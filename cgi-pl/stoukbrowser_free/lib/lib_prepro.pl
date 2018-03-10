# Library to preprocess Web display
sub main::lib_prepro_ProcessTts
{
my(%IdentifiedCode) = undef;
my($temp) = undef;
my($TtsContent) = $_[0];
my($SubDebug) = $main::SubID{ProcessTts}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

	$_ = $TtsContent;
	while (m!_(\w[\w\d_]*)-(\w[\w\d_]*)-(\w[\w\d_]*)_!gsi)
	{
	$IdentifiedCode{$1}{$2}{$3} = 1;	
	DebugOut("OK Identified: _$1-$2-$3_ \"$IdentifiedCode{$1}{$2}{$3}\"")
	};

my($Key) = undef; my($SubKey) = undef; my($SubSubKey) = undef;

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
							$TtsContent = main::lib_prepro_InsertHFile($TtsContent,$Key,$SubKey,$SubSubKey);
							#DebugOut("OK inserting hfile: $TtsContent,$Key,$SubKey,$SubSubKey")
							} elsif (($Key =~ m!^html$!i) && ($SubSubKey =~ m!^name$!i) )
							{
							$TtsContent = main::lib_prepro_InsertHTML($TtsContent,$Key,$SubKey,$SubSubKey);
							#DebugOut("OK inserting html: $TtsContent,$Key,$SubKey,$SubSubKey")	
							} elsif (($Key =~ m!^js$!i) && ($SubSubKey =~ m!^name$!i) )
							{
							$TtsContent = main::lib_prepro_InsertJS($TtsContent,$Key,$SubKey,$SubSubKey);		
							#DebugOut("OK inserting JavaScript: $TtsContent,$Key,$SubKey,$SubSubKey")
							} elsif (($Key =~ m!^css$!i) && ($SubSubKey =~ m!^name$!i) )
							{
							$TtsContent = main::lib_prepro_InsertCSS($TtsContent,$Key,$SubKey,$SubSubKey);
							#DebugOut("OK inserting CSS: $TtsContent,$Key,$SubKey,$SubSubKey")		
							} elsif (($Key =~ m!^htext$!i))
							{
							$TtsContent = main::lib_prepro_InsertHText($TtsContent,$Key,$SubKey,$SubSubKey);
							#DebugOut("OK inserting CSS: $TtsContent,$Key,$SubKey,$SubSubKey")		
									
							} else {
									
								};
						
						};
					};					
				};
			};
		};
	};	
($SubDebug == 1) ? DebugOut("OK - Finished Pre-Processing the Template.") : 0;	
return $TtsContent;
};

sub main::lib_prepro_InsertHFile
{
my($TtsContent) = $_[0];
my($Key) = $_[1];
my($SubKey) = $_[2];
my($SubSubKey) = $_[3];
my($SubDebug) = $main::SubID{InsertHFile}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut(" ... processing $SubKey -> $SubSubKey") : 0;

my($SubstituteString) = "_" . "$Key" . "-" . "$SubKey" . "-". "$SubSubKey" . "_";
my($InsertString) = undef;
my($InsertFile) = undef;

	($SubDebug == 1) ? DebugOut("\$SubSubKey = \"$SubSubKey\"") : 0;	
		
	if (($SubSubKey =~ m!^data$!i) || ($SubSubKey =~ m!^insert$!i) )
	{
	($SubDebug == 1) ? DebugOut("OK - We need to insert file, specified in the Form Parameter...\$main::Form{hfile} = \"$main::Form{hfile}\"") : 0;
	
	($SubDebug == 1) ? DebugOut("\$main::Form{hfile} = \"$main::Form{hfile}\"") : 0;	
		if ($main::Form{hfile} =~ m!(\w[\w\d]*)-(\w[\w\d]*)!is) 
		{
			if (-f ($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$1}{$2}))
			{
			($SubDebug == 1) ? DebugOut("OK: File Exists:  \$main::HConfig{$1}{$2} = \"$main::HConfig{$1}{$2}\"") : 0;					
			$SubKey = $1; $SubSubKey = $2;
			} else {
				($SubDebug == 1) ? DebugOut("FAILED: There is no Such file \$main::HConfig{$1}{$2} = \"$main::HConfig{$1}{$2}\"") : 0;				
				};
		};
	} else {
		($SubDebug == 1) ? DebugOut("\$SubSubKey = \"$SubSubKey\" ... OK - We need NOT insert file, specified in the Form Parameter...\$main::Form{hfile} = \"$main::Form{hfile}\"") : 0;
		};	
	
	if (($SubSubKey =~ m!^insert$!i) || ($SubSubKey =~ m!^name$!i) || ($SubSubKey =~ m!^data$!i) || ($SubSubKey =~ m!^file$!i))
	{
	$InsertFile = $main::Config{TtsSubFolders}{hfile} . $main::HConfig{$SubKey}{$SubSubKey};
	unless (-e $InsertFile) {main::SaveFile("$InsertFile","");};
	};

	if (-f $InsertFile)
	{
	DebugOut("OK: Insert File Exists: \"$InsertFile\"");
	$InsertString = join("",main::ReadFile($InsertFile));
		if (($SubSubKey =~ m!^file$!i) || ($SubSubKey =~ m!^name$!i) )
		{
		$InsertString = main::PreProcessTemplate($InsertString);
		$InsertString = main::lib_prepro_ProcessTts($InsertString);
		($SubDebug == 1) ? DebugOut("OK - Running pre-process on data: \"$SubstituteString\"") : 0;
		} elsif (($SubSubKey =~ m!^data$!i) || ($SubSubKey =~ m!^insert$!i))
			{
			 ($SubDebug == 1) ? DebugOut("OK - Will no Pre-Process. Insert as Raw data: \"$SubstituteString\"") : 0;
			 $InsertString = main::lib_html_Escape($InsertString);
			};


	$TtsContent =~ s!$SubstituteString!$InsertString!gis;
	} else {
		main::AddError("e01",$InsertFile);
		DebugOut("FAILED: No hfile: \"$InsertFile\"");
		$InsertString = "ERROR: No Such File: \"$InsertFile\"";
		};

return $TtsContent;
};
sub main::lib_prepro_InsertHTML
{
my($TtsContent) = $_[0];
my($Key) = $_[1];
my($SubKey) = $_[2];
my($SubSubKey) = $_[3];
my($SubDebug) = $main::SubID{InsertHTML}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut(" ... processing $SubKey -> $SubSubKey") : 0;

my($SubstituteString) = "_" . "$Key" . "-" . "$SubKey" . "-". "$SubSubKey" . "_";
my($InsertString) = undef;
my($InsertFile) = $main::Config{TtsSubFolders}{html} . $main::HTMLConfig{$SubKey}{name};
	if (-f $InsertFile)
	{
	$InsertString = join("",main::ReadFile($InsertFile));
	# This is a recersive function - because we are processing html template file within html template file.
	$InsertString = main::ProcessTts($InsertString);
	$TtsContent =~ s!$SubstituteString!$InsertString!gis;
	} else {
		main::AddError("e01",$InsertFile);
		};
return $TtsContent;
};
sub main::lib_prepro_InsertJS
{
my($TtsContent) = $_[0];
my($Key) = $_[1];
my($SubKey) = $_[2];
my($SubSubKey) = $_[3];
my($SubDebug) = $main::SubID{InsertJS}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut(" ... processing $SubKey -> $SubSubKey") : 0;

my($SubstituteString) = "_" . "$Key" . "-" . "$SubKey" . "-". "$SubSubKey" . "_";
my($InsertString) = undef;
my($InsertFile) = $main::Config{TtsSubFolders}{js} . $main::HConfig{$SubKey}{name};
	if (-e $InsertFile)
	{
	$InsertString = join("",main::ReadFile($InsertFile));
	# Processing for JavaScript file
	#$InsertString = main::PreProcessTemplate($InsertString);
	$TtsContent =~ s!$SubstituteString!$InsertString!gis;
	} else {
		main::AddError("e01",$InsertFile);
		};
return $TtsContent;
};
sub main::lib_prepro_InsertCSS
{
my($TtsContent) = $_[0];
my($Key) = $_[1];
my($SubKey) = $_[2];
my($SubSubKey) = $_[3];
my($SubDebug) = $main::SubID{InsertCSS}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut(" ... processing $SubKey -> $SubSubKey") : 0;

my($SubstituteString) = "_" . "$Key" . "-" . "$SubKey" . "-". "$SubSubKey" . "_";
my($InsertString) = undef;
my($InsertFile) = $main::Config{TtsSubFolders}{css} . $main::HConfig{$SubKey}{name};
	if (-e $InsertFile)
	{
	$InsertString = join("",main::ReadFile($InsertFile));
	# Processing for Cascading Style Sheet
	# $InsertString = main::PreProcessTemplate($InsertString);
	$TtsContent =~ s!$SubstituteString!$InsertString!gis;
	} else {
		main::AddError("e01",$InsertFile);
		};
return $TtsContent;
};

sub main::lib_prepro_InsertHText
{
my($TtsContent) = $_[0];
my($Key) = $_[1];
my($SubKey) = $_[2];
my($SubSubKey) = $_[3];
my($SubDebug) = $main::SubID{InsertHText}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut(" ... processing $SubKey -> $SubSubKey") : 0;

my($SubstituteString) = "_" . "$Key" . "-" . "$SubKey" . "-". "$SubSubKey" . "_";
my($InsertString) = $main::HTextConfig{$SubKey}{$SubSubKey};

	if ($InsertString)
	{
	# Processing for Cascading Style Sheet
	$InsertString = main::PreProcessTemplate($InsertString);
	$InsertString = main::lib_prepro_ProcessTts($InsertString);
	$TtsContent =~ s!$SubstituteString!$InsertString!gis;
	($SubDebug == 1) ? DebugOut("OK - Insert Code Exists: \"$SubstituteString\"") : 0;
	} else {
		$InsertString = "";
		$TtsContent =~ s!$SubstituteString!$InsertString!gis;
		main::AddError("e01",$SubstituteString);
		($SubDebug == 1) ? DebugOut("FAILED - Insert Code Not Exists: \"$SubstituteString\"") : 0;
		};
return $TtsContent;
};

1;
