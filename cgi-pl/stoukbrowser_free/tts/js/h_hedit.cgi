<script language="Javascript1.2">
<!-- // load htmlarea
_editor_url = "_config-script-editorwebroot_"                     // URL to htmlarea files
_editorimages_url = "_config-script-editorimageswebroot_"
_editorpopups_url = "_config-script-editorpopupswebroot_"
var win_ie_ver = parseFloat(navigator.appVersion.split("MSIE")[1]);
if (navigator.userAgent.indexOf('Mac')        >= 0) { win_ie_ver = 0; }
if (navigator.userAgent.indexOf('Windows CE') >= 0) { win_ie_ver = 0; }
if (navigator.userAgent.indexOf('Opera')      >= 0) { win_ie_ver = 0; }
if (win_ie_ver >= 5.5) {
  document.write('<script src="'+_editor_url+'editor.js"');
  document.write(' language="Javascript1.2"></script>');  
} else { document.write('<script>function editor_generate() { return false; }</script>'); }
// -->
</script>