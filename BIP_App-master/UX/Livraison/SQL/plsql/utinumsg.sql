-- pack_utile_numsg PL/SQL
--
-- equipe SOPRA
--
-- crée le 15/11/1999 (HT)
--
-- Package des constantes indiquant les N° de message et d'exception pour BIP
--
-- CONVENTIONS :
--         N° de message préfixés par numsg_ (N° Message < 20000)
--         N° exceptions préfixés par nuexc_ ((N° Message > 20000)
-- -------------------------------------------------------------------

CREATE OR REPLACE PACKAGE pack_utile_numsg AS
-- ---------------------------------------------

-----------------------------------------------------------------------
-- N° de message < 20000
-- ATTENTION : A COMPLETER (suivant les messages de Sylvie !!!)
-----------------------------------------------------------------------

--

-----------------------------------------------------------------------
-- N° d'exceptions (N° de message > 20000)
-----------------------------------------------------------------------
------------------------------
nuexc_coddpg_invalide3    		CONSTANT NUMBER := 20430; --  Code Département/Pôle/Groupe %s1 invalide
nuexc_codligne_bip_inexiste    		CONSTANT NUMBER := 20504; --  Code ligne BIP %s1 inexistant
nuexc_soccode_inexistant 		CONSTANT NUMBER := 20306; --  Code société inexistant
nuexc_numfact_inexistant 		CONSTANT NUMBER := 20601; --  Numéro de facture %s1 inexistant
nuexc_datfact_inexistant 		CONSTANT NUMBER := 20602; --  Date de facture %s1 inexistant



/*

nuexc_codcli_existant    		CONSTANT NUMBER := 20001; -- Code Client déjà existant
nuexc_datstatut_obligatoire    	CONSTANT NUMBER := 20002; -- La date de statut est obligatoire pour ce code statut
nuexc_datstatut_saisi_interdit    CONSTANT NUMBER := 20003; -- La date de statut ne doit pas être saisie pour ce code statut
nuexc_libproj_existant    		CONSTANT NUMBER := 20011; -- Libellé projet déjà existant pour le projet : %s1
nuexc_dpt_non_autorise    		CONSTANT NUMBER := 20012; -- Vous n'êtes pas autorisé %s1 dans ce département, votre département est : %s2
nuexc_pole_non_autorise    		CONSTANT NUMBER := 20013; -- Vous n'êtes pas autorisé %s1 dans ce pôle, votre pôle est : %s2
nuexc_der_ident_atteint    		CONSTANT NUMBER := 20014; -- Dernier identifiant atteint
nuexc_codtypo_non_autorise    	CONSTANT NUMBER := 20015; -- Code typologie d'activité non autorisé
nuexc_climo_ferme    			CONSTANT NUMBER := 20018; -- Client MO fermé
nuexc_fact_existant_hfact    		CONSTANT NUMBER := 20100; -- La facture existe déjà dans HISTO_FACTURE
nuexc_fact_existant_fact    		CONSTANT NUMBER := 20101; -- La facture existe déjà dans FACTURE
nuexc_modif_fact_non_autorise    	CONSTANT NUMBER := 20102; -- La modification de la facture n'est pas autorisée
nuexc_fact_inexistant    		CONSTANT NUMBER := 20103; -- La facture n'existe pas
nuexc_datfact_sup_datjour    		CONSTANT NUMBER := 20104; -- La date de la facture doit être inférieure ou égale à la date du jour
nuexc_suppr_fact_non_autorise    	CONSTANT NUMBER := 20105; -- La suppression de la facture n'est pas autorisée
nuexc_fact_existe_autre_filial    	CONSTANT NUMBER := 20106; -- La facture existe mais pour une autre filiale
nuexc_fact_refcontrat_inexist   CONSTANT NUMBER := 20107; -- Problème de facture faisant référence à un contrat inexistant
nuexc_datrecept_sup_datjour    	CONSTANT NUMBER := 20108; -- La date de réception doit être inférieure ou égale à la date du jour
nuexc_coddpg_inconnu    		CONSTANT NUMBER := 20109; -- Code Departement/Pole/Groupe inconnu
nuexc_codcompta_invalide    		CONSTANT NUMBER := 20110; -- Code Comptable invalide
nuexc_fact_existant    			CONSTANT NUMBER := 20111; -- Facture déjà existante
nuexc_contrat_app_autre_filial    	CONSTANT NUMBER := 20112; -- Le contrat appartient à une autre filiale
nuexc_annee_saisie_incorrecte    	CONSTANT NUMBER := 20200; -- L'année saisie n'est pas correcte
nuexc_codmo_ppal_inconnu    		CONSTANT NUMBER := 20202; -- Code maître d'ouvrage principal inconnu
nuexc_coddpg_inexistant    		CONSTANT NUMBER := 20203; -- Code Département/Pôle/Groupe inexistant
nuexc_codmo_gest_inconnu    		CONSTANT NUMBER := 20204; -- Code maître d'ouvrage gestionnaire inconnu
nuexc_appli_existant    		CONSTANT NUMBER := 20205; -- Application déjà existante
nuexc_mauvais_codappli    		CONSTANT NUMBER := 20206; -- Mauvais code Application, syntaxe: Axxxx
------------------------------
nuexc_coddossier_proj_existant    	CONSTANT NUMBER := 20207; -- Code dossier projet déjà existant
nuexc_mauvais_codproj    		CONSTANT NUMBER := 20208; -- Mauvais code projet, syntaxe: Pxxxx
nuexc_codmo_inexistant    		CONSTANT NUMBER := 20209; -- Code maître d'ouvrage inexistant
nuexc_coddossier_proj_inexiste    CONSTANT NUMBER := 20211; -- Code dossier projet inexistant
nuexc_coddossier_proj_existe2 	CONSTANT NUMBER := 20212; -- Code dossier projet déjà existant
nuexc_immeuble_existant    		CONSTANT NUMBER := 20213; -- Immeuble déjà existant
nuexc_cod_existant    			CONSTANT NUMBER := 20214; -- Code %s1 inexistant
nuexc_coddpg_inexistant2    		CONSTANT NUMBER := 20215; -- Code Département/Pôle/groupe %s1 inexistant
nuexc_coddpg_invalide    		CONSTANT NUMBER := 20216; -- Code Département/Pôle/Groupe invalide
nuexc_idcp_pas_une_personne    	CONSTANT NUMBER := 20218; -- Identifiant du chef de projet n'est pas une personne
nuexc_ressource_existante    		CONSTANT NUMBER := 20219; -- Ressource déjà existante
nuexc_correction_non_aut_div   	CONSTANT NUMBER := 20220; -- Correction non autorisée : vous êtes de la division %s1\n alors que cette ressource est de la division %s2
nuexc_correction_non_aut_pole 	CONSTANT NUMBER := 20221; -- Correction non autorisée : vous êtes du pôle %s1\n alors que cette ressource est du pôle %s2
nuexc_coddpg_invalide2    		CONSTANT NUMBER := 20223; -- Code Département/Pôle/Groupe invalide
nuexc_cod_inconnu_ou_ferme    	CONSTANT NUMBER := 20225; -- Code %s1 inconnu ou fermé
nuexc_idcp_inexistant    		CONSTANT NUMBER := 20226; -- Identifiant chef de projet %s1 inexistant
nuexc_datval_sup_datdepart    	CONSTANT NUMBER := 20227; -- La date de valeur doit être inférieure à la date de départ
------------------------------
nuexc_datvalsai_inf_datvalorig   	CONSTANT NUMBER := 20228; -- La date de valeur saisie est antérieure à la date de valeur d'origine
nuexc_situ_logiciel_modifie    	CONSTANT NUMBER := 20230; -- Situation Logiciel %s1 modifiée
nuexc_datvalsai_inf_datvalsitu    	CONSTANT NUMBER := 20231; -- La date de valeur saisie est inférieure à la plus ancienne des dates de valeur des situations
nuexc_ressource_pas_un_forfait    	CONSTANT NUMBER := 20233; -- Ressource %s1 de type %s2 ne correspond pas à un forfait
nuexc_suppr_imposs_reste_situ  	CONSTANT NUMBER := 20234; -- Suppression impossible, il ne reste qu'une seule situation
nuexc_codprestation_errone    	CONSTANT NUMBER := 20235; -- Code prestation %s1 erroné, saisir FH ou FS
nuexc_saisie_homonyme_imposs    	CONSTANT NUMBER := 20236; -- Il est impossible de saisir un homonyme
nuexc_ressource_pas_logiciel    	CONSTANT NUMBER := 20237; --  Ressource %s1 de type %s2 ne correspond pas un logiciel
nuexc_logiciel_existant    		CONSTANT NUMBER := 20240; --  Logiciel déjà existant
nuexc_codcout_inexistant    		CONSTANT NUMBER := 20241; --  Code coût FI %s1 inexistant pour l'année %s2
nuexc_faut_an_entre_1900_3000 	CONSTANT NUMBER := 20242; -- L'année doit être comprise entre 1900 et 3000
nuexc_coutfi_existant    		CONSTANT NUMBER := 20243; --  Coût FI déjà existant
nuexc_modif_non_autorise    		CONSTANT NUMBER := 20244; --  Modification non autorisée vous êtes %s1 alors que cette ressource est %s2
nuexc_forfait_sans_coddpg    		CONSTANT NUMBER := 20245; --  Forfait sans code Département/Pôle/Groupe
nuexc_prestation_errone    		CONSTANT NUMBER := 20246; --  Prestation %s1 erronée, consultez la table
nuexc_entrez_un_cout    		CONSTANT NUMBER := 20247; --  Entrez un coût
nuexc_faut_dispo_entre_0_et_7    	CONSTANT NUMBER := 20248; --  La disponibilité doit être comprise entre 0 et 7
nuexc_faut_codappli_diff_A0000 	CONSTANT NUMBER := 20249; --  Le code application doit être différent de A0000
nuexc_faut_codproj_diff_P0000  	CONSTANT NUMBER := 20250; --  Le code projet doit être différent de P0000
nuexc_ressource_pas_une_pers		CONSTANT NUMBER := 20251; --  Ressource %s1 de type %s2 ne correspond pas à une personne
nuexc_coddpg_ferme    			CONSTANT NUMBER := 20252; --  Code DPG %s1 fermé
nuexc_client_ferme    			CONSTANT NUMBER := 20253; --  Client %s1 fermé
nuexc_menu_utilise_inexistant    	CONSTANT NUMBER := 20265; --  Menu utilisé inexistant
nuexc_utilisateur_existant    	CONSTANT NUMBER := 20266; --  Utilisateur déjà existant
nuexc_calendrier_existant    		CONSTANT NUMBER := 20267; --  Calendrier déjà existant
nuexc_proposition_budget_exist   	CONSTANT NUMBER := 20268; --  Proposition de budget déjà existante
nuexc_non_habilite_maj_proposi  	CONSTANT NUMBER := 20269; --  Vous n'êtes pas habilité à mettre à jour cette proposition
nuexc_pas_de_cout_pour_cet_an  	CONSTANT NUMBER := 20271; --  Il n'y a pas de coût %s1 définit pour cette année
nuexc_dates_traitements_existe    	CONSTANT NUMBER := 20272; --  Dates de traitement existantes
nuexc_coddpg_inexistant3    		CONSTANT NUMBER := 20273; --  Code Département/Pôle inexistant
nuexc_coddpg_ferme2    			CONSTANT NUMBER := 20274; --  Code Département/Pôle/Groupe fermé
nuexc_codposte_est_0_ou_1    		CONSTANT NUMBER := 20275; --  Le code poste doit être 0 ou 1
nuexc_prestation_est_fs_ou_fh 	CONSTANT NUMBER := 20276; --  La prestation doit être FS ou FH
nuexc_ligne_bip_modifie    		CONSTANT NUMBER := 20277; --  Ligne Bip %s1 modifiée
nuexc_trop_de_select_ligne_bip   	CONSTANT NUMBER := 20278; --  Trop de Lignes Bip sélectionnées, veuillez restreindre votre sélection
nuexc_abs_ligne_bip_coddpg 		CONSTANT NUMBER := 20279; --  Il n'existe pas de ligne BIP pour le code DPG %s1
nuexc_contrat_inexistant    		CONSTANT NUMBER := 20280; --  Contrat inexistant
nuexc_contrat_existe_histo		 CONSTANT NUMBER := 20281; --  Contrat déjà existant dans histo_contrat
nuexc_incoherent_agrement_rang    	CONSTANT NUMBER := 20282; --  Incohérence entre l'agrément et le rang
nuexc_datarriv_gesach_sup_datj 	CONSTANT NUMBER := 20283; --  La date d'arrivée à GES/ACH doit être inférieure ou égale à la date du jour
nuexc_datfin_inf_datdebut    		CONSTANT NUMBER := 20284; --  La date de fin doit être supérieure ou égale à la date de début
nuexc_contrat_existant    		CONSTANT NUMBER := 20285; --  Contrat déjà existant
nuexc_contrat_existe_autre_fil	CONSTANT NUMBER := 20286; --  Le contrat existe déjà pour une autre filiale
nuexc_aucun_contrat_recent    	CONSTANT NUMBER := 20287; --  Aucun contrat récent
nuexc_aucun_contrat_historise    	CONSTANT NUMBER := 20288; --  Aucun contrat historisé
nuexc_codsoc_existant    		CONSTANT NUMBER := 20301; --  Code société déjà existant
nuexc_rens_datchg_datferm_seul 	CONSTANT NUMBER := 20302; --  Renseigner la date de changement seule ou\n la date de fermeture provisoire seule
nuexc_datferme_provis_inf_datj   	CONSTANT NUMBER := 20303; --  Date de fermeture provisoire inférieure à date du jour
nuexc_datferme_nouvsoc_ou_rien 	CONSTANT NUMBER := 20304; --  Saisir date fermeture et nouvelle société ou aucun des deux
nuexc_codnature_errone    		CONSTANT NUMBER := 20305; --  Code nature erroné: A=Agrée ou blanc


nuexc_codfour_existant    		CONSTANT NUMBER := 20307; --  Code fournisseur déjà existant
nuexc_codfour_inexistant    		CONSTANT NUMBER := 20308; --  Code fournisseur inexistant
nuexc_codcat_errone    			CONSTANT NUMBER := 20309; --  Code catégorie erroné
nuexc_propbud_existant    		CONSTANT NUMBER := 20310; --  Proposition de budget déjà existante
nuexc_notifbud_existant    		CONSTANT NUMBER := 20311; --  Notification de budget déjà existante
nuexc_notifarbitrage_existant    	CONSTANT NUMBER := 20312; --  Notification Arbitrage déjà existante
nuexc_pas_de_maj_annees_ant    	CONSTANT NUMBER := 20313; --  Pas de mise à jour sur les années antérieures
nuexc_erreur_lors_extraction    	CONSTANT NUMBER := 20401; --  Erreur lors de l'extraction
nuexc_erreur_gestion_fichier    	CONSTANT NUMBER := 20402; --  Erreur dans la gestion des fichiers
nuexc_bascule_bud_effectue    	CONSTANT NUMBER := 20410; --  Basculement du budget effectué

------------------------------
nuexc_codproj_inexiste_pour_an 	CONSTANT NUMBER := 20420; --  Code projet inexistant pour l'année saisie
nuexc_devis_bloque    			CONSTANT NUMBER := 20421; --  Devis bloqués
nuexc_proj_appartient_pas_pole    	CONSTANT NUMBER := 20422; --  Ce projet n'appartient pas à votre pôle
nuexc_abs_donne_pour_cet_an  		CONSTANT NUMBER := 20423; --  Pas de données pour cette année
nuexc_devis_cree    			CONSTANT NUMBER := 20424; --  Devis de type %s1 crée
nuexc_devis_existant    		CONSTANT NUMBER := 20425; --  Devis de type %s1 déjà existant
nuexc_concurrence_acces_devis		CONSTANT NUMBER := 20426; --  Acces concurrent sur le devis de type %s1
nuexc_devis_modifie    			CONSTANT NUMBER := 20427; --  Devis de type %s1 modifié
nuexc_mise_a_zeo_effectue    		CONSTANT NUMBER := 20428; --  Mise à zéro effectuée
nuexc_coutstd_inexiste_pour_an	CONSTANT NUMBER := 20429; --  Coût standard de type %s1 inexistant pour l'année saisie
nuexc_periode_errone    		CONSTANT NUMBER := 20431; --  Période erronée
nuexc_datenvpole_sup_datsaisie    	CONSTANT NUMBER := 20432; --  Date d'envoi au pôle doit être postérieure ou égale à la date de saisie
nuexc_datretpole_sup_datsaisie    	CONSTANT NUMBER := 20433; --  Date de retour du pôle doit être postérieure ou égale à la date de saisie
nuexc_saisie_obligatoire    		CONSTANT NUMBER := 20434; --  Saisie obligatoire
nuexc_codfiliale_existant    		CONSTANT NUMBER := 20501; --  Code filiale déjà existant
nuexc_codexception_existant    	CONSTANT NUMBER := 20502; --  Code exception déjà existant
nuexc_codcp_pas_une_personne    	CONSTANT NUMBER := 20503; --  Le code chef de projet %s1 ne correspond pas à une personne
nuexc_coddirection_inexiste    	CONSTANT NUMBER := 20505; --  Code direction %s1 inexistant
nuexc_codtypproj_inexistant    	CONSTANT NUMBER := 20506; --  Code type de projet %s1 inexistant
nuexc_erreur_insert_budget    	CONSTANT NUMBER := 20507; --  Erreur lors d'une insertion d'un budget %s1, veuillez recommencer l'initialisation
nuexc_abs_ligne_a_initialise		CONSTANT NUMBER := 20508; --  Il n'y a pas de lignes à initialiser %s1
nuexc_maj_budget    			CONSTANT NUMBER := 20509; --  Erreur lors de la mise à jour d'un budget %s1,\n%s2


nuexc_codtyp_existant    		CONSTANT NUMBER := 20604; --  Code type déjà existant
nuexc_proj_special_existant    	CONSTANT NUMBER := 20609; --  Projet spécial déjà existant
nuexc_typo_secondaire_existant    	CONSTANT NUMBER := 20614; --  Typologie secondaire déjà existante
------------------------------
nuexc_creatmodif_contrat_impos	CONSTANT NUMBER := 20710; --  Création ou modification de contrat impossible,\nce pôle n'existe pas
nuexc_codcompta_inexistant    	CONSTANT NUMBER := 20712; --  Le code comptable n'existe pas
nuexc_coddoss_proj_inexiste2    	CONSTANT NUMBER := 20729; --  Code dossier projet inexistant
nuexc_proj_special_non_aut    	CONSTANT NUMBER := 20730; --  Code projet spécial non autorisé
nuexc_coddpg_inexistant4    		CONSTANT NUMBER := 20731; --  Code Département/Pôle/Groupe inexistant
nuexc_creatmodif_lig_bip_impos 	CONSTANT NUMBER := 20732; --  Création ou modification de ligne BIP impossible,\nce client maîtrise d'ouvrage n'existe pas
nuexc_ident_appli_inexistant    	CONSTANT NUMBER := 20733; --  Identifiant Application inexistant
nuexc_typo_inexistant    		CONSTANT NUMBER := 20734; --  Typologie inexistante
nuexc_codproj_info_inexistant    	CONSTANT NUMBER := 20735; --  Code projet informatique inexistant
nuexc_typproj_inexistant    		CONSTANT NUMBER := 20736; --  Type de projet inexistant
nuexc_coddpg_inexistant5    		CONSTANT NUMBER := 20748; --  Code Département/Pôle/Groupe inexistant
nuexc_societe_inexistante    		CONSTANT NUMBER := 20749; --  Société inexistante
nuexc_codcamo_inexistant    		CONSTANT NUMBER := 20754; --  Code centre d'activité de la maîtrise d'ouvrage inexistant
nuexc_codgestproj_inexistant    	CONSTANT NUMBER := 20756; --  Code Gestionnaire de Projet inexistant
------------------------------
nuexc_crea_app_impos_pole     	CONSTANT NUMBER := 20758; --  Création ou modification de l'application impossible,\nce pôle n'existe pas
nuexc_crea_app_impos_climo   		CONSTANT NUMBER := 20759; --  Création ou modification de l'application impossible,\nce client maîtrise d'ouvrage n'existe pas
nuexc_crea_projinf_impos_climo   	CONSTANT NUMBER := 20760; --  Création ou modification de projet informatique impossible,\nce client maîtrise d'ouvrage n'existe pas
nuexc_crea_projinf_impos_pole  	CONSTANT NUMBER := 20761; --  Création ou modification de projet informatique impossible,\nce pôle n'existe pas
nuexc_crea_appli_impos_gest     	CONSTANT NUMBER := 20762; --  Création ou modification de l'application impossible,\nce gestionnaire d'application n'existe pas
nuexc_filiale_inexistante    		CONSTANT NUMBER := 20765; --  La filiale n'existe pas
nuexc_sup_filiale_impos_climo    	CONSTANT NUMBER := 20856; --  Suppression de la filiale impossible,\des clients maîtrise d'ouvrage sont rattachés à cette filiale
nuexc_sup_pole_impos_situ_ress    	CONSTANT NUMBER := 20860; --  Suppression du pôle impossible,\ndes situations ressources sont rattachées à ce pôle
nuexc_sup_contrat_impos_fact 		CONSTANT NUMBER := 20872; --  Suppression du contrat/avenant impossible,\ndes factures sont liées à ce contrat
nuexc_sup_soc_impos_situ_ress  	CONSTANT NUMBER := 20873; --  Suppression de la société impossible,\ndes situations ressources sont rattachées à cette société
nuexc_sup_proj_impos_ligne_bip    	CONSTANT NUMBER := 20880; --  Suppression de projet impossible,\des lignes BIP sont rattachées à ce projet
nuexc_sup_pole_impos_ligne_bip    	CONSTANT NUMBER := 20881; --  Suppression du pôle impossible,\ndes lignes BIP sont rattachées à ce pôle
nuexc_sup_cli_impos_ligne_bip    	CONSTANT NUMBER := 20882; --  Suppression du client impossible,\ndes lignes BIP sont rattachées à ce client maîtrise d'ouvrage
nuexc_sup_typo_impos_ligne_bip    	CONSTANT NUMBER := 20884; --  Suppression de typologie impossible,\des lignes BIP sont rattachées à cette typologie secondaire
nuexc_sup_type_impos_ligne_bip    	CONSTANT NUMBER := 20886; --  Suppression de type impossible,\des lignes BIP sont rattachées à ce type 1
------------------------------
nuexc_sup_imeub_impos_situ_res    	CONSTANT NUMBER := 20896; --  Suppression de l'immeuble impossible,\ndes ressources sont rattachées à cet immeuble
nuexc_sup_pol_impos_situ_ress2    	CONSTANT NUMBER := 20898; --  Suppression du pôle impossible,\ndes situations ressources sont rattachées à ce pôle
nuexc_sup_soc_impos_situ_ress2    	CONSTANT NUMBER := 20899; --  Suppression de le société impossible,\ndes situations ressources sont rattachées à cette société
nuexc_sup_ca_impos    			CONSTANT NUMBER := 20904; --  Le centre d'activité ne peut être supprimé
nuexc_sup_pole_impos_app    		CONSTANT NUMBER := 20908; --  Suppression du pôle impossible,\ndes applications sont rattachées à ce pôle
nuexc_sup_cli_impos_app    		CONSTANT NUMBER := 20909; --  Suppression du client impossible,\ndes applications sont rattachées à ce client maîtrise d'ouvrage
nuexc_sup_cli_impos_lig_bip    	CONSTANT NUMBER := 20910; --  Suppression du client impossible,\ndes lignes BIP sont rattachées à ce client maîtrise d'ouvrage
nuexc_sup_pole_impos_lig_bip2    	CONSTANT NUMBER := 20911; --  Suppression du pôle impossible,\ndes lignes BIP sont rattachées à ce pôle
nuexc_sup_cli_impos_app2    		CONSTANT NUMBER := 20912; --  Suppression du client impossible,\ndes applications sont rattachées à ce client maîtrise d'ouvrage

nuexc_pb_acces_histo_facture 		CONSTANT NUMBER := 20950; --  Problème d'accès à la table HISTO_FACTURE
nuexc_pb_acces_facture    		CONSTANT NUMBER := 20951; --  Problème d'accès à la table FACTURE
nuexc_pb_acces_facture_ou_soc		CONSTANT NUMBER := 20952; --  Problème d'accès à la table FACTURE ou SOCIETE
nuexc_pb_acces_contrat    		CONSTANT NUMBER := 20953; --  Problème d'accès à la table CONTRAT
nuexc_pb_acces_struct_info    	CONSTANT NUMBER := 20954; --  Problème d'accès à la table STRUCT_INFO
nuexc_pb_acces_code_compt    		CONSTANT NUMBER := 20955; --  Problème d'accès à la table CODE_COMPT

-- N° d'exception à lever dans la clause WHEN OTHERS
-- -------------------------------------------------
nuexc_others 				CONSTANT NUMBER := 20997;

nuexc_msg_inexiste_table_msg    	CONSTANT NUMBER := 20998; --  Message d'erreur inexistant dans la table des messages
nuexc_pb_acces_concurrent    		CONSTANT NUMBER := 20999; --  Accès concurrent sur les mêmes données,\nveuillez recharger vos données
*/

END pack_utile_numsg;
/

