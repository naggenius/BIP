#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : tom_pra_cono.sh
# Objet : script d'envoi TOM des conso vers Prest@chat
#        
#_______________________________________________________________________________
# Creation     : ABA 05/07/2012
#_______________________________________________________________________________
# Modification : 
#
################################################################################


if [ -a $EMISSION/$PRA_CONSO ] 
then
cd ${EMISSION}
#on recupère dans VAR1 le champ 1 2 et 3 et dans VAR2 le champ 4
#commande trans_tom prend en paramatre champ1.champ2.champ3 et champ4
VAR1=`echo $PRA_CONSO | cut -d'.' -f1,2,3`
VAR2=`echo $PRA_CONSO | cut -d'.' -f4`

echo $VAR1
echo $VAR2
trans_tom $VAR1 $VAR2
fi
