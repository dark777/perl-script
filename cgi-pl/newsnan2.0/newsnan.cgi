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

require "configuracao.cgi";

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
    <p align=\"center\">
    <p align=\"center\"><br><font face=\"Verdana\" size=\"1\">
    Seja Bem Vindo ao sistema de Notícias NewsNan</font></p>
<p align=\"center\"><font face=\"Verdana\" size=\"1\">Selecione uma opção abaixo:</font></p>
<p align=\"center\"><div align=\"center\">
  <center>
  <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\" width=\"0%\" id=\"AutoNumber1\">
    <tr>
      <td width=\"33%\">
      <p align=\"center\"><a href=\"entrar.cgi\">
      <img border=\"0\" src=\"$urlsistema/postar.gif\" width=\"121\" height=\"29\"></a></td>
      <td width=\"33%\">&nbsp;</td>
      <td width=\"34%\"><a href=\"admin.cgi\">
      <img border=\"0\" src=\"$urlsistema/admin_inicial.gif\" width=\"121\" height=\"29\"></a></td>
    </tr>
    <tr>
      <td width=\"33%\">&nbsp;</td>
      <td width=\"33%\">
      <p align=\"center\"><a href=\"news.cgi?todas\">
      <img border=\"0\" src=\"$urlsistema/ver.gif\" width=\"121\" height=\"29\"></a></td>
      <td width=\"34%\">&nbsp;</td>
    </tr>
  </table>
  </center>
</div></p>

    <p align=\"center\"><font face=\"Verdana\" size=\"2\">
    <br>
    <img border=\"0\" src=\"$urlsistema/barra.gif\" width=\"644\" height=\"10\"><br>
    <a href=\"http://www.scripts.osimbr.net\"><img border=\"0\" src=\"$urlsistema/scriptsnan.gif\" width=\"121\" height=\"29\"></a></font></p>
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