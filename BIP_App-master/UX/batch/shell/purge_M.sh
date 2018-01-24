#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : purge_M.sh
# Objet : purges Mensuelle des fichiers de la Bip
#
# Parametres d'entree :
#
#_______________________________________________________________________________
# Creation :
# EGR     18/08/03
#
# Modification :
# --------------
# Auteur  Date       Objet
#ABA      23/06/2008    ajout des scripts de log
################################################################################

autoload $(ls $FPATH)

LOG_TRAITEMENT=$DIR_BATCH_SHELL_LOG/$(date +"%Y%m%d").purge_M.log
export LOG_TRAITEMENT

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "`basename $0` : fichier de trace : $LOG_TRAITEMENT"

logText "--------------------------------------------------------------------------------" > $LOG_TRAITEMENT
logText "-- $(date +"%Y%m%d") Debut de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT

######   etape 1 : purge_M_reports_batch  ################################################
logText "-- Lancement de purge_M_reports_batch.sh ----------------------------------------" >> $LOG_TRAITEMENT
DELAI=12
$DIR_BATCH_SHELL/purge_M_reports_batch.sh $DELAI
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		varlog="Echec lors du traitement purge_M_reports_batch.sh"
		sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('purge_M.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
        logText "Echec lors de l execution du traitement purge_M_reports_batch"
        logText "arrêt du batch `basename $0`"
        unset LOG_TRAITEMENT
        exit 1;
fi

# Fin du batch de purge_M
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('purge_M.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
logText "-- Fin Normale de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
unset LOG_TRAITEMENT

exit 0