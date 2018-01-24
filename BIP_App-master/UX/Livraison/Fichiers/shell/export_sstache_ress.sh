#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : export_sstache_ress.sh
# Objet : Export des sous taches par ressources
# 
#_______________________________________________________________________________
# Creation : SopraSteria 10/03/2016
# --------------
# Auteur                Date         	Objet
# FAD					16/03/2016		Export des sous tâches par ressource
################################################################################
set -x

####################################################################################
#  				Partie 2 : Export des sous tâches par ressource
####################################################################################

if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.export_sstache_ress.log
		     
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.export_sstache_ress.txt   

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`


logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut l'export des sous-tâches par ressource : export_ress_mois.sh" >> $LOG_FILE

nom_fic_ress="export_sstache_ress.txt"
nom_fic_ress_zip="export_sstache_ress.zip"
nom_xml="x_sstacheress.xml"

#Commande pour acces au serveur report

#Gestion du chemin différent pour l'environnement de dev
if [ $ENV == d ]
then
`/applis/bip${ENV}/OracleReports/instances/inst_reports/config/reports/bin/rwclient.sh userid=$CONNECT_STRING delimiter='aucun' module=$DIR_REPORT/$nom_xml server=$REPORT_SERVER desformat='DELIMITEDDATA' delimited_hdr='no' desname=$DIR_REPORT_OUT/$nom_fic_ress P_param16='Tous' P_param7='*******' P_param6='.TXT' P_param5='0' P_param4='11050' P_param3='01 ' P_param2='3261212' P_param1='A350634' P_param0='fournisseur' P_global='A350634;DIR;11050;3261212;01 ;00000000000;000000000;0;36662,33042,24714,09455;;;;;;ges,isac,ginv,act,fin,supach,acdet,fidet,admin,copi,cli;;dir,me,isacm,inv,ach,suiviact,rbip,ref,ore,req,mo;;000000000' destype=file`
else
`/applis/bip${ENV}/OracleReports/instance_reports/config/reports/bin/rwclient.sh userid=$CONNECT_STRING delimiter='aucun' module=$DIR_REPORT/$nom_xml server=$REPORT_SERVER desformat='DELIMITEDDATA' delimited_hdr='no' desname=$DIR_REPORT_OUT/$nom_fic_ress P_param16='Tous' P_param7='*******' P_param6='.TXT' P_param5='0' P_param4='11050' P_param3='01 ' P_param2='3261212' P_param1='A350634' P_param0='fournisseur' P_global='A350634;DIR;11050;3261212;01 ;00000000000;000000000;0;36662,33042,24714,09455;;;;;;ges,isac,ginv,act,fin,supach,acdet,fidet,admin,copi,cli;;dir,me,isacm,inv,ach,suiviact,rbip,ref,ore,req,mo;;000000000' destype=file`

fi

####################################################################################
################# Compression du fichier au format zip ############################# 

cd $DIR_REPORT_OUT
zip $nom_fic_ress_zip $nom_fic_ress  
 
####################################################################################
################# Envoi des fichiers d'export par mail #############################

#Construction des differents parametres a passer a envoi_mail.sh
REMONTE="M004"
PRIORITE=""
OBJECT="Export Sous-tâches par ressource"
CORPS="Voici l’export des sous-tâches par ressource à l’issu de la mensuelle sur le périmètre complet de l’application .\n\(Format zip)"

PJ="$DIR_REPORT_OUT/$nom_fic_ress_zip;export_sstache_ress.zip"
	echo "# Piece jointe : " $PJ
#PJ=""

#Appel envoi_mail.sh
$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
logText " Envoi du mail avec le fichier de l'export Sous-tâches par ressource." >> $LOG_FILE