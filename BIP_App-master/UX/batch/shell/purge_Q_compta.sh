
#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : purge_Q_compta.sh
# Objet : purge des fichiers import/export compta
#
# Parametres d'entree :
#
#_______________________________________________________________________________
# Creation :
# EGR     14/08/03
#
# Modification :
# --------------
# Auteur  Date       Objet
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.purge_Q_compta.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE

# parametrage des delais de purge
DELAI_IMP_ARC=7         #DIR_BATCH_DATA
DELAI_EXP_ECH=7         #ORA_LIVE_UTL_EXPCOMPTA/erreur
DELAI_EXP_SUC=7         #ORA_LIVE_UTL_EXPCOMPTA/reussite
DELAI_EXP_ARC=7         #ORA_LIVE_UTL_EXPCOMPTA/fichiers_archives


$DIR_BATCH_SHELL/purge_repertoire.sh J $DIR_BATCH_DATA $DELAI_IMP_ARC
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers d'import compta ($DIR_BATCH_DATA)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh J $ORA_LIVE_UTL_EXPCOMPTA/erreur $DELAI_EXP_ECH
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers d'import compta ($ORA_LIVE_UTL_EXPCOMPTA/erreur)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh J $ORA_LIVE_UTL_EXPCOMPTA/reussite $DELAI_EXP_SUC
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers d'import compta ($ORA_LIVE_UTL_EXPCOMPTA/reussite)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh J $ORA_LIVE_UTL_EXPCOMPTA/fichiers_archives $DELAI_EXP_ARC
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers d'import compta ($ORA_LIVE_UTL_EXPCOMPTA/fichiers_archives)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Fin de (`basename $0`)"
logText "Fin de (`basename $0`)" >> $LOG_FILE


exit 0
