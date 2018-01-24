#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : export_immo_def.sh
# Objet : 
#       ce script permet l'export des immobilisations définitives
#       BIP -> EXPENSE
#_______________________________________________________________________________
# Creation : Equipe BIP (ABA)  12/09/2008
#_______________________________________________________________________________
# Modification :
# --------------
# Auteur        Date            Objet
# 
# ---------------------------------------------------------------------------
################################################################################

autoload $(ls $FPATH)
			
if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.export_immo_def.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.export_immo_deftmp.txt   

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`
echo $LOG_FILE
logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut l'export des immos definitives : export_immo_def.sh" >> $LOG_FILE

############################# APPEL  export_immo_def  #####################################
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_IMMO.EXPORT_IMMO_DEF" 	
logText "SQLPLUS Exec PACK_IMMO.EXPORT_IMMO_DEF" >> $LOG_FILE		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACK_IMMO.EXPORT_IMMO_DEF('$PL_LOGS','$PL_EMISSION','$EXP_IMMO_DEF');
!


#valeur de sortie de SQL*PLUS								
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then	
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('export_immo_def.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,null, 'NOK');
EOF
	logText  "Problème script export_immo_def.sh : Appel procédure SQL*PLUS : PACK_IMMO.EXPORT_IMMO_DEF "	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script export_immo_def.sh : Appel procédure SQL*PLUS : PACK_IMMO.EXPORT_IMMO_DEF " >> $LOG_FILE								
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_IMMO.EXPORT_IMMO_DEF : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de l'export immo definitive: export_immo_def.sh ===" >> $LOG_FILE
	rm -f $log_tmp
	exit -1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	echo $CONNECT_STRING
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('export_immo_def.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	logText "Fin NORMALE de l'export immo definitive: export_immo_def.sh ===" >> $LOG_FILE
	rm -f $log_tmp
fi		
############################# /  APPEL  export_immo_defp   #####################################

exit 0;

