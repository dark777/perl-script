####################################################################################################################
sub main::lib_sdbview_viewrecords
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
my($ImagePath) = $RecordsFolder . "image/";
unless (-e $ImagePath) {mkdir($ImagePath,0777)}
my($ImageTempPath) = undef;
my($ImageTempWebPath) = undef;
my($ImageFile) = undef;
my(%AdminOpt) = undef;

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

my($OptKey) = undef;
my($OptSubKey) = undef;

if ($main::EnableDebug) {$SubDebug = 1}; 

# $String .= "\n<center><table $main::Config{sdb}{opt}{view}{tb_border} $main::Config{sdb}{opt}{view}{tb_cpadding} $main::Config{sdb}{opt}{view}{tb_cspacing} style=\"$main::Config{sdb}{opt}{view}{tb_width} $main::Config{sdb}{opt}{view}{tb_fontfamily} $main::Config{sdb}{opt}{view}{tb_fontsize} $main::Config{sdb}{opt}{view}{tb_background}\">";	


# Reading User-Specific database view configuration file:
if (-f $main::Config{sdb}{udb}{config})
{
%ViewOption = 	main::ReadIntConfig($main::Config{sdb}{udb}{config});
($SubDebug == 1) ? DebugOut("Checking if Administrative Options exist: $RecordsFolder adminconfig.cgi") : 0;
		if (-f ($RecordsFolder ."adminconfig.cgi"))
		{
		%AdminOpt = main::ReadIntConfig(($RecordsFolder ."adminconfig.cgi"));	
		($SubDebug == 1) ? DebugOut("Reading Administrative Options: $RecordsFolder adminconfig.cgi") : 0;
			if ($AdminOpt{div}{sp_disablepreferences} == 1) 
			{
				foreach $OptKey (keys %{$main::Config{sdb}{opt}})
				{
					foreach $OptSubKey (keys %{$main::Config{sdb}{opt}{$OptKey}})
					{
						if (($main::Config{sdb}{opt}{$OptKey}{$OptSubKey} > $AdminOpt{$OptKey}{$OptSubKey}) || ($main::Config{sdb}{opt}{$OptKey}{$OptSubKey} < $AdminOpt{$OptKey}{$OptSubKey}) )
						{
						$main::Config{sdb}{opt}{$OptKey}{$OptSubKey} = $AdminOpt{$OptKey}{$OptSubKey};
						if ($main::Config{sdb}{opt}{$OptKey}{$OptSubKey} < 1) {$main::Config{sdb}{opt}{$OptKey}{$OptSubKey} = 0};
						($SubDebug == 1) ? DebugOut("Forced Administrative Option: \$main::Config{sdb}{opt}{$OptKey}{$OptSubKey} = $ViewOption{$OptKey}{$OptSubKey}") : 0;
						};
					};
				};
			};
		};

# Structure file is passed as a first parameter. This defines the fields of the database structure: reading it....
	if (-f $StructureFile)
		{
		%Structure = main::ReadIntConfig($StructureFile);
			# Assigning fields to an array. We need an array to keep the exact order....
		
		# $String .= "\n<tr>";
		my($HeaderString) = "\n<tr>";
					$HeaderString .= "\n<td>";	
					$HeaderString .= "</td>";

			foreach $key (sort keys %Structure)
			{
				if (defined $Structure{$key}{type})
				{
					if (($main::Config{sdb}{opt}{$StructureID}{$Structure{$key}{name}}{hide} == 1) && (length($main::Form{detaileddisplay}) < 2))
					{
						
					} else {
						($SubDebug == 1) ? DebugOut("Defined Field Name: $Structure{$key}{name}") : 0;			
							unless ($Structure{$key}{name} eq "f_owner") 
							{
							$StructureName[$sc] = $Structure{$key}{name};
							$StructureType[$sc] = $Structure{$key}{type};
							$StructureTitle[$sc] = $Structure{$key}{title};
							$StructureNote[$sc] = $Structure{$key}{note};
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
			};
		$HeaderString .= "\n</tr>";
				$totalfields = scalar @StructureName;
	
	
	if ($main::Config{sdb}{opt}{calculated}{view}{width} < $main::Config{sdb}{opt}{view}{width}) {$main::Config{sdb}{opt}{calculated}{view}{width} = $main::Config{sdb}{opt}{view}{width}};
	if ($main::Config{sdb}{opt}{calculated}{view}{width} < 100) {$main::Config{sdb}{opt}{calculated}{view}{width} = "100%"};
	
	
	$String .= "\n<DIV style=\"background:$main::Config{sdb}{opt}{div}{tb_background}; color:$main::Config{sdb}{opt}{div}{tb_textcolor}\"><center><table BORDER=\"$main::Config{sdb}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{sdb}{opt}{view}{tb_cpadding}\" CELLSPACING=\"$main::Config{sdb}{opt}{view}{tb_cspacing}\" style=\"width:$main::Config{sdb}{opt}{calculated}{view}{width}; font-family:$main::Config{sdb}{opt}{view}{tb_fontfamily}; font-size:$main::Config{sdb}{opt}{view}{tb_fontsize}pt; background:$main::Config{sdb}{opt}{view}{tb_background}; color:$main::Config{sdb}{opt}{view}{tb_color};\">";
				
	################ Create Search Form #############################

	unless ($AdminOpt{div}{sp_disablesearch} == 1) 
	{
	$SearchForm{FieldsFormOption} = "<option value=\"\">";
	my($TimeIsHere) = undef;
	
		for ($i = 0; $i < $totalfields ; $i++)
		{
			unless ($StructureType[$i] eq "timestamp")
			{
			$SearchForm{FieldsFormOption} .= "<option value=\"$StructureName[$i]\">$StructureTitle[$i]";
			};
		if ($StructureType[$i] eq "timestamp") {$TimeIsHere = 1};
		};
	
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
	$SearchForm{String} .= "\n<SELECT name=\"searchfield1\" style=\"font-size:7pt; font-family:verdana,arial\">$SearchForm{FieldsFormOption}</SELECT>";
	$SearchForm{String} .= "\n</td>";
	$SearchForm{String} .= "\n<td align=\"center\" >";
	$SearchForm{String} .= "\n<SELECT name=\"searchfield2\" style=\"font-size:7pt; font-family:verdana,arial\">$SearchForm{FieldsFormOption}</SELECT>";
	$SearchForm{String} .= "\n</td>";
	$SearchForm{String} .= "\n<td align=\"center\" >";
	$SearchForm{String} .= "\n<SELECT name=\"searchfield3\" style=\"font-size:7pt; font-family:verdana,arial\">$SearchForm{FieldsFormOption}</SELECT>";
	$SearchForm{String} .= "\n</td>";
	$SearchForm{String} .= "\n</tr>";

	$SearchForm{String} .= "\n<tr>";
	$SearchForm{String} .= "\n<td align=\"center\" >";	
	$SearchForm{String} .= "\n<input type=\"Submit\" name=\"Search\" value=\"Process Search\" size=\"40\"style=\"font-size:8pt; font-family:verdana,arial\"/>";
	$SearchForm{String} .= "\n</td>";	
	
	if ($TimeIsHere)
	{
	$SearchForm{String} .= "\n<td align=\"center\" >";	
	$SearchForm{String} .=	main::lib_sdbview_periodform();	
	$SearchForm{String} .= "\n</td>";	
	};
	$SearchForm{String} .= "\n</tr>";	

	$SearchForm{String} .= "\n</table>";			
	};


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
			$SortString .= "\n<td>";	
			$SortString .= "</td>";
	
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

		unless ($AdminOpt{div}{sp_disablefieldtitles} == 1) 
		{
			unless ($main::Form{details} == 1)
			{
			$String .= $HeaderString;
			$String .= $SortString;
			};
		};
	
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
	
	
			if ($ReIndexingRequired == 1)
			{
			# Process Recreating of index file here....using $ViewOption{$TableName}{IndexBy}
			if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Reading Database file: \"$DatabaseFile\"") : 0;
			%Data = main::ReadIntConfig($DatabaseFile);
			# if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Was read - OK") : 0;
			# ($SubDebug == 1) ? DebugOut("Indexing By:  \$ViewOption{$TableName}{IndexBy} = \"$ViewOption{$TableName}{IndexBy}\"") : 0;
				if ($ViewOption{$TableName}{IndexReverse} == 1)
				{
				($SubDebug == 1) ? DebugOut("Indexing is Reversed...") : 0;
	
					foreach $key (reverse sort {$Data{$a}{$ViewOption{$TableName}{IndexBy}} cmp $Data{$b}{$ViewOption{$TableName}{IndexBy}}} keys %Data)
					{
						$JTemp = substr($Data{$key}{$ViewOption{$TableName}{IndexBy}},0,1);
						if ($JKID ne $JTemp) {$JKID = $JTemp; $IndexData[$IndexCnt++] = $key .":"."$IndexCnt".":"."$JKID" ."\n"} else {$IndexData[$IndexCnt++] = $key . "\n"};
						# ($SubDebug == 1) ? DebugOut("Index check:  $Data{$key}{$ViewOption{$TableName}{IndexBy}}") : 0;
					
					};
				} else {
						foreach $key (sort {$Data{$a}{$ViewOption{$TableName}{IndexBy}} cmp $Data{$b}{$ViewOption{$TableName}{IndexBy}}} keys %Data)
						{
							$JTemp = substr($Data{$key}{$ViewOption{$TableName}{IndexBy}},0,1);
						        if ($JKID ne $JTemp) {$JKID = $JTemp; $IndexData[$IndexCnt++] = $key .":"."$IndexCnt".":"."$JKID" ."\n"} else {$IndexData[$IndexCnt++] = $key . "\n"};
						#	($SubDebug == 1) ? DebugOut("Index check:  $Data{$key}{$ViewOption{$TableName}{IndexBy}}") : 0;
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
			if ($main::Form{DisplayLength} > 9)
			{
			$ViewOption{$TableName}{DisplayLength} = $main::Form{DisplayLength}	
			};
		};
	if ($ViewOption{$TableName}{DisplayLength} < 2) {$ViewOption{$TableName}{DisplayLength} = 20};
	
	
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
	
				for ($i = $ViewOption{$TableName}{DisplayPoint}; $i < $DisplayRecords; $i++)
				{
					if ($IndexData[$i] =~ m!(.*):(.*):(.)!) 
					{
					$id = $1; 
					} else {
						$id = $IndexData[$i]; $id =~ s!\n!!i;	
						};

	if (($main::Form{detaileddisplay} eq $id) || (length($main::Form{detaileddisplay}) < 2))
	{

			
					$temp = $RecordsFolder . $id . ".cgi";
					# ($SubDebug == 1) ? DebugOut("Records File: \"$temp\"") : 0;
					$RecordString = "";
						if (-f $temp)
						{
						%RecordData = main::ReadIntConfig($temp);
						# main::DebugOut("\$RecordData{f_id} = $RecordData{f_id}");
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


							if ($main::Form{subc} =~ m!\w!)
							{
							$main::Config{sdb}{Linked}{LinkedCommand} = $main::Form{subc};	
							} else {
								$main::Config{sdb}{Linked}{LinkedCommand} = $main::Form{c};	
								};
# Checking if Administrator has forced this view to be always list view...
if ($AdminOpt{div}{sp_alwayslistview} == 1) {$ViewOption{$TableName}{ViewType} = 2};

							if (($ViewOption{$TableName}{ViewType} == 2) || ($main::Form{details} == 1) )
							{
							
							$String .= "\n</table></DIV><DIV style=\"background:$main::Config{sdb}{opt}{div}{tb_background}; color:$main::Config{sdb}{opt}{div}{tb_textcolor}\"><center><table BORDER=\"$main::Config{sdb}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{sdb}{opt}{view}{tb_cpadding}\" CELLSPACING=\"$main::Config{sdb}{opt}{view}{tb_cspacing}\" style=\"width:$main::Config{sdb}{opt}{calculated}{view}{width}; font-family:$main::Config{sdb}{opt}{view}{tb_fontfamily}; font-size:$main::Config{sdb}{opt}{view}{tb_fontsize}pt; background:$main::Config{sdb}{opt}{view}{tb_background}; color:$main::Config{sdb}{opt}{view}{tb_color};\">";
							$RecordString .= "\n<tr><td></td><td style=\"color:#222;background:#222; font-size:1pt\">.</td><tr>";
							#
													for ($sc = 0; $sc < $totalfields; $sc++)
													{
													# We will display records based on record type here....
													$main::Config{sdb}{appdisplay}{hidetitles} = 1;	
														if ($main::Config{sdb}{appdisplay}{hidetitles} == 1)
														{
														$RecordString .= "\n<tr><td valign=\"top\" align=\"left\" style=\"width:1%\"></td>";
														} else {
															$RecordString .= "\n<tr><td valign=\"top\" align=\"left\" style=\"width:10%\"><b>$StructureTitle[$sc]</b></td>";
															};

													$RecordString .= "\n<td style=\"width:90%\">";
													# DebugOut("\$RecordData{\$StructureType[$sc] = $StructureType[$sc] : $StructureName[$sc]} = $RecordData{$StructureName[$sc]}");
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
														$MemoRecord =  substr($MemoRecord,0,65000);
														$MemoRecord = main::lib_sdbview_processmemo($MemoRecord);
														#$MemoRecord = main::lib_html_Escape($MemoRecord);
														$MemoRecord =~ s!\n!<br>!gis;
														$MemoRecord =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;
														$RecordString .= "$MemoRecord" . " <a href=\"$main::UserEnv{href}&memoview=$id"."."."$StructureName[$sc]"."&c=$main::Config{sdb}{Linked}{LinkedCommand}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\"></a>";
														} else {
															($SubDebug == 1) ? DebugOut("Memo file does not exist!") : 0;
															$MemoRecord = $RecordData{$StructureName[$sc]};
															$MemoRecord = main::lib_sdbview_processmemo($MemoRecord);
															#$MemoRecord =~ s!&!&apm;!gis;
															#$MemoRecord =~ s!<!&gt;!gis;
															#$MemoRecord =~ s!>!&lt;!gis;
															$MemoRecord =~ s!\n!<br>!gis;
															$MemoRecord =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;								
															$RecordString .= "$MemoRecord" . " <a href=\"$main::UserEnv{href}&memoview=$id"."."."$StructureName[$sc]"."&c=$main::Config{sdb}{Linked}{LinkedCommand}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\"></a>";	
															};
														} elsif ($StructureType[$sc] eq "bin")
														{
														$RecordString .= " <a href=\"$main::UserEnv{href}&binview=$id"."."."$StructureName[$sc]"."&c=$main::Config{sdb}{Linked}{LinkedCommand}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\">$RecordData{$StructureName[$sc]}</a>";	
														} 
														elsif ($StructureType[$sc] eq "image")
														{
														
														if ($RecordData{$StructureName[$sc]} =~ m!(.*)(\.\w\w\w)!)
														{
														$ImageTempPath = $main::Config{sdbconfig}{imagetempfolder} . "$id". $2;
														$ImageTempWebPath = $main::Config{sdbconfig}{imagetempwebfolder} . "$id". $2;
														$ImageFile = $ImagePath . $id . "." . $StructureName[$sc];
														main::CopyFile($ImageFile,$ImageTempPath,1);
														if (-e $ImageTempPath)
														{
														$RecordString .=  main::lib_sdbview_imagethumbnail($ImageTempPath,$ImageTempWebPath,$RecordData{$StructureName[$sc]});
														#$RecordString .= " <a href=\"$main::UserEnv{href}&imageview=$id"."."."$StructureName[$sc]"."&c=$main::Config{sdb}{Linked}{LinkedCommand}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\"><img src=\"$ImageTempWebPath\" border=\"0\"></a>";	
														} else {
															$RecordString .= " <a href=\"$main::UserEnv{href}&imageview=$id"."."."$StructureName[$sc]"."&c=$main::Config{sdb}{Linked}{LinkedCommand}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\">View (Could not copy image for preview)</a>";		
															};
														
														} else {
															$ImageTempPath = undef;
															$ImageTempWebPath = undef;
															$RecordString .= " <a href=\"$main::UserEnv{href}&imageview=$id"."."."$StructureName[$sc]"."&c=$main::Config{sdb}{Linked}{LinkedCommand}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\">View (Could not identify image)</a>";		
															};
														
														} elsif ($StructureType[$sc] =~ m!^Link(.*)!i)
														{
	$temp = $1;
        if ($temp =~ m!(.*)\.(.*)!) 
        {
        $main::Config{sdb}{Linked}{DatabaseFile} = $main::Config{sdb}{dbmain}{$1};
        $main::Config{sdb}{Linked}{LinkedTable} = $1;
        $main::Config{sdb}{Linked}{DisplayField} = $2;
         $main::Config{sdb}{Linked}{SubCommand} = "sdb".$1."view";
        } else {
            $main::Config{sdb}{Linked}{DatabaseFile} = $main::Config{sdb}{dbmain}{$temp};
            $main::Config{sdb}{Linked}{LinkedTable} = $temp;
            $main::Config{sdb}{Linked}{DisplayField} = "f_id";
            $main::Config{sdb}{Linked}{SubCommand} = "sdb".$1."view";
            };							
           								
	($SubDebug == 1) ? DebugOut("\$main::Config{sdb}{Linked}{DatabaseFile} = $main::Config{sdb}{Linked}{DatabaseFile}") : 0;    
	($SubDebug == 1) ? DebugOut("\$main::Config{sdb}{Linked}{LinkedTable} = $main::Config{sdb}{Linked}{LinkedTable}") : 0;    
	($SubDebug == 1) ? DebugOut("\$main::Config{sdb}{Linked}{DisplayField} = $main::Config{sdb}{Linked}{DisplayField}") : 0;    
	($SubDebug == 1) ? DebugOut("\$main::Config{sdb}{Linked}{SubCommand} = $main::Config{sdb}{Linked}{SubCommand}") : 0;    
		
	
															$temp = $RecordData{$StructureName[$sc]};
															$temp =~ s#!\[\(.*\)\]!##gsi;
															$temp = substr($temp,0,254);
															$temp .= "<a href=\"$main::UserEnv{href}&subc=$main::Config{sdb}{Linked}{SubCommand}&selectview=$id"."."."$StructureName[$sc]"."&c=$main::Form{c}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\">. . .</a>";
															
														$RecordString .=  "$temp";
														
														} elsif ($StructureType[$sc] eq "timestamp")
														{
														$RecordString .= scalar localtime($RecordData{$StructureName[$sc]});	
														} else {
															$RecordString .= main::lib_html_Escape("$RecordData{$StructureName[$sc]}");
															};
													
													} else {
														$RecordString .= "&nbsp";
														};
							
							
													$RecordString .= "</td></tr>";
													 if (defined $RecordData{$StructureName[$sc]}) {$DisplayTrigger = 1};
													};
								
							} else {
									for ($sc = 0; $sc < $totalfields; $sc++)
									{
									# We will display records based on record type here....
									$RecordString .= "\n<td valign=\"top\" align=\"left\" style=\"width:$main::Config{sdb}{opt}{$StructureID}{$StructureName[$sc]}{width}\">";
									#$RecordString .= "\n<td>";
									#($SubDebug == 1) ? DebugOut("STYLE: width:\$main::Config{sdb}{opt}{$StructureID}{$StructureName[$sc]}{width} = width:$main::Config{sdb}{opt}{$StructureID}{$StructureName[$sc]}{width}") : 0;
									
									if ($RecordData{$StructureName[$sc]} =~ m!.!)
									{
										if ($StructureType[$sc] eq "memo")
										{
										#$MemoRecord = main::lib_html_Escape($RecordData{$StructureName[$sc]});
										$MemoRecord = $RecordData{$StructureName[$sc]};
										# $MemoRecord =~ s!&!&amp;!gis;
										$MemoRecord =~ s!\[--!!gis;
										$MemoRecord =~ s!--\]!!gis;
										$MemoRecord =~ s!<!&gt;!gis;
										$MemoRecord =~ s!>!&lt;!gis;
										$MemoRecord =~ s!\n!<br>!gis;
										$MemoRecord =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;								
										$RecordString .= "$MemoRecord" . " <a href=\"$main::UserEnv{href}&memoview=$id"."."."$StructureName[$sc]"."&c=$main::Config{sdb}{Linked}{LinkedCommand}&selectview=$main::Form{selectview}\" target=\"_self\">...</a>";
										} elsif ($StructureType[$sc] eq "bin")
										{
										$RecordString .= " <a href=\"$main::UserEnv{href}&binview=$id"."."."$StructureName[$sc]"."&c=$main::Config{sdb}{Linked}{LinkedCommand}&selectview=$main::Form{selectview}\" target=\"_self\">$RecordData{$StructureName[$sc]}</a>";	
										} 
										elsif ($StructureType[$sc] eq "image")
										{
										$RecordString .= " <a href=\"$main::UserEnv{href}&imageview=$id"."."."$StructureName[$sc]"."&c=$main::Config{sdb}{Linked}{LinkedCommand}&selectview=$main::Form{selectview}\" target=\"_self\">View</a>";	
										}
										elsif ($StructureType[$sc] =~ m!^Link(.*)!i)
										{

	$temp = $1;
        if ($temp =~ m!(.*)\.(.*)!) 
        {
        $main::Config{sdb}{Linked}{DatabaseFile} = $main::Config{sdb}{dbmain}{$1};
        $main::Config{sdb}{Linked}{LinkedTable} = $1;
        $main::Config{sdb}{Linked}{DisplayField} = $2;
         $main::Config{sdb}{Linked}{SubCommand} = "sdb".$1."view";
        } else {
            $main::Config{sdb}{Linked}{DatabaseFile} = $main::Config{sdb}{dbmain}{$temp};
            $main::Config{sdb}{Linked}{LinkedTable} = $temp;
            $main::Config{sdb}{Linked}{DisplayField} = "f_id";
            $main::Config{sdb}{Linked}{SubCommand} = "sdb".$1."view";
            };							
           								
	($SubDebug == 1) ? DebugOut("\$main::Config{sdb}{Linked}{DatabaseFile} = $main::Config{sdb}{Linked}{DatabaseFile}") : 0;    
	($SubDebug == 1) ? DebugOut("\$main::Config{sdb}{Linked}{LinkedTable} = $main::Config{sdb}{Linked}{LinkedTable}") : 0;    
	($SubDebug == 1) ? DebugOut("\$main::Config{sdb}{Linked}{DisplayField} = $main::Config{sdb}{Linked}{DisplayField}") : 0;    
	($SubDebug == 1) ? DebugOut("\$main::Config{sdb}{Linked}{SubCommand} = $main::Config{sdb}{Linked}{SubCommand}") : 0;    

											$temp = $RecordData{$StructureName[$sc]};
											$temp =~ s#!\[\(.*\)\]!##gsi;
											$temp = substr($temp,0,254);
											$temp =~ s!,(\w)!, $1!gi;
											$temp .= "<a href=\"$main::UserEnv{href}&subc=$main::Config{sdb}{Linked}{SubCommand}&selectview=$id"."."."$StructureName[$sc]"."&c=$main::Config{sdb}{Linked}{LinkedCommand}\" target=\"_self\">. . .</a>";
											
										$RecordString .= "$temp";
										
										} elsif ($StructureType[$sc] eq "timestamp")
										{
										$RecordString .= scalar localtime($RecordData{$StructureName[$sc]});	
										} else {
											$RecordString .= "$RecordData{$StructureName[$sc]}";		
											};
									
									} else {
										$RecordString .= "&nbsp";
										};
			
			
									$RecordString .= "</td>";
									 if (defined $RecordData{$StructureName[$sc]}) {$DisplayTrigger = 1};
									};
				
				};
			###############################################################################################################
						} else {
							($SubDebug == 1) ? DebugOut("ERROR: record does not exist! \"$temp\"") : 0;
							};
					$RecordString .= "\n</tr>";
						# ($SubDebug == 1) ? DebugOut("Checking if \$AdministratorMode = \"$AdministratorMode\"") : 0;
						my($AdminString) = undef;
							if ($AdministratorMode == 1)
							{
								if ($main::Config{sdb}{tableownerlock} == 1) 
								{
									if (($RecordData{"f_owner"} eq "$main::UserEnv{name}") || ($main::UserEnv{group} =~ m!administrators!))
									{
									$AdminString = "\n<td style=\"width:30\"><input type=\"CHECKBOX\" name=\"DELETE"."$id\" value=\"$id\"\"> <a href=\"$main::UserEnv{href}&c=$AdminCommand&act=edit&Mode=Modify&Modify=1&indexid=$id&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\"> ! </a></td>";
									$String .= "\n<tr>" . $AdminString . $RecordString;
									} else {
										$AdminString = "\n<td style=\"width:30\"> x </a></td>";
										$String .= "\n<tr>" . $AdminString . $RecordString;
										};
								} else {
									$AdminString = "\n<td style=\"width:30\"><input type=\"CHECKBOX\" name=\"DELETE"."$id\" value=\"$id\"\"> <a href=\"$main::UserEnv{href}&c=$AdminCommand&act=edit&Mode=Modify&Modify=1&indexid=$id&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\"> ! </a></td>";
									$String .= "\n<tr>" . $AdminString . $RecordString;									
									};
							} else {
								#$AdminString = "\n<td style=\"width:10\"><a href=\"$main::UserEnv{href}&c=$main::Form{c}&detaileddisplay=$id&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\"> * </a></td>";
	unless ($main::Form{subc} =~ m!\w!)
	{
	$AdminString = "\n<td style=\"width:10\"><a href=\"#\" onClick=\"popup(\'$main::UserEnv{href}&c=$main::Form{c}&detaileddisplay=$id&ViewType=$ViewOption{$TableName}{ViewType}&details=1\', \'$id\', ".(screen.width - 50).", ".(screen.height - 100)."); return false\"> * </a>";	
	} else {
		$AdminString = "\n<td style=\"width:10\">";		
		};

								
								$String .= "\n<tr>" . $AdminString . $RecordString;

								};
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
	unless ($AdminOpt{div}{sp_disablenavigation} == 1) 
	{
	$QJString = "\n<table border=\"$main::Config{sdb}{opt}{navbar}{tb_border}\" cellpadding=\"$main::Config{sdb}{opt}{navbar}{tb_cpadding}\" cellspacing=\"$main::Config{sdb}{opt}{navbar}{tb_cspacing}\" style=\"width:$main::Config{sdb}{opt}{navbar}{tb_width}; font-family:$main::Config{sdb}{opt}{navbar}{tb_fontfamily}; font-size:$main::Config{sdb}{opt}{navbar}{tb_fontsize}pt; background:$main::Config{sdb}{opt}{navbar}{tb_background};\">";
	$QJString .= "<tr>";
	$QJString .= "<td align=\"center\" style=\"width:100\">";
	$QJString .= " [ <a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=0&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\"> &lt&lt </a> ";
	$QJString .= " <a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=".($ViewOption{$TableName}{DisplayPoint} - $ViewOption{$TableName}{DisplayLength})."&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\"> &lt </a> ";
	$QJString .= " <a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=".($ViewOption{$TableName}{DisplayPoint} + $ViewOption{$TableName}{DisplayLength})."&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\"> &gt </a> ";
	$QJString .= " <a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=".($IndexCnt - $ViewOption{$TableName}{DisplayLength})."&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\"> &gt&gt </a> ";
	$QJString .= " ] </td>";
		unless ($AdminOpt{div}{sp_disableprint} == 1) 
		{
		$QJString .= "<td>";
		$QJString .= main::lib_html_printpagebutton();
		$QJString .= "</td>";	
		};
	
	$QJString .= "<td align=\"center\" style=\"width:100\">";
	if ($ViewOption{$TableName}{DisplayPoint} <  1) {$temp = 1} else {$temp = $ViewOption{$TableName}{DisplayPoint}};
	$QJString .= " $temp - ".($ViewOption{$TableName}{DisplayPoint} + $ViewOption{$TableName}{DisplayLength})." of $IndexCnt ";
	$QJString .= "</td>";
		if ($main::Form{SearchBrowse} == 1)
		{
		$QJString .= "<td align=\"center\" style=\"width:100\">";
		$QJString .= " <a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=0&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=0&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\"> All Records </a> ";	
		$QJString .= "</td>";
		};
	
	$QJString .= "<td align=\"center\" style=\"width:500\"> [ ";
	($SubDebug == 1) ? DebugOut("QuickJump Count = \"$QJCnt\"") : 0;
		for ($i = 0; $i <= $QJCnt; $i++)
		{
		($SubDebug == 1) ? DebugOut("\$QuickJumpID[$i] = $QuickJumpID[$i]") : 0;
		$QJString .= "<a href=\"$main::UserEnv{href}&c=$main::Form{c}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&IndexBy=$ViewOption{$TableName}{IndexBy}&DisplayPoint=$QuickJumpPT[$i]&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\">$QuickJumpID[$i] </a>";
		};
	$QJString .= " ] </td>";	
	
		unless ($AdminOpt{div}{sp_disablepreferences} == 1) 
		{
			unless ($main::UserEnv{name} =~ m!^guest!i)
			{
			$QJString .= "<td align=\"center\" style=\"width:150\">";
			$QJString .= " [<a href=\"$main::UserEnv{href}&c=sdbconfig&structure=$StructureID&ViewType=$main::Form{ViewType}&parentcommand=$main::Form{c}\" target=\"_self\">Preferences</a>] ";
			$QJString .= "</td>";
			};	
		};
	
	$QJString .= "<td align=\"center\" style=\"width:100\">";
	
		unless ($AdminOpt{div}{sp_alwayslistview} == 1) 
		{
			if ($main::Form{ViewType} == 2)
			{
			$QJString .= " [<a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=0&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=1\" target=\"_self\">Table View</a>] ";	
			} else {
			$QJString .= " [<a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=0&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=2\" target=\"_self\">List View</a>] ";	
				};
		};
	$QJString .= "</td>";
	
	
		if ($main::UserEnv{name} =~ m!^administrator!i)
		{
		$QJString .= "<td align=\"center\" style=\"width:300\">";
		$QJString .= " [<a href=\"$main::UserEnv{href}&c=sdbimport&tablename=$StructureID\" target=\"_self\">Import</a>]";
		$QJString .= "|[<a href=\"$main::UserEnv{href}&c=sdbexport&tablename=$StructureID\" target=\"_self\">Export</a>]";
		$QJString .= "|[<a href=\"$main::UserEnv{href}&c=sdbadminconfig&structure=$StructureID&parentcommand=$main::Form{c}\" target=\"_self\">Admin_Options</a>]";
		$QJString .= "</td>";
		};
	
		unless ($AdminOpt{div}{sp_disablerecordsnumberchange} == 1) 
		{
		$QJString .= "<td align=\"center\" style=\"width:100\">";
		$QJString .= " [(<a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=$ViewOption{$TableName}{DisplayPoint}&DisplayLength=".($ViewOption{$TableName}{DisplayLength} - 10)."&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\">-10</a>)";
		$QJString .= " (<a href=\"$main::UserEnv{href}&c=$main::Form{c}&DisplayPoint=$ViewOption{$TableName}{DisplayPoint}&DisplayLength=".($ViewOption{$TableName}{DisplayLength} + 10)."&IndexBy=$ViewOption{$TableName}{IndexBy}&IndexReverse=$ViewOption{$TableName}{IndexReverse}&SearchBrowse=$main::Form{SearchBrowse}&selectview=$main::Form{selectview}&ViewType=$ViewOption{$TableName}{ViewType}\" target=\"_self\">+10</a>)]";
		$QJString .= "</td>";
		};
	
	$QJString .= "</tr>";	
	$QJString .= "</table>";		
	};

$String .= "</DIV>";

	unless ($main::Form{details} == 1)
	{
	$String = $SearchForm{String} . $QJString . $String . $QJString;	
	} else {
		$String = main::lib_html_printpagebutton() . $String;
		};


	if ($AdministratorMode == 1)
	{
	$String .= qq(
	<center><input type="hidden" name="IndexReverse" value="$ViewOption{$TableName}{IndexReverse}">
	<input type="hidden" name="IndexBy" value="$ViewOption{$TableName}{IndexBy}">
	<input type="hidden" name="DisplayPoint" value="$ViewOption{$TableName}{DisplayPoint}">
	<input type="hidden" name="SearchBrowse" value="$main::Form{SearchBrowse}">
	<input type="hidden" name="selectview" value="$main::Form{selectview}">
	<input type="hidden" name="ViewType" value="$ViewOption{$TableName}{ViewType}">
	<input type="hidden" name="parentcommand" value="$main::Form{parentcommand}">
	</center>
	<input type="submit" name="Mode" value="Add Records">
	<input type="submit" name="Delete" value="Delete Selected">
		     );

	$String = qq(
		<input type="submit" name="Mode" value="Add Records">
		<input type="submit" name="Delete" value="Delete Selected">
		) . $String;
	};
# Saving User preferences back to options file...
my($PopupString) = undef;
$PopupString .= "<script Language=\"JavaScript\"><!--\nfunction popup(url, name, width, height)\{\nsettings=\n";
$PopupString .= "\"toolbar=no,location=no,directories=no,\"+\n";
$PopupString .= "\"status=no,menubar=no,scrollbars=yes,\"+\n";
$PopupString .= "\"resizable=yes,width=\"+(screen.width-10)+\",height=\"+(screen.height-200)+\",top=50,left=0\";";
$PopupString .= "\nMyNewWindow=window.open(url,name,settings);";
$PopupString .= "\n";
$PopupString .= "\n}\n//-->\n</script>";
$PopupString .= "";
$PopupString .= "";
$PopupString .= "";
#"resizable=yes,width="+800+",height="+600;
$String = $PopupString . $String;
($SubDebug == 1) ? DebugOut("Updated User View configuration file \"$main::Config{sdb}{udb}{config}\"") : 0;
main::WriteIntConfig("config",\%ViewOption,$main::Config{sdb}{udb}{config});
return $String;
};
my($LegendString) = undef;
$LegendString = qq(
<div>
Legend: <br>
* - see more details on the record in a list view

</div>
);

sub main::lib_sdbview_periodform
{
my($String) = undef;
my($i) = undef;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = undef;
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
	$year = $year + 1900;
	$mon++;	($mon < 10) ? $mon = "0"."$mon" : $mon = $mon;
	($mday < 10) ? $mday = "0"."$mday" : $mday = $mday;

my($YearStringFrom) = undef;
my($MonthStringFrom) = undef;
my($DateStringFrom) = undef;
my($YearStringTill) = undef;
my($MonthStringTill) = undef;
my($DateStringTill) = undef;
my($temp) = undef;


$YearStringFrom .= "\n<select name=\"yearfrom\"/>";		
$YearStringTill .= "\n<select name=\"yeartill\"/>";
my($ValueData) = $year;

	for ($i = ($year - 8); $i < ($year + 8); $i++)
	{
		if ($ValueData == $i)
		{
		$YearStringFrom .= "\n<option value=\"$i\" selected>$i</option>";
		$YearStringTill .= "\n<option value=\"$i\" selected>$i</option>";
		} else {
			$YearStringFrom .= "\n<option value=\"$i\">$i</option>";
			$YearStringTill .= "\n<option value=\"$i\">$i</option>";
			};
	};
$YearStringFrom .= "\n</select/>";
$YearStringTill .= "\n</select/>";

$MonthStringFrom .= "\n<select name=\"monthfrom\"/>";		
$MonthStringTill .= "\n<select name=\"monthtill\"/>";
$ValueData = $mon;
	for ($i = 1; $i < 13; $i++)
	{
		if ($ValueData == $i)
		{
		if ($i < 10) {$temp = "0"."$i"} else {$temp = $i};
		$MonthStringFrom .= "\n<option value=\"$temp\" selected>$temp</option>";
		$MonthStringTill .= "\n<option value=\"$temp\" selected>$temp</option>";
		} else {
			if ($i < 10) {$temp = "0"."$i"} else {$temp = $i};
			$MonthStringFrom .= "\n<option value=\"$temp\">$temp</option>";			
			$MonthStringTill .= "\n<option value=\"$temp\">$temp</option>";			
			};
	};
$MonthStringFrom .= "\n</select/>";
$MonthStringTill .= "\n</select/>";	

$DateStringFrom .= "\n<select name=\"datefrom\"/>";		
$DateStringTill .= "\n<select name=\"datetill\"/>";
$ValueData = $mday;	
	for ($i = 1; $i < 32; $i++)
	{
		if ($ValueData == $i)
		{
		if ($i < 10) {$temp = "0"."$i"} else {$temp = $i};
		$DateStringFrom .= "\n<option value=\"$temp\" selected>$temp</option>";
		$DateStringTill .= "\n<option value=\"$temp\" selected>$temp</option>";
		} else {
			if ($i < 10) {$temp = "0"."$i"} else {$temp = $i};
			$DateStringFrom .= "\n<option value=\"$temp\">$temp</option>";			
			$DateStringTill .= "\n<option value=\"$temp\">$temp</option>";			
			};
	};
$DateStringFrom .= "\n</select/>";
$DateStringTill .= "\n</select/>";	

$String = "<b> Restrict: </b> $YearStringFrom $MonthStringFrom $DateStringFrom &nbsp;&nbsp; - &nbsp;&nbsp; $YearStringTill $MonthStringTill $DateStringTill ";	
$String .= " On: <input type=\"checkbox\" name=\"usetimestamp\" value=\"1\">";	
return $String;
};


sub main::lib_sdbview_imagethumbnail
{
use Image::Size;
my($ImagePath) = $_[0];
my($ImageWebPath) = $_[1];
my($ImageAltName) = $_[2];

my($Size_x) = undef;
my($Size_y) = undef;
my($ASize_x) = undef;
my($ASize_y) = undef;
my($Max_x) = 150;
my($Max_y) = 90;
my($Shrink_x) = undef;
my($Shrink_y) = undef;
my($ShrinkBy) = undef;
my($String) = undef;
	if (-e $ImagePath)
	{
			($ASize_x,$ASize_y) = imgsize("$ImagePath");
			$Size_x = $ASize_x; $Size_y = $ASize_y;
			$ShrinkBy = undef;
			$Shrink_x = undef;
			$Shrink_y = undef;

			unless ($main::Form{details} == 1)
			{
			if ($Size_x > $Max_x) {$Shrink_x = $Size_x / $Max_x};
			if ($Size_y > $Max_y) {$Shrink_y = $Size_y / $Max_y};
			if ($Shrink_x > $Shrink_y) {$ShrinkBy = $Shrink_x} else {$ShrinkBy = $Shrink_y};
			if ($ShrinkBy > 0) {$Size_x = $Size_x / $ShrinkBy; $Size_y = $Size_y / $ShrinkBy;};	
			};

$String = 
"<a href=\"#".""."\" onClick=\"window.open(\'".
($ImageWebPath).
"\', \'loadwindow\', '\height=".($ASize_y + 20).",width=".($ASize_x + 20).",left=10,top=10,toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,directories=no,status=no\');\">".
"<img src=\"$ImageWebPath\" height=\"$Size_y\" width=\"$Size_x\" border=\"0\" target=\"_blank\"><font size=\"1\"></font></a>";
	
	};
# ($ASize_x x $ASize_y)	
return $String;	
};

sub main::lib_sdbview_processmemo
{
my ($String) = $_[0];
my ($result) = undef;
my (@stringparts) = split( /(\[--|--\])/, $String);
my ($inside) = 0;
my ($temp) = undef;

foreach $temp (@stringparts) 
	{
    	if( $temp eq '[--' ) { $inside = 1 ; next; }
    	if( $temp eq '--]' ) { $inside = 0 ; next; }
    	if ($inside)
   	{
   	$result .= $temp;
	} else {
		$result .= main::lib_html_Escape($temp);
		};
    	};
return $result;
};

1;