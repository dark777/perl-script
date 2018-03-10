<DIV style="font-family:verdana,sans-serif,arial;font-size=14pt; color:#333">
_config-command-description_
</DIV>
<DIV style="font-family:verdana,sans-serif,arial;font-size=8pt; color:#777">
Edit This Command Templates: 
[<a href="_config-user-linkid_&c=pedit&pfile=hfile-_form-option-c_" style="font-family:verdana,sans-serif,arial;font-size=8pt; color:#596">Form</a>]
 | [<a href="_config-user-linkid_&c=hedit&pfile=htfile-_form-option-c_" style="font-family:verdana,sans-serif,arial;font-size=8pt; color:#596">Page</a>]
 | [<a href="_config-user-linkid_&c=hedit&pfile=js-_form-option-c_" style="font-family:verdana,sans-serif,arial;font-size=8pt; color:#596">Header</a>]
 | [<a href="_config-user-linkid_&c=pedit&pfile=help-_form-option-c_" style="font-family:verdana,sans-serif,arial;font-size=8pt; color:#596">Help</a>]
<insert-redirect-adminmain>
</DIV>
<form method="post" name="registerform" action="_config-script-webpath_" target="_self" enctype="multipart/form-data">
<table style="width:100%; font-family:verdana,arial; font-size:8pt; background:#dec">
<tr>
<td><insert-newaction-data></td><td></td>
</tr>
<tr>
<td>New Action Name: </td><td><input type="text" name="newactionname" value="_form-option-newactionname_" size="80"/></td>
</tr>
<tr>
<td>New Action Description: </td><td><input type="text" name="newactiondescription" value="_form-option-newactiondescription_" size="80"/></td>
</tr>

<tr>
<td>
_config-user-formid_
<input type="submit" value=" Create New Action " />
<input type="hidden" name="c" value="_form-option-c_" />
<input type="hidden" name="sn" value="_form-option-sn_" />
<input type="hidden" name="default" value="_form-option-default_" />
</td><td></td>
</tr>
</table>
</form>


