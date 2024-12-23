program exemple_embed_xml;

uses
  Vcl.Forms,
  embed_lib in 'embed_lib.pas',
  embed_api in 'embed_api.pas',
  Vcl.Themes,
  Vcl.Styles,
  embed_ui in 'embed_ui.pas' {EmbedUi};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Charcoal Dark Slate');
  Application.CreateForm(TEmbedUi, EmbedUi);
  Application.Run;
end.
