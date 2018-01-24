#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : alimsuivijhr.sh
# Objet : Shell batch alimsuivijhr (tous les traitements mensuels)
#	  Shell d'alimentation de la table suivijhr qui sert pour l'\351dition du suivi des remontee jh
#	  on alimente les donn\351es du mois de mensuelle
#
#_______________________________________________________________________________
# Creation : ARE 22/08/2002
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     14/10/02   Migration ksh SOLARIS 8
#
################################################################################
# Obsolete
#################################################
# On charge l'environnement
#################################################
. $APP_ETC/bipparam.sh
#################################################


# Trace de l'execution du batch
# dans le repertoire des logs
RESULT_FILE=$DIR_BATCH_SHELL_LOG/alimsuivijhr.`date +"%Y%m%d"`.log

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
sqlplus -s $ORA_USR_LIVE@$ORA_LIVE <<! > $RESULT_FILE
	whenever sqlerror exit failure;
	execute pack_suivijhr.alim_suivijhr;
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	print 'Problème SQL*PLUS dans batch alimsuivijhr : consulter ' $RESULT_FILE
	print "et le fichier $DIR_BATCH_SHELL_LOG/AAAA.MM.JJ.alimsuivijhr.log du jour"
	exit -1;
fi

print 'ALIMSUIVIJHR OK'

exit 0
