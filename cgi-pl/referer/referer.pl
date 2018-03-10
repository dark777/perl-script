#!/usr/local/bin/perl
#####################
# Referal Count 1.0
#
# By Command-O Software
# http://www.command-o.com
#
# Copyright 1996
# All Rights Reserved
#
#If you find this script useful, we would appreciate a 
#donation to keep this service active for the community.
#Command-O Software, P.O. Box 12200, Jackson WY 83002
#####################
# Set Variables:

$referer_log = "/usr/home/commando/usr/local/etc/httpd/logs/referer_log";
# This is the location of the referer_log on your server

$page = "/";
# This is the part of your URL that you want the script to search for

@skip_pages = ("help.shtml","check.cgi","blank.gif");
# This is the part of URLs you want the script to skip. Each part in 
# quotes and seperated by a comma.

$local_domain = "command-o";
# This is the local domain, or a part thereof so the script only counts 
# outside referals.

$output_file = "referers.html";
# This is the name of the html file the script produces listing the final
# results

$minumum_referals = 1;
# This is the minimum number or referals required to be listed.

# That's it! You may not make any changes below this point
# without the express written consent of Command-O Software
####################
$|=1;
$time = time();

open(LOG,"$referer_log") || die "Could not open Referer Log";
while(<LOG>){
   if($_ =~ /$page/ && $_ !~ /$local_domain/i) {
      $ref = $_;
      foreach$skip(@skip_pages) {
         if($ref =~ /$skip/) {
             $bad =1;
         }
      }
      if(!$bad) {   
         ($test,$testbogus) = split(/ /,$ref);
         study($test);
         $test =~ s/:80//g;
         $test =~ s/%7E/~/g;
         if($test =~ /^file/) {
            $test = "Bookmark";
         }
         if($test =~ /^news/) {
            $test = "Newsgroup";
         }
         if($test =~ /search.yahoo.com/){
            $test = "Yahoo Search";
         }
         if($test =~ /www.excite.com\/search/){
            $test = "Excite Search";
         }
         if($test =~ /www.altavista.digital.com/){
            $test = "Altavista Search";
         }
         if($test =~ /lycos.com\/cgi-bin/){
            $test = "Lycos Search";
         }
      
         $HASH{"$test"}++;
         $grandtotal++;
      }
      undef($bad);
   }
}
close(LOG);

sub bynumber { $b <=> $a; }

foreach$key(keys %HASH) {
   $line = "$HASH{$key}\::$key";
   push(@array,$line);
}
undef(%HASH);
@array = sort bynumber @array;

$time = time() - $time;
open(OUTPUT,">$output_file");

print OUTPUT "<html><head><title>Page Referals</title></head>\n";
print OUTPUT "<body bgcolor=ffffff>\n";
print OUTPUT "<CENTER><H1>Page Referals</h1><h3>Match Criteria: $page<br>\n";
print OUTPUT "Skip Criteria: @skip_pages </h3>\n";
print OUTPUT "It took $time seconds to compile this information.</center>\n";
print OUTPUT "<table><tr><td><b>#</b></td><td><b>%</b></td><td><b>Page</b></td></tr>\n";
foreach$part(@array){
   ($total,$referer) = split(/::/,$part);
   if($total >= $minumum_referals) {
      $percentage = (int(($total * 1000) / $grandtotal)) / 10;
      if($referer !~ /^http:\/\//){
         print OUTPUT "<tr><td>$total</td><td>$percentage</td><td>$referer</td></tr>\n";
      }
      else {
         print OUTPUT "<tr><td>$total</td><td>$percentage</td><td><a href=\"$referer\">$referer</a></td></tr>\n";
      }
   }
}
print OUTPUT "</table>";
print OUTPUT "<a href=\"command-o.com\"><img border=0 width=91 height=31 ";
print OUTPUT "src=\"http://www.command-o.com/pics/command-o-logo-sm.gif\"></a>\n";
print OUTPUT "</body></html>\n"; 
close(OUTPUT);
exit;
