#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : isac.sh
# Objet : Shell batch isac (Les deux Premensuelle et la Mensuelle)
#	  Shell d'alimentation des tables PMW_lIGNE_BIP, PMW_ACTIVITE,
#	  PMW_AFFECTA, PMW_CONSOMM à partir des données d'ISAC
#
#_______________________________________________________________________________
# Creation : NBM 10/04/2002
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     15/10/02   Migration ksh SOLARIS 8
#
################################################################################

autoload $(ls $FPATH)
TYPE_MENSUELLE=$1 

# Trace de l'execution du batch
if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.isac.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de ISAC (`basename $0`)"
logText "Debut de ISAC (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "execute pack_isac_alimentation.insert_pmw"
	execute pack_isac_alimentation.insert_pmw('$PL_LOGS','$TYPE_MENSUELLE');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch isac : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.isac.log du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

logText "ISAC (`basename $0`)"
logText "Fin de ISAC (`basename $0`)" >> $LOG_FILE

exit 0
