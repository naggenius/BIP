#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : alimhisto.sh
# Objet : Shell batch alimhisto (le dernier traitement mensuel)
#	  Shell d'alimentation de la table histo_suivijhr
#
#_______________________________________________________________________________
# Creation : ARE 22/08/2002
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     14/10/02   Migration ksh SOLARIS 8
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.alimhisto.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de ALIMHISTO (`basename $0`)"
logText "Debut de ALIMHISTO (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "pack_suivijhr.alim_histo_suivijhr"
	execute pack_suivijhr.alim_histo_suivijhr;
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch alimhisto : consulter $LOG_FILE"
	logText "et le fichier $DIR_BATCH_SHELL_LOG/AAAA.MM.JJ.alimhisto.log du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

logText "ALIMHISTO (`basename $0`)"
logText "Fin de ALIMHISTO (`basename $0`)" >> $LOG_FILE

exit 0
