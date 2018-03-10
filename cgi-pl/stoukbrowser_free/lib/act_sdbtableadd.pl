# Action library for sdbtableadd


sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute before Template generation


my(%Table) = undef;
my($Exists) = undef;
my($key) = undef;
my($tempfldedit) = undef;
my($tempedit) = undef;
my($tempview) = undef;

($SubDebug == 1) ? DebugOut("Checking if \$main::Form{addnewtable} = $main::Form{addnewtable}") : 0;


	if (($main::Form{action} eq "delete") && (length($main::Form{key}) > 0)) 
	{
		if ($main::Form{Yes} eq "Yes")
		{
			if (-e $main::Config{sdb}{rootconfig})
			{
			%Table = main::ReadIntConfig($main::Config{sdb}{rootconfig});	
			main::LoadLibrary("lib_newaction.pl");
	
					if (defined $Table{$main::Form{key}}{name})
					{
					($SubDebug == 1) ? DebugOut("Deleting Table: $Table{$main::Form{key}}{name}") : 0;	
						if (-e $main::Config{sdb}{dbroot}{$Table{$main::Form{key}}{name}} )
						{
						rmtree($main::Config{sdb}{dbroot}{$Table{$main::Form{key}}{name}});	
						$tempfldedit = "sdb" . $Table{$main::Form{key}}{name} . "fldedit";
						$tempedit = "sdb" . $Table{$main::Form{key}}{name} . "edit";
						$tempview = "sdb" . $Table{$main::Form{key}}{name} . "view";
						main::LoadLibrary("lib_newaction.pl");
						main::lib_newaction_delete($tempfldedit);
						main::lib_newaction_delete($tempedit);
						main::lib_newaction_delete($tempview);

					if (defined $ActConfig{$tempfldedit}){main::lib_newaction_delete($tempfldedit)};
					if (defined $ActConfig{$tempedit}){main::lib_newaction_delete($tempedit)};
					if (defined $ActConfig{$tempview}){main::lib_newaction_delete($tempview)};
						undef $Table{$main::Form{key}};
						main::WriteIntConfig("config",\%Table,$main::Config{sdb}{rootconfig});	
						};
					
					
					};
			};
		} else {
			
				if ($main::Form{No} eq "No")
				{
				$main::Form{action} = "";
				$main::Form{key} = "";
				} else {
					 $main::Config{$main::Form{c}}{ok} .= "<b>WARNING! You have to be absolutly sure of what you are doing right now.<br>Any deletion of a registry table could bring devastating unexpacted results to the functionality of this whole application.<br>Are you sure you want to delete this table?</b><input type=\"Submit\" name=\"Yes\" value=\"Yes\" /><input type=\"Submit\" name=\"No\" value=\"No\" />";
					 $main::Config{$main::Form{c}}{ok} .= "<b><input type=\"hidden\" name=\"key\" value=\"$main::Form{key}\" /><input type=\"hidden\" name=\"action\" value=\"$main::Form{action}\" />";
					};
			};
				
	};
	if (length ($main::Form{addnewtable}) > 1)
	{
	($SubDebug == 1) ? DebugOut("Checking if exists: $main::Config{sdb}{rootconfig}") : 0;
		if (-e $main::Config{sdb}{rootconfig})
		{
		%Table = main::ReadIntConfig($main::Config{sdb}{rootconfig});	
		($SubDebug == 1) ? DebugOut("Reading \$main::Config{sdb}{rootconfig} = $main::Config{sdb}{rootconfig}") : 0;	
			foreach $key (sort keys %Table)
			{
			($SubDebug == 1) ? DebugOut("Checking if defined: \$Table{$key}{name} = $Table{$key}{name} and $Table{$key}{name} eq $main::Form{addnewtable}") : 0;	
				if ((defined $Table{$key}{name}) && ($Table{$key}{name} eq $main::Form{addnewtable}) )
				{
					$Exists = 1;
					($SubDebug == 1) ? DebugOut("FAILED: This table already exists!") : 0;	
				};
			};

			unless ($Exists == 1)
			{
			$Exists = undef;
			($SubDebug == 1) ? DebugOut("Continue - This table name does not exist = OK") : 0;	
			
			$tempfldedit = "sdb" . $main::Form{addnewtable} . "fldedit";
			($SubDebug == 1) ? DebugOut("Checking if defined: \$tempfldedit = $tempfldedit") : 0;	
				if (defined $ActConfig{$temp})
				{
				$Exists = 1;
				main::AddError("action-e00002","\"$tempfldedit\"");
				($SubDebug == 1) ? DebugOut("FAILED - could not Create New Action!") : 0;
				$main::Config{$main::Form{c}}{error} .= "FAILED - could not Create New Action: $ActConfig{$tempview} - Already defined!";
				};
			$tempedit = "sdb" . $main::Form{addnewtable} . "edit";
			($SubDebug == 1) ? DebugOut("Checking if defined: \$tempedit = $tempedit") : 0;	
				if (defined $ActConfig{$tempedit})
				{
				$Exists = 1;
				main::AddError("action-e00002","\"$tempedit\"");
				($SubDebug == 1) ? DebugOut("FAILED - could not Create New Action!") : 0;
				$main::Config{$main::Form{c}}{error} .= "FAILED - could not Create New Action: $ActConfig{$tempview} - Already defined!";
				};
			
			$tempview = "sdb" . $main::Form{addnewtable} . "view";
			($SubDebug == 1) ? DebugOut("Checking if defined: \$tempview = $tempview") : 0;	
			
				if (defined $ActConfig{$tempview})
				{
				$Exists = 1;
				main::AddError("action-e00002","\"$tempview\"");
				($SubDebug == 1) ? DebugOut("FAILED - could not Create New Action!") : 0;
				$main::Config{$main::Form{c}}{error} .= "FAILED - could not Create New Action: $ActConfig{$tempview} - Already defined!";
				};
			($SubDebug == 1) ? DebugOut("CHECKING: \$Exists = $Exists") : 0;	
				unless ($Exists == 1)
				{
				($SubDebug == 1) ? DebugOut("Creating New Table: \$main::Form{addnewtable} = $main::Form{addnewtable}") : 0;	
				main::LoadLibrary("lib_newaction.pl");
				main::lib_newaction_createkeys($tempfldedit,"1","$main::Form{addnewtable}");
				main::lib_newaction_createkeys($tempedit,"2","$main::Form{addnewtable}");
				main::lib_newaction_createkeys($tempview,"3","$main::Form{addnewtable}");
			
				$Table{("t".time)}{name} = $main::Form{addnewtable};
				main::WriteIntConfig("config",\%Table,$main::Config{sdb}{rootconfig});	
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

my($String) =   $main::Config{$main::Form{c}}{error} . $main::Config{$main::Form{c}}{ok} . main::act_sdbtableadd_form();
$main::Html{ServiceText} =~ s!<insert-sdbtableadd-content>!$String!gis;
};

sub main::act_sdbtableadd_form
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($key) = undef;
my($String) = main::lib_config_defaultstyle();
my(%Table) = undef;

	if (-e $main::Config{sdb}{rootconfig})
	{
	%Table = main::ReadIntConfig($main::Config{sdb}{rootconfig});		
	} else {
		
		};
 
$String .= qq(
<DIV style=\"background:$main::Config{divopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor}\">
<b>System Tables</b>
<br>
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

	foreach $key (sort {$Table{$a}{name} cmp $Table{$b}{name}} keys %Table)
	{
		if ($key)
		{
		
		# ($SubDebug == 1) ? DebugOut("checking if $ActConfig{$key}{acl}{group} contains $main::Form{checkgroup}") : 0;
			if (defined $Table{$key}{name})
			{
			$String .= "<tr><td><b>".ucfirst($Table{$key}{name})."</b> </td><td style=\"width:50\"><a href=\"$main::UserEnv{href}&c=$main::Form{c}&action=delete&key=$key\"> delete </a>";
			} else {
				
				};
		$String .= "</td></tr>";
		};
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
