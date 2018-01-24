#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : WL_rename_reports_hist.sh
# Objet : met a jour les reports historique
#
#
#_______________________________________________________________________________
# Creation :
# EGR     28/10/03
#
# Modification :
# --------------
# Auteur  	Date       Objet
# E.GREVREND	  19/10/04	MAJ WLS7
# A.SAKHRAOUI     03/04/07      MAJ WLS9
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.WL_rename_reports_hist.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" > $LOG_FILE
logText "-- $(date +"%Y%m%d") Debut de $0" >> $LOG_FILE
logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "-- Repertoire de fichier reports (.rdf) : $DIR_REPORT" >> $LOG_FILE
logText "-- Repertoire de fichier reports (.rdf) : $DIR_REPORT"
logText "--------------------------------------------------------------------------------" >> $LOG_FILE

LISTE_REPORTS="prodec2 prohist prodeta reshist profil_fi profil_domfonc"

logText "Recuperation du shema dont les .rdf vont etre mis a jour"
logText "Recuperation du shema dont les .rdf vont etre mis a jour" >> $LOG_FILE
# 1) Recuperer le shema le plus 'jeune' a partir de la table ref_histo
SCHEMA=$(sqlplus -s $CONNECT_STRING <<! 2>> $LOG_FILE
	whenever sqlerror exit failure;
	set heading off
	set headsep off
	set echo off
	select NOM_SCHEMA from REF_HISTO where MOIS in (select max(MOIS) from ref_histo);
!)

PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch $(basename $0) : consulter $LOG_FILE"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

#recup code retour
SCHEMA=$(echo $SCHEMA | tr [:upper:] [:lower:])
logText "Shema : $SCHEMA"
logText "Shema : $SCHEMA" >> $LOG_FILE

CODE_RETOUR=0
for REPORT in $LISTE_REPORTS
do
	cp $DIR_REPORT/$REPORT.rdf "$DIR_REPORT/$REPORT"_$SCHEMA.rdf 2>> $LOG_FILE
	CP_EXIT=$?
	if [ $CP_EXIT -ne 0 ]
	then
		logText "Echec de la recopie de $REPORT.rdf sur $REPORT"_$SCHEMA.rdf
		logText "Echec de la recopie de $REPORT.rdf sur $REPORT"_$SCHEMA.rdf >> $LOG_FILE
		logText "Code erreur : <$CP_EXIT>" >> $LOG_FILE
		logText "" >> $LOG_FILE
		CODE_RETOUR=$(($CODE_RETOUR+1))
	else
		logText "$REPORT.rdf recopie sur "$REPORT"_$SCHEMA.rdf"
		logText "$REPORT.rdf recopie sur "$REPORT"_$SCHEMA.rdf" >> $LOG_FILE
	fi
done

logText "Nombre de fichiers en erreur : $CODE_RETOUR" >> $LOG_FILE
logText "Fin du traitement (`basename $0`)" >> $LOG_FILE

exit $CODE_RETOUR
