#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : WL_purge_Q.sh
# Objet : purges Quotidienne des fichiers de la Bip, cote Intranet
#
# Parametres d'entree :
#
#_______________________________________________________________________________
# Creation :
# EGR     09/10/03
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

LOG_TRAITEMENT=$DIR_BATCH_SHELL_LOG/$(date +"%Y%m%d").WL_purge_Q.log
export LOG_TRAITEMENT
logText "`basename $0` : fichier de trace : $LOG_TRAITEMENT"

logText "--------------------------------------------------------------------------------" > $LOG_TRAITEMENT
logText "-- $(date +"%Y%m%d") Debut de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT

DELAI_REPORTS=5
######   etape 1 : WL_purge_Q_reports  ################################################
logText "-- Lancement de WL_purge_Q_reports.sh ----------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/WL_purge_Q_reports.sh $DELAI_REPORTS 2>> $LOG_FILE
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
        logText "Echec lors de l execution du traitement WL_purge_Q_reports"
        logText "arret du batch `basename $0`"
        unset LOG_TRAITEMENT
        exit 1;
fi

DELAI_ERR=20
######   etape 2 : WL_purge_Q_err_reports  ################################################
logText "-- Lancement de WL_purge_Q_err_reports.sh ----------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/WL_purge_Q_err_reports.sh $DELAI_ERR 2>> $LOG_FILE
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
        logText "Echec lors de l execution du traitement WL_purge_Q_err_reports"
        logText "arret du batch `basename $0`"
        unset LOG_TRAITEMENT
        exit 1;
fi


######   etape 3 : WL_relanceReport ################################################
logText "-- Lancement de WL_relanceReport.sh ----------------------------------------" >> $LOG_TRAITEMENT
sudo /usr/bin/pkill -u bippoas
sudo su - bippoas -c "WL_relanceReport.sh $DIR_INTRA_EXECREPORTS"
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
        logText "Echec lors de l execution du traitement WL_purge_Q_err_reports"
        logText "arret du batch `basename $0`"
        unset LOG_TRAITEMENT
        exit 1;
fi

# Fin du batch de WL_purge_Q
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
logText "-- Fin Normale de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
unset LOG_TRAITEMENT

exit 0

