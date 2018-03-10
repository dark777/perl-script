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
   $value =~ s/<!--(.|\n)*-->//g;

   $FORM{$name} = $value;
} 

print "Content-type: text/html\n\n";

chmod(0755, "adicionar.cgi");
chmod(0755, "admin.cgi");
chmod(0755, "codigo_html.cgi");
chmod(0755, "configuracao.cgi");
chmod(0755, "deletar.cgi");
chmod(0755, "deletar_cad.cgi");
chmod(0755, "deletar_cad2.cgi");
chmod(0755, "deletar_msg.cgi");
chmod(0755, "entrar.cgi");
chmod(0755, "logoff.cgi");
chmod(0755, "news.cgi");
chmod(0755, "newsnan.cgi");
chmod(0755, "noticias.cgi");
chmod(0755, "postar.cgi");
chmod(0755, "postar2.cgi");
chmod(0755, "design.cgi");

chmod(0662, "usuarios.rse");
chmod(0662, "news.txt");
chmod(0662, "novidades.txt");
chmod(0662, "resumo.txt");

if (! (-f "usuarios")) 
{
mkdir ("usuarios");
}

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
    <p align=\"center\"><font face=\"Verdana\" size=\"2\"><b>I</b>nstalando</font></p>
    <div align=\"center\">
      <center>
      <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\" width=\"47%\" id=\"AutoNumber3\">
        <tr>
          <td width=\"23%\" bgcolor=\"#00478E\" align=\"center\">
          <p align=\"center\"><font color=\"#FFFFFF\" face=\"Verdana\" size=\"2\">Ação</font></td>
          <td width=\"55%\" bgcolor=\"#00478E\" align=\"center\">
          <font color=\"#FFFFFF\" face=\"Verdana\" size=\"2\">Arquivo</font></td>
          <td width=\"89%\" bgcolor=\"#00478E\" align=\"center\">
          <font color=\"#FFFFFF\" face=\"Verdana\" size=\"2\">Status</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"adicionar.cgi\">
          adicionar.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"admin.cgi\">
          admin.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\">
          <a href=\"codigo_html.cgi\">codigo_html.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\">
          <a href=\"configuracao.cgi\">configuracao.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"deletar.cgi\">
          deletar.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\">
          <a href=\"deletar_cad.cgi\">deletar_cad.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\">
          <a href=\"deletar_cad2.cgi\">deletar_cad2.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\">
          <a href=\"deletar_msg.cgi\">deletar_msg.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"entrar.cgi\">
          entrar.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"logoff.cgi\">
          logoff.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"design.cgi\">
          design.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"news.cgi\">
          news.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"newsnan.cgi\">
          newsnan.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"noticias.cgi\">
          noticias.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"postar.cgi\">
          postar.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"postar2.cgi\">
          postar2.cgi</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\">&nbsp;</td>
          <td width=\"55%\">&nbsp;</td>
          <td width=\"89%\">&nbsp;</td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"usuarios.rse\">
          usuarios.rse</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"news.txt\">
          news.txt</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"novidades.txt\">
          novidades.txt</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"resumo.txt\">
          resumo.txt</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\">&nbsp;</td>
          <td width=\"55%\">&nbsp;</td>
          <td width=\"89%\">&nbsp;</td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Criado</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"usuarios/\">
          usuarios</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
        <tr>
          <td width=\"23%\"><font face=\"Verdana\" size=\"2\">Chmod</font></td>
          <td width=\"55%\"><font face=\"Verdana\" size=\"2\"><a href=\"usuarios/\">
          usuarios</a></font></td>
          <td width=\"89%\"><font face=\"Verdana\" size=\"2\">OK</font></td>
        </tr>
      </table>
      </center>
    </div>
    <p align=\"center\"><font face=\"Verdana\" size=\"2\">Seu Sistema foi instalado 
    com sucesso!</font></p>
    <p align=\"center\"><font face=\"Verdana\" size=\"2\">Obrigado por utilizar o 
    nosso sistema!</font></p>
    <p align=\"center\"><font face=\"Verdana\" size=\"2\">
    <img border=\"0\" src=\"$urlsistema/barra.gif\" width=\"644\" height=\"10\"></font></p>
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
