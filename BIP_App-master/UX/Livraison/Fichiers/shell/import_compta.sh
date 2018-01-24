#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : import_compta.sh
# Objet :
#       ce script  lance la procedure PL/SQL d'insertion des fichiers
#       d'import compta
#
#_______________________________________________________________________________
# Creation : Equipe BIP (OTO)  24/09/2003
# Modification :
# --------------
# Auteur        Date            Objet
#	OTO			??/11/2003		On recupere l'idenfiant dans l'entete du fichier (pour SGCIB)
#	EGR			06/11/2003		On remplace les '_' de l'identifiant par des '.' (pour SGCIB)
#       MMC			30/06/2004l		Le delete des tables temporaires se fera au niveau du report
#       ABA                      01/04/2008                  Ajout traitement pour affichage des logs via l'ihm bip
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then									
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`_`date +"%H"`H`date +"%M%S"`.import_compta.log
		rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.import_comptatmp.txt
statut=0

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de l'importation compta : import_compta.sh" >> $LOG_FILE
logText "DATE : `date` " >> $LOG_FILE

ls $PL_RECEPTION/$FICH_IMP_CONTRAT.*  > /dev/null 2> /dev/null
if [ $? != 0 ]
then
	logText "Pas de facture a importer. FIN DU TRAITEMENT D IMPORT." >> $LOG_FILE
	#exit 0
else
	logText "Fichier(s) detecte(s). Suite du traitement d import." >> $LOG_FILE
fi

USEROLD=toto

for NOMFIC in `ls $PL_RECEPTION|grep  $FICH_IMP_CONTRAT.`
do

#USERARPEGE=$(echo $NOMFIC | awk '{print substr($0, 19, 7)}')

USERARPEGE=$(head -1 $PL_RECEPTION/$NOMFIC | awk 'BEGIN {FS=";"}{print $2}')
USERARPEGE=$(echo $USERARPEGE | cut -c1-$((${#USERARPEGE}-2)) | tr '_' '.' )

#logText "userold: " $USEROLD

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "fichier traite: $NOMFIC  USER: $USERARPEGE"  >> $LOG_FILE
logText "fichier traite: $NOMFIC  USER: $USERARPEGE"
logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText " "  >> $LOG_FILE

sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
   whenever sqlerror exit failure;
  insert into import_compta_res (userid, etat) values ('$USERARPEGE','IMPORT EN COURS');
  commit;
!

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Execution de la procedure PL/SQL d import" >> $LOG_FILE
logText "sqlplus" >> $LOG_FILE
logText "--------------------------------------------------------------------------------" >> $LOG_FILE

sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
        whenever sqlerror exit failure;
        set serveroutput on size 1000000;
        !echo "execute pack_import_cs1.traite_import_cs1"
        execute pack_import_cs1.traite_import_cs1('$USERARPEGE','$PL_RECEPTION','$NOMFIC');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
		echo "Problème de traitement avec le fichier suivant : " >> $log_tmp
		echo $PL_RECEPTION/$NOMFIC >> $log_tmp
        logText "Problème SQL*PLUS dans batch import_comptable : consulter $LOG_FILE"
        logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
		datefin=`date +'%d/%m/%Y'`
		heurefin=`date +'%T'`
		varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
		sqlplus -s $CONNECT_STRING << EOF
		insert into BATCH_LOGS_BIP values ('import_compta.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
		rm -f $log_tmp
		logText "=== ERREUR : Fin ANORMALE de l'importation compta: import_compta.sh ===" >> $LOG_FILE
		exit -1;
        
fi

# archivage des fichiers

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "archivage de $NOMFIC"  >> $LOG_FILE 
logText "--------------------------------------------------------------------------------" >> $LOG_FILE
mv $PL_RECEPTION/$NOMFIC  $DIR_BATCH_DATA/$NOMFIC
RETOUR=$?
if [ $RETOUR -ne 0 ]
then
        logText "Problème  lors de l archivage du fichier $NOMFIC. Consulter $LOG_FILE"
        logText "Problème  lors de l archivage du fichier $NOMFIC. Consulter $LOG_FILE" >> $LOG_FILE
        logText "Code erreur : <$RETOUR>" >> $LOG_FILE
        exit -1;
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Mise a jour de la table de resultat des imports"  >> $LOG_FILE
logText "--------------------------------------------------------------------------------" >> $LOG_FILE


#Insertion dans la table le resultat de l'import
sqlplus -s $CONNECT_STRING <<! >>$LOG_FILE 2>&1
   whenever sqlerror exit failure;
   exec pack_verif_import.update_import('$USERARPEGE') ;
!
PLUS_EXIT=$?
if [ "$PLUS_EXIT" != "0" ]
   then
    logText "Probleme SQL*PLUS dans import_compta" >> $LOGFILE
	
    exit -1;
fi




USEROLD=$USERARPEGE

done

datefin=`date +'%d/%m/%Y'`
heurefin=`date +'%T'`
sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('import_compta.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
rm -f $log_tmp
logText "=== Fin NORMALE de l'importation compta : import_compta.sh ===" >> $LOG_FILE

exit 0
