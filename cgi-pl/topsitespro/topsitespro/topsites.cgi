#!/usr/bin/perl 
##
#######################################################
#		Top Sites Professional
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
# Copyright 1997 Solution Scripts  All Rights Reserved.
#
# Selling or redistributing the code for this program
# without prior written consent is expressly forbidden.
# In all cases copyright and header must remain intact.
#
######################################################


require "variables.pl";

##############################
# IF YOU WANT TO HAVE VIEWERS FORWARDED 
# TO SOMETHING OTHER THAN TOP SITES 
# PUT THE URL BELOW
##############################
$location_to_forward = "$url/$topsite_file";
##############################

$time = time;
$reset_offset = $reset_offset * 3600;
$time = $time + $reset_offset;
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);
$grt= $time - 600;
$mon++;
$year += 1900;
$now = "$mon.$mday.$year";
$sunday = $yday - $wday;

read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
@pairs = split(/&/, $buffer);
foreach $pair (@pairs) {
	($name, $value) = split(/=/, $pair);
	$value =~ tr/+/ /;
	$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	if ($INPUT{$name}) { $INPUT{$name} = $INPUT{$name}.",".$value; }
	else { $INPUT{$name} = $value; }
}

$current_time = time();
$member = $ENV{'QUERY_STRING'};
$host = $ENV{'HTTP_REFERER'}; 
$cgiurl = $ENV{'SCRIPT_NAME'};
$member =~ s/ID\=//gi;

########## GATEWAY CODE ##########

if ($gateway) {

	$type = $ENV{"CONTENT_TYPE"};
	if ($type ne "application/x-www-form-urlencoded") {
	        &print_gate;
	        exit;
	}
	$grtt = $INPUT{'value'} - 1000;
	if ($grtt > $grt) {
		$member = $INPUT{'member'};
		&print_gate;	
		exit;
	}
	unless ($host =~/$ENV{'SERVER_NAME'}/i) {
		$member = $INPUT{'member'};
		&print_gate;	
		exit;	
	}
	$member = $INPUT{'member'};
}

########### IP BLOCKING CODE ##########

$theip = $ENV{'REMOTE_ADDR'};
$found=0;
if ( -e "$path/data/ips.txt" ) { 
	open( IPS, "+<$path/data/ips.txt");
	if ($use_flock) {
		flock IPS, 2; 
	}
	@ipdb = <IPS>;
	seek (IPS, 0, 0);
	truncate (IPS,0);
	foreach $line(@ipdb) {
		@ip = split(/\|/,$line);
		$total_time = $current_time - $ip[1];
		if ( ($ip[0] == $theip) && ($total_time < $ip_time) ) {
			$found=1;
		}		
		if ($total_time < $ip_time) {
			print IPS "$ip[0]|$ip[1]|0\n";
		}
	}
	unless ($found) {
		print IPS "$theip|$current_time|0\n";
	}
	close IPS;
}
else {
	open( IP, ">$path/data/ips.txt");
	print IP "$theip|$current_time|0\n";
	close IP;	
}
if ($found) {
	print "Location: $location_to_forward  \n\n";
	exit;
}

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
		$today[1]++;
		$found=1;
	}

	seek (DISPLAY, 0, 0);
	print DISPLAY @banner;
	if ($found) {
		print DISPLAY "$today[0]|$today[1]|$today[2]\n";
	}
	else {
		print DISPLAY "$today[0]|$today[1]|$today[2]\n";
		print DISPLAY "$now|1|0\n";
	}
	close DISPLAY;
}
else {
	open( DISPLAY, ">$path/data/daily.txt");
	if ($use_flock) {
		flock DISPLAY, 2; 
	}
	print DISPLAY "$now|1|0\n";
	close DISPLAY;
}



##### READS MEMBER ID AND UPDATES HIT COUNT

open (DAT,"+<$path/members/$member.txt") || &nomember;
if ($use_flock) {
	flock DAT, 2; 
}
@members_array = <DAT>;


chomp ($members_array[9]);
chomp ($members_array[13]);
chomp ($members_array[14]);
chomp ($members_array[16]);
chomp ($members_array[17]);

unless ($members_array[9] eq $now) {
$members_array[1] = 0;
$members_array[10] = 0;
$members_array[10] .= "\n";
}

unless ($members_array[13] eq $mon) {
$members_array[14] = 0;
$members_array[15] = 0;
$members_array[15] .= "\n";
}

unless ($members_array[16] eq $sunday) {
$members_array[17] = 0;
$members_array[18] = 0;
$members_array[18] .= "\n";
}

$members_array[1]++;
$members_array[1] .= "\n";
$members_array[9] = "$now\n";
$members_array[0]++;
$members_array[0] .= "\n";
$members_array[13] = "$mon\n";
$members_array[14]++;
$members_array[14] .= "\n";
$members_array[16] = "$sunday\n";
$members_array[17]++;
$members_array[17] .= "\n";
$members_array[3] = "$current_time\n";

seek (DAT, 0, 0);
print DAT @members_array;
close (DAT);


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
		$today[1]++;
		$found=1;
	}

	seek (DISPLAY, 0, 0);
	print DISPLAY @banner;
	if ($found) {
		print DISPLAY "$today[0]|$today[1]|$today[2]|$today[3]\n";
	}
	else {
		print DISPLAY "$today[0]|$today[1]|$today[2]|$today[3]\n";
		print DISPLAY "$now|1|0|N.A.\n";
	}
	close DISPLAY;
}
else {
	open( DISPLAY, ">$path/members/$member.dat");
	if ($use_flock) {
		flock DISPLAY, 2; 
	}
	print DISPLAY "$now|1|0|N.A.\n";
	close DISPLAY;
}




######## CODE IF CRON IS SET TO 0 ##############
unless ($cron) {
	open (LASTTIME,"<$path/data/time.txt");
	if ($use_flock) {
		flock LASTTIME, 2; 
	}
	$last = <LASTTIME>;
	close (LASTTIME);

	$doit = $current_time - $last;

	if ($doit > $update) {
		open (NEWTIME,">$path/data/time.txt");
		if ($use_flock) {
			flock NEWTIME, 2; 
		}
		print NEWTIME "$time";
		close (NEWTIME);
		print "Location: $url_to_cgi/create.cgi \n\n";
		exit;
	}
}

##

print "Location: $location_to_forward \n\n";
exit;

sub print_gate {

$member = $ENV{'QUERY_STRING'};
print "Content-type: text/html \n\n";

print <<EOF;

<HTML><HEAD><TITLE>$topsite_name</TITLE></HEAD>
<BODY><center>
<FONT SIZE="+1" FACE="Arial">
You are just one click away from $topsite_name
</FONT><BR><BR>
<form action="$cgiurl" method="POST">
<input type="Hidden" name="member" value="$member">
<input type="Hidden" name="value" value="$grt">
<input type="Submit" name="proceed" value=" Click here to proceed ">
</form>
</center>
</BODY>
</HTML>

EOF

open (HEAD, "$path/data/gateway.txt");
@head = <HEAD>;
close (HEAD);
foreach $line (@head) {
	print "$line";
}

}

sub nomember {
	print "Location: $location_to_forward \n\n";
	exit;
}

sub error{
	$errors = $_[0] ;
	print "Content-type: text/html\n\n";
	print"<HTML><HEAD><TITLE>Top Sites error</TITLE></HEAD><Body>";
	print"<h2 align=center>A Top Sites error has occured in topsites.cgi</H2><center>";
	print"<blockquote><b>The error is: <br><font size=+1 color=red>$errors</font><br><br>";
	exit;
}