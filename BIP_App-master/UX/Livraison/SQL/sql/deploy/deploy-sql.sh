#!/bin/ksh

# This file must updated every time that an SQL script is added to the delivery

SCRIPT_DIR=$(dirname "$(readlink -f $0)")
echo "SCRIPT_DIR = ${SCRIPT_DIR}"
echo

# Load user env settings
. ~/.profile

#sqlplus $CONNECT_STRING @${SCRIPT_DIR}/1_HIER_TMP_TABLES_DDL.sql
#sqlplus $CONNECT_STRING @${SCRIPT_DIR}/1_NEW_ALTER_DDL.sql
sqlplus $CONNECT_STRING @${SCRIPT_DIR}/4_Insert_Hierarchy.sql
#sqlplus $CONNECT_STRING @${SCRIPT_DIR}/5_BIP_317_336_INSERT_DML.sql
#sqlplus $CONNECT_STRING @${SCRIPT_DIR}/6_BIP_330_DDL.sql
#sqlplus $CONNECT_STRING @${SCRIPT_DIR}/7_ISAC_ALIMENTATION_DDL.sql
#sqlplus $CONNECT_STRING @${SCRIPT_DIR}/8_ISAC_ALIMENTATION_DDL.sql
#sqlplus $CONNECT_STRING @${SCRIPT_DIR}/9_REJET_ME_DML.sql
#sqlplus $CONNECT_STRING @${SCRIPT_DIR}/replace_type.sql
