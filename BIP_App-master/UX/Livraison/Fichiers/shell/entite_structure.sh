#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : entite_structure.sh
# Objet : Shell-script d'import des ES
#
# Parametres d'entree:
#	$1	Fichier log (facultatif)
#
#_______________________________________________________________________________
# Creation : MM CURE 14/04/2004 
#
################################################################################


# fonction pour la creation de l'index
#function creation_index {
#logText "sqlplus" >> $LOG_FILE
# creation de l'index sur TMP_IMP_NIVEAU.MATRICULE
#sqlplus -s $CONNECT_STRING << EOF >> $LOG_FILE 2>&1
#        whenever sqlerror exit failure;
#        !echo "CREATE INDEX tmp_imp_niveau_idx1"
#        CREATE INDEX TMP_IMP_NIVEAU_IDX1 ON TMP_IMP_NIVEAU(MATRICULE) TABLESPACE idx;
#EOF
#}

autoload $(ls $FPATH)

DATA_FILE=$1

# Fichier log
if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.entite_structure.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut du chargement des ES (`basename $0`)"
logText "Debut du chargement des ES (`basename $0`)" >> $LOG_FILE

logText "--  Verification de la presence du fichier import_ES.dat "
logText "--  Verification de la presence du fichier import_ES.dat " >> $LOG_FILE

# test de l'existence du fichier import_ES.dat
#MTC - DATA_FILE=import_ES.dat
if [ -a $DATA_FILE ]
then logText "Fichier import_ES.dat detecte, Lancement de entite_structure.sh" >> $LOG_FILE

# suppression de l'index sur TMP_IMP_NIVEAU.MATRICULE 
#logText "sqlplus" >> $LOG_FILE
#sqlplus -s $CONNECT_STRING << EOF >> $LOG_FILE 2>&1
#	whenever sqlerror exit failure;
#	!echo "DROP INDEX tmp_imp_niveau_idx1"
#	DROP INDEX TMP_IMP_NIVEAU_IDX1;
#EOF

# valeur de sortie de SQL*PLUS
#PLUS_EXIT=$?
#if [ $PLUS_EXIT -ne 0 ]
#then
#	logText "Erreur : consulter $LOG_FILE"
#	logText "Erreur de destruction de l'index tmp_imp_niveau_idx1" >> $LOG_FILE
#	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
#	exit -1
#fi

logText "SQL*Load des ES"
logText "SQL*Load des ES" >> $LOG_FILE

LOGLOAD_FILE=$DIR_SQLLOADER_LOG/`date +"%Y%m%d"`.import_ES
BAD_FILE=$LOGLOAD_FILE.bad
DSC_FILE=$LOGLOAD_FILE.dsc
LOGLOAD_FILE=$LOGLOAD_FILE.logload

# chargement des donnees depuis le fichier
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/entite_struct.par \
	control=$DIR_SQLLOADER_PARAM/entite_struct.ctl \
	data=$DATA_FILE \
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
	logText "Erreur de chargement des ES avec SQL*Loader" >> $LOG_FILE
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
      #  creation_index
	exit -2
fi
logText "SQL*Load des ES termine"
logText "SQL*Load des ES termine" >> $LOG_FILE

#On deplace le fichier apres traitement
DATA_FILE2=`echo $DATA_FILE | cut -d'/' -f5`
mv $DATA_FILE $DIR_BATCH_DATA/$DATA_FILE2


 
# maj de la table entite_structure 
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "exec pack_import_ES.alim_ES"
	exec pack_import_ES.alim_ES;
EOF

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur dans alim de la table entite_structure sous SQL*Plus" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
         #creation_index
	exit -3
fi


#creation_index

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de creation de l'index tmp_imp_niveau_idx1" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	exit -4
fi

logText "Fin du chargement des ES (`basename $0`)"
logText "Fin du chargement des ES (`basename $0`)" >> $LOG_FILE

else
     logText " Fichier non detecte. Pas d insertion des donnees dans CHARGE_ES !!!"
     logText " Fichier non detecte. Pas d insertion des donnees dans CHARGE_ES !!!" >> $LOG_FILE
fi

exit 0
