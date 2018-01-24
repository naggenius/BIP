--------------------------------------------------------
--  Fichier créé - lundi-octobre-10-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PACK_BEST_DATE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "BIP"."PACK_BEST_DATE" AS
  FUNCTION best_date(
			  p_dateDebLC      IN DATE
			, p_dateFinLC      IN DATE
			, p_dateDebC       IN DATE
			, p_dateFinC       IN DATE
			, p_CoutContrat    IN NUMBER
			, p_CoutRess       IN NUMBER
			, p_DateReturn	   IN VARCHAR2 
		     ) RETURN DATE;
	PRAGMA restrict_references(best_date, wnds);
END pack_best_date;

 

/
--------------------------------------------------------
--  DDL for Package Body PACK_BEST_DATE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "BIP"."PACK_BEST_DATE" AS
--==============================================================================================
-- Fonction de recherche de la meilleur DATE en fonction du nombre JH et de la durée du contrat
--==============================================================================================
FUNCTION best_date(
			  p_dateDebLC      IN DATE
			, p_dateFinLC      IN DATE
			, p_dateDebC       IN DATE
			, p_dateFinC       IN DATE
			, p_CoutContrat    IN NUMBER
			, p_CoutRess       IN NUMBER
			, p_DateReturn	   IN VARCHAR2 
			     ) RETURN DATE
IS
p_newdate	DATE;
p_nbrJH		number(11);
p_dureeLC	number(11);
p_dureeC 	number(11);
p_ecartC	number(11);
p_ecartLC 	number(11);
p_ecartMini	number(11);
BEGIN
--
-- Rechercher de la meilleur date
--
	p_nbrJH:=p_CoutContrat/p_CoutRess;
	p_dureeC:=p_dateFinC-p_dateDebC;
	p_dureeLC:=p_dateFinLC-p_dateDebLC;
	IF (p_dureeC-p_nbrJH) < 0  THEN
		IF (p_dureeLC-p_nbrJH) < 0 THEN
			p_ecartC := p_nbrJH-p_dureeC;
		ELSE
			p_ecartC := (p_dureeLC-p_nbrJH)*2;
		END IF;
	ELSE
		p_ecartC := p_dureeC-p_nbrJH;
	END IF;
	IF (p_dureeLC-p_nbrJH) < 0  THEN
		IF (p_dureeC-p_nbrJH) < 0 THEN
			p_ecartLC := p_nbrJH-p_dureeLC;
		ELSE
			p_ecartLC := (p_dureeC-p_nbrJH)*2;
		END IF;
	ELSE
		p_ecartLC := p_dureeLC-p_nbrJH;
	END IF;
	p_ecartMini :=  LEAST (p_ecartC, p_ecartLC);
	IF p_ecartMini = p_ecartC THEN
		IF p_DateReturn='DEBUT' THEN
			p_newdate := p_dateDebC;
		ELSE
			p_newdate := p_dateFinC	;
		END IF;
	ELSE
		IF p_DateReturn='DEBUT' THEN
			p_newdate := p_dateDebLC;
		ELSE
			p_newdate := p_dateFinLC;	
		END IF;
	END IF;	
	RETURN(p_newdate);
END best_date;
END pack_best_date;

/
