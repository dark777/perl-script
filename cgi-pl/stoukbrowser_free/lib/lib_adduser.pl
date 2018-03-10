# Add New User interfaces
sub main::lib_adduser
{
my($SubDebug) = $main::SubID{lib_adduser}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

	if (-e  $main::Config{DbFile})
	{
		if ($main::Form{newusername})
		{
		$main::Form{newusername} = lc($main::Form{newusername});
			if ($main::Form{newusergroup})
			{
			unless ($main::Form{newuserpass}){$main::Form{newuserpass} = "12345"} else {$main::Form{newuserpass} = lc($main::Form{newuserpass})};
			$main::Form{newusergroup} = lc($main::Form{newusergroup});
			my($rtx) = undef;
			my($data) = undef;
			my($digest) = undef;			
			my(%lib_adduser) = main::ReadIntConfig($main::Config{DbFile});				
			my($keydigest) = undef;
			my(%newuser) = undef;

				if (main::lib_adduser_checkusername($main::Form{newusername}))
				{
				$rtx = Digest::MD5->new;
				$data = main::urlEncode("$main::Form{newusername}");
				$rtx->add($data);
				$digest = $rtx->hexdigest;
				$keydigest = "u" . "$digest";
					unless (defined $lib_adduser{$keydigest}{name})
					{
					$lib_adduser{$keydigest}{name} = main::urlEncode("$main::Form{newusername}");
					$lib_adduser{$keydigest}{group} = main::urlEncode("$main::Form{newusergroup}");
					$lib_adduser{$keydigest}{password} = crypt(main::urlEncode("$main::Form{newuserpass}"),$main::Config{CryptSalt});
					main::WriteIntConfig("config",\%lib_adduser,$main::Config{DbFile});
					($SubDebug == 1) ? DebugOut("OK: New User was created - OK!") : 0;
					return 1;
					} else {
						($SubDebug == 1) ? DebugOut("FAILED: User Already Exists!") : 0;
						main::AddError("e00020","\"$lib_adduser{$keydigest}{name}\"");
						return 0;
						};		
				undef $rtx;undef $data;undef $digest;undef $keydigest;
				} else {
					($SubDebug == 1) ? DebugOut("FAILED: User Group was not defiend! \"$main::Form{newusergroup}\"") : 0;
					main::AddError("e00024","\"$main::Form{newusername}\"");
					return 0;
					};
			
			} else {
				($SubDebug == 1) ? DebugOut("FAILED: User Group was not defiend! \"$main::Form{newusergroup}\"") : 0;
				main::AddError("e00019","\"$main::Form{newusergroup}\"");
				return 0;
				};
		} else {
			($SubDebug == 1) ? DebugOut("FAILED: User Name was not defiend! \"$main::Form{newusername}\"") : 0;
			main::AddError("e00018","\"$main::Form{newusername}\"");
			return 0;
			};
	} else {
		($SubDebug == 1) ? DebugOut("FAILED: Does Not Exist: \$main::Config{DbFile} = \"$main::Config{DbFile}\"") : 0;
		main::AddError("e00001","\$main::Config{DbFile} = \"$main::Config{DbFile}\"");
		return 0;
		};
};

sub main::lib_adduser_checkusername
{
my($SubDebug) = $main::SubID{lib_adduser_checkusername}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
my($SuggestedName) = $_[0];
my($CheckPassed) = 1;
	if (length($SuggestedName) < 2)
	{
	$CheckPassed = 0; 
	($SubDebug == 1) ? DebugOut("FAILED: Length for User Name is valid!") : 0;
	main::AddError("e00021","\"$SuggestedName\"");
	};

	unless (main::lib_access_checkusernameformat($SuggestedName))
	{
	$CheckPassed = 0; 
	($SubDebug == 1) ? DebugOut("FAILED: Not Valid User Name Format: \"$SuggestedName\"") : 0;
	main::AddError("e00022","\"$SuggestedName\"");
	};

	if ($SuggestedName =~ m!\s!)
	{
	$CheckPassed = 0; 
	($SubDebug == 1) ? DebugOut("FAILED: Not Valid User Name Format: \"$SuggestedName\" contains spaces!") : 0;
	main::AddError("e00023","\"$SuggestedName\"");
	};
return $CheckPassed;	
};

1;
