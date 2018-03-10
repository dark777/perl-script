#!/usr/bin/perl

################################################################
# Programa Conteo  v1.3                                        #
# Data 22/10/2001                                              #
# Arquivos: conteo.cgi, conteo.html, ajuda.html, form.html     # 
# Verifique novas versoes em:                                  #
# http://www.oceanodigital.com.br/ods                          #
# ------------------------------------                         #
# CONSULTE O ARQUIVO AJUDA.HTML PARA                           #
# SABER COMO CONFIGURAR ESSE CGI.                              #
# ------------------------------------                         #
# Programa gratis desde que não altere nenhuma linha acima     #
################################################################


#########################
#         CONFIG        #
#########################
$pathsendmail = '/usr/sbin/sendmail';
$pronto = "http://www.seusite.com.br/confirmado.html";
@urls = ('www.seusite.com.br','seusite.com.br');
$paginaerro = "http://www.seusite.com.br/erro.html";


#########################
#         TEXTO         #
#########################
$Subject = "nomedosite";
$site = "www.seusite.com.br";
$mensagem = "Eu gostei muito desse site e gostaria que o visitasse.";
$mensagem2 = "O endereço do site é:";


################################################################




#########################
# NAO MUDAR NADA ABAIXO #
#########################
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
@pairs = split(/&/, $buffer);
foreach $pair (@pairs) {($name, $value) = split(/=/, $pair);
$value =~ tr/+/ /;
$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
$IND{$name} = $value;}
$nome1 = $in{'nome1'};
$email1 = $in{'email1'};
$nome2 = $in{'nome2'};
$email2 = $in{'email2'};
&dft;
&Tranq;
&ait;
&env;
print "Location: $pronto\n\n";
exit;

sub Tranq {  
if (index($IND{'email2'}, ",") > 0)  {&noi;}
if (index($IND{'email2'}, ";") > 0)  {&noi;}
if (index($IND{'email2'}, ".") < 1)  {&noi;}
if (index($IND{'email2'}, "@") < 1)  {&noi;}
if (index($IND{'email1'}, ".") < 1)  {&noi;}
if (index($IND{'email1'}, "@") < 1)  {&noi;}
if (index($IND{'email1'}, ",") > 0)  {&noi;}
if (index($IND{'email1'}, ";") > 0)  {&noi;}
if (index($IND{'email2'}, "/") > 0)  {&noi;}
if (index($IND{'email2'}, "<") > 0)  {&noi;}
if (index($IND{'email2'}, ">") > 0)  {&noi;}
}

sub ait {
if (!$IND{'nome1'} || $IND{'nome1'} eq ' ')  {&noi;}
if (!$IND{'email1'} || $IND{'email1'} eq ' ')  {&noi;}
if (!$IND{'nome2'} || $IND{'nome2'} eq ' ')  {&noi;}
if (!$IND{'email2'} || $IND{'email2'} eq ' ')  {&noi;}
}

sub noi {
print "Location: $paginaerro\n\n";
exit;
}

sub env {
open (MAIL,"|$pathsendmail -t");
print MAIL "To: $IND{'email2'}\n";
print MAIL "FROM: $IND{'email1'}\n";
print MAIL "Subject: $Subject\n";
print MAIL "Olá $IND{'nome2'},\n\n";
print MAIL "$mensagem\n";
print MAIL "$mensagem2\n";
print MAIL "$site\n\n";
print MAIL "$IND{'nome1'}\n\n";
close (MAIL);
}

sub dft {
if ($ENV{'HTTP_REFERER'}) {
foreach $referer (@urls) {
if ($ENV{'HTTP_REFERER'} =~ /$referer/i) {
$check_referer = '1';
last;
}}}
else {$check_referer = '1';}
if ($check_referer != 1) {
print "Location: $paginaerro\n\n";
exit;
}}

exit;