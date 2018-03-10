#!/usr/bin/perl
# Hit Logger 1.0 
# By David Powell
# http://cgi.matrixvault.com
# This script is distributed as FREEWARE. Use it at your own risk! 
# This script comes with NO guarantees, warranties or promises.
# The author cannot be held responsible for any damage it causes.
# If you don't agree with this, do NOT USE THIS SCRIPT!
#################################################################
#    Description: 
#	This small script will keep a log of all hits toa web page. It is not very
#	complicated. When the user hits your page, this script extracts 
#	user information and logs it into a file. 
#	There are up to 5 lines per entry (configureable),
#   	So this file can get HUGE if you have a lot of traffic. Imagine 
# 	5000 lines of text per day if you get 1000 hits a day! 
#################################################################
#  Installation:
#    1. Edit the variables in the EDIT section to fit your situation.
#    2. Ascii upload the script to your cgi-bin, cmod 755
#    3. Call the script using a SSI tag in the web page:
#          <!--#exec cgi="http://your.host.xxx/cgi-bin/hitlog.cgi"-->
#    4. Make sure you change the extension of the web page to .shtml
#    5. If needed, upload an empty log file before running for the first time. Some
#        systems require this. If you have TELNET, type "touch filename.html" to 
#        save time. this will create a blank file.
##################################################################
#                           E D I T         VARIABLES:
#

$log_file="/virtualhosts/matrixvault.com/www/cgi-local/cgi_hitlog_hits.html";
#The UNIX path of your log file. This should be .HTML so you can view it with your browser.

#
#  Log line toggles: 1= on      0 = off
#
	$date_toggle="1";
	$IP="1";
	$hostname="1";
	$browser="1";
	$from="1";
#
#
#             E N D   E D I T      VARIABLES
######################################################
print "Content-type: text/html\n\n";
$date=localtime(time);
##############
#Open the log file 
#
open (LOG,">>$log_file");
##############
# Make the entry
#
if ($date_toggle eq "1") {
	print LOG "<b>Date:</b>$date<BR>\n";
	}
if ($IP eq "1") {
	print LOG "<b>IP Address:</b>$ENV{'REMOTE_ADDR'}<BR>\n";
	}
if ($hostname eq "1") {
	print LOG "<b>HostName:</b>$ENV{'REMOTE_HOST'}<BR>\n";
	}
if ($browser eq "1") {
	print LOG "<b>Browser/OS:</b>$ENV{'HTTP_USER_AGENT'}<BR>\n";
	}
if ($from eq "1") {
	print LOG "<b>From:</b><a href=\"$ENV{'HTTP_REFERER'}\">$ENV{'HTTP_REFERER'}</a><BR>\n";
	}
print LOG "$_";
close (LOG);


