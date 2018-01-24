#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : audit_immo.sh
# Objet : 
#       ce script permet d'alimenter la table audit_immo
#_______________________________________________________________________________
# Creation : Equipe BIP (ABA)  13/11/2008
#_______________________________________________________________________________
# Modification :
# --------------
# Auteur        Date            Objet
# YNI     		21/01/2010    	Ajout traitement pour ecriture dans quotidienne.txt
# ---------------------------------------------------------------------------
################################################################################

autoload $(ls $FPATH)

#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI
	
if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.audit_immo.log
		     
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.audit_immotmp.txt   

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`


logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut du shell audit_immo.sh" >> $LOG_FILE

############################# APPEL alim_audit_immo  #####################################
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_AUDIT_IMMO.ALIM_AUDIT_IMMO" 	
logText "SQLPLUS Exec PACK_AUDIT_IMMO.ALIM_AUDIT_IMMO" >> $LOG_FILE		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACK_AUDIT_IMMO.ALIM_AUDIT_IMMO;
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
	insert into BATCH_LOGS_BIP values ('audit_immo.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,null, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " audit_immo.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText  "Problème script audit_immo.sh : Appel procédure SQL*PLUS : PACK_AUDIT_IMMO.ALIM_AUDIT_IMMO "	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script audit_immo.sh  : Appel procédure SQL*PLUS : PACK_AUDIT_IMMO.ALIM_AUDIT_IMMO " >> $LOG_FILE								
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_AUDIT_IMMO.ALIM_AUDIT_IMMO : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE du shell audit_immo.sh ===" >> $LOG_FILE
	rm -f $log_tmp
	exit -1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('audit_immo.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,null,null, 'OK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " audit_immo.sh OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Fin NORMALE  du shell audit_immo.sh  ===" >> $LOG_FILE
	rm -f $log_tmp
fi		
############################# /  APPEL  alim_audit_immo    #####################################

exit 0;

