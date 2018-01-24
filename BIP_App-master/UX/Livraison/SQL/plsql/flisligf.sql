-- pack_liste_lignes_fact  PL/SQL
--
-- Equipe SOPRA
--
-- Cree le 29/10/1999
--
-- Objet : retourne la liste des Lignes de Facture associées à la facture
--
-- Tables : ligne_fact , ressource
--
-- Pour le fichier HTML : atligfac
--
-- Pour la gestion de facture, on passe systématiquement 8 paramètres 
-- Keylist0 .. Keylist7
-- La liste à retourner : ident      ligne_fact.ident%TYPE,
--                        rnom       ressource.rnom%TYPE,
--                        rprenom    ressource.rprenom%TYPE,
--                        lmontht    ligne_fact.lmontht%TYPE,
-- 10/01/2007 ASI  * Ajout des typdpg dans la liste
-- **********************************************************************
--
CREATE OR REPLACE PACKAGE Pack_Liste_Lignes_Fact AS

   TYPE lignes_fact_Type IS RECORD (clelf    VARCHAR2(71),
                                    liste    VARCHAR2(57));

   TYPE lignes_fact_Cur  IS REF CURSOR RETURN lignes_fact_Type;

   PROCEDURE lister_lignes_fact (p_socfact IN LIGNE_FACT.socfact%TYPE,
                                 p_typfact IN LIGNE_FACT.typfact%TYPE,
                              	 p_datfact IN VARCHAR2,
                              	 p_numfact IN LIGNE_FACT.numfact%TYPE,
                              	 p_soccont IN CONTRAT.soccont%TYPE,
                              	 p_cav     IN CONTRAT.cav%TYPE,
                               	 p_numcont IN CONTRAT.numcont%TYPE,
                              	 p_rnom    IN RESSOURCE.rnom%TYPE,
                              	 p_userid  IN VARCHAR2,
                              	 p_curseur IN OUT lignes_fact_Cur
                             );

   PROCEDURE xcle_ligne_fact  (c_clelf       IN VARCHAR2,  -- cle lister ligne facture
                               c_flaglib     IN NUMBER,    -- flag retourner valeur avec libellé ou non
                               c_lnum           OUT VARCHAR2,
                               c_ident          OUT VARCHAR2,
                               c_rnom           OUT VARCHAR2,
                               c_rprenom        OUT VARCHAR2,
                               c_lmontht        OUT VARCHAR2,
                               c_lmoisprest     OUT VARCHAR2,
                               c_lcodcompta     OUT VARCHAR2,
							   c_typdpg OUT CHAR
                              );
        -- La clé à extraire est longue de 70 car maxi et composée de
        -- lf.lnum(2);lf.ident(5);r.rnom(20);r.rprenom(15);lf.lmontht(11);lf.lmoisprest(7);lf.lcodcompta(11)


END Pack_Liste_Lignes_Fact;
/

CREATE OR REPLACE PACKAGE BODY Pack_Liste_Lignes_Fact IS

-- **************************************************************************************
-- **************************************************************************************
--
--  lister_lignes_fact
-- La clelf est longue de 70 car maxi et la liste 57 car/ligne
--
-- **************************************************************************************
-- **************************************************************************************

   PROCEDURE lister_lignes_fact (p_socfact IN LIGNE_FACT.socfact%TYPE,
                              	 p_typfact IN LIGNE_FACT.typfact%TYPE,
                              	 p_datfact IN VARCHAR2,
                              	 p_numfact IN LIGNE_FACT.numfact%TYPE,
                              	 p_soccont IN CONTRAT.soccont%TYPE,
                              	 p_cav     IN CONTRAT.cav%TYPE,
                              	 p_numcont IN CONTRAT.numcont%TYPE,
                              	 p_rnom    IN RESSOURCE.rnom%TYPE,
                              	 p_userid  IN VARCHAR2,
                              	 p_curseur IN OUT lignes_fact_Cur
                             ) IS

    l_filcode FILIALE_CLI.filcode%TYPE;

    BEGIN

        -- On recupere le code filiale et on prepare numcont et rnom en template
        l_filcode := Pack_Global.lire_globaldata(p_userid).filcode;

--  DBMS_OUTPUT.PUT_LINE('DEBUT ;' || p_socfact || ';' || p_typfact || ';' || p_datfact || ';' || p_numfact );

        -- La cle a retourner est longue de 70 car maxi et composée de
        -- lf.lnum(2);lf.ident(5);r.rnom(20);r.rprenom(15);lf.lmontht(11);lf.lmoisprest(7);lf.lcodcompta(11)

        OPEN p_curseur FOR
        SELECT (TO_CHAR(lf.lnum,'FM99') || ';' || TO_CHAR(lf.ident,'FM99999') || ';' || r.rnom || ';'
               || r.rprenom || ';' || TO_CHAR(lf.lmontht,'FM99999990D00') || ';'
               || TO_CHAR(lf.lmoisprest,'MM/YYYY') || ';' || lf.lcodcompta || ';' || DECODE(lf.typdpg,NULL,'C',lf.typdpg)  ) AS Clelf,
               (RPAD(TO_CHAR(lf.ident,'FM99999'),5,' ') ||
               '  ' || NVL(RPAD(r.rnom,20),'                    ') ||
               '  ' || NVL(RPAD(r.rprenom,15),'               ') ||
               ' ' || TO_CHAR(NVL(lf.lmontht,0),'99999990D00') ) AS "Liste Lignes de Facture"
        FROM LIGNE_FACT lf, RESSOURCE r
        WHERE   lf.ident   = r.ident
            AND lf.socfact = p_socfact
            AND lf.typfact = p_typfact
            AND lf.datfact = TO_DATE(p_datfact,'dd/mm/yyyy')
            AND lf.numfact = RPAD(p_numfact,15);

--        DBMS_OUTPUT.PUT_LINE('APRES SELECT') ;

   END lister_lignes_fact;


-- **************************************************************************************
-- **************************************************************************************
--
--  XCLE_LIGNE_FACT : retourne les infos de lignes facture
--                    contenues dans clelf de lister_lignes_fact
--         lf.lnum(2);lf.ident(5);r.rnom(20);r.rprenom(15)
--         ;lf.lmontht(11);lf.lmoisprest(7);lf.lcodcompta(11)
-- La clelf est longue de 70 car maxi
--
-- **************************************************************************************
-- **************************************************************************************

   PROCEDURE xcle_ligne_fact  (c_clelf       IN VARCHAR2,      -- cle lister ligne facture
                               c_flaglib     IN NUMBER,
                               c_lnum           OUT VARCHAR2,
                               c_ident          OUT VARCHAR2,
                               c_rnom           OUT VARCHAR2,
                               c_rprenom        OUT VARCHAR2,
                               c_lmontht        OUT VARCHAR2,
                               c_lmoisprest     OUT VARCHAR2,
                               c_lcodcompta     OUT VARCHAR2,
							   c_typdpg OUT CHAR
                              ) IS
   pos1   INTEGER;
   pos2   INTEGER;
   pos3   INTEGER;
   pos4   INTEGER;
   pos5   INTEGER;
   pos6   INTEGER;
   pos7   INTEGER;
   lgth   INTEGER;

   BEGIN
        pos1 := INSTR( c_clelf, ';', 1, 1);
        pos2 := INSTR( c_clelf, ';', 1, 2);
        pos3 := INSTR( c_clelf, ';', 1, 3);
        pos4 := INSTR( c_clelf, ';', 1, 4);
        pos5 := INSTR( c_clelf, ';', 1, 5);
        pos6 := INSTR( c_clelf, ';', 1, 6);
		pos7 := INSTR( c_clelf, ';', 1, 7);
        lgth := LENGTH( c_clelf);
DBMS_OUTPUT.PUT_LINE('longueur:'||lgth);
	IF c_flaglib = 1  THEN
        c_lnum       :=  SUBSTR( c_clelf, 1, pos1-1);
        c_ident      :=  SUBSTR( c_clelf, pos1+1, pos2-pos1-1);
        c_rnom       :=  SUBSTR( c_clelf, pos2+1, pos3-pos2-1);
        c_rprenom    :=  SUBSTR( c_clelf, pos3+1, pos4-pos3-1);
        c_lmontht    :=  SUBSTR( c_clelf, pos4+1, pos5-pos4-1);
        c_lmoisprest :=  SUBSTR( c_clelf, pos5+1, pos6-pos5-1);
		DBMS_OUTPUT.PUT_LINE('moisprest:'||c_lmoisprest||',code comp:'|| SUBSTR( c_clelf, pos6+1, lgth-pos6));
        c_lcodcompta := SUBSTR( c_clelf, pos6+1, pos7-pos6-1)  ;
		 c_typdpg :=  SUBSTR( c_clelf, pos7+1, lgth-pos7);
		ELSE
        c_lnum       := SUBSTR( c_clelf, 1, pos1-1);
        c_ident      := SUBSTR( c_clelf, pos1+1, pos2-pos1-1);
        c_rnom       := SUBSTR( c_clelf, pos2+1, pos3-pos2-1);
        c_rprenom    := SUBSTR( c_clelf, pos3+1, pos4-pos3-1);
        c_lmontht    := SUBSTR( c_clelf, pos4+1, pos5-pos4-1);
        c_lmoisprest := SUBSTR( c_clelf, pos5+1, pos6-pos5-1);
DBMS_OUTPUT.PUT_LINE('moisprest:'||c_lmoisprest );
		c_lcodcompta := SUBSTR( c_clelf, pos6+1, pos7-pos6-1)  ;
		 c_typdpg :=  SUBSTR( c_clelf, pos7+1, lgth-pos7);
		END IF;
   END xcle_ligne_fact;


END Pack_Liste_Lignes_Fact;
/
-- Pour Tester sous SQLPlus
-- > var vcur refcursor
-- > exec pack_liste_lignes_fact.lister_lignes_fact('SOPR','F','31/12/1997','971221430545','','','','','S935708;;;;01;',:vcur)
-- > exec pack_liste_lignes_fact.lister_lignes_fact('COM.','F','30/06/1998','094212','','','','','S935708;;;;01;',:vcur)
-- > exec pack_liste_lignes_fact.lister_lignes_fact('GFI.','F','31/08/1999','12099780264','','','','','S935708;;;;01;',:vcur)
-- > print vcur
