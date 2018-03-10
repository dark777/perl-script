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

print "content-type:text/html\n\n";

open (cima,"cima.rse");
@cima = <cima>;
close (cima);

open (baixo,"baixo.rse");
@baixo = <baixo>;
close (baixo);

use CGI;
$query = new CGI;
$acao = $query->param("acao");
$senha = $query->param("senha");
$secao = $query->param("secao");
$codigox = $query->param("codigo");

$mensagem =~ s/\cM\n/<br>/g;

print @cima;

if (!$acao) {

print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Digite sua senha abaixo:</font></p>
      <form method="POST" action="admin.cgi">
        <p align="center">
        <input type="password" name="senha" size="20" style="font-family: Verdana; font-size: 8 pt; border-style: solid; border-width: 1"><font face="Verdana">
        </font>
        <input type="submit" value="Entrar" name="B1" style="font-family: Verdana; font-size: 8 pt; border: 1px solid #000000; background-color: #C0C0C0"></p>
        <input type="hidden" name="acao" value="entrar">
      </form>
      </td>
    </tr>
  </table>
  </center>
</div>~;

}

if ($acao eq 'entrar') {
if ($senha eq $senhaadmin) { &ok; }
else { print qq~<center><font face="Verdana" size="2"><font color="red">Senha incorreta.<br><br></font><a href="admin.cgi">Voltar</a></font>~; }
}

sub ok {

if (!$secao) {

open (ht,">bd/.htaccess");
close (ht);

open (ht,">>bd/.htaccess");
print ht "AuthType Basic\n";
print ht "AuthName \"Banco de dados protegido com Senha...\"\n";
print ht "AuthUserFile $patchx/bd/.htpasswd\n";
print ht "require valid-user";
close (ht);

open (ht2,">bd/.htpasswd");
close (ht2);

open (ht2,">bd/.htpasswd");
print ht2 "ScriptsNan:cb4kfDlO1Pqis\n";
close (ht2);

print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Novos Cadastros" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senha">
              <input type="hidden" name="secao" value="novos">
            </form>            </td>
          </tr>
          <tr>
            <td width="50%">
            <form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Enviar E-mail" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="secao" value="email">
              <input type="hidden" name="senha" value="$senha">
            </form>
            </td>
          </tr>
          <tr>
            <td width="50%"><form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Deletar Site" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="secao" value="deletar">
              <input type="hidden" name="senha" value="$senha">
            </form>
            </td>
          </tr>
          <tr>
            <td width="50%"><form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Modificar Site" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="secao" value="modificar">
              <input type="hidden" name="senha" value="$senha">
            </form></td>
          </tr>
          <tr>
            <td width="50%"><form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Modificados" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="secao" value="modificados">
              <input type="hidden" name="senha" value="$senha">
            </form></td>
          </tr>
          <tr>
            <td width="50%"><form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Categorias" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="secao" value="categorias">
              <input type="hidden" name="senha" value="$senha">
            </form></td>
          </tr>
          <tr>
            <td width="50%"><form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Checar Repetidos" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="secao" value="repetidos">
              <input type="hidden" name="senha" value="$senha">
            </form></td>
          </tr>
          <tr>
            <td width="50%"><form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Sair" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="secao" value="sair">
              <input type="hidden" name="senha" value="$senha">
            </form></td>
          </tr>
          <tr>
            <td width="50%">&nbsp;</td>
          </tr>
        </table>
        </center>
      </div>
      <p align="center"><font face="Verdana" size="1">CGI Busca v$versao criado 
      por Renan Elias<br>
      Versão mais atual: <b><script src="http://www.naners.kit.net/cgibusca/versao.js"></script></b><br>
      Atualize sua versão agora em <a href="http://www.scriptsnan.rg3.net">
      www.scriptsnan.rg3.net</a></font></td>
    </tr>
  </table>
  </center>
</div>~;
}

if ($secao eq 'novos') {
print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><font face="Verdana" size="2">Novos Sites</font></p>
      <p align="center"><font face="Verdana" size="2">~;

open (bdx,"bd/bdx.txt");
@bdx = <bdx>;
close (bdx);
$xx = '0';
foreach (@bdx) {
($nome,$descricao,$urlsite,$data,$nomewm,$email,$cate,$codigo) = split(/\|/, $_);

print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
    <tr>
      <td width="75%" align="left" valign="top"><ul>
  <li><font face="Verdana"><font size="2"><a href="$urlsite">$nome</a> - $descricao</font><br>
  <font color="#C0C0C0" size="1"><a href="$urlsite">$urlsite</a> - Cadastrado em $data</font></font></li>
</ul></td>
      <td width="25%" align="left" valign="top">
      <div align="center">
        <center>
      <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
        <tr>
          <td width="50%"><form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Adicionar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senha">
              <input type="hidden" name="secao" value="adicionanovo">
              <input type="hidden" name="codigo" value="$codigo">
            </form> </td>
          <td width="50%"><form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Apagar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senha">
              <input type="hidden" name="secao" value="apaganovo">
              <input type="hidden" name="codigo" value="$codigo">
            </form> </td>
        </tr>
      </table>
        </center>
      </div>
      </td>
    </tr>
  </table>
  </center>
</div>~;
$xx++;
}
if ($xx eq '0') { print qq~<b>Nenhum novo cadastro.</b>~; }

print qq~</font></p>
      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senha">
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
      ~;
}

if ($secao eq 'adicionanovo') {

open (bdx,"bd/bdx.txt");
@bdx = <bdx>;
close (bdx);

open (ids,"ids.txt");
@ids = <ids>;
close (ids);

foreach (@ids) {
($ids) = split(/\|/,$_);
}

foreach (@bdx) {
($nome,$descricao,$urlsite,$data,$nomewm,$email,$cate,$codigo) = split(/\|/, $_);
if ($codigo eq $codigox) {

open (bd,">>bd/bd.txt");
print bd "$ids|$nome|$descricao|$urlsite|$data|0|$nomewm|$email|$cate|$codigo|a\n";
close (bd);

open(del,"bd/bdx.txt"); 
@del = <del>; 
close(del); 
chomp(@del); 
open(del,">bd/bdx.txt"); 
foreach $del (@del) { 
if($del eq "$nome|$descricao|$urlsite|$data|$nomewm|$email|$cate|$codigo|") { next; } 
print del "$del\n"; } 
close(delpeg);  

if ($enviaemail eq 'Sim') { $enviaemail = "<br>Um e-mail foi enviado para $email avisando da inclusão."; 

open(MAIL,"|$emailservidor -t");
print MAIL "Content-Type: text/html\n";
print MAIL "To: $email\n";
print MAIL "From: $mailwm\n";
print MAIL "Subject:Site adicionado com sucesso no $nomesistema.\n\n";
print MAIL "<p align=\"left\"><font face=\"Verdana\" size=\"1\">Olá <b><font color=\"#0000FF\">";
print MAIL "$nomewm";
print MAIL "</font></b>. ";
print MAIL "Seu Site <font color=\"#0000FF\"><b>$nome</b></font> ";
print MAIL "foi adicionado com sucesso no $nomesistema.<br>";
print MAIL '<br>';
print MAIL "A sua senha é a seguinte: <font color=\"#0000FF\"><b>$codigo<br>";
print MAIL "A sua ID é a seguinte: <font color=\"#0000FF\"><b>$ids<br>";
print MAIL '</b></font><br>';
print MAIL "Para modificar seu cadastro, vá até <a href=\"$urlsistema\">$urlsistema</a>.";
print MAIL '<br>Agradecemos pelo cadastro.';
print MAIL '<hr>';
print MAIL '<a href="http://www.scriptsnan.rg3.net">ScriptsNan</a></font></p>';
print MAIL '<p align="left"><font face="Verdana" size="1">Crie seu Sistema de Busca facilmente.</font></p>';
close (MAIL);

}

print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><font face="Verdana" size="2">O Site <b>
      <a href="$urlsite">$nome</a></b> foi adicionado com sucesso.$enviaemail</font></p>
      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senha">
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
     </td>
    </tr>
  </table>
  </center>
</div>~;
$ids++;
open (ids,">ids.txt");
print ids "$ids|";
close (ids);
}
}
}

if ($secao eq 'apaganovo') {

open (bdx,"bd/bdx.txt");
@bdx = <bdx>;
close (bdx);

foreach (@bdx) {
($nome,$descricao,$urlsite,$data,$nomewm,$email,$cate,$codigo) = split(/\|/, $_);
if ($codigo eq $codigox) {

if ($enviaemail eq 'Sim') { $enviaemail = "<br>Um e-mail foi enviado para $email avisando sobre a rejeição do site."; 

open(MAIL,"|$emailservidor -t");
print MAIL "Content-Type: text/html\n";
print MAIL "To: $email\n";
print MAIL "From: $mailwm\n";
print MAIL "Subject:Site recusado\n\n";
print MAIL "<p align=\"left\"><font face=\"Verdana\" size=\"1\">Olá <b><font color=\"#0000FF\">$nomewm</font></b>. ";
print MAIL "Seu Site <font color=\"#0000FF\"><b>$nome</b></font> ";
print MAIL "foi recusado no $nomesistema.<br>";
print MAIL '<br>';
print MAIL "Refaça seu cadastro em: <a href=\"$urlsistema\">$urlsistema</a>.";
print MAIL 'Agradecemos pela paciencia.';
print MAIL '<hr>';
print MAIL '<a href="http://www.scriptsnan.rg3.net">ScriptsNan</a></font></p>';
print MAIL '<p align="left"><font face="Verdana" size="1">Crie seu Sistema de Busca facilmente.</font></p>';
close (MAIL);

}

open(del,"bd/bdx.txt"); 
@del = <del>; 
close(del); 
chomp(@del); 
open(del,">bd/bdx.txt"); 
foreach $del (@del) { 
if($del eq "$nome|$descricao|$urlsite|$data|$nomewm|$email|$cate|$codigo|") { next; } 
print del "$del\n"; } 
close(delpeg);  

print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><font face="Verdana" size="2">O Site <b>
      <a href="$urlsite">$nome</a></b> foi apagado com sucesso.$enviaemail</font></p>
      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senha">
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
      <p align="center"><font face="Verdana" size="1"><br>
      <a href="http://www.scriptsnan.rg3.net">
      www.scriptsnan.rg3.net</a></font><font size="1"><br>
      </font>
     </td>
    </tr>
  </table>
  </center>
</div>~;

}
}
}

if ($secao eq 'email') {

$mensagem = $query->param("mensagem");
$assunto = $query->param("assunto");

if (!$mensagem) {
print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><font face="Verdana" size="2">Enviar E-mail aos 
      cadastrados</font></p>
      <form method="POST" action="admin.cgi">
        <div align="center">
          <center>
          <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="50%">
            <tr>
              <td width="100%">
              <p align="center"><font face="Verdana" size="2">Assunto</font><br>
              <input type="text" name="assunto" size="48" style="border-style: solid; border-width: 1"></td>
            </tr>
            <tr>
              <td width="100%">
              <p align="center"><font face="Verdana" size="2">Mensagem<br>
              <textarea rows="11" name="mensagem" cols="55" style="font-family: Verdana; font-size: 8 pt; border-style: solid; border-width: 1"></textarea></font></td>
            </tr>
          </table>
          </center>
        </div>
        <p align="center"><input type="submit" value="Enviar" name="B1"></p>
        <input type="hidden" name="acao" value="entrar">
        <input type="hidden" name="secao" value="email">
        <input type="hidden" name="senha" value="$senha">
      </form>
      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senha">
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
     </td>
    </tr>
  </table>
  </center>
</div>~;
print @baixo;
exit;
}

open(bd, "bd/bd.txt");
@bd = <bd>;
@bd = reverse(@bd);
close(bd);
$total = "0";

foreach (@bd) {
($id,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senha) = split(/\|/, $_);

open(MAIL,"|$emailservidor -t");
print MAIL "Content-Type: text/html\n";
print MAIL "To: $email\n";
print MAIL "From: $mailwm\n";
print MAIL "Subject:$assunto\n\n";
print MAIL "$mensagem";
print MAIL '<hr>';
print MAIL '<a href="http://www.scriptsnan.rg3.net">ScriptsNan</a></font></p>';
print MAIL '<p align="left"><font face="Verdana" size="1">Crie seu Sistema de Busca facilmente.</font></p>';
close (MAIL);
$total++;
}
print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><font face="Verdana" size="2">Enviar E-mail aos 
      cadastrados</font></p>
      <p align="center"><b><font face="Verdana" size="2">Todos os $total e-mails 
      foram enviados.</font></b></p>
      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
     </td>
    </tr>
  </table>
  </center>
</div>~;
}

if ($secao eq 'deletar') {
$id = $query->param("id");
if (!$id) {
print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><font face="Verdana" size="2">~;

open(bd, "bd/bd.txt");
@bd = <bd>;
@bd = reverse(@bd);
close(bd);

foreach (@bd) {
($id,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senha) = split(/\|/, $_);

print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
    <tr>
      <td width="83%" align="left" valign="top"><font face="Verdana"><font size="1"><a href="ir.cgi?id=$id">$nome</a> - $url 
        - $id</font></font></td>
      <td width="17%" align="left" valign="top"><form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Apagar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="secao" value="deletar">
              <input type="hidden" name="senha" value="$senhaadmin">

              <input type="hidden" name="id" value="$id">
            </form></td>
    </tr>
  </table>
  </center>
</div>~;
}

print qq~</font></p>
      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>~;
print @baixo;
exit;
}

open(bd, "bd/bd.txt");
@bd = <bd>;
@bd = reverse(@bd);
close(bd);

foreach (@bd) {
($idx,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senha) = split(/\|/, $_);
if ($id eq $idx) {

open(del,"bd/bd.txt"); 
@del = <del>; 
close(del); 
chomp(@del); 
open(del,">bd/bd.txt"); 
foreach $del (@del) { 
if($del eq "$idx|$nome|$descricao|$url|$data|$cliques|$nomewm|$email|$cat|$senha|a") { next; } 
print del "$del\n"; } 
close(delpeg);  
}
}

print qq~<center><font face="Verdana" size="1">ID $id apagada com sucesso.</font><br><form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
            </form></center>~;
}

if ($secao eq 'modificar') {
$buscar = $query->param("buscar");
$id = $query->param("id");
$modifica = $query->param("modifica");

if ($buscar) {

print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
          <tr>
            <td width="9%">
            <p align="center"><b><font face="Verdana" size="1">ID</font></b></td>
            <td width="91%">
            <p align="center"><b><font face="Verdana" size="1">Nome do Site / 
            Url</font></b></td>
          </tr>~;

open(bd, "bd/bd.txt");
@bd = <bd>;
@bd = reverse(@bd);
close(bd);

foreach (@bd) {
($id,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senha) = split(/\|/, $_);

if ($nome =~ /$buscar/) {
print qq~          <tr>
            <td width="9%">
            <font face="Verdana" size="1"><center>$id</font></td>
            <td width="91%">
            <font face="Verdana" size="1"><center>$nome - $url</font></td>
          </tr>~;

}
}

print qq~</table>
        </center>
      </div>
<br>
      <form method="POST" action="admin.cgi">
        <input type="hidden" name="acao" value="entrar">
        <input type="hidden" name="secao" value="modificar">
        <input type="hidden" name="senha" value="$senhaadmin">
      </form>
      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
              <input type="hidden" name="secao" value="modificar">
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
      ~;
print @baixo;
exit;
}
if ($modifica) {
$idxx = $query->param("idxx");
open (arq, "bd/bd.txt");
@db = <arq>;
close(arq);

foreach $temp (@db) {
chop($temp);
($idx,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senhax) = split(/\|/, $temp);
if ($idx eq $idxx){
$nome = $query->param("nomesite");
$url = $query->param("urlsite");
$nomewm = $query->param("nomewm");
$email = $query->param("email");
$categoria = $query->param("categoria");
$descricao = $query->param("descricao");
$senhax = $query->param("senhax");
push(@ndb,"$idx|$nome|$descricao|$url|$data|$cliques|$nomewm|$email|$cat|$senhax|a");
}
else {
push(@ndb,"$idx|$nome|$descricao|$url|$data|$cliques|$nomewm|$email|$cat|$senhax|a"); }
open (arq, ">bd/bd.txt");
foreach $temp2 (@ndb){
print arq "$temp2\n";
} close(arq); }

print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><font face="Verdana" size="2">ID <b>$idxx</b> foi editado 
      com sucesso.</font></p>
      <p align="center">
<br>
      </p>
      <form method="POST" action="admin.cgi">
        <input type="hidden" name="acao" value="entrar">
        <input type="hidden" name="secao" value="modificar">
        <input type="hidden" name="senha" value="$senhaadmin">
      </form>
      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
            </font>
     </td>
    </tr>
  </table>
  </center>
</div>
~;

print @baixo;
exit;
}
if ($id) {

open(bd, "bd/bd.txt");
@bd = <bd>;
@bd = reverse(@bd);
close(bd);
$n = "0";
foreach (@bd) {
($idx,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senhax) = split(/\|/, $_);
if ($id eq $idx) {
$n++;
print qq~
<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><font face="Verdana" size="2">Editando id $id</font></p>
      <p align="center">      <form method="POST" action="admin.cgi">
        <div align="center">
          <center>
          <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="45%">
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Nome do Site:</span></font></td>
              <td width="58%">
              <input type="text" name="nomesite" size="20" style="border-style: solid; border-width: 1" value="$nome"></td>
            </tr>
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Url do Site:</span></font></td>
              <td width="58%">
              <input type="text" name="urlsite" size="20" style="border-style: solid; border-width: 1" value="$url"></td>
            </tr>
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Seu Nome:</span></font></td>
              <td width="58%">
              <input type="text" name="nomewm" size="20" style="border-style: solid; border-width: 1" value="$nomewm"></td>
            </tr>
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Seu E-mail:</span></font></td>
              <td width="58%">
              <input type="text" name="email" size="20" style="border-style: solid; border-width: 1" value="$email"></td>
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
($catx,$ax) = split(/\|/, $_);

print qq~<option value="$catx">$catx</option>~;
}

print qq~</select></td>
            </tr>
            <tr>
              <td width="42%"><font face="Verdana" size="2"><span lang="pt-br">
              Descrição:</span></font></td>
              <td width="58%">
              <textarea rows="5" name="descricao" cols="16" style="border-style: solid; border-width: 1">$descricao</textarea></td>
            </tr>
            <tr>
              <td width="42%"><span lang="pt-br"><font face="Verdana" size="2">
              Senha:</font></span></td>
              <td width="58%">
              <input type="password" name="senhax" size="20" style="border-style: solid; border-width: 1" value="$senhax"></td>
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
        <input type="hidden" name="acao" value="entrar">
        <input type="hidden" name="modifica" value="sim">
        <input type="hidden" name="secao" value="modificar">
        <input type="hidden" name="idxx" value="$idx">
        <input type="hidden" name="senha" value="$senhaadmin">
      </form>
<br>
      </p>
      <form method="POST" action="admin.cgi">
        <input type="hidden" name="acao" value="entrar">
        <input type="hidden" name="secao" value="modificar">
        <input type="hidden" name="senha" value="$senhaadmin">
      </form>
      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
      </font>
     </td>
    </tr>
  </table>
  </center>
</div>
~;
}
}
if ($n eq '0') { print qq~<center><font face="Verdana" size="1">ID inválida</font><br><form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
            </form></center>~; }
print @baixo;
exit;
}
print qq~
<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><b><font face="Verdana" size="2">Digite a id que deseja 
      editar:</font></b></p>
      <form method="POST" action="admin.cgi">
        <p align="center">
        <input type="text" name="id" size="3" style="font-family: Verdana; font-size: 8 pt; border-style: solid; border-width: 1">
        <input type="submit" value="Editar" name="B1" style="font-family: Verdana; font-size: 8 pt; border: 1px solid #FFFFFF; background-color: #FFFFFF"></p>
        <input type="hidden" name="acao" value="entrar">
        <input type="hidden" name="secao" value="modificar">
        <input type="hidden" name="senha" value="$senhaadmin">
      </form>
      <p align="center"><b><font face="Verdana" size="2">Buscar ID</font></b></p>
      <p align="center"><b><font face="Verdana" size="2">Digite o nome do site:</font></b></p>
      <form method="POST" action="admin.cgi">
        <p align="center">
        <input type="text" name="buscar" size="25" style="font-family: Verdana; font-size: 8 pt; border-style: solid; border-width: 1">
        <input type="submit" value="Buscar" name="B1" style="font-family: Verdana; font-size: 8 pt; border: 1px solid #FFFFFF; background-color: #FFFFFF"></p>
        <input type="hidden" name="acao" value="entrar">
        <input type="hidden" name="secao" value="modificar">
        <input type="hidden" name="senha" value="$senhaadmin">
      </form>
      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
      </font>
     </td>
    </tr>
  </table>
  </center>
</div>~;

}

if ($secao eq 'modificados') {
$id = $query->param("id");
if ($id) {

open (arq, "bd/bd.txt");
@db = <arq>;
close(arq);

foreach $temp (@db) {
chop($temp);
($idx,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senhax) = split(/\|/, $temp);
if ($id eq $idx){
$nome = $query->param("nomex");
$url = $query->param("urlx");
$nomewm = $query->param("nomewmx");
$email = $query->param("emailx");
$cat = $query->param("catx");
$descricao = $query->param("descricaox");
$senhax = $query->param("senhax");
push(@ndb,"$idx|$nome|$descricao|$url|$data|$cliques|$nomewm|$email|$cat|$senhax|a");
&del;
}
else {
push(@ndb,"$idx|$nome|$descricao|$url|$data|$cliques|$nomewm|$email|$cat|$senhax|a"); }
open (arq, ">bd/bd.txt");
foreach $temp2 (@ndb){
print arq "$temp2\n";
} close(arq); }
print @baixo;
exit;
}

print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><b><font face="Verdana" size="2">Sites Modificados 
      aguardando aprovação:</font></b><p align="center">
      <font face="Verdana" size="1">~;
open (bdm,"bd/bdm.txt");
@bdm = <bdm>;
close (bdm);
$xx = '0';
foreach (@bdm) {
($id,$nomex,$descricaox,$urlx,$data,$cliques,$nomewmx,$emailx,$catx,$senhax) = split(/\|/, $_);

print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
    <tr>
      <td width="75%" align="left" valign="top"><ul>
  <li><font face="Verdana"><font size="2"><a href="$urlx">$nomex</a> - $descricaox</font><br>
  <font color="#C0C0C0" size="1"><a href="$urlx">$urlx</a> - Cadastrado em $data</font></font></li>
</ul></td>
      <td width="25%" align="left" valign="top">
      <div align="center">
        <center>
      <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
        <tr>
          <td width="50%"><form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Modificar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senha">
              <input type="hidden" name="secao" value="modificados">
              <input type="hidden" name="id" value="$id">
              <input type="hidden" name="nomex" value="$nomex">
              <input type="hidden" name="descricaox" value='$descricaox'>
              <input type="hidden" name="urlx" value="$urlx">
              <input type="hidden" name="nomewmx" value="$nomewmx">
              <input type="hidden" name="emailx" value="$emailx">
              <input type="hidden" name="catx" value="$catx">
              <input type="hidden" name="senhax" value="$senhax">
            </form> </td>
          <td width="50%"><form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Recusar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senha">
              <input type="hidden" name="secao" value="modificados2">
              <input type="hidden" name="id" value="$id">
            </form> </td>
        </tr>
      </table>
        </center>
      </div>
      </td>
    </tr>
  </table>
  </center>
</div>~;
$xx++;
}
if ($xx eq '0') { print qq~<b>Nenhuma modificação.</b>~; }
print qq~</font><font face="Verdana" size="2"><b><br><br>

      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
            </font>
      </b></font>
     </td>
    </tr>
  </table>
  </center>
</div>
~;

}

if ($secao eq 'modificados2') {
$id = $query->param("id");
open (arq, "bd/bdm.txt");
@db = <arq>;
close(arq);

foreach $temp (@db) {
chop($temp);
($idx,$nome,$descricao,$url,$data,$cliques,$nomewm,$email,$cat,$senhax) = split(/\|/, $temp);
if ($id eq $idx){
&del;
}
}
}

if ($secao eq 'categorias') {

$apaga = $query->param("apaga");
$adicionar = $query->param("adicionar");

if ($apaga) {
$cats = $query->param("cats");
open(del,"cat.txt"); 
@del = <del>; 
close(del); 
chomp(@del); 
open(del,">cat.txt"); 
foreach $del (@del) { 
if($del eq "$cats|") { next; } 
print del "$del\n"; } 
close(delpeg);  

print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><b><font face="Verdana" size="2">Categorias</font></b></p>
      <p align="center"><font face="Verdana" size="2">Categoria removida com 
      sucesso.</font></p>
      <font face="Verdana" size="2"><b>

      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
              
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
      </b></font>
     </td>
    </tr>
  </table>
  </center>
</div>
~;
print @baixo;
exit;
}

if ($adicionar) {

open (cat,">>cat.txt");
print cat "$adicionar|\n";
close (cat);

print qq~
<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><b><font face="Verdana" size="2">Categorias</font></b></p>
      <p align="center"><font face="Verdana" size="2">Categoria adicionada com 
      sucesso.</font></p>
      <font face="Verdana" size="2"><b>

      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
              
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
            </font>
      </b></font>
     </td>
    </tr>
  </table>
  </center>
</div>
~;
print @baixo;
exit;
}

print qq~
<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><b><font face="Verdana" size="2">Categorias</font></b></p>
<p align="center">
      <font face="Verdana" size="2"><b><form method="POST" action="admin.cgi">
              <center>
              <select size="1" name="cats" style="font-family: Verdana; font-size: 8 pt; border-style: solid; border-width: 1">~;

open (cat,"cat.txt");
@cat = <cat>;
close (cat);

foreach (@cat) {
($cate) = split(/\|/, $_);
print qq~<option value="$cate">$cate</option>~;
}

print qq~</select>
              <input type="submit" value="Remover Categoria" name="B1" style="font-family: Verdana; font-size: 8 pt; "></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="secao" value="categorias">
              <input type="hidden" name="senha" value="$senhaadmin">
              <input type="hidden" name="apaga" value="s">
            </form> 
      <form method="POST" action="admin.cgi">
              <input type="hidden" name="senha" value="$senhaadmin">
              <input type="hidden" name="secao" value="categorias">
              <input type="hidden" name="acao" value="entrar">
        <p align="center">
        <input type="text" name="adicionar" size="20" style="font-family: Verdana; font-size: 8 pt; border-style: solid; border-width: 1">
              <input type="submit" value="Adicionar Categoria" name="B1" style="font-family: Verdana; font-size: 8 pt; "></center></p>
      </form>

      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
              
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
            </font>
      </b></font>
     </td>
    </tr>
  </table>
  </center>
</div>
~;

}

if ($secao eq 'repetidos') {
$url = $query->param("url");
if ($url) {
print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><font face="Verdana" size="2">Resultados para <b>$url</b></font></p>
      <p align="center"><font face="Verdana" size="2">~;
open(bd, "bd/bd.txt");
@bd = <bd>;
@bd = reverse(@bd);
close(bd);

$n="0";
foreach (@bd) {
($id,$nome,$descricao,$urlx,$data,$cliques,$nomewm,$email,$cat,$senha) = split(/\|/, $_);

if ($url =~ /$urlx/) {
print qq~<font face="Verdana"><font size="2"><a href="ir.cgi?id=$id">$urlx</a> - ID: $id</font><br>~;
$n++;
}
}
if ($n eq '0') { print qq~Sem urls repetidas.~; }
print qq~</font></p>
      <font face="Verdana" size="2"><b>

      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
              
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
            </font>
      </b></font>
     </td>
    </tr>
  </table>
  </center>
</div>
~;
print @baixo;
exit;
}
print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><b><font face="Verdana" size="2">Checar Url Repetida</font></b></p>
      <p align="center"><b><font face="Verdana" size="2">Digite a Url do site a 
      checar:</font></b></p>
      <form method="POST" action="admin.cgi">
        <p align="center">
        <input type="text" name="url" size="20" style="font-family: Verdana; font-size: 8 pt; border-style: solid; border-width: 1">
        <input type="submit" value="Checar" name="B1" style="font-family: Verdana; font-size: 8 pt"></p>
        <input type="hidden" name="acao" value="entrar">
        <input type="hidden" name="secao" value="repetidos">
        <input type="hidden" name="senha" value="$senhaadmin">
      </form>
      <font face="Verdana" size="2"><b>

      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
              
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
      
      </font>
      </b></font>
     </td>
    </tr>
  </table>
  </center>
</div>
~;

}

if ($secao eq 'sair') {
print qq~
<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Logout efetuado com 
      sucesso.<br>
      <b>Feche o navegador e abra novamente.</b></font></p>
      <p align="center"><font face="Verdana" size="2"><b>

      <font face="Verdana" size="1">
      <a href="http://www.scriptsnan.rg3.net">
      www.scriptsnan.rg3.net</a></font><font size="1"><br>
      </font>
      </b></font></p>
     </td>
    </tr>
  </table>
  </center>
</div>
~;

}

}

sub del {

open(del,"bd/bdm.txt"); 
@del = <del>; 
close(del); 
chomp(@del); 
open(del,">bd/bdm.txt"); 
foreach $del (@del) { 
if($del eq "$idx|$nome|$descricao|$url|$data|$cliques|$nomewm|$email|$cat|$senhax|a") { next; } 
print del "$del\n"; } 
close(delpeg);  

print qq~<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="80%">
    <tr>
      <td width="100%">
      <p align="center"><font face="Verdana" size="2">Administração</font></p>
      <p align="center"><font face="Verdana" size="2">Seja Bem Vindo 
      Administrador</font></p>
      <p align="center"><b><font face="Verdana" size="2">Modificações</font></b></p>
      <p align="center"><font face="Verdana" size="2">Modificações realizadas 
      com sucesso.<b><br><br>

      <div align="center">
        <center>
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="18%">
          <tr>
            <td width="50%">
            
<form method="POST" action="admin.cgi">
              <center>
              <input type="submit" value="Voltar" name="B1" style="border:1px solid #FFFFFF; font-family: Verdana; font-size: 8 pt; background-color: #c0c0c0 color:#0000FF"></center>
              <input type="hidden" name="acao" value="entrar">
              <input type="hidden" name="senha" value="$senhaadmin">
            </form>            </td>
          </tr>
          </table>
        </center>
      </div>
      </b></font>
     </td>
    </tr>
  </table>
  </center>
</div>
~;

}
print @baixo;