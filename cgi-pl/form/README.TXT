UM ÓTIMO FORMULÁRIO DE LOJA VIRTUAL
https://www.scriptbrasil.com.br/script/cgi/form.zip

                    BigNoseBird.Com's 
                        - - - - -
                 All Purpose Form Handler

                    FOR UNIX & WINDOWS

NOW ON VERSION 4.0
------------------

Updated January 31, 2000

   Improved security features. Arbitrary file requests are
   prevented by the script appending a unique extension to
   each file type. File names and e-mail addresses are
   are checked for possible exploit attempts.

   Multiple recipients and cc's are now supported.

   Thank you page now shows submitted information.


ABOUT THE NEW FILENAME SYSTEM:

In order to prevent people from being able to overwrite
or read from files on your server, you MUST set up your
file names in the following way. Each item such as
automessage, is given an extension automatically by
the script. Do not include the extension in the VALUE
part of the HIDDEN INPUT tag. This is how the exploit
attempts are blocked. The list below shows the extension
associated with each file type.

<INPUT TYPE="HIDDEN" NAME="automessage" VALUE="mymessage">

  the file MUST be named mymessage.baut when you
  save it on the server.

<INPUT TYPE="HIDDEN" NAME="outputfile" VALUE="form1">

  the script will create form1.bout

<INPUT TYPE="HIDDEN" NAME="countfile" VALUE="form1">

  the script will create form1.bcnt

<INPUT TYPE="HIDDEN" NAME="emailfile" VALUE="form1">

  the script will create form1.bemf


This program, bnbform.cgi is designed to allow you to 
quickly implement your HTML based forms. The program
is configured by information you provide in the form
itself, so you can get the script to handle your data
in a variety of ways without changing your scripts.
Without writing one line of perl code, you can do
the following (in any combination!):

  1.) Submit E-mail to a specified person(s) and CC 
      as well.
  2.) Send the data to a file for easy import into a 
      database program.
  3.) Automatically send a resonse to the submitter,
      with a text file to contain your message.
  4.) Define the order the data is printed.
  5.) Enforce completion of specified fields.
  6.) Define a page for a "Thank you" or an "Oops!" 
      message after the form is submitted.


I.   GETTING READY TO INSTALL
----------------------------
Included in this zip or tar file you will find the 
following files:

FILE NAME      DESCRIPTION
---------      -----------
README.TXT     The file you are reading!
bnbform.cgi    The script
bnbform.html   A sample form
mymessage.baut  A sample autoreponse message
oops.html      A sample HTML page for incomplete data
thanks.html    A sample HTML page for saying thanks!

NOTE: PLEASE READ THE Q&A BELOW, IT CONTAINS SOME
USEFUL SETUP INFORMATION!

In order to install the script, you should only have
to find out the answers to the following questions:

   Q: Where is perl on my server?
   A: On some systems it is /usr/local/bin/perl but it
      may be in /usr/bin/perl or /usr/sbin/perl. The very
      first line of the script says,
      #!/usr/bin/perl
      This MUST be the first line of the script with nothing
      including blank lines above it. If your "perl" is not
      there, edit this line so that it is correct for your
      system.

   Q: What is an SMTP server?
   A: This is the computer that handles your domain's e-mail,
      but you can also use your ISP's mail server as well 
      (usually). On most systems, the "localhost" will work
      just fine. 

   Q: Where is my cgi-bin directory?
   A: This varies. Please check with your system 
      administrator or system FAQ if you do not know
      this.

   Q: How do I call a cgi-bin script from a form?
   A: On my system, this does the trick:
      <FORM METHOD="POST" ACTION="/cgi-bin/bnbform.cgi">
      Again, this can vary from server to server so 
      please consult your server FAQ or your system
      administrator.

   Q: How do I set file permissions?
   A: Once the files are installed, using FTP, you want
      to set the permissions on bnbform.cgi so that
      they are the equivalent of 755. This means that
      the owner can read-write-execute, group can 
      read-execute, and others can read-execute. If you
      can login using telnet, you can issue the command:
           chmod 755 bnbform.cgi
      You must "cd" to the directory containing the 
      script before doing this.
      For specific instructions on setting permissions
      using FTP, please see the "HELP" for your FTP 
      program.

II.  INSTALLING THE FILES ON YOUR SERVER
----------------------------------------

Edit the bnbform.cgi to make sure the path to perl is 
correct, i.e.,

#!/usr/local/bin/perl

Edit the bnbform.html to make sure you are calling the
script properly, i.e.,

      <FORM METHOD="POST" ACTION="/cgi-bin/bnbform.cgi">
Also, change the e-mail address of the "submit_to" and
the http://domain.com/oops.html and http:domain.com/thanks.html
so that they are correct for your domain. You may delete the
lines containing the ok_URL and not_ok_URL if you want.

Using FTP, transfer the following files using ASCII mode.
NEVER USE BINARY TO TRANSFER TEXT FILES FROM A PC TO A 
UNIX SERVER!!!!!

FILE           LOCATION
bnbform.cgi    cgi-bin directory
mymessage.baut  cgi-bin directory
bnbform.html   your webpage directory
oops.html      your webpage directory
thanks.html    your webpage directory

Set the permissions on bnbform.cgi to 755 which
means the owner can read-write-execute, group can
read-execute, and others can read-execute. (This
was one of the questions above!)

Guess what? That's it! Installation is complete
and you can test the script using the bnbform.html
that is included- after you edit it as described 
above.

III. CONFIGURING THE FORM FOR YOUR NEEDS
----------------------------------------
The bnbform.cgi script is very simple, and very flexible. 
How it works, is that it looks at the form's data for the 
existence and content of some special fields, most of 
which are HIDDEN so the reader doesn't see them. Here are
a list of the magic fields:


IMPORTANT NOTE: ALL FIELD NAMES AND VALUES ARE CASE SENSITIVE!
                To keep things simple- just use lower case. 

submit_by:   The e-mail address of the person completing the
             form. You should make this required if you are
             using autorespond.

required:    A list seperated by commas "," listing ALL fields
             you wish to enforce data completion on. As an
             example:
             <INPUT TYPE="HIDDEN" NAME="required" 
              VALUE="name,country,submit_by">

data_order:  In order for your information to show up in a file
             or in your e-mail, you MUST list each field you want
             to see in this comma "," separated list. This also
             specifies the order the data will be printed to mail
             and to file. Here is an example:
             <INPUT TYPE="HIDDEN" NAME="data_order" 
                VALUE="name,country,submit_by,mailing_list,how_found,
                       grape,banana,apple">

submit_to:   The person to receive the e-mail. Example
             <INPUT TYPE="HIDDEN" NAME="submit_to" 
                VALUE="yourname@domain.com">
             You do not have to indicate a "submit_to"
             if you are sending the information to a file,
             and don't need e-mail notification.
             You can use more than one e-mail address, just put commas
             between them, VALUE="person1@x.com,person2@y.com"

cc_to:       In addition to submit_to, you can also specify additional,
             CC recipient(s). 
             <INPUT TYPE="HIDDEN" NAME="cc_to" 
                VALUE="anotherperson@domain.com">
             You can use more than one e-mail address, just put commas
             between them, VALUE="person1@x.com,person2@y.com"

automessage: A textfile containing a message to go out as the
             body of an autorespond e-mail. Example,
             <INPUT TYPE="HIDDEN" NAME="automessage" 
                VALUE="mymessage">
             ***You can also specify the actual path to the file
                if you will be running this outside of the main
                cgi-bin directory- or if you want the data elsewhere.

outputfile:  This tells the system you want to log information,
             and what to name the file. The script will create
             the file with proper permissions for you.
             <INPUT TYPE="HIDDEN" NAME="outputfile" 
               VALUE="form1">
             ***You can also specify the actual path to the file
                if you will be running this outside of the main
                cgi-bin directory- or if you want the data elsewhere.

emailfile:   Configured as above. Saves only the sender's email address.

countfile:   Configures like outputfile(above). Stores a counter number
             for "Bates" Stamping your mail. The number is available as
             $newnum or $fields{'counter'} to the script.

form_id:     Optional. Forms part of the subject in to
             the e-mail to the person receiving the data.
             This helps them know which form it came from.
             <INPUT TYPE="HIDDEN" NAME="form_id" 
                VALUE="My Test Form">

ok_url:      A URL to jump to after successfully completing
             the form. If this is not on the form, a default
             "Thank you" message appears.
             <INPUT TYPE="HIDDEN" NAME="ok_url" 
                 VALUE="http://domain.com/test/thanks.html">
             You MUST specify the full URL as shown above!
             OPTIONAL!

not_ok_url:  A URL to jump to after not filling in all the
             required fields on the form. If this is not 
             on the form, a default "Oops" message appears.
             <INPUT TYPE="HIDDEN" NAME="not_ok_url" 
                VALUE="http://domain.com/test/oops.html">
             You MUST specify the full URL as shown above!
             OPTIONAL!



IV.  VARIOUS CONFIGURATION SCENARIOS
------------------------------------
              
Field Name   Datafile   E-Mail   Auto-Respond   A-R with Message
----------   --------   ------   ------------   ----------------
submit_to                 X
----------------------------------------------------------------
submit_by                             X                X
----------------------------------------------------------------
autorespond                           X                X
----------------------------------------------------------------
outputfile      X
----------------------------------------------------------------
automessage                                            X
----------------------------------------------------------------

For datafile and autorespond:
  submit_by
  autorespond
  outputfile

For datafile and autorespond with custom message:
  submit_by
  autorespond
  outputfile
  automessage

For e-mail notify and autorespond:
  submit_to
  submit_by
  autorespond

For e-mail notify and autorespond with custom message:
  submit_to
  submit_by
  autorespond
  automessage

For the whole enchilada!!!!!!
  submit_to
  submit_by
  autorespond
  outputfile
  automessage


V.   THINGS YOU NEED TO KNOW....
--------------------------------

About CHECKBOX fields... Eventhough you can have multiple 
CHECKBOX fields with different values- DON'T DO IT! This
script only picks up the last checked item. 

Since information might be going to a datafile, it would
be nearly impossible for you to get uneven columns of data
straightened out. Use different names for each field.


VI.  COOL TRICKS
----------------

Let's say you have more than one person you may need to send
the mail to depending on the form. What you can do is place 
the submit_to in a set of radio buttons, i.e.,

  <INPUT TYPE="RADIO" NAME="submit_to" VALUE="support@x.com" CHECKED>Support
  <INPUT TYPE="RADIO" NAME="submit_to" VALUE="sales@x.com">Sales
  <INPUT TYPE="RADIO" NAME="submit_to" VALUE="billing@x.com">Billing
  <INPUT TYPE="RADIO" NAME="submit_to" VALUE="pres@x.com">President

  Note that I have indicated CHECKED next to support. This way there
  is a default value.

