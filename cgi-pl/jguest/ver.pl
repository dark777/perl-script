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

my $porpagina = 5;

my $pagina = $query->param('pagina');

if(!$pagina || $pagina < 0) { $pagina = 0; }
print $query->header;
#################################################
####### HTML do Cabecalio
print qq~
<h2>jGuest!</h2><hr size=1>
~;
#################################################
$dbh=DBI->connect("DBI:mysql:$database:$host", $username, $password);
$sth=$dbh->prepare("SELECT * FROM guestbook");
$sth->execute;
$total = $sth->rows;
$inicio = $pagina * $porpagina;
$paginas = $total / $porpagina;
$sth=$dbh->prepare("SELECT * FROM guestbook ORDER BY id DESC LIMIT $inicio, $porpagina");
$sth->execute;

while (@atual=$sth->fetchrow_array) {
($numero,$nome,$email,$mensagem) = (@atual);
print qq~Nome: $nome<br>~;
if($email) { print qq~Email: $email<br>~; }
print qq~Mensagem: $mensagem<br><hr size=1>~;
}

if ($pagina > 0) {
 $anterior = $pagina - 1;
 print "<a href='?pagina=$anterior'>Anterior</a>";
} else {
 print "Anterior";
}

for($i=0;$i<$paginas;$i++) {
 $aaa = $i; $aaa++;
 if($pagina == $i) {
  print " [<b>$aaa</b>]";
 } else {
  print " [<a href='?pagina=$i'><b>$aaa</b></a>]";
 }
}

if($pagina<($paginas - 1)) {
 $proxima = $pagina + 1;
 print " <a href='?pagina=$proxima'>Proxima</a>";
} else {
 print " Proxima";
}
#################################################
####### HTML do Rodape
print qq~
<hr size=1>
Usamos: jGuest
~;
#################################################