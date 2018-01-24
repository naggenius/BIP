echo "Volume occupe par les scripts en $BIP_ENV : "

printf "sh  : % 10d Ko\n" $(( $(find $HOME_BIP	-name '*.sh' -exec ls -lA {} \; | grep -vi old | grep -vi nouveau | \
awk 'BEGIN {taille=0}{ taille=taille+$5 } END { print taille }') / 1024 ))

printf "sql : % 10d Ko\n" $(( $(find $HOME_BIP	-name '*.sql' -exec ls -lA {} \; | grep -vi old | grep -vi nouveau | \
awk 'BEGIN {taille=0}{ taille=taille+$5 } END { print taille }') / 1024 ))

printf "ctl : % 10d Ko\n" $(( $(find $HOME_BIP	-name '*.ctl' -exec ls -lA {} \; | grep -vi old | grep -vi nouveau | \
awk 'BEGIN {taille=0}{ taille=taille+$5 } END { print taille }') / 1024 ))

printf "par : % 10d Ko\n" $(( $(find $HOME_BIP	-name '*.par' -exec ls -lA {} \; | grep -vi old | grep -vi nouveau | \
awk 'BEGIN {taille=0}{ taille=taille+$5 } END { print taille }') / 1024 ))
