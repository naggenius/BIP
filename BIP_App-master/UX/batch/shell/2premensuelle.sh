#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : 2premensuelle.sh
# Objet : Shell batch (Seconde Premensuelle)
#
#_______________________________________________________________________________
# Creation : Equipe SOPRA 10/09/1999
# Modification :
# --------------
# Auteur  Date       Objet
# HTM     02/06/00   Appel Shell avec chemin absolu
# CRI     26/07/02   suppression du param : identifiant du serveur d'edition
# EGR     14/10/02   migration ksh sur SOLARIS 8
# NBM     21/11/03   ajout suivi_financier.sh :maj table CUMUL_CONSO pour IAS
# PJO 	  03/11/04   Fiche 90 : Suppression du shell de lancement de reports.sh
# BAA     03/08/05   Fiche 250 ajout du shell alim_total_jh.sh
# PPR     27/09/05   Ajout synthese_premensuelle.sh
# DDI     24/03/06   Fiche 384 ajout du shell alim_budget_ecart.sh
# ABA     24/06/06   Ajout script pour log via ihm
# YNI     21/01/10   Ajout traitement pour le lancement de alerte_mail.sh
# SEL	  18/11/15   PPM 60709 5.5 alerter la non presence du parametre applicatif TYPETAPES-JEUX / DEFAUT
################################################################################

autoload $(ls $FPATH)

LOG_TRAITEMENT=$DIR_BATCH_SHELL_LOG/$(date +"%Y%m%d").2premensuelle.log
export LOG_TRAITEMENT
logText "`basename $0` : fichier de trace : $LOG_TRAITEMENT"

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.2premensuelletmp.txt
statuttmp=0
#YNI Variable pour stocker les traitements additionnels plantés
VAR_TRT_ADD=" "
#Fin YNI
datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "--------------------------------------------------------------------------------" > $LOG_TRAITEMENT
logText "-- $(date +"%Y%m%d") Debut de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT

###############################################################################
# Lancement des traitements
###############################################################################
logText "-- Lancement de debfintrait.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/debfintrait.sh 'DEBUT TRAITEMENT 2 PRE-MENSUELLE' 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement debfintrait.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('2premensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 2 $heuredebut 2 'debfintrait.sh'
	#Fin YNI
	logText "Problème dans le traitement debfintrait"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 200;
fi

######## concatenation des fichiers bip remontés via l'intranet
logText "-- Lancement de rbip_extract.sh -------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/rbip_extract.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement rbip_extract.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('2premensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 2 $heuredebut 2 'rbip_extract.sh'
	#Fin YNI
	logText "Echec lors de l execution du traitement rbip_extract"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 304;
fi

######## concatenation des fichiers des remonteurs bip
logText "-- Lancement de concatFicBip.sh -------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/concatFicBip.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement concatFicBip.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('2premensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
        #YNI Appel au shell alerte_mail.sh
		$DIR_BATCH_SHELL/alerte_mail.sh 2 $heuredebut 2 'concatFicBip.sh'
		#Fin YNI
		logText "Echec lors de l execution du traitement concatFicBip"
        logText "arrêt du batch `basename $0`"
        unset LOG_TRAITEMENT
        exit 305;
fi


###############################################################################
logText "-- Lancement de stloapmw.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/stloapmw.sh $FILE_PMW_2 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement strloapmw.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('2premensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 2 $heuredebut 2 'strloapmw.sh'
	#Fin YNI
	logText "Problème dans le traitement stloapmw"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 210;
fi
###############################################################################
logText "-- Lancement de isac.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/isac.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement isac.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('2premensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 2 $heuredebut 2 'isac.sh'
	#Fin YNI
	logText "Probleme dans le traitement des donnees isac"
	logText "Arret du batch"
	unset LOG_TRAITEMENT
	exit 125;
fi
###############################################################################
logText "-- Lancement de st54700e.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/st54700e.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement st54700e.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('2premensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 2 $heuredebut 2 'st54700e.sh'
	#Fin YNI
	logText "Problème dans le traitement st54700e"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 212;
fi

################################################################################
logText "-- Lancement de suivi_financier.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/suivi_financier.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement suivi_financier.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('2premensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 2 $heuredebut 2 'suivi_financier.sh'
	#Fin YNI
	logText "Problème dans le traitement suivi_financier"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 214;
fi


###############################################################################
logText "-- Lancement de debfintrait.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/debfintrait.sh 'FIN TRAITEMENT 2 PRE-MENSUELLE' 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement debfintrait.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('2premensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 2 $heuredebut 2 'debfintrait.sh'
	#Fin YNI
	logText "Problème dans le traitement debfintrait"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 299;
fi
###############################################################################
logText "Fin de la seconde prémensuelle" >> $LOG_TRAITEMENT


###############################################################################
logText "-- Traitement(s) additionnel(s) :" >> $LOG_TRAITEMENT
logText "Lancement de alim_total_jh.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/alim_total_jh.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
		statuttmp=1
		echo "Problème dans le traitement alim_total_jh.sh" >> $log_tmp    
        logText "Probl\350me dans le traitement alim_total_jh.sh"
		VAR_TRT_ADD = "${VAR_TRT_ADD}\n alim_total_jh.sh"
fi

###############################################################################
logText "-- Traitement(s) additionnel(s) :" >> $LOG_TRAITEMENT
logText "Lancement de alim_budget_ecart.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/alim_budget_ecart.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
		statuttmp=1
		echo "Problème dans le traitement alim_budget_ecart.sh" >> $log_tmp
        logText "Probl\350me dans le traitement alim_budget_ecart.sh"
		VAR_TRT_ADD = "${VAR_TRT_ADD}\n alim_budget_ecart.sh"
fi

#################### SEL PPM 60709 5.5 : Verifier l'existence du paramétre applicatif TYPETAPES-JEUX / DEFAUT ###########################

#Recherche du parametre applicatif TYPETAPES-JEUX par defaut
NB_PARAM=`sqlplus -s $CONNECT_STRING << ! 
set head off 

select count(*) from ligne_param_bip 
where
trim(code_action)='TYPETAPES-JEUX'
and trim(code_version)='DEFAUT'
and upper(actif)='O'
;

!` 
NB_PARAM=`echo ${NB_PARAM}|sed "s/\n//g"`

#Si parametre applicatif TYPETAPES-JEUX par defaut est introuvable, il faut envoyer un mail d'alerte de type 4
if [ NB_PARAM -eq 0 ]
then

$DIR_BATCH_SHELL/alerte_mail.sh 2 $heuredebut 4 ""

fi

#################### Tables de synthese ###########################
logText "-- Lancement de synthese_premensuelle.sh -------------------------------------------" >>$LOG_TRAITEMENT
$DIR_BATCH_SHELL/synthese_premensuelle.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	statuttmp=1
	echo "Echec lors de l'execution du traitement de synthese premensuelle" >> $log_tmp
	logText "Echec lors de l'execution du traitement de synthese premensuelle"
	VAR_TRT_ADD = "${VAR_TRT_ADD}\n synthese_premensuelle.sh"
fi

if [ $statuttmp -eq 1 ]
then
	statut='NOK'
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	logText "=== ERREUR Fin ANORMALE de la deuxième prémensuelle ===" >> $LOG_TRAITEMENT
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 2 $heuredebut 3 "$VAR_TRT_ADD"
	#Fin YNI
else
	statut='OK'
	logText "=== Fin NORMALE de la  deuxième prémensuelle ===" >> $LOG_TRAITEMENT
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 2 $heuredebut 1 "$VAR_TRT_ADD"
	#Fin YNI
fi
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('2premensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, '$statut');
EOF
	rm -f $log_tmp

unset LOG_TRAITEMENT
exit 0
