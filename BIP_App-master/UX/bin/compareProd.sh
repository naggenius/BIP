#1) lister les fichiers versionnes
# BAA le 26/02/2007

# fichier où sont listés les batch SQL à compiler
PROJET_HOME=/projet/bip
BATCH2COMPIL_FILE=batch2compil.sql
COMPIL_BATCH=bin/compilBatch.sh
MESSAGE_FILE=bin/message2load.sql
CREATE_MESSAGE_FILE=compil/create_message2load.sql
COMP_INV_OBJ=compilInvalidPackage.sql
if test $# -ne 1; then
	echo
	echo "Usage : $0 [base]"
	echo "  Il manque l'environnement et /ou la Base de données"
	echo "  Base : Nom de la base où l'on récupère la table des messages"
	echo "  Exemple : $0 BIPL2"
	echo "            $0 BIPWLRE7"
	echo
	exit 1
fi


DB_NAME=$1
DB_USER=bip
DB_PASSWD=bip


# Pour tous les fichiers Batch (SQL) se trouvant sur l'Production

#PROD
REMOTE_HOST_BATCH_PROD=192.16.238.78
REMOTE_USER_BATCH_PROD=pbipbftp
REMOTE_PWD_BATCH_PROD=jR3AY69e
REMOTE_HOME_BATCH_PROD=
REMOTE_HOME_BATCH2LOAD_PROD=/batch/bipp/applis
REMOTE_HOME_BATCH3LOAD_PROD=/applis/livra

# Pour tous les fichiers intranet (report,shell,tableau Excel) 

#PROD
REMOTE_HOST_INTRA_PROD=bip.it.socgen
REMOTE_USER_INTRA_PROD=ftpbip9
REMOTE_PWD_INTRA_PROD=dD73_bA79
REMOTE_HOME_INTRA_PROD=/bip_wl9/data/reports/
REMOTE_HOME_INTRA2_PROD=/bip_wl9/data/tableau/



# Serveur de livraison pour les reports
#REMOTE_HOST_LIVRA=192.128.162.203
REMOTE_HOST_LIVRA=192.129.5.203
REMOTE_USER_LIVRA=livftp
REMOTE_PWD_LIVRA=livftp
REMOTE_DEST_LIVRA=/BIP/PROD_$(date +"%Y%m%d")_reports
REMOTE_DEST_LIVRA2=/BIP/PROD_$(date +"%Y%m%d")_tableau
REMOTE_DEST_LIVRA3=/BIP/PROD

DIFF_FILE_BATCH=/projet/bip/diff_batch_PROD.lst
DIFF_FILE_INTRA=/projet/bip/diff_intra_PROD.lst
DIFF_FILE_INTRA2=/projet/bip/diff_intra_e_PROD.lst
DIFF_NOTEXIST_FILE_BATCH=/projet/bip/diff_notexist_batch_PROD.lst
DIFF_NOTEXIST_FILE_INTRA=/projet/bip/diff_notexist_intra_PROD.lst
DIFF_NOTEXIST_FILE_INTRA2=/projet/bip/diff_notexist_intra_e_PROD.lst
DIFF_LOG=/projet/bip/diff_PROD.log
SCRIPT_FTP=/projet/bip/script_ftp_PROD.sh
SFTP_BATCH=/projet/bip/sftp_batch.file
LISTE=/projet/bip/liste_PROD.lst
LIVR_FILE=/projet/bip/livraison_PROD.sh
LIVR_FILE_PROD=/projet/bip/livraison_Production.sh
REP_DIFF=/projet/bip/diff_work_PROD




#********************************************************************************************************
#etape 1 Creation du fichier des messages

echo "Creation du fichier des messages"


# on crée un fichier contenant tous les enregistrements de la table MESSAGE à charger sur la base cible
#
sqlplus -s $DB_USER/$DB_PASSWD@$DB_NAME <<!
	@$APP_HOME/$CREATE_MESSAGE_FILE
!

mv $PROJET_HOME/$MESSAGE_FILE $PROJET_HOME/$MESSAGE_FILE.bak
# suppession de tous les blanc en fin de ligne mis par sqlplus
echo "    Suppression des blancs"
sed -e '1,$s/ *$//' $PROJET_HOME/$MESSAGE_FILE.bak > $PROJET_HOME/$MESSAGE_FILE
mv $PROJET_HOME/$MESSAGE_FILE $PROJET_HOME/$MESSAGE_FILE.bak
# suppression des lignes vides pour éviter d'avoir 2 retour chariot de suite dans un message (ex: msg id = 5014)
echo "    Suppression des lignes vides"
sed -e '/^$/d' $PROJET_HOME/$MESSAGE_FILE.bak > $PROJET_HOME/$MESSAGE_FILE
rm -f $PROJET_HOME/$MESSAGE_FILE.bak 2>/dev/null
echo ""


#********************************************************************************************************
# etape 2 Création de l'arborescence du répertoire de comparaison $REP_DIFF

if [ 1 -ne 0 ]
then
        /bin/rm -rf $REP_DIFF 2> /dev/null

        for REP in "
                $REP_DIFF
                $REP_DIFF/source
                $REP_DIFF/source/plsql
                $REP_DIFF/source/plsql/extract
                $REP_DIFF/source/plsql/tp
                $REP_DIFF/source/plsql/commun
                $REP_DIFF/source/plsql/reports
                $REP_DIFF/source/plsql/isac
                $REP_DIFF/batch
                $REP_DIFF/batch/data
                $REP_DIFF/batch/log
                $REP_DIFF/batch/rapport
                $REP_DIFF/batch/reports
                $REP_DIFF/batch/shell
                $REP_DIFF/batch/shell/MANNUEL
                $REP_DIFF/batch/sql
                $REP_DIFF/batch/load
                $REP_DIFF/batch/bouclage
                $REP_DIFF/batch/gdc
                $REP_DIFF/batch/oscar
                $REP_DIFF/shell
                $REP_DIFF/oracle
                $REP_DIFF/oracle/data
                $REP_DIFF/oracle/data/menu
                $REP_DIFF/oracle/struct
                $REP_DIFF/oracle/struct/BO
                $REP_DIFF/oracle/export_user
                $REP_DIFF/biphist
                $REP_DIFF/biphist/extraction
                $REP_DIFF/biphist/historique
                $REP_DIFF/intranet
                $REP_DIFF/intranet/reports
                $REP_DIFF/intranet/tableau
				$REP_DIFF/Rbip"
        do
                mkdir $REP
        done
		
fi

echo $SCRIPT_FTP
cd $APP_HOME


#********************************************************************************************************
#Etape 3 initialier et vider les fichiers suivants

>$LIVR_FILE
>$DIFF_FILE_BATCH
>$DIFF_FILE_INTRA
>$DIFF_FILE_INTRA2
>$DIFF_LOG
>$DIFF_NOTEXIST_FILE_BATCH
>$DIFF_NOTEXIST_FILE_INTRA
>$DIFF_NOTEXIST_FILE_INTRA2
>$PROJET_HOME/$BATCH2COMPIL_FILE
>$LIVR_FILE_PROD
>$SCRIPT_FTP
#La liste des répertoire a recuperer de la PROD
echo "			source/plsql/extract
                source/plsql/tp
                source/plsql/commun
                source/plsql/reports
                source/plsql/isac
                batch/shell
                batch/shell/MANNUEL
                batch/sql
                batch/load
                batch/bouclage
                batch/gdc
                batch/oscar" >$LISTE
echo $LISTE
#********************************************************************************************************
# Etape 4 on récupère les fichiers du serveur de Production afin de les comparer ensuite à ceux du serveur de DEV
echo "dir" > $SFTP_BATCH
for fichier in $(cat $LISTE)
do
        echo "get $fichier/*.* $REP_DIFF/$fichier" >> $SFTP_BATCH
done


echo "sftp -v -b $SFTP_BATCH $REMOTE_USER_BATCH_PROD@$REMOTE_HOST_BATCH_PROD" >> $SCRIPT_FTP
echo "exit" >> $SCRIPT_FTP

ksh $SCRIPT_FTP

#********************************************************************************************************
# Etpae 5 on fait les diff pour les fichiers batch et on supprime les fichers non modifier
cd $APP_HOME
cleartool find . -nxname -type f -print | \
        awk '{if (substr($0,1,2)=="./") print substr($0,3,length($0)-2) }' > $LISTE


		
cd $REP_DIFF		
		
for fichier in $(	cat $LISTE | \
					grep -v '^bin/' | \
					grep -v '^bipdata/' | \
					grep -v '^etc/' | \
					grep -v '^compil/' | \
					grep -v '^intranet/' | \
                              grep -v '^oracle/scripts/' | \
					grep -v '^lost+found/' | \
					grep -v 'export_PROD.sh' | \
					grep -v 'menu.csv')
do
        if [ ! -a $REP_DIFF/$fichier ]
        then
                echo "$fichier n'existe pas sur $REMOTE_HOST_BATCH_PROD"
                echo "$fichier n'existe pas sur $REMOTE_HOST_BATCH_PROD" >> $DIFF_LOG
                echo $fichier >> $DIFF_NOTEXIST_FILE_BATCH
        else
                echo "diff de $fichier" >> $DIFF_LOG
                diff $APP_HOME/$fichier $REP_DIFF/$fichier >> $DIFF_LOG 2>&1
                res=$?
                if [ $res -ne 0 ]
                then
                        echo $fichier >> $DIFF_FILE_BATCH
                else
                        echo "$fichier ok - on le delete du rep de travail ..."
                        #echo "$fichier ok - on le delete du rep de travail ..." >> $DIFF_LOG
                        /bin/rm -f $REP_DIFF/$fichier
                fi
        fi

done



#********************************************************************************************************
# Etape 6 Création du fichier batch2compil.sql qui contiendra les packages à compiler



#début du fichier compilant les packages
echo "spool compilBatch.log" >> $PROJET_HOME/$BATCH2COMPIL_FILE
echo " " >> $PROJET_HOME/$BATCH2COMPIL_FILE
echo "/***  Chargement de la table des messages  ***/" >> $PROJET_HOME/$BATCH2COMPIL_FILE
echo "@$REMOTE_HOME_BATCH2LOAD_PROD/$MESSAGE_FILE" >> $PROJET_HOME/$BATCH2COMPIL_FILE
echo " " >> $PROJET_HOME/$BATCH2COMPIL_FILE



#***************************************************************************************************************************
# Etape 7 a- création du fichier livraison_PROD.sh qui permettra de charger les fichiers (*.sql,*.sh,*.rdf,*.xls etc) 
#            à partir de l'environnement de développement vers l'environnement de livraison 
#         b- création du fichier livraison_Production.sh qui permettra de charger les fichiers (*.sql,*.sh,*.rdf,*.xls etc) 
#            à partir de l'environnement de livraison vers l'environnement de Production
#  les deux fichiers sont renseignés en même temps





#pour la livraison à partir de l'environnement de développement
echo "ftp -vn <<! > /dev/null" >> $LIVR_FILE
echo "open $REMOTE_HOST_LIVRA" >> $LIVR_FILE
echo "user $REMOTE_USER_LIVRA $REMOTE_PWD_LIVRA" >> $LIVR_FILE
echo "ascii" >> $LIVR_FILE

#pour la livraison à partir de l'environnement de livraison
echo "ftp -vn <<! > /dev/null" > $LIVR_FILE_PROD
echo "open $REMOTE_HOST_BATCH_HOMO" >> $LIVR_FILE_PROD
echo "user USER_FTP PWD_FTP" >> $LIVR_FILE_PROD
echo "ascii" >> $LIVR_FILE_PROD



#***************************************************************************************************************************
#Etape 8 remplir les fichiers livraison_PROD.sh et livraison_Production.sh
#        et aussi remplir le fichier batch2compil.sql qui paremettra par la suite de compiler les packages livrés



# s'il y a des fichiers différents ou qui n'existe pas, on crée un fichier de transfert.
if [ $(($(wc -l < $DIFF_FILE_BATCH)+$(wc -l < $DIFF_NOTEXIST_FILE_BATCH))) -gt 0 ]
then
	
	for fichier in $(cat $DIFF_FILE_BATCH) $(cat $DIFF_NOTEXIST_FILE_BATCH)
	do
	        
              echo "put $APP_HOME/$fichier $REMOTE_DEST_LIVRA3/$fichier" >> $LIVR_FILE
              #on renomme le fichier avant afin de l'ecraser
              echo "rename $REMOTE_HOME_BATCH2LOAD_PROD/$fichier $REMOTE_HOME_BATCH2LOAD_PROD/$fichier$(date +"%d%m%Y")" >> $LIVR_FILE_PROD
              echo "put REMOTE_HOME_BATCH3LOAD_PROD/$fichier $REMOTE_HOME_BATCH2LOAD_PROD/$fichier" >> $LIVR_FILE_PROD

	        case $fichier in
	        	*.sh) echo "quote site chmod +x $REMOTE_HOME_BATCH_PROD/$fichier" >> $LIVR_FILE
                        echo "quote site chmod +x $REMOTE_DEST_LIVRA3/$fichier" >> $LIVR_FILE_PROD;;
				# on crée un fichier de lancement automatique des batch
				*.sql) echo "@$REMOTE_HOME_BATCH2LOAD_PROD/$fichier" >> $PROJET_HOME/$BATCH2COMPIL_FILE;;
                               
		  esac
	done

else
	echo "# Pas de fichiers BATCH à livrer" >> $LIVR_FILE
fi

# fin du fichier compilant les packages
echo " " >> $PROJET_HOME/$BATCH2COMPIL_FILE
echo "put $PROJET_HOME/$BATCH2COMPIL_FILE $REMOTE_DEST_LIVRA3/bin/$BATCH2COMPIL_FILE" >> $LIVR_FILE
# transfert du fichier de chargement de la table MESSAGE
echo "put $PROJET_HOME/$MESSAGE_FILE $REMOTE_DEST_LIVRA3/$MESSAGE_FILE" >> $LIVR_FILE
# le fichier suivant permet de lancer le fichier SQL contenant les batchs à compiler
echo "put $APP_HOME/$COMPIL_BATCH $REMOTE_DEST_LIVRA3/$COMPIL_BATCH" >> $LIVR_FILE
echo "quote site chmod +x $REMOTE_HOME_BATCH_PROD/$COMPIL_BATCH" >> $LIVR_FILE
# le fichier compilant les objets invalides
echo "put $APP_HOME/compil/$COMP_INV_OBJ $REMOTE_DEST_LIVRA3/bin/$COMP_INV_OBJ" >> $LIVR_FILE

# on ferme le fichier de transfert FTP
echo "!" >> $LIVR_FILE


#********************************************************************************************************
#Etape 9 Livraisons des états reports *.rdf

echo "On traite les fichier de l'intranet"
#On récupére les fichiers d'Production reports

cd $REP_DIFF/intranet/reports
echo "ftp -vn <<! > /dev/null" > $SCRIPT_FTP
echo "open $REMOTE_HOST_INTRA_PROD" >> $SCRIPT_FTP
echo "user $REMOTE_USER_INTRA_PROD $REMOTE_PWD_INTRA_PROD" >> $SCRIPT_FTP
echo "binary" >> $SCRIPT_FTP
echo "cd $REMOTE_HOME_INTRA_PROD" >> $SCRIPT_FTP
echo "mget *.rdf" >> $SCRIPT_FTP
echo "!" >> $SCRIPT_FTP

ksh $SCRIPT_FTP

cd $APP_HOME/intranet/reports
cleartool find . -name "*.rdf" -nxname -type f -print | \
	awk '{if (substr($0,1,2)=="./") print substr($0,3,length($0)-2) }' > $LISTE

for fichier in $(cat $LISTE)
do
	fichier_long="intranet/reports/"$fichier
	if [ ! -a $REP_DIFF/$fichier_long ]
    then
            echo "$fichier_long n'existe pas sur $REMOTE_HOST_INTRA_PROD"
            echo "$fichier_long n'existe pas sur $REMOTE_HOST_INTRA_PROD" >> $DIFF_LOG
            echo $fichier >> $DIFF_NOTEXIST_FILE_INTRA
    else
            echo "diff de $fichier" >> $DIFF_LOG
            diff $APP_HOME/$fichier_long $REP_DIFF/$fichier_long >> $DIFF_LOG 2>&1
            res=$?
            if [ $res -ne 0 ]
            then
                    echo $fichier >> $DIFF_FILE_INTRA
            else
                    echo "$fichier ok - on le delete du rep de travail ..."
                    #echo "$fichier ok - on le delete du rep de travail ..." >> $DIFF_LOG
                    /bin/rm -f $REP_DIFF/$fichier_long
            fi
    fi
done

if [ $(($(wc -l < $DIFF_FILE_INTRA)+$(wc -l < $DIFF_NOTEXIST_FILE_INTRA))) -gt 0 ]
then
	echo "" >> $LIVR_FILE
	echo "ftp -vn <<! > /dev/null" >> $LIVR_FILE
	echo "open $REMOTE_HOST_LIVRA" >> $LIVR_FILE
	echo "user $REMOTE_USER_LIVRA $REMOTE_PWD_LIVRA" >> $LIVR_FILE
	echo "mkdir $REMOTE_DEST_LIVRA" >> $LIVR_FILE
	echo "binary" >> $LIVR_FILE
	
	for fichier in $(cat $DIFF_FILE_INTRA) $(cat $DIFF_NOTEXIST_FILE_INTRA)
	do
	    echo "put $APP_HOME/intranet/reports/$fichier $REMOTE_DEST_LIVRA/$fichier" >> $LIVR_FILE
	done
	echo "!" >> $LIVR_FILE
else
	echo "# Pas de fichiers INTRA REPORTS à livrer" >> $LIVR_FILE
fi





#On récupére les fichiers de l'Production Tableau Excel

cd $REP_DIFF/intranet/tableau
echo "ftp -vn <<! > /dev/null" > $SCRIPT_FTP
echo "open $REMOTE_HOST_INTRA_PROD" >> $SCRIPT_FTP
echo "user $REMOTE_USER_INTRA_PROD $REMOTE_PWD_INTRA_PROD" >> $SCRIPT_FTP
echo "binary" >> $SCRIPT_FTP
echo "cd $REMOTE_HOME_INTRA2_PROD" >> $SCRIPT_FTP
echo "mget *.xls" >> $SCRIPT_FTP

ksh $SCRIPT_FTP

cd $APP_HOME/intranet/tableau
cleartool find . -name "*.xls" -nxname -type f -print | \
	awk '{if (substr($0,1,2)=="./") print substr($0,3,length($0)-2) }' > $LISTE

for fichier in $(cat $LISTE)
do
	fichier_long="intranet/tableau/"$fichier
	if [ ! -a $REP_DIFF/$fichier_long ]
    then
            echo "$fichier_long n'existe pas sur $REMOTE_HOST_INTRA_PROD"
            echo "$fichier_long n'existe pas sur $REMOTE_HOST_INTRA_PROD" >> $DIFF_LOG
            echo $fichier >> $DIFF_NOTEXIST_FILE_INTRA2
    else
            echo "diff de $fichier" >> $DIFF_LOG
            diff $APP_HOME/$fichier_long $REP_DIFF/$fichier_long >> $DIFF_LOG 2>&1
            res=$?
            if [ $res -ne 0 ]
            then
                    echo $fichier >> $DIFF_FILE_INTRA2
            else
                    echo "$fichier ok - on le delete du rep de travail ..."
                    #echo "$fichier ok - on le delete du rep de travail ..." >> $DIFF_LOG
                    /bin/rm -f $REP_DIFF/$fichier_long
            fi
    fi
done


if [ $(($(wc -l < $DIFF_FILE_INTRA2)+$(wc -l < $DIFF_NOTEXIST_FILE_INTRA2))) -gt 0 ]
then
	echo "" >> $LIVR_FILE
	echo "ftp -vn <<! > /dev/null" >> $LIVR_FILE
	echo "open $REMOTE_HOST_LIVRA" >> $LIVR_FILE
	echo "user $REMOTE_USER_LIVRA $REMOTE_PWD_LIVRA" >> $LIVR_FILE
	echo "mkdir $REMOTE_DEST_LIVRA2" >> $LIVR_FILE
	echo "binary" >> $LIVR_FILE
	
	for fichier in $(cat $DIFF_FILE_INTRA2) $(cat $DIFF_NOTEXIST_FILE_INTRA2)
	do
	    echo "put $APP_HOME/intranet/tableau/$fichier $REMOTE_DEST_LIVRA2/$fichier" >> $LIVR_FILE
	done
	echo "!" >> $LIVR_FILE
else
	echo "# Pas de fichiers INTRA TABLEAU (Excel) à livrer" >> $LIVR_FILE
fi


################################################################################################"""
#livrer les fichiers de compilations et de livraisons


# connection au serveur
#echo "" >> $LIVR_FILE
#echo "ftp -vn <<! > /dev/null" >> $LIVR_FILE
#echo "open $REMOTE_HOST_LIVRA" >> $LIVR_FILE
#echo "user $REMOTE_USER_LIVRA $REMOTE_PWD_LIVRA" >> $LIVR_FILE
#echo "ascii" >> $LIVR_FILE
#echo "put $APP_HOME/$BATCH2COMPIL_FILE $REMOTE_DEST_LIVRA3/bin/$BATCH2COMPIL_FILE" >> $LIVR_FILE
#echo "put $APP_HOME/$MESSAGE_FILE $REMOTE_DEST_LIVRA3/bin/$MESSAGE_FILE" >> $LIVR_FILE
#echo "put $APP_HOME/compil/$COMP_INV_OBJ $REMOTE_DEST_LIVRA3/bin/$COMP_INV_OBJ" >> $LIVR_FILE
#echo "put $APP_HOME/$COMPIL_BATCH $REMOTE_DEST_LIVRA3/$COMPIL_BATCH" >> $LIVR_FILE
#echo "put $LIVR_FILE_PROD $REMOTE_DEST_LIVRA3/bin/livraison_Production.sh" >> $LIVR_FILE
#echo "quote site chmod +x $REMOTE_DEST_LIVRA3/bin/livraison_Production.sh" >> $LIVR_FILE
#echo "!" >> $LIVR_FILE



echo "put $REMOTE_HOME_BATCH3LOAD_PROD/$BATCH2COMPIL_FILE $REMOTE_HOME_BATCH2LOAD_PROD/bin/$BATCH2COMPIL_FILE" >> $LIVR_FILE_PROD
echo "put $REMOTE_HOME_BATCH3LOAD_PROD/$MESSAGE_FILE $REMOTE_HOME_BATCH2LOAD_PROD/bin/$MESSAGE_FILE" >> $LIVR_FILE_PROD
echo "put $REMOTE_HOME_BATCH3LOAD_PROD/compil/$COMP_INV_OBJ $REMOTE_HOME_BATCH2LOAD_PROD/bin/$COMP_INV_OBJ" >> $LIVR_FILE_PROD
echo "put $REMOTE_HOME_BATCH3LOAD_PROD/$COMPIL_BATCH $REMOTE_HOME_BATCH2LOAD_PROD/$COMPIL_BATCH" >> $LIVR_FILE_PROD
echo "quote site chmod +x $REMOTE_HOME_BATCH2LOAD_PROD/$COMPIL_BATCH" >> $LIVR_FILE_PROD
echo "!" >> $LIVR_FILE_PROD


rm $LIVR_FILE_PROD

##############################################################

echo "diff_batch.lst		: $DIFF_FILE_BATCH (liste des fichiers en diff (batch)"
echo "diff_intra.lst		: $DIFF_FILE_INTRA (liste des fichiers en diff (intra)"
echo "diff_intra_e.lst		: $DIFF_FILE_INTRA2 (liste des fichiers en diff (intra/tableau Excel)"
echo "diff.log				: $DIFF_LOG (resultat des diff (batch et intra)"
echo "diff_notexist_batch.lst	: $DIFF_NOTEXIST_FILE_BATCH (liste des fichiers manquant (batch)"
echo "diff_notexist_intra.lst	: $DIFF_NOTEXIST_FILE_INTRA (liste des fichiers manquant (intra)"
echo "diff_notexist_intra_e.lst	: $DIFF_NOTEXIST_FILE_INTRA2 (liste des fichiers manquant (intra/tableau Excel)"
echo ""
echo "Generation du script de livraison"
echo "	Ce script contient la liste des fichiers differants et manquants"
echo "	Ils vont etre livre (ftp) sur la PROD"

echo ""
echo " Bien RETIRER les fichiers qui ne doivent pas etres livres !!!!!!"
echo "Nom du script : $LIVR_FILE"
echo ""


