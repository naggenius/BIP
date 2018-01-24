#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : cloture_ias.sh
# Objet : Shell qui met � jour les tables stock_fi_dec et stock_immo_dec lors de la cloture
#
#_______________________________________________________________________________
# Creation :  NBM 09/12/2003
# Modification :
# --------------
# Auteur  Date       Objet
# 
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.CLOTURE_IAS.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de CLOTURE_IAS (`basename $0`)"
logText "Debut de CLOTURE_IAS (`basename $0`)" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	execute PACKBATCH_IAS.CLOTURE('$PL_LOGS');
	
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Probl�me SQL*PLUS dans cloture IAS : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.IAS.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.IAS.log du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi


logText "Fin de CLOTURE_IAS (`basename $0`)"
logText "Fin de CLOTURE_IAS (`basename $0`)" >> $LOG_FILE

exit 0
