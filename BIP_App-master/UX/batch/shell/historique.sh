#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : historique.sh
# Objet : Shell de gestion du processus d'historisation
#
#_______________________________________________________________________________
# Creation : Equipe SOPRA 24/02/2000
# Modification :
# --------------
# Auteur  Date       Objet
# SOPRA   26/04/00   Prise en compte dans LISTE_REPORTS prodec2  du lot3B
#                    et dans LISTE_PLSQL de projprin.sql du lot3B
#                    (Rem: ce projprin remplace celui du lot3A)
#                    Ajout dans sql LISTE_TABLE_HISTO deux fichiers tmp_conso_sstache
#                    et tmp_budget_sstache ainsi que les deux sequences qui vont avec.
# HTM     02/06/00   R\351cup\351ration USERID/PASSWORD \340 partir
#                    variables environnement
# EGR     14/10/02   Migration ksh SOLARIS 8
# EGR     22/10/02   suppression de la redef des variables d'environnement ORACLE
#                    les logs dans $DIR_BATCH_SHELL_LOG
# EGR	  03/02/05	 - ajout de la compilation du pack_global
#					 - retrait de LISTE_REPORTS qui n'etait plus utilise
#ABA       19/08/2008    Ajout traitement pour affichage des logs via l'ihm bip
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.historique.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi


log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.historiquetmp.txt

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`


logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de historique (`basename $0`)"
logText "Debut de historique (`basename $0`)" >> $LOG_FILE

LISTE_PLSQL="$DIR_PLSQL/prodeta $DIR_PLSQL/prohist $DIR_PLSQL/reshist $DIR_PLSQL/prodec2 $DIR_PLSQL/global $DIR_PLSQL/habilitation"

FIC_SHEMA=`date +"%Y%m%d"`.historique.schema
LOG_FILEHISTO=historique

#---------------------------------------------------------------------------
# ETAPE 2 : Determination du schema de sauvegarde
#---------------------------------------------------------------------------

logText "-- Determination du schema de sauvegarde ---------------------------------------"
logText "-- Determination du schema de sauvegarde ---------------------------------------" >>$LOG_FILE

logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	!echo "execute pack_schema_histo.ajout_schema"
	execute pack_schema_histo.ajout_schema('$PL_LOGS');
	!echo "execute pack_historique.select_nom_schema_a_ecraser"
	execute pack_historique.select_nom_schema_a_ecraser('$PL_DATA','$FIC_SHEMA');
!

PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('historique.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Problème SQL*PLUS : consulter $LOG_FILE"
	logText "Erreur SQL*PLUS : <$PLUS_EXIT>" >> $LOG_FILE
	rm -f $log_tmp
	logText "=== ERREUR : Fin ANORMALE de historique : historique.sh ===" >> $LOG_FILE
	exit 1;
else
	cat $log_tmp >> $LOG_FILE 2>&1
fi

if [ -f "$DIR_BATCH_DATA/$FIC_SHEMA" ]
then
	NOM_SCHEMA=`cat $DIR_BATCH_DATA/$FIC_SHEMA`
	logText "NOM_SCHEMA=<$NOM_SCHEMA>"
	logText "NOM_SCHEMA=<$NOM_SCHEMA>" >> $LOG_FILE
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog='Erreur dans historique.sh : fichier $DIR_BATCH_DATA/$FIC_SHEMA non cree'
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('historique.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Erreur dans historique.sh : fichier $DIR_BATCH_DATA/$FIC_SHEMA n'a pas ete cree"
	logText "Erreur dans historique.sh : fichier $DIR_BATCH_DATA/$FIC_SHEMA n'a pas ete cree" >>$LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de historique : historique.sh ===" >> $LOG_FILE
	exit 2;
fi

#---------------------------------------------------------------------------
# ETAPE 3 : Copie du schema courant dans un des schemas de sauvegarde
#---------------------------------------------------------------------------
logText "-- Copie du schema courant dans un des schemas de sauvegarde ----------------"
logText "-- Copie du schema courant dans un des schemas de sauvegarde ----------------" >> $LOG_FILE

logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRINGH <<! > $log_tmp 2>&1
	whenever sqlerror exit failure;

	!echo "execute pack_14mois.sauve_14mois"
	execute pack_14mois.sauve_14mois('$PL_LOGS','$LOG_FILEHISTO');
!

PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('historique.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	rm -f $log_tmp
	logText "Problème SQL*PLUS pack_14mois.sauve_14mois : consulter $LOG_FILE"
	logText "Problème SQL*PLUS pack_14mois.sauve_14mois :  consulter $PL_DATA_HIST/`date +"%Y.%m.%d"`.$LOG_FILEHISTO.log" >> $LOG_FILE
	logText "Erreur pack_14mois.sauve_14mois : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de historique : historique.sh ===" >> $LOG_FILE
	exit 3;
else
	cat $log_tmp >> $LOG_FILE 2>&1
fi

#---------------------------------------------------------------------------
# ETAPE 4 : Compilation des sources PLSQL associés au reports
#---------------------------------------------------------------------------
logText "-- Compilation  PL/SQL ---------------------------------------------------------"
logText "-- Compilation  PL/SQL ---------------------------------------------------------" >> $LOG_FILE

TMP_FILE=$TMPDIR/$(date +"%Y%m%d%H%M%S").historique.tmp

for i in $LISTE_PLSQL;
do
	echo "@$i" >> $TMP_FILE
done

logText "-- Contenu du Fichier de compilation :" >> $LOG_FILE
cat $TMP_FILE >> $LOG_FILE 2>&1
logText "----- Fin -----" >>$LOG_FILE

logText "-- Execution de $TMP_FILE"
logText "-- Execution de $TMP_FILE" >> $LOG_FILE
logText "sqlplus" >> $LOG_FILE
indice=`echo $NOM_SCHEMA | cut -c5-`
CONNECT_SCHEMA="\$CONNECT_STRINGH${indice}"
SCHEMA=`eval echo $CONNECT_SCHEMA`
sqlplus -s $SCHEMA <<! > $log_tmp 2>&1
	whenever sqlerror exit failure;
	!echo "@$TMP_FILE"
	@$TMP_FILE
!

PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('historique.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#rm -f $log_tmp
	logText "Problème SQL*PLUS lors de l'execution de $TMP_FILE : consulter $LOG_FILE"
	logText "Erreur d'execution de $TMP_FILE : <$PLUS_EXIT>" >> $LOG_FILE
	logText "=== ERREUR : Fin ANORMALE de historique : historique.sh ===" >> $LOG_FILE
	exit 5;
fi

rm $TMP_FILE 2>> $LOG_FILE

logText "historique (`basename $0`)"
logText "Fin du traitement Historique (`basename $0`)" >> $LOG_FILE

datefin=`date +'%d/%m/%Y'`
heurefin=`date +'%T'`
cat $log_tmp >> $LOG_FILE 2>&1
sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('historique.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	rm -f $log_tmp
	logText "=== Fin NORMALE de historique : historique.sh ===" >> $LOG_FILE

exit 0
