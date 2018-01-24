#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : purge_Q_log.sh
# Objet : purge des fichiers log batch/oracle
#
# Parametres d'entree :
#
#_______________________________________________________________________________
# Creation :
# EGR     21/10/04
#
# Modification :
# --------------
# Auteur  Date       Objet
#
################################################################################


if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.purge_Q_log.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE

# parametrage des delais de purge
DELAI=80


$DIR_BATCH_SHELL/purge_repertoire.sh J $DIR_BATCH_SHELL_LOG $DELAI
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers de log ($DIR_BATCH_SHELL_LOG)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi


logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Fin de (`basename $0`)"
logText "Fin de (`basename $0`)" >> $LOG_FILE


exit 0
