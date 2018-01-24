-- Nom            : VUE_BO_CONSKE.SQL
-- Auteur         : Uriel Bourgeois
-- Description    : Creation de la vue des consommés en KEEUR par ligne BIP pour BO.
--
--*********************************************************************************************
-- Quand      Qui  Quoi
-- --------   ---  ----------------------------------------
--
--/
-- Transmettre les droits au user bobip
--   GRANT SELECT ON VUE_BO_CONSKE TO ROLE_BO; (avec user bip)
--   CREATE SYNONYM VUE_BO_CONSKE FOR BIP.VUE_BO_CONSKE; (avec user bobip)
CREATE OR REPLACE VIEW VUE_BO_CONSKE AS
SELECT
   pid,
   round((sum(fxcscus) / 1000),1) factint
FROM
	tmpfactint
WHERE
   codsg >= 100000
GROUP BY pid
/
