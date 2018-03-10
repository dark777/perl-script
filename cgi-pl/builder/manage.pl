#!/usr/local/bin/perl
#########
#Please set the path above to your perl path.
#The format is as follows: #!/path/to/perl
#The most common paths to perl are /usr/local/bin/perl or /usr/local/perl
#So you would either use #!/usr/local/bin/perl or #!/usr/local/perl
#If you are not sure of the perl path please contact your system administrator.
#If you get an error message, this is the first place to check.
#########
$giveawaysite = "My Site";
$giveawayurl = "http://members.elitehosts.com";
$giveawayhome = "Elite Hosts, Inc.";
$femail = "welcome\@elitehosts.com";
# Copyright(c) 1999 Avi Brender.
###### DO NOT EDIT BELOW THIS LINE!!
print "content-type:text/html\n\n";
#############################
$referer = "http:\/\/$ENV{'SERVER_NAME'}$ENV{'SCRIPT_NAME'}";
$title = "Elite Web Page Builder";
unless ($ENV{'CONTENT_TYPE'} =~ m#^multipart/form-data#) {
&parse_form;
}
if ($ENV{'CONTENT_TYPE'} =~ m#^multipart/form-data#) {
require "prefs";
require "cgi-lib.pl";
$mailprog = "/usr/lib/sendmail";
&upload;
}
if (-e "prefs"){chmod(0777,"prefs");}
if (-e "$passfile"){chmod(0777,"$passfile");}

$action=$input{'action'};
unless ($action eq "Finish" || $action eq "saveid" || $action eq "confirm") {
if (!-e "prefs") {
&setup;
}else {
open(prf,"prefs") ;
$prf = <prf>;
if ($prf eq "1\;" || $prf eq ""){
&setup;
}} 
require "prefs"; 
}
require "cgi-lib.pl";
unless($action eq "" || $action eq "Add User" || $action eq "Delete User") {
if ($ENV{'HTTP_REFERER'} =~ "$referer") {
}else {

unless ($referer eq "http://members.elitehosts.com/index.html" || $referer eq "http://members.elitehosts.com"){
&top;
print "You can't call this script from: $ENV{'HTTP_REFERER'}<BR>It must be called from: $referer";
&bottom;
exit 0;
}}}
$username = $input{'userid'};
$usern = "$username";
@days   = ('Sunday','Monday','Tuesday','Wednesday',
'Thursday','Friday','Saturday');
@months = ('January','February','March','April','May','June','July',
'August','September','October','November','December');
($sec,$min,$hour,$mday,$mon,$year,$wday) = (localtime(time))[0,1,2,3,4,5,6];
$time = sprintf("%02d:%02d:%02d",$hour,$min,$sec);
$year += 1900;
$tdate = "$days[$wday], $months[$mon] $mday, $year";
$action = $input{'action'};
$url = "http://" . $ENV{SERVER_NAME} . $ENV{'SCRIPT_NAME'};
$cgi_script = $url;
$userlogon = $input{'userid'};
$u = $input{'userid'};
if ($u eq "") {
$u = $input{'userlogon'};
}
open(PS, "$passfile");
@fl = <PS>;
foreach $ent (@fl) {
($suserid, $pass, $stat, $disk, $first, $last, ,$email, $sex, $expire, $vlogon, $ext, $maxfiles, $maxdirs, $log, $header, $footer, $homedir, $homeurl, $changepass) = split(/\:\:/,$ent);
if ($suserid eq "$u") {
$usrdir = $homedir;
$userurl = $homeurl;
$vext = $ext;
}}close (PS);
if ($action eq "saveid"){&saveid;}
if ($action eq ""){&logonform;}
if ($action eq "Logon"){&logon_user;}
if ($action eq "Log Out"){&logout;}
if ($action eq "Delete File"){&deleteform;}
if ($action eq "Delete Now"){&delete;}
if ($action eq "Rename The File"){&rename;}
if ($action eq "Get File"){&getfile;}
if ($action eq "Get The File"){&uploadnow;}
if ($action eq "Copy File"){&copyform;}
if ($action eq "Copy The File"){&copyfile;}
if ($action eq "copyfile"){&copyfile;}
if ($action eq "Change Your Password"){&changepform;}
if ($action eq "changepass"){&changepass;}
if ($action eq "Add User"){&adduser;}
if ($action eq "adduser"){&addnow;}
if ($action eq "Edit HTML File"){&editfileform;}
if ($action eq "Create New HTML File"){&newfileform;}
if ($action eq "editfile"){&editfile;}
if ($action eq "Save File"){&savefile;}
if ($action eq "Change Password"){&changepasswordform;}
if ($action eq "Change Users Password"){&changeupassword;}
if ($action eq "Fix List Of Files"){&fixform;}
if ($action eq "Delete User"){&deleteuser;}
if ($action eq "Finish"){&stp2;}
if ($action eq "Move The File"){&movefile;}
if ($action eq "delnow"){&deluser;}
if ($action eq "copy") {&copyform;}
if ($action eq "save"){&save;}
if ($action eq "move"){&moveform;}
if ($action eq "back"){&good_logon;}
if ($action eq "chdir") {&good_logon;}
if ($action eq "rename") {&renameform;}
if ($action eq "delete") {&deleteform;}
if ($action eq "edit") {&editfile;}
if ($action eq "Create New Directory"){&createdir;}
if ($action eq "Make Directory"){&makedir;}
if ($action eq "View Suspended Users") {&vsu;}
if ($action eq "Previous Directory"){&prevdir;}
if ($action eq "Setup Script"){&setup;}
if ($action eq "confirm"){&conf;}
if ($action eq "am"){&am;}
if ($action eq "lostpass"){&lp;}

# If no action was selected

print "<H1><B>Error 197</B><HR></H1>This command is unknown. Please go back and try again.";
exit 0;
sub lp {

&top;
if  ($input{'sub'} ne "send") {
print "<BR><BR><font color=\"navy\">If you forgot your password (if not, why are you here?), type in the email address and a new password
will be emailed to you.<input type=\"hidden\" name=action value=lostpass>
<input type=hidden name=sub value=send><BR>
Email:<input type=\text\ name=\"email\"><BR>
Username:<input type=\text\ name=\"userid\">
<BR><input type=submit value=\"Send My New Password\">
";}
else {
srand;
$total = "10";
$rpass1 = int(rand($total));
$rpass2 = int(rand($total));
$rpass3 = int(rand($total));
$rpass4 = int(rand($total));
$rpass5 = int(rand($total));
$rpass6 = int(rand($total));
$rpass7 = int(rand($total));
$rpass = "$rpass1$rpass2$rpass3$rpass4$rpass5$rpass6$rpass7";
open(PSF, "$passfile");
@en = <PSF>;
foreach $entr (@en) {
($userid, $pass, $sus, $disk, $firs, $las, $email) = split(/\:\:/,$entr);
if ($userid eq $input{'userid'} && $email eq $input{'email'}) {
$okk = "52";
open(MAIL,"|$mailprog -t");
print MAIL "To: $email\n";
print MAIL "From: lostpassword\@fixit.com\n";
print MAIL "Subject: Your New Password\n";
print MAIL "Dear $firs, $las\n";
print MAIL "You have requested to have your password changed because you forgot it.\n";
print MAIL "Here is your new user information:\n";
print MAIL "Userid: $input{'userid'}\n";
print MAIL "Password: $rpass\n";
print MAIL "If you did not request to have your password changed, please logon with the new password and change it.\n";
 close (MAIL);

open(DATA,"$passfile")|| &ERROR("CANT OPEN1");
@lines = <DATA>;
close(DATA);
open(DATA,">$passfile") || &ERROR("CANT OPEN2");
foreach $line (@lines)
{
($loginname, $password, $a, $b, $c, $d, $e, $f, $g, $h, $i, $j, $k, $l, 
$m, $n, $o, $p, $q) = split(/\:\:/,$line);
if ($input{'userid'} eq $loginname &&  $input{'email'} eq "$e") 
{
$confirm = crypt($rpass,time);
print DATA ("$userid\:\:$confirm\:\:$a\:\:$b\:\:$c\:\:$d\:\:$e\:\:$f\:\:$g\:\:$h\:\:$i\:\:$j\:\:$k\:\:$l\:\:$m\:\:$n\:\:$o\:\:$p\:\:$q");
}else{print DATA $line;}}
}}
unless ($okk eq "52") {
print "Sorry, your record was not found in our database. Make sure that the email address you entered corrisponds with the userid you entered.";
&bottom;
exit 0;
}
print "Your new password was emailed."; }
&bottom;
exit 0;
}
sub ext {
$var = @_[0];
if ($var =~ "\/" || $var =~ /^\.\./){

&top;
print "<BR>The filename that you have chosen ($var) is not valid.";
&bottom;
exit 0;}
@ex = split(/\,/,$vext);
foreach $exte (@ex){
if ($var =~ /$exte$/){
$ge = "1";
}}unless ($ge eq "1") {

&top;
print "<BR>Sorry, but your file must have a valid file extention.";
&bottom;
exit 0;
}}

sub setup {

print <<SSMM;
<html>
<head>
<meta http-equiv="Content-Type"
content="text/html; charset=iso-8859-1">
<meta name="GENERATOR" content="Microsoft FrontPage Express 2.0">
<title>Scripts In The Making</title>
<style>
.bl:hover{color:red;text-decoration:underline}
a{text-decoration:none}

</style>
</head>

<body bgcolor="#FFFFFF">
<div align="center"><center>
<form method="post" action="$url">

<table border="1" cellpadding="0" cellspacing="0" width="50%"
bordercolor="#000000" bordercolordark="#000000"
bordercolorlight="#000000">
    <tr>
        <td align="center" colspan="1" bgcolor="#000091"><font
        color="#FFFFFF" face="verdana">Elite Web Page
        Builder - Main Page</font></td>
    </tr>
    <tr>
           <td bgcolor="#CFCFCF" valign="top"><BR><font face="verdana" size="-1">
<BR><font face="aria" size="-1" color="darkblue">Please Note:
This script may not be sold.<BR>
This script may not be re-distributed<BR>
This script may not be edited<BR>
You may not remove the link from the bottom of the page<BR>
<B>Without permission from the <a href="mailto:abmusic99\@aol.com">author.</a><BR><BR></b>

</font><font face="verdana" size="-1" color="blue">Step 1: Setup Your Main Account.<BR>
Please enter a username and password for your main account. Through this main account,
and only this account, will you be able to setup users preferences and script
settings.<BR><font color="green">
UserID:<input type="text" Name="userid" style="background-color:orange;font-face:verdana;
font-size:xx-small;color:black" size="30"><BR>
Password:<input type="password" Name="password" style="background-color:orange;font-face:verdana;
font-size:xx-small;color:black" size="30"><BR>
<CENTER>
<input type="hidden" name="action" value="saveid">
<input type="submit" name="submit" STYLE="background-color:#eeeeee;font:verdana;font-weight:bold;
color:#000080;font-size:xx-small;width:134;" value="Save!"></td>

    </tr>
</table>
</div></center></body></form></html>
SSMM
exit 0;
}
sub am {

print <<AMM;
<html>
<head>
<meta http-equiv="Content-Type"
content="text/html; charset=iso-8859-1">
<meta name="GENERATOR" content="Microsoft FrontPage Express 2.0">
<title>Scripts In The Making</title>
<style>
.bl:hover{color:red;text-decoration:underline}
a{text-decoration:none}
</style>
</head>
<body bgcolor="#FFFFFF">
<div align="center"><center>
<form method="post" action="$url">
<input type="hidden" name="action" value="am">
<table border="1" cellpadding="0" cellspacing="0" width="85%"
bordercolor="#000000" bordercolordark="#000000"
bordercolorlight="#000000">
<tr>
<td align="center" colspan="2" bgcolor="#000091"><font
color="#FFFFFF" face="verdana">Elite Web Page
Builder - Main Page</font></td>
</tr>
<tr>
<td width="24%" bgcolor="#CFCFCF" align="center" valign="top"><BR
        <br><BR>
        <INPUT TYPE="SUBMIT" name="sub" STYLE="background-color:#eeeeee;
font:verdana;font-weight:bold;color:#000080;font-size:xx-small;width:134;" value="User Settings"><BR><BR>
       <input type="submit" name="sub" STYLE="background-color:#eeeeee;
font:verdana;font-weight:bold;color:#000080;font-size:xx-small;width:134;" value="Change Password"><BR><BR>


</td>
        <td bgcolor="#CFCFCF" valign="top"><BR><font face="verdana" size="-1">
AMM
$sub = $input{'sub'};
$al = 0;
$s = "Save Settings For";
unless ($sub eq "Save Password File Path" || $sub eq "Save URL To Home Directories"
||$sub eq "Save Path To Home Directories" || $sub eq "Save Default Disk Space"
|| $sub eq "Save Default Settings" || $sub eq "User Settings" || $sub =~ /^Edit/
|| $sub =~ /^$s/ || $sub eq "Save New User Settings"){

open(prf, "prefs");
while (<prf>) {
@pf = split(/\n/);
foreach $ln (@pf) {
if ($ln =~ /^\$passfile/) {
$pass = 1;
}}}
close (prf);
unless ($pass eq "1") {
$al = "1";
print <<AMM;
Congradulations, you have successfully began setting up Elite Web Page Builder.<BR>
Now you have to setup some easy options. First, lets setup the path to your password file.<BR>
<BR>
<font color="red">Please enter the full path to your password file. (i.e. /usr/local/etc/httpd/htdocs/elite/passfile)
<BR>For security reasons, we recommend that you keep this file in a directory that is not web-accessible.
 If not, that is ok too.<BR><font color="blue">If this file does not exist, the script will
create it. (We will create the file NOT the directory.) The directory in which the password
file resides MUST exist!<BR>
<input type="text" Name="passfile" style="background-color:orange;font-face:verdana;
font-size:xx-small;color:black" size="50" value="/usr/local/etc/httpd/htdocs/avi/passfile"><BR>
<input type="submit" name="sub" value="Save Password File Path" style="background-color:white
;font-weight:bold;color:#000080;font-face:verdana;font-size:xx-small;">
AMM
&bo;
}if ($al ne "1"){
open(prf, "prefs");
while (<prf>) {
@pf = split(/\n/);
foreach $ln (@pf) {
if ($ln =~ /^\$nusrdir/) {
$udir = 1;
}}}close (prf);
unless ($udir eq "1") {
$al = "1";
print <<AMM;
Please enter the full path to the directory where the users files will be held.
<BR>For example if you enter /home/users in the box below, and a user signs up with the username
avib, his home directory will be /home/users/avib
<BR><BR><B>No trailing slash (/), and
MUST be web-accessible.<BR>If this directory does not exist, we will create it for you.<BR>
</b>
<input type="text" Name="userdir" style="background-color:orange;font-face:verdana;
font-size:xx-small;color:black" size="50" value="/home/users"><BR>
<input type="submit" name="sub" value="Save Path To Home Directories" style="background-color:white
;font-weight:bold;color:#000080;font-face:verdana;font-size:xx-small;">
AMM
&bo;
}}if ($al ne "1"){
open(prf, "prefs");
while (<prf>) {
@pf = split(/\n/);
foreach $ln (@pf) {
if ($ln =~ /^\$nuserurl/) {
$uurl = 1;
}}}
close (prf);
unless ($uurl eq "1") {
$al = "1";
print <<AMM;
Please enter the URL corrisponding to the full path of the directory where the users
files will be held (the path you previously entered.)
<BR>For example if you previously entered /home/users, and a user signs up with the username
avib, his home directory will be /home/users/avib and his url will be: http://yoursite.com/users/avib
(assuming the http://yoursite.com pointed to /home";
<BR><BR><B>No trailing slash (/), and
MUST be web-accessible.<BR>
</b>
<input type="text" Name="userurl" style="background-color:orange;font-face:verdana;
font-size:xx-small;color:black" size="50" value="http://yourisite.com/users"><BR>
<input type="submit" name="sub" value="Save URL To Home Directories" style="background-color:white
;font-weight:bold;color:#000080;font-face:verdana;font-size:xx-small;">

AMM
&bo;
}}if ($al ne "1"){
open(prf, "prefs");
while (<prf>) {
@pf = split(/\n/);
foreach $ln (@pf) {
if ($ln =~ /^\$diskspace/) {
$disks = 1;
}}}close (prf);
unless ($disks eq "1") {
$al = "1";
print <<AMM;
Please enter the default amout of disk space that each new use should be alloted. 
(You can customize each user's disk space by clicking on "Users Settings" when setup
is done.)<BR>You should enter the number in bytes. Remember 1,000,000 bytes = 1mb.<BR>
For unlimited space, enter: 0<BR>
<input type="text" Name="diskspace" style="background-color:orange;font-face:verdana;
font-size:xx-small;color:black" size="50" value="11,000,000"><BR>
<input type="submit" name="sub" value="Save Default Disk Space" style="background-color:white
;font-weight:bold;color:#000080;font-face:verdana;font-size:xx-small;">
AMM
&bo;
}}

if ($al ne "1"){

open(prf, "prefs");
while (<prf>) {
@pf = split(/\n/);
foreach $ln (@pf) {

if ($ln =~ /^\$passchange/) {
$pc = 1;
}
if ($ln =~ /^\$minpass/){
$mip = "1";
}
if ($ln =~ /^\$maxpass/){
$map = "1";
}
if ($ln =~ /^\$minuser/){
$miu = "1";
}
if ($ln =~ /^\$maxuser/){
$mau = "1";
}
}}
if ($pc eq "1" && $mip eq "1" && $map eq "1" && $miu eq "1" || $mau eq "1"){
$def = "1";
}
close (prf);

if ($def ne "1") {

$al = "1";
print <<AMM;
Last Step. This one is pretty easy. (These are just defaults, and can be changed later.)<BR><BR>

Can A New User Change His/Her Password?<BR>
<input type="radio" Name="passchange" style="background-color:#CFCFCF;font-face:verdana;
font-size:xx-small;color:black" value="yes">Yes
<input type="radio" Name="changepass" style="background-color:#CFCFCF;font-face:verdana;
font-size:xx-small;color:black" value="no">No
<br>Minimum Password Length:
<input type="text" Name="minuser" style="background-color:orange;font-face:verdana;
font-size:xx-small;color:black" size="5" value="4"><BR>
Maximum Password Length:
<input type="text" Name="maxuser" style="background-color:orange;font-face:verdana;
font-size:xx-small;color:black" size="5" value="8"><BR>
<BR>
Minimum Username Length:
<input type="text" Name="minpass" style="background-color:orange;font-face:verdana;
font-size:xx-small;color:black" size="5" value="4"><BR>
Maximum Username Length:
<input type="text" Name="maxpass" style="background-color:orange;font-face:verdana;
font-size:xx-small;color:black" size="5" value="8"><BR>
<INPUT TYPE="SUBMIT" name="sub" STYLE="background-color:#eeeeee;
font:verdana;font-weight:bold;color:#000080;font-size:xx-small;width:134;" value="Save Default Settings"><BR>

AMM
&bo;
}}
}if ($al ne "1" && $sub eq ""){
print <<NOO;
<font face="verdana" style="font-size:small;color:darkblue">Dear Beta Testers,<BR>
Please read the readme file!<HR><BR><BR>Congradulations, your script is set 
up and you are now ready to go. Now, you may make, edit or delete users by click on User Settings
on the left side.<BR><BR><font color="red">We have worked really hard on this script, so please
just take 1 minute out of your time and rate it below. Thanks.<BR>
<table border="0" cellpadding="0" cellspacing="0" width="300">
    <tr>
        <td><font face="verdana"><img
        src="http://cgi-resources.com/images/rate/remote_red.gif"
        alt="Rate this Script @ The CGI Resource Index!"
        width="300" height="11"></font></td>
    </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" width="300">
    <tr>
        <td width="20">&nbsp;</td>
        <td width="260" bgcolor="#FF3232"><div align="center"><center><table
        border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td><form
                action="http://cgi-resources.com/rate/index.cgi"
                method="POST">
                    <input type="hidden" name="referer"
                    value="http://cgi-resources.com/"><input
                    type="hidden" name="link_code" value="03840"><input
                    type="hidden" name="category_name"
                    value="Programs and Scripts/Perl/Homepage Communities/"><input
                    type="hidden" name="link_name"
                    value="Elite Web Site Builder"><p><font
                    size="2" face="verdana"><b>Script Rating: </b></font><font
                    face="verdana"><select name="rating" size="1">
                        <option selected>-- </option>
                        <option>10 </option>
                        <option>9 </option>
                        <option>8 </option>
                        <option>7 </option>
                        <option>6 </option>
                        <option>5 </option>
                        <option>4 </option>
                        <option>3 </option>
                        <option>2 </option>
                        <option>1 </option>
                    </select> </font></p>
                </form>
                </td>
                <td><font face="verdana"><input type="image" name
                src="http://cgi-resources.com/images/rate/remote_red_sub.gif"
                alt="Rate It!" align="bottom" border="0"
                width="59" height="18"></font></td>
            </tr>
        </table>
        </center></div></td>
        <td width="20">&nbsp;</td>
    </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" width="300">
    <tr>
        <td colspan="3" width="300"><font face="verdana"><img
        src="http://cgi-resources.com/images/rate/remote_red_bot.gif"
        width="300" height="11"></font></td>
    </tr>
</table>


NOO
exit 0;
}

if ($sub =~ /^Change Now/){
$new = $input{'password'};
$new2 = $input{'confirm'};

if ($new ne $new2){
print "Your passwords do not match.";
&bot;
exit 0;
}if ($new eq ""){
print "Your new password cannot be blank.";
&bot;
exit 0;
}
$npass = crypt($input{'password'},time);

open(prff, "prefs");
@ffl = <prff>;
close (prff);

open(prff, ">prefs");
foreach $nl (@ffl) {
unless ($nl =~ "adminpass" ){
print prff "$nl";
}
else {
print prff "\$adminpass = \"$npass\"\;\n";
}
}

print <<FRM;

Your Password Has Been Changed

FRM

}



if ($sub =~ /^Change Password/){
print <<FRM;

New Password:  
<input type="password" name="password"
 style="background-color:orange;font-size:xx-small;"><BR>

Confirm:
<input type="password" name="confirm"
 style="background-color:orange;font-size:xx-small;"><BR>
<BR>
<input type="submit" name="sub" STYLE="background-color:#eeeeee;
font:verdana;font-weight:bold;color:#000080;font-size:xx-small;" value="Change Now">

FRM
}

if ($sub =~ /^Edit/) {
($com, $user) = split(/ /,$sub);
open(pass, "$passfile");
while(<pass>) {
@ps = split(/\n/);
foreach $uid (@ps){
unless (uid eq "" || $uid eq " " || $uid eq "\n"){
($userid, $pass, $stat, $disk, $first, $last, ,$email, $sex, $expire, $vlogon, $ext, $maxfiles, $maxdirs, $log, $header, $footer, $homedir, $homeurl, $changepass) = split(/\:\:/,$uid);
if ($userid eq "$user") {
if ($disk eq "0") {
$ndisk = "Unlimited";
}
if ($stat eq "yes") {
$nstat = "Suspended.";
}
if ($stat eq "no") {
$nstat = "Normal.";
}if ($maxfiles eq "0") {
$nmaxfiles = "Unlimited";
}if ($maxdirs eq "0"){
$nmaxdirs = "Unlimited";
}
print <<dd;
<table border="0"><TR><TD align="right">Userid:</td><TD>
 <input type="text" name="userid"
 style="background-color:orange;font-size:xx-small;" value="$userid"><BR>

</td></tr><TR><Td align="right">New Password:</td><TD> 
<input type="password" name="password"
 style="background-color:orange;font-size:xx-small;"><BR>

</td></tr><TR><Td align="right">Confirm:</td><TD> 
<input type="password" name="confirm"
 style="background-color:orange;font-size:xx-small;"><BR>

</td></tr><TR><Td align="right">Name:</td><TD>
<input type="text" name="name" 
style="background-color:orange;font-size:xx-small;" value="$sex $first $last" ><BR>

</td></tr><TR><Td align="right">Account Dissabled?</td><TD>
dd
if ($stat eq "yes") {
print <<dk;
<input type="radio" value="yes" name="sus" checked>Yes
 <input type="radio" value="no" name="sus">No
dk
}
else {
print <<dk;
<input type="radio" value="yes" name="sus">Yes
 <input type="radio" value="no" name="sus" checked>No
dk
}
print <<dd;
<BR>
</td></tr><TR><Td align="right">Home Dir: </td><TD>
<input type="text" name="homedir" 
style="background-color:orange;font-size:xx-small;width:250" value="$homedir" ><BR>

</td></tr><TR><Td align="right">Home URL: </td><TD><input type="text" name="homeurl" 
style="background-color:orange;font-size:xx-small;width:250" value="$homeurl" ><BR>

</td></tr><TR><Td align="right">Disk Space (type 0 for unlimited):</td><TD><input type="text" name="disk" 
style="background-color:orange;font-size:xx-small;" value="$disk" >bytes. (1,000,000 bytes=1mb)<BR>

</td></tr><TR><Td align="right">Change Password? </td><TD>
dd
if ($changepass eq "yes") {
print <<dk;
<input type="radio" value="yes" name="changepass" checked>Yes
 <input type="radio" value="no" name="changepass">No
dk
}
else {
print <<dk;
<input type="radio" value="yes" name="changepass">Yes
 <input type="radio" value="no" name="changepass" checked>No
dk
}
print <<dd;
<BR>
</td></tr><TR><Td align="right">Email:</td><TD> <input type="text" name="email" 
style="background-color:orange;font-size:xx-small;" value="$email" ><BR>

<input type=hidden name="expire" value="0">
<input type=hidden name="vlogon" value="0">


</td></tr><TR><Td align="right">Valid Extentions:</td><TD><input type="text" name="ext" 
style="background-color:orange;font-size:xx-small;width:250" value="$ext" ><BR>


</td></tr><TR><Td align="right">Max Files (0 = unlimited):</td><TD><input type="text" name="maxfiles" 
style="background-color:orange;font-size:xx-small;" value="$maxfiles" ><BR>

</td></tr><TR><Td align="right">Max Dirs (0 = unlimited): </td><TD><input type="text" name="maxdirs" 
style="background-color:orange;font-size:xx-small;" value="$maxdirs" ><BR>

</td></tr>
dd

print <<dd;
<input type=hidden name="log" value=no>

<input type="hidden" name="footer" value="none">
<input type="hidden" name="header" value="none">

<TR><TD colspan="2" align="center">      
  <input type="submit" name="sub" STYLE="background-color:#eeeeee;
font:verdana;font-weight:bold;color:#000080;font-size:xx-small;"value="Save Settings For $userid"><BR><BR> </table>
dd
}}}}
}
if ($sub eq "") {
print "nothing todo.";
exit 0;
}
$sp = "Save Settings For ";
if ($sub =~ /^$sp/) {
$f = " For ";
($com, $user) = split(/$f/,$sub);
print "Save Settings For $user...<BR>";
if ($input{'disk'} =~ "\,"){
$input{'disk'} =~ s/\,//g;
}
if ($input{'password'} ne "$input{'confirm'}"){
print "<BR>The new passwords don't match. Please go back and try again.";
exit 0;
}
($nsex, $nfirst, $nlast) = split (/ /,$input{'name'});

$npassword = crypt($input{'password'},time);
open (PS, "$passfile");
@pass = <PS>;
close (PS);
open (PS,">$passfile");
foreach $line (@pass) {
($useridd, $password, $sus, $disk, $first, $last, $email, $sex, $expire, $vlogon,
$ext, $maxfiles, $maxdirs, $log, $header, $footer, $path, $url, $changepass)
= split(/\:\:/,$line);
if ($input{'password'} eq "") {
$pass = $password;
}else {
$pass = $npassword;}

if ($useridd eq $user){

print PS "$input{'userid'}\:\:$pass\:\:$input{'sus'}\:\:$input{'disk'}\:\:$nfirst\:\:$nlast\:\:$input{'email'}\:\:$nsex\:\:$input{'expire'}\:\:$input{'vlogon'}\:\:$input{'ext'}\:\:$input{'maxfiles'}\:\:$input{'maxdirs'}\:\:$input{'log'}\:\:$input{'header'}\:\:$input{'footer'}\:\:$input{'homedir'}\:\:$input{'homeurl'}\:\:$input{'changepass'}\n";
}else {
print PS "$line";
}
}
if (!-d "$input{'homedir'}") {
print "<B><font color=red>Warning: $user's home directory ($input{'homedir'}) does not exist! Please create it!";
}print "<BR>Your settings were saved.";

close (PS);
exit 0;
}
if ($sub eq "User Settings") {
$nu = "0";
if ($input{'subb'} eq "Save New User Settings") {
if ($input{'nexpmonth'} eq "00" || $input{'nexpmonth'} eq "0"){
$input{'nexpmonth'} = "0";
}if ($input{'starthour'} eq "0") {
$vlog = "0";
}else {
$vlog = "$input{'starthour'}:$input{'startminute'}:$input{'startap'}-$input{'endhour'}:$input{'endminute'}:$input{'endap'}";
}
$exp = "$input{'nexpmonth'}\/$input{'nexpdate'}\/$input{'nexpyear'}";
open(prff, "prefs");
@ffl = <prff>;
close (prff);

open(prff, ">prefs");
foreach $nl (@ffl) {
unless ($nl =~ "1\;" 
|| $nl =~ /^\$nchangepass/ 
|| $nl =~ /^\$nnexpire/
 || $nl =~ /^\$nvalid/
 || $nl =~ /^\$nfext/
 || $nl =~ /^\$nmaxfiles/
 || $nl =~ /^\$nmaxdirs/
 || $nl =~ /^\$nlog/
 || $nl =~ /^\$nheader/
 || $nl =~ /^\$nfooter/
 || $nl =~ /^\$exp/
){
print prff "$nl";
}}
print prff "\$nchangepass = \"$input{'npasschange'}\"\;\n";
print prff "\$nnexpire = \"$exp\"\;\n";
print prff "\$nvalid = \"$vlog\"\;\n";
print prff "\$nfext = \"$input{'nfext'}\"\;\n";
print prff "\$nmaxfiles = \"$input{'mfiles'}\"\;\n";
print prff "\$nmaxdirs = \"$input{'mdirs'}\"\;\n";
print prff "\$nlog = \"$input{'log'}\"\;\n";
print prff "\$nheader = \"$input{'header'}\"\;\n";
print prff "\$nfooter = \"$input{'footer'}\"\;\n";
print prff "\$exp = \"$input{'exp'}\"\;\n";

print prff "1\;\n";
print "Thank you, your preferences were saved. Click <a href=\"$url?action=am&sub=User Settings\">here</a> to continue.";
&bo;
exit 0;
}
unless ($input{'subb'} eq "Save New User Settings") {

open(prf, "prefs");
while (<prf>) {
@pf = split(/\n/);
foreach $ln (@pf) {
if ($ln =~ /^\$nchangepass/){$a = 1;}
if ($ln =~ /^\$nnexpire/){$b = 1;} 
if ($ln =~ /^\$nvalid/){$c = 1;}
if ($ln =~ /^\$nfext/){$d = 1;} 
if ($ln =~ /^\$nmaxfiles/){$e = 1;} 
if ($ln =~ /^\$nmaxdirs/){$f = 1;} 
if ($ln =~ /^\$nlog/){$g = 1;} 
if ($ln =~ /^\$nheader/){$h = 1;} 
if ($ln =~ /^\$nfooter/){$i = 1;}
if ($ln =~ /^\$exp/){$j = 1;}
if ($a eq "1" && $b eq "1" && $c eq "1" && $d eq "1" && $c eq "1" && $f eq "1" && $g eq "1"
 && $h eq "1" && $i eq "1" && $j eq "1"){
$nu = "1";
}}}
close (prf);
unless ($nu eq "1") {
$al = "1";
print <<AMM;

You are about to set up your default preferances for new users. When a new users signs up,
the settings you enter below will be applied to new users. You can configure each user seperatly
after they sign up, by clicking on users settings then find their entry, and click the button
labeled "Edit"<BR><BR><font face="verdana,verdana,verdana" size="-1">
Can New Users Change Their Password? <select name="npasschange"
style="font-size:xx-small;font-face:verdana"><option>yes</option>
<option>no</option></select><BR><BR>
Date For New Accounts To Expire (mm/dd/yy)
 (Don't worry, it's y2k compliant. 00 will translate as 2000 and 01 will be 2001 and etc.)
<input type="text" name="nexpmonth" size="1" maxlength="2" style="font-size:xx-small;font-face:verdana ">
/
<input type="text" name="nexpday" size="1" maxlength="2" style="font-size:xx-small;font-face:verdana ">
/
<input type="text" name="nexpyear" size="1" maxlength="2" style="font-size:xx-small;font-face:verdana ">
- Enter 00 in the month field for no experation.
<BR><BR>
What should happen to expired accounts? <select name="exp"
style="font-size:xx-small;font-face:verdana "><option>delete</option><option>
suspend</option></select><BR><BR>
Accounts Can Log on Between (Select 0 for the start hour to dissable):
<BR>
<select name="starthour" size="1" style="font-size:xx-small;font-face:verdana "><option>
0</option>
<option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>
<option>6</option><option>7</option><option>8</option><option>9</option><option>10</option>
<option>11</option><option>12</option></select><select name="startminute" size="1"
style="font-size:xx-small;font-face:verdana ">
<option>00</option><option>01</option><option>02</option><option>03</option><option>04</option>
<option>05</option><option>06</option><option>07</option><option>08</option>
<option>09</option><option>10</option><option>11</option><option>12</option>
<option>13</option><option>14</option><option>15</option><option>16</option>
<option>17</option><option>18</option><option>19</option><option>20</option>
<option>21</option><option>22</option><option>23</option><option>24</option>
<option>25</option><option>26</option><option>27</option><option>28</option>
<option>29</option><option>30</option><option>31</option><option>32</option>
<option>33</option><option>34</option><option>35</option><option>36</option>
<option>37</option><option>38</option><option>39</option><option>40</option>
<option>41</option><option>42</option><option>43</option><option>44</option>
<option>45</option><option>46</option><option>47</option><option>48</option>
<option>49</option><option>50</option><option>51</option><option>52</option>
<option>53</option><option>54</option><option>55</option><option>56</option>
<option>57</option><option>58</option><option>59</option>
                </select><select name="startap" size="1"
style="font-size:xx-small;font-face:verdana ">
<option>am</option>
<option>pm</option>
                </select> - <select name="endhour" size="1"
style="font-size:xx-small;font-face:verdana ">
<option>1</option><option>2</option><option>3</option><option>4</option>
<option>5</option><option>6</option><option>7</option><option>8</option>
<option>9</option><option>10</option><option>11</option><option>12</option>
                </select><select name="endminute" 
style="font-size:xx-small;font-face:verdana " size="1">
<option>00</option><option>01</option><option>02</option><option>03</option>
<option>04</option><option>05</option><option>06</option><option>07</option>
<option>08</option><option>09</option><option>10</option><option>11</option>
<option>12</option><option>13</option><option>14</option><option>15</option>
<option>16</option><option>17</option><option>18</option><option>19</option>
<option>20</option><option>21</option><option>22</option><option>23</option>
<option>24</option><option>25</option><option>26</option><option>27</option>
<option>28</option><option>29</option><option>30</option><option>31</option>
<option>32</option><option>33</option><option>34</option><option>35</option>
<option>36</option><option>37</option><option>38</option><option>39</option>
<option>40</option><option>41</option><option>42</option><option>43</option>
<option>44</option><option>45</option><option>46</option><option>47</option>
<option>48</option><option>49</option><option>50</option><option>51</option>
<option>52</option><option>53</option><option>54</option><option>55</option>
<option>56</option><option>57</option><option>58</option><option>59</option>
                </select><select name="endap" size="1"
style="font-size:xx-small;font-face:verdana ">
<option>am</option>
<option>pm</option>
                </select><BR><BR>
Valid File Extentions (Type 0 to allow all extentions): 
<input type="text" name="nfext" style="font-size:x-small;font-face:verdana;width:250"
value=".html,.htm,.txt,.gif,.jpg,.mpeg,.gif,.wav,.midi"><BR><BR>
Max Number Of Files: <input type="text" name="mfiles" 
style="font-size:xx-small;font-face:verdana"
value="0" size="3">
Directories: <input type="text" name="mdirs" 
style="font-size:xx-small;font-face:verdana"
value="0" size="2">(0 for unlimited)<BR><BR>
Do you wish to log a new users actions? <select name="log"
style="font-size:xx-small;font-face:verdana">
<option>yes</option><option>no</option></select><BR><BR>
If you wish to put a header and/or footer on a users page, type the filename
of the file containing the header and one containing the footer. (type "none" for none)
Header: <input type="text" name="header" 
style="font-size:xx-small;font-face:verdana"
value="none" >
Footer: <input type="text" name="footer" 
style="font-size:xx-small;font-face:verdana"
value="none" ><BR>
<CENTER><input type="hidden" name="sub" value="User Settings">
        <input type="submit" name="subb" STYLE="background-color:#eeeeee;
font:verdana;font-weight:bold;color:#000080;font-size:xx-small;width:160;" 
value="Save New User Settings"><BR><BR>
AMM
&bo;
}}


open(pass, "$passfile");
while(<pass>) {
@ps = split(/\n/);
foreach $uid (@ps){
unless (uid eq "" || $uid eq " " || $uid eq "\n"){
($userid, $pass, $stat, $disk, $first, $last, $email, $sex, $expire, $vlogon, $ext, $faxfiles, $maxdirs, $log, $header, $footer, $homedir, $homeurl, $changepass) = split(/\:\:/,$uid);
if ($stat eq "no") {
$stat = "Normal";
}if ($stat eq "yes") {
$stat = "Dissabled";}
print <<DD;
<table border="1" cellpadding="0" cellspacing="0" width="99%"
bgcolor="#FFFFFF" bordercolor="#808080" bordercolordark="#808080"
bordercolorlight="#808080">
    <tr>
        <td width="50%"><font size="-1" face="verdana,verdana">Name: <font color="red" size="-1"><B>$sex $first $last</td>
        <td width="50%"><font size="-1" face="verdana,verdana">UserID: <font color="red"  size="-1"><B>$userid</td>
    </tr>
    <tr>
        <td width="50%"><font size="-1" face="verdana,verdana">Status: <font color="red" size="-1"><B>$stat</td>
        <td width="50%"><input type="submit" name="sub" STYLE="background-color:#eeeeee;
font:verdana;font-weight:bold;color:#000080;font-size:xx-small;width:134;" value="Edit $userid"></td>
            </tr>
</table><BR>

DD
}}}
print "</form>";
print <<DD;
<form method="post" action="$url">
<input type="submit" name="action" STYLE="background-color:#eeeeee;
font:verdana;font-weight:bold;color:#000080;font-size:xx-small;width:134;" value="Add User">
<input type="submit" name="action" STYLE="background-color:#eeeeee;
font:verdana;font-weight:bold;color:#000080;font-size:xx-small;width:134;" value="Delete User">
<BR></form>
DD
}
if ($sub eq "Save Path To Home Directories") {

open(prf, "prefs");
@fl = <prf>;
close (prf);

open(prff, ">prefs");
foreach $l (@fl) {
unless ($l =~ "1\;" || $l =~ /^\$usrdir/){
print prff "$l";
}
}

print prff "\$nusrdir = \"$input{'userdir'}\"\;\n";
print prff "1\;\n";
print "Thank you, your preferences were saved. Click <a href=\"$url?action=am\">here</a> to continue.";
&bo;
exit 0;
}
if ($sub eq "Save Default Disk Space") {
$input{'diskspace'} =~ s/\,//g;
$input{'diskspace'} =~ s/[a-z]//g;
$input{'diskspace'} =~ s/[A-Z]//g;

open(prf, "prefs");
@fl = <prf>;
close (prf);

open(prff, ">prefs");
foreach $l (@fl) {
unless ($l =~ "1\;" || $l =~ /^\$diskspace/){
print prff "$l";
}
}

print prff "\$diskspace = \"$input{'diskspace'}\"\;\n";
print prff "1\;\n";
print "Thank you, your preferences were saved. Click <a href=\"$url?action=am\">here</a> to continue.";
&bo;
exit 0;
}




if ($sub eq "Save Default Settings") {
open(prf, "prefs");
@fl = <prf>;
close (prf);

open(prff, ">prefs");
foreach $l (@fl) {
unless ($l =~ "1\;" || $l =~ /^\$passchange/ || $l =~ /^\$maxuser/
 || $l =~ /^\$minpass/
 || $l =~ /^\$maxpass/
 || $l =~ /^\$minuser/){
print prff "$l";
}
}

print prff "\$minpass = \"$input{'minpass'}\"\;\n";
print prff "\$maxpass = \"$input{'maxpass'}\"\;\n";
print prff "\$minuser = \"$input{'minuser'}\"\;\n";
print prff "\$maxuser = \"$input{'maxuser'}\"\;\n";
print prff "\$passchange = \"$input{'passchange'}\"\;\n";
print prff "1\;\n";
print "Thank you, your preferences were saved. Click <a href=\"$url?action=am\">here</a> to continue.";
&bo;
exit 0;
}
if ($sub eq "Save Password File Path") {

print "Saving path...<BR>\n";
open(prf, "prefs");
@fl = <prf>;
close (prf);

open(prff, ">prefs");
foreach $l (@fl) {
unless ($l =~ "1\;" || $l =~ /^\$passfile/){
print prff "$l";
}}
close(prf);
$pass = $input{'passfile'};
print prff "\$passfile = \"$pass\"\;\n";
print prff "1\;\n";
close(prff);
if (!-e "$input{'passfile'}") {
open(PS,">$input{'passfile'}");
close(PS);
print "creating password file at $input{'passfile'}<BR>\n";
}
$time = "0";
print "Thank you. Your preferences were saved. Click <a href=\"$url?action=am\">here</a> to continue.";
&bo;
exit 0;
}

if ($sub eq "Save URL To Home Directories") {
open(prf, "prefs");
@fl = <prf>;
close (prf);

open(prff, ">prefs");
foreach $l (@fl) {
unless ($l =~ "1\;" || $l =~ /^\$userurl/){
print prff "$l";
}
}

print prff "\$nuserurl = \"$input{'userurl'}\"\;\n";
print prff "1\;\n";
print "Thank you, your preferences were saved. Click <a href=\"$url?action=am\">here</a> to continue.";
&bo;
exit 0;
}
if ($sub eq "Save Password File Path") {

print "Saving path...<BR>\n";
open(prf, "prefs");
@fl = <prf>;
close (prf);

open(prff, ">prefs");
foreach $l (@fl) {
unless ($l =~ "1\;" || $l =~ /^\$passfile/){
print prff "$l";
}
}
close(prf);
$pass = $input{'passfile'};
print prff "\$passfile = \"$pass\"\;\n";
print prff "1\;\n";
close(prff);
if (!-e "$input{'passfile'}") {
open(PS,">$input{'passfile'}");
close(PS);
print "creating password file at $input{'passfile'}<BR>\n";
}
$time = "0";
print "Thank you. Your preferences were saved. Click <a href=\"$url?action=am\">here</a> to continue.";
&bo;
exit 0;}
exit 0;}
sub bo {

print <<AMM;

</td>
    </tr>
</table>
</center></div><hr><a href="http://www.elitehosts.com/scripts">
©1999 Avi Brender.</a> All rights reserved.
</body>
</html>
AMM
exit 0;
}
sub conf {

$nuserid = $input{'nuserid'};
$npassword = $input{'npassword'};

$userid = crypt($input{userid},time);
$password = crypt($input{password},time);
if ($time eq "1") {
$time = "0";
}else {
$time = "2";
}
unless ($userid eq "$nuserid" && $password eq "$npassword") {

print <<SSMM;
<html>

<head>
<meta http-equiv="Content-Type"
content="text/html; charset=iso-8859-1">
<meta name="GENERATOR" content="Microsoft FrontPage Express 2.0">
<title>Scripts In The Making</title>
<style>
.bl:hover{color:red;text-decoration:underline}
a{text-decoration:none}

</style>
</head>

<body bgcolor="#FFFFFF">
<div align="center"><center>
<form method="post" action="$url">
SSMM
print <<TGBL;
<table border="1" cellpadding="0" cellspacing="0" width="50%"
bordercolor="#000000" bordercolordark="#000000"
bordercolorlight="#000000">
    <tr>
        <td align="center" colspan="1" bgcolor="#000091"><font
        color="#FFFFFF" face="verdana">Elite Web Page
        Builder - Main Page</font></td>
    </tr>
    <tr>
           <td bgcolor="#CFCFCF" valign="top"><BR><font face="verdana" size="-1">
Sorry, but your new UserID or password does not match the UserID and password
you first entered. Please try again.<BR><BR><font face="aria" size="-1" color="darkblue">Please Note:
<BR>This script may not be sold.<BR>
This script may not be re-distributed<BR>
This script may not be edited<BR>
You may not remove the link from the bottom of the page<BR>
<B>Without permission from the <a href="mailto:abmusic99\@aol.com">author.</a><BR><BR>

</font><font face="verdana" size="-1" color="blue">Step 2: Confirm Main Account (Again).<BR><BR>
<font color="red">Please confirm your UserID and password for your main account.<BR><font color="green">
UserID:<input type="text" Name="userid" style="background-color:orange;font-face:verdana;
font-size:xx-small;color:black" size="30"><BR>
Password:<input type="password" Name="password" style="background-color:orange;font-face:verdana;
font-size:xx-small;color:black" size="30"><BR>
<input type="hidden" name="nuserid" value="$nuserid">
<input type="hidden" name="npassword" value="$npassword">
<CENTER><input type="hidden" name="action" value="confirm">
<input type="submit" name="submit" STYLE="background-color:#eeeeee;font:verdana;font-weight:bold;
color:#000080;font-size:xx-small;width:134;" value="Save!"></td>

    </tr>
</table>
TGBL
}else {
open (FILEY, ">prefs");
print FILEY "\$adminname = \"$userid\"\;\n";
print FILEY "\$adminpass = \"$password\"\;\n";
print FILEY "1\;\n";

&am;
}

print <<SSMM;
</center></div>
</body></form>
</html>
SSMM
exit 0;
}
sub saveid {

	$nuserid = crypt($input{userid},time);
	$npassword = crypt($input{password},time);

print <<SSMM;
<html>

<head>
<meta http-equiv="Content-Type"
content="text/html; charset=iso-8859-1">
<meta name="GENERATOR" content="Microsoft FrontPage Express 2.0">
<title>Scripts In The Making</title>
<style>
.bl:hover{color:red;text-decoration:underline}
a{text-decoration:none}

</style>
</head>
</form>
<body bgcolor="#FFFFFF">
<div align="center"><center>
<form method="post" action="$url">
<table border="1" cellpadding="0" cellspacing="0" width="50%"
bordercolor="#000000" bordercolordark="#000000"
bordercolorlight="#000000">
    <tr>
        <td align="center" colspan="1" bgcolor="#000091"><font
        color="#FFFFFF" face="verdana">Elite Web Page
        Builder - Main Page</font></td>
    </tr>
    <tr>
           <td bgcolor="#CFCFCF" valign="top"><BR><font face="verdana" size="-1">
Welcome. You are seeing this screen because this is the first time that you
are using this script.<BR><BR><font face="aria" size="-1" color="darkblue">Please Note:
<BR>This script may not be sold.<BR>
This script may not be re-distributed<BR>
This script may not be edited<BR>
You may not remove the link from the bottom of the page<BR>
<B>Without permission from the <a href="mailto:abmusic99\@aol.com">author.</a><BR><BR>

</font><font face="verdana" size="-1" color="blue">Step 2: Confirm Main Account.<BR><BR>
<font color="red">Please confirm your UserID and password for your main account.<BR><font color="green">
UserID:<input type="text" Name="userid" style="background-color:orange;font-face:verdana;
font-size:xx-small;color:black" size="30"><BR>
Password:<input type="password" Name="password" style="background-color:orange;font-face:verdana;
font-size:xx-small;color:black" size="30"><BR>
<input type="hidden" name="nuserid" value="$nuserid">
<input type="hidden" name="npassword" value="$npassword">
<CENTER><input type="hidden" name="action" value="confirm">
<input type="submit" name="submit" STYLE="background-color:#eeeeee;font:verdana;font-weight:bold;
color:#000080;font-size:xx-small;width:134;" value="Save"></td>
</form>
    </tr>
</table>
</center></div>
</body>
</html>
SSMM
exit 0;

}
sub prevdir {
$cd = $input{'cd'};
@all = split(/\//, $cd);
$dnn = "0";
foreach $dir (@all) {
$dnn = $dnn + 1;
}
@all = split(/\//, $cd);
$dn = "0"; 
foreach $dir (@all) {
$dn = $dn + 1;
unless ($dn eq "$dnn" || $dir eq "") {
$nd .= "/$dir";
}}
if ($nd eq "" || $dnn eq "" || $dnn eq "1" || $dnn eq "0") {
$nd = "/";
$cd = "/";
$ndd = "/";
$oky = "/";
&good_logon;
exit 0;
}
$cd = $nd;
$ndd = $nd;
$oky = $ndd;
&good_logon;
exit 0;
}
sub logonform {

$title = "Log on";
&top;
print <<LOGO;
<p align="center"><font color="#000080"
                    size="3" face="Verdana, Arail"><b>Log On</b></font></p>
<font color="#000080" size="2"
                    face="Verdana, Arail">
<b>UserID:</b></font><font                 
color="#000080" size="1"
                    face="Verdana, Arail"><b> </b></font><input
                    type="text" size="20" name="userid" ><br>
                    <font color="#000080" size="2"
                    face="Verdana, Arail"><b>Password: </b></font><input
                    type="password" size="20" name="passwd" ></p>
<input type="submit"
            name="action" value="Logon"><input type="reset"
            name="reset" value="Start Again"><BR><a href="$cgi_script?action=lostpass">
<font color="blue"><u>Lost
Your Password?</a></u></font>  
LOGO
&bottom;
exit 0;
}
sub top {
 @days   = ('Sunday','Monday','Tuesday','Wednesday',
               'Thursday','Friday','Saturday');
    @months = ('January','February','March','April','May','June','July',
	         'August','September','October','November','December');


    ($sec,$min,$hour,$mday,$mon,$year,$wday) = (localtime(time))[0,1,2,3,4,5,6];
    $time = sprintf("%02d:%02d:%02d",$hour,$min,$sec);
if ($hour eq "13") {
$hour = "1";
$pm = "y";
}if ($hour eq "14") {
$hour = "2";
$pm = "y";
}if ($hour eq "15") {
$hour = "3";
$pm = "y";
}if ($hour eq "16") {
$hour = "4";
$pm = "y";
}if ($hour eq "17") {
$hour = "5";
$pm = "y";
}if ($hour eq "18") {
$hour = "6";
$pm = "y";
}if ($hour eq "19") {
$hour = "7";
$pm = "y";
}if ($hour eq "20") {
$hour = "8";
$pm = "y";
}if ($hour eq "21") {
$hour = "9";
$pm = "y";
}if ($hour eq "22") {
$hour = "10";
$pm = "y";
}if ($hour eq "23") {
$hour = "11";
$pm = "y";
}if ($hour eq "24") {
$hour = "12";
$pm = "y";
}
 $time = sprintf("%02d:%02d",$hour,$min);
$tdate = "$days[$wday], $months[$mon] $mday, $year";
$mon = $mon + 1;

if ($pm eq "y") {
$tm = "pm";
}else {
$tm = "am";
}
print <<LOGO;
<html>

<head>
<title>$title</title>
<style>
a{text-decoration:none}
</style>

</head>

<body bgcolor="#FFFFFF" topmargin="0" leftmargin="0">

<p align="center"><br>
</p>
<div align="center"><center>

<table border="1" cellpadding="0" cellspacing="0" width="700"
bordercolor="#C0C0C0">
    <tr>
        <td align="center" width="40"><font face="verdana">$mon/$mday/$year</font></td>
        <td align="center" bgcolor="#FFFFFF"><font
        color="#000000" size="5" face="Impact">Elite Web Page
        Builder</font></td>
        <td align="center" width="40"><font face="verdana">$time$tm
        (EST)</font></td>
    </tr>
    <tr>
        <td colspan="3">
<form method="post" action="$cgi_script">
LOGO
}
sub bottom {
print <<BOTHEAD;
                    <BR></form><form method="post" action="$cgi_script">
BOTHEAD
unless($action eq "" || $ns eq "32") {
print <<BOTHEAD;
<input type="hidden" name="userid" value="$userid">
<input type="hidden" name="action" value="back">
</form>
BOTHEAD
}
print <<BOTHEAD;
   </td>
    </tr>
    <tr>
        <td colspan="3"><a
        href="http://www.elitehosts.com/scripts/index.html"><font
        color="#0000FF" size="1" face="Verdana, verdana"><b>Created
        By: Avi Brender<br>
        (c) 1998 Avi Brender.</b></font></a></td>
    </tr>
</table>
</center></div>

<p align="center"><br>
</p>
</body>
</html>
BOTHEAD
}

sub logon_user {
$userlogon = $input{'userid'};
$userpass = $input{'passwd'};
$new_username = crypt($input{'userid'},time);
$new_password = crypt($input{'passwd'},time);
if ($new_username eq "$adminname" && $new_password eq "$adminpass") {
&am;
exit 0;
}
open(CHECK, "$passfile");	
	while(<CHECK>) {
	@all = split(/\n/);
	foreach $line (@all) {
	($userid, $loginpass, $type, $html) = split(/\:\:/, $line);

$userpass = crypt($userpass,time);
	if($userid eq "$userlogon" && $loginpass eq "$new_password" || 
$userid eq "$userlogon" && $new_password eq "$adminpass") {
$userid = $input{'userid'};
$userlogon = $input{'userid'};
&good_logon;
exit 0;
}
}
}
	
$errortitle="Invalid Logon";
$headline="Invalid Logon";
$text="You have entered an incorrect username and/or password.";
$ns = 32;
&error;
exit 0;
}

sub checkpass {

$userlogon = $input{'userid'};
$userpass = $input{'passwd'};
$userid = $input{'userid'};
open(CHECK, "$passfile");	
	while(<CHECK>) {
	@all = split(/\n/);
	foreach $line (@all) {
	($userid, $loginpass, $type, $html) = split(/\:\:/, $line);
$loginpass = crypt($loginpass,time);
$userpass = crypt($userpass,time);
	if($userid eq "$userlogon" && $loginpass eq "$userpass" || $userid eq "$userlogon" && $loginpass eq "$adminpass") {

$userid = $input{'userid'};
$userlogon = $input{'userid'};
exit 0;
}
}
}

	
$errortitle="Invalid Logon";
$headline="Invalid Logon";
$text="You have entered an incorrect username and/or password.";
$ns = 32;
&error;
exit 0;
}


sub good_logon{
$userlogon = $input{'userid'};
$username = "$userlogon";
$userpass = $input{'passwd'};
$userid = $input{'userid'};
$size = "Not Available";

open(CHECK, "$passfile");	
	while(<CHECK>) {
	@all = split(/\n/);
	foreach $line (@all) {
	($userid3, $pase, $sus) = split(/\:\:/, $line);
	if($userid3 eq "$userlogon") {
if ($sus eq "yes") {


&top;
print "Sorry, your account has been dissabled.";
$ns="32";
&bottom;
exit 0;
}}}}
open(PASSWTeE,"inactive");
	while(<PASSWTeE>) {
	@all = split(/\n/);
	foreach $line (@all) {
	($u, $c) = split(/\\*\*/, $line);
if ($u eq "$userlogon") {

&top;
print "Sorry, you have not yet activated your account. To activate your account, please go here: <a href=\"$cgi_script?action=activate&userid=$userid\">$cgi_script?action=activate&userid=$userid</a>";
&bottom;
exit 0;
}}}

$uee="$userid";
$ue = "$userid";

$ndd = $input{'nd'};
if ($ndd eq "") {
$ndd = $oky;
}
if ($ndd eq "") {
$ndd = "/";
}

if ($ndd eq "/") {
$nd = "$usrdir";
}
else {
$nd = "$usrdir$ndd"
} 
if (!-e "$nd") {

&top;
print "Sorry, this directory does not exist!";
&bottom;

exit 0;
} 


&top;
print <<GOODL;
<div
                        align="center">
<center><table
        border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td align="center" colspan="3"><font size="4"
                face="verdana">You are now in </font><font
                color="#FF0000" size="4" face="verdana">$ndd</font></td>
            </tr>
<tr>
                <td width="120" bgcolor="#000000"><font
                color="#FFFFFF" face="verdana">Filename </font></td>
                <td width="100" bgcolor="#000000"><font
                color="#FFFFFF" face="verdana">File Size</font></td>
                <td bgcolor="#000000"><font color="#FFFFFF"
                face="verdana">Options</font></td>
            </tr>

GOODL
unless($ndd eq "/" || $ndd eq "" || $cd eq "/") {
print <<OKYTA;
<TR bgcolor="#005782"><TD bgcolor="#005782" colspan="3">
<input type="submit" name="action" value="Previous Directory"></TD>
OKYTA
}
    opendir (DIR, "$nd") or &cgierr;
    my @ls = readdir(DIR);
    closedir (DIR);
    my (%directory, %text, %graphic);
    my ($temp_dir, $newdir, @nest, $fullfile, $filesize, $filedate, $fileperm, $fileicon, $file);
foreach $file (@ls) {
unless ($file eq "." || $file eq "" || $file eq " " || $file eq ".."){
        $fullfile = "$nd/$file";
        ($filesize, $filedate, $fileperm) = (stat($fullfile))[7,9,2];
$yesfiles = "1";
if ($file eq "index.html" || $file eq "index.htm") {
$in = "1";
}
if (-d "$fullfile") {
$d = "$fillfile";

close (FIIILE);
$cdd = $input{'cd'};  
print <<GOODL2;

<tr><td bgcolor="#005782"><font color="yellow"><img src="folder.jpg">

GOODL2
if ($ndd eq "/") {
print <<GOODL2;
<a href="$cgi_script?action=chdir&nd=/$file&userid=$userid"><font color="yellow">$file</a></font></td>
GOODL2
}
else {
print <<GOODL2;
<a href="$cgi_script?action=chdir&nd=$ndd/$file&userid=$userid"><font color="yellow">$file</a></font></td>
GOODL2
}
print <<GOODL2;
       <td bgcolor="#005782"><font color="yellow">Directory
 </font></td><td bgcolor="#005782">
GOODL2
if ($ndd eq "/") {
print <<OKUY;
<a href="$cgi_script?action=rename&file=$file&userid=$userid&cd=$ndd"><font color="yellow">[Rename]</a>
OKUY
}
else {
print <<OKUY;


<a href="$cgi_script?action=rename&file=$file&userid=$userid&cd=$cd$ndd"><font color="yellow">[Rename]</a>
OKUY
}
if ($ndd eq "/") {
print <<OKUY;
<a href="$cgi_script?action=delete&file=$file&userid=$userid&cd=$ndd"><font color="yellow">[Delete]</a>
OKUY
}
else {
print <<OKUY;
<a href="$cgi_script?action=delete&file=$file&userid=$userid&cd=$cd$ndd"><font color="yellow">[Delete]</a>
OKUY
}



print <<GOODL2;

</td>
       </tr>
GOODL2
}
}
}
    opendir (DIR, "$nd") or &cgierr;
    my @ls = readdir(DIR);
    closedir (DIR);
    my (%directory, %text, %graphic);
    my ($temp_dir, $newdir, @nest, $fullfile, $filesize, $filedate, $fileperm, $fileicon, $file);
foreach $file (@ls) {
unless ($file eq "." || $file eq "" || $file eq " " || $file eq ".."){
        $fullfile = "$nd/$file";
        ($filesize, $filedate, $fileperm) = (stat($fullfile))[7,9,2];
$yesfiles = "1";
unless (-d "$fullfile") {

$nc = $ndd;
if ($ndd ne "" || $ndd ne " " || $ndd eq "/") {
unless ($ndd eq "/"){
$nc = "/";
}$nc = $ndd;}
unless ($nc =~ /\/$/) {
$nc = "$ndd\/";
}unless ($nc =~ /^\//) {
$nc = "\/$ndd";}
print <<GOODL2;
<tr><td bgcolor="#005782"><font color="#FF0000"><a href="$userurl$nc$file"><font color="yellow">$file</a></font></td>
       <td bgcolor="#005782"><font color="yellow">$filesize bytes.
 </font></td><TD bgcolor="#005782">
GOODL2
if ($ndd eq "/") {
print <<OKUY;
<a href="$cgi_script?action=rename&file=$file&userid=$userid&cd=$ndd"><font color="yellow">[Rename]</a>
OKUY
}else {
print <<OKUY;
<a href="$cgi_script?action=rename&file=$file&userid=$userid&cd=$cd$ndd"><font color="yellow">[Rename]</a>
OKUY
}if ($ndd eq "/") {
print <<OKUY;
<a href="$cgi_script?action=delete&file=$file&userid=$userid&cd=$ndd"><font color="yellow">[Delete]</a>
OKUY
}else {
print <<OKUY;
<a href="$cgi_script?action=delete&file=$file&userid=$userid&cd=$cd$ndd"><font color="yellow">[Delete]</a>
OKUY
}if ($file =~ /.txt$/ || $file =~ /.htm$/ || $file =~ /.html$/) {
print <<GOODL3;
<a href="$cgi_script?action=edit&file=$file&userid=$userid&cd=$ndd"><font color="yellow">[Edit]</a>
GOODL3
}if ($ndd eq "/") {
print <<OKUY;
<a href="$cgi_script?action=copy&file=$file&userid=$userid&cd=$ndd"><font color="yellow">[Copy]</a>
<a href="$cgi_script?action=move&file=$file&userid=$userid&cd=$ndd"><font color="yellow">[Move]</a>
OKUY
}
else {
print <<OKUY;
<a href="$cgi_script?action=copy&file=$file&userid=$userid&cd=$cd$ndd"><font color="yellow">[Copy]</a>
<a href="$cgi_script?action=move&file=$file&userid=$userid&cd=$cd$ndd"><font color="yellow">[Move]</a>
OKUY
}
print <<GOODL2;
 </td>

       </tr>
GOODL2
}
}
}
close(FIIILE);
if ($yesfiles ne "1") {
print "<tr><TD colspan=\"3\" align=\"center\"><B><font color=\"red\" face=\"verdana\" size=\"2\">There are no files in /$userid$ndd</font></td></Tr>";
}

print "</table>";
if ($yesfiles eq "1" && $in ne "1") {
print "<B><font color=\"red\" face=\"verdana\" size=\"2\">WARNING: There is no index.html or index.htm in /$userid$ndd. That means that anyone can view all of the files in this directory!</font>";
}
close(FILE);
open(CHECK, "$passfile");	
	while(<CHECK>) {
	@all = split(/\n/);
	foreach $line (@all) {
	($userid2, $loginpass, $sus, $disks) = split(/\:\:/, $line);
	if($userid2 eq "$userlogon") {
$ds = $disks;
}}}
&ds;
$free = $ds - $used;
if ($free eq "" || $free eq "0" || $free =~ "\-") {
$free = "0";
}
if ($ds eq "0") {
$ds = "Unlimited";
$free = "Unlimited";
}
print <<BUTTONS;
</center></B></CENTER></p></div>
<font face="verdana, verdana">Allotted Disk Space: $ds bytes<BR>
Total Number Of Files: $files<BR>
Total Number Of Directories: $dirs<BR>
Used Space: $used bytes<BR>
Free Space: $free bytes<BR>
<BR>(1,000,000 bytes = 1mb)
<input type="hidden" name="cd" value="$ndd">
<center><input type="submit"
                        name="action" value="Log Out">
<BR>                       
BUTTONS
open(CHECK, "$passfile");	

	while(<CHECK>) {
	@all = split(/\n/);
	foreach $line (@all) {

($suseridd, $pass, $stat, $disk, $first, $last, ,$email, $sex, $expire, $vlogon, $ext, $maxfiles, $maxdirs, $log, $header, $footer, $homedir, $homeurl, $changepasss)
= split(/\:\:/,$line);
	if($suseridd eq "$userid") {
if ($changepasss eq "yes") {
print <<ADMINB;
                        <input type="submit" name="action"
                        value="Change Your Password"><BR> 
ADMINB
close(CHECK);
}}}
}
open(CHECK, "$passfile");	
	while(<CHECK>) {
	@all = split(/\n/);
	foreach $line (@all) {
	($userid2, $loginpass, $type, $html) = split(/\:\:/, $line);
	if($userid2 eq "$userlogon") {
foreach $userid2($userid2) {
if ($userid2 eq "$userlogon") {
if ($type eq "admin"){
print "<INPUT TYPE=\"SUBMIT\" NAME=\"action\" value=\"Change Users Properties\">\n";
print "<INPUT TYPE=\"SUBMIT\" NAME=\"action\" value=\"Setup Script\"><BR>\n";
}}}}}}


print "<INPUT TYPE=\"SUBMIT\" NAME=\"action\" value=\"Create New Directory\">";
print "<INPUT TYPE=\"SUBMIT\" NAME=\"action\" value=\"Create New HTML File\">";




print <<BUTTON2;

<INPUT TYPE="HIDDEN" NAME="userid" value="$ue">

BUTTON2


open(CHECK, "$passfile");	
	while(<CHECK>) {
	@all = split(/\n/);
	foreach $line (@all) {
	($userid2, $loginpass, $type, $html) = split(/\:\:/, $line);
	if($userid2 eq "$userlogon") {
foreach $userid2($userid2) {
if ($userid2 eq "$userlogon") {
if ($type eq "admin"){
print <<ADMINB;
<BR>
<INPUT TYPE="SUBMIT" NAME="action" value="Suspend User">
<INPUT TYPE="SUBMIT" NAME="action" value="Unsuspend User">
<INPUT TYPE="SUBMIT" NAME="action" value="View Suspended Users"><BR>
<INPUT TYPE="SUBMIT" NAME="action" value="Change Password">

<INPUT TYPE="SUBMIT" NAME="action" value="Add User">
<INPUT TYPE="SUBMIT" NAME="action" value="Delete User">
<INPUT TYPE="SUBMIT" NAME="action" value="Dissable All Logons">
<BR>
ADMINB
}}}
close(CHECK);
}}}
print <<BUTTON23;
<center>
<TABLE border="1"><TR><TD><font color="navy">To <B>update</B> this page press the <b>refresh</b> button.</Td></TR></table>

BUTTON23

print <<END;
<TaBLE width="100%"><TR bgcolor="navy"><TD bgcolor="navy">
</FORM><FORM METHOD="POST" ENCTYPE="multipart/form-data" ACTION="$cgi_script">
<INPUT TYPE=hidden name="userid" value="$ue">
<INPUT TYPE=hidden name="cd" value="$ndd">
<CENTER>
<font color="#FFFFFF" size="3" face="arail">
<b>FILE 1:</b> <INPUT TYPE=file NAME=upfile1 SIZE="30"><BR>
<b>FILE 2:</b> <INPUT TYPE=file NAME=upfile2 SIZE="30"><BR>
<b>FILE 3:</b> <INPUT TYPE=file NAME=upfile3 SIZE="30"><BR>
<b>FILE 4:</font></b> <INPUT TYPE=file NAME=upfile4 SIZE="30"><BR>
<INPUT VALUE="        Upload File(s)      "  TYPE=submit > 
</FORM>

</td>
        </tr>
        </table>

END
$ns = "32";
&bottom;
exit 0;
}


sub createdir {
$userid = $input{'userid'};
$cd = $input{'cd'};

&top;
print <<STJKL;
<form method="post" action="$cgi_script">
<input type="hidden" name="cd" value="$cd">
<input type="hidden" name="userid" value="$userid">
<center><font face="verdana" color="navy" size="3"><B>Create New Directory</b></font><BR><BR></center>
<table border="0"><TR><TD>
<font face="verdana" color="navy" size="3">New Directory Name: <input type="text" name="newdir"></td></TR><TR><TD align="center">
<input type="submit" name="action" value="Make Directory">
</td></tr></table>
</form>
STJKL
$ns="32";
&bottom;
exit 0;
}
sub makedir {
$userid = $input{'userid'};
$cd = $input{'cd'};
$newdir = $input{'newdir'};
if ($cd eq "/") {
if (-e "$usrdir/$newdir" && -d "$usrdir/$newdir") {
$errortitle = "Error Creating $newdir";
$headline = "$newdir Already Exists";
$text = "There is already a directory named $newdir in /$userid/";
&error;
exit 0;
}
mkdir("$usrdir/$newdir",0777);

}
else {
if (-e "$usrdir$cd/$newdir" && -d "$usrdir$cd/$newdir") {
$errortitle = "Error Creating $newdir";
$headline = "$newdir Already Exists";
$text = "There is already a directory named $newdir in /$userid$cd/";
&error;
exit 0;
}
mkdir("$usrdir$cd/$newdir",0777);
}
$errortitle = "Directory Created";
$headline = "$newdir Was Created";
$text = "$newdir was created in /$userid$cd";
&error;
exit 0;
}

sub deleteform {
$userid47 = $input{'userid'};
$userid = $input{'userid'};
$pswd = $input{'userid'};
$cd = $input{'cd'};
$file = $input{'file'};


$title = "Delete File";
&top;
print <<DEL;
<input type="hidden" name="action" value="Delete Now">
<center><font color="#000080"
                    size="3" face="Verdana, Arail"><b>Delete File</b></font></center>
                    <font color="#000080" size="2"
                    face="Verdana, Arail"><b>File to delete: $file</b></font>
DEL
print <<DEL2;
                                        </td>
                </tr>
        <tr><input type="hidden" name="cd" value="$cd">
<input type="hidden" name="userid" value="$userid">
<input type="hidden" name="file" value="$file">
            <td align="left" valign="top">Are you sure you want to delete $file?? <input type="submit"
            name="delete" value="Yes"><input type="submit" name="delete" value="No">

DEL2
$ns = "32";
&bottom;
exit 0;
}
sub renameform {
$file = $input{'file'};
$userid47 = $input{'userid'};
$pswd = $input{'userid'};
$userid = $input{'userid'};
$cd = $input{'cd'};

$title = "Rename File";
&top;
print <<RF;
<p align="center">
<input type="hidden" name="userid" value="$userid47">
<font color="#000080"
                    size="3" face="Verdana, Arail"><b>Rename File</b></font></p>
                    <p><font color="#000080" size="2"
                    face="Verdana, verdana"><b>Old Filename: $file </b></font><br>
                    <font color="#000080" size="2"
                    face="Verdana, verdana"><b>New Filename: </b></font><input
                    type="text" size="20" name="new"></p>
                    </td>
                </tr>

        <tr>
            <td align="center" valign="top">
<input type="hidden" name="file" value="$file">
<input type="hidden" name="cd" value="$cd">
<input type="submit"
            name="action" value="Rename The File"><input
            type="reset" name="reset" value="Start Again">

RF
&bottom;
exit 0;
}
sub rename{
$file = $input{'file'};
$new = $input{'new'};
$userid47 = $input{'userid'};
$userid = $input{'userid'};
$pswd = $input{'userid'};
($userid29, $rnd3) = split(/$pdivider/, $pswd);


$ue = $input{'userid'};
$filename = $new;

if ($file eq "") {
$errortitle = "Error";
$headline = "Select A File";
$text = "Please go back and select a file.";
&error;
exit 0;
}


if ($new eq "") {
$errortitle = "Error";
$headline = "New Filename";
$text = "Please go back and enter a new filename";
&error;
exit 0;
}
if ($file eq "SELECT ONE") {
$errortitle = "Error";
$headline = "Select A File";
$text = "Please go back and select a file.";
&error;
exit 0;
}
if ($file eq "Select One") {
$errortitle = "Select a File";
$headline = "Please Select a File";
$text = "Please go back and select a file to rename";
&error;
exit 0;
}
$cd = $input{'cd'};
if ($cd eq "/") {
if (!-e "$usrdir/$file" || -e "$usrdir/$new") {
$errortitle = "Error";
$headline = "Error";
$text = "Either the file that you are renaming does not exist or the new filename is already in use.";
&error;
exit 0;
}
}
if ($cd ne "/") {
if (!-e "$usrdir$cd/$file" || -e "$usrdir$cd/$new") {
$errortitle = "Error";
$headline = "Error";
$text = "Either the file that you are renaming does not exist or the new filename is already in use.";
&error;
exit 0;
}
}

if ($cd eq "/") {
if (!-d "$usrdir/$file") {
&ext($filename);}}

if ($cd ne "/") {
if (!-d "$usrdir$cd/$file") {
&ext($filename);}
}
if ($cd eq "/") {
rename ("$usrdir/$file", "$usrdir/$new");
}
else {
rename ("$usrdir$cd/$file", "$usrdir$cd/$new");
}
    @days   = ('Sunday','Monday','Tuesday','Wednesday',
               'Thursday','Friday','Saturday');
    @months = ('January','February','March','April','May','June','July',
	         'August','September','October','November','December');

    ($sec,$min,$hour,$mday,$mon,$year,$wday) = (localtime(time))[0,1,2,3,4,5,6];
    $time = sprintf("%02d:%02d:%02d",$hour,$min,$sec);
    $year += 1900;

    $date = "$days[$wday], $months[$mon] $mday, $year";

$Errortitle = "Renamed";
$headline = "$file Was Renamed";
$text = "$file was renamed to $new";
&error;
exit 0;
}
sub delete {

$file = $input{'file'};
$userid = $input{'userid'};
$delete = $input{'delete'};
$cd = $input{'cd'};
if ($delete eq "No") {
&good_logon;
}
if ($file eq "Select One") {
$errortitle="Select A File";
$headline="Select A File";
$text = "Please go back and select a file.";
&error;
exit 0;
}
if ($file eq "SELECT ONE") {
$errortitle="Select A File";
$headline="Select A File";
$text = "Please go back and select a file.";
&error;
exit 0;
}
if ($file eq "") {
$errortitle="Select A File";
$headline="Select A File";
$text = "Please go back and select a file.";
&error;
exit 0;
}
if ($cd eq "/") {

if (-e "$usrdir/$file") {
if (!-d "$usrdir/$file") {
unlink ("$usrdir/$file");
$errortitle = "Delete OK";
$headline = "Delete OK";
$text = "$file was successfully deleted.";
&error;
exit 0;
}
else {
opendir (DIR, "$usrdir/$file") or &cgierr;
    my @ls = readdir(DIR);
    closedir (DIR);
my (%directory, %text, %graphic);
my ($temp_dir, $newdir, @nest, $fullfile, $filesize, $filedate, $fileperm, $fileicon, $filee);
foreach $filee (@ls) {
unless ($filee eq "." || $filee eq "" || $filee eq " " || $filee eq ".."){
        $fullfile = "$nd/$filee";
        ($filesize, $filedate, $fileperm) = (stat($fullfile))[7,9,2];
$yfiles = "1";
}}if ($yfiles eq "1") {
$errortitle = "Delete Error";
$headline = "File Not Empty";
$text = "The directory you selected was not deleted because it still contains files. Please delete all the files in $file and then try again.";
&error;
exit 0;
}rmdir ("$usrdir/$file");
$errortitle = "Delete OK";
$headline = "Delete OK";
$text = "$file was successfully deleted.";
&error;
exit 0;
}}}else {
if (-e "$usrdir$cd/$file") {
if (-d "$usrdir$cd/$file") {
opendir (DIR, "$usrdir$cd/$file") or &cgierr;
    my @ls = readdir(DIR);
    closedir (DIR);
my (%directory, %text, %graphic);
my ($temp_dir, $newdir, @nest, $fullfile, $filesize, $filedate, $fileperm, $fileicon, $filee);
foreach $filee (@ls) {
unless ($filee eq "." || $filee eq "" || $filee eq " " || $filee eq ".."){
$fullfile = "$nd/$filee";
($filesize, $filedate, $fileperm) = (stat($fullfile))[7,9,2];
$yfiles = "1";
}}if ($yfiles eq "1") {
$errortitle = "Delete Error";
$headline = "File Not Empty";
$text = "The directory you selected was not deleted because it still contains files. Please delete all the files in $file and then try again.";
&error;
exit 0;
}rmdir("$usrdir$cd/$file");
$errortitle = "Delete OK";
$headline = "Delete OK";
$text = "$file was successfully deleted.";
&error;
exit 0;
}elsif (!-d "$usrdir$cd/$file") {
unlink("$usrdir$cd/$file");
$errortitle = "Delete OK";
$headline = "Delete OK";
$text = "$file was successfully deleted.";
&error;
exit 0;
}$errortitle = "Delete OK";
$headline = "Delete OK";
$text = "$file was successfully deleted.";
&error;
exit 0;
}}
@days   = ('Sunday','Monday','Tuesday','Wednesday',
'Thursday','Friday','Saturday');
@months = ('January','February','March','April','May','June','July',
'August','September','October','November','December');
($sec,$min,$hour,$mday,$mon,$year,$wday) = (localtime(time))[0,1,2,3,4,5,6];
$time = sprintf("%02d:%02d:%02d",$hour,$min,$sec);
$year += 1900;
$date = "$days[$wday], $months[$mon] $mday, $year";open(FILE, "$usrdir/$old");
$errortitle = "Error";
$headline = "Non Existant File";
$text = "Sorry, that file does not exist, please go back and select a file to delete.";
&error;
exit 0;}

sub movefile {
$odir = $input{'odir'};
$file = $input{'file'};
$newdir = $input{'newdir'};
$userid = $input{'userid'};
if ($odir eq "/") {
$ok = rename("$usrdir/$file","$usrdir/$newdir/$file");
}else {
if ($newdir eq "/") {
$ok = rename("usrdir/$odir/$file","$usrdir/$file");
}else {
$ok = rename("$usrdir/$odir/$file","$usrdir/$odir/$newdir/$file");
}}

&top;
if ($newdir eq "/") {
print "$file was moved to /$userid/";
}else {
print "$file was successfully moved.";
}&bottom;
exit 0;
}

sub moveform {
$cnd = $input{'cd'};
$userid = $input{'userid'};
$file = $input{'file'};
$filee = $input{'file'};

&top;
print "<CENTER><h3><font color=\"navy\" face=\"verdana\" size=\"2\">Move $file<BR></center>";
print <<HERE;
<BR><table border="0" align="center"><TR><TD>Current Directory</td><TD>New Directory</td></tr>
<TR><TD width="175"><code>
HERE
if ($cnd eq "/") {
print "/$userid/</code></td><TD>";
}else {
print "/$userid$cnd/</code></td><TD>";
}print "<select name=\"newdir\">";
if ($cnd eq "/") {
$nd = "$usrdir";
}else {
$nd = "$usrdir/$cnd";
print "<option value=\"/\">/";
}if ($cnd ne "/") {   
opendir (DIR, "$usrdir") or &cgierr;
my @ls = readdir(DIR);
closedir (DIR);
my (%directory, %text, %graphic);
my ($temp_dir, $newdir, @nest, $fullfile, $filesize, $filedate, $fileperm, $fileicon, $file);
foreach $file (@ls) {
unless ($file eq "." || $file eq "" || $file eq " " || $file eq ".."){
$fullfile = "$usrdir/$file";
($filesize, $filedate, $fileperm) = (stat($fullfile))[7,9,2];
if (-d "$fullfile") {
print "<option value=\"/file\">/$file";
}}}}
opendir (DIR, "$nd") or &cgierr;
my @ls = readdir(DIR);
closedir (DIR);
my (%directory, %text, %graphic);
my ($temp_dir, $newdir, @nest, $fullfile, $filesize, $filedate, $fileperm, $fileicon, $file);
foreach $file (@ls) {
unless ($file eq "." || $file eq "" || $file eq " " || $file eq ".."){
$fullfile = "$nd/$file";
($filesize, $filedate, $fileperm) = (stat($fullfile))[7,9,2];
if (-d "$fullfile") {
$d = "$fillfile";
close (FIIILE);
print "<option value=\"$file\">$file</option>";
}}}close(FIIILE);
print "</select>";
print <<yOK;
</TD></TR>
<TR><Td colspan="2" align="center">
<input type="hidden" name="cd" value="/$userid$cnd/">
<input type="hidden" name="userid" value="$userid">
<input type="hidden" name="file" value="$filee">
<input type="hidden" name="odir" value="$cnd">
<input type="submit" name="action" value="Move The File"><input
            type="reset" name="reset" value="Start Again"></form>
</TD></tr>
</table>
yOK
$ns = "32";
&bottom;
exit 0;
}

sub logout {

$file = $input{'file'};
$userid = $input{'userid'};
$pswd = $input{'userid'};
&top;
print <<LOGO;
<font color="#000080" size="3" face="Verdana, Arail"><b><br>
You have been logged out. Thank you...</b></font>
LOGO
$ns = "32";
&bottom;
exit 0;}

sub copyform {
$file = $input{'file'};
$userid = $input{'userid'};
$title = "Copy File";
&top;
print <<COPY;
<p align="center"><font color="#000080"
size="3" face="Verdana, Arail"><b>Copy File</b></font></p>
<p><font color="#000080" size="2"
face="Verdana, Arail"><b>
<table border="0" align="center"><TR><TD>Current Name</td><TD>New Name</td></tr>
<TR><TD width="175"><code>$file</code></td><TD><input type="text" name="new"></TD></TR>
<TR><Td colspan="2" align="center">
<input type="hidden" name="userid" value="$userid">
<input type="hidden" name="old" value="$file">
<input type="hidden" name="cd" value="$input{'cd'}">
<input type="submit" name="action" value="Copy The File"><input
type="reset" name="reset" value="Start Again">
<BR></form>
</TD></tr>
</table>
</b></font>
COPY
$ns="32";
&bottom;
exit 0;
}

sub copyfile {
$file = $input{'file'};
$userid47 = $input{'userid'};
$pswd = $input{'userid'};
$userid = $input{'userid'};
$old = $input{'old'};
$new = $input{'new'};
if ($old eq "") {
$errortitle = "Error";
$headline = "Select A File";
$text = "Please go back and select a file to copy.";
&error;
exit 0;}
if ($new eq "") {
$errortitle = "Error";
$headline = "Enter A New Filename";
$text = "Please go back and enter a new filename.";
&error;
exit 0;}
$filename = $new;
if ($old eq "Select One" || $old eq "SELECT ONE") {
$errortitle = "Select A File";
$headline = "Select A File";
$text = "Please go back and select a file to copy.";
&error;
exit 0;}
$cd = $input{'cd'};
if ($cd eq "/") {
if (!-d "$usrdir/$old") {
&ext($filename);}}
else {
if ($cd ne "/") {
if (!-d "$usrdir$cd/$old") {
&ext($filename);}}}
if ($cd eq "/") {
if (-e "$usrdir/$new" || !-e "$usrdir/$old") {
$errortitle = "Error";
$headline = "Non Existant File";
$text = "Either $new already exists or $old doesn't exist.";
&error;
exit 0;}}
else {
if (-e "$usrdir$cd/$new" || !-e "$usrdir$cd/$old") {
$errortitle = "Error";
$headline = "Non Existant File";
$text = "Either $new already exists or $old doesn't exist.";
&error;
exit 0;}}
@days   = ('Sunday','Monday','Tuesday','Wednesday',
'Thursday','Friday','Saturday');
@months = ('January','February','March','April','May','June','July',
'August','September','October','November','December');
($sec,$min,$hour,$mday,$mon,$year,$wday) = (localtime(time))[0,1,2,3,4,5,6];
$time = sprintf("%02d:%02d:%02d",$hour,$min,$sec);
$year += 1900;
$date = "$days[$wday], $months[$mon] $mday, $year";open(FILE, "$usrdir/$old");
if ($cd eq "/") {
open(CHECK, "$passfile");	
while(<CHECK>) {
@all = split(/\n/);
foreach $line (@all) {
($userid2, $loginpass, $sus, $disks) = split(/\:\:/, $line);
if($userid2 eq "$userid") {
$ds = $disks;
}}}
$file2 = $filename;
$file2 .= "2";
$fullfilee = "$usrdir/$old";
($fsds, $filedate, $fileperm) = (stat("$usrdir/$old"))[7,9,2];
&ds;
 $free = $ds - $used;
if ($free eq "" || $free eq "0" || $free =~ "\-") {
$free = "0";
}if ($ds ne "0") {
$len = length("$TEXT");
if ($ds eq "0") {
$ds = "Unlimited";
$free = "Unlimited";
}if ($fsds >= $free) {

print "Sorry, not enough disk space to save this file. Please make it smaller. The new file will be:$fsds bytes and you only have $free bytes free.";
exit 0;
}}
open (OFLD,"$usrdir/$old");
@FILETE = <OFLD>;
close (OFLD);
open(FLS,">$usrdir/$new");
print FLS "@FILETE";
close(FILE);
$errortitle = "Copy Successful";
$headline = "Successful Copy";
$text = "$old was successfully copied to $new";
&error;
exit 0;
}else {
open (OFLD,"$usrdir$cd/$old");
@FILETE = <OFLD>;
close (OFLD);
open(FLS,">$usrdir$cd/$new");
print FLS "@FILETE";
close(FILE);
$errortitle = "Copy Successful";
$headline = "Successful Copy";
$text = "$old was successfully copied to $new";
&error;
exit 0;
}}
sub changepform {
$userlogon = $input{'userid'};
open(CHECK, "$passfile");	
while(<CHECK>) {
@all = split(/\n/);
foreach $line (@all) {
($userid, $loginpass, $type, $html) = split(/\:\:/, $line);
if($userid eq "$userlogon") {
unless ($type eq "admin") {
if ($passchange eq "no") {

$title = "Change Your Password";
&top;
print <<CHANGE1;
Sorry, you are not permitted to change your password.
CHANGE1
&bottom;
exit 0;
}}}}}
$passwd = $input{'passwd'};
$userid47 = $input{'userid'};
$pswd = $input{'userid'};
($userid29, $rnd3) = split(/$pdivider/, $pswd);

$title = "Change Your Password";
&top;
print <<CHANGE1;
<div align="center"><center><table
border="0" cellpadding="0" cellspacing="0" width="100%">
<tr>
<td width="50%"><font color="#000080" size="1"
face="Verdana, Arail"><b>Old Password: </b></font><input
type="password" size="20" name="old"></td>
<td width="50%"><font color="#000080" size="1"
face="Verdana, Arail"><b>New Password: </b></font><input
type="password" size="20" name="new"></td>
</tr><tr><td width="50%"><INPUT type="hidden" name="userid" value="$userid47">
<INPUT TYPE="HIDDEN" name="action" value="changepass"> </td>
<td width="50%"><font color="#000080" size="1"
face="Verdana, Arail"><b>Retype Password: </b></font><input
type="password" size="20" name="confirm" maxlength="$maxpass"></td>
</tr></table></center></div></td></tr><tr>
<td align="center" valign="top"><input type="submit"
name="submit" value="Change Password"> <input
type="reset" name="reset" value="Start Again">
CHANGE1
$ns="32";
&bottom;
exit 0;
}
sub changepass {
$userid47 = $input{'userid'};
$userid = $input{'userid'};
$pswd = $input{'userid'};
$old = $input{'old'};
$new = $input{'new'};
$confirm = $input{'confirm'};

if ($userid eq "" || $old eq "" || $new eq "" || $confirm eq ""){
$errortitle = "Error";
$headline = "Empty Input";
$text = "Please go back and fill in all the fields.";
&error;
exit 0;}
elsif ($new eq "$old") {
$errortitle = "Error";
$headline = "Your Passwords Match";
$text = "Your new and old passwords are the same, please go back and enter a new password.";
&error;
exit 0;}
elsif ($new ne $confirm){
$errortitle = "Error";
$headline = "Passwords Don't Match";
$text = "The two new passwords that you entered don't match, please go back and fix it.";
&error;
exit 0;}
unless (crypt($input{'old'},time) eq "$adminpass") {
$lpass = length("$new");
if ($lpass >= "$minpass" || $pass eq "$minpass") {
}else { 

&top;
print "Your password is too short.";
$ns = "32";
&bottom;
exit 0;
}if ($lpass >= "$maxpass") {

&top;
print "Your password is too long.";
$ns = "32";
&bottom;
exit 0;
}}
$old = crypt($input{'old'},time);	  	
$confirm = crypt($input{'confirm'},time);
open(CHECK, "$passfile");	
while(<CHECK>) {
@all = split(/\n/);
foreach $line (@all) {
($loginname1, $loginpass, $type, $html) = split(/\:\:/, $line);
if ($loginname1 eq "$userid47" && $loginpass eq "$old" 
||  $loginname1 eq "$userid47" && $old eq "$adminpass") {
open(DATA,"$passfile")|| &ERROR("CANT OPEN1");
@lines = <DATA>;
close(DATA);
open(DATA,">$passfile") || &ERROR("CANT OPEN2");
foreach $line (@lines)
{($loginname, $password, $a, $b, $c, $d, $e, $f, $g, $h, $i, $j, $k, $l, 
$m, $n, $o, $p, $q) = split(/\:\:/,$line);
if ($userid eq $loginname && $old eq $password || $userid eq "$loginname" && $old eq "$adminpass") 
{print DATA ("$userid\:\:$confirm\:\:$a\:\:$b\:\:$c\:\:$d\:\:$e\:\:$f\:\:$g\:\:$h\:\:$i\:\:$j\:\:$k\:\:$l\:\:$m\:\:$n\:\:$o\:\:$p\:\:$q");
$okk = "52";}else{print DATA $line;}}
close(DATA);}}}
if ($okk eq "52") {
$errortitle = "Change OK";
$headline = "Change OK";
$text = "Your password was changed as requested.";
&error;
exit 0;
}else {
$errortitle = "Invalid Password";
$headline = "Invalid Password";
$text = "Sorry, but you have entered an invalid password.";
&error;
exit 0;
}}
sub adduser {

$title = "Add User";
&top;
print <<ADDFORM;
<input type="hidden" name="action" value="adduser">
<table border="0"
cellpadding="0" cellspacing="0" width="100%">
<TR><TD align="right"><font color="#000080" size="2" face="Verdana, Arail">
User ID:</td><TD>
<input type="text" size="15" name="userid" maxlength="$maxuser">
</td><Td align="right"><font color="#000080" size="2" face="Verdana, Arail">
Title:</td><td><font color="#000080" size="2" face="Verdana, Arail">
<input type="radio" value="Mr." name="sex">Mr. 
<input type="radio" value="Mrs." name="sex">Mrs. 
<input type="radio" value="Ms." name="sex">Ms. 
</td></TR>
<TR><TD align="right"><font color="#000080" size="2" face="Verdana, Arail">
Password:</td><TD>
<input type="password" size="15" name="passwd" maxlength="$maxpass">
</td><Td align="right"><font color="#000080" size="2" face="Verdana, Arail">
First:</td><td>
<input type="text" size="15" name="first">
</td></TR>
<TR><TD align="right">
<font color="#000080" size="2" face="Verdana, Arail">
Confirm:</td><TD>
<input type="password" size="15" name="confirm" maxlength="$maxpass">
</td><Td align="right"><font color="#000080" size="2" face="Verdana, Arail">
Last:</td><td>
<input type="text" size="15" name="last">
</td></TR>
<TR><TD align="right"><input type="submit"
        name="Submit" value="Add User"></td><TD>
<input type="reset"
        name="reset" value="Start Again"></td><Td align="right">
<font color="#000080" size="2" face="Verdana, Arail">
Email:</td><td>
<input type="text" size="15" name="email">
</td></TR>
</table>
ADDFORM
$ns = "32";
&bottom;
exit 0;
}

sub editfileform {
$userid = $input{'userid'};

$title = "Edit File";
&top;
print <<EDIT;
<p align="center"><font color="#000080"
                size="3" face="Verdana, Arail"><b>Edit File</b></font></p>
                <font color="#000080" size="2"
                face="Verdana, Arail"><b>File To Edit: </b></font><select
                name="file" size="1">
                    <option>Select One 

EDIT
open(FILE,"<$filesdir/$userid/files.fls");
while($inline=<FILE>) {
($file,$date)=split(/%!%/,$inline);   
foreach $userid($userid) {
   print <<GOODL2;
<OPTION value="$file">$file
GOODL2
}
}
print <<NEW;
                    
                </select><input type="hidden" name="userid" value="$userid">
<input type="hidden" name="action" value="editfile">

                </td>
            </tr>

    <tr>
        <td align="center" valign="top"><input type="submit"
        name="submit" value="Edit This File"><input type="reset"
        name="reset" value="Start Again">
NEW
&bottom;
exit 0;
}

#Edit the file
sub editfile {
$cd = $input{'cd'};
$userid47 = $input{'userid'};
$pswd = $input{'userid'};
$userid = $input{'userid'};
$file = $input{'file'};
$userid = $input{'userid'};
if ($file eq "" || $file eq "Select One" || $file eq "SELECT ONE") {
$errortitle = "Select A File";
$headline = "Select A File";
$text = "Please go back and select a file to edit.";
&error;
exit 0;
}
if ($cd eq "") {
if(!-e "$usrdir/$file") {

print "file does not exist";
exit 0;
}
else {

open(ChHECK, "$usrdir/$file");	
@ffat = <ChHECK>;
close (ChHECK);

   print "Content-type: text/html\n\n";
&top;
    print <<END7;
<INPUT name="file" type="hidden" value="$file">
<INPUT name="userid" type="hidden" value="$userid">                
<p><textarea name="text" rows="30" cols="90">
@ffat
</textarea>
                <br>
                <input type="submit"
        name="action" value="Save File"><input type="reset"
        name="reset" value="Start Again">
END7
&bottom;
close(FILEERRE);
}
exit 0;
}
else {
if(!-e "$usrdir$cd/$file") {

print "file does not exist";
exit 0;
}
else {

open(CHhECK, "$usrdir$cd/$file");	
@fffat = <CHhECK>;
close (CHhECK);
   print "Content-type: text/html\n\n";
&top;
$ncd = $cd;
if ($ncd eq "\/"){
$ncd = "";
}
    print <<END7;
<INPUT name="file" type="hidden" value="$ncd/$file">
<INPUT name="userid" type="hidden" value="$userid">                
<p><textarea name="text" rows="30" cols="90">
END7
#foreach $lnk (@fffat){
#if ($ln =~ /^ /) {
#$nfilee = $ln;
#@lett = split(//,$nfilee);
#foreach $lett (@lett) {
#if ($lett eq " " && $nee eq "0") {
#$nff .= $lett;
#$nee eq "1";
#}else {
#if ($lett eq " ") {
#}else {
#$nff .= $lett;
#}}}}else {
#print "$lnk";
#$nff = "";
#}
#}
foreach $lnk (@fffat) {
chop $lnk;
chomp $lnk;

print "$lnk";
}
print <<END7;
</textarea>
                <br>
                <input type="submit"
        name="action" value="Save File"><input type="reset"
        name="reset" value="Start Again">
END7
&bottom;
close(FILEERRE);
}
exit 0;
}} 

#Save the file
sub savefile {
#$text = $input{'text'};
$userid = $input{'userid'};
$pswd = $input{'userid'};
$file = $input{'file'}; 
@TEXTc = $input{'text'};
open(CHECK, "$passfile");	
	while(<CHECK>) {
	@all = split(/\n/);
	foreach $line (@all) {
	($userid2, $loginpass, $sus, $disks) = split(/\:\:/, $line);
	if($userid2 eq "$userid") {
$ds = $disks;
}}}
$file2 = $file;
$file2 .= "2";
#foreach $ln (@TEXT){
##if ($ln =~ /^ /) {
#$nfilee = $ln;
#@lett = split(//,$nfilee);
#foreach $lett (@lett) {
#if ($lett eq " " && $nee eq "0") {
#$nff .= $lett;
#$nee eq "1";
#}else {
#if ($lett eq " ") {

##}else {
#$nff .= $lett;
#}}}}}


#$TEXT = $nff;
open(FILE,"> $usrdir/$file2");
foreach $lnk (@TEXTc){
print FILE "$lnk";
$nff = "";
#}
}

close(FILE);
   $fullfilee = "$usrdir/$file2";
        ($fsds, $filedate, $fileperm) = (stat("$usrdir/$file2"))[7,9,2];
unlink("$usrdir/$file2");
&ds;
 $free = $ds - $used;
        $fullfilel = "$usrdir/$file";
        ($fss, $filedate, $fileperm) = (stat($fullfilel))[7,9,2];
$ffs = $free + $fss;
#
#print "Alloted: $ds<BR>Used: $used<BR>Used - filesize:<BR>";
#print "Free Space: $free<BR>Free + file: $ffs<BR>File Is: $fsds<BR>and $fss<BR>";
#exit 0;

$free = $free + $fs;
if ($free eq "" || $free eq "0" || $free =~ "\-") {
$free = "0";
}

if ($ds ne "0") {
$len = length("$TEXT");
if ($ds eq "0") {
$ds = "Unlimited";
$free = "Unlimited";
}


if ($fsds >= $ffs) {

print "Sorry, not enough disk space to save this file. Please make it smaller. The new file will be $fsds bytes and you only have $ffs free.<BR>";

exit 0;
} 

}
@TEXTc;
open(FILE,"> $usrdir/$nf/$file");
foreach $lnk (@TEXTc){
print FILE "$lnk\n";
$nff = "";
#}
}
close(FILE);
$errortitle = "Save Successful";
$headline = "Save Successful";
$text = "$file was successfully edited and saved.";
&error;
exit 0;
}

#Form to create a new file
sub newfileform {
$userid = $input{'userid'};
$cd = $input{'cd'};

&top;
print "Filename: <input type=\"text\" name=\"file\"><BR>\n";
print "<textarea name=\"text\" rows=30 cols=90></textarea>\n";
print "<input type=\"hidden\" name=\"action\" value=\"save\">\n";
print "<input type=\"hidden\" name=\"cd\" value=\"$cd\">\n";
print "<input type=\"hidden\" name=\"userid\" value=\"$userid\">\n";
print "<input type=\"submit\" name=\"submit\" value=\"Save File\">\n";
&bottom;
exit 0;
}
sub save {
$filename = $input{'file'};
$userid = $input{'userid'};
@data = $input{'text'};
$cd = $input{'cd'};

if ($cd eq "/") {
$cd = "";
}
if (-e "$usrdir$cd/$filename") {
$errortitle = "$filename Exists";
$headline = "$filename Exists";
$text = "$filename already exists!";
&error;
exit 0;
}
&ext($filename);
open(CHECK, "$passfile");	
	while(<CHECK>) {
	@all = split(/\n/);
	foreach $line (@all) {
	($userid2, $loginpass, $sus, $disks) = split(/\:\:/, $line);
	if($userid2 eq "$userid") {
$ds = $disks;
}}}
$file2 = $filename;
$file2 .= "2";
open(FILE,"> $usrdir$cd/$filename");
foreach $lnk (@data){
print FILE "$lnk";
$nff = "";
#}
}
close(FILE);
   $fullfilee = "$usrdir$cd/$file2";
        ($fsds, $filedate, $fileperm) = (stat("$usrdir$cd/$filename"))[7,9,2];
unlink("$usrdir$cd/$filename");
&ds;
 $free = $ds - $used;

#
#print "Alloted: $ds<BR>Used: $used<BR>Used - filesize:<BR>";
#print "Free Space: $free<BR>Free + file: $ffs<BR>File Is: $fsds<BR>and $fss<BR>";
#exit 0;

if ($free eq "" || $free eq "0" || $free =~ "\-") {
$free = "0";
}

if ($ds ne "0") {
$len = length("$TEXT");
if ($ds eq "0") {
$ds = "Unlimited";
$free = "Unlimited";
}


if ($fsds >= $free) {

print "Sorry, not enough disk space to save this file. Please make it smaller. File will be: $fsds free: $free<BR>";

exit 0;
} }

open (FILEY, ">$usrdir$cd/$filename");
open(FILE,"> $usrdir$cd/$filename");
foreach $lnk (@data){
print FILEY "$lnk";
$nff = "";
#}
}
close (FILEY);
$errortitle="$filename Created";
$headline = "$filename Was Created";
$text = "$filename was created.";
&error;
exit 0;
}
#Add the user

sub addnow {
$userid = $input{'userid'};
$passwd = $input{'passwd'};
$confirm = $input{'confirm'};
$html = $input{'html'};
$type = $input{'status'};
if ($userid eq "") {
$errortitle="Empty Field";
$headline = "Empty Field";
$text = "Please enter a userid.";
&error;
exit 0;
}
if ($passwd eq "") {
$errortitle="Empty Field";
$headline = "Empty Field";
$text = "Please enter a password.";
&error;
exit 0;
}
if ($confirm eq "") {
$errortitle="Empty Field";
$headline = "Empty Field";
$text = "Please confirm your password.";
&error;
exit 0;
}
if ($confirm ne "$passwd") {
$errortitle="Passwords Don't Match";
$headline = "Passwords Don't Match";
$text = "Your passwords don't match.";
&error;
exit 0;
}
if ($input{'email'} eq "" || $input{'first'} eq "" || $input{'last'} eq "" || $input{'sex'} eq "") {
$errortitle="Empty Field";
$headline = "Empty Field";
$text = "Please go back and fill in all the fields.";
&error;
exit 0;
}
if ($input{'email'} !=~ "\@"){
$errortitle="Email Address"; 
$headline = "Invalid Email Address";
$text ="Please go back and enter a valid email address.";
&error;
exit 0;}
$lconfirm = length("$confirm");
$pass = length("$passwd");
if ($pass >= "$minpass" || $pass eq "$minpass" || $lconfirm >= "$minpass" || $lconfirm eq "$minpass") {
}
else { 

&top;
print "Your password is too short.";
$ns="32";
&bottom;
exit 0;
}

$luserid = length("$userid");
if ($luserid >= "$minuser" || $luserid eq "$minuser") {
}
else { 

&top;
print "Your username is too short.";
$ns="32";
&bottom;
exit 0;
}

if ($userid =~ " ") {

&top;
print "Usernames can't have spaces in them.";
$ns="32";
&bottom;
exit 0;
}
if ($type eq "") {
$type = "user";
}
open(DBL, "$passfile");	
while(<DBL>) {
	chop;		
	@all = split(/\n/);
	foreach $line2 (@all) {
        ($loginname, $loginpass, $status2, $html2) = split(/\:\:/, $line2);
if($userid eq $loginname) {
$errortitle="Username is in use";
$headline = "That username is already in use";
$text = "Sorry, that username is already in use.";
&error;
exit 0;
}
}
}
mkdir("$nusrdir/$userid",0777);

    # Define arrays for the day of the week and month of the year.           #
    @days   = ('Sunday','Monday','Tuesday','Wednesday',
               'Thursday','Friday','Saturday');
    @months = ('January','February','March','April','May','June','July',
	         'August','September','October','November','December');

    # Get the current time and format the hour, minutes and seconds.  Add    #
    # 1900 to the year to get the full 4 digit year.                         #
    ($sec,$min,$hour,$mday,$mon,$year,$wday) = (localtime(time))[0,1,2,3,4,5,6];
    $time = sprintf("%02d:%02d:%02d",$hour,$min,$sec);
    $year += 1900;

    # Format the date.                                                       #
    $date = "$days[$wday], $months[$mon] $mday, $year";

$html = "yes"; 
$changepaass = $nchangepass;
$sus = "no";
$first = $input{'first'};
$last = $input{'last'};
$sex = $input{'sex'};
$email = $input{'email'};
$expire = "$nnexpire";
$vlogon = "$nvalid";
$next = $nfext;
$maxfiles = $nmaxfiles;
$maxdirs = $nmaxdirs;
$log = $nlog;
$header = $nheader;
$footer = $nfooter;
$confirm = crypt($input{'confirm'},time);
$pswd = $input{'passwd'};
open(PASSWTE,">>$passfile");
print PASSWTE "$userid\:\:$confirm\:\:$sus\:\:$diskspace\:\:$first\:\:$last\:\:$email\:\:$sex\:\:$expire\:\:$vlogon\:\:$next\:\:$maxfiles\:\:$maxdirs\:\:$log\:\:$header\:\:$footer\:\:$nusrdir/$userid\:\:$nuserurl/$userid\:\:$nchangepass\n";
close(PASSWTE);
srand;
$tota = "10";
$rpas1 = int(rand($tota));
$rpas2 = int(rand($tota));
$rpas3 = int(rand($tota));
$rpas4 = int(rand($tota));
$rpas5 = int(rand($tota));
$rpas6 = int(rand($tota));
$rpas7 = int(rand($tota));
$act = "$rpas1$rpas2$rpas3$rpas4$rpas5$rpas6$rpas7";

$errortitle="$userid Was Added";
$headline = "$userid Was Added";
$text = "$userid has been created. Click <a href=manage.pl>here</a> to log in.";
$mailprog = "/usr/lib/sendmail";
open(MAIL,"|$mailprog -t");
print MAIL "To: $email\n";
print MAIL "From: $femail\n";
print MAIL "Subject: Your New Account!\n";
print MAIL "Dear $sex $last\n\n";
print MAIL "  You have recently signed up for your website at <a href=\"$giveawayurl\">$giveawayhome.<\/a>";
#print MAIL "In order to activate your account, you must goto: <a href=\"$cgi_script?action=activate&userid=$userid\">$cgi_script?action=activate&userid=$userid</a>\n\n";
#print MAIL "\nYour activation code is: $act\n\n";
print MAIL "\*\*\*\*\*\*\* ACCOUNT INFO \*\*\*\*\*\*\*\n";
print MAIL "Name: $sex $first $last\n";
print MAIL "Email: $email\n";
print MAIL "Userid: $userid\n";
print MAIL "Password: $pswd\n\n
You can access your website at:
http://members.elitehosts.com/$userid/

You can logon and manage your account at:
http://members.elitehosts.com/manage.pl
";
#open(PASSWTEe,">>inactive");
#print PASSWTEe "$userid\*\*$act\n";
#close(PASSWTEe);
&error;
exit 0;
}

#ERROR
sub error {
unless ($nsd eq "2") {


$title = "$errortitle";
&top;
}
print <<ERR;
<div align="center"><center><table
        border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td><p align="center"><font color="#000080"
                size="3" face="Verdana, Arail"><b>$headline</b></font></p>
                <p align="left"><font color="#000080" size="2" face="Verdana, Arail"><b>$text</b></font></p>
                </td>
            </tr>
        </table>
        </center></div>

ERR
&bottom;
}

#Change password form
sub changepasswordform {

&top;
print <<CPF;
<center><table border="0"
                cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td align="center" valign="top"
                        colspan="2" width="50%"><font
                        color="#000080" size="3"
                        face="Verdana, Arail"><b>Change Users
                        Password</b></font></td>
                    </tr>
                    <tr>
                        <td><font color="#000080" size="1"
                        face="Verdana, Arail"><b>UserID:</b></font><select
                        name="userid">
                            <option>Select One
CPF
open(FILE,"<$passfile");
while($inline=<FILE>) {
($userid,$date)=split(/\:\:/,$inline);   
foreach $userid($userid) {
unless ($userid eq "Select One") {
   print "<OPTION>$userid";
}
}
}
print <<CPF2;
                        </select></td>
                        <td><font color="#000080" size="1"
                        face="Verdana, Arail"><b>New Password:</b></font><input
                        type="password" size="15" name="new"></td>
                    </tr>
                    <tr>
                        <td width="50%"><font color="#000080"
                        size="1" face="Verdana, Arail"><b>Override
                        Password:</b></font><input
                        type="password" size="15"
                        name="override"></td>
                        <td width="50%"><font color="#000080"
                        size="1" face="Verdana, Arail"><b>Confirm
                        Password:</b></font><input
                        type="password" size="15" name="confirm"></td>
                    </tr>
<TR><TD><input type="submit" name="action" value="Change Users Password"></td></tr>

                </table>
               
CPF2
&bottom;
exit 0;
}

# Delete User Form
sub deleteuser {

&top;
print <<DUSER;
<center><font color="#000080"
                    size="3" face="Verdana, Arail"><b>Delete User</CENTER></b></font>
                    <font color="#000080" size="2"
                    face="Verdana, Arail"><b>UserID: <input type="text" name="userid">
<BR>
Password: <input type="password" name="pass"><BR>
DUSER


print <<DUSER2;
                <input type="hidden" name="action" value="delnow"> 
      <input type="submit"
            name="submit1" value="Delete User"><input
           type="reset" name="reset" value="Start Again">
DUSER2
$ns = "32";
&bottom;
exit 0;
}
sub deluser {
$useridd = $input{'userid'};
$pass = $input{'pass'};
if ($useridd eq "" || $pass eq "" || $useridd eq "Select One" || $useridd eq "select one" || $useridd eq "SELECT ONE") {
$errortitle = "Required Fields";
$headline = "You Missed Something";
$text ="You did not fill in all the fields!";
&error;
exit 0;
}
$pass = crypt($input{'pass'},time);
open(LIST,"$passfile" || &error('Could not open list file.'));
@logs = <LIST>;
close(LIST);
open(LIST,"$passfile" || &error('Could not open list file.'));
foreach $i (@logs) {
@userd = split(/\:\:/,$i);
if (@userd[0] eq "$useridd" && @userd[1] eq "$pass") {
$match = "1";
}
if (@userd[0] eq "$useridd" && $pass eq "$adminpass") {
$match = "1";
}
}

if ($match ne "1") {
$errortitle = "Delete User Failed";
$headline = "Delete Aborted";
$text = "You have entered a wrong userid and/or password.";
&error;
exit 0;
}
open(LIST,"$passfile" || &error('Could not open list file.'));
@logs = <LIST>;
close(LIST);
open(LIST,">$passfile" || &error('Could not open list file.'));
foreach $i (@logs) {
	@userd = split(/\:\:/,$i);
	unless($userd[0] eq $input{'userid'}) {
		print LIST $i;
}}$errortitle = "Delete User";
$headline = "Delete OK";
$text = "$useridd was successfully deleted.";
$ns = "32";
&error;
exit 0;
}
# Change a users password
sub changeupassword {
$userid = $input{'userid'};
$new = $input{'new'};
$confirm = $input{'confirm'};
$overridep = $input{'override'};

if ($new eq "" || $confirm eq "" || $overridep eq "" || $userid eq "") {
$errortitle = "Error";
$headline = "Fill In";
$text = "Please fill in all the fields";
&error;
exit 0;
}
if ($new eq "Select One" || $new eq "SELECT ONE") {
$errortitle = "Error";
$headline = "Fill In";
$text = "Please select a userID.";
&error;
exit 0;
}
if ($new ne "$confirm") {
$errortitle = "Error";
$headline = "Fill In";
$text = "Your passwords don't match.";
&error;
exit 0;
}


if ($overridep ne "$adminpass") {
$errortitle = "Error";
$headline = "Admin Override";
$text = "The admin override password you entered is incorrect.";
&error;
exit 0;
}
open(CHECK, "$passfile");	

	while(<CHECK>) {

	@all = split(/\n/);

	foreach $line (@all) {

	($loginname1, $loginpass, $type, $html) = split(/\:\:/, $line);

	if($loginname1 eq "$userid") {


open(DATA,"$passfile")|| &ERROR("CANT OPEN1");
   @lines = <DATA>;
close(DATA);

open(DATA,">$passfile") || &ERROR("CANT OPEN2");
	  foreach $line (@lines)
	  {
	  	($loginname, $password, $type, $html, $sus, $swk) = split(/\:\:/,$line);
	  	if ($userid eq $loginname) 
		  {

		 	print DATA ("$userid::$confirm::$type::$html::$sus::$swk");


		  	  }
	      else 
	  	  {
			print DATA $line;
	  	  }

	  }
close(DATA);
$errortitle = "Change OK";
$headline = "Change OK";
$text = "Your password was changed as requested.";
&error;
exit 0;
}}}}

sub upload {
       if ($ENV{'HTTP_REFERER'} =~ "$referer" || 
$referer =~ $ENV{'HTTP_REFERER'} ||
 $ENV{'HTTP_REFERER'} eq "$referer") {
    }else {
&top;
print "You can't call this script from: $ENV{'HTTP_REFERER'}<BR>It must be called from: $referer";
&bottom;
exit 0;
    }
# When writing files, several options can be set... here we just set one
# Limit upload size to avoid using too much memory
open(DATA,"$passfile") || &ERROR("CANT OPEN2");
	  foreach $line (@lines)
	  {
	  	($loginname, $password, $sus, $swk) = split(/\:\:/,$line);
if ($uid eq "$loginname") {
$cgi_lib'maxdata = $swk; 
}}
# Start off by reading and parsing the data.  Save the return value.
# We could also save the file's name and content type, but we don't
# do that in this example.
$ret = &ReadParse;

open(PS, "$passfile");
@fl = <PS>;
foreach $ent (@fl) {
($suserid, $pass, $stat, $disk, $first, $last, ,$email, $sex, $expire, $vlogon, $ext, $maxfiles, $maxdirs, $log, $header, $footer, $homedir, $homeurl, $changepass) = split(/\:\:/,$ent);
if ($suserid eq "$in{'userid'}") {
$usrdir = $homedir;
}}close (PS);

#print "contenet-type:text/html\n\n";
#print "here: $usrdir";
#exit 0;
# A bit of error checking never hurt anyone
&CgiDie("Error in reading and parsing of CGI input") if !defined $ret;
&CgiDie("No data uploaded",
	"Please enter it in <a href='fup.html'>fup.html</a>.") if !$ret;


# Munge the uploaded text so that it doesn't contain HTML elements
# This munging isn't complete -- lots of illegal characters are left as-is.
# However, it takes care of the most common culprits.  
#$in{'upfile1'} =~ s/</&lt;/g;
#$in{'upfile1'} =~ s/>/&gt;/g;
#$in{'upfile2'} =~ s/</&lt;/g;
#$in{'upfile2'} =~ s/>/&gt;/g;
#$in{'upfile3'} =~ s/</&lt;/g;
#$in{'upfile3'} =~ s/>/&gt;/g;
#$in{'upfile4'} =~ s/</&lt;/g;
#$in{'upfile4'} =~ s/>/&gt;/g;


$uid = $in{'userid'};
# Now produce the result: an HTML page...
print &PrintHeader;
&top;
$userid = $uid;
if ($incfn{'upfile1'} eq "" && $incfn{'upfile2'} eq "" && $incfn{'upfile3'} eq "" 
&& $incfn{'upfile4'} eq "") { 
print "Please enter a file to upload.";
&bottom;
exit 0;
}
if ($incfn{'upfile1'} ne "") {
unless ($incfn{'upfile1'} =~ /.htm$/ || $incfn{'upfile1'} =~ /.html$/ 
|| $incfn{'upfile1'} =~ /.gif$/ || $incfn{'upfile1'} =~ /.jpg$/ 
|| $incfn{'upfile1'} =~ /.mpeg$/ ||$incfn{'upfile1'} =~ /.bmp$/ ||
$incfn{'upfile1'} =~ /.wav$/ || $incfn{'upfile1'} =~ /.mid$/ || 
$incfn{'upfile1'} =~ /.mov$/ ||
$incfn{'upfile1'} =~ /.txt$/
)
 {
print "The file that you are uploading has an invalid extention.";
&bottom;
exit 0;
}
if ($incfn{'upfile1'} =~ "\/"
 || $incfn{'upfile1'} =~ /^\//
){
$nsd = "2";
$errortitle = "Extention Check";
$headline = "Extention Check";
$text = "Please enter a valid file name.";
&error;
exit 0;

}
}
if ($incfn{'upfile2'} ne "") {
unless ($incfn{'upfile2'} =~
 /.htm$/ || $incfn{'upfile2'} =~ /.html$/ 
|| $incfn{'upfile2'} =~ /.gif$/ || $incfn{'upfile2'} =~ /.jpg$/ 
|| $incfn{'upfile2'} =~ /.mpeg$/ ||$incfn{'upfile2'} =~ /.bmp$/ ||
$incfn{'upfile2'} =~ /.wav$/ || $incfn{'upfile2'} =~ /.mid$/ || 
$incfn{'upfile2'} =~ /.mov$/ ||
$incfn{'upfile2'} =~ /.txt$/
|| $incfn{'upfile2'} =~ "\/"
|| $incfn{'upfile2'} =~ "\.\." || $incfn{'upfile2'} =~ /^../  || $incfn{'upfile2'} =~ /^\//

) {
print "The file that you are uploading has an invalid extention.";
&bottom;
exit  0;
}
if ($incfn{'upfile2'} =~ "\/"
|| $incfn{'upfile2'} =~ /^\//
){
$nsd = "2";
$errortitle = "Extention Check";
$headline = "Extention Check";
$text = "Please enter a valid file name.";
&error;
exit 0;

}
}
 
if ($incfn{'upfile3'} ne "") {
unless ($incfn{'upfile3'} =~ /.htm$/ || $incfn{'upfile3'} =~ /.html$/ 
|| $incfn{'upfile3'} =~ /.gif$/ || $incfn{'upfile3'} =~ /.jpg$/ 
|| $incfn{'upfile3'} =~ /.mpeg$/ ||$incfn{'upfile3'} =~ /.bmp$/ ||
$incfn{'upfile3'} =~ /.wav$/ || $incfn{'upfile3'} =~ /.mid$/ || 
$incfn{'upfile3'} =~ /.mov$/ ||
$incfn{'upfile3'} =~ /.txt$/
|| $incfn{'upfile3'} =~ "\/"
|| $incfn{'upfile3'} =~ /^\//

) {
print "The file that you are uploading has an invalid extention.";
&bottom;
exit 0; 
}
if ($incfn{'upfile3'} =~ "\/"
|| $incfn{'upfile3'} =~ /^\//
){
$nsd = "2";
$errortitle = "Extention Check";
$headline = "Extention Check";
$text = "Please enter a valid file name.";
&error;
exit 0;

}
}
if ($incfn{'upfile4'} ne "") {
unless ($incfn{'upfile4'} =~ /.htm$/ || $incfn{'upfile4'} =~ /.html$/ 
|| $incfn{'upfile4'} =~ /.gif$/ || $incfn{'upfile4'} =~ /.jpg$/ 
|| $incfn{'upfile4'} =~ /.mpeg$/ ||$incfn{'upfile4'} =~ /.bmp$/ ||
$incfn{'upfile4'} =~ /.wav$/ || $incfn{'upfile4'} =~ /.mid$/ || 
$incfn{'upfile4'} =~ /.mov$/ ||
$incfn{'upfile4'} =~ /.txt$/ ||
$incfn{'upfile4'} =~ "\/"
|| $incfn{'upfile4'} =~ "\.\." || $incfn{'upfile4'} =~ /^../  || $incfn{'upfile4'} =~ /^\//

 
) {
print "The file that you are uploading has an invalid extention.";
&bottom;
exit 0;
}if ($incfn{'upfile4'} =~ "\/"
  || $incfn{'upfile4'} =~ /^\//
){
$nsd = "2";
$errortitle = "Extention Check";
$headline = "Extention Check";
$text = "Please enter a valid file name.";
&error;
exit 0;

}}
if ($incfn{'upfile1'} ne "") {
open(CHECK, "$passfile");	
	while(<CHECK>) {
	@all = split(/\n/);
	foreach $line (@all) {
	($userid2, $loginpass, $sus, $disks) = split(/\:\:/, $line);
	if($userid2 eq "$userid") {
$ds = $disks;
#print "$ds<BR>";
}}}
$cd = $in{'cd'};
unless ($cd eq "/") {
unless ($cd =~ /\/$/) {
$cd .=  "/";
}
}
$fn = $incfn{'upfile1'};
$fn =~ s/\\/:::/g;
$fn =~ s/\//:::/g;
@fn = split(/\:\:\:/, $fn);
foreach $p (@fn) {
$fc = $fc + 1;
}
#   $usrdir$cd$pn
$fnn = $incfn{'upfile1'};
@fnn = split(/\\/, $fnn);
foreach $pn (@fnn) {
$cf = $cf+1;
if ($cf eq "$fc") {
$filename = $pn;
}}

$file2 .= "2";
open(FILE,"> $usrdir$cd$filename");
  print FILE "$in{'upfile1'}";
close(FILE);
   $fullfilee = "$usrdir$cd$filename";
        ($fsds, $filedate, $fileperm) = (stat("$usrdir$cd$filename"))[7,9,2];
unlink("$usrdir$cd$filename");
&ds;
 $free = $ds - $used;
#print "$fsds ok?";
#print "DUDE: $usrdir/$userid$cd$filename";
#
#print "Alloted: $ds<BR>Used: $used<BR>Used - filesize:<BR>";
#print "Free Space: $free<BR>Free + file: $ffs<BR>File Is: $fsds<BR>and $fss<BR>USERID:$userid<BR>
#Filename: $filename: $dir $usrdir$cd$filename<BR>";

if ($free eq "" || $free eq "0" || $free =~ "\-") {
$free = "0";
}

if ($ds ne "0" || $ds eq "Unlimited" || $free eq "Unlimited") {
$len = length("$TEXT");
if ($ds eq "0") {
$ds = "Unlimited";
$free = "Unlimited";
}
if ($fsds >= $free) {

print "Sorry, not enough disk space to save your uploads. Please make it smaller.";

exit 0;
} }
}
#############################
if ($incfn{'upfile2'} ne "") {
open(CHECK, "$passfile");	
	while(<CHECK>) {
	@all = split(/\n/);
	foreach $line (@all) {
	($userid2, $loginpass ,$sus, $disks) = split(/\:\:/, $line);
	if($userid2 eq "$userid") {
$ds = $disks;
}}}
$cd = $in{'cd'};
unless ($cd eq "/") {
unless ($cd =~ /\/$/) {
$cd .=  "/";
}
}
$fn = $incfn{'upfile2'};
$fn =~ s/\\/:::/g;
$fn =~ s/\//:::/g;
@fn = split(/\:\:\:/, $fn);
foreach $p (@fn) {
$fc = $fc + 1;
}
#   $usrdir$cd$pn
$fnn = $incfn{'upfile2'};
@fnn = split(/\\/, $fnn);
foreach $pn (@fnn) {
$cf = $cf+1;
if ($cf eq "$fc") {
$filename = $pn;
}}

$file2 .= "2";
open(FILE,"> $usrdir$cd$filename");
  print FILE "$in{'upfile2'}";
close(FILE);
   $fullfilee = "$usrdir$cd$filename";
        ($fsds, $filedate, $fileperm) = (stat("$usrdir$cd$filename"))[7,9,2];
unlink("$usrdir$cd$filename");
&ds;
 $free = $ds - $used;
#print "$fsds ok?";
#print "DUDE: $usrdir/$userid$cd$filename";
#
#print "Alloted: $ds<BR>Used: $used<BR>Used - filesize:<BR>";
#print "Free Space: $free<BR>Free + file: $ffs<BR>File Is: $fsds<BR>and $fss<BR>USERID:$userid<BR>
#Filename: $filename: $dir $usrdir/$userid$cd$filename<BR>";

if ($free eq "" || $free eq "0" || $free =~ "\-") {
$free = "0";
}

if ($ds ne "0") {
$len = length("$TEXT");


if ($ds eq "0") {
$ds = "Unlimited";
$free = "Unlimited";
}
if ($fsds >= $free) {

print "Sorry, not enough disk space to save your uploads. Please make it smaller.";

exit 0;
} }
}
#############################
if ($incfn{'upfile3'} ne "") {
open(CHECK, "$passfile");	
	while(<CHECK>) {
	@all = split(/\n/);
	foreach $line (@all) {
	($userid2, $loginpass, $sus, $disks) = split(/\:\:/, $line);
	if($userid2 eq "$userid") {
$ds = $disks;
}}}
$cd = $in{'cd'};
unless ($cd eq "/") {
unless ($cd =~ /\/$/) {
$cd .=  "/";
}
}
$fn = $incfn{'upfile3'};
$fn =~ s/\\/:::/g;
$fn =~ s/\//:::/g;
@fn = split(/\:\:\:/, $fn);
foreach $p (@fn) {
$fc = $fc + 1;
}
#   $usrdir$cd$pn
$fnn = $incfn{'upfile3'};
@fnn = split(/\\/, $fnn);
foreach $pn (@fnn) {
$cf = $cf+1;
if ($cf eq "$fc") {
$filename = $pn;
}}

$file2 .= "2";
open(FILE,"> $usrdir$cd$filename");
  print FILE "$in{'upfile3'}";
close(FILE);
   $fullfilee = "$usrdir$cd$filename";
        ($fsds, $filedate, $fileperm) = (stat("$usrdir$cd$filename"))[7,9,2];
unlink("$usrdir$cd$filename");
&ds;
 $free = $ds - $used;
#print "$fsds ok?";
#print "DUDE: $usrdir/$userid$cd$filename";
#
#print "Alloted: $ds<BR>Used: $used<BR>Used - filesize:<BR>";
#print "Free Space: $free<BR>Free + file: $ffs<BR>File Is: $fsds<BR>and $fss<BR>USERID:$userid<BR>
#Filename: $filename: $dir $usrdir/$userid$cd$filename<BR>";

if ($free eq "" || $free eq "0" || $free =~ "\-") {
$free = "0";
}
if ($ds ne "0") {
$len = length("$TEXT");



if ($ds eq "0") {
$ds = "Unlimited";
$free = "Unlimited";
}

if ($fsds >= $free) {

print "Sorry, not enough disk space to save your uploads. Please make it smaller.";

exit 0;
} }
}
#############################
if ($incfn{'upfile4'} ne "") {
open(CHECK, "$passfile");	
	while(<CHECK>) {
	@all = split(/\n/);
	foreach $line (@all) {
	($userid2, $loginpass, $sus, $disks) = split(/\:\:/, $line);
	if($userid2 eq "$userid") {
$ds = $disks;
}}}
$cd = $in{'cd'};
unless ($cd eq "/") {
unless ($cd =~ /\/$/) {
$cd .=  "/";
}
}
$fn = $incfn{'upfile4'};
$fn =~ s/\\/:::/g;
$fn =~ s/\//:::/g;
@fn = split(/\:\:\:/, $fn);
foreach $p (@fn) {
$fc = $fc + 1;
}
#   $usrdir/$uid$cd$pn
$fnn = $incfn{'upfile4'};
@fnn = split(/\\/, $fnn);
foreach $pn (@fnn) {
$cf = $cf+4;
if ($cf eq "$fc") {
$filename = $pn;
}}

$file2 .= "2";
open(FILE,"> $usrdir$cd$filename");
  print FILE "$in{'upfile4'}";
close(FILE);
   $fullfilee = "$usrdir$cd$filename";
        ($fsds, $filedate, $fileperm) = (stat("$usrdir$cd$filename"))[7,9,2];
unlink("$usrdir$cd$filename");
&ds;
 $free = $ds - $used;
#print "$fsds ok?";
#print "DUDE: $usrdir/$userid$cd$filename";
#
#print "Alloted: $ds<BR>Used: $used<BR>Used - filesize:<BR>";
#print "Free Space: $free<BR>Free + file: $ffs<BR>File Is: $fsds<BR>and $fss<BR>USERID:$userid<BR>
#Filename: $filename: $dir $usrdir/$userid$cd$filename<BR>";

if ($free eq "" || $free eq "0" || $free =~ "\-") {
$free = "0";
}
if ($ds ne "0") {
$len = length("$TEXT");


if ($ds eq "0") {
$ds = "Unlimited";
$free = "Unlimited";
}
if ($fsds >= $free) {

print "Sorry, not enough disk space to save your uploads. Please make it smaller.";

exit 0;
} }
}
#############################
print "The following files have been uploaded:<BR>";
$cd = $in{'cd'};
unless ($cd eq "/") {
unless ($cd =~ /\/$/) {
$cd .=  "/";
}
}
$cf = 0;
$fc = 0;
$fn = $incfn{'upfile1'};
$fn =~ s/\\/:::/g;
$fn =~ s/\//:::/g;
@fn = split(/\:\:\:/, $fn);
foreach $p (@fn) {
$fc = $fc + 1;
}
#   $usrdir$cd$pn
$fnn = $incfn{'upfile1'};
@fnn = split(/\\/, $fnn);
foreach $pn (@fnn) {
$cf = $cf+1;

if ($cf eq "$fc") {

unless ($fn eq "" || $fn eq " " || $cf eq "0") {

print "$cd$pn<BR>";
open (Nf1, ">$usrdir$cd$pn");
print Nf1 "$in{'upfile1'}";
close (Nf1);
}}}

$fn = $incfn{'upfile2'};
$fn =~ s/\\/:::/g;
$fn =~ s/\//:::/g;
@fn = split(/\:\:\:/, $fn);
foreach $p (@fn) {
$fc = $fc + 1;
}
$fnn = $incfn{'upfile2'};
@fnn = split(/\\/, $fnn);
foreach $pn (@fnn) {
$cf = $cf+1;
if ($cf eq "$fc") {
unless ($fn eq "" || $fn eq " " || $cf eq "0") {
print "$cd$pn<BR>";
open (Nf1, ">$usrdir$cd$pn");
print Nf1 "$in{'upfile2'}";
close (Nf1);
}}}

$fn = $incfn{'upfile3'};
$fn =~ s/\\/:::/g;
$fn =~ s/\//:::/g;
@fn = split(/\:\:\:/, $fn);
foreach $p (@fn) {
$fc = $fc + 1;
}
$fnn = $incfn{'upfile3'};
@fnn = split(/\\/, $fnn);
foreach $pn (@fnn) {
$cf = $cf+1;
if ($cf eq "$fc") {
unless ($fn eq "" || $fn eq " " || $cf eq "0") {
print "$cd$pn<BR>";
open (Nf1, ">$usrdir$cd$pn");
print Nf1 "$in{'upfile3'}";
close (Nf1);
}
}}


$fn = $incfn{'upfile4'};
$fn =~ s/\\/:::/g;
$fn =~ s/\//:::/g;
@fn = split(/\:\:\:/, $fn);
foreach $p (@fn) {
$fc = $fc + 1;
}
$fnn = $incfn{'upfile4'};
@fnn = split(/\\/, $fnn);
foreach $pn (@fnn) {
$cf = $cf+1;
if ($cf eq "$fc") {
unless ($fn eq "" || $fn eq " " || $cf eq "0") {
open (Nf1, ">$usrdir$cd$pn");
print Nf1 "$in{'upfile4'}";
close (Nf1);
print "$cd$pn<BR>";
}
}}
print "<input type=\"hidden\" name=\"userid\" value=\"$uid\">";
&bottom;
exit 0;
}


sub ds {

$cdir = "$usrdir"; 
   opendir (DIR, "$cdir");
    my @ls = readdir(DIR);
    closedir (DIR);
 #Then go through the results of ls and work out the files.
    my (%directory, %text, %graphic);
    my ($temp_dir, $newdir, @nest, $fullfile, $filesize1, $filedate, $fileperm, $fileicon, $file);
foreach $file (@ls) {
unless ($file eq "." || $file eq "" || $file eq " " || $file eq ".."){
        $fullfile = "$cdir/$file";
        ($filesize1, $filedate, $fileperm) = (stat($fullfile))[7,9,2];
if (-d "$cdir/$file") {
$dirs= $dirs + 1;
#### START 1;


   opendir (DIR, "$cdir/$file");
    my @ls = readdir(DIR);
    closedir (DIR);
 #Then go through the results of ls and work out the files.
    my (%directory, %text, %graphic);
    my ($temp_dir, $newdir, @nest, $fullfile, $filesize2, $filedate, $fileperm, $fileicon, $file2);
foreach $file2 (@ls) {
unless ($file2 eq "." || $file2 eq "" || $file2 eq " " || $file2 eq ".."){
        $fullfile = "$cdir/$file/$file2";
        ($filesize2, $filedate, $fileperm) = (stat($fullfile))[7,9,2];
if (-d "$cdir/$file/$file2") {
$dirs= $dirs + 1;

##### START 2
   opendir (DIR, "$cdir/$file/$file2");
    my @ls = readdir(DIR);
    closedir (DIR);
 #Then go through the results of ls and work out the files.
    my (%directory, %text, %graphic);
    my ($temp_dir, $newdir, @nest, $fullfile, $filesize3, $filedate, $fileperm, $fileicon, $file3);
foreach $file3 (@ls) {
unless ($file3 eq "." || $file3 eq "" || $file3 eq " " || $file3 eq ".."){
        $fullfile = "$cdir/$file/$file2/$file3";
        ($filesize3, $filedate, $fileperm) = (stat($fullfile))[7,9,2];
if (-d "$cdir/$file/$file2/$file3") {
$dirs= $dirs + 1;
#### START 3
   opendir (DIR, "$cdir/$file/$file2/$file3");
    my @ls = readdir(DIR);
    closedir (DIR);
 #Then go through the results of ls and work out the files.
    my (%directory, %text, %graphic);
    my ($temp_dir, $newdir, @nest, $fullfile, $filesize4, $filedate, $fileperm, $fileicon, $file4);
foreach $file4 (@ls) {
unless ($file4 eq "." || $file4 eq "" || $file4 eq " " || $file4 eq ".."){
        $fullfile = "$cdir/$file/$file2/$file3/$file4";
        ($filesize4, $filedate, $fileperm) = (stat($fullfile))[7,9,2];
if (-d "$cdir/$file/$file2/$file3/$file4") {
$dirs= $dirs + 1;
######## START4

   opendir (DIR, "$cdir/$file/$file2/$file3/$file4");
    my @ls = readdir(DIR);
    closedir (DIR);
 #Then go through the results of ls and work out the files.
    my (%directory, %text, %graphic);
    my ($temp_dir, $newdir, @nest, $fullfile, $filesize5, $filedate, $fileperm, $fileicon, $file5);
foreach $file5 (@ls) {
unless ($file5 eq "." || $file5 eq "" || $file5 eq " " || $file5 eq ".."){
        $fullfile = "$cdir/$file/$file2/$file3/$file4/$file5";
        ($filesize5, $filedate, $fileperm) = (stat($fullfile))[7,9,2];
if (-d "$cdir/$file/$file2/$file3/$file4/$file5") {
$dirs= $dirs + 1;
######### START5
   opendir (DIR, "$cdir/$file/$file2/$file3/$file4/$file5");
    my @ls = readdir(DIR);
    closedir (DIR);
 #Then go through the results of ls and work out the files.
    my (%directory, %text, %graphic);
    my ($temp_dir, $newdir, @nest, $fullfile, $filesize6, $filedate, $fileperm, $fileicon, $file6);
foreach $file6 (@ls) {
unless ($file6 eq "." || $file6 eq "" || $file6 eq " " || $file6 eq ".."){
        $fullfile = "$cdir/$file/$file2/$file3/$file4/$file5/$file6";
        ($filesize6, $filedate, $fileperm) = (stat($fullfile))[7,9,2];
if (-d "$cdir/$file/$file2/$file3/$file4/$file5/$file6") {
$dirs= $dirs + 1;

sdsdf

}else {
unless ($file5 eq "") {
$used = $used + $filesize6;
$files = $files + 1;
}
1;
}}}
######### END5

1;
}else {
unless ($file5 eq "") {
$used = $used + $filesize5;
$files = $files + 1;
}
1;
}}}

######## END 4
1;
}else {
unless ($file4 eq "") {
$used = $used + $filesize4;
$files = $files + 1;
}
1;
}}}

##### END 3
1;
}else {
unless ($file3 eq "") {
$used = $used + $filesize3;
$files = $files + 1;
}
1;
}}}

##### END 2

1;
}else {
unless ($file2 eq "") {
$used = $used + $filesize2;
$files = $files + 1;
}
1;
}}}
######### END 1;

1;
}else {
unless ($file eq "") {
$used = $used + $filesize1;
$files = $files + 1;
}
1;
}
}}}


###################
sub parse_form{
 read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
  if (length($buffer) < 5) {
     $buffer = $ENV{QUERY_STRING};
  }
  @pairs=split(/&/,$buffer);
  foreach $pair(@pairs) {
     ($name, $value)=split(/=/,$pair);
     $encoded_value = $value;
     $value =~ tr/+/ /;
     $value =~ s/%([a-fA-F0-9][A-F0-9])/pack("C",hex($1))/eg;
     if($input{$name} eq "") {
	$input{$name} = $value;
	$ENCODED{$name} = $encoded_value;
        push (@Fields,$name);
     }
     else {
  	$input{$name} = $input{$name}." ".$value;
     }
  }
}


