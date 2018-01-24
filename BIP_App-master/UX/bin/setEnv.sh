#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : setEnvMaint.sh
# Objet : changemement de l'environnement en environnement de MAINTENANCE
# Usage : >. setEnvMaint.sh
#
#_______________________________________________________________________________
# Creation : EGR 22/10/2002
# Modification :
# --------------
# Auteur  Date       Objet
#
################################################################################

if [ $# -ne 1 ]
then
	echo "Usage : setEnv.sh ENVIRONNEMENT" >&2
	echo "\tBIP_MAINTENANCE" >&2
	echo "\tBIP_RECETTE" >&2
	echo "\tBIP_PRODUCTION" >&2
	echo "Environnement par defaut : BIP_MAINTENANCE"
	ENVIR=BIP_MAINTENANCE
else
	ENVIR=$1
fi

unset BIPPARAM_DEFINED
export BIP_ENV=$ENVIR

#################################################
# On charge l'environnement
#################################################
. $APP_ETC/bipparam.sh
#################################################
