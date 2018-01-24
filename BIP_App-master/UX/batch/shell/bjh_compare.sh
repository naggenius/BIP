#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : bjh_compare.sh
# Objet : Shell-script de comparaison des donnees BIP et Gershwin pour le bouclage J/H
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
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.bjh_compare.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi
else
	LOG_FILE=$1
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE

logText "Lancement de la comparaison pour le bouclage J/H (`basename $0`)"
logText "Lancement de la comparaison pour le bouclage J/H (`basename $0`)" >> $LOG_FILE

logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "pack_bjh.compare_bip_gershwin"
	exec pack_bjh.compare_bip_gershwin;
EOF

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur dans la comparaison" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -2
fi

logText "Fin de traitement de comparaison pour le bouclage J/H (`basename $0`)"
logText "Fin de traitement de comparaison pour le bouclage J/H (`basename $0`)" >> $LOG_FILE

exit 0
