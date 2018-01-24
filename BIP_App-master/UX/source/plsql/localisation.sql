create or replace PACKAGE PACK_LOCALISATION AS

   -- Définition curseur sur la table DATE_EFFET
   TYPE Localisation_ViewType IS RECORD ( codlocalisation   LOCALISATION.CODE_LOCALISATION%type,
                                          commentaire       LOCALISATION.COMMENTAIRE%type,
                                          libelle           LOCALISATION.LIBELLE%type                                          
                                          );

   TYPE Localisation_CurType_Char IS REF CURSOR RETURN Localisation_ViewType;


   PROCEDURE insert_Localisation (  p_codlocalisation  IN LOCALISATION.CODE_LOCALISATION%type,
                                    p_commentaire      IN LOCALISATION.COMMENTAIRE%type,
                                    p_libelle          IN LOCALISATION.LIBELLE%type,
                                    p_userid     	     IN VARCHAR2,
                                    p_nbcurseur        OUT INTEGER,
                                    p_message          OUT VARCHAR2
                                    );

	 PROCEDURE update_Localisation (p_codlocalisation   IN  LOCALISATION.CODE_LOCALISATION%type,
                                  p_commentaire       IN LOCALISATION.COMMENTAIRE%type,
                                  p_libelle           IN LOCALISATION.LIBELLE%type,
                                  p_userid     	      IN VARCHAR2,
                                  p_nbcurseur         OUT INTEGER,
                                  p_message           OUT VARCHAR2
                                  );

	 PROCEDURE delete_Localisation (p_codlocalisation   IN  LOCALISATION.CODE_LOCALISATION%type,
                                  p_userid            IN  VARCHAR2,
                                  p_nbcurseur         OUT INTEGER,
                                  p_message           OUT VARCHAR2
                                  );

	 PROCEDURE select_Localisation (p_codlocalisation     IN  LOCALISATION.CODE_LOCALISATION%type,
                                  p_userid     	        IN  VARCHAR2,
                                  p_curLocalisation     IN OUT Localisation_CurType_Char ,
                                  p_nbcurseur           OUT INTEGER,
                                  p_message             OUT VARCHAR2
                                  ) ;


END PACK_LOCALISATION;
/
create or replace
PACKAGE BODY PACK_LOCALISATION AS

  PROCEDURE insert_Localisation (   p_codlocalisation   IN LOCALISATION.CODE_LOCALISATION%type,
                                    p_commentaire       IN LOCALISATION.COMMENTAIRE%type,
                                    p_libelle           IN LOCALISATION.LIBELLE%type,
                                    p_userid     	      IN VARCHAR2,
                                    p_nbcurseur         OUT INTEGER,
                                    p_message           OUT VARCHAR2
                                    ) AS
  l_msg VARCHAR2(1024);
  l_count NUMBER;

  BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      SELECT COUNT(*)  INTO l_count  FROM LOCALISATION  WHERE code_localisation = p_codlocalisation;

      IF(l_count <> 0)THEN
    
            Pack_Global.recuperer_message(21184, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20958, l_msg );
    
      ELSE

      BEGIN
             INSERT INTO LOCALISATION ( code_localisation,
                                        commentaire,
                                        libelle)
                   VALUES ( UPPER(p_codlocalisation),
                            p_commentaire,
                            p_libelle);
        COMMIT;
    
        Pack_Global.recuperer_message( 21185, NULL, NULL, NULL, l_msg);
        p_message := l_msg;
    
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               Pack_Global.recuperer_message( 21178, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20001, l_msg );
         END;

	 END IF;
 
  END insert_Localisation;



  PROCEDURE update_Localisation ( p_codlocalisation   IN LOCALISATION.CODE_LOCALISATION%type,
                                  p_commentaire       IN LOCALISATION.COMMENTAIRE%type,
                                  p_libelle           IN LOCALISATION.LIBELLE%type,
                                  p_userid     	    IN VARCHAR2,
                                  p_nbcurseur       OUT INTEGER,
                                  p_message         OUT VARCHAR2
                                  ) AS
  l_msg VARCHAR2(1024);
  l_count NUMBER;

  BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
            UPDATE LOCALISATION
            SET	 --code_localisation = p_codlocalisation,
                 commentaire = p_commentaire,
                 libelle = p_libelle
            WHERE code_localisation = p_codlocalisation;
      EXCEPTION
         WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -21188, l_msg );
      END;
    
          IF SQL%NOTFOUND THEN
             -- 'Accès concurrent'
             Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20999, l_msg );
          ELSE     
               -- 'La date effet a été modifiée'
               Pack_Global.recuperer_message( 21186, NULL, NULL, NULL, l_msg);
               p_message := l_msg;
          END IF;
          
  END update_Localisation;



  PROCEDURE delete_Localisation ( p_codlocalisation   IN  LOCALISATION.CODE_LOCALISATION%type,
                                  p_userid            IN  VARCHAR2,
                                  p_nbcurseur         OUT INTEGER,
                                  p_message           OUT VARCHAR2
                                  ) AS
    l_msg VARCHAR2(1024);
    referential_integrity EXCEPTION;
	  l_count NUMBER;
    PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

    BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

     BEGIN
	   DELETE FROM LOCALISATION WHERE code_localisation = p_codlocalisation;

     EXCEPTION
		 WHEN referential_integrity THEN
		         Pack_Global.recuperer_message( 21179, NULL, NULL, NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20954, l_msg );

		 WHEN OTHERS THEN
				    RAISE_APPLICATION_ERROR( -21179, SQLERRM);
		 END;

     IF SQL%NOTFOUND THEN

	   -- 'Accès concurrent'

	    Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
      RAISE_APPLICATION_ERROR( -20999, l_msg );

      ELSE

	   -- ' p_codlocalisation a été supprimé'

	     Pack_Global.recuperer_message( 21187, NULL, NULL, NULL, l_msg);
	     p_message := l_msg;

      END IF;
      
  END delete_Localisation;

  PROCEDURE select_Localisation ( p_codlocalisation     IN  LOCALISATION.CODE_LOCALISATION%type,
                                  p_userid     	        IN  VARCHAR2,
                                  p_curLocalisation     IN OUT Localisation_CurType_Char ,
                                  p_nbcurseur           OUT INTEGER,
                                  p_message             OUT VARCHAR2
                                  )  AS
l_msg VARCHAR2(1024);

   BEGIN

        -- Positionner le nb de curseurs ==> 0
        -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         OPEN  p_curLocalisation FOR
              SELECT 	code_localisation,
                      commentaire,
                      libelle
              FROM  LOCALISATION
              WHERE code_localisation = p_codlocalisation;


          Pack_Global.recuperer_message( 21188, NULL, NULL, NULL, l_msg);
          p_message := l_msg;

      EXCEPTION

        WHEN OTHERS THEN

		  RAISE_APPLICATION_ERROR( -20997, SQLERRM);
  END;
 
  END select_Localisation;

END PACK_LOCALISATION;
/