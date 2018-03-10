#!/usr/bin/perl
###########################
##  AutoRank Pro v2.0.4  ##
###################################################################################
##  cron_rs.cgi                                                                  ##
##  -----------                                                                  ##
##  This script controls the cron resets of the list.                            ##
###################################################################################

#use strict;
package RESET;

### Set this variable
$RESET::SCRIPT_DATA_DIR = "/home/thenat/cgi-bin/rankem/sdata";

###################################################################################
#                    DONE EDITING THIS FILE - CHANGE NO MORE                      # 
###################################################################################
#  If any more editing is done to this file the minimum penalty will              #
#  be loss of technical support from CGI Works.  Editing of any script            #
#  can also result in a copyright violation.  Do NOT do it unless you             #
#  have received permission directly from CGI Works to do so!                     #
###################################################################################

require "$RESET::SCRIPT_DATA_DIR/variables.dat";

&reset;
exit;

sub reset {
  my $file;
  opendir(MEMBER_DIR, "$VARIABLES::MEMBER_DATA_DIR");
  my @member_files = sort(grep { m/.*\.mdf/ } readdir(MEMBER_DIR));
  closedir(MEMBER_DIR);  

  for $file (@member_files) {
    open(DATA, "+<$VARIABLES::MEMBER_DATA_DIR/$file");
    flock(DATA, 2);
    my ($in, $out, $totalIn, $inactive, $url, $title, $descrip, $email, $banner, $password) = split(/\|/, <DATA>);
    $inactive++ unless($in);
    truncate(DATA, 0);
    seek(DATA, 0, 0);
    print DATA "0|0|$totalIn|$inactive|$url|$title|$descrip|$email|$banner|$password|";
    close(DATA);
    
    $file =~ s/\.mdf/\.idf/gi;
        
    open(IPLOG, ">$VARIABLES::MEMBER_DATA_DIR/$file");
    close(IPLOG);
  }
}
