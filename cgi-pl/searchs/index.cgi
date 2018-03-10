#!/usr/bin/perl

########################
# NO EDITING NECESSARY #
########################

print "Content-type: text/html\n\n";

require "variables.dat";

open (WORDS, "words.txt") or medie ("Can't open words.txt - $!");
my $words = join ('', <WORDS>);
close (WORDS);

$words =~ s/\r//isg;
$words =~ s/\n/\|/isg;

open (OUTPUT, ">searchindex.dat") or medie ("Can't open searchindex.dat - $!");

push @dirs, $basedir;

while (@dirs) {
   $dir = shift (@dirs);

   opendir (DIR, "$dir") or medie ("Can't open $dir - $!");
   my @files = readdir (DIR);
   closedir (DIR);

   foreach $file (@files) {

      if ((-d "$dir/$file") and ($file ne ".") and ($file ne "..")) {
         push @dirs, "$dir/$file";
         next;
      }

      next if ($file !~ /\.$ext$/i);

      open (FILE, "$dir/$file") or medie ("Can't open $dir/$file - $!");
      my $page = join ('', <FILE>);
      close (FILE);

      $page =~ s/(\n|\r|\t)/ /isg;

      my $title;
      if ($page =~ /<title>(.+?)<\/title>/i) {
         $title = $1;

      } else {
         $title = "No Title";

      }

      $page =~ s/<head>.+?<\/head>//isg;
      $page =~ s/<.+?>//isg;
      $page =~ s/\&.{2,6};/ /isg;

      my $description = $page;
      $description =~ s/\s+/ /isg;
      $description =~ s/^(.{255}).*/$1\.\.\./isg;

      $page =~ s/[\!@\#\$\%\^\&\*\(\)\[\]\{\}\+\=\|\\\/\.\,\_\-\~\`\'\"\;\:]/ /isg;
      $page =~ s/\b($words)\b//isg;
      $page =~ s/\s+/ /isg;
      $page =~ s/^(.{1024}).*/$1/isg;

      $thisdir = $dir;
      $thisdir =~ s/^$basedir//isg;
      my $URL = "$BaseURL$thisdir/$file";

      print OUTPUT "$URL|%%|$title|%%|$description|%%|$page\n";
      print "Indexed <a href=\"$URL\">$title</a>\n<br>\n";

      $| = 1;

   }

}

close (OUTPUT);

print "<br>Index Complete!";

sub medie {

my $message = shift;
print <<DEATH;
<html>
<head>
<title>Script Error</title>
</head>
<body>
<ul><b>Script Error</b>
<br><br>
$message
<br><br>
Make sure the required files are in the same directory as this script and are accessible by
the script.
</ul>
</body>
</html>
DEATH

}

exit 1;
