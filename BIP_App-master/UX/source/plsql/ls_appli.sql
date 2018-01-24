-- Package qui renvoie un curseur contenant la liste des applications.
-- 16/02/2005 : PJO : Fiche 112 : Ajout des listes des applis pour le menu référentiel
-- -- YSB : 08/01/2010 : Fiche TD 876 - Ajout de la liste des applications du RTFE (lister_appli_limitation_ref)
-- 06/01/2012 QC 1329

CREATE OR REPLACE PACKAGE     pack_liste_appli AS

TYPE lib_ListeViewType IS RECORD(    	AIRT	CHAR(5),
					LIB	VARCHAR2(60)
                                         );

   TYPE lib_listeCurType IS REF CURSOR RETURN lib_ListeViewType;


   -- Liste des applis pour le menu référentiel
   PROCEDURE lister_appli_ref(	p_userid   IN 	  VARCHAR2,
             	       		p_curseur  IN OUT lib_listeCurType
            );

   -- Liste des applis pour le menu référentiel (Pas de limitation)
   PROCEDURE lister_appli_limitation_ref(	p_userid   IN 	  VARCHAR2,
             	       		p_curseur  IN OUT lib_listeCurType
            );

END pack_liste_appli;
/


CREATE OR REPLACE PACKAGE BODY     pack_liste_appli AS

-- Liste des applis pour le menu référentiel
PROCEDURE lister_appli_ref(	p_userid   IN 	  VARCHAR2,
             	       		p_curseur  IN OUT lib_listeCurType) IS
l_doss_proj 	VARCHAR2(5000);
l_projet	VARCHAR2(5000);
l_appli		VARCHAR2(255);
BEGIN
   l_doss_proj := pack_global.lire_doss_proj(p_userid);
   l_projet    := pack_global.lire_projet(p_userid);
   l_appli    := pack_global.lire_appli(p_userid);

   IF (l_appli IS NULL) AND (l_projet IS NULL) AND (l_doss_proj IS NULL) THEN
   	OPEN p_curseur FOR
        	-- Ligne vide
        	SELECT '' CODE,
        	       '' LIB
        	FROM DUAL;

   ELSIF (INSTR(UPPER(l_doss_proj), 'TOUS') > 0) OR (INSTR(UPPER(l_projet), 'TOUS') > 0) OR (INSTR(UPPER(l_appli), 'TOUS') > 0) THEN

	OPEN p_curseur FOR
  	    -- La première ligne est "Toutes"
  	    SELECT 	'TOUS' airt,
  	    		'Toutes' LIB
  	    FROM dual
  	    -- La seconde liste est la liste des projets actifs
  	    UNION
	    SELECT  	a.airt,
	    	     	a.airt ||' - ' ||ltrim(rtrim(a.alibel)) LIB
	    FROM application a, ligne_bip lb, datdebex d
	    WHERE a.airt = lb.airt
	      AND ((lb.adatestatut IS NULL) OR (lb.adatestatut >= d.datdebex))
	    ORDER BY airt;
   ELSE
	OPEN p_curseur FOR
  	    -- La première ligne est "Tous"
  	    SELECT 	'TOUS' airt,
  	    		'Toutes' LIB
  	    FROM dual
  	    -- La deuxiéme liste est la liste des applications de l'habilitation
  	    UNION
	    SELECT  	a.airt,
	    	     	a.airt ||' - ' ||ltrim(rtrim(a.alibel)) LIB
	    FROM application a, ligne_bip lb, datdebex d
	    WHERE a.airt = lb.airt
	      AND ((lb.adatestatut IS NULL) OR (lb.adatestatut >= d.datdebex))
	      AND INSTR(l_appli, a.airt) > 0
  	    -- La troisiéme liste est la liste des applications liées aux projets de l'habilitation
  	    UNION
	    SELECT  	a.airt,
	    	     	a.airt ||' - ' ||ltrim(rtrim(a.alibel)) LIB
	    FROM application a, ligne_bip lb, proj_info pi, datdebex d
	    WHERE a.airt = lb.airt
	      AND lb.icpi = pi.icpi
	      AND ((lb.adatestatut IS NULL) OR (lb.adatestatut >= d.datdebex))
	      AND INSTR(l_projet, pi.icpi) > 0
	    -- La quatriéme liste est la liste des applications rattachés au dossiers_projets de l'habilitation
	    UNION
	    SELECT  	a.airt,
	    	     	a.airt ||' - ' ||ltrim(rtrim(a.alibel)) LIB
	    FROM application a, ligne_bip lb, datdebex d
	    WHERE a.airt = lb.airt
	      AND ((lb.adatestatut IS NULL) OR (lb.adatestatut >= d.datdebex))
	      AND INSTR(l_doss_proj, TO_CHAR(lb.dpcode, 'FM00000')) > 0
	    ORDER BY airt;
   END IF;
EXCEPTION
	WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);
END lister_appli_ref;

-- Liste des applis pour le menu référentiel (Pas de limitation)
PROCEDURE lister_appli_limitation_ref(	p_userid   IN 	  VARCHAR2,
             	       		p_curseur  IN OUT lib_listeCurType) IS
l_appli		VARCHAR2(255);
BEGIN
   l_appli    := pack_global.lire_appli(p_userid);

   IF ((l_appli IS NOT NULL) AND (UPPER(l_appli) != 'TOUS')) THEN
	OPEN p_curseur FOR
	    SELECT  	distinct(a.airt) airt,
	    	     	a.airt ||' - ' ||ltrim(rtrim(a.alibel)) LIB
	    FROM application a, ligne_bip lb, datdebex d
	    WHERE a.airt = lb.airt
	      AND ((lb.adatestatut IS NULL) OR (lb.adatestatut >= d.datdebex))
	      AND INSTR(l_appli, a.airt) > 0
	    ORDER BY airt;
   -- YSB : pour éviter de retourner un curseur closed (qui génére des erreurs au niveau de java) j'ai ajouter ce bloc
   ELSE
    OPEN p_curseur FOR
        SELECT  	distinct(a.airt) airt,
	    	     	a.airt ||' - ' ||ltrim(rtrim(a.alibel)) LIB
	    FROM application a
        WHERE INSTR(l_appli, -1) > 0;
   END IF;
EXCEPTION
	WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);
END lister_appli_limitation_ref;

END pack_liste_appli;
/


