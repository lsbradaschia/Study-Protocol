#!/bin/bash

# ---------------------------------------------------------------------
# ESPECÍFICO PARA BIOEMU - DEFAULT FILES
# Script para cálculo de RMSD e RMSF usando GROMACS (gmx rms e gmx rmsf).
# Cálculo de RMSD contra estrutura query e contra estrutura representativa do cluster.
# Cálculo de RMSF em relação à estrutura query.
# Least Square Fit (RMSD) e Group for Output (RMSD e RMSD) selecionados como Backbone (4).
# Arquivos de entrada fixos: topology.pdb, samples.xtc, clustered_topology.pdb
# Verifica se o usuário forneceu um nome para o output.
# Uso: ./bioemu-df_rms.sh <prefixo_saida>
# Exemplo: ./bioemu-df_rms.sh PTN1WT
# Prefixo é adicionado no parâmetro de output (-o) dos comandos gmx rms e gmx rmsf.
# Após o prefixo é adicionado automaticamente o sufixo -ensembl-rmsd, -cluster-rmsd ou -rmsf.
# Requisitos: GROMACS instalado e ambiente ativado. Arquivos de entrada no diretório.
# Autor: Laura Shimohara Bradaschia
# Data: 2025-09-24
# ---------------------------------------------------------------------

#------Inputs fixos-------
PDB_TOPOL="topology.pdb"
PDB_CLUSTER_TOPOL="clustered_topology.pdb"
XTC_TRAJ="samples.xtc"


#------Verificação de argumentos de Entrada - verifica se o prefixo foi fornecido-------
# Se o primeiro argumento ($1) for nulo ("-z"), o script exibe uma mensagem de erro e sai.
if [ -z "$1" ]; then
    echo "ERRO: Você não especificou um prefixo para o arquivo de saída!"
    echo "Uso correto: $0 <prefixo_saida>"
    exit 1 # Sai do script com um código de erro
fi

# --- Input Editável (Argumento da Linha de Comando) - Prefixo de Output ----
PREFIXO_SAIDA=$1

#------Comando GROMACS para RMSD - EM RELAÇÃO A ESTRUTURA QUERY (-s topology.pdb)----------
echo "Calculando RMSD em relação à estrutura query..."
echo "  - Referência: ${PDB_TOPOL}"
echo "  - Trajetória: ${XTC_TRAJ}"
echo "  - Saída: ${PREFIXO_SAIDA}-rmsd.xvg"

# 'echo 4 |' seleciona o grupo de átomos para o cálculo (4 = Backbone), ajuste conforme necessário. (Recomendado para estruturas monomeras sem ligantes é Backbone ou C-alpha)
#Não utilizei -tu devido a não existencia de tempo na simulação do BioEmu. Alterável conforme orientação. 
echo 4 | gmx rms -s "$PDB_TOPOL" -f "$XTC_TRAJ" -o "${PREFIXO_SAIDA}-rmsd"

#Verifica se o comando foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "Cálculo de RMSD - EM RELAÇÃO A ESTRUTURA QUERY (-s topology.pdb) - finalizado com sucesso!"
    echo


    #=============================================================================
    #------Comandos executados APENAS se o RMSD anterior for bem-sucedido------
    #=============================================================================
    #---Comando GROMACS para RMSD - PARA ESTRUTURA REPRESENTATIVA DO CLUSTER (-s clustered_topology.pdb)----------
    echo "--------------------------------"
    echo "Calculando RMSD em relação à estrutura representativa do cluster..."
    echo "  - Referência: ${PDB_CLUSTER_TOPOL}"
    echo "  - Trajetória: ${XTC_TRAJ}"
    echo "  - Saída: ${PREFIXO_SAIDA}-cluster-rmsd.xvg"

    echo 4 | gmx rms -s "$PDB_CLUSTER_TOPOL" -f "$XTC_TRAJ" -o "${PREFIXO_SAIDA}-cluster-rmsd"

    #Verifica se o comando foi bem-sucedido
    if [ $? -eq 0 ]; then
        echo "Cálculo de RMSD - PARA ESTRUTURA REPRESENTATIVA DO CLUSTER (-s clustered_topology.pdb) - finalizado com sucesso!"
        echo "Arquivo de saída gerado: ${PREFIXO_SAIDA}-cluster-rmsd.xvg"
    else
        echo "ERRO: O cálculo de RMSD - PARA ESTRUTURA REPRESENTATIVA DO CLUSTER (-s clustered_topology.pdb) - falhou!"
        exit 1 # Sai do script com um código de erro
    fi

    #=============================================================================
    #-----------Comando GROMACS para RMSF (-s topology.pdb)----------
    #=============================================================================
    echo "--------------------------------"
    echo "Calculando RMSF..."
    echo "  - Referência: ${PDB_TOPOL}"
    echo "  - Trajetória: ${XTC_TRAJ}"
    echo "  - Saída: ${PREFIXO_SAIDA}-rmsf.xvg"

    echo 4 | gmx rmsf -s "$PDB_TOPOL" -f "$XTC_TRAJ" -o "${PREFIXO_SAIDA}-rmsf" -res

    #Verifica se o comando foi bem-sucedido
    if [ $? -eq 0 ]; then
        echo "Cálculo de RMSF finalizado com sucesso!"
        echo "---------------------------------"
        echo "Análises concluídas!"
    else
        echo "ERRO: Ocorreu um problema durante a execução do gmx rmsf."
        exit 1
    fi

else
    echo "ERRO: Ocorreu um problema durante a execução do gmx rms. O script será encerrado."
    exit 1
fi