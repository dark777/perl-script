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

# THIS CGI LOGS TRAFFIC TO PROMOTERS WEB SITES FROM THEIR LISTINGS ON THE TOP LIST

# Set Global Variables
$groupdirname   =       "/home/virtual/www/warezplaza/data";

$data           =       "${groupdirname}/linkaccounts"; # Directory where link promoter accounts are stored
$locks          =       "${groupdirname}/locks";                        # Location of Locks Directory (chmod 777)
$locksip        =       "${groupdirname}/locksip";              # Location of Locks Directory (chmod 777)

$account        =       $ENV{'QUERY_STRING'}; # Get account number from linked url
$host           =       $ENV{'REMOTE_ADDR'};  # Remote IP number
$host           =~ s/\./P/g;
$found = 0;

####### START UNIQUE HOST FILTER
$FLK            =       $locks."/".$account.".iplock";  # Lock file = path to lock directory plus account + ".lock"
&lock ($FLK);   # Lock the account for exclusive use only to prevent corruption

if (-e "${locksip}/${account}.block") {
        open (FILE,"${locksip}/${account}.block");
        @blocked = <FILE>;
        close (FILE);

        foreach $ip (@blocked) {
                chop($ip);
                if ($ip eq $host) {
                        $found = 1;
                        last;}
                }
        if ($found == 0) {
                open (FILE,">>${locksip}/${account}.block");
                print FILE "${host}\n";
                close (FILE);
                }
        }

else {
        if ($found==0) {
                open (FILE,">>${locksip}/${account}.block");
                print FILE "${host}\n";
                close (FILE);
                }
        }

&unlock($FLK);

#######  END UNIQUE HOST FILTER

        $FLK            =       $locks."/".$account.".lock";    # Lock file = path to lock directory plus account + ".lock"
        &lock ($FLK);   # Lock the account for exclusive use only to prevent corruption

        unless (open (FILE,"${data}/${account}"))
                {
                &unlock ($FLK);
                die "Splitinfinity Error #001";}

        $input=<FILE>;
        close (FILE);
        @array=split(/::/,$input);

        if (($array[5] eq '') | ($array[5] !~ /http/)) {
        &unlock ($FLK);
        exit;}

        $array[9]++;                    # Increment sent today total
        $array[13]++;                   # Increment sent sum total
        $array[14] = time();    # Get time of last sent
        $redirect=$array[5];    # Get url to send user to

if ($found==0) {
        # Create their account record
        $output = join("::",@array);

        #$|=1;
        unless (open (FILE,">${data}/${account}")) {
                &unlock ($FLK);
                die "Splitinfinity Error #002";}

        print FILE $output,"\n";
        close (FILE);
        #$|=0;
}
&unlock ($FLK);
print "Location: ${redirect}\n\n";
exit;

####################################################
# REPLACEMENT LOCKING ROUTINE BECAUSE FLOCK SUCKS! #
####################################################
sub lock{
        $LOCKFILE = $_[0];
        if (-e $LOCKFILE){
                while (-e $LOCKFILE)
                {
                $count++;
                sleep 1;
                if ($count > 100) {die "Could not unlock lock file ${LOCKFILE}\n";}
                }
        }
        open (LOCK,">$LOCKFILE");
        print (LOCK "busy");
        close (LOCK);
        }       # end lock

sub unlock
{ $LOCKFILE = $_[0];
  if (-e $LOCKFILE)
  { unlink ($LOCKFILE);
  }
} # end lock
