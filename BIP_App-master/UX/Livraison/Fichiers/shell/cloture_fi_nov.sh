#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : cloture_fi_nov.sh
# Objet : 
#       ce script lance la procedure PL/SQL de sauvegarde du STOCK_FI de l'année fiscale.
#	dans la table HISTO_STOCK_FI après la mensuelle de novembre.
#_______________________________________________________________________________
# Creation : PJO  23/11/2004
# Modification :
# --------------
# Auteur        Date            Objet
#ABA        13/11/2008    Log IHM du shell
################################################################################

autoload $(ls $FPATH)
if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.cloture_fi_nov.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.cloture_fi_novtmp.txt   

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`


logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de cloture_fi_nov (`basename $0`)"
logText "Debut de cloture_fi_nov (`basename $0`)" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
        whenever sqlerror exit failure;
        execute pack_batch_histo_cloture.cloture_fi_nov('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
		cat $log_tmp >> $LOG_FILE 2>&1
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('cloture_fi_nov.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,null, 'NOK');
EOF
        logText "Problème SQL*PLUS dans batch Clôture FI Novembre pack_batch_histo_cloture.cloture_fi_nov : consulter $LOG_FILE"
        logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
		logText "=== ERREUR : Fin ANORMALE du shell cloture_fi_nov.sh ===" >> $LOG_FILE
		rm -f $log_tmp
        exit -1;

else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('cloture_fi_nov.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,null,null, 'OK');
EOF
	logText "=== Fin NORMALE du shell cloture_fi_nov.sh  ===" >> $LOG_FILE
	rm -f $log_tmp
fi
	
exit O;

