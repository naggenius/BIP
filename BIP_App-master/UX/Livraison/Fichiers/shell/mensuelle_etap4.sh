#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : mensuelle.sh
# Objet : Shell batch  (mensuelle)
#
#____________________________________________________________________________________________________________
# Creation : Equipe SOPRA 10/09/1999
# Modification :
# --------------
# Auteur  Date       Objet
# HTM     02/06/00   Appel Shell avec chemin absolu
# EGR     14/10/02   Migration ksh SOLARIS 8
# EGR     28/10/02   Plus de parametre pour les etapes
#		     Suppression de sorties erreur et ajout de traitements
# NBM	  17/11/03   Ajout batch_ias.sh pour la FI et les IMMOS
# NBM     21/11/03   ajout suivi_financier.sh :maj table CUMUL_CONSO pour IAS
# PPR     25/07/05   appel cout_logiciel.sh
# BAA     03/08/05   Fiche 250 ajout du shell alim_total_jh.sh
# BAA     03/11/05   ajout du shell rjh.sh pour lancer le traitement de répartition
# PPR     12/01/06   ajout du shell metrique.sh
# DDI     28/02/06   Ajout des shells de repartition des arbitres et de reestimes (rjh_arb.sh et rjh_ree.sh)
# DDI     24/03/06   Fiche 384 ajout du shell alim_budget_ecart.sh
# BAA     09/01/07   Fiche 460 Nouvelle extraction "suivi-comptable" ajout du shell synth_fin_compta.sh
# EVI     06/03/07   Fiche 531 ajout des shell de repartition des notifies et des proposees (rjh_noti.sh et rjh_prop.sh)
# DDI     25/04/07   Suppression des traitements OSCAR.
# EVI     21/05/07   Ajout du shell ebis_export_realise.sh
# DDI     06/09/07   Deplacement de la repartition des T9 en fin de traitements additionnels
# DDI	  15/11/07   TD 598 : Extraction DIVA des consommes hors perimetre
# JAL      04/12/2007  Supression de l'extraction  DIVA des consommes hors perimetre (elle sera incluse dans un CTRL-M)
# JAL     03/03/2008   Mise en commentaire appel à metrique.sh
#ABA    27/03/2008    Ajout du shell d'export d'adonix
#ABA    15/04/2008    ajout du shell diva_x_conso_hp.sh
#EVI    25/04/2008    Suppression du shell diva_x_conso_hp.sh
#ABA    24/06/2008    ajout script pour log via ihm
#YNI    15/10/2009    supression des appels aux shells: stloadcam.sh, st54702k.sh et entite_structure.sh
#YSB    06/11/2009    déplacement de l'etape 11 à la fin du traitement de la mensuel
# YNI     21/01/2010    Ajout traitement pour le lancement de alerte_mail.sh
# YNI     19/03/2010    Ajout de l'envoi des fichier "EXP_encours.csv" et "FACTINT.txt" par mail si la mensuelle est terminée normalement
# ABA     31/03/2010    Supression du shell fair.sh
# YNI     13/04/2010    FDT 973 Harmonisation des mails
#############################################################################################################

autoload $(ls $FPATH)

LOG_TRAITEMENT=$DIR_BATCH_SHELL_LOG/$(date +"%Y%m%d").mensuelle.log
export LOG_TRAITEMENT
logText "`basename $0` : fichier de trace : $LOG_TRAITEMENT"

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.mensuelletmp.txt
statuttmp=0
#YNI Variable pour stocker les traitements additionnels plantés
VAR_TRT_ADD=" "
#Fin YNI
datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "--------------------------------------------------------------------------------" > $LOG_TRAITEMENT
logText "-- $(date +"%Y%m%d") Debut de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT

######### etape 4 : consolidation PL/SQL #######################################
logText "-- Lancement de st54700e.sh -------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/st54700e.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement st54700e.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('mensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 2 'st54700e.sh'
	#Fin YNI
	logText "Echec lors de l execution du traitement st54700e"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 312;
fi

######## etape 5 : alimentation de la table histo_suivijhr #####################
logText "-- Lancement de alimhisto.sh ------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/alimhisto.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement alimhisto.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('mensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 2 'alimhisto.sh'
	#Fin YNI
	logText "Echec lors de l execution du traitement d alimentation d histo_suivijhr"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 313;
fi
######### etape 6 : maj BUDCONS ################################################
logText "-- Lancement de st54702f.sh -------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/st54702f.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement st54702f.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('mensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 2 'st54702f.sh'
	#Fin YNI
	logText "Echec lors de l execution du traitement st54702f"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 314;
fi

########## etape 9 : maj LIGNE_BIP2 ############################################
logText "-- Lancement de st54700g.sh -------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/st54700g.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement st54700g.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('mensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 2 'st54700g.sh'
	#Fin YNI
	logText "Echec lors de l execution du traitement st54700g"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 324;
fi

##########  chargement de import_niveau.dat #####################################
logText "-- Lancement de import_niveau.sh ------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/import_niveau.sh 
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement import_niveau.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('mensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
        #YNI Appel au shell alerte_mail.sh
		$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 2 'import_niveau.sh'
		#Fin YNI
        logText "Echec lors de l execution du traitement import_niveau"
        logText "arrêt du batch `basename $0`"
        unset LOG_TRAITEMENT
        exit 327;
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
	insert into BATCH_LOGS_BIP values ('mensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 2 'suivi_financier.sh'
	#Fin YNI
	logText "Problème dans le traitement suivi_financier"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 326;
fi


################################################################################
logText "-- Lancement du traitement de repartition" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/rjh.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement rjh.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('mensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 2 'rjh.sh'
	#Fin YNI
	logText "Problème dans le traitement de repartition"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 327;
fi

####################Traitement de Facturation Interne et des Immos (IAS)###########################
DATE_HEURE=`date +"%Y%m%d%H%M%S"`
#LOG_FILE=$DIR_BATCH_SHELL_LOG/$DATE_HEURE.fi.log
logText "-- Lancement de batch_ias.sh -------------------------------------------" >>$LOG_TRAITEMENT
$DIR_BATCH_SHELL/batch_ias.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement batch_ias.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('mensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 2 'batch_ias.sh'
	#Fin YNI
	logText "Echec lors de l'execution du traitement de FI et des Immos"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 328;
fi


######### etape 10 : maj DATDEBEX ##############################################
logText "-- Lancement de rpmoisu.sh --------------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/rpmoisu.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement rpmoisu.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('mensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 2 'rpmoisu.sh'
	#Fin YNI
	logText "Echec lors de l execution du traitement rpmoisu"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 330;
fi

#################### Traitement de bouclage JH ##################################
logText "-- Lancement de bjh.sh ------------------------------------------------" >>$LOG_TRAITEMENT
$DIR_BATCH_SHELL/bjh.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	statuttmp=1
	echo "Problème dans le traitement bjh.sh" >> $log_tmp   
	logText "Probleme dans le traitement bjh"
	VAR_TRT_ADD = "${VAR_TRT_ADD}\n bjh.sh"
fi

#################### Traitement des retours arrières ###########################
logText "-- Lancement de stock_ra.sh -------------------------------------------" >>$LOG_TRAITEMENT
$DIR_BATCH_SHELL/stock_ra.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	statuttmp=1
	echo "Problème dans le traitement stock_ra.sh" >> $log_tmp   
	logText "Echec lors de l'execution du traitement des retours arrieres"
	VAR_TRT_ADD = "${VAR_TRT_ADD}\n stock_ra.sh"
fi

#################### Tables de synthese ###########################
logText "-- Lancement de synthese.sh -------------------------------------------" >>$LOG_TRAITEMENT
$DIR_BATCH_SHELL/synthese.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	statuttmp=1
	echo "Problème dans le traitement synthese.sh" >> $log_tmp   
	logText "Echec lors de l'execution du traitement de synthese"
	VAR_TRT_ADD = "${VAR_TRT_ADD}\n synthese.sh"
fi

logText "-- Lancement de synth_fin.sh -------------------------------------------" >>$LOG_TRAITEMENT
$DIR_BATCH_SHELL/synth_fin.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	statuttmp=1
	echo "Problème dans le traitement synth_fin.sh" >> $log_tmp   
	logText "Echec lors de l'execution du traitement de synth fin"
	VAR_TRT_ADD = "${VAR_TRT_ADD}\n synth_fin.sh"
fi

logText "-- Lancement de synth_fin_compta.sh -------------------------------------------" >>$LOG_TRAITEMENT
$DIR_BATCH_SHELL/synth_fin_compta.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	statuttmp=1
	echo "Problème dans le traitement synth_fin_compta.sh" >> $log_tmp   
	logText "Echec lors de l'execution du traitement de synth fin compta"
	VAR_TRT_ADD = "${VAR_TRT_ADD}\n synth_fin_compta.sh"
fi

#################### Maj Cout Logiciel ###########################
logText "-- Lancement de cout_logiciel.sh -------------------------------------------" >>$LOG_TRAITEMENT
$DIR_BATCH_SHELL/cout_logiciel.sh
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	statuttmp=1
	echo "Problème dans le traitement cout_logiciel.sh" >> $log_tmp   
	logText "Echec lors de l'execution du traitement de maj cout logiciel"
	VAR_TRT_ADD = "${VAR_TRT_ADD}\n cout_logiciel.sh"
fi

###############################################################################
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

###############################################################################
logText "Lancement de alim_bouclage_jh.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/alim_bouclage_jh.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	statuttmp=1
	echo "Problème dans le traitement alim_bouclage_jh.sh" >> $log_tmp   
        logText "Probl\350me dans le traitement alim_bouclage_jh.sh"
	VAR_TRT_ADD = "${VAR_TRT_ADD}\n alim_bouclage_jh.sh"
fi

###############################################################################
#logText "Lancement de metrique.sh" >> $LOG_TRAITEMENT
#$DIR_BATCH_SHELL/metrique.sh 2>> $LOG_TRAITEMENT
#SHELL_EXIT=$?
#if [ $SHELL_EXIT -ne 0 ]
#then
#        logText "Probl\350me dans le traitement metrique.sh"
#fi

###############################################################################
logText "Lancement de ebis_export_realise.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/ebis_export_realise.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	statuttmp=1
	echo "Problème dans le traitement ebis_export_realise.sh" >> $log_tmp   
        logText "Probl\350me dans le traitement ebis_export_realise.sh"
	VAR_TRT_ADD = "${VAR_TRT_ADD}\n ebis_export_realise.sh"
fi

###############################################################################
logText "Lancement de pra_export_conso.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/pra_export_conso.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	statuttmp=1
	echo "Problème dans le traitement pra_export_conso.sh" >> $log_tmp   
        logText "Probl\350me dans le traitement pra_export_conso.sh"
	VAR_TRT_ADD = "${VAR_TRT_ADD}\n pra_export_conso.sh"
fi

###################################################################################################
logText "-- Lancement du traitement de repartition des arbitres" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/rjh_arb.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 2 'rjh_arb.sh'
	#Fin YNI
	logText "Probleme dans le traitement de repartition des arbitres"
	logText "arret du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 373;
fi

###################################################################################################
logText "-- Lancement du traitement de repartition des reestimes" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/rjh_ree.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement rjh_ree.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('mensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 2 'rjh_ree.sh'
	#Fin YNI
	logText "Probleme dans le traitement de repartition des reestimes"
	logText "arret du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 378;
fi

###################################################################################################
logText "-- Lancement du traitement de repartition des notifies" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/rjh_noti.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement rjh_noti.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('mensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 2 'rjh_noti.sh'
	#Fin YNI
	logText "Probleme dans le traitement de repartition des notifies"
	logText "arret du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 379;
fi

###################################################################################################
logText "-- Lancement du traitement de repartition des proposes" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/rjh_prop.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement rjh_prop.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('mensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 2 'rjh_prop.sh'
	#Fin YNI
	logText "Probleme dans le traitement de repartition des proposees"
	logText "arret du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 380;
fi

###################################################################################################
logText "-- Lancement du traitement de recopie de la table synthese_activite" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/synthese_activite_mensuel.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	statuttmp=1
	echo "Problème dans la recopie de la table synthese_activite" >> $log_tmp   
        logText "Probl\350me dans le traitement synthese_activite_mensuel.sh"
	VAR_TRT_ADD = "${VAR_TRT_ADD}\n synthese_activite_mensuel.sh"
fi

# QC 1204 : suppression de la chaine de traitement
#######################    PEPSI   ###########################################################
#logText "-- Lancement du traitement de génération des fichiers PEPSI" >> $LOG_TRAITEMENT
#$DIR_BATCH_SHELL/export_PEPSI.sh 2>> $LOG_TRAITEMENT
#SHELL_EXIT=$?
#if [ $SHELL_EXIT -ne 0 ]
#then
#	statuttmp=1
#	echo "Problème génération fichiers PEPSI" >> $log_tmp   
#        logText "Probl\350me dans le traitement export_PEPSI.sh"
#	VAR_TRT_ADD = "${VAR_TRT_ADD}\n export_PEPSI.sh"
#fi

######### etape 11 : fin traitement ############################################
logText "-- Lancement de debfintrait.sh ----------------------------------------" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/debfintrait.sh 'FIN TRAITEMENT MENSUELLE'
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement debfintrait.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('mensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 2 'debfintrait.sh'
	#Fin YNI
	logText "Echec lors de l execution du traitement debfintrait"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit 399;
fi

################################################################################
logText "------------------------------------------------------------------------" >> $LOG_TRAITEMENT
logText "Fin du traitement MENSUELLE" >> $LOG_TRAITEMENT
logText "------------------------------------------------------------------------" >> $LOG_TRAITEMENT
################################################################################
################################################################################
logText "------------------------------------------------------------------------" >> $LOG_TRAITEMENT
logText "Traitement(s) additionnel(s) :" >> $LOG_TRAITEMENT
logText "------------------------------------------------------------------------" >> $LOG_TRAITEMENT
################################################################################

###################################################################################################
# Fin du batch de mensuelle
if [ $statuttmp -eq 1 ]
then
	statut='NOK'
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	logText "=== ERREUR Fin ANORMALE de la mensuelle ===" >> $LOG_TRAITEMENT
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 3 "$VAR_TRT_ADD"
	#Fin YNI
else
	statut='OK'
	logText "=== Fin NORMALE de la mensuelle ===" >> $LOG_TRAITEMENT
	#YNI Appel au shell alerte_mail.sh
	$DIR_BATCH_SHELL/alerte_mail.sh 3 $heuredebut 1 "$VAR_TRT_ADD"
	#Fin YNI
	
	#YNI FDT 957
	#Cas du fichier EXP_encours.csv
	FILE_EXP_ENCOURS=$DIR_BATCH_DATA/$FICHIER_EXPENSE
	if [ -e $FILE_EXP_ENCOURS ]
	then

			#Construction des differents parametres a passer a envoi_mail.sh
			REMONTE="P002"
			PRIORITE=""
			OBJECT="Fichier IMMOS de la dernière mensuelle du "`date +"%d/%m/%Y"`
			CORPS=""
			CORPS="${CORPS}Veuillez trouver ci joint le fichier IMMOS de la dernière mensuelle du "`date +"%d/%m/%Y"`" à "`date +"%H:%M"`"."
			PJ="$FILE_EXP_ENCOURS;$FICHIER_EXPENSE"
			
			#Appel envoi_mail.sh
			$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
	else

			#Construction des differents parametres a passer a envoi_mail.sh
			REMONTE="P002"
			PRIORITE=""
			OBJECT="Fichier IMMOS de la dernière mensuelle du "`date +"%d/%m/%Y"`
			CORPS=""
			CORPS="${CORPS}--- ATTENTION ----"
			CORPS="${CORPS}\n\n"
			CORPS="${CORPS}Erreur dans le traitement de génération du fichier IMMOS de la dernière mensuelle en date du "`date +"%d/%m/%Y"`" à "`date +"%H:%M"`"."
			CORPS="${CORPS}\n\n"
			CORPS="${CORPS}Merci de contacter la ME"
			PJ=""
			
			#Appel envoi_mail.sh
			$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
	fi

	#Cas du fichier FACTINT.txt
	FILE_FACTINT=$DIR_BATCH_DATA/$FICHIER_FI
	if [ -e $FILE_FACTINT ]
	then

			#Construction des differents parametres a passer a envoi_mail.sh
			REMONTE="P002"
			PRIORITE=""
			OBJECT="Fichier FACINT de la dernière mensuelle du "`date +"%d/%m/%Y"`
			CORPS=""
			CORPS="${CORPS}Veuillez trouver ci joint le fichier FACTINT de la dernière mensuelle du "`date +"%d/%m/%Y"`" à "`date +"%H:%M"`"."
			PJ="$FILE_FACTINT;$FICHIER_FI"
			
			#Appel envoi_mail.sh
			$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
	else

			#Construction des differents parametres a passer a envoi_mail.sh
			REMONTE="P002"
			PRIORITE=""
			OBJECT="Fichier FACINT de la dernière mensuelle du "`date +"%d/%m/%Y"`
			CORPS=""
			CORPS="${CORPS}--- ATTENTION ----"
			CORPS="${CORPS}\n\n"
			CORPS="${CORPS}Erreur dans le traitement de génération du fichier FACINT de la dernière mensuelle en date du "`date +"%d/%m/%Y"`" à "`date +"%H:%M"`"."
			CORPS="${CORPS}\n\n"
			CORPS="${CORPS}Merci de contacter la ME"
			PJ=""
			
			#Appel envoi_mail.sh
			$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
	fi
	#Fin YNI FDT 957
fi
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('mensuelle.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, '$statut');
EOF
	rm -f $log_tmp

unset LOG_TRAITEMENT
exit 0
