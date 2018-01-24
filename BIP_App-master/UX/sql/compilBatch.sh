#! /bin/ksh

sqlplus $CONNECT_STRING @$TMPDIR/UPDATE_MESSAGE.sql
sqlplus $CONNECT_STRING @$TMPDIR/batch2compilbip.sql
sqlplus $CONNECT_STRING @$TMPDIR/compilInvalidPackage.sql
sqlplus $CONNECT_STRING @$TMPDIR/verif_errors.sql