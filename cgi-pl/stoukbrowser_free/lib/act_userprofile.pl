# Action library for userprofile


sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute before Template generation
$main::Form{pchange} = lc($main::Form{pchange});
$main::Form{pconfirm} = lc($main::Form{pconfirm});
my($rtx) = Digest::MD5->new;
my($data) = undef;
my($digest) = undef;
$data = $main::Config{ServerAddress};
$rtx->add($data);
$digest = $rtx->hexdigest;
$main::Config{DbFile} = $main::Config{DbFolder} . "a_"."$digest".".cgi";
my(%UserData) = undef;
my($key) = undef;
my($DFD) = undef;


	if (length ($main::Form{pchange}) > 1)
	{
		if ($main::Form{pchange} eq $main::Form{pconfirm})
		{
		%UserData = main::ReadIntConfig($main::Config{DbFile});	
			foreach $key (sort keys %UserData)
			{
			($SubDebug == 1) ? DebugOut("CHECKING: \"$UserEnv{name}\" = \"$UserData{$key}\"?") : 0;
				if ($UserEnv{name} eq $UserData{$key}{name}) 
				{
				$UserData{$key}{password} = crypt($main::Form{pconfirm},$main::Config{CryptSalt});
					unless ($main::Config{DemoApp} == 1)
					{
					main::WriteIntConfig("config",\%UserData,$main::Config{DbFile});			
					};
					my(@DigestFileData) = undef;
					$DigestFileData[$DFD++] = "name:$UserData{$key}{name}\n";
					$DigestFileData[$DFD++] = "group:$UserData{$key}{group}\n";
					$DigestFileData[$DFD++] = "pass:$UserData{$key}{password}\n";
					$data = $UserData{$key}{name};
					$rtx->add($data);
					$digest = $rtx->hexdigest;
					$main::Config{temp}{digestfile} = $main::Config{DbFolder} . "$digest" . ".cgi";
					unless ($main::Config{DemoApp} == 1)
					{
					main::SaveFile($main::Config{temp}{digestfile},@DigestFileData);
					};
					

				($SubDebug == 1) ? DebugOut("OK - Updated Password for user: $UserEnv{name}") : 0;
				$main::Html{userprofile}{message} = "<br>Successfully Changed Password!<br>";
				};
			};
		
		} else {
			$main::Html{userprofile}{message} = "ERROR: Confirm password properly!<br>";
			};
		
	};

};

sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute After Template generation
# Example of adding Processed data to the Template:
# Unremark the following lines to see the action:

# my($String) = "</br><b>My Data insert Example! ! !<b>";;
my($String) = $main::Html{userprofile}{message};
$main::Html{ServiceText} =~ s!<insert-userprofile-message>!$String!gis;
};
1;
