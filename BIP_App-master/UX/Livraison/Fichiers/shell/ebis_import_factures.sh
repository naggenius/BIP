#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : ebis_import_factures.sh
# Objet : Shell-script d'import des factures
#         provenant de l'application Expense-Bis (XBIS).
#
# Parametres d'entree:
#	$1	Fichier log (facultatif)
#_______________________________________________________________________________
# Creation     : David DEDIEU 18/06/2007
#_______________________________________________________________________________
# Modification : 
#ABA       01/04/2008    Ajout traitement pour affichage des logs via l'ihm bip
#ABA       21/08/2009	TD 792 Ajout de envoi automatique des rejets par mail
# YNI       22/12/2009    FDT 901 Ajout du test sur la taille du fichier REJET FACTURES
# YNI       21/01/2010    Ajout traitement pour ecriture dans quotidienne.txt
# YNI       13/04/2010    FDT 973 Annulation de l'envoi du premier mail attestant le debut de la quotidienne
################################################################################

autoload $(ls $FPATH)
set -x
#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

# Fichier log
# ############
	if [ -z $LOG_TRAITEMENT ]
	then
		LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_xbis_factures.log
		rm $LOG_FILE 2> /dev/null
		logText "`basename $0` : fichier de trace : $LOG_FILE"
	else
		LOG_FILE=$LOG_TRAITEMENT
	fi

logText "Début de l'importation de factures ebis : ebis_import_factures.sh" >> $LOG_FILE
statuttmp=0

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_xbis_facturestmp.txt
	
datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

FILE_IMPORT_FACTURES=$RECEPTION/$EBIS_FIC_FACTURES	
FILE_REJET_FACTURES=$FILE_REJET_FACTURES
FILE_LOG_TRAITEMENT_PLSQL=`date +"%Y.%m.%d"`.ALIM_EBIS_FACTURES.log

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'import des factures XBIS (`basename $0`)"
logText "Debut de l'import des factures XBIS (`basename $0`)" >> $LOG_FILE

logText "--  Verification de la presence du fichier"
logText "--  Verification de la presence du fichier" >> $LOG_FILE

# Test de l'existence du fichier ????????????.csv
# ################################################

#if [ -a $FILE_IMPORT_FACTURES ]
if [ -e $FILE_IMPORT_FACTURES ]
 
then if [ -s $FILE_IMPORT_FACTURES ]
 
then logText "Fichier detecte, Lancement de ebis_import_factures.sh" >> $LOG_FILE

logText "SQL*Load des factures XBIS"
logText "SQL*Load des factures XBIS" >> $LOG_FILE

LOGLOAD_FILE=$DIR_SQLLOADER_LOG/`date +"%Y%m%d"`.import_xbis_facturestmp
BAD_FILE=$LOG_FILE.1.bad
DSC_FILE=$LOG_FILE.1.dsc
LOGLOAD_FILE=$LOG_FILE.1.logload


# Chargement des budgets dans la table temporaire
# ################################################
sqlldr $CONNECT_STRING \
	parfile=$DIR_SQLLOADER_PARAM/stload_ebis_facture.par \
	control=$DIR_SQLLOADER_PARAM/stload_ebis_facture.ctl \
	data=$FILE_IMPORT_FACTURES \
	log=$LOGLOAD_FILE \
	bad=$BAD_FILE \
	discard=$DSC_FILE >> $LOG_FILE 2>&1 

# Valeur de sortie de SQL*LOAD
# #############################
LOAD_EXIT=$?
# si le loader retourne 0 ou 2, il faut verifier qu'il n'y a pas de codes erreurs 
# dans le fichier de log
if [ $LOAD_EXIT -ne 0 ]
then
	statuttmp=1
	logText "Erreur : consulter $LOG_FILE"
	echo "Erreur de chargement des factures XBIS SQL*Loader" >> $log_tmp
	logText "Erreur de chargement des factures XBIS SQL*Loader" >> $LOG_FILE
	logText "Consulter le fichier de log du loader : $LOGLOAD_FILE" >> $LOG_FILE
	logText "Code erreur : <$LOAD_EXIT>" >> $LOG_FILE
        
fi
logText "SQL*Load des factures XBIS Termine"
logText "SQL*Load des factures XBIS Termine" >> $LOG_FILE


# Compression et renommage du fichier
# ####################################
cp -p $FILE_IMPORT_FACTURES  $FILE_IMPORT_FACTURES`date +"%Y%m%d"`
	if [ $? -ne 0 ]
	then
 	 logText "Erreur dans le renommage du fichier des factures XBIS" >> $LOG_FILE
	fi
rm -f $FILE_IMPORT_FACTURES 
	if [ $? -ne 0 ]
	then
	 logText "Erreur dans la suppression du fichier des factures XBIS" >> $LOG_FILE 
	fi





# MAJ des factures XBIS
# ############################
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING << EOF >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	!echo "PACK_EXPENSEBIS.ALIM_EBIS_FACTURES"
	execute PACK_EXPENSEBIS.ALIM_EBIS_FACTURES('$PL_LOGS','$PL_DATA','$FILE_REJET_FACTURES');
EOF

PLUS_EXIT=$?
####################################################################################
####################################################################################
####################################################################################
################# Envoi du fichier des rejets par mail #############################

#Construction des differents parametres a passer a envoi_mail.sh
REMONTE="E001"
PRIORITE=""
OBJECT="[EXP] Traitement du "`date +"%d/%m/%Y"`
CORPS=""
CORPS="${CORPS}voici les fichiers générés suite au traitement des factures expense."

#YNI FDT 901 : Ajout du test sur la taille du fichier $FILE_REJET_FACTURES
if [ -s $DIR_BATCH_DATA/$FILE_REJET_FACTURES ]
then
	PJ="$DIR_BATCH_DATA/$FILE_REJET_FACTURES;$FILE_REJET_FACTURES $HOME_BIP/log/plsql/$FILE_LOG_TRAITEMENT_PLSQL;log_Traitement.log"
	#Appel envoi_mail.sh
	$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
	logText " Envoi du mail avec le fichier des rejets factures." >> $LOG_FILE
else
	PJ="$HOME_BIP/log/plsql/$FILE_LOG_TRAITEMENT_PLSQL;log_Traitement.log"
	#Appel envoi_mail.sh
	$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
	logText " Envoi du mail sans le fichier des rejets factures." >> $LOG_FILE
fi



####################################################################################
####################################################################################
####################################################################################


# Valeur de sortie de SQL*PLUS
# #############################

if [ $PLUS_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	nom_fichier=$FILE_IMPORT_FACTURES`date +"%Y%m%d"`
	nbligne=`awk 'END {print NR}' $nom_fichier`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('ebis_import_factures.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,'$nbligne', 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " ebis_import_factures.sh OK" > $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Erreur : consulter $LOG_FILE"
	logText "et le fichier $DIR_SQLLOADER_LOG/AAAA.MM.JJ.ebis_import_factures.log du jour"
	logText "Erreur integration factures XBIS sous SQL*Plus" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de l'importation de factures ebis : ebis_import_factures.sh ===" >> $LOG_FILE
else
	if [ $statuttmp -eq 1 ]
	then
		statut='NOK'
		varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
		#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
		echo " ebis_import_factures.sh ECHEC" > $FILE_QUOTIDIENNE
		#Fin YNI
	else
		statut='OK'
		#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
		echo " ebis_import_factures.sh OK" > $FILE_QUOTIDIENNE
		#Fin YNI
	fi
	
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	nom_fichier=$FILE_IMPORT_FACTURES`date +"%Y%m%d"`
	nbligne=`awk 'END {print NR}' $nom_fichier`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('ebis_import_factures.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,'$nbligne', '$statut');
EOF
	rm -f $log_tmp
	logText "=== Fin NORMALE de l'importation de factures ebis : ebis_import_factures.sh ===" >> $LOG_FILE
fi
else
echo " Fichier EBIS vide. Pas d insertion des donnees dans EBIS_IMPORT_FACTURE !!!" >> $log_tmp
	echo " Fin NORMALE du traitement d insertion : 0 lignes importees." >> $log_tmp
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('ebis_import_factures.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'OK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " ebis_import_factures.sh OK" > $FILE_QUOTIDIENNE
	#Fin YNI
     logText " Fichier XBIS vide. Pas d insertion des donnees dans EBIS_IMPORT_FACTURE !!!"
     logText " Fichier XBIS vide. Pas d insertion des donnees dans EBIS_IMPORT_FACTURE !!!" >> $LOG_FILE
	 logText " Fin NORMALE du traitement d insertion : 0 lignes importees." >> $LOG_FILE
	 	rm -f $log_tmp
		
	#Construction des differents parametres a passer a envoi_mail.sh
	REMONTE="E001"
	PRIORITE=""
	OBJECT="[EXP] Traitement du "`date +"%d/%m/%Y"`
	CORPS=""
	CORPS="${CORPS}Le fichier Expense est vide, il n'y a pas d'insertion de données dans la table facture."
	PJ=""
	
	#Appel envoi_mail.sh
	$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
		
cp -p $FILE_IMPORT_FACTURES  $FILE_IMPORT_FACTURES`date +"%Y%m%d"`
rm -f $FILE_IMPORT_FACTURES 


				
fi
else
	echo " Fichier EBIS non detecte. Pas d insertion des donnees dans EBIS_IMPORT_FACTURE !!!" >> $log_tmp
	echo " ERREUR : Fin ANORMALE du traitement d insertion des factures en provenance de EBIS." >> $log_tmp
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('ebis_import_factures.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
     logText " Fichier XBIS non detecte. Pas d insertion des donnees dans EBIS_IMPORT_FACTURE !!!"
     logText " Fichier XBIS non detecte. Pas d insertion des donnees dans EBIS_IMPORT_FACTURE !!!" >> $LOG_FILE
	 logText "=== ERREUR : Fin ANORMALE de l'importation de factures ebis : ebis_import_factures.sh ===" >> $LOG_FILE
	 #YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	 echo " ebis_import_factures.sh ECHEC" > $FILE_QUOTIDIENNE
	 #Fin YNI
	 	rm -f $log_tmp
fi

#On deplace le fichier apres traitement
mv $FILE_IMPORT_FACTURES`date +"%Y%m%d"` $DIR_BATCH_DATA/$EBIS_FIC_FACTURES

rm -f $DIR_SQLLOADER_LOG/$FILE_REJET_FACTURES



exit 0

