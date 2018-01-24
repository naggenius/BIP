#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : search_pack_use.sh
# Objet : repertorie les occurences aux appels de packages
#
#_______________________________________________________________________________
# Creation :
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     18/10/02   Migration ksh SOLARIS 8
#
################################################################################

for fichier in $(find . -name "*");
do
	#on saute les fichiers se trouvant dans un repertoire /old/
	echo $fichier | grep "/old/" > /dev/null 2>&1
	CMD_EXIT=$?
	if [ $CMD_EXIT -eq 1 ]
	then
		#on selectionne les lignes contenant le prefixe de nom des package
		#mais pas celles qui correspondent a une creation (create)
		#ni a la fin de definition (end _packXXXXX)
		grep -i pack_ $fichier 2>/dev/null \
			|grep -vi create \
			|grep -vi "end pack_" > /dev/null
		CMD_EXIT=$?
		if [ $CMD_EXIT -eq 0 ]
		then
			echo "_"$fichier
			grep -i pack_ $fichier 2>/dev/null | \
				grep -vi create | \
				grep -vi "end pack_" | \
				tr '[:lower:]' '[:upper:]' | \
				awk '{ \
					if (substr($0, 1, 2)=="--") next;
					pkgList=$0;
					pos=index(pkgList, "PACK_");
					pkgList=substr(pkgList, pos);
					pos=index(pkgList, ".");
					if (pos==0) pos=length(pkgList)+1;
					print " |_ "substr(pkgList, 1, pos-1)}' | \
				sort -u

			echo " "
		fi
	fi
done

exit 0
