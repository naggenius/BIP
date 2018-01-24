-- pack_type_projet PL/SQL
--
-- Equipe SOPRA
--
-- Créé le 18/02/99
--
-- Modifié le 25/03/1999
--         Modification des n° de messages
--
-- *******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_type_projet AS

   TYPE type_projetCurType IS REF CURSOR RETURN type_projet%ROWTYPE;

  PROCEDURE insert_type_projet (p_typproj   IN type_projet.typproj%TYPE, 
                                p_libtyp    IN type_projet.libtyp%TYPE, 
                                p_global    IN CHAR,
                                p_nbcurseur OUT INTEGER,
                                p_message   OUT VARCHAR2
                                );

   PROCEDURE update_type_projet (p_typproj   IN type_projet.typproj%TYPE, 
                                 p_libtyp    IN type_projet.libtyp%TYPE,
                                 p_flaglock  IN NUMBER,
                                 p_global    IN CHAR,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                );

   PROCEDURE delete_type_projet (p_typproj   IN type_projet.typproj%TYPE,
                                 p_libtyp    IN type_projet.libtyp%TYPE,
                                 p_flaglock  IN NUMBER,
                                 p_global    IN CHAR,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
	   		              );

   PROCEDURE select_type_projet (p_typproj   IN type_projet.typproj%TYPE,
                                 p_global    IN CHAR,
                                 p_cursor    IN OUT type_projetCurType,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                );

END pack_type_projet;
/

CREATE OR REPLACE PACKAGE BODY pack_type_projet AS 

   PROCEDURE insert_type_projet (p_typproj   IN  type_projet.typproj%TYPE , 
                                 p_libtyp    IN  type_projet.libtyp%TYPE  ,
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
         INSERT INTO type_projet ( typproj,
                                   libtyp)
         VALUES ( p_typproj, 
                  p_libtyp);

      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN

            -- 'Code type existe déjà'	

	      pack_global.recuperer_message(20604,NULL,NULL,NULL,msg);
            raise_application_error( -20604, msg );
         
         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;

      -- 'Code type ' || p_libtyp|| ' créé'

	pack_global.recuperer_message( 6000, '%s1', p_libtyp, NULL, msg);
	p_message := msg;

   END insert_type_projet;


   PROCEDURE update_type_projet (p_typproj   IN type_projet.typproj%TYPE, 
                                 p_libtyp    IN type_projet.libtyp%TYPE,
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

         UPDATE type_projet 
         SET libtyp   = p_libtyp,    
             flaglock = decode( p_flaglock, 1000000, 0,
                                p_flaglock + 1)
         WHERE typproj  = p_typproj
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

         -- 'Code type ||p_libtyp|| modifié' 

         pack_global.recuperer_message( 6001, '%s1', p_libtyp, NULL, msg);
         p_message := msg;
      END IF;

   END update_type_projet;


   PROCEDURE delete_type_projet (p_typproj   IN type_projet.typproj%TYPE,
                                 p_libtyp    IN type_projet.libtyp%TYPE,
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
         DELETE FROM type_projet 
         WHERE typproj  = p_typproj
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

         -- 'Code type ||p_libtyp|| supprimé' 

	   pack_global.recuperer_message( 6002, '%s1', p_libtyp, NULL, msg);
         p_message := msg;
      END IF;

   END delete_type_projet;


   PROCEDURE select_type_projet (p_typproj   IN type_projet.typproj%TYPE,
                                 p_global    IN CHAR,
                                 p_cursor    IN OUT type_projetCurType,
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
           FROM type_projet
           WHERE typproj =  p_typproj;

      -- en cas absence
      -- 'Code Type p_typproj inexistant'

      pack_global.recuperer_message( 6003, '%s1', p_typproj, NULL, msg);
      p_message := msg;

   END select_type_projet;

END pack_type_projet;
/
