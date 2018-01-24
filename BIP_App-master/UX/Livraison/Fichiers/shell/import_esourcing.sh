#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : import_eSourcing_cont.sh
# Objet : Shell-script d'import des donnees provenant d'eSourcing
#
# Parametres d'entree:
#	$1	Fichier log (facultatif)
#
#_______________________________________________________________________________
# Creation : MM CURE 24/11/2004 
# ABA       01/04/2008    Ajout traitement pour affichage des logs via l'ihm bip
# YNI       21/01/2010    Ajout traitement pour ecriture dans quotidienne.txt
################################################################################

autoload $(ls $FPATH)

#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

# Fichier log
#if [ $# -eq 0 ]
#then
	if [ -z $LOG_TRAITEMENT ]
	then
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_esourcing.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi
#else
#	LOG_FILE=$1
#fi



#FILE_IMPORT_CONTRAT=eSourcing_cont.csv
#FILE_IMPORT_LIGNE_CONT=eSourcing_ligne_cont.csv
#FILE_IMPORT_RESSOURCE=eSourcing_ress.csv
#FILE_IMPORT_SITU=eSourcing_situ.csv

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'import des ressources eSourcing (`basename $0`)"
logText "Debut de l'import des ressources eSourcing (`basename $0`)" >> $LOG_FILE

logText "--  Verification de la presence des fichiers"
logText "--  Verification de la presence des fichiers" >> $LOG_FILE

# test de l'existence des fichiers eSourcing_ress.csv et eSourcing_situ.csv

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

if [ -a $FILE_IMPORT_RESSOURCE ] && [ -a $FILE_IMPORT_SITU ]
then logText "Fichiers detectes, Lancement de import_eSourcing.sh pour les ressources" >> $LOG_FILE



log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_esourcingtmp.txt

logText "SQL*Load des ressources depuis eSourcing"
logText "SQL*Load des ressources depuis eSourcing" >> $LOG_FILE

LOGLOAD_FILE=$LOG_FILE
BAD_FILE=$LOG_FILE.1.bad
DSC_FILE=$LOG_FILE.1.dsc
LOGLOAD_FILE=$LOG_FILE.1.logload

# chargement des ressources
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/eSourcing_ress.par \
	control=$DIR_SQLLOADER_PARAM/eSourcing_ress.ctl \
	data=$FILE_IMPORT_RESSOURCE \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	discard=$DSC_FILE \
   	skip=1 >> $LOG_FILE 2>&1


# valeur de sortie de SQL*LOAD
LOAD_EXIT=$?
# si le loader retourne 0 ou 2, il faut verifier qu'il n'y a pas de codes erreurs 
# dans le fichier de log
if [ $LOAD_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog='Erreur de chargement des ressources SQL*Loader'
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de chargement des ressources SQL*Loader" >> $LOG_FILE
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_esourcing.sh (ressources)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
echo " import_esourcing.sh(ressources) ECHEC" >> $FILE_QUOTIDIENNE
#Fin YNI
#en cas de presence d'un .bad on renomme les fichier pour eviter qu'il tourne en boucle à cause de crtl M
cp -p $FILE_IMPORT_RESSOURCE  $FILE_IMPORT_RESSOURCE`date +"%Y%m%d"`
	if [ $? -ne 0 ]
	then
 	logText "Erreur dans le renommage du fichier des ressources" >> $LOG_FILE
	fi
rm -f $FILE_IMPORT_RESSOURCE 
	if [ $? -ne 0 ]
	then
	 logText "Erreur dans la suppression du fichier des ressources" >> $LOG_FILE 
	fi
    exit -2
fi
logText "SQL*Load des ressources eSourcing Termine"
logText "SQL*Load des ressources eSourcing Termine" >> $LOG_FILE


BAD_FILE=$LOG_FILE.2.bad
DSC_FILE=$LOG_FILE.2.dsc
LOGLOAD_FILE=$LOG_FILE.2.logload

# chargement des situations
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/eSourcing_situ.par \
	control=$DIR_SQLLOADER_PARAM/eSourcing_situ.ctl \
	data=$FILE_IMPORT_SITU \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	discard=$DSC_FILE \
   	skip=1 >> $LOG_FILE 2>&1

# valeur de sortie de SQL*LOAD
LOAD_EXIT=$?
# si le loader retourne 0 ou 2, il faut verifier qu'il n'y a pas de codes erreurs 
# dans le fichier de log
if [ $LOAD_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog='Erreur de chargement des situations esourcing SQL*Loader'
	logText "Erreur : consulter $LOG_FILE"
	logText "Erreur de chargement des situations SQL*Loader" >> $LOG_FILE
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_esourcing.sh (ressources)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
echo " import_esourcing.sh(ressources) ECHEC" >> $FILE_QUOTIDIENNE
#Fin YNI
#en cas de presence d'un .bad on renomme les fichier pour eviter qu'il tourne en boucle à cause de crtl M
cp -p $FILE_IMPORT_SITU  $FILE_IMPORT_SITU`date +"%Y%m%d"`
	if [ $? -ne 0 ]
	then
 	logText "Erreur dans le renommage du fichier des situations" >> $LOG_FILE
	fi
rm -f $FILE_IMPORT_SITU 
	if [ $? -ne 0 ]
	then
	 logText "Erreur dans la suppression du fichier des situations" >> $LOG_FILE 
	fi	
    exit -2
fi
logText "SQL*Load des situations eSourcing Termine"
logText "SQL*Load des situations eSourcing Termine" >> $LOG_FILE

#compression et renommage des fichiers
cp -p $FILE_IMPORT_RESSOURCE  $FILE_IMPORT_RESSOURCE`date +"%Y%m%d"`
	if [ $? -ne 0 ]
	then
 	logText "Erreur dans le renommage du fichier des ressources" >> $LOG_FILE
	fi
rm -f $FILE_IMPORT_RESSOURCE 
	if [ $? -ne 0 ]
	then
	 logText "Erreur dans la suppression du fichier des ressources" >> $LOG_FILE 
	fi

cp -p $FILE_IMPORT_SITU  $FILE_IMPORT_SITU`date +"%Y%m%d"`
	if [ $? -ne 0 ]
	then
 	logText "Erreur dans le renommage du fichier des situations" >> $LOG_FILE
	fi
rm -f $FILE_IMPORT_SITU 
	if [ $? -ne 0 ]
	then
	 logText "Erreur dans la suppression du fichier des situations" >> $LOG_FILE 
	fi	
 
# maj  ressources
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	!echo "exec pack_esourcing.global_ressource"
	exec pack_eSourcing.global_ressource('$PL_LOGS');
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
	insert into BATCH_LOGS_BIP values ('import_esourcing.sh (ressources)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " import_esourcing.sh(ressources) ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Erreur : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.ESOURCING_RESS.log du jour"
	logText "Erreur de maj des ressources OALIA sous SQL*Plus" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	rm -f $log_tmp
	logText "=== ERREUR : Fin ANORMALE du traitement d insertion des donnees en provenance de resao : import_esourcing.sh. ===" >> $LOG_FILE
	exit -3
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	logText "Fin NORMALE du traitement d insertion des donnees en provenance de resao : import_esourcing.sh. ===" >> $LOG_FILE
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_esourcing.sh (ressources)','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " import_esourcing.sh(ressources) OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
	rm -f $log_tmp
fi

logText "Fin de Import des ressources et situations eSourcing (`basename $0`)"
logText "Fin de Import des ressources et situations eSourcing (`basename $0`)" >> $LOG_FILE

else
     logText " Fichier non detecte. Pas d insertion des donnees dans TMP_RESSOURCE ni dans TMP_SITUATION !!!"
     logText " Fichier non detecte. Pas d insertion des donnees dans TMP_RESSOURCE ni dans TMP_SITUATION !!!" >> $LOG_FILE
	 datefin=`date +'%d/%m/%Y'`
	 heurefin=`date +'%T'`
	 varlog='Fichier non detecte. Pas d insertion des donnees dans TMP_RESSOURCE ni dans TMP_SITUATION !!!'
	 sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_esourcing.sh (ressources)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'OK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " import_esourcing.sh(ressources) OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
fi



logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de la creation du fichier de retour (`basename $0`)"
logText "Debut de la creation du fichier de retour (`basename $0`)" >> $LOG_FILE

# construction du nom du fichier
# on recupere dans la base de donnees le mois et l'annee des donnees courantes
param=`sqlplus -s $CONNECT_STRING << EOF
	whenever sqlerror exit failure;
	set headsep off
	set heading off
	set linesize 2000
	set feedback off
	select to_char(sysdate,'DDMMYYYY')||' ' ||'RETOUR'  from dual;
EOF`

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Echec de lecture de la date" >> $LOG_FILE
	logText "Erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "===>$param<===" >> $LOG_FILE
	exit -1
fi

Annee=`echo $param|awk '{print $1}'`
Retour=`echo $param|awk '{print $2}'`

nom_fic_retour=$Annee$Retour.csv
logText "Fichier retour = $nom_fic_retour" >> $LOG_FILE

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_esourcingtmp.txt

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	!echo "@$DIR_BATCH_SQL/esourcing_retour.sql spoole dans $DIR_BATCH_DATA/$nom_fic_retour"
	spool $DIR_BATCH_DATA/$nom_fic_retour
	@$DIR_BATCH_SQL/esourcing_retour.sql
	spool off
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('esourcing_retour.sql (retour.csv)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " esourcing_retour.sql (retour.csv) ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Probleme SQL*PLUS dans esourcing_retour.sql pour la generation du fichier" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR Fin ANORMALE de la génération du fichier retour.csv : esourcing_retour.sql ===" >> $LOG_FILE
	rm -f $log_tmp
	
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('esourcing_retour.sql (retour.csv)','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " esourcing_retour.sql (retour.csv) OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "=== Fin NORMALE de la génération du fichier retour.csv : esourcing_retour.sql ===" >> $LOG_FILE
	rm -f $log_tmp
fi

logText "Fin de la creation du fichier de retour eSourcing(`basename $0`)"
logText "Fin de la creation du fichier de retour eSourcing (`basename $0`)" >> $LOG_FILE








logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'import des contrats eSourcing (`basename $0`)"
logText "Debut de l'import des contrats eSourcing (`basename $0`)" >> $LOG_FILE

logText "--  Verification de la presence des fichiers"
logText "--  Verification de la presence des fichiers" >> $LOG_FILE

# test de l'existence des fichiers eSourcing_cont.csv et eSourcing_ligne_cont.csv

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

if [ -a $FILE_IMPORT_CONTRAT ] && [ -a $FILE_IMPORT_LIGNE_CONT ]
then logText "Fichiers detectes, Lancement de import_eSourcing_cont.sh" >> $LOG_FILE

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_esourcingtmp.txt

   logText "SQL*Load des contrats depuis eSourcing"
   logText "SQL*Load des contrats depuis eSourcing" >> $LOG_FILE
   
   LOGLOAD_FILE=$LOG_FILE
   BAD_FILE=$LOG_FILE.3.bad
   DSC_FILE=$LOG_FILE.3.dsc
   LOGLOAD_FILE=$LOG_FILE.3.logload

   # chargement des contrats
   sqlldr $CONNECT_STRING \
   	parfile=$DIR_SQLLOADER_PARAM/eSourcing_contrat.par \
   	control=$DIR_SQLLOADER_PARAM/eSourcing_contrat.ctl \
   	data=$FILE_IMPORT_CONTRAT \
   	log=$LOGLOAD_FILE \
   	bad=$BAD_FILE \
   	discard=$DSC_FILE \
   	skip=1 >> $LOG_FILE 2>&1
   
   
   # valeur de sortie de SQL*LOAD
   LOAD_EXIT=$?
   # si le loader retourne 0, il faut verifier qu'il n'y a pas de codes erreurs 
   # dans le fichier de log
   if [ $LOAD_EXIT -ne 0 ]
   then
 	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog='Erreur de chargement des contrats esourcing SQL*Loader'
	logText "Erreur : consulter $LOG_FILE"
   	logText "Erreur de chargement des contrats SQL*Loader" >> $LOG_FILE
   	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
   	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_esourcing.sh (contrats)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
echo " import_esourcing.sh (contrats) ECHEC" >> $FILE_QUOTIDIENNE
#Fin YNI
#en cas de presence d'un .bad on renomme les fichier pour eviter qu'il tourne en boucle à cause de crtl M
   cp -p $FILE_IMPORT_CONTRAT  $FILE_IMPORT_CONTRAT`date +"%Y%m%d"`
   	if [ $? -ne 0 ]
   	then
    	logText "Erreur dans le renommage du fichier des contrats" >> $LOG_FILE
   	fi
   rm -f $FILE_IMPORT_CONTRAT 
   	if [ $? -ne 0 ]
   	then
   	 logText "Erreur dans la suppression du fichier des contrats" >> $LOG_FILE 
   	fi
    exit -2		   

   fi
   logText "SQL*Load des contrats eSourcing Termine"
   logText "SQL*Load des contrats eSourcing Termine" >> $LOG_FILE
   
   BAD_FILE=$LOG_FILE.4.bad
   DSC_FILE=$LOG_FILE.4.dsc
   LOGLOAD_FILE=$LOG_FILE.4.logload

   
   # chargement des lignes contrat
   sqlldr $CONNECT_STRING \
   	parfile=$DIR_SQLLOADER_PARAM/eSourcing_ligne_cont.par \
   	control=$DIR_SQLLOADER_PARAM/eSourcing_ligne_cont.ctl \
   	data=$FILE_IMPORT_LIGNE_CONT \
   	log=$LOGLOAD_FILE \
   	bad=$BAD_FILE \
   	discard=$DSC_FILE \
   	skip=1 >> $LOG_FILE 2>&1
   
   # valeur de sortie de SQL*LOAD
   LOAD_EXIT=$?
   # si le loader retourne 0, il faut verifier qu'il n'y a pas de codes erreurs 
   # dans le fichier de log
   if [ $LOAD_EXIT -ne 0 ]
   then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog='Erreur de chargement des lignes contrats esourcing SQL*Loader'
   	logText "Erreur : consulter $LOG_FILE"
   	logText "Erreur de chargement des lignes contrat SQL*Loader" >> $LOG_FILE
   	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
   	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_esourcing.sh (contrats)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
echo " import_esourcing.sh (contrats) ECHEC" >> $FILE_QUOTIDIENNE
#Fin YNI
#en cas de presence d'un .bad on renomme les fichier pour eviter qu'il tourne en boucle à cause de crtl M
   cp -p $FILE_IMPORT_LIGNE_CONT  $FILE_IMPORT_LIGNE_CONT`date +"%Y%m%d"`
   	if [ $? -ne 0 ]
   	then
    	logText "Erreur dans le renommage du fichier des lignes contrat" >> $LOG_FILE
   	fi
   rm -f $FILE_IMPORT_LIGNE_CONT 
   	if [ $? -ne 0 ]
   	then
   	 logText "Erreur dans la suppression du fichier des lignes contrat" >> $LOG_FILE 
   	fi
     exit -2
   fi
   logText "SQL*Load des lignes contrat eSourcing Termine"
   logText "SQL*Load des lignes contrat eSourcing Termine" >> $LOG_FILE
   
   #compression et renommage des fichiers
   cp -p $FILE_IMPORT_CONTRAT  $FILE_IMPORT_CONTRAT`date +"%Y%m%d"`
   	if [ $? -ne 0 ]
   	then
    	logText "Erreur dans le renommage du fichier des contrats" >> $LOG_FILE
   	fi
   rm -f $FILE_IMPORT_CONTRAT 
   	if [ $? -ne 0 ]
   	then
   	 logText "Erreur dans la suppression du fichier des contrats" >> $LOG_FILE 
   	fi
   
   cp -p $FILE_IMPORT_LIGNE_CONT  $FILE_IMPORT_LIGNE_CONT`date +"%Y%m%d"`
   	if [ $? -ne 0 ]
   	then
    	logText "Erreur dans le renommage du fichier des lignes contrat" >> $LOG_FILE
   	fi
   rm -f $FILE_IMPORT_LIGNE_CONT 
   	if [ $? -ne 0 ]
   	then
   	 logText "Erreur dans la suppression du fichier des lignes contrat" >> $LOG_FILE 
   	fi	
    
     
   logText "sqlplus" >> $LOG_FILE
   sqlplus -s $CONNECT_STRING << EOF >> $log_tmp 2>&1
   	whenever sqlerror exit failure;
   	!echo "exec pack_esourcing.global_contrat"
   	exec pack_esourcing.global_contrat('$PL_LOGS');
EOF
   
   
    #valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_esourcing.sh (contrats)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
   	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " import_esourcing.sh (contrats) ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Erreur : consulter $LOG_FILE"
   	logText "Erreur d insertion des contrats esourcing sous SQL*Plus" >> $LOG_FILE
	rm -f $log_tmp
	logText "=== ERREUR : Fin ANORMALE du traitement d insertion des donnees en provenance de resao : import_esourcing.sh. ===" >> $LOG_FILE
	exit -3
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	logText "Fin NORMALE du traitement d insertion des donnees en provenance de resao : import_esourcing.sh. ===" >> $LOG_FILE
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_esourcing.sh (contrats)','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0,'OK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " import_esourcing.sh (contrats) OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
	rm -f $log_tmp
fi
   logText "Fin de Import des contrats et lignes contrat eSourcing (`basename $0`)"
   logText "Fin de Import des contrats et lignes contrat eSourcing (`basename $0`)" >> $LOG_FILE

else

     logText " Fichier non detecte. Pas d insertion des donnees dans TMP_CONTRAT ni dans TMP_LIGNE_CONT !!!"
     logText " Fichier non detecte. Pas d insertion des donnees dans TMP_CONTRAT ni dans TMP_LIGNE_CONT !!!" >> $LOG_FILE
	 datefin=`date +'%d/%m/%Y'`
	 heurefin=`date +'%T'`
	 varlog='Fichier non detecte. Pas d insertion des donnees dans TMP_CONTRAT ni dans TMP_LIGNE_CONT !!!' 
	 sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_esourcing.sh (contrats)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'OK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " import_esourcing.sh (contrats) OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
	rm -f $log_tmp

fi

     logText "=== Fin du traitement d insertion des donnees en provenance d esourcing. ==="



exit 0
