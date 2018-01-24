-- pack_liste_niveau PL/SQL
--
-- cree le 12/09/2005
-- Objet : Permet la création de la liste des niveaux
-- Tables : niveau

-- Attention le nom du package ne peut etre le nom
-- de la table...
CREATE OR REPLACE PACKAGE pack_liste_niveau AS

   PROCEDURE lister_niveau(p_userid  IN VARCHAR2,
                             p_curseur IN OUT pack_liste_dynamique.liste_dyn
                            );

END pack_liste_niveau;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_niveau AS 

----------------------------------- SELECT -----------------------------------
   PROCEDURE lister_niveau (p_userid  IN VARCHAR2,
                              p_curseur IN OUT pack_liste_dynamique.liste_dyn
                             ) IS
   BEGIN

      OPEN p_curseur FOR
      SELECT '', 
             ' '
      FROM dual
    UNION
      SELECT 
           niveau,
           libniveau
      FROM niveau
      ORDER BY 2;

   EXCEPTION
      WHEN OTHERS THEN
        raise_application_error(-20997, SQLERRM);

   END lister_niveau;

END pack_liste_niveau;
/
