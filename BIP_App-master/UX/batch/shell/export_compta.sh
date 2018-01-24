#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : export_compta.sh
# Objet : 
#       ce script recupere lance la procedure PL/SQL de generation des fichiers
#       d'export compta 
#
#_______________________________________________________________________________
# Creation : Equipe BIP (OTO)  22/09/2003 
# Modification :
# --------------
# Auteur        Date            Objet
#ABA       01/04/2008    Ajout traitement pour affichage des logs via l'ihm bip
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`_`date +"%H"`H`date +"%M%S"`.export_compta.log
		rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

#création du fichier temporaire de log
log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.export_comptatmp.txt

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de export compta : export_compta.sh" >> $LOG_FILE

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
        whenever sqlerror exit failure;
        !echo "execute pack_export_comptable.select_export_comptable"
        execute pack_export_comptable.select_export_comptable('$PL_EMISSION');
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
	insert into BATCH_LOGS_BIP values ('export_compta.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
        logText "Problème SQL*PLUS dans batch export_comptable : consulter $LOG_FILE"
        logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
		logText "=== ERREUR : Fin ANORMALE de export compta : export_compta.sh ===" >> $LOG_FILE
		rm -f $log_tmp
        exit -1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('export_compta.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	rm -f $log_tmp
	logText "=== Fin NORMALE de export comtpa : export_compta.sh ===" >> $LOG_FILE
fi

exit O

