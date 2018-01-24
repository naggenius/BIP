#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : purge_tous_6m
# Objet : purge des fichiers dont la date de création est superieure à 6 mois
#
# Parametres d'entree :
#
#_______________________________________________________________________________
# Creation :
# JBE     05/11/2009
#
# Modification :
# --------------
# Auteur  Date       Objet 
#
###################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.purge_tous_6m.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE

# Parametrage des delais de purge
DELAI_TOUS_FIC=6           
# pour les repertoires suivants : 
# /batch/bipp/applis/bipdata/batch 
# /batch/bipp/applis/bipdata/diva
# /batch/bipp/applis/bipdata/fair/reussite
# /batch/bipp/applis/bipdata/oscar/export
# /batch/bipp/applis/bipdata/pepsi/reussite
# /batch/bipp/applis/bipdata/remontee/histo
# /batch/bipp/applis/bipdata/sgam/export_conso/reussite
# /batch/bipp/applis/batch/log 
# /batch/bipp/applis/batch/data



#Purge des fichiers dont la date création est  superieure à six mois
$DIR_BATCH_SHELL/purge_repertoire.sh 01M ${BIP_DATA}/batch $DELAI_TOUS_FIC
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers  (${BIP_DATA}/batch)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh 01M ${BIP_DATA}/diva $DELAI_TOUS_FIC
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers (${BIP_DATA}/diva)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh 01M ${BIP_DATA}/fair/reussite $DELAI_TOUS_FIC
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers (${BIP_DATA}/fair/reussite)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh 01M ${BIP_DATA}/oscar/export $DELAI_TOUS_FIC
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers (${BIP_DATA}/oscar/export)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh 01M ${BIP_DATA}/pepsi/reussite $DELAI_TOUS_FIC
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers (${BIP_DATA}/pepsi/reussite)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh 01M ${BIP_DATA}/remontee/histo $DELAI_TOUS_FIC
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers (${BIP_DATA}/remontee/histo)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh 01M ${BIP_DATA}/sgam/export_conso/reussite $DELAI_TOUS_FIC
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers (${BIP_DATA}/sgam/export_conso/reussite)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh 01M ${DIR_BATCH_SHELL_LOG} $DELAI_TOUS_FIC
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers (${DIR_BATCH}/log)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh 01M ${DIR_BATCH_DATA} $DELAI_TOUS_FIC
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers (${DIR_BATCH}/data)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi


logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Fin de (`basename $0`)"
logText "Fin de (`basename $0`)" >> $LOG_FILE

exit 0
