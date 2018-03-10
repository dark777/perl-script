sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;

	if (($main::Form{pfile}) && ($main::Form{data}))	
	{
		if ($main::Form{pfile} =~ m!(\w[\d\w]*)-(\w[\d\w]*)!i)
		{
		my($Action) = $2;
			if ($1 =~ m!^hfile$!i)
			{
			unless ($main::HConfig{$Action}{name} =~ m!$Action!i) {$main::HConfig{$Action}{name} = "$Action" . ".cgi"};
			unless (-e ($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$Action}{name})) {main::SaveFile(($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$Action}{name}),"")};

				if (-f ($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$Action}{name}))
				{
				main::SaveFile(($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$Action}{name}),$main::Form{data});
				} else {
					
					};			
			} elsif ($1 =~ m!^js$!i)
			{
			unless ($main::JSConfig{$Action}{name} =~ m!$Action!i) {$main::JSConfig{$Action}{name} = "h_"."$Action" . ".cgi"};
			unless (-e ($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{name})) {main::SaveFile(($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{name}),"")};

				if (-f ($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{head}{name}))
				{
				main::SaveFile(($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{head}{name}),$main::Form{data});
				} else {
					
					};			
			
			} elsif ($1 =~ m!^css$!i)
			{
			unless ($main::CSSConfig{$Action}{name} =~ m!$Action!gi) {$main::CSSConfig{$Action}{name} = "$Action" . ".cgi"};
			unless (-e ($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name})) {main::SaveFile(($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name}),"")};

				if (-f ($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name}))
				{
				main::SaveFile(($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name}),$main::Form{data});
				} else {
					
					};				
			} elsif ($1 =~ m!^lib$!i)
			{
			my($LibFile) = 	$main::Config{LibFolder} . "act"."_"."$Action".".pl";			
			
				if (-f ($LibFile))
				{
				main::SaveFile($LibFile,$main::Form{data});
				} else {
					
					};				
			} elsif ($1 =~ m!^help$!i)
			{
				unless ($main::HelpConfig{$Action}{name} =~ m!$Action!i) 
				{
				$main::HelpConfig{$Action}{name} = "$Action" . ".cgi";
				$HelpConfig{$Action}{acl}{group} = "administrators";
				$HelpConfig{$Action}{acl}{user} = "none";
				$HelpConfig{$Action}{description} = "Description for Help file: $Action";
				main::WriteIntConfig("config",\%HelpConfig,$main::Config{HelpConfigFile});
				};
			unless (-e ($main::Config{TtsSubFolders}{help} . $main::HelpConfig{$Action}{name})) {main::SaveFile(($main::Config{TtsSubFolders}{help} . $main::HelpConfig{$Action}{name}),"")};
			
				if (-f ($main::Config{TtsSubFolders}{help} . $main::HelpConfig{$Action}{name}))
				{
				main::SaveFile(($main::Config{TtsSubFolders}{help} . $main::HelpConfig{$Action}{name}),$main::Form{data});
				} else {
					
					};				
				
			};
		};
	};
	
};

sub main::post_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
	if ($main::Form{pfile})	
	{
		if ($main::Form{pfile} =~ m!(\w[\d\w]*)-(\w[\d\w]*)!i)
		{
		($SubDebug == 1) ? DebugOut("\$main::Form{pfile} = \"$main::Form{pfile}\" Identified: ($1)-($2)") : 0;
		my($Action) = $2;	
			
			if ($1 =~ m!^hfile$!i)
			{
			($SubDebug == 1) ? DebugOut("Editing hfile file: $Action") : 0;
			unless ($main::HConfig{$Action}{name} =~ m!$Action!i) {$main::HConfig{$Action}{name} = "$Action" . ".cgi"};
			unless (-e ($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$Action}{name})) {main::SaveFile(($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$Action}{name}),"")};

				if (-f ($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$Action}{name}))
				{
				my($HFileContent) = join("",main::ReadFile(($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$Action}{name})));
				$HFileContent = main::lib_html_Escape($HFileContent);
					if ($main::Html{ServiceText} =~ m!(_insert-pedit-content_)!gis)
					{
					$main::Html{ServiceText} =~ s!$1!$HFileContent!is;
					} else {
						($SubDebug == 1) ? DebugOut("FAILED: Could not find pattern: \"_insert-pedit-content_\"") : 0;
						};			
				} else {
					$main::Html{ServiceText} =~ s!_insert-pedit-content_!!is;
					($SubDebug == 1) ? DebugOut("FAILED: File Not Present  \"($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$Action}{name})\"") : 0;					
					};							
			} elsif ($1 =~ m!^js$!i)
			{

			($SubDebug == 1) ? DebugOut("Editing js file: $Action") : 0;
			unless ($main::JSConfig{$Action}{name} =~ m!$Action!i) {$main::JSConfig{$Action}{name} = "h_"."$Action" . ".cgi"};
			unless (-e ($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{name})) {main::SaveFile(($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{name}),"")};

			
				if (-f ($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{head}{name}))
				{
				my($HFileContent) = join("",main::ReadFile(($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{head}{name})));
				$HFileContent = main::lib_html_Escape($HFileContent);
					if ($main::Html{ServiceText} =~ m!(_insert-pedit-content_)!gis)
					{
					$main::Html{ServiceText} =~ s!$1!$HFileContent!is;
					} else {
						($SubDebug == 1) ? DebugOut("FAILED: Could not find pattern: \"_insert-pedit-content_\"") : 0;
						};			
				} else {
					$main::Html{ServiceText} =~ s!_insert-pedit-content_!!is;
					($SubDebug == 1) ? DebugOut("FAILED: File Not Present  \"($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{head}{name})\"") : 0;					
					};			
							
			} elsif ($1 =~ m!^css$!i)
			{
			($SubDebug == 1) ? DebugOut("Editing css file: $Action") : 0;
			unless ($main::CSSConfig{$Action}{name} =~ m!$Action!gi) {$main::CSSConfig{$Action}{name} = "$Action" . ".cgi"};
			unless (-e ($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name})) {main::SaveFile(($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name}),"")};
			
				if (-f ($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name}))
				{
				my($HFileContent) = join("",main::ReadFile(($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name})));
				$HFileContent = main::lib_html_Escape($HFileContent);
					if ($main::Html{ServiceText} =~ m!(_insert-pedit-content_)!gis)
					{
					$main::Html{ServiceText} =~ s!$1!$HFileContent!is;
					} else {
						($SubDebug == 1) ? DebugOut("FAILED: Could not find pattern: \"_insert-pedit-content_\"") : 0;
						};			
				} else {
					$main::Html{ServiceText} =~ s!_insert-pedit-content_!!is;
					($SubDebug == 1) ? DebugOut("FAILED: File Not Present  \"($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name})\"") : 0;					
					};							
			} elsif ($1 =~ m!^lib$!i)
			{
				
			($SubDebug == 1) ? DebugOut("Editing css file: $Action") : 0;
			my($LibFile) = $main::Config{LibFolder} . "act"."_"."$Action".".pl";
				if (-f $LibFile)
				{
				my($HFileContent) = join("",main::ReadFile($LibFile));
				# $HFileContent = uri_escape($HFileContent);
				$HFileContent = main::lib_html_Escape($HFileContent);
					if ($main::Html{ServiceText} =~ m!(_insert-pedit-content_)!gis)
					{
					$main::Html{ServiceText} =~ s!$1!$HFileContent!is;
					} else {
						($SubDebug == 1) ? DebugOut("FAILED: Could not find pattern: \"_insert-pedit-content_\"") : 0;
						};			
				} else {
					$main::Html{ServiceText} =~ s!_insert-pedit-content_!!is;
					($SubDebug == 1) ? DebugOut("FAILED: File Not Present  \"$LibFile\"") : 0;					
					};				
			} elsif ($1 =~ m!^help$!i)
			{
			($SubDebug == 1) ? DebugOut("Editing help file: $Action") : 0;
			unless ($main::HelpConfig{$Action}{name} =~ m!$Action!i) {$main::HelpConfig{$Action}{name} = "$Action" . ".cgi"};
			unless (-e ($main::Config{TtsSubFolders}{help} . $main::HelpConfig{$Action}{name})) {main::SaveFile(($main::Config{TtsSubFolders}{help} . $main::HelpConfig{$Action}{name}),"")};
				if (-f ($main::Config{TtsSubFolders}{help} . $main::HelpConfig{$Action}{name}))
				{
				my($HFileContent) = join("",main::ReadFile(($main::Config{TtsSubFolders}{help} . $main::HelpConfig{$Action}{name})));
				$HFileContent = main::lib_html_Escape($HFileContent);
					if ($main::Html{ServiceText} =~ m!(_insert-pedit-content_)!gis)
					{
					$main::Html{ServiceText} =~ s!$1!$HFileContent!is;
					} else {
						($SubDebug == 1) ? DebugOut("FAILED: Could not find pattern: \"_insert-pedit-content_\"") : 0;
						};			
				} else {
					$main::Html{ServiceText} =~ s!_insert-pedit-content_!!is;
					($SubDebug == 1) ? DebugOut("FAILED: File Not Present  \"($main::Config{TtsSubFolders}{help} . $main::HelpConfig{$Action}{name})\"") : 0;					
					};					
			};




		} else {
			($SubDebug == 1) ? DebugOut("FAILED: Pattern Not identified: \"$main::Form{pfile}\"") : 0;
			};
	};

};



1;
