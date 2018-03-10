# Action library for groupmanager


sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute before Template generation
	if (length($main::Form{newgroup}) > 1)
	{
	$main::Form{newgroup} = lc($main::Form{newgroup});
	$main::Form{newgroup} =~ s!\s+!!gi;
		if ($main::Form{newgroup} =~ m!\W!i)
		{
		main::AddError("action-e00001","Wrong Format for New Group Name - Should not contain anything other than letters!");
		} else {
			my($key) = undef;
				unless (defined $main::Config{Groups}{$main::Form{newgroup}}{active})
				{
				$main::Config{Groups}{$main::Form{newgroup}}{active} = 1;
					unless ($main::Config{DemoApp} == 1)
					{
					main::WriteIntConfig("config",\%{$main::Config{Groups}},"$main::Config{GroupConfigFile}");				
					};				
				};
			};
	
	};

	if ($main::Form{act} eq "delete")
	{
		if ($main::Config{Groups}{$main::Form{group}}{active} == 1)
		{
			if ($main::Form{Yes} eq "Yes")
			{
			undef $main::Config{Groups}{$main::Form{group}};
				unless ($main::Config{DemoApp} == 1)
				{
				main::WriteIntConfig("config",\%{$main::Config{Groups}},"$main::Config{GroupConfigFile}");	
				};			
			
			} else {
				$main::Config{groupmanager}{errormessage} .= "<br>Are You sure you want to delete group <b>$main::Form{group}</b> ? <input type=\"hidden\" name=\"group\" value=\"$main::Form{group}\"/> <input type=\"hidden\" name=\"act\" value=\"delete\"/> <input type=\"submit\" name=\"Yes\" value=\"Yes\"/> <input type=\"submit\" name=\"No\" value=\"No\"/><br>";
					if ($main::Form{No} eq "No")
					{
					$main::Form{act} = undef;
					$main::Form{group} = undef;
					};
				};	
		};
	};
};

sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute After Template generation
# Example of adding Processed data to the Template:
# Unremark the following lines to see the action:

my($String) = $main::Config{groupmanager}{errormessage} . main::act_groupmanager_listgroups();
$main::Html{ServiceText} =~ s!<insert-groupmanager-content>!$String!gis;
};

sub main::act_groupmanager_listgroups
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($String) = undef;
my($key) = undef;
my($BgColor) = "";	
my(%Look) = undef;
# %Look = %{main::lib_defaults_desktopstyle()};
#$String = "<table border=$Look{TBorder} cellspacing=$Look{TCellSpacing} cellpadding=$Look{TCellPadding} style=\"width:100%;font-family:$Look{TextFontFace};font-size:$Look{TextFontSize}pt;color:$Look{TextFontColor};background:$Look{BgColor};\">";
$String .= "<center><table cellpadding=1 cellspacing=0 border=1 style=\"width:640; font-family:verdana,arial; font-size:8pt; background:#aef\">";			
	foreach $key (sort keys %{$main::Config{Groups}})
	{
	if ($main::Config{Groups}{$key}{active} == 1)
	{
	$String .= "<tr><td>$key</td><td><a href=\"$main::UserEnv{href}&c=groupusermanager&group=$key&act=delete\">Manage Users</a></td><td><a href=\"$main::UserEnv{href}&c=grouppermmanager&group=$key&checkgroup=$key\">Manage Permissions</a></td><td> Be careful! - <a href=\"$main::UserEnv{href}&c=groupmanager&group=$key&act=delete\">delete $key</a></td></tr>";
	};
	};
$String .= "</table>";
return $String;
};

1;
