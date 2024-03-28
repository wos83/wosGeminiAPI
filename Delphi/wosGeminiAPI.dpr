program wosGeminiAPI;

uses
   System.ShareMem,
   System.Classes,
   System.SysUtils,

   Vcl.Forms,

   Common.Logger in 'Source\Common.Logger.pas',
   WebCookies in 'Source\WebCookies.pas',
   CoreWebView2 in 'Source\CoreWebView2.pas',   

   uFrmMain in 'Source\uFrmMain.pas' {FrmMain};

{$R *.res}

begin
   Application.Initialize;

   Application.Title := 'Delphi & Python | Gemini (Google) @WOS83';

   Application.MainFormOnTaskbar := True;
   Application.CreateForm(TFrmMain, FrmMain);

   FrmMain.pyEngine.DllPath := ExtractFileDir(ParamStr(0));
   FrmMain.pyEngine.DllName := 'python312.dll';

   Application.Run;

end.
