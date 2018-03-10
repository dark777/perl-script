sub main::lib_feddownload_collect
{
	my($TimeName) = main::lib_time_gettime(14);
	my($TimeData) = main::lib_time_gettime(6);
	
	
	my($SubmitFolder) =  $main::Config{TempFolder}. "feddownload"."/";
	unless (-e $SubmitFolder) {mkdir($SubmitFolder,0777);};
	
	my($PickupFolder) = $SubmitFolder . "pickup". "/";
	unless (-e $PickupFolder) {mkdir($PickupFolder,0777);};

	my($PickupFileName) = $PickupFolder . "result".".txt";
	my($PickupMarkerName) = $PickupFolder . "result".".mrk";
	
	my($ListFileName) = $SubmitFolder . "fed".".xml";
	my($LatestFileName) = $SubmitFolder . "latest".".txt";

	my($DataFolder) = $SubmitFolder . "data" . "/";	
	unless (-e $DataFolder) {mkdir($DataFolder,0777);};
	my(%Data) = undef;
	if (-e $ListFileName) 
	{
	%Data = main::ReadIntConfig($ListFileName);
	};
	my($DataFile) = $DataFolder . $TimeName . ".txt";
	my($IndexName) = "i" . main::lib_time_gettime(11);
	
	$Data{$IndexName}{Time} = $TimeData;
	$Data{$IndexName}{File} = $DataFile;
	$Data{$IndexName}{DataFrame} = $main::Form{dataframe};
	main::WriteIntConfig("config",\%Data,$ListFileName);

	my(@temp) = undef;
	@temp = split(",",$main::Form{msg});
	my($i) = undef;
	for ($i=0; $i<@temp; $i++)
	{
	$temp[$i] = chr($temp[$i]);
	};
	main::SaveFile($DataFile,@temp);	
	main::SaveFile($PickupFileName,@temp);	
	main::SaveFile($LatestFileName,$IndexName);	
	main::SaveFile($PickupMarkerName,scalar localtime(time));	
};

sub main::lib_feddownload_configure
{
	my($SubmitFolder) =  $main::Config{TempFolder}. "feddownload"."/";
	unless (-e $SubmitFolder) {mkdir($SubmitFolder,0777);};
	
	my($PickupFolder) = $SubmitFolder . "pickup". "/";
	unless (-e $PickupFolder) {mkdir($PickupFolder,0777);};

	my($PickupFileName) = $PickupFolder . "result".".txt";
	my($PickupMarkerName) = $PickupFolder . "result".".mrk";
	
	my($ListFileName) = $SubmitFolder . "fed".".xml";
	my($LatestFileName) = $SubmitFolder . "latest".".txt";
	
	my($DataFolder) = $SubmitFolder . "data" . "/";	
	my($DataFile) = $DataFolder . $TimeName . ".txt";
		
my(%Data) = undef;
$main::Config{feddownload}{SubmitFolder} = $SubmitFolder;
$main::Config{feddownload}{PickupFolder} = $PickupFolder;
$main::Config{feddownload}{PickupFileName} = $PickupFileName;
$main::Config{feddownload}{PickupMarkerName} = $PickupMarkerName;
$main::Config{feddownload}{ListFileName} = $ListFileName;

$main::Config{feddownload}{LatestFileName} = $LatestFileName;
$main::Config{feddownload}{DataFolder} = $DataFolder;
$main::Config{feddownload}{DataFile} = $DataFile;

my(@raw) = undef;
	if (-e $main::Config{feddownload}{LatestFileName})
	{
	@raw = main::ReadFile($main::Config{feddownload}{LatestFileName});
	$main::Config{feddownload}{LatestIndex} = $raw[0];
	};

	if (-e $main::Config{feddownload}{ListFileName}) 
	{
	%Data = main::ReadIntConfig($main::Config{feddownload}{ListFileName});
	$main::Config{feddownload}{Data} = \%Data;
	};
	
};

1;