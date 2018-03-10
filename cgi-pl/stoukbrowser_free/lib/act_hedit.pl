# Action library for hedit
sub main::pre_act_process
{
my($SubDebug) = $main::SubID{pre_act_process}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
# Insert Code to execute before Template generation
	if (($main::Form{htfile}) && ($main::Form{econtent}))	
	{
		if ($main::Form{htfile} =~ m!(\w[\d\w]*)-(\w[\d\w]*)!i)
		{
		my($Action) = $2;
			if ($1 =~ m!^hfile$!i)
			{
				if (-f ($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$Action}{name}))
				{
				main::SaveFile(($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$Action}{name}),$main::Form{econtent});
				} else {
					
					};			
			} elsif ($1 =~ m!^js$!i)
			{
				if (-f ($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{head}{name}))
				{
				main::SaveFile(($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{head}{name}),$main::Form{econtent});
				} else {
					
					};			
			
			} elsif ($1 =~ m!^css$!i)
			{
				if (-f ($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name}))
				{
				main::SaveFile(($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name}),$main::Form{econtent});
				} else {
					
					};				
			} elsif ($1 =~ m!^htfile$!i)
			{
				if (-f ($main::Config{TtsSubFolders}{html} . $main::HTMLConfig{$Action}{name}))
				{
				main::SaveFile(($main::Config{TtsSubFolders}{html} . $main::HTMLConfig{$Action}{name}),$main::Form{econtent});
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
# Insert Code to execute After Template generation
	if ($main::Form{htfile})	
	{
		if ($main::Form{htfile} =~ m!(\w[\d\w]*)-(\w[\d\w]*)!i)
		{
		($SubDebug == 1) ? DebugOut("\$main::Form{htfile} = \"$main::Form{htfile}\" Identified: ($1)-($2)") : 0;
		my($Action) = $2;	
			
			if ($1 =~ m!^hfile$!i)
			{
			($SubDebug == 1) ? DebugOut("Editing hfile file: $Action") : 0;
				if (-f ($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$Action}{name}))
				{
				my($HFileContent) = join("",main::ReadFile(($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$Action}{name})));
				$HFileContent = main::lib_html_Escape($HFileContent);
					if ($main::Html{ServiceText} =~ m!(_insert-htedit-content_)!gis)
					{
					$main::Html{ServiceText} =~ s!$1!$HFileContent!is;
					} else {
						($SubDebug == 1) ? DebugOut("FAILED: Could not find pattern: \"_insert-htedit-content_\"") : 0;
						};			
				} else {
					$main::Html{ServiceText} =~ s!_insert-htedit-content_!!is;
					($SubDebug == 1) ? DebugOut("FAILED: File Not Present  \"($main::Config{TtsSubFolders}{hfile} . $main::HConfig{$Action}{name})\"") : 0;					
					};							
			} elsif ($1 =~ m!^js$!i)
			{

			($SubDebug == 1) ? DebugOut("Editing js file: $Action") : 0;
			
				if (-f ($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{head}{name}))
				{
				my($HFileContent) = join("",main::ReadFile(($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{head}{name})));
				$HFileContent = main::lib_html_Escape($HFileContent);
					if ($main::Html{ServiceText} =~ m!(_insert-htedit-content_)!gis)
					{
					$main::Html{ServiceText} =~ s!$1!$HFileContent!is;
					} else {
						($SubDebug == 1) ? DebugOut("FAILED: Could not find pattern: \"_insert-htedit-content_\"") : 0;
						};			
				} else {
					$main::Html{ServiceText} =~ s!_insert-htedit-content_!!is;
					($SubDebug == 1) ? DebugOut("FAILED: File Not Present  \"($main::Config{TtsSubFolders}{js} . $main::JSConfig{$Action}{head}{name})\"") : 0;					
					};			
							
			} elsif ($1 =~ m!^css$!i)
			{
			($SubDebug == 1) ? DebugOut("Editing css file: $Action") : 0;
			
				if (-f ($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name}))
				{
				my($HFileContent) = join("",main::ReadFile(($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name})));
				$HFileContent = main::lib_html_Escape($HFileContent);
					if ($main::Html{ServiceText} =~ m!(_insert-htedit-content_)!gis)
					{
					$main::Html{ServiceText} =~ s!$1!$HFileContent!is;
					} else {
						($SubDebug == 1) ? DebugOut("FAILED: Could not find pattern: \"_insert-htedit-content_\"") : 0;
						};			
				} else {
					$main::Html{ServiceText} =~ s!_insert-htedit-content_!!is;
					($SubDebug == 1) ? DebugOut("FAILED: File Not Present  \"($main::Config{TtsSubFolders}{css} . $main::CSSConfig{$Action}{name})\"") : 0;					
					};							
			} elsif ($1 =~ m!^htfile$!i)
			{
			($SubDebug == 1) ? DebugOut("Editing htfile file: $Action") : 0;
			
				if (-f ($main::Config{TtsSubFolders}{html} . $main::HTMLConfig{$Action}{name}))
				{
				my($HFileContent) = join("",main::ReadFile(($main::Config{TtsSubFolders}{html} . $main::HTMLConfig{$Action}{name})));
				$HFileContent = main::lib_html_Escape($HFileContent);
					if ($main::Html{ServiceText} =~ m!(_insert-htedit-content_)!gis)
					{
					$main::Html{ServiceText} =~ s!$1!$HFileContent!is;
					} else {
						($SubDebug == 1) ? DebugOut("FAILED: Could not find pattern: \"_insert-htedit-content_\"") : 0;
						};			
				} else {
					$main::Html{ServiceText} =~ s!_insert-htedit-content_!!is;
					($SubDebug == 1) ? DebugOut("FAILED: File Not Present  \"($main::Config{TtsSubFolders}{html} . $main::HTMLConfig{$Action}{name})\"") : 0;					
					};							
			};
		} else {
			($SubDebug == 1) ? DebugOut("FAILED: Pattern Not identified: \"$main::Form{htfile}\"") : 0;
			};
	};
};
1;
