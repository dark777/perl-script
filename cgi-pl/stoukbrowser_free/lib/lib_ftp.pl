sub main::lib_ftp_SendFile
{
my($FileName) = $_[0];
$FileName =~ s!\\!/!gi;
my($RetryCount) = undef;
if (-e $FileName)
{
	my($TempFileName) = $main::Config{TempFolder}."/"."temp.dum";
	if  ($main::Config{FtpServerTimeout} < 1000) {$main::Config{FtpServerTimeout} = 10000};
	my($INET) = new Win32::Internet();
	my($FTP) = undef;
	main::DebugOut("SERVER: $main::Config{SmurfFTPServer} -USER: $main::Config{SmurfFTPUser} -PASS: $main::Config{SmurfFTPPassword}\n");
	$result = $INET->FTP($FTP, "$main::Config{FTPServer}", "$main::Config{FTPUser}", "$main::Config{FTPPassword}");
	($ErrNum, $ErrText) = $INET->Error();
	main::DebugOut("FTP Connect: \"$main::Config{FTPServer}\" ($ErrNum) $ErrText : \"$path\"");
	
		unless ($ErrNum)
		{
		main::DebugOut("Connected - OK. Continue Upload.");
		$FTP->ControlReceiveTimeout($main::Config{FtpServerTimeout});
		$FTP->ControlSendTimeout($main::Config{FtpServerTimeout});
		$FTP->DataReceiveTimeout($main::Config{FtpServerTimeout});
		$FTP->DataSendTimeout($main::Config{FtpServerTimeout});
		my($path) = $FTP->Pwd();
		($ErrNum, $ErrText) = $INET->Error();
		main::DebugOut("Pwd : ($ErrNum) $ErrText : \"$path\"");
			if ($main::{FTPDirectory}) 
			{
			$path = $FTP->Cd("$main::{FTPDirectory}");
			($ErrNum, $ErrText) = $INET->Error();
			DebugOut("CD : ($ErrNum) $ErrText : \"$path\"");
			};
		my($ReturnResult) = undef;
		$main::Config{FTPRetry} = 3;
		RepeatAgain:
			if (-e $FileName)
			{
			$RetryCount++;
			$_ = $FileName;
			m!.*/(.*)$!;
			$RemoteFileName = $1;
			$FTP->Put("$FileName","$RemoteFileName");
			($ErrNum, $ErrText) = $INET->Error();
			main::DebugOut("Put \"$FileName,$RemoteFileName\": ($ErrNum) $ErrText");
			# Now check if the file got there:
			$FTP->Get("$RemoteFileName", "$TempFileName");	
			($ErrNum, $ErrText) = $INET->Error();
			main::DebugOut("Get \"$RemoteFileName,$TempFileName\": ($ErrNum) $ErrText");
			# And Compare the sizes
			main::DebugOut("Compare the sizes of \"$RemoteFileName\" and \"$TempFileName\"");
				if ( ( ((stat($FileName))[7]) == ((stat($TempFileName))[7]))  && (-e $TempFileName) )
				{
				main::DebugOut("Sizes are the same!");
				main::DebugOut("Deleting \"$FileName\" and \"$TempFileName\".");
				unlink($FileName);
				unlink ($TempFileName);
				main::DebugOut("Successfully Uploaded \"$FileName\" ");
				$ReturnResult = 1;
				} else {
					unless ($RetryCount > $main::Config{FTPRetry}) {sleep(3); main::DebugOut("Trying Again...$RetryCount"); goto RepeatAgain};
					unlink ($TempFileName);
					main::DebugOut("ERROR: Failed to Upload \"$FileName\"");
					};
			} else {
				# Local File Does Not Exist
				};
		} else {
			main::DebugOut("Failed TO Connect...");	
			};
	$INET->Close($FTP); 
return $ReturnResult;
} else {
	return 1;
	};
};

1;
