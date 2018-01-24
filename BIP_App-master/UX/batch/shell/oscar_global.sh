#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : oscar_global.sh
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
# PPR     13/10/06   Enleve l'envoi par FTP (on utilise TOM)
#
################################################################################

autoload $(ls $FPATH)

# Fichier log
if [ $# -eq 0 ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.oscar_global.log
	rm $LOG_FILE 2> /dev/null
else
	LOG_FILE=$1
fi

logText "`basename $0` : fichier de trace : $LOG_FILE"
LOG_TRAITEMENT=$LOG_FILE
export LOG_TRAITEMENT

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut du traitement Oscar quotidien (`basename $0`)"
logText "Debut du traitement Oscar quotidien (`basename $0`)" >> $LOG_FILE

logText "--  Verification de la presence du fichier oscar "
logText "--  Verification de la presence du fichier oscar " >> $LOG_FILE

DATA_FILE=ligne_oscar.csv
if [ -a $OSCAR_QUOTIDIEN/$DATA_FILE ]
then
	logText "Fichier $FIC_OSCAR detecte, Lancement de oscar_imprt.sh" >> $LOG_FILE
	$DIR_BATCH_SHELL/oscar_import.sh $OSCAR_QUOTIDIEN/$DATA_FILE $LOG_FILE 2>> $LOG_FILE
	SHELL_EXIT=$?
	if [ $SHELL_EXIT -ne 0 ]
	then
		logText "Echec lors de l execution du traitement d'import du fichier oscar ligne bip"
		logText "Echec lors de l execution du traitement d'import du fichier oscar ligne bip" >> $LOG_FILE
		logText "arret du batch `basename $0`"
		logText "arret du batch `basename $0`" >> $LOG_FILE
		unset LOG_TRAITEMENT
		exit 300;
	fi

	logText "-- Insertion dans ligne_bip et budget, Lancement de oscar_insert.sh" >> $LOG_FILE
	$DIR_BATCH_SHELL/oscar_insert.sh $LOG_FILE 2>> $LOG_FILE
	SHELL_EXIT=$?
	if [ $SHELL_EXIT -ne 0 ]
	then
		logText "Echec lors de l execution du traitement d'insertion des donnees depuis la table temporaire"
		logText "Echec lors de l execution du traitement d'insertion des donnees depuis la table temporaire" >> $LOG_FILE
		logText "arret du batch `basename $0`"
		logText "arret du batch `basename $0`" >> $LOG_FILE
		unset LOG_TRAITEMENT
		exit 310;
	fi

	echo "-- Renommage du fichier Oscar : $OSCAR_QUOTIDIEN/$DATA_FILE en $OSCAR_QUOTIDIEN/$DATA_FILE.$(date +"%Y%m%d")" >> $LOG_FILE
	cp -p $OSCAR_QUOTIDIEN/$DATA_FILE $OSCAR_QUOTIDIEN/$DATA_FILE.`date +"%Y%m%d"` 2>> $LOG_FILE
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
	then
		echo "Echec de la recopie <$CMD_EXIT>"
		echo "Echec de la recopie <$CMD_EXIT>" >> $LOG_FILE
		echo "arret du batch `basename $0`"
		echo "arret du batch `basename $0`" >> $LOG_FILE
		unset LOG_TRAITEMENT
		exit 320;
	else
		rm -f $OSCAR_QUOTIDIEN/$DATA_FILE 2>> $LOG_FILE
	fi
else
	logText " Fichier non detecte. Pas d insertion des donnees Oscar !!!"
	logText " Fichier non detecte. Pas d insertion des donnees Oscar !!!" >> $LOG_FILE
fi

logText "-- Generation des fichiers ressource et lignes BIP, Lancement de oscar_extract.sh"
logText "-- Generation des fichiers ressource et lignes BIP, Lancement de oscar_extract.sh" >> $LOG_FILE
$DIR_BATCH_SHELL/oscar_extract.sh $LOG_FILE 2>> $LOG_FILE
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de l execution du traitement de generation des fichiers pour Oscar"
	logText "Echec lors de l execution du traitement de generation des fichiers pour Oscar" >> $LOG_FILE
	logText "arret du batch `basename $0`"
	logText "arret du batch `basename $0`" >> $LOG_FILE
	unset LOG_TRAITEMENT
	exit 350;
fi


nom_fic_bip=BIP.`date +"%Y%m%d"`.csv
fic_bip="bip.csv"
cp $OSCAR_QUOTIDIEN/$nom_fic_bip $OSCAR_QUOTIDIEN/$fic_bip 2>> $LOG_FILE
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
	logText "Echec de la recopie de $OSCAR_QUOTIDIEN/$nom_fic_bip en $OSCAR_QUOTIDIEN/$fic_bip pour Oscar"
	logText "Echec de la recopie de $OSCAR_QUOTIDIEN/$nom_fic_bip en $OSCAR_QUOTIDIEN/$fic_bip pour Oscar" >> $LOG_FILE
	logText "arret du batch `basename $0`"
	logText "arret du batch `basename $0`" >> $LOG_FILE
	unset LOG_TRAITEMENT
	exit 360;
fi

nom_fic_res=RESSOURCE_BIP.`date +"%Y%m%d"`.csv
fic_res="ressource_bip.csv"
cp $OSCAR_QUOTIDIEN/$nom_fic_res $OSCAR_QUOTIDIEN/$fic_res 2>> $LOG_FILE
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
	logText "Echec de la recopie de $OSCAR_QUOTIDIEN/$nom_fic_res en $OSCAR_QUOTIDIEN/$fic_res pour Oscar"
	logText "Echec de la recopie de $OSCAR_QUOTIDIEN/$nom_fic_res en $OSCAR_QUOTIDIEN/$fic_res pour Oscar" >> $LOG_FILE
	logText "arret du batch `basename $0`"
	logText "arret du batch `basename $0`" >> $LOG_FILE
	unset LOG_TRAITEMENT
	exit 360;
fi

#logText "-- Envoi des fichiers lignes BIP, Lancement de shell_ftp.sh" >> $LOG_FILE
#$DIR_BATCH_SHELL/shell_ftp.sh	$OSCAR_IP      \
#				$OSCAR_PORT     \
#				$OSCAR_LOGIN       \
#				$OSCAR_PASSWORD	\
#				$OSCAR_QUOTIDIEN \
#				$fic_bip 2>> $LOG_FILE
#SHELL_EXIT=$?
#if [ $SHELL_EXIT -ne 0 ]
#then
#	logText "Echec lors de l envoi du fichier bip ($fic_bip) pour Oscar"
#	logText "Echec lors de l envoi du fichier bip ($fic_bip) pour Oscar" >> $LOG_FILE
#	logText "arret du batch `basename $0`"
#	logText "arret du batch `basename $0`" >> $LOG_FILE
#	unset LOG_TRAITEMENT
#	exit 360;
#fi

#logText "-- Envoi des fichiers ressources BIP, Lancement de shell_ftp.sh" >> $LOG_FILE
#$DIR_BATCH_SHELL/shell_ftp.sh	$OSCAR_IP      \
#				$OSCAR_PORT     \
#				$OSCAR_LOGIN       \
#				$OSCAR_PASSWORD	\
#				$OSCAR_QUOTIDIEN \
#				$fic_res 2>> $LOG_FILE
#SHELL_EXIT=$?
#if [ $SHELL_EXIT -ne 0 ]
#then
#	logText "Echec lors de l envoi du fichier bip ($fic_res) pour Oscar"
#	logText "Echec lors de l envoi du fichier bip ($fic_res) pour Oscar" >> $LOG_FILE
#	logText "arret du batch `basename $0`"
#	logText "arret du batch `basename $0`" >> $LOG_FILE
#	unset LOG_TRAITEMENT
#	exit 370;
#fi

logText "Fin de traitement global de oscar quotidien (`basename $0`)"
logText "Fin de traitement global de oscar quotidien (`basename $0`)" >> $LOG_FILE

unset LOG_TRAITEMENT
exit 0
