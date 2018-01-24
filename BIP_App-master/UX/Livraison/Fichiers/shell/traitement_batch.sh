#!/bin/ksh
#_______________________________________________________________________________
# Application Base d'Informations Projets
# Nom du fichier : traitement_batch.sh
# Objet : Shell Batch (traitement_batch)
# Lancé régulièrement par Ctrl/M, il va regarder dans la table TRAIT_BATCH tous les traitements
# dynamiquement programmé pour le jour actuel, puis il va exécuter les traitements dont l'heure de planification 
# est passée et dont le top_exec est à N. Une écriture du fichier d'entrée depuis le champ CLOB peut-être nécessaire
# pour certains traitements.
#_______________________________________________________________________________
# Creation : Christophe Martins 07/07/2011
# Modification :
# --------------
# Auteur  Date       Objet
# CMA     07/07/11   Version initiale
################################################################################
autoload $(ls $FPATH)

nombre=`sqlplus -s $CONNECT_STRING << !
	set heading off
	select count(*)
                from LISTE_SHELL b, trait_batch t
                 where b.id_shell = t.id_shell
                 and t.date_shell < SYSDATE
                 and TO_CHAR(t.date_shell,'DD/MM/YYYY') = TO_CHAR(sysdate,'DD/MM/YYYY')
                 and t.top_exec = 'N';
!`

if [ ${nombre} -ne 0 ]
then

LOG_TRAITEMENT=$DIR_BATCH_SHELL_LOG/$(date +"%Y%m%d_%HH%M").traitement_batch.log
export LOG_TRAITEMENT
logText "`basename $0` : fichier de trace : $LOG_TRAITEMENT"


logText "--------------------------------------------------------------------------------" > $LOG_TRAITEMENT
logText "-- $(date +"%Y%m%d %T") Debut de $0" >> $LOG_TRAITEMENT
logText "--------------------------------------------------------------------------------" >> $LOG_TRAITEMENT

logText "Appel de la liste des traitements à exécuter" >> $LOG_TRAITEMENT

param=`sqlplus -s $CONNECT_STRING << EOF > out.txt
	whenever sqlerror exit failure;
	set headsep off
	set heading off
	set linesize 2000
	set feedback off
	select t.id_trait_batch, b.id_shell, b.nom_shell, TO_CHAR(t.date_shell,'DD/MM/YYYY HH24:MI'), b.nom_fich
                from LISTE_SHELL b, trait_batch t
                 where b.id_shell = t.id_shell
                 and t.date_shell < SYSDATE
                 and TO_CHAR(t.date_shell,'DD/MM/YYYY') = TO_CHAR(sysdate,'DD/MM/YYYY')
                 and t.top_exec = 'N'
                order by t.date_shell;
EOF`


while read -r id_trait_batch id_shell nom_shell date heure nom_fichier
do
 if [[ $nom_fichier != "" ]] 
 then
	logText "Ecriture du fichier $nom_fichier pour le shell $nom_shell" >> $LOG_TRAITEMENT
	sqlplus -s $CONNECT_STRING <<! >> $LOG_TRAITEMENT 
        whenever sqlerror exit failure;
        !echo "execute pack_upload_fichier_batch.build_fichier_batch"
        execute pack_upload_fichier_batch.build_fichier_batch('$PL_DATA','$nom_fichier','$id_trait_batch');
!
 fi
 
 if [[ $id_shell != "" ]] 
 then
	logText "Exécution du shell $nom_shell" >> $LOG_TRAITEMENT
	$DIR_BATCH_SHELL/$nom_shell $id_trait_batch
	PLUS_EXIT=$?
	if [ $PLUS_EXIT -ne 0 ]
	then
		logText "Erreur dans l'exécution du shell $nom_shell" >> $LOG_TRAITEMENT
		logText "Update du top_exec du traitement $nom_shell" >> $LOG_TRAITEMENT	
	sqlplus -s $CONNECT_STRING << EOF >> $LOG_TRAITEMENT
	UPDATE TRAIT_BATCH SET TOP_ANO='O' WHERE ID_TRAIT_BATCH = $id_trait_batch;
EOF
	fi
	logText "Update du top_exec du traitement $nom_shell" >> $LOG_TRAITEMENT	
	sqlplus -s $CONNECT_STRING << EOF >> $LOG_TRAITEMENT
	UPDATE TRAIT_BATCH SET TOP_EXEC='O' WHERE ID_TRAIT_BATCH = $id_trait_batch;
EOF
 fi
# if [[ $nom_fichier =  "ligne_bip_maj_masse.csv" ]]
# then
#	if [[ -s $DIR_BATCH_DATA/$nom_fichier ]]
#	then
#		mv $DIR_BATCH_DATA/ligne_bip_maj_masse.csv $DIR_BATCH_DATA/$(date +"%Y%m%d_%HH%M").ligne_bip_maj_masse.csv
#	fi
# fi
 
 if [[ $nom_fichier = "ligne_bip_maj_masse.csv" || $nom_fichier = "transf_lien_tache.csv" ]]
 then
	if [[ -s $DIR_BATCH_DATA/$nom_fichier ]]
	then
		mv $DIR_BATCH_DATA/$nom_fichier $DIR_BATCH_DATA/$(date +"%Y%m%d_%HH%M").$nom_fichier
	fi
 fi
 
done < out.txt
rm out.txt

logText "Fin de $0" >> $LOG_TRAITEMENT
unset LOG_TRAITEMENT
fi
exit 0