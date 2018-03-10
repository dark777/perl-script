#!/usr/local/bin/perl
###############
# Footer
#
# by Mike Wheeler
#
# Command-O Software
#
# Copyright 1996
#put this on page you want footer to appear <!--#exec cgi="footer.cgi"-->
# All Rights Reserved
#
#If you find this script useful, we would appreciate a 
#donation to keep this service active for the community.
#Command-O Software, P.O. Box 12200, Jackson WY 83002
###############

$footer_file = "/usr/local/etc/httpd/htdocs/demos/footer.txt";

print "Content-type: text/html\n\n";
open(FILE,"$footer_file");
while(<FILE>) {
   print $_;
}
exit;
