-- ============================================================
-- PROJET  - Script de creation des clés BIP
-- Date : 02/10/2006	
-- Auteur :  A. SAKHRAOUI
-- Version:	1
--
-- Modifications :
--	
--
-- ============================================================

-- ========================================================
-- bip_cre_pk.sql
-- ========================================================
-- 
-- Non Foreign Key Constraints for Table ACTUALITE 
-- 
ALTER TABLE bip.actualite ADD (
  CONSTRAINT pk_actualite PRIMARY KEY (code_actu)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table AGENCE 
-- 
ALTER TABLE bip.agence ADD (
  CONSTRAINT agence_pk PRIMARY KEY (soccode, socfour)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table APPLICATION 
-- 
ALTER TABLE bip.application ADD (
  CONSTRAINT application_pk PRIMARY KEY (airt)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table AUDIT_STATUT 
-- 
ALTER TABLE bip.audit_statut ADD (
  CONSTRAINT audit_statut_pk PRIMARY KEY (pid)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          128k
                NEXT             64k
                MINEXTENTS       1
                MAXEXTENTS       4000
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ));


-- 
-- Non Foreign Key Constraints for Table BATCH_HDLA 
-- 
ALTER TABLE bip.batch_hdla ADD (
  PRIMARY KEY (pid)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table BJH_ANOMALIES 
-- 
ALTER TABLE bip.bjh_anomalies ADD (
  CONSTRAINT bjh_anomalies_pk PRIMARY KEY (matricule, mois, typeabsence)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table BRANCHES 
-- 
ALTER TABLE bip.branches ADD (
  CONSTRAINT branches_pk PRIMARY KEY (codbr)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table BUDGET 
-- 
ALTER TABLE bip.budget ADD (
  CONSTRAINT budget_pk PRIMARY KEY (pid, annee)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table BUDGET_DP 
-- 
ALTER TABLE bip.budget_dp ADD (
  CONSTRAINT pk_budget_dp PRIMARY KEY (annee, dpcode, clicode)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          512k
                NEXT             64k
                MINEXTENTS       1
                MAXEXTENTS       500
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ));


-- 
-- Non Foreign Key Constraints for Table CALENDRIER 
-- 
ALTER TABLE bip.calendrier ADD (
  CONSTRAINT calend_pk PRIMARY KEY (calanmois)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          256k
                NEXT             128k
                MINEXTENTS       1
                MAXEXTENTS       500
                PCTINCREASE      50
                FREELISTS        1
                FREELIST GROUPS  1
               ));


-- 
-- Non Foreign Key Constraints for Table CENTRE_ACTIVITE 
-- 
ALTER TABLE bip.centre_activite ADD (
  CHECK (             ctopamo IS NULL OR (ctopamo IN ('M','A'))));

ALTER TABLE bip.centre_activite ADD (
  CONSTRAINT centreactivite_pk PRIMARY KEY (codcamo)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table CENTRE_FRAIS 
-- 
ALTER TABLE bip.centre_frais ADD (
  CONSTRAINT pk_centre_frais PRIMARY KEY (codcfrais)
    USING INDEX
    TABLESPACE tbs_bip_fact_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table CLIENT_MO 
-- 
ALTER TABLE bip.client_mo ADD (
  CHECK (             clitopf IN ('F','O')));

ALTER TABLE bip.client_mo ADD (
  CONSTRAINT clientmo_pk PRIMARY KEY (clicode)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table CODE_COMPT 
-- 
ALTER TABLE bip.code_compt ADD (
  CHECK (             comtyp IN ('N','O')));

ALTER TABLE bip.code_compt ADD (
  CHECK (             comtyp IN ('N','O')));

ALTER TABLE bip.code_compt ADD (
  CONSTRAINT codecompt_pk PRIMARY KEY (comcode)
    USING INDEX
    TABLESPACE tbs_bip_fact_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table CODE_STATUT 
-- 
ALTER TABLE bip.code_statut ADD (
  CONSTRAINT codestatut_pk PRIMARY KEY (astatut)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          256k
                NEXT             128k
                MINEXTENTS       1
                MAXEXTENTS       500
                PCTINCREASE      50
                FREELISTS        1
                FREELIST GROUPS  1
               ));


-- 
-- Non Foreign Key Constraints for Table COMPO_CENTRE_FRAIS 
-- 
ALTER TABLE bip.compo_centre_frais ADD (
  CONSTRAINT pk_compo_centre_frais PRIMARY KEY (codcfrais, codbddpg, topfer)
    USING INDEX
    TABLESPACE tbs_bip_fact_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table COMPTE 
-- 
ALTER TABLE bip.compte ADD (
  CONSTRAINT pk_compte PRIMARY KEY (codcompte)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table CONSOMME 
-- 
ALTER TABLE bip.consomme ADD (
  CONSTRAINT consomme_pk PRIMARY KEY (pid, annee)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table CONS_SSTACHE_RES 
-- 
ALTER TABLE bip.cons_sstache_res ADD (
  CONSTRAINT cons_sstache_res_pk PRIMARY KEY (pid, ecet, acta, acst, ident)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table CONS_SSTACHE_RES_BACK 
-- 
ALTER TABLE bip.cons_sstache_res_back ADD (
  CONSTRAINT conssstacheres_back_pk PRIMARY KEY (pid, ecet, acta, acst, ident)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table CONS_SSTACHE_RES_MOIS 
-- 
ALTER TABLE bip.cons_sstache_res_mois ADD (
  CONSTRAINT conssstacheresmois_pk PRIMARY KEY (pid, ecet, acta, acst, ident, cdeb)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table CONS_SSTACHE_RES_MOIS_ARCHIVE 
-- 
ALTER TABLE bip.cons_sstache_res_mois_archive ADD (
  CONSTRAINT csstrm_archive_pk PRIMARY KEY (pid, ecet, acta, acst, ident, cdeb)
    USING INDEX
    TABLESPACE tbs_bip_his_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1m
                NEXT             256k
                MINEXTENTS       1
                MAXEXTENTS       1000
                PCTINCREASE      50
                FREELISTS        1
                FREELIST GROUPS  1
               ));


-- 
-- Non Foreign Key Constraints for Table CONS_SSTACHE_RES_MOIS_BACK 
-- 
ALTER TABLE bip.cons_sstache_res_mois_back ADD (
  CONSTRAINT conssstacheresmois_back_pk PRIMARY KEY (cdeb, pid, ecet, acta, acst, ident)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table CONS_SSTRES_M_REJET_DATESTATUT 
-- 
ALTER TABLE bip.cons_sstres_m_rejet_datestatut ADD (
  CONSTRAINT conssstresm_rej_datestatut_pk PRIMARY KEY (cdeb, pid, ecet, acta, acst, ident)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table CONS_SSTRES_REJET_DATESTATUT 
-- 
ALTER TABLE bip.cons_sstres_rejet_datestatut ADD (
  CONSTRAINT conssstres_rej_datestatut_pk PRIMARY KEY (pid, ecet, acta, acst, ident)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table CONTRAT 
-- 
ALTER TABLE bip.contrat ADD (
  CHECK (             cnaffair IN ('NON','OUI')));

ALTER TABLE bip.contrat ADD (
  CHECK (             cnaffair IN ('NON','OUI')));

ALTER TABLE bip.contrat ADD (
  CHECK (             cnaffair IN ('NON','OUI')));

ALTER TABLE bip.contrat ADD (
  CHECK (             cnaffair IN ('NON','OUI')));

ALTER TABLE bip.contrat ADD (
  CONSTRAINT contrat_pk PRIMARY KEY (numcont, soccont, cav)
    USING INDEX
    TABLESPACE tbs_bip_fact_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table COUT_STD2 
-- 
ALTER TABLE bip.cout_std2 ADD (
  CONSTRAINT cout_std2_pk PRIMARY KEY (annee, dpg_bas)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table COUT_STD_SG 
-- 
ALTER TABLE bip.cout_std_sg ADD (
  CONSTRAINT cout_std_sg_pk PRIMARY KEY (annee, niveau, metier, dpg_haut, dpg_bas)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table CUMUL_CONSO 
-- 
ALTER TABLE bip.cumul_conso ADD (
  CONSTRAINT cumul_conso_pk PRIMARY KEY (annee, pid)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table DIRECTIONS 
-- 
ALTER TABLE bip.directions ADD (
  CONSTRAINT directions_pk PRIMARY KEY (coddir)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table DOMAINE_BANCAIRE 
-- 
ALTER TABLE bip.domaine_bancaire ADD (
  CONSTRAINT domaine_bancaire_pk PRIMARY KEY (cod_db)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table DOSSIER_PROJET 
-- 
ALTER TABLE bip.dossier_projet ADD (
  CONSTRAINT dossierprojet_pk PRIMARY KEY (dpcode)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table ENSEMBLE_APPLICATIF 
-- 
ALTER TABLE bip.ensemble_applicatif ADD (
  CONSTRAINT ensemble_applicatif_pk PRIMARY KEY (cod_ea)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table ENTITE_STRUCTURE 
-- 
ALTER TABLE bip.entite_structure ADD (
  CONSTRAINT pk_entite_structure PRIMARY KEY (codcamo)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table ESOURCING_CONTRAT 
-- 
ALTER TABLE bip.esourcing_contrat ADD (
  CONSTRAINT esour_cont_pk PRIMARY KEY (id_oalia_cont, id_oalia_ligne, date_trait)
    USING INDEX
    TABLESPACE tbs_bip_fact_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table ETAPE 
-- 
ALTER TABLE bip.etape ADD (
  CONSTRAINT etape_pk PRIMARY KEY (pid, ecet)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table ETAPE2 
-- 
ALTER TABLE bip.etape2 ADD (
  CONSTRAINT etape2pk PRIMARY KEY (pid, ecet)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table ETAPE_BACK 
-- 
ALTER TABLE bip.etape_back ADD (
  CONSTRAINT etape_back_pk PRIMARY KEY (ecet, pid)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table ETAPE_REJET_DATESTATUT 
-- 
ALTER TABLE bip.etape_rejet_datestatut ADD (
  CONSTRAINT etape_rejet_datestatut_pk PRIMARY KEY (ecet, pid)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table FACTURE 
-- 
ALTER TABLE bip.facture ADD (
  CONSTRAINT facture_pk PRIMARY KEY (socfact, numfact, typfact, datfact)
    USING INDEX
    TABLESPACE tbs_bip_fact_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table FAVORIS 
-- 
ALTER TABLE bip.favoris ADD (
  CONSTRAINT pk_favoris PRIMARY KEY (iduser, menu, typefav, ordre)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table FICHIER 
-- 
ALTER TABLE bip.fichier ADD (
  PRIMARY KEY (idfic)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table FICHIERS_RDF 
-- 
ALTER TABLE bip.fichiers_rdf ADD (
  CONSTRAINT fichiers_rdf_pk PRIMARY KEY (fichier_rdf)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table FILIALE_CLI 
-- 
ALTER TABLE bip.filiale_cli ADD (
  CHECK (             top_immo IS NULL OR (top_immo IN ('N','O'))));

ALTER TABLE bip.filiale_cli ADD (
  CHECK (             top_sdff IS NULL OR (top_sdff IN ('N','O'))));

ALTER TABLE bip.filiale_cli ADD (
  CONSTRAINT filialecli_pk PRIMARY KEY (filcode)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table FILTRE_REQUETE 
-- 
ALTER TABLE bip.filtre_requete ADD (
  CONSTRAINT obligatoire_chk CHECK (obligatoire IN ('O', 'N', 'H')));

ALTER TABLE bip.filtre_requete ADD (
  CONSTRAINT pk_filtre_requete PRIMARY KEY (nom_fichier, code)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table HISTO_AMORT 
-- 
ALTER TABLE bip.histo_amort ADD (
  CONSTRAINT histoamortpc70_pk PRIMARY KEY (pid, aanhist)
    USING INDEX
    TABLESPACE  tbs_bip_his_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table HISTO_CONTRAT 
-- 
ALTER TABLE bip.histo_contrat ADD (
  CHECK (             cnaffair IN ('NON','OUI')));

ALTER TABLE bip.histo_contrat ADD (
  CHECK (             cnaffair IN ('NON','OUI')));

ALTER TABLE bip.histo_contrat ADD (
  CONSTRAINT histo_contrat_pk PRIMARY KEY (numcont, soccont, cav)
    USING INDEX
    TABLESPACE tbs_bip_his_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table HISTO_LIGNE_CONT 
-- 
ALTER TABLE bip.histo_ligne_cont ADD (
  CHECK (             lfraisdep IS NULL OR (lfraisdep IN ('N','O'))));

ALTER TABLE bip.histo_ligne_cont ADD (
  CHECK (             lastreinte IS NULL OR (lastreinte IN ('N','O'))));

ALTER TABLE bip.histo_ligne_cont ADD (
  CHECK (             lheursup IS NULL OR (lheursup IN ('N','O'))));

ALTER TABLE bip.histo_ligne_cont ADD (
  CONSTRAINT histo_lignecont_pk PRIMARY KEY (numcont, soccont, cav, lcnum)
    USING INDEX
    TABLESPACE tbs_bip_his_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table HISTO_LIGNE_FACT 
-- 
ALTER TABLE bip.histo_ligne_fact ADD (
  CONSTRAINT histo_lignefact_pk PRIMARY KEY (lnum, socfact, typfact, datfact, numfact)
    USING INDEX
    TABLESPACE tbs_bip_his_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table HISTO_SUIVIJHR 
-- 
ALTER TABLE bip.histo_suivijhr ADD (
  CONSTRAINT pk_histo_suivijhr PRIMARY KEY (codsg)
    USING INDEX
    TABLESPACE  tbs_bip_his_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table IAS 
-- 
ALTER TABLE bip.ias ADD (
  CONSTRAINT ias_pk PRIMARY KEY (cdeb, factpid, ident, typetap, pid)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table IMMEUBLE 
-- 
ALTER TABLE bip.immeuble ADD (
  CONSTRAINT immeuble_pk PRIMARY KEY (icodimm)
    USING INDEX
    TABLESPACE  tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table INVESTISSEMENTS 
-- 
ALTER TABLE bip.investissements ADD (
  CONSTRAINT pk_investissements PRIMARY KEY (codtype)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table ISAC_AFFECTATION 
-- 
ALTER TABLE bip.isac_affectation ADD (
  CONSTRAINT pk_isac_affectation PRIMARY KEY (sous_tache, ident)
    USING INDEX
    TABLESPACE tbs_bip_isac_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table ISAC_CONSOMME 
-- 
ALTER TABLE bip.isac_consomme ADD (
  CONSTRAINT pk_isac_consomme PRIMARY KEY (ident, sous_tache, cdeb)
    USING INDEX
    TABLESPACE tbs_bip_isac_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table ISAC_CONTROLE 
-- 
ALTER TABLE bip.isac_controle ADD (
  CONSTRAINT pk_isac_controle PRIMARY KEY (ID)
    USING INDEX
    TABLESPACE tbs_bip_isac_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table ISAC_ETAPE 
-- 
ALTER TABLE bip.isac_etape ADD (
  CONSTRAINT pk_isac_etape PRIMARY KEY (etape)
    USING INDEX
    TABLESPACE tbs_bip_isac_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table ISAC_MESSAGE 
-- 
ALTER TABLE bip.isac_message ADD (
  CONSTRAINT pk_isac_message PRIMARY KEY (id_msg)
    USING INDEX
    TABLESPACE tbs_bip_isac_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table ISAC_SOUS_TACHE 
-- 
ALTER TABLE bip.isac_sous_tache ADD (
  CONSTRAINT pk_isac_sous_tache PRIMARY KEY (sous_tache)
    USING INDEX
    TABLESPACE tbs_bip_isac_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table ISAC_TACHE 
-- 
ALTER TABLE bip.isac_tache ADD (
  CONSTRAINT pk_isac_tache PRIMARY KEY (tache)
    USING INDEX
    TABLESPACE tbs_bip_isac_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table JFERIE 
-- 
ALTER TABLE bip.jferie ADD (
  CONSTRAINT jferie_pk PRIMARY KEY (datjfer)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table LIEN_PROFIL_ACTU 
-- 
ALTER TABLE bip.lien_profil_actu ADD (
  CONSTRAINT lien_profil_actu_pk PRIMARY KEY (code_actu, code_profil)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table LIEN_TYPES_PROJ_ACT 
-- 
ALTER TABLE bip.lien_types_proj_act ADD (
  CONSTRAINT lien_types_proj_act_pk PRIMARY KEY (type_proj, type_act)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table LIGNE_BIP 
-- 
ALTER TABLE bip.ligne_bip ADD (
  CONSTRAINT ck_pcactop CHECK (pcactop IS NULL OR (pcactop IN ('F','O'))));

ALTER TABLE bip.ligne_bip ADD (
  CONSTRAINT topfer_ck CHECK (topfer IN ('O', 'N')));

ALTER TABLE bip.ligne_bip ADD (
  CONSTRAINT lignebip_pk PRIMARY KEY (pid)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5m
                NEXT             512k
                MINEXTENTS       1
                MAXEXTENTS       500
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ));


-- 
-- Non Foreign Key Constraints for Table LIGNE_BIP2 
-- 
ALTER TABLE bip.ligne_bip2 ADD (
  CONSTRAINT chk_pcactop CHECK (pcactop IS NULL OR (pcactop IN ('F','O'))));

ALTER TABLE bip.ligne_bip2 ADD (
  CONSTRAINT lignebip2pk PRIMARY KEY (pid)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table LIGNE_BIP_LOGS 
-- 
ALTER TABLE bip.ligne_bip_logs ADD (
  CONSTRAINT ligne_bip_logs_pk PRIMARY KEY (pid, date_log, user_log, colonne)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table LIGNE_CONT 
-- 
ALTER TABLE bip.ligne_cont ADD (
  CHECK (             lastreinte IS NULL OR (lastreinte IN ('N','O'))));

ALTER TABLE bip.ligne_cont ADD (
  CHECK (             lheursup IS NULL OR (lheursup IN ('N','O'))));

ALTER TABLE bip.ligne_cont ADD (
  CHECK (             lfraisdep IS NULL OR (lfraisdep IN ('N','O'))));

ALTER TABLE bip.ligne_cont ADD (
  CHECK (             lastreinte IS NULL OR (lastreinte IN ('N','O'))));

ALTER TABLE bip.ligne_cont ADD (
  CHECK (             lheursup IS NULL OR (lheursup IN ('N','O'))));

ALTER TABLE bip.ligne_cont ADD (
  CHECK (             lfraisdep IS NULL OR (lfraisdep IN ('N','O'))));

ALTER TABLE bip.ligne_cont ADD (
  CONSTRAINT lignecont_pk PRIMARY KEY (numcont, soccont, cav, lcnum)
    USING INDEX
    TABLESPACE tbs_bip_fact_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table LIGNE_FACT 
-- 
ALTER TABLE bip.ligne_fact ADD (
  CONSTRAINT lignefact_pk PRIMARY KEY (socfact, numfact, datfact, typfact, lnum)
    USING INDEX
    TABLESPACE tbs_bip_fact_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table LIGNE_INVESTISSEMENT 
-- 
ALTER TABLE bip.ligne_investissement ADD (
  CONSTRAINT pk_li PRIMARY KEY (codinv, annee, codcamo)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          2m
                NEXT             256k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ));


-- 
-- Non Foreign Key Constraints for Table LIGNE_REALISATION 
-- 
ALTER TABLE bip.ligne_realisation ADD (
  CONSTRAINT pk_ligne_realisation PRIMARY KEY (codrea, codinv, annee, codcamo)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          2m
                NEXT             256k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ));


-- 
-- Non Foreign Key Constraints for Table MESSAGE 
-- 
ALTER TABLE bip.MESSAGE ADD (
  CONSTRAINT message_pk PRIMARY KEY (id_msg)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table METIER 
-- 
ALTER TABLE bip.metier ADD (
  CONSTRAINT metier_pk PRIMARY KEY (metier)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table NATURE 
-- 
ALTER TABLE bip.nature ADD (
  CONSTRAINT pk_nature PRIMARY KEY (codnature)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table NICHE 
-- 
ALTER TABLE bip.niche ADD (
  CONSTRAINT niche_pk PRIMARY KEY (niche)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table NIVEAU 
-- 
ALTER TABLE bip.niveau ADD (
  CONSTRAINT niveau_pk PRIMARY KEY (niveau)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table PARAMETRE 
-- 
ALTER TABLE bip.parametre ADD (
  PRIMARY KEY (cle)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          256m
                NEXT             64k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ));


-- 
-- Non Foreign Key Constraints for Table PARTENAIRE 
-- 
ALTER TABLE bip.partenaire ADD (
  CONSTRAINT pk_partenaire PRIMARY KEY (coddep, soccode)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table POSTE 
-- 
ALTER TABLE bip.poste ADD (
  CONSTRAINT pk_poste PRIMARY KEY (codposte)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          512k
                NEXT             128k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ));


-- 
-- Non Foreign Key Constraints for Table PRESTATION 
-- 
ALTER TABLE bip.prestation ADD (
  CONSTRAINT pk_prestation PRIMARY KEY (prestation)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table PROJ_INFO 
-- 
ALTER TABLE bip.proj_info ADD (
  CONSTRAINT projinfo_pk PRIMARY KEY (icpi)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table PROJ_SPE 
-- 
ALTER TABLE bip.proj_spe ADD (
  CONSTRAINT projetspe_pk PRIMARY KEY (codpspe)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table REE_ACTIVITES 
-- 
ALTER TABLE bip.ree_activites ADD (
  CONSTRAINT pk_ree_activites PRIMARY KEY (codsg, code_activite)
    USING INDEX
    TABLESPACE tbs_bip_isac_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table REE_ACTIVITES_LIGNE_BIP 
-- 
ALTER TABLE bip.ree_activites_ligne_bip ADD (
  CONSTRAINT pk_ree_activites_ligne_bip PRIMARY KEY (codsg, code_activite, pid)
    USING INDEX
    TABLESPACE tbs_bip_isac_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table REE_REESTIME 
-- 
ALTER TABLE bip.ree_reestime ADD (
  CONSTRAINT pk_ree_reestime PRIMARY KEY (codsg, ident, cdeb, code_scenario, TYPE, code_activite)
    USING INDEX
    TABLESPACE tbs_bip_isac_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table REE_RESSOURCES 
-- 
ALTER TABLE bip.ree_ressources ADD (
  CONSTRAINT pk_ree_ressources PRIMARY KEY (codsg, ident, TYPE)
    USING INDEX
    TABLESPACE tbs_bip_isac_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table REE_RESSOURCES_ACTIVITES 
-- 
ALTER TABLE bip.ree_ressources_activites ADD (
  CONSTRAINT pk_ree_ressources_activites PRIMARY KEY (codsg, ident, code_activite, TYPE)
    USING INDEX
    TABLESPACE tbs_bip_isac_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table REE_SCENARIOS 
-- 
ALTER TABLE bip.ree_scenarios ADD (
  CONSTRAINT pk_ree_scenarios PRIMARY KEY (codsg, code_scenario)
    USING INDEX
    TABLESPACE tbs_bip_isac_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table REF_HISTO 
-- 
ALTER TABLE bip.ref_histo ADD (
  CONSTRAINT ref_histo_pk PRIMARY KEY (mois)
    USING INDEX
    TABLESPACE tbs_bip_his_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table REMONTEE 
-- 
ALTER TABLE bip.remontee ADD (
  CONSTRAINT remontee_pk PRIMARY KEY (pid, id_remonteur)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table REPARTITION_LIGNE 
-- 
ALTER TABLE bip.repartition_ligne ADD (
  CONSTRAINT repartition_ligne_pk PRIMARY KEY (pid, codcamo, datdeb)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table REQUETE 
-- 
ALTER TABLE bip.requete ADD (
  CONSTRAINT pk_requete PRIMARY KEY (nom_fichier)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table RESSOURCE 
-- 
ALTER TABLE bip.ressource ADD (
  CONSTRAINT ressource_pk PRIMARY KEY (ident)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table RESSOURCE_ECART 
-- 
ALTER TABLE bip.ressource_ecart ADD (
  CONSTRAINT pk_ressource_ecart PRIMARY KEY (ident, cdeb, TYPE)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table RESSOURCE_ECART_1 
-- 
ALTER TABLE bip.ressource_ecart_1 ADD (
  CONSTRAINT pk_ressource_ecart_1 PRIMARY KEY (ident, cdeb, TYPE)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table RJH_CHARGEMENT 
-- 
ALTER TABLE bip.rjh_chargement ADD (
  CONSTRAINT pk_rjh_chargement PRIMARY KEY (codchr)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table RJH_CHARG_ERREUR 
-- 
ALTER TABLE bip.rjh_charg_erreur ADD (
  CONSTRAINT pk_rjh_chargement_erreur PRIMARY KEY (codchr, numligne)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table RJH_CONSOMME 
-- 
ALTER TABLE bip.rjh_consomme ADD (
  CONSTRAINT pk_rjh_consomme PRIMARY KEY (pid, ident, cdeb, pid_origine)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table RJH_IAS 
-- 
ALTER TABLE bip.rjh_ias ADD (
  CONSTRAINT rjh_ias_pk PRIMARY KEY (pid, ident, cdeb)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table RJH_TABREPART 
-- 
ALTER TABLE bip.rjh_tabrepart ADD (
  CONSTRAINT pk_rjh_tabrepart PRIMARY KEY (codrep)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table RJH_TABREPART_DETAIL 
-- 
ALTER TABLE bip.rjh_tabrepart_detail ADD (
  CONSTRAINT pk_rjh_tabrepart_detail PRIMARY KEY (codrep, moisrep, pid, typtab)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table RTFE_LOG 
-- 
ALTER TABLE bip.rtfe_log ADD (
  CONSTRAINT pk_rtfe_log PRIMARY KEY (user_rtfe, mois)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table RUBRIQUE 
-- 
ALTER TABLE bip.rubrique ADD (
  CONSTRAINT pk_rubrique PRIMARY KEY (codrub)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table RUBRIQUE_METIER 
-- 
ALTER TABLE bip.rubrique_metier ADD (
  CONSTRAINT pk_rubrique_metier PRIMARY KEY (codep, codfei, metier)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table SITU_RESS 
-- 
ALTER TABLE bip.situ_ress ADD (
  CONSTRAINT situress_pk PRIMARY KEY (ident, datsitu)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5m
                NEXT             256k
                MINEXTENTS       1
                MAXEXTENTS       500
                PCTINCREASE      50
                FREELISTS        1
                FREELIST GROUPS  1
               ));


-- 
-- Non Foreign Key Constraints for Table SOCIETE 
-- 
ALTER TABLE bip.societe ADD (
  CONSTRAINT societe_pk PRIMARY KEY (soccode)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table SOUS_TYPOLOGIE 
-- 
ALTER TABLE bip.sous_typologie ADD (
  CONSTRAINT sous_typologie_pk PRIMARY KEY (sous_type)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table SSTRT 
-- 
ALTER TABLE bip.sstrt ADD (
  CONSTRAINT sstrt_pk PRIMARY KEY (pid, ecet, acta, acst, tires, cdeb)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table STAT_PAGE 
-- 
ALTER TABLE bip.stat_page ADD (
  CONSTRAINT pk_stat_page PRIMARY KEY (id_menu, id_page)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table STOCK_FI 
-- 
ALTER TABLE bip.stock_fi ADD (
  CONSTRAINT stock_fi_pk PRIMARY KEY (cdeb, pid, ident, codcamo, cafi)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table STOCK_FI_1 
-- 
ALTER TABLE bip.stock_fi_1 ADD (
  CONSTRAINT stock_fi_1_pk PRIMARY KEY (cdeb, pid, ident, codcamo, cafi)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table STOCK_FI_DEC 
-- 
ALTER TABLE bip.stock_fi_dec ADD (
  CONSTRAINT stock_fi_dec_pk PRIMARY KEY (cdeb, pid, ident, codcamo, cafi)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table STOCK_FI_MULTI 
-- 
ALTER TABLE bip.stock_fi_multi ADD (
  CONSTRAINT stock_fi_multi_pk PRIMARY KEY (cdeb, pid, ident, codcamo, cafi)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table STOCK_IMMO 
-- 
ALTER TABLE bip.stock_immo ADD (
  CONSTRAINT stock_immo_pk PRIMARY KEY (cdeb, pid, ident, icpi, cafi, codcamo)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table STOCK_IMMO_1 
-- 
ALTER TABLE bip.stock_immo_1 ADD (
  CONSTRAINT stock_immo_1_pk PRIMARY KEY (cdeb, pid, ident, icpi, cafi, codcamo)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table STOCK_RA 
-- 
ALTER TABLE bip.stock_ra ADD (
  CONSTRAINT stock_ra_pk PRIMARY KEY (factpid, pid, cdeb, codcamo, ecet, acta, acst, cafi, ident)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table STOCK_RA_1 
-- 
ALTER TABLE bip.stock_ra_1 ADD (
  CONSTRAINT stock_ra_1_pk PRIMARY KEY (factpid, pid, cdeb, codcamo, ecet, acta, acst, cafi, ident)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table STRUCT_INFO 
-- 
ALTER TABLE bip.struct_info ADD (
  CONSTRAINT structinfo_pk PRIMARY KEY (codsg)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table SUIVIJHR 
-- 
ALTER TABLE bip.suivijhr ADD (
  CONSTRAINT pk_suivijhr PRIMARY KEY (dpg)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table SYNTHESE_ACTIVITE 
-- 
ALTER TABLE bip.synthese_activite ADD (
  CONSTRAINT synthese_activite_pk PRIMARY KEY (pid, annee)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table SYNTHESE_ACTIVITE_MOIS 
-- 
ALTER TABLE bip.synthese_activite_mois ADD (
  CONSTRAINT synthese_activite_mois_pk PRIMARY KEY (pid, cdeb)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table SYNTHESE_FIN 
-- 
ALTER TABLE bip.synthese_fin ADD (
  CONSTRAINT synthese_fin_pk PRIMARY KEY (annee, pid, codcamo, cafi, codsgress)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table SYNTHESE_FIN_BIP 
-- 
ALTER TABLE bip.synthese_fin_bip ADD (
  CONSTRAINT synthese_fin_bip_pk PRIMARY KEY (annee, pid)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table SYNTHESE_FIN_RESS 
-- 
ALTER TABLE bip.synthese_fin_ress ADD (
  CONSTRAINT synthese_fin_ress_pk PRIMARY KEY (pid, ident, codcamo, cafi)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TACHE 
-- 
ALTER TABLE bip.tache ADD (
  CONSTRAINT tache_pk PRIMARY KEY (pid, ecet, acta, acst)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TACHE_BACK 
-- 
ALTER TABLE bip.tache_back ADD (
  CONSTRAINT tache_back_pk PRIMARY KEY (acta, acst, pid, ecet)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TACHE_REJET_DATESTATUT 
-- 
ALTER TABLE bip.tache_rejet_datestatut ADD (
  CONSTRAINT tache_rejet_datestatut_pk PRIMARY KEY (acta, acst, pid, ecet)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TAUX_CHARGE_SALARIALE 
-- 
ALTER TABLE bip.taux_charge_salariale ADD (
  CONSTRAINT taux_charge_salariale_pk PRIMARY KEY (annee)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          512k
                NEXT             64k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ));


-- 
-- Non Foreign Key Constraints for Table TAUX_RECUP 
-- 
ALTER TABLE bip.taux_recup ADD (
  CONSTRAINT pk_taux_recup PRIMARY KEY (annee, filcode)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          512k
                NEXT             64k
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ));


-- 
-- Non Foreign Key Constraints for Table TMP_FAIR 
-- 
ALTER TABLE bip.tmp_fair ADD (
  CONSTRAINT fair_pk PRIMARY KEY (ident, date_crea, pid)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TMP_IMMEUBLE 
-- 
ALTER TABLE bip.tmp_immeuble ADD (
  CONSTRAINT tmp_immeuble_pk PRIMARY KEY (icodimm)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TMP_IMMO 
-- 
ALTER TABLE bip.tmp_immo ADD (
  CONSTRAINT tmp_immo_pk PRIMARY KEY (cdeb, pid, ident)
    USING INDEX
    TABLESPACE tbs_bip_ias_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TMP_PERSONNE 
-- 
ALTER TABLE bip.tmp_personne ADD (
  CONSTRAINT tmp_personne_pk PRIMARY KEY (matricule)
    USING INDEX
    TABLESPACE tbs_bip_batch_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TMP_VISUPROJPRIN 
-- 
ALTER TABLE bip.tmp_visuprojprin ADD (
  CONSTRAINT sys_c003746 CHECK (
            typeb IN ('A','B','C','D','E','F','G','H','I','J')));


-- 
-- Non Foreign Key Constraints for Table TVA 
-- 
ALTER TABLE bip.tva ADD (
  CONSTRAINT tva_pk PRIMARY KEY (tva)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TYPE_ACTIVITE 
-- 
ALTER TABLE bip.type_activite ADD (
  CONSTRAINT typeactivite_pk PRIMARY KEY (arctype)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TYPE_AMORT 
-- 
ALTER TABLE bip.type_amort ADD (
  CONSTRAINT typeamort_pk PRIMARY KEY (ctopact)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TYPE_DOMAINE 
-- 
ALTER TABLE bip.type_domaine ADD (
  CONSTRAINT type_domaine_pk PRIMARY KEY (code_domaine)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TYPE_DOSSIER_PROJET 
-- 
ALTER TABLE bip.type_dossier_projet ADD (
  CONSTRAINT typedossierprojet_pk PRIMARY KEY (typdp)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TYPE_ETAPE 
-- 
ALTER TABLE bip.type_etape ADD (
  CONSTRAINT typeetape_pk PRIMARY KEY (typetap)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TYPE_PROJET 
-- 
ALTER TABLE bip.type_projet ADD (
  CONSTRAINT typeprojet_pk PRIMARY KEY (typproj)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TYPE_RESS 
-- 
ALTER TABLE bip.type_ress ADD (
  CONSTRAINT typeress_pk PRIMARY KEY (rtype)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table TYPE_RUBRIQUE 
-- 
ALTER TABLE bip.type_rubrique ADD (
  CONSTRAINT pk_type_rubrique PRIMARY KEY (codep, codfei)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));


-- 
-- Non Foreign Key Constraints for Table VERSION_TP 
-- 
ALTER TABLE bip.version_tp ADD (
  CONSTRAINT versiontp_pk PRIMARY KEY (numtp)
    USING INDEX
    TABLESPACE tbs_bip_ref_data
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
               ));
               
               

-- 
-- Non Foreign Key Constraints for Table BUDGET_ECART 
-- 
ALTER TABLE BIP.BUDGET_ECART ADD (
  CONSTRAINT PK_BUDGET_ECART PRIMARY KEY (PID, TYPE, ANNEE)
    USING INDEX 
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1m
                NEXT             256K
                MINEXTENTS       1
                MAXEXTENTS       500
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ));



-- 
-- Non Foreign Key Constraints for Table BUDGET_ECART_1 
-- 
ALTER TABLE BIP.BUDGET_ECART_1 ADD (
  CONSTRAINT PK_BUDGET_ECART_1 PRIMARY KEY (PID, TYPE, ANNEE)
    USING INDEX 
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1m
                NEXT             256K
                MINEXTENTS       1
                MAXEXTENTS       500
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ));


-- 
-- Non Foreign Key Constraints for Table MESSAGE_FORUM 
-- 
ALTER TABLE BIP.MESSAGE_FORUM ADD (
  CONSTRAINT PK_MESSAGE_FORUM PRIMARY KEY (ID)
    USING INDEX 
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          512K
                NEXT             64K
                MINEXTENTS       1
                MAXEXTENTS       500
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ));



-- 
-- Non Foreign Key Constraints for Table MESSAGE_PERSONNEL 
-- 
ALTER TABLE BIP.MESSAGE_PERSONNEL ADD (
  CONSTRAINT PK_MESSAGE_PERSONNEL PRIMARY KEY (CODE_MP)
    USING INDEX 
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          512K
                NEXT             64K
                MINEXTENTS       1
                MAXEXTENTS       4000
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ));



-- 
-- Non Foreign Key Constraints for Table PARAMETRE_LIGNE_BIP 
-- 
ALTER TABLE BIP.PARAMETRE_LIGNE_BIP ADD (
  CONSTRAINT PK_PARAMETRE_LIGNE_BIP PRIMARY KEY (USERID, IDCPID)
    USING INDEX 
    TABLESPACE tbs_bip_ref_data
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
               ));

 
-- 
-- Non Foreign Key Constraints for Table DEMANDE_VAL_FACTU 
-- 
ALTER TABLE BIP.DEMANDE_VAL_FACTU ADD (
  CONSTRAINT PK_DEMANDE_VAL_FACTU PRIMARY KEY (IDDEM, SOCFACT, NUMFACT, TYPFACT, DATFACT, LNUM)
    USING INDEX 
    TABLESPACE tbs_bip_ref_data
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
               ));            
               
               
-- 
-- Non Foreign Key Constraints for Table PARAM_TYPE_LIGNE_BIP 
-- 
ALTER TABLE BIP.PARAM_TYPE_LIGNE_BIP ADD (
  CONSTRAINT PK_PARAM_TYPE_LIGNE_BIP PRIMARY KEY (USERID, TYPPROJ)
    USING INDEX 
    TABLESPACE tbs_bip_ref_data
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
               ));



-- 
-- Non Foreign Key Constraints for Table RESSOURCE_LOGS 
-- 
ALTER TABLE BIP.RESSOURCE_LOGS ADD (
  CONSTRAINT RESSOURCE_LOGS_PK PRIMARY KEY (IDENT, DATE_LOG, USER_LOG, NOM_TABLE, COLONNE)
    USING INDEX 
    TABLESPACE tbs_bip_ref_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          128K
                NEXT             64K
                MINEXTENTS       1
                MAXEXTENTS       500
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ));

-- 
-- Non Foreign Key Constraints for Table RJH_ALIM_CONSO_LOG 
-- 
ALTER TABLE BIP.RJH_ALIM_CONSO_LOG ADD (
  CONSTRAINT PK_RJH_ALIM_CONSO_LOG PRIMARY KEY (CODREP) DISABLE);


-- 
-- Non Foreign Key Constraints for Table RTFE_USER 
-- 
ALTER TABLE BIP.RTFE_USER ADD (
  CONSTRAINT PK_RTFE_USER PRIMARY KEY (USER_RTFE)
    USING INDEX 
    TABLESPACE tbs_bip_batch_data
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          1m
                NEXT             256K
                MINEXTENTS       1
                MAXEXTENTS       4000
                PCTINCREASE      1
                FREELISTS        1
                FREELIST GROUPS  1
               ));      
               
               

-- 
-- Non Foreign Key Constraints for Table TMP_DISC_FORUM 
-- 
ALTER TABLE BIP.TMP_DISC_FORUM ADD (
  CONSTRAINT PK_TMP_DISC_FORUM PRIMARY KEY (USER_RTFE, ID));


                        