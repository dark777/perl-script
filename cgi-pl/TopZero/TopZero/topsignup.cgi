#!/usr/bin/perl

###########################################################################
#                                                                         #
#    This is UNPUBLISHED PROPRIETARY SOURCE CODE of SplitInfinity; the    #
#    contents of this file may not be disclosed to third parties,         #
#    copied or duplicated in any form, in whole or in part, without       #
#    the prior written permission of SplitInfinity.                       #
#                                                                         #
#    Permission is hereby granted soley to the licencee for use of        #
#    this source code in its unaltered state.  This source code may       # 
#    not be modified by licencee except under direction of SplitInfinity. #
#    Neither may this source code be given under any                      #
#    circumstances to non-licensees in any form, including source         # 
#    or binary.  Modification of this source constitutes breach of        #
#    contract, which voids any potential pending support                  #
#    responsibilities by SplitInfinity.  Divulging the exact or           #
#    paraphrased contents of this source code to unlicensed parties       #
#    either directly or indirectly constitutes violation of federal       #
#    and international copyright and trade secret laws, and will be       #
#    duly prosecuted to the fullest extent permitted under law.           #
#                                                                         #
#    This software is provided by SplitInfinity. ``as is'' and any        #
#    express or implied warranties, including, but not limited to,        #
#    the implied warranties of merchantability and fitness for a          #
#    particular purpose are disclaimed.  In no event shall the            #
#    regents or contributors be liable for any direct, indirect,          #
#    incidental, special, exemplary, or consequential damages             #
#    (including, but not limited to, procurement of substitute            #
#    goods or services; loss of use, data, or profits; or business        #
#    interruption) however caused and on any theory of liability,         #
#    whether in contract, strict liability, or tort (including            #
#    negligence or otherwise) arising in any way out of the use of        #
#    this software, even if advised of the possibility of such            #
#    damage.                                                              #
#                                                                         #
###########################################################################
#                       _______                                           #
#                      /XXXXXX/| _____      Programmer: Chris Jester      #
#                     |------|X|/XXXX/|     Date      : 06/20/97          #
#                     |IIIIII|X|-ÑÑÑ X|     Version   : 1.0               #
#                     |IIIIII|X|IIII|X|     Title     : top100cgi         #
#                     |IIIIII|X|IIII|X|                                   #
#              --ÑÑÑÑÑ|IIIIII|X|IIII|/-----                               #
#         -----ooooooo|IIIIII|/oooooooooooo-----                          #
#     ---o o o o o o o o o o o o o o o o o o o o---                       #
#             http://www.splitinfinity.com                                #
#                      818-840-0905                                       #
###########################################################################

&ReadParse;
require "/www/warezplaza/cgi/topsites/top.conf";

# THIS CGI ALLOWS WEBMASTERS TO SIGNUP FOR A LINK ACCOUNT

# Make form variables easier to deal with.
$account[0]	=	$first 		=	$in{'first'};		# First Name
$account[1]	=	$last 		=	$in{'last'};		# Last Name
$account[2]	=	$email 		=	$in{'email'};		# Email Address
$account[3]	=	$title 		=	$in{'title'};		# Site Title
$account[4]	=	$desc 		=	$in{'desc'};		# Site Description
$account[5]	=	$linkurl 	=	$in{'linkurl'};		# Link URL
$account[6]	=	$bannerurl 	=	"NONE";				# Banner URL
$account[7]	=	$password 	=	$in{'password'};	# Password
$account[8]	=	0;									# How many people have visited us from them	
$account[9]	=	0;									# How many times we sent people to them
$account[10]=	0;									# Last visit date	
$account[11]=	0;									# Flags
$account[12]=	0;									# Visits Aggregate/Accumulative
$account[13]=	0;									# Sent Aggregate/Accumulative
$account[14]=	0;									# Last Sent Date
$account[15]=	time();								# Account creation date
$account[16]=	$category	=	$in{'category'};	# Category Chosen
$account[17]=	$freepics	=	$in{'freepics'};	# Number of free pics
$account[18]=	"NONE";								# Photo URL
$account[19]=	0;									# Photo Height
$account[20]=	0;									# Photo Width
$account[21]=	0;									# Banner Height
$account[22]=	0;									# Banner Width

# Clear initial variables
$response	=	"";					# Needs to be clear initially used for error checking

# Clean up form input
$first		=~	s/ //g;				# Remove spaces and globally for the following
$last		=~	s/ //g;
$email		=~	s/ //g;
$linkurl	=~	s/ //g;
$password	=~	s/ //g;

# Check all input for possible errors
if (length($first) < 1) 	{$response .= "First Name not entered.<BR>\n";}
if (length($last) < 1) 		{$response .= "Last Name not entered.<BR>\n";}
if (length($email) < 1) 	{$response .= "Email Address not entered.<BR>\n";}
if (length($title) < 1) 	{$response .= "Site Title not entered.<BR>\n";}
if (length($desc) < 2) 		{$response .= "No description entered.<BR>\n";}
if (length($linkurl) < 9) 	{$response .= "Link URL not entered.<BR>\n";}
if (length($password) < 4) 	{$response .= "Password not entered correctly. Passwords must be at least four characters<BR>\n";}
if ($linkurl !~ /^http:\/\//){$response.= "Link URL does not contain: http://<BR>\n";}
if ($category eq "none") 	{$response .= "You must choose a category.<BR>\n";}
if ($none eq "none") 		{$response .= "Number of free pics not chosen.<BR>\n";}
if ($response ne "") {&errorOnInput;}

# Create their unique account number
$account	=	$$|time();

# Create their account record
$output	= join("::",@account);

$FLK = $locks."/".$account.".lock";
&lock($FLK);
open (FILE,">${data}/${account}");
print FILE $output,"\n";
close (FILE);
chmod (0777,"${data}/${account}");
&unlock($FLK);
print "Location: ${cgiurl}/topcode.cgi?account=${account}&password=${password}\n\n";
exit;

# Header Content and Page Setup
sub head {
	print "Content-type: text/html\n\n";
	print "<HTML>\n";
	print "<HEAD>\n";
	print "<TITLE>${sigtitle}</TITLE>\n";
	print "</HEAD>\n";
	print "<BODY BGCOLOR=\"${bgcolor}\" TEXT=\"${textcolor}\" LINK=\"${linkcolor}\" 
			ALINK=\"${alinkcolor}\" VLINK=\"${vlinkcolor}\">\n\n";
	}
	
# There was an error, tell the user.
sub errorOnInput {
	&head;
	print "<P><CENTER>\n";
	print "<TABLE BORDER=\"0\">\n";
	print "<TR><TD>\n";
	print "<FONT SIZE=\"+1\" COLOR=\"${errorcolor}\">\n";
	print "<B>There was an error on your input!</B><br>\n";
	print "The reason your input failed was because:<P></FONT>\n";
	
	print "<FONT COLOR=\"${whycolor}\">";
	print "${response}<P>\n\n";
	print "Please use your browsers back button to correct<BR>\n";
	print "the error(s) and submit your input again.<P>\n";
	print "If you continue to have problems, please email us:<BR>";
	print "<A HREF=\"mailto:${support}\"><I>${support}</I></A>\n";
	print "</TD></TR></TABLE>\n";
	print $foot;
	exit;
	}

#####################################################
# LOCK ROUTINES 11/7/97 @ 4:16AM By Chris Jester    #
#  - 4:18am Changed delay from 1 second to .1s      #
#  - 4:20am Added die handler to open command       #
#  - 5:30am Added default mode of support for flock #
#####################################################
# This routine can either use my custom locking or  #
# standard flock() if available.  We always would   #
# prefer to use flock() when and if at all possible #
# since it will speed things up dramatically and is #
# native to the system.  When you want to use flock #
# you must make sure ALL other programs accessing   #
# the files under lock control are using flock as   #
# well.                                             #
#####################################################

sub lock
	{
	local ($lock_file) = @_;
	local ($timeout);
	
	$denyflock = 1;
	if ($denyflock == 1) {
  	# The timeout is used in a test against the date/time the lock file
  	# was last modified.  This allows us to determine rogue lock files and
  	# deal with them correctly.  If the current time is greater than the
  	# last modified time plus the timeout value, the system will allow
  	# this process to seize control of the lockfile and create it's own.
    # - Chris Jester say "Flock you!" -
  	
  	$timeout=20;	
	
	while (-e $lock_file && (stat($lock_file))[9]+$timeout>time)
		{
		# I use the unix system command 'select' to specify a .1s wait instead
		# of the enormous 1 second sleep command.  I have included the sleep
		# command below as an alternative if the select command gives any
		# trouble.  If we use sleep, then we comment out the select command.
		select(undef,undef,undef,0.1);
		# sleep(1); 
		}
	
	open(LOCK_FILE, ">$lock_file") || die ("ERR: Lock File Routine,{__FILE__},{__LINE__}");
	}
	else {flock(FILE,2);}
}

sub unlock
  {
  	local ($lock_file) = @_;
	$denyflock = 1;
	if ($denyflock == 1) {
  	close(LOCK_FILE);
  	unlink($lock_file);
  	}
  else {flock(FILE,8);}
  }


###################################################################
# READPARSE: PARSE $ENV AND URL ARGS, RETURN IN $in{'blah'} ARRAY #
###################################################################
sub ReadParse {
    local (*in) = @_ if @_;
    local ($i, $loc, $key, $val);
    # Read in text
    if ($ENV{'REQUEST_METHOD'} eq "GET") 
    	{
      	$in = $ENV{'QUERY_STRING'};
      	} elsif ($ENV{'REQUEST_METHOD'} eq "POST") 
      		{
    		read(STDIN,$in,$ENV{'CONTENT_LENGTH'});
  			}
  	@in = split(/&/,$in);
  	foreach $i (0 .. $#in) 
  		{
    	# Convert plus's to spaces
    	$in[$i] =~ s/\+/ /g;
    	# Split into key and value.
    	($key, $val) = split(/=/,$in[$i],2); # splits on the first =.
		#!! text fields return empty values when user doesn't use; dump these
		($val eq "") && next;
    	# Convert %XX from hex numbers to alphanumeric
    	$key =~ s/%(..)/pack("c",hex($1))/ge;
    	$val =~ s/%(..)/pack("c",hex($1))/ge;
    	# Associate key and value
    	$in{$key} .= "\t" if (defined($in{$key})); # \0 is the multiple separator
    	$in{$key} .= $val;
  		}
  	}
