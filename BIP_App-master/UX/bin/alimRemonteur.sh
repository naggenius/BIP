#!/bin/ksh

#FICHIER_DB=/bip/tom1/remftp/bipdb.log
FICHIER_DB=bipdb.log

NOM=
PRENOM=
IDARPEGE=

FICHIER_SQL=alimbase.sql
echo "DELETE REMONTEUR;" > $FICHIER_SQL

while read LIGNE_USER
do
	LIGNE_USER=$(echo $LIGNE_USER | sed "s/\'/\'\'/")
	
	NOM=$(echo $LIGNE_USER | awk 'BEGIN { FS=";" } { print $1 }')
	PRENOM=$(echo $LIGNE_USER | awk 'BEGIN { FS=";" } { print $2 }')
	IDARPEGE=$(echo $LIGNE_USER | awk 'BEGIN { FS=";" } { print $4 }')
	
	LENGTH=${#IDARPEGE}
	
	if [ $LENGTH -ge 7 ]
	then
		IDARPEGE=$(echo $IDARPEGE | tr "[:lower:]" "[:upper:]")
		echo "INSERT INTO REMONTEUR(IDARPEGE, COMMENTAIRE, CREATEDATE) VALUES ('$IDARPEGE', '$NOM $PRENOM', sysdate);" >> $FICHIER_SQL
	else
		echo "$IDARPEGE - $NOM, $PRENOM"
		echo "--INSERT INTO REMONTEUR(IDARPEGE, COMMENTAIRE, CREATEDATE) VALUES ('$IDARPEGE', '$NOM $PRENOM', sysdate);" >> $FICHIER_SQL
	fi
	
done < $FICHIER_DB

# on insere les compte d'homo IHT Arpege :
echo "insert into REMONTEUR(IDARPEGE, COMMENTAIRE, CREATEDATE) values ('X000012', 'Homo. IHT Arpege', sysdate);" >> $FICHIER_SQL
echo "insert into REMONTEUR(IDARPEGE, COMMENTAIRE, CREATEDATE) values ('X000013', 'Homo. IHT Arpege', sysdate);" >> $FICHIER_SQL
echo "insert into REMONTEUR(IDARPEGE, COMMENTAIRE, CREATEDATE) values ('X000032', 'Homo. IHT Arpege', sysdate);" >> $FICHIER_SQL


# on fait le sort (pas de pb poor 'delete', il va rester en 1ere position)
sort $FICHIER_SQL -o $FICHIER_SQL

exit 0

