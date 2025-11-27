# Scripts Útilitários Gerais - Versão 0.1

## Manejo de Bibliotecas/Pacotes Python Isolado - Ambiente Python (venv) 

### Contexto e Objetivo
* **OBJETIVO:** Criar ambiente isolado específico Python para upload de pacotes e bibliotecas sem conflito com a máquina.
* **SITUAÇÃO:** Utilizado para upload de `requirements.txt` de ferramentas **Python**, permitindo o funcionamento de um software/ferramenta com todas as dependencias necessárias sem riscos de conflitos.
      * ***Exemplo:*** Executar uma webferramenta do `Streamlit` localmente.

### 1. Pré-Requisitos e Configuração Inicial
* Para que seja possível criar ambiente python, é necessário ter **`Python`**  instalado em versão igual o maior a 3.10.
       * Averiguando a existência de Python e versão:
  
            ```bash
                 # Em PowerShell/VSCode: (Funciona tanto em Windows quanto Linux)
                 python --version
                 # Outra alternativa:
                 python3 --version
            ```
         
          ```bash
                 # Em PowerShell/VSCode: (Funciona tanto em Windows quanto Linux)
                 python --version
                 # Outra alternativa:
                 python3 --version
          ```

  
