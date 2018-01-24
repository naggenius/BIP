#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : stloadcam.sh
# Objet : Shell batch STLOADCAM
#	  A la fin du traitement si OK, on renomme le fichier avec une extension de la date du jour
#
# Parametres d'entree :
#	$1	le chemin ET LE NOM du fichier de data, contenant la remontée du fichier CAMO
#
#_______________________________________________________________________________
# Creation : M. LECLERC 19/03/1999
# Modification :
# --------------
# Auteur  Date       Objet
# HTM     02/06/00   Récupération USERID/PASSWORD à partir
#                    variables environnement
# ODU     15/11/01   Passage au fichier log avec date
# EGR     16/10/02   Migration ksh sur SOLARIS 8
#                    Utilisation de 'sqlldr' a la place de sqlload
#
################################################################################
autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.stloadcam.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de STLOADCAM (`basename $0`)"
logText "Debut de STLOADCAM (`basename $0`)" >> $LOG_FILE

DATA_FILE=$1
LOGLOAD_FILE=$DIR_SQLLOADER_LOG/`date +"%Y%m%d"`.stloadcam
BAD_FILE=$LOGLOAD_FILE.bad
DSC_FILE=$LOGLOAD_FILE.dsc
LOGLOAD_FILE=$LOGLOAD_FILE.logload

# appel SQL*LOADER avec trace execution
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/stloadcam.par \
	control=$DIR_SQLLOADER_PARAM/stloadcam.ctl \
	data=$DATA_FILE \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	discard=$DSC_FILE >> $LOG_FILE 2>&1

# valeur de sortie de SQL*PLUS
LOAD_EXIT=$?
# si le loader retourne 0, il faut verifier qu'il n'y a pas de codes erreurs persents
# dans le fichier de log
if [ $LOAD_EXIT -ne 0 ] || \
   [ $(cat $LOGLOAD_FILE | grep -ci 'SQL\*Loader-') -ne 0 ] || \
   [ $(cat $LOGLOAD_FILE | grep -ci 'ORA-') -ne 0 ]
then
	logText "Problème SQL*LOAD dans batch STLOADCAM : consulter $LOG_FILE"
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>"
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	exit -1;
fi

DATE_DUJOUR=`date +"%Y%m%d"`
DATA_FILE2=`echo $DATA_FILE | cut -d'/' -f5`

mv  $DATA_FILE  $DIR_BATCH_DATA/$DATA_FILE2 2>> $LOG_FILE
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
	logText "Echec du deplacement de $DATA_FILE "
	logText "Echec du deplacement de $DATA_FILE " >> $LOG_FILE
	logText "Code erreur : <$CMD_EXIT>" >> $LOG_FILE
	#erreur non bloquante
	exit 0
fi
logText "Fichier DPA CAMO deplacer"

logText "STLOADCAM (`basename $0`)"
logText "Fin de STLOADCAM (`basename $0`)" >> $LOG_FILE

exit 0
