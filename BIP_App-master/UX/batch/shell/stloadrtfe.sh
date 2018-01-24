#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : stloadimmeuble.sh
# Objet : Shell batch STLOADRTFE	  
#
#
#_______________________________________________________________________________
# Creation : BAA 17/10/2005
# Modification :
# --------------
# Auteur  Date       	Objet
# YNI     21/01/2010    Ajout traitement pour ecriture dans quotidienne.txt
#
################################################################################
autoload $(ls $FPATH)

#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.stloadrtfe.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi


datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de STLOADRTFE (`basename $0`)" >> $LOG_FILE

#DATA_FILE=`ls -rt $OSCAR_QUOTIDIEN/export_RTFE* | tail -1`
cd $RECEPTION
DATA_FILE=`ls -tr $FIC_RTFE |tail -1`

logText "NOM FICHIER :  $DATA_FILE" >> $LOG_FILE

#if [ -f "$DATA_FILE" ] 
if [ -a $DATA_FILE ]
then

    logText "Le fichier RTFE $DATA_FILE existe "
    logText "Le fichier RTFE $DATA_FILE existe " >> $LOG_FILE

else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog='Le fichier RTFE est absent'
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('stloadrtfe.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
    #YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " stloadrtfe.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Le fichier RTFE n'existe pas"
    logText "Le fichier RTFE n'existe pas" >> $LOG_FILE
    logText "Fin de STLOADRTFE (`basename $0`)"
    logText "Fin de STLOADRTFE (`basename $0`)" >> $LOG_FILE
	exit -1;

fi


LOGLOAD_FILE=$DIR_SQLLOADER_LOG/`date +"%Y%m%d"`.stloadrtfe
BAD_FILE=$LOGLOAD_FILE.bad
DSC_FILE=$LOGLOAD_FILE.dsc
LOGLOAD_FILE=$LOGLOAD_FILE.logload



# appel SQL*LOADER avec trace execution
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/stloadrtfe.par \
	control=$DIR_SQLLOADER_PARAM/stloadrtfe.ctl \
	data=$DATA_FILE \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	discard=$DSC_FILE \
	skip=1 >> $LOG_FILE 2>&1

# valeur de sortie de SQL*PLUS
LOAD_EXIT=$?
# si le loader retourne 0, il faut verifier qu'il n'y a pas de codes erreurs persents
# dans le fichier de log
if [ $LOAD_EXIT -ne 0 ] || \
   [ $(cat $LOGLOAD_FILE | grep -ci 'SQL\*Loader-') -ne 0 ] || \
   [ $(cat $LOGLOAD_FILE | grep -ci 'ORA-') -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog='ERREUR de chargement du RTFE SQL*Loader'
	nom_fichier=$DATA_FILE
	nbligne=`awk 'END {print NR}' $nom_fichier`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('stloadrtfe.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,'$nbligne', 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " stloadrtfe.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Problème SQL*LOAD dans batch STLOADRTFE : consulter $LOG_FILE"
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>"
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	exit -1;
fi


	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	nom_fichier=$DATA_FILE
	nbligne=`awk 'END {print NR}' $nom_fichier`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('stloadrtfe.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,'$nbligne', 'OK');
EOF

#On deplace le fichier apres traitement
mv $RECEPTION/$DATA_FILE $DIR_BATCH_DATA/$DATA_FILE 

#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
echo " stloadrtfe.sh OK" >> $FILE_QUOTIDIENNE
#Fin YNI
logText "STLOADRTFE (`basename $0`)"
logText "Fin de STLOADRTFE (`basename $0`)" >> $LOG_FILE

exit 0
