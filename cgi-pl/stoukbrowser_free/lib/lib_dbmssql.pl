# Microsoft SQL Database Handling Library


sub main::ConnectDatabase
{
use DBI;
use DBD::ODBC;
    	
};
sub main::DisconnectDatabase
{
use DBI;
use DBD::ODBC;
	
};


sub main::DatabaseConnect
{
    use DBI;
    use DBD::ODBC;
 my($SubDebug) = $main::SubID{DatabaseConnect}{debug};
 if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

#	unless (defined $main::Config{DatabaseServerName}) 
#	{
#	main::AddError("e00101");
#	($SubDebug == 1) ? DebugOut("FAILED - Database Server Name was not specified: \$main::Config{DatabaseServerName} = \"$main::Config{DatabaseServerName}\"") : 0;
#	};

	unless (defined $main::Config{DSN}) 
	{
	main::AddError("e00105");
	($SubDebug == 1) ? DebugOut("FAILED - Database Source Name was not specified: \$main::Config{DSN} = \"$main::Config{DSN}\"") : 0;
	};

	unless (defined $main::Config{DBUer}) 
	{
	main::AddError("e00102");
	($SubDebug == 1) ? DebugOut("FAILED - Database User Name was not specified: \$main::Config{DBUser} = \"$main::Config{DBUser}\"") : 0;
	};

	$main::Config{DBConnected} = 1;
	$main::Config{DB} = DBI->connect( "dbi:ODBC:$main::Config{DSN}", "$main::Config{DBUser}", "$main::Config{DBPassword}", {RaiseError => 1, PrintError => 1, AutoCommit => 1} ) or main::DBError();
};


 sub main::DatabaseDisconnect
 {
 $main::Config{DB}->disconnect;	
 };

sub main::GetTableData
{
    use DBI;
    use DBD::ODBC;

my($SubDebug) = $main::SubID{DatabaseConnect}{debug};
 if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

my($TableName) = $_[1];
my($FieldName) = $_[0];
my($temp) = undef;
my(@datatemp) = undef;
my($colcounter) = undef;
my($rowcounter) = undef;
$main::Config{Sql} = "Select $FieldName from $TableName";
$main::Config{DBRows} = 0;
($SubDebug == 1) ? DebugOut("Query: \"$main::Config{Sql}\"") : 0;

	if ($main::Config{DBConnected} == 1)
	{
	$main::Config{DBH} = $main::Config{DB}->prepare($main::Config{Sql});
	$main::Config{DBH}->execute;
 	while ($temp = $main::Config{DBH}->fetch)
 	{
	@datatemp = @$temp;
	$colcounter = 0;
	 	foreach (@datatemp)
	 	{
	 	$main::DbGetData[$rowcounter][$colcounter++] = $_;
	 	};
	$rowcounter++;
 	};
	$main::Config{DBRows} = $rowcounter;
	$main::Config{DBH}->finish;
	($SubDebug == 1) ? DebugOut("Retrieved: \"$main::Config{DBRows}\" rows of data.") : 0;
	} else {
		main::AddError("e00106"," \"$main::Config{Sql}\" \$main::Config{DBConnected} = \"$main::Config{DBConnected}\"");
		($SubDebug == 1) ? DebugOut("FAILED: No Connection to Database.") : 0;
		};
};

sub main::DBError
{
my($SubDebug) = $main::SubID{DatabaseConnect}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
main::AddError("e00102","$DBI::errstr");
$main::Config{DBConnected} = 0;	
};


sub main::DatabaseInsertRecord
{
    use DBI;
    use DBD::ODBC;

my($SubDebug) = $main::SubID{DatabaseConnect}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($DateMark) = main::main::lib_time_gettime(3);
my($sql) = $_[0];
	if ($sql)
	{
	$main::Config{Sql} = $sql;

	($SubDebug == 1) ? DebugOut("Executing Query: \"$main::Config{Sql}\"") : 0;
	$main::Config{DBH} = $main::Config{DB}->prepare($main::Config{Sql});
	$main::Config{DBH}->execute;
	unless ($DBI::errstr) 
	{
	($SubDebug == 1) ? DebugOut("OK - Query Executed.") : 0;
	return 1;
	} else {
		($SubDebug == 1) ? DebugOut("FAILED - Query failed to execute: \"$DBI::errstr\"") : 0;
		return 0;
		};
	
	} else {
		($SubDebug == 1) ? DebugOut("FAILED: No SQL String passed.") : 0;
		main::AddError("e00107"," $sql");
		return 0;
		};
	
};


1;