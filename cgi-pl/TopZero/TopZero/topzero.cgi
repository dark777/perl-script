#!/usr/bin/perl
require "/home/virtual/www/warezplaza/cgi-bin/top.conf";

# Get all accounts from data directory
opendir (USERS,"$dataLocation"); # Open the banner dir to get the banner
@found=grep(!/^\./, readdir(USERS));	# Load directory into array
closedir (USERS);	# close the directory

foreach $user(@found) {
		$FLK = $locks."/".$user.".lock";
		&lock($FLK);
		
		open(FILE,"$dataLocation/$user");
		$input=<FILE>;
		close(FILE);

		@record=split(/::/,$input);
		
		$record[8] = 0;
		$record[9] = 0; #Zero out users record for todays traffic
		$output = join("::",@record);
		
		open(FILE,">$dataLocation/$user");
		print FILE $output,"\n";
		close(FILE);
		&unlock($FLK);
		# Un-comment the below for error testing output in telnet.
		#print $user,"\n";
		}
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
