-- Creation de la vue vue_ext_ppcm2 .
-- Elle permet d'appliquer les regles de gestion et, pour une ressource donnée, 
-- facilite la recherche de la plus ancienne date de debut de contrat.

  CREATE OR REPLACE FORCE VIEW "BIP"."VUE_EXT_PPCM2" ("IDENT", "CDATDEB", "CDATFIN", "CODSG") AS 
  SELECT lc.ident, c.cdatdeb, c.cdatfin, c.codsg codsg
FROM  ligne_cont lc, contrat c
WHERE lc.soccont  = c.soccont
  AND lc.cav      = c.cav
  AND lc.numcont  = c.numcont
  AND c.cdatdeb <= trunc(SYSDATE)   -- Regle de gestion
  AND c.cdatfin >= trunc(SYSDATE)   -- Regle de gestion
 ;


