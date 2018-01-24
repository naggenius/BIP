-- Nom            : VUE_BO_BUDGETS.SQL
-- Auteur         : Philippe DARRACQ
-- Description    : Creation de la vue des budgets par ligne BIP pour BO                                         différence.
--
--*********************************************************************************************
-- Quand      Qui  Quoi
-- --------   ---  ----------------------------------------
-- xx/xx/2000 PHD  
--VARIABLE an NUMBER
--DECLARE
--	v_annee NUMBER(4);
--BEGIN
--      SELECT to_number(to_char(datdebex,'yyyy'))INTO v_annee from DATDEBEX;
--	:an:= v_annee;
--END;
--/
-- Transmettre les droits au user bobip
--   GRANT SELECT VUE_BO_BUDGETS ON TO ROLE_BO; (avec user bip)
--   CREATE SYNONYM VUE_BO_BUDGETS FOR BIP.VUE_BO_BUDGETS; (avec user bobip)
CREATE OR REPLACE VIEW VUE_BO_BUDGETS AS
SELECT	LBDB.pid ,
          PB_1.bpmont1 PropAAm1_PR1,
          PB_1.bpmont2 PropAAm1_PR2,
          PB_1.bpmont3 PropAAm1_PR3,
          BN_1.bnmont  NotAAm1,
          BAN_1.anmont ArbAAm1,
          PB.bpmont1   PropAA_PR1,
          PB.bpmont2   PropAA_PR2,
          PB.bpmont3   PropAA_PR3,
          BN.bnmont    NotAA,
          BAN.anmont   ArbAA,
          PB1.bpmont1  PropAAP1_PR1,
          PB1.bpmont2  PropAAP1_PR2,
          PB1.bpmont3  PropAAP1_PR3,
          BN1.bnmont   NotAAp1,
          PB2.bpmont1  PropAAp2_PR1,
          BN2.bnmont   NotAAp2,
          PB3.bpmont1  PropAAp3_PR1,
          BN3.bnmont   NotAAp3,
          PB1.bpmontmo PropAAp1_MO,
          PB.bpmontmo  PropAA_MO
FROM
	(SELECT LB.pid, to_number(to_char(DB.DATDEBEX,'yyyy')) an FROM  LIGNE_BIP LB, DATDEBEX DB) LBDB,
	 PROP_BUDGET PB_1,                                         --table des budgets proposés pour l'année en cours-1
	 BUDG_NOTIF BN_1,                                          --table des budgets notifiés pour l'année en cours-1
         BUDG_ARB_NOTIF BAN_1,                                     --table des budgets arbitrés notifiés pour l'année en cours-1
	 PROP_BUDGET PB,                                           --table des budgets proposés pour l'année en cours
	 BUDG_NOTIF BN,                                            --table des budgets notifiés pour l'année en cours
	 BUDG_ARB_NOTIF BAN,                                       --table des budgets arbitrés notifiés pour l'année en cours
         PROP_BUDGET PB1,                                         --table des budgets proposés pour l'année en cours+1
         BUDG_NOTIF  BN1,                                         --table des budgets notifiés pour l'année en cours+1
         PROP_BUDGET PB2,                                         --table des budgets proposés pour l'année en cours+2
         BUDG_NOTIF BN2,                                          --table des budgets notifiés pour l'année en cours+2
         PROP_BUDGET PB3,                                         --table des budgets proposés pour l'année en cours+3
         BUDG_NOTIF  BN3 	                                   --table des budgets notifiés pour l'année en cours+3
WHERE 
          LBDB.pid     = PB.pid(+)
  AND     LBDB.pid     = BN.pid(+)
  AND     LBDB.pid     = BAN.pid(+)
  AND     LBDB.pid     = PB_1.pid(+)
  AND     LBDB.pid     = BN_1.pid(+)
  AND     LBDB.pid     = BAN_1.pid(+)
  AND     LBDB.pid     = PB1.pid(+)
  AND     LBDB.pid     = BN1.pid(+)
  AND     LBDB.pid     = PB2.pid(+)
  AND     LBDB.pid     = BN2.pid(+)
  AND     LBDB.pid     = PB3.pid(+)
  AND     LBDB.pid     = BN3.pid(+)
      -- clauses where sur les années
  AND BAN.anannee(+)   = LBDB.an
  AND BAN_1.anannee(+) = LBDB.an-1
  AND BN.bnannee(+)    = LBDB.an 
  AND BN_1.bnannee(+)  = LBDB.an-1
  AND BN1.bnannee(+)   = LBDB.an+1
  AND BN2.bnannee(+)   = LBDB.an+2
  AND BN3.bnannee(+)   = LBDB.an+3
  AND PB.bpannee(+)    = LBDB.an
  AND PB_1.bpannee(+)  = LBDB.an-1
  AND PB1.bpannee(+)   = LBDB.an+1
  AND PB2.bpannee(+)   = LBDB.an+2
  AND PB3.bpannee(+)   = LBDB.an+3
/

