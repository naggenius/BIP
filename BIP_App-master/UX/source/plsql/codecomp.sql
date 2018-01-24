-- pack_code_compt PL/SQL
--
-- equipe SOPRA
--
-- Cree le 10/02/1999
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_code_compt AS

   TYPE code_comptCurType IS REF CURSOR RETURN code_compt%ROWTYPE;

   PROCEDURE insert_code_compt (p_comcode   IN  code_compt.comcode%TYPE,
                                p_comlib    IN  code_compt.comlib%TYPE,
                                p_comtyp    IN  code_compt.comtyp%TYPE,
                                p_userid    IN  VARCHAR2,
                                p_nbcurseur OUT INTEGER,
                                p_message   OUT VARCHAR2
                               );

   PROCEDURE update_code_compt (p_comcode   IN  code_compt.comcode%TYPE,
                                p_comlib    IN  code_compt.comlib%TYPE,
                                p_comtyp    IN  code_compt.comtyp%TYPE,
                                p_flaglock  IN  NUMBER,
                                p_userid    IN  VARCHAR2,
                                p_nbcurseur OUT INTEGER,
                                p_message   OUT VARCHAR2
                               );

   PROCEDURE delete_code_compt (p_comcode   IN  code_compt.comcode%TYPE,
                                p_flaglock  IN  NUMBER,
                                p_userid    IN  VARCHAR2,
                                p_nbcurseur OUT INTEGER,
                                p_message   OUT VARCHAR2
                               );

   PROCEDURE select_code_compt (p_comcode       IN code_compt.comcode%TYPE,
                                p_userid        IN VARCHAR2,
                                p_curcode_compt IN OUT code_comptCurType,
                                p_nbcurseur        OUT INTEGER,
                                p_message          OUT VARCHAR2
                               );

END pack_code_compt;
/

CREATE OR REPLACE PACKAGE BODY pack_code_compt AS

    PROCEDURE insert_code_compt (p_comcode   IN  code_compt.comcode%TYPE,
                                 p_comlib    IN  code_compt.comlib%TYPE,
                                 p_comtyp    IN  code_compt.comtyp%TYPE,
                                 p_userid    IN  VARCHAR2,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                ) IS

       l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         INSERT INTO code_compt (comcode,
                                 comlib,
                                 comtyp
                                )
             VALUES (p_comcode,
                     p_comlib,
                     p_comtyp
                    );

          -- 'Code comptable ' || p_comcode ||  ' a été créé.';

         pack_global.recuperer_message( 2020, '%s1', p_comcode, NULL, l_msg);
         p_message := l_msg;

      EXCEPTION

         WHEN DUP_VAL_ON_INDEX THEN
            pack_global.recuperer_message(20001, NULL, NULL, NULL, l_msg);
            raise_application_error(-20001, l_msg);

         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;

   END insert_code_compt;

   PROCEDURE update_code_compt (p_comcode   IN  code_compt.comcode%TYPE,
                                p_comlib    IN  code_compt.comlib%TYPE,
                                p_comtyp    IN  code_compt.comtyp%TYPE,
                                p_flaglock  IN  NUMBER,
                                p_userid    IN  VARCHAR2,
                                p_nbcurseur OUT INTEGER,
                                p_message   OUT VARCHAR2
                               ) IS

       l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         UPDATE code_compt SET comcode  = p_comcode,
                               comlib   = p_comlib,
                               comtyp   = p_comtyp,
                               flaglock = decode(p_flaglock, 1000000, 0, p_flaglock + 1)
         WHERE comcode = p_comcode
          AND flaglock = p_flaglock;

      EXCEPTION
 
         WHEN OTHERS THEN
           raise_application_error( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
     ELSE
         pack_global.recuperer_message(2021, '%s1', p_comcode, NULL, l_msg);
         p_message := l_msg;
      END IF;

   END update_code_compt;


   PROCEDURE delete_code_compt (p_comcode   IN  code_compt.comcode%TYPE,
                                p_flaglock  IN  NUMBER,
                                p_userid    IN  VARCHAR2,
                                p_nbcurseur OUT INTEGER,
                                p_message   OUT VARCHAR2
                               ) IS

      l_msg VARCHAR2(1024);

      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

    BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         DELETE FROM code_compt 
                WHERE comcode = p_comcode
                 AND flaglock = p_flaglock;

      EXCEPTION

         WHEN referential_integrity THEN

            -- habiller le msg erreur

            pack_global.recuperation_integrite(-2292);

          WHEN OTHERS THEN
             raise_application_error( -20997,SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
      ELSE
         pack_global.recuperer_message(2022, '%s1', p_comcode, NULL, l_msg);
         p_message := l_msg;
      END IF;

   END delete_code_compt;

   PROCEDURE select_code_compt (p_comcode       IN code_compt.comcode%TYPE,
                                p_userid        IN VARCHAR2,
                                p_curcode_compt IN OUT code_comptCurType,
                                p_nbcurseur        OUT INTEGER,
                                p_message          OUT VARCHAR2
                               ) IS

       l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN

         OPEN p_curcode_compt FOR
              SELECT *
              FROM CODE_COMPT
              WHERE comcode = p_comcode;

      EXCEPTION
         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);

      END;

      -- en cas absence
      -- 'Le code_compt p_comcode n'existe pas';

      pack_global.recuperer_message(2023, '%s1', p_comcode, NULL, l_msg);
      p_message := l_msg;

   END select_code_compt;

END pack_code_compt;
/
