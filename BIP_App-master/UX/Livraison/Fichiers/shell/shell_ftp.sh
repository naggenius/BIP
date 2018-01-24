#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : shell_ftp.sh
# Objet : Programme de Distribution des Fichiers par FTP
#
# Parametres d'entree :
#       $1      Adresse IP du serveur FTP distant
#       $2      Port FTP du serveur
#       $2      login
#       $3      Password
#       $4      Répertoire local
#       $5      Fichier à transmettre
#
#_______________________________________________________________________________
# Creation :
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     15/10/02   Migration ksh sur SOLARIS 8
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.shell_ftp.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE

if [ $# -ne 6 ]
then
	logText "Mauvais nombre d'arguments" >&2
	logText "Usage `basename $0` IP Port Login Password RepLocal Fichier" >&2
	logText "Mauvais nombre d'arguments" >> $LOG_FILE
	logText "Usage `basename $0` IP Port Login Password RepLocal Fichier" >> $LOG_FILE
	exit -1
else
	ADR=$1
	PORT=$2
	LOGIN=$3
	PASS=$4
	DLOCAL=$5
	FILE=$6
	logText "| Adresse IP : $ADR"
	logText "| Port : $PORT"
	logText "| Login : $LOGIN"
	logText "| Rep. local : $DLOCAL"
	logText "| Fichier : $FILE"

	logText "| Adresse IP : $ADR" >> $LOG_FILE
	logText "| Port : $PORT" >> $LOG_FILE
	logText "| Login : $LOGIN" >> $LOG_FILE
	logText "| Rep. local : $DLOCAL" >> $LOG_FILE
	logText "| Fichier : $FILE" >> $LOG_FILE
fi

# ascii : mode de transfert
# prompt : desactive confirmation
# quote STAT : recupere les info du serveur FTP (rstatus sous AIX)
# quote SYST : recupere l'OS du serveur FTP (system sous AIX)
# trace : active le log des packets (non implemete sous SOLARIS)
ftp -vn << EOF >> $LOG_FILE 2>&1
	open $ADR $PORT
	user $LOGIN $PASS
	ascii
	prompt
	quote STAT
	quote SYST
	trace
	lcd $DLOCAL
	mput $FILE
	bye
EOF

FTP_EXIT=$?

if [ $FTP_EXIT -eq 0 ]
then
	#la commande ftp est bien passee, mais le fichier a t'il ete correctement envoye ?
	# => on recherche dans le fichier de log la trace du succes de l'envoie
	#  Transfer complete.
	grep -i "Transfer complete." $LOG_FILE > /dev/null 2>&1
	CMD_EXIT=$?
	if [ $CMD_EXIT -ne 0 ]
	then
		logText "Echec du transfert de $FILE"
		logText "Echec du transfert de $FILE" >> $LOG_FILE
		FTP_EXIT=$CMD_EXIT
	fi
fi

logText "Code retour du ftp : $FTP_EXIT"
logText "Code retour du ftp : $FTP_EXIT" >> $LOG_FILE

exit $FTP_EXIT
