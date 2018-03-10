#!/usr/bin/perl
#
#	Matrix's 404 Helper
#	Helps your 404's help you make a completely linked site.
#
#	This script will keep a log of 404 errors. Periodically, you will
#	recieve emails telling you what the errors were.  You can then 
#	see who was trying to get where from what other page or source.
#	From there you can take appropriate action.
########################
#	INSTALLATION:
#	Edit the variables below.
#	Upload this script to your cgi-bin or a cgi-capeable directory via ASCII mode.
#	CHMOD 755 this script.
#	Put the following SSI tag in your 404.shtml page:
#	<!--#exec cgi="/directory of this script/404helper.cgi"-->
########################
#     Edit Variables:

# Your sendmail program UNIX location
$sendmail = '/usr/lib/sendmail -t';

# The log file name you wish to use:
$logname = "404.log";

# The size of the log file needed (in K) to send you an email:
$mailon = 10;

#  The Email address you want the report mailed to:
$email = 'webmaster@matrixvault.com';

# 
#     End Edit
#########################

 	print "Content-type: text/html\n\n";

	$bad_page = $ENV{'REQUEST_URI'};
	$referer = $ENV{'HTTP_REFERER'};
	$ip=$ENV{'REMOTE_HOST'};

	&add_entry;
	&check_log_length;
	&finish;
	exit;

#################
# Add Entry to the log
#################
sub add_entry
{

		open (LOG, ">>$logname") || &error ("Cannot open log for writing");
		print LOG qq!
--
WHO: $ip 
BAD PAGE: $bad_page  
CLICKED FROM: $referer
SUGGESTED: $suggestion
!;
		close(LOG);
}

#################
# Check Log Length
#################
sub check_log_length
{
	$max=($mailon*1024);
	$size = (-s "$logname");
	if ( $size >= $max)
		{
		open (LOG, "$logname") || &error ("Cannot open log for reading");
		while (<LOG>)
			{
			$text=$text . $_;
			}
		close (LOG);

		open (MAIL, "|$sendmail $email") || &error ("Can't open $sendmail");
		print MAIL "Subject:Error Log Report\n";
		print MAIL "To:$email\n";
		print MAIL "From: $email\n\n";
		print MAIL qq!
		Your error log has reached $mailon (K).\n
		Here are the latest entries:\n
		$text

		!;
		close(MAIL);
		unlink("$logname");
		}
}
#####################
#  FINISH
#####################
sub finish
{	
	print "<BR><font face=\"arial\" size=-2>404 Helper has logged this error.<BR>";
	print "The Webmaster will be notified.<BR>";
	print "<BR><BR><FONT size =-2>";
	print "404helper: <a href=\"http://www.matrixvault.com/cgi/\">A Matrix Vault Production</a><BR>";
}

