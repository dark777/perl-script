# Action library for fbrowsermain


	sub main::pre_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute before Template generation:
	main::LoadLibrary("lib_fbrowser.pl");
	main::lib_fbrowser_readconfig();
	
	unless ((-d $main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{path}) && ($main::Form{rootpath} =~ m!\w!))
	{
	$main::Config{CEnv}{$main::Form{c}}{RootFolderPath} = undef;	
	} else {
		$main::Config{CEnv}{$main::Form{c}}{RootFolderPath} = $main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{path} . "/";
		$main::Config{CEnv}{$main::Form{c}}{RootFolderWebPath} = $main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{webpath} . "/";
		};

	$main::Config{CEnv}{$main::Form{c}}{OriginalDownloadFile} = 	$main::Config{CEnv}{$main::Form{c}}{RootFolderPath} . $main::Form{bfolder} . "/" . $main::Form{bfile};
	
	if ($main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{upload} eq "YES")
	{
	main::LoadLibrary("lib_upload.pl");
	$main::Config{CEnv}{$main::Form{c}}{AllowUpload} = "<br><input type=\"file\" name=\"upload\" size=\"60\">";	
		if ($main::Form{upload} =~ m!\w!)
		{
			$main::Form{upload} =~ s!\\!/!gi;
			my($BinFile) = undef;
			my(@temp) = split("/",$main::Form{upload});
			$BinFile = $temp[$#temp];			
				if ($BinFile =~ m!\w!)
				{
				$BinFile = $main::Config{CEnv}{$main::Form{c}}{RootFolderPath} . $main::Form{bfolder} . "/" . "$BinFile";					
				print "<br>$BinFile";

					unless ($main::Config{DemoApp} == 1)
					{
					main::lib_upload_file("upload",$BinFile,0)
					};
				};
		};
	} else {
		$main::Config{CEnv}{$main::Form{c}}{AllowUpload} = undef;
		};




		if ($main::Config{fbrowser}{config}{securecache} eq "YES")
		{
			$main::Config{CEnv}{$main::Form{c}}{DownloadFilePath} = $main::Config{TempFolder} . "$main::Form{bfile}";
			$main::Config{CEnv}{$main::Form{c}}{DownloadWebFilePath} = $main::Config{ScriptWebRoot}. $main::ConfigEnv{TempFolder} . "$main::Form{bfile}";
		} else {
			$main::Config{CEnv}{$main::Form{c}}{DownloadFilePath} = $main::Config{CEnv}{$main::Form{c}}{RootFolderPath}. $main::Form{bfolder} ."/". "$main::Form{bfile}";
			$main::Config{CEnv}{$main::Form{c}}{DownloadWebFilePath} = $main::Config{CEnv}{$main::Form{c}}{RootFolderWebPath} . $main::Form{bfolder} ."/". "$main::Form{bfile}";
			};
		
				if (-e $main::Config{CEnv}{$main::Form{c}}{DownloadFilePath})
				{
				$main::Config{CEnv}{$main::Form{c}}{AddExtentionRevertLine} = "$main::Config{CEnv}{$main::Form{c}}{DownloadFilePath}" . "|";
				};
		
			if ($main::Form{extention} =~ m!^\w\w\w$!i)
			{
			$main::Config{CEnv}{$main::Form{c}}{DownloadFilePath} .= ".". $main::Form{extention};	
			$main::Config{CEnv}{$main::Form{c}}{DownloadWebFilePath} .= ".". $main::Form{extention};
			$main::Config{$main::Form{c}}{ok} .= "<br><b>Note: Remove Extention .$main::Form{extention} after download.</b>";
			$main::Config{CEnv}{$main::Form{c}}{AddExtentionRevertLine} .= "$main::Config{CEnv}{$main::Form{c}}{DownloadFilePath}" . "|" . "\n";		
			$main::Config{CEnv}{$main::Form{c}}{ExtentionChanged} = 1;	
			$main::Config{fbrowser}{userconfig}{extention} = $main::Form{extention};
			main::lib_fbrowser_saveuserconfig();	
			} else {
					if ($main::Config{fbrowser}{userconfig}{extention} =~ m!\w\w\w!)
					{
					 	if (length($main::Form{extention}) > 0)
						{
						$main::Config{fbrowser}{userconfig}{extention} = "";
						main::lib_fbrowser_saveuserconfig();	
						$main::Form{extention} = "";
						} else {
							$main::Form{extention} = $main::Config{fbrowser}{userconfig}{extention};
							};
					};
				};
			
			if (($main::Form{previewimages} eq "YES") || ($main::Form{previewimages} eq "NO") )
			{
			$main::Config{fbrowser}{userconfig}{previewimages} = $main::Form{previewimages};
			main::lib_fbrowser_saveuserconfig();
			};
			
			
			my($ExtentionMatch) = "exe|js|com|reg|dll|vbs|inf|ins|";
			my($DownloadExtention) = undef;
			$DownloadExtention = lib_files_extension($main::Config{CEnv}{$main::Form{c}}{DownloadFilePath});
			#$main::Config{$main::Form{c}}{ok} .= "<br>\$DownloadExtention = $DownloadExtention";
			#$main::Config{$main::Form{c}}{ok} .= "<br>\$main::Config{CEnv}{$main::Form{c}}{DownloadFilePath} = $main::Config{CEnv}{$main::Form{c}}{DownloadFilePath}";
			if ((defined $DownloadExtention) && ($ExtentionMatch =~ m!$DownloadExtention!i) && (-e $main::Config{CEnv}{$main::Form{c}}{DownloadFilePath}) )
			{
			$main::Config{CEnv}{$main::Form{c}}{DownloadFilePath} .= ".zip";	
			$main::Config{CEnv}{$main::Form{c}}{DownloadWebFilePath} .= ".zip";	
			$main::Config{$main::Form{c}}{ok} .= "<br><b>Note: Remove Extention .zip after download.</b>";	
			$main::Config{CEnv}{$main::Form{c}}{AddExtentionRevertLine} .= "$main::Config{CEnv}{$main::Form{c}}{DownloadFilePath}" . "|" . "\n";
			$main::Config{CEnv}{$main::Form{c}}{ExtentionChanged} = 1;
			};

			if ($main::Config{CEnv}{$main::Form{c}}{ExtentionChanged} == 1) 
			{
				unless ($main::Config{fbrowser}{config}{securecache} eq "YES")
				{
				main::AddFile($main::Config{bfrowser}{configrenamedfile},$main::Config{CEnv}{$main::Form{c}}{AddExtentionRevertLine});			
				};
			
			};
			
			if ($main::Form{dl} == 1)
			{
				if ($main::Config{fbrowser}{config}{securecache} eq "YES")
				{
					if (-e $main::Config{CEnv}{$main::Form{c}}{OriginalDownloadFile})
					{
						unless ((-e $main::Config{CEnv}{$main::Form{c}}{DownloadFilePath}) && ((((stat($main::Config{CEnv}{$main::Form{c}}{DownloadFilePath}))[7])) == (((stat($main::Config{CEnv}{$main::Form{c}}{OriginalDownloadFile}))[7]))))
						{
						main::CopyFile($main::Config{CEnv}{$main::Form{c}}{OriginalDownloadFile},$main::Config{CEnv}{$main::Form{c}}{DownloadFilePath},1);					
						};
					
		
					} else {
						print "<br>Does Not Exist: $main::Config{CEnv}{$main::Form{c}}{OriginalDownloadFile} ";
						};
					
				} else {
						if (-e $main::Config{CEnv}{$main::Form{c}}{OriginalDownloadFile})
						{
							unless ((-e $main::Config{CEnv}{$main::Form{c}}{DownloadFilePath}) && ((((stat($main::Config{CEnv}{$main::Form{c}}{DownloadFilePath}))[7])) == (((stat($main::Config{CEnv}{$main::Form{c}}{OriginalDownloadFile}))[7]))))
							{
							rename($main::Config{CEnv}{$main::Form{c}}{OriginalDownloadFile},$main::Config{CEnv}{$main::Form{c}}{DownloadFilePath});					
							};
						} else {
							print "<br>Does Not Exist: $main::Config{CEnv}{$main::Form{c}}{OriginalDownloadFile} ";
							};
					
					};
			};

			


	};
		    
	sub main::post_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute after Template generation:
	
my($String) = undef;
$main::Config{$main::Form{c}}{ok} .= "<input type=\"hidden\" name=\"rootpath\" value=\"$main::Form{rootpath}\" /><input type=\"hidden\" name=\"bfolder\" value=\"$main::Form{bfolder}\" />";
$main::Config{$main::Form{c}}{error} .= "";
$String .= main::act_fbrowsermain_form();

if (defined $main::Config{CEnv}{$main::Form{c}}{AllowUpload})
{
$String .= "<br>Upload file into this fodler:" . $main::Config{CEnv}{$main::Form{c}}{AllowUpload};
};
$String .= "<br>Add download extention: <input type=\"text\" name=\"extention\" value=\"$main::Form{extention}\" size=3 /> (Just add three letters. Example: \"tmp\". To disable, put space and submit.)<br><input type=\"submit\" value=\"Submit\" />";
	if ($main::Config{fbrowser}{userconfig}{previewimages} eq "YES")
	{
	$String .= "<br>Preview images: (Yes:<input type=\"RADIO\" name=\"previewimages\" value=\"YES\" CHECKED>No:<input type=\"RADIO\" name=\"previewimages\" value=\"NO\" >)";	
	} else {
		$String .= "<br>Preview images: (Yes:<input type=\"RADIO\" name=\"previewimages\" value=\"YES\">No:<input type=\"RADIO\" name=\"previewimages\" value=\"NO\"  CHECKED>)";	
		};

	
	if ((-e $main::Config{CEnv}{$main::Form{c}}{DownloadFilePath}) && ($main::Form{dl} == 1) )
	{
	$String .= main::lib_html_Redirect($main::Config{CEnv}{$main::Form{c}}{DownloadWebFilePath});
	};
	
$String = $main::Config{$main::Form{c}}{error} . $main::Config{$main::Form{c}}{ok} . $String;
$main::Html{ServiceText} =~ s!<insert-fbrowsermain-content>!$String!gis;
};


sub main::act_fbrowsermain_form

{
my($String) = undef;
my($key) = undef;
my($temp) = undef;
my($PopupString) = undef;
$PopupString .= "<script Language=\"JavaScript\"><!--\nfunction popup(url, name, width, height)\{\nsettings=\n";
$PopupString .= "\"toolbar=no,location=no,directories=no,\"+\n";
$PopupString .= "\"status=no,menubar=no,scrollbars=yes,\"+\n";
$PopupString .= "\"resizable=yes,width=\"+(screen.width-10)+\",height=\"+(screen.height-200)+\",top=50,left=0\";";
$PopupString .= "\nMyNewWindow=window.open(url,name,settings);";
$PopupString .= "\n";
$PopupString .= "\n}\n//-->\n</script>";
$PopupString .= "";
$PopupString .= "";
$PopupString .= "";
#"resizable=yes,width="+800+",height="+600;
$String = $PopupString . $String;	
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

my($Folder) = $main::Config{CEnv}{$main::Form{c}}{RootFolderPath} . "$main::Form{bfolder}";	
my($WebFolder) = $main::Config{CEnv}{$main::Form{c}}{RootFolderWebPath} . "$main::Form{bfolder}";	
# print "<br>\$Folder = $Folder";
my($fl) = undef;
my($size) = undef;
my($tmp) = undef;
my($sm) = undef;
my($fname) = undef;
my($tmpPath) = undef;
my($tmpWebPath) = undef;
my($tmpAltName) = undef;
my(@bgcolor) = ("#eee","#fff");
my($cnt) = undef;
my($fullname) = undef;
my($Extention) = undef;
my($ExtentionMatch) = "png|jpg|gif|bmp|tif|jpeg|tiff";
	if (-e $Folder)
	{
	my(@list) = main::ListFiles($Folder,0,"*.*");
		foreach $fname (@list)
		{
		
			if (($fname =~ m![\(\)\s\+]!g) && ($main::Config{fbrowser}{config}{enablenamecorrection} eq "YES") )
			{
			$temp = $fname;
			$temp =~ s![\(\)\s\+]!_!ig;
			$tmp = $Folder . "/" . $temp;
				unless (-e $tmp)
				{
					rename($fname,$tmp);
					if (-e $tmp)
					{
					$fname = $temp;	
					};
				};
			};
		$cnt++;
		$String .= "\n<tr style=\"background:".(@bgcolor[($cnt % 2)])."\">";
		$size  = (stat(($Folder."/".$fname)))[7]; 
		$String .= "<td style=\"width:80%\">";
		
			if ($size < ($main::Config{fbrowser}{config}{maxdownload} * 1000000))
			{
			$Extention = lib_files_extension($fname);
			
					if ($ExtentionMatch =~ m!$Extention!i)
					{
					$tmpPath = $Folder . "/". $fname;
					$tmpWebPath = $WebFolder . "/" . $fname;
					$tmpAltName = $fname;
						if ($main::Config{fbrowser}{userconfig}{previewimages} eq "YES")
						{
						$String .= main::lib_sdbview_imagethumbnail($tmpPath,$tmpWebPath,$tmpAltName) . " <a href=\"$main::UserEnv{href}&rootpath=$main::Form{rootpath}&c=fbrowsermain&bfolder=$main::Form{bfolder}&bfile=".$_."&dl=1&extention=$main::Form{extention}\"> $fname</a>";	
						} else {
							$String .= " <a href=\"$main::UserEnv{href}&rootpath=$main::Form{rootpath}&c=fbrowsermain&bfolder=$main::Form{bfolder}&bfile=".$_."&dl=1&extention=$main::Form{extention}\"> $fname</a>";
							};
					} else {
						$String .= "<a href=\"$main::UserEnv{href}&rootpath=$main::Form{rootpath}&c=fbrowsermain&bfolder=$main::Form{bfolder}&bfile=".$_."&dl=1&extention=$main::Form{extention}\">$fname</a>";	
						};
			
			} else {
				$String .= "$fname";
				};
		$String .= "</td>";
		$String .= "<td style=\"width:20%\">";
        	if (($size <= 1000 ) && ($size >= 0))  
                { 
                $sm = "bytes"; 
                } elsif (($size >= 999 ) && ($size <= 1000000 ))  
                { 
                $size = $size / 1000; $sm = "Kb" 
                } elsif ($size >= 1000000 )  
                { 
                $size = $size / 1000000; $sm = "Mb" 
                }; 
        	($size, $tmp) = ($size =~ /(\d+)\.(\d\d)/);   		
		$String .= "$size $sm";
		$String .= "</td>";
		$String .= "</tr>";
		};

	};
		
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


sub main::fbrowsermainGetFileSize
{ 
my($filename) = $_[0]; 
my($switcher) = $_[1]; 
my($filesize) = 0; 
my($sm) = ""; 
$filesize  = (stat($filename))[7];        # the eighth element returned by stat() 
if ($switcher == 0 ) {return $filesize}; 
if ($switcher == 1 ) {return $filesize / 1000 }; 
if ($switcher == 2 )  {return $filesize / 1000000 }; 
if ($switcher == 3 )  
        { 
        if (($filesize <= 1000 ) && ($filesize >= 0))  
                { 
                $sm = "bytes"; 
                return "$filesize"," $sm"; 
                } else { 
        if (($filesize >= 999 ) && ($filesize <= 1000000 ))  
                { 
                $filesize = $filesize / 1000; $sm = "Kb" 
                }; 
        if ($filesize >= 1000000 )  
                { 
                $filesize = $filesize / 1000000; $sm = "Mb" 
                }; 
        ($filesize, $tmp) = ($filesize =~ /(\d+)\.(\d\d)/);         
                }; 
        return "$filesize",".","$tmp"," $sm"; 
        }; 
}; 

sub main::lib_sdbview_imagethumbnail
{
use Image::Size;
my($ImagePath) = $_[0];
my($ImageWebPath) = $_[1];
my($ImageAltName) = $_[2];

my($Size_x) = undef;
my($Size_y) = undef;
my($ASize_x) = undef;
my($ASize_y) = undef;
my($Max_x) = 150;
my($Max_y) = 90;
my($Shrink_x) = undef;
my($Shrink_y) = undef;
my($ShrinkBy) = undef;
my($String) = undef;
	if (-e $ImagePath)
	{
			($ASize_x,$ASize_y) = imgsize("$ImagePath");
			$Size_x = $ASize_x; $Size_y = $ASize_y;
			$ShrinkBy = undef;
			$Shrink_x = undef;
			$Shrink_y = undef;

			unless ($main::Form{details} == 1)
			{
			if ($Size_x > $Max_x) {$Shrink_x = $Size_x / $Max_x};
			if ($Size_y > $Max_y) {$Shrink_y = $Size_y / $Max_y};
			if ($Shrink_x > $Shrink_y) {$ShrinkBy = $Shrink_x} else {$ShrinkBy = $Shrink_y};
			if ($ShrinkBy > 0) {$Size_x = $Size_x / $ShrinkBy; $Size_y = $Size_y / $ShrinkBy;};	
			};
$String = "<a href=\"#".""."\" onClick=\"window.open(\'".
($ImageWebPath). "\', \'loadwindow\', '\height=".($ASize_y + 20).",width=".($ASize_x + 20).",left=10,top=10,toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,directories=no,status=no\');\">".
"<img src=\"$ImageWebPath\" height=\"$Size_y\" width=\"$Size_x\" border=\"0\" target=\"_blank\"><font size=\"1\"></font></a>";
	
	};
# ($ASize_x x $ASize_y)	
return $String;	
};

1;
