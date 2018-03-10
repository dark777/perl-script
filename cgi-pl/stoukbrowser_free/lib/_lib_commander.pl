sub lib_commander_configure
{
my($SubDebug) = $main::SubID{lib_commander_configure}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
lib_commander_loadconfiguration();
lib_commander_command();
lib_commander_leftlist();
lib_commander_rightlist();
};




sub lib_commander_loadconfiguration
{
my($SubDebug) = $main::SubID{lib_commander_loadconfiguration}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	

$main::Config{Commander}{ConfigurationFile} = $main::UserEnv{UEnvFolder} . "commandercfg.cgi";

	unless (-f $main::Config{Commander}{ConfigurationFile}) 
	{
	($SubDebug == 1) ? DebugOut("Creating Default Commander Configuration File: \"$main::Config{Commander}{ConfigurationFile}\"") : 0;
	lib_commander_createdefaltconfig();
	$main::Config{Commander}{ConfigurationFile} = $main::UserEnv{UEnvFolder} . "commandercfg.cgi";
	$main::Config{CommanderQuickJump}{ConfigFile} = $main::UserEnv{UEnvFolder} . "quickjumpcfg.cgi";	
	};
my(%Temp) = undef;
	if (-f $main::Config{Commander}{ConfigurationFile}) 
	{
	($SubDebug == 1) ? DebugOut("Reading Commander Configuration File: \"$main::Config{Commander}{ConfigurationFile}\"") : 0;
	%Temp = main::ReadIntConfig($main::Config{Commander}{ConfigurationFile}); 
	$main::Config{Commander} = \%Temp;
	$main::Config{Commander}{ConfigurationFile} = $main::UserEnv{UEnvFolder} . "commandercfg.cgi";
	$main::Config{CommanderQuickJump}{ConfigFile} = $main::UserEnv{UEnvFolder} . "quickjumpcfg.cgi";	
	};

	unless (-f $main::Config{CommanderQuickJump}{ConfigFile})
	{
	main::lib_commander_createdefaultjumpfile();	
	} else {
		my(%QJ) = main::ReadIntConfig($main::Config{CommanderQuickJump}{ConfigFile});
		$main::Config{CommanderQJ} = \%QJ;
		};

return %Temp;
};


sub main::lib_commander_createdefaultjumpfile
{
my($SubDebug) = $main::SubID{lib_commander_createdefaultjumpfile}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my(%Temp) = undef;
my($JumpId) = "j".time;
$Temp{$JumpId}{JumpName} = "root";
$Temp{$JumpId}{JumpPath} = "$main::Config{Commander}{CommanderRoot}";
$Temp{$JumpId}{JumpWebPath} = "$main::Config{Commander}{CommanderWebRoot}";
main::WriteIntConfig("config",\%Temp,$main::Config{CommanderQuickJump}{ConfigFile});	
$main::Config{CommanderQJ} = \%Temp;
};

sub main::lib_commander_addjumppoint
{
my($SubDebug) = $main::SubID{lib_commander_addjumppoint}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
my(%Temp) = undef;
my($JumpId) = "j".time;

	if (-e $main::Config{CommanderQuickJump}{ConfigFile})
	{
	%Temp = main::ReadIntConfig($main::Config{CommanderQuickJump}{ConfigFile}); 
		if ((length($main::Form{addqjname}) > 0) && (length($main::Form{addqjpath}) > 0))
		{
				if (-d $main::Form{addqjpath})
				{
				$Temp{$JumpId}{JumpName} = "$main::Form{addqjname}";	
				$Temp{$JumpId}{JumpName} =~ s![<>\s~\t\$\^%,\.]*!!gi;
								
				$Temp{$JumpId}{JumpPath} = "$main::Form{addqjpath}";

				$Temp{$JumpId}{JumpPath} =~ s!\\!/!gi;
				$Temp{$JumpId}{JumpPath} =~ s!//!/!gi;
				unless ($Temp{$JumpId}{JumpPath} =~ m!/$!) {$Temp{$JumpId}{JumpPath} .= "/"};
				
				$Temp{$JumpId}{JumpWebPath} = "$main::Form{addqjwebpath}";
				$Temp{$JumpId}{JumpWebPath} =~ s!\\!/!gi;
				unless ($Temp{$JumpId}{JumpWebPath} =~ m!/$!) {$Temp{$JumpId}{JumpWebPath} .= "/"};


				main::WriteIntConfig("config",\%Temp,$main::Config{CommanderQuickJump}{ConfigFile});	
				$main::Config{CommanderQJ} = \%Temp;
				} else {
					($SubDebug == 1) ? DebugOut("FAILED to add Quick Jump Point - no such Path for the Jump: \"$main::Form{addqjpath}\"") : 0;
					};			
			
		} else {
			($SubDebug == 1) ? DebugOut("FAILED to Add because not all required parameters are present: \$main::Form{addqjname} = \"$main::Form{addqjname}\" \$main::Form{addqjpath} = \"$main::Form{addqjpath}\"") : 0;
			};
	} else {
		main::lib_commander_createdefaultjumpfile();
		};
	
};

sub main::lib_commander_editjumppoint
{
my($SubDebug) = $main::SubID{lib_commander_editjumppoint}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
	
	
};

sub main::lib_commander_deletejumppoint
{
my($SubDebug) = $main::SubID{lib_commander_deletejumppoint}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
my(%Temp) = undef;
my($JumpId) = "j".time;
my($key) = undef;
	if (-e $main::Config{CommanderQuickJump}{ConfigFile})
	{
	%Temp = main::ReadIntConfig($main::Config{CommanderQuickJump}{ConfigFile}); 
		if (defined $Temp{$main::Form{delqj}}{JumpName})
		{
		undef $Temp{$main::Form{delqj}};
		undef $main::Config{CommanderQJ};
		$main::Config{CommanderQJ} = \%Temp;
		main::WriteIntConfig("config",\%{$main::Config{CommanderQJ}},$main::Config{CommanderQuickJump}{ConfigFile});	
		} else {
			($SubDebug == 1) ? DebugOut("FAILED: This ID does not exist! \$main::Form{delqj} = \"$main::Form{delqj}\"") : 0;
			};
	} else {
		main::lib_commander_createdefaultjumpfile();
		};	
	
};

sub main::lib_commander_jump
{
my($SubDebug) = $main::SubID{lib_commander_jump}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
my(%Temp) = undef;
my($key) = undef;
my($Side) = $_[0];

	if (defined  $main::Config{CommanderQJ}{$main::Form{jump}}{JumpPath})
	{
		if ($Side eq "LeftList")
		{
		$main::Config{Commander}{LeftRoot} = $main::Config{CommanderQJ}{$main::Form{jump}}{JumpPath}; 	
		$main::Config{Commander}{LeftWebRoot} = $main::Config{CommanderQJ}{$main::Form{jump}}{JumpWebPath}; 	
		$main::Config{Commander}{CommanderRootLeft} = $main::Config{CommanderQJ}{$main::Form{jump}}{JumpPath}; 	
		$main::Config{Commander}{CommanderWebRootLeft} = $main::Config{CommanderQJ}{$main::Form{jump}}{JumpWebPath}; 	
		
		main::WriteIntConfig("config",\%{$main::Config{Commander}},$main::Config{Commander}{ConfigurationFile});		
		} elsif ($Side eq "RightList") 
			{
			$main::Config{Commander}{RightRoot} = $main::Config{CommanderQJ}{$main::Form{jump}}{JumpPath}; 	
			$main::Config{Commander}{RightWebRoot} = $main::Config{CommanderQJ}{$main::Form{jump}}{JumpWebPath}; 	
			$main::Config{Commander}{CommanderRootRight} = $main::Config{CommanderQJ}{$main::Form{jump}}{JumpPath}; 	
			$main::Config{Commander}{CommanderWebRootRight} = $main::Config{CommanderQJ}{$main::Form{jump}}{JumpWebPath}; 	
			main::WriteIntConfig("config",\%{$main::Config{Commander}},$main::Config{Commander}{ConfigurationFile});			
			};
	} else {
		};
		
	
};

sub lib_commander_command
{
my($SubDebug) = $main::SubID{lib_commander_checkfocus}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	


	if ($main::Form{addquickjump} eq "Add Quick Jump")
	{
	main::lib_commander_addjumppoint();
	};

	if ($main::Form{cmd} eq "focus")
	{
		if (($main::Form{side} eq "LeftList") || ($main::Form{side} eq "RightList") )
		{
		 ($SubDebug == 1) ? DebugOut("Changing Active Side... to $main::Form{side}") : 0;
		$main::Config{Commander}{FocusedPanel} = $main::Form{side};
		main::WriteIntConfig("config",\%{$main::Config{Commander}},$main::Config{Commander}{ConfigurationFile});
		};
	};	
		if ($main::Form{cmd} eq "sort")
		{
			if (($main::Form{side} eq "LeftList") || ($main::Form{side} eq "RightList") )
			{
			 ($SubDebug == 1) ? DebugOut("Changing Sorting ... for $main::Form{side} \$main::Form{sortby} = $main::Form{sortby};  order: $main::Form{sortorder}") : 0;
			$main::Config{Commander}{SortOption}{$main::Form{side}}{SortBy} = $main::Form{sortby};
			$main::Config{Commander}{SortOption}{$main::Form{side}}{SortOrder} = $main::Form{sortorder};
			if ($main::Config{Commander}{SortOption}{$main::Form{side}}{SortOrder} eq "D") {$main::Config{Commander}{SortOption}{$main::Form{side}}{SortOrder} = "A"} else {$main::Config{Commander}{SortOption}{$main::Form{side}}{SortOrder} = "D"};
			($SubDebug == 1) ? DebugOut("Writing New data: \$main::Config{Commander}{SortOption}{$main::Form{side}}{SortBy} = $main::Config{Commander}{SortOption}{$main::Form{side}}{SortBy}") : 0;
			($SubDebug == 1) ? DebugOut("Writing New data: \$main::Config{Commander}{SortOption}{$main::Form{side}}{SortOrder} = $main::Config{Commander}{SortOption}{$main::Form{side}}{SortOrder}") : 0;
			main::WriteIntConfig("config",\%{$main::Config{Commander}},$main::Config{Commander}{ConfigurationFile});
			};
		};
	
	if (length($main::Form{upload}) > 0)
	{
	main::lib_commander_upload();
	};

	if ($main::Form{Copy} eq "Copy")
	{
	lib_commander_copyfiles();	
	};

	if ($main::Form{Move} eq "Move")
	{
	lib_commander_movefiles();	
	};

	if ($main::Form{Delete} eq "Delete")
	{
	lib_commander_deletefiles();	
	};

	if ($main::Form{QuickJumpLeftList} eq "QuickJump")
	{
	main::lib_commander_jump("LeftList");
	};

	if ($main::Form{QuickJumpRightList} eq "QuickJump")
	{
	main::lib_commander_jump("RightList");
	};


	if ($main::Form{delqj} =~ m!j\d+!i)
	{
	main::lib_commander_deletejumppoint();	
	};

	if ($main::Form{Rename} eq "Rename")
	{
	lib_commander_rename();	
	};

	if ($main::Form{New_Folder} eq "New Folder")
	{
	lib_commander_newfolder();	
	};


};

sub main::lib_commander_upload
{
my($SubDebug) = $main::SubID{lib_commander_upload}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
my($temp) = undef;
my($UploadFile) = $main::Form{upload};
$UploadFile =~ s!\\!/!gi;
my(@Temp) = undef;
my($UploadPath) = undef;

		if ($main::Form{side} eq "LeftList")
		{
		$UploadPath = $main::Config{Commander}{LeftRoot};
		} elsif ($main::Form{side} eq "RightList") 
			{
			$UploadPath  = $main::Config{Commander}{RightRoot};
			};
@Temp = split("/",$UploadFile);
$UploadPath .= 	$Temp[$#Temp];
($SubDebug == 1) ? DebugOut("UPLOADING FILE: $UploadFile - > $UploadPath") : 0;
main::LoadLibrary("lib_upload.pl");
main::lib_upload_file("upload",$UploadPath,1);	
};

sub lib_commander_newfolder
{
my($SubDebug) = $main::SubID{lib_commander_newfolder}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
my($temp) = undef;
	if (length($main::Form{newfolderid}) > 0)
	{
		if ($main::Form{side} eq "LeftList")
		{
		$temp = $main::Config{Commander}{LeftRoot};
		} elsif ($main::Form{side} eq "RightList") 
			{
			$temp = $main::Config{Commander}{RightRoot};
			};
		$temp .= $main::Form{newfolderid};
		unless (-e $temp)
		{
		mkdir($temp,0777);
		($SubDebug == 1) ? DebugOut("OK - created new folder: \"$temp\"") : 0;	
		} else {
			($SubDebug == 1) ? DebugOut("FAILED to create new folder: \"$temp\" this name already exists!") : 0;	
			};
	};
};


sub lib_commander_rename
{
my($SubDebug) = $main::SubID{lib_commander_rename}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($key) = undef;
my(%ActiveSide) = undef;
if ($main::Form{side} eq "LeftList")
{
	if (-f $main::Config{Commander}{LeftListFile})
	{
	%ActiveSide = main::ReadIntConfig($main::Config{Commander}{LeftListFile});
	};
} elsif ($main::Form{side} eq "RightList") 
	{
		if (-f $main::Config{Commander}{RightListFile})
		{
		%ActiveSide = main::ReadIntConfig($main::Config{Commander}{RightListFile});
		};
	};
my($temp) = undef;
	

	if (length($main::Form{renameid}) > 0)
	{
		foreach $key (sort keys %main::Form)
		{
			if ($key =~ m!fid(i\d+)!i)
			{
				if (-e $ActiveSide{$1}{fullname})
				{
				$temp = $ActiveSide{$1}{path} . "$main::Form{renameid}";
					unless (-e $temp)
					{
					rename($ActiveSide{$1}{fullname},$temp);
					($SubDebug == 1) ? DebugOut("OK: Renamed: \"$ActiveSide{$1}{fullname}\" ->  \"$temp\"") : 0;
					} else {
						($SubDebug == 1) ? DebugOut("FAILED: This name \"$temp\" already exists! Cannot rename!") : 0;
						};
				};
			};
		};	
	};
	
};

sub lib_commander_deletefiles
{
my($SubDebug) = $main::SubID{lib_commander_copyfiles}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
my($key) = undef;
my(%ActiveSide) = undef;
my($DestinationFolder) = undef;
my($temp) = undef;

if ($main::Form{side} eq "LeftList")
{
	if (-f $main::Config{Commander}{LeftListFile})
	{
	%ActiveSide = main::ReadIntConfig($main::Config{Commander}{LeftListFile});
	};
} elsif ($main::Form{side} eq "RightList") 
	{
		if (-f $main::Config{Commander}{RightListFile})
		{
		%ActiveSide = main::ReadIntConfig($main::Config{Commander}{RightListFile});
		};
	};

	if (defined %ActiveSide)
	{
		foreach $key (keys %main::Form)
		{
			if ($key =~ m!fid(i\d+)!i)
			{
				if (defined $ActiveSide{$1}{fullname})
				{
					if (-f $ActiveSide{$1}{fullname})
					{
					unlink($ActiveSide{$1}{fullname});
					} elsif (-d $ActiveSide{$1}{fullname}) 
						{
						rmtree($ActiveSide{$1}{fullname});
						};
					if (-e $ActiveSide{$1}{fullname})
					{
					($SubDebug == 1) ? DebugOut("FAILED: to delete: \"$ActiveSide{$1}{fullname}\"") : 0;			
					} else {
						($SubDebug == 1) ? DebugOut("Deleted: \"$ActiveSide{$1}{fullname}\"") : 0;			
						};
				} else {
					($SubDebug == 1) ? DebugOut("FAILED: not defined \"$ActiveSide{$1}{fullname}\"") : 0;			
					};
			} ;
		};	
	} else {
		($SubDebug == 1) ? DebugOut("FAILED: not defined \"\%ActiveSide\" or does not exist: \"$DestinationFolder\"") : 0;			
		};
};


sub lib_commander_copyfiles
{
my($SubDebug) = $main::SubID{lib_commander_copyfiles}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
my($key) = undef;
my(%ActiveSide) = undef;
my($DestinationFolder) = undef;
my($temp) = undef;

if ($main::Form{side} eq "LeftList")
{
	if (-f $main::Config{Commander}{LeftListFile})
	{
	%ActiveSide = main::ReadIntConfig($main::Config{Commander}{LeftListFile});
	$DestinationFolder = $main::Config{Commander}{RightRoot};
	};
} elsif ($main::Form{side} eq "RightList") 
	{
		if (-f $main::Config{Commander}{RightListFile})
		{
		%ActiveSide = main::ReadIntConfig($main::Config{Commander}{RightListFile});
		$DestinationFolder = $main::Config{Commander}{LeftRoot};
		};
	};

	if ((defined %ActiveSide) && (-d $DestinationFolder))
	{
		foreach $key (keys %main::Form)
		{
			if ($key =~ m!fid(i\d+)!i)
			{
				if (defined $ActiveSide{$1}{fullname})
				{
				
				if (-f $ActiveSide{$1}{fullname})
				{
				$temp = $DestinationFolder . $ActiveSide{$1}{name};
				main::CopyFile($ActiveSide{$1}{fullname},$temp);	
					if (-f $temp)
					{
					($SubDebug == 1) ? DebugOut("Copied file: \"$ActiveSide{$1}{fullname}\" -> \"$temp\"") : 0;			
					} else {
						($SubDebug == 1) ? DebugOut("FAILED to copy file: \"$ActiveSide{$1}{fullname}\" -> \"$temp\"") : 0;			
						};

				} elsif (-d $ActiveSide{$1}{fullname})
					{
					$temp = $DestinationFolder . $ActiveSide{$1}{name};
					main::CopyStructure($ActiveSide{$1}{fullname},$temp);
						if (-d $temp)
						{
						($SubDebug == 1) ? DebugOut("Copied directory: \"$ActiveSide{$1}{fullname}\" -> \"$temp\"") : 0;			
						} else {
							($SubDebug == 1) ? DebugOut("FAILED to copy directory: \"$ActiveSide{$1}{fullname}\" -> \"$temp\"") : 0;			
							};
					};
				} else {
					($SubDebug == 1) ? DebugOut("FAILED: not defined \"$ActiveSide{$1}{fullname}\"") : 0;			
					};
			} ;
		};	
	} else {
		($SubDebug == 1) ? DebugOut("FAILED: not defined \"\%ActiveSide\" or does not exist: \"$DestinationFolder\"") : 0;			
		};
};

sub lib_commander_movefiles
{
my($SubDebug) = $main::SubID{lib_commander_copyfiles}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
my($key) = undef;
my(%ActiveSide) = undef;
my($DestinationFolder) = undef;
my($temp) = undef;

if ($main::Form{side} eq "LeftList")
{
	if (-f $main::Config{Commander}{LeftListFile})
	{
	%ActiveSide = main::ReadIntConfig($main::Config{Commander}{LeftListFile});
	$DestinationFolder = $main::Config{Commander}{RightRoot};
	};
} elsif ($main::Form{side} eq "RightList") 
	{
		if (-f $main::Config{Commander}{RightListFile})
		{
		%ActiveSide = main::ReadIntConfig($main::Config{Commander}{RightListFile});
		$DestinationFolder = $main::Config{Commander}{LeftRoot};
		};
	};

	if ((defined %ActiveSide) && (-d $DestinationFolder))
	{
		foreach $key (keys %main::Form)
		{
			if ($key =~ m!fid(i\d+)!i)
			{
				if (defined $ActiveSide{$1}{fullname})
				{
					if (-f $ActiveSide{$1}{fullname})
					{
					$temp = $DestinationFolder . $ActiveSide{$1}{name};
					main::CopyFile($ActiveSide{$1}{fullname},$temp);
						if (-f $temp)
						{
						($SubDebug == 1) ? DebugOut("Copied file: \"$ActiveSide{$1}{fullname}\" -> \"$temp\"") : 0;	
						unlink($ActiveSide{$1}{fullname});
							unless (-f $ActiveSide{$1}{fullname}) 
							{
							($SubDebug == 1) ? DebugOut("OK Deleted file: \"$ActiveSide{$1}{fullname}\"") : 0;	
							} else {
								($SubDebug == 1) ? DebugOut("FAILED to delete \"$ActiveSide{$1}{fullname}\"") : 0;	
								};
						} else {
							($SubDebug == 1) ? DebugOut("FAILED to copy file: \"$ActiveSide{$1}{fullname}\" -> \"$temp\"") : 0;			
							};
					} elsif (-d $ActiveSide{$1}{fullname})
						{
						$temp = $DestinationFolder . $ActiveSide{$1}{name};
						main::CopyStructure($ActiveSide{$1}{fullname},$temp);
							if (-d $temp)
							{
							($SubDebug == 1) ? DebugOut("Copied directory: \"$ActiveSide{$1}{fullname}\" -> \"$temp\"") : 0;	
							rmtree($ActiveSide{$1}{fullname});
								unless (-d $ActiveSide{$1}{fullname}) 
								{
								($SubDebug == 1) ? DebugOut("OK Deleted directory: \"$ActiveSide{$1}{fullname}\"") : 0;	
								} else {
									($SubDebug == 1) ? DebugOut("FAILED to delete \"$ActiveSide{$1}{fullname}\"") : 0;	
									};
							} else {
								($SubDebug == 1) ? DebugOut("FAILED to copy directory: \"$ActiveSide{$1}{fullname}\" -> \"$temp\"") : 0;			
								};
						};
				} else {
					($SubDebug == 1) ? DebugOut("FAILED: not defined \"$ActiveSide{$1}{fullname}\"") : 0;			
					};
			} ;
		};	
	} else {
		($SubDebug == 1) ? DebugOut("FAILED: not defined \"\%ActiveSide\" or does not exist: \"$DestinationFolder\"") : 0;			
		};
};

sub lib_commander_createdefaltconfig
{
my($SubDebug) = $main::SubID{lib_commander_createdefaltconfig}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
my(%Default) = undef;
$Default{CommanderRoot} = $main::Config{ScriptRoot};
$Default{CommanderRootLeft} = $main::Config{ScriptRoot};
$Default{CommanderRootRight} = $main::Config{ScriptRoot};
$Default{CommanderWebRootLeft} = $main::Config{ScriptWebRoot};
$Default{CommanderWebRootRight} = $main::Config{ScriptWebRoot};
$Default{CommanderWebRoot} = $main::Config{ScriptWebRoot};
$Default{LeftRoot} = $main::UserEnv{UEnvFolder};
$Default{LeftWebRoot} = $Default{CommanderWebRoot};
$Default{RightRoot} = $main::UserEnv{UEnvFolder};
$Default{RightWebRoot} = $Default{CommanderWebRoot};
$Default{LeftListFile} = $main::UserEnv{UEnvFolder} . "commander_lt.cgi";
$Default{RightListFile} = $main::UserEnv{UEnvFolder} . "commander.rt.cgi";

$Default{Options}{Main}{BGColor}{Description} = "Main Background Color for Both Panels";
$Default{Options}{Main}{BGColor}{Value} = "#CCC";
$Default{Options}{Main}{FontColor}{Description} = "Font Color";
$Default{Options}{Main}{FontColor}{Value} = "#000";
$Default{Options}{Main}{FontSize}{Description} = "Main Font Size";
$Default{Options}{Main}{FontSize}{Value} = "10";
$Default{Options}{Main}{FontFamily}{Description} = "Main Font Type";
$Default{Options}{Main}{FontFamily}{Value} = "sans-serif,verdana,arial,tahoma";

$Default{Options}{MainDirectory}{FontColor}{Description} = "Font Color for Directories";
$Default{Options}{MainDirectory}{FontColor}{Value} = "#000";
$Default{Options}{MainDirectory}{FontSize}{Description} = "Font Size for Directories";
$Default{Options}{MainDirectory}{FontSize}{Value} = "10";
$Default{Options}{MainDirectory}{FontFamily}{Description} = "Font Type for Directories";
$Default{Options}{MainDirectory}{FontFamily}{Value} = "sans-serif,verdana,arial,tahoma";
$Default{Options}{MainDirectory}{FontEmphasize}{Description} = "Font Emphasis for Directories";
$Default{Options}{MainDirectory}{FontFamily}{Value} = "bold";

$Default{Options}{MainFile}{FontColor}{Description} = "Font Color for Files";
$Default{Options}{MainFile}{FontColor}{Value} = "#000";
$Default{Options}{MainFile}{FontSize}{Description} = "Font Size for Files";
$Default{Options}{MainFile}{FontSize}{Value} = "10";
$Default{Options}{MainFile}{FontFamily}{Description} = "Font Type for Files";
$Default{Options}{MainFile}{FontFamily}{Value} = "sans-serif,verdana,arial,tahoma";
$Default{Options}{MainFile}{FontEmphasize}{Description} = "Font emphasis for files";
$Default{Options}{MainFile}{FontFamily}{Value} = "";

$Default{Options}{MainPanel}{Width}{Description} = "Total Width of Two Panels";
$Default{Options}{MainPanel}{Width}{Value} = "1024";
$Default{Options}{MainPanel}{Border}{Description} = "Border Width for Outer Panel";
$Default{Options}{MainPanel}{Border}{Value} = "1";
$Default{Options}{MainPanel}{Cellpadding}{Description} = "Cellpadding";
$Default{Options}{MainPanel}{Cellpadding}{Value} = "0";
$Default{Options}{MainPanel}{Cellspacing}{Description} = "Cellspacing";
$Default{Options}{MainPanel}{Cellspacing}{Value} = "0";


$Default{Options}{IntPanelList}{Width}{Description} = " Width of list panel, if less than 100, than it is half of total Panel Width size";
$Default{Options}{IntPanelList}{Width}{Value} = "1";
$Default{Options}{IntPanelList}{Border}{Description} = "Border Width for Outer Panel";
$Default{Options}{IntPanelList}{Border}{Value} = "1";
$Default{Options}{IntPanelList}{Cellpadding}{Description} = "Cellpadding";
$Default{Options}{IntPanelList}{Cellpadding}{Value} = "0";
$Default{Options}{IntPanelList}{Cellspacing}{Description} = "Cellspacing";
$Default{Options}{IntPanelList}{Cellspacing}{Value} = "0";
$Default{Options}{IntPanelListName}{Width}{Description} = "File and Directory Column Width";
$Default{Options}{IntPanelListName}{Width}{Value} = "0";
$Default{Options}{IntPanelListSize}{Width}{Description} = "Size Column Width";
$Default{Options}{IntPanelListSize}{Width}{Value} = "0";
$Default{Options}{IntPanelListMod}{Width}{Description} = "Size Column Width";
$Default{Options}{IntPanelListMod}{Width}{Value} = "0";





main::WriteIntConfig("config",\%Default,$main::Config{Commander}{ConfigurationFile});
};

sub lib_commander_leftlist
{
my($SubDebug) = $main::SubID{lib_commander_leftlist}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
my(%Temp) = undef;
my(@List) = undef;
if (-f $main::Config{Commander}{LeftListFile}) {%Temp = main::ReadIntConfig($main::Config{Commander}{LeftListFile})};

	if (($main::Form{did} =~ m!(i\d+)!) && ($main::Form{side} eq "LeftList") )
	{
	($SubDebug == 1) ? DebugOut("CHECKING: if \"$main::Config{Commander}{LeftRoot}\" eq \"$Temp{$1}{fullname}\"") : 0;		
		unless ($main::Config{Commander}{LeftRoot} eq $Temp{$1}{fullname})
		{
			if (-d $Temp{$1}{fullname})
			{
			$main::Config{Commander}{LeftRoot} = $Temp{$1}{fullname};	
			my($temp) = $main::Config{Commander}{LeftRoot};
			$temp =~ s!$main::Config{Commander}{CommanderRootLeft}!$main::Config{Commander}{CommanderWebRootLeft}!i;
			$main::Config{Commander}{LeftWebRoot} = $temp;	
			($SubDebug == 1) ? DebugOut("CHANGED FOLDER: $main::Config{Commander}{LeftRoot} - > $main::Config{Commander}{LeftWebRoot}") : 0;	
			};
		};
	};

	if (($main::Form{did} =~ m!(iroot)!) && ($main::Form{side} eq "LeftList")) 
	{
	$main::Config{Commander}{LeftRoot} = $main::Config{Commander}{CommanderRootLeft};	
	$main::Config{Commander}{LeftWebRoot} = $main::Config{Commander}{CommanderWebRootLeft};
	};
	
	if (($main::Form{did} =~ m!ir(\d+)!) && ($main::Form{side} eq "LeftList")) 
	{
	my($DirId) = $1;
	($SubDebug == 1) ? DebugOut("\$DirId = \"$DirId\" - \$main::Form{did} = \"$main::Form{did}\"") : 0;
	my($temp) = undef;
	my($tempweb) = undef;
	my(@ListWeb) = undef;
	
	$temp = $main::Config{Commander}{LeftRoot};
	$tempweb = $main::Config{Commander}{LeftWebRoot};
	($SubDebug == 1) ? DebugOut("\$temp = \"$temp\" - \$main::Config{Commander}{LeftRoot} = \"$main::Config{Commander}{LeftRoot}\"") : 0;
	($SubDebug == 1) ? DebugOut("\$temp = \"$tempweb\" - \$main::Config{Commander}{LeftWebRoot} = \"$main::Config{Commander}{LeftWebRoot}\"") : 0;
	
	$temp =~ s!$main::Config{Commander}{CommanderRootLeft}!!i;
	$tempweb =~ s!$main::Config{Commander}{CommanderWebRootLeft}!!i;
	
	($SubDebug == 1) ? DebugOut("\$temp = \"$temp\"") : 0;
	@List = split("/",$temp);
	@ListWeb = split("/",$tempweb);
	
	my($Directory) = $main::Config{Commander}{CommanderRootLeft};
	my($WebDirectory) = $main::Config{Commander}{CommanderWebRootLeft};
	
	my($i) = undef;
		for ($i = 1; $i <= $DirId; $i++)
		{
		$Directory .= $List[$i-1] . "/";
		($SubDebug == 1) ? DebugOut("\$i = $i, \$Directory = \"$Directory\"") : 0;
		};

		for ($i = 1; $i <= $DirId; $i++)
		{
		$WebDirectory .= $ListWeb[$i-1] . "/";
		($SubDebug == 1) ? DebugOut("\$i = $i, \$WebDirectory = \"$WebDirectory\"") : 0;
		};
		

	$main::Config{Commander}{LeftRoot} = $Directory;
	$main::Config{Commander}{LeftWebRoot} = $WebDirectory;
	};

main::lib_commander_list("$main::Config{Commander}{LeftRoot}","*","LeftList");
$main::Config{Commander}{LeftRoot} = $main::Config{Commander}{LeftList}{Root};
main::WriteIntConfig("config",$main::Config{Commander}{LeftList},$main::Config{Commander}{LeftListFile});
($SubDebug == 1) ? DebugOut("Updating Commander config file: \"$main::Config{Commander}{ConfigurationFile}\"") : 0;
main::WriteIntConfig("config",$main::Config{Commander},$main::Config{Commander}{ConfigurationFile});

};

sub lib_commander_rightlist
{
my($SubDebug) = $main::SubID{lib_commander_leftlist}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
my(%Temp) = undef;
my(@List) = undef;
if (-f $main::Config{Commander}{RightListFile}) {%Temp = main::ReadIntConfig($main::Config{Commander}{RightListFile})};

	if (($main::Form{did} =~ m!(i\d+)!) && ($main::Form{side} eq "RightList") )
	{
	($SubDebug == 1) ? DebugOut("CHECKING: if \"$main::Config{Commander}{RightList}\" eq \"$Temp{$1}{fullname}\"") : 0;		
		unless ($main::Config{Commander}{RightRoot} eq $Temp{$1}{fullname})
		{
			if (-d $Temp{$1}{fullname})
			{
			$main::Config{Commander}{RightRoot} = $Temp{$1}{fullname};	
			my($temp) = $main::Config{Commander}{RightRoot};
			$temp =~ s!$main::Config{Commander}{CommanderRootRight}!$main::Config{Commander}{CommanderWebRootRight}!i;
			$main::Config{Commander}{RightWebRoot} = $temp;	
			($SubDebug == 1) ? DebugOut("CHANGED FOLDER: $main::Config{Commander}{RightRoot} - > $main::Config{Commander}{RightWebRoot}") : 0;	
			
			};
		};
	};

	if (($main::Form{did} =~ m!(iroot)!) && ($main::Form{side} eq "RightList")) 
	{
	$main::Config{Commander}{RightRoot} = $main::Config{Commander}{CommanderRootRight};	
	$main::Config{Commander}{RightWebRoot} = $main::Config{Commander}{CommanderWebRootRight};	
	};

	if (($main::Form{did} =~ m!ir(\d+)!) && ($main::Form{side} eq "RightList")) 
	{
	my($temp) = undef;
	my($tempweb) = undef;
	
	my($DirId) = $1;
	$temp = $main::Config{Commander}{RightRoot};
	$tempweb = $main::Config{Commander}{RightWebRoot};
	
	($SubDebug == 1) ? DebugOut("\$temp = \"$temp\" - \$main::Config{Commander}{CommanderRootRight} = \"$main::Config{Commander}{CommanderRootRight}\"") : 0;
	
	$temp =~ s!$main::Config{Commander}{CommanderRootRight}!!i;
	$tempweb =~ s!$main::Config{Commander}{CommanderWebRootRight}!!i;
	
	($SubDebug == 1) ? DebugOut("\$temp = \"$temp\"") : 0;
	my(@ListWeb) = undef;
	
	@List = split("/",$temp);
	@ListWeb = split("/",$tempweb);
	
	my($Directory) = $main::Config{Commander}{CommanderRootRight};
	my($WebDirectory) = $main::Config{Commander}{CommanderWebRootRight};
	
	my($i) = undef;
		for ($i = 1; $i <= $DirId; $i++)
		{
		$Directory .= $List[$i-1] . "/";
		($SubDebug == 1) ? DebugOut("\$i = $i, \$Directory = \"$Directory\"") : 0;
		};

		for ($i = 1; $i <= $DirId; $i++)
		{
		$WebDirectory .= $ListWeb[$i-1] . "/";
		($SubDebug == 1) ? DebugOut("\$i = $i, \$WebDirectory = \"$WebDirectory\"") : 0;
		};


	$main::Config{Commander}{RightRoot} = $Directory;
	$main::Config{Commander}{RightWebRoot} = $WebDirectory;
	};


main::lib_commander_list("$main::Config{Commander}{RightRoot}","*","RightList");
$main::Config{Commander}{RightRoot} = $main::Config{Commander}{RightList}{Root};
main::WriteIntConfig("config",$main::Config{Commander}{RightList},$main::Config{Commander}{RightListFile});
($SubDebug == 1) ? DebugOut("Updating Commander config file: \"$main::Config{Commander}{ConfigurationFile}\"") : 0;
main::WriteIntConfig("config",$main::Config{Commander},$main::Config{Commander}{ConfigurationFile});
};


sub main::lib_commander_list
{ 
my($dirname) = $_[0]; 
my($pattern) = $_[1];
my($Panel) = $_[2];
my($count) = 0; 
my($file) = undef;
my($id) = undef;
undef $main::Config{Commander}{$Panel};
$main::Config{Commander}{$Panel}{Root} = $dirname;
unless (-d $main::Config{Commander}{$Panel}{Root}) 
{
$main::Config{Commander}{$Panel}{Root} = $main::Config{Commander}{CommanderRoot}; 
$dirname = $main::Config{Commander}{CommanderRoot};
};
if($pattern) {$pattern =~ s/\*/\.\*/g; $pattern = "^"."$pattern"."\$"};
$dirname =~ s!\\!/!gi;
	unless ($dirname =~ m!/$!) 
	{
	$dirname = "$dirname"."/";
	};
$dirname =~ s!//!/!;

opendir(DIR, $dirname) or warn "can't opendir $dirname: $!";
	while (defined($file = readdir(DIR))) 
	{
	next if $file =~ /^\.\.?$/;
		if (-d "$dirname$file") 
		{
		$count++;			
		$id = "i". "$count";
		$main::Config{Commander}{$Panel}{$id}{fullname} = $dirname.$file."/";
		$main::Config{Commander}{$Panel}{$id}{fullname} =~ s!\\!/!gi;
		$main::Config{Commander}{$Panel}{$id}{fullname} =~ s!//!/!gi;
		$main::Config{Commander}{$Panel}{$id}{name} = $file;
		$main::Config{Commander}{$Panel}{$id}{name} =~ s!\\!/!gi;
		$main::Config{Commander}{$Panel}{$id}{name} =~ s!//!/!gi;
		$main::Config{Commander}{$Panel}{$id}{path} = $dirname;
		$main::Config{Commander}{$Panel}{$id}{type} = "d";
		$main::Config{Commander}{$Panel}{$id}{size} = (stat($dirname.$file))[7];
		$main::Config{Commander}{$Panel}{$id}{mod} = (stat($dirname.$file))[9];
		$main::Config{Commander}{$Panel}{TotalFolders}++;
		};
		if (($file =~ /$pattern/g) && (-f "$dirname$file"))
		{
		$count++;			
		$id = "i". "$count";
		$main::Config{Commander}{$Panel}{$id}{fullname} = $dirname.$file; 
		$main::Config{Commander}{$Panel}{$id}{fullname} =~ s!\\!/!gi;
		$main::Config{Commander}{$Panel}{$id}{fullname} =~ s!//!/!gi;
		$main::Config{Commander}{$Panel}{$id}{name} = $file; 
		$main::Config{Commander}{$Panel}{$id}{name} =~ s!\\!/!gi;
		$main::Config{Commander}{$Panel}{$id}{name} =~ s!//!/!gi;
		$main::Config{Commander}{$Panel}{$id}{path} = $dirname;
		$main::Config{Commander}{$Panel}{$id}{type} = "f";
		$main::Config{Commander}{$Panel}{$id}{size} = (stat($main::Config{Commander}{$Panel}{$id}{fullname}))[7];
		$main::Config{Commander}{$Panel}{$id}{mod} = (stat($main::Config{Commander}{$Panel}{$id}{fullname}))[9];
		$main::Config{Commander}{$Panel}{TotalSize} = $main::Config{Commander}{$Panel}{TotalSize} + $main::Config{Commander}{$Panel}{$id}{size};
		$main::Config{Commander}{$Panel}{TotalFiles}++;
		};
	
	};
closedir(DIR);
};
##############################################################################




1;
