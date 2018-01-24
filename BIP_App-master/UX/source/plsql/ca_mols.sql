-- pack_liste_situation_logiciel PL/SQL
--
-- Equipe SOPRA 
-- cree le 15/03/1999
--
-- Objet : Permet la creation de la liste top amortissable dans top_amort
-- Tables : type_amort
-- Pour le fichier HTML : dccamo.htm


-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_top_amort AS

   PROCEDURE lister_top_amort(	p_userid  IN VARCHAR2,
             			p_curseur IN OUT pack_liste_dynamique.liste_dyn
            );

END pack_liste_top_amort;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_top_amort AS 

----------------------------------- SELECT -----------------------------------

   PROCEDURE lister_top_amort ( p_userid IN VARCHAR2,
               			p_curseur IN OUT pack_liste_dynamique.liste_dyn
              ) IS

   BEGIN

      OPEN p_curseur FOR SELECT
           ctopact,
           libamort
      FROM type_amort
       ORDER BY ctopact;

   EXCEPTION
       WHEN OTHERS THEN
          raise_application_error(-20997, SQLERRM); 

   END lister_top_amort;

END pack_liste_top_amort;
/
