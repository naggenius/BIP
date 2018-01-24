#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : purge_repertoire.sh
# Objet : purge du repertoire donné avec les criteres donnés
#
# Parametres d'entree :
#       $1      Type de critere : J/M/01M
#       $2      Répertoire à purger
#       $2      Délai
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

autoload $(ls $FPATH)

DIRTMP=.

if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.purge_repertoire.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE

if [ $# -lt 3 ] && [ $# -gt 4 ]
then
	logText "Mauvais nombre d'arguments" >&2
	logText "Usage `basename $0` Type Repertoire Delai FiltreNomFichier" >&2
	logText "	- Type : J - Delai en jours ouvrés (Lundi..Vendredi)" >&2
	logText "	- Type : 01M - Purge des fichiers antérieur au 01/(mois_courant-delai)" >&2
	logText "Mauvais nombre d'arguments" >> $LOG_FILE
	logText "Usage `basename $0` Type Repertoire Delai FiltreNomFichier" >> $LOG_FILE
	logText "	- Type : J - Delai en jours ouvrés (Lundi..Vendredi)" >> $LOG_FILE
	logText "	- Type : 01M - Purge des fichiers antérieur au 01/(mois_courant-delai)" >> $LOG_FILE
	exit -1
else
	CRITERE=$1
	REPERTOIRE=$2
	DELAI=$3
	
	if [ -z $4 ]
	then
		FILTRE=*
	else
		FILTRE=$4
	fi
	
	logText "Critere    : $CRITERE"
	logText "Critere    : $CRITERE" >> $LOG_FILE
	logText "Repertoire : $REPERTOIRE"
	logText "Repertoire : $REPERTOIRE" >> $LOG_FILE
	logText "Delai      : $DELAI"
	logText "Delai      : $DELAI" >> $LOG_FILE
	logText "Filtre     : $FILTRE"
	logText "Filtre     : $FILTRE" >> $LOG_FILE
fi

if [ "$CRITERE" != "J" ] && [ "$CRITERE" != "01M" ]
then
	logText "Usage `basename $0` Type Repertoire Delai FiltreNomFichier" >&2
	logText "	- Type : J - Delai en jours ouvrés (Lundi..Vendredi)" >&2
	logText "	- Type : 01M - Purge des fichiers antérieur au 01/(mois_courant-delai)" >&2
	logText "Usage `basename $0` Type Repertoire Delai FiltreNomFichier" >> $LOG_FILE
	logText "	- Type : J - Delai en jours ouvrés (Lundi..Vendredi)" >> $LOG_FILE
	logText "	- Type : 01M - Purge des fichiers antérieur au 01/(mois_courant-delai)" >> $LOG_FILE
	exit -1
fi

FICHIER_TMP=$REPERTOIRE/fichierDatePurge.tmp

########## Par Jours calendaires ################
if [ "$CRITERE" = "J" ]
then
	DELAI_RESTANT=$DELAI
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
	
	# NBJ vaut maintenant le nombre de jours calendaires
	#echo "Nb de jours calendaires : "$NBJ
	
	#######################################################################################################
	cd $REPERTOIRE
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
	then
	        logText "Probleme <code=$CMD_EXIT>  lors du passage dans le repertoire $REPERTOIRE"
	        logText "Probleme <code=$CMD_EXIT>  lors du passage dans le repertoire $REPERTOIRE" >> $LOG_FILE
	        exit 1
	fi
	
	
	logText "Liste des fichiers antérieurs à $NBJ jours"
	find . -name "$FILTRE" -mtime +$NBJ -type f
	
	logText "Liste des fichiers antérieurs à $NBJ jours" >> $LOG_FILE
	find . -name "$FILTRE" -mtime +$NBJ -type f >> $LOG_FILE 2> /dev/null
	
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
	then
	        logText "Probleme <code=$CMD_EXIT>  lors du listage des fichiers a supprimer"
	        logText "Probleme <code=$CMD_EXIT>  lors du listage des fichiers a supprimer" >> $LOG_FILE
	        exit 1
	fi

	find . -name "$FILTRE" -mtime +$NBJ -type f -exec rm -f {} \; >> $LOG_FILE 2>&1
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
	then
	        logText "Un probleme <code=$CMD_EXIT> est survenu, des fichiers n'ont pas etes supprimes"
	        logText "Un probleme <code=$CMD_EXIT> est survenu, des fichiers n'ont pas etes supprimes" >> $LOG_FILE
	fi
	cd - > /dev/null
	
########## Par 01/Mois #############################
elif [ "$CRITERE" = "01M" ]
then
	#Preparation du fichier temporaire permettant de specifier la date
	ANNEE_LIM=$(date +"%y")
	MOIS_LIM=$(( $(date +"%m") - $DELAI ))
	if [ $MOIS_LIM -lt 1 ]
	then
		MOIS_LIM=$(( $MOIS_LIM + 12 ))
		ANNEE_LIM=$(( $ANNEE_LIM - 1 ))
	fi
	MOIS_LIM=$(printf "%02d" $MOIS_LIM)
	ANNEE_LIM=$(printf "%02d" $ANNEE_LIM)
	
	# Creation
	touch -t $ANNEE_LIM$MOIS_LIM"010000" $FICHIER_TMP 2>> $LOG_FILE
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
	then
	        logText "Probleme <code=$CMD_EXIT>  lors de la creation d'un fichier de travail ($FICHIER_TMP)"
	        logText "Probleme <code=$CMD_EXIT>  lors de la creation d'un fichier de travail ($FICHIER_TMP)" >> $LOG_FILE
	        exit 1
	fi
	
	#######################################################################################################
	cd $REPERTOIRE
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
	then
	        logText "Probleme <code=$CMD_EXIT>  lors du passage dans le repertoire $REPERTOIRE"
	        logText "Probleme <code=$CMD_EXIT>  lors du passage dans le repertoire $REPERTOIRE" >> $LOG_FILE
	        exit 1
	fi
	
	logText "Liste des fichiers antérieurs au 01/$MOIS_LIM/$ANNEE_LIM"
	find . -type f ! -newer $FICHIER_TMP -exec ls -l {} \;

	logText "Liste des fichiers antérieurs au 01/$MOIS_LIM/$ANNEE_LIM" >> $LOG_FILE
	find . -type f ! -newer $FICHIER_TMP -exec ls -l {} \; >>$LOG_FILE 2>&1
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
	then
	        logText "Probleme <code=$CMD_EXIT>  lors du listage des fichiers a supprimer"
	        logText "Probleme <code=$CMD_EXIT>  lors du listage des fichiers a supprimer" >> $LOG_FILE
	        rm -f $FICHIER_TMP 2> /dev/null
	        exit 1
	fi
	
	find . -type f ! -newer $FICHIER_TMP -exec rm -f {} \; >>$LOG_FILE   2>&1
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
	then
	        logText "Un probleme <code=$CMD_EXIT> est survenu, des fichiers n'ont pas etes supprimes"
	        logText "Un probleme <code=$CMD_EXIT> est survenu, des fichiers n'ont pas etes supprimes" >> $LOG_FILE
	fi
	rm -f $FICHIER_TMP 2> /dev/null
	cd -
fi

logText "Purge terminée (`basename $0`)"
logText "Purge terminée (`basename $0`)" >> $LOG_FILE

exit 0
