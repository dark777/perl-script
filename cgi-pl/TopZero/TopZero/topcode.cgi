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

require "/home/virtual/www/warezplaza/cgi-bin/top.conf";		# All variables are set in top.conf

# THIS CGI DISPLAYS WEBMASTERS THE HTML CODE FOR THEIR LINK

# Make form variables easier to deal with.
$filename	=	$in{'account'};		# Account number from topsignup.cgi
$FLK = $locks . "/" . $filename . ".lock";

&lock($FLK);
open (FILE,"${data}/${filename}");
$input=<FILE>;
close (FILE);
&unlock($FLK);

@record = split(/::/,$input);
$account=$filename;
$password=$record[7];

if ($in{'password'} ne $backdoorpw) {
	if ($in{'password'} ne $password) {die "\nHack Attempt from $ENV{REMOTE_HOST}\n";}
	}

open (FILE,"${randomlink}");
@textlinks=<FILE>;
close (FILE);

$howmany=@textlinks;
srand(time|$$);
$random = int(rand($howmany-1));


open (FILE,"${banners}");
@bannersarray=<FILE>;
close (FILE);

$numofbans=(@bannersarray);
$banrandom = int(rand($numofbans));

&head;

&custom($codeheader);

print "<TABLE BORDER=\"1\" BGCOLOR=\"${accounttablebgcolor}\" CELLPADDING=\"2\">\n";
print "<TR><TH ALIGN=\"RIGHT\"><FONT COLOR=\"${accounttabletextcolor}\">Account Number:</FONT>\n";
print "</TH><TD ALIGN=\"LEFT\"><FONT COLOR=\"${accounttabletextcolor}\">${account}</FONT></TD></TR>\n";
print "<TR><TH ALIGN=\"RIGHT\"><FONT COLOR=\"${accounttabletextcolor}\">Password:</FONT>\n";
print "</TH><TD ALIGN=\"LEFT\"><FONT COLOR=\"${accounttabletextcolor}\">${password}</FONT></TD></TR>\n</TABLE>\n";
print "<P>\n";

&custom($codesection1);

$bannersarray[$banrandom] =~ s/\n//g;

print "&lt;A HREF=&quot;${cgiurl}/topvlog.cgi?${account}&quot;&gt;\n<BR>";
print "&lt;IMG SRC=\"$bannersarray[$banrandom]\" BORDER=\"0\"&gt;&lt;BR&gt;<BR>\n";
print "@textlinks[$random]&lt;/A&gt;<P>";

&custom($codesection2);

print "<IMG SRC=\"${bannerurl}/$bannersarray[$banrandom]\"><P>";

&custom($codesection3);

print "&lt;A HREF=&quot;${cgiurl}/topvlog.cgi?${account}&quot;&gt;\n<BR>";
print "@textlinks[$random]";
print "&lt;/A&gt;<P>";

&custom($codefooter);

print "<P><FONT SIZE=\"1\">CGI &copy;1997 <A HREF=\"http://www.splitinfinity.com\">SplitInfinity</A></FONT>";
print "</TD></TR></TABLE>\n";
print $foot;
exit;

# Header Content and Page Setup
sub head {
	print "Content-type: text/html\n\n";
	print "<HTML>\n";
	print "<HEAD>\n";
	print "<TITLE>${codetitle}</TITLE>\n";
	print "</HEAD>\n";
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
    if ($ENV{'REQUEST_METHOD'} eq "GET") {
      $in = $ENV{'QUERY_STRING'};
      } elsif ($ENV{'REQUEST_METHOD'} eq "POST") {
    read(STDIN,$in,$ENV{'CONTENT_LENGTH'});
  }
  @in = split(/&/,$in);
  foreach $i (0 .. $#in) {
    $in[$i] =~ s/\+/ /g;
    ($key, $val) = split(/=/,$in[$i],2);
	($val eq "") && next;
    $key =~ s/%(..)/pack("c",hex($1))/ge;
    $val =~ s/%(..)/pack("c",hex($1))/ge;
    $in{$key} .= "\t" if (defined($in{$key}));
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

