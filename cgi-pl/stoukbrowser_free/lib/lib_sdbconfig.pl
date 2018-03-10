sub  main::lib_sdbconfig_configenvironment
{
# Configure Root Folders
my($SubDebug) = $main::SubID{lib_sdbconfig_configenvironment}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($temp) = undef;
my($key) = undef;
my(%opt) = undef;

$main::Config{sdb}{root} = $main::Config{DbFolder} . "sdb/";
unless (-e $main::Config{sdb}{root}) {mkdir($main::Config{sdb}{root},0777)}
$main::Config{sdb}{uroot} = $main::UserEnv{UEnvFolder} . "sdb/";
unless (-e $main::Config{sdb}{uroot}) {mkdir($main::Config{sdb}{uroot},0777)}
$main::Config{sdb}{rootconfig} = $main::Config{sdb}{root} . "sdb.cgi";
unless (-e $main::Config{sdb}{rootconfig}) {main::WriteIntConfig("config","<config>\n</config>","$main::Config{sdb}{rootconfig}")};
$main::Config{sdbconfig}{opt}{file} = $main::Config{sdb}{root} . "opt.cgi";
$main::Config{sdbconfig}{uopt}{file} = $main::Config{sdb}{uroot} . "opt.cgi";
$main::Config{sdbconfig}{imagetempfolder} = $main::Config{ImagesRoot} . "sdbtemp/";
$main::Config{sdbconfig}{imagetempwebfolder} = $main::Config{ImagesWebRoot} . "sdbtemp/";
unless (-e $main::Config{sdbconfig}{imagetempfolder}) {mkdir($main::Config{sdbconfig}{imagetempfolder},0777)}

unless (-e $main::Config{sdbconfig}{opt}{file})
{
main::lib_sdbconfig_assigndefaultoptions();
main::WriteIntConfig("config",$main::Config{sdb}{opt},$main::Config{sdbconfig}{opt}{file});
main::WriteIntConfig("config",$main::Config{sdb}{opt},$main::Config{sdbconfig}{uopt}{file});
} else {
		unless (-e $main::Config{sdbconfig}{uopt}{file})
		{
		%opt = main::ReadIntConfig($main::Config{sdbconfig}{opt}{file});
		$main::Config{sdb}{opt} = \%opt;
		main::WriteIntConfig("config",$main::Config{sdb}{opt},$main::Config{sdbconfig}{uopt}{file});	
		} else {
			%opt = main::ReadIntConfig($main::Config{sdbconfig}{uopt}{file});
			$main::Config{sdb}{opt} = \%opt;
			};
	};
if ($main::Config{sdb}{opt}{div}{tb_border} < 1) {$main::Config{sdb}{opt}{div}{tb_border} = 0};
if ($main::Config{sdb}{opt}{view}{tb_border} < 1) {$main::Config{sdb}{opt}{view}{tb_border} = 0};
if ($main::Config{sdb}{opt}{search}{tb_border} < 1) {$main::Config{sdb}{opt}{search}{tb_border} = 0};
if ($main::Config{sdb}{opt}{navbar}{tb_border} < 1) {$main::Config{sdb}{opt}{navbar}{tb_border} = 0};

$main::Config{sdb}{udb}{config} = $main::Config{sdb}{uroot} . "ucfg.cgi";unless (-e $main::Config{sdb}{udb}{config}) {main::WriteIntConfig("config",\%opt,"$main::Config{sdb}{udb}{config}")};

my(%Temp) = undef;


	if (-f $main::Config{sdb}{rootconfig})
	{
	
	%Temp = main::ReadIntConfig($main::Config{sdb}{rootconfig});	
	$main::Config{sdb}{rootlist} = \%Temp;
		foreach $key (keys %{$main::Config{sdb}{rootlist}})
		{
		# $main::Config{sdb}{message}{ok} .= "<br>checking if defined : \$main::Config{sdb}{rootlist}{$key}{name}  - $main::Config{sdb}{rootlist}{$key}{name}";
			if (defined $main::Config{sdb}{rootlist}{$key}{name})
			{
			
				if ((-f ($main::Config{sdb}{root} . "$main::Config{sdb}{rootlist}{$key}{name}/"."private.cgi")) && ($main::UserEnv{name} ne "administrator") )
				{
				$main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{root} . "$main::Config{sdb}{rootlist}{$key}{name}/";	
				unless (-e $main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}}) {mkdir($main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}},0777)}
				# ($SubDebug == 1) ? DebugOut("DATABASE ROOT: \$main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}}") : 0;
				$main::Config{sdb}{dbmain}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}} . "$main::Config{sdb}{rootlist}{$key}{name}" . ".cgi";	
				unless (-e $main::Config{sdb}{dbmain}{$main::Config{sdb}{rootlist}{$key}{name}}) {main::WriteIntConfig("config","<config></config>","$main::Config{sdb}{dbmain}{$main::Config{sdb}{rootlist}{$key}{name}}")};
				# ($SubDebug == 1) ? DebugOut("DATABASE FILE: \$main::Config{sdb}{dbmain}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{dbmain}{$main::Config{sdb}{rootlist}{$key}{name}}") : 0;
				$main::Config{sdb}{dbstruct}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}} . "struct". ".cgi";
				unless (-e $main::Config{sdb}{dbstruct}{$main::Config{sdb}{rootlist}{$key}{name}}) {main::WriteIntConfig("config","<config></config>","$main::Config{sdb}{dbstruct}{$main::Config{sdb}{rootlist}{$key}{name}}")};
				# ($SubDebug == 1) ? DebugOut("STRUCTURE FILE: \$main::Config{sdb}{dbstruct}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{dbstruct}{$main::Config{sdb}{rootlist}{$key}{name}}") : 0;
				$main::Config{sdb}{udb}{ind}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{uroot} . "$main::Config{sdb}{rootlist}{$key}{name}".".cgi";
				unless (-e $main::Config{sdb}{udb}{ind}{$main::Config{sdb}{rootlist}{$key}{name}}) {main::WriteIntConfig("config","<config></config>","$main::Config{sdb}{udb}{ind}{$main::Config{sdb}{rootlist}{$key}{name}}")};
				# ($SubDebug == 1) ? DebugOut("USER INDEX: \$main::Config{sdb}{udb}{ind}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{udb}{ind}{$main::Config{sdb}{rootlist}{$key}{name}}") : 0;
				$main::Config{sdb}{udbroot}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{uroot} . "$main::Config{sdb}{rootlist}{$key}{name}/";	
					unless (-e $main::Config{sdb}{udbroot}{$main::Config{sdb}{rootlist}{$key}{name}}) 
					{
					mkdir($main::Config{sdb}{udbroot}{$main::Config{sdb}{rootlist}{$key}{name}},0777);
					main::CopyStructure($main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}},$main::Config{sdb}{udbroot}{$main::Config{sdb}{rootlist}{$key}{name}});
					}
				# Assigning Private Database Entries.
				$main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{uroot} . "$main::Config{sdb}{rootlist}{$key}{name}/";	
				$main::Config{sdb}{dbmain}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}} . "$main::Config{sdb}{rootlist}{$key}{name}" . ".cgi";	
				$main::Config{sdb}{dbstruct}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}} . "struct". ".cgi";
				$main::Config{sdb}{udb}{ind}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{uroot} . "$main::Config{sdb}{rootlist}{$key}{name}".".cgi";
				} else {
					$main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{root} . "$main::Config{sdb}{rootlist}{$key}{name}/";	
					unless (-e $main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}}) {mkdir($main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}},0777)}
					# ($SubDebug == 1) ? DebugOut("DATABASE ROOT: \$main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}}") : 0;
					$main::Config{sdb}{dbmain}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}} . "$main::Config{sdb}{rootlist}{$key}{name}" . ".cgi";	
					unless (-e $main::Config{sdb}{dbmain}{$main::Config{sdb}{rootlist}{$key}{name}}) {main::WriteIntConfig("config","<config></config>","$main::Config{sdb}{dbmain}{$main::Config{sdb}{rootlist}{$key}{name}}")};
					# ($SubDebug == 1) ? DebugOut("DATABASE FILE: \$main::Config{sdb}{dbmain}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{dbmain}{$main::Config{sdb}{rootlist}{$key}{name}}") : 0;
					$main::Config{sdb}{dbstruct}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{dbroot}{$main::Config{sdb}{rootlist}{$key}{name}} . "struct". ".cgi";
					unless (-e $main::Config{sdb}{dbstruct}{$main::Config{sdb}{rootlist}{$key}{name}}) {main::WriteIntConfig("config","<config></config>","$main::Config{sdb}{dbstruct}{$main::Config{sdb}{rootlist}{$key}{name}}")};
					# ($SubDebug == 1) ? DebugOut("STRUCTURE FILE: \$main::Config{sdb}{dbstruct}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{dbstruct}{$main::Config{sdb}{rootlist}{$key}{name}}") : 0;
					$main::Config{sdb}{udb}{ind}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{uroot} . "$main::Config{sdb}{rootlist}{$key}{name}".".cgi";
					unless (-e $main::Config{sdb}{udb}{ind}{$main::Config{sdb}{rootlist}{$key}{name}}) {main::WriteIntConfig("config","<config></config>","$main::Config{sdb}{udb}{ind}{$main::Config{sdb}{rootlist}{$key}{name}}")};
					# ($SubDebug == 1) ? DebugOut("USER INDEX: \$main::Config{sdb}{udb}{ind}{$main::Config{sdb}{rootlist}{$key}{name}} = $main::Config{sdb}{udb}{ind}{$main::Config{sdb}{rootlist}{$key}{name}}") : 0;
					};

			};
		};
	};

	
	
};

sub main::lb_sdbconfig_readconfig
{
my($StructureFile) = $_[0];
my($DatabaseFile) = $_[1];
my($IndexField) = $_[2];
unless ($IndexField) {$IndexField = "f_id"};
$SubDebug = 1;
my($key) = undef;
my(@StructureName) = undef;
my($sc) = undef;
my($totalfields) = undef;
my($i) = undef;
my(%Temp) = undef;
my(%Result) = undef;

		if (-f $StructureFile)
		{
		%Structure = main::ReadIntConfig($StructureFile);
				foreach $key (sort keys %Structure)
				{
					if (defined $Structure{$key}{type})
					{
					# ($SubDebug == 1) ? DebugOut("Defined Field Name: $Structure{$key}{name}") : 0;			
					$StructureName[$sc] = $Structure{$key}{name};
					$sc++;
					};
				};

			$totalfields = scalar @StructureName;
			
			if (-e $DatabaseFile)
			{
			%Temp = main::ReadIntConfig($DatabaseFile);
			# ($SubDebug == 1) ? DebugOut("OK - Database file exists...") : 0;
				foreach $key (keys %Temp)
				{
					if (defined $key)
					{
						
					# ($SubDebug == 1) ? DebugOut("Key: $key is defined - OK") : 0;
					
						for ($i = 0; $i < $totalfields ; $i++)
						{
							if (defined $Temp{$key}{$IndexField})
							{
							$Result{$Temp{$key}{$IndexField}}{$StructureName[$i]} = $Temp{$key}{$StructureName[$i]};
							$main::Config{sdb}{ReadConfig}{$key}{$StructureName[$i]} = $Temp{$key}{$StructureName[$i]};
							# ($SubDebug == 1) ? DebugOut("ASSIGNING: \$Result{$Temp{$key}{$IndexField}}{$StructureName[$i]} = $Result{$Temp{$key}{$IndexField}}{$StructureName[$i]}") : 0;
							} else {
								($SubDebug == 1) ? DebugOut("ERROR: Index field is not defined: \$Result{$Temp{$key}{$IndexField}}{$StructureName[$i]} = $Result{$Temp{$key}{$IndexField}}{$StructureName[$i]}") : 0;
								};
						};							
					};
				};
				
			} else {
				($SubDebug == 1) ? DebugOut("ERROR: Structure File does not exist! \$StructureFile = $StructureFile") : 0;
				};
				
		
		} else {
			($SubDebug == 1) ? DebugOut("ERROR: Structure File does not exist! \$StructureFile = $StructureFile") : 0;
			};
	
return %Result;
};

####################################################################################################################
sub main::lib_sdbconfig_processcommand_afterstructure
{
my($StructureFile) =  $_[0];
my($DatabaseFile) = $_[1];
my($DatabaseFolder) = $_[2];
my($String) = undef;
$String = $main::Config{sdb}{message}{error} . $main::Config{sdb}{message}{ok} . main::lib_sdbstructure_structform($StructureFile,$StructureFile,$DatabaseFolder);	
return $String;
};
####################################################################################################################

####################################################################################################################
sub main::lib_sdbconfig_processcommand_structure
{
my($StructureFile) =  $_[0];
my($DatabaseFile) = $_[1];
my($DatabaseFolder) = $_[2];

$main::Config{sdb}{EmailFlag} = $StructureFile . "."."email";
$main::Config{sdb}{PrivateFlag} = $DatabaseFolder . "private.cgi";

my($SubDebug) = $main::SubID{lib_sdbconfig_processcommand_structure}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;


($SubDebug == 1) ? DebugOut("\$main::Config{sdb}{EmailFlag} = $main::Config{sdb}{EmailFlag}") : 0;
($SubDebug == 1) ? DebugOut("\$main::Config{sdb}{PrivateFlag} = $main::Config{sdb}{PrivateFlag}") : 0;

	if ($main::Form{private} eq "private")
	{
	main::SaveFile($main::Config{sdb}{PrivateFlag},"");
	$main::Config{sdb}{PrivateFlagEnabled} = 1;
	} else {
			if ((-e $main::Config{sdb}{PrivateFlag}) && ($main::Form{deleteprivate} == 1) )
			{
			unlink($main::Config{sdb}{PrivateFlag});	
			};		
			if (-e $main::Config{sdb}{PrivateFlag})
			{
			$main::Config{sdb}{PrivateFlagEnabled} = 1;
			} else {
				$main::Config{sdb}{PrivateFlagEnabled} = 0;
				};
		};

	if ($main::Form{emailupdate} =~ m!@!)
	{
	$main::Form{emailupdate} =~ s!\s+!!gis;
	$main::Form{emailupdate} =~ s!\n!!gis;
	main::SaveFile($main::Config{sdb}{EmailFlag},"$main::Form{emailupdate}");
	$main::Config{sdb}{EmailFlagList} = $main::Form{emailupdate};	
	$main::Config{sdb}{EmailFlagEnabled} = 1;
	} else {
		
			if ((-e $main::Config{sdb}{EmailFlag}) && ($main::Form{deleteemailupdate} == 1))
			{
			unlink($main::Config{sdb}{EmailFlag});	
			};		
			
			if (-e $main::Config{sdb}{EmailFlag})
			{
			$main::Config{sdb}{EmailFlagEnabled} = 1;	
			$main::Config{sdb}{EmailFlagList} = join("",(main::ReadFile($main::Config{sdb}{EmailFlag})));
			} else {
				$main::Config{sdb}{EmailFlagEnabled} = 0;
				$main::Config{sdb}{EmailFlagList} = "";
				};
		};

	if ($main::Form{act} eq "delete")
	{
			if ($main::Form{Yes} eq "Yes")
			{
			main::lib_sdbstructure_deletestructfield($StructureFile,$main::Form{fid});
			} else {
				$main::Config{sdb}{message}{ok} .= "<br>Are You sure you want to delete field  <b>$main::Form{fname}</b> ? <input type=\"hidden\" name=\"fid\" value=\"$main::Form{fid}\"/> <input type=\"hidden\" name=\"act\" value=\"delete\"/> <input type=\"submit\" name=\"Yes\" value=\"Yes\"/> <input type=\"submit\" name=\"No\" value=\"No\"/><br>";
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
					main::lib_sdbstructure_addnewstructfield($StructureFile,$main::Form{nfname},$main::Form{nftype},$main::Form{nftitle},$main::Form{nfnote},$main::Form{nunique},$main::Form{nrequired},$main::Form{nstatic},$main::Form{nownerlock});	
					} else {
						$main::Config{sdb}{message}{error} .= "ERROR: Please specify some notes, explaining this field...";
						};
				} else {
					$main::Config{sdb}{message}{error} .= "ERROR: Please specify title...";			
					};
			} else {
				$main::Config{sdb}{message}{error} .= "ERROR: Please specify field type...";			
				};
		} else {
			$main::Config{sdb}{message}{error} .= "ERROR: Please specify field name...";
			};	
	};	
};
####################################################################################################################

####################################################################################################################
sub main::lib_sdbconfig_processcommand_afteredit
{
my($StructureFile) =  $_[0];
my($DatabaseFile) = $_[1];
my($DatabaseFolder) = $_[2];
my($IndexLetter) = $_[3];
my($TableName) = $_[4];		
my($String) = undef;
my($SubDebug) = $main::SubID{lib_sdbconfig_processcommand_afteredit}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

$String = $main::Config{sdb}{message}{error} . $main::Config{sdb}{message}{ok} . $main::Config{sdb}{formtext};

	unless ($main::Config{sdb}{SkipDisplay} == 1)
	{
	main::LoadLibrary("lib_sdbview.pl");
	($SubDebug == 1) ? DebugOut("Loaded Library: lib_sdbview.pl") : 0;
	
		if ($main::Form{Search} eq "Process Search")
		{
		main::LoadLibrary("lib_sdbsearch.pl");
		$main::Config{sdb}{SearchResultDatabaseFile} = $main::Config{sdb}{uroot} . "searchresult". ".cgi";
		if (-f $main::Config{sdb}{SearchResultDatabaseFile}) {unlink($main::Config{sdb}{SearchResultDatabaseFile})};
		main::lib_sdbsearch_searchindexgenerate("$DatabaseFile",$StructureFile);
		
			if (-f $main::Config{sdb}{SearchResultDatabaseFile})
			{
			$String .= qq(
				<DIV style="font-family:verdana,arial;font-size=7pt">
				$main::Config{sdb}{searchstring}<br>
				Found $main::Config{sdb}{SearchResult} record(s)<br>
				Search took $main::Config{sdb}{SearchTime} sec.
				</DIV>
					);
			$main::Form{SearchBrowse} = 1;
			$String .=  main::lib_sdbview_viewrecords("$StructureFile","$main::Config{sdb}{SearchResultDatabaseFile}","$DatabaseFolder","search","$main::Form{c}","$TableName");		
			} else {

			$String .= qq(
				<DIV style="font-family:verdana,arial;font-size=7pt">
				$main::Config{sdb}{searchstring}<br>
				No Records were found...<br>
				Search took $main::Config{sdb}{SearchTime} sec.
				</DIV>
					);
				};
		} else {
			$main::Config{sdb}{SearchResultDatabaseFile} = $main::Config{sdb}{uroot} . "searchresult". ".cgi";
			
			if (($main::Form{SearchBrowse} == 1) && (-f $main::Config{sdb}{SearchResultDatabaseFile}))
			{
				unless (($main::Form{Mode} eq "Add Records") || ($main::Form{Mode} eq "Modify"))
				{
				main::LoadLibrary("lib_sdbview.pl");
				$String .= main::lib_sdbview_viewrecords("$StructureFile","$main::Config{sdb}{SearchResultDatabaseFile}","$DatabaseFolder","search","$main::Form{c}","$TableName");
				};
			} else {
					unless (($main::Form{Mode} eq "Add Records") || ($main::Form{Mode} eq "Modify"))
					{
					main::LoadLibrary("lib_sdbview.pl");
					($SubDebug == 1) ? DebugOut("Loaded Library: lib_sdbview.pl") : 0;
					$String .= main::lib_sdbview_viewrecords("$StructureFile","$DatabaseFile","$DatabaseFolder","$TableName","$main::Form{c}","$TableName");
					};
				};
			};
	};
	
return $String;		
};

sub main::lib_sdbconfig_processcommand_afterview
{
my($StructureFile) =  $_[0];
my($DatabaseFile) = $_[1];
my($DatabaseFolder) = $_[2];
my($IndexLetter) = $_[3];
my($TableName) = $_[4];		
my($String) = undef;
	unless ($main::Config{sdb}{SkipDisplay} == 1)
	{
	main::LoadLibrary("lib_sdbview.pl");
		if ($main::Form{Search} eq "Process Search")
		{
		main::LoadLibrary("lib_sdbsearch.pl");
		main::lib_sdbsearch_searchindexgenerate("$DatabaseFile",$StructureFile);
			if (-f $main::Config{sdb}{SearchResultDatabaseFile})
			{
			$String .= qq(
				<DIV style="font-family:verdana,arial;font-size=7pt">
				$main::Config{sdb}{searchstring}<br>
				Found $main::Config{sdb}{SearchResult} record(s)<br>
				Search took $main::Config{sdb}{SearchTime} sec.
				</DIV>
					);
			$main::Form{SearchBrowse} = 1;
			$String .=  main::lib_sdbview_viewrecords("$StructureFile","$main::Config{sdb}{SearchResultDatabaseFile}","$DatabaseFolder","search","","$TableName");		
			} else {

			$String .= qq(
				<DIV style="font-family:verdana,arial;font-size=7pt">
				$main::Config{sdb}{searchstring}<br>
				No Records were found...<br>
				Search took $main::Config{sdb}{SearchTime} sec.
				</DIV>
					);
				};
		} else {
			$main::Config{sdb}{SearchResultDatabaseFile} = $main::Config{sdb}{uroot} . "searchresult". ".cgi";
			if (($main::Form{SearchBrowse} == 1) && (-f $main::Config{sdb}{SearchResultDatabaseFile}))
			{
			$String =  main::lib_sdbview_viewrecords("$StructureFile","$main::Config{sdb}{SearchResultDatabaseFile}","$DatabaseFolder","search","","$TableName");	
			} else {
				$String =  main::lib_sdbview_viewrecords("$StructureFile","$DatabaseFile","$DatabaseFolder","$TableName","","$TableName");	
				};
			};
	};
$String = $main::Config{sdb}{message}{error} . $main::Config{sdb}{message}{ok} . $String;	
return $String;	
};
####################################################################################################################

sub main::lib_sdbconfig_processcommands_view
{
my($StructureFile) =  $_[0];
my($DatabaseFile) = $_[1];
my($DatabaseFolder) = $_[2];
my($IndexLetter) = $_[3];
my($TableName) = $_[4];	
my($String) = undef;

	if (length($main::Form{binview}) > 1)
	{
	main::LoadLibrary("lib_sdbspecview.pl");
	my($Reference) = main::lib_sdbspecview_checkdownload_bin($DatabaseFolder);

	$main::Config{sdb}{message}{ok} .= qq(
	<style><!--
	a:link,.w,a.w:link,.w a:link{color:$main::Config{sdb}{opt}{div}{tb_linkcolor}}
	a:visited,.fl:visited{color:$main::Config{sdb}{opt}{div}{tb_vislinkcolor}}
	.t a:link,.t a:active,.t a:visited,.t{color:$main::Config{sdb}{opt}{div}{tb_textcolor}}
	div,td{color:$main::Config{sdb}{opt}{div}{tb_textcolor}}
	.f,.fl:link{color:$main::Config{sdb}{opt}{div}{tb_textcolor}}
	//-->
	</style>
	<center>
	<DIV style=\"background:$main::Config{sdb}{opt}{div}{tb_background}; color:$main::Config{sdb}{opt}{div}{tb_textcolor}\">
	);
		if (defined $Reference)
		{
			$main::Config{sdb}{message}{ok} .= "<br>If Download does not start automatically, click <a href=\"$Reference\">DOWNLOAD FILE</a> to download the file.<br></DIV>";
			$main::Config{sdb}{message}{ok} .= main::lib_html_Redirect($Reference);
			$main::Config{sdb}{SkipDisplay} = 1;
		} else {
			$main::Config{sdb}{message}{ok} .= "<br>There was an error accesing the file you requested. Please contact administrator...<br></DIV>";
			};
	};

	if (length($main::Form{imageview}) > 1)
	{
	main::LoadLibrary("lib_sdbspecview.pl");
	my($Reference) = main::lib_sdbspecview_checkdownload_image($DatabaseFolder);

	$main::Config{sdb}{message}{ok} .= qq(
	<style><!--
	a:link,.w,a.w:link,.w a:link{color:$main::Config{sdb}{opt}{div}{tb_linkcolor}}
	a:visited,.fl:visited{color:$main::Config{sdb}{opt}{div}{tb_vislinkcolor}}
	.t a:link,.t a:active,.t a:visited,.t{color:$main::Config{sdb}{opt}{div}{tb_textcolor}}
	div,td{color:$main::Config{sdb}{opt}{div}{tb_textcolor}}
	.f,.fl:link{color:$main::Config{sdb}{opt}{div}{tb_textcolor}}
	//-->
	</style>
	<center>
	<DIV style=\"background:$main::Config{sdb}{opt}{div}{tb_background}; color:$main::Config{sdb}{opt}{div}{tb_textcolor}\">
	);
		if (defined $Reference)
		{
			$main::Config{sdb}{message}{ok} .= "<br>If Image View does not start, click <a href=\"$Reference\">View Image</a> to View.<br></DIV>";
			$main::Config{sdb}{message}{ok} .= main::lib_html_Redirect($Reference);
			$main::Config{sdb}{SkipDisplay} = 1;
		} else {
			$main::Config{sdb}{message}{ok} .= "<br>There was an error accesing the file you requested. Please contact administrator...<br></DIV>";
			};
	};
	
	if (length($main::Form{memoview}) > 1)
	{
	main::LoadLibrary("lib_sdbspecview.pl");
	my($Reference) = main::lib_sdbspecview_checkdownload_memo($DatabaseFolder);
		if (defined $Reference)
		{
			$main::Config{sdb}{message}{ok} .= "<br>To View the file separately, click <a href=\"$Reference\">VIEW FILE</a><br>";
			$main::Config{sdb}{message}{ok} .= "<textarea style=\"width:100%;font-family:verdana,sans-serif,arial;font-size:8pt\" rows=\"60\" wrap=\"off\">".$main::Config{sdb}{memodata}."</textarea></DIV>";
			$main::Config{sdb}{SkipDisplay} = 1;
		} else {
			$main::Config{sdb}{message}{error} .= "<br>There was an error accesing the memo file you requested. Please contact administrator...<br></DIV>";
			};
	};
	
	if (length($main::Form{selectview}) > 1)
	{
	main::LoadLibrary("lib_sdbview.pl");
	main::LoadLibrary("lib_sdbspecview.pl");

	$main::Config{sdb}{message}{ok} .= main::lib_sdbspecview_checkdownload_selectview($StructureFile,$DatabaseFile,$DatabaseFolder,$IndexLetter,$TableName);
	$main::Config{sdb}{SkipDisplay} = 1;
	};

};

####################################################################################################################


sub main::lib_sdbconfig_processcommands_edit
{
my($StructureFile) =  $_[0];
my($DatabaseFile) = $_[1];
my($DatabaseFolder) = $_[2];
my($IndexLetter) = $_[3];
my($temp) = undef;

my($SubDebug) = $main::SubID{lib_sdbconfig_processcommands_edit}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Processing Edit Commands: $StructureFile") : 0;

					$main::Config{sdb}{emailtriggerfile} = $StructureFile . "."."email";
					
					$main::Config{sdb}{databaseid} = $DatabaseFolder;
					$main::Config{sdb}{databaseid} =~ s!\\!/!gi;
					if ($main::Config{sdb}{databaseid} =~ m!.*/(\w+)/$!)
					{
					$main::Config{sdb}{databaseid} = $1;	
					};
					
					if (-e $main::Config{sdb}{emailtriggerfile})
					{
					$main::Config{sdb}{emailtrigger} = join("",(main::ReadFile($main::Config{sdb}{emailtriggerfile})));
					$main::Config{sdb}{emailtrigger} =~ s!\n!!gis;
					$main::Config{sdb}{emailtrigger} =~ s!\s+!!gis;
					};

	if ($main::Form{Delete} eq "Delete Selected")
	{
	main::LoadLibrary("lib_sdbrecords.pl");
	main::lib_sdbrecords_deleterecords($StructureFile,$DatabaseFile,$DatabaseFolder);
	};

	if ($main::Form{Mode} eq "Add Records")
	{
	main::LoadLibrary("lib_sdbrecords.pl");
		if ($main::Form{indexid} > 0)
		{
		main::DebugOut("OK Adding New Data row... \"$main::Form{indexid}\"");
		main::lib_sdbrecords_addrecord($StructureFile,$DatabaseFile,$DatabaseFolder,$main::Form{indexid},"$IndexLetter");
		$main::Config{sdb}{formtext} = main::lib_sdbrecords_addnewelementform($StructureFile);
			unless ($main::Config{sdb}{errortrigger} > 0)
			{
			$main::Config{sdb}{message}{ok} .= "<b>Added new data with ID: $main::Form{indexid}</b>";
			

				if ((-e $main::Config{sdb}{emailtriggerfile}) && ($main::Form{confirmemailalert} == 1))
				{
					my(@emails) = split(";",$main::Config{sdb}{emailtrigger});
					my($email) = undef;
					foreach $email (@emails)
					{
						if (defined $email)
						{
						main::lib_email_send($main::UserEnv{name},$email,"New Record Added","FYI, \nI added new record with ID: $main::Form{indexid} to Database: $main::Config{sdb}{databaseid}. \nPlease check.\n\n$main::UserEnv{name}\n\nDETAILS:\n\n$main::Config{sdb}{UpdatedDataRecord}");	
						};
					};
				};
			
			};
		
		} else {
			
			$main::Config{sdb}{formtext} = main::lib_sdbrecords_addnewelementform($StructureFile);
			main::DebugOut("Displaying Add New Data form...");
			};
	};

	if ($main::Form{Mode} eq "Modify")
	{
	main::LoadLibrary("lib_sdbrecords.pl");
		if ($main::Form{"Update"} eq "Update Record")
		{
		main::DebugOut("OK Adding New Data row... \"$main::Form{indexid}\"");
			if ($main::Form{indexid} =~ m!\w(\d+)!)
			{
			$temp = $1;
			main::lib_sdbrecords_addrecord($StructureFile,$DatabaseFile,$DatabaseFolder,$temp,"$IndexLetter");
			$main::Config{sdb}{formtext} = main::lib_sdbrecords_addnewelementform($StructureFile,$DatabaseFolder,$main::Form{indexid},$temp);
				unless ($main::Config{sdb}{errortrigger} > 0)
				{
				$main::Config{sdb}{message}{ok} = "<b>Updated data with ID: $main::Form{indexid}</b>";
				
	
					main::DebugOut("Checking if exists: $main::Config{sdb}{emailtriggerfile}. Database: $main::Config{sdb}{databaseid} ");
					if ((-e $main::Config{sdb}{emailtriggerfile}) && ($main::Form{confirmemailalert} == 1))
					{
						my(@emails) = split(";",$main::Config{sdb}{emailtrigger});
						my($email) = undef;
						main::DebugOut("\@emails = @emails");
						foreach $email (@emails)
						{
							
							if (defined $email)
							{
							main::DebugOut("Sending notification to: $email...");
							main::lib_email_send($main::UserEnv{name},$email,"Record Updated!","FYI, \nI updated record with ID: $main::Form{indexid} in Database: $main::Config{sdb}{databaseid}. \nPlease check.\n\n$main::UserEnv{name}\n\nDETAILS:\n\n$main::Config{sdb}{UpdatedDataRecord}");	
							};
						};
					};

				
				
				
				};
			} else {
				($SubDebug == 1) ? DebugOut("ERROR: Index ID is of incorrect format! \"$main::Form{indexid}\"") : 0;			
				};
		} else {
			main::DebugOut("\$main::Form{indexid} = $main::Form{indexid}");
			if ($main::Form{indexid} =~ m!\w(\d+)!)
			{
			$temp = $1;	
			} else {
				$temp = "";
				};
			main::DebugOut("\$temp = $temp");
			$main::Config{sdb}{formtext} = main::lib_sdbrecords_addnewelementform($StructureFile,$DatabaseFolder,$main::Form{indexid},$temp);
			main::DebugOut("Displaying Modify Data form...");
			};
	};	


	if (length($main::Form{binview}) > 1)
	{
	main::LoadLibrary("lib_sdbspecview.pl");
	my($Reference) = main::lib_sdbspecview_checkdownload_bin($DatabaseFolder);
		if (defined $Reference)
		{
			$main::Config{sdb}{message}{ok} .= "<br>If Download does not start automatically, click <a href=\"$Reference\">DOWNLOAD FILE</a> to download the file.<br>";
			$main::Config{sdb}{SkipDisplay} = 1;
		} else {
			$main::Config{sdb}{message}{ok} .= "<br>There was an error accesing the file you requested. Please contact administrator...<br>";
			};
	};

	if (length($main::Form{imageview}) > 1)
	{
	main::LoadLibrary("lib_sdbspecview.pl");
	my($Reference) = main::lib_sdbspecview_checkdownload_image($DatabaseFolder);
		if (defined $Reference)
		{
			$main::Config{sdb}{message}{ok} .= "<br>If IMage View does not start automatically, click <a href=\"$Reference\">View Image File</a> to view the image.<br>";
			$main::Config{sdb}{message}{ok} .= main::lib_html_Redirect($Reference);
			$main::Config{sdb}{SkipDisplay} = 1;
		} else {
			$main::Config{sdb}{message}{ok} .= "<br>There was an error accesing the file you requested. Please contact administrator...<br>";
			};
	};

	if (length($main::Form{memoview}) > 1)
	{
	main::LoadLibrary("lib_sdbspecview.pl");
	my($Reference) = main::lib_sdbspecview_checkdownload_memo($DatabaseFolder);
		if (defined $Reference)
		{
			$main::Config{sdb}{message}{ok} .= "<br>To View the file separately, click <a href=\"$Reference\">VIEW FILE</a><br>";
			$main::Config{sdb}{message}{ok} .= "<textarea style=\"width:100%; font-family:verdana,sans-serif,arial;font-size:8pt\" cols=\"180\" rows=\"60\" wrap=\"off\">$main::Config{sdb}{memodata}</textarea>";
			$main::Config{sdb}{SkipDisplay} = 1;
		} else {
			$main::Config{sdb}{message}{ok} .= "<br>There was an error accesing the memo file you requested. Please contact administrator...<br>";
			};
	};
	
	if (length($main::Form{selectview}) > 1)
	{
	main::LoadLibrary("lib_sdbview.pl");
	main::LoadLibrary("lib_sdbspecview.pl");

	$main::Config{sdb}{message}{ok} .= main::lib_sdbspecview_checkdownload_selectview($StructureFile,$DatabaseFile,$DatabaseFolder,$IndexLetter,$TableName);
	$main::Config{sdb}{SkipDisplay} = 1;
	};
	
};


sub main::lib_sdbconfig_assigndefaultoptions
{

$main::Config{sdb}{opt}{div}{tb_border} = "1";
$main::Config{sdb}{opt}{div}{tb_cpadding} = "1";
$main::Config{sdb}{opt}{div}{tb_cspacing} = "0";
$main::Config{sdb}{opt}{div}{tb_width} = "100%";
$main::Config{sdb}{opt}{div}{tb_fontfamily} = "verdana,sans-serif,arial";
$main::Config{sdb}{opt}{div}{tb_fontsize} = "8";
$main::Config{sdb}{opt}{div}{tb_linkcolor} = "#EEEEEE";
$main::Config{sdb}{opt}{div}{tb_vislinkcolor} = "#EEEEEE";
$main::Config{sdb}{opt}{div}{tb_textcolor} = "#001133";
$main::Config{sdb}{opt}{div}{tb_background} = "#6699CC";


$main::Config{sdb}{opt}{view}{tb_border} = "1";
$main::Config{sdb}{opt}{view}{tb_cpadding} = "1";
$main::Config{sdb}{opt}{view}{tb_cspacing} = "0";
$main::Config{sdb}{opt}{view}{tb_width} = "100%";
$main::Config{sdb}{opt}{view}{tb_fontfamily} = "verdana,sans-serif,arial";
$main::Config{sdb}{opt}{view}{tb_fontsize} = "8";
$main::Config{sdb}{opt}{view}{tb_background} = "#33CC99";

$main::Config{sdb}{opt}{search}{tb_border} = "1";
$main::Config{sdb}{opt}{search}{tb_cpadding} = "0";
$main::Config{sdb}{opt}{search}{tb_cspacing} = "0";
$main::Config{sdb}{opt}{search}{tb_width} = "100%";
$main::Config{sdb}{opt}{search}{tb_fontfamily} = "verdana,sans-serif,arial";
$main::Config{sdb}{opt}{search}{tb_fontsize} = "7";
$main::Config{sdb}{opt}{search}{tb_background} = "#33CC99";


$main::Config{sdb}{opt}{navbar}{tb_border} = "1";
$main::Config{sdb}{opt}{navbar}{tb_cpadding} = "0";
$main::Config{sdb}{opt}{navbar}{tb_cspacing} = "0";
$main::Config{sdb}{opt}{navbar}{tb_width} = "100%";
$main::Config{sdb}{opt}{navbar}{tb_fontfamily} = "verdana,sans-serif,arial";
$main::Config{sdb}{opt}{navbar}{tb_fontsize} = "7";
$main::Config{sdb}{opt}{navbar}{tb_background} = "#3399CC";
};

1;
