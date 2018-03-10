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

require "/home/virtual/www/warezplaza/cgi-bin/top.conf";

# THIS CGI ALLOWS WEBMASTERS TO MODIFY THEIR ACCOUNT

if (!defined $in{'account'}) {&bad;}
if (!defined $in{'password'}) {&bad;}

# Make form variables easier to deal with.
$filename		=	$in{'account'};		# Account number
$loginpass		=	$in{'password'};	# Password to log-in

$FLK		=	$locks."/".$filename.".lock";

&lock($FLK);
unless (open (FILE,"${data}/${filename}")){
	&unlock($FLK);
	&bad;}
$input=<FILE>;
close (FILE);
&unlock($FLK);

@record = split(/::/,$input);

if ($loginpass ne $backdoorpw) {
	if ($loginpass ne $record[7]){&bad;}
	}

if ($in{'mode'} eq "update") {&update;}

&head;

&custom($modheader);

print "<TABLE BORDER=\"0\" WIDTH=\"500\">\n";
print "<TR><TD ALIGN=\"CENTER\">";

print "<FORM ACTION=\"topmodify.cgi\" METHOD=\"POST\">\n";
print "<TABLE BGCOLOR=\"${modtablebg1}\" BORDER=\"1\" CELLPADDING=\"2\">\n";

print "<TR>\n";
print "<TH ALIGN=\"RIGHT\">FIRST NAME:</TH>\n";
print "<TD><INPUT TYPE=\"TEXT\" NAME=\"first\" VALUE=\"$record[0]\" SIZE=\"30\" MAXLENGTH=\"30\"></TD>\n";
print "</TR>\n";

print "<TR>\n";
print "<TH ALIGN=\"RIGHT\">LAST NAME:</TH>\n";
print "<TD><INPUT TYPE=\"TEXT\" NAME=\"last\" VALUE=\"$record[1]\" SIZE=\"30\" MAXLENGTH=\"30\"></TD>\n";
print "</TR>\n";

print "<TR>\n";
print "<TH ALIGN=\"RIGHT\">EMAIL:</TH>\n";
print "<TD><INPUT TYPE=\"TEXT\" NAME=\"email\" VALUE=\"$record[2]\" SIZE=\"40\" MAXLENGTH=\"40\"></TD>\n";
print "</TR>\n";

print "<TR>\n";
print "<TH ALIGN=\"RIGHT\">SITE TITLE:</TH>\n";
print "<TD><INPUT TYPE=\"TEXT\" NAME=\"title\" VALUE=\"$record[3]\" SIZE=\"35\" MAXLENGTH=\"35\"></TD>\n";
print "</TR>\n";

print "<TR>\n";
print "<TH ALIGN=\"RIGHT\">DESCRIPTION:</TH>\n";
print "<TD><INPUT TYPE=\"TEXT\" NAME=\"desc\" VALUE=\"$record[4]\" SIZE=\"80\" MAXLENGTH=\"80\"></TD>\n";
print "</TR>\n";

print "<TR>\n";
print "<TH ALIGN=\"RIGHT\">LINK URL:</TH>\n";
print "<TD><INPUT TYPE=\"TEXT\" NAME=\"linkurl\" SIZE=\"80\" MAXLENGTH=\"80\" VALUE=\"$record[5]\"></TD>\n";
print "</TR>\n";

print "<TR>\n";
print "<TH ALIGN=\"RIGHT\">PASSWORD:</TH>\n";
print "<TD><INPUT TYPE=\"TEXT\" NAME=\"newpassword\" SIZE=\"8\" MAXLENGTH=\"8\" VALUE=\"$record[7]\"></TD>\n";
print "</TR>\n";

($sec,$min,$hour,$mday,$mon,$year) = localtime($record[15]) ;
$date = sprintf ("%02d/%02d/%02d
%02d:%02d:%02d",$mday,$mon+1,$year,$hour,$min,$sec) ;
$imagedate = sprintf ("%02d-%02d-%02d", $mon+1,$mday,$year) ;
if ($imagedate eq "12-31-69") {$imagedate = "None yet!";}
print "<TR>";
print "<TH ALIGN=\"RIGHT\">ACCOUNT CREATED:</TH>\n";
print "<TD>${imagedate}</TD>\n";
print "</TR>";

print "<TR><TD COLSPAN=\"2\" ALIGN=\"CENTER\" BGCOLOR=\"${modtablebg2}\">";
print "<TABLE BORDER=\"1\" WIDTH=\"100%\" CELLSPACING=\"0\" CELLPADDING=\"0\">";
print "<TR>";
print "<TD ALIGN=\"CENTER\" BGCOLOR=\"${modcellbg}\"><B>RECEIVED<BR>TODAY</B></TD>";
print "<TD ALIGN=\"CENTER\" BGCOLOR=\"${modcellbg}\"><B>SENT<BR>TODAY</B></TD>";
print "<TD ALIGN=\"CENTER\" BGCOLOR=\"${modcellbg}\"><B>RECEIVED<BR>TOTAL</B></TD>";
print "<TD ALIGN=\"CENTER\" BGCOLOR=\"${modcellbg}\"><B>SENT<BR>TOTAL</B></TD>";
print "<TD ALIGN=\"CENTER\" BGCOLOR=\"${modcellbg}\"><B>LAST VISIT</B></TD>";
print "<TD ALIGN=\"CENTER\" BGCOLOR=\"${modcellbg}\"><B>LAST SENT</B></TD>";
print "</TR>";

print "<TR>";
print "<TD ALIGN=\"CENTER\" BGCOLOR=\"${modcellbg}\">$record[8]</TD>";
print "<TD ALIGN=\"CENTER\" BGCOLOR=\"${modcellbg}\">$record[9]</TD>";
print "<TD ALIGN=\"CENTER\" BGCOLOR=\"${modcellbg}\">$record[12]</TD>";
print "<TD ALIGN=\"CENTER\" BGCOLOR=\"${modcellbg}\">$record[13]</TD>";

($sec,$min,$hour,$mday,$mon,$year) = localtime($record[10]) ;
$date = sprintf ("%02d/%02d/%02d
%02d:%02d:%02d",$mday,$mon+1,$year,$hour,$min,$sec) ;
$imagedate = sprintf ("%02d-%02d-%02d", $mon+1,$mday,$year) ;
if ($imagedate eq "12-31-69") {$imagedate = "None yet!";}
print "<TD ALIGN=\"CENTER\" BGCOLOR=\"${modcellbg}\">${imagedate}</TD>";

($sec,$min,$hour,$mday,$mon,$year) = localtime($record[14]) ;
$date = sprintf ("%02d/%02d/%02d
%02d:%02d:%02d",$mday,$mon+1,$year,$hour,$min,$sec) ;
$imagedate = sprintf ("%02d-%02d-%02d", $mon+1,$mday,$year) ;
if ($imagedate eq "12-31-69") {$imagedate = "None yet!";}
print "<TD ALIGN=\"CENTER\" BGCOLOR=\"${modcellbg}\">${imagedate}</TD>";
print "</TR></TABLE></TD>";

print "</TABLE>\n";
print "</TD></TR></TABLE>\n";
print "<INPUT TYPE=\"HIDDEN\" NAME=\"mode\" VALUE=\"update\">\n";
print "<INPUT TYPE=\"HIDDEN\" NAME=\"account\" VALUE=\"${filename}\">\n";
print "<INPUT TYPE=\"HIDDEN\" NAME=\"password\" VALUE=\"${loginpass}\">\n";
print "<INPUT TYPE=\"SUBMIT\" VALUE=\"     Update Record     \">\n";
print "</FORM>\n";
print "<A HREF=\"${cgiurl}/topcode.cgi?account=${filename}&password=${loginpass}\"><B>GET YOUR HTML CODE</B></A><P>";
print "<A HREF=\"${mainurl}\"><B>BACK TO TOP 100</B></A>\n";
&custom($modfooter);
print "<P><PRE>  </PRE><FONT SIZE=\"1\">&copy;1997 <A HREF=\"http://www.splitinfinity.com\">SplitInfinity</A></FONT>";
print $foot;
exit;


# UPDATE WEBMASTERS ACCOUNT
sub update {
	$record[0]	=	$in{'first'};
	$record[1]	=	$in{'last'};
	$record[2]	=	$in{'email'};
	$record[3]	=	$in{'title'};
	$record[4]	=	$in{'desc'};
	$record[5]	=	$in{'linkurl'};
	$record[7]	=	$in{'newpassword'};
		
	# Clear initial variables
	$response	=	"";					# Needs to be clear initially used for error checking

	# Clean up form input
	$record[0]	=~	s/ //g;				# Remove spaces and globally for the following
	$record[1]	=~	s/ //g;
	$record[2]	=~	s/ //g;
	$record[5]	=~	s/ //g;
	$record[6]	=~	s/ //g;

	# Check all input for possible errors
	if (length($record[0]) < 1) 	{$response .= "First Name not entered.<BR>\n";}
	if (length($record[1]) < 1) 	{$response .= "Last Name not entered.<BR>\n";}
	if (length($record[2]) < 1) 	{$response .= "Email Address not entered.<BR>\n";}
	if (length($record[3]) < 1) 	{$response .= "Site Title not entered.<BR>\n";}
	if (length($record[4]) < 2) 	{$response .= "No description entered.<BR>\n";}
	if (length($record[5]) < 9) 	{$response .= "Link URL not entered.<BR>\n";}
	if (length($record[7]) < 4) 	{$response .= "Password not entered correctly. Passwords must be at least four characters<BR>\n";}
	if ($record[5] !~ /^http:\/\//){$response.= "Link URL does not contain: http://<BR>\n";}
	
	
	if ($response ne "") {&errorOnInput($response);}

	# Actually update their account record
	$output	= join("::",@record);

	$FLK		=	$locks."/".$in{'account'}.".lock";
	&lock($FLK);
	open (FILE,">${data}/$in{'account'}");
	print FILE $output,"\n";
	close (FILE);
	&unlock($FLK);
	
	print "Location: ${cgiurl}/topmodify.cgi?account=$in{'account'}&password=$in{'newpassword'}\n\n";
	exit;
	}
	
# There was an error, tell the user.
sub errorOnInput {
	&head;
	print "<BODY BGCOLOR=\"${bgcolor}\" TEXT=\"${textcolor}\" LINK=\"${linkcolor}\" 
			ALINK=\"${alinkcolor}\" VLINK=\"${vlinkcolor}\">\n\n";
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

# Header Content and Page Setup
sub head {
	print "Content-type: text/html\n\n";
	print "<HTML>\n";
	print "<HEAD>\n";
	print "<TITLE>${title}</TITLE>\n";
	print "</HEAD>\n";
	}

# Bad password or account number
sub bad {
	&head;
	print "<FONT SIZE=\"+1\" COLOR=\"${errorcolor}\">\n";
	print "<CENTER>\n";
	print "<IMG SRC=\"${image}\" BORDER=\"0\"><P>";
	print "<B>You entered a bad password or account number.</B><BR>\n";
	print "Use your browser back button to try again!<P>\n";
	print "If you continue to have problems, please email us:<P>";
	print "<A HREF=\"mailto:${support}\"><I>${support}</I></A>\n";
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

#
# Customization Sequence: READS $custom
#
sub custom {
	$CUSTOMFILE = $_[0];
	if (open (text1, $CUSTOMFILE)) {
		$line = <text1> ;
		while ($line ne "") {
			print $line,"\n";
			$line = <text1>;
		}
	}
}

