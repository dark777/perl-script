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
    <img border=\"0\" src=\"$urlsistema/adicionar.gif\" width=\"121\" height=\"29\"></a><a href=\"deletar_cad.cgi\"><img border=\"0\" src=\"$urlsistema/deletar_user.gif\" width=\"121\" height=\"29\"></a><a href=\"deletar_msg.cgi\"><img border=\"0\" src=\"$urlsistema/deletar_msg.gif\" width=\"121\" height=\"29\"></a><a href=\"design.cgi\"><img border=\"0\" src=\"$urlsistema/design.gif\" width=\"121\" height=\"29\"></a><a href=\"codigo_html.cgi\"><img border=\"0\" src=\"$urlsistema/codigo_html.gif\" width=\"121\" height=\"29\"></a><a href=\"logoff.cgi\"><img border=\"0\" src=\"$urlsistema/logout.gif\" width=\"121\" height=\"29\"></a><br>
    <img border=\"0\" src=\"$urlsistema/barra.gif\" width=\"644\" height=\"10\"></font></p>
    <p align=\"center\">
    <p align=\"center\"><font face=\"Verdana\" size=\"1\">Código Html<br>
    <br>
    <b>JAVA SCRIPT</b></font></p>
    <p align=\"center\">
    <div align=\"center\">
      <center><table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\" width=\"64%\" id=\"AutoNumber1\">
    <tr>
      <td width=\"50%\" align=\"center\"><font size=\"1\" face=\"Verdana\"><b>N</b>otícia Atual</font></td>
      <td width=\"50%\" align=\"center\"><textarea rows=\"5\" name=\"S1\" cols=\"44\"><script src=\"$urlcgis/news.cgi?atual\"></script></textarea></td>
    </tr>
    <tr>
      <td width=\"50%\" align=\"center\"><font face=\"Verdana\" size=\"1\">
      <b>T</b>odas as Notícias</font></td>
      <td width=\"50%\" align=\"center\"><textarea rows=\"5\" name=\"S1\" cols=\"44\"><script src=\"$urlcgis/news.cgi?codigo\"></script></textarea></td>
    </tr>
    <tr>
      <td width=\"50%\" align=\"center\"><font face=\"Verdana\" size=\"1\">Resumo das 
      News</font></td>
      <td width=\"50%\" align=\"center\"><textarea rows=\"5\" name=\"S1\" cols=\"44\"><script src=\"$urlcgis/news.cgi?resumo\"></script></textarea></td>
    </tr>
  </table>
      </center>
    </div>
</p>

</p>
<p align=\"center\">
    <p>
</p>

    <p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>IFRAME OU SSI</b></font></p>

    <div align=\"center\">
      <center>
      <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\" width=\"64%\" id=\"AutoNumber3\">
        <tr>
      <td width=\"50%\" align=\"center\"><font size=\"1\" face=\"Verdana\"><b>N</b>otícia Atual</font></td>
      <td width=\"50%\" align=\"center\"><textarea rows=\"5\" name=\"S1\" cols=\"44\"><center><!--webbot bot=\"HTMLMarkup\" startspan --><IFRAME SRC=\"$urlcgis/news.cgi?atual_ssi\" name=\"news\" width=\"450\" height=\"300\" frameborder=\"0\" border=\"0\" marginheight=\"0\" marginwidth=\"0\" scrolling=\"no\"></iframe><!--webbot bot=\"HTMLMarkup\" endspan --></center></textarea></td>
        </tr>
        <tr>
      <td width=\"50%\" align=\"center\"><font face=\"Verdana\" size=\"1\">
      <b>T</b>odas as Notícias</font></td>
      <td width=\"50%\" align=\"center\"><textarea rows=\"5\" name=\"S1\" cols=\"44\"><center><!--webbot bot=\"HTMLMarkup\" startspan --><IFRAME SRC=\"$urlcgis/news.cgi?todas\" name=\"news\" width=\"450\" height=\"300\" frameborder=\"0\" border=\"0\" marginheight=\"0\" marginwidth=\"0\" scrolling=\"no\"></iframe><!--webbot bot=\"HTMLMarkup\" endspan --></center></textarea></td>
        </tr>
        <tr>
      <td width=\"50%\" align=\"center\"><font face=\"Verdana\" size=\"1\">Resumo das 
      News</font></td>
      <td width=\"50%\" align=\"center\"><textarea rows=\"5\" name=\"S1\" cols=\"44\"><center><!--webbot bot=\"HTMLMarkup\" startspan --><IFRAME SRC=\"$urlcgis/news.cgi?resumo_ssi\" name=\"news\" width=\"450\" height=\"300\" frameborder=\"0\" border=\"0\" marginheight=\"0\" marginwidth=\"0\" scrolling=\"no\"></iframe><!--webbot bot=\"HTMLMarkup\" endspan --></center></textarea></td>
        </tr>
      </table>
      </center>
    </div>

    <p align=\"center\"><font face=\"Verdana\" size=\"1\">Para que o sistema funcione 
    corretamente, adicione um destes códigos em seu site.</font></p>

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