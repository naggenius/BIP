#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : metrique.sh
# Objet : Shell de constitution du fichier pour METRIQUE 
#         Lancé le 4 è jour ouvré du mois
# --------------
# Auteur  Date       Objet
# DDI     09/12/05   creation
#
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.metrique.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

#REP_EXTRACT=$METRIQUE
REP_EXTRACT=$OSCAR_QUOTIDIEN

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de METRIQUE (`basename $0`)"
logText "Debut de METRIQUE (`basename $0`)" >> $LOG_FILE

# construction du nom du fichier
# on recupere dans la base de donnees le mois et l'annee des donnees courantes
param=`sqlplus -s $CONNECT_STRING << EOF
	whenever sqlerror exit failure;
	set headsep off
	set heading off
	set linesize 2000
	set feedback off
	select to_char(sysdate, 'ddmmyyyy') from dual;
EOF`

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Echec de lecture du mois et de l'annee dans metrique.sh" >> $LOG_FILE
	logText "Erreur : <$PLUS_EXIT>" >> $LOG_FILE
	logText "===>$param<===" >> $LOG_FILE
	exit -1
fi

#Date=`echo $param|awk '{print $1}'`
#Mois=`echo $param|awk '{print $2}'`

nom_fic=$nom_fic_metrique
#nom_fic=truc.csv
logText "Fichier = $nom_fic" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	!echo "pack_oscar_lignebip.select_bip_metrique"
	exec pack_oscar_lignebip.select_bip_metrique('$REP_EXTRACT', '$nom_fic')
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Probleme SQL*PLUS dans select_bip_metrique pour la generation du fichier" >> $LOG_FILE
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi


logText "METRIQUE (`basename $0`)"
logText "Fin de METRIQUE (`basename $0`)" >> $LOG_FILE

exit 0
