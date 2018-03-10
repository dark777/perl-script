# Generic HTML handling library
##############################################################################
sub main::lib_html_GetFormParameters {
my ( @pairs, %params);
my($value) = undef;
my($name) = undef;
my($pair) = undef;
my(@names) = undef;
use CGI qw(:standard);
$CGI::POST_MAX=1024 * 10000;  
$|=1;
my($cgi) = new CGI;
my($temp) = undef;
my(%Tmp) = undef;
my(@elements) = undef;
my($KeyCount) = undef;

    if ($ENV{'REQUEST_METHOD'} eq 'POST') 
    {
    @pairs = split(/&/, $ENV{'QUERY_STRING'});
    };

    @names = $cgi->param;
    foreach $name (@names) 
    {
     $KeyCount = undef;
     @elements = $cgi->param($name);
     	if ((scalar @elements) > 0) 
     	{
	$Tmp{$name}{0} = join(",",@elements);
		foreach (@elements)
		{
		$KeyCount++;
		$Tmp{$name}{$KeyCount} = $_;
		};
	};
	$value = $cgi->param($name);

	     unless ($ENV{'REQUEST_METHOD'} eq 'POST')
	     {
		    $name = &main::urlDecode($name);
		    $value = &main::urlDecode($value);
	     };
     $params{$name} = $value;
    }
%main::Form = %params;
$main::Form{MultipleFormValuesFromSingleFormField} = \%Tmp;

if (length ($main::Form{sn}) < 5)
{
my($rtx) = Digest::MD5->new;
my($data) = undef;
my($digest) = undef;
$data = time . $main::Config{ENV}{REMOTE_HOST};
$rtx->add($data);
$digest = $rtx->hexdigest;
$digest =~ m!([\d\w][\d\w][\d\w][\d\w][\d\w])!i;
$main::Form{sn} = $1;
};


return %params; 
}

#############################################################################################
sub main::lib_html_Redirect
{
my($String) = qq{ <SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
         <!-- 
         window.location.replace("};
$String .=  "$_[0]";

$String .= qq{")
         // -->
         </SCRIPT>
         };
return $String;
};


#############################################################################################
sub main::lib_html_mainscreen
{
my($SubDebug) = $main::SubID{lib_html_mainscreen}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
main::lib_customlib_displayplatters()
};
#############################################################################################
#############################################################################################
sub main::lib_html_getframeset
{
my($SubDebug) = $main::SubID{lib_html_getframeset}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

$main::Html{AdminPanelFrameSet} =
qq(
<frameset cols="190,*">
  
  <frame name="left" scrolling="no" noresize target="rtop" src="http://172.20.214.72/wwork/windex.cgi">
  
  <frameset rows="100%,*">
    <frame name="rtop" target="rbottom" src="http://www.scotia-capital.com">
  </frameset>
  <noframes>
  <body>

  <p>This page uses frames, but your browser doesn't support them.</p>

  </body>
  </noframes>
</frameset>
);
return     $main::Html{AdminPanelFrameSet};
};
#############################################################################################


#############################################################################################
sub main::lib_html_ProcessHtmlTemplate
{
my($SubDebug) = $main::SubID{ProcessHtmlTemplate}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

my($ProcessHtmltemplateFile) = $_[0];
    unless (-e $ProcessHtmltemplateFile)
    {
        unless (defined $main::Config{DefaultHtmlTemplate}){$main::Config{DefaultHtmlTemplate} = $main::Config{TtsFolder}. "default.htm";};
        $ProcessHtmltemplateFile = $main::Config{DefaultHtmlTemplate};
    };

    if (-e $ProcessHtmltemplateFile)
    {
    my(@raw) = main::ReadFile($ProcessHtmltemplateFile);    
    $main::Html{DefaultRaw} = join(//,"@raw");
    } else {
        $main::Html{DefaultRaw} = main::CreateDefaultHtmlTemplate();    
        };


$main::Html{DefaultRaw} =~ s!<PAGE_TITLE>!$main::ConfigEnv{ScriptMainTitle}!gis;
$main::Html{DefaultRaw} =~ s!<PAGE_DESCRIPTION>!$main::ConfigEnv{ScriptDescription}!gis;
$main::Html{DefaultRaw} =~ s!<PAGE_KEYWORDS>!$main::ConfigEnv{ScriptKeywords}!gis;
$main::Html{DefaultRaw} =~ s!<PAGE_AUTHOR>!$main::ConfigEnv{ScriptWebAuthor}!gis;
$main::Html{DefaultRaw} =~ s!<PAGE_LANGUAGE>!$main::ConfigEnv{ScriptLanguage}!gis;
$main::Html{DefaultRaw} =~ s!<PAGE_ENCODING>!$main::ConfigEnv{ScriptWebCharSet}!gis;
$main::Html{DefaultRaw} =~ s!<SERVICETEXT>!$main::Html{ServiceText}!gis;
$main::Html{DefaultRaw} =~ s!<SERVICEDATA>!$main::Html{ServiceData}!gis;
$main::Html{DefaultRaw} =~ s!<EDITORCONTENT>!$main::Html{EditorContent}!gis;
$main::Html{DefaultRaw} =~ s!<CUSTOMHTMLDATA>!$main::Html{CustomHtmlData}!gis;
$main::Html{DefaultRaw} =~ s!</head>!$main::Html{PageCSS}$main::Html{HeadOptions}$main::Html{HeadJavaScript}</head>!gis;
$main::Html{DefaultRaw} =~ s!<body>!<body$main::Html{BodyOptions}>$main::Html{BodyJavaScript}!gis;
$main::Html{DefaultRaw} =~ s!<ScriptWebRoot>!$main::Config{ScriptWebRoot}!gis;
$main::Html{DefaultRaw} =~ s!<ScriptWebPath>!$main::Config{ScriptWebPath}!gis;
$main::Html{DefaultRaw} =~ s!<ImagesWebRoot>!$main::Config{ImagesWebRoot}!gis;
$main::Html{DefaultRaw} =~ s!<LinkUserID>!$main::UserEnv{href}!gis;
$main::Html{DefaultRaw} =~ s!<LinkAdminPanel>!$main::UserEnv{adminlink}!gis;


($SubDebug == 1) ? DebugOut("OK - Processing HTML Template.") : 0;	
return $main::Html{DefaultRaw};
};
#############################################################################################
sub main::CreateDefaultHtmlTemplate
{
my($SubDebug) = $main::SubID{CreateDefaultHtmlTemplate}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

my($String) =
qq(
<head>
<title><PAGE_TITLE></title>
<meta name="description" content="<PAGE_DESCRIPTION>">
<meta name="keywords" content="<PAGE_KEYWORDS>">
<meta http-equiv="pragma" content="no-cache">
<meta name="generator" content="Stouk Rapid Web Development Application at www.stouk.com">
<meta name="author" content="<PAGE_AUTHOR>">
<meta name="copyright" content="Sergy Stouk">
<meta name="language" content="<PAGE_LANGUAGE>">
<meta name="charset" content="<PAGE_ENCODING>">
<meta name="MSSmartTagsPreventParsing" content="TRUE">
<meta name="distribution" content="Global">
<meta name="rating" content="General">
<meta name="expires" content="Now">
<meta name="robots" content="Index, Follow">
<meta name="revisit-after" content="7 Days">
</head>
<body>
<SERVICETEXT>
<SERVICEDATA>
</body>    
);
return $String;
};
#############################################################################################
sub main::PreProcessTemplate
{
# This Preprocessing is only for HFile inserted Forms.
my($SubDebug) = $main::SubID{PreProcessTemplate}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

my($Template) = $_[0];
$Template =~ s!<ScriptWebRoot>!$main::Config{ScriptWebRoot}!gis;
$Template =~ s!<ScriptWebPath>!$main::Config{ScriptWebPath}!gis;
$Template =~ s!<ImagesWebRoot>!$main::Config{ImagesWebRoot}!gis;
$Template =~ s!<LinkUserID>!$main::UserEnv{href}!gis;
$Template =~ s!<LinkAdminPanel>!$main::UserEnv{adminlink}!gis;
$Template =~ s!<Env-([\w_-]+)>!$main::Config{Env}{$1}!gis;
$Template =~ s!<Form-([\w\d]+)>!$main::Form{$1}!gis;

	while ($Template =~ m!<Date-(\d+)>!gis)
	{
	my($Dt) = main::lib_time_gettime($1);
	$Template =~ s!<Date-$1>!$Dt!is
	};

	if ($Template =~ m!<Environment>!is)
	{
	my($key) = undef;
	my($ts) = "\n<table>";
		foreach $key (sort keys %ENV)
		{
		$ts .= "\n<tr><td>$key </td><td> - </td><td> $ENV{$key}</td></tr>";
		};
	$ts .= "</table>\n";
	$Template =~ s!<Environment>!$ts!is
	};
	
$Template =~ s!<FormUserID>!$main::UserEnv{userid}!gis;
$Template =~ s!<UserName>!$main::UserEnv{name}!gis;
$Template =~ s!<UserGroup>!$main::UserEnv{group}!gis;
$Template =~ s!<EditorWebRoot>!$main::Config{EditorWebRoot}!gis;
$Template =~ s!<EditorImagesWebRoot>!$main::Config{EditorImagesWebRoot}!gis;
$Template =~ s!<EditorPopupsWebRoot>!$main::Config{EditorPopupsWebRoot}!gis;
$Template =~ s!<ConfigurationFile>!$main::Config{ConfigurationFile}!gis;
$Template =~ s!<CustomTemplateData>!$main::Html{CustomTemplateData}!gis;

return $Template;
};
#############################################################################################
sub main::ViewFile
{
my($SubDebug) = $main::SubID{ViewFile}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

my($File) = $main::Config{ScriptRoot} . $main::Form{viewfilename};	
if (-e $File) 	
{
my(@raw) = undef;
@raw = main::ReadFile($File);
my($String) =  join("",@raw);
$String =~ s!\n!<br>!gis;
$main::Html{ServiceText} .= "$main::Html{Fs1}". $String . "$main::Html{FF}";
} else {
	$main::Html{ServiceText} .= "$main::Html{Fs1}". "No Such Configuration File: \"$File\"" . "$main::Html{FF}";
	};
};
#############################################################################################
# List folder for files to view
sub main::WebListFolder
{
my($SubDebug) = $main::SubID{WebListFolder}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	
my($Folder) = $main::Config{ScriptRoot} . $main::Form{viewfoldername};	
$main::Html{ServiceText} .= "<br>Listing Folder: \"$Folder\"";
if (-e $Folder) 	
{
my(@raw) = undef;
@raw = main::ListFiles($Folder,1,"*.*");
my($File) = undef;
	foreach $File (@raw)
	{
		if (-e $File)
		{
		$File =~ s!$main::Config{ScriptRoot}!$main::Config{ScriptWebRoot}!gi;
		$main::Html{ServiceText} .= "$main::Html{Fs1}". "<br><a href=\"$File\" target=\"_blank\">"."$File"."</a>" . "$main::Html{FF}";					
		};
	};


} else {
	$main::Html{ServiceText} .= "$main::Html{Fs1}". "No Such Folder Name: \"$Folder\"" . "$main::Html{FF}";
	};
};
#############################################################################################


sub main::lib_html_template
{
my($TemplateKey) = $_[0];
my($SubDebug) = $main::SubID{lib_html_template}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	if ($TemplateKey)
	{
		if (defined $main::Action{$TemplateKey}{template}{name})
		{
		my($TemplateFile) = $main::Config{TtsSubFolders}{html} . "$main::Action{$TemplateKey}{template}{name}";
			if (-e $TemplateFile)
			{
			($SubDebug == 1) ? DebugOut("Processing Template file \"$TemplateFile\"") : 0;
			my($TemplateString) = join("",main::ReadFile($TemplateFile));
			$TemplateString = main::lib_prepro_ProcessTts($TemplateString);
			$main::Html{ServiceText} .= $TemplateString;
			return $TemplateString;
			} else {
				main::AddError("e00204","\$TemplateFile = $TemplateFile");	
				$main::Html{ServiceText} .= "ERROR 204!";			
				DebugOut("FAILED: \$TemplateFile = $TemplateFile")
				};
		
			
		} else {
			main::AddError("e00203","No Template File: \$main::Action{$TemplateKey}{template}{name} = \"$main::Action{$TemplateKey}{template}{name}\"");
			$main::Html{ServiceText} .= "ERROR 203!";
			DebugOut("FAILED: \$main::Action{$TemplateKey}{template}{name} = \"$main::Action{$TemplateKey}{template}{name}\"")
			};
	} else {
		main::AddError("e00202","No template Key. \$main::Action{$TemplateKey}{template}{name} = \"$main::Action{$TemplateKey}{template}{name}\"");
		$main::Html{ServiceText} .= "ERROR 202!";
		DebugOut("FAILED: No template Key. \$main::Action{$TemplateKey}{template}{name} = \"$main::Action{$TemplateKey}{template}{name}\"")
		};

return 	$TemplateString;
};

sub main::lib_html_Escape
{
my($Template) = $_[0];
$Template =~ s/&/&amp;/gis;
$Template =~ s/</&lt;/gis;
$Template =~ s/>/&gt;/gis;
$Template =~ s/"/&quot;/gis;
return $Template;	
};

sub main::lib_html_printpagebutton
{
my($Image) = $_[0];
my($String) = undef;
	if (defined $Image)
	{
	$String = "<a href=\"#\" onClick=\"window.print()\"><img src=\"$Image\" border=\"0\" alt=\"Print This Page\"></a>";	
	} else {
		$String = "<span style=\"cursor: hand;\" onClick=\"window.print()\">[Print]</span>";
		};
return $String;
};

1;
