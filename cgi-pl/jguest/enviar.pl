#!/usr/bin/perl

#####################################
# Joao Orui - jfsso@cgiclube.net
# Copyleft (L) por Joao Orui
# Todos os direitos nao reservados!
#####################################
# jGuest - Livro de Visitas

use CGI;
use DBI;

my $query = new CGI;
my $host = "localhost";
my $username = "usuario";
my $database = "database";
my $password = "senha";

my $modo = $query->param('modo');

if($modo eq 'envia') {
my $nome = $query->param('nome');
my $email = $query->param('email');
my $mensagem = $query->param('mensagem');

if (!$nome) { $erro .= "Nome nao preeenchido<br>"; }
unless ($email =~ /\@/) { $erro .= "Email invalido<br>"; }
if (!$mensagem) { $erro .= "Mensagem nao preeenchida<br>"; }
if($erro) { &erro; }

$nome =~ s/</&lt;/ig; $nome =~ s/>/&gt;/ig;
$email =~ s/</&lt;/ig; $email =~ s/>/&gt;/ig;
$mensagem =~ s/</&lt;/ig; $mensagem =~ s/>/&gt;/ig;

$dbh=DBI->connect("DBI:mysql:$database:$host", $username, $password);
$dbh->do("INSERT INTO guestbook (nome, email, mensagem) VALUES ('$nome', '$email', '$mensagem')") or die $dbh->errstr;
$dbh->disconnect;

print $query->redirect("ver.pl");
} else {
print $query->header;
##############################
######### Formulario
print qq~
<h2>jGuest!</h2><hr size=1>
<form action="enviar.pl" method="POST">
<input type=hidden name=modo value="envia">
Nome: <input type=text name=nome><br>
Email: <input type=text name=email><br>
Mensagem:<br>
<textarea name=mensagem></textarea><br>
<input type=submit>
</form>
<hr size=1>
Usamos jGuest!
~;
##############################
}

sub erro {
print $query->header;
print "Erro(s)!<br>$erro";
exit;
}