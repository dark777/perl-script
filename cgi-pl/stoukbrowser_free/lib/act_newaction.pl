sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
($SubDebug == 1) ? DebugOut("\$main::Form{newactionname} =  \"$main::Form{newactionname}\"") : 0;

		
	if ($main::Form{newactionname})
	{
	$main::Form{newactionname} = lc($main::Form{newactionname});
	unless (($main::Form{newactionname} =~ m!\s!) || !($main::Form{newactionname} =~ m!\w[\w\d]*!))
	{
	($SubDebug == 1) ? DebugOut("Processing \"$main::Form{newactionname}\"") : 0;
		unless (defined $ActConfig{$main::Form{newactionname}}) 
		{
		($SubDebug == 1) ? DebugOut("Creating New action key: \"$main::Form{newactionname}\"") : 0;	
		main::LoadLibrary("lib_newaction.pl");
			if (main::lib_newaction_createkeys($main::Form{newactionname}))
			{

####################################################################################################################
my($StrFile) =  $main::Config{sdb}{dbstruct}{commands};
my($DatabaseFile) =  $main::Config{sdb}{dbmain}{commands};
my($DatabaseFolder) =  $main::Config{sdb}{dbroot}{commands};
my($IndexLetter) = "t";
my($TableName) = "commands";
my($IndexID) = time;
####################################################################################################################
main::LoadLibrary("lib_sdbrecords.pl");
($SubDebug == 1) ? DebugOut("\$main::Form{newactionname} =  \"$main::Form{newactionname}\"") : 0;
$main::Form{f_id} = lc(main::lib_html_Escape($main::Form{newactionname}));
$main::Form{f_desc} = main::lib_html_Escape($main::Form{newactiondescription});
$main::Form{f_title} = "Action: $main::Form{f_id}";
$main::Form{f_help} = "Help: $main::Form{f_id}";
$main::Form{f_kernel} = "NO";
main::lib_sdbrecords_addrecord("$StrFile","$DatabaseFile","$DatabaseFolder","$IndexID","$IndexLetter");		
	
			
			($SubDebug == 1) ? DebugOut("OK - Created New Action!") : 0;
			} else {
				($SubDebug == 1) ? DebugOut("FAILED - could not Create New Action!") : 0;
			        $main::Html{newactionerror} = "<br><b>FAILED - could not Create New Action!</b><br>";
				};
				
		} else {
		
			($SubDebug == 1) ? DebugOut("This action key is already defined: \"$main::Form{newactionname}\"") : 0;			
			main::AddError("action-e00002","\"$main::Form{newactionname}\"");
			$main::Html{newactionerror} = "<br><b>FAILED: This action key is already defined: \"$main::Form{newactionname}\"</b><br>";
			};
	} else {
		main::AddError("action-e00001","\"$main::Form{newactionname}\"");
		($SubDebug == 1) ? DebugOut("FAILED: Incorrect parameter format: \"$main::Form{newactionname}\"") : 0;
		$main::Html{newactionerror} = "<br><b>FAILED: Incorrect parameter format: \"$main::Form{newactionname}\"</b><br>";
		};
	
		
	} else {
		
		};

};

sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($HtmlTemplateName)  = $main::Config{TtsSubFolders}{html} . $ActConfig{$main::Form{newactionname}}{htmltemplate}{name};
my($HFileTemplateName) = $main::Config{TtsSubFolders}{hfile} . $HConfig{$main::Form{newactionname}}{name};
my($LibTemplateName)   = $main::CWD . "lib/" . "act_"."$main::Form{newactionname}".".pl";
	if ($main::Config{newactionOK} == 1)
	{
	my($RedirectString) = main::lib_html_Redirect("$main::UserEnv{href}"."&c=adminmain");
	$main::Html{ServiceText} =~ s!<insert-redirect-adminmain>!$RedirectString!gis;
	};

	if ((-f $HtmlTemplateName) && (-f $HFileTemplateName) && (-f $LibTemplateName))
	{
	my($Links) = qq(
	<HR>
	

	$main::Html{newactionerror}
	<br>
<table style="width:100%; height:100; font-family:verdana,arial; font-size:8pt; background:#ffa">
		<tr>
		<td>
		<a href="$main::UserEnv{href}&c=$main::Form{newactionname}">$main::Form{newactionname}</a>
		</td>
		<td>
		<a href="$main::UserEnv{href}&c=pedit&pfile=hfile-$main::Form{newactionname}">Plain Edit: form $main::Form{newactionname}</a>
		</td>
		<td>
		<a href="$main::UserEnv{href}&c=pedit&pfile=js-$main::Form{newactionname}">Plain Edit: Java header $main::Form{newactionname}</a>
		</td>
		<td>
		<a href="$main::UserEnv{href}&c=pedit&pfile=css-$main::Form{newactionname}">Plain Edit: CSS header $main::Form{newactionname}</a>
		</td>
		<td>
		<a href="$main::UserEnv{href}&c=hedit&htfile=htfile-$main::Form{newactionname}">HTML Edit: HTML Template $main::Form{newactionname}</a>
		</td>
		<td>
		<a href="$main::UserEnv{href}&c=rmaction&rmaction=$main::Form{newactionname}">Delete $main::Form{newactionname}</a>
		</td>

		</tr>
		
</table>
	);
	$main::Html{ServiceText} =~ s![<_]insert-newaction-data[>_]!$Links!is;
	};

};








1;
