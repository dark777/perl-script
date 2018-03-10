sub lib_stats_collect
{
my($Time) = time;
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = undef;
my($month,$weekday,$ampm, $ampmhour) = undef;
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($Time); 
	$mon++; 
	$month = $main::ConfigEnv{Month}{$mon};
	$weekday = $main::ConfigEnv{Weekday}{$wday};
	($sec < 10) ? $sec = "0"."$sec" : $sec = $sec;
	($min < 10) ? $min = "0"."$min" : $min = $min;
	($hour < 12) ? {$ampm = "AM"} : {$ampm = "PM"};
	($hour < 12) ? {$ampmhour = "$hour"} : {$ampmhour = $hour - 12};
	($hour < 10) ? $hour = "0"."$hour" : $hour = $hour;
	($hour < 1) ? $hour = "0"."$hour" : {};
	($mday < 10) ? $mday = "0"."$mday" : $mday = $mday;
	($mon < 10) ? $mon = "0"."$mon" : $mon = $mon;
	($ampmhour < 10) ? $ampmhour = "0"."$ampmhour" : $ampmhour = $ampmhour;
	($ampmhour < 1) ? $ampmhour = "0"."$ampmhour" : {};
	$year = $year + 1900;


	
};
1;
