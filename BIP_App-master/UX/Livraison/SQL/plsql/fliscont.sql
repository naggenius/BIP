-- pack_liste_contrats  PL/SQL
--
-- Equipe SOPRA
--
-- Cree le 15/11/1999
--
-- Objet : retourne la liste des lignes de contrat recentes lister_contrats
--         avec recherche générique sur le NOM ou sur le N° CONTRAT
--         (pour lignes de contrat historisées voir pack_liste_cont_hist.lister_cont_hist)
--
--
-- Tables : contrat, ligne_cont , ressource
--
-- Pour le fichier HTML : atlscont.htm
--
-- Pour la gestion de facture, on passe systématiquement 8 paramètres 
-- Keylist0 .. Keylist7
--
-- liste à retourner : numcont, cav, ident, rnom, lresdeb, lresfin, lccouact
--  
-- Modifié le 21/12/2000 par NCM : ramener que les contrats du centre de frais de l'utilisateur
-- Modifié le 17/04/2009 par EVI : TD737 augmentation de la taille du numero de contrat + avenant 27+3
--
-- **********************************************************************

CREATE OR REPLACE PACKAGE pack_liste_contrats AS

   TYPE contrats_p_RecType IS RECORD (clelc    VARCHAR2(37),
                                      liste    VARCHAR2(57));

   TYPE contrats_p_CurType IS REF CURSOR RETURN contrats_p_RecType;

   PROCEDURE lister_contrats (p_socfact IN facture.socfact%TYPE,
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

   PROCEDURE xcle_contrat    (c_clelc       IN VARCHAR2,  -- cle lister contrat ou cont hist
                              c_flaglib     IN NUMBER,    -- flag retourner valeur avec libellé ou non
                              c_numcont        OUT VARCHAR2,
                              c_cav            OUT VARCHAR2,
                              c_comcode        OUT VARCHAR2,
                              c_codsg          OUT VARCHAR2
                             );


END pack_liste_contrats;
/


CREATE OR REPLACE PACKAGE BODY     pack_liste_contrats AS

    PROCEDURE lister_contrats (p_socfact IN facture.socfact%TYPE,
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

    l_like_numcont  varchar2(30);
    l_like_rnom     varchar2(31);
    l_filcode       contrat.filcode%TYPE;
    l_centre_frais  centre_frais.codcfrais%TYPE;
    p_where 	    varchar2(50);
    BEGIN

        -- ========================================================================
        -- On recupere le code filiale et on prepare numcont et rnom en template
        -- ========================================================================
        l_filcode      := pack_global.lire_globaldata(p_userid).filcode;
        l_like_numcont := RTRIM(p_numcont) || '%' ;
        l_like_rnom    := RTRIM(p_rnom) || '%' ;

	-- ===================================================================
	-- On récupère le centre de frais de l'utilisateur
	-- ==================================================================
	l_centre_frais:=pack_global.lire_globaldata(p_userid).codcfrais;

	-- =============================================================
        -- La largeur de la liste_contrats est limité à 57 caractères
        -- cle = numcont(15)+cav(2)+comcode(11)+codsg(6)=34+3';'=37
        -- =============================================================

    IF l_centre_frais=0 then    -- le centre de frais 0 donne tous les droits à l'utilisateur

         OPEN p_curseur FOR

        SELECT  (RTRIM(c.numcont) || ';' || RTRIM(c.cav) || ';' || RTRIM(c.comcode) ||
          ';' || c.codsg)  as Clelc,
            RPAD(c.numcont,27) ||
            ' '  || DECODE(c.top30,'O',DECODE(c.cav,'000','   ',RPAD(c.cav,3)),'N',RPAD(SUBSTR(c.cav,2,2),3) ) ||
            ' '  || TO_CHAR(r.ident,'99999') ||
            ' '  || RPAD(r.rnom,5) ||
            ' '  || NVL(TO_CHAR(lc.lresdeb,'ddmmyyyy'),'        ') ||
            ' '  || NVL(TO_CHAR(lc.lresfin,'ddmmyyyy'),'        ') ||
            ' '  || LPAD(TO_CHAR(TRUNC(lc.lccouact),'FM99999'),5)   as Liste_contrats
        FROM  ligne_cont lc, contrat c , ressource r
        WHERE   r.ident = lc.ident
            AND lc.soccont =  c.soccont
            AND lc.cav     =  c.cav
            AND lc.numcont =  c.numcont
            AND c.soccont  =  p_socfact
            AND c.filcode  =  l_filcode
            AND c.numcont like l_like_numcont
            AND r.rnom    like l_like_rnom
        ORDER BY Clelc;
    ELSE       -- seuls les contrats appartenant au centre de frais sont sélectionnés
	OPEN p_curseur FOR

        SELECT  (RTRIM(c.numcont) || ';' || RTRIM(c.cav) || ';' || RTRIM(c.comcode) ||
          ';' || c.codsg)  as Clelc,
            RPAD(c.numcont,27) ||
            ' '  || DECODE(c.top30,'O',DECODE(c.cav,'000','   ',RPAD(c.cav,3)),'N',RPAD(SUBSTR(c.cav,2,2),3) ) ||
            ' '  || TO_CHAR(r.ident,'99999') ||
            ' '  || RPAD(r.rnom,5) ||
            ' '  || NVL(TO_CHAR(lc.lresdeb,'ddmmyyyy'),'        ') ||
            ' '  || NVL(TO_CHAR(lc.lresfin,'ddmmyyyy'),'        ') ||
            ' '  || LPAD(TO_CHAR(TRUNC(lc.lccouact),'FM99999'),5)   as Liste_contrats
        FROM  ligne_cont lc, contrat c , ressource r
        WHERE   r.ident = lc.ident
            AND lc.soccont =  c.soccont
            AND lc.cav     =  c.cav
            AND lc.numcont =  c.numcont
            AND c.soccont  =  p_socfact
            AND c.filcode  =  l_filcode
            AND c.numcont like l_like_numcont
            AND r.rnom    like l_like_rnom
	    AND c.ccentrefrais = l_centre_frais
        ORDER BY Clelc;

    END IF;

   END lister_contrats;


-- **************************************************************************************
--    Extraire les infos de la cle Lister contrats ou contrats historisés
-- **************************************************************************************
   PROCEDURE xcle_contrat    (c_clelc       IN VARCHAR2,  -- cle lister contrat ou cont hist
                              c_flaglib     IN NUMBER,    -- flag retourner valeur avec libellé ou non
                              c_numcont        OUT VARCHAR2,
                              c_cav            OUT VARCHAR2,
                              c_comcode        OUT VARCHAR2,
                              c_codsg          OUT VARCHAR2
                             ) IS

      pos1   integer;
      pos2   integer;
      pos3   integer;
      lgth   integer;
   BEGIN
      pos1 := INSTR( c_clelc, ';', 1, 1);
      pos2 := INSTR( c_clelc, ';', 1, 2);
      pos3 := INSTR( c_clelc, ';', 1, 3);
      lgth := LENGTH( c_clelc);

      IF c_flaglib = 1 THEN
         BEGIN
           c_numcont    := 'NUMCONT#' || substr( c_clelc, 1, pos1-1);
           c_cav        := 'CAV#'     || substr( c_clelc, pos1+1, pos2-pos1-1);
           c_comcode    := 'COMCODE#' || substr( c_clelc, pos2+1, pos3-pos2-1);
           c_codsg      := 'CODSG#'   || substr( c_clelc, pos3+1, lgth-pos3);


         END;
      ELSE
         BEGIN
           c_numcont    := substr( c_clelc, 1, pos1-1);
           c_cav        := substr( c_clelc, pos1+1, pos2-pos1-1);
           c_comcode    := substr( c_clelc, pos2+1, pos3-pos2-1);
           c_codsg      := substr( c_clelc, pos3+1, lgth-pos3);
         END;
      END IF;

   END xcle_contrat;

END pack_liste_contrats;
/


