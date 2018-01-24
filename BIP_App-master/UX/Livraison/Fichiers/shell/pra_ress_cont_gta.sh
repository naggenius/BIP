#!/bin/ksh
#
#########################################################
# Script unix SHELL
# ------------------------------
# Nom du sript	:  PRA_RESS_CONT.sh
# Desription	:  Les fonctions de ce script sont pour le flux en provenance de prest@chat :
# 			- chargement des fichiers dans les tables tampons 
#			- controle et alimentation des ressources et situation
#			- Controle et alimentation des contrats et ligne contrat
# PARAMETRES :
# ------------
#	- Aucun
#
# HISTORIQUE 
# ----------
# 03/06/2012 - JM.LEDOYEN (Steria) - Fiche 1419 : Création
#
#########################################################


# Chargemement environnement
# --------------------------
# set -x

autoload $(ls $FPATH)

FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.IMPORT_PRA.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

# ======================================================
# RESSOURCES ET SITUATIONS
# ======================================================

# ------------------------------------------------------
# Import ressources et situations dans TMP_RESSOURCE_PRA 
# ------------------------------------------------------

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'import des ressource et situation PRA (`basename $0`)"
logText "Debut de l'import des ressource et situation PRA (`basename $0`)" >> $LOG_FILE
logText "--  Verification de la presence du fichier"
logText "--  Verification de la presence dus fichier" >> $LOG_FILE

# test de l'existence du fichier ressources_PRA.csv

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

cd $RECEPTION
FIC_IMP_RESS=`ls -tr $FIC_PRA_RESS |tail -1`
echo $FIC_IMP_RESS >> $LOG_FILE
FIC_PRA_RESS_OPT=$FIC_IMP_RESS.OPT
logText "NOM FICHIER :  $FIC_IMP_RESS"
FIC_TROUVE=0

if [[ $FIC_IMP_RESS = *RESSOUR*  ]]
	
then 
	FIC_TROUVE=1
	logText "Fichier ressources/situations detecte, Transfert du fichier dans le repertoire d'import" >> $LOG_FILE
		
	mv $RECEPTION/$FIC_IMP_RESS $DIR_BATCH_DATA/$FIC_IMP_RESS
	logText "nom du fichier : $FIC_IMP_RESS "
	
	logText "Lancement import dans la table tampon des ressources et situation PRA" >> $LOG_FILE
	
	log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_PRA_TMP.txt
	
	logText "SQL*Load des ressources/situations depuis PRA"
	logText "SQL*Load des ressources/situations depuis PRA" >> $LOG_FILE
	
	BAD_FILE=$LOG_FILE.PRA.RESS.bad
	DSC_FILE=$LOG_FILE.PRA.RESS.dsc
	LOGLOAD_FILE=$LOG_FILE.PRA.RESS.logload
	
	# chargement des ressources et des situations
	sqlldr $CONNECT_STRING \
		parfile=$DIR_SQLLOADER_PARAM/Load_TMP_RESSOURCE_PRA.par \
		control=$DIR_SQLLOADER_PARAM/Load_TMP_RESSOURCE_PRA.ctl \
		data=$DIR_BATCH_DATA/$FIC_IMP_RESS \
		log=$LOGLOAD_FILE \
		bad=$BAD_FILE \
		discard=$DSC_FILE \
	   	skip=2 >> $LOG_FILE 2>&1
	
	
	# valeur de sortie de SQL*LOAD
	LOAD_EXIT=$?
	# si le loader retourne 0 ou 2, il faut verifier qu'il n'y a pas de codes erreurs 
	# dans le fichier de log
	if [ $LOAD_EXIT -ne 0 ]
	then
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		varlog='Erreur de chargement (ressources/situations) PRA SQL*Loader'
		logText "nom du fichier : $FIC_IMP_RESS "
		logText "Erreur : consulter $LOG_FILE"
		logText "Erreur de chargement des ressources/situations PRA SQL*Loader" >> $LOG_FILE
		logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
		logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('PRA_RESS_CONT.sh (Load ressources/situations)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
		commit;
EOF
		
		echo " PRA_RESS_CONT.sh (ressources) ECHEC" >> $FILE_QUOTIDIENNE
		logText "SQL*Load (Load ressources/situations) PRA Termine"
		logText "SQL*Load (Load ressources/situations) PRA Termine" >> $LOG_FILE
	else
		echo " PRA_RESS_CONT.sh(Load ressources/situations) OK" >> $FILE_QUOTIDIENNE
		logText "SQL*Load (Load ressources/situations) PRA Termine"
		logText "nom du fichier : $FIC_IMP_RESS"
		logText "SQL*Load (Load ressources/situations) PRA Termine" >> $LOG_FILE
		
		
		# Execution du package des ressources et situations
		# Optimisation du fichier
		# -----------------------------------------------------------
		logText "sqlplus --> package de mise à jour des données PRA" >> $LOG_FILE
		sqlplus -s $CONNECT_STRING << EOF >> $log_tmp 2>&1
				whenever sqlerror exit failure;
				!echo "exec PACK_PRA_RESS_CONT.P_PRA_RESS_CONT_OPT"
				exec PACK_PRA_RESS_CONT.P_PRA_RESS_CONT_OPT('$PL_LOGS', '$PL_DATA', '$FIC_PRA_RESS_OPT');
EOF

		logText "nom du fichier : $FIC_PRA_RESS_OPT "
			# test valeur de sortie de SQL*PLUS
	PLUS_EXIT=$?
	if [ $PLUS_EXIT -ne 0 ]
	then
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
		cat $log_tmp >> $LOG_FILE 2>&1
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('PRA_RESS_CONT.sh (ressources)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
		commit;
EOF

		echo " PRA_RESS_CONT.sh(PACKAGE PACK_PRA_RESS_CONT.P_PRA_RESS_CONT_OPT ) ECHEC" >> $FILE_QUOTIDIENNE

		logText "============================"
		logText "Erreur : consulter $LOG_FILE"
		logText "============================"
		logText "Erreur de maj des données PRA sous SQL*Plus" >> $LOG_FILE
		logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
		rm -f $log_tmp
		logText "=== ERREUR : Fin ANORMALE du traitement d optimisation des donnees en provenance de PRA : pra_ress_cont.sh. ===" >> $LOG_FILE
		exit -3
	else
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		cat $log_tmp >> $LOG_FILE 2>&1
		logText "Fin NORMALE du traitement d optimisation des donnees en provenance de PRA : pra_ress_cont.sh. ===" >> $LOG_FILE
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('pra_ress_cont.sh (ressources)','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
		commit;
EOF

		echo " pack_pra_ress_cont.sh OK" >> $FILE_QUOTIDIENNE
		rm -f $log_tmp
	fi

		
	fi
else
	logText " Fichier non detecte. Pas d insertion des donnees dans TMP_RESSOURCE_PRA !!!"
	logText " Fichier non detecte. Pas d insertion des donnees dans TMP_RESSOURCE_PRA !!!" >> $LOG_FILE
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog='Fichier non detecte. Pas d insertion des donnees dans TMP_RESSOURCE_PRA !!!'
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP
	values ('PRA_RES_CONT.sh (Load ressources/situations)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'OK');
	commit;
EOF
fi

# ======================================================
# CONTRATS ET LIGNES CONTRATS
# ======================================================

# -----------------------------------------------------------
# Import des contrats et lignes contrat dans TMP_CONTRAT_PRA 
# -----------------------------------------------------------

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'import des contrats/lignes contrat PRA (`basename $0`)"
logText "Debut de l'import des contrats/lignes contrat PRA (`basename $0`)" >> $LOG_FILE
logText "--  Verification de la presence du fichier"
logText "--  Verification de la presence dus fichier" >> $LOG_FILE

# test de l'existence du fichier ressources_PRA.csv

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

cd $RECEPTION
FIC_IMP_CTRA=`ls -tr $FIC_PRA_CTRA |tail -1`

# Vérification de l'existence du fichier
if [[ $FIC_IMP_CTRA = *CONTRAT* ]] 

then 
	FIC_TROUVE=1
	logText "Fichier contrats/lignes detecte, Transfert du fichier dans le repertoire d'import" >> $LOG_FILE
	mv $RECEPTION/$FIC_IMP_CTRA $DIR_BATCH_DATA/$FIC_IMP_CTRA
	
	logText "Lancement import dans la table tampon des contrats/lignes contrat PRA" >> $LOG_FILE
	
	log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_PRA_TMP.txt
	
	logText "SQL*Load des contrats/lignes depuis PRA"
	logText "SQL*Load des contrats/lignes depuis PRA" >> $LOG_FILE
	
	BAD_FILE=$LOG_FILE.PRA.CTRA.bad
	DSC_FILE=$LOG_FILE.PRA.CTRA.dsc
	LOGLOAD_FILE=$LOG_FILE.PRA.CTRA.logload
	
	# chargement des ressources et des situations
	sqlldr $CONNECT_STRING \
		parfile=$DIR_SQLLOADER_PARAM/Load_TMP_CONTRAT_PRA.par \
		control=$DIR_SQLLOADER_PARAM/Load_TMP_CONTRAT_PRA.ctl \
		data=$DIR_BATCH_DATA/$FIC_IMP_CTRA \
		log=$LOGLOAD_FILE \
		bad=$BAD_FILE \
		discard=$DSC_FILE \
	   	skip=2 >> $LOG_FILE 2>&1
	
	
	# valeur de sortie de SQL*LOAD
	LOAD_EXIT=$?
	# si le loader retourne 0 ou 2, il faut verifier qu'il n'y a pas de codes erreurs 
	# dans le fichier de log
	if [ $LOAD_EXIT -ne 0 ]
	then
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		varlog='Erreur de chargement (contrats/lignes) PRA SQL*Loader'
		logText "Erreur : consulter $LOG_FILE"
		logText "Erreur de chargement des contrats/lignes PRA SQL*Loader" >> $LOG_FILE
		logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
		logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('PRA_RESS_CONT.sh (Load contrats/lignes)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
		commit;
EOF

		echo " PRA_RESS_CONT.sh (contrats/lignes contrat) ECHEC" >> $FILE_QUOTIDIENNE
		logText "SQL*Load (Load contrats/lignes contrat) PRA Termine"
		logText "SQL*Load (Load contrats/lignes contrat) PRA Termine" >> $LOG_FILE
	else
		echo " PRA_RESS_CONT.sh(Load contrats/lignes contrat) OK" >> $FILE_QUOTIDIENNE
		logText "SQL*Load (Load contrats/lignes contrat) PRA Termine"
		logText "SQL*Load (contrats/lignes contrat) PRA Termine" >> $LOG_FILE
	fi
	
else
	logText " Fichier non detecte. Pas d insertion des donnees dans TMP_CONTRAT_PRA !!!"
	logText " Fichier non detecte. Pas d insertion des donnees dans TMP_CONTRAT_PRA !!!" >> $LOG_FILE
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog='Fichier non detecte. Pas d insertion des donnees dans TMP_CONTRAT_PRA !!!'
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP
	values ('PRA_RES_CONT.sh (Load contrats/lignes contrat)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'OK');
	commit;
EOF
	echo " PRA_RESS_CONT.sh(Load contrats/lignes contrat) OK" >> $FILE_QUOTIDIENNE
fi

#Si aucun des deux fichiers n'a été trouvé, arrêt du batch
if [ $FIC_TROUVE -eq 0 ]
then
		logText " Aucun fichier detecte. Arret du traitement."
		logText " Aucun fichier detecte. Arret du traitement." >> $LOG_FILE
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		varlog='Aucun fichier detecte. Arret du traitement.'
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('PRA_RESS_CONT.sh (contrats/lignes)','$datedebut', '$heuredebut','$datefin','$heurefin','',0,0, 'NOK');
		commit;
EOF
	exit -3;
fi

# ==============================================================
# LANCEMENT PACKAGE DES MISES A JOUR :
# - RESSOURCES ET SITUATIONS
# - CONTRATS ET LIGNES CONTRATS
# ==============================================================

# Import des contrats et lignes contrat dans TMP_CONTRAT_PRA 
# -----------------------------------------------------------

	# Execution du package des ressources et situations
	logText "sqlplus --> package de mise à jour des données PRA" >> $LOG_FILE
	sqlplus -s $CONNECT_STRING << EOF >> $log_tmp 2>&1
		whenever sqlerror exit failure;
		!echo "exec PACK_PRA_RESS_CONT_GTA.P_PRA_RESS_CONT_MAIN"
		exec PACK_PRA_RESS_CONT_GTA.P_PRA_RESS_CONT_MAIN('$PL_LOGS');
EOF
		
		
	# test valeur de sortie de SQL*PLUS
	PLUS_EXIT=$?
	if [ $PLUS_EXIT -ne 0 ]
	then
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
		cat $log_tmp >> $LOG_FILE 2>&1
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('PRA_RESS_CONT.sh (contrats/lignes)','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
		commit;
EOF

		echo " PRA_RESS_CONT.sh(PACKAGE PACK_PRA_RESS_CONT_GTA.P_PRA_RESS_CONT_MAIN ) ECHEC" >> $FILE_QUOTIDIENNE

		logText "============================"
		logText "Erreur : consulter $LOG_FILE"
		logText "============================"
		logText "Erreur de maj des données PRA sous SQL*Plus" >> $LOG_FILE
		logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
		rm -f $log_tmp
		logText "=== ERREUR : Fin ANORMALE du traitement d insertion des donnees en provenance de PRA : pack_pra_ress_cont.sh. ===" >> $LOG_FILE
		exit -3
	else
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		cat $log_tmp >> $LOG_FILE 2>&1
		logText "Fin NORMALE du traitement d insertion des donnees en provenance de PRA : pack_pra_ress_cont.sh. ===" >> $LOG_FILE
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('pack_pra_ress_cont.sh ','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
		commit;
EOF

		echo " pack_pra_ress_cont.sh OK" >> $FILE_QUOTIDIENNE
		rm -f $log_tmp
	fi
	
	logText "Fin de Import des données PRA (`basename $0`)"
	logText "Fin de Import des données PRA (`basename $0`)" >> $LOG_FILE
	
####### -------------- FIN SHELL ------------------- ############

