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

&usuario unless $FORM{'senha'};
&usuario unless $FORM{'usuario'};

$arquivo="usuarios.rse";

open (USUARIOS, "$arquivo") || &open_error($arquivo);
@usuario = <USUARIOS>;
close (USUARIOS);
foreach $line (@usuario)

{

    ($nome, $senha) = split(/ /,$line);
    $logando{$nome}=$senha;
    
}


if (!$logando{$FORM{'usuario'}})
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
elsif (crypt($FORM{'senha'},"MM") ne $logando{$FORM{'usuario'}} ) {
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

open(DATA, "<usuarios/$FORM{'usuario'}.txt");
@datao = <DATA>;
close(DATA);

if ($datao[0] eq "") { print "<center><font class=\"font1\"><b>Erro</b></center></font>\n"; }
else {

foreach (@datao) {
chomp;
($email,$nome,$avatar) = split(/``/, $_);

print "Set-Cookie: usuario=$FORM{'usuario'}; path=/; expires=1d GMT;\n";
print "Set-Cookie: senha=$FORM{'senha'}; path=/; expires=1d GMT;\n";

print "Content-type: text/html\n\n";
print "<html>

<head>
<meta http-equiv=\"Content-Language\" content=\"pt-br\">
<meta name=\"GENERATOR\" content=\"Microsoft FrontPage 5.0\">
<meta name=\"ProgId\" content=\"FrontPage.Editor.Document\">
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1252\">
<title>Scripts Nan</title>";

open(postar, "$patch/script.inc");
@post = <postar>;
close(postar); 

print @post;

print "</head>

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
    <p align=\"center\"><p align=\"center\"><font face=\"Verdana\" size=\"1\"><b>S</b>eja Bem Vindo $nome.<br>
<b>P</b>reencha o formulário abaixo para postar uma mensagem.<br>
<b>L</b>embramos...<br>
<b>V</b>ocê pode usar HTML na mensagem.</font></p>
<p align=\"center\">
<div align=\"center\">
        <center>
	  <table width=\"90%\" border=\"1\" bordercolor=\"#111111\" cellpadding=\"8\" cellspacing=\"0\" style=\"border-collapse: collapse\">
	    <tr bgcolor=\"#ffffff\"> 
      <td>
<form method=\"POST\" action=\"postar.cgi\" name=\"submitnews\">
<input type=\"hidden\" name=\"nome\" value=\"$nome\">
<input type=\"hidden\" name=\"email\" value=\"$email\">
<input type=\"hidden\" name=\"imagem\" value=\"$avatar\">
	        <div align=\"center\"><font face=\"Verdana\" size=\"1\">
<b>Resumo da Notícia<br>(80 caracteres no máximo)</b>
<p><!--webbot bot=\"Validation\" b-value-required=\"TRUE\" i-maximum-length=\"80\" --><input type=\"text\" name=\"titulo\" size=\"80\" maxlength=\"80\"></p>
<b><font size=\"1\">Notícia</font></b><font size=\"1\"> <br>
	          <textarea name=\"mensagem\" cols=\"70\" rows=\"15\" wrap=\"VIRTUAL\"></textarea>
	<br>
		<input type=\"submit\" name=\"Submit\" value=\"Enviar\"><input type=\"reset\" value=\"Apagar\">
              </font></font>
	        </div></form>
<center><form name=\"entryform\" onSubmit=\"enter(); return false;\">
<hr>
<p><font face=\"Verdana\" size=\"1\"><b>Editor Avançado</b></font></p>
<table><tr><td valign=\"top\" rowspan=\"2\"><table>
<tr><td>
  <font face=\"Verdana\" size=\"1\">
  <input type=\"button\" name=\"Text Styles\" value=\"Estilos de Texto\" onclick=\"submitval=1; setupstyle();\"></font></td></tr>
<tr><td>
  <font face=\"Verdana\" size=\"1\">
  <input type=\"button\" name=\"Font Styles\" value=\"Cor da Fonte\" onclick=\"submitval=2; setupfont();\"></font></td></tr>
<tr><td>
  <font face=\"Verdana\" size=\"1\">
  <input type=\"button\" name=\"Formating\" value=\"Formatação\" onclick=\"submitval=3; setupform();\"></font></td></tr>
<tr><td><font face=\"Verdana\" size=\"1\"><input type=\"button\" name=\"Link\" value=\"Link\" onclick=\"submitval=4; setuplink();\"></font></td></tr>
<tr><td><font face=\"Verdana\" size=\"1\"><input type=\"button\" name=\"E-mail\" value=\"E-mail\" onclick=\"submitval=5; setupmail();\"></font></td></tr>
<tr><td>
  <font face=\"Verdana\" size=\"1\">
  <input type=\"button\" name=\"Image\" value=\"Imagem\" onclick=\"submitval=6; setupimage();\"></font></td></tr>
</table></td>
<td valign=\"top\">
<table>
<tr><td colspan=3><font face=\"Verdana\" size=\"1\"><input type=\"text\" size=15 name=\"select_title\" onFocus=\"document.entryform.select_list.focus();\"></font></td></tr>
<tr><td colspan=3><font face=\"Verdana\" size=\"1\"><select size=\"4\" name=\"select_list\">
<option>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</option>
<option></option>
<option></option>
<option></option>
<option></option>
<option></option>
<option></option>
<option></option>
<option></option>
<option></option>
<option></option>
<option></option>
</select></font></td></tr>
<tr><td><font face=\"Verdana\" size=\"1\"><input type=\"submit\" name=\"Enter\" value=\"Inserir\"></font></td>
<td><font face=\"Verdana\" size=\"1\"><input type=\"checkbox\" name=\"distype\" checked=true value=\"ON\"></font></td>
<td><font size=\"1\" face=\"Verdana\">Adicionar na mensagem</font></td>
</tr></table></td>
<td valign=top><table>
<tr><td><font face=\"Verdana\" size=\"1\"><input type=\"text\" size=24 name=\"text_title\" onFocus=\"document.entryform.text_entry.focus();\"></font></td></tr>
<tr><td><font face=\"Verdana\" size=\"1\"><textarea cols=20 rows=6 name=\"text_entry\"></textarea></font></td></tr>
</table></td>
<td valign=top><table>
<tr><td><font face=\"Verdana\" size=\"1\"><input type=\"text\" size=12 name=\"text2_title\" onFocus=\"document.entryform.text2_entry.focus();\"></font></td></tr>
<tr><td><font face=\"Verdana\" size=\"1\"><textarea cols=10 rows=6 name=\"text2_entry\"></textarea></font></td></tr>
</table></td>
</tr>
<td colspan=3>&nbsp;</td>
</tr></table>

</form></center>
	</td>
	    </tr>
	  </table>
	    </center>
      </div>
	  <font face=\"Verdana\" size=\"1\">
	  <br>
	</div>

	  <br>
	</div>
</font>
</p></p>

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
}
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
