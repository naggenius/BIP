#!/bin/ksh

if [ $# = 2 ]
then
   OWNER=$1
   PASSW=$2
else
   echo "usage : $0 OWNER PASSW"
   exit 1
fi

sqlplus -S $OWNER/$PASSW << EOF

echo "disactiver les contraintes..."
@@bip_disable_constraint.sql


echo "Chargement des donn�es..."
@@bip_ins_ABECEDAIRE.sql
@@bip_ins_ACTUALITE.sql
@@bip_ins_AGENCE.sql
@@bip_ins_APPLICATION.sql
@@bip_ins_AUDIT_RESSOURCE_MATRICULE.sql
@@bip_ins_AUDIT_STATUT.sql
@@bip_ins_BATCH_CHARGE_CAMO_BAD.sql
@@bip_ins_BATCH_CONS_SSTACHE_RES_BAD.sql
@@bip_ins_BATCH_CONS_SST_RES_M_BAD.sql
@@bip_ins_BATCH_ETAPE_BAD.sql
@@bip_ins_BATCH_HDLA.sql
@@bip_ins_BATCH_PROPLUS_COMPLUS.sql
@@bip_ins_BATCH_REJETSRP.sql
@@bip_ins_BATCH_REJET_DATESTATUT.sql
@@bip_ins_BATCH_TACHE_BAD.sql
@@bip_ins_BJH_ANOMALIES.sql
@@bip_ins_BJH_ANOMALIES_TEMP
@@bip_ins_BJH_EXTBIP.sql
@@bip_ins_BJH_EXTGIP.sql
@@bip_ins_BJH_RESSOURCE.sql
@@bip_ins_BJH_TYPE_ABSENCE.sql
@@bip_ins_BRANCHES.sql
@@bip_ins_BUDGET.sql
@@bip_ins_BUDGET_DP.sql
@@bip_ins_BUDGET_ECART.sql
@@bip_ins_BUDGET_ECART_1.sql
@@bip_ins_CAFI.sql
@@bip_ins_CALENDRIER.sql
@@bip_ins_CENTRE_ACTIVITE.sql
@@bip_ins_CENTRE_FRAIS.sql
@@bip_ins_CHAMP_LIGNE_BIP.sql
@@bip_ins_CHARGE_CAMO.sql
@@bip_ins_CHARGE_ES.sql
@@bip_ins_CHARGE_ES_ERR.sql
@@bip_ins_CLIENT_MO.sql
@@bip_ins_CODE_COMPT.sql
@@bip_ins_CODE_STATUT.sql
@@bip_ins_COMPO_CENTRE_FRAIS.sql
@@bip_ins_COMPTE.sql
@@bip_ins_CONSOMME.sql
@@bip_ins_CONS_SSTACHE_RES.sql
@@bip_ins_CONS_SSTACHE_RES_BACK.sql
@@bip_ins_CONS_SSTACHE_RES_MOIS.sql
@@bip_ins_CONS_SSTACHE_RES_MOIS_ANO.sql
@@bip_ins_CONS_SSTACHE_RES_MOIS_ARCHIVE.sql
@@bip_ins_CONS_SSTACHE_RES_MOIS_BACK.sql
@@bip_ins_CONS_SSTACHE_RES_MOIS_PURGE.sql
@@bip_ins_CONS_SSTACHE_RES_MOIS_REJET.sql
@@bip_ins_CONS_SSTACHE_RES_PURGE.sql
@@bip_ins_CONS_SSTRES_M_REJET_DATESTATUT.sql
@@bip_ins_CONS_SSTRES_REJET_DATESTATUT.sql
@@bip_ins_CONTRAT.sql
@@bip_ins_COUT_STD2.sql
@@bip_ins_COUT_STD_SG.sql
@@bip_ins_CUMUL_CONSO.sql
@@bip_ins_DATDEBEX.sql
@@bip_ins_DEMANDE_VAL_FACTU.sql
@@bip_ins_DIRECTIONS.sql
@@bip_ins_DOMAINE_BANCAIRE.sql
@@bip_ins_DOSSIER_PROJET.sql
@@bip_ins_ENSEMBLE_APPLICATIF.sql
@@bip_ins_ENTITE_STRUCTURE.sql
@@bip_ins_ESOURCING.sql
@@bip_ins_ESOURCING_CONTRAT.sql
@@bip_ins_ETAPE.sql
@@bip_ins_ETAPE2.sql
@@bip_ins_ETAPE_BACK.sql
@@bip_ins_ETAPE_BAD.sql
@@bip_ins_ETAPE_REJET_DATESTATUT.sql
@@bip_ins_EXCEPTIONS.sql
@@bip_ins_FACCONS_CONSOMME.sql
@@bip_ins_FACCONS_FACTURE.sql
@@bip_ins_FACCONS_RESSOURCE.sql
@@bip_ins_FACTURE.sql
@@bip_ins_FAVORIS.sql
@@bip_ins_FICHIER.sql
@@bip_ins_FICHIERS_RDF.sql
@@bip_ins_FILIALE_CLI.sql
@@bip_ins_FILTRE_REQUETE.sql
@@bip_ins_HISPRO.sql
@@bip_ins_HISSUIJHR.sql
@@bip_ins_HISTO_AMORT.sql
@@bip_ins_HISTO_STOCK_FI.sql
@@bip_ins_HISTO_STOCK_IMMO.sql
@@bip_ins_HISTO_SUIVIJHR.sql
@@bip_ins_IAS.sql
@@bip_ins_IMMEUBLE.sql
@@bip_ins_IMMEUBLE_1.sql
@@bip_ins_IMPORT_COMPTA_DATA.sql
@@bip_ins_IMPORT_COMPTA_LOG.sql
@@bip_ins_IMPORT_COMPTA_RES.sql
@@bip_ins_IMP_OSCAR_TMP.sql
@@bip_ins_INVESTISSEMENTS.sql
@@bip_ins_ISAC_AFFECTATION.sql
@@bip_ins_ISAC_CONSOMME.sql
@@bip_ins_ISAC_CONTROLE.sql
@@bip_ins_ISAC_ETAPE.sql
@@bip_ins_ISAC_MESSAGE.sql
@@bip_ins_ISAC_SOUS_TACHE.sql
@@bip_ins_ISAC_TACHE.sql
@@bip_ins_JFERIE.sql
@@bip_ins_KHA_LOG_PLSQL.sql
@@bip_ins_LIEN_PAGE_HTML.sql
@@bip_ins_LIEN_PROFIL_ACTU.sql
@@bip_ins_LIEN_TYPES_PROJ_ACT.sql
@@bip_ins_LIGNE_BIP.sql
@@bip_ins_LIGNE_BIP2.sql
@@bip_ins_LIGNE_BIP_LOGS.sql
@@bip_ins_LIGNE_CONT.sql
@@bip_ins_LIGNE_FACT.sql
@@bip_ins_LIGNE_INVESTISSEMENT.sql
@@bip_ins_LIGNE_REALISATION.sql
@@bip_ins_LISTE_TABLE_HISTO.sql
@@bip_ins_MENU.sql
@@bip_ins_MESSAGE.sql
@@bip_ins_MESSAGE_ADMIN.sql
@@bip_ins_MESSAGE_FORUM.sql
@@bip_ins_MESSAGE_PERSONNEL.sql
@@bip_ins_METIER.sql
@@bip_ins_NATURE.sql
@@bip_ins_NICHE.sql
@@bip_ins_NIVEAU.sql
@@bip_ins_NOTIFICATION_LOGS.sql
@@bip_ins_PAGE_HTML.sql
@@bip_ins_PARAMETRE.sql
@@bip_ins_PARAMETRE_LIGNE_BIP.sql
@@bip_ins_PARAM_TYPE_LIGNE_BIP.sql
@@bip_ins_PARTENAIRE.sql
@@bip_ins_PLAN_TABLE.sql
@@bip_ins_PMW_ACTIVITE.sql
@@bip_ins_PMW_AFFECTA.sql
@@bip_ins_PMW_CONSOMM.sql
@@bip_ins_PMW_LIGNE_BIP.sql
@@bip_ins_POSTE.sql
@@bip_ins_PRESTATION.sql
@@bip_ins_PROFIL.sql
@@bip_ins_PROJ_INFO.sql
@@bip_ins_PROJ_SPE.sql
@@bip_ins_PROPLUS.sql
@@bip_ins_REE_ACTIVITES.sql
@@bip_ins_REE_ACTIVITES_LIGNE_BIP.sql
@@bip_ins_REE_REESTIME.sql
@@bip_ins_REE_RESSOURCES.sql
@@bip_ins_REE_RESSOURCES_ACTIVITES.sql
@@bip_ins_REE_SCENARIOS.sql
@@bip_ins_REF_HISTO.sql
@@bip_ins_REMONTEE.sql
@@bip_ins_REPARTITION_LIGNE.sql
@@bip_ins_REPORT_LOG.sql
@@bip_ins_REQUETE.sql
@@bip_ins_REQUETE_PROFIL
@@bip_ins_RESSOURCE.sql
@@bip_ins_RESSOURCE_1.sql
@@bip_ins_RESSOURCE_ECART.sql
@@bip_ins_RESSOURCE_ECART_1.sql
@@bip_ins_RESSOURCE_LOGS.sql
@@bip_ins_RESSOURCE_PURGE.sql
@@bip_ins_RJH_ALIM_CONSO_LOG.sql
@@bip_ins_RJH_CHARGEMENT.sql
@@bip_ins_RJH_CHARG_ERREUR.sql
@@bip_ins_RJH_CONSOMME.sql
@@bip_ins_RJH_IAS.sql
@@bip_ins_RJH_TABREPART.sql
@@bip_ins_RJH_TABREPART_DETAIL.sql
@@bip_ins_RTFE.sql
@@bip_ins_RTFE_ERROR.sql
@@bip_ins_RTFE_LOG.sql
@@bip_ins_RTFE_USER.sql
@@bip_ins_RUBRIQUE.sql
@@bip_ins_RUBRIQUE_METIER.sql
@@bip_ins_SITU_RESS.sql
@@bip_ins_SITU_RESS_FULL.sql
@@bip_ins_SITU_RESS_SAVE_ITEC.sql
@@bip_ins_SOCIETE.sql
@@bip_ins_SOUS_TYPOLOGIE.sql
@@bip_ins_SQL_REQUETE.sql
@@bip_ins_SSTRT.sql
@@bip_ins_STAT_PAGE.sql
@@bip_ins_STOCK_FI.sql
@@bip_ins_STOCK_FI_1.sql
@@bip_ins_STOCK_FI_DEC.sql
@@bip_ins_STOCK_FI_MULTI.sql
@@bip_ins_STOCK_IMMO.sql
@@bip_ins_STOCK_IMMO_1.sql
@@bip_ins_STOCK_RA.sql
@@bip_ins_STOCK_RA_1.sql
@@bip_ins_STRUCT_INFO.sql
@@bip_ins_SUIVIJHR.sql
@@bip_ins_SYNTHESE_ACTIVITE.sql
@@bip_ins_SYNTHESE_ACTIVITE_MOIS.sql
@@bip_ins_SYNTHESE_FIN.sql
@@bip_ins_SYNTHESE_FIN_BIP.sql
@@bip_ins_SYNTHESE_FIN_RESS.sql
@@bip_ins_TACHE.sql
@@bip_ins_TACHE_BACK.sql
@@bip_ins_TACHE_REJET_DATESTATUT.sql
@@bip_ins_TAUX_CHARGE_SALARIALE.sql
@@bip_ins_TAUX_RECUP.sql
@@bip_ins_TESTFAC.sql
@@bip_ins_TEST_MESSAGE.sql
@@bip_ins_TMPAMTHIST2.sql
@@bip_ins_TMPEDSSTR.sql
@@bip_ins_TMPFE60.sql
@@bip_ins_TMPRAPSYNT.sql
@@bip_ins_TMPREFTRANS.sql
@@bip_ins_TMP_APPLI.sql
@@bip_ins_TMP_APPLICAT.sql
@@bip_ins_TMP_APPLI_REJET.sql
@@bip_ins_TMP_BUDGET_SSTACHE.sql
@@bip_ins_TMP_CONSO_SSTACHE.sql
@@bip_ins_TMP_CONTRAT.sql
@@bip_ins_TMP_DISC_FORUM.sql
@@bip_ins_TMP_DIVA_BUDGETS.sql
@@bip_ins_TMP_FACTAE.sql
@@bip_ins_TMP_FAIR.sql
@@bip_ins_TMP_IMMEUBLE.sql
@@bip_ins_TMP_IMMO.sql
@@bip_ins_TMP_IMP_NIVEAU.sql
@@bip_ins_TMP_IMP_NIVEAU_ERR.sql
@@bip_ins_TMP_LIGNE_CONT.sql
@@bip_ins_TMP_LIGNE_OSCAR.sql
@@bip_ins_TMP_ORGANISATION.sql
@@bip_ins_TMP_OSCAR.sql
@@bip_ins_TMP_PERSONNE.sql
@@bip_ins_TMP_REE_DETAIL.sql
@@bip_ins_TMP_REJETMENS.sql
@@bip_ins_TMP_RESSOURCE.sql
@@bip_ins_TMP_RTFE.sql
@@bip_ins_TMP_SAISIE_REALISEE.sql
@@bip_ins_TMP_SITUATION.sql
@@bip_ins_TMP_SYNTHCOUTPROJ.sql
@@bip_ins_TMP_VISUPROJPRIN.sql
@@bip_ins_TOAD_PLAN_SQL.sql
@@bip_ins_TOAD_PLAN_TABLE.sql
@@bip_ins_TRAIT_ASYNCHRONE.sql
@@bip_ins_TVA.sql
@@bip_ins_TYPE_ACTIVITE.sql
@@bip_ins_TYPE_AMORT.sql
@@bip_ins_TYPE_DOMAINE.sql
@@bip_ins_TYPE_DOSSIER_PROJET.sql
@@bip_ins_TYPE_ETAPE.sql
@@bip_ins_TYPE_PROJET.sql
@@bip_ins_TYPE_RESS.sql
@@bip_ins_TYPE_RUBRIQUE.sql
@@bip_ins_VERSION_TP.sql

echo "Activer les contraintes..."
@@bip_enable_constraint.sql

EOF

