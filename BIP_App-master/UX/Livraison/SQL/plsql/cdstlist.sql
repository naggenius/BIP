-- pack_liste_code_statut PL/SQL
--
-- Equipe SOPRA 
-- cree le 26/03/1999
--
-- Objet : Permet la creation de la liste code statut dans MAJ statut
-- Tables : code_statut
-- Pour le fichier HTML : dmstbip.htm
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_code_statut AS

   PROCEDURE lister_statuts_ligne_bip(p_userid IN VARCHAR2,
             			p_curseur IN OUT pack_liste_dynamique.liste_dyn
            );

   PROCEDURE lister_statuts_projet(p_userid IN VARCHAR2,
             			p_curseur IN OUT pack_liste_dynamique.liste_dyn
            );

END pack_liste_code_statut;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_code_statut AS

----------------------------------- SELECT -----------------------------------
   PROCEDURE lister_statuts_ligne_bip (p_userid  IN VARCHAR2,
               			 p_curseur IN OUT pack_liste_dynamique.liste_dyn
              ) IS

   BEGIN

      OPEN p_curseur FOR

      -- Sélection des intitulés
      SELECT
           astatut,
           libstatut
      FROM code_statut
      UNION
      -- Permet d'afficher le vide
      SELECT '', 'Pas de statut'
      FROM DUAL;


   EXCEPTION
       WHEN OTHERS THEN
          raise_application_error(-20997, SQLERRM);

   END lister_statuts_ligne_bip;



   PROCEDURE lister_statuts_projet (p_userid  IN VARCHAR2,
               			 p_curseur IN OUT pack_liste_dynamique.liste_dyn
              ) IS

   BEGIN

      OPEN p_curseur FOR
      SELECT
           astatut,
           libstatut
      FROM code_statut
      WHERE astatut IN ('O','A','D','N','Q','R')
      UNION
      -- Permet d'afficher le vide
      SELECT '', 'Pas de statut'
      FROM DUAL;

   EXCEPTION
       WHEN OTHERS THEN
          raise_application_error(-20997, SQLERRM);

   END lister_statuts_projet;

END pack_liste_code_statut;
/
