#!/bin/ksh
# script alerte_mail.sh
# YNI    19/01/2016   Améliorer la notification suite à pb batchs de nuit 
# YNI    13/04/2010   FDT 973 Harmonisation des mails
#############################################################################################################


TYPE_MENSUELLE=$1 
HEURE_DEBUT=$2
TYPE_ALERTE=$3 
SHELL_ERREUR=$4

#Paramétrage du corps du mail lors du passage de la mensuelle.
#Cas Bon traitement. 
if [ $TYPE_ALERTE -eq 1 ]
then
		
		#Construction des differents parametres a passer a envoi_mail.sh
		REMONTE="P001"
		PRIORITE=""
		#Objet du mail
		if [ $TYPE_MENSUELLE -eq 1 ]
		then
			OBJECT="1premensuelle.sh: Traitement première mensuelle du "`date +"%d/%m/%Y"`
		fi
		if [ $TYPE_MENSUELLE -eq 2 ]
		then
			OBJECT="2premensuelle.sh : Traitement deuxième mensuelle du "`date +"%d/%m/%Y"`
		fi 
		if [ $TYPE_MENSUELLE -eq 3 ]
		then
			OBJECT="mensuelle.sh : Traitement mensuelle définitive du "`date +"%d/%m/%Y"`
		fi
		CORPS=""
		CORPS="${CORPS}Voici le compte rendu du traitement."
		CORPS="${CORPS}\n\n"
		CORPS="${CORPS}Heure de debut:$HEURE_DEBUT"
		CORPS="${CORPS}\n\n"
		CORPS="${CORPS}Fin normale du traitement."
		CORPS="${CORPS}\n\n"
		CORPS="${CORPS}Heure de fin:"`date +'%T'`
		PJ=""
		#Appel envoi_mail.sh
		$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
		
		
		#Mail automatique du CR vers DIVA. 
		#Test d'existence des fichiers disponibles dans le répertoire /RBip/data/DIVA avec la date du jour.
		fileDir=$HOME_BIP/RBip/data/DIVA
		fileArray=$(find $fileDir -name "*.CSV" -type f -mtime 0)
		FILE_DIVA_RBIP=${fileArray[0]}
		if [ "X"$FILE_DIVA_RBIP == "X" ]
		then
			echo "Aucun fichier DIVA modifié aujourdhui"
		else
			echo "Fichier DIVA : $FILE_DIVA_RBIP a été modifié aujourdhui"
			#Construction des differents parametres a passer a envoi_mail.sh
			REMONTE="D001"
			PRIORITE=""
			#Objet du mail
			if [ $TYPE_MENSUELLE -eq 1 ]
			then
				OBJECT="1premensuelle.sh : BIP : Compte rendu du traitement de la première mensuelle du "`date +"%d/%m/%Y"`
			fi
			if [ $TYPE_MENSUELLE -eq 2 ]
			then
				OBJECT="2premensuelle.sh : BIP : Compte rendu du traitement de la deuxième mensuelle du "`date +"%d/%m/%Y"`
			fi
			if [ $TYPE_MENSUELLE -eq 3 ]
			then
				OBJECT="mensuelle.sh : BIP : Compte rendu du traitement de la mensuelle définitive du "`date +"%d/%m/%Y"`
			fi
			CORPS=""
			CORPS="${CORPS}Voici le compte rendu du traitement suite à l’intégration de votre fichier des consommés."
			CORPS="${CORPS}\n\n"
			CORPS="${CORPS}Heure de debut:$HEURE_DEBUT"
			CORPS="${CORPS}\n\n"
			CORPS="${CORPS}Fin normale du traitement."
			CORPS="${CORPS}\n\n"
			CORPS="${CORPS}Heure de fin:"`date +'%T'`
			PJ="$FILE_DIVA_RBIP;"`date +'%d%m%Y'`".DIVA.RBIP.CSV"
	
			#Appel envoi_mail.sh
			$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
		fi 

				
		#Mail automatique du CR vers GIMS. 
		#Test d'existence des fichiers disponibles dans le répertoire /RBip/data/GIMS avec la date du jour.
		fileDir=$HOME_BIP/RBip/data/GIMS
		fileArray=$(find $fileDir -name "*.CSV" -type f -mtime 0)
		FILE_GIMS_RBIP=${fileArray[0]}
		if [ "X"$FILE_GIMS_RBIP == "X" ]
		then
			echo "Aucun fichier DIVA modifié aujourdhui"
		else
			echo "Fichier GIMS : $FILE_GIMS_RBIP a été modifié aujourdhui"
			#Construction des differents parametres a passer a envoi_mail.sh
			REMONTE="C001"
			PRIORITE=""
			#Objet du mail
			if [ $TYPE_MENSUELLE -eq 1 ]
			then
				OBJECT="1premensuelle.sh : BIP : Compte rendu du traitement de la première mensuelle du "`date +"%d/%m/%Y"`
			fi
			if [ $TYPE_MENSUELLE -eq 2 ]
			then
				OBJECT="2premensuelle.sh : BIP : Compte rendu du traitement de la deuxième mensuelle du "`date +"%d/%m/%Y"`
			fi
			if [ $TYPE_MENSUELLE -eq 3 ]
			then
				OBJECT="mensuelle.sh : BIP : Compte rendu du traitement de la mensuelle définitive du "`date +"%d/%m/%Y"`
			fi
			CORPS=""
			CORPS="${CORPS}Voici le compte rendu du traitement suite à l’intégration de votre fichier des consommés."
			CORPS="${CORPS}\n\n"
			CORPS="${CORPS}Heure de debut:$HEURE_DEBUT"
			CORPS="${CORPS}\n\n"
			CORPS="${CORPS}Fin normale du traitement."
			CORPS="${CORPS}\n\n"
			CORPS="${CORPS}Heure de fin:"`date +'%T'`
			PJ="$FILE_GIMS_RBIP;"`date +'%d%m%Y'`".GIMS.RBIP.CSV"
	
			#Appel envoi_mail.sh
			$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
		fi 

		
fi


#Cas Plantage lors de la mensuelle. 
if [ $TYPE_ALERTE -eq 2 ]
then
		#Construction des differents parametres a passer a envoi_mail.sh
		REMONTE="P001"
		PRIORITE=""
		#Objet du mail
		if [ $TYPE_MENSUELLE -eq 1 ]
		then
			OBJECT="1premensuelle.sh: Traitement première mensuelle du "`date +"%d/%m/%Y"`
		fi
		if [ $TYPE_MENSUELLE -eq 2 ]
		then
			OBJECT="2premensuelle.sh : Traitement deuxième mensuelle du "`date +"%d/%m/%Y"`
		fi
		if [ $TYPE_MENSUELLE -eq 3 ]
		then
			OBJECT="mensuelle.sh : Traitement mensuelle définitive du "`date +"%d/%m/%Y"`
		fi
		CORPS=""
		CORPS="${CORPS}Voici le compte rendu du traitement."
		CORPS="${CORPS}\n\n"
		CORPS="${CORPS}Heure de debut:$HEURE_DEBUT"
		CORPS="${CORPS}\n\n"
		CORPS="${CORPS}Echec du traitement:$SHELL_ERREUR"
		CORPS="${CORPS}\n\n"
		CORPS="${CORPS}Fin Anormale."
		CORPS="${CORPS}\n\n"
		CORPS="${CORPS}Heure de fin:"`date +'%T'`
		PJ=""

		#Appel envoi_mail.sh
		$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
		
fi

#Cas Plantage lors des traitements différés. 
if [ $TYPE_ALERTE -eq 3 ]
then
		#Construction des differents parametres a passer a envoi_mail.sh
		REMONTE="P001"
		PRIORITE=""
		#Objet du mail
		if [ $TYPE_MENSUELLE -eq 1 ]
		then
			OBJECT="1premensuelle.sh: Traitement première mensuelle du "`date +"%d/%m/%Y"`
		fi
		if [ $TYPE_MENSUELLE -eq 2 ]
		then
			OBJECT="2premensuelle.sh : Traitement deuxième mensuelle du "`date +"%d/%m/%Y"`
		fi
		if [ $TYPE_MENSUELLE -eq 3 ]
		then
			OBJECT="mensuelle.sh : Traitement mensuelle définitive du "`date +"%d/%m/%Y"`
		fi
		CORPS=""
		CORPS="${CORPS}Voici le compte rendu du traitement."
		CORPS="${CORPS}\n\n"
		CORPS="${CORPS}Heure de debut:$HEURE_DEBUT"
		CORPS="${CORPS}\n\n"
		CORPS="${CORPS}Liste des steps tombé en erreur:$SHELL_ERREUR"
		CORPS="${CORPS}\n\n"
		CORPS="${CORPS}Fin Anormale."
		CORPS="${CORPS}\n\n"
		CORPS="${CORPS}Heure de fin:"`date +'%T'`
		PJ=""

		#Appel envoi_mail.sh
		$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"
		
fi

#Alerte d'anomalie de parametrage 
if [ $TYPE_ALERTE -eq 4 ]
then
	# Récuperation des paramètres passés au shell
	REMONTE="P002"
	PRIORITE=""
	PARTIE_LIBRE_OBJET="Anomalie de paramétrage" 
	PARTIE_LIBRE_CORPS="Anomalie de paramétrage des types d'étapes, A CORRIGER."
	
	echo "REMONTE "$REMONTE 
	echo "PRIORITE "$PRIORITE
	echo "PARTIE_LIBRE_OBJET "$PARTIE_LIBRE_OBJET 
	echo "PARTIE_LIBRE_CORPS "$PARTIE_LIBRE_CORPS
	
	    #Objet du mail
		if [ $TYPE_MENSUELLE -eq 1 ]
		then
			TYPE="1premensuelle.sh"
		fi
		if [ $TYPE_MENSUELLE -eq 2 ]
		then
			TYPE="2premensuelle.sh"
		fi
		if [ $TYPE_MENSUELLE -eq 3 ]
		then
			TYPE="mensuelle.sh"
		fi

	LIBELLE=`sqlplus -s $CONNECT_STRING << ! 
	set head off 
	select ltrim(rtrim(libelle)) from contact_mail where codremonte='${REMONTE}';
	!` 
	LIBELLE=`echo ${LIBELLE}|sed "s/\n//g"`

	# Contenu du mail
	CONTENT_BODY="Bonjour,"
	CONTENT_BODY="${CONTENT_BODY}\n\n"
	CONTENT_BODY="${CONTENT_BODY}$PARTIE_LIBRE_CORPS"
	CONTENT_BODY="${CONTENT_BODY}\n\n"
	CONTENT_BODY="${CONTENT_BODY}Horodatage : <"`date +"%d/%m/%Y %H:%M:%S"`"> Ceci est la dernière ligne de ce mail automatique."

	# Objet du mail
	SUBJECT="[Remontée BIP: <${REMONTE}> <${TYPE}>] ${PARTIE_LIBRE_OBJET}" 
	# Destinataire du mail
	TO=`sqlplus -s $CONNECT_STRING << ! 
	set head off 
	select mail1, mail2, mail3 from contact_mail where codremonte='${REMONTE}';
	!` 

	# Expéditeur du mail
	FROM=List.Fr-Bip@socgen.com

	#Envoi du mail
	echo "Avant envoi du mail"
	#(echo "$CONTENT_BODY") | mail -v -r $FROM -s "$SUBJECT" -c "$CC" $TO
	echo -e "$CONTENT_BODY" | mail -v -s "$SUBJECT" $TO -c $CC -- -f $FROM
	echo "Apres envoi du mail"

	exit
		
fi