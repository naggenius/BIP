-- pack_liste_dirmo PL/SQL
--
-- Philippe DARRACQ 
-- cree le 26/06/2000
--
-- Objet : Liste des directions Maitrise d'Ouvrage
-- Tables : directions
-- Pour le fichier HTML : dcclient.htm


-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_liste_dirmo AS

   PROCEDURE lister_dirmo(p_userid  IN VARCHAR2,
             		  p_curseur IN OUT pack_liste_dynamique.liste_dyn
            );
            
   PROCEDURE lister_dirmo_notif(p_userid  IN VARCHAR2,
             		  p_curseur IN OUT pack_liste_dynamique.liste_dyn
            );
   
   PROCEDURE lister_codmo_notif(p_dirmo IN VARCHAR2,
   				p_userid  IN VARCHAR2,
             		  	p_curseur IN OUT pack_liste_dynamique.liste_dyn
            );
  -- PPM 58337 : ajout d'une fonction de vérification si un string est un nombre
  FUNCTION is_number (p_string IN VARCHAR2) RETURN INT;			

END pack_liste_dirmo;
/

CREATE OR REPLACE PACKAGE BODY pack_liste_dirmo AS 

----------------------------------- SELECT -----------------------------------

   PROCEDURE lister_dirmo (p_userid  IN VARCHAR2,
               		   p_curseur IN OUT pack_liste_dynamique.liste_dyn
              ) IS

   BEGIN

      OPEN p_curseur FOR SELECT
           coddir,
           coddir||' - '||libbr||'/'||libdir
      FROM directions d, branches b
      WHERE d.codbr = b.codbr
      ORDER BY coddir;


   EXCEPTION
       WHEN OTHERS THEN
          raise_application_error(-20997, SQLERRM);

   END lister_dirmo;
   
   PROCEDURE lister_dirmo_notif (p_userid  IN VARCHAR2,
               		   p_curseur IN OUT pack_liste_dynamique.liste_dyn
              ) IS

   BEGIN

      OPEN p_curseur FOR   
       -- HPPM 58337 : Tri sur code direction
    --  SELECT 	' ' coddir,
  	--    		' ' libdir
  	--    FROM dual
  	 --   UNION
    --  SELECT
   --        to_char(coddir),
   --        coddir||' - '||libbr||'/'||libdir libdir
   --   FROM directions d, branches b
  --    WHERE d.codbr = b.codbr
  --    ORDER BY coddir;
      
      SELECT coddir, libdir FROM (      
          SELECT 	' ' coddir,
                ' ' libdir,
                0 toptri


            FROM dual
            UNION

          SELECT
               to_char(coddir),
               coddir||' - '||libbr||'/'||libdir libdir,
               coddir toptri
          FROM directions d, branches b
          WHERE d.codbr = b.codbr
        )
      ORDER BY toptri;
-- Fin HPPM 58337 : Tri sur code direction


   EXCEPTION
       WHEN OTHERS THEN
          raise_application_error(-20997, SQLERRM);

   END lister_dirmo_notif;


   PROCEDURE lister_codmo_notif (p_dirmo IN VARCHAR2,
   				p_userid  IN VARCHAR2,
               		   	p_curseur IN OUT pack_liste_dynamique.liste_dyn
              ) IS

   BEGIN

      OPEN p_curseur FOR
-- HPPM 58337 : Tri sur code direction
    --  SELECT 	' ' clicode,
  	--    	' ' libmo
  	--    FROM dual
  	--    UNION
    --  SELECT
    --       clicode,
    --       clicode ||' - '||clilib libmo
    --  FROM client_mo cm
   --   WHERE cm.clidir=p_dirmo
    --  ORDER BY clicode;
    --A revoir : tri par char et number
  --    SELECT clicode, libmo FROM (      

  --        SELECT 	' ' clicode,
  --            ' ' libmo,
  --              '0' toptri

   --         FROM dual
   --         UNION
   --       SELECT
   --            clicode,



  --             clicode ||' - '||clilib libmo,
    --           clicode toptri
    --      FROM client_mo cm
   --       WHERE cm.clidir=p_dirmo
   --     )
   --   ORDER BY toptri;
   --*****************************************************************************
   -- HPPM 58337 : fonction qui permet de faire un tri sur code direction de type char (les chaines de caractères en premiers puis les nombres)  
   -------------------------------------------------------------------------------
      
    SELECT clicode, libmo FROM (  
       SELECT 	' ' clicode,
              ' ' libmo,
                '0' toptri
            FROM dual
       UNION
          SELECT
               clicode,
               clicode ||' - '||clilib libmo,
               '1' toptri
          FROM client_mo cm
          WHERE cm.clidir=p_dirmo 
          AND is_number(clicode) = 0          
        UNION
          SELECT
               clicode,
               clicode ||' - '||clilib libmo,
               clicode toptri
          FROM client_mo cm
          WHERE cm.clidir=p_dirmo 
          AND is_number(clicode) = 1        
         )
         order by to_number(toptri);
         
-- Fin HPPM 58337 : Tri sur code direction



   EXCEPTION
       WHEN OTHERS THEN
          raise_application_error(-20997, SQLERRM);

   END lister_codmo_notif;
   
-- HPPM 58337 : création d'une fonction pour verifier si une chaine est de type number
FUNCTION is_number (p_string IN VARCHAR2)
     RETURN INT
      IS
         v_new_num NUMBER;
      BEGIN
         v_new_num := TO_NUMBER(p_string);
         RETURN 1;
      EXCEPTION
      WHEN VALUE_ERROR THEN
         RETURN 0;
END is_number;


END pack_liste_dirmo
;
/