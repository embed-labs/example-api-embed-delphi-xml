program exemple_embed_xml;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  embed_api in 'embed_api.pas',
  embed_ui in 'embed_ui.pas' {EmbedUi};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TEmbedUi, EmbedUi);
  TStyleManager.TrySetStyle('Charcoal Dark Slate');
  Application.Run;
end.
