--------------------------------------------------------
--  Fichier créé - lundi-octobre-10-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PACK_SUIVI_FINANCIER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "BIP"."PACK_SUIVI_FINANCIER" IS
   -- Fonction qui retourne les consommés de l'année n-1
   FUNCTION get_conso_m1(p_pid		VARCHAR2,
		      	 p_colonne	VARCHAR2,
		      	 p_annee	NUMBER)
	RETURN NUMBER;

   -- Fonction qui retourne les consommés des années avant n-1
   FUNCTION get_conso_avm1(	p_pid		VARCHAR2,
		      		p_colonne	VARCHAR2,
		      		p_annee		NUMBER)
	RETURN NUMBER;
END pack_suivi_financier;

 

/
--------------------------------------------------------
--  DDL for Package Body PACK_SUIVI_FINANCIER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "BIP"."PACK_SUIVI_FINANCIER" AS

-- Fonction qui retourne les consommés de l'année n-1
FUNCTION get_conso_m1(p_pid	VARCHAR2,
		      p_colonne	VARCHAR2,
		      p_annee	NUMBER)
	RETURN NUMBER IS

l_annee_1 NUMBER := 0;

BEGIN
	SELECT SUM(DECODE(p_colonne,
			'ftsg', ftsg,
			'ftssii', ftssii,
			'envsg', envsg,
			'envssii', envssii,
			 0))
	INTO l_annee_1
	FROM cumul_conso
	WHERE pid=p_pid
	  AND annee = p_annee - 1;

	RETURN NVL(l_annee_1, 0);
END get_conso_m1;


-- Fonction qui retourne les consommés des années avant n-1
FUNCTION get_conso_avm1(p_pid		VARCHAR2,
		      	p_colonne	VARCHAR2,
		      	p_annee		NUMBER)
	RETURN NUMBER IS

l_annee_av NUMBER := 0;

BEGIN
	SELECT SUM(DECODE(p_colonne,
			'ftsg', ftsg,
			'ftssii', ftssii,
			'envsg', envsg,
			'envssii', envssii,
			 0))
	INTO l_annee_av
	FROM cumul_conso
	WHERE pid=p_pid
	  AND annee < (p_annee - 1);

	RETURN NVL(l_annee_av, 0);
END get_conso_avm1;


END pack_suivi_financier;


/
