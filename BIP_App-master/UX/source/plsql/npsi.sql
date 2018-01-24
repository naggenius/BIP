-- *****************************************************************************************

-- Package pour le traitement des tables NPSI

-- Créé le 11/09/2008 par ABA

-- Modifié 

-- 23/09/2008 ABA TD 665 Ajout des porcedure pour la gestion du npsi via l'ihm

-- 01/10/2008 ABA TD 665 modif procedure du npsi

-- 02/10/2008 ABA TD 665 suppression dans l'affichage des liste les valeur par defaut

-- ******************************************************************************************





CREATE OR REPLACE PACKAGE     pack_npsi IS





/* PARTIE POUR LES SOUS SYSTEMES */ 



TYPE sous_systeme_ViewType IS RECORD(	code  VARCHAR2(5),

                                   	libelle  VARCHAR2(1000),

                                   	top_actif	VARCHAR2(10),

                                    nbdomaines  NUMBER

				  );



TYPE sous_systeme_CurType IS REF CURSOR RETURN sous_systeme_ViewType;

   

   

PROCEDURE insert_sous_systeme(	p_code    	in VARCHAR2,

                         	 p_libelle 	in sous_systeme.libelle%TYPE,

                         	 p_top_actif	IN  sous_systeme.top_actif%TYPE,

                         	 p_message   	out VARCHAR2

                            );

                            

PROCEDURE update_sous_systeme(	p_code   	IN  VARCHAR2,

                            p_libelle 	IN  sous_systeme.libelle%TYPE,

                            p_top_actif	IN  sous_systeme.top_actif%TYPE,

                            p_message   	OUT VARCHAR2

                              );    

                              

PROCEDURE delete_sous_systeme(	p_code    	in VARCHAR2,

                            	p_libelle 	in sous_systeme.libelle%TYPE,

                            	p_message   	out VARCHAR2

                                   );



PROCEDURE select_sous_systeme(	p_code  	in     VARCHAR2,

                              	p_curseur 	IN OUT sous_systeme_CurType,

                              	p_message 	out    VARCHAR2

                                );                                                    



PROCEDURE lister_sous_systeme (p_curseur 	IN OUT sous_systeme_CurType,

                              	p_message 	out    VARCHAR2

                                );

                                

                              

PROCEDURE lister_sous_systeme_actif (p_curseur 	IN OUT sous_systeme_CurType,

                              	    p_message 	out    VARCHAR2

                                );

                                

/* Liste des domaine sans les valeur par defaut à rattacher et hors perimètre*/   

PROCEDURE lister_sous_systeme_sans(p_curseur 	IN OUT sous_systeme_CurType,

                              	    p_message 	out    VARCHAR2

                                );                             

                                

/* PARTIE POUR LES DOMAINES*/ 



TYPE domaine_ViewType IS RECORD(	code  VARCHAR2(2),

                                   	libelle  VARCHAR2(200),

                                    code_ss  VARCHAR2(5),

                                    libelle_code_ss VARCHAR2(200),

                                   	top_actif	VARCHAR2(10),

                                    nbbloc  NUMBER,

                                   nbProjet NUMBER,

                                  nbDPCOPI NUMBER

				  );



TYPE domaine_CurType IS REF CURSOR RETURN domaine_ViewType;

   

   

PROCEDURE insert_domaine(	p_code    	in VARCHAR2,

                         	 p_libelle 	in domaine.libelle%TYPE,

                             p_code_ss   IN  domaine.code_ss%TYPE,

                         	 p_top_actif	IN  domaine.top_actif%TYPE,

                             p_message   	out VARCHAR2

                            );

                            

PROCEDURE update_domaine(	p_code   	IN  VARCHAR2,

                            p_libelle 	IN  domaine.libelle%TYPE,

                            p_code_ss   IN  domaine.code_ss%TYPE,

                            p_top_actif	IN  domaine.top_actif%TYPE,

                            p_message   	OUT VARCHAR2

                              );    

                              

PROCEDURE delete_domaine(	    p_code    	in VARCHAR2,

                            	p_libelle 	in domaine.libelle%TYPE,

                            	p_message   	out VARCHAR2

                                   );



PROCEDURE select_domaine(	p_code  	in     VARCHAR2,

                              	p_curseur 	IN OUT domaine_CurType,

                              	p_message 	out    VARCHAR2

                                );                                                    



PROCEDURE lister_domaine (p_curseur 	IN OUT domaine_CurType,

                              	p_message 	out    VARCHAR2

                                );

                                

                              

PROCEDURE lister_domaine_actif (    

                                    p_curseur 	IN OUT domaine_CurType,

                              	    p_message 	out    VARCHAR2

                                );     

/* Liste des domaine sans les valeur par defaut à rattacher et hors perimètre*/                                

PROCEDURE lister_domaine_sans (    

                                    p_curseur 	IN OUT domaine_CurType,

                              	    p_message 	out    VARCHAR2

                                );                                                            





/* PARTIE POUR LES BLOCS*/ 



TYPE bloc_ViewType IS RECORD(	code  VARCHAR2(2),

                                   	libelle  VARCHAR2(200),

                                    code_d  VARCHAR2(5),

                                    libelle_code_d VARCHAR2(200),

                                   	top_actif	VARCHAR2(10),

                                    nbApplication NUMBER

				  );



TYPE bloc_CurType IS REF CURSOR RETURN bloc_ViewType;

   

   

PROCEDURE insert_bloc(	p_code    	in VARCHAR2,

                         	 p_libelle 	in bloc.libelle%TYPE,

                             p_code_d   IN  bloc.code_d%TYPE,

                         	 p_top_actif	IN  bloc.top_actif%TYPE,

                             p_message   	out VARCHAR2

                            );

                            

PROCEDURE update_bloc(	p_code   	IN  VARCHAR2,

                            p_libelle 	IN  bloc.libelle%TYPE,

                            p_code_d   IN  bloc.code_d%TYPE,

                            p_top_actif	IN  bloc.top_actif%TYPE,

                            p_message   	OUT VARCHAR2

                              );    

                              

PROCEDURE delete_bloc(	    p_code    	in VARCHAR2,

                            	p_libelle 	in bloc.libelle%TYPE,

                            	p_message   	out VARCHAR2

                                   );



PROCEDURE select_bloc(	p_code  	in     VARCHAR2,

                              	p_curseur 	IN OUT bloc_CurType,

                              	p_message 	out    VARCHAR2

                                );                                                    



PROCEDURE lister_bloc(p_curseur 	IN OUT bloc_CurType,

                              	p_message 	out    VARCHAR2

                                );

                                

                              

PROCEDURE lister_bloc_actif (p_curseur 	IN OUT bloc_CurType,

                              	    p_message 	out    VARCHAR2

                                );  

                                

                                

END pack_npsi;

/





CREATE OR REPLACE PACKAGE BODY     pack_npsi AS



 A_rattacher     VARCHAR2(5) := '0';

 Hors_perimetre  VARCHAR2(5) := 'ZZZZZ'; 





/* GESTION DES SOUS SYSTEMES */





PROCEDURE insert_sous_systeme(	p_code    	in VARCHAR2,

                         	 p_libelle 	in sous_systeme.libelle%TYPE,

                         	 p_top_actif	IN  sous_systeme.top_actif%TYPE,

                         	 p_message   	out VARCHAR2

                                 ) IS

       l_msg VARCHAR2(1024);



       BEGIN

          p_message := '';



           -- création d'un sous système

           INSERT INTO sous_systeme(code_ss, libelle, top_actif)

           VALUES (upper(p_code), p_libelle, p_top_actif);

           EXCEPTION

                WHEN DUP_VAL_ON_INDEX THEN

                     pack_global.recuperer_message( 21141, '%s1', p_libelle, NULL, l_msg);

                     p_message := l_msg;

                     raise_application_error( -20000, l_msg );



           pack_global.recuperer_message(20971, '%s1', 'Sous système ' || p_libelle, NULL, l_msg);

           p_message := l_msg;



       END insert_sous_systeme;

       

PROCEDURE update_sous_systeme(	p_code   	IN  VARCHAR2,

                            p_libelle 	IN  sous_systeme.libelle%TYPE,

                            p_top_actif	IN  sous_systeme.top_actif%TYPE,

                            p_message   	OUT VARCHAR2

                              ) IS

       l_msg VARCHAR2(1024);

       



       BEGIN

       p_message := '';

              

          

       

                 

          BEGIN

          

            UPDATE sous_systeme SET

            	libelle = p_libelle,

            	top_actif = p_top_actif

            WHERE code_ss = UPPER(p_code);



            -- message systeme modifié 

            pack_global.recuperer_message(20972, '%s1', 'Sous systeme ' || p_libelle, NULL, l_msg);

            p_message := l_msg;



          EXCEPTION

            WHEN NO_DATA_FOUND THEN

                pack_global.recuperer_message( 20969, '%s1', p_libelle, NULL, l_msg);

                p_message := l_msg;

                raise_application_error( -20969, l_msg );

            WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);



          END;

          

         



       END update_sous_systeme;

       

       

PROCEDURE delete_sous_systeme (	p_code    	in VARCHAR2,

                            	p_libelle 	in sous_systeme.libelle%TYPE,

                            	p_message   	out VARCHAR2

                              )IS

       l_msg VARCHAR2(1024);

       referential_integrity EXCEPTION;

       PRAGMA EXCEPTION_INIT(referential_integrity, -2292);



       BEGIN

          -- Initialiser le message retour

          p_message := '';



          BEGIN

        	   DELETE FROM sous_systeme

        		      WHERE code_ss = UPPER(p_code);

          EXCEPTION

               	WHEN referential_integrity THEN

               		-- habiller le msg erreur

               		pack_global.recuperer_message( 20199, '%s1', p_libelle, '%s2', 'un domaine', NULL, l_msg);

               		p_message := l_msg;

               		raise_application_error( -20199, l_msg );

        	WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);

          END;



          IF SQL%NOTFOUND THEN

    	   -- Pas de données trouvées

    	    pack_global.recuperer_message( 20969, '%s1', p_libelle, NULL, l_msg);

            raise_application_error( -20969, l_msg );

          ELSE

    	   -- 'Le systeme p_libelle a été supprimé'

    	   pack_global.recuperer_message( 20973, '%s1', 'Sous systeme ' || p_libelle, NULL, l_msg);

          END IF;



          p_message := l_msg;



       END delete_sous_systeme;









PROCEDURE select_sous_systeme (p_code  	in     VARCHAR2,

                              	p_curseur 	IN OUT sous_systeme_CurType,

                              	p_message 	out    VARCHAR2

                                )IS

       l_msg VARCHAR2(1024);

       l_nombre VARCHAR2(5);



       BEGIN



    /*Détermine le nombre de domaine rattaché au sous systeme

            utilisé pour le test du top actif via ihm on ne peux fermer un sous systeme

             si des domaines lui sont rattachés*/  

              BEGIN

                SELECT count(*) into l_nombre

                FROM sous_systeme ss, domaine d

                where ss.code_ss = d.code_ss

                and ss.code_ss = p_code;

              END;

              

              OPEN p_curseur FOR SELECT

                   code_ss as code,

                   libelle,

                   top_actif,

                   l_nombre nbdomaines

              FROM  sous_systeme

              WHERE code_ss = p_code;

            



            EXCEPTION WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);





   END select_sous_systeme;   

   

PROCEDURE lister_sous_systeme (p_curseur 	IN OUT sous_systeme_CurType,

                              	p_message 	out    VARCHAR2

                                ) IS

   l_msg VARCHAR2(1024);



   BEGIN



              OPEN p_curseur FOR SELECT

                   code_ss  code,

                   code_ss || ' - ' ||libelle libelle, 

                   top_actif,

                   null

              FROM  sous_systeme

              WHERE

                 code_ss not in (A_rattacher,Hors_perimetre)

                 ORDER BY NLSSORT(code_ss, 'NLS_SORT=FRENCH_M');

              



   END lister_sous_systeme;    

   

PROCEDURE lister_sous_systeme_actif (p_curseur 	IN OUT sous_systeme_CurType,

                              	p_message 	out    VARCHAR2

                                ) IS

   l_msg VARCHAR2(1024);



   BEGIN



              OPEN p_curseur FOR SELECT

                   code_ss  code,

                   code_ss || ' - ' ||libelle libelle, 

                   top_actif,

                   null

              FROM  sous_systeme

              where

              top_actif='O'

             ORDER BY NLSSORT(code_ss, 'NLS_SORT=FRENCH_M');

              



   END lister_sous_systeme_actif;

   

PROCEDURE lister_sous_systeme_sans (p_curseur 	IN OUT sous_systeme_CurType,

                              	p_message 	out    VARCHAR2

                                ) IS

   l_msg VARCHAR2(1024);



   BEGIN



              OPEN p_curseur FOR SELECT

                   code_ss  code,

                   code_ss || ' - ' ||libelle libelle, 

                   top_actif,

                   null

              FROM  sous_systeme

              where

              top_actif='O'

              AND  code_ss not in (A_rattacher,Hors_perimetre)

             ORDER BY NLSSORT(code_ss, 'NLS_SORT=FRENCH_M');

              



   END lister_sous_systeme_sans; 

   

/*PARTIE CONCERNANT LA GESTION DES DOMAINES*/



PROCEDURE insert_domaine(	p_code    	in VARCHAR2,

                         	 p_libelle 	in domaine.libelle%TYPE,

                             p_code_ss   IN  domaine.code_ss%TYPE,

                         	 p_top_actif	IN  domaine.top_actif%TYPE,

                         	 p_message   	out VARCHAR2

                           

        ) IS

       l_msg VARCHAR2(1024);



       BEGIN

          p_message := '';



           -- création d'un domaine

           INSERT INTO domaine(code_d, libelle,code_ss, top_actif)

           VALUES (upper(p_code), p_libelle, p_code_ss, p_top_actif);

           EXCEPTION

                WHEN DUP_VAL_ON_INDEX THEN

                     pack_global.recuperer_message( 21141, '%s1', p_libelle, NULL, l_msg);

                     p_message := l_msg;

                     raise_application_error( -20000, l_msg );



           pack_global.recuperer_message(20971, '%s1', 'Domaine ' || p_libelle, NULL, l_msg);

           p_message := l_msg;



       END insert_domaine;

                            

PROCEDURE update_domaine(	p_code   	IN  VARCHAR2,

                            p_libelle 	IN  domaine.libelle%TYPE,

                            p_code_ss   IN  domaine.code_ss%TYPE,

                            p_top_actif	IN  domaine.top_actif%TYPE,

                            p_message   	OUT VARCHAR2

                              )IS

       l_msg VARCHAR2(1024);

      



       BEGIN

       p_message := '';





          BEGIN

          

            UPDATE domaine SET

            	libelle = p_libelle,

                code_ss = p_code_ss,

            	top_actif = p_top_actif

            WHERE code_d = UPPER(p_code);



            -- message domaine modifié 

            pack_global.recuperer_message(20972, '%s1', 'Domaine ' || p_libelle, NULL, l_msg);

            p_message := l_msg;



          EXCEPTION

            WHEN NO_DATA_FOUND THEN

                pack_global.recuperer_message( 20969, '%s1', p_libelle, NULL, l_msg);

                p_message := l_msg;

                raise_application_error( -20969, l_msg );

            WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);



          END;



       END update_domaine;    

                              

PROCEDURE delete_domaine(	    p_code    	in VARCHAR2,

                            	p_libelle 	in domaine.libelle%TYPE,

                            	p_message   	out VARCHAR2

                                   )IS

       l_msg VARCHAR2(1024);

       referential_integrity EXCEPTION;

       PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

       l_nombreP NUMBER; 

       l_nombreDPCOPI NUMBER; 

       l_nombreB    NUMBER;

       

       BEGIN

          -- Initialiser le message retour

          p_message := '';



           

          

          

          

          

          BEGIN

        	   DELETE FROM domaine

        		      WHERE code_d = UPPER(p_code);

              EXCEPTION

               	WHEN referential_integrity THEN

                         SELECT count(*) into l_nombreB

                         FROM  domaine d, bloc b

                         where d.code_d = b.code_d

                         and d.code_d = p_code; 

                         IF l_nombreB <> 0 THEN

                                pack_global.recuperer_message( 20199, '%s1', p_libelle, '%s2', 'un bloc', NULL, l_msg);

               		             p_message := l_msg;

               		             raise_application_error( -20199, l_msg );

                          ELSE

                          SELECT count(*) into l_nombreP

                            FROM  domaine d, proj_info p

                            where d.code_d = p.cod_db

                            and d.code_d = p_code;

                              IF l_nombreP <> 0 THEN

                                    pack_global.recuperer_message( 20199, '%s1', p_libelle, '%s2', 'un projet', NULL, l_msg);

               		                p_message := l_msg;

               		                raise_application_error( -20199, l_msg );

                              ELSE

                                BEGIN

                                    SELECT count(*) into l_nombreDPCOPI

                                    FROM  domaine d, dossier_projet_copi dp

                                    where d.code_d = dp.domaine 

                                    and d.code_d = p_code;

                                    IF l_nombreDPCOPI<>0 THEN

                                        pack_global.recuperer_message( 20199, '%s1', p_libelle, '%s2', 'un dossier projet COPI', NULL, l_msg);

               		                    p_message := l_msg;

               		                    raise_application_error( -20199, l_msg );

                                    END IF;

                                END;

                            END IF;

                          END IF;

                                       

                WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);      

          END;

                

                		



          IF SQL%NOTFOUND THEN

    	   -- Pas de données trouvées

    	    pack_global.recuperer_message( 20969, '%s1', p_libelle, NULL, l_msg);

            raise_application_error( -20969, l_msg );

          ELSE

    	   -- 'Le domaine p_libelle a été supprimé'

    	   pack_global.recuperer_message( 20973, '%s1', 'Domaine ' || p_libelle, NULL, l_msg);

          END IF;



          p_message := l_msg;



       END delete_domaine;



PROCEDURE select_domaine(	p_code  	in     VARCHAR2,

                              	p_curseur 	IN OUT domaine_CurType,

                              	p_message 	out    VARCHAR2

                                )IS

       l_msg VARCHAR2(1024);

       l_nombreP NUMBER; 

       l_nombreDPCOPI NUMBER; 

       l_nombreBloc NUMBER;

       

       BEGIN

              

       /* Détermine le nombre de projet rattaché au domaine

            utilisé pour le test du top actif via ihm on ne peux fermer un domaine

             si des projets lui sont rattachés*/  

              BEGIN

                SELECT count(*) into l_nombreP

                FROM  domaine d, proj_info p

                where d.code_d = p.cod_db

                and d.code_d = p_code;

              END;

              

          /**Détermine le nombre de dpcopi rattaché au domaine

            utilisé pour le test du top actif via ihm on ne peux fermer un domaine

             si des dpcopi lui sont rattachés*/      

              BEGIN

                SELECT count(*) into l_nombreDPCOPI

                FROM  domaine d, dossier_projet_copi dp

                where d.code_d = dp.domaine 

                and d.code_d = p_code;

              END;

              

              

              /*Détermine le nombre de bloc rattaché au domaine

            utilisé pour le test du top actif via ihm on ne peux fermer un domaine

             si des bloc lui sont rattachés*/  

              BEGIN

                SELECT count(*) into l_nombreBloc

                FROM  domaine d, bloc b

                where d.code_d = b.CODE_D 

                and d.code_d = p_code;

              END;

              

              

              

              OPEN p_curseur FOR SELECT

                   d.code_d as code,

                   d.libelle,

                   d.code_ss,

                   ss.code_ss || ' - ' || ss.libelle libelle_code_ss,

                   d.top_actif,

                   l_nombreBloc nbbloc,

                   l_nombreP nbProjet,

                   l_nombreDPCOPI nbDPCOPI

                   

              FROM  domaine d, sous_systeme ss

              WHERE code_d = p_code

              and d.code_ss = ss.code_ss;



            EXCEPTION WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);





   END select_domaine;                                                     



PROCEDURE lister_domaine (p_curseur 	IN OUT domaine_CurType,

                              	p_message 	out    VARCHAR2

                                )IS

   l_msg VARCHAR2(1024);



   BEGIN



              OPEN p_curseur FOR SELECT

                   code_d  code,

                   code_d || ' - ' ||libelle libelle,

                   code_ss,

                   null, 

                   top_actif,

                   null,

                   null,

                   null

              FROM  domaine

              WHERE

              code_d not in (A_rattacher,Hors_perimetre)

                 ORDER BY NLSSORT(code_d, 'NLS_SORT=FRENCH_M');



   END lister_domaine; 

                                

                              

PROCEDURE lister_domaine_actif (   

                                    p_curseur 	IN OUT domaine_CurType,

                              	    p_message 	out    VARCHAR2

                                )IS

   l_msg VARCHAR2(1024);



   BEGIN

                

               

                

                    OPEN p_curseur FOR SELECT

                         code_d  code,

                         code_d || ' - ' ||libelle libelle,

                         code_ss, 

                        null,

                        top_actif,

                         null,

                         null,

                         null

                     FROM  domaine

                     where

                        top_actif = 'O'

                        ORDER BY NLSSORT(code_d, 'NLS_SORT=FRENCH_M');

              

               

              



   END lister_domaine_actif;    



PROCEDURE lister_domaine_sans (   

                                    p_curseur 	IN OUT domaine_CurType,

                              	    p_message 	out    VARCHAR2

                                )IS

   l_msg VARCHAR2(1024);



   BEGIN

                

               

                

                    OPEN p_curseur FOR SELECT

                         code_d  code,

                         code_d || ' - ' ||libelle libelle,

                         code_ss, 

                        null,

                        top_actif,

                         null,

                         null,

                         null

                     FROM  domaine

                     where

                        top_actif = 'O'

                        and code_d not in (A_rattacher,Hors_perimetre)

                        ORDER BY NLSSORT(code_d, 'NLS_SORT=FRENCH_M');

              

               

              



   END lister_domaine_sans;     

   

/*PARTIE CONCERNANT LA GESTION DES BLOCS*/



PROCEDURE insert_bloc(	p_code    	in VARCHAR2,

                         	 p_libelle 	in bloc.libelle%TYPE,

                             p_code_d   IN  bloc.code_d%TYPE,

                         	 p_top_actif	IN  bloc.top_actif%TYPE,

                         	 p_message   	out VARCHAR2

                           

        ) IS

       l_msg VARCHAR2(1024);



       BEGIN

          p_message := '';



           -- création d'un bloc

           INSERT INTO bloc(code_b, libelle,code_d, top_actif)

           VALUES (upper(p_code), p_libelle, p_code_d, p_top_actif);

           EXCEPTION

                WHEN DUP_VAL_ON_INDEX THEN

                     pack_global.recuperer_message( 21141, '%s1', p_libelle, NULL, l_msg);

                     p_message := l_msg;

                     raise_application_error( -20000, l_msg );



           pack_global.recuperer_message(20971, '%s1', 'Bloc ' || p_libelle, NULL, l_msg);

           p_message := l_msg;



       END insert_bloc;

                            

PROCEDURE update_bloc(	p_code   	IN  VARCHAR2,

                            p_libelle 	IN  bloc.libelle%TYPE,

                            p_code_d   IN  bloc.code_d%TYPE,

                            p_top_actif	IN  bloc.top_actif%TYPE,

                            p_message   	OUT VARCHAR2

                              )IS

       l_msg VARCHAR2(1024);

      



       BEGIN

       p_message := '';





          BEGIN

          

            UPDATE bloc SET

            	libelle = p_libelle,

                code_d = p_code_d,

            	top_actif = p_top_actif

            WHERE code_b = UPPER(p_code);



            -- message bloc modifié 

            pack_global.recuperer_message(20972, '%s1', 'Bloc ' || p_libelle, NULL, l_msg);

            p_message := l_msg;



          EXCEPTION

            WHEN NO_DATA_FOUND THEN

                pack_global.recuperer_message( 20969, '%s1', p_libelle, NULL, l_msg);

                p_message := l_msg;

                raise_application_error( -20969, l_msg );

            WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);



          END;



       END update_bloc;    

                              

PROCEDURE delete_bloc(	    p_code    	in VARCHAR2,

                            	p_libelle 	in bloc.libelle%TYPE,

                            	p_message   	out VARCHAR2

                                   )IS

       l_msg VARCHAR2(1024);

         referential_integrity EXCEPTION;

       PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

       



       BEGIN

          -- Initialiser le message retour

          p_message := '';



          BEGIN

        	   DELETE FROM bloc

        		      WHERE code_b = UPPER(p_code);

          EXCEPTION

            WHEN referential_integrity THEN

               		-- habiller le msg erreur

               		pack_global.recuperer_message( 20199, '%s1', p_libelle, '%s2', 'une application', NULL, l_msg);

               		p_message := l_msg;

               		raise_application_error( -20199, l_msg );

            

               WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);

          END;



          IF SQL%NOTFOUND THEN

    	   -- Pas de données trouvées

    	    pack_global.recuperer_message( 20969, '%s1', p_libelle, NULL, l_msg);

            raise_application_error( -20969, l_msg );

          ELSE

    	   -- 'Le bloc p_libelle a été supprimé'

    	   pack_global.recuperer_message( 20973, '%s1', 'Bloc' || p_libelle, NULL, l_msg);

          END IF;



          p_message := l_msg;



       END delete_bloc;



PROCEDURE select_bloc(	p_code  	in     VARCHAR2,

                              	p_curseur 	IN OUT bloc_CurType,

                              	p_message 	out    VARCHAR2

                                )IS

       l_msg VARCHAR2(1024);

       l_nombre NUMBER;



       BEGIN

       

           /*Détermine le nombre d 'application rattaché au bloc

            utilisé pour le test du top actif via ihm on ne peux fermer un bloc

             si des applications lui sont rattachés*/  

             BEGIN

                SELECT count(*) into l_nombre

                FROM bloc b, application a

                where b.code_b = a.bloc

                and b.code_b = p_code;

              END;         

       

              OPEN p_curseur FOR SELECT

                   b.code_b as code,

                   b.libelle,

                   b.code_d,

                   d.code_d || ' - ' || d.libelle libelle_code_d,

                   b.top_actif,

                   l_nombre nbApplication

              FROM  bloc b, domaine d

              WHERE code_b = p_code

              and b.code_d = d.code_d;



            EXCEPTION WHEN OTHERS THEN raise_application_error( -20997, SQLERRM);





   END select_bloc;                                                     



PROCEDURE lister_bloc(p_curseur 	IN OUT bloc_CurType,

                              	p_message 	out    VARCHAR2

                                )IS

   l_msg VARCHAR2(1024);



   BEGIN



              OPEN p_curseur FOR SELECT

                   code_b  code,

                   code_b || ' - ' ||libelle libelle,

                   code_d,

                   null, 

                   top_actif,

                   null

              FROM  bloc

              WHERe

              code_d not in (A_rattacher,Hors_perimetre)

              ORDER BY NLSSORT(code_b, 'NLS_SORT=FRENCH_M');

              



   END lister_bloc; 

                                

                              

PROCEDURE lister_bloc_actif (p_curseur 	IN OUT bloc_CurType,

                              	    p_message 	out    VARCHAR2

                                )IS

   l_msg VARCHAR2(1024);



   BEGIN



              OPEN p_curseur FOR SELECT

                   code_b  code,

                   code_b || ' - ' ||libelle libelle,

                   code_d, 

                   null,

                   top_actif,

                   null

              FROM  bloc

              where

              top_actif = 'O'

            ORDER BY NLSSORT(code_b, 'NLS_SORT=FRENCH_M');    

              



   END lister_bloc_actif;                



END pack_npsi;

/









