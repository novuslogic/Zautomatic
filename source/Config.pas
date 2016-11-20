{$I Zautomatic.inc}
unit Config;

interface

Uses SysUtils, NovusXMLBO, Registry, Windows, NovusStringUtils, NovusFileUtils,
     JvSimpleXml, NovusSimpleXML, NovusList;

Const
  csOutputFile = 'Output.log';
  csConfigfile = 'zautomatic.config';

Type
   TConfigPlugins = class(Tobject)
   private
     fsPluginName: String;
     fsPluginFilename: string;
     fsPluginFilenamePathname: String;
   protected
   public
     property PluginName: String
       read fsPluginName
       write fsPluginName;

     property Pluginfilename: string
        read fsPluginfilename
        write fsPluginfilename;

     property PluginFilenamePathname: String
       read fsPluginFilenamePathname
       write fsPluginFilenamePathname;
   end;


   TConfig = Class(TNovusXMLBO)
   protected
     fConfigPluginsList: tNovusList;
     fsSolutionFilename: String;
     fsConfigfile: string;
     fsPluginPath: String;
     fsOutputFile: string;
     fsProjectConfigFileName: String;
     fsProjectFileName: String;
     fsRootPath: String;
     fbCompileOnly: Boolean;
   private
   public
     constructor Create; virtual; // override;
     destructor  Destroy; override;

     procedure LoadConfig;

     function ParseParams: Boolean;

     property SolutionFilename: String
       read fsSolutionFilename
       write fsSolutionFilename;

     property ProjectFileName: String
       read fsProjectFileName
       write fsProjectFileName;

     property ProjectConfigFileName: String
       read fsProjectConfigFileName
       write fsProjectConfigFileName;

      property OutputFile: String
        read fsOutputFile
        write fsOutputFile;

     property  RootPath: String
        read fsRootPath
        write fsRootPath;

     property Configfile: string
       read fsConfigfile
       write fsConfigfile;

     property PluginPath: String
       read fsPluginPath
       write fsPluginPath;

     property CompileOnly: Boolean
       read fbCompileOnly
       write fbCompileOnly;

     property oConfigPluginsList: tNovusList
       read fConfigPluginsList
       write fConfigPluginsList;
   End;

Var
  oConfig: tConfig;

implementation

constructor TConfig.Create;
begin
  inherited Create;

  fConfigPluginsList := tNovusList.Create(TConfigPlugins);

  fbcompileonly := False;
end;

destructor TConfig.Destroy;
begin
  fConfigPluginsList.Free;

  inherited Destroy;
end;

function TConfig.ParseParams: Boolean;
Var
  I: integer;
  fbOK: Boolean;
  lsParamStr: String;
begin
  Result := False;

  fbOK := false;
  I := 1;
  While Not fbOK do
    begin
       lsParamStr := Lowercase(ParamStr(i));

       if lsParamStr = '-solution' then
         begin
           Inc(i);
           fsSolutionFilename := Trim(ParamStr(i));

           if Trim(TNovusStringUtils.JustFilename(fsSolutionFilename)) = trim(fsSolutionFilename) then
             fsSolutionFilename := IncludeTrailingPathDelimiter(TNovusFileUtils.AbsoluteFilePath(ParamStr(i))) + Trim(ParamStr(i));

           if Not FileExists(fsSolutionFilename) then
              begin
                writeln ('-solution ' + TNovusStringUtils.JustFilename(fsSolutionFilename) + ' project filename cannot be found.');

                Exit;
              end;

           Result := True;
         end
       else
       if lsParamStr = '-project' then
         begin
           Inc(i);
           fsProjectFileName := Trim(ParamStr(i));

           if Trim(TNovusStringUtils.JustFilename(fsProjectFilename)) = trim(fsProjectFilename) then
             fsProjectFilename := IncludeTrailingPathDelimiter(TNovusFileUtils.AbsoluteFilePath(ParamStr(i))) + Trim(ParamStr(i));

           if Not FileExists(fsProjectFileName) then
              begin
                writeln ('-project ' + TNovusStringUtils.JustFilename(fsProjectFileName) + ' project filename cannot be found.');

                Exit;
              end;

           Result := True;
         end
        else
        if lsParamStr = '-projectconfig' then
         begin
           Inc(i);
           fsProjectConfigFileName := Trim(ParamStr(i));

           if Trim(TNovusStringUtils.JustFilename(fsProjectConfigFilename)) = trim(fsProjectConfigFilename) then
             fsProjectConfigFilename := IncludeTrailingPathDelimiter(TNovusFileUtils.AbsoluteFilePath(ParamStr(i))) + Trim(ParamStr(i));

           if Not FileExists(fsProjectConfigFileName) then
             begin
               writeln ('-projectconfig ' + TNovusStringUtils.JustFilename(fsProjectConfigFileName) + ' projectconfig filename cannot be found.');

               Exit;
             end;

           Result := True;
         end
       else
       if lsParamStr = '-compileonly' then
         fbcompileonly := True;

      Inc(I);

      if I > ParamCount then fbOK := True;
    end;

  if Trim(fsSolutionFilename) = '' then
    begin
      if Trim(fsProjectFileName) = '' then
        begin
          writeln ('-project filename cannot be found.');

          Result := false;
        end;

      if Trim(fsProjectConfigFileName) = '' then
         begin
           writeln ('-projectconfig filename cannot be found.');

           result := False;
         end;
    end;

  if Result = false then
    begin
      writeln ('-error ');

      //
    end;

  fsOutputFile := csOutputFile;
end;

procedure TConfig.LoadConfig;
Var
  fPluginElem,
  fPluginsElem: TJvSimpleXmlElem;
  i, Index: Integer;
  fsPluginName,
  fsPluginFilename: String;
  loConfigPlugins: TConfigPlugins;
begin
  if fsRootPath = '' then
    fsRootPath := TNovusFileUtils.TrailingBackSlash(TNovusStringUtils.RootDirectory);

  fsConfigfile := fsRootPath + csConfigfile;

  if FileExists(fsConfigfile) then
    begin
      XMLFileName := fsRootPath + csConfigfile;
      Retrieve;


      Index := 0;
       fPluginsElem  := TNovusSimpleXML.FindNode(oXMLDocument.Root, 'plugins', Index);
       if Assigned(fPluginsElem) then
         begin
           For I := 0 to fPluginsElem.Items.count -1 do
             begin
               loConfigPlugins := TConfigPlugins.Create;

               fsPluginName := fPluginsElem.Items[i].Name;

               Index := 0;
               fsPluginFilename := '';
               fPluginElem := TNovusSimpleXML.FindNode(fPluginsElem.Items[i], 'filename', Index);
               if Assigned(fPluginElem) then
                 fsPluginFilename := fPluginElem.Value;

               loConfigPlugins.PluginName := fsPluginName;
               loConfigPlugins.Pluginfilename := fsPluginfilename;
               loConfigPlugins.PluginFilenamePathname := rootpath + 'plugins\'+ fsPluginfilename;

               fConfigPluginsList.Add(loConfigPlugins);
             end;
         end;


    end;



end;

Initialization
  oConfig := tConfig.Create;

finalization
  oConfig.Free;

end.

