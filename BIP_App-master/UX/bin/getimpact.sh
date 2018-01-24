#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : getimpact.sh
# Objet : recherche les fichiers contenant un lexeme donne
#
# Parametres d'entree :
#	$1	lexeme recherche
#
#_______________________________________________________________________________
# Creation : Equipe SOPRA 10/09/1999
# Modification :
# --------------
# Auteur  Date       Objet
# HTM     02/06/00   Appel Shell avec chemin absolu
# CRI     26/07/02   suppression du param : identifiant du serveur d'edition
# EGR     14/10/02   Migration ksh sur SOLARIS 8
#
###############################################################################

if [ $# -ne 1 ]
then
	echo "Usage : $0 lexeme" >&2
	exit 1
fi


echo "        #########   reports    ###########"
for fichier in $(find reports -name "*.rdf");
do
	getimpact_file $1 $fichier
done

echo "        #########   oracle/data ###########"
for fichier in $(find oracle/data -name "*");
do
	getimpact_file $1 $fichier
done

echo "        #########     source/plsql     ###########"
for fichier in $(find source/plsql -name "*.sql");
do
	getimpact_file $1 $fichier
done

echo "        #########     batch     ###########"
for fichier in $(find batch -name "*");
do
	echo $fichier|grep "dat" > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
		getimpact_file $1 $fichier
	fi
done

echo "        #########     intranet     ###########"
for fichier in $(find intranet -name "*");
do
	echo $fichier|grep "log" > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
		getimpact_file $1 $fichier
	fi
done
