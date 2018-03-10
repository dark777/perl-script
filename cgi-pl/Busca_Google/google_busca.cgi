#!/usr/bin/perl
print "Content-type:text/html\n\n";

use SOAP::Lite;

################## CONFIGURAÇÕES ##################
my $max_botoes="10";     # Nº de Botoes
my $google_key='1yYhY5JQFHKyTAjdDT0ga1XWsPDy3tYI'; # Coloque  sua Google-API License Key
# Caso queria uma API própria acesse http://www.google.com/apis/
my $google_wdsl = "http://api.google.com/GoogleSearch.wsdl";
###################################################
my $qs = $ENV{QUERY_STRING};

read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
@conteudo = split(/&/, $buffer);
foreach $par (@conteudo) {
        ($campo, $valor) = split(/=/, $par);
        $valor =~ tr/+/ /;
        $valor =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
        $CAMPO{$campo} = $valor;
}


if (!$qs){
print qq|<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mr.Bam Web Site Busca no gogle</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
.tabela  { font-family:Tahoma; font-size:8pt; color:000000; font-weight:bold; border:2pt; border-style:outset; border-color:D3E5FA; }
.txt     { font-family:Tahoma; font-size:8pt; color:FFFFFF; }
.txt2    { font-family:Tahoma; font-size:8pt; color:333333; font-weight:normal }
BODY     { overflow:auto; text-align:center; }
INPUT    { font-family:Tahoma; font-size:8pt; color:000000; font-weight:bold; }
.selected{ font-family:Tahoma; font-size:8pt; background-color:#6688DD; color:FFFFFF; font-weight:bold; }
</style>
</head>

<body bgcolor="#6487DC" text="#FFFFFF" link="#000000" vlink="#333333" alink="#333333">
<form action="?busca" method="post" name="" id="">
<table width="75%" border="0">
        <tr bgcolor="#D3E5FA">
        <td colspan="3" class="tabela"><div align="center">Fast Searcher</div></td>
        </tr>
       <tr>
        <td>
         <table  width="100%" border="0" align="center" class="tabela" cellspacing="0" cellpadding="0">
          <tr bgcolor="#ECF3FD">
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr bgcolor="#ECF3FD">
            <td width="44%"><div align="right">Procurar por:&nbsp;</div></td>
            <td width="17%"><div align="right">
            <input name="q" type="text" id="q">
            </div></td>
            <td width="39%"><input type="submit" value="Pesquisar"></td>
          </tr>
          <tr bgcolor="#ECF3FD">
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td></td>
   </tr>
         </table>
        <table cellpadding="0" cellspacing="0" width="100%" align="center">
         <tr bgcolor="#D3E5FA">
   <td bgcolor="#D3E5FA" class="tabela">
           <div align="right"><font class="txt2">Fast Searcher by <a href="http://forum.wmonline.com.br/index.php?showuser=870" target="_blank">Whitesnake</a>&nbsp;</font></div>
          </td>
  </tr>
         <tr>
           <td class="txt"><div align="right"><br>powered by Google™</div></td>
         </tr>
        </table>
       </td>
     </tr>
</table>
</form>
</body>
</html>|;
}




if ($qs){
$q = $CAMPO{q};

if (!$CAMPO{pag}){$CAMPO{pag} = 0;}

my $google_search = SOAP::Lite->service("$google_wdsl");
my $resultados = $google_search -> doGoogleSearch( $google_key,  $q,   $CAMPO{pag}, 10, "false", "", "false", "lang_pt", "UTF-8", "UTF-8" );
@{$resultados->{resultElements}} or print "Sem resultado";
my $total_paginas = $resultados ->{'estimatedTotalResultsCount'};

if($total_paginas => "990"){$total_paginas=990;}
        $pagina_atual = $CAMPO{pag};

print qq|<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mr.Bam Web Site - Busca no Google</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
.tabela2 { font-family:Tahoma; font-size:8pt; color:000000; font-weight:bold; border:2pt; border-style:outset; border-color:D3E5FA; }
.tabela  { font-family:Tahoma; font-size:8pt; color:FFFFFF; font-weight:bold; border:2pt; border-style:outset; border-color:D3E5FA; }
.txt     { font-family:Tahoma; font-size:8pt; color:FFFFFF; }
.txt2    { font-family:Tahoma; font-size:8pt; color:333333; font-weight:normal }
BODY     { overflow:auto; text-align:center; }
INPUT    { font-family:Tahoma; font-size:8pt; color:#333333; font-weight:bold; }
.selected{ font-family:Tahoma; font-size:8pt; color:#3355FF; font-weight:bold; }
</style>
</head>

<body bgcolor="#6487DC" text="#FFFFFF" link="#222222" vlink="#000000" alink="#000000">
<table cellspacing="0" cellpadding="0"><tr>|;

print qq|
       </tr>
      </table>
       <form action="?busca" method="post" name="" id="">
        <table width="75%" border="0" cellspacing="0" cellpadding="0" class="tabela">
         <tr bgcolor="#D3E5FA">
          <td colspan="3" class="tabela2">
           <div align="left">Fast Searcher</div>
          </td>
        </tr>
      <tr>
       <td>
        <table width="100%" border="0" align="center" class="txt2" bgcolor="#ECF3FD">
          <tr>
            <td colspan="3">
             <div align="left">
              Procurar por: <input name="q" type="text" id="query">
               <input type="submit" value="Pesquisar">
              </div>
             <div align="right"> </div>
           </td>
          </tr>
          <tr>
            <td colspan="3">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="3">|;

foreach $resultado (@{$resultados->{resultElements}}) {
print qq|
          <a href="$resultado->{URL}" target="_blank">$resultado->{title}</a>
           <br>
            <font color="333333">$resultado->{snippet}</font>
           <br>$resultado->{URL}<br><br>
|;
}

print qq|</td>
        </tr>
       <tr>
<td colspan="3">
  <table align="center" cellpadding="0" cellspacing="0" class="txt">|;



if($pagina_atual ne "0"){
    $ant=$pagina_atual-1; # Página anterior
    print qq|<td>
              <form action="?busca" method="post" name="" id="">
               <input name="q" type="hidden" id="query" value="$q">
               <input name="pag" type="hidden" id="query" value="$ant">
        <input type="submit" value="< Anterior ">
              </form>
             </td>|;
}else{
print qq|
             <td>
               <form name="form">
  <input type="submit" value="< Anterior " disabled>
               </form>
             </td>|;
}

if($total_paginas <= $max_botoes){

for ($p=0; $p<=$total_paginas;$p++){
   $n=$p+1; if($n < 10){$n = "0".$n;}
    if($p eq $CAMPO{pag}){
     print qq|<td>
               <form action="?busca" method="post" name="" id="">
                <input name="q" type="hidden" id="query" value="$q">
                <input name="pag" type="hidden" id="query" value="$p">
  <input type="submit" value=" $n " class="selected">
               </form>
              </td>|;
}else{
print qq|<td>
          <form action="?busca" method="post" name="" id="">
           <input name="q" type="hidden" id="query" value="$q">
           <input name="pag" type="hidden" id="query" value="$p">
    <input type="submit" value=" $n ">
          </form>
         </td>|;
  }
}
}else{

for ($p=$CAMPO{pag}; $p<=$CAMPO{pag}+$max_botoes-1;$p++){
  $n=$p+1; if($n < 10){$n = "0".$n;}

   if($p eq $CAMPO{pag}){
    print qq|<td>
              <form action="?busca" method="post" name="" id="">
               <input name="q" type="hidden" id="query" value="$q">
               <input name="pag" type="hidden" id="query" value="$p">
               <input type="submit" value=" $n " class="selected">
              </form>
             </td>|;
}else{
print qq|<td>
          <form action="?busca" method="post" name="" id="">
           <input name="q" type="hidden" id="query" value="$q">
           <input name="pag" type="hidden" id="query" value="$p">
    <input type="submit" value=" $n ">
          </form>
         </td>|;
  }
}
}

if($pagina_atual ne $total_paginas){
  $prox=$pagina_atual+1;# Próxima página
  print qq|<td>
            <form action="?busca" method="post" name="" id="">
             <input name="q" type="hidden" id="query" value="$q">
             <input name="pag" type="hidden" id="query" value="$prox">
      <input type="submit" value=" Próximo >">
            </form>
           </td>|;
}else{
print qq|  <td>
            <form name="form">
      <input type="submit" value=" Próximo >" disabled>
            </form>
           </td>|;
}

print qq| </tr>
         </table>
        </td>
       </tr>
      </table>
     </td>
    </tr>
</table>
<table cellpadding="0" cellspacing="0" width="75%" align="center">
  <tr bgcolor="#D3E5FA">
   <td class="tabela">
    <div align="right">
     <font class="txt2">Fast Searcher by <a href="http://forum.wmonline.com.br/index.php?showuser=870" target="_blank">Whitesnake&nbsp;</a></font>
   </div>
  </td>
</tr>
<tr>
   <td class="txt">
    <div align="right"><br>powered by Google™</div>
   </td>
</tr>
</table>
</form>
</body>
</html>|;
}