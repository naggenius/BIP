#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : compileSql.sh
# Objet : Shell lancant la compilation des fichiers sql de l'application
#
#_______________________________________________________________________________
# Creation : E.GREVREND 17/12/02
# Modification :
# --------------
# Auteur  Date       Objet
#
################################################################################

#################################################
# On charge l'environnement
#################################################
. $APP_ETC/bipparam.sh
#################################################

LOG_FILE=$APP_BIN/log/$BIP_ENV.`date +"%Y%m%d"`.compileSql.log
LOG_TMP=$TMPDIR/`date +"%Y%m%d"`.compileSql.tmplog
rm -f $LOG_FILE 2> /dev/null

logText "`basename $0` - Fichier de trace : $LOG_FILE"

# Liste des fichiers contenant une liste de fichiers sql a compiler
LISTE_FIC_SCRIPTS="$DIR_BATCH_SQL/script_batch.sql \
		$DIR_PLSQL_COMMUN/script_commun.sql \
		$DIR_PLSQL_EXTRACT/script_extract.sql \
		$DIR_PLSQL_ISAC/script_isac.sql \
		$DIR_PLSQL_REPORTS/script_report.sql \
		$DIR_PLSQL_TP/script_a_lancer.sql"
NB_FIC_SCRIPT=0
NB_SCRIPT=0
NB_ERR_FICHIER=0
NB_ERR_COMPIL=0

# on parcours la liste des fichiers contenant eux meme la liste des fichiers a compiler
for FIC_SCRIPT in $LISTE_FIC_SCRIPTS
do
	NB_FIC_SCRIPT=$(( NB_FIC_SCRIPT+1 ))
	if [ ! -r $FIC_SCRIPT ]
	then
		logText "Le fichier de scripts $FIC_SCRIPT n'existe pas"
		logText "Le fichier de scripts $FIC_SCRIPT n'existe pas" >> $LOG_FILE
		NB_ERR_FICHIER=$(( $NB_ERR_FICHIER+1 ))
	else
		logText "Parcours du fichier de script $FIC_SCRIPT"
		logText "Parcours du fichier de script $FIC_SCRIPT" >> $LOG_FILE

		CUR_REP=`dirname $FIC_SCRIPT`
		# on parcours la liste des fichiers a compiler du fichier de liste courant
		for SCRIPT in $(sed s/@//g $FIC_SCRIPT)
		do
			NB_SCRIPT=$(( NB_SCRIPT+1 ))
			if [ ! -r $CUR_REP/$SCRIPT ]
			then
				logText "-- Le script $CUR_REP/$SCRIPT n'existe pas"
				logText "-- Le script $CUR_REP/$SCRIPT n'existe pas" >> $LOG_FILE
				NB_ERR_FICHIER=$(( $NB_ERR_FICHIER+1 ))
			else
				logText "-- Execution du script $CUR_REP/$SCRIPT"
				logText "-- Execution du script $CUR_REP/$SCRIPT" >> $LOG_FILE
				# on compile le fichier courant
				sqlplus -s $ORA_USR_LIVE@$ORA_LIVE <<! > $LOG_TMP 2>&1
					whenever sqlerror exit failure;
					@$CUR_REP/$SCRIPT
!
				PLUS_EXIT=$?
				if [ $PLUS_EXIT -ne 0 ]
				then
					logText "## Echec de $CUR_REP/$SCRIPT"
					logText "## Echec de $CUR_REP/$SCRIPT : " >> $LOG_FILE
					cat $LOG_TMP >> $LOG_FILE
					NB_ERR_COMPIL=$(( $NB_ERR_COMPIL+1 ))
				fi
			fi
		done
	fi
done

logText "Compilation terminee"
logText "Compilation terminee" >> $LOG_FILE

rm -f $LOG_TMP 2> /dev/null

if [ $NB_ERR_FICHIER -ne 0 ]
then
	logText "==> Des scripts sont manquant ($NB_ERR_FICHIER/$(( $NB_FIC_SCRIPT+$NB_SCRIPT )))"
	logText "==> Des scripts sont manquant ($NB_ERR_FICHIER/$(( $NB_FIC_SCRIPT+$NB_SCRIPT )))" >> $LOG_FILE
fi

if [ $NB_ERR_COMPIL -ne 0 ]
then
	logText "==> Des compilations ont echouees ($NB_ERR_COMPIL/$NB_SCRIPT)"
	logText "==> Des compilations ont echouees ($NB_ERR_COMPIL/$NB_SCRIPT)" >> $LOG_FILE
fi

if [ $(( NB_ERR_FICHIER+NB_ERR_COMPIL )) -ne 0 ]
then
	logText "==> Consulter $LOG_FILE"
fi
