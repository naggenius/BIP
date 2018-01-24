#!/bin/ksh
# Creation
# YNI    FDT 973 06/04/2010   HARMONISATION des MAILS AUTOMATIQUES émis par les BATCHS 
########################################################################################
set +x
set 

# Récuperation des paramètres passés au shell
CODE_REMONTE=$1 
PRIORITE=$2
PARTIE_LIBRE_OBJET=$3 
PARTIE_LIBRE_CORPS=$4
REFERENCES_PJ=$5

echo "CODE_REMONTE "$1 
echo "PRIORITE "$2
echo "PARTIE_LIBRE_OBJET "$3 
echo "PARTIE_LIBRE_CORPS "$4
echo "REFERENCES_PJ "$5
LIBELLE=`sqlplus -s $CONNECT_STRING << ! 
set head off 
select ltrim(rtrim(libelle)) from contact_mail where codremonte='${CODE_REMONTE}';
!` 
LIBELLE=`echo ${LIBELLE}|sed "s/\n//g"`

# Contenu du mail
CONTENT_BODY="Bonjour,"
CONTENT_BODY="${CONTENT_BODY}\n\n"
CONTENT_BODY="${CONTENT_BODY}$PARTIE_LIBRE_CORPS"
CONTENT_BODY="${CONTENT_BODY}\n\n"
CONTENT_BODY="${CONTENT_BODY}Horodatage : <"`date +"%d/%m/%Y %H:%M:%S"`"> Ceci est la dernière ligne de ce mail automatique."

# Objet du mail
SUBJECT="[Remontée BIP: <${CODE_REMONTE}> <${LIBELLE}>] ${PARTIE_LIBRE_OBJET}" 
# Destinataire du mail
TO=`sqlplus -s $CONNECT_STRING << ! 
set head off 
select mail1, mail2, mail3 from contact_mail where codremonte='${CODE_REMONTE}';
!` 

# Expéditeur du mail
FROM=List.Fr-Bip@socgen.com

# Copie du mail
# variable $CC initialiser dans bipparam.sh

# Recuperation des pieces jointes 
#on supprime l'ancien fichier zip MO
rm -f $DIR_BATCH_SHELL_LOG/MO.zip
# Chaque piece jointe est composee du chemin et du nom d'attachement
ATTACHEMENT=""


z=0
for i in $REFERENCES_PJ
do
z=`expr $z + 1`
done

#Varibale qui sert a tester s il y a des PJ ou non
j=0
PATH_FILE = ""
NOM_PJ = ""
for i in $REFERENCES_PJ
do
	PATH_PJ=`echo $i|awk -F";" '{print $1}'`
	NOM_PJ=`echo $i|awk -F";" '{print $2}'`
		
	#Recuperer le chemin des PJs
	PATH_FILE=`echo ${PATH_PJ%/*}`
	
	
	echo "PATH_FILE.... :\n"$PATH_FILE
	echo "NOM_PJ.... :\n"$NOM_PJ
	
	if [ -s $PATH_PJ ] 
	then
		#Renommer le fichier avec le nom envoye en parametre
		echo "NOM_PJ..222.. :\n"$NOM_PJ
		echo "PATH_PJ..222.. :\n"$PATH_PJ
		echo "PATH_FILE..222.. :\n"$PATH_FILE
		cp $PATH_PJ $PATH_FILE/$NOM_PJ
		if [ $z -gt 1 ]
		then
			#Ziper les PJs
			zip -j $DIR_BATCH_SHELL_LOG/MO.zip $PATH_FILE/$NOM_PJ
			#Supprimer le fichier cree en haut avec la commande cp s il est different du non du PJ
		fi
		
	fi
	
	j=`expr $j + 1`
done

#Affichage de la chaine de pieces jointes
echo "Attachement.... :\n"$ATTACHEMENT
echo "Fin attachement!!!"

#Envoi du mail
#if [ ${#ATTACHEMENT} -eq 0 ]
if [ $j -eq 0 ]
then
	# Envoi du mail sans pieces jointes
	# DEBUT - ABN - 09/10/2013
	echo "Avant envoi du mail sans pieces jointes"
	#(echo "$CONTENT_BODY") | mail -v -r $FROM -s "$SUBJECT" -c "$CC" $TO
	echo -e "$CONTENT_BODY" | mail -v -s "$SUBJECT" $TO -c $CC -- -f $FROM
	echo "Apres envoi du mail sans pieces jointes"
	# FIN - ABN - 09/10/2013
else
	# Envoi du mail avec pieces jointes
	# DEBUT - ABN - 09/10/2013
	echo "Avant envoi du mail avec pieces jointes"
	if [ $z -gt 1 ]
		then	
			(echo -e "$CONTENT_BODY" ; cat $DIR_BATCH_SHELL_LOG/MO.zip | uuencode MO.zip) | mail -v -s "$SUBJECT" $TO -c $CC -- -f $FROM
		else			
			(echo -e "$CONTENT_BODY" ; cat $PATH_FILE/$NOM_PJ | uuencode $NOM_PJ) | mail -v -s "$SUBJECT" $TO -c $CC -- -f $FROM
	fi
	
	echo "Apres envoi du mail avec pieces jointes"
	# FIN - ABN - 09/10/2013
		
fi
if [[ -s $PATH_PJ && $PATH_PJ != $PATH_FILE/$NOM_PJ  ]]
then
	rm $PATH_FILE/$NOM_PJ
fi

# echo -e "test" | mail -v -s "test" $TO -- -f $FROM
exit
