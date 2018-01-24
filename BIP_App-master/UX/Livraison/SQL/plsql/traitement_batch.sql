/*
	Package		PACK_TRAITEMENT_BATCH
	
	Objet		Fonctions destinees a gerer les traitements exceptionnels
	
12/07/2011	C. Martins CMA dans le cadre de la fiche 969
			Premiere version du package. Fonctions d'insert/select/update/delete 
			pour les liste_shell et les trait_batch
31/05/2012  BSA : QC 1382			
*/


CREATE OR REPLACE PACKAGE "PACK_TRAITEMENT_BATCH" IS


   TYPE trait_batch_retour_ViewType IS RECORD ( DATA TRAIT_BATCH_RETOUR.DATA%TYPE,
                                                ERREUR TRAIT_BATCH_RETOUR.ERREUR%TYPE
                                       );
                                       
    TYPE trait_batch_retour_CurType IS REF CURSOR RETURN trait_batch_retour_ViewType;                                       
                                       
   TYPE trait_batch_ViewType IS RECORD ( ID_TRAIT_BATCH TRAIT_BATCH.ID_TRAIT_BATCH%TYPE,
                                         ID_SHELL TRAIT_BATCH.ID_SHELL%TYPE,
                                         NOM_SHELL LISTE_SHELL.NOM_SHELL%TYPE,
                                         DATE_SHELL VARCHAR2(16),
                                         NOM_FICH LISTE_SHELL.NOM_FICH%TYPE,
                                         TAILLE_CLOB NUMBER,
                                         TOP_EXEC TRAIT_BATCH.TOP_EXEC%TYPE,
                                         TOP_RETOUR TRAIT_BATCH.TOP_RETOUR%TYPE,
                                         TOP_ANO TRAIT_BATCH.TOP_ANO%TYPE
                                       );

   TYPE trait_batch_CurType IS REF CURSOR RETURN trait_batch_ViewType;

  PROCEDURE SELECT_trait_batch ( p_date_lancement       IN VARCHAR2,
                                 p_curseur IN OUT trait_batch_CurType ,
                                 p_message           OUT VARCHAR2
                                );

  PROCEDURE SELECT_DONNEE_BATCH ( p_id_trait_batch IN VARCHAR2,
                                  p_curseur IN OUT trait_batch_retour_CurType ,
                                  p_message           OUT VARCHAR2
                               );

  PROCEDURE DELETE_trait_batch ( p_id_trait_batch       IN VARCHAR2,
                                 p_message           OUT VARCHAR2
                                );

  PROCEDURE INSERT_trait_batch ( p_id_trait_batch IN VARCHAR2,
                                 p_id_shell IN VARCHAR2,
                                 p_date_shell       IN VARCHAR2,
                                 p_message           OUT VARCHAR2
                                );


TYPE shell_Type IS RECORD (
                                 ID_SHELL LISTE_SHELL.ID_SHELL%TYPE,
                                 NOM_SHELL LISTE_SHELL.NOM_SHELL%TYPE,
                                 NOM_FICH LISTE_SHELL.NOM_FICH%TYPE
                             );

TYPE shellCurType IS REF CURSOR RETURN shell_Type;

PROCEDURE lister_shell (       p_curshell IN OUT shellCurType
                              ) ;

PROCEDURE select_shell (p_code     IN NUMBER,
                                p_curshell IN OUT shellCurType,
                                p_message OUT VARCHAR2
                              ) ;

PROCEDURE insert_shell(
                           p_libelle        IN VARCHAR2,
                           p_fichier        IN VARCHAR2,
                           p_message        OUT VARCHAR2
                          ) ;
PROCEDURE update_shell ( p_code      IN  VARCHAR2,
                                 p_libelle    IN VARCHAR2,
                                 p_fichier    IN VARCHAR2,
                                 p_message    OUT VARCHAR2
                          ) ;
PROCEDURE delete_shell (  p_code       IN  VARCHAR2,
                                   p_message    OUT VARCHAR2
                             ) ;


END pack_traitement_batch;
/


CREATE OR REPLACE PACKAGE BODY "PACK_TRAITEMENT_BATCH" IS



PROCEDURE SELECT_trait_batch ( p_date_lancement       IN VARCHAR2,
                                 p_curseur IN OUT trait_batch_CurType ,
                                 p_message           OUT VARCHAR2
                                ) IS

    l_msg VARCHAR2(1024);

   BEGIN

      p_message := '';

      BEGIN

            BEGIN
             OPEN   p_curseur  FOR
             select t.id_trait_batch, b.id_shell, b.nom_shell, TO_CHAR(t.date_shell,'DD/MM/YYYY HH24:MI')
                    , b.nom_fich, dbms_lob.getlength(t.data_fich), t.top_exec,
                    t.TOP_RETOUR, t.TOP_ANO
                from LISTE_SHELL b, trait_batch t
                 where b.id_shell = t.id_shell
                 and TO_CHAR(t.date_shell,'DD/MM/YYYY') = p_date_lancement
                order by t.date_shell;


                p_message := l_msg;

                 EXCEPTION
                     WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR( -21069, SQLERRM);
               END;




      END;

   END SELECT_trait_batch;

PROCEDURE SELECT_DONNEE_BATCH ( p_id_trait_batch IN VARCHAR2,
                                p_curseur IN OUT trait_batch_retour_CurType ,
                                p_message           OUT VARCHAR2
                               ) IS

    l_msg VARCHAR2(1024);

   BEGIN

      p_message := '';

      BEGIN
        
            BEGIN
             OPEN   p_curseur FOR 
             SELECT DATA, ERREUR FROM TRAIT_BATCH_RETOUR WHERE ID_TRAIT_BATCH =  p_id_trait_batch;


                p_message := l_msg;

                 EXCEPTION
                     WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR( -21069, SQLERRM);
               END;

      END;

   END SELECT_DONNEE_BATCH;
   

    ---------------------- Lister les shells---------------------------------------
  PROCEDURE lister_shell (   p_curshell IN OUT shellCurType
                              ) IS

   BEGIN

      BEGIN
         OPEN p_curshell FOR
          SELECT
            ID_SHELL,
            nom_shell,
            nom_fich
            FROM LISTE_SHELL ORDER BY nom_shell ;


      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;
   END lister_shell;

  PROCEDURE select_shell (p_code     IN NUMBER,
                                p_curshell IN OUT shellCurType,
                                p_message OUT VARCHAR2
                              ) IS

   l_msg VARCHAR2(1024);

   BEGIN

   p_message := '';

      BEGIN
         OPEN p_curshell FOR
          SELECT
            ID_SHELL,
            nom_shell,
            nom_fich
            FROM LISTE_SHELL
            WHERE ID_SHELL = p_code;

         pack_global.recuperer_message( 21169, '%s1', p_code, NULL, l_msg);
         p_message := l_msg;


      EXCEPTION

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;
   END select_shell;


PROCEDURE insert_shell(
                           p_libelle        IN VARCHAR2,
                           p_fichier        IN VARCHAR2,
                           p_message        OUT VARCHAR2
                          ) IS
l_msg varchar2(1024);
l_numero_suivant NUMBER ;
l_count NUMBER ;
BEGIN


    SELECT COUNT(*) INTO l_count FROM LISTE_SHELL ;

     IF l_count > 0 THEN
         SELECT MAX(id_shell) INTO l_numero_suivant FROM  LISTE_SHELL  ;
         l_numero_suivant := l_numero_suivant + 1 ;
     ELSE
            l_numero_suivant := 1 ;
     END IF ;

     INSERT INTO LISTE_SHELL (id_shell,nom_shell,nom_fich) VALUES (l_numero_suivant, p_libelle, p_fichier);

     Pack_Global.recuperer_message( 21171, '%s1', p_libelle , NULL, l_msg);

     p_message := l_msg;
     EXCEPTION
             WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
END insert_shell;

----------------- UPDATE -------------------------------------------------------------
PROCEDURE update_shell ( p_code      IN  VARCHAR2,
                                 p_libelle    IN VARCHAR2,
                                 p_fichier    IN VARCHAR2,
                                 p_message    OUT VARCHAR2
                          ) IS
 l_msg varchar2(1024);
 l_count NUMBER ;
BEGIN

    UPDATE liste_shell SET nom_shell = p_libelle, nom_fich = p_fichier WHERE id_shell = to_number(p_code);
    Pack_Global.recuperer_message( 21172, '%s1', p_libelle , NULL, l_msg);
    p_message := l_msg;

END update_shell;

----------------- DELETE -------------------------------------------------------------
PROCEDURE delete_shell (  p_code       IN  VARCHAR2,
                                   p_message    OUT VARCHAR2
                             ) IS
      l_msg varchar2(1024);
      l_lib_shell VARCHAR2(100) ;
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
  BEGIN

       BEGIN

           SELECT nom_shell INTO  l_lib_shell FROM liste_shell WHERE id_shell = TO_NUMBER(p_code) ;

        EXCEPTION

         WHEN NO_DATA_FOUND THEN
             Pack_Global.recuperer_message(21169, '%s1', p_code, NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20607,  l_msg);


        END;

    BEGIN

         -- Suppression de tous les traitements batchs qui utilisaient ce shell
         DELETE FROM trait_batch WHERE id_shell = TO_NUMBER(p_code);
         -- Suppression du shell
         DELETE FROM liste_shell WHERE id_shell = TO_NUMBER(p_code);
      EXCEPTION
             WHEN OTHERS THEN
            raise_application_error( -20997, l_msg);
    END;

    Pack_Global.recuperer_message( 21173, '%s1', l_lib_shell , NULL, l_msg);
    p_message := l_msg;

END delete_shell;

----------------- Suppression d'un traitement via l'IHM --------------------------------------------------------
PROCEDURE delete_trait_batch (  p_id_trait_batch       IN  VARCHAR2,
                                   p_message    OUT VARCHAR2
                             ) IS
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
  BEGIN

    BEGIN

         DELETE FROM trait_batch WHERE id_trait_batch = TO_NUMBER(p_id_trait_batch);
         DELETE FROM trait_batch_retour  WHERE id_trait_batch = TO_NUMBER(p_id_trait_batch);

      EXCEPTION
             WHEN OTHERS THEN
            raise_application_error( -20997, SQLERRM);
    END;


END delete_trait_batch;


PROCEDURE insert_trait_batch( p_id_trait_batch IN VARCHAR2,
                           p_id_shell        IN VARCHAR2,
                           p_date_shell        IN VARCHAR2,
                           p_message        OUT VARCHAR2
                          ) IS
l_numero_suivant NUMBER ;
l_count NUMBER ;
BEGIN

    SELECT COUNT(*) INTO l_count FROM TRAIT_BATCH ;

     IF l_count > 0 THEN
         SELECT MAX(id_trait_batch) INTO l_numero_suivant FROM  TRAIT_BATCH  ;
         l_numero_suivant := l_numero_suivant + 1 ;
     ELSE
            l_numero_suivant := 1 ;
     END IF ;


BEGIN
            MERGE into TRAIT_BATCH tb
            using
            (
                select TO_NUMBER(p_id_trait_batch) id_trait_batch
                from dual
            )   tmp
            on
            (
                tmp.id_trait_batch = tb.id_trait_batch
           )
            when matched then
                update set id_shell = TO_NUMBER(p_id_shell) ,
                    date_shell = TO_DATE(p_date_shell,'DD/MM/YYYY HH24:MI')
            when not matched then
                INSERT (id_trait_batch,id_shell,date_shell,data_fich)
                VALUES (l_numero_suivant,TO_NUMBER(p_id_shell), TO_DATE(p_date_shell,'DD/MM/YYYY HH24:MI'),empty_clob());
         EXCEPTION WHEN
         OTHERS THEN
            raise_application_error( -20997, SQLERRM);
         END;

         p_message := l_numero_suivant;


END insert_trait_batch;

END pack_traitement_batch;
/
