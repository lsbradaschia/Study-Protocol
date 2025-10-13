# Otimização e Modularização do HufflePlots

As atualizações de processamento de arquivos `.xvg` do GROMACS e compilação de arquivos de interesse em `.csv` me fez refletir sobre como melhorar o entendimento do script como um todo para um usuário que queira entende-lo. **Modularização**
separa as etapas principais dos processos da ferramenta em diferentes arquivos `.py` armazenados no repositório, e acredito que vai ser útil para quando os outros alunos do laboratório precisarem fazer alterações na ferramenta, ou
puxar uma função específica para outra análise de dados. 

O modelo de estruturização de arquivos (sugerida pelo Gemini) para a Modularização será a seguinte, tentando seguir o padrão de pacotes Python: 
```bash
REPOSit/     #diretório raiz
├── assets/ #Arquivos estáticos
│   └── Logolog.png
├── example_files/ 
│   └── sample_data.csv  # Arquivo de dados de exemplo
├── reposit/ #Seria o pacote Python em si, código-fonte recomendado nesse diretório 
│   ├── __init__.py #arquivo vazio pra sinalização de diretório 
│   ├── analyses/ #Sub-módulo com .py de cada tab
│   │   ├── __init__.py
│   │   ├── analysis_one.py
│   │   ├── analysis_two.py
│   │   └── analysis_three.py
│   └── utils/ #Sub-Módulo pra códigos compartilahdos. Interessante colocar Todas as funções aqui.
│       ├── __init__.py
│       └── helpers.py
├── PotPot.py #def main(). Orquestra o st
└── requirements.txt #dependências do projeto
```


Adaptando para o repositório do HufflePlots: 

```bash
ProtPlots/     #diretório raiz
├── assets/ #Arquivos estáticos
│   └── HufflePlots.png
├── example_files/ 
│   └── sample_data.csv  # Arquivo de dados de exemplo
├── reposit/ #Seria o pacote Python em si, código-fonte recomendado nesse diretório 
│   ├── __init__.py #arquivo vazio pra sinalização de diretório 
│   ├── analyses/ #Sub-módulo com .py de cada tab
│   │   ├── __init__.py
│   │   ├── xvg_process.py #tab1
│   │   ├── csv_compile.py #tab2
│   │   └── plots.py #tab3
│   └── utils/ #Sub-Módulo pra códigos compartilahdos. Interessante colocar Todas as funções aqui.
│       ├── __init__.py
│       └── helpers.py #No sei se precisará
├── ProtPlots.py #def main(). #Orquestra o st
└── requirements.txt #dependências do projeto

```
