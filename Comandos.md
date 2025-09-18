# Comandos e Tutoriais 

## UNIX

### Utilizando Ferramenta a partir de arquivo no VSCode uasndo Git Bash
***NOTA:*** É possível rodar a ferramenta no seu computador usando o Git Bash, **MAS** a ferramenta tem que ter uma formatação compatível/ou alguma forma de construção/manutenção da ferramenta que permita que ela seja utilizada em dependências Windows. Se ela for única e exclusivamente LINUX, é necessário acessar um servidor Linux ou ter um Dual Boot pra rodar. 


#### 1. Abrir Local de Arquivo de Interesse
Ctrl K + Ctrl O

**NOTA:** É interessante que a pasta/diretório aberta como local de arquivo no VSCode tenha os arquivos de interesse, sejam eles o próprio arquivo zipado do RING quanto os inputs de interesse para a ferramenta.

#### 2. Conectar ao seu próprio PC usando Git Bash
Ctrl + Shit + P -> Escolha a opção "Create new Terminal (With Profile)"; seguido de "Git Bash" 

Utilizar o Git Bash permite que você utilize comandos UNIX mesmo que o seu computador seja Windows, dentro do VSCode. É um espécie de dual boot sem a necessidade de baixar o dual boot do Windows. 

#### 3. Descompactando o arquivo da ferramenta

```bash

tar -xzvf ring-4.0.tgz #caso esteja já no diretório onde se encontrao o arquivo

#Fora do diretório

tar -xzvf /caminho/para/o/diretório/ferramenta.tgz

#Entre no diretório descompactado

cd ring-4.0

```
#### 4.Acesso Simplicado a ferramenta utilizando PATH

```bash

#Acesse o diretório onde se encontra o executável da ferramenta (geralmente no /bin)
cd ~/ring-4.0/ring-4.0/out/bin

#Caminho absoluto até o diretório /bin
pwd

#Edição do arquivo de configuração shell (.bashrc)
nano ~/.bashrc
## Isso vai abrir uma espécie de notas editável, que pode ser executado. arquivos salvos em nano tem o final '.sh', e podem carregar scripts completos.

#Chamada da ferramenta: escrever no bash editável

export PATH=$PATH://d/Usuários/Público/Documentos Públicos/Academico/PPG_Bioinfo/masters/Batata/ring-4.0/ring-4.0/out/bin

```

Para salvar o comando em bash, escreva **CTRL+O**, depois **CTRL+X**. 


---

### Instalação de Conda no Servidor (a partir do .sh do MiniConda) 

```bash
#Baixar o bash apropriado do Miniconda para o servidor
##Usando wget:
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

#Rodar o script bash do Miniconda

bash Miniconda3-latest-Linux-x86_64.sh

##NOTA: Se for em servidor de acesso de mais pessoas, baixe e instale o miniconda NO SEU DIRETÓRIO. NÃO INSTALE NA HOME ou em qualquer outro diretório antes do seu diretório. Durante a instalação, será perguntando e sugerido a criação de um diretório miniconda dentro do diretório atual em que está sendo instalado para que a mesma seja finalizada. Se atente ao diretório em que está fazendo a instalação.

##NOTA2: Caso queira a ativação automática do conda ao acessar o servidor, selecione **YES** na última seleção durante a instalação se tratando de activate/deactivate. Ele irá escrever no bash base do seu diretório (no meu caso, bashrc) uma especificação para ativação do conda automática. Caso queira ativar isso assim que instalar, use o seguinte comando:

source ./bashrc #ou o seu código fonte do diretório




```

---

## Python

### Salvar output completo do BioEmu no drive

Após a análise de BioEmu ser completa, abra uma nova aba de código e conecto o seu ambiente do drive:
```python

from google.colab import drive
drive.mount('/content/drive')

```

Após conectado, use `!cp` para copiar os diretórios de interesse para uma pasta do drive
```python
# -r para copiar a pasta e todo o seu conteúdo
# /content/sua_pasta é a origem
# /content/drive/MyDrive/ é o destino (raiz do seu "Meu Drive")
# Você pode especificar uma subpasta, ex: /content/drive/MyDrive/Colab_Outputs/
!cp -r /content/sua_pasta /content/drive/MyDrive/

```
