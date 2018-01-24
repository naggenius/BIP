  CREATE OR REPLACE FORCE VIEW "BIP"."VUE_DIRECTION" ("CLIDOM", "CLISIGLE") AS 
  select distinct clicode,clisigle
from client_mo
 ;

   COMMENT ON COLUMN "BIP"."VUE_DIRECTION"."CLIDOM" IS 'Code client MO';
   COMMENT ON COLUMN "BIP"."VUE_DIRECTION"."CLISIGLE" IS 'Sigle client MO';
   COMMENT ON TABLE "BIP"."VUE_DIRECTION"  IS 'Vue listant les clients MO et leur sigle';
