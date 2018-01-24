#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : appli.sh
# Objet : Shell-script d'import des données dans la table appplication
#
# Parametres d'entree:
#	$1	Fichier log (facultatif)
#
#_______________________________________________________________________________
# Creation : MM CURE 16/06/2004 
# ABA     01/04/2008    Ajout traitement pour affichage des logs via l'ihm bip
# YNI     21/01/2010    Ajout traitement pour ecriture dans quotidienne.txt
################################################################################


autoload $(ls $FPATH)

#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

# fonction pour la creation de l'index
function creation_index {
logText "sqlplus" >> $LOG_FILE
# creation de l'index sur TMP_APPLI.AIRT
sqlplus -s $CONNECT_STRING << EOF >> $LOG_FILE 2>&1
        whenever sqlerror exit failure;
        !echo "CREATE INDEX tmp_appli_idx1"
        CREATE INDEX TMP_APPLI_IDX1 ON TMP_APPLI(AIRT) ;
EOF
}

# Fichier log
if [ $# -eq 0 ]
then
	if [ -z $LOG_TRAITEMENT ]
	then
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.appli.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi
else
	LOG_FILE=$1
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.applitmp.txt
statuttmp=0

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'import des applications  : appli.sh" >> $LOG_FILE

logText "--  Verification de la presence du fichier TRANSTOM.HBIPF.RDC38320.D0138411.DXXXXX "
logText "--  Verification de la presence du fichier TRANSTOM.HBIPF.RDC38320.D0138411.DXXXXX " >> $LOG_FILE

# test de l'existence du fichier TRANSTOM.HBIPF.RDC38320.D0138411.DXXXXX
#DATA_FILE=TRANSTOM.HBIPF.RDC38320.D0138411.DXXXXX

#referentiel ES
DATA_FILE_APPLI=`ls -tr $FILE_APPLI |tail -1`
if [ -a $DATA_FILE_APPLI ]
then logText "Fichier application.dat detecte, Lancement de appli.sh" >> $LOG_FILE

# suppression de l'index sur TMP_APPLI.AIRT 
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "DROP INDEX tmp_appli_idx1"
	DROP INDEX TMP_APPLI_IDX1;
EOF

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de destruction de l'index tmp_appli_idx1" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	#exit -1
fi

logText "SQL*Load des applications"
logText "SQL*Load des applications" >> $LOG_FILE

LOGLOAD_FILE=$DIR_SQLLOADER_LOG/`date +"%Y%m%d"`.appli
BAD_FILE=$LOGLOAD_FILE.bad
DSC_FILE=$LOGLOAD_FILE.dsc
LOGLOAD_FILE=$LOGLOAD_FILE.logload

# chargement des donnees depuis le fichier
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/appli.par \
	control=$DIR_SQLLOADER_PARAM/appli.ctl \
	data=$DATA_FILE_APPLI \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	discard=$DSC_FILE >> $LOG_FILE 2>&1

# valeur de sortie de SQL*LOAD
LOAD_EXIT=$?
# si le loader retourne 0, il faut verifier qu'il n'y a pas de codes erreurs 
# dans le fichier de log
if [ $LOAD_EXIT -ne 0 ] 
then
	statuttmp=1
	echo "Erreur de chargement des application SQL*Loader" >> $log_tmp
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de chargement des applications avec SQL*Loader" >> $LOG_FILE
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
        creation_index
	exit -2
fi
logText "SQL*Load des applications Termine"
logText "SQL*Load des applications Termine" >> $LOG_FILE

#on compte le nombre de ligne
nbligne=`awk 'END {print NR}' $DATA_FILE_APPLI`

#on deplace le fichier apres traitement
DATA_FILE_APPLI2=`echo $DATA_FILE_APPLI | cut -d'/' -f5`
mv $DATA_FILE_APPLI $DIR_BATCH_DATA/$DATA_FILE_APPLI2
 
# maj des situations des ressources en fonction de leur niveau 
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	!echo "exec pack_appli.alim_appli"
	exec pack_appli.alim_appli;
EOF

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('appli.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,'$nbligne', 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " appli.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de correction des applications sous SQL*Plus" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
         creation_index
	rm -f $log_tmp
	logText "=== ERREUR : Fin ANORMALE du traitement d importation des applications : appli.sh. ===" >> $LOG_FILE
	#exit -3
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	if [ $statuttmp -eq 1 ]
	then
		statut='NOK'
		varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
		logText "=== ERREUR Fin NORMALE du traitement d importation des applications : appli.sh. ===" >> $LOG_FILE
		#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
		echo " appli.sh ECHEC" >> $FILE_QUOTIDIENNE
		#Fin YNI
	else
		statut='OK'
		logText "Fin NORMALE du traitement d importation des applications : appli.sh. ===" >> $LOG_FILE
		#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
		echo " appli.sh OK" >> $FILE_QUOTIDIENNE
		#Fin YNI
	fi
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('appli.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,'$nbligne', '$statut');
EOF
	rm -f $log_tmp
	
fi

creation_index

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de creation de l'index tmp_appli_idx1" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	#exit -4
fi

logText "Fin de Import des applications (`basename $0`)"
logText "Fin de Import des applications (`basename $0`)" >> $LOG_FILE

else
	echo " Fichier application.dat non detecte. Pas d insertion des donnees dans TMP_APPLI !!!" >> $log_tmp
	echo " Pas de traitement d insertion des applications ." >> $log_tmp
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('appli.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	rm -f $log_tmp
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " appli.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText " Fichier non detecte. Pas d insertion des donnees dans TMP_APPLI !!!" >> $LOG_FILE
	logText " ERREUR : Fin ANORMALE du traitement d insertion des applications." >> $LOG_FILE
    logText " Fichier non detecte. Pas d insertion des donnees dans TMP_APPLI !!!"
  
fi

exit 0
