#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : fair.sh
# Objet : Shell de constitution des cinq fichiers pour fair
#
#_______________________________________________________________________________
# Creation : ???
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     15/10/02   Migration ksh SOLARIS 8
# MMC     19/06/03   Modif date pour nommage du fichier envoye
# PPR     07/01/05   Modif du nom du fichier si on est en Janvier 
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.fair.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de FAIR (`basename $0`)"
logText "Debut de FAIR (`basename $0`)" >> $LOG_FILE

#################
# Format de la date dans le nom du fichier : (mois -1)annee
if [ $(date +"%m") -eq "01" ]
then
	sDateaa=$(($(date +"%y")-1))
	sDate="12"$(printf "%02d" $sDateaa)
else
	sDate=$(($(date +"%m")-1))$(date +"%y")
fi
sDate=$(printf "%04d" $sDate)

#################

#NOM_FIC_SGPMP=FAIR.PBB1`date +"%m%y"`.csv

logText "Fichier de donnees financieres pour sgpm      = $NOM_FIC_SGPMP" >> $LOG_FILE
logText "Fichier de donnees financieres pour sgam      = $NOM_FIC_SGAMP" >> $LOG_FILE
logText "Fichier de referentiel des articles pour sgpm = $NOM_FIC_SGPMA" >> $LOG_FILE
logText "Fichier de referentiel des articles pour sgam = $NOM_FIC_SGAMA" >> $LOG_FILE
logText "Fichier de referentiel des entites pour sgam  = $NOM_FIC_SGAME" >> $LOG_FILE
#################

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "pack_fair.select_fair"
	exec pack_fair.select_fair('$DIR_BATCH_DATA','$NOM_FIC_SGPMP','$NOM_FIC_SGAMP','$NOM_FIC_SGAME','$NOM_FIC_SGPMA','$NOM_FIC_SGAMA')
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Probleme SQL*PLUS dans fair.sql pour la generation des deux fichiers"
	logText "Probleme SQL*PLUS dans fair.sql pour la generation des deux fichiers" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi
#################
logText "copie de $FAIR_DIR/$NOM_FIC_SGPMP en $FAIR_EXTRACT/$NOM_FIC_SGPMP" >> $LOG_FILE
cp -p $FAIR_DIR/$NOM_FIC_SGPMP $FAIR_EXTRACT/$NOM_FIC_SGPMP 2>> $LOG_FILE
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
	logText "Probleme dans le cp du fichier sgpmp" >> $LOG_FILE
	exit -1;
fi
rm -f $FAIR_DIR/$NOM_FIC_SGPMP 2>> $LOG_FILE
#################
logText "copie de $FAIR_DIR/$NOM_FIC_SGAMP en $FAIR_EXTRACT/$NOM_FIC_SGAMP" >> $LOG_FILE
cp -p $FAIR_DIR/$NOM_FIC_SGAMP $FAIR_EXTRACT/$NOM_FIC_SGAMP 2>> $LOG_FILE
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
	logText "Probleme dans le cp du fichier sgamp" >> $LOG_FILE
	exit -1;
fi
rm -f $FAIR_DIR/$NOM_FIC_SGAMP 2>> $LOG_FILE
#################
logText "copie de $FAIR_DIR/$NOM_FIC_SGAME en $FAIR_EXTRACT/$NOM_FIC_SGAME" >> $LOG_FILE
cp -p $FAIR_DIR/$NOM_FIC_SGAME $FAIR_EXTRACT/$NOM_FIC_SGAME 2>> $LOG_FILE
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
	logText "Probleme dans le cp du fichier sgame" >> $LOG_FILE
	exit -1;
fi
rm -f $FAIR_DIR/$NOM_FIC_SGAME 2>> $LOG_FILE
#################
logText "copie de $FAIR_DIR/$NOM_FIC_SGPMA en $FAIR_EXTRACT/$NOM_FIC_SGPMA" >> $LOG_FILE
cp -p $FAIR_DIR/$NOM_FIC_SGPMA $FAIR_EXTRACT/$NOM_FIC_SGPMA 2>> $LOG_FILE
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
	logText "Probleme dans le cp du fichier sgpma" >> $LOG_FILE
	exit -1;
fi
rm -f $FAIR_DIR/$NOM_FIC_SGPMA 2>> $LOG_FILE
#################
logText "copie de $FAIR_DIR/$NOM_FIC_SGAMA en $FAIR_EXTRACT/$NOM_FIC_SGAMA" >> $LOG_FILE
cp -p $FAIR_DIR/$NOM_FIC_SGAMA $FAIR_EXTRACT/$NOM_FIC_SGAMA 2>> $LOG_FILE
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
	logText "Probleme dans le cp du fichier sgama" >> $LOG_FILE
	exit -1;
fi
rm -f $FAIR_DIR/$NOM_FIC_SGAMA 2>> $LOG_FILE
#################

logText "FAIR (`basename $0`)"
logText "Fin de FAIR (`basename $0`)" >> $LOG_FILE

exit 0
