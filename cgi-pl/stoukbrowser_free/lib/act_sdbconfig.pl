# Action library for sdbconfig


	sub main::pre_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute before Template generation:
####################################################################################################################
my($StrFile) =  $main::Config{sdb}{dbstruct}{$main::Form{structure}};
my($DatabaseFile) =  $main::Config{sdb}{dbmain}{$main::Form{structure}};
my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{$main::Form{structure}};
my($IndexLetter) = "t";
my($TableName) = "$main::Form{structure}";
####################################################################################################################
my($key) = undef;
my($fldname) = undef;
my($fldtype) = undef;
my($temp) = undef;
		
		if ($main::Form{submit} =~ m!Update!)
		{

		($SubDebug == 1) ? DebugOut("Submitted - OK") : 0;
			foreach $key (keys %main::Form)
			{
			$temp = $key;
			($SubDebug == 1) ? DebugOut("\$key = $key ; \$temp = $temp") : 0;
				
				if ($key =~ m!widthFLD(.*)!)
				{
				$fldname = $1;
				$main::Config{sdb}{opt}{$main::Form{structure}}{$fldname}{width} = $main::Form{$key};	
				($SubDebug == 1) ? DebugOut("Updating \$main::Config{sdb}{opt}{$main::Form{structure}}{$fldname}{width} = $main::Config{sdb}{opt}{$main::Form{structure}}{$fldname}{width}") : 0;	
				};
			
				if ($key =~ m!visFLD(.*)!)
				{
				$fldname = $1;
				if ($main::Form{$key} == 2)
				{
				$main::Form{$key} = 0;	
				} else {
					$main::Form{$key} = 1;
					};
				$main::Config{sdb}{opt}{$main::Form{structure}}{$fldname}{hide} = $main::Form{$key};	
				($SubDebug == 1) ? DebugOut("Updating \$main::Config{sdb}{opt}{$main::Form{structure}}{$fldname}{hide} = $main::Config{sdb}{opt}{$main::Form{structure}}{$fldname}{hide}") : 0;	
				};

				if ($key =~ m!orderFLD(.*)!)
				{
				$fldname = $1;
				$main::Config{sdb}{opt}{$main::Form{structure}}{$fldname}{order} = $main::Form{$key};	
				($SubDebug == 1) ? DebugOut("Updating \$main::Config{sdb}{opt}{$main::Form{structure}}{$fldname}{order} = $main::Config{sdb}{opt}{$main::Form{structure}}{$fldname}{order}") : 0;	
				};

				

				
				if (($temp =~ m!(view):(.*)!) || ($temp =~ m!(search):(.*)!) || ($temp =~ m!(navbar):(.*)!) || ($temp =~ m!(div):(.*)!) )
				{
				$fldtype = $1;
				$fldname = $2;
($SubDebug == 1) ? DebugOut("\$fldtype = $fldtype ; \$fldname = $fldname") : 0;				
					if (($fldname =~ m!size!) || ($fldname =~ m!cpadding!) || ($fldname =~ m!cspacing!) || ($fldname =~ m!border!) || ($fldname =~ m!width!))
					{

					$main::Config{sdb}{opt}{$fldtype}{$fldname} = $main::Form{$key};
						
					} elsif ($fldname =~ m!family!)
					{
						if (length($main::Form{$key}) > 128)
						{
							
						} else {
							$main::Config{sdb}{opt}{$fldtype}{$fldname} = $main::Form{$key};
							};
					} elsif (($fldname =~ m!background!) || ($fldname =~ m!color!) )
					{
($SubDebug == 1) ? DebugOut("\$fldname = $fldname") : 0;
						if (($main::Form{$key} =~ m!(\#\w\w\w\w\w\w)!) || ($main::Form{$key} =~ m!(\#\w\w\w)!) )
						{
						$main::Config{sdb}{opt}{$fldtype}{$fldname} = $1;	
						($SubDebug == 1) ? DebugOut("Saving Color: \$main::Config{sdb}{opt}{$fldtype}{$fldname} = $main::Config{sdb}{opt}{$fldtype}{$fldname}") : 0;
						} else {
							
							};
					} elsif ($fldname =~ m!ext!)
					{
						
					$main::Config{sdb}{opt}{$fldtype}{$fldname} = $main::Form{$key};
					unless ($main::Config{sdb}{opt}{$fldtype}{$fldname} =~ m!^\.!) {$main::Config{sdb}{opt}{$fldtype}{$fldname} = ".". $main::Config{sdb}{opt}{$fldtype}{$fldname}};	
					};
				};

			};
		
		main::WriteIntConfig("config",$main::Config{sdb}{opt},$main::Config{sdbconfig}{uopt}{file});
		($SubDebug == 1) ? DebugOut("Information was writtent to: $main::Config{sdb}{uopt}{file}") : 0;
			if ($main::UserEnv{name} =~ m!^administrator!i) 
			{
			main::WriteIntConfig("config",$main::Config{sdb}{opt},$main::Config{sdbconfig}{opt}{file});
			($SubDebug == 1) ? DebugOut("Information was writtent to: $main::Config{sdb}{opt}{file}") : 0;
			};
		} else {
			
			};


		   		   
	};
		    
	sub main::post_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute after Template generation:

	################################################################################

####################################################################################################################
main::lib_sdbconfig_configenvironment();
my($StrFile) =  $main::Config{sdb}{dbstruct}{$main::Form{structure}};
my($DatabaseFile) =  $main::Config{sdb}{dbmain}{$main::Form{structure}};
my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{$main::Form{structure}};
my($IndexLetter) = "t";
my($TableName) = "$main::Form{structure}";
####################################################################################################################

my($String) = main::act_sdbconfig_form($StrFile,$DatabaseFile,$DatabaseFolder,$IndexLetter,$TableName,$TableName);
	

$main::Config{$main::Form{c}}{ok} .= "";
$main::Config{$main::Form{c}}{error} .= "";
$String = $main::Config{$main::Form{c}}{error} . $main::Config{$main::Form{c}{ok}} . $String;
$main::Html{ServiceText} =~ s!<insert-sdbconfig-content>!$String!gis;
};

sub main::act_sdbconfig_form
{
my($StructureFile) = $_[0];
my($DatabaseFile) = $_[1];
my($RecordsFolder) = $_[2];
my($TableName) = $_[3];
my($AdministratorMode) = undef;
my($AdminCommand) = $_[4];
my($StructureID) = $_[5];
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("") : 0;
($SubDebug == 1) ? DebugOut("WMS Config Parameters: \$StructureFile = $StructureFile; \$DatabaseFile = $DatabaseFile; \$RecordsFolder = $RecordsFolder; \$TableName = $TableName") : 0;
my($String) = undef;
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
$String .= "\n<DIV style=\"background:$main::Config{sdb}{opt}{div}{tb_background}\"> [ <a href=\"$main::UserEnv{href}&c=$main::Form{parentcommand}\" style=\"color:#000;background:#FFF\">Back</a> ] ";
$String .= "<br>Example of Search Bar...";
$String .= main::act_sdb_config_searchform();
$String .= main::act_sdb_config_navbarform();
$String .= "<center><table BORDER=\"$main::Config{sdb}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{sdb}{opt}{view}{tb_cpadding}\" CELLSPACING=\"$main::Config{sdb}{opt}{view}{tb_cspacing}\" style=\"width:$main::Config{sdb}{opt}{view}{tb_width}; font-family:$main::Config{sdb}{opt}{view}{tb_fontfamily}; font-size:$main::Config{sdb}{opt}{view}{tb_fontsize}pt; background:$main::Config{sdb}{opt}{view}{tb_background};\">";

my($key) = undef;
my(@StructureName) = undef;
my(@StructureTitle) = undef;
my(@StructureType) = undef;
my(@StructureNote) = undef;
my($sc) = undef;


	if (-f $StructureFile)
	{
	%Structure = main::ReadIntConfig($StructureFile);
	
	$String .= "\n<tr>";

		foreach $key (sort keys %Structure)
		{
			if (defined $Structure{$key}{type})
			{
				if ($main::Config{sdb}{opt}{$StructureID}{$Structure{$key}{name}}{hide} == 1)
				{
				($SubDebug == 1) ? DebugOut("Defined Field Name: $Structure{$key}{name}") : 0;			
				$StructureName[$sc] = $Structure{$key}{name};
				$StructureType[$sc] = $Structure{$key}{type};
				$StructureTitle[$sc] = $Structure{$key}{title};
				$StructureNote[$sc] = $Structure{$key}{note};
				$String .= "\n<td style=\"width:$main::Config{sdb}{opt}{$StructureID}{$Structure{$key}{name}}{width}; background:#999\">";
				$String .= "<b>$StructureTitle[$sc]</b>";			
				$String .= "\n</td>";
				($SubDebug == 1) ? DebugOut("Added: $Structure{$key}{title} \$main::Config{sdb}{opt}{$StructureID}{$Structure{$key}{name}}{width} = $main::Config{sdb}{opt}{$StructureID}{$Structure{$key}{name}}{width}") : 0;
				$sc++;
				} else {
					($SubDebug == 1) ? DebugOut("Defined Field Name: $Structure{$key}{name}") : 0;			
					$StructureName[$sc] = $Structure{$key}{name};
					$StructureType[$sc] = $Structure{$key}{type};
					$StructureTitle[$sc] = $Structure{$key}{title};
					$StructureNote[$sc] = $Structure{$key}{note};
					$String .= "\n<td style=\"width:$main::Config{sdb}{opt}{$StructureID}{$Structure{$key}{name}}{width}\">";
					$String .= "<b>$StructureTitle[$sc]</b>";			
					$String .= "\n</td>";
					($SubDebug == 1) ? DebugOut("Added: $Structure{$key}{title} \$main::Config{sdb}{opt}{$StructureID}{$Structure{$key}{name}}{width} = $main::Config{sdb}{opt}{$StructureID}{$Structure{$key}{name}}{width}") : 0;
					$sc++;
					};
			};
		};
	$String .= "\n</tr>";
	my($totalfields) = scalar @StructureName;	
	my($i) = undef;
	my($checked) = undef;
	$String .= "\n<tr>";
		for ($i = 0; $i < $sc; $i++)
		{
		$String .= "\n<td valign=\"bottom\">";
		$checked = undef;
		if ($main::Config{sdb}{opt}{$StructureID}{$StructureName[$i]}{hide} > 0) 
		{
		$checked = "CHECKED";
		$String .= "\n<br>Hide: <br><input type=\"RADIO\" name=\"visFLD".$StructureName[$i]."\" value=\"1\" CHECKED><br>Show: <br><input type=\"RADIO\" name=\"visFLD".$StructureName[$i]."\" value=\"2\">";
		} else {
			$String .= "\n<br>Hide: <br><input type=\"RADIO\" name=\"visFLD".$StructureName[$i]."\" value=\"1\" ><br>Show: <br><input type=\"RADIO\" name=\"visFLD".$StructureName[$i]."\" value=\"2\" CHECKED>";
			};
		
		
		
		$String .= "\n<br>Width: <br><input type=\"text\" size=\"3\" name=\"widthFLD".$StructureName[$i]."\" value=\"$main::Config{sdb}{opt}{$StructureID}{$StructureName[$i]}{width}\">";
		# $String .= "\n<br>Order: <input type=\"text\" size=\"1\" name=\"orderFLD".$StructureName[$i]."\" value=\"$main::Config{sdb}{opt}{$StructureID}{$StructureName[$i]}{order}\">";
		$String .= "\n</td>";
		};
	$String .= "\n</tr>";	
	} else {
		
		};

$String .= "\n</table></center>";
$String .= "\n<center><input type=\"hidden\" name=\"structure\" value=\"$main::Form{structure}\">";
$String .= "\n<input type=\"submit\" name=\"submit\" value=\"Update\"></center>";
$String .= "\n<center><table BORDER=\"$main::Config{sdb}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{sdb}{opt}{view}{tb_cpadding}\" CELLSPACING=\"$main::Config{sdb}{opt}{view}{tb_cspacing}\" style=\"width:$main::Config{sdb}{opt}{view}{tb_width}; font-family:$main::Config{sdb}{opt}{view}{tb_fontfamily}; font-size:$main::Config{sdb}{opt}{view}{tb_fontsize}pt; background:$main::Config{sdb}{opt}{view}{tb_background};\">";

my(@Form) = undef;
my($ln) = undef;
$Form[$ln++] = "<tr><td></td><td></td></tr>";

$Form[$ln++] = "<tr><td></td><td></td></tr>";
$Form[$ln++] = "<tr><td><b>General Options: </b></td><td></td></tr>";
$Form[$ln++] = "<tr><td>Division Background : </td><td><input type=\"text\" size=\"10\" name=\"div:tb_background\" value=\"$main::Config{sdb}{opt}{div}{tb_background}\"></td></tr>";
$Form[$ln++] = "<tr><td>Link Color : </td><td><input type=\"text\" size=\"10\" name=\"div:tb_linkcolor\" value=\"$main::Config{sdb}{opt}{div}{tb_linkcolor}\"></td></tr>";
$Form[$ln++] = "<tr><td>Visited Link Color : </td><td><input type=\"text\" size=\"10\" name=\"div:tb_vislinkcolor\" value=\"$main::Config{sdb}{opt}{div}{tb_vislinkcolor}\"></td></tr>";
$Form[$ln++] = "<tr><td>Text Color : </td><td><input type=\"text\" size=\"10\" name=\"div:tb_textcolor\" value=\"$main::Config{sdb}{opt}{div}{tb_textcolor}\"></td></tr>";


$Form[$ln++] = "<tr><td><b>View Table Options: </b></td><td></td></tr>";
$Form[$ln++] = "<tr><td>Table Width: </td><td><input type=\"text\" size=\"3\" name=\"view:tb_width\" value=\"$main::Config{sdb}{opt}{view}{tb_width}\"></td></tr>";
$Form[$ln++] = "<tr><td>Border Width: </td><td><input type=\"text\" size=\"3\" name=\"view:tb_border\" value=\"$main::Config{sdb}{opt}{view}{tb_border}\"></td></tr>";
$Form[$ln++] = "<tr><td>Border Cellpadding: </td><td><input type=\"text\" size=\"3\" name=\"view:tb_cpadding\" value=\"$main::Config{sdb}{opt}{view}{tb_cpadding}\"></td></tr>";
$Form[$ln++] = "<tr><td>Border Cellspacing: </td><td><input type=\"text\" size=\"3\" name=\"view:tb_cspacing\" value=\"$main::Config{sdb}{opt}{view}{tb_cspacing}\"></td></tr>";
$Form[$ln++] = "<tr><td><b>Table Style: </b></td><td></td></tr>";
$Form[$ln++] = "<tr><td>Font-Family : </td><td><input type=\"text\" size=\"30\" name=\"view:tb_fontfamily\" value=\"$main::Config{sdb}{opt}{view}{tb_fontfamily}\"></td></tr>";
$Form[$ln++] = "<tr><td>Font-Size : </td><td><input type=\"text\" size=\"3\" name=\"view:tb_fontsize\" value=\"$main::Config{sdb}{opt}{view}{tb_fontsize}\"></td></tr>";
$Form[$ln++] = "<tr><td>Font-Color : </td><td><input type=\"text\" size=\"3\" name=\"view:tb_fontcolor\" value=\"$main::Config{sdb}{opt}{view}{tb_fontcolor}\"></td></tr>";
$Form[$ln++] = "<tr><td>Background : </td><td><input type=\"text\" size=\"10\" name=\"view:tb_background\" value=\"$main::Config{sdb}{opt}{view}{tb_background}\"></td></tr>";

$Form[$ln++] = "<tr><td><b>Search Table Options: </b></td><td></td></tr>";
$Form[$ln++] = "<tr><td>Table Width: </td><td><input type=\"text\" size=\"3\" name=\"search:tb_width\" value=\"$main::Config{sdb}{opt}{search}{tb_width}\"></td></tr>";
$Form[$ln++] = "<tr><td>Border Width: </td><td><input type=\"text\" size=\"3\" name=\"search:tb_border\" value=\"$main::Config{sdb}{opt}{search}{tb_border}\"></td></tr>";
$Form[$ln++] = "<tr><td>Border Cellpadding: </td><td><input type=\"text\" size=\"3\" name=\"search:tb_cpadding\" value=\"$main::Config{sdb}{opt}{search}{tb_cpadding}\"></td></tr>";
$Form[$ln++] = "<tr><td>Border Cellspacing: </td><td><input type=\"text\" size=\"3\" name=\"search:tb_cspacing\" value=\"$main::Config{sdb}{opt}{search}{tb_cspacing}\"></td></tr>";
$Form[$ln++] = "<tr><td><b>Search Table Style: </b></td><td></td></tr>";
$Form[$ln++] = "<tr><td>Font-Family : </td><td><input type=\"text\" size=\"30\" name=\"search:tb_fontfamily\" value=\"$main::Config{sdb}{opt}{search}{tb_fontfamily}\"></td></tr>";
$Form[$ln++] = "<tr><td>Font-Size : </td><td><input type=\"text\" size=\"3\" name=\"search:tb_fontsize\" value=\"$main::Config{sdb}{opt}{search}{tb_fontsize}\"></td></tr>";
$Form[$ln++] = "<tr><td>Background : </td><td><input type=\"text\" size=\"10\" name=\"search:tb_background\" value=\"$main::Config{sdb}{opt}{search}{tb_background}\"></td></tr>";

$Form[$ln++] = "<tr><td><b>Navigation Bar Table Options: </b></td><td></td></tr>";
$Form[$ln++] = "<tr><td>Table Width: </td><td><input type=\"text\" size=\"3\" name=\"navbar:tb_width\" value=\"$main::Config{sdb}{opt}{navbar}{tb_width}\"></td></tr>";
$Form[$ln++] = "<tr><td>Border Width: </td><td><input type=\"text\" size=\"3\" name=\"navbar:tb_border\" value=\"$main::Config{sdb}{opt}{navbar}{tb_border}\"></td></tr>";
$Form[$ln++] = "<tr><td>Border Cellpadding: </td><td><input type=\"text\" size=\"3\" name=\"navbar:tb_cpadding\" value=\"$main::Config{sdb}{opt}{navbar}{tb_cpadding}\"></td></tr>";
$Form[$ln++] = "<tr><td>Border Cellspacing: </td><td><input type=\"text\" size=\"3\" name=\"navbar:tb_cspacing\" value=\"$main::Config{sdb}{opt}{navbar}{tb_cspacing}\"></td></tr>";
$Form[$ln++] = "<tr><td><b>Navigation Bar Table Style: </b></td><td></td></tr>";
$Form[$ln++] = "<tr><td>Font-Family : </td><td><input type=\"text\" size=\"30\" name=\"navbar:tb_fontfamily\" value=\"$main::Config{sdb}{opt}{navbar}{tb_fontfamily}\"></td></tr>";
$Form[$ln++] = "<tr><td>Font-Size : </td><td><input type=\"text\" size=\"3\" name=\"navbar:tb_fontsize\" value=\"$main::Config{sdb}{opt}{navbar}{tb_fontsize}\"></td></tr>";
$Form[$ln++] = "<tr><td>Background : </td><td><input type=\"text\" size=\"10\" name=\"navbar:tb_background\" value=\"$main::Config{sdb}{opt}{navbar}{tb_background}\"></td></tr>";

$Form[$ln++] = "<tr><td><b>Special Options: </b></td><td></td></tr>";
$Form[$ln++] = "<tr><td>Add Download Extention : </td><td><input type=\"text\" size=\"10\" name=\"div:dl_ext\" value=\"$main::Config{sdb}{opt}{div}{dl_ext}\"></td></tr>";



$String .= "@Form <input type=\"hidden\" name=\"parentcommand\" value=\"$main::Form{parentcommand}\">";
$String .= "\n</table></center><input type=\"submit\" name=\"submit\" value=\"Update\"></DIV>";

return $String;
};

sub main::act_sdb_config_searchform
{

my(%SearchForm) = undef;

	$SearchForm{String} = "\n<table border=\"$main::Config{sdb}{opt}{search}{tb_border}\" cellpadding=\"$main::Config{sdb}{opt}{search}{tb_cpadding}\" cellspacing=\"$main::Config{sdb}{opt}{search}{tb_cspacing}\" style=\"width:$main::Config{sdb}{opt}{search}{tb_width}; font-family:$main::Config{sdb}{opt}{search}{tb_fontfamily}; font-size:$main::Config{sdb}{opt}{search}{tb_fontsize}pt; background:$main::Config{sdb}{opt}{search}{tb_background};\">";
	$SearchForm{String} .= "\n<tr>";
	$SearchForm{String} .= "\n<td align=\"center\" >";
	$SearchForm{String} .= "\n<input type=\"text\" name=\"searchdata1\" value=\"\" size=\"40\" style=\"font-size:7pt; font-family:verdana,arial\"/>";
	$SearchForm{String} .= "\n</td>";
	$SearchForm{String} .= "\n<td align=\"center\" >";
	$SearchForm{String} .= "\n<input type=\"text\" name=\"searchdata2\" value=\"\" size=\"40\"style=\"font-size:7pt; font-family:verdana,arial\"/>";
	$SearchForm{String} .= "\n</td>";
	$SearchForm{String} .= "\n<td align=\"center\" >";
	$SearchForm{String} .= "\n<input type=\"text\" name=\"searchdata3\" value=\"\" size=\"40\"style=\"font-size:7pt; font-family:verdana,arial\"/>";
	$SearchForm{String} .= "\n</td>";
	$SearchForm{String} .= "\n</tr>";
	$SearchForm{String} .= "\n<tr>";
	$SearchForm{String} .= "\n<td align=\"center\" >";	
	$SearchForm{String} .= "\n</td>";	
	$SearchForm{String} .= "\n</tr>";	
	$SearchForm{String} .= "\n</table>";	
return 	$SearchForm{String};
};

sub main::act_sdb_config_navbarform
{
my($QJString) = "\n<table border=\"$main::Config{sdb}{opt}{navbar}{tb_border}\" cellpadding=\"$main::Config{sdb}{opt}{navbar}{tb_cpadding}\" cellspacing=\"$main::Config{sdb}{opt}{navbar}{tb_cspacing}\" style=\"width:$main::Config{sdb}{opt}{navbar}{tb_width}; font-family:$main::Config{sdb}{opt}{navbar}{tb_fontfamily}; font-size:$main::Config{sdb}{opt}{navbar}{tb_fontsize}pt; background:$main::Config{sdb}{opt}{navbar}{tb_background};\">";
$QJString .= "<tr>";
$QJString .= "<td>";
$QJString .= "Example of Navigation Bar...";
$QJString .= "</td>";
$QJString .= "<td align=\"center\" style=\"width:100\">";
$QJString .= " [ <a href=\"$main::UserEnv{href}&c=$main::Form{c}&structure=$main::Form{structure}&parentcommand=$main::Form{parentcommand}\"> &lt&lt </a> ";
$QJString .= " <a href=\"$main::UserEnv{href}&c=$main::Form{c}&structure=$main::Form{structure}&parentcommand=$main::Form{parentcommand}\"> &lt </a> ";
$QJString .= " <a href=\"$main::UserEnv{href}&c=$main::Form{c}&structure=$main::Form{structure}&parentcommand=$main::Form{parentcommand}\"> &gt </a> ";
$QJString .= " <a href=\"$main::UserEnv{href}&c=$main::Form{c}&structure=$main::Form{structure}&parentcommand=$main::Form{parentcommand}\"> &gt&gt </a> ";
$QJString .= " ] </td>";
$QJString .= "</tr>";
$QJString .= "</table>";
return 	$QJString;
};


1;
