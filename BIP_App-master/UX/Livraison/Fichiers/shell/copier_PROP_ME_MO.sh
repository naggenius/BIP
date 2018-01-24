#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : copier_PROP_ME_MO.sh
# Objet : Ce script lance les procedures PL/SQL de Copie Proposé Fournisseur dans le Proposé Client 
#_______________________________________________________________________________
# Creation : Equipe STERIA  16/11/2015 ZAA
#_______________________________________________________________________________
# ---------------------------------------------------------------------------
################################################################################



if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.copier_PROP_ME_MO.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi


log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.copier_PROP_ME_MO.txt

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`
statuttmp=0

#########################################################
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_DIVA.copiePropFRN_CLI"
logText "SQLPLUS Exec PACK_DIVA.copiePropFRN_CLI" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF
	whenever sqlerror exit failure;
	!echo "exec pack_diva.copiePropFRN_CLI"
	execute pack_diva.copiePropFRN_CLI;
EOF

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then

	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('copier_PROP_ME_MO.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_DIVA.copiePropFRN_CLI : consulter $LOG_FILE"
	logText "Consulter le fichier $ORA_LIVE_UTL_BATCH_LOG/AAAA.MM.JJ.exp_DMP_DIVA.log du jour"
	logText "Code erreur : <$PLUS_EXIT>"
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_DIVA.copiePropFRN_CLI" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE

	exit -1;
else
logText "Fin NORMALE de la copie Proposé Fournisseur dans le Proposé Client : copier_PROP_ME_MO.sh "
logText "Fin NORMALE de la copie Proposé Fournisseur dans le Proposé Client : copier_PROP_ME_MO.sh ===" >> $LOG_FILE
rm -f $log_tmp
fi

exit 0
