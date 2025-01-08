
# TEmbedApi

Uma classe Delphi para integração com a API da Embed para processamento de arquivos XML, ZIP e RAR. Essa classe fornece métodos para autenticação e envio de arquivos para análise na plataforma.

---

## ⚙️ Funcionalidades

- **Autenticação (Geração de Token):** `GerarToken` realiza a autenticação na API e obtém o token para autorizações futuras.
- **Envio de XML:** `Xml` envia o conteúdo de um arquivo XML para análise.
- **Envio de Arquivo:** `Path` realiza o upload de um arquivo específico para análise.
- **Envio de Arquivo ZIP:** `Zip` envia arquivos compactados no formato ZIP para análise.
- **Envio de Arquivo RAR:** `Rar` envia arquivos compactados no formato RAR para análise.
- **Consulta de Status:** `GetStatus` consulta o status do processamento de um arquivo enviado.

---

## 🛠️ Como Usar

### 1. Instalação

Adicione o arquivo `embed_api.pas` ao seu projeto Delphi.

### 2. Configuração Inicial

- Defina o `ACCESS_KEY`, `SECRET_KEY`, e `ID_PDV` no método `GerarToken`. Recomenda-se que essas informações sejam armazenadas em um local seguro, como variáveis de ambiente ou um arquivo de configuração, em vez de estar diretamente no código.

### 3. Exemplo de Uso

```delphi
uses
  embed_api;

var
  EmbedApi: TEmbedApi;
  Status: string;
begin
  EmbedApi := TEmbedApi.Create;
  try
    // Geração do Token
    if EmbedApi.GerarToken = '0' then
    begin
      Writeln('Autenticação bem-sucedida.');

      // Envio de um arquivo XML
      Status := EmbedApi.Xml('<xml><example>test</example></xml>');
      if Status <> '-1' then
        Writeln('Arquivo enviado com sucesso! Status: ', Status)
      else
        Writeln('Falha no envio do XML.');
    end
    else
      Writeln('Falha na autenticação.');
  finally
    EmbedApi.Free;
  end;
end;
```

### 4. Métodos

#### `função GerarToken: string`
- Gera o token de autenticação.
- Retorna:
  - `0`: Token gerado com sucesso.
  - `-1`: Erro na geração do token.

#### `função Xml(const Content: string): string`
- Envia o conteúdo XML para análise.
- Parâmetros:
  - `Content`: Conteúdo XML em formato string.
- Retorna:
  - `0`: Processamento finalizado.
  - `1`: Em processamento.
  - `-1`: Falha no envio ou erro no processamento.

#### `função Path(const PathFile: string): string`
- Envia um arquivo para análise.
- Parâmetros:
  - `PathFile`: Caminho completo do arquivo.
- Retorna:
  - `0`: Processamento finalizado.
  - `1`: Em processamento.
  - `-1`: Falha no envio ou erro no processamento.

#### `função Zip(const PathZip: string): string`
- Envia um arquivo ZIP para análise.
- Parâmetros:
  - `PathZip`: Caminho completo do arquivo ZIP.
- Retorna os mesmos valores que o método `Path`.

#### `função Rar(const PathRar: string): string`
- Envia um arquivo RAR para análise.
- Parâmetros:
  - `PathRar`: Caminho completo do arquivo RAR.
- Retorna os mesmos valores que o método `Path`.

#### `função GetStatus: string`
- Consulta o status do processamento do arquivo enviado.
- Retorna:
  - `1`: Processamento finalizado.
  - `0`: Processando.
  - `-1`: Erro ou status inválido.

---

