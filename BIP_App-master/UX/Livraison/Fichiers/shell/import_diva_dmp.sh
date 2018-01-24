#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets (BIP)
# Nom du fichier : import_diva_dmp.sh
# Objet : Shell batch pour alimentation de la table DMP_RESEAUXFRANCE 
#         a partir d'un flux reçu du DIVA
#_______________________________________________________________________________
# Creation :  DDI 01/09/2015
# Modification :
# --------------
# Auteur  Date       Objet
# ZAA  	  01092015  PPM 61919
#
################################################################################


autoload $(ls $FPATH)

#YNI Fichier de la quotidienne
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

# Fichier log
# ############

	if [ -z $LOG_TRAITEMENT ]
	then
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_diva_dmp.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_diva_dmptmp.txt
statuttmp=0

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

FILE_IMPORT_DMP=$RECEPTION/$FILE_DIVA_DMP
FILE_IMPORT_DMP_TMP=$RECEPTION/FILE_IMPORT_DMP_TEMP.RECU

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'import des dmp DIVA : import_diva_dmp.sh" >> $LOG_FILE

logText "--  Verification de la presence du fichier"
logText "--  Verification de la presence du fichier" >> $LOG_FILE

# Test de l'existence du fichier ????????????.csv
# ################################################

if [ -a $FILE_IMPORT_DMP ]
then
#Periode de prise en compte du fichier DIVA
logText "Fichier detecte, Lancement de import_diva_dmp.sh" >> $LOG_FILE

logText "SQL*Load des dmp depuis DIVA"
logText "SQL*Load des dmp depuis DIVA" >> $LOG_FILE

LOGLOAD_FILE=$LOG_FILE
BAD_FILE=$LOG_FILE.1.bad
DSC_FILE=$LOG_FILE.1.dsc
LOGLOAD_FILE=$LOG_FILE.1.logload

###################################################################################################
# On défini un doublon uniquement lorsque 
# Nous avons plus d’une fois le trio : Numéro de demande,Numéro dpcopi,	Numéro projet                
# On supprime les doublon du fichier en entrée
###################################################################################################

awk '!x[$1,$6,$7]++' FS=';' $FILE_IMPORT_DMP > $FILE_IMPORT_DMP_TMP

##################################################
# Chargement des dmp dans la table temporaire
# ################################################
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/loadDIVA_DMP.par \
	control=$DIR_SQLLOADER_PARAM/loadDIVA_DMP.ctl \
	data=$FILE_IMPORT_DMP_TMP \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	discard=$DSC_FILE >> $LOG_FILE 2>&1

# Valeur de sortie de SQL*LOAD
# #############################
LOAD_EXIT=$?
# si le loader retourne 0 ou 2, il faut verifier qu'il n'y a pas de codes erreurs
# dans le fichier de log
if [ $LOAD_EXIT -ne 0 ]
then
	statuttmp=1
	logText "Erreur : consulter $LOG_FILE"
	echo "Erreur de chargement des dmp DIVA SQL*Loader" >> $log_tmp
	logText "Erreur de chargement des dmp DIVA SQL*Loader" >> $LOG_FILE
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE

fi
logText "SQL*Load des dmp DIVA Termine"
logText "SQL*Load des dmp DIVA Termine" >> $LOG_FILE


# on deplace le fichier apres traitement
# ####################################
mv $FILE_IMPORT_DMP  $DIR_BATCH_DATA/$FILE_DIVA_DMP
# on supprime le fichier de chargement temporaire qui ne contient pas de doublon apres traitement
# ###############################################################################################
rm -f $FILE_IMPORT_DMP_TMP
# MAJ des donnees dmp
# ############################
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	!echo "exec pack_diva.global_diva_dmp"
	execute pack_diva.global_diva_dmp('PL_LOGS');
EOF

# Valeur de sortie de SQL*PLUS
# #############################
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
    datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	nom_fichier=$DIR_BATCH_DATA/$FILE_DIVA_DMP
	nbligne=`awk 'END {print NR}' $nom_fichier`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_diva_dmp.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,'$nbligne', 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " import_diva_dmp.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Erreur : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.import_diva_dmp.log du jour"
	logText "Erreur de maj des dmp DIVA sous SQL*Plus" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	rm -f $log_tmp
	logText "=== ERREUR : Fin ANORMALE du traitement d insertion des donnees dmp en provenance de DIVA : import_diva_dmp.sh. ===" >> $LOG_FILE
	exit -1
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	if [ $statuttmp -eq 1 ]
	then
		statut='NOK'
		varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
		logText "=== ERREUR Fin NORMALE du traitement d insertion des donnees dmp en provenance de DIVA : import_diva_dmp.sh. ===" >> $LOG_FILE
		#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
		echo " import_diva_dmp.sh ECHEC" >> $FILE_QUOTIDIENNE
		#Fin YNI
	else
		statut='OK'
		logText "=== Fin NORMALE du traitement d insertion des donnees dmp en provenance de DIVA : import_diva_dmp.sh. ===" >> $LOG_FILE
		#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
		echo " import_diva_dmp.sh OK" >> $FILE_QUOTIDIENNE
		#Fin YNI
	fi
	nom_fichier=$DIR_BATCH_DATA/$FILE_DIVA_DMP
	nbligne=`awk 'END {print NR}' $nom_fichier`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_diva_dmp.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,'$nbligne', '$statut');
EOF
	rm -f $log_tmp
fi
else
	echo " Fichier DIVA non detecte. Pas d insertion des donnees dans DMP_RESEAUXFRANCE  !!!" >> $log_tmp
	echo " ERREUR : Fin ANORMALE du traitement d insertion des donnees dmp en provenance de DIVA." >> $log_tmp
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_diva_dmp.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
		#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
		echo " import_diva_dmp.sh ECHEC" >> $FILE_QUOTIDIENNE
		#Fin YNI
		logText " Fichier DIVA non detecte. Pas d insertion des donnees dans DMP_RESEAUXFRANCE  !!!"
		logText " Fichier DIVA non detecte. Pas d insertion des donnees dans DMP_RESEAUXFRANCE  !!!" >> $LOG_FILE
		logText "------------------------------------------------------------------------------------" >> $LOG_FILE
		logText "=== ERREUR : Fin ANORMALE du traitement d insertion des donnees dmp en provenance de DIVA. ==="
		logText "=== ERREUR : Fin ANORMALE du traitement d insertion des donnees dmp en provenance de DIVA : import_diva_dmp.sh. ===" >> $LOG_FILE
		logText "------------------------------------------------------------------------------------" >> $LOG_FILE
	rm -f $log_tmp
fi

exit 0


