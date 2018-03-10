# Action library for userprofileadm


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

($SubDebug == 1) ? DebugOut("CHECKING: USER Defined? \"$UserData{$main::Form{mu}}{name}\"") : 0;

if (defined $UserData{$main::Form{mu}}{name})
{

($SubDebug == 1) ? DebugOut("YES: USER Defined - OK \"$UserData{$main::Form{mu}}{name}\"") : 0;
my(@temp) = undef;

	foreach $key (keys %main::Form)
	{
		
	($SubDebug == 1) ? DebugOut("CHECKING: $key") : 0;
		if ($key =~ m!group-(\w+)!i)
		{
			if (defined $1)
			{
			push @temp, $1;		
			($SubDebug == 1) ? DebugOut("PUSHING: \@temp = \"@temp\"") : 0;		
			};

		};

	};
		if ($#temp > 0) 
		{
		$UserData{$main::Form{mu}}{group} = join(",",@temp);
		$UserData{$main::Form{mu}}{group} =~ s!^,!!i;
		($SubDebug == 1) ? DebugOut("OK - \@temp = \"@temp\" GROUP: Updated group list for user : \$UserData{$main::Form{mu}}{group}") : 0;
		};

#	if ($main::Form{mugroup} =~ m!\w!)
#	{
#	$UserData{$main::Form{mu}}{group} = $main::Form{mugroup};
#	($SubDebug == 1) ? DebugOut("OK - Updated group list for user : \$UserData{$main::Form{mu}}{group} = $UserData{$main::Form{mu}}{group}, \$main::Form{mu} = $main::Form{mu}") : 0;
#	};

	if ($main::Form{muemail} =~ m!\w!)
	{
		if (main::lib_access_checkusernameformat($main::Form{muemail}))
		{
		$UserData{$main::Form{mu}}{email} = $main::Form{muemail};	
		($SubDebug == 1) ? DebugOut("OK - Updated e-mail for user: \$UserData{$main::Form{mu}}{email} = $UserData{$main::Form{mu}}{email}") : 0;
		} else {
			($SubDebug == 1) ? DebugOut("FAILED: User e-mail format is wrong!") : 0;
			$main::Html{act_userprofileadm}{error} .= "<b><br>ERROR: incorrect e-mail format: \"$main::Form{muemail}\"</b>";
			};
	};


	unless ($main::Config{DemoApp} == 1)
	{
	main::WriteIntConfig("config",\%UserData,"$main::Config{DbFile}");
	};



} else {
	($SubDebug == 1) ? DebugOut("FAILED: User \$UserData{$main::Form{mu}}{name} = \"$UserData{$main::Form{mu}}{name}\" is not defined!") : 0;
	$main::Html{act_userprofileadm}{error} .= "<b><br>ERROR: User not Found! \"$UserData{$main::Form{mu}}{name}\"</b>";
	};
	
};


sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute After Template generation
# Example of adding Processed data to the Template:
# Unremark the following lines to see the action:
my($rtx) = Digest::MD5->new;
my($data) = undef;
my($digest) = undef;
$data = $main::Config{ServerAddress};
$rtx->add($data);
$digest = $rtx->hexdigest;
$main::Config{DbFile} = $main::Config{DbFolder} . "a_"."$digest".".cgi";
my(%UserData) = undef;
($SubDebug == 1) ? DebugOut("READING: $main::Config{DbFile}") : 0;
%UserData = main::ReadIntConfig($main::Config{DbFile});	

($SubDebug == 1) ? DebugOut("CHECKING: \"$main::Form{mu}\" User group: \"$UserData{$main::Form{mu}}{group}\" for user: \"$UserData{$main::Form{mu}}{name}\"") : 0;


my($String) = qq(
<table border="1" cellpadding="2" cellspacing="0" style="width:100%; font-family:verdana,arial; font-size:8pt; background:#4fa">
);

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
		<b>Delete account:</b>
		</td>
		</tr>
		);	

my($TempString) = qq(
<table border="0" cellpadding="0" cellspacing="1" style="width:100%; font-family:verdana,arial; font-size:8pt; background:#4fa">
);
my($gkey) = undef;
($SubDebug == 1) ? DebugOut("CHECKING: User group: \"$UserData{$main::Form{mu}}{group}\" for user: \"$UserData{$main::Form{mu}}{name}\"") : 0;

	foreach $gkey (sort keys %{$main::Config{Groups}})
	{
		if ($main::Config{Groups}{$gkey}{active} == 1)
		{
		($SubDebug == 1) ? DebugOut("CHECKING: If User group: has \"$gkey\" in \"$UserData{$main::Form{mu}}{group}\"") : 0;
			if (($UserData{$main::Form{mu}}{group} =~ m!$gkey!i) && (defined $gkey) )
			{
			($SubDebug == 1) ? DebugOut("YES: User group: has \"$gkey\" in \"$UserData{$main::Form{mu}}{group}\"") : 0;
				$TempString .= "<tr><td>$gkey</td><td><input type=\"checkbox\" name=\"group-$gkey\"  value=\"group-$gkey\" checked=\"1\"></td></tr>";
			} else {
			($SubDebug == 1) ? DebugOut("NO: User group: has \"$gkey\" in \"$UserData{$main::Form{mu}}{group}\"") : 0;
				$TempString .= "<tr><td>$gkey</td><td><input type=\"checkbox\" name=\"group-$gkey\"  value=\"group-$gkey\" ></td></tr>";
				};
		
		};
	};
$TempString .= "</table>";	
# <input type="text" name="mugroup" value="$UserData{$main::Form{mu}}{group}" size="30"/>
	$String .= qq(
		<tr>
		<td>
		$UserData{$main::Form{mu}}{name}
		</td>
		<td>
		
		$TempString
		</td>
		<td>
		<input type="text" name="muemail" value="$UserData{$main::Form{mu}}{email}" size="40"/>	
			
		</td>
		<td>
		&nbsp;$UserData{$main::Form{mu}}{voteresults}
		</td>
		<td>
		&nbsp;$UserData{$main::Form{mu}}{membersince}
		</td>
		<td>
		&nbsp;$UserData{$main::Form{mu}}{lastlogindate}
		</td>
		);

		if ($UserData{$main::Form{mu}}{name} =~ m!administrator!)
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
				&nbsp;<a href="$main::UserEnv{href}&c=useradministration&delusr=$UserData{$main::Form{mu}}{name}&sn=$main::Form{sn}">Delete $UserData{$main::Form{mu}}{name}</a>
				</td>		
				</tr>
				);	
			};	

	$String .= qq(
	</table>
	);
			$String .= qq(
			<input type="hidden" name="mu" value="$main::Form{mu}"/>
				);	
$main::Html{ServiceText} =~ s!<insert-userprofileadmerror-content>!$main::Html{act_userprofileadm}{error}!gis;
$main::Html{ServiceText} =~ s!<insert-userprofileadm-content>!$String!gis;
};
1;
