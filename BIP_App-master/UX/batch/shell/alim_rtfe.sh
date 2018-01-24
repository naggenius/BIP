#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : alim_rtfe.sh
# Objet : Shell batch pour alimenter la table RTFE
#         a partir de la table TMP_RTFE
#_______________________________________________________________________________
# Creation :  BAA 19/10/2005
# Modification :
# --------------
# Auteur  Date       	Objet
# YNI     21/01/2010    Ajout traitement pour ecriture dans quotidienne.txt
#
################################################################################

autoload $(ls $FPATH)

#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.ALIM_RTFE.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi


log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.ALIM_RTFEtmp.txt

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de ALIM_RTFE (`basename $0`)"
logText "Debut de ALIM_RTFE (`basename $0`)" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACKBATCH_RTFE.LOAD_RTFE('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('alim_rtfe.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " alim_rtfe.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	rm -f $log_tmp
	logText "Problème SQL*PLUS dans batch ALIM_RTFE : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.ALIM_RTFE.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.ALIM_RTFE.log du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

datefin=`date +'%d/%m/%Y'`
heurefin=`date +'%T'`
cat $log_tmp >> $LOG_FILE 2>&1
sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('alim_rtfe.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
rm -f $log_tmp
#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
echo " alim_rtfe.sh OK" >> $FILE_QUOTIDIENNE
#Fin YNI
logText "=== Fin NORMALE de ALIMENTATION RTFE : alim_rtfe.sh ===" >> $LOG_FILE

exit 0
