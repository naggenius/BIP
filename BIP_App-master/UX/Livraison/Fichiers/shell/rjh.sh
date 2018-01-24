#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : rjh.sh
# Objet : Shell batch pour lancer le traitement de répartition
#       
#_______________________________________________________________________________
# Creation :  BAA 03/11/2005
# Modification :
# --------------
# Auteur  Date       Objet
# 
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.RJH.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de RJH (`basename $0`)"
logText "Debut de RJH (`basename $0`)" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	execute PACKBATCH_REPARTITION.ALIM_RJH('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch RJH : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.RJH.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.RJH.log du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

logText "Fin de RJH (`basename $0`)"
logText "Fin de RJH (`basename $0`)" >> $LOG_FILE

exit 0
