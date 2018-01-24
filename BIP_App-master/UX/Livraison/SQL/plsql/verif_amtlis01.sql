--------------------------------------------------------
--  Fichier créé - lundi-octobre-10-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PACK_VERIF_AMTLIS01
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "BIP"."PACK_VERIF_AMTLIS01" AS
-- ----------------------------------------------

   -- ------------------------------------------------------------------------
   --
   -- Nom        : f_immo_montant_ht_anprec
   -- Auteur     : Equipe SOPRA (HT)
   -- Decription : Calcul du champ Montant HT de l'état AMTLIS01
   --              en utilisant règle de gestion <Montant HT années précédentes>
   -- Paramètres :
   --              p_pid (IN)        Identifiant projet
   --			 p_annee_cour (IN)      Année courante 'AAAA'
   --              p_decr_annee_cour (IN) Décrément de l'année courante
   --                                     On travaille sur l'année (p_annee_cour - p_decr_annee_cour)!
   --              p_adatestatut (IN)     Date de statut
   --              p_mois_11 (IN)    	Mois (format 'MM') utilisé pour comparaison
   --                                     ('11' par défaut)
   -- Retour     : Montant HT de l'état AMTLIS01
   --
   -- Remarque :
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_immo_montant_ht_anprec(
			    p_pid            IN histo_amort.pid%TYPE,
			    p_annee_cour          IN VARCHAR2,
			    p_decr_annee_cour     IN NUMBER,
			    p_adatestatut         IN ligne_bip.adatestatut%TYPE
			   ) RETURN NUMBER;

   -- ------------------------------------------------------------------------
   --
   -- Nom        : f_immo_montant_ht_ancour
   -- Auteur     : Equipe SOPRA (HT)
   -- Decription : Calcul du champ Montant HT de l'état AMTLIS01
   --              en utilisant règle de gestion <Montant HT année courante>
   -- Paramètres :
   --              p_pid (IN)        Identifiant projet
   --              p_annee_cour (IN)      Année courante
   --              p_dat_der_mensuelle (IN) Date dernière mensuelle
   --              p_adatestatut (IN)     Date de statut   (JJ/MM/AAAA)
   --              p_mois_01 (IN)         Mois (format 'MM') utilisé pour comparaison
   --                                     ('01' par défaut)
   --              p_mois_11 (IN)    	Mois (format 'MM') utilisé pour comparaison
   --                                     ('11' par défaut)
   -- Retour     : Montant HT de l'état AMTLIS01
   --
   -- Remarque :
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_immo_montant_ht_ancour(
   			    p_pid    IN histo_amort.pid%TYPE,
			    p_annee_cour  IN VARCHAR2,
   			    p_adatestatut IN ligne_bip.adatestatut%TYPE
   			   ) RETURN NUMBER;

   -- ------------------------------------------------------------------------
   --
   -- Nom        : f_immo_montant_ht_an_mois
   -- Auteur     : O. DUPREY
   -- Decription : Calcul du champ Montant HT de l'état AMTLIS01
   --              en utilisant règle de gestion <Montant HT années précédentes>
   --		   pour la periode d'une annee commencant au mois indique
   --		   (pour les annees avec changement de TVA : 1995, 2000, ...)
   -- Paramètres :
   --              p_pid (IN)	Identifiant projet
   --		   p_annee(IN)		Année de calcul
   --		   p_mois_debut(IN)	premier mois de la periode
   --              p_adatestatut (IN)	Date de statut
   --              p_mois_11 (IN)	Mois (format 'MM') utilisé pour comparaison
   -- Retour     : Montant HT de l'état AMTLIS01
   --
   -- Remarque :
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_immo_montant_ht_an_mois(
			    p_pid		IN histo_amort.pid%TYPE,
			    p_annee		IN INTEGER,
			    p_mois_debut	IN INTEGER,
			    p_adatestatut	IN ligne_bip.adatestatut%TYPE
			   ) RETURN NUMBER;

PRAGMA restrict_references(f_immo_montant_ht_anprec, WNDS, WNPS);
PRAGMA restrict_references(f_immo_montant_ht_ancour, WNDS, WNPS);
PRAGMA restrict_references(f_immo_montant_ht_an_mois, WNDS, WNPS);

END pack_verif_amtlis01 ;

 

/
--------------------------------------------------------
--  DDL for Package Body PACK_VERIF_AMTLIS01
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "BIP"."PACK_VERIF_AMTLIS01" AS
-- ---------------------------------------------------

FUNCTION f_immo_montant_ht_anprec(
			    p_pid        IN histo_amort.pid%TYPE,
			    p_annee_cour      IN VARCHAR2,
                p_decr_annee_cour IN NUMBER,
			    p_adatestatut     IN ligne_bip.adatestatut%TYPE
			   ) RETURN NUMBER IS
      l_montant_res NUMBER(15, 2) := 0 ;
	l_annee_consideree VARCHAR2(4);  -- Année considerée

BEGIN

	BEGIN
		--------------------------------------------------------------------------
		-- Traitement proprement dit
		--------------------------------------------------------------------------
		l_annee_consideree := TO_CHAR( TO_NUMBER(p_annee_cour) - p_decr_annee_cour );

		IF	(l_annee_consideree <= 2003) OR
			(p_adatestatut IS NULL) OR
			(p_adatestatut > TO_DATE( '30/11/' || TO_CHAR(TO_NUMBER(l_annee_consideree) -1), 'DD/MM/YYYY' ))
      	THEN
			-- Calcul somme des coûts de l'historique du projet
			SELECT
				SUM(acoutssiifde)
				+ SUM(acoutssiilde)
				+ SUM(acoutssiipde)
				+ SUM(acoussiif)
				+ SUM(acoutssiil)
				+ SUM(acoutssiip)
			INTO
				l_montant_res
			FROM
				histo_amort
			WHERE
				pid = p_pid
				AND aanhist BETWEEN TO_DATE('01/01/' || l_annee_consideree, 'DD/MM/YYYY')
							  AND TO_DATE('31/12/' || l_annee_consideree, 'DD/MM/YYYY') ;
		END IF;


		RETURN( NVL(l_montant_res, 0) );

      	EXCEPTION
			WHEN OTHERS THEN
				RETURN(0);
	END;
END f_immo_montant_ht_anprec;


FUNCTION f_immo_montant_ht_ancour(
		   			    p_pid          IN histo_amort.pid%TYPE,
		                p_annee_cour        IN VARCHAR2,
		   			    p_adatestatut       IN ligne_bip.adatestatut%TYPE
   			   ) RETURN NUMBER
IS
	l_montant_histo_amort  NUMBER(15, 2) := 0 ;
	l_montant_res NUMBER(15, 2) := 0 ;
BEGIN


	BEGIN
		-------------------------------------------------------------------------------------
		-- Le montant de l'annee en cours avec la table stock_immo
		-------------------------------------------------------------------------------------
 		IF	(p_annee_cour <= 2003) OR
			(p_adatestatut IS NULL) OR
			(p_adatestatut > TO_DATE( '30/11/' || TO_CHAR(TO_NUMBER(p_annee_cour) -1), 'DD/MM/YYYY' ))
		THEN
			SELECT
				SUM(CONSOFT)
			INTO
				l_montant_histo_amort
			FROM
				stock_immo
			WHERE
				pid = p_pid;
		END IF;

		EXCEPTION
			WHEN OTHERS THEN
	           		l_montant_histo_amort := 0;
	END;

--	BEGIN
--		-------------------------------------------------------------------------------------
--		-- (2) Calcul de l_montant_proplus
--		-------------------------------------------------------------------------------------
--		SELECT
--			SUM(cusag * cout)
--		INTO
--			l_montant_proplus
--		FROM
--			proplus  pro
--		WHERE
--			pro.factpid = p_pid
--			AND ( pro.cdeb <= p_dat_der_mensuelle )
--			AND ( pro.cdeb >= TO_DATE(l_premjour_mois_01 || '/' || p_mois_01 || '/' || p_annee_cour, 'DD/MM/YYYY') )
--			AND ( pro.cdeb <= TO_DATE(l_derjour_mois_11 || '/' || p_mois_11 || '/' || p_annee_cour, 'DD/MM/YYYY') )
--            	AND NOT EXISTS ( SELECT 1 FROM ex4sst WHERE codex = pro.aist )
--			AND pro.societe != 'SG..'
--                  AND ( (pro.qualif NOT IN ('GRA', 'MO')) OR (pro.qualif IS NULL) )
--		;
--
--      	EXCEPTION
--			WHEN OTHERS THEN
--				l_montant_proplus := 0;
--	END;

	BEGIN

		-------------------------------------------------------------------------------------
		-- (3) Calcul de l_montant_res
		-------------------------------------------------------------------------------------
		--l_montant_res := NVL(l_montant_histo_amort, 0) + NVL(l_montant_proplus, 0);
		l_montant_res := NVL(l_montant_histo_amort, 0);

		RETURN(l_montant_res);

	END;
END f_immo_montant_ht_ancour;


FUNCTION f_immo_montant_ht_an_mois(
			p_pid		IN histo_amort.pid%TYPE,
			p_annee			IN INTEGER,
			p_mois_debut		IN INTEGER,
			p_adatestatut		IN ligne_bip.adatestatut%TYPE
			   ) RETURN NUMBER IS
	l_montant_res		NUMBER(15, 2) := 0 ;
	l_derjour_mois_11	CONSTANT VARCHAR2(2) := '30';
BEGIN

	BEGIN
		--------------------------------------------------------------------------
		-- Traitement proprement dit
		--------------------------------------------------------------------------
		IF	(p_annee <= 2003) OR
			(p_adatestatut IS NULL) OR
			(p_adatestatut > TO_DATE( '30/11/' || TO_CHAR(TO_NUMBER(p_annee) -1), 'DD/MM/YYYY' ))
      		THEN
			-- Calcul somme des coûts de l'historique du projet
			SELECT
				SUM(acoutssiifde)
				+SUM(acoutssiilde)
				+SUM(acoutssiipde)
				+SUM(acoussiif)
				+SUM(acoutssiil)
				+SUM(acoutssiip)
			INTO
				l_montant_res
			FROM
				histo_amort
			WHERE
				pid = p_pid
				AND aanhist=TO_DATE('01/' || TO_CHAR(p_mois_debut) || '/' || TO_CHAR(p_annee), 'DD/MM/YYYY') ;
		END IF;
		RETURN( NVL(l_montant_res, 0) );

      	EXCEPTION
			WHEN OTHERS THEN
				RETURN(0);
	END;
END f_immo_montant_ht_an_mois;


END pack_verif_amtlis01 ;

/
