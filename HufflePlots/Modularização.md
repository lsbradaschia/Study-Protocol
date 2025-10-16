# Otimização e Modularização do HufflePlots - 16/10/2025

As atualizações de processamento de arquivos `.xvg` do GROMACS e compilação de arquivos de interesse em `.csv` me fez refletir sobre como melhorar o entendimento do script como um todo para um usuário que queira entende-lo. **Modularização**
separa as etapas principais dos processos da ferramenta em diferentes arquivos `.py` armazenados no repositório, e acredito que vai ser útil para quando os outros alunos do laboratório precisarem fazer alterações na ferramenta, ou
puxar uma função específica para outra análise de dados. 

Para ter uma ideia de como modularizar, pedi ao Gemini para inicialmente fazer a Modularização do `ProtPlots.py`, para depois eu incorporar aos poucos as outras etapas de análise e processamento. 

## ProtPlots.py Orquestrado

1. **Estrutura de arquivos da Modularização de ProtPlots.py**

```bash
HufflePlots_App/
├── app.py              # Arquivo principal para executar o Streamlit
├── ui.py               # Módulo para os componentes da interface do usuário (sidebar)
├── plotting.py         # Módulo para as funções de plotagem
├── utils.py            # Módulo para funções utilitárias (carregar dados)
├── example_files/
│   ├── P03923_WTxN119S_F161L_RMSD.tsv
│   └── P03923_WTxN119S_F161L_RMSF.tsv
└── HufflePlots.png

```

2. **Conteúdo dos Arquivos**
    2.1 main.py (Orquestrador principal):
```python
# app.py
import streamlit as st
import os
from ui import create_sidebar
from utils import load_data
from plotting import plot_rmsd, plot_rmsf

def main():
    st.image('HufflePlots.png')
    st.title("HufflePlots: Protein Molecular Dynamics *Harry Plotter*")

    # Cria a sidebar e obtém as seleções do usuário
    unit, rmsd_file_uploaded, rmsf_file_uploaded, use_example = create_sidebar()

    # Define os arquivos a serem usados (upload ou exemplo)
    rmsd_file = None
    rmsf_file = None
    example_folder = "example_files"

    if use_example:
        rmsd_file = os.path.join(example_folder, "P03923_WTxN119S_F161L_RMSD.tsv")
        rmsf_file = os.path.join(example_folder, "P03923_WTxN119S_F161L_RMSF.tsv")
    else:
        rmsd_file = rmsd_file_uploaded
        rmsf_file = rmsf_file_uploaded

    # Processa os arquivos e gera os gráficos
    if rmsd_file or rmsf_file:
        st.subheader("Uploaded Data and Plots")

        if rmsd_file:
            st.write("### RMSD Data")
            rmsd_data = load_data(rmsd_file)
            if rmsd_data is not None:
                st.dataframe(rmsd_data.head())
                plot_rmsd(rmsd_data, unit)

        if rmsf_file:
            st.write("### RMSF Data")
            rmsf_data = load_data(rmsf_file)
            if rmsf_data is not None:
                st.dataframe(rmsf_data.head())
                plot_rmsf(rmsf_data, unit)

if __name__ == "__main__":
    main()
   
```

    2.2 ui.py (Interface)
```python
# ui.py
import streamlit as st

def create_sidebar():
    """Cria a sidebar e retorna as opções selecionadas pelo usuário."""
    st.sidebar.title("Options")

    # Seleção de unidade
    st.sidebar.subheader("Files values are in Nanometers (nm) or Angstrom (Å)?")
    unit = st.sidebar.radio("Choose the unit for y-axis:", ("nm", "Å"))

    # Seção de upload de arquivos
    st.sidebar.subheader("Upload Files")
    rmsd_file = st.sidebar.file_uploader("Upload RMSD File (CSV/TSV)", type=["csv", "tsv"])
    rmsf_file = st.sidebar.file_uploader("Upload RMSF File (CSV/TSV)", type=["csv", "tsv"])

    # Seção de arquivos de exemplo
    st.sidebar.subheader("Use Example Files")
    use_example = st.sidebar.checkbox("Use Example Files")

    return unit, rmsd_file, rmsf_file, use_example

```

    2.3 utils.py (Módulo de Utilitários) - função de carregamento de dados
```python
# utils.py
import streamlit as st
import pandas as pd

def load_data(file):
    """Carrega dados de um arquivo CSV ou TSV."""
    try:
        # Verifica se 'file' é um caminho de arquivo (string) ou um arquivo upado
        if isinstance(file, str):
            if file.endswith(".csv"):
                return pd.read_csv(file)
            elif file.endswith(".tsv"):
                return pd.read_csv(file, sep="\t")
        else:
            if file.name.endswith(".csv"):
                return pd.read_csv(file)
            elif file.name.endswith(".tsv"):
                return pd.read_csv(file, sep="\t")
    except Exception as e:
        st.error(f"Error loading file: {e}")
        return None

```

    2.4 plotting.py (Módulo de Gráficos)
```python
# plotting.py
import streamlit as st
import plotly.express as px

def plot_rmsd(data, unit):
    """Gera e exibe o gráfico RMSD."""
    try:
        y_data = data.iloc[:, 1:].copy()  # Cria uma cópia para evitar SettingWithCopyWarning
        x_col_name = data.columns[0]
        
        # O DataFrame original não é modificado. A conversão é feita na cópia.
        if unit == "nm":
            y_data = y_data / 10

        # Constrói um novo DataFrame para o Plotly usar
        plot_data = data[[x_col_name]].join(y_data)

        fig = px.line(plot_data, x=x_col_name, y=plot_data.columns[1:], title="RMSD Plot")
        fig.update_yaxes(title_text=f"RMSD ({unit})")
        fig.update_layout(legend_title="Trajectory")
        st.plotly_chart(fig)

        # Botão de download
        st.download_button(
            label="Download RMSD Plot as PNG",
            data=fig.to_image(format="png"),
            file_name="rmsd_plot.png",
            mime="image/png"
        )
    except Exception as e:
        st.error(f"Error generating RMSD plot: {e}")

def plot_rmsf(data, unit):
    """Gera e exibe o gráfico RMSF."""
    try:
        y_data = data.iloc[:, 1:].copy()
        x_col_name = data.columns[0]

        if unit == "nm":
            y_data = y_data / 10

        plot_data = data[[x_col_name]].join(y_data)

        fig = px.line(plot_data, x=x_col_name, y=plot_data.columns[1:], title="RMSF Plot")
        fig.update_yaxes(title_text=f"RMSF ({unit})")
        fig.update_layout(legend_title="Trajectory")
        st.plotly_chart(fig)

        # Botão de download
        st.download_button(
            label="Download RMSF Plot as PNG",
            data=fig.to_image(format="png"),
            file_name="rmsf_plot.png",
            mime="image/png"
        )
    except Exception as e:
        st.error(f"Error generating RMSF plot: {e}")

```





---
---

# Otimização e Modularização do HufflePlots - Antiga

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

## Organizando .py 

### ProtPlots.py - função principal

```python
import streamlit as st
import pandas as pd
import plotly.express as px
import os
import re
from io import StringIO

def process_xvg_content(content, file_name):
    """
    Identifies the type of .xvg file (RMSD or RMSF) and extracts data.
    """
    lines = content.split('\n')
    file_type = None
    output_name = None

    for line in lines:
        if '# gmx rms ' in line:
            file_type = 'rmsd'
            match = re.search(r'-o\s+(\S+)', line)
            if match:
                output_name = os.path.splitext(match.group(1))[0]
            else:
                output_name = os.path.splitext(file_name)[0] + "_rmsd"
            break
        elif '# gmx rmsf' in line:
            file_type = 'rmsf'
            match = re.search(r'-o\s+(\S+)', line)
            if match:
                output_name = os.path.splitext(match.group(1))[0]
            else:
                output_name = os.path.splitext(file_name)[0] + "_rmsf"
            break

    if not file_type:
        return None, None, None

    data_lines = [line.strip() for line in lines if line.strip() and not line.strip().startswith(('#', '@'))]
    return file_type, output_name, '\n'.join(data_lines)

def create_df_from_txt_files(files, file_type):
    """
    Creates a merged DataFrame from a list of .txt files.
    """
    if not files:
        st.warning(f"No {file_type.upper()} files to process.")
        return None

    all_dfs = []
    for file in files:
        file_content = file.getvalue().decode("utf-8")
        
        # We need a name for the column. Let's use the file name.
        col_name = os.path.splitext(file.name)[0]
        
        try:
            # Use StringIO to treat the string content as a file
            df = pd.read_csv(StringIO(file_content), sep=r'\s+', header=None, names=['Model', col_name])
            all_dfs.append(df)
        except Exception as e:
            st.error(f"Error processing file {file.name}: {e}")
            continue

    if not all_dfs:
        return None

    # Merge all dataframes
    merged_df = all_dfs[0]
    for df in all_dfs[1:]:
        merged_df = pd.merge(merged_df, df, on='Model', how='outer')

    return merged_df


def create_df_from_processed_xvg(processed_files):
    """
    Creates a merged DataFrame from processed .xvg data.
    """
    if not processed_files:
        return None

    # Initial DataFrame from the first file
    first_file_info = processed_files[0]
    col_name = first_file_info['name']
    
    try:
        # Use StringIO to treat the string content as a file
        df = pd.read_csv(StringIO(first_file_info['data']), sep=r'\s+', header=None, names=['Model', col_name])
    except Exception as e:
        st.error(f"Error processing data for {col_name}: {e}")
        return None

    # Merge with the rest of the files
    for file_info in processed_files[1:]:
        col_name = file_info['name']
        try:
            temp_df = pd.read_csv(StringIO(file_info['data']), sep=r'\s+', header=None, names=['Model', col_name])
            df = pd.merge(df, temp_df, on='Model', how='outer')
        except Exception as e:
            st.error(f"Error processing data for {col_name}: {e}")
            continue
            
    return df

def plot_data(df, plot_type, unit):
    """
    Generates and displays a plot for RMSD or RMSF data.
    """
    try:
        y_data = df.iloc[:, 1:]
        if unit == "nm":
            # Angstrom to nm conversion
            y_data = y_data / 10

        fig = px.line(x=df.iloc[:, 0], y=y_data, title=f"{plot_type.upper()} Plot")
        
        y_axis_title = f"{plot_type.upper()} ({'Å' if unit == 'Å' else unit})"
        fig.update_xaxes(title_text="Model")
        fig.update_yaxes(title_text=y_axis_title)
        fig.update_layout(legend_title="Trajectory")
        
        st.plotly_chart(fig)

        # Download button for the plot
        st.download_button(
            label=f"Download {plot_type.upper()} Plot as PNG",
            data=fig.to_image(format="png"),
            file_name=f"{plot_type.lower()}_plot.png",
            mime="image/png"
        )
        # Download button for the data
        st.download_button(
            label=f"Download {plot_type.upper()} Data as CSV",
            data=df.to_csv(index=False).encode('utf-8'),
            file_name=f"{plot_type.upper()}_data.csv",
            mime="text/csv",
        )
    except Exception as e:
        st.error(f"Error generating {plot_type.upper()} plot: {e}")

def main():
    st.image('HufflePlots.png')
    st.title("HufflePlots: Protein Molecular Dynamics *Harry Plotter*")

    st.sidebar.title("Options")
    unit = st.sidebar.radio("Choose the unit for y-axis:", ("Å", "nm"), key='unit_selection')

    tab1, tab2, tab3 = st.tabs(["Pre-processing: GROMACS .xvg files", "Pre-processing: .txt files", "Direct Plotting: .csv/.tsv files"])

    with tab1:
        st.header("Step 1: Process GROMACS .xvg files")
        st.info("Upload your .xvg files from GROMACS. The script will automatically identify them as RMSD or RMSF, process them, and generate plots.")
        
        xvg_files = st.file_uploader("Upload .xvg files", type="xvg", accept_multiple_files=True, key="xvg_uploader")

        if xvg_files:
            rmsd_data = []
            rmsf_data = []
            with st.spinner('Processing .xvg files...'):
                for file in xvg_files:
                    content = file.getvalue().decode("utf-8")
                    file_type, output_name, data_lines = process_xvg_content(content, file.name)
                    
                    if file_type == 'rmsd':
                        rmsd_data.append({'name': output_name, 'data': data_lines})
                    elif file_type == 'rmsf':
                        rmsf_data.append({'name': output_name, 'data': data_lines})

            if rmsd_data:
                st.subheader("RMSD Results")
                rmsd_df = create_df_from_processed_xvg(rmsd_data)
                if rmsd_df is not None:
                    st.dataframe(rmsd_df.head())
                    plot_data(rmsd_df, "RMSD", unit)
            
            if rmsf_data:
                st.subheader("RMSF Results")
                rmsf_df = create_df_from_processed_xvg(rmsf_data)
                if rmsf_df is not None:
                    st.dataframe(rmsf_df.head())
                    plot_data(rmsf_df, "RMSF", unit)
            
            if not rmsd_data and not rmsf_data:
                st.error("Could not identify any valid RMSD or RMSF data in the uploaded .xvg files.")

    with tab2:
        st.header("Step 2: Process pre-formatted .txt files")
        st.info("If you have already converted your data to two-column .txt files (Model/Residue vs. Value), you can upload them here.")
        
        st.subheader("Upload RMSD .txt files")
        rmsd_txt_files = st.file_uploader("Upload RMSD files", type="txt", accept_multiple_files=True, key="rmsd_txt_uploader")
        
        st.subheader("Upload RMSF .txt files")
        rmsf_txt_files = st.file_uploader("Upload RMSF files", type="txt", accept_multiple_files=True, key="rmsf_txt_uploader")
        
        if rmsd_txt_files:
            with st.spinner('Processing RMSD .txt files...'):
                rmsd_df = create_df_from_txt_files(rmsd_txt_files, 'rmsd')
                if rmsd_df is not None:
                    st.subheader("RMSD Results")
                    st.dataframe(rmsd_df.head())
                    plot_data(rmsd_df, "RMSD", unit)

        if rmsf_txt_files:
            with st.spinner('Processing RMSF .txt files...'):
                rmsf_df = create_df_from_txt_files(rmsf_txt_files, 'rmsf')
                if rmsf_df is not None:
                    st.subheader("RMSF Results")
                    st.dataframe(rmsf_df.head())
                    plot_data(rmsf_df, "RMSF", unit)

    with tab3:
        st.header("Direct Plotting from .csv/.tsv files")
        st.info("Upload a consolidated .csv or .tsv file for direct plotting.")

        rmsd_csv_file = st.file_uploader("Upload RMSD File (CSV/TSV)", type=["csv", "tsv"], key="rmsd_csv_uploader")
        rmsf_csv_file = st.file_uploader("Upload RMSF File (CSV/TSV)", type=["csv", "tsv"], key="rmsf_csv_uploader")
        
        if rmsd_csv_file:
            try:
                rmsd_df = pd.read_csv(rmsd_csv_file, sep=None, engine='python')
                st.subheader("RMSD Results")
                st.dataframe(rmsd_df.head())
                plot_data(rmsd_df, "RMSD", unit)
            except Exception as e:
                st.error(f"Failed to read RMSD file: {e}")
                
        if rmsf_csv_file:
            try:
                rmsf_df = pd.read_csv(rmsf_csv_file, sep=None, engine='python')
                st.subheader("RMSF Results")
                st.dataframe(rmsf_df.head())
                plot_data(rmsf_df, "RMSF", unit)
            except Exception as e:
                st.error(f"Failed to read RMSF file: {e}")

if __name__ == "__main__":
    main()

```

