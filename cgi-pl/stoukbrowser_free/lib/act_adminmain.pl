sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

$main::Config{login}{ActionList}{userprofile} = "Change Password";
$main::Config{login}{ActionList}{useradministration} = "User Manager";
$main::Config{login}{ActionList}{groupmanager} = "Group Manager";
};

sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($TrCount) = undef;
my($TdCount) = undef;
my($TdNumber) = 5;
my($key) = undef;
my($i) = undef;
my($h) = undef;
my($String) = qq(
<table border="1" cellpadding="2" cellspacing="0" style="width:100%; font-family:verdana,arial; font-size:8pt; background:#ffa">
);
my(@Temp) = undef;
my($tcount) = undef;
my($FirstChar) = undef;
my(@Color) = ("#faf","#efa","#fea","#afe","#bac","#cfb");
my($ColorID) = undef;
my($ColorCount) = undef;
my($Rest) = undef;
my($CaseChar) = undef;
my($PanelString) = qq(
<table border="1" cellpadding="2" cellspacing="0" style="width:100%; font-family:verdana,arial; font-size:8pt; background:#ffa">
<tr>
);
$PanelString .= qq(<td><a href="$main::UserEnv{href}&c=adminmain">All Commands</td>);
my(@Keys) = undef;
my($kid) = undef;

	foreach $key (sort keys %ActConfig)
	{
		if ($key)
		{

		if ($main::Form{onlyletter} =~ m!^\w!)
		{
			$key =~ m!^(\w)(.*)!;
			if ($main::Form{onlyletter} eq $1)
			{
			$Keys[$kid++] = $key;		
			};
		} else {
			$Keys[$kid++] = $key;			
			};
			

		};
	};

	my($TotalKeys) = scalar @Keys;
my(@ChartKeys) = undef;
my($ChartRowCount) = undef;
my($ChartColCount) = undef;
my($Columns) = 3;
my($tcount) = undef;

$ChartRowCount = int (($kid+1) / $Columns) + 1;
my($Counter) = undef;

	for ($i = 0; $i < $ChartRowCount; $i++)
	{
	$String .= qq(<tr>); 
		for ($h = 0; $h < $Columns; $h++)
		{
		$Counter = (($h * $ChartRowCount) + $i);
			$_ = $Keys[$Counter];
			m!^(\w)(.*)!;
			$FirstChar = $1;
			$Rest = $2;
			$FirstChar = uc($FirstChar);

			if ($Keys[$Counter])
			{
			$String .= qq(
			<td style="background:#ecd">
			<a href="$main::UserEnv{href}&c=editaction&aid=$Keys[$Counter]" target="_self"><b>$FirstChar</b>$Rest</a>
			&nbsp; <a href="$main::UserEnv{href}&c=$Keys[$Counter]" target="_self"><font size=3><b> &nbsp; ! </b></font> </a>
			&nbsp; <a href="JavaScript:newWindow('$main::UserEnv{href}&c=help&aid=$Keys[$Counter]','popup',400,300,'scrollbars=yes')"> <font size=3><b> ? </b></font></a>
			&nbsp;
			</td>
				);
			} else {
				$String .= qq(
				<td style="background:#ecd">
				&nbsp;
				</td>
				);
				};
		};
	$String .= qq(</tr>);
	};
	

	
	foreach $key (sort keys %ActConfig)
	{
	$key =~ m!^(\w)(.*)!;
	$CaseChar = $1;
		if ($FirstChar ne $1) 
		{
		$FirstChar = $CaseChar;
		$CaseChar = uc($CaseChar);
		$PanelString .= qq(<td><a href="$main::UserEnv{href}&c=adminmain&onlyletter=$FirstChar"><b>$CaseChar</b></td>); 

		};
	};	


$String .= "</table>";
$PanelString .= qq(</tr>
</table>
);

$String = main::act_adminmain_form() . "Library is <b>$Counter</b> actions strong." . $PanelString . $String;

$main::Html{ServiceText} =~ s!<insert-adminmain-content>!$String!is;
};

sub main::act_adminmain_form
{
my($String) = undef;

$String .= qq(
<DIV style=\"background:$main::Config{divopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor}\">
<center>
	<table BORDER=\"$main::Config{tbopt}{tb_border}\" CELLPADDING=\"$main::Config{tbopt}{tb_cpadding}\" CELLSPACING=\"$main::Config{tbopt}{tb_cspacing}\" 
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
1;