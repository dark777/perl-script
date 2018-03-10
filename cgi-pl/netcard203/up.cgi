#!/usr/bin/perl5
####################################
#
# up.cgi adds the uploading function 
# to the Net Card script.
#
####################################
# CREDITS:
# some parts of this script have been used:
#
# File Upload Script        Version 6.00
# Created by Jeff Carnahan  jeffc@terminalp.com
# http://www.terminalp.com/scripts/
# 
####################################
# NETCARD 2.03
# 
# Aytekin Tank
# email: aytekin@bridgeport.edu
# http://www.interlogy.com/scripts/netcard
# 
####################################

require "netcard2.cfg";
$netcardPL =  "netcard2.pl";
$DIRECTORY = $root."/images/";
$MAX_UPLOAD = $MAX_UPLOAD*1000;

# set variables
sub values{
	$loginname = $value[1];
};


# the extension gif or jpg or jpeg?
sub change_Filename {

	$image_ext = substr($Filename, -4);

	$Filename = $loginname.$image_ext;

	if ($image_ext eq "jpeg"){
			$image_ext = ".jpg";
			}
	if ($image_ext ne ".jpg"){
		if ($image_ext ne ".gif")
		{
			print "Content-type: text/html\n\n";
			print "unknown image type";
			exit;
		}
	}

}



sub finished {

	$valueC = @value;
	for ($i=0; $i <= $valueC ; $i++){
 		$value[$i] = $value [$i+1];
 	}

#	print "..upload was succesful\n"; 
	$upload = 0;
	$preview = 1;
	$logo = $Filename;
	$started = 1;
	if (loginname eq ""){
		print "Content-type: text/html\n\n";
		print "no loginname ";
		exit;}
	require $netcardPL;
	exit;
}

$| = 1;
chop $DIRECTORY if ($DIRECTORY =~ /\/$/);
use CGI qw(:standard);
$query = new CGI;

if ( (!(-e $DIRECTORY)) ||
	 (!(-W $DIRECTORY)) ||
	 (!(-d $DIRECTORY)) ) {
		print "Content-type: text/html\n\n";
		print ("\n bad directory\n");
	exit;
}
	
$fieldno = 1;
foreach $key (sort {$a <=> $b} $query->param()) {
	next if ($key =~ /^\s*$/);
	next if ($query->param($key) =~ /^\s*$/);
	next if ($key !~ /^field_(\d+)$/);
	$value[$fieldno] = $query->param($key);
	$fieldno++; 
}	

# field values	coming from the 
&values;
	
foreach $key (sort {$a <=> $b} $query->param()) {
	next if ($key =~ /^\s*$/);
	next if ($query->param($key) =~ /^\s*$/);
	next if ($key !~ /^upload_(\d+)$/);
	$Number = $1;
	
	if ($query->param($key) =~ /([^\/\\]+)$/) {
		$Filename = $1;
		$Filename =~ s/^\.+//;
		$File_Handle = $query->param($key);
		
	#change the actual filename:
	&change_Filename;
	
		if (!$ALLOW_INDEX && $Filename =~ /^index/i) {
			print "Content-type: text/html\n\n";
			print "Error: Filename Problem";
			exit;
		}	} else {
		$FILENAME_IN_QUESTION = $query->param($key);
		
		print "Content-type: text/html\n\n";
		print "Error: Filename Problem";
		exit;
	}
	    if (!open(OUTFILE, ">$DIRECTORY\/$Filename")) {
            print "Content-type: text/plain\n\n";
            print "File: $DIRECTORY\/$Filename\n";
            print "-------------------------\n";
        print "There was an error opening the Output File\n";
            exit;
        }

	undef $BytesRead;
	undef $Buffer;
	
        while ($Bytes = read($File_Handle,$Buffer,1024)) {
		$BytesRead += $Bytes;
            print OUTFILE $Buffer;
        }
	
	push(@Files_Written, "$DIRECTORY\/$Filename");
	$TOTAL_BYTES += $BytesRead;
	$Confirmation{$File_Handle} = $BytesRead;

        close($File_Handle);
	close(OUTFILE);

        chmod (0666, "$DIRECTORY\/$Filename");
    }

$FILES_UPLOADED = scalar(keys(%Confirmation));

	
if ($TOTAL_BYTES > $MAX_UPLOAD && $MAX_UPLOAD > 0) {
	foreach $File (@Files_Written) {
		unlink $File;
	}
	
	print "Content-type: text/html\n\n";
	print "Error: Limit Reached";
	exit;
}
	
if ($SUCCESS_LOCATION !~ /^\s*$/) {
	print $query->redirect($SUCCESS_LOCATION);
} else {
	
	&finished;
	foreach $key (keys (%Confirmation)) {
		print "$key - $Confirmation{$key} bytes\n";
	}
	
	print <<__END_OF_HTML_CODE__;
	
	</BODY>
	</HTML>

__END_OF_HTML_CODE__
#	exit;	
}
# end of the up.cgi