#!/bin/ksh

# This file must updated every time that an SQL script is added to the delivery

SCRIPT_DIR=$(dirname "$(readlink -f $0)")
echo "SCRIPT_DIR = ${SCRIPT_DIR}"
echo

# Load user env settings
. ~/.profile

#sqlplus $CONNECT_STRING @${SCRIPT_DIR}/replace_type.sql
sqlplus $CONNECT_STRINGIHM @${SCRIPT_DIR}/2_Synonyms_Hierarchy.sql
sqlplus $CONNECT_STRING @${SCRIPT_DIR}/3_grants_Hierarchy.sql