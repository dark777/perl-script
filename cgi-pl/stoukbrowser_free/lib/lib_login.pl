sub main::lib_login_LoginForm
{
my($String) = undef;
$String = qq(
	$main::Html{Login}{Error}
	<table style="width:200; height:100; font-family:verdana,arial; font-size:8pt; background:#fcc">
	<form method="post" name="loginform" action="$main::Config{ScriptWebPath}" target="_self">
	<tr>
	<td valign="top">User name: </td><td><input type="text" size="30" name="u"  value=""/></td>
	</tr><tr>
	<td valign="top">Password: </td><td><input type="password" size="30" name="p" /></td>
	</tr>
	<tr>
	<td valign="top"></td><td valign="top"><input type="submit" value=" Login! " />
	<input type="hidden" name="c" value="$main::Form{c}" /></td>
	<input type="hidden" name="default" value="$main::Form{default}" /></td>
	<input type="hidden" name="sn" value="$main::Form{sn}" /></td>
	<input type="hidden" name="agi" value="$main::Form{agi}" /></td>
	</tr>
	<tr>
	<td valign="top"></td><td valign="top">
	If not registered yet, specify your e-mail address as the user name,<br> click "New Registration!".<br> Registration will be e-mailed.
	<input type="submit" value=" New Registration! " name="submit"/>
	</td>
	</tr>
	</form>
	</table>
);
return $String;	
};


sub main::lib_login_adduser
{
my($SubDebug) = $main::SubID{lib_login_adduser}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

	if (-e  $main::Config{DbFile})
	{
		if ($main::Form{newusername})
		{
		$main::Form{newusername} = lc($main::Form{newusername});
			if ($main::Form{newusergroup})
			{
			unless ($main::Form{newuserpass}){$main::Form{newuserpass} = "$main::Config{DefaultPassword}"} else {$main::Form{newuserpass} = lc($main::Form{newuserpass})};
			$main::Form{newusergroup} = lc($main::Form{newusergroup});
			my($rtx) = undef;
			my($data) = undef;
			my($digest) = undef;			
			my(%lib_adduser) = main::ReadIntConfig($main::Config{DbFile});				
			my($keydigest) = undef;
			my(%newuser) = undef;

				if (main::lib_login_adduser_checkusername($main::Form{newusername}))
				{
				$rtx = Digest::MD5->new;
				$data = main::urlEncode("$main::Form{newusername}");
				$rtx->add($data);
				$digest = $rtx->hexdigest;
				$keydigest = "u" . "$digest";
					unless (defined $lib_adduser{$keydigest}{name})
					{
					

					$lib_adduser{$keydigest}{name} = $main::Form{newusername};
					$lib_adduser{$keydigest}{group} = $main::Form{newusergroup};
					$lib_adduser{$keydigest}{password} = crypt($main::Form{newuserpass},$main::Config{CryptSalt});
					$lib_adduser{$keydigest}{created} = time;

					$data = $lib_adduser{$keydigest}{name};
					$rtx->add($data);
					$digest = $rtx->hexdigest;

					$lib_adduser{$keydigest}{digest} = $digest;
					main::WriteIntConfig("config",\%lib_adduser,$main::Config{DbFile});
					
					my(@DigestFileData) = undef;
					
					$DigestFileData[$DFD++] = "name:$lib_adduser{$keydigest}{name}\n";
					$DigestFileData[$DFD++] = "group:$lib_adduser{$keydigest}{group}\n";
					$DigestFileData[$DFD++] = "pass:$lib_adduser{$keydigest}{password}\n";
					$DigestFileData[$DFD++] = "created:$lib_adduser{$keydigest}{created}\n";
					$main::Config{temp}{digestfile} = $main::Config{DbAccessFolder} . "$digest" . ".cgi";
					main::SaveFile($main::Config{temp}{digestfile},@DigestFileData);
					if (-e $main::Config{temp}{digestfile})
					{
					($SubDebug == 1) ? DebugOut("OK: New User was created - OK!") : 0;
					return 1;
					} else {
						($SubDebug == 1) ? DebugOut("FAILED: Could not confirm creating digest file \"$main::Config{temp}{digestfile}\"!") : 0;
						return 0;
						};
					} else {
						($SubDebug == 1) ? DebugOut("FAILED: User Already Exists!") : 0;
						main::AddError("e00020","\"$lib_adduser{$keydigest}{name}\"");
						$main::Html{useradministration}{Error} = "FAILED: User Already Exists!";
						return 0;
						};		
				undef $rtx;undef $data;undef $digest;undef $keydigest;
				} else {
					($SubDebug == 1) ? DebugOut("FAILED: User Group was not defined! \"$main::Form{newusergroup}\"") : 0;
					main::AddError("e00024","\"$main::Form{newusername}\"");
					return 0;
					};
			
			} else {
				($SubDebug == 1) ? DebugOut("FAILED: User Group was not defined! \"$main::Form{newusergroup}\"") : 0;
				main::AddError("e00019","\"$main::Form{newusergroup}\"");
				return 0;
				};
		} else {
			($SubDebug == 1) ? DebugOut("FAILED: User Name was not defined! \"$main::Form{newusername}\"") : 0;
			main::AddError("e00018","\"$main::Form{newusername}\"");
			return 0;
			};
	} else {
		($SubDebug == 1) ? DebugOut("FAILED: Does Not Exist: \$main::Config{DbFile} = \"$main::Config{DbFile}\"") : 0;
		main::AddError("e00001","\$main::Config{DbFile} = \"$main::Config{DbFile}\"");
		return 0;
		};
};

sub main::lib_login_adduser_checkusername
{
my($SubDebug) = $main::SubID{act_useradministration_adduser_checkusername}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
my($SuggestedName) = $_[0];
my($CheckPassed) = 1;
	if (length($SuggestedName) < 8)
	{
	$CheckPassed = 0; 
	($SubDebug == 1) ? DebugOut("FAILED: Length for User Name is valid!") : 0;
	main::AddError("e00021","\"$SuggestedName\"");
	$main::Html{useradministration}{Error} = "FAILED: Length for User Name is not valid!";
	};

	unless (main::lib_access_checkusernameformat($SuggestedName))
	{
	$CheckPassed = 0; 
	($SubDebug == 1) ? DebugOut("FAILED: Not Valid User Name Format: \"$SuggestedName\"") : 0;
	main::AddError("e00022","\"$SuggestedName\"");
	$main::Html{useradministration}{Error} = "FAILED: Not Valid User Name Format (should be in the form of e-mail address)!";
	};

	if ($SuggestedName =~ m!\s!)
	{
	$CheckPassed = 0; 
	($SubDebug == 1) ? DebugOut("FAILED: Not Valid User Name Format: \"$SuggestedName\" contains spaces!") : 0;
	main::AddError("e00023","\"$SuggestedName\"");
	$main::Html{useradministration}{Error} = "FAILED: Not Valid User Name Format (contains spaces)!";
	};
return $CheckPassed;	
};

sub main::lib_login_configure_impersonation
{
my($SubDebug) = $main::SubID{lib_login_configure_impersonation}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;	
my($Impersonate) = $_[0];
my($ImpersonateDigest) = main::lib_access_userdigest($Impersonate);
my(%UserData) = undef;

    if (defined $ImpersonateDigest)    
    {
    ($SubDebug == 1) ? DebugOut("OK  - User exists \"$main::User{name}\"") : 0;
    $main::ImpEnv{digestfile} = $main::Config{DbAccessFolder} . $ImpersonateDigest . ".cgi";	
  
        if (-f $main::ImpEnv{digestfile})
        {
	%UserData = main::ReadConfig{$main::Config{DbFile}};        	
        ($SubDebug == 1) ? DebugOut("OK  - Impersonate User digest \"$main::ImpEnv{digestfile}\"") : 0;
        $main::ImpEnv{digest} = $ImpersonateDigest;

        $main::ImpEnv{TempFolder} = $main::Config{TempFolder} . $main::ImpEnv{digest} . "/"; 
        unless (-e $main::ImpEnv{TempFolder}) {mkdir($main::ImpEnv{TempFolder},0777)};
        unless (-e $main::ImpEnv{TempFolder}) {die "$ErrorText01 $main::ImpEnv{TempFolder}"};
        $main::ImpEnv{CacheFolder} = $main::Config{CacheFolder} . $main::ImpEnv{digest} . "/"; 
        unless (-e $main::ImpEnv{CacheFolder}) {mkdir($main::ImpEnv{CacheFolder},0777)};
        unless (-e $main::ImpEnv{CacheFolder}) {die "$ErrorText01 $main::ImpEnv{CacheFolder}"};
        $main::ImpEnv{DbFolder} = $main::Config{DbFolder} . $main::ImpEnv{digest} . "/"; 
        unless (-e $main::ImpEnv{DbFolder}) {mkdir($main::ImpEnv{DbFolder},0777)};
        unless (-e $main::ImpEnv{DbFolder}) {die "$ErrorText01 $main::ImpEnv{DbFolder}"};
        $main::ImpEnv{TtsFolder} = $main::Config{TtsFolder} . $main::ImpEnv{digest} . "/"; 
        unless (-e $main::ImpEnv{TtsFolder}) {mkdir($main::ImpEnv{TtsFolder},0777)};
        unless (-e $main::ImpEnv{TtsFolder}) {die "$ErrorText01 $main::ImpEnv{TtsFolder}"};
        $main::ImpEnv{UEnvFolder} = $main::Config{UEnvFolder} . $main::ImpEnv{digest} . "/"; 
        unless (-e $main::ImpEnv{UEnvFolder}) {mkdir($main::ImpEnv{UEnvFolder},0777)};
        unless (-e $main::ImpEnv{UEnvFolder}) {die "$ErrorText01 $main::ImpEnv{UEnvFolder}"};
       
	return 1;
        } else {
            ($SubDebug == 1) ? DebugOut("FAILED  - User Impersonate digest \"$main::ImpEnv{digestfile}\"") : 0;    
            main::AddError("e12");                
            };
    } else {
        ($SubDebug == 1) ? DebugOut("FAILED  - No Impersonate Digest: \"$ImpersonateDigest\"") : 0;
        main::AddError("e11");        
        };
	
};

1;
