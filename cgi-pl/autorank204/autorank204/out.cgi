#!/usr/bin/perl
###########################
##  AutoRank Pro v2.0.4  ##
###################################################################################
##  out.cgi                                                                      ##
##  -------                                                                      ##
##  This script controls the counting of outgoing hits from the list.            ##
###################################################################################

#use strict;
package OUT;

### Set this variable
$OUT::SCRIPT_DATA_DIR = "/usr/local/etc/httpd/htdocs/bettors/arp/sdata";

###################################################################################
#                    DONE EDITING THIS FILE - CHANGE NO MORE                      # 
###################################################################################
#  If any more editing is done to this file the minimum penalty will              #
#  be loss of technical support from CGI Works.  Editing of any script            #
#  can also result in a copyright violation.  Do NOT do it unless you             #
#  have received permission directly from CGI Works to do so!                     #
###################################################################################

OUT::problem("Could not load the variables file") unless(-e "$OUT::SCRIPT_DATA_DIR/variables.dat");

require "$OUT::SCRIPT_DATA_DIR/variables.dat";

&giveOutHit($ENV{'QUERY_STRING'});
exit;

sub giveOutHit {
  my($id) = shift;
  if(-e "$VARIABLES::MEMBER_DATA_DIR/$id.mdf") {
    open(DATA, "+<$VARIABLES::MEMBER_DATA_DIR/$id.mdf") || OUT::problem("Could not open member datafile");
    flock(DATA, 2);
    my ($in, $out, $totalIn, $inactive, $url, $title, $descrip, $email, $banner, $password) = split(/\|/, <DATA>);
    $out++;
    truncate(DATA, 0);
    seek(DATA, 0, 0);
    print DATA "$in|$out|$totalIn|$inactive|$url|$title|$descrip|$email|$banner|$password";
    close(DATA);

    print "Location: $url\n\n";  
  }
  else {
    print "Content-type: text/html\n\n";
    print "No member exists with that ID!";
  }
}

sub problem {
  my $description = shift;
  print "Content-type: text/html\n\n";
  print "$description\n";
  print "$!";
  exit;
}
