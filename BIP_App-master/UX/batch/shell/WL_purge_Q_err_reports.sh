#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : WL_purge_Q_err_reports.sh
# Objet :
#       Le script REP_INTRANET/WEB-INF/cmd/execReports genere en cas d'anomalie
#       des fichiers d'erreur. Ce sont ces fichiers qui vont etre purges
#
# Parametres d'entree :
#       $1      :       delai de la purge en jours ouvres
#
#_______________________________________________________________________________
# Creation :
# EGR     08/10/03
#
# Modification :
# --------------
# Auteur  Date       Objet
# E.GREVREND	  19/10/04	MAJ WLS7
# A.SAKHRAOUI     03/04/07      MAJ WLS9
#
################################################################################
autoload $(ls $FPATH)

. /applis/bip_wl9/bip9dom/WL_bipparam.sh

if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.WL_purge_Q_err_reports.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

if [ $# -ne 1 ]
then
        logText "Mauvais nombre d'arguments" >&2
        logText "Usage `basename $0` DELAI_JOURS" >&2
        logText "Mauvais nombre d'arguments" >> $LOG_FILE
        logText "Usage `basename $0` DELAI_JOURS" >> $LOG_FILE
        exit -1
else
        DELAI=$1
        logText "| Delai jours : $DELAI"
        logText "| Delai jours : $DELAI" >> $LOG_FILE
fi

REP=$DIR_INTRA_EXECREPORTS
FILTRE=????????.*.err

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE

$DIR_BATCH_SHELL/WL_purge_repertoire.sh J $REP $DELAI $FILTRE 2>> $LOG_FILE
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
        logText "Echec lors de la purge des fichiers de travail du script de lancement des editions par l'intranet"
        logText "arret du batch `basename $0`"
        exit 1;
fi

logText "Fin de (`basename $0`)"
logText "Fin de (`basename $0`)" >> $LOG_FILE

exit 0

