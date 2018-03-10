# PlainConfig Library

###########################################################################
sub main::lib_plainconfig
{
	
my($SubDebug) = $main::SubID{lib_plainconfig}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($ConfigFile) = undef;


			
		if ($main::Form{hfile} =~ m!(\w[\w\d]*)-(\w[\w\d]*)!is) 
		{
		($SubDebug == 1) ? DebugOut("Updated HFile:  \$main::Form{hfile} = \"$main::Form{hfile}\"") : 0;			
			if (defined $main::HConfig{$1}{$2})
			{
				if ($main::Form{data})
				{
				main::SaveFile(($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$1}{$2}),$main::Form{data});
				($SubDebug == 1) ? DebugOut("Updated HFile:  \$main::HConfig{$1}{$2} = \"$main::HConfig{$1}{$2}\"") : 0;			
				};
			};

			if (-f ($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$1}{$2}))
			{
			($SubDebug == 1) ? DebugOut("OK: File Exists:  \$main::HConfig{$1}{$2} = \"$main::HConfig{$1}{$2}\"") : 0;					
			$ConfigFile = $main::Config{TtsSubFolders}{hfile} . $main::HConfig{$1}{$2};
			} else {
				($SubDebug == 1) ? DebugOut("FAILED: There is no Such file \$main::HConfig{$1}{$2} = \"$main::HConfig{$1}{$2}\"") : 0;				
				};
		};

my($TemplateFile) = $main::Config{TtsSubFolders}{hfile} . $main::Action{plainconfig}{template}{name};

	if (defined $main::Action{plainconfig}{template}{name})
	{
		unless (-e $TemplateFile) 
		{
		main::SaveFile($TemplateFile,"");
		($SubDebug == 1) ? DebugOut("OK: Creating New Action Template file: \$TemplateFile = \"$TemplateFile\"") : 0;
		};
	} else {
		main::AddError("e00026","\$main::Action{plainconfig}{template}{name} = \"$main::Action{plainconfig}{template}{name}\"");
		};

	if (-e $ConfigFile)
	{
		if (-e $TemplateFile)
		{
			if ($main::Form{data})
			{
			main::SaveFile($ConfigFile,$main::Form{data});
			($SubDebug == 1) ? DebugOut("OK: Updated \"$TemplateFile\" with new form data.") : 0;
			};
		main::lib_html_template("plainconfig")
		} else {
			main::AddError("e00001","\$TemplateFile = $TemplateFile");
			($SubDebug == 1) ? DebugOut("FAILED: Could not load \"$TemplateFile\"") : 0;
			};
	} else {
		main::AddError("e00001","\$ConfigFile = $ConfigFile");
		($SubDebug == 1) ? DebugOut("FAILED: Could not load \"$ConfigFile\"") : 0;
		};
};
###########################################################################
sub main::BackupConfigFile
{
my($SubDebug) = $main::SubID{BackupConfigFile}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($OrigFile) = $_[0];
my($PermanentBackupFile) = $_[0] . "$ENV{REMOTE_ADDR}";
my($CurrentBackupFile) = $_[0] . ".bkp";
	unless ($main::Config{DoNotCreatePermanentBackups} == 1)
	{
		unless (-e $PermanentBackupFile) {main::CopyFile($OrigFile,$PermanentBackupFile)};
	};

	unless ($main::Config{DoNotCreateBackups} == 1)
	{
		main::CopyFile($OrigFile,$CurrentBackupFile);
	};
};
1;
