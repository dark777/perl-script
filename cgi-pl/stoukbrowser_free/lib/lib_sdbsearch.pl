sub main::lib_sdbsearch_searchindexgenerate
{
my($DatabaseFile) = $_[0];
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Searching data....") : 0;
my(%Search) = undef;
$main::Config{sdb}{SearchResultDatabaseFile} = $main::Config{sdb}{uroot} . "searchresult". ".cgi";
if (-f $main::Config{sdb}{SearchResultDatabaseFile}) {unlink($main::Config{sdb}{SearchResultDatabaseFile})};
my(@IndexData) = undef;
my($idc) = undef;
my($Confirmed) = undef;
my($SearchFields) = undef;
$main::Config{sdb}{SearchResult} = 0;
$main::Config{sdb}{SearchStartTime} = time;
my($key) = undef;
my($skey) = undef;
my($temp) = undef;
my($StructureFile) = $_[1];
my(%Structure) = undef;
my($TimeIsHere) = undef;

			if (-f $StructureFile)
			{
			%Structure = main::ReadIntConfig($StructureFile);
			
					foreach $key (keys %Structure)
					{

						if (defined $Structure{$key}{type})
						{

							if ($Structure{$key}{type} eq "timestamp")
							{
							$TimeIsHere = "$Structure{$key}{name}";
							};
						};					
					};		
			};

$main::Config{sdb}{searchfrom} = undef;
$main::Config{sdb}{searchtill} = undef;

$main::Config{sdb}{searchstring} = "<font size=\"1\" face=\"verdana,sans-serif,arial\">Searched for:";

	if ((defined $TimeIsHere) && ($main::Form{usetimestamp} eq "1") )
	{
	use Time::Local; 		
	$main::Form{monthfrom}--;
	$main::Form{monthtill}--;
	$main::Config{sdb}{searchfrom} = timelocal(0,0,0,$main::Form{datefrom},$main::Form{monthfrom},$main::Form{yearfrom}); 
	$main::Config{sdb}{searchtill} = timelocal(59,59,23,$main::Form{datetill},$main::Form{monthtill},$main::Form{yeartill}); 
	$main::Config{sdb}{searchf} = scalar localtime($main::Config{sdb}{searchfrom});
	$main::Config{sdb}{searcht} = scalar localtime($main::Config{sdb}{searchtill});
	($SubDebug == 1) ? DebugOut("TimeStamp from:  $main::Config{sdb}{searchfrom} till: $main::Config{sdb}{searchtill}") : 0;
	($SubDebug == 1) ? DebugOut("TimeStamp from:  $main::Config{sdb}{searchf} till: $main::Config{sdb}{searcht}") : 0;
	$main::Config{sdb}{searchstringtime} = " ( <b><font size=\"1\" face=\"verdana,sans-serif,arial\"> $main::Config{sdb}{searchf} - $main::Config{sdb}{searcht} </b></font> ) ";
	} else {
		undef $TimeIsHere;
		};					

if (length($main::Form{searchfield1}) > 1)
{
	if (defined $main::Form{searchdata1})
	{
	$Search{$main::Form{searchfield1}}{pattern} = $main::Form{searchdata1};
	$main::Config{sdb}{searchstring} .= "<b> ". main::lib_html_Escape($main::Form{searchdata1}) ."</b>";	
	};
};

if (length($main::Form{searchfield2}) > 1)
{
	if (defined $main::Form{searchdata2})
	{
	$Search{$main::Form{searchfield2}}{pattern} = $main::Form{searchdata2};
	$main::Config{sdb}{searchstring} .= " and <b> ". main::lib_html_Escape($main::Form{searchdata2}) ."</b>";	
	};
};

if (length($main::Form{searchfield3}) > 1)
{
	if (defined $main::Form{searchdata3})
	{
	$Search{$main::Form{searchfield3}}{pattern} = $main::Form{searchdata3};
	$main::Config{sdb}{searchstring} .= " and <b> ". main::lib_html_Escape($main::Form{searchdata3}) ."</b>";	
	};
};


				foreach $skey (keys %Search)
				{
					if (defined $Search{$skey}{pattern})
					{
						if ($main::Config{sdb}{precise} == 1)
						{
						$Search{$skey}{pattern} =~ s!\*!\\\*!gi;
						$Search{$skey}{pattern} =~ s!\.!\\\.!gi;
						};
						$SearchFields++;
					};
				};

($SubDebug == 1) ? DebugOut("Total Search Fields : $SearchFields") : 0;				
	if (-f $DatabaseFile)
	{
	%Data = main::ReadIntConfig($DatabaseFile);	
	($SubDebug == 1) ? DebugOut("Database File Exists.. continue Searching...") : 0;
		foreach $key (keys %Data)
		{
		$Confirmed = undef;
		
			if (defined $key)
			{
				foreach $skey (keys %Search)
				{
					if (defined $Search{$skey}{pattern})
					{
					($SubDebug == 1) ? DebugOut("Checking Pattern: \"$Search{$skey}{pattern}\" within data: \"$Data{$key}{$skey}\"") : 0;
						if ($Data{$key}{$skey} =~ m!$Search{$skey}{pattern}!i)
						{
						$Confirmed++;	
						($SubDebug == 1) ? DebugOut("FOUND and CONFIRMED! \$Confirmed = $Confirmed") : 0;
						};
					};
				};

				($SubDebug == 1) ? DebugOut("Checking if  \$Confirmed = $Confirmed  >= $SearchFields") : 0;
				if ($Confirmed >= $SearchFields) 
				{
				$main::Config{sdb}{SearchResultData}{$key} = $Data{$key};
				$main::Config{sdb}{SearchResult}++;
				} else {
					($SubDebug == 1) ? DebugOut("No Records Found!") : 0;
					};
			
				if ($main::Config{sdb}{SearchResult} > 0)
				{
				main::WriteIntConfig("config",$main::Config{sdb}{SearchResultData},$main::Config{sdb}{SearchResultDatabaseFile});
				};
			};
		
		};
	$main::Config{sdb}{SearchFinishTime} = time;	
	$main::Config{sdb}{SearchTime} = $main::Config{sdb}{SearchFinishTime} - $main::Config{sdb}{SearchStartTime};	
	if ($main::Config{sdb}{SearchTime} == 0) {$main::Config{sdb}{SearchTime} = "0"};
	
	} else {
		($SubDebug == 1) ? DebugOut("ERROR: Database file does not exist!") : 0;
		};




};
1;