# Action library for wmssrview


sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute before Template generation

	################################################################################
		main::LoadLibrary("lib_wmsconfig.pl");
		main::lib_wmsconfigenv();

		my($StructureFile) =  $main::Config{wms}{dbstructfile}{srv};
		my($DatabaseFile) = $main::Config{wms}{db}{srv};
		my($DatabaseFolder) = $main::Config{wms}{srvroot};
		my($IndexLetter) = "t";
		my($TableName) = "srv";
	################################################################################
		main::lib_wmsconfig_processcommands_view($StructureFile,$DatabaseFile,$DatabaseFolder,$IndexLetter,$TableName);
};

sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute After Template generation
# Example of adding Processed data to the Template:
# Unremark the following lines to see the action:
	################################################################################
		my($StructureFile) =  $main::Config{wms}{dbstructfile}{srv};
		my($DatabaseFile) = $main::Config{wms}{db}{srv};
		my($DatabaseFolder) = $main::Config{wms}{srvroot};
		my($IndexLetter) = "t";
		my($TableName) = "srv";
	################################################################################
		my($String) = main::lib_wmsconfig_processcommand_afterview($StructureFile,$DatabaseFile,$DatabaseFolder,$IndexLetter,$TableName);
$main::Html{ServiceText} =~ s!<insert-wmssrview-content>!$String!gis;
};
1;
