-- pack_liste_proj_spe PL/SQL
--
-- Equipe SOPRA
--
-- Crée le 24/02/1999
--
-- Objet  : Permet la création de la liste des projets spéciaux
-- Table  : proj_spe
-- Pour le fichier HTML : dtprjspc.htm
--
-- *****************************************************************************


-- Attention le nom du package ne peut etre le nom
-- de la table...
--

CREATE OR REPLACE PACKAGE pack_liste_proj_spe AS

   PROCEDURE lister_proj_spe(p_userid  IN VARCHAR2,
                             p_curseur IN OUT pack_liste_dynamique.liste_dyn
                            );
  
END pack_liste_proj_spe;
/


CREATE OR REPLACE PACKAGE BODY pack_liste_proj_spe AS 


  PROCEDURE lister_proj_spe(p_userid  IN VARCHAR2,
                             p_curseur IN OUT pack_liste_dynamique.liste_dyn
                            ) IS
   BEGIN

      OPEN p_curseur FOR 
 		SELECT codpspe,
             rpad( codpspe, 10, ' ') ||
             libpspe 
		FROM proj_spe
		UNION
		select ' ','           ' from proj_spe
		order by 1;

   END lister_proj_spe;

END pack_liste_proj_spe;
/
