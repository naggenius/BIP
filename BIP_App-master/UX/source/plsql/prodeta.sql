-- -------------------------------------------------------------------
-- pack_verif_prodeta PL/SQL
--
-- equipe SOPRA (HT)
--
-- crée le 11/01/2000
-- modifie le 23/02/2000	MSA	Adaptation au concept d'historique
--					MSA   Deplacement de la procedure 'verif_prodeta' dans pack_historique (histo.sql)
--
-- Package qui sert à la réalisation de l'état prodeta
--                   
-- -------------------------------------------------------------------

 --SET SERVEROUTPUT ON SIZE 1000000;

CREATE OR REPLACE PACKAGE pack_verif_prodeta  AS
-- ----------------------------------------------


   -- ------------------------------------------------------------------------
   --
   -- Nom        : f_conso_ress
   -- Auteur     : Equipe SOPRA (HT)
   -- Decription : Calcul du consommé d'une ressource pour le mois, l'année, le projet, l'étape, 
   --              la tâche, la sous-tâche et la ressource fournis en paramètres
   -- Paramètres : 
   --              p_mois (IN)            Mois traité 'MM'
   --			 p_annee(IN)            Année traitée 'AAAA'
   --              p_pid (IN)             Code Projet 
   --              p_ecet (IN)            N° Etape 
   --              p_acta (IN)            N° Tache 
   --              p_acst (IN)            N° Sous-Tache 
   --              p_ident (IN)           Identifiant ressource
   -- Retour     : Nbre de jours consommés de la ressource
   -- 
   -- Remarque :  Utilisation de la table cons_sstache_res_mois
   --             
   -- ------------------------------------------------------------------------   
   FUNCTION f_conso_ress(
			    p_mois                IN VARCHAR2,
			    p_annee               IN VARCHAR2,
			    p_pid		  IN cons_sstache_res_mois.pid%TYPE,
			    p_ecet                IN cons_sstache_res_mois.ecet%TYPE,
			    p_acta                IN cons_sstache_res_mois.acta%TYPE,
			    p_acst                IN cons_sstache_res_mois.acst%TYPE,
			    p_ident               IN cons_sstache_res_mois.ident%TYPE
			   ) RETURN NUMBER;

FUNCTION  f_conso_ress_qualif(
			    p_mois                IN VARCHAR2,
			    p_annee               IN VARCHAR2,
			    p_pid		  IN cons_sstache_res_mois.pid%TYPE,
			    p_ecet                IN cons_sstache_res_mois.ecet%TYPE,
			    p_acta                IN cons_sstache_res_mois.acta%TYPE,
			    p_acst                IN cons_sstache_res_mois.acst%TYPE,
			    p_ident               IN cons_sstache_res_mois.ident%TYPE,
			    p_qualif              IN proplus.qualif%TYPE
			    ) RETURN NUMBER ;

-----------------------------------------------------------------------------
-- Différents PRAGMA
-----------------------------------------------------------------------------  
PRAGMA restrict_references(f_conso_ress, WNDS);
PRAGMA restrict_references(f_conso_ress_qualif, WNDS);


END pack_verif_prodeta ;
/

CREATE OR REPLACE PACKAGE BODY pack_verif_prodeta  AS 
-- ---------------------------------------------------



   --*************************************************************************
   --
   -- Nom        : f_conso_ress
   -- Auteur     : Equipe SOPRA (HT)
   -- Decription : Calcul du consommé d'une ressource pour le mois, l'année, le projet, l'étape, 
   --              la tâche, la sous-tâche et la ressource fournis en paramètres
   -- Paramètres : 
   --              p_mois (IN)            Mois traité 'MM'
   --			 p_annee(IN)            Année traitée 'AAAA'
   --              p_pid (IN)             Code Projet 
   --              p_ecet (IN)            N° Etape 
   --              p_acta (IN)            N° Tache 
   --              p_acst (IN)            N° Sous-Tache 
   --              p_ident (IN)           Identifiant ressource
   -- Retour     : Nbre de jours consommés de la ressource
   -- 
   -- Remarque :  Utilisation de la table cons_sstache_res_mois
   --             
   --*************************************************************************
   FUNCTION f_conso_ress(
			    p_mois                IN VARCHAR2,
			    p_annee               IN VARCHAR2,
			    p_pid		        IN cons_sstache_res_mois.pid%TYPE,
			    p_ecet                IN cons_sstache_res_mois.ecet%TYPE,
			    p_acta                IN cons_sstache_res_mois.acta%TYPE,
			    p_acst                IN cons_sstache_res_mois.acst%TYPE,
			    p_ident               IN cons_sstache_res_mois.ident%TYPE
			   ) RETURN NUMBER IS
      l_conso_res cons_sstache_res_mois.cusag%TYPE := 0 ;
	l_annee_traite VARCHAR2(4) := p_annee ;

	l_mois_annee_datdebex VARCHAR2(7) := '12/2000';  /* MM/AAAA */
	l_mois_datdebex VARCHAR2(2) := '12';


BEGIN

	BEGIN

		-----------------------------------------------------------------------------
		-- Determination de l'année à traiter si p_annee est nul !
		-----------------------------------------------------------------------------
            IF ( p_annee IS NULL )
		THEN
			SELECT TO_CHAR(cmensuelle, 'MM/YYYY') INTO l_mois_annee_datdebex  FROM datdebex;
			
			l_annee_traite := SUBSTR(l_mois_annee_datdebex, 4, 4);
			l_mois_datdebex := SUBSTR(l_mois_annee_datdebex, 1, 2);

			---------------------------------------------------------------
			-- Dans ce cas, on ne fera les calculs que si p_mois (mois traité) 
			-- <= l_mois_datdebex (mois de datdebex)
			-- Sinon, on retourne 0 tout de suite
			----------------------------------------------------------------
			IF ( l_mois_datdebex < p_mois )
			THEN
				RETURN (0);
			END IF;
		END IF;
		
		EXCEPTION
	 		WHEN OTHERS THEN
	   			--raise_application_error(-pack_utile_numsg.nuexc_others, SQLERRM);
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);
	END;

	BEGIN
		  SELECT 	cusag 
		  INTO	l_conso_res 
		  FROM  	cons_sstache_res_mois		 
	 	  WHERE
				pid 		= p_pid
				AND ecet	= p_ecet
				AND acta	= p_acta
				AND acst	= p_acst
				AND ident	= p_ident
				AND cdeb 	= TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY'); 
		RETURN( NVL(l_conso_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				l_conso_res  := 0;
				RETURN(0);
	 		WHEN OTHERS THEN
				l_conso_res  := 0;
	   			--raise_application_error(-pack_utile_numsg.nuexc_others, SQLERRM);
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;

END f_conso_ress;


---
---
FUNCTION  f_conso_ress_qualif(
			    p_mois                IN VARCHAR2,
			    p_annee               IN VARCHAR2,
			    p_pid		  IN cons_sstache_res_mois.pid%TYPE,
			    p_ecet                IN cons_sstache_res_mois.ecet%TYPE,
			    p_acta                IN cons_sstache_res_mois.acta%TYPE,
			    p_acst                IN cons_sstache_res_mois.acst%TYPE,
			    p_ident               IN cons_sstache_res_mois.ident%TYPE,
			    p_qualif              IN proplus.qualif%TYPE
			    ) RETURN NUMBER IS 
			    
        l_conso_res NUMBER(15, 2) := 0 ;
	l_derjour_mois VARCHAR2(2) := '31';
	l_annee_traite VARCHAR2(4) := p_annee ;
	l_mois_annee_datdebex VARCHAR2(7) := '12/2000';  /* MM/AAAA */
	l_mois_datdebex VARCHAR2(2) := '12';
	l_qualif proplus.qualif%TYPE;


BEGIN

	BEGIN
		-----------------------------------------------------------------------------
		-- Determination de l'année à traiter si p_annee est nul !
		-----------------------------------------------------------------------------
            IF ( p_annee IS NULL )
		THEN
			SELECT TO_CHAR(cmensuelle, 'MM/YYYY') INTO l_mois_annee_datdebex  FROM datdebex;
			
			l_annee_traite := SUBSTR(l_mois_annee_datdebex, 4, 4);
			l_mois_datdebex := SUBSTR(l_mois_annee_datdebex, 1, 2);

			---------------------------------------------------------------
			-- Dans ce cas, on ne fera les calculs que si p_mois (mois traité) 
			-- <= l_mois_datdebex (mois de datdebex)
			-- Sinon, on retourne 0 tout de suite
			----------------------------------------------------------------
			IF ( l_mois_datdebex < p_mois )
			THEN
				RETURN (0);
			END IF;
		END IF;
		
		EXCEPTION
	 		WHEN OTHERS THEN
	   			--raise_application_error(-pack_utile_numsg.nuexc_others, SQLERRM);
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);
	END;

	BEGIN
l_derjour_mois := TO_CHAR( LAST_DAY(TO_DATE('01' || '/' || p_mois  ||'/'||l_annee_traite,'DD/MM/YYYY')),'DD');
		
		-- ON recupere la qualif
			SELECT DISTINCT sr.prestation INTO l_qualif
			FROM situ_ress_full sr,cons_sstache_res c
			WHERE c.ident=sr.ident
			AND c.ident= p_ident
			AND sr.datsitu <= TO_DATE(l_derjour_mois || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY')
			AND ( sr.datdep >= TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY')
			OR sr.datdep IS NULL)
			;
		
	
		IF l_qualif <> p_qualif
			THEN l_conso_res :=null;	
		ELSE 					
		   	SELECT 	cusag 
		  	INTO	l_conso_res 
		  	FROM  	cons_sstache_res_mois		 
	 	  	WHERE
				pid 		= p_pid
				AND ecet	= p_ecet
				AND acta	= p_acta
				AND acst	= p_acst
				AND ident	= p_ident
				AND cdeb 	= TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY'); 
		END IF;

		RETURN( NVL(l_conso_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				l_conso_res  := 0;
				RETURN (0);
	 		WHEN OTHERS THEN
	   			--raise_application_error(-pack_utile_numsg.nuexc_others, SQLERRM);
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;

END f_conso_ress_qualif;


END pack_verif_prodeta ;
/

