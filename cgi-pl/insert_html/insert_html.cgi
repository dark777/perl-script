#!/usr/bin/perl

#
#
#
#   HTML inserter
#   By David Powell
#   Copyright 1999 Matrix Vault Productions
#   http://www.matrixvault.com/
#
#
#  USAGE: Call the script via SSI
#  <!--#exec cgi="cgi-local/insert_html.cgi"-->
##############
print "Content-type: text/html\n\n";
print "<HTML>\n";
$file = "/home/yourdir/public_html/file_to_be_inserted.html";
#The UNIX path to the insert file
##############
open(FILE,"$file") || &error('open->insert_file',$file);
@line=<FILE>;
close(FILE);
foreach $insert_line (@line) {
print "$insert_line\n";
}
exit;
#############
# E R R O R    ROUTINE
sub error {
    ($error,$file) = @_;
    print <<"END_ERROR";
Content-type: text/html

<html>
 <head>
  <title>ERROR: Insert File Unopenable</title>
 </head>
 <body bgcolor=#FFFFFF text=#000000>
  <center>
   <h1>ERROR: Insert File Unopenable</h1>
  </center>

The insert file, as specified in the \$file perl variable was 
unopenable.<p>
END_ERROR

exit;
}

