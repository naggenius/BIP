-- -------------------------------------------------------------------
-- pack_verif_reshist PL/SQL
--
-- equipe SOPRA (HT)
--
-- crée le 21/12/1999
-- modifie le 23/02/2000	MSA	Adaptation au concept d'historique
--					MSA   Deplacement de la procedure 'verif_reshist' dans pack_historique (histo.sql)
--	      24/06/2004	MMC     Ajout de procedure pour différencier les consommés absences
-- Package qui sert à la réalisation de l'état RESHIST
-- 04/04/2008  JAL : fiche 587 :  modif procédure  , si pas de cp trouvé , on recherche dernière  SITU existante
-- 02/04/2008  EVI  : fiche 638 : modif des regles d'absence pour SSII        
-- 03/10/2008 EVI   : fiche 690     
-- --------------------------------------------------------------------------

-- SET SERVEROUTPUT ON SIZE 1000000;

CREATE OR REPLACE PACKAGE     pack_verif_reshist  AS
-- ----------------------------------------------

   -- ------------------------------------------------------------------------
   --
   -- Nom        : f_conso_ress
   -- Auteur     : Equipe SOPRA (HT)
   -- Decription : Calcul du consommé d'une ressource pour le mois et année
   --              fourni en paramètres
   -- Paramètres :
   --              p_mois (IN)            Mois traité 'MM'
   --			 p_annee(IN)            Année traitée 'AAAA'
   --              p_divsecgrou (IN)      Code Dpt/Pole/Groupe
   --              p_tires (IN)           Identifiant ressource
   --              p_pid (IN)             Identifiant projet
   --              p_aist (IN)            Identifiant sous-tâche
   -- Retour     : Nbre de jours consommés de la ressource
   --
   -- Remarque :
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_conso_ress(
			    p_mois                IN VARCHAR2,
			    p_annee               IN VARCHAR2,
			    p_divsecgrou          IN proplus.divsecgrou%TYPE,
			    p_tires               IN proplus.tires%TYPE,
			    p_pid                 IN proplus.pid%TYPE,
			    p_aist                IN proplus.aist%TYPE
			   ) RETURN NUMBER;

   -- ------------------------------------------------------------------------
   --
   -- Nom        : f_nbjour_ouvre
   -- Auteur     : Equipe SOPRA (HT)
   -- Decription : Calcul du nbre de jours ouvrés pour le mois ('MM') de l' année ('AAAA')
   --              fourni en paramètres : Si l'année est NUL, on prend l'année de datdebex!!!
   --
   -- Paramètres :
   --			 p_annee(IN)            Année traitée 'AAAA'
   --              p_mois (IN)            Mois traité 'MM'
   -- Retour     : Nbre de jours ouvrés du mois p_mois de l'année p_année
   --
   -- Remarque :  Si p_annee est NUL, on prend l'année de datdebex!!!
   --          On retourne 0 si l'information recherchée ne se trouve pas dans la table
   --          CALENDRIER.
   -- ------------------------------------------------------------------------
   FUNCTION f_nbjour_ouvre( p_annee IN VARCHAR2, p_mois IN VARCHAR2 ) RETURN calendrier.cjours%TYPE ;

   -- ------------------------------------------------------------------------
   --
   -- Nom        : f_societe_ress
   -- Auteur     : ODu
   -- Decription : Recherche du code societe d'une ressource a une date
   --              donnee dans PROPLUS
   -- Paramètres :
   --              p_tires (IN)           Identifiant ressource
   --              p_date (IN)            'MM/AAAA'
   -- Retour     : Code societe
   --
   -- Remarque :
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_societe_ress( p_date IN VARCHAR2, p_tires IN INTEGER) RETURN VARCHAR2;

    -- ------------------------------------------------------------------------
   --
   -- Nom        : f_conso_ress_cp
   -- Auteur     : MMC
   -- Decription : Calcul du consommé d'une ressource pour le mois et année
   --              fourni en paramètres en fonction du CP
   -- Paramètres :
   --              p_mois (IN)            Mois traité 'MM'
   --		   p_annee(IN)            Année traitée 'AAAA'
   --              p_divsecgrou (IN)      Code Dpt/Pole/Groupe
   --              p_tires (IN)           Identifiant ressource
   --              p_pid (IN)             Identifiant projet
   --              p_aist (IN)            Identifiant sous-tâche
   -- Retour     : Nbre de jours consommés de la ressource
   -- ------------------------------------------------------------------------
   FUNCTION  f_conso_ress_cp(
			    p_mois                IN VARCHAR2,
			    p_annee               IN VARCHAR2,
			    p_divsecgrou          IN proplus.divsecgrou%TYPE,
			    p_cpident IN proplus.cpident%TYPE,
			    p_tires               IN proplus.tires%TYPE,
			    p_pid                 IN proplus.pid%TYPE,
			    p_aist                IN proplus.aist%TYPE
			    ) RETURN NUMBER ;

 -- ------------------------------------------------------------------------
   --
   -- Nom        : f_conso_abs
   -- Auteur     : MMC
   -- Decription : Calcul du consommé d'une ressource pour le mois pour les lignes de type absence
   -- Paramètres :
   --              p_mois (IN)            Mois traité 'MM'
   --		   p_divsecgrou (IN)      Code Dpt/Pole/Groupe
   --              p_tires (IN)           Identifiant ressource
   --              p_pid (IN)             Identifiant projet
   --              p_aist (IN)            Identifiant sous-tâche
   -- Retour     : Nbre de jours consommés de la ressource
   -- ------------------------------------------------------------------------
   FUNCTION  f_conso_abs(
			    p_mois                IN VARCHAR2,
			    p_annee               IN VARCHAR2,
			    p_divsecgrou          IN proplus.divsecgrou%TYPE,
			    p_tires               IN proplus.tires%TYPE,
			    p_pid                 IN proplus.pid%TYPE,
			    p_aist                IN proplus.aist%TYPE
			    ) RETURN NUMBER ;

    FUNCTION  f_conso_mois(
			    p_mois                IN VARCHAR2,		    
			    p_ident               IN cons_sstache_res_mois.ident%TYPE
			    ) RETURN NUMBER ;


PRAGMA restrict_references(f_conso_ress, WNDS);
PRAGMA restrict_references(f_nbjour_ouvre, WNDS);
PRAGMA restrict_references(f_societe_ress, WNDS);
PRAGMA restrict_references(f_conso_ress_cp, WNDS);


END pack_verif_reshist ;
/


CREATE OR REPLACE PACKAGE BODY     pack_verif_reshist  AS
-- ---------------------------------------------------


-------------------------------------------------------------------
--
------------------------------------------------------------------

FUNCTION f_conso_ress(
			    p_mois                IN VARCHAR2,
			    p_annee               IN VARCHAR2,
			    p_divsecgrou          IN proplus.divsecgrou%TYPE,
			    p_tires               IN proplus.tires%TYPE,
			    p_pid                 IN proplus.pid%TYPE,
			    p_aist                IN proplus.aist%TYPE
			   ) RETURN NUMBER IS
      l_conso_res NUMBER(15, 2) := 0 ;
	l_derjour_mois VARCHAR2(2) := '31';
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
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);
	END;

	BEGIN
            l_derjour_mois := TO_CHAR( LAST_DAY(TO_DATE('01' || '/' || p_mois  || '/' || l_annee_traite, 'DD/MM/YYYY')), 'DD' );

		IF ( p_aist IS NOT NULL)
		THEN
		  SELECT SUM(cusag)
		  INTO	l_conso_res
		  FROM  proplus
	 	  WHERE
			divsecgrou = p_divsecgrou
			AND tires  = p_tires
			AND pid    = p_pid
			AND aist   = p_aist
			AND cdeb BETWEEN TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY')
						     AND TO_DATE(l_derjour_mois || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY');
		ELSE
		  SELECT SUM(cusag)
		  INTO	l_conso_res
		  FROM  proplus
	 	  WHERE
			divsecgrou = p_divsecgrou
			AND tires  = p_tires
			AND pid    = p_pid
			AND aist   IS NULL
			AND cdeb BETWEEN TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY')
						     AND TO_DATE(l_derjour_mois || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY');

		END IF;
		/*****************************************************************************************
		DBMS_OUTPUT.PUT_LINE('f_conso_ress.mois: '|| p_mois);
		DBMS_OUTPUT.PUT_LINE('f_conso_ress.Annee: '|| l_annee_traite);
		DBMS_OUTPUT.PUT_LINE('f_conso_ress.derjour_mois: '|| l_derjour_mois);
		DBMS_OUTPUT.PUT_LINE('f_conso_ress.DPG: '|| p_divsecgrou);
		DBMS_OUTPUT.PUT_LINE('f_conso_ress.Tires: '|| p_tires);
		DBMS_OUTPUT.PUT_LINE('f_conso_ress.pid: '|| p_pid);
		DBMS_OUTPUT.PUT_LINE('f_conso_ress.ss_tache: '|| p_aist);
      	DBMS_OUTPUT.PUT_LINE('f_conso_ress.l_conso_res  : '|| l_conso_res );
            *****************************************************************************************/

		RETURN( NVL(l_conso_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				l_conso_res  := 0;
				RETURN (0);
	 		WHEN OTHERS THEN
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;

END f_conso_ress;




-------------------------------------------------------------------
--
------------------------------------------------------------------

FUNCTION f_nbjour_ouvre(
			    p_annee    IN VARCHAR2,
			    p_mois     IN VARCHAR2
			   ) RETURN calendrier.cjours%TYPE  IS
      l_nbjour_ouvre calendrier.cjours%TYPE := 0 ;
      l_annee_traite VARCHAR2(4) := p_annee ;

BEGIN

	BEGIN
		-----------------------------------------------------------------------------
		-- Determination de l'année à traiter si p_annee est nul !
		-----------------------------------------------------------------------------
            IF ( p_annee IS NULL )
		THEN
			SELECT TO_CHAR(datdebex, 'YYYY') INTO l_annee_traite FROM datdebex;
		END IF;

		EXCEPTION
	 		WHEN OTHERS THEN
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);
	END;

	BEGIN
		SELECT cjours
		INTO   l_nbjour_ouvre
		FROM   calendrier
		WHERE  calanmois = TRUNC(TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY'), 'MONTH') ;

		RETURN( NVL(l_nbjour_ouvre , 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				l_nbjour_ouvre   := 0;
				RETURN(0);
	 		WHEN OTHERS THEN
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);
	END;

END f_nbjour_ouvre;




-------------------------------------------------------------------
--
------------------------------------------------------------------

   FUNCTION f_societe_ress( p_date IN VARCHAR2, p_tires IN INTEGER) RETURN VARCHAR2 IS
	l_societe	proplus.societe%TYPE;
	l_date		DATE;
   BEGIN
	l_date:=TO_DATE('01/'||p_date, 'DD/MM/YYYY');

	BEGIN
		SELECT soccode
			INTO l_societe
			FROM situ_ress
			WHERE ident=p_tires
			AND datsitu<=l_date
			AND (datdep>=l_date OR datdep IS NULL);
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
-- si rien trouve on prend la derniere situation de la ressource
			SELECT soccode
				INTO l_societe
				FROM situ_ress
				WHERE ident=p_tires
				AND datsitu=(SELECT MAX(datsitu) FROM situ_ress WHERE ident=p_tires);
		WHEN OTHERS THEN
			RAISE;
	END;

	RETURN l_societe;
   END f_societe_ress;

---
---
FUNCTION  f_conso_ress_cp(
			    p_mois                IN VARCHAR2,
			    p_annee               IN VARCHAR2,
			    p_divsecgrou          IN proplus.divsecgrou%TYPE,
			    p_cpident IN proplus.cpident%TYPE,
			    p_tires               IN proplus.tires%TYPE,
			    p_pid                 IN proplus.pid%TYPE,
			    p_aist                IN proplus.aist%TYPE
			    ) RETURN NUMBER IS

        l_conso_res NUMBER(15, 2) := 0 ;
	l_derjour_mois VARCHAR2(2) := '31';
	l_annee_traite VARCHAR2(4) := p_annee ;
	l_mois_annee_datdebex VARCHAR2(7) := '12/2000';  /* MM/AAAA */
	l_mois_datdebex VARCHAR2(2) := '12';
	l_cpident VARCHAR2(5);


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
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);
	END;

	BEGIN
            l_derjour_mois := TO_CHAR( LAST_DAY(TO_DATE('01' || '/' || p_mois  || '/' || l_annee_traite, 'DD/MM/YYYY')), 'DD' );
		BEGIN
		-- ON recupere le CP
			SELECT DISTINCT sr.cpident INTO l_cpident
			FROM situ_ress sr,proplus p
			WHERE p.tires=sr.ident
			AND p.tires= p_tires
			AND sr.datsitu <= TO_DATE(l_derjour_mois || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY')
			AND ( sr.datdep >= TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY')
			OR sr.datdep IS NULL)
			;
			-- Fiche 587 : si pas trouvé on recherche la dernière situation existante
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
			 -- si rien trouve on prend la derniere situation de la ressource
			SELECT DISTINCT sr.cpident INTO l_cpident
			FROM SITU_RESS sr,PROPLUS p
			WHERE p.tires=sr.ident
			AND p.tires= p_tires
			AND datsitu=(SELECT MAX(datsitu) FROM SITU_RESS WHERE ident=p_tires);
			WHEN OTHERS THEN
			RAISE
			;
		END ;

		IF ( p_aist IS NOT NULL)
		THEN
			IF l_cpident <> p_cpident
			THEN l_conso_res :=null;
			ELSE
		  SELECT SUM(cusag)
		  INTO	l_conso_res
		  FROM  proplus p
	 	  WHERE
			divsecgrou = p_divsecgrou
			AND tires  = p_tires
			AND pid    = p_pid
			AND aist   = p_aist
			AND cdeb BETWEEN TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY')
			AND TO_DATE(l_derjour_mois || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY');
			END IF;

		ELSE
			IF l_cpident <> p_cpident
			THEN l_conso_res :=null;
			ELSE
		  SELECT SUM(cusag)
		  INTO	l_conso_res
		  FROM  proplus p
	 	  WHERE
			divsecgrou = p_divsecgrou
			AND tires  = p_tires
			AND pid    = p_pid
			AND aist   IS NULL
			AND cdeb BETWEEN TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY')
			AND TO_DATE(l_derjour_mois || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY');
			END IF;
		END IF;

		RETURN( NVL(l_conso_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				l_conso_res  := 0;
				RETURN (0);
	 		WHEN OTHERS THEN
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;

END f_conso_ress_cp;

FUNCTION f_conso_abs(
			    p_mois                IN VARCHAR2,
			    p_annee               IN VARCHAR2,
			    p_divsecgrou          IN proplus.divsecgrou%TYPE,
			    p_tires               IN proplus.tires%TYPE,
			    p_pid                 IN proplus.pid%TYPE,
			    p_aist                IN proplus.aist%TYPE
			   ) RETURN NUMBER IS
l_conso_res_sg NUMBER(15, 2) := 0 ;
l_conso_res_ssii NUMBER(15, 2) := 0 ;
l_res NUMBER(15, 2) := 0 ;
l_derjour_mois VARCHAR2(2) := '31';
l_annee_traite VARCHAR2(4) := p_annee ;
l_societe VARCHAR2(4);

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
            l_derjour_mois := TO_CHAR( LAST_DAY(TO_DATE('01' || '/' || p_mois  || '/' || l_annee_traite, 'DD/MM/YYYY')), 'DD' );
		--total absences  non facturees pour les SG
		  SELECT NVL(SUM(p.cusag),0)
		  INTO	l_conso_res_sg
		  FROM  proplus	p,ligne_bip lb
	 	  WHERE
			p.divsecgrou = p_divsecgrou
			AND p.tires  = p_tires
			AND p.pid    = lb.pid
			AND lb.typproj=7
			AND p.societe='SG..'
			AND p.cdeb BETWEEN TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY')
			     AND TO_DATE(l_derjour_mois || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY');

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				l_conso_res_sg  := 0;
			WHEN OTHERS THEN
	   			--raise_application_error(-pack_utile_numsg.nuexc_others, SQLERRM);
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);
	END;

	BEGIN
            l_derjour_mois := TO_CHAR( LAST_DAY(TO_DATE('01' || '/' || p_mois  || '/' || l_annee_traite, 'DD/MM/YYYY')), 'DD' );
		--total absences  non facturees pour les SSII
		  SELECT NVl(SUM(p.cusag),0)
		  INTO	l_conso_res_ssii
		  FROM  proplus	p,ligne_bip lb
	 	  WHERE
			p.divsecgrou = p_divsecgrou
			AND p.tires  = p_tires
			AND p.pid    = lb.pid
			AND lb.typproj=7
			AND p.societe <> 'SG..'
			AND (p.aist IN ('FORMAT','ABSDIV','CONGES','MOBILI','RTT') OR p.aist IS NULL)
			AND p.cdeb BETWEEN TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY')
			     AND TO_DATE(l_derjour_mois || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY');

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				l_conso_res_ssii  := 0;
			WHEN OTHERS THEN
	   			--raise_application_error(-pack_utile_numsg.nuexc_others, SQLERRM);
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);
	END;




	l_res := l_conso_res_ssii + l_conso_res_sg;
	RETURN( NVL(l_res, 0) );



END f_conso_abs;


FUNCTION  f_conso_mois(
			    p_mois                IN VARCHAR2,
			    p_ident              IN cons_sstache_res_mois.ident%TYPE
			    ) RETURN NUMBER IS

l_conso NUMBER(15, 2) := 0 ;
l_ident RESSOURCE.ident%TYPE;
l_derjour_mois VARCHAR2(2) := '31';
l_annee_traite VARCHAR2(4) := '';

l_mois_annee_datdebex VARCHAR2(7) := '12/2000';  /* MM/AAAA */
l_mois_datdebex VARCHAR2(2) := '12';


BEGIN

	BEGIN
		-----------------------------------------------------------------------------
		-- Determination de l'année à traiter si p_annee est nul !
		-----------------------------------------------------------------------------
          --  IF ( p_annee IS NULL )
		--THEN
			SELECT TO_CHAR(moismens, 'MM/YYYY') INTO l_mois_annee_datdebex  FROM datdebex;

			l_annee_traite := SUBSTR(l_mois_annee_datdebex, 4, 4);
			l_mois_datdebex := SUBSTR(l_mois_annee_datdebex, 1, 2);

			---------------------------------------------------------------
			-- Dans ce cas, on ne fera les calculs que si p_mois (mois traité)
			-- <= l_mois_datdebex (mois de datdebex)
			-- Sinon, on retourne 0 tout de suite
			----------------------------------------------------------------
			IF ( l_mois_datdebex < p_mois )
			THEN
				RETURN (-2);
			END IF;
		--END IF;

		EXCEPTION
	 		WHEN OTHERS THEN
	   			--raise_application_error(-pack_utile_numsg.nuexc_others, SQLERRM);
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);
	END;
    
    -- On verifie que pour le mois données la ressource possede une situation valide
    BEGIN
        SELECT s.ident INTO l_ident FROM SITU_RESS s
        WHERE s.ident=p_ident
                AND s.datsitu <= TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY')
                AND (s.datdep >= TO_DATE('15' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY') or s.datdep is null );
                
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        -- Dans le cas ou il n'y as pa de situation valide pour la ressource on renvoi -1
                        l_conso := -1;
                        RETURN( NVL(l_conso, 0) );
                        WHEN OTHERS THEN
	   			--raise_application_error(-pack_utile_numsg.nuexc_others, SQLERRM);
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);
        
    
    END;


	BEGIN
            l_derjour_mois := TO_CHAR( LAST_DAY(TO_DATE('01' || '/' || p_mois  || '/' || l_annee_traite, 'DD/MM/YYYY')), 'DD' );
		--total absences  non facturees pour les SG
		  SELECT NVL(SUM(c.cusag),0)
		  INTO	l_conso
		  FROM  cons_sstache_res_mois c
	 	  WHERE c.ident= p_ident
				AND c.cdeb BETWEEN TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY')
			     AND TO_DATE(l_derjour_mois || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY');

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				l_conso  := 0;
			WHEN OTHERS THEN
	   			--raise_application_error(-pack_utile_numsg.nuexc_others, SQLERRM);
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);
	END;


	RETURN( NVL(l_conso, 0) );
                
END f_conso_mois;

END pack_verif_reshist ;
/



