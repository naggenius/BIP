#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : oscar.sh
# Objet : Shell de constitution du fichier pour Oscar et son envoi par FTP
#
#_______________________________________________________________________________
# Creation : ????
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     15/10/02   Migration ksh sur SOLARIS 8
# EGR	  15/11/02   Utilisation de logText
# PPR     13/10/06   Enlève l'envoi par FTP ( utilisation de TOM)
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.oscar.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de OSCAR (`basename $0`)"
logText "Debut de OSCAR (`basename $0`)" >> $LOG_FILE

# construction du nom du fichier
# on recupere dans la base de donnees le mois et l'annee des donnees courantes
param=`sqlplus -s $CONNECT_STRING << EOF
	whenever sqlerror exit failure;
	set headsep off
	set heading off
	set linesize 2000
	set feedback off
	select to_char(moismens, 'yy') || ' ' || to_char(moismens, 'mm') from datdebex;
EOF`

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Echec de lecture du mois et de l'annee dans oscar.sh" >> $LOG_FILE
	logText "Erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "===>$param<===" >> $LOG_FILE
	exit -1
fi

Annee=`echo $param|awk '{print $1}'`
Mois=`echo $param|awk '{print $2}'`

nom_fic_tache=$FILE_SS_TACHE_OSCAR
logText "Fichier Ss-taches = $nom_fic_tache" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "@$DIR_BATCH_SQL/oscar_sstache.sql spoole dans $PL_DATA/$nom_fic_tache"
	spool $OSCAR_DIR/$nom_fic_tache
	@$DIR_BATCH_SQL/oscar_sstache.sql
	spool off
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Probleme SQL*PLUS dans oscar.sql pour la generation des deux fichiers" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

#$DIR_BATCH_SHELL/shell_ftp.sh	$OSCAR_IP \
#				$OSCAR_PORT \
#				$OSCAR_LOGIN \
#				$OSCAR_PASSWORD \
#				$OSCAR_DIR \
#				$nom_fic_tache 2>> $LOG_FILE
# valeur de sortie de ftp
#FTP_EXIT=$?
#if [ $FTP_EXIT -ne 0 ]
#then
#	logText "Probleme dans oscar.sh pour le transfert FTP <$FTP_EXIT> du fichier des sous-taches" >> $LOG_FILE
#	exit -1
#fi

logText "OSCAR (`basename $0`)"
logText "Fin de OSCAR (`basename $0`)" >> $LOG_FILE

exit 0
