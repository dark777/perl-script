# Action library for configroot


sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute before Template generation
my($CustomServerConfigFile) = $main::Config{DbFolder} . $main::Config{ServerAddress}. ".cgi";
my($key) = undef;
my(%CurrentConfig) = main::ReadIntConfig($CustomServerConfigFile);

	if (defined $main::Form{ScriptRoot}) 
	{
	unless ($main::Form{ScriptRoot} =~ m!/$!i){$main::Form{ScriptRoot} .= "/"};
	$CurrentConfig{ScriptRoot} = "$main::Form{ScriptRoot}";
	};

	if (defined $main::Form{ImagesRoot}) 
	{
	unless ($main::Form{ImagesRoot} =~ m!/$!i){$main::Form{ImagesRoot} .= "/"};
	$CurrentConfig{ImagesRoot} = "$main::Form{ImagesRoot}";
	};

	if (defined $main::Form{ScriptWebRoot}) 
	{
	unless ($main::Form{ScriptWebRoot} =~ m!/$!i){$main::Form{ScriptWebRoot} .= "/"};
	$CurrentConfig{ScriptWebRoot} = "$main::Form{ScriptWebRoot}";
	};

	if (defined $main::Form{ImagesWebRoot}) 
	{
	unless ($main::Form{ImagesWebRoot} =~ m!/$!i){$main::Form{ImagesWebRoot} .= "/"};
	$CurrentConfig{ImagesWebRoot} = "$main::Form{ImagesWebRoot}";
	};

	if (defined $main::Form{EditorWebRoot}) 
	{
	unless ($main::Form{EditorWebRoot} =~ m!/$!i){$main::Form{EditorWebRoot} .= "/"};
	$CurrentConfig{EditorWebRoot} = "$main::Form{EditorWebRoot}";
	};

	if (defined $main::Form{EditorImagesWebRoot}) 
	{
	unless ($main::Form{EditorImagesWebRoot} =~ m!/$!i){$main::Form{EditorImagesWebRoot} .= "/"};
	$CurrentConfig{EditorImagesWebRoot} = "$main::Form{EditorImagesWebRoot}";
	};

	if (defined $main::Form{EditorPopupsWebRoot}) 
	{
	unless ($main::Form{EditorPopupsWebRoot} =~ m!/$!i){$main::Form{EditorPopupsWebRoot} .= "/"};
	$CurrentConfig{EditorPopupsWebRoot} = "$main::Form{EditorPopupsWebRoot}";
	};


	if (defined $main::Form{'SmtpServer'}) 
	{
	$CurrentConfig{SmtpServer} = $main::Form{SmtpServer};
	};

	if (defined $main::Form{'adminemail'}) 
	{
	$CurrentConfig{adminemail} = $main::Form{adminemail};
	};

	if (defined $main::Form{'admindebug'}) 
	{
	$CurrentConfig{admindebug} = $main::Form{admindebug};
	};

	unless ($main::Config{DemoApp} == 1)
	{
	main::WriteIntConfig("config",\%CurrentConfig,$CustomServerConfigFile);	
	};

};

sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute After Template generation
my($CustomServerConfigFile) = $main::Config{DbFolder} . $main::Config{ServerAddress}. ".cgi";
my($FieldSize) = 60;
my($bg1) = "\#dec";
my($bg2) = "\#edc";

my($String) = qq(
		<table style="width:100%; font-family:verdana,arial; font-size:8pt; background:\#7ed">
		);
my($key) = undef;
my(%CurrentConfig) = main::ReadIntConfig($CustomServerConfigFile);
$String .= qq(

<tr style="width:100%; font-family:verdana,arial; font-size:8pt; background:$bg2">
<td><b>Folder name:</b></td>
<td><b>Modify data if recognized incorrectly:</b></td>
<td><b>Help notes:</b></td>
</tr>
	
	);
		$String .= qq(
<tr style="width:100%; font-family:verdana,arial; font-size:8pt; background:$bg1">
<td>Root Folder:</td>
<td><input type="text" name="ScriptRoot" value="$CurrentConfig{ScriptRoot}" size="$FieldSize"></td>
<td>Server path (e.g. /home/users/html/cgi-bin/app/) -  Please make sure that Root Folder has only "/" slashes (not "\\"), that it points to actual folder where the index.cgi is located on the server</td>
</tr>
<tr style="width:100%; font-family:verdana,arial; font-size:8pt; background:$bg2">
<td>Images Root Folder:</td>
<td><input type="text" name="ImagesRoot" value="$CurrentConfig{ImagesRoot}" size="$FieldSize"></td>
<td>Server path (e.g. /home/users/html/images/) - Please make sure that Root Folder has only "/" slashes (not "\\"), that it points to actual folder where the images are located on the server.</td>
</tr>
<tr style="width:100%; font-family:verdana,arial; font-size:8pt; background:$bg1">
<td>Web Root Folder:</td>
<td><input type="text" name="ScriptWebRoot" value="$CurrentConfig{ScriptWebRoot}" size="$FieldSize"></td>
<td>Web address path (e.g. http://www.domain.com/cgi-bin/app/) - Please make sure that Web root folder points correctly to the folder where index.cgi is located, this should be a web address as entered from the browser.</td>
</tr>
<tr style="width:100%; font-family:verdana,arial; font-size:8pt; background:$bg2">
<td>Images Web Root Folder:</td>
<td><input type="text" name="ImagesWebRoot" value="$CurrentConfig{ImagesWebRoot}" size="$FieldSize"></td>
<td>Web address path (e.g. http://www.domain.com/images/) - Please make sure that Web root folder points correctly to the folder where images are located, this should be a web address as entered from the browser.</td>
</tr>
<tr style="width:100%; font-family:verdana,arial; font-size:8pt; background:$bg1">
<td>Editor Web Root Folder:</td>
<td><input type="text" name="EditorWebRoot" value="$CurrentConfig{EditorWebRoot}" size="$FieldSize"></td>
<td>Web address path (e.g. http://www.domain.com/editor/) - Path to WYSIWYG editor installation on the server as entered from the browser.</td>
</tr>
<tr style="width:100%; font-family:verdana,arial; font-size:8pt; background:$bg2">
<td>Editor Images Web Root Folder:</td>
<td><input type="text" name="EditorImagesWebRoot" value="$CurrentConfig{EditorImagesWebRoot}" size="$FieldSize"></td>
<td>Web address path (e.g. http://www.domain.com/editor/images/) - Path to WYSIWYG editor images folder as entered from the browser.</td>
</tr>
<tr style="width:100%; font-family:verdana,arial; font-size:8pt; background:$bg1">
<td>Editor Popups Web Root Folder:</td>
<td><input type="text" name="EditorPopupsWebRoot" value="$CurrentConfig{EditorPopupsWebRoot}" size="$FieldSize"></td>
<td>Web address path (e.g. http://www.domain.com/editor/popups/)  - Path to WYSIWYG editor popups folder as entered from the browser.</td>
</tr>
<tr style="width:100%; font-family:verdana,arial; font-size:8pt; background:$bg1">
<td>SMTP Server</td>
<td><input type="text" name="SmtpServer" value="$CurrentConfig{SmtpServer}" size="$FieldSize"></td>
<td>Smtp Server to process e-mail messaging.</td>
</tr>
<tr style="width:100%; font-family:verdana,arial; font-size:8pt; background:$bg1">
<td>Support e-mail address</td>
<td><input type="text" name="adminemail" value="$CurrentConfig{adminemail}" size="$FieldSize"></td>
<td>Administrator e-mail address.</td>
</tr>

<tr style="width:100%; font-family:verdana,arial; font-size:8pt; background:$bg1">
<td>Enable Debug (YES/NO)</td>
<td><input type="text" name="admindebug" value="$CurrentConfig{admindebug}" size="$FieldSize"></td>
<td>Type YES to enable debug.</td>
</tr>

	);

$String .= "</table>";
$main::Html{ServiceText} =~ s![<_]insert-configroot-content[>_]!$String!is;
};
1;
