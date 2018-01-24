#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : search_pack.sh
# Objet : ce script recherche tous les fichiers contenant des corps de package SQL
# Remarque : lors du passage a clear-case, la commande ne devra pas etre lancee
#		a partir de la racine, car le find partira en boucle infinie due
#		a un montage en boucle
#
#_______________________________________________________________________________
# Creation : 
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     18/10/02   Migration ksh sur SOLARIS 8
#                    affiche la liste de tous les packages des fichiers
#                    et plus seulement le premier
#		  
#
################################################################################

PKG_PREFIXE="PACK_"

for fichier in $(find . -name "*.sql");
do
	grepRes=`grep -i create $fichier 2>/dev/null \
		| grep -i package 2>/dev/null \
		| grep -i body 2>/dev/null`
	#echo $grepRes
	
	GREP_EXIT=$?
	if [ $GREP_EXIT -ne 0 ]
	then
		echo "Le fichier $fichier ne contient pas de package body."
		echo " "
	else
		#conversion en lettres capitales
		grepRes=$(echo $grepRes | tr '[:lower:]' '[:upper:]')
		
		#affichade du nom du fichier puis de la liste des packages qu'il contiend
		echo "_"$fichier" : "
		echo $grepRes | awk '{ for ( i=1; i<= NF; i++ )  if ( index($i, "PACK_") == 1 ) { print "  |_ "$i} }'
		echo " "
	fi
done

exit 0

# explication du awk
# NF : nombre de champs de la ligne courante
# Remarque : grepRes contiend toutes les occurence sur une seule 'ligne'
# index($i, "PACK_") > 0 : vrai si $i commence par PACK_
