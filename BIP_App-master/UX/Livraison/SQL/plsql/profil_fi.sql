create or replace
PACKAGE     PACK_PROFIL_FI AS


    TYPE t_array IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;

    TYPE RefCurTyp IS REF CURSOR;
    TYPE profil_fiCurType IS REF CURSOR RETURN profil_fi%ROWTYPE;

    FUNCTION LIST_CAFI ( p_code_es   IN PROFIL_FI.CODE_ES%TYPE )

    RETURN VARCHAR2;

    FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array;

    FUNCTION get_token( p_list      VARCHAR2,
                        p_index     NUMBER,
                        p_delim     VARCHAR2 := ','
                      )
    RETURN VARCHAR2  ;

    TYPE string_array IS TABLE OF VARCHAR2(1000);
    FUNCTION SPLIT_STRING ( p_str       IN VARCHAR2,
                            p_delim     IN CHAR default ','
                          )
    RETURN string_array;

    FUNCTION GEN_LIST_SPLIT( p_str       IN VARCHAR2,
                             p_delim     IN CHAR default ','
                           )
    RETURN VARCHAR2;

   PROCEDURE INSERT_PROFIL_FI( p_profi                  IN  PROFIL_FI.PROFIL_FI%TYPE,
                               p_libelle                IN  PROFIL_FI.LIBELLE%TYPE,
                               p_date_effet             IN  VARCHAR2,
                               p_top_actif              IN  PROFIL_FI.TOP_ACTIF%TYPE,
                               p_cout                   IN  PROFIL_FI.COUT%TYPE,
                               p_commentaire            IN  PROFIL_FI.COMMENTAIRE%TYPE,
                               p_coddir                 IN  PROFIL_FI.CODDIR%TYPE,
                               p_topegalprestation      IN  PROFIL_FI.TOPEGALPRESTATION%TYPE,
                               p_prestation             IN  PROFIL_FI.PRESTATION%TYPE,
                               p_topegallocalisation    IN  PROFIL_FI.TOPEGALLOCALISATION%TYPE,
                               p_localisation           IN  PROFIL_FI.LOCALISATION%TYPE,
                               p_topegales              IN  PROFIL_FI.TOPEGALES%TYPE,
                               p_code_es                IN  PROFIL_FI.CODE_ES%TYPE,
                               p_userid                 IN  VARCHAR2,
                               p_nbcurseur              OUT INTEGER,
                               p_message                OUT VARCHAR2
                              );


   PROCEDURE DELETE_PROFIL_FI (p_profi               IN PROFIL_FI.PROFIL_FI%TYPE,
                               p_date_effet          IN  VARCHAR2,
                               p_userid              IN  VARCHAR2,
                               p_nbcurseur           OUT INTEGER,
                               p_message             OUT VARCHAR2
                              );

   PROCEDURE SELECT_PROFIL_FI (p_profi                IN  PROFIL_FI.PROFIL_FI%TYPE,
                               p_date_effet           IN  VARCHAR2,
                               p_userid               IN  VARCHAR2,
                               p_curprofil_fi         IN OUT profil_fiCurType,
                               p_nbcurseur            OUT INTEGER,
                               p_message              OUT VARCHAR2,
                               p_fi_ress              OUT VARCHAR2
                              );

   PROCEDURE UPDATE_PROFIL_FI (p_profi                  IN  PROFIL_FI.PROFIL_FI%TYPE,
                               p_libelle                IN  PROFIL_FI.LIBELLE%TYPE,
                               p_date_effet             IN  VARCHAR2,
                               p_top_actif              IN  PROFIL_FI.TOP_ACTIF%TYPE,
                               p_cout                   IN  PROFIL_FI.COUT%TYPE,
                               p_commentaire            IN  PROFIL_FI.COMMENTAIRE%TYPE,
                               p_coddir                 IN  PROFIL_FI.CODDIR%TYPE,
                               p_topegalprestation      IN  PROFIL_FI.TOPEGALPRESTATION%TYPE,
                               p_prestation             IN  PROFIL_FI.PRESTATION%TYPE,
                               p_topegallocalisation    IN  PROFIL_FI.TOPEGALLOCALISATION%TYPE,
                               p_localisation           IN  PROFIL_FI.LOCALISATION%TYPE,
                               p_topegales              IN  PROFIL_FI.TOPEGALES%TYPE,
                               p_code_es                IN  PROFIL_FI.CODE_ES%TYPE,
                               p_userid                 IN  VARCHAR2,
                               p_nbcurseur              OUT INTEGER,
                               p_message                OUT VARCHAR2
                              );

    -- ********************************************************************************** --
    -- Liste Profils de FI
    -- ********************************************************************************** --

    TYPE list_profilfi_View IS RECORD (
                                       P_PROFI   PROFIL_FI.PROFIL_FI%TYPE,
                                       P_LIBELLE VARCHAR2(500)
                                      );

    TYPE list_profilfi_ViewCurType IS REF CURSOR RETURN list_profilfi_View;

    PROCEDURE LISTER_PROFIL_FI( p_profi         IN PROFIL_FI.PROFIL_FI%TYPE,
                                p_filtre_date   IN VARCHAR2,
                                p_userid        IN VARCHAR2,
                                p_curseur       IN OUT list_profilfi_ViewCurType,
                                p_message       OUT VARCHAR2
                              );

    -- ********************************************************************************** --
    -- Liste Détails Profils de FI
    -- ********************************************************************************** --

    TYPE details_profilfi_View IS RECORD (
                                            P_PROFI     PROFIL_FI.PROFIL_FI%TYPE,
                                            P_LIBELLE   VARCHAR2(1000)
                                         );

    TYPE details_profilfi_ViewCurType IS REF CURSOR RETURN details_profilfi_View;

    PROCEDURE LISTER_DETAILS_PROFIL_FI( p_profi         IN PROFIL_FI.PROFIL_FI%TYPE,
                                        p_filtre_date   IN VARCHAR2,
                                        p_userid        IN VARCHAR2,
                                        p_curseur       IN OUT details_profilfi_ViewCurType,
                                        p_message       OUT VARCHAR2
                                      );

    PROCEDURE MAJ_PROFIL_FI_LOGS ( p_profi           IN  PROFIL_FI_LOGS.PROFIL_FI%TYPE,
                                   p_date_effet      IN  VARCHAR2,
                                   p_user_log        IN  PROFIL_FI_LOGS.USER_LOG%TYPE,
                                   p_colonne         IN  PROFIL_FI_LOGS.COLONNE%TYPE,
                                   p_valeur_prec     IN  PROFIL_FI_LOGS.VALEUR_PREC%TYPE,
                                   p_valeur_nouv     IN  PROFIL_FI_LOGS.VALEUR_NOUV%TYPE,
                                   p_commentaire     IN  PROFIL_FI_LOGS.COMMENTAIRE%TYPE
                                 );

      PROCEDURE isFiRessource ( p_profi           IN  PROFIL_FI.PROFIL_FI%TYPE,
                                p_date_effet      IN  VARCHAR2,
                                p_userid          IN  VARCHAR2,
                                p_message         OUT VARCHAR2
                              );

      PROCEDURE isValidCodeDir ( p_coddir          IN  VARCHAR2,
                                 p_userid          IN  VARCHAR2,
                                 p_message         OUT VARCHAR2
                               );

    PROCEDURE isValidProfilFI ( p_profil_fi          IN  VARCHAR2,
                                p_userid          IN  VARCHAR2,
                                p_message         OUT VARCHAR2
                             );

    PROCEDURE getLibelle_ProfilFI (  p_profil_fi       IN  VARCHAR2,
                                     p_date_effet      IN  VARCHAR2,
                                     p_userid          IN  VARCHAR2,
                                     p_libelle         OUT VARCHAR2,
                                     p_message         OUT VARCHAR2
                                  );


    FUNCTION PROFILFI_SEUIL_VALUES (  p_valeur       IN  VARCHAR2,
                                      p_separateur   IN  VARCHAR2,
                                      p_param        IN  NUMBER
                                   ) RETURN  VARCHAR2;

    FUNCTION PROFILFI_SEUIL_PARAM (p_codsg IN NUMBER)
         RETURN       VARCHAR2;

 PROCEDURE verif_direction_perime(  p_coddir    IN  VARCHAR2,
                                    p_userid    IN  VARCHAR2,
                                    p_message   OUT VARCHAR2
                                 ) ;

PROCEDURE PROFILFI_EXISTS ( p_profil IN  PROFIL_FI.PROFIL_FI%TYPE, 
                            p_message OUT MESSAGE.LIMSG%TYPE
                          ) ;

END PACK_PROFIL_FI;
/

CREATE OR REPLACE PACKAGE BODY     PACK_PROFIL_FI AS

PROCEDURE UNICITY_CHECK ( p_profil_fi          IN  VARCHAR2,
                                p_userid          IN  VARCHAR2,
                                p_message         OUT VARCHAR2
                             ) IS

      l_msg VARCHAR2(1024);
      L_USER                  VARCHAR2 (30);
      l_presence              NUMBER;
      PROFILFI_INTEGRITY     EXCEPTION;

    BEGIN
        p_message := '';       
        /*Changes for BIP-224 profil fi unicity -- starts*/
         BEGIN
          SELECT NVL(COUNT (*),0) INTO L_PRESENCE FROM PROFIL_DOMFONC WHERE UPPER(PROFIL_DOMFONC) = UPPER(p_profil_fi);
          IF(L_PRESENCE = 0) THEN
          BEGIN
              SELECT NVL(COUNT (*),0) INTO L_PRESENCE FROM PROFIL_LOCALIZE WHERE UPPER(PROFIL_LOCALIZE) = UPPER(p_profil_fi);
              IF(L_PRESENCE != 0) THEN
                RAISE PROFILFI_INTEGRITY;
              END IF;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
              L_PRESENCE := 0;
            END;           
          ELSE
            RAISE PROFILFI_INTEGRITY;
          END IF;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        L_PRESENCE := 0;
        END;
        /*Changes for BIP-224 profil fi unicity -- ends*/        
    EXCEPTION
        
        WHEN PROFILFI_INTEGRITY THEN
        pack_global.recuperer_message(21320, null, p_profil_fi, NULL, l_msg);
        p_message := l_msg;
    END UNICITY_CHECK;

    FUNCTION LIST_CAFI ( p_code_es   IN PROFIL_FI.CODE_ES%TYPE )

    RETURN VARCHAR2 IS

    CURSOR C_ES IS
    SELECT lpad(to_char(codcamo),6,'0') codcamo FROM centre_activite
    WHERE to_char(codcamo) IN (p_code_es)
                  OR to_char(CANIV1) IN (p_code_es)
                  OR to_char(CANIV2) IN (p_code_es)
                  OR to_char(CANIV3) IN (p_code_es)
                  OR to_char(CANIV4) IN (p_code_es)
                  OR to_char(CANIV5) IN (p_code_es)
                  OR to_char(CANIV6) IN (p_code_es);

    T_ES            C_ES%ROWTYPE;
    CAFI_LIST       VARCHAR2(32000);

    BEGIN
       CAFI_LIST :='';
       OPEN  C_ES;
       LOOP

                FETCH C_ES INTO T_ES;
                EXIT WHEN C_ES%NOTFOUND;
                CAFI_LIST := CAFI_LIST || to_char(T_ES.codcamo) || ',';


       END LOOP;
       CLOSE C_ES;

       RETURN CAFI_LIST;

    EXCEPTION

    WHEN OTHERS THEN
    raise_application_error( -20997, SQLERRM);
    NULL;

    END LIST_CAFI;

-- *********************************************************************************
--       Procedure   AJOUT  PROFIL DE FI
-- *********************************************************************************

   PROCEDURE INSERT_PROFIL_FI (p_profi                  IN  PROFIL_FI.PROFIL_FI%TYPE,
                               p_libelle                IN  PROFIL_FI.LIBELLE%TYPE,
                               p_date_effet             IN  VARCHAR2,
                               p_top_actif              IN  PROFIL_FI.TOP_ACTIF%TYPE,
                               p_cout                   IN  PROFIL_FI.COUT%TYPE,
                               p_commentaire            IN  PROFIL_FI.COMMENTAIRE%TYPE,
                               p_coddir                 IN  PROFIL_FI.CODDIR%TYPE,
                               p_topegalprestation      IN  PROFIL_FI.TOPEGALPRESTATION%TYPE,
                               p_prestation             IN  PROFIL_FI.PRESTATION%TYPE,
                               p_topegallocalisation    IN  PROFIL_FI.TOPEGALLOCALISATION%TYPE,
                               p_localisation           IN  PROFIL_FI.LOCALISATION%TYPE,
                               p_topegales              IN  PROFIL_FI.TOPEGALES%TYPE,
                               p_code_es                IN  PROFIL_FI.CODE_ES%TYPE,
                               p_userid                 IN VARCHAR2,
                               p_nbcurseur              OUT INTEGER,
                               p_message                OUT VARCHAR2
                              ) IS

   l_msg                VARCHAR2(1024);
   l_profi              VARCHAR2(1024);
   L_USER               VARCHAR2(7);
   l_presence           NUMBER;
   l_num_ligne          NUMBER;

   CODDIR_INTEGRITY          EXCEPTION;
   CODE_LOCALISATION_EXP     EXCEPTION;
   CODE_PRESTATION_EXP       EXCEPTION;
   CODE_ES_EXP               EXCEPTION;
   PROFIL_FI_EXP             EXCEPTION;
   PROFIL_FI_SEUIL_EXP       EXCEPTION;

   CURSOR C_PROFILFI IS
                SELECT PFI.PROFIL_FI
                FROM PROFIL_FI PFI
                WHERE PFI.PROFIL_FI  = p_profi;

    param varchar2(100);
    CURSOR C_LOCAL (param IN varchar2) IS
        SELECT count(mc.CODE_LOCALISATION) CODE_LOCALISATION
        FROM mode_contractuel mc
        WHERE mc.CODE_LOCALISATION = param
        AND ROWNUM<=1;
    T_LOCAL   C_LOCAL%ROWTYPE;

    CURSOR C_ES (param IN varchar2) IS
        SELECT count(ES.CODCAMO) CODCAMO
        FROM ENTITE_STRUCTURE ES
        WHERE ES.CODCAMO = param;
    T_ES            C_ES%ROWTYPE;

    CURSOR C_PREST (param IN varchar2) IS
        SELECT count(P.PRESTATION) PRESTATION
        FROM PRESTATION P
        WHERE TRIM(P.PRESTATION) like replace(TRIM(param),'*','%')
        AND ROWNUM<=1;
    T_PREST            C_PREST%ROWTYPE;

    return_value_l  bip.pack_profil_fi.string_array;
    return_value_p  bip.pack_profil_fi.string_array;
    return_value_es bip.pack_profil_fi.string_array;

    l_var VARCHAR2(200);

   BEGIN


          BEGIN

             SELECT COUNT (*)
             INTO l_presence
             FROM DIRECTIONS
             WHERE to_char(coddir) = p_coddir;

            IF(p_date_effet is null or p_date_effet='') THEN

                OPEN C_PROFILFI;
                                FETCH C_PROFILFI INTO l_profi;
                                IF C_PROFILFI%FOUND THEN
                                    RAISE PROFIL_FI_EXP;
                                END IF;
                CLOSE C_PROFILFI;

            END IF;

            IF(p_profi is not null and p_date_effet is not null) THEN

                IF(l_presence = 0) THEN

                    RAISE CODDIR_INTEGRITY;

                ELSE

                        BEGIN
                            SELECT  count(NUM_LIGNE)
                                    INTO l_num_ligne
                                    FROM ligne_param_bip
                                    WHERE code_action = 'PROFILSFI-SEUILS'
                                    AND   code_version = to_char(p_coddir)
                                    AND   num_ligne = (SELECT MIN (num_ligne) FROM ligne_param_bip
                                                           WHERE code_version = to_char(p_coddir)
                                                           AND   code_action = 'PROFILSFI-SEUILS'
                                                           AND   actif = 'O'
                                                           );
                        EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                             pack_global.recuperer_message(4617, NULL, NULL, NULL, p_message);
                             raise_application_error( -20226, p_message);
                        END;

                    IF(l_num_ligne = 0 or l_num_ligne is null) THEN
                        RAISE PROFIL_FI_SEUIL_EXP;
                    ELSE

                        return_value_l := split_string(
                        p_str=>p_localisation,
                        p_delim=>',');

                        return_value_p := split_string(
                        p_str=>p_prestation,
                        p_delim=>',');

                        return_value_es := split_string(
                        p_str=>p_code_es,
                        p_delim=>',');

                        IF return_value_p.count > 0 THEN

                              FOR i IN 1..return_value_p.COUNT LOOP

                                  OPEN C_PREST (TRIM(return_value_p(i))) ;
                                      l_var := return_value_p(i);
                                      LOOP

                                        FETCH C_PREST INTO T_PREST ;
                                        EXIT WHEN C_PREST%NOTFOUND;

                                        IF(T_PREST.PRESTATION =0) THEN
                                            RAISE CODE_PRESTATION_EXP;
                                        END IF;

                                      END LOOP;

                                  CLOSE C_PREST ;

                              END LOOP;

                        END IF;

                        IF return_value_l.count > 0 THEN

                              FOR i IN 1..return_value_l.COUNT LOOP

                                  OPEN C_LOCAL (TRIM(return_value_l(i))) ;
                                      l_var := return_value_l(i);
                                      LOOP

                                        FETCH C_LOCAL INTO T_LOCAL ;
                                        EXIT WHEN C_LOCAL%NOTFOUND;

                                        IF(T_LOCAL.CODE_LOCALISATION =0) THEN
                                            RAISE CODE_LOCALISATION_EXP;
                                        END IF;

                                      END LOOP;

                                  CLOSE C_LOCAL ;

                              END LOOP;

                        END IF;


                        IF p_code_es is not null and return_value_es.count > 0 THEN

                              FOR i IN 1..return_value_es.COUNT LOOP

                                  OPEN C_ES (TRIM(return_value_es(i))) ;
                                      l_var := return_value_es(i);
                                      LOOP

                                        FETCH C_ES INTO T_ES ;
                                        EXIT WHEN C_ES%NOTFOUND;

                                        IF(T_ES.CODCAMO =0) THEN
                                            RAISE CODE_ES_EXP;
                                        END IF;

                                      END LOOP;

                                  CLOSE C_ES ;

                              END LOOP;

                        END IF;

                        INSERT INTO PROFIL_FI
                                (
                                PROFIL_FI,
                                LIBELLE,
                                DATE_EFFET,
                                TOP_ACTIF,
                                COUT,
                                COMMENTAIRE,
                                CODDIR,
                                TOPEGALPRESTATION,
                                PRESTATION,
                                TOPEGALLOCALISATION,
                                LOCALISATION,
                                TOPEGALES,
                                CODE_ES
                                )
                                VALUES
                                (
                                p_profi,
                                p_libelle,
                                TO_DATE(p_date_effet, 'MM/YYYY'),
                                p_top_actif,
                                p_cout,
                                p_commentaire,
                                p_coddir,
                                p_topegalprestation,
                                p_prestation,
                                p_topegallocalisation,
                                p_localisation,
                                p_topegales,
                                p_code_es
                                );


                                L_USER := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

                                MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER,'CODDIR', '', p_coddir,'Creation Profil de FI');
                                MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER,'TOP_ACTIF', '', p_top_actif,'Creation Profil de FI');
                                MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER,'COUT', '', p_cout,'Creation Profil de FI');
                                MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER,'TOPEGALPRESTATION', '', p_topegalprestation,'Creation Profil de FI');
                                MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER,'PRESTATION', '', p_prestation,'Creation Profil de FI');
                                MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER,'TOPEGALLOCALISATION', '', p_topegallocalisation,'Creation Profil de FI');
                                MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER,'LOCALISATION', '', p_localisation,'Creation Profil de FI');
                                MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER,'TOPEGALES', '', p_topegales,'Creation Profil de FI');
                                MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER,'CODE_ES', '', p_code_es,'Creation Profil de FI');

                                pack_global.recuperer_message(4600,'%s1', p_profi, '%s2', p_date_effet, NULL, p_message);
                    END IF;

                END IF;

            END IF;

          EXCEPTION

             WHEN CODDIR_INTEGRITY THEN
                pack_global.recuperer_message(20505,'%s1', p_coddir, NULL, NULL, 'coddir', p_message);-- 20505 : Code Direction Inexistant
                raise_application_error( -20505, p_message);
             WHEN PROFIL_FI_SEUIL_EXP THEN
                 pack_global.recuperer_message(4617, NULL, NULL, NULL, NULL, 'coddir', p_message);
                 raise_application_error( -20226, p_message);
             WHEN CODE_PRESTATION_EXP THEN
                pack_global.recuperer_message(4613,'%s1', l_var, NULL, NULL, 'prestation', p_message);
                raise_application_error( -20226, p_message);
             WHEN CODE_LOCALISATION_EXP THEN
                pack_global.recuperer_message(4612,'%s1', l_var, NULL, NULL, 'localisation', p_message);
                raise_application_error( -20226, p_message) ;
             WHEN CODE_ES_EXP THEN
                pack_global.recuperer_message(4614,'%s1', l_var, NULL, NULL, 'code_es', p_message);
                raise_application_error( -20226, p_message);
             WHEN PROFIL_FI_EXP THEN
                 pack_global.recuperer_message(4602,NULL, NULL, NULL,NULL,'date_effet', p_message);
                 raise_application_error( -20226, p_message);
             WHEN OTHERS THEN
                pack_global.recuperer_message(4611,'%s1', p_profi, '%s2', p_date_effet, NULL, NULL, 'date_effet', p_message);
                raise_application_error( -20226, p_message);

          END;

   END INSERT_PROFIL_FI;

-- *********************************************************************************
--       Procedure   SUPPRESSION  PROFIL DE FI
-- *********************************************************************************

   PROCEDURE DELETE_PROFIL_FI (p_profi                IN PROFIL_FI.PROFIL_FI%TYPE,
                               p_date_effet           IN  VARCHAR2,
                               p_userid               IN VARCHAR2,
                               p_nbcurseur            OUT INTEGER,
                               p_message              OUT VARCHAR2
                               ) IS

   L_USER                  VARCHAR2 (30);
   REFERENTIAL_INTEGRITY   EXCEPTION;
   l_presence              NUMBER;
   l_msg VARCHAR2(1024);

   CURSOR c_profil_fi IS
        SELECT PROFIL_FI
        FROM PROFIL_FI
        WHERE PROFIL_FI = p_profi
        AND DATE_EFFET = to_date(p_date_effet,'MM/YYYY');
   l_profil_fi c_profil_fi%ROWTYPE;

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';
      L_USER := SUBSTR (pack_global.lire_globaldata (p_userid).idarpege, 1, 30);

        OPEN c_profil_fi;
        FETCH c_profil_fi INTO l_profil_fi;

        IF c_profil_fi%NOTFOUND THEN
            PACK_GLOBAL.RECUPERER_MESSAGE(4604,'%s1', p_profi, '%s2', p_date_effet, NULL, l_msg);
            p_message := l_msg;
        ELSE

            DELETE FROM PROFIL_FI
            WHERE PROFIL_FI = p_profi
            AND TO_CHAR(DATE_EFFET,'MM/YYYY') = p_date_effet;

            MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER, 'TOUTES', 'TOUTES', NULL, 'Suppression du Profil de FI');
            PACK_GLOBAL.RECUPERER_MESSAGE(4606,'%s1', p_profi, '%s2', p_date_effet, NULL, l_msg);
            p_message := l_msg;

        END IF;
        CLOSE c_profil_fi;

   EXCEPTION

         WHEN OTHERS THEN
         PACK_GLOBAL.RECUPERER_MESSAGE(4604,'%s1', p_profi, '%s2', p_date_effet, NULL, l_msg);
         p_message := l_msg;


   END DELETE_PROFIL_FI;

-- *********************************************************************************
--       Procedure   SELECTION  PROFIL DE FI
-- *********************************************************************************

   PROCEDURE SELECT_PROFIL_FI (p_profi                IN PROFIL_FI.PROFIL_FI%TYPE,
                               p_date_effet           IN VARCHAR2,
                               p_userid               IN VARCHAR2,
                               p_curprofil_fi         IN OUT profil_fiCurType,
                               p_nbcurseur            OUT INTEGER,
                               p_message              OUT VARCHAR2,
                               p_fi_ress              OUT VARCHAR2
                              ) IS

    l_msg VARCHAR2(1024);
    p_libelle               PROFIL_FI.LIBELLE%TYPE;
    p_top_actif             PROFIL_FI.TOP_ACTIF%TYPE;
    p_cout                  PROFIL_FI.COUT%TYPE;
    l_profil    VARCHAR2(12);
    PROFIL_FI_EXP EXCEPTION;

   CURSOR c_fi_ress IS
        SELECT COUNT (*) COUNT
        FROM STOCK_FI
        WHERE PROFIL_FI = p_profi
        AND ROWNUM < 2;
   t_fi_ress c_fi_ress%ROWTYPE;

   CURSOR c_profil_fi IS
        SELECT LIBELLE, TOP_ACTIF, COUT
        INTO p_libelle, p_top_actif, p_cout
        FROM PROFIL_FI
        WHERE PROFIL_FI = p_profi
        AND TO_CHAR(DATE_EFFET,'MM/YYYY') = p_date_effet;
   l_profil_fi c_profil_fi%ROWTYPE;



   BEGIN
      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      p_nbcurseur := 1;
      p_message := '';
      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *
      p_fi_ress := '';

        OPEN p_curprofil_fi FOR
        SELECT *
        FROM PROFIL_FI
        WHERE PROFIL_FI = p_profi
        AND DATE_EFFET = to_date(p_date_effet,'MM/YYYY');


                OPEN c_profil_fi;
                FETCH c_profil_fi INTO l_profil_fi;

            IF c_profil_fi%FOUND THEN

                    OPEN c_fi_ress;
                    FETCH c_fi_ress INTO t_fi_ress;
                    CLOSE c_fi_ress;

                    IF (t_fi_ress.COUNT =0) THEN

                        PACK_GLOBAL.RECUPERER_MESSAGE(4608,'%s1', p_profi ||' -- Libellé: '||l_profil_fi.libelle, '%s2', p_date_effet ||' -- TOP ACTIF: '||l_profil_fi.top_actif ||' -- COÛT UNITAIRE: '||l_profil_fi.cout, NULL, l_msg);
                        p_fi_ress := l_msg;
                        pack_global.recuperer_message(4602,NULL, NULL, NULL, p_message);


                    ELSE

                        PACK_GLOBAL.RECUPERER_MESSAGE(4609,'%s1', p_profi ||' -- Libellé: '||l_profil_fi.libelle, '%s2', p_date_effet ||' -- TOP ACTIF: '||l_profil_fi.top_actif ||' -- COÛT UNITAIRE: '||l_profil_fi.cout, NULL, l_msg);
                        p_fi_ress := l_msg;
                        pack_global.recuperer_message(4602,NULL, NULL, NULL, p_message);


                    END IF;

            ELSE

                pack_global.recuperer_message(4604,NULL, NULL, NULL, l_msg);
                p_message := l_msg;


            END IF;
            CLOSE c_profil_fi;

   EXCEPTION

            WHEN OTHERS THEN
            pack_global.recuperer_message(4602,NULL, NULL, NULL, p_message);


   END SELECT_PROFIL_FI;


-- *********************************************************************************
--       Procedure   MISE A JOUR  PROFIL FI
-- *********************************************************************************
   PROCEDURE UPDATE_PROFIL_FI (p_profi                  IN  PROFIL_FI.PROFIL_FI%TYPE,
                               p_libelle                IN  PROFIL_FI.LIBELLE%TYPE,
                               p_date_effet             IN  VARCHAR2,
                               p_top_actif              IN  PROFIL_FI.TOP_ACTIF%TYPE,
                               p_cout                   IN  PROFIL_FI.COUT%TYPE,
                               p_commentaire            IN  PROFIL_FI.COMMENTAIRE%TYPE,
                               p_coddir                 IN  PROFIL_FI.CODDIR%TYPE,
                               p_topegalprestation      IN  PROFIL_FI.TOPEGALPRESTATION%TYPE,
                               p_prestation             IN  PROFIL_FI.PRESTATION%TYPE,
                               p_topegallocalisation    IN  PROFIL_FI.TOPEGALLOCALISATION%TYPE,
                               p_localisation           IN  PROFIL_FI.LOCALISATION%TYPE,
                               p_topegales              IN  PROFIL_FI.TOPEGALES%TYPE,
                               p_code_es                IN  PROFIL_FI.CODE_ES%TYPE,
                               p_userid                 IN  VARCHAR2,
                               p_nbcurseur              OUT INTEGER,
                               p_message                OUT VARCHAR2
                              ) IS

   L_USER                       VARCHAR2(7);
   L_LIBELLE_OLD                PROFIL_FI.LIBELLE%TYPE;
   L_TOP_ACTIF_OLD              PROFIL_FI.TOP_ACTIF%TYPE;
   L_COUT_OLD                   PROFIL_FI.COUT%TYPE;
   L_COMMENTAIRE_OLD            PROFIL_FI.COMMENTAIRE%TYPE;
   L_CODDIR_OLD                 PROFIL_FI.CODDIR%TYPE;
   L_TOPEGALPRESTATION_OLD      PROFIL_FI.TOPEGALPRESTATION%TYPE;
   L_PRESTATION_OLD             PROFIL_FI.PRESTATION%TYPE;
   L_TOPEGALLOCALISATION_OLD    PROFIL_FI.TOPEGALLOCALISATION%TYPE;
   L_LOCALISATION_OLD           PROFIL_FI.LOCALISATION%TYPE;
   L_TOPEGALES_OLD              PROFIL_FI.TOPEGALES%TYPE;
   L_CODE_ES_OLD                PROFIL_FI.CODE_ES%TYPE;

   CODE_LOCALISATION_EXP     EXCEPTION;
   CODE_PRESTATION_EXP       EXCEPTION;
   CODE_ES_EXP               EXCEPTION;
   CODDIR_INTEGRITY          EXCEPTION;
   PROFIL_FI_SEUIL_EXP       EXCEPTION;

    param varchar2(100);
    CURSOR C_LOCAL (param IN varchar2) IS
        SELECT count(mc.CODE_LOCALISATION) CODE_LOCALISATION
        FROM mode_contractuel mc
        WHERE mc.CODE_LOCALISATION = param
        AND ROWNUM<=1;
    T_LOCAL   C_LOCAL%ROWTYPE;

    CURSOR C_ES (param IN varchar2) IS
        SELECT count(ES.CODCAMO) CODCAMO
        FROM ENTITE_STRUCTURE ES
        WHERE ES.CODCAMO = param;
    T_ES            C_ES%ROWTYPE;

    CURSOR C_PREST (param IN varchar2) IS
        SELECT count(P.PRESTATION) PRESTATION
        FROM PRESTATION P
        WHERE TRIM(P.PRESTATION) like replace(TRIM(param),'*','%')
        AND ROWNUM<=1;
    T_PREST            C_PREST%ROWTYPE;

    return_value_l  bip.pack_profil_fi.string_array;
    return_value_p  bip.pack_profil_fi.string_array;
    return_value_es bip.pack_profil_fi.string_array;

    l_var        VARCHAR2(200);
    l_presence   NUMBER;
    l_num_ligne  NUMBER;

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';


      BEGIN

            SELECT COUNT (*)
            INTO l_presence
            FROM DIRECTIONS
            WHERE to_char(coddir) = p_coddir;

        IF(l_presence = 0) THEN
            RAISE CODDIR_INTEGRITY;
        ELSE

            BEGIN
                SELECT  count(NUM_LIGNE)
                        INTO l_num_ligne
                        FROM ligne_param_bip
                        WHERE code_action = 'PROFILSFI-SEUILS'
                        AND   code_version = to_char(p_coddir)
                        AND   num_ligne = (SELECT MIN (num_ligne) FROM ligne_param_bip
                                               WHERE code_version = to_char(p_coddir)
                                               AND   code_action = 'PROFILSFI-SEUILS'
                                               AND   actif = 'O'
                                               );
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 pack_global.recuperer_message(4617, NULL, NULL, NULL, p_message);
                 raise_application_error( -20226, p_message);
            END;


            IF(l_num_ligne = 0 or l_num_ligne is null) THEN
                RAISE PROFIL_FI_SEUIL_EXP;
            ELSE

                   -- ********************************************************************************************
                   return_value_l := split_string(
                    p_str=>p_localisation,
                    p_delim=>',');

                    return_value_p := split_string(
                    p_str=>p_prestation,
                    p_delim=>',');

                    return_value_es := split_string(
                    p_str=>p_code_es,
                    p_delim=>',');

                    IF return_value_p.count > 0 THEN

                          FOR i IN 1..return_value_p.COUNT LOOP


                              OPEN C_PREST (TRIM(return_value_p(i))) ;
                                  l_var := return_value_p(i);
                                  LOOP

                                    FETCH C_PREST INTO T_PREST ;
                                    EXIT WHEN C_PREST%NOTFOUND;

                                    IF(T_PREST.PRESTATION =0) THEN
                                        RAISE CODE_PRESTATION_EXP;
                                    END IF;

                                  END LOOP;

                              CLOSE C_PREST ;

                          END LOOP;

                    END IF;

                    IF return_value_l.count > 0 THEN

                          FOR i IN 1..return_value_l.COUNT LOOP


                              OPEN C_LOCAL (TRIM(return_value_l(i))) ;
                                  l_var := return_value_l(i);
                                  LOOP

                                    FETCH C_LOCAL INTO T_LOCAL ;
                                    EXIT WHEN C_LOCAL%NOTFOUND;

                                    IF(T_LOCAL.CODE_LOCALISATION =0) THEN
                                        RAISE CODE_LOCALISATION_EXP;
                                    END IF;

                                  END LOOP;

                              CLOSE C_LOCAL ;

                          END LOOP;

                    END IF;

                    IF p_code_es is not null and return_value_es.count > 0 THEN

                          FOR i IN 1..return_value_es.COUNT LOOP

                              OPEN C_ES (TRIM(return_value_es(i))) ;
                                  l_var := return_value_es(i);
                                  LOOP

                                    FETCH C_ES INTO T_ES ;
                                    EXIT WHEN C_ES%NOTFOUND;

                                    IF(T_ES.CODCAMO =0) THEN
                                        RAISE CODE_ES_EXP;
                                    END IF;

                                  END LOOP;

                              CLOSE C_ES ;

                          END LOOP;

                    END IF;

                -- *****************************************************************************************

                -- ***************** BLOC COMPARAISON : ANCIENS VALEURS ************************************
                    BEGIN
                        SELECT PFI.LIBELLE, PFI.TOP_ACTIF, PFI.COUT, PFI.COMMENTAIRE, PFI.CODDIR, PFI.TOPEGALPRESTATION, PFI.PRESTATION,
                               PFI.TOPEGALLOCALISATION, PFI.LOCALISATION, PFI.TOPEGALES, PFI.CODE_ES
                        INTO L_LIBELLE_OLD, L_TOP_ACTIF_OLD, L_COUT_OLD, L_COMMENTAIRE_OLD, L_CODDIR_OLD, L_TOPEGALPRESTATION_OLD,
                        L_PRESTATION_OLD, L_TOPEGALLOCALISATION_OLD, L_LOCALISATION_OLD, L_TOPEGALES_OLD, L_CODE_ES_OLD
                        FROM PROFIL_FI PFI
                        WHERE PROFIL_FI = P_PROFI
                        AND TO_CHAR(DATE_EFFET,'MM/YYYY') = p_date_effet;
                    END;
                -- *****************************************************************************************

                    IF(L_LIBELLE_OLD != p_libelle) THEN

                            UPDATE PROFIL_FI SET LIBELLE                = p_libelle,
                                                 TOP_ACTIF              = p_top_actif,
                                                 COUT                   = p_cout,
                                                 COMMENTAIRE            = p_commentaire,
                                                 CODDIR                 = p_coddir,
                                                 TOPEGALPRESTATION      = p_topegalprestation,
                                                 PRESTATION             = p_prestation,
                                                 TOPEGALLOCALISATION    = p_topegallocalisation,
                                                 LOCALISATION           = p_localisation,
                                                 TOPEGALES              = p_topegales,
                                                 CODE_ES                = p_code_es
                            WHERE PROFIL_FI = p_profi;


                    ELSE

                            UPDATE PROFIL_FI SET LIBELLE                = p_libelle,
                                                 DATE_EFFET             = TO_DATE(p_date_effet, 'MM/YYYY'),
                                                 TOP_ACTIF              = p_top_actif,
                                                 COUT                   = p_cout,
                                                 COMMENTAIRE            = p_commentaire,
                                                 CODDIR                 = p_coddir,
                                                 TOPEGALPRESTATION      = p_topegalprestation,
                                                 PRESTATION             = p_prestation,
                                                 TOPEGALLOCALISATION    = p_topegallocalisation,
                                                 LOCALISATION           = p_localisation,
                                                 TOPEGALES              = p_topegales,
                                                 CODE_ES                = p_code_es
                            WHERE PROFIL_FI = p_profi
                            AND to_char(date_effet,'MM/YYYY') = p_date_effet;
                    END IF;

                        L_USER := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
                        -- On loggue les champs dans la table Profil_fi_logs

                        MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER, 'TOP_ACTIF', L_TOP_ACTIF_OLD, p_top_actif, 'Modification Profil de FI');
                        MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER, 'COUT', L_COUT_OLD, p_cout, 'Modification Profil de FI');
                        MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER, 'CODDIR', L_CODDIR_OLD, p_coddir, 'Modification Profil de FI');
                        MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER, 'TOPEGALPRESTATION', L_TOPEGALPRESTATION_OLD, p_topegalprestation, 'Modification Profil de FI');
                        MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER, 'PRESTATION', L_PRESTATION_OLD, p_prestation, 'Modification Profil de FI');
                        MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER, 'TOPEGALLOCALISATION', L_TOPEGALLOCALISATION_OLD, p_topegallocalisation, 'Modification Profil de FI');
                        MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER, 'LOCALISATION', L_LOCALISATION_OLD, p_localisation, 'Modification Profil de FI');
                        MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER, 'TOPEGALES', L_TOPEGALES_OLD, p_topegales, 'Modification Profil de FI');
                        MAJ_PROFIL_FI_LOGS(p_profi, p_date_effet, L_USER, 'CODE_ES', L_CODE_ES_OLD, p_code_es, 'Modification Profil de FI');

                        pack_global.recuperer_message(4605,'%s1', p_profi, '%s2', p_date_effet, NULL, p_message);

            END IF;  -- Fin si l_num_ligne = 0
        END IF; -- Fin si l_presence=0

      EXCEPTION

         WHEN CODDIR_INTEGRITY THEN
            pack_global.recuperer_message(20505,'%s1', p_coddir, NULL, NULL, 'coddir', p_message);-- 20505 : Code Direction Inexistant
            raise_application_error( -20505, p_message);
         WHEN PROFIL_FI_SEUIL_EXP THEN
            pack_global.recuperer_message(4617, NULL, NULL, NULL, NULL, 'coddir', p_message);
            raise_application_error( -20226, p_message);
         WHEN CODE_PRESTATION_EXP THEN
            pack_global.recuperer_message(4613,'%s1', l_var, NULL, NULL, 'prestation', p_message);
            raise_application_error( -20226, p_message) ;
         WHEN CODE_LOCALISATION_EXP THEN
            pack_global.recuperer_message(4612,'%s1', l_var, NULL, NULL, 'localisation', p_message);
            raise_application_error( -20226, p_message) ;
         WHEN CODE_ES_EXP THEN
            pack_global.recuperer_message(4614,'%s1', l_var, NULL, NULL, 'code_es', p_message);
            raise_application_error( -20226, p_message) ;
         WHEN OTHERS THEN
            PACK_GLOBAL.RECUPERER_MESSAGE(4607,NULL, NULL, NULL, p_message);
            raise_application_error( -20226, p_message) ;

      END;


   END UPDATE_PROFIL_FI;


-- *********************************************************************************
--       Procedure   LISTE  PROFIL DE FI
-- *********************************************************************************

    PROCEDURE LISTER_PROFIL_FI( p_profi         IN PROFIL_FI.PROFIL_FI%TYPE,
                                p_filtre_date   IN VARCHAR2,
                                p_userid        IN VARCHAR2,
                                p_curseur       IN OUT list_profilfi_ViewCurType,
                                p_message       OUT VARCHAR2
                              ) IS


    l_liste     VARCHAR2(5000);
    l_profi     VARCHAR2(1024);
    l_libelle     VARCHAR2(1024);
    l_filtre_date     VARCHAR2(7);
    l_filtre_fi       VARCHAR2(12);

    CURSOR C_PROFILFI IS
                SELECT PFI.PROFIL_FI, PFI.LIBELLE
                FROM PROFIL_FI PFI
                WHERE PFI.PROFIL_FI  = p_profi;

    CURSOR  p_curseur2 IS
    SELECT DISTINCT
    PROFIL_FI,
    RPAD(NVL(to_char(PROFIL_FI), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
    from PROFIL_FI
    WHERE DATE_EFFET >= to_date(p_filtre_date,'MM/YYYY')
    AND (PROFIL_FI like p_profi||'%' OR PROFIL_FI = p_profi)
    order by PROFIL_FI asc;

    t_curseur2   p_curseur2%ROWTYPE;

    CURSOR p_curseur3 IS
    SELECT DISTINCT
    PROFIL_FI,
    RPAD(NVL(to_char(PROFIL_FI), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
    from PROFIL_FI
    WHERE DATE_EFFET >= to_date(p_filtre_date,'MM/YYYY')
    order by PROFIL_FI asc;

    t_curseur3   p_curseur3%ROWTYPE;

    CURSOR C_PROFILFI2 IS
            SELECT PFI.PROFIL_FI, PFI.LIBELLE
            FROM PROFIL_FI PFI
            WHERE PFI.PROFIL_FI like p_profi||'%';

    BEGIN


            IF(p_profi is not null or p_profi !='') THEN


                IF(p_filtre_date is null) THEN

                    OPEN C_PROFILFI;
                                    FETCH C_PROFILFI INTO l_profi, l_libelle;
                                    IF C_PROFILFI%NOTFOUND THEN
                                        pack_global.recuperer_message(4602,NULL, NULL, NULL, p_message);
                                            OPEN      p_curseur FOR
                                            SELECT DISTINCT
                                            PROFIL_FI,
                                            RPAD(NVL(to_char(PROFIL_FI), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                                            from PROFIL_FI
                                            order by PROFIL_FI asc;
                                    END IF;
                    CLOSE C_PROFILFI;

                    OPEN      p_curseur FOR
                              SELECT DISTINCT
                              PROFIL_FI,
                              RPAD(NVL(to_char(PROFIL_FI), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                              from PROFIL_FI
                              where PROFIL_FI = p_profi
                              order by PROFIL_FI asc;

                END IF;

                if(p_profi ='*') THEN

                    if(p_filtre_date ='*') then

                              OPEN      p_curseur FOR
                              SELECT DISTINCT
                              PROFIL_FI,
                              RPAD(NVL(to_char(PROFIL_FI), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                              from PROFIL_FI
                              order by PROFIL_FI asc;

                    else

                              IF(p_filtre_date is null) THEN

                                              OPEN      p_curseur FOR
                                              SELECT DISTINCT
                                              PROFIL_FI,
                                              RPAD(NVL(to_char(PROFIL_FI), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                                              from PROFIL_FI
                                              order by PROFIL_FI asc;
                              ELSE

                                      OPEN      p_curseur FOR
                                      SELECT DISTINCT
                                      PROFIL_FI,
                                      RPAD(NVL(to_char(PROFIL_FI), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                                      from PROFIL_FI
                                      WHERE DATE_EFFET >= to_date(p_filtre_date,'MM/YYYY') --to_char(date_effet,'MM/YYYY') >= p_filtre_date
                                      order by PROFIL_FI asc;

                                        OPEN p_curseur3;
                                        FETCH p_curseur3 INTO t_curseur3;
                                        IF p_curseur3%NOTFOUND THEN
                                            OPEN      p_curseur FOR
                                            SELECT DISTINCT
                                            ' ',
                                            RPAD(NVL(to_char(' '), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(' '), ' '), 90, ' ')
                                            FROM DUAL;
                                        END IF;
                                        CLOSE p_curseur3;

                              END IF;
                    end if;

                ELSE

                    IF(p_filtre_date ='*') THEN

                          OPEN      p_curseur FOR
                          SELECT DISTINCT
                          PROFIL_FI,
                          RPAD(NVL(to_char(PROFIL_FI), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                          FROM PROFIL_FI
                          WHERE PROFIL_FI like p_profi||'%'
                          ORDER BY PROFIL_FI ASC;

                        OPEN C_PROFILFI2;
                        FETCH C_PROFILFI2 INTO l_profi, l_libelle;
                        IF C_PROFILFI2%NOTFOUND THEN
                                OPEN      p_curseur FOR
                                SELECT DISTINCT
                                ' ',
                                RPAD(NVL(to_char(' '), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(' '), ' '), 90, ' ')
                                FROM DUAL;
                        END IF;
                        CLOSE C_PROFILFI2;

                    ELSE
                            OPEN      p_curseur FOR
                            SELECT DISTINCT
                            PROFIL_FI,
                            RPAD(NVL(to_char(PROFIL_FI), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                            from PROFIL_FI
                            WHERE DATE_EFFET >= to_date(p_filtre_date,'MM/YYYY')--to_char(date_effet,'MM/YYYY') >= p_filtre_date
                            AND (PROFIL_FI like p_profi||'%' OR PROFIL_FI = p_profi)
                            order by PROFIL_FI asc;

                            OPEN p_curseur2;
                            FETCH p_curseur2 INTO t_curseur2;
                            IF p_curseur2%NOTFOUND THEN
                                OPEN      p_curseur FOR
                                SELECT DISTINCT
                                ' ',
                                RPAD(NVL(to_char(' '), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(' '), ' '), 90, ' ')
                                FROM DUAL;
                            END IF;
                            CLOSE p_curseur2;

                    END IF;

                END IF;


            END IF;

    EXCEPTION
              WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR( -21174, SQLERRM);

    END  LISTER_PROFIL_FI;


-- *********************************************************************************
--       Procedure   LISTE  DETAILS PROFIL DE FI
-- *********************************************************************************

    PROCEDURE LISTER_DETAILS_PROFIL_FI( p_profi         IN PROFIL_FI.PROFIL_FI%TYPE,
                                        p_filtre_date   IN VARCHAR2,
                                        p_userid        IN VARCHAR2,
                                        p_curseur       IN OUT details_profilfi_ViewCurType,
                                        p_message       OUT VARCHAR2
                                      ) IS

      l_profi     VARCHAR2(1024);
      CURSOR C_PROFILFI IS
                SELECT PFI.PROFIL_FI
                FROM PROFIL_FI PFI
                WHERE PFI.PROFIL_FI  = p_profi;
      t_curseur   p_curseur%ROWTYPE;

      BEGIN

      if(p_profi is not null)   then

        OPEN C_PROFILFI;
        FETCH C_PROFILFI INTO l_profi;
        IF C_PROFILFI%NOTFOUND THEN

        OPEN      p_curseur FOR
        SELECT
        ' ',
        RPAD(NVL(to_char(' '), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(' '), ' '), 90, ' ')
        FROM DUAL;

        ELSE

                 CLOSE C_PROFILFI;

            if(p_filtre_date is null) then

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PFI.DATE_EFFET,'MM/YYYY'),
                RPAD(NVL(TO_CHAR(PFI.DATE_EFFET,'MM/YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PFI.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                RPAD(NVL(TO_CHAR(PFI.COUT) , '---'), 15, ' ') ||
                RPAD(NVL(PFI.CODDIR , '---'), 7, ' ') ||
                RPAD(NVL(PFI.TOPEGALPRESTATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.PRESTATION,0,31) , '---'), 32, ' ')||
                RPAD(NVL(PFI.TOPEGALLOCALISATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.LOCALISATION,0,31) , '---'), 32, ' ')
                FROM PROFIL_FI PFI
                WHERE PFI.PROFIL_FI = p_profi
                ORDER BY PFI.DATE_EFFET DESC;


                            OPEN C_PROFILFI;
                            FETCH C_PROFILFI INTO l_profi;
                            IF (l_profi is null) THEN
                                    OPEN    p_curseur FOR
                                    SELECT
                                    TO_CHAR(PFI.DATE_EFFET,'MM/YYYY'),
                                    RPAD(NVL(TO_CHAR(PFI.DATE_EFFET,'MM/YYYY') , '---'), 13, ' ') ||
                                    RPAD(NVL(DECODE(PFI.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                                    RPAD(NVL(TO_CHAR(PFI.COUT) , '---'), 15, ' ') ||
                                    RPAD(NVL(PFI.CODDIR , '---'), 7, ' ') ||
                                    RPAD(NVL(PFI.TOPEGALPRESTATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.PRESTATION,0,31) , '---'), 32, ' ')||
                                    RPAD(NVL(PFI.TOPEGALLOCALISATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.LOCALISATION,0,31) , '---'), 32, ' ')
                                    FROM PROFIL_FI PFI
                                    WHERE PFI.PROFIL_FI in (SELECT DISTINCT PROFIL_FI FROM PROFIL_FI WHERE ROWNUM <='1')
                                    ORDER BY PFI.PROFIL_FI ASC;
                            END IF;
                            CLOSE C_PROFILFI;
            else

                            OPEN C_PROFILFI;
                            FETCH C_PROFILFI INTO l_profi;
                            IF C_PROFILFI%NOTFOUND THEN

                            OPEN      p_curseur FOR
                            SELECT
                            ' ',
                            RPAD(NVL(to_char(' '), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(' '), ' '), 90, ' ')
                            FROM DUAL;
                            END IF;

                            CLOSE C_PROFILFI;



            end if;

            IF(p_profi ='*' and p_filtre_date is null) THEN

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PFI.DATE_EFFET,'MM/YYYY'),
                RPAD(NVL(TO_CHAR(PFI.DATE_EFFET,'MM/YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PFI.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                RPAD(NVL(TO_CHAR(PFI.COUT) , '---'), 15, ' ') ||
                RPAD(NVL(PFI.CODDIR , '---'), 7, ' ') ||
                RPAD(NVL(PFI.TOPEGALPRESTATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.PRESTATION,0,31) , '---'), 32, ' ')||
                RPAD(NVL(PFI.TOPEGALLOCALISATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.LOCALISATION,0,31) , '---'), 32, ' ')
                FROM PROFIL_FI PFI
                ORDER BY PFI.DATE_EFFET DESC;
            END IF;

            IF(p_profi ='*' and p_filtre_date ='*') THEN

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PFI.DATE_EFFET,'MM/YYYY'),
                RPAD(NVL(TO_CHAR(PFI.DATE_EFFET,'MM/YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PFI.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                RPAD(NVL(TO_CHAR(PFI.COUT) , '---'), 15, ' ') ||
                RPAD(NVL(PFI.CODDIR , '---'), 7, ' ') ||
                RPAD(NVL(PFI.TOPEGALPRESTATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.PRESTATION,0,31) , '---'), 32, ' ')||
                RPAD(NVL(PFI.TOPEGALLOCALISATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.LOCALISATION,0,31) , '---'), 32, ' ')
                FROM PROFIL_FI PFI
                WHERE PFI.PROFIL_FI IN (SELECT PROFIL_FI FROM ( SELECT PROFIL_FI FROM PROFIL_FI ORDER BY PROFIL_FI ASC ) WHERE ROWNUM<2)
                ORDER BY PFI.DATE_EFFET DESC;

            END IF;

            IF(p_profi ='*' and p_filtre_date <>'*') then

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PFI.DATE_EFFET,'MM/YYYY'),
                RPAD(NVL(TO_CHAR(PFI.DATE_EFFET,'MM/YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PFI.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                RPAD(NVL(TO_CHAR(PFI.COUT) , '---'), 15, ' ') ||
                RPAD(NVL(PFI.CODDIR , '---'), 7, ' ') ||
                RPAD(NVL(PFI.TOPEGALPRESTATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.PRESTATION,0,31) , '---'), 32, ' ')||
                RPAD(NVL(PFI.TOPEGALLOCALISATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.LOCALISATION,0,31) , '---'), 32, ' ')
                FROM PROFIL_FI PFI
                WHERE PFI.DATE_EFFET >= to_date(p_filtre_date,'MM/YYYY')
                -- *-D
                AND PFI.PROFIL_FI IN (SELECT PROFIL_FI FROM (  SELECT PROFIL_FI FROM PROFIL_FI PFI WHERE PFI.DATE_EFFET >= to_date(p_filtre_date,'MM/YYYY') AND ROWNUM<2 ) )
                ORDER BY PFI.DATE_EFFET DESC;

            END IF;

            if(p_profi <>'*' and p_filtre_date ='*') then

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PFI.DATE_EFFET,'MM/YYYY'),
                RPAD(NVL(TO_CHAR(PFI.DATE_EFFET,'MM/YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PFI.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                RPAD(NVL(TO_CHAR(PFI.COUT) , '---'), 15, ' ') ||
                RPAD(NVL(PFI.CODDIR , '---'), 7, ' ') ||
                RPAD(NVL(PFI.TOPEGALPRESTATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.PRESTATION,0,31) , '---'), 32, ' ')||
                RPAD(NVL(PFI.TOPEGALLOCALISATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.LOCALISATION,0,31) , '---'), 32, ' ')
                FROM PROFIL_FI PFI
                WHERE PFI.PROFIL_FI = p_profi
                ORDER BY PFI.DATE_EFFET DESC;

                OPEN C_PROFILFI;
                FETCH C_PROFILFI INTO l_profi;
                IF (l_profi is null) THEN
                        OPEN    p_curseur FOR
                        SELECT
                        TO_CHAR(PFI.DATE_EFFET,'MM/YYYY'),
                        RPAD(NVL(TO_CHAR(PFI.DATE_EFFET,'MM/YYYY') , '---'), 13, ' ') ||
                        RPAD(NVL(DECODE(PFI.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                        RPAD(NVL(TO_CHAR(PFI.COUT) , '---'), 15, ' ') ||
                        RPAD(NVL(PFI.CODDIR , '---'), 7, ' ') ||
                        RPAD(NVL(PFI.TOPEGALPRESTATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.PRESTATION,0,31) , '---'), 32, ' ')||
                        RPAD(NVL(PFI.TOPEGALLOCALISATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.LOCALISATION,0,31) , '---'), 32, ' ')
                        FROM PROFIL_FI PFI
                        WHERE PFI.PROFIL_FI in (SELECT DISTINCT PROFIL_FI FROM PROFIL_FI WHERE ROWNUM <='1')
                        ORDER BY PFI.PROFIL_FI ASC;
                END IF;
                CLOSE C_PROFILFI;

            end if;

            if(p_profi <>'*' and p_filtre_date <>'*') then

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PFI.DATE_EFFET,'MM/YYYY'),
                RPAD(NVL(TO_CHAR(PFI.DATE_EFFET,'MM/YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PFI.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                RPAD(NVL(TO_CHAR(PFI.COUT) , '---'), 15, ' ') ||
                RPAD(NVL(PFI.CODDIR , '---'), 7, ' ') ||
                RPAD(NVL(PFI.TOPEGALPRESTATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.PRESTATION,0,31) , '---'), 32, ' ')||
                RPAD(NVL(PFI.TOPEGALLOCALISATION , '---'), 2, ' ')||RPAD(NVL(SUBSTR(PFI.LOCALISATION,0,31) , '---'), 32, ' ')
                FROM PROFIL_FI PFI
                WHERE PFI.PROFIL_FI = p_profi
                AND PFI.DATE_EFFET >= to_date(p_filtre_date,'MM/YYYY')
                ORDER BY PFI.DATE_EFFET DESC;

                    IF(p_profi=' ') THEN

                    OPEN      p_curseur FOR
                    SELECT DISTINCT
                    ' ',
                    RPAD(NVL(to_char(' '), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(' '), ' '), 90, ' ')
                    FROM DUAL;

                    END IF;

            end if;
        END IF;
      end if;

    END  LISTER_DETAILS_PROFIL_FI;
-- *********************************************************************************
--       Procedure   GESTION DES LOGS - PROFIL DE FI
-- *********************************************************************************

    PROCEDURE MAJ_PROFIL_FI_LOGS (p_profi           IN  PROFIL_FI_LOGS.PROFIL_FI%TYPE,
                                  p_date_effet      IN  VARCHAR2,
                                  p_user_log        IN  PROFIL_FI_LOGS.USER_LOG%TYPE,
                                  p_colonne         IN  PROFIL_FI_LOGS.COLONNE%TYPE,
                                  p_valeur_prec     IN  PROFIL_FI_LOGS.VALEUR_PREC%TYPE,
                                  p_valeur_nouv     IN  PROFIL_FI_LOGS.VALEUR_NOUV%TYPE,
                                  p_commentaire     IN  PROFIL_FI_LOGS.COMMENTAIRE%TYPE
                                 ) IS
    BEGIN

            IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN

                INSERT INTO PROFIL_FI_LOGS
                    (PROFIL_FI, date_effet, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
                VALUES
                    (p_profi, TO_DATE(p_date_effet, 'MM/YYYY'), SYSDATE, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);

            END IF;
            -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

    END MAJ_PROFIL_FI_LOGS;


-- *********************************************************************************
--       Procedure   AJAX - PROFIL DE FI
-- *********************************************************************************

    PROCEDURE isFiRessource ( p_profi           IN  PROFIL_FI.PROFIL_FI%TYPE,
                              p_date_effet      IN  VARCHAR2,
                              p_userid          IN  VARCHAR2,
                              p_message         OUT VARCHAR2
                            ) IS

      l_msg VARCHAR2(1024);
      L_USER                  VARCHAR2 (30);
      l_presence              NUMBER;
      p_libelle               PROFIL_FI.LIBELLE%TYPE;
      p_top_actif             PROFIL_FI.TOP_ACTIF%TYPE;
      p_cout                  PROFIL_FI.COUT%TYPE;


    BEGIN

        -- Positionner le nb de curseurs ==> 0
        -- Initialiser le message retour

        p_message := '';

            SELECT COUNT (*)
            INTO l_presence
            FROM STOCK_FI
            WHERE PROFIL_FI = p_profi
            AND ROWNUM < 2;

            SELECT LIBELLE, TOP_ACTIF, COUT
            INTO p_libelle, p_top_actif, p_cout
            FROM PROFIL_FI
            WHERE PROFIL_FI = p_profi
            AND TO_CHAR(DATE_EFFET,'MM/YYYY') = p_date_effet;

            IF(l_presence = 0) THEN

                    PACK_GLOBAL.RECUPERER_MESSAGE(4608,'%s1', p_profi ||', Libellé: '||p_libelle, '%s2', p_date_effet, NULL, l_msg);
                    p_message := l_msg;

            ELSE
                    PACK_GLOBAL.RECUPERER_MESSAGE(4609,'%s1', p_profi ||', Libellé: '||p_libelle, '%s2', p_date_effet, NULL, l_msg);
                    p_message := l_msg;
            END IF;

    END isFiRessource;


-- *********************************************************************************
--       Procedure   AJAX - PROFIL DE FI - isValid Code Direcrion
-- *********************************************************************************
    PROCEDURE isValidCodeDir ( p_coddir          IN  VARCHAR2,--DIRECTIONS.CODDIR%TYPE,
                               p_userid          IN  VARCHAR2,
                               p_message         OUT VARCHAR2
                             ) IS

      l_msg VARCHAR2(1024);
      L_USER                  VARCHAR2 (30);
      l_presence              NUMBER;
      CODDIR_INTEGRITY     EXCEPTION;


    BEGIN

        -- Positionner le nb de curseurs ==> 0
        -- Initialiser le message retour

        p_message := '';

            SELECT COUNT (*)
            INTO l_presence
            FROM DIRECTIONS
            WHERE TO_CHAR(CODDIR) = p_coddir;


            IF(l_presence = 0) THEN

                    RAISE CODDIR_INTEGRITY;

            END IF;

    EXCEPTION

        WHEN CODDIR_INTEGRITY THEN
        pack_global.recuperer_message(20505,'%s1', p_coddir, NULL, l_msg);
        p_message := l_msg;

    END isValidCodeDir;

-- *********************************************************************************
--       Procedure   AJAX - PROFIL DE FI - isValid Profil FI
-- *********************************************************************************
    PROCEDURE isValidProfilFI ( p_profil_fi          IN  VARCHAR2,
                                p_userid          IN  VARCHAR2,
                                p_message         OUT VARCHAR2
                             ) IS

      l_msg VARCHAR2(1024);
      L_USER                  VARCHAR2 (30);
      l_presence              NUMBER;
      PROFILFI_INTEGRITY     EXCEPTION;


    BEGIN

        -- Positionner le nb de curseurs ==> 0
        -- Initialiser le message retour

        p_message := '';

            SELECT COUNT (*)
            INTO l_presence
            FROM PROFIL_FI
            WHERE PROFIL_FI like p_profil_fi||'%';

        IF(p_profil_fi <>'*') THEN
            IF(l_presence = 0) THEN

                    RAISE PROFILFI_INTEGRITY;

            END IF;
        END IF;
    EXCEPTION

        WHEN PROFILFI_INTEGRITY THEN
        pack_global.recuperer_message(4610,'%s1', p_profil_fi, NULL, l_msg);
        p_message := l_msg;

    END isValidProfilFI;

-- *********************************************************************************
--       Fonction   - Tools PROFIL DE FI - get_token
-- *********************************************************************************
   FUNCTION get_token( p_list       VARCHAR2,
                       p_index      NUMBER,
                       p_delim      VARCHAR2 := ','
                     ) return       VARCHAR2 IS

    deb_pos   NUMBER;
    fin_pos   NUMBER;
    l_list    VARCHAR2(100);
    r_list    VARCHAR2(100) :='';

    BEGIN


           IF p_index = 1 THEN
               deb_pos := 1;
           ELSE
               deb_pos := INSTR(p_list, p_delim, 1, p_index - 1);
               IF deb_pos = 0 THEN
                   RETURN 'NOK';
               ELSE
                   deb_pos := deb_pos + LENGTH(p_delim);
               END IF;
           END IF;

           fin_pos := INSTR(p_list, p_delim, deb_pos, 1);


       for p_index in 1..fin_pos loop

           IF fin_pos = 0 THEN
               l_list := '''' || SUBSTR(p_list, deb_pos) ||'''';
               r_list := r_list + l_list;
           ELSE
               l_list := '''' || SUBSTR(p_list, deb_pos, fin_pos - deb_pos) ||'''';
               r_list := r_list + l_list;
           END IF;

       end loop;

           RETURN r_list;

    END GET_TOKEN;

-- ***********************************************************************************************

    FUNCTION SPLIT_STRING( p_str       IN VARCHAR2,
                           p_delim     IN CHAR default ','
                         ) RETURN string_array IS

        return_value         string_array := string_array();
        split_str            LONG default p_str || p_delim;
        i                    NUMBER;

    BEGIN
        LOOP

            i := INSTR(split_str, p_delim);
            EXIT WHEN NVL(i,0) = 0;
            return_value.extend;
            return_value(return_value.count) := TRIM(SUBSTR(split_str, 1, i-1));
            split_str := SUBSTR(split_str, i + length(p_delim));

        END LOOP;
        RETURN return_value;
    END split_string;


    FUNCTION GEN_LIST_SPLIT( p_str       IN VARCHAR2,
                             p_delim     IN CHAR default ','
                           ) RETURN VARCHAR2 IS

        return_value bip.pack_profil_fi.string_array;
        l_list  VARCHAR2(100);
        i       NUMBER;

    BEGIN

          return_value := split_string(
                p_str=>p_str,
                p_delim=>p_delim);

          IF return_value.count > 0 THEN
                FOR i in 1..return_value.count LOOP
                    l_list := l_list || ''''||return_value(i)||''''||',';

                END LOOP;
                --dbms_output.put_line(substr(l_list, 1, LENGTH(l_list) -1)); --substr(l_list, 1, l_list.lenght)
          END IF;

        RETURN substr(l_list, 1, LENGTH(l_list) -1);

    END GEN_LIST_SPLIT;


    PROCEDURE getLibelle_ProfilFI (  p_profil_fi       IN  VARCHAR2,
                                     p_date_effet      IN  VARCHAR2,
                                     p_userid          IN  VARCHAR2,
                                     p_libelle         OUT VARCHAR2,
                                     p_message         OUT VARCHAR2
                                 ) IS

      l_msg VARCHAR2(1024);
      L_USER                  VARCHAR2 (30);
      l_presence              NUMBER;
      l_libelle               VARCHAR2(30);

   CURSOR c_profil_fi IS
        SELECT LIBELLE
        FROM PROFIL_FI
        WHERE PROFIL_FI = p_profil_fi;
   l_profil_fi c_profil_fi%ROWTYPE;

   CURSOR c_profil_fi2 IS
        SELECT LIBELLE
        FROM PROFIL_FI
        WHERE PROFIL_FI = p_profil_fi and to_char(date_effet,'MM/YYYY') = p_date_effet;
   l_profil_fi2 c_profil_fi2%ROWTYPE;
   
   CURSOR c_profil_domfonc IS
        SELECT PDOMFONC.PROFIL_DOMFONC 
		FROM PROFIL_DOMFONC PDOMFONC
		WHERE PDOMFONC.PROFIL_DOMFONC = p_profil_fi;
   l_profil_domfonc c_profil_domfonc%ROWTYPE;

    BEGIN

        -- Positionner le nb de curseurs ==> 0
        -- Initialiser le message retour

        p_message := '';
        UNICITY_CHECK(p_profil_fi, p_userid, p_message );

        IF(p_date_effet is null) THEN

            OPEN c_profil_fi;
            FETCH c_profil_fi INTO l_profil_fi;
            IF c_profil_fi%FOUND THEN
                        pack_global.recuperer_message(4602,NULL, NULL, NULL, p_message);
                        p_libelle := l_profil_fi.LIBELLE;

            END IF;
            CLOSE c_profil_fi;

        ELSE

            OPEN c_profil_fi2;
            FETCH c_profil_fi2 INTO l_profil_fi2;
            IF c_profil_fi2%FOUND THEN
                        pack_global.recuperer_message(4615,NULL, NULL, NULL, p_message);
                        p_libelle := l_profil_fi2.LIBELLE;
            ELSE
                        OPEN c_profil_fi;
                        FETCH c_profil_fi INTO l_profil_fi;
                        IF c_profil_fi%FOUND THEN
                                    p_libelle := l_profil_fi.LIBELLE;
                        END IF;
                        CLOSE c_profil_fi;
									
            END IF;
            CLOSE c_profil_fi2;
			
        END IF;
        
        OPEN c_profil_domfonc;
        FETCH c_profil_domfonc INTO l_profil_domfonc;
        IF c_profil_domfonc%FOUND THEN
									pack_global.recuperer_message(21277,NULL, NULL, NULL, p_message);
        END IF;
        CLOSE c_profil_domfonc;	
									
    EXCEPTION

        WHEN OTHERS THEN
            raise_application_error(-20997, SQLERRM);



    END getLibelle_ProfilFI;


FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array
IS

   i       number :=0;
   pos     number :=0;
   lv_str  varchar2(50) := p_in_string;

strings t_array;

BEGIN

   -- determine first chuck of string
   pos := instr(lv_str,p_delim,1,1);

   -- while there are chunks left, loop
   WHILE ( pos != 0) LOOP

      -- increment counter
      i := i + 1;

      -- create array element for chuck of string
      strings(i) := substr(lv_str,1,pos-1);

      -- remove chunk from string
      lv_str := substr(lv_str,pos+1,length(lv_str));

      -- determine next chunk
      pos := instr(lv_str,p_delim,1,1);

      -- no last chunk, add to array
      IF pos = 0 THEN

         strings(i+1) := lv_str;

      END IF;

   END LOOP;

   -- return array
   RETURN strings;

END SPLIT;

-- QC 1321
-- Récupérer les valeurs des paramètres applicatif pour gérer les seuils d'application de profils de FI
FUNCTION PROFILFI_SEUIL_VALUES (  p_valeur       VARCHAR2,
                                  p_separateur   VARCHAR2,
                                  p_param        NUMBER
                               )  RETURN       VARCHAR2 IS



    l_msg           VARCHAR2(1024);
    p_valeur_out    VARCHAR2(100);
    t_table         t_array;

BEGIN

    -- Initialisation
    p_valeur_out       := '';

            t_table := SPLIT(p_valeur,p_separateur);
            FOR I IN 1..t_table.COUNT LOOP
                IF (I = p_param) THEN
                    CASE p_param
                         WHEN 1 Then p_valeur_out := REPLACE(t_table(I),'.',',');
                         WHEN 2 Then p_valeur_out := REPLACE(t_table(I),'.',',');
                         WHEN 3 Then p_valeur_out := t_table(I);
                         WHEN 4 Then p_valeur_out := t_table(I);
                      ELSE
                            EXIT ;
                    END CASE ;
                END IF;

            END LOOP;

    RETURN p_valeur_out;

    EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR( -20997, SQLERRM);

END PROFILFI_SEUIL_VALUES;

    FUNCTION PROFILFI_SEUIL_PARAM (p_codsg NUMBER)
         RETURN       VARCHAR2 IS


    l_msg           VARCHAR2(1024);
    l_num_ligne     NUMBER;
    l_coddir NUMBER;

    BEGIN

        BEGIN
            select coddir into l_coddir from struct_info where
            codsg = p_codsg;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            l_coddir := null;
        END;


    SELECT  count(NUM_LIGNE)
            INTO l_num_ligne
            FROM ligne_param_bip
            WHERE code_action = 'PROFILSFI-SEUILS'
            AND   code_version = to_char(l_coddir)
            AND   num_ligne = (SELECT MIN (num_ligne) FROM ligne_param_bip
                                   WHERE code_version = to_char(l_coddir)
                                   AND   code_action = 'PROFILSFI-SEUILS'
                                   AND   actif = 'O'
                                   );

        IF(l_num_ligne =1) THEN
            l_msg :='O';
        ELSE
            --Message : 'Le paramètre applicatif PROFILFI-SEUILS actif n'a pas été trouvé pour la direction ' || p_coddir ;
            pack_global.recuperer_message(4616,'%s1', l_coddir, NULL, l_msg);
        END IF;

    RETURN l_msg;

    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          pack_global.recuperer_message(4616,'%s1', l_coddir, NULL, l_msg);
          return l_msg;
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR( -20997, SQLERRM);

    END PROFILFI_SEUIL_PARAM;

 PROCEDURE VERIF_DIRECTION_PERIME(  p_coddir    IN  VARCHAR2,
                                    p_userid    IN  VARCHAR2,
                                    p_message   OUT VARCHAR2
                                 ) IS


    l_msg               VARCHAR2(1024);
    L_USER              VARCHAR2 (30);
    l_menu              VARCHAR2 (255);
    l_presence          NUMBER;
    CODDIR_INTEGRITY    EXCEPTION;

    BEGIN

        -- Positionner le nb de curseurs ==> 0
        -- Initialiser le message retour
        p_message := '';
        l_menu := Pack_Global.lire_globaldata(p_userid).menutil;

            SELECT COUNT (*)
            INTO l_presence
            FROM DIRECTIONS
            WHERE TO_CHAR(CODDIR) = p_coddir;


            IF(l_presence = 0) THEN

                    RAISE CODDIR_INTEGRITY;
            ELSE
                IF(l_menu='ME') THEN
                    IF( PACK_HABILITATION.VERIF_PERIME_DIRECTION(p_userid, p_coddir) = 'N' ) THEN
                        pack_global.recuperer_message(20364,'%s1', 'à cette direction',NULL, p_message);
                    END IF;
                END IF;

            END IF;

    EXCEPTION

        WHEN CODDIR_INTEGRITY THEN
        pack_global.recuperer_message(20505,'%s1', p_coddir, NULL, l_msg);
        p_message := l_msg;

    END VERIF_DIRECTION_PERIME;
    
PROCEDURE PROFILFI_EXISTS( p_profil IN  PROFIL_FI.PROFIL_FI%TYPE, 
                           p_message OUT MESSAGE.LIMSG%TYPE
                         ) IS
						  
						
    l_msg VARCHAR2(1024);
    l_presence              NUMBER;
  	PROFILDOMFONC_INTEGRITY     EXCEPTION;
	
	BEGIN
		
		-- Positionner le nb de curseurs ==> 0
		-- Initialiser le message retour

		p_message := '';

		SELECT COUNT (*)
		INTO l_presence
		FROM PROFIL_FI
		WHERE PROFIL_FI like p_profil;

		
		IF(l_presence != 0) THEN

			RAISE PROFILDOMFONC_INTEGRITY;

		END IF;
				
		EXCEPTION

			WHEN PROFILDOMFONC_INTEGRITY THEN
				pack_global.recuperer_message(21271,NULL, NULL, NULL, l_msg);
				p_message := l_msg;
		
	
END PROFILFI_EXISTS;

END PACK_PROFIL_FI;
/
