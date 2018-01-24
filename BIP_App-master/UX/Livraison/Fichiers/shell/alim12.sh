#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : alim12.sh
# Objet : Shell batch alim12 (1ere pr\351mensuelle)
#	  Shell d'alimentation de la table suivijhr qui sert pour l'\351dition du suivi des remontee jh
#	  on alimente les donn\351es du mois -1 et -2
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
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.alim12.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de ALIM12 (`basename $0`)"
logText "Debut de ALIM12 (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "execute pack_suivijhr.alim12_suivijhr"
	execute pack_suivijhr.alim12_suivijhr;
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch alim12 : consulter $LOG_FILE"
	logText "et le fichier  $DIR_BATCH_SHELL_LOG/AAAA.MM.JJ.alim12.log  du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

logText "Fin de ALIM12 (`basename $0`)"
logText "Fin de ALIM12 (`basename $0`)" >> $LOG_FILE

exit 0
