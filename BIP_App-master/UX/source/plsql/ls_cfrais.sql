-- pack_liste_cfrais PL/SQL
-- 
-- cree le 08/01/2001 par NBM
--
-- Modifier le 24/06/2005 BAA (ajout de la procedure lister_centres_frais )
-- Modifier le 10/01/2006 BAA Probleme erreur oracle
--
-- Objet : Liste des centres de frais
-- Tables : centre_frais
-- Pour le fichier HTML : dcuser.htm


-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE Pack_Liste_Cfrais AS


  TYPE RefCurTyp IS REF CURSOR;



   PROCEDURE lister_cfrais(p_userid  IN VARCHAR2,
             		   p_curseur IN OUT Pack_Liste_Dynamique.liste_dyn
            );



   -- ------------------------------------------------------------------------
   --  BAA Le 24/06/2005
   -- Nom        : lister_centres_frais
   -- Auteur     : BAA
   -- Decription : cette methode
   -- Paramètres : p_centres_frais (IN)  contien la liste des codes des centres
   --              de frais separé par ,
   --              curseur (out)l  a date en cours
   --
   -- ------------------------------------------------------------------------



   PROCEDURE lister_centres_frais(p_centres_frais  IN VARCHAR2,
             		              p_curseur IN OUT RefCurTyp
                                 );



END Pack_Liste_Cfrais;
/





CREATE OR REPLACE PACKAGE BODY Pack_Liste_Cfrais AS

PROCEDURE lister_cfrais(p_userid  IN VARCHAR2,
	                p_curseur IN OUT Pack_Liste_Dynamique.liste_dyn
            ) IS

BEGIN
      OPEN p_curseur FOR
	SELECT ' '  AS codcfrais,
	       ' '
	FROM dual
	UNION
	SELECT
           TO_CHAR(codcfrais) AS codcfrais,
           RPAD(TO_CHAR(codcfrais),3,' ')||' '||libcfrais
	  FROM CENTRE_FRAIS
ORDER BY 1;

   EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20997, SQLERRM);

   END lister_cfrais;


  PROCEDURE lister_centres_frais(p_centres_frais  IN VARCHAR2,
             		              p_curseur IN OUT RefCurTyp
                                 ) IS
								 
								 
   str_query VARCHAR2(255);
   req                            VARCHAR2(800);
  

  BEGIN

    
		  req := ' SELECT TO_CHAR(CODCFRAIS) AS CODCFRAIS, '
		  || ' TO_CHAR(CODCFRAIS)||'' - ''||LIBCFRAIS AS LIBCFRAIS '
		  || ' FROM CENTRE_FRAIS '
		  || ' WHERE CODCFRAIS in ('|| p_centres_frais ||')  ' ;
		  
			    
 
        OPEN p_curseur FOR   req;  

			
		

   EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20997, SQLERRM);

   END lister_centres_frais;


END Pack_Liste_Cfrais;
/




