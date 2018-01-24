#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : st54700b.sh
# Objet : SHELL batch ST54700B (Mensuelle)
#
#_______________________________________________________________________________
# Creation : M. LECLERC 12/03/1999
# Modification :
# --------------
# Auteur  Date       Objet
# HTM     02/06/00   Récupération USERID/PASSWORD à partir
#                    variables environnement
# EGR     15/10/02   Migration ksh sur SOLARIS 8
#
################################################################################
autoload $(ls $FPATH)

# Trace de l'execution du batch
if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.st54700b.result
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de ST54700B (`basename $0`)"
logText "Debut de ST54700B (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "execute packbatch.ST54700B"
	execute packbatch.ST54700B('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch ST54700B : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.ST54700B.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.ST54700B.log du jour" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

logText "ST54700B (`basename $0`)"
logText "Fin de ST54700B (`basename $0`)" >> $LOG_FILE

exit 0
