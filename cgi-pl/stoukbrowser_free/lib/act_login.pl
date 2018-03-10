sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

$main::Config{login}{ActionList}{userprofile} = "Change Password";
$main::Config{login}{ActionList}{useradministration} = "User Manager";
$main::Config{login}{ActionList}{groupmanager} = "Group Manager";
$main::Config{login}{ActionList}{sdbphonebookview} = "View Phonebook";
$main::Config{login}{ActionList}{sdbphonebookedit} = "Edit Phonebook Records";




if ($main::Form{nr} == 1)
{
	if (length ($main::Form{ur}) > 3)
	{
	$main::Config{DbNotConfirmedUserFile} = $main::Config{DbFolder} . "ncf_"."$main::Form{ur}".".cgi";			
		if (-e $main::Config{DbNotConfirmedUserFile})
		{
		my($String) = join("",(main::ReadFile($main::Config{DbNotConfirmedUserFile})));
		if ($String =~ m!(.*)\|(.*)!) 
		{
			$main::Form{newusername} = $1;
			$main::Form{newusergroup} = $2;
			$main::Form{newusergroup} =~ s!administrators!!gis;
			DebugOut("Registering $main::Form{newusername} -> $main::Form{newusergroup}");			
				if (main::act_useradministration_adduser())
				{
				$main::Form{u} = $main::Form{newusername};	
				$main::Html{Login}{Error} .= "<br>Registration successful!";
				$main::Html{Login}{Error} .= "<br>Please Provide your password, specified in e-mail to login.<br>";
				unlink($main::Config{DbNotConfirmedUserFile});
				$main::Html{Login}{Error} .= main::lib_html_Redirect(($main::Config{ScriptWebRoot}."?u=$main::Form{u}&c=$main::Form{cr}"));
				} else {
					$main::Html{Login}{Error} .= "<br>There were errors during the registration process. Please contact support.";
					};
		} else {
			$main::Html{Login}{Error} .= "<br>There were errors during the registration process. Please contact support.";			
			DebugOut("FAILED: Could not properly parse pre-registration data file!");
			};
		
		} else {
			$main::Html{Login}{Error} .= "<br>There were errors during the registration process. Please contact support.";			
			DebugOut("FAILED: New registration file does not exist! registration failed!");
			};
	
	};

} else {
		if ($main::Form{submit} =~ m!registration!i)	
		{
			if (main::lib_access_checkusernameformat($main::Form{u}))			
			{
			main::act_login_newregistration();
				
			} else {
				DebugOut("ERROR: Incorrect e-mail format provided during the registration process.");
				$main::Html{Login}{Error} .= "<b>ERROR: </b>Incorrect e-mail format provided as a username: \"$main::Form{u}\".<br>Please specify your email address as a user name.";
				};
		};
	};


	
};

sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
$main::Form{u} = $main::Form{newusername};
	if ($main::Form{cr} =~ m!\w!)
	{
	$main::Form{c} = $main::Form{cr};	
	};

my($String) = undef;
my($FormString) = undef;

	if ((($main::UserEnv{name} eq "administrator") && ($main::Config{UserLogged} == 1) )  || (($main::UserEnv{group} =~ m!administrators!) && ($main::Config{UserLogged} == 1) ))
	{
	$String .= main::act_login_defaultadminpage();
	} elsif ($main::UserEnv{name} =~ m!^guest!i)
	{
	$String .= main::act_login_defaultguestpage();	
	} elsif ($main::Config{UserLogged} == 1) 
		{
		$String .= main::act_login_defaultuserpage();	
		};
	
	if (($main::Config{UserLogged} == 0) || ($main::UserEnv{name} =~ m!^guest!i) )
	{
	$FormString = 	main::act_login_form();
	};

$main::Html{ServiceText} =~ s!<insert-login-error>!$main::Html{Login}{Error}!gis;
$main::Html{ServiceText} =~ s!<insert-login-data>!$String!gis;
$main::Html{ServiceText} =~ s!<insert-login-formdata>!$FormString!gis;

};

sub main::act_login_newregistration
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

my($rtx) = Digest::MD5->new;
my($data) = undef;
my($digest) = undef;
$data = $main::Config{ServerAddress} . $main::Form{u};
$rtx->add($data);
$digest = $rtx->hexdigest;
$main::Config{DbNotConfirmedUserFile} = $main::Config{DbFolder} . "ncf_"."$digest".".cgi";	
$main::Config{NewRegistrationDigestFile} = $main::Config{DbNotConfirmedUserFile};
$main::DConfig{script}{newregistrationaddress} = $main::DConfig{script}{webpath} . "?nr=1" . "&ur=$digest&cr=$main::Form{c}";
$main::DConfig{script}{defaultpassword} = $main::Config{DefaultPassword};
main::SaveFile($main::Config{DbNotConfirmedUserFile},"$main::Form{u}|guests,$main::Form{agi}");
my($EmailTemplateFile) = $main::Config{TtsFolder}."newreg.cgi";
my($String) = undef;
my($Debug) = 1;


	if (-e $EmailTemplateFile)
	{
	$String = join("",(main::ReadFile($EmailTemplateFile)));
	} else {
		$String = main::act_Login_newemailtemplate();
		};
$String = main::lib_act_template($String);
($SubDebug == 1) ? DebugOut("OK Sending New User registration: User \"$main::Form{u}\" through server: \"$Config{SmtpServer}\" from \"$main::DConfig{script}{adminemail}\". Message: \n$String") : 0;
  				eval {
  					(new Mail::Sender) ->MailMsg({smtp => $Config{SmtpServer},
					from => "$main::DConfig{script}{adminemail}",
					to =>"$main::Form{u}",
					subject => "Registration",
					msg => "$String"}
					);
					
					$main::Html{Login}{Error} .= "<br>OK. Registration was sent to your e-mail address.<br>";
					$main::Html{Login}{Error} .= "Check your e-mail box shortly.<br>";
					$main::Html{Login}{Error} .= "If there is a problem, contact $main::DConfig{script}{adminemail}<br>";
					DebugOut("OK - Sent registration to: \"$main::Form{u}\"");		

					if ($Debug == 1)
					{
	  					(new Mail::Sender) ->MailMsg({smtp => $Config{SmtpServer},
						from => "$main::DConfig{script}{adminemail}",
						to =>"sergy\@stouk.com",
						subject => "Registration",
						msg => "\"$main::Form{c}\" New User Just Asked for registration: $main::Form{u}"}
						);
						
					};
					
 					} or $main::Html{Login}{Error} .="$Mail::Sender::Error\n";
};
sub main::act_Login_newemailtemplate
{
my($String) =
qq(
Hello,

New registration request confirmation.


Someone, possibly yourself, has requested new registration
with:
_config-server-name_

To confirm your registration and log into the system, please
click on the following link:
_config-script-newregistrationaddress_

Your default password (which you can change after login) is:
_config-script-defaultpassword_

If this message is recieved in error, please ignore it.

Registration request was recieved from computer with address:
_config-user-ip_

If there is any problem with registration process,
please contact: 
_config-script-adminemail_

Thank You.
Have a nice day!
);	
return $String;
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
			if ($main::Form{newusergroup} =~ m!\w+!)
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
				$data = main::urlEncode("$main::Form{newusername}");
				$rtx->add($data);
				$digest = $rtx->hexdigest;
				$keydigest = "u" . "$digest";
					unless (defined $lib_adduser{$keydigest}{name})
					{
					$lib_adduser{$keydigest}{name} = $main::Form{newusername};
					$lib_adduser{$keydigest}{group} = $main::Form{newusergroup};
					$lib_adduser{$keydigest}{password} = crypt($main::Form{newuserpass},$main::Config{CryptSalt});
					$data = $lib_adduser{$keydigest}{name};
					$rtx->add($data);
					$digest = $rtx->hexdigest;
					$lib_adduser{$keydigest}{digest} = $digest;
					main::WriteIntConfig("config",\%lib_adduser,$main::Config{DbFile});
					
					my(@DigestFileData) = undef;
					$DigestFileData[$DFD++] = "name:$lib_adduser{$keydigest}{name}\n";
					$DigestFileData[$DFD++] = "group:$lib_adduser{$keydigest}{group}\n";
					$DigestFileData[$DFD++] = "pass:$lib_adduser{$keydigest}{password}\n";
					
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

sub main::act_login_defaultadminpage
{
my($String) = undef;

$String .= qq(
<DIV style=\"background:$main::Config{divopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor}\">
<center>
	<table BORDER=\"$main::Config{wms}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{tbopt}{tb_cpadding}\" CELLSPACING=\"$main::Config{tbopt}{tb_cspacing}\" 
	style=\"width:$main::Config{tbopt}{tb_width}; font-family:$main::Config{divopt}{tb_fontfamily}; 
	font-size:$main::Config{divopt}{tb_fontsize}pt; background:$main::Config{tbopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor};\">
<tr>
	<td>
	<b>Administrator Links:</b>
	</td>
</tr>
<tr>
	<td>
		[<a href="$main::UserEnv{href}&c=adminmain">Main Development Area</a>] 
		[<a href="$main::UserEnv{href}&c=configroot">General Configuration</a>] 
	</td>

</tr>
<tr>
	<td>
	</td>

</tr>
);

$String .= "<tr><td>";
	my($key) = undef;
	my($keycount) = 0;
	foreach $key (sort keys %{$main::Config{login}{ActionList}})
	{
		if ($key)
		{
			if (main::checkacl("$key"))
			{
				$keycount++;
				if (($keycount % 5) == 0)
				{
				$String .= "</td></tr><tr><td>";	
				};
				$String .= qq(
					[<a href="$main::UserEnv{href}&c=$key" target="_self">$main::Config{login}{ActionList}{$key}</a>] 
					);		
				if (($keycount % 5) == 0)
				{
				#$String .= "</td></tr>";	
				};

			};
		};
	};
$String .= "</td></tr>";

$String .= qq(
</table>
</center>
<p>
</DIV>
);




return $String;	
};

sub main::act_login_defaultuserpage
{
my($String) = undef;

$String .= qq(
<DIV style=\"background:$main::Config{divopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor}\">
<center>
	<table BORDER=\"$main::Config{wms}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{tbopt}{tb_cpadding}\" CELLSPACING=\"$main::Config{tbopt}{tb_cspacing}\" 
	style=\"width:$main::Config{tbopt}{tb_width}; font-family:$main::Config{divopt}{tb_fontfamily}; 
	font-size:$main::Config{divopt}{tb_fontsize}pt; background:$main::Config{tbopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor};\">
<tr>
	<td>
	<b>Welcome: $main::UserEnv{name}!</b>
	</td>

</tr>
<tr>
	<td>
	
	</td>

</tr>
<tr>
	<td>
	
	</td>

</tr>
<tr>
	<td>
	You can access the following areas:
	</td>

</tr>
);

$String .= "<tr><td>";
	my($key) = undef;
	my($keycount) = 0;
	foreach $key (sort keys %{$main::Config{login}{ActionList}})
	{
		if ($key)
		{
			if (main::checkacl("$key"))
			{
				$keycount++;
				if (($keycount % 5) == 0)
				{
				$String .= "</td></tr><tr><td>";	
				};
				$String .= qq(
					[<a href="$main::UserEnv{href}&c=$key" target="_self">$main::Config{login}{ActionList}{$key}</a>] 
					);		
				if (($keycount % 5) == 0)
				{
				#$String .= "</td></tr>";	
				};

			};
		};
	};
$String .= "</td></tr>";
#### CHECKING ACCESS for wmsadmin
#    	if (main::checkacl("wmsadmin"))
#    	{
#		$String .= 
#		qq(
#		<tr>
#			<td>
#			<IFRAME SRC="$main::UserEnv{href}&c=wmsadmin&sn=$main::Form{sn}" name="iframe-wmsadmin" border="0" width="100%" height="650" scrolling="no"></IFRAME>
#			</td>
#		</tr>
#		);    		
#   	};

	

$String .= qq(

</table>
</center>
<p>
</DIV>
);



return $String;	
};

sub main::act_login_defaultguestpage
{
my($String) = undef;
$String .= qq(
<DIV style=\"background:$main::Config{divopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor}\">
<center>
	<table BORDER=\"$main::Config{wms}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{tbopt}{tb_cpadding}\" CELLSPACING=\"$main::Config{tbopt}{tb_cspacing}\" 
	style=\"width:$main::Config{tbopt}{tb_width}; font-family:$main::Config{divopt}{tb_fontfamily}; 
	font-size:$main::Config{divopt}{tb_fontsize}pt; background:$main::Config{tbopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor};\">
<tr>
	<td>
	<b></b>
	</td>

</tr>
<tr>
	<td>
	</td>

</tr>
</table>
);

#### CHECKING ACCESS for wmsadmin
# my($FrameCommand) = "wmsadmin";
#    	if (main::checkacl("$FrameCommand"))
#    	{
#		$String .= 
#		qq(
#		<tr>
#			<td>
#			<IFRAME SRC="$main::UserEnv{href}&c=$FrameCommand&sn=$main::Form{sn}" name="iframe-wmsadmin" border="0" width="100%" height="650" scrolling="no"></IFRAME>
#			</td>
#		</tr>
#		);    		
#   	};

$String .= qq(
</center>
<p>
</DIV>
);
return $String;	
};

sub main::act_login_defaultgrouppage
{
my($String) = main::lib_config_defaultstyle();
$String = qq(


);
return $String;	
};


sub main::act_login_form
{
my($String) = main::lib_config_defaultstyle();

$String .= qq(

<DIV valign="bottom" style=\"background:$main::Config{divopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor}\">
<center>
	<table BORDER=\"$main::Config{wms}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{tbopt}{tb_cpadding}\" CELLSPACING=\"$main::Config{tbopt}{tb_cspacing}\" 
	style=\"width:$main::Config{tbopt}{tb_width}; font-family:$main::Config{divopt}{tb_fontfamily}; 
	font-size:$main::Config{divopt}{tb_fontsize}pt; background:$main::Config{tbopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor};\">

	<form method="post" name="loginform" action="$main::Config{ScriptWebPath}" target="_self">
	<tr>
);

if ($main::Config{Param}{u}=~ m!@!)
{
	$String .= qq(
	<td valign="top">User name: </td><td><input type="text" size="30" name="u"  value="$main::Config{Param}{u}"/></td>
	);
} else {
		if ($main::Html{CookieAnswer}{user} =~ m!@!)
		{
	$String .= qq(
	<td valign="top">User name: </td><td><input type="text" size="30" name="u"  value="$main::Html{CookieAnswer}{user}"/></td>
	);
			
		} else {
	$String .= qq(
	<td valign="top">User name: </td><td><input type="text" size="30" name="u"  value=""/></td>
	);
			
			};
	};
$String .= qq(
	
	</tr><tr>
	<td valign="top">Password: </td><td><input type="password" size="30" name="p" /></td>
	</tr>
	<tr>
	<td valign="top"></td><td valign="top"><input type="submit" value=" Login! " />
	Remember me: <input type="CHECKBOX" name="rememberme" value="1" CHECKED />
	<input type="hidden" name="a" value="login" />
	<input type="hidden" name="default" value="$main::Form{default}" />
	<input type="hidden" name="c" value="$main::Form{c}" />
	<input type="hidden" name="cr" value="$main::Form{cr}" />
	<input type="hidden" name="agi" value="$main::Form{agi}" /></td>
	</tr>
);


	if ($main::Config{AllowGuestRegistration} == 1)
	{
		$String .= qq(
			<tr>
			<td valign="top"></td><td valign="top">
		<hr>If you do not have a password,<br> specify your e-mail address as the user name,<br> click "New Registration!" and the password will be sent to you by e-mail.<br><b>Reminder: </b>After loggin in, you should change the e-mailed password.
		
		<br><input type="submit" value=" New Registration! " name="submit"/>
		</td>
			</tr>
		);
	};
$String .= qq(	
	</form>
	</table>
</center>	
</DIV>
);	
return $String;
};


1;
