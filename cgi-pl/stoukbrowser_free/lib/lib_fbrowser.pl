sub main::lib_fbrowser_readconfig
{
$main::Config{bfrowser}{fbrowserfolder} = $main::Config{DbFolder} . "fbrowser" . "/";
unless (-e $main::Config{bfrowser}{fbrowserfolder}) {mkdir($main::Config{bfrowser}{fbrowserfolder},0777)};
$main::Config{bfrowser}{configfile} = $main::Config{bfrowser}{fbrowserfolder} . "fbrowser.cgi";
$main::Config{bfrowser}{userconfigfile} = $main::Config{bfrowser}{fbrowserfolder} . "fbrowser.cgi";
$main::Config{bfrowser}{configrenamedfile} = $main::Config{bfrowser}{fbrowserfolder} . "fbrowserren.cgi";
$main::Config{bfrowser}{jssourcetplpath} = $main::Config{ScriptRoot} . $main::ConfigEnv{ScriptsFolder} . "tree_tpl.js";
# $main::Config{bfrowser}{jssourcetplwebpath} = $main::Config{ScriptWebRoot} . $main::ConfigEnv{ScriptsFolder} . "tree_tpl.js";
$main::Config{bfrowser}{jssourcenavpath} = $main::Config{ScriptRoot} . $main::ConfigEnv{ScriptsFolder} . "tree.js";
$main::Config{bfrowser}{jssourcenavwebpath} = $main::Config{ScriptWebRoot} . $main::ConfigEnv{ScriptsFolder} . "tree.js";

my(%Temp) = undef;
my(%UTemp) = undef;

	if (-e $main::Config{bfrowser}{configfile})
	{
	# print "<br>Configfile exists - OK \$main::Config{fbrowser}{config}{roots}{$key}{path} = $main::Config{fbrowser}{config}{roots}{$key}{path}";
	%Temp = main::ReadIntConfig($main::Config{bfrowser}{configfile});	
	$main::Config{fbrowser}{config} = \%Temp;
	my($key) = undef;
			foreach $key (sort {$main::Config{fbrowser}{config}{roots}{$a}{name} cmp $main::Config{fbrowser}{config}{roots}{$b}{name}} keys %{$main::Config{fbrowser}{config}{roots}})
			{
				# print "<br>Checking \$main::Config{fbrowser}{config}{roots}{$key}{path} = $main::Config{fbrowser}{config}{roots}{$key}{path}";
				if ((defined $main::Config{fbrowser}{config}{roots}{$key}) && (-e $main::Config{fbrowser}{config}{roots}{$key}{path}) )
				{
				# print "<br>\$key = $key";
				unless (defined $main::Config{fbrowser}{defaultkey})
				{
				$main::Config{fbrowser}{defaultkey} = $key;	
				};
				
				$main::Config{fbrowser}{config}{roots}{$key}{jspitemspath} = 	$main::Config{ImagesRoot} . "$key" . "_fbrowser".".js";
				$main::Config{fbrowser}{config}{roots}{$key}{jsitemswebpath} = $main::Config{ImagesWebRoot} . "$key" . "_fbrowser". ".js";
				$main::Config{fbrowser}{config}{roots}{$key}{jsnavtplpath} = 	$main::Config{ImagesRoot} . "$key" . "_fbrowsertpl".".js";
				$main::Config{fbrowser}{config}{roots}{$key}{jsnavtplwebpath} = $main::Config{ImagesWebRoot} . "$key" . "_fbrowsertpl". ".js";
			
				};
			};
	
		if (-e $main::Config{bfrowser}{userconfigfile})
		{
		%UTemp	= main::ReadIntConfig($main::Config{bfrowser}{userconfigfile});
		$main::Config{fbrowser}{userconfig} = \%UTemp;
		};
	} else {
		main::lib_fbrowser_saveconfig();
		};

	if (-e $main::Config{bfrowser}{configrenamedfile})
	{
	my(@ListToRename) = main::ReadFile($main::Config{bfrowser}{configrenamedfile});	
	my($line) = undef;
	my(@tmpout) = undef; my($cntout) = undef;
	my($orig) = undef; my($dest) = undef;
		if (@ListToRename)		
		{
			foreach $line (@ListToRename)
			{
				($dest,$orig,@tmp) = split(/\|/,$line);
				if (-f $orig)
				{
					rename($orig,$dest);	
					if (-f $dest)
					{
						# Renamed - OK
					} else {
							if (-e $orig)
							{
							# Could not rename
							$tmpout[$cntout++] = $line;	
							};
						};
				};
			};
		};
		if ($cntout > 0)
		{
			main::SaveFile($main::Config{bfrowser}{configrenamedfile},@tmpout);
		};
	};
};

sub main::lib_fbrowser_saveconfig
{
	unless ($main::Config{DemoApp} == 1)
	{
	main::WriteIntConfig("config",$main::Config{fbrowser}{config},$main::Config{bfrowser}{configfile});
	};

};
sub main::lib_fbrowser_saveuserconfig
{
main::WriteIntConfig("config",$main::Config{fbrowser}{userconfig},$main::Config{bfrowser}{userconfigfile});
};


1;