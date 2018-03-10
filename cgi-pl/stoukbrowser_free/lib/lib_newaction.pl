sub main::lib_newaction_createkeys
{
my($ActionKey) = $_[0];
my($Success) = 0;
my($DatabaseOption) = $_[1];
my($DatabaseTable) = $_[2];

$ActConfig{$ActionKey}{htmltemplate}{name} = "$ActionKey". ".htm";
$HConfig{$ActionKey}{name} = "$ActionKey". ".cgi";
$HTMLConfig{$ActionKey}{name} = "$ActionKey". ".htm";
$JSConfig{$ActionKey}{head}{name} = "h_"."$ActionKey". ".cgi";
$JSConfig{$ActionKey}{body}{name} = "b_"."$ActionKey". ".cgi";
$CSSConfig{$ActionKey}{name} = "$ActionKey". ".cgi";
$HelpConfig{$ActionKey}{name} = "$ActionKey". ".cgi";

my($HtmlTemplateName)  = $main::Config{TtsSubFolders}{html} . $ActConfig{$ActionKey}{htmltemplate}{name};
my($HFileTemplateName) = $main::Config{TtsSubFolders}{hfile} . $HConfig{$ActionKey}{name};
my($JSHeadFileTemplateName) = $main::Config{TtsSubFolders}{js} . $JSConfig{$ActionKey}{head}{name};
my($JSBodyFileTemplateName) = $main::Config{TtsSubFolders}{js} . $JSConfig{$ActionKey}{body}{name};
my($CSSFileTemplateName) = $main::Config{TtsSubFolders}{css} . $CSSConfig{$ActionKey}{name};
my($HelpFileTemplateName) = $main::Config{TtsSubFolders}{help} . $HelpConfig{$ActionKey}{name};

my($LibTemplateName)   = $main::CWD . "lib/" . "act_"."$ActionKey".".pl";

unless (-e $HtmlTemplateName) {main::SaveFile($HtmlTemplateName,main::lib_newaction_getdefault_html($ActionKey))};
unless (-e $HFileTemplateName) {main::SaveFile($HFileTemplateName,main::lib_newaction_getdefault_hfile($ActionKey))};
unless (-e $LibTemplateName) {main::SaveFile($LibTemplateName,main::lib_newaction_getdefault_lib($ActionKey,$DatabaseOption,$DatabaseTable))};
unless (-e $JSHeadFileTemplateName) {main::SaveFile($JSHeadFileTemplateName,main::lib_newaction_getdefault_jshead($ActionKey))};
unless (-e $JSBodyFileTemplateName) {main::SaveFile($JSBodyFileTemplateName,main::lib_newaction_getdefault_jsbody($ActionKey))};
unless (-e $CSSFileTemplateName) {main::SaveFile($CSSFileTemplateName,main::lib_newaction_getdefault_css($ActionKey))};
unless (-e $HelpFileTemplateName) {main::SaveFile($HelpFileTemplateName,main::lib_newaction_getdefault_css($ActionKey))};

$ActConfig{$ActionKey}{acl}{group} = "administrators";
$ActConfig{$ActionKey}{acl}{user} = "none";
	if (length($main::Form{newactiondescription}) > 1)
	{
	$ActConfig{$ActionKey}{description} = $main::Form{newactiondescription};		
	$HConfig{$ActionKey}{description} = "Form: ($ActionKey) $main::Form{newactiondescription}";
	$HTMLConfig{$ActionKey}{description} = "HTML Template: ($ActionKey) $main::Form{newactiondescription}";
	$CSSConfig{$ActionKey}{description} = "CSS: ($ActionKey) $main::Form{newactiondescription}";
	$JSConfig{$ActionKey}{description} = "JavaScript: ($ActionKey) $main::Form{newactiondescription}";
	$HelpConfig{$ActionKey}{description} = "Help: ($ActionKey) $main::Form{newactiondescription}";
	} else {
		$ActConfig{$ActionKey}{description} = "Title for command $ActionKey";
		$HConfig{$ActionKey}{description} = "Description for form file: $ActionKey";
		$HTMLConfig{$ActionKey}{description} = "Description for form file: $ActionKey";
		$CSSConfig{$ActionKey}{description} = "Description for CSS file: $ActionKey";
		$JSConfig{$ActionKey}{description} = "Description for JS file: $ActionKey";
		$HelpConfig{$ActionKey}{description} = "Description for Help file: $ActionKey";
		};

$HConfig{$ActionKey}{acl}{group} = "administrators";
$HConfig{$ActionKey}{acl}{user} = "none";
$HTMLConfig{$ActionKey}{acl}{group} = "administrators";
$HTMLConfig{$ActionKey}{acl}{user} = "none";
$CSSConfig{$ActionKey}{acl}{group} = "administrators";
$CSSConfig{$ActionKey}{acl}{user} = "none";
$JSConfig{$ActionKey}{acl}{group} = "administrators";
$JSConfig{$ActionKey}{acl}{user} = "none";
$HelpConfig{$ActionKey}{acl}{group} = "administrators";
$HelpConfig{$ActionKey}{acl}{user} = "none";



main::WriteIntConfig("config",\%ActConfig,$main::Config{ActConfigFile});
main::WriteIntConfig("config",\%HConfig,$main::Config{HConfigFile});
main::WriteIntConfig("config",\%JSConfig,$main::Config{JSConfigFile});
main::WriteIntConfig("config",\%CSSConfig,$main::Config{CSSConfigFile});
main::WriteIntConfig("config",\%HTMLConfig,$main::Config{HTMLConfigFile});
main::WriteIntConfig("config",\%HelpConfig,$main::Config{HelpConfigFile});

	if ((-f $HtmlTemplateName) && (-f $HFileTemplateName) && (-f $LibTemplateName))
	{
	$Success = 1;
	$main::Config{newactionOK} = 1;
	};
return $Success;
};

sub main::lib_newaction_getdefault_jshead
{
my($ActionKey) = $_[0];
my($String) = qq(

);
return $String;	
};

sub main::lib_newaction_getdefault_jsbody
{
my($ActionKey) = $_[0];
my($String) = qq(

);
return $String;	
};

sub main::lib_newaction_getdefault_css
{
my($ActionKey) = $_[0];
my($String) = qq(

);
return $String;	
};

sub main::lib_newaction_getdefault_lib
{
my($ActionKey) = $_[0];
my($String) = "# Action library for $ActionKey\n\n";
my($DatabaseOption) = $_[1];
my($DatabaseTable) = $_[2];
my($DBString) = undef;
my($DBAfterString) = undef;

my($SubDebug) = $main::SubID{lib_newaction_getdefault_lib}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("\$ActionKey = $ActionKey; \$DatabaseOption = $DatabaseOption; \$DatabaseTable = $DatabaseTable") : 0;

if ($DatabaseOption == 1)
{

$DBString .= "\n". '####################################################################################################################';
$DBString .= "\n". 'my($StrFile) =  $main::Config{sdb}{dbstruct}{'."$DatabaseTable".'};';
$DBString .= "\n". 'my($DatabaseFile) =  $main::Config{sdb}{dbmain}{'."$DatabaseTable".'};';
$DBString .= "\n". 'my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{'."$DatabaseTable".'};';
$DBString .= "\n". 'main::LoadLibrary("lib_sdbstructure.pl");';
$DBString .= "\n". 'main::lib_sdbconfig_processcommand_structure($StrFile,$DatabaseFile,$DatabaseFolder);';	
$DBString .= "\n". '####################################################################################################################';

$DBAfterString .= "\n". '####################################################################################################################';
$DBAfterString .= "\n". 'my($StrFile) =  $main::Config{sdb}{dbstruct}{'."$DatabaseTable".'};';
$DBAfterString .= "\n". 'my($DatabaseFile) =  $main::Config{sdb}{dbmain}{'."$DatabaseTable".'};';
$DBAfterString .= "\n". 'my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{'."$DatabaseTable".'};';
$DBAfterString .= "\n". '$String = main::lib_sdbconfig_processcommand_afterstructure($StrFile,$DatabaseFile,$DatabaseFolder);';	
$DBAfterString .= "\n". '#$String = $main::Config{sdb}{message}{error} .  $String;';	
$DBAfterString .= "\n". '####################################################################################################################';

} elsif ($DatabaseOption == 2)
{
$DBString .= "\n". '####################################################################################################################';
$DBString .= "\n". 'my($StrFile) =  $main::Config{sdb}{dbstruct}{'."$DatabaseTable".'};';
$DBString .= "\n". 'my($DatabaseFile) =  $main::Config{sdb}{dbmain}{'."$DatabaseTable".'};';
$DBString .= "\n". 'my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{'."$DatabaseTable".'};';
$DBString .= "\n". 'my($IndexLetter) = "t";';
$DBString .= "\n". 'my($TableName) = "'."$DatabaseTable".'";';
$DBString .= "\n". '####################################################################################################################';	
$DBString .= "\n". 'main::lib_sdbconfig_processcommands_edit($StrFile,$DatabaseFile,$DatabaseFolder,$IndexLetter);';			


$DBAfterString .= "\n". '####################################################################################################################';
$DBAfterString .= "\n". 'my($StrFile) =  $main::Config{sdb}{dbstruct}{'."$DatabaseTable".'};';
$DBAfterString .= "\n". 'my($DatabaseFile) =  $main::Config{sdb}{dbmain}{'."$DatabaseTable".'};';
$DBAfterString .= "\n". 'my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{'."$DatabaseTable".'};';
$DBAfterString .= "\n". 'my($IndexLetter) = "t";';
$DBAfterString .= "\n". 'my($TableName) = "'."$DatabaseTable".'";';
$DBAfterString .= "\n". '####################################################################################################################';	
$DBAfterString .= "\n". '$String = main::lib_sdbconfig_processcommand_afteredit($StrFile,$DatabaseFile,$DatabaseFolder,$IndexLetter,$TableName);';			
$DBAfterString .= "\n". '#$String = $main::Config{sdb}{message}{error} . $String;';	
} elsif ($DatabaseOption == 3)
{

$DBString .= "\n". '####################################################################################################################';
$DBString .= "\n". 'my($StrFile) =  $main::Config{sdb}{dbstruct}{'."$DatabaseTable".'};';
$DBString .= "\n". 'my($DatabaseFile) =  $main::Config{sdb}{dbmain}{'."$DatabaseTable".'};';
$DBString .= "\n". 'my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{'."$DatabaseTable".'};';
$DBString .= "\n". 'my($IndexLetter) = "t";';
$DBString .= "\n". 'my($TableName) = "'."$DatabaseTable".'";';
$DBString .= "\n". '####################################################################################################################';	
$DBString .= "\n". 'main::lib_sdbconfig_processcommands_view($StrFile,$DatabaseFile,$DatabaseFolder,$IndexLetter);';			


$DBAfterString .= "\n". '####################################################################################################################';
$DBAfterString .= "\n". 'my($StrFile) =  $main::Config{sdb}{dbstruct}{'."$DatabaseTable".'};';
$DBAfterString .= "\n". 'my($DatabaseFile) =  $main::Config{sdb}{dbmain}{'."$DatabaseTable".'};';
$DBAfterString .= "\n". 'my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{'."$DatabaseTable".'};';
$DBAfterString .= "\n". 'my($IndexLetter) = "t";';
$DBAfterString .= "\n". 'my($TableName) = "'."$DatabaseTable".'";';
$DBAfterString .= "\n". '####################################################################################################################';	
$DBAfterString .= "\n". '$String = main::lib_sdbconfig_processcommand_afterview($StrFile,$DatabaseFile,$DatabaseFolder,$IndexLetter,$TableName);';			
$DBAfterString .= "\n". '#$String = $main::Config{sdb}{message}{error} . $String;';

} else {
	
	};

($SubDebug == 1) ? DebugOut("\$DBString = $DBString") : 0;
($SubDebug == 1) ? DebugOut("\$DBAfterString = $DBAfterString") : 0;
	$String .= q(
	sub main::pre_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute before Template generation:
		   );
		   
	$String .= $DBString;
	$String .= q(		   
	};
		    );
		    
	$String .= q(
	sub main::post_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute after Template generation:
	);

$String .= "\n". 'my($String) = undef;';
$String .= $DBAfterString;
$String .= "\n". '$main::Config{$main::Form{c}}{ok} .= "";';
$String .= "\n". '$main::Config{$main::Form{c}}{error} .= "";';
$String .= "\n". '$String .= '."main::act_".$ActionKey."_form();";
	unless ($DatabaseOption > 0)
	{
	$String .= "\n". '$String .= "<input type=\"submit\" value=\"Submit\" />";';
	};

$String .= "\n". '$String = $main::Config{$main::Form{c}}{error} . $main::Config{$main::Form{c}}{ok} . $String;';
$String .= "\n". '$main::Html{ServiceText} =~ s!<insert-'.$ActionKey.'-content>!$String!gis;';
$String .= qq(
};

);


$String .= "\nsub main::act_".$ActionKey."_form";
$String .= q(

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
	<td><b></b></td>
	<td><b></b></td>	
</tr>
);	


		
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
1;
);
return $String;	
};

sub main::lib_newaction_getdefault_html
{
my($ActionKey) = $_[0];
my($String) = qq(_hfile-$ActionKey-name_);
return $String;	
};

sub main::lib_newaction_getdefault_hfile
{
my($ActionKey) = $_[0];
my($String) = qq(
<DIV style="font-family:verdana,sans-serif,arial;font-size=14pt; color:#333">
_config-command-description_
</DIV>
<DIV style="font-family:verdana,sans-serif,arial;font-size=8pt; color:#777">
Edit This Command Templates: 
[<a href="_config-user-linkid_&c=pedit&pfile=hfile-_form-option-c_" style="font-family:verdana,sans-serif,arial;font-size=8pt; color:#596" target="_self">Form</a>]
 | [<a href="_config-user-linkid_&c=hedit&pfile=htfile-_form-option-c_" style="font-family:verdana,sans-serif,arial;font-size=8pt; color:#596" target="_self">Page</a>]
 | [<a href="_config-user-linkid_&c=pedit&pfile=lib-_form-option-c_" style="font-family:verdana,sans-serif,arial;font-size=8pt; color:#596" target="_self">Code</a>]
 | [<a href="_config-user-linkid_&c=pedit&pfile=js-_form-option-c_" style="font-family:verdana,sans-serif,arial;font-size=8pt; color:#596" target="_self">Header</a>]
 | [<a href="_config-user-linkid_&c=pedit&pfile=help-_form-option-c_" style="font-family:verdana,sans-serif,arial;font-size=8pt; color:#596" target="_self">Help</a>]
</DIV>
<form method="post" name="registerform" action="_config-script-webpath_" target="_self" enctype="multipart/form-data">
<table style="width:100%; font-family:verdana,arial; font-size:8pt; background:#dec">
<tr>
<td>
<insert-$ActionKey-content>
</td>
</tr>
<tr>
<td>
_config-user-formid_
<input type="hidden" name="c" value="_form-option-c_" />
<input type="hidden" name="sn" value="_form-option-sn_" />
<input type="hidden" name="default" value="_form-option-default_" />
</td>
</tr>

<tr>
<td>
[<a href="_config-script-webpath_?c=login&logout=1" style="color:#333333; background:#aaaaaa">Logout</a>]
</td>
</tr>

</table>
</form>
);

return $String;	
};

sub main::lib_newaction_delete
{
my($ActionKey) = $_[0];
my($Success) = 0;
my($HtmlTemplateName)  = $main::Config{TtsSubFolders}{html} . $ActConfig{$ActionKey}{htmltemplate}{name};
my($HFileTemplateName) = $main::Config{TtsSubFolders}{hfile} . $HConfig{$ActionKey}{name};
my($JSHeadFileTemplateName) = $main::Config{TtsSubFolders}{js} . $JSConfig{$ActionKey}{head}{name};
my($JSBodyFileTemplateName) = $main::Config{TtsSubFolders}{js} . $JSConfig{$ActionKey}{body}{name};
my($CSSFileTemplateName) = $main::Config{TtsSubFolders}{css} . $CSSConfig{$ActionKey}{name};
my($LibTemplateName)   = $main::CWD . "lib/" . "act_"."$ActionKey".".pl";
if (-e $HtmlTemplateName) {unlink($HtmlTemplateName)};
if (-e $HFileTemplateName) {unlink($HFileTemplateName)};
if (-e $LibTemplateName) {unlink($LibTemplateName)};
if (-e $JSHeadFileTemplateName) {unlink($JSHeadFileTemplateName)};
if (-e $JSBodyFileTemplateName) {unlink($JSBodyFileTemplateName)};
if (-e $CSSFileTemplateName) {unlink($CSSFileTemplateName)};
undef $ActConfig{$ActionKey};
undef $HConfig{$ActionKey};
undef $HTMLConfig{$ActionKey};
undef $JSConfig{$ActionKey};
undef $JSConfig{$ActionKey};
undef $CSSConfig{$ActionKey};
main::WriteIntConfig("config",\%ActConfig,$main::Config{ActConfigFile});
main::WriteIntConfig("config",\%HConfig,$main::Config{HConfigFile});
main::WriteIntConfig("config",\%JSConfig,$main::Config{JSConfigFile});
main::WriteIntConfig("config",\%CSSConfig,$main::Config{CSSConfigFile});
main::WriteIntConfig("config",\%HTMLConfig,$main::Config{HTMLConfigFile});

$main::Config{rmactionOK} = 1;
return 1;
};
1;