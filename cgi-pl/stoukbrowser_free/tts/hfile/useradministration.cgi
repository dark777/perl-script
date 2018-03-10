<DIV style="font-family:verdana,sans-serif,arial;font-size=14pt; color:#333">
_config-command-description_
</DIV>
<form method="post" name="registerform" action="_config-script-webpath_" target="_self">
<table style="width:100%;  font-family:verdana,arial; font-size:8pt; background:#eba">

<tr>
<td>
Account name should be in the format of the e-mail address.
<br>New account  will be automatically assigned to "guests" group until it is confirmed.
<br>After account is confirmed, group membership will be automatically changed to "users".
</td>
<td>
<b>New account name:</b>
</td>
<td>
<input type="text" size="40" name="newusername" value="_form-option-newusername_" />
</td>
</tr>
</table>
_config-user-formid_
<input type="submit" value=" Update! " />
<input type="hidden" name="c" value="_form-option-c_" />
<input type="hidden" name="delusr" value="_form-option-delusr_" />
<input type="hidden" name="modusr" value="_form-option-modusr_" />
<insert-useradministration-confirm>
</form>

<hr>
<insert-useradministration-content>