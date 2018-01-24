#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : controle_mci.sh
# Objet : Shell de constitution du fichier xxx pour QC 1321 - calcul de la FI 
#         Lancé manuellement
#_______________________________________________________________________________
# Auteur  	Date       		Objet
# BSA     	23/01/2012   		creation
################################################################################
 
autoload $(ls $FPATH)

#YNI Fichier de la quotidienne 
#FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.controle_mci.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.controle_mcitmp.txt 

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

#Répertoire d'extraction : /utl_file_dir/bip/dbipdbip/utl_file/bipdata/batch - Variable a definir dans bipparam.sh
#
REP_EXTRACT=$PL_LOGS

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de controle_mci : controle_mci.sh" >> $LOG_FILE

# construction du nom du fichier
nom_fic_csv=$nom_fic_csv_mci
nom_fic_count=$nom_fic_count_mci
#nom_fic=truc.csv
logText "Fichier = $nom_fic_csv" >> $LOG_FILE
logText "Fichier = $nom_fic_count" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	!echo "PACKBATCH_CONTROLE_MCI.traitement"
	exec PACKBATCH_CONTROLE_MCI.traitement('$REP_EXTRACT', '$nom_fic_csv', '$nom_fic_count')
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
	insert into BATCH_LOGS_BIP values ('controle_mci.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	#echo " controle_mci.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Probleme SQL*PLUS dans controle_mci pour la generation du fichier" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	rm -f $log_tmp
	logText "=== ERREUR : Fin ANORMALE de controle_mci : controle_mci.sh ===" >> $LOG_FILE
	exit -1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	nom_fichier=$REP_EXTRACT/$nom_fic_csv
	nbligne=`awk 'END {print NR}' $nom_fichier`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('controle_mci.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,'$nbligne',0, 'OK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	#echo " controle_mci.sh OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
	rm -f $log_tmp
	logText "=== Fin NORMALE de controle_mci : controle_mci.sh ===" >> $LOG_FILE
fi


exit 0
