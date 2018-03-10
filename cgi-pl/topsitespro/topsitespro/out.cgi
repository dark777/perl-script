#!/usr/bin/perl 
##
#######################################################
#		Top Sites Professional v3.04
#     
#    	Created by Solution Scripts
# 		Email: solutions@solutionscripts.com
#		Web: http://solutionscripts.com
#
#######################################################
#
#
# COPYRIGHT NOTICE:
#
# Copyright 1998 Solution Scripts  All Rights Reserved.
#
# Selling or redistributing the code for this program
# without prior written consent is expressly forbidden.
# In all cases copyright and header must remain intact.
#
######################################################


require "variables.pl";

#print "Content-type: text/html \n\n";


$member = $ENV{'QUERY_STRING'};
$time = time;
$reset_offset = $reset_offset * 3600;
$time = $time + $reset_offset;
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);
$mon++;
$year += 1900;
$now = "$mon.$mday.$year";
$sunday = $yday - $wday;

if ( -e "$path/data/daily.txt" ) { 
	open( DISPLAY, "+<$path/data/daily.txt");
	if ($use_flock) {
		flock DISPLAY, 2; 
	}
	@banner = <DISPLAY>;
	$log_num=0;
	$log_num = push(@banner);
	if ($log_num > 1) {
		$log = pop(@banner);
	}
	else {
		$log = $banner[0];
		@banner ='';
	}

	chomp($log);
	@today = split(/\|/,$log);
	
	$found=0;
	if ($today[0] eq $now) {
		$today[2]++;
		$found=1;
	}

	seek (DISPLAY, 0, 0);
	print DISPLAY @banner;
	if ($found) {
		print DISPLAY "$today[0]|$today[1]|$today[2]\n";
	}
	else {
		print DISPLAY "$today[0]|$today[1]|$today[2]\n";
		print DISPLAY "$now|0|1\n";
	}
	close DISPLAY;
}
else {
	open( DISPLAY, ">$path/data/daily.txt");
	if ($use_flock) {
		flock DISPLAY, 2; 
	}
	print DISPLAY "$now|0|1\n";
	close DISPLAY;
}



##### READS MEMBER ID AND UPDATES HIT COUNT
open (DAT,"+<$path/members/$member.txt") || &nomember;
if ($use_flock) {
	flock DAT, 2; 
}
@members_array = <DAT>;
chomp ($members_array[10]);
chomp ($members_array[11]);
chomp ($members_array[9]);
chomp ($members_array[13]);
chomp ($members_array[15]);
chomp ($members_array[16]);
chomp ($members_array[18]);

unless ($members_array[9] eq $now) {
$members_array[1] = 0;
$members_array[10] = 0;
$members_array[1] .= "\n";
}

unless ($members_array[13] eq $mon) {
$members_array[14] = 0;
$members_array[15] = 0;
$members_array[14] .= "\n";
}

unless ($members_array[16] eq $sunday) {
$members_array[17] = 0;
$members_array[18] = 0;
$members_array[17] .= "\n";
}


$members_array[11]++;
$members_array[11] .= "\n";

$members_array[9] = "$now\n";
$members_array[10]++;
$members_array[10] .= "\n";
$members_array[13] = "$mon\n";
$members_array[15]++;
$members_array[15] .= "\n";
$members_array[16] = "$sunday\n";
$members_array[18]++;
$members_array[18] .= "\n";



seek (DAT, 0, 0);
print DAT @members_array;
close (DAT);
chomp ($members_array[4]);
$url = "$members_array[4]";

if ( -e "$path/members/$member.dat" ) { 
	open( DISPLAY, "+<$path/members/$member.dat");
	if ($use_flock) {
		flock DISPLAY, 2; 
	}
	@banner = <DISPLAY>;
	$log_num=0;
	$log_num = push(@banner);
	if ($log_num > 1) {
		$log = pop(@banner);
	}
	else {
		$log = $banner[0];
		@banner ='';
	}
	chomp($log);
	@today = split(/\|/,$log);
	
	$found=0;
	if ($today[0] eq $now) {
		$today[2]++;
		$found=1;
	}

	seek (DISPLAY, 0, 0);
	print DISPLAY @banner;
	if ($found) {
		print DISPLAY "$today[0]|$today[1]|$today[2]|$today[3]";
	}
	else {
		print DISPLAY "$today[0]|$today[1]|$today[2]|$today[3]";
		print DISPLAY "$now|0|1|N.A.\n";
	}
	close DISPLAY;
}
else {
	open( DISPLAY, ">$path/members/$member.dat");
	if ($use_flock) {
		flock DISPLAY, 2; 
	}
	print DISPLAY "$now|0|1|N.A.\n";
	close DISPLAY;
}





print "Location: $url \n\n";
exit;

sub nomember {
print "Content-type: text/html\n\n";
print "$member .... no such member";
exit;
}
