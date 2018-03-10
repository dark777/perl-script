# Action library for editaction


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
my($key) = undef;
my($String) = qq(
<table border="1" cellpadding="2" cellspacing="0" style="width:100%; font-family:verdana,arial; font-size:8pt; background:#ffa">
);


	if ($main::Form{aid})
	{
$key = $main::Form{aid};
	$String .= qq(
		<tr>
		<td>
		<b>View Action:</b>
		</td>
		<td>
		<b>Edit Form:</b>
		</td>
		<td>
		<b>Edit Header:</b>
		</td>
		<td>
		<b>Edit CSS:</b>
		</td>
		<td>
		<b>Edit HTML template:</b>
		</td>
		<td>
		<b>Edit Library:</b>
		</td>
		<td>
		<b>Edit Help:</b>
		</td>

		<td>
		<b>Delete Action:</b>
		</td>

		</tr>
		);
		
	$String .= qq(
		<tr>
		<td>
		<a href="$main::UserEnv{href}&c=$key">View: $key</a>
		</td>
		<td>
		<a href="$main::UserEnv{href}&c=pedit&pfile=hfile-$key">Body: $key</a>
		</td>
		<td>
		<a href="$main::UserEnv{href}&c=pedit&pfile=js-$key">Header: $key</a>
		</td>
		<td>
		<a href="$main::UserEnv{href}&c=pedit&pfile=css-$key">CSS: $key</a>
		</td>
		<td>
		<a href="$main::UserEnv{href}&c=hedit&htfile=htfile-$key">Html: $key</a>
		</td>
		<td>
		<a href="$main::UserEnv{href}&c=pedit&pfile=lib-$key">Lib: $key</a>
		</td>
		<td>
		<a href="$main::UserEnv{href}&c=pedit&pfile=help-$key">Help: $key</a>
		</td>

		<td>
		<a href="$main::UserEnv{href}&c=rmaction&rmaction=$key">Delete $key</a>
		</td>

		</tr>
		);

		
	};
$String .= "</table>";
# my($String) = "</br><b>My Data insert Example! ! !<b>";;
$main::Html{ServiceText} =~ s!<insert-editaction-content>!$String!gis;
my($String2) = undef;
$String2 = main::act_editaction_groupaccess();
$main::Html{ServiceText} =~ s!<insert-editaction-specialcontent>!$String2!gis;

};

sub main::act_editaction_groupaccess
{
my($String) = undef;
my($ConfigFile) = $main::Config{TtsFolder} . $main::ListConfig{afile}{name};
main::DebugOut("Reading Group Access: \"$ConfigFile\"");
my(%CustomConfig) = undef;
my($temp) = undef;
my($key) = undef;
my(@tg) = undef;

my($BgColor) = "";	
my(%Look) = undef;
%Look = %{main::lib_defaults_desktopstyle()};



	if (-f $ConfigFile)
	{
	%CustomConfig = main::ReadIntConfig($ConfigFile);	
	main::DebugOut("OK: \"$ConfigFile\"");
	main::DebugOut("CHECKING: \"$main::Form{aid}\"");		
		if (defined $CustomConfig{$main::Form{aid}})
		{
		main::DebugOut("Action is defined: \"$main::Form{aid}\"");
		
			@tg = split(",",$CustomConfig{$main::Form{aid}}{acl}{group});

			foreach $temp (@tg)
			{
				if (defined $temp)
				{
				$main::Config{editaction}{accessgroup}{$temp} = $temp;
				};
			};

#			$String = "<table border=$Look{TBorder} cellspacing=$Look{TCellSpacing} cellpadding=$Look{TCellPadding} style=\"width:100%;font-family:$Look{TextFontFace};font-size:$Look{TextFontSize}pt;color:$Look{TextFontColor};background:$Look{BgColor};\">";
			$String .= "<center><table cellpadding=1 cellspacing=0 border=1 style=\"width:640; font-family:verdana,arial; font-size:8pt; background:#aef\">";			
			$String .= "<tr><td>Access Group:</td><td>Allow Execute:</td></tr>";	
			foreach $key (sort keys %{$main::Config{Groups}})
			{
				if ($main::Config{Groups}{$key}{active} == 1)
				{
				$temp = "group_" . "$key";

				
					if ($main::Config{editaction}{accessgroup}{$key} eq $key)
					{
							if ($main::Form{$temp} eq "NO")
							{
							main::DebugOut("undefined \$main::Config{editaction}{accessgroup}{$key} = $main::Config{editaction}{accessgroup}{$key}");
							undef $main::Config{editaction}{accessgroup}{$key};
							main::DebugOut("undefined \$main::Config{editaction}{accessgroup}{$key} = $main::Config{editaction}{accessgroup}{$key}");
							$String .= "<tr><td>$key</td><td> +<input type=\"radio\" name=\"group_"."$key\" value=\"$key\" > -<input type=\"radio\" name=\"group_"."$key\" value=\"NO\" checked></td></tr>";	
							} else {
								
								$String .= "<tr><td>$key</td><td> +<input type=\"radio\" name=\"group_"."$key\" value=\"$key\" checked> -<input type=\"radio\" name=\"group_"."$key\" value=\"NO\"></td></tr>";				
								};

					
					} else {
						
						if ($main::Form{$temp} eq $key)
						{
						$main::Config{editaction}{accessgroup}{$key} = $key;
						$String .= "<tr><td>$key</td><td> +<input type=\"radio\" name=\"group_"."$key\" value=\"$key\" checked> -<input type=\"radio\" name=\"group_"."$key\" value=\"NO\"></td></tr>";
						} else {
							if ($main::Form{$temp} eq "NO")
							{
							main::DebugOut("undefined \$main::Config{editaction}{accessgroup}{$key} = $main::Config{editaction}{accessgroup}{$key}");
							undef $main::Config{editaction}{accessgroup}{$key};
							main::DebugOut("undefined \$main::Config{editaction}{accessgroup}{$key} = $main::Config{editaction}{accessgroup}{$key}");
							};
							$String .= "<tr><td>$key</td><td> +<input type=\"radio\" name=\"$temp\" value=\"$key\"> -<input type=\"radio\" name=\"$temp\" value=\"NO\" checked></td></tr>";
							};
						};
				
				};
			};
			$String .= "</table>";
		$CustomConfig{$main::Form{aid}}{acl}{group} = undef;
		
		foreach $key (sort keys %{$main::Config{editaction}{accessgroup}})
		{
			if (defined $main::Config{editaction}{accessgroup}{$key})
			{
				main::DebugOut("\$main::Config{editaction}{accessgroup}{$key} = $main::Config{editaction}{accessgroup}{$key}; \$CustomConfig{$main::Form{aid}}{acl}{group}  = $CustomConfig{$main::Form{aid}}{acl}{group} ");
				
				if ($CustomConfig{$main::Form{aid}}{acl}{group} =~ m!\w!i)
				{
				$CustomConfig{$main::Form{aid}}{acl}{group} .= ",".$key;	
				} else {
					$CustomConfig{$main::Form{aid}}{acl}{group} .= $key;
					};
			};
		};

		main::DebugOut("Updating Configuration file with New Group Access List: \"$CustomConfig{$main::Form{aid}}{acl}{group}\"");
		main::WriteIntConfig("config",\%CustomConfig,"$ConfigFile");

		} else {
			main::DebugOut("FAILED:  \"$main::Form{aid}\"");		
			};
		
	} else {
		main::DebugOut("FAILED: Could not open Action File: \"$ConfigFile\"");		
		};
	
return $String;	
};

1;
