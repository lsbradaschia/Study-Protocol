# Pesquisa Exploratória para Completo METTL3-METTL14 para Batata

## Características Gerais

METTL3-14 formam o complexo heterodímero ***N6-metiltransferase**, responsável pela metilação de **adenosinas**. Interesse nesse complexo vem de estudo prévio da minha parte 
em RNAS longos não codificantes (lncRNAS). Estudo prévio associado ao prof. Vinícius tem uma linha de pesquisa voltada pra metilação pós-transcricional de lncRNAs. Tive acesso 
pesquisas de altíssimo nível de Seba sobre esse complexo, e por isso meu interesse em observar as mudanças conformacionais associadas a mutações missense nesses complexos, 
já bastante conhecido e associados a cancer e a outras doenças (referencias no final).

O seguinte [artigo](https://www.cell.com/molecular-cell/fulltext/S1097-2765(16)30227-1?_returnURL=https%3A%2F%2Flinkinghub.elsevier.com%2Fretrieve%2Fpii%2FS1097276516302271%3Fshowall%3Dtrue), indicado por Seba, me trouxe a possibilidade de utilizar essas moléculas como dado exemplo, por disponibilidade de dados de cristalografia, além de extensa
pesquisa bibliográfica de laboratório associado, o que pode ser de interesse pra pesquisas posteriores. 

### METTL3 -Sub-unidade Catalítica do complexo N6-metiltransferase

- UNIPROT: [Q86U44](https://www.uniprot.org/uniprotkb/Q86U44/entry)
- TAMANHO: 580 aa
- Gene: [METTL3](https://www.ncbi.nlm.nih.gov/gene/56339)
- Região (chrom): Chromossomo 14 
- LOCALIZAÇÃO (UniProt): Majoritariamente **Núcleo**, ou **citoplasma**. Nada sobre transmembranal (obrigada deus)
- OMIM: [612472](https://www.omim.org/entry/612472)
- ClinVar: [612472[MIM] ](https://www.ncbi.nlm.nih.gov/clinvar/?term=612472[MIM])
- KEGG: [HUMAN 56339](https://www.genome.jp/dbget-bin/www_bget?hsa:56339)
- PTM/Processing (Tabela abaixo):

| Type | Start | End | Description | Evidences (Code, Source, ID) |
|---|---|---|---|---|
| Initiator methionine | 1 | 1 | Removed | ECO:0007744 (PubMed: 19413330) |
| Chain | 2 | 580 | N(6)-adenosine-methyltransferase catalytic subunit METTL3 | N/A |
| Modified residue | 2 | 2 | N-acetylserine; alternate | ECO:0007744 (PubMed: 19413330) |
| Modified residue | 2 | 2 | Phosphoserine; alternate | ECO:0000269 (PubMed: 29348140) |
| Modified residue | 43 | 43 | Phosphoserine | ECO:0000269 (PubMed: 29348140), ECO:0007744 (PubMed: 16964243), ECO:0007744 (PubMed: 18669648), ECO:0007744 (PubMed: 20068231), ECO:0007744 (PubMed: 23186163) |
| Modified residue | 48 | 48 | Phosphoserine | ECO:0000269 (PubMed: 29348140) |
| Modified residue | 50 | 50 | Phosphoserine | ECO:0000269 (PubMed: 29348140) |
| Modified residue | 219 | 219 | Phosphoserine | ECO:0000269 (PubMed: 29348140), ECO:0007744 (PubMed: 18669648), ECO:0007744 (PubMed: 23186163) |
| Modified residue | 243 | 243 | Phosphoserine | ECO:0000269 (PubMed: 29348140), ECO:0007744 (PubMed: 18669648) |
| Modified residue | 348 | 348 | Phosphothreonine | ECO:0000269 (PubMed: 29348140), ECO:0007744 (PubMed: 23186163) |
| Modified residue | 350 | 350 | Phosphoserine | ECO:0000269 (PubMed: 29348140) |
| Cross-link | 177 | 177 | Glycyl lysine isopeptide (Lys-Gly) (interchain with G-Cter in SUMO1) | ECO:0000269 (PubMed: 29506078) |
| Cross-link | 211 | 211 | Glycyl lysine isopeptide (Lys-Gly) (interchain with G-Cter in SUMO1) | ECO:0000269 (PubMed: 29506078) |
| Cross-link | 212 | 212 | Glycyl lysine isopeptide (Lys-Gly) (interchain with G-Cter in SUMO1) | ECO:0000269 (PubMed: 29506078) |
| Cross-link | 215 | 215 | Glycyl lysine isopeptide (Lys-Gly) (interchain with G-Cter in SUMO1) | ECO:0000269 (PubMed: 29506078) |


- Binary Interactions:

 Type | Entry1 | Entry2 | Nº of Experiments | Intact |
|---|---|---|---|---|
| Binary | Q86U44 | METTL14 Q9HCE5 | 21 | [IntAct - 21 entries](https://www.ebi.ac.uk/intact/search?query=(id:EBI-11105430%20AND%20id:EBI-6661081)#interactor) |
| Binary | Q86U44-1 | METTL14 Q9HCE5 | 10 | [IntAct - 10 entries](https://www.ebi.ac.uk/intact/search?query=(id:EBI-16084936%20AND%20id:EBI-6661081)#interactor) |


#### METTL3 - Estruturas PDB

Criando uma aba nova pelo seguinte, existem algumas estruturas por cristalografia pra METTL3 no PDB e com artigos de referência MUITO bem citados (feito o paper que linkei acima), mas muitas estruturas experimentais fazem a cristalização **apenas das regiões de ligação entre METTL3-14**, havendo uma remoção das **porções proteolíticas das duas estruturas**. 

Como isso pode ser interessante pra análise, eu vou atrás de PDBs *TANTO DAS REGIÕES DE LIGAÇÃO (denominadas pelo artigo como MTD3-MTD14), QUANTO DAS ESTRUTURAS COMPLETAS*. Pode ser interessante ver o comportamente da trajetória delas dessa forma. 

**NOTA/DÚVIDA:** Existem estudos com as ISOFORMAS de cada uma delas. Seria interessante fazer análise comparativa das isoformas que **contem os domínios de ligação**, além de mutações missense? Acho que isso daria não só um dado exemplo como um ótimo artigo de pesquisa. 

**NOTA2:** Estruturas do [Paper muito citado e populoviski]() são: 5K7M, 5K7U e 5K7W

- PDB MTD3(isolado): []()
- PDB MTTL3 (completa): []()
- PDB com Mutações: []()
- AlphaFoldDB: []()
- PTM/Processing:

| Type | Start | End | Description | Evidences (Code, Source, ID) |
|---|---|---|---|---|
| Initiator methionine | 1 | 1 | Removed | ECO:0007744 (PubMed: 19413330) |
| Chain | 2 | 580 | N(6)-adenosine-methyltransferase catalytic subunit METTL3 | N/A |
| Modified residue | 2 | 2 | N-acetylserine; alternate | ECO:0007744 (PubMed: 19413330) |
| Modified residue | 2 | 2 | Phosphoserine; alternate | ECO:0000269 (PubMed: 29348140) |
| Modified residue | 43 | 43 | Phosphoserine | ECO:0000269 (PubMed: 29348140), ECO:0007744 (PubMed: 16964243), ECO:0007744 (PubMed: 18669648), ECO:0007744 (PubMed: 20068231), ECO:0007744 (PubMed: 23186163) |
| Modified residue | 48 | 48 | Phosphoserine | ECO:0000269 (PubMed: 29348140) |
| Modified residue | 50 | 50 | Phosphoserine | ECO:0000269 (PubMed: 29348140) |
| Modified residue | 219 | 219 | Phosphoserine | ECO:0000269 (PubMed: 29348140), ECO:0007744 (PubMed: 18669648), ECO:0007744 (PubMed: 23186163) |
| Modified residue | 243 | 243 | Phosphoserine | ECO:0000269 (PubMed: 29348140), ECO:0007744 (PubMed: 18669648) |
| Modified residue | 348 | 348 | Phosphothreonine | ECO:0000269 (PubMed: 29348140), ECO:0007744 (PubMed: 23186163) |
| Modified residue | 350 | 350 | Phosphoserine | ECO:0000269 (PubMed: 29348140) |
| Cross-link | 177 | 177 | Glycyl lysine isopeptide (Lys-Gly) (interchain with G-Cter in SUMO1) | ECO:0000269 (PubMed: 29506078) |
| Cross-link | 211 | 211 | Glycyl lysine isopeptide (Lys-Gly) (interchain with G-Cter in SUMO1) | ECO:0000269 (PubMed: 29506078) |
| Cross-link | 212 | 212 | Glycyl lysine isopeptide (Lys-Gly) (interchain with G-Cter in SUMO1) | ECO:0000269 (PubMed: 29506078) |
| Cross-link | 215 | 215 | Glycyl lysine isopeptide (Lys-Gly) (interchain with G-Cter in SUMO1) | ECO:0000269 (PubMed: 29506078) |


- Binary Interactions:

 Type | Entry1 | Entry2 | Nº of Experiments | Intact |
|---|---|---|---|---|
| Binary | Q86U44 | METTL14 Q9HCE5 | 21 | [IntAct - 21 entries](https://www.ebi.ac.uk/intact/search?query=(id:EBI-11105430%20AND%20id:EBI-6661081)#interactor) |
| Binary | Q86U44-1 | METTL14 Q9HCE5 | 10 | [IntAct - 10 entries](https://www.ebi.ac.uk/intact/search?query=(id:EBI-16084936%20AND%20id:EBI-6661081)#interactor) |

### METTL14 - Sub-unidade não-catalítica do complexo N6-metiltransferase 

- UNIPROT: []()
- TAMANHO: []()
- OMIM: []()
- ClinVar: []()
- PDB (isolado): []()
- PDB com Mutações: []()
- AlphaFoldDB: []()

### COMPLEXO HETERODÍMERO N6-metiltransferase (se houver) - METTL3-METTL14

Tem pdb pra caralho, e informações em outras bases de dados sobre INTERAÇÃO, que vou colocar abaixo, mas vou 

- UNIPROT: []()
- TAMANHO: []()
- OMIM: []()
- ClinVar: []()
- PDB (isolado): []()
- PDB com Mutações: []()
- AlphaFoldDB: []()

#### Complexo N6-METILTRANSFERASE - PDBs
