#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : export_ress_mois.sh
# Objet : Export des ressources par mois et Export des sous tâches par ressource
# 
#_______________________________________________________________________________
# Creation : Steria 20/03/2013
# Modification : KRA PPM 61918 - Steria 20/04/2015 : Ajout Export des sous tâches par ressource
# --------------
# Auteur                Date         	Objet
# FAD					16/03/2016		Suppression de la partie Export des sous tâches par ressource
################################################################################
set -x

################################################################################
#  				Partie 1 : Export des ressources par mois
################################################################################
# KRA 22/04/2015 PPM 61918 : PARAMS="P_param8='DIR' P_param7='*******' P_param6='.CSV' P_param5='0' P_param4='11050' P_param3='01 ' P_param2='3261212' P_param1='A350634' P_param0='fournisseur' P_global='A350634;DIR;11050;3261212;01 ;00000000000;000000000;0;36662,33042,24714,09455;;;;;;ges,isac,ginv,act,fin,supach,acdet,fidet,admin,copi,cli;;dir,me,isacm,inv,ach,suiviact,rbip,ref,ore,req,mo;;000000000' "

#echo $PARAMS


if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.export_ress_mois.log
		     
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.export_ress_mois.txt   

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

FICHIER="ressource_par_mois.csv"

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut l'export des ressources par mois : export_ress_mois.sh" >> $LOG_FILE

nom_fic_ress="export_ress_mois.csv"
nom_fic_ress_zip="export_ress_mois.zip"
nom_xml="x_ressmoi.xml"
# KRA 22/04/2015 PPM 61918 : OPTIONS="destype=file"

#Commande pour acces au serveur report

#Gestion du chemin différent pour l'environnement de dev
if [ $ENV == d ]
then
# KRA 22/04/2015 PPM 61918 : sudo su - $APP_USER -c "/applis/bip${ENV}/OracleReports/instances/inst_reports/config/reports/bin/rwclient.sh userid=$CONNECT_STRING delimiter=';' module='$DIR_REPORT/$nom_xml' server='$REPORT_SERVER' desformat='DELIMITEDDATA' delimited_hdr='yes' desname='$DIR_REPORT_OUT/$nom_fic_ress' $PARAMS $OPTIONS"
`/applis/bip${ENV}/OracleReports/instances/inst_reports/config/reports/bin/rwclient.sh userid=$CONNECT_STRING delimiter=';' module=$DIR_REPORT/$nom_xml server=$REPORT_SERVER desformat='DELIMITEDDATA' delimited_hdr='yes' desname=$DIR_REPORT_OUT/$nom_fic_ress P_param8='DIR' P_param7='*******' P_param6='.CSV' P_param5='0' P_param4='11050' P_param3='01 ' P_param2='3261212' P_param1='A350634' P_param0='fournisseur' P_global='A350634;DIR;11050;3261212;01 ;00000000000;000000000;0;36662,33042,24714,09455;;;;;;ges,isac,ginv,act,fin,supach,acdet,fidet,admin,copi,cli;;dir,me,isacm,inv,ach,suiviact,rbip,ref,ore,req,mo;;000000000' destype=file`
else
# KRA 22/04/2015 PPM 61918 : sudo su - $APP_USER -c "applis/bip${ENV}/OracleReports/instance_reports/config/reports/bin/rwclient.sh userid=$CONNECT_STRING delimiter=';' module='$DIR_REPORT/$nom_xml' server='$REPORT_SERVER' desformat='DELIMITEDDATA' delimited_hdr='yes' desname='$DIR_REPORT_OUT/$nom_fic_ress' $PARAMS $OPTIONS"
`/applis/bip${ENV}/OracleReports/instance_reports/config/reports/bin/rwclient.sh userid=$CONNECT_STRING delimiter=';' module=$DIR_REPORT/$nom_xml server=$REPORT_SERVER desformat='DELIMITEDDATA' delimited_hdr='yes' desname=$DIR_REPORT_OUT/$nom_fic_ress P_param8='DIR' P_param7='*******' P_param6='.CSV' P_param5='0' P_param4='11050' P_param3='01 ' P_param2='3261212' P_param1='A350634' P_param0='fournisseur' P_global='A350634;DIR;11050;3261212;01 ;00000000000;000000000;0;36662,33042,24714,09455;;;;;;ges,isac,ginv,act,fin,supach,acdet,fidet,admin,copi,cli;;dir,me,isacm,inv,ach,suiviact,rbip,ref,ore,req,mo;;000000000' destype=file`
fi


####################################################################################
################# Compression du fichier au format zip ############################# 

cd $DIR_REPORT_OUT
zip $nom_fic_ress_zip $nom_fic_ress  
 
####################################################################################
################# Envoi des fichiers d'export par mail #############################

#Construction des differents parametres a passer a envoi_mail.sh
REMONTE="M003"
PRIORITE=""
OBJECT="Export Ressources par mois"
CORPS="Voici l’export des ressources par mois à l’issu de la mensuelle sur le périmètre complet de l’application .\n\(Format zip)"

PJ="$DIR_REPORT_OUT/$nom_fic_ress_zip;export_ress_mois.zip"
	echo "# Piece jointe : " $PJ
#PJ=""

#Appel envoi_mail.sh
$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
logText " Envoi du mail avec le fichier de l'export Ressources par mois." >> $LOG_FILE

####################################################################################


#KRA PPM 62325 - 20/11/2015 : Extraction des demandes et lignes BIP
################################################################################
#  				Partie 3 : Extraction des demandes et lignes BIP
################################################################################

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.Extract_demandes_lignesBIP.log

	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.Extract_demandes_lignesBIP.txt   

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'extraction des demandes et lignes BIP : export_ress_mois.sh" >> $LOG_FILE

nom_fic_ress="Extract_demandes_lignesBIP.csv"
nom_fic_ress_zip="Extract_demandes_lignesBIP.zip"
nom_xml="x_demandeLigneBip.xml"

#Commande pour acces au serveur report

#Gestion du chemin différent pour l'environnement de dev
if [ $ENV == d ]
then
	`/applis/bip${ENV}/OracleReports/instances/inst_reports/config/reports/bin/rwclient.sh userid=bip/bip@dbipdb01 server='RptSvr_DBIPLX02_inst_reports' delimiter=';' module=$DIR_REPORT/$nom_xml desformat='DELIMITEDDATA' delimited_hdr='yes' desname=$DIR_REPORT_OUT/$nom_fic_ress P_paramM='M' P_param5='0' P_param4='11050' P_param3='01 ' P_param2='' P_param1='A350634' P_param0='fournisseur'  P_global='A350634;ME;11050;;01 ;00000000000;000000000;0;36662;;;;;;ges,ges,cli,isac,ginv,act,fin,supach,acdet,fidet,admin,copi;;me,dir,me,mo,isacm,inv,ach,suiviact,rbip,ref,ore,req;;' destype=file`
 else
	`/applis/bip${ENV}/OracleReports/instance_reports/config/reports/bin/rwclient.sh userid=$CONNECT_STRING delimiter=';' module=$DIR_REPORT/$nom_xml server=$REPORT_SERVER desformat='DELIMITEDDATA' delimited_hdr='yes' desname=$DIR_REPORT_OUT/$nom_fic_ress P_paramM='M' P_param5='0' P_param4='11050' P_param3='01 ' P_param2='' P_param1='A350634' P_param0='fournisseur' P_global='A350634;ME;11050;;01 ;00000000000;000000000;0;36662;;;;;;ges,ges,cli,isac,ginv,act,fin,supach,acdet,fidet,admin,copi;;me,dir,me,mo,isacm,inv,ach,suiviact,rbip,ref,ore,req;;' destype=file`
fi


####################################################################################
################# Compression du fichier au format zip ############################# 

cd $DIR_REPORT_OUT
zip $nom_fic_ress_zip $nom_fic_ress  
 
####################################################################################
################# Envoi des fichiers d'export par mail #############################

#Construction des differents parametres a passer a envoi_mail.sh
REMONTE="M005"
PRIORITE=""
OBJECT="Extract. des demandes et lignes BIP"
CORPS="Voici l’extraction des demandes et lignes BIP à l’issu de la mensuelle sur le périmètre complet de l’application .\n\(Format zip)"

PJ="$DIR_REPORT_OUT/$nom_fic_ress_zip;Extract_demandes_lignesBIP.zip"
echo "# Piece jointe : " $PJ
#PJ=""

#Appel envoi_mail.sh
$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
logText " Envoi du mail avec le fichier de l'extraction des demandes et lignes BIP." >> $LOG_FILE

####################################################################################

