-- -------------------------------------------------------------------
-- pack_verif_prohist PL/SQL
--
-- equipe SOPRA (HT)
--
-- crée le 04/01/200
-- modifie le 23/02/2000	MSA	Adaptation au concept d'historique
--					MSA   Deplacement de la procedure 'verif_prohist' dans pack_historique (histo.sql)
--
-- Package qui sert à la réalisation de l'état prohist
--                   
-- Modifié le 23/12/2008 par EVI: TD 728: correction prise en compte des ressources non facturé
-- -------------------------------------------------------------------

-- SET SERVEROUTPUT ON SIZE 1000000;

CREATE OR REPLACE PACKAGE pack_verif_prohist  AS
-- ----------------------------------------------

   -- ------------------------------------------------------------------------
   --
   -- Nom         : f_conso_ress
   -- Auteur      : Equipe SOPRA (HT)
   -- Description : Calcul du consommé d'une ressource pour le mois et année
   --              fourni en paramètres
   -- Paramètres  :
   --               p_mois (IN)            Mois traité 'MM'
   --			  p_annee(IN)            Année traitée 'AAAA'
   --               p_factpdsg (IN)        Code Dpt/Pole/Groupe Projet principal
   --               p_factpid (IN)         Code Projet principal
   --               p_pdsg (IN)            Code Dpt/Pole/Groupe projet associé au Projet principal
   --               p_pid (IN)             Code Projet associé au Projet principal
   --               p_tires (IN)           Identifiant ressource
   --               p_qualif (IN)          Qualification ressource
   -- Retour      : Nbre de jours consommés de la ressource
   --
   -- Remarque  :
   --
   -- ------------------------------------------------------------------------
   FUNCTION f_conso_ress(
			    p_mois                IN VARCHAR2,
			    p_annee               IN VARCHAR2,
			    p_factpdsg            IN proplus.factpdsg%TYPE,
			    p_factpid		  IN proplus.factpid%TYPE,
			    p_pdsg                IN proplus.pdsg%TYPE,
			    p_pid                 IN proplus.pid%TYPE,
			    p_tires               IN proplus.tires%TYPE,
			    p_qualif              IN proplus.qualif%TYPE
			   ) RETURN NUMBER;

 PRAGMA restrict_references(f_conso_ress, WNDS);

END pack_verif_prohist ;
/


CREATE OR REPLACE PACKAGE BODY     pack_verif_prohist  AS
-- ---------------------------------------------------



FUNCTION f_conso_ress(
			    p_mois                IN VARCHAR2,
			    p_annee               IN VARCHAR2,
			    p_factpdsg            IN proplus.factpdsg%TYPE,
			    p_factpid		  IN proplus.factpid%TYPE,
			    p_pdsg                IN proplus.pdsg%TYPE,
			    p_pid                 IN proplus.pid%TYPE,
			    p_tires               IN proplus.tires%TYPE,
			    p_qualif              IN proplus.qualif%TYPE
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
	   			--raise_application_error(-pack_utile_numsg.nuexc_others, SQLERRM);
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);
	END;

	BEGIN
            l_derjour_mois := TO_CHAR( LAST_DAY(TO_DATE('01' || '/' || p_mois  || '/' || l_annee_traite, 'DD/MM/YYYY')), 'DD' );

		IF ( (p_qualif = 'GRA') OR  (p_qualif = 'MO') OR  (p_qualif = 'IFO') OR  (p_qualif = 'INT') OR  (p_qualif = 'STA'))
		THEN
		  	SELECT SUM(cusag)
		  	INTO	l_conso_res
		  	FROM  proplus
	 	  	WHERE
				factpdsg 	= p_factpdsg
				AND factpid 	= p_factpid
				AND pdsg	= p_pdsg
				AND pid		= p_pid
				AND tires	= p_tires
				AND qualif	= p_qualif
				AND cdeb BETWEEN TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY')
				AND TO_DATE(l_derjour_mois || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY');
		ELSE
		  	SELECT SUM(cusag)
		  	INTO	l_conso_res
		  	FROM  proplus
	 	  	WHERE
				factpdsg 	= p_factpdsg
				AND factpid 	= p_factpid
				AND pdsg	= p_pdsg
				AND pid		= p_pid
				AND tires	= p_tires
				AND ( (qualif NOT IN ('GRA', 'MO','IFO','INT','STA')) OR (qualif IS NULL) )
				AND cdeb BETWEEN TO_DATE('01' || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY')
				AND TO_DATE(l_derjour_mois || '/' || p_mois || '/' || l_annee_traite, 'DD/MM/YYYY');

		END IF;

		RETURN( NVL(l_conso_res, 0) );

      	EXCEPTION
			WHEN NO_DATA_FOUND THEN
				l_conso_res  := 0;
				RETURN( 0 );
	 		WHEN OTHERS THEN
				l_conso_res  := 0;
	   			--raise_application_error(-pack_utile_numsg.nuexc_others, SQLERRM);
	   			RAISE_APPLICATION_ERROR(-20997, SQLERRM);

	END;

END f_conso_ress;


END pack_verif_prohist ;
/


