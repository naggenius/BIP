-- ============================================================
-- PROJET  - Script de creation des synonymes BIP
-- Date : 02/10/2006	
-- Auteur :  A. SAKHRAOUI
-- Version:	1
--
-- Modifications :
--	
--
-- ============================================================

-- ========================================================
-- bip_cre_syno.sql
-- ========================================================



DROP SYNONYM bipu1.batch_tache_bad;

--
-- BATCH_TACHE_BAD  (Synonym) 
--
CREATE SYNONYM bipu1.batch_tache_bad FOR bip.batch_tache_bad;


DROP SYNONYM bipu1.code_statut;

--
-- CODE_STATUT  (Synonym) 
--
CREATE SYNONYM bipu1.code_statut FOR bip.code_statut;


DROP SYNONYM bipu1.etape;

--
-- ETAPE  (Synonym) 
--
CREATE SYNONYM bipu1.etape FOR bip.etape;


DROP SYNONYM bipu1.dossier_projet;

--
-- DOSSIER_PROJET  (Synonym) 
--
CREATE SYNONYM bipu1.dossier_projet FOR bip.dossier_projet;


DROP SYNONYM bipu1.datdebex;

--
-- DATDEBEX  (Synonym) 
--
CREATE SYNONYM bipu1.datdebex FOR bip.datdebex;


DROP SYNONYM bipu1.cons_sstache_res_mois;

--
-- CONS_SSTACHE_RES_MOIS  (Synonym) 
--
CREATE SYNONYM bipu1.cons_sstache_res_mois FOR bip.cons_sstache_res_mois;


DROP SYNONYM bipu1.contrat;

--
-- CONTRAT  (Synonym) 
--
CREATE SYNONYM bipu1.contrat FOR bip.contrat;


DROP SYNONYM bipu1.cons_sstache_res;

--
-- CONS_SSTACHE_RES  (Synonym) 
--
CREATE SYNONYM bipu1.cons_sstache_res FOR bip.cons_sstache_res;


DROP SYNONYM bipu1.etape2;

--
-- ETAPE2  (Synonym) 
--
CREATE SYNONYM bipu1.etape2 FOR bip.etape2;


DROP SYNONYM bipu1.fichier;

--
-- FICHIER  (Synonym) 
--
CREATE SYNONYM bipu1.fichier FOR bip.fichier;


DROP SYNONYM bipu1.filiale_cli;

--
-- FILIALE_CLI  (Synonym) 
--
CREATE SYNONYM bipu1.filiale_cli FOR bip.filiale_cli;


DROP SYNONYM bipu1.histo_contrat;

--
-- HISTO_CONTRAT  (Synonym) 
--
CREATE SYNONYM bipu1.histo_contrat FOR bip.histo_contrat;


DROP SYNONYM bipu1.histo_amort;

--
-- HISTO_AMORT  (Synonym) 
--
CREATE SYNONYM bipu1.histo_amort FOR bip.histo_amort;


DROP SYNONYM bipu1.hispro;

--
-- HISPRO  (Synonym) 
--
CREATE SYNONYM bipu1.hispro FOR bip.hispro;


DROP SYNONYM bipu1.facture;

--
-- FACTURE  (Synonym) 
--
CREATE SYNONYM bipu1.facture FOR bip.facture;


DROP SYNONYM bipu1.histo_facture;

--
-- HISTO_FACTURE  (Synonym) 
--
CREATE SYNONYM bipu1.histo_facture FOR bip.histo_facture;


DROP SYNONYM bipu1.histo_ligne_cont;

--
-- HISTO_LIGNE_CONT  (Synonym) 
--
CREATE SYNONYM bipu1.histo_ligne_cont FOR bip.histo_ligne_cont;


DROP SYNONYM bipu1.histo_ligne_fact;

--
-- HISTO_LIGNE_FACT  (Synonym) 
--
CREATE SYNONYM bipu1.histo_ligne_fact FOR bip.histo_ligne_fact;


DROP SYNONYM bipu1.import_compta_data;

--
-- IMPORT_COMPTA_DATA  (Synonym) 
--
CREATE SYNONYM bipu1.import_compta_data FOR bip.import_compta_data;


DROP SYNONYM bipu1.import_compta_log;

--
-- IMPORT_COMPTA_LOG  (Synonym) 
--
CREATE SYNONYM bipu1.import_compta_log FOR bip.import_compta_log;


DROP SYNONYM bipu1.ligne_bip;

--
-- LIGNE_BIP  (Synonym) 
--
CREATE SYNONYM bipu1.ligne_bip FOR bip.ligne_bip;


DROP SYNONYM bipu1.ligne_cont;

--
-- LIGNE_CONT  (Synonym) 
--
CREATE SYNONYM bipu1.ligne_cont FOR bip.ligne_cont;


DROP SYNONYM bipu1.ligne_fact;

--
-- LIGNE_FACT  (Synonym) 
--
CREATE SYNONYM bipu1.ligne_fact FOR bip.ligne_fact;


DROP SYNONYM bipu1.liste_table_histo;

--
-- LISTE_TABLE_HISTO  (Synonym) 
--
CREATE SYNONYM bipu1.liste_table_histo FOR bip.liste_table_histo;


DROP SYNONYM bipu1.ligne_bip2;

--
-- LIGNE_BIP2  (Synonym) 
--
CREATE SYNONYM bipu1.ligne_bip2 FOR bip.ligne_bip2;


DROP SYNONYM bipu1.jferie;

--
-- JFERIE  (Synonym) 
--
CREATE SYNONYM bipu1.jferie FOR bip.jferie;


DROP SYNONYM bipu1.immeuble;

--
-- IMMEUBLE  (Synonym) 
--
CREATE SYNONYM bipu1.immeuble FOR bip.immeuble;


DROP SYNONYM bipu1.niche;

--
-- NICHE  (Synonym) 
--
CREATE SYNONYM bipu1.niche FOR bip.niche;


DROP SYNONYM bipu1.proj_info;

--
-- PROJ_INFO  (Synonym) 
--
CREATE SYNONYM bipu1.proj_info FOR bip.proj_info;


DROP SYNONYM bipu1.pmw_ligne_bip;

--
-- PMW_LIGNE_BIP  (Synonym) 
--
CREATE SYNONYM bipu1.pmw_ligne_bip FOR bip.pmw_ligne_bip;


DROP SYNONYM bipu1.pmw_consomm;

--
-- PMW_CONSOMM  (Synonym) 
--
CREATE SYNONYM bipu1.pmw_consomm FOR bip.pmw_consomm;


DROP SYNONYM bipu1.pmw_affecta;

--
-- PMW_AFFECTA  (Synonym) 
--
CREATE SYNONYM bipu1.pmw_affecta FOR bip.pmw_affecta;


DROP SYNONYM bipu1.pmw_activite;

--
-- PMW_ACTIVITE  (Synonym) 
--
CREATE SYNONYM bipu1.pmw_activite FOR bip.pmw_activite;


DROP SYNONYM bipu1.MESSAGE;

--
-- MESSAGE  (Synonym) 
--
CREATE SYNONYM bipu1.MESSAGE FOR bip.MESSAGE;


DROP SYNONYM bipu1.proj_spe;

--
-- PROJ_SPE  (Synonym) 
--
CREATE SYNONYM bipu1.proj_spe FOR bip.proj_spe;


DROP SYNONYM bipu1.ref_histo;

--
-- REF_HISTO  (Synonym) 
--
CREATE SYNONYM bipu1.ref_histo FOR bip.ref_histo;


DROP SYNONYM bipu1.proplus;

--
-- PROPLUS  (Synonym) 
--
CREATE SYNONYM bipu1.proplus FOR bip.proplus;


DROP SYNONYM bipu1.ressource;

--
-- RESSOURCE  (Synonym) 
--
CREATE SYNONYM bipu1.ressource FOR bip.ressource;


DROP SYNONYM bipu1.societe;

--
-- SOCIETE  (Synonym) 
--
CREATE SYNONYM bipu1.societe FOR bip.societe;


DROP SYNONYM bipu1.situ_ress;

--
-- SITU_RESS  (Synonym) 
--
CREATE SYNONYM bipu1.situ_ress FOR bip.situ_ress;


DROP SYNONYM bipu1.tache;

--
-- TACHE  (Synonym) 
--
CREATE SYNONYM bipu1.tache FOR bip.tache;


DROP SYNONYM bipu1.struct_info;

--
-- STRUCT_INFO  (Synonym) 
--
CREATE SYNONYM bipu1.struct_info FOR bip.struct_info;


DROP SYNONYM bipu1.sstrt;

--
-- SSTRT  (Synonym) 
--
CREATE SYNONYM bipu1.sstrt FOR bip.sstrt;


DROP SYNONYM bipu1.tmpfe60;

--
-- TMPFE60  (Synonym) 
--
CREATE SYNONYM bipu1.tmpfe60 FOR bip.tmpfe60;


DROP SYNONYM bipu1.tmprapsynt;

--
-- TMPRAPSYNT  (Synonym) 
--
CREATE SYNONYM bipu1.tmprapsynt FOR bip.tmprapsynt;


DROP SYNONYM bipu1.tmpreftrans;

--
-- TMPREFTRANS  (Synonym) 
--
CREATE SYNONYM bipu1.tmpreftrans FOR bip.tmpreftrans;


DROP SYNONYM bipu1.tmp_conso_sstache;

--
-- TMP_CONSO_SSTACHE  (Synonym) 
--
CREATE SYNONYM bipu1.tmp_conso_sstache FOR bip.tmp_conso_sstache;


DROP SYNONYM bipu1.tmp_budget_sstache;

--
-- TMP_BUDGET_SSTACHE  (Synonym) 
--
CREATE SYNONYM bipu1.tmp_budget_sstache FOR bip.tmp_budget_sstache;


DROP SYNONYM bipu1.type_etape;

--
-- TYPE_ETAPE  (Synonym) 
--
CREATE SYNONYM bipu1.type_etape FOR bip.type_etape;


DROP SYNONYM bipu1.type_amort;

--
-- TYPE_AMORT  (Synonym) 
--
CREATE SYNONYM bipu1.type_amort FOR bip.type_amort;


DROP SYNONYM bipu1.type_activite;

--
-- TYPE_ACTIVITE  (Synonym) 
--
CREATE SYNONYM bipu1.type_activite FOR bip.type_activite;


DROP SYNONYM bipu1.tva;

--
-- TVA  (Synonym) 
--
CREATE SYNONYM bipu1.tva FOR bip.tva;


DROP SYNONYM bipu1.trait_asynchrone;

--
-- TRAIT_ASYNCHRONE  (Synonym) 
--
CREATE SYNONYM bipu1.trait_asynchrone FOR bip.trait_asynchrone;


DROP SYNONYM bipu1.type_projet;

--
-- TYPE_PROJET  (Synonym) 
--
CREATE SYNONYM bipu1.type_projet FOR bip.type_projet;


DROP SYNONYM bipu1.type_ress;

--
-- TYPE_RESS  (Synonym) 
--
CREATE SYNONYM bipu1.type_ress FOR bip.type_ress;


DROP SYNONYM bipu1.version_tp;

--
-- VERSION_TP  (Synonym) 
--
CREATE SYNONYM bipu1.version_tp FOR bip.version_tp;


DROP SYNONYM bobip.investissements;

--
-- INVESTISSEMENTS  (Synonym) 
--
CREATE SYNONYM bobip.investissements FOR bip.investissements;


DROP SYNONYM bobip.nature;

--
-- NATURE  (Synonym) 
--
CREATE SYNONYM bobip.nature FOR bip.nature;


DROP SYNONYM bobip.poste;

--
-- POSTE  (Synonym) 
--
CREATE SYNONYM bobip.poste FOR bip.poste;


DROP SYNONYM bipu1.ligne_investissement;

--
-- LIGNE_INVESTISSEMENT  (Synonym) 
--
CREATE SYNONYM bipu1.ligne_investissement FOR bip.ligne_investissement;


DROP SYNONYM bipu1.entite_structure;

--
-- ENTITE_STRUCTURE  (Synonym) 
--
CREATE SYNONYM bipu1.entite_structure FOR bip.entite_structure;


DROP SYNONYM bipu1.investissements;

--
-- INVESTISSEMENTS  (Synonym) 
--
CREATE SYNONYM bipu1.investissements FOR bip.investissements;


DROP SYNONYM bipu1.ligne_realisation;

--
-- LIGNE_REALISATION  (Synonym) 
--
CREATE SYNONYM bipu1.ligne_realisation FOR bip.ligne_realisation;


DROP SYNONYM bipu1.poste;

--
-- POSTE  (Synonym) 
--
CREATE SYNONYM bipu1.poste FOR bip.poste;


DROP SYNONYM bipu1.nature;

--
-- NATURE  (Synonym) 
--
CREATE SYNONYM bipu1.nature FOR bip.nature;


DROP SYNONYM bipu1.cons_sstache_res_mois_rejet;

--
-- CONS_SSTACHE_RES_MOIS_REJET  (Synonym) 
--
CREATE SYNONYM bipu1.cons_sstache_res_mois_rejet FOR bip.cons_sstache_res_mois_rejet;


DROP SYNONYM bipu1.audit_statut;

--
-- AUDIT_STATUT  (Synonym) 
--
CREATE SYNONYM bipu1.audit_statut FOR bip.audit_statut;


DROP SYNONYM bipu1.requete_profil;

--
-- REQUETE_PROFIL  (Synonym) 
--
CREATE SYNONYM bipu1.requete_profil FOR bip.requete_profil;


DROP SYNONYM bobip.cout_std2;

--
-- COUT_STD2  (Synonym) 
--
CREATE SYNONYM bobip.cout_std2 FOR bip.cout_std2;


DROP SYNONYM bipu1.stock_immo;

--
-- STOCK_IMMO  (Synonym) 
--
CREATE SYNONYM bipu1.stock_immo FOR bip.stock_immo;


DROP SYNONYM bipu1.stock_fi;

--
-- STOCK_FI  (Synonym) 
--
CREATE SYNONYM bipu1.stock_fi FOR bip.stock_fi;


DROP SYNONYM bobip.cout_std_sg;

--
-- COUT_STD_SG  (Synonym) 
--
CREATE SYNONYM bobip.cout_std_sg FOR bip.cout_std_sg;


DROP SYNONYM bipu1.agence;

--
-- AGENCE  (Synonym) 
--
CREATE SYNONYM bipu1.agence FOR bip.agence;


DROP SYNONYM bipu1.batch_charge_camo_bad;

--
-- BATCH_CHARGE_CAMO_BAD  (Synonym) 
--
CREATE SYNONYM bipu1.batch_charge_camo_bad FOR bip.batch_charge_camo_bad;


DROP SYNONYM bipu1.batch_etape_bad;

--
-- BATCH_ETAPE_BAD  (Synonym) 
--
CREATE SYNONYM bipu1.batch_etape_bad FOR bip.batch_etape_bad;


DROP SYNONYM bipu1.batch_cons_sstache_res_bad;

--
-- BATCH_CONS_SSTACHE_RES_BAD  (Synonym) 
--
CREATE SYNONYM bipu1.batch_cons_sstache_res_bad FOR bip.batch_cons_sstache_res_bad;


DROP SYNONYM bipu1.application;

--
-- APPLICATION  (Synonym) 
--
CREATE SYNONYM bipu1.application FOR bip.application;


DROP SYNONYM bipu1.batch_proplus_complus;

--
-- BATCH_PROPLUS_COMPLUS  (Synonym) 
--
CREATE SYNONYM bipu1.batch_proplus_complus FOR bip.batch_proplus_complus;


DROP SYNONYM bipu1.batch_rejetsrp;

--
-- BATCH_REJETSRP  (Synonym) 
--
CREATE SYNONYM bipu1.batch_rejetsrp FOR bip.batch_rejetsrp;


DROP SYNONYM bipu1.batch_hdla;

--
-- BATCH_HDLA  (Synonym) 
--
CREATE SYNONYM bipu1.batch_hdla FOR bip.batch_hdla;


DROP SYNONYM bipu1.centre_activite;

--
-- CENTRE_ACTIVITE  (Synonym) 
--
CREATE SYNONYM bipu1.centre_activite FOR bip.centre_activite;


DROP SYNONYM bipu1.client_mo;

--
-- CLIENT_MO  (Synonym) 
--
CREATE SYNONYM bipu1.client_mo FOR bip.client_mo;


DROP SYNONYM bipu1.charge_camo;

--
-- CHARGE_CAMO  (Synonym) 
--
CREATE SYNONYM bipu1.charge_camo FOR bip.charge_camo;


DROP SYNONYM bipu1.code_compt;

--
-- CODE_COMPT  (Synonym) 
--
CREATE SYNONYM bipu1.code_compt FOR bip.code_compt;


DROP SYNONYM bipu1.calendrier;

--
-- CALENDRIER  (Synonym) 
--
CREATE SYNONYM bipu1.calendrier FOR bip.calendrier;


DROP SYNONYM bipu1.fichiers_rdf;

--
-- FICHIERS_RDF  (Synonym) 
--
CREATE SYNONYM bipu1.fichiers_rdf FOR bip.fichiers_rdf;


DROP SYNONYM bipu1.notification_logs;

--
-- NOTIFICATION_LOGS  (Synonym) 
--
CREATE SYNONYM bipu1.notification_logs FOR bip.notification_logs;


DROP SYNONYM bipu1.rjh_tabrepart;

--
-- RJH_TABREPART  (Synonym) 
--
CREATE SYNONYM bipu1.rjh_tabrepart FOR bip.rjh_tabrepart;


DROP SYNONYM bipu1.rjh_tabrepart_detail;

--
-- RJH_TABREPART_DETAIL  (Synonym) 
--
CREATE SYNONYM bipu1.rjh_tabrepart_detail FOR bip.rjh_tabrepart_detail;


DROP SYNONYM bipu1.rjh_chargement;

--
-- RJH_CHARGEMENT  (Synonym) 
--
CREATE SYNONYM bipu1.rjh_chargement FOR bip.rjh_chargement;


DROP SYNONYM bipu1.rjh_charg_erreur;

--
-- RJH_CHARG_ERREUR  (Synonym) 
--
CREATE SYNONYM bipu1.rjh_charg_erreur FOR bip.rjh_charg_erreur;


DROP SYNONYM bipu1.type_domaine;

--
-- TYPE_DOMAINE  (Synonym) 
--
CREATE SYNONYM bipu1.type_domaine FOR bip.type_domaine;


DROP SYNONYM bipu1.rtfe_log;

--
-- RTFE_LOG  (Synonym) 
--
CREATE SYNONYM bipu1.rtfe_log FOR bip.rtfe_log;


DROP SYNONYM bipu1.consomme;

--
-- CONSOMME  (Synonym) 
--
CREATE SYNONYM bipu1.consomme FOR bip.consomme;


DROP SYNONYM bipu1.budget;

--
-- BUDGET  (Synonym) 
--
CREATE SYNONYM bipu1.budget FOR bip.budget;


DROP SYNONYM bipu1.situ_ress_full;

--
-- SITU_RESS_FULL  (Synonym) 
--
CREATE SYNONYM bipu1.situ_ress_full FOR bip.situ_ress_full;


DROP SYNONYM bipu1.tmp_oscar;

--
-- TMP_OSCAR  (Synonym) 
--
CREATE SYNONYM bipu1.tmp_oscar FOR bip.tmp_oscar;


DROP SYNONYM bipu1.isac_consomme;

--
-- ISAC_CONSOMME  (Synonym) 
--
CREATE SYNONYM bipu1.isac_consomme FOR bip.isac_consomme;


DROP SYNONYM bipu1.isac_affectation;

--
-- ISAC_AFFECTATION  (Synonym) 
--
CREATE SYNONYM bipu1.isac_affectation FOR bip.isac_affectation;


DROP SYNONYM bipu1.isac_sous_tache;

--
-- ISAC_SOUS_TACHE  (Synonym) 
--
CREATE SYNONYM bipu1.isac_sous_tache FOR bip.isac_sous_tache;


DROP SYNONYM bipu1.isac_tache;

--
-- ISAC_TACHE  (Synonym) 
--
CREATE SYNONYM bipu1.isac_tache FOR bip.isac_tache;


DROP SYNONYM bipu1.isac_etape;

--
-- ISAC_ETAPE  (Synonym) 
--
CREATE SYNONYM bipu1.isac_etape FOR bip.isac_etape;


DROP SYNONYM bipu1.suivijhr;

--
-- SUIVIJHR  (Synonym) 
--
CREATE SYNONYM bipu1.suivijhr FOR bip.suivijhr;


DROP SYNONYM bipu1.histo_suivijhr;

--
-- HISTO_SUIVIJHR  (Synonym) 
--
CREATE SYNONYM bipu1.histo_suivijhr FOR bip.histo_suivijhr;


DROP SYNONYM bobip.isac_message;

--
-- ISAC_MESSAGE  (Synonym) 
--
CREATE SYNONYM bobip.isac_message FOR bip.isac_message;


DROP SYNONYM bobip.isac_tache;

--
-- ISAC_TACHE  (Synonym) 
--
CREATE SYNONYM bobip.isac_tache FOR bip.isac_tache;


DROP SYNONYM bobip.isac_sous_tache;

--
-- ISAC_SOUS_TACHE  (Synonym) 
--
CREATE SYNONYM bobip.isac_sous_tache FOR bip.isac_sous_tache;


DROP SYNONYM bobip.isac_affectation;

--
-- ISAC_AFFECTATION  (Synonym) 
--
CREATE SYNONYM bobip.isac_affectation FOR bip.isac_affectation;


DROP SYNONYM bobip.isac_consomme;

--
-- ISAC_CONSOMME  (Synonym) 
--
CREATE SYNONYM bobip.isac_consomme FOR bip.isac_consomme;


DROP SYNONYM bobip.isac_controle;

--
-- ISAC_CONTROLE  (Synonym) 
--
CREATE SYNONYM bobip.isac_controle FOR bip.isac_controle;


DROP SYNONYM bobip.isac_etape;

--
-- ISAC_ETAPE  (Synonym) 
--
CREATE SYNONYM bobip.isac_etape FOR bip.isac_etape;


DROP SYNONYM bipu1.bjh_anomalies;

--
-- BJH_ANOMALIES  (Synonym) 
--
CREATE SYNONYM bipu1.bjh_anomalies FOR bip.bjh_anomalies;


DROP SYNONYM bipu1.bjh_extbip;

--
-- BJH_EXTBIP  (Synonym) 
--
CREATE SYNONYM bipu1.bjh_extbip FOR bip.bjh_extbip;


DROP SYNONYM bipu1.bjh_extgip;

--
-- BJH_EXTGIP  (Synonym) 
--
CREATE SYNONYM bipu1.bjh_extgip FOR bip.bjh_extgip;


DROP SYNONYM bipu1.bjh_type_absence;

--
-- BJH_TYPE_ABSENCE  (Synonym) 
--
CREATE SYNONYM bipu1.bjh_type_absence FOR bip.bjh_type_absence;


DROP SYNONYM bipu1.tmpedsstr;

--
-- TMPEDSSTR  (Synonym) 
--
CREATE SYNONYM bipu1.tmpedsstr FOR bip.tmpedsstr;


DROP SYNONYM bipu1.taux_recup;

--
-- TAUX_RECUP  (Synonym) 
--
CREATE SYNONYM bipu1.taux_recup FOR bip.taux_recup;


DROP SYNONYM bobip.abecedaire;

--
-- ABECEDAIRE  (Synonym) 
--
CREATE SYNONYM bobip.abecedaire FOR bip.abecedaire;


DROP SYNONYM bobip.bjh_anomalies;

--
-- BJH_ANOMALIES  (Synonym) 
--
CREATE SYNONYM bobip.bjh_anomalies FOR bip.bjh_anomalies;


DROP SYNONYM bobip.bjh_extbip;

--
-- BJH_EXTBIP  (Synonym) 
--
CREATE SYNONYM bobip.bjh_extbip FOR bip.bjh_extbip;


DROP SYNONYM bobip.bjh_extgip;

--
-- BJH_EXTGIP  (Synonym) 
--
CREATE SYNONYM bobip.bjh_extgip FOR bip.bjh_extgip;


DROP SYNONYM bobip.bjh_type_absence;

--
-- BJH_TYPE_ABSENCE  (Synonym) 
--
CREATE SYNONYM bobip.bjh_type_absence FOR bip.bjh_type_absence;


DROP SYNONYM bobip.centre_frais;

--
-- CENTRE_FRAIS  (Synonym) 
--
CREATE SYNONYM bobip.centre_frais FOR bip.centre_frais;


DROP SYNONYM bobip.compo_centre_frais;

--
-- COMPO_CENTRE_FRAIS  (Synonym) 
--
CREATE SYNONYM bobip.compo_centre_frais FOR bip.compo_centre_frais;


DROP SYNONYM bobip.taux_recup;

--
-- TAUX_RECUP  (Synonym) 
--
CREATE SYNONYM bobip.taux_recup FOR bip.taux_recup;


DROP SYNONYM bobip.tmpedsstr;

--
-- TMPEDSSTR  (Synonym) 
--
CREATE SYNONYM bobip.tmpedsstr FOR bip.tmpedsstr;


DROP SYNONYM bipu1.bjh_ressource;

--
-- BJH_RESSOURCE  (Synonym) 
--
CREATE SYNONYM bipu1.bjh_ressource FOR bip.bjh_ressource;


DROP SYNONYM bipu1.filtre_requete;

--
-- FILTRE_REQUETE  (Synonym) 
--
CREATE SYNONYM bipu1.filtre_requete FOR bip.filtre_requete;


DROP SYNONYM bipu1.requete;

--
-- REQUETE  (Synonym) 
--
CREATE SYNONYM bipu1.requete FOR bip.requete;


DROP SYNONYM bipu1.sql_requete;

--
-- SQL_REQUETE  (Synonym) 
--
CREATE SYNONYM bipu1.sql_requete FOR bip.sql_requete;


DROP SYNONYM bipu1.prestation;

--
-- PRESTATION  (Synonym) 
--
CREATE SYNONYM bipu1.prestation FOR bip.prestation;


DROP SYNONYM bipu1.faccons_ressource;

--
-- FACCONS_RESSOURCE  (Synonym) 
--
CREATE SYNONYM bipu1.faccons_ressource FOR bip.faccons_ressource;


DROP SYNONYM bipu1.faccons_consomme;

--
-- FACCONS_CONSOMME  (Synonym) 
--
CREATE SYNONYM bipu1.faccons_consomme FOR bip.faccons_consomme;


DROP SYNONYM bipu1.faccons_facture;

--
-- FACCONS_FACTURE  (Synonym) 
--
CREATE SYNONYM bipu1.faccons_facture FOR bip.faccons_facture;


DROP SYNONYM bipu1.actualite;

--
-- ACTUALITE  (Synonym) 
--
CREATE SYNONYM bipu1.actualite FOR bip.actualite;


DROP SYNONYM bipu1.lien_profil_actu;

--
-- LIEN_PROFIL_ACTU  (Synonym) 
--
CREATE SYNONYM bipu1.lien_profil_actu FOR bip.lien_profil_actu;


DROP SYNONYM bipu1.parametre;

--
-- PARAMETRE  (Synonym) 
--
CREATE SYNONYM bipu1.parametre FOR bip.parametre;


DROP SYNONYM bipu1.remontee;

--
-- REMONTEE  (Synonym) 
--
CREATE SYNONYM bipu1.remontee FOR bip.remontee;


DROP SYNONYM bipu1.ensemble_applicatif;

--
-- ENSEMBLE_APPLICATIF  (Synonym) 
--
CREATE SYNONYM bipu1.ensemble_applicatif FOR bip.ensemble_applicatif;


DROP SYNONYM bipu1.domaine_bancaire;

--
-- DOMAINE_BANCAIRE  (Synonym) 
--
CREATE SYNONYM bipu1.domaine_bancaire FOR bip.domaine_bancaire;


DROP SYNONYM bobip.ensemble_applicatif;

--
-- ENSEMBLE_APPLICATIF  (Synonym) 
--
CREATE SYNONYM bobip.ensemble_applicatif FOR bip.ensemble_applicatif;


DROP SYNONYM bobip.domaine_bancaire;

--
-- DOMAINE_BANCAIRE  (Synonym) 
--
CREATE SYNONYM bobip.domaine_bancaire FOR bip.domaine_bancaire;


DROP SYNONYM bipu1.repartition_ligne;

--
-- REPARTITION_LIGNE  (Synonym) 
--
CREATE SYNONYM bipu1.repartition_ligne FOR bip.repartition_ligne;


DROP SYNONYM bobip.repartition_ligne;

--
-- REPARTITION_LIGNE  (Synonym) 
--
CREATE SYNONYM bobip.repartition_ligne FOR bip.repartition_ligne;


DROP SYNONYM bobip.jferie;

--
-- JFERIE  (Synonym) 
--
CREATE SYNONYM bobip.jferie FOR bip.jferie;


DROP SYNONYM bobip.import_compta_res;

--
-- IMPORT_COMPTA_RES  (Synonym) 
--
CREATE SYNONYM bobip.import_compta_res FOR bip.import_compta_res;


DROP SYNONYM bobip.import_compta_log;

--
-- IMPORT_COMPTA_LOG  (Synonym) 
--
CREATE SYNONYM bobip.import_compta_log FOR bip.import_compta_log;


DROP SYNONYM bobip.import_compta_data;

--
-- IMPORT_COMPTA_DATA  (Synonym) 
--
CREATE SYNONYM bobip.import_compta_data FOR bip.import_compta_data;


DROP SYNONYM bobip.histo_facture;

--
-- HISTO_FACTURE  (Synonym) 
--
CREATE SYNONYM bobip.histo_facture FOR bip.histo_facture;


DROP SYNONYM bobip.hispro;

--
-- HISPRO  (Synonym) 
--
CREATE SYNONYM bobip.hispro FOR bip.hispro;


DROP SYNONYM bobip.histo_amort;

--
-- HISTO_AMORT  (Synonym) 
--
CREATE SYNONYM bobip.histo_amort FOR bip.histo_amort;


DROP SYNONYM bobip.histo_contrat;

--
-- HISTO_CONTRAT  (Synonym) 
--
CREATE SYNONYM bobip.histo_contrat FOR bip.histo_contrat;


DROP SYNONYM bobip.ligne_cont;

--
-- LIGNE_CONT  (Synonym) 
--
CREATE SYNONYM bobip.ligne_cont FOR bip.ligne_cont;


DROP SYNONYM bobip.MESSAGE;

--
-- MESSAGE  (Synonym) 
--
CREATE SYNONYM bobip.MESSAGE FOR bip.MESSAGE;


DROP SYNONYM bobip.niche;

--
-- NICHE  (Synonym) 
--
CREATE SYNONYM bobip.niche FOR bip.niche;


DROP SYNONYM bobip.pmw_activite;

--
-- PMW_ACTIVITE  (Synonym) 
--
CREATE SYNONYM bobip.pmw_activite FOR bip.pmw_activite;


DROP SYNONYM bobip.liste_table_histo;

--
-- LISTE_TABLE_HISTO  (Synonym) 
--
CREATE SYNONYM bobip.liste_table_histo FOR bip.liste_table_histo;


DROP SYNONYM bobip.ligne_fact;

--
-- LIGNE_FACT  (Synonym) 
--
CREATE SYNONYM bobip.ligne_fact FOR bip.ligne_fact;


DROP SYNONYM bobip.pmw_affecta;

--
-- PMW_AFFECTA  (Synonym) 
--
CREATE SYNONYM bobip.pmw_affecta FOR bip.pmw_affecta;


DROP SYNONYM bobip.proj_spe;

--
-- PROJ_SPE  (Synonym) 
--
CREATE SYNONYM bobip.proj_spe FOR bip.proj_spe;


DROP SYNONYM bobip.proj_info;

--
-- PROJ_INFO  (Synonym) 
--
CREATE SYNONYM bobip.proj_info FOR bip.proj_info;


DROP SYNONYM bobip.situ_ress;

--
-- SITU_RESS  (Synonym) 
--
CREATE SYNONYM bobip.situ_ress FOR bip.situ_ress;


DROP SYNONYM bobip.ressource;

--
-- RESSOURCE  (Synonym) 
--
CREATE SYNONYM bobip.ressource FOR bip.ressource;


DROP SYNONYM bobip.ref_histo;

--
-- REF_HISTO  (Synonym) 
--
CREATE SYNONYM bobip.ref_histo FOR bip.ref_histo;


DROP SYNONYM bobip.proplus;

--
-- PROPLUS  (Synonym) 
--
CREATE SYNONYM bobip.proplus FOR bip.proplus;


DROP SYNONYM bobip.pmw_consomm;

--
-- PMW_CONSOMM  (Synonym) 
--
CREATE SYNONYM bobip.pmw_consomm FOR bip.pmw_consomm;


DROP SYNONYM bobip.pmw_ligne_bip;

--
-- PMW_LIGNE_BIP  (Synonym) 
--
CREATE SYNONYM bobip.pmw_ligne_bip FOR bip.pmw_ligne_bip;


DROP SYNONYM bobip.societe;

--
-- SOCIETE  (Synonym) 
--
CREATE SYNONYM bobip.societe FOR bip.societe;


DROP SYNONYM bobip.sstrt;

--
-- SSTRT  (Synonym) 
--
CREATE SYNONYM bobip.sstrt FOR bip.sstrt;


DROP SYNONYM bobip.tache;

--
-- TACHE  (Synonym) 
--
CREATE SYNONYM bobip.tache FOR bip.tache;


DROP SYNONYM bobip.tmpfe60;

--
-- TMPFE60  (Synonym) 
--
CREATE SYNONYM bobip.tmpfe60 FOR bip.tmpfe60;


DROP SYNONYM bobip.tmp_factae;

--
-- TMP_FACTAE  (Synonym) 
--
CREATE SYNONYM bobip.tmp_factae FOR bip.tmp_factae;


DROP SYNONYM bobip.tmp_conso_sstache;

--
-- TMP_CONSO_SSTACHE  (Synonym) 
--
CREATE SYNONYM bobip.tmp_conso_sstache FOR bip.tmp_conso_sstache;


DROP SYNONYM bobip.tmp_budget_sstache;

--
-- TMP_BUDGET_SSTACHE  (Synonym) 
--
CREATE SYNONYM bobip.tmp_budget_sstache FOR bip.tmp_budget_sstache;


DROP SYNONYM bobip.tmpreftrans;

--
-- TMPREFTRANS  (Synonym) 
--
CREATE SYNONYM bobip.tmpreftrans FOR bip.tmpreftrans;


DROP SYNONYM bobip.tmprapsynt;

--
-- TMPRAPSYNT  (Synonym) 
--
CREATE SYNONYM bobip.tmprapsynt FOR bip.tmprapsynt;


DROP SYNONYM bobip.struct_info;

--
-- STRUCT_INFO  (Synonym) 
--
CREATE SYNONYM bobip.struct_info FOR bip.struct_info;


DROP SYNONYM bobip.tva;

--
-- TVA  (Synonym) 
--
CREATE SYNONYM bobip.tva FOR bip.tva;


DROP SYNONYM bobip.trait_asynchrone;

--
-- TRAIT_ASYNCHRONE  (Synonym) 
--
CREATE SYNONYM bobip.trait_asynchrone FOR bip.trait_asynchrone;


DROP SYNONYM bobip.type_activite;

--
-- TYPE_ACTIVITE  (Synonym) 
--
CREATE SYNONYM bobip.type_activite FOR bip.type_activite;


DROP SYNONYM bobip.type_etape;

--
-- TYPE_ETAPE  (Synonym) 
--
CREATE SYNONYM bobip.type_etape FOR bip.type_etape;


DROP SYNONYM bobip.type_ress;

--
-- TYPE_RESS  (Synonym) 
--
CREATE SYNONYM bobip.type_ress FOR bip.type_ress;


DROP SYNONYM bobip.version_tp;

--
-- VERSION_TP  (Synonym) 
--
CREATE SYNONYM bobip.version_tp FOR bip.version_tp;


DROP SYNONYM bobip.type_projet;

--
-- TYPE_PROJET  (Synonym) 
--
CREATE SYNONYM bobip.type_projet FOR bip.type_projet;


DROP SYNONYM bobip.type_amort;

--
-- TYPE_AMORT  (Synonym) 
--
CREATE SYNONYM bobip.type_amort FOR bip.type_amort;


DROP SYNONYM bipu1.abecedaire;

--
-- ABECEDAIRE  (Synonym) 
--
CREATE SYNONYM bipu1.abecedaire FOR bip.abecedaire;


DROP SYNONYM bipu1.centre_frais;

--
-- CENTRE_FRAIS  (Synonym) 
--
CREATE SYNONYM bipu1.centre_frais FOR bip.centre_frais;


DROP SYNONYM bipu1.compo_centre_frais;

--
-- COMPO_CENTRE_FRAIS  (Synonym) 
--
CREATE SYNONYM bipu1.compo_centre_frais FOR bip.compo_centre_frais;


DROP SYNONYM bipu1.branches;

--
-- BRANCHES  (Synonym) 
--
CREATE SYNONYM bipu1.branches FOR bip.branches;


DROP SYNONYM bipu1.directions;

--
-- DIRECTIONS  (Synonym) 
--
CREATE SYNONYM bipu1.directions FOR bip.directions;


DROP SYNONYM bipu1.tmp_factae;

--
-- TMP_FACTAE  (Synonym) 
--
CREATE SYNONYM bipu1.tmp_factae FOR bip.tmp_factae;


DROP SYNONYM bipu1.import_compta_res;

--
-- IMPORT_COMPTA_RES  (Synonym) 
--
CREATE SYNONYM bipu1.import_compta_res FOR bip.import_compta_res;


DROP SYNONYM bobip.agence;

--
-- AGENCE  (Synonym) 
--
CREATE SYNONYM bobip.agence FOR bip.agence;


DROP SYNONYM bobip.application;

--
-- APPLICATION  (Synonym) 
--
CREATE SYNONYM bobip.application FOR bip.application;


DROP SYNONYM bobip.batch_charge_camo_bad;

--
-- BATCH_CHARGE_CAMO_BAD  (Synonym) 
--
CREATE SYNONYM bobip.batch_charge_camo_bad FOR bip.batch_charge_camo_bad;


DROP SYNONYM bobip.batch_etape_bad;

--
-- BATCH_ETAPE_BAD  (Synonym) 
--
CREATE SYNONYM bobip.batch_etape_bad FOR bip.batch_etape_bad;


DROP SYNONYM bobip.batch_hdla;

--
-- BATCH_HDLA  (Synonym) 
--
CREATE SYNONYM bobip.batch_hdla FOR bip.batch_hdla;


DROP SYNONYM bobip.batch_proplus_complus;

--
-- BATCH_PROPLUS_COMPLUS  (Synonym) 
--
CREATE SYNONYM bobip.batch_proplus_complus FOR bip.batch_proplus_complus;


DROP SYNONYM bobip.batch_cons_sstache_res_bad;

--
-- BATCH_CONS_SSTACHE_RES_BAD  (Synonym) 
--
CREATE SYNONYM bobip.batch_cons_sstache_res_bad FOR bip.batch_cons_sstache_res_bad;


DROP SYNONYM bobip.batch_tache_bad;

--
-- BATCH_TACHE_BAD  (Synonym) 
--
CREATE SYNONYM bobip.batch_tache_bad FOR bip.batch_tache_bad;


DROP SYNONYM bobip.batch_rejetsrp;

--
-- BATCH_REJETSRP  (Synonym) 
--
CREATE SYNONYM bobip.batch_rejetsrp FOR bip.batch_rejetsrp;


DROP SYNONYM bobip.charge_camo;

--
-- CHARGE_CAMO  (Synonym) 
--
CREATE SYNONYM bobip.charge_camo FOR bip.charge_camo;


DROP SYNONYM bobip.centre_activite;

--
-- CENTRE_ACTIVITE  (Synonym) 
--
CREATE SYNONYM bobip.centre_activite FOR bip.centre_activite;


DROP SYNONYM bobip.calendrier;

--
-- CALENDRIER  (Synonym) 
--
CREATE SYNONYM bobip.calendrier FOR bip.calendrier;


DROP SYNONYM bobip.branches;

--
-- BRANCHES  (Synonym) 
--
CREATE SYNONYM bobip.branches FOR bip.branches;


DROP SYNONYM bobip.client_mo;

--
-- CLIENT_MO  (Synonym) 
--
CREATE SYNONYM bobip.client_mo FOR bip.client_mo;


DROP SYNONYM bobip.code_compt;

--
-- CODE_COMPT  (Synonym) 
--
CREATE SYNONYM bobip.code_compt FOR bip.code_compt;


DROP SYNONYM bobip.code_statut;

--
-- CODE_STATUT  (Synonym) 
--
CREATE SYNONYM bobip.code_statut FOR bip.code_statut;


DROP SYNONYM bobip.contrat;

--
-- CONTRAT  (Synonym) 
--
CREATE SYNONYM bobip.contrat FOR bip.contrat;


DROP SYNONYM bobip.cons_sstache_res_mois;

--
-- CONS_SSTACHE_RES_MOIS  (Synonym) 
--
CREATE SYNONYM bobip.cons_sstache_res_mois FOR bip.cons_sstache_res_mois;


DROP SYNONYM bobip.cons_sstache_res;

--
-- CONS_SSTACHE_RES  (Synonym) 
--
CREATE SYNONYM bobip.cons_sstache_res FOR bip.cons_sstache_res;


DROP SYNONYM bobip.directions;

--
-- DIRECTIONS  (Synonym) 
--
CREATE SYNONYM bobip.directions FOR bip.directions;


DROP SYNONYM bobip.datdebex;

--
-- DATDEBEX  (Synonym) 
--
CREATE SYNONYM bobip.datdebex FOR bip.datdebex;


DROP SYNONYM bobip.etape;

--
-- ETAPE  (Synonym) 
--
CREATE SYNONYM bobip.etape FOR bip.etape;


DROP SYNONYM bobip.facture;

--
-- FACTURE  (Synonym) 
--
CREATE SYNONYM bobip.facture FOR bip.facture;


DROP SYNONYM bobip.fichier;

--
-- FICHIER  (Synonym) 
--
CREATE SYNONYM bobip.fichier FOR bip.fichier;


DROP SYNONYM bobip.filiale_cli;

--
-- FILIALE_CLI  (Synonym) 
--
CREATE SYNONYM bobip.filiale_cli FOR bip.filiale_cli;


DROP SYNONYM bobip.etape2;

--
-- ETAPE2  (Synonym) 
--
CREATE SYNONYM bobip.etape2 FOR bip.etape2;


DROP SYNONYM bobip.dossier_projet;

--
-- DOSSIER_PROJET  (Synonym) 
--
CREATE SYNONYM bobip.dossier_projet FOR bip.dossier_projet;


DROP SYNONYM bobip.histo_ligne_cont;

--
-- HISTO_LIGNE_CONT  (Synonym) 
--
CREATE SYNONYM bobip.histo_ligne_cont FOR bip.histo_ligne_cont;


DROP SYNONYM bobip.immeuble;

--
-- IMMEUBLE  (Synonym) 
--
CREATE SYNONYM bobip.immeuble FOR bip.immeuble;


DROP SYNONYM bobip.histo_ligne_fact;

--
-- HISTO_LIGNE_FACT  (Synonym) 
--
CREATE SYNONYM bobip.histo_ligne_fact FOR bip.histo_ligne_fact;


DROP SYNONYM bobip.ligne_bip2;

--
-- LIGNE_BIP2  (Synonym) 
--
CREATE SYNONYM bobip.ligne_bip2 FOR bip.ligne_bip2;


DROP SYNONYM bobip.ligne_bip;

--
-- LIGNE_BIP  (Synonym) 
--
CREATE SYNONYM bobip.ligne_bip FOR bip.ligne_bip;


DROP SYNONYM bipu1.tmp_imp_niveau;

--
-- TMP_IMP_NIVEAU  (Synonym) 
--
CREATE SYNONYM bipu1.tmp_imp_niveau FOR bip.tmp_imp_niveau;


DROP SYNONYM bobip.batch_rejet_datestatut;

--
-- BATCH_REJET_DATESTATUT  (Synonym) 
--
CREATE SYNONYM bobip.batch_rejet_datestatut FOR bip.batch_rejet_datestatut;


DROP SYNONYM bipu1.lien_types_proj_act;

--
-- LIEN_TYPES_PROJ_ACT  (Synonym) 
--
CREATE SYNONYM bipu1.lien_types_proj_act FOR bip.lien_types_proj_act;


DROP SYNONYM bobip.lien_types_proj_act;

--
-- LIEN_TYPES_PROJ_ACT  (Synonym) 
--
CREATE SYNONYM bobip.lien_types_proj_act FOR bip.lien_types_proj_act;


DROP SYNONYM bobip.bjh_ressource;

--
-- BJH_RESSOURCE  (Synonym) 
--
CREATE SYNONYM bobip.bjh_ressource FOR bip.bjh_ressource;


DROP SYNONYM bobip.suivijhr;

--
-- SUIVIJHR  (Synonym) 
--
CREATE SYNONYM bobip.suivijhr FOR bip.suivijhr;


DROP SYNONYM bipu1.tmp_rejetmens;

--
-- TMP_REJETMENS  (Synonym) 
--
CREATE SYNONYM bipu1.tmp_rejetmens FOR bip.tmp_rejetmens;


DROP SYNONYM bipu1.ree_scenarios;

--
-- REE_SCENARIOS  (Synonym) 
--
CREATE SYNONYM bipu1.ree_scenarios FOR bip.ree_scenarios;


DROP SYNONYM bipu1.ree_activites;

--
-- REE_ACTIVITES  (Synonym) 
--
CREATE SYNONYM bipu1.ree_activites FOR bip.ree_activites;


DROP SYNONYM bipu1.ree_activites_ligne_bip;

--
-- REE_ACTIVITES_LIGNE_BIP  (Synonym) 
--
CREATE SYNONYM bipu1.ree_activites_ligne_bip FOR bip.ree_activites_ligne_bip;


DROP SYNONYM bipu1.ree_reestime;

--
-- REE_REESTIME  (Synonym) 
--
CREATE SYNONYM bipu1.ree_reestime FOR bip.ree_reestime;


DROP SYNONYM bipu1.ree_ressources;

--
-- REE_RESSOURCES  (Synonym) 
--
CREATE SYNONYM bipu1.ree_ressources FOR bip.ree_ressources;


DROP SYNONYM bipu1.ree_ressources_activites;

--
-- REE_RESSOURCES_ACTIVITES  (Synonym) 
--
CREATE SYNONYM bipu1.ree_ressources_activites FOR bip.ree_ressources_activites;


DROP SYNONYM bipu1.tmp_ree_detail;

--
-- TMP_REE_DETAIL  (Synonym) 
--
CREATE SYNONYM bipu1.tmp_ree_detail FOR bip.tmp_ree_detail;


DROP SYNONYM bipu1.ressource_ecart;

--
-- RESSOURCE_ECART  (Synonym) 
--
CREATE SYNONYM bipu1.ressource_ecart FOR bip.ressource_ecart;


DROP SYNONYM bipu1.sous_typologie;

--
-- SOUS_TYPOLOGIE  (Synonym) 
--
CREATE SYNONYM bipu1.sous_typologie FOR bip.sous_typologie;


DROP SYNONYM bipu1.tmp_ligne_cont;

--
-- TMP_LIGNE_CONT  (Synonym) 
--
CREATE SYNONYM bipu1.tmp_ligne_cont FOR bip.tmp_ligne_cont;


DROP SYNONYM bipu1.tmp_contrat;

--
-- TMP_CONTRAT  (Synonym) 
--
CREATE SYNONYM bipu1.tmp_contrat FOR bip.tmp_contrat;


DROP SYNONYM bipu1.tmp_situation;

--
-- TMP_SITUATION  (Synonym) 
--
CREATE SYNONYM bipu1.tmp_situation FOR bip.tmp_situation;


DROP SYNONYM bipu1.tmp_ressource;

--
-- TMP_RESSOURCE  (Synonym) 
--
CREATE SYNONYM bipu1.tmp_ressource FOR bip.tmp_ressource;


DROP SYNONYM bipu1.tmp_imp_niveau_err;

--
-- TMP_IMP_NIVEAU_ERR  (Synonym) 
--
CREATE SYNONYM bipu1.tmp_imp_niveau_err FOR bip.tmp_imp_niveau_err;


DROP SYNONYM bipu1.cout_std_sg;

--
-- COUT_STD_SG  (Synonym) 
--
CREATE SYNONYM bipu1.cout_std_sg FOR bip.cout_std_sg;


DROP SYNONYM bipu1.cout_std2;

--
-- COUT_STD2  (Synonym) 
--
CREATE SYNONYM bipu1.cout_std2 FOR bip.cout_std2;


DROP SYNONYM bipu1.metier;

--
-- METIER  (Synonym) 
--
CREATE SYNONYM bipu1.metier FOR bip.metier;


DROP SYNONYM bipu1.niveau;

--
-- NIVEAU  (Synonym) 
--
CREATE SYNONYM bipu1.niveau FOR bip.niveau;


DROP SYNONYM bipu1.synthese_fin;

--
-- SYNTHESE_FIN  (Synonym) 
--
CREATE SYNONYM bipu1.synthese_fin FOR bip.synthese_fin;


DROP SYNONYM bipu1.synthese_fin_bip;

--
-- SYNTHESE_FIN_BIP  (Synonym) 
--
CREATE SYNONYM bipu1.synthese_fin_bip FOR bip.synthese_fin_bip;


DROP SYNONYM bipu1.budget_dp;

--
-- BUDGET_DP  (Synonym) 
--
CREATE SYNONYM bipu1.budget_dp FOR bip.budget_dp;


DROP SYNONYM bipu1.type_dossier_projet;

--
-- TYPE_DOSSIER_PROJET  (Synonym) 
--
CREATE SYNONYM bipu1.type_dossier_projet FOR bip.type_dossier_projet;


DROP SYNONYM bipu1.stock_fi_multi;

--
-- STOCK_FI_MULTI  (Synonym) 
--
CREATE SYNONYM bipu1.stock_fi_multi FOR bip.stock_fi_multi;


DROP SYNONYM bipu1.test_message;

--
-- TEST_MESSAGE  (Synonym) 
--
CREATE SYNONYM bipu1.test_message FOR bip.test_message;


DROP SYNONYM bipu1.tmp_visuprojprin;

--
-- TMP_VISUPROJPRIN  (Synonym) 
--
CREATE SYNONYM bipu1.tmp_visuprojprin FOR bip.tmp_visuprojprin;


DROP SYNONYM bobip.tmp_appli_rejet;

--
-- TMP_APPLI_REJET  (Synonym) 
--
CREATE SYNONYM bobip.tmp_appli_rejet FOR bip.tmp_appli_rejet;


DROP SYNONYM bipu1.report_log;

--
-- REPORT_LOG  (Synonym) 
--
CREATE SYNONYM bipu1.report_log FOR bip.report_log;


DROP SYNONYM bobip.report_log;

--
-- REPORT_LOG  (Synonym) 
--
CREATE SYNONYM bobip.report_log FOR bip.report_log;


DROP SYNONYM bipu1.ligne_bip_logs;

--
-- LIGNE_BIP_LOGS  (Synonym) 
--
CREATE SYNONYM bipu1.ligne_bip_logs FOR bip.ligne_bip_logs;


DROP SYNONYM bobip.ligne_bip_logs;

--
-- LIGNE_BIP_LOGS  (Synonym) 
--
CREATE SYNONYM bobip.ligne_bip_logs FOR bip.ligne_bip_logs;


DROP SYNONYM bipu1.stat_page;

--
-- STAT_PAGE  (Synonym) 
--
CREATE SYNONYM bipu1.stat_page FOR bip.stat_page;


DROP SYNONYM bipu1.compte;

--
-- COMPTE  (Synonym) 
--
CREATE SYNONYM bipu1.compte FOR bip.compte;


DROP SYNONYM bipu1.type_rubrique;

--
-- TYPE_RUBRIQUE  (Synonym) 
--
CREATE SYNONYM bipu1.type_rubrique FOR bip.type_rubrique;


DROP SYNONYM bipu1.rubrique;

--
-- RUBRIQUE  (Synonym) 
--
CREATE SYNONYM bipu1.rubrique FOR bip.rubrique;


DROP SYNONYM bipu1.rubrique_metier;

--
-- RUBRIQUE_METIER  (Synonym) 
--
CREATE SYNONYM bipu1.rubrique_metier FOR bip.rubrique_metier;


DROP SYNONYM bipu1.favoris;

--
-- FAVORIS  (Synonym) 
--
CREATE SYNONYM bipu1.favoris FOR bip.favoris;