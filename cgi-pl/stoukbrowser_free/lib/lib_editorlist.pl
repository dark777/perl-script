# Function to list folder for editor edit selection.
#############################################################################################
sub main::lib_editorlist
{
my($SubDebug) = $main::SubID{lib_html_listhtmlconfig}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
$main::Html{ListHtmlConfig} = undef;
my($ListHtmlFolder) = $_[0];

my(%List) = undef;
my(@raw) = undef;
my(@FileList) = undef;

if ($main::Form{newhtmlfile})
{
$main::Html{NewHtmlFile} = $main::Config{ScriptRoot} . "$main::Form{newhtmlfile}";
my($Default) = main::CreateDefaultHtmlTemplate();
main::SaveFile($main::Html{NewHtmlFile},$Default);
	unless (-e $main::Html{NewHtmlFile}) 
	{
	($SubDebug == 1) ? DebugOut("FAILED: To create html template file: \"$main::Html{NewHtmlFile}\"") : 0;	
	main::AddError("e15","\"$main::Html{NewHtmlFile}\"");
	} else {
		($SubDebug == 1) ? DebugOut("OK: Created html template file: \"$main::Html{NewHtmlFile}\"") : 0;	
		};
};

if (-e $ListHtmlFolder)
{
@raw = main::ListFiles($ListHtmlFolder,1,"*.htm");
push @FileList,@raw;
@raw = main::ListFiles($ListHtmlFolder,1,"*.html");
push @FileList,@raw;
@raw = main::ListFiles($ListHtmlFolder,1,"*.htm");
push @FileList,@raw;
@raw = main::ListFiles($ListHtmlFolder,1,"*.htm");
push @FileList,@raw;
} else {
	main::AddError("e00016","\$ListHtmlFolder = $ListHtmlFolder");
	};
	

my($file) = undef;
my($temp) = undef;

    foreach $file (@FileList)
    {
    $file =~ s!\\!/!gi;
        if (-e $file) 
        {
            $List{$file}{fullname} = $file;
            if ($file =~ m!^$main::Config{ScriptRoot}(.*)!i)
            {
            $List{$file}{relativename} = $1;
            $List{$file}{webname} = $main::Config{ScriptWebRoot} . $1;
            };
        };
    };

$main::Html{ListHtmlConfig} .= 
qq(
New File Name: <br>
(example: tts/newtemplate.htm)
<br>
<form name="newhtmltemplate" action="$main::Config{ScriptWebPath}" method="POST">
<input type="text" value="" name="newhtmlfile" columns="40">
$main::UserEnv{userid}
<input type="hidden" name="a" value="listhtmlconfig">
<input type="submit" name="Submit" value="submit">
<br>
);

$main::Html{ListHtmlConfig} .= "<table border=\"1\">";

my($key) = undef;
    foreach $key (sort keys %List)
    {
        if (-e $key)
        {
        $temp = "<a href =\"$main::UserEnv{href}\&fl=$List{$key}{relativename}\&a=editor\">$List{$key}{relativename}";
        $main::Html{ListHtmlConfig} .= "<tr><td>$main::Html{Fs1} $temp </td><td>$main::Html{Fs1}  $main::Html{FF}</td><td>$main::Html{Fs1}  $main::Html{FF}</td><td>$main::Html{Fs1}  $main::Html{FF}</td></tr>";    
        };
    };

$main::Html{ListHtmlConfig} .= "</table>";
$main::Html{ServiceData} .= $main::Html{ListHtmlConfig};    
};
1;
