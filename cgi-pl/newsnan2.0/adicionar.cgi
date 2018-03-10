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


if ($ENV{'REQUEST_METHOD'} eq "POST"){
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
@pairs = split(/&/, $buffer);

foreach $pair (@pairs) {
   ($name, $value) = split(/=/, $pair);


   $value =~ tr/+/ /;
   $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
   $value =~ s/<!--(.|\n)*-->//g;

   $FORM{$name} = $value;
} 

$senha = "$FORM{'senha'}";
$senha2 = crypt($senha, "MM");
$arquivo="usuarios.rse";
$arquivo2="usuarios/$FORM{'usuario'}.txt";
require "configuracao.cgi";


open USUARIOS, "$arquivo";
while (<USUARIOS>)
{
 if (/$FORM{'usuario'}/o)
 {
   &erro_existente;

   close USUARIOS;

   exit 0;
 }
}
close USUARIOS;

foreach (split(/; /,$ENV{'HTTP_COOKIE'})) { 
$_ =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg; 
($nome,$valor) = split(/=/); 
$COOKIE{$nome} = $valor; 
}


if ($COOKIE{'admin'} eq $senhaadmin)
{


open (CADASTRO, ">>$arquivo");
print CADASTRO "$FORM{'usuario'} ";
print CADASTRO "$senha2 \n";
close (CADASTRO);


open (CREATE, ">usuarios/$FORM{'usuario'}.txt");
close CREATE;
chmod(0666, "usuarios/$FORM{'usuario'}.txt");

open (USUARIO2, ">>$arquivo2") || &open_error($arquivo2);
print USUARIO2 "$FORM{'email'}``$FORM{'nome'}``$FORM{'avatar'}";
close (USUARIO2);

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
<p align=\"center\">&nbsp;</p>
<p align=\"center\"><font face=\"Verdana\" size=\"1\">Você cadastrou o usuário em seu 
sistema de News.</font></p>
<p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>U</b>suário: $FORM{'usuario'}<br>
<b>S</b>enha: $FORM{'senha'}</font></p>
<p align=\"center\"><font face=\"Verdana\" size=\"1\"><a href=\"adicionar.cgi\">Voltar</a> 
e adicionar outro usuário.</font></p>
<p align=\"center\">&nbsp;</p>
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
print "Content-type:text/html\n\n";
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

}else{

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
    <p align=\"center\"><font face=\"Verdana\" size=\"1\">Adicionar Usuário</font></p>
<p align=\"center\"><form method=\"POST\" action=\"adicionar.cgi\">
  <div align=\"center\">
    <center>
    <table border=\"0\" width=\"31%\" cellspacing=\"0\" cellpadding=\"0\">
      <tr>
        <td width=\"50%\"><font face=\"Verdana\" size=\"1\"><b>U</b>suário:</font></td>
        <td width=\"50%\"><input type=\"text\" name=\"usuario\" size=\"20\"></td>
      </tr>
      <tr>
        <td width=\"50%\"><font face=\"Verdana\" size=\"1\"><b>S</b>enha:</font></td>
        <td width=\"50%\"><input type=\"password\" name=\"senha\" size=\"20\"></td>
      </tr>
      <tr>
        <td width=\"50%\"><font face=\"Verdana\" size=\"1\"><b>E</b>-mail</font></td>
        <td width=\"50%\"><input type=\"text\" name=\"email\" size=\"20\"></td>
      </tr>
      <tr>
        <td width=\"50%\"><font face=\"Verdana\" size=\"1\"><b>S</b>eu Nome</font></td>
        <td width=\"50%\"><input type=\"text\" name=\"nome\" size=\"20\"></td>
      </tr>
      <tr>
        <td width=\"50%\"><font face=\"Verdana\" size=\"1\"><b>A</b>vatar</font></td>
        <td width=\"50%\"><input type=\"text\" name=\"avatar\" size=\"20\" value=\"http://\"></td>
      </tr>
    </table>
    </center>
  </div>
  <p align=\"center\"><input type=\"submit\" value=\"Cadastrar\" name=\"B1\"><input type=\"reset\" value=\"Redefinir\" name=\"B2\"></p>
</form>
</p>

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
print "Content-type:text/html\n\n";
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
}


exit;

sub erro_existente  {

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
    <p align=\"center\"><font face=\"Verdana\" size=\"1\">Adicionar Usuário</font></p>
    <p align=\"center\"><font face=\"Verdana\" size=\"1\">« Erro »</font></p>
    <p align=\"center\"><font face=\"Verdana\" size=\"1\"><br>
    Este Usuário que você está tentando cadastrar, já existe!</font></p>
    <p align=\"center\"><font face=\"Verdana\" size=\"1\">Volte e tente novamente 
    mudando o nome de Usuário.</font></p>
    <p align=\"center\"><font face=\"Verdana\" size=\"1\"><a href=\"adicionar.cgi\">
    Voltar</a></font><br>
&nbsp;</p>
<p align=\"center\">
    <p>
</p>

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

