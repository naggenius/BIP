
# version evoluee parametree
# = lancement de la commande avec 2 parametres 
# precaution : avant de lancer bien mettre le bon ORACLE_SID
#		2) vider la base d'accueil, il s'agit d'un import full
#  Dans ce shell userid est  bidon donc a changer. Par contre le user 
# qui sera donner devra avoir les privileges systeme necessaire c.a.d. le 
# role IMP_FULL_DATABASE
#
# lancement de la commande :
#
# imp_base_compresse.sh nom_fic_exp_compresse( sans le .Z) localisation_fic
#	exemple imp_base_compresse.sh 1212-bipprod.dmp /export_bases/bipprod
#
VAR1="${2}/${1}"
VAR11="${VAR1}.Z"
VAR2="log_imp_${1}.log"
VAR3="fifo_import_base$$"
#echo "VAR1 : $VAR1"
#echo "VAR11 : $VAR11"
#echo "VAR2 : $VAR2"
#echo "VAR3 : $VAR3"
mkfifo ${VAR3}
dd if=${VAR11} ibs=16384k \
| uncompress -c \
| dd of=${VAR3} obs=16384k &
imp     /                                       \
BUFFER=16384000                                 \
USERID=BIP/BIP@BIPR				\
FROMUSER=bip					\
TOUSER=bip					\
FILE=${VAR3}                                    \
ROWS=Y						\
INDEXES=Y					\
COMMIT=Y					\
GRANTS=Y					\
FULL=N						\
LOG=${VAR2}
rm -f ${VAR3}

