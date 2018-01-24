-- Package qui renvoie un curseur contenant la liste des projets.
-- 10/06/2004 : PJO : Fiche 308 : la liste des projets retournée est fontion du dossier projet sélectionné.
-- 10/06/2004 : PJO : Fiche 308 : la liste retournée ne contient que les projets actifs
-- 15/02/2005 : PJO : Fiche 112 : Ajout des listes des projets pour le menu référentiel
-- 30/01/2006 : DDI : Fiche 272 : Retour suite MEP 5.7 : Lister_projet ne ramenait pas les statuts 'N'
-- 25/05/2006 : EVI : Fiche 501 : Prise en compte du statut du projet
-- 08/01/2010 : YSB : Fiche 876 : Ajout d'une liste des projets du RTFE (lister_projet_limitation_ref)
-- 03/05/2010 : ABA : Fiche 1002 
-- 06/01/2012 QC 1329

CREATE OR REPLACE PACKAGE     pack_liste_proj_info AS

TYPE lib_ListeViewType IS RECORD(    	ICPI	CHAR(5),
					LIB	VARCHAR2(50)
                                         );

   TYPE lib_listeCurType IS REF CURSOR RETURN lib_ListeViewType;
   -- liste des projets pour un dossier projet donné
   PROCEDURE lister_projet(	p_userid   IN 	  VARCHAR2,
   				p_dpcode   IN 	  VARCHAR2,
             	       		p_curseur  IN OUT lib_listeCurType
            );

   -- Liste des projets pour un dossier projet donné par ordre alphabétique
   PROCEDURE lister_projet_alpha(	p_userid   IN 	  VARCHAR2,
   					p_dpcode   IN 	  VARCHAR2,
             	       			p_curseur  IN OUT lib_listeCurType
            );

   -- Liste des projets pour le menu référentiel
   PROCEDURE lister_projet_ref(	p_userid   IN 	  VARCHAR2,
             	       		p_curseur  IN OUT lib_listeCurType
            );

   -- Liste des projets pour le menu référentiel + (Pas de limitation)
   PROCEDURE lister_projet_limitation_ref(	p_userid   IN 	  VARCHAR2,
             	       		p_curseur  IN OUT lib_listeCurType
            );

    -- Liste des projets pour un dossier projet (notification)
   PROCEDURE lister_projet_notif(	p_userid   IN 	  VARCHAR2,
   					p_dpcode   IN 	  VARCHAR2,
             	       			p_curseur  IN OUT lib_listeCurType
            );

END pack_liste_proj_info;
/


CREATE OR REPLACE PACKAGE BODY     pack_liste_proj_info AS

PROCEDURE lister_projet(	p_userid   IN 	  VARCHAR2,
   				p_dpcode   IN 	  VARCHAR2,
             	       		p_curseur  IN OUT lib_listeCurType
            ) IS
BEGIN
  -- Si le code DP est = à 70000 on retourne tous les projets actifs
  IF TO_NUMBER(p_dpcode) = 70000 THEN
  	OPEN p_curseur FOR

  	    -- La première ligne est vide
  	    SELECT 	'' icpi,
  	    		' ' LIB
  	    FROM dual
  	    UNION
	    SELECT DISTINCT  pi.icpi,
	    		     'DP ' || TO_CHAR(pi.icodproj, 'FM00000') ||' - ' || pi.icpi ||' - ' || ltrim(rtrim(pi.ilibel))  LIB
	    FROM proj_info pi, dossier_projet dp
	    WHERE dp.dpcode = pi.icodproj
	      AND (pi.statut IS NULL OR pi.statut='O' OR pi.statut='N')
	      AND dp.actif = 'O'
	      AND dp.dpcode != 0
	    ORDER BY LIB;


  -- Sinon on renvoie la liste des projets actifs pour le dossier projet
  ELSE
	OPEN p_curseur FOR
  	    -- La première ligne est vide
  	    SELECT 	'' icpi,
  	    		' ' LIB
  	    FROM dual
  	    UNION
	    SELECT DISTINCT  icpi,
	    		     icpi ||' - ' || ltrim(rtrim(ilibel))  LIB
	    FROM proj_info
	    WHERE icodproj = TO_NUMBER(p_dpcode)
	      AND (statut IS NULL OR statut='O' OR statut='N')
	    ORDER BY LIB;

  END IF;

EXCEPTION WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);

END lister_projet;


PROCEDURE lister_projet_alpha(	p_userid   IN 	  VARCHAR2,
   				p_dpcode   IN 	  VARCHAR2,
             	       		p_curseur  IN OUT lib_listeCurType
            ) IS
BEGIN

	OPEN p_curseur FOR
  	    -- La première ligne est vide
  	    SELECT 	'' icpi,
  	    		' ' LIB
  	    FROM dual
  	    UNION
	    SELECT DISTINCT  icpi,
	    		     ltrim(rtrim(ilibel)) ||' - ' || icpi LIB
	    FROM proj_info
	    WHERE icodproj = TO_NUMBER(p_dpcode)
	      AND (statut IS NULL OR statut='O' OR statut='N')
	    ORDER BY LIB;

EXCEPTION WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);

END lister_projet_alpha;

--Debut PPM 58162 : Suivi par Ref - Elargissement choix Projets
-- Liste des projets pour le menu référentiel
PROCEDURE lister_projet_ref(	p_userid   IN 	  VARCHAR2,
             	       		p_curseur  IN OUT lib_listeCurType) IS
l_doss_proj 	VARCHAR2(5000);
l_projet	VARCHAR2(5000);
nb_projet INTEGER;
nb_doss_proj INTEGER;
BEGIN
   l_doss_proj := pack_global.lire_doss_proj(p_userid);
   l_projet    := pack_global.lire_projet(p_userid);  
 
   --nombre de projets habilite
    SELECT  COUNT (DISTINCT	icpi) INTO nb_projet
	    FROM proj_info, datdebex
	    WHERE (datdem IS NULL OR datdem > datdebex)
	      AND INSTR(l_projet, icpi) > 0;
  -- nombre de projets inclus dans des dossiers habilite    
        SELECT COUNT (DISTINCT pi.icpi) INTO nb_doss_proj
	    FROM proj_info pi, ligne_bip lb, datdebex d
	    WHERE pi.icpi = lb.icpi
	      AND ((pi.datdem IS NULL) OR (pi.datdem >= d.datdebex))
	      AND ((lb.adatestatut IS NULL) OR (lb.adatestatut >= d.datdebex))
	      AND INSTR(l_doss_proj, TO_CHAR(lb.dpcode, 'FM00000')) > 0;
   
  
   IF (l_projet IS NULL) AND (l_doss_proj IS NULL) THEN
   	OPEN p_curseur FOR
        	-- Ligne vide
        	SELECT '' CODE,
        	       '' LIB
        	FROM DUAL;

   ELSIF (INSTR(UPPER(l_doss_proj), 'TOUS') > 0) OR (INSTR(UPPER(l_projet), 'TOUS') > 0) THEN

	OPEN p_curseur FOR
  	    -- La première ligne est "Tous"
  	    SELECT 	' TOUS' icpi,
  	    		'Tous' LIB
  	    FROM dual
  	    -- La seconde liste est la liste des projets actifs 
  	    UNION
	    SELECT  	icpi,
	    	     	icpi ||' - ' ||ltrim(rtrim(ilibel)) LIB
	    FROM proj_info, datdebex
	    WHERE (datdem IS NULL OR datdem > datdebex)
	    ORDER BY icpi;

  --Liste des projets de l'habilitation
  ELSIF (nb_projet > 0) AND (nb_doss_proj = 0) THEN
	OPEN p_curseur FOR
  	    -- La première ligne est "Tous"
  	    SELECT DISTINCT	' TOUS' icpi,
  	    		'Tous' LIB
  	    FROM proj_info
  	    -- La seconde liste est la liste des projets de l'habilitation        
       UNION ALL        
        SELECT DISTINCT	'--- Habil Directe ---' icpi,
  	    		'--- Habil Directe ---' LIB
  	    FROM proj_info
  	    UNION ALL
	    SELECT  DISTINCT	icpi,
	    	     	icpi ||' - ' ||ltrim(rtrim(ilibel)) LIB
	    FROM proj_info, datdebex
	    WHERE (datdem IS NULL OR datdem > datdebex)
	      AND INSTR(l_projet, icpi) > 0;
  --Liste des projets rattaches au dossiers_projets de l'habilitation
  ELSIF  (nb_projet = 0) AND (nb_doss_proj > 0) THEN
      OPEN p_curseur FOR
      -- La première ligne est "Tous"
  	    SELECT DISTINCT	' TOUS' icpi,
  	    		'Tous' LIB
  	    FROM proj_info        
       UNION ALL
	    -- La troisieme liste est la liste des projets rattachés au dossiers_projets de l'habilitation     
        SELECT DISTINCT	'--- Habil par DP ---' icpi,
  	    		'--- Habil par DP ---' LIB
  	    FROM proj_info
	    UNION ALL
	    SELECT DISTINCT 	pi.icpi,
	    	     	pi.icpi ||' - ' ||ltrim(rtrim(pi.ilibel)) LIB
	    FROM proj_info pi, ligne_bip lb, datdebex d
	    WHERE pi.icpi = lb.icpi
	      AND ((pi.datdem IS NULL) OR (pi.datdem >= d.datdebex))
	      AND ((lb.adatestatut IS NULL) OR (lb.adatestatut >= d.datdebex))
	      AND INSTR(l_doss_proj, TO_CHAR(lb.dpcode, 'FM00000')) > 0;        
  ELSE
  --Liste des projets par habilitation directe et par dossiers_projets
	OPEN p_curseur FOR
   SELECT  icpi, LIB from (
  	    -- La première ligne est "Tous"
  	    SELECT DISTINCT	' TOUS' icpi,
  	    		'Tous' LIB, 1 as ordere
  	   FROM proj_info
  	    -- La seconde liste est la liste des projets de l'habilitation
       UNION ALL        
        SELECT 	DISTINCT '--- Habil Directe ---' icpi,
  	    		'--- Habil Directe ---' LIB, 2 as ordere
  	    FROM proj_info
  	    UNION ALL
	    SELECT  DISTINCT	icpi,
	    	     	icpi ||' - ' ||ltrim(rtrim(ilibel)) LIB, 3 as ordere
	    FROM proj_info, datdebex
	    WHERE (datdem IS NULL OR datdem > datdebex)
	      AND INSTR(l_projet, icpi) > 0
   UNION  ALL   
	    -- La troisieme liste est la liste des projets rattachés au dossiers_projets de l'habilitation     
        SELECT DISTINCT	'--- Habil par DP ---' icpi,
  	    		'--- Habil par DP ---' LIB, 4 as ordere
  	    FROM proj_info
	    UNION ALL
	    SELECT DISTINCT 	pi.icpi,
	    	     	pi.icpi ||' - ' ||ltrim(rtrim(pi.ilibel)) LIB, 5 as ordere
	    FROM proj_info pi, ligne_bip lb, datdebex d
	    WHERE pi.icpi = lb.icpi
	      AND ((pi.datdem IS NULL) OR (pi.datdem >= d.datdebex))
	      AND ((lb.adatestatut IS NULL) OR (lb.adatestatut >= d.datdebex))
	      AND INSTR(l_doss_proj, TO_CHAR(lb.dpcode, 'FM00000')) > 0
        ) 
        order by ordere,icpi ;               
   END IF;
EXCEPTION
	WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);
END lister_projet_ref;

-- Liste des projets pour le menu référentiel + pas de limitation
PROCEDURE lister_projet_limitation_ref(	p_userid   IN 	  VARCHAR2,
             	       		p_curseur  IN OUT lib_listeCurType) IS
l_doss_proj 	VARCHAR2(5000);
l_projet	VARCHAR2(5000);
nb_projet INTEGER;
nb_doss_proj INTEGER;
BEGIN
   l_doss_proj := pack_global.lire_doss_proj(p_userid);
   l_projet    := pack_global.lire_projet(p_userid);  

   --nombre de projets habilite
    SELECT  COUNT (DISTINCT	icpi) INTO nb_projet
	    FROM proj_info, datdebex
	    WHERE (datdem IS NULL OR datdem > datdebex)
	      AND INSTR(l_projet, icpi) > 0;
  -- nombre de projets inclus dans des dossiers habilite    
        SELECT COUNT (DISTINCT pi.icpi) INTO nb_doss_proj
	    FROM proj_info pi, ligne_bip lb, datdebex d
	    WHERE pi.icpi = lb.icpi
	      AND ((pi.datdem IS NULL) OR (pi.datdem >= d.datdebex))
	      AND ((lb.adatestatut IS NULL) OR (lb.adatestatut >= d.datdebex))
	      AND INSTR(l_doss_proj, TO_CHAR(lb.dpcode, 'FM00000')) > 0;
   
   IF ( ((l_projet IS NULL) or (UPPER(l_projet) = 'TOUS')) AND ((l_doss_proj IS NULL) or (UPPER(l_doss_proj) = 'TOUS')) ) THEN
	OPEN p_curseur FOR
  	    -- ne retourne rien 
        SELECT  	icpi icpi,
	    	     	icpi ||' - ' ||ltrim(rtrim(ilibel)) LIB
	    FROM proj_info
        WHERE INSTR(l_projet, -1) > 0;

  --Liste des projets de l'habilitation
  ELSIF (nb_projet > 0) AND (nb_doss_proj = 0) THEN
	OPEN p_curseur FOR
  	    -- La seconde liste est la liste des projets de l'habilitation        
        SELECT DISTINCT	'--- Habil Directe ---' icpi,
  	    		'--- Habil Directe ---' LIB
  	    FROM proj_info
  	    UNION ALL
	    SELECT  DISTINCT	icpi,
	    	     	icpi ||' - ' ||ltrim(rtrim(ilibel)) LIB
	    FROM proj_info, datdebex
	    WHERE (datdem IS NULL OR datdem > datdebex)
	      AND INSTR(l_projet, icpi) > 0;
  --Liste des projets rattaches au dossiers_projets de l'habilitation
  ELSIF  (nb_projet = 0) AND (nb_doss_proj > 0) THEN
      OPEN p_curseur FOR
	    -- La troisieme liste est la liste des projets rattachés au dossiers_projets de l'habilitation     
        SELECT DISTINCT	'--- Habil par DP ---' icpi,
  	    		'--- Habil par DP ---' LIB
  	    FROM proj_info
	    UNION ALL
	    SELECT DISTINCT 	pi.icpi,
	    	     	pi.icpi ||' - ' ||ltrim(rtrim(pi.ilibel)) LIB
	    FROM proj_info pi, ligne_bip lb, datdebex d
	    WHERE pi.icpi = lb.icpi
	      AND ((pi.datdem IS NULL) OR (pi.datdem >= d.datdebex))
	      AND ((lb.adatestatut IS NULL) OR (lb.adatestatut >= d.datdebex))
	      AND INSTR(l_doss_proj, TO_CHAR(lb.dpcode, 'FM00000')) > 0;        
  ELSE
  --Liste des projets par habilitation directe et par dossiers_projets
	OPEN p_curseur FOR
   SELECT  icpi, LIB from (
  	    -- La seconde liste est la liste des projets de l'habilitation        
        SELECT 	DISTINCT '--- Habil Directe ---' icpi,
  	    		'--- Habil Directe ---' LIB, 2 as ordere
  	    FROM proj_info
  	    UNION ALL
	    SELECT  DISTINCT	icpi,
	    	     	icpi ||' - ' ||ltrim(rtrim(ilibel)) LIB, 3 as ordere
	    FROM proj_info, datdebex
	    WHERE (datdem IS NULL OR datdem > datdebex)
	      AND INSTR(l_projet, icpi) > 0
   UNION  ALL   
	    -- La troisieme liste est la liste des projets rattachés au dossiers_projets de l'habilitation     
        SELECT DISTINCT	'--- Habil par DP ---' icpi,
  	    		'--- Habil par DP ---' LIB, 4 as ordere
  	    FROM proj_info
	    UNION ALL
	    SELECT DISTINCT 	pi.icpi,
	    	     	pi.icpi ||' - ' ||ltrim(rtrim(pi.ilibel)) LIB, 5 as ordere
	    FROM proj_info pi, ligne_bip lb, datdebex d
	    WHERE pi.icpi = lb.icpi
	      AND ((pi.datdem IS NULL) OR (pi.datdem >= d.datdebex))
	      AND ((lb.adatestatut IS NULL) OR (lb.adatestatut >= d.datdebex))
	      AND INSTR(l_doss_proj, TO_CHAR(lb.dpcode, 'FM00000')) > 0
        ) 
        order by ordere,icpi ;               
   END IF;

   EXCEPTION
	WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);
END lister_projet_limitation_ref;
--Fin PPM 58162

PROCEDURE lister_projet_notif(	p_userid   IN 	  VARCHAR2,
   				p_dpcode   IN 	  VARCHAR2,
             	       		p_curseur  IN OUT lib_listeCurType
            ) IS
BEGIN
-- HPPM 58337 : ajout de la valeur "Tous" au début de la liste et la selectionnée par défaut et
-- si tous les dossiers projets sont sélectionnées alors ne pas charger la liste des sous projets 
IF (p_dpcode IS NULL  OR p_dpcode = ' ' OR p_dpcode = 'TOUS')  THEN


	OPEN p_curseur FOR
        	-- Ligne vide
        	SELECT '' CODE,
        	       '' LIB
        	FROM DUAL;
ELSE
   	OPEN p_curseur FOR
  	    -- La première ligne est vide
  	    SELECT 	' ' icpi,
  	    		' ' LIB
  	    FROM dual
  	 --   UNION
  	    -- La première ligne est "Tous"
  	 --   SELECT 	' TOUS' icpi,
  	--    		'Tous' LIB
  	--    FROM dual
  	    UNION
	    SELECT DISTINCT  icpi,
	    		     icpi ||' - ' ||  ltrim(rtrim(ilibel)) LIB
	    FROM proj_info
	    WHERE icodproj = TO_NUMBER(p_dpcode)
	      AND (statut IS NULL OR statut='O' OR statut='N')
	    ORDER BY icpi;

END IF;
EXCEPTION WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);


END lister_projet_notif;

END pack_liste_proj_info;
/


