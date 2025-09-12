# Estudos Diversos

## Batata - Proteína simples pra example data do SlytheRINs 

Para a busca de molécula apropriada, será feita uma busca por moléculas pequenas e de cadeia simples. Para busca afunilada, o foco será na '*Glycogen Storage Disease*', e proteínas que apresentam mutações *missense* nos diversos tipos dessa doença. 

***Tipos GSD x QIAGEN***

| Tipo/Nome               | Enzima Afetada                     | Órgãos Afetados                 | Genes Associados (QIAGEN)    |
| :---------------------: | :--------------------------------: | :-----------------------------: | :--------------------------: |
| Tipo 0                  | Glycogen synthase                  | Liver                           | GYS1, GYS2                   |
| Tipo Ia (von Gierke's)  | Glucose-6-phospatase               | Liver                           | G6PC1, ASS1, GAA, NR3C1      |
| Tipo Ib                 | Microsomal G6P translocase         | Liver                           | FOXP3, SLC37A4               |
| Tipo Ic                 | Microsonal Pi transporter          | Liver                           | SLC37A4                      |
| Tipo II (Pompe's)       | Lysosomal glucosidase              | Skeletal/Cardiac muscle         | GAA, IGF2R, M6PR, UCGC **     |
| Tipo IIIa               | Debranching enzyme                 | Liver, skeletal/cardiac muscle  | AGL                          |
| Tipo IIIb               | Liver debranching enzyme           | Liver                           | AGL                          |
| Tipo IV (Andersen's)    | Branching enzyme                   | Liver/Skeletal muscle           | GAA, GBE1                    | 
| Tipo V (McArdle's)      | Muscle phosporylase                | Skeletal muscle                 | Apenas fármacos associados***|
| Tipo VI (Hers's)        | Liver phosporylase                 | Liver                           | PYGL                         |
| Tipo VII (Tarui's)      | Muscle PFK-1                       | Muscle, erythrocytes            | PFKM, Phosphofructokinase    |
| Tipo VIb, VIII or IX    | Phosporylase kinase                | Liver, erythrocytes, muscle     | PHKA1, PHKA2, PHKB, PHKG2    |
| Tipo XI (Fanconi-Bickel | Glucose transporter (GLUT2)        | Liver                           | LDHA                         |

** Mais de 60 moléculas associadas à tipo II (Pompe's) pela QIAGEN. Todas as moléculas e filtragem vou fazer a frente.

  
*** Buscar na literatura se existem associações de genes ao tipo V.

### Busca de Moléculas Associadas usando QIAGEN

Pra curadoria e testagem do Software, vou usar a QIAGEN IPA pra curagem de genes associados pra cada um dos tipos de GSD de interesse. O software da QIAGEN tem uma aba específica de '*Diseases and Functions*' onde posso procurar diretamente pela GSD do tipo desejado, e moléculas associadas. 

---

### GSD Ia 
Associada ao mal funcionamento de uma **sub-unidade** da G6P codificada pelo gene **G6PC1**. A seguinte [tabela](SlytheRINs/Papers/sup-table2.pdf) retirada de uma revisão indicam muitas variantes nessa sub-unidade. 

#### G6PC1 - Unidade catalítica 1 da Glucose-6-Fosfatase

- UNIPROT: [P35575](https://www.uniprot.org/uniprotkb/P35575/entry)
- TAMANHO: 357 AA
- OMIM: [232200](https://www.omim.org/entry/232200); [613742](https://www.omim.org/entry/613742?search=gsd1a&highlight=gsd1a)
- ClinVar: [613742[MIM]](https://www.ncbi.nlm.nih.gov/clinvar/?term=613742[MIM])
- PDB: [97JV](https://www.rcsb.org/structure/9J7V)
  - Recentemente submetida (2025). [https://www.pnas.org/doi/10.1073/pnas.2418316122]
- AlphaFoldDB: [AF-P35575-F1-v4](https://alphafold.ebi.ac.uk/entry/P35575)
 
***NOTA:*** Existe uma divergencia entre o número de aa existentes na versão final da subunidade. UniProt não indica nenhum ponto de clivagem (nem mesmo da posição 1), enquanto os arquivos PDB possuem 352 aa, onde os faltantes são do N-terminal. Vou usar tanto o arquivo pdb nativo quanto o modelado do **AlphaFold** para os testes. 

### Shell Script para Numeração Automática de "MODEL" em arquivos PDB
```bash
awk 'BEGIN{c=1} /^MODEL/ {printf "MODEL     %4d\n", c++} !/^MODEL/ {print}' 9J7V_trajectory.pdb > 9J7V_teste.pdb

```
#### Checagem e unzip de arquivo PDB de trajetória em terminal Linux
```
#Primeiro descompactar usando gunzip
gunzip -k 9J7V_trajectory.pdb.gz

#Contagem de strings 'MODEL' presentes no arquivo (pro NMSIM como utilizamos, deve ser 500)
grep -c "MODEL" 9J7V_trajectory.pdb.gz

#Averiguar se o string "MODEL" está devidamente numerado
##Esse comando, por default, lhe devolve a linha onde o string "MODEL" se encontra.        
grep "MODEL" 9J7V_trajectory.pdb.gz

````
**NOTA:** O parâmetro -k cria um novo arquivo descompactado, mas mantém o antigo intacto. 


Quando devidamente numerado, os números aparecerão ao lado do string "MODEL"
```
#Exemplo de output de .pdb devidamente numerado
grep "MODEL" 9J7V_teste.pdb
MODEL        1
MODEL        2
MODEL        3
MODEL        4
MODEL        5
MODEL        6
MODEL        7
MODEL        8
MODEL        9
MODEL       10
...

Exemplo de output .pdb sem numeração
```
MODEL
MODEL
MODEL
MODEL
MODEL
MODEL
MODEL
MODEL
MODEL
MODEL
MODEL
```

 
Selecionei 3 variantes que possuem os maiores números de publicação a respeito:
- 	**[VAR_005239](https://web.expasy.org/variant_pages/VAR_005239.html#) (12 Publicações)**
    - [rs1801175](https://www.ncbi.nlm.nih.gov/snp/rs1801175)
    - [Patogênica](https://www.ncbi.nlm.nih.gov/clinvar?term=((2749251[AlleleID])OR(27037[AlleleID])))
    - [Ensembl](http://www.ensembl.org/Homo_sapiens/Variation/Explore?r=17:42903447-42904447;v=rs1801175;vdb=variation;vf=959569854)
-   **[VAR_005246](https://web.expasy.org/variant_pages/VAR_005246.html) (5 Publicações)**
    - [rs80356482](https://www.ncbi.nlm.nih.gov/snp/rs80356482)
    - [Patogênica](https://www.ncbi.nlm.nih.gov/clinvar?term=((211810[AlleleID])OR(27047[AlleleID])))
    - [Ensembl](http://www.ensembl.org/Homo_sapiens/Variation/Explore?r=17:42908918-42909918;v=rs80356482;vdb=variation;vf=960112920)
-   **[VAR_005237](https://web.expasy.org/variant_pages/VAR_005237.html) (4 Publicações)**
    - [rs104894565](https://www.ncbi.nlm.nih.gov/snp/rs104894565)
    - [Patogênica](https://www.ncbi.nlm.nih.gov/clinvar/variation/12004/?oq=((27043[AlleleID]))&m=NM_000151.4(G6PC1):c.113A%3ET%20(p.Asp38Val))
    - [Ensembl](https://www.ncbi.nlm.nih.gov/clinvar/variation/12004/?oq=((27043[AlleleID]))&m=NM_000151.4(G6PC1):c.113A%3ET%20(p.Asp38Val))

#### NMSIM PDB 97JV
[LINK 97JV NATIVA](https://cpclab.uni-duesseldorf.de/nmsim/results/7mSURtgxwdyM4rb/)

***Seleção de Melhor Modelo de AlphaFold com RevelioPlots***
fold_a83c_9j7v_model_0.cif

[LINK 9J7V VAR_005239](https://cpclab.uni-duesseldorf.de/nmsim/results/SLyyhdWE1YNTCUd/)

***Ambas sem numeração em MODEL***



***ANOTAÇÕES GERAIS ABAIXO***
---
### Busca de Moléculas Associadas por busca bibliográfica

Busca por artigos científicos levaram a 3 artigos de revisão sobre GSD, onde informações quanto a localização do gene, frequência de variantes, e principais moléculas relacionadas a cada tipo da doença podem ser facilmente identificados a partir das tabelas. 

**[Glycogen Storage Disease](https://doi.org/10.1038/s41572-023-00456-z)**
- [Clinical Features of GSDs](SlytheRINs/Papers/sup-table1.pdf)
- [Epidemology of GSDs](SlytheRINs/Papers/sup-table2.pdf)

---
**[Glycogen Storage Diseases: an update](https://doi.org/10.3748/wjg.v29.i25.3932)**
- [Overview of GSDs](SlytheRINs/Papers/gene-loc.pdf)
    - Informação sobre localização do gene
**Trechos de Relevância**
- ***GSD-IX; PHK deficiency***
    - PHK is a heterotetramer composed of **4 different subunits (α, β, γ, and δ)**. Each subunit is **encoded by different genes** that are located on different chromosomes and differentially expressed in a variety of tissues. ***α and β subunits have regulatory functions, the γ subunit contains the catalytic site, and δ is a calmodulin protein***.
    - α subunit: PHKA1(muscle) and PHKA2(liver) on the X choromossome.
    - γ subunit: PHKG1(muscle) and PHKG2(liver).
    -  β subunit: PHKB
  - GSD-IX Classification:
      - According to gene: *X-linked form (GSD-IXa or X-linked glycogenosis)*
      - According to autossomal recessive forms: GSD-IXb and GSD-IXc 

---
 **[Glycogen Metabolism and glycogen Storage diseases](http://dx.doi.org/10.21037/atm.2018.10.59)**
- [Characteristics of Inborn errors of glycogen metabolism](SlytheRINs/Papers/tabela-frequencia.pdf)
    - Informação sobre frequência de cada tipo da doença (quando existente)
**Trechos de relevância**
- GSD0a
    - liver glycogen synthase enzyme deficiency with impaired ability to incorporate UDP-glucose onto glycogen strands and elongate it within the liver. GSD0a is an **autosomal recessive disorder caused by a mutation in the GYS2 gene located at 12p12.2 that codes for the hepatic isoform of glycogen synthase**.
- GSD1a (Von Gierke)
    - Glucose-6-Phosphatase. Deficiency results from impaired ability of the hydrolase **subunit of G6Pase**, also known as G6Pase-α to hydrolyze G6P, leading to impaired function of G6Pase in removing the phosphate group from glucose-6-phosphate (G6P).
    - G6Pase-α is necessary to convert fructose and galactose into glucose and is expressed in the liver, kidney, and intestines.
    - GSD1a mode of inheritance is autosomal recessive; with **mutations in the G6PC gene on chromosome 17p21.31 encoding α-glucose-6-phosphatase (G6Pase-α)
enzyme**.
    - GSD1 incidence is about 1 in 100,000 with GSD1a accounting for 80% of diagnosis. Within the Ashkenazi Jewish population, the suggested incidence of GSD1a is 1 in 20,000.
- GSD1b
    - GSD1b has autosomal recessive inheritance, with 92 different reported with 31 confirmed as pathogenic mutations in SLC37A4 gene on chromosome 11q23, encoding glucose-6-phosphate translocase (G6PT) enzyme (GDE); and no apparent genotype-phenotype relationship.
    - G6PT enzyme is a transmembrane protein found within the endoplasmic reticulum and functions to move G6P into the endoplasmic reticulum. G6Pase-α and G6PT together as the G6Pase complex maintains glucose homeostasis.

- GSD 6
    - Hers disease or liver phosphorylase enzyme deficiency, is a glycogenolysis defect. Diagnostic confirmation includes molecular analysis of **PYGL** gene.
- GSD9a1 e GSD9a2
    - impaired phosphorylase kinase activity in the liver or erythrocyte (GSD9a1) or only liver (GSD9a2). Most common of all GSD9
    - X-linked inheritance with mutations in the **PHKA2** gene on chromosome Xp22.13 that encodes liver phosphorylase kinase.
- GSD9c
    - Impaired **gamma unit of phosphorylase kinase enzyme** function in liver and testis.
    - Because the gamma subunit contains the catalytic site of the enzyme, GSD9C typically has a more severe phenotype.
    - Autosomal recessive disorder caused by **mutations of the PHKG2** gene which encodes the **gamma subunit of phosphorylase kinase** on chromosome
16p11.2

- GSD9b
    - Also known as phosphorylase kinase deficiency of liver and muscle. An autosomal recessive disorder caused by **mutations of β subunit of PHKB** gene on chromosome 16q12.1

---

### Candidatas: 
Considerando as Candidatas/Indicações que o professor deu baseadas no Lehninger: 
- Proteínas da *Via Glicogênica*;
- Glicogênio Sintase;
- Fosforilases;
- Glucoquinases/Glucokinase (Síndrome mud2);
- G6P/G6pase
- Fatores de Transcrição;
- Associadas à Glycogen Storage Disease (GSD);
- Monômeros (Cadeia simples de proteína complexa)

Vou primeiramente considerar os pontos acima e buscar a partir da busca bibliográfica anomalias já associadas à **subunidades**, para maior chance de moléculas pequenas e de cadeia única para a pesquisa já antes confirmadas ligadas a doença. Caso necessário, buscarei por outras moléculas seguindo a seguinte ordem:

1. Associação direta com a síntese de Glicogênio (e tipos de GSD associadas);
2. Associada a anomalia no funcionamento de fosforilases(e GSDs associadas);
3. Glucoquinases;
4. Frequência de GSD predominante

### GSD com deficiência em subunidades associadas a doença
- ***GSD1a (Von Gierke) - mais frequente***
    - Glucose-6-Phosphatase. Deficiency results from impaired ability of the hydrolase **subunit of G6Pase**, also known as G6Pase-α to hydrolyze G6P, leading to impaired function of G6Pase in removing the phosphate group from glucose-6-phosphate (G6P).
    - GSD1a mode of inheritance is autosomal recessive; with **mutations in the G6PC1 gene on chromosome 17p21.31 encoding α-glucose-6-phosphatase (G6Pase-α)
enzyme**.
    - **G6PC1**, ASS1, GAA, NR3C1 (QIAGEN)
- ***GSD9c***
    - Impaired **gamma unit of phosphorylase kinase enzyme** function in liver and testis.
    - Because the gamma subunit contains the catalytic site of the enzyme, GSD9C typically has a more severe phenotype.
    - Autosomal recessive disorder caused by **mutations of the PHKG2** gene which encodes the **gamma subunit of phosphorylase kinase** on chromosome
16p11.2
    - PHKA1, PHKA2, PHKB, PHKG2 (QIAGEN)
***- GSD9b***
    - Also known as phosphorylase kinase deficiency of liver and muscle. An autosomal recessive disorder caused by **mutations of β subunit of PHKB** gene on chromosome 16q12.1

- ***GSD7 (Tarui Disease)***
    - Deficient muscle **subunit of phosphofructokinase (PFK) enzyme**.
    - GSD9D is an X-linked recessive disorder caused by **mutations of the PHKA1 gene** which **encodes the alpha subunit** of muscle phosphorylase kinase on chromosome Xq13.1.
    - The overall prevalence of GSD9 is estimated to be 1 in 100,000.

---

### GSD IX - Fosforilase Quinase (PHK) 

GSD IX pode ser de diferentes subtipos, todos associados às diferentes **subunidades** da PHK. Cada uma das 4 subunidades da PHK é codificada por um gene diferentes, localizado em diferentes cromossomos. As subunidades α e γ possuem diferentes isoformas dependendo da sua área de atuação (rins ou músculos). Subunidades α e β tem função regulatória, γ é a subunidade catalítica e δ é uma calmodulina (sinalizadora). 

    - α : PHKA1(muscle) and PHKA2(liver) on the X choromossome. `Tarui Disease/GSD VII/ GSD IXa`
    - γ : PHKG1(muscle) and PHKG2(liver). `GSD IXc`
    - β: PHKB. `GSD IXb`


   

- Anotei previamente GSD0, IV e XV diretamente associadas. Revisar nos artigos e IPA para seguir com candidatas. 


