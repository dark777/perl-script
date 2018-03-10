# Action library for errorhelp


sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute before Template generation

};

sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute After Template generation
# Example of adding Processed data to the Template:
# Unremark the following lines to see the action:
my($String) = undef;

if (length($main::Form{aid}) > 1)
{
my($ErrorID) = $main::Form{aid};
$main::Config{DisplayErrorFolder} = $main::Config{DebugFolder} . $ErrorID. "/";	
my($temp) = undef;
my($tempcontent) = undef;
	if (-e $main::Config{DisplayErrorFolder})
	{
	#my(@FileList) = main::ListFiles($main::Config{DisplayErrorFolder},1,"*.*");
	$temp = $main::Config{DisplayErrorFolder} . "allerrors.txt";
	($SubDebug == 1) ? DebugOut("Displaying Error File: \"$temp\"") : 0;
		if (-f $temp) 
		{
		$String .= "<hr>" . "<b>"."Debug Log:"."</b><br>";	
		$tempcontent = join("",main::ReadFile($temp));
		$tempcontent = main::lib_html_Escape($tempcontent);
		$tempcontent =~ s!\n!<br>!gis;
		$tempcontent =~ s!(Error)!<b>$1</b>!gis;
		
		$String .= $tempcontent;		
#		($SubDebug == 1) ? DebugOut("\n\nCONTENT:\n$tempcontent\n\n") : 0;
		};
		if ($main::UserEnv{group} =~ m!administrators!i)
		{
		$temp = $main::Config{DisplayErrorFolder} . "debuglog.txt";
		($SubDebug == 1) ? DebugOut("Displaying Error File: \"$temp\"") : 0;
			if (-f $temp) 
			{
			$String .= "<hr>" . "<font size=+2><b>"."Debug Log:"."</b></font><br><br>";	
			$tempcontent = join("",main::ReadFile($temp));
			$tempcontent = main::lib_html_Escape($tempcontent);
			$tempcontent =~ s!\n!<br>!gis;
			$tempcontent =~ s!(error)!<b>$1</b>!gis;
			$String .= $tempcontent;		
			};

		$temp = $main::Config{DisplayErrorFolder} . "form.txt";
			if (-f $temp) 
			{
			$String .= "<hr>" . "<font size=+2><b>"."Form Content:"."</b></font><br><br>";	
			$tempcontent = join("",main::ReadFile($temp));
			$tempcontent = main::lib_html_Escape($tempcontent);
			$tempcontent =~ s!\n!<br>!gis;
			$tempcontent =~ s!(error)!<b>$1</b>!gis;
			$String .= $tempcontent;		
			};

		$temp = $main::Config{DisplayErrorFolder} . "config.txt";
			if (-f $temp) 
			{
			$String .= "<hr>" . "<font size=+2><b>"."Configuration Content:"."</b></font><br><br>";	
			$tempcontent = join("",main::ReadFile($temp));
			$tempcontent = main::lib_html_Escape($tempcontent);
			$tempcontent =~ s!\n!<br>!gis;
			$tempcontent =~ s!(error)!<b>$1</b>!gis;
			$String .= $tempcontent;		
			};

			
		};
	};
};
$main::Html{ServiceText} =~ s!<insert-errorhelp-content>!$String!gis;
};
1;
