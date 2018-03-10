# Folders Manipulation Library

sub main::CopyFolder
{
my($Original) = $_[0];
my($Destination) = $_[1];
	if ((defined $Original) && (-d $Original) && (-e $Original))
	{
	$Original =~ s!\\!/!g;
		if ((defined $Destination) && (-e $Destination) && (-d $Destination))
		{
		$Destination =~ s!\\!/!g;
		unless ($Original =~ m!/$!) {$Original .= "/"};
		unless ($Destination =~ m!/$!) {$Destination .= "/"};
		my(@FileList) = main::ListDirectories($Original);
		my($file) = undef;
		my($dfile) = undef;
			foreach $file (@FileList)
			{
			$dfile = $file;
			$dfile =~ s!$Original!$Destination!i;
				if (-f $file) 
				{
				CopyFile($file,$dfile,1);
				unless (-e $dfile) {DebugOut(0,"ERROR: (CopyDirectory) Failed to copy file from \"$file\" to \"$dfile\"")};
				} elsif (-d $file)
					{
					unless (-e $dfile) {mkdir($dfile,0777)};
					unless ((-e $dfile) && (-d $dfile) ) {DebugOut(0,"ERROR: (CopyDirectory) Failed to Create Directory \"$file\" to \"$dfile\"")};
					};
			};
		
		};
	};
};

sub main::GetFolderSize
{ 
my(%Filename) = undef; 
my($Dir) = $_[0]; 
my($count) = 0; 
my($TotalSize) = undef;
my($NumberOfEntries) = 0; 
my($temp) = undef;
use File::Find; 
	if ((defined $Dir) && (-d $Dir))
	{
		find sub 
		{ 
		$temp = $File::Find::name, -d && '\\'; 
		$temp =~ s!\\!/!g;
		$Filename{File}{$temp}{name} = $temp;
		$Filename{File}{$temp}{size} = (stat($temp))[7];
		$TotalSize += $Filename{File}{$temp}{size};

		$count++; }, $Dir; 
		$NumberOfEntries = $count; 
	};
$Filename{TotalSize} = $TotalSize;
$Filename{TotalFiles} = $NumberOfEntries;
($Filename{KbSize}, $temp) = (($Filename{TotalSize} / 1000) =~ /(\d+)\.(\d\d)/);         
($Filename{MbSize}, $temp) = (($Filename{TotalSize} / 1000000) =~ /(\d+)\.(\d\d)/);     

return \%Filename; 
};

sub main::ListAllFiles
{
use File::Find;
my($FolderName) = $_[0];
my($Pattern) = $_[1];
my(@Result) = undef;
my($count) = undef;
if($Pattern) {$Pattern =~ s/\*/\.\*/g; 
$Pattern = "^"."$Pattern"."\$"};
my($temp) = undef;

	if ((defined $FolderName) && (-d $FolderName))
	{
		find sub 
		{ 
		$temp = $File::Find::name, -d && '/';
			if ((-f $temp) && ($temp =~ m!$Pattern!i))
			{
			$Result[$count] = $temp;
			$Result[$count] =~ s!\\!/!g;
			$count++; 
			}; 
		}, $FolderName; 
	};
return @Result;
};

sub main::ListDirectories
{ 
my(@Filename) = undef; 
my($Dir) = $_[0]; 
my($count) = 0; 
my($NumberOfEntries) = 0; 
use File::Find; 
	if ((defined $Dir) && (-d $Dir))
	{
		find sub 
		{ 
		$Filename[$count]= $File::Find::name, -d && '\\'; 
		$Filename[$count] =~ s!\\!/!g;
		$count++; }, $Dir; 
		$NumberOfEntries = $count; 
	};
return @Filename; 
};

sub main::ListAllFolders
{
use File::Find;
my($FolderName) = $_[0];
my($Pattern) = $_[1];
my(@Result) = undef;
my($count) = undef;
if($Pattern) {$Pattern =~ s/\*/\.\*/g; 
$Pattern = "^"."$Pattern"."\$"};
my($temp) = undef;

	if ((defined $FolderName) && (-d $FolderName))
	{
		find sub 
		{ 
		$temp = $File::Find::name, -d && '/';
			if ((-d $temp) && ($temp =~ m!$Pattern!i))
			{
			$Result[$count] = $temp;
			$Result[$count] =~ s!\\!/!g;
			$count++; 
			}; 
		}, $FolderName; 
	};
return @Result;
};

sub main::CopyStructure
{
# my($SubDebug) = $main::SubID{CopyStructure}{debug};
my($Original) = $_[0];
my($Destination) = $_[1];
# if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("COPYING: \"$Original\" -> \"$Destination\"") : 0;	
	if ((defined $Original) && (-d $Original) && (-e $Original))
	{
	# ($SubDebug == 1) ? DebugOut("Original is defined - OK  \"$Original\"") : 0;	
	$Original =~ s!\\!/!g;
		if (defined $Destination)
		{
		$Destination =~ s!\\!/!g;
		unless ($Original =~ m!/$!) {$Original .= "/"};
		unless ($Destination =~ m!/$!) {$Destination .= "/"};
		unless (-d $Destination) {mkdir($Destination,0777); ($SubDebug == 1) ? DebugOut("Created directory: \$Destination = \"$Destination\"") : 0;	};
		my(@FolderList) = main::ListAllFolders($Original,"*");
		my($folder) = undef;
			foreach $folder (@FolderList)
			{
			$folder =~ s!$Original!!i;
			$folder = $Destination . $folder;
			unless (-d $folder) {mkdir($folder,0777); ($SubDebug == 1) ? DebugOut("Created Structured folder: \"$folder\"") : 0;};		
			};
		my(@FileList) = main::ListAllFiles($Original,"*");
		($SubDebug == 1) ? DebugOut("Listed all files: \"@FileList\"") : 0;	
		my($file) = undef;
		my($dfile) = undef;
			foreach $file (@FileList)
			{
			$dfile = $file;
			$dfile =~ s!$Original!!i;
			$dfile = $Destination . $dfile;
				if (-f $file) 
				{
				# ($SubDebug == 1) ? DebugOut("COPY FILE: \"$file\" -> \"$dfile\"") : 0;	
				main::CopyFile($file,$dfile,1);
				unless (-e $dfile) {($SubDebug == 1) ? DebugOut("Created directory: \$Destination = \"$Destination\"") : 0;};
				} elsif (-d $file)
					{
					unless (-e $dfile) {mkdir($dfile,0777)};
					unless ((-e $dfile) && (-d $dfile) ) {($SubDebug == 1) ? DebugOut("Created directory: \$Destination = \"$Destination\"") : 0;};
					};
			};
		
		};
	} else {
		($SubDebug == 1) ? DebugOut("FAILED: Original is NOT defined  \"$Original\"") : 0;	
		};
};

# generate hash from root directory . Return pointer to hash.
sub main::HashDir{
   my($dir) = shift;
   my($dh) = undef;
   my($tp) = undef;
   
	if (-d $dir)
	{
	my($tp) = $dir;
	if ($tp =~ s![\&\+\'\(\)\[\]]!_!) 
	{
		unless (-e $tp) 
		{
		rename($dir,$tp);
		if (-e $tp) {$dir = $tp};
		};
	};
	   opendir $dh, $dir or main::HashDir_warn($dir, $!);
	   my $tree = {}->{$dir} = {};
	   while( my $file = readdir($dh) ) {
	       next if $file =~ m[^\.{1,2}$];
	       my $path = $dir .'/' . $file;
	       if (-d $path) {$IndexString .= $UID++ . "| $path\n";};
	       $tree->{$file} = main::HashDir($path), next if -d $path;
	      #  push @{$tree->{'.'}}, $file;
	   }
	   return $tree;
	};
}

sub main::HashDir_warn
{
main::DebugOut(($_[0] .":". $_[1]));	
};

1;
