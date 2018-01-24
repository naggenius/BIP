-- pack_filiale_cli PL/SQL
--
-- Equipe SOPRA
--
-- Crée le 24/02/1999
--
--******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_filiale_cli AS

   TYPE filiale_cliCurType IS REF CURSOR RETURN filiale_cli%ROWTYPE;

   PROCEDURE insert_filiale_cli ( p_filcode   IN CHAR, 
                                  p_filsigle  IN CHAR,
                                  p_top_immo  IN CHAR,
                                  p_top_sdff  IN CHAR,
                                  p_userid    IN VARCHAR2,
                                  p_nbcurseur OUT INTEGER,
                                  p_message   OUT VARCHAR2
                                );

   PROCEDURE update_filiale_cli ( p_filcode   IN CHAR, 
                                  p_filsigle  IN CHAR,
                                  p_top_immo  IN CHAR,
                                  p_top_sdff  IN CHAR,
                                  p_flaglock  IN NUMBER,
                                  p_userid    IN VARCHAR2,
                                  p_nbcurseur OUT INTEGER,
                                  p_message   OUT VARCHAR2
                                );

   PROCEDURE delete_filiale_cli ( p_filcode   IN CHAR, 
                                  p_flaglock  IN NUMBER,
                                  p_userid    IN VARCHAR2,
                                  p_nbcurseur OUT INTEGER,
                                  p_message   OUT VARCHAR2
                                );

   PROCEDURE select_filiale_cli ( p_filcode        IN CHAR,
                                  p_userid         IN VARCHAR2,
                                  p_curFiliale_cli IN OUT filiale_cliCurType,
                                  p_nbcurseur      OUT INTEGER,
                                  p_message        OUT VARCHAR2
                                );

END pack_filiale_cli;
/

CREATE OR REPLACE PACKAGE BODY pack_filiale_cli AS 

   PROCEDURE insert_filiale_cli ( p_filcode   IN CHAR, 
                                  p_filsigle  IN CHAR,
                                  p_top_immo  IN CHAR,
                                  p_top_sdff  IN CHAR,
                                  p_userid    IN VARCHAR2,
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
         INSERT INTO filiale_cli ( filcode, 
                                   filsigle, 
                                   top_immo, 
                                   top_sdff )
         VALUES ( p_filcode, 
                  p_filsigle, 
                  p_top_immo, 
                  p_top_sdff 
                );

      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            pack_global.recuperer_message( 20501, NULL, NULL, NULL, msg);
            raise_application_error( -20501, msg );

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
      END;

      -- 'Code filiale ' || p_filcode || ' enregistré.';

      pack_global.recuperer_message( 5001, '%s1', p_filcode, NULL, msg);
      p_message := msg;

   END insert_filiale_cli;


   PROCEDURE update_filiale_cli ( p_filcode   IN CHAR, 
                                  p_filsigle  IN CHAR,
                                  p_top_immo  IN CHAR,
                                  p_top_sdff  IN CHAR,
                                  p_flaglock  IN NUMBER,
                                  p_userid    IN VARCHAR2,
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
         UPDATE filiale_cli 
         SET filsigle = p_filsigle, 
             top_immo = p_top_immo, 
             top_sdff = p_top_sdff, 
             flaglock = decode( p_flaglock, 1000000, 0, p_flaglock + 1)
         WHERE filcode = p_filcode
         AND flaglock = p_flaglock;

      EXCEPTION
         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message( 20999, NULL, NULL, NULL, msg);
         raise_application_error( -20999, msg );                     
      ELSE
         pack_global.recuperer_message( 5002, '%s1', p_filcode, NULL, msg);
         p_message := msg;
      END IF;

   END update_filiale_cli;


   PROCEDURE delete_filiale_cli ( p_filcode   IN CHAR, 
                                  p_flaglock  IN NUMBER,
                                  p_userid    IN VARCHAR2,
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
         DELETE FROM filiale_cli 
         WHERE filcode = p_filcode
         AND flaglock = p_flaglock;

      EXCEPTION
         WHEN referential_integrity THEN

            -- habiller le msg erreur

           -- pack_global.recuperation_integrite(-2292);
            pack_global.recuperer_message( 20856, NULL, NULL, NULL, msg);
         raise_application_error( -20856, msg );

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message( 20999, NULL, NULL, NULL, msg);
         raise_application_error( -20999, msg );                     
      ELSE
         pack_global.recuperer_message( 5003, '%s1', p_filcode, NULL, msg);
         p_message := msg;
      END IF;

   END delete_filiale_cli;


   PROCEDURE select_filiale_cli ( p_filcode        IN CHAR,
                                  p_userid         IN VARCHAR2,
                                  p_curFiliale_cli IN OUT filiale_cliCurType,
                                  p_nbcurseur      OUT INTEGER,
                                  p_message        OUT VARCHAR2
                              ) IS 
      l_msg VARCHAR(1024);
   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      OPEN p_curFiliale_cli FOR
           SELECT *
           FROM FILIALE_CLI
           WHERE FILCODE = p_filcode;

      -- en cas absence
      -- 'Code filiale inexistant'

      pack_global.recuperer_message( 5004, '%s1', p_filcode, NULL, l_msg);
      p_message := l_msg;

   END select_filiale_cli;

END pack_filiale_cli;
/
