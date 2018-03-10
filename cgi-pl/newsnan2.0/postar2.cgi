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
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
@pairs = split(/&/, $buffer);
foreach $pair (@pairs) {
   ($name, $value) = split(/=/, $pair);

   $value =~ tr/+/ /;
   $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
   $value =~ s/<!--(.|\n)*-->//g;

   $FORM{$name} = $value;
} 

foreach (split(/; /,$ENV{'HTTP_COOKIE'})) { 
$_ =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg; 
($nome,$valor) = split(/=/); 
$COOKIE{$nome} = $valor; 
}

&usuario unless $COOKIE{'senha'};
&usuario unless $COOKIE{'usuario'};

$arquivo="usuarios.rse";

open (USUARIOS, "$arquivo") || &open_error($arquivo);
@usuario = <USUARIOS>;
close (USUARIOS);
foreach $line (@usuario)

{

    ($nome, $senha) = split(/ /,$line);
    $logando{$nome}=$senha;
    
}


if (!$logando{$COOKIE{'usuario'}})
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
    <p align=\"center\">
    <p align=\"center\"><br>
&nbsp;</p>
    <p align=\"center\"><b><font face=\"Verdana\" size=\"1\">Erro ao tentar Logar</font></b></p>

    <p align=\"center\"><font face=\"Verdana\" size=\"1\">Erro! Este Usuário não foi 
    encontrado em nosso sistema.</font></p>

    <p align=\"center\">&nbsp;</p>

    <p align=\"center\">&nbsp;</p>

    <p align=\"center\"><font face=\"Verdana\" size=\"2\">
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
}
elsif (crypt($COOKIE{'senha'},"MM") ne $logando{$COOKIE{'usuario'}} ) {
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
    <p align=\"center\"><br>
&nbsp;</p>
    <p align=\"center\"><b><font face=\"Verdana\" size=\"1\">Erro ao tentar Logar</font></b></p>

    <p align=\"center\"><font face=\"Verdana\" size=\"1\">Erro! Senha Incorreta.</font></p>

    <p align=\"center\">&nbsp;</p>

    <p align=\"center\">&nbsp;</p>

    <p align=\"center\"><font face=\"Verdana\" size=\"2\">
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
}

else
{
&ok;
}

sub usuario {

   print "Content-type: text/html\n\n";

print <<EOT;

<html>

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
    <p align=\"center\"><p align=\"center\"><font face=\"Verdana\" size=\"1\">Digite seu usuário e senha:</font></p>
<form method=\"POST\" action=\"entrar.cgi\">
  <p align=\"center\"><font size=\"1\" face=\"Verdana\">Usuário:
  <input type=\"text\" name=\"usuario\" size=\"20\"><br>
  Senha: <input type=\"password\" name=\"senha\" size=\"20\"><br>
  <input type=\"submit\" value=\"Entrar\" name=\"B1\"></font></p>
</form>
</p>

    <p></p>

    <p align=\"center\">&nbsp;</p>

    <p align=\"center\">&nbsp;</p>

    <p align=\"center\"><font face=\"Verdana\" size=\"2\">
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

</html>

EOT

exit;

}


exit;

sub ok {

print "Set-Cookie: usuario=; path=/; expires=1d GMT;\n";
print "Set-Cookie: senha=; path=/; expires=1d GMT;\n";
print "Content-type:text/html\n\n";

$arquivo="novidades.txt";
$arquivo2="news.txt";
$nome="$FORM{'nome'}";
$email="$FORM{'email'}";
$imagem="$FORM{'imagem'}";
$mensagem="$FORM{'mensagem'}";
$titulo="$FORM{'titulo'}";
$tempo=time();

if ($imagem eq "")
{
$imagem.="$urlsistema/nenhuma.gif";
}
elsif ($imagem eq "http://")
{
$imagem.="$urlsemwww/nenhuma.gif";
}


($min,$hour,$mday,$mon,$year,$wday) = (localtime(time))[1,2,3,4,5,6];

$year+=1900;
$mon+=1;
$mon = "0$mon" if $mon < 10;
$mday = "0$mday" if $mday < 10;
$min = "0$min" if $min < 10;
$hour = "0$hour" if $hour < 10;


if (! (-f "$arquivo")) 
{
open (CREATE, ">$arquivo");
close CREATE;
chmod(0666, "$arquivo");
}

open (NOVIDADES, ">>$arquivo");
print NOVIDADES "$nome``$email``$imagem``$mday/$mon/$year``$mensagem``$titulo``$tempo\n";
close (NOVIDADES);

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
    <p align=\"center\"><p align=\"center\"><font face=\"Verdana\" size=\"1\">A Seguinte Mensagem foi postada 
por $nome:</font></p>
<div align=\"center\">
  <center>
  <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\" width=\"49%\" id=\"AutoNumber1\">
    <tr>
      <td width=\"32%\"><font face=\"Verdana\" size=\"1\"><b>R</b>esumo:</font></td>
      <td width=\"68%\"><font face=\"Verdana\" size=\"1\">$titulo</font></td>
    </tr>
    <tr>
      <td width=\"32%\"><font face=\"Verdana\" size=\"1\"><b>U</b>suário:</font></td>
      <td width=\"68%\"><font face=\"Verdana\" size=\"1\">$nome</font></td>
    </tr>
    <tr>
      <td width=\"32%\"><font face=\"Verdana\" size=\"1\"><b>E</b>-mail:</font></td>
      <td width=\"68%\"><font face=\"Verdana\" size=\"1\">$email</font></td>
    </tr>
    <tr>
      <td width=\"32%\"><font face=\"Verdana\" size=\"1\"><b>D</b>ata:</font></td>
      <td width=\"68%\"><font SIZE=\"1\" face=\"Verdana\">$mday/$mon/$year</font></td>
    </tr>
    <tr>
      <td width=\"32%\"><font face=\"Verdana\" size=\"1\"><b>A</b>vatar:</font></td>
      <td width=\"68%\"><font face=\"Verdana\" size=\"1\"><img src=\"$imagem\" border=\"0\"></font></td>
    </tr>
    <tr>
      <td width=\"32%\"><font face=\"Verdana\" size=\"1\"><b>M</b>ensagem:</font></td>
      <td width=\"68%\"><font face=\"Verdana\" size=\"1\">$mensagem</font></td>
    </tr>
  </table>
  </center>
</div>
    <p align=\"center\"><font face=\"Verdana\" size=\"1\"><a href=\"newsnan.cgi\">Voltar</a></font><br>
    &nbsp;</p>
    <p align=\"center\">
    <font face=\"Verdana\" size=\"2\">
    <br>
    <img border=\"0\" src=\"$urlsistema/barra.gif\" width=\"644\" height=\"10\"><br>
    <a href=\"http://www.scripts.osimbr.net\"><img border=\"0\" src=\"$urlsistema/scriptsnan.gif\" width=\"121\" height=\"29\"></a></font></p>
    </p>
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

</html>\n";

}