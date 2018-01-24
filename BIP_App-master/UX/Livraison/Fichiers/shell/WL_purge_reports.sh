#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : WL_purge_reports.sh
# Objet : purge le répertoire de sortie des états
#
#
#_______________________________________________________________________________
# Creation :
# EGR     28/10/03
#
# Modification :
# --------------
# Auteur  Date       Objet
# E.GREVREND	  19/10/04	MAJ WLS7
# A.SAKHRAOUI     03/04/07      MAJ WLS9
#
################################################################################
autoload $(ls $FPATH)

function getNbJCalendaires {
	DELAI_RESTANT=$1
	JOUR=$(date +"%w")
	
	if [ $DELAI -lt 7 ]
	then
		NBJ=$DELAI_RESTANT
		DELAI_RESTANT=0
	else
		NBJ=$(( $JOUR+2 ))
		DELAI_RESTANT=$(( $DELAI_RESTANT-$JOUR ))
	fi
	#Si le delai ne fait pas changer de semaine, le nbj a faire vaut le delai
	#sinon on prend les jours pour remonter la semaine
	#Donc NBJ contient le nbj deja comptablises, et DELAI_RESTANT le nbj restant a faire
	
	#echo "NBJ : "$NBJ
	#echo "DELAI restant : "$DELAI_RESTANT
	
	#on va maintenant comptabiliser les nombre de semaines calendaire ENTIERES a remonter
	#1semaine ouvree = 5 jours
	#1semaine calendaire=7jours
	NBSemaine=$(( $DELAI_RESTANT / 5 ))
	#echo "nb demaines : $NBSemaine *7"
	NBJ=$(( $NBJ + $NBSemaine*7 ))
	DELAI_RESTANT=$(( $DELAI_RESTANT-$NBSemaine*5 ))
	
	#il peut rester quelques jours, on les compte
	NBJ=$(( $NBJ + $DELAI_RESTANT +1 ))	
	echo $NBJ
}

. /applis/bip_wl9/bip9dom/WL_bipparam.sh
#. $APP_HOME/WL_bipparam.sh
. /applis/bip_wl9/bip9dom/.WL_profile.oracle DEV6I
#. $APP_HOME/.WL_profile.oracle DEV6I

LISTE_ASYNC=$TMPDIR/liste_async.lst
LISTE_FICHIERS=$TMPDIR/liste_fichier.lst

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.WL_purge_reports.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "-- $(date +"%Y%m%d %H:%M:%S") Debut de $0" >> $LOG_FILE
logText "--------------------------------------------------------------------------------" >> $LOG_FILE


DELAI=6

NBJ=$(getNbJCalendaires $DELAI)
echo $NBJ


# 1)mettre a jour la table des traitement asynchrones:
#	- les 'en cours' passent en erreur
#	- les fichiers avec date > n-jours ouvres => supprimes
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	set pagesize 1000
	
	!echo "Delete des entrees 'en cours' passent en 'erreur'
	select NOM_FICHIER from TRAIT_ASYNCHRONE where STATUT='0';
	update TRAIT_ASYNCHRONE set STATUT='-1' where STATUT='0';

	!echo "On retire les enregistrements > $NBJ jours"
	select NOM_FICHIER from TRAIT_ASYNCHRONE where trunc(DATE_TRAIT) < trunc(sysdate-$NBJ);
	delete TRAIT_ASYNCHRONE where trunc(DATE_TRAIT) < trunc(sysdate-$NBJ);
!
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch $(basename $0) : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

# 2) Recuperer la liste des fichiers references dans la table trait_asynchrone
logText "Recuperation de la liste des fichiers en base" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! > $LISTE_ASYNC 2>> $LOG_FILE
	whenever sqlerror exit failure;
	set heading off
	set headsep off
	set feedback OFF
	set echo off
	set pagesize 1000
	set pages 0
	select NOM_FICHIER from TRAIT_ASYNCHRONE where STATUT='1';
!

PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch $(basename $0) : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

#######################################################################################################
cd $DIR_REPORT_OUT
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
        logText "Probleme <code=$CMD_EXIT>  lors du passage dans le repertoire $DIR_REPORT_OUT"
        logText "Probleme <code=$CMD_EXIT>  lors du passage dans le repertoire $DIR_REPORT_OUT" >> $LOG_FILE
        exit 1
fi
	
ls *.PDF *.pdf *.CSV *.csv *.DOC *.doc > $LISTE_FICHIERS

#par nature c'est la liste des fichiers en base qui doit etre la plus petite
for FICHIER in $(cat $LISTE_FICHIERS)
do
	grep $FICHIER $LISTE_ASYNC >/dev/null 2>> $LOG_FILE
	CMD_EXIT=$?
	if [ $CMD_EXIT -eq 0 ]
	then
		logText "On garde le fichier $FICHIER"
		logText "On garde le fichier $FICHIER" >> $LOG_FILE
	elif [ $CMD_EXIT -eq 1 ]
	then
		logText "Le fichier $FICHIER est a supprimer"
		logText "Le fichier $FICHIER est a supprimer" >> $LOG_FILE
		
		#on est tjs dans le repertoire
		/bin/rm -f $FICHIER 2>> $LOG_FILE
	fi
done




#echo "FICHIER EN BASE :"
#cat $LISTE_ASYNC
#echo "******************************************************************"
#echo "FICHIER dans le rep :"
#cat $LISTE_FICHIERS

exit 0
