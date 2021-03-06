spool grant_type.log;

GRANT DELETE, INSERT, SELECT, UPDATE ON	BIP.ARCHIVE_PMW_BIPS TO ROLE_REMOTE;
GRANT SELECT ON ARCHIVE_PMW_BIPS TO BIPH;
GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON ARCHIVE_PMW_BIPS TO BIPIHM;
GRANT SELECT ON BIP.ARCHIVE_PMW_BIPS TO ROLE_VISU_ME;
GRANT SELECT ON BIP.ARCHIVE_PMW_BIPS TO ROLE_VISU_MO;
GRANT SELECT ON BIP.ARCHIVE_PMW_BIPS TO ROLE_DBA_ME;

/
exit;
show errors