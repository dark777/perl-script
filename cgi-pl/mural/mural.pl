#!/usr/bin/perl

read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
@pairs = split(/&/, $buffer);
foreach $pair (@pairs) {
($name, $value) = split(/=/, $pair);
$value =~ tr/+/ /;
$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
$FORM{$name} = $value;
}

$nome = $FORM{'nome'};
$email = $FORM{'email'};
$nick = $FORM{'nick'};
$image = $FORM{'img'};
$mensagem = $FORM{'msg'};
$url = $FORM{'url'};
$image1 = "img1.gif";
$image2 = "img2.gif";
$image3 = "img3.gif";
$image4 = "img4.gif";
$image5 = "img5.gif";
$image6 = "img6.gif";
$image7 = "img7.gif";
$image8 = "img8.gif";
$image9 = "img9.gif";
$image10 = "img10.gif";
$image11 = "img11.gif";
$image12 = "img12.gif";
$arquivo = 'recados.txt';
$title = "Mural v1.0";
$logo = "mural.jpg";
@meses = ('01','02','03','04','05','06','07','08','09','10','11','12');
$dataf = &DataFormatada;

if($ENV{'QUERY_STRING'} eq "inserir") { &gravar; }

&index;

sub DataFormatada {
  ($seg,$min,$hora,$diames,$mes,$anoc,$diasem) = (localtime(time))[0,1,2,3,4,5,6];
  $ano += 2000;
  if ($hora < "10") { $hora = "0$hora"; }
  if ($min < "10") { $min = "0$min"; }
  return "$diames/$meses[$mes]/$ano $hora:$min";
}

sub index {
print "Content-type: text/html\n\n";
print "<html><head><title>$title</title>\n";
print "<STYLE><!--\n";
print "                .font1 { color: #ff9900; text-decoration: none; font-size: 11px; font-family: Verdana, Arial, Helvetica }\n";
print "                .font2 { color: #cc9900; text-decoration: none; font-size: 11px; font-family: Verdana, Arial, Helvetica }\n";
print "                a:hover { text-decoration: underline}\n";
print "                --></STYLE></head>\n";
print "<body bgcolor=\"#FFFFFF\" text=\"#000000\" link=\"#FF9900\" vlink=\"#FF9900\" alink=\"#FF9900\">\n";
print "<form action=\"mural.pl?inserir\" method=\"post\">\n";
print "    <div align=\"center\"><center><table border=\"0\" width=\"263\">\n";
print "        <tr><td valign=\"bottom\" colspan=\"3\"><p align=\"center\"><br>\n";
print "              <img border=\"0\" src=\"$logo\" width=\"318\" height=\"44\">\n";
print "            <br></p></td></tr><tr>\n";
print "            <td valign=\"bottom\"><font size=\"1\" face=\"Verdana\">Nome</font><br>\n";
print "            <input type=\"text\" size=\"15\" maxlength=\"30\" name=\"nome\"></td>
            <td valign=\"bottom\"><font size=\"1\" face=\"Verdana\">Nick</font><br>
            <input type=\"text\" size=\"10\" maxlength=\"30\" name=\"nick\"></td>
            <td valign=\"bottom\"><font size=\"1\"
            face=\"Verdana\">E-mail</font><br>
            <input type=\"text\" size=\"15\" maxlength=\"20\"
            name=\"email\"></td>
        </tr>
        <tr>
            <td valign=\"bottom\" colspan=\"3\"><font size=\"1\"
            face=\"Verdana\">Mensagem</font><br>
            <textarea name=\"msg\" rows=\"5\" cols=\"37\" id=\"fop\"
            wrap=\"psychical\"></textarea> </td>
        </tr>
    </center>
        <tr>
            <td valign=\"bottom\" colspan=\"3\">
              <p align=\"left\"><font size=\"1\"
            face=\"Verdana, Tahoma, Helv, Arial\">Homepage</font><br>
            <input type=\"text\" size=\"33\" maxlength=\"100\"
            name=\"url\"
            value=\"http://www.maximous.net\"> </p>
 </td>
        </tr>
      <center>
        <tr>
            <td valign=\"bottom\" colspan=\"3\"><table border=\"0\"
            cellpadding=\"2\" cellspacing=\"3\" width=\"265\">
                <tr>
                    <td align=\"center\"><img src=\"$image1\" width=\"32\" height=\"32\"><br>
                    <input type=\"radio\" name=\"img\"
                    value=\"$image1\"> </td>
                    <td>&nbsp;</td>
                    <td align=\"center\"><img src=\"$image2\" width=\"32\" height=\"32\"><br>
                    <input type=\"radio\" name=\"img\"
                    value=\"$image2\"> </td>
                    <td>&nbsp;</td>
                    <td align=\"center\"><img src=\"$image3\" width=\"32\" height=\"32\"><br>
                    <input type=\"radio\" name=\"img\"
                    value=\"$image3\"> </td>
                    <td>&nbsp;</td>
                    <td align=\"center\"><img src=\"$image4\" width=\"32\" height=\"32\"><br>
                    <input type=\"radio\" name=\"img\"
                    value=\"$image4\"> </td>
                    <td>&nbsp;</td>
                    <td align=\"center\"><img src=\"$image5\" width=\"32\" height=\"32\"><br>
                    <input type=\"radio\" name=\"img\"
                    value=\"$image5\"> </td>
                    <td>&nbsp;</td>
                    <td align=\"center\"><img src=\"$image6\" width=\"32\" height=\"32\"><br>
                    <input type=\"radio\" name=\"img\"
                    value=\"$image6\"> </td>
                </tr><tr>
                    <td align=\"center\"><img src=\"$image7\" width=\"32\" height=\"32\"><br>
                    <input type=\"radio\" name=\"img\"
                    value=\"$image7\"> </td>
                    <td>&nbsp;</td>
                    <td align=\"center\"><img src=\"$image8\" width=\"32\" height=\"32\"><br>
                    <input type=\"radio\" name=\"img\"
                    value=\"$image8\"> </td>
                    <td>&nbsp;</td>
                    <td align=\"center\"><img src=\"$image9\" width=\"32\" height=\"32\"><br>
                    <input type=\"radio\" name=\"img\"
                    value=\"$image9\"> </td>
                    <td>&nbsp;</td>
                    <td align=\"center\"><img src=\"$image10\" width=\"32\" height=\"32\"><br>
                    <input type=\"radio\" name=\"img\"
                    value=\"$image10\"> </td>
                    <td>&nbsp;</td>
                    <td align=\"center\"><img src=\"$image11\" width=\"32\" height=\"32\"><br>
                    <input type=\"radio\" name=\"img\"
                    value=\"$image11\"> </td>
                    <td>&nbsp;</td>
                    <td align=\"center\"><img src=\"$image12\" width=\"32\" height=\"32\"><br>
                    <input type=\"radio\" name=\"img\"
                    value=\"$image12\"> </td>
                </tr></table></td></tr><tr>
            <td valign=\"bottom\" colspan=\"3\">
              <p align=\"center\"><font size=\"1\"
            face=\"Verdana, Tahoma, Helv, Arial\">É proibido
            enviar palavrões e ofenças.<br>
            </font><input type=\"image\"
            name=\"Clique aqui para enviar a sua mensagem!\"
            src=\"botao.gif\" align=\"bottom\" border=\"0\"
            width=\"265\" height=\"25\"> </p>
 </td></tr></table></center></div></form>\n";

   ###################### ake sim tem q faze o eskema de imprime, foreach ##############
open(DATA, "<$arquivo");
@datao = <DATA>;
close(DATA);

if ($datao[0] eq "") { print "<center><font class=\"font1\"><b>Não há nenhuma mensagem nesse mural.</b></center></font>\n"; }
else {

foreach (@datao) {
chomp;
($nome,$email,$nick,$image,$mensagem,$url,$data) = split(/``/, $_);
print "<div align=\"center\"><center>
<table border=\"0\" cellPadding=\"0\" cellSpacing=\"0\" width=\"265\">
  <tr>
    <td></td>
    <td width=\"200\"><font face=\"verdana\" size=\"1\">Nome: <b>$nome<br>
    </b>Nick: <a class=\"font2\" href=\"mailto:$email\"><b>$nick</b></a> <b><br>
    </b></font></td></tr><tr>
    <td vAlign=\"top\" width=\"45\"><font face=\"verdana\" size=\"1\"><img
    src=\"$image\"></font></td>
    <td vAlign=\"top\" width=\"200\"><font face=\"verdana\" size=\"1\">$mensagem</font></td>
  </tr><tr>
    <td colSpan=\"2\" width=\"265\"><font face=\"verdana\" size=\"1\"><br>
    URL: <a class=\"font1\" href=\"$url\" target=\"new\">$url</a><br>
    $data</font></td>
  </tr></table></center></div><p></p>\n";
}
}
   ############## fim do bagulho ##################
&foot;
exit;
}

sub foot {
print "</body></html>\n";
}

sub gravar {
if(!$nome) { &erro("Campo nome não preenchido"); }
if(!$email) { &erro("Campo email não preenchido"); }
if($email !~ /@/) { &erro("Campo email nao parece ser valido"); }
if(!$nick) { &erro("Campo nick não preenchido"); }
if(!$image) { &erro("Campo imagem não preenchido"); }
if(!$mensagem) { &erro("Campo mensagem não preenchido"); }
if(!$url) { &erro("Campo url não preenchido"); }
if($url !~ /http:\/\//) { &erro("Campo url nao parece ser valido"); }

if(($nome) && ($email) && ($nick) && ($image) && ($mensagem) && ($url)) {
open(DATA, ">>$arquivo");
print DATA "$nome``$email``$nick``$image``$mensagem``$url``$dataf\n";
close(DATA);
&confirmacao;
exit;
}
} 

sub erro {
print "Content-type: text/html\n\n";
print "Ocorreu um erro: $_\n";
print "O sistema acusa: $!\n";
exit;
}

sub confirmacao {
print<<EOF;
Content-type: text/html\n\n
<html>

<head>
<style><!--
                .font1 { color: #ff9900; text-decoration: none; font-weight: bold; font-size: 11px; font-family: Verdana, Arial, Helvetica }
                .font2 { color: #cc9900; text-decoration: none; font-size: 11px; font-family: Verdana, Arial, Helvetica }
                a:hover { text-decoration: underline}
                --></style>
<title>Mural v1.0 - Sucesso!</title>
</head>

<body leftmargin="0">

<p align="center"><img
src="mural.jpg" width="318"
height="44" alt="mural.jpg (4372 bytes)"></p>

<p align="center">&nbsp;</p>
<div align="left">

<table border="0" width="100%" align="left" cellspacing="0" cellpadding="0">
  <tr>
    <td width="20%"></td>
    <td width="70%"><strong><small><font face="Verdana">Foi inserido o seguinte recado:</font></small></strong><blockquote>
      <table border="0" width="100%" cellspacing="0" cellpadding="0">
        <tr>
          <td width="15%"><small><font class="font1">Nome:</font></small></td>
          <td width="85%"><small><font face="Verdana">$nome</font></small></td>
        </tr>
        <tr>
          <td width="15%"><small><font class="font1">Nick: </font></small></td>
          <td width="85%"><small><font face="Verdana">$nick</font></small></td>
        </tr>
        <tr>
          <td width="15%"><small><font class="font1">Email: </font></small></td>
          <td width="85%"><small><font face="Verdana">$email</font></small></td>
        </tr>
        <tr>
          <td width="15%"><small><font class="font1">Mensagem: </font></small></td>
          <td width="85%"><small><font face="Verdana">$mensagem</font></small></td>
        </tr>
        <tr>
          <td width="15%"><small><font class="font1">Home-Page:</font></small></td>
          <td width="85%"><small><font face="Verdana">$url</font></small></td>
        </tr>
        <tr>
          <td vAlign="top" width="15%"><small><font class="font1">Imagem: </font></small></td>
          <td vAlign="top" width="85%"><small><font face="Verdana"><img src="$image" ></font></small></td>
        </tr>
      </table>
      <p>&nbsp;</p>
    </blockquote>
    <p><a href="mural.pl"><span class="font1">Voltar</span></a></td>
    <td width="20%"></td>
  </tr>
</table>
</div>
</body>
</html>
EOF
exit;
}
