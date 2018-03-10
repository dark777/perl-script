Sistema de busca interna
https://www.scriptbrasil.com.br/script/cgi/sistema_de_busca/searchs.zip
readme.txt for SFE Search

This script is freeware. You may modify it to suit your needs, and you may distribute it, but you may NOT do both. You can only distribute this script in it's origional form, and if you modify it, you may only do so to suit your own needs and may NOT charge someone to install or modify this script.

**********************
USAGE

* * * STEP 1 * * *
To use, you must first set a few variables. Open up variables.dat in Notepad or another text editor. The first variable is called $basedir. This needs to be set to the directory on the server that this script is to start in. An example would be your document root.

It should look something like one of the following:

   $basedir = "/home/domain/public_html";
   $basedir = "/usr/home/www";

NOTE: Do not end the path with a slash.

You may need to ask your system administrator for the path to your document root. The script does not detect this automatically, as some people do not want their entire domain indexed - they may wish to limit it to a particular section within a subdirectory.

The next variable, $BaseURL, is the actual URL to the above mentioned directory. This would be the URL you would use to access the desired server path from the web.

NOTE: Do not end the URL with a slash.

The final variable sets what file extentions should be indexed. Separate multiple extentions with a pipe (|). Do not put a pipe at the beginning or end of the string, and don't add one if you are going to limit to just one extention. Some examples are:

   $ext = "htm|html";
   $ext = "html|asp|txt";
   $ext = "shtml";

Note that they are not case sensitive.

* * * STEP 2 * * *
Next, you will need to upload the following files to a cgi enabled directory (cgi-bin, for example):

   search.cgi
   index.cgi
   results.html
   variables.dat
   words.txt
   searchindex.dat

Note that you will probably want to create a subdirectory in your cgi-bin if you have other scripts in there, to avoid confusion. Make sure you upload ALL files in ASCII or TEXT mode, NOT BINARY. This is the most common reason for script failure in America today.

Now you need to make sure the following files are executable:

   search.cgi
   index.cgi

On most servers, you would need to chmod these files to 755 or 777 to make them executable. Also make sure searchindex.dat is writable by the script. On most servers, you would it to 777.

The remaining files only need to be readable by the script and probably do not need to be changed. All files above MUST be in the same directory for the script to work.

The only file that needs to be within the document root is search.html - this is to serve as a sample search form. You can and should edit it to suit your site.

* * * STEP 3 * * *
Now you will need to index your site. To do this, point your browser to your index.cgi file and the indexing should begin. For example, if you put it in your cgi-bin, go to http://www.YourDomain.com/cgi-bin/index.cgi.

It should print a list of all of the files it has indexed. On a larger site it is possible that the script could time out before being able to index the whole site - this script is primarily intended for small to medium sized sites. If it does time out, you should still be able to search what has been indexed.

Now you should call search.html from your web browser and try a search. Note that this script will not index words contained in the words.txt file - you can add or remove from this file, depending on your needs. It contains common words that shouldn't be indexed for searching. The format is one word per line.

* * * STEP 4 * * *
Now that the script is working properly, it is time for some customization :)  You should open up results.html in any text editor or HTML editor. Just note that the comments within this file are replaced by the script at run time by the output of the script.

   <!-- KEYWORDS -->
   This is replaced with the words the user searched for.

   <!-- RESULTS -->
   This is replaced with the actual search results, 10 results per page.

   <!-- LINK -->
   This is replaced with the "<< Prev | Next >>" links, if applicable.

Note that the order does not matter - you can place the link above or below the search results, etc. You may also wish to include a search box on the results page (see the example page) to allow the user to search again. Also note that they are CASE SENSITIVE.

The format of the search form is simple. There are 3 fields:

   Q - The search words
   X - Set to any non-zero value to find exact match only, otherwise it will match any keywords
   E - Set to any non-zero value to search the entire document, otherwise it will only search the title.

You can use GET or POST method - both will work exactly the same. If you are familiar with HTML forms, you should have no problems adding a search box to any page you like within your site.

*********************************************************
Always visit http://www.hostfacts.com/scripts/ for the latest Perl or PHP scripts by SFE Software.
(c) 1999 Justin Nelson, SFE Software
All Rights Reserved.