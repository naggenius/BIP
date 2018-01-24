#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : exp_DPG_MEGA.sh
# Objet : Ce script lance les procedures PL/SQL de generation du fichier
# 	  d'export des DPG
#_______________________________________________________________________________
# Creation : Equipe STERIA  13/05/2013
#_______________________________________________________________________________
# ---------------------------------------------------------------------------
################################################################################


#Répertoire d'extraction : BIPDATA
REP_EXTRACT=$ORA_LIVE_UTL_EXTRACTION
			
				
if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.exp_DPG_MEGA.log        
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi


log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.exp_DPG_MEGA.txt

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`
statuttmp=0

############################# EXTRACTION DES DPG #############################
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_MEGA.SELECT_EXPORT_DPG"
logText "SQLPLUS Exec PACK_MEGA.SELECT_EXPORT_DPG" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACK_MEGA.select_export_DPG('$PL_EMISSION', '$EXP_MEGA');
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
	insert into BATCH_LOGS_BIP values ('exp_DPG_MEGA.sh(exp_mega)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_MEGA.select_export_DPG : consulter $LOG_FILE"
	logText "Consulter le fichier $ORA_LIVE_UTL_BATCH_LOG/AAAA.MM.JJ.exp_DPG_MEGA.log du jour"
	logText "Code erreur : <$PLUS_EXIT>"
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_MEGA.select_export_DPG" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	
	exit -1;
else
	# si le fichier a bien été généré on effectue l'envoi TOM
	
	$DIR_BATCH_SHELL/tom_envoi.sh $EXP_MEGA
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
		then
			datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		varlog=$CMD_EXIT
		cat $log_tmp >> $LOG_FILE 2>&1
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('exp_DPG_MEGA.sh(exp_mega)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
			logText "Echec du transfert TOM : Code erreur : <$CMD_EXIT>" >> $LOG_FILE
			rm -f $log_tmp
			logText "=== ERREUR : Fin ANORMALE de l'export Mega : exp_DPG_MEGA.sh ===" >> $LOG_FILE
		exit -1;
		else
			datefin=`date +'%d/%m/%Y'`
			heurefin=`date +'%T'`
			cat $log_tmp >> $LOG_FILE 2>&1
			sqlplus -s $CONNECT_STRING << EOF
			insert into BATCH_LOGS_BIP values ('exp_DPG_MEGA.sh(exp_mega)','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	logText "Fin NORMALE de l'export DPG MEGA : exp_DPG_MEGA.sh ===" >> $LOG_FILE
	rm -f $log_tmp
	fi
	

fi

exit O


