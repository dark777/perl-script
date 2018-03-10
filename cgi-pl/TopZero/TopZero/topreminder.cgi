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

require "/home/virtual/www/warezplaza/cgi-bin/top.conf";

# First, get all the category names. omitting the . and .. directories.
opendir (CATS,"${data}"); # Open the base image dir to get the newsgroup categories
@found=grep(!/^\./, readdir(CATS));	# Load directory into array
closedir (CATS);	# close the directory

open (LETTER,"$letter");
@content=<LETTER>;
close (LETTER);
$sentout = "";

foreach $account (@found) 
	{
	$FLK		=	$locks."/".$account.".lock";	# Lock file = path to lock directory plus account + ".lock"
	&lock ($FLK);	# Lock the account for exclusive use only to prevent corruption
	open (FILE,"$data/$account");
	$input=<FILE>;
	close (FILE);
	@array=split(/::/,$input);
	
	if ((time()-$array[15]) > 172800 && (substr ($array[11],0,1) ne "1")) {
		if ($array[12] == 0) 
			{
			$outmail = join("",@content);
			
			# Format date the account was created correctly
			($sec,$min,$hour,$mday,$mon,$year) = localtime($array[15]) ;	
			$imagedate = sprintf ("%02d-%02d-%02d", $mon+1,$mday,$year) ;

			$oldemail = $array[2];
			$array[2] =~ s/\@/\\\@/g;
			
			$outmail =~ s/<<FIRSTNAME>>/$array[0]/gi;
			$outmail =~ s/<<CREATED>>/$imagedate/gi;
			$outmail =~ s/<<ACCOUNT>>/$account/gi;
			$outmail =~ s/<<PASSWORD>>/$array[7]/gi;				
			$outmail =~ s/<<SENT>>/$array[13]/gi;
			$outmail =~ s/<<LINKURL>>/$array[5]/gi;
			$outmail =~ s/<<TITLE>>/$array[3]/gi;
			$outmail =~ s/<<EMAIL>>/$array[2]/gi;
						
			open (MAIL,"|mail -s \"Your Top100 Account\" $array[2]");
			print MAIL $outmail;
			close (MAIL);
			$sentout .= $account . "\t\t" . $array[3] . "\n";
			
			substr ($array[11],0,1) = "1";
			$array[2]=$oldemail;
			
			if (($array[5] eq '') | ($array[5] !~ /http/)) {
				&unlock ($FLK);
				exit;}
										
			$output = join("::",@array);
				
			open (RECORD,">${data}/${account}");
			print RECORD $output,"\n";
			select(RECORD);
			#$|=1;
			print $output,"\n";
			close (RECORD);
			}
		}

	&unlock ($FLK);
	}

open (MAIL,"|mail -s \"**REMINDERS**\" ${webmaster}");
print MAIL "WEBMASTER- Top 100 reminders were sent to the following accounts:\n\n";
print MAIL $sentout;
close (MAIL);

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

