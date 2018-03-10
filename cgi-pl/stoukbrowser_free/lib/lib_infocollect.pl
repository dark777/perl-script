sub main::lib_infocollect_collect
{
	my($FileName) = main::lib_time_gettime(12);
	my($ServerName) = $main::Form{server};
	my($ServerFolder) =  $main::Config{TempFolder}. "$ServerName"."_srv"."/";
	unless (-e $ServerFolder) {mkdir($ServerFolder,0777);};
	
	$FileName = $ServerFolder ."$FileName".".xml";
	$LastFileName = $ServerFolder ."last".".xml";
	my(@temp) = undef;
	@temp = split(",",$main::Form{msg});
	my($i) = undef;
	for ($i=0; $i<@temp; $i++)
	{
	$temp[$i] = chr($temp[$i]);
	};
	
	main::SaveFile($FileName,@temp);	
	main::SaveFile($LastFileName,@temp);	
	main::lib_log_ServerFolder($ServerFolder,7);	
};
sub main::lib_log_ServerFolder
{
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
my($ServerFolder) = $_[0];
my($ServerRetentionDays) = $_[1];
if ($ServerRetentionDays < 1) {$ServerRetentionDays = 1};

	if (-e $ServerFolder)
	{

		my(@list) = ListFiles($main::Config{LogFolder},1,"*.xml");
		my($temp) = undef;
			foreach $temp (@list)
			{
			$filemod  = (stat($temp))[9];       
			if ((time - ((stat($temp))[9])) > ($ServerRetentionDays * 86400)) 
			{
			unlink($temp)
			} else {
				$main::Config{InfoCollect}{$main::Form{server}}{$temp} = $temp;
				};
			};

	};

};

1;
