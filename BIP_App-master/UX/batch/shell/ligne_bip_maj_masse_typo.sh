#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier :ligne_bip_maj_masse_typo.sh
# Objet : maj en masse de ligne bip
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
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.ligne_bip_maj_masse_typo.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.ligne_bip_maj_masse_typotmp.txt
statuttmp=0
	
datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

FILE_IMPORT_RESS=$DIR_BATCH_DATA/$FILE_MAJ_MASSE_TYPO    
dos2unix -c ascii -n $FILE_IMPORT_RESS $FILE_IMPORT_RESS

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de la maj en masse de ligne bip : ligne_bip_maj_masse_typo.sh" >> $LOG_FILE

logText "--  Verification de la presence du fichier"
logText "--  Verification de la presence du fichier" >> $LOG_FILE

# Test de l'existence du fichier ????????????.csv
# ################################################

logText "SQL*Load des lignes en masse"
logText "SQL*Load des lignes en masse" >> $LOG_FILE

LOGLOAD_FILE=$LOG_FILE
BAD_FILE=$LOG_FILE.1.bad
DSC_FILE=$LOG_FILE.1.dsc
LOGLOAD_FILE=$LOG_FILE.1.logload


# Chargement des budgets dans la table temporaire
# ################################################
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/Ligne_bip_maj_masse_typo.par \
	control=$DIR_SQLLOADER_PARAM/Ligne_bip_maj_masse_typo.ctl \
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
	echo "Erreur de chargement des ressources en masse SQL*Loader" >> $log_tmp
	logText "Erreur de chargement des ressources en masse SQL*Loader" >> $LOG_FILE
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
    
fi
logText "SQL*Load des ressources en masse Termine"
logText "SQL*Load des ressources en masse Termine" >> $LOG_FILE


logText "SQLPLUS Exec pack_ligne_bip_maj_masse_typo.maj_masse_ligne_bip" 	
logText "SQLPLUS Exec pack_ligne_bip_maj_masse_typo.maj_masse_ligne_bip" >> $LOG_FILE		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute pack_ligne_bip_maj_masse.maj_masse_ligne_bip_typo;
!

PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then	
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('ligne_bip_maj_masse_typo.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,null, 'NOK');
EOF
	logText  "Problème script ligne_bip_maj_masse_typo.sh : Appel procédure SQL*PLUS : pack_ligne_bip_maj_masse.maj_masse_ligne_bip_typo "	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script ligne_bip_maj_masse_typo.sh : Appel procédure SQL*PLUS : pack_ligne_bip_maj_masse.maj_masse_ligne_bip_typo " >> $LOG_FILE								
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  pack_ligne_bip_maj_masse.maj_masse_ligne_bip_typo : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de la maj en masse de ligne : ligne_bip_maj_masse_typo.sh ===" >> $LOG_FILE
	rm -f $log_tmp
	exit -1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	nom_fichier=$REP_EXTRACT/$nom_fic
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('ligne_bip_maj_masse_typo.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,null, 'OK');
EOF
	logText "Fin NORMALE de la maj en masse de ligne : ligne_bip_maj_masse_typo.sh ===" >> $LOG_FILE
	rm -f $log_tmp
fi		
############################# /  FIN APPEL    #####################################

exit 0;




