#!/usr/bin/perl

######################################################################
#                           CGI Busca v2.0                           #
#                                                                    #
# Configuração: Edite somente o configuracao.cgi para que funcione   #
#                             corretamente.                          #
#                                                                    #
#                                                                    #
#                                                                    #
# Criador: Renan Silveira Elias                                      #
# E-mail: renan.elias@bol.com.br                                     #
# ICQ: 89603614                                                      #
# Site: http://www.scriptsnan.rg3.net / http://www.cgiclube.net      #
#                                                                    #
#    Você precisa de um CGI para seu site? Entre em contato! Crio    #
#       seu script do modo que quiser por um preço muito bom.        #
######################################################################

require "configuracao.cgi";

use CGI;
$query = new CGI;
$idx = $query->param("id");

open (arq, "bd/bd.txt");
@db = <arq>;
close(arq);

foreach $temp (@db) {
chop($temp);
($id,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senha,$axx) = split(/\|/, $temp);

if ($idx eq $id){
$cliques = $cliques + 1;
push(@ndb,"$id|$nome|$descricao|$url|$data|$cliques|$nomewm|$email|$cat|$senha|a");

print "Location:$url\n\n";

}
else {
push(@ndb,"$id|$nome|$descricao|$url|$data|$cliques|$nomewm|$email|$cat|$senha|a"); }
open (arq, ">bd/bd.txt");
foreach $temp2 (@ndb){
print arq "$temp2\n";
} close(arq); }
