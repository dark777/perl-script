# online visual Editor Library
sub main::lib_editor
{
my($SubDebug) = $main::SubID{lib_html_editorform}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

unless (defined $main::Tts{EditorJSFile}) {$main::Tts{EditorJSFile} = $main::Config{RootFolder} . "editor/editor.js";};
unless (defined $main::Tts{EditorHeaderFile}) {$main::Tts{EditorHeaderFile} = $main::Config{LibFolder} . "editorhead.cgi";};
unless (defined $main::Tts{EditorBodyFile}) {$main::Tts{EditorBodyFile} = $main::Config{LibFolder} . "editorbody.cgi";};


my($HtmlEditor) = undef;
my($HtmlHeader) = undef;
my($EditFileName) = $main::Config{ScriptRoot} . "$main::Form{fl}";
my(@raw) = undef;
my($FileContent) = undef;
$EditFileName =~ s!//!/!gi;

if (-e ($EditFileName))
{
    if ($main::Form{econtent})
    {
    main::SaveFile($EditFileName,$main::Form{econtent});        
    };

@raw = main::ReadFile($EditFileName);
$main::Html{EditorContent} = join("",@raw);
main::DebugOut("\$FileContent = $FileContent");
} else {
    	($SubDebug == 1) ? DebugOut("FAILED: Content File does not exist: \"$EditFileName\"") : 0;
       };

	if (-e $main::Tts{EditorJSFile})
	{
	@raw = main::ReadFile($main::Tts{EditorJSFile});
	# $main::Html{HeadJavaScript} .= "<script>" . join("",@raw) . "</script>";
	} else {
		($SubDebug == 1) ? DebugOut("FAILED:Editor JavaScript File does not  exist: \"$main::Tts{EditorJSFile}\"") : 0;
		};

	if (-e $main::Tts{EditorHeaderFile})
	{
	@raw = main::ReadFile($main::Tts{EditorHeaderFile});	
	$main::Html{HeadJavaScript} .= join("",@raw);
	} else {
		($SubDebug == 1) ? DebugOut("FAILED: Editor Header file does not exist: \"$main::Tts{EditorHeaderFile}\"") : 0;
		};

	if (-e $main::Tts{EditorBodyFile})
	{
	@raw = main::ReadFile($main::Tts{EditorBodyFile});
	$main::Html{EditorBodyContent} = join("",@raw);
	} else {
		($SubDebug == 1) ? DebugOut("FAILED: Editor Body file does not exist: \"$main::Tts{EditorBodyFile}\"") : 0;
		};	
$main::Html{ServiceData} .= 
    qq(
	$main::UserEnv{adminlink}
	<br>
<form method="POST" action="$main::Config{ScriptWebPath}" enctype="application/x-www-form-urlencoded">
<input type="submit" value="submit"/>
$main::UserEnv{userid}
<input type="hidden" name="fl" value="$main::Form{fl}"/>
<input type="hidden" name="a" value="editor"/>
<div align=center>
<span class="headline">htmlArea v2.03</span><br>
<textarea name="econtent" style="width:100%; height:200"><EDITORCONTENT></textarea> $main::Html{EditorBodyContent} </form>
);
};
1;
