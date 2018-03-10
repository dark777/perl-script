#!/usr/bin/perl
&ReadParse;
require "/home/virtual/www/warezplaza/cgi-bin/top.conf";

if ($in{'password'} ne $backdoorpw) {
	print "Location: ${mainurl}/\n\n";
	exit;
	}
	
# USER MODIFIABLE ELEMENTS
$sumvisitstoday			=	0;													# Do not change
$sumsenttoday			=	0;													# Do not change
$sumvisitstotal			=	0;													# Do not change
$sumsenttotal			=	0;													# Do not change

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

	$order[$count] = "$record[8]::${user}";
	$count++;
	}
	
$howmany=@order;
@order = reverse(sort num_last (@order));

print "Content-type: text/html\n\n";
print "<HTML>\n";
print "<HEAD><TITLE>${statstitle}</TITLE></HEAD>\n";

&custom($statsheader);

print "There are currently ${howmany} sites in your database.<P>\n\n";

print "<TABLE WIDTH=\"${listwidth}\" BORDER=\"${listborder}\" CELLSPACING=\"${listcellspacing}\" CELLPADDING=\"${listcellpadding}\">\n";
print "<TR>";
print "<TD COLSPAN=\"8\" BGCOLOR=\"${bgcolorofsections}\" ALIGN=\"CENTER\">\n";
print "<FONT SIZE=\"${textsizeofsections}\" COLOR=\"${textcolorofsections}\" FACE=\"${textface}\">\n";
print "$titleoftop5</FONT></TD></TR>\n";

print "<TR>\n";

print "<TD BGCOLOR=\"${listtitlebgcolor}\" ALIGN=\"LEFT\">";
print "<FONT SIZE=\"${listtitletextsize}\" COLOR=\"${listtitletextcolor}\" FACE=\"${textface}\">${ranktitle}</FONT></TD>\n";
	
print "<TD BGCOLOR=\"${listtitlebgcolor}\" ALIGN=\"CENTER\">";
print "<FONT SIZE=\"${listtitletextsize}\" COLOR=\"${listtitletextcolor}\" FACE=\"${textface}\">${sitedesctitle}</FONT></TD>\n";	

print "<TD BGCOLOR=\"${listtitlebgcolor}\" ALIGN=\"LEFT\">";
print "<FONT SIZE=\"${listtitletextsize}\" COLOR=\"${listtitletextcolor}\" FACE=\"${textface}\">${visitstitle}</FONT></TD>\n";

print "<TD BGCOLOR=\"${listtitlebgcolor}\" ALIGN=\"LEFT\">";
print "<FONT SIZE=\"${listtitletextsize}\" COLOR=\"${listtitletextcolor}\" FACE=\"${textface}\">${senttitle}</FONT></TD>\n";

print "<TD BGCOLOR=\"${listtitlebgcolor}\" ALIGN=\"LEFT\">";
print "<FONT SIZE=\"${listtitletextsize}\" COLOR=\"${listtitletextcolor}\" FACE=\"${textface}\">${visitstottitle}</FONT></TD>\n";

print "<TD BGCOLOR=\"${listtitlebgcolor}\" ALIGN=\"LEFT\">";
print "<FONT SIZE=\"${listtitletextsize}\" COLOR=\"${listtitletextcolor}\" FACE=\"${textface}\">${senttottitle}</FONT></TD>\n";

print "<TD BGCOLOR=\"${listtitlebgcolor}\" ALIGN=\"LEFT\">";
print "<FONT SIZE=\"${listtitletextsize}\" COLOR=\"${listtitletextcolor}\" FACE=\"${textface}\">${lastvisittitle}</FONT></TD>\n";

print "<TD BGCOLOR=\"${listtitlebgcolor}\" ALIGN=\"LEFT\">";
print "<FONT SIZE=\"${listtitletextsize}\" COLOR=\"${listtitletextcolor}\" FACE=\"${textface}\">${lastsenttitle}</FONT></TD>\n";

print "</TR>\n";	

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

	if ($record[8] eq "") {$record[8] = 0;}
	if ($record[9] eq "") {$record[9] = 0;}
	if ($record[12] eq "") {$record[12] = 0;}
	if ($record[13] eq "") {$record[13] = 0;}
	if ($record[14] eq "") {$record[14] = "None";}
	if ($record[10] eq "") {$record[10] = "None";}


	if ($count == 6) {
		print "<TR>";
		print "<TD COLSPAN=\"8\" BGCOLOR=\"${bgcolorofsections}\" ALIGN=\"CENTER\">\n";
		print "<FONT SIZE=\"${textsizeofsections}\" COLOR=\"${textcolorofsections}\" FACE=\"${textface}\">\n";
		print "${titleoftop6thru10}</FONT></TD></TR>\n";
		}
	
	if ($count == 11) {
		print "<TR>";
		print "<TD COLSPAN=\"8\" BGCOLOR=\"${bgcolorofsections}\" ALIGN=\"CENTER\">\n";
		print "<FONT SIZE=\"${textsizeofsections}\" COLOR=\"${textcolorofsections}\" FACE=\"${textface}\">\n";
		print "${titleoftop11thruend}</FONT></TD></TR>\n";
		}

	print "<TD BGCOLOR=\"${countcellbgcolor}\" ALIGN=\"LEFT\">";
	print "<SPACER TYPE=\"HORIZONTAL\" SIZE=\"6\">";
	print "<FONT SIZE=\"${sizeofcounttext}\" COLOR=\"${colorofcounttext}\" FACE=\"${textface}\">";
	print "<B>$count</B></FONT></TD>\n";	
		
	if ($count <= 5) {
		if (length($record[6]) > 8) {
			print "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\">";
			print "<A HREF=\"${cgiurl}/topmodify.cgi?account=${user}&password=${backdoorpw}\">${user}</A><A HREF=\"${linkurl}?${user}\"><BR>\n";
			print "<IMG SRC=\"$record[6]\" BORDER=\"0\" HEIGHT=\"${bannerheight}\" WIDTH=\"${bannerwidth}\"><BR>\n";
			print "<FONT SIZE=\"${sizeoftopitemlinktext}\" FACE=\"${textface}\"><B>$record[3]</B></FONT></A> ";
			print "<FONT SIZE=\"${sizeoftopitemtext}\" COLOR=\"${colorofitemtext}\" FACE=\"${textface}\">$record[4]</FONT></TD>\n";	
			}
		else {
			print "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\"><FONT SIZE=\"${sizeoftopitemlinktext}\" FACE=\"${textface}\">";
			print "<A HREF=\"${cgiurl}/topmodify.cgi?account=${user}&password=${backdoorpw}\">${user}</A><BR>\n";
			print "<A HREF=\"${linkurl}?${user}\"><B>$record[3]</B>";
			print "</FONT></A> <FONT SIZE=\"${sizeoftopitemtext}\" COLOR=\"${colorofitemtext}\" FACE=\"${textface}\">$record[4]</FONT></TD>\n";	
			}
		}
		
	else {
		if (($count > 5) && ($count < 11)) {
			print "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\"><FONT SIZE=\"${sizeoftopitemlinktext}\" FACE=\"${textface}\"><A HREF=\"${linkurl}?${user}\">\n";
			print "<A HREF=\"${cgiurl}/topmodify.cgi?account=${user}&password=${backdoorpw}\">${user}</A><BR>\n";
			print "<B>$record[3]</B></A></FONT>";
			print " <FONT SIZE=\"${sizeoftopitemtext}\" COLOR=\"${colorofitemtext}\" FACE=\"${textface}\">$record[4]</FONT></TD>\n";	
			}
		else {
			print "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\"><FONT SIZE=\"${sizeofitemlinktext}\" FACE=\"${textface}\">\n";
			print "<A HREF=\"${cgiurl}/topmodify.cgi?account=${user}&password=${backdoorpw}\">${user}</A><BR>\n";
			print "<A HREF=\"${linkurl}?${user}\">$record[3]</A></FONT>";
			print " <FONT SIZE=\"${sizeofitemtext}\" COLOR=\"${colorofitemtext}\" FACE=\"${textface}\">$record[4]</FONT></TD>\n";	
			}
		}

	print "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\">";
	print "<SPACER TYPE=\"HORIZONTAL\" SIZE=\"4\" ALIGN=\"LEFT\">";
	print "<FONT SIZE=\"${sizeofvisitstext}\" COLOR=\"${colorofvisitstext}\" FACE=\"${textface}\">";
	print "<B>$record[8]</B></FONT>";
	print "<SPACER TYPE=\"HORIZONTAL\" SIZE=\"4\" ALIGN=\"RIGHT\">";
	print "</TD>\n";
	
	print "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\">";
	print "<SPACER TYPE=\"HORIZONTAL\" SIZE=\"4\" ALIGN=\"LEFT\">";
	print "<FONT SIZE=\"${sizeofsenttext}\" COLOR=\"${colorofsenttext}\" FACE=\"${textface}\">";
	print "<B>$record[9]</B></FONT>";
	print "<SPACER TYPE=\"HORIZONTAL\" SIZE=\"4\" ALIGN=\"RIGHT\">";
	print "</TD>\n";

	print "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\">";
	print "<SPACER TYPE=\"HORIZONTAL\" SIZE=\"4\" ALIGN=\"LEFT\">";
	print "<FONT SIZE=\"${sizeofsenttext}\" COLOR=\"${colorofsenttext}\" FACE=\"${textface}\">";
	print "<B>$record[12]</B></FONT>";
	print "<SPACER TYPE=\"HORIZONTAL\" SIZE=\"4\" ALIGN=\"RIGHT\">";
	print "</TD>\n";

	print "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\">";
	print "<SPACER TYPE=\"HORIZONTAL\" SIZE=\"4\" ALIGN=\"LEFT\">";
	print "<FONT SIZE=\"${sizeofsenttext}\" COLOR=\"${colorofsenttext}\" FACE=\"${textface}\">";
	print "<B>$record[13]</B></FONT>";
	print "<SPACER TYPE=\"HORIZONTAL\" SIZE=\"4\" ALIGN=\"RIGHT\">";
	print "</TD>\n";

	if ($record[10] != 0) {
	($sec,$min,$hour,$mday,$mon,$year) = localtime($record[10]) ;
	$date = sprintf ("%02d/%02d/%02d
	%02d:%02d:%02d",$mday,$mon+1,$year,$hour,$min,$sec) ;
	$imagedate = sprintf ("%02d-%02d-%02d", $mon+1,$mday,$year) ;
	}
	else {
	$imagedate="None";
	}

	print "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\">";
	print "<SPACER TYPE=\"HORIZONTAL\" SIZE=\"4\" ALIGN=\"LEFT\">";
	print "<FONT SIZE=\"${sizeofsenttext}\" COLOR=\"${colorofsenttext}\" FACE=\"${textface}\">";
	print "<B>${imagedate}</B></FONT>";
	print "<SPACER TYPE=\"HORIZONTAL\" SIZE=\"4\" ALIGN=\"RIGHT\">";
	print "</TD>\n";

	if ($record[14] != 0) {
	($sec,$min,$hour,$mday,$mon,$year) = localtime($record[14]) ;
	$date = sprintf ("%02d/%02d/%02d
	%02d:%02d:%02d",$mday,$mon+1,$year,$hour,$min,$sec) ;
	$imagedate = sprintf ("%02d-%02d-%02d", $mon+1,$mday,$year) ;
	}
	else {
	$imagedate="None";
	}
	
	print "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\">";
	print "<SPACER TYPE=\"HORIZONTAL\" SIZE=\"4\" ALIGN=\"LEFT\">";
	print "<FONT SIZE=\"${sizeofsenttext}\" COLOR=\"${colorofsenttext}\" FACE=\"${textface}\">";
	print "<B>${imagedate}</B></FONT>";
	print "<SPACER TYPE=\"HORIZONTAL\" SIZE=\"4\" ALIGN=\"RIGHT\">";
	print "</TD>\n";

	print "</TR>";
	
	$sumvisitstoday += $record[8];
	$sumsenttoday	+= $record[9];
	$sumvisitstotal += $record[12];
	$sumsenttotal   += $record[13];
	$count++;
	}

print "<TR>";
print "<TD COLSPAN=\"2\" BGCOLOR=\"${bgcolorofsections}\">";
print "<FONT SIZE=\"${textsizeofsections}\" COLOR=\"${textcolorofsections}\" FACE=\"${textface}\">\n";
print "<B>TOTALS</B></FONT></TD>";
print "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\">${sumvisitstoday}</TD>";
print "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\">${sumsenttoday}</TD>";
print "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\">${sumvisitstotal}</TD>";
print "<TD BGCOLOR=\"${itemcellbgcolor}\" ALIGN=\"LEFT\">${sumsenttotal}</TD>";
print "<TD COLSPAN=\"2\" BGCOLOR=\"${bgcolorofsections}\">";
print "<PRE>  </PRE></TD>";
print "</TR>";

print "</TABLE><P>";

&custom($statsfooter);

print "</CENTER></BODY></HTML>";
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

