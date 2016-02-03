unit uPSI_Zip;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

}
interface
 

 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_Zip = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TZip(CL: TPSPascalCompiler);
procedure SIRegister_Zip(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TZip(CL: TPSRuntimeClassImporter);
procedure RIRegister_Zip(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Zip
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Zip]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TZip(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TZip') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TZip') do
  begin
    RegisterMethod('Function ZipCompress : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Zip(CL: TPSPascalCompiler);
begin
  SIRegister_TZip(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TZip(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZip) do
  begin
    RegisterMethod(@TZip.ZipCompress, 'ZipCompress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Zip(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TZip(CL);
end;

 
 
{ TPSImport_Zip }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Zip.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Zip(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Zip.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Zip(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
