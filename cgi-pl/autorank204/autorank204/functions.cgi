#!/usr/bin/perl
###########################
##  AutoRank Pro v2.0.4  ##
###################################################################################
##  CREATED ON   :  July 11, 1998                                                ##
##  LAST UPDATED :  June 2, 1999                                                 ##
##  E-MAIL       :  scripts@cgi-works.net                                        ##
##  WEB SITE     :  http://www.cgi-works.net                                     ##
###################################################################################
##               COPYRIGHT © 1998 CGI WORKS. ALL RIGHTS RESERVED                 ##
###################################################################################
##  This portion of the header appears only in this script file, but applies     ##
##  to all of the scripts that make up this software package.                    ##
##                                                                               ##
##  COPYRIGHT NOTICE                                                             ##
##  ----------------                                                             ##
##  This script is not freeware.  Any redistribution of this script without      ##
##  the written consent of  CGI Works is strictly prohibited.  Copying           ##
##  any of the code contained within these scripts and claiming it as your       ##
##  own is also prohibited.  You may not remove any of these header notices.     ##
##  By using this code you agree to indemnify CGI Works from any liability       ##
##  that might arise from it's use.                                              ##
##                                                                               ##
##  TECHNICAL SUPPORT NOTICE                                                     ##
##  ------------------------                                                     ##
##  You will not be eligible for technical support if you modify any of the      ##
##  scripts in this software package other than setting the location of perl in  ##
##  the first line of each of the scripts.  Any editing can result in copyright  ##
##  violations, and will automatically suspend your technical support.           ##
###################################################################################
##  functions.cgi                                                                ##
##  -------------                                                                ##
##  This file contains functions common to most of the scripts.                  ##
###################################################################################
package FUNCTIONS;

### Set this variable
$FUNCTIONS::SCRIPT_DATA_DIR = "/usr/local/etc/httpd/htdocs/bettors/arp/sdata";
	
###################################################################################
#                    DONE EDITING THIS FILE - CHANGE NO MORE                      # 
###################################################################################
#  If any more editing is done to this file the minimum penalty will              #
#  be loss of technical support from CGI Works.  Editing of any script            #
#  can also result in a copyright violation.  Do NOT do it unless you             #
#  have received permission directly from CGI Works to do so!                     #
###################################################################################

#use strict;
require "$FUNCTIONS::SCRIPT_DATA_DIR/variables.dat" if(-e "$FUNCTIONS::SCRIPT_DATA_DIR/variables.dat");
$FUNCTIONS::VERSION_NUMBER = "2.0.4";
$FUNCTIONS::CURRENT_DATE = get_date();
$FUNCTIONS::CURRENT = 0;
1;

####################################
##  Return current date and time  ##
####################################
sub get_date {	
  my @time_breakdown = localtime;
  my $time_of_day = "am";
  
  for(0..3) { $time_breakdown[$_] = 0 . $time_breakdown[$_] if(length($time_breakdown[$_]) < 2); } 
  
  $time_breakdown[4]++;
  ($time_breakdown[2] -= 12 and $time_of_day = "pm") if($time_breakdown[2] > 12);  ## Convert to non-military clock
  
  return "$time_breakdown[2]:$time_breakdown[1]:$time_breakdown[0]$time_of_day $time_breakdown[4]/$time_breakdown[3]/$time_breakdown[5]";
}

####################################################
##  Parse information submitted through web form  ##
####################################################
sub parse {
  my ($remove_html) = shift;
  my ($value, $name, $buffer);
  %FUNCTIONS::FORM = ();
  read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
  my @pairs = split(/&/, $buffer);
	
  for (@pairs) {
    ($name, $value) = split(/=/, $_);
    $value =~ tr/+/ /;
    $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $value =~ s/~!/ ~!/g;
    $value =~ s/<([^>]|\n)*>//g if($remove_html);
    $FUNCTIONS::FORM{$name} = $value;
  }
}

##########################
##  Parse query string  ##                
##########################
sub parse_query {
  my @pairs = split(/&/, $ENV{'QUERY_STRING'});
  my ($name, $value);
  %FUNCTIONS::QUERY = ();
  
  for (@pairs) {
    ($name, $value) = split(/=/, $_);
    $FUNCTIONS::QUERY{$name} = $value;
  }
}

########################################
##  Gather member data into an array  ##
########################################
sub load_member_data {
  my %member_hash = ();

  opendir(MEMBER_DIR, "$VARIABLES::MEMBER_DATA_DIR") || FUNCTIONS::script_error(1003, $VARIABLES::MEMBER_DATA_DIR);
  my @member_files = sort(grep { m/.*\.mdf/ } readdir(MEMBER_DIR));
  closedir(MEMBER_DIR);

  for(@member_files) {
    open(MEMBER_FILE, "$VARIABLES::MEMBER_DATA_DIR/$_");
    $member_hash{$_} = (split(/\|/, <MEMBER_FILE>))[0];
    close(MEMBER_FILE);
  }

  return (sort { $member_hash{$FUNCTIONS::b} <=> $member_hash{$FUNCTIONS::a} } keys %member_hash);
}

############################################################
##  Print footer at bottom of pages                       ##
##  Altering/Removing this code is a copyright violation  ##
############################################################
sub cgi_works_footer {
  my($fh) = shift;
  $fh = *STDOUT if(!$fh);
  print $fh <<HTML;
  <center>
  <hr width="30\%" size="1" noshade>
  <font face="Verdana,Arial" size="-2">
  Powered By <a href="http://www.cgi-works.net"> AutoRank Pro v$FUNCTIONS::VERSION_NUMBER</a>
  </body>
  </html>
HTML
}

########################################
##  Print the header on script pages  ##
########################################
sub header {
  my ($title, $fh) = @_;
  $fh = *STDOUT if(!$fh);
  print $fh <<HTML;
  <html>
  <head>
    <title>$title</title>
  <body bgcolor="white" link="blue">
  <div align="center">
HTML
}

##################################################
##  Print opening part of commonly used tables  ##
##################################################
sub open_table {
  my ($title, $fh, $csp, $width) = @_;
  $fh = *STDOUT if(!$fh);
  $width = 600 unless($width);
  print $fh <<TABLE_OPEN;
  <table cellpadding="1" cellspacing="0" border="0" align="center" width="$width">
  <tr>
  <td bgcolor="#000000">
  <!-- INNER TABLE --> 
  <table cellpadding="5" cellspacing="1" border="0" width="100\%">
  <tr>
  <td bgcolor="#afafaf" align="center" colspan="$csp">
  <font face="Verdana,Arial" size="4">
  <b>$title</b>
  </font>
  </td>
  </tr>
TABLE_OPEN
}

##################################################
##  Print closing part of commonly used tables  ##
##################################################
sub close_table {
  my($fh) = @_;
  $fh = *STDOUT if(!$fh);	
  print $fh <<TABLE_CLOSE;
  </table>
  </td></tr></table><p>
TABLE_CLOSE
}

################################
##  Check the admin password  ##
################################
sub password_is_valid {
  my $entered_password = shift;
  open(PASS, "$FUNCTIONS::SCRIPT_DATA_DIR/admin.epf") || FUNCTIONS::script_error(1002, "admin.epf");
  my $crypt_password = <PASS>;
  close(PASS);

  my $crypt_entered_password = crypt($entered_password, "aa");

  return "$crypt_password" eq "$crypt_entered_password" 
}

###################################
##  Print the list to the pages  ##
###################################
sub print_the_list {
  my(@sorted_members) = @_;
  my($i, $j, $where_to_start, $where_to_end, %ads, $font_size);
  my $members = scalar(@sorted_members);
  my(@list_splits)    = split(/,/, $VARIABLES::SPLIT_AT);
  my(@list_breaks)    = split(/,/, $VARIABLES::BREAK_AT);
  my(@pages)          = split(/,/, $VARIABLES::PAGE_LIST);
  $VARIABLES::SITES_TO_LIST = @sorted_members if($VARIABLES::SITES_TO_LIST > @sorted_members);
  for(@list_breaks) { $ads{$_} = 1; }
  
  ###############################################################
  ##                 Print list if using template              ##
  if($OPTIONS::USING_TEMPLATE) {
    for($i = 0; $i <= @list_splits; $i++) {
      my $template = load_page_data("pagedata_$i");
      
      if($i == 0) { $where_to_start = 1; }
      else { $where_to_start = $list_splits[$i - 1] + 1; }
    
      if($i == @list_splits || $list_splits[$i] > $VARIABLES::SITES_TO_LIST) { $where_to_end = $VARIABLES::SITES_TO_LIST; }
      else { $where_to_end = $list_splits[$i]; }
    
      open(CURRENT_PAGE, ">$VARIABLES::HTML_DIR/$pages[$i]") || FUNCTIONS::script_error(1001, $pages[$i]);
    
      if(-e "$FUNCTIONS::SCRIPT_DATA_DIR/header_$i") {
        open(HEADER, "$FUNCTIONS::SCRIPT_DATA_DIR/header_$i");
        while(<HEADER>) { print CURRENT_PAGE }
        close(HEADER);
      }        
    
      for($j = $where_to_start; $j <= $where_to_end; $j++) {
      	my $line = $template;
      	
      	open(MEMBER_DATA, "$VARIABLES::MEMBER_DATA_DIR/$sorted_members[$j - 1]") || FUNCTIONS::script_error(1004, $sorted_members[$j - 1]);
        my @current_data = split(/\|/, <MEMBER_DATA>);
        close(MEMBER_DATA); 
        
	$font_size = get_font_size($j);
	
        if($current_data[0] >= $VARIABLES::MINIMUM_HITS) {
          if($OPTIONS::COUNTING_OUT) {
            $sorted_members[$j - 1] =~ s/\.mdf//;
            $current_data[4] = "$VARIABLES::CGI_URL/out.cgi?$sorted_members[$j - 1]";
          }
        
          $line =~ s/#%RANK%#/$j/g;
	  $line =~ s/#%FONT_SIZE%#/$font_size/g;
          if($j <= $VARIABLES::NUM_OF_BANNERS && $current_data[8]) {
	    if($VARIABLES::BANNER_WIDTH && $VARIABLES::BANNER_HEIGHT) {
              $line =~ s/#%BANNER%#/<a href="$current_data[4]" target="$VARIABLES::TARGET"><img src="$current_data[8]" border="0" width="$VARIABLES::BANNER_WIDTH" height="$VARIABLES::BANNER_HEIGHT"><\/a><br>/g;
	    }  else  {
	      $line =~ s/#%BANNER%#/<a href="$current_data[4]" target="$VARIABLES::TARGET"><img src="$current_data[8]" border="0"><\/a><br>/g;
	    }
          }  
          else { $line =~ s/#%BANNER%#//g; }
          $line =~ s/#%TITLE%#/<a href="$current_data[4]" target="$VARIABLES::TARGET">$current_data[5]<\/a>/g;
          $line =~ s/#%IN%#/$current_data[0]/g;
          $line =~ s/#%OUT%#/$current_data[1]/g;
          $line =~ s/#%DESCRIPTION%#/$current_data[6]/g;        
        
          print CURRENT_PAGE "$line\n";
    	}
  
    	if($ads{$j} && -s "$FUNCTIONS::SCRIPT_DATA_DIR/advert_$j") {        	
          open(CURRENT_AD, "$FUNCTIONS::SCRIPT_DATA_DIR/advert_$j");
          while(<CURRENT_AD>) { print CURRENT_PAGE }
          close(CURRENT_AD);
        }	
      }
      
      if(-e "$FUNCTIONS::SCRIPT_DATA_DIR/footer_$i") {
        open(FOOTER, "$FUNCTIONS::SCRIPT_DATA_DIR/footer_$i");
        while(<FOOTER>) { print CURRENT_PAGE }
        close(FOOTER);
      }
    
      print CURRENT_PAGE qq|</table><p><font face="Verdana,Arial" size="1">Last Updated: $FUNCTIONS::CURRENT_DATE<br>|;
      print CURRENT_PAGE qq|$members Sites In Our Database</font>|;
      
      cgi_works_footer(*CURRENT_PAGE);
      close(CURRENT_PAGE);
    }
  }

  ###############################################################
  ##             Print list if NOT using template              ##
  elsif(!$OPTIONS::USING_TEMPLATE){
    for($i = 0; $i <= @list_splits; $i++) {
      %VARIABLES::PAGE_DATA = load_page_data("pagedata_$i");

      if($i == 0) { $where_to_start = 1; }
      else { $where_to_start = $list_splits[$i - 1] + 1; }

      if($i == @list_splits || $list_splits[$i] > $VARIABLES::SITES_TO_LIST) { $where_to_end = $VARIABLES::SITES_TO_LIST; }
      else { $where_to_end = $list_splits[$i]; }
    
      open(CURRENT_PAGE, ">$VARIABLES::HTML_DIR/$pages[$i]") || FUNCTIONS::script_error(1001, $pages[$i]);
    
      if(-e "$FUNCTIONS::SCRIPT_DATA_DIR/header_$i") {
        open(HEADER, "$FUNCTIONS::SCRIPT_DATA_DIR/header_$i");
        while(<HEADER>) { print CURRENT_PAGE }
        close(HEADER);
      }    

      print CURRENT_PAGE qq|<table border="$VARIABLES::PAGE_DATA{'TABLE_BORDER'}"
                                   cellspacing="$VARIABLES::PAGE_DATA{'TABLE_CELLSPACING'}"
                                   cellpadding="$VARIABLES::PAGE_DATA{'TABLE_CELLPADDING'}"
                                   width="$VARIABLES::PAGE_DATA{'TABLE_WIDTH'}"
                                   bgcolor="$VARIABLES::PAGE_DATA{'TABLE_BGCOLOR'}"
                                   background="$VARIABLES::PAGE_DATA{'TABLE_BACKGROUND'}"><tr>|;      

      print CURRENT_PAGE qq|<td align="center">\n
                            <font face="Arial" size="2">\n
                            <b>RANK</b>\n
                            </font>\n
                            </td>\n| if($VARIABLES::PAGE_DATA{'SHOW_RANK'});
                            
      print CURRENT_PAGE qq|<td align="center">\n
                            <font face="Arial" size="2">\n
                            <b>SITE</b>\n
                            </font>\n
                            </td>\n|;
                            
      print CURRENT_PAGE qq|<td align="center">\n
                            <font face="Arial" size="2">\n
                            <b>IN</b>\n
                            </font>\n
                            </td>\n| if($VARIABLES::PAGE_DATA{'SHOW_IN'});
                            
      print CURRENT_PAGE qq|<td align="center">\n
                            <font face="Arial" size="2">\n
                            <b>OUT</b>\n
                            </font>\n
                            </td>| if($VARIABLES::PAGE_DATA{'SHOW_OUT'});
                            
      print CURRENT_PAGE qq|</tr>\n|;

      for($j = $where_to_start; $j <= $where_to_end; $j++) {      
        open(MEMBER_DATA, "$VARIABLES::MEMBER_DATA_DIR/$sorted_members[$j - 1]") || FUNCTIONS::script_error(1004, $sorted_members[$j - 1]);
        my @current_data = split(/\|/, <MEMBER_DATA>);
        close(MEMBER_DATA);        
        
	$font_size = get_font_size($j);
	
        if($current_data[0] >= $VARIABLES::MINIMUM_HITS) {
          print CURRENT_PAGE qq|<tr bgcolor="$VARIABLES::PAGE_DATA{'TR_BGCOLOR'}">|;
        
          print CURRENT_PAGE qq|<td align="center">
                              <font face="$VARIABLES::PAGE_DATA{'RANK_FONT_FACE'}"
                                    size="$VARIABLES::PAGE_DATA{'RANK_FONT_SIZE'}"
                                    color="$VARIABLES::PAGE_DATA{'RANK_FONT_COLOR'}">$j</font>
                              </td>| if($VARIABLES::PAGE_DATA{'SHOW_RANK'});
                              
          print CURRENT_PAGE qq|<td align="center">
                              <font face="$VARIABLES::PAGE_DATA{'TITLE_FONT_FACE'}"
                                    size="$font_size"
                                    color="$VARIABLES::PAGE_DATA{'TITLE_FONT_COLOR'}"><a href=\"|;
                                    
          if($OPTIONS::COUNTING_OUT) {
            $sorted_members[$j - 1] =~ s/\.mdf//;
            print CURRENT_PAGE "$VARIABLES::CGI_URL/out.cgi?$sorted_members[$j - 1]";
          }
          else { print CURRENT_PAGE "$current_data[4]" }
                              
          print CURRENT_PAGE qq|\" target="$VARIABLES::TARGET">|;
        
          if($j <= $VARIABLES::NUM_OF_BANNERS && $current_data[8]) {
        	print CURRENT_PAGE qq|<img src="$current_data[8]" |;
        	print CURRENT_PAGE qq|width="$VARIABLES::BANNER_WIDTH" | if($VARIABLES::BANNER_WIDTH);
        	print CURRENT_PAGE qq|height="$VARIABLES::BANNER_HEIGHT" | if($VARIABLES::BANNER_HEIGHT);
        	print CURRENT_PAGE qq|border="0"><br>|;
          }

          print CURRENT_PAGE qq|$current_data[5]</a><br>
                              $current_data[6]</font>
                              </td>|;
                              
          print CURRENT_PAGE qq|<td align="center">
                              <font face="$VARIABLES::PAGE_DATA{'INOUT_FONT_FACE'}"
                                    size="$VARIABLES::PAGE_DATA{'INOUT_FONT_SIZE'}"
                                    color="$VARIABLES::PAGE_DATA{'INOUT_FONT_COLOR'}">$current_data[0]</font>
                              </td>\n| if($VARIABLES::PAGE_DATA{'SHOW_IN'});
                                    
          print CURRENT_PAGE qq|<td align="center">
                              <font face="$VARIABLES::PAGE_DATA{'INOUT_FONT_FACE'}"
                                    size="$VARIABLES::PAGE_DATA{'INOUT_FONT_SIZE'}"
                                    color="$VARIABLES::PAGE_DATA{'INOUT_FONT_COLOR'}">$current_data[1]</font>
                              </td>| if($VARIABLES::PAGE_DATA{'SHOW_OUT'});
        
          print CURRENT_PAGE qq|</tr>\n|;
        }
        
        if($ads{$j} && -s "$FUNCTIONS::SCRIPT_DATA_DIR/advert_$j") {
          print CURRENT_PAGE "</table>";
        
          open(CURRENT_AD, "$FUNCTIONS::SCRIPT_DATA_DIR/advert_$j");
          while(<CURRENT_AD>) { print CURRENT_PAGE }
          close(CURRENT_AD);
        	
          print CURRENT_PAGE qq|<table border="$VARIABLES::PAGE_DATA{'TABLE_BORDER'}"
                                   cellspacing="$VARIABLES::PAGE_DATA{'TABLE_CELLSPACING'}"
                                   cellpadding="$VARIABLES::PAGE_DATA{'TABLE_CELLPADDING'}"
                                   width="$VARIABLES::PAGE_DATA{'TABLE_WIDTH'}"
                                   bgcolor="$VARIABLES::PAGE_DATA{'TABLE_BGCOLOR'}"
                                   background="$VARIABLES::PAGE_DATA{'TABLE_BACKGROUND'}"><tr>|;
        }                             
      }  
  
      print CURRENT_PAGE qq|</table><p><font face="Verdana,Arial" size="1">Last Updated: $FUNCTIONS::CURRENT_DATE<br>|;
      print CURRENT_PAGE qq|$members Sites In Our Database</font>|;
  	
      if(-e "$FUNCTIONS::SCRIPT_DATA_DIR/footer_$i") {
        open(FOOTER, "$FUNCTIONS::SCRIPT_DATA_DIR/footer_$i");
        while(<FOOTER>) { print CURRENT_PAGE }
        close(FOOTER);
      }
    
      cgi_works_footer(*CURRENT_PAGE);
      close(CURRENT_PAGE);
    }
  }
  else {
    exit();
  }
}

sub get_font_size {
  my $rank = shift;
  my @temp_font_sizes = split(/,/, $VARIABLES::FONT_SIZES);
  my (@ranks, @sizes, $i);
  
  for($i = 0; $i <= $temp_font_sizes[$#]; $i++) {
    ($ranks[$i], $sizes[$i]) = split(/=>/, $temp_font_sizes[$i]);
  }
 
  if($rank <= $ranks[$FUNCTIONS::CURRENT]) {
    return $sizes[$FUNCTIONS::CURRENT];
  } else {
    $FUNCTIONS::CURRENT++;
    return $sizes[$FUNCTIONS::CURRENT];
  }
}

####################################
##  Load variables for each page  ##
####################################
sub load_page_data {
  my($page_to_load) = @_;	
	
  open(PAGE_DATA, "$FUNCTIONS::SCRIPT_DATA_DIR/$page_to_load") || FUNCTIONS::script_error(1000, $page_to_load);
  my @data = <PAGE_DATA>;
  close(PAGE_DATA);
  chomp(@data);
  
  if($OPTIONS::USING_TEMPLATE) {
    my $line;
    for(@data) { $line .= $_ }		
    return $line;
  }
  else {  	
    my %page_data = (); 
    $page_data{'TABLE_BORDER'}      = $data[0];
    $page_data{'TABLE_CELLSPACING'} = $data[1];
    $page_data{'TABLE_CELLPADDING'} = $data[2];
    $page_data{'TABLE_BGCOLOR'}     = $data[3];
    $page_data{'TABLE_BACKGROUND'}  = $data[4];
    $page_data{'TABLE_WIDTH'}       = $data[5];
    $page_data{'TR_BGCOLOR'}        = $data[6];
    $page_data{'SHOW_IN'}           = $data[7];
    $page_data{'SHOW_OUT'}          = $data[8];
    $page_data{'SHOW_RANK'}         = $data[9];
    $page_data{'TITLE_FONT_FACE'}   = $data[10];
    $page_data{'TITLE_FONT_COLOR'}  = $data[11];
    $page_data{'RANK_FONT_FACE'}    = $data[12];
    $page_data{'RANK_FONT_COLOR'}   = $data[13];
    $page_data{'RANK_FONT_SIZE'}    = $data[14];
    $page_data{'INOUT_FONT_FACE'}   = $data[15];
    $page_data{'INOUT_FONT_COLOR'}  = $data[16];
    $page_data{'INOUT_FONT_SIZE'}   = $data[17];
    
    return %page_data;
  }
}

############################
##  Print a script error  ##
############################
sub script_error {
  my($code_number, $file) = @_;
  unless(-e "$FUNCTIONS::SCRIPT_DATA_DIR/errors.dat") {
    print "Cannot locate errors.dat file!";
    exit;
  }
  require "$FUNCTIONS::SCRIPT_DATA_DIR/errors.dat";
  
  if($OPTIONS::LOG_ERRORS) {
    open(ERRORS, ">>$FUNCTIONS::SCRIPT_DATA_DIR/errors.ldf");
    print ERRORS "[ $FUNCTIONS::CURRENT_DATE ]  [ $file ] [ $ENV{'REMOTE_ADDR'} ] [ $! ]\n";
    close(ERRORS);
  }

  header("A Script Error Has Occured");
  open_table("Script Error With $file");
  print <<HTML;
  <tr>
  <td bgcolor="#dcdcdc" align="center"><font face="verdana" size="2">
  $SCRIPT_ERRORS::CODE{$code_number}
  </td>
  </tr>
  <tr>
  <td bgcolor="#ffffff" align="center">
  <font face="verdana" size="1"><b>Error Cause:</b> $!
  </td></tr>
HTML
  close_table();
  exit;
}

##########################
##  Print a data error  ##
##########################
sub data_error {
  my($code_number, $data) = @_;
  unless(-e "$FUNCTIONS::SCRIPT_DATA_DIR/errors.dat") {
    print "Cannot locate errors.dat file!";
    exit;
  }
  require "$FUNCTIONS::SCRIPT_DATA_DIR/errors.dat";
  
  if($OPTIONS::LOG_ERRORS) {
    open(ERRORS, ">>$FUNCTIONS::SCRIPT_DATA_DIR/errors.ldf");
    print ERRORS "[ $FUNCTIONS::CURRENT_DATE ]  [ Data Error ] [ $ENV{'REMOTE_ADDR'} ] [ $data ]\n";
    close(ERRORS);
  }
  
  header("A Data Error Has Occured");
  open_table("<font color=blue>Data Error:</font> $data");
  print <<HTML;
  <tr>
  <td bgcolor="#dcdcdc" align="center"><font face="verdana" size="2">
  $DATA_ERRORS::CODE{$code_number}
  </td></tr>
HTML
  close_table();
  exit;
}
