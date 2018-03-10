#!/usr/bin/perl
#
###################
# Renamer
# Written by Mike Wheeler 6/24/96
# Copyright 1996, All rights reserved
#
# This script is for changing the file extension on all the files (with
# the original file extension) in a directory. For example to make all
# your .html files into .shtml files or .html files into .htm files.
##################

$file_dir = "/usr/home/cabiness/usr/local/etc/httpd/htdocs/cgi";
# This is the directory where all the files to be renamed are.

$ext1 = ".html";
# This is the original file extension (begiining with a period)

$ext2 = ".shtml";
# This is the new file extension (beginning with a period)

# That's it! Be sure to chmod the script to 755 and run it from the
# Unix shell (rather than your browser).
###################
opendir(FILES,"$file_dir");
@allfiles = grep(!/^\.\.?$/,readdir(FILES));
closedir(FILES);
foreach $file(@allfiles){
   $newfile = $file;
   $newfile=~ s/$ext1/$ext2/g;
   rename("$file_dir/$file","$file_dir/$newfile");
}
exit;
