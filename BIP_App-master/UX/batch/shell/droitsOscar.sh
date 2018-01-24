#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : droitsOscar.sh
# Objet : modifie les droit des fichiers pour pouvoir effectuer les traitements
#       IL FAUT LANCER CE SCRIPT AVEC LE COMPTE OSCAR !!!!!!!
#
#_______________________________________________________________________________
# Creation : PIT/SYS
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     09/12/02   Migration ksh sur SOLARIS 8
#
################################################################################

autoload $(ls $FPATH)

#################################################
# On charge l'environnement
#################################################
#export APP_HOME=/datas/bippr/applis
#export BIP_ENV=BIP_PRODUCTION

#################################################

DIR=$OSCAR_QUOTIDIEN
LOG_FILE=$DIR_BATCH_SHELL_LOG/$(basename $0).log
rm -f $LOG_FILE 2> /dev/null

logText "Fichier de trace : $LOG_FILE"

logText "Debut du script de modification des droits des fichiers oscar ($(basename $0))"
logText "Debut du script de modification des droits des fichiers oscar ($(basename $0))" >> $LOG_FILE

logText "Liste des fichiers dont les droits vont etre modifies :"
logText "Liste des fichiers dont les droits vont etre modifies :" >> $LOG_FILE
find $DIR -user oscar -name "*".csv >> $LOG_FILE 2>&1
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
	logText "Echec du listage des fichiers a modifier"
	logText "Echec du listage des fichiers a modifier" >> $LOG_FILE
	logText "Code erreur <$CMD_EXIT>" >> $LOG_FILE
	exit $CMD_EXIT
fi

find $DIR -user oscar -name "*".csv -exec chmod 666 {} \;
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
	logText "La modification des droits a echoue"
	logText "La modification des droits a echoue" >> $LOG_FILE
	logText "Code erreur <$CMD_EXIT>" >> $LOG_FILE
	exit $CMD_EXIT
fi

logText "Fin de ($(basename $0))"
logText "Fin de ($(basename $0))" >> $LOG_FILE

exit 0
