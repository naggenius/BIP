CREATE OR REPLACE PACKAGE     PACK_PROFIL_LOCALIZE AS
TYPE profil_LocCurType IS REF CURSOR RETURN PROFIL_LOCALIZE%ROWTYPE;

PROCEDURE CHECK_LOCALIZE_EXISTS (P_PROFIL     IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                P_DATE_EFFET IN VARCHAR2,
                                P_RESULT     OUT VARCHAR2,
                                P_MESSAGE    OUT MESSAGE.LIMSG%TYPE);

PROCEDURE UPDATE_PROFIL_LOCALIZE (p_profil                 IN  PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
									p_libelle                IN  PROFIL_LOCALIZE.LIBELLE%TYPE,
									p_date_effet             IN  VARCHAR2,
									p_top_actif              IN  PROFIL_LOCALIZE.TOP_ACTIF%TYPE,
									P_FORCE_TRAVAIL          IN  VARCHAR2,
                  P_FRAIS_ENVIRONNEMENT    IN  VARCHAR2,
									p_commentaire            IN  PROFIL_LOCALIZE.COMMENTAIRE%TYPE,
									p_coddir                 IN  VARCHAR2,
									p_profil_defaut			     IN  PROFIL_LOCALIZE.PROFIL_DEFAUT%TYPE,
                  P_CODE_LOCALIZE          IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                  p_code_es                IN  PROFIL_LOCALIZE.CODE_ES%TYPE,
									p_userid                 IN  VARCHAR2,
                  p_message                OUT VARCHAR2
                              );

PROCEDURE SELECT_PROFIL_LOCALIZE (P_PROFIL                IN  PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                   P_DATE_EFFET            IN  VARCHAR2,
                                   P_CURPROFIL     OUT SYS_REFCURSOR
                                   );
                  
PROCEDURE MAJ_PROFIL_LOCALIZE_LOGS (p_profil          IN  PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
									   p_date_effet      IN  VARCHAR2,
									   p_user_log        IN  PROFIL_LOCALIZE_LOGS.USER_LOG%TYPE,
									   p_colonne         IN  PROFIL_LOCALIZE_LOGS.COLONNE%TYPE,
									   p_valeur_prec     IN  PROFIL_LOCALIZE_LOGS.VALEUR_PREC%TYPE,
									   p_valeur_nouv     IN  PROFIL_LOCALIZE_LOGS.VALEUR_NOUV%TYPE,
									   p_commentaire     IN  PROFIL_LOCALIZE_LOGS.COMMENTAIRE%TYPE
                    );
                    
PROCEDURE INSERT_PROFIL_LOCALIZE (P_PROFIL_LOCALIZE      IN  PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                               P_LIBELLE                IN  PROFIL_LOCALIZE.LIBELLE%TYPE,
                               P_DATE_EFFET             IN  VARCHAR2,
                               P_TOP_ACTIF              IN  PROFIL_LOCALIZE.TOP_ACTIF%TYPE,
                               P_FORCE_TRAVAIL          IN  VARCHAR2,
                               P_FRAIS_ENVIRONNEMENT    IN  VARCHAR2,
                               P_COMMENTAIRE            IN  PROFIL_LOCALIZE.COMMENTAIRE%TYPE,
                               P_CODDIR                 IN  PROFIL_LOCALIZE.CODDIR%TYPE,
                               P_PROFIL_DEFAUT			    IN  PROFIL_LOCALIZE.PROFIL_DEFAUT%TYPE,
                               P_CODE_LOCALIZE          IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                               P_CODE_ES                IN  PROFIL_LOCALIZE.CODE_ES%TYPE,
                               P_USERID                 IN VARCHAR2,
                               P_MESSAGE                OUT VARCHAR2
                              );
                                 
PROCEDURE DELETE_PROFIL_LOCALIZE (P_PROFIL          IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                               P_DATE_EFFET           IN  VARCHAR2,
                               P_USERID               IN VARCHAR2,
                               P_NBCURSEUR            OUT INTEGER,
                               P_MESSAGE              OUT VARCHAR2
                               );
                               
PROCEDURE NOT_EXISTS_PROFIL_DEFAUT_M(
                  P_PROFIL IN VARCHAR2,
                  P_DATE_EFFET	IN VARCHAR2,
									P_CODDIR IN PROFIL_LOCALIZE.CODDIR%TYPE,
									P_MESSAGE OUT VARCHAR2);
                  
PROCEDURE NOT_EXISTS_PROFIL_DEFAUT(P_DATE_EFFET	IN VARCHAR2,
									P_CODDIR IN PROFIL_LOCALIZE.CODDIR%TYPE,
									P_MESSAGE OUT VARCHAR2);

PROCEDURE GETLIBELLE_PROFIL_LOCALIZE(P_PROFIL IN  PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                   P_LIBELLE OUT PROFIL_LOCALIZE.LIBELLE%TYPE
                                 );

PROCEDURE ISVALIDPROFILLOCALIZE ( p_profil_localize          IN  PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                 p_filtre_date             IN  VARCHAR2,
                                 p_message                 OUT  MESSAGE.LIMSG%TYPE
                                 );
                                                        
PROCEDURE PROFIL_LOCALIZE_EXISTS (p_profil     IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                p_date_effet IN VARCHAR2,
                                p_result     OUT VARCHAR2,
                                p_message    OUT MESSAGE.LIMSG%TYPE);  

PROCEDURE ESTPROLOCAFFECTERESSMENSANNEE (p_profil               IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                        p_filtre_date             IN  VARCHAR2,
                                        p_message                 OUT MESSAGE.LIMSG%TYPE
                                        );
                                        
TYPE list_profilloc_View IS RECORD (
                                       P_PROFI   PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                       P_LIBELLE VARCHAR2(500)
                                      );                                        
                                        
TYPE list_profilloc_ViewCurType IS REF CURSOR RETURN list_profilloc_View;
                          
PROCEDURE LISTER_PROFIL_LOCALIZE( p_profil      IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                p_filtre_date   IN VARCHAR2,
                                p_userid        IN VARCHAR2,
                                p_curseur       IN OUT list_profilloc_ViewCurType,
                                p_message       OUT VARCHAR2
                              );
 
 -- ********************************************************************************** --
    -- Liste Dtails Profils de LOCALIZE :
    -- ********************************************************************************** --
 
 TYPE details_profilloc_View IS RECORD (
                                            P_PROFI     PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                            P_LIBELLE   VARCHAR2(1000)
                                         );

TYPE details_profilloc_ViewCurType IS REF CURSOR RETURN details_profilloc_View;
                              
 PROCEDURE LISTER_DETAILS_PROFIL_LOCALIZE( p_profi         IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                        p_filtre_date   IN VARCHAR2,
                                        p_userid        IN VARCHAR2,
                                        p_curseur       IN OUT details_profilloc_ViewCurType,
                                        p_message       OUT VARCHAR2
                                      );                              
                              
                                 
END PACK_PROFIL_LOCALIZE;
/


CREATE OR REPLACE PACKAGE BODY PACK_PROFIL_LOCALIZE AS

						 -- *********************************************************************************
--       Procedure   AJAX - PROFIL LOCALIZE - isValid Profil LOCALIZE
-- *********************************************************************************

PROCEDURE CHECK_LOCALIZE_EXISTS (P_PROFIL     IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                P_DATE_EFFET IN VARCHAR2,
                                P_RESULT     OUT VARCHAR2,
                                P_MESSAGE    OUT MESSAGE.LIMSG%TYPE)  AS
    L_MSG VARCHAR2(1024);
    L_PRESENCE VARCHAR2(1024);
    PROFILLOCALIZE_INTEGRITY1 EXCEPTION;
    PROFILLOCALIZE_INTEGRITY2 EXCEPTION;

	BEGIN

      P_MESSAGE := '';
      L_PRESENCE := 0;

      SELECT COUNT (*)
				INTO L_PRESENCE
				FROM PROFIL_LOCALIZE
        WHERE PROFIL_LOCALIZE = P_PROFIL AND  EXTRACT(YEAR FROM DATE_EFFET) = P_DATE_EFFET;

			IF(L_PRESENCE = 0) THEN
				RAISE PROFILLOCALIZE_INTEGRITY1;
      END IF;

		EXCEPTION

			WHEN PROFILLOCALIZE_INTEGRITY1 THEN
				PACK_GLOBAL.RECUPERER_MESSAGE(21314,NULL, NULL, NULL, L_MSG);
				P_MESSAGE := L_MSG;
        P_RESULT := 'N';
        
  END CHECK_LOCALIZE_EXISTS;

PROCEDURE UPDATE_PROFIL_LOCALIZE (P_PROFIL                 IN  PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
									P_LIBELLE                IN  PROFIL_LOCALIZE.LIBELLE%TYPE,
									P_DATE_EFFET             IN  VARCHAR2,
									P_TOP_ACTIF              IN  PROFIL_LOCALIZE.TOP_ACTIF%TYPE,
									P_FORCE_TRAVAIL          IN  VARCHAR2,
                  P_FRAIS_ENVIRONNEMENT    IN  VARCHAR2,
									P_COMMENTAIRE            IN  PROFIL_LOCALIZE.COMMENTAIRE%TYPE,
									P_CODDIR                 IN  VARCHAR2,
									P_PROFIL_DEFAUT			     IN  PROFIL_LOCALIZE.PROFIL_DEFAUT%TYPE,
                  P_CODE_LOCALIZE          IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                  P_CODE_ES                IN  PROFIL_LOCALIZE.CODE_ES%TYPE,
									P_USERID                 IN  VARCHAR2,
                  P_MESSAGE                OUT VARCHAR2
                              ) IS

   L_USER                       VARCHAR2(7);
   L_LIBELLE_OLD                PROFIL_LOCALIZE.LIBELLE%TYPE;
   L_TOP_ACTIF_OLD              PROFIL_LOCALIZE.TOP_ACTIF%TYPE;
   L_FORCE_TRAVAIL_OLD          PROFIL_LOCALIZE.FORCE_TRAVAIL%TYPE;
   L_FRAIS_ENVIRONNEMENT_OLD    PROFIL_LOCALIZE.FRAIS_ENVIRONNEMENT%TYPE;
   L_COMMENTAIRE_OLD            PROFIL_LOCALIZE.COMMENTAIRE%TYPE;
   L_CODDIR_OLD                 PROFIL_LOCALIZE.CODDIR%TYPE;
   L_CODE_ES_OLD                PROFIL_LOCALIZE.CODE_ES%TYPE;
   L_PROFIL_DEFAUT_OLD          PROFIL_LOCALIZE.PROFIL_DEFAUT%TYPE;
   L_CODE_LOCALIZE_OLD          PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE;


   CODE_ES_EXP               EXCEPTION;
   CODDIR_INTEGRITY          EXCEPTION;
   L_FORCE_TRAVAIL          PROFIL_LOCALIZE.FORCE_TRAVAIL%TYPE;
   L_FRAIS_ENVIRONNEMENT    PROFIL_LOCALIZE.FRAIS_ENVIRONNEMENT%TYPE;

    PARAM VARCHAR2(100);

    CURSOR C_ES (PARAM IN VARCHAR2) IS
        SELECT COUNT(ES.CODCAMO) CODCAMO
        FROM ENTITE_STRUCTURE ES
        WHERE ES.CODCAMO = PARAM;
    T_ES            C_ES%ROWTYPE;

    RETURN_VALUE_ES BIP.PACK_PROFIL_FI.STRING_ARRAY;

    L_VAR        VARCHAR2(200);
    L_PRESENCE   NUMBER;

   BEGIN
   
   BEGIN
    L_FORCE_TRAVAIL := REPLACE(P_FORCE_TRAVAIL,',','.');
    L_FRAIS_ENVIRONNEMENT := REPLACE(P_FRAIS_ENVIRONNEMENT,',','.');
    EXCEPTION  
    WHEN OTHERS THEN
    --FOR DEV ENVIRONMENT
        L_FORCE_TRAVAIL := P_FORCE_TRAVAIL;
    L_FRAIS_ENVIRONNEMENT := P_FRAIS_ENVIRONNEMENT;
    END;
      BEGIN
            SELECT COUNT (*)
            INTO L_PRESENCE
            FROM DIRECTIONS
            WHERE CODDIR = P_CODDIR;
        IF(L_PRESENCE=0) THEN
                  RAISE CODDIR_INTEGRITY;
        ELSE
                    BEGIN
                        SELECT PDF.LIBELLE, PDF.TOP_ACTIF, PDF.FORCE_TRAVAIL, PDF.FRAIS_ENVIRONNEMENT, PDF.COMMENTAIRE, PDF.CODDIR, PDF.PROFIL_DEFAUT, PDF.CODE_ES, PDF.CODE_LOCALIZE
                        INTO L_LIBELLE_OLD, L_TOP_ACTIF_OLD, L_FORCE_TRAVAIL_OLD, L_FRAIS_ENVIRONNEMENT_OLD, L_COMMENTAIRE_OLD, L_CODDIR_OLD, L_PROFIL_DEFAUT_OLD, L_CODE_ES_OLD, L_CODE_LOCALIZE_OLD
                        FROM PROFIL_LOCALIZE PDF
                        WHERE PROFIL_LOCALIZE = P_PROFIL
                        --AND  TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = p_date_effet; 
                         AND  EXTRACT (YEAR FROM DATE_EFFET) = P_DATE_EFFET; 
                    END;
                -- *****************************************************************************************

                    IF(L_LIBELLE_OLD != P_LIBELLE) THEN
                    DBMS_OUTPUT.PUT_LINE('Cas 1');
                            UPDATE PROFIL_LOCALIZE SET
                            LIBELLE                = P_LIBELLE,
													  TOP_ACTIF              = P_TOP_ACTIF,
													  FORCE_TRAVAIL          = L_FORCE_TRAVAIL,
													  FRAIS_ENVIRONNEMENT	   = L_FRAIS_ENVIRONNEMENT,
													  COMMENTAIRE            = P_COMMENTAIRE,
													  CODDIR                 = P_CODDIR,
													  PROFIL_DEFAUT          = P_PROFIL_DEFAUT,
													  CODE_ES                = P_CODE_ES,
                            CODE_LOCALIZE      = P_CODE_LOCALIZE
                            WHERE PROFIL_LOCALIZE = P_PROFIL
                           -- AND  TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = p_date_effet;
                            AND  EXTRACT (YEAR FROM DATE_EFFET) = P_DATE_EFFET; 

                           UPDATE PROFIL_LOCALIZE SET
                            LIBELLE                = P_LIBELLE
                          WHERE PROFIL_LOCALIZE = P_PROFIL;

                    ELSE
                    DBMS_OUTPUT.PUT_LINE('Cas 2');
                            UPDATE PROFIL_LOCALIZE SET
                            LIBELLE                = P_LIBELLE,
													  TOP_ACTIF              = P_TOP_ACTIF,
													  FORCE_TRAVAIL          = L_FORCE_TRAVAIL,
													  FRAIS_ENVIRONNEMENT	   = L_FRAIS_ENVIRONNEMENT,
													  COMMENTAIRE            = P_COMMENTAIRE,
													  CODDIR                 = P_CODDIR,
													  PROFIL_DEFAUT          = P_PROFIL_DEFAUT,
													  CODE_ES                = P_CODE_ES,
                            CODE_LOCALIZE      = P_CODE_LOCALIZE
                            WHERE PROFIL_LOCALIZE = P_PROFIL
                            --AND TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = p_date_effet;
                             AND  EXTRACT (YEAR FROM DATE_EFFET) = P_DATE_EFFET; 
                    END IF;
                        L_USER := SUBSTR(PACK_GLOBAL.LIRE_GLOBALDATA(P_USERID).IDARPEGE, 1, 30);
                        MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL, P_DATE_EFFET, L_USER, 'TOP_ACTIF', L_TOP_ACTIF_OLD, P_TOP_ACTIF, 'Modification Profil Localize');
                        MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL, P_DATE_EFFET, L_USER, 'FORCE_TRAVAIL', TO_CHAR(L_FORCE_TRAVAIL_OLD), TO_CHAR(L_FORCE_TRAVAIL), 'Modification Profil Localize');
                        MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL, P_DATE_EFFET, L_USER, 'FRAIS_ENVIRONNEMENT', L_FRAIS_ENVIRONNEMENT_OLD, L_FRAIS_ENVIRONNEMENT, 'Modification Profil Localize');
                        MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL, P_DATE_EFFET, L_USER, 'CODDIR', L_CODDIR_OLD, P_CODDIR, 'Modification Profil Localize');
                        MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL, P_DATE_EFFET, L_USER, 'PROFIL_DEFAUT', L_PROFIL_DEFAUT_OLD, P_PROFIL_DEFAUT, 'Modification Profil Localize');
                        MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL, P_DATE_EFFET, L_USER, 'CODE_ES', L_CODE_ES_OLD, P_CODE_ES, 'Modification Profil Localize');
                        MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL, P_DATE_EFFET, L_USER, 'CODE_LOCALIZE', L_CODE_LOCALIZE_OLD, P_CODE_LOCALIZE, 'Modification Profil Localize');
                       -- MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL, P_DATE_EFFET, L_USER, 'LIBELLE', L_LIBELLE_OLD, L_CODE_LOCALIZE, 'Modification Profil Localize');

                        PACK_GLOBAL.RECUPERER_MESSAGE(21319,'%s1', P_PROFIL, '%s2', P_DATE_EFFET, NULL, P_MESSAGE);
        END IF;
      END;

   END UPDATE_PROFIL_LOCALIZE;
   
PROCEDURE SELECT_PROFIL_LOCALIZE (P_PROFIL                IN  PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                   P_DATE_EFFET            IN  VARCHAR2,
                                   P_CURPROFIL     OUT SYS_REFCURSOR
                                   ) IS
   BEGIN
        OPEN P_CURPROFIL FOR 
        SELECT PROFIL_LOCALIZE, 
        LIBELLE, 
        DATE_EFFET, 
        TOP_ACTIF, 
        DECODE(SUBSTR(TO_CHAR(FORCE_TRAVAIL),1,1),',','0'||TO_CHAR(FORCE_TRAVAIL),TO_CHAR(FORCE_TRAVAIL)) as FORCE_TRAVAIL,
        DECODE(SUBSTR(TO_CHAR(FRAIS_ENVIRONNEMENT),1,1),',','0'||TO_CHAR(FRAIS_ENVIRONNEMENT),TO_CHAR(FRAIS_ENVIRONNEMENT)) as FRAIS_ENVIRONNEMENT,
        COMMENTAIRE, 
        CODDIR, 
        PROFIL_DEFAUT, 
        CODE_LOCALIZE,
        CODE_ES 
        FROM PROFIL_LOCALIZE WHERE PROFIL_LOCALIZE = P_PROFIL AND EXTRACT(YEAR FROM DATE_EFFET) = P_DATE_EFFET;

END SELECT_PROFIL_LOCALIZE;

PROCEDURE INSERT_PROFIL_LOCALIZE (P_PROFIL_LOCALIZE      IN  PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                               P_LIBELLE                IN  PROFIL_LOCALIZE.LIBELLE%TYPE,
                               P_DATE_EFFET             IN  VARCHAR2,
                               P_TOP_ACTIF              IN  PROFIL_LOCALIZE.TOP_ACTIF%TYPE,
                               P_FORCE_TRAVAIL          IN  VARCHAR2,
                               P_FRAIS_ENVIRONNEMENT    IN  VARCHAR2,
                               P_COMMENTAIRE            IN  PROFIL_LOCALIZE.COMMENTAIRE%TYPE,
                               P_CODDIR                 IN  PROFIL_LOCALIZE.CODDIR%TYPE,
                               P_PROFIL_DEFAUT			    IN  PROFIL_LOCALIZE.PROFIL_DEFAUT%TYPE,
                               P_CODE_LOCALIZE          IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                               P_CODE_ES                IN  PROFIL_LOCALIZE.CODE_ES%TYPE,
                               P_USERID                 IN VARCHAR2,
                               P_MESSAGE                OUT VARCHAR2
                              ) IS

   L_COMMENTAIRE_LOGS VARCHAR2(1024);
   L_MSG                VARCHAR2(1024);
   L_PROFI              VARCHAR2(1024);
   L_USER               VARCHAR2(7);
   L_PRESENCE           NUMBER;
   L_NUM_LIGNE          NUMBER;
   L_FORCE_TRAVAIL          PROFIL_LOCALIZE.FORCE_TRAVAIL%TYPE;
   L_FRAIS_ENVIRONNEMENT    PROFIL_LOCALIZE.FRAIS_ENVIRONNEMENT%TYPE;


   CODDIR_INTEGRITY          EXCEPTION;
   CODE_ES_EXP               EXCEPTION;
   PROFIL_EXP             EXCEPTION;
   PROFIL_SEUIL_EXP       EXCEPTION;

   CURSOR C_PROFIL IS
                SELECT LOCALIZE.PROFIL_LOCALIZE
                FROM PROFIL_LOCALIZE LOCALIZE
                WHERE LOCALIZE.PROFIL_LOCALIZE  = P_PROFIL_LOCALIZE;

    PARAM VARCHAR2(100);

    CURSOR C_ES (PARAM IN VARCHAR2) IS
        SELECT COUNT(ES.CODCAMO) CODCAMO
        FROM ENTITE_STRUCTURE ES
        WHERE ES.CODCAMO = PARAM;
        T_ES C_ES%ROWTYPE;


    L_VAR VARCHAR2(200);
   BEGIN
   BEGIN
    L_FORCE_TRAVAIL := REPLACE(P_FORCE_TRAVAIL,',','.');
    L_FRAIS_ENVIRONNEMENT := REPLACE(P_FRAIS_ENVIRONNEMENT,',','.');
    EXCEPTION  
    WHEN OTHERS THEN
    --FOR DEV ENVIRONMENT
        L_FORCE_TRAVAIL := P_FORCE_TRAVAIL;
    L_FRAIS_ENVIRONNEMENT := P_FRAIS_ENVIRONNEMENT;
    END;
      BEGIN
             SELECT COUNT (*)
             INTO L_PRESENCE
             FROM DIRECTIONS
             WHERE TO_CHAR(CODDIR) = P_CODDIR;

            IF(P_DATE_EFFET IS NULL OR P_DATE_EFFET='') THEN

                OPEN C_PROFIL;
                                FETCH C_PROFIL INTO L_PROFI;
                                IF C_PROFIL%FOUND THEN
                                    RAISE PROFIL_EXP;
                                END IF;
                CLOSE C_PROFIL;

            END IF;


            IF(P_PROFIL_LOCALIZE IS NOT NULL AND P_DATE_EFFET IS NOT NULL) THEN
                  BEGIN 
                   INSERT INTO PROFIL_LOCALIZE
                                (
                                PROFIL_LOCALIZE,
                                LIBELLE,
                                DATE_EFFET,
                                TOP_ACTIF,
                                FORCE_TRAVAIL,
                            		FRAIS_ENVIRONNEMENT,
                                COMMENTAIRE,
                                CODDIR,
                                PROFIL_DEFAUT,
                                CODE_LOCALIZE,
                                CODE_ES
                                )
                                VALUES
                                (
                                P_PROFIL_LOCALIZE,
                                P_LIBELLE,
                                TO_DATE('01-JAN-'||P_DATE_EFFET,'DD-MON-YYYY'),
                                P_TOP_ACTIF,
                                L_FORCE_TRAVAIL,
                                L_FRAIS_ENVIRONNEMENT,
                                P_COMMENTAIRE,
                                P_CODDIR,
                                P_PROFIL_DEFAUT,
                                P_CODE_LOCALIZE,
                                P_CODE_ES
                                );
                  EXCEPTION
                  WHEN OTHERS THEN
                  --FOR DEV ENVIRONMENT
                    INSERT INTO PROFIL_LOCALIZE
                                (
                                PROFIL_LOCALIZE,
                                LIBELLE,
                                DATE_EFFET,
                                TOP_ACTIF,
                                FORCE_TRAVAIL,
                            		FRAIS_ENVIRONNEMENT,
                                COMMENTAIRE,
                                CODDIR,
                                PROFIL_DEFAUT,
                                CODE_LOCALIZE,
                                CODE_ES
                                )
                                VALUES
                                (
                                P_PROFIL_LOCALIZE,
                                P_LIBELLE,
                                TO_CHAR('01-01-'||P_DATE_EFFET),
                                P_TOP_ACTIF,
                                L_FORCE_TRAVAIL,
                                L_FRAIS_ENVIRONNEMENT,
                                P_COMMENTAIRE,
                                P_CODDIR,
                                P_PROFIL_DEFAUT,
                                P_CODE_LOCALIZE,
                                P_CODE_ES
                                );
                  END;
                L_USER := SUBSTR(PACK_GLOBAL.LIRE_GLOBALDATA(P_USERID).IDARPEGE, 1, 30);

								L_COMMENTAIRE_LOGS := 'Creation Profil Localize';

								MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL_LOCALIZE, P_DATE_EFFET, L_USER,'LIBELLE', '', P_LIBELLE,L_COMMENTAIRE_LOGS);
                MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL_LOCALIZE, P_DATE_EFFET, L_USER,'TOP_ACTIF', '', P_TOP_ACTIF,L_COMMENTAIRE_LOGS);
								MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL_LOCALIZE, P_DATE_EFFET, L_USER,'FORCE_TRAVAIL', '', L_FORCE_TRAVAIL,L_COMMENTAIRE_LOGS);
                MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL_LOCALIZE, P_DATE_EFFET, L_USER,'FRAIS_ENVIRONNEMENT', '', L_FRAIS_ENVIRONNEMENT,L_COMMENTAIRE_LOGS);
								MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL_LOCALIZE, P_DATE_EFFET, L_USER,'COMMENTAIRE', '', P_COMMENTAIRE,L_COMMENTAIRE_LOGS);
								MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL_LOCALIZE, P_DATE_EFFET, L_USER,'CODDIR', '', P_CODDIR,L_COMMENTAIRE_LOGS);
                MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL_LOCALIZE, P_DATE_EFFET, L_USER,'PROFIL_DEFAUT', '', P_PROFIL_DEFAUT,L_COMMENTAIRE_LOGS);
                MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL_LOCALIZE, P_DATE_EFFET, L_USER,'CODE_ES', '', P_CODE_ES,L_COMMENTAIRE_LOGS);
                MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL_LOCALIZE, P_DATE_EFFET, L_USER,'CODE_LOCALIZE', '', P_CODE_LOCALIZE,L_COMMENTAIRE_LOGS);
PACK_GLOBAL.RECUPERER_MESSAGE(21318,'%s1', P_PROFIL_LOCALIZE, '%s2', P_DATE_EFFET, NULL, P_MESSAGE);
                    END IF;
       END;
              
   END INSERT_PROFIL_LOCALIZE;
   
PROCEDURE MAJ_PROFIL_LOCALIZE_LOGS (p_profil          IN  PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
									   p_date_effet      IN  VARCHAR2,
									   p_user_log        IN  PROFIL_LOCALIZE_LOGS.USER_LOG%TYPE,
									   p_colonne         IN  PROFIL_LOCALIZE_LOGS.COLONNE%TYPE,
									   p_valeur_prec     IN  PROFIL_LOCALIZE_LOGS.VALEUR_PREC%TYPE,
									   p_valeur_nouv     IN  PROFIL_LOCALIZE_LOGS.VALEUR_NOUV%TYPE,
									   p_commentaire     IN  PROFIL_LOCALIZE_LOGS.COMMENTAIRE%TYPE
                                 ) IS


    BEGIN

            IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
              BEGIN
                INSERT INTO PROFIL_LOCALIZE_LOGS
                    (PROFIL_LOCALIZE, date_effet, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
                VALUES            
                    (p_profil, TO_DATE('01-JAN-'||p_date_effet,'DD-MON-YYYY'), SYSDATE, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);
              EXCEPTION
              WHEN OTHERS THEN
              --FOR DEV ENVIRONMENT
               INSERT INTO PROFIL_LOCALIZE_LOGS
                    (PROFIL_LOCALIZE, date_effet, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
                VALUES            
                    (p_profil, TO_CHAR('01-01-'||p_date_effet), SYSDATE, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);
              END;
            END IF;
    END MAJ_PROFIL_LOCALIZE_LOGS;
    
PROCEDURE DELETE_PROFIL_LOCALIZE (P_PROFIL          IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                               P_DATE_EFFET           IN  VARCHAR2,
                               P_USERID               IN VARCHAR2,
                               P_NBCURSEUR            OUT INTEGER,
                               P_MESSAGE              OUT VARCHAR2
                               ) IS

   L_USER                  VARCHAR2 (30);
   REFERENTIAL_INTEGRITY   EXCEPTION;
   L_PRESENCE              NUMBER;
   L_MSG VARCHAR2(1024);

   CURSOR C_PROFIL_LOCALIZE IS
        SELECT PROFIL_LOCALIZE
        FROM PROFIL_LOCALIZE
        WHERE PROFIL_LOCALIZE = P_PROFIL
        AND  EXTRACT (YEAR FROM DATE_EFFET) = P_DATE_EFFET; 
        --AND  TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = P_DATE_EFFET; 

   L_PROFIL_LOCALIZE PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE;

   BEGIN

      P_NBCURSEUR := 0;
      P_MESSAGE := '';
      L_USER := SUBSTR (PACK_GLOBAL.LIRE_GLOBALDATA (P_USERID).IDARPEGE, 1, 30);

        OPEN C_PROFIL_LOCALIZE;
        FETCH C_PROFIL_LOCALIZE INTO L_PROFIL_LOCALIZE;

        IF L_PROFIL_LOCALIZE is null THEN
            PACK_GLOBAL.RECUPERER_MESSAGE(21279,'%s1', P_PROFIL, '%s2', P_DATE_EFFET, NULL, L_MSG);
            P_MESSAGE := L_MSG;
           -- P_MESSAGE := 'nEEEEEEEEEEEEEEEEEEEE : ' || P_DATE_EFFET ||P_PROFIL;
        ELSE

            DELETE FROM PROFIL_LOCALIZE
        WHERE PROFIL_LOCALIZE = P_PROFIL
        AND  EXTRACT (YEAR FROM DATE_EFFET) = P_DATE_EFFET;  

            MAJ_PROFIL_LOCALIZE_LOGS(P_PROFIL, P_DATE_EFFET, L_USER, 'TOUTES', 'TOUTES', NULL, 'Suppression du Profil Localize');
			PACK_GLOBAL.RECUPERER_MESSAGE(21317,'%s1', P_PROFIL, '%s2', P_DATE_EFFET, NULL, L_MSG);
			P_MESSAGE := L_MSG;

        END IF;
        CLOSE C_PROFIL_LOCALIZE;

   EXCEPTION

         WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE(sqlerrm);
         PACK_GLOBAL.RECUPERER_MESSAGE(21279,'%s1', P_PROFIL, '%s2', P_DATE_EFFET, NULL, L_MSG);
         P_MESSAGE := L_MSG;


   END DELETE_PROFIL_LOCALIZE;

PROCEDURE NOT_EXISTS_PROFIL_DEFAUT(P_DATE_EFFET	IN VARCHAR2,
									P_CODDIR IN PROFIL_LOCALIZE.CODDIR%TYPE,
									P_MESSAGE OUT VARCHAR2) IS
	L_COMPTEUR INTEGER;

	BEGIN
		L_COMPTEUR := 0;

		IF (P_DATE_EFFET IS NOT NULL
			AND P_CODDIR IS NOT NULL) THEN

			SELECT COUNT(1) INTO L_COMPTEUR
				FROM PROFIL_LOCALIZE
				--WHERE TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = P_DATE_EFFET 
        WHERE EXTRACT(YEAR FROM DATE_EFFET) = P_DATE_EFFET
				AND CODDIR = P_CODDIR
        AND PROFIL_DEFAUT = 'O'
				AND ROWNUM <= 1;

			IF (L_COMPTEUR > 0) THEN
				PACK_GLOBAL.RECUPERER_MESSAGE(21321, '%s1', P_DATE_EFFET, '%s2', P_CODDIR, NULL, P_MESSAGE);
			END IF;
		END IF;

END NOT_EXISTS_PROFIL_DEFAUT;



PROCEDURE NOT_EXISTS_PROFIL_DEFAUT_M(
                  P_PROFIL IN VARCHAR2,
                  P_DATE_EFFET	IN VARCHAR2,
									P_CODDIR IN PROFIL_LOCALIZE.CODDIR%TYPE,
									P_MESSAGE OUT VARCHAR2) IS
	L_COMPTEUR INTEGER;

	BEGIN
		L_COMPTEUR := 0;

		IF (P_DATE_EFFET IS NOT NULL
			AND P_CODDIR IS NOT NULL) THEN

			SELECT COUNT(1) INTO L_COMPTEUR
				FROM PROFIL_LOCALIZE
				--WHERE TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = P_DATE_EFFET
        WHERE EXTRACT(YEAR FROM DATE_EFFET) = P_DATE_EFFET
				AND CODDIR = P_CODDIR
        AND PROFIL_DEFAUT = 'O'
        AND PROFIL_LOCALIZE <> P_PROFIL
				AND ROWNUM <= 1;

			IF (L_COMPTEUR > 0) THEN
				PACK_GLOBAL.RECUPERER_MESSAGE(21321, '%s1', P_DATE_EFFET, '%s2', P_CODDIR, NULL, P_MESSAGE);
			END IF;
		END IF;

END NOT_EXISTS_PROFIL_DEFAUT_M;

 PROCEDURE GETLIBELLE_PROFIL_LOCALIZE(P_PROFIL IN  PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                   P_LIBELLE OUT PROFIL_LOCALIZE.LIBELLE%TYPE
                                 ) IS
  BEGIN

    IF (P_PROFIL IS NOT NULL) THEN
      SELECT LIBELLE INTO P_LIBELLE
        FROM PROFIL_LOCALIZE
        WHERE PROFIL_LOCALIZE = P_PROFIL
        AND ROWNUM <= 1;

    END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        P_LIBELLE := '';
END GETLIBELLE_PROFIL_LOCALIZE;

  PROCEDURE ISVALIDPROFILLOCALIZE ( p_profil_localize          IN  PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                 p_filtre_date             IN  VARCHAR2,
                                 p_message                 OUT  MESSAGE.LIMSG%TYPE
                                 ) AS
      l_msg VARCHAR2(1024);
		  l_presence              NUMBER;
		  PROFILLOCALIZE_INTEGRITY     EXCEPTION;
  BEGIN
        p_message := '';
        l_msg := '';
				SELECT COUNT (*)
				INTO l_presence
				FROM PROFIL_LOCALIZE
				WHERE PROFIL_LOCALIZE like p_profil_localize||'%' AND EXTRACT(YEAR FROM DATE_EFFET) >= p_filtre_date; --modif
        
			IF(p_profil_localize <>'*' ) THEN
				IF(l_presence = 0) THEN

						RAISE PROFILLOCALIZE_INTEGRITY;

				END IF;
			END IF;
		EXCEPTION

			WHEN PROFILLOCALIZE_INTEGRITY THEN
			pack_global.recuperer_message(21310,NULL, NULL, NULL, l_msg);
			p_message := l_msg;
      
    
  END ISVALIDPROFILLOCALIZE;
  
  						 -- *********************************************************************************
--       Procedure   AJAX - PROFIL LOCALIZE - FI and LOCALIZE exists
-- *********************************************************************************

  PROCEDURE PROFIL_LOCALIZE_EXISTS (P_PROFIL     IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                P_DATE_EFFET IN VARCHAR2,
                                P_RESULT     OUT VARCHAR2,
                                P_MESSAGE    OUT MESSAGE.LIMSG%TYPE)  AS
    L_MSG VARCHAR2(1024);
    L_PRESENCE VARCHAR2(1024);
    L_MESSAGE MESSAGE.LIMSG%TYPE;
    PROFILLOCALIZE_INTEGRITY1 EXCEPTION;
    PROFILLOCALIZE_INTEGRITY2 EXCEPTION;

	BEGIN

      P_MESSAGE := '';
      P_RESULT := '';
      L_PRESENCE := 0;

      PACK_PROFIL_FI.PROFILFI_EXISTS(P_PROFIL,L_MESSAGE);
      IF(L_MESSAGE IS NOT NULL) THEN
				RAISE PROFILLOCALIZE_INTEGRITY2;
      END IF;

      L_PRESENCE := 0;
      
      BEGIN
        SELECT COUNT (*)
				INTO L_PRESENCE
				FROM PROFIL_DOMFONC
        WHERE PROFIL_DOMFONC = p_profil;
        IF(L_PRESENCE != 0) THEN
				RAISE PROFILLOCALIZE_INTEGRITY2;
      END IF;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        L_PRESENCE := 0;
      END;

				SELECT COUNT (*)
				INTO L_PRESENCE
				FROM PROFIL_LOCALIZE
        WHERE PROFIL_LOCALIZE = P_PROFIL AND  EXTRACT(YEAR FROM DATE_EFFET) = P_DATE_EFFET;

			IF(L_PRESENCE != 0) THEN
				RAISE PROFILLOCALIZE_INTEGRITY1;
      END IF;

		EXCEPTION

			WHEN PROFILLOCALIZE_INTEGRITY1 THEN
				PACK_GLOBAL.RECUPERER_MESSAGE(21312,NULL, NULL, NULL, L_MSG);
				P_MESSAGE := L_MSG;
				P_RESULT :='N' ;
			WHEN PROFILLOCALIZE_INTEGRITY2 THEN
				PACK_GLOBAL.RECUPERER_MESSAGE(21311,NULL, NULL, NULL, L_MSG);
				P_MESSAGE := L_MSG;
				P_RESULT :='N' ;

		/*p_message := NULL;
    PACK_PROFIL_FI.PROFILFI_EXISTS(p_profil_localize_fi,l_presence_fi);

      SELECT nvl(COUNT (*),0)
				INTO l_presence_domfonc
				FROM PROFIL_DOMFONC
				WHERE PROFIL_DOMFONC = p_profil_localize_fi;
        
        IF (l_presence_domfonc <> 0 OR l_presence_fi IS NOT NULL) THEN
          RAISE PROFILLOCALIZE_INTEGRITY1;
          ELSE
             SELECT nvl(COUNT (*),0)
             INTO l_presence_localize
				     FROM PROFIL_LOCALIZE
				     WHERE PROFIL_LOCALIZE = p_profil_localize_fi;
             
             IF (L_PRESENCE_LOCALIZE >0) THEN
             RAISE PROFILLOCALIZE_INTEGRITY2;
             END IF; 
             
		END IF;
    

		EXCEPTION
			WHEN PROFILLOCALIZE_INTEGRITY1 THEN
				pack_global.recuperer_message(21311,NULL, NULL, NULL, l_msg);
				p_message := l_msg; 
        
        WHEN PROFILLOCALIZE_INTEGRITY2 THEN
				pack_global.recuperer_message(21313,NULL, NULL, NULL, l_msg);
				p_message := l_msg;*/
        
  END PROFIL_LOCALIZE_EXISTS;
  
 /* PROCEDURE PROFIL_LOCALIZE_EXISTS  (p_profil     IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                p_date_effet IN VARCHAR2,
                                p_flag IN VARCHAR2,
                                p_message    OUT MESSAGE.LIMSG%TYPE
                               )IS

		l_msg                        VARCHAR2(1024);
		l_presence                   NUMBER;
		PROFILLOCALIZE1_INTEGRITY     EXCEPTION;
    PROFILLOCALIZE2_INTEGRITY     EXCEPTION;


		BEGIN

			-- Positionner le nb de curseurs ==> 0
			-- Initialiser le message retour

			p_message := '';

				SELECT COUNT (*)
				INTO l_presence
				FROM PROFIL_LOCALIZE
        WHERE PROFIL_LOCALIZE = p_profil AND  TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = p_date_effet; --modif

			IF(l_presence != 0 AND p_flag = 'C') THEN
				RAISE PROFILLOCALIZE1_INTEGRITY;
        
     ELSIF(l_presence = 0 AND p_flag = 'M') THEN
				RAISE PROFILLOCALIZE2_INTEGRITY;
      END IF;

		EXCEPTION

			WHEN PROFILLOCALIZE1_INTEGRITY THEN
				pack_global.recuperer_message(21312,NULL, NULL, NULL, l_msg);
				p_message := l_msg;
        
        WHEN PROFILLOCALIZE2_INTEGRITY THEN
				pack_global.recuperer_message(21314,NULL, NULL, NULL, l_msg);
				p_message := l_msg;
			
END PROFIL_LOCALIZE_EXISTS;*/

PROCEDURE ESTPROLOCAFFECTERESSMENSANNEE (p_profil               IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                        p_filtre_date             IN  VARCHAR2,
                                        p_message                 OUT MESSAGE.LIMSG%TYPE
                                        ) IS


    l_msg                         VARCHAR2(1024);
    libelle                       VARCHAR2(1024);
		coutFT                        NUMBER(12,2);
    coutENV                       NUMBER(12,2);
    top_actif                     CHAR(1);
		PROFILLOCALIZE1_INTEGRITY      EXCEPTION;
		PROFILLOCALIZE2_INTEGRITY      EXCEPTION;
    PROFILLOCALIZE3_INTEGRITY      EXCEPTION;
    CURSOR c_profil_localize IS
        SELECT *
        FROM PROFIL_LOCALIZE
        WHERE PROFIL_LOCALIZE = p_profil AND  EXTRACT (YEAR FROM DATE_EFFET) = P_FILTRE_DATE;
         
    l_profil_localize c_profil_localize%ROWTYPE;
    
     CURSOR c_stock_fi IS
        SELECT *
        FROM STOCK_FI
        WHERE PROFIL_FI = p_profil;
          l_stock_fi c_stock_fi%ROWTYPE;
  

    BEGIN

			-- Positionner le nb de curseurs ==> 0
			-- Initialiser le message retour

			p_message := '';
      
        OPEN c_profil_localize;
        FETCH c_profil_localize INTO l_profil_localize;
        IF c_profil_localize%FOUND THEN
							libelle := l_profil_localize.LIBELLE;
              top_actif := l_profil_localize.TOP_ACTIF;
              coutFT := l_profil_localize.FORCE_TRAVAIL;
              coutENV := l_profil_localize.FRAIS_ENVIRONNEMENT;
        END IF;
        CLOSE c_profil_localize;
        
         OPEN c_stock_fi;
        FETCH c_stock_fi INTO l_stock_fi;
        IF c_stock_fi%FOUND THEN
              RAISE PROFILLOCALIZE2_INTEGRITY;
        ELSE
              RAISE PROFILLOCALIZE1_INTEGRITY;
        END IF;
        CLOSE c_stock_fi;

		EXCEPTION

			WHEN PROFILLOCALIZE1_INTEGRITY THEN
				PACK_GLOBAL.RECUPERER_MESSAGE(21315, '%s1', p_profil, '%s2', libelle , '%s3' , p_filtre_date ||' -- Top Actif : '||top_actif ||' -- Coût Force de Travail : '||coutFT ||' -- Coût Frais d''Environnement : '||coutENV ||' \nProfil Localisé non encore utilisé cette année \nConfirmez-vous la suppression?', NULL, l_msg);
        p_message := l_msg;
			WHEN PROFILLOCALIZE2_INTEGRITY THEN
				PACK_GLOBAL.RECUPERER_MESSAGE(21315, '%s1', p_profil, '%s2', libelle , '%s3' , p_filtre_date ||' -- Top Actif : '||top_actif ||' -- Coût Force de Travail : '||coutFT ||' -- Coût Frais d''Environnement : '||coutENV ||' \nProfil Localisé déjà utilisé cette année \nConfirmez-vous la suppression?', NULL, l_msg);
				p_message := l_msg;                             
END ESTPROLOCAFFECTERESSMENSANNEE;   

PROCEDURE LISTER_PROFIL_LOCALIZE( p_profil         IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                p_filtre_date   IN VARCHAR2,
                                p_userid        IN VARCHAR2,
                                p_curseur       IN OUT list_profilloc_ViewCurType,
                                p_message       OUT VARCHAR2
                              ) IS


    l_liste     VARCHAR2(5000);
    l_profi     VARCHAR2(1024);
    l_libelle     VARCHAR2(1024);
    l_filtre_date     VARCHAR2(7);
    l_filtre_LOCALIZE       VARCHAR2(12);

    CURSOR C_PROFILLOCALIZE IS
                SELECT PLOCALIZE.PROFIL_LOCALIZE, PLOCALIZE.LIBELLE
                FROM PROFIL_LOCALIZE PLOCALIZE
                WHERE PLOCALIZE.PROFIL_LOCALIZE  = p_profil;

    CURSOR  p_curseur2 IS
    SELECT DISTINCT
    PROFIL_LOCALIZE,
    RPAD(NVL(to_char(PROFIL_LOCALIZE), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
    from PROFIL_LOCALIZE
    WHERE EXTRACT(YEAR FROM DATE_EFFET) >= p_filtre_date
    --WHERE DATE_EFFET >= to_date(p_filtre_date,'YYYY')
    AND (PROFIL_LOCALIZE like p_profil||'%' OR PROFIL_LOCALIZE = p_profil)
    order by PROFIL_LOCALIZE asc;

    t_curseur2   p_curseur2%ROWTYPE;

    CURSOR p_curseur3 IS
    SELECT DISTINCT
    PROFIL_LOCALIZE,
    RPAD(NVL(to_char(PROFIL_LOCALIZE), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
    from PROFIL_LOCALIZE
    WHERE EXTRACT(YEAR FROM DATE_EFFET) >= p_filtre_date
   -- WHERE DATE_EFFET >= to_date(p_filtre_date,'YYYY')
    order by PROFIL_LOCALIZE asc;

    t_curseur3   p_curseur3%ROWTYPE;

    CURSOR C_PROFILLOCALIZE2 IS
            SELECT PLOCALIZE.PROFIL_LOCALIZE, PLOCALIZE.LIBELLE
            FROM PROFIL_LOCALIZE PLOCALIZE
            WHERE PLOCALIZE.PROFIL_LOCALIZE like p_profil||'%';

    BEGIN


            IF(p_profil is not null or p_profil !='') THEN


                IF(p_filtre_date is null) THEN

                    OPEN C_PROFILLOCALIZE;
                                    FETCH C_PROFILLOCALIZE INTO l_profi, l_libelle;
                                    IF C_PROFILLOCALIZE%NOTFOUND THEN
                                        pack_global.recuperer_message(4602,NULL, NULL, NULL, p_message);
                                            OPEN      p_curseur FOR
                                            SELECT DISTINCT
                                            PROFIL_LOCALIZE,
                                            RPAD(NVL(to_char(PROFIL_LOCALIZE), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                                            from PROFIL_LOCALIZE
                                            order by PROFIL_LOCALIZE asc;
                                    END IF;
                    CLOSE C_PROFILLOCALIZE;

                    OPEN      p_curseur FOR
                              SELECT DISTINCT
                              PROFIL_LOCALIZE,
                              RPAD(NVL(to_char(PROFIL_LOCALIZE), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                              from PROFIL_LOCALIZE
                              where PROFIL_LOCALIZE = p_profil
                              order by PROFIL_LOCALIZE asc;

                END IF;

                if(p_profil ='*') THEN

                    if(p_filtre_date ='*') then

                              OPEN      p_curseur FOR
                              SELECT DISTINCT
                              PROFIL_LOCALIZE,
                              RPAD(NVL(to_char(PROFIL_LOCALIZE), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                              from PROFIL_LOCALIZE
                              order by PROFIL_LOCALIZE asc;

                    else

                              IF(p_filtre_date is null) THEN

                                              OPEN      p_curseur FOR
                                              SELECT DISTINCT
                                              PROFIL_LOCALIZE,
                                              RPAD(NVL(to_char(PROFIL_LOCALIZE), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                                              from PROFIL_LOCALIZE
                                              order by PROFIL_LOCALIZE asc;
                              ELSE

                                      OPEN      p_curseur FOR
                                      SELECT DISTINCT
                                      PROFIL_LOCALIZE,
                                      RPAD(NVL(to_char(PROFIL_LOCALIZE), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                                      from PROFIL_LOCALIZE
                                      WHERE EXTRACT(YEAR FROM DATE_EFFET) >= p_filtre_date
                                   -- WHERE DATE_EFFET >= to_date(p_filtre_date,'YYYY') --to_char(date_effet,'MM/YYYY') >= p_filtre_date
                                      order by PROFIL_LOCALIZE asc;

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
                          PROFIL_LOCALIZE,
                          RPAD(NVL(to_char(PROFIL_LOCALIZE), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                          FROM PROFIL_LOCALIZE
                          WHERE PROFIL_LOCALIZE like p_profil||'%'
                          ORDER BY PROFIL_LOCALIZE ASC;

                        OPEN C_PROFILLOCALIZE2;
                        FETCH C_PROFILLOCALIZE2 INTO l_profi, l_libelle;
                        IF C_PROFILLOCALIZE2%NOTFOUND THEN
                                OPEN      p_curseur FOR
                                SELECT DISTINCT
                                ' ',
                                RPAD(NVL(to_char(' '), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(' '), ' '), 90, ' ')
                                FROM DUAL;
                        END IF;
                        CLOSE C_PROFILLOCALIZE2;

                    ELSE
                            OPEN      p_curseur FOR
                            SELECT DISTINCT
                            PROFIL_LOCALIZE,
                            RPAD(NVL(to_char(PROFIL_LOCALIZE), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                            from PROFIL_LOCALIZE
                            WHERE EXTRACT(YEAR FROM DATE_EFFET) >= p_filtre_date
                         -- WHERE TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') >=  p_filtre_date --to_char(date_effet,'MM/YYYY') >= p_filtre_date
                            AND (PROFIL_LOCALIZE like p_profil||'%' OR PROFIL_LOCALIZE = p_profil)
                            order by PROFIL_LOCALIZE asc;

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

    END  LISTER_PROFIL_LOCALIZE;
    
    -- *********************************************************************************
--       Procedure   LISTE  DETAILS PROFIL DE LOCALIZE :
-- *********************************************************************************

    PROCEDURE LISTER_DETAILS_PROFIL_LOCALIZE( p_profi         IN PROFIL_LOCALIZE.PROFIL_LOCALIZE%TYPE,
                                        p_filtre_date   IN VARCHAR2,
                                        p_userid        IN VARCHAR2,
                                        p_curseur       IN OUT details_profilloc_ViewCurType,
                                        p_message       OUT VARCHAR2
                                      ) IS

    
      l_profi     VARCHAR2(1024);
                            
      CURSOR C_PROFILLOCALIZE IS
                SELECT PLOCALIZE.PROFIL_LOCALIZE
                FROM PROFIL_LOCALIZE PLOCALIZE
                WHERE PLOCALIZE.PROFIL_LOCALIZE  = p_profi;
                           
      t_curseur   p_curseur%ROWTYPE;

      BEGIN

      if(p_profi is not null )   then
    
        OPEN C_PROFILLOCALIZE;
        FETCH C_PROFILLOCALIZE INTO l_profi;
        IF C_PROFILLOCALIZE%NOTFOUND AND p_profi <> '*' THEN

        OPEN      p_curseur FOR
        SELECT
        ' ',
        RPAD(NVL(to_char(' '), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(' '), ' '), 90, ' ')
        FROM DUAL;

        ELSE

                 CLOSE C_PROFILLOCALIZE;

            if(p_filtre_date is null) then

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY'),
                RPAD(NVL(TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PLOCALIZE.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                /*RPAD(NVL(TO_CHAR(pLOCALIZE.force_travail) , '---'), 12, ' ') ||
                RPAD(NVL(TO_CHAR(pLOCALIZE.frais_environnement) , '---'), 15, ' ') ||*/
                RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.force_travail),1,1),',','0'||TO_CHAR(pLOCALIZE.force_travail),TO_CHAR(pLOCALIZE.force_travail)) , '---'), 12, ' ') ||
                RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.frais_environnement),1,1),',','0'||TO_CHAR(pLOCALIZE.frais_environnement),TO_CHAR(pLOCALIZE.frais_environnement)) , '---'), 15, ' ') ||
                RPAD(NVL(PLOCALIZE.CODDIR , '---'), 13, ' ') ||
                RPAD(NVL(pLOCALIZE.profil_defaut , '---'), 16, ' ') ||
                RPAD(NVL(pLOCALIZE.code_localize , '---'), 16, ' ') ||
                RPAD(NVL(pLOCALIZE.code_es , '---'), 15, ' ')
                FROM PROFIL_LOCALIZE PLOCALIZE
                WHERE PLOCALIZE.PROFIL_LOCALIZE = p_profi
                ORDER BY PLOCALIZE.DATE_EFFET DESC;


                            OPEN C_PROFILLOCALIZE;
                            FETCH C_PROFILLOCALIZE INTO l_profi;
                            IF (l_profi is null) THEN
                                    OPEN    p_curseur FOR
                                    SELECT
                                    TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY'),
                                    RPAD(NVL(TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                                    RPAD(NVL(DECODE(PLOCALIZE.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                                    /*RPAD(NVL(TO_CHAR(pLOCALIZE.force_travail) , '---'), 12, ' ') ||
                                    RPAD(NVL(TO_CHAR(pLOCALIZE.frais_environnement) , '---'), 15, ' ') ||*/
                                    RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.force_travail),1,1),',','0'||TO_CHAR(pLOCALIZE.force_travail),TO_CHAR(pLOCALIZE.force_travail)) , '---'), 12, ' ') ||
                                    RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.frais_environnement),1,1),',','0'||TO_CHAR(pLOCALIZE.frais_environnement),TO_CHAR(pLOCALIZE.frais_environnement)) , '---'), 15, ' ') ||
                                    RPAD(NVL(PLOCALIZE.CODDIR , '---'), 13, ' ') ||
                                    RPAD(NVL(pLOCALIZE.profil_defaut , '---'), 16, ' ') ||
                                    RPAD(NVL(pLOCALIZE.code_localize , '---'), 16, ' ') ||
                                    RPAD(NVL(pLOCALIZE.code_es , '---'), 15, ' ')
                                    FROM PROFIL_LOCALIZE PLOCALIZE
                                    WHERE PLOCALIZE.PROFIL_LOCALIZE in (SELECT DISTINCT PROFIL_LOCALIZE FROM PROFIL_LOCALIZE WHERE ROWNUM <='1')
                                    ORDER BY PLOCALIZE.PROFIL_LOCALIZE ASC;
                            END IF;
                            CLOSE C_PROFILLOCALIZE;
            else

                            OPEN C_PROFILLOCALIZE;
                            FETCH C_PROFILLOCALIZE INTO l_profi;
                            IF C_PROFILLOCALIZE%NOTFOUND THEN

                            OPEN      p_curseur FOR
                            SELECT
                            ' ',
                            RPAD(NVL(to_char(' '), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(' '), ' '), 90, ' ')
                            FROM DUAL;
                            END IF;

                            CLOSE C_PROFILLOCALIZE;



            end if;

            IF(p_profi ='*' and p_filtre_date is null) THEN

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY'),
                RPAD(NVL(TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PLOCALIZE.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                /*RPAD(NVL(TO_CHAR(pLOCALIZE.force_travail) , '---'), 12, ' ') ||
                RPAD(NVL(TO_CHAR(pLOCALIZE.frais_environnement) , '---'), 15, ' ') ||*/
                RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.force_travail),1,1),',','0'||TO_CHAR(pLOCALIZE.force_travail),TO_CHAR(pLOCALIZE.force_travail)) , '---'), 12, ' ') ||
                RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.frais_environnement),1,1),',','0'||TO_CHAR(pLOCALIZE.frais_environnement),TO_CHAR(pLOCALIZE.frais_environnement)) , '---'), 15, ' ') ||
                RPAD(NVL(PLOCALIZE.CODDIR , '---'), 13, ' ') ||
                RPAD(NVL(pLOCALIZE.profil_defaut , '---'), 16, ' ') ||
                RPAD(NVL(pLOCALIZE.code_localize , '---'), 16, ' ') ||
                RPAD(NVL(pLOCALIZE.code_es , '---'), 15, ' ')
                FROM PROFIL_LOCALIZE PLOCALIZE
                ORDER BY PLOCALIZE.DATE_EFFET DESC;
            END IF;

            IF(p_profi ='*' and p_filtre_date ='*') THEN

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY'),
                RPAD(NVL(TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PLOCALIZE.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                /*RPAD(NVL(TO_CHAR(pLOCALIZE.force_travail) , '---'), 12, ' ') ||
                 RPAD(NVL(TO_CHAR(pLOCALIZE.frais_environnement) , '---'), 15, ' ') ||*/
                 RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.force_travail),1,1),',','0'||TO_CHAR(pLOCALIZE.force_travail),TO_CHAR(pLOCALIZE.force_travail)) , '---'), 12, ' ') ||
                 RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.frais_environnement),1,1),',','0'||TO_CHAR(pLOCALIZE.frais_environnement),TO_CHAR(pLOCALIZE.frais_environnement)) , '---'), 15, ' ') ||
                RPAD(NVL(PLOCALIZE.CODDIR , '---'), 13, ' ') ||
                RPAD(NVL(pLOCALIZE.profil_defaut , '---'), 16, ' ') ||
                RPAD(NVL(pLOCALIZE.code_localize , '---'), 16, ' ') ||
                RPAD(NVL(pLOCALIZE.code_es , '---'), 15, ' ')
                FROM PROFIL_LOCALIZE PLOCALIZE
                WHERE PLOCALIZE.PROFIL_LOCALIZE IN (SELECT PROFIL_LOCALIZE FROM ( SELECT PROFIL_LOCALIZE FROM PROFIL_LOCALIZE ORDER BY PROFIL_LOCALIZE ASC ) WHERE ROWNUM<2)
                ORDER BY PLOCALIZE.DATE_EFFET DESC;

            END IF;

            IF(p_profi ='*' and p_filtre_date <>'*') then

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY'),
                RPAD(NVL(TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PLOCALIZE.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                /*RPAD(NVL(TO_CHAR(pLOCALIZE.force_travail) , '---'), 12, ' ') ||
                 RPAD(NVL(TO_CHAR(pLOCALIZE.frais_environnement) , '---'), 15, ' ') ||*/
                 RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.force_travail),1,1),',','0'||TO_CHAR(pLOCALIZE.force_travail),TO_CHAR(pLOCALIZE.force_travail)) , '---'), 12, ' ') ||
                 RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.frais_environnement),1,1),',','0'||TO_CHAR(pLOCALIZE.frais_environnement),TO_CHAR(pLOCALIZE.frais_environnement)) , '---'), 15, ' ') ||
                RPAD(NVL(PLOCALIZE.CODDIR , '---'), 13, ' ') ||
                RPAD(NVL(pLOCALIZE.profil_defaut , '---'), 16, ' ') ||
                RPAD(NVL(pLOCALIZE.code_localize , '---'), 16, ' ') ||
                RPAD(NVL(pLOCALIZE.code_es , '---'), 15, ' ')
                FROM PROFIL_LOCALIZE PLOCALIZE
                WHERE  EXTRACT(YEAR FROM PLOCALIZE.DATE_EFFET) >= p_filtre_date

             -- WHERE PLOCALIZE.DATE_EFFET >= to_date(p_filtre_date,'YYYY')
                -- *-D
                AND PLOCALIZE.PROFIL_LOCALIZE IN (SELECT PROFIL_LOCALIZE FROM (  SELECT PROFIL_LOCALIZE FROM PROFIL_LOCALIZE PLOCALIZE WHERE  EXTRACT(YEAR FROM PLOCALIZE.DATE_EFFET) >= p_filtre_date AND ROWNUM<2 ) )
                ORDER BY PLOCALIZE.DATE_EFFET DESC;

            END IF;

            if(p_profi <>'*' and p_filtre_date ='*') then

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY'),
                RPAD(NVL(TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PLOCALIZE.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                /*RPAD(NVL(TO_CHAR(pLOCALIZE.force_travail) , '---'), 12, ' ') ||
                                    RPAD(NVL(TO_CHAR(pLOCALIZE.frais_environnement) , '---'), 15, ' ') ||*/
                                    RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.force_travail),1,1),',','0'||TO_CHAR(pLOCALIZE.force_travail),TO_CHAR(pLOCALIZE.force_travail)) , '---'), 12, ' ') ||
                                    RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.frais_environnement),1,1),',','0'||TO_CHAR(pLOCALIZE.frais_environnement),TO_CHAR(pLOCALIZE.frais_environnement)) , '---'), 15, ' ') ||
                RPAD(NVL(PLOCALIZE.CODDIR , '---'), 13, ' ') ||
                RPAD(NVL(pLOCALIZE.profil_defaut , '---'), 16, ' ') ||
                RPAD(NVL(pLOCALIZE.code_localize , '---'), 16, ' ') ||
                RPAD(NVL(pLOCALIZE.code_es , '---'), 15, ' ')
                FROM PROFIL_LOCALIZE PLOCALIZE
                WHERE PLOCALIZE.PROFIL_LOCALIZE = p_profi
                ORDER BY PLOCALIZE.DATE_EFFET DESC;

                OPEN C_PROFILLOCALIZE;
                FETCH C_PROFILLOCALIZE INTO l_profi;
                IF (l_profi is null) THEN
                        OPEN    p_curseur FOR
                        SELECT
                        TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY'),
                        RPAD(NVL(TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                        RPAD(NVL(DECODE(PLOCALIZE.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                        /*RPAD(NVL(TO_CHAR(pLOCALIZE.force_travail) , '---'), 12, ' ') ||
                                    RPAD(NVL(TO_CHAR(pLOCALIZE.frais_environnement) , '---'), 15, ' ') ||*/
                                    RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.force_travail),1,1),',','0'||TO_CHAR(pLOCALIZE.force_travail),TO_CHAR(pLOCALIZE.force_travail)) , '---'), 12, ' ') ||
                                    RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.frais_environnement),1,1),',','0'||TO_CHAR(pLOCALIZE.frais_environnement),TO_CHAR(pLOCALIZE.frais_environnement)) , '---'), 15, ' ') ||
                        RPAD(NVL(PLOCALIZE.CODDIR , '---'), 13, ' ') ||
                        RPAD(NVL(pLOCALIZE.profil_defaut , '---'), 16, ' ') ||
                        RPAD(NVL(pLOCALIZE.code_localize , '---'), 16, ' ') ||
                        RPAD(NVL(pLOCALIZE.code_es , '---'), 15, ' ')
                        FROM PROFIL_LOCALIZE PLOCALIZE
                        WHERE PLOCALIZE.PROFIL_LOCALIZE in (SELECT DISTINCT PROFIL_LOCALIZE FROM PROFIL_LOCALIZE WHERE ROWNUM <='1')
                        ORDER BY PLOCALIZE.PROFIL_LOCALIZE ASC;
                END IF;
                CLOSE C_PROFILLOCALIZE;

            end if;

            if(p_profi <>'*' and p_filtre_date <>'*') then

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY'),
                RPAD(NVL(TO_CHAR(PLOCALIZE.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PLOCALIZE.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                /*RPAD(NVL(TO_CHAR(pLOCALIZE.force_travail) , '---'), 12, ' ') ||
                                    RPAD(NVL(TO_CHAR(pLOCALIZE.frais_environnement) , '---'), 15, ' ') ||*/
                                    RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.force_travail),1,1),',','0'||TO_CHAR(pLOCALIZE.force_travail),TO_CHAR(pLOCALIZE.force_travail)) , '---'), 12, ' ') ||
                                    RPAD(NVL(DECODE(SUBSTR(TO_CHAR(pLOCALIZE.frais_environnement),1,1),',','0'||TO_CHAR(pLOCALIZE.frais_environnement),TO_CHAR(pLOCALIZE.frais_environnement)) , '---'), 15, ' ') ||
                RPAD(NVL(PLOCALIZE.CODDIR , '---'), 13, ' ') ||
                RPAD(NVL(pLOCALIZE.profil_defaut , '---'), 16, ' ') ||
                RPAD(NVL(pLOCALIZE.code_localize , '---'), 16, ' ') ||
                RPAD(NVL(pLOCALIZE.code_es , '---'), 15, ' ')
                FROM PROFIL_LOCALIZE PLOCALIZE
                WHERE PLOCALIZE.PROFIL_LOCALIZE = p_profi
                AND  EXTRACT(YEAR FROM PLOCALIZE.DATE_EFFET) >= p_filtre_date
               -- AND PLOCALIZE.DATE_EFFET >= to_date(p_filtre_date,'YYYY')
                ORDER BY PLOCALIZE.DATE_EFFET DESC;

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
      EXCEPTION
      WHEN OTHERS THEN
           p_message := SQLCODE||' ' ||SQLERRM;
    END  LISTER_DETAILS_PROFIL_LOCALIZE;

END PACK_PROFIL_LOCALIZE;
/
