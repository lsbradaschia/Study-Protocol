#!/bin/bash

# ----------------------------------------------------------------------------------------------------
# ESPECÍFICO PARA PROCESSAMENTO DE OUTPUT DO BIOEMU - MD RELAXATION EQUIL & SIDE CHAIN RECONSTRUCTION.
# Até o momento apenas foi feito o MD RELAX com LOCAL MINIMIZATION, não NVT_EQUIL.
# Script para cálculo de RMSD e RMSF usando GROMACS (gmx rms e gmx rmsf).
# Cálculo de RMSD do ensemble de estruturas relaxadas com MD_PROTOCOL - LOCAL MIN.
# Cálculo de RMSD do ensemble de estruturas com RECONSTRUÇÃO DE CADEIA LATERAL (via hpacker)
# Cálculo de RMSF de ambos os ensembles.
# Least Square Fit (RMSD) e Group for Output (RMSD e RMSD) selecionados como Backbone (4).
# Arquivos de entrada fixos para MD RELAXATION: hpacker-openmm_md_equil.pdb , hpacker-openmm_md_equil.xtc
# Arquivos de entrada fixos para SIDE CHAIN RECONSTRUCTION: hpacker-openmm_sidechain_rec.pdb , hpacker-openmm_sidechain_rec.xtc
# Verifica se o usuário forneceu um nome para o output.
# Uso: ./bioemu-hpacker_rms.sh <prefixo_saida>
# Exemplo: ./bioemu-hpacker_rms.sh PTN1WT
# Prefixo é adicionado no parâmetro de output (-o) dos comandos gmx rms e gmx rmsf.
# Após o prefixo é adicionado automaticamente o sufixo -md_local-rmsd, -sc_rec-rmsd, -md_local-rmsf e -sc_rec-rmsf.
# Autor: Laura Shimohara Bradaschia
# Data: 2025-09-24
# ---------------------------------------------------------------------

#-----------------REQUISITOS-------------------------------------------
# GROMACS instalado e ambiente ativado. Arquivos de entrada no diretório.


#------Inputs fixos __ MD_PROTOCOL/LOCAL_MINIMIZATION-------
PDB_MD_EQUIL="hpacker-openmm_md_equil.pdb"
MD_TRAJ="hpacker-openmm_md_equil.xtc"
#------Inputs fixos __SIDE CHAIN RECONSTRUCTION-------
PDB_SC_REC="hpacker-openmm_sidechain_rec.pdb"
SC_REC_TRAJ="hpacker-openmm_sidechain_rec.xtc"


#------Verificação de argumentos de Entrada - verifica se o prefixo foi fornecido-------
# Se o primeiro argumento ($1) for nulo ("-z"), o script exibe uma mensagem de erro e sai.
if [ -z "$1" ]; then
    echo "ERRO: Você não especificou um prefixo para o arquivo de saída!"
    echo "Uso correto: $0 <prefixo_saida>"
    exit 1 # Sai do script com um código de erro
fi

# --- Input Editável (Argumento da Linha de Comando) - Prefixo de Output ----
PREFIXO_SAIDA=$1

#------Comando GROMACS para RMSD - MD_PROTOCOL/LOCAL_MINIMIZATION----------
echo "Calculando RMSD para estruturas relaxadas com MD_PROTOCOL - LOCAL_MINIMIZATION..."
echo "  - Referência: ${PDB_MD_EQUIL}"
echo "  - Trajetória: ${MD_TRAJ}"
echo "  - Saída: ${PREFIXO_SAIDA}-md_local-rmsd.xvg"

# 'EOF 4 |' seleciona o grupo de átomos para o cálculo (4 = Backbone), ajuste conforme necessário. (Recomendado para estruturas monomeras sem ligantes é Backbone ou C-alpha)
#Não utilizei -tu devido a não existencia de tempo na simulação do BioEmu. Alterável conforme orientação. 
gmx rms -s "$PDB_MD_EQUIL" -f "$MD_TRAJ" -o "${PREFIXO_SAIDA}-md_local-rmsd" <<EOF
4
4
EOF

#Verifica se o comando foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "Cálculo de RMSD - MD_PROTOCOL/LOCAL_MINIMIZATION - finalizado com sucesso!"
    echo

    #=============================================================================
    #------Comandos executados APENAS se o RMSD anterior for bem-sucedido------
    #=============================================================================
    #---Comando GROMACS para RMSD - SIDE CHAIN RECONSTRUCTION ----------
    echo "--------------------------------"
    echo "Calculando RMSD com protocolo de RECONSTRUÇÃO DE CADEIAS LATERAIS..."
    echo "  - Referência: ${PDB_SC_REC}"
    echo "  - Trajetória: ${SC_REC_TRAJ}"
    echo "  - Saída: ${PREFIXO_SAIDA}-sc_rec-rmsd.xvg"

gmx rms -s "$PDB_SC_REC" -f "$SC_REC_TRAJ" -o "${PREFIXO_SAIDA}-sc_rec-rmsd" <<EOF
4
4
EOF

    #Verifica se o comando foi bem-sucedido
    if [ $? -eq 0 ]; then
        echo "Cálculo de RMSD - SIDE CHAIN RECONSTRUCTION - finalizado com sucesso!"
        echo "Arquivo de saída gerado: ${PREFIXO_SAIDA}-sc_rec-rmsd.xvg"
    else
        echo "ERRO: O cálculo de RMSD - SIDE CHAIN RECONSTRUCTION - falhou!"
        exit 1 # Sai do script com um código de erro
    fi

    #=============================================================================
    #-----------Comando GROMACS para RMSF - MD_PROTOCOL/LOCAL_MINIMIZATION--------
    #=============================================================================
    echo "--------------------------------"
    echo "Calculando RMSF para MD_PROTOCOL/LOCAL_MINIMIZATION..."
    echo "  - Referência: ${PDB_MD_EQUIL}"
    echo "  - Trajetória: ${MD_TRAJ}"
    echo "  - Saída: ${PREFIXO_SAIDA}-md_local-rmsf.xvg"

    echo 4 | gmx rmsf -s "$PDB_MD_EQUIL" -f "$MD_TRAJ" -o "${PREFIXO_SAIDA}-md_local-rmsf" -res

    #Verifica se o comando foi bem-sucedido
    if [ $? -eq 0 ]; then
        echo "Cálculo de RMSF - MD_PROTOCOL/LOCAL_MINIMIZATION - finalizado com sucesso!"
        echo "Arquivo de saída gerado: ${PREFIXO_SAIDA}-md_local-rmsf.xvg"
    else
        echo "ERRO: O cálculo de RMSF - MD_PROTOCOL/LOCAL_MINIMIZATION - falhou!"
        exit 1 # Sai do script com um código de erro
    fi

    #=============================================================================
    #-----------Comando GROMACS para RMSF - SIDE CHAIN RECONSTRUCTION--------
    #=============================================================================
    echo "--------------------------------"
    echo "Calculando RMSF para SIDE CHAIN RECONSTRUCTION..."
    echo "  - Referência: ${PDB_SC_REC}"
    echo "  - Trajetória: ${SC_REC_TRAJ}"
    echo "  - Saída: ${PREFIXO_SAIDA}-sc_rec-rmsf.xvg"

    echo 4 | gmx rmsf -s "$PDB_SC_REC" -f "$SC_REC_TRAJ" -o "${PREFIXO_SAIDA}-sc_rec-rmsf" -res

        #Verifica se o comando foi bem-sucedido
    if [ $? -eq 0 ]; then
        echo "Cálculo de RMSF - SIDE CHAIN RECONSTRUCTION - finalizado com sucesso!"
        echo "---------------------------------"
        echo "Análises concluídas!"
    else
        echo "ERRO: Ocorreu um problema durante a execução do gmx rmsf."
        exit 1
    fi

else
    echo "ERRO: Ocorreu um problema durante a execução do gmx rms. Não é possível continuar o script."
    exit 1
fi