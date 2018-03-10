# Time Manipulation Library
sub main::lib_time_gettime
{
my($TimeFormat) = $_[0];
my($Time) = $_[1];
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = undef;
my($month,$weekday,$ampm, $ampmhour) = undef;
unless ($Time)
{
$Time = time;
};

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($Time); 
	$mon++; 
	$month = $main::ConfigEnv{Month}{$mon};
	$weekday = $main::ConfigEnv{Weekday}{$wday};
	($sec < 10) ? $sec = "0"."$sec" : $sec = $sec;
	($min < 10) ? $min = "0"."$min" : $min = $min;
	($hour < 12) ? {$ampm = "AM"} : {$ampm = "PM"};
	($hour < 12) ? {$ampmhour = "$hour"} : {$ampmhour = $hour - 12};
	($hour < 10) ? $hour = "0"."$hour" : $hour = $hour;
	# ($hour < 1) ? $hour = "0"."$hour" : {};
	($mday < 10) ? $mday = "0"."$mday" : $mday = $mday;
	($mon < 10) ? $mon = "0"."$mon" : $mon = $mon;
	($ampmhour < 10) ? $ampmhour = "0"."$ampmhour" : $ampmhour = $ampmhour;
	($ampmhour < 1) ? $ampmhour = "0"."$ampmhour" : {};
	
my($ReturnTime) = undef;
$year = $year + 1900;


# 2003-Feb-12
($TimeFormat == 1) ? {$ReturnTime = "$year" . "-" . "$month" . "-". "$mday"} :
# 2003/Feb/12
($TimeFormat == 2) ? {$ReturnTime = "$year" . "/" . "$month" . "/". "$mday"} :
# 2003/02/12
($TimeFormat == 3) ? {$ReturnTime = "$year" . "/" . "$mon" . "/". "$mday"} :
# 12/02/2003
($TimeFormat == 4) ? {$ReturnTime = "$mday" . "/" . "$month" . "/". "$year"} :
# 02/12/2003
($TimeFormat == 5) ? {$ReturnTime = "$month" . "/" . "$mday" . "/". "$year"} :
# 02/12/2003 18:22
($TimeFormat == 6) ? {$ReturnTime = "$month" . "/" . "$mday" . "/". "$year" . " " . "$hour" . ":" . "$min"} :
# 02/12/2003 06:22PM
($TimeFormat == 7) ? {$ReturnTime = "$month" . "/" . "$mday" . "/". "$year" . " " . "$ampmhour" . ":" . "$min". "$ampm"} :
# 2002Feb12
($TimeFormat == 8) ? {$ReturnTime = "$year"  . "$month" . "$mday"} :
# 2003-02-12
($TimeFormat == 9) ? {$ReturnTime = "$year"  . "-" . "$mon" ."-". "$mday"} :
# 2003-02-12-01
($TimeFormat == 10) ? {$ReturnTime = "$year"  . "-" . "$mon" ."-". "$mday"."-"."$hour"} :
# 20030212010101
($TimeFormat == 11) ? {$ReturnTime = "$year"."$mon" ."$mday"."$hour"."$min"."$sec"} :
($TimeFormat == 12) ? {$ReturnTime = "$year"."$mon" ."$mday"."$hour"} :
($TimeFormat == 13) ? {$ReturnTime = "$year"  . "-" . "$mon" ."-". "$mday"."-"."$hour"."_"."$min"."$sec"} :
($TimeFormat == 14) ? {$ReturnTime = "$year"."$mon" ."$mday"."$hour"."$min"} :



{$ReturnTime = scalar localtime($Time)};
return $ReturnTime;
};
sub GetDateAndTime 
{
    # Define the time zones verbiage you would like to display.
    my $daylight_zone     = 'Pacific Daylight Time';
    my $standard_zone     = 'Pacific Standard Time';

    # Define the server offset, if any.
    my $daylight_offset     = -3; 
    my $standard_offset = -3; 

    my @days          = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday);
    my @months          = qw(January February March April May June July August September October November December); 
    my $dst               = (localtime(time))[8];
    my $tz_offset     = $dst ? $daylight_offset     : $standard_offset;
    my $zone           = $dst ? $daylight_zone          : $standard_zone;

    my ($sec, $min, $hour, $mday, $mon, $year, $wday) = (localtime(time + ($tz_offset * 3600)))[0..6];
    my $ampm = ($hour < 12) ? 'am' : 'pm';

    $hour  = 12 if $hour == 0;
    $hour -= 12 if $hour > 12;
    $year += 1900;

    $_ = sprintf("%02d", $_) foreach ($sec, $min, $hour, $mday);     

    $mon = $mon + 1;

    if (length($mon) == 1) {$mon = "0" . $mon;}
    if (length($mday) == 1) {$mday = "0" . $mday;}
    if (length($hour) == 1) {$hour = "0" . $hour;}
    if (length($min) == 1) {$min = "0" . $min;}

    return("$mon$mday$year-$hour$min$ampm");
}
1;
