#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : cloture.sh
# Objet : Shell batch CLOTURE
#
#_______________________________________________________________________________
# Creation : ?????
# Modification :
# --------------
# Auteur  Date       Objet
# QHL     28/07/00   R\351cup\351ration USERID/PASSWORD \340 partir
#                    variables environnement plus besoin de $1 , $2
# EGR     14/10/02   Migration ksh SOLARIS 8
# EGR     12/12/02   Ajout de l'appel a pack_batch_cloture.cloture
#
################################################################################

autoload $(ls $FPATH)
if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.cloture.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de la cloture (`basename $0`)"
logText "Debut de la cloture (`basename $0`)" >> $LOG_FILE
logText "Environnement travaillé : $BIP_ENV"

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "execute pack_batch_cloture.archive_structure"
	execute pack_batch_cloture.archive_structure('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch cloture : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.archive_structure.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.archive_structure.log du jour" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "execute pack_batch_cloture.cloture"
	execute pack_batch_cloture.cloture('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch cloture : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.cloture.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.cloture.log du jour" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

logText "Cloture (`basename $0`)"
logText "Fin de la cloture (`basename $0`)" >> $LOG_FILE

exit 0
