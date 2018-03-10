26th October 2001, LockedArea.com, DirectoryPass

- What is DirectoryPass?
DirectoryPass is a .htaccess management system.  It allows the user to administor both .htaccess and .htpasswd files to add and remove users.  It also creates .htaccess files and is compatiable with Cobalt RAQ .htaccess.  DirectoryPass allows administration of an unlimited number of .htaccess and .htpasswd files within a particular users account/server.

- License Agreement/Copyright Notice
Please read this before using DirectoryPass.

DirectoryPass may be used and modified free of charge by anyone so long as this copyright notice and the comments within remain intact. By using this code you agree to indemnify Neil Skirrow and LockedArea.com from any liability that might arise from its use.  Selling the code for this program without prior written consent is expressly forbidden. In other words, please ask first before you try and make money off of our program. Obtain permission before redistributing this software over the Internet or in any other medium.  In all cases copyright and header must remain intact.  We cannot be held responsible for any harm this may cause.

- Installing DirectoryPass
Firstly, open dirpass.cgi in your favourite text editor and edit the top line to represent the path to perl 5 on your web server.  The most common locations are #!/usr/bin/perl or #!/usr/local/bin/perl though it may be different.  If you are unsure, contact your system administrator.

Once that is done, scroll down to line 24 and modify the $adminpass variable.  This should be the password of your choice for using DirectoryPass.  It can be anything you like but it is recommended you only use alphanumberic characters. i.e. 0-9 and a-z.

Now that is done, save dirpass.cgi and upload it via FTP in ASCII mode to your web server.  Uploading in Binary will not work.

Now, set the permissions to 755, executable.  To do this you can either login to telnet and type chmod 755 dirpass.cgi.  If you're using a ftp program like CuteFTP or WsFTP you may find a CHMOD or Write Permissions option on the menu when selecting the dirpass.cgi file.

Once done, open your web browser and call up the dirpass.cgi file as you would for any other file on your web site.  You need to call it as follow:
dirpass.cgi? followed by the full path to the directory you wish to password protect.
e.g. dirpass.cgi?/home/username/dir/dir/

- Troubleshooting
If you have any problems, please feel free to visit the support forum.  Please don't email us requesting support, this is reserved for Locked Area Pro users.  We simply can't handle all the emails so we have to restrict the usage.

If you have trouble creating .htaccess and .htpasswd files, set the directory where you want them to be to 755 or 777.

- Bugs
If you think you've found a bug, please email bugs@lockedarea.com