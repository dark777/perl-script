# Action library for grouppermmanager


sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute before Template generation

my($key) = undef;
my(@temp) = undef;				
my(@newtemp) = undef; 
my($count) = undef;
my($grp) = undef;
my($group) = undef;
my($on) = undef;
my($changed) = undef;

	if ($main::Form{checkgroup} =~ m!\w+!)
	{
		foreach $key (keys %ActConfig)
		{
			if ($key)
			{
			@temp = split(",",$ActConfig{$key}{acl}{group});	
			$count = 0;
			$on = undef;
			$changed = undef;
			@newtemp = undef;
					foreach $group (@temp)
					{
						if ($group)
						{
							if ("$group" ne "$main::Form{checkgroup}")
							{
							$newtemp[$count++] = $group;
							};
							
							
							if ("$group" eq "$main::Form{checkgroup}") 
							{
								
								if ($main::Form{$key} eq "OFF")
								{
								($SubDebug == 1) ? DebugOut("Turning OFF Permission for $key for group: $group") : 0;
								$changed  = 1;
								} else {
									$newtemp[$count++] = $group;
									$on = 1;
									};
							};
						
						};
					};
	
				if ($main::Form{$key} eq "ON")
				{
					unless ($on)
					{
					$newtemp[$count++] = $main::Form{checkgroup};	
					($SubDebug == 1) ? DebugOut("Turning ON Permission for $key for group $group") : 0;
					$changed = 1;	
					};
				};
			$ActConfig{$key}{acl}{group} = join(",",@newtemp);
	
				if ($changed == 1)
				{
				($SubDebug == 1) ? DebugOut("CHANGED PERMISSIONS: \$ActConfig{$key}{acl}{group} = $ActConfig{$key}{acl}{group} ") : 0;	
				};
			};
		};
	
	($SubDebug == 1) ? DebugOut("Updating Configuration. - $main::Config{ActConfigFile}") : 0;	
		unless ($main::Config{DemoApp} == 1)
		{
		main::WriteIntConfig("config",\%ActConfig,"$main::Config{ActConfigFile}");	
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

my($String) = main::act_grouppermmanager_form();
$main::Html{ServiceText} =~ s!<insert-grouppermmanager-content>!$String!gis;
};


sub main::act_grouppermmanager_form
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($key) = undef;
my($String) = main::lib_config_defaultstyle();
%ActConfig = main::ReadIntConfig($main::Config{ActConfigFile});
$String .= qq(
<DIV style=\"background:$main::Config{divopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor}\">
<b>Permissions for Group: $main::Form{checkgroup}</b>
<br>
<a href=\"$main::UserEnv{href}&c=groupmanager\">Back to all groups</a><br>

	<table BORDER=\"$main::Config{wms}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{tbopt}{tb_cpadding}\" CELLSPACING=\"$main::Config{tbopt}{tb_cspacing}\" 
	style=\"width:640; font-family:$main::Config{divopt}{tb_fontfamily}; 
	font-size:$main::Config{divopt}{tb_fontsize}pt; background:$main::Config{tbopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor};\">
<tr>
	<td>

	</td>
	<td>

	</td>
	<td>

	</td>	
</tr>
);

	foreach $key (sort keys %ActConfig)
	{
		if ($key)
		{
		$String .= "<tr><td><b>".ucfirst($key)."</b> <font size=1>($ActConfig{$key}{description})</font></td><td style=\"width:50\">";
		# ($SubDebug == 1) ? DebugOut("checking if $ActConfig{$key}{acl}{group} contains $main::Form{checkgroup}") : 0;
			if ($ActConfig{$key}{acl}{group} =~ m!$main::Form{checkgroup}!i)
			{
			$String .= "\n [+ <input type=\"radio\" name=\"$key\" value=\"ON\" style=\"background:#336666\" checked>]</td><td style=\"width:50\">";
			$String .= "\n [- <input type=\"radio\" name=\"$key\" value=\"OFF\">]</td><td>";
			} else {
				$String .= "\n [+ <input type=\"radio\" name=\"$key\" value=\"ON\">]</td><td style=\"width:50\">";
				$String .= " [- <input type=\"radio\" name=\"$key\" value=\"OFF\" style=\"background:#CC3300\" checked>]</td><td>";					
				};
		$String .= "</td></tr>";
		};
	};	

	unless ($main::Config{DemoApp} == 1)
	{
	main::WriteIntConfig("config",\%ActConfig,"$main::Config{ActConfigFile}");
	};



	$String .= qq(<tr>
					<td>
					</td>
					<td>
					</td>
					<td>
					</td>
			</tr>
</table>

<p>
</DIV>
);
return $String;	

};
1;
