sub main::lib_projectset_config
{
$main::Config{projects}{listfile} = $main::Config{DBFolder} . "projects.cgi";	
	if (-e $main::Config{projects}{listfile})
	{
	$main::Config{projects}{list} = main::ReadIntConfig($main::Config{projects}{listfile});	
	};
};
1;