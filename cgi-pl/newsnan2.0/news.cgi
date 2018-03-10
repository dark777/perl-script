#!/usr/bin/perl
######################################################################
#                      News Nan By Renan Elias                       #
#                                                                    #
# Configuração: Somente configure o configuracao.cgi para que o CGI  #
#                       funcione corretamente                        #
#                                                                    #
#                                                                    #
#                                                                    #
# Criador: Renan Silveira Elias                                      #
# E-mail: renan@osimbr.net                                          #
# ICQ: 89603614                                                      #
#                                                                    #
#    Você precisa de um CGI para seu site? Entre em contato! Crio    #
#       seu script do modo que quiser por um preço muito bom.        #
######################################################################



$content = $ENV{'QUERY_STRING'};

read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});

@pairs = split(/&/, $buffer);

foreach $pair (@pairs) {
   ($name, $value) = split(/=/, $pair);

   $value =~ tr/+/ /;
   $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
   $value =~ s/<!--(.|\n)*-->//g;

   $FORM{$name} = $value;
}

print "Content-type: text/html\n\n";

require "configuracao.cgi";

$copyright="News Nan v$versao, by Renan Elias";

if ($content) {

if (defined(&$content)) {

&$content;

} else {
&nao_encontrei;
}

} else {
&nao_permitido_acesso;
}


sub todas {

$arquivo2="novidades.txt";

open(DATA, "<$arquivo2");
@datao = <DATA>;
@datao = reverse(@datao);
close(DATA);

if (@datao[0] eq "") 
{ 
print "<center><font face='Verdana' size='1'><b>Não ha nenhuma mensagem.</b></center></font>";

}

else {

foreach (@datao) {
chomp;

($nome,$email,$imagem,$data,$mensagem,$titulo,$tempo) = split(/``/, $_);


if ($imagem eq "")
{
$imagem.="$urlsistema/nenhuma.gif";
}
elsif ($imagem eq "http://")
{
$imagem.="$urlsemwww/nenhuma.gif";
}

print "<div align=\"center\"><center><table border=\"0\" width=\"438\" cellspacing=\"0\" cellpadding=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\"><tr><td width=\"438\" height=\"28\" background=\"$urlsistema/cima.gif\"><p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>$titulo</b></font></td></tr><tr><td width=\"100%\" background=\"$urlsistema/centro.gif\"><div align=\"center\"><table border=\"0\" width=\"93%\" cellspacing=\"0\" cellpadding=\"0\"><tr><td width=\"3%\" align=\"center\"><font face=\"Verdana\" size=\"1\"><img src=\"$imagem\"></font></td><td width=\"97%\" align=\"center\"><font face=\"Verdana\" size=\"1\" color=\"#FFFFFF\">$mensagem<br><br><font face=\"Verdana\" size=\"1\">Postado por: <b>$nome</b> em <b>$data</b></font></td></tr></table></div></td></tr><tr><td width=\"438\" height=\"19\" background=\"$urlsistema/baixo.gif\"><p align=\"center\"><font face=\"Verdana\" size=\"1\" color=\"#FFFFFF\">$copyright</font></td></tr></table><br>";

}
}
exit;

}


sub atual {

$arquivo="novidades.txt";

open(DATA, "<$arquivo");
@datao = <DATA>;
@datao = reverse(@datao);
close(DATA);

if ($datao[0] eq "") { print qq~document.write('<center><font face=Verdana size=1><b>Não ha nenhuma mensagem.</b></center></font>')\;~;}
else {


$n=0;
foreach (@datao){
 if($n<1){

chomp;
($nome,$email,$imagem,$data,$mensagem,$titulo,$tempo) = split(/``/, $_);

if ($imagem eq "")
{
$imagem.="$urlsistema/nenhuma.gif";
}
elsif ($imagem eq "http://")
{
$imagem.="$urlsemwww/nenhuma.gif";
}

print qq~document.write('<div align=\"center\"><center><table border=\"0\" width=\"438\" cellspacing=\"0\" cellpadding=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\"><tr><td width=\"438\" height=\"28\" background=\"$urlsistema/cima.gif\"><p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>$titulo</b></font></td></tr><tr><td width=\"100%\" background=\"$urlsistema/centro.gif\"><div align=\"center\"><table border=\"0\" width=\"93%\" cellspacing=\"0\" cellpadding=\"0\"><tr><td width=\"3%\" align=\"center\"><font face=\"Verdana\" size=\"1\"><img src=\"$imagem\"></font></td><td width=\"97%\" align=\"center\"><font face=\"Verdana\" size=\"1\" color=\"#FFFFFF\">$mensagem<br><br><font face=\"Verdana\" size=\"1\">Postado por: <b>$nome</b> em <b>$data</b></font></td></tr></table></div></td></tr><tr><td width=\"438\" height=\"19\" background=\"$urlsistema/baixo.gif\"><p align=\"center\"><font face=\"Verdana\" size=\"1\" color=\"#FFFFFF\">$copyright</font></td></tr></table><br>'\)\;~;
 $n++;
}
}
}
exit;

}

sub codigo {
$arquivo="novidades.txt";

open(DATA, "<$arquivo");
@datao = <DATA>;
@datao = reverse(@datao);
close(DATA);

if ($datao[0] eq "") { print qq~document.write\('<center><font face=Verdana size=1><b>Não ha nenhuma mensagem.</b></center></font>'\)\;~;}
else {

foreach (@datao) {
chomp;
($nome,$email,$imagem,$data,$mensagem,$titulo,$tempo) = split(/``/, $_);

if ($imagem eq "")
{
$imagem.="$urlsistema/nenhuma.gif";
}
elsif ($imagem eq "http://")
{
$imagem.="$urlsemwww/nenhuma.gif";
}

print qq~document.write\('<div align=\"center\"><center><table border=\"0\" width=\"438\" cellspacing=\"0\" cellpadding=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\"><tr><td width=\"438\" height=\"28\" background=\"$urlsistema/cima.gif\"><p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>$titulo</b></font></td></tr><tr><td width=\"100%\" background=\"$urlsistema/centro.gif\"><div align=\"center\"><table border=\"0\" width=\"93%\" cellspacing=\"0\" cellpadding=\"0\"><tr><td width=\"3%\" align=\"center\"><font face=\"Verdana\" size=\"1\"><img src=\"$imagem\"></font></td><td width=\"97%\" align=\"center\"><font face=\"Verdana\" size=\"1\" color=\"#FFFFFF\">$mensagem<br><br><font face=\"Verdana\" size=\"1\">Postado por: <b>$nome</b> em <b>$data</b></font></td></tr></table></div></td></tr><tr><td width=\"438\" height=\"19\" background=\"$urlsistema/baixo.gif\"><p align=\"center\"><font face=\"Verdana\" size=\"1\" color=\"#FFFFFF\">$copyright</font></td></tr></table><br>'\)\;~;
}
}
exit;

}

sub resumo {

$arquivo="novidades.txt";

open(DATA, "<$arquivo");
@datao = <DATA>;
@datao = reverse(@datao);
close(DATA);

if ($datao[0] eq "") { print qq~document.write\('<center><font face=Verdana size=1><b>Não ha nenhuma mensagem.</b></center></font>'\)\;~;}
else {

$n=0;
foreach (@datao){
 if($n<5){

chomp;

($nome,$email,$imagem,$data,$mensagem,$titulo,$tempo) = split(/``/, $_);

if ($imagem eq "")
{
$imagem.="$urlsistema/nenhuma.gif";
}
elsif ($imagem eq "http://")
{
$imagem.="$urlsemwww/nenhuma.gif";
}



print qq~document.write\('<p align=left><img border=0 src=$urlsistema/marcador.jpg align=absmiddle width=10 height=10><font face=Verdana size=1>$data - <a href=$urlcgis/noticias.cgi?$tempo>$titulo</a></font>'\)\;~;
 $n++;
}
}
}
exit;

}


sub resumo_ssi {

print "<div align='center'><center><table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='57%' id='AutoNumber1'>
";
$arquivo="novidades.txt";

open(DATA, "<$arquivo");
@datao = <DATA>;
@datao = reverse(@datao);
close(DATA);

if ($datao[0] eq "") { print "<center><font face='Verdana' size='1'><b>Não ha nenhuma mensagem.</b></center></font>";}
else {

$n=0;
foreach (@datao){
 if($n<5){

chomp;

($nome,$email,$imagem,$data,$mensagem,$titulo,$tempo) = split(/``/, $_);

if ($imagem eq "")
{
$imagem.="$urlsistema/nenhuma.gif";
}
elsif ($imagem eq "http://")
{
$imagem.="$urlsemwww/nenhuma.gif";
}



print "<tr><td width='100%'><p align='left'><img border='0' src='$urlsistema/marcador.jpg' align='absmiddle' width='10' height='10'><font face='Verdana' size='1'>$data - <a href='$urlcgis/noticias.cgi?$tempo'>$titulo</a></font></td></tr>";
 $n++;
}
}
}
exit;
print "</table></center></div>";

}

sub atual_ssi {

$arquivo="novidades.txt";

open(DATA, "<$arquivo");
@datao = <DATA>;
@datao = reverse(@datao);
close(DATA);

if ($datao[0] eq "") { print "<center><font face='Verdana' size='1'><b>Não ha nenhuma mensagem.</b></center></font>";}
else {


$n=0;
foreach (@datao){
 if($n<1){

chomp;
($nome,$email,$imagem,$data,$mensagem,$titulo,$tempo) = split(/``/, $_);

if ($imagem eq "")
{
$imagem.="$urlsistema/nenhuma.gif";
}
elsif ($imagem eq "http://")
{
$imagem.="$urlsemwww/nenhuma.gif";
}

print "<div align=\"center\"><center><table border=\"0\" width=\"438\" cellspacing=\"0\" cellpadding=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\"><tr><td width=\"438\" height=\"28\" background=\"$urlsistema/cima.gif\"><p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>$titulo</b></font></td></tr><tr><td width=\"100%\" background=\"$urlsistema/centro.gif\"><div align=\"center\"><table border=\"0\" width=\"93%\" cellspacing=\"0\" cellpadding=\"0\"><tr><td width=\"3%\" align=\"center\"><font face=\"Verdana\" size=\"1\"><img src=\"$imagem\"></font></td><td width=\"97%\" align=\"center\"><font face=\"Verdana\" size=\"1\" color=\"#FFFFFF\">$mensagem<br><br><font face=\"Verdana\" size=\"1\">Postado por: <b>$nome</b> em <b>$data</b></font></td></tr></table></div></td></tr><tr><td width=\"438\" height=\"19\" background=\"$urlsistema/baixo.gif\"><p align=\"center\"><font face=\"Verdana\" size=\"1\" color=\"#FFFFFF\">$copyright</font></td></tr></table><br>";
 $n++;
}
}
}
exit;

}


sub nao_encontrei {
print <<EOF;
Erro! Você deve ter executado o CGI Incorretamente
EOF
}

sub nao_permitido_acesso {
print <<EOF;
Erro! Você deve ter executado o CGI Incorretamente
EOF
}