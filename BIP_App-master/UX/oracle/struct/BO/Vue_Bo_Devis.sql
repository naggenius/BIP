-- Nom            : VUE_BO_DEVIS.SQL
-- Auteur         : Uriel Bourgeois
-- Description    : Creation de la vue des devis par ligne BIP pour BO.
--
--*********************************************************************************************
-- Quand      Qui  Quoi
-- --------   ---  ----------------------------------------
--
--/
-- Transmettre les droits au user bobip
--   GRANT SELECT ON VUE_BO_DEVIS TO ROLE_BO; (avec user bip)
--   CREATE SYNONYM VUE_BO_DEVIS FOR BIP.VUE_BO_DEVIS; (avec user bobip)
CREATE OR REPLACE VIEW VUE_BO_DEVIS AS
SELECT
	f.pid,
	NULL deviskf,
	round((sum(f.pcsdecn1 * CF.coutfi)/1000),1) factintd
FROM
   	(SELECT f.pid,f.pcsdecn1,f.cafi,f.deannee,f.codfi
	  FROM datdebex d,fi_conso_m1 f,
     		(SELECT DISTINCT cafi FROM struct_info
      		WHERE codsg>=100000
      		AND topfer='O') s
	 WHERE f.cafi=s.cafi
	 AND f.deannee = to_number(to_char(d.datdebex,'YYYY'))) f,
   COUT_FI    CF
WHERE
       f.deannee = CF.anneefi
   AND f.codfi = CF.codfi
   AND f.cafi=cf.cafi
GROUP BY f.pid
/
