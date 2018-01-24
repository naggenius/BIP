#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : proj_bip_expens.sh
# Objet : Ce script lance les procedures PL/SQL de flux des projets BIP, à ExpenseBis.
#_______________________________________________________________________________
# Creation : Equipe STERIA  17/03/2016
#_______________________________________________________________________________
# ---------------------------------------------------------------------------
################################################################################


if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.proj_bip_expens.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi


log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.proj_bip_expens.txt

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`
statuttmp=0

############################# EXTRACTION DES DPG #############################
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_PROJ_INFO.SELECT_EXPORT_EXPENSE"
logText "SQLPLUS Exec PACK_PROJ_INFO.SELECT_EXPORT_EXPENSE" >> $LOG_FILE
sqlplus -s $CONNECT_STRING  <<EOF >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	!echo "exec PACK_PROJ_INFO.SELECT_EXPORT_EXPENSE"
	execute PACK_PROJ_INFO.SELECT_EXPORT_EXPENSE('$PL_EMISSION', '$EXP_PROJ_EXPENSE');
EOF

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	#FAD QC 1889
	#insert into BATCH_LOGS_BIP values ('proj_bip_expens.sh(exp_proj_expense)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('proj_bip_expens.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_PROJ_INFO.SELECT_EXPORT_EXPENSE : consulter $LOG_FILE"
	logText "Consulter le fichier $ORA_LIVE_UTL_BATCH_LOG/AAAA.MM.JJ.proj_bip_expens.log du jour"
	logText "Code erreur : <$PLUS_EXIT>"
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_PROJ_INFO.SELECT_EXPORT_EXPENSE" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
else
	# si le fichier a bien été généré on effectue l'envoi TOM

	$DIR_BATCH_SHELL/tom_envoi.sh $EXP_PROJ_EXPENSE
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
	then
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		varlog=$CMD_EXIT
		cat $log_tmp >> $LOG_FILE 2>&1
		#FAD QC 1889
		#insert into BATCH_LOGS_BIP values ('proj_bip_expens.sh(EXP_DMPDIVA)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('proj_bip_expens.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
		logText "Echec du transfert TOM : Code erreur : <$CMD_EXIT>" 
		logText "Echec du transfert TOM : Code erreur : <$CMD_EXIT>" >> $LOG_FILE
		rm -f $log_tmp
		logText "=== ERREUR : Fin ANORMALE de l'export Projet ExpenseBIS : proj_bip_expens.sh ===" 
		logText "=== ERREUR : Fin ANORMALE de l'export Projet ExpenseBIS : proj_bip_expens.sh ===" >> $LOG_FILE

		exit -1;
	else
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		cat $log_tmp >> $LOG_FILE 2>&1
		#FAD QC 1889
		#insert into BATCH_LOGS_BIP values ('proj_bip_expens.sh(EXP_DMPDIVA)','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('proj_bip_expens.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF

		logText "Fin NORMALE de l'export Projet ExpenseBIS : proj_bip_expens.sh ==="
		logText "Fin NORMALE de l'export Projet ExpenseBIS : proj_bip_expens.sh ===" >> $LOG_FILE
	fi
	rm -f $log_tmp
fi

exit 0
