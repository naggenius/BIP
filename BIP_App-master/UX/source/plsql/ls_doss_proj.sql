-- Package qui renvoie la liste des dossiers projets actifs.
-- PJO : 10/06/2004 : on ne sélectionne que les dossiers projets actifs
-- MMC : 09/08/2004 : le DP 0 ne doit pas figurer dans la liste pour les T1
-- PJO : 15/02/2005 : Procédure qui renvoie la liste des dossiers projets pour le menu référentiels
-- EJE : 12/04/2005 : Procédure qui renvoie la liste des dossiers projets pour un département
-- DDI : 28/11/2005 : Liste des DP actifs classés par code avec les valeurs 0, 70000, tous et Aucun.
-- BPO : 19/05/2007 : Fiche TD 550 - Modification de la taille du champ correspondant au libelle du Dossier Projet
-- EVI : 24/04/2008 : Fiche TD 616 - Ajout du filtre sur les dossiers projets provisoires 88xxx
-- ABA : 15/05/2008 : Fiche TD 616 - Ajout du filtre sur toutes les listes  dossiers projets provisoires 88xxx
-- YSB : 08/01/2010 : Fiche TD 876 - Ajout de la liste des dossiers projets du RTFE (lister_dprojet_limitation_ref).
-- ABA : 10/03/2011 : QC 1140 suppression de l'exclusion du DP 70000 dans la liste des dp notification
-- 06/01/2012 QC 1329

CREATE OR REPLACE PACKAGE     pack_liste_dossier_projet AS

TYPE lib_ListeViewType IS RECORD(    	DPCODE	NUMBER(5),
					LIB	VARCHAR2(60)
                                         );

   TYPE lib_listeCurType IS REF CURSOR RETURN lib_ListeViewType;

   TYPE libBudAct_ListeViewType IS RECORD(    	DPCODE	NUMBER(5),
						LIB	VARCHAR2(60),
						BUDACT	NUMBER(10,2)
                                         );

   TYPE libBudAct_listeCurType IS REF CURSOR RETURN libBudAct_ListeViewType;

   -- Méthode qui liste les dossiers projets par codes.
   PROCEDURE lister_dossier_projet(	p_userid  IN VARCHAR2,
             	       			p_curseur IN OUT lib_listeCurType
            );
            
   --PPM 59288 : lister_dossier_projet_nonGT1 Méthode qui liste les dossiers projets, pour les lignes non GT1, triés par code DP
   PROCEDURE lister_dossier_projet_nonGT1(	p_userid  IN VARCHAR2,
             	       			p_curseur IN OUT lib_listeCurType
            );            
   -- Méthode qui liste les dossiers projets par ordre alphabétique d'intitulé
   PROCEDURE lister_dprojet_alpha(	p_userid  IN VARCHAR2,
             	       			p_curseur IN OUT lib_listeCurType
            );

   -- Méthode qui liste les dossiers projets seleon l'habilitation par référentiels
   PROCEDURE lister_dprojet_ref(	p_userid  IN VARCHAR2,
             	       			p_curseur IN OUT lib_listeCurType
            );

   -- Méthode qui liste les dossiers projets seleon l'habilitation par référentiels  (ajout de 'pas de limitation au début de la liste')
   PROCEDURE lister_dprojet_limitation_ref(	p_userid  IN VARCHAR2,
             	       			p_curseur IN OUT lib_listeCurType
            );

   -- Méthode qui liste les dossiers projets selon un département
   PROCEDURE lister_doss_proj_dep(	p_clicode  IN client_mo.clicode%TYPE,
					p_annee IN VARCHAR2,
             	       			p_curseur IN OUT libBudAct_listeCurType
            );

   -- Méthode qui liste les dossiers projets pour la notification
   PROCEDURE lister_dprojet_notif(	p_userid  IN VARCHAR2,
             	       			p_curseur IN OUT lib_listeCurType
            );

   -- Méthode qui liste les dossiers projets Actifs et Non Actifs classés par code
   PROCEDURE lister_dprojet_par_code01(	p_userid  IN VARCHAR2,
             	       			p_curseur IN OUT lib_listeCurType
            );

   -- Méthode qui liste les dossiers projets Actifs et Non Actifs classés par code  sans la valeur TOUS
   PROCEDURE lister_dprojet_par_code02(	p_userid  IN VARCHAR2,
             	       			p_curseur IN OUT lib_listeCurType
            );

END pack_liste_dossier_projet;
/


CREATE OR REPLACE PACKAGE BODY     pack_liste_dossier_projet AS

PROCEDURE lister_dossier_projet(p_userid  IN VARCHAR2,
             		p_curseur IN OUT lib_listeCurType
            ) IS
BEGIN
    OPEN p_curseur FOR
        -- Ligne vide en haut --
        SELECT '',
               ' ' LIB
        FROM DUAL
        UNION
        /* PPM 59288 : la liste déroulante est la même en non GT1 sauf on met vide au début de la liste et pas de DP=0
    	SELECT DISTINCT  TO_CHAR(dpcode, 'FM00000'),
    			 to_char(dpcode, 'FM00000') ||' - '|| ltrim(rtrim(dplib)) LIB
    	FROM dossier_projet
    	WHERE actif = 'O' and dpcode <> 0
        -- On retire les dossier projet provisoire 88xxx
        AND dpcode NOT LIKE '88%'
    	ORDER BY LIB;

      */
      SELECT DISTINCT  TO_CHAR(dp.dpcode, 'FM00000') COD,
    			 to_char(dp.dpcode, 'FM00000') ||' - '|| ltrim(rtrim(dp.dplib)) LIB
    	FROM dossier_projet dp, proj_info pi
    	WHERE dp.dpcode = pi.icodproj
      AND dp.actif = 'O' --exclure les DP fermés (top actif = N)
      AND dp.dpcode <> 0 --pas de DP =0 pour les lignes GT1
      -- On retire les dossier projet provisoire 88xxx
      AND dp.dpcode NOT LIKE '88%'
      AND (pi.statut IS NULL OR pi.statut='O' OR pi.statut='N') --comporte au moins 1 projet actif dont le statut est <vide> ou <N> ou <O>
    	ORDER BY LIB; --Tri par code DP
   EXCEPTION
       WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);
   END lister_dossier_projet;

--PPM 59288 : Liste des dossiers projets pour des lignes non GT1
PROCEDURE lister_dossier_projet_nonGT1(p_userid  IN VARCHAR2,
             		p_curseur IN OUT lib_listeCurType
            ) IS
BEGIN
    OPEN p_curseur FOR
      SELECT DISTINCT  TO_CHAR(dp.dpcode, 'FM00000') COD,
    			 to_char(dp.dpcode, 'FM00000') ||' - '|| ltrim(rtrim(dp.dplib)) LIB
    	FROM dossier_projet dp, proj_info pi
    	WHERE dp.dpcode = pi.icodproj
      AND dp.actif = 'O' --exclure les DP fermés (top actif = N)
      -- On retire les dossier projet provisoire 88xxx
      AND dp.dpcode NOT LIKE '88%'
      AND (pi.statut IS NULL OR pi.statut='O' OR pi.statut='N') --comporte au moins 1 projet actif dont le statut est <vide> ou <N> ou <O>
    	ORDER BY COD; --Tri par code DP

   EXCEPTION
       WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);
   END lister_dossier_projet_nonGT1;
   
PROCEDURE lister_dprojet_alpha(p_userid  IN VARCHAR2,
             		p_curseur IN OUT lib_listeCurType
            ) IS
BEGIN
    OPEN p_curseur FOR
        -- Ligne vide en haut --
        SELECT '',
               ' ' LIB
        FROM DUAL
        UNION
    	SELECT DISTINCT  TO_CHAR(dpcode),
    			 ltrim(rtrim(dplib)) ||' - '|| to_char(dpcode, 'FM00000')  LIB
    	FROM dossier_projet
    	WHERE actif = 'O'
        -- On retire les dossier projet provisoire 88xxx
        AND dpcode NOT LIKE '88%'
    	ORDER BY LIB;

EXCEPTION
       WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);
END lister_dprojet_alpha;


-- Méthode qui liste les dossiers projets selon l'habilitation par référentiels
PROCEDURE lister_dprojet_ref(	p_userid  IN VARCHAR2,
             	       		p_curseur IN OUT lib_listeCurType) IS

l_doss_proj VARCHAR2(5000);
BEGIN
   l_doss_proj := pack_global.lire_doss_proj(p_userid);

   IF l_doss_proj IS NULL THEN
   	OPEN p_curseur FOR
        	-- Ligne vide --
        	SELECT '' CODE,
        	       '' LIB
        	FROM DUAL;

   ELSIF INSTR(UPPER(l_doss_proj), 'TOUS') > 0 THEN
   	OPEN p_curseur FOR
        	-- Ligne "Tous" en haut --
        	SELECT 'TOUS' CODE,
        	       'Tous' LIB
        	FROM DUAL
        	UNION
    		SELECT   TO_CHAR(dpcode, 'FM00000') CODE,
    			 TO_CHAR(dpcode, 'FM00000') ||' - '|| ltrim(rtrim(dplib))    LIB
    		FROM dossier_projet
    		WHERE actif = 'O'
            -- On retire les dossier projet provisoire 88xxx
            AND dpcode NOT LIKE '88%'
    		ORDER BY CODE;
   ELSE
   	OPEN p_curseur FOR
        	-- Ligne "Tous" en haut --
        	SELECT 'TOUS' CODE,
        	       'Tous' LIB
        	FROM DUAL
        	UNION
    		SELECT 	TO_CHAR(dpcode, 'FM00000') CODE,
    			TO_CHAR(dpcode, 'FM00000') ||' - '|| ltrim(rtrim(dplib)) LIB
    		FROM dossier_projet
    		WHERE actif = 'O'
            -- On retire les dossier projet provisoire 88xxx
            AND dpcode NOT LIKE '88%'
    		  AND INSTR(l_doss_proj, TO_CHAR(dpcode, 'FM00000')) > 0
    		ORDER BY CODE;
    END IF;
END lister_dprojet_ref;

-- Méthode qui liste les dossiers projets selon l'habilitation par référentiels + pas de limitation
PROCEDURE lister_dprojet_limitation_ref(	p_userid  IN VARCHAR2,
             	       		p_curseur IN OUT lib_listeCurType) IS

l_doss_proj VARCHAR2(5000);
BEGIN
   l_doss_proj := pack_global.lire_doss_proj(p_userid);

   IF ((l_doss_proj IS NOT NULL) and (UPPER(l_doss_proj) <> 'TOUS')) THEN

    OPEN p_curseur FOR
    		SELECT 	TO_CHAR(dpcode, 'FM00000') CODE,
    			TO_CHAR(dpcode, 'FM00000') ||' - '|| ltrim(rtrim(dplib)) LIB
    		FROM dossier_projet
    		WHERE INSTR(l_doss_proj, TO_CHAR(dpcode, 'FM00000')) > 0
            AND actif = 'O'
            -- On retire les dossier projet provisoire 88xxx
            AND dpcode NOT LIKE '88%'
            ORDER BY CODE;
   ELSE
   -- YSB : pour éviter de retourner un curseur closed (qui génére des erreurs au niveau de java) j'ai ajouter ce bloc
    OPEN p_curseur FOR
            SELECT 	TO_CHAR(dpcode, 'FM00000') CODE,
    			TO_CHAR(dpcode, 'FM00000') ||' - '|| ltrim(rtrim(dplib)) LIB
    		FROM dossier_projet
            WHERE INSTR(l_doss_proj, TO_CHAR(-1, 'FM00000')) > 0;
   END IF;
END lister_dprojet_limitation_ref;

PROCEDURE lister_doss_proj_dep(	p_clicode  IN client_mo.clicode%TYPE,
				p_annee  IN VARCHAR2,
             			p_curseur IN OUT libBudAct_listeCurType
            ) IS
BEGIN
    OPEN p_curseur FOR
    	-- récupération des différents dossier projet du departement
    	-- et des eventuelles valeurs de budget deja saisies
	SELECT distinct dp.dpcode DPCODE,
		ltrim(rtrim(dp.dplib))    LIB,
		TO_CHAR(bdp.BUDGETHTR, 'FM9999999990D00') BUDACT
	FROM dossier_projet dp,
		ligne_bip lb,
		budget_dp bdp
	WHERE dp.ACTIF = 'O'
	and lb.CLICODE in (
		select clicoderatt
		from vue_clicode_hierarchie
		where clicode = p_clicode )
	and dp.DPCODE = lb.DPCODE
	and bdp.ANNEE (+)= p_annee
	and bdp.CLICODE (+)= p_clicode
	and bdp.DPCODE (+)= lb.DPCODE
    -- On retire les dossier projet provisoire 88xxx
        AND dp.dpcode NOT LIKE '88%'
	ORDER BY dp.dpcode;

EXCEPTION
       WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);
END lister_doss_proj_dep;

-- Méthode qui liste les dossiers projets pour la notification
-- HPPM 58337 : Ajout de la valeur "tous" en tête de liste et la sélectionner par défaut (dans jsp)
PROCEDURE lister_dprojet_notif(	p_userid  IN VARCHAR2,
             	       		p_curseur IN OUT lib_listeCurType) IS


BEGIN
   	OPEN p_curseur FOR
  	    -- ligne "Tous"
  	  --  SELECT 	' TOUS' CODE,
  	   -- 		'Tous' LIB
  	   -- FROM dual
  	   -- UNION
        	-- Ligne vide --
        	SELECT ' ' CODE,
        	       '' LIB
        	FROM DUAL
           	UNION
    		SELECT   TO_CHAR(dpcode, 'FM00000') CODE,
    			 TO_CHAR(dpcode, 'FM00000') ||' - '|| ltrim(rtrim(dplib))    LIB
    		FROM dossier_projet
    		WHERE actif = 'O'
    		AND dpcode <> 00000
    		-- On retire les dossier projet provisoire 88xxx
            AND dpcode NOT LIKE '88%'
    		ORDER BY CODE;

END lister_dprojet_notif;

PROCEDURE lister_dprojet_par_code01(p_userid  IN VARCHAR2,
             		p_curseur IN OUT lib_listeCurType
            ) IS
BEGIN
    OPEN p_curseur FOR
        -- Lignes en haut --
		SELECT  'AUCUN' CODE,
		        'Selectionnez un Dossier Projet'     LIB
        FROM DUAL
        UNION
        SELECT 'TOUS' CODE,
               'TOUS' LIB
        FROM DUAL
        UNION
    	SELECT DISTINCT  TO_CHAR(dpcode, 'FM00000') CODE,
    			 TO_CHAR(dpcode, 'FM00000') ||' - '|| ltrim(rtrim(dplib))    LIB
    	FROM dossier_projet
    	WHERE actif = 'O' or actif = 'N'
        -- On retire les dossier projet provisoire 88xxx
        AND dpcode NOT LIKE '88%'
    	ORDER BY CODE;

EXCEPTION
       WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);
END lister_dprojet_par_code01;

PROCEDURE lister_dprojet_par_code02(p_userid  IN VARCHAR2,
             		p_curseur IN OUT lib_listeCurType
            ) IS
BEGIN
    OPEN p_curseur FOR
        -- Lignes en haut --
		SELECT  'AUCUN' CODE,
		        'Selectionnez un Dossier Projet'     LIB
        FROM DUAL
        UNION
    	SELECT DISTINCT  TO_CHAR(dpcode, 'FM00000') CODE,
    			 TO_CHAR(dpcode, 'FM00000') ||' - '|| ltrim(rtrim(dplib))    LIB
    	FROM dossier_projet
    	WHERE actif = 'O' or actif = 'N'
        -- On retire les dossier projet provisoire 88xxx
        AND dpcode NOT LIKE '88%'
    	ORDER BY CODE;

EXCEPTION
       WHEN OTHERS THEN raise_application_error(-20997, SQLERRM);
END lister_dprojet_par_code02;

END pack_liste_dossier_projet;
/


