#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : adonix_export_realise.sh
# Objet : 
#       ce script recupere lance la procedure PL/SQL de generation des fichiers
#       d'export des realises bip pour le flux bip -> adonix
#_______________________________________________________________________________
# Creation : Equipe BIP (ABA)  11/02/2008
#_______________________________________________________________________________
# Modification :
# --------------
# Auteur        Date            Objet
# 
# ---------------------------------------------------------------------------
################################################################################

autoload $(ls $FPATH)

#Répertoire d'extraction : BIPDATA/adonix/export_conso
REP_EXTRACT=$ADONIX_REP
nom_fic=$ADONIX_FIC
				
				
if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.BIP_Adonix_Conso.log
		     
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.BIP_Adonix_Consotmp.txt   

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`


logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut l'export des réalisés adonix : adonix_export_realises.sh" >> $LOG_FILE

############################# APPEL  EXPORT_realises_bip  #####################################
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_ADONIX.EXPORT_REALISES_BIP".$REP_EXTRACT 	
logText "SQLPLUS Exec PACK_ADONIX.EXPORT_REALISES_BIP" >> $LOG_FILE		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACK_ADONIX.EXPORT_REALISES_BIP('$PL_DATA','$nom_fic');
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
	insert into BATCH_LOGS_BIP values ('adonix_export_realises.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,null, 'NOK');
EOF
	logText  "Problème script adonix_export_realises.sh : Appel procédure SQL*PLUS : PACK_ADONIX.EXPORT_REALISES_BIP "	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script adonix_export_realises.sh : Appel procédure SQL*PLUS : PACK_ADONIX.EXPORT_REALISES_BIP " >> $LOG_FILE								
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_ADONIX.EXPORT_REALISES_BIP : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de l'export réalisés adonix: adonix_export_realisés.sh ===" >> $LOG_FILE
	rm -f $log_tmp
	exit -1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	nom_fichier=$REP_EXTRACT/$nom_fic
	nbligne=`awk 'END {print NR}' $nom_fichier`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('adonix_export_realises.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,'$nbligne',null, 'OK');
EOF
	logText "Fin NORMALE de l'export réalisés adonix: adonix_export_realisés.sh ===" >> $LOG_FILE
	rm -f $log_tmp
fi		
############################# /  APPEL  EXPORT_realises_bip   #####################################

exit 0;

