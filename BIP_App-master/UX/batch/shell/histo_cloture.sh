#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : amthist.sh
# Objet : Shell batch histo_cloture 
#	  Ordonnancement : Lors de la cloture
#
#_______________________________________________________________________________
# Creation : PJO 05/11/2004
# Modification :
# --------------
# Auteur  Date       	Objet
# SEL	  02/10/2014 	PPM 58986 : integration du traitement de cloture des FI (pack_batch_histo_cloture.cloture_fi_nov)	
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.histo_cloture.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de histo_cloture (`basename $0`)"
logText "Debut de histo_cloture (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "execute pack_batch_histo_cloture.cloture_exercice"
	execute pack_batch_histo_cloture.cloture_exercice('$PL_LOGS');
        !echo "execute pack_batch_histo_cloture.cloture_fi_nov"
	execute pack_batch_histo_cloture.cloture_fi_nov('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch histo_cloture : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.histo_cloture.log du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

logText "histo_cloture (`basename $0`)"
logText "Fin de histo_cloture (`basename $0`)" >> $LOG_FILE

exit 0
