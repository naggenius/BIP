ALTER TABLE RTFE_ERROR MODIFY CHEF_PROJET varchar2(4000);
ALTER TABLE RTFE MODIFY CHEF_PROJET varchar2(4000);
ALTER TABLE LIGNE_PARAM_BIP MODIFY MAX_SIZE_TOT NUMBER(4,0);
COMMENT ON COLUMN "BIP"."LIGNE_PARAM_BIP"."MAX_SIZE_TOT"
IS 'Longueur totale maximale (1 � 9999 car)';
exit;
