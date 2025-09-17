# Comandos para uso de CONDA 

Comandos úteis que usei no início quando comecei a usar conda. 


conda env list 
## Boas Práticas CONDA - CRIAR AMBIENTES PARA FERRAMENTAS

É importante criar ambientes separados para cada ferramenta de uso, pra que não ocorra crash. O conda permite que se instale a ferramenta em um ambiente completamente isolado, não tendo problema de compatibilidade de requisitos de instalação tanto com o computador local ou servidor utilizado.
```bash
#criando um ambiente conda
##caso conda não esteja ativado, ative

conda activate

#crie um ambiente específico pra ferramenta
conda create -n 'nome da ferramenta' 
#ex: conda create -n minimap2

#Lista de todos os ambientes criados no conda (bom pra relembrar o nome do ambiente de alguma ferramenta)
conda env list

```

## Acessando ambientes e instalando ferramentas

Entrar no ambiente 

conda activete nomedoambiente

- instalar a ferramenta dentro do ambiente criado:

conda install -c bioconda/conda 'nome da ferramenta'
ex: conda install -c bioconda minimap2 
    minimap2 (rodar a ferramenta) 

- desativar o ambiente

conda deactivate 

- caso queira deletar um ambiente e pacotes relacionados: 
conda remove -n <nomedoambiente> --all
ex: conda remove -n minimap2 	--all 
