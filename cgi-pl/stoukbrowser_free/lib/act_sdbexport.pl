# Action library for sdbexport


	sub main::pre_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute before Template generation:
		   		   
	};
		    
	sub main::post_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute after Template generation:
####################################################################################################################
my($StrFile) =  $main::Config{sdb}{dbstruct}{$main::Form{tablename}};
my($DatabaseFile) =  $main::Config{sdb}{dbmain}{$main::Form{tablename}};
my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{$main::Form{tablename}};
my($IndexLetter) = "t";
my($TableName) = "$main::Form{tablename}";
####################################################################################################################

	
my($String) = undef;

	
$String .= main::act_sdbexport_exporttable($StrFile,$DatabaseFile,$DatabaseFolder,$TableName);
$main::Config{$main::Form{c}}{ok} .= "";
$main::Config{$main::Form{c}}{error} .= "";
$String .= main::act_sdbexport_form();

$main::Config{sdb}{ExportedDataFile} = $main::Config{TempFolder} . "$TableName".".txt";
$main::Config{sdb}{ExportedDataFileRef} = $main::Config{ScriptWebRoot}. "$main::ConfigEnv{TempFolder}" . "$TableName".".txt";
if (-e $main::Config{sdb}{ExportedDataFile}) 
{
$String = "<br><a href=\"$main::Config{sdb}{ExportedDataFileRef}\" style=\"color:#000; background:#fff\">Get exported data file.</a>" . $String;
} else {
	$String = "<br>Export Failed." . $String;
	};	
$String .= "<input type=\"submit\" value=\"Submit\" />";
$String = $main::Config{$main::Form{c}}{error} . $main::Config{$main::Form{c}{ok}} . $String;
$main::Html{ServiceText} =~ s!<insert-sdbexport-content>!$String!gis;
};


sub main::act_sdbexport_form

{
my($String) = undef;
my($key) = undef;
my($temp) = undef;

$String .= qq(
<DIV style=\"background:$main::Config{divopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor}\">
<center>
<table BORDER=\"$main::Config{tbopt}{tb_border}\" CELLPADDING=\"$main::Config{tbopt}{tb_cpadding}\" CELLSPACING=\"$main::Config{tbopt}{tb_cspacing}\" 
style=\"width:$main::Config{tbopt}{tb_width}; 
font-family:$main::Config{divopt}{tb_fontfamily}; 
font-size:$main::Config{divopt}{tb_fontsize}pt; 
background:$main::Config{tbopt}{tb_background}; 
color:$main::Config{divopt}{tb_textcolor};\">

<tr>
	<td><b></b></td>
	<td><b></b></td>	
</tr>
);	


		
$String .= qq(
<tr>
	<td></td>
	<td></td>
</tr>
</table>
</center>
<p>
</DIV>
);
	
return $String;		
};

sub main::act_sdbexport_exporttable
{
my($StructureFile) = $_[0];
my($DatabaseFile) = $_[1];
my($RecordsFolder) = $_[2];
my($TableName) = $_[3];
my($AdministratorMode) = undef;
my($AdminCommand) = $_[4];
my($StructureID) = $_[5];
	if (length($AdminCommand) > 1)
	{
	$AdministratorMode = 1;	
	};
my(%ViewOption) = undef;
my(%Structure) = undef;
my(%Data) = undef;
my(%RecordData) = undef;
my($key) = undef;
my($subkey) = undef;
my($ViewOptionUpdated) = undef;
my($IndexFileName) = $main::Config{sdb}{uroot} . "$TableName". ".ind";
my(@IndexData) = undef;
my($IndexCnt) = undef;
my(@StructureName) = undef;
my(@StructureTitle) = undef;
my(@StructureType) = undef;
my(@StructureNote) = undef;
my(@StructureKey) = undef;
my($sc) = undef;
my(%FieldName) = undef;
my(@NewIndexData) = undef;
my($id) = undef;
my($ReIndexingRequired) = undef;
my($i) = undef;
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Processing table \"$TableName\": $StructureFile") : 0;
my($String) = undef;
my($TotalFields) = undef;
my($temp) = undef;
my($totalfields) = undef;
my($RecordString) = undef;
my($DisplayTrigger) = undef;
my(@QuickJumpID) = undef;
my(@QuickJumpPT) = undef;
my($QJCnt) = undef;
my($QJString) = undef;
my($JKID) = undef;
my($JTemp) = undef;
my(%SearchForm) = undef;
my($MemoPath) = $RecordsFolder . "memo/";
unless (-e $MemoPath) {mkdir($MemoPath,0777)}
my($BinPath) = $RecordsFolder . "bin/";
unless (-e $BinPath) {mkdir($BinPath,0777)}
my(%ViewOpt) = undef;
my($ExportLine) = undef;
my(@ER) = undef;
my($ERCount) = undef;
my(@EL) = undef;
my($ELCount) = undef;
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

if ($main::EnableDebug) {$SubDebug = 1}; 

# $String .= "\n<center><table $main::Config{sdb}{opt}{view}{tb_border} $main::Config{sdb}{opt}{view}{tb_cpadding} $main::Config{sdb}{opt}{view}{tb_cspacing} style=\"$main::Config{sdb}{opt}{view}{tb_width} $main::Config{sdb}{opt}{view}{tb_fontfamily} $main::Config{sdb}{opt}{view}{tb_fontsize} $main::Config{sdb}{opt}{view}{tb_background}\">";	


# Reading User-Specific database view configuration file:
if (-f $main::Config{sdb}{udb}{config})
{
%ViewOption = 	main::ReadIntConfig($main::Config{sdb}{udb}{config});
# Structure file is passed as a first parameter. This defines the fields of the database structure: reading it....
	if (-f $StructureFile)
		{
		%Structure = main::ReadIntConfig($StructureFile);
			# Assigning fields to an array. We need an array to keep the exact order....
		
		# $String .= "\n<tr>";
		my($HeaderString) = "\n<tr>";
					if ($AdministratorMode == 1)
					{
					$HeaderString .= "\n<td>";	
					$HeaderString .= "</td>";
					};
	
			foreach $key (sort keys %Structure)
			{
				if (defined $Structure{$key}{type})
				{
					if ($main::Config{sdb}{opt}{$StructureID}{$Structure{$key}{name}}{hide} == 1)
					{
						
					} else {
						($SubDebug == 1) ? DebugOut("Defined Field Name: $Structure{$key}{name}") : 0;			
						$StructureName[$sc] = $Structure{$key}{name};
						$StructureType[$sc] = $Structure{$key}{type};
						$StructureTitle[$sc] = $Structure{$key}{title};
						$StructureNote[$sc] = $Structure{$key}{note};
						$EL[$ELCount++] = $StructureTitle[$sc];
						$StructureKey[$sc] = $key;
						$SearchForm{field} = $Structure{$key}{name};
						if ($Structure{$key}{ownerlock}) {$main::Config{sdb}{tableownerlock} = 1};
						
						$main::Config{sdb}{opt}{calculated}{view}{width} = $main::Config{sdb}{opt}{calculated}{view}{width} + $main::Config{sdb}{opt}{$StructureID}{$StructureName[$sc]}{width};
						
							if (($StructureType[$sc] eq "dtyear") || ($StructureType[$sc] eq "dtmonth") || ($StructureType[$sc] eq "dtdate") || ($StructureType[$sc] eq "dthour") || ($StructureType[$sc] eq "dtminute") || ($StructureType[$sc] eq "dtsecond") || ($StructureType[$sc] eq "dtwday") || ($StructureType[$sc] eq "bin"))
							{
								if ($main::Config{sdb}{opt}{$StructureID}{$Structure{$key}{name}}{width} > 0)
								{
								$HeaderString .= "\n<td style=\"width:$main::Config{sdb}{opt}{$StructureID}{$Structure{$key}{name}}{width}\" align=\"center\">";
								} else {
									$HeaderString .= "\n<td style=\"width:40\" align=\"center\">";
									};
							
							} else {
				
								if ($main::Config{sdb}{opt}{$StructureID}{$Structure{$key}{name}}{width} > 0)
								{
								$HeaderString .= "\n<td align=\"center\" style=\"width:$main::Config{sdb}{opt}{$StructureID}{$Structure{$key}{name}}{width}\">";
								} else {
									$HeaderString .= "\n<td align=\"center\">";
									};
				
								
								};
						
						$HeaderString .= "<b>$StructureTitle[$sc]</b>";
						$HeaderString .= "</td>";
						# This will let us known if the field with this name really exists, when we sort by specific field name...
						$FieldName{$Structure{$key}{name}} = 1;
						$sc++;
						};
	
				};
			};
		$HeaderString .= "\n</tr>";
				$totalfields = scalar @StructureName;
	
	
	if ($main::Config{sdb}{opt}{calculated}{view}{width} < $main::Config{sdb}{opt}{view}{width}) {$main::Config{sdb}{opt}{calculated}{view}{width} = $main::Config{sdb}{opt}{view}{width}};
	if ($main::Config{sdb}{opt}{calculated}{view}{width} < 100) {$main::Config{sdb}{opt}{calculated}{view}{width} = "100%"};
	$String .= "\n<DIV style=\"background:$main::Config{sdb}{opt}{div}{tb_background}; color:$main::Config{sdb}{opt}{div}{tb_textcolor}\"><center><table BORDER=\"$main::Config{sdb}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{sdb}{opt}{view}{tb_cpadding}\" CELLSPACING=\"$main::Config{sdb}{opt}{view}{tb_cspacing}\" style=\"width:$main::Config{sdb}{opt}{calculated}{view}{width}; font-family:$main::Config{sdb}{opt}{view}{tb_fontfamily}; font-size:$main::Config{sdb}{opt}{view}{tb_fontsize}pt; background:$main::Config{sdb}{opt}{view}{tb_background}; color:$main::Config{sdb}{opt}{view}{tb_color};\">";

													for ($mc = 0; $mc < $ELCount; $mc++)
													{
													$EL[$mc] = "\"" .$EL[$mc]. "\"";
													};
													$ER[$ERCount++] = join(",",@EL) . "\n";
													undef @EL;
													undef $ELCount;

				
	################ Create Search Form #############################
	

	################ Create Search Form #############################			
	# Check if we still index by the same field;		
	# We pass parameter from the form and parameter name is "IndexBy"			
	# ViewOption we previously read from the user-specific options file
			if (($main::Form{IndexBy} eq "$ViewOption{$TableName}{IndexBy}") && (defined $ViewOption{$TableName}{IndexBy}) )
			{
			# indexing did not change.....
			($SubDebug == 1) ? DebugOut("Indexing did not change...") : 0;			
			} else {
					if (length($main::Form{IndexBy}) < 2)
					{
						($SubDebug == 1) ? DebugOut("IndexBy from Form is Empty!") : 0;
						if (defined $ViewOption{$TableName}{IndexBy})
						{
						($SubDebug == 1) ? DebugOut("Previously Indexed By this field: \"$ViewOption{$TableName}{IndexBy}\" Will No Re-Index at this time...") : 0;
						# will not re-index.....
						} else {
							($SubDebug == 1) ? DebugOut("FIRST-TIME Indexing: Previously Indexed By this field: \"$ViewOption{$TableName}{IndexBy}\"") : 0;
							# Form parameter "IndexBy" and user-specific option to sort by specific field name does not match...
							# Let's check if the field name, which we have read from the User options  really exists if it does not exist, we have to assume that
							# this is the first time user views this table....
							$ReIndexingRequired = 1;
							$ViewOption{$TableName}{IndexBy} = $StructureName[0];
							};
					} else {
						($SubDebug == 1) ? DebugOut("Passed IndexBy field and it does not match the one stored in Options - Re-indexing...") : 0;
						$ReIndexingRequired = 1;
						$ViewOption{$TableName}{IndexBy} = $main::Form{IndexBy};
						};
	
				};		
	
				my($TimeStampDatabaseFile) = ((stat($DatabaseFile))[9]);
				my($TimeStampIndexFile) = undef;
				
				unless (-f $IndexFileName)
				{
				($SubDebug == 1) ? DebugOut("Indexing file does not exist \"$IndexFileName\" re-indexing to create one...") : 0;
				$ReIndexingRequired = 1;
				} else {
					$TimeStampIndexFile =  ((stat($IndexFileName))[9]);	
					};
	
				unless ($TimeStampIndexFile == $TimeStampDatabaseFile)
				{
					($SubDebug == 1) ? DebugOut("Indexing file has a different time stamp than Database file - Re-Indexing is required...") : 0;
					$ReIndexingRequired = 1;
				} else {
					# ($SubDebug == 1) ? DebugOut("Time Stamps Are the same \"$TimeStampIndexFile\" == \"$TimeStampDatabaseFile\"") : 0;
					};
	
			
			if ($main::Form{IndexReverse} > 0)
			{
			($SubDebug == 1) ? DebugOut("Passed IndexRevese form data...") : 0;
				if (($main::Form{IndexReverse} > $ViewOption{$TableName}{IndexReverse})  || ($main::Form{IndexReverse} < $ViewOption{$TableName}{IndexReverse}) )
				{
				$ViewOption{$TableName}{IndexReverse} = $main::Form{IndexReverse};
				$ReIndexingRequired = 1;
				($SubDebug == 1) ? DebugOut("Reversing Indexing...") : 0;
				};
			} else {
				($SubDebug == 1) ? DebugOut("DID NOT Pass IndexRevese form data...") : 0;
				if ($ViewOption{$TableName}{IndexReverse} > 0)
				{
				($SubDebug == 1) ? DebugOut("Not Reversing Indexing...") : 0;
				} else {
					$ViewOption{$TableName}{IndexReverse} = 1;
					($SubDebug == 1) ? DebugOut("First Time Creating IndexReverse Option") : 0;
					($SubDebug == 1) ? DebugOut("Not Reversing Indexing...") : 0;
					};
				
				};
	
	# Create Sort Table Row ...
	my($SortString) = "\n<tr>";
			if ($AdministratorMode == 1)
			{
			$SortString .= "\n<td>";	
			$SortString .= "</td>";
			};
	
			for ($sc=0; $sc < $totalfields; $sc++)
			{
				if ($StructureName[$sc] eq $ViewOption{$TableName}{IndexBy})
				{
					if ($ViewOption{$TableName}{IndexReverse} == 2)
					{
					$SortString .= "\n<td align=\"center\">";
					$SortString .= "<a href=\"$main::UserEnv{href}&c=$main::Form{c}&IndexBy=$StructureName[$sc]&IndexReverse=1&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$main::Form{ViewType}\"><b><font size=2>[ v ]</font></b></a>";
					$SortString .= "</td>";			
					} else {
						$SortString .= "\n<td align=\"center\">";
						$SortString .= "<a href=\"$main::UserEnv{href}&c=$main::Form{c}&IndexBy=$StructureName[$sc]&IndexReverse=2&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$main::Form{ViewType}\"><b><font size=2>[ ^ ]</font></b></a>";
						$SortString .= "</td>";			
						};				
				} else {
					$SortString .= "\n<td align=\"center\">";
					$SortString .= "<a href=\"$main::UserEnv{href}&c=$main::Form{c}&IndexBy=$StructureName[$sc]&IndexReverse=2&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$main::Form{ViewType}\"><font size=2>. . .</font></a>";
					$SortString .= "</td>";			
					};
	
			};
	$SortString .= "\n</tr>";
	$String .= $HeaderString;
	$String .= $SortString;
	
	# Checking if we need to shift the display point.
	
		($SubDebug == 1) ? DebugOut("Checking if Display point is defined from Form: ($main::Form{DisplayPoint})") : 0;
		if (defined $main::Form{DisplayPoint})
		{
			if (($main::Form{DisplayPoint} < $ViewOption{$TableName}{DisplayPoint}) || ($main::Form{DisplayPoint} > $ViewOption{$TableName}{DisplayPoint}) )
			{
			($SubDebug == 1) ? DebugOut("Display Point was changed ($main::Form{DisplayPoint}) ne ($ViewOption{$TableName}{DisplayPoint})") : 0;
			$ViewOption{$TableName}{DisplayPoint} = $main::Form{DisplayPoint};	
			};	
		};
	
	$ReIndexingRequired = 1;
	
			if ($ReIndexingRequired == 1)
			{
			# Process Recreating of index file here....using $ViewOption{$TableName}{IndexBy}
			if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Reading Database file: \"$DatabaseFile\"") : 0;
			%Data = main::ReadIntConfig($DatabaseFile);
			if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Was read - OK") : 0;
			($SubDebug == 1) ? DebugOut("Indexing By:  \$ViewOption{$TableName}{IndexBy} = \"$ViewOption{$TableName}{IndexBy}\"") : 0;
				if ($ViewOption{$TableName}{IndexReverse} == 1)
				{
				($SubDebug == 1) ? DebugOut("Indexing is Reversed...") : 0;
	
					foreach $key (reverse sort {$Data{$a}{$ViewOption{$TableName}{IndexBy}} cmp $Data{$b}{$ViewOption{$TableName}{IndexBy}}} keys %Data)
					{
						$JTemp = substr($Data{$key}{$ViewOption{$TableName}{IndexBy}},0,1);
						if ($JKID ne $JTemp) {$JKID = $JTemp; $IndexData[$IndexCnt++] = $key .":"."$IndexCnt".":"."$JKID" ."\n"} else {$IndexData[$IndexCnt++] = $key . "\n"};
						($SubDebug == 1) ? DebugOut("Index check:  $Data{$key}{$ViewOption{$TableName}{IndexBy}}") : 0;
					
					};
				} else {
						foreach $key (sort {$Data{$a}{$ViewOption{$TableName}{IndexBy}} cmp $Data{$b}{$ViewOption{$TableName}{IndexBy}}} keys %Data)
						{
							$JTemp = substr($Data{$key}{$ViewOption{$TableName}{IndexBy}},0,1);
						        if ($JKID ne $JTemp) {$JKID = $JTemp; $IndexData[$IndexCnt++] = $key .":"."$IndexCnt".":"."$JKID" ."\n"} else {$IndexData[$IndexCnt++] = $key . "\n"};
							($SubDebug == 1) ? DebugOut("Index check:  $Data{$key}{$ViewOption{$TableName}{IndexBy}}") : 0;
						};
					};
			($SubDebug == 1) ? DebugOut("Saving Index file: $IndexFileName") : 0;
			main::SaveFile($IndexFileName,@IndexData);
	
			utime($TimeStampDatabaseFile,$TimeStampDatabaseFile,$IndexFileName);
			
			$ViewOption{$TableName}{DisplayPoint} = 0;
			($SubDebug == 1) ? DebugOut("Setting Display Point to Zero...") : 0;
			} else {
				($SubDebug == 1) ? DebugOut("Reading Index File: \"$IndexFileName\"") : 0;
				@IndexData = main::ReadFile($IndexFileName);
				$IndexCnt = scalar @IndexData;
				if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("OK. Read $IndexCnt indexes records...") : 0;
				};
	
	# We do not have to display the whole data, we just need to display data starting from some point (one web page).
	# Start point and the length is defined in the ViewerOption of the user. It is user-specific.
	# If the length is not defined, we reset it. We also reset it if re-indexing has occured.
	# We also assign default display length if not defined already...
		unless ($main::Form{DisplayLength} == $ViewOption{$TableName}{DisplayLength}) 
		{ 
			if ($main::Form{DisplayLength} > 10)
			{
			$ViewOption{$TableName}{DisplayLength} = $main::Form{DisplayLength}	
			};
		};
	if ($ViewOption{$TableName}{DisplayLength} < 2) {$ViewOption{$TableName}{DisplayLength} = 10};
	
	
	# Checking if Next Display Point is higher than the maximum data count
		if (($ViewOption{$TableName}{DisplayPoint} + $ViewOption{$TableName}{DisplayLength}) > $IndexCnt)
		{
		($SubDebug == 1) ? DebugOut("Display Point ($ViewOption{$TableName}{DisplayPoint}) + ViewPoint Length ($ViewOption{$TableName}{DisplayLength}) is greater than total number of elements...($IndexCnt) ") : 0;
		$ViewOption{$TableName}{DisplayPoint} = $IndexCnt - $ViewOption{$TableName}{DisplayLength};
		};
	# Checking if Display point is lower than zero...
		if ($ViewOption{$TableName}{DisplayPoint} < 0)
		{
		($SubDebug == 1) ? DebugOut("Display Point is less than Zero ($ViewOption{$TableName}{DisplayPoint})") : 0;
		$ViewOption{$TableName}{DisplayPoint} = 0;	
		};
	# Now we need to read the data files for each record we want to display and prepare a display table
	# ($SubDebug == 1) ? DebugOut("\$IndexCnt = $IndexCnt") : 0;
		for ($i = 0; $i <= $IndexCnt; $i++)
		{
		#($SubDebug == 1) ? DebugOut("\$IndexData[$i] = $IndexData[$i]") : 0;
			if ($IndexData[$i] =~ m!(.*):(.*):(.)!) 
			{
			$QuickJumpID[$QJCnt] = $3;
			$QuickJumpPT[$QJCnt] = $2;
		#	($SubDebug == 1) ? DebugOut("\$QJCnt = $QJCnt : \$QuickJumpID[$QJCnt] = $QuickJumpID[$QJCnt], \$QuickJumpPT[$QJCnt] = $QuickJumpPT[$QJCnt]") : 0;
			$QJCnt++;
			};
		};
	
	($SubDebug == 1) ? DebugOut("Display elements from this point: $ViewOption{$TableName}{DisplayPoint}") : 0;
	my($DisplayRecords) = undef;
	$DisplayRecords = $ViewOption{$TableName}{DisplayPoint} + $ViewOption{$TableName}{DisplayLength};
	if ($DisplayRecords > $IndexCnt) {$DisplayRecords = $IndexCnt};
	
				for ($i = 1; $i < $IndexCnt; $i++)
				{
					if ($IndexData[$i] =~ m!(.*):(.*):(.)!) 
					{
					$id = $1; 
					} else {
						$id = $IndexData[$i]; $id =~ s!\n!!i;	
						};
			
					$temp = $RecordsFolder . $id . ".cgi";
					($SubDebug == 1) ? DebugOut("Records File: \"$temp\"") : 0;
					$RecordString = "";
						if (-f $temp)
						{
						%RecordData = main::ReadIntConfig($temp);
						main::DebugOut("\$RecordData{f_id} = $RecordData{f_id}");
							# Assigning each field value
			###############################################################################################################
					# $main::Form{ViewType} = 2;
					my($MemoRecord) = undef;
					my($TempMemoPath) = undef;
					
					if (defined $ViewOption{$TableName}{ViewType})
					{
						if (defined $main::Form{ViewType})
						{
							if ($ViewOption{$TableName}{ViewType} ne $main::Form{ViewType}) 
							{
							$ViewOption{$TableName}{ViewType} = $main::Form{ViewType};
							};		
						};
					} else {
							if (defined $main::Form{ViewType})
							{
							$ViewOption{$TableName}{ViewType} = $main::Form{ViewType};
							};
						};

					
					#&ViewType=$ViewOption{$TableName}{ViewType};

	
							$String .= "\n</table></DIV><DIV style=\"background:$main::Config{sdb}{opt}{div}{tb_background}; color:$main::Config{sdb}{opt}{div}{tb_textcolor}\"><center><table BORDER=\"$main::Config{sdb}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{sdb}{opt}{view}{tb_cpadding}\" CELLSPACING=\"$main::Config{sdb}{opt}{view}{tb_cspacing}\" style=\"width:$main::Config{sdb}{opt}{calculated}{view}{width}; font-family:$main::Config{sdb}{opt}{view}{tb_fontfamily}; font-size:$main::Config{sdb}{opt}{view}{tb_fontsize}pt; background:$main::Config{sdb}{opt}{view}{tb_background}; color:$main::Config{sdb}{opt}{view}{tb_color};\">";
							$RecordString .= "\n<tr><td></td><td style=\"color:#222;background:#222; font-size:1pt\">.</td><tr>";
							#
													
													@EL = undef;
													$ELCount = undef;
													
													for ($sc = 0; $sc < $totalfields; $sc++)
													{
													# We will display records based on record type here....
													$RecordString .= "\n<tr><td valign=\"top\" align=\"left\" style=\"width:10%\"><b>$StructureTitle[$sc]</b></td>";
													$RecordString .= "\n<td style=\"width:90%\">";
													DebugOut("\$RecordData{\$StructureType[$sc] = $StructureType[$sc] : $StructureName[$sc]} = $RecordData{$StructureName[$sc]}");
													if ($RecordData{$StructureName[$sc]} =~ m!.!)
													{
														if ($StructureType[$sc] eq "memo")
														{
														$TempMemoPath = $MemoPath . "$id" . "."."$StructureName[$sc]";
														($SubDebug == 1) ? DebugOut("\$TempMemoPath = $TempMemoPath") : 0;
														if (-e $TempMemoPath) 
														{
														($SubDebug == 1) ? DebugOut("Reading Memo File - OK") : 0;
														$MemoRecord = join("",(main::ReadFile($TempMemoPath)));
														$EL[$ELCount++] = $MemoRecord;
														$MemoRecord = $temp = substr($MemoRecord,0,65000);
														$MemoRecord = main::lib_html_Escape($MemoRecord);
														$MemoRecord =~ s!\n!<br>!gis;
														$MemoRecord =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;
														$RecordString .= "$MemoRecord" . " <a href=\"$main::UserEnv{href}&memoview=$id"."."."$StructureName[$sc]"."&c=$main::Form{c}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_blank\">...</a>";
														} else {
															($SubDebug == 1) ? DebugOut("Memo file does not exist!") : 0;
															$MemoRecord = main::lib_html_Escape($RecordData{$StructureName[$sc]});
															$MemoRecord =~ s!\n!<br>!gis;
															$MemoRecord =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;								
															$RecordString .= "$MemoRecord" . " <a href=\"$main::UserEnv{href}&memoview=$id"."."."$StructureName[$sc]"."&c=$main::Form{c}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_blank\">...</a>";	
															};
														} elsif ($StructureType[$sc] eq "bin")
														{
														$RecordString .= " <a href=\"$main::UserEnv{href}&binview=$id"."."."$StructureName[$sc]"."&c=$main::Form{c}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_blank\">get file</a>";	
														$EL[$ELCount++] = "$RecordData{$StructureName[$sc]}";
														} elsif ($StructureType[$sc] =~ m!^Link!i)
														{
															$temp = $RecordData{$StructureName[$sc]};
															$temp =~ s#!\[\(.*\)\]!##gsi;
															$temp = substr($temp,0,254);
															$EL[$ELCount++] = "$temp";
															$temp .= "<a href=\"$main::UserEnv{href}&selectview=$id"."."."$StructureName[$sc]"."&c=$main::Form{c}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_blank\">. . .</a>";
															
														$RecordString .= "$temp";
														
														} elsif ($StructureType[$sc] eq "timestamp")
														{
														$RecordString .= scalar localtime($RecordData{$StructureName[$sc]});	
														$EL[$ELCount++] = "$RecordData{$StructureName[$sc]}";
														} else {
															$RecordString .= "$RecordData{$StructureName[$sc]}";		
															$EL[$ELCount++] = "$RecordData{$StructureName[$sc]}";
															};
													
													} else {
														$EL[$ELCount++] = "";
														$RecordString .= "&nbsp";
														};
							
							
													$RecordString .= "</td></tr>";
													 if (defined $RecordData{$StructureName[$sc]}) {$DisplayTrigger = 1};
													};
			###############################################################################################################
						} else {
							($SubDebug == 1) ? DebugOut("ERROR: record does not exist! \"$temp\"") : 0;
							};
					$RecordString .= "\n</tr>";
					for ($mc = 0; $mc < $ELCount; $mc++)
					{
					$EL[$mc] = "\"" . $EL[$mc] . "\"";
					};
					$ER[$ERCount++] = join(",",@EL) . ":ENDOFRECORD:\n";
					undef @EL;
					undef $ELCount;

						($SubDebug == 1) ? DebugOut("Checking if \$AdministratorMode = \"$AdministratorMode\"") : 0;
						my($AdminString) = undef;
							if ($AdministratorMode == 1)
							{
								if ($main::Config{sdb}{tableownerlock} == 1) 
								{
									if (($RecordData{"f_owner"} eq "$main::UserEnv{name}") || ($main::UserEnv{group} =~ m!administrators!))
									{
									$AdminString = "\n<td style=\"width:30\"><input type=\"CHECKBOX\" name=\"DELETE"."$id\" value=\"$id\"\"> <a href=\"$main::UserEnv{href}&c=$AdminCommand&act=edit&Mode=Modify&Modify=1&indexid=$id&ViewType=$ViewOption{$TableName}{ViewType}\"> ! </a></td>";
									$String .= "\n<tr>" . $AdminString . $RecordString;
									} else {
										$AdminString = "\n<td style=\"width:30\"> x </a></td>";
										$String .= "\n<tr>" . $AdminString . $RecordString;
										};
								} else {
									$AdminString = "\n<td style=\"width:30\"><input type=\"CHECKBOX\" name=\"DELETE"."$id\" value=\"$id\"\"> <a href=\"$main::UserEnv{href}&c=$AdminCommand&act=edit&Mode=Modify&Modify=1&indexid=$id&ViewType=$ViewOption{$TableName}{ViewType}\"> ! </a></td>";
									$String .= "\n<tr>" . $AdminString . $RecordString;									
									};
							} else {
								$String .= "\n<tr>" . $RecordString;
								};
				};
	
	
	
	} else {
		($SubDebug == 1) ? DebugOut("ERROR: Structure file does not exist! \"$StructureFile\"") : 0;
		};
# $main::Config{sdb}{udb}{ind}{$TableName}
} else {
	($SubDebug == 1) ? DebugOut("ERROR: User Configuration file for database viewing does not exist! \"$main::Config{sdb}{udb}{config}\"") : 0;
	};
$String .= "\n</table></center>";	

# $QJString = "\n<table cellpadding=1 cellspacing=0 border=1 style=\"width:100%; font-family:verdana,arial; font-size:8pt; background:#cdf\">";
$QJString = "\n<table border=\"$main::Config{sdb}{opt}{navbar}{tb_border}\" cellpadding=\"$main::Config{sdb}{opt}{navbar}{tb_cpadding}\" cellspacing=\"$main::Config{sdb}{opt}{navbar}{tb_cspacing}\" style=\"width:$main::Config{sdb}{opt}{navbar}{tb_width}; font-family:$main::Config{sdb}{opt}{navbar}{tb_fontfamily}; font-size:$main::Config{sdb}{opt}{navbar}{tb_fontsize}pt; background:$main::Config{sdb}{opt}{navbar}{tb_background};\">";
$QJString .= "<tr>";
$QJString .= "<td align=\"center\" style=\"width:100\">";
$QJString .= " [ <a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=0&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\"> &lt&lt </a> ";
$QJString .= " <a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=".($ViewOption{$TableName}{DisplayPoint} - $ViewOption{$TableName}{DisplayLength})."&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\"> &lt </a> ";
$QJString .= " <a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=".($ViewOption{$TableName}{DisplayPoint} + $ViewOption{$TableName}{DisplayLength})."&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\"> &gt </a> ";
$QJString .= " <a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=".($IndexCnt - $ViewOption{$TableName}{DisplayLength})."&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\"> &gt&gt </a> ";
$QJString .= " ] </td>";
$QJString .= "<td align=\"center\" style=\"width:100\">";
if ($ViewOption{$TableName}{DisplayPoint} <  1) {$temp = 1} else {$temp = $ViewOption{$TableName}{DisplayPoint}};
$QJString .= " $temp - ".($ViewOption{$TableName}{DisplayPoint} + $ViewOption{$TableName}{DisplayLength})." of $IndexCnt ";
$QJString .= "</td>";
	if ($main::Form{SearchBrowse} == 1)
	{
	$QJString .= "<td align=\"center\" style=\"width:100\">";
	$QJString .= " <a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=0&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=0&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\"> All Records </a> ";	
	$QJString .= "</td>";
	};

$QJString .= "<td align=\"center\" style=\"width:500\"> [ ";
($SubDebug == 1) ? DebugOut("QuickJump Count = \"$QJCnt\"") : 0;
	for ($i = 0; $i <= $QJCnt; $i++)
	{
	($SubDebug == 1) ? DebugOut("\$QuickJumpID[$i] = $QuickJumpID[$i]") : 0;
	$QJString .= "<a href=\"$main::UserEnv{href}&c=$main::Form{c}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&IndexBy=$ViewOption{$TableName}{IndexBy}&DisplayPoint=$QuickJumpPT[$i]&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\">$QuickJumpID[$i] </a>";
	};
$QJString .= " ] </td>";	

	unless ($main::UserEnv{name} =~ m!^guest!i)
	{
	$QJString .= "<td align=\"center\" style=\"width:150\">";
	$QJString .= " [<a href=\"$main::UserEnv{href}&c=sdbconfig&structure=$StructureID&ViewType=$main::Form{ViewType}&caller=$main::Form{c}\">Preferences</a>] ";
	$QJString .= "</td>";
	};

$QJString .= "<td align=\"center\" style=\"width:100\">";
	if ($main::Form{ViewType} == 2)
	{
	$QJString .= " [<a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=0&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=1\">Table View</a>] ";	
	} else {
	$QJString .= " [<a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=0&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=2\">List View</a>] ";	
		};
$QJString .= "</td>";


	if ($main::UserEnv{name} =~ m!^administrator!i)
	{
	$QJString .= "<td align=\"center\" style=\"width:100\">";
	$QJString .= " [<a href=\"$main::UserEnv{href}&c=sdbimport&tablename=$StructureID\">Import</a>] ";
	$QJString .= "</td>";
	};

	$QJString .= "<td align=\"center\" style=\"width:100\">";
	$QJString .= " [(<a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=$ViewOption{$TableName}{DisplayPoint}&DisplayLength=".($ViewOption{$TableName}{DisplayLength} - 10)."&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\">-10</a>)";
	$QJString .= " (<a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=$ViewOption{$TableName}{DisplayPoint}&DisplayLength=".($ViewOption{$TableName}{DisplayLength} + 10)."&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\">+10</a>)]";
	$QJString .= "</td>";

$QJString .= "</tr>";	
$QJString .= "</table>";
$String .= "</DIV>";
$String = $SearchForm{String} . $QJString . $String . $QJString;

	if ($AdministratorMode == 1)
	{
	$String .= qq(
	<center><input type="hidden" name="IndexReverse" value="$ViewOption{$TableName}{IndexReverse}">
	<input type="hidden" name="IndexBy" value="$ViewOption{$TableName}{IndexBy}">
	<input type="hidden" name="DisplayPoint" value="$ViewOption{$TableName}{DisplayPoint}">
	<input type="hidden" name="SearchBrowse" value="$main::Form{SearchBrowse}">
	<input type="hidden" name="selectview" value="$main::Form{selectview}">
	<input type="hidden" name="ViewType" value="$ViewOption{$TableName}{ViewType}">
	<input type="submit" name="Mode" value="Add Records">
	<input type="submit" name="Delete" value="Delete Selected">
	
	</center>
		     );
	};
# Saving User preferences back to options file...

($SubDebug == 1) ? DebugOut("Updated User View configuration file \"$main::Config{sdb}{udb}{config}\"") : 0;
main::WriteIntConfig("config",\%ViewOption,$main::Config{sdb}{udb}{config});
$main::Config{sdb}{ExportedDataFile} = $main::Config{TempFolder} . "$TableName".".txt";
$main::Config{sdb}{ExportedDataFileRef} = $main::Config{ScriptWebRoot}. "$main::ConfigEnv{TempFolder}" . "$TableName".".txt";

main::SaveFile($main::Config{sdb}{ExportedDataFile},@ER);
return $String;
};

1;
