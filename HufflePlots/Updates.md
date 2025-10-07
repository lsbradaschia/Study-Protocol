# HufflePlots Update - Convert and Concatenate

## 1. Convert GROMACS xvg to .txt format 

Two new pre-process steps will be added to HufflePlots, which the first converts GROMACS generated `.xvg` file formats resulting from usage of `gmx rms` or `gmx rmsf` to `.txt` format,
allowing further pre-processing steps in HufflePlots. 

All the coding is made in Python, in which the **base code for xvg-to-rmsd** is: 

```python

#Dependencias e Bibliotecas

import pandas as pd
import sys
import re
import os
import glob

#Função pra utilização direta de .py

def xvg_rmsd(input_file):
  """
  Processa um arquivo .xgv gerado pelo GROMACS para um formato simples (.txt).
  Extrai o nome do arquivo de saída do comando GROMACS (gmx rms -o ) do cabeçalho;
  Remove linhas do cabeçalho (começam com @ ou #);
  Formata dados numéricos da primeira coluna.
  """

  #1. Guarda do -o do gmx rms para o nome de saída do arquivo original
  output_name = None

  #2. Leitura e processamento do arquivo linha por linha
  rmsd_lines = [] #pra diferenciar a função de rmsd e rmsf

  with open(input_file, 'r') as f:
    for line in f:
    #Encontra a linha do comando gmx rms
      if line.strip().startswith('# gmx rms'):
        #Extração do nome do arquivo após '-o'
        match = re.search(r'o\s+(\S+)', line)
        if match:
          output_name = match.group(1)

    #Remover linhas do cabeçalho
    if not line.strip().startswith(('#','@')):
      #Linhas de dados sem o cabeçalho pro append
      rmsd_lines.append(line.strip())


  if not output_name:
    raise ValueError("Não foi possível encontrar o nome do arquivo de saída na linha de comando GROMACS.")

    # 3. Formatar os dados numéricos
    formatted_lines = []
    for i, line in enumerate(rmsd_lines):
        try:
            # Dividir a linha em colunas, pegar a segunda coluna (RMSD), e gera uma nova coluna de index
            parts = line.split()
            value = float(parts[1])

            # Formatar a linha de saída
            # A indexação começa em 1, não em 0
            formatted_lines.append(f"{i + 1}.00\t{value:.5f}")
        except (IndexError, ValueError):
            # Ignorar linhas mal formatadas
            continue

  #4. Salva o resultado em novo arquivo (.txt)
  output_file = f"{output_name}.txt"
  with open(output_file, 'w') as f:
    f.write('\n'.join(formatted_lines))

  return output_file, output_name

#Roda em um diretório, para múltiplos arquivos

# Multiplos arquivos e file_label

if __name__ == "__main__":
    # Defina o diretório onde os arquivos .xvg estão localizados
    search_directory = "./" #default, diretório atual pra bash

    files_rmsd = []

    # Encontra todos os arquivos .xvg no diretório
    xvg_files = glob.glob(os.path.join(search_directory, '*.xvg'))

    if not xvg_files:
        print("Nenhum arquivo .xvg encontrado no diretório especificado.")
    else:
        for xvg_file in xvg_files:
            try:
                new_file_path, file_label = xvg_rmsd(xvg_file)
                files_rmsd.append((new_file_path, file_label))
            except Exception as e:
                print(f"Erro ao processar o arquivo {xvg_file}: {e}")

        #String com caminho e label
        output_list_rmsd = "files_rmsd = [\n"
        for path, label in files_rmsd:
            output_list_rmsd += f"    ('{path}', '{label}'),\n"
        output_list_rmsd += "]\n"

        # Salva a string em um novo arquivo
        output_file_name = "files_rmsd_list.py"
        with open(output_file_name, 'w') as f:
            f.write(output_list_rmsd)

        print("\n--- Lista pronta para ser usada no seu script - dados RMSD ---")
        print(output_list_rmsd)
        print(f"Lista salva no arquivo: {output_file_name}")


```

All the **base code for xvg rmsf** conversion: 

```python
#Dependencias e Bibliotecas

import pandas as pd
import sys
import re
import os
import glob

#Função pra utilização direta de .py

def xvg_rmsf(input_file):
  """
  Processa um arquivo .xgv gerado pelo GROMACS para um formato simples (.txt).
  Extrai o nome do arquivo de saída do comando GROMACS (gmx rmsf -o ) do cabeçalho;
  Remove linhas do cabeçalho (começam com @ ou #);
  Formata dados numéricos da primeira coluna.
  """

  #1. Guarda do -o do gmx rmsf para o nome de saída do arquivo original
  output_name = None

  #2. Leitura e processamento do arquivo linha por linha
  rmsf_lines = [] #pra diferenciar a função de rmsd e rmsf

  with open(input_file, 'r') as f:
    for line in f:
    #Encontra a linha do comando gmx rmsf
      if line.strip().startswith('# gmx rmsf'):
        #Extração do nome do arquivo após '-o'
        match = re.search(r'o\s+(\S+)', line)
        if match:
          output_name = match.group(1)

    #Remover linhas do cabeçalho
    if not line.strip().startswith(('#','@')):
      #Linhas de dados sem o cabeçalho pro append
      rmsf_lines.append(line.strip())


  if not output_name:
    raise ValueError("Não foi possível encontrar o nome do arquivo de saída na linha de comando GROMACS.")

    # 3. Formatar os dados numéricos
    formatted_lines = []
    for i, line in enumerate(rmsf_lines):
        try:
            # Dividir a linha em colunas, pegar a segunda coluna (RMSF), e gera uma nova coluna de index
            parts = line.split()
            value = float(parts[1])

            # Formatar a linha de saída
            # A indexação começa em 1, não em 0
            formatted_lines.append(f"{i + 1}.00\t{value:.5f}")
        except (IndexError, ValueError):
            # Ignorar linhas mal formatadas
            continue

  #4. Salva o resultado em novo arquivo (.txt)
  output_file = f"{output_name}.txt"
  with open(output_file, 'w') as f:
    f.write('\n'.join(formatted_lines))

  return output_file, output_name

#Roda em um diretório, para múltiplos arquivos

# Multiplos arquivos e file_label

if __name__ == "__main__":
    # Defina o diretório onde os arquivos .xvg estão localizados
    search_directory = "./" #default, diretório atual pra bash

    files_rmsf = []

    # Encontra todos os arquivos .xvg no diretório
    xvg_files = glob.glob(os.path.join(search_directory, '*.xvg'))

    if not xvg_files:
        print("Nenhum arquivo .xvg encontrado no diretório especificado.")
    else:
        for xvg_file in xvg_files:
            try:
                new_file_path, file_label = xvg_rmsf(xvg_file)
                files_rmsf.append((new_file_path, file_label))
            except Exception as e:
                print(f"Erro ao processar o arquivo {xvg_file}: {e}")

        #String com caminho e label
        output_list_rmsf = "files_rmsf = [\n"
        for path, label in files_rmsf:
            output_list_rmsf += f"    ('{path}', '{label}'),\n"
        output_list_rmsf += "]\n"

        # Salva a string em um novo arquivo
        output_file_name = "files_rmsf_list.py"
        with open(output_file_name, 'w') as f:
            f.write(output_list_rmsf)

        print("\n--- Lista pronta para ser usada no seu script - dados RMSF ---")
        print(output_list_rmsf)
        print(f"Lista salva no arquivo: {output_file_name}")



```


Colab Notebook version of script available [here](https://colab.research.google.com/drive/1gMNRrlpreKP20mJJOz-RiKfLCRLlZXLM), in case of personal changes needed.
