#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : export_prod.sh
# Objet : exportation de la base avant lancement des batcch
#
#_______________________________________________________________________________
# Creation : ARE 22/08/2002
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     14/10/02   Migration ksh SOLARIS 8
# EGR	  01/10/03   Ajout de compression du fichier dmp en debut de traitement
#			 (il ne doit pas exister au moment du dump)
#
################################################################################
#manque de place poor test complet

#################################################
# On charge l'environnement
#################################################
. $APP_ETC/bipparam.sh
#################################################

LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.export_prod.log
rm $LOG_FILE 2> /dev/null
logText "`basename $0` : fichier de trace : $LOG_FILE"

######################################################
#  Export de la base avant BATCH
######################################################

logText "--------------------------------------------------------------------------------" > $LOG_FILE
logText "-- $(date +"%Y%m%d") Debut de $0" >> $LOG_FILE
logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Export de la base $BIP_ENV"
logText "Export de la base $BIP_ENV" >> $LOG_FILE

DUMP_FILE=$DIR_ORACLE_EXPORT_USER/exp_bipprod.dmp
LOGEXP_FILE=$DIR_ORACLE_EXPORT_USER/exp_bipprod.log

rm -f $DUMP_FILE.gz
rm $LOGEXP_FILE

/usr/sbin/mknod $DUMP_FILE p
gzip < $DUMP_FILE > $DUMP_FILE.gz &
exp $ORA_USR_LIVE@$ORA_LIVE \
	FILE=$DUMP_FILE \
	LOG=$LOGEXP_FILE \
    	GRANTS=Y  CONSTRAINTS=Y  INDEXES=Y \
    	OWNER=$ORA_USRID >> $LOG_FILE 2>&1


EXP_EXIT=$?
# Test si lancement export KO
if [ $EXP_EXIT -ne 0 ]
then
	logText "Problème de export : consulter le fichier $LOG_FILE"
	logText "Problème de export" >> $LOG_FILE
	logText "code erreur : $EXP_EXIT"
	logText "code erreur : $EXP_EXIT" >> $LOG_FILE
	exit -1
else
	# Test si export terminé avec succès
	# EXP- prefixe des codes erreurs oracle lors d'un export
	if [ $(grep  -c "EXP-" $LOGEXP_FILE) -ne 0 ]
	then
		logText "Problème de export : consulter le fichier $LOG_FILE"
		logText "Problème de export" >> $LOG_FILE
		exit -1
	fi
fi


rm -f $DUMP_FILE

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "-- Fin Normale de $0" >> $LOG_FILE
logText "--------------------------------------------------------------------------------" >> $LOG_FILE

exit 0
