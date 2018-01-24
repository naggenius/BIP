-- pack_ligne_fact  PL/SQL
--
-- equipe SOPRA - QHL
--
-- POUR LA "MISE A JOUR DES LIGNES DE FACTURE"
--
--    Procedure : select_ligne_fact 
--                select_ident_ress
--                update_facture_majlig 
--                insert_ligne_fact   (insert ou insert+rapprochement)
--                update_ligne_fact   (update ou update+rapprochement)
--                delete_ligne_fact
--
--		Appel à pack_liste_lignes_fact.xcle_ligne_fact
-- Quand    Qui  Procedure impactée + Quoi
-- -------- ---  ----------------------------------------------------------------------------------------
-- 18/01/2000 QHL  * select_ident_ress : ajout controle existence de Identifiant ressource appartenant à société
--                 * update_facture_majlig : Si fact. sans contrat Alors Update Facture et ecran suivant
--                   Si fact avec contrat Alors MontantTotalHT doit être égale à Somme(MontantHT ligne_fact)
-- 09/02/2000 QHL  * le test de rapprochement doit se faire via la table proplus et pas la table cons_sstache_res_mois 
--                   msg modifiés 2207,2208  et  msg supprimés 2209,2210,2211
-- 19/04/2000 QHL  * ajout verif_periode_contrat pour controler le mois de prestation
--                 * alimenter automatiquement FREGCOMPTA et FACCSEC avec la date du jour si Facture Validée
-- 18/05/2000 QHL  * insert_ligne_fact : on prend la TVA de la facture et non de la table TVA. (prod lot2- 11)
--                 * verif_mois_prestation : on ne s'interesse uniquement au mois debut et fin du contrat (prod lot2- 3)
-- 07/07/00   NCM  * Factures sans contrat à prendre en compte : insert_ligne_fact, select_ident_ress 
-- 01/02/2001 PHD  * Ajout des nouvelles ss-taches RTT, PARTIE
-- 12/03/2001 NCM  * Message quand rapprochement déjà effectué: ajout de lrapprocht dans la table ligne_fact
-- 17/12/2001 NBM  * Procédure verif_rapprochement : message 20366 complété
-- 27/03/2006 JMA  * Procédure verif_rapprochement : ajout retour d'un mail
-- 04/07/2006 PPR  * Supprime tables histo
-- 06/09/2006 PPR  * Correction Factures Rapprochement
-- 10/01/2007 ASI  * Ajout des critères de centre d'activité
-- 23/02/2009 ABA  * TD 750
-- 17/04/2009  EVI * TD737 augmentation de la taille du numero de contrat + avenant 27+3
-- 29/06/2009 YSB  * TD 826
-- 21/09/2009  ABA * TD 826
--  Suppression des verrous SMS 23/03/20011 par BSA : Fiche 837
--
-- *******************************************************************************************************

CREATE OR REPLACE PACKAGE     Pack_Ligne_Fact AS

 TYPE FactSelectRec IS RECORD (soclib       SOCIETE.soclib%TYPE,
                               socfact      FACTURE.socfact%TYPE,
                               numfact      FACTURE.numfact%TYPE,
                               typfact      FACTURE.typfact%TYPE,
                               datfact      VARCHAR2(20),
                               fmoiacompta  VARCHAR2(20),
                               fmontht      VARCHAR2(20),
                               fstatut1     FACTURE.fstatut1%TYPE,
                               flaglock     VARCHAR2(20),
                               soccont      FACTURE.soccont%TYPE,
                               cav          FACTURE.cav%TYPE,
                               numcont      FACTURE.numcont%TYPE,
                               fenrcompta   VARCHAR2(20),
                               faccsec      VARCHAR2(20),
                               fregcompta   VARCHAR2(20),
                               fenvsec      VARCHAR2(20),      -- date reglement demande
                               fcodcompta   VARCHAR2(20),
                               fdeppole     VARCHAR2(20),
                               ftva         VARCHAR2(20),
                               comcode      VARCHAR2(20),       -- table contrat pour Modifier
                               codsg        VARCHAR2(7)        -- table contrat
                              );

   TYPE VideRec IS RECORD     (filcode      FILIALE_CLI.filcode%TYPE);

   TYPE LigfSelect IS RECORD  (socfact      FACTURE.socfact%TYPE,
                               soclib       SOCIETE.soclib%TYPE,
                               numcont      FACTURE.numcont%TYPE,
                               cav          FACTURE.cav%TYPE,
                               numfact      FACTURE.numfact%TYPE,
                               typfact      FACTURE.typfact%TYPE,
                               datfact      VARCHAR2(20),
                               lnum         VARCHAR2(10),
                               ident        VARCHAR2(10),
                               rnom         RESSOURCE.rnom%TYPE,
                               rprenom      RESSOURCE.rprenom%TYPE,
                               lmontht      VARCHAR2(10),
                               lmoisprest   VARCHAR2(10),
                               lcodcompta   VARCHAR2(20),
							   typdpg CHAR(1)

                              );

   TYPE SelectCurVide IS REF CURSOR RETURN VideRec;
   TYPE FactSelectCur IS REF CURSOR RETURN FactSelectRec;
   TYPE LigfSelectCur IS REF CURSOR RETURN LigfSelect;

   PROCEDURE maj_flaglock_fact (l_socfact        IN FACTURE.socfact%TYPE,
                                l_numfact        IN FACTURE.numfact%TYPE,
                                l_typfact        IN FACTURE.typfact%TYPE,
                                l_datfact        IN VARCHAR2,
                                l_flaglock       IN VARCHAR2,
                                l_flaglockout       OUT VARCHAR2
                                );

   PROCEDURE verif_codecompta  (c_codcompta      IN VARCHAR2       -- code comptable
                               );

 PROCEDURE verif_rapprochement (l_socfact       IN FACTURE.socfact%TYPE,
                                l_ident         IN VARCHAR2,
                                l_lmontht       IN VARCHAR2,
                                l_lmoisprest    IN VARCHAR2,
                                l_userid        IN VARCHAR2,
                                l_message          OUT VARCHAR2,
                                p_mail             OUT VARCHAR2
                               );

   PROCEDURE verif_periode_contrat (v_socfact    IN FACTURE.socfact%TYPE,
                                    v_numcont    IN FACTURE.numcont%TYPE,
                                    v_cav        IN FACTURE.cav%TYPE,
                                    v_lmoisprest IN VARCHAR2         -- mois prestation DD/YYYY
                               );

-- *********** OK
   PROCEDURE insert_ligne_fact(p_mode         IN VARCHAR2,
                               p_socfact        IN FACTURE.socfact%TYPE,
                               p_soclib         IN SOCIETE.soclib%TYPE,
                               p_numcont        IN FACTURE.numcont%TYPE,
                               p_cav            IN FACTURE.cav%TYPE,
                               p_numfact        IN FACTURE.numfact%TYPE,
                               p_typfact        IN FACTURE.typfact%TYPE,
                               p_datfact        IN VARCHAR2,
                               p_ident          IN VARCHAR2,
                               p_rnom           IN RESSOURCE.rnom%TYPE,
                               p_rprenom        IN RESSOURCE.rprenom%TYPE,
                               p_lmontht        IN VARCHAR2,
                               p_lmoisprest     IN VARCHAR2,
                               p_lcodcompta     IN VARCHAR2,
                               p_lnum           IN VARCHAR2,
                               p_fmontht        IN VARCHAR2,
                               p_ftva           IN VARCHAR2,
                               p_flaglock       IN VARCHAR2,
                               p_userid         IN VARCHAR2,
   							   p_typdpg         IN VARCHAR2,
                               p_fmonthtout        OUT VARCHAR2,
                               p_ftvaout           OUT VARCHAR2,
                               p_flaglockout       OUT VARCHAR2,
                               p_nbcurseur         OUT INTEGER,
                               p_message           OUT VARCHAR2
                              );

-- ************ OK
   PROCEDURE update_ligne_fact(p_mode         IN VARCHAR2,
                               p_socfact        IN FACTURE.socfact%TYPE,
                               p_soclib         IN SOCIETE.soclib%TYPE,
                               p_numcont        IN FACTURE.numcont%TYPE,
                               p_cav            IN FACTURE.cav%TYPE,
                               p_numfact        IN FACTURE.numfact%TYPE,
                               p_typfact        IN FACTURE.typfact%TYPE,
                               p_datfact        IN VARCHAR2,
                               p_ident          IN VARCHAR2,
                               p_rnom           IN RESSOURCE.rnom%TYPE,
                               p_rprenom        IN RESSOURCE.rprenom%TYPE,
                               p_lmontht        IN VARCHAR2,
                               p_lmoisprest     IN VARCHAR2,
                               p_lcodcompta     IN VARCHAR2,
                               p_lnum           IN VARCHAR2,
                               p_fmontht        IN VARCHAR2,
                               p_ftva           IN VARCHAR2,
                               p_flaglock       IN VARCHAR2,
                               p_userid         IN VARCHAR2,
							   p_typdpg         IN VARCHAR2,
                               p_fmonthtout        OUT VARCHAR2,
                               p_ftvaout           OUT VARCHAR2,
	   		       			   p_flaglockout       OUT VARCHAR2,
                               p_mail              OUT VARCHAR2,
                               p_nbcurseur         OUT INTEGER,
                               p_message           OUT VARCHAR2
                              );

-- **************** OK
  PROCEDURE delete_ligne_fact (p_socfact        IN FACTURE.socfact%TYPE,
                               p_soclib         IN SOCIETE.soclib%TYPE,
                               p_numcont        IN FACTURE.numcont%TYPE,
                               p_cav            IN FACTURE.cav%TYPE,
                               p_numfact        IN FACTURE.numfact%TYPE,
                               p_typfact        IN FACTURE.typfact%TYPE,
                               p_datfact        IN VARCHAR2,
                               p_ident          IN VARCHAR2,
                               p_rnom           IN RESSOURCE.rnom%TYPE,
                               p_rprenom        IN RESSOURCE.rprenom%TYPE,
                               p_lmontht        IN VARCHAR2,
                               p_lmoisprest     IN VARCHAR2,
                               p_lcodcompta     IN LIGNE_FACT.lcodcompta%TYPE,
                               p_lnum           IN VARCHAR2,
                               p_fmontht        IN VARCHAR2,
                               p_ftva           IN VARCHAR2,
                               p_flaglock       IN VARCHAR2,
                               p_userid         IN VARCHAR2,
                               p_fmonthtout        OUT VARCHAR2,
                               p_ftvaout           OUT VARCHAR2,
                               p_flaglockout       OUT VARCHAR2,
                               p_nbcurseur         OUT INTEGER,
                               p_message           OUT VARCHAR2
                              );
-- **************** OK
  PROCEDURE update_facture_majlig (p_mode        IN VARCHAR2,
                               	   p_socfact       IN FACTURE.socfact%TYPE,
                            	   p_soclib        IN SOCIETE.soclib%TYPE,
                            	   p_numcont       IN FACTURE.numcont%TYPE,
                            	   p_cav           IN FACTURE.cav%TYPE,
                            	   p_numfact       IN FACTURE.numfact%TYPE,
                            	   p_typfact       IN FACTURE.typfact%TYPE,
                            	   p_datfact       IN VARCHAR2,
                            	   p_fmontht       IN VARCHAR2,
                            	   p_ftva          IN VARCHAR2,
                            	   p_clelf         IN VARCHAR2,
                            	   p_flaglock      IN VARCHAR2,
                            	   p_userid        IN VARCHAR2,
                            	   p_flaglockout      OUT VARCHAR2,
                            	   p_soclibout        OUT VARCHAR2,
                            	   p_socfactout       OUT VARCHAR2,
                            	   p_numfactout       OUT VARCHAR2,
                            	   p_typfactout       OUT VARCHAR2,
                            	   p_datfactout       OUT VARCHAR2,
                            	   p_nbcurseur        OUT INTEGER,
                            	   p_message          OUT VARCHAR2
                              );

-- **************** OK
  PROCEDURE select_ligne_fact (p_mode      IN VARCHAR2,
                               p_socfact     IN FACTURE.socfact%TYPE,
                               p_soclib      IN SOCIETE.soclib%TYPE,
                               p_numcont     IN FACTURE.numcont%TYPE,
                               p_cav         IN FACTURE.cav%TYPE,
                               p_numfact     IN FACTURE.numfact%TYPE,
                               p_typfact     IN FACTURE.typfact%TYPE,
                               p_datfact     IN VARCHAR2,
                               p_fmontht     IN VARCHAR2,
                               p_ftva        IN VARCHAR2,
                               p_clelf       IN VARCHAR2,
                               p_flaglock    IN VARCHAR2,
                               p_userid      IN VARCHAR2,
                               p_curselect   IN OUT LigfSelectCur,
                               p_fmonthtout     OUT VARCHAR2,
                               p_ftvaout        OUT VARCHAR2,
                               p_flaglockout    OUT VARCHAR2,
                               p_nbcurseur      OUT INTEGER,
                               p_message        OUT VARCHAR2
                              );
-- **************** OK
  PROCEDURE select_ident_ress (p_socfact     IN FACTURE.socfact%TYPE,
                               p_soclib      IN SOCIETE.soclib%TYPE,
                               p_numcont     IN FACTURE.numcont%TYPE,
                               p_cav         IN FACTURE.cav%TYPE,
                               p_numfact     IN FACTURE.numfact%TYPE,
                               p_typfact     IN FACTURE.typfact%TYPE,
                               p_datfact     IN VARCHAR2,
                               p_listeress   IN VARCHAR2,
                               p_ident       IN VARCHAR2,
                               p_fmontht     IN VARCHAR2,
                               p_ftva        IN VARCHAR2,
                               p_flaglock    IN VARCHAR2,
                               p_userid      IN VARCHAR2,
							   p_typdpg        IN VARCHAR2,
                               p_socfactout     OUT VARCHAR2,
                               p_soclibout      OUT VARCHAR2,
                               p_numcontout     OUT VARCHAR2,
                               p_cavout         OUT VARCHAR2,
                               p_numfactout     OUT VARCHAR2,
                               p_typfactout     OUT VARCHAR2,
                               p_datfactout     OUT VARCHAR2,
                               p_identout       OUT VARCHAR2,
                               p_rnomout        OUT VARCHAR2,
                               p_rprenomout     OUT VARCHAR2,
                               p_fmonthtout     OUT VARCHAR2,
                               p_ftvaout        OUT VARCHAR2,
							   p_typdpgout        OUT VARCHAR2,
                               p_flaglockout    OUT VARCHAR2,
                               p_nbcurseur      OUT INTEGER,
                               p_message        OUT VARCHAR2
                              ) ;

END Pack_Ligne_Fact;
/


CREATE OR REPLACE PACKAGE BODY     Pack_Ligne_Fact AS
-- **************************************************************************************
-- **************************************************************************************
--
-- Controle et Mise à jour du Flaglock Facture
--
-- ***********************************************
   PROCEDURE maj_flaglock_fact (l_socfact        IN FACTURE.socfact%TYPE,
                                l_numfact        IN FACTURE.numfact%TYPE,
                                l_typfact        IN FACTURE.typfact%TYPE,
                                l_datfact        IN VARCHAR2,
                                l_flaglock       IN VARCHAR2,
                                l_flaglockout       OUT VARCHAR2
                                ) IS

      l_msg        VARCHAR2(5000);
      referential_integrity EXCEPTION;
      PRAGMA       EXCEPTION_INIT(referential_integrity, -2292);
   -- =======================================
   -- Mise à jour du flaglock de la facture
   -- =======================================
   BEGIN
      UPDATE  FACTURE
      SET    flaglock  = DECODE(l_flaglock, 1000000, 0, l_flaglock + 1)
      WHERE  socfact   = l_socfact
        AND  numfact   = l_numfact
        AND  typfact   = l_typfact
        AND  datfact   = TO_DATE(l_datfact,'DD/MM/YYYY')
        AND  flaglock  = l_flaglock;

		IF SQL%NOTFOUND THEN  -- Acces concurrent
			Pack_Global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
			RAISE_APPLICATION_ERROR( -20999, l_msg );
		ELSE
			l_flaglockout :=  (l_flaglock + 1);
		END IF;

   EXCEPTION
      WHEN referential_integrity THEN
            Pack_Global.recuperation_integrite(-2292);
      WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20997, SQLERRM);
   END maj_flaglock_fact;


-- ***********************************************
--
--       Verification code comptable
--
-- ***********************************************
   PROCEDURE verif_codecompta  (c_codcompta     IN VARCHAR2       -- code comptable
                               ) IS

      l_msg       VARCHAR2(5000);
      l_comcode   CODE_COMPT.comcode%TYPE;

   -- ===================================================
   -- Test Existence du code comptable pour Ligne Fcature
   -- ===================================================
   BEGIN
      SELECT comcode INTO l_comcode FROM CODE_COMPT
            WHERE  comcode = c_codcompta ;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN             -- msg Code comptable invalide
           Pack_Global.recuperer_message(20110, NULL, NULL, 'LCODCOMPTA', l_msg);
           RAISE_APPLICATION_ERROR(-20110,l_msg);
      WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20997,SQLERRM);
   END verif_codecompta;


-- ******************************************************************
--
-- Verification Mois Prestation  vs  Periode de validite du contrat
--
-- ******************************************************************
   PROCEDURE verif_periode_contrat (v_socfact      IN     FACTURE.socfact%TYPE,
                                    v_numcont      IN     FACTURE.numcont%TYPE,
                                    v_cav          IN     FACTURE.cav%TYPE,
                                    v_lmoisprest   IN     VARCHAR2         -- mois prestation DD/YYYY
                               )  IS
      l_msg       VARCHAR2(5000);
      l_msg2      VARCHAR2(5000);
      l_cdatdeb   CONTRAT.cdatdeb%TYPE;
      l_cdatfin   CONTRAT.cdatfin%TYPE;

   BEGIN
      -- on est sur que le contrat/avenant doit se trouver dans contrat
      SELECT chc.datdeb , chc.datfin INTO  l_cdatdeb, l_cdatfin
      FROM (
            SELECT  c.cdatdeb datdeb, c.cdatfin  datfin
            FROM CONTRAT c
            WHERE  c.soccont = v_socfact
               AND c.numcont = v_numcont
               AND c.cav     = v_cav
           ) chc  ;

      -- Verifier le mois de prestation
      -- 18/05/2000 : on ne s'interesse uniquement au mois
      l_cdatdeb := TO_DATE(TO_CHAR(l_cdatdeb,'MM/YYYY'),'MM/YYYY') ;
      l_cdatfin := TO_DATE(TO_CHAR(l_cdatfin,'MM/YYYY'),'MM/YYYY') ;

      IF (TO_DATE(v_lmoisprest,'MM/YYYY') < l_cdatdeb)  OR  (TO_DATE(v_lmoisprest,'MM/YYYY') > l_cdatfin )
            THEN   -- Msg Mois de prestation doit etre entre cdatdeb et cdatfin
               l_msg2 := TO_CHAR(l_cdatdeb,'MM/YYYY') || ' et ' || TO_CHAR(l_cdatfin,'MM/YYYY');
               Pack_Global.recuperer_message(20141, '%s1', l_msg2, 'LMOISPREST', l_msg);
               RAISE_APPLICATION_ERROR(-20141,l_msg);
      END IF;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN     -- Msg Facture refernce a un contrat/avenant inexistant
            Pack_Global.recuperer_message(20107, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20107,l_msg);
      WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20997,SQLERRM);

   END verif_periode_contrat;


-- ******************************************************************************
--
--  Verification Rapprochement du Montant de la ligne de facture
--
--  Modif 09/02/00 QHL : test via la table proplus
--
-- ******************************************************************************
PROCEDURE verif_rapprochement (l_socfact     IN FACTURE.socfact%TYPE,
                               l_ident         IN VARCHAR2,
                               l_lmontht       IN VARCHAR2,
                               l_lmoisprest    IN VARCHAR2,
                               l_userid        IN VARCHAR2,
                               l_message          OUT VARCHAR2,
                               p_mail             OUT VARCHAR2
                              ) IS

   l_NbJoursTravail	PROPLUS.cusag%TYPE;	-- cumul du nb de jours travaillés
   l_cout_total     PROPLUS.cout%TYPE;   -- Cout total
   l_msg            VARCHAR2(5000);
   l_rapprochement  LIGNE_FACT.lrapprocht%TYPE;
   l_tot_fact		NUMBER(12,2);
   l_montant_mensuel NUMBER(12,2);
   l_liste_fact  	VARCHAR2(32000);
   l_ecart 		    NUMBER(12,2);
   l_rapprocht		VARCHAR2(5000);
   l_mail			VARCHAR2(5000);
   l_ident_gdm		NUMBER(5);
   l_fdeppole    	FACTURE.fdeppole%TYPE;
   l_datedem		DATE;
   l_iddem			DEMANDE_VAL_FACTU.IDDEM%TYPE;
   TYPE Liste_date    IS VARRAY(50) OF DATE;
   TYPE Liste_char1   IS VARRAY(50) OF CHAR(1);
   TYPE Liste_char4   IS VARRAY(50) OF CHAR(4);
   TYPE Liste_char15  IS VARRAY(50) OF CHAR(15);
   TYPE Liste_number2 IS VARRAY(50) OF NUMBER(2);
   TYPE Liste_number3 IS VARRAY(50) OF NUMBER(3);
   t_socfact		Liste_char4  := Liste_char4();  -- Contiendra la liste des sociétés
   t_numfact		Liste_char15 := Liste_char15(); -- Contiendra la liste des numéros de facture
   t_typfact		Liste_char1  := Liste_char1();  -- Contiendra la liste des type de facture
   t_datfact		Liste_date   := Liste_date();   -- Contiendra la liste des dates de facture
   t_lnum			Liste_number2:= Liste_number2();-- Contiendra la liste des numéro de ligne de facture
   t_codcfrais		Liste_number3:= Liste_number3();-- Contiendra la liste des centre de frais
   l_idarpege		VARCHAR2(60);

   -- --------------------------------------------------------------------
   --  Curseur d'extraction du cout et du consomme pour le mois demandé
   -- --------------------------------------------------------------------
   CURSOR cur_coutcons  ( cl_socfact     IN FACTURE.socfact%TYPE,
                          cl_ident       IN VARCHAR2,
                          cl_lmoisprest  IN VARCHAR2
                        ) IS
  	   SELECT   P1.cusag , P1.cout
	   FROM	PROPLUS P1
	   WHERE P1.tires      = TO_NUMBER(cl_ident,'FM99999')
	   AND	P1.SOCIETE    = cl_socfact
	   AND	P1.cdeb       = TO_DATE(cl_lmoisprest,'MM/YYYY')
	   AND (     P1.aist NOT IN ( 'FORMAT','CONGES', 'ABSDIV','MOBILI','PARTIE', 'RTT','RTT   ')
		   OR	P1.aist    IS NULL
		 );

   -- -------------------------------------------------------------------------------
   --  Curseur qui ramène toutes les lignes de facture de la ressource pour le mois
   -- -------------------------------------------------------------------------------
   CURSOR cur_lignefact ( cl_socfact     IN FACTURE.socfact%TYPE,
                          cl_ident       IN VARCHAR2,
                          cl_lmoisprest  IN VARCHAR2
                        ) IS
	SELECT lf.lnum,lf.typfact, lf.numfact, lf.socfact, lf.datfact,DECODE(lf.typfact,'A',-1,1)*lmontht lmontht,
			fac.FDEPPOLE fdeppole, fac.fcentrefrais codcfrais
	FROM LIGNE_FACT lf , FACTURE fac
	WHERE lf.numfact=fac.numfact
	AND   lf.socfact=fac.socfact
	AND   lf.datfact=fac.datfact
	AND   lf.typfact=fac.typfact
	AND   lf.ident=TO_NUMBER(cl_ident,'FM99999')
	AND   lf.lmoisprest=TO_DATE(cl_lmoisprest,'MM/YYYY')
	AND   lf.socfact    = cl_socfact
	AND   (fac.fmodreglt!=8 OR fac.fmodreglt IS NULL)
	--AND   lf.lcodcompta NOT IN (6350001, 6350002, 6398001)
	ORDER BY lf.typfact DESC, lf.numfact
	;


BEGIN

      l_message := '';
	  p_mail := '';
	-----------------------------------------------------------
	-- Calcul du consommé de la ressource pour le mois choisi
	-----------------------------------------------------------
      	l_cout_total := 0;
      	l_NbJoursTravail := 0;
      	FOR ligne_pp IN cur_coutcons (l_socfact, l_ident, l_lmoisprest)
         LOOP
            l_cout_total := l_cout_total + (ligne_pp.cusag * ligne_pp.cout);
            l_NbJoursTravail := l_NbJoursTravail + ligne_pp.cusag ;
      	END LOOP;

	-----------------------------------------------------------
	-- Recherche s'il s'agit d'un forfait au 12 è
	-----------------------------------------------------------
 	SELECT NVL(montant_mensuel,0) INTO l_montant_mensuel
 	FROM SITU_RESS_FULL
 	WHERE ident = l_ident
 	AND   datsitu <= TO_DATE(l_lmoisprest,'MM/YYYY')
 	AND  (datdep > TO_DATE(l_lmoisprest,'MM/YYYY') OR datdep IS NULL ) ;

 	IF l_montant_mensuel > 0 THEN
 		-- Si montant mensuel , positionne le consommé de la ressource à cette valeur
 		l_cout_total := l_montant_mensuel;
 		l_NbJoursTravail := -1 ;
 	END IF;


	----------------------------------------------------------
	-- Calcul du montant facturé pour la ressource et le mois
	----------------------------------------------------------
	l_tot_fact := 0;
	l_liste_fact := '';
	l_fdeppole := 0;
	l_ident_gdm := 0;

	FOR rec_fact IN cur_lignefact (l_socfact, l_ident, l_lmoisprest)
    LOOP
       	l_tot_fact := l_tot_fact + NVL(rec_fact.lmontht,0);
		l_liste_fact := l_liste_fact||' numfact : '||rec_fact.numfact||
				', montant : '||TO_CHAR(rec_fact.lmontht,'FM999999990D00')||' \n ' ;
		-- On ne traitera qu'avec un seul GDM , s'il y a plusieurs DPG impliqués tant pis
		IF (l_fdeppole = 0) THEN
		   l_fdeppole := rec_fact.fdeppole;
		END IF;
		t_socfact.EXTEND;
	   	t_socfact(t_socfact.COUNT) := rec_fact.socfact;
		t_numfact.EXTEND;
	   	t_numfact(t_numfact.COUNT) := rec_fact.numfact;
		t_typfact.EXTEND;
	   	t_typfact(t_typfact.COUNT) := rec_fact.typfact;
		t_datfact.EXTEND;
	   	t_datfact(t_datfact.COUNT) := rec_fact.datfact;
		t_lnum.EXTEND;
	   	t_lnum(t_lnum.COUNT) := rec_fact.lnum;
		t_codcfrais.EXTEND;
	   	t_codcfrais(t_codcfrais.COUNT) := rec_fact.codcfrais;
    END LOOP;

	l_ecart := l_tot_fact - l_cout_total ;
	l_liste_fact:= l_liste_fact||
			' \n Total facture(s): '||TO_CHAR(l_tot_fact,'FM999999990D00')||
			' \n Total consommé: '||TO_CHAR(l_cout_total,'FM999999990D00')||
			' \n Ecart : '||TO_CHAR(l_ecart,'FM999999990D00');
	IF ABS(l_ecart)<1 THEN
		l_rapprocht:='RAPPROCHEMENT JUSTE :  \n ---------------------------------------------- \n ';
	ELSE
		l_rapprocht:='NON RAPPROCHEMENT : \n ------------------------------------------- \n ';
    END IF;

	Pack_Global.recuperer_message(20366, '%s1', l_rapprocht||'Mois de prestation : '||l_lmoisprest||' \n '||l_liste_fact, NULL, l_msg);
	l_message := l_message||l_msg;


   EXCEPTION
      WHEN NO_DATA_FOUND THEN   -- msg Pas de consommé pour le mois demandé
         Pack_Global.recuperer_message(20130, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR(-20130, l_msg);
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20997,SQLERRM);

END verif_rapprochement;



-- ********************************************************************************************
-- ********************************************************************************************
--
-- INSERT_ligne_fact :
--
-- ********************************************************************************************
-- ********************************************************************************************
   PROCEDURE insert_ligne_fact(p_mode         IN VARCHAR2,
                               p_socfact        IN FACTURE.socfact%TYPE,
                               p_soclib         IN SOCIETE.soclib%TYPE,
                               p_numcont        IN FACTURE.numcont%TYPE,
                               p_cav            IN FACTURE.cav%TYPE,
                               p_numfact        IN FACTURE.numfact%TYPE,
                               p_typfact        IN FACTURE.typfact%TYPE,
                               p_datfact        IN VARCHAR2,
                               p_ident          IN VARCHAR2,
                               p_rnom           IN RESSOURCE.rnom%TYPE,
                               p_rprenom        IN RESSOURCE.rprenom%TYPE,
                               p_lmontht        IN VARCHAR2,
                               p_lmoisprest     IN VARCHAR2,
                               p_lcodcompta     IN VARCHAR2,
                               p_lnum           IN VARCHAR2,
                               p_fmontht        IN VARCHAR2,
                               p_ftva           IN VARCHAR2,
                               p_flaglock       IN VARCHAR2,
                               p_userid         IN VARCHAR2,
							   p_typdpg         IN VARCHAR2,
                               p_fmonthtout        OUT VARCHAR2,
                               p_ftvaout           OUT VARCHAR2,
                               p_flaglockout       OUT VARCHAR2,
                               p_nbcurseur         OUT INTEGER,
                               p_message           OUT VARCHAR2
                              ) IS

      l_msg         VARCHAR2(5000);
      l_lnum        NUMBER(2);
      l_numfact     LIGNE_FACT.numfact%TYPE;
      l_ftva        FACTURE.ftva%TYPE;
      l_fdeppole    FACTURE.fdeppole%TYPE;
      referential_integrity EXCEPTION;
      PRAGMA        EXCEPTION_INIT(referential_integrity, -2291);
      l_cdeb        CONS_SSTACHE_RES_MOIS.cdeb%TYPE;
      l_cdur        CONS_SSTACHE_RES_MOIS.cdur%TYPE;
      l_cusag       CONS_SSTACHE_RES_MOIS.cusag%TYPE;
      l_flag_rappro NUMBER(1);
      l_consht      LIGNE_FACT.lmontht%TYPE;
      l_cout        SITU_RESS.cout%TYPE;
      l_flaglockout VARCHAR2(20);
      l_comcode     CODE_COMPT.comcode%TYPE;
      l_mail 		VARCHAR2(5000);
      l_user  VARCHAR2(7);
      l_numexpense VARCHAR2(8);
      l_cav CONTRAT.CAV%TYPE;


   BEGIN


    l_user := pack_global.lire_globaldata (p_userid).idarpege;


      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';
      p_fmonthtout :=  p_fmontht   ;
      p_ftvaout    :=  p_ftva      ;
      l_cav        :=  lpad(NVL(p_cav,0),3,'0');

      -- ===================================================
      -- Test Flaglock de la facture est toujours bonne, Si oui, on l'incremente de 1
      -- Si non Erreur  Acces concurrent
      -- ===================================================
      maj_flaglock_fact(p_socfact,p_numfact,p_typfact,p_datfact,p_flaglock,l_flaglockout);
      p_flaglockout := l_flaglockout;

      -- ===========================================================
      -- Test Mois Prestation  vs  Periode de validite du contrat si facture associée à un contrat
      -- ===========================================================
      IF p_numcont!='' OR p_numcont IS NOT NULL  THEN
		verif_periode_contrat(p_socfact, p_numcont,l_cav, p_lmoisprest);
	END IF;
      -- ===================================================
      -- Test Existence du code comptable dans CODE_COMPT
      -- ===================================================
      verif_codecompta(p_lcodcompta);
    IF p_typdpg ='C' THEN
      -- Selection du ftva et du code fdeppole de la facture
      SELECT fdeppole,NVL(ftva,0)  INTO l_fdeppole, l_ftva
  	  FROM  FACTURE
      WHERE (socfact = p_socfact AND typfact = p_typfact
            AND datfact = TO_DATE(p_datfact,'DD/MM/YYYY') AND numfact = RPAD(p_numfact,15) );
	ELSE IF p_typdpg='R' THEN
      -- Selection du ftva et du code fdeppole de la facture
      	  SELECT res.CODSG,NVL(fact.ftva,0)   INTO l_fdeppole, l_ftva
  	  	  FROM  SITU_RESS res, FACTURE fact
    	  WHERE (fact.socfact = p_socfact AND fact.typfact = p_typfact
         		  AND fact.datfact = TO_DATE(p_datfact,'DD/MM/YYYY') AND fact.numfact = RPAD(p_numfact,15) )
				  AND (TO_DATE(p_datfact,'DD/MM/YYYY')>= res.datsitu AND TO_DATE(p_datfact,'DD/MM/YYYY')<= res.datdep ) AND res.ident =  TO_NUMBER(p_ident,'99999') AND ROWNUM=1 ;
		END IF;

	END IF;


-- 18/05/2000 on prend la tva de la facture au lieu de la table tva !
--      SELECT tva  INTO l_ftva  FROM tva
--      WHERE datetva = (SELECT max(datetva) FROM tva ) ;


      -- Quel est le prochain numero de la ligne de facture ?
      SELECT  MAX(lnum) INTO l_lnum     FROM LIGNE_FACT
      WHERE  (socfact = p_socfact
          AND typfact = p_typfact
          AND datfact = TO_DATE(p_datfact,'DD/MM/YYYY')
          AND numfact = RPAD(p_numfact,15) );

      -- attention sql%found est toujours vrai car on a fait une operation MAX

      l_lnum := NVL(l_lnum,0) + 1 ;

      BEGIN

                SELECT  num_expense INTO l_numexpense     FROM facture
                    WHERE  (socfact = p_socfact
          AND typfact = p_typfact
          AND datfact = TO_DATE(p_datfact,'DD/MM/YYYY')
          AND numfact = RPAD(p_numfact,15) );

         --insert into test_message message values ('facture');
         INSERT INTO LIGNE_FACT
                  (lnum,
                  lmontht,
                  lcodcompta,
                  ldeppole,
                  lmoisprest,
                  socfact,
                  typfact,
                  datfact,
                  numfact,
                  TVA,
                  ident,
				  typdpg
                  )
         VALUES ( l_lnum,
                  TO_NUMBER(p_lmontht,'FM99999999D00'),
                  p_lcodcompta,
                  l_fdeppole,
                  TO_DATE(p_lmoisprest,'MM/YYYY'),
                  p_socfact,
                  p_typfact,
                  TO_DATE(p_datfact,'DD/MM/YYYY'),
                  p_numfact,
                  p_ftva,                               --     l_ftva,
                  TO_NUMBER(p_ident,'99999'), p_typdpg
                  );

         pack_facture.maj_facture_logs(l_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), l_lnum, 'LIGNE_FACT',  l_user, 'LMOISPREST',NULL,to_char(TO_DATE(p_lmoisprest,'MM/YYYY')),'Création du mois de prestation');
         pack_facture.maj_facture_logs(l_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), l_lnum, 'LIGNE_FACT',  l_user, 'LMONTHT',NULL,to_char(TO_NUMBER(p_lmontht,'FM99999999D00')),'Création du montant HT de la ligne facture');
         pack_facture.maj_facture_logs(l_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), l_lnum, 'LIGNE_FACT',  l_user, 'LCODCOMPTA',NULL,to_char(p_lcodcompta),'Création du code comptable');

      EXCEPTION
         WHEN referential_integrity THEN
            Pack_Global.recuperation_integrite(-2291);

         WHEN  DUP_VAL_ON_INDEX THEN  -- Probl de création de la ligne de facture!
            Pack_Global.recuperer_message(20113,NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20113 , l_msg );

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;

      IF SQL%FOUND THEN  -- OK Msg  Ligne de facture créée
         Pack_Global.recuperer_message(2203,NULL,NULL,NULL,l_msg);
         p_message := l_msg;
      END IF;

      -- =====================================
      -- Si tout va bien Test Rapprochement
      -- =====================================
      IF p_mode = 'Rapprochement' THEN
		   -- On a appuyé sur le bouton Rapprochement
           verif_rapprochement(p_socfact, p_ident, p_lmontht, p_lmoisprest, p_userid, l_msg, l_mail);
           p_message := p_message || l_msg;
           -- Si on a pressé sur le bouton Rapprochement - On fait un Rollback global de tout cela
           RAISE_APPLICATION_ERROR(-20366,l_msg);
	  ELSE
		   -- On a appuyé sur le bouton valider - on fait quand même un rapprochement pour avertir le GDM
           verif_rapprochement(p_socfact, p_ident, p_lmontht, p_lmoisprest, p_userid, l_msg, l_mail);
      END IF;   -- Fin du cas Rapprochement

END insert_ligne_fact;




-- ********************************************************************************************************
-- ********************************************************************************************************
--
-- UPDATE_ligne_fact   - possible que si fstatut1 = 'AE' ou 'SE' ou 'IN' déjà contrôlé lors du select_ligne_fact
--
-- ********************************************************************************************************
-- ********************************************************************************************************
   PROCEDURE update_ligne_fact(p_mode         IN VARCHAR2,
                               p_socfact        IN FACTURE.socfact%TYPE,
                               p_soclib         IN SOCIETE.soclib%TYPE,
                               p_numcont        IN FACTURE.numcont%TYPE,
                               p_cav            IN FACTURE.cav%TYPE,
                               p_numfact        IN FACTURE.numfact%TYPE,
                               p_typfact        IN FACTURE.typfact%TYPE,
                               p_datfact        IN VARCHAR2,
                               p_ident          IN VARCHAR2,
                               p_rnom           IN RESSOURCE.rnom%TYPE,
                               p_rprenom        IN RESSOURCE.rprenom%TYPE,
                               p_lmontht        IN VARCHAR2,
                               p_lmoisprest     IN VARCHAR2,
                               p_lcodcompta     IN VARCHAR2,
                               p_lnum           IN VARCHAR2,
                               p_fmontht        IN VARCHAR2,
                               p_ftva           IN VARCHAR2,
                               p_flaglock       IN VARCHAR2,
                               p_userid         IN VARCHAR2,
							   p_typdpg         IN VARCHAR2,
                               p_fmonthtout        OUT VARCHAR2,
                               p_ftvaout           OUT VARCHAR2,
			       			   p_flaglockout       OUT VARCHAR2,
                               p_mail              OUT VARCHAR2,
                               p_nbcurseur         OUT INTEGER,
                               p_message           OUT VARCHAR2
                              ) IS

      l_msg        VARCHAR2(5000);
      referential_integrity EXCEPTION;
      PRAGMA       EXCEPTION_INIT(referential_integrity, -2291);
      l_cdeb       CONS_SSTACHE_RES_MOIS.cdeb%TYPE;
      l_cdur       CONS_SSTACHE_RES_MOIS.cdur%TYPE;
      l_cusag      CONS_SSTACHE_RES_MOIS.cusag%TYPE;
      l_flag_rappro NUMBER(1);
      l_consht     LIGNE_FACT.lmontht%TYPE;
      l_cout       SITU_RESS.cout%TYPE;
      l_flaglockout  VARCHAR2(20);
      l_mail        VARCHAR2(5000) ;
      l_ftva        FACTURE.ftva%TYPE;
      l_fdeppole    FACTURE.fdeppole%TYPE;

      old_tydpg    CHAR(1);
      old_lmontht  NUMBER;
      old_lmoisprest  DATE;
      old_lcodcompta   VARCHAR2(11);
      l_user  VARCHAR2(7);
      l_numexpense VARCHAR2(8);
      l_cav CONTRAT.CAV%TYPE;


   BEGIN


    l_user := pack_global.lire_globaldata (p_userid).idarpege;

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';
		p_flaglockout	:=  p_flaglock ;
      p_fmonthtout   :=  p_fmontht  ;
      p_ftvaout      :=  p_ftva     ;
      l_cav          :=  lpad(NVL(p_cav,0),3,'0');

      -- ===========================================================
      -- Test Mois Prestation  vs  Periode de validite du contrat
      -- ===========================================================
      verif_periode_contrat(p_socfact, p_numcont, l_cav, p_lmoisprest);

      -- ===================================================
      -- Test Existence du code comptable dans CODE_COMPT
      -- ===================================================
      verif_codecompta(p_lcodcompta);
 IF p_typdpg ='C' THEN
      -- Selection du ftva et du code fdeppole de la facture
      SELECT fdeppole,NVL(ftva,0)  INTO l_fdeppole, l_ftva
  	  FROM  FACTURE
      WHERE (socfact = p_socfact AND typfact = p_typfact
            AND datfact = TO_DATE(p_datfact,'DD/MM/YYYY') AND numfact = RPAD(p_numfact,15) );
	ELSE IF p_typdpg='R' THEN
      -- Selection du ftva et du code fdeppole de la facture
      	  SELECT res.CODSG,NVL(fact.ftva,0)   INTO l_fdeppole, l_ftva
  	  	  FROM  SITU_RESS res, FACTURE fact
    	  WHERE (fact.socfact = p_socfact AND fact.typfact = p_typfact
         		  AND fact.datfact = TO_DATE(p_datfact,'DD/MM/YYYY') AND fact.numfact = RPAD(p_numfact,15) )
				  AND (TO_DATE(p_datfact,'DD/MM/YYYY')>= res.datsitu AND TO_DATE(p_datfact,'DD/MM/YYYY')<= res.datdep ) AND res.ident =  TO_NUMBER(p_ident,'99999') AND ROWNUM=1 ;
		END IF;
	END IF;
      -- ===================================================
      -- Test Flaglock de la facture est toujours bonne, Si oui, on l'incremente de 1
      -- Si non Erreur  Acces concurrent
      -- ===================================================
      maj_flaglock_fact(p_socfact,p_numfact,p_typfact,p_datfact,p_flaglock,l_flaglockout);
      p_flaglockout := l_flaglockout;

      -- =======================================
      --  OK update de la ligne la facture
      -- =======================================
      BEGIN

         SELECT LMONTHT, LCODCOMPTA, LMOISPREST, TYPDPG
         into old_lmontht, old_lcodcompta, old_lmoisprest, old_tydpg
         from ligne_fact
         WHERE  lnum     = p_lnum
           AND  socfact  = p_socfact
           AND  numfact  = RPAD(p_numfact,15)
           AND  typfact  = p_typfact
           AND  datfact  = TO_DATE(p_datfact,'DD/MM/YYYY');

         SELECT  num_expense INTO l_numexpense     FROM facture
          WHERE  (socfact = p_socfact
          AND typfact = p_typfact
          AND datfact = TO_DATE(p_datfact,'DD/MM/YYYY')
          AND numfact = RPAD(p_numfact,15) );



         UPDATE LIGNE_FACT
         SET   lmontht     = TO_NUMBER(p_lmontht,'FM999999D00'),
               lmoisprest  = TO_DATE(p_lmoisprest,'MM/YYYY'),
               lcodcompta  = p_lcodcompta,
			   typdpg=p_typdpg,
			   ldeppole=l_fdeppole,
			   TVA= l_ftva
         WHERE  lnum     = p_lnum
           AND  socfact  = p_socfact
           AND  numfact  = RPAD(p_numfact,15)
           AND  typfact  = p_typfact
           AND  datfact  = TO_DATE(p_datfact,'DD/MM/YYYY');


         pack_facture.maj_facture_logs(l_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact),  TO_DATE (p_datfact, 'DD/MM/YYYY'), p_lnum, 'LIGNE_FACT',  l_user, 'LMONTHT',to_char(TO_NUMBER(old_lmontht,'FM999999D00')),to_char(TO_NUMBER(p_lmontht,'FM999999D00')),'Modification du montant HT de la ligne facture');
         pack_facture.maj_facture_logs(l_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact),  TO_DATE (p_datfact, 'DD/MM/YYYY'), p_lnum, 'LIGNE_FACT',  l_user, 'TYDPG',to_char(old_tydpg),to_char(p_typdpg),'Modification du type du centre d''activite');
         pack_facture.maj_facture_logs(l_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact),  TO_DATE (p_datfact, 'DD/MM/YYYY'), p_lnum, 'LIGNE_FACT',  l_user, 'LMOISPREST',to_char(old_lmoisprest,'MM/YYYY'),to_char(p_lmoisprest),'Modification du mois de prestation');
         pack_facture.maj_facture_logs(l_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact),  TO_DATE (p_datfact, 'DD/MM/YYYY'), p_lnum, 'LIGNE_FACT',  l_user, 'LCODCOMPTA',to_char(old_lcodcompta),to_char(p_lcodcompta),'Modification du code comptable');


      EXCEPTION
         WHEN referential_integrity THEN
            Pack_Global.recuperation_integrite(-2291);
         WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20997, SQLERRM);
      END;

      IF SQL%FOUND THEN  -- Msg Ligne de facture modifiée
         Pack_Global.recuperer_message(2204,NULL,NULL,NULL, l_msg);
         p_message := l_msg;
      ELSE    -- SQL Not found : Msg Problème de modification de la ligne de facture
         Pack_Global.recuperer_message(20114,NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20114, l_msg );
      END IF;


      -- =====================================
      -- Si tout va bien Test Rapprochement
      -- =====================================
      IF p_mode = 'Rapprochement' THEN
		   -- On a appuyé sur le bouton Rapprochement
           verif_rapprochement(p_socfact, p_ident, p_lmontht, p_lmoisprest, p_userid, l_msg, l_mail);
           p_message := p_message || l_msg;
          RAISE_APPLICATION_ERROR(-20366,l_msg);
	  ELSE
		   -- On a appuyé sur le bouton valider - on fait quand même un rapprochement pour avertir le GDM
           verif_rapprochement(p_socfact, p_ident, p_lmontht, p_lmoisprest,  p_userid, l_msg, l_mail);
      END IF;   -- Fin du cas Rapprochement

END update_ligne_fact;



-- ********************************************************************************************
-- ********************************************************************************************
--
-- DELETE_ligne_fact  :
--
-- ********************************************************************************************
-- ********************************************************************************************
  PROCEDURE delete_ligne_fact (p_socfact        IN FACTURE.socfact%TYPE,
                               p_soclib         IN SOCIETE.soclib%TYPE,
                               p_numcont        IN FACTURE.numcont%TYPE,
                               p_cav            IN FACTURE.cav%TYPE,
                               p_numfact        IN FACTURE.numfact%TYPE,
                               p_typfact        IN FACTURE.typfact%TYPE,
                               p_datfact        IN VARCHAR2,
                               p_ident          IN VARCHAR2,
                               p_rnom           IN RESSOURCE.rnom%TYPE,
                               p_rprenom        IN RESSOURCE.rprenom%TYPE,
                               p_lmontht        IN VARCHAR2,
                               p_lmoisprest     IN VARCHAR2,
                               p_lcodcompta     IN LIGNE_FACT.lcodcompta%TYPE,
                               p_lnum           IN VARCHAR2,
                               p_fmontht        IN VARCHAR2,
                               p_ftva           IN VARCHAR2,
                               p_flaglock       IN VARCHAR2,
                               p_userid         IN VARCHAR2,
                               p_fmonthtout        OUT VARCHAR2,
                               p_ftvaout           OUT VARCHAR2,
                               p_flaglockout       OUT VARCHAR2,
                               p_nbcurseur         OUT INTEGER,
                               p_message           OUT VARCHAR2
                              ) IS

      l_msg VARCHAR2(5000);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
      l_exist NUMBER;
      l_lnum NUMBER;
           l_user  VARCHAR2(7);
           l_numexpense VARCHAR2(8);


   BEGIN


    l_user := pack_global.lire_globaldata (p_userid).idarpege;


      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      -- l'utilisateur a déjà fait un select pour visualiser avant, ici on est sur que
      -- la facture existe et donc la seule difference ne concernera que le Flaglock

      p_nbcurseur := 0;
      p_message := '';

      p_flaglockout :=  p_flaglock ;
      p_fmonthtout  :=  p_fmontht  ;
      p_ftvaout     :=  p_ftva     ;


      -- =======================================
      -- Mise à jour du flaglock de la facture
      -- =======================================
      BEGIN



         UPDATE  FACTURE
         SET    flaglock  = DECODE(p_flaglock, 1000000, 0, p_flaglock + 1)
         WHERE  socfact   = p_socfact
           AND  numfact   = p_numfact
           AND  typfact   = p_typfact
           AND  datfact   = TO_DATE(p_datfact,'DD/MM/YYYY')
           AND  flaglock  = p_flaglock;

			IF SQL%NOTFOUND THEN  -- Acces concurrent
				Pack_Global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
				RAISE_APPLICATION_ERROR( -20999, l_msg );
			ELSE
				p_flaglockout :=  (p_flaglock + 1);
			END IF;

      EXCEPTION
         WHEN referential_integrity THEN
            Pack_Global.recuperation_integrite(-2292);
         WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20997, SQLERRM);
      END;

      -- =============================================================================
      -- 06/10/2000 : Suppression impossible s'il existe des lignes de facture après
      -- ===============================================================================
	BEGIN


		SELECT MAX(lnum) INTO l_exist
		FROM LIGNE_FACT
		WHERE
		      socfact = p_socfact
           	 AND  numfact = RPAD(p_numfact,15)
           	 AND  typfact = p_typfact
           	 AND  datfact = TO_DATE(p_datfact,'DD/MM/YYYY') ;

		IF l_exist!=TO_NUMBER(p_lnum) THEN
		 --suppression impossible, on ne peut supprimer que la dernière ligne de facture
		Pack_Global.recuperer_message(20326,NULL,NULL,NULL, l_msg);
         	p_message := l_msg;
      	ELSE

      	-- =======================================
     	 -- OK Delete de la  ligne de facture
     	 -- =======================================
      	BEGIN

                 SELECT  num_expense INTO l_numexpense     FROM facture
                    WHERE  (socfact = p_socfact
          AND typfact = p_typfact
          AND datfact = TO_DATE(p_datfact,'DD/MM/YYYY')
          AND numfact = RPAD(p_numfact,15) );


            DELETE FROM LIGNE_FACT
         	WHERE  lnum    = p_lnum
           	AND  socfact = p_socfact
           	AND  numfact = RPAD(p_numfact,15)
           	AND  typfact = p_typfact
           	AND  datfact = TO_DATE(p_datfact,'DD/MM/YYYY') ;

           pack_facture.maj_facture_logs(l_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact),  TO_DATE (p_datfact, 'DD/MM/YYYY'), p_lnum, 'LIGNE_FACT',  l_user, 'TOUTES',NULL,'VIDE','Suppression de la ligne facture');


      	EXCEPTION
         	WHEN referential_integrity THEN
              		Pack_Global.recuperation_integrite(-2292);
         	WHEN OTHERS THEN
               		RAISE_APPLICATION_ERROR(-20997, SQLERRM);
      	END;

      IF SQL%FOUND THEN
         -- Ligne de facture supprimée
         Pack_Global.recuperer_message(2205,NULL,NULL,NULL, l_msg);
         p_message := l_msg;
      END IF;
	END IF;
END;
   END delete_ligne_fact;


-- ********************************************************************************************
-- ********************************************************************************************
--
-- UPDATE_facture_majlig : Ecran Lignes de facture - bouton 'VALIDER'
--       Update de la facture avec le montant HT + tva via l'écran màj lignes
--       Si OK on passera à l'écran Dates de suivi Facture
-- Quand    Qui  Procedure impactée + Quoi
-- -------- ---  ----------------------------------------------------------------------------------------
-- 18/01/00 QHL  update_facture_majlig : Si fact. sans contrat Alors Update Facture et ecran suivant
--                           Si fact avec contrat Alors MontantHT doit égale Somme(MontantHT ligne_fact)
--
-- 19/10/00 NCM  Mise à jour de la tva dans ligne_fact si chgt de code tva dans la facture
-- ********************************************************************************************
-- ********************************************************************************************
   PROCEDURE update_facture_majlig (p_mode     IN VARCHAR2,
                               p_socfact     IN FACTURE.socfact%TYPE,
                               p_soclib      IN SOCIETE.soclib%TYPE,
                               p_numcont     IN FACTURE.numcont%TYPE,
                               p_cav         IN FACTURE.cav%TYPE,
                               p_numfact     IN FACTURE.numfact%TYPE,
                               p_typfact     IN FACTURE.typfact%TYPE,
                               p_datfact     IN VARCHAR2,
                               p_fmontht     IN VARCHAR2,
                               p_ftva        IN VARCHAR2,
                               p_clelf       IN VARCHAR2,
                               p_flaglock    IN VARCHAR2,
                               p_userid      IN VARCHAR2,
                               p_flaglockout    OUT VARCHAR2,
                               p_soclibout      OUT VARCHAR2,
                               p_socfactout     OUT VARCHAR2,
                               p_numfactout     OUT VARCHAR2,
                               p_typfactout     OUT VARCHAR2,
                               p_datfactout     OUT VARCHAR2,
                               p_nbcurseur      OUT INTEGER,
                               p_message        OUT VARCHAR2
                              ) IS

      l_msg         VARCHAR2(5000) ;
      l_msg2        VARCHAR2(5000);
      l_soclib      SOCIETE.soclib%TYPE ;
      l_socfact     FACTURE.socfact%TYPE ;
      p_filcode     FILIALE_CLI.filcode%TYPE ;
      referential_integrity EXCEPTION;
      PRAGMA        EXCEPTION_INIT(referential_integrity, -2291);
      l_sumlmontht  NUMBER(12,2);
      l_countlf     NUMBER(12,2);
      l_user  VARCHAR2(7);
      old_fmontht   NUMBER;
      old_ftva      NUMBER;
      l_numexpense VARCHAR2(8);


   BEGIN


    l_user := pack_global.lire_globaldata (p_userid).idarpege;



      p_socfactout :=  p_socfact;
      p_soclibout  :=  p_soclib;
      p_numfactout :=  p_numfact;
      p_typfactout :=  p_typfact;
      p_datfactout :=  p_datfact;

      l_sumlmontht := 0;
      l_countlf    := 0;
      l_msg        := '';
      l_msg2       := '';

      -- ******************************************************************
      --
      -- * Si Facture sans contrat Alors Update facture et on passe à Dates de suivi
      -- * Si facture avec contrat
      --   Alors on passe à Dates de suivi que si MontantTotalHT=Somme(MontantHT ligne fact)
      --   Si OK , UPDATE facture avec le MontantTotalHT et le TVA  puis passer aux 'Dates de Suivi'
      --
      -- ******************************************************************

      IF p_numcont IS NOT NULL  THEN
         BEGIN
            -- ==================================================
            -- CAS  FACTURE AVEC CONTRAT
            -- Lire les lignes de facture et faire la somme
            -- ==================================================
            SELECT  SUM(lmontht), COUNT(lmontht)
               INTO l_sumlmontht, l_countlf
            FROM  LIGNE_FACT
            WHERE    socfact  = p_socfact
               AND   typfact  = p_typfact
               AND   datfact  = TO_DATE(p_datfact,'DD/MM/YYYY')
               AND   numfact  = RPAD(p_numfact,15) ;

            IF l_countlf = 0  THEN
               -- ============================================================
               -- Erreur : Lignes de facture inexistantes pour cette facture
               -- ============================================================
               Pack_Global.recuperer_message(20120,NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20120, l_msg);
            ELSIF ((TO_NUMBER(p_fmontht,'FM99999999D00')) <> l_sumlmontht) THEN
               -- ==================================================================================
               -- Erreur : Montant total HT différent de la somme des montants des lignes de facture
               -- ==================================================================================
               Pack_Global.recuperer_message(20121,'%s1',p_fmontht,'%s2',l_sumlmontht, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20121, l_msg);
            END IF;
         END;
      END IF;


      -- =============================================
      -- Màj de la facture
      -- =============================================
      BEGIN

        SELECT fmontht, ftva, num_expense
        into old_fmontht, old_ftva, l_numexpense
        from facture
        where   socfact  = p_socfact
           AND  numfact  = RPAD(p_numfact,15)
           AND  typfact  = p_typfact
           AND  datfact  = TO_DATE(p_datfact,'DD/MM/YYYY');

         UPDATE FACTURE
         SET   fmontht   = TO_NUMBER(p_fmontht,'FM99999999D00'),
               fmontttc  = (TO_NUMBER(p_fmontht,'FM99999999D00')*(1+(TO_NUMBER(p_ftva,'FM999D00')/100))),
               ftva      = TO_NUMBER(p_ftva,'FM999D00'),
               flaglock  = DECODE(p_flaglock, 1000000, 0, p_flaglock + 1)
         WHERE  socfact  = p_socfact
           AND  numfact  = RPAD(p_numfact,15)
           AND  typfact  = p_typfact
           AND  datfact  = TO_DATE(p_datfact,'DD/MM/YYYY')
           AND  flaglock = p_flaglock;


           pack_facture.maj_facture_logs(l_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact),  TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_user, 'FMONTHT',to_char(TO_NUMBER(old_fmontht,'FM999999D00')),to_char(TO_NUMBER(p_fmontht,'FM999999D00')),'Modification du montant HT de la facture');
           pack_facture.maj_facture_logs(l_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact),  TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_user, 'FTVA',to_char(TO_NUMBER(old_ftva,'FM999999D00')),to_char(TO_NUMBER(p_ftva,'FM999999D00')),'Modification du taux de la TVA');


         IF SQL%NOTFOUND THEN  -- Acces concurrent
            Pack_Global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20999, l_msg );
         ELSE
            --
            -- Msg Facture %s1 MODIFIEE
            --
            p_flaglockout :=  (p_flaglock + 1) ;
            Pack_Global.recuperer_message(2201,'%s1',p_numfact, NULL, l_msg);
            p_message := l_msg;

         END IF;

      EXCEPTION
         WHEN referential_integrity THEN
            Pack_Global.recuperation_integrite(-2291);
         WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20997, SQLERRM);
      END; -- End bloc màj facture


      -- ====================================================
      -- Mise à jour des dates FREGCOMPTA et FACCSEC si null
      -- ====================================================
      BEGIN
         UPDATE FACTURE
         SET    fregcompta = SYSDATE,
                faccsec    = SYSDATE
         WHERE     socfact    = p_socfact
              AND  numfact    = RPAD(p_numfact,15)
              AND  typfact    = p_typfact
              AND  datfact    = TO_DATE(p_datfact,'DD/MM/YYYY')
              AND  fregcompta IS NULL
              AND  faccsec    IS NULL
         ;
      END;

      -- ===================================================================================================
      -- 19/10/2000 : Mise à jour de la tva des lignes de facture si chgt de tva après création de la ligne
      -- ====================================================================================================
      BEGIN
	UPDATE LIGNE_FACT
	SET TVA=TO_NUMBER(p_ftva,'FM999D00')
	WHERE socfact  = p_socfact
           AND  numfact  = RPAD(p_numfact,15)
           AND  typfact  = p_typfact
           AND  datfact  = TO_DATE(p_datfact,'DD/MM/YYYY') ;


      END;
   END update_facture_majlig;   -- End bloc If Valider



-- ********************************************************************************************
-- ********************************************************************************************
--
-- SELECT_ligne_fact
-- Cas a tester : 1) Bouton Creer Lignes de facture
--                2) Bouton Modifier ou Supprimer + sélection de lignes de facture
--
-- ********************************************************************************************
-- ********************************************************************************************
  PROCEDURE select_ligne_fact (p_mode      IN VARCHAR2,
                               p_socfact     IN FACTURE.socfact%TYPE,
                               p_soclib      IN SOCIETE.soclib%TYPE,
                               p_numcont     IN FACTURE.numcont%TYPE,
                               p_cav         IN FACTURE.cav%TYPE,
                               p_numfact     IN FACTURE.numfact%TYPE,
                               p_typfact     IN FACTURE.typfact%TYPE,
                               p_datfact     IN VARCHAR2,
                               p_fmontht     IN VARCHAR2,
                               p_ftva        IN VARCHAR2,
                               p_clelf       IN VARCHAR2,
                               p_flaglock    IN VARCHAR2,
                               p_userid      IN VARCHAR2,
                               p_curselect   IN OUT LigfSelectCur,
                               p_fmonthtout     OUT VARCHAR2,
                               p_ftvaout        OUT VARCHAR2,
                               p_flaglockout    OUT VARCHAR2,
                               p_nbcurseur      OUT INTEGER,
                               p_message        OUT VARCHAR2
                              ) IS

      l_msg         VARCHAR2(5000) ;
      l_lnum        VARCHAR2(20);
      l_ident       VARCHAR2(20);
      l_rnom        VARCHAR2(40);
      l_rprenom     VARCHAR2(20);
      l_lmontht     VARCHAR2(20);
      l_lmoisprest  VARCHAR2(20);
      l_lcodcompta  VARCHAR2(20);
      l_typdpg  CHAR(1);
   BEGIN
      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      p_nbcurseur   := 1;
      p_message     := '';
      p_flaglockout :=  p_flaglock;
      p_fmonthtout  :=  p_fmontht ;
      p_ftvaout     := p_ftva    ;


  -- ************************************************************************
  --
  --  Cas CREER : il n'y a rien a faire, on passe
  --  à l'écran "Saisir l'identifiant d'une ressource"
  --
  -- ************************************************************************

   IF p_mode = 'insert' THEN  NULL;
   END IF;  -- Fin du cas creation


   -- ******************************************************************
   --
   -- Cas  MODIFIER  ou  SUPPRIMER (lignes de factures) les infos sont
   -- contenues dans clelf qu'il suffit de les extraire
   --
   -- ******************************************************************

   IF (p_mode = 'update' OR p_mode = 'delete') THEN
		BEGIN
			Pack_Liste_Lignes_Fact.xcle_ligne_fact(p_clelf, 0,
				l_lnum, l_ident, l_rnom, l_rprenom,
				l_lmontht, l_lmoisprest, l_lcodcompta,l_typdpg) ;

 		   -- Retour du curseur
			OPEN p_curselect FOR
				SELECT   p_socfact   ,
							p_soclib    ,
							p_numcont   ,
							NVL(p_cav,' ')       ,
							p_numfact   ,
							p_typfact   ,
							p_datfact   ,
							l_lnum      ,
							l_ident     ,
							l_rnom      ,
							l_rprenom   ,
							l_lmontht   ,
							l_lmoisprest,
							l_lcodcompta,
							l_typdpg

			FROM dual;
		END;
   END IF;  -- Fin du cas  MODIFIER ou SUPPRIMER

END select_ligne_fact;



-- ********************************************************************************************
-- ********************************************************************************************
--
-- SELECT_ident_ress  : filtre identifiant ressource
--
-- Quand    Qui  Procedure impactée + Quoi
-- -------- ---  ----------------------------------------------------------------------------------------
-- 18/01/00 QHL  * select_ident_ress : ajout controle existence de Identifiant ressource appartenant à société
--               on recherche dans ligne_cont
--
--
-- ********************************************************************************************
-- ********************************************************************************************
   PROCEDURE select_ident_ress (p_socfact     IN FACTURE.socfact%TYPE,
                               p_soclib      IN SOCIETE.soclib%TYPE,
                               p_numcont     IN FACTURE.numcont%TYPE,
                               p_cav         IN FACTURE.cav%TYPE,
                               p_numfact     IN FACTURE.numfact%TYPE,
                               p_typfact     IN FACTURE.typfact%TYPE,
                               p_datfact     IN VARCHAR2,
                               p_listeress   IN VARCHAR2,
                               p_ident       IN VARCHAR2,
                               p_fmontht     IN VARCHAR2,
                               p_ftva        IN VARCHAR2,
                               p_flaglock    IN VARCHAR2,
                               p_userid      IN VARCHAR2,
							   p_typdpg      IN VARCHAR2,
                               p_socfactout     OUT VARCHAR2,
                               p_soclibout      OUT VARCHAR2,
                               p_numcontout     OUT VARCHAR2,
                               p_cavout         OUT VARCHAR2,
                               p_numfactout     OUT VARCHAR2,
                               p_typfactout     OUT VARCHAR2,
                               p_datfactout     OUT VARCHAR2,
                               p_identout       OUT VARCHAR2,
                               p_rnomout        OUT VARCHAR2,
                               p_rprenomout     OUT VARCHAR2,
                               p_fmonthtout     OUT VARCHAR2,
                               p_ftvaout        OUT VARCHAR2,
							   p_typdpgout        OUT VARCHAR2,
                               p_flaglockout    OUT VARCHAR2,
                               p_nbcurseur      OUT INTEGER,
                               p_message        OUT VARCHAR2
                              ) IS

      l_msg       VARCHAR2(5000) ;
      l_rnom      RESSOURCE.rnom%TYPE;
      l_rprenom   RESSOURCE.rprenom%TYPE;

   BEGIN
         -- Positionner le nb de curseurs ==> 0
         -- Initialiser le message retour
         p_nbcurseur  := 1;
         p_message    := '';
         p_socfactout :=  p_socfact   ;
         p_soclibout  :=  p_soclib    ;
         p_numcontout :=  p_numcont   ;
         p_cavout     :=  p_cav       ;
         p_numfactout :=  p_numfact   ;
         p_typfactout :=  p_typfact   ;
         p_datfactout :=  p_datfact   ;
         p_identout   :=  p_ident     ;
         p_fmonthtout :=  p_fmontht   ;
         p_ftvaout    :=  p_ftva      ;
		 IF (p_typdpg= NULL) THEN
		  p_typdpgout :='C';
		  ELSE
		  p_typdpgout := p_typdpg;
		 END IF;
      BEGIN
       IF p_numcont!='' OR p_numcont IS NOT NULL THEN          -- FACTURE AVEC CONTRAT
	   SELECT frnom, frprenom INTO l_rnom, l_rprenom
         FROM (
               SELECT r.rnom frnom, r.rprenom frprenom
               FROM  LIGNE_CONT lc, RESSOURCE r
               WHERE	    r.ident    =  lc.ident
                     AND ROWNUM     = 1
                     AND lc.soccont = p_socfact
                     AND r.ident    = TO_NUMBER(p_ident,'FM99999')
             )
         WHERE ROWNUM = 1;
	ELSE								-- FACTURE SANS CONTRAT
		SELECT rnom,rprenom INTO l_rnom, l_rprenom
		FROM RESSOURCE
		WHERE ident = TO_NUMBER(p_ident,'FM99999');
	END IF;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN     -- Msg Code ressource inexistant
               Pack_Global.recuperer_message(20131, '%s1', p_ident, NULL, l_msg);
               RAISE_APPLICATION_ERROR(-20131,l_msg);

         WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20997,SQLERRM);
      END;

         p_rnomout    :=  l_rnom;
         p_rprenomout :=  l_rprenom;
         p_flaglockout:=  p_flaglock;



END select_ident_ress;

END Pack_Ligne_Fact;
/


