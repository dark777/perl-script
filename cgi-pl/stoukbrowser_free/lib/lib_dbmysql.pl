# MySQL Database routine Library
sub main::ConnectDatabase
{
use DBI;
my($SubDebug) = $main::SubID{ConnectDatabase}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... connecting to database: MySQL") : 0;
$main::Config{DBConnected} = 1;
unless ($main::Config{DBPort} > 1024) {$main::Config{DBPort} = 3306; ($SubDebug == 1) ? DebugOut("OK - Assigned Default Database connection port: 3306") : 0;};
	if (length($main::Config{DBName}) > 1) 
	{
	($SubDebug == 1) ? DebugOut("Connection Parameters: Database: \"$main::Config{DBName}\" User: \"$main::Config{DBUser}\" Server:\"$main::Config{DBServer}\"") : 0;
	$main::Config{DBConnectionString} = "DBI:mysql:".$main::Config{DBName}.":host=".$main::Config{DBServer};
	} else {
	    ($SubDebug == 1) ? DebugOut("Connection Parameters: User: \"$main::Config{DBUser}\" Server: \"$main::Config{DBServer}\"") : 0;
	    $main::Config{DBConnectionString} = "DBI:mysql:host=".$main::Config{DBServer}.":port=".$main::Config{DBPort};    
	    };

$main::Config{dbh} = DBI->connect($main::Config{DBConnectionString}, $main::Config{DBUser}, $main::Config{DBPassword}) || main::DBError();

	if ($main::Config{DBConnected} == 1)
	{
	unless (defined $main::Config{DBName}) {$main::Config{DBName} = "StoukWade"; ($SubDebug == 1) ? DebugOut("OK - Assigned Default database name.") : 0;};
	$main::Config{DBStatsName} = $main::Config{DBName};
	my($rv) = undef;
	$main::Config{dbh}->do("create database if not exists $main::Config{DBStatsName}"); 
	$rv = $main::Config{dbh}->do("use $main::Config{DBStatsName}");
	    if (defined $rv)
	    { 
	    ($SubDebug == 1) ? DebugOut("OK - Connected to Database \"$main::Config{DBStatsName}\"") : 0;
	    $main::Config{DBConnected} = 1;
		    unless ($main::Config{DisableTBStructureConfirmation} == 1) 
		    {
		    main::ConfirmTableStructure();
		    };
	    } else {
	    	main::AddError("e00108","FAILED - executing \"do \"use \"$main::Config{DBStatsName}\"");
	        ($SubDebug == 1) ? DebugOut("FAILED - Connecting  to Database \"$main::Config{DBStatsName}\"") : 0;
	        $main::Config{DBConnected} = 0;
	        };
	};
};

sub main::GetTableNames
{
	if ($main::Config{DBConnected} == 1)
	{
	undef $main::Config{DB}{tables};
	# my(@dbs) = $main::Config{dbh}->func("$main::Config{DBServer}:$main::Config{DBPort}", '_ListDBs'); 
	# my(@dbs) = DBD::mysql::db::_ListDBs($main::Config{dbh});
	#$main::Config{DB}{tables} =  $main::Config{sth}->{table};
	# $main::Config{DB}{tables} = \@dbs;
	my(@tables) = $main::Config{dbh}->tables;
	$main::Config{DB}{tables} = \@tables;
	
	};	
	if (defined $main::Config{DB}{tables})
	{
	main::DebugOut("Successfully listed table names from Database.");
	return $main::Config{DB}{tables};
	} else {
		main::DebugOut("Failed to list Table names from Database");
		return 0;
		};	
};

sub main::DisconnectDatabase
{
use DBI;
my($test) = undef;
$test = $main::Config{dbh}->disconnect;
    
};

sub main::DBError
{
my($SubDebug) = $main::SubID{ConnectDatabase}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... Database Error catching...") : 0;
main::AddError("e00108","$DBI::errstr");
DebugOut("$DBI::errstr");
$main::Config{DBConnected} = 0;    
};

############## Creating Default database Structured required for program to run
sub main::ConfirmTableStructure
{
	if ($main::Config{DBConnected} == 1)
	{
	my($SubDebug) = $main::SubID{ConfirmTableStructure}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... confirming database structure") : 0;
	$main::Config{DbResult}{created} = $main::Config{dbh}->do("SHOW TABLES FROM $main::Config{DBStatsName}");
	
	($SubDebug == 1) ? DebugOut("\$main::Config{DbResult}{created} = \"$main::Config{DbResult}{created}\" : \@TableNames = @TableNames") : 0;
	
	        if ($main::Config{DbResult}{created} < 2)
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
};

sub main::CreateDefaultDatabaseStructure
{
        $main::Config{sql} = 
        "
        CREATE TABLE tb_stats 
        (
        f_rec VARCHAR(100) UNIQUE, 
        f_time INTEGER,
        f_year INTEGER,
        f_month INTEGER,
        f_date INTEGER,
        f_hour INTEGER,
        f_command VARCHAR(254) NULL,
        f_file VARCHAR(254) NULL,
        f_filesize INTEGER NULL,
        f_ref VARCHAR(254) NULL,
        f_keywords VARCHAR(254) NULL,
        f_user VARCHAR(254),
        f_ip VARCHAR(16)  NULL,
        f_screen VARCHAR(20) NULL,
        f_agent VARCHAR(100) NULL,
        f_os VARCHAR(100) NULL,
	f_sn VARCHAR(10) NULL,
	f_cookie VARCHAR(100) NULL
        
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
        f_commands VARCHAR(254) NULL,
        f_files VARCHAR(254) NULL,
        f_filesizes INTEGER NULL,
        f_refs VARCHAR(254) NULL,
        f_keywords VARCHAR(254) NULL,
        f_users VARCHAR(254),
        f_ips VARCHAR(16)  NULL,
        f_agents VARCHAR(100) NULL,
        f_oss VARCHAR(100) NULL,
	f_sn VARCHAR(10) NULL,
	f_cookie VARCHAR(100) NULL
        
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
    $number = ($year . $Time . $number);
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
1;
