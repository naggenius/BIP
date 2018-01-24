-- pack_liste_profil PL/SQL
--
--
-- Objet  : Permet la création de la liste des profils
-- Table  : oui
-- 
--
--*********************************************************************
-- Modif 30/04/2004 KHA ajout ligne vide dans le curseur. 
--                      Supression des espaces en fin de valeur métier.
--*********************************************************************
-- Attention le nom du package ne peut etre le nom
-- de la table...
--
CREATE OR REPLACE PACKAGE pack_liste_profil AS


   TYPE profil_ListeViewType IS RECORD( id      lien_profil_actu.code_profil%TYPE,
   										filler lien_profil_actu.code_profil%TYPE );
   TYPE profil_listeCurType IS REF CURSOR RETURN profil_ListeViewType;
   
                           
  PROCEDURE lister_profil_actu(	p_userid  IN VARCHAR2,
  								p_code_actu  IN VARCHAR2,
                           		p_curseur IN OUT profil_listeCurType );

END pack_liste_profil;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_profil AS 


   PROCEDURE lister_profil_actu (	p_userid  IN VARCHAR2,
   									p_code_actu  IN VARCHAR2,
                            		p_curseur IN OUT profil_listeCurType)
	IS
	BEGIN
		OPEN
			p_curseur
		FOR 
      	SELECT
      		code_profil,
            code_profil
	FROM
		lien_profil_actu
    where
    	code_actu = to_number(p_code_actu)
	ORDER BY 2;

   END lister_profil_actu;

END pack_liste_profil;
/
