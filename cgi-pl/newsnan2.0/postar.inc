<html>

<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>News Nan - Postar</title>

<script language="JavaScript">
<!--
var submitval = "";
function setupstyle(){
document.entryform.select_title.value = "Style Type";
document.entryform.select_list.options[0].text = "Negrito";
document.entryform.select_list.options[1].text = "Sublinhado";
document.entryform.select_list.options[2].text = "Itálico";
document.entryform.select_list.options[3].text = "Parágrafo";
document.entryform.select_list.options[4].text = "Parágrafo 2";
for (var loop=5; loop <= 11; loop++){document.entryform.select_list.options[loop].text = "";}
document.entryform.text_title.value = "Coloque o Texto abaixo";
document.entryform.text_entry.value = "";
document.entryform.text2_title.value = "Fonte";
document.entryform.text2_entry.value = "";
}
function setupfont(){
document.entryform.select_title.value = "Select Color";
document.entryform.select_list.options[0].text = "Nenhum";
document.entryform.select_list.options[1].text = "Preto";
document.entryform.select_list.options[2].text = "Branco";
document.entryform.select_list.options[3].text = "Verde";
document.entryform.select_list.options[4].text = "Vermelho";
document.entryform.select_list.options[5].text = "Azul";
document.entryform.select_list.options[6].text = "Amarelo";
document.entryform.select_list.options[7].text = "Cinza";
document.entryform.select_list.options[8].text = "Verde Escuro";
document.entryform.select_list.options[9].text = "Vermelho Escuro";
document.entryform.select_list.options[10].text = "Azul Escuro";
document.entryform.select_list.options[11].text = "Digiar Código";
document.entryform.text_title.value = "Coloque o texto abaixo";
document.entryform.text_entry.value = "";
document.entryform.text2_title.value = "Fonte";
document.entryform.text2_entry.value = "";
}
function setupform(){
document.entryform.select_title.value = "Formatar Item";
document.entryform.select_list.options[0].text = "Parágrafo";
document.entryform.select_list.options[1].text = "Marcador";
document.entryform.select_list.options[2].text = "Linha Horizontal";
document.entryform.select_list.options[3].text = "Tabela";
for (var loop=4; loop <= 11; loop++){document.entryform.select_list.options[loop].text = "";}
document.entryform.text_title.value = "";
document.entryform.text_entry.value = "";
document.entryform.text2_title.value = "";
document.entryform.text2_entry.value = "";
}
function setuplink(){
document.entryform.select_title.value = "Link Target";
document.entryform.select_list.options[0].text = "Mesma Janela";
document.entryform.select_list.options[1].text = "Nova Janela";
document.entryform.select_list.options[2].text = "Sem Frames";
for (var loop=3; loop <= 11; loop++){document.entryform.select_list.options[loop].text = "";}
document.entryform.text_title.value = "Coloque a URL";
document.entryform.text_entry.value = "http://";
document.entryform.text2_title.value = "Nome da Página";
document.entryform.text2_entry.value = "";
}
function setupmail(){
document.entryform.select_title.value = "";
for (var loop=0; loop <= 11; loop++){document.entryform.select_list.options[loop].text = "";}
document.entryform.text_title.value = "Coloque um e-mail";
document.entryform.text_entry.value = "";
document.entryform.text2_title.value = "Nome";
document.entryform.text2_entry.value = "";
}
function setupimage(){
document.entryform.select_title.value = "";
for (var loop=0; loop <= 11; loop++){document.entryform.select_list.options[loop].text = "";}
document.entryform.text_title.value = "Coloque a URL da Imagem";
document.entryform.text_entry.value = "";
document.entryform.text2_title.value = "";
document.entryform.text2_entry.value = "";
}
function enter(){
if (submitval == 1){style();}
if (submitval == 2){fonts();}
if (submitval == 3){format();}
if (submitval == 4){link();}
if (submitval == 5){mail();}
if (submitval == 6){image();}
}
function printout (output){
if (document.entryform.distype.checked == true){document.submitnews.mensagem.value += output;}
else{
document.entryform.select_title.value = "";
for (var loop=0; loop <= 11; loop++){document.entryform.select_list.options[loop].text = "";}
document.entryform.text_title.value = "Código";
document.entryform.text_entry.value = output;
document.entryform.text2_title.value = "";
document.entryform.text2_entry.value = "";
document.entryform.text_entry.select();
submitval = "";
}
}
function style(){
var the_index = document.entryform.select_list.selectedIndex;
var the_text = document.entryform.text_entry.value;
if (the_index == 0){output = ' <B>'+the_text+'</B> ';}
if (the_index == 1){output = ' <U>'+the_text+'</U> ';}
if (the_index == 2){output = ' <I>'+the_text+'</I> ';}
if (the_index == 3){output = ' <UL>'+the_text+'</UL> ';}
if (the_index == 4){output = ' <BLOCKQUOTE>'+the_text+'</BLOCKQUOTE> ';}
printout(output);
}
function fonts(){
var the_index = document.entryform.select_list.selectedIndex;
var the_text = document.entryform.text_entry.value;
var the_text2 = document.entryform.text2_entry.value;
var fontcolor = "";
if (the_index == 1){fontcolor = ' color="#000000"';}
if (the_index == 2){fontcolor = ' color="#FFFFFF"';}
if (the_index == 3){fontcolor = ' color="#00FF00"';}
if (the_index == 4){fontcolor = ' color="#FF0000"';}
if (the_index == 5){fontcolor = ' color="#0000FF"';}
if (the_index == 6){fontcolor = ' color="#FFFF00"';}
if (the_index == 7){fontcolor = ' color="#808080"';}
if (the_index == 8){fontcolor = ' color="#008000"';}
if (the_index == 9){fontcolor = ' color="#800000"';}
if (the_index == 10){fontcolor = ' color="#000080"';}
if (the_index == 11){
	var source = prompt( "Enter Color Hex Value:", "#" ); 
	if ((source != "")&&(source != null)&&(source != "#")){fontcolor = ' color="'+source+'"';}
}
var source2 = prompt( "Coloque uma Fonte: (ex: Verdana, Arial, Helvetica, sans-serif):", "" );
var fontface = "";
if ((source2 != "")&&(source2 != null)){fontface = ' face="'+source2+'"'}
var fontsize = "";
if (the_text2 != ""){fontsize = ' size="'+the_text2+'"'}
output = ' <font'+fontface+fontsize+fontcolor+'>'+the_text+'</font> ';
printout (output);
}
function format(){
var the_index = document.entryform.select_list.selectedIndex;
output = "";
if (the_index == 0){output = '&nbsp;&nbsp;&nbsp;&nbsp;';}
if (the_index == 1){output = '<LI>';}
if (the_index == 2){output = '<HR>';}
if (the_index == 3){
var R = prompt("Coloque o número de linhas:","");
var C = prompt("Coloque o número de Colunas:","");
if(R&&C){output = '<TABLE>\n';
for(loop = 0; loop < R; loop++){output += '<TR>\n';
for(loop2 = 0; loop2 < C; loop2++){output += '<TD> </TD>\n';}
output += '</TR>\n';}
output += '</TABLE>';
}}
printout(output);
}
function link(){
var the_index = document.entryform.select_list.selectedIndex;
var the_text = document.entryform.text_entry.value;
var the_text2 = document.entryform.text2_entry.value;
var linktarget="";
if (the_index == 1){var linktarget = ' target="_blank" ';}
if (the_index == 2){var linktarget = ' target="_top" ';}
output = ' <a href="'+the_text+'"'+linktarget+'>'+the_text2+'</a> ';
printout (output);
}
function mail(){
var the_text = document.entryform.text_entry.value;
var the_text2 = document.entryform.text2_entry.value;
output = ' <a href="mailto:'+the_text+'">'+the_text2+'</a> ';
printout (output);
}
function image(){
var the_text = document.entryform.text_entry.value;
output = '<img src="'+the_text+'">';
printout (output);
}
// --> 
    </script>


</head>

<body>

<p align="center"><b><font face="Verdana" size="1">Postar Mensagem</font></b></p>
<meta http-equiv="Content-Language" content="pt-br">
<meta http-equiv="Content-Language" content="pt-br">
<hr>
<p align="center"><font face="Verdana" size="1"><b>S</b>eja Bem Vindo $nome.<br>
<b>P</b>reencha o formulário abaixo para postar uma mensagem.<br>
<b>L</b>embramos...<br>
<b>V</b>ocê pode usar HTML na mensagem.</font></p>
<p align="center">
<div align="center">
        <center>
	  <table width="90%" border="1" bordercolor="#111111" cellpadding="8" cellspacing="0" style="border-collapse: collapse">
	    <tr bgcolor="#ffffff"> 
      <td>
<form method="POST" action="postar.cgi" name="submitnews">
	        <div align="center"><font face="Verdana"><b><font size="1">Notícia</font></b><font size="1"> <br>
	          <textarea name="mensagem" cols="70" rows="15" wrap="VIRTUAL"></textarea>
	<br>
		<input type="submit" name="Submit" value="Enviar"><input type="reset" value="Apagar">
              </font></font>
	        </div></form>
<center><form name="entryform" onSubmit="enter(); return false;">
<hr>
<p><font face="Verdana" size="1"><b>Editor Avançado</b></font></p>
<table><tr><td valign="top" rowspan="2"><table>
<tr><td>
  <font face="Verdana" size="1">
  <input type="button" name="Text Styles" value="Estilos de Texto" onclick="submitval=1; setupstyle();"></font></td></tr>
<tr><td>
  <font face="Verdana" size="1">
  <input type="button" name="Font Styles" value="Cor da Fonte" onclick="submitval=2; setupfont();"></font></td></tr>
<tr><td>
  <font face="Verdana" size="1">
  <input type="button" name="Formating" value="Formatação" onclick="submitval=3; setupform();"></font></td></tr>
<tr><td><font face="Verdana" size="1"><input type="button" name="Link" value="Link" onclick="submitval=4; setuplink();"></font></td></tr>
<tr><td><font face="Verdana" size="1"><input type="button" name="E-mail" value="E-mail" onclick="submitval=5; setupmail();"></font></td></tr>
<tr><td>
  <font face="Verdana" size="1">
  <input type="button" name="Image" value="Imagem" onclick="submitval=6; setupimage();"></font></td></tr>
</table></td>
<td valign="top">
<table>
<tr><td colspan=3><font face="Verdana" size="1"><input type="text" size=15 name="select_title" onFocus="document.entryform.select_list.focus();"></font></td></tr>
<tr><td colspan=3><font face="Verdana" size="1"><select size="4" name="select_list">
<option>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</option>
<option></option>
<option></option>
<option></option>
<option></option>
<option></option>
<option></option>
<option></option>
<option></option>
<option></option>
<option></option>
<option></option>
</select></font></td></tr>
<tr><td><font face="Verdana" size="1"><input type="submit" name="Enter" value="Inserir"></font></td>
<td><font face="Verdana" size="1"><input type="checkbox" name="distype" checked=true value="ON"></font></td>
<td><font size="1" face="Verdana">Adicionar na mensagem</font></td>
</tr></table></td>
<td valign=top><table>
<tr><td><font face="Verdana" size="1"><input type="text" size=24 name="text_title" onFocus="document.entryform.text_entry.focus();"></font></td></tr>
<tr><td><font face="Verdana" size="1"><textarea cols=20 rows=6 name="text_entry"></textarea></font></td></tr>
</table></td>
<td valign=top><table>
<tr><td><font face="Verdana" size="1"><input type="text" size=12 name="text2_title" onFocus="document.entryform.text2_entry.focus();"></font></td></tr>
<tr><td><font face="Verdana" size="1"><textarea cols=10 rows=6 name="text2_entry"></textarea></font></td></tr>
</table></td>
</tr>
<td colspan=3>&nbsp;</td>
</tr></table>
</form></center>
	</td>
	    </tr>
	  </table>
	    </center>
      </div>
	  <font face="Verdana" size="1">
	  <br>
	</div>

	  <br>
	</div>
</font>
</p>
<hr>

<p align="center"><font face="Verdana" size="1">Criado por Renan Elias<br>
<a href="mailto:renan@osimbr.net">renan@osimbr.net</a></font></p>

</body>

</html>