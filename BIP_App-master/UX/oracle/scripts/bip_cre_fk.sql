-- ============================================================
-- PROJET  - Script de creation des clés étrangères BIP
-- Date : 02/10/2006	
-- Auteur :  A. SAKHRAOUI
-- Version:	1
--
-- Modifications :
--	
--
-- ============================================================

-- ========================================================
-- bip_cre_fk.sql
-- ========================================================

-- 
-- Foreign Key Constraints for Table AGENCE 
-- 
ALTER TABLE bip.agence ADD (
  CONSTRAINT soccode_100 FOREIGN KEY (soccode)
    REFERENCES bip.societe (soccode));


-- 
-- Foreign Key Constraints for Table APPLICATION 
-- 
ALTER TABLE bip.application ADD (
  CONSTRAINT acdareg_166 FOREIGN KEY (acdareg)
    REFERENCES bip.application (airt));

ALTER TABLE bip.application ADD (
  CONSTRAINT clicode_159 FOREIGN KEY (clicode)
    REFERENCES bip.client_mo (clicode));

ALTER TABLE bip.application ADD (
  CONSTRAINT codgappli_162 FOREIGN KEY (codgappli)
    REFERENCES bip.client_mo (clicode));

ALTER TABLE bip.application ADD (
  CONSTRAINT codsg_158 FOREIGN KEY (codsg)
    REFERENCES bip.struct_info (codsg));


-- 
-- Foreign Key Constraints for Table AUDIT_STATUT 
-- 
ALTER TABLE bip.audit_statut ADD (
  CONSTRAINT audit_statut_pid_fk FOREIGN KEY (pid)
    REFERENCES bip.ligne_bip (pid)
    ON DELETE CASCADE);


-- 
-- Foreign Key Constraints for Table CENTRE_ACTIVITE 
-- 
ALTER TABLE bip.centre_activite ADD (
  CONSTRAINT ctopact_105 FOREIGN KEY (ctopact)
    REFERENCES bip.type_amort (ctopact));


-- 
-- Foreign Key Constraints for Table CENTRE_FRAIS 
-- 
ALTER TABLE bip.centre_frais ADD (
  CONSTRAINT filcode_centre_frais FOREIGN KEY (filcode)
    REFERENCES bip.filiale_cli (filcode));


-- 
-- Foreign Key Constraints for Table CLIENT_MO 
-- 
ALTER TABLE bip.client_mo ADD (
  CONSTRAINT filcode_106 FOREIGN KEY (filcode)
    REFERENCES bip.filiale_cli (filcode));


-- 
-- Foreign Key Constraints for Table CONS_SSTACHE_RES 
-- 
ALTER TABLE bip.cons_sstache_res ADD (
  CONSTRAINT cons_sstache_res_fk FOREIGN KEY (pid, ecet, acta, acst)
    REFERENCES bip.tache (pid,ecet,acta,acst));

ALTER TABLE bip.cons_sstache_res ADD (
  CONSTRAINT ident_107 FOREIGN KEY (ident)
    REFERENCES bip.ressource (ident));


-- 
-- Foreign Key Constraints for Table CONTRAT 
-- 
ALTER TABLE bip.contrat ADD (
  CONSTRAINT codsg_110 FOREIGN KEY (codsg)
    REFERENCES bip.struct_info (codsg));

ALTER TABLE bip.contrat ADD (
  CONSTRAINT comcode_112 FOREIGN KEY (comcode)
    REFERENCES bip.code_compt (comcode));

ALTER TABLE bip.contrat ADD (
  CONSTRAINT filcode_165 FOREIGN KEY (filcode)
    REFERENCES bip.filiale_cli (filcode));

ALTER TABLE bip.contrat ADD (
  CONSTRAINT niche_111 FOREIGN KEY (niche)
    REFERENCES bip.niche (niche));

ALTER TABLE bip.contrat ADD (
  CONSTRAINT soccont_114 FOREIGN KEY (soccont)
    REFERENCES bip.societe (soccode));


-- 
-- Foreign Key Constraints for Table COUT_STD_SG 
-- 
ALTER TABLE bip.cout_std_sg ADD (
  CONSTRAINT fk_cout_std_sg_metier FOREIGN KEY (metier)
    REFERENCES bip.metier (metier));

ALTER TABLE bip.cout_std_sg ADD (
  CONSTRAINT fk_cout_std_sg_niveau FOREIGN KEY (niveau)
    REFERENCES bip.niveau (niveau));


-- 
-- Foreign Key Constraints for Table DOMAINE_BANCAIRE 
-- 
ALTER TABLE bip.domaine_bancaire ADD (
  CONSTRAINT codea_150 FOREIGN KEY (cod_ea)
    REFERENCES bip.ensemble_applicatif (cod_ea));


-- 
-- Foreign Key Constraints for Table ETAPE 
-- 
ALTER TABLE bip.etape ADD (
  CONSTRAINT etape_pid_fk FOREIGN KEY (pid)
    REFERENCES bip.ligne_bip (pid));

ALTER TABLE bip.etape ADD (
  CONSTRAINT typetap_121 FOREIGN KEY (typetap)
    REFERENCES bip.type_etape (typetap));


-- 
-- Foreign Key Constraints for Table FACTURE 
-- 
ALTER TABLE bip.facture ADD (
  CONSTRAINT fcodcompta_173 FOREIGN KEY (fcodcompta)
    REFERENCES bip.code_compt (comcode));

ALTER TABLE bip.facture ADD (
  CONSTRAINT fdeppole_172 FOREIGN KEY (fdeppole)
    REFERENCES bip.struct_info (codsg));

ALTER TABLE bip.facture ADD (
  CONSTRAINT ftva_156 FOREIGN KEY (ftva)
    REFERENCES bip.tva (tva));

ALTER TABLE bip.facture ADD (
  CONSTRAINT socfact_123 FOREIGN KEY (socfact)
    REFERENCES bip.societe (soccode));


-- 
-- Foreign Key Constraints for Table HISTO_CONTRAT 
-- 
ALTER TABLE bip.histo_contrat ADD (
  CONSTRAINT comcode_mig FOREIGN KEY (comcode)
    REFERENCES bip.code_compt (comcode));


-- 
-- Foreign Key Constraints for Table INVESTISSEMENTS 
-- 
ALTER TABLE bip.investissements ADD (
  CONSTRAINT fk_codnature_inv FOREIGN KEY (codnature)
    REFERENCES bip.nature (codnature));

ALTER TABLE bip.investissements ADD (
  CONSTRAINT fk_codposte_inv FOREIGN KEY (codposte)
    REFERENCES bip.poste (codposte));


-- 
-- Foreign Key Constraints for Table ISAC_CONSOMME 
-- 
ALTER TABLE bip.isac_consomme ADD (
  CONSTRAINT fk_isac_consomme FOREIGN KEY (sous_tache, ident)
    REFERENCES bip.isac_affectation (sous_tache,ident));


-- 
-- Foreign Key Constraints for Table ISAC_SOUS_TACHE 
-- 
ALTER TABLE bip.isac_sous_tache ADD (
  CONSTRAINT fk_isac_sous_tache FOREIGN KEY (tache)
    REFERENCES bip.isac_tache (tache));


-- 
-- Foreign Key Constraints for Table ISAC_TACHE 
-- 
ALTER TABLE bip.isac_tache ADD (
  CONSTRAINT fk_isac_tache FOREIGN KEY (etape)
    REFERENCES bip.isac_etape (etape));


-- 
-- Foreign Key Constraints for Table LIEN_PROFIL_ACTU 
-- 
ALTER TABLE bip.lien_profil_actu ADD (
  CONSTRAINT fk_code_actu FOREIGN KEY (code_actu)
    REFERENCES bip.actualite (code_actu)
    ON DELETE CASCADE);


-- 
-- Foreign Key Constraints for Table LIEN_TYPES_PROJ_ACT 
-- 
ALTER TABLE bip.lien_types_proj_act ADD (
  CONSTRAINT fk_type_act FOREIGN KEY (type_act)
    REFERENCES bip.type_activite (arctype));

ALTER TABLE bip.lien_types_proj_act ADD (
  CONSTRAINT fk_type_proj FOREIGN KEY (type_proj)
    REFERENCES bip.type_projet (typproj));


-- 
-- Foreign Key Constraints for Table LIGNE_BIP 
-- 
ALTER TABLE bip.ligne_bip ADD (
  CONSTRAINT airt_133 FOREIGN KEY (airt)
    REFERENCES bip.application (airt));

ALTER TABLE bip.ligne_bip ADD (
  CONSTRAINT arctype_134 FOREIGN KEY (arctype)
    REFERENCES bip.type_activite (arctype));

ALTER TABLE bip.ligne_bip ADD (
  CONSTRAINT caamort_153 FOREIGN KEY (caamort)
    REFERENCES bip.centre_activite (codcamo));

ALTER TABLE bip.ligne_bip ADD (
  CONSTRAINT clicode_128 FOREIGN KEY (clicode_oper)
    REFERENCES bip.client_mo (clicode));

ALTER TABLE bip.ligne_bip ADD (
  CONSTRAINT clicode_132 FOREIGN KEY (clicode)
    REFERENCES bip.client_mo (clicode));

ALTER TABLE bip.ligne_bip ADD (
  CONSTRAINT codcamo_154 FOREIGN KEY (codcamo)
    REFERENCES bip.centre_activite (codcamo));

ALTER TABLE bip.ligne_bip ADD (
  CONSTRAINT codpspe_130 FOREIGN KEY (codpspe)
    REFERENCES bip.proj_spe (codpspe));

ALTER TABLE bip.ligne_bip ADD (
  CONSTRAINT codsg_131 FOREIGN KEY (codsg)
    REFERENCES bip.struct_info (codsg));

ALTER TABLE bip.ligne_bip ADD (
  CONSTRAINT dpcode_129 FOREIGN KEY (dpcode)
    REFERENCES bip.dossier_projet (dpcode));

ALTER TABLE bip.ligne_bip ADD (
  CONSTRAINT icpi_135 FOREIGN KEY (icpi)
    REFERENCES bip.proj_info (icpi));

ALTER TABLE bip.ligne_bip ADD (
  FOREIGN KEY (sous_type)
    REFERENCES bip.sous_typologie (sous_type));

ALTER TABLE bip.ligne_bip ADD (
  CONSTRAINT typproj_136 FOREIGN KEY (typproj)
    REFERENCES bip.type_projet (typproj));


-- 
-- Foreign Key Constraints for Table LIGNE_CONT 
-- 
ALTER TABLE bip.ligne_cont ADD (
  CONSTRAINT ident_138 FOREIGN KEY (ident)
    REFERENCES bip.ressource (ident));

ALTER TABLE bip.ligne_cont ADD (
  CONSTRAINT numcont_137 FOREIGN KEY (numcont, soccont, cav)
    REFERENCES bip.contrat (numcont,soccont,cav)
    ON DELETE CASCADE);


-- 
-- Foreign Key Constraints for Table LIGNE_FACT 
-- 
ALTER TABLE bip.ligne_fact ADD (
  CONSTRAINT codcamo_141 FOREIGN KEY (codcamo)
    REFERENCES bip.centre_activite (codcamo));

ALTER TABLE bip.ligne_fact ADD (
  CONSTRAINT ident_142 FOREIGN KEY (ident)
    REFERENCES bip.ressource (ident));

ALTER TABLE bip.ligne_fact ADD (
  CONSTRAINT lcodcompta_174 FOREIGN KEY (lcodcompta)
    REFERENCES bip.code_compt (comcode));

ALTER TABLE bip.ligne_fact ADD (
  CONSTRAINT ligne_fact_pid_fk FOREIGN KEY (pid)
    REFERENCES bip.ligne_bip (pid));

ALTER TABLE bip.ligne_fact ADD (
  CONSTRAINT numfact_139 FOREIGN KEY (socfact, numfact, typfact, datfact)
    REFERENCES bip.facture (socfact,numfact,typfact,datfact)
    ON DELETE CASCADE);


-- 
-- Foreign Key Constraints for Table LIGNE_INVESTISSEMENT 
-- 
ALTER TABLE bip.ligne_investissement ADD (
  CONSTRAINT fk_li_centre_activite FOREIGN KEY (codcamo)
    REFERENCES bip.centre_activite (codcamo));

ALTER TABLE bip.ligne_investissement ADD (
  CONSTRAINT fk_li_dossier_projet FOREIGN KEY (dpcode)
    REFERENCES bip.dossier_projet (dpcode));

ALTER TABLE bip.ligne_investissement ADD (
  CONSTRAINT fk_li_entite_structure FOREIGN KEY (codcamo)
    REFERENCES bip.entite_structure (codcamo));

ALTER TABLE bip.ligne_investissement ADD (
  CONSTRAINT fk_li_investissements FOREIGN KEY (TYPE)
    REFERENCES bip.investissements (codtype));

ALTER TABLE bip.ligne_investissement ADD (
  CONSTRAINT fk_li_proj_info FOREIGN KEY (icpi)
    REFERENCES bip.proj_info (icpi));


-- 
-- Foreign Key Constraints for Table LIGNE_REALISATION 
-- 
ALTER TABLE bip.ligne_realisation ADD (
  CONSTRAINT fk_lr_li FOREIGN KEY (codinv, annee, codcamo)
    REFERENCES bip.ligne_investissement (codinv,annee,codcamo));


-- 
-- Foreign Key Constraints for Table PARTENAIRE 
-- 
ALTER TABLE bip.partenaire ADD (
  CONSTRAINT fk_partenaire_societe FOREIGN KEY (soccode)
    REFERENCES bip.societe (soccode));


-- 
-- Foreign Key Constraints for Table PRESTATION 
-- 
ALTER TABLE bip.prestation ADD (
  CONSTRAINT domaine_148 FOREIGN KEY (code_domaine)
    REFERENCES bip.type_domaine (code_domaine));

ALTER TABLE bip.prestation ADD (
  CONSTRAINT rtype_148 FOREIGN KEY (rtype)
    REFERENCES bip.type_ress (rtype));


-- 
-- Foreign Key Constraints for Table PROJ_INFO 
-- 
ALTER TABLE bip.proj_info ADD (
  CONSTRAINT clicode_160 FOREIGN KEY (clicode)
    REFERENCES bip.client_mo (clicode));

ALTER TABLE bip.proj_info ADD (
  CONSTRAINT coddb_150 FOREIGN KEY (cod_db)
    REFERENCES bip.domaine_bancaire (cod_db));

ALTER TABLE bip.proj_info ADD (
  CONSTRAINT codsg_161 FOREIGN KEY (codsg)
    REFERENCES bip.struct_info (codsg));

ALTER TABLE bip.proj_info ADD (
  CONSTRAINT icpir_167 FOREIGN KEY (icpir)
    REFERENCES bip.proj_info (icpi));


-- 
-- Foreign Key Constraints for Table PROPLUS 
-- 
ALTER TABLE bip.proplus ADD (
  CONSTRAINT proplus_factpid_fk FOREIGN KEY (factpid)
    REFERENCES bip.ligne_bip (pid));

ALTER TABLE bip.proplus ADD (
  CONSTRAINT proplus_pid_fk FOREIGN KEY (pid)
    REFERENCES bip.ligne_bip (pid));


-- 
-- Foreign Key Constraints for Table REE_ACTIVITES 
-- 
ALTER TABLE bip.ree_activites ADD (
  CONSTRAINT fk_struct_info_ree_activites FOREIGN KEY (codsg)
    REFERENCES bip.struct_info (codsg)
    ON DELETE CASCADE);


-- 
-- Foreign Key Constraints for Table REE_ACTIVITES_LIGNE_BIP 
-- 
ALTER TABLE bip.ree_activites_ligne_bip ADD (
  CONSTRAINT fk_ligne_bip FOREIGN KEY (pid)
    REFERENCES bip.ligne_bip (pid)
    ON DELETE CASCADE);

ALTER TABLE bip.ree_activites_ligne_bip ADD (
  CONSTRAINT fk_ree_activites FOREIGN KEY (codsg, code_activite)
    REFERENCES bip.ree_activites (codsg,code_activite)
    ON DELETE CASCADE);


-- 
-- Foreign Key Constraints for Table REE_REESTIME 
-- 
ALTER TABLE bip.ree_reestime ADD (
  CONSTRAINT fk_ree_activites_reestime FOREIGN KEY (codsg, code_activite)
    REFERENCES bip.ree_activites (codsg,code_activite)
    ON DELETE CASCADE);

ALTER TABLE bip.ree_reestime ADD (
  CONSTRAINT fk_ree_ressources_reestime FOREIGN KEY (codsg, ident, TYPE)
    REFERENCES bip.ree_ressources (codsg,ident,TYPE)
    ON DELETE CASCADE);

ALTER TABLE bip.ree_reestime ADD (
  CONSTRAINT fk_ree_scenario_reestime FOREIGN KEY (codsg, code_scenario)
    REFERENCES bip.ree_scenarios (codsg,code_scenario)
    ON DELETE CASCADE);


-- 
-- Foreign Key Constraints for Table REE_RESSOURCES 
-- 
ALTER TABLE bip.ree_ressources ADD (
  CONSTRAINT fk_struct_info_ressources FOREIGN KEY (codsg)
    REFERENCES bip.struct_info (codsg)
    ON DELETE CASCADE);


-- 
-- Foreign Key Constraints for Table REE_RESSOURCES_ACTIVITES 
-- 
ALTER TABLE bip.ree_ressources_activites ADD (
  CONSTRAINT fk_ree_activites_ress FOREIGN KEY (codsg, code_activite)
    REFERENCES bip.ree_activites (codsg,code_activite)
    ON DELETE CASCADE);

ALTER TABLE bip.ree_ressources_activites ADD (
  CONSTRAINT fk_ree_ressources FOREIGN KEY (codsg, ident, TYPE)
    REFERENCES bip.ree_ressources (codsg,ident,TYPE)
    ON DELETE CASCADE);


-- 
-- Foreign Key Constraints for Table REE_SCENARIOS 
-- 
ALTER TABLE bip.ree_scenarios ADD (
  CONSTRAINT fk_struct_info FOREIGN KEY (codsg)
    REFERENCES bip.struct_info (codsg)
    ON DELETE CASCADE);


-- 
-- Foreign Key Constraints for Table REPARTITION_LIGNE 
-- 
ALTER TABLE bip.repartition_ligne ADD (
  CONSTRAINT codcamo_repartition_ligne_fk FOREIGN KEY (codcamo)
    REFERENCES bip.centre_activite (codcamo));

ALTER TABLE bip.repartition_ligne ADD (
  CONSTRAINT pid_repartition_ligne_fk FOREIGN KEY (pid)
    REFERENCES bip.ligne_bip (pid));


-- 
-- Foreign Key Constraints for Table REQUETE_PROFIL 
-- 
ALTER TABLE bip.requete_profil ADD (
  CONSTRAINT fk_requete_profil FOREIGN KEY (nom_fichier)
    REFERENCES bip.requete (nom_fichier)
    ON DELETE CASCADE);


-- 
-- Foreign Key Constraints for Table RESSOURCE 
-- 
ALTER TABLE bip.ressource ADD (
  CONSTRAINT icodimm_146 FOREIGN KEY (icodimm)
    REFERENCES bip.immeuble (icodimm));

ALTER TABLE bip.ressource ADD (
  CONSTRAINT rtype_147 FOREIGN KEY (rtype)
    REFERENCES bip.type_ress (rtype));


-- 
-- Foreign Key Constraints for Table RESSOURCE_ECART 
-- 
ALTER TABLE bip.ressource_ecart ADD (
  CONSTRAINT fk_ressource_ecart FOREIGN KEY (ident)
    REFERENCES bip.ressource (ident)
    ON DELETE CASCADE);


-- 
-- Foreign Key Constraints for Table RESSOURCE_ECART_1 
-- 
ALTER TABLE bip.ressource_ecart_1 ADD (
  CONSTRAINT fk_ressource_ecart_1 FOREIGN KEY (ident)
    REFERENCES bip.ressource (ident)
    ON DELETE CASCADE);


-- 
-- Foreign Key Constraints for Table RJH_CHARGEMENT 
-- 
ALTER TABLE bip.rjh_chargement ADD (
  CONSTRAINT fk_charg_tabrepart FOREIGN KEY (codrep)
    REFERENCES bip.rjh_tabrepart (codrep));


-- 
-- Foreign Key Constraints for Table RJH_CHARG_ERREUR 
-- 
ALTER TABLE bip.rjh_charg_erreur ADD (
  CONSTRAINT fk_chargerreur_charg FOREIGN KEY (codchr)
    REFERENCES bip.rjh_chargement (codchr));


-- 
-- Foreign Key Constraints for Table RJH_CONSOMME 
-- 
ALTER TABLE bip.rjh_consomme ADD (
  CONSTRAINT fk_rjhconsoori_lignebip FOREIGN KEY (pid_origine)
    REFERENCES bip.ligne_bip (pid));

ALTER TABLE bip.rjh_consomme ADD (
  CONSTRAINT fk_rjhconso_lignebip FOREIGN KEY (pid)
    REFERENCES bip.ligne_bip (pid));

ALTER TABLE bip.rjh_consomme ADD (
  CONSTRAINT fk_rjhconso_ressource FOREIGN KEY (ident)
    REFERENCES bip.ressource (ident));


-- 
-- Foreign Key Constraints for Table RJH_IAS 
-- 
ALTER TABLE bip.rjh_ias ADD (
  CONSTRAINT fk_rjhias_lignebip FOREIGN KEY (pid)
    REFERENCES bip.ligne_bip (pid));

ALTER TABLE bip.rjh_ias ADD (
  CONSTRAINT fk_rjhias_ressource FOREIGN KEY (ident)
    REFERENCES bip.ressource (ident));


-- 
-- Foreign Key Constraints for Table RJH_TABREPART 
-- 
ALTER TABLE bip.rjh_tabrepart ADD (
  CONSTRAINT fk_rjhtabrepart_directions FOREIGN KEY (coddir)
    REFERENCES bip.directions (coddir));


-- 
-- Foreign Key Constraints for Table RJH_TABREPART_DETAIL 
-- 
ALTER TABLE bip.rjh_tabrepart_detail ADD (
  CONSTRAINT fk_detail_tabrepart FOREIGN KEY (codrep)
    REFERENCES bip.rjh_tabrepart (codrep));

ALTER TABLE bip.rjh_tabrepart_detail ADD (
  CONSTRAINT fk_rjhdetail_lignebip FOREIGN KEY (pid)
    REFERENCES bip.ligne_bip (pid));


-- 
-- Foreign Key Constraints for Table RUBRIQUE 
-- 
ALTER TABLE bip.rubrique ADD (
  CONSTRAINT fk_rubrique_cafi FOREIGN KEY (cafi)
    REFERENCES bip.centre_activite (codcamo));

ALTER TABLE bip.rubrique ADD (
  CONSTRAINT fk_rubrique_coddir FOREIGN KEY (coddir)
    REFERENCES bip.directions (coddir));

ALTER TABLE bip.rubrique ADD (
  CONSTRAINT fk_rubrique_codep FOREIGN KEY (codep, codfei)
    REFERENCES bip.type_rubrique (codep,codfei));

ALTER TABLE bip.rubrique ADD (
  CONSTRAINT fk_rubrique_compte_cre FOREIGN KEY (comptecre)
    REFERENCES bip.compte (codcompte));

ALTER TABLE bip.rubrique ADD (
  CONSTRAINT fk_rubrique_compte_deb FOREIGN KEY (comptedeb)
    REFERENCES bip.compte (codcompte));


-- 
-- Foreign Key Constraints for Table RUBRIQUE_METIER 
-- 
ALTER TABLE bip.rubrique_metier ADD (
  CONSTRAINT fk_rubrique_codep_metier FOREIGN KEY (codep, codfei)
    REFERENCES bip.type_rubrique (codep,codfei));

ALTER TABLE bip.rubrique_metier ADD (
  CONSTRAINT fk_rubrique_metier_metier FOREIGN KEY (metier)
    REFERENCES bip.metier (metier));


-- 
-- Foreign Key Constraints for Table SITU_RESS 
-- 
ALTER TABLE bip.situ_ress ADD (
  CONSTRAINT codsg_148 FOREIGN KEY (codsg)
    REFERENCES bip.struct_info (codsg));

ALTER TABLE bip.situ_ress ADD (
  CONSTRAINT ident_150 FOREIGN KEY (ident)
    REFERENCES bip.ressource (ident));

ALTER TABLE bip.situ_ress ADD (
  CONSTRAINT soccode_149 FOREIGN KEY (soccode)
    REFERENCES bip.societe (soccode));


-- 
-- Foreign Key Constraints for Table SQL_REQUETE 
-- 
ALTER TABLE bip.sql_requete ADD (
  CONSTRAINT sql_requete_fk FOREIGN KEY (nom_fichier)
    REFERENCES bip.requete (nom_fichier)
    ON DELETE CASCADE);


-- 
-- Foreign Key Constraints for Table STRUCT_INFO 
-- 
ALTER TABLE bip.struct_info ADD (
  CONSTRAINT filcode_167 FOREIGN KEY (filcode)
    REFERENCES bip.filiale_cli (filcode));


-- 
-- Foreign Key Constraints for Table TACHE 
-- 
ALTER TABLE bip.tache ADD (
  CONSTRAINT tache_fk FOREIGN KEY (pid, ecet)
    REFERENCES bip.etape (pid,ecet));
    
   


-- 
-- Foreign Key Constraints for Table PARAMETRE_LIGNE_BIP 
-- 
ALTER TABLE BIP.PARAMETRE_LIGNE_BIP ADD (
  CONSTRAINT FK_PARAMETRE_LIGNE_BIP FOREIGN KEY (IDCPID) 
    REFERENCES BIP.CHAMP_LIGNE_BIP (IDCPID));


