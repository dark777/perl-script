#!/usr/bin/perl

push(@INC,"cgi-bin");
###########################################################
#           T E R M O S   D E   L I C E N � A             #
###########################################################
#           N�O RETIRE O COPYRIGHT DO ARQUIVO             #
###########################################################
# Autor:         TodaviA Internet - WSSystem Solu��es     #
# Data:          03 abril de 2000                         #
# Copyright:     (C) 2000 All Rights Reserved.            #
###########################################################
# Este software � de propriedade exclusiva de seu autor.  #
# A licen�a adquirida refere-se ao uso apenas, e n�o      #
# autoriza o licenciado a ceder, vender, emprestar, locar #
# ou tornar p�blico o uso desta licen�a.                  #
# Qualquer altera��o feita neste software corre por total #
# conta e risco do licenciado, e n�o caracteriza o feito  #
# como co-autoria.                                        #
# A instala��o, execu��o e configura��o deste software    #
# correm por total conta e risco do licenciado e qualquer #
# dano decorrente destas a��es s�o de sua inteira         #
# responsabilidade.                                       #
###########################################################

##########################################################
# NOME:   T-TS1 - Teste Simulado    (C)2001 - TodaviA    #
#                                                        #
##########################################################
# Descri��o do Programa                                  #
# =====================                                  #
# Este sistema prop�e-se a criar analisar as respostas   #
# submetidas por um formul�rio especifico e gerar, caso  #
# os acertos forem superiores a 50%+0,1 um "certificado" #
# de bom resultado.                                      #
##########################################################
#        ******    I N S T A L A � � O    ******         #
# Verifique sa a 1� linha aponta para o interp. Perl de  #
# seu servidor (via telnet, digite "whereis perl")       #
# fa�a o up-load deste arquivo para seu servidor no modo #
# ASCII e altere a permiss�o do mesmo para 755.          #
#                                                        #
##########################################################

######         NAO ALTERE NADA AL�M DESTE PONTO     ######

##########################################################
&ReadParse;
print "Content-type: text/html\n\n";

if ($ENV{'REQUEST_METHOD'}ne 'POST')
{
	print <<"HTML";
	<HTML>
	<HEAD>
	<TITLE>M�todo errado</TITLE>
	<BODY BGCOLOR=red TEXT=yellow>
	<CENTER><h1>Desista</h1>
	<B>Acabamos de registrar sua tentativa de acesso.</B>
	</BODY></HTML>
HTML
	exit;
}
$quantas=$input{'quantas'};
$pontos=0;
$minimo=($quantas/2);
&cabecalho;
print "<table border=1>\n";
print "<caption align=\"Top\"><font size=\"-1\"><a href=$input{'site_url'}>$input{'site_nome'}</a></font></caption>\n";
print "<tr><th>Quest�o</th><th>Sua resposta</th><th>Resposta correta</th><th>Resultado</th></tr>\n";
for ($contador=1; $contador<($quantas+1); $contador++){
$questao[$contador]=$input{"questao$contador"};
$correta[$contador]=$input{"correta$contador"};
$resposta[$contador]=$input{"resposta$contador"};
if ($resposta[$contador] eq "$correta[$contador]"){
print "<tr><td>$questao[$contador]</td><td>$resposta[$contador]</td><td>$correta[$contador]</td><td bgcolor=green>Certo</td></tr>\n";
$pontos=($pontos + 1);
   }else{
print "<tr><td>$questao[$contador]</td><td>$resposta[$contador]</td><td>$correta[$contador]</td><td bgcolor=red>Errado</td></tr>\n";
   }
}
print "</table>\n";
$media_final=($quantas / 2)
$aprovacao=($$media_final + 0.1))
if ($pontos > $aprovacao){
print <<"HTML";

<FONT FACE="verdana,ms sans serif, ms serif, arial, helvetica" size="-1">
<H3>Parab�ns $input{'aluno'},</H3></center>
Voc� foi aprovado e abaixo est� seu certificado!<P>
<center>
<TABLE BORDER="0" CELLPADDING="50" width="90%">
<TR>
	<TD BGCOLOR="Teal">
<TABLE WIDTH="100%" BORDER="0" CELLPADDING="14">
<TR>
	<TD BGCOLOR="#E3FEFF"><FONT FACE="verdana,ms sans serif, ms serif, arial, helvetica" size="-1">
Em fun��o do �timo resultado obtido no<P>
<B><I>$input{'titulo'}</I></B><P>
Conferimos a<P>
<center><U><H2>$input{'aluno'},</H2></U></center><P>
<B>O presente Certificado de Honra ao M�rito</B><P>
Lembrando que o aluno acima referido acertou $pontos de um total de $quantas quest�es.<P>
 <I>Parab�ns</I><P>
</TD>
</TR>
</TABLE>
</TD>
</TR>
</TABLE>
<P>
<HR SIZE="1" WIDTH="100%" NOSHADE ALIGN="Center"><center>
<font size="-2" color="#797979">�2001 - <a href="http://www.todavia.com.br/scripts" target="nova">CGI-Center TodaviA</a></font></center>
</FONT></BODY></html>
HTML
&rodape;
exit();

} else {

print <<"HTML2";

<FONT FACE="verdana,ms sans serif, ms serif, arial, helvetica" size="-1">
<H3>Lamentamos, $input{'aluno'},</H3></center>
mas voc� foi <B><FONT COLOR="Red">Reprovado</FONT></B>.<P>
 A pontua��o m�nima � de $minimo - Seus pontos: $pontos<P>
<HR SIZE="1" WIDTH="100%" NOSHADE ALIGN="Center"><center>
<font size="-2" color="#797979">�2001 - <a href="http://www.todavia.com.br/scripts" target="nova">CGI-Center TodaviA</a></font></center>
</BODY></HTML>
HTML2
&rodape;
exit();
}
sub cabecalho{
open (ALTO,"alto.txt") || print "Problema na abertura do arquivo do cabe�alho.<br>Motivo\: $! \n";
while (<ALTO>) {
print $_;
	}
close(ALTO);
}
sub rodape{
open (BAIXO,"baixo.txt") || print "Problema na abertura do arquivo do rodape.<br>Motivo\: $! \n";
while (<BAIXO>) {
print $_;
	}
close(BAIXO);
}

sub ReadParse {

   read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
   @pairs = split(/&/, $buffer);
   foreach $pair (@pairs) {
      ($name, $value) = split(/=/, $pair);

      $value =~ tr/+/ /;
      $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

      $input{$name} = $value;
   }
}

### Acabou! Acabou!
### Um suco de laranja, por favor!