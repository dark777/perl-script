# Action Processing library
sub main::lib_act_process
{
my($Action) = $_[0];
my($SubDebug) = $main::SubID{lib_act_out}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? main::DebugOut("... do:\"$Action\"") : 0;
	unless ($Action =~ m!\w+!) 
	{
	$Action = "login";
	main::DebugOut("Assigning Default command : \"login\"")
	};


my($LibraryName) = "act"."_" . "$Action" . ".pl";
my($HtmlTemplateName) = undef;

if (defined $ActConfig{$Action}{htmltemplate}{name})
{
$HtmlTemplateName = $main::Config{TtsSubFolders}{html} . $ActConfig{$Action}{htmltemplate}{name};
($SubDebug == 1) ? DebugOut("\$HtmlTemplateName = \"$HtmlTemplateName\"") : 0;
	if (-e $HtmlTemplateName)
	{
	($SubDebug == 1) ? DebugOut("Loading Library: \"$LibraryName\"") : 0;
	main::LoadLibrary($LibraryName);
	main::pre_act_process();	
	main::lib_act_out($HtmlTemplateName,$Action);
	main::post_act_process();
	} else {
		main::AddError("e00001","\$HtmlTemplateName = \"$HtmlTemplateName\"");
		($SubDebug == 1) ? DebugOut("FAILED: Does not exist: \"\$HtmlTemplateName = \"$HtmlTemplateName\"\"") : 0;
		};
	
} else {
	main::AddError("e00026","\$ActConfig{$Action}{htmltemplate}{name} = \"$ActConfig{$Action}{htmltemplate}{name}\"");
	($SubDebug == 1) ? DebugOut("FAILED: No Act key: \$ActConfig{$Action}{htmltemplate}{name} = \"$ActConfig{$Action}{htmltemplate}{name}\"") : 0;
	};
return 1;
};

sub main::lib_act_out
{
my($HtmlTemplateName) = $_[0];
my($Action) = $_[1];
my($SubDebug) = $main::SubID{lib_act_out}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... acting out \"$HtmlTemplateName\"") : 0;


	if (-e $HtmlTemplateName)
	{
	($SubDebug == 1) ? DebugOut("Processing Template file \"$HtmlTemplateName\"") : 0;
	my($TemplateString) = join("",main::ReadFile($HtmlTemplateName));
	$TemplateString = main::lib_act_template($TemplateString,$HtmlTemplateName);
	
	if (-f ($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{head}{name}))
	{
	my($AddHeader) = join("",main::ReadFile(($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{head}{name}))); 
	$AddHeader = main::lib_act_template($AddHeader,$main::JSConfig{$Action}{head}{name});
	$main::Html{AddHeader} .= $AddHeader;
	};

	if (-f ($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{body}{name}))
	{
	my($AddBody) = join("",main::ReadFile(($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{body}{name}))); 
	$AddBody = main::lib_act_template($AddBody,$main::JSConfig{$Action}{body}{name});
	$main::Html{AddBody} .= $AddBody;
	};
	
	
	my($CssFile) = ($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name});
	($SubDebug == 1) ? DebugOut("Checking CSS: \"$CssFile\"") : 0;
	if (-f $CssFile)
	{
	my($AddCSS) = join("",main::ReadFile($CssFile)); 
	$AddCSS = main::lib_act_template($AddCSS,$CssFile);
	($SubDebug == 1) ? DebugOut("Adding CSS: \"$CssFile\"") : 0;
	$main::Html{AddCSS} .= $AddCSS;	
	};

	$main::Html{ServiceText} .= $TemplateString;
	return $TemplateString;
	} else {
		main::AddError("e00204","\$HtmlTemplateName = $HtmlTemplateName");	
		DebugOut("FAILED: \$HtmlTemplateName = $HtmlTemplateName")
		};
return 	$TemplateString;
};

sub main::lib_act_template
{
my($TemplateString) = $_[0];
my($TemplateFile) = $_[1];
my($SubDebug) = $main::SubID{ProcessTts}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... processing content of \"$TemplateFile\"") : 0;
my(%IdentifiedCode) = undef;
if ($main::Config{GlobalIterationCount}++ > $main::Config{GlobalIterationLimit}) {die "Global Iteration exceeded the limit! Please check for never ending recursive code! or Enable debugging and trace the error!"};

($SubDebug == 1) ? DebugOut("... the actual content is:  \"$TemplateString\"") : 0;
#	$_ = $TemplateString;
	while ($TemplateString =~ m![_<](\w[\w\d_]*)-(\w[\w\d_]*)-(\w[\w\d_]*)[>_]!gsi)
	{
	if ($main::Config{GlobalIterationCount}++ > $main::Config{GlobalIterationLimit}) {die "Global Iteration exceeded the limit! Please check for never ending recursive code! or Enable debugging and trace the error!"};
	$IdentifiedCode{$1}{$2}{$3} = 1;	
	($SubDebug == 1) ? DebugOut("OK Identified: $1-$2-$3 \"$IdentifiedCode{$1}{$2}{$3}\"") : 0;
	};
my($Key) = undef; my($SubKey) = undef; my($SubSubKey) = undef;
($SubDebug == 1) ? DebugOut("... Processing keys...") : 0;
	foreach $Key (keys %IdentifiedCode)
	{
		if ($Key)
		{
			foreach $SubKey (keys %{$IdentifiedCode{$Key}})
			{
				if ($SubKey)
				{
					foreach $SubSubKey (keys %{$IdentifiedCode{$Key}{$SubKey}})
					{
						if ($SubSubKey)
						{
						        if (($Key =~ m!^hfile$!i) && ($SubSubKey) )
						        {
							$TemplateString = main::lib_act_InsertHFile($TemplateString,$Key,$SubKey,$SubSubKey);
							#DebugOut("OK inserting hfile: $TtsContent,$Key,$SubKey,$SubSubKey")
							} elsif (($Key =~ m!^html$!i) && ($SubSubKey =~ m!^name$!i) )
							{
							$TemplateString = main::lib_act_InsertHTML($TemplateString,$Key,$SubKey,$SubSubKey);
							#DebugOut("OK inserting html: $TtsContent,$Key,$SubKey,$SubSubKey")	
							} elsif (($Key =~ m!^js$!i) && ($SubSubKey =~ m!^name$!i) )
							{
							#$TemplateString = main::lib_prepro_InsertJS($TemplateString,$Key,$SubKey,$SubSubKey);		
							#DebugOut("OK inserting JavaScript: $TtsContent,$Key,$SubKey,$SubSubKey")
							} elsif (($Key =~ m!^css$!i) && ($SubSubKey =~ m!^name$!i) )
							{
							#$TemplateString = main::lib_prepro_InsertCSS($TemplateString,$Key,$SubKey,$SubSubKey);
							#DebugOut("OK inserting CSS: $TtsContent,$Key,$SubKey,$SubSubKey")		
							} elsif ($Key =~ m!^htext$!i)
							{
							$TemplateString = main::lib_act_InsertHText($TemplateString,$Key,$SubKey,$SubSubKey);
							#DebugOut("OK inserting CSS: $TtsContent,$Key,$SubKey,$SubSubKey")		
							} elsif (($Key =~ m!^form$!i) && ($SubKey =~ m!^option$!i) )
							{
							$TemplateString =~ s![_<]form-option-(\w[\w\d]*)[_>]!$main::Form{$1}!gis;
							} elsif ($Key =~ m!^config$!is)
							{
							$TemplateString = main::lib_act_InsertConfiguration($TemplateString,$Key,$SubKey,$SubSubKey);
							} else {
								# $TemplateString =~ s![_<]$Key-$SubKey-$SubSubKey[_>]!!is;	
								};
						
						};
					};					
				};
			};
		};
	};	
($SubDebug == 1) ? DebugOut("OK - Finished lib_act_template of file \"$TemplateFile\".") : 0;	

	
return $TemplateString;	
};

sub main::lib_act_InsertHFile
{
my($TemplateString) = $_[0];
my($Key) = $_[1];
my($SubKey) = $_[2];
my($SubSubKey) = $_[3];
my($SubDebug) = $main::SubID{lib_act_InsertHFile}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut(" ... processing $SubKey -> $SubSubKey") : 0;
my($SubstituteString) = "$Key" . "-" . "$SubKey" . "-". "$SubSubKey";
($SubDebug == 1) ? DebugOut("\$SubstituteString = \"$SubstituteString\"") : 0;	
($SubDebug == 1) ? DebugOut("Adding: \$main::HConfig{$SubKey}{$SubSubKey} = \"$main::HConfig{$1}{$2}\"") : 0;	
		if (defined $main::HConfig{$SubKey}{$SubSubKey})
		{
			if (-f ($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$SubKey}{$SubSubKey}))
			{
			my($HFileContent) = join("",main::ReadFile(($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$SubKey}{$SubSubKey})));
			$HFileContent = main::lib_act_template($HFileContent);
			$TemplateString =~ s!([_<])$SubstituteString([>_])!$HFileContent!is;
			($SubDebug == 1) ? DebugOut("OK: Inserted file: \"$main::Config{TtsSubFolders}{hfile}$main::HConfig{$1}{$2}\"") : 0;
			} else {
				main::AddError("e00001","Does not exist: \"$main::Config{TtsSubFolders}{hfile}$main::HConfig{$1}{$2}\"");
				($SubDebug == 1) ? DebugOut("FAILED: File Does not exist:  \"$main::Config{TtsSubFolders}{hfile}$main::HConfig{$1}{$2}\"") : 0;
				};		
		} else {
			main::AddError("e00025","FAILED: Not Defined: \$main::HConfig{$1}{$2} = \"$main::HConfig{$1}{$2}\"");
			};
return $TemplateString;
};

sub main::lib_act_InsertHTML
{
my($TemplateString) = $_[0];
my($Key) = $_[1];
my($SubKey) = $_[2];
my($SubSubKey) = $_[3];
my($SubDebug) = $main::SubID{lib_act_InsertHTML}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut(" ... processing $SubKey -> $SubSubKey") : 0;
my($SubstituteString) = "$Key" . "-" . "$SubKey" . "-". "$SubSubKey";
($SubDebug == 1) ? DebugOut("\$SubstituteString = \"$SubstituteString\"") : 0;	
($SubDebug == 1) ? DebugOut("Adding: \$main::HTMLConfig{$SubKey}{$SubSubKey} = \"$main::HTMLConfig{$1}{$2}\"") : 0;	
		if (defined $main::HTMLConfig{$SubKey}{$SubSubKey})
		{
			if (-f ($main::Config{TtsSubFolders}{html} . $main::HTMLConfig{$SubKey}{$SubSubKey}))
			{
			my($HFileContent) = join("",main::ReadFile(($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$SubKey}{$SubSubKey})));
			$HFileContent = main::lib_act_template($HFileContent);
			$TemplateString =~ s!([_<])$SubstituteString([>_])!$HFileContent!is;
			($SubDebug == 1) ? DebugOut("OK: Inserted file: \"$main::Config{TtsSubFolders}{hfile}$main::HConfig{$1}{$2}\"") : 0;
			} else {
				main::AddError("e00001","Does not exist: \"$main::Config{TtsSubFolders}{hfile}$main::HConfig{$1}{$2}\"");
				($SubDebug == 1) ? DebugOut("FAILED: File Does not exist:  \"$main::Config{TtsSubFolders}{hfile}$main::HConfig{$1}{$2}\"") : 0;
				};		
		} else {
			main::AddError("e00025","FAILED: Not Defined: \$main::HConfig{$1}{$2} = \"$main::HConfig{$1}{$2}\"");
			};
return $TemplateString;
};

sub main::lib_act_InsertHText
{
my($TemplateString) = $_[0];
my($Key) = $_[1];
my($SubKey) = $_[2];
my($SubSubKey) = $_[3];
my($SubDebug) = $main::SubID{lib_act_InsertHText}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut(" ... processing $SubKey -> $SubSubKey") : 0;
my($SubstituteString) = "$Key" . "-" . "$SubKey" . "-". "$SubSubKey";
my($InsertString) = $main::HTextConfig{$SubKey}{$SubSubKey};

	if ($InsertString)
	{
	$InsertString = main::lib_act_template($InsertString);
	$TemplateString =~ s!([<_])$SubstituteString([>_])!$InsertString!gis;
	($SubDebug == 1) ? DebugOut("OK - Insert Code Exists: \"$SubstituteString\"") : 0;
	} else {
		$InsertString = "";
		$TemplateString =~ s!([<_])$SubstituteString([>_])!$InsertString!gis;
		main::AddError("e00028",$SubstituteString);
		($SubDebug == 1) ? DebugOut("FAILED - Insert Code Not Exists: \"$SubstituteString\": \$main::HTextConfig{$SubKey}{$SubSubKey} = \"$main::HTextConfig{$SubKey}{$SubSubKey}\"") : 0;
		};

return $TemplateString;
};

sub main::lib_act_InsertConfiguration
{
my($TemplateString) = $_[0];
my($Key) = $_[1];
my($SubKey) = $_[2];
my($SubSubKey) = $_[3];
my($SubDebug) = $main::SubID{lib_act_InsertHText}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut(" ... processing $SubKey -> $SubSubKey") : 0;
my($SubstituteString) = "$Key" . "-" . "$SubKey" . "-". "$SubSubKey";
my($InsertString) = $main::DConfig{$SubKey}{$SubSubKey};
	unless (defined $InsertString) 
	{
		if ($SubKey =~ m!script!i)
		{	
		$InsertString = $main::Config{$SubSubKey};
		} elsif ($SubKey =~ m!form!i)
		{	
		$InsertString = $main::Form{$SubSubKey};
		} elsif ($SubKey =~ m!user!i)
		{	
		$InsertString = $main::UserEnv{$SubSubKey};
		} elsif ($SubKey =~ m!html!i)
		{	
		$InsertString = $main::Html{$SubSubKey};
		} elsif ($SubKey =~ m!command!i)
		{	
		$InsertString = $ActConfig{$main::Form{c}}{$SubSubKey};
		} elsif ($SubKey =~ m!cenv!i)
		{
		$InsertString = $main::Config{CEnv}{$main::Form{c}}{$SubSubKey};	
		} elsif ($SubKey =~ m!env!i)
		{
		$InsertString = $main::Config{Env}{$SubSubKey};		
		};
	};
if (defined $InsertString) 
{
} else {
	$InsertString = "";
	AddError("e0001","Dinamic Configuration was not defined for this key: \"$SubstituteString\"");
};
$TemplateString =~ s!([_<])$SubstituteString([>_])!$InsertString!gis;
return 	$TemplateString;
};


sub main::lib_act_respond
{
my($SubDebug) = $main::SubID{lib_act_respond}{debug};
my($Action) = $_[0];
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
if (defined $main::ActConfig{$main::Form{c}}{superframe})
{
	
} else {
	$main::Html{ServiceText} = main::lib_act_ProcessSuperframe(main::lib_defaults_superframe());
	};
return $main::Html{ServiceText};
};


sub main::lib_act_ProcessSuperframe
{
my($TemplateString) = $_[0];
my($SubDebug) = $main::SubID{lib_act_ProcessSuperframe}{debug};
my($ErrorCallHeader) = undef;
my($ErrorCallBody) = undef;
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut(" ... processing Superframe.") : 0;
unless (defined $main::Html{config}{page}{title}) {$main::Html{config}{page}{title} = "Stouk Web Application Development Environment ($main::Form{c})"};
$TemplateString =~ s!_superframe_page_title_!$main::Html{config}{page}{title}!gis;
unless (defined $main::Html{config}{page}{description}) {$main::Html{config}{page}{description} = "Stouk Web Application Development Environment ($main::Form{c})"};
$TemplateString =~ s!_superframe_page_description_!$main::Html{config}{page}{description}!gis;
unless (defined $main::Html{config}{page}{keywords}) {$main::Html{config}{page}{keywords} = "sergy stouk Web Application Development Environment serguei stukalenko"};
$TemplateString =~ s!_superframe_page_keywords_!$main::Html{config}{page}{keywords}!gis;
unless (defined $main::Html{config}{page}{author}) {$main::Html{config}{page}{author} = "sergy stouk serguei stukalenko www.stouk.com"};
$TemplateString =~ s!_superframe_page_author_!$main::Html{config}{page}{author}!gis;
unless (defined $main::Html{config}{page}{language}) {$main::Html{config}{page}{language} = "russian"};
$TemplateString =~ s!_superframe_page_language_!$main::Html{config}{page}{language}!gis;
unless (defined $main::Html{config}{page}{encoding}) {$main::Html{config}{page}{encoding} = "windows-1251"};
$TemplateString =~ s!_superframe_page_encoding_!$main::Html{config}{page}{encoding}!gis;
if ($TemplateString =~ s!_superframe_insert_data_!$main::Html{ServiceText}!gis) {} else {AddError("e0001","CRITICAL! Superframe does not contain data insertion tag: \"_superframe_insert_data_\"");};
	if (($main::Config{ErrorTriggered} == 1) && (defined $main::UserEnv{href}))
	{
		unless ($main::Form{c} eq "errorhelp")
		{
		$ErrorCallHeader = main::lib_act_GetErrorHeader();
		$ErrorCallBody = main::lib_act_CheckErrorTrigger();
		};
	};
$TemplateString =~ s!</head>!$main::Html{AddHeader}$main::Html{AddCSS}\n $ErrorCallHeader</head>!gis;
$TemplateString =~ s!</body>!$main::Html{AddBody}\n$ErrorCallBody</body>!gis;
$TemplateString =~ s!<body([\s>])!<body $main::Html{AddBodyOptions}$1!gis;
return $TemplateString;
};

sub main::lib_act_GetErrorHeader
{
my($String) = qq(
<script language="JavaScript">
function newErrorWindow(mypage,myname,w,h,features) {
  if(screen.width){
  var winl = (screen.width-w)/2;
  var wint = (screen.height-h)/2;
  }else{winl = 0;wint =0;}
  if (winl < 0) winl = 0;
  if (wint < 0) wint = 0;
  var settings = 'height=' + h + ',';
  settings += 'width=' + w + ',';
  settings += 'top=' + wint + ',';
  settings += 'left=' + winl + ',';
  settings += features;
  win = window.open(mypage,myname,settings);
  win.window.focus();
}
</script>
);	
return $String;
};

sub main::lib_act_CheckErrorTrigger
{
my($String) = undef;


    if ($main::Config{ErrorTriggered} == 1)
    {
	main::lib_act_RemoveOldErrors();
	my($ErrorID) = main::lib_time_gettime(11);
	$main::Config{ErrorFolder} = $main::Config{DebugFolder} . $ErrorID. "/";	
	unless (-e $main::Config{ErrorFolder}) {mkdir($main::Config{ErrorFolder},0777)};
        main::lib_debug_DebugHash("config",\%main::Error,($main::Config{ErrorFolder}."errors.txt"));
        main::lib_debug_DebugHash("config",\%main::Html,($main::Config{ErrorFolder}."html.txt"));
        main::lib_debug_DebugHash("config",\%main::UserEnv,("$main::Config{ErrorFolder}"."userenv.txt"));
        main::lib_debug_DebugHash("config",\%main::GroupEnv,("$main::Config{ErrorFolder}"."groupenv.txt"));
        main::lib_debug_DebugHash("config",\%main::ConfigEnv,("$main::Config{ErrorFolder}"."configenv.txt"));
        main::lib_debug_DebugHash("config",\%main::User,("$main::Config{ErrorFolder}"."user.txt"));
        main::lib_debug_DebugHash("config",\%main::SubID,("$main::Config{ErrorFolder}"."subid.txt"));
        main::lib_debug_DebugHash("config",\%main::Img,("$main::Config{ErrorFolder}"."img.txt"));
        main::lib_debug_DebugHash("config",\%main::Tts,("$main::Config{ErrorFolder}"."tts.txt"));
        main::lib_debug_DebugHash("config",\%main::Data,("$main::Config{ErrorFolder}"."data.txt"));
        main::lib_debug_DebugHash("config",\%main::Form,("$main::Config{ErrorFolder}"."form.txt"));
        main::lib_debug_DebugHash("config",\%main::Style,("$main::Config{ErrorFolder}"."style.txt"));
        main::lib_debug_DebugHash("config",\%main::Action,("$main::Config{ErrorFolder}"."action.txt"));
        main::lib_debug_DebugHash("config",\%main::Config,("$main::Config{ErrorFolder}"."config.txt"));
        main::lib_debug_DebugHash("config",\%main::Form,("$main::Config{ErrorFolder}"."webform.txt"));
	my(@raw) = undef; my($count) = undef; my($key) = undef;
		foreach $key (sort main::by_number keys %main::Error)
		{
		if ($key =~ m!^id!) {$raw[$count++] = "$main::Error{$key}{Text}\n"};
		};
	main::SaveFile(($main::Config{ErrorFolder}."allerrors.txt"),@raw);	
	main::CopyFile($main::Config{DebugFile},($main::Config{ErrorFolder}."debuglog.txt"));
$String = qq	(
		<script>
		JavaScript:newErrorWindow('$main::UserEnv{href}&c=errorhelp&aid=$ErrorID','popup',450,500,'scrollbars=yes,resizable=yes');
		</script>
		);
    };
return $String;
};
sub main::lib_act_RemoveOldErrors
{
my(@DirList) = main::ListDirectories($main::Config{DebugFolder});	
my(@FileList) = undef;
my($DebugFolder) = undef;
my($temp) = undef;
if ($main::Config{ErrorRetentionDays} > 1) {$main::Config{ErrorRetention} = 86400 * $main::Config{ErrorRetentionDays} } else {$main::Config{ErrorRetention} = 3600};
	foreach $DebugFolder (@DirList)
	{
		if ($DebugFolder =~ m!/[\d]+$!)
		{
		$temp = time - (stat($DebugFolder))[8];
			if ($temp > $main::Config{ErrorRetention}) 
			{
			rmtree($DebugFolder);		
			};
		};
	};
};

1;
