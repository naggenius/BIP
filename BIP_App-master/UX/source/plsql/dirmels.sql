-- pack_liste_dirme PL/SQL
--
-- Philippe DARRACQ 
-- cree le 26/06/2000
--
-- Objet : Liste des directions Maitrise d'Oeuvre
-- Tables : directions
-- Pour le fichier HTML : dcpoles.htm

-- Modification :
--   03/11/2005 JMA : ajout lister_dirme_perimetre qui liste les directions ME suivant le périmètre de l'utilisateur
--   06/02/2007 Emmanuel VINATIER: Filtre de la liste des des direction sur le DPG
--   23/12/2010 CMA : QC 824 Ajouter le libellé de la branche dans la liste des directions
--   04/02/2011 CMA : Retour QC 824 changement de l'ordre de tri de la liste des directions et présentation différente des résultats

CREATE OR REPLACE PACKAGE pack_liste_dirme AS

   PROCEDURE lister_dirme(p_userid  IN VARCHAR2,
            		  p_curseur IN OUT pack_liste_dynamique.liste_dyn
            );

 PROCEDURE lister_dirme_notif(p_test IN VARCHAR2,
 				p_userid  IN VARCHAR2,
            		  	p_curseur IN OUT pack_liste_dynamique.liste_dyn
            );


-- -----------------------------------------------------------------
-- Liste les directions ME suivant le périmètre de l'utilisateur
-- -----------------------------------------------------------------
    PROCEDURE lister_dirme_perimetre( p_userid  IN VARCHAR2,
            		  				  p_curseur IN OUT pack_liste_dynamique.liste_dyn
            			  			);
END pack_liste_dirme;
/


CREATE OR REPLACE PACKAGE BODY     pack_liste_dirme AS

----------------------------------- SELECT -----------------------------------

   PROCEDURE lister_dirme (p_userid  IN  VARCHAR2,
               		   p_curseur IN OUT pack_liste_dynamique.liste_dyn
              ) IS

   BEGIN

      OPEN p_curseur FOR SELECT
           coddir,
           coddir||' - '||libbr||'/'||libdir
      FROM directions d, branches b
      WHERE d.codbr = b.codbr AND  topme = 1
      ORDER BY coddir;


   EXCEPTION
       WHEN OTHERS THEN
          raise_application_error(-20997, SQLERRM);

   END lister_dirme;

PROCEDURE lister_dirme_notif (p_test IN VARCHAR2,
				p_userid  IN  VARCHAR2,
               		   	p_curseur IN OUT pack_liste_dynamique.liste_dyn
              ) IS

   BEGIN
	IF p_test <> '3' THEN
      OPEN p_curseur FOR
      
 -- HPPM 58337 : Tri sur code direction
  --    SELECT 	' ' coddir,
  --	    		' ' libdir
  --	    FROM dual
  --    UNION
  	    -- ligne "Tous"
 -- 	    SELECT 	' TOUS' coddir,
  	--    		'Tous' libdir
  --	    FROM dual
  --	    UNION

   --    SELECT
  --         to_char(coddir),
   --        coddir||' - '||libbr||'/'||libdir
   --   FROM directions d, branches b
  --    WHERE d.codbr = b.codbr AND  topme = 1
 --     ORDER BY coddir;

      SELECT coddir, libdir FROM (
          SELECT  ' ' coddir,
                  ' ' libdir,
                    0 toptri
          FROM dual
        UNION
       -- ligne "Tous"
          SELECT  'TOUS' coddir,
                  'Tous' libdir,
                      0 toptri
          FROM dual
        UNION

          SELECT  to_char(coddir),
                  coddir||' - '||libbr||'/'||libdir,
                  coddir toptri
          FROM directions d, branches b
          WHERE d.codbr = b.codbr AND topme = 1
        )
      ORDER BY toptri;

ELSE
	OPEN p_curseur FOR
     -- SELECT 	' ' coddir,
  	--    		' ' libdir
  	--    FROM dual
   --   UNION
   --    SELECT
    --       to_char(coddir),
   --        coddir||' - '||libbr||'/'||libdir
  --    FROM directions d, branches b
   --   WHERE d.codbr = b.codbr AND  topme = 1
  --    ORDER BY coddir;
      
  SELECT coddir, libdir FROM (    
      SELECT 	' ' coddir,
  	    		' ' libdir,
              0 toptri
  	    FROM dual
      UNION
       SELECT
           to_char(coddir),
           coddir||' - '||libbr||'/'||libdir,
           coddir toptri
      FROM directions d, branches b
      WHERE d.codbr = b.codbr AND  topme = 1
              )
      ORDER BY toptri;
-- Fin HPPM 58337   
      
END IF;

   EXCEPTION
       WHEN OTHERS THEN
          raise_application_error(-20997, SQLERRM);

   END lister_dirme_notif;




-- -----------------------------------------------------------------
-- Liste les directions ME suivant le périmètre de l'utilisateur
-- -----------------------------------------------------------------
PROCEDURE lister_dirme_perimetre( p_userid  IN  VARCHAR2,
               		   			  p_curseur IN OUT pack_liste_dynamique.liste_dyn
              					) IS
    l_perime VARCHAR2(1000);
    l_dir    VARCHAR2(255);
	l_pos	 NUMBER;
BEGIN
   	-- Récupérer le périmètre de l'utilisateur
   	l_perime := pack_global.lire_globaldata(p_userid).perime ;
	l_dir := '';

	-- On fait une boucle pour récupérer les codes directions qu'on met dans la variable
	-- l_dir qui sera ensuite testée
	while (length(l_perime)>0)
	loop
		if (length(l_dir) > 0) then
		    l_dir := l_dir||','||substr(l_perime,3,2);
		else
			l_dir := substr(l_perime,3,2);
		end if;
	    l_perime := substr(l_perime,13);
	end loop;

	OPEN p_curseur FOR
       SELECT to_char(coddir),
		       coddir||' - '||libbr|| ' / ' ||libdir FROM (
         SELECT dir.coddir coddir, bra.libbr libbr, dir.libdir libdir FROM directions dir, branches bra
         WHERE ( (INSTR(l_dir, dir.coddir)>0) or (INSTR(l_dir,'00')>0) )
		   AND topme = 1
           AND dir.CODBR=bra.CODBR
         ORDER BY libbr,libdir);

EXCEPTION
   WHEN OTHERS THEN
       raise_application_error(-20997, SQLERRM);

END lister_dirme_perimetre;


END pack_liste_dirme;
/


