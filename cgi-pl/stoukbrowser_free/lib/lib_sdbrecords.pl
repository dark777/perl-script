####################################################################################################################
sub main::lib_sdbrecords_deleterecords
{
my($StructureFile) = $_[0];
my($DatabaseFile) = $_[1];
my($RecordsFolder) = $_[2];
my($SubDebug) = $main::SubID{lib_sdbrecords_deleterecords}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Deleting Records") : 0;
my(%Data) = undef;
my($key) = undef;
my(%Data) = undef;
my(%UpdatedData) = undef;
my($temp) = undef;
my(%DeleteKeys) = undef;
my($MemoPath) = $RecordsFolder . "memo/";
unless (-e $MemoPath) {mkdir($MemoPath,0777)}
my($BinPath) = $RecordsFolder . "bin/";
unless (-e $BinPath) {mkdir($BinPath,0777)}
my($ImagePath) = $RecordsFolder . "image/";
unless (-e $ImagePath) {mkdir($ImagePath,0777)}
my($memotemp) = undef;
my($bintemp) = undef;
my(%RecordData) = undef;
my($TypeKey) = undef;

        foreach $key (keys %main::Form)
        {
        ($SubDebug == 1) ? DebugOut("Checking $key = $main::Form{$key}") : 0;
            if ($key =~ m!^DELETE(.*)!)
            {
                $DeleteKeys{$1} = $1;
                ($SubDebug == 1) ? DebugOut("Marked to Delete key: $DeleteKeys{$1}") : 0;
            };
        };
                if ((-f $DatabaseFile) && (-d $RecordsFolder))
                {
                %Data = main::ReadIntConfig($DatabaseFile);
                # Identify Unique fields
                    foreach $key (keys %Data)
                    {
                        if (defined $key)
                        {
                            if($key eq $DeleteKeys{$key})
                            {
                            
                            my($RecordIndexFile) = $RecordsFolder . "$key" . ".cgi";
                            
                                if (-f $RecordIndexFile)
                                {
                                %RecordData = main::ReadIntConfig($RecordIndexFile);
                                    foreach $TypeKey (keys %RecordData)
                                    {
                                        if (defined $RecordData{$TypeKey}{type})
                                        {
                                        $memotemp = $MemoPath . "$key";
                                        if (-e $memotemp) {unlink($memotemp)};
                                        $memotemp = $MemoPath . "$key"."."."$RecordData{$TypeKey}{name}";
                                        if (-e $memotemp) {unlink($memotemp)};
                                        
                                        $bintemp = $BinPath . "$key";
                                        if (-e $bintemp) {unlink($bintemp)};
                                        $bintemp = $BinPath . "$key"."."."$RecordData{$TypeKey}{name}";
                                        if (-e $bintemp) {unlink($bintemp)};
                                        
					$imagetemp = $ImagePath . "$key";
                                        if (-e $imagetemp) {unlink($imagetemp)};
                                        $imagetemp = $ImagePath . "$key"."."."$RecordData{$TypeKey}{name}";
                                        if (-e $imagetemp) {unlink($imagetemp)};
                                                                                
                                            if (-e $RecordIndexFile)
                                            {
                                            unlink($RecordIndexFile);    
                                            };
                                        };
                                    };
                                unlink($RecordIndexFile);
                                } else {
                                    ($SubDebug == 1) ? DebugOut("ERROR: Records file does not exist already!") : 0;
                                    };
                            ($SubDebug == 1) ? DebugOut("DELETING: $key and records file: \"$RecordIndexFile\"") : 0;    
                            } else {
                                $UpdatedData{$key} = $Data{$key};
                                };
                        };
                    };                
                ($SubDebug == 1) ? DebugOut("Updated Data file: \"$DatabaseFile\"") : 0;
                main::WriteIntConfig("config",\%UpdatedData,$DatabaseFile);
                };
};


####################################################################################################################
sub main::lib_sdbrecords_deleterecordswhere
{
my($StructureFile) = $_[0];
my($DatabaseFile) = $_[1];
my($RecordsFolder) = $_[2];
my($WhereField) = $_[3];
my($WhereRecord) = $_[4];
my($SubDebug) = $main::SubID{lib_sdbrecords_deleterecords}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Deleting Records") : 0;
my(%Data) = undef;
my($key) = undef;
my(%Data) = undef;
my(%UpdatedData) = undef;
my($temp) = undef;
my(%DeleteKeys) = undef;
my($MemoPath) = $RecordsFolder . "memo/";
unless (-e $MemoPath) {mkdir($MemoPath,0777)}
my($BinPath) = $RecordsFolder . "bin/";
unless (-e $BinPath) {mkdir($BinPath,0777)}
my($memotemp) = undef;
my($bintemp) = undef;
my($imagetemp) = undef;
my(%RecordData) = undef;
my($TypeKey) = undef;

                if ((-f $DatabaseFile) && (-d $RecordsFolder))
                {
                %Data = main::ReadIntConfig($DatabaseFile);
                # Identify Unique fields
                    foreach $key (keys %Data)
                    {
                        if ((defined $key) && (defined $Data{$key}{$WhereField}) )
                        {
                            if (($Data{$key}{$WhereField} =~ m!^$WhereRecord$!i) && (defined $WhereRecord))
                            {
                            
                            my($RecordIndexFile) = $RecordsFolder . "$key" . ".cgi";
                            
                                if (-f $RecordIndexFile)
                                {
                                %RecordData = main::ReadIntConfig($RecordIndexFile);
                                    foreach $TypeKey (keys %RecordData)
                                    {
                                        if (defined $RecordData{$TypeKey}{type})
                                        {
                                        $memotemp = $MemoPath . "$key";
                                        if (-e $memotemp) {unlink($memotemp)};
                                        $memotemp = $MemoPath . "$key"."."."$RecordData{$TypeKey}{name}";
                                        if (-e $memotemp) {unlink($memotemp)};
                                        $bintemp = $BinPath . "$key";
                                        if (-e $bintemp) {unlink($bintemp)};
                                        $bintemp = $BinPath . "$key"."."."$RecordData{$TypeKey}{name}";
                                        if (-e $bintemp) {unlink($bintemp)};
                                            if (-e $RecordIndexFile)
                                            {
                                            unlink($RecordIndexFile);    
                                            };
                                        };
                                    };
                                unlink($RecordIndexFile);
                                } else {
                                    ($SubDebug == 1) ? DebugOut("ERROR: Records file does not exist already!") : 0;
                                    };
                            ($SubDebug == 1) ? DebugOut("DELETING: $key and records file: \"$RecordIndexFile\"") : 0;    
                            } else {
                                $UpdatedData{$key} = $Data{$key};
                                };
                        };
                    };                
                ($SubDebug == 1) ? DebugOut("Updated Data file: \"$DatabaseFile\"") : 0;
                main::WriteIntConfig("config",\%UpdatedData,$DatabaseFile);
                };
};


####################################################################################################################
sub main::lib_sdbrecords_addnewelementform
{
my($dbstructurefile) = $_[0];
my($RecordsFolder) = $_[1];
my($IndexID) = $_[2];
my($DataIndexID) = $_[3];
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
($SubDebug == 1) ? DebugOut("\$DataIndexID = $DataIndexID") : 0;
                
my($RecordIndexFile) = $RecordsFolder . "$IndexID" . ".cgi";
my($SubDebug) = $main::SubID{lib_sdbrecords_addnewelementform}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Processing: $dbstructurefile") : 0;
my(%Data) = undef;
my(%StructureData) = undef;
my($String) = undef;
my($key) = undef;
my(%RecordData) = undef;
my($MemoPath) = $RecordsFolder . "memo/";
unless (-e $MemoPath) {mkdir($MemoPath,0777)};
my($BinPath) = $RecordsFolder . "bin/";
unless (-e $BinPath) {mkdir($BinPath,0777)};
my($temp) = undef;
($SubDebug == 1) ? DebugOut("\$MemoPath = $MemoPath") : 0;
my(%ViewOpt) = undef;

$String .= qq(
<style><!--
a:link,.w,a.w:link,.w a:link{color:$main::Config{sdb}{opt}{div}{tb_linkcolor}}
a:visited,.fl:visited{color:$main::Config{sdb}{opt}{div}{tb_vislinkcolor}}
.t a:link,.t a:active,.t a:visited,.t{color:$main::Config{sdb}{opt}{div}{tb_textcolor}}
div,td{color:$main::Config{sdb}{opt}{div}{tb_textcolor}}
.f,.fl:link{color:$main::Config{sdb}{opt}{div}{tb_textcolor}}
//-->
</style>
);
    if (-f $main::Config{sdb}{udb}{config})
    {
    %ViewOption =     main::ReadIntConfig($main::Config{sdb}{udb}{config});
    };

    if ($main::Form{Modify} == "1")
    {
        if (-f $RecordIndexFile)
        {
        %RecordData = main::ReadIntConfig($RecordIndexFile);        
        } else {
            ($SubDebug == 1) ? DebugOut("ERROR Record File Does Not exist!") : 0;
            };
    };

    if (-f $dbstructurefile)
    {
    %StructureData = main::ReadIntConfig($dbstructurefile);
$String .= "\n<DIV style=\"background:$main::Config{sdb}{opt}{div}{tb_background}; color:$main::Config{sdb}{opt}{div}{tb_textcolor}\"><center><table BORDER=\"$main::Config{sdb}{opt}{view}{tb_border}\" CELLPADDING=\"$main::Config{sdb}{opt}{view}{tb_cpadding}\" CELLSPACING=\"$main::Config{sdb}{opt}{view}{tb_cspacing}\" style=\"width:$main::Config{sdb}{opt}{view}{tb_width}; font-family:$main::Config{sdb}{opt}{view}{tb_fontfamily}; font-size:$main::Config{sdb}{opt}{view}{tb_fontsize}pt; background:$main::Config{sdb}{opt}{view}{tb_background}; color:$main::Config{sdb}{opt}{view}{tb_color};\">";
# $String .= "<table cellpadding=1 cellspacing=0 border=1 style=\"width:900; font-family:verdana,arial; font-size:8pt; background:#aef\">";    

$String .= "<tr style=\"font-family:verdana,arial; font-size:8pt; background:#cdf\">";

$String .= "<td style=\"width:20%;\">";
$String .= "<b>Field Name:</b>";
$String .= "</td>";

$String .= "<td style=\"width:80%;\">";
$String .= "<b>Enter Data:</b>";
$String .= "</td>";

$String .= "</tr>";

        foreach $key (sort keys %StructureData)
        {

            if (defined $StructureData{$key}{type})
            {
            $String .= "<tr>";
            $String .= "<td style=\"width:15%;\">";
            my($AddChar) = undef;
            if ($StructureData{$key}{required})
            {
            $AddChar = "*";
            };            

            if ($StructureData{$key}{unique})
            {
            $AddChar .= "!";
            };            

            if ($StructureData{$key}{static})
            {
            $AddChar .= "x";
            };            

            $String .= "<b><font size=+1>$AddChar</font> $StructureData{$key}{title}</b>";
            $String .= "</td>";
            
            $String .= "<td align=\"left\" style=\"width:85%;\">";
            if (($StructureData{$key}{static} == 1) && ($RecordData{$StructureData{$key}{name}} ne $main::Form{$StructureData{$key}{name}})) {$main::Form{$StructureData{$key}{name}} = $RecordData{$StructureData{$key}{name}}};
            
            
                if ($StructureData{$key}{type} eq "text")
                {
                $String .= main::lib_sdbrecords_gettypeform_text($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});
                } elsif ($StructureData{$key}{type} eq "memo")
                {
                ($SubDebug == 1) ? DebugOut("\$DataIndexID = $DataIndexID") : 0;
                
                $temp = $MemoPath . "t".$DataIndexID . "." . "$StructureData{$key}{name}";
                    if (-f $temp) 
                    {
                    $RecordData{$StructureData{$key}{name}} = join("",main::ReadFile($temp))
                    } else {
                        main::DebugOut("ERROR: Memo file does not exist! \"$temp\"");
                        };
                $String .= main::lib_sdbrecords_gettypeform_memo($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});    
                } elsif ($StructureData{$key}{type} eq "bin")
                {
                $String .= main::lib_sdbrecords_gettypeform_bin($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});    
                } elsif ($StructureData{$key}{type} eq "number")
                {
                $String .= main::lib_sdbrecords_gettypeform_number($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});    
                } elsif ($StructureData{$key}{type} =~ m!^Link!i)
                {
                $String .= main::lib_sdbrecords_gettypeform_link($StructureData{$key}{name},$main::Form{MultipleFormValuesFromSingleFormField}{$StructureData{$key}{name}}{0},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note},$StructureData{$key}{type});        
                } elsif($StructureData{$key}{type} eq "dtyear")
                {
                $String .= main::lib_sdbrecords_gettypeform_year($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});        
                } elsif ($StructureData{$key}{type} eq "dtmonth")
                {
                $String .= main::lib_sdbrecords_gettypeform_month($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});    
                } elsif ($StructureData{$key}{type} eq "dtdate")
                {
                $String .= main::lib_sdbrecords_gettypeform_date($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});                        
                } elsif ($StructureData{$key}{type} eq "dthour")
                {
                $String .= main::lib_sdbrecords_gettypeform_hour($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});    
                } elsif ($StructureData{$key}{type} eq "dtminute")
                {
                $String .= main::lib_sdbrecords_gettypeform_minute($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});        
                } elsif ($StructureData{$key}{type} eq "dtsecond")
                {
                $String .= main::lib_sdbrecords_gettypeform_second($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});            
                } elsif ($StructureData{$key}{type} eq "dtwday")
                {
                $String .= main::lib_sdbrecords_gettypeform_wday($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});                
                } elsif ($StructureData{$key}{type} eq "email")
                {
                $String .= main::lib_sdbrecords_gettypeform_email($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});                    
                } elsif ($StructureData{$key}{type} eq "phone")
                {
                $String .= main::lib_sdbrecords_gettypeform_phone($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});                    
                } elsif ($StructureData{$key}{type} eq "webaddress")
                {
                $String .= main::lib_sdbrecords_gettypeform_webaddress($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});                    
                } elsif ($StructureData{$key}{type} eq "timestamp")
                {
                $String .= main::lib_sdbrecords_gettypeform_timestamp($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});                    
                } elsif ($StructureData{$key}{type} eq "id")
                {
                $RecordData{$StructureData{$key}{name}}    = $DataIndexID;            
                $String .= main::lib_sdbrecords_gettypeform_id($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});                        
                } elsif ($StructureData{$key}{type} eq "userautoinsert")
                {
                $String .= main::lib_sdbrecords_gettypeform_autouser($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});                            
                } elsif ($StructureData{$key}{type} eq "yn")
                {
                $String .= main::lib_sdbrecords_gettypeform_yn($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});                                
                } elsif ($StructureData{$key}{type} eq "image")
                {
                $String .= main::lib_sdbrecords_gettypeform_image($StructureData{$key}{name},$main::Form{$StructureData{$key}{name}},$RecordData{$StructureData{$key}{name}},$StructureData{$key}{note});    	
                };
            $String .= "</td>";
            $String .= "</tr>";
            };

        };


$String .= "</table>";    

if (-e $main::Config{sdb}{emailtriggerfile}) 
{
my($TextStr) = "<br> Send E-Mail Notification:";
my($TextStr2) = " (".substr($main::Config{sdb}{emailtrigger},0,128)."...) <br>";

	if ($main::Form{confirmemailalert} == 1)
	{
	$String = "$TextStr <input type=\"checkbox\" name=\"confirmemailalert\" value=\"1\" CHECKED/> $TextStr2" . $String;
	} else {
	$String = "$TextStr <input type=\"checkbox\" name=\"confirmemailalert\" value=\"1\" /> $TextStr2" . $String;
		};
};
    
$String .= "<input type=\"hidden\" name=\"addelement\" value=\"addelement\"/>";        
my($IndexID) = undef;

my($AddRecordString) = undef;

$AddRecordString .= "<br> <a href=\"$main::UserEnv{href}&c=$main::Form{c}\" style=\"color:#fff; background:#111; font-family:verdana,arial; font-size:8pt\">Edit Mode</a> &nbsp&nbsp&nbsp";

    unless (($main::Form{Modify} == "1") && ($main::Form{indexid} =~ m!\w(\d*)!))
    {
    $IndexID = main::lib_time_gettime(11);        
    $AddRecordString .= "<input type=\"Submit\" name=\"Add Record\" value=\"Add Record\"/>";    
    $AddRecordString .= "<input type=\"Submit\" name=\"Refresh Links\" value=\"Refresh Links\"/>";
    } else {
        $IndexID = $main::Form{indexid};
        $AddRecordString .= "<input type=\"Submit\" name=\"Update\" value=\"Update Record\"/>";    
        $AddRecordString .= "<input type=\"Submit\" name=\"Refresh Links\" value=\"Refresh Links\"/>";        
        };
        
$String .= "<input type=\"hidden\" name=\"indexid\" value=\"$IndexID\"/>";
$String .= "<input type=\"hidden\" name=\"Mode\" value=\"$main::Form{Mode}\"/>";
$String .= "<input type=\"hidden\" name=\"Modify\" value=\"$main::Form{Modify}\"/>";
$String .= "</DIV>";
$String = $AddRecordString . $String . $AddRecordString;
return $String;

    } else {
        main::DebugOut("ERROR: Structure file does not exist! \"$dbstructurefile\"");
        return 0;
        };

};

####################################################################################################################
sub main::lib_sdbrecords_addrecord
{
my($StructureFile) = $_[0];
my($DatabaseFile) = $_[1];
my($RecordsFolder) = $_[2];
my($IndexID) = $_[3];
my($IndexLetter) = lc($_[4]);
my($SubDebug) = $main::SubID{lib_sdbrecords_addrecord}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Adding or Modifying Record to \"$StructureFile\"") : 0;
my(%Data) = undef;
my(%StructureData) = undef;
my($String) = undef;
my($key) = undef;
my($subkey) = undef;
my(%Structure) = undef;
my(%Data) = undef;
my(%RecordData) = undef;
my($ContinueProcess) = undef;
my(%Unique) = undef;
my($MemoPath) = $RecordsFolder . "memo/";
unless (-e $MemoPath) {mkdir($MemoPath,0777)}
my($BinPath) = $RecordsFolder . "bin/";
unless (-e $BinPath) {mkdir($BinPath,0777)}
my($ImagePath) = $RecordsFolder . "image/";
unless (-e $ImagePath) {mkdir($ImagePath,0777)}


my($RecordIndex) = undef;
my($RecordIndexFile) = undef;

my($key1) = undef;
my($subkey1) = undef;

    if ($IndexID > 0)
    {
        if ($IndexLetter =~ m!^\w$!)
        {
        $RecordIndex = "$IndexLetter". "$IndexID";
        $RecordIndexFile = $RecordsFolder . "$IndexLetter". "$IndexID" . ".cgi";
        ($SubDebug == 1) ? DebugOut("\$RecordIndex = $RecordIndex") : 0;
        
            if (-f $StructureFile)
            {
            %Structure = main::ReadIntConfig($StructureFile);
                if ((-f $DatabaseFile) && (-d $RecordsFolder))
                {
                %Data = main::ReadIntConfig($DatabaseFile);
                # Identify Unique fields
                    foreach $key (keys %Structure)
                    {

                        if (defined $Structure{$key}{type})
                        {

                            if ($Structure{$key}{unique} == 1)
                            {
                                foreach $subkey (keys %Data)
                                {
                                    if (defined $Data{$subkey}{$Structure{$key}{name}})
                                    {
                                    # ($SubDebug == 1) ? DebugOut("Assigning Unique Key: \$Data{$subkey}{$Structure{$key}{name}} = $Data{$subkey}{$Structure{$key}{name}}") : 0;
                                    $Unique{$Structure{$key}{name}}{$Data{$subkey}{$Structure{$key}{name}}} = 1;
                                    # ($SubDebug == 1) ? DebugOut("\$Unique{$Structure{$key}{name}}{$Data{$subkey}{$Structure{$key}{name}}} = $Unique{$Structure{$key}{name}}{$Data{$subkey}{$Structure{$key}{name}}}") : 0;
                                    };
                                };
                            };

                                if ($Structure{$key}{fstatic} == 1)
                                {
                                ($SubDebug == 1) ? DebugOut("STATIC FIELD... checking the length of \$Data{$RecordIndex}{$Structure{$key}{name}} = $Data{$RecordIndex}{$Structure{$key}{name}}") : 0;
                                    if ((defined $key) && (defined $Data{$RecordIndex}{$Structure{$key}{name}}) && (length($RecordIndex) > 0))
                                    {
                                    # ($SubDebug == 1) ? DebugOut("ASSIGNING STATIC VALUE: \$main::Form{$Structure{$key}{name}} = $main::Form{$Structure{$key}{name}}") : 0;
                                    $main::Form{$Structure{$key}{name}} = $Data{$RecordIndex}{$Structure{$key}{name}};    
                                    # ($SubDebug == 1) ? DebugOut("ASSIGNING STATIC VALUE: \$main::Form{$Structure{$key}{name}} = $main::Form{$Structure{$key}{name}}") : 0;
                                    };
                                };


                        };                    
                    };                    
                # Process Input
                $main::Config{sdb}{UpdatedDataRecord} = undef;
                
                    foreach $key (keys %Structure)
                    {
                        if (defined $Structure{$key}{type})
                        {
                        $ContinueProcess = 1;
                        # Checking if required...
                        if ($Structure{$key}{required} == 1)
                        {
                            unless (length($main::Form{$Structure{$key}{name}}) > 0)
                            {
                            $ContinueProcess = 0;
                            ($SubDebug == 1) ? DebugOut("ERROR: Discontinue Record Adding because data not provided for required field: \"$Structure{$key}{name}\" <> $main::Form{$Structure{$key}{name}}") : 0;
                            $main::Config{sdb}{errortrigger}++;
                            $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} = "<br><b>Field \"$Structure{$key}{title}\" should have data! There was no data provided!";
                            };
                        };

                        ($SubDebug == 1) ? DebugOut("Checking if this is a unique field: \$Structure{$key}{unique} = $Structure{$key}{unique}") : 0;
                        if ($Structure{$key}{unique} == 1)
                        {
                            if ($Unique{$Structure{$key}{name}}{$main::Form{$Structure{$key}{name}}} == 1)
                            {
                            ($SubDebug == 1) ? DebugOut("Checking if this data belongs to the same ID: \$Data{$main::Form{indexid}}{$Structure{$key}{name}} if eq $Data{$main::Form{indexid}}{$Structure{$key}{name}}") : 0;
                            ($SubDebug == 1) ? DebugOut("\$main::Form{$Structure{$key}{name}} if eq $main::Form{$Structure{$key}{name}}") : 0;
                                unless ($Data{$main::Form{indexid}}{$Structure{$key}{name}} eq $main::Form{$Structure{$key}{name}})
                                {
                                $ContinueProcess = 0;
                                ($SubDebug == 1) ? DebugOut("ERROR: Discontinue Record Adding because data not unique in field: \"$Structure{$key}{title}\". This record already exists!") : 0;
                                $main::Config{sdb}{errortrigger}++;
                                $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} = "Discontinue Record Adding because data not unique in field: \"$Structure{$key}{title}\". This record already exists!";
                                };
                            };                                
                        };

                            if ($ContinueProcess == 1)
                            {
            
                                if ($Structure{$key}{type} eq "text")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_text($main::Form{$Structure{$key}{name}},$Structure{$key}{required});
                                } elsif ($Structure{$key}{type} eq "memo")
                                {
                                ($SubDebug == 1) ? DebugOut("Adding/Updating Memo record: $RecordIndex . $Structure{$key}{name} ") : 0;
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_memo($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$MemoPath,("$RecordIndex"."."."$Structure{$key}{name}"));    
                                } elsif ($Structure{$key}{type} eq "bin")
                                {
                                    ($SubDebug == 1) ? DebugOut("PROCESSING BINARY: \$main::Form{$Structure{$key}{name}} = $main::Form{$Structure{$key}{name}} and  \$Data{$RecordIndex}{$Structure{$key}{name}} = $Data{$RecordIndex}{$Structure{$key}{name}}") : 0;
                                    if (length($main::Form{$Structure{$key}{name}}) > 5)
                                    {
                                    ($SubDebug == 1) ? DebugOut("Uploading File...") : 0;
                                    $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_bin($Structure{$key}{name},$Structure{$key}{required},$BinPath,("$RecordIndex"."."."$Structure{$key}{name}"));    
                                    } else {
                                        if (defined $Data{$RecordIndex}{$Structure{$key}{name}})
                                        {
                                        $RecordData{$Structure{$key}{name}} = $Data{$RecordIndex}{$Structure{$key}{name}};
                                        ($SubDebug == 1) ? DebugOut("Retaining file ...\$RecordData{$Structure{$key}{name}} = $RecordData{$Structure{$key}{name}}") : 0;
                                        } else {
                                            ($SubDebug == 1) ? DebugOut("Binary file not defined: \"$Data{$RecordIndex}{$Structure{$key}{name}}\"") : 0;
                                            };
                                        };
                                
                                } elsif ($Structure{$key}{type} eq "number")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_number($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});    
                                } elsif ($Structure{$key}{type} =~ m!^Link!i)
                                {
                                my(@Joined) = join(",",$main::Form{$Structure{$key}{name}});
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_link($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{type},$Structure{$key}{name},$Structure{$key}{type});    
                                ($SubDebug == 1) ? DebugOut("\$RecordData{$Structure{$key}{name}} = \"$RecordData{$Structure{$key}{name}}\"") : 0;
                                } elsif ($Structure{$key}{type} eq "dtyear")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_year($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});        
                                } elsif ($Structure{$key}{type} eq "dtmonth")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_month($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});            
                                } elsif ($Structure{$key}{type} eq "dtdate")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_date($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});                                            
                                } elsif ($Structure{$key}{type} eq "dthour")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_hour($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});
                                } elsif ($Structure{$key}{type} eq "dtsecond")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_second($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});        
                                } elsif ($Structure{$key}{type} eq "dtminute")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_minute($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});            
                                } elsif ($Structure{$key}{type} eq "dtwday")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_wday($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});
                                } elsif ($Structure{$key}{type} eq "phone")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_phone($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});    
                                } elsif ($Structure{$key}{type} eq "email")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_email($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});
                                } elsif ($Structure{$key}{type} eq "webaddress")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_webaddress($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});
                                } elsif ($Structure{$key}{type} eq "timestamp")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_timestamp($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});
                                } elsif ($Structure{$key}{type} eq "id")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_id($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});    
                                } elsif ($Structure{$key}{type} eq "userautoinsert")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_autouser($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});        
                                } elsif ($Structure{$key}{type} eq "yn")
                                {
                                $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_yn($main::Form{$Structure{$key}{name}},$Structure{$key}{required},$Structure{$key}{unique},$Structure{$key}{fstatic});            
                                } elsif ($Structure{$key}{type} eq "image")
                                {
                                    ($SubDebug == 1) ? DebugOut("PROCESSING IMAGE: \$main::Form{$Structure{$key}{name}} = $main::Form{$Structure{$key}{name}} and  \$Data{$RecordIndex}{$Structure{$key}{name}} = $Data{$RecordIndex}{$Structure{$key}{name}}") : 0;
                                    if (length($main::Form{$Structure{$key}{name}}) > 5)
                                    {
                                    ($SubDebug == 1) ? DebugOut("Uploading Image File...") : 0;
                                    $RecordData{$Structure{$key}{name}} = main::lib_sdbrecords_processinput_image($Structure{$key}{name},$Structure{$key}{required},$ImagePath,("$RecordIndex"."."."$Structure{$key}{name}"));    
                                    } else {
                                        if (defined $Data{$RecordIndex}{$Structure{$key}{name}})
                                        {
                                        $RecordData{$Structure{$key}{name}} = $Data{$RecordIndex}{$Structure{$key}{name}};
                                        ($SubDebug == 1) ? DebugOut("Retaining file ...\$RecordData{$Structure{$key}{name}} = $RecordData{$Structure{$key}{name}}") : 0;
                                        } else {
                                            ($SubDebug == 1) ? DebugOut("Image file not defined: \"$Data{$RecordIndex}{$Structure{$key}{name}}\"") : 0;
                                            };
                                        };
                                	
                                };
                            
			    $main::Config{sdb}{UpdatedDataRecord} .= "\n**********\n$Structure{$key}{title} :\n**********\n$RecordData{$Structure{$key}{name}}\n";
                            } else {
                                main::DebugOut("ERROR: Cannot continue...");
                                $main::Config{sdb}{errortrigger}++;
                                };
                        };
                    };
                                # $main::Config{sdb}{errormessage} = undef;
                                if  ($main::Config{sdb}{errortrigger} > 0)
                                {
                                my($et) = undef;
                                main::DebugOut("FAILED: THERE WERE SOME ERRORS WHEN ADDING THE RECORD!");    
                                    foreach $et (sort keys %{$main::Config{sdb}{errortriggerxp}})
                                    {
                                    main::DebugOut("ERROR: $main::Config{sdb}{errortriggerxp}{$et}");
                                        if (defined $main::Config{sdb}{errortriggerxp}{$et})
                                        {
                                        main::DebugOut("$main::Config{sdb}{errortriggerxp}{$et}");
                                        $main::Config{sdb}{message}{error} .= "<br><b>ERROR: $main::Config{sdb}{errortriggerxp}{$et}</b>";
                                        };
                                    };
                                
                                } else {
                                        if (defined $RecordIndex)
                                        {
                                            if ($main::Form{"Refresh Links"} eq "Refresh Links")
                                            {
                                            main::DebugOut("OK - Refreshing Links: \"$RecordIndex\".");
                                            $main::Config{sdb}{errortrigger} = $main::Config{sdb}{errortrigger} + 1;        
                                            } else {
                                                main::DebugOut("OK - Adding new record: \"$RecordIndex\". to: \"$RecordIndexFile\" and  \"$DatabaseFile\"");    
                                                main::WriteIntConfig("config",\%RecordData,$RecordIndexFile);
                                                $Data{$RecordIndex} = \%RecordData;
                                                main::WriteIntConfig("config",\%Data,$DatabaseFile);
                                                };
                                        } else {
                                            main::DebugOut("WARNING! Record index was not defined! \"$RecordIndex\"");
                                            };
                                    };
                } else {
                    main::DebugOut("ERROR: Database file: \"$DatabaseFile\" or Database directory: \"$RecordsFolder\" do not exist!");
                    };
            } else {
                main::DebugOut("ERROR: Structure file: \"$StructureFile\" dies not exist!");
                };
        } else {
            main::DebugOut("ERROR: IndexLetter is either not present or of a wrong format! \"$IndexLetter\"!");
            };

    } else {
        main::DebugOut("ERROR: IndexID is  not present \"$IndexID\"!");
        };

    
};

####################################################################################################################
sub main::lib_sdbrecords_gettypeform_text
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;                                
my($Limit) = "<br><b>Limit: 254 characters.</b>";
my($NoteData) = "</td><td style=\"width:300;font-size=7pt\">$Explanation $Limit</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
if ($main::Form{sdb}{FormConfig}{TextFieldSize} < 10) {$main::Form{sdb}{FormConfig}{TextFieldSize} = 80};
$String .= "\n<input type=\"text\" name=\"$_[0]\" value=\"$ValueData\" size=\"$main::Form{sdb}{FormConfig}{TextFieldSize}\"/>";    
$String .= $NoteData;
return $String;
};

sub main::lib_sdbrecords_gettypeform_memo
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;
my($Limit) = "<br><b>Limit: 65000 characters.</b>";    
my($NoteData) = "</td><td style=\"width:300;font-size=7pt\">$Explanation $Limit</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
if ($main::Form{sdb}{FormConfig}{MemoFieldSize} < 10) {$main::Form{sdb}{FormConfig}{MemoFieldSize} = 81};
if ($main::Form{sdb}{FormConfig}{MemoFieldRows} < 2) {$main::Form{sdb}{FormConfig}{MemoFieldRows} = 7};

$String .= "\n<textarea name=\"$_[0]\" rows=\"$main::Form{sdb}{FormConfig}{MemoFieldRows}\" wrap=\"off\" style=\"width:100%;font-family:sans-serif,verdana,arial;font-size:9pt\">$ValueData</textarea>";    
$String .= $NoteData;
return $String;
};

sub main::lib_sdbrecords_gettypeform_bin
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;    
my($Limit) = "<br><b>Limit: 10Mb.</b>";
my($NoteData) = "</td><td style=\"width:300;font-size=7pt\">$Explanation $Limit</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
if ($main::Form{sdb}{FormConfig}{BinFieldSize} < 10) {$main::Form{sdb}{FormConfig}{BinFieldSize} = 80};

$String .= "\n<input type=\"file\" name=\"$_[0]\" value=\"$ValueData\" size=\"$main::Form{sdb}{FormConfig}{BinFieldSize}\"/>";        
$String .= $NoteData;
return $String;
};


sub main::lib_sdbrecords_gettypeform_image
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;    
my($Limit) = "<br><b>Limit: 1Mb.</b>";
my($NoteData) = "</td><td style=\"width:300;font-size=7pt\">$Explanation $Limit</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
if ($main::Form{sdb}{FormConfig}{BinFieldSize} < 10) {$main::Form{sdb}{FormConfig}{BinFieldSize} = 80};

$String .= "\n<input type=\"file\" name=\"$_[0]\" value=\"$ValueData\" size=\"$main::Form{sdb}{FormConfig}{BinFieldSize}\"/>";        
$String .= $NoteData;
return $String;
};

sub main::lib_sdbrecords_gettypeform_number
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;    
my($Limit) = "<br><b>Limit: 20 digits.</b>";
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation $Limit</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
if ($main::Form{sdb}{FormConfig}{NumberFieldSize} < 2) {$main::Form{sdb}{FormConfig}{NumberFieldSize} = 20};
$String .= "\n<input type=\"text\" name=\"$_[0]\" Max=\"20\" value=\"$ValueData\" size=\"$main::Form{sdb}{FormConfig}{NumberFieldSize}\"/>";        
$String .= $NoteData;
return $String;
};


sub main::lib_sdbrecords_gettypeform_link
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;
my($Limit) = "<br><b>Press and hold Ctrl button to select or deselect multiple values.</b>";    
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation $Limit</td></tr></table>";
my($FieldName) = $_[0];
my($FieldType) = $_[4];
my($DisplayField) = undef;
my($temp) = undef;
my($LinksSelected) = undef;
my(%TableLinkCommand) = undef;
my($key) = undef;
my($LinkedTable) = undef;

    foreach $key (keys %{$main::Config{sdb}{rootlist}})
    {
        if (defined $key)
        {
        $TableLinkCommand{$main::Config{sdb}{rootlist}{$key}{name}} = "sdb" . "$main::Config{sdb}{rootlist}{$key}{name}" . "edit";    
        };
    };
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };

my($DatabaseFile) = undef;
#    ($SubDebug == 1) ? DebugOut("\$FieldType = $FieldType") : 0;    
    if ($FieldType =~ m!^Link(.*)!i)
    {
    $temp = $1;
    ($SubDebug == 1) ? DebugOut("\$temp = $temp") : 0;    
        if ($temp =~ m!(.*)\.(.*)!) 
        {
        $DatabaseFile = $main::Config{sdb}{dbmain}{$1};
        $LinkedTable = $1;
        $DisplayField = $2;
        } else {
            $DatabaseFile = $main::Config{sdb}{dbmain}{$temp};
            $LinkedTable = $temp;
            $DisplayField = "f_id";
            };
    if ($main::Form{sdb}{FormConfig}{LinkFieldSize} < 2) {$main::Form{sdb}{FormConfig}{LinkFieldSize} = 19};    
        if (-f $DatabaseFile)
        {
        my(%Data) = main::ReadIntConfig($DatabaseFile);
        my($key) = undef;
        $String .= "\n<select size=\"$main::Form{sdb}{FormConfig}{LinkFieldSize}\" name=\"$FieldName\" multiple style=\"font-family:verdana,sans-serif;font-size:7pt\">";
            foreach $key (sort {$Data{$a}{$DisplayField} cmp $Data{$b}{$DisplayField}} keys %Data)
            {
                if (defined $Data{$key}{$DisplayField})
                {
                    if ($ValueData =~ m!$key!)
                    {
                    $String .= "\n<option selected value=\"$key\" style=\"font-family:verdana,sans-serif;font-size:7pt\">$Data{$key}{$DisplayField}</option>";
                    $LinksSelected++;    
                    } else {
                        $String .= "\n<option value=\"$key\" style=\"font-family:verdana,sans-serif;font-size:7pt\">$Data{$key}{$DisplayField}</option>";
                        };
                };
            };

            if ($LinksSelected > 0) 
            {
            $String .= "\n</select> Already selected: <b>$LinksSelected</b> record(s).";
            } else {
                $String .= "\n</select>No records selected.";
                };


            if (defined $TableLinkCommand{$LinkedTable})
            {
                if (main::checkacl("$TableLinkCommand{$LinkedTable}"))
                {
                $String .= " [ <a href=\"$main::UserEnv{href}&c=$TableLinkCommand{$LinkedTable}&cr=$main::Form{cr}&Mode=Add Records\" target=\"_blank\">Add Records...</a> ]";                    
                };
            };
        } else {
            ($SubDebug == 1) ? DebugOut("ERROR: Database file for a link does not exist: \"$DatabaseFile\"") : 0;
            };
    } else {
        ($SubDebug == 1) ? DebugOut("ERROR: FieldType has improper format: \"$FieldType\"") : 0;
        };

$String .= $NoteData;
return $String;
};


sub main::lib_sdbrecords_gettypeform_year
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = undef;
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
    $mon++; 
    $year = $year + 1900;
    
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;        
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
my($i) = undef;
$String .= "\n<select name=\"$_[0]\"/>";        
unless ($ValueData) {$ValueData = $year};

    for ($i = ($year - 8); $i < ($year + 8); $i++)
    {
        if ($ValueData == $i)
        {
        $String .= "\n<option value=\"$i\" selected>$i</option>";
        } else {
            $String .= "\n<option value=\"$i\">$i</option>";            
            };
    };
$String .= "\n</select/>";
$String .= $NoteData;
return $String;
};
####################################################################################################################
sub main::lib_sdbrecords_gettypeform_month
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = undef;
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
    $mon++;    ($mon < 10) ? $mon = "0"."$mon" : $mon = $mon;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;        
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
my($i) = undef;
$String .= "\n<select name=\"$_[0]\"/>";
my($temp) = undef;
unless ($ValueData) {$ValueData = $mon};
    for ($i = 1; $i < 13; $i++)
    {
        if ($ValueData == $i)
        {
        if ($i < 10) {$temp = "0"."$i"} else {$temp = $i};
        $String .= "\n<option value=\"$temp\" selected>$temp</option>";
        } else {
            if ($i < 10) {$temp = "0"."$i"} else {$temp = $i};
            $String .= "\n<option value=\"$temp\">$temp</option>";            
            };
    };
$String .= "\n</select/>";
$String .= $NoteData;
return $String;
};

####################################################################################################################
####################################################################################################################
sub main::lib_sdbrecords_gettypeform_date
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = undef;
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
    $weekday = $WeekDay[$wday];
    $mon++; 
    ($mday < 10) ? $mday = "0"."$mday" : $mday = $mday;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;    
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
my($i) = undef;
$String .= "\n<select name=\"$_[0]\"/>";
my($temp) = undef;
unless ($ValueData) {$ValueData = $mday};
    for ($i = 1; $i < 32; $i++)
    {
        if ($ValueData == $i)
        {
        if ($i < 10) {$temp = "0"."$i"} else {$temp = $i};
        $String .= "\n<option value=\"$temp\" selected>$temp</option>";
        } else {
            if ($i < 10) {$temp = "0"."$i"} else {$temp = $i};
            $String .= "\n<option value=\"$temp\">$temp</option>";            
            };
    };
$String .= "\n</select/>";
$String .= $NoteData;
return $String;
};
####################################################################################################################
####################################################################################################################
sub main::lib_sdbrecords_gettypeform_hour
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = undef;
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
    $mon++; 
    ($hour < 10) ? $hour = "0"."$hour" : $hour = $hour;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;        
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
my($i) = undef;
$String .= "\n<select name=\"$_[0]\"/>";
my($temp) = undef;
        
unless ($ValueData) {$ValueData = $hour};
    for ($i = 1; $i < 25; $i++)
    {
        if ($ValueData == $i)
        {
        if ($i < 10) {$temp = "0"."$i"} else {$temp = $i};
        $String .= "\n<option value=\"$temp\" selected>$temp</option>";
        } else {
            if ($i < 10) {$temp = "0"."$i"} else {$temp = $i};
            $String .= "\n<option value=\"$temp\">$temp</option>";            
            };
    };
$String .= "\n</select/>";
$String .= $NoteData;
return $String;
};

####################################################################################################################
####################################################################################################################
sub main::lib_sdbrecords_gettypeform_minute
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = undef;
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
    $mon++; ($min < 10) ? $min = "0"."$min" : $min = $min;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;        
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
my($i) = undef;
$String .= "\n<select name=\"$_[0]\"/>";
my($temp) = undef;
        
unless ($ValueData) {$ValueData = $min};
    for ($i = 1; $i < 61; $i++)
    {
        if ($ValueData == $i)
        {
        if ($i < 10) {$temp = "0"."$i"} else {$temp = $i};
        $String .= "\n<option value=\"$temp\" selected>$temp</option>";
        } else {
            if ($i < 10) {$temp = "0"."$i"} else {$temp = $i};
            $String .= "\n<option value=\"$temp\">$temp</option>";            
            };
    };
$String .= "\n</select/>";
$String .= $NoteData;
return $String;
};

####################################################################################################################
####################################################################################################################
sub main::lib_sdbrecords_gettypeform_second
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = undef;
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 
    $mon++; 
    ($sec < 10) ? $sec = "0"."$sec" : $sec = $sec;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;    
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
my($i) = undef;
$String .= "\n<select name=\"$_[0]\"/>";
my($temp) = undef;
unless ($ValueData) {$ValueData = $sec};
    for ($i = 1; $i < 61; $i++)
    {
        if ($ValueData == $i)
        {
        if ($i < 10) {$temp = "0"."$i"} else {$temp = $i};
        $String .= "\n<option value=\"$temp\" selected>$temp</option>";
        } else {
            if ($i < 10) {$temp = "0"."$i"} else {$temp = $i};
            $String .= "\n<option value=\"$temp\">$temp</option>";            
            };
    };
$String .= "\n</select/>";
$String .= $NoteData;
return $String;
};
####################################################################################################################
sub main::lib_sdbrecords_gettypeform_wday
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($ValueData) = undef;
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = undef;
my(@WeekDay) = ("Sun","Mon","Tue","Wed","Thu","Fri","Sat");
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); 

    $weekday = $WeekDay[$wday];
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;    
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
my($i) = undef;
$String .= "\n<select name=\"$_[0]\"/>";
my($temp) = undef;
        
unless ($ValueData) {$ValueData = $weekday};

    for ($i = 0; $i < 7; $i++)
    {
        if ($ValueData eq $WeekDay[$i])
        {
        $String .= "\n<option value=\"$WeekDay[$i]\" selected>$WeekDay[$i]</option>";
        } else {
            $String .= "\n<option value=\"$WeekDay[$i]\">$WeekDay[$i]</option>";            
            };
    };
$String .= "\n</select/>";
$String .= $NoteData;
return $String;
};

sub main::lib_sdbrecords_gettypeform_email
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;
my($Limit) = "<br><b>Limit: 254 characters.</b>";
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation $Limit</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
if ($main::Form{sdb}{FormConfig}{NumberFieldSize} < 2) {$main::Form{sdb}{FormConfig}{NumberFieldSize} = 80};
$String .= "\n<input type=\"text\" name=\"$_[0]\" value=\"$ValueData\" size=\"$main::Form{sdb}{FormConfig}{NumberFieldSize}\"/>";        
$String .= $NoteData;
return $String;
};

sub main::lib_sdbrecords_gettypeform_phone
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;
my($Limit) = "<br><b>Limit: 254 characters.</b>";
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation $Limit</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
if ($main::Form{sdb}{FormConfig}{NumberFieldSize} < 2) {$main::Form{sdb}{FormConfig}{NumberFieldSize} = 80};
$String .= "\n<input type=\"text\" name=\"$_[0]\" value=\"$ValueData\" size=\"$main::Form{sdb}{FormConfig}{NumberFieldSize}\"/>";        
$String .= $NoteData;
return $String;
};
sub main::lib_sdbrecords_gettypeform_webaddress
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;
my($Limit) = "<br><b>Limit: 254 characters.</b>";
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation $Limit</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
if ($main::Form{sdb}{FormConfig}{NumberFieldSize} < 2) {$main::Form{sdb}{FormConfig}{NumberFieldSize} = 80};
$String .= "\n<input type=\"text\" name=\"$_[0]\" value=\"$ValueData\" size=\"$main::Form{sdb}{FormConfig}{NumberFieldSize}\"/>";        
$String .= $NoteData;
return $String;
};
sub main::lib_sdbrecords_gettypeform_timestamp
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
unless ($ValueData > 0) {$ValueData = time};        
$String .= "\n<input type=\"hidden\" name=\"$_[0]\" value=\"$ValueData\"\"/>". scalar localtime($ValueData);        
$String .= $NoteData;
return $String;
};
sub main::lib_sdbrecords_gettypeform_id
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation</td></tr></table>";
    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
unless ($ValueData > 0) {$ValueData = time};        
$String .= "\n<input type=\"hidden\" name=\"$_[0]\" value=\"$ValueData\"\"/>". $ValueData;        
$String .= $NoteData;
return $String;
};

sub main::lib_sdbrecords_gettypeform_autouser
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation</td></tr></table>";

    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
unless (length($ValueData) > 1) {$ValueData = $main::UserEnv{name}};        
$String .= "\n<input type=\"hidden\" name=\"$_[0]\" value=\"$ValueData\"\"/>". $ValueData;        
$String .= $NoteData;
return $String;
};

sub main::lib_sdbrecords_gettypeform_yn
{
my($String) = "<table style=\"width:100%;font-size=7pt\"><tr><td>";
my($ValueData) = undef;
my($Explanation) = $_[3];
$Explanation = main::lib_html_Escape($Explanation);
$Explanation =~ s!\n!<br>!gis;
$Explanation =~ s!\t!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!gis;
my($NoteData) = "</td><td style=\"width:200;font-size=7pt\">$Explanation</td></tr></table>";
my($i) = undef;
$String .= "\n<select name=\"$_[0]\"/>";
my($temp) = undef;


    unless (($main::Form{Modify} == 1) || ($main::Form{Update} eq "Update Record") )
    {
    $ValueData = $_[1];
    } else {
        $ValueData = $_[2];
        };
                
unless ($ValueData eq "YES") {$ValueData = "NO"};

        if ($ValueData eq "YES")
        {
        $String .= "\n<option value=\"YES\" selected>YES</option>";
        $String .= "\n<option value=\"NO\">NO</option>";
        } else {
            $String .= "\n<option value=\"YES\">YES</option>";
            $String .= "\n<option value=\"NO\" selected>NO</option>";
            };

$String .= "\n</select/>";    
$String .= $NoteData;
return $String;
};

####################################################################################################################


sub main::lib_sdbrecords_processinput_text
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
$String = main::lib_html_Escape($String);
$String = substr($String,0,254);
return $String;    
};

sub main::lib_sdbrecords_processinput_memo
{
my($String) = $_[0];
my($Required) = $_[1];
my($MemoPath) = $_[2];
my($MemoID) = $_[3];
my($MemoFile) = $MemoPath . $MemoID;
if ($main::Config{InputConfig}{MemoDisplayLength} < 16) {$main::Config{InputConfig}{MemoDisplayLength} = 128};
    if (-e $MemoPath)
    {
    main::SaveFile($MemoFile,$String);
    $String = main::CleanSpaces($String);
    $String = substr(main::lib_html_Escape($String),0,$main::Config{InputConfig}{MemoDisplayLength});
    } else {
        ($SubDebug == 1) ? DebugOut("ERROR: Memo Path does Not Exist! Error Saving Memo File to \"$MemoFile\"") : 0;
        $String = undef;
        };

if ($Required == 1)
{
    if (length($String) > 0)
    {
    return $String;        
    } else {
        main::DebugOut("ERROR: Required Memo field was not processed!");
        $main::Config{sdb}{errortrigger}++;
        $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Required Memo Field is Empty!";
        };
} else {
    return $String;        
    };
};
sub main::lib_sdbrecords_processinput_bin
{
my($String) = $_[0];
my($Required) = $_[1];
my($BinPath) = $_[2];
my($BinID) = $_[3];
my($BinFile) = $BinPath . $BinID;
my(@temp) = undef;

    if (length{$main::Form{$String}} > 5)
    {
    main::LoadLibrary("lib_upload.pl");
    ($SubDebug == 1) ? DebugOut("Processing Binary file: \"$String\" -> \"$BinFile\"") : 0;
        if (main::lib_upload_file($String,$BinFile,1))
        {
        $main::Form{$String} =~ s!\\!/!gi;
        @temp = split("/",$main::Form{$String});
        $String = $temp[$#temp];
        return $String;    
        } else {
            $String = undef;
            main::DebugOut("ERROR: Saving Binary File!");
            $main::Config{sdb}{errortrigger}++;
            $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "There was an error saving Binary File!";
            };
    };
};


sub main::lib_sdbrecords_processinput_image
{
my($String) = $_[0];
my($Required) = $_[1];
my($ImagePath) = $_[2];
my($ImageID) = $_[3];
my($ImageFile) = $ImagePath . $ImageID;
my(@temp) = undef;

    if (length{$main::Form{$String}} > 5)
    {
    main::LoadLibrary("lib_upload.pl");
    ($SubDebug == 1) ? DebugOut("Processing Image file: \"$String\" -> \"$ImageFile\"") : 0;
        if (main::lib_upload_file($String,$ImageFile,1))
        {
        $main::Form{$String} =~ s!\\!/!gi;
        @temp = split("/",$main::Form{$String});
        $String = $temp[$#temp];
        return $String;    
        } else {
            $String = undef;
            main::DebugOut("ERROR: Saving Image File!");
            $main::Config{sdb}{errortrigger}++;
            $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "There was an error saving Image File!";
            };
    };
};

sub main::lib_sdbrecords_processinput_number
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
$String = main::lib_html_Escape($String);
    if ($String =~ m!\D!)
    {
    $String = undef;
    main::DebugOut("ERROR: Characters were passed into the number-type field!");
    $main::Config{sdb}{errortrigger}++;
    $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Characters were passed into the number-type field!";
    } else {
        $String = substr($String,0,254);
        };
return $String;    
};


sub main::lib_sdbrecords_processinput_link
{
my($String) = $_[0];
my($Required) = $_[1];
my($FieldName) = $_[3];
my($FieldType) = $_[4];

if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
my($valuekey) = undef;
my($temp) = undef;
my(@Value) = undef;
my($ValueCount) = undef;

my($DatabaseFile) = undef;
my($DatabaseField) = undef;
my($DatabaseFolder) = undef;


    ($SubDebug == 1) ? DebugOut("\$FieldType = $FieldType") : 0;    
    if ($FieldType =~ m!Link(.*)!i)
    {
    $temp = $1;
    ($SubDebug == 1) ? DebugOut("\$temp = $temp") : 0;    
        if ($temp =~ m!(.*)\.(.*)!) 
        {
        $DatabaseFile = $main::Config{sdb}{dbmain}{$1};
        $DisplayField = $2;
        $DatabaseFolder = $main::Config{sdb}{dbroot}{$1};
        } else {
            $DatabaseFile = $main::Config{sdb}{dbmain}{$temp};
            $DatabaseFolder = $main::Config{sdb}{dbroot}{$temp};
            $DisplayField = "f_id";
            };
    ($SubDebug == 1) ? DebugOut("\$DatabaseFile = $DatabaseFile") : 0;
    ($SubDebug == 1) ? DebugOut("\$DisplayField = $DisplayField") : 0;
    ($SubDebug == 1) ? DebugOut("\$DatabaseFolder = $DatabaseFolder") : 0;        
    };
$temp = undef;
my(%RecordData) = undef;
my(@SearchValue) = undef;

    if (defined $main::Form{MultipleFormValuesFromSingleFormField}{$FieldName})
    {

        foreach $valuekey (keys %{$main::Form{MultipleFormValuesFromSingleFormField}{$FieldName}})
        {
            if ($valuekey > 0)
            {
                if (defined $main::Form{MultipleFormValuesFromSingleFormField}{$FieldName}{$valuekey}) 
                {

                $temp = $DatabaseFolder . $main::Form{MultipleFormValuesFromSingleFormField}{$FieldName}{$valuekey} . ".cgi";
                    if (-f $temp)
                    {
                    %RecordData = main::ReadIntConfig($temp);
                        if (defined $RecordData{$DisplayField})
                        {
                        $SearchValue[$ValueCount++] = $RecordData{$DisplayField};
                        if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("Search Value = \"$RecordData{$DisplayField}\"") : 0;
                        $Value[$ValueCount] = main::urlDecode($main::Form{MultipleFormValuesFromSingleFormField}{$FieldName}{$valuekey});
                        } else {
                            ($SubDebug == 1) ? DebugOut("ERROR: Not defined : \$RecordData{$DisplayField} = $RecordData{$DisplayField}") : 0;
                            };
                        
                    } else {
                        ($SubDebug == 1) ? DebugOut("ERROR: \$temp = $temp") : 0;
                        };                            
                };
            };
        };

        if ($ValueCount > 0)
        {
        $temp = join(",",@SearchValue);
        $String = join(",",@Value);
        $temp = main::CleanSpaces($temp);
        $temp = main::lib_html_Escape($temp);
        $String = main::CleanSpaces($String);
        $String = main::lib_html_Escape($String);        
        $String = "$temp" . "![(" . "$String" . ")]!";
        if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("\$String = \"$String\"") : 0;
        };
    } else {
        $String = undef;
        };
return $String;    
};

sub main::lib_sdbrecords_processinput_year
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
$String = main::lib_html_Escape($String);
    if ($String =~ m!\D!)
    {
    $String = undef;
    main::DebugOut("ERROR: Characters were passed into the number-type field!");
    $main::Config{sdb}{errortrigger}++;
    $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Characters were passed into the number-type field!";
    } else {
        if ($String =~ m!\d\d\d\d!)
        {
        $String = substr($String,0,254);    
        } else {
            main::DebugOut("ERROR: Incorrect format of the year-type field!");
            $main::Config{sdb}{errortrigger}++;
            $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Incorrect format of the year-type field!";
            };
        };
return $String;    
};

sub main::lib_sdbrecords_processinput_month
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
$String = main::lib_html_Escape($String);
    if ($String =~ m!\D!)
    {
    $String = undef;
    main::DebugOut("ERROR: Characters were passed into the number-type field!");
    $main::Config{sdb}{errortrigger}++;
    $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Incorrect format of the month-type field!";
    } else {
        if ($String =~ m!\d\d!)
        {
        $String = substr($String,0,254);    
        } else {
            main::DebugOut("ERROR: Incorrect format of the month-type field!");
            $main::Config{sdb}{errortrigger}++;
            $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Incorrect format of the month-type field!";
            };
        };
return $String;    
};

sub main::lib_sdbrecords_processinput_date
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
$String = main::lib_html_Escape($String);
    if ($String =~ m!\D!)
    {
    $String = undef;
    main::DebugOut("ERROR: Characters were passed into the date-type field!");
    $main::Config{sdb}{errortrigger}++;
    $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Incorrect format of the date-type field!";
    } else {
        if ($String =~ m!\d\d!)
        {
        $String = substr($String,0,254);    
        } else {
            main::DebugOut("ERROR: Incorrect format of the month-type field!");
            $main::Config{sdb}{errortrigger}++;
            $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Incorrect format of the date-type field!";
            };
        };
return $String;    
};



sub main::lib_sdbrecords_processinput_hour
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
$String = main::lib_html_Escape($String);
    if ($String =~ m!\D!)
    {
    $String = undef;
    main::DebugOut("ERROR: Characters were passed into the minute-type field!");
    $main::Config{sdb}{errortrigger}++;
    $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Incorrect format of the minute-type field!";
    } else {
        if ($String =~ m!\d\d!)
        {
        $String = substr($String,0,254);    
        } else {
            main::DebugOut("ERROR: Incorrect format of the month-type field!");
            $main::Config{sdb}{errortrigger}++;
            $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Incorrect format of the minute-type field!";
            };
        };
return $String;    
};

sub main::lib_sdbrecords_processinput_minute
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
$String = main::lib_html_Escape($String);
    if ($String =~ m!\D!)
    {
    $String = undef;
    main::DebugOut("ERROR: Characters were passed into the minute-type field!");
    $main::Config{sdb}{errortrigger}++;
    $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Incorrect format of the minute-type field!";
    } else {
        if ($String =~ m!\d\d!)
        {
        $String = substr($String,0,254);    
        } else {
            main::DebugOut("ERROR: Incorrect format of the month-type field!");
            $main::Config{sdb}{errortrigger}++;
            $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Incorrect format of the minute-type field!";
            };
        };
return $String;    
};

sub main::lib_sdbrecords_processinput_second
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
$String = main::lib_html_Escape($String);
    if ($String =~ m!\D!)
    {
    $String = undef;
    main::DebugOut("ERROR: Characters were passed into the second-type field!");
    $main::Config{sdb}{errortrigger}++;
    $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Incorrect format of the second-type field!";
    } else {
        if ($String =~ m!\d\d!)
        {
        $String = substr($String,0,254);    
        } else {
            main::DebugOut("ERROR: Incorrect format of the month-type field!");
            $main::Config{sdb}{errortrigger}++;
            $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Incorrect format of the second-type field!";
            };
        };
return $String;    
};
sub main::lib_sdbrecords_processinput_wday
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
$String = main::lib_html_Escape($String);
    if ($String =~ m!\w\w\w!)
    {
    $String = substr($String,0,254);    
    } else {
        $String = undef;
        main::DebugOut("ERROR: Incorrect format of the month-type field!");
        $main::Config{sdb}{errortrigger}++;
        $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "Incorrect format of the WeekDay-type field!";
        };
return $String;    
};

sub main::lib_sdbrecords_processinput_phone
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
$String = main::lib_html_Escape($String);
$String = substr($String,0,254);
return $String;    
};

sub main::lib_sdbrecords_processinput_email
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
if ((main::lib_access_checkusernameformat($String)) || (length($String) == 0) )
{
$String = main::lib_html_Escape($String);
$String = substr($String,0,254);    
} else {
    main::DebugOut("ERROR: E-mail address record does not have a proper format!");
    $main::Config{sdb}{errortrigger}++;
    $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "ERROR: E-mail address record does not have a proper format!";    
    };

return $String;    
};
sub main::lib_sdbrecords_processinput_webaddress
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
    if (($String =~ m!http://.*!i) || (length($String) == 0))
    {
    $String = main::lib_html_Escape($String);
    $String = substr($String,0,254);
    } else {
        main::DebugOut("ERROR: Internet Web Address record does not have a proper format!");
        $main::Config{sdb}{errortrigger}++;
        $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "ERROR: Internet Web Address record does not have a proper format!<br>Example: \"http://www.address.com\"";            
        };
return $String;    
};
sub main::lib_sdbrecords_processinput_timestamp
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
$String = main::lib_html_Escape($String);
    if ($String =~ m!\D!)
    {
    $String = undef;
    main::DebugOut("ERROR: Timestamp does not have a proper formatting!");
    $main::Config{sdb}{errortrigger}++;
    $main::Config{sdb}{errortriggerxp}{$main::Config{sdb}{errortrigger}} .= "ERROR: Timestamp does not have a proper formatting!";
    } else {
        $String = substr($String,0,254);
        };
return $String;    
};
sub main::lib_sdbrecords_processinput_id
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
$String = main::lib_html_Escape($String);
$String = substr($String,0,254);
return $String;    
};

sub main::lib_sdbrecords_processinput_autouser
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
$String = main::lib_html_Escape($String);
$String = substr($String,0,254);
return $String;    
};
sub main::lib_sdbrecords_processinput_yn
{
my($String) = $_[0];
my($Required) = $_[1];
$String = main::CleanSpaces($String);
$String = main::lib_html_Escape($String);
$String = substr($String,0,3);
return $String;    
};
1;
