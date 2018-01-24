 CREATE OR REPLACE FORCE VIEW "BIP"."VUE_CALEND" ("CALANMOIS", "CJOURS") AS 
  SELECT  distinct calanmois ,
           cjours
FROM       CALENDRIER
WHERE      to_char(sysdate,'yyyy') = to_char(calanmois,'yyyy')
 ;

   COMMENT ON COLUMN "BIP"."VUE_CALEND"."CALANMOIS" IS 'Mois/Année de traitement';
   COMMENT ON COLUMN "BIP"."VUE_CALEND"."CJOURS" IS 'Nombre de jours ouvrés';
   COMMENT ON TABLE "BIP"."VUE_CALEND"  IS 'Vue donnant le nombre de jours ouvrés des mois de l''année d''exercice';
