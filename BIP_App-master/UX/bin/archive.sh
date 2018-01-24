#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : archive.sh
# Objet : Shell utilise pour archiver les fichier
#
# Parametres d'entree :
#	$1...	liste des fichiers a archiver
#_______________________________________________________________________________
# Creation :
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     16/10/02   Migration ksh sur SOLARIS 8
#
################################################################################

for fichier in $*
do
	if [ -f old/$fichier.`date +"%Y%m%d"` ]
	then
		print 'Fichier' $fichier.`date +"%Y%m%d"` 'est deja archive'
	else
		cp -p $fichier old/$fichier.`date +"%Y%m%d"` 2> /dev/null
		CMD_EXIT=$?
		if [ $CMD_EXIT -ne 0 ]
		then
			print 'Echec lors de la copie de' $fichier
		fi
	fi
done

exit 0
