-- pack_fichier PL/SQL
--
-- equipe SOPRA
--
-- crée le 12/02/1999
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_fichier AS

   PROCEDURE insert_calendrier (p_idfic     IN  fichier.idfic%TYPE,
                                p_contenu   IN  fichier.contenu%TYPE,
                                p_userid    IN  VARCHAR2,
                                p_nbcurseur OUT INTEGER,
                                p_message   OUT VARCHAR2
                               );

END pack_fichier;
/

CREATE OR REPLACE PACKAGE BODY pack_fichier AS 

   PROCEDURE insert_calendrier (p_idfic     IN  fichier.idfic%TYPE,
                                p_contenu   IN  fichier.contenu%TYPE,
                                p_userid    IN  VARCHAR2,
                                p_nbcurseur OUT INTEGER,
                                p_message   OUT VARCHAR2
                               ) IS 

   l_msg VARCHAR2(1024);
   l_idfic fichier.idfic%TYPE;

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      -- TEST pour savoir si la cle existe ou pas -> existe update, sinon insert

      BEGIN
         SELECT idfic
         INTO   l_idfic
         FROM   fichier
         WHERE  idfic = p_idfic;

      EXCEPTION  

         WHEN NO_DATA_FOUND THEN

            -- la cle n'existe pas donc insert.

            BEGIN
               INSERT INTO fichier (idfic,
                                    contenu
                                   )
               VALUES (p_idfic,
                       p_contenu
                      );

               -- 'Dates de traitement' || p_idfic ||' créé.'; 

               pack_global.recuperer_message(2079,'%s1',p_idfic, NULL, l_msg);
               p_message := l_msg;

            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                     pack_global.recuperer_message(20272,NULL, NULL, NULL, l_msg);
                     raise_application_error( -20272, l_msg );

                WHEN OTHERS THEN
                     raise_application_error( -20997, SQLERRM );
            END;
     END;

     IF l_idfic IS NOT NULL THEN

        BEGIN
          UPDATE fichier SET contenu = p_contenu
          WHERE  idfic = p_idfic;

        EXCEPTION
           WHEN OTHERS THEN
               raise_application_error( -20997, SQLERRM );
        END;

        IF SQL%NOTFOUND THEN
           pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
           raise_application_error( -20999, l_msg );                     
        ELSE
           pack_global.recuperer_message(2080, '%s1', p_idfic, NULL, l_msg);
           p_message := l_msg;
        END IF;
     END IF;

   END insert_calendrier;

END pack_fichier;
/
