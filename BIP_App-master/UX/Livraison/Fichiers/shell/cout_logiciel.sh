#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : maj_cout_logiciel.sh
# Objet : Shell batch pour mettre a jour les montants des logiciels de la table
#         SITU_RESS d'apres la table COUT_STD2
#
#
#_______________________________________________________________________________
# Creation :  AJ 21/07/2005
# Modification :
# --------------
# Auteur  Date       Objet
# PPR     01/03/06   Rajout d'un > pour éviter d'écraser le fichier de log
# 
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.maj_cout_logiciel.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de maj cout logiciel dans table SITU_RESS (`basename $0`)"
logText "Debut de maj cout logiciel dans table SITU_RESS (`basename $0`)" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
#sqlplus -s bip/bip@bipl2 <<! >> $LOG_FILE 2>&1
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
        whenever sqlerror exit failure;
        execute PACKBATCH_COUTLOGICIEL.maj_cout('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
        logText "Probl\350me SQL*PLUS dans batch synthese : consulter $LOG_FILE"
        logText "et le fichier $PL_LOGS/AAAA.MM.JJ.synthese.log du jour"
        logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.synthese.log du jou
r"
        logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
        exit -1;
fi

logText "Fin de  maj cout logiciel dans table SITU_RESS(`basename $0`)"
logText "Fin de maj cout logiciel dans table SITU_RESS(`basename $0`)" >> $LOG_FILE

exit 0
