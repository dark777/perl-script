sub main::CollectStat
{
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = undef;
my($Time) = time;

    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($Time); 
    $mon++; 
    ($hour < 10) ? $hour = "0"."$hour" : $hour = $hour;
    ($hour < 1) ? $hour = "0"."$hour" : {};
    ($mday < 10) ? $mday = "0"."$mday" : $mday = $mday;
    ($mon < 10) ? $mon = "0"."$mon" : $mon = $mon;
    $year = $year + 1900;

my($StatFolder) = $main::Config{StatFolder} . "$year/";
unless (-e $StatFolder) {mkdir($StatFolder,0777)};
$StatFolder = $main::Config{StatFolder} . "$year/" . "$mon/";
unless (-e $StatFolder) {mkdir($StatFolder,0777)};
    if (-e $StatFolder)
    {
    my($String) ="::1::".$Time."::1::::2::$main::Form{c}::2::::3::$main::UserEnv{name}::3::::4::$main::Config{Env}{REMOTE_ADDR}::4::::5::$main::Config{Env}{HTTP_USER_AGENT}::5::::6::$main::Config{Env}{HTTP_REFERER}::6::::7::$main::Config{Env}{QUERY_STRING}::7::::8::$main::Config{Env}{HTTP_COOKIE}::8::::9::$main::Config{Env}{HTTP_ACCEPT_LANGUAGE}::9::::10::".$main::Form{sn}."::10::::11::".$main::Html{CookieAnswer}{StoukWade}."::11::\n";
    my($StatFile) = $StatFolder . "$mday"."$hour".".stt";
    main::AddFile($StatFile,$String);
    };
};
1;
