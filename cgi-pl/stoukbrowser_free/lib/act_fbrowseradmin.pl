# Action library for fbrowseradmin


	sub main::pre_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	$SubDebug = 1;
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute before Template generation:
	main::LoadLibrary("lib_fbrowser.pl");
	main::lib_fbrowser_readconfig();
	my($key) = undef;


		if (($main::Form{act} eq "deleteroot") && (defined $main::Config{fbrowser}{config}{roots}{$main::Form{key}}{name}))
		{
		($SubDebug == 1) ? DebugOut("Deleted \$main::Config{fbrowser}{config}{roots}{$main::Form{key}} = $main::Config{fbrowser}{config}{roots}{$main::Form{key}}{name}") : 0;
		undef $main::Config{fbrowser}{config}{roots}{$main::Form{key}};
		main::lib_fbrowser_saveconfig();
		};
		
		if ($main::Form{addrootname} =~ m!\w\w\w!)
		{
			if (-e $main::Form{addrootpath})
			{
			$key = "k" . time;
			$main::Form{addrootpath} =~ s!\\!/!gi;
			$main::Form{addrootpath} =~ s!/$!!i;
			$main::Form{addrootwebpath} =~ s!\\!/!gi;
			$main::Form{addrootwebpath} =~ s!/$!!i;
			 # ($main::Form{addrootpath} =~ m!/$!) {$main::Form{addrootpath} .= "/"};
			$main::Config{fbrowser}{config}{roots}{$key}{name} = $main::Form{addrootname};
			$main::Config{fbrowser}{config}{roots}{$key}{path} = $main::Form{addrootpath};
			$main::Config{fbrowser}{config}{roots}{$key}{webpath} = $main::Form{addrootwebpath};
			$main::Config{fbrowser}{config}{roots}{$key}{jspitemspath} = $main::Config{ImagesRoot} . "$key" . "_fbrowser". ".js";
			$main::Config{fbrowser}{config}{roots}{$key}{jspitemswebpath} = $main::Config{ImagesWebRoot} . "$key" . "_fbrowser".".js";
			$main::Config{fbrowser}{config}{roots}{$key}{jsnavtplpath} = $main::Config{ImagesRoot} . "$key" . "_fbrowsertpl". ".js";
			$main::Config{fbrowser}{config}{roots}{$key}{jsnavtplwebpath} = $main::Config{ImagesWebRoot} . "$key" . "_fbrowsertpl". ".js";
				unless ($main::Config{DemoApp} == 1)
				{
				main::act_fbrowseradmin_createrootmenu($main::Config{fbrowser}{config}{roots}{$key}{path},$main::Config{fbrowser}{config}{roots}{$key}{jspitemspath},$key);
				main::fbrowsernav_generatetreetemplate($main::Config{bfrowser}{jssourcetplpath},$main::Config{fbrowser}{config}{roots}{$key}{jsnavtplpath});
				};
			} else {
				$main::Config{$main::Form{c}}{error} .= "Root Path: $main::Form{addrootpath} does not exist...";
				};
		};

		if (($main::Form{recreateroot} =~ m!k\d+!) && (-e $main::Config{fbrowser}{config}{roots}{$main::Form{recreateroot}}{path}))
		{
			unless ($main::Config{DemoApp} == 1)
			{
			main::act_fbrowseradmin_createrootmenu($main::Config{fbrowser}{config}{roots}{$main::Form{recreateroot}}{path},$main::Config{fbrowser}{config}{roots}{$main::Form{recreateroot}}{jspitemspath},$main::Form{recreateroot});
			main::fbrowsernav_generatetreetemplate($main::Config{bfrowser}{jssourcetplpath},$main::Config{fbrowser}{config}{roots}{$main::Form{recreateroot}}{jsnavtplpath});
			};
		};
		
		if ($main::Form{maxdownload} =~ m!(\d+)!)
		{
		$main::Config{fbrowser}{config}{maxdownload} = $1;	
		};
		
		if (($main::Form{securecache} =~ m!YES!) || ($main::Form{securecache} =~ m!NO!) )
		{
		$main::Config{fbrowser}{config}{securecache} = $main::Form{securecache};	
		};
		
		if (($main::Form{enablefilenamecorrection} =~ m!YES!) || ($main::Form{enablefilenamecorrection} =~ m!NO!) )
		{
		$main::Config{fbrowser}{config}{enablefilenamecorrection} = $main::Form{enablefilenamecorrection};	
		};


		if ($main::Form{directwebpath} =~ m!http://[\w\d]+!)
		{
		$main::Config{fbrowser}{config}{directwebpath} = $main::Form{directwebpath};	
		};

		foreach $key (keys %main::Form)
		{
			if ($key =~ m!upload_(.*)!i)
			{
			my($temp) = $1;
				if (defined $main::Config{fbrowser}{config}{roots}{$temp}{name})
				{
				$main::Config{fbrowser}{config}{roots}{$temp}{upload} = $main::Form{$key};	
				};
			
			};
		
			if ($key =~ m!fix_(.*)!i)
			{
			my($temp) = $1;
				if (-e $main::Config{fbrowser}{config}{roots}{$temp}{path})
				{
				main::act_fbrowseradmin_fixnames($main::Config{fbrowser}{config}{roots}{$temp}{path});
				};				
			};
		
		};
	main::lib_fbrowser_saveconfig();
	};
		    
	sub main::post_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute after Template generation:
	
my($String) = undef;
$main::Config{$main::Form{c}}{ok} .= "";
$main::Config{$main::Form{c}}{error} .= "";
$String .= main::act_fbrowseradmin_form();
$String .= "<input type=\"submit\" value=\"Submit\" />";
$String = $main::Config{$main::Form{c}}{error} . $main::Config{$main::Form{c}}{ok} . $String;
$main::Html{ServiceText} =~ s!<insert-fbrowseradmin-content>!$String!gis;
};


sub main::act_fbrowseradmin_form

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
	<td><b>Configuration Options:</b></td>
	<td><b></b></td>	
	<td><b></b></td>
</tr>
);	
my($key) = undef;
my($recreate) = undef;

	foreach $key (sort keys %{$main::Config{fbrowser}{config}{roots}})
	{
		if ($main::Config{fbrowser}{config}{roots}{$key} =~ m!\w\w\w!)
		{
			if (-d $main::Config{fbrowser}{config}{roots}{$key}{path})
			{
			
				if ($main::Config{fbrowser}{config}{roots}{$key}{upload} eq "YES")
				{
				$temp = "Allow upload: Yes-<input type=\"RADIO\" name=\"upload_".$key."\" value=\"YES\" CHECKED> No-<input type=\"RADIO\" name=\"upload_".$key."\" value=\"NO\">";	
				} else {
					$temp = "Allow upload: Yes-<input type=\"RADIO\" name=\"upload_".$key."\" value=\"YES\" > No-<input type=\"RADIO\" name=\"upload_".$key."\" value=\"NO\" CHECKED>";		
					};
			$recreate = "<a href=\"$main::UserEnv{href}&c=fbrowseradmin&recreateroot=$key\">Refresh_Navigation</a>";
			$String .= "\n<tr><td><hr><b>$main::Config{fbrowser}{config}{roots}{$key}{name}</b><br>$main::Config{fbrowser}{config}{roots}{$key}{path}<br>$main::Config{fbrowser}{config}{roots}{$key}{webpath}</td><td><hr><a href=\"$main::UserEnv{href}&c=fbrowseradmin&act=deleteroot&key=$key\">Delete</a><br><br>$recreate</td><td><hr>$temp <br><input type=\"submit\"  name=\"fix_".$key."\" value=\"Fix Name\"/></td></tr>";
			
			} else {
				$String .= "\n<tr><td><hr><b>(is not accessible!)</b><br>$main::Config{fbrowser}{config}{roots}{$key}{name}<br>$main::Config{fbrowser}{config}{roots}{$key}{path}</td><td><a href=\"$main::UserEnv{href}&c=fbrowseradmin&act=deleteroot&key=$key\">delete from list</a></td><td></td></tr>";	
				};
		};
	};
$String .= qq(
<tr>
	<td></td>
	<td></td>
	<td></td>
</tr>
);

		
$String .= qq(
<tr>
	<td><hr>Add new Root: <br>Name: <input type="text" size="60" name="addrootname" value=""/><br> Path: <input type="text" size="60" name="addrootpath" value=""/><br> WebPath: <input type="text" size="60" name="addrootwebpath" value="http://"/></td>
	<td></td>
	<td></td>
</tr>

<tr>
	<td>Additional Options</td>
	<td></td>
	<td></td>
</tr>

<tr><td>Maximum Downloadable Size: (current is: $main::Config{fbrowser}{config}{maxdownload} Mb.)</td><td><select name="maxdownload"><option value="">Select to change</option><option value="10">10 Mb.</option><option value="25">25 Mb.</option><option value="50">50 Mb</option><option value="100">100 Mb</option><option value="150">150 Mb</option><option value="500">500 Mb.</option></select></td><td></td></tr>
<tr><td>Secure Downloads by copying files to temporary cache first? (Current setting is: $main::Config{fbrowser}{config}{securecache})</td><td><select name="securecache"><option value="">Select to change</option><option value="YES">YES</option><option value="NO">NO</option></select></td><td></td></tr>
<tr><td>Enable File names correction? (Current setting is: $main::Config{fbrowser}{config}{enablefilenamecorrection})</td><td><select name="enablefilenamecorrection"><option value="">Select to change</option><option value="YES">YES</option><option value="NO">NO</option></select></td><td></td></tr>
</table>

</center>
<p>
</DIV>
);
	
return $String;		
};


sub main::act_fbrowseradmin_fixnames
{
my($RootFolder) = $_[0];
my($orig) = undef;
my($fixed) = undef;

	if (-e $RootFolder)
	{
	my(@list) = main::ListAllFiles($RootFolder,"*.*");
		foreach $orig (@list)
		{
		$fixed = $orig;
			if ($fixed =~ s![\!\&\+\(\)\[\]\'\"]!_!gi)
			{
				unless (-e $fixed)
				{
					rename($orig,$fixed);
					unless (-e $fixed)
					{
					$main::Config{$main::Form{c}}{error} .=  "\n<br>Could Not Fix \"$orig\" to \"$fixed\"<br> because either this name already exists or permission denied.";
					} else {
						$main::Config{$main::Form{c}}{ok} .= "<br>OK - Fixed: $fixed";
						};
				};
			};		
		};
	};

	
};


sub main::act_fbrowseradmin_createrootmenu
{
use Data::Dumper;
my($RootFolder) = $_[0];
my($JsNavFile) = $_[1];
my($RootKey) = $_[2];
	if (-d $RootFolder)
	{
	my(%Tree) = undef;
	%Tree = %{(main::HashDir($RootFolder))};
	main::WriteTreeConfig("Root",\%Tree,"$JsNavFile","$RootKey");
	} else {
		print "\nRoot Folder Does nto Exist: $RootFolder";
		};	

};


##############################################################################
sub main::WriteTreeConfig
{
my($RootKey) = $_[3];
my($Reference) = $main::Config{ScriptWebPath} . "?rootpath=$RootKey&c=fbrowsermain&bfolder=";
use constant INDENT => "\t ";
    if (defined $_[2])
    {
        open (OUT, ">$_[2]") || warn "Util:: Cannot write to $_[2]: error $!\n";
         my ($name, $hash) = @_;
         my($preserve) = $name;
     print OUT  'var TREE_ITEMS = [',"\n";    
         print OUT  "[\'$name\',\'$Reference\',\n";
         main::WriteTreeDump($hash, 1);
         print OUT  "],\n";
            sub main::WriteTreeDump {
             my ($hash, $indent,$preserve) = @_;
             for (sort (keys %$hash)) {
               print OUT  INDENT x $indent;
               if ((ref $hash->{$_}) && ($hash->{$_} =~ m!^HASH!) ) {
                 print OUT  "[\'$_\',\'$Reference".main::urlEncode("$preserve"."$_")."\',\n";
                #  $IndexString1 .= $UID1++ . "|".main::urlEncode("$preserve"."$_")."\n";
                 print OUT main::WriteTreeDump($hash->{$_}, $indent + 1,($preserve. $_ . "/"));
                 print OUT INDENT x $indent , "],\n"
               }
               else { 
	                   if ($hash->{$_}) 
	                   {
				unless ($hash->{$_} =~ m!^ARRAY!)
				{
	                   	print OUT "[\'".(main::urlEncode($hash->{$_}))."\',\'$Reference".main::urlEncode("$preserve".$hash->{$_})."\'],\n";	
	                   	# $IndexString1 .= $UID1++ . "|"."$_\n";				
				};

	                   };
                   }
             }
            }
     print OUT  ']',"\n";  
        close OUT;
    };
};
##############################################################################

sub main::fbrowsernav_generatetreetemplate
{
my($TreeTemplateJsPath) = $_[0];
my($TreeTemplateNavigationPath) = $_[1];

	if (-e $TreeTemplateJsPath)
	{
	my(@temp) = main::ReadFile($TreeTemplateJsPath);
	my($ln) = undef;
	my($line) = undef;
		for ($ln = 0; $ln < (scalar @temp); $ln++)
		{
		$temp[$ln] =~ s!\'icons/!\'$main::Config{ImagesWebRoot}!i;
		};
	main::SaveFile($TreeTemplateNavigationPath,@temp);
	} else {
		print "CANNOT FIND: $TreeTemplateJsPath";
		};	
};

1;
