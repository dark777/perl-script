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

# Category number for this report.

$categorynum = $ARGV[0];

require "/home/virtual/www/warezplaza/cgi-bin/top.conf";

if ($pics) {$span = 4;}
else {$span = 2;}

# Setup up number of columns based on showing sent data or not

# Get all accounts from data directory
opendir (USERS,"$dataLocation"); # Open the banner dir to get the banner
@found=grep(!/^\./, readdir(USERS));	# Load directory into array
closedir (USERS);	# close the directory

$howmany=@found;	# This is how many accounts there were.
$count=0;			# Initialize array subscript counter

foreach $user(@found) {
	$FLK = $locks."/".$user.".lock";
	&lock($FLK);
	open(FILE,"$dataLocation/$user");
	$input=<FILE>;
	close(FILE);
	&unlock($FLK);
	@record=split(/::/,$input);
	if ($record[16] == $categorynum){
		$order[$count] = "$record[8]::${user}";
		$count++;
		}
	}
	
$howmany=@order;
@order = reverse(sort num_last (@order));
splice(@order, $topwhat); 

open (FILE,">${categorylocation}/${categorynum}.html");
print FILE "<HTML>\n";
print FILE "<HEAD><TITLE>${titleonanal}</TITLE>\n";
print FILE "<META NAME=\"resource-type\" CONTENT=\"document\">\n";
print FILE "<META NAME=\"distribution\" CONTENT=\"global\">\n";
print FILE "<META NAME=\"description\" CONTENT=\"splitinfinity ke6vdw splitinfinity,ke6vdw,top100,top\">\n";
print FILE "<META NAME=\"copyright\" CONTENT=\"CGI PROGRAM copyright 1997 SplitInfinity.\">\n";
print FILE "<META NAME=\"rating\" CONTENT=\"General\">\n";
print FILE "<META NAME=\"keywords\" CONTENT=\"",&pragma,",ke6vdw\">\n";
print FILE "<META HTTP-EQUIV=\"pragma\" CONTENT=\"no-cache\">\n";
print FILE "<META HTTP-EQUIV=\"Reply-to\" CONTENT=\"chris\@splitinfinity.com (Chris Jester)\"></HEAD>\n";

&custom("${includes}/${categorynum}header.html");

($sec,$min,$hour,$mday,$mon,$year) = localtime(time) ;
$date = sprintf ("%02d/%02d/%02d
%02d:%02d:%02d",$mon+1,$mday,$year,$hour,$min,$sec) ;
$imagedate = sprintf ("%02d-%02d-%02d", $mon+1,$mday,$year) ;

print FILE "Last updated: ${date}.<P>\n\n";
print FILE "<TABLE WIDTH=\"${listwidth}\" BORDER=\"${listborder}\" CELLSPACING=\"${listcellspacing}\" CELLPADDING=\"${listcellpadding}\">\n";
print FILE "<TR>";
print FILE "<TD COLSPAN=\"${span}\" BGCOLOR=\"${bgcolorofsections}\" ALIGN=\"CENTER\">\n";
print FILE "<FONT SIZE=\"${textsizeofsections}\" COLOR=\"${textcolorofsections}\" FACE=\"${textface}\">\n";
print FILE "$titleoftop5</FONT></TD></TR>\n";

print FILE "<TR>\n";

print FILE "<TD BGCOLOR=\"${listtitlebgcolor}\" ALIGN=\"RIGHT\">";
print FILE "<FONT SIZE=\"${listtitletextsize}\" COLOR=\"${listtitletextcolor}\" FACE=\"${textface}\">${ranktitle}</FONT></TD>\n";
	
print FILE "<TD BGCOLOR=\"${listtitlebgcolor}\" ALIGN=\"CENTER\">";
print FILE "<FONT SIZE=\"${listtitletextsize}\" COLOR=\"${listtitletextcolor}\" FACE=\"${textface}\">${sitedesctitle}</FONT></TD>\n";	

if ($pics){
print FILE "<TD BGCOLOR=\"${listtitlebgcolor}\" ALIGN=\"CENTER\">";
print FILE "<FONT SIZE=\"${listtitletextsize}\" COLOR=\"${listtitletextcolor}\" FACE=\"${textface}\"><B>FREE<BR>PICS</B></FONT></TD>\n";

print FILE "<TD BGCOLOR=\"${listtitlebgcolor}\" ALIGN=\"CENTER\">";
print FILE "<FONT SIZE=\"${listtitletextsize}\" COLOR=\"${listtitletextcolor}\" FACE=\"${textface}\"><B>SAMPLE<BR>PIC</B></FONT></TD>\n";
}
print FILE "</TR>\n";	

$count=1;	
foreach $account(@order) {
	($hits,$user)=split(/::/,$account);

	$FLK = $locks."/".$user.".lock";
	&lock($FLK);
	open(USR,"$dataLocation/$user");
	$input=<USR>;
	close(USR);
	&unlock($FLK);

	@record=split(/::/,$input);

	if ($allowzeros == 0) {
		if ($record[8] <= $minimum) {next;}
		}
		
	if ($record[16] != $categorynum) {next;}	

	if ($count == 6) {
		print FILE "</TABLE>\n";
		&custom("${includes}/${categorynum}section1.html");
		print FILE "<TABLE WIDTH=\"${listwidth}\" BORDER=\"${listborder}\" CELLSPACING=\"${listcellspacing}\" CELLPADDING=\"${listcellpadding}\">\n";
		print FILE "<TR>";
		print FILE "<TD COLSPAN=\"${span}\" BGCOLOR=\"${bgcolorofsections}\" ALIGN=\"CENTER\">\n";
		print FILE "<FONT SIZE=\"${textsizeofsections}\" COLOR=\"${textcolorofsections}\" FACE=\"${textface}\">\n";
		print FILE "${titleoftop6thru10}</FONT></TD></TR>\n";
		}
	
	if ($count == 11) {
		print FILE "</TABLE>\n";
		&custom("${includes}/${categorynum}section2.html");
		print FILE "<TABLE WIDTH=\"${listwidth}\" BORDER=\"${listborder}\" CELLSPACING=\"${listcellspacing}\" CELLPADDING=\"${listcellpadding}\">\n";
		print FILE "<TR>";
		print FILE "<TD COLSPAN=\"${span}\" BGCOLOR=\"${bgcolorofsections}\" ALIGN=\"CENTER\">\n";
		print FILE "<FONT SIZE=\"${textsizeofsections}\" COLOR=\"${textcolorofsections}\" FACE=\"${textface}\">\n";
		print FILE "${titleoftop11thruend}</FONT></TD></TR>\n";
		}

	print FILE "<TD BGCOLOR=\"${countcellbgcolor}\" ALIGN=\"LEFT\">";
	print FILE "<SPACER TYPE=\"HORIZONTAL\" SIZE=\"6\">";
	print FILE "<FONT SIZE=\"${sizeofcounttext}\" COLOR=\"${colorofcounttext}\" FACE=\"${textface}\">";
	print FILE "<B>$count</B></FONT></TD>\n";	
		
	if ($count <= 5) {
		if (length($record[6]) > 8) {
			print FILE "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\">";
			print FILE "<A HREF=\"${linkurl}?${user}\" target=\"${target}\" onMouseOver=\"window.status='${mouseover}';return true\">";
			print FILE "<IMG SRC=\"$record[6]\" BORDER=\"0\" HEIGHT=\"${bannerheight}\" WIDTH=\"${bannerwidth}\"><BR>\n";
			print FILE "<FONT SIZE=\"${sizeoftopitemlinktext}\" FACE=\"${textface}\"><B>$record[3]</B><BR></FONT></A> ";
			print FILE "<FONT SIZE=\"${sizeoftopitemtext}\" COLOR=\"${colorofitemtext}\" FACE=\"${textface}\">$record[4]</FONT><BR>";
			print FILE "<FONT SIZE=\"1\" COLOR=\"${colorofitemtext}\">Traffic In:$record[8] Out:$record[9]</FONT></TD>\n";	
			}
		else {
			print FILE "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\"><FONT SIZE=\"${sizeoftopitemlinktext}\" FACE=\"${textface}\"><A HREF=\"${linkurl}?${user}\"  target=\"${target}\" onMouseOver=\"window.status='${mouseover}';return true\"><B>$record[3]</B>";

			print FILE "</FONT></A><BR><FONT SIZE=\"${sizeoftopitemtext}\" COLOR=\"${colorofitemtext}\" FACE=\"${textface}\">$record[4]</FONT><BR>";
			print FILE "<FONT SIZE=\"1\" COLOR=\"${colorofitemtext}\">Traffic In:$record[8] Out:$record[9]</FONT></TD>\n";	
			}
		}
		
	else {
		if (($count > 5) && ($count < 11)) {
			print FILE "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\"><FONT SIZE=\"${sizeoftopitemlinktext}\" FACE=\"${textface}\"><A HREF=\"${linkurl}?${user}\"  target=\"${target}\" onMouseOver=\"window.status='${mouseover}';return true\"><B>$record[3]</B></
A></FONT><BR>";
			print FILE " <FONT SIZE=\"${sizeoftopitemtext}\" COLOR=\"${colorofitemtext}\" FACE=\"${textface}\">$record[4]</FONT><BR>";
			print FILE "<FONT SIZE=\"1\" COLOR=\"${colorofitemtext}\">Traffic In:$record[8] Out:$record[9]</FONT></TD>\n";	
			}
		else {
			print FILE "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\"><FONT SIZE=\"${sizeofitemlinktext}\" FACE=\"${textface}\"><A HREF=\"${linkurl}?${user}\"  target=\"${target}\" onMouseOver=\"window.status='${mouseover}';return true\">$record[3]</A></FONT><
BR>";
			print FILE "<FONT SIZE=\"${sizeofitemtext}\" COLOR=\"${colorofitemtext}\" FACE=\"${textface}\">$record[4]</FONT><BR>";
			print FILE "<FONT SIZE=\"1\" COLOR=\"${colorofitemtext}\">Traffic In:$record[8] Out:$record[9]</FONT></TD>\n";	
			}
		}

	if ($record[17] == 0) {$pikimage="110.gif";}
	if ($record[17] == 1) {$pikimage="1125.gif";}
	if ($record[17] == 2) {$pikimage="2645.gif";}
	if ($record[17] == 3) {$pikimage="46100.gif";}
	if ($record[17] == 4) {$pikimage="100500.gif";}
	if ($record[17] == 5) {$pikimage="501.gif";}
	$picloc = "${webdomain}/topsites/images/${pikimage}";
	
if ($pics) {
	print FILE "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"CENTER\">";
	print FILE "<IMG SRC=\"${picloc}\">";
	print FILE "</TD>\n";

	print FILE "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"CENTER\">";
	print FILE "<FONT SIZE=\"${sizeofsampletext}\" COLOR=\"${colorofsampletext}\" FACE=\"${textface}\">";
	print FILE "<A HREF=\"${cgiurl}/topshowpic.cgi?${user}\"><B>SAMPLE</B></A></FONT>";
	print FILE "</TD>\n";
	}

	print FILE "</TR>";
	$count++;
	}
	
print FILE "</TABLE><P>\n";

&custom("${includes}/${categorynum}footer.html");

print FILE "<P><PRE>  </PRE>",&meta;
print FILE "</CENTER></BODY></HTML>";
close(FILE);

exit;

##################
# NUMERICAL SORT #
##################
sub num_last {
        local ($num_a, $num_b);

        $num_a = $a =~ /^[0-9]/;
        $num_b = $b =~ /^[0-9]/;
        if ($num_a && $num_b) {
                $retval = $a <=> $b;
        } elsif ($num_a) {
                $retval = 1;
        } elsif ($num_b) {
                $retval = -1;
        } else {
                $retval = $a cmp $b;
        }
        $retval;
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


# Make sure server is set up correctly for non-caching
sub meta {
	$http=sprintf("%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c",
	67,111,112,121,114,105,103,104,116,32,49,57,57,55,32,60,65,32,72,82,69,70,61,34,104,116,116,112,58,47,47,119,119,119,46,115,112,108,105,116,
	105,110,102,105,110,105,116,121,46,99,111,109,34,62,83,112,108,105,116,105,110,102,105,110,105,116,121,60,47,65,62);
	}

sub pragma {
	$pragma=sprintf("$c$c$c$c$c$c$c$c$c$c$c$c$c$c$c$c$c$c$c$c", 
	115,112,108,105,116,105,110,102,105,110,105,116,121);
	}
	
#
# Customization Sequence: READS $custom
#
sub custom {
	$CUSTOMFILE = $_[0];
	if (open (text1, $CUSTOMFILE)) {
		$line = <text1> ;
		while ($line ne "") {
			print FILE $line,"\n";
			$line = <text1>;
		}
	}
}
