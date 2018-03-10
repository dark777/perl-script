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
$procurar = $query->param("procurar");
$pagina = $query->param("pagina");
@invalidas = ("http://","www");

($min,$hour,$mday,$mon,$year,$wday) = (localtime(time))[1,2,3,4,5,6];

$year+=1900;
$mon+=1;
$mon = "0$mon" if $mon < 10;
$mday = "0$mday" if $mday < 10;
$min = "0$min" if $min < 10;
$hour = "0$hour" if $hour < 10;

$txx = "$year$mon$mday";

open (cima,"cima.rse");
@cima = <cima>;
close (cima);

open (baixo,"baixo.rse");
@baixo = <baixo>;
close (baixo);

print "Content-type:text/html\n\n";

open(bd, "bd/bd.txt");
@bd = <bd>;
@bd = reverse(@bd);
close(bd);

foreach (@bd) {
chomp;
($id,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senha,$axx) = split(/\|/, $_);
$descricao2 = lc("$descricao");
$nome2 = lc("$nome");
$procurar2 = lc("$procurar");
$descricao3 = "$descricao2 $nome2 $url";
foreach ($data) {
($diax,$mesx,$anox) = split(/\//, $_);
}
$diax = $diax + $tnovo;
$tempox = "$anox$mesx$diax";

if ($tempox > $txx) { push(@bdb,"$id|$nome|$descricao|$url|$data|$cliques|$nomewm|$email|$cat|$senha|a"); }

}
$total = @bdb;
if ($total > '1') { $r = "Resultados"; } else { $r = "Resultado"; }

print @cima;

print qq~<p align="center"><font face="Verdana" size="2">Novos Sites ($total $r).</font></p>~;

if ($total eq '0') { print qq~<font color="#FF0000" face="Verdana" size="2"><center>Não foi encontrado nenhum novo site</font></p>~; }

$re="1";
$inicio = $pagina * $porpagina;
$paginas = $total / $porpagina;

$fim = $inicio + $porpagina;
if($fim > $total) 
{
$fim = $total; 
}
for($a=$inicio;$a<$fim;$a++) 
{

foreach (@bdb[$a]) {
chomp;
($id,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senha,$axx) = split(/\|/, $_);
$descricao2 = lc("$descricao");
$nome2 = lc("$nome");
$descricao3 = "$descricao2 $nome2 $url";
if ($cliques eq '1') { $texto = "Clique"; } else { $texto = 'Cliques'; }


foreach ($data) {
($diax,$mesx,$anox) = split(/\//, $_);
}
$diax = $diax + 7;
$tempox = "$anox$mesx$diax";
$paginax=$pagina+1;
$rex=$re+15*$pagina;
if ($tempox > $txx) { $novox = qq~ <img src="$imagens/novo.gif" border="0"> ~; }
print qq~
<ul>
  <li><font face="Verdana"><font size="2">$rex: <a href="ir.cgi?id=$id">$nome</a> $novox- $descricao</font><br>
  <font color="#808080" size="1"><a href="ir.cgi?id=$id">$url</a> - $cliques $texto - <a href="ver.cgi?cat=$cat">$cat</a> - Cadastrado em $data</font></font></li>
</ul>~;
$re++;
}

}


print qq~<center>~;
if ($pagina > 0) {
 $anterior = $pagina - 1;
 print "<font face='Verdana' size='1'><a href='novos.cgi?pagina=$anterior'>Anterior</a></font>";
}
else {
 print " <font face='Verdana' size='1'>Anterior</font>";
}

for($i=0;$i<$paginas;$i++) {
 $aaa = $i; $aaa++;
 if($pagina == $i) {
  print " [<font face='Verdana' size='1'><b>$aaa</b></font>]";
 } else {
  print " [<font face='Verdana' size='1'><a href='novos.cgi?pagina=$i'><b>$aaa</b></a></font>]";
 }
}

if($pagina<($paginas - 1)) {
 $proxima = $pagina + 1;
 print " <font face='Verdana' size='1'><a href='novos.cgi?pagina=$proxima'>Proxima</a></font>";
} else {
 print " <font face='Verdana' size='1'>Proxima</font>";
}


sub erro {

print qq~<font face="Verdana" size="2" color="#FF0000">Erro: @_</font>~;

}

print @baixo;