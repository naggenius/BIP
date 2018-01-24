-- APPLICATION ISAC
-- -------------------------------------
-- pack_liste_isac_etape PL/SQL
-- 
-- Créé le 14/03/2002 par NBM
--
-- Liste des étapes d'une ligne BIP
--
-- Utilisée dans les pages iletape.htm et igtache.htm
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_isac_etape AS

   TYPE etape_ListeViewType IS RECORD( 
				   	ETAPE		VARCHAR2(100),
					LISTETAPE 	VARCHAR2(100)
				
                                         );

   TYPE etape_listeCurType IS REF CURSOR RETURN etape_ListeViewType;

   PROCEDURE lister_isac_etape( p_pid     IN isac_etape.pid%TYPE,		 
                              	p_userid  IN VARCHAR2,
                              	p_curseur IN OUT etape_listeCurType
                             );
	-- ------------------------------------------------------------------------
 -- Nom        : a_une_structure
 -- Auteur     : RBO
 -- Decription :   Renvoie un booléan indiquant s'il existe une structure
 -- pour une ligne BIP donnée
 --
 -- ------------------------------------------------------------------------
 PROCEDURE a_une_structure( p_pid IN isac_etape.pid%TYPE,
                            p_result OUT VARCHAR2);

 -- ------------------------------------------------------------------------
 -- Nom        : A_UN_CONSOMME
 -- Auteur     : FAD
 -- Decription : PPM 63773 : Renvoie un booléan indiquant si la ligne bip
 -- comporte un consommé
 -- ------------------------------------------------------------------------
 PROCEDURE A_UN_CONSOMME( p_pid IN ISAC_CONSOMME.pid%TYPE,
                            p_result OUT VARCHAR2);

 -- Type d'enregistrement structLb_ViewType, représentant les étapes / tâches / sous-tâches d'une ligne BIP. 
/*Il contient les attributs suivants :
-	L'identifiant d'étape
-	Le numéro d'étape ISAC_ETAPE.ECET%TYPE
-	Le type d'étape TYPE_ETAPE.TYPETAP%TYPE
-	Le libellé du type d'étape TYPE_ETAPE.LIBTYET%TYPE
-	Le libellé de l'étape ISAC_ETAPE.LIBETAPE%TYPE
-	L'identifiant de la tâche
-	Le numéro de la tâche ISAC_TACHE.ACTA%TYPE
-	Le libellé de la tâche ISAC_TACHE.LIBTACHE%TYPE
-	L'identifiant de la sous-tâche
-	Le numéro de la sous-tâche ISAC_SOUS_TACHE.ACST%TYPE
-	Le libellé de la sous-tâche ISAC_SOUS_TACHE.ASNOM%TYPE*/
  TYPE structLb_ViewType IS RECORD (  etape ISAC_ETAPE.ETAPE%TYPE,
									 ecet ISAC_ETAPE.ECET%TYPE,
                                     typetap TYPE_ETAPE.TYPETAP%TYPE,
                                     libtyet TYPE_ETAPE.LIBTYET%TYPE,
                                     libetape ISAC_ETAPE.LIBETAPE%TYPE,
									 tache ISAC_TACHE.TACHE%TYPE,
                                     acta ISAC_TACHE.ACTA%TYPE,
                                     libtache ISAC_TACHE.LIBTACHE%TYPE,
                                     --MCH PPM 61919 6.10
                                     tacheaxemetier ISAC_TACHE.TACHEAXEMETIER%TYPE,
									 sous_tache ISAC_SOUS_TACHE.SOUS_TACHE%TYPE,
                                     acst ISAC_SOUS_TACHE.ACST%TYPE,
                                     asnom ISAC_SOUS_TACHE.ASNOM%TYPE);
  TYPE structLb_CurType IS REF CURSOR RETURN structLb_ViewType;
  
  -- Procédure de récupération des informations concernant la structure d'une ligne BIP donnée
  PROCEDURE get_infos_structure_ligne (p_pid IN isac_etape.pid%TYPE, p_curseur OUT structLb_CurType);
							 
END pack_liste_isac_etape;
/
create or replace
PACKAGE BODY pack_liste_isac_etape AS

PROCEDURE lister_isac_etape(  p_pid     IN isac_etape.pid%TYPE,
                              p_userid  IN VARCHAR2,
                              p_curseur IN OUT etape_listeCurType
                             ) IS
l_count number(2);
BEGIN
	select count(*) into l_count
	from isac_etape
	where pid=p_pid;

	IF l_count=0 THEN
	OPEN p_curseur FOR
		select' ',RPAD(' ',36,' ') from dual;
	ELSE
	OPEN p_curseur FOR
		select to_char(etape) ETAPE, RPAD(ECET,2,' ')||' '|| RPAD(LIBETAPE,30,' ')||' '||RPAD(TYPETAPE,2,' ') 		LISTETAPE
		from isac_etape
		where pid=p_pid
		order by ecet;
	END IF;
END lister_isac_etape;

  -- ------------------------------------------------------------------------
 -- Nom        : a_une_structure
 -- Auteur     : RBO
 -- Decription :   Renvoie un booléan indiquant s'il existe une structure
 -- pour une ligne BIP donnée
 -- ------------------------------------------------------------------------
 PROCEDURE a_une_structure ( p_pid IN isac_etape.pid%TYPE,
                            p_result OUT VARCHAR2)IS
		l_pid ISAC_ETAPE.PID%type;
		BEGIN
		  p_result := 'O';
		  BEGIN
			  SELECT PID INTO l_pid FROM
				(SELECT DISTINCT PID
				FROM ISAC_ETAPE
				WHERE UPPER(PID) = UPPER(p_pid))
			  WHERE ROWNUM <= 1;
		  EXCEPTION
			WHEN NO_DATA_FOUND THEN
			  p_result := 'N';
		  END;
END a_une_structure;

 -- ------------------------------------------------------------------------
 -- Nom        : A_UN_CONSOMME
 -- Auteur     : FAD
 -- Decription : PPM 63773 : Renvoie un booléan indiquant si la ligne bip
 -- comporte un consommé
 -- ------------------------------------------------------------------------
PROCEDURE A_UN_CONSOMME ( p_pid IN ISAC_CONSOMME.pid%TYPE,
                          p_result OUT VARCHAR2)IS
  l_pid ISAC_CONSOMME.PID%type;
BEGIN
  p_result := 'O';
  BEGIN
    SELECT PID INTO l_pid
    FROM ISAC_CONSOMME
    WHERE UPPER(PID) = UPPER(p_pid)
    AND CUSAG IS NOT NULL AND CUSAG != 0
    AND ROWNUM <= 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
    p_result := 'N';
  END;
END A_UN_CONSOMME;

-- Procédure de récupération des informations concernant la structure d'une ligne BIP donnée
PROCEDURE get_infos_structure_ligne (p_pid IN isac_etape.pid%TYPE, p_curseur OUT structLb_CurType) IS
   BEGIN
      BEGIN
        OPEN p_curseur FOR
          SELECT  et.ETAPE, et.ECET,
          DECODE(et.TYPETAPE, 'ES', 'ES', 'NO', 'NO', typet.TYPETAP),
          DECODE(et.TYPETAPE, 'ES', ' Etape spéciale', 'NO', ' Etape globale', typet.LIBTYET),
          et.LIBETAPE, ta.TACHE, ta.ACTA, ta.LIBTACHE, ta.TACHEAXEMETIER, -- MCH PPM 61919 6.10 
          ssta.SOUS_TACHE, ssta.ACST, ssta.ASNOM
          FROM ISAC_ETAPE et
          LEFT JOIN TYPE_ETAPE typet ON (et.TYPETAPE = typet.TYPETAP)
          LEFT JOIN ISAC_TACHE ta ON (et.PID = ta.PID AND et.ETAPE = ta.ETAPE)
          LEFT JOIN ISAC_SOUS_TACHE ssta ON (et.PID = ssta.PID AND et.ETAPE = ssta.ETAPE AND ta.TACHE = ssta.TACHE)
          WHERE et.PID = p_pid
          ORDER BY ECET, ACTA, ACST;
      END;
END get_infos_structure_ligne;

END pack_liste_isac_etape;
/
show errors