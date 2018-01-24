#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : ebis_alim_contrat_ressouce_logs.sh
# Objet : Shell batch pour alimenter la table contrat_ressouce_logs
#       
#_______________________________________________________________________________
# Creation :  BAA 06/03/2007
# Modification :
# --------------
# Auteur  Date       Objet
# 
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.EBIS_CONTRAT_RESSOURCE_LOGS.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi
# COMMENTE  UTILISE QUE POUR LES TESTS EN DEV
#export LOG_FILE=/utl_file_dir/bip/bipl2/utl_file/17042007ressourcelogs.log

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de EBIS_CONTRAT_RESSOURCE_LOGS (`basename $0`)"
logText "Debut de EBIS_CONTRAT_RESSOURCE_LOGS (`basename $0`)" >> $LOG_FILE


#UTILISE POUR TESTS EN DEV
#execute PACK_EXPENSEBIS.CONTRAT_RESSOURCE_LOGS('/utl_file_dir/bip/bipl2/utl_file');

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	execute PACK_EXPENSEBIS.CONTRAT_RESSOURCE_LOGS('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch EBIS_CONTRAT_RESSOURCE_LOGS : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.EBIS_CONTRAT_RESSOURCE_LOGS.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.EBIS_CONTRAT_RESSOURCE_LOGS.log du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

logText "Fin de EBIS_CONTRAT_RESSOURCE_LOGS (`basename $0`)"
logText "Fin de EBIS_CONTRAT_RESSOURCE_LOGS (`basename $0`)" >> $LOG_FILE

exit 0
