# Otimização e Modularização do HufflePlots

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

