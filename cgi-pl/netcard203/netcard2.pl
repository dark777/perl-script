#!/usr/local/bin/perl

####################################
# NETCARD 2.03
# 
# Aytekin Tank
# email: aytekin@bridgeport.edu
# http://www.interlogy.com/scripts/netcard
# 
####################################
# COPYRIGHT NOTICE:
#
# Copyright 1998-99 Aytekin Tank.
#
# This program may be used and modified free of charge by anyone, so
# long as this copyright notice and the header above remain intact.
# Selling the code for this program without prior written consent is
# expressly forbidden.  Obtain permission before redistributing this
# program over the Internet or in any other medium.  In all cases
# copyright and header must remain intact.
#
# This program is distributed "as is" and without warranty of any
# kind, either express or implied. All responsibility is belong to 
# you if any damage or loss occurs.
####################################
# please send me an email to aytekin@bridgeport.edu
# about any bugs, problems or critics. Thank you.
####################################
print "Content-type: text/html\n\n";

#eval("main");
#if ($@) {
#   print "Content-type: text/plain\n\n",
#   "The script failed because the error\n$@\noccurred.";
#  }
 
#sub main
#{
#the netcard start
if (!$started){

	#the extension for the pages htm or html:
	$ext = "htm";

	# Read data coming from the form:
	&readparse;

	# Form Variables. Dont forget to change this 
	# part, if you modify the FORM: 
	&variables;
	
	# Loginame must be in proper form:
	&loginnameCheck;
	
	#Configuration File:
	# if NT: put the full path
	# like: require "netcard/cgi-bin/netcard2.cfg";
	require "netcard2.cfg";

}	# end of the netcard start


####################################
# Creation of cards.
####################################

# File name to be created:
$login = "$root/"."$loginname".".$ext";

# Link list to be modified:
$list = "$root/"."list.htm";

# UPLOAD process variables:
if ($logo eq upload){
	$upload = 1;
	$logo = $logoURL;
	}

# Other image url variables:
if (!$upload){
	if ($logo eq "url"){
		$logo = $logoURL;
		}
	else{
		$logo = "$URL/".$logo;
	}
}

# Uploaded image name:
if ($started){
	$logo = "$URL/images/".$Filename;
	$logoURL = $logo;
}

# Create the code for the card:
&createHTML;

# Preview:
&preview;

####################################
# Preview 
####################################
sub preview {
	if ($preview == 1)
	{
	# Show the card
	print "$cardHTML \n<center>\n";
	# Create hidden form for real submission
	# be sure to change this is you change the form
	if ($started){
		print " The uploaded image should be seen above<br>\n";
		print " If you can't see it, go back and upload again!<br>\n";
	}

	if ($upload){
	print "\n Image size should not be more than $MAX_UPLOAD KBs:<br>\n"; 
	print "<form ENCTYPE=multipart/form-data action=up.cgi method=post>";
	print "<INPUT TYPE=FILE NAME=upload_01 SIZE=35>";
	}
	else {
	print "<form action=$URLprogram method=post>";
	}

	for ($i=0; $i<11 ;$i++) {
	if ($value[$i] eq ''){
		$value[$i] = '_';}
	print "<input type=hidden name=\"field_0$i\" value=\"$value[$i]\">\n";
	}
	if ($started){
		print "<input type=hidden name=\"field_0$i\" value=\"$logoURL\">\n";
	}
	else{
		print "<input type=hidden name=\"field_0$i\" value=\"$value[$i]\">\n";
	}		

	print "<input type=hidden name=12 value=0>";
	print "\n<p><input type=submit name=submit value=Submit></p></form>";

	open (HTML, "< $login") or exit; 
	print "\n <p>sorry, this login name has already been registered. \n";
	print "\n <!-- $login --> \n <!-- $loginname --> \n";
	close(HTML);
	exit;
	}

# if you can read the file, fail, 
# else if there is no file, create the card:
open (HTML, "< $login") or &writeHTML; 
print "$failHTML";
close(HTML);

} # end of sub preview 

####################################
# SUBROUTINES
####################################


####################################
# Create the file and write on it:
####################################
sub writeHTML {
	#print "writing to $login";
	open (HTML,">$login"); 
	print HTML "$cardHTML";
	print "$successHTML";
	close (HTML);
	&addtoLIST;
	if ($confirmation == 1){
		&sendemail($email,$from,$sub,$letter); 
	}
	exit;
} # end of sub writeHTML

####################################
# addition to the listing file
####################################
sub addtoLIST {

	open (LISTFILE,"<$list") || &noLIST;
	@LINES=<LISTFILE>;
	close(LISTFILE);
	$SIZE=@LINES;

	open (LISTFILE,">$list") || die "Can't Open $output: $!\n";
	$fileSIZE = $SIZE;

	for ($i=0;$i<=$fileSIZE;$i++) {
		$_="$LINES[$i]"."\n";
	   print LISTFILE $LINES[$i];
   
	   if (/<!--LIST-->/) { 
	   	@lineNO = split (/--/, $LINES[++$i]);

	   	if ($lineNO[1] >= $MAX_LIST) 
	   	{
	   		print list;
		   	@listnameS = split (/\./, 'list.htm');
		   	$lineNO[2]++;
		   	$newlist = $listnameS[0].$lineNO[2].".$listnameS[1]";
			$newONEflag =1;
	   	}

	   	$lineNO[1]++; 
		print LISTFILE "$lineNO[0]--$lineNO[1]--$lineNO[2]--$lineNO[3]";
		print LISTFILE "\n$listHTML\n";
		}
	}
	close(LISTFILE);
	if ($newONEflag){
		rename ($list, "$root/".$newlist);
		&createNEWLIST;
	}
} # end of sub addtoLIST

####################################
# if there is no list.htm file
####################################
sub noLIST {
	$lineNO[2]=0;
	&createNEWLIST;
	&addtoLIST;
	exit;
} # end of sub noLIST

####################################
# If the list is full or there is 
# no list, create a new list file:
####################################
sub createNEWLIST {
	open (NEWLIST,">$list") or die "cannot create the $list file\n";
	print NEWLIST $listHEADER; 
	print NEWLIST "\n<!--LIST-->\n";
	print NEWLIST "<!--0--";
	if ($lineNO[2] eq ''){
		$lineNO[2]=0;
	}
	print NEWLIST $lineNO[2];
	print NEWLIST "-->\n";
	print NEWLIST "<!--LISTEND-->\n";
	if($newONEflag){
		print NEWLIST "\n<br><a href=$newlist>next</a><br>\n";
	}
	print NEWLIST $listFOOTER; 
	close (NEWLIST);
} # end of sub createNEWLIST

####################################
# Read data from the form:
####################################
sub readparse {
	read(STDIN,$user_string,$ENV{'CONTENT_LENGTH'});
	if (length($ENV{'QUERY_STRING'})>0) {$user_string=$ENV{'QUERY_STRING'}};
	$user_string =~ s/\+/ /g;
	@name_value_pairs = split(/&/,$user_string);
	foreach $name_value_pair (@name_value_pairs) {
	        ($keyword,$value) = split(/=/,$name_value_pair);
	        $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C",hex($1))/ge;
	        push(@value, "$value");
		  $user_data{$keyword} = $value;
	}
} # end of sub readparse

####################################
# Variables. Dont forget to change 
# this part if you change the form: 
####################################
sub variables {

	if (started){
	foreach $value (@value){
		if ($value eq '_'){
			$value = '';}
		}
	}
	
	$loginname = $value[0]; 
	$name = $value[1]; 
	$position = $value[2]; 
	$company = $value[3]; 
	$address = $value[4]; 
	$address2 = $value[5];
	$tel = $value[6]; 
	$fax = $value[7]; 
	$email = $value[8]; 
	$http = $value[9]; 
	$logo = $value[10]; 
	$logoURL = $value[11]; 
	$preview = $value[12];
} # end of sub variables
	
####################################
# login name check
####################################
sub loginnameCheck {
	if ($loginname eq ''){
		print "<p> error: login name is a required field.\n";
		print "You can not leave it blank. \n";
		print "<p> Please go back and try again.\n";
		exit;
	}
	
	@arrayLogin = split('',$loginname);
	foreach $arrayLogin (@arrayLogin){
		if(($arrayLogin eq ' ')||($arrayLogin eq '.')){
			$arrayLogin = '_';}
		}
	foreach $arrayLogin(@arrayLogin){
	$newloginname = $newloginname.$arrayLogin;}
	$value[0] = $loginname = $newloginname;

} # end of sub loginnameCheck

####################################
# send an email
####################################
sub sendemail {
	
	local($to,$from,$sub,$letter) = @_;
	@arrayEmail = split('',$to);
	foreach $arrayEmail (@arrayEmail){
		if(($arrayEmail eq '@') || ($arrayEmail eq '.')){
			$emailValid++;
			}
		}
	if($emailValid >= 2){
		$to=~s/@/\@/;
		$from=~s/@/\@/;
		open(MAIL, "|$sendmail -t") || die
		"Content-type: text/text\n\nCan't open $sendmail!";
		print MAIL "To: $to\n";
		print MAIL "From: $from\n";
		print MAIL "Subject: $sub\n";
		print MAIL "$letter\n";
		return close(MAIL);
	}
} # end of sub sendemail
# end of the program.
#}