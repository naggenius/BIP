#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : purge_Q_diva.sh
# Objet : purge des fichiers import/export DIVA
#
# Parametres d'entree :
#
#_______________________________________________________________________________
# Creation :
# DDI     21/03/2007
#
# Modification :
# --------------
# Auteur  Date       Objet
# JAL	20/08/2007  rajout des fichiers projets et dossier projets DIVA 
# DDI	04/10/2007  Correction rajout des fichiers projets et dossier projets DIVA
#
###################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
        LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.purge_Q_diva.log
        rm $LOG_FILE 2> /dev/null
        logText "`basename $0` : fichier de trace : $LOG_FILE"
else
        LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de (`basename $0`)"
logText "Debut de (`basename $0`)" >> $LOG_FILE

# Parametrage des delais de purge
DELAI_RESS=7           #DIVA_RESSOURCES/reussite ../erreur
DELAI_LIGN=7           #DIVA_LIGNES/reussite ../erreur
DELAI_CONS=45          #${BIP_DATA}/diva
DELAI_PROJETS=7           		#DIVA_PROJETS
DELAI_DOSSIERS_PROJETS=7           #DIVA_DOSSIERS_PROJETS



#Purge des fichiers RESSOURCES
$DIR_BATCH_SHELL/purge_repertoire.sh J $DIVA_RESSOURCES/erreur $DELAI_RESS
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers DIVA ($DIVA_RESSOURCES/erreur)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh J $DIVA_RESSOURCES/reussite $DELAI_RESS
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers DIVA ($DIVA_RESSOURCES/reussite)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

#Purge des fichiers LIGNES
$DIR_BATCH_SHELL/purge_repertoire.sh J $DIVA_LIGNES/erreur $DELAI_LIGN
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers DIVA ($DIVA_LIGNES/erreur)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh J $DIVA_LIGNES/reussite $DELAI_LIGN
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers DIVA ($DIVA_LIGNES/reussite)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

#Purge des fichiers CONSOMMES
$DIR_BATCH_SHELL/purge_repertoire.sh J ${BIP_DATA}/diva $DELAI_CONS
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers DIVA (${BIP_DATA}/diva)"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi



# -----------   DDI  :  04/10/2007 CORRECTION Purge fichiers DIVA  PROJETS  et DIVA DOSSIERS PROJETS --------------------

#Purge des fichiers PROJETS DE DIVA
$DIR_BATCH_SHELL/purge_repertoire.sh J ${DIVA_PROJETS}/erreur  $DELAI_PROJETS
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers DIVA (${DIVA_PROJETS})"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh J ${DIVA_PROJETS}/reussite  $DELAI_PROJETS
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers DIVA (${DIVA_PROJETS})"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

#Purge des fichiers DOSSIERS PROJETS DE DIVA 
$DIR_BATCH_SHELL/purge_repertoire.sh J ${DIVA_DOSSIERS_PROJETS}/erreur $DELAI_DOSSIERS_PROJETS
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers DIVA (${DIVA_DOSSIERS_PROJETS})"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi

$DIR_BATCH_SHELL/purge_repertoire.sh J ${DIVA_DOSSIERS_PROJETS}/reussite $DELAI_DOSSIERS_PROJETS
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	logText "Echec lors de la purge des fichiers DIVA (${DIVA_DOSSIERS_PROJETS})"
	logText "arrêt du batch `basename $0`"
	exit 1;
fi


logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Fin de (`basename $0`)"
logText "Fin de (`basename $0`)" >> $LOG_FILE


exit 0
