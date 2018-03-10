# General Database Handling Library
sub main::lib_dbgen_DisplayDBData
{
my($SubDebug) = $main::SubID{DatabaseConnect}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($rowcount) = undef;
my($colcount) = undef;
my(@temp) = undef;
my($String) = undef;
my($line) = undef;
my($subline) = undef;
$String = "<table>";
$String .= "<tr><td>Platter Name:</td><td>Platter Type:</td><td>Platter Count:</td><td>Batch ID:</td><td>Full Marked Date:</td><td>Full Marked recordID:</td><td>Dest Sched:</td><td>Dest RecordID:</td><td>Location Type:</td><td>Location RecordID:</td></tr>";
my(@Color) = undef;
$Color[0] = "bgcolor=\"#99ffff\"";
$Color[1] = "bgcolor=\"#ccccff\"";
my($colorid) = undef;
	if (@main::DbGetData)
	{
		for ($rowcount = 0; $rowcount < @main::DbGetData; $rowcount++ )
		{
		@temp = undef;
		@temp = @{$main::DbGetData[$rowcount]};
		$String .= "\n<tr>";
			for ($colcount = 0; $colcount < @temp; $colcount++)
			{
			$colorid = $rowcount % 2;
			$String .= "\n<td $Color[$colorid]>$main::Html{FS1}$temp[$colcount] $main::Html{FF}</td>";
			};	
		$String .= "\n</tr>";	
		};
	} else {
		#main::AddError("e00106"," \"$main::Config{Sql}\" \$main::Config{DBConnected} = \"$main::Config{DBConnected}\"");
		($SubDebug == 1) ? DebugOut("FAILED: No data to Display.") : 0;				
		};
$String .= "</table>";

return $String;
};

sub main::lib_dbgenb_indexdata
{
my($SubDebug) = $main::SubID{DatabaseConnect}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($IndexPosition) = $_[0];
my($ValuePosition) = $_[1];
my($IndexStartTime) = time;
($SubDebug == 1) ? DebugOut("Index Position: \"$IndexPosition\"") : 0;

	if (@DbGetData)
	{
	my($rowcount) = undef;
	my(@temp) = undef;
		for ($rowcount = 0; $rowcount < @main::DbGetData; $rowcount++ )
		{
		@temp = undef;
		@temp = @{$main::DbGetData[$rowcount]};
		$main::DbIndex{$temp[$IndexPosition]} = $temp[$ValuePosition];
		};
			
	my($IndexFinishTime) = time;
	my($IndexTiming) = $IndexFinishTime - $IndexFinishTime;
	($SubDebug == 1) ? DebugOut("indexing took: \"$IndexTiming\" sec.") : 0;
	} else {
		($SubDebug == 1) ? DebugOut("Nothing to index - No Data.") : 0;
		};	
return 1;	
};
1;