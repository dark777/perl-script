This is a calendar JScript.
To use this inside any other page of the System copy and paste the following to the other command's form:

<IFRAME SRC="_config-user-linkid_&c=calendar2" name="iframe-calendar2" border="0" width="170" height="160" scrolling="no"></IFRAME>


Or this is a Perl Script example:

$main::Config{$main::Form{c}}{ok} .= 
qq(
<IFRAME 
SRC="$main::UserEnv{href}&c=calendar2&sn=$main::Form{sn}" 
name="iframe-wmsadmin" 
border="0" 
width="170" 
height="160" 
scrolling="no">
</IFRAME>
);
