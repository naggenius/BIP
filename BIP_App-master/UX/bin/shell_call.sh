#TODO
for fichier in $(ls *.sh);do
	grep "\.sh" $fichier > /dev/null
	if test $? -eq 0;then
		echo $fichier
		grep "\.sh" $fichier | awk '{pos=index($0, ".sh"); toto=substr($0, 1, pos+2); pos=index(toto, " ");while (pos>0) {toto=substr(toto, pos+1); pos=index(toto, " ")};print toto}'
		echo " "
	fi
done
