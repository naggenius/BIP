-- pack_sous_typo PL/SQL
--MMC
--

-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_sous_typo AS

   TYPE sous_typologieCurType IS REF CURSOR RETURN sous_typologie%ROWTYPE;

  PROCEDURE insert_sous_type (p_sous_type   IN sous_typologie.sous_type%TYPE, 
                                p_libsoustype    IN sous_typologie.libsoustype%TYPE, 
                                p_global    IN CHAR,
                                p_nbcurseur OUT INTEGER,
                                p_message   OUT VARCHAR2
                                );

   PROCEDURE update_sous_type (p_sous_type   IN sous_typologie.sous_type%TYPE, 
                                 p_libsoustype    IN sous_typologie.libsoustype%TYPE,
                                 p_flaglock  IN NUMBER,
                                 p_global    IN CHAR,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                );

   PROCEDURE delete_sous_type (p_sous_type   IN sous_typologie.sous_type%TYPE,
                                 p_libsoustype    IN sous_typologie.libsoustype%TYPE,
                                 p_flaglock  IN NUMBER,
                                 p_global    IN CHAR,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
	   		              );

   PROCEDURE select_sous_type (p_sous_type   IN sous_typologie.sous_type%TYPE,
                                 p_global    IN CHAR,
                                 p_cursor    IN OUT sous_typologieCurType,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                );

END pack_sous_typo;
/

CREATE OR REPLACE PACKAGE BODY pack_sous_typo AS 

   PROCEDURE insert_sous_type (p_sous_type   IN  sous_typologie.sous_type%TYPE , 
                                 p_libsoustype    IN  sous_typologie.libsoustype%TYPE  ,
                                 p_global    IN  CHAR,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                ) IS 
      msg VARCHAR(1024);
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN 	  
         INSERT INTO sous_typologie ( sous_type,
                                   libsoustype)
         VALUES ( p_sous_type, 
                  p_libsoustype);

      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN

            -- 'Code type existe déjà'	

	      pack_global.recuperer_message(21023,NULL,NULL,NULL,msg);
            raise_application_error( -21023, msg );
         
         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;

      -- 'Code type ' || p_libsoustype|| ' créé'

	pack_global.recuperer_message( 21024, '%s1', p_libsoustype, NULL, msg);
	p_message := msg;

   END insert_sous_type;


   PROCEDURE update_sous_type (p_sous_type   IN sous_typologie.sous_type%TYPE, 
                                 p_libsoustype    IN sous_typologie.libsoustype%TYPE,
                                 p_flaglock  IN NUMBER,
                                 p_global    IN CHAR,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                ) IS 
      msg VARCHAR(1024);
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
      
      BEGIN

         UPDATE sous_typologie 
         SET libsoustype   = p_libsoustype,    
             flaglock = decode( p_flaglock, 1000000, 0,
                                p_flaglock + 1)
         WHERE sous_type  = p_sous_type
         AND   flaglock = p_flaglock;

      EXCEPTION
         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN

	   -- 'Accès concurrent'
        
	   pack_global.recuperer_message( 20999, NULL, NULL, NULL, msg);
         raise_application_error( -20999, msg );                     

      ELSE

         -- 'Code type ||p_libsoustype|| modifié' 

         pack_global.recuperer_message( 21025, '%s1', p_libsoustype, NULL, msg);
         p_message := msg;
      END IF;

   END update_sous_type;


   PROCEDURE delete_sous_type (p_sous_type   IN sous_typologie.sous_type%TYPE,
                                 p_libsoustype    IN sous_typologie.libsoustype%TYPE,
                                 p_flaglock  IN NUMBER,
                                 p_global    IN CHAR,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                ) IS 
      msg VARCHAR(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT( referential_integrity, -2292);
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN 
         DELETE FROM sous_typologie 
         WHERE sous_type  = p_sous_type
         AND   flaglock = p_flaglock;

      EXCEPTION
         WHEN referential_integrity THEN

            -- habiller le msg erreur

            pack_global.recuperation_integrite(-2292);

         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN

	   -- 'Accès concurrent'
        
	   pack_global.recuperer_message(20999,NULL,NULL,NULL,msg);
         raise_application_error( -20999, msg );                     

      ELSE

         -- 'Code type ||p_libsoustype|| supprimé' 

	   pack_global.recuperer_message( 21026, '%s1', p_libsoustype, NULL, msg);
         p_message := msg;
      END IF;

   END delete_sous_type;


   PROCEDURE select_sous_type (p_sous_type   IN sous_typologie.sous_type%TYPE,
                                 p_global    IN CHAR,
                                 p_cursor    IN OUT sous_typologieCurType,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                ) IS 
      msg VARCHAR(1024);
   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      OPEN p_cursor FOR
           SELECT *
           FROM sous_typologie
           WHERE sous_type =  p_sous_type;

      -- en cas absence
      -- 'Code Sous Type inexistant'

      pack_global.recuperer_message( 21022, '%s1', p_sous_type, NULL, msg);
      p_message := msg;

   END select_sous_type;

END pack_sous_typo;
/
