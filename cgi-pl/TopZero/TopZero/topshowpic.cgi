#!/usr/bin/perl
require "/home/virtual/www/warezplaza/cgi-bin/top.conf";
$account	=	$ENV{'QUERY_STRING'};

$FLK = $locks."/".$account.".lock";
&lock($FLK);
open(FILE,"$dataLocation/$account");
$input=<FILE>;
close(FILE);
&unlock($FLK);
@record=split(/::/,$input);

print "Content-type: text/html\n\n";
&custom("$picheader");
if ($record[18] ne "NONE") {
	print "<IMG SRC=\"$record[18]\"><P>";
	print "<h3>THIS PICTURE IS SPONSORED BY:</h3><P>";}
else {
	print "<h3>This site did not provide a sample pic.<BR>";
	print "You might find sample pics for this site at<BR>";
	print "the link below.</h3><P>";
	}
	

print "<A HREF=\"${linkurl}?${account}\">$record[3]</A><BR>";
print "$record[4]<P>";
print "FOR MORE FREE PICS, CLICK <A HREF=\"${linkurl}?${account}\">HERE</A>";
&custom("$picfooter");
exit;


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
