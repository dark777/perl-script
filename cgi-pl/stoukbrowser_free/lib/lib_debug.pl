##############################################################################
sub lib_debug_DebugHash
{
use constant INDENT => "\t ";
if (defined $_[2])
{
	open (OUT, ">$_[2]") || warn "Util:: Cannot write to $_[2]: error $!\n";
	 my ($name, $hash) = @_;
# print OUT  '<?xml version="1.0" encoding="utf-8" ?>',"\n";	

	 print OUT  "<$name>\n";
	
	 dump_contents($hash, 1);
	
	 print OUT  "</$name>\n";
	
		sub dump_contents {
		 my ($hash, $indent) = @_;
		
		 for (sort (keys %$hash)) {
	
		   print OUT  INDENT x $indent;
	
		   if ((ref $hash->{$_}) && ($hash->{$_} =~ m!^HASH!) ) {
		     print OUT  "<$_>\n";
	
		     print OUT dump_contents($hash->{$_}, $indent + 1);
	
		     print OUT INDENT x $indent , "</$_>\n"
		   }
		   else { 
		   	if ($hash->{$_}) {print OUT "<$_>".$hash->{$_}."</$_>\n";};
		   	
		   	}
		 }
		}
	
	close OUT;
};
};
##############################################################################
1;