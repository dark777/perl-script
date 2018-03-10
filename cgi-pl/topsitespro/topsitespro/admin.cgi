#!/usr/bin/perl
$no_stats = 0;
###
#######################################################
#		Top Sites Profressional v3.05
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
#######################################################

$chown = 0;


$topsite_name="";
$path="";
$topsite_path="";
$url="";
$url_to_cgi="";

require "variables.pl";

$version = "3.05";
$v1= 3;
$v2 = 0;
$v3 = 5;

$demo=0;

print "Content-type: text/html\n\n ";

read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
@pairs = split(/&/, $buffer);
foreach $pair (@pairs) {
	($name, $value) = split(/=/, $pair);
	$value =~ tr/+/ /;
	$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
#print "$name - $value <BR>";
	if ($INPUT{$name}) { $INPUT{$name} = $INPUT{$name}.",".$value; }
	else { $INPUT{$name} = $value; }
}

@months = ('Jan.','Feb.','March','Apr.','May','June','July','Aug.','Sept.','Oct.','Nov.','Dec');

$time = time;
$reset_offset = $reset_offset * 3600;
$time = $time + $reset_offset;
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);
$mon++;
$year += 1900;
$now = "$mon.$mday.$year";
$sunday = $yday - $wday;

$cgiurl = $ENV{'SCRIPT_NAME'};

$crons = "";
$crons=$ENV{'REMOTE_ADDR'};
unless ($crons) { &cron; }

&Header;

if ($path) {
	if ( -e "$path/data/password.txt") {
		open (VARIABLES, "$path/data/password.txt") || &error("Error reading password.txt");
		$admin_password = <VARIABLES>;
		close (VARIABLES);
	}
}


if ($INPUT{'log'}) { &log; }
elsif ($INPUT{'del'}) { &del; }
elsif ($INPUT{'setup_2'}) { &setup_2; }
elsif ($INPUT{'setup_4'}) { &setup_4; }
elsif ($INPUT{'setup_6'}) { &setup_6; }
elsif ($INPUT{'setup_9'}) { &setup_9; }
elsif ($INPUT{'setup_10'}) { &setup_10; }

elsif ($INPUT{'features'}) { &features; }
elsif ($INPUT{'features_gen'}) { &features_gen; }
elsif ($INPUT{'features_settings'}) { &features_settings; }
elsif ($INPUT{'features_adbreak'}) { &features_adbreak; }
elsif ($INPUT{'features_sotm'}) { &features_sotm; }

elsif ($INPUT{'upgrade'}) { &upgrade; }
elsif ($INPUT{'upgrade_final'}) { &upgrade_final; }

elsif ($INPUT{'view'}) { &view; }
elsif ($INPUT{'browse'}) { &browse; }
elsif ($INPUT{'browser'}) { &browser; }
elsif ($INPUT{'del_final'}) { &del_final; }
elsif ($INPUT{'rename'}) { &rename; }
elsif ($INPUT{'rename_final'}) { &rename_final; }
elsif ($INPUT{'edit'}) { &edit; }
elsif ($INPUT{'edit_headers'}) { &edit_head_foot; }
elsif ($INPUT{'edit_footers'}) { &edit_head_foot; }
elsif ($INPUT{'edit_ad'}) { &edit_head_foot; }
elsif ($INPUT{'new_headers'}) { &new_head_foot; }
elsif ($INPUT{'new_footers'}) { &new_head_foot; }
elsif ($INPUT{'new_ad'}) { &new_head_foot; }
elsif ($INPUT{'code'}) { &code; }
elsif ($INPUT{'code_final'}) { &code_final; }
elsif ($INPUT{'update'}) { &update; }
elsif ($INPUT{'updatecron'}) { &updatecron; }
elsif ($INPUT{'acc_update'}) { &acc_update; }
elsif ($INPUT{'edit_final'}) { &edit_final; }
elsif ($INPUT{'edit_final_head_foot'}) { &edit_final_head_foot; }
elsif ($INPUT{'delw'}) { &delw; }
elsif ($INPUT{'deln'}) { &deln; }
elsif ($INPUT{'del'}) { &del; }
elsif ($INPUT{'sendemail'}) { &sendemail; }
elsif ($INPUT{'emailcron'}) { &emailcron; }
elsif ($INPUT{'sentemail'}) { &sentemail; }
elsif ($INPUT{'backup'}) { &backup; }
elsif ($INPUT{'restore'}) { &restore; }
elsif ($INPUT{'stats'}) { &stats; }
else { &main; }
exit;

sub setup {

print <<EOF;
<FORM METHOD=POST ACTION="$cgiurl">
<table cellspacing =0 cellpadding =8 border=0 width=85%>
<TR><TD align=left colspan=2>
<font face=arial size=-1>
<b>Welcome To Top Sites Professional</b><BR><BR>
Before you can start building your Top Sites, and increasing the number of visitors to your site, 
we need to configure a few variables for the program to run correctly on your server.<BR><BR>
This setup has been built in such a way as to make this set-up as quick and easy for you.
Should you have any questions, the <a href="http://solutionscripts.com/lounge/topsites">Top Sites Pro. Members Lounge</a> has a forum to help you out. 
Just describe your problem and copy and paste the few lines in the small text at the bottom, this will greatly help us to help you.<br><br>
Thank you again for purchasing Top Sites Professional<br>
Tim Watson, <a href="mailto:solutions\@solutionscripts.com">Solution Scripts</a>........

<BR><BR><BR>
<b>Step 1</b><br>
EOF
if ($admin_password) {
print <<EOF;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Step 1 is where we usually ask you for your password, but since yours is already set, all we need you to do
is enter it in below, to verfiy that it is correct, and we can proceed with the rest of the setup questions
EOF
}
else {
print <<EOF;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
We will first need to set your admininstrative password, giving you access to this file and all the admin features.
After you finish this setup, and reload admin.cgi the next time, you will be asked for this password.
EOF
}

print <<EOF;
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Password:</b>
</TD>
<TD><input type="Password" name="password" size="30"></TD>
</TR>
<TR><TD colspan=2 >
<font face=arial size=-1>
<br><br>When you are done, <input type="Submit" name="setup_2" value="Proceed to Step 2">
</FORM>
<br><br><br>
</font>
<font face=arial size=-2>
Server Software -- $ENV{'SERVER_SOFTWARE'}<BR>
Server Name -- $ENV{'SERVER_NAME'}<BR>
Doc. Root -- $ENV{'DOCUMENT_ROOT'}<BR>
Script Filename -- $ENV{'SCRIPT_FILENAME'}<BR>
</FONT>
</TD></TR></TABLE> 


EOF
&Footer;
exit;
}

sub setup_2 {


if ($admin_password) {
	$password = $INPUT{'password'};
	&checkpassword;
}
else {
	$newpassword = crypt($INPUT{'password'}, ai);
	$password = $INPUT{'password'};
	
	open (VARIABLES, "variables.pl") || &error("Error reading variables.pl");
	@variables = <VARIABLES>;
	close (VARIABLES);

	$variables[1] = " \n";
	$variables[2] = " \n";
	$variables[3] = " \n";
	$variables[4] = " \n";
	$variables[5] = " \n";
	$variables[6] = " \n";
	$variables[7] = " \n";
	$variables[8] = " \n";
	$variables[9] = " \n";
	$variables[10] = " \n";
	$variables[11] = " \n";										
	$variables[12] = "\n";
	
	$varilength = push(@variables);
	$varilength = $varilength-1;
	chomp($variables[$varilength]);
	unless ($variables[$varilength] eq '1\;') {
		$varilength++;
		$variables[$varilength] = "\n1\;";
	}
	
	open (VARIABLES, ">variables.pl") || &error("Error writing variables.pl");
	print VARIABLES @variables;
	close (VARIABLES);


}

print <<EOF;
<FORM METHOD=POST ACTION="$cgiurl">
<input type="Hidden" name="password" value="$password">
<table cellspacing =0 cellpadding =8 border=0 width=85%>
<TR><TD colspan=2 >
<font face=arial size=-1>
<center><B>Top Sites Setup, Steps 2 & 3</B></center>
<BR><BR>
<b>Step 2</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
We will first start by giving a name to your Top Sites program. So when members sign up amoung other times
they will see something like "The top 100 coolest web sites", where The top 100 coolest web sites would be the name.
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Top Site name:</b>
</TD>
<TD><input type="Text" name="setup_name" value="$topsite_name" size="30"></TD>
</TR>
<TR><TD colspan=2 >
<font face=arial size=-1>
<BR><BR>
<b>Step 3</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Now we need your email address. This will be the "from" email address on all emails sent to members, and the
one that they will be refered to should they have a question or problem. 
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Your Email Address:</b>
</TD>
<TD><input type="Text" name="setup_email" value="$your_email" size="30"></TD>
</TR>
<TR><TD colspan=2 >
<font face=arial size=-1>
<br><br>When you are done, <input type="Submit" name="setup_4" value="Proceed to Step 4">
</FORM>
</TD></TR></TABLE> 

EOF
&Footer;
exit;
}

sub setup_4 {

$password = $INPUT{'password'};
if ($admin_password) {
	&checkpassword;
}

$error=0;
$error_name=0;
$error_email = 0;

unless ($INPUT{'setup_name'}) {
	$error=1;
	$error_name = "You must enter a name for your Top Sites program. You can always change it later";
}
unless ($INPUT{'setup_email'} =~ /.*\@.*\..*/) {
	$error=1;
	$error_email = "Problems have been detected with the email address you entered, please check it";
}
if ($error) {

print <<EOF;
<FORM METHOD=POST ACTION="$cgiurl">
<input type="Hidden" name="password" value="$password">
<table cellspacing =0 cellpadding =8 border=0 width=85%>
<TR><TD colspan=2 >
<font face=arial size=-1>
<center><B>Top Sites Pro. Setup, Steps 2 & 3</B></center>
<BR><BR>
EOF
if ($error_name) {
print <<EOF;
<b>Step 2</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
$error_name
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Top Site name:</b>
</TD>
<TD><input type="Text" name="setup_name" value="$INPUT{'setup_name'}" size="30"></TD>
</TR>
EOF
}
else {
	print "<input type=\"hidden\" name=\"setup_name\" value=\"$INPUT{'setup_name'}\">\n";
}
if ($error_email) {
print <<EOF;
<TR><TD colspan=2 >
<font face=arial size=-1>
<BR><BR>
<b>Step 3</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
$error_email
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Your Email Address:</b>
</TD>
<TD><input type="Text" name="setup_email" value="$INPUT{'setup_email'}" size="30"></TD>
</TR>
EOF
}
else {
	print"<input type=\"Hidden\" name=\"setup_email\" value=\"$INPUT{'setup_email'}\">\n";
}

print <<EOF;
<TR><TD colspan=2 >
<font face=arial size=-1>
<br><br>When you have fixed your errors, <input type="Submit" name="setup_4" value="Proceed to Step 4">
</FORM>
</TD></TR></TABLE> 
EOF
&Footer;
exit;
}

$INPUT{'setup_email'} =~ s/\@/\\\@/ig;

	open (VARIABLES, "variables.pl");
	@variables = <VARIABLES>;
	close (VARIABLES);

	unless ($demo) {
		$variables[1] = "\$topsite_name \= \"$INPUT{'setup_name'}\"\;\n";
		$variables[6] = "\$your_email \= \"$INPUT{'setup_email'}\"\;\n";
	}
			
	$varilength = push(@variables);
	$varilength = $varilength-1;
	chomp($variables[$varilength]);
	unless ($variables[$varilength] =~ /^1/) {
		$varilength++;
		$variables[$varilength] = "\n1\;";
	}
	open (VARIABLES, ">variables.pl");
	print VARIABLES @variables;
	close (VARIABLES);

$current_path = $ENV{'SCRIPT_FILENAME'};
$current_path =~ s/admin\.cgi//ig;

print <<EOF;
<FORM METHOD=POST ACTION="$cgiurl">
<input type="Hidden" name="password" value="$password">
<table cellspacing =0 cellpadding =8 border=0 width=85%>
<TR><TD colspan=2 >
<font face=arial size=-1>
<center><B>Top Sites Pro. Setup, Steps 4 & 5</B></center>
<BR><BR>
The next 2 steps will need you to enter a path, a path is the system of folders, we need the paths
so we can store the data files and Top Sites page in the correct spot. A path will be something like: 
<font color=red>/mnt/web/guide/solutionscripts/topsitespro</font> The path <B>is not the url</b> and <B>does not
start with http://</B>. With that said, and using a few enviromental variables of perl, we have helped you out a bit
by finding that the path to the dir that admin.cgi (this script) is in, is: <font color=red>$current_path</FONT>,
but of course the path you need to or want to use may be different.
<BR><BR>

<b>Step 4</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
The first path we need is the path to where you want the data for Top Sites to be stored. This dir should not
be readable from the web. Either below your root is good, or in a cgi-bin where text files can not be accessed by the browser.
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Data Path:</b>
</TD>
<TD><input type="Text" name="setup_path" value="$path" size="40"></TD>
</TR>
<TR><TD colspan=2 >
<font face=arial size=-1>
<BR><BR>
<b>Step 5</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Now we need the path that will hold the Top Sites pages (web site rankings), this dir should be readable from the web at all times. 
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Top Site Path:</b>
</TD>
<TD><input type="Text" name="setup_freepath" value="$topsites_path" size="40"></TD>
</TR>
<TR><TD colspan=2 >
<font face=arial size=-1>
<br><br>When you are done, <input type="Submit" name="setup_6" value="Proceed to Step 6">
</FORM>
</TD></TR></TABLE> 

EOF
&Footer;
exit;

}

sub setup_6 {

$password = $INPUT{'password'};
if ($admin_password) {
	&checkpassword;
}

$error=0;
$error_path = 0;
$error_freepath = 0;

unless ($INPUT{'setup_path'}) {
	$error=1;
	$error_path = "You must enter a path to your data dir";
}
unless ($INPUT{'setup_freepath'}) {
	$error=1;
	$error_freepath = "You must enter a path to where you want the Top Sites ranking created";
}

unless ( $error_path || (-e "$INPUT{'setup_path'}")) {
	$error =1;
	$error_path = "The path you entered does not correspond to an actually dir that exsists";
}
unless ( $error_freepath || (-e "$INPUT{'setup_freepath'}")) {
	$error =1;
	$error_freepath = "The path you entered does not correspond to an actually dir that exsists";
}
unless ( $error_path) {
	open (DAT,">$INPUT{'setup_path'}/test.html") || ($error_path = "$!");
	print DAT "This is just a test, you can delete me";
	close (DAT);	
	unlink("$INPUT{'setup_path'}/test.html");
}
unless ( $error_freepath) {

	open (DAT,">$INPUT{'setup_freepath'}/test.html") || ($error_freepath = "$!");
	print DAT "This is just a test, you can delete me";
	close (DAT);
	unlink("$INPUT{'setup_freepath'}/test.html");
}
if ($error_path || $error_freepath) {
	$error = 1;
}

if ($error) {
print <<EOF;
<FORM METHOD=POST ACTION="$cgiurl">
<input type="Hidden" name="password" value="$password">
<table cellspacing =0 cellpadding =8 border=0 width=85%>
<TR><TD colspan=2 >
<font face=arial size=-1>
<center><B>Top Sites Pro. Setup, Steps 4 & 5</B></center>
EOF
if ($error_path) {
print <<EOF;
<BR><BR>
<b>Step 4</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
There was an error in the path you want the data stored:
<font color="Red">$error_path</font>, if the error was <font color="Red">Pemission Denied</font>
then you must make the dir readable and writable by chmoding it 777. Please do this now.
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Data Path:</b>
</TD>
<TD><input type="Text" name="setup_path" value="$INPUT{'setup_path'}" size="40"></TD>
EOF
}
else {
print <<EOF;
</TD></TR>
<TD>
</TD>
<TD><input type="HIDDEN" name="setup_path" value="$INPUT{'setup_path'}" size="40"></TD>
EOF
}

print <<EOF;
</TR>
<TR><TD colspan=2 >
<font face=arial size=-1>

EOF
if ($error_freepath) {
print <<EOF;
<BR><BR>
<b>Step 5</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
There was an error in the path you want the Top Sites rankings to be:
<font color="Red">$error_freepath</font>, if the error was <font color="Red">Pemission Denied</font>
then you must make the dir readable and writable by chmoding it 777. Please do this now.
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Top Sites Path:</b>
</TD>
<TD><input type="Text" name="setup_freepath" value="$INPUT{'setup_freepath'}" size="40"></TD>
EOF
}
else {
print <<EOF;
</TD></TR>
<TD>
</TD>
<TD><input type="HIDDEN" name="setup_freepath" value="$INPUT{'setup_freepath'}" size="40"></TD>
EOF
}
print <<EOF;
</TR>
<TR><TD colspan=2 >
<font face=arial size=-1>
<br><br>When you are done, <input type="Submit" name="setup_6" value="Proceed to Step 6">
</FORM>
</TD></TR></TABLE> 

EOF
&Footer;
exit;
}
else {
	open (VARIABLES, "variables.pl");
	@variables = <VARIABLES>;
	close (VARIABLES);
	
	unless($demo) {
		$variables[2] = "\$path \= \"$INPUT{'setup_path'}\"\;\n";
		$variables[3] = "\$topsites_path \= \"$INPUT{'setup_freepath'}\"\;\n";
	}
	$varilength = push(@variables);
	$varilength = $varilength-1;
	chomp($variables[$varilength]);
	unless ($variables[$varilength] =~ /^1/) {
		$varilength++;
		$variables[$varilength] = "\n1\;";
	}
	open (VARIABLES, ">variables.pl");
	print VARIABLES @variables;
	close (VARIABLES);

	unless (-e "$INPUT{'setup_path'}/data") {
		mkdir("$INPUT{'setup_path'}/data", 0777) || &error("could not create dir: $INPUT{'setup_path'}/data");
	}
	unless (-e "$INPUT{'setup_path'}/members") {	
		mkdir("$INPUT{'setup_path'}/members", 0777) || &error("could not create dir: $INPUT{'setup_path'}/members");
	}
	
	$newpassword = crypt($INPUT{'password'}, ai);

	open (VARIABLES, ">$INPUT{'setup_path'}/data/password.txt") || &error("Error writing password.txt");
	print VARIABLES "$newpassword";
	close (VARIABLES);	

print <<EOF;
<FORM METHOD=POST ACTION="$cgiurl">
<input type="Hidden" name="password" value="$password">
<table cellspacing =0 cellpadding =8 border=0 width=85%>
<TR><TD colspan=2 >
<font face=arial size=-1>
<center><B>Top Sites Pro. Setup, Steps 6 & 7</B></center>
<BR><BR>
Now we need to set a few urls. This is the spot where they need to start with http://. All urls should point to a directory.
<BR><BR>

<b>Step 6</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
The first url is the url to where your cgi files are, the url to the directory where this file is.</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Url to cgi directory:</b>
</TD>
<TD><input type="Text" name="setup_url_to_cgi" value="$url_to_cgi" size="40"></TD>
</TR>
<TR><TD colspan=2 >
<font face=arial size=-1>
<BR><BR>
<b>Step 7</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
The next url we need is the url to the directory where the Top Sites rankings page will be stored. 
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Top Sites Url:</b>
</TD>
<TD><input type="Text" name="setup_url" value="$url" size="40"></TD>
</TR>
<TR><TD colspan=2 >
<font face=arial size=-1>
<br><br>When you are done, <input type="Submit" name="setup_9" value="Proceed to Step 8">
</FORM>
</TD></TR></TABLE> 

EOF
&Footer;
exit;

}

}

########## SETUP 9 ##########
sub setup_9 {

$password = $INPUT{'password'};
&checkpassword;


$error=0;
$error_url_to_cgi=0;
$error_url = 0;

$INPUT{'setup_url_to_cgi'} =~ s/\/$//;
$INPUT{'setup_url'} =~ s/\/$//;

unless ($INPUT{'setup_url_to_cgi'}) {
	$error=1;
	$error_url_to_cgi = "You must enter a url for to where your cgi files are.";
}
unless ($INPUT{'setup_url'}) {
	$error=1;
	$error_url_to_icons = "You must enter a url for to where the Top Sites ranking will be.";
}
if ($error) {

print <<EOF;
<FORM METHOD=POST ACTION="$cgiurl">
<input type="Hidden" name="password" value="$password">
<table cellspacing =0 cellpadding =8 border=0 width=85%>
<TR><TD colspan=2 >
<font face=arial size=-1>
<center><B>Top Sites Pro. Setup, Steps 6 & 7</B></center>

EOF
if ($error_url_to_cgi) {
print <<EOF;
<br><br>
<b>Step 6</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
$error_url_to_cgi.</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Url to cgi directory:</b>
</TD>
<TD><input type="Text" name="setup_url_to_cgi" value="$INPUT{'setup_url_to_cgi'}" size="40"></TD>
EOF
}
else {
print <<EOF;
</TD></TR>
<TD>
</TD>
<TD><input type="HIDDEN" name="setup_url_to_cgi" value="$INPUT{'setup_url_to_cgi'}" size="40"></TD>
EOF

}
print <<EOF;
</TR>
<TR><TD colspan=2 >
<font face=arial size=-1>
EOF
if ($error_url) {
print <<EOF;
<BR><BR>
<b>Step 7</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
The next url we need is the url to the directory where the Top Sites rankings will be stored. 
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Top Sites Url:</b>
</TD>
<TD><input type="Text" name="setup_url" value="$INPUT{'setup_url'}" size="40"></TD>
EOF
}
else {
print <<EOF; 
</TD></TR>
<TD>
</TD>
<TD><input type="HIDDEN" name="setup_url" value="$INPUT{'setup_url'}" size="40"></TD>
EOF
}
print <<EOF;

</TR><TR><TD colspan=2 >
<font face=arial size=-1>
<br><br>When you are done, <input type="Submit" name="setup_9" value="Proceed to Step 8">
</FORM>
</TD></TR></TABLE> 

EOF
&Footer;
exit;
}
else {
	open (VARIABLES, "variables.pl");
	@variables = <VARIABLES>;
	close (VARIABLES);

	unless($demo) {
		$variables[4] = "\$url \= \"$INPUT{'setup_url'}\"\;\n";
		$variables[5] = "\$url_to_cgi \= \"$INPUT{'setup_url_to_cgi'}\"\;\n";
	}	
	$varilength = push(@variables);
	$varilength = $varilength-1;
	chomp($variables[$varilength]);
	unless ($variables[$varilength] =~ /^1/) {
		$varilength++;
		$variables[$varilength] = "\n1\;";
	}
	open (VARIABLES, ">variables.pl");
	print VARIABLES @variables;
	close (VARIABLES);

print <<EOF;
<FORM METHOD=POST ACTION="$cgiurl">
<input type="Hidden" name="password" value="$password">
<table cellspacing =0 cellpadding =8 border=0 width=85%>
<TR><TD colspan=2 >
<font face=arial size=-1>
<center><B>Top Sites Pro Setup, Step 8</B></center>
<BR><BR>
And finially step 8, the last and most trickest for some. The path to your sendmail program or smtp account. This is needed
to send out all emails to your accounts. Sendmail is usually available only on unix systems, if your on NT you would want to use smtp.
<b>Fill out only one text box, the one you plan on using.</B>
<BR><BR><b>Step 8</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
The path to sendmail is not the same on all servers, you may have to ask your server admin ir check other cgi files
that might already use it, or look in the dirs. /usr/sbin,  /usr/lib, or /usr/bin for a program called sendmail
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Path to sendmail:</b>
</TD>
<TD><input type="Text" name="setup_mail_prog" value="$mail_prog" size="40"></TD>
</TR>
<TR><TD colspan=2 >
<font face=arial size=-1>
<BR><BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
The STMP Server is your main mail server you use with your isp. The same one you put in Microsoft Outlook or Netscape Mail to send out email.
Something like <font color="Red">mail.earthlink.net</font>. Ask your isp or network admin if you are not sure.
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>SMTP Server:</b>
</TD>
<TD><input type="Text" name="setup_smtp" value="$smtp" size="40"></TD>
</TR>


<TR><TD colspan=2 >
<font face=arial size=-1>
<br><br>When you are done, you are done... <input type="Submit" name="setup_10" value="Proceed to the main admin screen">
</FORM>
</TD></TR></TABLE> 

EOF
&Footer;
exit;
}

}

########## FINAL SETUP CHECK ##########
sub setup_10 {

$password = $INPUT{'password'};
&checkpassword;


$error=0;
$error_url = 0;

unless ($INPUT{'setup_mail_prog'}) {
	unless ($INPUT{'setup_smtp'}) {
		$error=1;
		$error_url = "You must enter a path for either sendmail or your smtp server.";
	}
}
if ($INPUT{'setup_mail_prog'} && $INPUT{'setup_smtp'}) {
	$error=1;
	$error_url = "You must enter a path for either sendmail or your smtp server, not both.";
}


if ($error){
print <<EOF;
<FORM METHOD=POST ACTION="$cgiurl">
<input type="Hidden" name="password" value="$password">
<table cellspacing =0 cellpadding =8 border=0 width=85%>
<TR><TD colspan=2 >
<font face=arial size=-1>
<center><B>Top Sites Pro Setup, Step 8</B></center>
<BR><BR>
There was an error in the last form you filled out:<BR><font color="Red">$error_url</font><BR><BR>
And finially step 8, the last and most trickest for some. The path to your sendmail program or smtp account. This is needed
to send out all emails to your accounts. Sendmail is usually available only on unix systems, if your on NT you would want to use smtp.
<b>Fill out only one text box, the one you plan on using.</B>
<BR><BR><b>Step 8</b><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
The path to sendmail is not the same on all servers, you may have to ask your server admin ir check other cgi files
that might already use it, or look in the dirs. /usr/sbin,  /usr/lib, or /usr/bin for a program called sendmail
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>Path to sendmail:</b>
</TD>
<TD><input type="Text" name="setup_mail_prog" value="$INPUT{'setup_mail_prog'}" size="40" maxlength="50"></TD>
</TR>
<TR><TD colspan=2 >
<font face=arial size=-1>
<BR><BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
The SMTP Server is your main mail server you use with your isp. The same one you put in Microsoft Outlook or Netscape Mail to send out email.
Something like <font color="Red">mail.earthlink.net</font>. Ask your isp or network admin if you are not sure.
</TD></TR>
<TD bgcolor = #e4e4e4><font face=arial size=-1><b>SMTP Server:</b>
</TD>
<TD><input type="Text" name="setup_smtp" value="$INPUT{'setup_smtp'}" size="40" maxlength="50"></TD>
</TR>


<TR><TD colspan=2 >
<font face=arial size=-1>
<br><br>When you are done, you are done... <input type="Submit" name="setup_10" value="Proceed to the main admin screen">
</FORM>
</TD></TR></TABLE> 

EOF
&Footer;
exit;


}
else {
	open (VARIABLES, "variables.pl");
	@variables = <VARIABLES>;
	close (VARIABLES);
	unless($demo) {
		$variables[8] = "\$mail_prog \= \"$INPUT{'setup_mail_prog'}\"\;\n";
		$variables[7] = "\$smtp \= \"$INPUT{'setup_smtp'}\"\;\n";
	}	
	$varilength = push(@variables);
	$varilength = $varilength-1;
	chomp($variables[$varilength]);
	unless ($variables[$varilength] =~ /^1/) {
		$varilength++;
		$variables[$varilength] = "\n1\;";
	}
	open (VARIABLES, ">variables.pl");
	print VARIABLES @variables;
	close (VARIABLES);

&log;
}
}

########## FEATURES EDIT ##########
sub features {
$password = $INPUT{'password'};
&checkpassword;

if ($INPUT{'features_edit'} =~ /Top Sites Setup/i) {
	&setup_2;
}
elsif ($INPUT{'features_edit'} =~ /General Operations/i) {

unless ($topsite_file) {
	$topsite_file = "topsites.html";
}
unless ($pages) {
	$pages = "1";
}

print <<EOF;
<font face=arial size=-1>
<center><B>General Top Sites Operations</B>
<BR><BR>
<BLOCKQUOTE>
For more information on what each item is and does, click on the help icon</BLOCKQUOTE>
<FORM METHOD=POST ACTION="$cgiurl">
<input type="Hidden" name="password" value="$password">
<table cellspacing =0 cellpadding =4 border=0>
<TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#1" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Choose a filename and extension for your Top Sites:
</TD><TD>
<input type="Text" name="topsite_file" value="$topsite_file" size=15>
</TD></TR><TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#2"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>How many sites do you want ranked:
</TD><TD>
<input type="Text" name="ranked" value="$ranked" size=4>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#3"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Spread those ranking over this many pages:
</TD><TD>
<input type="Text" name="pages" value="$pages" size=4>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#4"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>How would you liked the sites ranked:
</TD><TD>
EOF
$rhitstoday = "";
$rtotal = "";
$rtoday = "";
$rweek = "";
$rmonth = "";

if ($how_rank eq 'hitsday') {
	$rhitsday = "SELECTED";
}
elsif ($how_rank eq 'today') {
	$rtoday = "SELECTED";
}
elsif ($how_rank eq 'week') {
	$rweek = "SELECTED";
}
elsif ($how_rank eq 'month') {
	$rmonth = "SELECTED";
}
elsif ($how_rank eq 'total') {
	$rtotal = "SELECTED";
}

print<<EOF;
<select name="how_rank">
<option value="total" $rtotal>Total Hits
<option value="hitsday" $rhitsday>Hits/Day
<option value="today" $rtoday>Hits Today
<option value="week" $rweek>Hits this Week
<option value="month" $rmonth>Hits this Month
</select>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#5"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>In seconds the time it takes before another hit from same ip counts:
</TD><TD>
<input type="Text" name="ip_time" value="$ip_time" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#6"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Display the "Next update at:" on the Top Sites page:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="next_update"
EOF
	if ($next_update) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#7"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>In seconds the time between Top Sites updates (even if using cron):
</TD><TD>
<input type="Text" name="update" value="$update" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#8"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If the daily total should reset at a different time than midnight, enter the hour offset:
</TD><TD>
<input type="Text" name="reset_offset" value="$reset_offset" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#9"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Are you using crontabs to update Top Sites:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="cron"
EOF
	if ($cron) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#10"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show Solution Scripts credit footer:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="credit"
EOF
	if ($credit) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#11"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Use anti-cheat gateway:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="gateway"
EOF
	if ($gateway) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#12"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Make user agree to terms and conditions on signup:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="terms"
EOF
	if ($terms) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#13"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show site on rankings even if they have zero hits in:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="show_zero"
EOF
	if ($show_zero) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#14"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Use file locking (flock):
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="use_flock"
EOF
	if ($use_flock) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>


<TR><TD colspan=2>
<font face=arial size=-1><B>Display Options</FONT></B><BR>
<font face=arial size=-2>For more details and examples on the display options, <a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#options">click here</a></FONT>
</TD></TR><TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#15"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Rank of the site:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="d_rank"
EOF
	if ($d_rank) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR><TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#16"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Hits/Day:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="d_hitsday"
EOF
	if ($d_hitsday) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR><TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#17"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Total Hits in:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="d_totalin"
EOF
	if ($d_totalin) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#18"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Hits in Today:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="d_todayin"
EOF
	if ($d_todayin) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#19"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Hits in this week:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="d_weekin"
EOF
	if ($d_weekin) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#20"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Hits in this month:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="d_monthin"
EOF
	if ($d_monthin) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#21"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Hits out Total:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="d_totalout"
EOF
	if ($d_totalout) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#22"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Hits out Today:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="d_todayout"
EOF
	if ($d_todayout) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#23"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Hits out this week:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="d_weekout"
EOF
	if ($d_weekout) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.2.shtml#24"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Hits out this month:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="d_monthout"
EOF
	if ($d_monthout) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD colspan=2><br><br><CENTER>
<input type="Submit" name="features_gen" value=" Store these values ">
</TR></TD>
</TABLE>
</FORM>
EOF
&Footer;
exit;
}
elsif ($INPUT{'features_edit'} =~ /Style and Colors/i) {

print <<EOF;
<font face=arial size=-1>
<center><B>Top Sites Style and Color Setup</B>
<BR><BR>
<BLOCKQUOTE>
For more information on what each item is and does, click on the help icon</BLOCKQUOTE>
<FORM METHOD=POST ACTION="$cgiurl">
<input type="Hidden" name="password" value="$password">
<table cellspacing =0 cellpadding =4 border=0>

<TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#1" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Background color:
</TD><TD  bgcolor=$over_bg>
<input type="Text" name="over_bg" value="$over_bg" size=10>
</TD></TR>

<TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#2" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Background image:
</TD><TD  bgcolor=$over_bg>
<input type="Text" name="bg_image" value="$bg_image" size=10>
</TD></TR>
<TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#3" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Text color:
</TD><TD  bgcolor=$text_color>
<input type="Text" name="text_color" value="$text_color" size=10>
</TD></TR><TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#4" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Link color:
</TD><TD  bgcolor=$link_color>
<input type="Text" name="link_color" value="$link_color" size=10>
</TD></TR>



<TR><TD colspan=2><br><CENTER><font face=arial size=-1><b>Table Attirbutes</b></TD></TR>
<TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#5" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Border:
</TD><TD>
<input type="Text" name="table_border" value="$table_border" size=10>
</TD></TR>
<TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#6" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Cellpadding:
</TD><TD>
<input type="Text" name="table_padding" value="$table_padding" size=10>
</TD></TR>
<TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#7" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Cellspacing:
</TD><TD>
<input type="Text" name="table_spacing" value="$table_spacing" size=10>
</TD></TR>
<TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#8" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Table Width:
</TD><TD>
<input type="Text" name="table_width" value="$table_width" size=10>
</TD></TR>
<TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#9" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Background color:
</TD><TD  bgcolor=$table_bg>
<input type="Text" name="table_bg" value="$table_bg" size=10>
</TD></TR><TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#10" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Table Header Background color:
</TD><TD  bgcolor=$table_head_bg>
<input type="Text" name="table_head_bg" value="$table_head_bg" size=10>
</TD></TR><TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#11" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Color of text in header of table:
</TD><TD  bgcolor=$text_table_head>
<input type="Text" name="text_table_head" value="$text_table_head" size=10>
</TD></TR>
<TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#12" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Font type for text in header of table:
</TD><TD>
<input type="Text" name="font_table_head" value="$font_table_head" size=10>
</TD></TR>
<TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#13" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Font size for text in header of table:
</TD><TD>
<input type="Text" name="size_table_head" value="$size_table_head" size=10>
</TD></TR>
<TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#14" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Align text in header of table:
</TD><TD>
<input type="Text" name="align_table_head" value="$align_table_head" size=10>
</TD></TR>






<TR><TD colspan=2><br><br><CENTER><a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#15" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<b>&nbsp;&nbsp;&nbsp;Ranking Groups</b></TD></TR>
<TR><TD colspan=2>
<font face=arial size=-1>
<br><br>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#15" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<b>For rankings 1 to </b><input type="Text" name="r_1_e" value="$r_1_e" size=4>
<input type="Hidden" name="r_1_s" value="1">
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#16"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show Site Name:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="r_1_name"
EOF
	if ($r_1_name) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#17"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show Site Image:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="r_1_image"
EOF
	if ($r_1_image) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#18"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show Site Description:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="r_1_des"
EOF
	if ($r_1_des) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#19"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If name shown, font face of Site Name:
</TD><TD>
<input type="text" name="r_1_fname" value ="$r_1_fname" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#20"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If name shown, font size of Site Name:
</TD><TD>
<input type="text" name="r_1_sname" value ="$r_1_sname" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#21"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If description shown, font face of site description:
</TD><TD>
<font face=arial size=-1><input type="text" name="r_1_fdes" value ="$r_1_fdes" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#22"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If description shown, font size of site description:
</TD><TD>
<input type="text" name="r_1_fsdes" value ="$r_1_fsdes" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#23"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Background color of table:
</TD><TD>
<input type="text" name="r_1_bgcolor" value ="$r_1_bgcolor" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#24"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Text color:
</TD><TD>
<input type="text" name="r_1_text" value ="$r_1_text" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#25"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Text Alignment:
</TD><TD>
<input type="text" name="r_1_align" value ="$r_1_align" size=10>
</TD></TR>

<TR><TD colspan=2>
<font face=arial size=-1>
<br><br>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#15" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<b>For rankings <input type="Text" name="r_2_s" value="$r_2_s" size=4> to </b><input type="Text" name="r_2_e" value="$r_2_e" size=4>

</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#16"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show Site Name:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="r_2_name"
EOF
	if ($r_2_name) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#17"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show Site Image:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="r_2_image"
EOF
	if ($r_2_image) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#18"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show Site Description:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="r_2_des"
EOF
	if ($r_2_des) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#19"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If name shown, font face of Site Name:
</TD><TD>
<input type="text" name="r_2_fname" value ="$r_2_fname" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#20"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If name shown, font size of Site Name:
</TD><TD>
<input type="text" name="r_2_sname" value ="$r_2_sname" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#21"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If description shown, font face of site description:
</TD><TD>
<font face=arial size=-1><input type="text" name="r_2_fdes" value ="$r_2_fdes" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#22"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If description shown, font size of site description:
</TD><TD>
<input type="text" name="r_2_fsdes" value ="$r_2_fsdes" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#23"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Background color of table:
</TD><TD>
<input type="text" name="r_2_bgcolor" value ="$r_2_bgcolor" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#24"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Text color:
</TD><TD>
<input type="text" name="r_2_text" value ="$r_2_text" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#25"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Text Alignment:
</TD><TD>
<input type="text" name="r_2_align" value ="$r_2_align" size=10>
</TD></TR>


<TR><TD colspan=2>
<font face=arial size=-1>
<br><br>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#15" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<b>For rankings <input type="Text" name="r_3_s" value="$r_3_s" size=4> to </b><input type="Text" name="r_3_e" value="$r_3_e" size=4>

</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#16"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show Site Name:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="r_3_name"
EOF
	if ($r_3_name) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#17"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show Site Image:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="r_3_image"
EOF
	if ($r_3_image) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#18"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show Site Description:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="r_3_des"
EOF
	if ($r_3_des) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#19"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If name shown, font face of Site Name:
</TD><TD>
<input type="text" name="r_3_fname" value ="$r_3_fname" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#20"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If name shown, font size of Site Name:
</TD><TD>
<input type="text" name="r_3_sname" value ="$r_3_sname" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#21"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If description shown, font face of site description:
</TD><TD>
<font face=arial size=-1><input type="text" name="r_3_fdes" value ="$r_3_fdes" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#22"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If description shown, font size of site description:
</TD><TD>
<input type="text" name="r_3_fsdes" value ="$r_3_fsdes" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#23"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Background color of table:
</TD><TD>
<input type="text" name="r_3_bgcolor" value ="$r_3_bgcolor" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#24"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Text color:
</TD><TD>
<input type="text" name="r_3_text" value ="$r_3_text" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#25"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Text Alignment:
</TD><TD>
<input type="text" name="r_3_align" value ="$r_3_align" size=10>
</TD></TR>


<TR><TD colspan=2>
<font face=arial size=-1>
<br><br>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#15" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<b>For rankings <input type="Text" name="r_4_s" value="$r_4_s" size=4> to </b><input type="Text" name="r_4_e" value="$r_4_e" size=4>

</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#16"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show Site Name:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="r_4_name"
EOF
	if ($r_4_name) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#17"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show Site Image:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="r_4_image"
EOF
	if ($r_4_image) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#18"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show Site Description:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="r_4_des"
EOF
	if ($r_4_des) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#19"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If name shown, font face of Site Name:
</TD><TD>
<input type="text" name="r_4_fname" value ="$r_4_fname" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#20"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If name shown, font size of Site Name:
</TD><TD>
<input type="text" name="r_4_sname" value ="$r_4_sname" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#21"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If description shown, font face of site description:
</TD><TD>
<font face=arial size=-1><input type="text" name="r_4_fdes" value ="$r_4_fdes" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#22"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>If description shown, font size of site description:
</TD><TD>
<input type="text" name="r_4_fsdes" value ="$r_4_fsdes" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#23"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Background color of table:
</TD><TD>
<input type="text" name="r_4_bgcolor" value ="$r_4_bgcolor" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#24"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Text color:
</TD><TD>
<input type="text" name="r_4_text" value ="$r_4_text" size=10>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.3.shtml#25"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Text Alignment:
</TD><TD>
<input type="text" name="r_4_align" value ="$r_4_align" size=10>
</TD></TR>


<TR><TD colspan=2><br><br><CENTER>
<input type="Submit" name="features_settings" value=" Store these values ">
</TR></TD>
</TABLE>
</FORM>
EOF
&Footer;
exit;
}
elsif ($INPUT{'features_edit'} =~ /Ad Breaks/i) {
if ($pages) {
	$per_page = int($ranked/$pages);
}

print <<EOF;
<font face=arial size=-1>
<center><B>Configure your headers, footers, and ad breaks</B>
<BR><BR>
<BLOCKQUOTE>
For more information on how to configure these, click on the help icon</BLOCKQUOTE>
<FORM METHOD=POST ACTION="$cgiurl">
<input type="Hidden" name="password" value="$password">
<table cellspacing =0 cellpadding =4 border=0>
<TR><TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.1.4.shtml#1" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Choose where you want your advertisement breaks to occur:
</TD><TD>
<input type="Text" name="ad_breaks" value="$the_breaks" size=20>
</TD></TR>
<TR><TD colspan=2>
<font face=arial size=-2>Enter the ranking number of which you want the ad break to occur after.
Seperate those numbers by a comma. You can have as many as you choose.
<BR><BR>
Remember, you currently have it set up to display <font color=red>$per_page</FONT> accounts per page on <font color=red>$pages</font> pages, ranking <font color=red>$ranked</font> sites overall. 
</TD></TR>
<TR><TD colspan=2><br><br><CENTER>
<input type="Hidden" name="features_edit" value="ad break 2">
<input type="Submit" name="features" value="Goto step 2">
</TR></TD>
</TABLE>
</FORM>
EOF
&Footer;
exit;

}
elsif ($INPUT{'features_edit'} =~ /ad break 2/i) {
print <<EOF;
<font face=arial size=-1>
<center><B>Configure your headers, footers, and ad breaks</B>
<BR><BR>
<BLOCKQUOTE>
For more information on how to configure these, <a href="http://solutionscripts.com/man/topsites/1.1.4.shtml" target="main">click here</a></BLOCKQUOTE>
<FORM METHOD=POST ACTION="$cgiurl">
<input type="Hidden" name="password" value="$password">
<table cellspacing =0 cellpadding =4 border=0>
EOF

opendir (DIR, "$path/data") || &error("Unable to open data dir. for reading");
@file = grep { /ad_breaks/ } readdir(DIR);
close (DIR);

opendir (DIR, "$path/data") || &error("Unable to open data dir. for reading");
@fileh = grep { /headers/ } readdir(DIR);
close (DIR);

opendir (DIR, "$path/data") || &error("Unable to open data dir. for reading");
@filef = grep { /footers/ } readdir(DIR);
close (DIR);

@breaks = split(/\,/,$INPUT{'ad_breaks'});

$a=1;
while ($a <= $pages) {

print <<EOF;
<TR><TD colspan=2>
<a href="http://solutionscripts.com/man/topsites/1.1.4.shtml#2" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1><b>Page <font color=red>$a</FONT></b></TD></TR>
<TR><TD valign=center>
&nbsp;&nbsp;&nbsp;<a href="http://solutionscripts.com/man/topsites/1.1.4.shtml#3" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Page Header</font>:
</TD><TD>
<select name="headers$a">
EOF
	$ab = $a-1;
	foreach $fil(@fileh) {
		if ($fil eq $headers[$ab]) { 
			$sel = " SELECTED";
		}
		else {
			$sel = " ";
		}
		open (DAT,"<$path/data/$fil"); 
		@he = <DAT>;
		close (DAT);

		print "<option value=\"$fil\"$sel>$fil - $he[0]\n";
	}
print <<EOF;
</select>
</TD></TR>
EOF
	$b=0;
	foreach $br(@breaks) {
		@bre = split(/\z/,$ad_break{$a});
		$thepage = "breakz".$a."z".$br;
print <<EOF;
<TR><TD valign=center>
&nbsp;&nbsp;&nbsp;<a href="http://solutionscripts.com/man/topsites/1.1.4.shtml#4" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Ad break after rank <font color=red>$br</font>:
</TD><TD>
<select name="$thepage">
EOF

		foreach $fil(@file) {
			if ($fil eq $bre[$b]) { 
				$sel = " SELECTED";
			}
			else {
				$sel = " ";
			}
			open (DAT,"<$path/data/$fil"); 
			@hes = <DAT>;
			close (DAT);

			print "<option value=\"$fil\"$sel>$fil - $hes[0]\n";
		}
print <<EOF;
</select>
</TD></TR>
EOF
	$b++;
	}
print <<EOF;
<TR><TD valign=center>
&nbsp;&nbsp;&nbsp;<a href="http://solutionscripts.com/man/topsites/1.1.4.shtml#5" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Page Footer</font>:
</TD><TD>
<select name="footers$a">
EOF
	$ab = $a-1;
	foreach $fil(@filef) {
		if ($fil eq $footers[$ab]) { 
			$sel = " SELECTED";
		}
		else {
			$sel = " ";
		}
		open (DAT,"<$path/data/$fil"); 
		@headers = <DAT>;
		close (DAT);

		print "<option value=\"$fil\"$sel>$fil - $headers[0]\n";
	}
print "</SELECT></TD></TR>";
$a++;
}


print<<EOF;
<TR><TD colspan=2><br><br><CENTER>
<input type="Hidden" name="ad_breaks" value="$INPUT{'ad_breaks'}">
<input type="Submit" name="features_adbreak" value=" Store these changes ">
</TR></TD>
</TABLE>
</FORM>
EOF
&Footer;
exit;

}
elsif ($INPUT{'features_edit'} =~ /Site of the Moment/i) {

print <<EOF;
<font face=arial size=-1>
<center><B>"Site of the Moment"</B>
<BR><BR>
<BLOCKQUOTE>
For more information on what each item is and does, click on the help icon</BLOCKQUOTE>
<FORM METHOD=POST ACTION="$cgiurl">
<input type="Hidden" name="password" value="$password">
<table cellspacing =0 cellpadding =4 border=0>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#1" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>"Site of the Moment" name:
</TD><TD>
<input type="Text" name="sotm_name" value="$sotm_name" size=30>
</TD></TR>
<TR><TD colspan=2>
<font face=arial size=2>
<BR><BR><B>Slot 1</B>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#2"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>On/Off:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="sotm_1"
EOF
	if ($sotm_1) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;On
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#3"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>What should be displayed in this slot:
</TD><TD>
EOF
$rrandom = "";
$raccount = "";
$rwrite = "";

if ($sotm_1_how eq 'random') {
	$random = "SELECTED";
}
elsif ($sotm_1_how eq 'account') {
	$raccount = "SELECTED";
}
elsif ($sotm_1_how eq 'write') {
	$rwrite = "SELECTED";
}

print<<EOF;
<select name="sotm_1_how">
<option value="random" $random>Random Account
<option value="account" $raccount>Chosen Account
<option value="write" $rwrite>Written in url
</select>
</TD></TR>
<TR><TD colspan=2>
<font face=arial size=2>
If <b>"Chosen Account"</b> selected above:
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#4" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>Enter Account name:
</TD><TD>
<input type="Text" name="sotm_1_account" value="$sotm_1_account" size=15>
</TD></TR>
<TR><TD colspan=2>
<font face=arial size=2>
If <B>"Random Account"</B> or <b>"Chosen Account"</b> selected above:
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#5"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show account description:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="sotm_1_acc_des"
EOF
	if ($sotm_1_acc_des) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#6"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show account Banner:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="sotm_1_acc_ban"
EOF
	if ($sotm_1_acc_ban) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD colspan=2>
<font face=arial size=2>
If <b>"Written in url"</b> selected above:
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#7" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>Site name:
</TD><TD>
<input type="Text" name="sotm_1_w_name" value="$sotm_1_w_name" size=30>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#8" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>Site url:
</TD><TD>
<input type="Text" name="sotm_1_w_url" value="$sotm_1_w_url" size=30>
</TD></TR>

<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#9" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>If description, enter description:
</TD><TD>
<input type="Text" name="sotm_1_w_des" value="$sotm_1_w_des" size=30>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#10" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>If banner, enter banner url:
</TD><TD>
<input type="Text" name="sotm_1_w_ban" value="$sotm_1_w_ban" size=30>
</TD></TR>

<TR><TD colspan=2>
<font face=arial size=2>
<BR><BR><B>Slot 2</B>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#2"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>On/Off:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="sotm_2"
EOF
	if ($sotm_2) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;On
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#3"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>What should be displayed in this slot:
</TD><TD>
EOF
$rrandom = "";
$raccount = "";
$rwrite = "";

if ($sotm_2_how eq 'random') {
	$random = "SELECTED";
}
elsif ($sotm_2_how eq 'account') {
	$raccount = "SELECTED";
}
elsif ($sotm_2_how eq 'write') {
	$rwrite = "SELECTED";
}

print<<EOF;
<select name="sotm_2_how">
<option value="random" $random>Random Account
<option value="account" $raccount>Chosen Account
<option value="write" $rwrite>Written in url
</select>
</TD></TR>
<TR><TD colspan=2>
<font face=arial size=2>
If <b>"Chosen Account"</b> selected above:
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#4" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>Enter Account name:
</TD><TD>
<input type="Text" name="sotm_2_account" value="$sotm_2_account" size=15>
</TD></TR>
<TR><TD colspan=2>
<font face=arial size=2>
If <B>"Random Account"</B> or <b>"Chosen Account"</b> selected above:
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#5"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show account description:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="sotm_2_acc_des"
EOF
	if ($sotm_2_acc_des) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#6"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show account Banner:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="sotm_2_acc_ban"
EOF
	if ($sotm_2_acc_ban) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD colspan=2>
<font face=arial size=2>
If <b>"Written in url"</b> selected above:
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#7" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>Site name:
</TD><TD>
<input type="Text" name="sotm_2_w_name" value="$sotm_2_w_name" size=30>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#8" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>Site url:
</TD><TD>
<input type="Text" name="sotm_2_w_url" value="$sotm_2_w_url" size=30>
</TD></TR>

<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#9" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>If description, enter description:
</TD><TD>
<input type="Text" name="sotm_2_w_des" value="$sotm_2_w_des" size=30>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#10" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>If banner, enter banner url:
</TD><TD>
<input type="Text" name="sotm_2_w_ban" value="$sotm_2_w_ban" size=30>
</TD></TR>


<TR><TD colspan=2>
<font face=arial size=2>
<BR><BR><B>Slot 3</B>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#2"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>On/Off:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="sotm_3"
EOF
	if ($sotm_3) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;On
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#3"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>What should be displayed in this slot:
</TD><TD>
EOF
$rrandom = "";
$raccount = "";
$rwrite = "";

if ($sotm_3_how eq 'random') {
	$random = "SELECTED";
}
elsif ($sotm_3_how eq 'account') {
	$raccount = "SELECTED";
}
elsif ($sotm_3_how eq 'write') {
	$rwrite = "SELECTED";
}

print<<EOF;
<select name="sotm_3_how">
<option value="random" $random>Random Account
<option value="account" $raccount>Chosen Account
<option value="write" $rwrite>Written in url
</select>
</TD></TR>
<TR><TD colspan=2>
<font face=arial size=2>
If <b>"Chosen Account"</b> selected above:
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#4" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>Enter Account name:
</TD><TD>
<input type="Text" name="sotm_3_account" value="$sotm_3_account" size=15>
</TD></TR>
<TR><TD colspan=2>
<font face=arial size=2>
If <B>"Random Account"</B> or <b>"Chosen Account"</b> selected above:
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#5"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show account description:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="sotm_3_acc_des"
EOF
	if ($sotm_3_acc_des) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#6"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show account Banner:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="sotm_3_acc_ban"
EOF
	if ($sotm_3_acc_ban) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD colspan=2>
<font face=arial size=2>
If <b>"Written in url"</b> selected above:
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#7" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>Site name:
</TD><TD>
<input type="Text" name="sotm_3_w_name" value="$sotm_3_w_name" size=30>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#8" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>Site url:
</TD><TD>
<input type="Text" name="sotm_3_w_url" value="$sotm_3_w_url" size=30>
</TD></TR>

<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#9" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>If description, enter description:
</TD><TD>
<input type="Text" name="sotm_3_w_des" value="$sotm_3_w_des" size=30>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#10" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>If banner, enter banner url:
</TD><TD>
<input type="Text" name="sotm_3_w_ban" value="$sotm_3_w_ban" size=30>
</TD></TR>

<TR><TD colspan=2>
<font face=arial size=2>
<BR><BR><B>Slot 4</B>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#2"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>On/Off:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="sotm_4"
EOF
	if ($sotm_4) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;On
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#3"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>What should be displayed in this slot:
</TD><TD>
EOF
$rrandom = "";
$raccount = "";
$rwrite = "";

if ($sotm_4_how eq 'random') {
	$random = "SELECTED";
}
elsif ($sotm_4_how eq 'account') {
	$raccount = "SELECTED";
}
elsif ($sotm_4_how eq 'write') {
	$rwrite = "SELECTED";
}

print<<EOF;
<select name="sotm_4_how">
<option value="random" $random>Random Account
<option value="account" $raccount>Chosen Account
<option value="write" $rwrite>Written in url
</select>
</TD></TR>
<TR><TD colspan=2>
<font face=arial size=2>
If <b>"Chosen Account"</b> selected above:
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#4" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>Enter Account name:
</TD><TD>
<input type="Text" name="sotm_4_account" value="$sotm_4_account" size=15>
</TD></TR>
<TR><TD colspan=2>
<font face=arial size=2>
If <B>"Random Account"</B> or <b>"Chosen Account"</b> selected above:
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#5"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show account description:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="sotm_4_acc_des"
EOF
	if ($sotm_4_acc_des) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#6"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=-1>Show account Banner:
</TD><TD>
<font face=arial size=-1><input type="Checkbox" name="sotm_4_acc_ban"
EOF
	if ($sotm_4_acc_ban) {
		print " CHECKED ";
	}
print <<EOF;
>&nbsp;&nbsp;&nbsp;Yes
</TD></TR>
<TR><TD colspan=2>
<font face=arial size=2>
If <b>"Written in url"</b> selected above:
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#7" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>Site name:
</TD><TD>
<input type="Text" name="sotm_4_w_name" value="$sotm_4_w_name" size=30>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#8" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>Site url:
</TD><TD>
<input type="Text" name="sotm_4_w_url" value="$sotm_4_w_url" size=30>
</TD></TR>

<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#9" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>If description, enter description:
</TD><TD>
<input type="Text" name="sotm_4_w_des" value="$sotm_4_w_des" size=30>
</TD></TR>
<TR><TD>
<a href="http://solutionscripts.com/man/topsites/1.1.5.shtml#10" target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif" align=middle width=20 height=22 border=0></a>&nbsp;&nbsp;&nbsp;
<font face=arial size=2>If banner, enter banner url:
</TD><TD>
<input type="Text" name="sotm_4_w_ban" value="$sotm_4_w_ban" size=30>
</TD></TR>
<TR>
<TD align=center colspan=2>
<BR><BR>
<input type="Submit" name="features_sotm" value=" Save these settings "></FORM>


</TABLE><BR><BR>

<table cellpadding=10 cellspacing=0 border=1>
<TR><TD colspan=2 bgcolor=silver align=center>
<font face=arial size=2>"Site of the Moment" name goes here
</TD></TR>
<TR>
<TD><font face=arial size=2>Slot 1</TD>
<TD><font face=arial size=2>Slot 2</TD>
</TR><TR>
<TD><font face=arial size=2>Slot 3</TD>
<TD><font face=arial size=2>Slot 4</TD>
</TR></TABLE><BR><BR>
EOF
&Footer;
exit;
}
elsif ($INPUT{'setup_4'}) { &setup_4; }



}

########## STORE GENERAL OPERATIONS VALUES ##########
sub features_gen {
if ($demo) {&demo;}

$password=$INPUT{'password'};
&checkpassword;

	open (VARIABLES, "variables.pl");
	@variables = <VARIABLES>;
	close (VARIABLES);

	$variables[10] = "\$topsite_file \= \"$INPUT{'topsite_file'}\"\;\n";
	$variables[11] = "\$ranked \= \"$INPUT{'ranked'}\"\;\n";
	$variables[12] = "\$pages \= \"$INPUT{'pages'}\"\;\n";
	$variables[13] = "\$how_rank \= \"$INPUT{'how_rank'}\"\;\n";
	$variables[14] = "\$d_rank \= \"$INPUT{'d_rank'}\"\;\n";
	$variables[15] = "\$d_hitsday \= \"$INPUT{'d_hitsday'}\"\;\n";
	$variables[16] = "\$d_totalin \= \"$INPUT{'d_totalin'}\"\;\n";
	$variables[17] = "\$d_todayin \= \"$INPUT{'d_todayin'}\"\;\n";
	$variables[18] = "\$d_weekin \= \"$INPUT{'d_weekin'}\"\;\n";
	$variables[19] = "\$d_monthin \= \"$INPUT{'d_monthin'}\"\;\n";
	$variables[20] = "\$d_totalout \= \"$INPUT{'d_totalout'}\"\;\n";
	$variables[21] = "\$d_todayout \= \"$INPUT{'d_todayout'}\"\;\n";
	$variables[22] = "\$d_weekout \= \"$INPUT{'d_weekout'}\"\;\n";
	$variables[23] = "\$d_monthout \= \"$INPUT{'d_monthout'}\"\;\n";
	$variables[24] = "\$credit \= \"$INPUT{'credit'}\"\;\n";
	$variables[25] = "\$gateway \= \"$INPUT{'gateway'}\"\;\n";
	$variables[26] = "\$terms \= \"$INPUT{'terms'}\"\;\n";
	$variables[27] = "\$ip_time \= \"$INPUT{'ip_time'}\"\;\n";
	$variables[28] = "\$update \= \"$INPUT{'update'}\"\;\n";
	$variables[29] = "\$reset_offset \= \"$INPUT{'reset_offset'}\"\;\n";
	$variables[30] = "\$cron \= \"$INPUT{'cron'}\"\;\n";
	$variables[31] = "\$next_update \= \"$INPUT{'next_update'}\"\;\n";
	$variables[32] = "\$show_zero \= \"$INPUT{'show_zero'}\"\;\n";
	$variables[33] = "\$use_flock \= \"$INPUT{'use_flock'}\"\;\n";
				
	foreach $line(@variables) {
		$line =~ s/1\;//;
	}	
	$varilength = push(@variables);
	$variables[$varilength] = "1\;";

	open (VARIABLES, ">variables.pl");
	print VARIABLES @variables;
	close (VARIABLES);
&log("General setup updated");
exit;
}


########## STORE WEB BOARD VALUES ##########
sub features_settings {
if ($demo) {&demo;}

$password=$INPUT{'password'};
&checkpassword;

	open (VARIABLES, "variables.pl");
	@variables = <VARIABLES>;
	close (VARIABLES);

	$variables[34] = "\$over_bg \= \"$INPUT{'over_bg'}\"\;\n";
	$variables[35] = "\$bg_image \= \"$INPUT{'bg_image'}\"\;\n";
	$variables[36] = "\$text_color \= \"$INPUT{'text_color'}\"\;\n";
	$variables[37] = "\$link_color \= \"$INPUT{'link_color'}\"\;\n";
	$variables[38] = "\$table_border \= \"$INPUT{'table_border'}\"\;\n";
	$variables[39] = "\$table_padding \= \"$INPUT{'table_padding'}\"\;\n";
	$variables[40] = "\$table_spacing \= \"$INPUT{'table_spacing'}\"\;\n";
	$variables[41] = "\$table_width \= \"$INPUT{'table_width'}\"\;\n";
	$variables[42] = "\$table_bg \= \"$INPUT{'table_bg'}\"\;\n";
	$variables[43] = "\$table_head_bg \= \"$INPUT{'table_head_bg'}\"\;\n";
	$variables[44] = "\$text_table_head \= \"$INPUT{'text_table_head'}\"\;\n";
	$variables[45] = "\$font_table_head \= \"$INPUT{'font_table_head'}\"\;\n";
	$variables[46] = "\$size_table_head \= \"$INPUT{'size_table_head'}\"\;\n";
	$variables[47] = "\$align_table_head \= \"$INPUT{'align_table_head'}\"\;\n";
	
	$variables[48] = "\$r_1_s \= \"$INPUT{'r_1_s'}\"\;\n";
	$variables[60] = "\$r_2_s \= \"$INPUT{'r_2_s'}\"\;\n";			
	$variables[72] = "\$r_3_s \= \"$INPUT{'r_3_s'}\"\;\n";
	$variables[84] = "\$r_4_s \= \"$INPUT{'r_4_s'}\"\;\n";

	$variables[49] = "\$r_1_e \= \"$INPUT{'r_1_e'}\"\;\n";
	$variables[61] = "\$r_2_e \= \"$INPUT{'r_2_e'}\"\;\n";			
	$variables[73] = "\$r_3_e \= \"$INPUT{'r_3_e'}\"\;\n";
	$variables[85] = "\$r_4_e \= \"$INPUT{'r_4_e'}\"\;\n";

	$variables[50] = "\$r_1_name \= \"$INPUT{'r_1_name'}\"\;\n";
	$variables[62] = "\$r_2_name \= \"$INPUT{'r_2_name'}\"\;\n";			
	$variables[74] = "\$r_3_name \= \"$INPUT{'r_3_name'}\"\;\n";
	$variables[86] = "\$r_4_name \= \"$INPUT{'r_4_name'}\"\;\n";

	$variables[51] = "\$r_1_image \= \"$INPUT{'r_1_image'}\"\;\n";
	$variables[63] = "\$r_2_image \= \"$INPUT{'r_2_image'}\"\;\n";			
	$variables[75] = "\$r_3_image \= \"$INPUT{'r_3_image'}\"\;\n";
	$variables[87] = "\$r_4_image \= \"$INPUT{'r_4_image'}\"\;\n";

	$variables[52] = "\$r_1_des \= \"$INPUT{'r_1_des'}\"\;\n";
	$variables[64] = "\$r_2_des \= \"$INPUT{'r_2_des'}\"\;\n";			
	$variables[76] = "\$r_3_des \= \"$INPUT{'r_3_des'}\"\;\n";
	$variables[88] = "\$r_4_des \= \"$INPUT{'r_4_des'}\"\;\n";			
			
	$variables[53] = "\$r_1_fname \= \"$INPUT{'r_1_fname'}\"\;\n";
	$variables[65] = "\$r_2_fname \= \"$INPUT{'r_2_fname'}\"\;\n";			
	$variables[77] = "\$r_3_fname \= \"$INPUT{'r_3_fname'}\"\;\n";
	$variables[89] = "\$r_4_fname \= \"$INPUT{'r_4_fname'}\"\;\n";			
			
	$variables[54] = "\$r_1_sname \= \"$INPUT{'r_1_sname'}\"\;\n";
	$variables[66] = "\$r_2_sname \= \"$INPUT{'r_2_sname'}\"\;\n";			
	$variables[78] = "\$r_3_sname \= \"$INPUT{'r_3_sname'}\"\;\n";
	$variables[90] = "\$r_4_sname \= \"$INPUT{'r_4_sname'}\"\;\n";			

	$variables[55] = "\$r_1_fdes \= \"$INPUT{'r_1_fdes'}\"\;\n";
	$variables[67] = "\$r_2_fdes \= \"$INPUT{'r_2_fdes'}\"\;\n";			
	$variables[79] = "\$r_3_fdes \= \"$INPUT{'r_3_fdes'}\"\;\n";
	$variables[91] = "\$r_4_fdes \= \"$INPUT{'r_4_fdes'}\"\;\n";			
			
	$variables[56] = "\$r_1_fsdes \= \"$INPUT{'r_1_fsdes'}\"\;\n";
	$variables[68] = "\$r_2_fsdes \= \"$INPUT{'r_2_fsdes'}\"\;\n";			
	$variables[80] = "\$r_3_fsdes \= \"$INPUT{'r_3_fsdes'}\"\;\n";
	$variables[92] = "\$r_4_fsdes \= \"$INPUT{'r_4_fsdes'}\"\;\n";	
			
	$variables[57] = "\$r_1_bgcolor \= \"$INPUT{'r_1_bgcolor'}\"\;\n";
	$variables[69] = "\$r_2_bgcolor \= \"$INPUT{'r_2_bgcolor'}\"\;\n";			
	$variables[81] = "\$r_3_bgcolor \= \"$INPUT{'r_3_bgcolor'}\"\;\n";
	$variables[93] = "\$r_4_bgcolor \= \"$INPUT{'r_4_bgcolor'}\"\;\n";				
			
	$variables[58] = "\$r_1_text \= \"$INPUT{'r_1_text'}\"\;\n";
	$variables[70] = "\$r_2_text \= \"$INPUT{'r_2_text'}\"\;\n";			
	$variables[82] = "\$r_3_text \= \"$INPUT{'r_3_text'}\"\;\n";
	$variables[94] = "\$r_4_text \= \"$INPUT{'r_4_text'}\"\;\n";
			
	$variables[59] = "\$r_1_align \= \"$INPUT{'r_1_align'}\"\;\n";
	$variables[71] = "\$r_2_align \= \"$INPUT{'r_2_align'}\"\;\n";			
	$variables[83] = "\$r_3_align \= \"$INPUT{'r_3_align'}\"\;\n";
	$variables[95] = "\$r_4_align \= \"$INPUT{'r_4_align'}\"\;\n";
			
			
	foreach $line(@variables) {
		$line =~ s/1\;//;
	}	
	$varilength = push(@variables);
	$variables[$varilength] = "1\;";

	open (VARIABLES, ">variables.pl");
	print VARIABLES @variables;
	close (VARIABLES);

&log("Settings and Color setup updated");
exit;
}

########## AD BREAK SETTINGS ##########
sub features_adbreak {
if ($demo) {&demo;}

$password=$INPUT{'password'};
&checkpassword;

@breaks = split(/\,/,$INPUT{'ad_breaks'});

$store = "(";
$heads = "(\"";
$foots ="(\"";
$a=1;
while ($a <= $pages) {
if ($a == 1) {
	$store .= "$a\,";
}
else {
	$store .="\,$a\,";
}
$heads .= $INPUT{'headers'.$a};
$heads .= "\"\,\"";
$foots .= $INPUT{'footers'.$a};
$foots .= "\"\,\"";
	$ab=0;
	foreach $br(@breaks) {
		unless ($ab) {
			$store .= "\"";
		}
		$try = "breakz".$a."z".$br;
		$fun = $INPUT{$try};
		$store .= $fun."z";
		$ab++;
	}
unless ($ab) {
	$store .= "\"";
} 
$store .= "\"";
$a++;
}

$store .= ")\;";
$heads .= "\")\;";
$foots .= "\")\;";

	open (VARIABLES, "variables.pl");
	@variables = <VARIABLES>;
	close (VARIABLES);

	$variables[96] = "\$the_breaks \= \"$INPUT{'ad_breaks'}\"\;\n";
	$variables[97] = "\%ad_break \= $store\n";
	$variables[98] = "\@headers \= $heads\n";
	$variables[99] = "\@footers \= $foots\n";

	foreach $line(@variables) {
		$line =~ s/1\;//;
	}	
	$varilength = push(@variables);
	$variables[$varilength] = "1\;";

	open (VARIABLES, ">variables.pl");
	print VARIABLES @variables;
	close (VARIABLES);

&log("Headers, Footers, Ad Breaks updated");
exit;
}

########### SITE OF THE MOMENT ##########
sub features_sotm {
if ($demo) {&demo;}

$password=$INPUT{'password'};
&checkpassword;


	open (VARIABLES, "variables.pl");
	@variables = <VARIABLES>;
	close (VARIABLES);

	$variables[100] = "\$sotm_name \= \"$INPUT{'sotm_name'}\"\;\n";

	$variables[101] = "\$sotm_1 \= \"$INPUT{'sotm_1'}\"\;\n";
	$variables[110] = "\$sotm_2 \= \"$INPUT{'sotm_2'}\"\;\n";
	$variables[119] = "\$sotm_3 \= \"$INPUT{'sotm_3'}\"\;\n";
	$variables[128] = "\$sotm_4 \= \"$INPUT{'sotm_4'}\"\;\n";

	$variables[102] = "\$sotm_1_how \= \"$INPUT{'sotm_1_how'}\"\;\n";
	$variables[111] = "\$sotm_2_how \= \"$INPUT{'sotm_2_how'}\"\;\n";
	$variables[120] = "\$sotm_3_how \= \"$INPUT{'sotm_3_how'}\"\;\n";
	$variables[129] = "\$sotm_4_how \= \"$INPUT{'sotm_4_how'}\"\;\n";

	$variables[103] = "\$sotm_1_account \= \"$INPUT{'sotm_1_account'}\"\;\n";
	$variables[112] = "\$sotm_2_account \= \"$INPUT{'sotm_2_account'}\"\;\n";
	$variables[121] = "\$sotm_3_account \= \"$INPUT{'sotm_3_account'}\"\;\n";
	$variables[130] = "\$sotm_4_account \= \"$INPUT{'sotm_4_account'}\"\;\n";

	$variables[104] = "\$sotm_1_acc_des \= \"$INPUT{'sotm_1_acc_des'}\"\;\n";
	$variables[113] = "\$sotm_2_acc_des \= \"$INPUT{'sotm_2_acc_des'}\"\;\n";
	$variables[122] = "\$sotm_3_acc_des \= \"$INPUT{'sotm_3_acc_des'}\"\;\n";
	$variables[131] = "\$sotm_4_acc_des \= \"$INPUT{'sotm_4_acc_des'}\"\;\n";

	$variables[105] = "\$sotm_1_acc_ban \= \"$INPUT{'sotm_1_acc_ban'}\"\;\n";
	$variables[114] = "\$sotm_2_acc_ban \= \"$INPUT{'sotm_2_acc_ban'}\"\;\n";
	$variables[123] = "\$sotm_3_acc_ban \= \"$INPUT{'sotm_3_acc_ban'}\"\;\n";
	$variables[132] = "\$sotm_4_acc_ban \= \"$INPUT{'sotm_4_acc_ban'}\"\;\n";

	$variables[106] = "\$sotm_1_w_name \= \"$INPUT{'sotm_1_w_name'}\"\;\n";
	$variables[115] = "\$sotm_2_w_name \= \"$INPUT{'sotm_2_w_name'}\"\;\n";
	$variables[124] = "\$sotm_3_w_name \= \"$INPUT{'sotm_3_w_name'}\"\;\n";
	$variables[133] = "\$sotm_4_w_name \= \"$INPUT{'sotm_4_w_name'}\"\;\n";

	$variables[107] = "\$sotm_1_w_url \= \"$INPUT{'sotm_1_w_url'}\"\;\n";
	$variables[116] = "\$sotm_2_w_url \= \"$INPUT{'sotm_2_w_url'}\"\;\n";
	$variables[125] = "\$sotm_3_w_url \= \"$INPUT{'sotm_3_w_url'}\"\;\n";
	$variables[134] = "\$sotm_4_w_url \= \"$INPUT{'sotm_4_w_url'}\"\;\n";

	$variables[108] = "\$sotm_1_acc_des \= \"$INPUT{'sotm_1_acc_des'}\"\;\n";
	$variables[117] = "\$sotm_2_acc_des \= \"$INPUT{'sotm_2_acc_des'}\"\;\n";
	$variables[126] = "\$sotm_3_acc_des \= \"$INPUT{'sotm_3_acc_des'}\"\;\n";
	$variables[135] = "\$sotm_4_acc_des \= \"$INPUT{'sotm_4_acc_des'}\"\;\n";

	$variables[109] = "\$sotm_1_w_ban \= \"$INPUT{'sotm_1_w_ban'}\"\;\n";
	$variables[118] = "\$sotm_2_w_ban \= \"$INPUT{'sotm_2_w_ban'}\"\;\n";
	$variables[127] = "\$sotm_3_w_ban \= \"$INPUT{'sotm_3_w_ban'}\"\;\n";
	$variables[136] = "\$sotm_4_w_ban \= \"$INPUT{'sotm_4_w_ban'}\"\;\n";

	foreach $line(@variables) {
		$line =~ s/1\;//;
	}	
	$varilength = push(@variables);
	$variables[$varilength] = "1\;";

	open (VARIABLES, ">variables.pl");
	print VARIABLES @variables;
	close (VARIABLES);

&log("Site of the Moment settings updated");
exit;

}

########## MAIN LOOP ....... ASK FOR PASSWORD OR SEND TO SET UP ##########
sub main {

unless ($topsite_name && $path && $topsites_path && $url && $url_to_cgi) {
	&setup;
}

unless ($no_stats) {

eval { 
use Config;
};
$total_hits=0;
$total_out =0;


opendir (DIR, "$path/members");
@file = grep { /.txt/ } readdir(DIR);
close (DIR);

$numaccounts = push(@file);

foreach $line(@file) {

	open (DAT,"<$path/members/$line");
	if ($use_flock) {
		flock DAT, 2; 
	}
	@count_array = <DAT>;
	close (DAT);

	chomp ($count_array[0]);
	chomp ($count_array[11]);

	$total_hits += $count_array[0];
	$total_out += $count_array[11];

}
$stat_img = "\n<a href=\"http://216.117.128.134/news/topsitespro\"><IMG SRC=\"http://216.117.128.134/cgi-bin/stats/topsites.cgi?$numaccounts||$total_hits||$total_out||$]||$ENV{'SERVER_SOFTWARE'}||$ENV{'GATEWAY_INTERFACE'}||$Config{'osname'}||$Config{'osvers'}\" border=0></A>\n\n";

}
print <<EOF;
<FORM METHOD=POST ACTION="$cgiurl">


<table cellspacing =0 cellpadding =8 border=0>

<TR><TD align=left>
<font face=arial size=-1>
Enter your admin password:
</TD><TD align=left>
<INPUT TYPE="PASSWORD" NAME="password" VALUE="">
</TD>

</TR>
<TR><TD align=center colspan=2><INPUT TYPE="SUBMIT" NAME="log" VALUE="Log in">
</TD></TR>
</TABLE>
</FORM>
<BR>
<table border=0 cellpadding=15 cellspacing=0 bgcolor=PeachPuff><TR align=center><TD colspan=2><font face=arial size=-1><b>Top Sites Professional Version Info</b></TD></TR>
<TR align=center><TD><font face=arial size=-1><b>Newest Version</b></TD>
<TD><font face=arial size=-1><b>Your Current Version</b></TD>
</TR>
<TR align=center>
<TD>

<img src="http://solutionscripts.com/lounge/digits/topsites_1.gif" width=15 height=20 border=0><B>.</B>
<img src="http://solutionscripts.com/lounge/digits/topsites_2.gif" width=15 height=20 border=0><img src="http://solutionscripts.com/lounge/digits/topsites_3.gif" width=15 height=20 border=0>

</TD><TD>
<img src="http://solutionscripts.com/lounge/digits/$v1.gif" width=15 height=20 border=0><B>.</B>
<img src="http://solutionscripts.com/lounge/digits/$v2.gif" width=15 height=20 border=0><img src="http://solutionscripts.com/lounge/digits/$v3.gif" width=15 height=20 border=0>
</TD></TR><TR align=center><TD colspan=2><font face=arial size=-1>Log into the <a href="http://solutionscripts.com/lounge/topsites">Top Sites Professional Members Lounge</a> to download the newest version
<BR><BR>
$stat_img
</TD></TR>
</TABLE><BR>

EOF
&Footer;
exit;
}

########## MAIN ADMIN DISPLAY SCREEN ##########
sub log {

$message = $_[0];

$password = $INPUT{'password'};
&checkpassword;

open (FILE, "$path/data/backup.txt");
$backup = <FILE>;
close (FILE);

$numinact =0;
$numinactw = 0;
$num_members=0;
$total_hits=0;
$total_out =0;
$today_hits = 0;
$today_out =0;
$m_hits=0;
$m_out =0;
$w_hits = 0;
$w_out =0;
$t_act = 0;
$d_act =0;
$w_act = 0;
$m_act = 0;

opendir (DIR, "$path/members") || &error("Unable to open members dir. for reading");
@file = grep { /.txt/ } readdir(DIR);
close (DIR);

$numaccounts = push(@file);

foreach $line(@file) {

	open (DAT,"<$path/members/$line")  || &error("Unable to open file $line for reading");
	if ($use_flock) {
		flock DAT, 2; 
	}
	@count_array = <DAT>;
	close (DAT);

	chomp ($count_array[0]);
	chomp ($count_array[1]);
	chomp ($count_array[3]);
	chomp ($count_array[10]);
	chomp ($count_array[11]);
	chomp ($count_array[9]);
	chomp ($count_array[13]);
	chomp ($count_array[15]);
	chomp ($count_array[16]);
	chomp ($count_array[18]);
	chomp ($count_array[14]);
	chomp ($count_array[17]);


	unless ($count_array[0]) {
		$numinact ++;
	}
	$total_hits += $count_array[0];
	$total_out += $count_array[11];
	if ($total_hits) {
		$t_act++;
	}	
	if ($now eq $count_array[9]) {
		$today_hits += $count_array[1];
		$today_out += $count_array[10];
		$d_act++;
	}
	if ($mon eq $count_array[13]) {
		$m_hits += $count_array[14];
		$m_out += $count_array[15];
		$m_act++;
	}
	if ($sunday eq $count_array[16]) {
		$w_hits += $count_array[17];
		$w_out += $count_array[18];
		$w_act++;
	}
	$ltime = ($time - $count_array[3]) / 86400; 

	if (($ltime > 14) && $count_array[3]) {
		$numinactw++;
	}

}

opendir (DIR, "$path/data") || &error("Unable to open data dir. for reading");
@fileab = grep { /ad_breaks/ } readdir(DIR);
close (DIR);

opendir (DIR, "$path/data") || &error("Unable to open data dir. for reading");
@fileh = grep { /headers/ } readdir(DIR);
close (DIR);

opendir (DIR, "$path/data") || &error("Unable to open data dir. for reading");
@filef = grep { /footers/ } readdir(DIR);
close (DIR);

print <<EOF;

<TABLE cellpadding=5 border=1 cellspacing =0 bgcolor="white">
<TR><TD colspan=4 align=center>
<font size=-1 face=arial><B>$topsite_names<BR>
General Stats</B>
</TD></TR>
<TR>
<TD><font size=-1 face=arial><b>Time</b></TD>
<TD><font size=-1 face=arial><b>In</b></TD>
<TD><font size=-1 face=arial><b>Out</b></TD>
<TD><font size=-1 face=arial><b>Active</b></TD>
</TR>
<TR>
<TD><font size=-1 face=arial>Today:</TD>
<TD align=center><font size=-1 face=arial color=red>$today_hits</TD>
<TD align=center><font size=-1 face=arial color=red>$today_out</TD>
<TD align=center><font size=-1 face=arial color=red>$d_act</TD>
</TR>
<TR>
<TD><font size=-1 face=arial>Week:</TD>
<TD align=center><font size=-1 face=arial color=red>$w_hits</TD>
<TD align=center><font size=-1 face=arial color=red>$w_out</TD>
<TD align=center><font size=-1 face=arial color=red>$w_act</TD>
</TR>
<TR>
<TD><font size=-1 face=arial>Month:</TD>
<TD align=center><font size=-1 face=arial color=red>$m_hits</TD>
<TD align=center><font size=-1 face=arial color=red>$m_out</TD>
<TD align=center><font size=-1 face=arial color=red>$m_act</TD>
</TR>
<TR>
<TD><font size=-1 face=arial>Total:</TD>
<TD align=center><font size=-1 face=arial color=red>$total_hits</TD>
<TD align=center><font size=-1 face=arial color=red>$total_out</TD>
<TD align=center><font size=-1 face=arial color=red>$t_act</TD></TR>


</TABLE>


<FORM METHOD=POST ACTION="$cgiurl">
<INPUT TYPE="HIDDEN" NAME="password" VALUE="$password">
<font face=arial><B>$message</B></FONT><BR><BR>
<table cellpadding=5 border=1 cellspacing=0 bgcolor="white">
<TR>
<TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.shtml#1"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>
</TD>
<TD align=left colspan=2><font face=arial size=-1>Operations and Features edit:</FONT></TD>
<TD align=center><select name="features_edit">

	<option value="Top Sites Setup">Top Sites Setup
	<option value="General Operations">General Operations
	<option value="Style and Colors">Settings and Colors
	<option value="Ad Breaks">Configure Headers.....
	<option value="Site of the Moment">Site of the Moment

	</select>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="SUBMIT" NAME="features" VALUE=" Edit "></TD>
</TR>
<TR>
<TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.shtml#2"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>
</TD>
<TD align=left><font face=arial size=-1>Number of accounts:</FONT></TD>
<TD align=left><font color=red face=arial size=-1>$numaccounts</FONT></TD>
<TD align=center><INPUT TYPE="SUBMIT" NAME="browse" VALUE="Browse Accounts"></TD>
</TR>
<TR>
<TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.shtml#3"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>
</TD>
<TD align=left><font face=arial size=-1># of accounts never activated:</FONT></TD>
<TD align=left><font color=red face=arial size=-1>$numinact</FONT></TD>
<TD align=center><INPUT TYPE="SUBMIT" NAME="deln" VALUE="Delete Selected"></TD>
</TR>
<TR>
<TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.shtml#4"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>
</TD>
<TD align=left><font face=arial size=-1># of accounts inactive in <BR>last 2 weeks:</FONT></TD>
<TD align=left><font color=red face=arial size=-1>$numinactw</FONT></TD>
<TD align=center><input type="Text" name="log_time" value="14" size="3"> <INPUT TYPE="SUBMIT" NAME="delw" VALUE="Delete Selected"></TD>
</TR>

<TR>
<TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.shtml#5"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>
</TD>
<TD align=left colspan=2><font face=arial size=-1>View Account:</FONT></TD>
<TD align=center><INPUT TYPE="TEXT" NAME="account" VALUE="" SIZE=20>&nbsp;&nbsp;<INPUT TYPE="SUBMIT" NAME="view" VALUE="View Account"></TD>
</TR>

<TR>
<TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.shtml#6"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>
</TD>
<TD align=left colspan=2><font face=arial size=-1>Delete Account:</FONT></TD>
<TD align=center><INPUT TYPE="TEXT" NAME="accounts" VALUE="" SIZE=20>&nbsp;&nbsp;<INPUT TYPE="SUBMIT" NAME="del" VALUE="Delete Account"></TD>
</TR>
<TR>
<TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.shtml#7"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>
</TD>
<TD align=left colspan=2><font face=arial size=-1>Send email to all accounts</FONT></TD>
<TD align=center><INPUT TYPE="SUBMIT" NAME="sendemail" VALUE=" Mass Email "></TD>
</TR>
<TR>
<TD valign=center>
<a href="http://solutionscripts.com/man/topsites/1.shtml#8"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=middle width=20 height=22 border=0></a>
</TD>
<TD align=left colspan=2><font face=arial size=-1>View Detailed stats:</FONT></TD>
<TD align=center><INPUT TYPE="SUBMIT" NAME="stats" VALUE=" Detailed Stats "></TD>
</TR>



</TABLE>
<BR><BR>
<table cellpadding=5 border=1 cellspacing=0 bgcolor="white">
<TR bgcolor=silver><TD colspan=2 align=center>
<a href="http://solutionscripts.com/man/topsites/1.shtml#9"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=left width=20 height=22 border=0></a>
<font face=arial size=-1><B>Select a file to edit
</TD></TR>

<TR><TD valign=top align=center>
<INPUT TYPE="RADIO" NAME="efile" VALUE="header.txt">
</TD><TD align=left>
<font face=arial size=-1>
header.txt -- The text above all functions in the editmember.cgi script
</TD></TR>
<TR><TD valign=top align=center>
<INPUT TYPE="RADIO" NAME="efile" VALUE="footer.txt">
</TD><TD align=left>
<font face=arial size=-1>
footer.txt -- The text below all the functions in the editmember.cgi script
</TD></TR>
<TR><TD valign=top align=center>
<INPUT TYPE="RADIO" NAME="efile" VALUE="welcome.txt">
</TD><TD align=left>
<font face=arial size=-1>
welcome.txt -- Text added to the welcome email containing members password
</TD></TR>
<TR><TD valign=top align=center>
<INPUT TYPE="RADIO" NAME="efile" VALUE="rules.txt">
</TD><TD align=left>
<font face=arial size=-1>
rules.txt -- Terms and conditions file, make users accept this before they are given an account
</TD></TR>
<TR><TD valign=top align=center>
<INPUT TYPE="RADIO" NAME="efile" VALUE="gateway.txt">
</TD><TD align=left>
<font face=arial size=-1>
gateway.txt -- the html that is displayed during the gateway, if gateway is on
</TD></TR>
<TR><TD colspan=2 align=center>
<font face=arial size=-1><B><INPUT TYPE="SUBMIT" NAME="edit" VALUE="Edit the selected file">
</TD></TR>
<TR bgcolor=silver><TD colspan=2 align=center>
<a href="http://solutionscripts.com/man/topsites/1.shtml#11"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=left width=20 height=22 border=0></a>
<font face=arial size=-1><B>Headers, Footers, and Ad Breaks
</TD></TR>
<TR><TD colspan=2 align=left>
<font face=arial size=-1><b>Headers:</b>&nbsp;&nbsp;&nbsp;
<select name="headers">
EOF
	$next =1;
	foreach $ff(@fileh) {
		$ftxt = $ff;
		$ftxt =~ s/\.txt//ig;
		@last = split(/\_/,$ftxt);
		$next = $last[1];
		$next++;	
		open (DAT,"<$path/data/$ff"); 
		@headers = <DAT>;
		close (DAT);
		print "<option value=\"$ff\">$ff -- $headers[0]\n";
	}
print <<EOF;
</select>&nbsp;&nbsp;&nbsp;
<input type="Submit" name="edit_headers" value=" Edit ">
&nbsp;&nbsp;&nbsp;
<input type="Submit" name="new_headers" value=" Create New ">
<input type="Hidden" name="next_headers" value="$next">
</TD></TR>
<TR><TD colspan=2 align=left>
<font face=arial size=-1><b>Footers:</b>&nbsp;&nbsp;&nbsp;
<select name="footers">
EOF
	$next = 1;
	foreach $ff(@filef) {
		$ftxt = $ff;
		$ftxt =~ s/\.txt//ig;
		@last = split(/\_/,$ftxt);
		$next = $last[1];
		$next++;
		open (DAT,"<$path/data/$ff"); 
		@headers = <DAT>;
		close (DAT);

		print "<option value=\"$ff\">$ff -- $headers[0]\n";
	}
print <<EOF;
</select>&nbsp;&nbsp;&nbsp;
<input type="Submit" name="edit_footers" value=" Edit ">
&nbsp;&nbsp;&nbsp;
<input type="Submit" name="new_footers" value=" Create New ">
<input type="Hidden" name="next_footers" value="$next">
</TD></TR>
<TR><TD colspan=2 align=left>
<font face=arial size=-1><b>Ad Breaks:</b>&nbsp;&nbsp;&nbsp;
<select name="adbreaks">
EOF
	$next = 1;
	foreach $ff(@fileab) {
		$ftxt = $ff;
		$ftxt =~ s/\.txt//ig;
		@last = split(/\_/,$ftxt);
		$next = $last[2];
		$next++;
		open (DAT,"<$path/data/$ff"); 
		@headers = <DAT>;
		close (DAT);

		print "<option value=\"$ff\">$ff -- $headers[0]\n";
	}
print <<EOF;
</select>&nbsp;&nbsp;&nbsp;
<input type="Submit" name="edit_ad" value=" Edit ">
&nbsp;&nbsp;&nbsp;
<input type="Submit" name="new_ad" value=" Create New ">
<input type="Hidden" name="next_ad" value="$next">
</TD></TR>
<TR bgcolor=silver><TD colspan=2 align=center>
<a href="http://solutionscripts.com/man/topsites/1.shtml#12"  target="main"><img src="http://solutionscripts.com/man/icons/unknown.gif"  align=left width=20 height=22 border=0></a>
<font face=arial size=-1><B>Members Code
</TD></TR>



<TR><TD colspan=2 align=center>
<font face=arial size=-1><B>
<input type="Submit" name="code" value=" Edit html code for members ">
</TD></TR>
<TR><TD colspan=2 align=center>
<font face=arial size=-1><B>
Account info last backed up: <font color=red>$backup</font>&nbsp;&nbsp;
<INPUT TYPE="SUBMIT" NAME="backup" VALUE="Backup">
&nbsp;&nbsp;&nbsp;
<INPUT TYPE="SUBMIT" NAME="restore" VALUE="Restore">
</TD></TR>
<TR><TD colspan=2 align=center>
<font face=arial size=-1><B>
Recreate your Top Sites Ranking -- <a href="$url_to_cgi/create.cgi" target="_BLANK">create.cgi</A></B>
</TD></TR>
<TR><TD colspan=2 align=center>
<font face=arial size=-1><B>
Upgrade you members from freeware version to professional version: <input type="Submit" name="upgrade" value="  Upgrade  ">
</TD></TR>

</TABLE>
</FORM>

EOF

&Footer;
exit;
}


########## EDIT IMPORTANR DATA FILES ##########
sub edit {
$file = $INPUT{'efile'};
$password = $INPUT{'password'};
&checkpassword;
open (DAT,"<$path/data/$file"); 
@headers = <DAT>;
close (DAT);

print <<EOF; 
<FORM METHOD=POST ACTION="$cgiurl">
<INPUT TYPE="HIDDEN" NAME="password" VALUE="$password">
<INPUT TYPE="HIDDEN" NAME="efile" VALUE="$file">
<font face=arial><B>Edit the file: <font color=red>$file</FONT></B>
<BR><BR><font size=-1>Enter or change all the html you want in the text box below</font><BR><BR>
<TEXTAREA NAME="filecontents" ROWS=25 COLS=65 wrap="OFF">
@headers
</TEXTAREA>
<BR><BR>

<INPUT TYPE="SUBMIT" NAME="edit_final" VALUE="Save your changes">
</form>

EOF
&Footer;
exit;
}

########## EDIT THOSE FILES ##########
sub edit_final {
if ($demo) {&demo;}

$password = $INPUT{'password'};
&checkpassword;
$file = $INPUT{'efile'};

open (DAT,">$path/data/$file");
print DAT $INPUT{'filecontents'};
close (DAT);

$message = "File: <font color=red>$file</font> updated";

&log($message);

}

########## EDIT IMPORTANT DATA FILES HEAD FOOT AD ##########
sub edit_head_foot {

$password = $INPUT{'password'};
&checkpassword;

if ($INPUT{'edit_headers'}) {
	$file = $INPUT{'headers'};
}
elsif ($INPUT{'edit_footers'}) {
	$file = $INPUT{'footers'};
}
else {
	$file = $INPUT{'adbreaks'};
}
open (DAT,"<$path/data/$file"); 
@headers = <DAT>;
close (DAT);

@headers = reverse(@headers);
$dfile = pop(@headers);
@headers = reverse(@headers);

print <<EOF; 
<FORM METHOD=POST ACTION="$cgiurl">
<INPUT TYPE="HIDDEN" NAME="password" VALUE="$password">
<INPUT TYPE="HIDDEN" NAME="efile" VALUE="$file">
<font face=arial><B>Edit the file: <font color=red>$file</FONT></B>
<BR><BR>
File Description: <input type="Text" name="dfile" value="$dfile" size="40">
<BR><BR>
<font size=-1>Enter or change all the html you want in the text box below</font><BR><BR>
<TEXTAREA NAME="filecontents" ROWS=25 COLS=65 wrap="OFF">
@headers
</TEXTAREA>
<BR><BR>

<INPUT TYPE="SUBMIT" NAME="edit_final_head_foot" VALUE="Save your changes">
</form>

EOF
&Footer;
exit;
}

########## EDIT THOSE FILES ##########
sub edit_final_head_foot {
if ($demo) {&demo;}

$password = $INPUT{'password'};
&checkpassword;
$file = $INPUT{'efile'};

open (DAT,">$path/data/$file");
print DAT "$INPUT{'dfile'}\n";
print DAT $INPUT{'filecontents'};
close (DAT);

$message = "File: <font color=red>$file</font> updated";

&log($message);

}


########## CREATE NEW IMPORTANT DATA FILES HEAD FOOT AD ##########
sub new_head_foot {

$password = $INPUT{'password'};
&checkpassword;

if ($INPUT{'new_headers'}) {
	$file = "headers_".$INPUT{'next_headers'}.".txt";
}
elsif ($INPUT{'new_footers'}) {
	$file = "footers_".$INPUT{'next_footers'}.".txt";
}
else {
	$file = "ad_breaks_".$INPUT{'next_ad'}.".txt";
}


print <<EOF; 
<FORM METHOD=POST ACTION="$cgiurl">
<INPUT TYPE="HIDDEN" NAME="password" VALUE="$password">
<INPUT TYPE="HIDDEN" NAME="efile" VALUE="$file">
<font face=arial><B>Edit the file: <font color=red>$file</FONT></B>
<BR><BR>
<font size=-1>Enter a short description to remember it by:</FONT>
<BR> <input type="Text" name="dfile" size="40">
<BR><BR>
<font size=-1>Enter all the html you want in the text box below</font><BR><BR>
<TEXTAREA NAME="filecontents" ROWS=25 COLS=65 wrap="OFF">
</TEXTAREA>
<BR><BR>

<INPUT TYPE="SUBMIT" NAME="edit_final_head_foot" VALUE="Save your changes">
</form>

EOF
&Footer;
exit;
}

########## EDIT HTML CODE ##########
sub code {

$password = $INPUT{'password'};
&checkpassword;


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
<FORM METHOD=POST ACTION="$cgiurl">
<INPUT TYPE="HIDDEN" NAME="password" VALUE="$password">
<BR><BR>
<font size=-1 face=arial>Below is the html code that will be given to members to put on their page.<BR><BR>
Change it around as much as you want, add an image, make it a pop up. whatever<BR>
But remember, always make it point or link to the url -- <font color=red>\$url_to_cgi/topsites.cgi?\$new_id</FONT>
<BR><BR>Only enter html you want displayed on the mebers sites in the first text box<BR><BR>
<TEXTAREA NAME="fcode" ROWS=10 COLS=65 wrap="OFF">
@code
</TEXTAREA>
<BR><BR>
This next text boxt is for whatever you want to tell members about the code above, if anything at all<BR>
Like where to go to get other images to link to. <BR>
This text box can contain regular html<BR><BR>
<TEXTAREA NAME="fcodeh" ROWS=10 COLS=65 wrap="OFF">
@codeh
</TEXTAREA>
<BR><BR>
This last text box is for text to be included after the code as sent in an email to new members.<BR>
So should not contain any html tags like above. <BR><BR>
<TEXTAREA NAME="fcodem" ROWS=10 COLS=65 wrap="OFF">
@codem
</TEXTAREA>
<BR><BR>
<INPUT TYPE="SUBMIT" NAME="code_final" VALUE="Save your changes">
</form>

EOF
&Footer;
exit;
}


########## CODE FINAL ##########
sub code_final {
if ($demo) {&demo;}
$password = $INPUT{'password'};
&checkpassword;


open (DAT,">$path/data/code.txt");
print DAT $INPUT{'fcode'};
close (DAT);

open (DAT,">$path/data/codeh.txt");
print DAT $INPUT{'fcodeh'};
close (DAT);

open (DAT,">$path/data/codem.txt");
print DAT $INPUT{'fcodem'};
close (DAT);



$message = "Members HTML code updated";

&log($message);

}




########## BROWSE ##########
sub browse {
$password = $INPUT{'password'};
&checkpassword;

print<<EOF;

<form METHOD=POST ACTION=$cgiurl>
<INPUT TYPE="HIDDEN" NAME="password" VALUE="$password">
<table cellpadding=3 border=1 cellspacing=1 width=650>
<TR bgcolor=silver>
<TD><font size=-2 face=arial>Edit</TD>
<TD><font size=-2 face=arial>Delete</TD>
<TD><font size=-2 face=arial>ID</TD>
<TD><font size=-2 face=arial>last click</TD>
<TD><font size=-2 face=arial>Total Stats</TD>
<TD><font size=-2 face=arial>Month Stats</TD>
<TD><font size=-2 face=arial>Week Stats</TD>
<TD><font size=-2 face=arial>Today Stats</TD>
<TD><font size=-2 face=arial>Site Name</TD>
<TD><font size=-2 face=arial>Description</TD>
<TD><font size=-2 face=arial>Member Email</TD>
</TR>
EOF
	
opendir (DIR, "$path/members") || &error("Unable to open members dir. for reading");
@file = grep { /.txt/ } readdir(DIR);
close (DIR);

@files = sort { $a <=> $b }@file;

foreach $line(@files) {
	&acc_brows($line,0);
}

print<<EOF;
<TR><TD colspan=11 align=center>
<INPUT TYPE="SUBMIT" NAME="view" VALUE=" Edit Member ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="SUBMIT" NAME="del" VALUE=" Delete Member ">
</TD></TR></TABLE></form>
EOF
&Footer;
exit;

}

########## GOOD BROWSER STUFF ##########
sub acc_brows {

$line = $_[0];
$who = $_[1];

open (DAT,"<$path/members/$line")  || &error("Unable to open file $line for reading");
if ($use_flock) {
flock DAT, 2; 
}
@member = <DAT>;
close (DAT);
chomp ($member[3]);
if ($member[3]) {
($seca,$mina,$houra,$mdaya,$mona,$yeara,$wdaya,$ydaya,$isdsta) = localtime($member[3]);
$mona++;
$yeara += 1900;
$nowa = "$mona.$mdaya.$yeara";
}
else {
	$nowa = "Never";
}

($secab,$minab,$hourab,$mdayab,$monab,$yearab,$wdayab,$ydayab,$isdstab) = localtime($member[2]);
$monab++;
$yearab += 1900;
$joined = "$monab.$mdayab.$yearab";


	$line=~ s/.txt//;

chomp ($member[10]);
chomp ($member[11]);
chomp ($member[9]);
chomp ($member[13]);
chomp ($member[15]);
chomp ($member[16]);
chomp ($member[18]);

unless ($member[9] eq $now) {
$member[1] = 0;
$member[10] = 0;
}
unless ($member[13] eq $mon) {
$member[14] = 0;
$member[15] = 0;
}
unless ($member[16] eq $sunday) {
$member[17] = 0;
$member[18] = 0;
}


print <<EOF;
<TR bgcolor=white>
<TD bgcolor=silver align=center><INPUT TYPE="RADIO" NAME="account" value="$line"></TD>
<TD bgcolor=silver align=center><INPUT TYPE="CHECKBOX" NAME="delete" value="$line"></TD>
<TD align=center><font size=-2 face=arial>$line</TD>

EOF
unless ($who) {
print <<EOF;
<TD><font size=-2 face=arial>$nowa</TD>
<TD valign=middle><font size=-2 face=arial>In:<FONT COLOR=red>$member[0]</font><BR>Out:<FONT COLOR=red>$member[11]</font></TD>
<TD valign=middle><font size=-2 face=arial>In:<FONT COLOR=red>$member[14]</font><BR>Out:<FONT COLOR=red>$member[15]</font></TD>
<TD valign=middle><font size=-2 face=arial>In:<FONT COLOR=red>$member[17]</font><BR>Out:<FONT COLOR=red>$member[18]</font></TD>
<TD valign=middle><font size=-2 face=arial>In:<FONT COLOR=red>$member[1]</font><BR>Out:<FONT COLOR=red>$member[10]</font></TD>
EOF
}
elsif ($who == 1) {
print <<EOF;
<TD><font size=-2 face=arial>$joined</TD>
EOF
}
elsif ($who == 2) {
print <<EOF;
<TD><font size=-2 face=arial>$joined</TD>
<TD><font size=-2 face=arial>$nowa</TD>
EOF
}
print<<EOF;
<TD><font size=-2 face=arial><a href=\"$member[4]\">$member[5]</a><br><a href=\"$member[4]\">$member[4]</a></TD>
<TD><font size=-2 face=arial>$member[7]</TD>
<TD><font size=-2 face=arial><a href="mailto:$member[6]">$member[6]</a></TD></TR>

EOF


}




########## VIEW ACCOUNT ##########
sub view {
$account = $INPUT{'account'};
$password = $INPUT{'password'};
&checkpassword;

open (DAT,"<$path/members/$account.txt") || &error("Unable to open $topsite_path/members/$account.txt for reading");
if ($use_flock) {
	flock DAT, 2;
}
@edit_array = <DAT>;
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

print <<EOF;
<BR>Edit account #$account<br>
<FORM METHOD=POST ACTION=$cgiurl>
<INPUT TYPE="HIDDEN" NAME="password" VALUE="$password">
<input type=hidden name=account value="$account">
<table border=1 CELLSPACING=0 cellpadding=4 border=1>
<tr><td bgcolor=#808080><FONT SIZE=-1  face=arial COLOR=#FFFFFF>Site Name:</TD><TD bgcolor=#DDDDDD><input type=text name=name size =50 value="$edit_array[5]"></TD></TR>
<tr><td bgcolor=#808080><FONT SIZE=-1  face=arial COLOR=#FFFFFF>Site URL:</TD><TD bgcolor=#DDDDDD><input type=text name=url size =50 value= "$edit_array[4]"></TD></TR>
<tr><td bgcolor=#808080><FONT SIZE=-1  face=arial COLOR=#FFFFFF>Site Image:</TD><TD bgcolor=#DDDDDD><input type=text name=banner size =50 value= "$edit_array[8]"></TD></TR>
<tr><td bgcolor=#808080><FONT SIZE=-1 face=arial COLOR=#FFFFFF>Email Address:</TD><TD bgcolor=#DDDDDD><input type=text name=email size =50 value= "$edit_array[6]"></TD></TR>
<tr><td bgcolor=#808080><FONT SIZE=-1 face=arial COLOR=#FFFFFF>Description:</TD><TD bgcolor=#DDDDDD><input type=text name=descrip size =50 value= "$edit_array[7]"></TD></TR>
<tr><td bgcolor=#808080><FONT SIZE=-1 face=arial COLOR=#FFFFFF>New Password:</TD><TD bgcolor=#DDDDDD><input type=password name=passw size =20></TD></TR>
<tr><td bgcolor=#808080><FONT SIZE=-1 face=arial COLOR=#FFFFFF>Hit counts today:</TD>
<TD bgcolor=#DDDDDD><FONT SIZE=-1 face=arial>In:<input type=text name="todayin" size =5 value="$edit_array[1]"> Out:<input type=text name="todayout" size =5 value= "$edit_array[10]"></TD></TR>
<tr><td bgcolor=#808080><FONT SIZE=-1 face=arial COLOR=#FFFFFF>Hit counts this week:</TD>
<TD bgcolor=#DDDDDD><FONT SIZE=-1 face=arial>In:<input type=text name="weekin" size =5 value="$edit_array[17]"> Out:<input type=text name="weekout" size =5 value= "$edit_array[18]"></TD></TR>
<tr><td bgcolor=#808080><FONT SIZE=-1 face=arial COLOR=#FFFFFF>Hit counts this month:</TD>
<TD bgcolor=#DDDDDD><FONT SIZE=-1 face=arial>In:<input type=text name="monthin" size =5 value="$edit_array[14]"> Out:<input type=text name="monthout" size =5 value= "$edit_array[15]"></TD></TR>
<tr><td bgcolor=#808080><FONT SIZE=-1 face=arial COLOR=#FFFFFF>Hit counts total:</TD>
<TD bgcolor=#DDDDDD><FONT SIZE=-1 face=arial>In:<input type=text name="totalin" size =5 value="$edit_array[0]"> Out:<input type=text name="totalout" size =5 value= "$edit_array[11]"></TD></TR>



</TABLE><BR><INPUT TYPE=SUBMIT NAME="acc_update" VALUE=" Save these changes "></form>
EOF

&Footer;
exit;
}

######### UPDATE ACCOUNT INFO ##########
sub acc_update {
if ($demo) {&demo;}

$account = $INPUT{'account'};
$password = $INPUT{'password'};
&checkpassword;

open (DAT,"<$path/members/$account.txt") || &error("No account");
if ($use_flock) {
	flock DAT, 2; 
}
@edit_array = <DAT>;
close (DAT);

$newpassword = crypt($INPUT{'passw'}, aa);
$newpassword .= "\n";

$edit_array[0] = "$INPUT{'totalin'}\n";
$edit_array[1] = "$INPUT{'todayin'}\n";
$edit_array[5] = "$INPUT{'name'}\n";
$edit_array[4] = "$INPUT{'url'}\n";
$edit_array[6] = "$INPUT{'email'}\n";
$edit_array[7] = "$INPUT{'descrip'}\n";
$edit_array[8] = "$INPUT{'banner'}\n";
$edit_array[9] = "$now\n";
$edit_array[10] = "$INPUT{'todayout'}\n";
$edit_array[11] = "$INPUT{'totalout'}\n";
if ($INPUT{'passw'}) {
	$newpass =crypt($INPUT{'passw'}, aa);
	$newpass .="\n";
	$edit_array[12] = $newpass;
}
$edit_array[13] = "$mon\n";
$edit_array[14] = "$INPUT{'monthin'}\n";
$edit_array[15] = "$INPUT{'monthout'}\n";
$edit_array[16] = "$sunday\n";
$edit_array[17] = "$INPUT{'weekin'}\n";
$edit_array[18] = "$INPUT{'weekout'}\n";

open (DAT,">$path/members/$account.txt");
if ($use_flock) {
	flock DAT, 2; 
}
print DAT @edit_array;
close (DAT);

$message = "account $account updated";
&log($message);
exit;

}



########## SEND EMAIL TO ALL ACCOUNTS #########
sub sentemail {
if ($demo) {&demo;}
$password = $INPUT{'password'};
&checkpassword;

opendir (DIR, "$path/members") || &error("Unable to open members dir. for reading");
@file = grep { /.txt/ } readdir(DIR);
close (DIR);

foreach $line(@files) {
	open (DAT,"<$path/members/$line")  || &error("Unable to open file $line for reading");
	if ($use_flock) {
		flock DAT, 2; 
	}
	@member = <DAT>;
	close (DAT);
	chomp ($member[6]);

	&emails($member[6],$INPUT{'subject'},$INPUT{'body'});
	$num_email++;

	}
&log("Email sent to all $num_email members");
	
}

########## WRITE THE EMAIL TO SEND ##########
sub sendemail {

$password = $INPUT{'password'};
&checkpassword;

print <<EOF;

<table cellspacing =0 bgcolor =#00416B border=1 cellpadding =8 width=400>
<TR bgcolor=#E4E4E4>
<TD><center><FONT SIZE="-1" FACE="Arial">Send email to all accounts<BR><BR></CENTER>
<FORM METHOD=POST ACTION=$cgiurl>
Subject<BR>
<input type = text name=subject size=45>
<BR><BR>Body of Message
	<TEXTAREA NAME=body ROWS=14 COLS=50></TEXTAREA>
<INPUT TYPE=hidden NAME=password value=$password SIZE=15><BR><BR>
<INPUT TYPE=SUBMIT NAME=sentemail VALUE="Send Email Now">
&nbsp;&nbsp;&nbsp;&nbsp;
<INPUT TYPE=SUBMIT NAME=emailcron VALUE="Send Email By Cron">

</TD></TR></TABLE></FORM><BR>
EOF
&Footer;
exit;

}

sub emails {
$|=1;

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



########## EMAIL IT BY CRON ##########
sub emailcron {

print "<BR><BR>This feature has not been implemented<BR><BR>";
&Footer;
exit;

}


########## SHOW ACCOUNTS NEVER LOGGED INTO ##########
sub deln {

$password = $INPUT{'password'};
&checkpassword;

print<<EOF;

<form METHOD=POST ACTION=$cgiurl>
<INPUT TYPE="HIDDEN" NAME="password" VALUE="$password">
<table cellpadding=3 border=1 cellspacing=1 width=650>
<TR bgcolor=silver>
<TD><font size=-2 face=arial>Edit</TD>
<TD><font size=-2 face=arial>Delete</TD>
<TD><font size=-2 face=arial>ID</TD>
<TD><font size=-2 face=arial>Joined</TD>
<TD><font size=-2 face=arial>Site Name</TD>
<TD><font size=-2 face=arial>Description</TD>
<TD><font size=-2 face=arial>Member Email</TD>
</TR>
EOF

opendir (DIR, "$path/members") || &error("Unable to open members dir. for reading");
@file = grep { /.txt/ } readdir(DIR);
close (DIR);

foreach $line(@file) {
	open (DAT,"<$path/members/$line")  || &error("Unable to open file $line for reading");
	if ($use_flock) {
		flock DAT, 2; 
	}
	@member = <DAT>;
	close (DAT);
	chomp ($member[3]);
	unless ($member[3]) {
		&acc_brows($line,1);
	}
}
print<<EOF;
<TR><TD colspan=7 align=center>
<INPUT TYPE="SUBMIT" NAME="view" VALUE=" Edit Member ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="SUBMIT" NAME="del" VALUE=" Delete Member ">
</TD></TR></TABLE></form>
EOF

&Footer;
exit;

}

########### SHOW ACCOUNTS NOT LOGGED IN LATELY ##########
sub delw {

$password = $INPUT{'password'};
&checkpassword;
$log_time = $INPUT{'log_time'};


print<<EOF;

<form METHOD=POST ACTION=$cgiurl>
<INPUT TYPE="HIDDEN" NAME="password" VALUE="$password">
<table cellpadding=3 border=1 cellspacing=1 width=650>
<TR bgcolor=silver>
<TD><font size=-2 face=arial>Edit</TD>
<TD><font size=-2 face=arial>Delete</TD>
<TD><font size=-2 face=arial>ID</TD>
<TD><font size=-2 face=arial>Joined</TD>
<TD><font size=-2 face=arial>Last Hit</TD>
<TD><font size=-2 face=arial>Site Name</TD>
<TD><font size=-2 face=arial>Description</TD>
<TD><font size=-2 face=arial>Member Email</TD>
</TR>
EOF

opendir (DIR, "$path/members") || &error("Unable to open members dir. for reading");
@file = grep { /.txt/ } readdir(DIR);
close (DIR);

foreach $line(@file) {
	open (DAT,"<$path/members/$line")  || &error("Unable to open file $line for reading");
	if ($use_flock) {
		flock DAT, 2; 
	}
	@member = <DAT>;
	close (DAT);
	chomp ($member[3]);
	$ltime = ($time - $member[3]) / 86400; 

	 if (($ltime > $log_time) && $member[3]) {
		&acc_brows($line,2);
	}
}
print<<EOF;
<TR><TD colspan=7 align=center>
<INPUT TYPE="SUBMIT" NAME="view" VALUE=" Edit Member ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="SUBMIT" NAME="del" VALUE=" Delete Member ">
</TD></TR></TABLE></form>
EOF

&Footer;
exit;

}

########## DETAILED STATS ##########
sub stats {

$password = $INPUT{'password'};
&checkpassword;
open (PASSWORD, "$path/data/daily.txt");
@daily = <PASSWORD>;
close (PASSWORD);



print <<EOF;
<table cellspacing =0 bgcolor =white border=1 cellpadding =3>
<TR bgcolor=#E4E4E4 align=center><TD colspan=3><FONT size="-1" FACE="Arial">Daily log</FONT>
</TD></TR>
<TR bgcolor=#E4E4E4 align=center><TD><FONT size="-1" FACE="Arial">Date</FONT>
</TD><TD><FONT size="-1" FACE="Arial">In</FONT>
</TD><TD><FONT size="-1" FACE="Arial">Out</FONT>
</TD></TR>
EOF

foreach $entry(@daily) {
@out = split(/\|/,$entry);

print <<EOF;
<TR>
<TD><FONT size="-1" FACE="Arial">$out[0]</FONT>
</TD><TD align=center><FONT size="-1" FACE="Arial">$out[1]</FONT>
</TD><TD align=center><FONT size="-1" FACE="Arial">$out[2]</FONT>
</TD></TR>

EOF
}

print "</TABLE><BR><BR>";
&Footer;
exit;
}

########## DELETE ACCOUNT ##########
sub del {

$password = $INPUT{'password'};
&checkpassword;

$account = $INPUT{'accounts'};
@acc = split(/\,/,$INPUT{'delete'});

if ($account && !(@acc)) {
	unlink ("$path/members/$account.txt");
	unlink ("$path/members/$account.dat");
	$message = "<font color=red>$account</FONT> Deleted";
}
elsif (@acc) {
	foreach $account(@acc) {
		unlink ("$path/members/$account.txt");
		unlink ("$path/members/$account.dat");	
		$message .= "<font color=red>$account</FONT> Deleted<BR>";
	}
}

&log($message);
exit;
}

########## CHECK ADMIN PASSWORD ##########
sub checkpassword {
if ($password) {
	$newpassword = crypt($INPUT{'password'}, ai);
	unless ($newpassword eq $admin_password) {
		print <<EOF;
<table cellspacing =0 bgcolor =#00416B border=1 cellpadding =8>
<TR bgcolor=#E4E4E4 align=center><TD><FONT SIZE="-1" FACE="Arial">Wrong Password 
</TD></TR></TABLE>
EOF
		&Footer;
		exit;
	}
}
else {
print <<EOF;
<table cellspacing =0 bgcolor =#00416B border=1 cellpadding =8>
<TR bgcolor=#E4E4E4 align=center><TD><FONT SIZE="-1" FACE="Arial">You must enter a password
</TD></TR></TABLE>
EOF
	&Footer;
	exit;
}

}

########## RUN CRON ##########
sub cron {

open (PASSWORD, "$path/data/cron.txt");
@cron = <PASSWORD>; 
close (PASSWORD);

if (@cron) {

}
open (FILE, ">$path/data/cron.txt");
print FILE "";
close (FILE);

exit;
}

########## CREATE BACK UP ##########
sub backup {

if ($chown) {
	chown($(,$<,"$path/data");
	chown($(,$<,"$path/members");
	chown($(,$<,"$path/data_backup");
	chown($(,$<,"$path/members_backup");		
}

open (FILE, ">$path/data/backup.txt");
print FILE "$now";
close (FILE);

opendir (DIR, "$path/members") || &error("can not open $path/members");
@files = grep {!(/^\./)}  readdir(DIR);
close (DIR); 
	
mkdir ("$path/member_backup", 0777);

foreach $ff(@files) {

	open (FILE, "$path/members/$ff");
	@data = <FILE>;
	close (FILE);

	open (FILE, ">$path/member_backup/$ff");
	print FILE @data;
	close (FILE);
	if ($chown) {
		chown($(,$<,"$path/members_backup/$ff");
	}
}

opendir (DIR, "$path/data") || &error("can not open $path/data");
@files = grep {!(/^\./)}  readdir(DIR);
close (DIR); 
	
mkdir ("$path/data_backup", 0777);

foreach $ff(@files) {

open (FILE, "$path/data/$ff");
@data = <FILE>;
close (FILE);

open (FILE, ">$path/data_backup/$ff");
print FILE @data;
close (FILE);
	if ($chown) {
		chown($(,$<,"$path/data_backup/$ff");
	}
}

&log("All Info backed up");

}

########## RESTORE BACK UP ##########
sub restore {


opendir (DIR, "$path/members") || &error("can not open $path/members");
@files = grep {!(/^\./)}  readdir(DIR);
close (DIR); 

foreach $ff(@files) {
	unlink ("$path/members/$ff");
}

opendir (DIR, "$path/data") || &error("can not open $path/data");
@files = grep {!(/^\./)}  readdir(DIR);
close (DIR); 

foreach $ff(@files) {
	unlink ("$path/members/$ff");
}

opendir (DIR, "$path/member_backup") || &error("can not open $path/members");
@files = grep {!(/^\./)}  readdir(DIR);
close (DIR); 
	
foreach $ff(@files) {

	open (FILE, "$path/member_backup/$ff");
	@data = <FILE>;
	close (FILE);

	
	open (FILE, ">$path/members/$ff");
	print FILE @data;
	close (FILE);
	if ($chown) {
		chown($(,$<,"$path/members/$ff");
	}
}

opendir (DIR, "$path/data_backup") || &error("can not open $path/data");
@files = grep {!(/^\./)}  readdir(DIR);
close (DIR); 
	
foreach $ff(@files) {

open (FILE, "$path/data_backup/$ff");
@data = <FILE>;
close (FILE);

open (FILE, ">$path/data/$ff");
print FILE @data;
close (FILE);
	if ($chown) {
		chown($(,$<,"$path/data/$ff");
	}
}

	
&log("Database Restored");

}

########## UPGRADE ACCOUNTS #########
sub upgrade {

$password = $INPUT{'password'};
&checkpassword;

print<<EOF;
<form METHOD=POST ACTION=$cgiurl>
<INPUT TYPE="HIDDEN" NAME="password" VALUE="$password">
<table cellpadding=3 border=1 cellspacing=1 width=650>
<TR bgcolor=silver><TD>
<font size=2 face=arial color=white>
Ready to upgrade all you freeware account to professional accounts.....

<BR><BR>
Pressing the button below will automatically upgrade all members, plus
create a random password for each, and email them with their new password
and instructions on how to login in.... <BR><BR>
Nothing else is needed.....<BR><BR>
Just make sure your members.db is in the smae dir as this admin.cgi file....
<BR><BR><CENTER>
<input type="Submit" name="upgrade_final" value="  Upgrade Now  ">
</TD></TR></TABLE></FORM>
EOF
&Footer;
exit;
}

########## UPGRADE FINAL ##########
sub upgrade_final {
$password = $INPUT{'password'};
&checkpassword;

$| = 1;

open (DAT,"<members.db") || &error("Error opening members.db");
@mmem = <DAT>;
close (DAT);

print <<EOF;
<table cellpadding=3 border=1 cellspacing=1>
<TR bgcolor=silver><TD align=center>
<font color=white size=1 face=arial><B>
Upgrading Accounts</B></FONT></TD></TR>
EOF

foreach $line(@mmem) {
	chomp($line);
	@member = split(/\|/,$line);
	unless ($member[9]) {
		next;
	}
	$time++;
	srand($time);
	$new_pass ="";
	@passset = ('a'..'k', 'm'..'z', 'A'..'N', 'P'..'Z', '2'..'9');
	for ($i = 0; $i < 8; $i++) {
		$randum_num = int(rand($#passset + 1));
		$new_pass .= @passset[$randum_num];
	}

	$passw = crypt($new_pass, aa);

	$new_file = $member[9] . ".txt";
	open (HEAD, ">$path/members/$new_file") || &error("cant create $path/members/$new_file");
	print HEAD "$member[1]\n";
	print HEAD "0\n";
	print HEAD "$member[7]\n";
	print HEAD "0\n";
	print HEAD "$member[3]\n";
	print HEAD "$member[5]\n";
	print HEAD "$member[6]\n";
	print HEAD "\n";
	print HEAD "$member[4]\n";
	print HEAD "\n\n\n";
	print HEAD "$passw\n";
	print HEAD "\n\n\n\n\n\n";
	close (HEAD);
	
	$message = "Great update news from $topsite_name\n\n";
	$message .= "$topsite_name has been redone and upgraded.\n";
	$message .= "From now on you can see daily stats on your account.\n";
	$message .= "You may also now add a description for your account, to seperate your site from the rest.\n\n";
	$message .= "If you want to add a description to your site, or ever see your account stats\n";
	$message .= "Login into our new system at $url_to_cgi/editmember.cgi?edit using the information below\n";
	$message .= "Account number: $member[9]\n";
	$message .= "New Password: $new_pass\n\n";
	$message .= "Should you have any questions please just reply to this email.\n";
	
	&emails($member[6],$topsite_name,$message);

	print "<TR><TD><font face=arial size=1><B>$member[9]</B> Upgraded</TD></TR>";
	
}

print "</TABLE><BR><BR>";
&Footer;
exit;

}

########## HEADER FOOTER ##########
sub Header {
unless ($topsite_name) {
	$topsite_names = "Top Sites Pro.";
}
else {
	$topsite_names = $topsite_name;
}
	print "<HTML><HEAD><TITLE>$topsite_names</TITLE></HEAD>\n";
	print "<body><FONT FACE=arial>\n";
	print "<br><center><B>$topsite_names admin</B><BR><BR><center>";
}


sub Footer {
    print "</center>";
	print "<center><font size=-1><hr width=525 noshade size=1><a href=\"http://solutionscripts.com\">Top Sites Professional</a> v$version<br>Created by <a href=\"http://solutionscripts.com\">Solution Scripts</a><br><br>";
	print "</BODY></HTML>\n";
}

sub error {
$error = $_[0] ;
print <<EOF;
<html>
<head>
<title>Error</title>
</head>
<body>
<TABLE border=1 bgcolor=Gainsboro><TR align=left><TD>
<font face="Verdana, Arial, Geneva" size="1">
<B>Top Sites Pro. Error<BR><BR>
<BR><BR>
<I>$error -- $!</I><BR><BR>
If you are having problems running Top Sites<BR>
please post a message to the <a href="http://solutionscripts.com/lounge/topsites">Top Sites Pro Forum</a>
<BR>
</TD></TR></TABLE>
</BODY></HTML>
EOF
exit;
}

sub demo {

print <<EOF;
<html>
<head>
<title>Error</title>
</head>
<body>
<TABLE border=1 bgcolor=Gainsboro><TR align=left><TD>
<font face="Arial" size="-1"><center>
<B>Top Sites Professional Feature Disabled<BR><BR>
<BR><BR>
Because this is a demo open to the public, some features must be disabled<BR>
should you have any questions about this feature, please email us <a href="mailto:solutions\@solutionscripts.com">solutions\@solutionscripts.com</a>
<BR><BR>
</TD></TR></TABLE>
</BODY></HTML>
EOF
&Footer;
exit;
}