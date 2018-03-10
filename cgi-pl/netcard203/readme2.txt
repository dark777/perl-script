Este sistema cria um cartão de visitas on-line, permitindo a inclusão até de sua foto.
https://www.scriptbrasil.com.br/script/cgi/html/netcard203.zip
####################################
# NETCARD 2.03
# 
# Aytekin Tank
# email: aytekin@bridgeport.edu
# http://www.interlogy.com/scripts/netcard
# 
####################################

####################################
#
# STEP BY STEP SET UP IN 5 MINUTES:
#
####################################

 FILES YOU NEED:
 - netcard.htm		: form for addition
 - netcard2.pl		: netcard script 
 - netcard2.cfg		: configuration
 - up.cgi		: upload script 
 - readme2.txt		: Documentation

1) Open netcard.htm with notepad and change this address to your CGI-BIN directory:
<form action=http://interlogy.com/cgi-bin/netcard/netcard2.pl method=post>

2) Create the folder where the netcards to be placed:
	mkdir foldername

3) Copy netcard.htm and "images" folder into the folder. Uploaded files will be placed onto images folder.

4) Make the folders writable:
	chmod a+rw foldername 
	chmod a+rw foldername/images

5) Open netcard2.cfg with notepad and modify the variables. No need to modify netcard.pl or up.cgi. Everything you need is on the configuration file. Make sure the first lines of the "up.cgi" and "netcard2.cgi" is pointing to a Perl interpreter in your server.

6) Copy netcard2.pl, up.cgi and netcard2.cfg into your CGI-BIN (in ASCII mode)

7) Make the netcard2.pl and up.cgi executable:
	chmod a+rx netcard2.pl
	chmod a+rx up.cgi

8) Go to http://youraddress/foldername/netcard.htm and create your first netcard. Program will automatically create the list.htm file, where you can see the list of entries.

That's all. If you skip any step, program will probably not work or partially work. Fell free to send me an email to aytekin@bridgeport.edu about your opinions or questions. This script is totally FREE, so I can not promise for support. I can install and customize the script for you for a small amount. Don't forget to try Profile Manager: "http://www.interlogy.com/scripts/pm" 


####################################
#
# FOR ONLY WINDOWS NT USERS:
#
# I discovered that in NT you have to use
# whole root path for all operations, this only becomes 
# problem at this line, so you need to change 
# it to the whole path in "netcard.pl"
#
#	#Configuration File:
#	# if NT: put the full path
#	# like: require "netcard/cgi-bin/netcard2.cfg";
#	require "netcard2.cfg";
#
#
####################################
#
# UPGRADING FROM NETCARD 1.x:
#
####################################

-  change the name of list.htm file to the oldlist.htm, and do the process above. You must change the filename and delete the "list.htm". Otherwise it will not write on there.


####################################
#
# VERSIONS:
#
# Netcard 1.1 
# - Specify URL option for logos 
#
# Netcard 2
# - Upload option 
# - Preview 
# - Last come at the top list
# - Limited number of links in the list
# - Second address line
# - Checking inappropriate loginname or email
# - All HTML parts are configurable 
#
#  Netcard 2.1, 2.2 and 2.3 some bugs have been crashed
####################################
#
# COPYRIGHT NOTICE:
#
# Copyright 1998-99 Aytekin Tank.
#
# This program may be used and modified free of charge by anyone, so
# long as this copyright notice and the header above remain intact.
# Selling the code for this program without prior written consent is
# expressly forbidden.  Obtain permission before redistributing this
# program over the Internet or in any other medium.  In all cases
# copyright and header must remain intact.
#
# This program is distributed "as is" and without warranty of any
# kind, either express or implied. All responsibility is belong to 
# you if any damage or loss occurs.
####################################
# please send me an email to aytekin@bridgeport.edu
# about any bugs, problems or critics. Thank you.
####################################

