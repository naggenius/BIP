#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : purge_Q.sh
# Objet : purges Quotidienne des fichiers de la Bip
#
# Parametres d'entree :
#
#_______________________________________________________________________________
# Creation :
# EGR     14/08/03
#
# Modification :
# --------------
# Auteur  Date       Objet
# EGR	  08/10/2003	purge_Q_err_reports.sh n'est plus appele d'ici car il est execute sur la machine cote WL
# PPR     06/10/2006    ajout d'une purge des tables oracle
# DDI     21/03/2007    ajout des purges Expense Bis & DIVA
# ABA     23/06/2008    ajout des scripts de log
# YNI     21/01/2010    Ajout traitement pour ecriture dans quotidienne.txt
################################################################################

autoload $(ls $FPATH)

#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

LOG_TRAITEMENT=$DIR_BATCH_SHELL_LOG/$(date +"%Y%m%d").purge_Q.log
export LOG_TRAITEMENT
logText "`basename $0` : fichier de trace : $LOG_TRAITEMENT"

logText "--------------------------------------------------------------------------------" > $LOG_TRAITEMENT
logText "-- $(date +"%Y%m%d") Debut de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.purge_Qtmp.txt

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

######   etape 1 : purge_Q_compta  ################################################
logText "-- Lancement de purge_Q_compta.sh ----------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/purge_Q_compta.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		varlog="Echec lors du traitement purge_Q_compta.sh"
		sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('purge_Q.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
        #YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
		echo " purge_Q.sh ECHEC" >> $FILE_QUOTIDIENNE
		#Fin YNI
		logText "Echec lors de l execution du traitement purge_Q_compta"
        logText "arrêt du batch `basename $0`"
        unset LOG_TRAITEMENT
        exit 1;
fi

######   etape 2 : purge_Q_log  ################################################
logText "-- Lancement de purge_Q_log.sh ----------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/purge_Q_log.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		varlog="Echec lors du traitement purge_Q_log.sh"
		sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('purge_Q.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
        #YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
		echo " purge_Q.sh ECHEC" >> $FILE_QUOTIDIENNE
		#Fin YNI
		logText "Echec lors de l execution du traitement purge_Q_log"
        logText "arrêt du batch `basename $0`"
        unset LOG_TRAITEMENT
        exit 1;
fi

######   etape 3 : purge_Q_ebis  ################################################
logText "-- Lancement de purge_Q_ebis.sh ----------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/purge_Q_ebis.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement purge_Q_ebis.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('purge_Q.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
        #YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
		echo " purge_Q.sh ECHEC" >> $FILE_QUOTIDIENNE
		#Fin YNI
		logText "Echec lors de l execution du traitement purge_Q_ebis"
        logText "arrêt du batch `basename $0`"
        unset LOG_TRAITEMENT
        exit 1;
fi

######   etape 4 : purge_Q_diva  ################################################
logText "-- Lancement de purge_Q_diva.sh ----------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/purge_Q_diva.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement purge_Q_diva.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('purge_Q.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
        #YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
		echo " purge_Q.sh ECHEC" >> $FILE_QUOTIDIENNE
		#Fin YNI
		logText "Echec lors de l execution du traitement purge_Q_diva"
        logText "arrêt du batch `basename $0`"
        unset LOG_TRAITEMENT
        exit 1;
fi

######   etape 4 : purge_Tous_6mois  ################################################
logText "-- Lancement de purge_tous_6m.sh ----------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/purge_tous_6m.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement purge_tous_6m.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('purge_Q.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
        #YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
		echo " purge_Q.sh ECHEC" >> $FILE_QUOTIDIENNE
		#Fin YNI
		logText "Echec lors de l execution du traitement purge_tous_6m.sh"
        logText "arrêt du batch `basename $0`"
        unset LOG_TRAITEMENT
        exit 1;
fi


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_TRAITEMENT
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACKBATCH_PURGE_Q.PURGE_TABLES('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_TRAITEMENT 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('purge_Q.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " purge_Q.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Problème SQL*PLUS dans batch PURGE_Q : consulter $LOG_TRAITEMENT"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_TRAITEMENT
	rm -f $log_tmp
	exit -1;
fi

# Fin du batch de purge_Q
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('purge_Q.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
rm -f $log_tmp
#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
echo " purge_Q.sh OK" >> $FILE_QUOTIDIENNE
#Fin YNI
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
logText "-- Fin Normale de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
unset LOG_TRAITEMENT

exit 0


