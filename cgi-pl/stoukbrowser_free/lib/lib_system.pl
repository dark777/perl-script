sub main::lib_system_list
{
my(@ResultList) = undef;
my($FileCount) = undef;
my(@TempList) = undef;
my($FileName) = undef;
my($ModTime) = undef;
my($FileSize) = undef;
my($TempFileResultPath) = $main::Config{TempFolder} . $main::Config{ServerName}. "_v.txt";
$FileCount++;
# Listing Tts Folder
@TempList = main::ListAllFiles($main::Config{TtsFolder},"*.*");
($SubDebug == 1) ? DebugOut("OK Listed \$main::Config{TtsFolder} = \"$main::Config{TtsFolder}\"") : 0;
	foreach $FileName (@TempList)
	{
	$ModTime = (stat($FileName))[9];
	$FileSize = (stat($FileName))[7];
	$FileName =~ s!$main::Config{TtsFolder}!\(TtsFolder\)!i;
	$ResultList[++$FileCount] = "::0::".$FileCount."::0::::1::".$FileName."::1::::2::".$ModTime."::2::::3::".$FileSize."::3::\n";
	};
# Listing Library Folder
@TempList = main::ListAllFiles($main::Config{LibFolder},"*.*");
($SubDebug == 1) ? DebugOut("OK Listed \$main::Config{LibFolder} = \"$main::Config{LibFolder}\"") : 0;
	foreach $FileName (@TempList)
	{
	$ModTime = (stat($FileName))[9];
	$FileSize = (stat($FileName))[7];
	$FileName =~ s!$main::Config{LibFolder}!\(LibFolder\)!i;
	$ResultList[++$FileCount] = "::0::".$FileCount."::0::::1::".$FileName."::1::::2::".$ModTime."::2::::3::".$FileSize."::3::\n";
	};

# Listing Images Folder
@TempList = main::ListAllFiles($main::Config{ImagesRoot},"*.*");
($SubDebug == 1) ? DebugOut("OK Listed \$main::Config{ImagesRoot} = \"$main::Config{ImagesRoot}\"") : 0;
	foreach $FileName (@TempList)
	{
	$ModTime = (stat($FileName))[9];
	$FileSize = (stat($FileName))[7];
	$FileName =~ s!$main::Config{ImagesRoot}!\(ImagesRoot\)!i;
	$ResultList[++$FileCount] = "::0::".$FileCount."::0::::1::".$FileName."::1::::2::".$ModTime."::2::::3::".$FileSize."::3::\n";
	};

# Listing Help Folder
@TempList = main::ListAllFiles($main::Config{HelpFolder},"*.*");
($SubDebug == 1) ? DebugOut("OK Listed \$main::Config{HelpFolder} = \"$main::Config{HelpFolder}\"") : 0;
	foreach $FileName (@TempList)
	{
	$ModTime = (stat($FileName))[9];
	$FileSize = (stat($FileName))[7];
	$FileName =~ s!$main::Config{HelpFolder}!\(HelpFolder\)!i;
	$ResultList[++$FileCount] = "::0::".$FileCount."::0::::1::".$FileName."::1::::2::".$ModTime."::2::::3::".$FileSize."::3::\n";
	};

return @ResultList;
};
1;