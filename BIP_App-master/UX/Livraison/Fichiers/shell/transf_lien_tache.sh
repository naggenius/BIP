#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier :transf_lien_tache.sh
# Object : This development consists of recovering the Catalogue line stock to
# position the DMP in the correct field and delete the old field used.
#
# Input parameters:
#	$1	Batch Id
#_______________________________________________________________________________
# Creation     : Bip Chennai Team
#_______________________________________________________________________________
# Modification : 
# 02/02/2017  Creation
################################################################################

autoload $(ls $FPATH)

# Input parameters
id_batch=$1

if test $# -ne 1; then
	echo
	echo "The script requires 1 parameters"
	echo "  Execution Batch Id (TRAIT_BATCH)"
	exit 1
fi


# Log file
# ############
LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.transf_lien_tache.log
logText "--------------------------------------------------------------------------------" >> $LOG_FILE
log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.transf_lien_tache.txt
statuttmp=0	
datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`


FILE_IMPORT_RESS=$DIR_BATCH_DATA/'transf_lien_tache.csv'

logText "log file <$FILE_IMPORT_RESS>" >> $LOG_FILE
dos2unix -c ascii -n $FILE_IMPORT_RESS $FILE_IMPORT_RESS

logText "converting in to unix from dos  " >> $LOG_FILE

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Begining of loading the file : transf_lien_tache.csv" >> $LOG_FILE

logText "--  verifying the file presence --"
logText "--  verifying the file presence --" >> $LOG_FILE

# Testing the file presence ????????????.csv
# ################################################

logText "--SQL*Load starts--"
logText "SQL*Load starts" >> $LOG_FILE

LOGLOAD_FILE=$LOG_FILE
BAD_FILE=$LOG_FILE.1.bad
DSC_FILE=$LOG_FILE.1.dsc
LOGLOAD_FILE=$LOG_FILE.1.logload


# Loading data in to temporary table
# ################################################
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/transf_lien_tache.par \
	control=$DIR_SQLLOADER_PARAM/transf_lien_tache.ctl \
	data=$FILE_IMPORT_RESS \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	skip=1 \
	discard=$DSC_FILE >> $LOG_FILE 2>&1 \
	
# Output value of SQL * LOAD
# #############################

LOAD_EXIT=$?
logText "-----------------LOAD-EXIT------------<$LOAD_EXIT>"
#If the loader returns 0 or 2, it must be checked that there are no error codes
# In the log file
if [ $LOAD_EXIT -ne 0 ]
then
	statuttmp=1
	logText "Error : to consult LOG_FILE"
       	logText "Error loading data in to temp tables (Link transformation)" >> $LOG_FILE
	logText "View the loader log file: $ LOGLOAD_FILE" >> $LOG_FILE
	logText "Code error : <$LOAD_EXIT>" >> $LOG_FILE
    
fi
logText " loading data in to temp tables(Link transformation) stops"
logText " loading data in to temp tables(Link transformation) stops	" >> $LOG_FILE

logText "SQLPLUS Exec PACK_LINK_TRANSFORMATION.sp_exp_recovery_process" 	
logText "SQLPLUS Exec PACK_LINK_TRANSFORMATION.sp_exp_recovery_process" >> $LOG_FILE		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute pack_link_transformation.sp_exp_recovery_process('$id_batch');
!

PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then	
	
	enddate=`date +'%d/%m/%Y'`
	hour=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('transf_lien_tache.sh','$datedebut', '$heuredebut','$enddate','$hour','$varlog',0,null, 'NOK');
EOF
	logText  "Problem in script transf_lien_tache.sh: Call procedure SQL*PLUS : PACK_LINK_TRANSFORMATION.sp_exp_recovery_process "	
	logText  "Code error : <$PLUS_EXIT>"
	logText  "Problem in script transf_lien_tache.sh: Call procedure SQL*PLUS : PACK_LINK_TRANSFORMATION.sp_exp_recovery_process" >> $LOG_FILE								
	logText "Problem in SQL*PLUS execution procedure  PACK_LINK_TRANSFORMATION.sp_exp_recovery_process : to consult $LOG_FILE"
	logText "Code error : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERROR : Fatal error and end of execution : transf_lien_tache.sh ===" >> $LOG_FILE
	rm -f $log_tmp
	exit -1;
else
	enddate=`date +'%d/%m/%Y'`
	hour=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	nom_fichier=$REP_EXTRACT/$nom_fic
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('ligne_bip_maj_masse.sh','$datedebut', '$heuredebut','$enddate','$hour',null,0,null, 'OK');
EOF

logText "NORMAL end of the script : transf_lien_tache.sh ===" >> $LOG_FILE
	rm -f $log_tmp
fi

 #Writing bad data in the return table of the batch line
if [[ -f $BAD_FILE ]]
then
  cat $BAD_FILE |while read ligne
  do
	sqlplus -s $CONNECT_STRING << EOF
	insert into TRAIT_BATCH_RETOUR (ID_TRAIT_BATCH, DATA, ERREUR) VALUES ($id_batch,SUBSTR('$ligne',1,4),'Untreated line, incorrect format suite');
	commit;
EOF
	sqlplus -s $CONNECT_STRING << EOF
	UPDATE TRAIT_BATCH SET TOP_RETOUR = 'O', TOP_ANO='O' ,DATE_SHELL = sysdate WHERE ID_TRAIT_BATCH = $id_batch;
	commit;
EOF

done
fi
		
############################# /  APPEL  EXPORT_realises_bip   #####################################

exit 0;


