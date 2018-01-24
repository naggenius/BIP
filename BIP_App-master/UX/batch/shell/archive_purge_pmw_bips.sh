#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : archive_purge_pmw_bips.sh
# Objet : Shell batch pour archiver les données BIPS lors de la mensuelle
#         Appelé par mensuel.sh        
#_______________________________________________________________________________
# Creation :  SEL 21/03/2016
# Modification :
# --------------
# Auteur  Date       Objet
# 
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.ARCHIVE_PMW_BIPS.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

###################### Archivage et purge de la table PMW_BIPS ####################################

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Procedure ARCHIVE_PURGE_PMW_BIPS (`basename $0`)"
logText "Procedure ARCHIVE_PURGE_PMW_BIPS (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	execute PACK_BATCH_BIPS.ARCHIVE_PURGE_PMW_BIPS('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch ARCHIVE_PURGE_PMW_BIPS : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.ARCHIVE_PURGE_PMW_BIPS.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.ARCHIVE_PURGE_PMW_BIPS.log du jour" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi


logText "Fin de ARCHIVE_PURGE_PMW_BIPS (`basename $0`)"
logText "Fin de ARCHIVE_PURGE_PMW_BIPS (`basename $0`)" >> $LOG_FILE

exit 0
