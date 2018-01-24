#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier :ressources_prepa_recyclage.sh
# Objet : préparation de recyclage de ressources
#
# Parametres d'entree:
#	$1	Fichier log (facultatif)
#_______________________________________________________________________________
# Creation     : RBO (28/05/2013)
#_______________________________________________________________________________
################################################################################

# PARAMETRE ENTREE
id_batch=$1

if test $# -ne 1; then
	echo
	echo "Le script nécessite 1 paramètres"
	echo "  1 : Id du batch d execution ( TRAIT_BATCH )"
	exit 1
fi

autoload $(ls $FPATH)

# Fichier log
# ############

	if [ -z $LOG_TRAITEMENT ]
	then
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.ressources_prepa_recyclage.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.ressources_prepa_recyclagetmp.txt
statuttmp=0
	
datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

FILE_IMPORT_RESS=$DIR_BATCH_DATA/ressources_prepa_recyclage.csv  
dos2unix -c ascii -n $FILE_IMPORT_RESS $FILE_IMPORT_RESS

logText "DEBUT CR du batch de preparation de recyclage de ressources" >> $LOG_FILE

logText "--  Verification de la presence du fichier" >> $LOG_FILE

# Test de l'existence du fichier ????????????.csv
# ################################################

logText "SQL*Load des ressources"
logText "SQL*Load des ressources" >> $LOG_FILE

LOGLOAD_FILE=$LOG_FILE
BAD_FILE=$LOG_FILE.1.bad
DSC_FILE=$LOG_FILE.1.dsc
LOGLOAD_FILE=$LOG_FILE.1.logload
FILE_RESSOURCES_PREPA=`date +"%Y%m%d"`.ressources_prepa_recyclage.log

# Chargement des ressources dans la table temporaire
# ################################################
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/Ressources_prepa_recyclage.par \
	control=$DIR_SQLLOADER_PARAM/Ressources_prepa_recyclage.ctl \
	data=$FILE_IMPORT_RESS \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	skip=1 \
	discard=$DSC_FILE >> $LOG_FILE 2>&1 \
	
# Valeur de sortie de SQL*LOAD
# #############################

LOAD_EXIT=$?
# si le loader retourne 0 ou 2, il faut verifier qu'il n'y a pas de codes erreurs 
# dans le fichier de log
if [ $LOAD_EXIT -ne 0 ]
then
	statuttmp=1
	logText "Erreur : consulter $LOG_FILE"
	echo "Erreur de chargement des ressources SQL*Loader" >> $log_tmp
	logText "Erreur de chargement des ressources SQL*Loader" >> $LOG_FILE
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
    
fi
logText "SQL*Load des ressources Termine"
logText "SQL*Load des ressources Termine" >> $LOG_FILE

logText "SQLPLUS Exec PACK_RESSOURCE_P.update_ress_prepa_recyclage" 	
logText "SQLPLUS Exec PACK_RESSOURCE_P.update_ress_prepa_recyclage" >> $LOG_FILE		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACK_RESSOURCE_P.update_ress_prepa_recyclage ('$PL_LOGS','$FILE_RESSOURCES_PREPA','$id_batch');
!


############################# /  RENOMMAGE DU FICHIER PPM 59359  #####################################

mv $DIR_BATCH_DATA/ressources_prepa_recyclage.csv $DIR_BATCH_DATA/$(date +"%Y%m%d_%HH%M").ressources_prepa_recyclage.csv

#############################################################################################################################

PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then	
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('ressources_prepa_recyclage.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,null, 'NOK');
EOF
	sqlplus -s $CONNECT_STRING << EOF
	UPDATE TRAIT_BATCH SET TOP_ANO='O' WHERE ID_TRAIT_BATCH = $id_batch;
	commit;
EOF
	logText  "Problème script ressources_prepa_recyclage.sh : Appel procédure SQL*PLUS : PACK_RESSOURCE_P.update_ress_prepa_recyclage "	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script ressources_prepa_recyclage.sh : Appel procédure SQL*PLUS : PACK_RESSOURCE_P.update_ress_prepa_recyclage " >> $LOG_FILE								
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_RESSOURCE_P.update_ress_prepa_recyclage : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : FIN ANORMALE CR du batch de preparation de recyclage de ressources ===" >> $LOG_FILE
	rm -f $log_tmp
	exit -1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	nom_fichier=$REP_EXTRACT/$nom_fic
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('ressources_prepa_recyclage.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,null, 'OK');
EOF
	logText "FIN CR du batch de preparation de recyclage de ressources ===" >> $LOG_FILE
	rm -f $log_tmp
fi

  # ecriture des donnees bad dans la table de retour du trait batch
if [[ -f $BAD_FILE ]]
then
  cat $BAD_FILE |while read ligne
  do
	sqlplus -s $CONNECT_STRING << EOF
	insert into TRAIT_BATCH_RETOUR (ID_TRAIT_BATCH, DATA, ERREUR) VALUES ($id_batch,'$ligne','Ressource non traitee, suite format incorrect');
	commit;
EOF
	sqlplus -s $CONNECT_STRING << EOF
	UPDATE TRAIT_BATCH SET TOP_RETOUR = 'O', TOP_ANO='O' WHERE ID_TRAIT_BATCH = $id_batch;
	commit;
EOF

done
fi


		
############################# /  APPEL  EXPORT_realises_bip   #####################################

exit 0;
