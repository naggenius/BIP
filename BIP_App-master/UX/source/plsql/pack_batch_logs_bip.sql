-- pack_batch_logs_bip/SQL

-- 

-- Créé le 31/03/2008 ABA



--# Modification :

--# --------------

--# Auteur  Date       Objet

--#ABA      23/06/2008    suppression du filtre sur les heures de traitement des shells

--#ABA      2/10/2008    ajout du nom du shelle dans le filtre de l'ihm

--***********************************************************************************

--



CREATE OR REPLACE PACKAGE     pack_batch_logs_bip IS



   TYPE Logs_Bip_ViewType IS RECORD ( nom_batch   VARCHAR2(100),

                                         datedeb      varchar2(10),

                                         heure_deb        varchar2(8),

                                        datefin varchar2(10),

                                         heure_fin varchar2(8),

                                         libelleora varchar2(2024),

                                          ecrit number,

                                         lu number,

                                            statut varchar2(3)

                                );



   TYPE Logs_Bip_CurType_Char IS REF CURSOR RETURN Logs_Bip_ViewType;



  PROCEDURE SELECT_LOGS_BIP ( p_datedeb       IN VARCHAR2,

                                  p_datefin         IN VARCHAR2,

                                  p_nom_shell      IN VARCHAR2,

                                  p_curStruct_info IN OUT Logs_Bip_CurType_Char ,

                                  p_message           OUT VARCHAR2

                                );







TYPE nom_shell_ViewType IS RECORD(	code  VARCHAR2(100),

                                   	libelle  VARCHAR2(100)



				  );



TYPE nom_shell_CurType IS REF CURSOR RETURN nom_shell_ViewType;



PROCEDURE lister_nom_shell (p_curseur 	IN OUT nom_shell_CurType



                                );





END pack_batch_logs_bip;

/





CREATE OR REPLACE PACKAGE BODY     pack_batch_logs_bip IS



PROCEDURE SELECT_LOGS_BIP ( p_datedeb       IN VARCHAR2,

                                  p_datefin         IN VARCHAR2,

                                  p_nom_shell      IN VARCHAR2,

                                  p_curStruct_info IN OUT Logs_Bip_CurType_Char ,

                                  p_message           OUT VARCHAR2

                              ) IS



    l_msg VARCHAR2(1024);

        datedebtmp VARCHAR2(250);

        datefintmp  VARCHAR2(250);



   BEGIN



      p_message := '';





      BEGIN



            IF (p_nom_shell is null or p_nom_shell = ' '  ) THEN

            BEGIN

             OPEN   p_curStruct_info FOR

                 SELECT     nom_batch,

                         datedeb,

                         heure_deb,

                         datefin,

                        heure_fin,

                        libelleora,

                         ecrit,

                         lu,

                         statut



              FROM  batch_logs_bip

              where to_date(datedeb,'DD/MM/YYYYHH24:MI:SS') >= to_date(p_datedeb,'DD/MM/YYYY HH24:MI:SS') and

                    to_date(datefin,'DD/MM/YYYYHH24:MI:SS') <= to_date(p_datefin,'DD/MM/YYYY HH24:MI:SS')

             order by to_date(datedeb) desc , heure_deb desc;





                 pack_global.recuperer_message( 21069, '%s1', p_datedeb, NULL, p_datefin, null, l_msg);

                p_message := l_msg;



                 EXCEPTION



                     WHEN OTHERS THEN

                     RAISE_APPLICATION_ERROR( -21069, SQLERRM);



                END;

            ELSE

                BEGIN

                 OPEN   p_curStruct_info FOR

                 SELECT     nom_batch,

                         datedeb,

                         heure_deb,

                         datefin,

                        heure_fin,

                        libelleora,

                         ecrit,

                         lu,

                         statut



              FROM  batch_logs_bip

              where to_date(datedeb,'DD/MM/YYYYHH24:MI:SS') >= to_date(p_datedeb,'DD/MM/YYYY HH24:MI:SS') and

                    to_date(datefin,'DD/MM/YYYYHH24:MI:SS') <= to_date(p_datefin,'DD/MM/YYYY HH24:MI:SS')

                    AND nom_batch = p_nom_shell

                      order by to_date(datedeb) desc , heure_deb desc;





                    pack_global.recuperer_message( 21069, '%s1', p_datedeb, NULL, p_datefin, null, l_msg);

                     p_message := l_msg;



                      EXCEPTION



                     WHEN OTHERS THEN

                        RAISE_APPLICATION_ERROR( -21069, SQLERRM);

                        END;

            END IF;





      END;



   END SELECT_LOGS_BIP;





PROCEDURE lister_nom_shell (

                                p_curseur 	IN OUT nom_shell_CurType

                            )



                            IS





   BEGIN



              OPEN p_curseur FOR

              select distinct

            ' ' code,

            'Tous'  libelle

            from dual

            UNION

        SELECT distinct

                   nom_batch  code,

                   nom_batch libelle

              FROM  batch_logs_bip



      ORDER BY code;







   END lister_nom_shell;









END pack_batch_logs_bip;

/





