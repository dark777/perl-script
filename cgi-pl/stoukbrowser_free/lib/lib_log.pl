# Logging and Debugging library
sub main::lib_log_CleanLogFolder
{
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
	if (-e $main::Config{LogFolder})
	{
	my($marker) = $main::Config{LogFolder} . "$year" . "$yday".".log";
		unless (-e $marker)
		{
		my(@list) = ListFiles($main::Config{LogFolder},1,"*.log");
		my(@cachelist) = ListFiles($main::Config{CacheFolder},1,"*.cgi");
		my($temp) = undef;
			foreach $temp (@list)
			{
			$filemod  = (stat($temp))[9];       
			if ((time - ((stat($temp))[9])) > ($main::Config{LogRetentionDays} * 86400)) {unlink($temp)};
			};

			foreach $temp (@cachelist)
			{
			$filemod  = (stat($temp))[9];       
			if ((time - ((stat($temp))[9])) > ($main::Config{LogRetentionDays} * 86400)) {unlink($temp)};
			};

		open(OUT, "> $marker") or warn "\n<br>ERROR: (lib_log_CleanLogFolder) cant open New File \"$marker\": $! (Possible Permissions Misconfiguration!)"; 
		print OUT time;
		close OUT;
		};
	};
$main::Config{MainLog} = $main::Config{LogFolder} . ($year + 1900) . ($main::ConfigEnv{Month}{($mon + 1)}). $mday .".log";
if ((-e $main::Config{MainLog}) && (((stat($main::Config{MainLog}))[7]) > $main::Config{MaxLogSize}) && ($main::Config{MaxLogSize} > 1000)) {unlink($main::Config{MainLog});};
};

sub  main::Log
{
	if (defined $main::Config{MainLog})
	{
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
	($sec < 10) ? $sec = "0"."$sec" : $sec = $sec;
	($min < 10) ? $min = "0"."$min" : $min = $min;
	($hour < 10) ? $hour = "0"."$hour" : $hour = $hour;
		unless ($main::Config{MainLogDate} == $yday) 
		{
		$main::Config{MainLogDate} = $yday;
		main::lib_log_CleanLogFolder();
		$main::Config{AttachDate} = main::lib_time_gettime(8);
		$main::Config{ScriptMainLog} = $main::Config{LogFolder} ."". $main::Config{AttachDate} . ".log";
		$main::Config{DebugFile} = $main::Config{LogFolder} ."Debug_". $main::Config{AttachDate}."_".$main::Form{sn}."_"."$main::UserEnv{name}". ".log";				
		# $main::Config{DebugFile} = $main::Config{ScriptMainLog};
		};
			
	open(FH, ">>$main::Config{MainLog}") or warn "\n<br> Cannot Open File \"$main::Config{MainLog}\" $!";
		unless (flock(FH, 2)) 
		{
		sleep(1);
		    if (flock(FH, 2)) 
		    {
		    warn "can't get write-lock on numfile: $!";
		    } else 
			{
			print FH "$hour:$min:$sec"," $ENV{REMOTE_ADDR}:" , "@_" , "\n";
			};
		} else {
			print FH "$hour:$min:$sec"," $ENV{REMOTE_ADDR}:" ,"@_", "\n";
			};
	close FH;
	} else {
		warn "\n<br>Log File Name not Specified! \"$main::Config{MainLog}\"";
		};
};

	sub main::DumpDebug
	{
	my($DumpHashRef) = $_[0];
	my(%DimpHash) = undef;
	%DumpHash = %$DumpHashRef;
	my($DumpToFile) = $main::Config{DebugFolder} .$_[1];
	WriteIntConfig("debug",\%DumpHash,"$DumpToFile");
	};

	sub main::DebugOut
	{
	my($Parent2) = (caller(1))[2];
	my($Parent3) = (caller(1))[3];
	my($LogLine) = undef;
	$LogLine = "[sub $Parent3] - $_[0]";
		my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
		($sec < 10) ? $sec = "0"."$sec" : $sec = $sec;
		($min < 10) ? $min = "0"."$min" : $min = $min;
		($hour < 10) ? $hour = "0"."$hour" : $hour = $hour;

		unless ($main::Config{MainLogDate} == $yday) 
		{
		$main::Config{MainLogDate} = $yday;
		main::lib_log_CleanLogFolder();
		$main::Config{AttachDate} = main::lib_time_gettime(8);
		$main::Config{ScriptMainLog} = $main::Config{LogFolder} ."". $main::Config{AttachDate} . ".log";
		$main::Config{DebugFile} = $main::Config{LogFolder} ."Debug_". $main::Config{AttachDate}."_".$main::Form{sn}."_"."$main::UserEnv{name}". ".log";		
		#$main::Config{DebugFile} = $main::Config{ScriptMainLog};
		};
				
	open(FH, ">>$main::Config{DebugFile}") or warn "\n<br> Cannot Open File \"$main::Config{DebugFile}\" $!";
		unless (flock(FH, 2)) 
		{
		sleep(1);
		    if (flock(FH, 2)) 
		    {
		    warn "can't get write-lock on numfile: $!";
		    } else 
			{
			print FH "$hour:$min:$sec"," $ENV{REMOTE_ADDR}:" , "$LogLine" , "\n";
			};
		} else {
			print FH "$hour:$min:$sec"," $ENV{REMOTE_ADDR}:" ,"$LogLine", "\n";
			};
	close FH;

			
	
	};

	sub main::AddError
	{
	my($Parent2) = (caller(1))[2];
	my($Parent3) = (caller(1))[3];
	if ($_[0] =~ m!(\w[\w\d]*)-(\w[\w\d]*)!i)
	{
	$main::Error{"id".$main::Error{id}++}{Text} =  "$main::Error{Config}{$1}{$2} . [sub $Parent3] - ". $main::Error{List}{$1}{$2} . " $_[1]";
	} else {
		$main::Error{"id".$main::Error{id}++}{Text} =  "$main::Error{Config}{$_[0]} . [sub $Parent3] - ". $main::Error{List}{$_[0]} . " $_[1]";
		};
	
	if ((defined $main::Error{Config}{$1}{$2}) || (defined $main::Error{Config}{$_[0]}) ) {$main::Config{ErrorTriggered} = 1};
	};

	sub main::lib_log_DumpErrors
	{
	my(@raw) = undef; my($count) = undef;
	my($key) = undef;
		foreach $key (sort main::by_number keys %main::Error)
		{
		if ($key =~ m!^id!) {$raw[$count++] = "$main::Error{$key}{Text}\n"};
		};
	main::SaveFile(($main::Config{DebugFolder}."allerrors.txt"),@raw);	
	};
1;
