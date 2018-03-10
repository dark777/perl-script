<table style="width:100%; height:100%; font-family:verdana,arial; font-size:8pt; background:#edc">
<tr><td valign="top">
Editing: <b>_form-option-htfile_</b>
<div align=center>
<br><a href="_config-user-linkid_&c=adminmain">Administration panel.</a>
<form method="post" enctype="application/x-www-form-urlencoded" name="wysiwyg" action="_config-script-webpath_" target="_self">
_config-user-formid_
<textarea name="econtent" style="width:100%; height:400; font-family:verdana,arial; font-size:8pt; background:#fff">
_insert-htedit-content_
</textarea>
<br><input type="submit" value=" Update! " />
<input type="hidden" name="htfile" value="_form-option-htfile_" /></td>
<input type="hidden" name="c" value="_form-option-c_" /></td>
</div>
</td></tr>
<script language="javascript1.2">
var config = new Object();    // create new config object
config.width = "100%"
config.height = "400px"
config.bodyStyle = 'background-color: white; font-family:Verdana,arial; font-size:8pt;';
config.debug = 0;
config.imgURL = "_config-script-editorimageswebroot_"
// NOTE:  You can remove any of these blocks and use the default config!
config.toolbar = [
    ['fontname'],
    ['fontsize'],
    ['fontstyle'],
    ['forecolor','backcolor','separator'],
    ['HorizontalRule','Createlink','InsertImage','InsertTable','htmlmode','separator'],
    ['linebreak'],
    ['bold','italic','underline','separator'],
    ['strikethrough','subscript','superscript','separator'],
    ['justifyleft','justifycenter','justifyright','separator'],
    ['OrderedList','UnOrderedList','Outdent','Indent','separator'],
    ['about','help','popupeditor'],
];
config.fontnames = {
    "Arial":           "arial, helvetica, sans-serif",
    "Courier New":     "courier new, courier, mono",
    "Georgia":         "Georgia, Times New Roman, Times, Serif",
    "Tahoma":          "Tahoma, Arial, Helvetica, sans-serif",
    "Times New Roman": "times new roman, times, serif",
    "Verdana":         "Verdana, Arial, Helvetica, sans-serif",
    "impact":          "impact",
    "WingDings":       "WingDings"
};
config.fontsizes = {
    "1 (8 pt)":  "1",
    "2 (10 pt)": "2",
    "3 (12 pt)": "3",
    "4 (14 pt)": "4",
    "5 (18 pt)": "5",
    "6 (24 pt)": "6",
    "7 (36 pt)": "7"
  };
//config.stylesheet = "http://www.domain.com/sample.css"
 
config.fontstyles = [   // make sure classNames are defined in the page the content is being display as well in or they won't work!
  { name: "headline",     className: "headline",  classStyle: "font-family: arial black, arial; font-size: 28px; letter-spacing: -2px;" },
  { name: "arial red",    className: "headline2", classStyle: "font-family: arial black, arial; font-size: 12px; letter-spacing: -2px; color:red" },
  { name: "verdana blue", className: "headline4", classStyle: "font-family: verdana; font-size: 18px; letter-spacing: -2px; color:blue" }
// leave classStyle blank if it's defined in config.stylesheet (above), like this:
//  { name: "verdana blue", className: "headline4", classStyle: "" }  
];
editor_generate('econtent',config);
</script>

</form>
</table>

