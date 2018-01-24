#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : getimpact_file.sh
# Objet : determiner si un fichier donne ($1) est cite dans un autre fichier ($2)
#
# Parametres d'entree :
#	$1	fichier dont on cherche les references
#	$2	fichier sur lequel porte la recherche
#
#_______________________________________________________________________________
# Creation :
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     18/10/02   Migration ksh SOLARIS 8
#                    Modification du code de retour et ajout d'une erreur
#
################################################################################

echo $2 | grep "log" > /dev/null 2>&1
CMD_EXIT=$?
if [ $CMD_EXIT -eq 0 ]
then
	#fichier de log, sans interet
	exit 0
fi

echo $2 | grep "old" > /dev/null 2>&1
CMD_EXIT=$?
if [ $CMD_EXIT -eq 0 ]
then
	#fichier obsolete, sans interet
	exit 0
fi

# 28/10/02 EGR :
#avant grep -i $1 $2 2>/dev/null | grep -i $1 > /dev/null
# le 2eme grep avait du etre utilise pour separer les 2 redirections
grep -i $1 $2  > /dev/null 2>&1
CMD_EXIT=$?

#le grep retourne '1' s'il n'y a pas d'occurence du paterne ... on ne le traite pas
case $CMD_EXIT in
	0)
		echo "******************************"
		echo $2
		echo "******************************"
		grep -i $1 $2 2>/dev/null
		echo " ";;
	2)
		echo "Probleme de lecture avec "$2;;
esac

exit $CMD_EXIT