# MS Access routines Library
sub main::ConnectDatabase
{
use DBI;
use DBD::ODBC;
my($SubDebug) = $main::SubID{ConnectDatabase}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... connecting to database: ACCESS") : 0;


$main::Config{DBConnected} = 1;
my($ConnectionString) = undef;

	if (length($main::Config{DSN}) > 0)
	{
	$ConnectionString = "dbi:ODBC:" . "$main::Config{DSN}";
	($SubDebug == 1) ? DebugOut("Database connection string: \"$ConnectionString\"") : 0;
	$main::Config{dbh} = DBI -> connect("dbi:ODBC:$main::Config{DSN}","","") || main::DBError();
	($SubDebug == 1) ? DebugOut("... connecting to database: ACCESS") : 0;
	} else {
			my($DbName) = $main::Config{DbFolder} . "app.mdb";
			unless (-e $DbName)
			{
			my($DbTemplate) = $main::Config{DbFolder} . "dbtemplate.mdb";
			($SubDebug == 1) ? DebugOut("Default database name: \"$DbName\"") : 0;
				if (-e $DbTemplate)
				{
				($SubDebug == 1) ? DebugOut("OK - Database file does not exist. Creating new.") : 0;
				main::CopyFile($DbTemplate,$DbName);
				$main::Config{DbJustCreated} = 1;
				} else {
					($SubDebug == 1) ? DebugOut("FAILED - Database file does not exist. Database Template does not exist either! \"$DbTemplate\"") : 0;
					};
			};
	
	
			if (-f $DbName)
			{
			$ConnectionString = "Driver={Microsoft Access Driver (*.mdb)}; dbq=".$DbName; 
			 ($SubDebug == 1) ? DebugOut("Database connection string: \"$ConnectionString\"") : 0;
		
			$main::Config{dbh} = DBI->connect("dbi:ODBC:$ConnectionString","","") or main::DBError();	
			} else {
				($SubDebug == 1) ? DebugOut("FAILED - Cannot connect - No database file! Database folder not writable? \"$main::Config{DbFolder}\"") : 0;	
				};
	
		};
	if ($main::Config{DBConnected})
	{
	main::ConfirmTableStructure();
	};

};

############## Creating Default database Structured required for program to run
sub main::ConfirmTableStructure
{
my($SubDebug) = $main::SubID{ConfirmTableStructure}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... confirming database structure") : 0;

	unless ($main::Config{DbJustCreated} == 1)
	{
	$main::Config{sql} = "SELECT f_created from tb_control;";		
	$main::Config{sth} = $main::Config{dbh}->prepare(qq($main::Config{sql})); 
	($SubDebug == 1) ? DebugOut("... executing: \"$main::Config{sql}\"") : 0;
	$main::Config{sth}-> execute || main::DBError();
	$main::Config{DbResult}{created} = $main::Config{sth} -> fetchrow_array || main::DBError();
	$main::Config{sth} -> finish;
	};
		unless ($main::Config{DbResult}{created} > 0)
		{
		$main::Config{sql} = "CREATE TABLE tb_control (f_created INTEGER, f_holddays INTEGER)"; 
		$main::Config{sth} = $main::Config{dbh} -> prepare($main::Config{sql}) || main::DBError();
		($SubDebug == 1) ? DebugOut("... executing: \"$main::Config{sql}\"") : 0;
		$main::Config{sth} -> execute;
		$main::Config{sth} -> finish;
		
            	$main::Config{sth} = $main::Config{dbh}->prepare( qq(insert into tb_control values ( ?,?)));
            	$main::Config{sth} ->execute(time,365) || main::DBError();
            	$main::Config{sth} -> finish;
            	
            	# Now let us confirm again
		$main::Config{sql} = "SELECT f_created from tb_control;";		
		$main::Config{sth} = $main::Config{dbh}->prepare(qq($main::Config{sql})); 
		($SubDebug == 1) ? DebugOut("... executing: \"$main::Config{sql}\"") : 0;
		$main::Config{sth}-> execute || main::DBError();
		$main::Config{DbResult}{created} = $main::Config{sth} -> fetchrow_array || main::DBError();  
		$main::Config{sth} -> finish;      
		
			if ($main::Config{DbResult}{created} > 0) 
			{
			($SubDebug == 1) ? DebugOut("OK - Successfully created Database Structure!") : 0;
			# Create Other Default Tables HERE!
			main::CreateDefaultDatabaseStructure();
			###################################
			} else {
				($SubDebug == 1) ? DebugOut("FAILED - could not confirm creating database structure.") : 0;	
				};
		} else {
			$main::Config{DBConnected} = 1;
			};	
};

sub main::CreateDefaultDatabaseStructure
{
		$main::Config{sql} = 
		"
		CREATE TABLE tb_stats 
		(
		f_rec TEXT(100) UNIQUE, 
		f_time INTEGER,
		f_year INTEGER,
		f_month INTEGER,
		f_date INTEGER,
		f_hour INTEGER,
		f_command TEXT(254) NULL,
		f_file TEXT(254) NULL,
		f_filesize INTEGER NULL,
		f_ref TEXT(254) NULL,
		f_keywords TEXT(254) NULL,
		f_user TEXT(254),
		f_ip TEXT(16)  NULL,
		f_screen TEXT(20) NULL,
		f_agent TEXT(100) NULL,
		f_os TEXT(100) NULL,
		f_sn TEXT(10) NULL,
		f_cookie TEXT(10) NULL
		)"; 
		$main::Config{sth} = $main::Config{dbh} -> prepare($main::Config{sql}) || main::DBError();
		($SubDebug == 1) ? DebugOut("... executing: \"$main::Config{sql}\"") : 0;
		$main::Config{sth} -> execute;
		$main::Config{sth} -> finish;

		$main::Config{sql} = 
		"
		CREATE TABLE tb_totals 
		(
		f_rec INTEGER UNIQUE, 
		f_year INTEGER NOT NULL,
		f_month INTEGER NOT NULL,
		f_date INTEGER NOT NULL,
		f_hour INTEGER NULL,
		f_commands TEXT(254) NULL,
		f_files TEXT(254) NULL,
		f_filesizes INTEGER NULL,
		f_refs TEXT(254) NULL,
		f_keywords TEXT(254) NULL,
		f_users TEXT(254),
		f_ips TEXT(16)  NULL,
		f_agents TEXT(100) NULL,
		f_oss TEXT(100) NULL,
		f_sn TEXT(10) NULL,
		f_cookie TEXT(100) NULL
		)"; 
		$main::Config{sth} = $main::Config{dbh} -> prepare($main::Config{sql}) || main::DBError();
		($SubDebug == 1) ? DebugOut("... executing: \"$main::Config{sql}\"") : 0;
		$main::Config{sth} -> execute;
		$main::Config{sth} -> finish;
};

sub main::AddStatsRecord
{
	if ($main::Config{DBConnected} == 1)
	{

	my($number) = int(rand(100)+1);
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = undef;
	my($Time) = time;
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($Time); 
	$mon++;
	$year = $year + 1900;
	# $number = ($year . $Time . $number);
	$number = ($year . $Time. $number);
        $main::Config{sth} = $main::Config{dbh} ->prepare( qq(insert into tb_stats values ( ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)));
        unless (defined $main::Stats{filesize}) {$main::Stats{filesize} = 0};
        $main::Config{sth} -> execute(
	        			$number,
	        			$Time,
	        			$year,
	        			$mon,
	        			$mday,
	        			$hour,
	        			"$main::Form{c}",
	        			"$main::Form{file}",
	        			$main::Stats{filesize},
	        			"$main::Stats{referrer}",
	        			"$main::Stats{keywords}",
	        			"$main::UserEnv{name}",
	        			"$main::Config{Env}{REMOTE_ADDR}",
	        			"$main::Stats{screen}",
	        			"$main::Stats{agent}",
	        			"$main::Stats{os}",
	        			"$main::Form{sn}",
	        			"$main::Html{CookieAnswer}{StoukWade}"
	        			);        	
        $main::Config{sth} -> finish;	
	};	
};

sub main::DisconnectDatabase
{
use DBI;
use DBD::ODBC;
unlink $main::Config{sth};
$main::Config{dbh}->disconnect;	
};

sub main::ExecuteSQL_Total
{
my($Sql) = $_[0];
my($total) = undef;
my($SubDebug) = $main::SubID{ExecuteSQL_Total}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... Executing \"$Sql\"") : 0;

	if ($Sql)
	{
		if ($main::Config{DBConnected} == 1)
		{
	        $main::Config{sth} = $main::Config{dbh} ->prepare( qq($Sql));
	        $main::Config{sth} -> execute;       	
		$total = $main::Config{sth} -> fetchrow_array;  
	        $main::Config{sth} -> finish;			
		};	
	};
($SubDebug == 1) ? DebugOut("... Result: \"$total\"") : 0;
return $total
};

sub main::ExecuteSQL_Unique
{
my($Sql) = $_[0];
my($total) = undef;
my(@Result) = undef;
my($rc) = undef;
my($temp) = undef;
my(@TempResult) = undef;

my($SubDebug) = $main::SubID{ExecuteSQL_Total}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... Executing \"$Sql\"") : 0;

	if ($Sql)
	{
		if ($main::Config{DBConnected} == 1)
		{
	        $main::Config{sth} = $main::Config{dbh} ->prepare( qq($Sql));
	        $main::Config{sth} -> execute;       	
			while (@TempResult = $main::Config{sth} -> fetchrow_array)
			{
			$Result[$rc++] = $TempResult[0];				
			($SubDebug == 1) ? DebugOut(" OK - \"$TempResult[0]\"") : 0;
			};
	        $main::Config{sth} -> finish;			
		};	
	};
($SubDebug == 1) ? DebugOut("... Unique Result: \"$rc\"") : 0;
return @Result
};

sub main::ExecuteSQL
{
my($Sql) = $_[0];
my($total) = undef;
my(@Result) = undef;
my($rc) = undef;
my($cc) = undef;
my($temp) = undef;
my(@TempResult) = undef;

my($SubDebug) = $main::SubID{ExecuteSQL_Total}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... Executing \"$Sql\"") : 0;

	if ($Sql)
	{
		if ($main::Config{DBConnected} == 1)
		{
	        $main::Config{sth} = $main::Config{dbh} ->prepare( qq($Sql));
	        $main::Config{sth} -> execute;       	
			while (@TempResult = $main::Config{sth} -> fetchrow_array)
			{
			$cc = undef;
				foreach $temp (@TempResult)
				{
				$DbGetData[$rc][$cc++] = $temp;	
				};
			$rc++;
			($SubDebug == 1) ? DebugOut(" OK - \"$TempResult[0]\"") : 0;
			};
	        $main::Config{sth} -> finish;			
		};	
	};
($SubDebug == 1) ? DebugOut("... ExecuteSQL returned: \"$rc\" rows") : 0;
return $rc;
};


sub main::DBError
{
my($SubDebug) = $main::SubID{ConnectDatabase}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... Database Error catching...") : 0;
main::AddError("e00108","$DBI::errstr");
$main::Config{DBConnected} = 0;	
};
1;
