#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : trans_oscar.sh
# Objet : Shell de copie du fichier des consommes oscar vers le compte remonte BIP
#	  qui lui est destine. Ce traitement doit être effectue avant la premiere
#	  pre-mensuelle et la mensuelle
#
# Parametres d'entree :
#	$1	Fichier log (facultatif)
#
#_______________________________________________________________________________
# Creation : O. Tonnelet 23/08/2002
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
	LOG_FILE=$DIR_BATCH_SHELL_LOG/trans_oscar.`date +"%Y%m%d%H%M"`.log
else
	LOG_FILE=$1
fi

echo "*********************************************" >> $LOG_FILE
echo "***  Debut du transfert de Oscar.bip vers ***" >> $LOG_FILE
echo "***      son compte de remonte BIP        ***" >> $LOG_FILE
echo "*********************************************" >> $LOG_FILE
date >> $LOG_FILE

echo "**  Verification de la presence de oscar.bip ** " >> $LOG_FILE

if [ -a $OSCAR_QUOTIDIEN/oscar.bip ]
then
	cp -p $OSCAR_QUOTIDIEN/oscar.bip $OSCAR_RBIP/oscar.bip 2>> $LOG_FILE
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
	then
		echo "Echec lors de la copie du fichier des consommes" >> $LOG_FILE
		echo "arret du traitement" >> $LOG_FILE
		exit 15;
	fi
	echo "*** Copie effectuee ***" >> $LOG_FILE
	echo " " >> $LOG_FILE

	rm $OSCAR_QUOTIDIEN/oscar.bip 2>> $LOG_FILE
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
	then
		echo "Echec lors de la suppression du fichier des consommes" >> $LOG_FILE
	fi
	echo "*** Suppression effectuee ***" >> $LOG_FILE
	echo " " >> $LOG_FILE

	chmod 666 $OSCAR_RBIP/oscar.bip 2>> $LOG_FILE
else
	echo "Fichier des consommes Oscar non detecte" >> $LOG_FILE
	exit 18;
fi

date >> $LOG_FILE
echo "*********************************************" >> $LOG_FILE
echo "***  Fin de la copie du fichier Oscar.bip ***" >> $LOG_FILE
echo "*********************************************" >> $LOG_FILE

exit 0
