######################################################################
#                           CGI Busca v2.0                           #
#                                                                    #
# Configuração: Edite somente o configuracao.cgi para que funcione   #
#                             corretamente.                          #
#                                                                    #
#                                                                    #
#                                                                    #
# Criador: Renan Silveira Elias                                      #
# E-mail: renan.elias@bol.com.br                                     #
# ICQ: 89603614                                                      #
# Site: http://www.scriptsnan.rg3.net / http://www.cgiclube.net      #
#                                                                    #
#    Você precisa de um CGI para seu site? Entre em contato! Crio    #
#       seu script do modo que quiser por um preço muito bom.        #
######################################################################

############################ Configuração ############################
#

$versao = "2.0";
# Versão do Seu Sistema. !!!NÃO MUDE!!!

$imagens = "http://localhost/CGI Busca v2.0/imagens";
# URL da Pasta onde se localizam as imagens do Sistema.

$urlsistema = "http://localhost/CGI Busca v2.0";
# Url da pasta principal do Sistema.

$patchx = "/home/renan/public_html/sn/cgibusca";
# Patch para pasta principal do sistema.

$senhaadmin = "cgibusca";
# Senha Administrativa.

$enviaremail = "Sim";
# Enviar E-mail Quando o usuário adicionar o site? Sim ou Não

$porpagina = "15";
# Quantidade de Sites a serem Listados por Página no Resultado da Busca, na página das categorias e nos sites Novos.

$minimo = "3";
# Quantidade Mínima de Letras na pesquisa para o Sistema realizar a Busca.

$mailwm = "renan.elias\@bol.com.br";
# E-mail do WebMaster do Sistema ou do Site. Não se esqueça do \ antes do @! Ex: nome\@email.com

$emailservidor = "/usr/sbin/sendmail";
# Patch para o Servidor de E-mail
 
$nomesistema = "CGI Busca v$versao";
# Nome do Sistema

$tnovo="7";
# Quantidade de dias que um site é considerado Novo.

#
######################################################################