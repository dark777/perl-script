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
$acao = $query->param("acao");

sub cima {
open (cima,"cima.rse");
@cima = <cima>;
close (cima);
print @cima;
}
sub baixo {
open (baixo,"baixo.rse");
@baixo = <baixo>;
close (baixo);
print @baixo;
}

print "Content-type:text/html\n\n";

&cima;

#########################################################################################

open (cat, "cat.txt");
@cat = <cat>;
close ("cat");

open (bd, "bd/bd.txt");
@bd = <bd>;
close ("bd");

$xxx = "0";
$t = "0";

print qq~<center><table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="40%"><tr>~;

foreach (@cat) {
($catx,$axx) = split(/\|/, $_);

foreach (@bd) {
($id,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$categoria,$axx) = split(/\|/, $_);
if ($catx eq $categoria) { $t++; }
}
if ($xxx eq '2') { print qq~</tr><tr>~; $xxx = "0"; }
print qq~<td width="50%"><font face="Verdana" size="1"><a href="ver.cgi?cat=$catx">$catx</a> ($t)</td>\n~;
$xxx = $xxx + 1;
$t = "0";
}

print qq~</font></td>
    </tr>
  </table>
  </center>
</div></table>~;

#########################################################################################

sub erro {

print qq~<p align="center"><font size="2" face="Verdana" color="#FF0000">Erro: <b>@_</b></font></p>~;

}

&baixo;