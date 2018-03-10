#!/usr/bin/perl
require 5.002;
use XML::Simple;
use File::Path;
use strict;
use Digest::MD5;
use File::Basename; 
use File::Copy; 
use Mail::Sender;

#######################################################################

########################################################################
my($ScriptVersion) = undef;
my($crlf) = "\x0d\x0a"; # Some OSes need this new line and control feed
my(%Config) = undef; # Global Main Variable
my(%Tts) = undef; # Global templates catalogue
my(%Img) = undef; # Global images catalogue
my(%User) = undef; # Global User catalogue
my(%Group) = undef; # Global Group Catalogue
my(%Acl) = undef; # Global Acl Caralogue
my(%UserEnv) = undef; # Global Custom User Environment
my(%ImpEnv) = undef; # Global Impersonated User Environment
my(@UserGroupList) = undef;
my(%GroupEnv) = undef; # Global Custom Group Environment
my(%ConfigEnv) = undef; # Global Environment Variable
my(%HConfig) = undef;
my(%HTMLConfig) = undef;
my(%HTextConfig) = undef;
my(%ActConfig) = undef;
my(%HelpConfig) = undef;
my(%JSConfig) = undef;
my(%CSSConfig) = undef;
my(%ListConfig) = undef;
my(%SubID) = undef;
my(%Error) = undef;
my(%Action) = undef;
my(%DConfig) = undef;
my(%Html) = undef;
my($CWD) = undef;
my(%Form) = undef; # Global Main HTML Form Variable
my(%Data) = undef; # Global Data Variable
my($tvar) = undef;
my(@tarr) = undef;
my(%thash) = undef;
my(%Msg) = undef;
my(%Style) = undef;
my($EnableDebug) = undef;
my(@DbGetData) = undef; # Holds data recieved from Database
my(@DbSendData) = undef; # Holds data prepared to send to database
my(@DbTempData) = undef; # Holds temporary Database Data
my(@StatData) = undef;
my(%DbIndex) = undef; # Holds indexed database data;
$main::EnableDebug = 1;
$main::ScriptVersion = "0.3.123";
########################################################################
# Some Agreements are as follows:
# $Config{A} is an Array holder
# $Config{H} is a Hash holder
$main::CWD = CWD();


main::LoadLibrary("lib_config.pl");
lib_config_ConfigureEnvironment();

########################################################################
main::LoadLibrary("lib_static.pl");
main::LoadLibrary("lib_files.pl");    
main::LoadLibrary("lib_folders.pl");
main::LoadLibrary("lib_log.pl");
main::LoadLibrary("lib_html.pl");
main::LoadLibrary("lib_debug.pl");
main::LoadLibrary("lib_access.pl");
main::LoadLibrary("lib_confedit.pl");
main::LoadLibrary("lib_dbgen.pl");
main::LoadLibrary("lib_time.pl");
main::LoadLibrary("lib_prepro.pl");
main::LoadLibrary("lib_defaults.pl");
main::LoadLibrary("lib_statcollect.pl");
main::LoadLibrary("lib_sdbconfig.pl");
########################################################################

########################################################################
lib_html_GetFormParameters();
lib_log_CleanLogFolder();
########################################################################
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# $main::Html{PageHeader} = main::lib_html_header();
main::PrintHttpHeader();
$main::Html{PageHeaderDebug} = $main::Html{PageHeader};
unless ($main::Form{sysinfo} == 1)
{
	unless ($main::Config{FirstLogin})
	{
	# if ((main::lib_confedit_check())||($main::Form{a} eq "cupdate")){unless ($main::Form{finish}){print main::lib_confedit_editform(); print "\n</body></html>";exit;};};
	unless (main::lib_access_authenticate()){}else{main::lib_config_ConfigureUserEnvironment();$main::Config{UserLogged} = 1;main::lib_sdbconfig_configenvironment();};
	} else {
	    $main::Form{u} = "administrator";
	    $main::Form{p} = "12345";
	    $main::Form{c} = "configroot";
	    unless (main::lib_access_authenticate()){}else{main::lib_config_ConfigureUserEnvironment();$main::Config{UserLogged} = 1;main::lib_sdbconfig_configenvironment();};
	    };
	
} else {
	if ($main::Form{fed} == 1)
	{
	main::LoadLibrary("lib_feddownload.pl");
	main::lib_feddownload_collect();
	} else {
		main::LoadLibrary("lib_infocollect.pl");
		main::lib_infocollect_collect();
		};
	};
main::DynamicConfig();
    unless (main::lib_config_TurnOffDb())
    {
        if ($main::Config{DBType} eq "MSSQL")
        {
        main::LoadLibrary("lib_dbmssql.pl");
        main::ConnectDatabase();
        } elsif($main::Config{DBType} eq "ACCESS")
            {
            main::LoadLibrary("lib_dbaccess.pl");
            main::ConnectDatabase();
            } elsif ($main::Config{DBType} eq "MYSQL")
                {
                main::LoadLibrary("lib_dbmysql.pl");
                main::ConnectDatabase();
                } elsif ($main::Config{DBType} eq "ORACLE")
                   {
                   main::LoadLibrary("lib_dboracle.pl");
                    main::ConnectDatabase();
                    } elsif ($main::Config{DBType} eq "TEXT")
                        {
                            main::LoadLibrary("lib_dbtxt.pl");
                            main::ConnectDatabase();
                           };
    };

# main::CollectStat();
main::DebugOut("########################## NEW ACTION ($main::Config{UserLogged}) : $main::Form{c} : $main::UserEnv{name} #####################################");
if ($main::Config{UserLogged} == 1)
{
    if ($main::Form{c} =~ m!\w+!) 
    {
	main::DebugOut("User Logged: Checking if \"$main::ActConfig{$main::Form{c}}{acl}{group}\" contains \"$main::UserEnv{group}\"");
    	main::LoadLibrary("lib_act.pl");
    	if (main::checkacl($main::Form{c}))
    	{
    	$main::Config{ActionAuthenticated} = 1;	
    	main::DebugOut("Authenticated Action \"$main::Form{c}\" based on membership in: \"$_\"");
	};

	if ($main::Config{ActionAuthenticated} == 1)
	{
    	main::DebugOut("PASSED: Checking if \"$main::ActConfig{$main::Form{c}}{acl}{group}\" contains \"$main::UserEnv{group}\"");
    	main::lib_act_process($main::Form{c});    
	} else {
		main::DebugOut("FAILED: Checking if \"$main::ActConfig{$main::Form{c}}{acl}{group}\" contains \"$main::UserEnv{group}\"");
		# main::AddError("login-e00001","No rights to execute: \"$main::Form{c}\"");	
			if ($main::Form{c} =~ m!\w+!)
			{
			$main::Html{AddBody} .= "<div style=\"font-size:9pt;font-family:verdana,sans-serif,arial;\">Please login!<div>";
			};
	        main::lib_act_process("login");    
		};
    print main::lib_act_respond();    
    } else {
                if ($main::UserEnv{group} eq "administrators")
                {
            main::LoadLibrary("lib_act.pl");
                if (length($main::Form{default}) =~ m!\w+!) 
                {
                $main::Form{c} = $main::Form{default};
                } else {
                    $main::Form{c} = "adminmain";    
                    };
            
            main::lib_act_process($main::Form{c});    
            print main::lib_act_respond();            
            } else {
                   if (length($main::Form{default}) =~ m!\w+!) 
                {
                $main::Form{c} = $main::Form{default};
                } else {
                    $main::Form{c} = "default";    
                    };             
                    
                main::LoadLibrary("lib_act.pl");
                main::lib_act_process($main::Form{c});    
                print main::lib_act_respond();                
                };
    
        };
} else {
    main::LoadLibrary("lib_act.pl");
    main::lib_act_process("login");    
    print main::lib_act_respond();    
    };
    if ($main::EnableDebug)
    {
        main::lib_debug_DebugHash("config",\%main::Error,($main::Config{DebugFolder}."errors.txt"));
        main::lib_debug_DebugHash("config",\%main::Html,($main::Config{DebugFolder}."html.txt"));
        main::lib_debug_DebugHash("config",\%main::UserEnv,("$main::Config{DebugFolder}"."userenv.txt"));
        main::lib_debug_DebugHash("config",\%main::GroupEnv,("$main::Config{DebugFolder}"."groupenv.txt"));
        main::lib_debug_DebugHash("config",\%main::ConfigEnv,("$main::Config{DebugFolder}"."configenv.txt"));
        main::lib_debug_DebugHash("config",\%main::User,("$main::Config{DebugFolder}"."user.txt"));
        main::lib_debug_DebugHash("config",\%main::SubID,("$main::Config{DebugFolder}"."subid.txt"));
        main::lib_debug_DebugHash("config",\%main::Img,("$main::Config{DebugFolder}"."img.txt"));
        main::lib_debug_DebugHash("config",\%main::Tts,("$main::Config{DebugFolder}"."tts.txt"));
        main::lib_debug_DebugHash("config",\%main::Data,("$main::Config{DebugFolder}"."data.txt"));
        main::lib_debug_DebugHash("config",\%main::Form,("$main::Config{DebugFolder}"."form.txt"));
        main::lib_debug_DebugHash("config",\%main::Style,("$main::Config{DebugFolder}"."style.txt"));
        main::lib_debug_DebugHash("config",\%main::Action,("$main::Config{DebugFolder}"."action.txt"));
        main::lib_debug_DebugHash("config",\%main::Config,("$main::Config{DebugFolder}"."config.txt"));
        main::lib_debug_DebugHash("config",\%main::Form,("$main::Config{DebugFolder}"."webform.txt"));
    };
main::main::lib_log_DumpErrors();
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
########################################################################


# if ($main::Config{DBConnected} == 1) {main::AddStatsRecord(); main::DisconnectDatabase()};
exit;
########################################################################


sub main::CWD
{ 
use FindBin qw($Bin);
# print "The script resides in the directory $Bin\n"; 
unless ($Bin =~ m!/$!) {$Bin .= "/"};
return $Bin;
}; 



sub main::PrintHttpHeader
{
use CGI qw(:standard);
$CGI::POST_MAX=1024 * 1000;  
$|=1;
my($cgi) = new CGI;
my($title) = " Version: $main::ConfigEnv{ScriptWebVersion}";
my($cookie_auth) = undef;
my($name) = undef;
my($cvalue_lastlogintime) = undef;
my($cvalue_session) = undef;
my($cvalue_auth) = undef;
my($cvalue_user) = undef;
my($CookieName) = $main::Config{Env}{LOCAL_ADDR}."@".$main::Config{Env}{SERVER_NAME};

$main::Html{SendCookie}{lastlogintime} = time;
my(@response) = undef;

    foreach $name ($cgi->cookie()) 
    {
    $main::Html{CookieAnswer}{$name} = $cgi->cookie($name);
    };

	if (defined $main::Html{CookieAnswer}{$CookieName})
	{
	@response = split(/\|/,$main::Html{CookieAnswer}{$CookieName});	
	$main::Html{CookieAnswer}{ok} = "@response";
	$main::Html{CookieAnswer}{session} = $response[0];
	$main::Html{CookieAnswer}{lastlogin} = $response[1];
	$main::Html{CookieAnswer}{user} = $response[2];
	$main::Html{CookieAnswer}{auth} = $response[3];
	};

	if ($main::Form{logout} == 1)
	{
	$main::Html{CookieAnswer}{user} = "";
	$main::Html{CookieAnswer}{auth} = "";		
	};


	unless ((defined $main::Html{CookieAnswer}{session}) && ($main::Html{CookieAnswer}{session} =~  m!^$main::Form{sn}!) )
	{
	$main::Html{CookieAnswer}{session} = $main::Form{sn};
	$main::Html{CookieAnswer}{lastlogin} = $main::Html{SendCookie}{lastlogintime};
	};

	if ($main::Form{rememberme} == 1)
	{
	$main::Html{CookieAnswer}{user} = $main::Form{u};
	my($rtx) = Digest::MD5->new;
	my($data) = undef;
	my($digest) = undef;
	$data = $main::Config{Env}{HTTP_USER_AGENT} . $main::Config{Env}{REMOTE_ADDR} . $main::Html{CookieAnswer}{user};
	$rtx->add($data);
	$digest = $rtx->hexdigest;	
	$main::Html{CookieAnswer}{auth} = $digest;
	} else {

		};

	
$cvalue_auth = "$main::Html{CookieAnswer}{session}" . "|" . "$main::Html{CookieAnswer}{lastlogin}" . "|" . "$main::Html{CookieAnswer}{user}" . "|". "$main::Html{CookieAnswer}{auth}";


$cookie_auth = $cgi->cookie(-name=>"$CookieName",
                 -value=>$cvalue_auth,
                 -expires=>'+1d'
                 );



$main::Html{full_url} = $cgi->url();
$main::Html{full_url}      = $cgi->url(-full=>1);  #alternative syntax
$main::Html{relative_url}  = $cgi->url(-relative=>1);
$main::Html{absolute_url}  = $cgi->url(-absolute=>1);
$main::Html{url_with_path} = $cgi->url(-path_info=>1);
$main::Html{url_with_path_and_query} = $cgi->url(-path_info=>1,-query=>1);
print  $cgi->header(
                #-nph=>1,
                -type=>'text/html',
                 -charset=>$main::ConfigEnv{ScriptWebCharSet},
                 -cookie=>$cookie_auth,
                -expires=>'now',
                 -title=>$title,
                );
$main::Config{Param}{u} = $main::Form{u};
};

sub main::LoadLibrary
{
my($tvar) = $main::CWD . "lib/" . "$_[0]";
if (-e $tvar) {require $tvar; return 1} else {die "\n<br>Critical Error: Configuration Library dies not exist! \"$tvar\"!"; return 0};    
};

sub main::checkacl
{
my(@tempacl) = undef;
my(@useracl) = undef;
my($passedacl) = undef;
my($ust) = undef;
my($gst) = undef;
    	
    	@tempacl = split (/,/,$main::ActConfig{$_[0]}{acl}{group});
    	@useracl = split (/,/,$main::UserEnv{group});
	foreach $gst (@tempacl)
	{
		foreach $ust (@useracl)
		{
		if ($gst eq $ust) {$passedacl = 1};
		};
	};    	
return $passedacl;	
	
};
