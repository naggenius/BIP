/*
* Pack de gestion de la table branches
* Version initiale le 27/01/2011 CMA Fiche 1028
*
*
*
*
*/


CREATE OR REPLACE PACKAGE     pack_branche IS
/* source/plsql/tp/branche_gestion.sql*/
TYPE branche_ViewType IS RECORD(    codbr       NUMBER(2),
                                    libbr       VARCHAR2(30),
                                    combr       VARCHAR2(200),
                                    flaglock    NUMBER(7)
                                       );


TYPE branche_CurType IS REF CURSOR RETURN branche_ViewType;

/* procedure de mise à jour d'une branche*/

PROCEDURE update_branches(p_codbr        IN NUMBER,
                            p_libbr      IN VARCHAR2,
                            p_combr      IN VARCHAR2,
                            p_flaglock   IN NUMBER,
                            p_message    OUT VARCHAR2
                           );



/* procedure de recupération d'informations de la branche*/

PROCEDURE select_branches(p_codbr        IN NUMBER,
                            p_curseur    IN OUT branche_CurType,
                            p_message    OUT VARCHAR2
                        );

/* procedure d'insertion d'une nouvelle branche */

PROCEDURE insert_branches(p_codbr      IN NUMBER,
                            p_libbr      IN VARCHAR2,
                            p_combr      IN VARCHAR2,
                            p_message    OUT VARCHAR2
                           );

/* procédure de suppression d'une branche*/
PROCEDURE delete_branches(p_codbr IN NUMBER,
                          p_message OUT VARCHAR2);


END pack_branche;
/


CREATE OR REPLACE PACKAGE BODY     pack_branche AS
/* source/plsql/tp/branche_gestion.sql*/


PROCEDURE update_branches(p_codbr      IN NUMBER,

                              p_libbr     IN VARCHAR2,

                            p_combr      IN VARCHAR2,

                            p_flaglock   IN NUMBER,

                            p_message    OUT VARCHAR2

                           ) IS



        l_msg VARCHAR2(1024);



    BEGIN



         p_message := '';



         BEGIN



               UPDATE BRANCHES

              SET    libbr  = UPPER(p_libbr),

                          codbr   = p_codbr,

                     flaglock     = DECODE( p_flaglock, 1000000, 0, p_flaglock + 1 ) ,

                     combr = p_combr


              WHERE  codbr = p_codbr;



         pack_global.recuperer_message( 21210, '%s1', p_codbr, NULL, l_msg);

         p_message := l_msg;



           EXCEPTION



        WHEN OTHERS THEN

          RAISE_APPLICATION_ERROR( -21210, SQLERRM);



      END;



END update_branches;



PROCEDURE select_branches( p_codbr            IN NUMBER,

                               p_curseur            IN OUT branche_CurType,

                                p_message           OUT VARCHAR2

                        ) IS



    l_msg VARCHAR2(1024);



   BEGIN



      p_message := '';



      BEGIN



       OPEN p_curseur FOR

               select codbr,

                   libbr,

                   combr,

                   flaglock

            from branches

            where codbr = p_codbr;





          pack_global.recuperer_message( 20607, '%s1', p_codbr, NULL, l_msg);

         p_message := l_msg;



      EXCEPTION



        WHEN OTHERS THEN

          RAISE_APPLICATION_ERROR( -20607, SQLERRM);



      END;



   END select_branches;



PROCEDURE insert_branches(p_codbr      IN NUMBER,

                              p_libbr     IN VARCHAR2,

                            p_combr      IN VARCHAR2,

                            p_message    OUT VARCHAR2

                           )

                         IS



    l_msg VARCHAR2(1024);



   BEGIN



      p_message := '';



      BEGIN



          INSERT INTO BRANCHES

        ( codbr,

        libbr,

         combr,

         flaglock)

         VALUES ( p_codbr,

           p_libbr,

           p_combr,

           0

        );

         pack_global.recuperer_message( 21213, '%s1', p_codbr, NULL, l_msg);

         p_message := l_msg;



         EXCEPTION

          WHEN DUP_VAL_ON_INDEX THEN

           pack_global.recuperer_message( 21212, NULL, NULL, NULL, l_msg);

               RAISE_APPLICATION_ERROR( -21212, l_msg );



            WHEN OTHERS THEN

               RAISE_APPLICATION_ERROR( -20997, SQLERRM);

     END;



   END insert_branches;

PROCEDURE delete_branches(p_codbr IN NUMBER,
                           p_message OUT VARCHAR2) IS

l_msg           VARCHAR2(1024);
l_codbr         NUMBER(4);

BEGIN

    BEGIN

       SELECT codbr INTO l_codbr
       FROM BRANCHES
       WHERE codbr=p_codbr;

    EXCEPTION

     WHEN NO_DATA_FOUND THEN
         Pack_Global.recuperer_message(20607, '%s1', p_codbr, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20607,  l_msg);


    END;

    BEGIN

           DELETE FROM BRANCHES
           WHERE codbr=p_codbr;

       EXCEPTION

         WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);


    END;
    
    Pack_Global.recuperer_message(21214, '%s1', p_codbr, NULL, l_msg);
    p_message := l_msg;

END delete_branches;

END pack_branche;
/


