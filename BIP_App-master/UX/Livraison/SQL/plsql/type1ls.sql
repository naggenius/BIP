-- pack_liste_type_projet PL/SQL
-- Equipe SOPRA
-- Crée le 16/06/2004
--
-- Objet  : Permet la création de la liste des types de projets 
--          des projets 
-- Table  : type_projets
--
--*********************************************************************

CREATE OR REPLACE PACKAGE pack_liste_type_projet AS
   TYPE Projet_ListeViewType IS RECORD( id      type_projet.typproj%TYPE,
					libelle VARCHAR2(33)       
                                        );
   TYPE projet_listeCurType IS REF CURSOR RETURN Projet_ListeViewType;

   PROCEDURE lister_type_projet  (p_userid  IN VARCHAR2,
                                  p_curseur IN OUT projet_listeCurType
                                 );
END pack_liste_type_projet;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_type_projet AS 

   PROCEDURE lister_type_projet (p_userid  IN VARCHAR2,
                                 p_curseur IN OUT projet_listeCurType
                                ) IS
   BEGIN

      OPEN p_curseur FOR 
        -- Ligne vide en haut
        SELECT '', 
               ' ' libelle
        FROM dual
        UNION
        SELECT typproj,
               rpad( typproj, 3, ' ') || libtyp libelle
	FROM type_projet
	ORDER BY libelle;

   END lister_type_projet;

END pack_liste_type_projet;
/
