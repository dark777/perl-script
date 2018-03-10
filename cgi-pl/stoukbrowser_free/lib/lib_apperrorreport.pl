sub main::lib_apperrorreport_config
{
$main::Config{apperror}{errorfolder} = $main::Config{UEnvFolder} . "apperrors/";
unless (-e $main::Config{apperror}{errorfolder}) {mkdir($main::Config{apperror}{errorfolder},0777)};
$main::Config{apperror}{fixederrorfolder} = $main::Config{apperror}{errorfolder} . "fixed/";
unless (-e $main::Config{apperror}{fixederrorfolder}) {mkdir($main::Config{apperror}{fixederrorfolder},0777)};

my($ErrorTime) = main::lib_time_gettime(9);
$main::Config{apperror}{errorlog} = $main::Config{apperror}{errorfolder} . "$ErrorTime" . ".log";
$main::Config{apperror}{alertfile} = $main::Config{apperror}{errorfolder} . "alert".".txt";
	unless (-f $main::Config{apperror}{alertfile})
	{
	my($String) = qq(
<PRIORITY:HIGH>
<RETRYCOUNT:1>
<RETRYINTERVAL:1>
<TOFAXNUM:94163362066,,,,8888888>
<TOCOMPANY:SmurfAlert>
<TONAME:Sergy>
<NOCOVER>
<FROMNAME:WebAlert>
<NOSMARTRESUME>
<DELETEALL>	
	);
	main::SaveFile($main::Config{apperror}{alertfile},$String);
	};
$main::Config{apperror}{alertcommand} = "copy \"$main::Config{apperror}{alertfile}\" \\\\SCNTACRDFAX\\HPFAX";
};

sub main::lib_apperrorreport_adderror
{
use Win32;
my($ErrorTime) = main::lib_time_gettime(7);
my($ErrorFile) = $main::Config{apperror}{errorfolder} . main::lib_time_gettime(13) . ".err";
my(%ErrorReport) = undef;
$ErrorReport{Application} = $_[0];
$ErrorReport{User} = $_[1];
$ErrorReport{Phone} = $_[2];
$ErrorReport{Problem} = $_[3];
main::WriteIntConfig("config",\%ErrorReport,$ErrorFile);
my($String) = undef;
$String .= qq(
$ErrorTime
$ErrorFile
Application : $ErrorReport{Application}
User: $ErrorReport{User}
Phone: $ErrorReport{Phone}
Problem: $ErrorReport{Problem}
);
# my($Command) = `$main::Config{apperror}{alertcommand}`;
# $String .= $main::Config{apperror}{alertcommand} . "\n";
if (-f $main::Config{apperror}{alertfile})
{
my($Command) = Win32::CopyFile($main::Config{apperror}{alertfile},"\\\\SCNTACRDFAX\\HPFAX",1);
} else {
	$String .= "No Such File: $main::Config{apperror}{alertfile}\n";
	};
$String .= "Result: " . $Command;
main::AddFile($main::Config{apperror}{errorlog},$String);

if (-e $ErrorFile) {return 1} else {return 0};
};
1;