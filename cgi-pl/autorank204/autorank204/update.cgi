#!/usr/bin/perl
require "config.pl";
print "Content-type: text/plain\n\n";
&getData;
for (@sorted_data) {
  &drop("Database has already been updated") if(m/\.\mdf/gi);
  
  rename("$data_dir/$_", "$data_dir/$_.mdf") || &drop("Cannot rename member data file $_");
  open(DATA, "$data_dir/$_.mdf") || &drop("Cannot open member data file $_.mdf");
  $line = <DATA>;
  close(DATA);
  
  open(BACKUP, ">$data_dir/$_.bdf") || &drop("Cannot open member data file $_.bdf");
  print BACKUP "$line";
  close(BACKUP);
  
  open(IP, ">$data_dir/$_.idf") || &drop("Cannot open member data file $_.idf");
  close(IP);
}
print "Update complete!";

sub drop {
  $why = shift;
  print "$why: $!\n";
  exit;
}