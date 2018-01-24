#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : compile_maint.sh
# Objet : Shell generant le fichier compila_all_sql_g.sh qui va executer
#	  l'ensemble des fichiers .sql presents dans le repertoire source
#
# Parametres d'entree :
#	[ $1 ]	x : lance l'execution du fichier genere
#_______________________________________________________________________________
# Creation : ????
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     04/11/02   Migration ksh SOLARIS 8
#		     ajout d'une option facultative pour executer le fichier
#
################################################################################

#################################################
# On charge l'environnement
#################################################
. $APP_ETC/bipparam.sh
#################################################

EXEC_SH=0
if [ $? -gt 0 ]
then
	if [ $1 = "x" ] || [ $1 = "X" ]
	then
		EXEC_SH=1
	fi
fi

FICHIER_OUT=compile_all_sql_g.sh

echo "# Fichier genere par le shell $0" > $FICHIER_OUT
echo ". $APP_ETC/bipparam.sh" >> $FICHIER_OUT

echo 'sqlplus -S $ORA_USR_LIVE@$ORA_LIVE << EOF' >> $FICHIER_OUT

for fichier in $(find $DIR_SOURCE -name "*.sql" -print)
do
	echo "@"$fichier >> $FICHIER_OUT
done

echo "EOF" >> $FICHIER_OUT

#droits de lecture et execution donne aux autres utilisateurs
chmod 744 $FICHIER_OUT

#execution du fichier
if [ $EXEC_SH -eq 1 ]
then
	$FICHIER_OUT
fi

exit

