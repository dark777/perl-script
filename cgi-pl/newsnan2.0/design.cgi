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
&mostra;
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

sub mostra 
{

$acao="$ENV{QUERY_STRING}";

if ($acao eq '')
{
&form;
}
if ($acao eq 'ver')
{
&ver;
}
if ($acao eq 'modificar')
{
&modificar;
}
}

sub form 
{
print "Content-type: text/html\n\n";
print "<html>

<head>
<meta http-equiv=\"Content-Language\" content=\"pt-br\">
<meta name=\"GENERATOR\" content=\"Microsoft FrontPage 4.0\">
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
    <p align=\"center\"><font face=\"Verdana\" size=\"1\">Modificar Design das
    Notícias</font></p>
    <p align=\"center\"><font face=\"Verdana\" size=\"1\">Coloque abaixo o design que
    você deseja.</font></p>
    <form method=\"POST\" action=\"design.cgi?ver\">
      <div align=\"center\">
        <center>
        <table border=\"0\" width=\"84%\" cellspacing=\"3\" cellpadding=\"0\" height=\"134\">
          <tr>
            <td width=\"60%\" height=\"130\">
              <p align=\"center\"><font face=\"Verdana\" size=\"1\">Cole</font><font face=\"Verdana\" size=\"1\">
              o código do novo design abaixo:</font><br>
              <textarea rows=\"6\" name=\"design\" cols=\"42\"></textarea></td>
            <td width=\"40%\" height=\"130\">
              <p align=\"center\"><font face=\"Verdana\" size=\"1\">Você deve usar no
              design as variáveis:</font></p>
              <p align=\"center\"><textarea rows=\"5\" name=\"usar\" cols=\"23\">\$titulo
\$mensagem
\$nome
\$data
<img src=\"\$imagem\">
\$copyright</textarea></td>
          </tr>
        </table>
        </center>
      </div>
      <p align=\"center\"><input type=\"submit\" value=\"Modificar Design\" name=\"B1\"></p>
    </form>

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

sub ver 
{

$line_breaks = split('~',$FORM{'design'});

if ($line_breaks == 1)
{
$FORM{'design'} =~ s/\cM\n/<!-- br -->/g;
}

$FORM{'design'} =~ s/"/\\"/ig;
$FORM{'design'} =~ s/@/\\@/ig;

$html=$FORM{'design'};

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
    <a href=\"adicionar.cgi\">
    <img border=\"0\" src=\"$urlsistema/adicionar.gif\" width=\"121\" height=\"29\"></a><a href=\"deletar_cad.cgi\"><img border=\"0\" src=\"$urlsistema/deletar_user.gif\" width=\"121\" height=\"29\"></a><a href=\"deletar_msg.cgi\"><img border=\"0\" src=\"$urlsistema/deletar_msg.gif\" width=\"121\" height=\"29\"></a><a href=\"design.cgi\"><img border=\"0\" src=\"$urlsistema/design.gif\" width=\"121\" height=\"29\"></a><a href=\"codigo_html.cgi\"><img border=\"0\" src=\"$urlsistema/codigo_html.gif\" width=\"121\" height=\"29\"></a><a href=\"logoff.cgi\"><img border=\"0\" src=\"$urlsistema/logout.gif\" width=\"121\" height=\"29\"></a><br>
    <img border=\"0\" src=\"$urlsistema/barra.gif\" width=\"644\" height=\"10\"></font></p>
    <p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>M</b>odificar Design das
    Notícias</font></p>
    <form method=\"POST\" action=\"design.cgi?modificar\">
      <div align=\"center\">
        <center>
        <table border=\"0\" width=\"84%\" cellspacing=\"3\" cellpadding=\"0\" height=\"134\">
          <tr>
            <td width=\"60%\" height=\"130\">
              <p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>V</b>ocê está 
              prestes a alterar o design de seu sistema.</font></p>
              <p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>S</b>ugerimos 
              que você guarde o código original do sistema, que se localiza logo 
              abaixo.<br>
              <b>S</b>e as alterações forem mal sucedidas você pode usar o 
              código abaixo para voltar ao design padrão do sistema.</font></p>
              <p align=\"center\">
              <textarea rows=\"8\" name=\"padrao_codigo\" cols=\"38\" style=\"border: 3px double #C0C0C0\"><div align=\"center\"><center><table border=\"0\" width=\"438\" cellspacing=\"0\" cellpadding=\"0\" style=\"border-collapse: collapse\" bordercolor=\"#111111\"><tr><td width=\"438\" height=\"28\" background=\"\$urlsistema/cima.gif\"><p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>\$titulo</b></font></td></tr><tr><td width=\"100%\" background=\"\$urlsistema/centro.gif\"><div align=\"center\"><table border=\"0\" width=\"93%\" cellspacing=\"0\" cellpadding=\"0\"><tr><td width=\"3%\" align=\"center\"><font face=\"Verdana\" size=\"1\"><img src=\"\$imagem\"></font></td><td width=\"97%\" align=\"center\"><font face=\"Verdana\" size=\"1\" color=\"#FFFFFF\">\$mensagem<br><br><font face=\"Verdana\" size=\"1\">Postado por: <b>\$nome</b> em <b>\$data</b></font></td></tr></table></div></td></tr><tr><td width=\"438\" height=\"19\" background=\"\$urlsistema/baixo.gif\"><p align=\"center\"><font face=\"Verdana\" size=\"1\" color=\"#FFFFFF\">\$copyright</font></td></tr></table><br></textarea></p>
              <p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>C</b>lique em 
              Modificar Design para continuar.</font></td>
          </tr>
        </table>
        </center>
      </div>
      <p align=\"center\">
      <input type=\"hidden\" name=\"design\" value='$html'>
      <input type=\"submit\" value=\"Modificar Design\" name=\"B1\"></p>
    </form>

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

sub modificar 
{
print "content-type:text/html\n\n";
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
    <p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>M</b>odificar Design das
    Notícias</font></p>
    <form method=\"POST\" action=\"design.cgi?modificar\">
      <input type=\"hidden\" name=\"design\" value='$html'>
      <div align=\"center\">
        <center>
        <table border=\"0\" width=\"84%\" cellspacing=\"3\" cellpadding=\"0\" height=\"134\">
          <tr>
            <td width=\"60%\" height=\"130\">
              <p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>V</b>ocê 
              alterou seu design com sucesso!</font></p>
              <p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>A</b>baixo a notícia atual  com o design alterado:</font></p>
              <p align=\"center\"><center><!--webbot bot=\"HTMLMarkup\" startspan --><IFRAME SRC=\"$urlsistema/news.cgi?atual_ssi\" name=\"news\" width=\"450\" height=\"150\" frameborder=\"0\" border=\"0\" marginheight=\"0\" marginwidth=\"0\" scrolling=\"no\"></iframe><!--webbot bot=\"HTMLMarkup\" endspan --></center></td>
          </tr>
        </table>
        </center>
      </div>
      <p align=\"center\">
      &nbsp;</p>
    </form>

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


system "rm -r news.cgi";

open (CREATE, ">news.cgi");
print CREATE "\#\!/usr/bin/perl\n";
print CREATE "######################################################################
#                      News Nan By Renan Elias                       #
#                                                                    #
# Configuração: Somente configure o configuracao.cgi para que o CGI  #
#                       funcione corretamente                        #
#                                                                    #
#                                                                    #
#                                                                    #
# Criador: Renan Silveira Elias                                      #
# E-mail: renan\@osimbr.net                                          #
# ICQ: 89603614                                                      #
#                                                                    #
#    Você precisa de um CGI para seu site? Entre em contato! Crio    #
#       seu script do modo que quiser por um preço muito bom.        #
######################################################################
\n\n\n";
print CREATE "\$content = \$ENV\{'QUERY_STRING'\}\;

read\(STDIN, \$buffer, \$ENV\{'CONTENT_LENGTH'\}\)\;

\@pairs = split\(/\&/, \$buffer\)\;

foreach \$pair \(\@pairs\) \{
   \(\$name, \$value\) = split\(/=/, \$pair\)\;

   \$value =~ tr/+/ /\;
   \$value =~ s/%\([a-fA-F0-9][a-fA-F0-9]\)/pack\(\"C\", hex\(\$1\)\)/eg\;
   \$value =~ s/<!--\(.|\\n\)*-->//g\;

   \$FORM\{\$name\} = \$value\;
\}\n\nprint \"Content-type: text/html\\n\\n\"\;

require \"configuracao.cgi\"\;

\$copyright=\"News Nan v\$versao, by Renan Elias\"\;

if \(\$content\) \{

if \(defined\(\&\$content\)\) \{\n\n&\$content\;

\} else \{
&nao_encontrei\;
\}

\} else \{
&nao_permitido_acesso\;
\}\n\n\nsub todas \{

\$arquivo2=\"novidades.txt\"\;

open\(DATA, \"<\$arquivo2\"\)\;
\@datao = <DATA>\;
\@datao = reverse\(\@datao\)\;
close\(DATA\)\;\n\nif \(\@datao[0] eq \"\"\) 
\{ 
print \"<center><font face='Verdana' size='1'><b>Não ha nenhuma mensagem.</b></center></font>\"\;

\}\n\nelse \{

foreach \(\@datao\) \{
chomp\;

\(\$nome,\$email,\$imagem,\$data,\$mensagem,\$titulo,\$tempo\) = split\(/``/, \$_\)\;


if \(\$imagem eq \"\"\)
\{
\$imagem.=\"\$urlsistema/nenhuma.gif\"\;
\}
elsif \(\$imagem eq \"http://\"\)
\{
\$imagem.=\"\$urlsemwww/nenhuma.gif\"\;
\}

print \"";
print CREATE "$FORM{'design'}";
print CREATE "\"\;

\}
\}
exit\;

\}


sub atual \{

\$arquivo=\"novidades.txt\"\;

open(DATA, \"<\$arquivo\")\;
\@datao = <DATA>\;
\@datao = reverse(\@datao)\;
close(DATA)\;

if (\$datao[0] eq \"\") \{ print qq~document.write\('<center><font face=Verdana size=1><b>Não ha nenhuma mensagem.</b></center></font>'\)\\;~\;\}
else \{


\$n=0\;
foreach (\@datao)\{
 if(\$n<1)\{

chomp\;
(\$nome,\$email,\$imagem,\$data,\$mensagem,\$titulo,\$tempo) = split(/``/, \$_)\;

if (\$imagem eq \"\")
\{
\$imagem.=\"\$urlsistema/nenhuma.gif\"\;
\}
elsif (\$imagem eq \"http://\")
\{
\$imagem.=\"\$urlsemwww/nenhuma.gif\"\;
\}

print qq~document.write\('";
print CREATE "$FORM{'design'}";
print CREATE "'\\)\\;~\;
 \$n++\;
\}
\}
\}
exit\;

\}

sub codigo \{
\$arquivo=\"novidades.txt\"\;

open\(DATA, \"<\$arquivo\"\)\;
\@datao = <DATA>\;
\@datao = reverse\(\@datao\)\;
close\(DATA\)\;

if \(\$datao[0] eq \"\"\) \{ print qq~document.write\\('<center><font face=Verdana size=1><b>Não ha nenhuma mensagem.</b></center></font>'\\)\\;~\;\}
else \{

foreach \(\@datao\) \{
chomp\;
\(\$nome,\$email,\$imagem,\$data,\$mensagem,\$titulo,\$tempo\) = split\(/``/, \$_\)\;

if \(\$imagem eq \"\"\)
\{
\$imagem.=\"\$urlsistema/nenhuma.gif\"\;
\}
elsif \(\$imagem eq \"http://\"\)
\{
\$imagem.=\"\$urlsemwww/nenhuma.gif\"\;
\}

print qq~document.write\\('";
print CREATE "$FORM{'design'}";
print CREATE "'\\)\\;~\;
\}
\}
exit\;

\}

sub resumo \{

\$arquivo=\"novidades.txt\"\;

open\(DATA, \"<\$arquivo\"\)\;
\@datao = <DATA>\;
\@datao = reverse\(\@datao\)\;
close\(DATA\)\;

if \(\$datao[0] eq \"\"\) \{ print qq~document.write\\('<center><font face=Verdana size=1><b>Não ha nenhuma mensagem.</b></center></font>'\\)\\;~\;\}
else \{

\$n=0\;
foreach \(\@datao\)\{
 if\(\$n<5\)\{

chomp\;

\(\$nome,\$email,\$imagem,\$data,\$mensagem,\$titulo,\$tempo\) = split\(/``/, \$_\)\;

if \(\$imagem eq \"\"\)
\{
\$imagem.=\"\$urlsistema/nenhuma.gif\"\;
\}
elsif \(\$imagem eq \"http://\"\)
\{
\$imagem.=\"\$urlsemwww/nenhuma.gif\"\;
\}



print qq~document.write\\('<left><img border=0 src=\$urlsistema/marcador.jpg align=absmiddle width=10 height=10><font face=Verdana size=1>\$data - <a href=\$urlcgis/noticias.cgi?\$tempo>\$titulo</a></font><br>'\\)\\;~\;
 \$n++\;
\}
\}
\}
exit\;

\}


sub resumo_ssi \{

print \"<div align='center'><center><table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='57%' id='AutoNumber1'>
\"\;
\$arquivo=\"novidades.txt\"\;

open\(DATA, \"<\$arquivo\"\)\;
\@datao = <DATA>\;
\@datao = reverse\(\@datao\)\;
close\(DATA\)\;

if \(\$datao[0] eq \"\"\) \{ print \"<center><font face='Verdana' size='1'><b>Não ha nenhuma mensagem.</b></center></font>\"\;\}
else \{

\$n=0\;
foreach \(\@datao\)\{
 if\(\$n<5\)\{

chomp\;

\(\$nome,\$email,\$imagem,\$data,\$mensagem,\$titulo,\$tempo\) = split\(/``/, \$_\)\;

if \(\$imagem eq \"\"\)
\{
\$imagem.=\"\$urlsistema/nenhuma.gif\"\;
\}
elsif \(\$imagem eq \"http://\"\)
\{
\$imagem.=\"\$urlsemwww/nenhuma.gif\"\;
\}



print \"<tr><td width='100%'><p align='left'><img border='0' src='\$urlsistema/marcador.jpg' align='absmiddle' width='10' height='10'><font face='Verdana' size='1'>\$data - <a href='\$urlcgis/noticias.cgi?\$tempo'>\$titulo</a></font></td></tr>\"\;
 \$n++\;
\}
\}
\}
exit\;
print \"</table></center></div>\"\;

\}

sub atual_ssi \{

\$arquivo=\"novidades.txt\"\;

open\(DATA, \"<\$arquivo\"\)\;
\@datao = <DATA>\;
\@datao = reverse\(\@datao\)\;
close\(DATA\)\;

if \(\$datao[0] eq \"\"\) \{ print \"<center><font face='Verdana' size='1'><b>Não ha nenhuma mensagem.</b></center></font>\"\;\}
else \{


\$n=0\;
foreach \(\@datao\)\{
 if\(\$n<1\)\{

chomp\;
\(\$nome,\$email,\$imagem,\$data,\$mensagem,\$titulo,\$tempo\) = split\(/``/, \$_\)\;

if \(\$imagem eq \"\"\)
\{
\$imagem.=\"\$urlsistema/nenhuma.gif\"\;
\}
elsif \(\$imagem eq \"http://\"\)
\{
\$imagem.=\"\$urlsemwww/nenhuma.gif\"\;
\}

print \"";
print CREATE "$FORM{'design'}";
print CREATE "\"\;
 \$n++\;
\}
\}
\}
exit\;

\}


sub nao_encontrei \{
print <<EOF\;
Erro! Você deve ter executado o CGI Incorretamente
EOF
\}

sub nao_permitido_acesso \{
print <<EOF\;
Erro! Você deve ter executado o CGI Incorretamente
EOF
\}";

close CREATE;
chmod(0755, "news.cgi");

system "rm -r noticias.cgi";

open (CREATE, ">noticias.cgi");
print CREATE "\#\!/usr/bin/perl\n";
print CREATE "######################################################################
#                      News Nan By Renan Elias                       #
#                                                                    #
# Configuração: Somente configure o configuracao.cgi para que o CGI  #
#                       funcione corretamente                        #
#                                                                    #
#                                                                    #
#                                                                    #
# Criador: Renan Silveira Elias                                      #
# E-mail: renan\@osimbr.net                                           #
# ICQ: 89603614                                                      #
#                                                                    #
#    Você precisa de um CGI para seu site? Entre em contato! Crio    #
#       seu script do modo que quiser por um preço muito bom.        #
######################################################################



read\(STDIN, \$buffer, \$ENV\{'CONTENT_LENGTH'\}\)\;

\@pairs = split\(/&/, \$buffer\)\;

foreach \$pair \(\@pairs\) \{
   \(\$name, \$value\) = split\(/=/, \$pair\)\;

   \$value =~ tr/+/ /\;
   \$value =~ s/%\([a-fA-F0-9][a-fA-F0-9]\)/pack\(\"C\", hex\(\$1\)\)/eg\;
   \$value =~ s/<!--\(.|\\n\)*-->//g\;

   \$FORM\{\$name\} = \$value\;
\} 

print \"Content-type: text/html\\n\\n\"\;

\$noticia=\"\$ENV\{'QUERY_STRING'\}\"\;

\$arquivo2=\"novidades.txt\"\;

open\(DATA, \"<\$arquivo2\"\)\;
\@datao = <DATA>\;
\@datao = reverse\(\@datao\)\;
close\(DATA\)\;
require \"configuracao.cgi\"\;

if \(\@datao[0] eq \"\"\) 
\{ 
print \"<center><font face=Verdana size=1><b>Não ha nenhuma mensagem.</b></center></font>\"\;

\}
else \{

foreach \(\@datao\) \{
chomp\;

\(\$nome,\$email,\$imagem,\$data,\$mensagem,\$titulo,\$tempo\) = split\(/``/, \$_\)\;


if \(\$imagem eq \"\"\)
\{
\$imagem.=\"\$urlsistema/nenhuma.gif\"\;
\}
elsif \(\$imagem eq \"http://\"\)
\{
\$imagem.=\"\$urlsemwww/nenhuma.gif\"\;
\}

if \(\$tempo eq \$noticia\)

\{

print \"";
print CREATE "$FORM{'design'}";
print CREATE "\"\;

\}
\}
exit\;

\}";
close CREATE;
chmod(0755, "noticias.cgi");
}