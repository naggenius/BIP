spool create_TMP_REJETMENS_TAIL.log;

  CREATE TABLE "BIP"."TMP_REJETMENS_TAIL"
  (
    "PID"   VARCHAR2(4 BYTE),
    "CODSG" NUMBER(7,0),
    "ECET"  CHAR(2 BYTE),
    "ACTA"  CHAR(2 BYTE),
    "ACST"  CHAR(2 BYTE),
    "IDENT" NUMBER(5,0),
    "CDEB" DATE,
    "CUSAG"       NUMBER(9,2),
    "MOTIF_REJET" VARCHAR2(300 BYTE)
  );
exit;
show errors