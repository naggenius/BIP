#!/bin/ksh
#___________________________________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : rtfe.sh
# Objet : Shell batch rtfe
#         lance le deux shell : stloadrtfe.sh, alim_rtfe.sh  
#
#___________________________________________________________________________________________________
# Creation : BAA 19/10/2005
# Modification :
# --------------
# Auteur  Date       Objet
#  PPR    01/02/06   Rajout du chemin avant l'appel aux shells
#
################################################################################

autoload $(ls $FPATH)

######## chargement de la table tmp_rtfe
logText "-- Lancement de stloadrtfe.sh -------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/stloadrtfe.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors du chargement stloadrtfe.sh"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
fi


######## chargement de la table rtfe
logText "-- Lancement de alim_rtfe.sh -------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/alim_rtfe.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors du chargement alim_rtfe.sh"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 20;
fi


