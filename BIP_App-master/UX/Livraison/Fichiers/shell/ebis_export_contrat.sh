#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : ebis_export_contrat.sh
# Objet : 
#       ce script recupere lance la procedure PL/SQL de generation des fichiers
#       d'export contrats pour le flux bip -> expensebis
#_______________________________________________________________________________
# Creation : Equipe BIP (BAA)  27/02/2007
#_______________________________________________________________________________
# Modification :
# --------------
# Auteur        Date            Objet
# JAL       	23/04/2007      Incorporation appel script  CONTRAT_RESSOURCE_LOGS  dans  script export_contrat.
# DDI			27/06/2007		Modification du script car messages en logs.
# JAL          	26/02/2008      Modification pour incorporer l'export contrat ressource logs pour tout le périmètre
# ABA       	01/04/2008    	Ajout traitement pour affichage des logs via l'ihm bip
# YNI     		21/01/2010    	Ajout traitement pour ecriture dans quotidienne.txt
# ---------------------------------------------------------------------------
################################################################################

autoload $(ls $FPATH)

#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

#Répertoire d'extraction : EMISSION
REP_EXTRACT=$PL_EMISSION
nom_fic=$EBIS_FIC_CONTRATS
				
				
if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.ebis_export_contrat.log
		rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.ebis_export_contrattmp.txt      

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'export des contrats ebis : ebis_export_contrat.sh" >> $LOG_FILE

############################# APPEL  CONTRAT_RESSOURCE_REJET #############################
logText "Debut de (`basename $0`)"
logText "Debut de contrat_ressource_rejt" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
# répertoire de TEST en DEV
# execute PACK_EXPENSEBIS.CONTRAT_RESSOURCE_REJET('/utl_file_dir/bip/bipl2/utl_file');
logText "SQLPLUS Exec PACK_EXPENSEBIS.CONTRAT_RESSOURCE_REJET"
logText "Debut SQLPLUS Exec PACK_EXPENSEBIS.CONTRAT_RESSOURCE_REJET" >> $LOG_FILE
echo "SQLPLUS Exec PACK_EXPENSEBIS.CONTRAT_RESSOURCE_REJET" > $log_tmp
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACK_EXPENSEBIS.CONTRAT_RESSOURCE_REJET('$DIR_BATCH_SHELL_LOG');
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
	insert into BATCH_LOGS_BIP values ('ebis_export_contrat.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " ebis_export_contrat.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_EXPENSEBIS.CONTRAT_RESSOURCE_REJET : consulter $LOG_FILE"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.EBIS_CONTRAT_RESSOURCE_REJET.log du jour"
	logText "Code erreur : <$PLUS_EXIT>"
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_EXPENSEBIS.CONTRAT_RESSOURCE_REJET" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de l'export contrat ebis : ebis_export_contrat.sh ===" >> $LOG_FILE
	rm -f $log_tmp
	
else
logText "Fin SQLPLUS Exec PACK_EXPENSEBIS.CONTRAT_RESSOURCE_REJET" >> $LOG_FILE

############################# / APPEL  CONTRAT_RESSOURCE_REJEt #############################



############################# APPEL  EXPORT_CONTRAT   #####################################
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_EXPENSEBIS.EXPORT_CONTRAT" 	
logText "Debut SQLPLUS Exec PACK_EXPENSEBIS.EXPORT_CONTRAT" >> $LOG_FILE
echo "SQLPLUS Exec PACK_EXPENSEBIS.EXPORT_CONTRAT" > $log_tmp		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACK_EXPENSEBIS.EXPORT_CONTRAT('$REP_EXTRACT','$nom_fic');
!
	
#valeur de sortie de SQL*PLUS								
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('ebis_export_contrat.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " ebis_export_contrat.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText  "Problème script ebis_export_contrat.sh : Appel procédure SQL*PLUS : PACK_EXPENSEBIS.EXPORT_CONTRAT "	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script ebis_export_contrat.sh : Appel procédure SQL*PLUS : PACK_EXPENSEBIS.EXPORT_CONTRAT " >> $LOG_FILE								
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_EXPENSEBIS.EXPORT_CONTRAT : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de l'export contrat ebis : ebis_export_contrat.sh ===" >> $LOG_FILE
	rm -f $log_tmp
else
	logText "Fin SQLPLUS Exec PACK_EXPENSEBIS.EXPORT_CONTRAT" >> $LOG_FILE
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	nom_fichier=$REP_EXTRACT/$nom_fic
	nbligne=`awk 'END {print NR}' $nom_fichier`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('ebis_export_contrat.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,'$nbligne',0, 'OK');
EOF
	rm -f $log_tmp
	logText "=== Fin NORMALE de l'export contrat ebis : ebis_export_contrat.sh ===" >> $LOG_FILE
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " ebis_export_contrat.sh OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
					
fi
fi
############################# / APPEL  EXPORT_CONTRAT   #####################################

exit 0