unit Plugins;

interface

uses  MessagesLog, uPSRuntime, uPSI_MessagesLog, uPSCompiler;

type
   TPlugins = class
   private
   protected
      foMessagesLog: tMessagesLog;
      fImp: TPSRuntimeClassImporter;
   public
     constructor Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter);
     destructor Destroy;

     function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
     procedure RegisterFunctions(aExec: TPSExec);
     procedure SetVariantToClasses(aExec: TPSExec);
     procedure RegisterImports;
   end;

   function InternalWriteln(Caller: TPSExec; p: TIFExternalProcRec; Global, Stack: TPSStack): Boolean;

implementation

Uses Runtime;

constructor TPlugins.create;
begin
  foMessagesLog:= aMessagesLog;

  fImp:= aImp;
end;

destructor TPlugins.destroy;
begin
end;

function TPlugins.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Try
    TPSPascalCompiler(aCompiler).AddFunction('procedure Writeln(s: string);');

    // MessagesLog
    SIRegister_MessagesLog(aCompiler);
    AddImportedClassVariable(aCompiler, 'MessagesLog', 'TMessagesLog');

    Result := True;
  Except
    foMessagesLog.WriteExceptLog;

    Result := False;
  End;
end;

procedure TPlugins.RegisterFunctions(aExec: TPSExec);
begin
  aExec.RegisterFunctionName('WRITELN', InternalWriteln, nil, nil);

  RegisterClassLibraryRuntime(aExec, FImp);

end;

procedure TPlugins.RegisterImports;
begin
  RIRegister_MessagesLog(FImp);
end;

procedure TPlugins.SetVariantToClasses(aExec: TPSExec);
begin
  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('MESSAGESLOG')), foMessageslog);
end;

function InternalWriteln(Caller: TPSExec; p: TIFExternalProcRec; Global, Stack: TPSStack): Boolean;
var
  PStart: Cardinal;
begin
  if Global = nil then begin result := false; exit; end;
  PStart := Stack.Count - 1;

  oRuntime.oMessagesLog.WriteLog(Stack.GetString(PStart));


  Result := True;
end;



end.