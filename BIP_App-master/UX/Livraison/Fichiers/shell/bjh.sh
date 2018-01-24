#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : bjh.sh
# Objet : Shell-script du traitement global de bouclage J/H
#
#_______________________________________________________________________________
# Creation : O. Duprey 21/11/2001
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     14/10/02   Migration ksh sur SOLARIS 8
#
################################################################################

autoload $(ls $FPATH)
heuredebut=`date +'%T'`
if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.bjh.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de BJH (`basename $0`)"
logText "Debut de BJH (`basename $0`)" >> $LOG_FILE

#import des donnees Gershwin
logText "-- Lancement de bjh_import_gershwin.sh" >> $LOG_FILE
$DIR_BATCH_SHELL/bjh_import_gershwin.sh $LOG_FILE 2>> $LOG_FILE
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de l'execution du traitement bjh_import_gershwin.sh"
	#BIP 183 - Mailing the information about absent of gershwin file
	$DIR_BATCH_SHELL/alerte_mail.sh 5 $heuredebut 2 'bjh_import_gershwin.sh'
	#BIP 183 - Remove the dependency of gershwin and niveaux file
	#exit $SHELL_EXIT
fi

# import des donnees BIP
logText "-- Lancement de bjh_import_bip.sh" >> $LOG_FILE
$DIR_BATCH_SHELL/bjh_import_bip.sh $LOG_FILE 2>> $LOG_FILE
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de l'execution du traitement bjh_import_bip.sh"
	exit $SHELL_EXIT
fi

# comparaison des deux jeux de donnees
logText "-- Lancement de bjh_compare.sh" >> $LOG_FILE
$DIR_BATCH_SHELL/bjh_compare.sh $LOG_FILE 2>> $LOG_FILE
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de l'execution du traitement bjh_compare.sh"
	exit $SHELL_EXIT
fi

logText "Fin de BJH  (`basename $0`)"
logText "Fin de BJH  (`basename $0`)"

exit 0
