-- pack_liste_ContRess  PL/SQL
--
-- Equipe SOPRA
--
-- Cree le 15/11/1999
--
-- Objet : retourne la Liste des Ressources d'un contrat pour page HTML atligcon.
-- Pour la gestion de contrat.
-- Keylist0 .. Keylist3.
-- Liste à afficher contient les champs suivants : 
--                     ident      ligne_cont.ident%TYPE,
--                     rnom       ressource.rnom%TYPE,
--                     rprenom       ressource.rnom%TYPE,
--                     lccouact   ligne_cont.lccouact%TYPE
--   modifié le 23/04/2009 TD 737 contrat 27+3
-- **********************************************************************
--

CREATE OR REPLACE PACKAGE pack_liste_ContRess AS

  TYPE LigCont_RecType IS RECORD (clelc    VARCHAR2(2),  -- cle ligne contrat
				  liste    VARCHAR2(100)); -- reste de ligne de la liste

  TYPE LigCont_CurType IS REF CURSOR RETURN LigCont_RecType;

PROCEDURE lister_ContRess (p_soccont   IN contrat.soccont%TYPE,
			   p_numcont   IN contrat.numcont%TYPE,
			   p_cav       IN contrat.cav%TYPE,
			   p_userid    IN VARCHAR2,
			   p_curseur   IN OUT LigCont_CurType
			  );
END pack_liste_ContRess;
/


CREATE OR REPLACE PACKAGE BODY     pack_liste_ContRess AS

PROCEDURE lister_ContRess(p_soccont   IN contrat.soccont%TYPE,
			  p_numcont   IN contrat.numcont%TYPE,
			  p_cav       IN contrat.cav%TYPE,
			  p_userid    IN VARCHAR2,
			  p_curseur   IN OUT LigCont_CurType
			 ) IS

BEGIN

   -- La largeur de la liste_RessCont est limité à 28 caractères
   -- La clé cachée est l'identifiant

   OPEN p_curseur FOR
     SELECT  TO_CHAR(lc.lcnum,'FM99') as CleR,
       TO_CHAR(r.ident,'99999') ||
       '  '  || substr(RPAD(r.rnom,20), 1, 20) ||
       '  '  || rpad(nvl(r.rprenom,' '),15) ||
       '  '  || lpad(TO_char((lc.lccouact),'FM99999990D00'),11)   as Liste_RessCont
       FROM  ligne_cont lc,
       ressource r
       WHERE r.ident    =  lc.ident
       AND lc.soccont =  p_soccont
       AND lc.cav     =  lpad(nvl(p_cav,'0'),3,'0')
       AND lc.numcont =  p_numcont
       ORDER BY lc.lcnum;

END lister_ContRess;

-- Pour Tester sous SQLPlus
-- > set serveroutput on
-- > var cur refcursor

-- > exec pack_liste_ContRess.lister_ContRess('','','SOPR','B980621424','01','S935709;;;;01;',:cur)

END pack_liste_ContRess;
/


-- exec  pack_liste_ContRess.lister_ContRess('SOPR','C1222', '01', 'S935709;;;;01;', :cur);
-- exec  pack_liste_ContRess.lister_ContRess('ADMI','98123', '00', 'S935709;;;;01;', :cur);

