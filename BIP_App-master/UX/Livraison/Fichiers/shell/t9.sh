#!/bin/ksh
#_______________________________________________________________________________
autoload $(ls $FPATH)

LOG_TRAITEMENT=$DIR_BATCH_SHELL_LOG/$(date +"%Y%m%d").mensuelle.log
export LOG_TRAITEMENT
logText "`basename $0` : fichier de trace : $LOG_TRAITEMENT"

logText "--------------------------------------------------------------------------------" > $LOG_TRAITEMENT
logText "-- $(date +"%Y%m%d") Debut de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT

################################################################################
logText "-- Lancement du traitement de repartition" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/rjh.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Problème dans le traitement de repartition"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 327;
fi

###################################################################################################
logText "-- Lancement du traitement de repartition des arbitres" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/rjh_arb.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Probleme dans le traitement de repartition des arbitres"
	logText "arret du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 373;
fi

###################################################################################################
logText "-- Lancement du traitement de repartition des reestimes" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/rjh_ree.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Probleme dans le traitement de repartition des reestimes"
	logText "arret du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 378;
fi

###################################################################################################
logText "-- Lancement du traitement de repartition des notifies" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/rjh_noti.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Probleme dans le traitement de repartition des notifies"
	logText "arret du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 379;
fi

###################################################################################################
logText "-- Lancement du traitement de repartition des proposee" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/rjh_prop.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Probleme dans le traitement de repartition des proposees"
	logText "arret du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 380;
fi

# Fin du batch de t9
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
logText "-- Fin Normale de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
unset LOG_TRAITEMENT

exit 0
