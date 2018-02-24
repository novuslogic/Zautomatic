unit uPSI_API_Task;
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
  TPSImport_API_Task = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TAPI_Task(CL: TPSPascalCompiler);
procedure SIRegister_TTask(CL: TPSPascalCompiler);
procedure SIRegister_TTaskCriteria(CL: TPSPascalCompiler);
procedure SIRegister_TTaskFailed(CL: TPSPascalCompiler);
procedure SIRegister_API_Task(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAPI_Task(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTask(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTaskCriteria(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTaskFailed(CL: TPSRuntimeClassImporter);
procedure RIRegister_API_Task(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   APIBase
  ,NovusWindows
  ,API_Output
  ,Plugin_TaskRunner
  ,Project
  ,API_Task
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_API_Task]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAPI_Task(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAPIBase', 'TAPI_Task') do
  with CL.AddClassN(CL.FindClass('TAPIBase'),'TAPI_Task') do
  begin
    RegisterMethod('Constructor Create( aAPI_Output : tAPI_Output; aTaskRunner : TTaskRunner);');
    RegisterMethod('Function AddTask( const aProcedureName : String) : TTask');
    RegisterMethod('Function RunTarget( const aProcedureName : String) : boolean');
    RegisterMethod('Function RunTargets( const aProcedureNames : array of string) : boolean');
    RegisterMethod('Procedure BuildReport');
    RegisterProperty('BeforeTasks', 'TTaskEvent', iptrw);
    RegisterProperty('FinishedTasks', 'TTaskEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTask(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TTask') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TTask') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function IsDependentOn( const aProcedureName : String) : Boolean');
    RegisterProperty('ProcedureName', 'String', iptrw);
    RegisterProperty('TaskRunner', 'TTaskRunner', iptrw);
    RegisterProperty('Dependencies', 'tStringList', iptrw);
    RegisterProperty('StartBuild', 'tdatetime', iptrw);
    RegisterProperty('Duration', 'TDateTime', iptr);
    RegisterProperty('EndBuild', 'tDatetime', iptrw);
    RegisterProperty('BuildStatus', 'TBuildStatus', iptrw);
    RegisterProperty('Criteria', 'TTaskCriteria', iptrw);
    RegisterProperty('FinishedTask', 'TTaskEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTaskCriteria(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TTaskCriteria') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TTaskCriteria') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Failed', 'TtaskFailed', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTaskFailed(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TTaskFailed') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TTaskFailed') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Retry', 'integer', iptrw);
    RegisterProperty('Abort', 'Boolean', iptrw);
    RegisterProperty('Skip', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_API_Task(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TTaskEvent', 'Procedure');
  SIRegister_TTaskFailed(CL);
  SIRegister_TTaskCriteria(CL);
  SIRegister_TTask(CL);
  SIRegister_TAPI_Task(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAPI_TaskFinishedTasks_W(Self: TAPI_Task; const T: TTaskEvent);
begin Self.FinishedTasks := T; end;

(*----------------------------------------------------------------------------*)
procedure TAPI_TaskFinishedTasks_R(Self: TAPI_Task; var T: TTaskEvent);
begin T := Self.FinishedTasks; end;

(*----------------------------------------------------------------------------*)
procedure TAPI_TaskBeforeTasks_W(Self: TAPI_Task; const T: TTaskEvent);
begin Self.BeforeTasks := T; end;

(*----------------------------------------------------------------------------*)
procedure TAPI_TaskBeforeTasks_R(Self: TAPI_Task; var T: TTaskEvent);
begin T := Self.BeforeTasks; end;

(*----------------------------------------------------------------------------*)
Function TAPI_TaskCreate_P(Self: TClass; CreateNewInstance: Boolean;  aAPI_Output : tAPI_Output; aTaskRunner : TTaskRunner):TObject;
Begin Result := TAPI_Task.Create(aAPI_Output, aTaskRunner); END;

(*----------------------------------------------------------------------------*)
procedure TTaskFinishedTask_W(Self: TTask; const T: TTaskEvent);
begin Self.FinishedTask := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskFinishedTask_R(Self: TTask; var T: TTaskEvent);
begin T := Self.FinishedTask; end;

(*----------------------------------------------------------------------------*)
procedure TTaskCriteria_W(Self: TTask; const T: TTaskCriteria);
begin Self.Criteria := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskCriteria_R(Self: TTask; var T: TTaskCriteria);
begin T := Self.Criteria; end;

(*----------------------------------------------------------------------------*)
procedure TTaskBuildStatus_W(Self: TTask; const T: TBuildStatus);
begin Self.BuildStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskBuildStatus_R(Self: TTask; var T: TBuildStatus);
begin T := Self.BuildStatus; end;

(*----------------------------------------------------------------------------*)
procedure TTaskEndBuild_W(Self: TTask; const T: tDatetime);
begin Self.EndBuild := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskEndBuild_R(Self: TTask; var T: tDatetime);
begin T := Self.EndBuild; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDuration_R(Self: TTask; var T: TDateTime);
begin T := Self.Duration; end;

(*----------------------------------------------------------------------------*)
procedure TTaskStartBuild_W(Self: TTask; const T: tdatetime);
begin Self.StartBuild := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskStartBuild_R(Self: TTask; var T: tdatetime);
begin T := Self.StartBuild; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDependencies_W(Self: TTask; const T: tStringList);
begin Self.Dependencies := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskDependencies_R(Self: TTask; var T: tStringList);
begin T := Self.Dependencies; end;

(*----------------------------------------------------------------------------*)
procedure TTaskTaskRunner_W(Self: TTask; const T: TTaskRunner);
begin Self.TaskRunner := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskTaskRunner_R(Self: TTask; var T: TTaskRunner);
begin T := Self.TaskRunner; end;

(*----------------------------------------------------------------------------*)
procedure TTaskProcedureName_W(Self: TTask; const T: String);
begin Self.ProcedureName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskProcedureName_R(Self: TTask; var T: String);
begin T := Self.ProcedureName; end;

(*----------------------------------------------------------------------------*)
procedure TTaskCriteriaFailed_W(Self: TTaskCriteria; const T: TtaskFailed);
begin Self.Failed := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskCriteriaFailed_R(Self: TTaskCriteria; var T: TtaskFailed);
begin T := Self.Failed; end;

(*----------------------------------------------------------------------------*)
procedure TTaskFailedSkip_W(Self: TTaskFailed; const T: Boolean);
begin Self.Skip := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskFailedSkip_R(Self: TTaskFailed; var T: Boolean);
begin T := Self.Skip; end;

(*----------------------------------------------------------------------------*)
procedure TTaskFailedAbort_W(Self: TTaskFailed; const T: Boolean);
begin Self.Abort := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskFailedAbort_R(Self: TTaskFailed; var T: Boolean);
begin T := Self.Abort; end;

(*----------------------------------------------------------------------------*)
procedure TTaskFailedRetry_W(Self: TTaskFailed; const T: integer);
begin Self.Retry := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskFailedRetry_R(Self: TTaskFailed; var T: integer);
begin T := Self.Retry; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAPI_Task(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAPI_Task) do
  begin
    RegisterConstructor(@TAPI_TaskCreate_P, 'Create');
    RegisterMethod(@TAPI_Task.AddTask, 'AddTask');
    RegisterMethod(@TAPI_Task.RunTarget, 'RunTarget');
    RegisterMethod(@TAPI_Task.RunTargets, 'RunTargets');
    RegisterMethod(@TAPI_Task.BuildReport, 'BuildReport');
    RegisterPropertyHelper(@TAPI_TaskBeforeTasks_R,@TAPI_TaskBeforeTasks_W,'BeforeTasks');
    RegisterPropertyHelper(@TAPI_TaskFinishedTasks_R,@TAPI_TaskFinishedTasks_W,'FinishedTasks');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTask(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTask) do
  begin
    RegisterConstructor(@TTask.Create, 'Create');
    RegisterMethod(@TTask.IsDependentOn, 'IsDependentOn');
    RegisterPropertyHelper(@TTaskProcedureName_R,@TTaskProcedureName_W,'ProcedureName');
    RegisterPropertyHelper(@TTaskTaskRunner_R,@TTaskTaskRunner_W,'TaskRunner');
    RegisterPropertyHelper(@TTaskDependencies_R,@TTaskDependencies_W,'Dependencies');
    RegisterPropertyHelper(@TTaskStartBuild_R,@TTaskStartBuild_W,'StartBuild');
    RegisterPropertyHelper(@TTaskDuration_R,nil,'Duration');
    RegisterPropertyHelper(@TTaskEndBuild_R,@TTaskEndBuild_W,'EndBuild');
    RegisterPropertyHelper(@TTaskBuildStatus_R,@TTaskBuildStatus_W,'BuildStatus');
    RegisterPropertyHelper(@TTaskCriteria_R,@TTaskCriteria_W,'Criteria');
    RegisterPropertyHelper(@TTaskFinishedTask_R,@TTaskFinishedTask_W,'FinishedTask');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTaskCriteria(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTaskCriteria) do
  begin
    RegisterConstructor(@TTaskCriteria.Create, 'Create');
    RegisterPropertyHelper(@TTaskCriteriaFailed_R,@TTaskCriteriaFailed_W,'Failed');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTaskFailed(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTaskFailed) do
  begin
    RegisterConstructor(@TTaskFailed.Create, 'Create');
    RegisterPropertyHelper(@TTaskFailedRetry_R,@TTaskFailedRetry_W,'Retry');
    RegisterPropertyHelper(@TTaskFailedAbort_R,@TTaskFailedAbort_W,'Abort');
    RegisterPropertyHelper(@TTaskFailedSkip_R,@TTaskFailedSkip_W,'Skip');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_API_Task(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTaskFailed(CL);
  RIRegister_TTaskCriteria(CL);
  RIRegister_TTask(CL);
  RIRegister_TAPI_Task(CL);
end;



{ TPSImport_API_Task }
(*----------------------------------------------------------------------------*)
procedure TPSImport_API_Task.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_API_Task(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_API_Task.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_API_Task(ri);
end;
(*----------------------------------------------------------------------------*)


end.
