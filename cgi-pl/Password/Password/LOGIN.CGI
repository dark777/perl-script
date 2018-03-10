#!/usr/bin/perl


# *by Ranson Johnson 
# *Last Modified: 12/29/96
# Password Program

############################################################################
#Feel free to copy, change, reference, sample, or borrow, the contents.    #  
#The script is provided as is, there is no warranty expressed or implied.  #
#If you would, email me and let me know you are using the script, so I can #
#show you on my list of links.                                             #
#If you would like to support public domain freeware, contributions are    #
#accepted.							           #
#Last but certainly not least, if you find a better way of doing something,#
#I would really like to know. Thanks and have fun.                         #
############################################################################

# Enter the path and name of the file you want to password protect
$txt_file = "secure.txt";

# Enter the path and name of the file for password and username
$login_page = "index.html";

# Enter the path and name of your password file
$passfile = '/usr/home/rlaj/cgi-bin/test/people.lst';

$this_cgi = 'login.cgi';

#################### DON'T CHANGE ANYTHING BELOW ###########################



# Get the input
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});

# Split the name-value pairs
@pairs = split(/&/, $buffer);

foreach $pair (@pairs) {
   ($name, $value) = split(/=/, $pair);

   # Un-Webify plus signs and %-encoding
   $value =~ tr/+/ /;
   $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
   $value =~ s/<!--(.|\n)*-->//g;

   $FORM{$name} = $value;
} 


&whoareyou unless $FORM{'password'};
&whoareyou unless $FORM{'username'};



open (PEOPLE, "$passfile") || &open_error($passfile);
@lines = <PEOPLE>;
close (PEOPLE);
foreach $line (@lines)

{

    #chop $line;
    ($realname, $realpassword) = split(/ /,$line);
    $realname =~ tr/A-Z/a-z/;
    $pwordlist{$realname}=$realpassword;
    
}


if (!$pwordlist{$FORM{'username'}})
{
   #not an authorized user
   print "Content-type: text/html\n\n";
   print "<HTML>\n";
   print "<HEAD>\n";
   print "   <TITLE>Access Denied</TITLE>\n";
   print "</HEAD>\n";
   print "<BODY>\n";
   print "<H1>Access Denied</H1>";
   print "I can't let you in, because I don't know who ";
   print "\"$FORM{'username'}\" is.<br><br>";
   print "<a href=\"$login_page\">Try again.</a>";
   print @results;
   print "</BODY>\n";
   print "</HTML>\n";
}
elsif (crypt($FORM{'password'},"MM") ne $pwordlist{$FORM{'username'}} ) {
   #passwords don't match
   print "Content-type: text/html\n\n";
   print "<HTML>\n";
   print "<HEAD>\n";
   print "   <TITLE>Access denied</TITLE>\n";
   print "</HEAD>\n";
   print "<BODY>\n";
   print "<H1>Access Denied</H1>";
   print "I can't let you in, because that's not the right password for ";
   print "$FORM{'username'}";
   print ".<p>\n";
   print "<a href=\"$login_page\">Try again.</a>";
   print "</BODY>\n";
   print "</HTML>\n";
}

else
{

# This section opens the htm file and prints it

   print "Content-type: text/html\n\n";

open(FILE, "$txt_file");
@filein = <FILE>;
close(FILE); 

	print @filein;

}

sub whoareyou {

   print "Content-type: text/html\n\n";

print <<EOT;

<HTML>
<Head><Title>ERROR</Title></Head>
<Body bgcolor=ffffff>
<CENTER>
<H1><FONT COLOR=0000FF>Log In</FONT></H1>


<H2>You must enter a username and password.</H2>
<P><UL>
</CENTER>
<a href=\"$login_page\">Try again.</a>


EOT

exit;

}


exit; 


sub open_error
    {

    local ($filename) = @_;

    print "Content-Type: text/html\n\n";


    print "
<P>
<HR>
<P>
<H1>Error!</H1>
<P>
<H4>The $this_cgi can not find, or is not able to open the 
specified file:</H4>
<H2>$filename</H2><P>  
Please check the file name in the configuration section of the<B>
$this_cgi</B>. Also check that <B>$filename</B> is in the right directory.";
    die;

# open (FILEHANDLE, ">>$file") || &open_error($file);

    } # End sub open_error
