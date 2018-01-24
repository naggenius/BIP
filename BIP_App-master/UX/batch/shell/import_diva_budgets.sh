#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : import_diva_budgets.sh
# Objet : Shell-script d'import des donnees budgetaires 
#         provenant de l'application DIVA.
#
# Parametres d'entree:
#	$1	Fichier log (facultatif)
#_______________________________________________________________________________
# Creation     : David DEDIEU 16/08/2006
#_______________________________________________________________________________
# Modification : 
# JAL 		04/03/2008 		modification message de fin si pas de fichier reçu 
# ABA   	01/04/2008    	Ajout traitement pour affichage des logs via l'ihm bip
# YNI     	21/01/2010    	Ajout traitement pour ecriture dans quotidienne.txt
# YNI		12/03/2010		FDT 897: Ajout traitement annuel DIVA
################################################################################

autoload $(ls $FPATH)

#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

# Fichier log
# ############

	if [ -z $LOG_TRAITEMENT ]
	then
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_diva_budgets.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_diva_budgetstmp.txt
statuttmp=0
	
datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

FILE_IMPORT_BUDGETS=$RECEPTION/$FILE_DIVA_BUDGET    

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'import des budgets DIVA : import_diva_budget.sh" >> $LOG_FILE

logText "--  Verification de la presence du fichier"
logText "--  Verification de la presence du fichier" >> $LOG_FILE

# Test de l'existence du fichier ????????????.csv
# ################################################

if [ -a $FILE_IMPORT_BUDGETS ] 
then 

# YNI FDT 879 Test pour la prise en compte du fichier DIVA

# Date du jour en cours
dateJour=`date +'%Y%m%d'`
# Date CCLOTURE + 1 jour
		dateCCloture=`sqlplus -s $CONNECT_STRING << ! 
		set head off 
		select to_char(max(CCLOTURE)+1,'YYYYMMDD') from calendrier;
		!` 	
# Date du premier jour de l'annee en cours (en realité le second) 
echo $dateCCloture
datePremierJour=`expr "$dateCCloture" : '\(.....\)'`'0102'
echo $datePremierJour
logText "Date du jour : $dateJour" >> $LOG_FILE
logText "Date premier jour : $datePremierJour" >> $LOG_FILE
logText "Date cloture : $dateCCloture" >> $LOG_FILE
if [ $dateJour -ge $datePremierJour ] && [ $dateJour -le $dateCCloture ]
then

#Periode de non prise en compte du fichier DIVA
logText "Periode de non prise en compte du fichier DIVA"
logText "Periode de non prise en compte du fichier DIVA" >> $LOG_FILE
# on deplace le fichier apres traitement
# ####################################
mv $FILE_IMPORT_BUDGETS  $DIR_BATCH_DATA/$FILE_DIVA_BUDGET 


else
#Periode de prise en compte du fichier DIVA
logText "Fichier detecte, Lancement de import_diva_budgets.sh" >> $LOG_FILE

logText "SQL*Load des budgets depuis DIVA"
logText "SQL*Load des budgets depuis DIVA" >> $LOG_FILE

LOGLOAD_FILE=$LOG_FILE
BAD_FILE=$LOG_FILE.1.bad
DSC_FILE=$LOG_FILE.1.dsc
LOGLOAD_FILE=$LOG_FILE.1.logload


# Chargement des budgets dans la table temporaire
# ################################################
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/loadDIVA_budgets.par \
	control=$DIR_SQLLOADER_PARAM/loadDIVA_budgets.ctl \
	data=$FILE_IMPORT_BUDGETS \
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
	echo "Erreur de chargement des budgets DIVA SQL*Loader" >> $log_tmp
	logText "Erreur de chargement des budgets DIVA SQL*Loader" >> $LOG_FILE
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
    
fi
logText "SQL*Load des budgets DIVA Termine"
logText "SQL*Load des budgets DIVA Termine" >> $LOG_FILE


# on deplace le fichier apres traitement
# ####################################
mv $FILE_IMPORT_BUDGETS  $DIR_BATCH_DATA/$FILE_DIVA_BUDGET 


# MAJ des donnees budgetaires
# ############################
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	!echo "exec pack_diva.global_diva"
	execute pack_diva.global_diva('PL_LOGS');
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
	nom_fichier=$DIR_BATCH_DATA/$FILE_DIVA_BUDGET
	nbligne=`awk 'END {print NR}' $nom_fichier`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_diva_budgets.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,'$nbligne', 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " import_diva_budgets.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Erreur : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.IMPORT_DIVA_BUDGETS.log du jour"
	logText "Erreur de maj des budgets DIVA sous SQL*Plus" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	rm -f $log_tmp
	logText "=== ERREUR : Fin ANORMALE du traitement d insertion des donnees budgetaires en provenance de DIVA : import_diva_budgets.sh. ===" >> $LOG_FILE
	exit -1
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	if [ $statuttmp -eq 1 ]
	then
		statut='NOK'
		varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
		logText "=== ERREUR Fin NORMALE du traitement d insertion des donnees budgetaires en provenance de DIVA : import_diva_budgets.sh. ===" >> $LOG_FILE
		#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
		echo " import_diva_budgets.sh ECHEC" >> $FILE_QUOTIDIENNE
		#Fin YNI
	else
		statut='OK'
		logText "=== Fin NORMALE du traitement d insertion des donnees budgetaires en provenance de DIVA : import_diva_budgets.sh. ===" >> $LOG_FILE
		#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
		echo " import_diva_budgets.sh OK" >> $FILE_QUOTIDIENNE
		#Fin YNI
	fi
	nom_fichier=$DIR_BATCH_DATA/$FILE_DIVA_BUDGET
	nbligne=`awk 'END {print NR}' $nom_fichier`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_diva_budgets.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,'$nbligne', '$statut');
EOF
	rm -f $log_tmp
fi

fi
#YNI FDT 897

else
	echo " Fichier DIVA non detecte. Pas d insertion des donnees dans TMP_DIVA_BUDGETS !!!" >> $log_tmp
	echo " ERREUR : Fin ANORMALE du traitement d insertion des donnees budgetaires en provenance de DIVA." >> $log_tmp
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_diva_budgets.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
		#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
		echo " import_diva_budgets.sh ECHEC" >> $FILE_QUOTIDIENNE
		#Fin YNI
		logText " Fichier DIVA non detecte. Pas d insertion des donnees dans TMP_DIVA_BUDGETS !!!"
		logText " Fichier DIVA non detecte. Pas d insertion des donnees dans TMP_DIVA_BUDGETS !!!" >> $LOG_FILE
		logText "------------------------------------------------------------------------------------" >> $LOG_FILE
		logText "=== ERREUR : Fin ANORMALE du traitement d insertion des donnees budgetaires en provenance de DIVA. ==="
		logText "=== ERREUR : Fin ANORMALE du traitement d insertion des donnees budgetaires en provenance de DIVA : import_diva_budgets.sh. ===" >> $LOG_FILE
		logText "------------------------------------------------------------------------------------" >> $LOG_FILE
	rm -f $log_tmp
fi

exit 0


