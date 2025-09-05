# Study-Protocol: SlytheRINs

# SlytheRINs - de Projeto à Publicação
## Entrada 14/11/2024 

**14/11/2024** - Reunião João Paulo e Matheus

**SlytheRINs:** Processamento e Análise de arquivos derivados de RING para RIN x Dinâmica Molecular

**GriffindoRRBPs:** Meu mestrado. Datamining de proteínas no Modomics (16/10/2024) - *anexar os cadernos python depois*
- Filtragem de proteínas PDB por family e domínio (CDD)
- [Paper Gene Yeo](https://www.cell.com/molecular-cell/fulltext/S1097-2765(20)30159-3)
- Referência de banco de dados e integração com CarinDB
- Busca de Database independente do RING
- **Estudo de Casos:** RBPs(Modomics e solúveis); metiltransferase; ortólogos abrangentes; abrangência de taxonômicos (ou existente em taxon bem limitado); estrutura no AlphaFoldDB.
- Sugestão de Pacotes Dalmolin para auxílio: [GenePlast]([https://www.bioconductor.org/packages/release/bioc/html/geneplast.html) e [GeneBridge](https://dalmolingroup.github.io/genebridge-course/analysis/)

---

## Entrada 15/04/2025 

**15/04/2025:** Informações gerais de dados de input/output do SlytheRINs 

**NMSIM:** Online, gera 500 conformações a partir de um pdb (estático). Output: arquivo `PDB` contendo informações sobre todas as 500 conformações simuladas. Utilizado como input para *RING*. 

**RING:** Gera Redes de Interação entre Resíduos da Proteína para todas as conformações a partir do arquivo `PDB` gerado pelo NMSIM. *CHIMERA/VMD* pode permitir a visualização das conformações. Output: `edges.txt` e `nodes.txt` 

[Chimera](https://www.cgl.ucsf.edu/chimera/)
[VMD](https://www.ks.uiuc.edu/Research/vmd/)

*NOTA:* Dentro dos arquivos `.txt`gerados pelo RING, existem 'blocos' separados por 'MODEL', que indicam as interações/nós/arestas de cada uma das conformações. 

**TAREFA:** [X] Limpar o pré-processamento do SlytheRINS para receber apenas arestas(edges) do RING.

---

## Entrada 24/04/2025 - Dúvidas quanto SlytheRINs 

1. File Uploader: `st_file_uploader` cria um diretório? (sim)
2. Formas de input aceitas pelo SlytheRINs: `.zip` e `.txt`
3. Benchmarking ideal de conformações para SlytheRINs? *500 conformações pra cima*
   - Ou a partir do NMSIM, ponto de estabilização da proteína (RMSD, intervalo na trajetória);
4. **HufflePlots:** `RMSD` e `RMSF` do NMSIM ou dados de Trajetória (Dinâmica Molecular);

**Huffleplots** -> input NMSIM; Análise e output de restrição de intervalos (reduzir Models para análise) 
**SlytheRINs** -> RING + DM 

**PARA O MESTRADO E X-MEETING:**
- Objetivos Gerais do *HufflePlots* e *SlytheRINs*;
- Dinâmica/Conformação/Análise de Impacto de Mutações;
- Dados de Trajetória/Múltiplas Conformações;
- *Mestrado: Como Analisar trajetórias (RINs) p/ entender o efeito de mudanças conformacionais na proteína*; Busca de Metiltransferases para Mestrado

---

## Entrada 28/04/2025 - Matheus e João Paulo 

**Pontos Levantados por JP para revisão até o momento:**
- VCF e Análise de mutações com baixa frequência;
- código rs (snp) x sem cósigo rs - levantamento de mutações sem código no dbSNP;
- Classificação de predição de mutação nas variantes com código (frequência em superpopulações)
- Verificar quais vídeos de DM não foram processados no PC de JP;
- SlytheRINs: edição para análise comparativa entre diferenças entre wt x mutadas;
- Etapa com `FoldEX`: ferramenta

**Pendências:**
- Filtragem plddt > 70% dos resíduos AlphaFold
- Simulação de membrana p/ Matheus: `memprotmd` ; maioria de complexo I (?)

**Checklist Geral:**
- [ ] Resultados NMSIM sem resultado de trajetória;
- [ ] Exploração de dados de mutações sem trajetória no NMSIM no VCF do 1000 Genomes;
- [ ] Execução do FoldX/FoldEX (*buscar nome correto*) nas mutações que obtivemos sucesso;
- [ ] Explorar `memprotMD`, fazer pré-seleção de algumas estruturas/arquivos de dinâmica de interesse;
- [ ] Seleção de 2 mutações para iniciação de nota etapa;
- [ ] `Filtragem plddt >700`
- [ ] `Parte 2 SlytheRINs: plddt e Uniprot/AlphaFoldDB`
- [ ] `Busca de arquivo de melhor otimização para Parte 2, o mais leve possível, ou desenvolvimento de script que puxe o arquivo *.cif*, mas processe e delete os dados ao final da análise, poupando espaço (baixo armazenamento do Streamlit)`

**Sugestão de leitura**:[AlphaRING](https://www.biorxiv.org/content/10.1101/2024.11.12.623182v2.abstract)
**Fontes de Interesse:** [FoldX](https://foldxsuite.crg.eu/) ; [Memprotmd](https://memprotmd.bioch.ox.ac.uk/) ; [AlphaMissense HotSpots](https://alphamissense.hegelab.org/)

---

## Entrada 30/04/2025 - Metiltransferases

Busca de Metiltransferases conforme conversado em reunião (24/04). 

**N6-metiladenosina (m6A) - METTL3-METTL14**
- Ligadas a SAM/SAH
- PDB: 5IL2 ; 7LOT
*METTL3:* SAM-binding pocket
*METTL14:* "k-loop"

-> Mutações associadas ao câncer: 
- METTL3 R471C;
- Forforilação (pós-transcricional);
- METTL3 (D359) *catalytic dead mutant*;
- Região de ligação mutada da METTL14 - *Y406A*

**Interessantes pensando em RINs**
- *METTL3 SAM-binding pocket - D395 ; W397*
- *MEETL14 RNA K-binding loop - Y406 ; K409*

**TAREFA:** 
- [X] Busca no 1000 Genomes de mutações missense conhecidas p/ METTL3 e METTL14 (possibilidade de mutação de efeito semelhante ainda não conhecida)

## Entrada 14/05/2025 - Retorno de busca [1000G](https://www.internationalgenome.org/home) e X-Meeting

### TÓPICO 1: **SOBRE 1000G:**
Existem algumas formas de busca e acesso aos dados do 100G, a partir do [IGSR](https://www.internationalgenome.org/data-portal/sample) para visão geral de dados disponíveis e publicações associadas (metadado); acesso a amostra e contexto genômico pelo [Ensembl](https://www.ensembl.org/index.html)*; acessi ao dado bruto (o que eu fiz, julgando nosso objetivo de busca geral) pelo [NCBI](https://ftp-trace.ncbi.nih.gov/1000genomes/ftp/).

Os dados que me refiro aqui são encontrados a partir do dado bruto no NCBI, a partir da seguinte navegação de diretórios: **`1000G_2504_high_coverage/working/20201028_3202_raw_GT_with_annot/`**

Arquivos de formato `vcf.gz.tbi` com informação resumida em relação às mutações do 1000G despertaram minha curiosidade como uma opção de análise dos dados de interesse (missense METTL3 e METTL14); mas mesmo trabalhando com o formato tabular, o enorme volume e tamanho dos arquivos `vcf` - mesmo filtrado para busca apenas na região do cromossomo onde o gene de interesse se encontra -  me leva a pensar que devem existir alternativas mais manejáveis. 

Pergunta 1: *Existem outras formas de chamar essas variantes de interesse de forma mais eficiente?*
**Diego** sugeriu que, se o interesse for *mutações missense*, fazer a busca diretamente no `dbSNP, obtendo um número filtrado bem menor de variantes, arquivos menores e potencialmente mais maleáveis pra análise. 

**SUGESTÕES E TAREFAS:**

- [ ] Utilizar arquivos `clinical.txt`e `annotated-coding.txt` como fonte de informações de dados adicionais referentes às variávereis de interesse (Uma alternativa de análise de dados via terminal sem busca individual no ClinVar para cada variante).
- [ ] *Sugestão* do `EnsemblVEP` para predição de mutação na análise de potenciais mutações significativas além das já conhecidas (uma forma de pré-filtragem para seleção de variantes de interesse).

`Disclaimer:` Pra trazer noção de tamanho e o porquê de ser difícil de lidar com os dados do 1000G, falamos de dados de variantes de um único cromossomo chegando a 74gb ZIPADO. 

**Fonte de Interesse:** 

- [Informações Gerais da Genotipagem dos Dados brutos 1000G](https://ftp-trace.ncbi.nih.gov/1000genomes/ftp/1000G_2504_high_coverage/working/20201028_3202_raw_GT_with_annot/20201028_1000G_2020Oct26_NYGC_JointGenotyping_README.pdf)

### TÓPICO 2: Problema com NMSIM 

**URGENTE:**
- [ ] Refazer o script em python e linux para pré-processar arquivos **erroneamente** *sem numeração na coluna ***Model***.








