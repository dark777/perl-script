# Action library for useradministration


sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute before Template generation
my($rtx) = Digest::MD5->new;
my($data) = undef;
my($digest) = undef;
$data = $main::Config{ServerAddress};
$rtx->add($data);
$digest = $rtx->hexdigest;
$main::Config{DbFile} = $main::Config{DbFolder} . "a_"."$digest".".cgi";
my(%UserData) = main::ReadIntConfig($main::Config{DbFile});	
my($key) = undef;

	if ($main::Form{newusername})
	{
		$main::Form{newusergroup} = "guests";
		$main::Form{newuserpass} = "12345";
		unless ($main::Config{DemoApp} == 1)
		{
		main::act_useradministration_adduser($main::Form{newusername});
		};
	};

	if ($main::Form{delusr})
	{

		if (($main::Form{confirmdelete}) && ($main::Form{confirm} eq "Yes") )
		{
		#undef $UserData{$main::Form{confirmdelete}};	
		#main::WriteIntConfig("config",\%UserData,$main::Config{DbFile});
			unless ($main::Config{DemoApp} == 1)
			{
			main::lib_access_deleteuser($main::Form{confirmdelete})
			};
		} else {
				foreach $key (keys %UserData)
				{
				if ($main::Form{delusr} eq "$UserData{$key}{name}") {$main::Html{useradministration}{DeleteConfirm} = $key; };
				};
			};	
	};

};

sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute After Template generation
my($rtx) = Digest::MD5->new;
my($data) = undef;
my($digest) = undef;
$data = $main::Config{ServerAddress};
$rtx->add($data);
$digest = $rtx->hexdigest;
$main::Config{DbFile} = $main::Config{DbFolder} . "a_"."$digest".".cgi";
my(%UserData) = main::ReadIntConfig($main::Config{DbFile});	
my($key) = undef;
my($String) = qq(
<table border="1" cellpadding="2" cellspacing="0" style="width:100%; font-family:verdana,arial; font-size:8pt; background:#4fa">
);
#{$RowData{$b}{$AutoFieldName} <=> $RowData{$a}{$AutoFieldName} }
#sort {$UserData{$a}{name} <=> $UserData{$b}{name}}
	$String .= qq(
		<tr>
		<td>
		<b>User name:</b>
		</td>
		<td>
		<b>Membership:</b>
		</td>
		<td>
		<b>Email list:</b>
		</td>
		<td>
		<b>Vote results:</b>
		</td>
		<td>
		<b>Member since:</b>
		</td>
		<td>
		<b>Last login:</b>
		</td>
		<td>
		<b>Modify account:</b>
		</td>
		<td>
		<b>Delete account:</b>
		</td>

		</tr>
		);	
		
	foreach $key (sort {$UserData{$a}{name} cmp $UserData{$b}{name}} (keys %UserData))
	{
	
	unless ($UserData{$key}{name} =~ m!guest\d+!i)
	{
	$String .= qq(
		<tr>
		<td>
		$UserData{$key}{name}
		</td>
		<td>
		$UserData{$key}{group}
		</td>
		<td>
		&nbsp;$UserData{$key}{email}
		</td>
		<td>
		&nbsp;$UserData{$key}{voteresults}
		</td>
		<td>
		&nbsp;$UserData{$key}{membersince}
		</td>
		<td>
		&nbsp;$UserData{$key}{lastlogindate}
		</td>
		<td>
		&nbsp;<a href="$main::UserEnv{href}&c=userprofileadm&mu=$key&sn=$main::Form{sn}">Modify $UserData{$key}{name}</a>
		</td>		
		);
		
		if ($UserData{$key}{name} =~ m!administrator!)
		{
		$String .= qq(
			<td>
			&nbsp;
			</td>		
			</tr>
			);	
		} else {
			$String .= qq(
				<td>
				&nbsp;<a href="$main::UserEnv{href}&c=useradministration&delusr=$UserData{$key}{name}&sn=$main::Form{sn}">Delete $UserData{$key}{name}</a>
				</td>		
				</tr>
				);	
			};
	};


	};
	$String .= qq(
	</table>
	);
$main::Html{ServiceText} =~ s!<insert-useradministration-content>!$String!is;

		if (defined $main::Html{useradministration}{DeleteConfirm})
		{
			$String = qq(
			<br>
			<b>Are you sure that you wish to delete user: $main::Form{delusr}? 
			<input type="submit" name="confirm" value="Yes"/> or <input type="submit" name="confirm" value="No"/>
			<input type="hidden" name="confirmdelete" value="$main::Html{useradministration}{DeleteConfirm}"/>
			<input type="hidden" name="c" value="$main::Form{c}"/>
			<input type="hidden" name="sn" value="$main::Form{sn}"/>
			</b></br>
				);
	$main::Html{ServiceText} =~ s!<insert-useradministration-confirm>!$String!is;
	};

		if (defined $main::Html{useradministration}{Error})
		{
			$String = qq(
			<br>
			<b>$main::Html{useradministration}{Error}
			</b>
			</br>
				);
	$main::Html{ServiceText} =~ s!<insert-useradministration-confirm>!$String!is;
	};



};


sub main::act_useradministration_adduser
{
my($SubDebug) = $main::SubID{act_useradministration_adduser}{debug};
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

				if (main::act_useradministration_adduser_checkusername($main::Form{newusername}))
				{
				$rtx = Digest::MD5->new;
				$data = main::urlEncode($main::Form{newusername});
				$rtx->add($data);
				$digest = $rtx->hexdigest;
				$keydigest = "u" . "$digest";
					unless (defined $lib_adduser{$keydigest}{name})
					{
					$lib_adduser{$keydigest}{name} = $main::Form{newusername};
					$lib_adduser{$keydigest}{group} = $main::Form{newusergroup};
					$lib_adduser{$keydigest}{password} = crypt($main::Form{newuserpass},$main::Config{CryptSalt});
					main::WriteIntConfig("config",\%lib_adduser,$main::Config{DbFile});
					
					my(@DigestFileData) = undef;
					
					$DigestFileData[$DFD++] = "name:$lib_adduser{$keydigest}{name}\n";
					$DigestFileData[$DFD++] = "group:$lib_adduser{$keydigest}{group}\n";
					$DigestFileData[$DFD++] = "pass:$lib_adduser{$keydigest}{password}\n";
					$data = $lib_adduser{$keydigest}{name};
					$rtx->add($data);
					$digest = $rtx->hexdigest;
					$main::Config{temp}{digestfile} = $main::Config{DbFolder} . "$digest" . ".cgi";
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

sub main::act_useradministration_adduser_checkusername
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

1;
