#!/usr/bin/perl

####################### BuscMaster 1.6 #######################
# busca.cgi                                                  #
# Copyright 1999-00, CGi-Master.                             #
# Este CGI é Gratuito! E se encontra em:                     #
# http://www.cgimaster.com.br                                #
##############################################################

require "config.txt";

######################################################
#  Não é recomendavel que você modifique o restante  #
######################################################

$stringpassed=$ENV{'QUERY_STRING'};
$stringpassed=~s/\+/ /g;
($wordspassed, $sf1passed)=split(/&&/,$stringpassed);

$input = $ENV{'QUERY_STRING'};
@pairs = split(/&/, $input);

foreach $input (@pairs)
{
    ($name, $value) = split(/=/, lc($input));

    $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $value =~ tr/+/ /;
    $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

    $FORM{$name} = $value;
}
$maximumpage=$FORM{'page'};
$start=$FORM{'inicio'};
$enditem=$start+$maximumpage;

$words=$FORM{'procurar'};

if (-e "$template"){
open(OPENING, "$template") || die "I can't open $data";

@wholefile=<OPENING>;
foreach $line (@wholefile){
$words=~s/words=//g;
$line=~s/!num!/$Num/g;

if ($line =~ /!results!/){
#if ($line =~ /\+\+\+/){
$line="";
$flipflop="Flip";}
if ($flipflop){
push (@closehtml,$line);}
else{
push (@openhtml,$line);}
}}
else {
$flipflop="Default";}

$words=~s/\"//g;

$words=~s/ and / /g;
$words=~s/ AND / /g;

if (-e "$data"){
$noproblem="Arquivo Banco de dados encontrado";}
else {
$problem="Encontrado problema.";
&security;}

#convert search keywords to lowercase
$words2=$words;
$words=lc($words);

$words2=~s/"/&quot;/g;
$words2=~s/%22/&quot;/g;
$keywords=$words2;

$checklength=length($words);

if ($checklength<$minimum){
$problem=$noresults;
&security;
}



($one1, $two2, $three3, $four4, $five5, $six6, $seven7)=split(/ /, $words);


$problem="Can't open the data file.";
open (FILE, "$data") || &security;
@all=<FILE>;
close (FILE);


print "Content-type: text/html\n\n";


if ($flipflop eq "Default"){
print "<HTML>\n";
print "<HEAD><TITLE>$sitetitle - Resultados da Busca</TITLE></head>\n";
print "<body bgcolor=\"#FFFFFF\">\n";}

else{


print "@openhtml\n";}



foreach $line (@all){
$linetemp1=lc($line);

($field1,$field2,$field3,$field4,$skipthisfield)=split (/$delimiter/,$linetemp1);


$line="$delimiter$line";


$line=~s/^ +//;

$wholestring=" $field1 $field2 $field3,$field4";
if ($wholestring  =~/\b$one1/ && $wholestring  =~/\b$two2/ && $wholestring  =~/\b$three3/ && $wholestring  =~/\b$four4/ && $wholestring  =~/\b$five5/ && $wholestring=~/\b$six6/ && $wholestring  =~/\b$seven7/){
push (@keepers,$line);}}


$length1=@keepers;


if ($length1<$enditem){
$enditem=$length1;
$displaystat="Y";
}


$disstart=$start+1;


$filename = "$queryfile";
  &open_file("FILE1",">>",$filename);

  &write_file("FILE1","<font face=\"verdana\"><a href=\"$thaturl?$stringpassed\">". $value ."</a>|" .$length1 ."<br>" .$blah ."\n");
   close(FILE1);

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
     die ("Can't open $filename");
}

sub read_file {

  local ($filevar) = @_;

  <$filevar>;
}

sub write_file {

  local ($filevar, $line) = @_;

  print $filevar ($line);
}


if ($length1){
print "<br><table border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td width=\"100%\" bgcolor=\"$bordercolor\"><table align=\"left\"><font face=\"arial\" size=\"2\" color=\"$textcolor\"><b>&nbsp;&nbsp;Encontrado: $length1 item(s)</b><font color=\"$textcolor\"><b>|</b></font> \n";
print "Mostrando: $disstart-$enditem | Resultados para <b><i>$words</i></b> | <A STYLE='color:$textcolor;text-decoration:underline;' HREF=\"javascript:window.external.AddFavorite('$thaturl?$stringpassed', '$sitetitle-  Resultado da busca com$value')\"><FONT COLOR='white'><nobr><b>Adicionar ao Favoritos</b></a></nobr></font></table>|</td></tr></table><P>\n";
} else {
&noresults
}


foreach $line (@keepers){


$line=~s/\n//g;



$countline1++;



if ($countline1>$start && $countline1<=$enditem){


($sortfield,$field1,$field2,$field3,$field4,$field5,$field6,$skipthisfield)=split (/$delimiter/,$line);



$field1=~s/\"//g;
$cntResults++;
print "\n<a name=\"$cntResults\">\n";
print "<li><font size=2><b><font color='black'>$cntResults.&nbsp;<a href=\"$field4\" target=\"_top\">$field1</a></font></b></font><BR>\n";


$field2=~s/\"//g;
$field2 = substr($field2,0,400);
print "<font size=2 face=\"arial\" color=\"BLACK\">$field2</font><BR>\n";

$field4=~s/\"//g;
print "<font size=1 color=\"gray\"><u>$field4</u><br><A STYLE='color:black;text-decoration:underline;' HREF=\"javascript:window.external.AddFavorite('$field4', '$sitetitle Resultados-  $field1')\"><FONT COLOR='BLACK'><nobr><b>Adicionar esta pagina ao Favoritos</b></a></nobr></font><br>\n";

print "<br>\n";

if ($countline1 == $maximum && $maximum){
last;}


if ($length1 == $countline1){
last;}


if ($countline1 == $enditem && $displaystat ne "Y"  && $maximum>$countline1){
$stopit="Y";
last;
}

}}

if ($stopit eq "Y"){
print "\n";
print "<a name=\"more results\">\n";
print "<form method=GET action=\"$thisurl\">\n";
print "<input type=hidden name=\"procurar\" value=\"$keywords\"> \n";
print "<input type=hidden name=\"Page\" value=\"$maximumpage\"> \n";
print "<input type=hidden name=\"inicio\" value=\"$enditem\"> \n";
print "<input type=submit value=\"Avançar\"></form>\n";
}

if ($flipflop eq "Default"){
print "</body></html>\n";}
else{
print "@closehtml\n";}
exit;

sub noresults {
if ($words eq "")
 {
 print "<b>Você não digitou nenhuma palavra</b>";
}

elsif ($noresults)
{
 print "Não foi possível encontrar nada com <b>$words</a>";
}
}

sub security {
print "Content-type: text/html\n\n";

if ($flipflop eq "Default")
{
print "<HTML>\n";
print "<HEAD><TITLE>BuscMaster</TITLE></head>\n";
print "<body bgcolor=\"#FFFFFF\">\n";
}
else
{
print "@openhtml\n";
}
&noresults;
if ($flipflop eq "Default")
{
print "</body></html>\n";
}
else
{
print "@closehtml\n";
}
exit;
}