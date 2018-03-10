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
if ($fields{$name}) { $fields{$name} = $fields{$name}.",".$value; }
else { $fields{$name} = $value; }
$FORM{$name} = $value;
}
foreach (split(/; /,$ENV{'HTTP_COOKIE'})) { 
$_ =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg; 
($nome,$valor) = split(/=/); 
$COOKIE{$nome} = $valor; 
}
require "configuracao.cgi";

if ($COOKIE{'admin'} eq $senhaadmin)

{

print "Content-type: text/html\n\n";
print "<html>

<head>
<meta http-equiv=\"Content-Language\" content=\"pt-br\">
<meta name=\"GENERATOR\" content=\"Microsoft FrontPage 5.0\">
<meta name=\"ProgId\" content=\"FrontPage.Editor.Document\">
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1252\">
<title>Scripts Nan</title>
</head>

<body topmargin=\"0\" bgcolor=\"#00478E\">

<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\" width=\"100%\" id=\"AutoNumber1\">
  <tr>
    <td width=\"100%\">
    <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\" width=\"100%\" id=\"AutoNumber2\" background=\"$urlsistema/logo_dir.gif\">
      <tr>
        <td width=\"100%\" height=\"30\">&nbsp;</td>
      </tr>
      <tr>
        <td width=\"100%\">
    <font face=\"Verdana\" size=\"2\">
    <a href=\"http://www.scripts.osimbr.net\">
    <img border=\"0\" src=\"$urlsistema/logo.gif\" width=\"239\" height=\"62\"></a></font></td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td width=\"100%\" bgcolor=\"#FFFFFF\">
 <p align=\"center\"><font face=\"Verdana\" size=\"2\">
    <a href=\"adicionar.cgi\">
    <img border=\"0\" src=\"$urlsistema/adicionar.gif\" width=\"121\" height=\"29\"></a><a href=\"deletar_cad.cgi\"><img border=\"0\" src=\"$urlsistema/deletar_user.gif\" width=\"121\" height=\"29\"></a><a href=\"deletar_msg.cgi\"><img border=\"0\" src=\"$urlsistema/deletar_msg.gif\" width=\"121\" height=\"29\"></a><a href=\"design.cgi\"><img border=\"0\" src=\"design.gif\" width=\"121\" height=\"29\"></a><a href=\"codigo_html.cgi\"><img border=\"0\" src=\"$urlsistema/codigo_html.gif\" width=\"121\" height=\"29\"></a><a href=\"logoff.cgi\"><img border=\"0\" src=\"$urlsistema/logout.gif\" width=\"121\" height=\"29\"></a><br>
    <img border=\"0\" src=\"$urlsistema/barra.gif\" width=\"644\" height=\"10\"></font></p>
    <p align=\"center\">
    <p align=\"center\"><font face=\"Verdana\" size=\"1\">Deletar Mensagem</font></p>
<p align=\"center\">
    <p></p>

    <p align=\"center\">
    <p>
</p>

</p>
<p align=\"center\">
    <p>
</p>

    <p align=\"center\"><font face=\"Verdana\" size=\"1\">";

open(admin, "<novidades.txt");
@admin = <admin>;
@admin = reverse(@admin);
close(admin);

if ($admin[0] eq "")
{ print "<center><b><font face=\"Verdana\" size=\"1\">Não Ha Mensagens.</b></center></font></p>
\n"; 
}
else 
{
foreach (@admin) 
{
chomp;

($nome,$email,$imagem,$data,$mensagem,$titulo,$tempo) = split(/``/, $_);

if ($imagem eq "")
{
$imagem.="$urlsistema/nenhuma.gif";
}
elsif ($imagem eq "http://")
{
$imagem.="www.omoska.com/scripts/newsnan/nenhuma.gif";
}


print "<div align=\"center\"><center><table border=\"0\" width=\"438\" cellspacing=\"0\" cellpadding=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\"><tr><td width=\"438\" height=\"28\" background=\"$urlsistema/cima.gif\"><p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>$titulo</b></font></td></tr><tr><td width=\"100%\" background=\"$urlsistema/centro.gif\"><div align=\"center\"><table border=\"0\" width=\"93%\" cellspacing=\"0\" cellpadding=\"0\"><tr><td width=\"3%\" align=\"center\"><font face=\"Verdana\" size=\"1\"><img src=\"$imagem\"></font></td><td width=\"97%\" align=\"center\"><font face=\"Verdana\" size=\"1\" color=\"#FFFFFF\">$mensagem<br><br><font face=\"Verdana\" size=\"1\">Postado por: <b>$nome</b> em <b>$data</b></font></td></tr></table></div></td></tr><tr><td width=\"438\" height=\"19\" background=\"$urlsistema/baixo.gif\"><p align=\"center\"><font face=\"Verdana\" size=\"1\" color=\"#FFFFFF\">News Nan by Renan Elias</font></td></tr><tr>
  <td width=\"438\" height=\"19\"><form method=\"POST\" action=\"deletar.cgi\">
<input type=\"hidden\" name=\"nome\" value=\"$nome\">
<input type=\"hidden\" name=\"email\" value=$email>
<input type=\"hidden\" name=\"imagem\" value=$imagem>
<input type=\"hidden\" name=\"data\" value=$data>
<input type=\"hidden\" name=\"mensagem\" value=\'$mensagem\'>
<input type=\"hidden\" name=\"titulo\" value=\'$titulo\'>
<input type=\"hidden\" name=\"codigo\" value=\'$tempo\'>
          <p align=\"center\"><input type=\"submit\" value=\"Deletar\" name=\"B1\">
        </form></td></tr></table></center></div><br>
";

}
}
print "</font></p>

    <p align=\"center\"><font face=\"Verdana\" size=\"2\">
    <img border=\"0\" src=\"$urlsistema/barra.gif\" width=\"644\" height=\"10\"><br>
    <a href=\"infos.cgi\"><img border=\"0\" src=\"$urlsistema/novas.gif\" width=\"121\" height=\"29\"></a><a href=\"http://www.scripts.osimbr.net\"><img border=\"0\" src=\"$urlsistema/scriptsnan.gif\" width=\"121\" height=\"29\"></a></font></p>
    <p align=\"center\">&nbsp;</p>
    </td>
  </tr>
  <tr>
    <td width=\"100%\" bgcolor=\"#3399FF\">
    <p align=\"center\"><font face=\"Verdana\" size=\"2\">
    <a href=\"http://www.scripts.osimbr.net\">www.scripts.osimbr.net</a></font></td>
  </tr>
</table>

</body>

</html>";

}

else
{
print "Content-type: text/html\n\n";
print "<html>

<head>
<meta http-equiv=\"Content-Language\" content=\"pt-br\">
<meta name=\"GENERATOR\" content=\"Microsoft FrontPage 5.0\">
<meta name=\"ProgId\" content=\"FrontPage.Editor.Document\">
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1252\">
<title>Scripts Nan</title>
</head>

<body topmargin=\"0\" bgcolor=\"#00478E\">

<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\" width=\"100%\" id=\"AutoNumber1\">
  <tr>
    <td width=\"100%\">
    <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\" width=\"100%\" id=\"AutoNumber2\" background=\"$urlsistema/logo_dir.gif\">
      <tr>
        <td width=\"100%\" height=\"30\">&nbsp;</td>
      </tr>
      <tr>
        <td width=\"100%\">
    <font face=\"Verdana\" size=\"2\">
    <a href=\"http://www.scripts.osimbr.net\">
    <img border=\"0\" src=\"$urlsistema/logo.gif\" width=\"239\" height=\"62\"></a></font></td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td width=\"100%\" bgcolor=\"#FFFFFF\">
    <p align=\"center\"><font face=\"Verdana\" size=\"2\">
    <img border=\"0\" src=\"$urlsistema/barra.gif\" width=\"644\" height=\"10\"></font></p>
<p align=\"center\">&nbsp;</p>
<p align=\"center\">&nbsp;</p>
    <p align=\"center\">&nbsp;</p>
    <p align=\"center\"><font face=\"Verdana\" size=\"1\">Você deve logar no admin 
    antes de Entrar nas partes administrativas do sistema</font></p>
    <p align=\"center\">&nbsp;</p>
<p align=\"center\">&nbsp;</p>
<p align=\"center\">&nbsp;</p>
    <p align=\"center\"><font face=\"Verdana\" size=\"2\">
    <img border=\"0\" src=\"$urlsistema/barra.gif\" width=\"644\" height=\"10\"><br>
    <a href=\"http://www.scripts.osimbr.net\">
    <img border=\"0\" src=\"$urlsistema/scriptsnan.gif\" width=\"121\" height=\"29\"></a></font></p>
    </td>
  </tr>
  <tr>
    <td width=\"100%\" bgcolor=\"#3399FF\">
    <p align=\"center\"><font face=\"Verdana\" size=\"2\">
    <a href=\"http://www.scripts.osimbr.net\">www.scripts.osimbr.net</a></font></td>
  </tr>
</table>

</body>

</html>";
}