#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : historique_prelude.sh
# Objet : Shell de gestion du processus d'historisation
#
#_______________________________________________________________________________
# Creation : Equipe SOPRA 24/02/2000
# Modification :
# --------------
# Auteur  Date       Objet
# SOPRA   06/05/00   Generer le schema de sauvegarde si on n'a pas atteint les 14 schemas
# HTM     02/06/00   Récupération USERID/PASSWORD à partir
#                    variables environnement
# EGR     14/10/02   Migration ksh SOLARIS 8
#                    Ajout exit 0 en fin de traitement
# EGR     22/10/02   les logs dans $DIR_BATCH_SHELL_LOG
#
################################################################################


if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.historique_prelude.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de historique_prelude (`basename $0`)"
logText "Debut de historique_prelude (`basename $0`)" >> $LOG_FILE

logText "-- Generation du schema de sauvegarde ------------------------------------------"
logText "-- Generation du schema de sauvegarde ------------------------------------------" >> $LOG_FILE
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "execute pack_schema_histo.ajout_schema"
	execute pack_schema_histo.ajout_schema('$PL_LOGS');
!

PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS lors de l'execution de pack_schema_histo.ajout_schema : consulter $LOG_FILE"
	logText "Erreur d'execution de pack_schema_histo.ajout_schema : <$PLUS_EXIT>" >> $LOG_FILE
	exit 1;
fi

logText "historique_prelude (`basename $0`)"
logText "Fin du traitement Historique_prelude (`basename $0`)" >> $LOG_FILE

exit 0
