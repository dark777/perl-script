#!/usr/bin/perl

# Script name:
# @1 Last Modified Date and Time

# Purpose:
# This Perl script checks the "Last Modified" date and time
# of a file.

# Uses:
# Call the display via SSI using the tag below:
# <!--#include virtual="yourfolder1/yourfolder2/lastmodified.cgi" -->

# License Notice: 
# Copyright 2004 UPDI Network Enterprise, www.upoint.info/cgi
# You are free to use and distribute this script as long as
# you keep this license notice intact.

############################################################
# FULL PATH (not URL) to the file:
############################################################
$filename = "/home/tour/newsfeed/LatestTravelNews.txt";

############################################################
# Turn on debug mode so that you can see the formats
############################################################
$debug = "0";               	# 1 = ON    0 = OFF
				# Set to "0" after testing
############################################################
# DO NOT EDIT BELOW THIS LINE
############################################################

use POSIX 'strftime';
my $time = (stat $filename)[9];
print "Content-type: text/html\n\n";

print strftime '%a %d.%b.%Y @ %I:%M %p', localtime $time;

if ($debug eq 1){
print "<p>";
print "a - ";
print strftime '%a', localtime $time;
print "<BR>";
print "A - ";
print strftime '%A', localtime $time;
print "<BR>";
print "b - ";
print strftime '%b', localtime $time;
print "<BR>";
print "B - ";
print strftime '%B', localtime $time;
print "<BR>";
print "c - ";
print strftime '%c', localtime $time;
print "<BR>";
print "d - ";
print strftime '%d', localtime $time;
print "<BR>";
print "H - ";
print strftime '%H', localtime $time;
print "<BR>";
print "I - ";
print strftime '%I', localtime $time;
print "<BR>";
print "j - ";
print strftime '%j', localtime $time;
print "<BR>";
print "m - ";
print strftime '%m', localtime $time;
print "<BR>";
print "M - ";
print strftime '%M', localtime $time;
print "<BR>";
print "p - ";
print strftime '%p', localtime $time;
print "<BR>";
print "s - ";
print strftime '%s', localtime $time;
print "<BR>";
print "U - ";
print strftime '%U', localtime $time;
print "<BR>";
print "w - ";
print strftime '%w', localtime $time;
print "<BR>";
print "W - ";
print strftime '%W', localtime $time;
print "<BR>";
print "x - ";
print strftime '%x', localtime $time;
print "<BR>";
print "X - ";
print strftime '%X', localtime $time;
print "<BR>";
print "y - ";
print strftime '%y', localtime $time;
print "<BR>";
print "Y - ";
print strftime '%Y', localtime $time;
print "<BR>";
print "Z - ";
print strftime '%Z', localtime $time;
}