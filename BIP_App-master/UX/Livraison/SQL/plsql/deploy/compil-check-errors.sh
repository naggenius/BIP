#!/bin/ksh

# This file should not be updated...

SCRIPT_DIR=$(dirname "$(readlink -f $0)")
echo "SCRIPT_DIR = ${SCRIPT_DIR}"
echo

# Load user env settings
. ~/.profile

sqlplus $CONNECT_STRING @${SCRIPT_DIR}/compilInvalidPackage.sql
sqlplus $CONNECT_STRING @${SCRIPT_DIR}/verif_errors.sql