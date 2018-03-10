# Action library for help


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
my($AidFile) = $main::Config{TtsSubFolders}{help} . $main::HelpConfig{$main::Form{aid}}{name};
				if (-f $AidFile)
				{
				$String = join("",(main::ReadFile($AidFile)));
				$String = main::lib_html_Escape($String);
				$String =~ s!\n!<br>!gis;
				$String =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;
				} else {
					($SubDebug == 1) ? DebugOut("FAILED: Requested Help File Does not Exist! \"$AidFile\"") : 0;
					};		
	};
# my($String) = "</br><b>My Data insert Example! ! !<b>";;
$main::Html{ServiceText} =~ s!<insert-help-content>!$String!gis;
};
1;
