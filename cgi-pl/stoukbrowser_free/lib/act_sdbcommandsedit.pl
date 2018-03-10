# Action library for sdbcommandsedit


	sub main::pre_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute before Template generation:
		   
####################################################################################################################
my($StrFile) =  $main::Config{sdb}{dbstruct}{commands};
my($DatabaseFile) =  $main::Config{sdb}{dbmain}{commands};
my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{commands};
my($IndexLetter) = "t";
my($TableName) = "commands";
####################################################################################################################
	if ($main::Form{Delete} eq "Delete Selected")
	{
	main::LoadLibrary("lib_sdbrecords.pl");
	main::LoadLibrary("lib_newaction.pl");
	my(%AllRecords) = undef;
	%AllRecords = main::lb_sdbconfig_readconfig($StrFile,$DatabaseFile,"f_id");

my($key) = undef;

	        foreach $key (keys %main::Form)
	        {
	        ($SubDebug == 1) ? DebugOut("Checking $key = $main::Form{$key}") : 0;
	            if ($key =~ m!^DELETE(.*)!)
	            {
	                $DeleteKeys{$1} = $1;
	                ($SubDebug == 1) ? DebugOut("Checking If defined: $main::Config{sdb}{ReadConfig}{$DeleteKeys{$1}}{f_id}") : 0;
			if (defined $main::Config{sdb}{ReadConfig}{$DeleteKeys{$1}}{f_id})
			{
						if (defined $ActConfig{$main::Config{sdb}{ReadConfig}{$DeleteKeys{$1}}{f_id}})
						{
						main::lib_newaction_delete($main::Config{sdb}{ReadConfig}{$DeleteKeys{$1}}{f_id});	
						($SubDebug == 1) ? DebugOut("Preparing to DELETED Completely: \"$main::Config{sdb}{ReadConfig}{$DeleteKeys{$1}}{f_id}\"") : 0;	
						};			
			
			};	                
	                ($SubDebug == 1) ? DebugOut("Marked to Delete key: $DeleteKeys{$1}") : 0;
	            };
	        };
        

	 


	};

	main::lib_sdbconfig_processcommands_edit($StrFile,$DatabaseFile,$DatabaseFolder,$IndexLetter);		
	};
		    
	sub main::post_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute after Template generation:
	
my($String) = undef;
####################################################################################################################
my($StrFile) =  $main::Config{sdb}{dbstruct}{commands};
my($DatabaseFile) =  $main::Config{sdb}{dbmain}{commands};
my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{commands};
my($IndexLetter) = "t";
my($TableName) = "commands";
####################################################################################################################
$String = main::lib_sdbconfig_processcommand_afteredit($StrFile,$DatabaseFile,$DatabaseFolder,$IndexLetter,$TableName);
$String = $main::Config{sdb}{message}{error} . $main::Config{sdb}{message}{ok} . $String;
$main::Config{$main::Form{c}}{ok} .= "";
$main::Config{$main::Form{c}}{error} .= "";
$String = $main::Config{$main::Form{c}}{error} . $main::Config{$main::Form{c}{ok}} . $String;
$main::Html{ServiceText} =~ s!<insert-sdbcommandsedit-content>!$String!gis;
};
1;
