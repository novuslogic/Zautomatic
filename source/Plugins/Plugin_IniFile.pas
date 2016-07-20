unit Plugin_IniFile;

interface

uses Classes,Plugin,  uPSRuntime,  uPSCompiler, PluginsMapFactory, API_IniFile,
    uPSI_API_IniFile, MessagesLog, SysUtils;


type
  tPlugin_RegIni = class(Tplugin)
  private
  protected
    foAPI_IniFile: TAPI_IniFile;
  public
    constructor Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter); override;
    destructor Destroy; override;

    function CustomOnUses(aCompiler: TPSPascalCompiler): Boolean; override;
    procedure RegisterFunction(aExec: TPSExec); override;
    procedure SetVariantToClass(aExec: TPSExec); override;
    procedure RegisterImport; override;
  end;

implementation

constructor tPlugin_RegIni.Create(aMessagesLog: tMessagesLog; aImp: TPSRuntimeClassImporter);
begin
  Inherited;

  foAPI_IniFile := TAPI_IniFile.Create(foMessagesLog);

end;


destructor  tPlugin_RegIni.Destroy;
begin
  Inherited;

  FreeandNIl(foAPI_IniFile);
end;



function tPlugin_RegIni.CustomOnUses(aCompiler: TPSPascalCompiler): Boolean;
begin
  Result := True;

  foAPI_IniFile.oCompiler := aCompiler;

  SIRegister_API_IniFile(aCompiler);
  SIRegister_API_IniFile(aCompiler);

  AddImportedClassVariable(aCompiler, 'IniFile', 'TAPI_IniFile');




end;

procedure tPlugin_RegIni.RegisterFunction(aExec: TPSExec);
begin
end;

procedure tPlugin_RegIni.SetVariantToClass(aExec: TPSExec);
begin
  foAPI_IniFile.oExec := aExec;

  uPSRuntime.SetVariantToClass(aExec.GetVarNo(aExec.GetVar('IniFile')), foAPI_IniFile);
end;

procedure tPlugin_RegIni.RegisterImport;
begin
  RIRegister_API_IniFile(FImp);
  RIRegister_API_IniFile(FImp);
end;

Initialization
 begin
   tPluginsMapFactory.RegisterClass(tPlugin_RegIni);
 end;

end.

