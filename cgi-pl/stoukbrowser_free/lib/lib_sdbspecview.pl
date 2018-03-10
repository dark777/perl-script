sub main::lib_sdbspecview_checkdownload_bin
{
my($RecordsFolder) = $_[0];
my($BinPath) = $RecordsFolder . "bin/";
unless (-e $BinPath) {mkdir($BinPath,0777)}
my($RecordIndex) = undef;
my($RecordIndexFile) = undef;
my($DataFile) = undef;
my($ViewDataFile) = undef;
my($ViewDataReference) = undef;
my($key) = undef;
my(%RecordData) = undef;
my($Field) = undef;
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;


	if ($main::Form{binview} =~ m!(\w\d+)\.(.*)!)
	{
	
	$DataFile = $BinPath . $main::Form{binview};	
	$Field = $2;
	$RecordIndexFile = $RecordsFolder . "$1" . ".cgi";
	
	($SubDebug == 1) ? DebugOut("Processing Download: \$DataFile = $DataFile and \$Field = $Field") : 0;
		if (-f $DataFile)
		{
		($SubDebug == 1) ? DebugOut("DATAFILE Exists - OK!") : 0;
	
			if (-f $RecordIndexFile)
			{
			($SubDebug == 1) ? DebugOut("Record Index file exists - OK!") : 0;	
			
			%RecordData = main::ReadIntConfig($RecordIndexFile);
				if (defined $RecordData{$Field})
				{
				$ViewDataFile = $main::Config{CacheFolder} . $RecordData{$Field};
				if (-f $ViewDataFile) {unlink($ViewDataFile)};
				
				($SubDebug == 1) ? DebugOut("Created Path for ViewDataFile: $ViewDataFile : \$main::Config{sdb}{opt}{div}{dl_ext} = $main::Config{sdb}{opt}{div}{dl_ext}") : 0;
				if ($main::Config{sdb}{opt}{div}{dl_ext} =~ m!\.\w+!) {$ViewDataFile .= $main::Config{sdb}{opt}{div}{dl_ext}};
				main::CopyFile($DataFile,$ViewDataFile,1);
				
				if (-f $ViewDataFile) 
				{
				($SubDebug == 1) ? DebugOut("Successfully copied $DataFile to  $ViewDataFile") : 0;
				$ViewDataReference = $main::Config{ScriptWebRoot} . $main::ConfigEnv{CacheFolder} . $RecordData{$Field};
				if ($main::Config{sdb}{opt}{div}{dl_ext} =~ m!\.\w+!) {$ViewDataReference .= $main::Config{sdb}{opt}{div}{dl_ext}};
				($SubDebug == 1) ? DebugOut("Reterning Reference: \$ViewDataReference = $ViewDataReference") : 0;
				return $ViewDataReference;
				} else {
					$ViewDataReference = undef;
					($SubDebug == 1) ? DebugOut("ERROR: Referencing Binary Data file. Could not create a copy \"$ViewDataFile\"") : 0;
					return 0;
					};
				
				} else {
					($SubDebug == 1) ? DebugOut("ERROR: Binary Record not defined! \$RecordData{$Field} = \"$RecordData{$Field}\"") : 0;
					return 0;
					};

				
			} else {
				($SubDebug == 1) ? DebugOut("ERROR: record index file does not exist! \"$RecordIndexFile\"") : 0;
				return 0;
				};
			
		} else {
			($SubDebug == 1) ? DebugOut("ERROR: binview Data file does not exist! \"$DataFile\"") : 0;
			return 0;
			};
		
		
	} else {
		($SubDebug == 1) ? DebugOut("ERROR: Incorrect format of the field value \$main::Form{binview} = \"$main::Form{binview}\"") : 0;
		return 0;
		};	
	
};


sub main::lib_sdbspecview_checkdownload_image
{
my($RecordsFolder) = $_[0];
my($BinPath) = $RecordsFolder . "bin/";
unless (-e $BinPath) {mkdir($BinPath,0777)}
my($ImagePath) = $RecordsFolder . "image/";
unless (-e $ImagePath) {mkdir($ImagePath,0777)}

my($RecordIndex) = undef;
my($RecordIndexFile) = undef;
my($DataFile) = undef;
my($ViewDataFile) = undef;
my($ViewDataReference) = undef;
my($key) = undef;
my(%RecordData) = undef;
my($Field) = undef;
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;


	if ($main::Form{imageview} =~ m!(\w\d+)\.(.*)!)
	{
	
	$DataFile = $ImagePath . $main::Form{imageview};	
	$Field = $2;
	$RecordIndexFile = $RecordsFolder . "$1" . ".cgi";
	
	($SubDebug == 1) ? DebugOut("Processing Download: \$DataFile = $DataFile and \$Field = $Field") : 0;
		if (-f $DataFile)
		{
		($SubDebug == 1) ? DebugOut("DATAFILE Exists - OK!") : 0;
	
			if (-f $RecordIndexFile)
			{
			($SubDebug == 1) ? DebugOut("Record Index file exists - OK!") : 0;	
			
			%RecordData = main::ReadIntConfig($RecordIndexFile);
				if (defined $RecordData{$Field})
				{
					unless (-e $main::Config{ViewImageDinamicFolder})
					{
					$ViewDataFile = $main::Config{CacheFolder} . $RecordData{$Field};		
					} else {
						$ViewDataFile = $main::Config{ViewImageDinamicFolder} . $RecordData{$Field};	
						};
				
				if (-f $ViewDataFile) {unlink($ViewDataFile)};
				
				($SubDebug == 1) ? DebugOut("Created Path for ViewDataFile: $ViewDataFile : \$main::Config{sdb}{opt}{div}{dl_ext} = $main::Config{sdb}{opt}{div}{dl_ext}") : 0;
				if ($main::Config{sdb}{opt}{div}{dl_ext} =~ m!\.\w+!) {$ViewDataFile .= $main::Config{sdb}{opt}{div}{dl_ext}};
				main::CopyFile($DataFile,$ViewDataFile,1);
				
				if (-f $ViewDataFile) 
				{
				($SubDebug == 1) ? DebugOut("Successfully copied $DataFile to  $ViewDataFile") : 0;
				$ViewDataReference = $main::Config{ScriptWebRoot} . $main::ConfigEnv{CacheFolder} . $RecordData{$Field};
				if ($main::Config{sdb}{opt}{div}{dl_ext} =~ m!\.\w+!) {$ViewDataReference .= $main::Config{sdb}{opt}{div}{dl_ext}};
				($SubDebug == 1) ? DebugOut("Reterning Reference: \$ViewDataReference = $ViewDataReference") : 0;
				return $ViewDataReference;
				} else {
					$ViewDataReference = undef;
					($SubDebug == 1) ? DebugOut("ERROR: Referencing Image file. Could not create a copy \"$ViewDataFile\"") : 0;
					return 0;
					};
				
				} else {
					($SubDebug == 1) ? DebugOut("ERROR: Image Record not defined! \$RecordData{$Field} = \"$RecordData{$Field}\"") : 0;
					return 0;
					};

				
			} else {
				($SubDebug == 1) ? DebugOut("ERROR: record index file does not exist! \"$RecordIndexFile\"") : 0;
				return 0;
				};
			
		} else {
			($SubDebug == 1) ? DebugOut("ERROR: Image Data file does not exist! \"$DataFile\"") : 0;
			return 0;
			};
		
		
	} else {
		($SubDebug == 1) ? DebugOut("ERROR: Incorrect format of the field value \$main::Form{imageview} = \"$main::Form{imageview}\"") : 0;
		return 0;
		};	
	
};

sub main::lib_sdbspecview_checkdownload_memo
{
my($RecordsFolder) = $_[0];
my($MemoPath) = $RecordsFolder . "memo/";
unless (-e $MemoPath) {mkdir($MemoPath,0777)}
my($RecordIndex) = undef;
my($RecordIndexFile) = undef;
my($DataFile) = undef;
my($ViewDataFile) = undef;
my($ViewDataReference) = undef;
my($key) = undef;
my(%RecordData) = undef;
my($Field) = undef;
my($MemoId) = undef;

if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

	if ($main::Form{memoview} =~ m!(\w\d+)\.(.*)!)
	{
	$MemoId = $1;
	$DataFile = $MemoPath . $main::Form{memoview};	
	$Field = $2;
	$RecordIndexFile = $RecordsFolder . "$1" . ".cgi";
	
	($SubDebug == 1) ? DebugOut("Processing Memo Download: \$DataFile = $DataFile and \$Field = $Field") : 0;
		if (-f $DataFile)
		{
		($SubDebug == 1) ? DebugOut("MEMO FILE Exists - OK!") : 0;
	
			if (-f $RecordIndexFile)
			{
			($SubDebug == 1) ? DebugOut("Record Index file exists - OK!") : 0;	
			
			%RecordData = main::ReadIntConfig($RecordIndexFile);
			
				if (defined $RecordData{$Field})
				{
				$ViewDataFile = $main::Config{CacheFolder} . $MemoId . ".txt";
				if (-f $ViewDataFile) {unlink($ViewDataFile)};
				
				($SubDebug == 1) ? DebugOut("Created Path for ViewDataFile: $ViewDataFile") : 0;
				
				main::CopyFile($DataFile,$ViewDataFile,1);
				
				if (-f $ViewDataFile) 
				{
				($SubDebug == 1) ? DebugOut("Successfully copied $DataFile to  $ViewDataFile") : 0;
				$ViewDataReference = $main::Config{ScriptWebRoot} . $main::ConfigEnv{CacheFolder} . $MemoId . ".txt";
				($SubDebug == 1) ? DebugOut("Reterning Reference: \$ViewDataReference = $ViewDataReference") : 0;
				$main::Config{sdb}{memodata} =  main::lib_html_Escape(join("",(main::ReadFile($DataFile))));
				return $ViewDataReference;
				} else {
					$ViewDataReference = undef;
					($SubDebug == 1) ? DebugOut("ERROR: Referencing Memo Data file. Could not create a copy \"$ViewDataFile\"") : 0;
					return 0;
					};
				
				} else {
					($SubDebug == 1) ? DebugOut("ERROR: Memo Record not defined! \$RecordData{$Field} = \"$RecordData{$Field}\"") : 0;
					return 0;
					};

				
			} else {
				($SubDebug == 1) ? DebugOut("ERROR: record index file does not exist! \"$RecordIndexFile\"") : 0;
				return 0;
				};
			
		} else {
			($SubDebug == 1) ? DebugOut("ERROR: memoview Memo Data file does not exist! \"$DataFile\"") : 0;
			return 0;
			};
		
		
	} else {
		($SubDebug == 1) ? DebugOut("ERROR: Incorrect format of the field value \$main::Form{memoview} = \"$main::Form{memoview}\"") : 0;
		return 0;
		};	
	
};

sub main::lib_sdbspecview_checkdownload_selectview
{
my($StructureFile) = $_[0];
my($DatabaseFile) = $_[1];
my($RecordsFolder) = $_[2];
my($TableName) = $_[3];
my($ViewID) = undef;
my($ViewForm) = undef;
my(%ViewRecord) = undef;
my(%RecordData) = undef;
my($ViewField) = undef;
my($RecordIndexFile) = undef;
my($LinkDatabase) = undef;
my($LinkDatabaseStructureFile) = undef;
my($LinkDatabaseRecord) = undef;
my($LinkDatabaseRoot) = undef;
my($LinkDatabaseField) = undef;
my($temp) = undef;
my(%Structure) = undef;
my($LinkType) = undef;
my($String) = undef;

if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

	if ($main::Form{selectview} =~ m!(\w\d+)\.(.*)!)
	{
	$ViewId = $1;
	$ViewField = $2;
	$RecordIndexFile = $RecordsFolder . "$1" . ".cgi";
	
		if (-f $RecordIndexFile)
		{
		%RecordData = main::ReadIntConfig($RecordIndexFile);
		($SubDebug == 1) ? DebugOut("OK - RecordData file exists... \$RecordIndexFile = $RecordIndexFile") : 0;
			if (-f $StructureFile)
			{
			%Structure = main::ReadIntConfig($StructureFile);	
			($SubDebug == 1) ? DebugOut("OK - Structure file exists \$StructureFile = $StructureFile") : 0;
				foreach $key (keys %Structure)
				{
					if ($Structure{$key}{name} eq $ViewField)
					{
					($SubDebug == 1) ? DebugOut("OK - Found Link Database Type: \$Structure{$key}{type} = $Structure{$key}{type}") : 0;
					$LinkType = $Structure{$key}{type};	
					};
				};
			
			} else {
				($SubDebug == 1) ? DebugOut("ERROR: Structure file does not exist! \"$StructureFile\"") : 0;
				};
		
		
			if (defined $RecordData{$ViewField})
			{
			($SubDebug == 1) ? DebugOut("OK - RecordData ViewField is defined \$RecordData{$ViewField} = $RecordData{$ViewField}") : 0;
				if (defined $LinkType)
				{
				($SubDebug == 1) ? DebugOut("OK - LinkType is defined \$LinkType = $LinkType") : 0;
					if ($LinkType =~ m!^Link(.*)!i)
					{
					($SubDebug == 1) ? DebugOut("OK LinkType is of proper format...") : 0;
					$temp = $1;
						if ($temp =~ m!(.*)\.(.*)!)
						{
						$LinkDatabase = $1;
						$LinkDatabaseField = $2;	
						($SubDebug == 1) ? DebugOut("OK Defined \$LinkDatabase = $LinkDatabase and \$LinkDatabaseField = $LinkDatabaseField") : 0;
						} else {
							$LinkDatabase = $temp;
							$LinkDatabaseField = "f_id";
							($SubDebug == 1) ? DebugOut("OK Defined \$LinkDatabase = $LinkDatabase and \$LinkDatabaseField = $LinkDatabaseField") : 0;							
							};			
					} else {
						($SubDebug == 1) ? DebugOut("ERROR: Record Data Type is not defined or has an improper format \$RecordData{$ViewField}{type} = $RecordData{$ViewField}{type}") : 0;	
						};
				} else {
					($SubDebug == 1) ? DebugOut("ERROR: Record Data Type is not defined or has an improper format \$RecordData{$ViewField}{type} = $RecordData{$ViewField}{type}") : 0;
					};
				
			} else {
				($SubDebug == 1) ? DebugOut("ERROR: Record Data is not defined: \$RecordData{$ViewField} = $RecordData{$ViewField}") : 0;
				};
		
		
		} else {
			($SubDebug == 1) ? DebugOut("ERROR: Record Index File does not exist! \"$RecordIndexFile\"") : 0;
			};	
	
	
	
	} else {
		($SubDebug == 1) ? DebugOut("ERROR: SelectView Form Parameter has improper format: \"$main::Form{selectview}\"") : 0;
		};


	if ((defined $LinkDatabase) && (defined $LinkDatabaseField ) && (defined $RecordData{$ViewField}))
	{
	$LinkDatabaseRoot = $main::Config{sdb}{dbroot}{"$LinkDatabase"};
	($SubDebug == 1) ? DebugOut("Linked DatabaseRoot is \"$LinkDatabaseRoot\"") : 0;
	$LinkDatabaseStructureFile = $main::Config{sdb}{dbstruct}{$LinkDatabase};
	($SubDebug == 1) ? DebugOut("\$LinkDatabaseStructureFile = $LinkDatabaseStructureFile") : 0;
	if ($RecordData{$ViewField} =~ m#!\[\((.*)\)\]!#i)
		{
		$temp = $1;
		my(@LinkedRecord) = undef;
		
			if (defined $temp)
			{
			@LinkedRecord = split(",",$temp);
			$temp = scalar @LinkedRecord;
			($SubDebug == 1) ? DebugOut("OK - Total $temp linked records found...") : 0;
					foreach $key (@LinkedRecord)
					{
					($SubDebug == 1) ? DebugOut("Processing Linked Record: $key") : 0;
						if ($key =~ m!(\w\d+)!)
						{
						($SubDebug == 1) ? DebugOut("OK - Link record Key is of Proper format...") : 0;
						$temp = $1;
						($SubDebug == 1) ? DebugOut("OK - Processing Link Record: \"$temp\"") : 0;
						
						
							if (-e $LinkDatabaseRoot)
							{
							($SubDebug == 1) ? DebugOut("OK - \$LinkDatabaseRoot = $LinkDatabaseRoot") : 0;	
							$LinkDatabaseRecord = $LinkDatabaseRoot . $temp . ".cgi";
							($SubDebug == 1) ? DebugOut("Checking if Linked database Record Exists: \"$LinkDatabaseRecord\"") : 0;								
								
								if (-f $LinkDatabaseRecord)
								{
								($SubDebug == 1) ? DebugOut("OK - Exists... Reading data") : 0;
								undef %RecordData;
								%RecordData = main::ReadIntConfig($LinkDatabaseRecord);
								($SubDebug == 1) ? DebugOut("") : 0;
									if (defined $RecordData{$LinkDatabaseField})
									{
									($SubDebug == 1) ? DebugOut("OK - Successfully read data from Linked Record: \$RecordData{$LinkDatabaseField} = $RecordData{$LinkDatabaseField}") : 0;										
									$ViewRecord{$temp} = \%RecordData;
									} else {
										($SubDebug == 1) ? DebugOut("ERROR: Failed to read data from Linked Record: \$RecordData{$LinkDatabaseField} = $RecordData{$LinkDatabaseField}") : 0;	
										};
								} else {
									($SubDebug == 1) ? DebugOut("ERROR: This record does not exist! \$LinkDatabaseRecord = $LinkDatabaseRecord") : 0;
									};
							} else {
								($SubDebug == 1) ? DebugOut("ERROR: Does not exist: \$LinkDatabaseRoot = \"$LinkDatabaseRoot\"") : 0;
								};
						};
					};
	
			$main::Config{sdb}{SearchResultDatabaseFile} = $main::Config{sdb}{uroot} . "$LinkDatabaseField". ".xml";
			($SubDebug == 1) ? DebugOut("Updating selectview temporary database file: \$main::Config{sdb}{SearchResultDatabaseFile} = $main::Config{sdb}{SearchResultDatabaseFile}") : 0;
			main::WriteIntConfig("config",\%ViewRecord,$main::Config{sdb}{SearchResultDatabaseFile});
			$main::Config{sdb}{selectview} = 1;
			$String =  main::lib_sdbview_viewrecords("$LinkDatabaseStructureFile","$main::Config{sdb}{SearchResultDatabaseFile}","$LinkDatabaseRoot","$LinkDatabase","");	
			} else {
				($SubDebug == 1) ? DebugOut("Could not obtain Link Records Keys.... \"$temp\"") : 0;
				};
		} else {
			($SubDebug == 1) ? DebugOut("ERROR \$RecordData{$ViewField} = \"$RecordData{$ViewField}\"") : 0;
			};
	} else {
		($SubDebug == 1) ? DebugOut("LinkDatabase and LinkDatabaseField  are not defined... or there is no record data....") : 0;
		};
return $String;
};
1;