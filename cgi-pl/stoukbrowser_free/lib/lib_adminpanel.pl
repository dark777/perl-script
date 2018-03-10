#############################################################################################
sub main::lib_adminpanel
{
my($SubDebug) = $main::SubID{lib_html_adminpanel}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

unless (defined $main::Tts{AdminPanel}) { $main::Tts{AdminPanel} = $main::ConfigEnv{TtsFolder}. "adminpanel.cgi"};

my($DefaultAdminPanelString) = qq(
$main::Html{Fs2}
<a href="<LinkUserID>&a=viewfolder&viewfoldername=debug" target="_self">View Debug Folder</a><br>
<hr>
<a href="<LinkUserID>&a=viewfile&viewfilename=debug/debuglog.txt" target="_self">View Debug Log</a><br>
<hr>
<a href="<LinkUserID>&a=configedit&configeditfile=lib/errors.cgi">Edit Error Mappings</a><br>
<a href="<LinkUserID>&a=configedit&configeditfile=lib/html.cgi">Edit html Mappings</a><br>
<a href="<LinkUserID>&a=configedit&configeditfile=tts/styles.cgi">Edit Style Mappings</a><br>
<a href="<LinkUserID>&a=configedit&configeditfile=tts/tts.cgi">Edit Template Mappings</a><br>
<a href="<LinkUserID>&a=configedit&configeditfile=tts/acl.cgi">Edit Permission Mappings</a><br>
<hr>
<a href="<LinkUserID>&a=listhtmlconfig">Editor</a><br>
<hr>
<a href=\"<LinkUserID>\&a=plainconfigedit\&configeditfile=$main::Tts{AdminPanel}\">Edit AdminPanel Template</a>
$main::Html{FF}
);

unless (-e ($main::Config{ScriptRoot} . $main::Tts{AdminPanel})) {main::SaveFile(($main::Config{ScriptRoot} . $main::Tts{AdminPanel}),"$DefaultAdminPanelString");};
if (-e ($main::Config{ScriptRoot} . $main::Tts{AdminPanel})) 
{
my(@raw) = main::ReadFile(($main::Config{ScriptRoot} . $main::Tts{AdminPanel}));
$main::Html{ServiceData} .= join("",@raw);
	if ((defined $main::Tts{AdminPanelStyle}) && (defined $main::Tts{style}{$main::Tts{AdminPanelStyle}}))
	{
		if (-e ($main::Config{ScriptRoot} . $main::Tts{style}{$main::Tts{AdminPanelStyle}})) 
		{
		my(@raw) = main::ReadFile(($main::Config{ScriptRoot} . $main::Tts{style}{$main::Tts{AdminPanelStyle}}));
		$main::Html{HeadOptions} .= join("",@raw);
		};
	};

} else {$main::Html{ServiceData} = "<br> ERROR: Could Not create Default Administration Panel Template File: \"$main::Config{ScriptRoot}$main::Tts{AdminPanel}\""};
# print main::lib_html_getframeset();

};

1;
