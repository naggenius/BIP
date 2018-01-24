#!/bin/ksh

# $1 : parameter that must be given with Ansible Playbook
# This file should not be updated every

SCRIPT_DIR=$(dirname "$(readlink -f $0)")
echo "SCRIPT_DIR_DEPLOY = ${SCRIPT_DIR}"
echo

# Load user env settings
. ~/.profile


echo "BEGIN_COMPILE"
echo

sqlplus $CONNECT_STRING @${SCRIPT_DIR}/BIP_PACKAGES-ALL.sql

echo "FIN_COMPILE"
echo
