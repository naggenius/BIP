-- pack_liste_direction PL/SQL
--
-- Equipe SOPRA 
-- cree le 15/03/1999
--
-- Objet : Permet la creation de la liste des changements de direction
-- Tables : client_mo, userbip
-- Pour le fichier HTML : ctmajdir.htm
--
-- Modifie le 12/06/2003 Pierre JOSSE
--			 Changement de table de référence : detail_perimetre_mo a été supprimée
--			 Pour trouver les codes Client MO correspondants au perimetre du user,
--			 On utilise la vue vue_clicode_perimo
--			 Mise à jour du nouveau format clicode(les deux premiers char ne sont plus la dir)
--	    le 02/12/2003 (NBM)ne pas prendre les clicodes fermés (fiche 212)
-- le 11/05/2011 CMA fiche 1176 pour le mnu client on utilise perimcli, pas perimo
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_direction AS

   PROCEDURE lister_direction(  p_userid  IN VARCHAR2,
             			p_curseur IN OUT pack_liste_dynamique.liste_dyn
            );

   PROCEDURE lister_dir_prin(  p_userid  IN VARCHAR2,
             			p_curseur IN OUT pack_liste_dynamique.liste_dyn
            );  --PPM 59288 : recupère la liste des branches et directions principales
            
END pack_liste_direction;
/


CREATE OR REPLACE PACKAGE BODY     pack_liste_direction AS

----------------------------------- SELECT -----------------------------------

   PROCEDURE lister_direction ( p_userid  IN VARCHAR2,
               			p_curseur IN OUT pack_liste_dynamique.liste_dyn
              ) IS

   l_perimo VARCHAR2(1000);
   l_menu VARCHAR2(25);

   BEGIN
      
      l_menu := pack_global.lire_globaldata(p_userid).menutil;
	
		if('MO'=l_menu)then
			l_perimo := pack_global.lire_globaldata(p_userid).perimcli;
		else
			l_perimo := pack_global.lire_globaldata(p_userid).perimo;
		end if;

      BEGIN
         OPEN  p_curseur FOR
         SELECT DISTINCT LPAD(RTRIM(LTRIM(c.clicode)), 5, '0') AS clicode,
         	c.clicode||' - '||nvl(c.clisigle,'')
         FROM client_mo c, vue_clicode_perimo cpmo
         WHERE c.clicode = cpmo.clicode
           AND (INSTR(l_perimo, cpmo.bdclicode) > 0)
           AND c.clitopf='O'
	 ORDER BY 1;



      EXCEPTION

          WHEN OTHERS THEN
             raise_application_error(-20997, SQLERRM);
      END;

   END lister_direction;
   
   -- PPM 59288 - Elargissement de la notion de DP
   --**********************************
   --     Procédure pour récuperer la liste des branches et directions principales
   PROCEDURE lister_dir_prin ( p_userid  IN VARCHAR2,
               			p_curseur IN OUT pack_liste_dynamique.liste_dyn
              ) IS



   BEGIN

      BEGIN
         OPEN  p_curseur FOR
          SELECT null id, --QC 1657
          'Choisir une valeur...' libelle --QC 1657  : ajout d'un libellé fictif dans tous les cas "créer" et "modifier"
          FROM DUAL
          UNION
         SELECT dr.coddir id ,
         RPAD(TO_CHAR(br.codbr, 'FM00'), 3, ' ')  || RPAD(br.libbr , 5, ' ') || RPAD( ' : Direction',13,' ') || RPAD(TO_CHAR(dr.coddir, 'FM00'),3,' ') || dr.libdir libelle
        FROM branches br, directions dr
        WHERE  br.CODBR = dr.CODBR
        ORDER BY libelle,id;
        --ORDER BY br.codbr,dr.coddir;

      EXCEPTION

          WHEN OTHERS THEN
             raise_application_error(-20997, SQLERRM);
      END;
  END lister_dir_prin;
 

END pack_liste_direction;
/





