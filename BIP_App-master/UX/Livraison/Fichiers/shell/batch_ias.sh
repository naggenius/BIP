#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : batch_ias.sh
# Objet : Shell batch pour la Facturation Interne et les Immobilisations
#
#_______________________________________________________________________________
# Creation :  NBM 07/11/2003
# Modification :
# --------------
# Auteur  Date       Objet
# ABA     07/04/2008	suppresion du nom du fichier SMS pour integration dans le pack (séparation automatique du fichier en fonction des systèmes comptables)
#ABA      09/03/2009   TD 770 Suppression du traitement de SMS
################################################################################

autoload $(ls $FPATH)

if [ -z $LOG_TRAITEMENT ]
then
	LOG_FILE=$DIR_BATCH_SHELL_LOG/`date +"%Y%m%d"`.IAS.log
	rm $LOG_FILE 2> /dev/null
	logText "`basename $0` : fichier de trace : $LOG_FILE"
else
	LOG_FILE=$LOG_TRAITEMENT
fi

logText "--------------------------------------------------------------------------------" >> $LOG_FILE
logText "Debut de BATCH_IAS (`basename $0`)"
logText "Debut de BATCH_IAS (`basename $0`)" >> $LOG_FILE

# MTC - FICHIER_OUT_1=FACTINT
# MTC - FICHIER_FI=$FICHIER_OUT_1.txt
# MTC - FICHIER_GLOBAL="GLOBAL_SMS_EXP.D"`date +"%d%m%y"`
# MTC - FICHIER_MOISMENS=moismens.tmp

BU_MANQUANTE=$DIR_BATCH_DATA/$BU_MANQUANTE.csv
rm -f $BU_MANQUANTE


#fichier de test pour procedure export_immo_en
#FICHIER_EXPENSE="EXP_encours.csv"

logText "| Fichier out FI: $FICHIER_FI"
logText "| Fichier out FI: $FICHIER_FI" >> $LOG_FILE

logText "| Fichier out global: $FICHIER_GLOBAL"
logText "| Fichier out gloabl: $FICHIER_GLOBAL" >> $LOG_FILE
logText "| Fichier out Expense: $FICHIER_EXPENSE"
logText "| Fichier out Expense: $FICHIER_EXPENSE" >> $LOG_FILE

# Suppression du fichier temporaire contenant la date de la mensuelle
rm -f $PL_LOGS/$FICHIER_MOISMENS 2> /dev/null

# appel SQL*PLUS (mode silencieux -s) avec trace execution
# utilise le login unix (a definir dans la base)
logText "sqlplus" >> $LOG_FILE
sqlplus -s $CONNECT_STRING <<! >> $LOG_FILE 2>&1
	whenever sqlerror exit failure;
	execute PACKBATCH_IAS.IAS('$PL_LOGS');
	execute PACKBATCH_IAS.FI('$PL_LOGS','$PL_DATA','$FICHIER_FI');
	execute PACKBATCH_IAS.IMMO('$PL_LOGS','$PL_DATA','$FICHIER_GLOBAL');
	execute PACK_IMMO.EXPORT_IMMO_EN('$PL_LOGS','$PL_DATA','$FICHIER_EXPENSE');
	execute PACKBATCH_IAS.DATRAIT('$PL_LOGS','$PL_DATA','$FICHIER_MOISMENS');
!

# valeur de sortie de SQL*PLUS
PLUS_EXIT=$?
if [ $PLUS_EXIT -ne 0 ]
then
	logText "Problème SQL*PLUS dans batch IAS : consulter $LOG_FILE"
	logText "et le fichier $PL_LOGS/AAAA.MM.JJ.IAS.log du jour"
	logText "Consulter le fichier $PL_LOGS/AAAA.MM.JJ.IAS.log du jour"
	logText "Code erreur : <$PLUS_EXIT>" >> $LOG_FILE
	exit -1;
fi

if test -s "$DIR_BATCH_DATA/BU_manquante.csv"
 then
###################################################################################
####################################################################################
####################################################################################
################# Envoi du fichier des BU manquante #############################


#PPM 58132 : Ano : Liste des BUs manquantes
#CONTENU=`cat $BU_MANQUANTE | sort | uniq`
CONTENU=`cat $DIR_BATCH_DATA/BU_manquante.csv | sort | uniq`

#Construction des differents parametres a passer a envoi_mail.sh
REMONTE="M001"
PRIORITE=""
OBJECT="BU Manquante Traitement du "`date +"%d/%m/%Y"`
CORPS=""
CORPS="${CORPS}Bilan de la génération du fichier des immobilisations Expense.\n\n" 
CORPS="${CORPS}"
CORPS="${CORPS}Le BU des CAFIs suivants n'a pas pu être déterminé.\n\n"
CORPS="${CORPS}"
CORPS="${CORPS}$CONTENU\n\n"
CORPS="${CORPS}"
CORPS="${CORPS}PENSEZ A MODIFIER LE FICHIER EXPENSE"
PJ=""

#Appel envoi_mail.sh
$DIR_BATCH_SHELL/envoi_mail.sh "${REMONTE}" "${PRIORITE}" "${OBJECT}" "${CORPS}" "${PJ}"

logText " Envoi du mail avec la liste des BU manquantes" >> $LOG_FILE
####################################################################################
####################################################################################
####################################################################################
fi

# Recuperation MMAAAA de traitement à partir du fichier moismens.tmp
MOIS=`cat $EMISSION/$FICHIER_MOISMENS`
FICHIER_COPIE_FI=$FICHIER_FI.M$MOIS
DIR_COPIE_FI=$DIR_BATCH_DATA

CMD_EXIT=$?
if [ $CMD_EXIT -ne 0 ]
then
	logText "Echec de la recopie : consulter $LOG_FILE"
	logText "Code erreur : <$CMD_EXIT>"	>> $LOG_FILE
	exit -1;
fi


logText "Fin de BATCH_IAS (`basename $0`)"
logText "Fin de BATCH_IAS (`basename $0`)" >> $LOG_FILE

exit 0
