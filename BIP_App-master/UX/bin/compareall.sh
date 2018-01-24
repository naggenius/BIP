#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : compareall.sh
# Objet : ce script lance la comparaison de tous les repertoires listes dans le
#         le fichier path.lst
#
#_______________________________________________________________________________
# Creation :
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     18/10/02   Migration ksh sur SOLARIS 8
#
################################################################################

. $APP_ETC/bipparam.sh

FICHIER_LST=$APP_BIN/compareall.lst

if ! [ -e $FICHIER_LST ]
then
	echo "$FICHIER_LST contenant la liste des repertoires a comparer n'existe pas" >&2
	exit 1
fi

#cat $(dirname $0)/path.lst | while read path
for path in $(cat $FICHIER_LST);
do
	echo "############################################"
	echo "$path"
	echo "############################################"
	cd $HOME_BIP/$path
	$APP_BIN/comparedir.sh
done
