#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : diva_dossiers_projets.sh
# Objet : Shell de constitution du fichier des DOSSIERS PROJETS pour DIVA 
#         Lanc� quotidiennement les jours ouvrables
#_______________________________________________________________________________
# Auteur  	Date       		Objet
# DDI     	17/07/07   		creation
# ABA       01/04/2008    	Ajout traitement pour affichage des logs via l'ihm bip
# YNI     	21/01/2010    	Ajout traitement pour ecriture dans quotidienne.txt
################################################################################

autoload $(ls $FPATH)

#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.diva_dossiers_projets.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.diva_dossiers_projetstmp.txt 

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

#R�pertoire d'extraction : BIPDATA/DIVA/EXPORT_DOSSIERS_PROJETS Variable a definir dans bipparam.sh
#
REP_EXTRACT=$PL_EMISSION

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de DIVA dossiers projets : diva_dossiers_projets.sh" >> $LOG_FILE

# construction du nom du fichier
# on recupere dans la base de donnees le mois et l'annee des donnees courantes
param=`sqlplus -s $CONNECT_STRING << EOF
	whenever sqlerror exit failure;
	set headsep off
	set heading off
	set linesize 2000
	set feedback off
	select to_char(sysdate, 'ddmmyyyy') from dual;
EOF`

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Echec de lecture du mois et de l'annee dans diva_dossiers_projets.sh" >> $LOG_FILE
	logText "Erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "===>$param<===" >> $LOG_FILE
	exit -1
fi

#Date=`echo $param|awk '{print $1}'`
#Mois=`echo $param|awk '{print $2}'`

nom_fic=$DIVA_DOSSIERS_PROJETS
#nom_fic=truc.csv
logText "Fichier = $nom_fic" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	!echo "pack_diva.dossiers_projets"
	exec pack_diva.dossiers_projets('$REP_EXTRACT', '$nom_fic')
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
	insert into BATCH_LOGS_BIP values ('diva_dossier_projets.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " diva_dossiers_projets.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Probleme SQL*PLUS dans diva_dossiers_projets pour la generation du fichier" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	rm -f $log_tmp
	logText "=== ERREUR : Fin ANORMALE de DIVA dossiers projets : diva_dossiers_projets.sh ===" >> $LOG_FILE
	exit -1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1

	#nom_fichier=$REP_EXTRACT/$nom_fic
	#nbligne=`awk 'END {print NR}' $nom_fichier`

	nom_fichier=$EMISSION/$nom_fic
	nbligne=`cat $nom_fichier | wc -l`
	logText "$nom_fic nombre de ligne : $nbligne" >> $LOG_FILE
	
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('diva_dossier_projets.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,'$nbligne',0, 'OK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " diva_dossiers_projets.sh OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
	rm -f $log_tmp
	logText "=== Fin NORMALE de DIVA dossiers projets : diva_projets.sh ===" >> $LOG_FILE
fi


exit 0
