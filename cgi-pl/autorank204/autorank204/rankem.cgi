#!/usr/bin/perl
###########################
##  AutoRank Pro v2.0.4  ##
###################################################################################
##  rankem.cgi                                                                   ##
##  ----------                                                                   ##
##  This script controls the counting of incoming hits to the list.              ##
###################################################################################

package RANKEM;

### Set this variable
$RANKEM::SCRIPT_DATA_DIR = "/usr/local/etc/httpd/htdocs/bettors/arp/sdata";

###################################################################################
#                    DONE EDITING THIS FILE - CHANGE NO MORE                      # 
###################################################################################
#  If any more editing is done to this file the minimum penalty will              #
#  be loss of technical support from CGI Works.  Editing of any script            #
#  can also result in a copyright violation.  Do NOT do it unless you             #
#  have received permission directly from CGI Works to do so!                     #
###################################################################################

RANKEM::problem("Could not load the variables file") unless(-e "$RANKEM::SCRIPT_DATA_DIR/variables.dat");
require "$RANKEM::SCRIPT_DATA_DIR/variables.dat";

RANKEM::parse_query();

if($RANKEM::QUERY{'action'} eq "in") {
  if($OPTIONS::USING_DOUBLE_CGI) {
    print "Content-type: text/html\n\n";
    print <<HTML;
    <html>
    <head>
    <title>$VARIABLES::SITE_TITLE</title>
    </head>
    <body bgcolor="white" text="black">
    <div align="center">
    <font face="Verdana" size="2">
    <h3>$VARIABLES::SITE_TITLE</h3>
    Click Here to <a href="$VARIABLES::CGI_URL/rankem.cgi?action=incheck&id=$RANKEM::QUERY{'id'}">Enter</a>
    </body>
    </html>
HTML
  }
  else {  &check_time unless($OPTIONS::USING_CRON); &give_hit($RANKEM::QUERY{'id'});  } 
}
elsif($RANKEM::QUERY{'action'} eq "incheck") {
  my $referer = $ENV{HTTP_REFERER};
  if($referer =~ /rankem.cgi\?action=in/g) {  &check_time unless($OPTIONS::USING_CRON); &give_hit($RANKEM::QUERY{'id'});  }
  else {  &log_error("Bad referring URL: $RANKEM::QUERY{'id'}"); print "Location: $VARIABLES::FORWARD_URL\n\n";  }
}
else {
  print "Content-type: text/html\n\n";
  print "Malformed access method";
}
exit;

sub parse_query {
  my(@pairs, $pair, $name, $value);
  @pairs = split(/&/, $ENV{'QUERY_STRING'});
  foreach $pair (@pairs) {
    ($name, $value) = split(/=/, $pair);
    $RANKEM::QUERY{$name} = $value;
  }
}

sub give_hit {
  my($id) = shift;
  if(-e "$VARIABLES::MEMBER_DATA_DIR/$id.mdf") {
    my $current_ip = $ENV{'REMOTE_ADDR'};
    
    open(IP, "+<$VARIABLES::MEMBER_DATA_DIR/$id.idf") || RANKEM::problem("Cannot access the IP log file");
    seek(IP, 0, 0);
    my $last_ip = <IP>;
    
    $last_ip =~ tr/.//;
    $current_ip =~ tr/.//;
    
    if($last_ip eq $current_ip) {
      close(IP);
      &log_error("Multiple click throughs: $id");
      print "Location: $VARIABLES::FORWARD_URL\n\n";
    }
    else {
      truncate(IP, 0);
      seek(IP, 0, 0);
      print IP "$ENV{'REMOTE_ADDR'}";
      close(IP);
      
      open(DATA, "+<$VARIABLES::MEMBER_DATA_DIR/$id.mdf") || RANKEM::problem("Couldn't open the data file for account $id");
      flock(DATA, 2);
      my ($in, $out, $totalIn, $inactive, $url, $title, $descrip, $email, $banner, $password) = split(/\|/, <DATA>);
      if($title eq "") {  close(DATA); &repair_data($id);  }
      $in++;
      $totalIn++;
      truncate(DATA, 0);
      seek(DATA, 0, 0);
      print DATA "$in|$out|$totalIn|0|$url|$title|$descrip|$email|$banner|$password|";
      close(DATA);

      print "Location: $VARIABLES::FORWARD_URL\n\n";
    }  
  }
  else {
    print "Location: $VARIABLES::FORWARD_URL\n\n";
  } 
}

sub repair_data {
  my $user = shift;
  open(BACKUP, "$VARIABLES::MEMBER_DATA_DIR/$user.bdf") || RANKEM::problem("Couldn't open the data file for account $user");
  my $line = <BACKUP>;
  close(BACKUP);
  
  open(USER, ">$VARIABLES::MEMBER_DATA_DIR/$user.mdf") || RANKEM::problem("Couldn't open the data file for account $user");
  print USER "$line";
  close(USER);
  
  print "Location: $VARIABLES::FORWARD_URL\n\n";
  exit;
}

sub check_time {
  require "$RANKEM::SCRIPT_DATA_DIR/time.dat";
  my $current_time = time;
 
  my $age = $current_time - $TIME::RERANK;
  my $lastclean = $current_time - $TIME::RESET;
 
  if ($age >= $VARIABLES::RERANK_TIME) {
    open(TIME, ">$RANKEM::SCRIPT_DATA_DIR/time.dat") || RANKEM::problem("Cannot open time data file");
    print TIME "package TIME;\n";
    print TIME "\$TIME::RERANK = $current_time;\n";
    print TIME "\$TIME::RESET  = $TIME::RESET;\n";
    print TIME "1;";
    close(TIME);
    
    require "functions.cgi";
    FUNCTIONS::print_the_list(FUNCTIONS::load_member_data());
  }

  if ($lastclean >= $VARIABLES::RESET_TIME) {
    open(TIME, ">$RANKEM::SCRIPT_DATA_DIR/time.dat") || RANKEM::problem("Cannot open time data file");
    print TIME "package TIME;\n";
    print TIME "\$TIME::RERANK = $TIME::RERANK;\n";
    print TIME "\$TIME::RESET  = $TIME::$current_time;\n";
    print TIME "1;";
    close(TIME);    

    RANKEM::reset();
  }
  close(TIME);
}

sub reset {
  my $file;
  opendir(MEMBER_DIR, "$VARIABLES::MEMBER_DATA_DIR");
  my @member_files = sort(grep { m/.*\.mdf/ } readdir(MEMBER_DIR));
  closedir(MEMBER_DIR);  

  for $file (@member_files) {
    open(DATA, "+<$VARIABLES::MEMBER_DATA_DIR/$file") || RANKEM::problem("Cannot open member data file");
    flock(DATA, 2);
    my ($in, $out, $totalIn, $inactive, $url, $title, $descrip, $email, $banner, $password) = split(/\|/, <DATA>);
    $inactive++ unless($in);
    truncate(DATA, 0);
    seek(DATA, 0, 0);
    print DATA "0|0|$totalIn|$inactive|$url|$title|$descrip|$email|$banner|$password|";
    close(DATA);
    
    $file =~ s/\.mdf/\.idf/gi;
        
    open(IPLOG, ">$VARIABLES::MEMBER_DATA_DIR/$file") || RANKEM::problem("Cannot open member IP log file");
    close(IPLOG);
  }
}

sub log_error {
  my $data = shift;
  my $date = get_date();
  if($OPTIONS::LOG_ERRORS) {
    open(ERRORS, ">>$RANKEM::SCRIPT_DATA_DIR/errors.ldf");
    print ERRORS "[ $date ]  [ Possible Cheating ] [ $ENV{'REMOTE_ADDR'} ] [ $data ]\n";
    close(ERRORS);
  }
}

sub get_date {	
  my @time_breakdown = localtime;
  my $time_of_day = "am";
  
  for(0..3) { $time_breakdown[$_] = 0 . $time_breakdown[$_] if(length($time_breakdown[$_]) < 2); } 
  
  $time_breakdown[4]++;
  ($time_breakdown[2] -= 12 and $time_of_day = "pm") if($time_breakdown[2] > 12);  ## Convert to non-military clock
  
  return "$time_breakdown[2]:$time_breakdown[1]:$time_breakdown[0]$time_of_day $time_breakdown[4]/$time_breakdown[3]/$time_breakdown[5]";
}

sub problem {
  my $description = shift;
  print "Content-type: text/html\n\n";
  print "$description<br>";
  print "$!";
  exit;
}
