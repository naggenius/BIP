-- pack_liste_immeuble PL/SQL
--
-- EQUIPE SOPRA
--
-- cree le 15/02/1999
-- Objet : Permet la création de la liste des immeubles
-- Tables : immeuble
-- Pour le fichier HTML : dtimmeub

-- Modifie par PPR le 24/03/2006 : suppression de la ligne à blanc dans la liste

CREATE OR REPLACE PACKAGE pack_liste_immeuble AS

   PROCEDURE lister_immeuble(p_userid  IN VARCHAR2,
                             p_curseur IN OUT pack_liste_dynamique.liste_dyn
                            );

END pack_liste_immeuble;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_immeuble AS 

----------------------------------- SELECT -----------------------------------
   PROCEDURE lister_immeuble (p_userid  IN VARCHAR2,
                              p_curseur IN OUT pack_liste_dynamique.liste_dyn
                             ) IS
   BEGIN

      OPEN p_curseur FOR
      SELECT 
           icodimm,
           iadrabr
      FROM immeuble
      ORDER BY 2;

   EXCEPTION
      WHEN OTHERS THEN
        raise_application_error(-20997, SQLERRM);

   END lister_immeuble;

END pack_liste_immeuble;
/
