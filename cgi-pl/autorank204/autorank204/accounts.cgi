#!/usr/bin/perl
###########################
##  AutoRank Pro v2.0.4  ##
###################################################################################
##  accounts.cgi                                                                 ##
##  ------------                                                                 ##
##  This script controls the addition of sites to the member database            ##
###################################################################################

print "Content-type: text/html\n\n";
require "functions.cgi";
FUNCTIONS::script_error(1016, "variables.dat") unless(-e "$FUNCTIONS::SCRIPT_DATA_DIR/variables.dat");
FUNCTIONS::parse(1);

if($ENV{'REQUEST_METHOD'} eq "GET") {
  if($ENV{'QUERY_STRING'} eq "") {  &display_add_form  }
  else {  &display_login_form  }
}    
elsif($ENV{'REQUEST_METHOD'} eq "POST") {  
  if($FUNCTIONS::FORM{'submit'} eq "Submit This Data") {  &start_addition_procedure  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Log In")  {  &display_page($FUNCTIONS::FORM{'choice'})  }
  elsif($FUNCTIONS::FORM{'submit'} eq "Complete Editing") {  &do_account_edit($FUNCTIONS::FORM{'id'})  }
}
exit;

##########################################  BEGIN SUBROUTINES  ##########################################

sub display_add_form {
  my(%template);
  
  $template{'EMAIL_FIELD'} = qq|<input type="text" name="E-Mail_RQ" size="30">|;
  $template{'SITE_TITLE_FIELD'} = qq|<input type="text" name="Site_Title_RQ" size="30" maxlength="$VARIABLES::TITLE_LENGTH">|;
  $template{'SITE_URL_FIELD'} = qq|<input type="text" name="Site_URL_RQ" size="50">|;
  $template{'DESCRIPTION_FIELD'} = qq|<input type="text" name="Description_RQ" size="50" maxlength="$VARIABLES::DESC_LENGTH">|;
  $template{'BANNER_URL_FIELD'} = qq|<input type="text" name="Banner_URL" size="50">|;
  $template{'USERNAME_FIELD'} = qq|<input type="text" name="Username_RQ" size="12" maxlength="8">|;
  $template{'PASSWORD_FIELD'} = qq|<input type="password" name="Password_RQ" size="12" maxlength="8">|;
  $template{'VER_PASSWORD_FIELD'} = qq|<input type="password" name="Verify_Password_RQ" size="12" maxlength="8">|;
  $template{'SUBMIT_BUTTON'} = qq|<input type="submit" name="submit" value="Submit This Data">|;
  
  parse_template("_account_add.htmlt", %template);
} 

sub display_login_form {
  my(%template);

  $template{'USERNAME_FIELD'} = qq|<input type="text" name="username" size="12">|;
  $template{'PASSWORD_FIELD'} = qq|<input type="password" name="password" size="12">|;
  $template{'EDIT_RADIO'} = qq|<input type="radio" name="choice" value="edit" checked>|;
  $template{'STATS_RADIO'} = qq|<input type="radio" name="choice" value="stats">|;
  $template{'SUBMIT_BUTTON'} = qq|<input type="submit" name="submit" value="Log In">|;
  
  parse_template("_account_login.htmlt", %template);
}

sub display_page {
  my($what_to_display) = shift;
  if($what_to_display eq "edit") {  &display_edit  }
  else{  &display_stats  }
}

sub display_stats {
  my(%template);
  FUNCTIONS::data_error(1007, "No Account With That ID") unless(-e "$VARIABLES::MEMBER_DATA_DIR/$FUNCTIONS::FORM{'username'}.mdf");
  FUNCTIONS::data_error(1011, "Username Left Blank") unless($FUNCTIONS::FORM{'username'});
  
  open(MEMBER, "$VARIABLES::MEMBER_DATA_DIR/$FUNCTIONS::FORM{'username'}.mdf");
  my @mem_data = split(/\|/, <MEMBER>);
  close(MEMBER);
  
  FUNCTIONS::data_error(1017, "Invalid Usename/Password Combination") unless(crypt("$FUNCTIONS::FORM{'password'}", "aa") eq $mem_data[9]);
  
  $template{'HITS_IN'} = $mem_data[0];
  $template{'HITS_OUT'} = $mem_data[1];
  $template{'TOT_HITS_IN'} = $mem_data[2];
  
  parse_template("_account_stats.htmlt", %template);
}

sub display_edit {
  FUNCTIONS::data_error(1007, "No Account With That ID") unless(-e "$VARIABLES::MEMBER_DATA_DIR/$FUNCTIONS::FORM{'username'}.mdf");
  FUNCTIONS::data_error(1011, "Username Left Blank") unless($FUNCTIONS::FORM{'username'});
  
  open(MEMBER, "$VARIABLES::MEMBER_DATA_DIR/$FUNCTIONS::FORM{'username'}.mdf");
  my @mem_data = split(/\|/, <MEMBER>);
  close(MEMBER);
  
  FUNCTIONS::data_error(1017, "Invalid Usename/Password Combination") unless(crypt("$FUNCTIONS::FORM{'password'}", "aa") eq $mem_data[9]);
  
  $template{'USERNAME'} = $FUNCTIONS::FORM{'username'};
  $template{'EMAIL_FIELD'} = qq|<input type="text" name="E-Mail_RQ" size="30" value="$mem_data[7]">|;
  $template{'SITE_TITLE_FIELD'} = qq|<input type="text" name="Site_Title_RQ" size="30" value="$mem_data[5]" maxlength="$VARIABLES::TITLE_LENGTH">|;
  $template{'SITE_URL_FIELD'} = qq|<input type="text" name="Site_URL_RQ" size="50" value="$mem_data[4]">|;
  $template{'DESCRIPTION_FIELD'} = qq|<input type="text" name="Description_RQ" size="50" value="$mem_data[6]" maxlength="$VARIABLES::DESC_LENGTH">|;
  $template{'BANNER_URL_FIELD'} = qq|<input type="text" name="Banner_URL" size="50" value="$mem_data[8]">|;
  $template{'NEW_PASSWORD_FIELD'} = qq|<input type="password" name="Password_New" size="12" maxlength="8">|;
  $template{'CUR_PASSWORD_FIELD'} = qq|<input type="password" name="password" size="12" maxlength="8">|;
  $template{'SUBMIT_BUTTON'} = qq|<input type="hidden" name="id" value="$FUNCTIONS::FORM{'username'}"><input type="submit" name="submit" value="Complete Editing">|;
  
  parse_template("_account_edit.htmlt", %template);
}

sub do_account_edit {
  my($username) = shift;
  my $crypted_pass, my %md = %FUNCTIONS::FORM;
  
  FUNCTIONS::data_error(1018, "Too Many Characters Entered") if(length($FUNCTIONS::FORM{'Site_Title_RQ'}) > $VARIABLES::TITLE_LENGTH && $VARIABLES::TITLE_LENGTH);
  FUNCTIONS::data_error(1019, "Too Many Characters Entered") if(length($FUNCTIONS::FORM{'Description_RQ'}) > $VARIABLES::DESC_LENGTH && $VARIABLES::DESC_LENGTH);
  
  if(-e "$FUNCTIONS::SCRIPT_DATA_DIR/banned.udf") {
    open(BANNED, "$FUNCTIONS::SCRIPT_DATA_DIR/banned.udf") || FUNCTIONS::script_error(1015, "banned.udf");
    my @ban_list = <BANNED>;
    close(BANNED);
    chomp(@ban_list);
  
    for(@ban_list) {
      FUNCTIONS::data_error(1014, "URL Entered Has Been Banned") if($FUNCTIONS::FORM{'Site_URL_RQ'} =~ m/$_/gi);
    }
  }
  
  open(OLD, "$VARIABLES::MEMBER_DATA_DIR/$username.mdf") || FUNCTIONS::script_error(1008, "$username.mdf");
  my @data = split(/\|/, <OLD>);
  close(OLD);
  
  FUNCTIONS::data_error(1017, "Invalid Password") unless(crypt("$FUNCTIONS::FORM{'password'}", "aa") eq $data[9]);
  
  $crypted_pass = $data[9];
  $crypted_pass = crypt($md{'Password_New'}, "aa") if($md{'Password_New'});
  
  open(MAIN, ">$VARIABLES::MEMBER_DATA_DIR/$username.mdf") || FUNCTIONS::script_error(1008, "$username.mdf");
  print MAIN "$data[0]|$data[1]|$data[2]|$data[3]|$md{'Site_URL_RQ'}|$md{'Site_Title_RQ'}|$md{'Description_RQ'}|$md{'E-Mail_RQ'}|$md{'Banner_URL'}|$crypted_pass";
  close(MAIN);
  chmod(0666, "$VARIABLES::MEMBER_DATA_DIR/$username.mdf") || FUNCTIONS::script_error(1009, "$username.mdf");
  
  chmod(0666, "$VARIABLES::MEMBER_DATA_DIR/$username.bdf") || FUNCTIONS::script_error(1009, "$username.bdf");
  open(BACKUP, ">$VARIABLES::MEMBER_DATA_DIR/$username.bdf") || FUNCTIONS::script_error(1008, "$username.bdf");
  print BACKUP "0|0|0|0|$md{'Site_URL_RQ'}|$md{'Site_Title_RQ'}|$md{'Description_RQ'}|$md{'E-Mail_RQ'}|$md{'Banner_URL'}|$crypted_pass";
  close(BACKUP);
  chmod(0644, "$VARIABLES::MEMBER_DATA_DIR/$username.bdf") || FUNCTIONS::script_error(1009, "$username.bdf");
  
  print qq|<div align="center"><font face="Verdana,Arial" size="2" color="red"><b>Member Edited Successfully</b></font></div>|;
}

sub start_addition_procedure {
  my($new_username);
  &verify_input;
  
  $new_username = lc($FUNCTIONS::FORM{'Username_RQ'});
  if(-e "$VARIABLES::MEMBER_DATA_DIR/$new_username.mdf" || -e "$VARIABLES::MEMBER_DATA_DIR/$new_username.rdf") { 
    FUNCTIONS::data_error(1004, "Username Taken");
  }
  
  &send_confirmation_email($new_username) if($OPTIONS::SEND_NEW_EMAIL && !$OPTIONS::REVIEW_ADDITIONS);
  &send_admin_email($new_username) if($OPTIONS::REVIEW_ADDITIONS);
  &create_files($new_username);
  &display_confirmation_page($new_username);
}

sub verify_input {
  my($key, $real_key, @ban_list);
  for $key (keys(%FUNCTIONS::FORM)) {
    $FUNCTIONS::FORM{$key} =~ s/\|//g;
    $real_key = $key; $real_key =~ s/_RQ//; $real_key =~ s/_/ /;
    FUNCTIONS::data_error(1001, "$real_key Left Blank") if($key =~ /_RQ/ && $FUNCTIONS::FORM{$key} eq "");
    FUNCTIONS::data_error(1002, "$real_key Malformed") if($key =~ /E-Mail/ && $FUNCTIONS::FORM{$key} !~ /^[\w\d][\w\d\,\.\-]*\@([\w\d\-]+\.)+([a-zA-Z]{3}|[a-zA-Z]{2})$/);
    FUNCTIONS::data_error(1002, "$real_key Malformed") if($key =~ /URL/ && $FUNCTIONS::FORM{$key} && $FUNCTIONS::FORM{$key} !~ /^http:\/\/[\w\d\-\.]+\.[\w\d\-\.]+/);
  }
  FUNCTIONS::data_error(1003, "Passwords Don't Match") if ($FUNCTIONS::FORM{Password_RQ} ne $FUNCTIONS::FORM{Verify_Password_RQ});
  
  if(-e "$FUNCTIONS::SCRIPT_DATA_DIR/banned.udf") {
    open(BANNED, "$FUNCTIONS::SCRIPT_DATA_DIR/banned.udf") || FUNCTIONS::script_error(1015, "banned.udf");
    my @ban_list = <BANNED>;
    close(BANNED);
    chomp(@ban_list);
  
    for(@ban_list) {
      FUNCTIONS::data_error(1014, "URL Entered Has Been Banned") if($FUNCTIONS::FORM{'Site_URL_RQ'} =~ m/$_/gi);
    }
  }
  
  FUNCTIONS::data_error(1020, "Invalid Username Entered") if($FUNCTIONS::FORM{'Username_RQ'} =~ /\s/gi);
  FUNCTIONS::data_error(1018, "Too Many Characters Entered") if(length($FUNCTIONS::FORM{'Site_Title_RQ'}) > $VARIABLES::TITLE_LENGTH && $VARIABLES::TITLE_LENGTH);
  FUNCTIONS::data_error(1019, "Too Many Characters Entered") if(length($FUNCTIONS::FORM{'Description_RQ'}) > $VARIABLES::DESC_LENGTH && $VARIABLES::DESC_LENGTH);
}

sub send_confirmation_email {
  my($username) = shift;
  open(MAIL, "|$VARIABLES::MAIL_COMMAND -t") || FUNCTIONS::script_error(1005, "sendmail");
  print MAIL "To: $FUNCTIONS::FORM{'E-Mail_RQ'}\nFrom: $VARIABLES::MY_EMAIL\n";
  print MAIL "Subject: Addition To $VARIABLES::SITE_TITLE\n\n";
  print MAIL "Your information has been added to our database.\n";
  print MAIL "You can begin sending hits to the list at any time\n";
  print MAIL "and you will be listed, if you send enough hits, at the\n";
  print MAIL "next update.  Below is your linking information.\n\n";
  print MAIL "URL to send hits to:\n";
  print MAIL "$VARIABLES::CGI_URL/rankem.cgi?action=in&id=$username\n\n";
  print MAIL "Account Maintenance:\n";
  print MAIL "$VARIABLES::CGI_URL/accounts.cgi?login\n\n";
  print MAIL "Your User ID: $username\n";
  print MAIL "Your Password: $FUNCTIONS::FORM{'Password_RQ'}\n\n";
  print MAIL "Thanks for joining,\nWebmaster, $VARIABLES::SITE_TITLE\n";
  print MAIL "$VARIABLES::FORWARD_URL";
  close (MAIL);
}

sub send_admin_email {
  my($username) = shift;
  open(MAIL, "|$VARIABLES::MAIL_COMMAND -t") || FUNCTIONS::script_error(1005, "sendmail");
  print MAIL "To: $VARIABLES::MY_EMAIL\nFrom: $VARIABLES::MY_EMAIL\n";
  print MAIL "Subject: New AutoRank Pro Member\n\n";
  print MAIL "A new member has signed up for your AutoRank Pro list.\n";
  print MAIL "You can review and approve or delete this addition\n";
  print MAIL "from the administrative script of AutoRank Pro\n\n";
  close(MAIL);
}
  
sub create_files {
  my($username) = shift;
  my $crypted_pass, my $ext = "mdf", my %md = %FUNCTIONS::FORM;
  $ext = "rdf" if($OPTIONS::REVIEW_ADDITIONS);
  $crypted_pass = crypt($md{'Password_RQ'}, "aa");
  
  open(MAIN, ">$VARIABLES::MEMBER_DATA_DIR/$username.$ext") || FUNCTIONS::script_error(1008, "$username.$ext");
  print MAIN "0|0|0|0|$md{'Site_URL_RQ'}|$md{'Site_Title_RQ'}|$md{'Description_RQ'}|$md{'E-Mail_RQ'}|$md{'Banner_URL'}|$crypted_pass";
  close(MAIN);
  chmod(0666, "$VARIABLES::MEMBER_DATA_DIR/$username.$ext") || FUNCTIONS::script_error(1009, "$username.$ext");
  
  unless($OPTIONS::REVIEW_ADDITIONS) {
    open(BACKUP, ">$VARIABLES::MEMBER_DATA_DIR/$username.bdf") || FUNCTIONS::script_error(1008, "$username.bdf");
    print BACKUP "0|0|0|0|$md{'Site_URL_RQ'}|$md{'Site_Title_RQ'}|$md{'Description_RQ'}|$md{'E-Mail_RQ'}|$md{'Banner_URL'}|$crypted_pass";
    close(BACKUP);
  
    open(IPLOG, ">$VARIABLES::MEMBER_DATA_DIR/$username.idf") || FUNCTIONS::script_error(1008, "$username.idf");
    close(IPLOG);
  }  
}

sub display_confirmation_page {
  my($user, %template) = shift;
  
  $template{'USERNAME'} = $user;
  $template{'PASSWORD'} = $FUNCTIONS::FORM{'Password_RQ'};
  $template{'EMAIL'} = $FUNCTIONS::FORM{'E-Mail_RQ'};
  $template{'SITE_TITLE'} = $FUNCTIONS::FORM{'Site_Title_RQ'};
  $template{'DESCRIPTION'} = $FUNCTIONS::FORM{'Description_RQ'};
  $template{'SITE_URL'} = $FUNCTIONS::FORM{'Site_URL_RQ'};
  $template{'BANNER_URL'} = $FUNCTIONS::FORM{'Banner_URL'};
  $template{'LINK_TO_URL'} = "$VARIABLES::CGI_URL/rankem.cgi?action=in&id=$user";

  parse_template("_account_added.htmlt", %template);
}

sub parse_template {
  my($page, %template) = @_;
  open(FILE, "$VARIABLES::TEMPLATE_DIR/$page") || FUNCTIONS::script_error(1020, $page);
  my @file_contents = <FILE>;
  close(FILE);
  
  for(@file_contents) {
    $_ =~ s/#%(.*?)%#/$template{$1}/gise;
  }

  print @file_contents;
}
