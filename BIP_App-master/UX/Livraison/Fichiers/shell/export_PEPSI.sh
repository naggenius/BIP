#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : export_PEPSI.sh
# Objet : 
#       ce script recupere lance la procedure PL/SQL de generation des fichiers
#       d'export pour la mise en place des liens TOM avec l'application PEPSI
#_______________________________________________________________________________
# Creation : Equipe BIP (YNI)  10/09/2009
#_______________________________________________________________________________
# Modification :
# --------------
# Auteur        Date            Objet
# 
# ---------------------------------------------------------------------------
################################################################################

autoload $(ls $FPATH)

#Répertoire d'extraction : PL_EMISSION
REP_EXTRACT=$PL_EMISSION


#Noms des fichiers a creer
nom_fic_dossier_projet=$nom_fic_dossier_projet_pepsi
nom_fic_dossier_projet_copi=$nom_fic_dossier_projet_copi_pepsi
nom_fic_proj_info=$nom_fic_proj_info_pepsi
nom_fic_appli_projet=$nom_fic_appli_projet_pepsi
nom_fic_dpg=$nom_fic_dpg_pepsi

statut_pepsi='OK'				
				
if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.BIP_PEPSI.log
		     
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.BIP_PEPSI.txt   

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`



logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut l'export des fichiers de liaison TOM avec PEPSI : export_PEPSI.sh" >> $LOG_FILE







############################# APPEL  export_dossier_projet  #####################################
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_PEPSI.EXPORT_DOSSIER_PROJET" 	
logText "SQLPLUS Exec PACK_PEPSI.EXPORT_DOSSIER_PROJET" >> $LOG_FILE		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;

	execute PACK_PEPSI.export_dossier_projet('$REP_EXTRACT','$nom_fic_dossier_projet');
!
#valeur de sortie de SQL*PLUS								
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then	
	statut_pepsi="NOK"
	
	cat $log_tmp >> $LOG_FILE 2>&1
	logText  "Problème script export_pepsi.sh : Appel procédure SQL*PLUS : PACK_PEPSI.EXPORT_DOSSIER_PROJET "	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script export_PEPSI.sh : Appel procédure SQL*PLUS : PACK_PEPSI.EXPORT_DOSSIER_PROJET " >> $LOG_FILE								
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_PEPSI.EXPORT_DOSSIER_PROJET : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de l'export réalisés pepsi: export_PEPSI.sh ===" >> $LOG_FILE
	
	
else
	
	logText "Fin NORMALE de l'export pepsi: export_dossier_projet ===" >> $LOG_FILE
	
fi		
############################# /  APPEL  export_dossier_projet   #####################################







############################# APPEL  export_dossier_projet_copi  #####################################
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_PEPSI.EXPORT_DOSSIER_PROJET_COPI" 	
logText "SQLPLUS Exec PACK_PEPSI.EXPORT_DOSSIER_PROJET_COPI" >> $LOG_FILE		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;

	execute PACK_PEPSI.export_dossier_projet_copi('$REP_EXTRACT','$nom_fic_dossier_projet_copi');
!
#valeur de sortie de SQL*PLUS								
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then	
	statut_pepsi='NOK'
	
	cat $log_tmp >> $LOG_FILE 2>&1
	
	logText  "Problème script export_pepsi.sh : Appel procédure SQL*PLUS : PACK_PEPSI.EXPORT_DOSSIER_PROJET_COPI "	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script export_PEPSI.sh : Appel procédure SQL*PLUS : PACK_PEPSI.EXPORT_DOSSIER_PROJET_COPI " >> $LOG_FILE								
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_PEPSI.EXPORT_DOSSIER_PROJET_COPI : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de l'export réalisés pepsi: export_PEPSI.sh ===" >> $LOG_FILE
	rm -f $log_tmp
	
else
	

	
	logText "Fin NORMALE de l'export pepsi: export_dossier_projet_copi ===" >> $LOG_FILE
	
fi		
############################# /  APPEL  export_dossier_projet_copi   #####################################



############################# APPEL  export_proj_info  #####################################
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_PEPSI.EXPORT_PROJ_INFO" 	
logText "SQLPLUS Exec PACK_PEPSI.EXPORT_PROJ_INFO" >> $LOG_FILE		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;

	execute PACK_PEPSI.export_proj_info('$REP_EXTRACT','$nom_fic_proj_info');
!
#valeur de sortie de SQL*PLUS								
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then	
	statut_pepsi='NOK'
	
	cat $log_tmp >> $LOG_FILE 2>&1
	
	logText  "Problème script export_pepsi.sh : Appel procédure SQL*PLUS : PACK_PEPSI.EXPORT_PROJ_INFO "	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script export_PEPSI.sh : Appel procédure SQL*PLUS : PACK_PEPSI.EXPORT_PROJ_INFO " >> $LOG_FILE								
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_PEPSI.EXPORT_PROJ_INFO : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de l'export réalisés pepsi: export_PEPSI.sh ===" >> $LOG_FILE
	
	
else

	
	logText "Fin NORMALE de l'export pepsi: export_proj_info ===" >> $LOG_FILE
	
fi		
############################# /  APPEL  export_proj_info   #####################################







############################# APPEL  export_appli_projet  #####################################
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_PEPSI.EXPORT_APPLI_PROJET" 	
logText "SQLPLUS Exec PACK_PEPSI.EXPORT_APPLI_PROJET" >> $LOG_FILE		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;

	execute PACK_PEPSI.export_appli_projet('$REP_EXTRACT','$nom_fic_appli_projet');
!
#valeur de sortie de SQL*PLUS								
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then	
	statut_pepsi="NOK"
	
	cat $log_tmp >> $LOG_FILE 2>&1
	
	logText  "Problème script export_pepsi.sh : Appel procédure SQL*PLUS : PACK_PEPSI.EXPORT_APPLI_PROJET "	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script export_PEPSI.sh : Appel procédure SQL*PLUS : PACK_PEPSI.EXPORT_APPLI_PROJET " >> $LOG_FILE								
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_PEPSI.EXPORT_APPLI_PROJET : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de l'export réalisés pepsi: export_PEPSI.sh ===" >> $LOG_FILE
	
	
else
	
	
	logText "Fin NORMALE de l'export pepsi: export_appli_projet ===" >> $LOG_FILE
	
	fi		
############################# /  APPEL  export_appli_projet   #####################################







############################# APPEL  export_dpg  #####################################
# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_PEPSI.EXPORT_DPG" 	
logText "SQLPLUS Exec PACK_PEPSI.EXPORT_DPG" >> $LOG_FILE		
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;

	execute PACK_PEPSI.export_dpg('$REP_EXTRACT','$nom_fic_dpg');
!
#valeur de sortie de SQL*PLUS								
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then	
	statut_pepsi= "NOK"
	
	cat $log_tmp >> $LOG_FILE 2>&1
	
	logText  "Problème script export_pepsi.sh : Appel procédure SQL*PLUS : PACK_PEPSI.EXPORT_DPG "	
	logText "Code erreur : <$PLUS_EXIT>"
	logText  "Problème script export_PEPSI.sh : Appel procédure SQL*PLUS : PACK_PEPSI.EXPORT_DPG " >> $LOG_FILE								
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_PEPSI.EXPORT_DPG : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de l'export réalisés pepsi: export_PEPSI.sh ===" >> $LOG_FILE
	
	
else
	
	
	logText "Fin NORMALE de l'export pepsi: export_dpg ===" >> $LOG_FILE
	
fi		
############################# /  APPEL  export_dpg   #####################################

if [ $statut_pepsi == 'NOK' ]
then

	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('export_pepsi.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,null, 'NOK');
EOF
	logText "=== ERREUR : Fin ANORMALE de l'export réalisés pepsi: export_PEPSI.sh ===" >> $LOG_FILE
	rm -f $log_tmp
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	
	nom_fichier1=$EMISSION/$nom_fic_dpg
	nbligne1=`awk 'END {print NR}' $nom_fichier1`
	
	nom_fichier2=$EMISSION/$nom_fic_proj_info
	nbligne2=`awk 'END {print NR}' $nom_fichier2`
	
	nom_fichier3=$EMISSION/$nom_fic_dossier_projet_copi
	nbligne3=`awk 'END {print NR}' $nom_fichier3`
	
	nom_fichier4=$EMISSION/$nom_fic_dossier_projet
	nbligne4=`awk 'END {print NR}' $nom_fichier4`
	
	nom_fichier5=$EMISSION/$nom_fic_appli_projet
	nbligne5=`awk 'END {print NR}' $nom_fichier5`
	
	
	nbligne=`expr $nbligne1 + $nbligne2 + $nbligne3 + $nbligne4 + $nbligne5`

	
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('export_pepsi.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,'$nbligne',null, 'OK');
EOF
	logText "Fin NORMALE de l'export réalisés pepsi: export_PEPSI.sh ===" >> $LOG_FILE
	rm -f $log_tmp
	
####################################################################################
####################################################################################
####################################################################################
################# Envoi des fichiers d'export par mail #############################

#Construction des differents parametres a passer a envoi_mail.sh
REMONTE="M002"
PRIORITE=""
OBJECT="Fichiers de la Bip "`date +"%d/%m/%Y"`
CORPS=""
CORPS="${CORPS}Veuillez trouver ci joint les fichiers en date du "`date +"%d/%m/%Y"`" en provenance de l'application BIP.\n\nCordialement."

PJ="$REP_EXTRACT/$nom_fic_dpg;$nom_fic_dpg $REP_EXTRACT/$nom_fic_proj_info;$nom_fic_proj_info"
PJ="${PJ} $REP_EXTRACT/$nom_fic_appli_projet;$nom_fic_appli_projet"
PJ="${PJ} $REP_EXTRACT/$nom_fic_dossier_projet_copi;$nom_fic_dossier_projet_copi  $REP_EXTRACT/$nom_fic_dossier_projet;$nom_fic_dossier_projet"

#Appel envoi_mail.sh
$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
logText " Envoi du mail avec les fichiers de l'export PEPSI." >> $LOG_FILE

####################################################################################
####################################################################################
####################################################################################
	
fi

exit O

