#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : import_ress_mass.sh
# Objet : Importation en masse des ressources ainsi que leurs situation respectives
#
# Parametres d'entree:
#	$1	Fichier log (facultatif)
#_______________________________________________________________________________
# Creation     : Antoine BABOEUF (09/06/2009)
#_______________________________________________________________________________
# Modification : 
################################################################################

autoload $(ls $FPATH)

# Fichier log
# ############

	if [ -z $LOG_TRAITEMENT ]
	then
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.insert_ress_masse.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.insert_ress_massetmp.txt
statuttmp=0
	
datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "SQLPLUS Exec PACK_RESS_SITU_MASSE.INSERT_RESSOURCE" 	
logText "Debut SQLPLUS Exec PACK_RESS_SITU_MASSE.INSERT_RESSOURCE" >> $LOG_FILE
echo "SQLPLUS Exec PACK_RESS_SITU_MASSE.INSERT_RESSOURCE" > $log_tmp		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACK_RESS_SITU_MASSE.INSERT_RESSOURCE;
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
	insert into BATCH_LOGS_BIP values ('insert_ress_masse.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText  "Problème script import_ress_masse.sh : Appel procédure SQL*PLUS : PACK_RESS_SITU_MASSE.INSERT_RESSOURCE "	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script import_ress_masse.sh : Appel procédure SQL*PLUS : PACK_RESS_SITU_MASSE.INSERT_RESSOURCE " >> $LOG_FILE								
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_RESS_SITU_MASSE.INSERT_RESSOURCE : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de l'import des ressources en masse : insert_ress_masse.sh ===" >> $LOG_FILE
	rm -f $log_tmp
else
	logText "Fin SQLPLUS Exec PACK_RESS_SITU_MASSE.INSERT_RESSOURCE" >> $LOG_FILE
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	nom_fichier=$REP_EXTRACT/$nom_fic
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('insert_ress_masse.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	rm -f $log_tmp
	logText "=== Fin NORMALE de l'import des ressources en masse : insert_ress_masse.sh ===" >> $LOG_FILE
					
fi
