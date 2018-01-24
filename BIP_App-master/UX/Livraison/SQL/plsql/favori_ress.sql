-- Pack PACK_ISAC_FAVORI
--
-- Package permettant la gestion des ressources favorite
--
-- Créée Le 17/11/2011 par BSA

CREATE OR REPLACE PACKAGE     PACK_ISAC_FAVORI AS

    TYPE RefCurTyp IS REF CURSOR;

   PROCEDURE SELECT_FAVORI(     p_userid        IN VARCHAR2,
                                p_curseur       IN OUT RefCurTyp,
                                p_message       OUT VARCHAR2) ;

   PROCEDURE INIT_FAVORI(     p_idarpege      IN VARCHAR2,
                              p_message       OUT VARCHAR2);


   PROCEDURE INSERT_FAVORI(   p_idarpege        IN VARCHAR2,
                              p_ident           IN VARCHAR2,
                              p_message         OUT VARCHAR2) ;

-- PPM 57865 : procédure de vérification si l'utilisateur a paramétré des favoris

   PROCEDURE IS_RESSOURCE_FAVORIS(     p_idarpege      IN VARCHAR2,
                              p_result       OUT VARCHAR2,
                              p_message       OUT VARCHAR2);


END PACK_ISAC_FAVORI;
/

create or replace PACKAGE BODY     PACK_ISAC_FAVORI AS



   PROCEDURE SELECT_FAVORI(     p_userid        IN VARCHAR2,
                                p_curseur       IN OUT RefCurTyp,
                                p_message       OUT VARCHAR2) IS


     l_lst_chefs_projets    VARCHAR2(8000);-- PPM 63485 : augmenter la taille à 4000
     l_idarpege             VARCHAR2(600);

    -- recuperation de l ident de l utilisateur
    CURSOR c_ident IS
        SELECT NVL(IDENT,-1) IDENT
        FROM RTFE_USER
        WHERE USER_RTFE = l_idarpege;

    t_ident   RTFE_USER.IDENT%TYPE;
    t_req     VARCHAR2(10000);

    BEGIN

        p_message := '' ;
        l_lst_chefs_projets := Pack_Global.lire_globaldata(p_userid).chefprojet;
        l_idarpege := Pack_Global.lire_globaldata(p_userid).idarpege;

        OPEN c_ident;
            FETCH c_ident INTO t_ident;
            IF c_ident%NOTFOUND THEN
                t_ident := -1;
            END IF;
        CLOSE c_ident;

    t_req := 'SELECT  DISTINCT TO_CHAR(r.ident) ident , DECODE(i.ident,NULL,0,1) favori,
               DECODE (f.CPIDENT ,'||t_ident||',''Oui'','''') rattachement, r.rnom nom , r.RPRENOM prenom,
               DECODE(r.RTYPE, ''L'',''Logiciel'',
                                    ''E'',''Forfait sans frais d''''env'',
                                    ''F'',''Forfait avec frais d''''env'',
                                    ''P'',DECODE(f.SOCCODE,''SG..'',''SG ou assimilé'',''Presta. au temps passé''),
                                    ''INCONNU''
                          ) type
            FROM SITU_RESS_FULL f, DATDEBEX d, RESSOURCE r
                LEFT OUTER JOIN ISAC_RESSOURCE_FAVORITE i ON (i.IDENT = r.ident AND UPPER(i.IDARPEGE) = UPPER('''||l_idarpege||''' ) )
            WHERE f.ident=r.ident
                    AND (TRUNC(f.datsitu,''YEAR'') <=TRUNC(d.DATDEBEX,''YEAR'') OR f.datsitu IS NULL)
                    AND (TRUNC(f.datdep,''YEAR'')>=TRUNC(d.DATDEBEX,''YEAR'') OR f.datdep IS NULL)
                    AND ( f.cpident IN ( '||l_lst_chefs_projets||' ) OR f.ident IN ('|| l_lst_chefs_projets||' ) )
                    AND f.type_situ=''N''
            ORDER BY r.rnom';

        OPEN p_curseur FOR t_req;

    EXCEPTION
        WHEN OTHERS THEN
           raise_application_error(-20997,SQLERRM);


    END SELECT_FAVORI;

   PROCEDURE INIT_FAVORI(     p_idarpege      IN VARCHAR2,
                              p_message       OUT VARCHAR2) IS


    BEGIN

        p_message := '' ;

        DELETE FROM ISAC_RESSOURCE_FAVORITE
        WHERE IDARPEGE = p_idarpege;

    EXCEPTION
        WHEN OTHERS THEN
           raise_application_error(-20997,SQLERRM);


    END INIT_FAVORI;

   PROCEDURE INSERT_FAVORI(   p_idarpege        IN VARCHAR2,
                              p_ident           IN VARCHAR2,
                              p_message         OUT VARCHAR2) IS


    BEGIN


        p_message := '' ;

        INSERT INTO ISAC_RESSOURCE_FAVORITE (IDARPEGE,IDENT)
        VALUES (p_idarpege,p_ident);


    EXCEPTION
        WHEN OTHERS THEN
           raise_application_error(-20997,SQLERRM);


    END INSERT_FAVORI;

-- debut PPM 57865 : IS_RESSOURCE_FAVORIS procédure de vérification si l'utilisateur a paramétré des favoris

   PROCEDURE IS_RESSOURCE_FAVORIS(     p_idarpege      IN VARCHAR2,
                              p_result       OUT VARCHAR2,
                              p_message       OUT VARCHAR2) IS

  l_nbrefavoris NUMBER;
    BEGIN

        p_message := '' ;

        SELECT COUNT (*) into l_nbrefavoris
        FROM ISAC_RESSOURCE_FAVORITE
        WHERE IDARPEGE =p_idarpege;

        IF  l_nbrefavoris > 0 THEN
          p_result := 'true';
        ELSE
          p_result := 'false';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
           raise_application_error(-20997,SQLERRM);

    END IS_RESSOURCE_FAVORIS;
-- Fin PPM 57865 : IS_RESSOURCE_FAVORIS


END PACK_ISAC_FAVORI;
/





show errors