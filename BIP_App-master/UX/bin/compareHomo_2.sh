#1) lister les fichiers versionnes
REMOTE_HOST_BATCH=192.128.162.193
REMOTE_USER_BATCH=bipprod
REMOTE_PWD_BATCH=bipprod
REMOTE_HOME_BATCH=/datas/h2bip/applis

REMOTE_HOST_INTRA=192.128.162.203
REMOTE_USER_INTRA=livftp
REMOTE_PWD_INTRA=livftp
REMOTE_HOME_INTRA=/applis/h2bip/bipServer/reports/
REMOTE_DEST_INTRA=/applis/livra/BIP/HOMO_H2_$(date +"%Y%m%d")_reports

DIFF_FILE_BATCH=/projet/bip/diff_batch_HOMO_2.lst
DIFF_FILE_INTRA=/projet/bip/diff_intra_HOMO_2.lst
DIFF_NOTEXIST_FILE_BATCH=/projet/bip/diff_notexist_batch_HOMO_2.lst
DIFF_NOTEXIST_FILE_INTRA=/projet/bip/diff_notexist_intra_HOMO_2.lst
DIFF_LOG=/projet/bip/diff_HOMO_2.log
SCRIPT_FTP=/projet/bip/script_ftp_HOMO_2.sh
LISTE=/projet/bip/liste_HOMO_2.lst
LIVR_FILE=/projet/bip/livraison_HOMO_2.sh
REP_DIFF=/projet/bip/diff_work_HOMO_2

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
                $REP_DIFF/intranet/reports"
        do
                mkdir $REP
        done
fi

echo $LISTE
echo $SCRIPT_FTP
cd $APP_HOME

>$LIVR_FILE
>$DIFF_FILE_BATCH
>$DIFF_FILE_INTRA
>$DIFF_LOG
>$DIFF_NOTEXIST_FILE_BATCH
>$DIFF_NOTEXIST_FILE_INTRA

cleartool find . -nxname -type f -print | \
        awk '{if (substr($0,1,2)=="./") print substr($0,3,length($0)-2) }' > $LISTE

cd $REP_DIFF

echo "ftp -vn <<! > /dev/null" > $SCRIPT_FTP
echo "open $REMOTE_HOST_BATCH" >> $SCRIPT_FTP
echo "user $REMOTE_USER_BATCH $REMOTE_PWD_BATCH" >> $SCRIPT_FTP
echo "ascii" >> $SCRIPT_FTP
echo "cd $REMOTE_HOME_BATCH" >> $SCRIPT_FTP
echo "dir" >> $SCRIPT_FTP
for fichier in $(cat $LISTE)
do
        echo "get $fichier" >> $SCRIPT_FTP
done
echo "!" >> $SCRIPT_FTP

ksh $SCRIPT_FTP


# on fait les diff pour les fichiers batch
for fichier in $(	cat $LISTE | \
					grep -v '^bin/' | \
					grep -v '^bipdata/' | \
					grep -v '^etc/' | \
					grep -v '^compil/' | \
					grep -v '^intranet/' | \
					grep -v '^lost+found/' | \
					grep -v 'export_prod.sh' | \
					grep -v 'menu.csv')
do
        if [ ! -a $REP_DIFF/$fichier ]
        then
                echo "$fichier n'existe pas sur $REMOTE_HOST_BATCH"
                echo "$fichier n'existe pas sur $REMOTE_HOST_BATCH" >> $DIFF_LOG
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

if [ $(($(wc -l < $DIFF_FILE_BATCH)+$(wc -l < $DIFF_NOTEXIST_FILE_BATCH))) -gt 0 ]
then
	echo "ftp -vn <<! > /dev/null" >> $LIVR_FILE
	echo "open $REMOTE_HOST_BATCH" >> $LIVR_FILE
	echo "user $REMOTE_USER_BATCH $REMOTE_PWD_BATCH" >> $LIVR_FILE
	echo "ascii" >> $LIVR_FILE
	
	for fichier in $(cat $DIFF_FILE_BATCH) $(cat $DIFF_NOTEXIST_FILE_BATCH)
	do
	        echo "put $APP_HOME/$fichier $REMOTE_HOME_BATCH/$fichier" >> $LIVR_FILE
	done
	echo "!" >> $LIVR_FILE
else
	echo "# Pas de fichiers INTRA à livrer" >> $LIVR_FILE
fi

################################################################################
echo "On traite les fichier de l'intranet"
#Fichiers de l'intranet
cd $REP_DIFF/intranet/reports
echo "ftp -vn <<! > /dev/null" > $SCRIPT_FTP
echo "open $REMOTE_HOST_INTRA" >> $SCRIPT_FTP
echo "user $REMOTE_USER_INTRA $REMOTE_PWD_INTRA" >> $SCRIPT_FTP
echo "binary" >> $SCRIPT_FTP
echo "cd $REMOTE_HOME_INTRA" >> $SCRIPT_FTP
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
            echo "$fichier_long n'existe pas sur $REMOTE_HOST_INTRA"
            echo "$fichier_long n'existe pas sur $REMOTE_HOST_INTRA" >> $DIFF_LOG
            echo $fichier_long >> $DIFF_NOTEXIST_FILE_INTRA
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
	echo "open $REMOTE_HOST_INTRA" >> $LIVR_FILE
	echo "user $REMOTE_USER_INTRA $REMOTE_PWD_INTRA" >> $LIVR_FILE
	echo "mkdir $REMOTE_DEST_INTRA" >> $LIVR_FILE
	echo "binary" >> $LIVR_FILE
	
	for fichier in $(cat $DIFF_FILE_INTRA) $(cat $DIFF_NOTEXIST_FILE_INTRA)
	do
	    echo "put $APP_HOME/intranet/reports/$fichier $REMOTE_DEST_INTRA/$fichier" >> $LIVR_FILE
	done
	echo "!" >> $LIVR_FILE
else
	echo "# Pas de fichiers INTRA à livrer" >> $LIVR_FILE
fi

##############################################################

echo "diff_batch.lst		: $DIFF_FILE_BATCH (liste des fichiers en diff (batch)"
echo "diff_intra.lst		: $DIFF_FILE_INTRA (liste des fichiers en diff (intra)"
echo "diff.log				: $DIFF_LOG (resultat des diff (batch et intra)"
echo "diff_notexist_batch.lst	: $DIFF_NOTEXIST_FILE_BATCH (liste des fichiers manquant (batch)"
echo "diff_notexist_intra.lst	: $DIFF_NOTEXIST_FILE_INTRA (liste des fichiers manquant (intra)"
echo ""
echo "Generation du script de livraison"
echo "	Ce script contient la liste des fichiers differants et manquants"
echo "	Ils vont etre livre (ftp) sur la prod"

echo ""
echo " Bien RETIRER les fichiers qui ne doivent pas etres livres !!!!!!"
echo "Nom du script : $LIVR_FILE"
echo ""
