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
  public
    function GerarToken: string;
    function Xml(const Content: string): string;
    function Path(const PathFile: string): string;
    function Zip(const PathZip: string): string;
    function Rar(const PathRar: string): string;
    function GetStatus: string;
  end;

implementation

function TEmbedApi.GerarToken: string;
const
  ACCESS_KEY = '';
  SECRET_KEY = '';
var
  HttpClient: THttpClient;
  Payload: TStringStream;
  JSONObj: TJSONObject;
  Response: IHTTPResponse;
begin
  ID_PDV := '';

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
        Payload.Position := 0;

        HttpClient.CustomHeaders['Content-Type'] := 'application/json';
        Response := HttpClient.Post(BASE_URL + 'validateLogin', Payload);

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
      Exit('-1');
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

end.

