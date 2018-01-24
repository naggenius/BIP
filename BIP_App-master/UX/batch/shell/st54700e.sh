#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : st54700e.sh
# Objet : SHELL batch ST54700E (Mensuelle)
#
#_______________________________________________________________________________
# Creation : M. LECLERC 22/03/1999
# Modification :
# --------------
# Auteur  Date       Objet
# HTM     02/06/00   Récupération USERID/PASSWORD à partir
#                    variables environnement
# ODU     05/12/01   Changement de fichier log
# EGR     15/10/02   Migration ksh sur SOLARIS 8
#
################################################################################
autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.st54700e.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de ST54700E (`basename $0`)"
logText "Debut de ST54700E (`basename $0`)" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "execute packbatch.ST54700E"
	execute packbatch.ST54700E('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch ST54700E : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.ST54700E.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.ST54700E.log du jour" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

logText "ST54700E (`basename $0`)"
logText "Fin de ST54700E (`basename $0`)" >> $LOG_FILE

exit 0
