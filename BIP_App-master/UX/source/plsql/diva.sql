/*
	diva.sql: fichier contenant le package pack_diva permettant la mise
	à jour des données budgétaires en provenance de l'application DIVA.

	créé le 16/08/2006 par David DEDIEU
	Modifications :
	Le 17/10/2006 par PPR : Ajout du statut diva
	Le 11/12/2006 par DDI : Modification de la gestion des statuts DIVA
	Le 09/01/2007 par DDI : Modification de la gestion des statuts DIVA
	Le 06/04/2007 par DDI : Suppression de traces dans fichier de log
	Le 04/06/2007 par DDI : Suppression des commentaires ==> MAJ Proposés
	Le 19/07/2007 par DDI : Ajout des extractions sur le referentiel Projets.
	Le 17/10/2007 par DDI : Modification des noms des procédures dans le SPEC.
	Le 12/11/2007 par DDI : TD 598 Ajout Extraction des consommes hors perimetre DIVA.
	Le 13/11/2007 par DDI : TD 598 Suppression des ident egaux a ZERO.
	le 18/12/2007 par EVI: TD598 formatage des numbers
	le 15/12/2008 par ECH : TD 725 : supp forfait générique 
	le 26/08/2009 par YSB : TD 782 : ajout des logues
	le 03/10/2009 par YSB : TD 782 : modification au niveau des logues
	le 22/12/2009 par YSB : TD 888 : modification au niveau de la gestion des budgets et des logs
	le 17/03/2010 par YSB : TD 888 : corréction du prbléme de mise à jour
	le 18/03/2010 par YSB : TD 888 : corréction du prbléme de mise à jour
	le 28/04/2011 par CMA : TD 828 : Prise en compte des consommés à zéro
	le 06/05/2011 par ABA : TD 828 : Prise en compte des consommés à zéro la table conso sstache res moi ne contient pas de consomé à zero donc on utilise
									  la table pwm_consomm pour recuperer tous les conso en excluant ceux de cons_sstache_res_mois_rejet
	le 24/05/2011 par ABA : QC 1194
	Le 02/10/2015 par ZAA : PPM 61919 §6.6
									  */

CREATE OR REPLACE PACKAGE PACK_DIVA IS

------------------------------------------------------------
-- procedure générale permettant le lancement des procédures
-- d'insertions des données de l'application DIVA.
------------------------------------------------------------
PROCEDURE global_diva (P_LOGDIR VARCHAR2);

--------------------------------------------------------------
-- Cette procedure met à jour ou créee les données budgétaires
-- envoyées par l'application DIVA.
--------------------------------------------------------------
	PROCEDURE maj_budgets (P_HFILE utl_file.file_type) ;

--------------------------------------------------------------
-- Export du référentiel PROJETS.
--------------------------------------------------------------
PROCEDURE projets (
	p_chemin_fichier IN VARCHAR2,
	p_nom_fichier    IN VARCHAR2
);

--------------------------------------------------------------
-- Export du référentiel DOSSIERS PROJETS.
--------------------------------------------------------------
PROCEDURE dossiers_projets (
	p_chemin_fichier IN VARCHAR2,
	p_nom_fichier    IN VARCHAR2
);

------------------------------------------------------------
-- Procédure alimentant la table DIVA_CONSO_HP.
------------------------------------------------------------
PROCEDURE alim_conso_hp (p_chemin_fichier IN VARCHAR2,
                      	 p_nom_fichier    IN VARCHAR2);


--------------------------------------------------------------------------------
----ZAA : PPM 61919 chapitre 6.6
--------------------------------------------------------------------------------
PROCEDURE global_diva_dmp(P_LOGDIR          IN VARCHAR2);

--------------------------------------------------------------------------------
-- ZAA PPM 61163 -chapitre 6.12
--------------------------------------------------------------------------------
TYPE array_number IS TABLE OF NUMBER(2) INDEX BY BINARY_INTEGER;

PROCEDURE liste_dir_bbrf03(p_liste_dir_num OUT PACK_DIVA.array_number);

FUNCTION is_bbrf03 (p_valeur IN VARCHAR2) RETURN BOOLEAN;

FUNCTION is_dir_dpg(p_codsg IN ligne_bip.codsg%type) return VARCHAR;

FUNCTION is_dir_code_client(p_clicode IN ligne_bip.clicode%type) return VARCHAR;

PROCEDURE globale;

PROCEDURE SELECT_EXPORT_DMP(p_chemin_fichier IN VARCHAR2,p_nom_fichier    IN VARCHAR2);

FUNCTION is_BBRF_03_client_DPG(CLICODELIG IN LIGNE_BIP.clicode%type,CODSGLIG   IN STRUCT_INFO.CODSG%type) return VARCHAR;

END pack_diva;
/

CREATE OR REPLACE PACKAGE BODY "PACK_DIVA" IS


                -- -------------------
                -- Gestions exceptions
                -- -------------------
                CALLEE_FAILED exception;
                pragma exception_init( CALLEE_FAILED, -20000 );
                CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
                TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !
                ERR_FONCTIONNELLE_ID number := -20002;   -- pour provoquer erreur alors que Oracle OK
                CONSTRAINT_VIOLATION exception;          -- pour clause when
                pragma exception_init( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère

-----------------------------------------------------------------------------
-- PROCEDURE DE MAJ ET DE CREATION DES DONNEES BUDGETAIRES PROVENANT DE DIVA.
-----------------------------------------------------------------------------

PROCEDURE maj_budgets (P_HFILE utl_file.file_type)  IS

L_PID ligne_bip.pid%TYPE;
L_ANNEE1 budget.annee%TYPE;
L_TOP_DIVA_FOURNISSEUR struct_info.top_diva%TYPE;
L_TOP_DIVA_CLIENT client_mo.top_diva%TYPE;

referential_integrity EXCEPTION;
PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

L_PROCNAME  varchar2(256) := 'PACK_DIVA.maj_budgets';
L_STATEMENT varchar2(256);
L_Requete varchar2(5000);
L_UN        NUMBER ;
l_bud_prop  VARCHAR2(13);
l_bud_propmo  VARCHAR2(13);
l_bud_rst   VARCHAR2(13);
-- -----------------------------------------------------------------------------
-- Curseur qui parcourt la table temporaire TMP_DIVA_BUDGETS alimentée par DIVA.
-- -----------------------------------------------------------------------------

CURSOR C_BUDG IS SELECT PID,PNOM,ANNEE,BPMONTME,BPMONTME1,REESTIME
                         FROM TMP_DIVA_BUDGETS
                         ;

BEGIN
                -----------------------------------------------------
                -- Trace Start
                -----------------------------------------------------
                TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

    FOR ONE_BUDG IN C_BUDG LOOP
                  --  TRCLOG.TRCLOG( P_HFILE, 'Debut insertion des données budgétaires: '||ONE_budg.pid||' - '||ONE_BUDG.annee);

		BEGIN

		-- -----------------------------------------------
		-- Test d'existence de la ligne BIP
		-- ET Récupération des codes client et fournisseurs de la ligne BIP
		-- ET des Tops DIVA associés
		-- -----------------------------------------------
                 SELECT S.TOP_DIVA, C.TOP_DIVA  INTO L_TOP_DIVA_FOURNISSEUR, L_TOP_DIVA_CLIENT
                 FROM ligne_bip L, struct_info S, client_MO C
                 WHERE L.pid = ONE_BUDG.pid
                 AND   S.codsg = L.codsg
                 AND   C.clicode = L.clicode;

-- Première condition sur les TOPS.
                 if (
		      (L_TOP_DIVA_FOURNISSEUR='O' and L_TOP_DIVA_CLIENT='O')
                      or (L_TOP_DIVA_FOURNISSEUR='O' and L_TOP_DIVA_CLIENT='Y')
                      or (L_TOP_DIVA_FOURNISSEUR='X' and L_TOP_DIVA_CLIENT='O')
                    ) then

		-- -------------------------------------
		-- Mise à jour des budgets de l'année N.
		-- met à jour le proposé ME
		-- met à jour le proposé MO
		-- -------------------------------------
		BEGIN

--		                            TRCLOG.TRCLOG( P_HFILE, 'Cas1  pour : '||ONE_BUDG.pid);

		                SELECT  bpmontme,
                            bpmontmo,
                            reestime
		                INTO    l_bud_prop,
                            l_bud_propmo,
                            l_bud_rst
		                FROM    BUDGET
              WHERE   BUDGET.pid   = ONE_BUDG.pid
              AND        BUDGET.ANNEE = ONE_BUDG.annee  ;


            L_Requete := 'UPDATE BUDGET SET ';

            --Condition BPMONTME
            IF (RTRIM(LTRIM(l_bud_prop)) != RTRIM(LTRIM(ONE_BUDG.bpmontme))) or (l_bud_prop is null)
            THEN
                L_Requete := L_Requete || 'BPMONTME          = ''' || ONE_BUDG.bpmontme || ''', bpdate = ''' || sysdate || ''', ubpmontme = ''DIVA'', ' ;
            END IF;

            --Condition BPMONTMO
            IF (RTRIM(LTRIM(l_bud_propmo)) != RTRIM(LTRIM(ONE_BUDG.bpmontme))) or (l_bud_propmo is null)
            THEN
                L_Requete := L_Requete || 'BPMONTMO         = ''' || ONE_BUDG.bpmontme || ''', bpmedate = ''' || sysdate || ''', ubpmontmo = ''DIVA'', ';
            END IF;

            --Condition REESTIME
            IF (RTRIM(LTRIM(ONE_BUDG.reestime)) != RTRIM(LTRIM(l_bud_rst))) or (l_bud_rst is null)
            THEN
               L_Requete := L_Requete || 'REESTIME = ''' || ONE_BUDG.reestime || ''', redate  = ''' || sysdate || ''', ureestime = ''DIVA'', ';
            END IF;

            L_Requete := L_Requete || ' BUDGET.pid = ''' || ONE_BUDG.pid || ''' WHERE     BUDGET.pid       = '''|| ONE_BUDG.pid ||'''
		        AND              BUDGET.ANNEE = TO_NUMBER( '''||ONE_BUDG.annee||''')';

            EXECUTE IMMEDIATE L_Requete;



            -- 12/08/09 -YSB  : on logue les budgets
            IF (RTRIM(LTRIM(ONE_BUDG.reestime)) != RTRIM(LTRIM(l_bud_rst))) or (l_bud_rst is null)
            THEN

                Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Réestimé  ' || ONE_BUDG.annee, l_bud_rst,ONE_BUDG.reestime, 'DIVA Batch');
            END IF;

            IF (RTRIM(LTRIM(l_bud_propmo)) != RTRIM(LTRIM(ONE_BUDG.bpmontme))) or (l_bud_propmo is null)
            THEN

                Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé client ' || ONE_BUDG.annee, l_bud_propmo,ONE_BUDG.bpmontme, 'DIVA Batch');
            END IF;

            IF (RTRIM(LTRIM(l_bud_prop)) != RTRIM(LTRIM(ONE_BUDG.bpmontme))) or (l_bud_prop is null)
            THEN

                Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé fournisseur ' || ONE_BUDG.annee, l_bud_prop,ONE_BUDG.bpmontme, 'DIVA Batch');
            END IF;

		EXCEPTION           -- La ligne n'existe pas dans la table BUDGET --
		                    WHEN NO_DATA_FOUND THEN
				               BEGIN
						 TRCLOG.TRCLOG( P_HFILE, 'Insertion 1 pour : '||ONE_BUDG.pid||' - '||ONE_BUDG.annee);
            --Debut YNI FDT 888
						 INSERT INTO BUDGET(annee,pid,bnmont,bpmontme,bpmontme2,anmont,bpdate,reserve,
										                  apdate,apmont,bpmontmo,reestime,bpmedate,bndate,redate,
		             ubpmontme,ubpmontmo,ubnmont,uanmont,ureestime,flaglock)
								                 VALUES
								                 (ONE_BUDG.annee,
								                 ONE_BUDG.pid,
								                 NULL,
								                 ONE_BUDG.bpmontme,
								                 NULL,
								                 NULL,
								                 SYSDATE,
								                 NULL,
								                 SYSDATE,
								                 NULL,
								                 ONE_BUDG.bpmontme,
								                 ONE_BUDG.reestime,
		      SYSDATE,
		      SYSDATE,
		      SYSDATE,
		      'DIVA',
		      'DIVA',
		      'DIVA',
		      'DIVA',
		      'DIVA',
								                 0
								                 );

                -- 12/08/09 -YSB  : on logue les budgets
                IF ONE_BUDG.reestime is not null THEN

                    Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Réestimé  ' || ONE_BUDG.annee, NULL,ONE_BUDG.reestime, 'DIVA Batch');
                END IF;

                IF ONE_BUDG.bpmontme is not null THEN

                    Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé client ' || ONE_BUDG.annee, NULL,ONE_BUDG.bpmontme, 'DIVA Batch');
                    Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé fournisseur ' || ONE_BUDG.annee, NULL,ONE_BUDG.bpmontme, 'DIVA Batch');
                END IF;
              END;
                END; -- MAJ Année N --

		-- --------------------------------------
		-- Mise à jour du proposé de l'année N+1.
		-- --------------------------------------
		BEGIN

				                L_ANNEE1 := ONE_BUDG.annee ;
                L_ANNEE1 := ONE_BUDG.annee + 1;

                SELECT  bpmontme,
                            bpmontmo
                INTO    l_bud_prop,
                            l_bud_propmo
                FROM    BUDGET
				   WHERE               BUDGET.pid   = ONE_BUDG.pid
				   AND    BUDGET.ANNEE = L_ANNEE1  ;


            L_Requete := 'UPDATE  BUDGET  SET ';

            --Condition BPMONTME
            IF (RTRIM(LTRIM(l_bud_prop)) != RTRIM(LTRIM(ONE_BUDG.bpmontme1))) or (l_bud_prop is null)
            THEN
                L_Requete := L_Requete || 'BPMONTME          = ''' || ONE_BUDG.bpmontme1 || ''', bpdate = ''' || sysdate || ''', ubpmontme = ''DIVA'', ' ;
            END IF;

            --Condition BPMONTMO
            IF (RTRIM(LTRIM(l_bud_propmo)) != RTRIM(LTRIM(ONE_BUDG.bpmontme1))) or (l_bud_propmo is null)
            THEN
                L_Requete := L_Requete || 'BPMONTMO         = ''' || ONE_BUDG.bpmontme1 || ''', bpmedate = ''' || sysdate || ''', ubpmontmo = ''DIVA'', ';
            END IF;


            L_Requete := L_Requete || ' BUDGET.pid = ''' || ONE_BUDG.pid || ''' WHERE     BUDGET.pid       = '''|| ONE_BUDG.pid ||'''
		        AND              BUDGET.ANNEE = TO_NUMBER( '''||L_ANNEE1||''')';

            EXECUTE IMMEDIATE L_Requete;

                    -- 12/08/09 -YSB  : on logue les budgets
                    IF (RTRIM(LTRIM(l_bud_propmo)) != RTRIM(LTRIM(ONE_BUDG.bpmontme1))) or (l_bud_propmo is null)
                    THEN

                        Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé client ' || L_ANNEE1, l_bud_propmo,ONE_BUDG.bpmontme1, 'DIVA Batch');
                    END IF;

                    IF (RTRIM(LTRIM(l_bud_prop)) != RTRIM(LTRIM(ONE_BUDG.bpmontme1))) or (l_bud_prop is null)
                    THEN

                        Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé fournisseur ' || L_ANNEE1, l_bud_prop,ONE_BUDG.bpmontme1, 'DIVA Batch');
                    END IF;

		EXCEPTION           -- La ligne n'existe pas dans la table BUDGET --
		                    WHEN NO_DATA_FOUND THEN
				               BEGIN
						 TRCLOG.TRCLOG( P_HFILE, 'Insertion 1 du budget (année+1)  pour : '||ONE_BUDG.pid||' ; '||L_ANNEE1);
						 INSERT INTO BUDGET(annee,pid,bnmont,bpmontme,bpmontme2,anmont,bpdate,reserve,
										  apdate,apmont,bpmontmo,reestime,bpmedate,bndate,redate,
		             ubpmontme,ubpmontmo,ubnmont,uanmont,ureestime,flaglock)
								                 VALUES
								                 (L_ANNEE1,
								                 ONE_BUDG.pid,
								                 NULL,
								                 ONE_BUDG.bpmontme1,
								                 NULL,
								                 NULL,
								                 SYSDATE,
								                 NULL,
								                 SYSDATE,
								                 NULL,
								                 ONE_BUDG.bpmontme1,
								                 NULL,
		      SYSDATE,
		      SYSDATE,
		      SYSDATE,
		      'DIVA',
		      'DIVA',
		      'DIVA',
		      'DIVA',
		      'DIVA',
								                 0
								                 );
                      -- 12/08/09 -YSB  : on logue les budgets
                      IF ONE_BUDG.bpmontme1 is not null
                      THEN

                        Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé client ' || L_ANNEE1, NULL,ONE_BUDG.bpmontme1, 'DIVA Batch');
                        Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé fournisseur ' || L_ANNEE1, NULL,ONE_BUDG.bpmontme1, 'DIVA Batch');
                      END IF;

              END;
		END; -- MAJ Année N+1 --
                END IF; -- END IF sur la première condition des TOPS

            -- Deuxième condition sur les TOPS.
                 if (
		      (L_TOP_DIVA_FOURNISSEUR='O' and L_TOP_DIVA_CLIENT='N')
                    ) then

		-- -------------------------------------
		-- Mise à jour des budgets de l'année N.
		-- met à jour le proposé Fournisseur.
				 -- met à jour le Reestimé.
		-- -------------------------------------
		BEGIN

--		                            TRCLOG.TRCLOG( P_HFILE, 'Cas2  pour : '||ONE_BUDG.pid);

		                SELECT  bpmontme,
                            reestime
		                INTO    l_bud_prop,
                            l_bud_rst
		                FROM    BUDGET
				                 WHERE                 BUDGET.pid   = ONE_BUDG.pid
				     AND BUDGET.ANNEE = ONE_BUDG.annee  ;

            L_Requete := 'UPDATE  BUDGET  SET ';

            --Condition BPMONTME
            IF (RTRIM(LTRIM(l_bud_prop)) != RTRIM(LTRIM(ONE_BUDG.bpmontme))) or (l_bud_prop is null)
            THEN
                L_Requete := L_Requete || 'BPMONTME          = ''' || ONE_BUDG.bpmontme || ''', bpdate = ''' || sysdate || ''', ubpmontme = ''DIVA'', ' ;
            END IF;

            --Condition REESTIME
            IF (RTRIM(LTRIM(ONE_BUDG.reestime)) != RTRIM(LTRIM(l_bud_rst))) or (l_bud_rst is null)
            THEN
               L_Requete := L_Requete || 'REESTIME = ''' || ONE_BUDG.reestime || ''', redate  = ''' || sysdate || ''', ureestime = ''DIVA'', ';
            END IF;


            L_Requete := L_Requete || ' BUDGET.pid = ''' || ONE_BUDG.pid || ''' WHERE     BUDGET.pid       = '''|| ONE_BUDG.pid ||'''
		        AND              BUDGET.ANNEE = TO_NUMBER( '''||ONE_BUDG.annee||''')';

            EXECUTE IMMEDIATE L_Requete;

                    -- 12/08/09 -YSB  : on logue les budgets

                    IF (RTRIM(LTRIM(l_bud_rst)) != RTRIM(LTRIM(ONE_BUDG.reestime))) or  (l_bud_rst is null)
                    THEN

                        Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Réestimé  ' || ONE_BUDG.annee, l_bud_rst,ONE_BUDG.reestime, 'DIVA Batch');
                    END IF;

                    IF (RTRIM(LTRIM(l_bud_prop)) != RTRIM(LTRIM(ONE_BUDG.bpmontme))) or  (l_bud_prop is null)
                    THEN

                        Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé fournisseur ' || ONE_BUDG.annee, l_bud_prop,ONE_BUDG.bpmontme, 'DIVA Batch');
                    END IF;


		EXCEPTION           -- La ligne n'existe pas dans la table BUDGET --
		                    WHEN NO_DATA_FOUND THEN
				                BEGIN
						 TRCLOG.TRCLOG( P_HFILE, 'Insertion 2 pour : '||ONE_BUDG.pid||' - '||ONE_BUDG.annee);
						 INSERT INTO BUDGET(annee,pid,bnmont,bpmontme,bpmontme2,anmont,bpdate,reserve,
										                  apdate,apmont,bpmontmo,reestime,bpmedate,bndate,redate,
		             ubpmontme,ubpmontmo,ubnmont,uanmont,ureestime,flaglock)
								                 VALUES
								                 (ONE_BUDG.annee,
								                 ONE_BUDG.pid,
								                 NULL,
								                 ONE_BUDG.bpmontme,
								                 NULL,
								                 NULL,
								                 SYSDATE,
								                 NULL,
								                 SYSDATE,
								                 NULL,
								                 NULL,
								                 ONE_BUDG.reestime,
		      SYSDATE,
		      SYSDATE,
		      SYSDATE,
		      'DIVA',
		      'DIVA',
		      'DIVA',
		      'DIVA',
		      'DIVA',
								                 0
								                 );
                        -- 12/08/09 -YSB  : on logue les budgets
                        IF ONE_BUDG.reestime is not null
                        THEN

                            Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Réestimé  ' || ONE_BUDG.annee, NULL,ONE_BUDG.reestime, 'DIVA Batch');
                        END IF;

                        IF ONE_BUDG.bpmontme is not null
                        THEN

                            Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé fournisseur ' || ONE_BUDG.annee, NULL,ONE_BUDG.bpmontme, 'DIVA Batch');
                        END IF;


                        END;
		END; -- MAJ Année N --

		-- -------------------------------------------------
		-- Mise à jour du proposé FOURNISSEUR de l'année N+1.
		-- -------------------------------------------------
		BEGIN
				                L_ANNEE1 := ONE_BUDG.annee ;
		                L_ANNEE1 := ONE_BUDG.annee + 1;

		                SELECT  bpmontme
		               INTO    l_bud_prop
		                FROM    BUDGET
				                 WHERE                 BUDGET.pid   = ONE_BUDG.pid
				     AND BUDGET.ANNEE = L_ANNEE1  ;

            IF (RTRIM(LTRIM(l_bud_prop)) != RTRIM(LTRIM(ONE_BUDG.bpmontme1))) or  (l_bud_prop is null)
            THEN
		                UPDATE BUDGET
		                SET   BPMONTME     = ONE_BUDG.bpmontme1,
                          bpdate = sysdate,
                          ubpmontme = 'DIVA'
				                WHERE BUDGET.pid   = ONE_BUDG.pid
				 AND   BUDGET.ANNEE = L_ANNEE1;
           END IF;
                    -- 12/08/09 -YSB  : on logue les budgets
                    IF (RTRIM(LTRIM(l_bud_prop)) != RTRIM(LTRIM(ONE_BUDG.bpmontme1))) or  (l_bud_prop is null)
                    THEN

                        Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé fournisseur ' || L_ANNEE1, l_bud_prop,ONE_BUDG.bpmontme1, 'DIVA Batch');
                    END IF;

		EXCEPTION           -- La ligne n'existe pas dans la table BUDGET --
		                    WHEN NO_DATA_FOUND THEN
				               BEGIN
						 TRCLOG.TRCLOG( P_HFILE, 'Insertion 2 du budget (année+1)  pour : '||ONE_BUDG.pid||' ; '||L_ANNEE1);
						 INSERT INTO BUDGET(annee,pid,bnmont,bpmontme,bpmontme2,anmont,bpdate,reserve,
										  apdate,apmont,bpmontmo,reestime,bpmedate,bndate,redate,
		             ubpmontme,ubpmontmo,ubnmont,uanmont,ureestime,flaglock)
								                 VALUES
								                 (L_ANNEE1,
								                 ONE_BUDG.pid,
								                 NULL,
								                 ONE_BUDG.bpmontme1,
								                 NULL,
								                 NULL,
								                 SYSDATE,
								                 NULL,
								                 SYSDATE,
								                 NULL,
								                 NULL,
								                 NULL,
		      SYSDATE,
		      SYSDATE,
		      SYSDATE,
		      'DIVA',
		      'DIVA',
		      'DIVA',
		      'DIVA',
		      'DIVA',
								                 0
								                 );
                    -- 12/08/09 -YSB  : on logue les budgets
                    IF ONE_BUDG.bpmontme1 is not null
                    THEN

                        Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé fournisseur ' || L_ANNEE1, l_bud_prop,ONE_BUDG.bpmontme1, 'DIVA Batch');
		                END IF;
                    END;
		END; -- MAJ Année N+1 --
                END IF; -- END IF sur la deuxième condition des TOPS

            -- Troisième condition sur les TOPS.
                 if (
		      (L_TOP_DIVA_FOURNISSEUR='N' and L_TOP_DIVA_CLIENT='O')
                    ) then

		-- -------------------------------------
		-- Mise à jour des budgets de l'année N.
		-- met à jour le proposé MO
		-- -------------------------------------
		BEGIN

                --TRCLOG.TRCLOG( P_HFILE, 'Cas3  pour : '||ONE_BUDG.pid);

		                SELECT  bpmontmo
		                INTO    l_bud_propmo
		                FROM    BUDGET
				                 WHERE                 BUDGET.pid   = ONE_BUDG.pid
				     AND BUDGET.ANNEE = ONE_BUDG.annee  ;


            IF (RTRIM(LTRIM(l_bud_propmo)) != RTRIM(LTRIM(ONE_BUDG.bpmontme))) or (l_bud_propmo is null)
            THEN
		     UPDATE BUDGET
		                  SET BPMONTMO           = ONE_BUDG.bpmontme,
                        bpmedate = sysdate,
                        ubpmontmo = 'DIVA'
				        WHERE          BUDGET.pid       = ONE_BUDG.pid
				        AND               BUDGET.ANNEE = ONE_BUDG.annee  ;
            END IF;
                    -- 12/08/09 -YSB  : on logue les budgets
            IF (RTRIM(LTRIM(l_bud_propmo)) != RTRIM(LTRIM(ONE_BUDG.bpmontme))) or (l_bud_propmo is null)
            THEN

                   Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé client ' || ONE_BUDG.annee, l_bud_propmo,ONE_BUDG.bpmontme, 'DIVA Batch');
            END IF;

            EXCEPTION           -- La ligne n'existe pas dans la table BUDGET --
		                      WHEN NO_DATA_FOUND THEN
				                 BEGIN
						 TRCLOG.TRCLOG( P_HFILE, 'Insertion 3 pour : '||ONE_BUDG.pid||' - '||ONE_BUDG.annee);
						 INSERT INTO BUDGET(annee,pid,bnmont,bpmontme,bpmontme2,anmont,bpdate,reserve,
										                  apdate,apmont,bpmontmo,reestime,bpmedate,bndate,redate,
		             ubpmontme,ubpmontmo,ubnmont,uanmont,ureestime,flaglock)
								                 VALUES
								                 (ONE_BUDG.annee,
								                 ONE_BUDG.pid,
								                 NULL,
								                 NULL,
								                 NULL,
								                 NULL,
								                 SYSDATE,
								                 NULL,
								                 SYSDATE,
								                 NULL,
								                 ONE_BUDG.bpmontme,
								                 NULL,
		      SYSDATE,
		      SYSDATE,
		      SYSDATE,
		      'DIVA',
		      'DIVA',
		      'DIVA',
		      'DIVA',
		      'DIVA',
								                 0
								                 );
                            -- 12/08/09 -YSB  : on logue les budgets
                            IF ONE_BUDG.bpmontme is not null
                            THEN

		 Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé client ' || ONE_BUDG.annee, NULL,ONE_BUDG.bpmontme, 'DIVA Batch');
                            END IF;

                    END;
		END; -- MAJ Année N --

		-- --------------------------------------
		-- Mise à jour du proposé de l'année N+1.
		-- --------------------------------------
		BEGIN
				                L_ANNEE1 := ONE_BUDG.annee ;
		                L_ANNEE1 := ONE_BUDG.annee + 1;

            SELECT  bpmontmo
		                INTO    l_bud_propmo
		                FROM    BUDGET
				                 WHERE                 BUDGET.pid   = ONE_BUDG.pid
				     AND BUDGET.ANNEE = L_ANNEE1  ;

            IF (RTRIM(LTRIM(l_bud_propmo)) != RTRIM(LTRIM(ONE_BUDG.bpmontme1))) or (l_bud_propmo is null)
            THEN
		                UPDATE BUDGET
		                SET   BPMONTMO     = ONE_BUDG.bpmontme1,
                          bpmedate = sysdate,
                          ubpmontmo = 'DIVA'
				                WHERE BUDGET.pid   = ONE_BUDG.pid
				 AND   BUDGET.ANNEE = L_ANNEE1;
            END IF;

                    -- 12/08/09 -YSB  : on logue les budgets
                    IF (RTRIM(LTRIM(l_bud_propmo)) != RTRIM(LTRIM(ONE_BUDG.bpmontme1))) or (l_bud_propmo is null)
                    THEN

                        Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé client ' || L_ANNEE1, l_bud_propmo,ONE_BUDG.bpmontme1, 'DIVA Batch');
                    END IF;

            EXCEPTION           -- La ligne n'existe pas dans la table BUDGET --
		                    WHEN NO_DATA_FOUND THEN
				               BEGIN
						 TRCLOG.TRCLOG( P_HFILE, 'Insertion 3 du budget (année+1)  pour : '||ONE_BUDG.pid||' ; '||L_ANNEE1);
						 INSERT INTO BUDGET(annee,pid,bnmont,bpmontme,bpmontme2,anmont,bpdate,reserve,
										  apdate,apmont,bpmontmo,reestime,bpmedate,bndate,redate,
		             ubpmontme,ubpmontmo,ubnmont,uanmont,ureestime,flaglock)
								                 VALUES
								                 (L_ANNEE1,
								                 ONE_BUDG.pid,
								                 NULL,
								                 NULL,
								                 NULL,
								                 NULL,
								                 SYSDATE,
								                 NULL,
								                 SYSDATE,
								                 NULL,
								                 ONE_BUDG.bpmontme1,
								                 NULL,
		      SYSDATE,
		      SYSDATE,
		      SYSDATE,
		      'DIVA',
		      'DIVA',
		      'DIVA',
		      'DIVA',
		      'DIVA',
								                 0
								                 );
                            -- 12/08/09 -YSB  : on logue les budgets
                            IF ONE_BUDG.bpmontme1 is not null
                            THEN
		 Pack_Ligne_Bip.maj_ligne_bip_logs(ONE_BUDG.pid, 'DIVA', 'Proposé client ' || L_ANNEE1, NULL,ONE_BUDG.bpmontme1, 'DIVA Batch');
                            END IF;

                    END;
		END; -- MAJ Année N+1 --
                END IF;
        -- END IF sur la troisième condition des TOPS
        EXCEPTION
		  WHEN NO_DATA_FOUND THEN
		                TRCLOG.TRCLOG( P_HFILE, 'Ligne BIP inexistante : '||ONE_BUDG.pid);
        END;
     END LOOP;


                -----------------------------------------------------
                -- Trace Stop
                -----------------------------------------------------
                TRCLOG.TRCLOG( P_HFILE, 'Fin normale de ' || L_PROCNAME  );

EXCEPTION
		when others then

		                ROLLBACK;

		                if sqlcode <> CALLEE_FAILED_ID and sqlcode <> TRCLOG_FAILED_ID then
				 TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || SQLERRM );
		                end if;
		                if sqlcode <> TRCLOG_FAILED_ID then
				 TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				 raise_application_error( CALLEE_FAILED_ID,
				                         'Erreur : consulter le fichier LOG',
				                          false );
		                else
				 raise;
		                end if;

END maj_budgets;

-- ======================================================================
-- Extractions du referentiel Projets pour l application DIVA.
-- ======================================================================
PROCEDURE projets(
                        p_chemin_fichier        IN VARCHAR2,
                        p_nom_fichier           IN VARCHAR2
        ) IS
                CURSOR csr_projets IS
				                   select pi.icpi icpi,
						    trim(pi.ilibel) ilibel,
						    pi.STATUT statut,
						    to_char(pi.DATDEM,'MM/YYYY') datdem,
/*              DECODE (pi.STATUT, 'A','Abandonné',
						   'D','Démarré',
						   'N','Non Amortissable',
						   'O','Non Amortissable',
						   'Q','Démarré Sans Amortissement',
						   'R','Abandonné sans Immo',
						   'Pas de Statut'),
						 */pi.CADA cada,
						    pi.ICODPROJ icodproj
				                from proj_info pi
				                where ( pi.datdem >= '01/01/2007' or pi.datdem is null )
				                and pi.icpi not like 'PM%'
				                and pi.ICODPROJ != 10000
				                order by pi.icpi;

                l_msg  VARCHAR2(1024);
                l_hfile UTL_FILE.FILE_TYPE;
        BEGIN
                Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);

                FOR rec_projets IN csr_projets LOOP
                        Pack_Global.WRITE_STRING( l_hfile,
		 rec_projets.icpi || ';' ||
		 rec_projets.ilibel || ';' ||
		 rec_projets.statut || ';' ||
		 rec_projets.datdem || ';' ||
		 rec_projets.cada || ';' ||
		 rec_projets.icodproj
		 );
                END LOOP;
                Pack_Global.CLOSE_WRITE_FILE(l_hfile);
        EXCEPTION
                WHEN OTHERS THEN
                        Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
                        RAISE_APPLICATION_ERROR(-20401, l_msg);
END projets;

-- ======================================================================
-- Extractions du referentiel Dossiers Projets pour l application DIVA.
-- ======================================================================
PROCEDURE dossiers_projets(
                        p_chemin_fichier        IN VARCHAR2,
                        p_nom_fichier           IN VARCHAR2
        ) IS
                CURSOR csr_dossproj IS
		select distinct dp.dpcode dpcode,
		                trim(dp.dplib) dplib,
		                dp.actif actif,
		                dp.datimmo datimmo
		from dossier_projet dp, proj_info pi
		where dp.dpcode != 10000
		and (
		                ((dp.ACTIF='N') and ((to_char(pi.DATDEM,'YYYY') >= to_char(sysdate,'YYYY')) or pi.datdem is null) and (dp.dpcode = pi.ICODPROJ) )
		                OR
		                (dp.ACTIF='O' )
		)
		order by dpcode;

                l_msg  VARCHAR2(1024);
                l_hfile UTL_FILE.FILE_TYPE;
        BEGIN
                Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);

                FOR rec_dossproj IN csr_dossproj LOOP
                        Pack_Global.WRITE_STRING( l_hfile,
		 rec_dossproj.dpcode|| ';' ||
		 rec_dossproj.dplib|| ';' ||
		 rec_dossproj.actif|| ';' ||
		 rec_dossproj.datimmo
		 );
                END LOOP;
                Pack_Global.CLOSE_WRITE_FILE(l_hfile);
        EXCEPTION
                WHEN OTHERS THEN
                        Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
                        RAISE_APPLICATION_ERROR(-20401, l_msg);
END dossiers_projets;

------------------------------------------------------------
-- Procédure générale lançant les mises à jour.
------------------------------------------------------------
PROCEDURE global_diva (P_LOGDIR VARCHAR2) IS

		P_HFILE utl_file.file_type;
		 L_RETCOD number;
		L_PROCNAME varchar2(30):='MAJ_BUDGETS';

                BEGIN
		-- Init de la trace
		-- ----------------
		L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, P_HFILE );
		if ( L_RETCOD <> 0 ) then
		raise_application_error( TRCLOG_FAILED_ID,
		                         'Erreur : Gestion du fichier LOG impossible',
		                         false );
		end if;

		-- Trace Start
		-- -----------
		TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

		-- lancement des procédures
		-- ------------------------
		      pack_diva.maj_budgets (P_HFILE) ;


		-- Trace Stop
		-- ----------
		TRCLOG.TRCLOG( P_HFILE, 'Fin normale de ' || L_PROCNAME  );
		TRCLOG.CLOSETRCLOG( P_HFILE );

                exception

		when others then
		                rollback;
		                if sqlcode <> CALLEE_FAILED_ID and
		                   sqlcode <> TRCLOG_FAILED_ID then
				 TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || SQLERRM );
		                end if;
		                if sqlcode <> TRCLOG_FAILED_ID then
				 TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				TRCLOG.CLOSETRCLOG( P_HFILE );
				 raise_application_error( CALLEE_FAILED_ID,
				                         'Erreur : consulter le fichier LOG',
				                          false );
		                else
				 raise;
		                end if;

END global_diva;

-- ======================================================================
--   ALIM_CONSO_HP
-- ======================================================================
PROCEDURE ALIM_CONSO_HP(p_chemin_fichier IN VARCHAR2,
                        p_nom_fichier    IN VARCHAR2) IS


CURSOR curs_consoHP IS
select trim(pid_fact) pid_fact
                   , trim(pnom) pnom
                   , trim(typproj) typproj
                   , trim(arctype) arctype
                   , trim(metier) metier
                   , trim(typetap) typetap
                   , ident_g ident_g
                   , trim(rnom_g) rnom_g
                   , to_char(ANNEE,'YYYY') annee
                   , sum(janvier) janvier
                   , sum(fevrier) fevrier
                   , sum(mars) mars
                   , sum(avril) avril
                   , sum(mai) mai
                   , sum(juin) juin
                   , sum(juillet) juillet
                   , sum(aout) aout
                   , sum(septembre) septembre
                   , sum(octobre) octobre
                   , sum(novembre) novembre
                   , sum(decembre) decembre
from diva_conso_hp
where ident_g !=0
group by pid_fact,pnom,typproj,arctype,metier,typetap,ident_g, rnom_g,ANNEE
order by ident_g, pid_fact, typetap;

L_HFILE						                 UTL_FILE.FILE_TYPE;
L_RETCOD				                           NUMBER;
L_PROCNAME				                   VARCHAR2(35) := 'ALIM CONSO HORS PERIMETRE DIVA';
l_msg  VARCHAR2(1024);

                BEGIN

		-----------------------------------------------------
                    -- Troncature EBIS_CONTRAT_RESSOURCE_LOGS.
		-----------------------------------------------------
                    Packbatch.DYNA_TRUNCATE('DIVA_CONSO_HP');

		-----------------------------------------------------
		-- Alimentation de la table.
		-----------------------------------------------------
		INSERT INTO DIVA_CONSO_HP (PID_ORIG
								  , PID_FACT
								 , PNOM
								 , TYPPROJ
								 , ARCTYPE
								 , METIER
								 , CODSG_RESS
								 , CODSG_LIGN
								  , ECET
								  , ACTA
								  , ACST
								  , CLICODE
								  , CODBR
								  , CODDIR
								  , DIVA_LIGN
								  , DIVA_CLIE
								  , DIVA_RESS
								  , TYPETAP
								  , IDENT
								  , RNOM
								  , RPRENOM
								  , ANNEE
								  , JANVIER
								  , FEVRIER
								   , MARS
								  , AVRIL
								  , MAI
								  , JUIN
								  , JUILLET
								  , AOUT
								  , SEPTEMBRE
								  , OCTOBRE
								  , NOVEMBRE
								  , DECEMBRE
								  , IDENT_G
								  , RNOM_G
								  , RPRENOM_G)
                   (SELECT DISTINCT
								   CONSO.pid																		          AS ligne_depart_BIP
								 , ligne_bip.pid																                     AS code_BIP_IMPUTATION
								 , ligne_bip.pnom																                AS LIBELLE_BIP_IMPUTATION
								 , ligne_bip.TYPPROJ																          AS Type_Proj
								 , ligne_bip.ARCTYPE																         AS Sous_Typo
								 , ligne_bip.metier																              AS metier
								 , CONSO.codsg																                   AS DPG_RESS
								 , ligne_bip.codsg																                AS DPG_PID
								 , CONSO.ecet
								 , conso.acta
								 , conso.acst
								 , ligne_bip.clicode																             AS CLICODE_PID
								 , diress.codbr																                      AS CODBR_DPG_RESS
								 , siress.CODDIR																		    AS CODDIR_DPG_RESS
								 , struct_info.TOP_DIVA																  AS TOP_DIVA_LIGNE_BIP
								 , client_mo.TOP_DIVA														                   AS TOP_DIVA_CLIENT
								 , siress.TOP_DIVA																             AS TOP_DIVA_DPG_RESSOURCE
								 , etape.TYPETAP																		 AS typetap
								 , CONSO.ident																                    AS ident
								 , trim(ressource.rnom)														                  AS nom
								 , trim(ressource.rprenom)														                           AS prenom
								 , datdebex.DATDEBEX
								 , TO_NUMBER(CONSO.janvier)										AS janvier
								 , TO_NUMBER(CONSO.fevrier)										  AS fevrier
								 , TO_NUMBER(CONSO.mars)								                     AS mars
								 , TO_NUMBER(CONSO.avril)								                      AS avril
								 , TO_NUMBER(CONSO.mai)										        AS mai
								 , TO_NUMBER(CONSO.juin)										        AS juin
								 , TO_NUMBER(CONSO.juillet)								                   AS juillet
								 , TO_NUMBER(CONSO.aout)										      AS aout
								 , TO_NUMBER(CONSO.septembre)								        AS septembre
								 , TO_NUMBER(CONSO.octobre)										AS octobre
								 , TO_NUMBER(CONSO.novembre)								         AS novembre
								 , TO_NUMBER(CONSO.decembre)								                          AS decembre
								 , 0
								 , NULL
								 , NULL
		FROM
		(
		SELECT      DECODE(tache.aistty, 'FF', tache.aistpid, tache.pid) factpid
				   , tache.pid
				   , tache.asnom asnom
				   , tache.ecet
				   , tache.acta
				   , tache.acst
				   , tache.aist
				   , SUM(DECODE(TO_NUMBER(TO_CHAR(cons_sstache_res_mois.cdeb, 'MM')), 1, cons_sstache_res_mois.cusag, 0))         janvier
				   , SUM(DECODE(TO_NUMBER(TO_CHAR(cons_sstache_res_mois.cdeb, 'MM')), 2, cons_sstache_res_mois.cusag, 0))         fevrier
				   , SUM(DECODE(TO_NUMBER(TO_CHAR(cons_sstache_res_mois.cdeb, 'MM')), 3, cons_sstache_res_mois.cusag, 0))         mars
				   , SUM(DECODE(TO_NUMBER(TO_CHAR(cons_sstache_res_mois.cdeb, 'MM')), 4, cons_sstache_res_mois.cusag, 0))         avril
				   , SUM(DECODE(TO_NUMBER(TO_CHAR(cons_sstache_res_mois.cdeb, 'MM')), 5, cons_sstache_res_mois.cusag, 0))         mai
				   , SUM(DECODE(TO_NUMBER(TO_CHAR(cons_sstache_res_mois.cdeb, 'MM')), 6, cons_sstache_res_mois.cusag, 0))         juin
				  , SUM(DECODE(TO_NUMBER(TO_CHAR(cons_sstache_res_mois.cdeb, 'MM')), 7, cons_sstache_res_mois.cusag, 0))         juillet
				   , SUM(DECODE(TO_NUMBER(TO_CHAR(cons_sstache_res_mois.cdeb, 'MM')), 8, cons_sstache_res_mois.cusag, 0))         aout
				   , SUM(DECODE(TO_NUMBER(TO_CHAR(cons_sstache_res_mois.cdeb, 'MM')), 9, cons_sstache_res_mois.cusag, 0))         septembre
				   , SUM(DECODE(TO_NUMBER(TO_CHAR(cons_sstache_res_mois.cdeb, 'MM')), 10, cons_sstache_res_mois.cusag, 0))         octobre
				   , SUM(DECODE(TO_NUMBER(TO_CHAR(cons_sstache_res_mois.cdeb, 'MM')), 11, cons_sstache_res_mois.cusag, 0))         novembre
				   , SUM(DECODE(TO_NUMBER(TO_CHAR(cons_sstache_res_mois.cdeb, 'MM')), 12, cons_sstache_res_mois.cusag, 0))         decembre
				   , situ_ress_full.ident
				   , situ_ress_full.codsg
				   , situ_ress_full.soccode
		  , situ_ress_full.niveau
		  , situ_ress_full.cout
                    FROM situ_ress_full
		   , ligne_bip
		   , tache
		   , cons_sstache_res_mois
		   , datdebex
		   -- annee courante
		WHERE cdeb >= datdebex.datdebex
		-- jointure cons_sstache_res_mois / tache
		AND cons_sstache_res_mois.pid=tache.pid
		AND cons_sstache_res_mois.ecet=tache.ecet
		AND cons_sstache_res_mois.acta=tache.acta
		AND cons_sstache_res_mois.acst=tache.acst
		-- suppression de la ressource 0
		AND cons_sstache_res_mois.ident!=0
		-- il existe du consomme
        --QC 828 On envoie même si le consommé est à zéro
		--AND cons_sstache_res_mois.cusag!=0
		-- jointure tache / ligne_bip
		AND DECODE(tache.aistty, 'FF', tache.aistpid, tache.pid)=ligne_bip.pid
		AND ligne_bip.codsg IN  (SELECT codsg
				 FROM vue_dpg_perime
				 WHERE codsg >= 0
				 )
		-- jointure cons_sstache_res_mois / situ_ress_full pour avoir la qualif de la ressource
		AND cons_sstache_res_mois.ident=situ_ress_full.ident
		 AND (cons_sstache_res_mois.cdeb>=situ_ress_full.datsitu OR situ_ress_full.datsitu IS NULL)
		AND (cons_sstache_res_mois.cdeb<=situ_ress_full.datdep OR situ_ress_full.datdep IS NULL)
		AND ( situ_ress_full.prestation not in ('GRA', 'MO', 'IFO', 'INT', 'STA') or situ_ress_full.prestation is null)
                    GROUP BY
		                    tache.pid
				 , DECODE(tache.aistty, 'FF', tache.aistpid, tache.pid)
				 , tache.asnom
				 , tache.ecet
				 , tache.acta
				 , tache.acst
				 , tache.aist
				 , situ_ress_full.ident,situ_ress_full.codsg,situ_ress_full.soccode, situ_ress_full.niveau, situ_ress_full.cout
                union
      SELECT      DECODE(tache.aistty, 'FF', tache.aistpid, tache.pid) factpid
                  , tache.pid
                  , tache.asnom asnom
                  , tache.ecet
                  , tache.acta
                  , tache.acst
                  , tache.aist
                  , SUM(DECODE(TO_NUMBER(TO_CHAR(pmw_consomm.cdeb, 'MM')), 1, pmw_consomm.cusag, 0))    janvier
                  , SUM(DECODE(TO_NUMBER(TO_CHAR(pmw_consomm.cdeb, 'MM')), 2, pmw_consomm.cusag, 0))    fevrier
                  , SUM(DECODE(TO_NUMBER(TO_CHAR(pmw_consomm.cdeb, 'MM')), 3, pmw_consomm.cusag, 0))    mars
                  , SUM(DECODE(TO_NUMBER(TO_CHAR(pmw_consomm.cdeb, 'MM')), 4, pmw_consomm.cusag, 0))    avril
                  , SUM(DECODE(TO_NUMBER(TO_CHAR(pmw_consomm.cdeb, 'MM')), 5, pmw_consomm.cusag, 0))    mai
                  , SUM(DECODE(TO_NUMBER(TO_CHAR(pmw_consomm.cdeb, 'MM')), 6, pmw_consomm.cusag, 0))    juin
                  , SUM(DECODE(TO_NUMBER(TO_CHAR(pmw_consomm.cdeb, 'MM')), 7, pmw_consomm.cusag, 0))    juillet
                  , SUM(DECODE(TO_NUMBER(TO_CHAR(pmw_consomm.cdeb, 'MM')), 8, pmw_consomm.cusag, 0))    aout
                  , SUM(DECODE(TO_NUMBER(TO_CHAR(pmw_consomm.cdeb, 'MM')), 9, pmw_consomm.cusag, 0))    septembre
                  , SUM(DECODE(TO_NUMBER(TO_CHAR(pmw_consomm.cdeb, 'MM')), 10, pmw_consomm.cusag, 0))    octobre
                  , SUM(DECODE(TO_NUMBER(TO_CHAR(pmw_consomm.cdeb, 'MM')), 11, pmw_consomm.cusag, 0))    novembre
                  , SUM(DECODE(TO_NUMBER(TO_CHAR(pmw_consomm.cdeb, 'MM')), 12, pmw_consomm.cusag, 0))    decembre
                  , situ_ress_full.ident
                  , situ_ress_full.codsg
                  , situ_ress_full.soccode
                  , situ_ress_full.niveau
                  , situ_ress_full.cout
        FROM situ_ress_full
           , ligne_bip
           , tache
           , pmw_consomm
           , datdebex
           -- annee courante
        WHERE cdeb >= datdebex.datdebex
        -- jointure pmw_consomm / tache
        AND pmw_consomm.pid=tache.pid
        AND pmw_consomm.ccet=tache.ecet
        AND pmw_consomm.ccta=tache.acta
        AND pmw_consomm.ccst=tache.acst
        -- suppression de la ressource 0
        AND substr(pmw_consomm.cires,0,5)!=0
        -- il existe du consomme
        --QC 828 On envoie même si le consommé est à zéro
        --AND pmw_consomm.cusag!=0
        -- jointure tache / ligne_bip
        AND DECODE(tache.aistty, 'FF', tache.aistpid, tache.pid)=ligne_bip.pid
        AND ligne_bip.codsg IN  (SELECT codsg
                   FROM vue_dpg_perime
                   WHERE codsg >= 0
                   )
        -- jointure pmw_consomm / situ_ress_full pour avoir la qualif de la ressource
        AND substr(pmw_consomm.cires,0,5)=situ_ress_full.ident
        AND (pmw_consomm.cdeb>=situ_ress_full.datsitu OR situ_ress_full.datsitu IS NULL)
        AND (pmw_consomm.cdeb<=situ_ress_full.datdep OR situ_ress_full.datdep IS NULL)
        AND ( situ_ress_full.prestation not in ('GRA', 'MO', 'IFO', 'INT', 'STA') or situ_ress_full.prestation is null)
        and pmw_consomm.pid not in  (select pid from cons_sstache_res_mois_rejet)

GROUP BY
                tache.pid
                , DECODE(tache.aistty, 'FF', tache.aistpid, tache.pid)
                , tache.asnom
                , tache.ecet
                , tache.acta
                , tache.acst
                , tache.aist
                , situ_ress_full.ident,situ_ress_full.codsg,situ_ress_full.soccode, situ_ress_full.niveau, situ_ress_full.cout

		) CONSO
		                , ligne_bip
		                , etape
		                , proj_info
		                , ressource
		                , struct_info
		                , directions
		                , vue_dpg_perime VDP
		                , datdebex
		                , client_mo
		                , struct_info siress
		                , directions  diress
                WHERE
                -- jointure tache <-> etape
		CONSO.ecet = etape.ecet
		AND CONSO.pid = etape.pid
                -- jointure tache <-> ligne_bip avec prise en compte de la sous-traitance
		                AND  ligne_bip.pid =CONSO.factpid
		                AND   ligne_bip.codsg=VDP.codsg
                -- jointure ligne_bip <-> proj_info
		                AND proj_info.icpi=ligne_bip.icpi
                -- jointure ligne_bip <-> struct_info <-> directions
		                AND ligne_bip.codsg=struct_info.codsg
		                AND struct_info.coddir=directions.coddir
                -- jointure ressource/CONSO
		               AND CONSO.ident=ressource.ident
                -- jointures DIVA
		     and ligne_bip.TYPPROJ in (1,2,3,4)
		                and ligne_bip.clicode = client_mo.clicode
		                and conso.codsg = siress.codsg
		                and siress.coddir = diress.coddir
		                and
		                (
				  (conso.pid != ligne_bip.pid and struct_info.TOP_DIVA = 'O' and client_mo.TOP_DIVA = 'O' and siress.TOP_DIVA = 'N')
		                  or (conso.pid != ligne_bip.pid and struct_info.TOP_DIVA = 'O' and client_mo.TOP_DIVA = 'N' and siress.TOP_DIVA = 'N')
		                  or (conso.pid != ligne_bip.pid and struct_info.TOP_DIVA = 'O' and client_mo.TOP_DIVA = 'Y' and siress.TOP_DIVA = 'N')
		                  or (conso.pid != ligne_bip.pid and struct_info.TOP_DIVA = 'X' and client_mo.TOP_DIVA = 'O' and siress.TOP_DIVA = 'N')
		                  or						                           (struct_info.TOP_DIVA = 'N' and client_mo.TOP_DIVA = 'O')
		                )
                );

		                Update DIVA_CONSO_HP set ident_g = 25639 where codbr = 6 and coddir = 22;
		                Update DIVA_CONSO_HP set ident_g = 25640 where codbr = 5 and coddir = 1;
		                Update DIVA_CONSO_HP set ident_g = 25641 where codbr = 6 and coddir = 30;
		                Update DIVA_CONSO_HP set ident_g = 26125 where codbr = 2 and coddir = 94;
		                Update DIVA_CONSO_HP set ident_g = 27408 where codbr = 1 and coddir = 25;
		                --YNI FDT 917 13/01/2010 , Ajout de la ressource 33101 dans l'extraction des consommés hors DIVA.
		                Update DIVA_CONSO_HP set ident_g = 33101 where codbr = 6 and coddir = 31;
            -- QC 1194
            Update DIVA_CONSO_HP set ident_g = 38383 where codbr = 6 and coddir = 32;

		                --------------------------------------------------------------------------------------------
		                --ECH: Supp le 15/12/2008 , ce forfait ne doit plus être utilisé en 2008
		                --		             Update DIVA_CONSO_HP set ident_g = 26635 where codbr = 3 and coddir = 14;
		                ---------------------------------------------------------------------------------------------


		                --UPDATE DIVA_CONSO_HP SET rnom_g = (select r.rnom from ressource r
		                --		                 WHERE DIVA_CONSO_HP.IDENT_G = r.ident);

		                UPDATE DIVA_CONSO_HP SET rnom_g = 'FORFAIT GENERIQUE';

		                COMMIT;

		-----------------------------------------------------
		-- Génération du fichier.
		-----------------------------------------------------
		Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);

                  FOR cur_enr IN curs_consoHP
      LOOP
        Pack_Global.WRITE_STRING( l_hfile,
		cur_enr.pid_fact		             || ';' ||
		cur_enr.pnom		                  || ';' ||
		cur_enr.typproj				|| ';' ||
		cur_enr.arctype		                              || ';' ||
		cur_enr.metier				 || ';' ||
		cur_enr.typetap		                             || ';' ||
		cur_enr.ident_g		                              || ';' ||
		cur_enr.rnom_g		                              || ';' ||
		cur_enr.annee		                 || ';' ||
		TO_CHAR(TO_NUMBER(cur_enr.janvier),'FM999999990D00')                  || ';' ||
		TO_CHAR(TO_NUMBER(cur_enr.fevrier),'FM999999990D00')		   || ';' ||
		TO_CHAR(TO_NUMBER(cur_enr.mars),'FM999999990D00')		                      || ';' ||
		TO_CHAR(TO_NUMBER(cur_enr.avril),'FM999999990D00')		                        || ';' ||
		TO_CHAR(TO_NUMBER(cur_enr.mai),'FM999999990D00')		                         || ';' ||
		TO_CHAR(TO_NUMBER(cur_enr.juin),'FM999999990D00')		         || ';' ||
		TO_CHAR(TO_NUMBER(cur_enr.juillet),'FM999999990D00')		     || ';' ||
		TO_CHAR(TO_NUMBER(cur_enr.aout),'FM999999990D00')		                       || ';' ||
		TO_CHAR(TO_NUMBER(cur_enr.septembre),'FM999999990D00')                         || ';' ||
		TO_CHAR(TO_NUMBER(cur_enr.octobre),'FM999999990D00')				 || ';' ||
		TO_CHAR(TO_NUMBER(cur_enr.novembre),'FM999999990D00')                          || ';' ||
		TO_CHAR(TO_NUMBER(cur_enr.decembre),'FM999999990D00')		           );
      END LOOP;

                Pack_Global.CLOSE_WRITE_FILE(l_hfile);

                EXCEPTION
		WHEN OTHERS THEN
		Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
		RAISE_APPLICATION_ERROR(-20401, l_msg);

END ALIM_CONSO_HP;

-----------------------------------------------------------------------
------------------------------------------------------------------------
--ZAA : PPM 61919 chapitre 6.6
------------------------------------------------------------------------
------------------------------------------------------------------------

PROCEDURE global_diva_dmp(P_LOGDIR          IN VARCHAR2)  IS


L_PROCNAME  varchar2(17) := 'ALIM_DIVA_DMP';
L_STATEMENT varchar2(128);
L_HFILE     utl_file.file_type;
L_RETCOD    number;
L_ANNEE varchar2(4);
L_MOISMENS DATE;
l_exist NUMBER(1);
l_DPCOPI DOSSIER_PROJET_COPI.DP_COPI%type;
l_ICPI PROJ_INFO.ICPI%type;
CURSOR cur_TMP_ReseauxFrance IS SELECT * FROM TMP_ReseauxFrance;
L_DmpNumLong varchar2(12);
l_DmpNum_1 varchar2(12);
tmp_DmpNum TMP_RESEAUXFRANCE.DmpNum%type;
tmp_ProjCode TMP_RESEAUXFRANCE.ProjCode%type;
tmp_DPCOPIcode TMP_RESEAUXFRANCE.DPCOPIcode%type;
BEGIN

    SELECT to_char(moismens,'yyyy') INTO L_ANNEE FROM datdebex;

    SELECT moismens INTO L_MOISMENS FROM datdebex;

                -----------------------------------------------------
                -- Init de la trace
                -----------------------------------------------------
		L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
		if ( L_RETCOD <> 0 ) then
		raise_application_error( TRCLOG_FAILED_ID,
		                        'Erreur : Gestion du fichier LOG impossible',
		                         false );
		end if;

                -----------------------------------------------------
                -- Trace Start
                -----------------------------------------------------

    TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );
-- -------------------------------------------------------------------------------------------------------------------------------------------------
                -- Etape 1 : On alimente la table DMP_RESEAUXFRANCE avec des données de la table TMP_RESEAUXFRANCE(table temporarire chargé par le flux en entrée)
-- -------------------------------------------------------------------------------------------------------------------------------------------------

  MERGE INTO DMP_RESEAUXFRANCE D
   USING tmp_reseauxfrance S
   ON(NVL(D.DmpNum, 'NULL99')=NVL(S.DmpNum, 'NULL99') AND  NVL(D.DPCOPIcode, 'NULL99')=NVL(S.DPCOPIcode, 'NULL99')  AND  NVL(D.ProjCode, 'NULL99')=NVL(S.ProjCode, 'NULL99') )
   WHEN MATCHED THEN UPDATE SET
    D.DMPLIBEL=                   S.DMPLIBEL,
    D.EXNUMDEM=             S.EXNUMDEM,
    D.DDETYPE=                     S.DDETYPE,
    D.DPCODE=                      S.DPCODE,
    D.CODEDPGPOLE=       S.CODEDPGPOLE,
    D.STATDECIS=                 S.STATDECIS,
    D.STATAGR=                    S.STATAGR,
    D.STATEXE=                      S.STATEXE,
    D.ENVBUD=                     S.ENVBUD,
    D.TXFINEXT=                    S.TXFINEXT,
    D.DBS=		S.DBS,
    D.NATDEM=                     S.NATDEM,
    D.AGREGN1=                   S.AGREGN1,
    D.AGREGN2=                   S.AGREGN2,
    D.PORTMOA=                 S.PORTMOA,
    D.ANNEEENCOURS=     S.ANNEEENCOURS,
    D.ACC_LIB_MONT01=                 S.ACC_LIB_MONT01,
    D.ACC_MONT01=          S.ACC_MONT01,
    D.ACC_LIB_MONT02=                 S.ACC_LIB_MONT02,
    D.ACC_MONT02=          S.ACC_MONT02,
    D.ACC_LIB_MONT03=                 S.ACC_LIB_MONT03,
    D.ACC_MONT03=          S.ACC_MONT03,
    D.ACC_LIB_MONT04=                 S.ACC_LIB_MONT04,
    D.ACC_MONT04=          S.ACC_MONT04,
    D.ACC_LIB_MONT05=                 S.ACC_LIB_MONT05,
    D.ACC_MONT05=          S.ACC_MONT05,
    D.ACC_LIB_MONT06=                 S.ACC_LIB_MONT06,
    D.ACC_MONT06=          S.ACC_MONT06,
    D.ACC_LIB_MONT07=                 S.ACC_LIB_MONT07,
    D.ACC_MONT07=          S.ACC_MONT07,
    D.ACC_LIB_MONT08=                 S.ACC_LIB_MONT08,
    D.ACC_MONT08=          S.ACC_MONT08,
    D.ACC_LIB_MONT09=                 S.ACC_LIB_MONT09,
    D.ACC_MONT09=          S.ACC_MONT09,
    D.ACC_LIB_MONT10=                 S.ACC_LIB_MONT10,
    D.ACC_MONT10=          S.ACC_MONT10,
    D.ACC_LIB_MONT11=                 S.ACC_LIB_MONT11,
    D.ACC_MONT11=          S.ACC_MONT11,
    D.ACC_LIB_MONT12=                 S.ACC_LIB_MONT12,
    D.ACC_MONT12=          S.ACC_MONT12,
    D.ACC_LIB_MONT13=                 S.ACC_LIB_MONT13,
    D.ACC_MONT13=          S.ACC_MONT13,
    D.ACC_LIB_MONT14=                 S.ACC_LIB_MONT14,
    D.ACC_MONT14=          S.ACC_MONT14,
    D.ACC_LIB_MONT15=                 S.ACC_LIB_MONT15,
    D.ACC_MONT15=          S.ACC_MONT15,
    D.ACC_LIB_MONT16=                 S.ACC_LIB_MONT16,
    D.ACC_MONT16=          S.ACC_MONT16,
    D.ACC_LIB_MONT17=                 S.ACC_LIB_MONT17,
    D.ACC_MONT17=          S.ACC_MONT17,
    D.ACC_LIB_MONT18=                 S.ACC_LIB_MONT18,
    D.ACC_MONT18=          S.ACC_MONT18,
    D.ACC_LIB_MONT19=                 S.ACC_LIB_MONT19,
    D.ACC_MONT19=          S.ACC_MONT19,
    D.ACC_LIB_MONT20=                 S.ACC_LIB_MONT20,
    D.ACC_MONT20=          S.ACC_MONT20,
    D.ACC_LIB_MONT21=                 S.ACC_LIB_MONT21,
    D.ACC_MONT21=          S.ACC_MONT21,
    D.ACC_LIB_MONT22=                 S.ACC_LIB_MONT22,
    D.ACC_MONT22=          S.ACC_MONT22,
    D.ACC_LIB_MONT23=                 S.ACC_LIB_MONT23,
    D.ACC_MONT23=          S.ACC_MONT23,
    D.ACC_LIB_MONT24=                 S.ACC_LIB_MONT24,
    D.ACC_MONT24=          S.ACC_MONT24,
    D.ACC_LIB_MONT25=                 S.ACC_LIB_MONT25,
    D.ACC_MONT25=          S.ACC_MONT25,
    D.ACC_LIB_MONT26=                 S.ACC_LIB_MONT26,
    D.ACC_MONT26=          S.ACC_MONT26,
    D.ACC_LIB_MONT27=                 S.ACC_LIB_MONT27,
    D.ACC_MONT27=          S.ACC_MONT27,
    D.ACC_LIB_MONT28=                 S.ACC_LIB_MONT28,
    D.ACC_MONT28=          S.ACC_MONT28,
    D.ACC_LIB_MONT29=                 S.ACC_LIB_MONT29,
    D.ACC_MONT29=          S.ACC_MONT29,
    D.ACC_LIB_MONT30=                 S.ACC_LIB_MONT30,
    D.ACC_MONT30=          S.ACC_MONT30,
    D.ACC_LIB_MONT31=                 S.ACC_LIB_MONT31,
    D.ACC_MONT31=          S.ACC_MONT31,
    D.ACC_LIB_MONT32=                 S.ACC_LIB_MONT32,
    D.ACC_MONT32=          S.ACC_MONT32,
    D.ACC_LIB_MONT33=                 S.ACC_LIB_MONT33,
    D.ACC_MONT33=          S.ACC_MONT33,
    D.ACC_LIB_MONT34=                 S.ACC_LIB_MONT34,
    D.ACC_MONT34=          S.ACC_MONT34,
    D.ACC_LIB_MONT35=                 S.ACC_LIB_MONT35,
    D.ACC_MONT35=          S.ACC_MONT35,
    D.ACC_LIB_MONT36=                 S.ACC_LIB_MONT36,
    D.ACC_MONT36=          S.ACC_MONT36,
    D.ACC_LIB_MONT37=                 S.ACC_LIB_MONT37,
    D.ACC_MONT37=          S.ACC_MONT37,
    D.ACC_LIB_MONT38=                 S.ACC_LIB_MONT38,
    D.ACC_MONT38=          S.ACC_MONT38,
    D.ACC_LIB_MONT39=                 S.ACC_LIB_MONT39,
    D.ACC_MONT39=          S.ACC_MONT39,
    D.ACC_LIB_MONT40=                 S.ACC_LIB_MONT40,
    D.ACC_MONT40=          S.ACC_MONT40,
    D.ACC_LIB_MONT41=                 S.ACC_LIB_MONT41,
    D.ACC_MONT41=          S.ACC_MONT41,
    D.ACC_LIB_MONT42=                 S.ACC_LIB_MONT42,
    D.ACC_MONT42=          S.ACC_MONT42,
    D.ACC_LIB_MONT43=                 S.ACC_LIB_MONT43,
    D.ACC_MONT43=          S.ACC_MONT43,
    D.ACC_LIB_MONT44=                 S.ACC_LIB_MONT44,
    D.ACC_MONT44=          S.ACC_MONT44,
    D.ACC_LIB_MONT45=                 S.ACC_LIB_MONT45,
    D.ACC_MONT45=          S.ACC_MONT45,
    D.ACC_LIB_MONT46=                 S.ACC_LIB_MONT46,
    D.ACC_MONT46=          S.ACC_MONT46,
    D.ACC_LIB_MONT47=                 S.ACC_LIB_MONT47,
    D.ACC_MONT47=          S.ACC_MONT47,
    D.ACC_LIB_MONT48=                 S.ACC_LIB_MONT48,
    D.ACC_MONT48=          S.ACC_MONT48,
    D.ACC_LIB_MONT49=                 S.ACC_LIB_MONT49,
    D.ACC_MONT49=          S.ACC_MONT49,
    D.ACC_LIB_MONT50=                 S.ACC_LIB_MONT50,
    D.ACC_MONT50=          S.ACC_MONT50,
    D.ACC_LIB_MONT51=                 S.ACC_LIB_MONT51,
    D.ACC_MONT51=          S.ACC_MONT51,
    D.ACC_LIB_MONT52=                 S.ACC_LIB_MONT52,
    D.ACC_MONT52=          S.ACC_MONT52,
    D.ACC_LIB_MONT53=                 S.ACC_LIB_MONT53,
    D.ACC_MONT53=          S.ACC_MONT53,
    D.ACC_LIB_MONT54=                 S.ACC_LIB_MONT54,
    D.ACC_MONT54=          S.ACC_MONT54,
    D.ACC_LIB_MONT55=                 S.ACC_LIB_MONT55,
    D.ACC_MONT55=          S.ACC_MONT55,
    D.ACC_LIB_MONT56=                 S.ACC_LIB_MONT56,
    D.ACC_MONT56=          S.ACC_MONT56,
    D.ACC_LIB_MONT57=                 S.ACC_LIB_MONT57,
    D.ACC_MONT57=          S.ACC_MONT57,
    D.ACC_LIB_MONT58=                 S.ACC_LIB_MONT58,
    D.ACC_MONT58=          S.ACC_MONT58,
    D.ACC_LIB_MONT59=                 S.ACC_LIB_MONT59,
    D.ACC_MONT59=          S.ACC_MONT59,
    D.ACC_LIB_MONT60=                 S.ACC_LIB_MONT60,
    D.ACC_MONT60=          S.ACC_MONT60,
    D.ACC_LIB_MONT61=                 S.ACC_LIB_MONT61,
    D.ACC_MONT61=          S.ACC_MONT61,
    D.ACC_LIB_MONT62=                 S.ACC_LIB_MONT62,
    D.ACC_MONT62=          S.ACC_MONT62,
    D.ACC_LIB_MONT63=                 S.ACC_LIB_MONT63,
    D.ACC_MONT63=          S.ACC_MONT63,
    D.ACC_LIB_MONT64=                 S.ACC_LIB_MONT64,
    D.ACC_MONT64=          S.ACC_MONT64,
    D.ACC_LIB_MONT65=                 S.ACC_LIB_MONT65,
    D.ACC_MONT65=          S.ACC_MONT65,
    D.ACC_LIB_MONT66=                 S.ACC_LIB_MONT66,
    D.ACC_MONT66=          S.ACC_MONT66,
    D.ACC_LIB_MONT67=                 S.ACC_LIB_MONT67,
    D.ACC_MONT67=          S.ACC_MONT67,
    D.ACC_LIB_MONT68=                 S.ACC_LIB_MONT68,
    D.ACC_MONT68=          S.ACC_MONT68,
    D.ACC_LIB_MONT69=                 S.ACC_LIB_MONT69,
    D.ACC_MONT69=          S.ACC_MONT69,
    D.ACC_LIB_MONT70=                 S.ACC_LIB_MONT70,
    D.ACC_MONT70=          S.ACC_MONT70,
    D.ACC_LIB_MONT71=                 S.ACC_LIB_MONT71,
    D.ACC_MONT71=          S.ACC_MONT71,
    D.ACC_LIB_MONT72=                 S.ACC_LIB_MONT72,
    D.ACC_MONT72=          S.ACC_MONT72,
    D.ACC_LIB_MONT73=                 S.ACC_LIB_MONT73,
    D.ACC_MONT73=          S.ACC_MONT73,
    D.ACC_LIB_MONT74=                 S.ACC_LIB_MONT74,
    D.ACC_MONT74=          S.ACC_MONT74,
    D.ACC_LIB_MONT75=                 S.ACC_LIB_MONT75,
    D.ACC_MONT75=          S.ACC_MONT75,
    D.ACC_LIB_MONT76=                 S.ACC_LIB_MONT76,
    D.ACC_MONT76=          S.ACC_MONT76,
    D.ACC_LIB_MONT77=                 S.ACC_LIB_MONT77,
    D.ACC_MONT77=          S.ACC_MONT77,
    D.ACC_LIB_MONT78=                 S.ACC_LIB_MONT78,
    D.ACC_MONT78=          S.ACC_MONT78,
    D.ACC_LIB_MONT79=                 S.ACC_LIB_MONT79,
    D.ACC_MONT79=          S.ACC_MONT79,
    D.ACC_LIB_MONT80=                 S.ACC_LIB_MONT80,
    D.ACC_MONT80=          S.ACC_MONT80

   WHEN NOT MATCHED THEN INSERT
     (DMPNUM,
    DMPLIBEL,
    EXNUMDEM,
    DDETYPE,
    DPCODE,
    DPCOPICODE,

    PROJCODE,
    CODEDPGPOLE,

    STATDECIS,
    STATAGR,
    STATEXE,
    ENVBUD,
    TXFINEXT,
    DBS,
    NATDEM,
    AGREGN1,
    AGREGN2,
    PORTMOA,
    ANNEEENCOURS,
    ACC_LIB_MONT01,
    ACC_MONT01,
    ACC_LIB_MONT02,
    ACC_MONT02,
    ACC_LIB_MONT03,
    ACC_MONT03,
    ACC_LIB_MONT04,
    ACC_MONT04,
    ACC_LIB_MONT05,
    ACC_MONT05,
    ACC_LIB_MONT06,
    ACC_MONT06,
    ACC_LIB_MONT07,
    ACC_MONT07,
    ACC_LIB_MONT08,
    ACC_MONT08,
    ACC_LIB_MONT09,
    ACC_MONT09,
    ACC_LIB_MONT10,
    ACC_MONT10,
    ACC_LIB_MONT11,
    ACC_MONT11,
    ACC_LIB_MONT12,
    ACC_MONT12,
    ACC_LIB_MONT13,
    ACC_MONT13,
    ACC_LIB_MONT14,
    ACC_MONT14,
    ACC_LIB_MONT15,
    ACC_MONT15,
    ACC_LIB_MONT16,
    ACC_MONT16,
    ACC_LIB_MONT17,
    ACC_MONT17,
    ACC_LIB_MONT18,
    ACC_MONT18,
    ACC_LIB_MONT19,
    ACC_MONT19,
    ACC_LIB_MONT20,
    ACC_MONT20,
    ACC_LIB_MONT21,
    ACC_MONT21,
    ACC_LIB_MONT22,
    ACC_MONT22,
    ACC_LIB_MONT23,
    ACC_MONT23,
    ACC_LIB_MONT24,
    ACC_MONT24,
    ACC_LIB_MONT25,
    ACC_MONT25,
    ACC_LIB_MONT26,
    ACC_MONT26,
    ACC_LIB_MONT27,
    ACC_MONT27,
    ACC_LIB_MONT28,
    ACC_MONT28,
    ACC_LIB_MONT29,
    ACC_MONT29,
    ACC_LIB_MONT30,
    ACC_MONT30,
    ACC_LIB_MONT31,
    ACC_MONT31,
    ACC_LIB_MONT32,
    ACC_MONT32,
    ACC_LIB_MONT33,
    ACC_MONT33,
    ACC_LIB_MONT34,
    ACC_MONT34,
    ACC_LIB_MONT35,
    ACC_MONT35,
    ACC_LIB_MONT36,
    ACC_MONT36,
    ACC_LIB_MONT37,
    ACC_MONT37,
    ACC_LIB_MONT38,
    ACC_MONT38,
    ACC_LIB_MONT39,
    ACC_MONT39,
    ACC_LIB_MONT40,
    ACC_MONT40,
    ACC_LIB_MONT41,
    ACC_MONT41,
    ACC_LIB_MONT42,
    ACC_MONT42,
    ACC_LIB_MONT43,
    ACC_MONT43,
    ACC_LIB_MONT44,
    ACC_MONT44,
    ACC_LIB_MONT45,
    ACC_MONT45,
    ACC_LIB_MONT46,
    ACC_MONT46,
    ACC_LIB_MONT47,
    ACC_MONT47,
    ACC_LIB_MONT48,
    ACC_MONT48,
    ACC_LIB_MONT49,
    ACC_MONT49,
    ACC_LIB_MONT50,
    ACC_MONT50,
    ACC_LIB_MONT51,
    ACC_MONT51,
    ACC_LIB_MONT52,
    ACC_MONT52,
    ACC_LIB_MONT53,
    ACC_MONT53,
    ACC_LIB_MONT54,
    ACC_MONT54,
    ACC_LIB_MONT55,
    ACC_MONT55,
    ACC_LIB_MONT56,
    ACC_MONT56,
    ACC_LIB_MONT57,
    ACC_MONT57,
    ACC_LIB_MONT58,
    ACC_MONT58,
    ACC_LIB_MONT59,
    ACC_MONT59,
    ACC_LIB_MONT60,
    ACC_MONT60,
    ACC_LIB_MONT61,
    ACC_MONT61,
    ACC_LIB_MONT62,
    ACC_MONT62,
    ACC_LIB_MONT63,
    ACC_MONT63,
    ACC_LIB_MONT64,
    ACC_MONT64,
    ACC_LIB_MONT65,
    ACC_MONT65,
    ACC_LIB_MONT66,
    ACC_MONT66,
    ACC_LIB_MONT67,
    ACC_MONT67,
    ACC_LIB_MONT68,
    ACC_MONT68,
    ACC_LIB_MONT69,
    ACC_MONT69,
    ACC_LIB_MONT70,
    ACC_MONT70,
    ACC_LIB_MONT71,
    ACC_MONT71,
    ACC_LIB_MONT72,
    ACC_MONT72,
    ACC_LIB_MONT73,
    ACC_MONT73,
    ACC_LIB_MONT74,
    ACC_MONT74,
    ACC_LIB_MONT75,
    ACC_MONT75,
    ACC_LIB_MONT76,
    ACC_MONT76,
    ACC_LIB_MONT77,
    ACC_MONT77,
    ACC_LIB_MONT78,
    ACC_MONT78,
    ACC_LIB_MONT79,
    ACC_MONT79,
    ACC_LIB_MONT80,
    ACC_MONT80)
    Values


   (S.DMPNUM,
   S.DMPLIBEL,
   S.EXNUMDEM,
   S.DDETYPE,
   S.DPCODE,
   S.DPCOPICODE,
   S.PROJCODE,
   S.CODEDPGPOLE,
   S.STATDECIS,
   S.STATAGR,
   S.STATEXE,
   S.ENVBUD,
   S.TXFINEXT,
   S.DBS,
   S.NATDEM,
   S.AGREGN1,
   S.AGREGN2,
   S.PORTMOA,
   S.ANNEEENCOURS,
   S.ACC_LIB_MONT01,
   S.ACC_MONT01,
   S.ACC_LIB_MONT02,
   S.ACC_MONT02,
   S.ACC_LIB_MONT03,
   S.ACC_MONT03,
   S.ACC_LIB_MONT04,
   S.ACC_MONT04,
   S.ACC_LIB_MONT05,
   S.ACC_MONT05,
   S.ACC_LIB_MONT06,
   S.ACC_MONT06,
   S.ACC_LIB_MONT07,
   S.ACC_MONT07,
   S.ACC_LIB_MONT08,
   S.ACC_MONT08,
   S.ACC_LIB_MONT09,
   S.ACC_MONT09,
   S.ACC_LIB_MONT10,
   S.ACC_MONT10,
   S.ACC_LIB_MONT11,
   S.ACC_MONT11,
   S.ACC_LIB_MONT12,
   S.ACC_MONT12,
   S.ACC_LIB_MONT13,
   S.ACC_MONT13,
   S.ACC_LIB_MONT14,
   S.ACC_MONT14,
   S.ACC_LIB_MONT15,
   S.ACC_MONT15,
   S.ACC_LIB_MONT16,
   S.ACC_MONT16,
   S.ACC_LIB_MONT17,
   S.ACC_MONT17,
   S.ACC_LIB_MONT18,
   S.ACC_MONT18,
   S.ACC_LIB_MONT19,
   S.ACC_MONT19,
   S.ACC_LIB_MONT20,
   S.ACC_MONT20,
   S.ACC_LIB_MONT21,
   S.ACC_MONT21,
   S.ACC_LIB_MONT22,
   S.ACC_MONT22,
   S.ACC_LIB_MONT23,
   S.ACC_MONT23,
   S.ACC_LIB_MONT24,
   S.ACC_MONT24,
   S.ACC_LIB_MONT25,
   S.ACC_MONT25,
   S.ACC_LIB_MONT26,
   S.ACC_MONT26,
   S.ACC_LIB_MONT27,
   S.ACC_MONT27,
   S.ACC_LIB_MONT28,
   S.ACC_MONT28,
   S.ACC_LIB_MONT29,
   S.ACC_MONT29,
   S.ACC_LIB_MONT30,
   S.ACC_MONT30,
   S.ACC_LIB_MONT31,
   S.ACC_MONT31,
   S.ACC_LIB_MONT32,
   S.ACC_MONT32,
   S.ACC_LIB_MONT33,
   S.ACC_MONT33,
   S.ACC_LIB_MONT34,
   S.ACC_MONT34,
   S.ACC_LIB_MONT35,
   S.ACC_MONT35,
   S.ACC_LIB_MONT36,
   S.ACC_MONT36,
   S.ACC_LIB_MONT37,
   S.ACC_MONT37,
   S.ACC_LIB_MONT38,
   S.ACC_MONT38,
   S.ACC_LIB_MONT39,
   S.ACC_MONT39,
   S.ACC_LIB_MONT40,
   S.ACC_MONT40,
   S.ACC_LIB_MONT41,
   S.ACC_MONT41,
   S.ACC_LIB_MONT42,
   S.ACC_MONT42,
   S.ACC_LIB_MONT43,
   S.ACC_MONT43,
   S.ACC_LIB_MONT44,
   S.ACC_MONT44,
   S.ACC_LIB_MONT45,
   S.ACC_MONT45,
   S.ACC_LIB_MONT46,
   S.ACC_MONT46,
   S.ACC_LIB_MONT47,
   S.ACC_MONT47,
   S.ACC_LIB_MONT48,
   S.ACC_MONT48,
   S.ACC_LIB_MONT49,
   S.ACC_MONT49,
   S.ACC_LIB_MONT50,
   S.ACC_MONT50,
   S.ACC_LIB_MONT51,
   S.ACC_MONT51,
   S.ACC_LIB_MONT52,
   S.ACC_MONT52,
   S.ACC_LIB_MONT53,
   S.ACC_MONT53,
   S.ACC_LIB_MONT54,
   S.ACC_MONT54,
   S.ACC_LIB_MONT55,
   S.ACC_MONT55,
   S.ACC_LIB_MONT56,
   S.ACC_MONT56,
   S.ACC_LIB_MONT57,
   S.ACC_MONT57,
   S.ACC_LIB_MONT58,
   S.ACC_MONT58,
   S.ACC_LIB_MONT59,
   S.ACC_MONT59,
   S.ACC_LIB_MONT60,
   S.ACC_MONT60,
   S.ACC_LIB_MONT61,
   S.ACC_MONT61,
   S.ACC_LIB_MONT62,
   S.ACC_MONT62,
   S.ACC_LIB_MONT63,
   S.ACC_MONT63,
   S.ACC_LIB_MONT64,
   S.ACC_MONT64,
   S.ACC_LIB_MONT65,
   S.ACC_MONT65,
   S.ACC_LIB_MONT66,
   S.ACC_MONT66,
   S.ACC_LIB_MONT67,
   S.ACC_MONT67,
   S.ACC_LIB_MONT68,
   S.ACC_MONT68,
   S.ACC_LIB_MONT69,
   S.ACC_MONT69,
   S.ACC_LIB_MONT70,
   S.ACC_MONT70,
   S.ACC_LIB_MONT71,
   S.ACC_MONT71,
   S.ACC_LIB_MONT72,
   S.ACC_MONT72,
   S.ACC_LIB_MONT73,
   S.ACC_MONT73,
   S.ACC_LIB_MONT74,
   S.ACC_MONT74,
   S.ACC_LIB_MONT75,
   S.ACC_MONT75,
   S.ACC_LIB_MONT76,
   S.ACC_MONT76,
   S.ACC_LIB_MONT77,
   S.ACC_MONT77,
   S.ACC_LIB_MONT78,
   S.ACC_MONT78,
   S.ACC_LIB_MONT79,
   S.ACC_MONT79,
   S.ACC_LIB_MONT80,
   S.ACC_MONT80);


  FOR dmp IN cur_TMP_ReseauxFrance
    LOOP
    IF (dmp.DmpNum is not null)THEN
    L_DmpNumLong := trim(dmp.DmpNum);
   --2)     si le trio numéro de demande, dpcopi code et code projet existe alors
   --            nous mettons à jour les attributs Sinon
   --            Nous insérerons le nouvel enregistrement.




  --3)      Nous mettons à jour les liens sur les éléments projets et dpcopi
      IF(dmp.DdeType='P')THEN
        IF(dmp.DPCOPIcode is not null)THEN
        begin
          select DP_COPI INTO l_DPCOPI FROM DOSSIER_PROJET_COPI where DP_COPI= dmp.DPCOPIcode ;
        EXCEPTION

		                WHEN No_Data_Found THEN
                TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        END;
          --Mettre à jour l'Axe métier DPCOPI du DPCOPI en base, s'il existe, correspondant à celui de l'enregistrement, avec DmpNumLong
          IF l_DPCOPI is not NULL THEN
          UPDATE DOSSIER_PROJET_COPI  SET DPCOPIAXEMETIER = L_DmpNumLong where DP_COPI= dmp.DPCOPIcode ;
          END IF;
        END IF;


        IF(dmp.ProjCode is not null)THEN
         begin
          select ICPI INTO l_ICPI FROM PROJ_INFO where ICPI= dmp.ProjCode;
      EXCEPTION
		                WHEN No_Data_Found THEN
                TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        END;
          IF l_ICPI is not NULL THEN
          --Mettre à jour l'Axe métier Projet du Projet en base, s'il existe, correspondant à celui de l'enregistrement, avec DmpNumLong
         UPDATE PROJ_INFO SET PROJAXEMETIER  = L_DmpNumLong where ICPI= dmp.ProjCode;
          END IF;
        END IF;
       END IF;
      IF(dmp.DdeType='E') THEN
      IF (dmp.ProjCode is not null) THEN
      begin
        select ICPI INTO l_ICPI FROM PROJ_INFO where ICPI= dmp.ProjCode;
         EXCEPTION

		                WHEN No_Data_Found THEN
                TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        END;
          IF l_ICPI is not NULL THEN
          --Mettre à jour l'Axe métier Projet du Projet en base, s'il existe, correspondant à celui de l'enregistrement, avec DmpNumLong
          UPDATE PROJ_INFO SET PROJAXEMETIER  = L_DmpNumLong where ICPI= dmp.ProjCode;
          END IF;
          END IF;
      END IF;

    END IF;
    END LOOP;
    --4) nous supprimons tous les enregistrement qui n'existent pas dans le flux d'entrée.


   delete from DMP_RESEAUXFRANCE d
  where not exists (select 1 from TMP_RESEAUXFRANCE s where NVL(D.DmpNum, 'NULL66')= NVL(S.DmpNum , 'NULL66')
                AND  NVL(D.projcode, 'NULL66')= NVL(S.projcode, 'NULL66')
     AND  NVL(D.DPCOPIcode, 'NULL66')= NVL(S.DPCOPIcode , 'NULL66'));

                TRCLOG.TRCLOG( L_HFILE, 'Fin NORMALE de ' || L_PROCNAME);

EXCEPTION
                when others then
                    rollback;
		if sqlcode <> CALLEE_FAILED_ID then
				 TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		end if;
		TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		raise CALLEE_FAILED;

end global_diva_dmp;

--------------------------------------------------------------------------------
-- ZAA PPM 61163 -chapitre 6.12
--------------------------------------------------------------------------------
PROCEDURE liste_dir_bbrf03(p_liste_dir_num OUT PACK_DIVA.array_number) IS

    t_char_table PACK_LIGNE_BIP.t_array;
    p_liste_dir VARCHAR2(200);
     nb integer ;
     i integer:=1;
    Cursor cur_dir_codbr03 is select distinct CODDIR from DIRECTIONS where CODBR=03;

      Cursor lignes_dir_reglages is
        SELECT *
        FROM ligne_param_bip
        WHERE code_action = 'DIR-REGLAGES'
        AND   actif = 'O'
        AND   num_ligne = (SELECT MIN (num_ligne) FROM ligne_param_bip
		 WHERE  code_action = 'DIR-REGLAGES'
		 AND   actif = 'O' );

      BEGIN

         FOR maligne IN lignes_dir_reglages LOOP

             IF is_bbrf03(maligne.valeur) THEN
               IF(maligne.code_version !='DEFAUT') THEN
                   p_liste_dir:=maligne.code_version|| ',' || p_liste_dir  ;
               END IF;
            END IF;

        END LOOP;
      t_char_table := pack_ligne_bip.SPLIT(p_liste_dir,',');
     --transfert directions(code version) de type varchar to number
      for j IN 1..t_char_table.COUNT LOOP

      p_liste_dir_num(i):=TO_NUMBER(t_char_table(j),'99');
      i:=i+1;
      END LOOP;

  nb:=t_char_table.COUNT;

  FOR dir IN cur_dir_codbr03 LOOP
   nb:=nb+1;
    p_liste_dir_num(nb):=dir.CODDIR;

  END LOOP;
END liste_dir_bbrf03;

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
FUNCTION is_bbrf03(p_valeur IN VARCHAR2) RETURN BOOLEAN IS

  l_valeur VARCHAR2(500);
  t_table PACK_LIGNE_BIP.t_array;
  bbrf VARCHAR2(2);
  BEGIN

  t_table := pack_ligne_bip.SPLIT(p_valeur,',');
  bbrf:= t_table(1);

  IF bbrf = '03' THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;

END is_bbrf03;

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

FUNCTION is_dir_code_client(p_clicode IN ligne_bip.clicode%type) return VARCHAR is
l_liste_dir PACK_DIVA.array_number;

l_dir_code_client directions.CODDIR%type;

begin
liste_dir_bbrf03(l_liste_dir);


BEGIN

SELECT d1.CODDIR INTO l_dir_code_client FROM client_mo cli,directions d1 WHERE cli.clicode=p_clicode AND d1.coddir = cli.clidir;
EXCEPTION

WHEN No_Data_Found THEN
RETURN '0';
END;


FOR I IN 1..l_liste_dir.COUNT LOOP
    IF l_dir_code_client = l_liste_dir(I) THEN
      RETURN '1';
    END IF;
  END LOOP;
      RETURN '0';

END is_dir_code_client;

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

FUNCTION is_dir_dpg(p_codsg IN ligne_bip.codsg%type) return VARCHAR is
l_liste_dir PACK_DIVA.array_number;

l_dir_code_dpg STRUCT_INFO.CODDIR%type;

begin
liste_dir_bbrf03(l_liste_dir);


BEGIN

SELECT d2.CODDIR INTO l_dir_code_dpg FROM STRUCT_INFO si,directions d2 WHERE si.CODSG=p_codsg AND  d2.coddir = si.coddir;
EXCEPTION
WHEN No_Data_Found THEN
RETURN '0';
END;


FOR I IN 1..l_liste_dir.COUNT LOOP
    IF l_dir_code_dpg = l_liste_dir(I) THEN
      RETURN '1';
    END IF;
  END LOOP;
      RETURN '0';

END is_dir_dpg;

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--- QC 1836 - PPM 61163 FAD --
PROCEDURE globale
IS

L_MOISMENS DATDEBEX.MOISMENS%type;

L_ANNEE_FONCTIONELLE datdebex.datdebex%type;

BEGIN
                SELECT datdebex INTO L_ANNEE_FONCTIONELLE FROM datdebex;
                SELECT moismens INTO L_MOISMENS FROM datdebex;


                --QC 1796  optimisation
    --QC 1844 - PPM 61163
                INSERT /*+ APPEND */ INTO TMP_AXE_METIER_BUDGET_CONSO
                --FAD PPM 64056 : Modification de la requete d'insertion
                SELECT ligne.PID, axe.axe, ligne.metier,
                si.CODDIR direction, 
                nvl(BUD.BPMONTMO,0) proposeN,

                nvl(BUD1.BPMONTMO,0) proposeN1,

                nvl(BUD2.BPMONTMO,0) proposeN2,

	              nvl(BUD3.BPMONTMO,0) proposeN3,

                nvl(BUD.ANMONT,0) aribtre,

                nvl(BUD.REESTIME,0) restime,

    --QC 1844 - PPM 61163
		DECODE (
		AXE.INDICE,
		'T',
		(SELECT  nvl(SUM(nvl(cusag,0)),0) from isac_consomme conso,isac_tache tache,isac_sous_tache stt
		where
        conso.pid=stt.pid 
		AND conso.ETAPE=stt.ETAPE 
		AND conso.TACHE=stt.TACHE 
		AND conso.SOUS_TACHE=stt.SOUS_TACHE AND
		--and stache.tache=tache.tache
		--and conso.sous_tache=stache.sous_tache
		conso.ETAPE=TACHE.ETAPE
		and conso.TACHE=TACHE.TACHE
                    and  Decode(substr(stt.AIST,1,2),'FF',substr(stt.AIST,3),stt.PID)=ligne.PID
		and  trim(tache.tacheaxemetier)= trim(axe.axe)
		and to_char(cdeb,'MM/YYYY') <= to_char(L_MOISMENS,'MM/YYYY')),
		(SELECT nvl(SUM(nvl(cusag,0)),0) FROM isac_consomme conso,isac_sous_tache stt
		WHERE 
		conso.pid=stt.pid 
		AND conso.ETAPE=stt.ETAPE 
		AND conso.TACHE=stt.TACHE 
		AND conso.SOUS_TACHE=stt.SOUS_TACHE 
		AND Decode(substr(stt.AIST,1,2),'FF',substr(stt.AIST,3),stt.PID)=ligne.PID
		AND to_char(cdeb,'MM/YYYY') <= to_char(L_MOISMENS,'MM/YYYY'))
                ) budctr,
                -- KRA PPM 63403 : debut

                DECODE (
		AXE.INDICE,
		'T',
		DECODE(
		                (SELECT NUMTRAIT from DATDEBEX),
		                3,
		                (SELECT      nvl(SUM(nvl(conso.cusag,0)),0)
		                from cons_sstache_res_mois_back conso,tache tache, DATDEBEX d
		                where tache.ACTA=conso.ACTA
		                and tache.ACST=conso.ACST   --Modification faite par ABA
		                and tache.ECET=conso.ECET
		                and tache.pid=conso.pid
		                and  DECODE(TACHE.AISTTY,'FF', TACHE.AISTPID, TACHE.PID)=ligne.PID
		                and  trim(tache.tacheaxemetier) = trim(axe.axe)
		                --FAD QC 1836 : Modification de la table PROPLUS_BACK par la requête SELECT et suppression de la condition WHERE AND conso.PID=pro.PID
		                AND
		                (
		                (SELECT DISTINCT QUALIF  FROM PROPLUS_BACK, DATDEBEX D WHERE TRUNC(CDEB,'YEAR') = TRUNC(D.DATDEBEX,'YEAR') AND cdeb=conso.CDEB AND  conso.IDENT =TIRES)
		                not in ('MO','GRA','STA','IFO','INT')
		                OR
		                (SELECT DISTINCT QUALIF  FROM PROPLUS_BACK, DATDEBEX D WHERE TRUNC(CDEB,'YEAR') = TRUNC(D.DATDEBEX,'YEAR') AND cdeb=conso.CDEB AND  conso.IDENT =TIRES)
		                is null
		                )
		                AND TRUNC(conso.CDEB,'YEAR') = TRUNC(d.DATDEBEX,'YEAR')
		                ),
		                (SELECT      nvl(SUM(nvl(conso.cusag,0)),0)
		                from cons_sstache_res_mois conso,tache tache, DATDEBEX d
		                where tache.ACTA=conso.ACTA
		                and tache.ACST=conso.ACST   --Modification faite par ABA
		                and tache.ECET=conso.ECET
		                and tache.pid=conso.pid
		                and  DECODE(TACHE.AISTTY,'FF', TACHE.AISTPID, TACHE.PID)=ligne.PID
		                and  trim(tache.tacheaxemetier) = trim(axe.axe)
		                --FAD QC 1836 : Modification de la table PROPLUS_BACK par la requête SELECT et suppression de la condition WHERE AND conso.PID=pro.PID
		                AND
		                (
		                (SELECT DISTINCT QUALIF  FROM PROPLUS, DATDEBEX D WHERE TRUNC(CDEB,'YEAR') = TRUNC(D.DATDEBEX,'YEAR') AND cdeb=conso.CDEB AND  conso.IDENT =TIRES)
		                not in ('MO','GRA','STA','IFO','INT')
		                OR
		                (SELECT DISTINCT QUALIF  FROM PROPLUS, DATDEBEX D WHERE TRUNC(CDEB,'YEAR') = TRUNC(D.DATDEBEX,'YEAR') AND cdeb=conso.CDEB AND  conso.IDENT =TIRES)
		                is null
		                )
		                AND TRUNC(conso.CDEB,'YEAR') = TRUNC(d.DATDEBEX,'YEAR')
		                )
		),
		DECODE(
		                (SELECT NUMTRAIT from DATDEBEX),
		                3,
		                (select      nvl(SUM(nvl(conso_back.cusag,0)),0)
		                from cons_sstache_res_mois_back conso_back, DATDEBEX d, tache
		                where tache.ACTA=conso_back.ACTA
		                and tache.ACST=conso_back.ACST   --Modification faite par ABA
		                and tache.ECET=conso_back.ECET
		                and tache.pid=conso_back.pid
		                and  DECODE(TACHE.AISTTY,'FF', TACHE.AISTPID, TACHE.PID)=ligne.PID
		                /*WHERE (select distinct DECODE(stt.AISTTY,'FF', stt.AISTPID, stt.PID) from tache stt 
		                where conso_back.pid=stt.pid AND conso_back.ECET=stt.ECET AND conso_back.ACTA=stt.ACTA AND conso_back.ACST=stt.ACST)=ligne.PID*/
		                --FAD QC 1836 : Modification de la table PROPLUS_BACK par la requête SELECT et suppression de la condition WHERE AND conso_back.PID=pro_back.PID
		                AND
		                (
		                (SELECT DISTINCT QUALIF  FROM PROPLUS_BACK, DATDEBEX D WHERE TRUNC(CDEB,'YEAR') = TRUNC(D.DATDEBEX,'YEAR') AND cdeb=conso_back.CDEB AND  conso_back.IDENT =TIRES)
		                not in ('MO','GRA','STA','IFO','INT')
		                OR
		                (SELECT DISTINCT QUALIF  FROM PROPLUS_BACK, DATDEBEX D WHERE TRUNC(CDEB,'YEAR') = TRUNC(D.DATDEBEX,'YEAR') AND cdeb=conso_back.CDEB AND  conso_back.IDENT =TIRES)
		                is null
		                )
		                AND TRUNC(conso_back.CDEB,'YEAR') = TRUNC(d.DATDEBEX,'YEAR')),
		                
		                (select      nvl(SUM(nvl(conso.cusag,0)),0)
		                from CONS_SSTACHE_RES_MOIS conso, DATDEBEX d, tache
		                where tache.ACTA=conso.ACTA
		                and tache.ACST=conso.ACST   --Modification faite par ABA
		                and tache.ECET=conso.ECET
		                and tache.pid=conso.pid
		                and  DECODE(TACHE.AISTTY,'FF', TACHE.AISTPID, TACHE.PID)=ligne.PID
		                /*WHERE (select distinct DECODE(stt.AISTTY,'FF', stt.AISTPID, stt.PID) from tache stt 
		                where conso.pid=stt.pid AND conso.ECET=stt.ECET AND conso.ACTA=stt.ACTA AND conso.ACST=stt.ACST)=ligne.PID*/
		                --FAD QC 1836 : Modification de la table PROPLUS_BACK par la requête SELECT et suppression de la condition WHERE AND conso_back.PID=pro_back.PID
		                AND
		                (
		                (SELECT DISTINCT QUALIF  FROM PROPLUS_BACK, DATDEBEX D WHERE TRUNC(CDEB,'YEAR') = TRUNC(D.DATDEBEX,'YEAR') AND cdeb=conso.CDEB AND  conso.IDENT =TIRES)
		                not in ('MO','GRA','STA','IFO','INT')
		                OR
		                (SELECT DISTINCT QUALIF  FROM PROPLUS_BACK, DATDEBEX D WHERE TRUNC(CDEB,'YEAR') = TRUNC(D.DATDEBEX,'YEAR') AND cdeb=conso.CDEB AND  conso.IDENT =TIRES)
		                is null
		                )
		                AND TRUNC(conso.CDEB,'YEAR') = TRUNC(d.DATDEBEX,'YEAR'))
		)
                )budcmi,
                -- KRA PPM 63403 : fin

                DECODE (
		AXE.INDICE,
		'T',
		(SELECT  nvl(SUM(nvl(CONSOJH,0)),0)
		from STOCK_RA conso, tache tache
		where tache.ACTA=conso.ACTA
		and tache.ACST=conso.ACST   --Modification faite par ABA
		and tache.ECET=conso.ECET
		and tache.pid=conso.pid
		and DECODE(tache.AISTTY,'FF', tache.AISTPID, tache.PID)=conso.FACTPID
		and  conso.FACTPID=ligne.PID
		and  trim(tache.tacheaxemetier)= trim(axe.axe)),
		(select nvl(SUM(nvl(CONSOJH,0)),0) FROM STOCK_RA  WHERE FACTPID=ligne.PID)
                )budcfm,

                DECODE (
		AXE.INDICE,
		'T',
		(SELECT nvl(SUM(nvl(CONSOFT,0)),0)+nvl(SUM(nvl(CONSOENV,0)),0)
		from STOCK_RA conso, tache tache
		where tache.ACTA=conso.ACTA
		and tache.ACST=conso.ACST   --Modification faite par ABA
		and tache.ECET=conso.ECET
		and tache.pid=conso.pid
		and DECODE(tache.AISTTY,'FF', tache.AISTPID, tache.PID)=conso.FACTPID
		and  conso.FACTPID=ligne.PID
		and  trim(tache.tacheaxemetier)= trim(axe.axe)),
		(select  nvl(SUM(nvl(CONSOFT,0)),0)+nvl(SUM(nvl(CONSOENV,0)),0) FROM  STOCK_RA  WHERE FACTPID=ligne.PID)
                ) budeur

                FROM LIGNE_BIP ligne
		--FAD 64056
    JOIN
		(SELECT DISTINCT LB.PID id,
		                DECODE(DPC.dpcopiaxemetier, NULL, DECODE(PI1.PROJAXEMETIER, NULL, IT.tacheaxemetier, PI1.PROJAXEMETIER), DPC.dpcopiaxemetier) AXE,
		                DECODE(DPC.dpcopiaxemetier, NULL, DECODE(PI1.PROJAXEMETIER, NULL, 'T', 'R'), 'D') INDICE
		FROM LIGNE_BIP LB
		LEFT JOIN ( SELECT  Decode(substr(stt.AIST,1,2),'FF',substr(stt.AIST,3),stt.PID) FACTPID,tache.TACHEAXEMETIER
              from isac_tache tache,isac_sous_tache stt
		      where tache.pid=stt.pid 
		      AND tache.ETAPE=stt.ETAPE 
		      AND tache.TACHE=stt.TACHE ) IT ON LB.PID = IT.FACTPID -- Modif SZ : restitution des couples lignes imputation/tacheaxemetier au lieu de lignes saisies/tacheaxemetier
		LEFT JOIN PROJ_INFO PI1 ON LB.ICPI=PI1.ICPI
		LEFT JOIN PROJ_INFO PI2 ON LB.ICPI=PI2.ICPI
		LEFT JOIN DOSSIER_PROJET_COPI DPC ON PI2.DP_COPI = DPC.DP_COPI
		WHERE (DPC.dpcopiaxemetier IS NOT NULL OR PI1.PROJAXEMETIER IS NOT NULL OR IT.tacheaxemetier IS NOT NULL)) AXE ON  ligne.pid = axe.id
               
    LEFT JOIN STRUCT_INFO si ON si.CODSG=ligne.CODSG
    LEFT JOIN BUDGET BUD ON BUD.PID=ligne.PID AND BUD.ANNEE=to_number(to_char(L_ANNEE_FONCTIONELLE,'YYYY'))
    LEFT JOIN BUDGET BUD1 ON BUD1.PID=ligne.PID AND BUD1.ANNEE=to_number(to_char(L_ANNEE_FONCTIONELLE,'YYYY'))+1
    LEFT JOIN BUDGET BUD2 ON BUD2.PID=ligne.PID AND BUD2.ANNEE=to_number(to_char(L_ANNEE_FONCTIONELLE,'YYYY'))+2
    LEFT JOIN BUDGET BUD3 ON BUD3.PID=ligne.PID AND BUD3.ANNEE=to_number(to_char(L_ANNEE_FONCTIONELLE,'YYYY'))+3
    
    WHERE -- (PACK_DIVA.is_dir_code_client(ligne.clicode)='1' OR PACK_DIVA.is_dir_dpg(ligne.codsg)='1')                 
                   (ligne.adatestatut IS NULL
		OR to_date(ligne.adatestatut) >= to_date('01/01/'|| TO_CHAR(L_ANNEE_FONCTIONELLE,'YYYY'), 'DD/MM/YYYY'))
  AND (PACK_DIVA.is_BBRF_03_client_DPG(ligne.clicode,ligne.codsg)='1')
  ;

COMMIT;

END globale;

-- ======================================================================
--   SELECT_EXPORT_DMP
-- ======================================================================
-- QC 1796 après optimisation
PROCEDURE SELECT_EXPORT_DMP(p_chemin_fichier IN VARCHAR2,
                        p_nom_fichier    IN VARCHAR2) IS

L_HFILE		 UTL_FILE.FILE_TYPE;
L_HFILE_LOGS                  UTL_FILE.FILE_TYPE;
L_RETCOD				                           NUMBER;
f_log     VARCHAR2(50);
l_msg  VARCHAR2(1024);
maintenant VARCHAR2(50);

BEGIN

                L_RETCOD := TRCLOG.INITTRCLOG( 'PL_LOGS' , 'SELECT_EXPORT_DMP', L_HFILE_LOGS );

    if ( L_RETCOD <> 0 ) then
        raise_application_error( TRCLOG_FAILED_ID,
		  'Erreur : Gestion du fichier LOG impossible',
		  false );
    end if;
                
                TRCLOG.TRCLOG( L_HFILE_LOGS, 'Début SELECT_EXPORT_DMP');
                TRCLOG.TRCLOG( L_HFILE_LOGS, 'Début Purge de la table TMP_AXE_METIER_BUDGET_CONSO');
      PACKBATCH.DYNA_TRUNCATE('TMP_AXE_METIER_BUDGET_CONSO');
                TRCLOG.TRCLOG( L_HFILE_LOGS, 'Fin Purge de la table TMP_AXE_METIER_BUDGET_CONSO');
		-----------------------------------------------------
		-- Génération du fichier.
		-----------------------------------------------------
                
                TRCLOG.TRCLOG( L_HFILE_LOGS, 'Création entête fichier de sortie');
		Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);
    Pack_Global.WRITE_STRING( l_hfile,
		'NUMDEM;METIER;DIRFRN;BUDPR0;BUDPR1;BUDPR2;BUDPR3;BUDARB;BUDRES;BUDCTR;BUDCMI;BUDCFM;BUDEUR');

                TRCLOG.TRCLOG( L_HFILE_LOGS, 'Fin Création entête fichier de sortie');
                

    begin
                TRCLOG.TRCLOG( L_HFILE_LOGS, 'Début procédure GLOBAL');
    globale;

                TRCLOG.TRCLOG( L_HFILE_LOGS, 'Fin procédure GLOBAL');
  -- PPM 61163 QC 1799 order by axe metier
  -- QC 1796  optimisation

  TRCLOG.TRCLOG( L_HFILE_LOGS, 'Début écriture du résultat dans le fichier de sortie');
       for cur in (SELECT
        trim(budgaxe.axe_metier) AXEMET,
        trim(budgaxe.metier) MET,
        budgaxe.DIRFRN DIRECTION,

        BUDPR0 TOT_BUDPR0,
        BUDPR1 TOT_BUDPR1,
        BUDPR2 TOT_BUDPR2,
        BUDPR3 TOT_BUDPR3,
        BUDARB TOT_BUDARB,
        BUDRES TOT_BUDRES,
        BUDCTR TOT_BUDCTR,
        BUDCMI TOT_BUDCMI,
        BUDCFM TOT_BUDCFM,
        BUDEUR TOT_BUDEUR

        FROM  (
        select AXE_METIER, METIER, DIRFRN,

        SUM(nvl(BUDPR0,0)) BUDPR0, SUM(nvl(BUDPR1,0)) BUDPR1, SUM(nvl(BUDPR2,0)) BUDPR2, SUM(nvl(BUDPR3,0)) BUDPR3, SUM(nvl(BUDARB,0)) BUDARB,
        SUM(nvl(BUDRES,0)) BUDRES, SUM(nvl(BUDCTR,0)) BUDCTR, SUM(nvl(BUDCMI,0)) BUDCMI, SUM(nvl(BUDCFM,0)) BUDCFM, SUM(nvl(BUDEUR,0)) BUDEUR
        from TMP_AXE_METIER_BUDGET_CONSO
        group by AXE_METIER, METIER, DIRFRN) budgaxe
        ORDER BY AXEMET,MET,DIRECTION)
        loop

        Pack_Global.WRITE_STRING( l_hfile,
            cur.AXEMET || ';' ||
            cur.MET		|| ';' ||
            cur.DIRECTION	    || ';' ||
            cur.TOT_BUDPR0				|| ';' ||
            cur.TOT_BUDPR1				|| ';' ||
            cur.TOT_BUDPR2				|| ';' ||
            cur.TOT_BUDPR3		    || ';' ||
            cur.TOT_BUDARB        || ';' ||
            cur.TOT_BUDRES	      || ';' ||
            cur.TOT_BUDCTR				|| ';' ||
            cur.TOT_BUDCMI				|| ';' ||
            cur.TOT_BUDCFM				|| ';' ||
           cur.TOT_BUDEUR
        );
        end loop;

                TRCLOG.TRCLOG( L_HFILE_LOGS, 'Fin écriture du résultat dans le fichier de sortie');
    end;




                TRCLOG.TRCLOG( L_HFILE_LOGS, 'Fin SELECT_EXPORT_DMP');
                TRCLOG.CLOSETRCLOG( L_HFILE_LOGS );
                Pack_Global.CLOSE_WRITE_FILE(l_hfile);
                

EXCEPTION
     WHEN OTHERS THEN
        Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
        RAISE_APPLICATION_ERROR(-20401, l_msg);

END SELECT_EXPORT_DMP;


FUNCTION is_BBRF_03_client_DPG(CLICODELIG IN LIGNE_BIP.clicode%type,CODSGLIG   IN STRUCT_INFO.CODSG%type) return VARCHAR IS 

l_code_action LIGNE_PARAM_BIP.CODE_ACTION%TYPE;
    l_obligatoire LIGNE_PARAM_BIP.OBLIGATOIRE%TYPE;
    l_direction CLIENT_MO.CLIDIR%TYPE;
    l_valeur VARCHAR2(20);
    l_bbrf_clicode VARCHAR2(3);
    l_bbrf_dpg VARCHAR2(3);
    l_nbre_param_local number(3);

BEGIN

    select CMO.clidir into l_direction from client_mo CMO where CLICODELIG= CMO.clicode;

      select substr(valeur,1,2) into l_valeur
          from ligne_param_bip
          where code_action = 'DIR-REGLAGES'
          and code_version = l_direction
          and actif = 'O';
          if l_valeur='03' then return '1'; else return '0'; end if;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
        BEGIN
          select SI.coddir into l_direction from struct_info SI where CODSGLIG = SI.codsg;

          select  substr(valeur,1,2) into l_valeur
          from ligne_param_bip
          where code_action = 'DIR-REGLAGES'
          and code_version = l_direction
          and actif = 'O';
          if l_valeur='03' then return '1'; else return '0'; end if;
        EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
            BEGIN
              select substr(bdclicode,1,2) into l_bbrf_clicode from vue_clicode_perimo where clicode = CLICODELIG and codhabili = 'br';
          if l_bbrf_clicode='03' then return '1'; else return '0'; end if;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
               
                BEGIN
              select substr(CODBDDPG,1,2) into l_bbrf_dpg From vue_dpg_perime WHERE codsg =CODSGLIG and codhabili = 'br';
          if l_bbrf_dpg='03' then return '1'; else return '0'; end if;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                RETURN '0';
            END;
               
            END;

           
          END;

END is_BBRF_03_client_DPG;

END pack_diva;
/
