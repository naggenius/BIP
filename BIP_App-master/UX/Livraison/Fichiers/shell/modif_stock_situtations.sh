#_______________________________________________________________________________
# Application Base d'Informations Projets (BIP)
# Nom du fichier : modif_stock_situations.sh
# Objet : Shell batch pour la modification du stock des Situations
#_______________________________________________________________________________
# Creation :  YNI 24/05/2010
# Modification :
# --------------
# Auteur  Date       Objet
# 
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.MODIF_STOCK_SITUATIONS.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de MODIF_STOCK_SITUATIONS (`basename $0`)"
logText "Debut de MODIF_STOCK_SITUATIONS (`basename $0`)" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	execute PACKBATCH_MODIF_STOCK.MODIF_STOCK_SITUATIONS('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch MODIF_STOCK_SITUATIONS : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.MODIF_STOCK_SITUATIONS.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.MODIF_STOCK_SITUATIONS.log du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

logText "Fin de MODIF_STOCK_SITUATIONS (`basename $0`)"
logText "Fin de MODIF_STOCK_SITUATIONS (`basename $0`)" >> $LOG_FILE

exit 0
