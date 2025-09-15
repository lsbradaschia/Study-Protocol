# Comandos e Tutoriais 

## UNIX

### Utilizando RING 4.0 a partir de (.tgz) em computador Windows usando VSCode e Git Bash

#### 1. Abrir Local de Arquivo de Interesse
Ctrl K + Ctrl O

**NOTA:** É interessante que a pasta/diretório aberta como local de arquivo no VSCode tenha os arquivos de interesse, sejam eles o próprio arquivo zipado do RING quanto os inputs de interesse para a ferramenta.

#### 2. Conectar ao seu próprio PC usando Git Bash
Ctrl + Shit + P -> Escolha a opção "Create new Terminal (With Profile)"; seguido de "Git Bash" 

Utilizar o Git Bash permite que você utilize comandos UNIX mesmo que o seu computador seja Windows, dentro do VSCode. É um espécie de dual boot sem a necessidade de baixar o dual boot do Windows. 

#### 3. Descompactando o arquivo RING

```bash

tar -xzvf ring-4.0.tgz #caso esteja já no diretório onde se encontrao o arquivo

#Fora do diretório

tar -xzvf /caminho/para/o/diretório/ring-4.0.tgz

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
