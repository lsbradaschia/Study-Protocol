# BioEmu - Processo e Análise dos dados

## Onde Encontrar e Como Rodar

Como o objetivo é testar a ferramenta, rodei sem conectar em nenhum servidor externo, usando apenas o colab notebook e o limite diário de utilização de CPU do mesmo. 

### Informações Gerais
[GitHub](https://github.com/microsoft/bioemu)


[Hugging Face](https://huggingface.co/microsoft/bioemu)


[PrePrint](https://www.biorxiv.org/content/10.1101/2024.12.05.626885v2)


[Paper Publicado - fechado](https://www.science.org/doi/abs/10.1126/science.adv9817)



A ferramenta oficial é feita pra rodar utilizando `pip install`em bash, apenas em Unix. Mas também tem a opção de utilizar diretamente em um [colab notebook](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/BioEmu.ipynb) disponível graças ao 
[ColabFold](https://github.com/sokrypton/ColabFold). 

Em outro momento, descrevo melhor quanto ao que se trata a fundo o BioEmu, vou focar aqui na metodologia em si que utilizei com a ferramenta. 

--- 

## BioEmu no Notebook do Colab 

Após alguns teste, consegui chegar num limiar de **200** conformações geradas pra proteína que estou utilizando pra estudo atualmente pro teste BATATA (G6PC1), onde um pouco mais de
200 conformações (entre 230), é suficiente pra esgotar todo o GPU disponível gratuitamente pelo Google Colab que pode ser usado diariamente. Como o objetivo é justamente testar a 
ferramenta, optei por seguir a análise com o BioEmu com o padrão de **200** conformações pra ***3 PROTEÍNAS: 97JV-WT (G6PC1 nativa); P7JV-H176A e P7JV-R83C*** (352aa, monômero). 

Usei meus 3 usuários/e-mails da google, onde abri uma aba do [Colab do BioEmu]() com cada uma das protéinas, onde levaram aproximadamente 30-40 minutos para serem completamente processadas
(opção Executar tudo no Google Colab). Vale ressaltar que não foi bastante demorado (considerando qualquer tipo de simulação de dinâmica molecular, a limitação fica voltada ao CPU
utilizado pra a análise. 

### Etapas e Outputs Gerados

#### "Write samples and run foldseek" 

O BioEmu gera n conformações (que você define) onde ele prediz estruturas da proteína emulando seu 'ensembl' termodinâmico (eles usam a distribuição Boltzmann, o suplementar do paper deles 
explica bastante coisa). 

Por default **estruturas fisico-quimicamente impossíveis de existir** são deletadas, então é bem comum o número de estruturas final não ser exatamente o número inicialmente proposto
(dá pra mudar isso, mas não era do interesse nesse caso). Essa etapa gera o primeiro output do BioEmu, que são: 

- **Arquivos `.pdb` individuais para cada uma das (n) conformações que foram preditas como parte do ensembl.** É gerada uma **pasta** chamada `pdb_samples` onde terão por volta de (no meu caso) 200 arquivos .pdb, exceto os que foram retirados por serem fisicamente impróprias.


Os arquivos .pdb são utilizados para posterior clusterização e simulação de trajetória. É a partir do `FoldSeek` que o BioEmu simula a trajetória da proteína. Ele utiliza da função de clusterização do FoldSeek pra agrupar estruturas similares (os pdbs previamente gerados), e então são gerados os arquivos de **TRAJETÓRIA** e arquivos de **TOPOLOGIA** associados. Um ponto a ressaltar é que, por default, a estrutura **representativa** de cada cluster gerado pelo FoldSeek é individualmente arquivada tanto em arquivos de trajetória quanto de topologia. Um arquivo `json` é gerado apontando quantos clusters foram gerados, e quais amostras pertencem a cada um deles. 

```bash
#Exemplo do arquivo .json aberto com um less no terminal

{"0": ["sample_0", "sample_1", "sample_10", "sample_100", "sample_101", "sample_102", "sample_103", "sample_104", "sample_105", "sample_106", "sample_107", "sample_108", 
"sample_109", "sample_11", "sample_110", "sample_111", "sample_112", "sample_113", "sample_114", "sample_115", "sample_116", "sample_117", "sample_118", "sample_119", 
"sample_12", "sample_120", "sample_121", "sample_122", "sample_123", "sample_124", "sample_125", "sample_126", "sample_127", "sample_128", "sample_129", "sample_13", 
"sample_130", "sample_131", "sample_132", "sample_133", "sample_134", "sample_135", "sample_136", "sample_137", "sample_138", "sample_139", "sample_14", "sample_140", 
"sample_141", "sample_142", "sample_143", "sample_144", "sample_145", "sample_146", "sample_147", "sample_148", "sample_149", "sample_15", "sample_150", "sample_151", 
"sample_152", "sample_153", "sample_154", "sample_155", "sample_156", "sample_157", "sample_158", "sample_159", "sample_16", "sample_160", "sample_161", "sample_162", 
"sample_163", "sample_164", "sample_165", "sample_166", "sample_167", "sample_168", "sample_169", "sample_17", "sample_170", "sample_171", "sample_172", "sample_173",
 "sample_174", "sample_175", "sample_176", "sample_177", "sample_178", "sample_179", "sample_18", "sample_180", "sample_181", "sample_182", "sample_183", "sample_184", 
 "sample_185", "sample_186", "sample_187", "sample_188", "sample_189", "sample_19", "sample_190", "sample_191", "sample_192", "sample_193", "sample_194", "sample_195", 
 "sample_196", "sample_197", "sample_2", "sample_20", "sample_21", "sample_22", "sample_23", "sample_24", "sample_25", "sample_26", "sample_27", "sample_28", "sample_29", 
 "sample_3", "sample_30", "sample_31", "sample_32", "sample_33", "sample_34", "sample_35", "sample_36", "sample_37", "sample_38", "sample_39", "sample_4", "sample_40", 
 "sample_41", "sample_42", "sample_43", "sample_44", "sample_45", "sample_46", "sample_47", "sample_48", "sample_49", "sample_5", "sample_50", "sample_51", "sample_52", 
 "sample_53", "sample_54", "sample_55", "sample_56", "sample_57", "sample_58", "sample_59", "sample_6", "sample_60", "sample_61", "sample_62", "sample_63", "sample_64", 
 "sample_65", "sample_66", "sample_67", "sample_68", "sample_69", "sample_7", "sample_70", "sample_71", "sample_72", "sample_73", "sample_74", "sample_75", "sample_76", 
 "sample_77", "sample_78", "sample_79", "sample_8", "sample_80", "sample_81", "sample_82", "sample_83", "sample_84", "sample_85", "sample_86", "sample_87", "sample_88", 
 "sample_89", "sample_9", "sample_90", "sample_91", "sample_92", "sample_93", "sample_94", "sample_95", "sample_96", "sample_97", "sample_98", "sample_99"]}

```


No caso de apenas 1 cluster gerado pelo FoldSeek (todas as suas estruturas pertencendo a um único ensembl, conforme o exemplo), apenas 1 estrutura será determinada como representante do cluster. Em casos de mais clusters, cada um terá 1 estrutura representante. 

### Diretórios Gerados e Formatos de Outputs

Explicando cada um dos Arquivos e Pastas que são gerados pelo BioEmu, 4 pastas serão geradas ao final da análise, sendo elas: 

```bash

├── /9J7V-WT #essa pasta eu que criei, considerem a partir do 9J7V_cc11a
│   ├──/9J7V_cc11a
│   ├──/cg_coefficients
│   └──/foldseek
│   └──/pdb_samples
└── 


```

#### PDB_SAMPLES

Conforme explicado anteriormente, o diretório pdb_samples contém todas as estruturas individuais em formato `.pdb`. Pelo colab, ela é nomeada de forma padrão. O diretório sempre tem como nome `pdb_samples`, e os arquivos com as estruturas no interior são nomeadas `sample_X.pdb`. 

Aqui um exemplo de organização do diretório

```bash

├── /pdb_samples
│   ├──sample_0.pdb 
│   ├──sample_1.pdb 
│   └──sample_2.pdb 
│   └──sample_3.pdb 
│   └── ...

```

Os diretórios do `foldseek` e `cg_coefficients` são diretórios de chamada de ferramentas para processamento da análise feita pelo BioEmu, e não possuem nenhum arquivo significativo. Já os diretórios `9J7V_cc11a` e `pdb_samples` vão conter os dados de trajetória, topologia e cada um dos arquivos .pdb gerados. 

#### TRAJETÓRIA E TOPOLOGIA

Os arquivos relacionados a dinâmica molecular estarão no diretório de nome escolhido por você, geralmente referenciando a amostra em que foi feita análise (no caso que uso de exemplo aqui, é 9J7V_cc11a). A interpretação dos formatos de arquivos foram retiradas do [benchmark do BioEmu](https://github.com/microsoft/bioemu-benchmarks/blob/main/README.md#usage), já que não encontrei uma documentação no preprint nem no GitHub do próprio BioEmu. 

**NOTA:** *Esse diretório vai ter uma penca de arquivos em formato `.npz`, gerados pelo numpy durante a análise. **Acredito eu** que eles não vão ser de muita utilidade, já que são uma espécie de array temporário pra viabilizar a análise com o foldseek (pelo que entendi do código), mas mantive eles por agora pra não acabar apagando algo que pode ser interessante de olhar mais pra frente.*

Mas conforme é explicado no `README.md`, no tópico `#usage` do benchmark, o BioEmu gera arquivos em formato `.xtc` para serem interpretados como `mdtraj.Trajectory` (trajetória). Além disso, todo `.xtc` obrigatoriamente é acompanhado por um arquivo de *topologia*. No caso do BioEmu, A topologia é definida por um arquivo em formato `.pdb` onde o nome do arquivo **contém obrigatoriamente topology** escrito, e **encontra-se no mesmo diretório**. 

O diretório se apresenta no seguinte padrão: 

```bash

├── /9J7V_cc11a
│   ├── foldseek_clusters.json
│   ├── sequence.fasta
│   ├── samples.xtc
│   ├── topology.pdb
│   ├── clustered_samples.xtc
│   ├── clustered_topology.pdb
│   ├── /hpacker-openmm/
│   ├── batch_0000000_0000001.npz
│   ├── batch_0000001_0000002.npz
│   └── ...
└── 


```

Uma explicação breve dos arquivos e seus significados: 

- `foldseek_clusters.json`: representado anteriormente, esse arquivo define quantos clusters foram formados pelo foldseek, e quais `samples` estão presente em cada um deles.
- `sequence.fasta`: arquivo fasta com a sequência da protéina query na qual se baseia a análise.
- `samples.xtc`: arquivo de *trajetória* referente a **todas as estruturas**, ou seja, referente ao ensemble da protéina query.
- `topology.pdb`: arquivo de *topologia* referente ao arquivo de trajetória `samples.xtc`. Traça a topologia padrão das estruturas do ensemble retratado na trajetória.
- `clustered_samples.xtc`: arquivo de *trajetória* referente a/as **estrutura(s) representante(s) do cluster(s)**. Apenas uma estrutura de cada cluster é armazenada; em caso de uniformidade - um cluster gerado - apenas uma estrutura é representada no arquivo.
- `clustered_topology.pdb`: arquivo de *topologia* referente a/as **estrutura(s) representante(s) do cluster(s)**. Em caso de uniformidade, esse arquivo será idêntico ao `topology.pdb`.
- `hpacker-openmm/`: esse diretório contém os dados de trajetória e topologia da etapa *opcional* do BioEmu de ` Reconstruct sidechains + Run MD relaxation`. Como é opcional, eu vou explicar depois de passar por todo o processo principal. 



**Para baixar as pastas do Colab Notebook pro seu drive**

Ainda no Colab Notebok do BioEmu, adicione duas abas de código com os seguintes scripts: 

```python
#Monte seu drive
from google.colab import drive
drive.mount('/content/drive')

```

```python
#Copie as pastas pro drive
!cp -r /content/[sua_amostra]_cc11a /content/drive/MyDrive/
!cp -r /content//pdb_samples /content/drive/MyDrive/

##Nota: Eu indico criar e direcionar esses arquivos pra uma pasta no drive, pra não se perderem lá dentro. Você vai precisar baixar alguns dos arquivos pro seu computador ou diretamento pro servidor posteriormente, então é interessante ter eles de fácil acesso.
##Nota2: NÃO FECHE o Google Colab assim que esse comando rodar, porque demora um tempo pra todos os arquivos serem copiados pro seu drive. ESPERE COPIAR TUDO, porque não vai sobrar CPU pra refazer a análise, e vai ter que esperar até o dia seguinte. Não queremos isso :') 
```
