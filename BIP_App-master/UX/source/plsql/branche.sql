-- pack_branche PL/SQL
--
-- Equipe SOPRA
--
-- Cree le 10/02/1999
--
-- Attention le nom du package ne peut etre le nom
-- Modifié Le 01/02/2006  par BAA Ajout de la procedure lister_direction
-- Modifié le 09/07/2008 par TD 600 ABA ajout du libelle de la branche dans la liste des directions
-- de la table...


CREATE OR REPLACE PACKAGE Pack_Liste_Branche AS

TYPE branche_Type IS RECORD (codbr		NUMBER(2),
                  	     libbr 		VARCHAR2(30)
				);

      TYPE brancheCurType IS REF CURSOR RETURN branche_Type;

PROCEDURE lister_branche (p_userid     IN VARCHAR2,
                          p_curbranche IN OUT brancheCurType,
			  p_nbcurseur  OUT INTEGER,
                          p_message    OUT VARCHAR2
                       );


TYPE direction_Type IS RECORD (coddir		NUMBER(2),
                  	       		  						  	 			   libdir 		VARCHAR2(30)
																		  );

      TYPE directionCurType IS REF CURSOR RETURN direction_Type;

PROCEDURE lister_direction (p_userid                 IN VARCHAR2,
                         			   	  		   		   p_curdirection        IN OUT directionCurType
			  											   );


END Pack_Liste_Branche;
/





CREATE OR REPLACE PACKAGE BODY Pack_Liste_Branche AS

PROCEDURE lister_branche (p_userid     IN VARCHAR2,
                          p_curbranche IN OUT brancheCurType,
			  p_nbcurseur  OUT INTEGER,
                          p_message    OUT VARCHAR2
                      ) IS

     l_msg VARCHAR(1024);

   BEGIN

      BEGIN
         OPEN p_curbranche FOR
		SELECT
			codbr,
			libbr
		FROM BRANCHES
		;

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;

   END lister_branche;


PROCEDURE lister_direction (p_userid                 IN VARCHAR2,
                         			   	  		   		   p_curdirection        IN OUT directionCurType
			  											   ) IS

    l_msg VARCHAR(1024);

   BEGIN

      BEGIN
         OPEN p_curdirection FOR
		  SELECT '',
                            ' ' libdir
         FROM         DIRECTIONS
         UNION
        SELECT
             TO_CHAR(coddir),
             b.libbr || '/' || d.libdir libdir
        FROM DIRECTIONS d, BRANCHES b
        WHERE
            d.CODBR = b.CODBR
        ORDER BY libdir;


      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;

   END lister_direction;



END Pack_Liste_Branche;
/
