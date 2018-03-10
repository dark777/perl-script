# Action library for fbrowsedl


	sub main::pre_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute before Template generation:
	unless ($main::Form{rootpath} =~ m!\w!)
	{
	$main::Config{CEnv}{$main::Form{c}}{RootFolderPath} = "S:/FTPSERVER/DOWNLOADS/=-SYSTEM-=/";	
	} else {
		$main::Config{CEnv}{$main::Form{c}}{RootFolderPath} = $main::Form{rootpath};
		};
		
	$main::Config{CEnv}{$main::Form{c}}{OriginalDownloadFile} = 	$main::Config{CEnv}{$main::Form{c}}{RootFolderPath} . $main::Form{bfolder} . "/" . $main::Form{bfile};
	$main::Config{CEnv}{$main::Form{c}}{DownloadFilePath} = $main::Config{TempFolder} . "$main::Form{bfile}";
	$main::Config{CEnv}{$main::Form{c}}{DownloadWebFilePath} = $main::Config{ScriptWebRoot}. $main::ConfigEnv{TempFolder} . "$main::Form{bfile}";
	
		if (-e $main::Config{CEnv}{$main::Form{c}}{OriginalDownloadFile})
		{
		main::CopyFile($main::Config{CEnv}{$main::Form{c}}{OriginalDownloadFile},$main::Config{CEnv}{$main::Form{c}}{DownloadFilePath},1);
		} else {
			print "<br>Does Not Exist: $main::Config{CEnv}{$main::Form{c}}{OriginalDownloadFile} ";
			};
   		   
	};
		    
	sub main::post_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute after Template generation:
	
my($String) = undef;
$main::Config{$main::Form{c}}{ok} .= "<br><a href=\"$main::Config{CEnv}{$main::Form{c}}{DownloadWebFilePath}\">Download</a>";
$main::Config{$main::Form{c}}{error} .= "";
$String .= main::act_fbrowsedl_form();
	if (-e $main::Config{CEnv}{$main::Form{c}}{DownloadFilePath})
	{
	$String .= main::lib_html_Redirect($main::Config{CEnv}{$main::Form{c}}{DownloadWebFilePath});
	sleep(5);
	$String .= main::lib_html_Redirect(($main::UserEnv{href}."&c=fbrowsermain&bfolder=$main::Form{bfolder}"));
	$String .= "<br>$main::UserEnv{href} ". "&c=fbrowsermain&bfolder=$main::Form{bfolder}<br>";
	};
$String .= "<input type=\"submit\" value=\"Submit\" />";
$String = $main::Config{$main::Form{c}}{error} . $main::Config{$main::Form{c}}{ok} . $String;
$main::Html{ServiceText} =~ s!<insert-fbrowsedl-content>!$String!gis;
};


sub main::act_fbrowsedl_form

{
my($String) = undef;
my($key) = undef;
my($temp) = undef;

$String .= qq(
<DIV style=\"background:$main::Config{divopt}{tb_background}; color:$main::Config{divopt}{tb_textcolor}\">
<center>
<table BORDER=\"$main::Config{tbopt}{tb_border}\" CELLPADDING=\"$main::Config{tbopt}{tb_cpadding}\" CELLSPACING=\"$main::Config{tbopt}{tb_cspacing}\" 
style=\"width:$main::Config{tbopt}{tb_width}; 
font-family:$main::Config{divopt}{tb_fontfamily}; 
font-size:$main::Config{divopt}{tb_fontsize}pt; 
background:$main::Config{tbopt}{tb_background}; 
color:$main::Config{divopt}{tb_textcolor};\">

<tr>
	<td><b></b></td>
	<td><b></b></td>	
</tr>
);	


		
$String .= qq(
<tr>
	<td></td>
	<td></td>
</tr>
</table>
</center>
<p>
</DIV>
);
	
return $String;		
};
1;
