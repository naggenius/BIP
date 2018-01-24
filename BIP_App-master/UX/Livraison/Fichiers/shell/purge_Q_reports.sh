#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : purge_Q_reports.sh
# Objet : purge des fichiers crees par Oracle Reports Server
#
# Parametres d'entree :
#       $1  : delai en nombre de jours
#
#_______________________________________________________________________________
# Creation :
# EGR     14/08/03
#
# Modification :
# --------------
# Auteur  Date       Objet
#
################################################################################

#################################################
# On charge l'environnement
#################################################
autoload $(ls $FPATH)
#################################################

FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt

if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.purge_Q_reports.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

DELAI=5

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.purge_Q_reports.txt

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE


sqlplus -s $CONNECT_STRING << EOF >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	set linesize 1000
	set pages 1000
	
	select '###########################################################################' as INFO from dual;
	select '# Editions ################################################################' as INFO from dual;
	select '###########################################################################' as INFO from dual;
	
	select 'Contenu de la table trait_asynchrone Editions AVANT la purge' as INFO from dual;
	select userid, titre, nom_fichier, statut, to_char(date_trait,'DD/MM/YYYY HH24:MI:SS') as date_trait from trait_asynchrone
		where  type = 'E' order by date_trait;
		
	execute pack_asynchrone.purge_async($DELAI,'E');
	select 'Contenu de la table trait_asynchrone Editions APRES la purge' as INFO from dual;
	select userid, titre, nom_fichier, statut, to_char(date_trait,'DD/MM/YYYY HH24:MI:SS') as date_trait from trait_asynchrone
		where  type = 'E' order by date_trait;
	
	select '###########################################################################' as INFO from dual;
	select '# eXtractions #############################################################' as INFO from dual;
	select '###########################################################################' as INFO from dual;
	
	select 'Contenu de la table trait_asynchrone Extractions AVANT la purge' as INFO from dual;
	select userid, titre, nom_fichier, statut, to_char(date_trait,'DD/MM/YYYY HH24:MI:SS') as date_trait from trait_asynchrone
		where  type = 'X' order by date_trait;
		
	execute pack_asynchrone.purge_async($DELAI,'X');
	select 'Contenu de la table trait_asynchrone Extractions APRES la purge' as INFO from dual;
	select userid, titre, nom_fichier, statut, to_char(date_trait,'DD/MM/YYYY HH24:MI:SS') as date_trait from trait_asynchrone
		where  type = 'X' order by date_trait;
EOF

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('purge_Q_reports.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " purge_Q_reports.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Erreur lors du traitement PL/SQL"
	logText "Erreur lors du traitement PL/SQL" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR Fin ANORMALE de purge_Q_reports.sh ===" >> $LOG_FILE
	rm -f $log_tmp
	exit 1
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('purge_Q_reports.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " purge_Q_reports.sh OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
	rm -f $log_tmp
	logText "=== Fin NORMALE de purge_Q_reports.sh ===" >> $LOG_FILE
fi

exit 0