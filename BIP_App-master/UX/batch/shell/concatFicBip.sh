#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : concatFicBip.sh
#	reprise fonctionnelle de histsmbfile.sh sous bipbip
# Objet : 
#	ce script recupere les fichiers .bip dans les repertoires des utilisateurs
#	et les concatene dans le fichier consomme.bip."date"
#
#_______________________________________________________________________________
# Creation : Equipe SOPRA 10/09/1999
# Modification :
# --------------
# Auteur 	Date      	Objet
# EGR	 	2003/08/06	Migration BIP-C1 sous env Solaris
# EGR		2003/11/05	Le fichier oscar.bip est renomme en OSCAR.oscar.bip
# EGR		2004/05/05	PID sur 4 :  maj de la gestion des fichiers
# EGR		2004/08/30	dos2unix avant appel à isFichierValid :
#						les fichiers au format DOS faussent le test de longeur max
#
################################################################################

autoload $(ls $FPATH)

################################################################################
# Cette fonction va verifier que le fichier passe en parametre est valide
# C'est a dire qu'il ne possede pas de ligne de longueur > 84
################################################################################
function isFileValid {
	MAX=$(cat $1 | awk '{ if (length($0)>max) max=length($0)} END { print max }')
	#echo "Max de '$1' : $MAX"
	if [ $MAX -le $REMONTEE_LINESIZE_MAX ]
	then
		return 0
	else
		return 1
	fi
}

################################################################################
# Variables
set -x

LISTE_DEPART=$TMPDIR/liste_depart.tmp
LISTE_DEPART_PID3=$TMPDIR/liste_depart_pid3.tmp
LISTE_DEPART_PID4=$TMPDIR/liste_depart_pid4.tmp

>$LISTE_DEPART
>$LISTE_DEPART_PID3
>$LISTE_DEPART_PID4

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.concatFicBip.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de concatFicBip (`basename $0`)"
logText "Debut de concatFicBip (`basename $0`)" >> $LOG_FILE

cd $BIP_DATA_REMONTEE

# Renommage du fichier oscar.bip en OSCAR.oscar.bip
if [ -e oscar.bip ]
then
	logText "Le fichier oscar.bip existe, on va le renommer en OSCAR.oscar.bip"
	logText "Le fichier oscar.bip exite, on va le renommer en OSCAR.oscar.bip" >> $LOG_FILE
	cp -p oscar.bip OSCAR.oscar.bip
	CMD_EXIT=$?
        if [ $CMD_EXIT -ne 0 ]
       	then
        	logText "echec du cp de oscar.bip en OSCAR.oscar.bip"
		logText "echec du cp de oscar.bip en OSCAR.oscar.bip" >> $LOG_FILE
                exit -1
        fi

	rm oscar.bip
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
        then
                logText "echec du de la suppression du oscar.bip"
		logText "echec du de la suppression du oscar.bip" >> $LOG_FILE
                exit -1
        fi
	logText "Fichier oscar.bip renomme en OSCAR.oscar.bip"
fi

# On recupere le numero de traitement en cours
logText "sqlplus" >> $LOG_FILE
NUM_TRAIT=$(sqlplus -s $CONNECT_STRING <<! 2>&1 
  whenever sqlerror exit failure;
		set heading off
		set headsep off
		set echo off
      
        select NUMTRAIT from DATDEBEX;
!)

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
        logText "Problème SQL*PLUS dans batch concatFicBip : consulter $LOG_FILE"
        logText "Recuperation du n° de traitement en cours impossible"
        logText "Recuperation du n° de traitement en cours impossible" >> $LOG_FILE
        logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
        exit -1;
fi


NUM_TRAIT=$(echo $NUM_TRAIT | tr -d '[:space:]')

logText "Traitement en cours : '$NUM_TRAIT'"
logText "Traitement en cours : '$NUM_TRAIT'" >> $LOG_FILE


REMONTEE_LOG=$DIR_BATCH_SHELL_LOG/$(date +"%Y%m%d").remontee.$NUM_TRAIT.log
REJECT_LOG=$DIR_BATCH_SHELL_LOG/$(date +"%Y%m%d").reject.$NUM_TRAIT.log
CONCAT_FILE=$DIR_BATCH_DATA/pmw$NUM_TRAIT.dat
TMP_CONCAT_FILE=$BIP_DATA_REMONTEE/tmp_pmw$NUM_TRAIT.$(date +"%Y%m%d").dat

>$REMONTEE_LOG
>$REJECT_LOG
>$TMP_CONCAT_FILE

if [ $NUM_TRAIT = $TRAIT_1PREMENSUELLE ]
then
	logText "1ere premensuelle en court, purge du repertoire des rejets : "$BIP_DATA_REMONTEE_REJECT
	logText "1ere premensuelle en court, purge du repertoire des rejets : "$BIP_DATA_REMONTEE_REJECT >> $LOG_FILE
	rm -f $BIP_DATA_REMONTEE_REJECT/* 2>> $LOG_FILE
fi

logText "-- Etape 1 : Recherche des doublons -------------------------------------------"
logText "-- Etape 1 : Recherche des doublons -------------------------------------------" >> $LOG_FILE

cd $BIP_DATA_REMONTEE

ls *.BIP *.bip > $LISTE_DEPART 2> /dev/null
awk '{ FS="." } { if (length($2)==8) printf ("%s\n",$0)}' $LISTE_DEPART > $LISTE_DEPART_PID3
awk '{ FS="." } { if (length($2)!=8) printf ("%s\n",$0)}' $LISTE_DEPART > $LISTE_DEPART_PID4




################################################################################
# On parcours les fichiers de remontee
################################################################################

#for FICHIER in $(cat $LISTE_DEPART)
#do
while read FICHIER
do
#	echo ""
#	echo "Fichier : '"$FICHIER"'"
	# la liste n'est pas reconstruite en cours d'execution => s'il y a des doublons
	# et qu'ils ont etes purges ces fichiers n'existent plus
	# ===> verif que le fichier existe encore
	echo "$FICHIER"


	if [ ! -e $FICHIER ]
	then
		#le fichier n'existe plus => on le passe
		continue
	fi
	
	IDARPEGE=$(echo $FICHIER | awk 'BEGIN {FS="."}{print $1 }')
	CURRENT_FIC=$(echo $FICHIER | awk 'BEGIN {FS="."}{print $2"."$3}')


	#logText "Check de $CURRENT_FIC ($IDARPEGE)" >> $LOG_FILE
	
	# Le test des doublons doit s'effectuer sur la ligne bip, soit
	# seulement les 3 permiers caracteres du nom du fichier
	if [ ${#CURRENT_FIC} -eq 12 ]
	then
		LIGNE_BIP="$(echo $CURRENT_FIC | cut -c1-3)"
		LISTE=$LISTE_DEPART_PID3
	else	#pid sur 4 => longueur sur 13
		LIGNE_BIP="$(echo $CURRENT_FIC | cut -c1-4)"
		LISTE=$LISTE_DEPART_PID4
	fi

	logText "Check de la ligne BIP : $LIGNE_BIP"
	logText "Check de la ligne BIP : $LIGNE_BIP" >> $LOG_FILE
	
	# on cherche les fichiers qui ont le meme nom
	
	CMD="grep -i \.$LIGNE_BIP $LISTE"
	LISTE_CURRENT_FIC=$($CMD)
	
	if [ "$LISTE_CURRENT_FIC" = "" ]
	then
		logText "Probleme dans la recherche des occurances de la ligne $LIGNE_BIP"
		logText "Probleme dans la recherche des occurances de la ligne $LIGNE_BIP" >> $LOG_FILE
		logText "Arret du script"
		logText "Arret du script" >> $LOG_FILE
		exit 1
	fi
	echo "liste current : "
	echo $LISTE_CURRENT_FIC
	echo 'passe1'
	# on va historiser le fichier le plus recent
	TO_HISTO=$(ls -1t $LISTE_CURRENT_FIC | head -1)
	# et purger les plus anciens
	TO_REJECT=$(ls -1t $LISTE_CURRENT_FIC | tail -n+2)
echo 'passe2'
	# Converion du fichier avec dos2unix
	dos2unix -c ascii -n $TO_HISTO $TO_HISTO
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
	then
		logText "Echec dans le dos2unix de $TO_HISTO"
		logText "Echec dans le dos2unix de $TO_HISTO" >> $LOG_FILE
		logText "Code erreur : <$CMD_EXIT>" >> $LOG_FILE
		exit -1;
	fi
echo 'passe3'
	############################################################################
	# On teste la validite du fichier le plus recent
	# Si OK
	#	On le recopie dans le repertorie d'histo
	#	cp puis rm pour pouvoir faire un 'preserve' sur date de modif
	#	log
	# Sinon
	#	log
	############################################################################
	STR_LOG=$TO_HISTO";"$(date '+%Y')$(echo $(ls -l $TO_HISTO) | awk '{ print " " $6 " " $7 " " $8 }')

echo 'passe4'	
	isFileValid $TO_HISTO
echo 'passe4ici'
	CMD_EXIT=$?
echo 'passeencore4'
	if [ $CMD_EXIT -eq 0 ]
	then
		# Valide, on concatene le fichier
echo 'passe5'
		#cat $TO_HISTO >> $TMP_CONCAT_FILE
		# 23/02/2006 : J. MAS : on ajoute à la fin des lignes de séquence "A" la provenance du fichier
		awk -f $DIR_BATCH_SHELL/concatFicBip.awk $TO_HISTO >> $TMP_CONCAT_FILE
		# on peux historiser le fichier
		cp -p $TO_HISTO $BIP_DATA_REMONTEE_HISTO 2>> $LOG_FILE
		CMD_EXIT=$?
		if [ $CMD_EXIT -ne 0 ]
		then
			logText "echec du cp en histo"
			exit -1
		fi
		
		rm $TO_HISTO 2>> $LOG_FILE
		echo $STR_LOG";OK" >> $REMONTEE_LOG
		logText "Valide : $TO_HISTO"
	else
		# Invalide
		logText "Rejet : Trop long : $TO_HISTO"
		logText "Rejet : Trop long : $TO_HISTO" >> $LOG_FILE
		echo $STR_LOG";NOK" >> $REMONTEE_LOG
	fi
echo 'passe6'	
	############################################################################
	# On deplace les autres fichiers dans le repertoire des rejets, on les log
	############################################################################
	for DOUBLON in $TO_REJECT
		do
		logText "Rejet : Doublon : $DOUBLON"
		logText "Rejet : Doublon : $DOUBLON" >> $LOG_FILE
		
		cp -p $DOUBLON $BIP_DATA_REMONTEE_REJECT
		CMD_EXIT=$?
		if [ $CMD_EXIT -ne 0 ]
		then
			logText "echec du cp en rejet"
			exit -1
		fi
		rm $DOUBLON
		
		echo $DOUBLON >> $REJECT_LOG
	done 
done < "$LISTE_DEPART"

echo 'passe7'
rm $LISTE_DEPART
rm $LISTE_DEPART_PID3
rm $LISTE_DEPART_PID4

logText "Concatenation des fichiers de remontee terminee"
logText "Concatenation des fichiers de remontee terminee" >> $LOG_FILE

#le fichier est de format dos, on lui fait donc un dos2unix,
#la version corrigee est dans le repertoire BIPDATA
logText "Conversion du fichier des consomme au format unix ==> $CONCAT_FILE"
CMD="dos2unix -c ascii -n $TMP_CONCAT_FILE $CONCAT_FILE"
logText "Conversion du fichier des consomme au format unix : $CMD" >> $LOG_FILE
$CMD >> $LOG_FILE 2>&1
CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
	logText "Problème dans la conversion de $TMP_CONCAT_FILE vers $CONCAT_FILE"
	logText "voir $LOG_FILE"
	logText "Code erreur : <$CMD_EXIT>" >> $LOG_FILE
	exit -1;
fi
rm $TMP_CONCAT_FILE 2>> $LOG_FILE

######   Envoie des mails  ################################################
#logText "-- Lancement de mailLogMens.sh ----------------------------------------" >> $LOG_FILE
#$DIR_BATCH_SHELL/mailLogMens.sh $REMONTEE_LOG $REJECT_LOG
#SHELL_EXIT=$?
#if [ $SHELL_EXIT -ne 0 ]
#then
#	logText "Echec lors de l execution du traitement mailLogMens"
#	logText "Code erreur : <$SHELL_EXIT>" >> $LOG_FILE
#	exit -1;
#fi

logText "Fin de concatFicBip (`basename $0`)"
logText "Fin de concatFicBip (`basename $0`)" >> $LOG_FILE

exit 0

