-- pack_proj_spe PL/SQL
--
-- Equipe SOPRA
--
-- Créé le 18/02/99
--
--
--
-- *****************************************************************************

-- Attention le nom du package ne peut etre le nom
-- de la table..

CREATE OR REPLACE PACKAGE pack_proj_spe AS

   TYPE proj_speCurType IS REF CURSOR RETURN proj_spe%ROWTYPE;

   PROCEDURE insert_proj_spe (p_codpspe   IN proj_spe.codpspe%TYPE, 
                              p_libpspe   IN proj_spe.libpspe%TYPE,
                              p_global    IN VARCHAR2,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                             );

   PROCEDURE update_proj_spe (p_codpspe   IN  proj_spe.codpspe%TYPE, 
                              p_libpspe   IN  proj_spe.libpspe%TYPE,
                              p_flaglock  IN  NUMBER,
                              p_global    IN  VARCHAR2,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                             );

   PROCEDURE delete_proj_spe (p_codpspe   IN  proj_spe.codpspe%TYPE, 
                              p_libpspe   IN  proj_spe.libpspe%TYPE,
                              p_flaglock  IN  NUMBER,
                              p_global    IN  VARCHAR2,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
	   		           );

   PROCEDURE select_proj_spe (p_codpspe   IN proj_spe.codpspe%TYPE ,     
                              p_global    IN VARCHAR2,
                              p_cursor    IN OUT proj_speCurType,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                             );

END pack_proj_spe;
/

CREATE OR REPLACE PACKAGE BODY pack_proj_spe AS 

   PROCEDURE insert_proj_spe (p_codpspe   IN  proj_spe.codpspe%TYPE , 
                              p_libpspe   IN  proj_spe.libpspe%TYPE ,
                              p_global    IN  VARCHAR2,
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
         INSERT INTO proj_spe ( codpspe, 
                                libpspe)
         VALUES ( p_codpspe, 
                  p_libpspe);

         -- 'Projet spécial ' || p_libpspe|| ' créé'

         pack_global.recuperer_message( 6005, '%s1', p_libpspe, NULL, msg);
         p_message := msg;

      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
		
	      -- 'Projet spécial existe déjà'

            pack_global.recuperer_message( 20609, NULL, NULL, NULL, msg);
            raise_application_error( -20609, msg );

         WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END;

   END insert_proj_spe;


   PROCEDURE update_proj_spe (p_codpspe   IN  proj_spe.codpspe%TYPE , 
                              p_libpspe   IN  proj_spe.libpspe%TYPE ,
                              p_flaglock  IN  NUMBER,
                              p_global    IN  VARCHAR2,
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
         UPDATE proj_spe
         SET codpspe  = p_codpspe,
             libpspe  = p_libpspe,    
             flaglock = decode( p_flaglock, 1000000, 0, p_flaglock + 1)
         WHERE codpspe  = p_codpspe
         AND   flaglock = p_flaglock;

      EXCEPTION
	WHEN OTHERS THEN
          raise_application_error( -20999,msg);
      END;

      IF SQL%NOTFOUND THEN

         -- 'Accès concurrent'

	   pack_global.recuperer_message( 20999, NULL, NULL, NULL, msg);
         raise_application_error( -20999, msg );                     

      ELSE

         -- 'Projet spécial '|| p_libpspe||' modifié'

         pack_global.recuperer_message( 6006, '%s1', p_libpspe, NULL, msg);
         p_message := msg;
      END IF;

   END update_proj_spe;


   PROCEDURE delete_proj_spe (p_codpspe   IN  proj_spe.codpspe%TYPE ,
                              p_libpspe   IN  proj_spe.libpspe%TYPE ,
                              p_flaglock  IN  NUMBER,
                              p_global    IN  VARCHAR2,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                             ) IS 
      msg VARCHAR(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         DELETE FROM proj_spe 
         WHERE codpspe = p_codpspe
         AND  flaglock = p_flaglock;

      EXCEPTION
         WHEN referential_integrity THEN

            -- habiller le msg erreur

            pack_global.recuperation_integrite(-2292);

         WHEN OTHERS THEN
            raise_application_error( -20999,msg);
      END;

      IF SQL%NOTFOUND THEN

	   -- 'Accès concurrent'

	   pack_global.recuperer_message(20999,NULL,NULL,NULL,msg);
         raise_application_error( -20999, msg );                     

      ELSE

         -- 'Projet spécial '|| p_libpspe||' supprimé'

         pack_global.recuperer_message( 6007, '%s1', p_libpspe, NULL, msg);
	   p_message := msg;
      END IF;
         
   END delete_proj_spe;


   PROCEDURE select_proj_spe (p_codpspe   IN proj_spe.codpspe%TYPE ,
                              p_global    IN VARCHAR2,
                              p_cursor    IN OUT proj_speCurType,
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
           FROM proj_spe
           WHERE codpspe = p_codpspe;

      -- en cas absence
      -- 'Projet spécial inexistant';

      pack_global.recuperer_message( 6008, '%s1', p_codpspe, NULL, msg);
      p_message := msg;

   END select_proj_spe;

END pack_proj_spe;
/
