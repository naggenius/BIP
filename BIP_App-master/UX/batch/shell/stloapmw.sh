#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : stloapmw.sh
# Objet : Shell batch STLOAPMW
#	  A la fin du traitement si OK, on renomme le fichier avec une extension de la date du jour
#
# Parametres d'entree :
#	$1	le chemin ET LE NOM du fichier de data, contenant la remont�e PMW
#
#_______________________________________________________________________________
# Creation : M. LECLERC 19/03/1999
# Modification :
# --------------
# Auteur  Date       Objet
# HTM     02/06/00   R�cup�ration USERID/PASSWORD � partir
#                    variables environnement
# ODU     15/11/01   Changement du fichier result en log avec date dans le nom
# EGR     16/10/02   Migration ksh sur SOLARIS 8
#                    Utilisation de 'sqlldr' a la place de sqlload
#
################################################################################
autoload $(ls $FPATH)

# Trace de l'execution du batch
if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.stloapmw.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de STLOAPMW (`basename $0`)"
logText "Debut de STLOAPMW (`basename $0`)" >> $LOG_FILE

DATA_FILE=$1
LOGLOAD_FILE=$DIR_SQLLOADER_LOG/`date +"%Y%m%d"`.stloapmw
BAD_FILE=$LOGLOAD_FILE.bad
DSC_FILE=$LOGLOAD_FILE.dsc
LOGLOAD_FILE=$LOGLOAD_FILE.logload

# appel SQL*LOADER avec trace execution
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/stloapmw.par \
	control=$DIR_SQLLOADER_PARAM/stloapmw.ctl \
	data=$DATA_FILE \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	discard=$DSC_FILE >> $LOG_FILE 2>&1

# valeur de sortie de SQL*LOAD
LOAD_EXIT=$?
# si le loader retourne 0 ou 2 (on autorise des fichiers en bad et discard),
# il faut verifier qu'il n'y a pas de codes erreurs presents sauf le 01722 qui est autorise
# dans le fichier de log
if ( [ $LOAD_EXIT -ne 0 ] && [ $LOAD_EXIT -ne 2 ] ) || \
   [ $(cat $LOGLOAD_FILE | grep -ci 'SQL\*Loader-') -ne 0 ] || \
   [ $(cat $LOGLOAD_FILE | grep -iv 'ORA-01722' | grep -ci 'ORA-') -ne 0 ]
then
	logText "Probl�me SQL*LOAD dans batch stloapmw : consulter $LOG_FILE"
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>"
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	exit -1;
fi

###############BIPS : PPM 60612

# appel SQL*LOADER avec trace execution
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/stloapmw_bips.par \
	control=$DIR_SQLLOADER_PARAM/stloapmw_bips.ctl \
	data=$DATA_FILE \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	discard=$DSC_FILE >> $LOG_FILE 2>&1

# valeur de sortie de SQL*LOAD
LOAD_EXIT=$?
# si le loader retourne 0 ou 2 (on autorise des fichiers en bad et discard),
# il faut verifier qu'il n'y a pas de codes erreurs presents sauf le 01722 qui est autorise
# dans le fichier de log
if ( [ $LOAD_EXIT -ne 0 ] && [ $LOAD_EXIT -ne 2 ] ) || \
   [ $(cat $LOGLOAD_FILE | grep -ci 'SQL\*Loader-') -ne 0 ] || \
   [ $(cat $LOGLOAD_FILE | grep -iv 'ORA-01722' | grep -ci 'ORA-') -ne 0 ]
then
	logText "Probl�me SQL*LOAD dans batch stloapmw : consulter $LOG_FILE"
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>"
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	exit -1;
fi


###################


DATE_DUJOUR=`date +"%Y%m%d"`

mv  $DATA_FILE  $DATA_FILE$DATE_DUJOUR 2>> $LOG_FILE
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
	logText "Echec du deplacement de $DATA_FILE en $DATA_FILE$DATE_DUJOUR"
	logText "Echec du deplacement de $DATA_FILE en $DATA_FILE$DATE_DUJOUR" >> $LOG_FILE
	logText "Code erreur : <$CMD_EXIT>" >> $LOG_FILE
	#erreur non bloquante
	exit 0
fi
logText "Fichier PMW renomme en $DATA_FILE$DATE_DUJOUR" >> $LOG_FILE

logText "STLOAPMW (`basename $0`)"
logText "Fin de STLOAPMW (`basename $0`)" >> $LOG_FILE

exit 0
