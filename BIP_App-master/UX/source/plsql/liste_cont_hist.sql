--------------------------------------------------------
--  Fichier créé - lundi-octobre-10-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package PACK_LISTE_CONT_HIST
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "BIP"."PACK_LISTE_CONT_HIST" AS

   TYPE contrats_p_RecType IS RECORD (clelc    VARCHAR2(30),
                                      liste    VARCHAR2(57));

   TYPE contrats_p_CurType IS REF CURSOR RETURN contrats_p_RecType;


   PROCEDURE lister_cont_hist (p_socfact IN facture.socfact%TYPE,
                               p_typfact IN facture.typfact%TYPE,
                               p_datfact IN VARCHAR2,
                               p_numfact IN facture.numfact%TYPE,
                               p_soccont IN contrat.soccont%TYPE,
                               p_cav     IN contrat.cav%TYPE,
                               p_numcont IN contrat.numcont%TYPE,
                               p_rnom    IN ressource.rnom%TYPE,
                               p_userid  IN VARCHAR2,
                               p_curseur IN OUT contrats_p_CurType
                             );

-- Pour Procedure xcle_contrat(c_clelc,c_flaglib,c_numcont,c_cav,c_comcode,c_codsg);
--  Voir dans package  pack_liste_contrats.lister_contrats

END pack_liste_cont_hist;

 

/
--------------------------------------------------------
--  DDL for Package Body PACK_LISTE_CONT_HIST
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "BIP"."PACK_LISTE_CONT_HIST" AS


-- **************************************************************************************
--    Liste des contrats historisés
-- **************************************************************************************
    PROCEDURE lister_cont_hist (p_socfact IN facture.socfact%TYPE,
                              	p_typfact IN facture.typfact%TYPE,
                              	p_datfact IN VARCHAR2,
                              	p_numfact IN facture.numfact%TYPE,
                              	p_soccont IN contrat.soccont%TYPE,
                              	p_cav     IN contrat.cav%TYPE,
                              	p_numcont IN contrat.numcont%TYPE,
                              	p_rnom    IN ressource.rnom%TYPE,
                              	p_userid  IN VARCHAR2,
                              	p_curseur IN OUT contrats_p_CurType
                             ) IS

    l_like_numcont  varchar2(16);
    l_like_rnom     varchar2(31);
    l_filcode       contrat.filcode%TYPE;
    l_centre_frais  centre_frais.codcfrais%TYPE;

    BEGIN

        -- ========================================================================
        -- On recupere le code filiale et on prepare numcont et rnom en template
        -- ========================================================================
        l_filcode      := pack_global.lire_globaldata(p_userid).filcode;
        l_like_numcont := RTRIM(p_numcont) || '%' ;
        l_like_rnom    := RTRIM(p_rnom) || '%' ;

--       DBMS_OUTPUT.PUT_LINE('DEBUT ,' || l_like_numcont || ',' || l_like_rnom || ',' || l_filcode );

	-- ===================================================================
	-- On récupère le centre de frais de l'utilisateur
	-- ==================================================================
	l_centre_frais:=pack_global.lire_globaldata(p_userid).codcfrais;


        -- =============================================================
        -- La largeur de la liste_contrats est limité à 57 caractères
        -- cle = numcont(15)+cav(2)+comcode(11)+codsg(6)=34+3';'=37
        -- =============================================================
    IF l_centre_frais=0 then    -- le centre de frais 0 donne tout les droits à l'utilisateur

        OPEN p_curseur FOR

        SELECT  (RTRIM(c.numcont) || ';' || RTRIM(c.cav) || ';' || RTRIM(c.comcode) ||
            ';' || TO_CHAR(c.codsg,'FM0000000')) as Clelc,
            RPAD(c.numcont,15) ||
            ' '  || RPAD(c.cav,2) ||
            ' '  || TO_CHAR(r.ident,'99999') ||
            ' '  || RPAD(r.rnom,5) ||
            ' '  || NVL(TO_CHAR(lc.lresdeb,'ddmmyyyy'),'        ') ||
            ' '  || NVL(TO_CHAR(lc.lresfin,'ddmmyyyy'),'        ') ||
            ' '  || LPAD(TO_CHAR(TRUNC(lc.lccouact),'FM99999'),5)   as Liste_contrats
        FROM  histo_ligne_cont lc, histo_contrat c , ressource r
        WHERE   r.ident = lc.ident
            AND lc.soccont =  c.soccont
            AND lc.cav     =  c.cav
            AND lc.numcont =  c.numcont
            AND c.soccont  =  p_socfact
            AND c.filcode  =  l_filcode
            AND c.numcont like l_like_numcont
            AND r.rnom    like l_like_rnom
        ORDER BY Clelc;

    ELSE          -- seuls les contrats appartenant au centre de frais sont sélectionnés

	 OPEN p_curseur FOR

        SELECT  (RTRIM(c.numcont) || ';' || RTRIM(c.cav) || ';' || RTRIM(c.comcode) ||
            ';' || TO_CHAR(c.codsg,'FM0000000')) as Clelc,
            RPAD(c.numcont,15) ||
            ' '  || RPAD(c.cav,2) ||
            ' '  || TO_CHAR(r.ident,'99999') ||
            ' '  || RPAD(r.rnom,5) ||
            ' '  || NVL(TO_CHAR(lc.lresdeb,'ddmmyyyy'),'        ') ||
            ' '  || NVL(TO_CHAR(lc.lresfin,'ddmmyyyy'),'        ') ||
            ' '  || LPAD(TO_CHAR(TRUNC(lc.lccouact),'FM99999'),5)   as Liste_contrats
        FROM  histo_ligne_cont lc, histo_contrat c , ressource r
        WHERE   r.ident = lc.ident
            AND lc.soccont =  c.soccont
            AND lc.cav     =  c.cav
            AND lc.numcont =  c.numcont
            AND c.soccont  =  p_socfact
            AND c.filcode  =  l_filcode
            AND c.numcont like l_like_numcont
            AND r.rnom    like l_like_rnom
            AND c.ccentrefrais=l_centre_frais
        ORDER BY Clelc;



    END IF;
   END lister_cont_hist;


END pack_liste_cont_hist;

/
