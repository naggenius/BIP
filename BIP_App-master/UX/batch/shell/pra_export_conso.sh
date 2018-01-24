#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : pra_export_conso.sh
# Objet : 
#       ce script recupere lance la procedure PL/SQL de generation des fichiers
#       d'export réalisé pour le flux bip -> prestachats
#
#_______________________________________________________________________________
# Creation : Equipe BIP (BAA)  28/06/2012
# Modification :
# --------------
# Auteur        Date            Objet
# 		 
# 
#
################################################################################

set -x
autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.pra_export_conso.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de pra_export_conso (`basename $0`)"
logText "Debut de pra_export_conso (`basename $0`)" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
        whenever sqlerror exit failure;
        !echo "execute pack_pra_conso.export_pra_conso"
        exec pack_pra_conso.export_pra_conso('$PL_EMISSION','$PRA_CONSO')
!

#cp $PL_EMISSION/$PRA_CONSO $DIR_PRA_CONSO
#mv $PL_EMISSION/$PRA_CONSO $EMISSION

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
        logText "Problème SQL*PLUS dans batch pra_export_conso : consulter $LOG_FILE"
        logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
        exit -1;
fi


logText "pra_export_conso (`basename $0`)"
logText "Fin de pra_export_conso.sh (`basename $0`)" >> $LOG_FILE


exit O

