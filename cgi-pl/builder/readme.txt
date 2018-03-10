Sempre quis ter seu própril Geosites? Este sistema permite a proteção di diretórios, 
painel de controle, atributos no uso do disco, icones, extenções permitidas e muito mais.

ELite Web Page Builder 1.3
--------------------------

WARNING: The first time that you call the CGI script, you will see an easy setup
form. Just fill out all the forms, (CLICK ON "HELP" next to each object, it will tell you what 
to do)
If you make a mistake when typing one of the directory, and acciddentally clicked Finish,
you can redo that whole form, by delteing all the text in the "prefs" file and than just type
it "1;" (no quotation marks ("")) on the first line, then open a new window and call the script
again. Once you are done with the form it will say "Done!" and you can start
using your script.


--------------
Since this is an early release we dont have alot of documentation...

SETUP --->
----------
Just upload the following files to the same directory:

prefs
folder.jpg
intranet.pl
cgi-lib.pl


Then, in that same directory, make a directory called: tmp 

You should make them chmod 777 or if you are using ws_ftp right click
on the file and click chmod(unix) then check all the check boxed and 
click ok,... What this does is, it lets owner, group, and other, read
write and execute the file.

Then create a directory to hold all the users files (MUST BE ACCISSIBLE THROUGH THE WEB)
THen in that directory create a folder called admin...
then do the CHMOD 777 to those 2 directories as written above.
THen run the script...

THen mupload the file named passfile to a non-web accessible directory.
THen run the setup
If on the first time you use this script, you recieve an error:
IF YOU ARE USING UNIX -->
   1. make sure you have the right perl path (the first line of the file) in intranet.pl
   2. Make sure that you have a file named prefs in the same directory as the intranet.pl
   3. Make sure you set up the directories as it says below;
   4. Contact Us --> elite@elitehosts.com
IF you are using windows -->
   1. make sure you have the right perl path (the first line of the file) in intranet.pl
   2. Make sure that you have a file named prefs in the same directory as the intranet.pl
   3. Make sure you set up the directories as it says below;
   4. Find the line in intranet.pl that says require "prefs";
      and then earase that and type in: require "C:/path/to/prefs";  
      replace C:/path/to/prefs with the full filename of the prefs file.
   5. Contact us --> elite@elitehosts.com
URLS:
To add a user goto http://yoursite.com/cgi-bin/intranet.pl?action=Add User
To delete a user goto http://yoursite.com/cgi-bin/intranet.pl?action=Delete User

(Replace http://yoursite.com/cgi-bin/ with the path to the intranet.pl file)
the first time you log on, use the username admin and the password admin

P.S. WE LOVE FEEDBACK
If you have any questions or comments, please e-mail elite@elitehosts.com
Please check back for newer versions and documentations.