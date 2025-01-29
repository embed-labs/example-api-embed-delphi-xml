![image](https://github.com/user-attachments/assets/c8033b14-cc43-456d-89df-18b79b3fe5ef)

# Exemplo demonstrativo para o uso da API Embed no envio de XML

Este repositório demonstra como utilizar a API Embed para envio e processamento de XMLs no servidor de armazenamento, com recursos avançados de IA e ML.  

---

## Instalação

### Requisitos
- **Delphi**: É necessário ter o Delphi instalado em sua máquina.
- **Versão de Delphi recomendada**: Verifique a compatibilidade com o projeto.

### Clonar o repositório
Clone o repositório para sua máquina local:
```bash
git clone https://github.com/embed-labs/example-api-embed-delphi-xml.git
```

### Configurações
1. Acesse o diretório clonado.
2. Abra o projeto na IDE do Delphi.

---

## Sobre o exemplo

Este exemplo contém dois itens fundamentais:

1. **`embed_api.pas`**  
   Contém as implementações dos métodos de transação/operação com XML.  
2. **`embed_ui.pas`**  
   Interface gráfica simplificada que consome os métodos da API.  

---

## API

### Fluxo
O fluxo de uso da API segue os seguintes passos:  

- Configurar o acesso com as credenciais (Gerar Token).  
- Escolher uma das modalidades de envio:  
  - Por conteúdo XML (String).  
  - Por caminho absoluto do arquivo.  
  - Por arquivo compactado (ZIP ou RAR).  
- Consultar o status do processamento (opcional).  

---

## Métodos

### 1. Configurar

#### Credenciais
Passe as credenciais abaixo para que a função gere o token:
```delphi
ACCESS_KEY := '';
SECRET_KEY := '';
ID_PDV := '';
```

#### Uso
Este método realiza a autenticação na API, gerando um token válido para as operações subsequentes.

#### Retornos
- **0**: Sucesso.  
- **-1**: Erro ao gerar o token (verifique as credenciais ou a conexão).

---

### 2. Enviar XML

#### Assinatura
```delphi
function Xml(const Content: string): string;
```

#### Uso
Envia o conteúdo XML como string para processamento.  

#### Retornos
- **0**: Sucesso.  
- **1**: Em processamento.  
- **-1**: Falha no envio.

---

### 3. Enviar Arquivo (Path, ZIP ou RAR)

#### Assinatura
```delphi
function Path(const PathFile: string): string;
function Zip(const PathZip: string): string;
function Rar(const PathRar: string): string;
```

#### Uso
Permite o envio de arquivos XML diretamente por caminho absoluto, ou arquivos compactados no formato ZIP ou RAR.  

#### Retornos
- **0**: Sucesso.  
- **1**: Em processamento.  
- **-1**: Falha no envio.

---

### 4. Consultar Status

#### Assinatura
```delphi
function GetStatus: string;
```

#### Uso
Consulta o status de um arquivo enviado anteriormente, utilizando o identificador de análise (`FILE_ANALYZE_ID`).

#### Retornos
- **1**: Processamento concluído.  
- **0**: Em processamento.  
- **-1**: Erro ou status inválido.

---

## Retornos

| Código | Mensagem                     |
|--------|-------------------------------|
| 0      | Sucesso                      |
| -1     | Erro                         |
| -2     | Deserialize                  |
| -3     | ProviderError                |
| -41    | XmlError                     |
| -42    | XmlMissingParameter          |
| -43    | XmlInvalidOperation          |
| -44    | XmlInputBadFormat            |

| Status Code | Status Message            |
|-------------|----------------------------|
| -1          | Erro                      |
| 0           | Iniciado & Finalizado      |
| 1           | Processando               |

---
