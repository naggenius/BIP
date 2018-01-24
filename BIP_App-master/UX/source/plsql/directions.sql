-- pack_direction/SQL

-- 

-- Créé le 31/03/2008 ABA

--

--***********************************************************************************

--

CREATE OR REPLACE PACKAGE pack_direction IS

TYPE direction_ViewType IS RECORD(    coddir       NUMBER(2),
                                      libdir      VARCHAR2(30),
                                    codbr       NUMBER(2),
                                    topme       NUMBER(1),
                                    flaglock    NUMBER(7),
                                    syscompta   VARCHAR2(3),
                                    codref      VARCHAR2(5),
                                    codperim    VARCHAR2(5)
                                       );
                      

TYPE direction_CurType IS REF CURSOR RETURN direction_ViewType;

/* procedure de mise à jour du système comptable de chaque direction*/

PROCEDURE update_directions(p_coddir      IN NUMBER,
                              p_libdir     IN VARCHAR2,
                            p_codbr      IN NUMBER,
                            p_topme      IN NUMBER,
                            p_flaglock   IN NUMBER,
                            p_syscompta  IN VARCHAR2,
                            p_codref     IN VARCHAR2,
                            p_codperim   IN VARCHAR2,
                            p_message    OUT VARCHAR2
                           );



/* procedure de recupération d'informations de la direction*/

PROCEDURE select_directions(p_coddir      IN NUMBER,
                              p_curseur      IN OUT direction_CurType,
                            p_message    OUT VARCHAR2
                        );

/* procedure d'insertion d'une nouvelle direction */                        

PROCEDURE insert_directions(p_coddir      IN NUMBER,
                              p_libdir     IN VARCHAR2,
                            p_codbr      IN NUMBER,
                            p_topme      IN NUMBER,
                            p_syscompta  IN VARCHAR2,
                            p_codref     IN VARCHAR2,
                            p_codperim   IN VARCHAR2,
                            p_message    OUT VARCHAR2
                           );

                    

TYPE branche_Type IS RECORD (codbr        NUMBER(2),

                           libbr         VARCHAR2(30)

                );



      TYPE brancheCurType IS REF CURSOR RETURN branche_Type;



PROCEDURE lister_branche (p_userid     IN VARCHAR2,

                          p_curbranche IN OUT brancheCurType

                                  );

                        



                        



END pack_direction;

/





CREATE OR REPLACE PACKAGE BODY pack_direction AS



PROCEDURE update_directions(p_coddir      IN NUMBER,

                              p_libdir     IN VARCHAR2,

                            p_codbr      IN NUMBER,

                            p_topme      IN NUMBER,

                            p_flaglock   IN NUMBER,

                            p_syscompta  IN VARCHAR2,

                            p_codref     IN VARCHAR2,

                            p_codperim   IN VARCHAR2,

                            p_message    OUT VARCHAR2

                           ) IS

                           

        l_msg VARCHAR2(1024);                   

                           

    BEGIN

    

         p_message := '';

         

         BEGIN

         

               UPDATE DIRECTIONS

              SET    libdir  = UPPER(p_libdir),

                          codbr   = p_codbr,

                        topme = p_topme,

                     flaglock     = DECODE( p_flaglock, 1000000, 0, p_flaglock + 1 ) ,

                     syscompta = UPPER(p_syscompta),

                     codref = UPPER(p_codref),

                     codperim = UPPER(p_codperim)

                     

              WHERE  coddir = p_coddir;

              

         pack_global.recuperer_message( 20972, '%s1', p_coddir, NULL, l_msg);

         p_message := l_msg;

              

           EXCEPTION



        WHEN OTHERS THEN

          RAISE_APPLICATION_ERROR( -20972, SQLERRM);



      END;       

                           

END update_directions;                   



PROCEDURE select_directions( p_coddir            IN NUMBER,

                               p_curseur            IN OUT direction_CurType,

                                p_message           OUT VARCHAR2

                        ) IS



    l_msg VARCHAR2(1024);



   BEGIN



      p_message := '';



      BEGIN



       OPEN p_curseur FOR

               select coddir,

                   libdir,

                   codbr,

                   topme,

                   flaglock,

                   syscompta,

                   codref,

                   codperim

            from directions 

            where coddir = p_coddir;





          pack_global.recuperer_message( 20505, '%s1', p_coddir, NULL, l_msg);

         p_message := l_msg;



      EXCEPTION



        WHEN OTHERS THEN

          RAISE_APPLICATION_ERROR( -20505, SQLERRM);



      END;



   END select_directions;



PROCEDURE insert_directions(p_coddir      IN NUMBER,

                              p_libdir     IN VARCHAR2,

                            p_codbr      IN NUMBER,

                            p_topme      IN NUMBER,

                            p_syscompta  IN VARCHAR2,

                            p_codref     IN VARCHAR2,

                            p_codperim   IN VARCHAR2,

                            p_message    OUT VARCHAR2

                           )

                         IS



    l_msg VARCHAR2(1024);



   BEGIN



      p_message := '';



      BEGIN



          INSERT INTO DIRECTIONS

        ( coddir,

        libdir,

         codbr,

         topme,

         flaglock,

        syscompta,

         codref,

         codperim)

         VALUES ( p_coddir,

           p_libdir,

           p_codbr,

           p_topme,

           0,

           p_syscompta,

           p_codref,

           p_codperim

        );





         EXCEPTION

          WHEN DUP_VAL_ON_INDEX THEN

           pack_global.recuperer_message( 20001, NULL, NULL, NULL, l_msg);

               RAISE_APPLICATION_ERROR( -20001, l_msg );



            WHEN OTHERS THEN

               RAISE_APPLICATION_ERROR( -20997, SQLERRM);

     END;



   END insert_directions;

   

   

PROCEDURE lister_branche (p_userid     IN VARCHAR2,

                          p_curbranche IN OUT brancheCurType

                              ) IS



     l_msg VARCHAR(1024);



   BEGIN



      BEGIN

         OPEN p_curbranche FOR

        SELECT

            codbr,

            to_char(codbr) || ' - ' || libbr

        FROM BRANCHES

        ;



      EXCEPTION

         WHEN OTHERS THEN

            RAISE_APPLICATION_ERROR( -20997, SQLERRM );

      END;



   END lister_branche;

   



   

END pack_direction;

/