       CREATE OR REPLACE FORCE VIEW "BIP"."VUE_POLE" ("CODE", "LIBELLE") AS 
  select substr(to_char(codsg,'FM0099999'),1,7) AS code,
			substr(libdsg,1,12) As libelle
		   FROM
			struct_info
		   WHERE
			codsg > 1 and topfer like 'O'
		   -- -----
		   UNION
		   -- -----
		   -- ----------------------------------------------------------------------
		   -- Liste de tous les pôles
		   -- ----------------------------------------------------------------------
	           SELECT DISTINCT
			substr(to_char(codsg,'FM0099999'),1,5)||'00' AS code,
			sigdep                                 || '/'    ||
			sigpole AS libelle
		   FROM
			struct_info
		   WHERE
			codsg > 1 and topfer like 'O'
		   -- -----
		   UNION
		   -- -----
   		   -- ----------------------------------------------------------------------
		   -- Liste de tous les departements (XX**)
		   -- ----------------------------------------------------------------------
		   SELECT DISTINCT
			substr(to_char(codsg,'FM0099999'),1,3) || '0000'  AS code,
			rpad(sigdep,6,' ') AS libelle
		   FROM
			struct_info
		   WHERE
			codsg > 1 and topfer like 'O'
		   -- -----
		   UNION
		   -- -----
   		   -- ----------------------------------------------------------------------
		   -- Code special '0000'
		   -- ----------------------------------------------------------------------
		   SELECT
			'0000000' AS code,
		        rpad('Tous',6,' ') AS libelle
		   FROM
			dual
 ;
