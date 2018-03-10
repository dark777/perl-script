#!/usr/bin/perl
###########################
##  AutoRank Pro v2.0.4  ##
###################################################################################
##  setup.cgi                                                                    ##
##  ---------                                                                    ##
##  This script controls the setup of AutoRank Pro                               ##
###################################################################################

require "functions.cgi";
package SETUP;

FUNCTIONS::parse();

if($ENV{'REQUEST_METHOD'} eq "GET") {
  print "Content-type: text/html\n\n";
  if($ENV{'QUERY_STRING'} eq "") {    &initialize; &display_main;  }
  elsif($ENV{'QUERY_STRING'} eq "verify")  {  &display_verify  }
  else {  print "Unknown Command"  }
}
elsif($ENV{'REQUEST_METHOD'} eq "POST") {
  if($FUNCTIONS::FORM{'submit'}) {
    print "Content-type: text/html\n\n";
    FUNCTIONS::data_error(1000, "Invalid Administrative Password") unless(FUNCTIONS::password_is_valid($FUNCTIONS::FORM{'password'}));
    &verify_input;
    &edit_variables;
    &print_confirmation;
  } else {  &display_main  }  
}
  
sub display_main {
  FUNCTIONS::header("AutoRank Pro Setup");
  print <<HTML;
  <form action="setup.cgi" method="POST">
  <table cellpadding="1" cellspacing="0" border="0" align="center" width="600">
  <tr>
  <td bgcolor="#000000">
  <!-- INNER TABLE --> 
  <table cellpadding="5" cellspacing="1" border="0" width="100\%">
  <tr>
  <td bgcolor="#afafaf" align="center" colspan="2">
  <font face="Arial" size="3">
  <b>AUTORANK PRO SETUP</b><br>
  <font size="2" color="maroon">
  <b>Never Put a / at the End of a URL or Directory Path</b>
  </font>
  </font>
  </td>
  </tr>
  
  <tr>
  <td bgcolor="#dcdcdc" valign="top">
  <font face="Arial" size="2"><b>Directory Setup</b></font>
  </td>
  <td bgcolor="#ffffff">
  <font face="Verdana" size="1"><b>HTML Directory:</b></font><br>
  <input type="text" name="HTML_DIR_RQ" value="$VARIABLES::HTML_DIR" size="40"><br>
  <font face="Verdana" size="1">
  The full path to the location where the html list page will reside.<br>
  Example: /web/home/username/docs/autorank
  </font>
  <p>
  <font face="Verdana" size="1"><b>Member Data Directory:</b></font><br>
  <input type="text" name="MEMBER_DATA_DIR_RQ" value="$VARIABLES::MEMBER_DATA_DIR" size="40"><br>
  <font face="Verdana" size="1">
  The full path to the location where all member data files will reside.<br>
  Example: /web/home/username/cgi-bin/autorank/members
  </font>
  <p>
  <font face="Verdana" size="1"><b>Template Directory:</b></font><br>
  <input type="text" name="TEMPLATE_DIR_RQ" value="$VARIABLES::TEMPLATE_DIR" size="40"><br>
  <font face="Verdana" size="1">
  The full path to the location where all template data files will reside.<br>
  Example: /web/home/username/cgi-bin/autorank/templates
  </font>
  <p>
  <font face="Verdana" size="1"><b>Mail Command:</b></font><br>
  <input type="text" name="MAIL_COMMAND_RQ" value="$VARIABLES::MAIL_COMMAND" size="40"><br>
  <font face="Verdana" size="1">
  The full path to the location of your sendmail program.<br>
  Example: /usr/bin/sendmail
  </font>
  <p>
  </td>
  </tr>
  
  <tr>
  <td bgcolor="#dcdcdc" valign="top">
  <font face="Arial" size="2"><b>URL Setup</b></font>
  </td>
  <td bgcolor="#ffffff">
  <font face="Verdana" size="1"><b>CGI URL:</b></font><br>
  <input type="text" name="CGI_URL_RQ" value="$VARIABLES::CGI_URL" size="40"><br>
  <font face="Verdana" size="1">
  The full URL to the location where all cgi files will reside.<br>
  Example: http://www.domain.com/cgi-bin/autorank
  </font>
  <p>
  <font face="Verdana" size="1"><b>Forward URL:</b></font><br>
  <input type="text" name="FORWARD_URL_RQ" value="$VARIABLES::FORWARD_URL" size="40"><br>
  <font face="Verdana" size="1">
  The full URL that surfers should be sent to when clicking through.<br>
  Example: http://www.domain.com/autorank/index.html
  </font>
  <p>
  </td>
  </tr>
  
  <tr>
  <td bgcolor="#dcdcdc" valign="top">
  <font face="Arial" size="2"><b>List Details</b></font>
  </td>
  <td bgcolor="#ffffff">
  <font face="Verdana" size="1"><b>Split List At:</b></font><br>
  <input type="text" name="SPLIT_AT" value="$VARIABLES::SPLIT_AT" size="20"><br>
  <font face="Verdana" size="1">
  Where to split the list and start a new page. (leave blank if none)<br>
  Example: 25,50,75  &nbsp;&nbsp; <b>(NO SPACES!)</b><br>
  This setup will be <b>4 pages</b> with ranks:<br>
  1-25 on the first<br>
  26-50 on the second<br>
  51-75 on the third<br>
  76-END on the last
  </font>
  <p>
  <font face="Verdana" size="1"><b>Break List At:</b></font><br>
  <input type="text" name="BREAK_AT" value="$VARIABLES::BREAK_AT" size="20"><br>
  <font face="Verdana" size="1">
  Where to insert breaks in the list; for banner ads, etc. (leave blank if none)<br>
  Example: 5,30,70  &nbsp;&nbsp; <b>(NO SPACES!)</b><br>
  Breaks occur after the rank indicated.
  </font>
  <p>
  <font face="Verdana" size="1"><b>Page List:</b></font><br>
  <input type="text" name="PAGE_LIST" value="$VARIABLES::PAGE_LIST" size="30"><br>
  <font face="Verdana" size="1">
  List of html pages that the ranking list will be printed to.<br>
  The first page entered will be the page with rank one on it.<br>
  There should be one more value entered here than the number of list splits.<br>
  Example: index.html,index2.html,index3.html,index4.html
  </font>
  <p>
  <font face="Verdana" size="1"><b>Font Sizes:</b></font><br>
  <input type="text" name="FONT_SIZES" value="$VARIABLES::FONT_SIZES" size="30"><br>
  <font face="Verdana" size="1">
  List of font sizes and corresponding ranks.<br>
  Example: 5=>4,25=>3,50=>2,100=>1<br>
  This setup will use a font size of:<br>
  4 for ranks 1-5<br>
  3 for ranks 6-25<br>
  2 for ranks 26-50<br>
  1 for ranks 51-100<br>
  Note that you must start at a low rank and work your way to a higher rank.
  </font>
  <p>
  <font face="Verdana" size="1"><b>Total Sites To List:</b></font><br>
  <input type="text" name="SITES_TO_LIST_RQ" value="$VARIABLES::SITES_TO_LIST" size="5"><br>
  <font face="Verdana" size="1">
  The total number of sites to be listed.<br>
  Example: 100
  </font>
  <p>
  <font face="Verdana" size="1"><b>Minimum Hits:</b></font><br>
  <input type="text" name="MINIMUM_HITS_RQ" value="$VARIABLES::MINIMUM_HITS" size="3"><br>
  <font face="Verdana" size="1">
  The minimum number of hits needed to get listed.<br>
  Example: 1
  </font>
  <p>
  <font face="Verdana" size="1"><b>Banners To Show:</b></font><br>
  <input type="text" name="NUM_OF_BANNERS_RQ" value="$VARIABLES::NUM_OF_BANNERS" size="3"><br>
  <font face="Verdana" size="1">
  The number of banners to show.<br>
  Example: 5
  </font>
  <p>
  <font face="Verdana" size="1"><b>Link Target:</b></font><br>
  <input type="text" name="TARGET" value="$VARIABLES::TARGET" size="30"><br>
  <font face="Verdana" size="1">
  The value to insert for the target portion of link html tags.<br>
  Example: new
  </font>
  <p>
  <font face="Verdana" size="1"><b>Site Title Max Length:</b></font><br>
  <input type="text" name="TITLE_LENGTH" value="$VARIABLES::TITLE_LENGTH" size="5"><br>
  <font face="Verdana" size="1">
  The maximum number of characters allowed for member site titles.<br>
  Example: 60
  </font>
  <p>
  <font face="Verdana" size="1"><b>Site Description Max Length:</b></font><br>
  <input type="text" name="DESC_LENGTH" value="$VARIABLES::DESC_LENGTH" size="5"><br>
  <font face="Verdana" size="1">
  The maximum number of characters allowed for member site descriptions.<br>
  Example: 255
  </font>
  <p>
  <font face="Verdana" size="1"><b>Site Title:</b></font><br>
  <input type="text" name="SITE_TITLE_RQ" value="$VARIABLES::SITE_TITLE" size="30"><br>
  <font face="Verdana" size="1">
  The title of your top list site.<br>
  Example: CGI Works Top 50
  </font>
  <p>
  <font face="Verdana" size="1"><b>E-Mail Address:</b></font><br>
  <input type="text" name="MY_EMAIL_RQ" value="$VARIABLES::MY_EMAIL" size="30"><br>
  <font face="Verdana" size="1">
  The e-mail address to associate with the list.<br>
  Example: you\@domain.com
  </font>
  <p>
  </td>
  </tr>
  
  <tr>
  <td bgcolor="#dcdcdc" valign="top">
  <font face="Arial" size="2"><b>Options</b></font>
  </td>
  <td bgcolor="#ffffff">
  <input type="checkbox" name="USING_TEMPLATE" value="1"
HTML

  print get_checkbox_value($OPTIONS::USING_TEMPLATE);
  
  print <<HTML;
  <font face="Verdana" size="1"><b>Use HTML template?</b></font>
  <br>
  <input type="checkbox" name="LOG_ERRORS" value="1"
HTML

  print get_checkbox_value($OPTIONS::LOG_ERRORS);
  
  print <<HTML;
  <font face="Verdana" size="1"><b>Log Errors?</b></font>
  <br>
  <input type="checkbox" name="COUNTING_OUT" value="1"
HTML

  print get_checkbox_value($OPTIONS::COUNTING_OUT);
  
  print <<HTML;
  <font face="Verdana" size="1"><b>Count outgoing hits?</b></font>
  <br>
  <input type="checkbox" name="USING_DOUBLE_CGI" value="1"
HTML

  print get_checkbox_value($OPTIONS::USING_DOUBLE_CGI);
  
  print <<HTML;
  <font face="Verdana" size="1"><b>Use double CGI cheat protection?</b></font>
  <br>
  <input type="checkbox" name="REVIEW_ADDITIONS" value="1"
HTML

  print get_checkbox_value($OPTIONS::REVIEW_ADDITIONS);
  
  print <<HTML;
  <font face="Verdana" size="1"><b>Review new additions before listing?</b></font>
  <br>
  <input type="checkbox" name="SEND_NEW_EMAIL" value="1"
HTML

  print get_checkbox_value($OPTIONS::SEND_NEW_EMAIL);
  
  print <<HTML;
  <font face="Verdana" size="1"><b>Send confirmation e-mail to person signing up?</b></font>
  <br>
  <hr size="1">
    <input type="checkbox" name="USING_CRON" value="1"
HTML

  print get_checkbox_value($OPTIONS::USING_CRON);
  
  print <<HTML;
  <font face="Verdana" size="1"><b>Use cron to update the list?</b><br><br>
  Set the following only if you did NOT check the box above<br><br>
  <b>Rerank time:</b></font><br>
  <input type="text" name="RERANK_TIME" value="$VARIABLES::RERANK_TIME" size="12"><br>
  <font face="Verdana" size="1">
  The number of seconds between list re-ranks<br>
  Example: 3600
  </font><p>
  <font face="Verdana" size="1"><b>Reset time:</b></font><br>
  <input type="text" name="RESET_TIME" value="$VARIABLES::RESET_TIME" size="12"><br>
  <font face="Verdana" size="1">
  The number of seconds between list resets<br>
  Example: 86400
  </font>
  <br>
  <hr size="1">
  <font face="Verdana" size="1">
  If you want to have all banners be the same size, fill in the following values<p>
  <b>Banner Height:</b></font><br>
  <input type="text" name="BANNER_HEIGHT" value="$VARIABLES::BANNER_HEIGHT" size="5"><br>
  <font face="Verdana" size="1">
  The height value to use for all banners.<br>
  Example: 60
  </font>
  <p>
  <font face="Verdana" size="1"><b>Banner Width:</b></font><br>
  <input type="text" name="BANNER_WIDTH" value="$VARIABLES::BANNER_WIDTH" size="5"><br>
  <font face="Verdana" size="1">
  The width value to use for all banners.<br>
  Example: 468
  </font>
  <p>
  </td>
  </tr>
  
  </table>
  </td></tr></table>
  
  <p>
  
  <table cellpadding="1" cellspacing="0" border="0" align="center" width="300">
  <tr>
  <td bgcolor="#000000">
  <!-- INNER TABLE --> 
  <table cellpadding="5" cellspacing="1" border="0" width="100%">
  <tr>
  <td bgcolor="#afafaf" align="center">
  <font face="Arial" size="3">
  <b>Enter Your Password</b>
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc" align="center">
  <font face="Arial" size="2">
  <b>Password: </b></font> <input type="password" name="password" size="12">
  </td>
  </tr>
  <tr>
  <td bgcolor="#ffffff" align="center">
  <input type="submit" name="submit" value="SAVE CONFIGURATION">
  </td>
  </tr>
  
  </table>
  </td></tr></table>
HTML
}  

sub print_confirmation {
  FUNCTIONS::header("Setup Confirmation");
  FUNCTIONS::open_table("Variables Successfully Recorded");
  
  print <<HTML;
  <tr>
  <td bgcolor="#ffffff">
  <font face="Verdana,Arial" size="2">
  The variables have been successfully recorded to their data file.
  You should now verify your setup and variables by pointing your browser
  to the full URL of setup.cgi with the format http://www.domain.com/cgi-bin/setup.cgi?verify
  </td>
  </tr>
HTML
  FUNCTIONS::close_table();
}

sub initialize {
  unless(-e "$FUNCTIONS::SCRIPT_DATA_DIR/errors.dat") {
    print "Could not locate errors.dat in $FUNCTIONS::SCRIPT_DATA_DIR - Make sure this file exists";
    exit;
  }
  FUNCTIONS::script_error(1018, "admin.dat") unless(-e "$FUNCTIONS::SCRIPT_DATA_DIR/admin.dat");
  
  unless(-e "$FUNCTIONS::SCRIPT_DATA_DIR/admin.epf") {
    open(ADMINPASS, ">$FUNCTIONS::SCRIPT_DATA_DIR/admin.epf") || FUNCTIONS::script_error(1002, "admin.epf");
    print ADMINPASS crypt("admin", "aa");
    close(ADMINPASS);
    chmod(0666, "$FUNCTIONS::SCRIPT_DATA_DIR/admin.epf");
    print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>Created administrative password file</b></font></div>|;
  }

  unless(-e "$FUNCTIONS::SCRIPT_DATA_DIR/variables.dat") {
    open(VARIABLES, ">$FUNCTIONS::SCRIPT_DATA_DIR/variables.dat") || FUNCTIONS::script_error(1016, "variables.dat");
    print VARIABLES "1;";
    close(VARIABLES);
    chmod(0666, "$FUNCTIONS::SCRIPT_DATA_DIR/variables.dat");
    print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>Created variables data file</b></font></div>|;
  }
}

sub verify_input {
  my($key, $real_key, @last_split, $last);
  for $key (keys(%FUNCTIONS::FORM)) {
    $FUNCTIONS::FORM{$key} =~ s/"//g;
    $real_key = $key; $real_key =~ s/_RQ//; $real_key =~ s/_/ /;
    FUNCTIONS::data_error(1001, "$real_key Left Blank") if($key =~ /_RQ/ && $FUNCTIONS::FORM{$key} eq "");
  }
  @last_split = split(/,/, $FUNCTIONS::FORM{'SPLIT_AT'});
  $last = @last_split;
  FUNCTIONS::data_error(1021, "Invalid 'Total Sites To List' Value") if($FUNCTIONS::FORM{'SITES_TO_LIST_RQ'} <= $last_split[$last - 1]);
  FUNCTIONS::data_error(1015, "Unmatched Page List/Split Locations") unless(split(/,/, $FUNCTIONS::FORM{'PAGE_LIST'}) == (split(/,/, $FUNCTIONS::FORM{'SPLIT_AT'}) + 1));

  FUNCTIONS::data_error(1022, "Malformed Font Sizes") unless($FUNCTIONS::FORM{'FONT_SIZES'} =~ /\d*=>\d*/ && $FUNCTIONS::FORM{'FONT_SIZES'});

  my @temp_font_sizes = split(/,/, $FUNCTIONS::FORM{'FONT_SIZES'});
  my (@ranks, @sizes, $i);
  
  for($i = 0; $i <= $temp_font_sizes[$#]; $i++) {
    ($ranks[$i], $sizes[$i]) = split(/=>/, $temp_font_sizes[$i]);
    FUNCTIONS::data_error(1022, "Malformed Font Sizes") if($ranks[$i] < $ranks[$i - 1] && defined($ranks[$i - 1]) &&  defined($ranks[$i]));
  }  
}

sub edit_variables {
  my $time = time;
  open(VARS, ">$FUNCTIONS::SCRIPT_DATA_DIR/variables.dat") || FUNCTIONS::script_error(1016, "variables.dat");
  print VARS qq|package VARIABLES;\n|;
  print VARS qq|\$VARIABLES::SITE_TITLE       = "$FUNCTIONS::FORM{'SITE_TITLE_RQ'}"\;\n|;
  print VARS qq|\$VARIABLES::HTML_DIR         = "$FUNCTIONS::FORM{'HTML_DIR_RQ'}"\;\n|;
  print VARS qq|\$VARIABLES::MEMBER_DATA_DIR  = "$FUNCTIONS::FORM{'MEMBER_DATA_DIR_RQ'}"\;\n|;
  print VARS qq|\$VARIABLES::TEMPLATE_DIR     = "$FUNCTIONS::FORM{'TEMPLATE_DIR_RQ'}"\;\n|;
  print VARS qq|\$VARIABLES::MAIL_COMMAND     = "$FUNCTIONS::FORM{'MAIL_COMMAND_RQ'}"\;\n|;
  print VARS qq|\$VARIABLES::CGI_URL          = "$FUNCTIONS::FORM{'CGI_URL_RQ'}"\;\n|;
  print VARS qq|\$VARIABLES::FORWARD_URL      = "$FUNCTIONS::FORM{'FORWARD_URL_RQ'}"\;\n|;
  print VARS qq|\$VARIABLES::MY_EMAIL         = '$FUNCTIONS::FORM{'MY_EMAIL_RQ'}'\;\n|;
  print VARS qq|\$VARIABLES::FONT_SIZES       = '$FUNCTIONS::FORM{'FONT_SIZES'}'\;\n|;
  print VARS qq|\$VARIABLES::SPLIT_AT         = "$FUNCTIONS::FORM{'SPLIT_AT'}"\;\n|;
  print VARS qq|\$VARIABLES::BREAK_AT         = "$FUNCTIONS::FORM{'BREAK_AT'}"\;\n|;
  print VARS qq|\$VARIABLES::PAGE_LIST        = "$FUNCTIONS::FORM{'PAGE_LIST'}"\;\n|;
  print VARS qq|\$VARIABLES::SITES_TO_LIST    = '$FUNCTIONS::FORM{'SITES_TO_LIST_RQ'}'\;\n|;
  print VARS qq|\$VARIABLES::MINIMUM_HITS     = '$FUNCTIONS::FORM{'MINIMUM_HITS_RQ'}'\;\n|;
  print VARS qq|\$VARIABLES::NUM_OF_BANNERS   = '$FUNCTIONS::FORM{'NUM_OF_BANNERS_RQ'}'\;\n|;
  print VARS qq|\$VARIABLES::BANNER_HEIGHT    = '$FUNCTIONS::FORM{'BANNER_HEIGHT'}'\;\n|;
  print VARS qq|\$VARIABLES::BANNER_WIDTH     = '$FUNCTIONS::FORM{'BANNER_WIDTH'}'\;\n|;
  print VARS qq|\$VARIABLES::RERANK_TIME      = '$FUNCTIONS::FORM{'RERANK_TIME'}'\;\n|;
  print VARS qq|\$VARIABLES::RESET_TIME       = '$FUNCTIONS::FORM{'RESET_TIME'}'\;\n|;
  print VARS qq|\$VARIABLES::TARGET           = "$FUNCTIONS::FORM{'TARGET'}"\;\n|;
  print VARS qq|\$VARIABLES::TITLE_LENGTH     = '$FUNCTIONS::FORM{'TITLE_LENGTH'}'\;\n|;
  print VARS qq|\$VARIABLES::DESC_LENGTH      = '$FUNCTIONS::FORM{'DESC_LENGTH'}'\;\n|;
  print VARS qq|\%VARIABLES::PAGE_DATA        = ();\n|;
  print VARS qq|package OPTIONS;\n|;
  print VARS qq|\$OPTIONS::USING_CRON         = '$FUNCTIONS::FORM{'USING_CRON'}'\;\n|;
  print VARS qq|\$OPTIONS::USING_TEMPLATE     = '$FUNCTIONS::FORM{'USING_TEMPLATE'}'\;\n|;
  print VARS qq|\$OPTIONS::COUNTING_OUT       = '$FUNCTIONS::FORM{'COUNTING_OUT'}'\;\n|;
  print VARS qq|\$OPTIONS::USING_DOUBLE_CGI   = '$FUNCTIONS::FORM{'USING_DOUBLE_CGI'}'\;\n|;
  print VARS qq|\$OPTIONS::REVIEW_ADDITIONS   = '$FUNCTIONS::FORM{'REVIEW_ADDITIONS'}'\;\n|;
  print VARS qq|\$OPTIONS::SEND_NEW_EMAIL     = '$FUNCTIONS::FORM{'SEND_NEW_EMAIL'}'\;\n|;
  print VARS qq|\$OPTIONS::LOG_ERRORS         = '$FUNCTIONS::FORM{'LOG_ERRORS'}'\;\n|;
  print VARS qq|1\; # Return true\n|;
  close(VARS);
  
  unless(-e "$FUNCTIONS::SCRIPT_DATA_DIR/time.dat") {
    if(!$FUNCTIONS::FORM{'USING_CRON'}) {
      open(TIME, ">$FUNCTIONS::SCRIPT_DATA_DIR/time.dat") || FUNCTIONS::script_error(1019, "time.dat");
      print TIME "package TIME;\n";
      print TIME "\$TIME::RERANK = $time;\n";
      print TIME "\$TIME::RESET  = $time;\n";
      print TIME "1;";
      close(TIME);
      chmod(0666, "$FUNCTIONS::SCRIPT_DATA_DIR/time.dat");
    }
  } 
}

sub display_verify {
  FUNCTIONS::header("Setup Verification");
  print qq|<font face="Verdana,Arial" size="1">CURRENT TIME: $FUNCTIONS::CURRENT_DATE</font><p>|;
  FUNCTIONS::open_table("AutoRank Pro Setup Verification", "", 2);
  
  print <<HTML;
  <tr bgcolor="#dcdcdc">
  <td align="center">
  <font face="Verdana,Arial" size="1"><b>TEST
  </td>
  <td align="center">
  <font face="Verdana,Arial" size="1"><b>TEST RESULT
  </td>
  </tr>
  <tr bgcolor="#ffffff">
  <td align="center">
  <font face="Verdana,Arial" size="1">File Manipulation In Member Data Directory
  </td>
  <td align="center">
  <font face="Verdana,Arial" size="1">
HTML

  print test($VARIABLES::MEMBER_DATA_DIR, 1);
  
  print <<HTML;
  </td>
  </tr>
  <tr bgcolor="#ffffff">
  <td align="center">
  <font face="Verdana,Arial" size="1">File Manipulation In Script Data Directory
  </td>
  <td align="center">
  <font face="Verdana,Arial" size="1">
HTML

  print test($FUNCTIONS::SCRIPT_DATA_DIR, 1);
  
  print <<HTML;
  </td>
  </tr>
  <tr bgcolor="#ffffff">
  <td align="center">
  <font face="Verdana,Arial" size="1">File Manipulation In HTML Directory
  </td>
  <td align="center">
  <font face="Verdana,Arial" size="1">
HTML

  print test($VARIABLES::HTML_DIR, 1);
  
  print <<HTML;
  </td>
  </tr>
  <tr bgcolor="#ffffff">
  <td align="center">
  <font face="Verdana,Arial" size="1">Permissions check on admin.cgi
  </td>
  <td align="center">
  <font face="Verdana,Arial" size="1">
HTML

  print test("admin.cgi", 2);
  
  print <<HTML;
  </td>
  </tr>
  <tr bgcolor="#ffffff">
  <td align="center">
  <font face="Verdana,Arial" size="1">Permissions check on accounts.cgi
  </td>
  <td align="center">
  <font face="Verdana,Arial" size="1">
HTML

  print test("accounts.cgi", 2);
  
  print <<HTML;
  </td>
  </tr>
  <tr bgcolor="#ffffff">
  <td align="center">
  <font face="Verdana,Arial" size="1">Permissions check on out.cgi
  </td>
  <td align="center">
  <font face="Verdana,Arial" size="1">
HTML

  print test("out.cgi", 2);
  
  print <<HTML;
  </td>
  </tr>
  <tr bgcolor="#ffffff">
  <td align="center">
  <font face="Verdana,Arial" size="1">Permissions check on rankem.cgi
  </td>
  <td align="center">
  <font face="Verdana,Arial" size="1">
HTML

  print test("rankem.cgi", 2);
  
  print <<HTML;
  </td>
  </tr>
HTML
  FUNCTIONS::close_table();
  
  FUNCTIONS::open_table("Information");
  print <<HTML;
  <tr bgcolor="#ffffff">
  <td>
  <font face="Verdana,Arial" size="1">
  If all of the above tests have passed, you should be ready to start running your list.
  If this is your first time setting up the script, have a look at the documentation to
  see what you need to do to get your list completely setup and ready to use.
  </td>
  </tr>
HTML
  FUNCTIONS::close_table();
}

sub test {
  my($thing_to_test, $test_type) = @_;
  if($test_type == 1) {
    open(TESTFILE, ">$thing_to_test/test.file") || return "<font color='red'>Failed!</font><br>Could Not Create File<br>$!";
    print TESTFILE "TEST PASSED!";
    close(TESTFILE);
    chmod(0666, "$thing_to_test/test.file") || return "<font color='red'>Failed!</font><br>Could Not Change Permissions on File<br>$!";
    unlink("$thing_to_test/test.file") || return "<font color='red'>Failed!</font><br>Could Not Remove File<br>$!";
    return "<font color='blue'>Passed</font>";
  }
  elsif($test_type == 2) {
    my %perms = (16895 => 777, 33279 => 777, 33261 => 755, 16877 => 755,
                 33204 => 664, 16820 => 664, 33188 => 644, 16804 => 644,
                 33060 => 444, 16676 => 444, 33206 => 666, 16822 => 666,
                 33277 => 775, 16893 => 775, 33270 => 766, 16886 => 766,
                 33252 => 744, 16868 => 744, 33276 => 774, 16892 => 774);
    
    return "<font color='red'>Failed!</font><br>Incorrect Permissions" if($perms{(stat("$thing_to_test"))[2]} != 755);
    return "<font color='blue'>Passed</font>";
  }
}

sub get_checkbox_value {
  my $value = shift;
  return " checked>" if($value);
  return ">";
}
