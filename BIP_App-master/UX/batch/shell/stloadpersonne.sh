#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : stloadimmeuble.sh
# Objet : Shell batch STLOADPERSONNE
#	  A la fin du traitement si OK, on renomme le fichier avec une extension de la date du jour
#
# Parametres d'entree :
#	$1	le chemin ET LE NOM du fichier de data, contenant les personnes
#
#_______________________________________________________________________________
# Creation : BAA 22/09/2005
# Modification :
#ABA      14/03/08   integration des logs dans la base pour visualisation IHM
# --------------
# Auteur  	Date       		Objet
# ABA       01/04/2008    	Ajout traitement pour affichage des logs via l'ihm bip
# YNI     	21/01/2010    	Ajout traitement pour ecriture dans quotidienne.txt
################################################################################
autoload $(ls $FPATH)
set -x
#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`


if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.stloadpersonne.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de SQLLoader pour les ressources : stloadpersonne.sh" >> $LOG_FILE

DATA_FILE=$1
#DATA_FILE=$DIR_BATCH_DATA/PERSONNE.COL
LOGLOAD_FILE=$DIR_SQLLOADER_LOG/`date +"%Y%m%d"`.stloadpersonne
BAD_FILE=$LOGLOAD_FILE.bad
DSC_FILE=$LOGLOAD_FILE.dsc
LOGLOAD_FILE=$LOGLOAD_FILE.logload

# appel SQL*LOADER avec trace execution
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/stloadpersonne.par \
	control=$DIR_SQLLOADER_PARAM/stloadpersonne.ctl \
	data=$DATA_FILE \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	discard=$DSC_FILE >> $LOG_FILE 2>&1

# valeur de sortie de SQL*PLUS
LOAD_EXIT=$?
# si le loader retourne 0, il faut verifier qu'il n'y a pas de codes erreurs persents
# dans le fichier de log
if [ $LOAD_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	logText "Problème SQL*LOAD dans batch STLOADPERSONNE : consulter $LOG_FILE"
	varlog='ERREUR de chargement des personnes SQL*Loader'
	nom_fichier=$DATA_FILE
	nbligne=`awk 'END {print NR}' $nom_fichier`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('stloadpersonne.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,'$nbligne', 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " stloadpersonne.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>"
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de SQLLoader pour les personnes : stloadpersonne.sh ===" >> $LOG_FILE
	exit -1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	nom_fichier=$DATA_FILE
	nbligne=`awk 'END {print NR}' $nom_fichier`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('stloadpersonne.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,'$nbligne', 'OK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " stloadpersonne.sh OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "=== Fin NORMALE de SQLLoader pour les personnes : stloadpersonne.sh ===" >> $LOG_FILE
fi

#On deplace le fichier apres traitement
mv $RECEPTION/$FIC_PERSONNE $DIR_BATCH_DATA/$FIC_PERSONNE

#DATE_DUJOUR=`date +"%Y%m%d"`
#mv  $DATA_FILE  $DATA_FILE$DATE_DUJOUR 2>> $LOG_FILE
#CMD_EXIT=$?
#if [ $CMD_EXIT -ne 0 ]
#then
#	logText "Echec du deplacement de $DATA_FILE en $DATA_FILE$DATE_DUJOUR"
#	logText "Echec du deplacement de $DATA_FILE en $DATA_FILE$DATE_DUJOUR" >> $LOG_FILE
#	logText "Code erreur : <$CMD_EXIT>" >> $LOG_FILE
	#erreur non bloquante
#	exit 0
#fi
#logText "Fichier IMMEUBLE renomme en $DATA_FILE$DATE_DUJOUR"


exit 0
