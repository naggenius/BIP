#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : suivi_financier.sh
# Objet : 
#       ce script lance la procedure PL/SQL de mise à jour de la table CUMUL_CONSO
#       pour l'extraction Suivi financier des projets en coût réel 
#	=>Contrôle de gestion/Export sur PC/Suivi financier
#_______________________________________________________________________________
# Creation : NBM  21/11/2003 
# Modification :
# --------------
# Auteur        Date            Objet
#
################################################################################
autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.suivi_financier.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de suivi_financier (`basename $0`)"
logText "Debut de suivi_financier (`basename $0`)" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
        whenever sqlerror exit failure;
        execute pack_batch_suivfin.selection('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
        logText "Problème SQL*PLUS dans batch suivi finiancier pack_batch_suivfin : consulter $LOG_FILE"
        logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
        exit -1;
fi

logText "Fin de suivi_financier (`basename $0`)"
logText "Fin de suivi_financier.sh (`basename $0`)" >> $LOG_FILE


exit O

