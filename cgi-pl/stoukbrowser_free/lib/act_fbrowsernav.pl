# Action library for fbrowsernav


	sub main::pre_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	$SubDebug = 1;
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute before Template generation:
	main::LoadLibrary("lib_fbrowser.pl");
	main::lib_fbrowser_readconfig();
		unless ($main::Form{rootpath} =~ m!\w\d+!)
		{
		$main::Form{rootpath} = $main::Config{fbrowser}{defaultkey};	
		};

	($SubDebug == 1) ? DebugOut("\$main::Form{rootpath} = $main::Form{rootpath}") : 0;
	unless ((-d $main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{path}) && ($main::Form{rootpath} =~ m!\w!))
	{
	$main::Config{CEnv}{$main::Form{c}}{RootFolderPath} = undef;	
	} else {
		$main::Config{CEnv}{$main::Form{c}}{RootFolderPath} = $main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{path};
		# main::fbrowsernav_generatetreetemplate();
		($SubDebug == 1) ? DebugOut("\$main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{path} = $main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{path}") : 0;	
		($SubDebug == 1) ? DebugOut("\$main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{jspitemswebpath} = $main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{jspitemswebpath}") : 0;	
		($SubDebug == 1) ? DebugOut("\$main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{jsnavtplwebpath} = $main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{jsnavtplwebpath}") : 0;	
		($SubDebug == 1) ? DebugOut("\$main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{jspitemspath} = $main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{jspitemspath}") : 0;	
		($SubDebug == 1) ? DebugOut("\$main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{jsnavtplpath} = $main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{jsnavtplpath}") : 0;	
		};

	
	
	};
		    
	sub main::post_act_process
	{
	my($SubDebug) = $main::SubID{pre_act_process}{debug};
	if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	# Insert Code to execute after Template generation:
	
my($String) = undef;
$main::Config{$main::Form{c}}{ok} .= "";
$main::Config{$main::Form{c}}{error} .= "";
$String .= main::act_fbrowsernav_form();

my($key) = undef;

if (main::checkacl("fbrowseradmin")) 
{
		$String .= qq(
		[<a href="administration.htm"  style="font-family:verdana,sans-serif,arial;font-size=8pt; color:#ffffff; background:#999999" target="_top">Administration</a>]
		    );
};

$String .= "\n<SCRIPT LANGUAGE=\"JavaScript\" TYPE=\"text/javascript\">";
$String .= "\n<!--";
$String .= "\nfunction switchpage(select) {";
$String .= "\n  var index;";
$String .= "\n  for(index=0; index<select.options.length; index++)";
$String .= "\n    if(select.options[index].selected)";
$String .= "\n      {";
$String .= "\n        if(select.options[index].value!=\"\")";
$String .= "\n          window.location.href=\"$main::UserEnv{href}&c=fbrowsernav&rootpath=\"+select.options[index].value;";
$String .= "\n        break;";
$String .= "\n      }";
$String .= "\n}";
$String .= "\n// --></SCRIPT>";

$String .= qq(
	<select name="rootpath" onchange="switchpage(this)">
	);
	
	foreach $key (sort {$main::Config{fbrowser}{config}{roots}{$a}{name} cmp $main::Config{fbrowser}{config}{roots}{$b}{name}} keys %{$main::Config{fbrowser}{config}{roots}})
	{
		if (-d $main::Config{fbrowser}{config}{roots}{$key}{path})
		{
			if (($key eq $main::Form{rootpath}) && (defined $key))
			{
			$String .= qq(<option value="$key" SELECTED>$main::Config{fbrowser}{config}{roots}{$key}{name}</option>);				
			} else {
				$String .= qq(<option value="$key">$main::Config{fbrowser}{config}{roots}{$key}{name}</option>);				
				};

		};
	};
$String .= qq(
	</select>

	);




$String .= "<input type=\"hidden\" name=\"rootpath\" value=\"$main::Form{rootpath}\" />";



	if (-d $main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{path})
	{
	
	
	$String .= "\n<script language=\"JavaScript\" src=\"$main::Config{bfrowser}{jssourcenavwebpath}\"></script>\n";
	$String .= "\n<script language=\"JavaScript\" src=\"$main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{jsnavtplwebpath}\"></script>\n";
	$String .= "\n<script language=\"JavaScript\" src=\"$main::Config{fbrowser}{config}{roots}{$main::Form{rootpath}}{jspitemswebpath}\"></script>\n";
	$String .= "\n<script language=\"JavaScript\">\n";
	$String .= "new tree (TREE_ITEMS, tree_tpl);\n";
	$String .= "\n</script>\n";
	} else {
		$main::Config{$main::Form{c}}{ok} .= "<b>Select the root folder and click submit</b>";
		};




$String = $main::Config{$main::Form{c}}{error} . $main::Config{$main::Form{c}}{ok} . $String;
$main::Html{ServiceText} =~ s!<insert-fbrowsernav-content>!$String!gis;
};


sub main::act_fbrowsernav_form

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


sub main::act_fbrowsernav_createrootmenu
{
use Data::Dumper;

	if (-d $main::Config{CEnv}{$main::Form{c}}{RootFolderPath})
	{
	my(%Tree) = undef;
	%Tree = %{(main::HashDir($main::Config{CEnv}{$main::Form{c}}{RootFolderPath}))};
	main::WriteTreeConfig("Root",\%Tree,"$main::Config{CEnv}{$main::Form{c}}{JavaScriptNavPath}");
	} else {
		print "\nRoot Folder Does nto Exist: $RootFolder";
		};	

};


##############################################################################
sub main::WriteTreeConfig
{

my($Reference) = $main::UserEnv{href} . "&rootpath=$main::Form{rootpath}&c=fbrowsermain&bfolder=";
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
	if (-e $main::Config{CEnv}{$main::Form{c}}{TreeTplJsPath})
	{
	my(@temp) = main::ReadFile($main::Config{CEnv}{$main::Form{c}}{TreeTplJsPath});
	my($ln) = undef;
	my($line) = undef;
		for ($ln = 0; $ln < (scalar @temp); $ln++)
		{
		$temp[$ln] =~ s!\'icons/!\'$main::Config{ImagesWebRoot}!i;
		};
	main::SaveFile($main::Config{CEnv}{$main::Form{c}}{JavaScriptNavTplPath},@temp);
	} else {
		print "CANNOT FIND: $main::Config{CEnv}{$main::Form{c}}{TreeTplJsPath}";
		};	
};

1;
