#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : archive_cloture.sh
# Objet : Shell batch pour archiver les données lors de la cloture
#         Appelé par traitannuel.sh        
#_______________________________________________________________________________
# Creation :  PPR 16/11/2005
# Modification :
# --------------
# Auteur  Date       Objet
# 
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.ARCHIVE_CLOTURE.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de ARCHIVE_CLOTURE (`basename $0`)"
logText "Debut de ARCHIVE_CLOTURE (`basename $0`)" >> $LOG_FILE

###################### Archivage des ressources ####################################

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Procedure archive_ressources (`basename $0`)"
logText "Procedure archive_ressources (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	execute PACK_ARCHIVE_RESSOURCES.ARCHIVE_RESSOURCES('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch ARCHIVE_CLOTURE : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.ARCHIVE_RESSOURCES.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.ARCHIVE_RESSOURCES.log du jour" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

###################### Archivage des tables ####################################

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Procedure archive_tables (`basename $0`)"
logText "Procedure archive_tables (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	execute PACK_ARCHIVE_TABLES.ARCHIVE_TABLES('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch ARCHIVE_CLOTURE : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.ARCHIVE_TABLES.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.ARCHIVE_TABLES.log du jour" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

###################### Purge des tables ####################################

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Procedure archive_purge (`basename $0`)"
logText "Procedure archive_purge (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	execute PACK_ARCHIVE_PURGE.ARCHIVE_PURGE('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch ARCHIVE_CLOTURE : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.ARCHIVE_PURGE.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.ARCHIVE_PURGE.log du jour" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

###################### Purge des archives ####################################

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Procedure archive_archives (`basename $0`)"
logText "Procedure archive_archives (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	execute PACK_ARCHIVE_ARCHIVES.ARCHIVE_ARCHIVES('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch ARCHIVE_CLOTURE : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.ARCHIVE_ARCHIVES.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.ARCHIVE_ARCHIVES.log du jour" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi


logText "Fin de ARCHIVE_CLOTURE (`basename $0`)"
logText "Fin de ARCHIVE_CLOTURE (`basename $0`)" >> $LOG_FILE

exit 0
