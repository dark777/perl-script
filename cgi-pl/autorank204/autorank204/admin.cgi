#!/usr/bin/perl
###########################
##  AutoRank Pro v2.0.4  ##
###################################################################################
##  admin.cgi                                                                    ##
##  ---------                                                                    ##
##  This script controls the administrative functions for AutoRank Pro           ##
###################################################################################

print "Content-type: text/html\n\n";
require "functions.cgi";
FUNCTIONS::script_error(1016, "variables.dat") unless(-e "$FUNCTIONS::SCRIPT_DATA_DIR/variables.dat");

if($ENV{'REQUEST_METHOD'} eq "GET") {  &display_login  }
elsif($ENV{'REQUEST_METHOD'} eq "POST") {
  &FUNCTIONS::parse;
  FUNCTIONS::data_error(1000, "Invalid Administrative Password") unless(FUNCTIONS::password_is_valid($FUNCTIONS::FORM{'password'}) || $FUNCTIONS::FORM{'submit'} eq "Reload Main Admin Page");
  if($FUNCTIONS::FORM{'submit'} eq "Log In") {  &display_admin_main  } 
  elsif($FUNCTIONS::FORM{'submit'} eq "Execute Function") {
    if($FUNCTIONS::FORM{'selection'} eq "execute_function") {  &execute_function($FUNCTIONS::FORM{'function'})  }
    elsif($FUNCTIONS::FORM{'selection'} eq "edit_files") {  &display_edit_page($FUNCTIONS::FORM{'page'}, $FUNCTIONS::FORM{'file'})  }
    elsif($FUNCTIONS::FORM{'selection'} eq "display_member") {  &display_member($FUNCTIONS::FORM{'id'})  }
    elsif($FUNCTIONS::FORM{'selection'} eq "keyword_search") {  &search_members($FUNCTIONS::FORM{'keyword'})  }
    else {  FUNCTIONS::data_error(1012, "No Command Selected")  }
  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Reload Main Admin Page") {  &display_admin_main  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Display Details") {  &display_member($FUNCTIONS::FORM{'id'})  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Edit This Member") {  &display_edit_member($FUNCTIONS::FORM{'id'})  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Delete This Member") {  &remove_member($FUNCTIONS::FORM{'id'})  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Complete Editing") {  &do_member_edit($FUNCTIONS::FORM{'id'})  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Update Header/Footer") {  &do_header_edit($FUNCTIONS::FORM{'page_code'})  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Update Template") {  &do_template_edit($FUNCTIONS::FORM{'page_code'})  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Update Table Properties") {  &do_table_edit($FUNCTIONS::FORM{'page_code'})  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Change Password") {  &do_password_edit  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Approve") {  &do_approval($FUNCTIONS::FORM{'id'})  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Decline") {  &do_decline($FUNCTIONS::FORM{'id'})  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Clear Error Log") {  &do_clear_errors  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Load Data") {  &display_edit_breaks($FUNCTIONS::FORM{'break'})  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Save Data") {  &do_break_edit($FUNCTIONS::FORM{'break'})  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Send E-Mails") {  &do_mass_mail  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Update Ban List") {  &do_ban_edit  }
  else {  FUNCTIONS::data_error(1010, "Unrecognized Command")  }
}
else { print "bye!"; exit; }

##########################################  BEGIN SUBROUTINES  ##########################################

sub display_login {
  FUNCTIONS::header("Administrative Login");
  FUNCTIONS::open_table("Administrative Login", "", "1", 300);
  print <<HTML;
  <tr>
  <form method="POST">
  <td bgcolor="#dcdcdc" align="center">
  <input type="password" name="password" size="12" maxlength="8">
  </td>
  </tr>
  <tr>
  <td bgcolor="#ffffff" align="center">
  <input type="submit" name="submit" value="Log In">
  </td></tr>
HTML
  FUNCTIONS::close_table();  
}

sub display_admin_main {
  my($hits_in, $hits_out, $total_hits, $total_mems, @files, @members, $i) = (0,0,0,0);
  my($in, $out, $tot);
  my $url = 'http://www.cgi-works.net/scripts/autorankpro/version';
  @members = FUNCTIONS::load_member_data();
  $total_mems = @members;
  
  for(@members) {
    open(DATA_FILE, "$VARIABLES::MEMBER_DATA_DIR/$_") || FUNCTIONS::script_error(1004, "$_");
    ($in, $out, $tot) = split(/\|/, <DATA_FILE>);
    $hits_in += $in;
    $hits_out += $out;
    $total_hits += $tot;
  } 
  
  &FUNCTIONS::header("AutoRank Pro Administration"); 
  open(ADMIN, "$FUNCTIONS::SCRIPT_DATA_DIR/admin.dat") || FUNCTIONS::script_error(1006, "admin.dat");
  while(<ADMIN>) { print }
  close(ADMIN);
  
  @files = split(/,/, $VARIABLES::PAGE_LIST);
  
  for($i = 0; $i <= $#files; $i++) {
    print qq|<option value="$i">$files[$i]</option>\n|;
  }
   
  print <<HTML;
  </select>
  </td>
  </tr>
  
  <tr>
  <td bgcolor="#ffffff" width="15">
  <input type="Radio" name="selection" value="display_member">
  </td>
  <td bgcolor="#dcdcdc" width="305">
  <font face="Arial" size="2">
  <b>Display Member With ID:</b></font>&nbsp;&nbsp;<input type="text" name="id" size="12">
  </td>
  </tr>
  
  <tr>
  <td bgcolor="#ffffff" width="15">
  <input type="Radio" name="selection" value="keyword_search">
  </td>
  <td bgcolor="#dcdcdc" width="305">
  <font face="Arial" size="2">
  <b>Search Members For Keyword:</b></font>&nbsp;&nbsp;<input type="text" name="keyword" size="12">
  </td>
  </tr>
  
  <tr>
  <td bgcolor="#ffffff" colspan="2">
  <div align="center">
  
  <input type="hidden" name="password" value="$FUNCTIONS::FORM{'password'}">
  <input type="submit" name="submit" value="Execute Function">
  </td>
  </tr>
  
  </table>
  </td></tr></table>

  <p>

  <table cellpadding=1 cellspacing=0 border=0>
  <tr>
  <td bgcolor="#000000">
  <!-- INNER TABLE -->
  <table cellpadding=5 cellspacing=1 border=0>
  <tr>
  <td bgcolor="#afafaf" align="center" colspan="2">
  <b><font face="Arial">SUMMARY INFORMATION<b>
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="1">
  Hits in since last reset:
  </td>
  <td bgcolor="#ffffff" align="center">
  <font face="Verdana,Arial" size="1">
  $hits_in
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="1">
  Hits out since last reset:
  </td>
  <td bgcolor="#ffffff" align="center">
  <font face="Verdana,Arial" size="1">
  $hits_out
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="1">
  Total hits in since start:
  </td>
  <td bgcolor="#ffffff" align="center">
  <font face="Verdana,Arial" size="1">
  $total_hits
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="1">
  Number of members
  </td>
  <td bgcolor="#ffffff" align="center">
  <font face="Verdana,Arial" size="1">
  $total_mems
  </td></tr>
  </table>        
  </td></tr></table>
  
  <p>
  
  <table cellpadding=1 cellspacing=0 border=0>
  <tr>
  <td bgcolor="#000000">
  <!-- INNER TABLE -->
  <table cellpadding=5 cellspacing=1 border=0>
  <tr>
  <td bgcolor="#afafaf" align="center">
  <b><font face="Arial">VERSION INFORMATION<b>
  </td>
  </tr>
  <tr>
  <td bgcolor="#ffffff">
  <font face="Verdana,Arial" size="1">
  <font size="2"><b>Your Version:</b></font> $FUNCTIONS::VERSION_NUMBER<br>
  <font size="2"><b>Latest Version:</b></font> 
  <img src="$url/current_a.gif" width=7 height=7 border="0">.<img src="$url/current_b.gif" width=7 height=7 border="0">.<img src="$url/current_c.gif" width=7 height=7 alt="" border="0">
  </td>
  </tr>
  </table>        
  </td></tr></table>
HTML
}

sub execute_function {
  my($function) = shift;
  if($function eq "Re-rank The List") {  &rerank_list  }
  elsif($function eq "Review New Signups") {  &display_new_signups  }
  elsif($function eq "Display All Members") {  &display_all  }
  elsif($function eq "Edit Signup Page") {  &display_edit_signup  }
  elsif($function eq "Edit List Breaks") {  &display_edit_breaks  }
  elsif($function eq "Edit Your Setup") {  require "setup.cgi" }
  elsif($function eq "Change Admin Password") {  &display_ch_adminpass  }
  elsif($function eq "Send E-Mail To Members") {  &display_email  }
  elsif($function eq "Ban A Site") {  &display_bans  }
  elsif($function eq "Display Error Log") {  &display_errors  }
}

sub do_ban_edit {
  my $successful = 0;
  FUNCTIONS::data_error(1013, "No URL Entered!") unless($FUNCTIONS::FORM{'url'});
  if($FUNCTIONS::FORM{'add_remove'} eq "ban") {
    open(BANNED, ">>$FUNCTIONS::SCRIPT_DATA_DIR/banned.udf") || FUNCTIONS::script_error(1015, "banned.udf");
    print BANNED "$FUNCTIONS::FORM{'url'}\n";
    close(BANNED);
    $successful = 1;
  }
  else {
    open(BANNED, "$FUNCTIONS::SCRIPT_DATA_DIR/banned.udf") || FUNCTIONS::script_error(1015, "banned.udf");
    my @ban_list = <BANNED>;
    close(BANNED);
    chomp(@ban_list);
    
    open(NEWBANNED, ">$FUNCTIONS::SCRIPT_DATA_DIR/banned.udf") || FUNCTIONS::script_error(1015, "banned.udf");
    for(@ban_list) {
      if($_ eq "$FUNCTIONS::FORM{'url'}") {  $successful = 1; next;  }
      else {  print NEWBANNED "$_\n"  }
    }
    close(NEWBANNED);
  }
  
  if($successful) {
    print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>Ban List Successfully Updated</b></font></div>|;
    &display_admin_main;
  }
  else {
    print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>URL Not Found In Ban List</b></font></div>|;
    &display_admin_main;
  }  
}

sub display_bans {
  my @ban_list = (" "); 
  FUNCTIONS::header("Ban A Site");
  print qq|<form method="POST">|;
  FUNCTIONS::open_table("Ban A Site");
  
  print <<HTML;
  <tr bgcolor="#dcdcdc">
  <td align="center">
  <font face="Verdana,Arial" size="2"><b>Site URL: </b></font>
  <input type="text" name="url" size="50"><p>
  <input type="radio" name="add_remove" value="ban" checked> <font face="Verdana,Arial" size="1">Ban This URL</font><br>
  <input type="radio" name="add_remove" value="unban"> <font face="Verdana,Arial" size="1">Un-Ban This URL</font>
  </td>
  </tr>
  <tr>
  <td align="center" bgcolor="#ffffff">
  
  <input type="hidden" name="password" value="$FUNCTIONS::FORM{'password'}">
  <input type="submit" name="submit" value="Update Ban List">
  </td>
  </tr>
HTML

  FUNCTIONS::close_table();
  
  if(-e "$FUNCTIONS::SCRIPT_DATA_DIR/banned.udf") {
    open(BANNED, "$FUNCTIONS::SCRIPT_DATA_DIR/banned.udf");
    @ban_list = <BANNED>;
    close(BANNED);
  }
    
  FUNCTIONS::open_table("Current Ban List", "", 1, 400);
    
  print <<HTML;
  <tr bgcolor="#ffffff">
  <td>
  <font face="Verdana,Arial" size="2">
HTML

  for(@ban_list) { print "$_<br>" }

  print <<HTML;
  </td>
  </tr>
HTML
  FUNCTIONS::close_table();
  &admin_footer;
}

sub do_mass_mail {
  my @members = FUNCTIONS::load_member_data();
  
  for(@members) {
    open(MEMBER, "$VARIABLES::MEMBER_DATA_DIR/$_") || FUNCTIONS::script_error(1004, "$_");
    my @data = split(/\|/, <MEMBER>);
    close(MEMBER);
    
    open(MAIL, "|$VARIABLES::MAIL_COMMAND -t") || FUNCTIONS::script_error(1005, "sendmail");
    print MAIL "To: $data[7]\nFrom: $VARIABLES::MY_EMAIL\n";
    print MAIL "Subject: $FUNCTIONS::FORM{'subject'}\n\n";
    print MAIL "$FUNCTIONS::FORM{'message'}";
    close (MAIL);
  }
  
  print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>E-Mails Successfully Sent</b></font></div>|;
  &display_admin_main;
}

sub display_email {
  FUNCTIONS::header("Send E-Mail To Members");
  print qq|<form method="POST">|;
  FUNCTIONS::open_table("Send E-Mail To Members", "", 2);
  
  print <<HTML;
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>SUBJECT</b>
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="subject">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc" valign="top">
  <font face="Verdana,Arial" size="2"><b>MESSAGE</b>
  </td>
  <td bgcolor="#ffffff">
  <textarea name="message" cols="60" rows="10"></textarea>
  </td>
  </tr>
  <tr>
  <td align="center" bgcolor="#ffffff" colspan="2">
  
  <input type="hidden" name="password" value="$FUNCTIONS::FORM{'password'}">
  <input type="submit" name="submit" value="Send E-Mails">
  </td>
  </tr>
HTML
  FUNCTIONS::close_table();   
  &admin_footer;
}

sub do_break_edit {
  my $break = shift;
  open(BREAKDATA, ">$FUNCTIONS::SCRIPT_DATA_DIR/advert_$break") || FUNCTIONS::script_error(1014, "advert_$break");
  print BREAKDATA "$FUNCTIONS::FORM{'html'}";
  close(BREAKDATA);
  
  print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>List Break Successfully Updated</b></font></div>|;
  &display_admin_main;
}

sub display_edit_breaks {
  my($break_number, @data) = shift;

  if($break_number) {
    open(BREAKDATA, "$FUNCTIONS::SCRIPT_DATA_DIR/advert_$break_number") || FUNCTIONS::script_error(1014, "advert_$break_number");
    @data = <BREAKDATA>;
    close(BREAKDATA);
  }
  
  FUNCTIONS::header("Edit List Breaks");
  print qq|<form method="POST">|;
  FUNCTIONS::open_table("Editing List Breaks");

  print <<HTML;
  <tr>
  <td bgcolor="#dcdcdc" align="center">
  <textarea name="html" cols="70" rows="10">@data</textarea><p>
  <font face="verdana,arial" size="2">
  Select List Break To Update or Load: </font>
  <select name="break">
HTML

  for (split(/,/, $VARIABLES::BREAK_AT)) {
    print qq|<option value="$_">$_|;
  }
    
  print <<HTML;
  </select>  
  </td>
  </tr>
  <tr>
  <td align="center" bgcolor="#ffffff">
  
  <input type="hidden" name="password" value="$FUNCTIONS::FORM{'password'}">
  <input type="submit" name="submit" value="Save Data">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <input type="submit" name="submit" value="Load Data">
  </td>
  </tr>
HTML
  FUNCTIONS::close_table();   
  &admin_footer;
}

sub do_clear_errors {
  open(ERRORS, ">$FUNCTIONS::SCRIPT_DATA_DIR/errors.ldf") || FUNCTIONS::script_error(1013, "errors.ldf");
  close(ERRORS);
  
  print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>Error Log Successfully Cleared</b></font></div>|;
  &display_admin_main;
}

sub display_errors {
  open(ERRORS, "$FUNCTIONS::SCRIPT_DATA_DIR/errors.ldf") || FUNCTIONS::script_error(1013, "errors.ldf");
  my @errors = <ERRORS>;
  close(ERRORS);
  
  FUNCTIONS::header("Error Log Display");
  print qq|<form method="POST">|;
  FUNCTIONS::open_table("Error Log", "", , 0, "100%");
  
  print <<HTML;
  <tr>
  <td bgcolor="#ffffff">
  <pre>
HTML

  for(@errors) { print "$_" }
  
  print <<HTML;
  </pre>
  </td>
  </tr>
  <tr>
  <td align="center" bgcolor="#ffffff">
  
  <input type="hidden" name="password" value="$FUNCTIONS::FORM{'password'}">
  <input type="submit" name="submit" value="Clear Error Log">
  </td>
  </tr>
HTML
  FUNCTIONS::close_table();   
  &admin_footer;
}

sub send_approved_email {
  my($username, $email) = @_;
  open(MAIL, "|$VARIABLES::MAIL_COMMAND -t") || FUNCTIONS::script_error(1005, "sendmail");
  print MAIL "To: $email\nFrom: $VARIABLES::MY_EMAIL\n";
  print MAIL "Subject: Addition To $VARIABLES::SITE_TITLE\n\n";
  print MAIL "Your information has been added to our database.\n";
  print MAIL "You can begin sending hits to the list at any time\n";
  print MAIL "and you will be listed, if you send enough hits, at the\n";
  print MAIL "next update.  Below is your linking information.\n\n";
  print MAIL "URL to send hits to:\n";
  print MAIL "$VARIABLES::CGI_URL/rankem.cgi?action=in&id=$username\n\n";
  print MAIL "Account Maintenance:\n";
  print MAIL "$VARIABLES::CGI_URL/accounts.cgi?login\n\n";
  print MAIL "Your User ID: $username\n\n";
  print MAIL "Thanks for joining,\nWebmaster, $VARIABLES::SITE_TITLE\n";
  print MAIL "$VARIABLES::FORWARD_URL";
  close (MAIL);
}

sub do_approval {
  my $member = shift;
  FUNCTIONS::data_error(1011, "No Member Selected") unless($member);
  $member =~ /(.*)\.rdf/;
  my $id = $1;
  rename("$VARIABLES::MEMBER_DATA_DIR/$member", "$VARIABLES::MEMBER_DATA_DIR/$id.mdf");
  
  open(DATA, "$VARIABLES::MEMBER_DATA_DIR/$id.mdf") || FUNCTIONS::script_error(1004, "$id.mdf");
  my $data = <DATA>;
  close(DATA);
  
  open(BACKUP, ">$VARIABLES::MEMBER_DATA_DIR/$id.bdf") || FUNCTIONS::script_error(1008, "$id.bdf");
  print BACKUP "$data";
  close(BACKUP);
  chmod(0644, "$VARIABLES::MEMBER_DATA_DIR/$id.bdf") || FUNCTIONS::script_error(1009, "$id.bdf");
  
  open(IPLOG, ">$VARIABLES::MEMBER_DATA_DIR/$id.idf") || FUNCTIONS::script_error(1008, "$id.idf");
  close(IPLOG);
  chmod(0666, "$VARIABLES::MEMBER_DATA_DIR/$id.idf") || FUNCTIONS::script_error(1009, "$id.idf");
  
  my @info = split(/\|/, $data);
  
  &send_approved_email($id, $info[7], $info[9]);
  
  print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>Member Successfully Approved</b></font></div>|;
  &display_new_signups;
}

sub do_decline {
  my $member = shift;
  FUNCTIONS::data_error(1011, "No Member Selected") unless($member);
  unlink("$VARIABLES::MEMBER_DATA_DIR/$member") || FUNCTIONS::script_error(1010, "$member");
  
  print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>Member Successfully Removed</b></font></div>|;
  &display_new_signups;
}

sub display_new_signups {
  FUNCTIONS::header("Listing New Signups");
  print qq|<form method="POST">|;
  FUNCTIONS::open_table("All New Signups", "", 2);
  
  print <<HTML;
  <tr bgcolor="#dcdcdc">
  <td align="center">
  <font face="Verdana,Arial" size="1">
  SELECT
  </td>
  <td align="center">
  <font face="Verdana,Arial" size="1">
  SITE DETAILS
  </td>
  </tr>
HTML

  opendir(MEMBER_DIR, "$VARIABLES::MEMBER_DATA_DIR") || FUNCTIONS::script_error(1003, $VARIABLES::MEMBER_DATA_DIR);
  my @member_files = sort(grep { m/.*\.rdf/ } readdir(MEMBER_DIR));
  closedir(MEMBER_DIR);
  
  for(@member_files) {
    open(MEMDATA, "$VARIABLES::MEMBER_DATA_DIR/$_");
    my @data = split(/\|/, <MEMDATA>);
    close(MEMDATA);
    
    print <<HTML;
    <tr bgcolor="#ffffff">
    <td align="center">
    <input type="radio" name="id" value="$_">
    </td>
    <td>
    <font face="Verdana,Arial" size="1">
    TITLE: <a href="$data[4]" target="new">$data[5]</a><br>
    DESCRIPTION: $data[6]<br>
    E-MAIL: <a href="mailto:$data[7]">$data[7]</a><br>
    BANNER: <a href="$data[8]" target="new">$data[8]</a>
    </td>
    </tr> 
HTML
  }
  
  print <<HTML;
  <tr>
  <td align="center" bgcolor="#ffffff" colspan="2">
  
  <input type="hidden" name="password" value="$FUNCTIONS::FORM{'password'}">
  <input type="submit" name="submit" value="Approve">&nbsp;&nbsp;&nbsp;&nbsp;
  <input type="submit" name="submit" value="Decline">
  </td>
  </tr>
HTML

  FUNCTIONS::close_table();   
  &admin_footer;
}

sub display_ch_adminpass {
  FUNCTIONS::header("Change Administrative Password");
  print qq|<form method="POST">|;
  FUNCTIONS::open_table("Change Administrative Password", "", 2, 475);
  
  print <<HTML;
  <tr>
  <td bgcolor="#dcdcdc" width="150">
  <font face="Verdana,Arial" size="2"><b>
  New Password:
  </td>
  <td bgcolor="#ffffff" width="230">
  <input type="password" name="new_pass" size="12" maxlength="8">
  </td>
  </tr>
  <td bgcolor="#dcdcdc" width="150">
  <font face="Verdana,Arial" size="2"><b>
  Verify New Password:
  </td>
  <td bgcolor="#ffffff" width="230">
  <input type="password" name="ver_new_pass" size="12" maxlength="8">
  </td>
  </tr>
  <tr>
  <td align="center" bgcolor="#ffffff" colspan="2">
  <font face="Verdana,Arial" size="2"><b>Current Password:</b></font>
  <input type="password" name="password" size="12" maxlength="8">&nbsp;&nbsp;&nbsp;&nbsp;
  <input type="submit" name="submit" value="Change Password">
  </td>
  </tr>
HTML

  FUNCTIONS::close_table();   
  &admin_footer;
}

sub do_password_edit {
  my($new_pass, $ver_new_pass, $crypted_pass) = ($FUNCTIONS::FORM{'new_pass'}, $FUNCTIONS::FORM{'ver_new_pass'});
  FUNCTIONS::data_error(1003, "Passwords Don't Match") unless($new_pass eq $ver_new_pass);
  
  $crypted_pass = crypt($new_pass, "aa");
  
  open(ADMINPASS, ">$FUNCTIONS::SCRIPT_DATA_DIR/admin.epf") || FUNCTIONS::script_error(1002, "admin.epf");
  print ADMINPASS "$crypted_pass";
  close(ADMINPASS);
  
  $FUNCTIONS::FORM{'password'} = $FUNCTIONS::FORM{'new_pass'};
  
  print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>Administrative Password Successfully Updated</b></font></div>|;
  &display_admin_main;
}

sub display_all {
  my $member;
  FUNCTIONS::header("Displaying All Members");
  print qq|<form method="POST">|;
  FUNCTIONS::open_table("All Members", "", 5);
  
  print <<HTML;
  <tr bgcolor="#dcdcdc">
  <td align="center">
  <font face="Verdana,Arial" size="1">
  SELECT
  </td>
  <td align="center">
  <font face="Verdana,Arial" size="1">
  SITE TITLE - DESCRIPTION
  </td>
  <td align="center" width="20">
  <font face="Verdana,Arial" size="1">
  HITS IN
  </td>
  <td align="center" width="20">
  <font face="Verdana,Arial" size="1">
  HITS OUT
  </td>
  <td align="center">
  <font face="Verdana,Arial" size="1">
  INACTIVE
  </td>
  </tr>
HTML

  my @members = FUNCTIONS::load_member_data();
  foreach $member (@members) {
    open(DATAFILE, "$VARIABLES::MEMBER_DATA_DIR/$member");
    my @data = split(/\|/, <DATAFILE>);
    close(DATAFILE);
    
    $member =~ s/\.mdf//;
    
    print <<HTML;
    <tr bgcolor="#ffffff">
    <td>
    <font face="Verdana,Arial" size="1">
    <input type="radio" name="id" value="$member"> - $member
    </td>
    <td>
    <font face="Verdana,Arial" size="1">
    <a href="$data[4]" target="new">$data[5]</a> - $data[6]
    </td>
    <td align="center" width="20">
    <font face="Verdana,Arial" size="1">
    $data[0]
    </td>
    <td align="center" width="20">
    <font face="Verdana,Arial" size="1">
    $data[1]
    </td>
    <td align="center">
    <font face="Verdana,Arial" size="1">
    $data[3] resets
    </td>
    </tr>
HTML
  }
  
  print <<HTML;
  <tr>
  <td align="center" bgcolor="#ffffff" colspan="5">
  <input type="submit" name="submit" value="Display Details">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <input type="submit" name="submit" value="Edit This Member">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <input type="submit" name="submit" value="Delete This Member">
  <input type="hidden" name="password" value="$FUNCTIONS::FORM{'password'}">
  <input type="hidden" name="display" value="all">
  </td>
  </tr>
HTML

  FUNCTIONS::close_table();   
  &admin_footer;
}

sub do_header_edit {
  my($page_code) = shift;
  if($FUNCTIONS::FORM{'edit'} eq "one") {
    open(HEADER, ">$FUNCTIONS::SCRIPT_DATA_DIR/header_$page_code") || FUNCTIONS::script_error(1011, "header_$page_code");
    print HEADER "$FUNCTIONS::FORM{'header'}";
    close(HEADER);
  
    open(FOOTER, ">$FUNCTIONS::SCRIPT_DATA_DIR/footer_$page_code") || FUNCTIONS::script_error(1012, "footer_$page_code");
    print FOOTER "$FUNCTIONS::FORM{'footer'}";
    close(FOOTER);
  }
  else {
    for(0..scalar(split(/,/, $VARIABLES::SPLIT_AT))) {
      open(HEADER, ">$FUNCTIONS::SCRIPT_DATA_DIR/header_$_") || FUNCTIONS::script_error(1011, "header_$_");
      print HEADER "$FUNCTIONS::FORM{'header'}";
      close(HEADER);
  
      open(FOOTER, ">$FUNCTIONS::SCRIPT_DATA_DIR/footer_$_") || FUNCTIONS::script_error(1012, "footer_$_");
      print FOOTER "$FUNCTIONS::FORM{'footer'}";
      close(FOOTER);
    }
  }
  
  print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>Header/Footer Successfully Updated</b></font></div>|;
  &display_admin_main;
}

sub do_table_edit {
  my($page_code) = shift;
  if($FUNCTIONS::FORM{'edit'} eq "one") {
    open(PAGEDATA, ">$FUNCTIONS::SCRIPT_DATA_DIR/pagedata_$page_code") || FUNCTIONS::script_error(1013, "pagedata_$page_code");
    print PAGEDATA "$FUNCTIONS::FORM{'border'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'cspacing'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'cpadding'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'tbl_bgcolor'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'tbl_bground'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'tbl_width'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'tr_bgcolor'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'show_in'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'show_out'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'show_rank'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'tf_face'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'tf_color'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'rf_face'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'rf_color'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'rf_size'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'io_face'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'io_color'}\n";
    print PAGEDATA "$FUNCTIONS::FORM{'io_size'}";
    close(PAGEDATA);
  }
  else {
    for(0..scalar(split(/,/, $VARIABLES::SPLIT_AT))) {
      open(PAGEDATA, ">$FUNCTIONS::SCRIPT_DATA_DIR/pagedata_$_") || FUNCTIONS::script_error(1013, "pagedata_$_");
      print PAGEDATA "$FUNCTIONS::FORM{'border'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'cspacing'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'cpadding'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'tbl_bgcolor'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'tbl_bground'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'tbl_width'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'tr_bgcolor'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'show_in'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'show_out'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'show_rank'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'tf_face'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'tf_color'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'rf_face'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'rf_color'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'rf_size'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'io_face'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'io_color'}\n";
      print PAGEDATA "$FUNCTIONS::FORM{'io_size'}";
      close(PAGEDATA);
    }
  }
  
  print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>Table Properties Successfully Updated</b></font></div>|;
  &display_admin_main;
}

sub do_template_edit {
  my($page_code) = shift;
  if($FUNCTIONS::FORM{'edit'} eq "one") {
    open(TEMPLATE, ">$FUNCTIONS::SCRIPT_DATA_DIR/pagedata_$page_code") || FUNCTIONS::script_error(1013, "pagedata_$page_code");
    print TEMPLATE "$FUNCTIONS::FORM{'template'}";
    close(TEMPLATE);
  }
  else {
    for(0..scalar(split(/,/, $VARIABLES::SPLIT_AT))) {
      open(TEMPLATE, ">$FUNCTIONS::SCRIPT_DATA_DIR/pagedata_$_") || FUNCTIONS::script_error(1013, "pagedata_$_");
      print TEMPLATE "$FUNCTIONS::FORM{'template'}";
      close(TEMPLATE);
    }
  }
  
  print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>Template Successfully Updated</b></font></div>|;
  &display_admin_main;
}

sub display_edit_header {
  my($page, $file) = @_;
  my(@header_data, @footer_data, @files);
    @files = split(/,/, "$VARIABLES::PAGE_LIST");
    if(-e "$FUNCTIONS::SCRIPT_DATA_DIR/header_$page") {
      open(HEADER, "$FUNCTIONS::SCRIPT_DATA_DIR/header_$page");
      @header_data = <HEADER>;
      close(HEADER);
    }
    
    if(-e "$FUNCTIONS::SCRIPT_DATA_DIR/footer_$page") {
      open(FOOTER, "$FUNCTIONS::SCRIPT_DATA_DIR/footer_$page");
      @footer_data = <FOOTER>;
      close(FOOTER);
    } 
    
    FUNCTIONS::header("Edit Header/Footer");
    print qq|<form method="POST">|;
    FUNCTIONS::open_table("Edit Header File For $files[$page]"); 
    print <<HTML;
    <tr>
    <td align="center" bgcolor="#dcdcdc">
    <textarea name="header" cols="55" rows="10">@header_data</textarea>
    </td>
    </tr>
    <tr>
    <td align="center" bgcolor="#afafaf">
    <font face="Verdana,Arial" size="4">
    <b>Edit Footer File For $files[$page]</b>
    </td>
    </tr>
    <tr>
    <td align="center" bgcolor="#dcdcdc">
    <textarea name="footer" cols="55" rows="10">@footer_data</textarea>
    </td>
    </tr>
    <tr>
    <td align="center" bgcolor="#ffffff">
    <input type="hidden" name="page_code" value="$page">
    <input type="hidden" name="password" value="$FUNCTIONS::FORM{'password'}">
    <table>
    <tr><td>
    <input type="radio" name="edit" value="one" checked> <font face="verdana" size="1">Use info for this page only</font><br>
    <input type="radio" name="edit" value="all"> <font face="Verdana" size="1">Use info for all pages</font><br>
    </td></tr></table>
    <input type="submit" name="submit" value="Update Header/Footer">
    </td>
    </tr>
HTML
    FUNCTIONS::close_table();   
    &admin_footer;
}

sub display_edit_template {
  my($page, $file, @template_data, @files) = @_;
  FUNCTIONS::data_error(1008, "You are not using the HTML template") unless($OPTIONS::USING_TEMPLATE);
  @files = split(/,/, "$VARIABLES::PAGE_LIST");
  if(-e "$FUNCTIONS::SCRIPT_DATA_DIR/pagedata_$page") {
    open(DATA, "$FUNCTIONS::SCRIPT_DATA_DIR/pagedata_$page");
    @template_data = <DATA>;
    close(DATA);
  } 
  
  FUNCTIONS::header("Edit Template");
  print qq|<form method="POST">|;
  FUNCTIONS::open_table("Edit Template File For $files[$page]");
  print <<HTML;
  <tr>
  <td align="center" bgcolor="#dcdcdc">
  <textarea name="template" cols="55" rows="10">@template_data</textarea>
  </td>
  </tr>
  <tr>
  <td align="center" bgcolor="#ffffff">
  <input type="hidden" name="page_code" value="$page">
  <table>
  <tr><td>
  <input type="radio" name="edit" value="one" checked> <font face="verdana" size="1">Use info for this page only</font><br>
  <input type="radio" name="edit" value="all"> <font face="Verdana" size="1">Use info for all pages</font><br>
  </td></tr></table>
  <input type="hidden" name="password" value="$FUNCTIONS::FORM{'password'}">
  <input type="submit" name="submit" value="Update Template">
  </td>
  </tr>
HTML
  FUNCTIONS::close_table();   
  &admin_footer;
}

sub display_edit_table {
  my($page, $file, @files) = @_;
  FUNCTIONS::data_error(1009, "You are using the HTML template") if($OPTIONS::USING_TEMPLATE);
  @files = split(/,/, "$VARIABLES::PAGE_LIST");
  %VARIABLES::PAGE_DATA = FUNCTIONS::load_page_data("pagedata_$page") if(-e "$FUNCTIONS::SCRIPT_DATA_DIR/pagedata_$page");
  FUNCTIONS::header("Edit Table Properties");
  print qq|<form method="POST">|;
  FUNCTIONS::open_table("Edit Table Data For $files[$page]", "", 2);
  
  print <<HTML;
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  TABLE BORDER
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="border" value="$VARIABLES::PAGE_DATA{'TABLE_BORDER'}">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  TABLE CELLSPACING
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="cspacing" value="$VARIABLES::PAGE_DATA{'TABLE_CELLSPACING'}">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  TABLE CELLPADDING
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="cpadding" value="$VARIABLES::PAGE_DATA{'TABLE_CELLPADDING'}">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  TABLE BGCOLOR
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="tbl_bgcolor" value="$VARIABLES::PAGE_DATA{'TABLE_BGCOLOR'}">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  TABLE BACKGROUND
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="tbl_bground" value="$VARIABLES::PAGE_DATA{'TABLE_BACKGROUND'}">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  TABLE WIDTH
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="tbl_width" value="$VARIABLES::PAGE_DATA{'TABLE_WIDTH'}">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  ROW BACKGROUND COLOR
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="tr_bgcolor" value="$VARIABLES::PAGE_DATA{'TR_BGCOLOR'}">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc" valign="top">
  <font face="Verdana,Arial" size="2"><b>
  OPTIONS
  </td>
  <td bgcolor="#ffffff">
  <input type="checkbox" name="show_in" value="1"
HTML

  print get_checkbox_value($VARIABLES::PAGE_DATA{'SHOW_IN'});

  print <<HTML;
  &nbsp;<font face="Verdana,Arial" size="1"><b>Show incoming hit counts</b></font><br>
  <input type="checkbox" name="show_out" value="1"
HTML

  print get_checkbox_value($VARIABLES::PAGE_DATA{'SHOW_OUT'});

  print <<HTML;
  &nbsp;<font face="Verdana,Arial" size="1"><b>Show outgoing hit counts</b></font><br>
  <input type="checkbox" name="show_rank" value="1"
HTML

  print get_checkbox_value($VARIABLES::PAGE_DATA{'SHOW_IN'});

  print <<HTML;
  &nbsp;<font face="Verdana,Arial" size="1"><b>Show site\'s rank</b></font><br> 
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  TITLE FONT FACE
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="tf_face" value="$VARIABLES::PAGE_DATA{'TITLE_FONT_FACE'}">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  TITLE FONT COLOR
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="tf_color" value="$VARIABLES::PAGE_DATA{'TITLE_FONT_COLOR'}">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  RANK FONT FACE
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="rf_face" value="$VARIABLES::PAGE_DATA{'RANK_FONT_FACE'}">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  RANK FONT COLOR
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="rf_color" value="$VARIABLES::PAGE_DATA{'RANK_FONT_COLOR'}">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  RANK FONT SIZE
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="rf_size" value="$VARIABLES::PAGE_DATA{'RANK_FONT_SIZE'}">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  IN/OUT FONT FACE
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="io_face" value="$VARIABLES::PAGE_DATA{'INOUT_FONT_FACE'}">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  IN/OUT FONT COLOR
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="io_color" value="$VARIABLES::PAGE_DATA{'INOUT_FONT_COLOR'}">
  </td>
  </tr>
  <tr>
  <td bgcolor="#dcdcdc">
  <font face="Verdana,Arial" size="2"><b>
  IN/OUT FONT SIZE
  </td>
  <td bgcolor="#ffffff">
  <input type="text" size="30" name="io_size" value="$VARIABLES::PAGE_DATA{'INOUT_FONT_SIZE'}">
  </td>
  </tr>
  <tr>
  <td align="center" bgcolor="#ffffff" colspan="2">
  <input type="hidden" name="page_code" value="$page">
  <table>
  <tr><td>
  <input type="radio" name="edit" value="one" checked> <font face="verdana" size="1">Use info for this page only</font><br>
  <input type="radio" name="edit" value="all"> <font face="Verdana" size="1">Use info for all pages</font><br>
  </td></tr></table>
  <input type="hidden" name="password" value="$FUNCTIONS::FORM{'password'}">
  <input type="submit" name="submit" value="Update Table Properties">
  </td>
  </tr>
HTML

  FUNCTIONS::close_table();   
  &admin_footer;
}

sub display_edit_page {
  my($page, $file) = @_;
  if($file eq "Header/Footer") {  &display_edit_header($page, $file)  }
  elsif($file eq "HTML Template") {  &display_edit_template($page, $file)  }
  else {  &display_edit_table($page, $file)  }      
}  

sub remove_member {
  my($member) = shift;
  unlink("$VARIABLES::MEMBER_DATA_DIR/$member.mdf") || FUNCTIONS::script_error(1010, "$member.mdf");
  unlink("$VARIABLES::MEMBER_DATA_DIR/$member.idf") || FUNCTIONS::script_error(1010, "$member.idf");
  unlink("$VARIABLES::MEMBER_DATA_DIR/$member.bdf") || FUNCTIONS::script_error(1010, "$member.bdf");
  print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>Member $member Removed Successfully</b></font></div>|;
  if($FUNCTIONS::FORM{'display'} eq "all") {
    &display_all;
  } else {
    &display_admin_main;
  }
}
  
sub display_member {
  my($member) = shift;
  FUNCTIONS::data_error(1011, "No Member Selected") unless($member);
  $member =~ s/\.mdf//i;
  FUNCTIONS::data_error(1005, "You must select a member") unless($member);
  
  if(-e "$VARIABLES::MEMBER_DATA_DIR/$member.mdf") {
    open(MEMBER, "$VARIABLES::MEMBER_DATA_DIR/$member.mdf");
    my(@member_data) = split(/\|/, <MEMBER>);
    close(MEMBER);
    $member_data[8] = "None" unless($member_data[8]);
    
    FUNCTIONS::header("Details For Member $member");
    FUNCTIONS::open_table("Details For Member $member", "", 2);
    print <<HTML;
    <form method="POST">
    <tr>
    <td bgcolor="#dcdcdc">
    <font face="Verdana,Arial" size="2"><b>
    Site Title</b></font>
    </td>
    <td bgcolor="#ffffff">
    <font face="Verdana,Arial" size="2">$member_data[5]
    </td>
    </tr>
    <tr>
    <td bgcolor="#dcdcdc">
    <font face="Verdana,Arial" size="2"><b>
    Site Description</b></font>
    </td>
    <td bgcolor="#ffffff">
    <font face="Verdana,Arial" size="2">$member_data[6]
    </td>
    </tr>
HTML

    if($VARIABLES::NUM_OF_BANNERS) {
      print <<HTML;
      <tr>
      <td bgcolor="#dcdcdc">
      <font face="Verdana,Arial" size="2"><b>
      Banner URL</b></font>
      </td>
      <td bgcolor="#ffffff">
      <font face="Verdana,Arial" size="2">$member_data[8]
      </td>
      </tr>
HTML
    }      

    print <<HTML;    
    <tr>
    <td bgcolor="#dcdcdc">
    <font face="Verdana,Arial" size="2"><b>
    Site URL</b></font>
    </td>
    <td bgcolor="#ffffff">
    <font face="Verdana,Arial" size="2">$member_data[4]
    </td>
    </tr>
    <tr>
    <td bgcolor="#dcdcdc">
    <font face="Verdana,Arial" size="2"><b>
    E-Mail Address</b></font>
    </td>
    <td bgcolor="#ffffff">
    <font face="Verdana,Arial" size="2">$member_data[7]
    </td>
    </tr>
    <tr>
    <td bgcolor="#dcdcdc">
    <font face="Verdana,Arial" size="2"><b>
    Hits In</b><font size="1"> (since last reset)</font></font>
    </td>
    <td bgcolor="#ffffff">
    <font face="Verdana,Arial" size="2">$member_data[0]
    </td>
    </tr>
    <tr>
    <td bgcolor="#dcdcdc">
    <font face="Verdana,Arial" size="2"><b>
    Hits Out</b><font size="1"> (since last reset)</font></font>
    </td>
    <td bgcolor="#ffffff">
    <font face="Verdana,Arial" size="2">$member_data[1]
    </td>
    </tr>
    <tr>
    <td bgcolor="#dcdcdc">
    <font face="Verdana,Arial" size="2"><b>
    Inactive</b></font>
    </td>
    <td bgcolor="#ffffff">
    <font face="Verdana,Arial" size="2">$member_data[3] resets
    </td>
    </tr>
    <tr>
    <td colspan="2" bgcolor="#ffffff" align="center">
    <input type="hidden" name="id" value="$FUNCTIONS::FORM{'id'}">    
    <input type="hidden" name="password" value="$FUNCTIONS::FORM{'password'}">
    <input type="submit" name="submit" value="Edit This Member">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input type="submit" name="submit" value="Delete This Member">
    </td></tr>
HTML
  
    FUNCTIONS::close_table();
    &admin_footer;
  }
  else { FUNCTIONS::data_error(1007, "Member Not Found") }
}

sub do_member_edit {
  my($username) = shift;
  my $crypted_pass, my %md = %FUNCTIONS::FORM;
  $crypted_pass = $md{'Old_Password'};
  $crypted_pass = crypt($md{'Password_New'}, "aa") if($md{'Password_New'});
  
  open(MAIN, ">$VARIABLES::MEMBER_DATA_DIR/$username.mdf") || FUNCTIONS::script_error(1008, "$username.mdf");
  print MAIN "$md{'Hits_In_RQ'}|$md{'Hits_Out_RQ'}|$md{'Total_In'}|$md{'Inactive'}|$md{'Site_URL_RQ'}|$md{'Site_Title_RQ'}|$md{'Description_RQ'}|$md{'E-Mail_RQ'}|$md{'Banner_URL'}|$crypted_pass";
  close(MAIN);
  chmod(0666, "$VARIABLES::MEMBER_DATA_DIR/$username.mdf") || FUNCTIONS::script_error(1009, "$username.mdf");
  
  chmod(0666, "$VARIABLES::MEMBER_DATA_DIR/$username.bdf") || FUNCTIONS::script_error(1009, "$username.bdf");
  open(BACKUP, ">$VARIABLES::MEMBER_DATA_DIR/$username.bdf") || FUNCTIONS::script_error(1008, "$username.bdf");
  print BACKUP "0|0|0|0|$md{'Site_URL_RQ'}|$md{'Site_Title_RQ'}|$md{'Description_RQ'}|$md{'E-Mail_RQ'}|$md{'Banner_URL'}|$crypted_pass";
  close(BACKUP);
  chmod(0644, "$VARIABLES::MEMBER_DATA_DIR/$username.bdf") || FUNCTIONS::script_error(1009, "$username.bdf");
  
  print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>Member Edited Successfully</b></font></div>|;
  if($FUNCTIONS::FORM{'display'} eq "all") {
    &display_all;
  } else {
    &display_admin_main;
  }
}

sub display_edit_member {
  my($member, @mem_data) = shift;
  FUNCTIONS::data_error(1011, "No Member Selected") unless($member);
  open(MEMBER, "$VARIABLES::MEMBER_DATA_DIR/$member.mdf");
  @mem_data = split(/\|/, <MEMBER>);
  close(MEMBER);
  
  FUNCTIONS::header("Edit Member");
  print qq|<form method="POST">|;
  FUNCTIONS::open_table("Edit Member: $member", "", 2);
  
  print <<HTML;
  <tr bgcolor="#dcdcdc">
  <td align="right">
  <font face="Verdana, Arial" size="2"><b>
  E-Mail Address</b>
  </td>
  <td bgcolor="white">
  <input type="text" name="E-Mail_RQ" size="30" value="$mem_data[7]">
  </td>
  </tr>  
  <tr bgcolor="#dcdcdc">
  <td align="right">
  <font face="Verdana, Arial" size="2"><b>
  Site Title</b>
  </td>
  <td bgcolor="white">
  <input type="text" name="Site_Title_RQ" size="30" value="$mem_data[5]" maxlength="$VARIABLES::TITLE_LENGTH">
  </td>
  </tr>
  <tr bgcolor="#dcdcdc">
  <td align="right">
  <font face="Verdana, Arial" size="2"><b>
  Site URL</b>
  </td>
  <td bgcolor="white">
  <input type="text" name="Site_URL_RQ" size="50" value="$mem_data[4]">
  </td>
  </tr>
  <tr bgcolor="#dcdcdc">
  <td align="right">
  <font face="Verdana, Arial" size="2"><b>
  Description</b>
  </td>
  <td bgcolor="white">
  <input type="text" name="Description_RQ" size="50" value="$mem_data[6]" maxlength="$VARIABLES::DESC_LENGTH">
  </td>
  </tr>
HTML

  if($VARIABLES::NUM_OF_BANNERS) {
    print <<HTML;
    <tr bgcolor="#dcdcdc">
    <td align="right">
    <font face="Verdana, Arial" size="2"><b>
    Banner URL</b>
    </td>
    <td bgcolor="white">
    <input type="text" name="Banner_URL" size="50" value="$mem_data[8]">
    </td>
    </tr>
HTML
  }    
  
  print <<HTML;
  <tr bgcolor="#dcdcdc">
  <td align="right">
  <font face="Verdana, Arial" size="2"><b>
  Hits In</b>
  </td>
  <td bgcolor="white">
  <input type="text" name="Hits_In_RQ" size="12" maxlength="8" value="$mem_data[0]">
  </td>
  </tr>
  <tr bgcolor="#dcdcdc">
  <td align="right">
  <font face="Verdana, Arial" size="2"><b>
  Hits Out</b>
  </td>
  <td bgcolor="white">
  <input type="text" name="Hits_Out_RQ" size="12" maxlength="8" value="$mem_data[1]">
  </td>
  </tr>
  <tr bgcolor="#dcdcdc">
  <td align="right">
  <font face="Verdana, Arial" size="2"><b>
  Total Hits In</b>
  </td>
  <td bgcolor="white">
  <input type="text" name="Total_In" size="12" maxlength="8" value="$mem_data[2]">
  </td>
  </tr>
  <tr bgcolor="#dcdcdc">
  <td align="right">
  <font face="Verdana, Arial" size="2"><b>
  Password</b>
  </td>
  <td bgcolor="white">
  <input type="password" name="Password_New" size="12" maxlength="8">
  <font face="Verdana,Arial" size="1">(Leave blank to retain old password)</font>
  </td>
  </tr>
  <tr>
  <td colspan="2" align="center" bgcolor="white">
  <input type="hidden" name="Inactive" value="$mem_data[3]">
  <input type="hidden" name="Old_Password" value="$mem_data[9]">
  <input type="hidden" name="id" value="$member">
  <input type="hidden" name="display" value="$FUNCTIONS::FORM{'display'}">
  <input type="hidden" name="password" value="$FUNCTIONS::FORM{'password'}">
  <input type="submit" name="submit" value="Complete Editing">
  </td></tr>
HTML
  FUNCTIONS::close_table();
  &admin_footer;
}

sub search_members {
  my($keyword, @members, %matched, $matches, @mem_data) = shift;
  FUNCTIONS::data_error(1006, "No Keyword entered") if(!$keyword);
  @members = FUNCTIONS::load_member_data();
  $matches = 0;
  
  for(@members) {
    open(MEMBER, "$VARIABLES::MEMBER_DATA_DIR/$_");
    $matched{$_} = $_ and $matches++ if(<MEMBER> =~ /$keyword/gi);
    close(MEMBER);
  }  
  
  FUNCTIONS::header("Searched members for $keyword");
  print qq|<form method="POST">|;
  FUNCTIONS::open_table("$matches Matches For Keyword: $keyword", "", 2);
  
  print <<HTML;
  <tr bgcolor="#dcdcdc">
  <td align="center">
  <font face="Verdana,Arial" size="2"><b>Select
  </td>
  <td>
  <font face="Verdana,Arial" size="2"><b>Member Information
  </td>
  </tr>
HTML
  
  for(keys %matched) {
    $matched{$_} =~ s/\.mdf//i;
    open(MEMBER, "$VARIABLES::MEMBER_DATA_DIR/$_");
    @mem_data = split(/\|/, <MEMBER>);
    close(MEMBER);
    
    print <<HTML;
    <tr bgcolor="#ffffff">
    <td align="center">
    <input type="radio" name="id" value="$matched{$_}">
    </td>
    <td>
    <font face="Verdana,Arial" size="2">
    <a href="$mem_data[4]" target="new">$mem_data[5]</a> - $mem_data[6]<br>
    </td>
    </tr>
HTML
  }
  
  print <<HTML;
  <tr>
  <td bgcolor="#ffffff" align="center" colspan="2">
  
  <input type="hidden" name="password" value="$FUNCTIONS::FORM{'password'}">
  <input type="submit" name="submit" value="Display Details">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <input type="submit" name="submit" value="Edit This Member">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <input type="submit" name="submit" value="Delete This Member">
  </td>
  </tr>
HTML
 
  FUNCTIONS::close_table();
  &admin_footer;
}  

sub rerank_list {
  FUNCTIONS::print_the_list(FUNCTIONS::load_member_data());
  print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>List Re-Ranked Successfully</b></font></div>|;
  &display_admin_main;
}
  
sub admin_footer {
  print <<HTML;
  <p>
  <input type="submit" name="submit" value="Reload Main Admin Page">
  </form>
  </body>
  </html>
HTML
}  

sub get_checkbox_value {
  my $value = shift;
  return " checked>" if($value);
  return ">";
}  
