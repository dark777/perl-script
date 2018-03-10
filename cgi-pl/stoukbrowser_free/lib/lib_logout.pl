sub main::lib_logout
{
my($SubDebug) = $main::SubID{lib_access_logout}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	
print "\n<br>main::lib_access_logout";			
};
1;
