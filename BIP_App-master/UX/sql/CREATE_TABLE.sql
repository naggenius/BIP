spool creation_tmp_dmp_nonutilisee.log;

CREATE TABLE "BIP"."TMP_DMP_NONUTILISEE"
  (
    "REFDEMANDE" VARCHAR2(12 BYTE),
    "DDETYPE"    VARCHAR2(1 BYTE),
    "DPCOPI"     VARCHAR2(6 BYTE),
    "PROJET"     VARCHAR2(5 BYTE),
    "NUMSEQ"     NUMBER NOT NULL ENABLE
  )
  SEGMENT CREATION DEFERRED PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING TABLESPACE "BIP_1M_DA" ;

commit;
exit;
show errors