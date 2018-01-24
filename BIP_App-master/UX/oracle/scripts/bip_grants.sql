-- ============================================================
-- PROJET  - Script de creation des droits BIP
-- Date : 02/10/2006	
-- Auteur :  A. SAKHRAOUI
-- Version:	1
--
-- Modifications :
--	
--
-- ============================================================

-- ========================================================
-- bip_grants.sql
-- ========================================================


GRANT SELECT ON  bip.version_tp TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.version_tp TO bipu1;

GRANT SELECT ON  bip.type_rubrique TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.type_rubrique TO bipu1;

GRANT SELECT ON  bip.type_ress TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.type_ress TO bipu1;

GRANT SELECT ON  bip.type_projet TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.type_projet TO bipu1;

GRANT SELECT ON  bip.type_etape TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.type_etape TO bipu1;

GRANT SELECT ON  bip.type_dossier_projet TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.type_dossier_projet TO bipu1;

GRANT SELECT ON  bip.type_domaine TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.type_domaine TO bipu1;

GRANT SELECT ON  bip.type_amort TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.type_amort TO bipu1;

GRANT SELECT ON  bip.type_activite TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.type_activite TO bipu1;

GRANT SELECT ON  bip.tva TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.tva TO bipu1;

GRANT SELECT ON  bip.trait_asynchrone TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.trait_asynchrone TO bipu1;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.TOAD_PLAN_TABLE TO PUBLIC;

GRANT SELECT ON  bip.TOAD_PLAN_TABLE TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.toad_plan_sql TO PUBLIC;

GRANT SELECT ON  bip.toad_plan_sql TO role_bo;

GRANT SELECT ON  bip.tmpreftrans TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.tmpreftrans TO bipu1;

GRANT SELECT ON  bip.tmprapsynt TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.tmprapsynt TO bipu1;

GRANT SELECT ON  bip.tmpfe60 TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.tmpfe60 TO bipu1;

GRANT SELECT ON  bip.tmpedsstr TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.tmpedsstr TO bipu1;

GRANT SELECT ON  bip.tmp_visuprojprin TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.tmp_visuprojprin TO bipu1;

GRANT SELECT ON  bip.tmp_synthcoutproj TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.tmp_synthcoutproj TO bipu1;

GRANT SELECT ON  bip.tmp_situation TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.tmp_situation TO bipu1;

GRANT SELECT ON  bip.tmp_situ_ress TO role_bo;

GRANT SELECT ON  bip.tmp_saisie_realisee TO role_bo;

GRANT SELECT ON  bip.tmp_rtfe TO role_bo;

GRANT SELECT ON  bip.tmp_ressource TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.tmp_ressource TO bipu1;

GRANT SELECT ON  bip.tmp_rejetmens TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.tmp_rejetmens TO bipu1;

GRANT SELECT ON  bip.tmp_ree_detail TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.tmp_ree_detail TO bipu1;

GRANT SELECT ON  bip.tmp_personne TO role_bo;

GRANT SELECT ON  bip.tmp_oscar TO role_bo;

GRANT SELECT ON  bip.tmp_ligne_cont TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.tmp_ligne_cont TO bipu1;

GRANT SELECT ON  bip.tmp_imp_niveau_err TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.tmp_imp_niveau_err TO bipu1;

GRANT SELECT ON  bip.tmp_imp_niveau TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.tmp_imp_niveau TO bipu1;

GRANT SELECT ON  bip.tmp_immo TO role_bo;

GRANT SELECT ON  bip.tmp_immeuble TO role_bo;

GRANT SELECT ON  bip.tmp_fair TO role_bo;

GRANT SELECT ON  bip.tmp_factae TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.tmp_factae TO bipu1;

GRANT SELECT ON  bip.tmp_contrat TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.tmp_contrat TO bipu1;

GRANT SELECT ON  bip.tmp_conso_sstache TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.tmp_conso_sstache TO bipu1;

GRANT SELECT ON  bip.tmp_budget_sstache TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.tmp_budget_sstache TO bipu1;

GRANT SELECT ON  bip.tmp_appli_rejet TO role_bo;

GRANT SELECT ON  bip.tmp_appli_rejet TO bobip;

GRANT SELECT ON  bip.tmp_appli TO role_bo;

GRANT SELECT ON  bip.test_message TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.test_message TO bipu1;

GRANT SELECT ON  bip.taux_recup TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.taux_recup TO bipu1;

GRANT SELECT ON  bip.taux_charge_salariale TO role_bo;

GRANT SELECT ON  bip.tache_rejet_datestatut TO role_bo;

GRANT SELECT ON  bip.tache_back TO role_bo;

GRANT SELECT ON  bip.tache TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.tache TO bipu1;

GRANT SELECT ON  bip.synthese_fin_bip TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.synthese_fin_bip TO bipu1;

GRANT SELECT ON  bip.synthese_fin TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.synthese_fin TO bipu1;

GRANT SELECT ON  bip.synthese_activite_mois TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.synthese_activite_mois TO bipu1;

GRANT SELECT ON  bip.synthese_activite TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.synthese_activite TO bipu1;

GRANT SELECT ON  bip.suivijhr TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.suivijhr TO bipu1;

GRANT SELECT ON  bip.suivijhr TO bobip;

GRANT SELECT ON  bip.struct_info TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.struct_info TO bipu1;

GRANT SELECT ON  bip.stock_ra_1 TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.stock_ra_1 TO bipu1;

GRANT SELECT ON  bip.stock_ra TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.stock_ra TO bipu1;

GRANT SELECT ON  bip.stock_immo_1 TO role_bo;

GRANT SELECT ON  bip.stock_immo TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.stock_immo TO bipu1;

GRANT SELECT ON  bip.stock_fi_multi TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.stock_fi_multi TO bipu1;

GRANT SELECT ON  bip.stock_fi_dec TO role_bo;

GRANT SELECT ON  bip.stock_fi_1 TO role_bo;

GRANT SELECT ON  bip.stock_fi TO role_bo;

GRANT SELECT ON  bip.stock_fi TO bipu1;

GRANT SELECT ON  bip.stat_page TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.stat_page TO bipu1;

GRANT SELECT ON  bip.sstrt TO role_bo;

GRANT SELECT ON  bip.sql_requete TO role_bo;

GRANT SELECT ON  bip.sql_requete TO bipu1;

GRANT SELECT ON  bip.sous_typologie TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.sous_typologie TO bipu1;

GRANT SELECT ON  bip.societe TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.societe TO bipu1;

GRANT SELECT ON  bip.situ_ress_full TO role_bo;

GRANT SELECT ON  bip.situ_ress_full TO bipu1;

GRANT SELECT ON  bip.situ_ress TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.situ_ress TO bipu1;

GRANT SELECT ON  bip.rubrique_metier TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.rubrique_metier TO bipu1;

GRANT SELECT ON  bip.rubrique TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.rubrique TO bipu1;

GRANT SELECT ON  bip.rtfe_log TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.rtfe_log TO bipu1;

GRANT SELECT ON  bip.rtfe_error TO role_bo;

GRANT SELECT ON  bip.rtfe TO role_bo;

GRANT SELECT ON  bip.rjh_tabrepart_detail TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.rjh_tabrepart_detail TO bipu1;

GRANT SELECT ON  bip.rjh_tabrepart TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.rjh_tabrepart TO bipu1;

GRANT SELECT ON  bip.rjh_ias TO role_bo;

GRANT SELECT ON  bip.rjh_ias TO bobip;

GRANT SELECT ON  bip.rjh_consomme TO role_bo;

GRANT SELECT ON  bip.rjh_chargement TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.rjh_chargement TO bipu1;

GRANT SELECT ON  bip.rjh_charg_erreur TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.rjh_charg_erreur TO bipu1;

GRANT SELECT ON  bip.ressource_ecart_1 TO role_bo;

GRANT SELECT ON  bip.ressource_ecart TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.ressource_ecart TO bipu1;

GRANT SELECT ON  bip.ressource TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.ressource TO bipu1;

GRANT SELECT ON  bip.requete_profil TO role_bo;

GRANT SELECT ON  bip.requete_profil TO bipu1;

GRANT SELECT ON  bip.requete TO role_bo;

GRANT SELECT ON  bip.requete TO bipu1;

GRANT SELECT ON  bip.report_log TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.report_log TO bipu1;

GRANT SELECT ON  bip.repartition_ligne TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.repartition_ligne TO bipu1;

GRANT SELECT ON  bip.repartition_ligne TO bobip;

GRANT SELECT ON  bip.remontee TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.remontee TO bipu1;

GRANT SELECT ON  bip.ref_histo TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.ref_histo TO bipu1;

GRANT SELECT ON  bip.ree_scenarios TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.ree_scenarios TO bipu1;

GRANT SELECT ON  bip.ree_ressources_activites TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.ree_ressources_activites TO bipu1;

GRANT SELECT ON  bip.ree_ressources TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.ree_ressources TO bipu1;

GRANT SELECT ON  bip.ree_reestime TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.ree_reestime TO bipu1;

GRANT SELECT ON  bip.ree_activites_ligne_bip TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.ree_activites_ligne_bip TO bipu1;

GRANT SELECT ON  bip.ree_activites TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.ree_activites TO bipu1;

GRANT SELECT ON  bip.proplus TO role_bo;

GRANT SELECT ON  bip.proplus TO bipu1;

GRANT SELECT ON  bip.proplus TO bobip;

GRANT SELECT ON  bip.proj_spe TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.proj_spe TO bipu1;

GRANT SELECT ON  bip.proj_info TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.proj_info TO bipu1;

GRANT SELECT ON  bip.proj_info TO bobip;

GRANT SELECT ON  bip.prestation TO role_bo;

GRANT SELECT ON  bip.prestation TO bipu1;

GRANT SELECT ON  bip.poste TO role_bo;

GRANT DELETE, SELECT, UPDATE ON  bip.poste TO bipu1;

GRANT SELECT ON  bip.poste TO bobip;

GRANT SELECT ON  bip.pmw_ligne_bip TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.pmw_ligne_bip TO bipu1;

GRANT SELECT ON  bip.pmw_consomm TO role_bo;

GRANT SELECT ON  bip.pmw_affecta TO role_bo;

GRANT SELECT ON  bip.pmw_activite TO role_bo;

GRANT SELECT ON  bip.plan_table TO role_bo;

GRANT SELECT ON  bip.parametre TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.parametre TO bipu1;

GRANT SELECT ON  bip.notification_logs TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.notification_logs TO bipu1;

GRANT SELECT ON  bip.niveau TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.niveau TO bipu1;

GRANT SELECT ON  bip.niche TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.niche TO bipu1;

GRANT SELECT ON  bip.nature TO role_bo;

GRANT DELETE, SELECT, UPDATE ON  bip.nature TO bipu1;

GRANT SELECT ON  bip.nature TO bobip;

GRANT SELECT ON  bip.metier TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.metier TO bipu1;

GRANT SELECT ON  bip.MESSAGE TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.MESSAGE TO bipu1;

GRANT SELECT ON  bip.liste_table_histo TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.liste_table_histo TO bipu1;

GRANT SELECT ON  bip.ligne_realisation TO role_bo;

GRANT DELETE, SELECT, UPDATE ON  bip.ligne_realisation TO bipu1;

GRANT SELECT ON  bip.ligne_investissement TO role_bo;

GRANT DELETE, SELECT, UPDATE ON  bip.ligne_investissement TO bipu1;

GRANT SELECT ON  bip.ligne_fact TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.ligne_fact TO bipu1;

GRANT SELECT ON  bip.ligne_cont TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.ligne_cont TO bipu1;

GRANT SELECT ON  bip.ligne_bip2 TO role_bo;

GRANT SELECT ON  bip.ligne_bip_logs TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.ligne_bip_logs TO bipu1;

GRANT SELECT ON  bip.ligne_bip TO role_bo;

GRANT SELECT ON  bip.ligne_bip TO bipu1;

GRANT SELECT ON  bip.ligne_bip TO bobip;

GRANT SELECT ON  bip.lien_types_proj_act TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.lien_types_proj_act TO bipu1;

GRANT SELECT ON  bip.lien_types_proj_act TO bobip;

GRANT SELECT ON  bip.lien_profil_actu TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.lien_profil_actu TO bipu1;

GRANT SELECT ON  bip.jferie TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.jferie TO bipu1;

GRANT SELECT ON  bip.isac_tache TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.isac_tache TO bipu1;

GRANT SELECT ON  bip.isac_sous_tache TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.isac_sous_tache TO bipu1;

GRANT SELECT ON  bip.isac_message TO role_bo;

GRANT SELECT ON  bip.isac_etape TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.isac_etape TO bipu1;

GRANT SELECT ON  bip.isac_controle TO role_bo;

GRANT SELECT ON  bip.isac_consomme TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.isac_consomme TO bipu1;

GRANT SELECT ON  bip.isac_affectation TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.isac_affectation TO bipu1;

GRANT SELECT ON  bip.investissements TO role_bo;

GRANT DELETE, SELECT, UPDATE ON  bip.investissements TO bipu1;

GRANT SELECT ON  bip.investissements TO bobip;

GRANT SELECT ON  bip.import_compta_res TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.import_compta_res TO bipu1;

GRANT SELECT ON  bip.import_compta_log TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.import_compta_log TO bipu1;

GRANT SELECT ON  bip.import_compta_data TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.import_compta_data TO bipu1;

GRANT SELECT ON  bip.imp_oscar_tmp TO role_bo;

GRANT SELECT ON  bip.immeuble TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.immeuble TO bipu1;

GRANT SELECT ON  bip.ias TO role_bo;

GRANT SELECT ON  bip.histo_suivijhr TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.histo_suivijhr TO bipu1;

GRANT SELECT ON  bip.histo_stock_immo TO role_bo;

GRANT SELECT ON  bip.histo_stock_fi TO role_bo;

GRANT SELECT ON  bip.histo_ligne_fact TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.histo_ligne_fact TO bipu1;

GRANT SELECT ON  bip.histo_ligne_cont TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.histo_ligne_cont TO bipu1;

GRANT SELECT ON  bip.histo_facture TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.histo_facture TO bipu1;

GRANT SELECT ON  bip.histo_contrat TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.histo_contrat TO bipu1;

GRANT SELECT ON  bip.histo_amort TO role_bo;

GRANT SELECT ON  bip.histo_amort TO bipu1;

GRANT SELECT ON  bip.hispro TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.hispro TO bipu1;

GRANT SELECT ON  bip.filtre_requete TO role_bo;

GRANT SELECT ON  bip.filtre_requete TO bipu1;

GRANT SELECT ON  bip.filiale_cli TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.filiale_cli TO bipu1;

GRANT SELECT ON  bip.fichiers_rdf TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.fichiers_rdf TO bipu1;

GRANT SELECT ON  bip.fichier TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.fichier TO bipu1;

GRANT SELECT ON  bip.favoris TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.favoris TO bipu1;

GRANT SELECT ON  bip.facture TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.facture TO bipu1;

GRANT SELECT ON  bip.faccons_ressource TO role_bo;

GRANT SELECT ON  bip.faccons_ressource TO bipu1;

GRANT SELECT ON  bip.faccons_facture TO role_bo;

GRANT SELECT ON  bip.faccons_facture TO bipu1;

GRANT SELECT ON  bip.faccons_consomme TO role_bo;

GRANT SELECT ON  bip.faccons_consomme TO bipu1;

GRANT SELECT ON  bip.etape2 TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.etape2 TO bipu1;

GRANT SELECT ON  bip.etape_rejet_datestatut TO role_bo;

GRANT SELECT ON  bip.etape_back TO role_bo;

GRANT SELECT ON  bip.etape TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.etape TO bipu1;

GRANT SELECT ON  bip.esourcing_contrat TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.esourcing_contrat TO bipu1;

GRANT SELECT ON  bip.esourcing TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.esourcing TO bipu1;

GRANT SELECT ON  bip.entite_structure TO role_bo;

GRANT DELETE, SELECT, UPDATE ON  bip.entite_structure TO bipu1;

GRANT SELECT ON  bip.ensemble_applicatif TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.ensemble_applicatif TO bipu1;

GRANT SELECT ON  bip.dossier_projet TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.dossier_projet TO bipu1;

GRANT SELECT ON  bip.domaine_bancaire TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.domaine_bancaire TO bipu1;

GRANT SELECT ON  bip.directions TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.directions TO bipu1;

GRANT SELECT ON  bip.datdebex TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.datdebex TO bipu1;

GRANT SELECT ON  bip.cumul_conso TO role_bo;

GRANT SELECT ON  bip.cout_std2 TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.cout_std2 TO bipu1;

GRANT SELECT ON  bip.cout_std2 TO bobip;

GRANT SELECT ON  bip.cout_std_sg TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.cout_std_sg TO bipu1;

GRANT SELECT ON  bip.cout_std_sg TO bobip;

GRANT SELECT ON  bip.contrat TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.contrat TO bipu1;

GRANT SELECT ON  bip.consomme TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.consomme TO bipu1;

GRANT SELECT ON  bip.cons_sstres_rejet_datestatut TO role_bo;

GRANT SELECT ON  bip.cons_sstres_m_rejet_datestatut TO role_bo;

GRANT SELECT ON  bip.cons_sstache_res_mois_rejet TO role_bo;

GRANT ALTER, DELETE, INSERT, SELECT, UPDATE ON  bip.cons_sstache_res_mois_rejet TO bipu1;

GRANT SELECT ON  bip.cons_sstache_res_mois_back TO role_bo;

GRANT SELECT ON  bip.cons_sstache_res_mois_archive TO role_bo;

GRANT SELECT ON  bip.cons_sstache_res_mois TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.cons_sstache_res_mois TO bipu1;

GRANT SELECT ON  bip.cons_sstache_res_back TO role_bo;

GRANT SELECT ON  bip.cons_sstache_res TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.cons_sstache_res TO bipu1;

GRANT SELECT ON  bip.compte TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.compte TO bipu1;

GRANT SELECT ON  bip.compo_centre_frais TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.compo_centre_frais TO bipu1;

GRANT SELECT ON  bip.code_statut TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.code_statut TO bipu1;

GRANT SELECT ON  bip.code_compt TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.code_compt TO bipu1;

GRANT SELECT ON  bip.client_mo TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.client_mo TO bipu1;

GRANT SELECT ON  bip.charge_es_err TO role_bo;

GRANT SELECT ON  bip.charge_es TO role_bo;

GRANT SELECT ON  bip.charge_camo TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.charge_camo TO bipu1;

GRANT SELECT ON  bip.centre_frais TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.centre_frais TO bipu1;

GRANT SELECT ON  bip.centre_activite TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.centre_activite TO bipu1;

GRANT SELECT ON  bip.calendrier TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.calendrier TO bipu1;

GRANT SELECT ON  bip.budget_dp TO role_bo;

GRANT DELETE, INSERT, SELECT, UPDATE ON  bip.budget_dp TO bipu1;

GRANT SELECT ON  bip.budget TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.budget TO bipu1;

GRANT SELECT ON  bip.branches TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.branches TO bipu1;

GRANT SELECT ON  bip.bjh_type_absence TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.bjh_type_absence TO bipu1;

GRANT SELECT ON  bip.bjh_ressource TO role_bo;

GRANT SELECT ON  bip.bjh_ressource TO bipu1;

GRANT SELECT ON  bip.bjh_ressource TO bobip;

GRANT SELECT ON  bip.bjh_extgip TO role_bo;

GRANT SELECT ON  bip.bjh_extgip TO bipu1;

GRANT SELECT ON  bip.bjh_extgip TO bobip;

GRANT SELECT ON  bip.bjh_extbip TO role_bo;

GRANT SELECT ON  bip.bjh_extbip TO bipu1;

GRANT SELECT ON  bip.bjh_extbip TO bobip;

GRANT SELECT ON  bip.bjh_anomalies_temp TO role_bo;

GRANT SELECT ON  bip.bjh_anomalies TO role_bo;

GRANT SELECT ON  bip.bjh_anomalies TO bipu1;

GRANT SELECT ON  bip.bjh_anomalies TO bobip;

GRANT SELECT ON  bip.batch_tache_bad TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.batch_tache_bad TO bipu1;

GRANT SELECT ON  bip.batch_rejetsrp TO role_bo;

GRANT SELECT ON  bip.batch_rejet_datestatut TO role_bo;

GRANT SELECT ON  bip.batch_rejet_datestatut TO bobip;

GRANT SELECT ON  bip.batch_proplus_complus TO role_bo;

GRANT SELECT ON  bip.batch_hdla TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.batch_hdla TO bipu1;

GRANT SELECT ON  bip.batch_etape_bad TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.batch_etape_bad TO bipu1;

GRANT SELECT ON  bip.batch_cons_sstache_res_bad TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.batch_cons_sstache_res_bad TO bipu1;

GRANT SELECT ON  bip.batch_cons_sst_res_m_bad TO role_bo;

GRANT SELECT ON  bip.batch_charge_camo_bad TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.batch_charge_camo_bad TO bipu1;

GRANT SELECT ON  bip.audit_statut TO role_bo;

GRANT ALTER, DELETE, INSERT, SELECT, UPDATE ON  bip.audit_statut TO bipu1;

GRANT SELECT ON  bip.application TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.application TO bipu1;

GRANT SELECT ON  bip.agence TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.agence TO bipu1;

GRANT SELECT ON  bip.actualite TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.actualite TO bipu1;

GRANT SELECT ON  bip.abecedaire TO role_bo;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  bip.abecedaire TO bipu1;


GRANT SELECT ON  BIP.RESSOURCE_LOGS TO ROLE_BO;

GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON  BIP.RESSOURCE_LOGS TO BIPU1;


GRANT SELECT ON  BIP.RTFE_USER TO ROLE_BO;

