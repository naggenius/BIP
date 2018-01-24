/*
 * Table created for BIP-31 implementation
 * */

create global temporary table pack_arbitre_tab (
    CLILIB VARCHAR2(25),
    DPCODE NUMBER(5),
    DP_COPI VARCHAR2(6) ,
    ICPI CHAR(5),
    METIER CHAR(3),
    FOURNISSEUR VARCHAR2(60),
    PID VARCHAR2(4),
  TYPE CHAR(2),
  ARCTYPE VARCHAR2(3),
  BPMONTMO NUMBER(12,2) ,
  ECART NUMBER(12,2) ,
  ANMONT NUMBER(12,2),
  FLAGLOCK VARCHAR2(20),
  APDATE DATE,
  UANMONT VARCHAR2(30),
  REF_DEMANDE VARCHAR2(12),
  CONSOANNEE NUMBER(7,2),
  DPCOPIAXEMETIER VARCHAR2(12),
  PROJAXEMETIER VARCHAR2(12) 
  ) on commit preserve rows;