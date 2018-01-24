#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : comparedir.sh
# Objet : Shell de comparaison du contenu de deux repertoires
#
#_______________________________________________________________________________
# Creation :
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     18/10/02   Migration ksh SOLARIS 8
#
################################################################################

#

# analyse du pwd local pour savoir avec quoi comparer
# le repertoire de comparaison se trouve dans $OTHER_DIR

#fonctionnement :	si on est en environnement de mainteance, on effectue
#			la comparaison avec l'environnement de recette
#			si on est en environnement de recette, on effectue la
#			comparaison avec l'environnement de mainteance
# RQ : l'env de prod n'est pas a priori sur la meme machine
#	=> comparaison impossible sauf si on met en place un image

pwdLength=$(expr $(pwd) : '.*')
maintLength=$(expr $dirmaint : '.*')
recLength=$(expr $dirrec : '.*')
#echo $maintLength / $recLength
if [ $BIP_ENV = BIP_MAINTENANCE ]
then
	if [ $dirmaint = $(pwd | cut -c1-$maintLength) ]
	then
		OTHER_DIR=$dirrec$(pwd | cut -c$(( $maintLength +1 ))-$pwdLength)
	else
		echo "Il faut se placer dans un repertoire lie a votre environnement actuel !!"
		exit 1
	fi
elif [ $BIP_ENV = BIP_RECETTE ]
then
	if [ $dirrec = $(pwd | cut -c1-$recLength) ]
	then
		OTHER_DIR=$dirmaint$(pwd | cut -c$(( $recLength +1 ))-$pwdLength)
	else
		echo "Il faut se placer dans un repertoire lie a votre environnement actuel !!"
		exit 1
	fi
else
	exit 1
fi

NBRE_DIFF=0
NBRE_LOCAL=0
NBRE_OTHER=0

# On commence par traiter tous les fichiers (autres que repertoires ou liens)
# present en local.
# Pour chacun :
#	test d'existence dans l'autre repertoire
#	si existence : comparaison

for fichier in $(ls -F|grep -v "/"|grep -v "@"|sed s/*//g);
do
	if ! [ -e $OTHER_DIR/$fichier ]
	then
		echo "Le fichier $fichier est absent dans le répertoire source"
		NBRE_OTHER=$(expr $NBRE_OTHER + 1)
	else
		diff $fichier $OTHER_DIR/$fichier > /dev/null 2>&1
		DIFF_EXIT=$?
		if [ $DIFF_EXIT -ne 0 ]
		then
			DATE_OTHER=$(ls -l $OTHER_DIR/$fichier|awk '{print $6, $7, $8}')
			DATE_LOCAL=$(ls -l $fichier|awk '{print $6, $7, $8}')
			echo "Le fichier $fichier est différent : Local=$DATE_LOCAL ; Source=$DATE_OTHER"
			NBRE_DIFF=$(expr $NBRE_DIFF + 1)
		fi
	fi
done

# Pour tous les fichiers presents dans l'autre repertoire on teste
# l'existence dans le repertoire local
for fichier in $(ls -F $OTHER_DIR|grep -v "/"|grep -v "@"|sed s/*//g);
do
        if ! [ -e $fichier ]
        then
                echo "Le fichier $fichier est absent dans le répertoire local"
		NBRE_LOCAL=$(expr $NBRE_LOCAL + 1)
	fi
done

echo " "
echo "Nombre de fichiers manquant en source : $NBRE_OTHER"
echo "Nombre de fichiers manquant en local : $NBRE_LOCAL"
echo "Nombre de fichiers differents : $NBRE_DIFF"

exit 0