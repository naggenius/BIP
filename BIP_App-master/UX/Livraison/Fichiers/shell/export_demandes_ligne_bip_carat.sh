#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom of File : export_demandes_ligne_bip_carat.sh
# Object : GENERATION AND TRANSFER OF EXTRACTION OF REQUESTS AND BIP LINES FOR CARAT
# 
#_______________________________________________________________________________
# Creation : Steria 23/08/2017
# Modification : Initial copy
# --------------
# Auteur                Date         	Objet
# Nagesh				23/08/2017		Initial copy
################################################################################
set -x

#echo $PARAMS


if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.export_demandes_ligne_bip_carat.log
		     
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi
log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.export_demandes_ligne_bip_carat.txt
datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`
logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Begining of the execution : export_demandes_ligne_bip_carat.sh" >> $LOG_FILE


#nom_xml="x_ressmoi_carat.xml"
nom_xml="x_demandeLigneBip.xml"


#Command to access server for report generation
logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Command to access server for report generation" >> $LOG_FILE
#$NOM_DEMETLIGNES



if [ $ENV == d ]
then
	`/applis/bip${ENV}/OracleReports/instances/inst_reports/config/reports/bin/rwclient.sh userid=bip/bip@dbipdb01 server='RptSvr_DBIPLX02_inst_reports' delimiter=';' module=$DIR_REPORT/$nom_xml desformat='DELIMITEDDATA' delimited_hdr='yes' desname=$EMISSION/$NOM_DEMETLIGNES P_param5='0' P_param4='11050' P_param3='01 ' P_param2='' P_param1='A350634' P_param0='fournisseur'  P_global='A350634;ME;11050;;01 ;00000000000;000000000;0;36662;;;;;;ges,ges,cli,isac,ginv,act,fin,supach,acdet,fidet,admin,copi;;me,dir,me,mo,isacm,inv,ach,suiviact,rbip,ref,ore,req;;' destype=file`
 else
	`/applis/bip${ENV}/OracleReports/instance_reports/config/reports/bin/rwclient.sh userid=$CONNECT_STRING delimiter=';' module=$DIR_REPORT/$nom_xml server=$REPORT_SERVER desformat='DELIMITEDDATA' delimited_hdr='yes' desname=$EMISSION/$NOM_DEMETLIGNES P_param5='0' P_param4='11050' P_param3='01 ' P_param2='' P_param1='A350634' P_param0='fournisseur' P_global='A350634;ME;11050;;01 ;00000000000;000000000;0;36662;;;;;;ges,ges,cli,isac,ginv,act,fin,supach,acdet,fidet,admin,copi;;me,dir,me,mo,isacm,inv,ach,suiviact,rbip,ref,ore,req;;' destype=file`
fi


logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "End of Report execution" >> $LOG_FILE

####################################################################################
################# Initiating TOM transfer ############################# 
cd $EMISSION

if [ -e $NOM_DEMETLIGNES ]
then
 	logText "File generated in Emission Successfully: $NOM_DEMETLIGNES" >> $LOG_FILE  
 	logText "Initiating TOM transfer" >> $LOG_FILE
     $DIR_BATCH_SHELL/tom_envoi.sh $NOM_DEMETLIGNES
    CMD_EXIT=$?
    if [ $CMD_EXIT -ne 0 ]
	then
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		varlog=$CMD_EXIT
		cat $log_tmp >> $LOG_FILE 2>&1
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('export_demandes_ligne_bip_carat.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
		   logText "TOM transfer Failed" >> $LOG_FILE   
		logText "Echec du transfert TOM : Code erreur : <$CMD_EXIT>" 
		logText "Echec du transfert TOM : Code erreur : <$CMD_EXIT>" >> $LOG_FILE
		rm -f $log_tmp
		logText "=== ERREUR : Fin ANORMALE de l'export Projet  : export_demandes_ligne_bip_carat.sh ===" 
		logText "=== ERREUR : Fin ANORMALE de l'export Projet  : export_demandes_ligne_bip_carat.sh ===" >> $LOG_FILE

		exit -1;
	else
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		cat $log_tmp >> $LOG_FILE 2>&1
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('export_demandes_ligne_bip_carat.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
		   
EOF
		logText "TOM transfer Completed" >> $LOG_FILE 
		logText "Fin NORMALE de l'export Projet  : export_demandes_ligne_bip_carat.sh ==="
		logText "Fin NORMALE de l'export Projet  : export_demandes_ligne_bip_carat.sh ===" >> $LOG_FILE
	fi  
else

		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		varlog=$CMD_EXIT
		cat $log_tmp >> $LOG_FILE 2>&1
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('export_demandes_ligne_bip_carat.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
		logText "TOM transfer Failed - file not exists in EMISSION folder" >> $LOG_FILE
		logText "Echec du transfert TOM : Code erreur : <$CMD_EXIT>" 
		logText "Echec du transfert TOM : Code erreur : <$CMD_EXIT>" >> $LOG_FILE
		rm -f $log_tmp
		logText "=== ERREUR : Fin ANORMALE de l'export Projet  : export_demandes_ligne_bip_carat.sh ===" 
		logText "=== ERREUR : Fin ANORMALE de l'export Projet  : export_demandes_ligne_bip_carat.sh ===" >> $LOG_FILE

		exit -1;    


fi




####################################################################################