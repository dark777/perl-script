#!/usr/bin/perl

# THIS CGI LOGS TRAFFIC FROM PROMOTERS WEB SITES TO THEIR ACCOUNTS

# Set Global Variables
$groupdirname   =       "/home/virtual/www/warezplaza/data";
$redirect               =       "http://warezplaza.com/topsites";       # URL browsers go to when link is clicked

$data                   =       "${groupdirname}/linkaccounts"; # Directory where link promoter accounts are stored
$locks                  =       "${groupdirname}/locks";                        # Location of Locks Directory (chmod 777)
$locksip                =       "${groupdirname}/lockvip";              # Location of Visits IP Locks Directory (chmod 777)
$account                =       $ENV{'QUERY_STRING'}; # Get account number from linked url
$host                   =       $ENV{'REMOTE_ADDR'};
print "Location: ${redirect}\n\n";


####### START UNIQUE HOST FILTER
$host           =~ s/\./P/g;

$FLK            =       $locks."/".$account.".iplock";  # Lock file = path to lock directory plus account + ".lock"
&lock ($FLK);   # Lock the account for exclusive use only to prevent corruption

if (-e "${locksip}/${account}.block") {
        open (FILE,"${locksip}/${account}.block");
        @blocked = <FILE>;
        close (FILE);

        foreach $ip (@blocked) {
                chop($ip);
                if ($ip eq $host) {
                        &unlock($FLK);
                        exit;}
                }
        open (FILE,">>${locksip}/${account}.block");
        print FILE "${host}\n";
        close (FILE);
        }

else {
        open (FILE,">>${locksip}/${account}.block");
        print FILE "${host}\n";
        close (FILE);
        }
&unlock($FLK);
#######  END UNIQUE HOST FILTER

$FLK            =       $locks."/".$account.".lock";    # Lock file = path to lock directory plus account + ".lock"
&lock ($FLK);   # Lock the account for exclusive use only to prevent corruption

unless (open (FILE,"${data}/${account}"))
        {
        &unlock ($FLK);
        exit;}

$input=<FILE>;
close (FILE);
@array=split(/::/,$input);

if (($array[5] eq '') | ($array[5] !~ /http/)) {
        &unlock ($FLK);
        exit;}

$array[8]++;                    # Increment visits today
$array[12]++;                   # Increment visits total
$array[10] = time();    # Get time of last visit

# Create their account record
$output = join("::",@array);

unless (open (FILE,">${data}/${account}")) {
        &unlock ($FLK);
        exit;}

print FILE $output,"\n";
close (FILE);
&unlock ($FLK);
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

