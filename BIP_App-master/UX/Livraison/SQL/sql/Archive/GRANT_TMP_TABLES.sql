spool grantBIP.log;

GRANT DELETE, INSERT, SELECT, UPDATE ON	BIP.TMP_REJETMENS_TAIL TO ROLE_REMOTE;
GRANT SELECT ON TMP_REJETMENS_TAIL TO BIPH;
GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON TMP_REJETMENS_TAIL TO BIPIHM;
GRANT SELECT ON BIP.TMP_REJETMENS_TAIL TO ROLE_VISU_ME;
GRANT SELECT ON BIP.TMP_REJETMENS_TAIL TO ROLE_VISU_MO;
GRANT SELECT ON BIP.TMP_REJETMENS_TAIL TO ROLE_DBA_ME;


/
exit;
show errors