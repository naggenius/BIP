-- extraction x_consossii.rdf
-- package pack_x_consossii
-- Crée par NBM le 28/08/2003

CREATE OR REPLACE PACKAGE pack_x_consossii AS
-- ******************************************************************************
-- Fonction qui récupère le top ressource
-- *******************************************************************************
   FUNCTION getTop_ressource( p_last_month		IN NUMBER,
					p_mois_preced		IN NUMBER,
					p_cle_contrat		IN VARCHAR2,
					p_date_fin_contrat	IN DATE
				    ) RETURN CHAR ;
-- ******************************************************************************
-- Fonction qui récupère la date de fin d'utilisation de la ressource
-- *******************************************************************************
   FUNCTION getDateFinUtilRess(    p_ident	IN NUMBER,
					p_soccont	IN VARCHAR2,
					p_lcprest	IN VARCHAR2,
					p_cdeb	IN DATE
				    ) RETURN DATE ;
END pack_x_consossii;
/


CREATE OR REPLACE PACKAGE BODY pack_x_consossii AS 
-- ******************************************************************************
-- Fonction qui récupère le top ressource
-- *******************************************************************************
 FUNCTION getTop_ressource( p_last_month		IN NUMBER,
					p_mois_preced		IN NUMBER,
					p_cle_contrat		IN VARCHAR2,
					p_date_fin_contrat	IN DATE
				    ) RETURN CHAR IS

   l_result CHAR(1);

   BEGIN
	IF ( p_last_month < p_mois_preced ) THEN
	   l_result := 'F';
	ELSIF ( p_last_month = p_mois_preced ) THEN
	   IF ( p_cle_contrat IS NULL OR p_date_fin_contrat < sysdate ) THEN
		l_result := 'S';
	    ELSIF (p_date_fin_contrat > sysdate ) THEN
		l_result := 'M';
	   END IF;
	ELSE
	   l_result := '?';
	END IF;

	RETURN l_result;

   END getTop_ressource;

-- ******************************************************************************
-- Fonction qui récupère la date de fin d'utilisation de la ressource
-- *******************************************************************************
  FUNCTION getDateFinUtilRess(    p_ident	IN NUMBER,
					p_soccont	IN VARCHAR2,
					p_lcprest	IN VARCHAR2,
					p_cdeb	IN DATE
				    ) RETURN DATE IS

   l_result DATE;

   BEGIN
	SELECT max(lresfin) into l_result
		FROM   ligne_cont 
		WHERE ident    = p_ident
		AND   soccont  =p_soccont
		AND   lcprest  = p_lcprest
		AND   to_number(to_char(lresdeb,'YYYYMM')) <=  to_number(to_char(p_cdeb,'YYYYMM'));

	RETURN l_result;


 END getDateFinUtilRess;


END pack_x_consossii;
/
