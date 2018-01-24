#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : oscar_import.sh
# Objet :
#
# Parametres d'entree :
#	$1	Fichier de données à charger
#	$2	Fichier de log (facultatif)
#
#_______________________________________________________________________________
# Creation : O. Tonnelet 26/06/2002
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     16/10/02   Migration ksh sur SOLARIS 8
#
################################################################################

autoload $(ls $FPATH)

# Fichier log
if [ $# -eq 1 ]
then
	if [ -z $LOG_TRAITEMENT ]
	then
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.oscar_import.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi
elif [ $# -eq 2 ]
then
	LOG_FILE=$2
else
	logText "Mauvais nombre d'arguments" >&2
	logText "Usage `basename $0` FICHIER_DATA [LOG_FILE]" >&2
	exit 1
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'import des donnees OSCAR (`basename $0`)"
logText "Debut de l'import des donnees OSCAR (`basename $0`)" >> $LOG_FILE

DATA_FILE=$1
logText "| Fichier DATA : $DATA_FILE"
logText "| Fichier DATA : $DATA_FILE" >> $LOG_FILE

LOGLOAD_FILE=$DIR_SQLLOADER_LOG/`date +"%Y%m%d"`.oscar_import
BAD_FILE=$LOGLOAD_FILE.bad
DSC_FILE=$LOGLOAD_FILE.dsc
LOGLOAD_FILE=$LOGLOAD_FILE.logload

# appel SQL*LOADER avec trace execution
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/oscar.par \
	control=$DIR_SQLLOADER_PARAM/oscar.ctl \
	data=$DATA_FILE \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	discard=$DSC_FILE >> $LOG_FILE 2>&1

# valeur de sortie de SQL*Loader
LOAD_EXIT=$?
# si le loader retourne 0, il faut verifier qu'il n'y a pas de codes erreurs persents
# dans le fichier de log
if [ $LOAD_EXIT -ne 0 ] || \
   [ $(cat $LOGLOAD_FILE | grep -ci 'SQL\*Loader-') -ne 0 ] || \
   [ $(cat $LOGLOAD_FILE | grep -ci 'ORA-') -ne 0 ]
then
	logText "Probleme SQL*LOAD dans batch oscar_import : consulter $LOG_FILE"
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur <$LOAD_EXIT>"
	logText "Code erreur <$LOAD_EXIT>" >> $LOG_FILE
	exit -1;
fi

echo "Fin de traitement d'import des donnees oscar (`basename $0`)"
echo "Fin de traitement d'import des donnees oscar (`basename $0`)" >> $LOG_FILE

exit 0
