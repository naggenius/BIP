-- -------------------------------------------------------------------
-- pack_verif_visuproj PL/SQL
-- equipe SOPRA (HTM)
-- crée le 26/01/2000
-- Attention le PRAGMA restrict_references doit etre declare juste après la fonction !!!
--
-- Package qui sert à la réalisation de l'état VISUPROJ
-- (Edition des infos générales et budgétaires  d'une ligne BIP)
--
-- Quand      Qui Quoi
-- --------   --- ----------------------------------------------------
-- 09/02/2001 PHD Correction liée à la nouvelle FI (cout de FI par DPG)
--
-- 30/07/2002 ARE Correction liée aux suppression dans la table proplus  des données inférieures à l'année N-5
--                On utilise pour le consommé avant l'année N-1 le champ xcusag de l'année N-2 dans consomme
-- 12/08/2002 MMC modif de  f_calc_totbudcons_depuis_creat : autre facon de calculer le consomme total
--
-- 02/11/2004 PPR Rajout fonction f_calc_immos
-- 22/05/2006 DDI Passage du total sur 2 décimales (f_calc_totbudcons_depuis_creat)
-- 01/09/2014 SEL PPM 58986 : changement de regle de calcul pour prendre en compte la FI en année calendaire.
-- -------------------------------------------------------------------

CREATE OR REPLACE PACKAGE pack_verif_visuproj  AS
-- ----------------------------------------------

-- ------------------------------------------------------------------------
--
-- Nom        : verif_visuproj
-- Auteur     : Equipe SOPRA 
-- Decription : Vérification des paramètres saisis pour l'état visuproj
-- Paramètres : 
--              p_pid (IN)			Code projet
--              p_userid      (IN) 		Code user BIP
--		    P_message OUT             Message de sortie
-- 
-- Remarque :  
--             
-- ------------------------------------------------------------------------   

     PROCEDURE verif_visuproj( 
                 p_pid 		IN  VARCHAR2,	     -- CHAR(4) 
		 p_userid 	IN  VARCHAR2,
                 P_message 	OUT VARCHAR2
                 );


   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_budget_propose
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget proposé pour une annee
   --              
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   -- Retour     : Montant du budget proposé
   --	           
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_budget_propose(
				p_pid   IN budget.pid%TYPE,
			        p_annee IN budget.annee%TYPE
			     	) RETURN NUMBER;
   
   PRAGMA restrict_references(f_calc_budget_propose,wnds);
   
-- ------------------------------------------------------------------------

   -- Nom        : f_calc_budget_propose_mo
   -- Auteur     : MMC
   -- Decription : calcul le budget proposé pour une annee
   --              
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   -- Retour     : Montant du budget proposé
   -- ------------------------------------------------------------------------

   FUNCTION f_calc_budget_propose_mo(
				p_pid   IN budget.pid%TYPE,
 			        p_annee IN budget.annee%TYPE
			     	) RETURN NUMBER;

   

   PRAGMA restrict_references(f_calc_budget_propose_mo,wnds);
   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_budget_reserve
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget réservé pour une annee
   --              
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   -- Retour     : Montant du budget réservé
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_budget_reserve(
				p_pid   IN budget.pid%TYPE,
			        p_annee IN budget.annee%TYPE
			     	) RETURN NUMBER;
   
   PRAGMA restrict_references(f_calc_budget_reserve,wnds);

   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_budget_notifie
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget notifier pour une annee
   --              
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   -- Retour     : Montant calculé
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_budget_notifie(
				p_pid   IN budget.pid%TYPE,
			     	p_annee IN budget.annee%TYPE
			    	) RETURN NUMBER;
   
   PRAGMA restrict_references(f_calc_budget_notifie,wnds);
   
   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_budget_arb_notifie
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget arbitré notifié pour une annee
   --              
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   -- Retour     : Montant calculé
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_budget_arb_notifie(p_pid   IN budget.pid%TYPE,
				      p_annee IN budget.annee%TYPE
				) RETURN NUMBER;
   
   PRAGMA restrict_references(f_calc_budget_arb_notifie,wnds);

 -- ------------------------------------------------------------------------
   -- Nom        : f_calc_reestime
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le réestimé
   --              
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   -- Retour     : Montant Calculé
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_reestime(     p_pid   IN budget.pid%TYPE,
				 p_annee IN budget.annee%TYPE
				) RETURN NUMBER;
     
   PRAGMA restrict_references(f_calc_reestime,wnds);
   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_budget_conso
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget consommé de : Année courante ou  AN - 1 ou  AN - 2 ou AN - 3
   --              
   -- Paramètres : p_pid   		(IN) code projet
   --              p_indic_annee 	(IN) Indicateur de l'année à prendre en compte
   --							'0' --> Année en cour
   --							'1' --> Année -1
   --							'2' --> Année -2
   --							'3' --> Année -3
   -- Retour     : Montant calculé
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_budget_conso(
				p_pid         IN consomme.pid%TYPE,
				p_indic_annee IN VARCHAR2			-- CHAR(1)
				) RETURN NUMBER;
   
   PRAGMA restrict_references(f_calc_budget_conso,wnds);

   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_budget_conso_mois_cour
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul  budget consommé mois courant
   --              
   -- Paramètres : p_pid   		(IN) code projet
   -- Retour     : Montant calculé
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_budget_conso_mois_cour(
				p_pid   IN consomme.pid%TYPE
				) RETURN NUMBER;
   
   PRAGMA restrict_references(f_calc_budget_conso_mois_cour, wnds);

   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_totbudcons_depuis_creat
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul  budget consommé au total par un projet depuis sa création
   --              
   -- Paramètres : p_pid   		(IN) code projet
   -- Retour     : Montant calculé
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_totbudcons_depuis_creat(
				p_pid   IN consomme.pid%TYPE
				) RETURN NUMBER;
   
   PRAGMA restrict_references(f_calc_totbudcons_depuis_creat, wnds);

   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_fact_interne_decn1_fr
   -- Auteur     : Equipe SOPRA
   -- Decription : Facturation interne de decembre de l'année N - 1 en FRANC !!!
   --      		 pour un projet et une année donnés       
   -- Paramètres : p_pid   		(IN) code projet
   --              p_annee 		(IN) annee considérée
   -- Retour     : Montant calculé
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_fact_interne_decn1_fr(
				p_pid   IN stock_fi.pid%TYPE,
				p_annee IN NUMBER
				) RETURN NUMBER;
   
   PRAGMA restrict_references(f_calc_fact_interne_decn1_fr, wnds);

   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_fact_interne_annee_fr
   -- Auteur     : Equipe SOPRA
   -- Decription : Facturation interne (en FRANC !!!) de l'année pour un projet et une année donnés 
   --      		 pour un projet et une année donnés       
   -- Paramètres : p_pid   		(IN) code projet
   --              p_annee 		(IN) annee considérée
   -- Retour     : Montant calculé
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_fact_interne_annee_fr(
				p_pid   IN stock_fi.pid%TYPE,
				p_annee IN NUMBER
				) RETURN NUMBER;
   
   PRAGMA restrict_references(f_calc_fact_interne_annee_fr, wnds);

   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_immos
   -- Auteur     : PPR
   -- Decription : Immobilisations de l'année pour un projet et une année donnés 
   --      		       
   -- Paramètres : p_pid   		(IN) code projet
   --              p_annee 		(IN) annee considérée
   -- Retour     : Montant calculé en euros
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_immos (
				p_pid   IN stock_immo.pid%TYPE,
				p_annee IN NUMBER
				) RETURN NUMBER ;

   PRAGMA restrict_references(f_calc_immos, wnds);


END pack_verif_visuproj ;
/

CREATE OR REPLACE PACKAGE BODY pack_verif_visuproj  AS 
-- ---------------------------------------------------

-- ------------------------------------------------------------------------
--
-- Nom        : verif_visuproj
-- Auteur     : Equipe SOPRA 
-- Decription : Vérification des paramètres saisis pour l'état visuproj
-- Paramètres : 
--              p_pid (IN)			Code projet
--              p_userid      (IN) 		Code user BIP
--		    P_message OUT             Message de sortie
-- 
-- Remarque :  
--             
-- ------------------------------------------------------------------------   

     PROCEDURE verif_visuproj( 
                 p_pid 		IN  VARCHAR2,	     -- CHAR(4) 
		 p_userid 	IN  VARCHAR2,
                 P_message 	OUT VARCHAR2
                 ) IS

      l_message      	VARCHAR2(1024) 		:= '';	
      l_menutil   	VARCHAR2(255);
      l_clicode   	client_mo.clicode%TYPE;
      l_perimetre 	VARCHAR2(1000);
      l_bool      	boolean;
      l_num_exception 	NUMBER;

BEGIN

   BEGIN

	---------------------------------------------------------------------------------------------
	-- (1) Vérification existence Code ligne bip dans la table LIGNE_BIP
	---------------------------------------------------------------------------------------------
	IF ( pack_utile3A.f_verif_pid_ligne_bip(p_pid) = FALSE ) 
	THEN
		l_num_exception := pack_utile_numsg.nuexc_codligne_bip_inexiste;
            	pack_global.recuperer_message(l_num_exception , '%s1', p_pid, ' P_param6 ', l_message);   
		RAISE_APPLICATION_ERROR(-l_num_exception, l_message);
                                     
	END IF;

	p_message   := l_message;

   END;

END verif_visuproj; 

   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_budget_propose
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget proposé pour une annee
   --              
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   -- Retour     : Montant du budget proposé
   --	           
   -- 
   -- ------------------------------------------------------------------------
FUNCTION f_calc_budget_propose(
				p_pid   IN budget.pid%TYPE,
			        p_annee IN budget.annee%TYPE
			    	) RETURN NUMBER IS

   l_montant_res budget.bpmontme%TYPE := 0;

BEGIN

	BEGIN

		SELECT bpmontme
		INTO  l_montant_res
		FROM  budget 
		WHERE pid = p_pid
		AND   annee = p_annee;

		RETURN( NVL(l_montant_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN(0);
	 		WHEN OTHERS THEN
				l_montant_res  := 0;
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;


END f_calc_budget_propose;

 -- ------------------------------------------------------------------------

   -- Nom        : f_calc_budget_propose

   -- Auteur     : Equipe SOPRA

   -- Decription : calcul le budget proposé pour une annee

   --              

   -- Paramètres : p_pid   (IN) code projet

   --              p_annee (IN) annee du buget

   -- Retour     : Montant du budget proposé

   --	           

   -- 

   -- ------------------------------------------------------------------------

FUNCTION f_calc_budget_propose_mo(
				p_pid   IN budget.pid%TYPE,
			        p_annee IN budget.annee%TYPE
			    	) RETURN NUMBER IS
   l_montant_res budget.bpmontmo%TYPE := 0;
BEGIN

	BEGIN

		SELECT bpmontmo
		INTO  l_montant_res
		FROM  budget 
		WHERE pid = p_pid
		AND   annee = p_annee;
		RETURN( NVL(l_montant_res, 0) );

      	EXCEPTION

			WHEN NO_DATA_FOUND THEN

				RETURN(0);

	 		WHEN OTHERS THEN

				l_montant_res  := 0;
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);



	END;
END f_calc_budget_propose_mo;


   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_budget_reserve
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget proposé pour une annee
   --              
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   -- Retour     : Montant du budget proposé
   --	           
   -- 
   -- ------------------------------------------------------------------------
FUNCTION f_calc_budget_reserve(
				p_pid   IN budget.pid%TYPE,
			        p_annee IN budget.annee%TYPE
			     	) RETURN NUMBER IS

	l_montant_res budget.reserve%TYPE := 0;

BEGIN

	BEGIN

		SELECT reserve
		INTO  l_montant_res
		FROM  budget 
		WHERE pid = p_pid
		AND   annee = p_annee;

		RETURN( NVL(l_montant_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN(0);
	 		WHEN OTHERS THEN
				l_montant_res  := 0;
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;

END f_calc_budget_reserve;


   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_totbudcons_depuis_creat
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul  budget consommé au total par un projet depuis sa création
   --              
   -- Paramètres : p_pid   		(IN) code projet
   -- Retour     : Montant calculé
   -- 
   -- ------------------------------------------------------------------------
FUNCTION f_calc_totbudcons_depuis_creat(
				p_pid   IN consomme.pid%TYPE
			     	) RETURN NUMBER IS

	l_montant_res NUMBER(15, 2) := 0;

BEGIN

	BEGIN
	SELECT MAX(xcusag) 
	INTO l_montant_res
	FROM  consomme ,datdebex 
 	WHERE  pid=p_pid
	AND annee >= (TO_NUMBER(TO_CHAR(datdebex,'YYYY')) -2);
	
	RETURN( NVL(l_montant_res, 0) );
	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN(0);
	 		WHEN OTHERS THEN
				l_montant_res  := 0;
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;
	
END f_calc_totbudcons_depuis_creat;


   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_budget_notifie
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget notifier pour une annee
   --              
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   -- Retour     : Montant calculé
   -- 
   -- ------------------------------------------------------------------------
FUNCTION f_calc_budget_notifie(
				p_pid   IN budget.pid%TYPE,
			     	p_annee IN budget.annee%TYPE
			    	) RETURN NUMBER IS

	l_montant_res budget.bnmont%TYPE := 0;

BEGIN

	BEGIN

		SELECT bnmont
		INTO  l_montant_res
		FROM  budget
		WHERE pid = p_pid
		AND   annee = p_annee;

		RETURN( NVL(l_montant_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN(0);
	 		WHEN OTHERS THEN
				l_montant_res  := 0;
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;


END f_calc_budget_notifie;

  -- ------------------------------------------------------------------------
   -- Nom        : f_calc_budget_arb_notifie
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget arbitré notifié pour une annee
   --              
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   -- Retour     : Montant Calculé
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_budget_arb_notifie(p_pid   IN budget.pid%TYPE,
				      p_annee IN budget.annee%TYPE

				) RETURN NUMBER IS

	l_montant_res budget.anmont%TYPE := 0;

BEGIN

	BEGIN

		SELECT anmont
		INTO  l_montant_res
		FROM  budget 
		WHERE pid = p_pid
		AND   annee = p_annee;

		RETURN( NVL(l_montant_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN(0);
	 		WHEN OTHERS THEN
				l_montant_res  := 0;
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;

END f_calc_budget_arb_notifie;

 -- ------------------------------------------------------------------------
   -- Nom        : f_calc_reestime
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le réestimé
   --              
   -- Paramètres : p_pid   (IN) code projet
   --              p_annee (IN) annee du buget
   -- Retour     : Montant Calculé
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_reestime(p_pid   IN budget.pid%TYPE,
		   	    p_annee IN budget.annee%TYPE
				) RETURN NUMBER IS

	l_montant_res budget.reestime%TYPE := 0;

BEGIN

	BEGIN

		SELECT reestime
		INTO  l_montant_res
		FROM  budget 
		WHERE pid = p_pid
		AND   annee = p_annee;

		RETURN( NVL(l_montant_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN(0);
	 		WHEN OTHERS THEN
				l_montant_res  := 0;
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;

END f_calc_reestime;

   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_budget_conso
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul le budget consommé de année courante ou  AN - 1, AN - 2 , AN - 3
   --              
   -- Paramètres : p_pid   		(IN) code projet
   --              p_indic_annee 	(IN) Indicateur de l'année à prendre en compte
   --							'0' --> Année en cour
   --							'1' --> Année -1
   --							'2' --> Année -2
   --							'3' --> Année -3
   -- Retour     : Montant calculé
   -- 
   -- ------------------------------------------------------------------------
  FUNCTION f_calc_budget_conso(
				p_pid         IN consomme.pid%TYPE,
				p_indic_annee IN VARCHAR2			-- CHAR(1)
				) RETURN NUMBER IS

	l_montant_res consomme.cusag%TYPE := 0;

BEGIN

	BEGIN
		
		IF ( p_indic_annee = '0') THEN
			SELECT cusag
			INTO  l_montant_res
			FROM  consomme,datdebex 
			WHERE pid = p_pid
			AND annee = TO_NUMBER(TO_CHAR(datdebex,'YYYY'));
		ELSIF ( p_indic_annee = '1') THEN
			SELECT cusag
			INTO  l_montant_res
			FROM  consomme,datdebex 
			WHERE pid = p_pid
			AND annee = TO_NUMBER(TO_CHAR(ADD_MONTHS(datdebex,-12),'YYYY'));
		ELSIF ( p_indic_annee = '2') THEN
			SELECT cusag
			INTO  l_montant_res
			FROM  consomme,datdebex 
			WHERE pid = p_pid
			AND annee = TO_NUMBER(TO_CHAR(ADD_MONTHS(datdebex,-24),'YYYY'));
		ELSIF ( p_indic_annee = '3') THEN
			SELECT cusag
			INTO  l_montant_res
			FROM  consomme,datdebex 
			WHERE pid = p_pid
			AND annee = TO_NUMBER(TO_CHAR(ADD_MONTHS(datdebex,-36),'YYYY'));
		ELSE
			l_montant_res := 0;
		END IF;

		RETURN( NVL(l_montant_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN(0);
	 		WHEN OTHERS THEN
				l_montant_res  := 0;
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;

END f_calc_budget_conso;

   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_budget_conso_mois_cour
   -- Auteur     : Equipe SOPRA
   -- Decription : calcul  budget consommé mois courant
   --              
   -- Paramètres : p_pid   		(IN) code projet
   -- Retour     : Montant calculé
   -- 
   -- ------------------------------------------------------------------------
FUNCTION f_calc_budget_conso_mois_cour(
				p_pid   IN consomme.pid%TYPE
				) RETURN NUMBER IS
		l_pid consomme.pid%TYPE;
		l_montant_res consomme.xcusag%TYPE := 0;

BEGIN

	BEGIN
		SELECT factpid pid,SUM(cusag) xcusmois  INTO l_pid,l_montant_res FROM proplus,datdebex
		WHERE proplus.factpid=p_pid
		AND (qualif not in ('MO','GRA','IFO','STA','INT') OR qualif is null)
		AND trunc(proplus.cdeb,'MONTH')=trunc(datdebex.moismens,'MONTH')
	 	GROUP BY factpid;

		RETURN( NVL(l_montant_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN(0);
	 		WHEN OTHERS THEN
				l_montant_res  := 0;
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;

END  f_calc_budget_conso_mois_cour;


   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_fact_interne_decn1_fr
   -- Auteur     : Equipe SOPRA
   -- Decription : Facturation interne de decembre de l'année N - 1 en FRANC !!!
   --      		 pour un projet et une année donnés       
   -- Paramètres : p_pid   		(IN) code projet
   --              p_annee 		(IN) annee considérée
   -- Retour     : Montant calculé
   -- 
   -- ------------------------------------------------------------------------
--SEL PPM 58986 : retourne 0 : elle n est plus utilisee dans le traitement de rapport de visualisation de ligne
FUNCTION f_calc_fact_interne_decn1_fr(
				p_pid   IN stock_fi.pid%TYPE,
				p_annee IN NUMBER
				) RETURN NUMBER IS
	l_montant_res NUMBER(25, 2) := 0;

BEGIN

	BEGIN
		SELECT
			SUM(consoft) + SUM(consoenvimmo) + SUM(nconsoenvimmo)
		INTO
			l_montant_res
		FROM
			STOCK_FI
		WHERE
			pid=p_pid
		AND to_char(cdeb, 'MM/YYYY') = to_char('12/'||(p_annee-1));

		RETURN( NVL(l_montant_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN(0);
	 		WHEN OTHERS THEN
				l_montant_res  := 0;
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;

END f_calc_fact_interne_decn1_fr;

   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_fact_interne_annee_fr
   -- Auteur     : Equipe SOPRA
   -- Decription : Facturation interne (en FRANC !!!) de l'année pour un projet et une année donnés 
   --      		 pour un projet et une année donnés       
   -- Paramètres : p_pid   		(IN) code projet
   --              p_annee 		(IN) annee considérée
   -- Retour     : Montant calculé
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_fact_interne_annee_fr(
				p_pid   IN stock_fi.pid%TYPE,
				p_annee IN NUMBER
				) RETURN NUMBER IS

	l_montant_res NUMBER(25, 2) := 0;

BEGIN

	BEGIN
	
		SELECT
			SUM(consoft + consoenvimmo + nconsoenvimmo)
		INTO
			l_montant_res
		FROM
			STOCK_FI
		WHERE
			pid=p_pid;
		
		RETURN( NVL(l_montant_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN(0);
	 		WHEN OTHERS THEN
				l_montant_res  := 0;
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;

END f_calc_fact_interne_annee_fr;

   -- ------------------------------------------------------------------------
   -- Nom        : f_calc_immos
   -- Auteur     : PPR
   -- Decription : Immobilisations de l'année pour un projet et une année donnés 
   --      		       
   -- Paramètres : p_pid   		(IN) code projet
   --              p_annee 		(IN) annee considérée
   -- Retour     : Montant calculé en euros
   -- 
   -- ------------------------------------------------------------------------
   FUNCTION f_calc_immos (
				p_pid   IN stock_immo.pid%TYPE,
				p_annee IN NUMBER
				) RETURN NUMBER IS

	l_montant_res NUMBER(25, 2) := 0;

BEGIN

	BEGIN
	
		SELECT
			SUM(consoft)
		INTO
			l_montant_res
		FROM
			STOCK_IMMO
		WHERE
			pid=p_pid;
		
		RETURN( NVL(l_montant_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				RETURN(0);
	 		WHEN OTHERS THEN
				l_montant_res  := 0;
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;

END f_calc_immos;

END pack_verif_visuproj ;
/

