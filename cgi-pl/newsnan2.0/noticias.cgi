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
# E-mail: renan@osimbr.net                                           #
# ICQ: 89603614                                                      #
#                                                                    #
#    Você precisa de um CGI para seu site? Entre em contato! Crio    #
#       seu script do modo que quiser por um preço muito bom.        #
######################################################################



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

$noticia="$ENV{'QUERY_STRING'}";

$arquivo2="novidades.txt";

open(DATA, "<$arquivo2");
@datao = <DATA>;
@datao = reverse(@datao);
close(DATA);
require "configuracao.cgi";

if (@datao[0] eq "") 
{ 
print "<center><font face=\"Verdana\" size=\"1\"><b>Não ha nenhuma mensagem.</b></center></font>";

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

if ($tempo eq $noticia)

{

print "<div align=\"center\"><center><table border=\"0\" width=\"438\" cellspacing=\"0\" cellpadding=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\"><tr><td width=\"438\" height=\"28\" background=\"$urlsistema/cima.gif\"><p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>$titulo</b></font></td></tr><tr><td width=\"100%\" background=\"$urlsistema/centro.gif\"><div align=\"center\"><table border=\"0\" width=\"93%\" cellspacing=\"0\" cellpadding=\"0\"><tr><td width=\"3%\" align=\"center\"><font face=\"Verdana\" size=\"1\"><img src=\"$imagem\"></font></td><td width=\"97%\" align=\"center\"><font face=\"Verdana\" size=\"1\" color=\"#FFFFFF\">$mensagem<br><br>Postado por: <b>$nome</b> em <b>$data</b></font></td></tr></table></div></td></tr><tr><td width=\"438\" height=\"19\" background=\"$urlsistema/baixo.gif\"><p align=\"center\"><font face=\"Verdana\" size=\"1\" color=\"#FFFFFF\">News Nan by Renan Elias</font></td></tr></table></center></div><br>";

}
}
exit;

}