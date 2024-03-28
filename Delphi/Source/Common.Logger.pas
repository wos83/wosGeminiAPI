unit Common.Logger;

interface

uses
   System.Classes,
   System.SysUtils,
   System.IOUtils,

   FireDAC.Stan.Intf,
   FireDAC.Stan.Def,
   FireDAC.Stan.Option,
   FireDAC.Stan.Error,
   FireDAC.Stan.Pool,
   FireDAC.Stan.Param,
   FireDAC.Stan.ASync,

   FireDAC.UI.Intf,

   {$IFDEF MSWINDOWS}
   FireDAC.VCLUI.Wait,
   {$ENDIF}
   {$IF DEFINED (ANDROID) || (IOS)}
   FireDAC.FMXUI.Wait,
   {$ENDIF}
   FireDAC.DatS,

   FireDAC.DApt,
   FireDAC.DApt.Intf,

   FireDAC.Comp.DataSet,
   FireDAC.Comp.Client,
   FireDAC.Comp.UI,

   FireDAC.Phys.Intf,
   FireDAC.Phys.Meta,
   FireDAC.Phys,

   FireDAC.Phys.SQLite,
   FireDAC.Phys.SQLiteMeta,

   {$IF COMPILERVERSION >= 33}
   FireDAC.Phys.SQLiteCli,
   FireDAC.Phys.SQLiteDef,
   FireDAC.Phys.SQLiteVDataSet,
   FireDAC.Phys.SQLiteWrapper,
   FireDAC.Phys.SQLiteWrapper.Stat,
   {$ENDIF}
   Data.DB;

type
   TLogger = class
   private
      class var FInstance: TLogger;
      class var FDGUIxWaitCursor: TFDGUIxWaitCursor;

      function CreateTableLogs(out AConn: TFDConnection): boolean;
      { Private declarations }
   public
      constructor Create;
      destructor Destroy; override;

      class function getInstance: TLogger; static;
      class property Instance: TLogger read getInstance;

      procedure LogDebug(ADescription: string);
      procedure LogApp(ADescription: string); overload;
      procedure LogApp(ADescription, ADebug: string); overload;
      procedure LogAppError(ADescription, AError: string); overload;
      procedure LogAppSQL(ADescription, AError, ASQL: string);
      procedure LogAppREST(ADescription, AError, ASQL, AMethod, AURI, AParam, ARequestJSON, AResponseJSON: string);
      { Public declarations }
   end;

var
   Logg: TLogger;

const
   DIR_LOGS = 'Logs';

   SQL_CREATE_TABLE_LOGS = //
      'CREATE TABLE IF NOT EXISTS LOGS (' + sLineBreak + //
      'ID_LOG INTEGER PRIMARY KEY AUTOINCREMENT' + sLineBreak + //
      ',DS_LOG TEXT' + sLineBreak + //
      ',DS_DEBUG TEXT' + sLineBreak + //
      ',DS_ERRO TEXT' + sLineBreak + //
      ',DS_SQL TEXT' + sLineBreak + //
      ',DS_REST VARCHAR(255)' + sLineBreak + //
      ',DS_REST_URI VARCHAR(255)' + sLineBreak + //
      ',DS_REST_PARAM TEXT' + sLineBreak + //
      ',DS_REST_REQUEST TEXT' + sLineBreak + //
      ',DS_REST_RESPONSE TEXT' + sLineBreak + //
      ',DT_REG_INS DATETIME DEFAULT CURRENT_TIMESTAMP' + sLineBreak + //
      ')' + sLineBreak + //
      '';

implementation

constructor TLogger.Create;
begin
   inherited Create;
   FDGUIxWaitCursor := TFDGUIxWaitCursor.Create(nil);
   FDGUIxWaitCursor.ScreenCursor := gcrNone;
   FDGUIxWaitCursor.Provider := 'Forms';
end;

destructor TLogger.Destroy;
begin
   inherited;
   FreeAndNil(FDGUIxWaitCursor);
   FreeAndNil(FInstance);
end;

class function TLogger.getInstance: TLogger;
begin
   Result := FInstance;
end;

function TLogger.CreateTableLogs(out AConn: TFDConnection): boolean;
var
   LNow: string;
   LDir: string;
   LFile: string;

   LConn: TFDConnection;
   LQry: TFDQuery;
   LSQL: string;
const
   cLogFile = '%s.sdb';
begin
   {$IFDEF DEBUG}
   Result := False;

   LConn := TFDConnection.Create(nil);
   LConn.LoginPrompt := False;

   LConn.DriverName := 'SQLite';
   {$IF COMPILERVERSION >= 33}
   LConn.Params.DriverID := 'SQLite';
   {$ENDIF}
   LNow := FormatDateTime('yyyymmdd', Now);

   {$IFDEF MSWINDOWS}
   LDir := ExtractFileDir(ParamStr(0)) + PathDelim + DIR_LOGS + PathDelim + LNow;
   {$ENDIF}
   {$IFDEF ANDROID}
   LDir := TPath.GetDocumentsPath + PathDelim + DIR_LOGS + PathDelim + LNow;
   {$ENDIF}
   if not DirectoryExists(LDir) then
      ForceDirectories(LDir);

   LFile := LDir + PathDelim + Format(cLogFile, [LNow]);
   LConn.Params.Values['Database'] := LFile;
   LConn.Params.Values['Synchronous'] := 'Full';
   LConn.Params.Values['LockingMode'] := 'Normal';
   LConn.Params.Values['SharedCache'] := 'False';
   LConn.Params.Values['StringFormat'] := 'Unicode';
   LConn.Params.Values['UpdateOptions.LockWait'] := 'True';

   AConn.Assign(LConn);

   LQry := TFDQuery.Create(nil);
   try
      LQry.Connection := LConn;
      try
         LSQL := SQL_CREATE_TABLE_LOGS;
         LQry.ExecSQL(LSQL);
         Result := True;
      except
         on E: Exception do
         begin
            // Logg.LogAppSQL( //
            // 'TLog.CreateTableLogs' //
            // , E.ClassName + '. ' + E.Message //
            // , LSQL);

            Logg.LogDebug( //
               'TLog.CreateTableLogs' + sLineBreak + //
               E.ClassName + '. ' + E.Message + sLineBreak + //
               LSQL);
         end;
      end;
   finally
      {$IFDEF MSWINDOWS}
      FreeAndNil(LQry);
      FreeAndNil(LConn);
      {$ELSE}
      LQry.DisposeOf;
      LConn.DisposeOf;
      {$ENDIF}
   end;
   {$ENDIF}
end;

procedure TLogger.LogDebug(ADescription: string);
var
   LNow: string;
   LDir: string;
   LFile: string;

   LSL: TStringList;
const
   cLogFile = '%s.log';
begin
   {$IFDEF DEBUG}
   // TThread.CreateAnonymousThread(
   TThread.Queue(nil,
      procedure
      begin
         LNow := FormatDateTime('yyyymmdd', Now);
         LFile := Format(cLogFile, [LNow]);

         {$IFDEF MSWINDOWS}
         LDir := ExtractFileDir(ParamStr(0)) + PathDelim + DIR_LOGS + PathDelim + LNow;
         {$ENDIF}
         {$IFDEF ANDROID}
         LDir := TPath.GetDocumentsPath + PathDelim + DIR_LOGS + PathDelim + LNow;
         {$ENDIF}
         if not DirectoryExists(LDir) then
            ForceDirectories(LDir);

         LFile := LDir + PathDelim + Format(cLogFile, [LNow]);

         LSL := TStringList.Create;
         try
            if FileExists(LFile) then
               LSL.LoadFromFile(LFile, TEncoding.UTF8);

            LNow := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now);
            LSL.Insert(0, LNow + ' ' + Trim(ADescription));

            TThread.Synchronize(nil,
               procedure
               begin
                  LSL.SaveToFile(LFile, TEncoding.UTF8);
               end);
         finally
            {$IFDEF MSWINDOWS}
            FreeAndNil(LSL);
            {$ELSE}
            LSL.DisposeOf;
            {$ENDIF}
         end;
      end);
   {$ENDIF}
end;

procedure TLogger.LogApp(ADescription: string);
var
   LConn: TFDConnection;
   LQry: TFDQuery;
   LSQL: string;

   LError: string;
begin
   {$IFDEF DEBUG}
   LConn := TFDConnection.Create(nil);

   if CreateTableLogs(LConn) then
   begin
      LQry := TFDQuery.Create(nil);
      try
         LSQL := 'INSERT INTO LOGS (DS_LOG) VALUES (:DS_LOG)';
         LQry.Name := 'QryTemp' + FormatDateTime('yyyymddhhnnsszzz', Now);
         LQry.Close;
         LQry.Connection := LConn;
         LQry.SQL.Clear;
         LQry.SQL.Text := Trim(LSQL);

         // Logg.LogDebug('DEBUG: TLog.LogApp' + sLineBreak + LSQL);

         try
            LQry.Params.ParamByName('DS_LOG').AsString := Trim(ADescription);
            LQry.ExecSQL;
         except
            on E: Exception do
            begin
               LError := 'Error: ' + E.ClassName + '. ' + E.Message + sLineBreak + LSQL;
               Logg.LogDebug(LError);
               Exit;
            end;
         end;
      finally
         {$IFDEF MSWINDOWS}
         FreeAndNil(LQry);
         FreeAndNil(LConn);
         {$ENDIF}
         {$IFDEF ANDROID}
         LQry.DisposeOf;
         LConn.DisposeOf;
         {$ENDIF}
      end;
   end;
   {$ENDIF}
end;

procedure TLogger.LogApp(ADescription, ADebug: string);
var
   LConn: TFDConnection;
   LQry: TFDQuery;
   LSQL: string;

   LError: string;
begin
   {$IFDEF DEBUG}
   LConn := TFDConnection.Create(nil);

   if CreateTableLogs(LConn) then
   begin
      LQry := TFDQuery.Create(nil);
      try
         LSQL := 'INSERT INTO LOGS (DS_LOG,DS_DEBUG) VALUES (:DS_LOG,:DS_DEBUG)';
         LQry.Name := 'QryTemp' + FormatDateTime('yyyymddhhnnsszzz', Now);
         LQry.Close;
         LQry.Connection := LConn;
         LQry.SQL.Clear;
         LQry.SQL.Text := Trim(LSQL);

         // Logg.LogDebug('DEBUG: TLog.LogApp' + sLineBreak + LSQL);

         try
            LQry.Params.ParamByName('DS_LOG').AsString := Trim(ADescription);
            LQry.Params.ParamByName('DS_DEBUG').AsString := Trim(ADebug);
            LQry.ExecSQL;
         except
            on E: Exception do
            begin
               LError := 'Error: ' + E.ClassName + '. ' + E.Message + sLineBreak + LSQL;
               Logg.LogDebug(LError);
               Exit;
            end;
         end;
      finally
         {$IFDEF MSWINDOWS}
         FreeAndNil(LQry);
         FreeAndNil(LConn);
         {$ENDIF}
         {$IFDEF ANDROID}
         LQry.DisposeOf;
         LConn.DisposeOf;
         {$ENDIF}
      end;
   end;
   {$ENDIF}
end;

procedure TLogger.LogAppError(ADescription, AError: string);
var
   LConn: TFDConnection;
   LQry: TFDQuery;
   LSQL: string;

   LError: string;
begin
   {$IFDEF DEBUG}
   LConn := TFDConnection.Create(nil);

   if CreateTableLogs(LConn) then
   begin
      LQry := TFDQuery.Create(nil);
      try
         LSQL := 'INSERT INTO LOGS (DS_LOG,DS_ERRO) VALUES (:DS_LOG,:DS_ERRO)';
         LQry.Name := 'QryTemp' + FormatDateTime('yyyymddhhnnsszzz', Now);
         LQry.Close;
         LQry.Connection := LConn;
         LQry.SQL.Clear;
         LQry.SQL.Text := Trim(LSQL);

         // Logg.LogDebug('DEBUG: TLog.LogApp' + sLineBreak + LSQL);

         try
            LQry.Params.ParamByName('DS_LOG').AsString := Trim(ADescription);
            LQry.Params.ParamByName('DS_ERRO').AsString := Trim(AError);
            LQry.ExecSQL;
         except
            on E: Exception do
            begin
               LError := 'Error: ' + E.ClassName + '. ' + E.Message + sLineBreak + LSQL;
               Logg.LogDebug(LError);
               Exit;
            end;
         end;
      finally
         {$IFDEF MSWINDOWS}
         FreeAndNil(LQry);
         FreeAndNil(LConn);
         {$ENDIF}
         {$IFDEF ANDROID}
         LQry.DisposeOf;
         LConn.DisposeOf;
         {$ENDIF}
      end;
   end;
   {$ENDIF}
end;

procedure TLogger.LogAppSQL(ADescription, AError, ASQL: string);
var
   LConn: TFDConnection;
   LQry: TFDQuery;
   LSQL: string;

   LError: string;
begin
   {$IFDEF DEBUG}
   LConn := TFDConnection.Create(nil);

   if CreateTableLogs(LConn) then
   begin
      LQry := TFDQuery.Create(nil);
      try
         LSQL := 'INSERT INTO LOGS (DS_LOG,DS_ERRO,DS_SQL) VALUES (:DS_LOG,:DS_ERRO,:DS_SQL)';

         LQry.Name := 'QryTemp' + FormatDateTime('yyyymddhhnnsszzz', Now);
         LQry.Close;
         LQry.Connection := LConn;
         LQry.SQL.Clear;
         LQry.SQL.Text := Trim(LSQL);

         // Logg.LogDebug('DEBUG: TLog.LogAppSQL' + sLineBreak + LSQL);

         try
            LQry.Params.ParamByName('DS_LOG').AsString := Trim(ADescription);
            LQry.Params.ParamByName('DS_ERRO').AsString := Trim(AError);
            LQry.Params.ParamByName('DS_SQL').AsString := Trim(ASQL);
            LQry.ExecSQL;
         except
            on E: Exception do
            begin
               LError := 'Error: ' + E.ClassName + '. ' + E.Message + sLineBreak + LSQL;
               LogDebug(LError);
               Exit;
            end;
         end;
      finally
         {$IFDEF MSWINDOWS}
         FreeAndNil(LQry);
         FreeAndNil(LConn);
         {$ENDIF}
         {$IFDEF ANDROID}
         LQry.DisposeOf;
         LConn.DisposeOf;
         {$ENDIF}
      end;
   end;
   {$ENDIF}
end;

procedure TLogger.LogAppREST(ADescription, AError, ASQL, AMethod, AURI, AParam, ARequestJSON, AResponseJSON: string);
var
   LConn: TFDConnection;
   LQry: TFDQuery;
   LSQL: string;

   LError: string;
begin
   {$IFDEF DEBUG}
   LConn := TFDConnection.Create(nil);

   if CreateTableLogs(LConn) then
   begin
      LQry := TFDQuery.Create(nil);
      try
         LSQL := //
            'INSERT INTO LOGS (' + sLineBreak + //
            'DS_LOG,DS_ERRO,DS_SQL,DS_REST,DS_REST_URI,DS_REST_PARAM,DS_REST_REQUEST,DS_REST_RESPONSE' + sLineBreak + //
            ') VALUES (' + sLineBreak + //
            ':DS_LOG,:DS_ERRO,:DS_SQL,:DS_REST,:DS_REST_URI,:DS_REST_PARAM,:DS_REST_REQUEST,:DS_REST_RESPONSE' + sLineBreak + //
            ')';

         LQry.Name := 'QryTemp' + FormatDateTime('yyyymddhhnnsszzz', Now);
         LQry.Close;
         LQry.Connection := LConn;
         LQry.SQL.Clear;
         LQry.SQL.Text := Trim(LSQL);

         // Logg.LogDebug('DEBUG: TLog.LogAppREST' + sLineBreak + LSQL);

         try
            LQry.Params.ParamByName('DS_LOG').AsString := Trim(ADescription);
            LQry.Params.ParamByName('DS_ERRO').AsString := Trim(AError);
            LQry.Params.ParamByName('DS_SQL').AsString := Trim(ASQL);
            LQry.Params.ParamByName('DS_REST').AsString := Trim(AMethod);
            LQry.Params.ParamByName('DS_REST_URI').AsString := Trim(AURI);
            LQry.Params.ParamByName('DS_REST_PARAM').AsString := Trim(AParam);
            LQry.Params.ParamByName('DS_REST_REQUEST').AsString := Trim(ARequestJSON);
            LQry.Params.ParamByName('DS_REST_RESPONSE').AsString := Trim(AResponseJSON);
            LQry.ExecSQL;
         except
            on E: Exception do
            begin
               LError := 'Error: ' + E.ClassName + '. ' + E.Message + sLineBreak + LSQL;
               LogDebug(LError);
               Exit;
            end;
         end;
      finally
         {$IFDEF MSWINDOWS}
         FreeAndNil(LQry);
         FreeAndNil(LConn);
         {$ENDIF}
         {$IFDEF ANDROID}
         LQry.DisposeOf;
         LConn.DisposeOf;
         {$ENDIF}
      end;
   end;
   {$ENDIF}
end;

end.
