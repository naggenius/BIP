#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : alim_total_jh.sh
# Objet : Shell batch pour alimentation de la table ressource_ecart 
#         a partir de la table CONS_SSTACHE_RES_MOIS
#_______________________________________________________________________________
# Creation :  BAA 02/08/2005
# Modification :
# --------------
# Auteur  Date       Objet
# 
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.ALIM_TOTAL_JH.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de ALIM_TOTAL_JH (`basename $0`)"
logText "Debut de ALIM_TOTAL_JH (`basename $0`)" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	execute PACKBATCH_RESSOURCE_ECART.ALIM_TOTAL_JH('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch ALIM_TOTAL_JH : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.ALIM_TOTAL_JH.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.ALIM_TOTAL_JH.log du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

logText "Fin de ALIM_TOTAL_JH (`basename $0`)"
logText "Fin de ALIM_TOTAL_JH (`basename $0`)" >> $LOG_FILE

exit 0
