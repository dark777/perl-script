# Action library for sdbappsview


	sub main::pre_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute before Template generation:
		   
####################################################################################################################
my($StrFile) =  $main::Config{sdb}{dbstruct}{apps};
my($DatabaseFile) =  $main::Config{sdb}{dbmain}{apps};
my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{apps};
my($IndexLetter) = "t";
my($TableName) = "apps";
####################################################################################################################
main::lib_sdbconfig_processcommands_view($StrFile,$DatabaseFile,$DatabaseFolder,$IndexLetter);		   
	};
		    
	sub main::post_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute after Template generation:
	
my($String) = undef;
####################################################################################################################
my($StrFile) =  $main::Config{sdb}{dbstruct}{apps};
my($DatabaseFile) =  $main::Config{sdb}{dbmain}{apps};
my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{apps};
my($IndexLetter) = "t";
my($TableName) = "apps";
####################################################################################################################
$String = main::lib_sdbconfig_processcommand_afterview($StrFile,$DatabaseFile,$DatabaseFolder,$IndexLetter,$TableName);
$String = $main::Config{sdb}{message}{error} . $main::Config{sdb}{message}{ok} . $String;
$main::Config{$main::Form{c}}{ok} .= "";
$main::Config{$main::Form{c}}{error} .= "";
$String = $main::Config{$main::Form{c}}{error} . $main::Config{$main::Form{c}{ok}} . $String;
$main::Html{ServiceText} =~ s!<insert-sdbappsview-content>!$String!gis;
};
1;
