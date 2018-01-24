#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : SurveillanceQuotidienne.sh
# Objet : Ce shell doit etre lance une fois par jour, en fin de journee.
#	  Il effectue plein de controles.
#	  En cas d'anomalie il envoie un mail.
#	  Controles effectues :
#		Presence d'un fichier de log de violation des habilitations HTML
#		Presence d'un fichier dans export_compta/erreur
#		Presence d'un fichier d'export de factures de + de 24h : user et concatene
#		Bonne execution du traitement de FACCONS
#
# Parametres d'entree : (optionnels et non ordonnes)
#	-T		Trace et non pas envoie de mails
#	-D AAAAMMJJ	Date pour le controle
#_______________________________________________________________________________
# Creation : ??
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     30/10/02   Migration ksh sur SOLARIS 8
#
################################################################################

#################################################
# On charge l'environnement
#################################################
. $APP_ETC/bipparam.sh
#################################################

CURRENT_DATE=$(date +"%Y%m%d")
TRACE=0
while [ $# -gt 0 ]
do
	if [ $1 = "-D" ]
	then
		shift
		CURRENT_DATE=$1
	fi

	if [ $1 = "-T" ]
	then
		TRACE=1
	fi

	shift
done

# TODO intranet n'est pas porte sur ICHDEV02 ...
# test de presence d'un nouveau fichier de violation des habilitations HTML
#HAB_FILE=$HOME_BIP/intranet/logfiles/hab.$CURRENT_DATE.log
#if [ -f $HAB_FILE ]
#then
#	if [ TRACE -eq 1 ]
#	then
#		echo "Violation Habilitation BIP le $CURRENT_DATE"
#	else
#		cat $HAB_FILE | mail -s "Violation Habilitation BIP le $CURRENT_DATE" corinne.ricard@socgen.com olivier.tonnelet@socgen.com
#	fi
#else
#	if [ TRACE -eq 1 ]; then echo "Pas de violation Habilitation BIP le $CURRENT_DATE";fi
#fi


# test de presence d'un fichier d'export de facture dans le repertoire erreur
ls $ORA_LIVE_UTL_EXPCOMPTA_ERREUR/CIAJ* > /dev/null 2>&1
if [ $? -eq 0 ]
then
	if [ TRACE -eq 1 ]
	then
		echo "Fichiers de factures en erreur"
	else
		ls $ORA_LIVE_UTL_EXPCOMPTA_ERREUR | mail -s "Fichiers de factures en erreur" -c "emmanuel.vinatier@socgen.com emmanuel.vinatier@socgen.com" emmanuel.vinatier@socgen.com
	fi
else
	if [ TRACE -eq 1 ]; then echo "Pas de fichiers de factures en erreur";fi
fi


# test de presence de fichiers d'export de factures de + de 24h (fichier users)
# la date est formattee differement : JJMMAAAA
DATE_FICHIER_USER=$(echo $CURRENT_DATE | awk '{print substr($0, 7) substr($0, 5, 2) substr($0, 1, 4)}')
ls -l $ORA_LIVE_UTL_EXPCOMPTA | grep BIPEXCOMPTA | grep -v $DATE_FICHIER_USER | grep BIPEXCOMPTA
if [ $? -eq 0 ]
then
	if [ TRACE -eq 1 ]
	then
		echo "Fichiers de factures users en attente"
	else
		ls -l $ORA_LIVE_UTL_EXPCOMPTA | grep BIPEXCOMPTA | grep -v $DATE_FICHIER_USER | mail -s "Fichiers de factures users en attente" -c "emmanuel.vinatier@socgen.com emmanuel.vinatier@socgen.com" emmanuel.vinatier@socgen.com
	fi
else
	if [ TRACE -eq 1 ]; then echo "Pas de fichiers factures users en attente";fi
fi


# test de presence de fichiers d'export de factures de + de 24h (fichier concatenes)
# la date est formattee differement : JJMMAA
DATE_FICHIER_CONCATENE=$(echo $CURRENT_DATE | awk '{print substr($0, 7) substr($0, 5, 2) substr($0, 3, 2)}')
ls -l $ORA_LIVE_UTL_EXPCOMPTA | grep CIAJXFAC | grep -v $DATE_FICHIER_CONCATENE | grep CIAJXFAC
if [ $? -eq 0 ]
then
	if [ TRACE -eq 1 ]
	then
		echo "Fichiers de factures concatenes en attente"
	else
		ls -l $ORA_LIVE_UTL_EXPCOMPTA | grep CIAJXFAC | grep -v $DATE_FICHIER_CONCATENE | mail -s "Fichiers de factures concatenes en attente" -c "emmanuel.vinatier@socgen.com emmanuel.vinatier@socgen.com" emmanuel.vinatier@socgen.com
	fi
else
	if [ TRACE -eq 1 ]; then echo "Pas de fichiers factures concatenes en attente";fi
fi


# test de presence de fichier log du faccons avec bonne fin
LOG_FACCONS=$DIR_BATCH_SHELL_LOG/$CURRENT_DATE.faccons.log
if [ -f $LOG_FACCONS ]
then
	if [ TRACE -eq 1 ]; then echo "Fichier log du FACCONS present";fi

	grep "ORA" $LOG_FACCONS > /dev/null

	if [ $? -eq 0 ]
	then
		if [ TRACE -eq 1 ]
		then
			echo "Erreur Oracle dans le fichier de log FACCONS"
		else
			cat $LOG_FACCONS | mail -s "Erreur de FACCONS : $LOG_FACCONS" -c "emmanuel.vinatier@socgen.com emmanuel.vinatier@socgen.com" emmanuel.vinatier@socgen.com
		fi
	else
		if [ TRACE -eq 1 ]; then echo "Fichier de log FACCONS OK";fi
	fi
else
	if [ TRACE -eq 1 ]
	then
		echo "Fichier log du FACCONS absent"
	else
		echo "Fichier log du FACCONS absent"|mail -s "Erreur de FACCONS : $LOG_FACCONS" -c "emmanuel.vinatier@socgen.com emmanuel.vinatier@socgen.com" emmanuel.vinatier@socgen.com
	fi
fi

exit 0
