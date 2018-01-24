#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : WL_relanceReport.sh
# Objet : script de relance du server reports
#
# Ce script est copié dans le répertoire bin du server report à savoir en production /produits2/bip_oas10g/bin
#
# Parametres d'entree :
#   chemin du repertoire de log des reports : $DIR_INTRA_EXECREPORTS
#_______________________________________________________________________________
# Creation :
# ABA    14/06/10
#
# Modification :
# --------------
#
################################################################################

LOG_TRAITEMENT=$1/`date +"%Y%m%d"`.WL_relanceReport.log

opmnctl startall
emctl start iasconsole
sleep 10
opmnctl status >> $LOG_TRAITEMENT
emctl status iasconsole >> $LOG_TRAITEMENT

exit 0;