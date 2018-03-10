# Custom Application Library

sub main::lib_customlib_displayplatters
{
my($SubDebug) = $main::SubID{lib_customlib_displayplatters}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	if (($main::Config{DSN}) && ($main::Config{DBUser}))
	{
		main::DatabaseConnect(); 
		main::GetTableData("*","Platters");
		if (($main::Form{mpf1}) || ($main::Form{mpf3}) || ($main::Form{mpf6}) )
		{
		main::lib_customlib_processlatters();	
		main::GetTableData("*","Platters");
		};
	
	
	
		my($FormString) = undef;
		$FormString .=
		qq(
		<b>$main::Html{ServiceText}</b><br>
		<form action="$main::Config{ScriptWebPath}" method="POST">
		Please cpecify platters which were marked as full:<br>
		AC1: <input type="text" name="mpf1" value="$main::Form{mfp1}"/> Example: AC1-0001A<br>
		AC3: <input type="text" name="mpf3" value="$main::Form{mfp3}"/> Example: AC3-0001A<br>
		AC6: <input type="text" name="mpf6" value="$main::Form{mfp6}"/> Example: AC6-0001A<br>
		<input type="hidden" name="a" value="custom"/>
		<input type="hidden" name="c" value="platterform"/>
		<input type="hidden" name="do" value="displayform"/>
		$main::UserEnv{userid}
		<input type="submit" name="submit" value="Submit"/>
		</form>
		<hr>
		);
		$main::Html{BodyJavaScript} .= $FormString;
		$main::Html{BodyJavaScript} .= main::lib_dbgen_DisplayDBData();


	} else {
		$main::Html{BodyJavaScript} .= "No Database Source Name and/or  User name Specified!";
		};

};

sub main::lib_customlib_processlatters
{
my($SubDebug) = $main::SubID{lib_customlib_processlatters}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
main::lib_dbgenb_indexdata(0,5);
my(%PlatterIDs) = undef;


	if ($main::Form{mpf1} =~ m!^AC1-\d\d\d\d[AB]$!i)
	{
	if (defined $main::DbIndex{uc($main::Form{mpf1})}) 
	{
	($SubDebug == 1) ? DebugOut("OK Confirm Existing platter: \"$main::Form{mpf1}\"") : 0;
	} else {
		($SubDebug == 1) ? DebugOut("FAILED to Confirm Existing platter: \"$main::Form{mpf1}\"") : 0;
		$main::Html{ServiceText} .= "No Such Platter Name found (AC1): \"$main::Form{mpf1}\"<br>";
		undef $main::Form{mpf1};
		};

	unless ($main::DbIndex{uc($main::Form{mpf1})} > 0)
	{
	main::lib_custom_markplatterfull(uc($main::Form{mpf1}));
	} else {
		($SubDebug == 1) ? DebugOut("FAILED ... Attempt to Mark already marked platter.") : 0;
		$main::Html{ServiceText} .= "<font color=\"red\"> ERROR: Platter \"$main::Form{mpf1}\" is ALREADY marked as FULL! <br>If you feel this is in error, please contact GT WBO-MBOAS Support.<br></font>";
		};
	
	} else {
			if (length($main::Form{mpf1}) > 0)
			{
			($SubDebug == 1) ? DebugOut("mpf1 Was not specified: \"$main::Form{mpf1}\"") : 0;
			$main::Html{ServiceText} .= "Wrong Platter Name Specified... check syntax (AC1): \"$main::Form{mpf1}\"<br>";
			undef $main::Form{mpf1};
			};
		};

	if ($main::Form{mpf3} =~ m!^AC3-\d\d\d\d[AB]$!i)
	{
	if (defined $main::DbIndex{uc($main::Form{mpf3})}) 
	{
	($SubDebug == 1) ? DebugOut("OK Confirm Existing platter: \"$main::Form{mpf3}\"") : 0;
	} else {
		($SubDebug == 1) ? DebugOut("FAILED to Confirm Existing platter: \"$main::Form{mpf3}\"") : 0;
		$main::Html{ServiceText} .= "No Such Platter Name found (AC3): \"$main::Form{mpf3}\"<br>";
		undef $main::Form{mpf3};
		};
	
	unless ($main::DbIndex{uc($main::Form{mpf3})} > 0)
	{
	main::lib_custom_markplatterfull(uc($main::Form{mpf3}));
	} else {
		($SubDebug == 1) ? DebugOut("FAILED ... Attempt to Mark already marked platter.") : 0;
		$main::Html{ServiceText} .= "<font color=\"red\"> ERROR: Platter \"$main::Form{mpf3}\" is ALREADY marked as FULL! <br>If you feel this is in error, please contact GT WBO-MBOAS Support.<br></font>";
		};


	} else {
			if (length($main::Form{mpf3}) > 0)
			{
			($SubDebug == 1) ? DebugOut("mpf3 Was not specified: \"$main::Form{mpf3}\"") : 0;
			$main::Html{ServiceText} .= "Wrong Platter Name Specified... check syntax (AC3): \"$main::Form{mpf3}\"<br>";
			undef $main::Form{mpf3};
			};
		};


	if ($main::Form{mpf6} =~ m!^AC6-\d\d\d\d[AB]$!i)
	{
	if (defined $main::DbIndex{uc($main::Form{mpf6})}) 
	{
	($SubDebug == 1) ? DebugOut("OK Confirm Existing platter: \"$main::Form{mpf6}\"") : 0;
	} else {
		($SubDebug == 1) ? DebugOut("FAILED to Confirm Existing platter: \"$main::Form{mpf6}\"") : 0;
		$main::Html{ServiceText} .= "No Such Platter Name found (AC6): \"$main::Form{mpf6}\"<br>";
		undef $main::Form{mpf6};
		};
		
	unless ($main::DbIndex{uc($main::Form{mpf6})} > 0)
	{
	main::lib_custom_markplatterfull(uc($main::Form{mpf6}));
	} else {
		($SubDebug == 1) ? DebugOut("FAILED ... Attempt to Mark already marked platter.") : 0;
		$main::Html{ServiceText} .= "<font color=\"red\"> ERROR: Platter \"$main::Form{mpf6}\" is ALREADY marked as FULL! <br>If you feel this is in error, please contact GT WBO-MBOAS Support.<br></font>";
		};


	} else {
			if (length($main::Form{mpf6}) > 0)
			{
			($SubDebug == 1) ? DebugOut("mpf6 Was not specified: \"$main::Form{mpf6}\"") : 0;
			$main::Html{ServiceText} .= "Wrong Platter Name Specified... check syntax (AC6): \"$main::Form{mpf6}\"<br>";
			undef $main::Form{mpf6};
			};
		};
};

sub main::lib_custom_markplatterfull
{
my($PlatterId) = $_[0];
my($SubDebug) = $main::SubID{MarkPlatterFull}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
$main::Html{ServiceText} .= "Marked Platter: \"$PlatterId\" as full - OK<br>";
if ($PlatterId =~ m!(AC\d-\d\d\d\d)(A)!i) {$main::Html{ServiceText} .= "<br>$main::Html{FS1}NOTE: You marked side \"A\" of Platter: $1 as full. <br>You also need to mark Side \"B\" of this platter as full, because both sides are on one physical platter. <br>Please Do it Now! $main::Html{FF}"};
my($Time) = time;
my($DateMark) = main::lib_time_gettime(9);
 		if ($PlatterId)
 		{
 		undef @temp1;
 		$sql = "UPDATE Platters SET full_m_d = '$DateMark' WHERE p_id = '$PlatterId'";
	 		if (main::DatabaseInsertRecord($sql)) 
	 		{
			$sql = "INSERT INTO PLog (log_id,p_id, name, action) VALUES ('$Time','$PlatterId','$main::UserEnv{name}','Marked As Full')";
			main::DatabaseInsertRecord($sql);
			$sql = "UPDATE Platters SET full_r = '$Time' WHERE p_id = '$PlatterId'";
			main::DatabaseInsertRecord($sql);
	 		} else {
	 			($SubDebug == 1) ? DebugOut("FAILED Execute: \"$sql\"") : 0; 			
	 			};
 		
 		} else {
	 		($SubDebug == 1) ? DebugOut("FAILED No Platter ID Specified: \"$PlatterID\"") : 0; 			 			
 			};

};

1;