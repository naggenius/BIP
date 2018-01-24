#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : maj_CA.sh
# Objet : Shell batch  (maj_CA)
#
#____________________________________________________________________________________________________________
# Creation 			: YNI 12/10/2009
#____________________________________________________________________________________________________________
# Modification 		:
# YNI  21/01/2010  FDT 886  Ajout traitement pour ecriture dans quotidienne.txt 
#############################################################################################################

autoload $(ls $FPATH)

#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

LOG_TRAITEMENT=$DIR_BATCH_SHELL_LOG/$(date +"%Y%m%d").maj_CA.log
export LOG_TRAITEMENT
logText "`basename $0` : fichier de trace : $LOG_TRAITEMENT"

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.maj_CA.txt

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

statuttmp1=0
statuttmp2=0
statuttmp3=0

logText "--------------------------------------------------------------------------------" > $LOG_TRAITEMENT
logText "-- $(date +"%Y%m%d") Debut de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT

# Vérification du dernier fichier existant

cd $RECEPTION
#referentiel ES
DATA_FILE_DPA=`ls -tr $FILE_DPA_CAMO |tail -1`
#referentiel DPA
DATA_FILE_ES=`ls -tr $FILE_IMPORT_ES |tail -1`


#Tester l'existance des fichiers dpa.dat et import_ES.dat
if [ -e $DATA_FILE_DPA ] && [ -e $DATA_FILE_ES ]
then
########## Chargement de la table CHARGE_CAMO à partir du fichier dpa.dat #####################################
logText "-- Lancement de stloadcam.sh ------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/stloadcam.sh $DATA_FILE_DPA
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement stloadcam.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('maj_CA.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " maj_CA.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Echec lors de l execution du traitement stloadcam"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	#exit 320;
else
	statuttmp1=1
fi

########## Création du CA ou maj du CA dans la table centre_activite à partir de la table CHARGE_CAMO #######################################
logText "-- Lancement de st54702k.sh -------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/st54702k.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement st54702k.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('maj_CA.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " maj_CA.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Echec lors de l execution du traitement st54702k"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	#exit 322;
else
	statuttmp2=1
fi

######### Chargement de la table CHARGE_ES à partir du fichier import_ES.dat #####################################
logText "-- Lancement de entite_structure.sh ------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/entite_structure.sh $DATA_FILE_ES
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement entite_structure.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('maj_CA.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
        #YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
		echo " maj_CA.sh ECHEC" >> $FILE_QUOTIDIENNE
		#Fin YNI
		logText "Echec lors de l'execution du traitement entite_structure"
        logText "arret du batch `basename $0`"
        unset LOG_TRAITEMENT
		#exit 327;
else
	statuttmp3=1
fi

else

if [ -e $DATA_FILE_DPA ] && [ ! -e $DATA_FILE_ES ]
then
	echo " Fichier import_ES.dat non detecte!!!" >> $log_tmp
	echo " ERREUR : Fin ANORMALE de l'execution du traitement maj_CA" >> $log_tmp
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('maj_CA.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
     #YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	 echo " maj_CA.sh ECHEC" >> $FILE_QUOTIDIENNE
	 #Fin YNI
	 logText " Fichier import_ES.dat non detecte!!!"
     logText " Fichier import_ES.dat non detecte!!!" >> $LOG_TRAITEMENT
	 logText "=== ERREUR : Fin ANORMALE de l'execution du traitement maj_CA ===" >> $LOG_TRAITEMENT
	 	rm -f $log_tmp

fi

if [ ! -e $DATA_FILE_DPA ] && [ -e $DATA_FILE_ES ]
then
	echo " Fichiers DPA.dat non detecte!!!" >> $log_tmp
	echo " ERREUR : Fin ANORMALE de l'execution du traitement maj_CA" >> $log_tmp
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('maj_CA.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " maj_CA.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText " Fichiers DPA.dat non detecte!!!"
	logText " Fichiers DPA.dat non detecte!!!" >> $LOG_TRAITEMENT
	logText "=== ERREUR : Fin ANORMALE de l'execution du traitement maj_CA ===" >> $LOG_TRAITEMENT
 	rm -f $log_tmp
fi

if [ ! -e $DATA_FILE_DPA ] && [ ! -e $DATA_FILE_ES ]
then
	echo " Fichiers DPA.dat et import_ES.dat non detectes!!!" >> $log_tmp
	echo " ERREUR : Fin ANORMALE de l'execution du traitement maj_CA" >> $log_tmp
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('maj_CA.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " maj_CA.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText " Fichiers DPA.dat et import_ES.dat non detectes!!!"
	logText " Fichiers DPA.dat et import_ES.dat non detectes!!!" >> $LOG_TRAITEMENT
	logText "=== ERREUR : Fin ANORMALE de l'execution du traitement maj_CA ===" >> $LOG_TRAITEMENT
		rm -f $log_tmp
fi
	
fi


#Logg decrivant que le script s'est bien executé
if [ $statuttmp1 -ne 0 ] && [ $statuttmp2 -ne 0 ] && [ $statuttmp3 -ne 0 ]
then
	echo " Fin NORMALE de l'execution du traitement maj_CA" >> $log_tmp
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('maj_CA.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
     #YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	 echo " maj_CA.sh OK" >> $FILE_QUOTIDIENNE
	 #Fin YNI
	 logText "=== Fin NORMALE de l'execution du traitement maj_CA ===" >> $LOG_TRAITEMENT
	 	rm -f $log_tmp
fi

joursem=`date +%w`
#YNI
#Début de fin de la quotidienne.
#contenu du mail
CONTENU=$(<$FILE_QUOTIDIENNE)
if [ $joursem -eq 1 ] || [ $joursem -eq 2 ] || [ $joursem -eq 3 ] || [ $joursem -eq 4 ] || [ $joursem -eq 5 ] || [ $joursem -eq 6 ]
then
		if [ -e $FILE_QUOTIDIENNE ]
		then
				
		#Construction des differents parametres a passer a envoi_mail.sh
		REMONTE="P001"
		PRIORITE=""
		OBJECT="Fin quotidienne du "`TZ=MET+24 date +"%d%m%y"`
		CORPS=""
		CORPS="${CORPS}Ce mail atteste de la fin de la quotidienne."
		CORPS="${CORPS}\n\n"
		CORPS="${CORPS}$CONTENU"
		PJ="$FILE_QUOTIDIENNE;quotidienne.txt"
		
		#Appel envoi_mail.sh
		$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
		fi
fi

exit 0;