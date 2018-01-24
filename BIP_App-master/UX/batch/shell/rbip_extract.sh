#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : rbip_extract.sh
# Objet : SHELL d'extraction des fichiers de remontee de la base
#			dans un fichier à alimenter pour les mensuelles
#
#_______________________________________________________________________________
# Creation : E. GREVREND 26/08/2004
# Modification :
# --------------
# Auteur  Date       Objet
#
################################################################################

autoload $(ls $FPATH)
set -x
# Trace de l'execution du batch
if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.rbip_extract.log
rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de rbip_extract (`basename $0`)"
logText "Debut de rbip_extract (`basename $0`)" >> $LOG_FILE

#BIP_DATA_REMONTEE=$ORA_LIVE_UTL_BATCH

FICHIER_OUT=$FILE_RBIPINTRA.dmp
logText "Le fichier de destination est $BIP_DATA_REMONTEE/$FICHIER_OUT"

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
        whenever sqlerror exit failure;
        !echo "execute pack_batch_remontee.build_fichier_remontee"
        execute pack_batch_remontee.build_fichier_remontee('$PL_LOGS', '$PL_DATA', '$FICHIER_OUT');
!
#execute pack_batch_remontee.build_fichier_remontee('$PL_LOGS', '$BIP_DATA_REMONTEE', '$FICHIER_OUT');
# valeur de sortie de SQL*PLUS

PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
        logText "Problème SQL*PLUS dans batch rbip_extract : consulter $LOG_FILE"
        logText "et le fichier $PL_LOGS/AAAA.MM.JJ.rbip_extract.log du jour"
        logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.rbip_extract.log du jour" >> $LOG_FILE
        logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
        exit -1;
fi

logText "On recopie le fichier de sortie dans le fichier final : $BIP_DATA_REMONTEE/$FICHIER_OUT => $BIP_DATA_REMONTEE/$FILE_RBIPINTRA"
logText "On recopie le fichier de sortie dans le fichier final : $BIP_DATA_REMONTEE/$FICHIER_OUT => $BIP_DATA_REMONTEE/$FILE_RBIPINTRA" >> $LOG_FILE
cp $DIR_BATCH_DATA/$FICHIER_OUT $BIP_DATA_REMONTEE/$FILE_RBIPINTRA >> $LOG_FILE 2>&1
#cp $BIP_DATA_REMONTEE/$FICHIER_OUT $BIP_DATA_REMONTEE/$FILE_RBIPINTRA >> $LOG_FILE 2>&1
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
        logText "Problème dans la recopie du fichier"
        logText "Problème dans la recopie du fichier" >> $LOG_FILE
        logText "Code erreur : <$CMD_EXIT>" >> $LOG_FILE
        exit -1;
fi

logText "rbip_extract (`basename $0`)"
logText "Fin de rbip_extract (`basename $0`)" >> $LOG_FILE

exit 0
