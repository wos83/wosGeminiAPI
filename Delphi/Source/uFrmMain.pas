unit uFrmMain;

interface

uses
   System.Character,
   System.Classes,
   System.IOUtils,
   System.Sharemem,
   System.StrUtils,
   System.SysUtils,
   System.Threading,
   System.Variants,

   Vcl.ComCtrls,
   Vcl.Controls,
   Vcl.Dialogs,
   Vcl.Edge,
   Vcl.ExtCtrls,
   Vcl.Forms,
   Vcl.Graphics,
   Vcl.StdCtrls,

   Winapi.WebView2,
   Winapi.ActiveX,
   Winapi.Messages,
   Winapi.Windows,

   Vcl.PythonGUIInputOutput,
   PythonEngine,

   Data.DB,
   FireDAC.Stan.Intf,
   FireDAC.Stan.Option,
   FireDAC.Stan.Error,
   FireDAC.UI.Intf,
   FireDAC.Phys.Intf,
   FireDAC.Stan.Def,
   FireDAC.Stan.Pool,
   FireDAC.Stan.Async,
   FireDAC.Phys,
   FireDAC.VCLUI.Wait,
   FireDAC.Stan.ExprFuncs,
   FireDAC.Phys.SQLiteWrapper.Stat,
   FireDAC.Phys.SQLiteDef,
   FireDAC.Stan.Param,
   FireDAC.DatS,
   FireDAC.DApt.Intf,
   FireDAC.DApt,
   FireDAC.Comp.DataSet,
   FireDAC.Comp.Client,
   FireDAC.Phys.SQLite,
   FireDAC.Comp.UI;

type
   TFrmMain = class(TForm)
      mmoResponse: TMemo;
      mmoChat: TMemo;
      mmoCode: TMemo;
      svN1: TSplitter;

      pyEngine: TPythonEngine;
      pyInOut: TPythonGUIInputOutput;
      pyInOutNot: TPythonGUIInputOutput;

      pnlContent: TPanel;
      btnOK: TButton;

      pgcMain: TPageControl;
      tsResponse: TTabSheet;
      tsHTML: TTabSheet;
      ebResponse: TEdgeBrowser;

      procedure FormCreate(Sender: TObject);
      procedure FormShow(Sender: TObject);
      procedure btnOKClick(Sender: TObject);

   private
      FChat: string;
      FCode: string;
      { Private declarations }
   public
      { Public declarations }
   end;

var
   FrmMain: TFrmMain;

implementation
{$R *.dfm}

uses
   Common.Logger;

function RemoveAccents(AStr: string): string;
const
   comAcento = 'àáâãäåçèéêëìíîïðñòóôõöùúûüýÿÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝ';
   semAcento = 'aaaaaaceeeeiiiidnooooouuuuyyAAAAAACEEEEIIIIDNOOOOOUUUUY';
var
   I: Integer;
begin
   Result := '';
   for I := 1 to Length(AStr) do
   begin
      if Pos(AStr[I], comAcento) > 0 then
         Result := Result + semAcento[Pos(AStr[I], comAcento)]
      else
         Result := Result + AStr[I];
   end;
end;

function OnlyANSI(AStr: string): string;
var
   I: Integer;
begin
   Result := '';
   for I := 1 to Length(AStr) do
   begin
      if (Ord(AStr[I]) <= 255) and (CharInSet(AStr[I], ['0' .. '9', 'A' .. 'Z', 'a' .. 'z'])) then
         Result := Result + AStr[I];
   end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
   pgcMain.ActivePage := tsHTML;

   mmoCode.Visible := False;
   mmoCode.Enabled := False;

   Self.ShowHint := True;
   Self.KeyPreview := True;
   Self.Position := TPosition.poDesktopCenter;
   Self.WindowState := TWindowState.wsMaximized;

   Self.Caption := Application.Title;

   mmoResponse.Font.Size := 11;
   mmoResponse.Lines.Clear;

   mmoChat.Font.Size := 11;
   mmoChat.Lines.Clear;

   {$IFDEF DEBUG}
   // mmoChat.Lines.Text := //
   // 'Quais são os eventos históricos aconteceram nesta data de hoje ' + //
   // FormatDateTime('dd/mm', Now) + //
   // ' no Brasil' + //
   // ' ?';

   mmoChat.Lines.Text := 'create four images of chinese panda eating bamboo in the forest, panoramic perspective, photorealistic, ultra-realistic, high-definition, cinematic, hdr, 8k';
   {$ENDIF}
   pyEngine.InitThreads := True;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
   mmoChat.SetFocus;
end;

procedure TFrmMain.btnOKClick(Sender: TObject);
var
   LDirectory: string;
   LResponse: string;
begin
   pgcMain.ActivePage := tsHTML;

   mmoResponse.Lines.Clear;

   pyEngine.IO := pyInOut;
   pyInOut.Output.Lines.Clear;

   FChat := RemoveAccents(mmoChat.Lines.Text);
   TLogger.Instance.LogApp('Pergunta do Chat', FChat);

   LDirectory := ExtractFilePath(ParamStr(0));
   LDirectory := StringReplace(LDirectory, '\', '\\', [rfReplaceAll]);

   FCode := StringReplace(mmoCode.Text, '#directory', LDirectory, [rfReplaceAll]);
   FCode := StringReplace(FCode, '#prompt', FChat, [rfReplaceAll]);

   TLogger.Instance.LogApp('Código Python', FCode);

   mmoResponse.Lines.Clear;
   try
      Screen.Cursor := crSQLWait;
      try
         TThread.Queue(TThread.Current,
            procedure
            var
               FConn: TFDConnection;
               FQry: TFDQuery;
               LHtml: string;
            begin
               try
                  pyInOut.Output.Lines.Clear;
                  pyEngine.ExecString(UTF8Encode(FCode), EmptyStr);

                  TThread.Synchronize(TThread.CurrentThread,
                     procedure
                     begin
                        LResponse := pyInOut.Output.Lines.Text;

                        TLogger.Instance.LogAppREST( //
                           EmptyStr // ADescription//
                           , EmptyStr // AError//
                           , EmptyStr // ASQL//
                           , EmptyStr // AMethod//
                           , EmptyStr // AURI//
                           , FCode // AParam//
                           , FChat // ARequestJSON//
                           , LResponse // AResponseJSON//
                           );

                        FConn := TFDConnection.Create(nil);
                        FQry := TFDQuery.Create(nil);
                        try
                           FConn.LoginPrompt := False;
                           FConn.DriverName := 'SQLite';
                           FConn.Params.Database := 'results\gemini-' + FormatDateTime('yyyymmdd', Now) + '.db';

                           FQry.Connection := FConn;

                           FQry.Close;
                           FQry.Open('SELECT DS_FILE_HTML FROM GEMINI ORDER BY DT_REG_INS DESC LIMIT 1');

                           LHtml := FQry.Fields[0].AsString;
                           ebResponse.Navigate(LHtml);
                           Sleep(250);
                        finally
                           FreeAndNil(FQry);
                           FreeAndNil(FConn);
                        end;
                     end);

               except
                  on E: Exception do
                  begin
                     TLogger.Instance.LogAppError(E.ClassName, E.Message);
                     Exit;
                  end;
               end;
            end);

      finally
         Screen.Cursor := crDefault;
      end;
   except
      on E: Exception do
      begin
         TLogger.Instance.LogAppError(E.ClassName, E.Message);
         Exit;
      end;
   end;
end;

end.
