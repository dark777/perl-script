#!/usr/bin/perl

# *by Ranson Johnson 
# *Last Modified: 09/17/97
# Password Program, Add user (username, password)
#
# 
#
#        *** IMPORTANT You must FTP this file in ASCII mode! ***
#
#
#       99% of all user difficulties are caused from incorrect path
#       statements to the 'people.lst' file. If the 'people.lst' file
#       is in the same directory as this file, then the path would be:
#       $passfile = 'people.lst'; on most systems. If the file is not
#       in the same directory, you should use an absolute path - like:
#       $passfile = 'www/users/buba/scripts/password/people.lst'; 
#       If you do not know the path, ask your system administrator. 
#
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

# Enter the path and name of your password file
$passfile = 'wsdocs/scripts/password/people.lst';

$this_cgi = 'adduser.cgi';


           ############ Do not change any thing below ############


if ($ENV{'REQUEST_METHOD'} eq "POST"){

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

open FILE, "$passfile";
while (<FILE>)
{
 if (/$FORM{'username'}/o)
 {
   &already_there;

   close FILE;

   exit 0;
 }
}
close FILE; 


$password = "$FORM{'password'}";
$pass = crypt($password, "MM");

$PRINT = "Content-type:\ text/plain\n\n ";

       {
         $PRINT;
	
	open (ADDUSER, ">>$passfile") || &open_error($passfile);
        
	print ADDUSER "$FORM{'username'} ";

	print ADDUSER "$pass \n";

	close (ADDUSER);
}

{
print "Content-type: text/html\n\n";
   print "<HEAD>\n";
   print "   <TITLE>New User</TITLE>\n";
   print "</HEAD>\n";
   print "<BODY>\n";
   print "<B>This is what you entered <P>\n";
   print "User Name: $FORM{'username'}<BR>\n";
   print "Password: $FORM{'password'}<BR>\n";
   print "<P><HR><P></BODY></HTML>\n";
   exit;

 }

}else{

   print "Content-type: text/html\n\n";

   print <<"END";

	<html>
  	<head>
    	<title>Add User</title>
  	</head>
  	<body bgcolor="#C9A2D0">
	<CENTER>
	<H1>Add User</H1> 
	</CENTER>
	<B>Important</B>You can only use one word for each field. For sight name 
	or real name, Use underscore ( _ ) to separate words. ie Ransons_scripts.
	<P>
	<HR>   
	<form method="POST" action="$this_cgi">

	User Name <input type=text name="username" size=20> - 
	Password <input type=text name="password" size=20><p>
	<input type=submit value="Save User Info."> * <input type=reset>
	</form>

	</body>
	</html>
END
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


sub already_there  {

   print "Content-type: text/html\n\n";

print <<EOT;

	<html>
  	<head>
    	<title>UserName Error</title>
  	</head>
  	<body bgcolor="#FFFFFF">
	<CENTER>
	<H1>Previously Taken UserName</H1> 
	</CENTER>

<HR>
<P>
<FONT SIZE=5>
We already have a user with the name:<B> $FORM{'username'}</B>
</FONT>
<P>
<FONT SIZE=4>
You will have to select another username, or a variation of this
username. 
<P>
</FONT>
<HR>   

EOT


}
