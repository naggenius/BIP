#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : purge_M_reports_batch.sh
# Objet : SHELL de purge des fichiers crees par Oracle Reports Server
#
# Parametres d'entree :
#	$1	Delai en nombre de mois,
#		les fichiers supprimes seront ceux strictement anterieur au 01/moisCourant-Delai
#
#_______________________________________________________________________________
# Creation :
#	EGR	18/08/2003
#
# Modification :
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.purge_M_reports_batch.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de la purge des reports des batchs (`basename $0`)"
logText "Debut de la purge des reports des batchs (`basename $0`)" >> $LOG_FILE

if [ $# -ne 1 ]
then
	logText "Mauvais nombre d'arguments" >&2
	logText "Usage `basename $0` DELAI_MOIS" >&2
	logText "Mauvais nombre d'arguments" >> $LOG_FILE
	logText "Usage `basename $0` DELAI_MOIS" >> $LOG_FILE
	exit -1
else
	DELAI=$1
	logText "| Delai mois : $DELAI"
	logText "| Delai mois : $DELAI" >> $LOG_FILE
fi

REPERTOIRE=$DIR_BATCH_REPORT_OUT

$DIR_BATCH_SHELL/purge_repertoire.sh 01M $REPERTOIRE $DELAI
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers reports batch ($REPERTOIRE)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Fin de (`basename $0`)"
logText "Fin de (`basename $0`)" >> $LOG_FILE

exit 0
