#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : oscar_extract.sh
# Objet : Shell de constitution des deux fichiers pour Oscar
#
# Parametres d'entree :
#	$1	fichier log (facultatif)
#
#_______________________________________________________________________________
# Creation :
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

REP_EXTRACT=$OSCAR_QUOTIDIEN
logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut des extractions oscar (`basename $0`)"
logText "Debut des extractions oscar (`basename $0`)" >> $LOG_FILE


nom_fic_bip=$FILE_LIGNES_OSCAR
logText "Fichier Lignes BIP = $nom_fic_bip"
logText "Fichier Lignes BIP = $nom_fic_bip" >> $LOG_FILE
nom_fic_res=$FILE_RESS_OSCAR
logText "Fichier Ressources BIP = $nom_fic_res"
logText "Fichier Ressources BIP = $nom_fic_res" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "Extraction des lignes bip"
logText "Extraction des lignes bip" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	exec pack_oscar_lignebip.lance_oscar_lignebip('$REP_EXTRACT', '$nom_fic_bip')
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Probleme SQL*PLUS dans pour la extraction des lignes bip"
	logText "Probleme SQL*PLUS dans pour la extraction des lignes bip" >> $LOG_FILE
	logText "Code erreur <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "Extraction des ressources bip"
logText "Extraction des ressources bip" >> $LOG_FILE
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "pack_oscar_lignebip.oscar_ressource"
	exec pack_oscar_lignebip.oscar_ressource('$REP_EXTRACT', '$nom_fic_res')
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Probleme SQL*PLUS dans pour la extraction des ressources bip"
	logText "Probleme SQL*PLUS dans pour la extraction des ressources bip" >> $LOG_FILE
	logText "Code erreur <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

logText "Fin des extractions oscar (`basename $0`)"
logText "Fin des extractions oscar (`basename $0`)" >> $LOG_FILE

exit 0
