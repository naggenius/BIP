spool creation_tmp_dmp_nonutilisee.log;

  CREATE OR REPLACE VIEW "VIEW_LIST_ACTIVE_PM" ("IDENT", "CPIDENT") AS SELECT distinct st.ident, decode(st.cpident,st.ident,null,st.cpident) cpident
FROM situ_ress st, datdebex d,
  (SELECT DISTINCT cpident  FROM situ_ress st,  datdebex d
  WHERE 
  (TRUNC(st.datsitu,'YEAR') <=TRUNC(d.DATDEBEX,'YEAR')  OR st.datsitu IS NULL)
  AND (TRUNC(st.datdep,'YEAR') >=TRUNC(d.DATDEBEX,'YEAR') OR st.datdep IS NULL)
  ) cp
WHERE 
  (TRUNC(st.datsitu,'YEAR') <=TRUNC(d.DATDEBEX,'YEAR')  OR st.datsitu IS NULL)
  AND (TRUNC(st.datdep,'YEAR') >=TRUNC(d.DATDEBEX,'YEAR') OR st.datdep IS NULL)
AND st.ident= cp.cpident ;

   COMMENT ON TABLE "VIEW_LIST_ACTIVE_PM"  IS 'List all project manager with the N-1 level' ;

   
commit;
exit;
show errors