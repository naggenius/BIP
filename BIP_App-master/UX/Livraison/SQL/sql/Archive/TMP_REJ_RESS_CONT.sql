spool creation_tmp_rej_ress_cont.log;

CREATE TABLE "BIP"."TMP_REJ_RESS_CONT"
(
	"ID_TRAITEMENT" NUMBER,
	"ID_REJET" NUMBER,
	"REJET" VARCHAR2(400),
	"DATE_EDITION" DATE
);

exit;
show errors