# Startup Configuration Library
sub main::SetEnvironment
{
$main::ConfigEnv{crlf} = "\x0d\x0a";
$main::ConfigEnv{TtsFolder} = "tts/"; # Html Templates Folder
$main::ConfigEnv{UEnvFolder} = "uenv/"; # Users Environment Custom data Folder
$main::ConfigEnv{CacheFolder} = "cache/"; # Cache Folder
$main::ConfigEnv{LogFolder} = "log/"; # Log Folder
$main::ConfigEnv{DebugFolder} = "debug/"; # Debug Folder
$main::ConfigEnv{TempFolder} = "temp/"; # Temp Folder
$main::ConfigEnv{LibFolder} = "lib/"; # Library Folder
$main::ConfigEnv{HelpFolder} = "help/"; # Help Folder
$main::ConfigEnv{ScriptsFolder} = "scripts/"; # JavaScripts Folder
$main::ConfigEnv{DbFolder} = "db/"; # Database Folder
$main::ConfigEnv{StatFolder} = "stat/"; # Database Folder
$main::ConfigEnv{ImagesFolder} = "images/"; # Images Folder
$main::ConfigEnv{CssFolder} = "css/"; # Images Folder
$main::ConfigEnv{DbAccessFolder} = "access/";
$main::ConfigEnv{Month}{1} = "Jan";
$main::ConfigEnv{Month}{2} = "Feb";
$main::ConfigEnv{Month}{3} = "Mar";
$main::ConfigEnv{Month}{4} = "Apr";
$main::ConfigEnv{Month}{5} = "May";
$main::ConfigEnv{Month}{6} = "Jun";
$main::ConfigEnv{Month}{7} = "Jul";
$main::ConfigEnv{Month}{8} = "Aug";
$main::ConfigEnv{Month}{9} = "Sep";
$main::ConfigEnv{Month}{10} = "Oct";
$main::ConfigEnv{Month}{11} = "Nov";
$main::ConfigEnv{Month}{12} = "Dec";
$main::ConfigEnv{Weekday}{1} = "Sun";
$main::ConfigEnv{Weekday}{2} = "Mon";
$main::ConfigEnv{Weekday}{3} = "Tue";
$main::ConfigEnv{Weekday}{4} = "Wed";
$main::ConfigEnv{Weekday}{5} = "Thu";
$main::ConfigEnv{Weekday}{6} = "Fri";
$main::ConfigEnv{Weekday}{7} = "Sat";
$main::ConfigEnv{ScriptWebAuthor} = "Sergy Stouk";
$main::ConfigEnv{ScriptMainTitle} = "Web Application Template";
$main::ConfigEnv{ScriptWebCharSet} = "Windows-1251";
$main::ConfigEnv{ScriptLanguage} = "Russian";
$main::ConfigEnv{ScriptKeywords} = "Stouk,Rapid,Web,Development,Environment,Sergy,Application";
$main::ConfigEnv{ScriptDescription} = "Stouk Rapid Web Application at www.stouk.com";
$main::ConfigEnv{ScriptWebGenerator} = "Mozilla 4.11 (Sergy Stouk)";
$main::ConfigEnv{ScriptWebVersion} = $main::ScriptVersion;
$main::Html{Fs1} = "<font size=\"1\" face=\"verdana\">"; $main::Html{FS1} = $main::Html{Fs1};
$main::Html{Fs2} = "<font size=\"2\" face=\"verdana\">"; $main::Html{FS2} = $main::Html{Fs2};
$main::Html{Fs3} = "<font size=\"3\" face=\"verdana\">"; $main::Html{FS3} = $main::Html{Fs3};
$main::Html{Fs4} = "<font size=\"4\" face=\"verdana\">"; $main::Html{FS4} = $main::Html{Fs4};
$main::Html{FF} = "</font>"; $main::Html{Ff} = $main::Html{FF};
$main::Html{Escape} = {
               '<' => '&lt;',
               '>' => '&gt;',
               '"' => '&quot;',
               '&' => '&amp;'
            };
};

##############################################################################
sub lib_config_ConfigureEnvironment
{
my($ErrorText01) = "\n<br>ERROR: Check Permissions. You probably do not have rights to create this folder: ";
my($FirstLogin) = undef;
    
    $main::Config{ScriptRoot} = $main::CWD;
    main::SetEnvironment();
    
    unless (-e $main::Config{DbFolder}) {$main::Config{DbFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{DbFolder}"; unless (-e $main::Config{DbFolder}) {mkdir($main::Config{DbFolder},0777)}} else {$main::Config{DbFolder} = ForwardPath($main::Config{DbFolder},1)};
    unless (-e $main::Config{DbFolder}) {die "$ErrorText01 $main::Config{DbFolder}"};
    if ($ENV{SERVER_ADDR} =~ m!\.!i){$main::Config{ServerAddress} = $ENV{SERVER_ADDR};} elsif ($ENV{LOCAL_ADDR} =~ m!\.!i) {$main::Config{ServerAddress} = $ENV{LOCAL_ADDR};} else {$main::Config{ServerAddress} = "172.0.0.1";};
    my($CustomServerConfigFile) =  undef;

    $main::ServerAuth{File} = $main::Config{DbFolder} . "srv"."key".".cgi";
        if (-f $main::ServerAuth{File})
        {
        %main::ServerAuth = main::ReadIntConfig($main::ServerAuth{File});
        $CustomServerConfigFile = $main::Config{DbFolder} . $main::ServerAuth{SrvConf}. ".cgi";    
    } else {
        $main::ServerAuth{SrvConf} = $main::Config{ServerAddress};
        $main::ServerAuth{CreatedBy} = "Sergy Stouk. (www.stouk.com)";
        $main::ServerAuth{Version} = "Demo";
        $main::ServerAuth{RegisteredTo} = "Demo";
        main::WriteIntConfig("config",\%main::ServerAuth,$main::ServerAuth{File});
        $CustomServerConfigFile = $main::Config{DbFolder} . $main::ServerAuth{SrvConf} . ".cgi";
        };
 

    if (-e  $CustomServerConfigFile) 
    {
    %main::Config = main::ReadIntConfig($CustomServerConfigFile); 
    } else  {

        main::CreateDefaultCustomServerConfigFile($CustomServerConfigFile);
        %main::Config = main::ReadIntConfig($CustomServerConfigFile); 
    $main::Config{FirstLogin} = 1;
        };

        unless (-e $main::Config{DbFolder}) {$main::Config{DbFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{DbFolder}"; unless (-e $main::Config{DbFolder}) {mkdir($main::Config{DbFolder},0777)}} else {$main::Config{DbFolder} = ForwardPath($main::Config{DbFolder},1)};
            unless (-e $main::Config{DbFolder}) {die "$ErrorText01 $main::Config{DbFolder}"};
            if ($ENV{SERVER_ADDR} =~ m!\.!i){$main::Config{ServerAddress} = $ENV{SERVER_ADDR};} elsif ($ENV{LOCAL_ADDR} =~ m!\.!i) {$main::Config{ServerAddress} = $ENV{LOCAL_ADDR};} else {$main::Config{ServerAddress} = "172.0.0.1";};
            my($CustomServerConfigFile) = $main::Config{DbFolder} . $main::Config{ServerAddress}. ".cgi";

    $main::Config{ConfigurationFile} = "$main::ConfigEnv{DbFolder}".  $main::Config{ServerAddress}. ".cgi";
    if ($main::Config{admindebug} eq "YES") {$main::EnableDebug = 1;} else {$main::EnableDebug = 0;};
    # unless (-e $main::Config{CustomServerConfigFile}) {main::CreateDefaultCustomServerConfigFile($main::Config{CustomServerConfigFile})} else {%main::Config = main::ReadIntConfig($main::Config{CustomServerConfigFile}); }
    unless (-e $main::Config{DbFolder}) {$main::Config{DbFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{DbFolder}"; unless (-e $main::Config{DbFolder}) {mkdir($main::Config{DbFolder},0777)}} else {$main::Config{DbFolder} = ForwardPath($main::Config{DbFolder},1)};
    unless (-e $main::Config{DbFolder}) {die "$ErrorText01 $main::Config{DbFolder}"};
    $main::Config{Env} = \%ENV;
    # create required folders:

        
    unless (-e $main::Config{DbAccessFolder}) {$main::Config{DbAccessFolder} = $main::Config{DbFolder} . "$main::ConfigEnv{DbAccessFolder}"; unless (-e $main::Config{DbAccessFolder}) {mkdir($main::Config{DbAccessFolder},0777)}} else {$main::Config{DbAccessFolder} = ForwardPath($main::Config{DbAccessFolder},1)};
    unless (-e $main::Config{DbAccessFolder}) {die "$ErrorText01 $main::Config{DbAccessFolder}"};
    unless (-e $main::Config{TempFolder}) {$main::Config{TempFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{TempFolder}"; unless (-e $main::Config{TempFolder}) {mkdir($main::Config{TempFolder},0777)}} else {$main::Config{TempFolder} = ForwardPath($main::Config{TempFolder},1)};
    unless (-e $main::Config{TempFolder}) {die "$ErrorText01 $main::Config{TempFolder}"};
    unless (-e $main::Config{LogFolder}) {$main::Config{LogFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{LogFolder}"; unless (-e $main::Config{LogFolder}) {mkdir($main::Config{LogFolder},0777)}} else {$main::Config{LogFolder} = ForwardPath($main::Config{LogFolder},1)};
    unless (-e $main::Config{LogFolder}) {die "$ErrorText01 $main::Config{LogFolder}"};
    unless (-e $main::Config{TtsFolder}) {$main::Config{TtsFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{TtsFolder}"; unless (-e $main::Config{TtsFolder}) {mkdir($main::Config{TtsFolder},0777)}} else {$main::Config{TtsFolder} = ForwardPath($main::Config{TtsFolder},1)};
    unless (-e $main::Config{TtsFolder}) {die "$ErrorText01 $main::Config{TtsFolder}"};
    unless (-e $main::Config{UEnvFolder}) {$main::Config{UEnvFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{UEnvFolder}"; unless (-e $main::Config{UEnvFolder}) {mkdir($main::Config{UEnvFolder},0777)}} else {$main::Config{UEnvFolder} = ForwardPath($main::Config{UEnvFolder},1)};
    unless (-e $main::Config{UEnvFolder}) {die "$ErrorText01 $main::Config{UEnvFolder}"};
    unless (-e $main::Config{CacheFolder}) {$main::Config{CacheFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{CacheFolder}"; unless (-e $main::Config{CacheFolder}) {mkdir($main::Config{CacheFolder},0777)}} else {$main::Config{CacheFolder} = ForwardPath($main::Config{CacheFolder},1)};
    unless (-e $main::Config{CacheFolder}) {die "$ErrorText01 $main::Config{CacheFolder}"};
    unless (-e $main::Config{DebugFolder}) {$main::Config{DebugFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{DebugFolder}"; unless (-e $main::Config{DebugFolder}) {mkdir($main::Config{DebugFolder},0777)}} else {$main::Config{DebugFolder} = ForwardPath($main::Config{DebugFolder},1)};
    unless (-e $main::Config{DebugFolder}) {die "$ErrorText01 $main::Config{DebugFolder}"};
    unless (-e $main::Config{LibFolder}) {$main::Config{LibFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{LibFolder}"; unless (-e $main::Config{LibFolder}) {mkdir($main::Config{LibFolder},0777)}} else {$main::Config{LibFolder} = ForwardPath($main::Config{LibFolder},1)};
    unless (-e $main::Config{LibFolder}) {die "$ErrorText01 $main::Config{LibFolder}"};
    unless (-e $main::Config{HelpFolder}) {$main::Config{HelpFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{HelpFolder}"; unless (-e $main::Config{HelpFolder}) {mkdir($main::Config{HelpFolder},0777)}} else {$main::Config{HelpFolder} = ForwardPath($main::Config{HelpFolder},1)};
    unless (-e $main::Config{HelpFolder}) {die "$ErrorText01 $main::Config{HelpFolder}"};
    unless (-e $main::Config{ScriptsFolder}) {$main::Config{ScriptsFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{ScriptsFolder}"; unless (-e $main::Config{ScriptsFolder}) {mkdir($main::Config{ScriptsFolder},0777)}} else {$main::Config{ScriptsFolder} = ForwardPath($main::Config{ScriptsFolder},1)};
    unless (-e $main::Config{ScriptsFolder}) {die "$ErrorText01 $main::Config{ScriptsFolder}"};
    unless (-e $main::Config{StatFolder}) {$main::Config{StatFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{StatFolder}"; unless (-e $main::Config{StatFolder}) {mkdir($main::Config{StatFolder},0777)}} else {$main::Config{StatFolder} = ForwardPath($main::Config{StatFolder},1)};
    unless (-e $main::Config{StatFolder}) {die "$ErrorText01 $main::Config{StatFolder}"};
    unless (-e $main::Config{CssFolder}) {$main::Config{CssFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{CssFolder}"; unless (-e $main::Config{CssFolder}) {mkdir($main::Config{CssFolder},0777)}} else {$main::Config{CssFolder} = ForwardPath($main::Config{CssFolder},1)};
    unless (-e $main::Config{CssFolder}) {die "$ErrorText01 $main::Config{CssFolder}"};
    $main::Config{TtsSubFolders}{hfile} = $main::Config{TtsFolder} . "hfile/"; unless (-e $main::Config{TtsSubFolders}{hfile}) {mkdir($main::Config{TtsSubFolders}{hfile},0777)};
    $main::Config{TtsSubFolders}{js} = $main::Config{TtsFolder} . "js/"; unless (-e $main::Config{TtsSubFolders}{js}) {mkdir($main::Config{TtsSubFolders}{js},0777)};
    $main::Config{TtsSubFolders}{html} = $main::Config{TtsFolder} . "html/"; unless (-e $main::Config{TtsSubFolders}{html}) {mkdir($main::Config{TtsSubFolders}{html},0777)};
    $main::Config{TtsSubFolders}{css} = $main::Config{TtsFolder} . "css/"; unless (-e $main::Config{TtsSubFolders}{css}) {mkdir($main::Config{TtsSubFolders}{css},0777)};
    $main::Config{TtsSubFolders}{help} = $main::Config{TtsFolder} . "help/"; unless (-e $main::Config{TtsSubFolders}{help}) {mkdir($main::Config{TtsSubFolders}{help},0777)};
    
    if ($ENV{SERVER_NAME}){$main::Config{ServerName} = ($ENV{SERVER_NAME} . ":" . $ENV{SERVER_PORT});} elsif ($ENV{HTTP_HOST}) {$main::Config{ServerName} = $ENV{HTTP_HOST};} else {$main::Config{ServerName} = "localhost";};    
    if ($ENV{SCRIPT_NAME} =~ m!/index\.cgi!i){$main::Config{ScriptName} = $ENV{SCRIPT_NAME};} elsif ($ENV{PATH_INFO} =~ m!/index\.cgi!i) {$main::Config{ScriptName} = $ENV{PATH_INFO};} else {$main::Config{ScriptName} = "/";};    
    unless (defined $main::Config{ScriptWebRoot}) {$main::Config{ScriptWebRoot} = "http://".$main::Config{ServerName}.$main::Config{ScriptName};} else {unless ($main::Config{ScriptWebRoot} =~ m!/$!) {$main::Config{ScriptWebRoot} = $main::Config{ScriptWebRoot} . "/"}};
    $main::Config{ScriptWebRoot} =~ s!index\.cgi$!!i;
    unless (defined $main::Config{ScriptWebPath}) {$main::Config{ScriptWebPath} = $main::Config{ScriptWebRoot} . "index.cgi"};
    unless (defined $main::Config{ImagesWebRoot}) {$main::Config{ImagesWebRoot} = $main::Config{ScriptWebRoot} . $main::ConfigEnv{ImagesFolder}} else {unless ($main::Config{ImagesWebRoot} =~ m!/$!i) {$main::Config{ImagesWebRoot} = $main::Config{ImagesWebRoot} . "/"}};
    unless (defined $main::Config{ImagesRoot}) {$main::Config{ImagesRoot} = $main::Config{ScriptRoot} . $main::ConfigEnv{ImagesFolder}} else {unless ($main::Config{ImagesRoot} =~ m!/$!i) {$main::Config{ImagesRoot} = $main::Config{ImagesRoot} . "/"}};
    unless (defined $main::Config{ImagesFolder}) {$main::Config{ImagesFolder} = $main::Config{ScriptRoot} . $main::ConfigEnv{ImagesFolder}} else {unless ($main::Config{ImagesFolder} =~ m!/$!i) {$main::Config{ImagesFolder} = $main::Config{ImagesFolder} . "/"}};
    unless (-e $main::Config{ImagesFolder}) 
    {
    mkdir($main::Config{ImagesFolder},0777);
    } else {
            $main::Config{ImagesFolder} = ForwardPath($main::Config{ImagesFolder},1);
            };
    
    unless (-e $main::Config{ImagesFolder}) {die "$ErrorText01 $main::Config{ImagesFolder}"};
    main::lib_config_AssignDefaultValues();
    
    # read configuration files:
    if (-e $main::Config{SubIDFile}) {%main::SubID = main::ReadIntConfig($main::Config{SubIDFile})};
    if (-e $main::Config{ErrorFile}) {my(%temp) = main::ReadIntConfig($main::Config{ErrorFile}); $main::Error{Config} = \%temp;};
    if (-e $main::Config{HtmlFile}) {my(%temp) = main::ReadIntConfig($main::Config{HtmlFile}); $main::Html{Config} = \%temp;};
    if (-e $main::Config{TtsFile}) {%main::Tts = main::ReadIntConfig($main::Config{TtsFile});};
    if (-e $main::Config{StyleFile}) {%main::Style = main::ReadIntConfig($main::Config{StyleFile});};
    if (-e $main::Config{ActionFile}) {%main::Action = main::ReadIntConfig($main::Config{ActionFile});};

   if (-e $main::Config{HConfigFile}) {%main::HConfig = main::ReadIntConfig($main::Config{HConfigFile});};
   if (-e $main::Config{JSConfigFile}) {%main::JSConfig = main::ReadIntConfig($main::Config{JSConfigFile});};
   if (-e $main::Config{HTMLConfigFile}) {%main::HTMLConfig = main::ReadIntConfig($main::Config{HTMLConfigFile});};
   if (-e $main::Config{CSSConfigFile}) {%main::CSSConfig = main::ReadIntConfig($main::Config{CSSConfigFile});};
   if (-e $main::Config{HTextConfigFile}) {%main::HTextConfig = main::ReadIntConfig($main::Config{HTextConfigFile});};
   if (-e $main::Config{ActConfigFile}) {%main::ActConfig = main::ReadIntConfig($main::Config{ActConfigFile});};
   if (-e $main::Config{ListConfigFile}) {%main::ListConfig = main::ReadIntConfig($main::Config{ListConfigFile});};
   if (-e $main::Config{HelpConfigFile}) {%main::HelpConfig = main::ReadIntConfig($main::Config{HelpConfigFile});};
    main::lib_config_defaultstyle(); 
    $main::Config{DemoApp} = 0;
};
##############################################################################


sub main::DynamicConfig
{
$main::DConfig{script}{root} = $main::Config{ScriptRoot};    
$main::DConfig{script}{webroot} = $main::Config{ScriptWebRoot};
$main::DConfig{script}{path} = $main::Config{ScriptName};
$main::DConfig{script}{webpath} = $main::Config{ScriptWebPath};
$main::DConfig{script}{imagesroot} = $main::Config{ImagesRoot};
$main::DConfig{script}{imageswebroot} = $main::Config{ImagesWebRoot};
$main::DConfig{script}{editorimageswebroot} = $main::Config{EditorImagesWebRoot};
$main::DConfig{script}{editorpopupswebroot} = $main::Config{EditorPopupsWebRoot};
$main::DConfig{script}{editorwebroot} = $main::Config{EditorWebRoot};
$main::DConfig{script}{adminlink} = $main::UserEnv{adminlink};
$main::DConfig{script}{adminemail} = $main::Config{adminemail};

$main::DConfig{server}{address} = $main::Config{ServerAddress};
$main::DConfig{server}{name} = $main::Config{ServerName};


$main::DConfig{user}{name} = "$main::UserEnv{name}";
$main::DConfig{user}{ip} = "$ENV{REMOTE_ADDR}";
$main::DConfig{user}{group} = "$main::UserEnv{group}";
$main::DConfig{user}{formid} = "$main::UserEnv{userid}";
$main::DConfig{user}{linkid} = "$main::UserEnv{href}";
$main::DConfig{user}{tokenid} = "$main::UserEnv{authentication}";


};

sub main::CreateDefaultCustomServerConfigFile
{
my(%Custom) = undef;
my($ConfigFile) = $_[0];
if ($ConfigFile)
{
$Custom{ScriptRoot} = $main::Config{ScriptRoot};
$Custom{TempFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{TempFolder}";    
$Custom{LogFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{LogFolder}";    
$Custom{UEnvFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{UEnvFolder}";    
$Custom{CacheFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{CacheFolder}";    
$Custom{DebugFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{DebugFolder}";    
$Custom{LibFolder} = $main::Config{ScriptRoot} . "$main::ConfigEnv{LibFolder}";    

if ($ENV{SERVER_NAME}){$Custom{ServerName} = $ENV{SERVER_NAME} . ":" . $ENV{SERVER_PORT};} elsif ($ENV{HTTP_HOST}) {$Custom{ServerName} = $ENV{HTTP_HOST};} else {$Custom{ServerName} = "localhost";};    
if ($ENV{SCRIPT_NAME} =~ m!/index\.cgi!i){$Custom{ScriptName} = $ENV{SCRIPT_NAME};} elsif ($ENV{PATH_INFO} =~ m!/index\.cgi!i) {$Custom{ScriptName} = $ENV{PATH_INFO};} else {$Custom{ScriptName} = "/";};    
unless ($Custom{ScriptWebRoot} =~ m!^http://!is) {$Custom{ScriptWebRoot} = "http://".$Custom{ServerName}.$Custom{ScriptName};} else {unless ($Custom{ScriptWebRoot} =~ m!/$!) {$Custom{ScriptWebRoot} = $Custom{ScriptWebRoot} . "/"}};
$Custom{ScriptWebRoot} =~ s!index\.cgi$!!i;
$Custom{ImagesWebRoot} = $main::Config{ScriptWebRoot} . $main::ConfigEnv{ImagesFolder};
$Custom{ImagesRoot} = $main::Config{ScriptRoot} . "$main::ConfigEnv{ImagesFolder}";    
$Custom{EditorWebRoot} = $Custom{ScriptWebRoot} . "editor/";
$Custom{EditorImagesWebRoot} = $Custom{ImagesWebRoot} . "editor/";
$Custom{EditorPopupsWebRoot} = $Custom{EditorWebRoot} . "popups/";
main::WriteIntConfig("config",\%Custom,$ConfigFile);
unless (-e $ConfigFile) {die "ERROR: Could Not create Default Configuration file! Permission Denied! \"$ConfigFile\""};
    
} else {
    die "ERROR: Could Not create Default Configuration file! No File Name Passed! \"$ConfigFile\"";    
    };
};

sub main::lib_config_ConfigureUserEnvironment
{
my($SubDebug) = $main::SubID{lib_config_ConfigureUserEnvironment}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Initialized Sub") : 0;
my($ErrorText01) = "\n<br>ERROR: Check Permissions. You probably do not have rights to create this folder: ";
    
    if ($main::User{name})    
    {
    ($SubDebug == 1) ? DebugOut("OK  - User exists \"$main::User{name}\"") : 0;
        if ($main::User{digest})
        {
        ($SubDebug == 1) ? DebugOut("OK  - User digest \"$main::User{digest}\"") : 0;
        $main::UserEnv{digest} = $main::User{digest};
        $main::UserEnv{name} = $main::User{name};
        $main::UserEnv{group} = $main::User{group};
        $main::UserEnv{pass} = $main::User{pass};    
        $main::UserEnv{authentication} = $main::Config{AuthenticationString};
        if ((length($main::Form{sn}) < 10) && (length($main::Form{sn}) > 1) ) {$main::UserEnv{sn} = $main::Form{sn}};
        $main::Config{ScriptWebPathRef} = $main::Config{ScriptWebPath} . "?" . "u=" . "$main::UserEnv{authentication}"."&sn="."$main::UserEnv{sn}";
        $main::UserEnv{userid} = "<input type=\"hidden\" name=\"u\" value=\"$main::UserEnv{authentication}\"/><input type=\"hidden\" name=\"sn\" value=\"$main::UserEnv{sn}\"/>";
        $main::UserEnv{href} = $main::Config{ScriptWebPath} . "?" . "u=" . "$main::UserEnv{authentication}"."&sn="."$main::UserEnv{sn}";
        $main::UserEnv{adminlink} = "<a href=\"" . $main::Config{ScriptWebPath} . "?" . "u=" . "$main::UserEnv{authentication}"."\&a=" . "adminpanel"."\">"."Administration Panel" . "</a>";
        $main::UserEnv{UserRoot} = $main::Config{UEnvFolder} . $main::UserEnv{digest} . "/";
        unless (-e  $main::UserEnv{UserRoot}) {mkdir( $main::UserEnv{UserRoot},0777)};
        $main::UserEnv{TempFolder} = $main::Config{UEnvFolder} . $main::UserEnv{digest} . "/temp/"; unless (-e $main::UserEnv{TempFolder}) {mkdir($main::UserEnv{TempFolder},0777)};
        unless (-e $main::UserEnv{TempFolder}) {die "$ErrorText01 $main::UserEnv{TempFolder}"};
        $main::UserEnv{CacheFolder} = $main::Config{UEnvFolder}  . $main::UserEnv{digest} . "/cache/"; unless (-e $main::UserEnv{CacheFolder}) {mkdir($main::UserEnv{CacheFolder},0777)};
        unless (-e $main::UserEnv{CacheFolder}) {die "$ErrorText01 $main::UserEnv{CacheFolder}"};
        $main::UserEnv{DbFolder} = $main::Config{UEnvFolder}  . $main::UserEnv{digest} . "/db/"; unless (-e $main::UserEnv{DbFolder}) {mkdir($main::UserEnv{DbFolder},0777)};
        unless (-e $main::UserEnv{DbFolder}) {die "$ErrorText01 $main::UserEnv{DbFolder}"};
        $main::UserEnv{TtsFolder} = $main::Config{UEnvFolder}  . $main::UserEnv{digest} . "/tts/"; unless (-e $main::UserEnv{TtsFolder}) {mkdir($main::UserEnv{TtsFolder},0777)};
        unless (-e $main::UserEnv{TtsFolder}) {die "$ErrorText01 $main::UserEnv{TtsFolder}"};
        $main::UserEnv{UEnvFolder} = $main::Config{UEnvFolder} . $main::UserEnv{digest}. "/userdata/"; unless (-e $main::UserEnv{UEnvFolder}) {mkdir($main::UserEnv{UEnvFolder},0777)};
        unless (-e $main::UserEnv{UEnvFolder}) {die "$ErrorText01 $main::UserEnv{UEnvFolder}"};
        ($SubDebug == 1) ? main::DumpDebug(\%main::UserEnv,($main::User{digest} . ".txt")) : 0;
        $main::UserEnv{UserDigestFile} = $main::Config{UEnvFolder} . "$main::User{digest}" . ".cgi";
        
        @main::UserGroupList = split(",",$main::UserEnv{group});
    return 1;
        } else {
            ($SubDebug == 1) ? DebugOut("FAILED  - User digest \"$main::User{digest}\"") : 0;    
            main::AddError("e12");                
            };
    } else {
        ($SubDebug == 1) ? DebugOut("FAILED  - No user: \"$main::User{name}\"") : 0;
        main::AddError("e11");        
        };
};


sub main::lib_config_AssignDefaultValues
{
my(@raw) = undef;
unless (defined $main::Config{LogRetentionDays}) {$main::Config{LogRetentionDays} = 7};
unless (defined $main::Config{MaxLogSize}) {$main::Config{MaxLogSize} = 100000};

#unless (defined $main::Config{SubIDFile}) {$main::Config{SubIDFile} = $main::Config{TtsFolder} . "subids.cgi";};
unless (defined $main::Config{ErrorFile}) {$main::Config{ErrorFile} = $main::Config{TtsFolder} . "errors_c.cgi";};
unless (defined $main::Config{ActionFile}) {$main::Config{ActionFile} = $main::Config{LibFolder} . "actions.cgi";};
unless (defined $main::Config{TtsFile}) {$main::Config{TtsFile} = $main::Config{TtsFolder} . "tts.cgi";};
unless (defined $main::Config{HConfigFile}) {$main::Config{HConfigFile} = $main::Config{TtsFolder} . "hfile_c.cgi";};
unless (defined $main::Config{JSConfigFile}) {$main::Config{JSConfigFile} = $main::Config{TtsFolder} . "js_c.cgi";};
unless (defined $main::Config{HTMLConfigFile}) {$main::Config{HTMLConfigFile} = $main::Config{TtsFolder} . "html_c.cgi";};
unless (defined $main::Config{CSSConfigFile}) {$main::Config{CSSConfigFile} = $main::Config{TtsFolder} . "css_c.cgi";};
unless (defined $main::Config{HTextConfigFile}) {$main::Config{HTextConfigFile} = $main::Config{TtsFolder} . "htext_c.cgi";};
unless (defined $main::Config{ActConfigFile}) {$main::Config{ActConfigFile} = $main::Config{TtsFolder} . "act_c.cgi";};
unless (defined $main::Config{ListConfigFile}) {$main::Config{ListConfigFile} = $main::Config{TtsFolder} . "list_c.cgi";};
unless (defined $main::Config{HelpConfigFile}) {$main::Config{HelpConfigFile} = $main::Config{TtsFolder} . "help_c.cgi";};
unless (defined $main::Config{GroupConfigFile}) {$main::Config{GroupConfigFile} = $main::Config{DbFolder} . "groups.cgi";};

unless (-e $main::Config{HelpConfigFile}) {main::WriteIntConfig("config","<config>\n</config>","$main::Config{HelpConfigFile}")};
unless (-e $main::Config{ListConfigFile}) {main::WriteIntConfig("config","<config>\n</config>","$main::Config{ListConfigFile}")};
unless (-e $main::Config{HConfigFile}) {main::WriteIntConfig("config","<config>\n</config>","$main::Config{HConfigFile}")};
unless (-e $main::Config{JSConfigFile}) {main::WriteIntConfig("config","<config>\n</config>","$main::Config{JSConfigFile}")};
unless (-e $main::Config{HTMLConfigFile}) {main::WriteIntConfig("config","<config>\n</config>","$main::Config{HTMLConfigFile}")};
unless (-e $main::Config{CSSConfigFile}) {main::WriteIntConfig("config","<config>\n</config>","$main::Config{CSSConfigFile}")};
unless (-e $main::Config{HTextConfigFile}) {main::WriteIntConfig("config","<config>\n</config>","$main::Config{HTextConfigFile}")};
unless (-e $main::Config{ActConfigFile}) {main::WriteIntConfig("config","<config>\n</config>","$main::Config{ActConfigFile}")};
unless (-e $main::Config{ErrorFile}) {main::WriteIntConfig("config","<config>\n</config>","$main::Config{ErrorFile}")};



unless (-e  $main::Config{ActionFile}) {main::WriteIntConfig("config","<config>\n</config>","$main::Config{ActionFile}")};

unless (defined $main::Config{StyleFile}) {$main::Config{StyleFile} = $main::Config{TtsFolder} . "styles.cgi";};
unless (defined $main::Config{HtmlFile}) {$main::Config{HtmlFile} = $main::Config{LibFolder} . "html.cgi";};
unless (defined $main::Config{DebugFile}){$main::Config{DebugFile} = $main::Config{DebugFolder}. "debuglog.txt";};
unless (defined $main::Config{ConfigDescriptionFile}){$main::Config{ConfigDescriptionFile} = $main::Config{HelpFolder}. "confdesc.txt";};
unless ($main::Config{SubIDFile}  =~ m!\w!) {main::WriteIntConfig("config",\%main::SubID,"$main::Config{SubIDFile}")};
unless ($main::Config{ErrorFile}  =~ m!\w!) {main::WriteIntConfig("config",\%main::Error,"$main::Config{ErrorFile}")};
unless ($main::Config{HtmlFile}  =~ m!\w!) {main::WriteIntConfig("config","","$main::Config{HtmlFile}")};
    unless (-e $main::Config{GroupConfigFile}) 
    {
    $main::Config{Groups}{administrators}{active} = 1;    
    $main::Config{Groups}{guests}{active} = 1;
    $main::Config{Groups}{users}{active} = 1;
    #main::WriteIntConfig("config",$main::Config{Groups},"$main::Config{GroupConfigFile}");
    } else {
        my(%temp) = undef;
        %temp = main::ReadIntConfig($main::Config{GroupConfigFile});
        $main::Config{Groups} = \%temp;
        };
if (-e $main::Config{DebugFile}) {unlink($main::Config{DebugFile})};
unless (defined $main::Config{SmtpServer}) {$main::Config{SmtpServer} = "mail.stouk.com"};
unless (defined $main::Config{DefaultPassword}) {$main::Config{DefaultPassword} = "12345"};
unless (defined $main::Config{SessionTime}) {$main::Config{SessionTime} = 3600};
$main::Config{GlobalIterationLimit} = 1000;
$main::Config{AllowGuestAccess} = 1;
$main::Config{GuestAccessCounterFile} = $main::Config{DbFolder} . "guestcount.cgi";
$main::Config{GuestAccountLife} = 3600;
$main::Config{GuestAccountLimit} = 50;

};

##############################################################################
sub main::ForwardPath
{
my($Path) = $_[0];
my($FolderCheckFlag) = $_[1];
$Path =~ s!\\!/!g;    
    if ($FolderCheckFlag == 1)
    {
        unless ($Path =~ m!/$!)
        {
        $Path = $Path . "/";
        };
    };
return $Path;
};
##############################################################################
sub main::CleanSpaces
{
my($var) = $_[0];
    $var =~ s/^\s+//;    
    $var =~ s/\s+$//;
    $var =~ s/\n//g;
return $var;
};
##############################################################################
sub main::lib_html_Escape
{
my($Template) = $_[0];
$Template =~ s/&/&amp;/gis;
$Template =~ s/</&lt;/gis;
$Template =~ s/>/&gt;/gis;
# $Template =~ s/"/&quot;/gis;
return $Template;    
};


##############################################################################
sub main::DecodeHash
{
my($HashRef) = $_[0];
my(%Temp) = undef;
my($key) = undef;
my($tmp) = undef;

    if ((ref $HashRef) && ($HashRef =~ m!^HASH!i) )
    {
    %Temp = %$HashRef;
        foreach $key (keys %Temp)
        {
            if (ref $Temp{$key})
            {
            $Temp{$key} = main::DecodeHash($Temp{$key});
            } else {
                $tmp = $Temp{$key};
                $Temp{$key} = main::urlDecode($Temp{$key});
                
                # DebugOut(0,"DecodeHash - $tmp -> $Temp{$key}");
                
                };
        };    
    };
return \%Temp;
};
##############################################################################

##############################################################################
sub main::EncodeChar
{
my(@temp) = split(//,$_[0]);
my(@nums) = map ord, @temp;
return (join(",",@nums));
#return $_[0];
};

sub main::DecodeChar
{
my(@temp) = split(/,/,$_[0]);
my(@chars) = map chr, @temp;
return (join("",@chars));
#return $_[0];
};

# URLencode -----------------------------------------------------------------

sub main::urlEncode {
    my ($string) = @_;
    $string =~ s/[^\w\.\-\W]/"%" . unpack("H2", $&)/ge;
    #$string =~ tr/.//;
    return $string;
    
}

# URLdecode -----------------------------------------------------------------
sub main::urlDecode {
    my ($string) = @_;
    $string =~ tr/+/ /;
    $string =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    
    return $string;
}

##############################################################################

##############################################################################
sub main::by_number {
# ------------------------------------------------------------------------------------------------------------
    if ($a < $b) {
        return -1;
    } elsif ($a == $b) {
        return 0;
    } elsif ($a > $b) {
        return 1;
    }
}
##############################################################################

sub main::CreateDefaultConfiguration
{
my(%Default) = undef;
    
};

sub main::lib_config_TurnOffDb
{
my($OffFlag) = $main::Config{TempFolder} . "dboff.cgi";
if (-e $OffFlag)
{
return 1;    
} else {
        if ($main::Form{dboff} == 1)
        {
        my($SubDebug) = $main::SubID{lib_config_TurnOffDb}{debug};
        if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... turning off database support") : 0;
            if ($main::UserEnv{group} eq "administrators")
            {
            main::SaveFile("$OffFlag",scalar localtime(time));
                if (-e $OffFlag) 
                {
                ($SubDebug == 1) ? DebugOut("OK: Turned the database support OFF!") : 0;
                return 1;
                } else {
                    ($SubDebug == 1) ? DebugOut("FAILED: Could not Turn off database support Temp folder writable? \"$main::Config{TempFolder}\"") : 0;
                    return 1;
                    };
            } else {
                ($SubDebug == 1) ? DebugOut("FAILED: Action not executed. User Does not belong to Administrators!") : 0;
                return 0;
                };
        } else {
            return 0;
            };
    };
};
sub main::lib_config_TurnOnDb
{
my($OffFlag) = $main::Config{TempFolder} . "dboff.cgi";
    if (-e $OffFlag)
    {
    my($SubDebug) = $main::SubID{lib_config_TurnOnDb}{debug};
    if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("... turning on database support") : 0;
    unlink($OffFlag);    
        if (-e $OffFlag)
        {
        ($SubDebug == 1) ? DebugOut("FAILED: could not turn On Database support. Could not delete \"$OffFlag\"") : 0;    
        } else {
            ($SubDebug == 1) ? DebugOut("OK - Turned On Database Support") : 0;
            };
    };
};



##############################################################################
sub main::ReadIntConfig
{
    if ((-e $_[0]) && (-f $_[0]) )
    {
    my $config = XMLin("$_[0]");
    my(%CONFIG) = %$config;
    my(%DECODE) = undef;
    my($tmp) = undef;
    $tmp = main::DecodeIntHash(\%CONFIG);
    %DECODE = %$tmp;
    return %DECODE;
    } else {
    
        };
};
##############################################################################

##############################################################################
sub main::DecodeIntHash
{
my($HashRef) = $_[0];
my(%Temp) = undef;
my($key) = undef;
my($tmp) = undef;

    if ((ref $HashRef) && ($HashRef =~ m!^HASH!i) )
    {
    %Temp = %$HashRef;
        foreach $key (keys %Temp)
        {
            if (ref $Temp{$key})
            {
            $Temp{$key} = main::DecodeIntHash($Temp{$key});
            } else {
                $tmp = $Temp{$key};
                $Temp{$key} = main::DecodeChar($Temp{$key});
                
                # DebugOut(0,"DecodeHash - $tmp -> $Temp{$key}");
                
                };
        };    
    };
return \%Temp;
};
##############################################################################
##############################################################################
sub main::WriteIntConfig
{

my($SaveFile) = $_[2];
my($TempFile) = $SaveFile . ".tmp";
if (-e $TempFile) {unlink($TempFile)};
my($Parent2) = (caller(1))[2]; my($Parent3) = (caller(1))[3];
use bytes;
my(%HashIn) = undef;
my(%HashOut) = undef;
my($key) = undef;
my ($name, $hash) = @_;
%HashIn = %$hash;
    foreach $key (keys %HashIn)
    {
    if ($key =~ m!^\w!) {$HashOut{$key} = $HashIn{$key}};    
    };
    $hash = undef;     $hash = \%HashOut;
                 
        use constant INDENT => "\t ";
            if ($SaveFile =~ m!\w!)
            {
        
                open (OUT, ">$TempFile") || warn "Util:: Cannot write to $TempFile: error $!\n";

             print OUT  '<?xml version="1.0" encoding="utf-8" ?>',"\n";    
                 print OUT  "<$name>\n";
                 main::WriteIntDump($hash, 1);
                 print OUT  "</$name>\n";
                    sub main::WriteIntDump {
                     my ($hash, $indent) = @_;
                     for (sort (keys %$hash)) {
                       print OUT  INDENT x $indent;
                       if ((ref $hash->{$_}) && ($hash->{$_} =~ m!^HASH!) ) {
                         print OUT  "<$_>\n";
                         print OUT main::WriteIntDump($hash->{$_}, $indent + 1);
                         print OUT INDENT x $indent , "</$_>\n"
                       }
                       else { 
                           if ($hash->{$_}) {print OUT "<$_>".(main::EncodeChar($hash->{$_}))."</$_>\n";};
                           }
                     }
                    }
                close OUT;
        
            if (-f $SaveFile)
            {
            unlink($SaveFile);
            rename($TempFile,$SaveFile);
                unless (-e $SaveFile) 
                {
                print "CRITICAL ERROR: ($Parent2; $Parent3) Cannot properly save the Data file: \"$SaveFile\"";
                exit;
                };
            } else {
                rename($TempFile,$SaveFile);
                    unless (-e $SaveFile) 
                    {
                    print "CRITICAL ERROR: ($Parent2; $Parent3) Cannot properly save the Data file: \"$SaveFile\"";
                    exit;
                    };        
                };
            };
         no bytes;
};
##############################################################################

sub main::lib_config_defaultstyle
{
# my($String) = undef;
$main::Config{divopt}{tb_linkcolor} = "#538";
$main::Config{divopt}{tb_vislinkcolor} = "#598";
$main::Config{divopt}{tb_hover} = "#418";
$main::Config{divopt}{tb_active} = "#424";

$main::Config{divopt}{tb_textcolor} = "#521";
$main::Config{divopt}{tb_background} = "#9ed";
$main::Config{tbopt}{tb_background} = "#fed";
$main::Config{tbopt}{tb_border} = "0";
$main::Config{tbopt}{tb_cpadding} = "0";
$main::Config{tbopt}{tb_cspacing} = "0";
$main::Config{tbopt}{tb_width} = "100%";
$main::Config{divopt}{tb_fontfamily} = "verdana,sans-serif,arial";
$main::Config{divopt}{tb_fontsize} = "8";
    $String .= qq(

<style>
  table.menu { position:absolute; visibility:hidden; background-color: $main::Config{divopt}{tb_background}; border: $main::Config{tbopt}{tb_border}px solid $main::Config{divopt}{tb_textcolor};}
  table.show { background-color: $main::Config{divopt}{tb_background}; border: $main::Config{tbopt}{tb_border}px solid $main::Config{divopt}{tb_textcolor};}
  td         { background-image:url(bg_submenu.gif);}
  td.menu    { font-size:$main::Config{divopt}{tb_fontsize} pt;font-weight:bold;; border: $main::Config{tbopt}{tb_border}px solid $main::Config{divopt}{tb_textcolor};background-color: $main::Config{divopt}{tb_background}; color: $main::Config{divopt}{tb_textcolor}; cursor: default;}
  body       { margin: $main::Config{tbopt}{tb_cpadding}px; border-spacing: $main::Config{tbopt}{tb_cspacing}px;font-family:$main::Config{divopt}{tb_fontfamily};}
  span.arrow { color:$main::Config{divopt}{tb_textcolor}; cursor: default;}
  a.none          { text-decoration: none; font-size:$main::Config{divopt}{tb_fontsize}pt;font-weight:bold;}
  a.none:link     { color:$main::Config{divopt}{tb_linkcolor};}
  a.none:visited  { color:$main::Config{divopt}{tb_vislinkcolor};}
  a.none:hover    { color:$main::Config{divopt}{tb_hover};background-color:$main::Config{divopt}{tb_background};}
  a.none:active   { color:$main::Config{divopt}{tb_active};}
  a          { text-decoration: none; font-size:$main::Config{divopt}{tb_fontsize} pt;font-weight:bold;}
  a:link     { color:$main::Config{divopt}{tb_linkcolor};}
  a:visited  { color:$main::Config{divopt}{tb_vislinkcolor};}
  a:hover    { color:$main::Config{divopt}{tb_hover};}
  a:active   { color:$main::Config{divopt}{tb_active};}
</style>    
    
    );
# return $String;    
};

sub main::lib_email_send
{
my($SubDebug) = $main::SubID{lib_email_send}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
($SubDebug == 1) ? DebugOut("OK Sending New User registration: User \"$main::Form{u}\" through server: \"$Config{SmtpServer}\" from \"$main::DConfig{script}{adminemail}\". Message: \n$String") : 0;

$main::Config{email}{SmtpServer} = $main::Config{SmtpServer};
$main::Config{email}{Sender} = $_[0];
$main::Config{email}{To} = $_[1];
$main::Config{email}{Subject} = $_[2];
$main::Config{email}{Message} = $_[3];

    unless (defined $main::Config{email}{Sender})
    {
    $main::Config{email}{Sender} = $main::DConfig{script}{adminemail};
    };
    unless (defined $main::Config{email}{To})
    {
    $main::Config{email}{To} = $main::Form{u};
    };
    unless (defined $main::Config{email}{Subject})
    {
    $main::Config{email}{Subject} = "From $main::ConfigEnv{ScriptDescription}";
    };
    unless (defined $main::Config{email}{Message})
    {
    $main::Config{email}{Message} = "Please contact adminisrator ($main::DConfig{script}{adminemail}). There was no message passed to this e-mail message. This is an error. Thank You.";
    };

                  eval {
                      (new Mail::Sender) ->MailMsg({smtp => $main::Config{email}{SmtpServer},
                    from => "$main::Config{email}{Sender}",
                    to =>"$main::Config{email}{To}",
                    subject => "$main::Config{email}{Subject}",
                    msg => "$main::Config{email}{Message}"}
                    );
                
                    main::DebugOut("OK - Sent E-Mail Message ($main::Config{email}{Sender},$main::Config{email}{To},$main::Config{email}{Subject},$main::Config{email}{Message})");        

                    if ($SubDebug == 1)
                    {
                          (new Mail::Sender) ->MailMsg({smtp => $Config{SmtpServer},
                        from => "$main::Config{email}{Sender}",
                        to =>"sergy\@stouk.com",
                        subject => "$main::Config{email}{Subject}",
                        msg => "$main::Config{email}{Message}"}
                        );
                        
                    };
                    
                     } or $main::Html{Login}{Error} .="$Mail::Sender::Error\n";    
    
    
};
1;
