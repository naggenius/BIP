#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : controle_ca.sh
# Objet : Shell batch controle_ca
#	  Shell d'alimentation de la table TMP_CONTROLE_CA pour le controle des CA et FI.
#	  
#
#_______________________________________________________________________________
# Creation : BSA 06/06/2011
# Modification :
# --------------
# Auteur  Date       Objet
# 
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.controle_ca.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.controle_catmp.txt

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de controle_ca (`basename $0`)"
logText "Debut de controle_ca (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	!echo "pack_controle_ca.controle_ca"
	execute pack_controle_ca.controle_ca;
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
	insert into BATCH_LOGS_BIP values ('controle_ca.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	
	logText "Problème SQL*PLUS dans batch controle_ca : consulter $LOG_FILE"
	logText "et le fichier  $DIR_BATCH_SHELL_LOG/AAAA.MM.JJ.controle_ca.log  du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
	
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('controle_ca.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	#Fin YNI
	rm -f $log_tmp
	
	logText "=== Fin NORMALE de CONTROLE_CA : controle_ca.sh ==="
	logText "=== Fin NORMALE de CONTROLE_CA : controle_ca.sh ===" >> $LOG_FILE	
fi

exit 0
