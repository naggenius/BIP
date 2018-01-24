#!/bin/ksh
#___________________________________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : maj_ressource_immeuble.sh
# Objet : Shell batch maj_ressource_immeuble
#         lance le trois shell : stloadimmeuble.sh, stloadimmeuble.sh, maj_ress_imm.sh 	  
#
# Parametres d'entree :
#	$1	le chemin ET LE NOM du fichier de data, contenant les immeubles
#
#___________________________________________________________________________________________________
# Creation : BAA 22/09/2005
# Modification :
# --------------
# Auteur  	Date       		Objet
# PPR     	01/02/05   		Rajout du chemin dans l'appel des autres shells
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

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.maj_ressource_immeubletmp.txt
statuttmp=0

######## chargement de la table tmp_immeuble
logText "-- Lancement de stloadimmeuble.sh -------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/stloadimmeuble.sh $RECEPTION/$FIC_IMMEUBLE
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	statuttmp=1
	logText "Echec lors du chargement stloadimmeuble.sh"
	echo "Echec lors du chargement stloadimmeuble.sh" >> $log_tmp
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " maj_ressource_immeuble.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	exit 10;
fi


######## chargement de la table tmp_personne
logText "-- Lancement de stloadpersonne.sh -------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/stloadpersonne.sh $RECEPTION/$FIC_PERSONNE
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	statuttmp=2
	logText "Echec lors du chargement stloadpersonne.sh"
	echo "Echec lors du chargement stloadpersonne.sh" >> $log_tmp
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " maj_ressource_immeuble.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	exit 20;
fi


######## mise à jour des tables ressource et immeuble
logText "-- Lancement de maj_ress_imm.sh -------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/maj_ress_imm.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	statuttmp=3
	logText "Echec lors de la mise à jour des table ressource et immeuble maj_personne_immeuble.sh"
	echo "Echec lors de la mise à jour des table ressource et immeuble maj_personne_immeuble.sh" >> $log_tmp
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " maj_ressource_immeuble.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	exit 30;
fi

if ([ statuttmp -eq 1 ] || [ statuttmp -eq 2 ] || [ statuttmp -eq 3 ])
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('maj_ressource_immeuble.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " maj_ressource_immeuble.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	rm -f $log_tmp
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('maj_ressource_immeuble.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " maj_ressource_immeuble.sh OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
	rm -f $log_tmp
fi

exit 0;
