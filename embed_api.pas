unit embed_api;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.Net.HttpClient, System.Net.URLClient, System.Net.HttpClientComponent, System.Net.Mime, System.JSON;

type
  TEmbedApi = class
  private
    const
      BASE_URL = 'https://xml.embed.it/v1/';
    var
      ID_PDV, TOKEN, FILE_ANALYZE_ID: string;
    procedure CreateLog(const LogContent: string);
  public
    function GerarToken: string;
    function Xml(const Content: string): string;
    function Path(const PathFile: string): string;
    function Zip(const PathZip: string): string;
    function Rar(const PathRar: string): string;
    function GetStatus: string;
  end;

implementation

procedure TEmbedApi.CreateLog(const LogContent: string);
var
  LogFileName, LogFilePath: string;
  LogFile: TextFile;
begin
  // Cria o nome do arquivo de log com a data e minuto no nome
  LogFileName := FormatDateTime('yyyy-mm-dd_hhnn', Now) + '_log.txt';

  // Cria o caminho completo para o arquivo de log na pasta "log"
  LogFilePath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'log');

  // Cria o diretório "log" se ele não existir
  if not DirectoryExists(LogFilePath) then
    CreateDir(LogFilePath);

  // Combina o caminho do diretório com o nome do arquivo
  LogFilePath := TPath.Combine(LogFilePath, LogFileName);

  // Abre ou cria o arquivo de log para escrita
  AssignFile(LogFile, LogFilePath);
  try
    Rewrite(LogFile);
    WriteLn(LogFile, LogContent);
  finally
    CloseFile(LogFile);
  end;
end;

function TEmbedApi.GerarToken: string;
const
  ACCESS_KEY = '214e495a@vmwiu.hic';  // Mover para uma configuração segura
  SECRET_KEY = 'U5dpx1DF2jYuN78gTdizpEa$4U1GLJFRJ6h0OJ8r';  // Mover para uma configuração segura
var
  HttpClient: THttpClient;
  Payload: TStringStream;
  JSONObj: TJSONObject;
  Response: IHTTPResponse;
begin
  ID_PDV := 'ca4b4498-2753-4753-9490-65d1bf26b344';

  if (ACCESS_KEY = '') or (SECRET_KEY = '') or (ID_PDV = '') then
    Exit('-1');

  HttpClient := THttpClient.Create;
  try
    Payload := TStringStream.Create;
    try
      JSONObj := TJSONObject.Create;
      try
        JSONObj.AddPair('accessKey', ACCESS_KEY);
        JSONObj.AddPair('secretKey', SECRET_KEY);
        Payload.WriteString(JSONObj.ToString);
        Payload.Position := 0; // Resetar a posição do payload para o início

        // Adicionar um log para verificar o conteúdo do payload
        CreateLog('Payload: ' + Payload.DataString);

        HttpClient.CustomHeaders['Content-Type'] := 'application/json';
        Response := HttpClient.Post(BASE_URL + 'validateLogin', Payload);

        // Adicionar um log para verificar a resposta
        CreateLog('Response Status Code: ' + Response.StatusCode.ToString);
        CreateLog('Response Content: ' + Response.ContentAsString);

        if Response.StatusCode = 200 then
        begin
          JSONObj := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
          if Assigned(JSONObj) then
          begin
            TOKEN := JSONObj.GetValue<string>('token');
            Exit('0');
          end;
        end
        else
          Exit('-1');
      finally
        JSONObj.Free;
      end;
    finally
      Payload.Free;
    end;
  except
    on E: Exception do
    begin
      // Log da exceção para facilitar a depuração
      CreateLog('Exception: ' + E.Message);
      Exit('-1');
    end;
  end;
end;


function TEmbedApi.Xml(const Content: string): string;
begin
  var HttpClient := THttpClient.Create;
  try
    var JSONObj := TJSONObject.Create;
    try
      JSONObj.AddPair('content', Content);
      JSONObj.AddPair('softwareHousePdvId', ID_PDV);

      var Payload := TStringStream.Create(JSONObj.ToString, TEncoding.UTF8);
      try
        HttpClient.CustomHeaders['Authorization'] := TOKEN;
        HttpClient.CustomHeaders['Content-Type'] := 'application/json';
        var Response := HttpClient.Post(BASE_URL + 'doc/xml', Payload);

        if Response.StatusCode = 200 then
        begin
          var ResponseJSON := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
          if Assigned(ResponseJSON) then
          try
            FILE_ANALYZE_ID := ResponseJSON.GetValue<string>('fileAnalyzeId');
            Result := ResponseJSON.GetValue<string>('status');
          finally
            ResponseJSON.Free;
          end;
        end
        else
          Result := '-1';
      finally
        Payload.Free;
      end;
    finally
      JSONObj.Free;
    end;
  except
    on E: Exception do
      Result := '-1';
  end;
end;

function TEmbedApi.Path(const PathFile: string): string;
begin
  if not FileExists(PathFile) then
    Exit('-1');

  var HttpClient := THttpClient.Create;
  var MultipartFormData := TMultipartFormData.Create;
  try
    MultipartFormData.AddFile('file', PathFile);
    MultipartFormData.AddField('softwareHousePdvId', ID_PDV);
    HttpClient.CustomHeaders['Authorization'] := TOKEN;
    var Response := HttpClient.Post(BASE_URL + 'doc/file', MultipartFormData);

    if Response.StatusCode = 200 then
    begin
      var JSONObj := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
      if Assigned(JSONObj) then
      try
        var Status := JSONObj.GetValue<string>('status');
        FILE_ANALYZE_ID := JSONObj.GetValue<string>('fileAnalyzeId');

        if Status = 'DONE' then
          Exit('0')
        else if (Status = 'INITIAL') or (Status = 'PROCESSING') then
          Exit('1')
        else
          Exit('-1');
      finally
        JSONObj.Free;
      end;
    end
    else
      Exit('-1');
  except
    on E: Exception do
      Exit('-1');
  end;
end;

function TEmbedApi.Zip(const PathZip: string): string;
begin
  if not FileExists(PathZip) then
    Exit('-1');

  var HttpClient := THttpClient.Create;
  var MultipartFormData := TMultipartFormData.Create;
  try
    MultipartFormData.AddFile('file', PathZip);
    MultipartFormData.AddField('softwareHousePdvId', ID_PDV);
    HttpClient.CustomHeaders['Authorization'] := TOKEN;
    var Response := HttpClient.Post(BASE_URL + 'doc/zip', MultipartFormData);

    if Response.StatusCode = 200 then
    begin
      var JSONObj := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
      if Assigned(JSONObj) then
      try
        var Status := JSONObj.GetValue<string>('status');
        FILE_ANALYZE_ID := JSONObj.GetValue<string>('fileAnalyzeId');

        if Status = 'DONE' then
          Exit('0')
        else if (Status = 'INITIAL') or (Status = 'PROCESSING') then
          Exit('1')
        else
          Exit('-1');
      finally
        JSONObj.Free;
      end;
    end
    else
      Exit('-1');
  except
    on E: Exception do
      Exit('-1');
  end;
end;

function TEmbedApi.Rar(const PathRar: string): string;
begin
  if not FileExists(PathRar) then
    Exit('-1');

  var HttpClient := THttpClient.Create;
  var MultipartFormData := TMultipartFormData.Create;
  try
    MultipartFormData.AddFile('file', PathRar);
    MultipartFormData.AddField('softwareHousePdvId', ID_PDV);
    HttpClient.CustomHeaders['Authorization'] := TOKEN;
    var Response := HttpClient.Post(BASE_URL + 'doc/rar', MultipartFormData);

    if Response.StatusCode = 200 then
    begin
      var JSONObj := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
      if Assigned(JSONObj) then
      try
        var Status := JSONObj.GetValue<string>('status');
        FILE_ANALYZE_ID := JSONObj.GetValue<string>('fileAnalyzeId');

        if Status = 'DONE' then
          Exit('0')
        else if (Status = 'INITIAL') or (Status = 'PROCESSING') then
          Exit('1')
        else
          Exit('-1');
      finally
        JSONObj.Free;
      end;
    end
    else
      Exit('-1');
  except
    on E: Exception do
      Exit('-1');
  end;
end;

function TEmbedApi.GetStatus: string;
begin
  if FILE_ANALYZE_ID.IsEmpty then
    Exit('-1');

  var URL := BASE_URL + 'doc/file/' + FILE_ANALYZE_ID;
  var HttpClient := THttpClient.Create;
  try
    HttpClient.CustomHeaders['Authorization'] := TOKEN;
    var Response := HttpClient.Get(URL);

    if Response.StatusCode = 200 then
    begin
      var JSONObj := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
      if Assigned(JSONObj) then
      try
        var Status := JSONObj.GetValue<string>('status');

        if Status = 'DONE' then
          Exit('1')
        else if Status = 'INITIAL' then
          Exit('0')
        else if Status = 'ERROR' then
          Exit('-1')
        else
          Exit('-1');
      finally
        JSONObj.Free;
      end;
    end
    else
      Exit('-1');
  except
    on E: Exception do
      Exit('-1');
  end;
end;

// Salvar um log após a execução do programa
initialization
  with TEmbedApi.Create do
  try
    CreateLog('Log de execução do programa.');
  finally
    Free;
  end;

end.

