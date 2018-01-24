/*
	Package		PACK_UTIL_SITU
	
	Objet		Fonctions destinees a exploiter les situations des ressources
	
12/01/2001	O. Duprey
			Premiere version du package pour la fonction indiquant la date
			d'arrivee des ressources pour la recherche des prestataires presents
			depuis plus de 1 an		
09/01/2004	P. JOSSE
			Remplacement du délai : ce n'est plus 1 an mais 6 mois=180 jours.
06/12/2005      B. AARAB  
			Fiche 327  Ajout de la fontion DureePresenceRessourceMois
06/02/2005  P PRIGENT
	        Supprime la création de la vue vue_ress_ancien     
11/02/2009 E VINATIER
			Remplacement du délai : ce n'est plus 6 mois mais 1 ans=365 jours.
14/04/2011 BSA 1054
			Remplacement du délai : ce n'est plus 365 jours mais 11 mois = 335 jours
01/06/2012  : BSA QC 1396
13/06/2012	: OEL QC 1396 - Enrichissement de l'export ressources actives.			
*/

CREATE OR REPLACE PACKAGE "PACK_UTIL_SITU" IS
/*
	La fonction DureePresenceRessource indique la duree en jours
	entre l'arrivee de la ressource et la date recue en parametre,
	sachant que les periodes d'absence de plus de 6 mois (constante
	Delai a 183 jours) remettent le compteur a zero.
*/
	FUNCTION DureePresenceRessource(id_ress IN NUMBER, DateCourante IN DATE) RETURN NUMBER;
	PRAGMA RESTRICT_REFERENCES (DureePresenceRessource, WNDS, WNPS);

	/*
	La fonction DureePresenceRessource indique la duree en mois
	entre l'arrivee de la ressource et la date recue en parametre,
	sachant que les periodes d'absence de plus de 6 mois (constante
	Delai a 183 jours) remettent le compteur a zero.
*/
	FUNCTION DureePresenceRessourceMois(id_ress IN NUMBER, DateCourante IN DATE) RETURN NUMBER;
	PRAGMA RESTRICT_REFERENCES (DureePresenceRessourceMois, WNDS, WNPS);

/*
	La fonction DebutPresenceRessource indique la date de debut
	de presence de la ressource à la SG sans interruption
	egale ou superieure a 6 mois.
*/
	FUNCTION DebutPresenceRessource(id_ress IN NUMBER) RETURN DATE;
	PRAGMA RESTRICT_REFERENCES (DebutPresenceRessource, WNDS, WNPS);

/*
	Fonction qui permet de connaitre la durée réelle de présence
	de la ressource en otant les interruptions inférieures à 6 mois
	Si interruption supérieure à 6 mois : remise à zéro
*/
	FUNCTION DureeReellePresence(id_ress IN NUMBER, DateCourante IN DATE) RETURN NUMBER;
	PRAGMA RESTRICT_REFERENCES (DureeReellePresence, WNDS, WNPS);

	FUNCTION DureeReellePresenceMois(id_ress IN NUMBER, DateCourante IN DATE) RETURN NUMBER;
	PRAGMA RESTRICT_REFERENCES (DureePresenceRessourceMois, WNDS, WNPS);
    
    FUNCTION ISACTIVESITU(p_dateDeb DATE, p_date_fin DATE, p_ident NUMBER) RETURN CHAR;
    
    
END;
/


CREATE OR REPLACE PACKAGE BODY "PACK_UTIL_SITU" IS
/*
	La constante Delai correspond au nombre de jours d'une annee
	(on recherche les periodes sans interruption superieure ou egale
	a 6 mois=180 jours).
*/
/*
Mise a jour le 11/02/2009 le delai n'est plus de 6 mois mais 1ans = 365j
BSA 1054 14/04/2011 le delai passe maintenant a 11 mois soit un equvalent de 335 jours

*/
	Delai		CONSTANT INTEGER := 335;
/*
	La procedure PeriodePrecence recherche la derniere periode
	de presence de la ressource sans interruption de plus de 6 mois.
*/
	PROCEDURE PeriodePresence(id_ress IN NUMBER, DateDebut OUT DATE, DateFin OUT DATE, PresenceTotale OUT NUMBER) IS
		CURSOR periode(ID IN NUMBER) IS
			SELECT DatSitu, DatDep
			FROM SITU_RESS
			WHERE ident=id_ress
			ORDER BY DatSitu;
		situ	periode%ROWTYPE;
		DateArrivee	DATE;
		DateDepart	DATE;
		aujourdhui	DATE;

	BEGIN
		SELECT TRUNC(SYSDATE) INTO aujourdhui
		FROM DUAL;

		DateArrivee:=NULL;
		DateDepart:=NULL;
		OPEN periode(id_ress);
		LOOP
			FETCH periode INTO situ;
			EXIT WHEN periode%NOTFOUND;
			IF (DateArrivee IS NULL) THEN			-- premiere periode
				DateArrivee:=situ.DatSitu;
				DateDepart:=situ.DatDep;

				IF (DateDepart IS NULL) THEN	-- Si date de départ non renseignée(=>ressource toujours présente)
					PresenceTotale:=aujourdhui - situ.DatSitu;
				ELSE				-- Sinon
					PresenceTotale:=(situ.DatDep - situ.DatSitu) + 1;
				END IF;

			ELSE						-- pas premiere periode
				IF situ.DatSitu>=DateDepart+Delai THEN		-- interruption > 6 mois
					DateArrivee:=situ.DatSitu;
					DateDepart:=situ.DatDep;

					IF (DateDepart IS NULL) THEN	-- Si date de départ non renseignée(=>ressource toujours présente)
						PresenceTotale := aujourdhui - situ.DatSitu;
					ELSE				-- Sinon
						PresenceTotale := situ.DatDep - situ.DatSitu + 1;
					END IF;

				ELSE						-- interruption < 6 mois
					DateDepart:=situ.DatDep;
					IF (DateDepart IS NOT NULL) THEN	-- Si date de départ renseignée
						PresenceTotale := PresenceTotale + (situ.DatDep - situ.DatSitu) + 1;
					ELSE -- Sinon la presence Totale est calculée avec aujourd'hui comme date de fin
						PresenceTotale := PresenceTotale + (aujourdhui - situ.DatSitu);
					END IF;
				END IF;
			END IF;
		END LOOP;
		CLOSE periode;

		DateDebut:=DateArrivee;
		DateFin:=DateDepart;
	END;

	FUNCTION DureePresenceRessource(id_ress IN NUMBER, DateCourante IN DATE) RETURN NUMBER IS
		DateArrivee	DATE;
		DateDepart	DATE;
		PresenceTotale	NUMBER;
		Duree		NUMBER;
	BEGIN
		PeriodePresence(id_ress, DateArrivee, DateDepart, PresenceTotale);
/*
	On a les dates de debut et de fin de periode.
	On compare la date de fin de periode avec la date recue en parametre :
		- si difference >= delai alors duree = 0
		- si difference < delai alors duree = DateCourante-DateArrivee
		- si date de fin de periode NULL ou superieure a DateCourante : ressource toujours presente : duree = DateCourante-DateArrivee
*/
		IF DateDepart IS NULL THEN			-- ressource toujours presente, depart non programee
			Duree:=DateCourante-DateArrivee;
		ELSIF DateDepart>DateCourante THEN		-- ressource toujours presente, depart programme
			Duree:=DateCourante-DateArrivee;
		ELSIF DateCourante-DateDepart>Delai THEN	-- ressource partie depuis plus d'un an
			Duree:=0;
		ELSE						-- ressource partie depuis moins d'un an
			Duree:=DateCourante-DateArrivee;
		END IF;
		RETURN Duree;
	END;


	FUNCTION DureePresenceRessourceMois(id_ress IN NUMBER, DateCourante IN DATE) RETURN NUMBER IS
			PresenceTotalej	NUMBER;
			PresenceTotaleMois	NUMBER;
	BEGIN

	    PresenceTotalej := DureePresenceRessource(id_ress, DateCourante) ;

	   SELECT (TO_NUMBER(SUBSTR(A,6,2)) - 01)+DECODE(SUBSTR(A,1,4),'2000',0,12*(TO_NUMBER(SUBSTR(A,1,4)) - 2000)) + TRUNC((TO_NUMBER(SUBSTR(A,9,2)) /30),1) INTO PresenceTotaleMois
       FROM (SELECT TO_CHAR(TO_DATE('20000101','YYYYMMDD')+PresenceTotalej ,'YYYY MM DD ') A FROM DUAL);

	    RETURN  PresenceTotaleMois;

	END;



	FUNCTION DebutPresenceRessource(id_ress IN NUMBER) RETURN DATE IS
		DateArrivee	DATE;
		DateDepart	DATE;
		PresenceTotale	NUMBER;
	BEGIN
		PeriodePresence(id_ress, DateArrivee, DateDepart, PresenceTotale);
		RETURN DateArrivee;
	END;


	FUNCTION DureeReellePresence(id_ress IN NUMBER, DateCourante IN DATE) RETURN NUMBER IS
		DateArrivee	DATE;
		DateDepart	DATE;
		PresenceTotale	NUMBER;
		Duree		NUMBER;
	BEGIN
		PeriodePresence(id_ress, DateArrivee, DateDepart, PresenceTotale);

		IF DateDepart IS NULL THEN			-- ressource toujours presente, depart non programee
			Duree:=PresenceTotale;
		ELSIF DateDepart>DateCourante THEN		-- ressource toujours presente, depart programme
			Duree:=PresenceTotale - 1 - (DateDepart - DateCourante);
		ELSIF DateCourante-DateDepart>Delai THEN	-- ressource partie depuis plus de 6 mois
			Duree:=0;
		ELSE						-- ressource partie depuis moins de 6 mois
			Duree:=PresenceTotale;
		END IF;
		RETURN Duree;
	END;

    FUNCTION DureeReellePresenceMois(id_ress IN NUMBER, DateCourante IN DATE) RETURN NUMBER IS
			PresenceTotalej	NUMBER;
			PresenceTotaleMois	NUMBER;
	BEGIN

	    PresenceTotalej := DureeReellePresence(id_ress, DateCourante) ;

	   SELECT (TO_NUMBER(SUBSTR(A,6,2)) - 01)+DECODE(SUBSTR(A,1,4),'2000',0,12*(TO_NUMBER(SUBSTR(A,1,4)) - 2000)) + TRUNC((TO_NUMBER(SUBSTR(A,9,2)) /30),1) INTO PresenceTotaleMois
       FROM (SELECT TO_CHAR(TO_DATE('20000101','YYYYMMDD')+PresenceTotalej ,'YYYY MM DD ') A FROM DUAL);

	    RETURN  PresenceTotaleMois;

	END;


    -- **************************************************************************************
-- Nom 		: ISACTIVESITU
-- Auteur 	: OEL - Oussama El Khabzi
-- QC       : 1396
-- Date     : 13/06/2012
-- Description 	: Retourne "O" si la situation est active par rapport a une date de reference
-- Paramètres 	: p_dateDeb (IN) Date de debut de situation
-- 				  p_date_fin (IN) Date de fin de situation
--                p_ident (IN) Identifiant de la Ressource
-- Retour	: "O" pour oui, "N" pour non.
--
-- *******************************************************************************************

    FUNCTION ISACTIVESITU(  p_dateDeb  DATE, 
                            p_date_fin DATE,
                            p_ident    NUMBER
                         ) RETURN CHAR IS



    t_retour    CHAR(1);
    t_result    NUMBER;
    
    BEGIN
    
            t_retour := '';
            
            IF(p_date_fin IS NOT NULL) THEN
                SELECT COUNT(*)
                INTO t_result
                FROM SITU_RESS SR
                WHERE TRUNC(SYSDATE) BETWEEN p_dateDeb AND p_date_fin
                AND SR.IDENT = p_ident;
                
            ELSE
                SELECT COUNT(*)
                INTO t_result
                FROM SITU_RESS SR
                WHERE p_dateDeb <= TRUNC(SYSDATE) 
                AND p_date_fin IS NULL
                AND SR.IDENT = p_ident; 
                              
            END IF;
            
            IF ( t_result != 0 ) THEN 
                t_retour := 'O'; 
            ELSE
                t_retour := 'N'; 
            END IF;
      
            RETURN t_retour;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           return 'N';
        --WHEN OTHERS THEN
        --   return 'N';
               
    END IsActiveSitu;

END;
/


