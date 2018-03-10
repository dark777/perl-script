sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
			if ($main::Form{cfile} =~ m!(\w[\d\w]*)-(\w[\d\w]*)!i)
			{
				if (-f ($main::Config{TtsFolder} . $main::ListConfig{$1}{$2}))
				{
				($SubDebug == 1) ? DebugOut("Processing Configuration Edit for \"$main::ListConfig{$1}{$2}\"") : 0;		
				main::act_cedit_configeditform(($main::Config{TtsFolder} . $main::ListConfig{$1}{$2}));	
				} else {
					main::AddError{"e00001","No File: ($main::Config{TtsFolder} . $main::ListConfig{$1}{$2})"};
					($SubDebug == 1) ? DebugOut("FAILED: No File: ($main::Config{TtsFolder} . $main::ListConfig{$1}{$2})") : 0;		
					};
			} else {
				main::AddError{"e00001","Parameter Was not Passed: \$main::Form{cfile} = \"$main::Form{cfile}\""};
				($SubDebug == 1) ? DebugOut("FAILED: Wrong Parameter to open Configuration file!") : 0;		
				};
};

sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
				if ($main::Html{ServiceText} =~ m!(_insert-cedit-content_)!gis)
				{
				$main::Html{ServiceText} =~ s!$1!$main::Html{ConfigEditForm}!is;
				} else {
					($SubDebug == 1) ? DebugOut("FAILED: Could not find pattern: \"_insert-cedit-content_\"") : 0;
					};			
};

sub main::act_cedit_configeditform
{

my($ConfigFile) = $_[0];	
my($StyleFontSize) = "8pt";
my(@KeyColor) = ("#CCFFFF","#D0DEFA","#F9E9EA","#CCFFCC","#FFFFFF");
my($StyleColors) = 5;
my($StyleColor) = undef;
my($KeyCount) = undef;
my($SubDebug) = $main::SubID{lib_confedit_configeditform}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($ConfigFileKey) = $main::Form{configeditfile};
my($updated) = undef;
my(%CustomConfig) = undef;
my($key) = undef;
undef $main::Html{ConfigEditForm};
my($KeyFieldLength) = $main::Style{Developer}{ConfigForm}{KeyFieldLength};
my($ValueFieldLength) = $main::Style{Developer}{ConfigForm}{ValueFieldLength};

if ($KeyFieldLength < 5) {$KeyFieldLength = 15};
if ($ValueFieldLength < 5) {$ValueFieldLength = 25};
 $main::Html{ConfigEditForm} = 
	qq(
	<br>Editing: <b>"$ConfigFile"</b>
	<table cellpadding="0" cellspacing="0">
	<tr>

		<td>$main::Html{Fs1}New Key:    <input type="text" size="$KeyFieldLength" name="createkey" value=""/> $main::Html{FF}
		<br>$main::Html{Fs1} Sub Key 1: <input type="text" size="$KeyFieldLength" name="subkey1" value=""/> $main::Html{FF}
		<br>$main::Html{Fs1} Sub Key 2: <input type="text" size="$KeyFieldLength" name="subkey2" value=""/> $main::Html{FF}
		<br>$main::Html{Fs1} Value: <input type="text" size="$ValueFieldLength" name="createkeyvalue" value=""/>$main::Html{FF}</td>
		<td></td>
		</tr>
	</tr>

	</table>
	<hr>
<table border="0" cellpadding="0" cellspacing="0">
	);
	

unless (-e $ConfigFile) {main::SaveFile("config","<config>\n</config>",$ConfigFile)};

 	if (-e $ConfigFile)
	{
 	$updated = main::act_cedit_updateconfig($ConfigFile);
 	($SubDebug == 1) ? DebugOut("Updated - \"$updated\" options.") : 0;
 	undef %CustomConfig;
 	%CustomConfig = main::ReadIntConfig($ConfigFile);	
	$main::Html{ConfigEditForm} .= "\n<tr>" . "<td>$main::Html{Fs1} Key Name: (Do Not Change.)$main::Html{FF}</td><td>$main::Html{Fs1} Key Value: (Change is allowed.) $main::Html{FF}</td>" . "<td>Delete?</td>"."</tr>\n<br>";			
		foreach $key (sort keys %CustomConfig)
		{
			if ($key) 
			{
			$KeyCount++;
			$StyleColor = "background:$KeyColor[(($KeyCount++) % $StyleColors)]";
				unless ($CustomConfig{$key} =~ m!^HASH\(0!)
				{
$CustomConfig{$key} = main::lib_html_Escape($CustomConfig{$key});
$main::Html{ConfigEditForm} .= 
qq(
<tr>
<td>$main::Html{Fs1} 
<div><input type=text name=box value="$key" style="font-family:verdana,arial; font-size:$StyleFontSize; $StyleColor" ; onFocus="this.blur()"; onChange=this.value="$key"; onClick=this.form.createkey.value=this.value; size=$KeyFieldLength></div>
$main::Html{FF}</td>
<td>$main::Html{Fs1}
 : <input type=\"text\" size=\"$ValueFieldLength\" name=\"update-$key\" value=\"$CustomConfig{$key}\" style="font-family:verdana,arial; font-size:$StyleFontSize; $StyleColor"/>
</td>$main::Html{FF}
<td><input type=\"checkbox\" name=\"delete-$key\" value=\"1\"></td>
</tr>
);
				($SubDebug == 1) ? DebugOut("Key is Not a reference: $CustomConfig{$key} ") : 0;
				} else {
					my($SubKey) = undef;
					($SubDebug == 1) ? DebugOut("Key is a reference: $CustomConfig{$key} ") : 0;
						foreach $SubKey (sort keys %{$CustomConfig{$key}})
						{
							if ($SubKey)
							{
							my($SubSubKey) = undef;
								if ($CustomConfig{$key}{$SubKey} =~ m!^HASH\(0!)
								{
								($SubDebug == 1) ? DebugOut("Key is a reference: \$SubKey = $CustomConfig{$key}{$SubKey} ") : 0;

									foreach $SubSubKey (sort keys %{$CustomConfig{$key}{$SubKey}})
									{
										if ($SubSubKey)
										{

$CustomConfig{$key}{$SubKey}{$SubSubKey} = main::lib_html_Escape($CustomConfig{$key}{$SubKey}{$SubSubKey});										
$main::Html{ConfigEditForm} .= 
qq(
<tr>
<td>
$main::Html{Fs1}
<div>
<input type=text name=box1 value="$key"  style="font-family:verdana,arial; font-size:$StyleFontSize; $StyleColor" ; onFocus="this.blur()" ; onChange=this.value="$key"; onClick=this.form.createkey.value=this.value;  size=$KeyFieldLength>
-<font size=+1>
<input type=text name=box2 value="$SubKey" style="font-family:verdana,arial; font-size:$StyleFontSize; $StyleColor" ; onFocus="this.blur()" ; onChange=this.value="$SubKey"; onClick=this.form.subkey1.value=this.value; size=$KeyFieldLength>
</font>-
<input type=text name=box3 value="$SubSubKey" style="font-family:verdana,arial; font-size:$StyleFontSize; $StyleColor"; onFocus="this.blur()" ; onChange=this.value="$SubSubKey"; onClick=this.form.subkey2.value=this.value; size=$KeyFieldLength></div>
$main::Html{FF}
 </td><td>$main::Html{Fs1}
 :  <input type=\"text\" size=\"$ValueFieldLength\" name=\"update-$key-$SubKey-$SubSubKey\" value=\"$CustomConfig{$key}{$SubKey}{$SubSubKey}\" style="font-family:verdana,arial; font-size:$StyleFontSize; $StyleColor"/>
 </td>$main::Html{FF}
<td><input type=\"checkbox\" name=\"delete-$key-$SubKey-$SubSubKey\" value=\"1\"></td>
</tr>
);
										};
									};
								} else {
$CustomConfig{$key}{$SubKey} = main::lib_html_Escape($CustomConfig{$key}{$SubKey});
$main::Html{ConfigEditForm} .= 
qq(
<tr>
<td>$main::Html{Fs1} 
<div>
<input type=text name=box1 value="$key" style="font-family:verdana,arial; font-size:$StyleFontSize; $StyleColor" ; onFocus="this.blur()" ; onChange=this.value="$key"; onClick=this.form.createkey.value=this.value; size=$KeyFieldLength>
-<font size=+1>
<input type=text name=box2 value="$SubKey" style="font-family:verdana,arial; font-size:$StyleFontSize; $StyleColor" ; onFocus="this.blur()" ; onChange=this.value="$SubKey"; onClick=this.form.subkey1.value=this.value; size=$KeyFieldLength></div>
</font>$main::Html{FF}</td>
<td>$main::Html{Fs1}
 : <input type=\"text\" size=\"$ValueFieldLength\" name=\"update-$key-$SubKey\" value=\"$CustomConfig{$key}{$SubKey}\" style="font-family:verdana,arial; font-size:$StyleFontSize; $StyleColor"/></td>$main::Html{FF}
<td><input type=\"checkbox\" name=\"delete-$key-$SubKey\" value=\"1\"></td>
</tr>
);
									};
							};
						};
					
					};	
			}; 	
		};
	} else {
		($SubDebug == 1) ? DebugOut("FAILED - Config File does not exist or no permissions to write: \"$ConfigFile\"") : 0;
		main::AddError("e13");
		};
$main::Html{ConfigEditForm} .= 
	qq(
	</table>
	);	
# $main::Html{ServiceData} .= $main::Html{ConfigEditForm};
return $main::Html{ConfigEditForm};
};


sub main::act_cedit_updateconfig
{
my($ConfigFile) = $_[0];	
my(%CustomConfig) = undef;
my(%CustomHelp) = undef;

my($SubDebug) = $main::SubID{act_cedit_updateconfig}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;


my($temp) = undef;

unless (-e $ConfigFile) {($SubDebug == 1) ? DebugOut("FAILED: Does not exist: \"$ConfigFile\"") : 0;};
my($updated) = undef;
	if (-e $ConfigFile)
	{
	($SubDebug == 1) ? DebugOut("OK - Updating configuration for \"$ConfigFile\"") : 0;
	%CustomConfig = main::ReadIntConfig($ConfigFile);
		foreach $key (sort keys %CustomConfig)
		{
			if ($key)
			{
				if ($CustomConfig{$key} =~ m!^HASH\(0!i)
				{
				my($SubKey) = undef;
				($SubDebug == 1) ? DebugOut("Is a hash: ($key) $CustomConfig{$key} ") : 0;
					foreach $SubKey (sort keys %{$CustomConfig{$key}})
					{
						if ($SubKey)
						{
						$temp = "update"."-" . "$key" . "-" . "$SubKey";
							if ($CustomConfig{$key}{$SubKey} =~ m!^HASH\(0!i)
							{
							my($SubSubKey) = undef;			
							($SubDebug == 1) ? DebugOut("Is a hash: ($key){$SubKey} $CustomConfig{$key}{$SubKey}") : 0;					
								foreach $SubSubKey (sort keys %{$CustomConfig{$key}{$SubKey}})
								{
									if ($SubSubKey)
									{
									$temp = "update"."-" . "$key" . "-" . "$SubKey". "-". "$SubSubKey";
										if ($main::Form{"update"."-" . "$key" . "-" . "$SubKey". "-". "$SubSubKey"})
										{
											unless ($main::Form{("delete"."-"."$key". "-". "$SubKey" . "-" . "$SubSubKey")} == 1)
											{
											$CustomConfig{$key}{$SubKey}{$SubSubKey} = $main::Form{$temp};
											($SubDebug == 1) ? DebugOut("$key->$SubKey->$SubSubKey - Updated - OK ") : 0;
											$updated++;						
											} else {
												undef $CustomConfig{$key}{$SubKey}{$SubSubKey};
													unless (defined %{$CustomConfig{$key}{$SubKey}}) 
													{
													undef $CustomConfig{$key}{$SubKey}
													} else 	{
														($SubDebug == 1) ? DebugOut("Returned Some Values from $CustomConfig{$key}{$SubKey}") : 0;
														};
												($SubDebug == 1) ? DebugOut("OK - Deleted configuration key: \"$key\"->\"$SubKey\"->\"$SubSubKey\"") : 0;
												};
										} else {
											($SubDebug == 1) ? DebugOut("No Such Form Parameter: \"$main::Form{$temp}\"") : 0;
											};
									};								
								
								};
							} else {
									if ($main::Form{$temp})
									{
																
										unless ($main::Form{("delete"."-"."$key". "-". "$SubKey")} == 1)
										{
										$CustomConfig{$key}{$SubKey} = $main::Form{$temp};
										($SubDebug == 1) ? DebugOut("$key->$SubKey - Updated - OK ") : 0;
										$updated++;						
										} else {
											undef $CustomConfig{$key}{$SubKey};
											($SubDebug == 1) ? DebugOut("OK - Deleted configuration key: \"$key\"->\"$SubKey\"") : 0;
											};
									} else {
										($SubDebug == 1) ? DebugOut("No Such Form Parameter: \"$main::Form{$temp}\"") : 0;
										};
								};
						
						
							
						};
					};
				} else {
					$temp = "update"."-" . "$key";
						if ($main::Form{$temp})
						{
							unless ($main::Form{("delete"."-"."$key")} == 1)
							{
							$CustomConfig{$key} = $main::Form{$temp};
							($SubDebug == 1) ? DebugOut("$key - Updated - OK ") : 0;
							$updated++;
							} else {
								undef $CustomConfig{$key};
								($SubDebug == 1) ? DebugOut("OK - Deleted configuration key: \"$key\"") : 0;
								};
						};
					};
			};
		};
		if (($main::Form{createkey}) && ($main::Form{createkeyvalue}) )
		{
		$main::Form{createkey} =~ s!-!_!gi;
		if ($main::Form{subkey1}) {$main::Form{subkey1} =~ s!-!_!gi; $main::Form{createkey} .= "-" . "$main::Form{subkey1}"};
		if ($main::Form{subkey2}) {$main::Form{subkey2} =~ s!-!_!gi; $main::Form{createkey} .= "-" . "$main::Form{subkey2}"};
				if (($main::Form{createkey} =~ m!^(\w[0-9a-zA-Z]*$)!) || ($main::Form{createkey} =~ m!^(\w[0-9a-zA-Z]*)-(\w[0-9a-zA-Z]*)$!) || ($main::Form{createkey} =~ m!^(\w[0-9a-zA-Z]*)-(\w[0-9a-zA-Z]*)-(\w[0-9a-zA-Z]*)$!))
				{
				$temp = $1;
					if ($2)				
					{
						if ($3)
						{
						($SubDebug == 1) ? DebugOut("OK - creating new configuration key: \"$temp\"-\"$2\"-\"$3\" = $main::Form{createkeyvalue}") : 0;
						$CustomConfig{$temp}{$2}{$3} = $main::Form{createkeyvalue};
						$updated++;
						} else {
							($SubDebug == 1) ? DebugOut("OK - creating new configuration key: \"$temp\"-\"$2\" = $main::Form{createkeyvalue}") : 0;
							$CustomConfig{$temp}{$2} = $main::Form{createkeyvalue};
							$updated++;
							};
					
					} else {
						($SubDebug == 1) ? DebugOut("OK - creating new configuration key: \"$temp\" = $main::Form{createkeyvalue}") : 0;
						$CustomConfig{$temp} = $main::Form{createkeyvalue};
						$updated++;
						};
				} elsif ($main::Form{createkey} =~ m!(.*)!) 
					{
					($SubDebug == 1) ? DebugOut("FAILED - Cannot create the following key: \"$1\"") : 0;
					main::AddError("e13");
					};
			
		};
	} else {
		($SubDebug == 1) ? DebugOut("FAILED -Config File does not exist: \"$ConfigFile\"") : 0;
		};
if ($updated) {$main::Config{UpdatedConfig} = \%CustomConfig; main::WriteIntConfig("config",\%CustomConfig,"$ConfigFile")};

return $updated;
};

1;
