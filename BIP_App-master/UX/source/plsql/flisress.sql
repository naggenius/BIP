-- pack_liste_resscont  PL/SQL
--
-- Equipe SOPRA
--
-- Cree le 15/11/1999
--
-- Objet : retourne la liste des ressources d'un contrat
-- Tables : ligne_cont , ressource
-- Pour le fichier HTML : acresfact
-- Pour la gestion de facture, on passe systématiquement 8 paramètres 
-- Keylist0 .. Keylist7
-- liste à retourner : ident      ligne_cont.ident%TYPE,
--                     rnom       ressource.rnom%TYPE,
--                     lccouact   ligne_cont.lccouact%TYPE
-- MODIF
-- PPR  04/07/2006 : Enlève table histo
-- EVI  20/04/2008 : TD 737
-- **********************************************************************
--

CREATE OR REPLACE PACKAGE pack_liste_resscont AS

   TYPE contress_RecType IS RECORD (clelc    VARCHAR2(6),
                                    liste    VARCHAR2(57));

   TYPE contress_CurType IS REF CURSOR RETURN contress_RecType;

   PROCEDURE lister_resscont (p_socfact IN facture.socfact%TYPE,
                              p_typfact IN facture.typfact%TYPE,
                              p_datfact IN VARCHAR2,
                              p_numfact IN facture.numfact%TYPE,
                              p_soccont IN contrat.soccont%TYPE,
                              p_cav     IN contrat.cav%TYPE,
                              p_numcont IN contrat.numcont%TYPE,
                              p_rnom    IN ressource.rnom%TYPE,
                              p_userid  IN VARCHAR2,
                              p_curseur IN OUT contress_CurType
                             );
END pack_liste_resscont;
/


CREATE OR REPLACE PACKAGE BODY     pack_liste_resscont AS

    PROCEDURE lister_resscont (p_socfact IN facture.socfact%TYPE,
                              p_typfact IN facture.typfact%TYPE,
                              p_datfact IN VARCHAR2,
                              p_numfact IN facture.numfact%TYPE,
                              p_soccont IN contrat.soccont%TYPE,
                              p_cav     IN contrat.cav%TYPE,
                              p_numcont IN contrat.numcont%TYPE,
                              p_rnom    IN ressource.rnom%TYPE,
                              p_userid  IN VARCHAR2,
                              p_curseur IN OUT contress_CurType
                             ) IS
    l_like_numcont  varchar2(16);
    l_like_rnom     varchar2(31);
    l_filcode       contrat.filcode%TYPE;

    BEGIN

      -- La largeur de la liste_resscont est limité à 28 caractères
      -- La clé cachée est l'identifiant
if p_numcont !='' or p_numcont is not null then
      OPEN p_curseur FOR
 	SELECT  TO_CHAR(r.ident,'FM99999') as CleR,
                TO_CHAR(r.ident,'99999') ||
                ' '  || RPAD(r.rnom,10) ||
                ' '  || LPAD(TO_CHAR(TRUNC(lc.lccouact),'FM99999D00'),8)   as Liste_RessCont
      FROM  ligne_cont lc, ressource r
      WHERE		  r.ident   =  lc.ident
            AND lc.soccont =  p_soccont
            AND lc.cav     =  lpad(NVL(p_cav,0),3,'0')
            AND lc.numcont =  p_numcont  ;

else	 /* FACTURES SANS CONTRAT*/
	OPEN p_curseur FOR
	SELECT distinct  TO_CHAR(r.ident,'FM99999') as CleR,
                TO_CHAR(r.ident,'99999') ||
                ' '  || RPAD(r.rnom,10) as Liste_RessCont
	FROM situ_ress s, ressource r
	WHERE  s.ident=r.ident
	  AND  s.soccode=p_socfact ;

 end if;

   END lister_resscont;



END pack_liste_resscont;
/


