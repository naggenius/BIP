#!/bin/ksh

echo "-----------------"
echo "  Script recherchant tous les packages de l'application à recompiler"
echo "-----------------"

if test $# -ne 2; then
	echo
	echo "Usage : $0 [connection base] [répertoire]"
	echo
	echo "  connection base : User/PassWord@Connect"
	echo "  répertoire      : Le répertoire de base dans lequel il faut rechercher les fichiers SQL"
	echo
	exit 1
fi

echo
echo "--> Recherche en cours..."

echo "sqlplus -S $1 << EOF" > compile_all_sql_g.sh
echo "spool compile_all_sql.log" >> compile_all_sql_g.sh
for fichier in $(find $2 -name "*.sql" -print | \
	grep -v "script_extract.sql"  | \
	grep -v "script_a_lancer.sql" | \
	grep -v "script_commun.sql"   | \
	grep -v "script_report.sql"   | \
	grep -v "script_isac.sql"     | \
	grep -v "compile_batchs.sql"  | \
	grep -v "compilInvalidPackage.sql" | \
	grep -v "create_message2load.sql" | \
	grep -v "$2/oracle/" | \
	grep -v "14mois.sql" | \
	grep -v "oscar_sstache.sql" | \
	grep -v "esourcing_retour.sql" | \
	sort )
do
	echo "@"$fichier >> compile_all_sql_g.sh
done
echo "EOF" >> compile_all_sql_g.sh
chmod 744 compile_all_sql_g.sh

echo
echo "--> Le fichier 'compile_all_sql_g.sh' contenant tous les packages à recompiler a été créé."
echo
echo "Pour la compilation veuillez lancer le script 'compile_all_sql_g.sh'."
echo
echo

# compile_all_sql_g.sh
