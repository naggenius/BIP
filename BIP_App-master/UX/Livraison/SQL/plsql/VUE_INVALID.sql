 CREATE OR REPLACE FORCE VIEW "BIP"."VUE_INVALID" ("COMMANDE") AS 
  select distinct
'alter ' || decode(object_type, 'PACKAGE BODY', 'PACKAGE', object_type) ||
' ' || object_name || ' compile;' commande
from obj where status='INVALID'
 ;

   COMMENT ON COLUMN "BIP"."VUE_INVALID"."COMMANDE" IS 'Commande pour recompiler l''objet';
   COMMENT ON TABLE "BIP"."VUE_INVALID"  IS 'Vue Technique des objets Oracle invalides';
