#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : maj_ress_imm.sh
# Objet : Shell batch pour mettre à jour les tables ressource et immeuble
#         Appelé par maj_ressource_immeuble
#_______________________________________________________________________________
# Creation :  BAA 26/09/2005
# Modification :
# --------------
# Auteur  	Date       		Objet
# ABA       01/04/2008    	Ajout traitement pour affichage des logs via l'ihm bip
# YNI     	21/01/2010    	Ajout traitement pour ecriture dans quotidienne.txt
################################################################################

autoload $(ls $FPATH)

#YNI Fichier de la quotidienne 
FILE_QUOTIDIENNE=$DIR_BATCH_SHELL_LOG/quotidienne.txt
#Fin YNI

datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.MAJ_RESS_IMM.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

log_tmp=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.MAJ_RESS_IMMtmp.txt

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de la mise à jour ressources et immeubles : maj_ress_imm.sh" >> $LOG_FILE


# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $log_tmp 2>&1
	whenever sqlerror exit failure;
	execute PACK_BATCH_RESSIMMEUB.MAJ_RESSOURCE('$PL_LOGS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog=`sed "s/$/<br>/; s/'/ /g" $log_tmp`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('maj_ress_imm.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas NOK
	echo " maj_ress_imm.sh ECHEC" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "Problème SQL*PLUS dans batch MAJ_RESS_IMM : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.MAJ_RESS_IMM.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.MAJ_RESS_IMM.log du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	rm -f $log_tmp
	logText "=== Fin ANORMALE de la mise à jour ressources et immeuble : maj_ress_imm.sh ===" >> $LOG_FILE
	exit -1;
else
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	cat $log_tmp >> $LOG_FILE 2>&1
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('maj_ress_imm.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF
	rm -f $log_tmp
	#YNI Ecriture dans le fichier quotidienne.txt dans le cas OK
	echo " maj_ress_imm.sh OK" >> $FILE_QUOTIDIENNE
	#Fin YNI
	logText "=== Fin NORMALE de la mise à jour ressources et immeuble : maj_ress_imm.sh ===" >> $LOG_FILE
fi


exit 0
