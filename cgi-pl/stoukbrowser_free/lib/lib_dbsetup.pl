####################################################################################################################
sub main::lib_wmsconfigenv
{
# Configure Root Folders
my(%temp) = undef;
$temp{config} = undef;
$main::Config{wms}{root} = $main::Config{DbFolder} . "pdb/";
unless (-e $main::Config{wms}{root}) {mkdir($main::Config{wms}{root},0777)}
$main::Config{wms}{dbroot} = $main::Config{wms}{root} . "db/";
unless (-e $main::Config{wms}{dbroot}) {mkdir($main::Config{wms}{dbroot},0777)}
$main::Config{wms}{jobroot} = $main::Config{wms}{root} . "job/";
unless (-e $main::Config{wms}{jobroot}) {mkdir($main::Config{wms}{jobroot},0777)}
$main::Config{wms}{jobsourceroot} = $main::Config{wms}{root} . "jobsource/";
unless (-e $main::Config{wms}{jobsourceroot}) {mkdir($main::Config{wms}{jobsourceroot},0777)}

$main::Config{wms}{approot} = $main::Config{wms}{root} . "app/";
unless (-e $main::Config{wms}{approot}) {mkdir($main::Config{wms}{approot},0777)}
$main::Config{wms}{srvroot} = $main::Config{wms}{root} . "srv/";
unless (-e $main::Config{wms}{srvroot}) {mkdir($main::Config{wms}{srvroot},0777)}
$main::Config{wms}{controot} = $main::Config{wms}{root} . "cont/";
unless (-e $main::Config{wms}{controot}) {mkdir($main::Config{wms}{controot},0777)}
$main::Config{wms}{contyperoot} = $main::Config{wms}{controot} . "type/";
unless (-e $main::Config{wms}{contyperoot}) {mkdir($main::Config{wms}{contyperoot},0777)}
$main::Config{wms}{docroot} = $main::Config{wms}{root} . "doc/";
unless (-e $main::Config{wms}{docroot}) {mkdir($main::Config{wms}{docroot},0777)}
$main::Config{wms}{docbin} = $main::Config{wms}{docroot} . "bin/";
unless (-e $main::Config{wms}{docbin}) {mkdir($main::Config{wms}{docbin},0777)}
$main::Config{wms}{docparseroot} = $main::Config{wms}{docroot} . "parse/";
unless (-e $main::Config{wms}{docparseroot}) {mkdir($main::Config{wms}{docparseroot},0777)}
# Configure User Root Folders
$main::Config{wms}{uroot} = $main::UserEnv{UEnvFolder} . "phb/";
unless (-e $main::Config{wms}{uroot}) {mkdir($main::Config{wms}{uroot},0777)}
# Configure XML FIles
# Configure User Environment
$main::Config{wms}{udb}{config} = $main::Config{wms}{uroot} . "conf.xml";
unless (-e $main::Config{wms}{udb}{config}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{udb}{config}")};
$main::Config{wms}{udb}{ind}{srv} = $main::Config{wms}{uroot} . "srv.ind";
$main::Config{wms}{udb}{ind}{app} = $main::Config{wms}{uroot} . "app.ind";
$main::Config{wms}{udb}{ind}{cont} = $main::Config{wms}{uroot} . "cont.ind";
$main::Config{wms}{udb}{ind}{contype} = $main::Config{wms}{uroot} . "contype.ind";
$main::Config{wms}{udb}{ind}{doc} = $main::Config{wms}{uroot} . "doc.ind";
$main::Config{wms}{udb}{ind}{job} = $main::Config{wms}{uroot} . "job.ind";
$main::Config{wms}{udb}{ind}{jobsource} = $main::Config{wms}{uroot} . "jobsource.ind";
$main::Config{wms}{uopt}{file} = $main::Config{wms}{uroot} . "opt.xml";
unless (-e $main::Config{wms}{uopt}{file}) {main::lib_wmsconfig_assigndefaultoptions();main::WriteIntConfig("config",$main::Config{wms}{opt},$main::Config{wms}{uopt}{file});};
if (-e $main::Config{wms}{uopt}{file}){my(%Tmp) = main::ReadIntConfig($main::Config{wms}{uopt}{file});$main::Config{wms}{opt} = \%Tmp;};

# Configure Databases
$main::Config{wms}{db}{srv} = $main::Config{wms}{dbroot} . "srv.xml";
unless (-e $main::Config{wms}{db}{srv}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{db}{srv}")};
$main::Config{wms}{db}{app} = $main::Config{wms}{dbroot} . "app.xml";
unless (-e $main::Config{wms}{db}{app}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{db}{app}")};
$main::Config{wms}{db}{cont} = $main::Config{wms}{dbroot} . "cont.xml";
unless (-e $main::Config{wms}{db}{cont}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{db}{cont}")};
$main::Config{wms}{db}{contype} = $main::Config{wms}{dbroot} . "contype.xml";
unless (-e $main::Config{wms}{db}{contype}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{db}{contype}")};
$main::Config{wms}{db}{doc} = $main::Config{wms}{dbroot} . "doc.xml";
unless (-e $main::Config{wms}{db}{doc}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{db}{doc}")};
$main::Config{wms}{db}{job} = $main::Config{wms}{dbroot} . "job.xml";
unless (-e $main::Config{wms}{db}{job}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{db}{job}")};
$main::Config{wms}{db}{jobsource} = $main::Config{wms}{dbroot} . "jobsource.xml";
unless (-e $main::Config{wms}{db}{jobsource}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{db}{jobsource}")};


# Configure Database Structure Files
$main::Config{wms}{dbstructfile}{srv} = $main::Config{wms}{srvroot} . "struct.xml";
unless (-e $main::Config{wms}{dbstructfile}{srv}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{dbstructfile}{srv}")};
$main::Config{wms}{dbstructfile}{app} = $main::Config{wms}{approot} . "struct.xml";
unless (-e $main::Config{wms}{dbstructfile}{app}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{dbstructfile}{app}")};
$main::Config{wms}{dbstructfile}{cont} = $main::Config{wms}{controot} . "struct.xml";
unless (-e $main::Config{wms}{dbstructfile}{cont}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{dbstructfile}{cont}")};
$main::Config{wms}{dbstructfile}{contype} = $main::Config{wms}{contyperoot} . "struct.xml";
unless (-e $main::Config{wms}{dbstructfile}{contype}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{dbstructfile}{contype}")};
$main::Config{wms}{dbstructfile}{doc} = $main::Config{wms}{docroot} . "struct.xml";
unless (-e $main::Config{wms}{dbstructfile}{doc}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{dbstructfile}{doc}")};
$main::Config{wms}{dbstructfile}{job} = $main::Config{wms}{jobroot} . "struct.xml";
unless (-e $main::Config{wms}{dbstructfile}{job}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{dbstructfile}{job}")};
$main::Config{wms}{dbstructfile}{jobsource} = $main::Config{wms}{jobsourceroot} . "struct.xml";
unless (-e $main::Config{wms}{dbstructfile}{jobsource}) {main::WriteIntConfig("config",\%temp,"$main::Config{wms}{dbstructfile}{jobsource}")};
};
####################################################################################################################
sub main::lib_wmsconfig_processcommand_afterstructure
{
my($StructureFile) =  $_[0];
my($String) = undef;
$String = $main::Config{wms}{errormessage} . $main::Config{wms}{message} . main::lib_wmsconfig_structform($StructureFile);	
return $String;
};
####################################################################################################################
sub main::lib_wmsconfig_processcommand_structure
{
my($StructureFile) =  $_[0];
	if ($main::Form{act} eq "delete")
	{
			if ($main::Form{Yes} eq "Yes")
			{
			main::lib_wmsconfig_deletestructfield($StructureFile,$main::Form{fid});
			} else {
				$main::Config{wms}{message} .= "<br>Are You sure you want to delete field  <b>$main::Form{fname}</b> ? <input type=\"hidden\" name=\"fid\" value=\"$main::Form{fid}\"/> <input type=\"hidden\" name=\"act\" value=\"delete\"/> <input type=\"submit\" name=\"Yes\" value=\"Yes\"/> <input type=\"submit\" name=\"No\" value=\"No\"/><br>";
					if ($main::Form{No} eq "No")
					{
					$main::Form{act} = undef;
					$main::Form{fid} = undef;
					$main::Form{fname} = undef;
					};
				};	
	};
	if ($main::Form{Add} eq "Add")
	{
		if (length($main::Form{nfname}) > 1)
		{
			if (length($main::Form{nftype}) > 1)
			{
				if (length($main::Form{nftitle}) > 1)
				{
					if (length($main::Form{nfnote}) > 1)
					{
					main::lib_wmsconfig_addnewstructfield($StructureFile,$main::Form{nfname},$main::Form{nftype},$main::Form{nftitle},$main::Form{nfnote},$main::Form{nunique},$main::Form{nrequired},$main::Form{nstatic});	
					} else {
						$main::Config{wms}{message} .= "ERROR: Please specify some notes, explaining this field...";
						};
				} else {
					$main::Config{wms}{message} .= "ERROR: Please specify title...";			
					};
			} else {
				$main::Config{wms}{message} .= "ERROR: Please specify field type...";			
				};
		} else {
			$main::Config{wms}{message} .= "ERROR: Please specify field name...";
			};	
	};	
};
####################################################################################################################
sub main::lib_wmsconfig_processcommand_afteredit
{
my($StructureFile) =  $_[0];
my($DatabaseFile) = $_[1];
my($DatabaseFolder) = $_[2];
my($IndexLetter) = $_[3];
my($TableName) = $_[4];		
my($String) = undef;

$String = $main::Config{wms}{errormessage} . $main::Config{wms}{message} . $main::Config{wms}{formtext};

	unless ($main::Config{wms}{SkipDisplay} == 1)
	{
	main::LoadLibrary("lib_wmsview.pl");

		if ($main::Form{Search} eq "Process Search")
		{
		main::LoadLibrary("lib_wmsearch.pl");
		$main::Config{wms}{SearchResultDatabaseFile} = $main::Config{wms}{uroot} . "searchresult". ".xml";
		if (-f $main::Config{wms}{SearchResultDatabaseFile}) {unlink($main::Config{wms}{SearchResultDatabaseFile})};
		main::lib_wmsearch_searchindexgenerate("$DatabaseFile");
		
			if (-f $main::Config{wms}{SearchResultDatabaseFile})
			{
			$String .= qq(
				<DIV style="font-family:verdana,arial;font-size=7pt">
				Found $main::Config{wms}{SearchResult} record(s)<br>
				Search took $main::Config{wms}{SearchTime} sec.
				</DIV>
					);
			$main::Form{SearchBrowse} = 1;
			$String .=  main::lib_wmsconfig_viewrecords("$StructureFile","$main::Config{wms}{SearchResultDatabaseFile}","$DatabaseFolder","search","$main::Form{c}","$TableName");		
			} else {

			$String .= qq(
				<DIV style="font-family:verdana,arial;font-size=7pt">
				No Records were found...<br>
				Search took $main::Config{wms}{SearchTime} sec.
				</DIV>
					);
				};
		} else {
			$main::Config{wms}{SearchResultDatabaseFile} = $main::Config{wms}{uroot} . "searchresult". ".xml";
			if (($main::Form{SearchBrowse} == 1) && (-f $main::Config{wms}{SearchResultDatabaseFile}))
			{
				unless (($main::Form{Mode} eq "Add Records") || ($main::Form{Mode} eq "Modify"))
				{
				main::LoadLibrary("lib_wmsview.pl");
				$String .= main::lib_wmsconfig_viewrecords("$StructureFile","$main::Config{wms}{SearchResultDatabaseFile}","$DatabaseFolder","search","$main::Form{c}","$TableName");
				};
			} else {
					unless (($main::Form{Mode} eq "Add Records") || ($main::Form{Mode} eq "Modify"))
					{
					main::LoadLibrary("lib_wmsview.pl");
					$String .= main::lib_wmsconfig_viewrecords("$StructureFile","$DatabaseFile","$DatabaseFolder","$TableName","$main::Form{c}","$TableName");
					};
				};
			};
	};
	
return $String;		
};

sub main::lib_wmsconfig_processcommand_afterview
{
my($StructureFile) =  $_[0];
my($DatabaseFile) = $_[1];
my($DatabaseFolder) = $_[2];
my($IndexLetter) = $_[3];
my($TableName) = $_[4];		
my($String) = undef;
	unless ($main::Config{wms}{SkipDisplay} == 1)
	{
	main::LoadLibrary("lib_wmsview.pl");
		if ($main::Form{Search} eq "Process Search")
		{
		main::LoadLibrary("lib_wmsearch.pl");
		main::lib_wmsearch_searchindexgenerate("$DatabaseFile");
			if (-f $main::Config{wms}{SearchResultDatabaseFile})
			{
			$String .= qq(
				<DIV style="font-family:verdana,arial;font-size=7pt">
				Found $main::Config{wms}{SearchResult} record(s)<br>
				Search took $main::Config{wms}{SearchTime} sec.
				</DIV>
					);
			$main::Form{SearchBrowse} = 1;
			$String .=  main::lib_wmsconfig_viewrecords("$StructureFile","$main::Config{wms}{SearchResultDatabaseFile}","$DatabaseFolder","search","","$TableName");		
			} else {

			$String .= qq(
				<DIV style="font-family:verdana,arial;font-size=7pt">
				No Records were found...<br>
				Search took $main::Config{wms}{SearchTime} sec.
				</DIV>
					);
				};
		} else {
			$main::Config{wms}{SearchResultDatabaseFile} = $main::Config{wms}{uroot} . "searchresult". ".xml";
			if (($main::Form{SearchBrowse} == 1) && (-f $main::Config{wms}{SearchResultDatabaseFile}))
			{
			$String =  main::lib_wmsconfig_viewrecords("$StructureFile","$main::Config{wms}{SearchResultDatabaseFile}","$DatabaseFolder","search","","$TableName");	
			} else {
				$String =  main::lib_wmsconfig_viewrecords("$StructureFile","$DatabaseFile","$DatabaseFolder","$TableName","","$TableName");	
				};
			};
	};
$String = $main::Config{wms}{message} . $String;	
return $String;	
};
####################################################################################################################
sub main::lib_wmsconfig_processcommands_view
{
my($StructureFile) =  $_[0];
my($DatabaseFile) = $_[1];
my($DatabaseFolder) = $_[2];
my($IndexLetter) = $_[3];
my($TableName) = $_[4];	
my($String) = undef;

$main::Config{wms}{message} .= qq(
<style><!--
a:link,.w,a.w:link,.w a:link{color:$main::Config{wms}{opt}{div}{tb_linkcolor}}
a:visited,.fl:visited{color:$main::Config{wms}{opt}{div}{tb_vislinkcolor}}
.t a:link,.t a:active,.t a:visited,.t{color:$main::Config{wms}{opt}{div}{tb_textcolor}}
div,td{color:$main::Config{wms}{opt}{div}{tb_textcolor}}
.f,.fl:link{color:$main::Config{wms}{opt}{div}{tb_textcolor}}
//-->
</style>
<center>
<DIV style=\"background:$main::Config{wms}{opt}{div}{tb_background}; color:$main::Config{wms}{opt}{div}{tb_textcolor}\">
);	

	if (length($main::Form{binview}) > 1)
	{
	main::LoadLibrary("lib_wmsfileview.pl");
	my($Reference) = main::lib_wmsconfig_checkdownload_bin($DatabaseFolder);

		if (defined $Reference)
		{
			$main::Config{wms}{message} .= "<br>If Download does not start automatically, click <a href=\"$Reference\">DOWNLOAD FILE</a> to download the file.<br></DIV>";
			$main::Config{wms}{SkipDisplay} = 1;
		} else {
			$main::Config{wms}{message} .= "<br>There was an error accesing the file you requested. Please contact administrator...<br></DIV>";
			};
	};

	if (length($main::Form{memoview}) > 1)
	{
	main::LoadLibrary("lib_wmsfileview.pl");
	my($Reference) = main::lib_wmsconfig_checkdownload_memo($DatabaseFolder);
		if (defined $Reference)
		{
			$main::Config{wms}{message} .= "<br>To View the file separately, click <a href=\"$Reference\">VIEW FILE</a><br>";
			$main::Config{wms}{message} .= "<textarea style=\"font-family:verdana,sans-serif,arial;font-soze:8pt\" cols=\"140\" rows=\"60\">$main::Config{wms}{memodata}</textarea></DIV>";
			$main::Config{wms}{SkipDisplay} = 1;
		} else {
			$main::Config{wms}{message} .= "<br>There was an error accesing the memo file you requested. Please contact administrator...<br></DIV>";
			};
	};
	
	if (length($main::Form{selectview}) > 1)
	{
	main::LoadLibrary("lib_wmsview.pl");
	main::LoadLibrary("lib_wmsfileview.pl");
	# my($Reference) = main::lib_wmsconfig_checkdownload_selectview($StructureFile,$DatabaseFile,$DatabaseFolder,$IndexLetter,$TableName);

	$main::Config{wms}{message} .= main::lib_wmsconfig_checkdownload_selectview($StructureFile,$DatabaseFile,$DatabaseFolder,$IndexLetter,$TableName);
	
	$main::Config{wms}{SkipDisplay} = 1;
	};
$main::Config{wms}{message} .= "</DIV>";
};

####################################################################################################################

####################################################################################################################
sub main::lib_wmsconfig_processcommands_edit
{
my($StructureFile) =  $_[0];
my($DatabaseFile) = $_[1];
my($DatabaseFolder) = $_[2];
my($IndexLetter) = $_[3];
my($temp) = undef;

$main::Config{wms}{message} .= qq(
<style><!--
a:link,.w,a.w:link,.w a:link{color:$main::Config{wms}{opt}{div}{tb_linkcolor}}
a:visited,.fl:visited{color:$main::Config{wms}{opt}{div}{tb_vislinkcolor}}
.t a:link,.t a:active,.t a:visited,.t{color:$main::Config{wms}{opt}{div}{tb_textcolor}}
div,td{color:$main::Config{wms}{opt}{div}{tb_textcolor}}
.f,.fl:link{color:$main::Config{wms}{opt}{div}{tb_textcolor}}
//-->
</style>
<center>
<DIV style=\"background:$main::Config{wms}{opt}{div}{tb_background}; color:$main::Config{wms}{opt}{div}{tb_textcolor}\">
);	
	if ($main::Form{Delete} eq "Delete Selected")
	{
	main::LoadLibrary("lib_wmsrecords.pl");
	main::lib_wmsconfig_deleterecords($StructureFile,$DatabaseFile,$DatabaseFolder);
	};

	if ($main::Form{Mode} eq "Add Records")
	{
	main::LoadLibrary("lib_wmsrecords.pl");
		if ($main::Form{indexid} > 0)
		{
		main::DebugOut("OK Adding New Data row... \"$main::Form{indexid}\"");
		main::lib_wmsconfig_addrecord($StructureFile,$DatabaseFile,$DatabaseFolder,$main::Form{indexid},"$IndexLetter");
		$main::Config{wms}{formtext} = main::lib_wmsconfig_addnewelementform($StructureFile);
			unless ($main::Config{wms}{errortrigger} > 0)
			{
			$main::Config{wms}{message} .= "<b>Added new data with ID: $main::Form{indexid}</b>";
			};
		
		} else {
			
			$main::Config{wms}{formtext} = main::lib_wmsconfig_addnewelementform($StructureFile);
			main::DebugOut("Displaying Add New Data form...");
			};
	};

	if ($main::Form{Mode} eq "Modify")
	{
	main::LoadLibrary("lib_wmsrecords.pl");
		if ($main::Form{"Update"} eq "Update Record")
		{
		main::DebugOut("OK Adding New Data row... \"$main::Form{indexid}\"");
			if ($main::Form{indexid} =~ m!\w(\d+)!)
			{
			$temp = $1;
			main::lib_wmsconfig_addrecord($StructureFile,$DatabaseFile,$DatabaseFolder,$temp,"$IndexLetter");
			$main::Config{wms}{formtext} = main::lib_wmsconfig_addnewelementform($StructureFile,$DatabaseFolder,$main::Form{indexid});
				unless ($main::Config{wms}{errortrigger} > 0)
				{
				$main::Config{wms}{message} = "<b>Updated data with ID: $main::Form{indexid}</b>";
				};
			} else {
				($SubDebug == 1) ? DebugOut("ERROR: Index ID is of incorrect format! \"$main::Form{indexid}\"") : 0;			
				};
		} else {
			if ($main::Form{indexid} =~ m!\w(\d+)!)
			{
			$temp = $1;	
			} else {
				$temp = "";
				};
			$main::Config{wms}{formtext} = main::lib_wmsconfig_addnewelementform($StructureFile,$DatabaseFolder,$main::Form{indexid},$temp);
			main::DebugOut("Displaying Modify Data form...");
			};
	};	


	if (length($main::Form{binview}) > 1)
	{
	main::LoadLibrary("lib_wmsfileview.pl");
	my($Reference) = main::lib_wmsconfig_checkdownload_bin($DatabaseFolder);
		if (defined $Reference)
		{
			$main::Config{wms}{message} .= "<br>If Download does not start automatically, click <a href=\"$Reference\">DOWNLOAD FILE</a> to download the file.<br>";
			$main::Config{wms}{SkipDisplay} = 1;
		} else {
			$main::Config{wms}{message} .= "<br>There was an error accesing the file you requested. Please contact administrator...<br>";
			};
	};

	if (length($main::Form{memoview}) > 1)
	{
	main::LoadLibrary("lib_wmsfileview.pl");
	my($Reference) = main::lib_wmsconfig_checkdownload_memo($DatabaseFolder);
		if (defined $Reference)
		{
			$main::Config{wms}{message} .= "<br>To View the file separately, click <a href=\"$Reference\">VIEW FILE</a><br>";
			$main::Config{wms}{message} .= "<textarea style=\"font-family:verdana,sans-serif,arial;font-soze:8pt\" cols=\"140\" rows=\"60\">$main::Config{wms}{memodata}</textarea>";
			$main::Config{wms}{SkipDisplay} = 1;
		} else {
			$main::Config{wms}{message} .= "<br>There was an error accesing the memo file you requested. Please contact administrator...<br>";
			};
	};
	
	if (length($main::Form{selectview}) > 1)
	{
	main::LoadLibrary("lib_wmsview.pl");
	main::LoadLibrary("lib_wmsfileview.pl");
	# my($Reference) = main::lib_wmsconfig_checkdownload_selectview($StructureFile,$DatabaseFile,$DatabaseFolder,$IndexLetter,$TableName);
	$main::Config{wms}{message} .= main::lib_wmsconfig_checkdownload_selectview($StructureFile,$DatabaseFile,$DatabaseFolder,$IndexLetter,$TableName);
	$main::Config{wms}{SkipDisplay} = 1;
	};
$main::Config{wms}{message} .= "</DIV>";	
};

sub main::lib_wmsconfig_assigndefaultoptions
{

$main::Config{wms}{opt}{div}{tb_border} = "0";
$main::Config{wms}{opt}{div}{tb_cpadding} = "1";
$main::Config{wms}{opt}{div}{tb_cspacing} = "0";
$main::Config{wms}{opt}{div}{tb_width} = "100%";
$main::Config{wms}{opt}{div}{tb_fontfamily} = "verdana,sans-serif,arial";
$main::Config{wms}{opt}{div}{tb_fontsize} = "8";
$main::Config{wms}{opt}{div}{tb_linkcolor} = "#EEEEEE";
$main::Config{wms}{opt}{div}{tb_vislinkcolor} = "#EEEEEE";
$main::Config{wms}{opt}{div}{tb_textcolor} = "#001133";
$main::Config{wms}{opt}{div}{tb_background} = "#6699CC";


$main::Config{wms}{opt}{view}{tb_border} = "0";
$main::Config{wms}{opt}{view}{tb_cpadding} = "1";
$main::Config{wms}{opt}{view}{tb_cspacing} = "0";
$main::Config{wms}{opt}{view}{tb_width} = "100%";
$main::Config{wms}{opt}{view}{tb_fontfamily} = "verdana,sans-serif,arial";
$main::Config{wms}{opt}{view}{tb_fontsize} = "8";
$main::Config{wms}{opt}{view}{tb_background} = "#33CC99";

$main::Config{wms}{opt}{search}{tb_border} = "0";
$main::Config{wms}{opt}{search}{tb_cpadding} = "0";
$main::Config{wms}{opt}{search}{tb_cspacing} = "0";
$main::Config{wms}{opt}{search}{tb_width} = "100%";
$main::Config{wms}{opt}{search}{tb_fontfamily} = "verdana,sans-serif,arial";
$main::Config{wms}{opt}{search}{tb_fontsize} = "7";
$main::Config{wms}{opt}{search}{tb_background} = "#33CC99";


$main::Config{wms}{opt}{navbar}{tb_border} = "0";
$main::Config{wms}{opt}{navbar}{tb_cpadding} = "0";
$main::Config{wms}{opt}{navbar}{tb_cspacing} = "0";
$main::Config{wms}{opt}{navbar}{tb_width} = "100%";
$main::Config{wms}{opt}{navbar}{tb_fontfamily} = "verdana,sans-serif,arial";
$main::Config{wms}{opt}{navbar}{tb_fontsize} = "7";
$main::Config{wms}{opt}{navbar}{tb_background} = "#3399CC";
	
	
};

1;