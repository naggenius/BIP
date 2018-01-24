#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : diva_conso_hp.sh
# Objet : Ce script lance la procedure PL/SQL de generation du fichier
# 	  d'export des consommes hors perimetre DIVA.
#_______________________________________________________________________________
# Creation : Equipe BIP (DDI)  12/11/2007
#_______________________________________________________________________________
# Modification :
# --------------
# Auteur        Date            Objet
# DDI           12/11/2007      Creation
#ABA            26/06/2008    Ajout traitement pour affichage des logs via l'ihm bip
# ---------------------------------------------------------------------------
################################################################################

autoload $(ls $FPATH)

#Répertoire d'extraction : EMISSION
REP_EXTRACT=$PL_EMISSION
nom_fic=$DIVA_CONSOHP
				
				
if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.diva_x_consoHP.log        
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi


log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.diva_x_consoHPtmp.txt

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`


############################# EXTRACTION DES CONSOMMES HORS PERIMETRE DIVA #############################
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "SQLPLUS Exec PACK_DIVA.ALIM_CONSO_HP"
logText "SQLPLUS Exec PACK_DIVA.ALIM_CONSO_HP" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACK_DIVA.ALIM_CONSO_HP('$REP_EXTRACT', '$nom_fic');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('diva_x_conso_hp.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_DIVA.ALIM_CONSO_HP : consulter $LOG_FILE"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.DIVA_ALIM_CONSO_HP.log du jour"
	logText "Code erreur : <$PLUS_EXIT>"
	logText "Problème SQL*PLUS lors de l'exécution de la procédure  PACK_DIVA.ALIM_CONSO_HP" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	rm -f $log_tmp
	logText "=== ERREUR : Fin ANORMALE de DIVA X_conso : diva_x_consoHP.sh ===" >> $LOG_FILE
	exit -1;
	
fi

############################# / EXTRACTION DES CONSOMMES HORS PERIMETRE DIVA #############################

datefin=`date +'%d/%m/%Y'`
heurefin=`date +'%T'`
cat $log_tmp >> $LOG_FILE 2>&1
nom_fichier=$REP_EXTRACT/$nom_fic
nbligne=`awk 'END {print NR}' $nom_fichier`
sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('diva_x_conso_hp.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,'$nbligne',0, 'OK');
EOF
rm -f $log_tmp
logText "=== Fin NORMALE de DIVA X_conso : diva_x_consoHP.sh ===" >> $LOG_FILE

exit O

