-- ============================================================
-- PROJET  - Script de creation des index BIP
-- Date : 02/10/2006	
-- Auteur :  A. SAKHRAOUI
-- Version:	1
--
-- Modifications :
--	
--
-- ============================================================

-- ========================================================
-- bip_creindex.sql
-- ========================================================


--
-- PK_ACTUALITE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_actualite ON bip.actualite
(code_actu)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- AGENCE_IDX1  (Index) 
--
CREATE INDEX bip.agence_idx1 ON bip.agence
(soccode)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- AGENCE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.agence_pk ON bip.agence
(soccode, socfour)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- APPLICATION_IDX1  (Index) 
--
CREATE INDEX bip.application_idx1 ON bip.application
(clicode)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- APPLICATION_IDX2  (Index) 
--
CREATE INDEX bip.application_idx2 ON bip.application
(codgappli)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- APPLICATION_IDX3  (Index) 
--
CREATE INDEX bip.application_idx3 ON bip.application
(codsg)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- APPLICATION_PK  (Index) 
--
CREATE UNIQUE INDEX bip.application_pk ON bip.application
(airt)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- AUDIT_STATUT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.audit_statut_pk ON bip.audit_statut
(pid)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- BJH_ANOMALIES_PK  (Index) 
--
CREATE UNIQUE INDEX bip.bjh_anomalies_pk ON bip.bjh_anomalies
(matricule, mois, typeabsence)
NOLOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- BJH_EXTBIP_IND1  (Index) 
--
CREATE INDEX bip.bjh_extbip_ind1 ON bip.bjh_extbip
(matricule)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- BJH_EXTGIP_IND1  (Index) 
--
CREATE INDEX bip.bjh_extgip_ind1 ON bip.bjh_extgip
(matricule)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- BRANCHES_PK  (Index) 
--
CREATE UNIQUE INDEX bip.branches_pk ON bip.branches
(codbr)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- BUDGET_PK  (Index) 
--
CREATE UNIQUE INDEX bip.budget_pk ON bip.budget
(pid, annee)
NOLOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_BUDGET_DP  (Index) 
--
CREATE UNIQUE INDEX bip.pk_budget_dp ON bip.budget_dp
(annee, dpcode, clicode)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CALEND_PK  (Index) 
--
CREATE UNIQUE INDEX bip.calend_pk ON bip.calendrier
(calanmois)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CENTRE_ACTIVITE_IDX1  (Index) 
--
CREATE INDEX bip.centre_activite_idx1 ON bip.centre_activite
(ctopact)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CENTREACTIVITE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.centreactivite_pk ON bip.centre_activite
(codcamo)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_CENTRE_FRAIS  (Index) 
--
CREATE UNIQUE INDEX bip.pk_centre_frais ON bip.centre_frais
(codcfrais)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CLIENT_MO_IDX1  (Index) 
--
CREATE INDEX bip.client_mo_idx1 ON bip.client_mo
(filcode)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CLIENTMO_PK  (Index) 
--
CREATE UNIQUE INDEX bip.clientmo_pk ON bip.client_mo
(clicode)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CODECOMPT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.codecompt_pk ON bip.code_compt
(comcode)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CODESTATUT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.codestatut_pk ON bip.code_statut
(astatut)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_COMPO_CENTRE_FRAIS  (Index) 
--
CREATE UNIQUE INDEX bip.pk_compo_centre_frais ON bip.compo_centre_frais
(codcfrais, codbddpg, topfer)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_COMPTE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_compte ON bip.compte
(codcompte)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONSOMME_PK  (Index) 
--
CREATE UNIQUE INDEX bip.consomme_pk ON bip.consomme
(pid, annee)
NOLOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONS_SSTACHE_RES_PK  (Index) 
--
CREATE UNIQUE INDEX bip.cons_sstache_res_pk ON bip.cons_sstache_res
(pid, ecet, acta, acst, ident)
NOLOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONS_SSTACHE_RES_IDX2  (Index) 
--
CREATE INDEX bip.cons_sstache_res_idx2 ON bip.cons_sstache_res
(ident)
NOLOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONS_SSTACHE_RES_IDX1  (Index) 
--
CREATE INDEX bip.cons_sstache_res_idx1 ON bip.cons_sstache_res
(acst, acta, ecet, pid)
NOLOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONSSSTACHERES_BACK_PK  (Index) 
--
CREATE UNIQUE INDEX bip.conssstacheres_back_pk ON bip.cons_sstache_res_back
(pid, ecet, acta, acst, ident)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONSSSTACHERESMOIS_IDEN  (Index) 
--
CREATE INDEX bip.conssstacheresmois_iden ON bip.cons_sstache_res_mois
(ident)
NOLOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       2
            MAXEXTENTS       50
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONSSSTACHERESMOIS_PK  (Index) 
--
CREATE UNIQUE INDEX bip.conssstacheresmois_pk ON bip.cons_sstache_res_mois
(pid, ecet, acta, acst, ident,
cdeb)
NOLOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CSSTRM_ARCHIVE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.csstrm_archive_pk ON bip.cons_sstache_res_mois_archive
(pid, ecet, acta, acst, ident,
cdeb)
NOLOGGING
TABLESPACE tbs_bip_his_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       1000
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONSSSTACHERESMOIS_BACK_PK  (Index) 
--
CREATE UNIQUE INDEX bip.conssstacheresmois_back_pk ON bip.cons_sstache_res_mois_back
(cdeb, pid, ecet, acta, acst,
ident)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONSSSTRESM_REJ_DATESTATUT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.conssstresm_rej_datestatut_pk ON bip.cons_sstres_m_rejet_datestatut
(cdeb, pid, ecet, acta, acst,
ident)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONSSSTRES_REJ_DATESTATUT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.conssstres_rej_datestatut_pk ON bip.cons_sstres_rejet_datestatut
(pid, ecet, acta, acst, ident)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONTRAT_IDX2  (Index) 
--
CREATE INDEX bip.contrat_idx2 ON bip.contrat
(cav)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONTRAT_IDX6  (Index) 
--
CREATE INDEX bip.contrat_idx6 ON bip.contrat
(codsg)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONTRAT_IDX1  (Index) 
--
CREATE INDEX bip.contrat_idx1 ON bip.contrat
(soccont)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONTRAT_IDX3  (Index) 
--
CREATE INDEX bip.contrat_idx3 ON bip.contrat
(filcode)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONTRAT_IDX4  (Index) 
--
CREATE INDEX bip.contrat_idx4 ON bip.contrat
(niche)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONTRAT_IDX5  (Index) 
--
CREATE INDEX bip.contrat_idx5 ON bip.contrat
(comcode)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CONTRAT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.contrat_pk ON bip.contrat
(numcont, soccont, cav)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- COUT_STD2_PK  (Index) 
--
CREATE UNIQUE INDEX bip.cout_std2_pk ON bip.cout_std2
(annee, dpg_bas)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- COUT_STD_SG_PK  (Index) 
--
CREATE UNIQUE INDEX bip.cout_std_sg_pk ON bip.cout_std_sg
(annee, niveau, metier, dpg_haut, dpg_bas)
NOLOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- CUMUL_CONSO_PK  (Index) 
--
CREATE UNIQUE INDEX bip.cumul_conso_pk ON bip.cumul_conso
(annee, pid)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- DIRECTIONS_PK  (Index) 
--
CREATE UNIQUE INDEX bip.directions_pk ON bip.directions
(coddir)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- DOMAINE_BANCAIRE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.domaine_bancaire_pk ON bip.domaine_bancaire
(cod_db)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- DOSSIERPROJET_PK  (Index) 
--
CREATE UNIQUE INDEX bip.dossierprojet_pk ON bip.dossier_projet
(dpcode)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- ENSEMBLE_APPLICATIF_PK  (Index) 
--
CREATE UNIQUE INDEX bip.ensemble_applicatif_pk ON bip.ensemble_applicatif
(cod_ea)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_ENTITE_STRUCTURE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_entite_structure ON bip.entite_structure
(codcamo)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- ESOUR_CONT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.esour_cont_pk ON bip.esourcing_contrat
(id_oalia_cont, id_oalia_ligne, date_trait)
LOGGING
TABLESPACE tbs_bip_fatc_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- ETAPE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.etape_pk ON bip.etape
(pid, ecet)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- ETAPE_IDX1  (Index) 
--
CREATE INDEX bip.etape_idx1 ON bip.etape
(typetap)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- ETAPE2PK  (Index) 
--
CREATE UNIQUE INDEX bip.etape2pk ON bip.etape2
(pid, ecet)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- ETAPE_BACK_PK  (Index) 
--
CREATE UNIQUE INDEX bip.etape_back_pk ON bip.etape_back
(ecet, pid)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- ETAPE_REJET_DATESTATUT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.etape_rejet_datestatut_pk ON bip.etape_rejet_datestatut
(ecet, pid)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- FACCONS_CONSOMME_IDX1  (Index) 
--
CREATE INDEX bip.faccons_consomme_idx1 ON bip.faccons_consomme
(ident)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- FACCONS_FACTURE_IDX1  (Index) 
--
CREATE INDEX bip.faccons_facture_idx1 ON bip.faccons_facture
(ident)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- FACTURE_IDX4  (Index) 
--
CREATE INDEX bip.facture_idx4 ON bip.facture
(socfact)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- FACTURE_IDX1  (Index) 
--
CREATE INDEX bip.facture_idx1 ON bip.facture
(numcont, cav, soccont)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- FACTURE_IDX2  (Index) 
--
CREATE INDEX bip.facture_idx2 ON bip.facture
(typfact)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- FACTURE_IDX3  (Index) 
--
CREATE INDEX bip.facture_idx3 ON bip.facture
(datfact)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- FACTURE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.facture_pk ON bip.facture
(socfact, numfact, typfact, datfact)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_FAVORIS  (Index) 
--
CREATE UNIQUE INDEX bip.pk_favoris ON bip.favoris
(iduser, menu, typefav, ordre)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- FICHIERS_RDF_PK  (Index) 
--
CREATE UNIQUE INDEX bip.fichiers_rdf_pk ON bip.fichiers_rdf
(fichier_rdf)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- FILIALECLI_PK  (Index) 
--
CREATE UNIQUE INDEX bip.filialecli_pk ON bip.filiale_cli
(filcode)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_FILTRE_REQUETE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_filtre_requete ON bip.filtre_requete
(nom_fichier, code)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- HISPRO_IDX_3  (Index) 
--
CREATE INDEX bip.hispro_idx_3 ON bip.hispro
(pid)
LOGGING
TABLESPACE tbs_bip_his_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- HISPRO_IDX_1  (Index) 
--
CREATE INDEX bip.hispro_idx_1 ON bip.hispro
(cdeb)
LOGGING
TABLESPACE tbs_bip_his_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- HISPRO_IDX_2  (Index) 
--
CREATE INDEX bip.hispro_idx_2 ON bip.hispro
(tires)
LOGGING
TABLESPACE tbs_bip_his_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- HISTOAMORTPC70_PK  (Index) 
--
CREATE UNIQUE INDEX bip.histoamortpc70_pk ON bip.histo_amort
(pid, aanhist)
LOGGING
TABLESPACE tbs_bip_his_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- HISTO_CONTRAT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.histo_contrat_pk ON bip.histo_contrat
(numcont, soccont, cav)
LOGGING
TABLESPACE tbs_bip_his_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- HISTO_LIGNECONT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.histo_lignecont_pk ON bip.histo_ligne_cont
(numcont, soccont, cav, lcnum)
LOGGING
TABLESPACE tbs_bip_his_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- HISTO_LIGNEFACT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.histo_lignefact_pk ON bip.histo_ligne_fact
(lnum, socfact, typfact, datfact, numfact)
LOGGING
TABLESPACE tbs_bip_his_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_HISTO_SUIVIJHR  (Index) 
--
CREATE UNIQUE INDEX bip.pk_histo_suivijhr ON bip.histo_suivijhr
(codsg)
LOGGING
TABLESPACE tbs_bip_his_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- IAS_PK  (Index) 
--
CREATE UNIQUE INDEX bip.ias_pk ON bip.ias
(cdeb, factpid, ident, typetap, pid)
LOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- IMMEUBLE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.immeuble_pk ON bip.immeuble
(icodimm)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- IMP_OSCAR_TMP_IND1  (Index) 
--
CREATE INDEX bip.imp_oscar_tmp_ind1 ON bip.imp_oscar_tmp
(pid)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_INVESTISSEMENTS  (Index) 
--
CREATE UNIQUE INDEX bip.pk_investissements ON bip.investissements
(codtype)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- ISAC_AFFECTATION_IDX1  (Index) 
--
CREATE INDEX bip.isac_affectation_idx1 ON bip.isac_affectation
(ident)
NOLOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_ISAC_AFFECTATION  (Index) 
--
CREATE UNIQUE INDEX bip.pk_isac_affectation ON bip.isac_affectation
(sous_tache, ident)
NOLOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_ISAC_CONSOMME  (Index) 
--
CREATE UNIQUE INDEX bip.pk_isac_consomme ON bip.isac_consomme
(ident, sous_tache, cdeb)
NOLOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_ISAC_CONTROLE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_isac_controle ON bip.isac_controle
(ID)
LOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- ISAC_ETAPE_IDX1  (Index) 
--
CREATE INDEX bip.isac_etape_idx1 ON bip.isac_etape
(pid)
NOLOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_ISAC_ETAPE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_isac_etape ON bip.isac_etape
(etape)
NOLOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_ISAC_MESSAGE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_isac_message ON bip.isac_message
(id_msg)
LOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- ISAC_SOUS_TACHE_IDX1  (Index) 
--
CREATE INDEX bip.isac_sous_tache_idx1 ON bip.isac_sous_tache
(tache)
LOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- ISAC_SOUS_TACHE_IDX2  (Index) 
--
CREATE INDEX bip.isac_sous_tache_idx2 ON bip.isac_sous_tache
(etape)
LOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- ISAC_SOUS_TACHE_IDX3  (Index) 
--
CREATE INDEX bip.isac_sous_tache_idx3 ON bip.isac_sous_tache
(pid)
LOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_ISAC_SOUS_TACHE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_isac_sous_tache ON bip.isac_sous_tache
(sous_tache)
NOLOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- ISAC_TACHE_IDX1  (Index) 
--
CREATE INDEX bip.isac_tache_idx1 ON bip.isac_tache
(etape)
NOLOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- ISAC_TACHE_IDX2  (Index) 
--
CREATE INDEX bip.isac_tache_idx2 ON bip.isac_tache
(pid)
NOLOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_ISAC_TACHE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_isac_tache ON bip.isac_tache
(tache)
NOLOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- JFERIE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.jferie_pk ON bip.jferie
(datjfer)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIEN_PROFIL_ACTU_PK  (Index) 
--
CREATE UNIQUE INDEX bip.lien_profil_actu_pk ON bip.lien_profil_actu
(code_actu, code_profil)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIEN_TYPES_PROJ_ACT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.lien_types_proj_act_pk ON bip.lien_types_proj_act
(type_proj, type_act)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_BIP_IDX6  (Index) 
--
CREATE INDEX bip.ligne_bip_idx6 ON bip.ligne_bip
(dpcode)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_BIP_IDX10  (Index) 
--
CREATE INDEX bip.ligne_bip_idx10 ON bip.ligne_bip
(pcpi)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_BIP_IDX2  (Index) 
--
CREATE INDEX bip.ligne_bip_idx2 ON bip.ligne_bip
(codpspe)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_BIP_IDX8  (Index) 
--
CREATE INDEX bip.ligne_bip_idx8 ON bip.ligne_bip
(airt)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_BIP_IDX1  (Index) 
--
CREATE INDEX bip.ligne_bip_idx1 ON bip.ligne_bip
(typproj)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_BIP_IDX5  (Index) 
--
CREATE INDEX bip.ligne_bip_idx5 ON bip.ligne_bip
(codsg)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_BIP_IDX9  (Index) 
--
CREATE INDEX bip.ligne_bip_idx9 ON bip.ligne_bip
(clicode)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_BIP_IDX4  (Index) 
--
CREATE INDEX bip.ligne_bip_idx4 ON bip.ligne_bip
(codcamo)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_BIP_IDX7  (Index) 
--
CREATE INDEX bip.ligne_bip_idx7 ON bip.ligne_bip
(arctype)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_BIP_IDX3  (Index) 
--
CREATE INDEX bip.ligne_bip_idx3 ON bip.ligne_bip
(icpi)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNEBIP_PK  (Index) 
--
CREATE UNIQUE INDEX bip.lignebip_pk ON bip.ligne_bip
(pid)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNEBIP2PK  (Index) 
--
CREATE UNIQUE INDEX bip.lignebip2pk ON bip.ligne_bip2
(pid)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_BIP_LOGS_PK  (Index) 
--
CREATE UNIQUE INDEX bip.ligne_bip_logs_pk ON bip.ligne_bip_logs
(pid, date_log, user_log, colonne)
NOLOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_CONT_IDX1  (Index) 
--
CREATE INDEX bip.ligne_cont_idx1 ON bip.ligne_cont
(ident)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_CONT_IDX2  (Index) 
--
CREATE INDEX bip.ligne_cont_idx2 ON bip.ligne_cont
(numcont, soccont, cav)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNECONT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.lignecont_pk ON bip.ligne_cont
(numcont, soccont, cav, lcnum)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_FACT_IDX1  (Index) 
--
CREATE INDEX bip.ligne_fact_idx1 ON bip.ligne_fact
(tva)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_FACT_IDX2  (Index) 
--
CREATE INDEX bip.ligne_fact_idx2 ON bip.ligne_fact
(ident)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_FACT_IDX3  (Index) 
--
CREATE INDEX bip.ligne_fact_idx3 ON bip.ligne_fact
(codcamo)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_FACT_IDX4  (Index) 
--
CREATE INDEX bip.ligne_fact_idx4 ON bip.ligne_fact
(pid)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNE_FACT_IDX5  (Index) 
--
CREATE INDEX bip.ligne_fact_idx5 ON bip.ligne_fact
(numfact, socfact, datfact, typfact)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- LIGNEFACT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.lignefact_pk ON bip.ligne_fact
(socfact, numfact, datfact, typfact, lnum)
LOGGING
TABLESPACE tbs_bip_fact_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_LI  (Index) 
--
CREATE UNIQUE INDEX bip.pk_li ON bip.ligne_investissement
(codinv, annee, codcamo)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_LIGNE_REALISATION  (Index) 
--
CREATE UNIQUE INDEX bip.pk_ligne_realisation ON bip.ligne_realisation
(codrea, codinv, annee, codcamo)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- MESSAGE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.message_pk ON bip.MESSAGE
(id_msg)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- METIER_PK  (Index) 
--
CREATE UNIQUE INDEX bip.metier_pk ON bip.metier
(metier)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_NATURE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_nature ON bip.nature
(codnature)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- NICHE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.niche_pk ON bip.niche
(niche)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- NIVEAU_PK  (Index) 
--
CREATE UNIQUE INDEX bip.niveau_pk ON bip.niveau
(niveau)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_PARTENAIRE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_partenaire ON bip.partenaire
(coddep, soccode)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PMW_ACTIVITE_IDX1  (Index) 
--
CREATE INDEX bip.pmw_activite_idx1 ON bip.pmw_activite
(pid, acet, acta, acst)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PMW_AFFECTA_IDX1  (Index) 
--
CREATE INDEX bip.pmw_affecta_idx1 ON bip.pmw_affecta
(pid, tcet, tcta, tcst, tires)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PMW_LIGNE_BIP_IDX1  (Index) 
--
CREATE INDEX bip.pmw_ligne_bip_idx1 ON bip.pmw_ligne_bip
(pid)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_POSTE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_poste ON bip.poste
(codposte)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_PRESTATION  (Index) 
--
CREATE UNIQUE INDEX bip.pk_prestation ON bip.prestation
(prestation)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PROJINFO_PK  (Index) 
--
CREATE UNIQUE INDEX bip.projinfo_pk ON bip.proj_info
(icpi)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PROJ_INFO_IDX1  (Index) 
--
CREATE INDEX bip.proj_info_idx1 ON bip.proj_info
(codsg)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PROJ_INFO_IDX2  (Index) 
--
CREATE INDEX bip.proj_info_idx2 ON bip.proj_info
(clicode)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PROJETSPE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.projetspe_pk ON bip.proj_spe
(codpspe)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PROPLUS_IDX2  (Index) 
--
CREATE INDEX bip.proplus_idx2 ON bip.proplus
(tires)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PROPLUS_IDX3  (Index) 
--
CREATE INDEX bip.proplus_idx3 ON bip.proplus
(pid)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PROPLUS_IDX4  (Index) 
--
CREATE INDEX bip.proplus_idx4 ON bip.proplus
(factpid)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PROPLUS_IDX5  (Index) 
--
CREATE INDEX bip.proplus_idx5 ON bip.proplus
(qualif)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PROPLUS_IDX6  (Index) 
--
CREATE INDEX bip.proplus_idx6 ON bip.proplus
(rtype)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PROPLUS_IDX7  (Index) 
--
CREATE INDEX bip.proplus_idx7 ON bip.proplus
(divsecgrou)
NOLOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PROPLUS_IDX1  (Index) 
--
CREATE INDEX bip.proplus_idx1 ON bip.proplus
(cdeb)
NOLOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PROPLUS_IDX8  (Index) 
--
CREATE INDEX bip.proplus_idx8 ON bip.proplus
(pdsg)
NOLOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PROPLUS_IDX9  (Index) 
--
CREATE INDEX bip.proplus_idx9 ON bip.proplus
(factpdsg)
NOLOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_REE_ACTIVITES  (Index) 
--
CREATE UNIQUE INDEX bip.pk_ree_activites ON bip.ree_activites
(codsg, code_activite)
LOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_REE_ACTIVITES_LIGNE_BIP  (Index) 
--
CREATE UNIQUE INDEX bip.pk_ree_activites_ligne_bip ON bip.ree_activites_ligne_bip
(codsg, code_activite, pid)
LOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_REE_REESTIME  (Index) 
--
CREATE UNIQUE INDEX bip.pk_ree_reestime ON bip.ree_reestime
(codsg, ident, cdeb, code_scenario, TYPE,
code_activite)
NOLOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_REE_RESSOURCES  (Index) 
--
CREATE UNIQUE INDEX bip.pk_ree_ressources ON bip.ree_ressources
(codsg, ident, TYPE)
LOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_REE_RESSOURCES_ACTIVITES  (Index) 
--
CREATE UNIQUE INDEX bip.pk_ree_ressources_activites ON bip.ree_ressources_activites
(codsg, ident, code_activite, TYPE)
LOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_REE_SCENARIOS  (Index) 
--
CREATE UNIQUE INDEX bip.pk_ree_scenarios ON bip.ree_scenarios
(codsg, code_scenario)
LOGGING
TABLESPACE tbs_bip_isac_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- REF_HISTO_PK  (Index) 
--
CREATE UNIQUE INDEX bip.ref_histo_pk ON bip.ref_histo
(mois)
LOGGING
TABLESPACE tbs_bip_his_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- REMONTEE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.remontee_pk ON bip.remontee
(pid, id_remonteur)
NOLOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- REPARTITION_LIGNE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.repartition_ligne_pk ON bip.repartition_ligne
(pid, codcamo, datdeb)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_REQUETE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_requete ON bip.requete
(nom_fichier)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- RESSOURCE_IDX2  (Index) 
--
CREATE INDEX bip.ressource_idx2 ON bip.ressource
(icodimm)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- RESSOURCE_IDX1  (Index) 
--
CREATE INDEX bip.ressource_idx1 ON bip.ressource
(rtype)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- RESSOURCE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.ressource_pk ON bip.ressource
(ident)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_RESSOURCE_ECART  (Index) 
--
CREATE UNIQUE INDEX bip.pk_ressource_ecart ON bip.ressource_ecart
(ident, cdeb, TYPE)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_RESSOURCE_ECART_1  (Index) 
--
CREATE UNIQUE INDEX bip.pk_ressource_ecart_1 ON bip.ressource_ecart_1
(ident, cdeb, TYPE)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_RJH_CHARGEMENT  (Index) 
--
CREATE UNIQUE INDEX bip.pk_rjh_chargement ON bip.rjh_chargement
(codchr)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_RJH_CHARGEMENT_ERREUR  (Index) 
--
CREATE UNIQUE INDEX bip.pk_rjh_chargement_erreur ON bip.rjh_charg_erreur
(codchr, numligne)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_RJH_CONSOMME  (Index) 
--
CREATE UNIQUE INDEX bip.pk_rjh_consomme ON bip.rjh_consomme
(pid, ident, cdeb, pid_origine)
NOLOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- RJH_IAS_PK  (Index) 
--
CREATE UNIQUE INDEX bip.rjh_ias_pk ON bip.rjh_ias
(pid, ident, cdeb)
NOLOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_RJH_TABREPART  (Index) 
--
CREATE UNIQUE INDEX bip.pk_rjh_tabrepart ON bip.rjh_tabrepart
(codrep)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_RJH_TABREPART_DETAIL  (Index) 
--
CREATE UNIQUE INDEX bip.pk_rjh_tabrepart_detail ON bip.rjh_tabrepart_detail
(codrep, moisrep, pid, typtab)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_RTFE_LOG  (Index) 
--
CREATE UNIQUE INDEX bip.pk_rtfe_log ON bip.rtfe_log
(user_rtfe, mois)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_RUBRIQUE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_rubrique ON bip.rubrique
(codrub)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- IDX_RUBRIQUE  (Index) 
--
CREATE INDEX bip.idx_rubrique ON bip.rubrique
(cafi)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_RUBRIQUE_UNIQUE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_rubrique_unique ON bip.rubrique
(codfei, cafi)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- IDX_RUBRIQUE_METIER  (Index) 
--
CREATE INDEX bip.idx_rubrique_metier ON bip.rubrique_metier
(codep, codfei)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_RUBRIQUE_METIER  (Index) 
--
CREATE UNIQUE INDEX bip.pk_rubrique_metier ON bip.rubrique_metier
(codep, codfei, metier)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k 
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- SITU_RESS_IDX1  (Index) 
--
CREATE INDEX bip.situ_ress_idx1 ON bip.situ_ress
(soccode)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- SITU_RESS_IDX2  (Index) 
--
CREATE INDEX bip.situ_ress_idx2 ON bip.situ_ress
(codsg)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- SITURESS_PK  (Index) 
--
CREATE UNIQUE INDEX bip.situress_pk ON bip.situ_ress
(ident, datsitu)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- SITU_RESS_FULL_IDX2  (Index) 
--
CREATE INDEX bip.situ_ress_full_idx2 ON bip.situ_ress_full
(cpident)
NOLOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- SITU_RESS_FULL_IDX1  (Index) 
--
CREATE INDEX bip.situ_ress_full_idx1 ON bip.situ_ress_full
(ident)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- SOCIETE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.societe_pk ON bip.societe
(soccode)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- SOUS_TYPOLOGIE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.sous_typologie_pk ON bip.sous_typologie
(sous_type)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- SSTRT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.sstrt_pk ON bip.sstrt
(pid, ecet, acta, acst, tires,
cdeb)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_STAT_PAGE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_stat_page ON bip.stat_page
(id_menu, id_page)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- STOCK_FI_IDX1  (Index) 
--
CREATE INDEX bip.stock_fi_idx1 ON bip.stock_fi
(pid, codsgress, codcamo, cafi)
NOLOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- STOCK_FI_PK  (Index) 
--
CREATE UNIQUE INDEX bip.stock_fi_pk ON bip.stock_fi
(cdeb, pid, ident, codcamo, cafi)
NOLOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- STOCK_FI_1_PK  (Index) 
--
CREATE UNIQUE INDEX bip.stock_fi_1_pk ON bip.stock_fi_1
(cdeb, pid, ident, codcamo, cafi)
NOLOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- STOCK_FI_DEC_PK  (Index) 
--
CREATE UNIQUE INDEX bip.stock_fi_dec_pk ON bip.stock_fi_dec
(cdeb, pid, ident, codcamo, cafi)
NOLOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- STOCK_FI_MULTI_PK  (Index) 
--
CREATE UNIQUE INDEX bip.stock_fi_multi_pk ON bip.stock_fi_multi
(cdeb, pid, ident, codcamo, cafi)
LOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- STOCK_IMMO_IDX1  (Index) 
--
CREATE INDEX bip.stock_immo_idx1 ON bip.stock_immo
(pid, codsgress, codcamo, cafi)
LOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- STOCK_IMMO_PK  (Index) 
--
CREATE UNIQUE INDEX bip.stock_immo_pk ON bip.stock_immo
(cdeb, pid, ident, icpi, cafi,
codcamo)
LOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- STOCK_IMMO_1_PK  (Index) 
--
CREATE UNIQUE INDEX bip.stock_immo_1_pk ON bip.stock_immo_1
(cdeb, pid, ident, icpi, cafi,
codcamo)
LOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- STOCK_RA_PK  (Index) 
--
CREATE UNIQUE INDEX bip.stock_ra_pk ON bip.stock_ra
(factpid, pid, cdeb, codcamo, ecet,
acta, acst, cafi, ident)
NOLOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- STOCK_RA_1_PK  (Index) 
--
CREATE UNIQUE INDEX bip.stock_ra_1_pk ON bip.stock_ra_1
(factpid, pid, cdeb, codcamo, ecet,
acta, acst, cafi, ident)
NOLOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- STRUCTINFO_PK  (Index) 
--
CREATE UNIQUE INDEX bip.structinfo_pk ON bip.struct_info
(codsg)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_SUIVIJHR  (Index) 
--
CREATE UNIQUE INDEX bip.pk_suivijhr ON bip.suivijhr
(dpg)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          512k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- SYNTHESE_ACTIVITE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.synthese_activite_pk ON bip.synthese_activite
(pid, annee)
LOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- SYNTHESE_ACTIVITE_MOIS_PK  (Index) 
--
CREATE UNIQUE INDEX bip.synthese_activite_mois_pk ON bip.synthese_activite_mois
(pid, cdeb)
LOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- SYNTHESE_FIN_PK  (Index) 
--
CREATE UNIQUE INDEX bip.synthese_fin_pk ON bip.synthese_fin
(annee, pid, codcamo, cafi, codsgress)
LOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- SYNTHESE_FIN_BIP_PK  (Index) 
--
CREATE UNIQUE INDEX bip.synthese_fin_bip_pk ON bip.synthese_fin_bip
(annee, pid)
LOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- SYNTHESE_FIN_RESS_PK  (Index) 
--
CREATE UNIQUE INDEX bip.synthese_fin_ress_pk ON bip.synthese_fin_ress
(pid, ident, codcamo, cafi)
LOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             512k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TACHE_IDX1  (Index) 
--
CREATE INDEX bip.tache_idx1 ON bip.tache
(aistpid, aistty)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TACHE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.tache_pk ON bip.tache
(pid, ecet, acta, acst)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TACHE_BACK_PK  (Index) 
--
CREATE UNIQUE INDEX bip.tache_back_pk ON bip.tache_back
(acta, acst, pid, ecet)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TACHE_REJET_DATESTATUT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.tache_rejet_datestatut_pk ON bip.tache_rejet_datestatut
(acta, acst, pid, ecet)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TAUX_CHARGE_SALARIALE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.taux_charge_salariale_pk ON bip.taux_charge_salariale
(annee)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_TAUX_RECUP  (Index) 
--
CREATE UNIQUE INDEX bip.pk_taux_recup ON bip.taux_recup
(annee, filcode)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TMP_APPLI_IDX1  (Index) 
--
CREATE INDEX bip.tmp_appli_idx1 ON bip.tmp_appli
(airt)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TMP_BUDGET_SSTACHE_IDX2  (Index) 
--
CREATE INDEX bip.tmp_budget_sstache_idx2 ON bip.tmp_budget_sstache
(pid)
NOLOGGING
TABLESPACE tbs_bip_tmp_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- FAIR_PK  (Index) 
--
CREATE UNIQUE INDEX bip.fair_pk ON bip.tmp_fair
(ident, date_crea, pid)
NOLOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          2m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_TMP_IMMEUBLE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_tmp_immeuble ON bip.tmp_immeuble
(iadrabr)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TMP_IMMEUBLE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.tmp_immeuble_pk ON bip.tmp_immeuble
(icodimm)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TMP_IMMO_PK  (Index) 
--
CREATE UNIQUE INDEX bip.tmp_immo_pk ON bip.tmp_immo
(cdeb, pid, ident)
LOGGING
TABLESPACE tbs_bip_ias_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TMP_IMP_NIVEAU_IDX1  (Index) 
--
CREATE INDEX bip.tmp_imp_niveau_idx1 ON bip.tmp_imp_niveau
(matricule)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TMP_PERSONNE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.tmp_personne_pk ON bip.tmp_personne
(matricule)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_TMP_RTFE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_tmp_rtfe ON bip.tmp_rtfe
(sgcustomid1)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             128k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TMP_SYNTHCOUTPROJ_IDX1  (Index) 
--
CREATE INDEX bip.tmp_synthcoutproj_idx1 ON bip.tmp_synthcoutproj
(dpcode, clicode, numseq)
LOGGING
TABLESPACE tbs_bip_tmp_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

--
-- TVA_PK  (Index) 
--
CREATE UNIQUE INDEX bip.tva_pk ON bip.tva
(tva)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TYPEACTIVITE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.typeactivite_pk ON bip.type_activite
(arctype)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TYPEAMORT_PK  (Index) 
--
CREATE UNIQUE INDEX bip.typeamort_pk ON bip.type_amort
(ctopact)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TYPE_DOMAINE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.type_domaine_pk ON bip.type_domaine
(code_domaine)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TYPEDOSSIERPROJET_PK  (Index) 
--
CREATE UNIQUE INDEX bip.typedossierprojet_pk ON bip.type_dossier_projet
(typdp)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TYPEETAPE_PK  (Index) 
--
CREATE UNIQUE INDEX bip.typeetape_pk ON bip.type_etape
(typetap)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TYPEPROJET_PK  (Index) 
--
CREATE UNIQUE INDEX bip.typeprojet_pk ON bip.type_projet
(typproj)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- TYPERESS_PK  (Index) 
--
CREATE UNIQUE INDEX bip.typeress_pk ON bip.type_ress
(rtype)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_TYPE_RUBRIQUE  (Index) 
--
CREATE UNIQUE INDEX bip.pk_type_rubrique ON bip.type_rubrique
(codep, codfei)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             64k 
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- VERSIONTP_PK  (Index) 
--
CREATE UNIQUE INDEX bip.versiontp_pk ON bip.version_tp
(numtp)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      50
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_BUDGET_ECART  (Index) 
--
CREATE UNIQUE INDEX BIP.PK_BUDGET_ECART ON BIP.BUDGET_ECART
(PID, TYPE, ANNEE)
LOGGING
TABLESPACE tbs_bip_ref_IDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             64K
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_BUDGET_ECART_1  (Index) 
--
CREATE UNIQUE INDEX BIP.PK_BUDGET_ECART_1 ON BIP.BUDGET_ECART_1
(PID, TYPE, ANNEE)
LOGGING
TABLESPACE tbs_bip_ref_IDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             64K
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_DEMANDE_VAL_FACTU  (Index) 
--
CREATE UNIQUE INDEX BIP.PK_DEMANDE_VAL_FACTU ON BIP.DEMANDE_VAL_FACTU
(IDDEM, SOCFACT, NUMFACT, TYPFACT, DATFACT, 
LNUM)
LOGGING
TABLESPACE tbs_bip_ref_IDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256K
            NEXT             128K
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

--
-- DEMANDE_VAL_FACTU_IDX2  (Index) 
--
CREATE INDEX BIP.DEMANDE_VAL_FACTU_IDX2 ON BIP.DEMANDE_VAL_FACTU
(IDENT_GDM)
LOGGING
TABLESPACE tbs_bip_ref_IDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             64K
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- DEMANDE_VAL_FACTU_IDX3  (Index) 
--
CREATE INDEX BIP.DEMANDE_VAL_FACTU_IDX3 ON BIP.DEMANDE_VAL_FACTU
(STATUT, DATDEM)
LOGGING
TABLESPACE tbs_bip_ref_IDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256K
            NEXT             128K
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

--
-- PK_MESSAGE_FORUM  (Index) 
--
CREATE UNIQUE INDEX BIP.PK_MESSAGE_FORUM ON BIP.MESSAGE_FORUM
(ID)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             64K
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- MF_MENU  (Index) 
--
CREATE INDEX BIP.MF_MENU ON BIP.MESSAGE_FORUM
(MENU)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             64K
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- MF_TEXTE_TITRE  (Index) 
--
CREATE INDEX BIP.MF_TEXTE_TITRE ON BIP.MESSAGE_FORUM
(TEXTE, TITRE)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             64K
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;



--
-- PK_MESSAGE_PERSONNEL  (Index) 
--
CREATE UNIQUE INDEX BIP.PK_MESSAGE_PERSONNEL ON BIP.MESSAGE_PERSONNEL
(CODE_MP)
LOGGING
TABLESPACE tbs_bip_ref_IDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             64K
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- MESSAGE_PERSONNEL_IDX2  (Index) 
--
CREATE INDEX BIP.MESSAGE_PERSONNEL_IDX2 ON BIP.MESSAGE_PERSONNEL
(IDENT, TYPE_MP)
LOGGING
TABLESPACE tbs_bip_ref_IDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             64K
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;



--
-- PK_PARAMETRE_LIGNE_BIP  (Index) 
--
CREATE UNIQUE INDEX BIP.PK_PARAMETRE_LIGNE_BIP ON BIP.PARAMETRE_LIGNE_BIP
(USERID, IDCPID)
LOGGING
TABLESPACE tbs_bip_ref_IDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             64K
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_PARAM_TYPE_LIGNE_BIP  (Index) 
--
CREATE UNIQUE INDEX BIP.PK_PARAM_TYPE_LIGNE_BIP ON BIP.PARAM_TYPE_LIGNE_BIP
(USERID, TYPPROJ)
LOGGING
TABLESPACE tbs_bip_ref_IDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             64K
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;




--
-- RESSOURCE_LOGS_PK  (Index) 
--
CREATE UNIQUE INDEX BIP.RESSOURCE_LOGS_PK ON BIP.RESSOURCE_LOGS
(IDENT, DATE_LOG, USER_LOG, NOM_TABLE, COLONNE)
LOGGING
TABLESPACE tbs_bip_ref_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256k
            NEXT             128K
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_RTFE_USER  (Index) 
--
CREATE UNIQUE INDEX BIP.PK_RTFE_USER ON BIP.RTFE_USER
(USER_RTFE)
LOGGING
TABLESPACE tbs_bip_batch_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1m
            NEXT             256k
            MINEXTENTS       1
            MAXEXTENTS       4000
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


--
-- PK_TMP_DISC_FORUM  (Index) 
--
CREATE UNIQUE INDEX BIP.PK_TMP_DISC_FORUM ON BIP.TMP_DISC_FORUM
(USER_RTFE, ID);



--
-- PK_TMP_DIVA_BUDGETS  (Index) 
--
CREATE UNIQUE INDEX BIP.PK_TMP_DIVA_BUDGETS ON BIP.TMP_DIVA_BUDGETS
(PID, ANNEE)
LOGGING
TABLESPACE tbs_bip_tmp_idx
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128k
            NEXT             64k
            MINEXTENTS       1
            MAXEXTENTS       500
            PCTINCREASE      1
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


