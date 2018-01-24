#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : oscar_insert.sh
# Objet :
#
# Parametres d'entree :
#	$1	Fichier log (facultatif)
#
#_______________________________________________________________________________
# Creation : O. Tonnelet 26/06/2002
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     16/10/02   Migration ksh sur SOLARIS 8
#
################################################################################

autoload $(ls $FPATH)

# Fichier log
if [ $# -eq 0 ]
then
	if [ -z $LOG_TRAITEMENT ]
	then
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.oscar_insert.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi
else
	LOG_FILE=$1
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de la mise a jour des lignes BIP (`basename $0`)"
logText "Debut de la mise a jour des lignes BIP (`basename $0`)" >> $LOG_FILE

logText "sqlplus" >> $LOG_FILE
sqlplus $CONNECT_STRING << EOF >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "pack_ligne_oscar.maj_ligne_oscar"
	exec pack_ligne_oscar.maj_ligne_oscar;
EOF

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Erreur d'import des donnees BIP"
	logText "Erreur d'import des donnees BIP" >> $LOG_FILE
	logText "Code erreur <$PLUS_EXIT>" >> $LOG_FILE
	exit -1
fi

logText "Fin de traitement d'import des donnees BIP (`basename $0`)"
logText "Fin de traitement d'import des donnees BIP (`basename $0`)" >> $LOG_FILE

exit 0
