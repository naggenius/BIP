#!/bin/ksh
# script verif_fichier.sh
# Verification de la bonne reception et emission des fichiers BIP
# YNI     21/01/2010    Ajout traitement pour ecriture dans quotidienne.txt
# ABA     31/03/2010    Supression du test sur les fic hiers fair et adonix
# YNI     13/04/2010    FDT 973 Harmonisation des mails
#################################################
autoload $(ls $FPATH)

#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.verif_TOM.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.verif_TOMtmp.log
echo "========= PROBLEMES TOM ==========" >> $log_tmp

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`
statuttmp=0
logText "Debut du shell verif_TOM.sh" >> $LOG_FILE
# recupère le numero du jour : 1 = lundi 2= mardi 3 = mercredi......
joursem=`date +%w`
################# EXPORT #######################
# TRAITEMENT DU LUNDI AU VENDREDI
if [ $joursem -eq 1 ] || [ $joursem -eq 2 ] || [ $joursem -eq 3 ] || [ $joursem -eq 4 ] || [ $joursem -eq 5 ] 
then
	
	
	#### DIVA DOSSIER PROJET ####
	#FICH_DIVA_DOSSIERS_PROJETS=bip_diva_dossiers_projets.`date +"%Y%m%d"`.csv
	if [ ! -e $EMISSION/$DIVA_DOSSIERS_PROJETS ]
	then
		logText  "DIVA DOSSIERS PROJETS : $FICH_DIVA_DOSSIERS_PROJETS" >> $LOG_FILE
		echo "DIVA DOSSIERS PROJETS : $FICH_DIVA_DOSSIERS_PROJETS" >> $log_tmp
		statuttmp=1
	fi
	
	#### DIVA PROJET ####
	#FICH_DIVA_PROJETS=bip_diva_projets.`date +"%Y%m%d"`.csv
	if [ ! -e $EMISSION/$DIVA_PROJETS ]
	then
		logText  "DIVA PROJETS : $FICH_DIVA_PROJETS" >> $LOG_FILE
		echo "DIVA PROJETS : $FICH_DIVA_PROJETS" >> $log_tmp
		statuttmp=1
	fi
	
	#### DIVA  RESSOURCES ####
	#FICH_DIVA_RESSOURCES=bip_diva_ressources.`date +"%Y%m%d"`.csv
	if [ ! -e $EMISSION/$DIVA_RESSOURCES ]
	then
		logText  "DIVA RESSOURCES : $FICH_DIVA_RESSOURCES" >> $LOG_FILE
		echo "DIVA RESSOURCES : $FICH_DIVA_RESSOURCES" >> $log_tmp
		statuttmp=1
	fi
	
	#### DIVA  LIGNES ####
	#FICH_DIVA_LIGNES=bip_diva_lignes.`date +"%Y%m%d"`.csv
	if [ ! -e $EMISSION/$DIVA_LIGNES ]
	then
		logText  "DIVA LIGNES : $FICH_DIVA_LIGNES" >> $LOG_FILE
		echo "DIVA LIGNES : $FICH_DIVA_LIGNES" >> $log_tmp
		statuttmp=1
	fi
	
	#### EXPENSE CONTRATS ####
	#FICH_EXP_CONTRATS=ebis_x_contrats.D`date +"%d%m%Y"`.csv
	if [ ! -e $EMISSION/$EBIS_FIC_CONTRATS ]
	then
		logText  "EXPENSE CONTRATS : $FICH_EXP_CONTRATS" >> $LOG_FILE
		echo "EXPENSE CONTRATS : $FICH_EXP_CONTRATS" >> $log_tmp
		statuttmp=1
	fi
	
	#### SMS COMPTA  #####
	if [ $joursem -eq 1 ]
	then
		DATE_FIC=`TZ=MET+72 date +"%d%m%y"`
	else
	# traitement du mardi au vendredi on traite le fichier de la veille
		DATE_FIC=`TZ=MET+24 date +"%d%m%y"`
	fi
	#FICH_SMS_COMPTA1=CIAJXFAC.A0374FAC.D${DATE_FIC}1
	if [  -e $EMISSION/$FICHIER_GLOBAL_TMPDATE_FIC$DATE_FIC ] 
	then
		logText  "SMS COMPTA : $FICH_SMS_COMPTA1" >> $LOG_FILE
		echo "SMS COMPTA : $FICH_SMS_COMPTA1" >> $log_tmp
		statuttmp=1
	fi
	# A TRAITER !!!!!!!!!!!!
	#FICH_SMS_COMPTA2=CIAJXFAC.A0374FAC.D${DATE_FIC}2
	#if [  -e $ORA_LIVE_UTL_EXPCOMPTA/$FICH_SMS_COMPTA2 ] || [  -e $ORA_LIVE_UTL_EXPCOMPTA/erreur/$FICH_SMS_COMPTA2 ]
	#then
	#	logText  "SMS COMPTA : $FICH_SMS_COMPTA2" >> $LOG_FILE
	#	echo "SMS COMPTA : $FICH_SMS_COMPTA2" >> $log_tmp
	#	statuttmp=1
	#fi

	# A TRAITER !!!!!!!!!!!!
	#### RESAO RETOUR ####
	# cas particulier du lundi on doit tester le fichier du vendredi soir
	# if [ $joursem -eq 1 ]
	# then
		# DATE_FIC=`TZ=MET+72 date +"%d%m%Y"`
	# else
	#traitement du mardi au vendredi on traite le fichier de la veille
		# DATE_FIC=`TZ=MET+24 date +"%d%m%Y"`
	# fi
	# FICH_RESAO_RETOUR=${DATE_FIC}RETOUR.csv
	# if [ ! -e $DIR_BATCH_DATA/$FICH_RESAO_RETOUR ]
	# then
		# logText  "RESAO RETOUR : $FICH_RESAO_RETOUR" >> $LOG_FILE
		# echo "RESAO RETOUR : $FICH_RESAO_RETOUR" >> $log_tmp
		# statuttmp=1
	# fi
	
	#YNI
	#### Tester l'existance du fichier dpa.dat ####
	#FILE_DPA_CAMO_d=$FILE_DPA_CAMO`date +"%Y%m%d"`
	if [ ! -e $FILE_DPA ]
	then
		logText  " Fichier dpa.dat non detecte!!!" >> $LOG_FILE
		echo " Fichier dpa.dat non detecte!!!" >> $log_tmp
		statuttmp=1
	fi
	
	#### Tester l'existance du fichier import_ES.dat ####
	#FILE_IMPORT_ES_d=$FILE_IMPORT_ES`date +"%Y%m%d"`.Z
	if [ ! -e $FILE_IMPORT_ES ]
	then
		logText  " Fichier import_ES.dat non detecte!!!" >> $LOG_FILE
		echo " Fichier import_ES.dat non detecte!!!" >> $log_tmp
		statuttmp=1
	fi
	#Fin YNI
	
fi

#TRAITEMENT DU SAMEDI
if [ $joursem -eq 6 ]
then
	logText  "=========PROBLEMES EXPORT TOM==========" >> $LOG_FILE
	logText  "========= PROBLEMES EXPORT TOM ==========" >> $log_tmp
	#### DIVA DOSSIER PROJET ####
	 #FICH_DIVA_DOSSIERS_PROJETS=bip_diva_dossiers_projets.`date +"%Y%m%d"`.csv
	if [ ! -e $EMISSION/$DIVA_DOSSIERS_PROJETS ]
	then
		logText  "DIVA DOSSIERS PROJETS : $FICH_DIVA_DOSSIERS_PROJETS" >> $LOG_FILE
	fi
	
	#### DIVA PROJET ####
	#FICH_DIVA_PROJETS=bip_diva_projets.`date +"%Y%m%d"`.csv
	if [ ! -e $EMISSION/$DIVA_PROJETS ]
	then
		logText  "DIVA PROJETS : $FICH_DIVA_PROJETS" >> $LOG_FILE
	fi
fi

################# IMPORT #######################
# TRAITEMENT DU LUNDI AU VENDREDI
if [ $joursem -eq 1 ] || [ $joursem -eq 2 ] || [ $joursem -eq 3 ] || [ $joursem -eq 4 ] || [ $joursem -eq 5 ] 
then
	
	#### RESSOURCE IMMEUBLE ######
	## nous recherchons le fichier personne.col modifié il y a moins 24h
	if [ $joursem -eq 1 ]
	then
		find $DIR_BATCH_DATA -mtime -3 -name PERSONNE.COL |grep PERSONNE.COL
		if [ $? -ne 0 ]
		then
			logText  "RESSOURCE - IMMEUBLE : PERSONNE.COL" >> $LOG_FILE
			echo "RESSOURCE - IMMEUBLE : PERSONNE.COL" >> $log_tmp
			statuttmp=1
		fi
	else
		find $DIR_BATCH_DATA -mtime 0 -name PERSONNE.COL |grep PERSONNE.COL
		if [ $? -ne 0 ]
		then
			logText  "RESSOURCE - IMMEUBLE : PERSONNE.COL" >> $LOG_FILE
			echo "RESSOURCE - IMMEUBLE : PERSONNE.COL" >> $log_tmp
			statuttmp=1
		fi
	fi
	## nous recherchons le fichier immeuble.col modifié il y a moins 24h
	if [ $joursem -eq 1 ]
	then
		find $DIR_BATCH_DATA -mtime -3 -name IMMEUBLE.COL |grep IMMEUBLE.COL
		if [ $? -ne 0 ]
		then
			logText  "RESSOURCE - IMMEUBLE : IMMEUBLE.COL" >> $LOG_FILE
			echo "RESSOURCE - IMMEUBLE : IMMEUBLE.COL" >> $log_tmp
			statuttmp=1
		fi
	else
		find $DIR_BATCH_DATA -mtime 0 -name IMMEUBLE.COL |grep IMMEUBLE.COL
		if [ $? -ne 0 ]
		then
			logText  "RESSOURCE - IMMEUBLE : IMMEUBLE.COL" >> $LOG_FILE
			echo "RESSOURCE - IMMEUBLE : IMMEUBLE.COL" >> $log_tmp
			statuttmp=1
		fi
	fi
	#### DIVA BUDGET ####
	#FICH_DIVA_BUDGET=diva_budget.csv`date +"%Y%m%d"`
	if [ ! -e $RECEPTION/$FILE_DIVA_BUDGET ]
	then
		logText "DIVA BUDGETS : $FICH_DIVA_BUDGET" >> $LOG_FILE
		echo "DIVA BUDGETS : $FICH_DIVA_BUDGET" >> $log_tmp
		statuttmp=1
	fi
	
	#### APPLICATION ####
	#FICH_APPLI=application.dat`date +"%Y%m%d"`.Z
	if [ ! -e $RECEPTION/$FILE_APPLI ]
	then
		logText "APPLICATION : $FICH_APPLI" >> $LOG_FILE
		echo "APPLICATION : $FICH_APPLI" >> $log_tmp
		statuttmp=1
	fi
	
	### EXPENSE FACTURE ####
	#cas particulier du lundi on doit tester le fichier du vendredi soir
	if [ $joursem -eq 1 ]
	then
		DATE_FIC=`TZ=MET+72 date +"%Y%m%d"`
	else
	# traitement du mardi au vendredi on traite le fichier de la veille
		DATE_FIC=`TZ=MET+24 date +"%Y%m%d"`
	fi
	#FICH_EXP_FACTURE=ebis_i_factures.csv${DATE_FIC}
	if [ ! -e $RECEPTION/$EBIS_FIC_FACTURES_TMP$DATE_FIC.RECU ]
	then
		logText  "EXPENSE FACTURE : $FICH_EXP_FACTURE" >> $LOG_FILE
		echo "EXPENSE FACTURE : $FICH_EXP_FACTURE" >> $log_tmp
		statuttmp=1
	fi
fi

# TRAITEMENT DU LUNDI UNIQUEMENT	
if [ $joursem -eq 1 ]
then
	### RTFE ####
	# on doit tester le fichier du vendredi soir
	if [ $joursem -eq 1 ]
	then
		DATE_FIC=`TZ=MET+72 date +"%Y%m%d"`
	fi
	#FICH_RTFE=export_RTFE.${DATE_FIC}.csv
	if [ ! -e $RECTION/$FIC_RTFE_TMP$DATE_FIC.RECU ]
	then
		logText  "RTFE : $FICH_RTFE" >> $LOG_FILE
		echo "RTFE : $FICH_RTFE" >> $log_tmp
		statuttmp=1
	fi
fi

# TRAITEMENT DU JOUR DE LA MENSULLE UNIQUEMENT
datemensuelle=`sqlplus -s $CONNECT_STRING << ! 
set head off 
select to_char(cmensuelle,'DD/MM/YYYY') from datdebex; 
!` 

datejour=`date +'%d/%m/%Y'`

if [ $datemensuelle = $datejour ]
then
	
	#### ABS GERSHWIN ####
	find $DIR_BATCH_DATA -mtime -4 -name abs_gershwin.dat |grep abs_gershwin.dat
	if [ $? -ne 0 ]
	then
		logText  "ABS GERSHWIN : abs_gershwin.dat" >> $LOG_FILE
		echo "ABS GERSHWIN : abs_gershwin.dat" >> $log_tmp
		statuttmp=1
	fi
	
	#### IMPORT NIVEAU ####
	if [ ! -e $RECEPTION/$FILE_IMPORT_NIVEAU ]
	then
		logText "IMPORT NIVEAU : $FILE_IMPORT_NIVEAU" >> $LOG_FILE
		echo "IMPORT NIVEAU $FILE_IMPORT_NIVEAU" >> $log_tmp
		statuttmp=1
	fi
	
fi

#YNI
# TRAITEMENT DU JOUR DE LA MENSUELLE + 1 jour (lendemain)
datetrait=`sqlplus -s $CONNECT_STRING << ! 
set head off 
select to_char(DERTRAIT,'DD/MM/YYYY') from datdebex; 
!` 
if [ $datetrait = $datejour ]
then

	#### EXPORT EBIS ####
	if [ ! -e $EMISSION/$EBIS_FIC_REALISE  ]
	then
		logText "EXPORT EBIS : $EBIS_FIC_REALISE" >> $LOG_FILE
		echo "EXPORT EBIS : $EBIS_FIC_REALISE" >> $log_tmp
	fi
	
	#### EXPORT PEPSI ####
	if [ ! -e $EMISSION/$nom_fic_dossier_projet_pepsi  ]
	then
		logText "EXPORT PEPSI : Dossier_projet.D"`date +"%d%m%Y"`".csv" >> $LOG_FILE
		echo "EXPORT PEPSI : Dossier_projet.D"`date +"%d%m%Y"`".csv" >> $log_tmp
	fi
		
	if [ ! -e $EMISSION/$nom_fic_dossier_projet_copi_pepsi ]
	then
		logText "EXPORT PEPSI : Dossier_projet_copi.D"`date +"%d%m%Y"`".csv" >> $LOG_FILE
		echo "EXPORT PEPSI : Dossier_projet_copi.D"`date +"%d%m%Y"`".csv" >> $log_tmp
		statuttmp=1
	fi
	
	if [ ! -e $EMISSION/$nom_fic_proj_info_pepsi ]
	then
		logText "EXPORT PEPSI : Proj_info.D"`date +"%d%m%Y"`".csv" >> $LOG_FILE
		echo "EXPORT PEPSI : Proj_info.D"`date +"%d%m%Y"`".csv" >> $log_tmp
	    statuttmp=1
	fi
	
	if [ ! -e $EMISSION/$nom_fic_appli_projet_pepsi ]
	then
		logText "EXPORT PEPSI : Appli_projet.D"`date +"%d%m%Y"`".csv" >> $LOG_FILE
		echo "EXPORT PEPSI : Appli_projet.D"`date +"%d%m%Y"`".csv" >> $log_tmp
        statuttmp=1
	fi
	
	if [ ! -e $EMISSION/$nom_fic_dpg_pepsi ]
	then
		logText "EXPORT PEPSI : Dpg.D"`date +"%d%m%Y"`".csv" >> $LOG_FILE
		echo "EXPORT PEPSI : Dpg.D"`date +"%d%m%Y"`".csv" >> $log_tmp
		statuttmp=1
	fi
		
fi


# TRAITEMENT DU JOUR DE LA MENSULLE + 2 jours
datemens=`sqlplus -s $CONNECT_STRING << ! 
set head off 
select to_char(cmensuelle + 2,'DD/MM/YYYY') from datdebex; 
!` 

DATE_FICHIER=`TZ=MET+24 date +"%d%m%Y"`

if [ $datemens = $datejour ]
then
	
	#### EXPORT DIVA X CONSO HP ####
	if [ ! -e $EMISSION/$DIVA_CONSOHP_TMP$DATE_FICHIER.PRET ]
	then
		logText "EXPORT DIVA X CONSO HP : $DIVA_CONSOHP_TMP$DATE_FICHIER.PRET" >> $LOG_FILE
		echo "EXPORT DIVA X CONSO HP : $DIVA_CONSOHP_TMP$DATE_FICHIER.PRET" >> $log_tmp
	fi

fi

# TRAITEMENT DU JOUR DE LA MENSULLE + 3 jours

datetrait=`sqlplus -s $CONNECT_STRING << ! 
set head off 
select to_char(DERTRAIT + 3,'DD/MM/YYYY') from datdebex; 
!` 

moisfair=`date +'%m`
anneefair=`date +%y`

if [ ${moisfair} -ne 10 ]  || [ ${moisfair} -ne 11 ] || [ ${moisfair} -ne 12 ] 
then
	moisfair=`expr $moisfair - 1` 
	if  [ ${moisfair} -eq 0 ] 
	then
	  moisfair=12
	  anneefair=`expr $anneefair - 1` 
	  if [ ${anneefair} -lt 10  ] 
	  then
		anneefair="0"${anneefair}
	  fi
	else
	 moisfair="0"${moisfair}
	fi
	
fi

# TRAITEMENT DU 26 eme JOUR DE CHAQUE MOIS

dateimmo=`date +"%d"`

if [ $dateimmo -eq 26 ]
then

	#### IMMO DEF ####
	if [ ! -e $EMISSION/$EXP_IMMO_DEF  ]
	then
		logText "IMMO DEF : $EXP_IMMO_DEF" >> $LOG_FILE
		echo "IMMO DEF : $EXP_IMMO_DEF" >> $log_tmp
	fi
			
fi


if [ $statuttmp -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('verif_TOM.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	rm -f $log_tmp
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas KO
	echo " verif_TOM.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('verif_TOM.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,null,null, 'OK');
EOF
	rm -f $log_tmp
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " verif_TOM.sh OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
fi

logText "Fin NORMALE du shell verif_TOM.sh  ===" >> $LOG_FILE

#YNI
#Début de fin de la quotidienne.
#contenu du mail
CONTENU=$(<$FILE_QUOTIDIENNE)
if [ $joursem -eq 1 ] || [ $joursem -eq 2 ] || [ $joursem -eq 3 ] || [ $joursem -eq 4 ] || [ $joursem -eq 5 ] || [ $joursem -eq 6 ]
then
		if [ -e $FILE_QUOTIDIENNE ]
		then
				
		#Construction des differents parametres a passer a envoi_mail.sh
		REMONTE="P001"
		PRIORITE=""
		OBJECT="Fin quotidienne du "`TZ=MET+24 date +"%d%m%y"`
		CORPS=""
		CORPS="${CORPS}Ce mail atteste de la fin de la quotidienne."
		CORPS="${CORPS}\n\n"
		CORPS="${CORPS}$CONTENU"
		PJ="$FILE_QUOTIDIENNE;quotidienne.txt"
		
		#Appel envoi_mail.sh
		$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
		fi
fi


exit 0;
