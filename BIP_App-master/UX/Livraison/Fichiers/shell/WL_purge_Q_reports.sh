#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : WL_purge_Q_reports.sh
# Objet : purge des fichiers crees par Oracle Reports Server cote intranet
#
# Parametres d'entree :
#       $1  : delai en nombre de jours
#
#_______________________________________________________________________________
# Creation :
# EGR     08/10/03
#
# Modification :
# --------------
# Auteur  Date       Objet
# E.GREVREND	  19/10/04	MAJ WLS7
# A.SAKHRAOUI     03/04/07      MAJ WLS9   
#
################################################################################

#################################################
# On charge l'environnement
#################################################

autoload $(ls $FPATH)

. /applis/bip_wl9/bip9dom/WL_bipparam.sh

if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.WL_purge_Q_reports.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi



if [ $# -ne 1 ]
then
        logText "Mauvais nombre d'arguments" >&2
        logText "Usage `basename $0` DELAI_JOURS" >&2
        logText "Mauvais nombre d'arguments" >> $LOG_FILE
        logText "Usage `basename $0` DELAI_JOURS" >> $LOG_FILE
        exit -1
else
        DELAI=$1
        logText "| Delai jours : $DELAI"
        logText "| Delai jours : $DELAI" >> $LOG_FILE
fi

. /applis/bip_wl9/bip9dom/.WL_profile.oracle UTILITIES
#################################################

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE

REPERTOIRE=$DIR_REPORT_OUT
$DIR_BATCH_SHELL/WL_purge_repertoire.sh J $REPERTOIRE $DELAI 2>> $LOG_FILE
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
        logText "Echec lors de la purge des fichiers"
        logText "arrêt du batch `basename $0`"
        exit 1;
fi

sqlplus -s $CONNECT_STRING <<!   >>$LOG_FILE   2>&1
        whenever sqlerror exit failure;
        set linesize 1000
        set pages 1000

        select '###########################################################################' as INFO from dual;
        select '# Editions ################################################################' as INFO from dual;
        select '###########################################################################' as INFO from dual;

        select 'Contenu de la table trait_asynchrone Editions AVANT la purge' as INFO from dual;
        select userid, titre, nom_fichier, statut, to_char(date_trait,'DD/MM/YYYY HH24:MI:SS') as date_trait from trait_asynchrone
                where  type = 'E' order by date_trait;

        execute pack_asynchrone.purge_async($DELAI,'E');
        select 'Contenu de la table trait_asynchrone Editions APRES la purge' as INFO from dual;
        select userid, titre, nom_fichier, statut, to_char(date_trait,'DD/MM/YYYY HH24:MI:SS') as date_trait from trait_asynchrone
                where  type = 'E' order by date_trait;

        select '###########################################################################' as INFO from dual;
        select '# eXtractions #############################################################' as INFO from dual;
        select '###########################################################################' as INFO from dual;

        select 'Contenu de la table trait_asynchrone Extractions AVANT la purge' as INFO from dual;
        select userid, titre, nom_fichier, statut, to_char(date_trait,'DD/MM/YYYY HH24:MI:SS') as date_trait from trait_asynchrone
                where  type = 'X' order by date_trait;

        execute pack_asynchrone.purge_async($DELAI,'X');
        select 'Contenu de la table trait_asynchrone Extractions APRES la purge' as INFO from dual;
        select userid, titre, nom_fichier, statut, to_char(date_trait,'DD/MM/YYYY HH24:MI:SS') as date_trait from trait_asynchrone
                where  type = 'X' order by date_trait;
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
        logText "Probleme SQL*PLUS dans batch WL_purge_Q_reports : consulter $LOG_FILE"
        logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
        exit -1;
fi

logText "Fin de la WL_purge_Q_reports.sh"
logText "Fin de la WL_purge_Q_reports.sh" >> $LOG_FILE

exit 0

