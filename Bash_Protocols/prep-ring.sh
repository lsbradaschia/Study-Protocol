#!/bin/bash
#----------------------------------------------------------------------------------------------------------------
# SCRIPT DE CONVERSÃO DE ARQUIVO DE TRAJETÓRIA P/ PDB E POSTERIOR ANÁLISE COM RING
#----------------------------------------------------------------------------------------------------------------
# Recebe como entrada:
# - Arquivo de topologia (.tpr, .gro, .pdb, ...)
# - Arquivo de trajetória (.xtc, .trr, ...)
# Recomenda-se usar o script trjconv-preprocess.sh para pré-processar a trajetória, se necessário.
#----------------------------------------------------------------------------------------------------------------
# Realiza as seguintes etapas:
# 1) Converte um arquivo de trajetória para o formato .pdb usando o GROMACS (gmx trjconv).
# Seleção de grupo 1('Protein') output, considerando a proteína como alvo de interesse para converter a traj.
# 2) Cria um diretório dentro do diretório atual para armazenar os para posterior análise com o RING.
# Nome do diretório é baseada no PREFIXO_SAIDA fornecido.
# 3) Realiza a análise do RING a partir da trajetória convertida em .pdb anteriormente.
# 4) Gera arquivos de saída do RING no diretório criado.
#----------------------------------------------------------------------------------------------------------------
# Requisitos:
# - GROMACS instalado e configurado no PATH do sistema (ou com conda).
# - RING instalado e configurado no PATH do sistema. 
# - Permissões de execução para o script (chmod +x script.sh).
#----------------------------------------------------------------------------------------------------------------
# Autor: Laura Shimohara Bradaschia 
# Data: 2025-09-29
# ----------------------------------------------------------------------------------------------------------------
# Uso: ./prep-ring.sh <topology_file> <trajectory_file> <prefixo_saida>
# Exemplo: ./prep-ring.sh topol.tpr traj.xtc PTN1WT
# ------------------------------ Observações de Atualizações ao final do script ----------------------------------


# Verifica se o número de argumentos está correto
if [ "$#" -ne 3 ]; then
echo "ERRO. Número incorreto de argumentos."
echo "Uso: $0 <topology_file> <trajectory_file> <prefixo_saida>"
echo "Exemplo: $0 topol.tpr traj.xtc PTN1WT"
exit 1
fi
# Atribuição de argumentos de entrada a variáveis 

TOPOL_FILE="$1"
TRAJ_FILE="$2"
PREFIXO_SAIDA="$3"

#Define os nomes dos arquivos e diretórios de saída - arquivos intermediários
PDB_OUTPUT="${PREFIXO_SAIDA}_traj"
RING_DIR="${PREFIXO_SAIDA}_ring"

#==============================================================================
#------------------- Comando GROMACS para converter traj p/ PDB -----------------
#==============================================================================
echo "--------------------------------"
echo "Iniciando conversão de trajetória para PDB..."
echo "Topologia: ${TOPOL_FILE}"
echo "Trajetória: ${TRAJ_FILE}"
echo "Arquivo PDB de saída: ${PDB_OUTPUT}"

#Seleção de grupo 1 ('Protein') para output para seleção de proteína como alvo de interesse para conversão de trajetória.
echo 1 | gmx trjconv -s "$TOPOL_FILE" -f "$TRAJ_FILE" -o "$PDB_OUTPUT".pdb

#Verifica se o comando foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "Conversão concluída. Arquivo PDB salvo como ${PDB_OUTPUT}.pdb"
    echo "---------------------------------"
else
    echo "ERRO: Ocorreu um problema durante a conversão da trajetória para PDB. O script será encerrado."
    exit 1
fi

#------------------------------------------------------------------------------
#------------------ Execução e Análise com RING -------------------------------

echo "--------------------------------"
echo "Iniciando análise com RING..."
echo "Criando diretório para resultados do RING: ${RING_DIR}"

# Criar diretório para armazenar os resultados do RING
mkdir -p "$RING_DIR"

echo "Diretório ${RING_DIR} criado."
echo "Executando RING na trajetória PDB ${PDB_OUTPUT}.pdb..."

ring -i "${PDB_OUTPUT}.pdb" --all_edges --all_models --out_dir "$RING_DIR"

#Verifica se o comando foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "Análise com RING concluída. Resultados salvos em ${RING_DIR}"
    echo "---------------------------------"
    echo "Processo concluído com sucesso!"

else 
    echo "ERRO: Ocorreu um problema durante a execução do RING. Favor verifique os arquivos de entrada, ou se PDB gerado está correto. O script será encerrado."
    exit 1
fi

echo "Todos os cálculos foram concluídos. Verifique os arquivos de saída com o prefixo '${PREFIXO_SAIDA}' e resultados dentro do diretório ${RING_DIR}."
echo "---------------------------------"
# FIM DO SCRIPT