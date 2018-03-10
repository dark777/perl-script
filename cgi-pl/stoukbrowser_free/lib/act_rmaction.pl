# Action library for rmaction


sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute before Template generation
	if (($main::Form{rmaction}) && ($main::Form{submit} eq "Yes") )
	{
	$main::Form{rmaction} = lc($main::Form{rmaction});
	my($ActionKey) = $main::Form{rmaction};
	
		if (defined $ActConfig{$ActionKey})
		{
		main::LoadLibrary("lib_newaction.pl");
		main::lib_newaction_delete($ActionKey);	
####################################################################################################################
my($StrFile) =  $main::Config{sdb}{dbstruct}{commands};
my($DatabaseFile) =  $main::Config{sdb}{dbmain}{commands};
my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{commands};
my($IndexLetter) = "t";
my($TableName) = "commands";
####################################################################################################################	
main::LoadLibrary("lib_sdbrecords.pl");	
($SubDebug == 1) ? DebugOut("Deleting action: $ActionKey") : 0;
main::lib_sdbrecords_deleterecordswhere($StrFile,$DatabaseFile,$DatabaseFolder,"f_id","$ActionKey");
	
		} else {
			
			};
	} else {
		
		};
};

sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute After Template generation
if ($main::Config{rmactionOK} == 1)
{
my($RedirectString) = main::lib_html_Redirect("$main::UserEnv{href}"."&c=adminmain");
$main::Html{ServiceText} =~ s!<insert-redirect-string>!$RedirectString!gis;
};


};



1;
