#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : tom_envoi.sh
# Objet : script d'envoi TOM
#        
#_______________________________________________________________________________
# Creation     : SGA 29/04/2013
#_______________________________________________________________________________
# Modification : 
#
################################################################################

#on recupère dans VAR1 le champ 1 2 et 3 et dans VAR2 le champ 4
#commande trans_tom prend en paramatre champ1.champ2.champ3 et champ4
VAR1=`echo $1 | cut -d'.' -f1,2,3`
VAR2=`echo $1 | cut -d'.' -f4`
VAR3=`echo $1 | cut -d'.' -f5`
VAR4=`echo $1 | cut -d'.' -f3`


if [ -a $EMISSION/$1 ] 
then
cd ${EMISSION}

	
	#Gestion du cas des fichiers IMMO
	
	if [[ $VAR3 = "PRET" ]]
	then
		trans_tom $VAR1 $VAR2 
	else
		if [[ $VAR4 = "IMMO" ]]
		then
			trans_tom $VAR1.$VAR2 $VAR3
		else
			trans_tom $VAR1 $VAR2 $VAR3
		fi
	
	fi

	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
	then
		logText "Echec du transfert TOM : Code erreur : <$CMD_EXIT>"
		exit -1;
	fi
	
exit 0
else
	#Cas particulier des envois IMMO et FI, si le fichier n'est pas trouvé un code erreur n'est pas retourné
	if [[ $VAR4 = "IMMO" || $VAR4 = "STPD3725" ]]
	then
		exit 0
	else
		exit -1;
	fi
fi


