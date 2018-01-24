#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : compil_histo.sh
# Objet : script de compilation du batch pour la base historique
#	  log dans compil_histo.log
#	  ce programme doit etre lance dans le repertoire
#
#
#_______________________________________________________________________________
# Creation : ?????
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     04/11/02   Migration ksh sur SOLARIS 8
#
################################################################################
#WIP gestion des shema => test parametre ?
#################################################
# On charge l'environnement
#################################################
. $APP_ETC/bipparam.sh
#################################################

HIST_SHEMA=$1
FICHIER_LOG=compil_histo.log

print "Compilation sur l'instance $HIST_SHEMA"
echo "Compilation sur l'instance $HIST_SHEMA" > $FICHIER_LOG
sqlplus $ORA_USR_HIST@$HIST_SHEMA <<! >> $FICHIER_LOG
	--***********************************
	-- Compilation de TRCLOG.sql
	--***********************************
	prompt "Compilation package TRCLOG";
	@$DIR_PLSQL_BATCH/trclog.sql
	show errors

	--***********************************
	-- Compilation de 14Mois.sql
	--***********************************
	prompt "Compilation package 14MOIS";
	@$DIR_PLSQL_COMMUN/14mois.sql
	show errors
!

PLUS_EXIT=$?
exit $PLUS_EXIT
