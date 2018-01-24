-- pack_immeuble PL/SQL
--
-- EQUIPE SOPRA
--
-- cree le 10/02/1999
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_immeuble AS

   TYPE immeubleCurType IS REF CURSOR RETURN immeuble%ROWTYPE;

   PROCEDURE insert_immeuble (p_icodimm   IN immeuble.icodimm%TYPE,
                              p_iadrabr   IN immeuble.iadrabr%TYPE,
                              p_userid    IN VARCHAR2,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                              );

   PROCEDURE update_immeuble (p_icodimm   IN immeuble.icodimm%TYPE,
                              p_iadrabr   IN immeuble.iadrabr%TYPE,
                              p_flaglock  IN NUMBER,
                              p_userid    IN VARCHAR2,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                             );

   PROCEDURE delete_immeuble (p_icodimm   IN immeuble.icodimm%TYPE,
                              p_flaglock  IN NUMBER,
                              p_userid    IN VARCHAR2,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                             );

   PROCEDURE select_immeuble (p_icodimm     IN immeuble.icodimm%TYPE,
                              p_userid      IN VARCHAR2,
                              p_curimmeuble IN OUT immeubleCurType,
                              p_nbcurseur   OUT INTEGER,
                              p_message     OUT VARCHAR2
                             );

END pack_immeuble;
/

CREATE OR REPLACE PACKAGE BODY pack_immeuble AS 

   PROCEDURE insert_immeuble (p_icodimm   IN immeuble.icodimm%TYPE,
                              p_iadrabr   IN immeuble.iadrabr%TYPE,
                              p_userid    IN VARCHAR2,
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
         INSERT INTO immeuble (iadrabr,
                               icodimm
                              )
         VALUES (p_iadrabr,
                 p_icodimm
                );

         --'L'immeuble ' || p_icodimm ||  ' a été créé.'; 

         pack_global.recuperer_message( 2012, '%s1', p_icodimm, NULL, l_msg);
         p_message := l_msg;

      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            pack_global.recuperer_message(20213, NULL, NULL, NULL, l_msg);
            raise_application_error( -20213, l_msg );

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);

      END;

   END insert_immeuble;


   PROCEDURE update_immeuble (p_icodimm   IN immeuble.icodimm%TYPE,
                              p_iadrabr   IN immeuble.iadrabr%TYPE,
                              p_flaglock  IN NUMBER,
                              p_userid    IN VARCHAR2,
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
         UPDATE immeuble SET iadrabr = p_iadrabr,
                             icodimm = p_icodimm,
                             flaglock = decode( p_flaglock, 1000000, 
                                                0, p_flaglock + 1)
         WHERE icodimm = p_icodimm
          AND flaglock = p_flaglock;

      EXCEPTION
         WHEN OTHERS THEN
            raise_application_error( -22097, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
      ELSE
         pack_global.recuperer_message( 2013, '%s1', p_icodimm, NULL, l_msg);
         p_message := l_msg;
      END IF;

  END update_immeuble;


   PROCEDURE delete_immeuble (p_icodimm   IN immeuble.icodimm%TYPE,
                              p_flaglock  IN NUMBER,
                              p_userid    IN VARCHAR2,
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
         DELETE FROM immeuble 
         WHERE icodimm = p_icodimm
         AND flaglock = p_flaglock;

      EXCEPTION

         WHEN referential_integrity THEN

            -- habiller le msg erreur

            pack_global.recuperation_integrite(-2292);

         WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM );
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );                  
      ELSE
         pack_global.recuperer_message( 2014, '%s1', p_icodimm, NULL, l_msg);
         p_message := l_msg;
      END IF;

   END delete_immeuble;

   PROCEDURE select_immeuble (p_icodimm     IN immeuble.icodimm%TYPE,
                              p_userid      IN VARCHAR2,
                              p_curimmeuble IN OUT immeubleCurType,
                              p_nbcurseur   OUT INTEGER,
                              p_message     OUT VARCHAR2
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
         OPEN p_curimmeuble FOR
              SELECT *
              FROM IMMEUBLE
              WHERE icodimm = p_icodimm;

      EXCEPTION

          WHEN OTHERS THEN
             raise_application_error( -20997, SQLERRM);
      END;

      -- en cas absence
      -- 'L'immeuble n'existe pas';

      pack_global.recuperer_message( 2015, '%s1', p_icodimm, NULL, l_msg);
      p_message := l_msg;

   END select_immeuble;

END pack_immeuble;
/
