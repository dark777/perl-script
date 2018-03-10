#######################################################
#		Top Sites Professional
#     
#    	Created by Solution Scripts
# 		Email: solutions@solutionscripts.com
#		Web: http://solutionscripts.com
#
#######################################################
#
#
# COPYRIGHT NOTICE:
#
# Copyright 1998 Solution Scripts  All Rights Reserved.
#
# Selling or redistributing the code for this program
# without prior written consent is expressly forbidden.
# In all cases copyright and header must remain intact.
#
######################################################


INSTALLATION INSTRUCTIONS - Version 3.04

This is for new setups only, if you are upgrading
from a version 2.31 or lower, please go to the following url
http://solutionscripts.com/man/topsitespro/upgrade.shtml

#######################################################

There are baically three easy steps to getting Top Sites
Professional to run. Once you get it to run, all of the 
configuring is done from the admin.cgi script via a browser.

Step 1.

Check the path to perl on all the .cgi files. If your path to
perl is different from #!/usr/bin/perl you will need to change
that on the top of all scripts. If you are unsure what the correct
path is, ask your system admin. Top Sites Pro. needs perl5 to run
so make sure it points to perl 5, not perl 4.

Step 2.

Log into your account via ftp. Go to the dir you want the cgi files
to be in, this dir must be chmoded to 777. Now upload all file to
this dir. This is important, UPLOAD ALL FILES IN ASCII, or the scripts
will not work at all.

Step 3. 

While still in ftp, you must chmod the following files.

topsites.cgi - 755
out.cgi - 755
editmember.cgi - 755
admin.cgi - 755
create.cgi - 755
variables.pl - 666


Thats it, all files should run.....

Now first call up admin.cgi with a browser. It should prompt
you to enter 9 important variables, one or two steps at a time.

Once that has been completed it will take you to the main admin screen
From there you should set a few more confid variables, to get the rankings
page the way you want it to look. From the drop down list near the top of the
page, select "General Operations" and press the "Edit" button. After you have
editted those variables, select one at a time the rest of the items in the drop
down list.

Should you have any problems or questions, we have created a forum for just
Top Sites Professional owners at http://solutionscripts.com/forum and select
the Top Sites Professional forum from the list. Or you can email us at
solutions@solutionscripts.com

Solution Scripts
http://solutionscripts.com

########## STATS FOR SOLUTION SCRIPTS ##########
Solution Scripts wants to know more about its customers and what kind of
abuse our scripts can stand up too. Instead of manually emailing and asking
everyone about their system, we've implemented a completely optional
stats feature into version 3.04. This stats feature sends the following information 
to a cgi on our site. Total number of members, Total hits out, Total hits in, Version
of perl, and server software. If you do not want your site sending us this information
all you have to do is set the variable on the top of admin.cgi to 1, as shown.....

$no_stats = 1;

This call to our web site returns a blank image, but may sometime may be used to display
an image containing current Top Sites news.

