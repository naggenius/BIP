#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : synthese_activite_mensuel.sh
# Objet : 
#       ce script permet de copier la table synthèse_activité dans synthèse_activité_mensuel apres chaque mensuelle
#_______________________________________________________________________________
# Creation : Equipe BIP (ABA)  05/04/2008
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
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.synthese_activite_mensuel.log
		     
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.synthese_activite_mensueltmp.txt   

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`


logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de la copie synthese_activite vers synthese_activite_mensuel:  synthese_activite_mensuel.sh" >> $LOG_FILE

##################################################################
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)

#FAD PPM 64010 : Suppression du DROP/CREATE et remplacement par TRUNCATE/INSERT
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	TRUNCATE TABLE SYNTHESE_ACTIVITE_MENSUEL;
	INSERT INTO SYNTHESE_ACTIVITE_MENSUEL SELECT * FROM SYNTHESE_ACTIVITE;
	COMMIT;
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
	insert into BATCH_LOGS_BIP values ('synthese_activite_mensuel.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,null, 'NOK');
EOF
	logText  "Problème script synthese_activite_mensuel.sh"	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script synthese_activite_mensuel.sh"	 >> $LOG_FILE								
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de la copie : synthese_activite_mensuel.sh ===" >> $LOG_FILE
	rm -f $log_tmp
	exit -1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('synthese_activite_mensuel.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0,'OK');
EOF
	logText "Fin NORMALE de la copie : synthese_activite_mensuel.sh ===" >> $LOG_FILE
	rm -f $log_tmp
fi		
#################################################################

exit 0;

