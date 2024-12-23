unit embed_ui;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Vcl.Imaging.pngimage, embed_api;

type
  TEmbedUi = class(TForm)
    BtnXml: TButton;
    BtnPath: TButton;
    BtnZip: TButton;
    BtnRar: TButton;
    ImgEmbed: TImage;
    DlgEmbed: TOpenDialog;
    procedure BtnXmlClick(Sender: TObject);
    procedure BtnPathClick(Sender: TObject);
    procedure BtnZipClick(Sender: TObject);
    procedure BtnRarClick(Sender: TObject);
    procedure ShowStatus(Status: string);
  private
    { Private declarations }
    api: TEmbedApi;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  EmbedUi: TEmbedUi;

implementation

{$R *.dfm}

constructor TEmbedUi.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  api := TEmbedApi.Create;
  api.Configurar;
end;

procedure TEmbedUi.BtnXmlClick(Sender: TObject);
var
  ValorStr, Output: string;
begin
  ValorStr := InputBox('XML', 'Conteúdo do XML:', '');
  api.Iniciar();
  ShowStatus('[XML] Iniciado');
  Output := api.Xml(ValorStr);
  if Output = '1' then
  begin
    ShowStatus('[XML] XML (conteúdo do arquivo)');
    while Output = '1' do
    begin
      Output := api.GetStatus;
      if Output = '0' then
        ShowStatus('[XML] Enviado')
      else if Output = '-1' then
        ShowStatus('[XML] Falha no processamento')
      else
        ShowStatus('[XML] Processando');
    end;
    Output := api.Finalizar;
    if Output = '0' then
      ShowStatus('[XML] Finalizado')
    else
      ShowStatus('[XML] Falha na finalização');
  end;
end;

procedure TEmbedUi.BtnPathClick(Sender: TObject);
var
  ValorStr, Output: string;
begin
  if DlgEmbed.Execute then
  begin
    ValorStr := DlgEmbed.FileName;
    api.Iniciar();
    ShowStatus('[XML] Iniciado');
    Output := api.Path(ValorStr);
    if Output = '1' then
    begin
      ShowStatus('[XML] Path (caminho do arquivo)');
      while Output = '1' do
      begin
        Output := api.GetStatus;
        if Output = '0' then
          ShowStatus('[XML] Enviado')
        else if Output = '-1' then
          ShowStatus('[XML] Falha no processamento')
        else
          ShowStatus('[XML] Processando');
      end;
      Output := api.Finalizar;
      if Output = '0' then
        ShowStatus('[XML] Finalizado')
      else
        ShowStatus('[XML] Falha na finalização');
    end;
  end
  else
    ShowStatus('[XML] Falha ao obter path (caminho do arquivo)');
end;

procedure TEmbedUi.BtnZipClick(Sender: TObject);
var
  ValorStr, Output: string;
begin
  if DlgEmbed.Execute then
  begin
    ValorStr := DlgEmbed.FileName;
    api.Iniciar();
    ShowStatus('[XML] Iniciado');
    Output := api.Zip(ValorStr);
    if Output = '1' then
    begin
      ShowStatus('[XML] ZIP (arquivo compactado)');
      while Output = '1' do
      begin
        Output := api.GetStatus;
        if Output = '0' then
          ShowStatus('[XML] Enviado')
        else if Output = '-1' then
          ShowStatus('[XML] Falha no processamento')
        else
          ShowStatus('[XML] Processando');
      end;
      Output := api.Finalizar;
      if Output = '0' then
        ShowStatus('[XML] Finalizado')
      else
        ShowStatus('[XML] Falha na finalização');
    end;
  end
  else
    ShowStatus('[XML] Falha ao obter ZIP (arquivo compactado)');
end;

procedure TEmbedUi.BtnRarClick(Sender: TObject);
var
  ValorStr, Output: string;
begin
  if DlgEmbed.Execute then
  begin
    ValorStr := DlgEmbed.FileName;
    api.Iniciar();
    ShowStatus('[XML] Iniciado');
    Output := api.Rar(ValorStr);
    if Output = '1' then
    begin
      ShowStatus('[XML] RAR (arquivo compactado)');
      while Output = '1' do
      begin
        Output := api.GetStatus;
        if Output = '0' then
          ShowStatus('[XML] Enviado')
        else if Output = '-1' then
          ShowStatus('[XML] Falha no processamento')
        else
          ShowStatus('[XML] Processando');
      end;
      Output := api.Finalizar;
      if Output = '0' then
        ShowStatus('[XML] Finalizado')
      else
        ShowStatus('[XML] Falha na finalização');
    end;
  end
  else
    ShowStatus('[XML] Falha ao obter RAR (arquivo compactado)');
end;

procedure TEmbedUi.ShowStatus(Status: string);
begin
  ShowMessage(Status);
end;

end.
