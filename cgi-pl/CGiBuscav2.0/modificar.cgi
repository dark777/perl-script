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
$senhax = $query->param("senha");

open (cima,"cima.rse");
@cima = <cima>;
close (cima);

open (baixo,"baixo.rse");
@baixo = <baixo>;
close (baixo);

print "content-type:text/html\n\n";

print @cima;

if (!$idx) { 

print qq~ <p align="center"><span lang="pt-br"><font face="Verdana" size="2">
      Modificar Conta</font></span></p>
      <p align="center"><span lang="pt-br"><font face="Verdana" size="2">Digite 
      sua ID e sua senha:</font></span></p>
      <form method="POST" action="modificar.cgi">
        <div align="center">
          <center>
          <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="36%" height="44">
            <tr>
              <td width="72%" height="22"><font face="Verdana" size="2">ID:</font></td>
              <td width="50%" height="22">
              <input type="text" name="id" size="20" style="border-style: solid; border-width: 1; background-image:url('$imagens/fundo_form.jpg')"></td>
            </tr>
            <tr>
              <td width="72%" height="22"><font face="Verdana" size="2">Senha:
              </font></td>
              <td width="50%" height="22">
              <input type="password" name="senha" size="20" style="border-style: solid; border-width: 1; background-image:url('$imagens/fundo_form.jpg')"></td>
            </tr>
          </table>
          </center>
        </div>
        <p align="center"><input type="submit" value="Entrar" name="B1"></p>
      </form>~;
print @baixo;
exit;
}
else {

open(bd, "bd/bd.txt");
@bd = <bd>;
@bd = reverse(@bd);
close(bd);
$total = "0";

foreach (@bd) {
($id,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senha,$axx) = split(/\|/, $_);

if ($idx eq $id && $senha eq $senhax) { &checar; exit;}
}
print qq~<p align="center"><span lang="pt-br"><font face="Verdana" size="2">
      Modificar Conta</font></span></p>
      <p align="center"><span lang="pt-br"><font face="Verdana" size="2">Erro:
      <font color="#FF0000">ID ou senha inválidos</font></font></span></p>
      <p align="center"><span lang="pt-br"><font face="Verdana" size="2">Digite 
      sua ID e sua senha:</font></span></p>
      <form method="POST" action="modificar.cgi">
        <div align="center">
          <center>
          <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="36%" height="44">
            <tr>
              <td width="72%" height="22"><font face="Verdana" size="2">ID:</font></td>
              <td width="50%" height="22">
              <input type="text" name="id" size="20"></td>
            </tr>
            <tr>
              <td width="72%" height="22"><font face="Verdana" size="2">Senha:
              </font></td>
              <td width="50%" height="22">
              <input type="password" name="senha" size="20"></td>
            </tr>
          </table>
          </center>
        </div>
        <p align="center"><input type="submit" value="Entrar" name="B1"></p>
      </form>~; print @baixo;
}

sub checar {

$codigo = $query->param("codigo");

if ($codigo) {

open(bd, "bd/bd.txt");
@bd = <bd>;
close(bd);

foreach (@bd) {
($id,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senhax,$a33) = split(/\|/, $_);
if ($id eq $idx) {


$nomex = $query->param("nomesite");
$nomex =~ s/</\&lt;/ig;
$nomex =~ s/\|/ /ig;
$nomex =~ s/>/\&gt;/ig;
$descricaox = $query->param("descricao");
$descricaox =~ s/\|/ /ig;
$descricaox =~ s/\cM\n/ /g;
$descricaox =~ s/</\&lt;/ig;
$descricaox =~ s/>/\&gt;/ig;
$urlx = $query->param("urlsite");
$urlx =~ s/\|/ /ig;
$urlx =~ s/</\&lt;/ig;
$urlx =~ s/>/\&gt;/ig;
$nomewmx = $query->param("nomewm");
$nomewmx =~ s/\|/ /ig;
$nomewmx =~ s/</\&lt;/ig;
$nomewmx =~ s/>/\&gt;/ig;
$emailx = $query->param("email");
$emailx =~ s/\|/ /ig;
$emailx =~ s/</\&lt;/ig;
$emailx =~ s/>/\&gt;/ig;
$catx = $query->param("categoria");
$senhaxx = $query->param("senhax");
$senhaxx =~ s/\|/ /ig;
$senhaxx =~ s/</\&lt;/ig;
$senhaxx =~ s/>/\&gt;/ig;

open (bdm,">>bd/bdm.txt");
print bdm "$idx|$nomex|$descricaox|$urlx|$data|$cliques|$nomewmx|$emailx|$catx|$senhaxx|a\n";
close (bdm);

print qq~      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">As suas modificações foram 
      enviadas com sucesso.<br>
      Seu site estará aguardando por uma aprovação.</font></p>
      <p align="center"><font face="Verdana" size="2"><a href="index.cgi">Voltar</a></font></p>
      <p align="center">      
      <p>

      </p>
     
     
      <p align="center"><font face="Verdana" size="1"><br>
      <a href="http://www.scriptsnan.rg3.net">
      www.scriptsnan.rg3.net</a></font><font size="1"><br>~;
print @baixo;
exit;
}
}


}

else {

$codigo = time();
open(bd, "bd/bd.txt");
@bd = <bd>;
close(bd);

foreach (@bd) {
($id,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senhax,$a33) = split(/\|/, $_);
if ($id eq $idx) {
print qq~<p align="center"><font face="Verdana" size="2">Modificar Cadastro</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      $nomewm</font></p>
      <p align="center"><font face="Verdana" size="2">Editando id $id</font></p>
      <p align="center">      <form method="POST" action="modificar.cgi">
        <input type="hidden" name="senha" value="$senhax">
        <input type="hidden" name="id" value="$idx">
        <input type="hidden" name="codigo" value="$codigo">
        <div align="center">
          <center>
          <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="45%">
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Nome do Site:</span></font></td>
              <td width="58%">
              <input type="text" name="nomesite" size="20" style="border-style: solid; border-width: 1; background-image:url('$imagens/fundo_form.jpg')" value="$nome"></td>
            </tr>
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Url do Site:</span></font></td>
              <td width="58%">
              <input type="text" name="urlsite" size="20" style="border-style: solid; border-width: 1; background-image:url('$imagens/fundo_form.jpg')" value="$url"></td>
            </tr>
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Seu Nome:</span></font></td>
              <td width="58%">
              <input type="text" name="nomewm" size="20" style="border-style: solid; border-width: 1; background-image:url('$imagens/fundo_form.jpg')" value="$nomewm"></td>
            </tr>
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Seu E-mail:</span></font></td>
              <td width="58%">
              <input type="text" name="email" size="20" style="border-style: solid; border-width: 1; background-image:url('$imagens/fundo_form.jpg')" value="$email"></td>
            </tr>
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Categoria:</span></font></td>
              <td width="58%">
              <select size="1" name="categoria" style="border-style: solid; border-width: 1">~;
open (cat, "cat.txt");
@cat = <cat>;
close ("cat");

foreach (@cat) {
($catx,$a33) = split(/\|/, $_);

print qq~<option value="$catx">$catx</option>~;
}

print qq~</select></td>
            </tr>
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Descrição:</span></font></td>
              <td width="58%">
              <textarea rows="5" name="descricao" cols="16" style="border-style: solid; background-image: url('$imagens/fundo_form.jpg'); border-width: 1">$descricao</textarea></td>
            </tr>
            <tr>
              <td width="42%"><span lang="pt-br"><font face="Verdana" size="2">
              Senha:</font></span></td>
              <td width="58%">
              <input type="password" name="senhax" size="20" style="border-style: solid; border-width: 1; background-image:url('$imagens/fundo_form.jpg')" value="$senhax"></td>
            </tr>
            <tr>
              <td width="42%"><span lang="pt-br"><font face="Verdana" size="2">
              ID:</font></span></td>
              <td width="58%">
              <font face="Verdana" size="2">$id</font></td>
            </tr>
          </table>
          </center>
        </div>
        <p align="center"><input type="submit" value="Modificar" name="B1"></p>
      </form>~;
print @baixo;
exit;
}
}
}

}