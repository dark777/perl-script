#############################################################################################
sub main::lib_defaults_superframe
{
my($SubDebug) = $main::SubID{lib_defaults_superframe}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

my($String) =
qq(
<head>
<title>_superframe_page_title_</title>
<meta name="description" content="_superframe_page_description_">
<meta name="keywords" content="_superframe_page_keywords_">
<meta http-equiv="pragma" content="no-cache">
<meta name="generator" content="Stouk Rapid Web Development Application at www.stouk.com">
<meta name="author" content="_superframe_page_author_">
<meta name="copyright" content="Sergy Stouk">
<meta name="language" content="_superframe_page_language_">
<meta name="charset" content="_superframe_page_encoding_">
<meta name="MSSmartTagsPreventParsing" content="TRUE">
<meta name="distribution" content="Global">
<meta name="rating" content="General">
<meta name="expires" content="Now">
<meta name="robots" content="Index, Follow">
<meta name="revisit-after" content="7 Days">
</head>
<body>
_superframe_insert_data_
</body>    
);
return $String;
};
#############################################################################################

sub main::lib_defaults_desktopstyle
{
my(%Default) = undef;
$Default{BgColor} = "#ecf";	
$Default{TextFontColor} = "#000";
$Default{TextFontSize} = "8";
$Default{TextBgColor} = $Default{BgColor};
$Default{TextFontFace} = "verdana,sans-serif,arial";
$Default{TextFontWeight} = "";

$Default{LinkFontColor} = "#555";
$Default{LinkFontSize} = "8";
$Default{LinkFontFace} = "verdana,sans-serif,arial";
$Default{LinkBgColor} = $Default{BgColor};
$Default{LinkFontWeight} = "";

$Default{VLinkFontColor} = "#555";
$Default{VLinkFontSize} = "8";
$Default{VLinkFontFace} = "verdana,sans-serif,arial";
$Default{VLinkBgColor} = $Default{BgColor};
$Default{VLinkFontWeight} = "";


$Default{Width} = 1000;
$Default{TCellWidth}{1} = "333";
$Default{TCellWidth}{2} = "333";
$Default{TCellWidth}{3} = "333";
$Default{Height} = "100%";
$Default{TValign} = "top";
$Default{TBorder} = 1;
$Default{TCellPadding} = 0;
$Default{TCellSpacing} = 1;
$Default{TBgColor} = "#ecf";

return %Default;
};

1;