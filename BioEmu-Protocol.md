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
ferramenta, optei por seguir a análise com o BioEmu com o padrão de **200** conformações pra ***3 PROTEÍNAS: 97JV-WT (G6PC1 nativa); P7JV-H176A e P7JV-R83C***. 

Usei meus 3 usuários/e-mails da google, onde abri uma aba do [Colab do BioEmu]() com cada uma das protéinas, onde levaram aproximadamente 30-40 minutos para serem completamente processadas
(opção Executar tudo no Google Colab). Vale ressaltar que não foi bastante demorado (considerando qualquer tipo de simulação de dinâmica molecular, a limitação fica voltada ao CPU
utilizado pra a análise. 

### Etapas e Outputs Gerados

#### "Write samples and run foldseek" 

O BioEmu gera n conformações (que você define) onde ele prediz estruturas da proteína emulando seu 'ensembl' termodinâmico (eles usam a distribuição Boltzmann, o suplementar do paper deles 
explica bastante coisa). 

Por default **estruturas fisico-quimicamente impossíveis de existir** são deletadas, então é bem comum o número de estruturas final não ser exatamente o número inicialmente proposto
(dá pra mudar isso, mas não era do interesse nesse caso). Essa etapa gera o primeiro output do BioEmu, que são: 

- **Arquivos `.pdb` individuais para cada uma das (n) conformações que foram preditas como parte do ensembl.** É gerada uma **pasta** chamada `pdb_samples` onde terão por volta de (no meu caso)
- 200 arquivos .pdb, exceto os que foram retirados por serem fisicamente impróprias. 

É a partir do `FoldSeek` que o BioEmu simula a trajetória da proteína. Ele utiliza da função de clusterização do FoldSeek pra agrupar estruturas similares, e a partir disso ele é
capaz de gerar 

