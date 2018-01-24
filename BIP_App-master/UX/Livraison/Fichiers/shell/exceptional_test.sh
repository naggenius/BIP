#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom of File : export_ligneBipEnrichi_carat.sh
# Object : GENERATION AND TRANSFER OF EXTRACTION OF ACTIVE BIP LINES FOR CARAT
# 
#_______________________________________________________________________________
# Creation : Steria 23/08/2017
# Modification : Initial copy
# --------------
# Auteur                Date         	Objet
# Nagesh				23/08/2017		Initial copy
################################################################################
set -x

#echo $PARAMS
sqlplus -s $CONNECT_STRING <<EOF
@$TMPDIR/BIP_EXCEPTIONAL_TRAIT.sql
EOF

exit 0
####################################################################################

