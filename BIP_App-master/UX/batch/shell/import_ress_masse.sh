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
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_ress_masse.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_ress_massetmp.txt
statuttmp=0
	
datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`


nom_fic=$nom_fic_rejet_ress_masse

FILE_IMPORT_RESS=$FILE_IMPORT_RESS   

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'import en masse des ressources : import_ress_mass.sh" >> $LOG_FILE

logText "--  Verification de la presence du fichier"
logText "--  Verification de la presence du fichier" >> $LOG_FILE

# Test de l'existence du fichier ????????????.csv
# ################################################

logText "SQL*Load des ressources en masse"
logText "SQL*Load des ressources en masse" >> $LOG_FILE

LOGLOAD_FILE=$LOG_FILE
BAD_FILE=$LOG_FILE.1.bad
DSC_FILE=$LOG_FILE.1.dsc
LOGLOAD_FILE=$LOG_FILE.1.logload


# Chargement des budgets dans la table temporaire
# ################################################
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/eRess_masse.par \
	control=$DIR_SQLLOADER_PARAM/eRess_masse.ctl \
	data=$FILE_IMPORT_RESS \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	discard=$DSC_FILE >> $LOG_FILE 2>&1 \
	skip=1 >> $LOG_FILE 2>&1

# Valeur de sortie de SQL*LOAD
# #############################


LOAD_EXIT=$?
# si le loader retourne 0 ou 2, il faut verifier qu'il n'y a pas de codes erreurs 
# dans le fichier de log
if [ $LOAD_EXIT -ne 0 ]
then
	statuttmp=1
	logText "Erreur : consulter $LOG_FILE"
	echo "Erreur de chargement des ressources en masse SQL*Loader" >> $log_tmp
	logText "Erreur de chargement des ressources en masse SQL*Loader" >> $LOG_FILE
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
    
fi
logText "SQL*Load des ressources en masse Termine"
logText "SQL*Load des ressources en masse Termine" >> $LOG_FILE



logText "SQLPLUS Exec PACK_RESS_SITU_MASSE.TEST_RESSOURCE" 	
logText "Debut SQLPLUS Exec PACK_RESS_SITU_MASSE.TEST_RESSOURCE" >> $LOG_FILE
echo "SQLPLUS Exec PACK_RESS_SITU_MASSE.TEST_RESSOURCE" > $log_tmp		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACK_RESS_SITU_MASSE.TEST_RESSOURCE('$DIR_BATCH_SHELL_LOG','$nom_fic');
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
	insert into BATCH_LOGS_BIP values ('import_ress_masse.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText  "Problème script import_ress_masse.sh : Appel procédure SQL*PLUS : PACK_RESS_SITU_MASSE.TEST_RESSOURCE "	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script import_ress_masse.sh : Appel procédure SQL*PLUS : PACK_RESS_SITU_MASSE.TEST_RESSOURCE " >> $LOG_FILE								
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_RESS_SITU_MASSE.TEST_RESSOURCE : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de l'import des ressources en masse : import_ress_masse.sh ===" >> $LOG_FILE
	rm -f $log_tmp
else
	logText "Fin SQLPLUS Exec PACK_RESS_SITU_MASSE.TEST_RESSOURCE" >> $LOG_FILE
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	nom_fichier=$REP_EXTRACT/$nom_fic
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_ress_masse.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	rm -f $log_tmp
	logText "=== Fin NORMALE de l'import des ressources en masse : import_ress_masse.sh ===" >> $LOG_FILE
					
fi
