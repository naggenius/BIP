#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : synthese_premensuelle.sh
# Objet : Shell batch pour alimenter la tables de synthese SYNTHESE_ACTIVITE_MOIS
#          lors des deux traitements de pré-mensuelle
#
#_______________________________________________________________________________
# Creation :  PPR 27/09/2005
# Modification :
# --------------
# Auteur  Date       Objet
# 
#
################################################################################


if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.synthesepremensuelle.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de synthese premensuelle (`basename $0`)"
logText "Debut de synthese premensuelle (`basename $0`)" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	execute PACKBATCH_RA.SYNTHESE_PREMENSUELLE('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch synthesepremensuelle : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.synthesepremensuelle.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.synthesepremensuelle.log du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

logText "Fin de synthese premensuelle (`basename $0`)"
logText "Fin de synthese premensuelle (`basename $0`)" >> $LOG_FILE

exit 0
