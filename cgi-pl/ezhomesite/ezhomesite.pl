#!/usr/bin/perl
##################################################################################
# Original program was
# HomePageMaker v.1.6 written by Dave Palmer <dave@upstatepress.com>
# http://www.upstatepress.com/dave/perl.shtml
# Modified by Greg Mathews <webmaster@notts.net>.
# Further modifications:
##################################################################################
# ezhomepg - EZ Home Page Generator - by Manny Juan <manny@jps.net> 
# http://inet-images.com/manny/userpages/
##################################################################################
# ver 1.22 - 02/18/2000 - modifications by Bill Hall Compucat Software
# see end of configuration block for New Compucat Options
##################################################################################
# ver 1.30 modified by Abuzer Khan. E-mail <san_trino@yahoo.com>
# ver 1.30 - 16/5/2000 added folder creation, Editing, deleting with index page. 
# Password protection. Pop up banner window in user pages. 
# ver 1.20 - 10/8/98 added simple table creation
# ver 1.10 - 10/7/98 added deletion capability and handled un-selected graphics
# ver 1.00 - 9/25/98 changed to use same code for create/edit logic, eliminate makepage.html 
#                    also added code to remember user's clip art choices 
##################################################################################
#
# EZHomesite Modifications  ver 1.00 - 01/10/2000
# Modified by Per Kristian Johansen <pkj@internor.com>
# Creates multiple pages. The generator now creates a 5-page Homesite.
# Added option to select contrasting background color.
# Customized navigation menu. 
# Content and title different in each page.
# Option to center pages.
# Changed fontselection
###################################################################################
#
# Anyone if free to use and modify this script if the footer or the button link 
# and the credits in the script head remains as it is. Do not try to sell this script.
#
##################################################################################
# These variables need to be set
# set this to 1 if your server is running in windows 95
$win95=0;

# Set this to the HTML directory where the new pages will reside. This is a PATH not a URL
# $base_dir = "/home/yourname/ezhomesite";
# $base_dir = "../";
$base_dir="/www/yourbasedirectory/ezhomesite";

# This is your URL of this script - now you don't have to change it elsewhere
# $cgiurl = "http://your-website.com/cgi-bin/ezhomesite.pl";
# $cgiurl = "ezhomesite.pl";
# $cgiurl = "http://www.your-website.com/ezhomesite/ezhomesite.pl";
$cgiurl = "http://your-website.com/cgi-bin/ezhomesite.pl";

# This is your URL of where the new HTML pages will be kept. keep the trailing slash
# $baseurl = "http://192.193.1.94/ezhomesite/";
# $baseurl = "http://your-website.com/ezhomesite/";
$baseurl="http://your-website.com/ezhomesite/";

# this the URL of the banner page
# $banner="/ezhomesite/banner.html";
# $banner="http://www.your-website.com/ezhomesite/banner.html";
$banner="http://your-website.com/ezhomesite/banner.html";


# This is a URL and dir for the images sub directory in the ezhomesite directory.
# Create the images directory in the ezhomesite directory. This is where
# you will upload your background images
# $imageurl = "http://127.0.0.1/ezhomesite/images";
# $imagedir = "../ezhomesite/images";
$imageurl = "http://your-website.com/ezhomesite/images";
$imagedir="/www/your-website/ezhomesite/images";

#directory for the pictures
$tnp_dir_url = "$imageurl/pictures";
$tnp_dir = "$imagedir/pictures";
#directory for the lines graphics
$tn_dir_url = "$imageurl/lines";
$tn_dir = "$imagedir/lines";
#directory for the background graphics
$tnbg_dir_url = "$imageurl/backgrounds";
$tnbg_dir = "$imagedir/backgrounds";
#directory for the emailgif graphics
$tne_dir_url = "$imageurl/email";
$tne_dir = "$imagedir/email";
#directory for the bullets graphics
$tnb_dir_url = "$imageurl/bullets";
$tnb_dir = "$imagedir/bullets";

# This is the path for user pages. You don't really need to change this
# Just make sure to create a directory: ezhomesite and chmod it 777
$page_dir = "$base_dir";

# This is the index of all pages created by Member Page Generator
# This file should be chmod to 777 and placed in the ezhomesite directory
$indexpage = "$base_dir/index.html";

# This is the location of the data.txt file. This holds each user's
# login name and e-mail address for confirmation
$data = "$base_dir/data.txt";

#Site title
$title="EZHomesite";

#Yourname or Company
$yourtitle="Yourname or Company";


# self explanatory variables for your site logo
$logo = "$imageurl/header.gif";
$logoalt = "EZHomesite";

# Location of the sendmail program
$sendmail = "/usr/sbin/sendmail -t";

# Your e-mail address here
$myemail = "yourname\@your-website.com";

# the text for the links section - if no links are entered it will not be displayed
$linkstext = "My links";

# The default font face for userpages. Must be same as syntax as options in form.
# NOTE: In EZHomesite the font face will not impact the settings in the Create Page and 
# Edit Page section.
$fontface = "Arial";

# Compucat Modifications  ver 1.21 - 01/29/2000
# set csnotify to 1 to enable email notifications
# set csnotify to 0 to disable email notifications
# the user notification page differs with this option
$csnotify = 1;

# set csreeditindex to 1 to reedit the index page after Edits
# set csreeditindex to 0 to disable reedit of the index page after Edits
# the reediting of the index page is handled by sub csreeditentry
# which deletes the entry from the index page writes it out
# and then adds the entry to the index page and writes it out
# putting the edited headline at the top of the index page
$csreeditindex = 1;

# set csdisplaylinks to 1 to enable Links in Design And Creation
# set csdisplaylinks to 0 to disable Links
$csdisplaylinks = 1;

# set csdisplayoptable to 1 to enable Optional Table in Design And Creation
# set csdisplayoptable to 0 to disable Optional Table in Design And Creation
$csdisplayoptable = 1;

# set csdisplaymailto to 1 to enable email image selection in Design And Creation
# set csdisplaymailto to 0 to disable email image selection and the mailto
$csdisplaymailto = 1;

# End of Compucat Modifications
# That's it.
# DO NOT CHANGE ANYTHING BELOW THIS LINE
######################################################################################
$SIG{__DIE__} = \&Error_Msg;

sub Error_Msg {
    $msg = "@_";
    print "\nContent-type: text/html\n\n";
    print "The following error occurred : $msg\n";
    exit;
}

# Get the input
read(STDIN, $input, $ENV{'CONTENT_LENGTH'});

    # split the input
    @pairs = split(/&/, $input);

    # split the name/value pairs
    foreach $pair (@pairs) {

    ($name, $value) = split(/=/, $pair);

    $name =~ tr/+/ /;
    $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $value =~ tr/+/ /;
    $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $value =~ s/<([^>]|\n)*>//g;

  $FORM{$name} = $value;
    }

# Lets do some translating first
# EZHomesite modifications: navigator and content, pagepos and
$login = $FORM{'login'};
$usrname = $FORM{'usrname'};
$email = $FORM{'email'};
$background = $FORM{'background'};
$background2 = $FORM{'background2'};
$emailgif = $FORM{'emailgif'};
$linkc = $FORM{'linkc'};
$vlinkc = $FORM{'vlinkc'};
$textc = $FORM{'textc'};
$fontface = $FORM{'fontface'};
$headline = $FORM{'headline'};
$subhead = $FORM{'subhead'};
$headpos = $FORM{'headpos'};
$pagepos = $FORM{'pagepos'};
$topimage = $FORM{'topimage'};
$line2 = $FORM{'line'};
$imageyn = "yes";
$imagepos = $FORM{'imagepos'};
$imdesc = $FORM{'imdesc'};
$usrlink1 = $FORM{'usrlink1'};
$usrlink2 = $FORM{'usrlink2'};
$usrlink3 = $FORM{'usrlink3'};
$linkname1 = $FORM{'linkname1'};
$linkname2 = $FORM{'linkname2'};
$linkname3 = $FORM{'linkname3'};
$navigator1 = $FORM{'navigator1'};
$navigator2 = $FORM{'navigator2'};
$navigator3 = $FORM{'navigator3'};
$navigator4 = $FORM{'navigator4'};
$navigator5 = $FORM{'navigator5'};
$content = $FORM{'content'};
$content2 = $FORM{'content2'};
$content3 = $FORM{'content3'};
$content4 = $FORM{'content4'};
$content5 = $FORM{'content5'};
$images = $FORM{'images'};
$password = $FORM{'password'};
$bullet = $FORM{'bullet'};
$tbltext = $FORM{'tbltext'};
$updact = $FORM{'updact'};

# Add the line breaks for paragraph spacing
#$content =~ s/&&/<br><br>/g;
$content =~ s/&&/%%/g;
$content2 =~ s/&&/%%/g;
$content3 =~ s/&&/%%/g;
$content4 =~ s/&&/%%/g;
$content5 =~ s/&&/%%/g;


# This fixes the bug of white space and
# other wierd spacing:
$content =~ s/\cM//g;
$content =~ s/\n/  /g;
$content2 =~ s/\cM//g;
$content2 =~ s/\n/  /g;
$content3 =~ s/\cM//g;
$content3 =~ s/\n/  /g;
$content4 =~ s/\cM//g;
$content4 =~ s/\n/  /g;
$content5 =~ s/\cM//g;
$content5 =~ s/\n/  /g;
$tbltext =~ s/\cM//g;
$tbltext =~ s/\n/  /g;

# If the user tries to add more than one word in
# the pages name field, this will put an underscore
# in the spaces to make it one word
$login =~ s/ /_/g;

# Find out what the user wants to do
if ($FORM{'action'} eq "New Site") {
    &newpage;
    }
if ($FORM{'action'} eq "Create Site") {
    &create;
    }
if ($FORM{'action'} eq "Edit Site") {
    &confirm("edit");
    }
if ($FORM{'action'} eq "checkuser") {
    &checkuser;
    }
    if ($FORM{'action'} eq "recreate") {
    &recreate;
    }
if ($FORM{'action'} eq "Delete Site") {
    &confirm("delete");
    }

sub newpage() {
    local($usrname, $mail, $head, $sub, $body, $body2, $body3, $body4, $body5, $bgimage, $bgimage2, $linkcolor, $vlinkcolor, 
        $ahref1, $ahref2, $ahref3, $ahrefname1, $ahref2name, $ahref3name,
                    $password1, $imurl, $hrline, $emailpic, $textcolor, $bullet, $tbltext, 
$navigator1, $navigator2, $navigator3, $navigator4, $navigator5, $headpos, $pagepos, $imagepos);

($usrname, $mail, $bgimage, $bgimage2, $head, $sub, $body, $body2, $body3, $body4, $body5, $linkcolor, $vlinkcolor, 
    $ahref1, $ahref2, $ahref3, $ahrefname1, $ahref2name, $ahref3name, 
    $password1, $imurl, $hrline, $emailpic, $textcolor, $bullet, $tbltext, 
$navigator1, $navigator2, $navigator3, $navigator4, $navigator5, $headpos, $pagepos, $imagepos) = split(/&&/, "");

$ahref1="http://";    
$ahref2="http://";
$ahref3="http://";
$textcolor="#000000";
$linkcolor="#0000ff";
$vlinkcolor="#800000";
$bullet="0";
# To avoid any security risks. Take out the HTML tags added when HPM translated
# the && to: <br><br>. They will be re-translated to: && Once the user updates
# the page, the: && will be put back to: <br><br>
$body =~ s/<br><br>/&&/g;
$body2 =~ s/<br><br>/&&/g;
$body3 =~ s/<br><br>/&&/g;
$body4 =~ s/<br><br>/&&/g;
$body5 =~ s/<br><br>/&&/g;

# print the edit-page form

print "Content-type: text/html\n\n";
print "<html><head><title>Create Your Own Homesite</title></head>\n";
print "<body bgcolor=\"#FFFFFF\" TEXT=\"#000000\" font face=\"Arial\" link=\"#008000\" vlink=\"#800040\">\n";
print "<center>\n";
print "<img src=\"$logo\" alt=\"$logoalt\" border=0>\n";
print "<table width=640 cellspacing=2 cellpadding=2 border=0>\n";
print "<tr><td width=100% align=left valign=top>\n";
print "</td></tr><tr><td bgcolor=lightgrey><p><FONT face=\"verdana, helvetica, arial\" size=\"4\"><h2>Create Your Own Homesite</h2></font></p>\n";
print "</td></tr><tr><td bgcolor=white><FONT face=\"verdana, helvetica, arial\" size=\"2\"><p>Below is an empty form for you to fill in. <br>The first five fields are required.\n";
print "<br>You can edit any part of your site later</font></p>\n";
print "<form action=\"$cgiurl\" method=POST>\n";
print "<input type=hidden name=\"action\" value=\"Create Site\">\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Your name:</b></font><br>\n";
print "</td></tr><tr><td bgcolor=white><font face=\"verdana, helvetica, arial\" size=\"1\">(will appear in page as link to your email)</font><br>\n";
print "<input type=text size=40 name=\"usrname\" value=\"$usrname\"><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>The next 3 fields will be used for editing:</b>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Homesite Login and location:</b><br>\n";
print "</td></tr><tr><td bgcolor=white><font face=\"verdana, helvetica, arial\" size=\"1\">(One word that would be your webadress. It's also used later for editing)<br>\n";
print "<input type=text size=40 name=\"login\" value=\"$login\"><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Your e-mail:</b><br>\n";
print "</td></tr><tr><td bgcolor=white><font face=\"verdana, helvetica, arial\" size=\"1\">(For editing and will also appear in page)<br>\n";
print "<input type=text size=40 name=\"email\" value=\"$mail\"><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Password:</b><br>\n";
print "</td></tr><tr><td bgcolor=white><font face=\"verdana, helvetica, arial\" size=\"1\">(One word that will be your password for editing)<br>\n";
print "<input type=password size=40 name=\"password\" value=\"$password1\"><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Homesite Title:</b><br>\n";
print "</td></tr><tr><td bgcolor=white><font face=\"verdana, helvetica, arial\" size=\"1\">\n";
print "(How your page will be listed in index and the main title of your site)<br></font>\n";
print "<input type=text size=40 name=\"headline\" value=\"$head\"><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Do you want the title centered:</b>\n";
print "<input type=radio name=\"headpos\" value=\"yes\" checked>Yes\n";
print "<input type=radio name=\"headpos\" value=\"no\">No</font>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Name on webpages:</b></font><br>\n";
print "</td></tr><tr><td bgcolor=white><font face=\"verdana, helvetica, arial\" size=\"1\">(Will also be the name of your navigation links)<br>\n";
print "Page 1: <input type=text size=40 name=\"navigator1\" value=\"$navigator1\"><br>\n";
print "Page 2: <input type=text size=40 name=\"navigator2\" value=\"$navigator2\"><br>\n";
print "Page 3: <input type=text size=40 name=\"navigator3\" value=\"$navigator3\"><br>\n";
print "Page 4: <input type=text size=40 name=\"navigator4\" value=\"$navigator4\"><br>\n";
print "Page 5: <input type=text size=40 name=\"navigator5\" value=\"$navigator5\"></font><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Do you want the pages centered:</b> <input type=radio name=\"pagepos\" value=\"yes\" checked>Yes\n";
print "<input type=radio name=\"pagepos\" value=\"no\">No</font>\n";
print "</td></tr><tr><td bgcolor=lightgrey><p><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Slogan:</b></font><br>\n";
print "</td></tr><tr><td bgcolor=white><font face=\"verdana, helvetica, arial\" size=\"1\">(Subtitle of your site)</font><br>\n";
print "<input type=text size=40 name=\"subhead\" value=\"$sub\"><br><br>\n";
&build_form_body($usrname, $mail, $head, $sub, $body, $body2, $body3, $body4, $body5, $bgimage, $bgimage2, $linkcolor, $vlinkcolor, 
        $ahref1, $ahref2, $ahref3, $ahrefname1, $ahref2name, $ahref3name,
                    $filename, $imurl, $hrline, $emailpic, $textcolor, $fontface, $bullet, $tbltext,
$navigator1, $navigator2, $navigator3, $navigator4, $navigator5, $headpos, $pagepos, $imagepos);
print "<input type=submit value=\"Create Site\">\n";
print "</form>\n";
print HTML "<p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">A <a href=\"mailto:$myemail\">$yourtitle</a> Customization Based On <a href=\"http://www.internor.com/ezhomesite/\">EZHomesite</a></p>\n";
print "</td></tr></table>\n";
print "</font></center></body></html>\n";
    }

sub create {

# Now, lets do some error checking. Making sure they filled out each field
# This is pretty low tech now. I'll improve it later
&missing(missing_name) unless $usrname;
&missing(missing_email) unless $email;
&missing(missing_login) unless $login;

# if they try to name their page "index" This will stop them
if ($login eq "admin") {
    print "Content-type: text/html\n\n";
    print "<html><head><title>Error</title></head>\n";
    print "<body><center><img src=\"$logo\" alt=\"$logoalt\" border=0></center><p>\n";
    print "<p>You cannot name your page <b>index</b>\n";
    print "Please go back and re-name your page</p>\n";
    print "<p>(Return to <a href=\"$baseurl\">Index</a>)\n";
    exit;
        }
# if they Don't give their page a heading This will stop them
if ($headline eq "") {
    print "Content-type: text/html\n\n";
    print "<html><head><title>Error</title></head>\n";
    print "<body><p>You MUST give your page a <b>Headline</b>\n";
    print "Please go back and enter one for your page</p>\n";
    exit;
        }

# if the user tries to name their page 
# something that is already taken
# this will HOPEFULLY stop them :)
if (-e "$page_dir/$login/index\.html") {
        print "Content-type: text/html\n\n";
        print "<html><head><title>Error</title></head>\n";
        print "<body><p>The Homesite Name: <b>$login</b>\n";
        print "is already taken.\n";
        print "Please go back and rename your Homesite</p>\n";
        print "<p>(Return to <a href=\"$baseurl\">Index</a>)\n";
        exit;
                }
        mkdir ("$base_dir/$login", 0777) || die("Could not create user directory:");
#now, lets create our new html page
  &buildpage;

# Write the login name and email address to a separate file for confirmation
# when they want to edit their page
open (FILE, ">>$data") || die "I can't open $data\n";
if ($win95==0) { flock (FILE, 2) or die "can't lock data file\n"; }
print FILE "$login&&$email&&$password\n";
close(FILE);


# Suck the index page, and write the new entry to it
open(FILE, "$indexpage") || die "I can't open that file\n";
if ($win95==0) { flock (FILE, 1) or die "can't lock index file\n"; }
    @lines = <FILE>;
    close(FILE);
    $sizelines = @lines;

# Now, re-open the links file, and add the new link
open(FILE, ">$indexpage") || die "I can't open that file\n";
if ($win95==0) { flock (FILE, 2) or die "can't lock index file\n"; }
    
        for ($a = 0; $a <= $sizelines; $a++) {
    
        $_ = $lines[$a];

    if (/<!--begin-->/) {
    
    print FILE "<!--begin-->\n";
    print FILE "<p><FONT face=\"verdana, helvetica, arial\" size=\"3\"><a href=\"$baseurl$login/index.html\">$headline</a></font></p>\n";

        } else {
            print FILE $_;
        }
    }
close(FILE);



# Send the user an e-mail confirming their page
if($csnotify){
  open (MAIL,"|$sendmail");
  print MAIL "To: $email\n";
  print MAIL "From: $myemail\n";
  print MAIL "Subject: Your URL on $title\n";
  print MAIL "Your site can be viewed at the URL below:\n";
  print MAIL "\n";
  print MAIL "$baseurl$login\n";
  print MAIL "\nThank you for using $title\n";
  print MAIL "\n\nHomesite Manager - $myemail\n";
  close (MAIL);

# Notify us when someone creates a site
open (MAIL, "|$sendmail");
  print MAIL "To: $myemail\n";
  print MAIL "From: $email\n";
  print MAIL "Subject: New EZHomesite Report\n";
  print MAIL "$usrname created a New Site:\n";
  print MAIL "$baseurl$login/index.html\n";
  print MAIL "\nThe content is :\n$content\n";
close(MAIL);
# Give the user a response
print "Content-type: text/html\n\n";
print "<html><head><title>Thanks</title></head>\n";
print "<body bgcolor=\"#ffffff\" TEXT=\"#000000\" link=\"#008000\" vlink=\"#800040\">\n";
print "<center><img src=\"$logo\" alt=\"$logoalt\" border=0></center><p>\n";
print "<BR><BR><FONT face=\"verdana, helvetica, arial\" size=\"1\">\n";
print "Your site has been created, and you will receive an e-mail confirming this!\n";
print "Your URL is: <a href=\"$baseurl$login/\">\n";
print "$baseurl$login/</a> - remember to press Reload\n";
print "Thanks for your participation!\n";
print "<p>(Return to <a href=\"$baseurl\">Index</a>)\n";
print HTML "<p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">A <a href=\"mailto:$myemail\">$yourtitle</a> Customization Based On <a href=\"http://www.internor.com/ezhomesite/\">EZHomesite</a></p>\n";
print "</body></html>\n";
} else {
# Give the user a response
print "Content-type: text/html\n\n";
print "<html><head><title>Thanks</title></head>\n";
print "<body bgcolor=\"#ffffff\" TEXT=\"#000000\" link=\"#008000\" vlink=\"#800040\">\n";
print "<center><img src=\"$logo\" alt=\"$logoalt\" border=0></center><p>\n";
print "<BR><BR><FONT SIZE=4 FACE=\"ARIAL\">\n";
print "Your Homesite has been created!\n";
print "Your URL is: <a href=\"$baseurl$login\">\n";
print "$baseurl$login/</a> - remember to press Reload\n";
print "Thanks for your participation!\n";
print "<p>(Return to <a href=\"$baseurl\">Index</a>)\n";
print HTML "<p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">A <a href=\"mailto:$myemail\">$yourtitle</a> Customization Based On <a href=\"http://www.internor.com/ezhomesite/\">EZHomesite</a></p>\n";
print "</body></html>\n";
}
        }

sub recreate {
#now, lets create our new html page
  &buildpage;
  if($csreeditindex){
  &csreeditentry;
  }
if($csnotify){
# Send the user a notice that their site has been re-done
  open (MAIL,"|$sendmail");
  print MAIL "To: $email\n";
  print MAIL "From: $myemail\n";
  print MAIL "Subject: Your Changes on the $title\n";
  print MAIL "Your revised site can be viewed at the URL below:\n";
  print MAIL "\n";
  print MAIL "$baseurl$login\n";
  print MAIL "\nOnce again thank you for using the $title\n";
  print MAIL "\n\nThe Homesite Manager\n";
  close (MAIL);
# Give the user a response
print "Content-type: text/html\n\n";
print "<html><head><title>Thanks</title></head>\n";
print "<body bgcolor=\"#ffffff\" TEXT=\"#000000\" link=\"#008000\" vlink=\"#800040\">\n";
print "<CENTER><IMG SRC=\"$logo\" alt=\"$logoalt\" border=0></CENTER>\n";
print "<P><BR><BR><FONT face=\"verdana, helvetica, arial\" size=\"1\">\n";
print "Your site has been revised, and you will receive an e-mail confirming this!\n";
print "Your URL is: <a href=\"$baseurl$login\">\n";
print "$baseurl$login/</a> - remember to press Reload\n";
print "Thanks for your participation!\n";
print "<p>(Return to <a href=\"$baseurl\">Index</a>)\n";
print HTML "<p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">A <a href=\"mailto:$myemail\">$yourtitle</a> Customization Based On <a href=\"http://www.internor.com/ezhomesite/\">EZHomesite</a></p>\n";
print "</body></html>\n";
} else {
# Give the user a response
print "Content-type: text/html\n\n";
print "<html><head><title>Thanks</title></head>\n";
print "<body bgcolor=\"#ffffff\" TEXT=\"#000000\" link=\"#008000\" vlink=\"#800040\">\n";
print "<CENTER><IMG SRC=\"$logo\" alt=\"$logoalt\" border=0></CENTER>\n";
print "<P><BR><BR><FONT face=\"verdana, helvetica, arial\" size=\"1\">\n";
print "Your site has been revised!\n";
print "Your URL is: <a href=\"$baseurl/$login\">\n";
print "$baseurl$login/</a> - remember to press Reload\n";
print "Thanks for your participation!\n";
print "<p>(Return to <a href=\"$baseurl\">Index</a>)\n";
print HTML "<p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">A <a href=\"mailto:$myemail\">$yourtitle</a> Customization Based On <a href=\"http://www.internor.com/ezhomesite/\">EZHomesite</a></p>\n";
print "</body></html>\n";
}
       }





sub buildpage {
###############################################################
# EZHomesite Modifications  ver 1.00 - 12/10/2000
###############################################################
#  NEW PAGE STARTS HERE
###############################################################
open(HTML, ">$page_dir/$login/index.html") || die "I can't create $login/index.html\n";
if ($win95==0) { flock (HTML, 2) or die "can't lock html file\n"; }
print HTML "<html><head><title>$headline</title></head>\n";

# the next few lines are banner printing code
print HTML ("<SCRIPT LANGUAGE=JavaScript>\n");
print HTML ("<!--\n");
print HTML ("window.open(\"$banner\", \"w3adIAYJAAII\",\n");
print HTML ("\"width=640,height=80\")\;\n");
print HTML ("//-->\n");
print HTML ("</SCRIPT>\n");

print HTML "<body background=\"$background\" text=$textc link=$linkc vlink=$vlinkc>\n";
if ($pagepos eq "yes") {
    print HTML "<center>\n";
        }

print HTML "<table width=\"80%\" border=\"0\" cellpadding=\"5\" cellspacing=\"1\"><tr><td colspan=\"3\" height=\"80\" valign=\"top\"  background=\"$background2\">\n";

    if ($headpos eq "yes") {
    print HTML "<center>\n";
        }
print HTML "<p><font face=\"$fontface\" size=6>$headline</font><br>
<font face=\"$fontface\" size=3><b>$subhead</b></p>\n";
    if ($headpos eq "yes") {
    print HTML "</center>\n";
        }
print HTML "</tr></td>\n";

print HTML "<tr><td width=\"15%\" valign=\"top\" background=\"$background2\">\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"index.html\">$navigator1</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page2.html\">$navigator2</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page3.html\">$navigator3</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page4.html\">$navigator4</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page5.html\">$navigator5</a></font><br>\n";
print HTML "</td><td width=\"70%\" valign=\"top\">\n";
    if ($imageyn eq "yes") {
    if ($imagepos eq "yes") {
    print HTML "<center>\n";
        }
    if (($topimage eq "0") or ($topimage eq "")) {
        print HTML "";
        }
    else  {
        print HTML "<img src=\"$topimage\">\n";
        }
print HTML "</center><p><font face=\"$fontface\" size=3><b>$navigator1</b></font>\n";
    if ($imagepos eq "yes") {
    print HTML "</p>\n";
        }
    print HTML "<center>";
    if (($line2 eq "0") or ($line2 eq "")) {
        print HTML "</center>";
        } 
    else {
       print HTML "<p><img src=\"$line2\"></center></p>\n";
        }
    }

@atxt = split(/%%/, $content);
if ($bullet eq "0") {

  foreach $txtline(@atxt) {
      print HTML "<p align=\"left\"><font face=\"$fontface\" size=3>$txtline</font></p>\n";
    }
  }
else {
print HTML "<table border=0 cellpadding=5>\n";
foreach $txtline (@atxt) {
  print HTML "<tr><td valign=top><img src=\"$bullet\"></td>\n";
  print HTML "<td><font face=\"$fontface\" size=3>$txtline</font></td></tr>\n";
  }
print HTML "</table>\n";
}
if($csdisplayoptable){
print HTML "<center>\n";
print HTML "<table border=1 cellspacing=0 cellpadding=5>";
@all = split(/%%/,$tbltext);
foreach $tbline (@all) {
    print HTML "<tr>";
    @flds = split(/\:\:/, $tbline);
    foreach $fld (@flds) {
        print HTML "<td><font face=\"$fontface\">$fld</font></td>";
        }
    print HTML "</tr>";
    }
print HTML "</table>";
print HTML "</center>";
}
if(($csdisplaylinks)&&(($linkname1 ne "")||($linkname2 ne "")||($linkname3 ne ""))){
if ($bullet eq "0") {
  print HTML "\n";
  }
print HTML "<p align=\"left\"><i><font face=\"$fontface\" size=3><b>$linkstext:</i></b></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"$usrlink1\" Target=\"_blank\">$linkname1</a><br>\n";
print HTML "<a href=\"$usrlink2\" Target=\"_blank\">$linkname2</a><br>\n";
print HTML "<a href=\"$usrlink3\" Target=\"_blank\">$linkname3</a></font></p>\n";
if ($bullet eq "0") {
  print HTML "\n";
  }
}

print HTML "<p><center>";
if (($line2 eq "0") or ($line2 eq "")) {
print HTML "";
    } else {
print HTML "<img src=\"$line2\"></center></p>\n";
    }
print HTML "<p align=\"center\"><font face=\"$fontface\" size=3><a href=\"index.html\">$navigator1</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page2.html\">$navigator2</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page3.html\">$navigator3</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page4.html\">$navigator4</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page5.html\">$navigator5</a></font></p>\n";

if($csdisplaymailto){
print HTML "<p><center>";
if (($emailgif ne "")&&($emailgif ne "0")) {
    print HTML "<img src=\"$emailgif\"><br>\n";
    }
print HTML "<font face=\"$fontface\" size=3><a href=\"mailto:$email\">$usrname</a></font></center></p>\n";
}

print HTML "</td><td width=\"15%\" valign=\"top\"  background=\"$background2\">";
print HTML "<p align=\"left\"><a href=\"http://internor.com/ezhomesite/\">\n";
print HTML "<img src=\"$imageurl/button.gif\" alt=\"EZHomesite\"></a></p></td></tr>\n";
 if ($pagepos eq "yes") {
    print HTML "</center>\n";
        }

print HTML "<tr><td colspan=\"3\" valign=\"top\"  background=\"$background2\"><p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">\n";
print HTML "<p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">A <a href=\"mailto:$myemail\">$yourtitle</a> Customization Based On <a href=\"http://www.internor.com/ezhomesite/\">EZHomesite</a></p>\n";
print HTML "</td></tr></table></body></html>";
close(HTML);

###############################################################
#  NEW PAGE STARTS HERE
###############################################################
open(HTML, ">$page_dir/$login/page2.html") || die "I can't create $login/page2.html\n";
if ($win95==0) { flock (HTML, 2) or die "can't lock html file\n"; }
print HTML "<html><head><title>$headline</title></head>\n";

# the next few lines are banner printing code
print HTML ("<SCRIPT LANGUAGE=JavaScript>\n");
print HTML ("<!--\n");
print HTML ("window.open(\"$banner\", \"w3adIAYJAAII\",\n");
print HTML ("\"width=640,height=80\")\;\n");
print HTML ("//-->\n");
print HTML ("</SCRIPT>\n");

print HTML "<body background=\"$background\" text=$textc link=$linkc vlink=$vlinkc><font face=\"Arial\">\n";
if ($pagepos eq "yes") {
    print HTML "<center>\n";
        }

print HTML "<table width=\"80%\" border=\"0\" cellpadding=\"5\" cellspacing=\"1\"><tr><td colspan=\"3\" height=\"80\" valign=\"top\"  background=\"$background2\">\n";

    if ($headpos eq "yes") {
    print HTML "<center>\n";
        }
print HTML "<p><font face=\"$fontface\" size=6>$headline</font><br>
<font face=\"$fontface\" size=3><b>$subhead</b></p>\n";
    if ($headpos eq "yes") {
    print HTML "</center>\n";
        }
print HTML "</tr></td>\n";

print HTML "<tr><td width=\"15%\" valign=\"top\" background=\"$background2\">\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"index.html\">$navigator1</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page2.html\">$navigator2</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page3.html\">$navigator3</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page4.html\">$navigator4</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page5.html\">$navigator5</a></font><br>\n";
print HTML "</td><td width=\"70%\" valign=\"top\">\n";
    if ($imageyn eq "yes") {
    if ($imagepos eq "yes") {
    print HTML "<center>\n";
        }
    if (($topimage eq "0") or ($topimage eq "")) {
        print HTML "";
        }
    else  {
        print HTML "<img src=\"$topimage\">\n";
        }
print HTML "</center><p><font face=\"$fontface\" size=3><b>$navigator2</b></font>\n";
    if ($imagepos eq "yes") {
    print HTML "</p>\n";
        }
    print HTML "<center>";
    if (($line2 eq "0") or ($line2 eq "")) {
        print HTML "</center>";
        } 
    else {
       print HTML "<p><img src=\"$line2\"></center></p>\n";
        }
    }

@atxt = split(/%%/, $content2);
if ($bullet eq "0") {

  foreach $txtline(@atxt) {
      print HTML "<p align=\"left\"><font face=\"$fontface\" size=3>$txtline</font></p>\n";
    }
  }
else {
print HTML "<table border=0 cellpadding=5>\n";
foreach $txtline (@atxt) {
  print HTML "<tr><td valign=top><img src=\"$bullet\"></td>\n";
  print HTML "<td><font face=\"$fontface\" size=3>$txtline</font></td></tr>\n";
  }
print HTML "</table>\n";
}
if($csdisplayoptable){
print HTML "<center>\n";
print HTML "<table border=1 cellspacing=0 cellpadding=5>";
@all = split(/%%/,$tbltext);
foreach $tbline (@all) {
    print HTML "<tr>";
    @flds = split(/\:\:/, $tbline);
    foreach $fld (@flds) {
        print HTML "<td><font face=\"$fontface\">$fld</font></td>";
        }
    print HTML "</tr>";
    }
print HTML "</table>";
print HTML "</center>";
}
if(($csdisplaylinks)&&(($linkname1 ne "")||($linkname2 ne "")||($linkname3 ne ""))){
if ($bullet eq "0") {
  print HTML "\n";
  }
print HTML "<p align=\"left\"><i><font face=\"$fontface\" size=3><b>$linkstext:</i></b></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"$usrlink1\" Target=\"_blank\">$linkname1</a><br>\n";
print HTML "<a href=\"$usrlink2\" Target=\"_blank\">$linkname2</a><br>\n";
print HTML "<a href=\"$usrlink3\" Target=\"_blank\">$linkname3</a></font></p>\n";
if ($bullet eq "0") {
  print HTML "\n";
  }
}

print HTML "<p><center>";
if (($line2 eq "0") or ($line2 eq "")) {
print HTML "";
    } else {
print HTML "<img src=\"$line2\"></center></p>\n";
    }
print HTML "<p align=\"center\"><font face=\"$fontface\" size=3><a href=\"index.html\">$navigator1</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page2.html\">$navigator2</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page3.html\">$navigator3</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page4.html\">$navigator4</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page5.html\">$navigator5</a></font></p>\n";

if($csdisplaymailto){
print HTML "<p><center>";
if (($emailgif ne "")&&($emailgif ne "0")) {
    print HTML "<img src=\"$emailgif\"><br>\n";
    }
print HTML "<font face=\"$fontface\" size=3><a href=\"mailto:$email\">$usrname</a></font></center></p>\n";
}

print HTML "</td><td width=\"15%\" valign=\"top\"  background=\"$background2\">";
print HTML "<p align=\"left\"><a href=\"http://internor.com/ezhomesite/\">\n";
print HTML "<img src=\"$imageurl/button.gif\" alt=\"EZHomesite\"></a></p></td></tr>\n";
 if ($pagepos eq "yes") {
    print HTML "</center>\n";
        }

print HTML "<tr><td colspan=\"3\" valign=\"top\"  background=\"$background2\"><p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">\n";
print HTML "<p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">A <a href=\"mailto:$myemail\">$yourtitle</a> Customization Based On <a href=\"http://www.internor.com/ezhomesite/\">EZHomesite</a></p>\n";
print HTML "</td></tr></table></body></html>";
close(HTML);

###############################################################
#  NEW PAGE STARTS HERE
###############################################################
open(HTML, ">$page_dir/$login/page3.html") || die "I can't create $login/page3.html\n";
if ($win95==0) { flock (HTML, 2) or die "can't lock html file\n"; }
print HTML "<html><head><title>$headline</title></head>\n";

# the next few lines are banner printing code
print HTML ("<SCRIPT LANGUAGE=JavaScript>\n");
print HTML ("<!--\n");
print HTML ("window.open(\"$banner\", \"w3adIAYJAAII\",\n");
print HTML ("\"width=640,height=80\")\;\n");
print HTML ("//-->\n");
print HTML ("</SCRIPT>\n");

print HTML "<body background=\"$background\" text=$textc link=$linkc vlink=$vlinkc><font face=\"Arial\">\n";
if ($pagepos eq "yes") {
    print HTML "<center>\n";
        }

print HTML "<table width=\"80%\" border=\"0\" cellpadding=\"5\" cellspacing=\"1\"><tr><td colspan=\"3\" height=\"80\"  valign=\"top\" background=\"$background2\">\n";

    if ($headpos eq "yes") {
    print HTML "<center>\n";
        }
print HTML "<p><font face=\"$fontface\" size=6>$headline</font><br>
<font face=\"$fontface\" size=3><b>$subhead</b></p>\n";
    if ($headpos eq "yes") {
    print HTML "</center>\n";
        }
print HTML "</tr></td>\n";

print HTML "<tr><td width=\"15%\" valign=\"top\"  background=\"$background2\">\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"index.html\">$navigator1</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page2.html\">$navigator2</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page3.html\">$navigator3</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page4.html\">$navigator4</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page5.html\">$navigator5</a></font><br>\n";
print HTML "</td><td width=\"70%\" valign=\"top\">\n";
    if ($imageyn eq "yes") {
    if ($imagepos eq "yes") {
    print HTML "<center>\n";
        }
    if (($topimage eq "0") or ($topimage eq "")) {
        print HTML "";
        }
    else  {
        print HTML "<img src=\"$topimage\">\n";
        }
print HTML "</center><p><font face=\"$fontface\" size=3><b>$navigator3</b></font>\n";
    if ($imagepos eq "yes") {
    print HTML "</p>\n";
        }
    print HTML "<center>";
    if (($line2 eq "0") or ($line2 eq "")) {
        print HTML "</center>";
        } 
    else {
       print HTML "<p><img src=\"$line2\"></center></p>\n";
        }
    }

@atxt = split(/%%/, $content3);
if ($bullet eq "0") {

  foreach $txtline(@atxt) {
      print HTML "<p align=\"left\"><font face=\"$fontface\" size=3>$txtline</font></p>\n";
    }
  }
else {
print HTML "<table border=0 cellpadding=5>\n";
foreach $txtline (@atxt) {
  print HTML "<tr><td valign=top><img src=\"$bullet\"></td>\n";
  print HTML "<td><font face=\"$fontface\" size=3>$txtline</font></td></tr>\n";
  }
print HTML "</table>\n";
}
if($csdisplayoptable){
print HTML "<center>\n";
print HTML "<table border=1 cellspacing=0 cellpadding=5>";
@all = split(/%%/,$tbltext);
foreach $tbline (@all) {
    print HTML "<tr>";
    @flds = split(/\:\:/, $tbline);
    foreach $fld (@flds) {
        print HTML "<td><font face=\"$fontface\">$fld</font></td>";
        }
    print HTML "</tr>";
    }
print HTML "</table>";
print HTML "</center>";
}
if(($csdisplaylinks)&&(($linkname1 ne "")||($linkname2 ne "")||($linkname3 ne ""))){
if ($bullet eq "0") {
  print HTML "\n";
  }
print HTML "<p align=\"left\"><i><font face=\"$fontface\" size=3><b>$linkstext:</i></b></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"$usrlink1\" Target=\"_blank\">$linkname1</a><br>\n";
print HTML "<a href=\"$usrlink2\" Target=\"_blank\">$linkname2</a><br>\n";
print HTML "<a href=\"$usrlink3\" Target=\"_blank\">$linkname3</a></font></p>\n";
if ($bullet eq "0") {
  print HTML "\n";
  }
}

print HTML "<p><center>";
if (($line2 eq "0") or ($line2 eq "")) {
print HTML "";
    } else {
print HTML "<img src=\"$line2\"></center></p>\n";
    }
print HTML "<p align=\"center\"><font face=\"$fontface\" size=3><a href=\"index.html\">$navigator1</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page2.html\">$navigator2</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page3.html\">$navigator3</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page4.html\">$navigator4</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page5.html\">$navigator5</a></font></p>\n";

if($csdisplaymailto){
print HTML "<p><center>";
if (($emailgif ne "")&&($emailgif ne "0")) {
    print HTML "<img src=\"$emailgif\"><br>\n";
    }
print HTML "<a href=\"mailto:$email\">$usrname</a></font></center></p>\n";
}

print HTML "</td><td width=\"15%\" valign=\"top\"  background=\"$background2\">";
print HTML "<p align=\"left\"><a href=\"http://internor.com/ezhomesite/\">\n";
print HTML "<img src=\"$imageurl/button.gif\" alt=\"EZHomesite\"></a></p></td></tr>\n";
 if ($pagepos eq "yes") {
    print HTML "</center>\n";
        }

print HTML "<tr><td colspan=\"3\" valign=\"top\"  background=\"$background2\"><p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">\n";
print HTML "<p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">A <a href=\"mailto:$myemail\">$yourtitle</a> Customization Based On <a href=\"http://www.internor.com/ezhomesite/\">EZHomesite</a></p>\n";
print HTML "</td></tr></table></body></html>";
close(HTML);

###############################################################
#  NEW PAGE STARTS HERE
###############################################################
open(HTML, ">$page_dir/$login/page4.html") || die "I can't create $login/page4.html\n";
if ($win95==0) { flock (HTML, 2) or die "can't lock html file\n"; }
print HTML "<html><head><title>$headline</title></head>\n";

# the next few lines are banner printing code
print HTML ("<SCRIPT LANGUAGE=JavaScript>\n");
print HTML ("<!--\n");
print HTML ("window.open(\"$banner\", \"w3adIAYJAAII\",\n");
print HTML ("\"width=640,height=80\")\;\n");
print HTML ("//-->\n");
print HTML ("</SCRIPT>\n");

print HTML "<body background=\"$background\" text=$textc link=$linkc vlink=$vlinkc><font face=\"Arial\">\n";
if ($pagepos eq "yes") {
    print HTML "<center>\n";
        }

print HTML "<table width=\"80%\" border=\"0\" cellpadding=\"5\" cellspacing=\"1\"><tr><td colspan=\"3\" height=\"80\"  valign=\"top\" background=\"$background2\">\n";

    if ($headpos eq "yes") {
    print HTML "<center>\n";
        }
print HTML "<p><font face=\"$fontface\" size=6>$headline</font><br>
<font face=\"$fontface\" size=3><b>$subhead</b></p>\n";
    if ($headpos eq "yes") {
    print HTML "</center>\n";
        }
print HTML "</tr></td>\n";

print HTML "<tr><td width=\"15%\" valign=\"top\"  background=\"$background2\">\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"index.html\">$navigator1</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page2.html\">$navigator2</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page3.html\">$navigator3</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page4.html\">$navigator4</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page5.html\">$navigator5</a></font><br>\n";
print HTML "</td><td width=\"70%\" valign=\"top\">\n";
    if ($imageyn eq "yes") {
    if ($imagepos eq "yes") {
    print HTML "<center>\n";
        }
    if (($topimage eq "0") or ($topimage eq "")) {
        print HTML "";
        }
    else  {
        print HTML "<img src=\"$topimage\">\n";
        }
print HTML "</center><p><font face=\"$fontface\" size=3><b>$navigator4</b></font>\n";
    if ($imagepos eq "yes") {
    print HTML "</p>\n";
        }
    print HTML "<center>";
    if (($line2 eq "0") or ($line2 eq "")) {
        print HTML "</center>";
        } 
    else {
       print HTML "<p><img src=\"$line2\"></center></p>\n";
        }
    }

@atxt = split(/%%/, $content4);
if ($bullet eq "0") {

  foreach $txtline(@atxt) {
      print HTML "<p align=\"left\"><font face=\"$fontface\" size=3>$txtline</font></p>\n";
    }
  }
else {
print HTML "<table border=0 cellpadding=5>\n";
foreach $txtline (@atxt) {
  print HTML "<tr><td valign=top><img src=\"$bullet\"></td>\n";
  print HTML "<td><font face=\"$fontface\" size=3>$txtline</font></td></tr>\n";
  }
print HTML "</table>\n";
}
if($csdisplayoptable){
print HTML "<center>\n";
print HTML "<table border=1 cellspacing=0 cellpadding=5>";
@all = split(/%%/,$tbltext);
foreach $tbline (@all) {
    print HTML "<tr>";
    @flds = split(/\:\:/, $tbline);
  foreach $fld (@flds) {
        print HTML "<td><font face=\"$fontface\">$fld</font></td>";
        }
    print HTML "</tr>";
    }
print HTML "</table>";
print HTML "</center>";
}
if(($csdisplaylinks)&&(($linkname1 ne "")||($linkname2 ne "")||($linkname3 ne ""))){
if ($bullet eq "0") {
  print HTML "\n";
  }
print HTML "<p align=\"left\"><i><font face=\"$fontface\" size=3><b>$linkstext:</i></b></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"$usrlink1\" Target=\"_blank\">$linkname1</a><br>\n";
print HTML "<a href=\"$usrlink2\" Target=\"_blank\">$linkname2</a><br>\n";
print HTML "<a href=\"$usrlink3\" Target=\"_blank\">$linkname3</a></font></p>\n";
if ($bullet eq "0") {
  print HTML "\n";
  }
}

print HTML "<p><center>";
if (($line2 eq "0") or ($line2 eq "")) {
print HTML "";
    } else {
print HTML "<img src=\"$line2\"></center></p>\n";
    }
print HTML "<p align=\"center\"><font face=\"$fontface\" size=3><a href=\"index.html\">$navigator1</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page2.html\">$navigator2</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page3.html\">$navigator3</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page4.html\">$navigator4</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page5.html\">$navigator5</a></font></p>\n";

if($csdisplaymailto){
print HTML "<p><center>";
if (($emailgif ne "")&&($emailgif ne "0")) {
    print HTML "<img src=\"$emailgif\"><br>\n";
    }
print HTML "<a href=\"mailto:$email\">$usrname</a></font></center></p>\n";
}

print HTML "</td><td width=\"15%\" valign=\"top\"  background=\"$background2\">";
print HTML "<p align=\"left\"><a href=\"http://internor.com/ezhomesite/\">\n";
print HTML "<img src=\"$imageurl/button.gif\" alt=\"EZHomesite\"></a></p></td></tr>\n";
 if ($pagepos eq "yes") {
    print HTML "</center>\n";
        }

print HTML "<tr><td colspan=\"3\" valign=\"top\"  background=\"$background2\"><p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">\n";
print HTML "<p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">A <a href=\"mailto:$myemail\">$yourtitle</a> Customization Based On <a href=\"http://www.internor.com/ezhomesite/\">EZHomesite</a></p>\n";
print HTML "</td></tr></table></body></html>";
close(HTML);

###############################################################
#  NEW PAGE STARTS HERE
###############################################################
open(HTML, ">$page_dir/$login/page5.html") || die "I can't create $login/page5.html\n";
if ($win95==0) { flock (HTML, 2) or die "can't lock html file\n"; }
print HTML "<html><head><title>$headline</title></head>\n";

# the next few lines are banner printing code
print HTML ("<SCRIPT LANGUAGE=JavaScript>\n");
print HTML ("<!--\n");
print HTML ("window.open(\"$banner\", \"w3adIAYJAAII\",\n");
print HTML ("\"width=640,height=80\")\;\n");
print HTML ("//-->\n");
print HTML ("</SCRIPT>\n");

print HTML "<body background=\"$background\" text=$textc link=$linkc vlink=$vlinkc><font face=\"Arial\">\n";
if ($pagepos eq "yes") {
    print HTML "<center>\n";
        }

print HTML "<table width=\"80%\" border=\"0\" cellpadding=\"5\" cellspacing=\"1\"><tr><td colspan=\"3\" height=\"80\"  valign=\"top\"  background=\"$background2\">\n";

    if ($headpos eq "yes") {
    print HTML "<center>\n";
        }
print HTML "<p><font face=\"$fontface\" size=6>$headline</font><br>
<font face=\"$fontface\" size=3><b>$subhead</b></p>\n";
    if ($headpos eq "yes") {
    print HTML "</center>\n";
        }
print HTML "</tr></td>\n";

print HTML "<tr><td width=\"15%\" valign=\"top\"  background=\"$background2\">\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"index.html\">$navigator1</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page2.html\">$navigator2</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page3.html\">$navigator3</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page4.html\">$navigator4</a></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page5.html\">$navigator5</a></font><br>\n";
print HTML "</td><td width=\"70%\" valign=\"top\">\n";
    if ($imageyn eq "yes") {
    if ($imagepos eq "yes") {
    print HTML "<center>\n";
        }
    if (($topimage eq "0") or ($topimage eq "")) {
        print HTML "";
        }
    else  {
        print HTML "<img src=\"$topimage\">\n";
        }
print HTML "</center><p><font face=\"$fontface\" size=3><b>$navigator5</b></font>\n";
    if ($imagepos eq "yes") {
    print HTML "</p>\n";
        }
    print HTML "<center>";
    if (($line2 eq "0") or ($line2 eq "")) {
        print HTML "</center>";
        } 
    else {
       print HTML "<p><img src=\"$line2\"></center></p>\n";
        }
    }

@atxt = split(/%%/, $content5);
if ($bullet eq "0") {

  foreach $txtline(@atxt) {
      print HTML "<p align=\"left\"><font face=\"$fontface\" size=3>$txtline</font></p>\n";
    }
  }
else {
print HTML "<table border=0 cellpadding=5>\n";
foreach $txtline (@atxt) {
  print HTML "<tr><td valign=top><img src=\"$bullet\"></td>\n";
  print HTML "<td><font face=\"$fontface\" size=3>$txtline</font></td></tr>\n";
  }
print HTML "</table>\n";
}
if($csdisplayoptable){
print HTML "<center>\n";
print HTML "<table border=1 cellspacing=0 cellpadding=5>";
@all = split(/%%/,$tbltext);
foreach $tbline (@all) {
    print HTML "<tr>";
    @flds = split(/\:\:/, $tbline);
foreach $fld (@flds) {
        print HTML "<td><font face=\"$fontface\">$fld</font></td>";
        }
    print HTML "</tr>";
    }
print HTML "</table>";
print HTML "</center>";
}
if(($csdisplaylinks)&&(($linkname1 ne "")||($linkname2 ne "")||($linkname3 ne ""))){
if ($bullet eq "0") {
  print HTML "\n";
  }
print HTML "<p align=\"left\"><i><font face=\"$fontface\" size=3><b>$linkstext:</i></b></font><br>\n";
print HTML "<font face=\"$fontface\" size=3><a href=\"$usrlink1\" Target=\"_blank\">$linkname1</a><br>\n";
print HTML "<a href=\"$usrlink2\" Target=\"_blank\">$linkname2</a><br>\n";
print HTML "<a href=\"$usrlink3\" Target=\"_blank\">$linkname3</a></font></p>\n";
if ($bullet eq "0") {
  print HTML "\n";
  }
}

print HTML "<p><center>";
if (($line2 eq "0") or ($line2 eq "")) {
print HTML "";
    } else {
print HTML "<img src=\"$line2\"></center></p>\n";
    }
print HTML "<p align=\"center\"><font face=\"$fontface\" size=3><a href=\"index.html\">$navigator1</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page2.html\">$navigator2</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page3.html\">$navigator3</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page4.html\">$navigator4</a></font> \n";
print HTML "<font face=\"$fontface\" size=3><a href=\"page5.html\">$navigator5</a></font></p>\n";

if($csdisplaymailto){
print HTML "<p><center>";
if (($emailgif ne "")&&($emailgif ne "0")) {
    print HTML "<img src=\"$emailgif\"><br>\n";
    }
print HTML "<a href=\"mailto:$email\">$usrname</a></font></center></p>\n";
}

print HTML "</td><td width=\"15%\" valign=\"top\"  background=\"$background2\">";
print HTML "<p align=\"left\"><a href=\"http://internor.com/ezhomesite/\">\n";
print HTML "<img src=\"$imageurl/button.gif\" alt=\"EZHomesite\"></a></p></td></tr>\n";
 if ($pagepos eq "yes") {
    print HTML "</center>\n";
        }

print HTML "<tr><td colspan=\"3\" valign=\"top\"  background=\"$background2\"><p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">\n";
print HTML "<p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">A <a href=\"mailto:$myemail\">$yourtitle</a> Customization Based On <a href=\"http://www.internor.com/ezhomesite/\">EZHomesite</a></p>\n";
print HTML "</td></tr></table></body></html>";
close(HTML);


# Write all of the input into a flat file.
open(FILE, ">$page_dir/$login/page.dat") || die "I can't create page.dat\n";
if ($win95==0) { flock (FILE, 2) or die "can't lock user data file\n";  }
$tbltext =~ s/\n/%%/g;
print FILE "$usrname&&$email&&$background&&$background2&&$headline&&$subhead&&$content&&$content2&&$content3&&$content4&&$content5&&$linkc&&$vlinkc&&$usrlink1&&$usrlink2&&$usrlink3&&$linkname1&&$linkname2&&$linkname3&&$password&&$topimage&&$line2&&$emailgif&&$textc&&$fontface&&$bullet&&$tbltext&&$navigator1&&$navigator2&&$navigator3&&$navigator4&&$navigator5&&$headpos&&$pagepos&&$imagepos\n";
close(FILE);
chmod 0777, '$page_dir/$login/page.dat';
}


# Standard error message for any missing required fields
sub missing {
local ($missing) = @_;
print "Content-type: text/html\n\n";

    print "<HTML><HEAD><TITLE>You missed something</TITLE></HEAD>\n";
    print "<BODY>\n";
    print "You forgot to fill in one of the fields. Please go back and make\n";
    print "sure that all required fields are filled in! $missing\n";
    
print "</BODY></HTML>\n";
    exit;
}

sub confirm {
    local ($updact) = @_;

print "Content-type: text/html\n\n";
print "<html><head><title>$updact Confirmation</title></head>\n";
print "<body bgcolor=\"#ffffff\" TEXT=\"#000000\" link=\"#008000\" vlink=\"#800040\" >\n";
print "<CENTER><table width=\"640\"><IMG SRC=\"$logo\" alt=\"$logoalt\"  border=0></CENTER>\n";
print "<P><BR><FONT SIZE=4 FACE=\"ARIAL\">\n";
print "<p><h3>Please Enter your Homesite Login, E-mail and Password to $updact</h3></p>\n";
print "<form action=\"$cgiurl\" method=POST>\n";
print "<FONT SIZE=4 FACE=\"ARIAL\">\n";
print "Homesite Login:<br>\n";
print "<input size=40 type=text name=\"login\"><br>\n";
print "<input size=40 type=hidden name=\"$login\">\n";
print "Original E-Mail Address:<br>\n";
print "<input size=40 type=text name=\"email\"><br>\n";
print "Password:<br>\n";
print "<input type=password size=40 name=\"password\"><br>\n";
print "<input type=submit value=submit>\n";
print "<input type=hidden name=\"action\" value=\"checkuser\">\n";
print "<input type=hidden name=\"updact\" value=\"$updact\">\n";
print "</FONT>\n";
print HTML "<p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">A <a href=\"mailto:$myemail\">$yourtitle</a> Customization Based On <a href=\"http://www.internor.com/ezhomesite/\">EZHomesite</a></p>\n";
print "</form></table></body></html>\n";
    }

sub checkuser {
open(FILE, "$data") || die "I can't open $data\n";  
if ($win95==0) { flock (FILE, 1) or die "can't lock data file\n"; }

    while(<FILE>) {
    chop;       
    @all = split(/\n/);

    foreach $line (@all) {
    ($loginname, $loginemail, $loginpassword) = split(/&&/, $line);
    if($loginname eq "$login" && $loginemail eq "$email" && $loginpassword eq "$password") {
        $match = 1;
        if($updact eq "edit") {
          &edit($loginpassword);
          }
        else {
          &delpage($loginpassword);
          }
        }
      }
    }

close(FILE);

if (! $match) {
    &error;
    }

# del entry from data
if($updact eq "delete") {

    # Suck the index page, and write the new entry to it
    open(FILE, "$data") || die "I can't open that file\n";
    if ($win95==0) { flock (FILE, 1) or die "can't lock data file\n"; }
        @lines = <FILE>;
        close(FILE);
        $sizelines = @lines;

    # Now, re-open the links file, and comment out the page to delete
    open(FILE, ">$data") || die "I can't open that file\n";
    if ($win95==0) { flock (FILE, 2) or die "can't lock index file for append\n"; }
    chop;
            for ($a = 0; $a <= $sizelines; $a++) {
            $_ = $lines[$a];
            $w = $_;
            $w =~ s/\cM//g;
            $w =~ s/\n//g;
    ($loginname, $loginemail, $loginpassword) = split(/&&/, $w);
    if($loginname eq "$login" && $loginemail eq "$email" && $loginpassword eq "$password") {
          # do nothing  (ie. don't write)
          } 
        else {
          if($w eq "") {
            # do nothing (skip)
            }
          else {
            print FILE "$w\n";
            }
          }
        }
    close(FILE);
    print "Content-type: text/html\n\n";
    print "<html><head><title>$updact Confirmation</title></head>\n";
    print "<body bgcolor=\"#ffffff\" TEXT=\"#000000\" link=\"#008000\" vlink=\"#800040\" >\n";
    print "<CENTER><IMG SRC=\"$logo\" alt=\"$logoalt\" border=0></CENTER>\n";
    print "<P><BR><FONT SIZE=4 FACE=\"ARIAL\">\n";
    print "<p>Your page has been deleted";
    print "<p>(Return to <a href=\"$baseurl\">Index</a>)\n";
    print "</form></body></html>\n";
  }
}

sub edit {

    local ($editfile) = @_;
    
        open(FILE, "$page_dir/$login/page.dat") || die "I can't open page.dat\n";
    if ($win95==0) { flock (FILE, 1) or die "can't lock data file for edit\n"; }

    while(<FILE>) {
    chop;
    @datafile = split(/\n/);

    foreach $line (@datafile) {
            &build_edit_form($line);
            }
         }
    close(FILE);
    }

sub delpage {
    local ($editfile) = @_;
        $cnt=unlink "$page_dir/$login/page.dat", "$page_dir/$login/index.html", "$page_dir/$login/page2.html", "$page_dir/$login/page3.html", "$page_dir/$login/page4.html", "$page_dir/$login/page5.html";
        rmdir ("$page_dir/$login");

    # Suck the index page, and write the new entry to it
    open(FILE, "$indexpage") || die "I can't open that file\n";
    if ($win95==0) { flock (FILE, 1) or die "can't lock index file\n"; }
        @lines = <FILE>;
        close(FILE);
        $sizelines = @lines;

    # Now, re-open the links file, and comment out the page to delete
    open(FILE, ">$indexpage") || die "I can't open that file\n";
    if ($win95==0) { flock (FILE, 2) or die "can't lock index file to delete entry\n"; }

            for ($a = 0; $a <= $sizelines; $a++) {

            $_ = $lines[$a];

        if (/$login/) {
          # do nothing  (ie. don't write)
          } 
        else {
          print FILE $_;
           }
        }
    close(FILE);

    }
sub csreeditentry {
    local ($editfile) = @_;
    # Suck the index page, and write the new entry to it
    open(FILE, "$indexpage") || die "I can't open that file\n";
    if ($win95==0) { flock (FILE, 1) or die "can't lock index file\n"; }
        @lines = <FILE>;
        close(FILE);
        $sizelines = @lines;

    # Now, re-open the links file, and comment out the page to delete
    open(FILE, ">$indexpage") || die "I can't open that file\n";
    if ($win95==0) { flock (FILE, 2) or die "can't lock index file to delete entry\n"; }

            for ($a = 0; $a <= $sizelines; $a++) {

            $_ = $lines[$a];

        if (/$login/) {
          # do nothing  (ie. don't write)
          } 
        else {
          print FILE $_;
           }
        }
    close(FILE);
# Suck the index page, and write the new entry to it
 open(FILE, "$indexpage") || die "I can't open that file\n";
 if ($win95==0) { flock (FILE, 1) or die "can't lock index file\n"; }
    @lines = <FILE>;
    close(FILE);
    $sizelines = @lines;

# Now, re-open the links file, and add the new link
 open(FILE, ">$indexpage") || die "I can't open that file\n";
 if ($win95==0) { flock (FILE, 2) or die "can't lock index file\n"; }
    
        for ($a = 0; $a <= $sizelines; $a++) {
    
        $_ = $lines[$a];

    if (/<!--begin-->/) {
    
    print FILE "<!--begin-->\n";
    print FILE "<p><font face=\"Arial,Verdana\" size=3><a href=\"$baseurl$login/index.html\">$headline</a></font></p>\n";
   
        } else {
            print FILE $_;
        }
    }
 close(FILE);
     }

sub build_edit_form($line) {
    local ($line) = @_;
    local($fullname, $mail, $head, $sub, $body, $body2, $body3, $body4, $body5, $bgimage, $bgimage2, $linkcolor, $vlinkcolor, 
        $ahref1, $ahref2, $ahref3, $ahrefname1, $ahref2name, $ahref3name,
            $password1, $imurl, $hrline, $emailpic, $textcolor, $fontface, $bullet, $tbltext,
$navigator1, $navigator2, $navigator3, $navigator4, $navigator5, $headpos, $pagepos,$imagepos);

($fullname, $mail, $bgimage, $bgimage2, $head, $sub, $body, $body2, $body3, $body4, $body5, $linkcolor, $vlinkcolor, $ahref1, $ahref2,
 $ahref3, $ahrefname1, $ahref2name, $ahref3name, $password1, $imurl, $hrline, $emailpic, 
 $textcolor, $fontface, $bullet, $tbltext, $navigator1, $navigator2, $navigator3, $navigator4, $navigator5, $headpos, $pagepos, $imagepos) = split(/&&/, $line);
    
# To avoid any security risks. Take out the HTML tags added when HPM translated
# the && to: <br><br>. They will be re-translated to: && Once the user updates
# the page, the: && will be put back to: <br><br> on all pages
$body =~ s/<br><br>/&&/g;
$body2 =~ s/<br><br>/&&/g;
$body3 =~ s/<br><br>/&&/g;
$body4 =~ s/<br><br>/&&/g;
$body5 =~ s/<br><br>/&&/g;

# print the edit-page form

print "Content-type: text/html\n\n";
print "<html><head><title>Edit Your Page</title></head>\n";
print "<body bgcolor=\"#ffffff\" TEXT=\"#000000\" link=\"#008000\" vlink=\"#800040\">\n";
print "<center>\n";
print "<img src=\"$logo\" alt=\"$logoalt\" border=0>\n";
print "<table width=640 cellspacing=2 cellpadding=2 border=0>\n";
print "<tr><td width=100% align=left valign=top>\n";
print "</td></tr><tr><td bgcolor=lightgrey><p><font face=\"verdana, helvetica, arial\" size=\"6\"><h2>Edit Your Page</h2></font></p>\n";
print "</td></tr><tr><td bgcolor=white><p><FONT face=\"verdana, helvetica, arial\" size=\"2\">Below is a form with the contents\n";
print "of the Homesite you created. You can edit any part of your site.</font></p>\n";
print "<form action=\"$cgiurl\" method=POST>\n";
print "<input type=hidden name=\"action\" value=\"recreate\">\n";
print "<input type=hidden size=40 name=\"login\" value=\"$login\">\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\">Your name:<br>\n";
print "</td></tr><tr><td bgcolor=white><input type=text size=40 name=\"usrname\" value=\"$fullname\"><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\">Your e-mail:</font><br>\n";
print "</td></tr><tr><td bgcolor=white><input type=text size=40 name=\"email\" value=\"$mail\"><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\">Homesite Title:</font><br>\n";
print "</td></tr><tr><td bgcolor=white><input type=text size=40 name=\"headline\" value=\"$head\"><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Do you want the title centered:</b> <input type=radio name=\"headpos\" value=\"yes\"\n";
if ($headpos eq "yes") { print " checked";}
print ">Yes<input type=radio name=\"headpos\" value=\"no\"\n";
if ($headpos eq "no") { print " checked";}
print ">No</font></td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Name on webpages:</b>\n";
print "</font></td></tr><tr><td bgcolor=white><font face=\"verdana, helvetica, arial\" size=\"1\">(Will also be the name of your navigation links)</font><br>\n";
print "<font face=\"verdana, helvetica, arial\" size=\"1\">Page 1: <input type=text size=40 name=\"navigator1\" value=\"$navigator1\"><br>\n";
print "Page 2: <input type=text size=40 name=\"navigator2\" value=\"$navigator2\"><br>\n";
print "Page 3: <input type=text size=40 name=\"navigator3\" value=\"$navigator3\"><br>\n";
print "Page 4: <input type=text size=40 name=\"navigator4\" value=\"$navigator4\"><br>\n";
print "Page 5: <input type=text size=40 name=\"navigator5\" value=\"$navigator5\"></font><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Pages centered:</b> <input type=radio name=\"pagepos\" value=\"yes\"\n";
if ($pagepos eq "yes") { print " checked";}
print ">Yes<input type=radio name=\"pagepos\" value=\"no\"\n";
if ($pagepos eq "no") { print " checked";}
print ">No</font><b></td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\">Slogan:</font></b><br>\n";
print "</td></tr><tr><td bgcolor=white><input type=text size=40 name=\"subhead\" value=\"$sub\"><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\">Password: Not available</font><br><br>\n";
print "<input type=hidden name=\"password\" value=\"$password1\">\n";
&build_form_body($fullname, $mail, $head, $sub, $body, $body2, $body3, $body4, $body5, $bgimage, $bgimage2, $linkcolor, $vlinkcolor, 
        $ahref1, $ahref2, $ahref3, $ahrefname1, $ahref2name, $ahref3name,
            $password1, $imurl, $hrline, $emailpic, $textcolor, $fontface, $bullet, $tbltext,
$navigator1, $navigator2, $navigator3, $navigator4, $navigator5, $headpos, $pagepos, $imagepos);
print "<P><input type=submit value=\"Update Site\">\n";
print "</form>\n";
print "</td></tr></table>\n";
print HTML "<p align=\"center\"><font face=\"Arial, Verdana\" size=\"2\">A <a href=\"mailto:$myemail\">$yourtitle</a> Customization Based On <a href=\"http://www.internor.com/ezhomesite/\">EZHomesite</a></p>\n";
print "</font></center></body></html>\n";
    }

sub build_form_body($fullname, $mail, $head, $sub, $body, $body2, $body3, $body4, $body5, $bgimage, $bgimage2, $linkcolor, $vlinkcolor, 
        $ahref1, $ahref2, $ahref3, $ahrefname1, $ahref2name, $ahref3name,
            $password1, $imurl, $hrline, $emailpic, $textcolor, $fontface, $bullet, $tbltext,
$navigator1, $navigator2, $navigator3, $navigator4, $navigator5, $headpos, $pagepos, $imagepos) {

print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Pick Your Photo From The Gallery:</b>\n";
print "</font></td></tr><tr><td bgcolor=white>\n";
      opendir (TN, "$tnp_dir");
      rewinddir (TN);
      @tnlist =  grep(!/^\.\.?$/, readdir (TN));
      closedir (TN);

   $tnnum = @tnlist;
   $cnum = "0";
   print "<input type=radio name=\"topimage\" value=\"0\"><font face=\"verdana, helvetica, arial\" size=\"1\">No Graphic</font></a><br><br>\n";
   $lend = "0";   
while ($tnnum > $cnum) {
   print "<input type=radio name=\"topimage\" value=\"$tnp_dir_url/$tnlist[$cnum]\" ";
   if ($imurl eq "$tnp_dir_url/$tnlist[$cnum]") {print "checked";}
   print "><img src=\"$tnp_dir_url/$tnlist[$cnum]\" border=0></a>\n";
   $cnum = $cnum + 1;
   $lend = $lend + 1;
   if ($lend eq "4"){
   print "<br><br>\n";
   $lend = 0;
    }
   }

print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Do you want the image centered? :</b> <input type=radio name=\"imagepos\" value=\"yes\"\n";
if ($imagepos eq "yes") { print " checked";}
print ">Yes<input type=radio name=\"imagepos\" value=\"no\"\n";
if ($imagepos eq "no") { print " checked";}

# EZHomesite enhanced
print ">No</font>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Body Page 1:</b> (use two percent signs (<b>%%</b>) BETWEEN paragraphs)</font><br>\n";
print "</td></tr><tr><td bgcolor=white><textarea cols=50 rows=6 wrap=on name=\"content\">$body</textarea><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Body Page 2:</b> (use two percent signs (<b>%%</b>) BETWEEN paragraphs)</font><br>\n";
print "</td></tr><tr><td bgcolor=white><textarea cols=50 rows=6 wrap=on name=\"content2\">$body2</textarea><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Body Page 3:</b> (use two percent signs (<b>%%</b>) BETWEEN paragraphs)</font><br>\n";
print "</td></tr><tr><td bgcolor=white><textarea cols=50 rows=6 wrap=on name=\"content3\">$body3</textarea><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Body Page 4:</b> (use two percent signs (<b>%%</b>) BETWEEN paragraphs)</font><br>\n";
print "</td></tr><tr><td bgcolor=white><textarea cols=50 rows=6 wrap=on name=\"content4\">$body4</textarea><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Body Page 5:</b> (use two percent signs (<b>%%</b>) BETWEEN paragraphs)</font><br>\n";
print "</td></tr><tr><td bgcolor=white><textarea cols=50 rows=6 wrap=on name=\"content5\">$body5</textarea><br><br>\n";
if($csdisplayoptable){
print << 'END'
</td></tr><tr><td bgcolor=lightgrey><font face="verdana, helvetica, arial" size="1"><b>Table (Optional: Will appear below body text on every pages):</b>
</td></tr><tr><td bgcolor=white><font face="verdana, helvetica, arial" size="1"><br>Use two percent signs (<b>%%</b>) BETWEEN rows, use 2 colons (<b>::</b>) BETWEEN fields.  for example (you can copy and paste the example for a start):
<pre><font size=2>
   SU :: MO :: TU :: WE :: TH :: FR :: SA
%%    ::    ::    ::  1 ::  2 ::  3 ::  4
%%  5 ::  6 ::  7 ::  8 ::  9 :: 10 :: 11
%% 12 :: 13 :: 14 :: 15 :: 16 :: 17 :: 18
%% 19 :: 20 :: 21 :: 22 :: 23 :: 24 :: 25
%% 26 :: 27 :: 28 :: 29 :: 30 :: 31
</font></pre></p>
END
;

$tbltext =~ s/%%/\n%%/g;
print "<textarea cols=50 rows=6 wrap=on name=\"tbltext\">$tbltext</textarea></font><br><br>";
} else {
$tbltext =~ s/%%/\n%%/g;
print "<input type=hidden name=\"tbltext\" value=\"$tbltext\">\n";
}
if($csdisplaylinks){
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>$linkstext</b></text><br>\n";
print "</td></tr><tr><td bgcolor=white><table width=80% cellpadding=2 cellspacing=2 border=0>\n";
print "<tr><td width=50% align=left valign=top>\n";
print "<font face=\"verdana, helvetica, arial\" size=\"1\">Link 1 URL:</font><br>\n";
print "<input type=text size=40 name=\"usrlink1\" value=\"$ahref1\"></font><br><br>\n";
print "<font face=\"verdana, helvetica, arial\" size=\"1\">Link 2 URL:</font><br>\n";
print "<input type=text size=40 name=\"usrlink2\" value=\"$ahref2\"></font><br><br>\n";
print "<font face=\"verdana, helvetica, arial\" size=\"1\">Link 3 URL:</font><br>\n";
print "<input type=text size=40 name=\"usrlink3\" value=\"$ahref3\"><br><br>\n";
print "</td>\n";
print "<td width=50% align=left valign=top>\n";
print "<font face=\"verdana, helvetica, arial\" size=\"1\">Link 1 Name:</font><br>\n";
print "<input type=text size=40 name=\"linkname1\" value=\"$ahrefname1\"><br><br>\n";
print "<font face=\"verdana, helvetica, arial\" size=\"1\">Link 2 Name:</font><br>\n";
print "<input type=text size=40 name=\"linkname2\" value=\"$ahref2name\"><br><br>\n";
print "<font face=\"verdana, helvetica, arial\" size=\"1\">Link 3 Name:</font><br>\n";
print "<input type=text size=40 name=\"linkname3\" value=\"$ahref3name\"><br><br>\n";
print "</td></tr></table>\n";
} else {
 print "<input type=\"hidden\" name=\"usrlink1\" value=\"$ahref1\">\n";
 print "<input type=\"hidden\" name=\"usrlink2\" value=\"$ahref2\">\n";
 print "<input type=\"hidden\" name=\"usrlink3\" value=\"$ahref3\">\n";
 print "<input type=\"hidden\" name=\"linkname1\" value=\"$ahrefname1\">\n";
 print "<input type=\"hidden\" name=\"linkname2\" value=\"$ahrefname2\">\n";
 print "<input type=\"hidden\" name=\"linkname3\" value=\"$ahrefname2\">\n";
 }


print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Text</b></font><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\">Text color:</font><br>\n";
print "<input type=radio name=\"textc\" value=\"#000000\"";
    if ($textcolor eq "#000000") {print "checked";}
    print "><font color=\"#000000\">Black\n";
print "<input type=radio name=\"textc\" value=\"#800000\"";
    if ($textcolor eq "#800000") {print "checked";}
    print "><font color=\"Maroon\">Maroon</font>\n";
print "<input type=radio name=\"textc\" value=\"#ff0000\"";
    if ($textcolor eq "#ff0000") {print "checked";}
    print "><font color=\"Red\">Red</font>\n";
print "<input type=radio name=\"textc\" value=\"#ffff00\"";
    if ($textcolor eq "#ffff00") {print "checked";}
    print "><font color=\"Yellow\">Yellow</font>\n";
print "<input type=radio name=\"textc\" value=\"#00ff00\"";
    if ($textcolor eq "#00ff00") {print "checked";}
    print "><font color=\"Green\">Green</font>\n";
print "<input type=radio name=\"textc\" value=\"#ffffff\"";
    if ($textcolor eq "#ffffff") {print "checked";}
    print "><font color=\"White\">White\n";
print "<input type=radio name=\"textc\" value=\"#0000ff\"";
    if ($textcolor eq "#0000ff") {print "checked";}
    print "><font color=\"Blue\">Blue</font><br><br>\n";
print "<font face=\"verdana, helvetica, arial\" size=\"1\" color=\"black\">Link color:</font><br>\n";
print "<input type=radio name=\"linkc\" value=\"#000000\"";
    if ($linkcolor eq "#000000") {print "checked";}
    print "><font color=\"#000000\">Black\n";
print "<input type=radio name=\"linkc\" value=\"#800000\"";
    if ($linkcolor eq "#800000") {print "checked";}
    print "><font color=\"Maroon\">Maroon</font>\n";
print "<input type=radio name=\"linkc\" value=\"#ff0000\"";
    if ($linkcolor eq "#ff0000") {print "checked";}
    print "><font color=\"Red\">Red</font>\n";
print "<input type=radio name=\"linkc\" value=\"#ffff00\"";
    if ($linkcolor eq "#ffff00") {print "checked";}
    print "><font color=\"Yellow\">Yellow</font>\n";
print "<input type=radio name=\"linkc\" value=\"#00ff00\"";
    if ($linkcolor eq "#00ff00") {print "checked";}
    print "><font color=\"Green\">Green</font>\n";
print "<input type=radio name=\"linkc\" value=\"#ffffff\"";
    if ($linkcolor eq "#ffffff") {print "checked";}
    print "><font color=\"White\">White\n";
print "<input type=radio name=\"linkc\" value=\"#0000ff\"";
    if ($linkcolor eq "#0000ff") {print "checked";}
    print "><font color=\"Blue\">Blue</font><br><br>\n";
print "<font face=\"verdana, helvetica, arial\" size=\"1\" color=\"black\">Visited Link Color:</font><br>\n";
print "<input type=radio name=\"vlinkc\" value=\"#000000\"";
    if ($vlinkcolor eq "#000000") {print "checked";}
    print "><font color=\"#000000\">Black\n";
print "<input type=radio name=\"vlinkc\" value=\"#800000\"";
    if ($vlinkcolor eq "#800000") {print "checked";}
    print "><font color=\"Maroon\">Maroon</font>\n";
print "<input type=radio name=\"vlinkc\" value=\"#ff0000\"";
    if ($vlinkcolor eq "#ff0000") {print "checked";}
    print "><font color=\"Red\">Red</font>\n";
print "<input type=radio name=\"vlinkc\" value=\"#ffff00\"";
    if ($vlinkcolor eq "#ffff00") {print "checked";}
    print "><font color=\"Yellow\">Yellow</font>\n";
print "<input type=radio name=\"vlinkc\" value=\"#00ff00\"";
    if ($vlinkcolor eq "#00ff00") {print "checked";}
    print "><font color=\"Green\">Green</font>\n";
print "<input type=radio name=\"vlinkc\" value=\"#ffffff\"";
    if ($vlinkcolor eq "#ffffff") {print "checked";}
    print "><font color=\"White\">White\n";
print "<input type=radio name=\"vlinkc\" value=\"#0000ff\"";
    if ($vlinkcolor eq "#0000ff") {print "checked";}
    print "><font color=\"Blue\">Blue</font><br><br>\n";


print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Font face:</b></font><br>\n";
print "</td></tr><tr><td bgcolor=white><input type=radio name=\"fontface\" value=\"Arial\"";
    if ($fontface eq "Arial") {print "checked";}
    print "><font face=\"Arial\">Arial</font><br><br>\n";
print "<input type=radio name=\"fontface\" value=\"Times\"";
    if ($fontface eq "Times") {print "checked";}
    print "><font face=\"Times\">Times</a><br><br>\n";
print "<input type=radio name=\"fontface\" value=\"Verdana\"";
    if ($fontface eq "Verdana") {print "checked";}
    print "><font face=\"Verdana\">Verdana</font><br><br>\n";
print "<input type=radio name=\"fontface\" value=\"Georgia,times\"";
    if ($fontface eq "Georgia,times") {print "checked";}
    print "><font face=\"Georgia,times\">Georgia</font><br><br>\n";




print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Background color:</b><br>\n";
print "</font></td></tr><tr><td bgcolor=white>\n";
      opendir (TN, "$tnbg_dir");
      rewinddir (TN);
      @tnlist =  grep(!/^\.\.?$/, readdir (TN));
      closedir (TN);

   $tnnum = @tnlist;
   $cnum = "0";
   $lend = "0";   
   while ($tnnum > $cnum) {
      print "<input type=radio name=\"background\" value=\"$tnbg_dir_url/$tnlist[$cnum]\" " ;
      if ($bgimage eq "$tnbg_dir_url/$tnlist[$cnum]") {print "checked";}
      print "><img src=\"$tnbg_dir_url/$tnlist[$cnum]\" border=1></a>\n";
      $cnum = $cnum + 1;
$lend = $lend + 1;
   if ($lend eq "5"){
   print "<br><br>\n";
   $lend = 0;
    }
   }

print "<br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Contrast color:</b><br>\n";
print "</td></tr><tr><td bgcolor=white>\n";
      opendir (TN, "$tnbg_dir");
      rewinddir (TN);
      @tnlist =  grep(!/^\.\.?$/, readdir (TN));
      closedir (TN);

   $tnnum = @tnlist;
   $cnum = "0";
   $lend = "0";   
   while ($tnnum > $cnum) {
      print "<input type=radio name=\"background2\" value=\"$tnbg_dir_url/$tnlist[$cnum]\" " ;
      if ($bgimage2 eq "$tnbg_dir_url/$tnlist[$cnum]") {print "checked";}
      print "><img src=\"$tnbg_dir_url/$tnlist[$cnum]\" border=1></a>\n";
      $cnum = $cnum + 1;
$lend = $lend + 1;
   if ($lend eq "5"){
   print "<br><br>\n";
   $lend = 0;
    }

   }

print "</font><br><br>\n";
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Horizontal Line:</b><br>\n";
print "</font></td></tr><tr><td bgcolor=white>\n";
      opendir (TN, "$tn_dir");
      rewinddir (TN);
      @tnlist =  grep(!/^\.\.?$/, readdir (TN));
      closedir (TN);

   $tnnum = @tnlist;
   $cnum = "0";
      print "<input type=radio name=\"line\" value=\"0\"";
      if ($line2 eq "0") { print " checked";}
      print "><font face=\"verdana, helvetica, arial\" size=\"1\">No Line</font><br><br>\n";
   while ($tnnum > $cnum) {
      print "<input type=radio name=\"line\" value=\"$tn_dir_url/$tnlist[$cnum]\"";
      if ($hrline eq "$tn_dir_url/$tnlist[$cnum]") {print "checked";}
      print "><img src=\"$tn_dir_url/$tnlist[$cnum]\" border=0></a><br><br>\n";
      $cnum = $cnum + 1;
      print "\n";
   }

print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>Bullet:</b><br>\n";
print "</font></td></tr><tr><td bgcolor=white>\n";
      opendir (TN, "$tnb_dir");
      rewinddir (TN);
      @tnlist =  grep(!/^\.\.?$/, readdir (TN));
      closedir (TN);

   $tnnum = @tnlist;
   $cnum = "0";
   print "<input type=radio name=\"bullet\" value=\"0\"";
   if($bullet eq "0") {print "checked";}
   print "><font face=\"verdana, helvetica, arial\" size=\"1\">No Bullet</font><br><br>\n";
   $lend = "0";   
while ($tnnum > $cnum) {
      print "<input type=radio name=\"bullet\" value=\"$tnb_dir_url/$tnlist[$cnum]\"";
      if ($bullet eq "$tnb_dir_url/$tnlist[$cnum]") {print "checked";}
      print "><img src=\"$tnb_dir_url/$tnlist[$cnum]\" border=0></a>\n";
      $cnum = $cnum + 1;
    $lend = $lend + 1;
      if ($lend eq "10"){
    print "<br><br>\n";
    $lend = 0;
    }
   }
if(! $csdisplaymailto){
 print "<input type=hidden name=\"emailgif\" value=\"$emailpic\">\n";
} else {
print "</td></tr><tr><td bgcolor=lightgrey><font face=\"verdana, helvetica, arial\" size=\"1\"><b>E-mail image:</b><br>\n";
print "</font></td></tr><tr><td bgcolor=white>\n";
      opendir (TN, "$tne_dir");
      rewinddir (TN);
      @tnlist =  grep(!/^\.\.?$/, readdir (TN));
      closedir (TN);

   $tnnum = @tnlist;
   $cnum = "0";
   $lend = "0";   
while ($tnnum > $cnum) {
      print "<input type=radio name=\"emailgif\" value=\"$tne_dir_url/$tnlist[$cnum]\"";
      if ($emailpic eq "$tne_dir_url/$tnlist[$cnum]") {print "checked";}
      print "><img src=\"$tne_dir_url/$tnlist[$cnum]\" border=0></a></font>\n";
      $cnum = $cnum + 1;
    $lend = $lend + 1;
      if ($lend eq "4"){
    print "<br><br>\n";
    $lend = 0;
    }
   }
  }
 }

sub error {
    local ($updact) = @_;
print "Content-type: text/html\n\n";
print "<html><head><title>Permission Denied</title></head>\n";
print "<body>\n";
print "<p><font face=\"verdana, helvetica, arial\"><h1>Permission Denied</h1></p>\n";
print "You do not have permission $updact\n";
print "<p>(Return to <a href=\"$baseurl\">Index</a>)</font>\n";
print "</body></html>\n";
exit;
    }






