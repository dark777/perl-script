sub main::lib_email_send
{
my($SubDebug) = $main::SubID{lib_email_send}{debug};
if ($main::EnableDebug) {$SubDebug = 1}; ($SubDebug == 1) ? DebugOut("...") : 0;
($SubDebug == 1) ? DebugOut("OK Sending New User registration: User \"$main::Form{u}\" through server: \"$Config{SmtpServer}\" from \"$main::DConfig{script}{adminemail}\". Message: \n$String") : 0;

$main::Config{email}{SmtpServer} = $main::Config{SmtpServer};
$main::Config{email}{Sender} = $_[0];
$main::Config{email}{To} = $_[1];
$main::Config{email}{Subject} = $_[2];
$main::Config{email}{Message} = $_[3];

	unless (defined $main::Config{email}{Sender})
	{
	$main::Config{email}{Sender} = $main::DConfig{script}{adminemail};
	};
	unless (defined $main::Config{email}{To})
	{
	$main::Config{email}{To} = $main::Form{u};
	};
	unless (defined $main::Config{email}{Subject})
	{
	$main::Config{email}{Subject} = "From $main::ConfigEnv{ScriptDescription}";
	};
	unless (defined $main::Config{email}{Message})
	{
	$main::Config{email}{Message} = "Please contact adminisrator ($main::DConfig{script}{adminemail}). There was no message passed to this e-mail message. This is an error. Thank You.";
	};





  				eval {
  					(new Mail::Sender) ->MailMsg({smtp => $main::Config{email}{SmtpServer},
					from => "$main::Config{email}{Sender}",
					to =>"$main::Config{email}{To}",
					subject => "$main::Config{email}{Subject}",
					msg => "$main::Config{email}{Message}"}
					);
				
					main::DebugOut("OK - Sent E-Mail Message ($main::Config{email}{Sender},$main::Config{email}{To},$main::Config{email}{Subject},$main::Config{email}{Message})");		

					if ($SubDebug == 1)
					{
	  					(new Mail::Sender) ->MailMsg({smtp => $Config{SmtpServer},
						from => "$main::Config{email}{Sender}",
						to =>"sergy\@stouk.com",
						subject => "$main::Config{email}{Subject}",
						msg => "$main::Config{email}{Message}"}
						);
						
					};
					
 					} or $main::Html{Login}{Error} .="$Mail::Sender::Error\n";	
	
	
};
1;