#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : clear-ctrl_M.sh
# Objet : ce script retire tous les retours chariots (code ascii 13)
#
#_______________________________________________________________________________
# Creation :
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     14/10/02   Migration ksh sur SOLARIS 8
#
################################################################################
# RQ : si c'est pour la recup de fichier dos, il existe une fonction dos2unix ...

# Pour tous les fichiers .sql .htm et .sh
for fichier in $(ls *.sql *.htm *.sh);
do
	#on recherche la presence  de \r, si trouve le awk retourne 1, retourne 0 sinon
	result=`awk 'BEGIN {trouve=0}/\r/ {trouve=1}END {print trouve}' $fichier`

	#si il y a un \r dans le fichier courant
	if [ $result -eq 1 ]
	then
		#on fait un backup du fichier
		fichier_old=old/$fichier.`date +"%Y%m%d"`
		cp -p $fichier $fichier_old
		if [ $? -ne 0 ]
		then
			echo "Erreur lors de la copie de $fichier en $fichier_old !"
			exit 1;
		fi

		#on retire du fichier toutes les occurence de \r
		nawk '{gsub(/\r/, "");print}' $fichier_old > $fichier
		if [ $? -ne 0 ]
		then
			echo "Erreur lors de la modification de $fichier !"
			exit 2;
		fi

		echo "Mise à jour de $fichier avec archivage de $fichier_old"
	fi
done

#sortie sans erreurs
exit 0