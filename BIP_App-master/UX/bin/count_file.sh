#!/bin/ksh
#TODO
old_nb=0
while ${1};do
	sleep 60
	nb=$(ls -la /bipprod/users/bipprod/reports|wc -l)
	if test $nb -ne $old_nb;then
		echo "Avant : $old_nb ; après : $nb" | mail -s "Pb fichiers reports en prod" -c "aurore.remens@socgen.com olivier.tonnelet@socgen.com" olivier.duprey@socgen.com
	fi
	old_nb=$nb;
done
