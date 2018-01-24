#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets (BIP)
# Nom du fichier : alim_budget_ecart.sh
# Objet : Shell batch pour alimentation de la table budget_ecart 
#         a partir des tables BUDGET, CONSOMME & LIGNE_BIP
#_______________________________________________________________________________
# Creation :  DDI 24/03/2006
# Modification :
# --------------
# Auteur  Date       Objet
# SGARCIA 15012013  PPM 30735
#
################################################################################


autoload $(ls $FPATH)

# Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.ALIM_BUDGET_ECART.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.alim_budget_ecarttmp.txt   

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de ALIM_BUDGET_ECART (`basename $0`)"
logText "Debut de ALIM_BUDGET_ECART (`basename $0`)" >> $LOG_FILE

#####A MODIFIER############################

############################# APPEL alim_ALIM_BUDGET_ECART  #####################################
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACKBATCH_BUDGET_ECART.ALIM_BUDGET_ECART" 	
logText "SQLPLUS Exec PACKBATCH_BUDGET_ECART.ALIM_BUDGET_ECART" >> $LOG_FILE		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACKBATCH_BUDGET_ECART.ALIM_BUDGET_ECART('$PL_LOGS');
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
	insert into BATCH_LOGS_BIP values ('alim_budget_ecart.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,null, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " alim_budget_ecart.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText  "Problème script alim_budget_ecart.sh : Appel procédure SQL*PLUS : PACKBATCH_BUDGET_ECART.ALIM_BUDGET_ECART "	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script alim_budget_ecart  : Appel procédure SQL*PLUS : PACKBATCH_BUDGET_ECART.ALIM_BUDGET_ECART " >> $LOG_FILE								
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACKBATCH_BUDGET_ECART.ALIM_BUDGET_ECART : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE du shell alim_budget_ecart.sh ===" >> $LOG_FILE
	rm -f $log_tmp
	exit -1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('alim_budget_ecart.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,null,null, 'OK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " alim_budget_ecart.sh OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Fin NORMALE  du shell alim_budget_ecart.sh  ===" >> $LOG_FILE
	rm -f $log_tmp
fi		
############################# /  APPEL  alim_budget_ecart    #####################################

exit 0;


