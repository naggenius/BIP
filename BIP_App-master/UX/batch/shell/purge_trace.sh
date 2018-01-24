#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : purge_trace.sh
# Objet : Shell batch purge_trace
#	  Shell de purge de la table NAVIGATION_USER.
#	  
#
#_______________________________________________________________________________
# Creation : BSA 28/10/2011
# Modification :
# --------------
# Auteur  Date       Objet
# 
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.purge_trace.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.purge_tracetmp.txt

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de purge_trace (`basename $0`)"
logText "Debut de purge_trace (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	!echo "USER_TRACE.PURGE"
	execute USER_TRACE.PURGE;
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
	insert into BATCH_LOGS_BIP values ('purge_trace.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	
	logText "Problème SQL*PLUS dans batch purge_trace : consulter $LOG_FILE"
	logText "et le fichier  $DIR_BATCH_SHELL_LOG/AAAA.MM.JJ.purge_trace.log  du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
	
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('purge_trace.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	#Fin YNI
	rm -f $log_tmp
	
	logText "=== Fin NORMALE de purge_trace : purge_trace.sh ==="
	logText "=== Fin NORMALE de purge_trace : purge_trace.sh ===" >> $LOG_FILE	
fi

exit 0
