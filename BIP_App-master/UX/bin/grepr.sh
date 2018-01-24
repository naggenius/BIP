#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : grepr.sh
# Objet : recherche d'un lexeme dans toute l'arborescence d'un rep donne
#
# Parametres d'entree :
#	$1	lexeme recherche
#	$2	repertoire a parcourir
#_______________________________________________________________________________
# Creation : Philippe DARRACQ 04/01/2001
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     04/11/02   Migration ksh SOLARIS 8
#
################################################################################

if [ $? -ne 2 ]
then
	echo "Usage : $0 LEXEME REP" >&2
	echo "LEXEME est le mot a rechercher a travers l'arborescence de REP" >&2
	exit -1
fi

LEXEME=$1
REP_SEARCH=$2

#on memorise le repertoire de travail courant
DIR_PWD=$PWD
cd $REP_SEARCH

echo "Recherche par Grep de la chaine $LEXEME dans $REP_SEARCH"
date

# cut -f2 -d. : deuxieme champ avec comme separateur le .
#for W_FIC in `cat | du | cut -f2 -d.`
for W_FIC in `du | cut -f2 -d.`
do
	echo "$LEXEME $W_FIC"
	W_FIC_DIR=$REP_SEARCH$W_FIC/*
	#echo $LEXEME ' ' $W_FIC_DIR
	grep -l -i $LEXEME $W_FIC_DIR 2> /dev/null
done

#on retourne au repertoire de travail
cd $DIR_PWD
#grep -l $1 $2/*

exit 0