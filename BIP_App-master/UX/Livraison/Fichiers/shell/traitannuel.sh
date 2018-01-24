#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : traitannuel.sh
# Objet : Shell Batch (traitannuel)
#
#_______________________________________________________________________________
# Creation : Equipe SOPRA 08/08/2000
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     14/10/02   Migration ksh SOLARIS 8
# EGR	  12/12/02   retrait de razannuel.sh
# NBM     21/11/03   ajout suivi_financier.sh :maj table CUMUL_CONSO pour IAS
# NBM     16/12/03   ajout de cloture_ias.sh : calculs des rectificatifs de décembre(stock_fi_dec et stock_immo_dec)
# PPR     21/11/05   ajout de archive_cloture.sh : archivage des données
#ABA        13/11/2008    Log IHM du shell 
################################################################################
autoload $(ls $FPATH)

LOG_TRAITEMENT=$DIR_BATCH_SHELL_LOG/$(date +"%Y%m%d").traitannuel.log
export LOG_TRAITEMENT
logText "`basename $0` : fichier de trace : $LOG_TRAITEMENT"


datedebut=`date +'%d/%m/%Y'`
heuredebut=`date +'%T'`

logText "--------------------------------------------------------------------------------" > $LOG_TRAITEMENT
logText "-- $(date +"%Y%m%d") Debut de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT

logText "-- Lancement de debfintrait.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/debfintrait.sh 'DEBUT Traitement Annuel 2eme Phase' 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement debfintrait.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('traitannuel.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Echec lors de l execution du traitement debfintrait"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit -1;
fi
######################################
logText "-- Lancement de histo_cloture.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/histo_cloture.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement histo_cloture.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('traitannuel.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Echec lors de l execution du traitement histo_cloture"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit -1;
fi

################################################################################
logText "-- Lancement de suivi_financier.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/suivi_financier.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement suivi_financier.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('traitannuel.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Problème dans le traitement suivi_financier"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit -1;
fi
####################### SEL PPM 58986 : pas de reinjection de decembre dans STOCK_FI ###########
logText "-- Lancement de cloture_ias.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/cloture_ias.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement cloture_ias.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('traitannuel.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Problème dans le traitement cloture_ias"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit -1;
fi
######################################
logText "-- Lancement de cloture.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/cloture.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement cloture.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('traitannuel.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Echec lors de l execution du traitement cloture"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit -1;
fi
######################################
logText "-- Lancement de debfintrait.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/debfintrait.sh 'FIN Traitement Annuel 2eme Phase' 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement debfintrait.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('traitannuel.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Echec lors de l execution du traitement debfintrait"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit -1;
fi
######################################
logText "-- Lancement de archive_cloture.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/archive_cloture.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement archive_cloture.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('traitannuel.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Echec lors de l execution du traitement archive_cloture"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit -1;
fi

######################################
logText "-- Lancement de purge_trace.sh" >> $LOG_TRAITEMENT
$DIR_BATCH_SHELL/purge_trace.sh 2>> $LOG_TRAITEMENT
SHELL_EXIT=$?
if [ $SHELL_EXIT -ne 0 ]
then
	datefin=`date +'%d/%m/%Y'`
	heurefin=`date +'%T'`
	varlog="Echec lors du traitement purge_trace.sh"
	sqlplus -s $CONNECT_STRING << EOF
	insert into BATCH_LOGS_BIP values ('traitannuel.sh','$datedebut', '$heuredebut','$datefin','$heurefin','$varlog',0,0, 'NOK');
EOF
	logText "Echec lors de l execution du traitement purge_trace"
	logText "arrêt du batch `basename $0`"
	unset LOG_TRAITEMENT
	exit -1;
fi
######################################

# Fin du batch de traitement annuel
datefin=`date +'%d/%m/%Y'`
heurefin=`date +'%T'`
sqlplus -s $CONNECT_STRING << EOF
insert into BATCH_LOGS_BIP values ('traitannuel.sh','$datedebut', '$heuredebut','$datefin','$heurefin',null,0,0, 'OK');
EOF

logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
logText "-- Fin Normale de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT
unset LOG_TRAITEMENT

exit 0
