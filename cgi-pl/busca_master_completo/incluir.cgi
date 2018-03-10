#!/usr/bin/perl

####################### BuscMaster 1.6 #######################
# incluir.cgi                                                #
# Copyright 1999-00, CGi-Master.                             #
# Este CGI é Gratuito! E se encontra em:                     #
# http://www.cgimaster.com.br                                #
##############################################################

require "config.txt";

######################################################
#  Não é recomendavel que você modifique este script #
######################################################

&parse_form;

print "Content-type: text/html\n\n";

if ($FORM{'add'} eq "x") { &addrecord; }
elsif ($ENV{'QUERY_STRING'} eq "") { &main; }

############################################
#         Gravando Novo Endereco           #
############################################

sub addrecord {

  $linktitle    = $FORM{'linktitle'};
  $linkdescrip    = $FORM{'linkdescrip'};
  $linkwords    = $FORM{'linkwords'};
  $linkemail   = $FORM{'linkemail'};
  $linkurl = $FORM{'linkurl'};

  # Convertendo < tags para &lt;
  $linktitle =~ s/</\&lt;/g;
  $linkdescrip =~ s/</\&lt;/g;
  $linkwords =~ s/</\&lt;/g;
  $linkemail =~ s/</\&lt;/g;
  $linkurl =~ s/</\&lt;/g;

   print "<html><head><title>Cadastro de Sites !!!</title></head>\n";
   print "<body Bgcolor='#FFFFFF'><img src=\"$logo\"><br><br>\n";
   $erro="0";

        if (!$FORM{'linktitle'})
        {
                if (!$erro)
                {
                        print("<font face=verdana size=+1><b>Erro:</b></font><br>\n");
                        $erro = 1;
                }
                print("<b><font face=verdana size=2 color=\"RED\">O Título do site não foi digitado</font><br></b>\n");
        }
        if (!$FORM{'linkurl'})
        {
                if (!$erro)
                {
                        print("<font face=verdana size=2>Erro:</font><br>\n");
                        $erro = 1;
                }
                        print("<b><font face=verdana size=2 color=\"RED\">O URL do site não foi digitado</font><br></b>\n");
        }
        if (!$FORM{'linkdescrip'})
        {
                if (!$erro)
                {
                        print("<font face=verdana size=2>Erro:</font><br>\n");
                        $erro = 1;
                }
                print("<b><font face=verdana size=2 color=\"RED\">Seu site deve ter uma descrição</font><br></b>\n");
        }
        if (!$FORM{'linkwords'})
        {
                if (!$erro)
                {
                        print("<font face=verdana size=2>Erro:</font><br>\n");
                        $erro = 1;
                }
                print("<b><font face=verdana size=2 color=\"RED\">Você deve digitar pelo menos uma palavra-chave</font><br></b>\n");
        }
                if (!$FORM{'linkemail'})
        {
                if (!$erro)
                {
                        print("<font face=verdana size=2>Erro:</font><br>\n");
                        $erro = 1;
                }
                print("<b><font face=verdana size=2 color=\"RED\">Você deve digitar seu e-mail</font><br></b>\n");
        }

if ($erro eq "1") {
print "<br>\n";
&form;
}
if ($erro eq "0") {
  # Manda email para o usuário e para o WebMaster do Site
                open (WMAIL, "|$mailprog -t") or &error("Unable to open the mail program");
                print WMAIL "To: $searchemail\n";
                print WMAIL "From: $searchemail\n";
                print WMAIL "Subject: Novo Cadastro!\n\n";
                print WMAIL "Novo site cadastrado! - $sitetitle!\n";
                print WMAIL "Dados do cadastro:\n";
                print WMAIL "------------------------------------------------------------------\n";
                print WMAIL "URL : $FORM{'linkurl'}\n";
                print WMAIL "Título : $FORM{'linktitle'}\n";
                print WMAIL "Descrição : $FORM{'linkdescrip'}\n";
                print WMAIL "Palavras-chaves : $FORM{'linkwords'}\n";
                print WMAIL "E-mail : $FORM{'linkemail'}\n";
                print WMAIL "------------------------------------------------------------------\n\n";
                print WMAIL "Novo site cadastrado no $sitetitle\n";
                print WMAIL "------------------------------------------------------------------\n\n";
                print WMAIL "Obrigado,\n";
                print WMAIL "---------------------------------------------\n";
                print WMAIL "$sitetitle\n";
                print WMAIL "$searchemail\n";
                print WMAIL "$urlini\n";
                close (WMAIL);
                open (MAIL, "|$mailprog -t") or &error("Unable to open the mail program");
                print MAIL "To: $FORM{'linkemail'}\n";
                print MAIL "From: $searchemail\n";
                print MAIL "Subject: Cadastro - $sitetitle!\n\n";
                print MAIL "Seu cadastro - $sitetitle!\n";
                print MAIL "Seu cadastro:\n";
                print MAIL "------------------------------------------------------------------\n";
                print MAIL "URL : $FORM{'linkurl'}\n";
                print MAIL "Título : $FORM{'linktitle'}\n";
                print MAIL "Descrição : $FORM{'linkdescrip'}\n";
                print MAIL "Palavras-chaves : $FORM{'linkwords'}\n";
                print MAIL "E-mail : $FORM{'linkemail'}\n";
                print MAIL "------------------------------------------------------------------\n\n";
                print MAIL "$msgmail\n";
                print MAIL "------------------------------------------------------------------\n\n";
                print MAIL "Obrigado,\n";
                print MAIL "---------------------------------------------\n";
                print MAIL "$sitetitle\n";
                print MAIL "$searchemail\n";
                print MAIL "$urlini\n";
                close (MAIL);
  # Abre o Banco de dados e grava as informações

  &open_file("FILE1",">>",$filename);
  &write_file("FILE1",$linktitle . "|".$linkdescrip. "|" .$linkwords ."|http://" .$linkurl . "|" .$linkemail ."\n");
   close(FILE1);
   print "<BR><font face=\"Verdana\" size=2><CENTER>Obrigado pela contribuição !</CENTER></font>\n";
   print "<br><br><a href=index.htm>Ir para a página de busca</a>";
}
   print "</body></html>\n";
}

sub main {
print <<EOF;

 <html>
 <head>
  <title>Incluir Novo Site</title>
 </head>
 <body bgcolor=#FFFFFF text=#000000>
<img src="$logo"><br>
 <center>
  <table border="0" align="center" width="100%">
    <TR>
      <TD Align="Center"> <Font Size="3" Face="Arial"><Strong>Inserir Novo Endereço!</Strong></Font>
        <FORM METHOD=POST ACTION="incluir.cgi">
          <INPUT TYPE="HIDDEN" NAME="add" value="x">
          <font face="verdana, arial" size=2><b>Título :</b></font>
          <INPUT NAME="linktitle" SIZE="30" MAXLENGTH="50">
          <BR>
          <font face="verdana, arial" size=2><b>URL : </b></font>
          <font size=2 face=arial>http://</font><INPUT TYPE="Text" NAME="linkurl" SIZE="30" MAXLENGTH="100">
          <BR>
          <font face="verdana, arial" size=1><i><b>Descrição :</b></i></font><BR>
          <Font Size=1 face="arial">Coloque uma ou duas frases com palavras características
          do seu site.<BR>
          200 caracteres no máximo. Estas informações irão ser divulgadas a <BR>
          quem pesquisar nosso banco de dados.</font><BR>
          <INPUT NAME="linkdescrip" SIZE="30" MAXLENGTH="250">
          <BR>
          <font face="verdana, arial" size=1><i><b>Palavras Chaves :</b></i></font><BR>
          <Font Size=1 face="arial">Coloque palavras chaves adicionais (separado
          por espaços)<BR>
          para ajudar nas pesquisas. Note que essas palavras não serão <BR>
          inseridas no resultado.</font><BR>
          <INPUT NAME="linkwords" SIZE="30" MAXLENGTH="150">
          <BR>
          <font face="verdana, arial" size=1><i><b>E-mail :<br></b></i></font> <font face="arial" size=1>Seu
          e-mail não será divulgado no site.<BR>
          (somente para controle interno)</font><BR>
          <INPUT NAME="linkemail" SIZE="30" MAXLENGTH="40">
          <BR>
          <INPUT TYPE=submit value="Cadastrar">
        </FORM>

      </td>
    </TR>
  </TABLE>

</CENTER>
</body>
</html>

EOF

}

sub form {
print <<EOF;

  <table border="0" align="center" width="100%">
    <TR>
      <TD Align="Center"> <Font Size="3" Face="Arial"><Strong>Corrija os erros!</Strong></Font>
        <FORM METHOD=POST ACTION="incluir.cgi">
          <font face="verdana, arial" size=2><b>Título :</b></font>
          <INPUT NAME="linktitle" SIZE="30" MAXLENGTH="50">
          <BR>
          <font face="verdana, arial" size=2><b>URL : </b></font>
          <font size=2 face=arial>http://</font><INPUT TYPE="Text" NAME="linkurl" SIZE="30" MAXLENGTH="100">
          <BR>
          <font face="verdana, arial" size=1><i><b>Descrição :</b></i></font><BR>
          <Font Size=1 face="arial">Coloque uma ou duas frases com palavras características
          do seu site.<BR>
          200 caracteres no máximo. Estas informações irão ser divulgadas a <BR>
          quem pesquisar nosso banco de dados.</font><BR>
          <INPUT NAME="linkdescrip" SIZE="30" MAXLENGTH="250">
          <BR>
          <font face="verdana, arial" size=1><i><b>Palavras Chaves :</b></i></font><BR>
          <Font Size=1 face="arial">Coloque palavras chaves adicionais (separado
          por espaços)<BR>
          para ajudar nas pesquisas. Note que essas palavras não serão <BR>
          inseridas no resultado.</font><BR>
          <INPUT NAME="linkwords" SIZE="30" MAXLENGTH="150">
          <BR>
          <font face="verdana, arial" size=1><i><b>E-mail :<br></b></i></font> <font face="arial" size=1>Seu
          e-mail não será divulgado no site.<BR>
          (somente para controle interno)</font><BR>
          <INPUT NAME="linkemail" SIZE="30" MAXLENGTH="40">
          <BR>
          <INPUT TYPE=submit value="Cadastrar">
        </FORM>

      </td>
    </TR>
  </TABLE>


      </td>
    </TR>
  </TABLE>

EOF

}

sub parse_form {

   read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
   if (length($buffer) < 5) {
         $buffer = $ENV{QUERY_STRING};
    }

  @pairs = split(/&/, $buffer);
   foreach $pair (@pairs) {
      ($name, $value) = split(/=/, $pair);

      $value =~ tr/+/ /;
      $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

      $FORM{$name} = $value;
   }
}



sub open_file {

  local ($filevar, $filemode, $filename) = @_;

  open ($filevar,$filemode . $filename) ||
     die ("Não posso abrir $filename");
}

sub read_file {

  local ($filevar) = @_;

  <$filevar>;
}

sub write_file {

  local ($filevar, $line) = @_;

  print $filevar ($line);
}

sub error{
print "An error has been occured. The error is: $_[0]<br>\n";
print "<font color=\"red\">Reason: $!</font>\n";
exit;
}