#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : faccons.sh
# Objet : Shell de mise a jour des tables de FACCONS :
#               faccons_ressource
#               faccons_consomme
#               faccons_facture
#
#_______________________________________________________________________________
# Creation : Olivier DUPREY 03/12/2001
# Modification :
# --------------
# Auteur    Date          Objet
# EGR       14/10/02      Migration ksh SOLARIS 8
# ABA       01/04/2008    Ajout traitement pour affichage des logs via l'ihm bip
# YNI       21/01/2010    Ajout traitement pour ecriture dans quotidienne.txt
################################################################################

autoload $(ls $FPATH)

#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.faccons.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.facconstmp.txt

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de FACCONS : faccons.sh " >> $LOG_FILE

logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	!echo "DROP INDEX faccons_consomme_idx1"
	DROP INDEX faccons_consomme_idx1;

	!echo "TRUNCATE TABLE faccons_consomme"
	TRUNCATE TABLE faccons_consomme;

	!echo "DROP INDEX faccons_facture_idx1"
	DROP INDEX faccons_facture_idx1;

	!echo "TRUNCATE TABLE faccons_facture"
	TRUNCATE TABLE faccons_facture;

	!echo "TRUNCATE TABLE faccons_ressource"
	TRUNCATE TABLE faccons_ressource;

	!echo "Pack_FacCons.Remplir_Consomme"
	exec Pack_FacCons.Remplir_Consomme;

	!echo "Pack_FacCons.Remplir_Facture"
	exec Pack_FacCons.Remplir_Facture;

	!echo "CREATE INDEX faccons_consomme_idx1"
	CREATE INDEX faccons_consomme_idx1 ON faccons_consomme(ident);

	!echo "CREATE INDEX faccons_facture_idx1"
	CREATE INDEX faccons_facture_idx1 ON faccons_facture(ident);

	!echo "Pack_FacCons.Remplir_Ressource"
	exec Pack_FacCons.Remplir_Ressource;
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
	insert into BATCH_LOGS_BIP values ('faccons.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " faccons.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Erreur lors du traitement PL/SQL"
	logText "Erreur lors du traitement PL/SQL" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR Fin ANORMALE de FACCONS : faccons.sh ===" >> $LOG_FILE
	rm -f $log_tmp
	exit 1
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('faccons.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " faccons.sh OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
	rm -f $log_tmp
	logText "=== Fin NORMALE de FACCONS : faccons.sh ===" >> $LOG_FILE
fi



exit 0
