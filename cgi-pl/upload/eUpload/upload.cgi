#!/usr/bin/perl -w
################################################################################
# eUpload                                      Version 1.0                     #
# Copyright 2000 Frederic TYNDIUK (FTLS)       All Rights Reserved.            #
# E-Mail: tyndiuk@ftls.org                     Script License: GPL             #
# Created  01/01/2000                          Last Modified 01/01/2000        #
# Scripts Archive at:                          http://www.ftls.org/cgi/        #
################################################################################
# Function :                                                                   #
# Web file Uploader system                                                     #
# upload.cgi?ac=admin query login, pass and display administrate users         #
# upload.cgi display upload form                                               #
################################################################################
########################## license & copyright header ##########################
#                                                                              #
#                     Copyright (c) 1999 by TYNDIUK Frederic                   #
#                                                                              #
#       This program is free software; you can redistribute it and/or          #
#       modify it under the terms of the GNU General Public License as         #
#       published by the Free Software Foundation; either version 2 of         #
#       the License, or (at your option) any later version.                    #
#                                                                              #
#       This program is distributed in the hope that it will be useful,        #
#       but WITHOUT ANY WARRANTY; without even the implied warranty of         #
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          #
#       GNU General Public License for more details.                           #
#                                                                              #
#       You should have received a copy of the GNU General Public License      #
#       along with this program in the file 'COPYING'; if not, write to        #
#       the Free Software Foundation, Inc., 59 Temple Place - Suite 330,       #
#       Boston, MA 02111-1307, USA, or contact the author:                     #
#                                                                              #
#                                   TYNDIUK Frederic <tyndiuk@ftls.org>        #
#                                            <http://www.ftls.org/>            #
#                                                                              #
######################## end license & copyright header ########################
################################################################################
# Necessary Variables:                                                         #
# The following variables should be set to define the locations and URLs of    #
# various files, as explained in the documentation.                            #

my $DATA_DIR = '/Absolute/path/to/datadir/';   # Path of data directory
my $DEFAULT_UPLOAD_DIR = '/tmp/'; #used only if you don't use password.

my $MAX_SIZE_UPLOAD = 25; # Ko
	# File sizes are limited to $MAX_SIZE_UPLOAD (0 No limit), larger files will
	# return an 'Internal Server Error'.

my $FORM_URL = 'http://www.yourdomain.com/upload.html';

my $WEBMASTER_EMAIL = 'you@yourdomain.com';
	
my $DISPLAY_LANG = 'En'; # Fr -> french

my $USE_PASSWORD_PROTECT = 1; # 1 to use password protect 0 else.
my $PASSWORD_FILE = $DATA_DIR.'password.txt'; # Name of Password file
	
# Nothing Below this line needs to be altered!                                 #
################################################################################
#    DO NOT EDIT ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING    #
################################################################################
my $VALUE_GENERATOR = 'eUpload v1.0 made by FTLS (Frederic TYNDIUK, http://www.ftls.org/)';

# En: Define all messages and buttons text.
# Fr: Definition des messages et des boutons
my(%NAME_BUTTON, %NAME_HEADTAB, %NAME_TITLE);

if ($DISPLAY_LANG eq 'Fr') {
	%NAME_BUTTON = ('exit' => 'Sortir', 'back' => 'Retour', 'add' => 'Ok', 
		'add_user' => 'Ajouter', 'edit_user' => 'Edit', 'del_user' => 'Supprimer',  'log' => 'Entrer');
	%NAME_HEADTAB = ('name' => 'Nom', 'level' => 'Droits', 'user_path' => 'R&eacute;pertoire utilisateur',
		'login' => 'Identifiant', 'password' => 'Mot de passe', 'new_login' => 'Nouvel identifiant',
		'new_pass' => 'Nouveau mot de passe', 'conf_pass' => 'Confimer mot de passe',
		'admin' => 'Administrateur', 'member' => 'Membre', 'w_path' => "(Chemin inexistant !)");
	%NAME_TITLE   = ('common_admin' => "eUpload, &eacute;cran d'administration", 'common_member' => 'eUpload, &eacute;cran de chargement',
		'error_form' => 'Erreur : Formulaire incomplet', 'manage_users' => 'Management des utilisateurs', 'edit_user' => "Editer 'Value_login' utilisateur", 'add_user' => 'Ajout d\'un utilisateur',
		'user_saved' => "Utilisateur 'Value_login' sav&eacute;", 'user_added' => "Nouvel utilisateur 'Value_login' ajout&eacute;", 'user_deleted' => "Utilisateur 'Value_new_login' supprim&eacute;",
		'change_pass' => 'Changer votre mot de passe', 'chpass_invalid' => 'Nouveau mot de passe invalide', 'chpass_updated' => 'Mot de passe de Value_login mis &agrave; jour',
		'enter_pass' => 'Entrer votre mot de passe', 'invalid_pass' => 'MOT de PASSE INCORECT',
		'EU_BadFN' => "Error: Nom de fichier 'Value_FileName' incorrect", 'EU_FExist' => "Error: Fichier 'Value_FileName' existant, impossible de le modifier!",
		'EU_Size' => "Error: Erreur de chargement de 'Value_FileName'", 'Upload_Succes' => 'Chargement r&eacute;ussi !',
		'Upload_Succes_txt' => "'Value_FileName' (Value_Size bytes, Value_Time s) est sauv&eacute;");
} else {
	%NAME_BUTTON = ('exit' => 'Exit', 'back' => 'Back', 'add' => 'Ok', 
		'add_user' => 'Add', 'edit_user' => 'Edit', 'del_user' => 'Remove', 'log' => 'Log in');
	%NAME_HEADTAB = ('name' => 'Name', 'level' => 'Level', 'user_path' => "User path",
		'login' => 'Login', 'password' => 'Password', 'new_login' => 'New Login',
		'new_pass' => 'New password', 'conf_pass' => 'Confim password',
		'admin' => 'Administrator', 'member' => 'Member', 'w_path' => "(Path don't exist !)");
	%NAME_TITLE  = ('common_admin' => "eUpload, administrative display", 'common_member' => "eUpload, upload display",
		'error_form' => 'Error : Incomplet form', 'manage_users' => 'Manage Users', 'edit_user' => "Edit 'Value_login' user", 'add_user' => 'Add a user',
		'user_saved' => "User 'Value_login' saved", 'user_added' => "New user 'Value_login' added", 'user_deleted' => "User 'Value_new_login' deleted",
		'enter_pass' => 'Enter your password', 'invalid_pass' => 'INVALID PASSWORD',
		'EU_BadFN' => "Error: Bad Name 'Value_FileName'", 'EU_FExist' => "Error: File 'Value_FileName' exists, can not overwrite !",
		'EU_Size' => "Error: Could not upload file: 'Value_FileName'", 'Upload_Succes' => 'Upload uploaded successfully!',
		'Upload_Succes_txt' => "'Value_FileName' (Value_Size bytes, Value_Time s) was saved");
}

use strict;
use CGI;
if ($MAX_SIZE_UPLOAD) { $CGI::POST_MAX=1024 * $MAX_SIZE_UPLOAD; } # Ko
# File sizes are limited to 25K, larger files will return an 'Internal Server Error'

my $query = new CGI;

my $login    = $query->param('login');
my $password = $query->param('pass');
my $action   = $query->param('ac');

my ($dir);

if ($query->param('BT_Exit')) { $action = ''; }


if ($action eq 'admin') {
	print $query->header;
	if ($login && $password)  {
		&admin($query, $login, $password);
	} else {
		print &PagePassword($NAME_TITLE{'common_admin'});
	}
} elsif ($action eq 'upload') {
	print $query->header;
	if ($dir = &check_password('guest', $login, $password)) {
		print &Upload($query, $dir);
	} else {
		print &BadPassword($NAME_TITLE{'common_member'});
	}
} else {
	print $query->redirect($FORM_URL);
}

################################################################################
# Subs                                                                         #
################################################################################

########################################
# Upload Sub                           #
########################################

sub Upload  {
	my($query, $upload_dir) = @_;
    my($file_query, $file_name, $size, $buff, $time, $bytes_count);
	$size = $bytes_count =0;
	$_ = $file_query = $query->param('file');
	s/\w://;
	s/([^\/\\]+)$//;
	$_ = $1;
	s/\.\.+//g;
	s/\s+//g;
	$file_name = $_;
		
	if (! $file_name) {
		$_ = $NAME_TITLE{'EU_BadFN'};
		s/Value_FileName/$file_name/ig;
		&Error($_, 1);
	}

	if (-e "$upload_dir/$file_name") {
		$_ = $NAME_TITLE{'EU_FExist'};
		s/Value_FileName/$file_name/ig;
		&Error($_, 1);
	}
    
    open(FILE,">$upload_dir/$file_name") || &Error("Error opening file $file_name for writing, error $!", 1);
    binmode FILE;
    $time=time();
    while ($bytes_count = read($file_query,$buff,2096)) {
    	$size += $bytes_count;
        print FILE $buff;
    }
    close(FILE);

    if ((stat "$upload_dir/$file_name")[7] <= 0) {
	   	unlink("$upload_dir/$file_name");
    	$_ = $NAME_TITLE{'EU_Size'};
		s/Value_FileName/$file_name/ig;
        &Error($_, 1);
    } else {
    	$time = time -$time;
    	$_ = $NAME_TITLE{'Upload_Succes_txt'};
		s/Value_FileName/$file_name/ig;
		s/Value_Size/$size/ig;
		s/Value_Time/$time/ig;
        &ResutPage($NAME_TITLE{'Upload_Succes'}, $_);
     }
}

########################################
# Administrative Subs                  #
########################################

sub admin {
	my($query, $login, $password) = @_;
	my($ulogin, $upassword, $ulevel, $upath, $no_send, $new_login, $new_pass, $cnf_pass, $new_mode, $new_path);
	my($cnt, $page, $name, $result, $txt, , $time, @pass, $bytes_read, $warning);
	if (! &check_password('root', $login, $password)) {
		print &BadPassword($NAME_TITLE{'common_admin'});
		exit;
	}
	$no_send = $query->param('no');

	if ($query->param('BT_AddUser')) {
		&AddEditUser(0, 'admin', '-1', $login, $password);
	}

	if ($query->param('BT_EditUser') && ($no_send ne '')) {
		&AddEditUser(1, 'admin', $no_send, $login, $password);
	}


	if ($query->param('BT_sv_add_edit_user')) {
		$new_login = $query->param('NewLogin');
		$new_pass   = $query->param('NewPass');
		$cnf_pass  = $query->param('ConfPass');
		$new_mode  = $query->param('Mode');
		$new_path  = $query->param('Dir');
		if (($new_pass eq $cnf_pass) && $new_pass && $new_login) {
			@pass = &Read_Data_File($PASSWORD_FILE);
			$result = "$new_login\t".&CryptPassword($new_pass)."\t$new_mode\t$new_path\n";

			if ($no_send >= 0) { #if Not New
			   $pass[$no_send] = $result;
		    	$txt = $NAME_TITLE{'user_saved'};
			} else {
				push(@pass, $result);
			    $txt = $NAME_TITLE{'user_added'};
			}

			&Write_Data_2_File($PASSWORD_FILE, \@pass);
			$txt =~ s/Value_login/$new_login/gi;
			print &ResutPage("$NAME_TITLE{'common_admin'}<BR>$txt", '', $action, $login, $password);
		} else {
			print &ResutPage("$NAME_TITLE{'common_admin'}<BR>$NAME_TITLE{'error_form'}", '', $action, $login, $password);
		}
		exit;
	}

	if ($query->param('BT_DelUser') && ($no_send >= 0)) {
		@pass = &Read_Data_File($PASSWORD_FILE);
	    ($name) = split /\t/, splice(@pass, $no_send, 1);
		&Write_Data_2_File($PASSWORD_FILE, \@pass);
		$NAME_TITLE{'user_deleted'} =~ s/Value_new_login/$name/;
		print &ResutPage("$NAME_TITLE{'common_admin'}<BR>$NAME_TITLE{'user_deleted'}",'', $action, $login, $password);
		exit;
	}

	print &HTMLHeaderTitle("$NAME_TITLE{'common_admin'}<BR>$NAME_TITLE{'manage_users'}");
	print "<CENTER><FORM METHOD=post><INPUT TYPE=HIDDEN Name=ac VALUE=$action><INPUT TYPE=HIDDEN Name=login VALUE=$login><INPUT TYPE=HIDDEN Name=pass VALUE=$password>\n";
	print "<TABLE BORDER=1 WIDTH=70%><TR><TD></TD><TH> $NAME_HEADTAB{'name'} </TH><TH> $NAME_HEADTAB{'level'} </TH><TH> $NAME_HEADTAB{'user_path'} </TH></TR>\n";
	$cnt = 0;
	foreach (&Read_Data_File($PASSWORD_FILE)) {
		if (! /\s*^#/) {
			($ulogin, $upassword, $ulevel, $upath) = split /\t|\n/;
			if (! -d $upath) { $warning = "<I>$NAME_HEADTAB{'w_path'}</I>"; } else { $warning = ""; }
			print "<TR><TD ALIGN=\"CENTER\"><INPUT TYPE=radio Name='no' Value='$cnt' </TD><TD> $ulogin</TD><TD> $ulevel </TD><TD> $upath $warning</TD></TR>\n";
		}
		$cnt++;
	}
	print "</TABLE><BR><INPUT TYPE=Submit Value=\" $NAME_BUTTON{'add_user'} \" NAME=BT_AddUser> <INPUT TYPE=Submit Value=\" $NAME_BUTTON{'edit_user'} \" NAME=BT_EditUser> <INPUT TYPE=Submit Value=\" $NAME_BUTTON{'del_user'} \" NAME=BT_DelUser> <INPUT TYPE=Submit Value=\" $NAME_BUTTON{'exit'} \" NAME=BT_Exit></CENTER></FORM>\n";
	print &HTMLEnd;
}

sub AddEditUser {
	my($edit, $action, $noline, $login, $password) = @_;
	my($ulogin, $upassword, $ulevel, $upath, @pass, $select_level1, $select_level2, $page_title);
	if ($edit) {
		@pass = &Read_Data_File($PASSWORD_FILE);
	    ($ulogin, $upassword, $ulevel, $upath) = split /\t|\n/, $pass[$noline];
		$page_title = $NAME_TITLE{'edit_user'};
		$page_title =~ s/Value_login/$ulogin/gi;
	} else {
		$page_title = $NAME_TITLE{'add_user'};
		$noline = -1;
		$ulevel = 'guest';
		$upath  = $DEFAULT_UPLOAD_DIR;
	}
	$select_level1 = $select_level2 = '';
	if ($ulevel eq 'root') { $select_level1 = 'CHECKED'; } else { $select_level2 = 'CHECKED'; }
	print &HTMLHeaderTitle("$NAME_TITLE{'common_admin'}<BR>$page_title");
	print "<CENTER><FORM METHOD=post><INPUT TYPE=HIDDEN Name=no VALUE=$noline><INPUT TYPE=HIDDEN Name=ac VALUE=$action><INPUT TYPE=HIDDEN Name=login VALUE=$login><INPUT TYPE=HIDDEN Name=pass VALUE=$password><TABLE BORDER=0>\n";
	print "<TR><TD>$NAME_HEADTAB{'new_login'} :</TD><TD><INPUT TYPE=text Name=NewLogin VALUE=\"$ulogin\"></TD></TR>\n";
	print "<TR><TD>$NAME_HEADTAB{'new_pass'} :</TD><TD><INPUT TYPE=Password Name=NewPass VALUE=\"$upassword\"></TD></TR>\n";
	print "<TR><TD>$NAME_HEADTAB{'conf_pass'} :</TD><TD><INPUT TYPE=Password Name=ConfPass VALUE=\"$upassword\"></TD></TR>\n";
	print "<TR><TD>$NAME_HEADTAB{'level'} :</TD><TD><INPUT TYPE=Radio Name=Mode Value=root $select_level1>$NAME_HEADTAB{'admin'} <INPUT TYPE=Radio Name=Mode Value=guest $select_level2>$NAME_HEADTAB{'member'}</TD></TR>\n";
	print "<TR><TD>$NAME_HEADTAB{'user_path'} :</TD><TD><INPUT TYPE=Text Name=Dir VALUE=\"$upath\"></TD></TR>\n";
	print "<TD></TD><TD ALIGN=\"CENTER\"><INPUT TYPE=Submit Value=\" $NAME_BUTTON{'add'} \" NAME=BT_sv_add_edit_user> <INPUT TYPE=Submit Value=\" $NAME_BUTTON{'exit'} \"></TD></TR>\n";
	print "</TABLE></CENTER></FORM>\n";
	print &HTMLEnd;
	exit;
}

########################################
# Password protect sub                 #
########################################

sub BadPassword {
	$_  = &HTMLHeaderTitle($_[0]);
	$_ .= "<CENTER><BR><BR><B><FONT FACE=\"Arial\" SIZE=\"+3\">$NAME_TITLE{'invalid_pass'}</FONT></B><BR><BR><BR>\n";
	return $_.&BackUrl('','/').&HTMLEnd;
}

sub PagePassword {
    $_ = &HTMLHeaderTitle($_[0].'<BR>'.$NAME_TITLE{'enter_pass'});
    $_ .= "<TABLE ALIGN=\"center\" BGCOLOR=\"navy\" BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"1\" WIDTH=\"50%\"><TR><TD>\n";
    $_ .= "<TABLE BGCOLOR=\"#dcdcdc\" BORDER=\"0\" CELLSPACING=\"0\" CELLPADDING=\"3\" WIDTH=\"100%\"><TR><TD>\n";
    $_ .= $query->start_form;
	$_ .= $query->hidden(-name=>'ac', -value=>'admin');
    $_ .= "<TABLE BORDER=0 WIDTH=100% CELLSPACING=\"10\" CELLPADDING=\"1\">\n";
    $_ .= "<TR><TD>$NAME_HEADTAB{'login'} :</TD><TD>".$query->textfield(-name=>'login', -size=>10)."</TD></TR>\n";
    $_ .= "<TR><TD>$NAME_HEADTAB{'password'} :</TD><TD>".$query->password_field(-name=>'pass', -size=>10)."</TD>\n";
    $_ .= "<TD>".$query->submit(-label=>'Upload', -value=>$NAME_BUTTON{'log'})."</TD></TR></TABLE>\n";
    $_ .= $query->endform;
    $_ .= "</TD></TR></TABLE>\n";
    $_ .= "</TD></TR></TABLE>\n";
    $_ .= &HTMLEnd;
    return $_;
}

sub check_password {
	my($mode, $login, $password) = @_;
	my($flogin, $fpass, $flevel, $fpath);
	if (! $USE_PASSWORD_PROTECT) { return $DEFAULT_UPLOAD_DIR; }
	
	if ($mode && $login && $password) {
		open(PASSWORD, $PASSWORD_FILE);
	 	($_) = grep(/^$login\t/, <PASSWORD>);
	  	close(PASSWORD);
		s/\n//;
		($flogin, $fpass, $flevel, $fpath) = split /\t|\n/;

		if (($flogin eq $login) && ($fpass eq &CryptPassword($password)) &&
			(($mode eq $flevel) || (($flevel eq 'root') && ($mode eq 'guest'))) ) {
	    	 return $fpath;
		}
	}
	return 0;
}

sub CryptPassword {
	#return crypt ($_[0], substr($_[0],0,2));
	return $_[0];
}

########################################
# HTML Present subs                    #
########################################

sub HTMLHeaderTitle {
	return &HTMLHeader($_[0]).&Title($_[0]);
}

sub HTMLHeader {
	my($head_title) = @_;
	$head_title =~ s/\<\w\w*\>/ /g;
	$head_title =~ s/\&(\w)\w+;/$1/g;
	return $query->start_html(
            -title => $head_title,
            -bgcolor => '#FFFFFF',
			-meta => {'robot'=>'NOINDEX, FOLLOW', 'description'=>'none', 'keywords'=>'none',
			'copyright' => $VALUE_GENERATOR, 'author' => $VALUE_GENERATOR, 'generator' => $VALUE_GENERATOR
			});
}

sub Title {
    return <<EOF;
<BR><BR><P ALIGN="Center"><FONT FACE="Arial, helvetica" SIZE="+2" COLOR="#336699"><STRONG><EM>$_[0]</EM></STRONG></FONT></P><BR>
EOF
}

sub BackPost {
    my($title, $ac, $login, $password) = @_ ;
    if (! $title) {
	    $title = $NAME_BUTTON{'back'};
    }
	return "<CENTER><BR><BR><FORM METHOD=post><INPUT TYPE=HIDDEN Name=ac VALUE=$ac><INPUT TYPE=HIDDEN Name=login VALUE=$login><INPUT TYPE=HIDDEN Name=pass VALUE=$password><INPUT TYPE=Submit VALUE=\" $title\" ></FORM><BR><BR></CENTER>\n";
}

sub BackUrl {
    my($title, $url) = @_ ;
    if (! $title) {
	    $title = $NAME_BUTTON{'back'};
    }
	return "<CENTER><BR><BR><FONT FACE=\"Arial\"><A HREF=\"$url\">$title</A></FONT><BR><BR></CENTER>\n";
}


sub HTMLEnd {
	# En : Don't change or remove this Copyright.
	# Fr : Ne modifiez pas ni ne supprimez ce Copyright.
    return <<EOF;
<CENTER><BR><BR><FONT FACE="Arial" SIZE="-2">
<EM>&copy Copyright 2000 <A HREF="http://www.ftls.org/">FTLS</A> (Tyndiuk Fr&eacute;d&eacute;ric). All rights reserved.
<BR>FTLS's CGI Scripts Archive : <A HREF="http://www.ftls.org/cgi/">http://www.ftls.org/cgi/</A>.
<BR>Send all comments to <A HREF="mailto:$WEBMASTER_EMAIL">$WEBMASTER_EMAIL</A></EM>.
</FONT></CENTER></BODY></HTML>
EOF
}

sub ResutPage {
	my($title, $text, $ac, $login, $password) = @_;
	$_ = &HTMLHeaderTitle($title);
	$_ .= "<TABLE WIDTH=\"80%\" ALIGN=\"CENTER\"><TR><TD ALIGN=\"CENTER\">";
	$_ .= "<FONT FACE=\"Arial\" SIZE=\"-1\">$text<P>";
	$_ .= &BackPost("",$ac, $login,$password);
	$_ .= "</FONT>\n</TD></TR></TABLE>";
	$_ .= &HTMLEnd;
	return $_;
}

sub Error {
	my($errortext, $exit) = @_;
    print &HTMLHeaderTitle($errortext);
	print &HTMLEnd;
	if($exit) { exit; }
}

########################################
# Other Subs                           #
########################################

sub Write_Data_2_File {
	my($file, $pt_arry_data) = @_;
	open(FILE, ">$file") || print "Cannot write file $file, error: $!<BR>\n";
	print FILE @$pt_arry_data;
	close(FILE);
}

sub Read_Data_File {
	my($file) = @_;
	my @data;
	open(FILE, "<$file") || print "Cannot open file $file, error: $!<BR>\n";
	@data = <FILE>;
	close(FILE);
	return @data;
}
