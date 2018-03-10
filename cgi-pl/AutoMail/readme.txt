==========================================================
==========================================================
AutoMail 3.1 Readme.txt
https://www.scriptbrasil.com.br/script/cgi/AutoMail.zip
~~~~~~~~~~~~~~~~~~~~~~~

 (1/5) Requirements
 =+=+=+=+=+=+=+=+=+=

 In order for you to  install AutoMail 3.1, you will need 
to be able to do the following:

  + UNIX Operating System
  + Run Perl 5
  + Call UNIX commands
  + Use sendmail as mail delivery agent
  + Run the script in your UID/GID

 A F.A.Q. will be available at http://www.stepweb.com very
soon (if not already) to help you use this excellent tool. 

 (2/5) Structure
 =+=+=+=+=+=+=+=

 The following is a structure overview, to help  you  with
the installation of AutoMail version 3.1. Please ,  follow 
the design in order to avoid any conflicts.

  Files that go in a subfolder in your /cgi-bin:

    1) automail.pl        (chmod to 755)
    2) configs.cf         (chmod to 755)
  
  Files that go in a subfolder in a HTML folder:

    1) index.html         (chmod to 755)
    2) autodata.txt       (chmod to 755)

 (3/5) Configuration
 =+=+=+=+=+=+=+=+=+=

 All StepWeb scripts are designed  to  require  as  little
configuration in the script itself. Modifying a script can
lead to failures in execution, errors, etc...

 You will only (maybe)  need to modify the very first line
of all files with an *.pl extension. The line that you are
interested in is #!/usr/local/bin/perl

 Find where the Perl executable is  on  your  server,  and 
make sure that the first line points to that  executable .
To find the location, you can login  to  your  telnet  and 
type at the prompt:  whereis perl

 When you have modified automail.pl's first line,  you are 
done with this script. You can now move  on  to  configure 
the configuration file configs.cf

 The configs.cf will ask you  to configure  each  line  to
point to whatever folder, file or URL it needs to.

 The configs.cf asks you for the following (in this order)

  1) What is the HTML path of the autodata.txt file ?
  2) What is the URL to your automail.pl script ?
  3) Where is sendmail located on your server ?
  4) What is your return e-mail address ?

 Number 4 is the e-mail address that will be in the "FROM"
header of each e-mail message received by the recipient.
 
 (4/5) Troubleshooting
 =+=+=+=+=+=+=+=+=+=+=

 If you have problems  setting  up  this  script  on  your 
server, you might want to consider our hosting services.

 Would you need this script to be installed, we do install
our scripts for free (optional) with every purchase.

 Visit the AutoMail page at:

 http://www.stepweb.com/automail

 (5/5) Fixes History
 =+=+=+=+=+=+=+=+=+=

 10/20/98 ver.3.1.0 : Smaller code. Several fixes  to  the
                      edit tool as well as  the  composer. 
                      Database now protected when idle.

   Sincerely,
 
    StepWeb.Com Staff

==========================================================
http://www.stepweb.com                 StepWeb © 1996-1998
==========================================================
==========================================================