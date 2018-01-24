#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : import_niveau.sh
# Objet : Shell-script d'import des donnees Gershwin
#
# Parametres d'entree:
#	$1	Fichier log (facultatif)
#
#_______________________________________________________________________________
# Creation : MM CURE 27/10/2003 
#
################################################################################

autoload $(ls $FPATH)

# fonction pour la creation de l'index
function creation_index {
logText "sqlplus" >> $LOG_FILE
# creation de l'index sur TMP_IMP_NIVEAU.MATRICULE
sqlplus -s $CONNECT_STRING << EOF >> $LOG_FILE 2>&1
        whenever sqlerror exit failure;
        !echo "CREATE INDEX tmp_imp_niveau_idx1"
        CREATE INDEX TMP_IMP_NIVEAU_IDX1 ON TMP_IMP_NIVEAU(MATRICULE);
EOF
}

# Fichier log
if [ $# -eq 0 ]
then
	if [ -z $LOG_TRAITEMENT ]
	then
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_niveau.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi
else
	LOG_FILE=$1
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'import des niveaux depuis Gershwin (`basename $0`)"
logText "Debut de l'import des niveaux depuis Gershwin (`basename $0`)" >> $LOG_FILE

logText "--  Verification de la presence du fichier import_niveau.dat "
logText "--  Verification de la presence du fichier import_niveau.dat " >> $LOG_FILE

# test de l'existence du fichier import_niveau.dat
cd $RECEPTION
DATA_FILE_NIVEAU=`ls -tr $IMPORT_NIVEAU |tail -1`
if [ -a $DATA_FILE_NIVEAU ]
then logText "Fichier import_niveau.dat detecte, Lancement de import_niveau.sh" >> $LOG_FILE

# suppression de l'index sur TMP_IMP_NIVEAU.MATRICULE 
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "DROP INDEX tmp_imp_niveau_idx1"
	DROP INDEX TMP_IMP_NIVEAU_IDX1;
EOF

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de destruction de l'index tmp_imp_niveau_idx1" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1
fi

logText "SQL*Load des niveaux depuis Gershwin"
logText "SQL*Load des niveaux depuis Gershwin" >> $LOG_FILE

LOGLOAD_FILE=$DIR_SQLLOADER_LOG/`date +"%Y%m%d"`.import_niveau
BAD_FILE=$LOGLOAD_FILE.bad
DSC_FILE=$LOGLOAD_FILE.dsc
LOGLOAD_FILE=$LOGLOAD_FILE.logload

# chargement des donnees depuis le fichier
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/import_niveau.par \
	control=$DIR_SQLLOADER_PARAM/import_niveau.ctl \
	data=$DATA_FILE_NIVEAU \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	discard=$DSC_FILE >> $LOG_FILE 2>&1

# valeur de sortie de SQL*LOAD
LOAD_EXIT=$?
# si le loader retourne 0, il faut verifier qu'il n'y a pas de codes erreurs 
# dans le fichier de log
if [ $LOAD_EXIT -ne 0 ] || \
   [ $(cat $LOGLOAD_FILE | grep -ci 'SQL\*Loader-') -ne 0 ] || \
   [ $(cat $LOGLOAD_FILE | grep -ci 'ORA-') -ne 0 ]
then
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de chargement des niveaux Gershwin avec SQL*Loader" >> $LOG_FILE
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
        creation_index
	exit -2
fi
logText "SQL*Load des des niveaux Gershwin Termine"
logText "SQL*Load des des niveaux Gershwin Termine" >> $LOG_FILE

#On deplace le fichier apres traitement
mv $RECEPTION/$DATA_FILE_NIVEAU $DIR_BATCH_DATA/$DATA_FILE_NIVEAU

 
# maj des situations des ressources en fonction de leur niveau 
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "exec pack_import_niveau.alim_situation"
	exec pack_import_niveau.alim_situation;
EOF

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de correction des niveaux Gershwin sous SQL*Plus" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
         creation_index
	exit -3
fi


creation_index

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de creation de l'index tmp_imp_niveau_idx1" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	exit -4
fi

logText "Fin de Import des niveaux depuis Gershwin (`basename $0`)"
logText "Fin de Import des niveaux depuis Gershwin (`basename $0`)" >> $LOG_FILE

else
     logText " Fichier non detecte. Pas d insertion des donnees dans TMP_IMP_NIVEAU !!!"
     logText " Fichier non detecte. Pas d insertion des donnees dans TMP_IMP_NIVEAU !!!" >> $LOG_FILE
fi

exit 0
