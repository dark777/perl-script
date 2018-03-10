# Action library for configdb


sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute before Template generation
my($CustomServerConfigFile) = $main::Config{DbFolder} . $main::Config{ServerAddress}. ".cgi";
my($key) = undef;
my(%CurrentConfig) = main::ReadIntConfig($CustomServerConfigFile);

	if ($main::Form{DBType} eq "NONE")
	{
	undef $CurrentConfig{DBType};
	undef $main::Form{DBType};
	undef $CurrentConfig{DSN};
	undef $main::Form{DSN};	
	undef $CurrentConfig{DBServer};
	undef $main::Form{DBServer};	
	undef $CurrentConfig{DBPort};
	undef $main::Form{DBPort};	
	undef $CurrentConfig{DBName};
	undef $main::Form{DBName};	
	undef $CurrentConfig{DBUser};
	undef $main::Form{DBUser};	
	undef  $CurrentConfig{DBPassword};
	undef $main::Form{DBPassword};	
	main::WriteIntConfig("config",\%CurrentConfig,$CustomServerConfigFile);
		unless ($main::Form{RS} == 1)
		{
		$main::Config{act_configdb}{Message} = main::lib_html_Redirect($main::UserEnv{href} . "&c=configdb&DBType=NONE&RS=1");		
		} else {
				if ($main::Form{RAISED} == 1)
				{
				$main::Config{act_configdb}{Message} = "Automatically turned off Database Support because of the error connecting to database.<br>";	
				};
			};
	
	} else {
			if (($main::Form{DBType} eq "ACCESS") || ($main::Form{DBType} eq "MYSQL") || ($main::Form{DBType} eq "MSSQL") )
			{
						# Database Type
						if (length($main::Form{DBType}) > 0)
						{
						$CurrentConfig{DBType} = "$main::Form{DBType}";	
						$Config{DBType} = "$main::Form{DBType}";	
						} else {
								unless ($main::Form{ClearDBType} eq "NONE")
								{
									if (defined $CurrentConfig{DBType})
									{
									$main::Form{DBType} = $CurrentConfig{DBType};	
									};
								} else {
									undef $CurrentConfig{DBType};
									};
							};
		
						# DSN
						if (length($main::Form{DSN}) > 0)
						{
						$CurrentConfig{DSN} = "$main::Form{DSN}";	
						$Config{DSN} = "$main::Form{DSN}";
						} else {
								unless ($main::Form{ClearDSN} == 1)
								{
									if (defined $CurrentConfig{DSN})
									{
									$main::Form{DSN} = $CurrentConfig{DSN};	
									};
								} else {
									undef $CurrentConfig{DSN};
									};
							};
		
						# DBServer
						if (length($main::Form{DBServer}) > 0)
						{
						$CurrentConfig{DBServer} = "$main::Form{DBServer}";	
						$Config{DBServer} = "$main::Form{DBServer}";	
						} else {
								unless ($main::Form{ClearDBServer} == 1)
								{
									if (defined $CurrentConfig{DBServer})
									{
									$main::Form{DBServer} = $CurrentConfig{DBServer};	
									};
								} else {
									undef $CurrentConfig{DBServer};
									};
							};
		
						# DBPort
						if (length($main::Form{DBPort}) > 0)
						{
						$CurrentConfig{DBPort} = "$main::Form{DBPort}";	
						$Config{DBPort} = "$main::Form{DBPort}";
						} else {
								unless ($main::Form{ClearDBPort} == 1)
								{
									if (defined $CurrentConfig{DBPort})
									{
									$main::Form{DBPort} = $CurrentConfig{DBPort};	
									};
								} else {
									undef $CurrentConfig{DBPort};
									};
							};
		
						# DBName
						if (length($main::Form{DBName}) > 0)
						{
						$CurrentConfig{DBName} = "$main::Form{DBName}";	
						$Config{DBName} = "$main::Form{DBName}";
						} else {
								unless ($main::Form{ClearDBName} == 1)
								{
									if (defined $CurrentConfig{DBName})
									{
									$main::Form{DBName} = $CurrentConfig{DBName};	
									};
								} else {
									undef $CurrentConfig{DBName};
									};
							};
		
		
						# DBUser
						if (length($main::Form{DBUser}) > 0)
						{
						$CurrentConfig{DBUser} = "$main::Form{DBUser}";	
						$Config{DBUser} = "$main::Form{DBUser}";	
						} else {
								unless ($main::Form{ClearDBUser} == 1)
								{
									if (defined $CurrentConfig{DBUser})
									{
									$main::Form{DBUser} = $CurrentConfig{DBUser};	
									};
								} else {
									undef $CurrentConfig{DBUser};
									};
							};
		
						# DBPassword
						if (length($main::Form{DBPassword}) > 0)
						{
						$CurrentConfig{DBPassword} = "$main::Form{DBPassword}";	
						$Config{DBPassword} = "$main::Form{DBPassword}";
						} else {
								unless ($main::Form{ClearDBPassword} == 1)
								{
									if (defined $CurrentConfig{DBPassword})
									{
									$main::Form{DBPassword} = $CurrentConfig{DBPassword};	
									};
								} else {
									undef $CurrentConfig{DBPassword};
									};
							};
						# DSNLess
						if ($main::Form{DSNLess} == 1)
						{
						$CurrentConfig{DSNLess} = "$main::Form{DSNLess}";	
						$Config{DSNLess} = "$main::Form{DSNLess}";
						} else {
							undef $CurrentConfig{DSNLess};
		
							};


						if ((length($main::Form{DBServer}) > 0) || (length($main::Form{DSN})> 0) )
						{
						main::act_configdb_test();
							if ($main::Config{DBConnected} == 1)	
							{
							main::WriteIntConfig("config",\%CurrentConfig,$CustomServerConfigFile);	
							};
						} elsif (($main::Form{DBType} eq "ACCESS") && ($main::Form{DSNLess} == 1) )
							{
							main::act_configdb_test();			
								if ($main::Config{DBConnected} == 1)	
								{
								main::WriteIntConfig("config",\%CurrentConfig,$CustomServerConfigFile);	
								};
							};
			
			};

		
		};
					if ($main::Config{DBConnected} == 1)
					{
						if (($main::Form{DBType} eq "ACCESS") || ($main::Form{DBType} eq "MYSQL") || ($main::Form{DBType} eq "MSSQL") )
						{
							if (main::act_configdb_test())
							{
							$main::Config{act_configdb}{Message} .= "<b>Connected to Database ($main::Config{DBType}) - OK!</b>";	
							};
						
						} else {
							$main::Config{act_configdb}{Message} .= "<b>Database not connected...</b>";
							};
					} else {
						$main::Config{act_configdb}{Message} .= "<b>Database not connected...</b>";
						};



};

sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute After Template generation
# Example of adding Processed data to the Template:
# Unremark the following lines to see the action:

my($String) = $main::Config{act_configdb}{Message} . "" . main::act_configdb_form();
$main::Html{ServiceText} =~ s!<insert-configdb-content>!$String!gis;
};


sub main::act_configdb_test
{
my($SubDebug) = $main::SubID{act_configdb_test}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... testing connection to database...") : 0;

unless ($main::Config{DBConnected} == 1)
{
	if ($main::Form{DBType} eq "ACCESS")
	{
        main::LoadLibrary("lib_dbaccess.pl");
        main::ConnectDatabase();
	} elsif ($main::Form{DBType} eq "MYSQL")
	{
        main::LoadLibrary("lib_dbmysql.pl");
        main::ConnectDatabase();
	} elsif ($main::Form{DBType} eq "MSSQL")
	{
        main::LoadLibrary("lib_dbmssql.pl");
        main::ConnectDatabase();
	};

};

	unless ($main::Config{DBConnected} == 1) 
	{
	$main::Config{act_configdb}{Message} = main::lib_html_Redirect($main::UserEnv{href} . "&c=configdb&DBType=NONE&RS=1&RAISED=1");
	};
return $main::Config{DBConnected};
};


sub main::act_configdb_form
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($String) = undef;
my(%Style) = undef;
my($temp) = undef;
%Style = main::lib_defaults_desktopstyle();
############## Customize Style Here #####################
$Style{TCellWidth}{2} = 300;
$Style{TCellWidth}{3} = 50;
#########################################################
$String .= qq(
			<STYLE TYPE="text/css">
			<!--
			A.lnk:link { color: $Style{LinkFontColor}; position:relative; font-family:$Style{LinkFontFace}; font-size:$Style{LinkFontSize}pt; font-weight:$Style{LinkFontWeight}}
			A.lnk:visited { color: $Style{LinkFontColor}; position:relative; font-family:$Style{LinkFontFace}; font-size:$Style{LinkFontSize}pt; font-weight:$Style{LinkFontWeight}}
			A.txt{ color: $Style{TextFontColor}; position:relative; font-family:$Style{TextFontFace}; font-size:$Style{TextFontSize}pt; font-weight:$Style{TextFontWeight}}
			//-->
			</STYLE> 

);
$String .= qq(
<table valign="$Style{TValign}" border="$Style{TBorder}" cellpadding="$Style{TCellPadding}" cellspacing="$Style{TCellSpacing}" style="width:$Style{Width}; font-family:$Style{TextFontFace}; font-size:$Style{TextFontSize}pt; background:$Style{TBgColor}">
);	
# Title
$String .= "<tr><td style=\"width=$Style{TCellWidth}{1}\">";
$String .= "Configure Your Database Access:";
$String .= "</td><td style=\"width=$Style{TCellWidth}{1}\">To clear errors, simply select \"No database\" from the list...";
$String .= "</td><td style=\"width=$Style{TCellWidth}{1}\">";
$String .= "</td></tr>";
# Database Type
$String .= "<tr><td>";
$String .= "Select Database Type:";
$String .= "</td><td>";
my(@selected) = undef;
	if ($main::Form{DBType} eq "ACCESS")
	{
	$selected[0] = "SELECTED";
	} elsif ($main::Form{DBType} eq "MYSQL")
	{
	$selected[1] = "SELECTED";
	} elsif ($main::Form{DBType} eq "MSSQL")
	{
	$selected[2] = "SELECTED";
	};
$String .= qq(
<select name="DBType">
<option value="NONE">No Database
<option value="ACCESS" $selected[0]>Microsoft Access
<option value="MYSQL" $selected[1]>MySQL
<option value="MSSQL" $selected[2]>Microsoft SQL
</select>
);

$String .= "</td></tr>";
# Database Source Name
$String .= "<tr><td>";
$String .= "DSN: Data Source Name (if applicable)";
$String .= "</td><td>";
$String .= "<input class=txt type=\"text\" size=\"50\" value=\"$main::Form{DSN}\" name=\"DSN\" >";
$String .= "</td><td>";
$String .= "</td></tr>";

unless (($main::Form{DBType} eq "ACCESS") || ($main::Form{DBType} eq "NONE") )
{
# Database Server Name
$String .= "<tr><td>";
$String .= "Database Server name (optional):";
$String .= "</td><td>";
$String .= "<input class=txt type=\"text\" size=\"50\" value=\"$main::Form{DBServer}\" name=\"DBServer\" >";
$String .= "</td><td>";
$String .= "</td></tr>";
# Database Server Name
$String .= "<tr><td>";
$String .= "Database Server port (optional):";
$String .= "</td><td>";
$String .= "<input class=txt type=\"text\" size=\"50\" value=\"$main::Form{DBPort}\" name=\"DBPort\" >";
$String .= "</td><td>";
$String .= "</td></tr>";

$String .= "<tr><td>";
$String .= "Database Name:";
$String .= "</td><td>";
$String .= "<input class=txt type=\"text\" size=\"50\" value=\"$main::Form{DBName}\" name=\"DBName\" >";
$String .= "</td><td>";
$String .= "</td></tr>";
};

# Database User Name
$String .= "<tr><td>";
$String .= "User:";
$String .= "</td><td>";
$String .= "<input class=txt type=\"text\" size=\"50\" value=\"$main::Form{DBUser}\" name=\"DBUser\" >";
$String .= "</td><td>";
$String .= "</td></tr>";

# Database User Password
$String .= "<tr><td>";
$String .= "Password:";
$String .= "</td><td>";
$String .= "<input class=txt type=\"password\" size=\"50\" value=\"$main::Form{DBPass}\" name=\"DBPass\" >";
$String .= "</td><td>";
$String .= "</td></tr>";

	if ($main::Form{DBType} eq "ACCESS")
	{
	# Database User Password
	$String .= "<tr><td>";
	$String .= "Use DSN-Less Connection?";
	$String .= "</td><td>";

		if ($main::Form{DSNLess} == 1)
		{
		$String .= "<input type=\"checkbox\" name=\"DSNLess\" value=\"1\" checked>";
		} else {
			$String .= "<input type=\"checkbox\" name=\"DSNLess\" value=\"1\">";
			};

	$String .= "</td><td>";
	$String .= "</td></tr>";
	};


$String .= "</table>";	
return $String;
};


1;
