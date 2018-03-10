# Action library for commanddesc


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

my($String) = main::act_commanddesc_form();
$main::Html{ServiceText} =~ s!<insert-commanddesc-content>!$String!gis;
};

sub main::act_commanddesc_form
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($key) = undef;
my($String) = main::lib_config_defaultstyle();
$String .= qq(
<DIV style=\"background:$main::Config{divopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor}\">
<center>
	<table BORDER=\"$main::Config{wms}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{tbopt}{tb_cpadding}\" CELLSPACING=\"$main::Config{tbopt}{tb_cspacing}\" 
	style=\"width:640; font-family:$main::Config{divopt}{tb_fontfamily}; 
	font-size:$main::Config{divopt}{tb_fontsize}pt; background:$main::Config{tbopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor};\">
<tr>
	<td>
	<b>Command Name:</b>
	</td>
	<td>
	<b>Command Page Title:</b>
	</td>	
</tr>
);

	foreach $key (sort keys %ActConfig)
	{
		if ($key)
		{
		$String .= "<tr><td>".ucfirst($key) ." </td><td style=\"width:500\">";
			if (length($main::Form{$key}) > 0)
			{
			$ActConfig{$key}{description} = $main::Form{$key};
			};
		$String .= "\n<input type=\"text\" size=\"80\" name=\"$key\" value=\"$ActConfig{$key}{description}\" style=\"font-size:8pt\"></td>";		
		$String .= "</tr>";					
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
			</tr>
</table>
</center>
<p>
</DIV>
);
return $String;	
	
};
1;
