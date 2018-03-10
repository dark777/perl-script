# Action library for groupusermanager


sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute before Template generation
# uses $main::Form{group}

};

sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute After Template generation
# Example of adding Processed data to the Template:
# Unremark the following lines to see the action:
my($String2) = main::act_groupusermanager_form();

my($String) = "$main::Config{groupusermanager}{AddListField}";
$main::Html{ServiceText} =~ s!<insert-groupusermanager-addcontent>!$String!gis;
$main::Html{ServiceText} =~ s!<insert-groupusermanager-content>!$String2!gis;


};

sub main::act_groupusermanager_form
{
my(%OtherGroupUsers) = undef;
my(%ThisGroupUsers) = undef;

my($rtx) = Digest::MD5->new;
my($data) = undef;
my($digest) = undef;
$data = $main::Config{ServerAddress};
$rtx->add($data);
$digest = $rtx->hexdigest;
$main::Config{DbFile} = $main::Config{DbFolder} . "a_"."$digest".".cgi";
my(%UserData) = main::ReadIntConfig($main::Config{DbFile});	
my($key) = undef;

	foreach $key (sort {$UserData{$a}{name} cmp $UserData{$b}{name}} keys %UserData)
	{
	main::DebugOut("Checking user: $UserData{$key}{name}");
		if (($UserData{$key}{group} =~ m!^$main::Form{group}!i) || ($UserData{$key}{group} =~ m!,$main::Form{group},!i) || ($UserData{$key}{group} =~ m!$main::Form{group}$!i) )
		{
		main::DebugOut("User $UserData{$key}{name} is in this Group - OK: \$main::Form{rem} = $main::Form{rem}");
				if ($main::Form{rem} eq $UserData{$key}{name})
				{
				main::DebugOut("Removing from this Group - OK");
				
				$OtherGroupUsers{$key}{name} = $UserData{$key}{name};
				$UserData{$key}{group} =~ s!$main::Form{group}!!i;
				$UserData{$key}{group} =~ s!,,!,!ig;$UserData{$key}{group} =~ s!^\s+!!gi;$UserData{$key}{group} =~ s!\s+$!!gi;$UserData{$key}{group} =~ s!,$!!gi;$UserData{$key}{group} =~ s!^,!!gi;
				
				unless ($main::Config{DemoApp} == 1)
				{
				main::WriteIntConfig("config",\%UserData,$main::Config{DbFile});		
				};

				} else {
					main::DebugOut("NOT Removing from this Group - OK");
					$ThisGroupUsers{$key}{name} = $UserData{$key}{name};			
					};
		} else {
			main::DebugOut("User $UserData{$key}{name} is NOT in this - OK \$main::Form{addtogroup} = $main::Form{addtogroup}");
			
				if ($main::Form{addtogroup} eq $UserData{$key}{name})
				{
				main::DebugOut("Adding to this Group - OK");
				$ThisGroupUsers{$key}{name} = $UserData{$key}{name};
				$UserData{$key}{group} .= "," . "$main::Form{group}";
$UserData{$key}{group} =~ s!,,!,!ig;$UserData{$key}{group} =~ s!^\s+!!gi;$UserData{$key}{group} =~ s!\s+$!!gi;$UserData{$key}{group} =~ s!,$!!gi;$UserData{$key}{group} =~ s!^,!!gi;
				main::DebugOut("Adding $UserData{$key}{name} to group: $main::Form{addtogroup} : \"$UserData{$key}{group}\"");
					unless ($main::Config{DemoApp} == 1)
					{
					main::WriteIntConfig("config",\%UserData,$main::Config{DbFile});
					};
				} else {
					main::DebugOut("NOT Adding to this Group - OK");
					$OtherGroupUsers{$key}{name} = $UserData{$key}{name};					
					};
			};		
	};

my($AddListField) .= "\n<select size=\"9\" name=\"addtogroup\" multiple>";
foreach $key (sort {$OtherGroupUsers{$a}{name} cmp $OtherGroupUsers{$b}{name}} keys %OtherGroupUsers)
{
	if (defined $OtherGroupUsers{$key}{name})
	{
	$AddListField .= "\n<option>$OtherGroupUsers{$key}{name}</option>";	
	};
	
};
$AddListField .= "\n</select>";
$main::Config{groupusermanager}{AddListField} =  $AddListField;
my($String) = qq(
<table border="1" cellpadding="2" cellspacing="0" style="width:100%; font-family:verdana,arial; font-size:8pt; background:#4fa">
);
	foreach $key (sort {$ThisGroupUsers{$a}{name} cmp $ThisGroupUsers{$b}{name}} keys %ThisGroupUsers)
	{
		if (defined $ThisGroupUsers{$key}{name})
		{
		$String .= "\n<tr><td>$ThisGroupUsers{$key}{name} </td><td><a href=\"$main::UserEnv{href}&c=groupusermanager&group=$main::Form{group}&rem=$ThisGroupUsers{$key}{name}\"> Remove from group</a></td></tr>";	
		};		
	};
$String .= "</table>";
return $String;


};
1;
