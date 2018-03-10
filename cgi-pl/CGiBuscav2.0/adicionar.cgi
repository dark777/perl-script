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

($min,$hour,$mday,$mon,$year,$wday) = (localtime(time))[1,2,3,4,5,6];

$year+=1900;
$mon+=1;
$mon = "0$mon" if $mon < 10;
$mday = "0$mday" if $mday < 10;
$min = "0$min" if $min < 10;
$hour = "0$hour" if $hour < 10;

open (cima,"cima.rse");
@cima = <cima>;
close (cima);

open (baixo,"baixo.rse");
@baixo = <baixo>;
close (baixo);


print "Content-type:text/html\n\n";

print @cima;
if (!$acao) {

print qq~<p align="center">
      <font face="Verdana" size="2" color="#FF0000">Cadastro de Sites</font></span></p>
      </p>
      <form method="POST" action="adicionar.cgi">
        <div align="center">
          <center>
          <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="45%">
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Nome do Site:</span></font></td>
              <td width="58%">
              <input type="text" name="nomesite" size="20" style="border-style: solid; border-width: 1; background-image:url('$imagens/fundo_form.jpg')"></td>
            </tr>
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Url do Site:</span></font></td>
              <td width="58%">
              <input type="text" name="urlsite" value="http://" size="20" style="border-style: solid; border-width: 1; background-image:url('$imagens/fundo_form.jpg')"></td>
            </tr>
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Seu Nome:</span></font></td>
              <td width="58%">
              <input type="text" name="nomewm" size="20" style="border-style: solid; border-width: 1; background-image:url('$imagens/fundo_form.jpg')"></td>
            </tr>
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Seu E-mail:</span></font></td>
              <td width="58%">
              <input type="text" name="email" size="20" style="border-style: solid; border-width: 1; background-image:url('$imagens/fundo_form.jpg')"></td>
            </tr>
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Categoria:</span></font></td>
              <td width="58%">
              <select size="1" name="categoria" style="border-style: solid; border-width: 1; background-image:url('$imagens/fundo_form.jpg')">
             
~;

open (cat, "cat.txt");
@cat = <cat>;
close ("cat");

foreach (@cat) {
($catx,$a) = split(/\|/, $_);

print qq~<option value="$catx">$catx</option>~;
}

print qq~</select></td>
            </tr>
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Descrição:</span></font></td>
              <td width="58%">
              <textarea rows="5" name="descricao" cols="16" style="border-style: solid; background-image: url('$imagens/fundo_form.jpg'); border-width: 1"></textarea></td>
            </tr>
          </table>
          </center>
        </div>
        <p align="center"><input type="submit" value="Cadastrar" name="B1"></p>
        <input type="hidden" name="acao" value="2">
      </form>~;

}

if ($acao eq '2') {

$nomesite = $query->param("nomesite");
$nomesite =~ s/</\&lt;/ig;
$nomesite =~ s/\|/ /ig;
$nomesite =~ s/>/\&gt;/ig;
$descricao = $query->param("descricao");
$descricao =~ s/\|/ /ig;
$descricao =~ s/\cM\n/ /g;
$descricao =~ s/</\&lt;/ig;
$descricao =~ s/>/\&gt;/ig;
$urlsite = $query->param("urlsite");
$urlsite =~ s/\|/ /ig;
$urlsite =~ s/</\&lt;/ig;
$urlsite =~ s/>/\&gt;/ig;
$data = "$mday/$mon/$year" ;
$nomewm = $query->param("nomewm");
$nomewm =~ s/\|/ /ig;
$nomewm =~ s/</\&lt;/ig;
$nomewm =~ s/>/\&gt;/ig;
$email = $query->param("email");
$email =~ s/\|/ /ig;
$email =~ s/</\&lt;/ig;
$email =~ s/>/\&gt;/ig;
$categoria = $query->param("categoria");
$codigo = time();

if (!$nomesite) { $erro = "Nome do Site necessário.<br>"; }
if (!$descricao) { $erro = "Descrição necessária.<br>"; }
if (!$urlsite) { $erro = "Url do Site é obrigatória.<br>"; }
if (!$nomewm) { $erro = "Seu nome é obrigatório.<br>"; }
if (!$email) { $erro = "Seu e-mail é obrigatório<br>"; }

if ($erro) { &erro; print @baixo; exit; }

open (bd, ">>bd/bdx.txt");
print bd "$nomesite|$descricao|$urlsite|$data|$nomewm|$email|$categoria|$codigo|\n";
close (bd);

print qq~<p align="center"><span lang="pt-br">
      <font face="Verdana" size="2" color="#FF0000">Cadastro de Sites</font></span></p>
      <p align="center"><font face="Verdana" size="2">Você realizou o cadastro 
      do site <a href="$urlsite">$nomesite</a> com sucesso. Guarde sua senha: <b>$codigo</b>.<br>
      Em breve seu site será avaliado.</font><p align="center">
      <font face="Verdana" size="2">Quando seu site for adicionado você receberá 
      um e-mail.</font><p align="center"><font face="Verdana" size="2">
      <a href="index.cgi">Voltar</a></font>~;

}

print @baixo;

sub erro {

print qq~<center><font color="red" size="2" face="Verdana">Erro: $erro</font><br>~;

}