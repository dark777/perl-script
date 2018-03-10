# Access Check and Set library
sub main::lib_access_authenticate
{
my($SubDebug) = $main::SubID{lib_access_authenticate}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($rtx) = Digest::MD5->new;
my($data) = undef;
my($digest) = undef;
$data = $main::Config{ServerAddress};
$rtx->add($data);
$digest = $rtx->hexdigest;
$main::Config{DbFile} = $main::Config{DbFolder} . "a_"."$digest".".cgi";	


# convert to lowercase and assign user name and password to Global variables.

unless (defined $main::Form{u})
{
	if (defined $main::Html{CookieAnswer}{user})
	{
	$main::Form{u} = $main::Html{CookieAnswer}{user};	
	};
};

unless (defined $main::Form{p})
{
	if (defined $main::Html{CookieAnswer}{auth})
	{
	$data = $main::Config{Env}{HTTP_USER_AGENT} . $main::Config{Env}{REMOTE_ADDR} . $main::Html{CookieAnswer}{user};
	$rtx->add($data);
	$digest = $rtx->hexdigest;
		if ($main::Html{CookieAnswer}{auth} eq $digest)
		{
		$main::Config{CookieAccess} = "YES";		
		} else {
			
			$main::Config{CookieAccess} = "NO";
			};
	};
};

$main::UserEnv{name} = urlDecode(lc($main::Form{u}));
$main::UserEnv{pass} = crypt(main::urlEncode(urlDecode(lc($main::Form{p}))),$main::Config{CryptSalt});
$FormPassword = CleanSpaces($FormPassword);
my(@raw) = undef;

	unless (-e $main::Config{DbFile}) {($SubDebug == 1) ? DebugOut("User DB File Does Not Exist!: \"$UserDbFile\"") : 0; lib_access_createdefaultuserfile($main::Config{DbFile});};
	unless (-e $main::Config{DbFile}) {main::AddError("e00003","\"$main::Config{DbFile}\""); die;};
	

	if ($UserEnv{name})
	{
# we check if the user is a current session user
	($SubDebug == 1) ? DebugOut("OK Username was passed \"$UserEnv{name}\"") : 0;
		if (main::lib_access_readuserinfo($main::Config{CacheFolder} . "$UserEnv{name}" . ".cgi"))
		{
		($SubDebug == 1) ? DebugOut("OK - returned from main::lib_access_readuserinfo") : 0;
		# Authentication is Complete.
		return 1;
		} else {
			($SubDebug == 1) ? DebugOut("FAILED - returned from lib_access_readuserinfo") : 0;
			# The session digest file was not found. Let's see if the user actually exists.		
				if (main::lib_access_checknewlogininfo())
				{
				# new user access is authenticated.
				($SubDebug == 1) ? DebugOut("OK - returned from lib_access_checknewlogininfo") : 0;
				return 1;
				} else {
					# there is no such user in the database, let's check the format of user name
					($SubDebug == 1) ? DebugOut("FAILED - returned from lib_access_checknewlogininfo") : 0;
						if (main::lib_access_checkusernameformat($main::Form{u})) 
						{
						# The format of the user name is correct. Offer a chance to register.
						($SubDebug == 1) ? DebugOut("OK - returned from lib_access_checkusernameformat \"$main::Form{u}\"") : 0;
						return 0;
						} else {
							main::AddError("e06");
							($SubDebug == 1) ? DebugOut("FAILED - returned from lib_access_checkusernameformat \"$main::Form{u}\"") : 0;
							return 0;
							};
					};
			
			};
	} else {
		($SubDebug == 1) ? DebugOut("No Username Passed? \"$UserEnv{name}\"") : 0;
		# main::AddError("e00010");
		
			unless (length($main::Form{sn}) < 4)
			{
					$data = time . $main::Config{ENV}{REMOTE_HOST};
					$rtx->add($data);
					$digest = $rtx->hexdigest;
					$_ = $digest;
					m!([\d\w][\d\w][\d\w][\d\w][\d\w])!i;
					$main::Form{sn} = $1;
					($SubDebug == 1) ? DebugOut("ok - Generated new session number: $main::Form{sn}") : 0;
			};
	
		if ($main::Config{AllowGuestAccess} == 1)
		{
		main::LoadLibrary("lib_login.pl");
		unless (-f $main::Config{GuestAccessCounterFile}) {main::SaveFile("$main::Config{GuestAccessCounterFile}","1")};
		if (-f $main::Config{GuestAccessCounterFile})
		{
		main::lib_access_cleanguestaccounts();
		my($Counter) = join("",main::ReadFile($main::Config{GuestAccessCounterFile}));	
		$Counter++;
		if ($Counter > $main::Config{GuestAccountLimit}) {$Counter = 1};
		main::SaveFile($main::Config{GuestAccessCounterFile},$Counter);
		$main::Form{newusername} = "guest" . "$Counter" . "\@stouk.com";
		$main::Form{newusergroup} = "guests";
		main::lib_login_adduser();
		$main::Form{u} = $main::Form{newusername};
		$main::Form{p} = $main::Config{DefaultPassword};
		# Call itself but now with the Guest user name created.
		main::lib_access_authenticate();
		} else {
			($SubDebug == 1) ? DebugOut("FAILED: Error! Could not find the Guest Counter File! \"$main::Config{GuestAccessCounterFile}\"") : 0;			
			};
		} else {
			return 0;	
			};
		
		
		};

};

sub main::lib_access_checknewlogininfo
{
my($SubDebug) = $main::SubID{lib_access_checknewlogininfo}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($rtx) = Digest::MD5->new;
my($data) = undef;
my($digest) = undef;
my($count) = undef;

my(@raw) = undef;
%main::User = undef;
my($key) = undef;

($SubDebug == 1) ? DebugOut("CHECKING if exists:  \"$main::Config{DbFile}\"") : 0;

		if (-e $main::Config{DbFile}) 
		{
		# digest user file exists, let's read it and find out the password:
		($SubDebug == 1) ? DebugOut("OK - file exists: \"$main::Config{DbFile}\"") : 0;
		my(%TempData) = undef;
		%TempData = main::ReadIntConfig($main::Config{DbFile});
			foreach $key (keys %TempData)
			{
				if (defined $key)
				{
					if ($TempData{$key}{name} eq $main::Form{u})
					{
					$main::User{name} = $TempData{$key}{name};
					$main::User{group} = $TempData{$key}{group};
					$main::User{password} = $TempData{$key}{password};
					$main::User{created} = $TempData{$key}{created};
					$main::User{digest} = $TempData{$key}{digest};
					};					
				};
			};

			if (($main::User{name}) && ($main::User{group}) )
			{
			# we were able to read it. Let's compare the password.
			($SubDebug == 1) ? DebugOut("OK - \$main::User{name} = $main::User{name} and \$main::User{group} = $main::User{group}") : 0;
			my($PassedAuth) = undef;
			($SubDebug == 1) ? DebugOut("Testing Match for: $main::User{name} and $UserEnv{name} and $main::User{password} and $UserEnv{pass}") : 0;
				if (($main::User{name} eq $UserEnv{name}) && ($main::User{password} eq $UserEnv{pass}) )
				{
				$PassedAuth = 1;	
				($SubDebug == 1) ? DebugOut("Matched by User and password...") : 0;	
				
				} else {
						($SubDebug == 1) ? DebugOut("Checking if \$main::Config{CookieAccess} eq \"$main::Config{CookieAccess}\"") : 0;
						if (($main::User{name} eq $UserEnv{name}) && ($main::Config{CookieAccess} eq "YES") )
						{
						($SubDebug == 1) ? DebugOut("Match By User and Cookie...") : 0;
						$PassedAuth = 1;	
						} else {
							($SubDebug == 1) ? DebugOut("Did Not Match") : 0;
							};
					};
				if ($PassedAuth == 1)
				{
				# user name and passwords are OK.
				# create a digest session file:
				($SubDebug == 1) ? DebugOut("OK - Password and Username match") : 0;
				$data = $UserEnv{name};
				$rtx->add($data);
				$digest = $rtx->hexdigest;	
				$main::Config{AuthenticationString} = $digest;	
				$main::User{digest} = $digest;
				$raw[$count++] = "name:"."$main::User{name}\n";
				$raw[$count++] = "group:"."$main::User{group}\n";
				$raw[$count++] = "pass:"."$main::User{password}\n";
				$raw[$count++] = "created:"."$main::User{created}\n";
				$main::Config{UserAccessDbFile} = $main::Config{DbAccessFolder} . "$digest" . ".cgi";
				$main::Config{UserAccessCacheFile} = $main::Config{CacheFolder} . "$digest" . ".cgi";
				SaveFile($main::Config{UserAccessCacheFile},"$main::User{digest}");
				SaveFile($main::Config{UserAccessDbFile},@raw);
				$data = time . $main::Config{ENV}{REMOTE_HOST};
				$rtx->add($data);
				$digest = $rtx->hexdigest;
				$_ = $digest;
				m!([\d\w][\d\w][\d\w][\d\w][\d\w])!i;
				$main::Form{sn} = $1;
				($SubDebug == 1) ? DebugOut("ok - Generated new session number: $main::Form{sn}") : 0;
				
				return 1;
				} else {
					# user name and password do not match;
					($SubDebug == 1) ? DebugOut("FAIELD - Password and Username NOT match ($main::User{name} eq $UserEnv{name}) and ($main::User{pass} eq $UserEnv{pass})") : 0;
					$main::Html{Login}{Error} .= "User name and password do not match<br>";
					main::AddError("e06");
					return 0;
					};
			} else {
				($SubDebug == 1) ? DebugOut("FAILED - \$main::User{name} = $main::User{name} and \$main::User{group} = $main::User{group}") : 0;
				main::AddError("e07");
				return 0;
				};
		} else {
			($SubDebug == 1) ? DebugOut("FAILED - no digest user file: \"$main::User{digestfile}\"") : 0;
			main::AddError("e08");
			return 0;
			};
};

sub main::lib_access_readuserinfo
{
my($SubDebug) = $main::SubID{lib_access_readuserinfo}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my(@raw) = undef;
$main::Config{AuthenticationFile} = $_[0];
%main::User = undef;
($SubDebug == 1) ? DebugOut("\$main::Config{AuthenticationFile} = $main::Config{AuthenticationFile}") : 0;

if (-e $main::Config{AuthenticationFile})
{
my($filemod)  = (stat($main::Config{AuthenticationFile}))[9]; 
	if ((time - $filemod) > $main::Config{SessionTime})
	{
	unlink($main::Config{AuthenticationFile});
	main::DebugOut("SESSION TIMED OUT!");
	};
 };
				
	if (-e $main::Config{AuthenticationFile})
	{
	($SubDebug == 1) ? DebugOut("OK Authentication file exists.") : 0;
	@raw = ReadFile($main::Config{AuthenticationFile});
	$main::User{digest} = $raw[0];
	$main::User{digestfile} = $main::Config{DbAccessFolder} . "$main::User{digest}" . ".cgi";
		if (-e $main::User{digestfile}) 
		{
		($SubDebug == 1) ? DebugOut("OK - exists \"$main::User{digestfile}\"") : 0;
		@raw = ReadFile($main::User{digestfile});
		
			foreach (@raw)
			{
			if ($_ =~  m!^name:(.*)!i) {$main::User{name} = $1; $main::User{name} =~ s!\n!!};
			if ($_ =~  m!^group:(.*)!i) {$main::User{group} = $1;$main::User{group} =~ s!\n!!};
			if ($_ =~  m!^pass:(.*)!i) {$main::User{pass} = $1 ;$main::User{pass} =~ s!\n!!};
			};

			if ((defined $main::User{name}) && (defined $main::User{group}) )
			{
			($SubDebug == 1) ? DebugOut("OK - \$main::User{name} = $main::User{name} and \$main::User{group} = $main::User{group}") : 0;
			$main::Config{AuthenticationString} = $main::UserEnv{name};
			SaveFile($main::Config{AuthenticationFile},$main::User{digest});
			return 1;
			} else {
				($SubDebug == 1) ? DebugOut("FAILED - \$main::User{name} = $main::User{name} and \$main::User{group} = $main::User{group}") : 0;
				return 0;
				};
		} else {
			($SubDebug == 1) ? DebugOut("FAILED - does not exist \"$main::User{digestfile}\"") : 0;
			return 0;
			};
	} else {
		($SubDebug == 1) ? DebugOut("FAIL Authentication file does not exist.") : 0;
		return 0;
		};
return 0;
};

	sub main::lib_access_checkusernameformat
	{
	if (($_[0] =~/@/) && ($_[0]) =~ /\.\w{2,3}$/ ) {return 1;} else {return 0;}	
	};

sub main::lib_access_createdefaultuserfile
{
my($SubDebug) = $main::SubID{lib_access_createdefaultuserfile}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;


my($UserDbFile) = $_[0];
my(%Default) = undef;
my($rtx) = undef;
my($data) = undef;
my($digest) = undef;
my(@UserData) = undef;
my($UserDataCount) = undef;
my(@DefaultUsers) = ("administrator","user","guest");
my(@DefaultGroups) = ("administrators","users","guests");
my($DefaultPassword) = "12345";
my($i) = undef;
my($keydigest) = undef;

	foreach ($i = 0; $i < @DefaultUsers; $i++)
	{
		$UserDataCount = 0;
		$rtx = Digest::MD5->new;
		$data = main::urlEncode("$DefaultUsers[$i]");
		$rtx->add($data);
		$digest = $rtx->hexdigest;
		$keydigest = "u" . "$digest";
		$Default{$keydigest}{name} = main::urlEncode("$DefaultUsers[$i]");
		$UserData[$UserDataCount++] = "name:"."$Default{$keydigest}{name}"."\n";
		$Default{$keydigest}{password} = crypt(main::urlEncode("$DefaultPassword"),$main::Config{CryptSalt});
		$UserData[$UserDataCount++] = "pass:"."$Default{$keydigest}{password}"."\n";
		$Default{$keydigest}{group} = main::urlEncode("$DefaultGroups[$i]");
		$UserData[$UserDataCount++] = "group:"."$Default{$keydigest}{group}"."\n";
		$UserData[$UserDataCount++] = "digest:"."$digest"."\n";
		$Default{$keydigest}{digest} = $digest;
		$main::Config{Temp} = $main::Config{DbAccessFolder} . $digest . ".cgi";	
		SaveFile("$main::Config{Temp}",@UserData);
		undef $rtx;undef $data;undef $digest;undef $keydigest;
	};

main::WriteIntConfig("config",\%Default,"$UserDbFile");
unless  (-e $UserDbFile) {main::AddError("e03");($SubDebug == 1) ? DebugOut("FAILED create default Access Database file. \"$UserDbFile\"") : 0;return 0};
return 1;
};


sub main::lib_access_LoginForm
{
my($SubDebug) = $main::SubID{lib_access_LoginForm}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;


$main::Html{LoginForm} = 
	qq(
	<table border=\"0\">
	<form method=\"post\" name=\"loginform\" action=\"$main::Config{ScriptWebPath}\" target=\"_top\">
	<tr>
	<td>$main::Html{Fs1} $main::Html{Text}{t001} $main::Html{FF}</td><td><input type=\"text\" size="30" name="u" /></td>
	</tr><tr>
	<td>$main::Html{Fs1} $main::Html{Text}{t002} $main::Html{FF}</td><td><input type=\"password\" size="30" name="p" /></td>
	</tr>
	<tr>
	<td></td><td><input type="submit" value=" Login! " /><input type="hidden" name="a" value="login" /></td>
	</tr>
	</form>
	</table>
	);	
return $main::Html{LoginForm};
};


sub main::lib_access_userkey
{
my($SubDebug) = $main::SubID{lib_access_userkey}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... start Assigning keydigest for $main::UserEnv{name}") : 0;	
my(%UserData) = undef;
my($key) = undef;
my($Result) = undef;
	if (-f $main::Config{DbFile})
	{
	%UserData = main::ReadIntConfig($main::Config{DbFile});
		foreach $key (keys %UserData)
		{
			if (($UserData{$key}{name} eq $main::UserEnv{name}) && (defined $UserData{$key}{name}) )
			{
			$UserEnv{keydigest} = $key;
			($SubDebug == 1) ? DebugOut("OK keydigest is assigned...") : 0;
			last;
			return $key;
			};	
		};	
	($SubDebug == 1) ? DebugOut("FAILED... could not find keydigest....") : 0;
	};	
};

sub main::lib_access_userdigest
{
my($SubDebug) = $main::SubID{lib_access_userdigest}{debug};
my($UserDigestName) = $_[0];	
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... start impersonating") : 0;
my(%UserData) = undef;
my($key) = undef;
my($Result) = undef;
if (-f $main::Config{DbFile})
{
%UserData = main::ReadIntConfig($main::Config{DbFile});

	if ($main::Form{imp} =~ m![\w\d]+!)
	{
		if (defined $UserData{$main::Form{imp}}{digest})
		{
		$Result = $UserData{$main::Form{imp}}{digest};	
		} else {
			 ($SubDebug == 1) ? DebugOut("FAILED: Impersonation data passed, but cannot find the digest: \$UserData{$main::Form{imp}}{digest} = \"$UserData{$main::Form{imp}}{digest}\"") : 0;
			 $UserDigestName = "guest";
			($SubDebug == 1) ? DebugOut("OK: Impersonation by name...\"$UserDigestName\"") : 0;		
			foreach $key (keys %UserData)
			{
			($SubDebug == 1) ? DebugOut("Checking $key : \"$UserData{$key}{name}\"") : 0;	
				if ((defined $key) && ($UserData{$key}{name} eq "$UserDigestName") )
				{
				$Result = $UserData{$key}{digest};
				$main::Form{imp} = $key;
				last;
				};
			};
			 
			};	
	} else {
		($SubDebug == 1) ? DebugOut("OK: Impersonation by name...\"$UserDigestName\"") : 0;		
		foreach $key (keys %UserData)
		{
		($SubDebug == 1) ? DebugOut("Checking $key : \"$UserData{$key}{name}\"") : 0;	
			if ((defined $key) && ($UserData{$key}{name} eq "$UserDigestName") )
			{
			$Result = $UserData{$key}{digest};
			$main::Form{imp} = $key;
			last;
			};
		};
		
		};

if (defined $Result)
{
($SubDebug == 1) ? DebugOut("OK Returned \"$Result\"") : 0;	
return $Result;
} else {
	($SubDebug == 1) ? DebugOut("FAILED - Did not return anything") : 0;
	return 0;
	};
} else {
	($SubDebug == 1) ? DebugOut("FAILED - Did not return anything") : 0;
	return 0;	
	};
};




sub main::lib_access_cleanguestaccounts
{
my($SubDebug) = $main::SubID{lib_access_cleanguestaccounts}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("CLEANING... old guest accounts") : 0;	
my($UserDigestName) = $_[0];
my(%UserData) = undef;
my($key) = undef;
if (-f $main::Config{DbFile})
{
%UserData = main::ReadIntConfig($main::Config{DbFile});
	foreach $key (keys %UserData)
	{
		if ($UserData{$key}{name} =~ m!^guest\d!i)
		{
		($SubDebug == 1) ? DebugOut("Checking : $UserData{$key}{name}") : 0;	
			if ((time - $UserData{$key}{created}) > $main::Config{GuestAccountLife})
			{
			($SubDebug == 1) ? DebugOut("Deleting : $UserData{$key}{name}") : 0;
			main::lib_access_deleteuser($UserData{$key}{name});	
			} else {
				($SubDebug == 1) ? DebugOut("Account is still active...") : 0;
				};
		};
	};

} else {
	return 0;	
	};

	
};


sub main::lib_access_deleteuser
{
my($SubDebug) = $main::SubID{lib_access_deleteuser}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;		
my($UserName) = $_[0];
my(%UserData) = undef;
my(%Temp) = undef;
my($key) = undef;
my($UserDigest) = undef;
($SubDebug == 1) ? DebugOut("DELETING: \"$UserName\"") : 0;	

my($keydigest) = undef;

if (-f $main::Config{DbFile})
{
($SubDebug == 1) ? DebugOut("Configuration file: \"$main::Config{DbFile}\"") : 0;
%UserData = main::ReadIntConfig($main::Config{DbFile});

	if ($UserName =~ m!@!)
	{
	($SubDebug == 1) ? DebugOut("OK: User is not a digest") : 0;	
		foreach $key (keys %UserData)
		{
			if (($UserData{$key}{name} =~ $UserName) && (defined $UserData{$key}{digest}) )
			{
			$UserDigest = $UserData{$key}{digest};
			$keydigest = $key;
			($SubDebug == 1) ? DebugOut("OK: Found Digest: \"$UserDigest\"") : 0;	
			last;
			};
		};
	} else {
		($SubDebug == 1) ? DebugOut("OK: User is a digest") : 0;	
			if (defined $UserData{$UserName}{digest})
			{
			$UserDigest = $UserData{$UserName}{digest};
			$keydigest = $UserName;
			};
		};

	if (defined $UserDigest)
	{
	($SubDebug == 1) ? DebugOut("User name to delete was confirmed: \"$UserData{$UserDigest}{name}\"") : 0;	
	
		($SubDebug == 1) ? DebugOut("Digest is defined - deleting folders...") : 0;
			my($temp) = undef;
			$temp = $main::Config{TempFolder} . $UserDigest . "/";
			if (-d $temp) 
			{
			rmtree($temp);
			($SubDebug == 1) ? DebugOut("OK - DELETED: \"$temp\"") : 0;
			};
			$temp = $main::Config{CacheFolder} . $UserDigest . "/";
			if (-d $temp) 
			{
			rmtree($temp);
			($SubDebug == 1) ? DebugOut("OK - DELETED: \"$temp\"") : 0;
			};
			$temp = $main::Config{DbFolder} . $UserDigest . "/";
			if (-d $temp) 
			{
			rmtree($temp);
			($SubDebug == 1) ? DebugOut("OK - DELETED: \"$temp\"") : 0;
			};
			$temp = $main::Config{TtsFolder} . $UserDigest . "/";
			if (-d $temp) 
			{
			rmtree($temp);
			($SubDebug == 1) ? DebugOut("OK - DELETED: \"$temp\"") : 0;
			};
			$temp = $main::Config{UEnvFolder} . $UserDigest . "/";
			if (-d $temp) 
			{
			rmtree($temp);
			($SubDebug == 1) ? DebugOut("OK - DELETED: \"$temp\"") : 0;
			};
			$main::Config{UserAccessDbFile} = $main::Config{DbAccessFolder} . "$UserDigest" . ".cgi";

			if (-f $main::Config{UserAccessDbFile})
			{
			unlink($main::Config{UserAccessDbFile});
			};
			
			
			foreach $key (keys %UserData)
			{
				if (defined $UserData{$key}{name})
				{
						if ($key eq "$keydigest")
						{
						($SubDebug == 1) ? DebugOut("UNDEFINED USER DATA \"$UserData{$key}{name}\" \"$UserData{$key}{created}\" - OK... Saving back the users data file") : 0;			
						} else {
							$Temp{$key} = $UserData{$key};
							};
				};
			};
			main::WriteIntConfig("config",\%Temp,$main::Config{DbFile});
	} else {
		($SubDebug == 1) ? DebugOut("FAILED: User name to delete was NOT confirmed: \"$UserData{$UserDigest}{name}\"") : 0;	
		};


} else {
	return 0;	
	};


	
};

1;
