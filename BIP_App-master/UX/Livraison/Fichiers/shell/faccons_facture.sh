
autoload $(ls $FPATH)

# Fichier log
# ############

	if [ -z $LOG_TRAITEMENT ]
	then
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.faccons_ressource.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.faccons_ressourcetmp.txt
statuttmp=0
	
datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

FILE_IMPORT_RESS=$DIR_BATCH_DATA/faccons_ressource.csv    
dos2unix -c ascii -n $FILE_IMPORT_RESS $FILE_IMPORT_RESS

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de la maj en masse de ligne bip : faccons_ressource.sh" >> $LOG_FILE

logText "--  Verification de la presence du fichier"
logText "--  Verification de la presence du fichier" >> $LOG_FILE

# Test de l'existence du fichier ????????????.csv
# ################################################

logText "SQL*Load des faccons_ressource"
logText "SQL*Load des faccons_ressource" >> $LOG_FILE

LOGLOAD_FILE=$LOG_FILE
BAD_FILE=$LOG_FILE.1.bad
DSC_FILE=$LOG_FILE.1.dsc
LOGLOAD_FILE=$LOG_FILE.1.logload


# Chargement des budgets dans la table temporaire
# ################################################
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/faccons_facture.par \
	control=$DIR_SQLLOADER_PARAM/faccons_facture.ctl \
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
	echo "Erreur de chargement des lignes BIP en masse SQL*Loader" >> $log_tmp
	logText "Erreur de chargement des lignes BIP en masse SQL*Loader" >> $LOG_FILE
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
    
fi
logText "SQL*Load des faccons_ressource Termine"
logText "SQL*Load des faccons_ressource Termine" >> $LOG_FILE

exit 0;




