sub main::lib_sdbstructure_addnewstructfield
{
my($ConfigFile) = $_[0];
my($SubDebug) = $main::SubID{lib_sdbstructure_addnewstructfield}{debug};
my(%Data) = undef;
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Adding Field to \"$ConfigFile\"") : 0;
my($FieldName) = $_[1];
my($FieldType) = $_[2];
my($FieldTitle) = $_[3];
my($FieldNote) = $_[4];
my($FieldUnique) = $_[5];
my($FieldRequired) = $_[6];
my($FieldStatic) = $_[7];
my($FieldOwnerLock) = $_[8];


my($key) = undef;
my($AlreadyExists) = 0;
$FieldName = main::CleanSpaces($FieldName);
$FieldName = lc($FieldName);
$FieldType = main::CleanSpaces($FieldType);
$FieldType = lc($FieldType);
$FieldName = main::lib_html_Escape($FieldName);
$FieldType = main::lib_html_Escape($FieldType);
$FieldTitle = main::lib_html_Escape($FieldTitle);
$FieldNote = main::lib_html_Escape($FieldNote);
$FieldUnique = main::lib_html_Escape($FieldUnique);
$FieldRequired = main::lib_html_Escape($FieldRequired);
$FieldStatic = main::lib_html_Escape($FieldStatic);
$FieldOwnerLock = main::lib_html_Escape($FieldOwnerLock);


	if (-f $ConfigFile)
	{
	%Data = main::ReadIntConfig($ConfigFile);
		foreach $key (keys %Data)
		{
		if ($Data{$key}{name} =~ m!^$FieldName$!i) {$AlreadyExists = 1};
		};	

		unless ($AlreadyExists == 1)
		{
		my($NewKey) = "f". main::lib_time_gettime(11);
		$Data{$NewKey}{name} = $FieldName;
		$Data{$NewKey}{type} = $FieldType;
		$Data{$NewKey}{title} = $FieldTitle;
		$Data{$NewKey}{note} = $FieldNote;
		$Data{$NewKey}{unique} = $FieldUnique;
		$Data{$NewKey}{required} = $FieldRequired;
		$Data{$NewKey}{fstatic} = $FieldStatic;
		$Data{$NewKey}{ownerlock} = $FieldOwnerLock;
		
		main::WriteIntConfig("config",\%Data,$ConfigFile);
		main::DebugOut("OK - Updated with new field: $NewKey :  \"$Data{$NewKey}{name}\" \"$Data{$NewKey}{type}\" \"$Data{$NewKey}{title}\" \"$Data{$NewKey}{note}\"");
		return 1;
		} else {
			main::DebugOut("ERROR: Cannot add this filed \"$FieldName\" because it already exists!");
			return 0;
			};	
		
	} else {
		main::DebugOut("ERROR: Configuration file does not exist! \"$ConfigFile\"");
		return 0;
		};
	
};

####################################################################################################################
sub main::lib_sdbstructure_deletestructfield
{
my(%Data) = undef;
my($ConfigFile) = $_[0];
my($SubDebug) = $main::SubID{lib_sdbstructure_deletestructfield}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Adding Field to \"$ConfigFile\"") : 0;
my($ID) = $_[1];
my($key) = undef;
my($AlreadyExists) = 0;

	if (-f $ConfigFile)
	{
	%Data = main::ReadIntConfig($ConfigFile);
		foreach $key (keys %Data)
		{
		main::DebugOut("CHECKING: Defined \"$key\" -> $Data{$key}{name}");
			if (defined $Data{$key}{name})
			{
			main::DebugOut("CHECKING: \"$ID\" eq \"$key\"");	
				if ($key eq $ID)
				{
				undef $Data{$key};	
				main::DebugOut("OK: Deleted \"$ID\"");				
				};
			};
		};	
	main::WriteIntConfig("config",\%Data,$ConfigFile);
	} else {
		main::DebugOut("ERROR: Configuration file does not exist! \"$ConfigFile\"");
		return 0;
		};

};

####################################################################################################################

####################################################################################################################
sub main::lib_sdbstructure_structform
{
my($dbfile) = $_[0];
my($SubDebug) = $main::SubID{lib_sdbstructure_structform}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Processing: $dbfile") : 0;
my($StructureFile) = $_[1];
my($DbFolder) = $_[2];

my(%Data) = undef;
my($String) = undef;
my($key) = undef;
my($Updated) = undef;

my(%ViewOpt) = undef;

$String .= qq(
<style><!--
a:link,.w,a.w:link,.w a:link{color:$main::Config{sdb}{opt}{div}{tb_linkcolor}}
a:visited,.fl:visited{color:$main::Config{sdb}{opt}{div}{tb_vislinkcolor}}
.t a:link,.t a:active,.t a:visited,.t{color:$main::Config{sdb}{opt}{div}{tb_textcolor}}
div,td{color:$main::Config{sdb}{opt}{div}{tb_textcolor}}
.f,.fl:link{color:$main::Config{sdb}{opt}{div}{tb_textcolor}}
//-->
</style>
);
$String .= "QUICK HELP NOTES. Please read carefully before acting.<br>";
$String .= "NOTE #1: In order to be able to properly use option \"Lock to Owner\", create a field \"f_owner\" and assign this lock to this field.<br>";
$String .= "NOTE #2: Field names should have only lowercase english characters without any spaces and may contain underscores (e.g \"_\").<br>";
$String .= "NOTE #3: It is a good habit to assign one required unique field with the name \"f_id\". It is the default field name for linking options.<br>";
$String .= "\n<DIV style=\"background:$main::Config{sdb}{opt}{div}{tb_background}; color:$main::Config{sdb}{opt}{div}{tb_textcolor}\">";
$String .= "<center><table BORDER=\"$main::Config{sdb}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{sdb}{opt}{view}{tb_cpadding}\" CELLSPACING=\"$main::Config{sdb}{opt}{view}{tb_cspacing}\" style=\"width:$main::Config{sdb}{opt}{view}{tb_width}; font-family:$main::Config{sdb}{opt}{view}{tb_fontfamily}; font-size:$main::Config{sdb}{opt}{view}{tb_fontsize}pt; background:$main::Config{sdb}{opt}{view}{tb_background}; color:$main::Config{sdb}{opt}{view}{tb_color};\">";

$String .= "<tr style=\"font-family:verdana,arial; font-size:8pt; background:#cdf\">";
$String .= "<td style=\"width:100;\">";
$String .= "<b>Add New Field:</b>";
$String .= "</td>";

$String .= "<td style=\"width:150;\">";
$String .= "<b><hr></b>";
$String .= "</td>";

$String .= "<td style=\"width:200;\">";
$String .= "<b><hr></b>";
$String .= "</td>";

$String .= "<td style=\"width:300;\">";
$String .= "<b><hr></b>";
$String .= "</td>";

$String .= "<td style=\"width:70;\">";
$String .= "<b><hr></b>";
$String .= "</td>";

$String .= "<td style=\"width:70;\">";
$String .= "<b><hr></b>";
$String .= "</td>";

$String .= "<td style=\"width:70;\">";
$String .= "<b><hr></b>";
$String .= "</td>";
$String .= "<td style=\"width:70;\">";
$String .= "<b><hr></b>";
$String .= "</td>";
$String .= "<td style=\"width:50;\">";
$String .= "<b><hr></b>";
$String .= "</td>";


$String .= "</tr>";

$String .= "<tr style=\"font-family:verdana,arial; font-size:8pt; background:#cdf\">";

$String .= "<td style=\"width:100;\">";
$String .= "<b><input type=\"text\" name=\"nfname\" value=\"\"/></b>";
$String .= "</td>";

$String .= "<td style=\"width:150;\">";
# # # # # # # # START OF TABLE LINKING # # # # # # # #

my(%LOpt) = undef;
%LOpt = main::lb_sdbconfig_readconfig($main::Config{sdb}{dbstruct}{linkoptions},$main::Config{sdb}{dbmain}{linkoptions},"f_id");
my($LKey) = undef;
#	$String = $String . "<br>Result: \$Result{test}{f_id} = $Result{test}{f_id}";
my($LOptCount) = undef;

if (defined %LOpt)
{
$String .= "\n<select name=\"nftype\">";

	foreach $LKey (sort keys %LOpt)
	{
	($SubDebug == 1) ? DebugOut("Checking key: \$LKey = $LKey") : 0;
		if ((defined $LKey) && (defined $LOpt{$LKey}{f_text}))
		{
			
				if ($LKey eq "text")
				{
				$String .= "\n<option value=\"$LKey\" selected>$LOpt{$LKey}{f_text}";					
				} else {
					$String .= "\n<option value=\"$LKey\" >$LOpt{$LKey}{f_text}";	
					};
			$LOptCount++;
		($SubDebug == 1) ? DebugOut("\$LOptCount = $LOptCount") : 0;			
		};
	};	
	if ($LOptCount < 1)
	{
	$String .= "\n<option value=\"text\">text";
	$String .=  qq(
		<option value="number">number
		<option value="memo">memo
		<option value="bin">binary
		<option value="image">image
		<option value="timestamp">Auto Timestamp
		<option value="id">Auto Unique ID
		<option value="yn">Yes/No
		<option value="userautoinsert">Auto User Name
		);	
	};
$String .= "\n</select>";
} else {
		$String .=  qq(
		<select name="nftype">
		<option value="text">text
		<option value="number">number
		<option value="memo">memo
		<option value="bin">binary
		<option value="image">image
		<option value="dtyear">year
		<option value="dtmonth">month
		<option value="dtdate">date
		<option value="dtwday">weekday
		<option value="dthour">hour
		<option value="dtminute">minute
		<option value="dtsecond">second
		<option value="linksrv">Server id
		<option value="linkapp">Application id
		<option value="linkjob">Job Log id
		<option value="linkjobsource">Job Source id
		<option value="linkcont">Contact id
		<option value="linkcontype">Contact type id
		<option value="linkdoc">Document id
		<option value="linkloc">Location
		<option value="linktype1">Scheduled Task Type ID
		<option value="linktype2">Document Type
		<option value="email">e-mail address
		<option value="phone">phone/fax number
		<option value="webaddress">web address
		<option value="timestamp">timestamp
		<option value="id">Unique Auto id
		<option value="yn">Yes/No
		<option value="userautoinsert">Autouser Name
		</select>
		);
	};

	
# # # # # # # # END OF TABLE LINKING # # # # # # # #

# $String .= "<b><input type=\"text\" name=\"nftype\" value=\"\"></b>";
$String .= "</td>";

$String .= "<td style=\"width:200;\">";
$String .= "<b><input type=\"text\" name=\"nftitle\" value=\"\"/></b>";
$String .= "</td>";

$String .= "<td style=\"width:300;\">";
$String .= "<b><textarea name=\"nfnote\" cols=\"30\"></textarea></b>";
$String .= "</td>";

$String .= "<td style=\"width:70;\">";
$String .= "<b>Unique? <input type=\"CHECKBOX\" name=\"nunique\" value=\"1\"/></b>";
$String .= "</td>";

$String .= "<td style=\"width:70;\">";
$String .= "<b>Required? <input type=\"CHECKBOX\" name=\"nrequired\" value=\"1\"/></b>";
$String .= "</td>";

$String .= "<td style=\"width:70;\">";
$String .= "<b>Static? <input type=\"CHECKBOX\" name=\"nstatic\" value=\"1\"/></b>";
$String .= "</td>";

$String .= "<td style=\"width:70;\">";
$String .= "<b>Lock to Owner? <input type=\"CHECKBOX\" name=\"nownerlock\" value=\"1\"/></b>";
$String .= "</td>";


$String .= "<td style=\"width:70;\">";
$String .= "<br><b><input type=\"submit\" name=\"Add\" value=\"Add\"/></b>";
$String .= "</td>";

$String .= "</tr>";


$String .= "<tr>";

$String .= "<td style=\"width:100;\">";
$String .= "<b>Field Name</b>";
$String .= "</td>";

$String .= "<td style=\"width:150;\">";
$String .= "<b>Field Type</b>";
$String .= "</td>";

$String .= "<td style=\"width:200;\">";
$String .= "<b>Field Title</b>";
$String .= "</td>";

$String .= "<td style=\"width:300;\">";
$String .= "<b>Field Note</b>";
$String .= "</td>";

$String .= "<td style=\"width:30;\">";
$String .= "<b>Unique</b>";
$String .= "</td>";

$String .= "<td style=\"width:30;\">";
$String .= "<b>Required</b>";
$String .= "</td>";

$String .= "<td style=\"width:30;\">";
$String .= "<b>Static</b>";
$String .= "</td>";

$String .= "<td style=\"width:30;\">";
$String .= "<b>Owner Lock</b>";
$String .= "</td>";

$String .= "<td style=\"width:50;\">";
$String .= "<b>Delete</b>";
$String .= "</td>";

$String .= "</tr>";

	if (-f $dbfile)
	{
	%Data = main::ReadIntConfig($dbfile);
		foreach $key (sort keys %Data)
		{
			if (defined $Data{$key}{name})
			{
				$String .= "<tr>";
				
				$String .= "<td>";
				$String .= "$Data{$key}{name}";
				$String .= "</td>";

				$String .= "<td>";
				$String .= "$Data{$key}{type}";
				$String .= "</td>";

				$String .= "<td>";
				$String .= "$Data{$key}{title}";
				$String .= "</td>";

				$String .= "<td>";
				$String .= "$Data{$key}{note}";
				$String .= "</td>";

				$String .= "<td>";
				$String .= "$Data{$key}{unique}";
				$String .= "</td>";

				$String .= "<td>";
				$String .= "$Data{$key}{required}";
				$String .= "</td>";

				$String .= "<td>";
				$String .= "$Data{$key}{fstatic}";
				$String .= "</td>";

				$String .= "<td>";
				$String .= "$Data{$key}{ownerlock}";
				$String .= "</td>";


				$String .= "<td>";
				$String .= "<a href=\"$main::UserEnv{href}&c=$main::Form{c}&fid=$key&act=delete&fname=$Data{$key}{name}\">delete</a>";
				$String .= "</td>";

				$String .= "</tr>";
			};
		};

	} else {
		main::DebugOut("ERROR: No Database file: \"$dbfile\"");
		};


$String .= "</table><center>";	
$String .= "<hr>";	
$String .= "<b>You have to be logged as administrator to make a proper use of the following options.</b>";
$String .= "<table BORDER=\"$main::Config{sdb}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{sdb}{opt}{view}{tb_cpadding}\" CELLSPACING=\"$main::Config{sdb}{opt}{view}{tb_cspacing}\" style=\"width:$main::Config{sdb}{opt}{view}{tb_width}; font-family:$main::Config{sdb}{opt}{view}{tb_fontfamily}; font-size:$main::Config{sdb}{opt}{view}{tb_fontsize}pt; background:$main::Config{sdb}{opt}{view}{tb_background}; color:$main::Config{sdb}{opt}{view}{tb_color};\">";

$String .= "<tr><td style=\"width:400\">";	
$String .= "Enable e-mail notification<br>option when record updated or added<br> e-mail to the following e-mail addresses:<br>(Separate by semicolons \";\"):";	
$String .= "</td><td>";
$String .= "<input type=\"text\" name=\"emailupdate\" size=\"120\" value=\"$main::Config{sdb}{EmailFlagList}\"/>";
$String .= "</td><td style=\"width:250\">";
$String .= "Disable:<input type=\"CHECKBOX\" value=\"1\" name=\"deleteemailupdate\" /><br>(please clean <br>the e-mail list field)<br>";
$String .= "</td></tr>";
	
if (-e $main::Config{sdb}{PrivateFlag})
{
$PrivateEnabled = "CHECKED";	
};
$String .= "<tr><td style=\"width:400\">";	
$String .= "Check to make this table a private table.<br>(Data for each user will be seaparated):";	
$String .= "</td><td>";
$String .= "<input type=\"CHECKBOX\" value=\"private\" name=\"private\" $PrivateEnabled />";
$String .= "</td><td>";
$String .= "Disable:<input type=\"CHECKBOX\" value=\"1\" name=\"deleteprivate\"/><br> (please uncheck<br>the other checkbox)<br>";
$String .= "</td></tr>";


$String .= "</table><center>";	
$String .= "</DIV>";
return $String;
};

1;
