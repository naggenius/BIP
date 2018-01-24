#TODO
for fichier in $(find intranet/aides -name "*");do
	getimpact_file $1 $fichier
done

for fichier in $(find intranet/modeles -name "*");do
	getimpact_file $1 $fichier
done

for fichier in $(find intranet/menus -name "*");do
	getimpact_file $1 $fichier
done

