#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : BIP_DivaDem.sh
# Objet : Ce script lance les procedures PL/SQL de flux des budgets et consommés, émis par la BIP 
#_______________________________________________________________________________
# Creation : Equipe STERIA  19/08/2015
#_______________________________________________________________________________
# ---------------------------------------------------------------------------
################################################################################


#Répertoire d'extraction : BIPDATA
REP_EXTRACT=$ORA_LIVE_UTL_EXTRACTION
EXP_DMPDIVA_TMP=TEMP.PRET
EMISSION=$HOME_BIP/emission
if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.BIP_DivaDem.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi


log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.BIP_DivaDem.txt

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`
statuttmp=0

############################# EXTRACTION DES DPG #############################
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_DIVA.SELECT_EXPORT_DMP"
logText "SQLPLUS Exec PACK_DIVA.SELECT_EXPORT_DMP" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF
	whenever sqlerror exit failure;
	!echo "exec pack_diva.SELECT_EXPORT_DMP"
	execute pack_diva.SELECT_EXPORT_DMP('$PL_EMISSION', '$EXP_DMPDIVA');
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
	insert into BATCH_LOGS_BIP values ('BIP_DivaDem.sh(exp_DmpDiva)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_DIVA.SELECT_EXPORT_DMP : consulter $LOG_FILE"
	logText "Consulter le fichier $ORA_LIVE_UTL_BATCH_LOG/AAAA.MM.JJ.exp_DMP_DIVA.log du jour"
	logText "Code erreur : <$PLUS_EXIT>"
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_DIVA.SELECT_EXPORT_DMP" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE

	exit -1;
else

logText "Fin NORMALE de l'export DMP DIVA : BIP_DivaDem.sh ===" >> $LOG_FILE
rm -f $log_tmp
fi

exit 0
