#!/bin/bash
#----------------------------------------------------------------------------------------------------------------
# SCRIPT DE INPUT CONDICIONAL PARA ANÁLISE DE RMSD, RMSF E Rg COM GROMACS - COM PRÉ-PROCESSAMENTO DE TRAJETÓRIA.
#----------------------------------------------------------------------------------------------------------------
# MODO PRESET: Usa inputs fixos de MD e Equilibrum gerado pelo BIOEMU e inputs fixos de Side Chain Reconstruction.
#              Definição do modo utilizando palavra-chave 'hpacker' na linha de comando como primeiro argumento.
#              Arquivos de entrada únicos na pasta de execução do script. (Recomenda-se clonar a propria pasta hpacker_openmm)
#
# INPUTS FIXOS: hpacker-openmm_md_equil.pdb, hpacker-openmm_md_equil.xtc, hpacker-openmm_sidechain_rec.pdb,
#               hpacker-openmm_sidechain_rec.xtc
#
#            Uso: ./gmx-rms_gyr.sh hpacker <prefixo_saida>
#            Exemplo: ./gmx-rms_gyr.sh hpacker PTN1WT
#----------------------------------------------------------------------------------------------------------------
# MODO MANUAL: Sem utilização da palavra-chave 'hpacker' na linha de comando, usuário fornece todos os inputs.
#              Processa de 2 a 4 amostras (sendo necessário no mínimo 1 arquivo de topologia e 1 de trajetória).
#              No caso de 4 amostras, É necessário que o usuário forneça os 4 arquivos E A ASSOCIAÇÃO ENTRE ELES.
#
#            Uso: ./gmx-rms_gyr.sh <topology> <sample> <prefixo_saida>
#            Exemplo (1 par): ./gmx-rms_gyr.sh topol.pdb traj.xtc PTN1WT
#            Exemplo (2 pares): ./gmx-rms_gyr.sh topol1.pdb traj1.xtc topol2.pdb traj2.xtc PTN1WT_DOIS
#                                Assiciação de topol e xtc é feita pela ordem dos argumentos, logo topol1 com traj1 e topol2 com traj2.
#----------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------
# EXPLICAÇÃO GERAL DO SCRIPT
# ---------------------------------------------------------------------------------------------------------------
# Pré-processamento da trajetória com gmx trjconv (-pbc whole -center)
# Cálculo de RMSD e RMSF usando GROMACS (gmx rms e gmx rmsf) e Radio de Giração (Rg) usando GROMACS (gmx gyrate).
# Least Square Fit (RMSD) e Group for Output (RMSD e RMSF) selecionados como Backbone (4).
# RMSD/RMSF/Rg MODO PRESET de estruturas relaxadas com MD_PROTOCOL - LOCAL MINIMIZATION (via hpacker).
# Até o momento apenas foi feito o MD RELAX com LOCAL MINIMIZATION, não NVT_EQUIL (via hpacker).
# RMSD/RMSF/Rg MODO PRESET de estruturas com RECONSTRUÇÃO DE CADEIA LATERAL (via hpacker)
# Verifica se o usuário forneceu um nome para o output.
# Prefixo é adicionado no parâmetro de output (-o) dos comandos gmx rms e gmx rmsf e gmx gyrate.
# Após o prefixo é adicionado automaticamente o sufixo -rmsd, -rmsf, -rg.
# Autor: Laura Shimohara Bradaschia
# Data: 2025-09-24
# Revisão: 2025-09-29
# ---------------------------------------------------------------------
#-----------------REQUISITOS-------------------------------------------
# GROMACS instalado e ambiente ativado. Arquivos de entrada no diretório. Preferencialmente apenas os arquivos necessários.
# Arquivos duplicados ou semelhantes podem causar erros.
# ----------------------------------------------------------------------------------------------------------------
# Observações de atualizações ao final do script.
# ----------------------------------------------------------------------------------------------------------------

# -------- FUNÇÃO DE AJUDA --------------------------------------------------------------
usage() {
    echo "Uso Incorreto! Verifique os arquivos e argumentos fornecidos."
    echo "MODO PRESET: $0 hpacker <prefixo_geral_saida>"
    echo "MODO MANUAL: $0 <topo1> <traj1> [<topo2> <traj2> ...] <prefixo_geral_saida>"
    exit 1
}

# --- VERIFICAÇÃO INICIAL DE ARGUMENTOS ---
if [ "$#" -lt 2 ]; then
    usage
fi

# --- ARRAYS PARA ARMAZENAR OS ARQUIVOS DE ENTRADA ---
declare -a TOPOL
declare -a TRAJ
declare -a PREFIXO_BASE

# --- LÓGICA CONDICIONAL PARA MODO PRESET OU MANUAL --------------------------------------------------------------

# Verifica se o primeiro argumento é a palavra-chave "hpacker"
if [ "$1" == "hpacker" ]; then
    # --- MODO PRESET ---
    echo "== MODO PRESET 'hpacker' ATIVADO =="

    # Verifica se o número de argumentos está correto para este modo (preset + prefixo)
    if [ "$#" -ne 2 ]; then
    usage;
    fi

    #----------------------------------- Inputs Fixos MODO PRESET - HPACKER -----------------------------------------
    #----------------------------------Inputs fixos __ MD_PROTOCOL/SIDE CHAIN RECONSTRUCTION -------------------------------
    TOPOL=("hpacker-openmm_md_equil.pdb"
            "hpacker-openmm_sidechain_rec.pdb")
    TRAJ=("hpacker-openmm_md_equil.xtc"
          "hpacker-openmm_sidechain_rec.xtc")

    #Prefixos curtos para diferenciar as saídas
    PREFIXO_BASE=("md_local"
                 "sc_rec")

    #Prefixo de saída é o segundo argumento 
    PREFIXO_SAIDA="$2"

    echo "MODO PRESET SELECIONADO. Usando inputs fixos para simulação de MD e Reconstrução BioEmu com Hpacker (topology.pdb e samples.xtc)."
    echo " - Topologia: ${TOPOL[@]}"
    echo "  - Trajetória: ${TRAJ[@]}"

# -----------------------------------------------------------------------------------------------------------------------------
# -------------------------------- MODO MANUAL - de 2 a 4 arquivos (correlacionar topologia e trajetória) ------------------------------------
# -----------------------------------------------------------------------------------------------------------------------------

else
    # -------------------------------- MODO MANUAL - de 2 a 4 arquivos (correlacionar topologia e trajetória) ------------------------------------
    echo "== MODO MANUAL ATIVADO =="
    # Verifica se o número de argumentos está correto para este modo (total -1 deve ser par, contando o -1 do prefixo)
    if (( ($# - 1) % 2 != 0 )) || [ "$#" -lt 3 ]; then
        echo "ERRO: No modo manual, forneça pares de topologia/trajetória e um prefixo de saída no final."
        usage
    fi

    # Loop para processar os pares de argumentos
    while (( "$#" > 1 )); do
      TOPO_ATUAL="$1"
      TOPOL+=("$TOPO_ATUAL") # Adiciona o primeiro argumento ao array de topologias
      TRAJ+=("$2") # Adiciona o segundo ao array de trajetórias
      
      # Cria e nomeia arquivos para PREFIXO_BASE com base no nome original de cada arquivo de topologia
      NOME_ARQUIVO=$(basename -- "${TOPO_ATUAL}") # Remove o caminho e a extensão .pdb
      PREFIXO_BASE+=("${NOME_ARQUIVO%.*}") # Remove a extensão e adiciona ao array de nomes base

      shift 2              # Associa os dois argumentos e remove-os da lista, avançando para os próximos (caso existam)
    done

    # O que sobrar como $1 será o prefixo de saída
    PREFIXO_SAIDA="$1"
fi

#========================= LOOP DE PROCESSAMENTO - ASSOCIAÇÃO DE TOPOLOGIA E TRAJETÓRIA ==========================
# Itera cada par de topologia e trajetória definido
# Análises ocorrem dentro do loop.
# ==============================================================================================================
echo "-------------------------"
echo "Iniciando processamento de pareamento de arquivos topologia /trajetória"

for i in "${!TOPOL[@]}"; do
    TOPO_ATUAL="${TOPOL[$i]}"
    TRAJ_ATUAL="${TRAJ[$i]}"
    PREFIXO_ATUAL="${PREFIXO_BASE[$i]}"

    echo "================================================================="
    echo "Processando Par $((i+1)): ${TOPO_ATUAL}/${TRAJ_ATUAL}"
    echo "================================================================="
    echo "Prefixo de saída geral: ${PREFIXO_ATUAL}"

    # --- VERIFICAÇÃO DOS ARQUIVOS ---
    if [ ! -f "${TOPO_ATUAL}" ] || [ ! -f "${TRAJ_ATUAL}" ]; then
        echo "AVISO: Arquivos para o par $((i+1)) não encontrados. Pulando..."
        continue # Pula para a próxima iteração do loop
    fi


    #======================================================================================================
    #------------------------ ETAPA DE PRÉ-PROCESSAMENTO DA TRAJETÓRIA ----------------------------------------
    #======================================================================================================

    # --- Definição dos Nomes de Arquivos Intermediários e Finais ---
    TRAJ_PROCESSADA="${PREFIXO_SAIDA}_${PREFIXO_ATUAL}_pbc"
    echo "--------------------------------"
    echo "Etapa de CORREÇÃO PERIÓDICA da trajetória (centralização e correção PBC)..."
    echo "  - Referência: ${TOPO_ATUAL}"
    echo "  - Trajetória: ${TRAJ_ATUAL}"
    echo "  - Saída: ${TRAJ_PROCESSADA}.xtc"

    # Comando para centralizar a proteína (grupo 1) e corrigir a caixa, 
    # salvando o resultado no arquivo definido pela variável $TRAJ_PROCESSADA.
    gmx trjconv -s ${TOPO_ATUAL} -f ${TRAJ_ATUAL} -o ${TRAJ_PROCESSADA} -pbc whole -center <<EOF
1
0
EOF

    # Verifica se o comando foi bem-sucedido
    if [ $? -ne 0 ]; then echo "ERRO no trjconv. Pulando este par."
        continue
    else 
        echo "Correção periódica da trajetória concluída com sucesso!"
        echo "Arquivo de saída gerado: ${TRAJ_PROCESSADA}.xtc"
     fi

    #======================================================================================================
    #------------------------ ETAPA DE ANÁLISE DE RMSD, RMSF E Rg ----------------------------------------
    #======================================================================================================

    # ------------------------- ANÁLISE DE RMSD ---------------------------------------
    echo "--------------------------------"
    echo "Etapa de Cálculo de RMSD..."
    echo "  - Referência: ${TOPO_ATUAL}"
    echo "  - Trajetória: ${TRAJ_PROCESSADA}"
    echo "  - Saída: ${PREFIXO_SAIDA}-${PREFIXO_ATUAL}-rmsd.xvg"

    # 'EOF 4|' seleciona o grupo de átomos para o cálculo (4 = Backbone), ajuste conforme necessário. (Recomendado para estruturas monomeras sem ligantes é Backbone ou C-alpha)
    #Não utilizei -tu devido a não existencia de tempo e campo de força na simulação do BioEmu. Alterável conforme orientação ou tipo de análise.
    gmx rms -s "$TOPO_ATUAL" -f "$TRAJ_PROCESSADA" -o "${PREFIXO_SAIDA}-${PREFIXO_ATUAL}-rmsd" <<EOF
4
4
EOF
    #Verifica se o comando foi bem-sucedido
    if [ $? -eq 0 ]; then
    echo "Cálculo de RMSD - EM RELAÇÃO A ESTRUTURA QUERY (-s topology.pdb) - finalizado com sucesso!"
    else 
        echo "ERRO: Ocorreu um problema durante a execução do gmx rms."
    fi

    # ------------------------- ANÁLISE DE RMSF ---------------------------------------
    echo "--------------------------------"
    echo "Etapa de Cálculo RMSF..."
    echo "  - Referência: ${TOPO_ATUAL}"
    echo "  - Trajetória: ${TRAJ_PROCESSADA}"
    echo "  - Saída: ${PREFIXO_SAIDA}-${PREFIXO_ATUAL}-rmsf.xvg"

    echo 4 | gmx rmsf -s "$TOPO_ATUAL" -f "$TRAJ_PROCESSADA" -o "${PREFIXO_SAIDA}-${PREFIXO_ATUAL}-rmsf" -res

    #Verifica se o comando foi bem-sucedido
    if [ $? -eq 0 ]; then
        echo "Cálculo de RMSF finalizado com sucesso!"
        echo "---------------------------------"
        echo "Análises concluídas!"
    else
        echo "ERRO: Ocorreu um problema durante a execução do gmx rmsf."
    fi

    # ------------------------- ANÁLISE DE Rg ---------------------------------------
    echo "--------------------------------"
    echo "Etapa de Cálculo do Raio de Giração (Rg)..."
    echo "  - Referência: ${TOPO_ATUAL}"
    echo "  - Trajetória: ${TRAJ_PROCESSADA}"
    echo "  - Saída: ${PREFIXO_SAIDA}-${PREFIXO_ATUAL}-rg.xvg"

    gmx gyrate -s "$TOPO_ATUAL" -f "$TRAJ_PROCESSADA" -o "${PREFIXO_SAIDA}-${PREFIXO_ATUAL}-rg" -sel Protein

    #Verifica se o comando foi bem-sucedido
    if [ $? -eq 0 ]; then
        echo "Cálculo de Radio de Giração (Rg) finalizado com sucesso!"
        echo "---------------------------------"
        echo "Análises concluídas!"
    else
        echo "ERRO: Ocorreu um problema durante a execução do gmx gyrate."
    fi

done
echo "Todos os cálculos foram concluídos. Verifique os arquivos de saída com o prefixo '${PREFIXO_SAIDA}'."
echo "---------------------------------"

#FIM DO SCRIPT
# ------------------------------ Observações de Atualizações ---------------------------------------------------
#NOTA: A correção foi incluida dia 25/09/2025 seguindo tutorial do GROMACS. Script e dados gerados
# antes da correção serão comparados para avaliar impacto.
#NOTA2: Retirando tudo relacionado a CLUSTER, pois todas as análises geraram um cluster, logo identico ao topology.pdb
# Att 29/09/2025: Generalização do script para uso manual ou preset (palavra-chave hpacker). Retirada de cluster e separação do script com pré-processamento.
# Adição da Análise de Rg. ESSE É O SCRIPT COM PRÉ-PROCESSAMENTO DE TRAJETÓRIA. MODO MANUAL analisa outputs com SIMULAÇÃO DE MD do BioEmu.