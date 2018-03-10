#!/usr/bin/perl
#
#######################################################
#		Top Sites Professional 3.05
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
# IF YOU USE CRON YOU MUST PUT THE FULL PATH TO VARIABLES.PL
require "variables.pl";

srand();
#print "Content-type: text/html\n\n ";


sub location {
if ($ENV{'REMOTE_ADDR'}) {
	print "Location: $url/$topsite_file\n\n";
}
}


##### GET TIME AND DATE #########

$current_time = time();
$reset_offset = $reset_offset * 3600;
$current_time = $current_time + $reset_offset;
@days =(Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday);
@months = (January,February,March,April,May,June,July,August,September,October,November,December);
$time = time;
$time = $time + $reset_offset;
$time = $time + $update;
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =  localtime($time);
$ampm = "a.m.";
if ($hour eq 12) { $ampm = "p.m."; }
if ($hour eq 0) { $hour = "12"; }
if ($hour > 12) {
	$hour = ($hour - 12);
	$ampm = "p.m.";
}
if ($min < 10) { $min = "0$min"; }
$todaydate = "$days[$wday], $mday $months[$mon] 19$year, ";
$todaydate = $todaydate."at $hour\:$min $ampm";
$mon++;
$year += 1900;
$now = "$mon.$mday.$year";
$sunday = $yday - $wday;

srand();
$rand_num = rand();


######## GET MEMBERS INFO AND RANK THEM ############
opendir (DIR, "$path/members") || &error("Unable to open members dir. for reading");
@file = grep { /.txt/ } readdir(DIR);
close (DIR);
$updated=0;
$files=0;
foreach $line (@file) {
	open (DAT,"<$path/members/$line")  || &error("Unable to open file $line for reading");
	if ($use_flock) {
		flock DAT, 2; 
	}
	@member = <DAT>;
	close (DAT);
	foreach $entry(@member) {
		chomp($entry);
	}
	
	if ($how_rank eq 'hitsday') {
		if ($member[0] || $show_zero){
			$total_time = $current_time - $member[2];
			$total_time = $total_time /86400;
			if ($total_time >1) {
				$ratio = $member[0] / $total_time;
				$acc[$files] = "$ratio|$line";
				$files++;	
			}
		}
	}
	elsif ($how_rank eq 'total') { 
		if ($member[0] || $show_zero){
			$acc[$files] = "$member[0]|$line";
			$files++;
		}
	}
	elsif ($how_rank eq 'today') { 
		if (($member[1] && ($member[9] eq $now)) || $show_zero){
			if ($member[9] eq $now) {
				$acc[$files] = "$member[1]|$line";
			}
			else {
				$acc[$files] = "0|$line";
			}			
			$files++;
		}
	}
	elsif ($how_rank eq 'week') { 
		if (($member[17] && ($member[16] eq $sunday)) || $show_zero){
			if ($member[16] eq $sunday) {
				$acc[$files] = "$member[17]|$line";
			}
			else {
				$acc[$files] = "0|$line";
			}			
			$files++;
		}
	}
	elsif ($how_rank eq 'month') { 
		if (($member[14] && ($member[13] eq $mon)) || $show_zero){
			if ($member[13] eq $mon) {
				$acc[$files] = "$member[14]|$line";
			}
			else {
				$acc[$files] = "0|$line";
			}			
			$files++;
		}
	}

}
@sorted = sort { $a <=> $b }@acc;
@sorts = reverse(@sorted);

if ($pages) {
	$per_page = int($ranked/$pages);
}
else {
	&error("you must configure your Top Sites First, please do this through the admin.cgi script now");
}


# SET DEFAULTS #
unless ($over_bg) {
	$over_bg = "white";
}
unless ($text_color) {
	$text_color = "black";
}
unless ($link_color) {
	$link_color = "blue";
}
unless ($table_border) {
	$table_border = 0;
}
unless ($table_padding){
	$table_padding = 0;
}
unless ($table_spacing) {
	$table_spacing = 0;
}
unless ($table_width){
	$table_width = 575;
}
unless ($table_bg){
	$table_bg = $over_bg;
}
unless ($table_head_bg){
	$table_head_bg = $over_bg;
}
unless ($text_table_head){
	$text_table_head = $text_color;
}
unless ($font_table_head){
	$font_table_head = "arial";
}
unless ($size_table_head){
	$size_table_head = "-1";
}
unless ($align_table_head){
	$align_table_head = "center";
}

$ranks = 0;
$ranking = 1;
$new_page =1;
$break_num=0;
@breaks = split(/\,/,$the_breaks);


&startpage;

## START LOOP ##
while ($ranks < $ranked) {
	@sort = split(/\|/,$sorts[$ranks]);
	if ($ranking > $per_page) {
		$ranking = 1;
		$break_num=0;
				
		&endpage;
		$new_page++;
		&startpage;
	}

	$s_rank = $ranks + 1;
	&member_rank;

	if (($ranking >= $r_1_s) && ($ranking <= $r_1_e)) {
		$r_name = $r_1_name;
		$r_image = $r_1_image;
		$r_des = $r_1_des;
		if ($r_1_fname) {	$r_fname = $r_1_fname;	}
		else {	$r_fname = "arial";	}
		if ($r_1_sname) {	$r_sname = $r_1_sname;	}
		else {	$r_sname = "3";	}
		if ($r_1_fdes) {	$r_fdes = $r_1_fdes;	}
		else {	$r_fdes = "arial";	}
		if ($r_1_fsdes) {	$r_fsdes = $r_1_fsdes;	}
		else {	$r_fsdes = "2";	}
		if ($r_bgcolor) {	$r_bgcolor = $r_1_bgcolor;	}
		else {	$r_bgcolor = $table_bg;	}
		if ($r_text) {	$r_text = $r_1_text; }
		else {	$r_text = $text_color; }
		if ($r_align) {	$r_align = $r_1_align; }
		else {	$r_align = "left";	}
	}
	elsif (($ranking >= $r_2_s) && ($ranking <= $r_2_e)) {
		$r_name = $r_2_name;
		$r_image = $r_2_image;
		$r_des = $r_2_des;
		if ($r_2_fname) {	$r_fname = $r_2_fname;	}
		else {	$r_fname = "arial";	}
		if ($r_2_sname) {	$r_sname = $r_2_sname;	}
		else {	$r_sname = "3";	}
		if ($r_2_fdes) {	$r_fdes = $r_2_fdes;	}
		else {	$r_fdes = "arial";	}
		if ($r_2_fsdes) {	$r_fsdes = $r_2_fsdes;	}
		else {	$r_fsdes = "2";	}
		if ($r_bgcolor) {	$r_bgcolor = $r_2_bgcolor;	}
		else {	$r_bgcolor = $table_bg;	}
		if ($r_text) {	$r_text = $r_2_text; }
		else {	$r_text = $text_color; }
		if ($r_align) {	$r_align = $r_2_align; }
		else {	$r_align = "left";	}
	} 
	elsif (($ranking >= $r_3_s) && ($ranking <= $r_3_e)) {
		$r_name = $r_3_name;
		$r_image = $r_3_image;
		$r_des = $r_3_des;
		if ($r_3_fname) {	$r_fname = $r_3_fname;	}
		else {	$r_fname = "arial";	}
		if ($r_3_sname) {	$r_sname = $r_3_sname;	}
		else {	$r_sname = "3";	}
		if ($r_3_fdes) {	$r_fdes = $r_3_fdes;	}
		else {	$r_fdes = "arial";	}
		if ($r_3_fsdes) {	$r_fsdes = $r_3_fsdes;	}
		else {	$r_fsdes = "2";	}
		if ($r_bgcolor) {	$r_bgcolor = $r_3_bgcolor;	}
		else {	$r_bgcolor = $table_bg;	}
		if ($r_text) {	$r_text = $r_3_text; }
		else {	$r_text = $text_color; }
		if ($r_align) {	$r_align = $r_3_align; }
		else {	$r_align = "left";	}
	} 
	elsif (($ranking >= $r_4_s) && ($ranking <= $r_4_e)) {
		$r_name = $r_4_name;
		$r_image = $r_4_image;
		$r_des = $r_4_des;
		if ($r_4_fname) {	$r_fname = $r_4_fname;	}
		else {	$r_fname = "arial";	}
		if ($r_4_sname) {	$r_sname = $r_4_sname;	}
		else {	$r_sname = "3";	}
		if ($r_4_fdes) {	$r_fdes = $r_4_fdes;	}
		else {	$r_fdes = "arial";	}
		if ($r_4_fsdes) {	$r_fsdes = $r_4_fsdes;	}
		else {	$r_fsdes = "2";	}
		if ($r_bgcolor) {	$r_bgcolor = $r_4_bgcolor;	}
		else {	$r_bgcolor = $table_bg;	}
		if ($r_text) {	$r_text = $r_4_text; }
		else {	$r_text = $text_color; }
		if ($r_align) {	$r_align = $r_4_align; }
		else {	$r_align = "left";	}
	} 

	if ($sort[1]) {
		open (DAT,"<$path/members/$sort[1]")  || &error("Unable to open file $sort[1] for reading");
		if ($use_flock) {
			flock DAT, 2; 
		}
		@acc = <DAT>;
		close (DAT);

		foreach $entry(@acc) {
			chomp ($entry);
		}
		$account  = $sort[1];
		$account =~ s/\.txt//;

		$total_time = $current_time - $acc[2];
		$total_time = $total_time /86400;
		$ratio = int($acc[0] / $total_time);
	
		unless ($acc[9] eq $now) {
			$acc[1] = 0;
			$acc[10] = 0;
		}
		unless ($acc[13] eq $mon) {
			$acc[14] = 0;
			$acc[15] = 0;
		}
		unless ($acc[16] eq $sunday) {
			$acc[17] = 0;
			$acc[18] = 0;
		}
	}
	else {
		$ratio = "-";
		$acc[0] = "-";
		$acc[1] = "-";
		$acc[10] ="-";
		$acc[11] ="-";
		$acc[14] = "-";
		$acc[15] = "-";
		$acc[17] = "-";
		$acc[18] = "-";		
	}
	$html = "<TR align=\"$r_align\" bgcolor=\"$r_bgcolor\">";
	if ($d_rank) {
		$html .= "<TD><font face=\"$r_fname\" size=\"$r_sname\" color=\"$r_text\">$s_rank</FONT></TD>\n";
	}
	
	$html .= "<TD>";
	if ($sort[1]) {	
		if ($r_name) {
			$html .= "<font face=\"$r_fname\" size=\"$r_sname\"><A HREF=\"$url_to_cgi/out.cgi?$account\" target=\"_blank\">$acc[5]</A></FONT>"; 
		}
		if ($r_image && $acc[8]) {
			$html .="<BR><A HREF=\"$url_to_cgi/out.cgi?$account\" target=\"_blank\"><IMG SRC=\"$acc[8]\" border=0></A>";
		}
		if ($r_des && $acc[7]) {
			$html .="<BR><font face=\"$r_fdes\" size=\"$r_fsdes\" color=\"$r_text\">$acc[7]</FONT>";
		}
	}
	else { 
		$html .= "<font face=\"$r_fname\" size=\"$r_sname\"><A HREF=\"$url_to_cgi/editmember.cgi\" target=\"_blank\">Your Site Here</A></FONT>";
	}

	$html .= "</TD>\n";
	
	if ($d_hitsday) {
		$html .= "<TD><font face=\"$r_fname\" size=\"$r_sname\" color=\"$r_text\">$ratio</FONT></TD>\n";
	}
	if ($d_totalin) {
		$html .= "<TD><font face=\"$r_fname\" size=\"$r_sname\" color=\"$r_text\">$acc[0]</FONT></TD>\n";
	}
	if ($d_todayin) {
		$html .= "<TD><font face=\"$r_fname\" size=\"$r_sname\" color=\"$r_text\">$acc[1]</FONT></TD>\n";
	}
	if ($d_weekin) {
		$html .= "<TD><font face=\"$r_fname\" size=\"$r_sname\" color=\"$r_text\">$acc[17]</FONT></TD>\n";
	}
	if ($d_monthin) {
		$html .= "<TD><font face=\"$r_fname\" size=\"$r_sname\" color=\"$r_text\">$acc[14]</FONT></TD>\n";
	}
	if ($d_totalout) {
		$html .= "<TD><font face=\"$r_fname\" size=\"$r_sname\" color=\"$r_text\">$acc[11]</FONT></TD>\n";
	}	
	if ($d_todayout) {
		$html .= "<TD><font face=\"$r_fname\" size=\"$r_sname\" color=\"$r_text\">$acc[10]</FONT></TD>\n";
	}
	if ($d_weekout) {
		$html .= "<TD><font face=\"$r_fname\" size=\"$r_sname\" color=\"$r_text\">$acc[18]</FONT></TD>\n";
	}
	if ($d_monthout) {
		$html .= "<TD><font face=\"$r_fname\" size=\"$r_sname\" color=\"$r_text\">$acc[15]</FONT></TD>\n";
	}
	$html .= "</TR>\n";
	print HTML "$html";	


	## AD BREAKS ##
	if ($breaks[$break_num] == $ranking) {
		&ad_breaks;
		$break_num++;
	}

	$ranking++;
	$ranks++;

}

&endpage;
&location;
exit;

##########

sub startpage {

	@filename = split(/\./,$topsite_file);

	if ($new_page == 1) {
		$file_page = "";
	}
	else {
		$file_page = $new_page;
	}
	unlink ("$topsites_path/$filename[0]$file_page.$filename[1]");
	open (HTML,">$topsites_path/$filename[0]$file_page.$filename[1]")  || &error("$topsites_path/$filename[0]$file_page.$filename[1] for writing");
	if ($use_flock) {
		flock HTML, 2; 
	}
	
	&htmltop;
	&sotm;
	if ($next_update) {
		print HTML "<div align=center><font size=1 face=arial>Next Update: $todaydate</DIV><BR>";
	}
	&tabletop;

}

########## HTML HEADER AND BODY ##########
sub htmltop {

	print HTML "<HTML><HEAD><TITLE>$topsite_name</TITLE></HEAD>";
	print HTML "<BODY bgcolor=\"$over_bg\" ";
	if ($bg_image) {
		print HTML "background=\"$bg_image\" ";
	}
	print HTML "text=\"$text_color\" link=\"$link_color\">\n";
	$head_page = $new_page-1;
	$head_path = "$path/data/$headers[$head_page]";
	open (HEAD, "$head_path");
	@head = <HEAD>;
	close (HEAD);
	@head = reverse(@head);
	pop(@head);
	@head = reverse(@head);
	foreach $line (@head) {
		print HTML"$line";
	}

}

########## SITE OF THE MOMENT STUFF ##########
sub sotm {

	$r_name = $r_1_name;
	$r_image = $r_1_image;
	$r_des = $r_1_des;
	$r_fname = $r_1_fname;
	$r_sname = $r_1_sname;
	$r_fdes = $r_1_fdes;
	$r_fsdes = $r_1_fsdes;
	$r_bgcolor = $r_1_bgcolor;
	$r_text = $r_1_text;			
	$r_align = $r_1_align;


$sotm_num =0;

if ($sotm_1) {
	$sotm_num++;
}
if ($sotm_2) {
	$sotm_num++;
}
if ($sotm_3) {
	$sotm_num++;
}
if ($sotm_4) {
	$sotm_num++;
}


if ($sotm_num) {
	$cols = '';
	if ($sotm_num > 1) {
		$cols = "colspan\=2"; 
	}
	
	print HTML "<DIV ALIGN=CENTER><TABLE bgcolor=\"$table_bg\" border=\"$table_border\" cellpadding=\"$table_padding\" cellspacing=\"$table_spacing\">\n";
	print HTML "<TR bgcolor=\"$table_head_bg\" align=\"$align_table_head\"><TD $cols>";
	print HTML "<font face=\"$font_table_head\" size=\"$size_table_head\" color=\"$text_table_head\">$sotm_name</FONT></TD></TR>\n";

	$ac =1;
	while ($ac < 5) {
		if ($ac == 1) {
			$sotmm = $sotm_1;
			$sotm_how = $sotm_1_how;
			$sotm_account = $sotm_1_account;
			$sotm_acc_des = $sotm_1_acc_des;			 
			$sotm_acc_ban = $sotm_1_acc_ban;
			$sotm_w_name = $sotm_1_w_name;
			$sotm_w_url = $sotm_1_w_url;
			$sotm_w_des = $sotm_1_w_des;
			$sotm_w_ban = $sotm_1_w_ban;
		}
		if ($ac == 2) {
			$sotmm = $sotm_2;
			$sotm_how = $sotm_2_how;
			$sotm_account = $sotm_2_account;
			$sotm_acc_des = $sotm_2_acc_des;			 
			$sotm_acc_ban = $sotm_2_acc_ban;
			$sotm_w_name = $sotm_2_w_name;
			$sotm_w_url = $sotm_2_w_url;
			$sotm_w_des = $sotm_2_w_des;
			$sotm_w_ban = $sotm_2_w_ban;
		}
		if ($ac == 3) {
			$sotmm = $sotm_3;
			$sotm_how = $sotm_3_how;
			$sotm_account = $sotm_3_account;
			$sotm_acc_des = $sotm_3_acc_des;			 
			$sotm_acc_ban = $sotm_3_acc_ban;
			$sotm_w_name = $sotm_3_w_name;
			$sotm_w_url = $sotm_3_w_url;
			$sotm_w_des = $sotm_3_w_des;
			$sotm_w_ban = $sotm_3_w_ban;
		}
		if ($ac == 4) {
			$sotmm = $sotm_4;
			$sotm_how = $sotm_4_how;
			$sotm_account = $sotm_4_account;
			$sotm_acc_des = $sotm_4_acc_des;			 
			$sotm_acc_ban = $sotm_4_acc_ban;
			$sotm_w_name = $sotm_4_w_name;
			$sotm_w_url = $sotm_4_w_url;
			$sotm_w_des = $sotm_4_w_des;
			$sotm_w_ban = $sotm_4_w_ban;
		}
		if ($sotmm) {
			if ($sotmm_num == 0) {
				print HTML "<TR align=\"$r_align\" bgcolor=\"$r_bgcolor\">";
			}
			$cols = '';
			if ($sotm_num == 1) {
				$cols = "colspan\=2"; 
			}
			if (($ac == 3) && !($sotm_4) && ($sotmm_num == 0)) {
				$cols = "colspan\=2"; 
			}
			if (($ac == 4) && ($sotmm_num == 0)) {
				$cols = "colspan\=2"; 
			}
			if ($sotm_how eq "random") {
				$rand_num = rand();
				$files = push(@file);
				$rand_num = int($rand_num * $files);  
				
				open (DAT,"<$path/members/$file[$rand_num]");
				if ($use_flock) {
					flock DAT, 2; 
				}
				@acc = <DAT>;
				close (DAT);
				$account  = $file[$rand_num];
				$account =~ s/\.txt//;

				print HTML "<TD $cols><font face=\"$r_fname\" size=\"$r_sname\"><A HREF=\"$url_to_cgi/out.cgi?$account\" target=\"_blank\">$acc[5]</A></FONT>"; 
				if ($sotm_acc_ban && $acc[8]) {
					print HTML "<BR><A HREF=\"$url_to_cgi/out.cgi?$account\" target=\"_blank\"><IMG SRC=\"$acc[8]\" border=0></A>";
				}
				if ($sotm_acc_des) {
					print HTML "<BR><font face=\"$r_fdes\" size=\"$r_sdes\" color=\"$r_text\">$acc[7]</FONT>";
				}
				print HTML "</TD>";
			}
			elsif ($sotm_how eq "account"){
				open (DAT,"<$path/members/$sotm_account.txt");
				if ($use_flock) {
					flock DAT, 2; 
				}
				@acc = <DAT>;
				close (DAT);
				$account  = $sotm_account;
				$account =~ s/\.txt//;

				print HTML "<TD $cols><font face=\"$r_fname\" size=\"$r_sname\"><A HREF=\"$url_to_cgi/out.cgi?$account\" target=\"_blank\">$acc[5]</A></FONT>"; 
				if ($sotm_acc_ban && $acc[8]) {
					print HTML "<BR><A HREF=\"$url_to_cgi/out.cgi?$account\" target=\"_blank\"><IMG SRC=\"$acc[8]\" border=0></A>";
				}
				if ($sotm_acc_des) {
					print HTML "<BR><font face=\"$r_fdes\" size=\"$r_sdes\" color=\"$r_text\">$acc[7]</FONT>";
				}
				print HTML "</TD>";			
			}
			elsif ($sotm_how eq "write"){
				print HTML "<TD $cols>";
				if ($sotm_w_name) {
					print HTML "<font face=\"$r_fname\" size=\"$r_sname\"><A HREF=\"$sotm_w_url\" target=\"_blank\">$sotm_w_name</A></FONT>"; 
				}
				if ($sotm_w_ban) {
					print HTML "<BR><A HREF=\"$sotm_w_url\" target=\"_blank\"><IMG SRC=\"$sotm_w_ban\" border=0></A>";
				}
				if ($sotm_w_des) {
					print HTML "<BR><font face=\"$r_fdes\" size=\"$r_sdes\" color=\"$r_text\">$sotm_w_des</FONT>";
				}
				print HTML "</TD>";			
			}
			$sotmm_num++;
			if ($sotmm_num == 2) {
				print HTML "</TR>";
				$sotmm_num =0;
			}			
		}	
	$ac++;
	} 
print HTML "</TABLE><BR>";
}

}

sub tabletop {

	$html = "<DIV ALIGN=CENTER><TABLE bgcolor=\"$table_bg\" border=\"$table_border\" cellpadding=\"$table_padding\" cellspacing=\"$table_spacing\" width=\"$table_width\">\n";
	$html .= "<TR bgcolor=\"$table_head_bg\" align=\"$align_table_head\">";

	if ($d_rank) {
		$html .= "<TD><font face=\"$font_table_head\" size=\"$size_table_head\" color=\"$text_table_head\">Rank</FONT></TD>\n";
	}
	
	$html .= "<TD width=100\%><font face=\"$font_table_head\" size=\"$size_table_head\" color=\"$text_table_head\">Site</FONT></TD>\n";
	
	if ($d_hitsday) {
		$html .= "<TD><font face=\"$font_table_head\" size=\"$size_table_head\" color=\"$text_table_head\">Hits\&nbsp\;per\&nbsp\;day</FONT></TD>\n";
	}
	if ($d_totalin) {
		$html .= "<TD><font face=\"$font_table_head\" size=\"$size_table_head\" color=\"$text_table_head\">Total\&nbsp\;In</FONT></TD>\n";
	}
	if ($d_todayin) {
		$html .= "<TD><font face=\"$font_table_head\" size=\"$size_table_head\" color=\"$text_table_head\">In\&nbsp\;Today</FONT></TD>\n";
	}
	if ($d_weekin) {
		$html .= "<TD><font face=\"$font_table_head\" size=\"$size_table_head\" color=\"$text_table_head\">In\&nbsp\;this<BR>Week</FONT></TD>\n";
	}
	if ($d_monthin) {
		$html .= "<TD><font face=\"$font_table_head\" size=\"$size_table_head\" color=\"$text_table_head\">In\&nbsp\;this<BR>Month</FONT></TD>\n";
	}
	if ($d_totalout) {
		$html .= "<TD><font face=\"$font_table_head\" size=\"$size_table_head\" color=\"$text_table_head\">Total\&nbsp\;Out</FONT></TD>\n";
	}	
	if ($d_todayout) {
		$html .= "<TD><font face=\"$font_table_head\" size=\"$size_table_head\" color=\"$text_table_head\">Out\&nbsp\;Today</FONT></TD>\n";
	}
	if ($d_weekout) {
		$html .= "<TD><font face=\"$font_table_head\" size=\"$size_table_head\" color=\"$text_table_head\">Out<BR>this\&nbsp\;Week</FONT></TD>\n";
	}
	if ($d_monthout) {
		$html .= "<TD><font face=\"$font_table_head\" size=\"$size_table_head\" color=\"$text_table_head\">Out<BR>this\&nbsp\;Month</FONT></TD>\n";
	}
	$html .= "</TR>\n";
	print HTML "$html";

}

########## END A PAGE ##########
sub endpage {

	print HTML "</TABLE><BR>\n";

	$foot_page = $new_page-1;
	$foot_path = "$path/data/$footers[$foot_page]";
	open (HEAD, "$foot_path");
	@foot = <HEAD>;
	close (HEAD);
	@foot = reverse(@foot);
	pop(@foot);
	@foot = reverse(@foot);
	foreach $line (@foot) {
			print HTML"$line";
	}
	if ($credit) {
		print HTML "<DIV ALIGN=CENTER><hr width=525 noshade size=1><font face=arial size=-1><a href=\"http://solutionscripts.com\">Top Sites Professional</a><br>Created by <a href=\"http://solutionscripts.com\">Solution Scripts</a><br><br>";
	}
	print HTML "</BODY></HTML>\n";
	close (HTML);

}

########## AD BREAK ##########
sub ad_breaks {

print HTML "</TABLE></DIV><BR><BR>";

@bre = split(/z/,$ad_break{$new_page}); 
$ad_path = "$path/data/$bre[$break_num]";
open (HEAD, "$ad_path");
@ad = <HEAD>;
close (HEAD);
@ad = reverse(@ad);
pop(@ad);
@ad = reverse(@ad);
foreach $line (@ad) {
	print HTML"$line";
}

&tabletop;

}

sub member_rank {

$member = $sort[1];
$member =~ s/\.txt//ig;
if ($member) {
	if ( -e "$path/members/$member.dat" ) { 
		open( DISPLAY, "+<$path/members/$member.dat");
		if ($use_flock) {
			flock DASPLAY, 2; 
		}
		@banner = <DISPLAY>;
		$log_num=0;
		$log_num = push(@banner);
		if ($log_num > 1) {
			$log = pop(@banner);
		}
		else {
			$log = $banner[0];
			@banner ='';
		}
		chomp($log);
		@today = split(/\|/,$log);
		
		$found=0;
		if ($today[0] eq $now) {
			$today[3] = $s_rank;
			$found=1;
		}

		seek (DISPLAY, 0, 0);
		print DISPLAY @banner;

		if ($found) {
			print DISPLAY "$today[0]|$today[1]|$today[2]|$today[3]\n";
		}
		else {
			print DISPLAY "$today[0]|$today[1]|$today[2]|$today[3]\n";
			print DISPLAY "$now|0|0|$s_rank\n";
		}
		close DISPLAY;
	}
	else {
		open( DISPLAY, ">$path/members/$member.dat");
		if ($use_flock) {
			flock DISPLAY, 2; 
		}
		print DISPLAY "$now|0|0|$s_rank\n";
		close DISPLAY;
	}
}

}

sub error{
$errors = $_[0] ;
print "Content-type: text/html\n\n";
print"<HTML><HEAD><TITLE>Top Sites error</TITLE></HEAD><Body>";
print"<h2 align=center>A Top Sites error has occured in create.cgi</H2><center>";
print"<blockquote><b>The error is: <br><font size=+1 color=red>$errors - $!</font><br><br>";
print"If you do not run this Top Sites and just clicked thru, please let <A HREF=\"mailto:$your_email\">$your_email</A> of the error that just occured<br><BR>";
print"If you are the operator of this Top Sites and are having trouble getting Top Sites to run, please stop by <A HREF=\"http://solutionscripts.com/forum\">The CGI Forum</A> and post a message<br>";
exit;
}
