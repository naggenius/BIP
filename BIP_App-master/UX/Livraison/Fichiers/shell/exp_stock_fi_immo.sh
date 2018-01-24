#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : exp_stock_fi_immo.sh
# Objet : Ce script lance les procedures PL/SQL de generation du fichier
# 	  d'export du stock FI et IMMO
#_______________________________________________________________________________
# Creation : Equipe STERIA  27/04/2013
#_______________________________________________________________________________
# ---------------------------------------------------------------------------
################################################################################

#################################################
# On charge l'environnement
#################################################
. $APP_ETC/bipparam.sh
#################################################

#Répertoire d'extraction : BIPDATA
REP_EXTRACT=$ORA_LIVE_UTL_EXTRACTION
			
				
if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.stock_FI_IMMO.log        
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi


log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.stock_FI_IMMO.txt

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`


############################# EXTRACTION DU STOCK FI #############################
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_EXPORT_STOCK.select_export_stock_FI"
logText "SQLPLUS Exec PACK_EXPORT_STOCK.select_export_stock_FI" >> $LOG_FILE
sqlplus -s $ORA_USR_LIVE@$ORA_LIVE <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACK_EXPORT_STOCK.select_export_stock_FI('$BIP_DATA', '$STOCK_FI');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $ORA_USR_LIVE@$ORA_LIVE << EOF
	insert into BATCH_LOGS_BIP values ('exp_stock_fi_immo.sh(stock_fi)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_EXPORT_STOCK.select_export_stock_FI : consulter $LOG_FILE"
	logText "Consulter le fichier $ORA_LIVE_UTL_BATCH_LOG/AAAA.MM.JJ.stock_FI_IMMO.log du jour"
	logText "Code erreur : <$PLUS_EXIT>"
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_EXPORT_STOCK.select_export_stock_FI" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	rm -f $log_tmp
	logText "=== ERREUR : Fin ANORMALE de l'export Stock_FI : exp_stock_fi_immo.sh ===" >> $LOG_FILE
	exit -1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $ORA_USR_LIVE@$ORA_LIVE << EOF
	insert into BATCH_LOGS_BIP values ('exp_stock_fi_immo.sh(stock_fi)','datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	logText "Fin NORMALE de l'export Stock_FI : exp_stock_fi_immo.sh ===" >> $LOG_FILE
	rm -f $log_tmp
fi

############################# EXTRACTION DU STOCK IMMO #############################
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_EXPORT_STOCK.select_export_stock_immo"
logText "SQLPLUS Exec PACK_EXPORT_STOCK.select_export_stock_immo" >> $LOG_FILE
sqlplus -s $ORA_USR_LIVE@$ORA_LIVE <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACK_EXPORT_STOCK.select_export_stock_immo('$BIP_DATA', '$STOCK_IMMO');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $ORA_USR_LIVE@$ORA_LIVE << EOF
	insert into BATCH_LOGS_BIP values ('exp_stock_fi_immo.sh(stock_immo)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_EXPORT_STOCK.select_export_stock_immo : consulter $LOG_FILE"
	logText "Consulter le fichier $ORA_LIVE_UTL_BATCH_LOG/AAAA.MM.JJ.stock_FI_IMMO.log du jour"
	logText "Code erreur : <$PLUS_EXIT>"
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_EXPORT_STOCK.select_export_stock_immo" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	rm -f $log_tmp
	logText "=== ERREUR : Fin ANORMALE de l'export Stock_immo : exp_stock_fi_immo.sh ===" >> $LOG_FILE
	exit -1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $ORA_USR_LIVE@$ORA_LIVE << EOF
	insert into BATCH_LOGS_BIP values ('exp_stock_fi_immo.sh(stock_immo)','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	logText "Fin NORMALE de l'export Stock_immo : exp_stock_fi_immo.sh ===" >> $LOG_FILE
	rm -f $log_tmp
fi


mv $BIP_DATA/$STOCK_IMMO $EMISSION
mv $BIP_DATA/$STOCK_FI $EMISSION
./tom_envoi.sh $STOCK_IMMO
./tom_envoi.sh $STOCK_FI

exit O

