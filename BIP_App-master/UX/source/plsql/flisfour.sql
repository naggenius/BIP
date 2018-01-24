-- pack_liste_fournisseur  PL/SQL
--
-- Equipe SOPRA
--
-- Cree le 5/11/1999
--
-- Objet : retourne la liste des fournisseurs (agence)
-- Tables : agence 
-- Pour le fichier HTML : dtfact
-- Pour la gestion de facture, on passe systématiquement 8 paramètres 
-- Keylist0 .. Keylist7
-- liste à retourner : clélf = agence.socfour%TYPE
--                     liste = agence.socfour%TYPE,
--                             agence.socflib%TYPE,
-- **********************************************************************
--

CREATE OR REPLACE PACKAGE pack_liste_fournisseur AS

   TYPE agence_p_RecType IS RECORD (clelf    VARCHAR2(11),
                                    liste    VARCHAR2(37));

   TYPE agence_p_CurType IS REF CURSOR RETURN agence_p_RecType;

   PROCEDURE lister_fournisseur (p_socfact IN facture.socfact%TYPE,
                              	 p_typfact IN facture.typfact%TYPE,
                              	 p_datfact IN VARCHAR2,
                              	 p_numfact IN facture.numfact%TYPE,
                              	 p_soccont IN contrat.soccont%TYPE,
                              	 p_cav     IN contrat.cav%TYPE,
                              	 p_numcont IN contrat.numcont%TYPE,
                              	 p_rnom    IN ressource.rnom%TYPE,
                             	 p_userid  IN VARCHAR2,
                             	 p_curseur IN OUT agence_p_CurType
                             );
END pack_liste_fournisseur;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_fournisseur AS 

    PROCEDURE lister_fournisseur (p_socfact IN facture.socfact%TYPE,
                             	  p_typfact IN facture.typfact%TYPE,
                            	  p_datfact IN VARCHAR2,
                            	  p_numfact IN facture.numfact%TYPE,
                            	  p_soccont IN contrat.soccont%TYPE,
                            	  p_cav     IN contrat.cav%TYPE,
                            	  p_numcont IN contrat.numcont%TYPE,
                            	  p_rnom    IN ressource.rnom%TYPE,
                            	  p_userid  IN VARCHAR2,
                            	  p_curseur IN OUT agence_p_CurType
                             ) IS
                                 
    BEGIN
        -- On recupere le code filiale et on prepare numcont et rnom en template

--       DBMS_OUTPUT.PUT_LINE('DEBUT ,' || l_like_numcont || ',' || l_like_rnom || ',' || l_filcode );
        
         -- La largeur de la liste_fournisseur est limité à 33 caractères????????
        OPEN p_curseur FOR 
        SELECT  RPAD(a.socfour,10) as Clelf,
                RPAD(a.socfour,10) || ' ' || RPAD(a.socflib,25) as Liste_fournisseur
        FROM  agence a
        WHERE   a.soccode =  p_socfact 
        ORDER BY Clelf;
        
   END lister_fournisseur;

-- Pour Tester sous SQLPlus
-- > set serveroutput on
-- > var vcur refcursor
-- > set autoprint on
-- > exec pack_liste_fournisseur.lister_fournisseur('SOPR','F','10201999','TOTO','','','','LE','S935708;;;;01;',:vcur)
-- > exec pack_liste_fournisseur.lister_fournisseur('ADMI','','','','','' ,'B980','','S935708;;;;01;',:vcur)
-- > print vcur

END pack_liste_fournisseur;
/
