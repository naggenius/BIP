#!/bin/ksh
##################################################################################
#
#   PROCEDURE DE LIVRAISON
#		4 arguments sont necessaire
#				1: environnement de livraison valeur possible :  PROD ou HOMO
#              2: nom de l base de developpement  ex : DBIPDBIP
#              3: nom du premier label
#              4: nom du deuxième label
#
#   ATTENTION le premier label doit etre plus récent que le deuxième label pour ramener toutes les versions modifiées
#
##################################################################################

ENV=$1
DB_NAME=$2
LABEL1=$3
LABEL2=$4

if test $# -ne 4; then
	echo
	echo "Le script nécessite 4 paramètres"
	echo "  1 : environnement de livraison : PROD / HOMO"
	echo "  2 : SSID Base : Nom de la base où l'on récupère la table des messages"
	echo "  3 : nom du premier label clearcase"
	echo "  4 : nom du deuxième label clearcase"
	echo "ATTENTION le premier label doit etre plus récent que le deuxième label pour ramener toutes les versions modifiées"
	exit 1
fi

ENV_DATE=$ENV"_"$(date +"%d%m%Y")
DB_USER=bip
DB_PASSWD=bip
PROJET_HOME=/applis/bipd/livraison
MESSAGE_FILE=message2load.sql
CREATE_MESSAGE_FILE=compil/create_message2load.sql
LISTE=/applis/bipd/livraison/liste_fichier.lst
COMP_INV_OBJ=compilInvalidPackage.sql
BATCH2COMPIL_FILE=batch2compil.sql
COMP_PACKAGE_FILE=compilInvalidPackage.sql
COMPIL_BATCH=compilBatch.sh
if  [ ${ENV} = "PROD" ]
then
	BASE_LIVR=PBIPPBIP
	PWD_LIVR=C8bIx96DZBHX
	REMOTE_HOME_BATCH2LOAD=/batch/bipp/applis
else
	BASE_LIVR=HBIPFBIP
	PWD_LIVR=bip
	REMOTE_HOME_BATCH2LOAD=/batch/bipf/applis
fi
LIVR_FILE=/applis/bipd/livraison/livraison_${ENV}.sh


#creation des répertoires

mkdir -p $PROJET_HOME/$ENV_DATE/oracle/batch/sql
mkdir -p $PROJET_HOME/$ENV_DATE/oracle/batch/shell
mkdir -p $PROJET_HOME/$ENV_DATE/oracle/batch/load
mkdir -p $PROJET_HOME/$ENV_DATE/oracle/batch/sql
mkdir -p $PROJET_HOME/$ENV_DATE/oracle/batch/bouclage
mkdir -p $PROJET_HOME/$ENV_DATE/oracle/bin
mkdir -p $PROJET_HOME/$ENV_DATE/oracle/RBip
mkdir -p $PROJET_HOME/$ENV_DATE/oracle/source/plsql/tp
mkdir -p $PROJET_HOME/$ENV_DATE/oracle/source/plsql/reports
mkdir -p $PROJET_HOME/$ENV_DATE/oracle/source/plsql/isac
mkdir -p $PROJET_HOME/$ENV_DATE/oracle/source/plsql/extract
mkdir -p $PROJET_HOME/$ENV_DATE/oracle/source/plsql/commun
mkdir -p $PROJET_HOME/$ENV_DATE/weblogic


#********************************************************************************************************
#etape 1 Creation du fichier des messages

echo "Creation du fichier des messages"


# on crée un fichier contenant tous les enregistrements de la table MESSAGE à charger sur la base cible
#
sqlplus -s $DB_USER/$DB_PASSWD@$DB_NAME <<!
	@$HOME_VIEW/$CREATE_MESSAGE_FILE
!

mv $PROJET_HOME/$MESSAGE_FILE $PROJET_HOME/$MESSAGE_FILE.bak
# suppession de tous les blanc en fin de ligne mis par sqlplus
echo "    Suppression des blancs"
sed -e '1,$s/ *$//' $PROJET_HOME/$MESSAGE_FILE.bak > $PROJET_HOME/$MESSAGE_FILE
mv $PROJET_HOME/$MESSAGE_FILE $PROJET_HOME/$MESSAGE_FILE.bak
# suppression des lignes vides pour éviter d'avoir 2 retour chariot de suite dans un message (ex: msg id = 5014)
echo "    Suppression des lignes vides"
sed -e '/^$/d' $PROJET_HOME/$MESSAGE_FILE.bak > $PROJET_HOME/$MESSAGE_FILE
mv $PROJET_HOME/$MESSAGE_FILE $PROJET_HOME/$ENV_DATE/oracle/bin/$MESSAGE_FILE
rm -r -f $PROJET_HOME/$MESSAGE_FILE.bak


# on se position dans le repertoire de la vue
cd $HOME_VIEW

# on liste toutes les fichiers modifié entre 2 labels
var="@"
cleartool  find . -version 'lbtype('${LABEL1}') && !lbtype('${LABEL2}')' -type f -print | \
	awk '{if (substr($0,1,2)=="./") print substr($0,3,length($0)-2) }'  | cut -f1 -d"@"  | grep -v "lost+found"  | grep -v "bin"  | grep -v "compil"> $LISTE 


# on creer ler repertoire si'il y a des reports, des tableaux ou des shell weblogic
if [ `grep -c ".rdf" $LISTE` -gt 0 ] 
then
	mkdir -p $PROJET_HOME/$ENV_DATE/weblogic/bip_wl9/data/reports
fi
if [ `grep -c ".xls" $LISTE` -gt 0 ]
then
	mkdir -p $PROJET_HOME/$ENV_DATE/weblogic/bip_wl9/data/tableau
fi
	if [ `grep -c "intranet/batch/shell" $LISTE` -gt 0 ]
then
	mkdir -p $PROJET_HOME/$ENV_DATE/weblogic/batch/shell
fi


#début du fichier compilant les packages
echo "spool compilBatch.log" >> $PROJET_HOME/${ENV_DATE}/oracle/bin/$BATCH2COMPIL_FILE
echo " " >> $PROJET_HOME/${ENV_DATE}/oracle/bin/$BATCH2COMPIL_FILE
echo "/***  Chargement de la table des messages  ***/" >>$PROJET_HOME/${ENV_DATE}/oracle/bin/$BATCH2COMPIL_FILE
echo "@$REMOTE_HOME_BATCH2LOAD/bin/$MESSAGE_FILE" >> $PROJET_HOME/${ENV_DATE}/oracle/bin/$BATCH2COMPIL_FILE
echo " " >> $PROJET_HOME/${ENV_DATE}/oracle/bin/$BATCH2COMPIL_FILE


# pour chaqie fichier de la liste on le copie dans le repertoire  pour permettre la livraison
for fichier in $(cat $LISTE | sed s#intranet/reports/#@#g | sed s#intranet/tableau/#@#g | sed s#intranet/batch/shell/#@#g |cut -f2 -d@ )
	do
		
	echo $fichier 
			case $fichier in
	        	*.rdf) 	cp ${HOME_VIEW}/intranet/reports/${fichier} ${PROJET_HOME}/${ENV_DATE}/weblogic/bip_wl9/data/reports/${fichier}
							chmod 664 ${PROJET_HOME}/${ENV_DATE}/weblogic/bip_wl9/data/reports/${fichier};;
				*.xls) 	cp ${HOME_VIEW}/intranet/tableau/${fichier} ${PROJET_HOME}/${ENV_DATE}/weblogic/bip_wl9/data/tableau/${fichier}
							chmod 644 ${PROJET_HOME}/${ENV_DATE}/weblogic/bip_wl9/data/tableau/${fichier};;
			WL*.sh) 	cp ${HOME_VIEW}/intranet/batch/shell/${fichier} ${PROJET_HOME}/${ENV_DATE}/weblogic/batch/shell/${fichier} 
							chmod 775 ${PROJET_HOME}/${ENV_DATE}/weblogic/batch/shell/${fichier} ;;
				 #on crée un fichier de lancement automatique des batch
				*.sql) 	cp $HOME_VIEW/$fichier $PROJET_HOME/$ENV_DATE/oracle/$fichier
							echo "@$REMOTE_HOME_BATCH2LOAD/$fichier" >> $PROJET_HOME/${ENV_DATE}/oracle/bin/$BATCH2COMPIL_FILE;;
				*.sh) 	cp $HOME_VIEW/$fichier $PROJET_HOME/$ENV_DATE/oracle/$fichier
							chmod 775 $PROJET_HOME/$ENV_DATE/oracle/$fichier;;
			    *.ctl)    cp $HOME_VIEW/$fichier $PROJET_HOME/$ENV_DATE/oracle/$fichier
							chmod 775 $PROJET_HOME/$ENV_DATE/oracle/$fichier;;
				*.par)    cp $HOME_VIEW/$fichier $PROJET_HOME/$ENV_DATE/oracle/$fichier
							chmod 775 $PROJET_HOME/$ENV_DATE/oracle/$fichier;;
							
                               
	esac
	
done

# copie du script pour compiler les packages invalide
cp ${HOME_VIEW}/compil/${COMP_INV_OBJ} ${PROJET_HOME}/${ENV_DATE}/oracle/bin/${COMP_INV_OBJ} 

#creation du fichier compilBatch.sh
echo "#! /bin/ksh" >> $PROJET_HOME/${ENV_DATE}/oracle/bin/${COMPIL_BATCH}
echo "BASE="${BASE_LIVR}  >> $PROJET_HOME/${ENV_DATE}/oracle/bin/${COMPIL_BATCH}
echo "PASSWD="${PWD_LIVR}  >> $PROJET_HOME/${ENV_DATE}/oracle/bin/${COMPIL_BATCH}
echo "BATCH2COMPIL_FILE"=${BATCH2COMPIL_FILE} >> $PROJET_HOME/${ENV_DATE}/oracle/bin/${COMPIL_BATCH}
echo "COMP_PACKAGE_FILE="${COMP_PACKAGE_FILE} >> $PROJET_HOME/${ENV_DATE}/oracle/bin/${COMPIL_BATCH}
echo "sqlplus $DB_USER/${PWD_LIVR}@${BASE_LIVR} @$BATCH2COMPIL_FILE" >> $PROJET_HOME/${ENV_DATE}/oracle/bin/${COMPIL_BATCH}
echo "sqlplus $DB_USER/${PWD_LIVR}@${BASE_LIVR} @$COMP_PACKAGE_FILE" >> $PROJET_HOME/${ENV_DATE}/oracle/bin/${COMPIL_BATCH}

#On compresse les deux répertoires créés, oracle et weblogic
cd $PROJET_HOME/$ENV_DATE/oracle
export $ENV_DATE

exit 0;
