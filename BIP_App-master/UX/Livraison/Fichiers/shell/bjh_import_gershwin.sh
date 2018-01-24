#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : bjh_import_gershwin.sh
# Objet : Shell-script d'import des donnees Gershwin
#
# Parametres d'entree:
#	$1	Fichier log (facultatif)
#
#_______________________________________________________________________________
# Creation : O. Duprey 21/11/2001
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     14/10/02   Migration ksh sur SOLARIS 8
#
################################################################################

autoload $(ls $FPATH)

# Fichier log
if [ $# -eq 0 ]
then
	if [ -z $LOG_TRAITEMENT ]
	then
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.bjh_import_gershwin.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi
else
	LOG_FILE=$1
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'import des données GIP (`basename $0`)"
logText "Debut de l'import des données GIP (`basename $0`)" >> $LOG_FILE

# suppression de l'index sur BJH_EXTGIP.MATRICULE
logText "sqlplus" >> $LOG_FILE
#Début PPM 60001 - Ano : intégration flux absence mensuel
# vérification présence de l'index avant de le supprimer
nombre=`sqlplus -s $CONNECT_STRING << !
        set heading off
		SELECT count(*) FROM USER_INDEXES WHERE INDEX_NAME = 'BJH_EXTGIP_IND1';
!`
# S'il existe un index, alors il faut le suprimer
if [ $nombre -ne 0 ] 
then
sqlplus -s $CONNECT_STRING << EOF >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "DROP INDEX bjh_extgip_ind1"
	DROP INDEX bjh_extgip_ind1;
EOF
fi
# Fin PPM 60001
# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de destruction de l'index bjh_extgip_idx1" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1
fi

logText "SQL*Load des des donnees Gershwin"
logText "SQL*Load des des donnees Gershwin" >> $LOG_FILE

LOGLOAD_FILE=$DIR_SQLLOADER_LOG/`date +"%Y%m%d"`.bjh_import_gershwin
BAD_FILE=$LOGLOAD_FILE.bad
DSC_FILE=$LOGLOAD_FILE.dsc
LOGLOAD_FILE=$LOGLOAD_FILE.logload

# On recherche le fichier possedant IABSM001 car la date de reception contenu dans le nom du fichier est antérieur à la date du traitement batch
#Vérification de présence du fichier des absences
#Début PPM 62715 - Ano : Pb mensuelle presence fichier Abs
cd $RECEPTION
FICHIER=`ls -tr $RECEPTION/*IABSM001* |tail -1`
echo $FICHIER >> $LOG_FILE
logText "NOM FICHIER :  $FICHIER"
if [[ $FICHIER = *IABSM001*  ]]

then 
	# chargement des donnees depuis le fichier
	logText "Fichier en cours d'intégration"
	logText "Fichier en cours d'intégration" >> $LOG_FILE
	sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/bjh_import_gershwin.par \
	control=$DIR_SQLLOADER_PARAM/bjh_import_gershwin.ctl \
	data=$FICHIER \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	discard=$DSC_FILE >> $LOG_FILE 2>&1
else
	logText "Fichier absent, intégration non réalisée" >> $LOG_FILE
	logText "Fichier absent, intégration non réalisée"
	exit -2
fi
#Fin PPM 62715

# valeur de sortie de SQL*LOAD
LOAD_EXIT=$?
# si le loader retourne 0, il faut verifier qu'il n'y a pas de codes erreurs persents
# dans le fichier de log
if [ $LOAD_EXIT -ne 0 ] || \
   [ $(cat $LOGLOAD_FILE | grep -ci 'SQL\*Loader-') -ne 0 ] || \
   [ $(cat $LOGLOAD_FILE | grep -ci 'ORA-') -ne 0 ]
then
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de chargement des données Gershwin avec SQL*Loader" >> $LOG_FILE
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	exit -2
fi
logText "SQL*Load des des donnees Gershwin Termine"
logText "SQL*Load des des donnees Gershwin Termine" >> $LOG_FILE

# Suppression des ressources qui ne concernent pas la BIP
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "exec pack_bjh.filtre_gershwin"
	exec pack_bjh.filtre_gershwin;
EOF

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de correction des donnees Gershwin sous SQL*Plus" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	exit -3
fi

logText "sqlplus" >> $LOG_FILE
# creation de l'index sur BJH_EXTGIP.MATRICULE
sqlplus -s $CONNECT_STRING << EOF >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "CREATE INDEX bjh_extgip_ind1"
	CREATE INDEX bjh_extgip_ind1 ON bjh_extgip(matricule);
EOF

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de creation de l'index bjh_extgip_idx1" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	exit -4
fi

#Apres traitement on deplace le fichier du dossier reception dans batch/data
mv $FICHIER $DIR_BATCH_DATA/$FILE_BJH_IMPORT_GERSHWIN

logText "Fin de Import des donnees GIP (`basename $0`)"
logText "Fin de Import des donnees GIP (`basename $0`)" >> $LOG_FILE

exit 0
