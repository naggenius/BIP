-- pack_centre_activite PL/SQL
--
-- equipe SOPRA
--
-- crée le 09/02/1999
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_centre_activite AS

   TYPE centre_activiteCurType IS REF CURSOR RETURN centre_activite%ROWTYPE;

   PROCEDURE insert_centre_activite (p_codcamo   IN  VARCHAR2, 
                                     p_ctopact   IN  centre_activite.ctopact%TYPE,
                                     p_clibca    IN  centre_activite.clibca%TYPE,
                                     p_clibrca   IN  centre_activite.clibrca%TYPE,
                                     p_userid    IN  VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2
                                    );

   PROCEDURE update_centre_activite (p_codcamo   IN  VARCHAR2,
                                     p_ctopact   IN  centre_activite.ctopact%TYPE,
                                     p_clibca    IN  centre_activite.clibca%TYPE,
                                     p_clibrca   IN  centre_activite.clibrca%TYPE,
                                     p_flaglock  IN  NUMBER,
                                     p_userid    IN  VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2
                                   );

   PROCEDURE delete_centre_activite (p_codcamo   IN  VARCHAR2,
                                     p_flaglock  IN  NUMBER,
                                     p_userid    IN  VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2 
                                    );

   PROCEDURE select_centre_activite (p_codcamo            IN VARCHAR2,
                                     p_userid             IN VARCHAR2,
                                     p_curcentre_activite IN OUT centre_activiteCurType,
                                     p_nbcurseur             OUT INTEGER,
                                     p_message               OUT VARCHAR2
                                    );

END pack_centre_activite;
/

CREATE OR REPLACE PACKAGE BODY pack_centre_activite AS 

   PROCEDURE insert_centre_activite (p_codcamo   IN  VARCHAR2, 
                                     p_ctopact   IN  centre_activite.ctopact%TYPE,
                                     p_clibca    IN  centre_activite.clibca%TYPE,
                                     p_clibrca   IN  centre_activite.clibrca%TYPE,
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
         INSERT INTO centre_activite (clibca,
                                      clibrca,
                                      codcamo,
                                      ctopact
                                     )
                VALUES (p_clibca,
                        p_clibrca,
                        TO_NUMBER(p_codcamo),
                        p_ctopact
                       );

         -- 'Le centre d'activité M.O. ' || p_codcamo ||  a été créé.'; 

         pack_global.recuperer_message(2004,'%s1',p_codcamo, NULL, l_msg);
         p_message := l_msg;

     EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
             pack_global.recuperer_message(20001,NULL, NULL, NULL, l_msg);
             raise_application_error( -20001, l_msg );

         WHEN OTHERS THEN
              raise_application_error( -20997, SQLERRM );

     END;

   END insert_centre_activite;

   PROCEDURE update_centre_activite (p_codcamo   IN  VARCHAR2,
                                     p_ctopact   IN  centre_activite.ctopact%TYPE,
                                     p_clibca    IN  centre_activite.clibca%TYPE,
                                     p_clibrca   IN  centre_activite.clibrca%TYPE,
                                     p_flaglock  IN  NUMBER,
                                     p_userid    IN  VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2
                                    ) IS 

      l_msg VARCHAR(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
          UPDATE centre_activite SET clibrca  = p_clibrca, 
                                     ctopact  = p_ctopact, 
                                     clibca   = p_clibca,
                                     flaglock = decode( p_flaglock, 1000000, 0, p_flaglock + 1)
          WHERE codcamo = TO_NUMBER(p_codcamo)
           AND flaglock = p_flaglock;

      EXCEPTION
           WHEN OTHERS THEN
              raise_application_error(-20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );                     
      ELSE
        pack_global.recuperer_message(2005, '%s1', p_codcamo, NULL, l_msg);
        p_message := l_msg;
      END IF;

   END update_centre_activite;


   PROCEDURE delete_centre_activite (p_codcamo   IN  VARCHAR2,
                                     p_flaglock  IN  NUMBER,
                                     p_userid    IN  VARCHAR2,
                                     p_nbcurseur OUT INTEGER,
                                     p_message   OUT VARCHAR2 
                                    ) IS

      l_msg VARCHAR(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
 
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         DELETE FROM centre_activite 
                WHERE codcamo = TO_NUMBER(p_codcamo)
                 AND flaglock = p_flaglock;

      EXCEPTION
         WHEN referential_integrity THEN

            -- habiller le msg erreur

            pack_global.recuperation_integrite(-2292);

         WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );                     
      ELSE
         pack_global.recuperer_message(2006, '%s1', p_codcamo, NULL, l_msg);
	   p_message := l_msg;
      END IF;

   END delete_centre_activite;


   PROCEDURE select_centre_activite (p_codcamo            IN VARCHAR2,
                                     p_userid             IN VARCHAR2,
                                     p_curcentre_activite IN OUT centre_activiteCurType,
                                     p_nbcurseur             OUT INTEGER,
                                     p_message               OUT VARCHAR2
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

      BEGIN
         OPEN p_curcentre_activite FOR
              SELECT *
              FROM CENTRE_ACTIVITE
              WHERE codcamo = TO_NUMBER(p_codcamo);

      EXCEPTION
         WHEN OTHERS THEN
             raise_application_error(-20997,SQLERRM);
      END;

      -- en cas absence
      -- p_message := 'Le centre d'activité n''existe pas';

      pack_global.recuperer_message(2007, '%s1', p_codcamo, NULL, l_msg);
      p_message := l_msg;

   END select_centre_activite;

END pack_centre_activite;
/
