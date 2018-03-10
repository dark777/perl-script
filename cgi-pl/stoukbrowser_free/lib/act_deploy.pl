# Action library for deploy


	sub main::pre_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute before Template generation:
####################################################################################################################
		if (($main::Form{Deploy} eq "Deploy") && (length($main::Form{delpoyapp}) > 0) )
		{
		$main::Config{$main::Form{c}{ok}} .= "Deploying application: <b>$main::Form{delpoyapp}</b>";
		main::act_deploy();	
		};

		   		   
	};
		    
	sub main::post_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute after Template generation:
	
my($String) = undef;
$main::Config{$main::Form{c}}{ok} .= "";
$main::Config{$main::Form{c}}{error} .= "";
$String .= main::act_deploy_form();
$String = $main::Config{$main::Form{c}}{error} . $main::Config{$main::Form{c}{ok}} . $String;
$main::Html{ServiceText} =~ s!<insert-deploy-content>!$String!gis;
};

sub main::act_deploy
{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($key) = undef;
my($temp) = undef;
my($StrFile) =  $main::Config{sdb}{dbstruct}{commands};
my($DatabaseFile) =  $main::Config{sdb}{dbmain}{commands};
my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{commands};
my($IndexLetter) = "t";
my($TableName) = "commands";
my(%Temp) = undef;
my(%Commands) = undef;

%Commands = main::lb_sdbconfig_readconfig($StrFile,$DatabaseFile,"f_id");
$main::Config{deploy}{commands} = \%Commands;	

$StrFile =  $main::Config{sdb}{dbstruct}{apps};
$DatabaseFile =  $main::Config{sdb}{dbmain}{apps};
$DatabaseFolder =  $main::Config{sdb}{dbroot}{apps};
$IndexLetter = "t";
$TableName = "apps";

%Temp = main::lb_sdbconfig_readconfig($StrFile,$DatabaseFile,"f_id");
$main::Config{deploy}{apps} = \%Temp;

my($DeployAppCommands) = undef;
($SubDebug == 1) ? DebugOut("\$main::Config{deploy}{apps}{$main::Form{delpoyapp}}{f_commands} = $main::Config{deploy}{apps}{$main::Form{delpoyapp}}{f_commands}") : 0;
$DeployAppCommands = $main::Config{deploy}{apps}{$main::Form{delpoyapp}}{f_commands};
($SubDebug == 1) ? DebugOut("\$DeployAppCommands = $DeployAppCommands") : 0;
$DeployAppCommands =~ s#!\[\(.*\)\]!##gsi;
($SubDebug == 1) ? DebugOut("\$DeployAppCommands = $DeployAppCommands") : 0;
my(@DeployCommands) = undef;

	if ($DeployAppCommands =~ m!\w!)
	{
	@DeployCommands = split(",",$DeployAppCommands);	
	};
my(%DeployList) = undef;
	if (@DeployCommands)
	{
		foreach (@DeployCommands)
		{
		$DeployList{$_} = 1;	
		};
	};
($SubDebug == 1) ? DebugOut("\@DeployCommands = @DeployCommands") : 0;

my(%ActConfig_Deploy) = undef;
my(%HConfig_Deploy) = undef;
my(%JSConfig_Deploy) = undef;
my(%HTMLConfig_Deploy) = undef;
my(%CSSConfig_Deploy) = undef;
my(%HTextConfig_Deploy) = undef;
my(%ListConfig_Deploy) = undef;
my(%HelpConfig_Deploy) = undef;
my(%DeleteLib) = undef;

   
	foreach $key (sort keys %ActConfig)
	{
	($SubDebug == 1) ? DebugOut("Checking command $key for Deployment.") : 0;		
		if (($DeployList{$key} == 1) || ($main::Config{deploy}{commands}{$key}{f_kernel} eq "YES"))
		{
		$ActConfig_Deploy{$key} = $ActConfig{$key};
		$HConfig_Deploy{$key} = $HConfig{$key};
		$JSConfig_Deploy{$key} = $JSConfig{$key};
		$HTMLConfig_Deploy{$key} = $HTMLConfig{$key};
		$CSSConfig_Deploy{$key} = $CSSConfig{$key};
		$HTextConfig_Deploy{$key} = $HTextConfig{$key};
		$ListConfig_Deploy{$key} = $ListConfig{$key};
		$HelpConfig_Deploy{$key} = $HelpConfig{$key};
		($SubDebug == 1) ? DebugOut("Confirmed! Deployment for $key") : 0;
		$main::Config{$main::Form{c}{ok}} .= "\n<br>Deploying $key";
		} else {
			
			$DeleteLib{$key} = "act_" . "$key" . ".pl";
			($SubDebug == 1) ? DebugOut("Prepared to Delete: \$DeleteLib{$key} = $DeleteLib{$key}") : 0;
			};
		
	};

my($DeployFolder) = 
$main::Config{deploy}{rootfolder} = $main::Config{TempFolder} . "deploy/";
	if (-e $main::Config{deploy}{rootfolder})
	{
	rmtree($main::Config{deploy}{rootfolder});	
	};
mkdir($main::Config{deploy}{rootfolder},0777);

$main::Config{deploy}{TtsFolder} = $main::Config{deploy}{rootfolder} . $main::ConfigEnv{TtsFolder};
mkdir($main::Config{deploy}{TtsFolder},0777);

$main::Config{DeployTtsSubFolders}{hfile} = $main::Config{deploy}{TtsFolder} . "hfile/"; unless (-e $main::Config{DeployTtsSubFolders}{hfile}) {mkdir($main::Config{DeployTtsSubFolders}{hfile},0777)};
$main::Config{DeployTtsSubFolders}{js} = $main::Config{deploy}{TtsFolder} . "js/"; unless (-e $main::Config{DeployTtsSubFolders}{js}) {mkdir($main::Config{DeployTtsSubFolders}{js},0777)};
$main::Config{DeployTtsSubFolders}{html} = $main::Config{deploy}{TtsFolder} . "html/"; unless (-e $main::Config{DeployTtsSubFolders}{html}) {mkdir($main::Config{DeployTtsSubFolders}{html},0777)};
$main::Config{DeployTtsSubFolders}{css} = $main::Config{deploy}{TtsFolder} . "css/"; unless (-e $main::Config{DeployTtsSubFolders}{css}) {mkdir($main::Config{DeployTtsSubFolders}{css},0777)};
$main::Config{DeployTtsSubFolders}{help} = $main::Config{deploy}{TtsFolder} . "help/"; unless (-e $main::Config{DeployTtsSubFolders}{help}) {mkdir($main::Config{DeployTtsSubFolders}{help},0777)};


$main::Config{deploy}{UEnvFolder} = $main::Config{deploy}{rootfolder} . $main::ConfigEnv{UEnvFolder};
mkdir($main::Config{deploy}{UEnvFolder},0777);
$main::Config{deploy}{CacheFolder} = $main::Config{deploy}{rootfolder} . $main::ConfigEnv{CacheFolder};
mkdir($main::Config{deploy}{CacheFolder},0777);
$main::Config{deploy}{LogFolder} = $main::Config{deploy}{rootfolder} . $main::ConfigEnv{LogFolder};
mkdir($main::Config{deploy}{LogFolder},0777);
$main::Config{deploy}{DebugFolder} = $main::Config{deploy}{rootfolder} . $main::ConfigEnv{DebugFolder};
mkdir($main::Config{deploy}{DebugFolder},0777);
$main::Config{deploy}{TempFolder} = $main::Config{deploy}{rootfolder} . $main::ConfigEnv{TempFolder};
mkdir($main::Config{deploy}{TempFolder},0777);
$main::Config{deploy}{LibFolder} = $main::Config{deploy}{rootfolder} . $main::ConfigEnv{LibFolder};
mkdir($main::Config{deploy}{LibFolder},0777);
main::CopyStructure($main::Config{LibFolder},$main::Config{deploy}{LibFolder});
$main::Config{deploy}{HelpFolder} = $main::Config{deploy}{rootfolder} . $main::ConfigEnv{HelpFolder};
mkdir($main::Config{deploy}{HelpFolder},0777);
$main::Config{deploy}{DbFolder} = $main::Config{deploy}{rootfolder} . $main::ConfigEnv{DbFolder};
mkdir($main::Config{deploy}{DbFolder},0777);
$main::Config{deploy}{StatFolder} = $main::Config{deploy}{rootfolder} . $main::ConfigEnv{StatFolder};
mkdir($main::Config{deploy}{StatFolder},0777);
$main::Config{deploy}{ImagesFolder} = $main::Config{deploy}{rootfolder} . $main::ConfigEnv{ImagesFolder};
mkdir($main::Config{deploy}{ImagesFolder},0777);
main::CopyStructure($main::Config{ImagesRoot},$main::Config{deploy}{ImagesFolder});
$main::Config{deploy}{CssFolder} = $main::Config{deploy}{rootfolder} . $main::ConfigEnv{CssFolder};
mkdir($main::Config{deploy}{CssFolder},0777);
my($fromfile) = undef;
my($tofile) = undef;
$main::Config{ModulesRoot} = $main::Config{RootFolder} . "modules/";
$main::Config{DeployModulesRoot} = $main::Config{deploy}{rootfolder} . "modules/";
$main::Config{EditorRoot} = $main::Config{RootFolder} . "editor/";
$main::Config{DeployEditorRoot} = $main::Config{deploy}{rootfolder} . "editor/";
main::CopyStructure($main::Config{ModulesRoot},$main::Config{DeployModulesRoot});
main::CopyStructure($main::Config{EditorRoot},$main::Config{DeployEditorRoot});


	foreach $key (keys %ActConfig_Deploy)
	{
		if ($key)
		{
		$fromfile = $main::Config{TtsSubFolders}{hfile} . $key . ".cgi";
		$tofile = $main::Config{DeployTtsSubFolders}{hfile} . $key . ".cgi";
		main::CopyFile($fromfile,$tofile,1);
		$fromfile = $main::Config{TtsSubFolders}{html} . $key . ".htm";
		$tofile = $main::Config{DeployTtsSubFolders}{html} . $key . ".htm";
		main::CopyFile($fromfile,$tofile,1);
		$fromfile = $main::Config{TtsSubFolders}{css} . $key . ".cgi";
		$tofile = $main::Config{DeployTtsSubFolders}{css} . $key . ".cgi";
		main::CopyFile($fromfile,$tofile,1);						
		$fromfile = $main::Config{TtsSubFolders}{help} . $key . ".cgi";
		$tofile = $main::Config{DeployTtsSubFolders}{help} . $key . ".cgi";
		main::CopyFile($fromfile,$tofile,1);						
		$fromfile = $main::Config{TtsSubFolders}{js} . "b_".$key . ".cgi";
		$tofile = $main::Config{DeployTtsSubFolders}{js} . "b_". $key . ".cgi";
		main::CopyFile($fromfile,$tofile,1);
		$fromfile = $main::Config{TtsSubFolders}{js} . "h_". $key . ".cgi";
		$tofile = $main::Config{DeployTtsSubFolders}{js} . "h_". $key . ".cgi";
		main::CopyFile($fromfile,$tofile,1);
		};
	};

	foreach $key (keys %DeleteLib)
	{
		if ($key)
		{
			$temp = $main::Config{deploy}{LibFolder} . $DeleteLib{$key};
			($SubDebug == 1) ? DebugOut("DELETING: $temp") : 0;
			unlink($temp);
		};
	};
	
my($IndexFile) = $main::Config{ScriptRoot} . "index.cgi";
my($DeployIndexFile) = $main::Config{deploy}{rootfolder} . "index.cgi";
main::CopyFile($IndexFile,$DeployIndexFile,1);

$main::Config{DeployErrorFile} = $main::Config{deploy}{TtsFolder} . "errors_c.cgi";
$main::Config{DeployHTextConfigFile} = $main::Config{deploy}{TtsFolder} . "htext_c.cgi";

 $main::Config{DeployTtsFile} = $main::Config{deploy}{TtsFolder} . "tts.cgi";
 $main::Config{DeployListConfigFile} = $main::Config{deploy}{TtsFolder} . "list_c.cgi";

$main::Config{DeployActConfigFile} = $main::Config{deploy}{TtsFolder} . "act_c.cgi";
main::WriteIntConfig("config",\%ActConfig_Deploy,$main::Config{DeployActConfigFile}); 

$main::Config{DeployHConfigFile} = $main::Config{deploy}{TtsFolder} . "hfile_c.cgi";
main::WriteIntConfig("config",\%HConfig_Deploy,$main::Config{DeployHConfigFile}); 

$main::Config{DeployJSConfigFile} = $main::Config{deploy}{TtsFolder} . "js_c.cgi";
main::WriteIntConfig("config",\%JSConfig_Deploy,$main::Config{DeployJSConfigFile}); 

$main::Config{DeployHTMLConfigFile} = $main::Config{deploy}{TtsFolder} . "html_c.cgi";
main::WriteIntConfig("config",\%HTMLConfig_Deploy,$main::Config{DeployHTMLConfigFile}); 

$main::Config{DeployCSSConfigFile} = $main::Config{deploy}{TtsFolder} . "css_c.cgi";
main::WriteIntConfig("config",\%CSSConfig_Deploy,$main::Config{DeployCSSConfigFile}); 

$main::Config{DeployHelpConfigFile} = $main::Config{deploy}{TtsFolder} . "help_c.cgi";
main::WriteIntConfig("config",\%HelpConfig_Deploy,$main::Config{DeployHelpConfigFile}); 
		
main::CopyFile($main::Config{ErrorFile},$main::Config{DeployErrorFile},1);
main::CopyFile($main::Config{HTextConfigFile},$main::Config{DeployHTextConfigFile},1);

	
};

sub main::act_deploy_form

{
my($String) = undef;
my($key) = undef;
my($temp) = undef;
my($StrFile) =  $main::Config{sdb}{dbstruct}{apps};
my($DatabaseFile) =  $main::Config{sdb}{dbmain}{apps};
my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{apps};
my($IndexLetter) = "t";
my($TableName) = "apps";
my(%Temp) = undef;
%Temp = main::lb_sdbconfig_readconfig($StrFile,$DatabaseFile,"f_id");
$main::Config{deploy}{apps} = \%Temp;

$String .= qq(
<DIV style=\"background:$main::Config{divopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor}\">
<center>
<table BORDER=\"$main::Config{tbopt}{tb_border}\" CELLPADDING=\"$main::Config{tbopt}{tb_cpadding}\" CELLSPACING=\"$main::Config{tbopt}{tb_cspacing}\" 
style=\"width:$main::Config{tbopt}{tb_width}; 
font-family:$main::Config{divopt}{tb_fontfamily}; 
font-size:$main::Config{divopt}{tb_fontsize}pt; 
background:$main::Config{tbopt}{tb_background}; 
color:$main::Config{divopt}{tb_textcolor};\">

<tr>
	<td><b></b></td>
	<td><b></b></td>	
</tr>
);	
my(%SelectOption) = undef;

%SelectOption = %Temp;
my($FieldName) = "delpoyapp";
my($SelectKey) = undef;
my($DescriptionKey) = "f_title"; # Please specify the database key which will be used for description
my($SelectCount) = undef;

if (defined %SelectOption)
{
$String .= "\n<select name=\"$FieldName\">";
$String .= "\n<option value=\"\" selected>";

	foreach $SelectKey (sort keys %SelectOption)
	{
	($SubDebug == 1) ? DebugOut("Checking key: \$SelectKey = $SelectKey") : 0;
		if ((defined $SelectKey) && (defined $SelectOption{$SelectKey}{$DescriptionKey}))
		{
			
		$String .= "\n<option value=\"$SelectKey\" >$SelectOption{$SelectKey}{$DescriptionKey}";	
		$SelectCount++;
		($SubDebug == 1) ? DebugOut("\$SelectCount = $SelectCount") : 0;			
		};
	};	
};	
	if ($SelectCount < 1)
	{
	$String .= "\n<option value=\"text\">text";
	};
$String .= "\n</select>";
		
$String .= qq(
<input type="submit" value="Deploy" name="Deploy" />
<tr>
	<td></td>
	<td></td>
</tr>
</table>
</center>
<p>
</DIV>
);
	
return $String;		
};
1;
