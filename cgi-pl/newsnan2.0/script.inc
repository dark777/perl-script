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
if (the_index == 1){fontcolor = ' color=#000000';}
if (the_index == 2){fontcolor = ' color=#FFFFFF';}
if (the_index == 3){fontcolor = ' color=#00FF00';}
if (the_index == 4){fontcolor = ' color=#FF0000';}
if (the_index == 5){fontcolor = ' color=#0000FF';}
if (the_index == 6){fontcolor = ' color=#FFFF00';}
if (the_index == 7){fontcolor = ' color=#808080';}
if (the_index == 8){fontcolor = ' color=#008000';}
if (the_index == 9){fontcolor = ' color=#800000';}
if (the_index == 10){fontcolor = ' color=#000080';}
if (the_index == 11){
	var source = prompt( "Enter Color Hex Value:", "#" ); 
	if ((source != "")&&(source != null)&&(source != "#")){fontcolor = ' color="'+source+'"';}
}
var source2 = prompt( "Coloque uma Fonte: (ex: Verdana, Arial, Helvetica, sans-serif):", "" );
var fontface = "";
if ((source2 != "")&&(source2 != null)){fontface = ' face='+source2+''}
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
if (the_index == 1){var linktarget = ' target=_blank ';}
if (the_index == 2){var linktarget = ' target=_top ';}
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