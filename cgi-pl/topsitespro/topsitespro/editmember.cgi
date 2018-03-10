#!/usr/bin/perl
#
#######################################################
#		Top Sites Professional
#     
#    	Created by Solution Scripts
# 		Email: solutions@solutionscripts.com
#		Web: http://solutionscripts.com
#
#######################################################
#
#
# COPYRIGHT NOTICE:
#
# Copyright 1998 Solution Scripts  All Rights Reserved.
#
# Selling or redistributing the code for this program
# without prior written consent is expressly forbidden.
# In all cases copyright and header must remain intact.
#
######################################################

require "variables.pl";


$cgiurl = $ENV{'SCRIPT_NAME'};
print "Content-type: text/html\n\n";
$INPUT{'action'} = $ENV{'QUERY_STRING'};

read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
@pairs = split(/&/, $buffer);
foreach $pair (@pairs) {
	($name, $value) = split(/=/, $pair);
	$value =~ tr/+/ /;
	$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $value =~ s/<([^>]|\n)*>//g;
	if ($INPUT{$name}) { $INPUT{$name} = $INPUT{$name}.",".$value; }
	else { $INPUT{$name} = $value; }
}


$version = "3.05";

$time = time;
$reset_offset = $reset_offset * 3600;
$time = $time + $reset_offset;
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);
$mon++;
$year += 1900;
$now = "$mon.$mday.$year";
$sunday = $yday - $wday;

&Header;

if ($INPUT{'action'} eq "new") { &new; }
elsif ($INPUT{'action'} eq "edit") { &log_edit; }
elsif ($INPUT{'action'} eq "html") { &html; }
elsif ($INPUT{'action'} eq "name") { &name; }
elsif ($INPUT{'action'} eq "password") { &password; }
elsif ($INPUT{'editfinal'}) { &editfinal; }
elsif ($INPUT{'edit'}) { &edit; }
elsif ($INPUT{'stats'}) { &stats; }
elsif ($INPUT{'new_pass'}) { &new_pass; }
elsif ($INPUT{'html_dis'}) { &html_dis; }
elsif ($INPUT{'locate'}) { &locate; }
elsif ($INPUT{'newaccount'}) {&newaccount; }
else { &htmloptions; }
exit;


sub htmloptions {

print <<EOF;
<center>
<font size=+1 face=arail>Welcome to $topsite_name<BR>Please choose one of the following:
<BR></FONT>
<FORM METHOD="POST" ACTION="$cgiurl">
<TABLE cellpadding=4 border=0>
<TR><TD>
<input type="Radio" name="action" value="new" checked>
</TD><TD><font size=-1 face=arial>
Create a new account
</TD></TR>
<TR><TD>
<input type="Radio" name="action" value="edit">
</TD><TD><font size=-1 face=arial>
Edit, check stats on existing account
</TD></TR>

<TR><TD>
<input type="Radio" name="action" value="html">
</TD><TD><font size=-1 face=arial>
Lost html to put on page
</TD></TR>

<TR><TD>
<input type="Radio" name="action" value="name">
</TD><TD><font size=-1 face=arial>
Lost account name
</TD></TR>

<TR><TD>
<input type="Radio" name="action" value="password">
</TD><TD><font size=-1 face=arial>
Lost account password
</TD></TR>
<TR><TD colspan=2 align=center>
<input type="Submit" name="go" value=" Pick One ">
</TD></TR></TABLE>
</FORM>
<BR>

EOF

&Footer; 
exit;
}

sub new {

print <<EOF;
<CENTER>
<FORM METHOD="POST" ACTION="$cgiurl">
<font face=arial>
Sign up for an account at $topsite_name<BR><BR>
EOF

if ($terms) {
	open (PASSWORD, "$path/data/rules.txt");
	@rules = <PASSWORD>; 
	close (PASSWORD);
		
print <<EOF;
<table border=0 width=60%>
<TR align=left>
<TD><font face=$font_face size=$font_size>
<B>Terms and Conditions</B><BR><BR>
@rules
<BR><BR></TD></TR><TR><TD bgcolor = silver align=center>
<font face=arial size=2 color=white> 
<input type="Checkbox" name="agree"> -- <B>I Agree</B>
</TD></TR>
</TABLE><BR>
EOF
}

print <<EOF;

<TABLE BORDER=1 CELLPADDING=8 cellspacing=0>
<TR><TD ALIGN=RIGHT ><font size=-1 face=arial><b>Account Name:</b></font><BR><FONT size=-2 face=arial>Must be 3-12 characters,<BR>letters and numbers only</TD><TD ALIGN=LEFT ><INPUT TYPE="text" NAME="account" size=30 Maxlength=50></TD> </TR>

<TR><TD ALIGN=RIGHT ><font size=-1 face=arial><b>Site Name:</b></font></TD><TD ALIGN=LEFT ><INPUT TYPE="text" NAME="name" size=30 Maxlength=50></TD> </TR>
<TR><TD ALIGN=RIGHT ><font size=-1 face=arial><b>Your Email:</b></font></TD><TD ALIGN=LEFT ><INPUT TYPE="text" NAME="email" size=30 Maxlength=50></TD></TR>
<TR><TD ALIGN=RIGHT ><font size=-1 face=arial><b>Site URL:</b></font></TD><TD ALIGN=LEFT ><INPUT TYPE="text" NAME="url" size=30></TD></TR>
<TR><TD ALIGN=RIGHT ><font size=-1 face=arial><b>Site Desrciption:</b></font></TD><TD ALIGN=LEFT ><INPUT TYPE="text" NAME="des" size=50 Maxlength=100></TD></TR> 
<TR><TD ALIGN=RIGHT ><font size=-1 face=arial><b>Site image:</b></font></TD><TD ALIGN=LEFT ><INPUT TYPE="text" NAME="banner" size=30></TD></TR>
<TR><TD ALIGN=RIGHT ><font size=-1 face=arial><b>Password:</b></font></TD><TD ALIGN=LEFT ><INPUT TYPE="password" NAME="pass" size=20 Maxlength=15></TD></TR>
<TR><TD ALIGN=RIGHT ><font size=-1 face=arial><b>Retype Password:</b></font></TD><TD ALIGN=LEFT ><INPUT TYPE="password" NAME="pass2" size=20 Maxlength=15></TD></TR>
<tr><TD  colspan=2><center><input type=submit name="newaccount" value="  Create my account!  "></TD></tr>
</TABLE><BR>

</form>


EOF

&Footer; 
exit;

}

sub log_edit {

print <<EOF;
<CENTER>
<FORM METHOD="POST" ACTION="$cgiurl">
<font face=arial>
<b>Edit your account - Check stats</b><BR><BR>
<TABLE BORDER=1 CELLPADDING=5 cellspacing=0>
<TR><TD ALIGN=RIGHT ><font size=-1 face=arial>Account Name:</font></TD><TD ALIGN=LEFT ><INPUT TYPE="text" NAME="id" size=20></TD> </TR>
<TR><TD ALIGN=RIGHT ><font size=-1 face=arial>Password:</font></TD><TD ALIGN=LEFT ><INPUT TYPE="password" NAME="pass" size=20></TD></TR>
<TR><TD ALIGN=center colspan=2 ><input type=submit name=edit value="  Edit Account  "></TD></TR>

</TABLE>

</form>
<BR>
EOF

&Footer; 
exit;
}



sub edit {

unless ($INPUT{'id'}) {
print <<EOF;
<BR>
<table cellpadding=5 border=1 cellspacing=0>
<TR><TD><font face=arial size=2><B>
You must enter an account number
</TD></TR></TABLE><BR>
EOF
	&Footer;
	exit;
	}

unless ($INPUT{'pass'}) {
print <<EOF;
<BR>
<table cellpadding=5 border=1 cellspacing=0>
<TR><TD><font face=arial size=2><B>
The password you entered for account $mem is incorrect!
</TD></TR></TABLE><BR>
EOF
	&Footer;
	exit;
	}

$mem = $INPUT{'id'};
open (DAT,"<$path/members/$mem.txt") || &error("No such member as $mem");
if ($use_flock) {
	flock DAT, 2;
}
@edit_array = <DAT>;
close (DAT);

open (DAT,"<$path/members/$mem.dat");
if ($use_flock) {
	flock DAT, 2;
}
@data = <DAT>;
close (DAT);


chomp ($edit_array[10]);
chomp ($edit_array[11]);
chomp ($edit_array[9]);
chomp ($edit_array[13]);
chomp ($edit_array[15]);
chomp ($edit_array[16]);
chomp ($edit_array[18]);

unless ($edit_array[9] eq $now) {
	$edit_array[1] = 0;
	$edit_array[10] = 0;
}
unless ($edit_array[13] eq $mon) {
	$edit_array[14] = 0;
	$edit_array[15] = 0;
}
unless ($edit_array[16] eq $sunday) {
	$edit_array[17] = 0;
	$edit_array[18] = 0;
}

$rank = pop(@data);
@ranks = split(/\|/,$rank);



$newpassword = crypt($INPUT{'pass'}, aa);
$newpassword .= "\n";
unless ($newpassword eq $edit_array[12]) {
print <<EOF;
<BR>
<table cellpadding=5 border=1 cellspacing=0>
<TR><TD><font face=arial size=2><B>
The password you entered for account $mem is incorrect!
</TD></TR></TABLE><BR>
EOF
	&Footer;
	exit;
}


print <<EOF;
<FORM METHOD=POST ACTION=$cgiurl>
<INPUT TYPE="HIDDEN" NAME="pass" VALUE="$INPUT{'pass'}">
<input type=hidden name=id value="$mem">
<font size=3 face=arial><b>Account</b>
<font color=red>$mem</FONT></FONT><br>
<font size=2 face=arial>$message</FONT>
<BR><table border=1 cellpadding=3 cellspacing=0>
<TR><TD bgcolor=silver align=center colspan=3>
<font size=2 face=arial color=white>Stats for $mem</FONT></TD></TR>
<TR><TD><font size=2 face=arial>Current Rank:</TD>
<TD colspan=2 align=center><font size=2 face=arial color=red><B>$ranks[3]
</TD></TR>
<TR>
<TD bgcolor=silver align=center><font size=2 face=arial color=white>Time</TD>
<TD bgcolor=silver align=center><font size=2 face=arial color=white>In</TD>
<TD bgcolor=silver align=center><font size=2 face=arial color=white>Out</TD>
</TR>
<TR align=center>
<TD><font size=2 face=arial>Total</TD>
<TD><font size=2 face=arial>$edit_array[0]</TD>
<TD><font size=2 face=arial>$edit_array[11]</TD>
</TR>
<TR align=center>
<TD><font size=2 face=arial>Today</TD>
<TD><font size=2 face=arial>$edit_array[1]</TD>
<TD><font size=2 face=arial>$edit_array[10]</TD>
</TR>
<TR align=center>
<TD><font size=2 face=arial>Week</TD>
<TD><font size=2 face=arial>$edit_array[17]</TD>
<TD><font size=2 face=arial>$edit_array[18]</TD>
</TR>
<TR align=center>
<TD><font size=2 face=arial>Month</TD>
<TD><font size=2 face=arial>$edit_array[14]</TD>
<TD><font size=2 face=arial>$edit_array[15]</TD>
</TR>
<TR><TD colspan=3 align=center bgcolor=silver>
<input type="Submit" name="stats" value=" Daily Stats ">
</TD></TR>
</TABLE>

<BR><font size=2 face=arial><B>Edit account $mem</B><br><BR>
<table border=1 CELLSPACING=0 cellpadding=4 border=1>
<tr><td bgcolor=#808080><FONT SIZE=-1  face=arial COLOR=#FFFFFF>Site Name:</TD><TD bgcolor=#DDDDDD><input type=text name=name size =50 value="$edit_array[5]"></TD></TR>
<tr><td bgcolor=#808080><FONT SIZE=-1  face=arial COLOR=#FFFFFF>Site URL:</TD><TD bgcolor=#DDDDDD><input type=text name=url size =50 value= "$edit_array[4]"></TD></TR>
<tr><td bgcolor=#808080><FONT SIZE=-1  face=arial COLOR=#FFFFFF>Site Image:</TD><TD bgcolor=#DDDDDD><input type=text name=banner size =50 value= "$edit_array[8]"></TD></TR>
<tr><td bgcolor=#808080><FONT SIZE=-1 face=arial COLOR=#FFFFFF>Email Address:</TD><TD bgcolor=#DDDDDD><input type=text name=email size =50 value= "$edit_array[6]"></TD></TR>
<tr><td bgcolor=#808080><FONT SIZE=-1 face=arial COLOR=#FFFFFF>Description:</TD><TD bgcolor=#DDDDDD><input type=text name=descrip size =50 value= "$edit_array[7]"></TD></TR>
<tr><td bgcolor=#808080><FONT SIZE=-1 face=arial COLOR=#FFFFFF>New Password:</TD><TD bgcolor=#DDDDDD><input type=password name=passw size =20></TD></TR>
</TABLE><BR><BR>
<INPUT TYPE=SUBMIT NAME="editfinal" VALUE=" Save these changes "></form>
EOF
	&Footer;
	exit;

}

sub editfinal {

$error=0;
$err = "";
unless($INPUT{'pass'}) {
	$err .= "You must enter your password to edit your account<br>";
	$error=1;
}
unless($INPUT{'url'}=~/\http:/) {
	$err .= "You must enter a valid url<br>";
	$error = 1;
}
unless($INPUT{'email'}=~/\@/) {
	$err.= "You must enter a valid email address<br>";
	$error = 1;
}
if ($error == 1 ) {
print <<EOF;
<BR>
<table cellpadding=5 border=1 cellspacing=0>
<TR><TD><font face=arial size=2><B>
Error found, please go back and fix the following:<BR><BR>
<font color=red>
$err
</FONT>
</TD></TR></TABLE>
EOF
	&Footer;
	exit; 
}

$num_edit=0;
$mem = $INPUT{'id'};

open (DAT,"<$path/members/$mem.txt") || &error("No account");
if ($use_flock) {
	flock DAT, 2; 
}
@edit_array = <DAT>;
close (DAT);
$newpassword = crypt($INPUT{'pass'}, aa);
$newpassword .= "\n";
unless ($newpassword eq $edit_array[12]) {
print <<EOF;
<BR>
<table cellpadding=5 border=1 cellspacing=0>
<TR><TD><font face=arial size=2><B>
The password you entered for account $mem is incorrect!
</TD></TR></TABLE><BR>
EOF
	&Footer;
	exit;
	}

$edit_array[5] = "$INPUT{'name'}\n";
$edit_array[4] = "$INPUT{'url'}\n";
$edit_array[6] = "$INPUT{'email'}\n";
$edit_array[7] = "$INPUT{'descrip'}\n";
$edit_array[8] = "$INPUT{'banner'}\n";

if ($INPUT{'passw'}) {
	$INPUT{'pass'} = $INPUT{'passw'};
	$newpass =crypt($INPUT{'passw'}, aa);
	$newpass .="\n";
	$edit_array[12] = $newpass;
}

open (DATA,">$path/members/$mem.txt") || &error;
if ($use_flock) {
	flock DATA, 2; 
}
print DATA @edit_array;
close (DATA);

$message = "<BR><B>Account $mem information updated</B><BR>";
&edit;
exit;

}

sub newaccount {

if ($terms) {
	unless ($INPUT{'agree'}) {
print <<EOF;
<BR>
<table cellpadding=5 border=1 cellspacing=0>
<TR><TD><font face=arial size=2><B>
You must agree to the terms and conditions before joining,<BR><BR>
please go back and read them, then check the "I agree box"
</TD></TR></TABLE><br>
EOF
		&Footer;
		exit;
	}
}		

$new_id = $INPUT{'account'};
@out = split(//,$new_id);
$a=0;
foreach $char (@out) {
$a++;
unless ($char =~ /[a-z0-9]/) {
print <<EOF;
<BR>
<table cellpadding=5 border=1 cellspacing=0>
<TR><TD><font face=arial size=2>
You entered an invalid account name<BR>
Make sure you only enter letters and numbers, but nothing else<BR>
and that it is only 3 to 12 characters
</TD></TR></TABLE><BR><BR>
EOF
&Footer;
exit;
}

}

if ($a < 3 || $a > 12) {
print <<EOF;
<BR>
<table cellpadding=5 border=1 cellspacing=0>
<TR><TD><font face=arial size=2>
You entered an invalid account name<BR>
Make sure you only enter letters and numbers, but nothing else<BR>
and that it is only 3 to 12 characters
</TD></TR></TABLE><BR><BR>
EOF
&Footer;
exit;
}

if (-e "$path/members/$new_id.txt") {
print <<EOF;
<BR>
<table cellpadding=5 border=1 cellspacing=0>
<TR><TD><font face=arial size=2>
The account name you selected is already in use,<BR>please select another one.
</TD></TR></TABLE><BR><BR>
EOF
&Footer;
exit;
}

$error=0;
unless ($INPUT{'name'}) {
	$err .= "You must enter the site name<br>";
	$error = 1;
}

unless ($INPUT{'url'}=~/\http:/)   { 
	$err.= "You have entered an invalid url for you site<br>\n";
	$error =1;
}

unless ($INPUT{'email'}=~/\@/)   { 
	$err .="You have entered an invalid e-mail address<br>\n";
	$error=1;
}
unless ($INPUT{'pass'}) {
	$err .= "You must enter a password<br>";
	$error = 1;
}

unless ($INPUT{'pass'} eq $INPUT{'pass2'}) {
	$err .= "The two passwords you entered must be the same<br>\n";
	$error=1;
}
if ($error) {
print <<EOF;
<BR>
<table cellpadding=5 border=1 cellspacing=0>
<TR><TD><font face=arial size=2>
Errors were found in your sign up form.<BR>
They were:<BR><BR><font color=red>
$err
<BR></FONT>
Please go back and fix them.
</TD></TR></TABLE><BR><BR>
EOF
	&Footer;
	exit;
	}

open (BLOCK, "$path/data/block.txt");
@block = <BLOCK>;
close (BLOCK);
$found=0;
$ipaddress = $ENV{'REMOTE_ADDR'};

foreach $line (@block) { 
chomp($line);

	if ($ipaddress =~ /^$line/i) { 
		$found = 1; 
		last; 
	} 
	if ($INPUT{'url'} =~ /^$line/i) { 
		$found = 1; 
		last; 
	} 
	if ($INPUT{'email'} =~ /^$line/i) { 
		$found = 1; 
		last; 
	} 
	
} 

if ($found) {

print <<EOF;
<BR>
<table cellpadding=5 border=1 cellspacing=0>
<TR><TD><font face=arial size=2>
We are sorry, you can not create an account at this time
</TD></TR></TABLE><BR><BR>
EOF
&Footer;
exit;
}



$password = crypt($INPUT{'pass'}, aa);

$current_time = time();


open(DB, ">$path/members/$new_id.txt")  || &error("Unable to create file $new_id.txt $!");
if ($use_flock) {
flock DB, 2; 
}
print DB "0\n";
print DB "0\n";
print DB "$current_time\n";
print DB "0\n";
print DB "$INPUT{'url'}\n";
print DB "$INPUT{'name'}\n";
print DB "$INPUT{'email'}\n";
print DB "$INPUT{'des'}\n";
print DB "$INPUT{'banner'}\n";
print DB "0\n";
print DB "0\n";
print DB "0\n";
print DB "$password\n";
print DB "0\n";
print DB "0\n";
print DB "0\n";
print DB "0\n";
print DB "0\n";
print DB "0\n";
close (DB);

open (DAT,"<$path/data/code.txt");
@code = <DAT>;
close (DAT);

open (DAT,"<$path/data/codeh.txt");
@codeh = <DAT>;
close (DAT);

open (DAT,"<$path/data/codem.txt");
@codem = <DAT>;
close (DAT);

unless (@code) {
	$code[0] = "<A HREF=\"\$url_to_cgi/topsites.cgi?\$new_id\" TARGET=\"_BLANK\">\n";
	$code[1] ="<IMG SRC=\"$topsite_name image here\" BORDER=0></A>";
}

print <<EOF;
<div=center>
<font size=3 face=arial><br>Thank you for joining $topsite_name</FONT>
<BR><BR><font size=-1 face=arial>
Your account information is as follows:<BR>
<table border=0 width=500><TR><TD>
Account Name: $new_id<BR>
Password: <font color="Red">$INPUT{'pass'}</font><BR>
Your Name: <font color="Red">$INPUT{'name'}</font><BR>
Your Email: <font color="Red">$INPUT{'email'}</font><BR>
Web Site Url: <font color="Red">$INPUT{'url'}</font><BR><BR>
<font size=2>
Below is the html code you need to insert into your web site. Once this has been inserted into your
html pages, the first time you send a hit to Top Sites, your account will be activated. 
<BR><BR>
<font size=2 color=red>
EOF

foreach $cd(@code) {

	$cd =~ s/\$url_to_cgi/$url_to_cgi/ig;	
	$cd =~ s/\$new_id/$new_id/ig;
	$cd =~ s/</\&lt\;/ig;
	$cd =~ s/>/\&gt\;/ig;
	$cd =~ s/\n/<BR>/ig;	
	print "$cd";
}
print <<EOF;
</FONT>
@codeh
<BR><BR>
To view the site rankings, you may go to <a href="$url/$topsite_file" target="_blank">$url/$topsite_file</A>.
<BR>If you would like to edit your account info or check your stats, you may go to <a href="$url_to_cgi/editmember.cgi?edit" target="_blank">$url_to_cgi/editmember.cgi?edit</A>.
</TD></TR></TABLE>
<BR><BR>
EOF

&Footer;

$toemail = $INPUT{'email'};
$messages = '';

$messages .= "Thank you for submitting your site to $topsite_name \n\n";
$messages .= "Your account name and password are as follows:\n";
$messages .= "Account name: $new_id\n";
$messages .= "Password: $INPUT{'pass'}\n\n";
$messages .= "You need to put the following html code on your web site:\n\n";

foreach $cf(@code) {
	$cf =~ s/\&lt\;/</ig;
	$cf =~ s/\&gt\;/>/ig;
	$cf =~ s/<BR>/\n/ig;	
	$messages .= "$cf";
}

$messages .= "\n@codem\n\n";
$messages .= "View the $topsite_name at $url/$topsite_file\n\n";
$messages .= "Edit your account and view stats at $url_to_cgi/editmember.cgi?edit\n\n";


&emails($toemail,$topsite_name,$messages);

exit;

}


sub locate {

opendir (DIR, "$path/members") || &error("Unable to open members dir. for reading");
@file = grep { /.txt/ } readdir(DIR);
close (DIR);
$found =0;

foreach $line(@file) {

	open (DAT,"<$path/members/$line")  || &error("Unable to open file $line for reading");
	if ($use_flock) {
		flock DAT, 2; 
	}
	@array = <DAT>;
	close (DAT);

	chomp ($array[6]);
	if ($INPUT{'email'} eq $array[6]) {
	
		$account = $line;
		$account =~s/\.txt//;
		$new_id = $account;
		open (DAT,"<$path/data/code.txt");
		@code = <DAT>;
		close (DAT);

		open (DAT,"<$path/data/codem.txt");
		@codem = <DAT>;
		close (DAT);

		unless (@code) {
			$code[0] = "<A HREF=\"\$url_to_cgi/topsites.cgi?\$new_id\" TARGET=\"_BLANK\">\n";
			$code[1] ="<IMG SRC=\"$topsite_name image here\" BORDER=0></A>";
		}

		$toemail = $INPUT{'email'};
		$messages = '';
		$messages .= "This is the info you requested from $topsite_name \n\n";
		$messages .= "Your account name is: $account\n\n";
		$messages .= "The following is the html code that should be on your web site:\n\n";

		foreach $cf(@code) {
			$cf =~ s/\$url_to_cgi/$url_to_cgi/ig;	
			$cf =~ s/\$new_id/$new_id/ig;
			$messages .= "$cf";
		}

		$messages .= "\n@codem\n\n";
		$messages .= "View the $topsite_name at $url/$topsite_file\n\n";
		$messages .= "Edit your account and view stats at $url_to_cgi/editmember.cgi?edit\n\n";

		&emails($toemail,$topsite_name,$messages);
		$found=1;
	}

}

if ($found) {
print <<EOF;
<BR><table cellpadding=10 border=1 cellspacing=0><TR><TD align=center>
<font face=arial size=2>
<b>Account Found</B><BR><BR>
An account was found for the email address that was entered<BR>
An email including the account name has been sent to $INPUT{'email'}
</TD></TR></TABLE><BR>
EOF
	&Footer;
	exit;
}
else {
print <<EOF;
<BR><table cellpadding=10 border=1 cellspacing=0><TR><TD align=center>
<font face=arial size=-1>
We are sorry,<BR>There is no account for the email $INPUT{'email'}</TD></TR></TABLE><BR>

EOF
	&Footer;
	exit;
}

}

sub html {

print <<EOF;
<BR>
<FORM METHOD=POST ACTION=$cgiurl>
<table cellpadding=5 border=1 cellspacing=0 width=500>
<TR><TD align=center><font face=arial size=2>
Please enter you account name below and we will show you your customized html you need to put on your web site.
<BR><BR>
Account Name: <input type="Text" name="id" size="15">
<BR>
<input type="Submit" name="html_dis" value=" Submit ">
<BR></TD></TR></TABLE></FORM><BR>
EOF
&Footer;
exit;

}

sub html_dis {

$new_id= $INPUT{'id'};

print <<EOF;
<BR>
<table cellpadding=5 border=1 cellspacing=0 width=500>
<TR><TD><font face=arial size=2>
<CENTER>Below is the html code you need for account $new_id<BR>
You can copy and paste it into any html page you wish<BR>
<BR>
</CENTER><font color=red>
EOF

open (DAT,"<$path/data/code.txt");
@code = <DAT>;
close (DAT);

open (DAT,"<$path/data/codeh.txt");
@codeh = <DAT>;
close (DAT);

unless (@code) {
	$code[0] = "<A HREF=\"\$url_to_cgi/topsites.cgi?\$new_id\" TARGET=\"_BLANK\">\n";
	$code[1] ="<IMG SRC=\"$topsite_name image here\" BORDER=0></A>";
}

foreach $cd(@code) {

	$cd =~ s/\$url_to_cgi/$url_to_cgi/ig;	
	$cd =~ s/\$new_id/$new_id/ig;
	$cd =~ s/</\&lt\;/ig;
	$cd =~ s/>/\&gt\;/ig;
	$cd =~ s/\n/<BR>/ig;	
	print "$cd";
}

print <<EOF;
</FONT>
<BR>
@codeh<BR>
</TD></TR></TABLE><BR><BR>
EOF
&Footer;
exit;

}

sub name {

print <<EOF;
<FORM METHOD="POST" ACTION="$cgiurl">
<TABLE BORDER=1 CELLPADDING=5 cellspacing=0>
<TR><TD ALIGN=CENTER ><font size=-1 face=arial>Forget your account number?<BR>Enter you email address</TD> </TR>
<TR><TD ALIGN=Center ><INPUT TYPE="TEXT" NAME="email" size=20></TD></TR>
<TR><TD ALIGN=center ><input type=submit name=locate value="  Locate my account  "></TD></TR>
</TABLE>
</FORM><BR>
EOF
&Footer;
exit;
}

sub password {

print <<EOF;
<FORM METHOD="POST" ACTION="$cgiurl">
<TABLE BORDER=1 CELLPADDING=5 cellspacing=0 width=500>
<TR><TD ALIGN=CENTER ><font size=-1 face=arial>Forget your account password?<BR>Enter you account name and email address and we will send you a new password</TD> </TR>
<TR><TD ALIGN=Center ><font size=-1 face=arial>Account: <INPUT TYPE="TEXT" NAME="account" size=20></TD></TR>
<TR><TD ALIGN=Center ><font size=-1 face=arial>Email: <INPUT TYPE="TEXT" NAME="email" size=20></TD></TR>
<TR><TD ALIGN=center ><input type=submit name=new_pass value="  Lost my password  "></TD></TR>
</TABLE>
</FORM><BR>
EOF
&Footer;
exit;
}

sub new_pass {

open (DAT,"<$path/members/$INPUT{'account'}.txt")  || &error("No such account as $INPUT{'account'}");
if ($use_flock) {
	flock DAT, 2; 
}
@array = <DAT>;
close (DAT);

chomp ($array[6]);
if ($INPUT{'email'} eq $array[6]) {
# NEW PASS
# generate random password
	srand($time);
	$password ="";
	@passset = ('a'..'k', 'm'..'z', 'A'..'N', 'P'..'Z', '2'..'9');
	for ($i = 0; $i < 8; $i++) {
		$randum_num = int(rand($#passset + 1));
		$password .= @passset[$randum_num];
	}
	$newpass =crypt($password, aa);
	$newpass .="\n";
	$array[12] = $newpass;
	$array[6] .= "\n";

	open (DATA,">$path/members/$INPUT{'account'}.txt") || &error;
	if ($use_flock) {
		flock DATA, 2; 
	}
	print DATA @array;
	close (DATA);

$messages ="";
$toemail = $INPUT{'email'};
$new_id = $INPUT{'account'};

$messages .= "Here is the new password you requested from $topsite_name\n\n";
$messages .= "Account: $INPUT{'account'}\n";
$messages .= "New Password: $password\n\n";
$messages .= "The following is the html code that should be on your web site:\n\n";

open (DAT,"<$path/data/code.txt");
@code = <DAT>;
close (DAT);

open (DAT,"<$path/data/codem.txt");
@codem = <DAT>;
close (DAT);

unless (@code) {
	$code[0] = "<A HREF=\"\$url_to_cgi/topsites.cgi?\$new_id\" TARGET=\"_BLANK\">\n";
	$code[1] ="<IMG SRC=\"$topsite_name image here\" BORDER=0></A>";
}

foreach $cf(@code) {
	$cf =~ s/\$url_to_cgi/$url_to_cgi/ig;	
	$cf =~ s/\$new_id/$new_id/ig;
	$messages .= "$cf";
}
$messages .= "\n@codem\n\n";
$messages .= "View the $topsite_name at $url/$topsite_file\n\n";
$messages .= "Edit your account and view stats at $url_to_cgi/editmember.cgi?edit\n\n";
$subject = "$topsite_name\n";

&emails($toemail,$subject,$messages);


print <<EOF;
<TABLE BORDER=1 CELLPADDING=5 cellspacing=0 width=500>
<TR><TD ALIGN=CENTER ><font size=-1 face=arial>
The account was located and a new password has been set, the password was mailed to the email address you entered.
</TD> </TR>
</TABLE><BR><BR>
EOF
&Footer;
exit;


}
else {
print <<EOF;
<TABLE BORDER=1 CELLPADDING=5 cellspacing=0 width=500>
<TR><TD ALIGN=CENTER ><font size=-1 face=arial>We are sorry, the email address you entered was different from the one we had on record for the account <font color=red>$INPUT{'account'}</FONT><BR><BR>
Therefore we can not send you the new password....</TD> </TR>
</TABLE><BR><BR>
EOF
&Footer;
exit;
}

}

sub stats {

$mem = $INPUT{'id'};

open (DAT,"<$path/members/$mem.txt") || &error("No account");
if ($use_flock) {
	flock DAT, 2; 
}
@edit_array = <DAT>;
close (DAT);
$newpassword = crypt($INPUT{'pass'}, aa);
$newpassword .= "\n";
unless ($newpassword eq $edit_array[12]) {

print <<EOF;
<BR>
<table cellpadding=5 border=1 cellspacing=0>
<TR><TD><font face=arial size=2><B>
The password you entered for account $mem is incorrect!
</TD></TR></TABLE><BR>
EOF
	&Footer;
	exit;
}

open (PASSWORD, "$path/members/$mem.dat");
@daily = <PASSWORD>;
close (PASSWORD);


@daily = reverse(@daily);

if ($how_rank eq "total") {
	$hows = "the total amount of hits sent in";
	$howw = "the total number people you have sent since you have been an member";
}
elsif ($how_rank eq "hitsday") {
	$hows = "the average amount of hits you send each day";
	$howw = "the number of total hits you have sent, diveded by the number of days you have been a member";
}
elsif ($how_rank eq 'today') {
	$hows = "the number of hits sent today";
	$howw = "the total amount of people you have sent just today, reset everyday";
}
elsif ($how_rank eq 'week') {
	$hows = "the number of hits sent this week";
	$howw = "the total amount of people you have sent just this week, reset every Sunday";
}
elsif ($how_rank eq 'month') {
	$hows = "the number of hits sent this month";
	$howw = "the total amount of people you have sent just this month, reset the 1rst of every month";
}

print <<EOF;
<table cellspacing =0 border=1 cellpadding =3>
<TR bgcolor=#E4E4E4 align=center><TD colspan=4><FONT size="-1" FACE="Arial">Daily log</FONT>
</TD></TR>
<TR bgcolor=#E4E4E4 align=center><TD><FONT size="-1" FACE="Arial">Date</FONT>
</TD><TD><FONT size="-1" FACE="Arial">In</FONT>
</TD><TD><FONT size="-1" FACE="Arial">Out</FONT>
</TD><TD><FONT size="-1" FACE="Arial">Rank</FONT>
</TD></TR>
EOF

foreach $entry(@daily) {
@out = split(/\|/,$entry);

print <<EOF;
<TR bgcolor=white align=center>
<TD><FONT size="-1" FACE="Arial">$out[0]</FONT>
</TD><TD><FONT size="-1" FACE="Arial">$out[1]</FONT>
</TD><TD><FONT size="-1" FACE="Arial">$out[2]</FONT>
</TD><TD><FONT size="-1" FACE="Arial" color=red>$out[3]</FONT>
</TD></TR>

EOF
}

print <<EOF;
</TABLE>
<BR>
<table border=0 width=400><TR><TD>
<font size=2 face=arial>
$topsite_name is ranked on $hows meaning its ranked on $howw
</TD></TR></TABLE>
EOF

&Footer;
exit;
}

sub emails {


$recipient = $_[0];
$subject = $_[1];
$message = $_[2];

### SMTP ###
if ($smtp) {

	$smtp_server = $smtp;
	$emailfrom = $your_email;

($x,$x,$x,$x, $here) = gethostbyname($null);
($x,$x,$x,$x, $there) = gethostbyname($smtp_server);
$thisserver = pack('S n a4 x8',2,0,$here);
$remoteserver = pack('S n a4 x8',2,25,$there);
#NOTE, if Solaris, uncomment the line below and delete the one below it...leave alone for NT
#(!(socket(S,2,2,6))) && (&error("SMTP EMAIL: Connect error!"));
(!(socket(S,2,1,6))) && (&error("SMTP EMAIL: Connect error! socket"));
(!(bind(S,$thisserver))) && (&error("SMTP EMAIL: Connect error! bind"));
(!(connect(S,$remoteserver))) && (&error("SMTP EMAIL:  connection to $smtp_server has failed!"));

select(S);
$| = 1;
select(STDOUT);

$DATA_IN = <S>;	
($DATA_IN !~ /^220/) && (&error("SMTP EMAIL: data in Connect error - 220")); 

print S "HELO $ENV{REMOTE_HOST}\r\n";
$DATA_IN = <S>;
($DATA_IN !~ /^250/) && (&error("SMTP EMAIL: data in Connect error - 250")); 

print S "MAIL FROM:<$emailfrom>\n";
$DATA_IN = <S>;
($DATA_IN !~ /^250/) && (&error("SMTP EMAIL: $emailfrom address not valid")); 

print S "RCPT TO:<$recipient>\n";
$DATA_IN = <S>;
($DATA_IN !~ /^250/) && (&error("SMTP EMAIL: $recipient address not valid")); 

print S "DATA\n";
$DATA_IN = <S>;
($DATA_IN !~ /^354/) && (&error("SMTP EMAIL: Message send failed - 354")); 

print S <<MESSAGES;
From: $emailfrom
To: $recipient
Subject: $subject

$message
.
MESSAGES
$DATA_IN = <S>;
($DATA_IN !~ /^250/) && (&error("SMTP EMAIL: Message send failed - try again - 250")); 

print S "QUIT\n";
		
}
else {
	open(MAIL, "|$mail_prog -t") || &error("Could not send out emails");
	print MAIL "To: $recipient \n";
	print MAIL "From: $your_email \n";
	print MAIL "Subject: $subject \n\n";
	print MAIL $message;
	print MAIL "\n\n";
	close (MAIL);
}
}


########## CGI HEADER ##########
sub Header {

	print "<HTML><HEAD><TITLE>$topsite_name</TITLE></HEAD>\n";
	print "<body>\n";
	open (HEAD, "$path/data/header.txt");
	@head = <HEAD>;
	close (HEAD);
	foreach $line (@head) {
			print "$line";
	}
	print "<br><BR><center>";
}

########## CGI FOOTER ##########
sub Footer {
         print HTML"</center>";
	open (HEAD, "$path/data/footer.txt");
	@foot = <HEAD>;
	close (HEAD);
			foreach $line (@foot) {
			print "$line";
		}
if ($credit) {
	print "<center><font size=2 face=arial><hr width=525 noshade size=1><a href=\"http://solutionscripts.com\">Top Sites Professional</a> v$version<br>Created by <a href=\"http://solutionscripts.com\">Solution Scripts</a><br><br>";
	}
	print "</BODY></HTML>\n";
}


sub error{
$errors = $_[0] ;

print"<HTML><HEAD><TITLE>Top Sites error</TITLE></HEAD><Body><center>";
print"<TABLE cellpadding=10 border=1 cellspacing=0><TR><TD><center><font face=arial size=2>Top Sites error has occured in editmember.cgi<BR>";
print"<b>The error is: <br><font color=red>$errors -- $!</font><br><br>";
print"If you do not run this Top Sites and just clicked thru, please let <A HREF=\"mailto:$your_email\">$your_email</A> of the error that just occured<br><BR>";
print"If you are the operator of this Top Sites and are having trouble getting Top Sites to run, please consult the <A HREF=\"http://solutionscripts.com/man/topsitespro\">Top Sites Pro online manual</A> or post a message in the forum in the Top Sites Pro members lounge.</TD></TR></TABLE>";
print "<center><BR><hr width=525 noshade size=1><font face=arial size=2><a href=\"http://solutionscripts.com\">Top Sites Professional</a><br>Created by: <a href=\"http://solutionscripts.com\">Solution Scripts</a><br><br>";
exit;
}