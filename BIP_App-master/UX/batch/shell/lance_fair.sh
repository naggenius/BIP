#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : mensuelle.sh
# Objet : Shell batch  (mensuelle)
#
#_______________________________________________________________________________
# Creation : Equipe SOPRA 10/09/1999
# Modification :
# --------------
# Auteur  Date       Objet
# HTM     02/06/00   Appel Shell avec chemin absolu
# EGR     14/10/02   Migration ksh SOLARIS 8
# EGR     28/10/02   Plus de parametre pour les etapes
#		     Suppression de sorties erreur et ajout de traitements
#
################################################################################


DATE_HEURE=`date +"%Y%m%d.%H%M%S"`
LOG_FILE=$DIR_BATCH_SHELL_LOG/$DATE_HEURE.fair.log
LOG_TRAITEMENT=$LOG_FILE
export LOG_TRAITEMENT
logText "`basename $0` : fichier de trace : $LOG_TRAITEMENT"

###################Traitement FAIR#############################################


echo "--------------------------------------------------------------------------------" >>$LOG_FILE
echo "-- Debut du traitement fair.sh -------------------------------------------------" >>$LOG_FILE
echo "-- Date=<"`date +"%d/%m/%Y %T"`">\n" >>$LOG_FILE
echo "--------------------------------------------------------------------------------" >>$LOG_FILE

$DIR_BATCH_SHELL/fair.sh 2> $LOG_FILE

SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	print 'Echec lors de l execution du traitement fair'
	#28/10/02 plus de exit 450
fi
echo "--------------------------------------------------------------------------------" >>$LOG_FILE
echo "-- Fin du traitement fair.sh ---------------------------------------------------" >>$LOG_FILE
echo "-- Date=<"`date +"%d/%m/%Y %T"`">\n" >>$LOG_FILE
echo "--------------------------------------------------------------------------------" >>$LOG_FILE

unset LOG_TRAITEMENT
exit 0
