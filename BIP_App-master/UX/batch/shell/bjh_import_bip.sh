#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : bjh_import_bip.sh
# Objet : Shell-script d'import des donnees BIP pour le bouclage J/H
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
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.bjh_import_bip.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi
else
	LOG_FILE=$1
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'import des données BIP (`basename $0`)"
logText "Debut de l'import des données BIP (`basename $0`)" >> $LOG_FILE

logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "DROP INDEX bjh_extbip_ind1"
	DROP INDEX bjh_extbip_ind1;
	!echo "pack_bjh.import_consomme_bip"
	exec pack_bjh.import_consomme_bip;
	!echo "CREATE INDEX bjh_extbip_ind1"
	CREATE INDEX bjh_extbip_ind1 ON bjh_extbip(matricule);
	!echo "pack_bjh.Import_Ressource_BIP"
	exec pack_bjh.Import_Ressource_BIP;
EOF

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur d'import des donnees BIP" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1
fi

logText "Fin de Import des donnees BIP (`basename $0`)"
logText "Fin de Import des donnees BIP (`basename $0`)" >> $LOG_FILE

exit 0
