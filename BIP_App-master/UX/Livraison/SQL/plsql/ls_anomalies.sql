-- pack_liste_bjh_anomalies PL/SQL
--
-- Maintenance BIP
-- Cree le 13/03/2001
-- Modifié le 06/09/2001(NBM): modif suite aux modifs de la page dbjherr.htm
--
-- Objet : Permet la création de la liste des anomalies relevees lors du bouclage
-- Tables : bjh_anomalies
--
--**********************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...



CREATE OR REPLACE PACKAGE pack_liste_bjh_anomalies AS

TYPE anomalies_p_RecType IS RECORD (cle    VARCHAR2(8),
                                    lib    VARCHAR2(150));

   TYPE anomalies_p_CurType IS REF CURSOR RETURN anomalies_p_RecType;

   PROCEDURE lister_bjh_anomalies(  p_matricule IN CHAR,
				    p_ident 	IN CHAR,
                                    p_userid  	IN VARCHAR2,
                                    p_curseur 	IN OUT anomalies_p_CurType
                                   );

END pack_liste_bjh_anomalies;

/



CREATE OR REPLACE PACKAGE BODY pack_liste_bjh_anomalies AS 
----------------------------------- SELECT -----------------------------------
   PROCEDURE lister_bjh_anomalies ( p_matricule IN CHAR,
				    p_ident 	IN CHAR,
	                            p_userid    IN VARCHAR2,
                                    p_curseur   IN OUT anomalies_p_CurType
                                 ) IS
   BEGIN
	IF p_matricule is not null THEN
        OPEN p_curseur FOR
     		SELECT
            	LPAD(NVL(TO_CHAR(mois,'FM00'), '  '),2,' ')||LPAD(NVL(typeabsence, '      '),6,' '),
	     		LPAD(NVL(TO_CHAR(mois,'FM00'), '  '),2,' ')	||'     '||
	     		LPAD(NVL(typeabsence, '      '),6,' ')		||'     '||
	     		LPAD(NVL(TO_CHAR(coutbip, 'FM990.0'),'     '),5,' ')		||'     '||
            	LPAD(NVL(TO_CHAR(coutgip, 'FM990.0'),'     '),5,' ')		||'     '||
            	LPAD(NVL(TO_CHAR(coutbip-coutgip, 'FM990.0'),'     '),5,' ')	||'     '||
            	DECODE(validation1 , null,'non','oui')
      	FROM bjh_anomalies
      	WHERE matricule = SUBSTR(p_matricule,1,7)
      	ORDER BY mois,typeabsence DESC;
	ELSE
	  OPEN p_curseur FOR
     		SELECT
            	LPAD(NVL(TO_CHAR(mois,'FM00'), '  '),2,' ')||LPAD(NVL(typeabsence, '      '),6,' '),
	     		LPAD(NVL(TO_CHAR(mois,'FM00'), '  '),2,' ')	||'     '||
	     		LPAD(NVL(typeabsence, '      '),6,' ')		||'     '||
	     		LPAD(NVL(TO_CHAR(coutbip, 'FM990.0'),'     '),5,' ')		||'     '||
            	LPAD(NVL(TO_CHAR(coutgip, 'FM990.0'),'     '),5,' ')		||'     '||
            	LPAD(NVL(TO_CHAR(coutbip-coutgip, 'FM990.0'),'     '),5,' ')	||'     '||
            	DECODE(validation1 , null,'non','oui')
      	FROM bjh_anomalies a,(select distinct matricule, ident from bjh_ressource) e
      	WHERE a.matricule = e.matricule
		AND e.ident=to_number(p_ident)
      	ORDER BY mois,typeabsence DESC;
	END IF;

	
   END lister_bjh_anomalies;

END pack_liste_bjh_anomalies;
/



