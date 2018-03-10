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
$re="1";

open(bd, "bd/bd.txt");
@bd = <bd>;
@bd = reverse(@bd);
close(bd);

foreach (@bd) {
chomp;
($id,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senha,$axxx) = split(/\|/, $_);

$descricao2 = lc("$descricao");
$nome2 = lc("$nome");
$procurar2 = lc("$procurar");
$descricao3 = "$descricao2 $nome2 $url";

if ($descricao3=~ /$procurar2/) { push(@bdb,"$id|$nome|$descricao|$url|$data|$cliques|$nomewm|$email|$cat|$senha|a"); }

}
$total = @bdb;
if ($total > '1') { $r = "Resultados"; } else { $r = "Resultado"; }

print @cima;

if ($procurar=~ /@invalida/) { $procurar =~ s/http:\/\///g; $procurar =~ s/www.//g; $procurar =~ s/www/a/g; $msgg=qq~<font color="red" face="Verdana" size="2"><br>Termos como http://www são automaticamente ignorados pelo sistema.</font><br>~;}

$letras = length("$procurar");
if ($letras < $minimo) { &erro('Sua pesquisa está muito pequena. Digite mais letras.'); print @baixo; exit; }

print qq~<p align="center"><font face="Verdana" size="2">Resultados da Busca por
      <font color="#FF0000">$procurar</font> ($total $r).</font></p>~;

if ($total eq '0') { print qq~<font color="#FF0000" face="Verdana" size="2"><center>Não foi encontrado nenhum resultado para sua pesquisa</font></p>~; }


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
($id,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senha,$axxx) = split(/\|/, $_);
$descricao2 = lc("$descricao");
$nome2 = lc("$nome");
$descricao3 = "$descricao2 $nome2 $url";
if ($cliques eq '1') { $texto = "Clique"; } else { $texto = 'Cliques'; }


if ($descricao3=~ /$procurar2/) {

foreach ($data) {
($diax,$mesx,$anox) = split(/\//, $_);
}
$paginax=$pagina+1;
$rex=$re+15*$pagina;
$diax = $diax + 7;
$tempox = "$anox$mesx$diax";
if ($tempox > $txx) { $novox = qq~ <img src="$imagens/novo.gif" border="0"> ~; }
print qq~
<ul>
  <li>
<font face="Verdana"><font size="2">$rex: <a href="ir.cgi?id=$id">$nome</a> $novox- $descricao</font><br>
  <font color="#808080" size="1"><a href="ir.cgi?id=$id">$url</a> - $cliques $texto - <a href="ver.cgi?cat=$cat">$cat</a> - Cadastrado em $data</font></font></li>
</ul>\n~;
$re++;
$novox="";
}

}
}


print qq~<center>~;
if ($pagina > 0) {
 $anterior = $pagina - 1;
 print "<font face='Verdana' size='1'><a href='?pagina=$anterior&procurar=$procurar'>Anterior</a></font>";
}
else {
 print " <font face='Verdana' size='1'>Anterior</font>";
}

for($i=0;$i<$paginas;$i++) {
 $aaa = $i; $aaa++;
 if($pagina == $i) {
  print " [<font face='Verdana' size='1'><b>$aaa</b></font>]";
 } else {
  print " [<font face='Verdana' size='1'><a href='?pagina=$i&procurar=$procurar'><b>$aaa</b></a></font>]";
 }
}

if($pagina<($paginas - 1)) {
 $proxima = $pagina + 1;
 print " <font face='Verdana' size='1'><a href='?pagina=$proxima&procurar=$procurar'>Proxima</a></font>";
} else {
 print " <font face='Verdana' size='1'>Proxima</font>";
}


sub erro {

print qq~<center><font face="Verdana" size="2" color="#FF0000">Erro: @_</font></center>~;

}

print @baixo;