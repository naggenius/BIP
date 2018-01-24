#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : ebis_export_realise.sh
# Objet : 
#       ce script recupere lance la procedure PL/SQL de generation des fichiers
#       d'export réalisé pour le flux bip -> expensebis
#
#_______________________________________________________________________________
# Creation : Equipe BIP (BAA)  13/03/2007
# Modification :
# --------------
# Auteur        Date            Objet
# Alves Julio 13-04-2007 : modification script 
# JAL            19-03-2008 : fiche 613 : ajout log des Time Tracking non ramassés
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.ebis_export_realise.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de ebis_export_realise (`basename $0`)"
logText "Debut de ebis_export_realise (`basename $0`)" >> $LOG_FILE


#Répertoire d'extraction 
REP_EXTRACT=$PL_EMISSION

nom_fic=$EBIS_FIC_REALISE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
        whenever sqlerror exit failure;
        !echo "execute pack_expensebis.ebis_export_realise"
        exec pack_expensebis.export_realise('$REP_EXTRACT','$nom_fic')
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
        logText "Problème SQL*PLUS dans batch ebis_export_realise : consulter $LOG_FILE"
        logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
        exit -1;
fi


#Appel récupération Time Tracking EBIS non ramassés par procédure précédente (fiche 613)
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
        whenever sqlerror exit failure;
        !echo "execute pack_expensebis.export_tt_rejet"
        exec pack_expensebis.export_tt_rejet( '$REP_EXTRACT','$nom_fic')
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
        logText "Problème SQL*PLUS dans batch export_ttebis : consulter $LOG_FILE"
        logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
        exit -1;
fi



logText "ebis_export_realise (`basename $0`)"
logText "Fin de ebis_export_realise.sh (`basename $0`)" >> $LOG_FILE


exit O

