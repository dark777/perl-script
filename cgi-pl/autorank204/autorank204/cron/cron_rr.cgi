#!/usr/bin/perl
###########################
##  AutoRank Pro v2.0.4  ##
###################################################################################
##  cron_rr.cgi                                                                  ##
##  ----------                                                                   ##
##  This script controls the cron re-ranking of the script.                      ##
###################################################################################

### Set this variable
$SCRIPT_DATA_DIR = "/home/thenat/cgi-bin/rankem/sdata";
$CGI_SCRIPT_DIR = "/home/thenat/cgi-bin/rankem";

###################################################################################
#                    DONE EDITING THIS FILE - CHANGE NO MORE                      # 
###################################################################################
#  If any more editing is done to this file the minimum penalty will              #
#  be loss of technical support from CGI Works.  Editing of any script            #
#  can also result in a copyright violation.  Do NOT do it unless you             #
#  have received permission directly from CGI Works to do so!                     #
###################################################################################

require "$SCRIPT_DATA_DIR/variables.dat";
require "$CGI_SCRIPT_DIR/functions.cgi";
FUNCTIONS::print_the_list(FUNCTIONS::load_member_data());
