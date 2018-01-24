#!/bin/ksh
#TODO
#
# Olivier DUPREY 04/09/2001
#
# Recoit un fichier en parametre
# Copie ce fichier de la recette dans le repertoire courant
# Necessite la presence du lien avec la recette

. getpath
cp -p $OTHER_DIR/$1 $1

