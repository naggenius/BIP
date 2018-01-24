#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : debfintrait.sh
# Objet : batch DEBFINTRAIT (1pr\351 2pr\351 et Mensuelle)
#
# Parametres d'entree :
#	$1	Type de traitement 'FIN' ou 'DEBUT'
#
#_______________________________________________________________________________
# Creation : ???
# Modification :
# --------------
# Auteur  Date       Objet
# HTM     02/06/00   R\351cup\351ration USERID/PASSWORD \340 partir
#                    variables environnement
# ODU     05/12/01   Changement de fichier log
# EGR     14/10/02   Migration ksh SOLARIS 8
#
################################################################################

autoload $(ls $FPATH)
set -x
# Trace de l'execution du batch
if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.debfintrait.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de DEBFINTRAIT (`basename $0`)"
logText "Debut de DEBFINTRAIT (`basename $0`)" >> $LOG_FILE

if [ $# -ne 1 ]
then
	logText "Mauvais nombre d'arguments" >&2
	logText "Usage `basename $0` TYPE_TRAITEMENT" >&2
	logText "Mauvais nombre d'arguments" >> $LOG_FILE
	logText "Usage `basename $0` TYPE_TRAITEMENT" >> $LOG_FILE
	exit -1
else
	TYPE_TRAIT=$1
	logText "| Type de Traitement : $TYPE_TRAIT"
	logText "| Type de Traitement : $TYPE_TRAIT" >> $LOG_FILE
fi

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "execute packbatch2.DEBFINTRAIT"
	execute packbatch2.DEBFINTRAIT('$PL_LOGS','$TYPE_TRAIT');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch DEBFINTRAIT : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.DEBFINTRAIT.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.DEBFINTRAIT.log du jour" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

logText "DEBFINTRAIT (`basename $0`)"
logText "Fin de DEBFINTRAIT (`basename $0`)" >> $LOG_FILE

exit 0
