unit embed_api;

interface

uses
  SysUtils, Classes, embed_lib;

type
  TEmbedApi = class
  private
    { Private declarations }
    lib: TEmbedLib;
    const
      STATUS_CODE = 'resultado.status_code';
  public
    constructor Create;
    destructor Destroy;
    function Configurar: string;
    function Iniciar: string;
    function Xml(Valor: string): string;
    function Path(Valor: string): string;
    function Zip(Valor: string): string;
    function Rar(Valor: string): string;
    function GetStatus: string;
    function Finalizar: string;
  end;

implementation

constructor TEmbedApi.Create;
begin
  lib := TEmbedLib.Create('lib-embed-x86.dll');
  inherited Create;
end;

destructor TEmbedApi.Destroy;
begin
  lib.Free;
end;

function TEmbedApi.Configurar: string;
begin
  var Produto := 'xml';
  var SubProduto := '1';
  var AccessKey := '';   // informação fornecida pelo time de integração
  var SecretKey := '';   // informação fornecida pelo time de integração
  var PdvId := '';       // informação fornecida pelo time de integração
  var Input := Produto + ';'
            + SubProduto + ';'
            + AccessKey + ';'
            + SecretKey + ';'
            + PdvId;
  var Output := lib.Configurar(Input);
end;

function TEmbedApi.Iniciar: string;
begin
  var Operacao := 'xml';
  var Output := lib.Iniciar(Operacao);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

function TEmbedApi.Xml(Valor: string): string;
begin
  var Operacao := 'enviar_xml';
  var TipoEnvio := 'xml';
  var Input := Operacao + ';'
            + TipoEnvio + ';'
            + Valor;
  var Output := lib.Processar(Input);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

function TEmbedApi.Path(Valor: string): string;
begin
  var Operacao := 'enviar_xml';
  var TipoEnvio := 'path';
  var Input := Operacao + ';'
            + TipoEnvio + ';'
            + Valor;
  var Output := lib.Processar(Input);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

function TEmbedApi.Zip(Valor: string): string;
begin
  var Operacao := 'enviar_xml';
  var TipoEnvio := 'zip';
  var Input := Operacao + ';'
            + TipoEnvio + ';'
            + Valor;
  var Output := lib.Processar(Input);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

function TEmbedApi.Rar(Valor: string): string;
begin
  var Operacao := 'enviar_xml';
  var TipoEnvio := 'rar';
  var Input := Operacao + ';'
            + TipoEnvio + ';'
            + Valor;
  var Output := lib.Processar(Input);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

function TEmbedApi.GetStatus: string;
begin
  var Operacao := 'get_status';
  var Output := lib.Processar(Operacao);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

function TEmbedApi.Finalizar: string;
begin
  var Input := '';
  var Output := lib.Finalizar(Input);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

end.

