# Files Manipulation Library
##############################################################################
sub main::CopyFile 
{ 
my($blksize) = undef;
my($len) = undef;
my($buf) = undef;
my($offset) = undef;
my($written) = undef;
my($timestamp) = undef;

	if (-e $_[1]) {unlink($_[1])};
	open(IN,  "< $_[0]") or DebugOut(0,"ERROR: (CopyFile) cant open Old File$_[0]: $!");  
	$timestamp = ((stat($_[0]))[9]);
	open(OUT, "> $_[1]") or DebugOut(0,"ERROR: (CopyFile) cant open New File $_[1]: $!"); 
	binmode IN;
	binmode OUT;
	$blksize = (stat IN)[11] || 16384;
	
	while ($len = sysread IN, $buf, $blksize) 
	{  
    		if (!defined $len) 
    		{  
        	next if $! =~ /^Interrupted/;       # ^Z and fg  
		die;
        	DebugOut(0,"$Config{User}{Name} ERROR: (CopyFile) System read error: $!");  
    		};
    	$offset = 0;  
    		while ($len) 
    		{
        	defined($written = syswrite OUT, $buf, $len, $offset) or DebugOut("ERROR: (CopyFile) System write error: $!");  
        	$len    -= $written;  
        	$offset += $written;  
    		};  
	}  
	
	close(IN);  
	close(OUT);  
	utime($timestamp,$timestamp,$_[1]);
}; 
##############################################################################


##############################################################################
sub lib_files_extension {
    my $path = shift;
    my $ext = undef;
#    $ext =~ s/^\.//;
    $_ = $path;
    if ($path =~ m!\.([\w\d][\w\d][\w\d][\w\d]?)$!i)
    {
    $ext = $1;	
    };
    return $ext;
}
##############################################################################
##############################################################################
sub main::SaveFile
{
my($filename) = $_[0];
my(@send) = @_[1..@_-1];
my($count) = 0;
if (defined $filename)
{
use bytes;
open (FILE, ">$filename") || warn "Util:: Cannot write to \"$filename\": error $!\n<br>";
	while ($count < @_)
	{
	print FILE $send[$count];
	$count++
	};
close FILE;
no bytes;
} else {
	my($Package, $Filename, $Line) = caller;
	DebugOut(0,"ERROR: No Filename was passed for Saving: \$Package, \$Filename, \$Line = $Package, $Filename, $Line");
	};
return $count;
};
##############################################################################
##############################################################################
sub main::AddFile
{
my($filename) = $_[0];
my(@send) = @_[1..@_-1];
my($count) = 0;
if (defined $filename)
{
open (FILE, ">>$filename") || warn "Util:: Cannot write to \"$filename\": error $!\n<br>";
	while ($count < @_)
	{
	print FILE $send[$count];
	$count++
	};
close FILE;
};
return $count;
};
##############################################################################
##############################################################################
sub main::ReadFile 
{ 
my($filename) = $_[0]; 
my($count) = 0; 
my(@result) = undef; 
if ((-e $filename) && (-f $filename) )
{
	open (INPUT, "$filename") || warn "Could not open file $filename : $!\n"; 
	while (<INPUT>) 
	{ 
	($result[$count]) =$_; 
	$count++; 
	}; 
	close (INPUT); 
} else {
	print "Does not exist: $filename\n";
	};
return @result; 
};
##############################################################################
##############################################################################
sub main::ListFiles
{ 
my(@FILENAME) = undef; 
my($dirname) = $_[0]; 
my($fullnameswitch) = $_[1];
my($pattern) = $_[2];
my($count) = 0; 
my($file) = undef;
if($pattern) {$pattern =~ s/\*/\.\*/g; $pattern = "^"."$pattern"."\$"};
if ($dirname =~ m!/!) 
{
	unless ($dirname =~ m!/$!) 
	{
	$dirname = "$dirname"."/";
	};

} else {
		unless ($dirname =~ m!\$!) 
		{
		$dirname = "$dirname"."\\";
		};
	};
opendir(DIR, $dirname) or warn "can't opendir $dirname: $!";
	while (defined($file = readdir(DIR))) 
	{
	next if $file =~ /^\.\.?$/;
	next if (-d "$dirname$file");
		if (($file =~ /$pattern/g) && (-f "$dirname$file"))
		{
		# print "FILE: $file\n<br>";
			if ($fullnameswitch) 
			{
			$FILENAME[$count] = "$dirname"."$file"; 
			$FILENAME[$count] =~ s/\\\\/\\/;
			$FILENAME[$count] =~ s/\\/\//;
			$count++;
			} else {
				$FILENAME[$count] = $file; 
				$count++;
				};
		} else {
			
			};
	}
closedir(DIR);
return @FILENAME;
};
##############################################################################
1;
