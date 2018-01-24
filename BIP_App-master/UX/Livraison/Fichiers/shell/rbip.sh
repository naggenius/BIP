#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : RBip.sh
# Objet : Shell batch qui lance le contrôle des fichiers de remontée bip déposés
#	par les utilisateurs dans leur répertoire de dépot
#
#_______________________________________________________________________________
# Creation : E.GREVREND
# Modification :
#ABA       01/04/2008    Ajout traitement pour affichage des logs via l'ihm bip
#ABA       01/12/2010    QC 1083
#OEL	   16/11/2011    QC 1283
# --------------
# Auteur  Date       Objet
################################################################################

print "Début du contrôle Batch de la remontée Bip"

#. /datas/h2bip/applis/bipparam.sh
#################################################
#export BIP_DATA_REMONTEE=/projet/bip/RBip/data/remontee

#echo $BIP_DATA_REMONTEE
# Variable TOP pour le lancement du traitement Remontee BIP UNIX
TOP="UNIX"

LOG_TRAITEMENT=$DIR_BATCH_SHELL_LOG/$(date +"%Y%m%d").rbip.$(date +"%H")H.log
log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.rbip.$(date +"%H")H.tmp.txt
export LOG_TRAITEMENT

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "Début du contrôle Batch de la remontée Bip : rbip.sh" >> $LOG_TRAITEMENT

logText "`basename $0` : fichier de trace : $LOG_TRAITEMENT"

logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
logText "-- $(date +"%Y%m%d") Debut de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT

################################
# Extraction des fichiers DIVA #
################################
cd $RECEPTION

toperr=0

if [ -f $FIC_DIVA ]
then 

	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	logText "-- $(date +"%Y%m%d") Debut d extraction diva" >> $LOG_TRAITEMENT
	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
        	
			mv $FIC_DIVA $DIR_DIVA_EXTRACT
        	cd $DIR_DIVA_EXTRACT 
        	tar xvf $FIC_DIVA

	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	logText "-- $(date +"%d%m%y") DIVA: archivage du  fichier source" >> $LOG_TRAITEMENT
	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
		mv $FIC_DIVA $DIR_DIVA_HIST/$FIC_DIVA.$(date +"%Y%m%d%H%M%S")
	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	logText "-- $(date +"%d%m%y") FIN d extraction diva" >> $LOG_TRAITEMENT
	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	
	
else
	
		toperr=1
		logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
		logText "-- $(date +"%d%m%y") fichier diva inexistant" >> $LOG_TRAITEMENT
		logText "ERREUR fichier diva : diva_consomme.tar inexistant" >> $log_tmp
		logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	
	
fi
###############################
# Extraction des fichier GIMS #
###############################
cd $RECEPTION

if [ -f $FIC_GIMS ]
then 

	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	logText "-- $(date +"%Y%m%d") Debut d extraction GIMS" >> $LOG_TRAITEMENT
	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
        	mv $FIC_GIMS $DIR_GIMS_EXTRACT
        	cd $DIR_GIMS_EXTRACT 
			tar xvf $FIC_GIMS

	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	logText "-- $(date +"%d%m%y") GIMS: archivage du  fichier source" >> $LOG_TRAITEMENT
	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
		mv $FIC_GIMS $DIR_GIMS_HIST/$FIC_GIMS.$(date +"%Y%m%d%H%M%S")
	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	logText "-- $(date +"%d%m%y") FIN d extraction GIMS" >> $LOG_TRAITEMENT
	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	
	
else
	
		toperr=1
		logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
		logText "-- $(date +"%d%m%y") fichier GIMS inexistant" >> $LOG_TRAITEMENT
		logText "ERREUR fichier GIMS : gims_consomme.tar inexistant" >> $log_tmp
		logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	
	
fi

#####################################
# Extraction des fichiers BIPS DIVA #
#####################################
cd $RECEPTION

toperr=0

if [ -f $FIC_DIVA_BIPS ]
then 

	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	logText "-- $(date +"%Y%m%d") Debut d extraction BIPS diva" >> $LOG_TRAITEMENT
	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
        	
			mv $FIC_DIVA_BIPS $DIR_DIVA_EXTRACT
        	cd $DIR_DIVA_EXTRACT 
        	tar xvf $FIC_DIVA_BIPS

	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	logText "-- $(date +"%d%m%y") DIVA: archivage du  fichier source BIPS" >> $LOG_TRAITEMENT
	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
		mv $FIC_DIVA_BIPS $DIR_DIVA_HIST/$FIC_DIVA_BIPS.$(date +"%Y%m%d%H%M%S")
	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	logText "-- $(date +"%d%m%y") FIN d extraction diva BIPS" >> $LOG_TRAITEMENT
	logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	
	
else
	
		toperr=1
		logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
		logText "-- $(date +"%d%m%y") fichier diva BIPS inexistant" >> $LOG_TRAITEMENT
		logText "ERREUR fichier diva BIPS: $FIC_DIVA_BIPS inexistant" >> $log_tmp
		logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
	
	
fi

################################################################################
# Lancement du java - Traitement des fichiers .bip
################################################################################
#RBIP_JAR=rBip.jar ...
RBIP_JAR=RBip.jar

export CLASSPATH=$BIP_RBIP_DIR/lib/ojdbc14.jar:$BIP_RBIP_DIR/lib/capfwk.jar:$BIP_RBIP_DIR/lib/log4j-1.2.8.jar:$BIP_RBIP_DIR/lib/RBip.jar:$BIP_RBIP_DIR/config/:$BIP_RBIP_DIR/lib/com.bea.core.apache.commons.lang_2.1.0.jar

cd $BIP_RBIP_DIR
ORA_USRID=`echo $CONNECT_STRING | cut -d'/' -f1`
ORA_INT=`echo $CONNECT_STRING | cut -d'/' -f2`
ORA_USRPWD=`echo $ORA_INT | cut -d'@' -f1`

java com.socgen.bip.rbip.batch.RBip $ORA_DB_URL $ORA_USRID $ORA_USRPWD $TOP >> $LOG_TRAITEMENT 2>&1

JAVA_EXIT=$?
if [ $JAVA_EXIT -ne 0 ]
then
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		echo "Erreur de traitement : java com.socgen.bip.rbip.batch.RBip" >> $log_tmp
		varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('rbip.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0,'NOK');
EOF
		rm -f $log_tmp
        logText "Echec lors de l execution du traitement remontée bip côté serveur" >> $LOG_TRAITEMENT
        logText "arrêt du batch `basename $0`" >> $LOG_TRAITEMENT
		logText "=== Fin ANORMALE du contrôle Batch de la remontée Bip : rbip.sh ===" >> $LOG_TRAITEMENT
        unset LOG_TRAITEMENT
        exit 1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	if [ toperr -eq 1 ]	
	then
		statut='NOK'
		varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
		echo "=== Fin ANORMALE du contrôle Batch de la remontée Bip : rbip.sh ===" >> $LOG_TRAITEMENT
	else
		logText "=== Fin NORMALE  du contrôle Batch de la remontée Bip : rbip.sh ===" >> $LOG_TRAITEMENT
		statut='OK'
	fi
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('rbip.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0,'$statut');
EOF
	rm -f $log_tmp
	rm -f $BIP_RBIP_DIR/data/GIMS/*.bip
	rm -f $BIP_RBIP_DIR/data/DIVA/*.bip
	
	rm -f $BIP_RBIP_DIR/data/GIMS/*.bips
	rm -f $BIP_RBIP_DIR/data/DIVA/*.bips
fi

exit 0
