#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : bipparam.sh
# Objet : parametres GENERAUX  de l'application BIP
#
#_______________________________________________________________________________
# Creation : EGR     21/10/2002
# Modification :
# --------------
# Auteur  Date       Objet
# EGR     22/10/02   Ajout DIR_REPORT_OUT, repertoire de sortie des reports
# EGR	  15/11/02   Ajout de la fonction logText : echo avec timestamp
#		     utilisation de logText a la place de echo
# EGR	  21/02/03   Modif de OSCAR_QUOTIDIEN
# EGR	  14/03/03   Gestion de bipdata, batch/log, batch/data et biphist hors clearcase
#			cc : dans clearcase : /vich/bip1
#			old : /projet/bip/
# EGR	  11/08/03   Ajout params pour remonte BIP et nouvel en d'homo
# MMC     28/10/03   Ajout param pour recuperer les niveaux des SG depuis Gershwin
# MMC     22/04/04   Ajout pour le chargement des ES
# MMC     09/05/05   Ajout eSourcing
# DDI     08/01/07   Ajout DIVA
# DDI     11/06/07   Ajout XBIS
# DDI     24/09/07   Ajout DIVA - Referentiels Projets
# ABA     21/03/08   Ajout Adonix
# ABA     26/01/08   Ajout immo definitive
# OEL     16/11/11   Remontee BIP - Typetape dynamique depuis la base de données (QC 1283)
# NGE     03/02/12   TC12-4133
# JDO + TCO     11/07/12   Ajout variables Prest@chat
################################################################################

function logText {
	echo $(date +"[%H:%M:%S]") $*
}

#on verifie que bipparam.sh n'pas ete lance
if ! [ -z $BIPPARAM_DEFINED ]
then
	#logText "(bipparam.sh deja initialise)"
	return 0
fi

#logText Lecture des parametres dans bipparam.sh

export dirprod=$APP_HOME

################################################################################
# Partie variable dependante de l'environnement
################################################################################
if [ $BIP_ENV == BIP_PRODUCTION ]
then
	#logText "Chargement de l'environnement '$BIP_ENV'"
	#pour pouvoir utiliser reports il faut un display valide ...
	export DISPLAY=192.16.225.105:0.0
	#  Parametres lies a Oracle et  Report (Instance live et historique, user, password,..)
	#export  ORA_LIVE=BIPPRODSUN
	export  ORA_LIVE=pbippbip
	export  ORA_REPSERV=Rep60
	# Repertoire racine de l'application BIP, de l'instance live et historique
	export  HOME_BIP=$dirprod
	# Parametres Oscar
	export	OSCAR_IP=192.16.248.30
	export	OSCAR_PORT=5051
	export	OSCAR_LOGIN=FTPBIP_USR
	export	OSCAR_PASSWORD=chicago03
	#  Parametres lies a Oracle et  Report (Instance live et historique, user, password,..)
	export  ORA_USRID=bip
	export  ORA_USRPWD=C8bIx96DZBHX
	export  ORA_USR_LIVE=$ORA_USRID/$ORA_USRPWD
	export  ORA_HIST=pbipphst
	export  ORA_USRID_HIST=biph
	export  ORA_USRPWD_HIST=s9P8DAe8R332
	export  ORA_USR_HIST=$ORA_USRID_HIST/$ORA_USRPWD_HIST
	export  HOME_VIEW=$APP_HOME
	# création des 14 mots de passe pour les schemas de la base d'histo le : est element séparateur
	export  ORA_HSTPWD=s9F8t3D5r9S6:e9Y6r9u9TP99:u6G5j8Y9r4AZ:z9R2h8T2v9X3:w9D8r5A1e9P4:r2U9s4X9w4C7:p9W8d3F7h2W5:s2F8q7W3c1Z9:r5F8g7T2s4E4:k6P8d6F3g4E1:x9F5y2S3z5R7:h9T5f1E6w5Z7:k2F8s9N1D8z3:e7T5E9u5b3EE
	# Parametres de connexion JDBC - RBip
	export  ORA_DB_PORT=1595
	export  ORA_DB_HOST=p-ora10-bip.dns30.socgen
	export  EMISSION=/applis/bipp/emission
	export	RECEPTION=/applis/bipp/reception
	export 	RECEPT_PRA=PPRALX01
	export 	RECEPT_SFPM=PBGDAP01
	export 	RECEPT_MEGA=POQL2K01
	export  EMET=PBIPP
	export  RAPPORT_WEBLO=/applis/bip_wl9/bip9dom/bip_wl9/data/rapport/
	export  REPORT_WEBLO=/applis/bip_wl9/bip9dom/bip_wl9/data/reports/
	export  CPTREP=bippoas
	
#Environnement Developpement
elif [ $BIP_ENV == BIP_HOMOLOGATION ]
then
	export DISPLAY=192.16.225.105:0.0
	#  Parametres lies a Oracle et  Report (Instance live et historique, user, password,..)
	export  ORA_LIVE=HBIPFBIP
	export  ORA_REPSERV=r
	# Repertoire racine de l'application BIP, de l'instance live et historique
	export  HOME_BIP=$dirprod
	#  Parametres lies a Oracle et  Report (Instance live et historique, user, password,..)
	export  ORA_USRID=bip
	export  ORA_USRPWD=f89VkM8q
	export  ORA_USR_LIVE=$ORA_USRID/$ORA_USRPWD
	export  ORA_HIST=HBIPFHST
	export  ORA_USRID_HIST=biph
	export  ORA_USRPWD_HIST=mq2aymso
	export  ORA_USR_HIST=$ORA_USRID_HIST/$ORA_USRPWD_HIST
	export  HOME_VIEW=$APP_HOME
	# création des 14 mots de passe pour les schemas de la base d'histo le : est element séparateur
	export  ORA_HSTPWD=tos2jfUj:g7TI4Sgi:flg8rqoH:sOewlNW5:dtK266KP:yz5UkLhh:uMYi8TUB:c3P6FsOZ:pmGXmUog:v3qcGK5J:rR0j76CA:zZHEhiBJ:VPYCUDQ2:sgAn3Aj2
	# Parametres de connexion JDBC - RBip
	export  ORA_DB_PORT=1595
	export  ORA_DB_HOST=h-ora10-bip.dns30.socgen
	export  EMISSION=/applis/bipf/emission
	export	RECEPTION=/applis/bipf/reception
	export 	RECEPT_PRA=HPRALX01
	export 	RECEPT_SFPM=HBGDAP01
	export 	RECEPT_MEGA=HOQL2K01
	export  EMET=HBIPF
	export  RAPPORT_WEBLO=/applis/bip_wl9/hbip9dom/bip_wl9/data/rapport
	export  REPORT_WEBLO=/applis/bip_wl9/hbip9dom/bip_wl9/data/reports
	export  CPTREP=bipfoas
	
	#Environnement Developpement
elif [ $BIP_ENV == DEV ]
then
	export  ORA_LIVE=dbipdbip
	export  ORA_REPSERV=rep_dtmaz04_Reports10gR2
	export  HOME_BIP=/utl_file_dir/bip/dbipdbip/utl_file
	#  Parametres lies a Oracle et  Report (Instance live et historique, user, password,..)
	export  ORA_USRID=bip
	export  ORA_USRPWD=bip
	export  ORA_USR_LIVE=$ORA_USRID/$ORA_USRPWD
	export  ORA_HIST=dbipdhst
	export  ORA_USRID_HIST=biph
	export  ORA_USRPWD_HIST=tpm1RVrN4fYc
	export  ORA_USR_HIST=$ORA_USRID_HIST/$ORA_USRPWD_HIST
	# Parametres de connexion JDBC - RBip
	export  ORA_DB_PORT=12200
	export  ORA_DB_HOST=dtmaz04.dns21.socgen
	export  EMISSION=/applis/bipd/emission
	export  RECEPTION=/applis/bipd/reception
	export  RECEPT_PRA=HPRALX01
	export 	RECEPT_SFPM=HBGDAP01
	export 	RECEPT_MEGA=
	export  EMET=HBIPF
	export  RAPPORT_WEBLO=/applis/bipd/weblogic/dom922dev/servers/bipSrv/data/rapport
	export  REPORT_WEBLO=/applis/bipd/weblogic/dom922dev/servers/bipSrv/data/reports
	export  CPTREP=oasadm
else
	logText "'$BIP_ENV' : environnement inconnu" >&2
	exit 1
fi

################################################################################
# Parametres de connexion JDBC - RBip
################################################################################
export  ORA_DB_URL="jdbc:oracle:thin:@"$ORA_DB_HOST":"$ORA_DB_PORT":"$ORA_LIVE

################################################################################
# Partie constante entre les differents environnents
################################################################################

## destinataire mis en copie pour l'envoi de mail automatique
export CC="Antoine.Baboeuf@socgen.com Arnaud.Le-Dorze@socgen.com List.Fr-Bip-Tma@socgen.com"


export APP_ETC=$APP_HOME

#  Directory  des sources plsql et des reports
export	DIR_SOURCE=$HOME_VIEW/source
DIR_PLSQL=$DIR_SOURCE/plsql
export  DIR_PLSQL_TP=$DIR_PLSQL/tp
export  DIR_PLSQL_REPORTS=$DIR_PLSQL/reports
export  DIR_PLSQL_EXTRACT=$DIR_PLSQL/extract
export	DIR_PLSQL_COMMUN=$DIR_PLSQL/commun	#new
export	DIR_PLSQL_ISAC=$DIR_PLSQL/isac	#new

export	DIR_INTRA_EXECREPORTS=$DIR_INTRA/WEB-INF/cmd
export  DIR_REPORT=$DIR_INTRA/reports
export  DIR_REPORT_OUT=$DIR_INTRA/rapport


#   Directory des Batchs
DIR_BATCH=$HOME_VIEW/batch
export  DIR_BATCH_SQL=$DIR_BATCH/sql
export  DIR_BATCH_SHELL=$DIR_BATCH/shell
export  DIR_BATCH_BOUCLAGE=$DIR_BATCH/bouclage
export	DIR_BATCH_GDC=$DIR_BATCH/gdc
export	DIR_BATCH_REPORT=$DIR_BATCH/reports
export	DIR_BATCH_REPORT_OUT=$DIR_BATCH/rapport
export  DIR_OSCAR_BATCH=$DIR_BATCH/oscar
export  DIR_SQLLOADER_PARAM=$DIR_BATCH/load


#		Directory des logs
export  BIP_HIST=$HOME_BIP/biphist
DIR_BATCH=$HOME_BIP/batch
export  DIR_SQLLOADER_LOG=$DIR_BATCH/log
export  DIR_BATCH_SHELL_LOG=$DIR_BATCH/log
export  DIR_BATCH_DATA=$DIR_BATCH/data


#   Nom Fichier utilise par le Batch
export  FILE_PMW_1=$DIR_BATCH_DATA/pmw1.dat
export  FILE_PMW_2=$DIR_BATCH_DATA/pmw2.dat
export  FILE_PMW_3=$DIR_BATCH_DATA/pmw3.dat
export  FILE_DPA_CAMO=$DIR_BATCH_DATA/dpa.dat
export	FILE_USER_SAMBA_LST=$DIR_BATCH_DATA/user_samba.lst
export  FILE_RBIPINTRA=BIP.RBIP.BIP


#   Directory des UTL files de ORACLE - chemin definie dans  initbip.ora
export  BIP_DATA=$HOME_BIP/bipdata

export  ORA_LIVE_UTL_EXTRACTION=$BIP_DATA/extraction
export  ORA_LIVE_UTL_EXTRACTION_HIST=$BIP_HIST/extraction
export  ORA_LIVE_UTL_BATCH=$BIP_DATA/batch
export  ORA_LIVE_UTL_BATCH_LOG=$ORA_LIVE_UTL_BATCH
export  ORA_LIVE_UTL_IMPCOMPTA=$BIP_DATA/import_compta
export  ORA_LIVE_UTL_EXPCOMPTA=$BIP_DATA/export_compta
export  ORA_LIVE_UTL_EXPCOMPTA_ERREUR=$ORA_LIVE_UTL_EXPCOMPTA/erreur
export  ORA_LIVE_UTL_EXPORT=$BIP_DATA/export
export  ORA_HIST_UTL_HISTORIQUE=$BIP_HIST/historique
export  BIP_DATA_FI=$ORA_LIVE_UTL_BATCH/fi

#   Parametres Oscar

export	OSCAR_DIR=$ORA_LIVE_UTL_EXTRACTION # a retirer (aussi dans scripts) utilise dans batch/shell/oscar.sh
export  OSCAR_QUOTIDIEN=$BIP_DATA/oscar/export	# dans UTL files !!

#   Parametres BIP vers DIVA
	
export  DIVA_LIGNES=$BIP_DATA/diva/export_lignes
export  DIVA_RESSOURCES=$BIP_DATA/diva/export_ressources
export  DIVA_PROJETS=$BIP_DATA/diva/export_projets
export  DIVA_DOSSIERS_PROJETS=$BIP_DATA/diva/export_dossiers_projets
export  DIVA_CONSOHP=$BIP_DATA/diva/export_conso_hp

#   Parametres DIVA vers BIP
	
export  DIR_DIVA_DATA=$DIR_BATCH_DATA          # repertoire de depot de fichier diva !!
export  DIR_DIVA_HIST=${BIP_DATA}/diva
export  DIR_DIVA_EXTRACT=$HOME_BIP/RBip/data/DIVA
export  FIC_DIVA=diva_consomme.tar     # fichier de donnees diva !

#   Parametres XBIS

export  EBIS_DIR_CONTRATS=$BIP_DATA/ebis/export_contrats	# repertoire de depot du fichier contrats
export  EBIS_DIR_REALISES=$BIP_DATA/ebis/export_realises	# repertoire de depot du fichier realises

export  EBIS_FIC_FACT=ebis_i_factures.csv     			# nom du fichier des factures EXPENSE BIS
export  EBIS_DIR_FACT=$BIP_DATA/ebis/import_factures          	# repertoire de depot du fichier EXPENSE BIS !!

#   Parametres Fair
export	FAIR_DIR=$ORA_LIVE_UTL_EXTRACTION
export	FAIR_EXTRACT=$BIP_DATA/fair

#  Parametres Bouclage J/H
export	FILE_BJH_IMPORT_GERSHWIN=abs_gershwin.dat	#dans $DIR_BATCH_DATA

#  Parametres niveaux Gershwin
export FILE_IMPORT_NIVEAU=$DIR_BATCH_DATA/import_niveau.dat   #new

#  Parametres chargement des ES
export FILE_IMPORT_ES=$DIR_BATCH_DATA/import_ES.dat

# Parametres application
export FILE_APPLI=$DIR_BATCH_DATA/application.dat 

#  eSourcing
export FILE_IMPORT_RESSOURCE=$DIR_BATCH_DATA/eSourcing_ress.csv
export FILE_IMPORT_SITU=$DIR_BATCH_DATA/eSourcing_situ.csv
export FILE_IMPORT_CONTRAT=$DIR_BATCH_DATA/eSourcing_cont.csv
export FILE_IMPORT_LIGNE_CONT=$DIR_BATCH_DATA/eSourcing_ligne_cont.csv
export ESOURCING=$BIP_DATA/esourcing

# Parametres pour la remonte bip
export	BIP_DATA_REMONTEE=$BIP_DATA/remontee
export	BIP_DATA_REMONTEE_REJECT=$BIP_DATA_REMONTEE/reject
export	BIP_DATA_REMONTEE_HISTO=$BIP_DATA_REMONTEE/histo
export	REMONTEE_LINESIZE_MAX=84

export	TRAIT_1PREMENSUELLE=1
export	TRAIT_2PREMENSUELLE=2
export	TRAIT_MENSUELLE=3

export BIPPARAM_DEFINED=1

#parametres env oracle sql ...
export	DIR_ORACLE=$HOME_BIP/oracle
export	DIR_ORACLE_DATA=$DIR_ORACLE/data
export	DIR_ORACLE_DATA_OLD=$DIR_ORACLE_DATA/old

export	DIR_ORACLE_EXPORT_USER=$HOME_BIP/oracle/export_user

########## Parametres SGAM #############
export  ADONIX_REP=$BIP_DATA/sgam/export_conso

########## Parametres PEPSI #############
export  PEPSI_REP=$BIP_DATA/pepsi


########## Parametres RBIP#############
export BIP_RBIP_DIR=$HOME_BIP/RBip

########## Immo definitive #############
export IMMO_DEF=$BIP_DATA/immo

########## Parametres GIMS vers BIP #############
export  DIR_GIMS_DATA=$DIR_BATCH_DATA          # repertoire de depot de fichier gims !!
export  DIR_GIMS_HIST=${BIP_DATA}/gims
export  DIR_GIMS_EXTRACT=$HOME_BIP/RBip/data/GIMS
export  FIC_GIMS=gims_consomme.tar     # fichier de donnees gims !

####### PRA ##############
export PRA_CONSO=${EMET}.${RECEPT_PRA}.CONSO.D`date +"%d%m%y"`.PRET
export FIC_PRA_RESS=${RECEPT_PRA}.${EMET}.RESSOUR.D`date +"%d%m%y"`.*.RECU
export FIC_PRA_CTRA=${RECEPT_PRA}.${EMET}.CONTRAT.D`date +"%d%m%y"`.*.RECU
export DIR_PRA_CONSO=$BIP_DATA/pra/conso

####### SFPM ############
export STOCK_FI=${EMET}.${RECEPT_SFPM}.IMMO.D`date +"%d%m%y"`.PRET
export STOCK_IMMO=${EMET}.${RECEPT_SFPM}.FI.D`date +"%d%m%y"`.PRET

####### MEGA ############
export EXP_MEGA=${EMET}.${RECEPT_MEGA}.DPG.D`date +"%d%m%y"`.PRET


return 0
