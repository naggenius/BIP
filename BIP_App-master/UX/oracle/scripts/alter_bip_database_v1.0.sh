#!/bin/ksh

if [ $# = 2 ]
then
   OWNER=$1
   PASSW=$2
else
   echo "usage : $0 OWNER PASSW"
   exit 1
fi

sqlplus -S $OWNER/$PASSW << EOF

set define off
@@bip_cre_tbs.sql
@@bip_cre_tables.sql
@@bip_cre_pk.sql
@@bip_cre_fk.sql
@@bip_cre_index.sql
@@bip_cre_seq.sql
@@bip_packages.sql
@@bip_grants.sql


echo "Maintenant, il faut créer les synonymes publics"
@@bip_cre_syno.sql

EOF

