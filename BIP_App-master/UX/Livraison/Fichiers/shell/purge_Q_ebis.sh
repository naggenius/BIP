#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : purge_Q_ebis.sh
# Objet : purge des fichiers import/export EXPENSE BIS
#
# Parametres d'entree :
#
#_______________________________________________________________________________
# Creation :
# DDI     21/03/2007
#
# Modification :
# --------------
# Auteur  Date       Objet
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.purge_Q_ebis.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE

# Parametrage des delais de purge
DELAI_REAL=90          #EBIS_DIR_REALISES/reussite ../erreur
DELAI_CONT=30          #EBIS_DIR_CONTRATS/reussite ../erreur
DELAI_FACT=180         #EBIS_DIR_FACT

# ##############################
# Purge des fichiers REALISES  #
# ##############################
$DIR_BATCH_SHELL/purge_repertoire.sh J $EBIS_DIR_REALISES/erreur $DELAI_REAL
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers EBIS REALISES ($EBIS_DIR_REALISES/erreur)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh J $EBIS_DIR_REALISES/reussite $DELAI_REAL
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers EBIS REALISES ($EBIS_DIR_REALISES/reussite)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

# ##############################
# Purge des fichiers CONTRATS  #
# ##############################
$DIR_BATCH_SHELL/purge_repertoire.sh J $EBIS_DIR_CONTRATS/erreur $DELAI_CONT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers EBIS CONTRATS ($EBIS_DIR_CONTRATS/erreur)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh J $EBIS_DIR_CONTRATS/reussite $DELAI_CONT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers EBIS CONTRATS ($EBIS_DIR_CONTRATS/reussite)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

# ##############################
# Purge des fichiers FACTURES  #
# ##############################
$DIR_BATCH_SHELL/purge_repertoire.sh J $EBIS_DIR_FACT $DELAI_FACT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers EBIS FACTURES ($EBIS_DIR_FACT)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Fin de (`basename $0`)"
logText "Fin de (`basename $0`)" >> $LOG_FILE


exit 0
