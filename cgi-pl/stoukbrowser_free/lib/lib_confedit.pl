# Configuration Edit Library

sub main::lib_confedit_check
{
my(%CustomConfig) = undef;
my($key) = undef;
my($SubDebug) = $main::SubID{lib_confedit_check}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

my($Updated) = undef;
my($temp) = undef;
my(@KeySplitted) = undef;

	foreach $key (sort keys %main::Form)
	{
	($SubDebug == 1) ? DebugOut("\$key = $key - \$main::Form{$key} = $main::Form{$key}") : 0;
		if (($key) && (defined $main::Form{$key}))
		{
		($SubDebug == 1) ? DebugOut("OK - Key is defined : $key") : 0;

			if ($key =~ m!^update-(.*)!i)
			{
			($SubDebug == 1) ? DebugOut("OK - Config Key is defined: $1") : 0;
			$temp = $1;
			@KeySplitted = undef;
			@KeySplitted = split("-",$temp);
			
			if (($KeySplitted[0]) && ($KeySplitted[1]) && ($KeySplitted[2]))
			{
			$CustomConfig{$KeySplitted[0]}{$KeySplitted[1]}{$KeySplitted[2]} = $main::Form{$key};
			($SubDebug == 1) ? DebugOut("OK - Updated config for: \$temp = $temp... \$1 = $1 \$2 = $2... = \"$CustomConfig{$1}{$2}\"!") : 0;
			$Updated++;
			} elsif (($KeySplitted[0]) && ($KeySplitted[1]))
				{
				$CustomConfig{$KeySplitted[0]}{$KeySplitted[1]} = $main::Form{$key};
				($SubDebug == 1) ? DebugOut("OK - Updated config for: \$temp = $temp... \$1 = $1 \$2 = $2... = \"$CustomConfig{$1}{$2}\"!") : 0;
				$Updated++;
				} elsif ($KeySplitted[0]) 
					{
					$CustomConfig{$KeySplitted[0]} = $main::Form{$key};
					($SubDebug == 1) ? DebugOut("OK - Updated config for: \$temp = $temp... \$1 = $1 ... = \"$CustomConfig{$1}{$2}\"!") : 0;
					$Updated++;
					} else {
						($SubDebug == 1) ? DebugOut("FAILED: Attempt to update without providing keys: \"$KeySplitted[0]\" - \"$KeySplitted[1]\" - \"$KeySplitted[2]\"") : 0;						
						};

			};

		};
	};
	
	$main::Config{CustomConfigFile} = $main::Config{DbFolder} . $ENV{LOCAL_ADDR}. ".cgi";
	
	if ($Updated)
	{
	main::WriteIntConfig("config",\%CustomConfig,$main::Config{CustomConfigFile});
	($SubDebug == 1) ? DebugOut("OK - Custom Configuration was updated! for $Updated values.") : 0;
	undef %CustomConfig
	};
	
	if (-e $main::Config{CustomConfigFile})
	{
	($SubDebug == 1) ? DebugOut("OK - exists file: ". $main::Config{CustomConfigFile}) : 0;
	%CustomConfig = main::ReadIntConfig($main::Config{CustomConfigFile});		
	($SubDebug == 1) ? DebugOut("Custom Configuration was read : ". %CustomConfig) : 0;
		
		foreach $key (sort keys %CustomConfig)
		{
		($SubDebug == 1) ? DebugOut("Custom Config key: $key = $CustomConfig{$key}") : 0;
			if ($key)
			{
				if ($CustomConfig{$key} =~ m!^HASH\(0!)
				{
				($SubDebug == 1) ? DebugOut("Key is a reference:  $key = $CustomConfig{$key}") : 0;				
				$main::Config{$key} = \%{$CustomConfig{$key}};
				} else {
					($SubDebug == 1) ? DebugOut("Key is NOT a reference:  $key = $CustomConfig{$key}") : 0;				
					$main::Config{$key} = $CustomConfig{$key};
					};
			
			($SubDebug == 1) ? DebugOut("OK - Assigned from Custom Option: $key = $main::Config{$key}") : 0;
			};
		};
	return 0;	
	} else {
		($SubDebug == 1) ? DebugOut("NO - does not exist file: ". $main::Config{CustomConfigFile}. " running default configuration") : 0;
		return 1;
		};
	
};

sub main::lib_confedit_editform
{
my($key) = undef;
my($SubDebug) = $main::SubID{lib_confedit_editform}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
$main::Html{ConfigEditForm} = 
	qq(
	<table border=\"0\">
	<form method=\"post\" name=\"configeditform\" action=\"$main::Config{ScriptWebPath}\" target=\"_top\">
	);
	

	foreach $key (sort keys %main::Config)
	{
		if (($key) && (defined $key) && ($main::Config{CustomizeFilter}{$key} == 1)) 
		{
		$main::Html{ConfigEditForm} .= "\n<tr>" . "<td>$main::Html{Fs1} $key $main::Html{FF}</td><td>$main::Html{Fs1}<input type=\"text\" size=\"80\" name=\"cupdate-$key\" value=\"$main::Config{$key}\"/></td>$main::Html{FF}" . "</tr>";	
		};
	};
	
$main::Html{ConfigEditForm} .= 
	qq(
	<tr>
	<td></td><td><input type="submit" value=" Update! " /> <input type="submit" name="finish" value=" Finished Updates. " /></td>
	</tr>
	<input type="hidden" name="a" value="cupdate" />
	<input type="hidden" name="u" value="$main::UserEnv{digest}" />
	</form>
	</table>
	);	

return $main::Html{ConfigEditForm};
};

sub main::lib_confedit_updateconfig
{
my($ConfigFile) = $main::Config{ScriptRoot} . $main::Form{configeditfile};	
my(%CustomConfig) = undef;
my(%CustomHelp) = undef;

my($SubDebug) = $main::SubID{lib_confedit_updateconfig}{debug};
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