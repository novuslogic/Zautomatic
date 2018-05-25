unit CodeImatic;

interface

Uses cmd;
  
function codegen(aProject: string; aProjectconfig: string; aVariables: string; aWorkingdirectory: string;aOptions: string): Integer;
function codegenex(aProject: string; aProjectconfig: string; aVariables: string; aWorkingdirectory: string;aOptions: string; aPreCompatible: boolean): Integer;
function GetcodegenPath: String;

implementation


function GetcodegenPath: String;
begin
  Result := File.IncludeTrailingPathDelimiter(Environment.GetEnvironmentVar('ZCODE'));
end;

function codegen(aProject: string; aProjectconfig: string; aVariables: string; aWorkingdirectory: string;aOptions: string): Integer;
begin
  result := codegenex(aProject,aProjectconfig,aVariables,aWorkingdirectory,aOptions, false);
end;

function codegenex(aProject: string; aProjectconfig: string; aVariables: string; aWorkingdirectory: string;aOptions: string; aPreCompatible: boolean): Integer;
var
  SB: TStringBuilder;
begin
  Result := -1;
  
  if not Folder.Exists(GetcodegenPath) then 
    begin
      if not aPreCompatible then 
        RaiseException(erCustomError, 'CodeImatic.codegen Configured path [' + GetcodegenPath +'] cannot not be found.')
      else  
        RaiseException(erCustomError, 'zcodegen Configured path [' + GetcodegenPath +'] cannot not be found.');
    end;

  try
    SB:= TStringBuilder.Create;

    if not aPreCompatible then 
       SB.Append(GetcodegenPath + 'codeitmatic.codegen.exe ')
    else
       SB.Append(GetcodegenPath + 'zcodegen.exe ');
    

    SB.Append('-project ' + aProject + ' ');
    SB.Append('-projectconfig ' + aProjectconfig + ' ');

    if not aPreCompatible then  SB.Append('-consoleoutputonly ');

    if aWorkingdirectory <> '' then 
      SB.Append('-workingdirectory '+  aWorkingdirectory+ ' ');   

    if aVariables <> '' then 
       SB.Append('-var ' + aVariables + ' ');

    if aOptions <> '' then
      SB.Append(aOptions + ' ');   
  
    Output.logformat('Running: %s', [SB.ToString]);

    result := Exec(sb.ToString);
  finally
    SB.Free;
  end;
end;    
  

end.