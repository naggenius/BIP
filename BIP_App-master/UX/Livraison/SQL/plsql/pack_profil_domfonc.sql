create or replace
PACKAGE     PACK_PROFIL_DOMFONC AS

  TYPE profil_domfoncCurType IS REF CURSOR RETURN PROFIL_DOMFONC%ROWTYPE;

 /*aDDED NEW SP FOR UNICIT CHECK*/
  PROCEDURE PROFILFI_PROFILLOC_EXISTS(
    P_PROFIL IN PROFIL_FI.PROFIL_FI%TYPE,
    P_MESSAGE OUT MESSAGE.LIMSG%TYPE );
    
	PROCEDURE MAJ_PROFIL_DOMFONC_LOGS (p_profil          IN  PROFIL_DOMFONC_LOGS.PROFIL_DOMFONC%TYPE,
									   p_date_effet      IN  VARCHAR2,
									   p_user_log        IN  PROFIL_DOMFONC_LOGS.USER_LOG%TYPE,
									   p_colonne         IN  PROFIL_DOMFONC_LOGS.COLONNE%TYPE,
									   p_valeur_prec     IN  PROFIL_DOMFONC_LOGS.VALEUR_PREC%TYPE,
									   p_valeur_nouv     IN  PROFIL_DOMFONC_LOGS.VALEUR_NOUV%TYPE,
									   p_commentaire     IN  PROFIL_DOMFONC_LOGS.COMMENTAIRE%TYPE
                                 );

/* Alimentation de p_libelle avec la colonne LIBELLE de la 1ère ligne de la table PROFIL_DOMFONC pour laquelle la colonne PROFIL_DOMFONC est p_profil
   Sinon, alimentation de p_libelle à chaine vide.
   (A la création d¿une 1ère date d¿effet pour un code profilDomfonc, le libellé doit être vide,
   à la création d¿une date d'effet supplémentaire pour ce code profilDomfonc, le libellé doit être celui précédemment créé)
*/
PROCEDURE getLibelle_ProfilDomFonc(p_profil IN PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                   p_libelle OUT PROFIL_DOMFONC.LIBELLE%TYPE
                                  );

-- Rechercher s¿il existe une ligne dans la table PROFIL_DOMFONC pour laquelle :
-- la colonne DATE_EFFET a pour valeur p_date_effet
-- la colonne  CODDIR a pour valeur p_coddir
-- Si oui, alimenter p_message avec le message 21278.

PROCEDURE not_Exists_Profil_Defaut(p_date_effet	IN VARCHAR2,
									p_coddir IN PROFIL_DOMFONC.CODDIR%TYPE,
									p_message OUT VARCHAR2);

-- Utilisee dans le cas de la modification
-- Rechercher s¿il existe une ligne dans la table PROFIL_DOMFONC ,  autre que le profil qu'on veur mette a jour pour laquelle :
-- la colonne DATE_EFFET a pour valeur p_date_effet
-- la colonne  CODDIR a pour valeur p_coddir
-- Si oui, alimenter p_message avec le message 21278.
PROCEDURE not_Exists_Profil_Defaut_m(
                  p_profil IN VARCHAR2,
                  p_date_effet	IN VARCHAR2,
									p_coddir IN PROFIL_DOMFONC.CODDIR%TYPE,
									p_message OUT VARCHAR2);

 -- ********************************************************************************** --
    -- Liste Profils de DOMFONC : PPM 49169
    -- ********************************************************************************** --

TYPE list_profildomfonc_View IS RECORD (
                                       P_PROFI   PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                       P_LIBELLE VARCHAR2(500)
                                      );

TYPE list_profildomfonc_ViewCurType IS REF CURSOR RETURN list_profildomfonc_View;

PROCEDURE LISTER_PROFIL_DOMFONC( p_profil         IN PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                p_filtre_date   IN VARCHAR2,
                                p_userid        IN VARCHAR2,
                                p_curseur       IN OUT list_profildomfonc_ViewCurType,
                                p_message       OUT VARCHAR2
                              );

 -- ********************************************************************************** --
    -- Liste Détails Profils de DOMFONC : PPM 49169
    -- ********************************************************************************** --

TYPE details_profildomfonc_View IS RECORD (
                                            P_PROFI     PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                            P_LIBELLE   VARCHAR2(1000)
                                         );

TYPE details_profildomf_ViewCurType IS REF CURSOR RETURN details_profildomfonc_View;

PROCEDURE LISTER_DETAILS_PROFIL_DOMFONC( p_profi         IN PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                        p_filtre_date   IN VARCHAR2,
                                        p_userid        IN VARCHAR2,
                                        p_curseur       IN OUT details_profildomf_ViewCurType,
                                        p_message       OUT VARCHAR2
                                      );

PROCEDURE isValidProfilDOMFONC ( p_profil_domfonc          IN  PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                 p_filtre_date             IN  VARCHAR2,
                                 p_message                 OUT  MESSAGE.LIMSG%TYPE
                                 );

PROCEDURE PROFIL_DOMFONC_EXISTS(p_profil     IN PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                p_date_effet IN VARCHAR2,
                                p_result     OUT VARCHAR2,
                                p_message    OUT MESSAGE.LIMSG%TYPE
                               );

PROCEDURE ESTPROFILAFFECTERESSMENSANNEE(p_profil                  IN PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                        p_filtre_date             IN  VARCHAR2,
                                        p_message                 OUT VARCHAR2
                                        );

PROCEDURE DELETE_PROFIL_DOMFONC (p_profil              IN PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
								 p_date_effet          IN  VARCHAR2,
								 p_userid              IN  VARCHAR2,
								 p_nbcurseur           OUT INTEGER,
								 p_message             OUT VARCHAR2
								);


--PPM 49169 : Insertion profil dom fonc
TYPE string_array IS TABLE OF VARCHAR2(1000);

FUNCTION SPLIT_STRING ( p_str       IN VARCHAR2,
                            p_delim     IN CHAR default ','
                          )
RETURN string_array;

PROCEDURE INSERT_PROFIL_DOMFONC (p_profil_domfonc      IN  PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                               p_libelle                IN  PROFIL_DOMFONC.LIBELLE%TYPE,
                               p_date_effet             IN  VARCHAR2,
                               p_top_actif              IN  PROFIL_DOMFONC.TOP_ACTIF%TYPE,
                               p_force_travail          IN  PROFIL_DOMFONC.FORCE_TRAVAIL%TYPE,
                               p_frais_environnement    IN  PROFIL_DOMFONC.FRAIS_ENVIRONNEMENT%TYPE,
                               p_commentaire            IN  PROFIL_DOMFONC.COMMENTAIRE%TYPE,
                               p_coddir                 IN  PROFIL_DOMFONC.CODDIR%TYPE,
                               p_profil_defaut			IN  PROFIL_DOMFONC.PROFIL_DEFAUT%TYPE,
                               p_code_es                IN  PROFIL_DOMFONC.CODE_ES%TYPE,
                               p_userid                 IN VARCHAR2,
                               p_message                OUT VARCHAR2
                               );

--PPM 49169 : Mise à jour profil domfonc

-- *********************************************************************************
--       Procedure   MISE A JOUR  PROFIL DOMFONC
-- *********************************************************************************
     PROCEDURE UPDATE_PROFIL_DOMFONC (p_profil                 IN  PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
									p_libelle                IN  PROFIL_DOMFONC.LIBELLE%TYPE,
									p_date_effet             IN  VARCHAR2,
									p_top_actif              IN  PROFIL_DOMFONC.TOP_ACTIF%TYPE,
									p_force_travail			 IN  PROFIL_DOMFONC.FORCE_TRAVAIL%TYPE,
									p_frais_environnement	 IN  PROFIL_DOMFONC.FRAIS_ENVIRONNEMENT%TYPE,
									p_commentaire            IN  PROFIL_DOMFONC.COMMENTAIRE%TYPE,
									p_coddir                 IN  VARCHAR2,
									p_profil_defaut			 IN  PROFIL_DOMFONC.PROFIL_DEFAUT%TYPE,
                  p_code_es                IN  PROFIL_DOMFONC.CODE_ES%TYPE,
									p_userid                 IN  VARCHAR2,
                  p_message                OUT VARCHAR2
                              );

-- *********************************************************************************
--       Procedure   AJAX - PROFIL DE DOMFONC - isValid Code ES
-- *********************************************************************************
  PROCEDURE SELECT_PROFIL_DOMFONC (p_profil                  IN  PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                   p_date_effet              IN  VARCHAR2,
                                   p_curprofil_domfonc       OUT profil_domfoncCurType
                                  );


 PROCEDURE isValidCodeEs ( p_code_es          IN  VARCHAR2,
                               p_userid          IN  VARCHAR2,
                               p_message         OUT VARCHAR2
                             ) ;

END PACK_PROFIL_DOMFONC;
/

create or replace
PACKAGE BODY     PACK_PROFIL_DOMFONC AS

							 -- *********************************************************************************
--       Procedure   AJAX - PROFIL DOMFONC - isValid Profil DOMFONC
-- *********************************************************************************
 /*aDDED NEW SP FOR UNICIT CHECK*/
PROCEDURE PROFILFI_PROFILLOC_EXISTS(
    P_PROFIL IN PROFIL_FI.PROFIL_FI%TYPE,
    P_MESSAGE OUT MESSAGE.LIMSG%TYPE )
IS
  L_MSG                   VARCHAR2(1024);
  L_PRESENCE              NUMBER := 0;
  PROFILDOMFONC_INTEGRITY EXCEPTION;
BEGIN
  P_MESSAGE := '';
  BEGIN
    SELECT COUNT (*) INTO L_PRESENCE FROM PROFIL_FI WHERE PROFIL_FI = P_PROFIL;
    IF(L_PRESENCE != 0) THEN
      RAISE PROFILDOMFONC_INTEGRITY;
    END IF;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    L_PRESENCE := 0;
  END;
  BEGIN
    SELECT COUNT (*)
    INTO L_PRESENCE
    FROM PROFIL_LOCALIZE
    WHERE PROFIL_LOCALIZE = P_PROFIL;
    IF(L_PRESENCE        != 0) THEN
      RAISE PROFILDOMFONC_INTEGRITY;
    END IF;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    L_PRESENCE := 0;
  END;
EXCEPTION
WHEN PROFILDOMFONC_INTEGRITY THEN
  PACK_GLOBAL.RECUPERER_MESSAGE(21320,NULL, NULL, NULL, L_MSG);
  P_MESSAGE := L_MSG;
END PROFILFI_PROFILLOC_EXISTS;

		PROCEDURE isValidProfilDOMFONC ( p_profil_domfonc          IN  PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                     p_filtre_date             IN  VARCHAR2,
                                     p_message                 OUT  MESSAGE.LIMSG%TYPE
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
				FROM PROFIL_DOMFONC
				WHERE PROFIL_DOMFONC like p_profil_domfonc||'%' AND TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') >= p_filtre_date; --modif

			IF(p_profil_domfonc <>'*' ) THEN
				IF(l_presence = 0) THEN

						RAISE PROFILDOMFONC_INTEGRITY;

				END IF;
			END IF;
		EXCEPTION

			WHEN PROFILDOMFONC_INTEGRITY THEN
			pack_global.recuperer_message(21279,NULL, NULL, NULL, l_msg);
			p_message := l_msg;

		END isValidProfilDOMFONC;



		-- *********************************************************************************
--       Procedure   GESTION DES LOGS - PROFIL DOMFONC
-- *********************************************************************************

    PROCEDURE MAJ_PROFIL_DOMFONC_LOGS (p_profil          IN  PROFIL_DOMFONC_LOGS.PROFIL_DOMFONC%TYPE,
									   p_date_effet      IN  VARCHAR2,
									   p_user_log        IN  PROFIL_DOMFONC_LOGS.USER_LOG%TYPE,
									   p_colonne         IN  PROFIL_DOMFONC_LOGS.COLONNE%TYPE,
									   p_valeur_prec     IN  PROFIL_DOMFONC_LOGS.VALEUR_PREC%TYPE,
									   p_valeur_nouv     IN  PROFIL_DOMFONC_LOGS.VALEUR_NOUV%TYPE,
									   p_commentaire     IN  PROFIL_DOMFONC_LOGS.COMMENTAIRE%TYPE
                                 ) IS


    BEGIN

            IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN

                INSERT INTO PROFIL_DOMFONC_LOGS
                    (PROFIL_DOMFONC, date_effet, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
                VALUES
                    (p_profil, to_char('01-01-'||p_date_effet), SYSDATE, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire); --modif

            END IF;
            -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

    END MAJ_PROFIL_DOMFONC_LOGS;

 PROCEDURE getLibelle_ProfilDomFonc(p_profil IN  PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                   p_libelle OUT PROFIL_DOMFONC.LIBELLE%TYPE
                                 ) IS
  BEGIN
    -- Initialisation du libellé à chaine vide par défaut
    p_libelle := '';

    IF (p_profil IS NOT NULL) THEN
      -- Alimentation du libellé si trouvé
      SELECT LIBELLE INTO p_libelle
        FROM PROFIL_DOMFONC
        WHERE PROFIL_DOMFONC = p_profil
        AND ROWNUM <= 1;

    END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        -- Alimentation du libellé à chaine vide par défaut
        p_libelle := '';
END getLibelle_ProfilDomFonc;

PROCEDURE not_Exists_Profil_Defaut(p_date_effet	IN VARCHAR2,
									p_coddir IN PROFIL_DOMFONC.CODDIR%TYPE,
									p_message OUT VARCHAR2) IS
	l_compteur INTEGER;

	BEGIN
		l_compteur := 0;

		IF (p_date_effet IS NOT NULL
			and p_coddir IS NOT NULL) THEN

			SELECT COUNT(1) INTO l_compteur
				FROM PROFIL_DOMFONC
				WHERE TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = p_date_effet --modif
				AND CODDIR = p_coddir
        AND PROFIL_DEFAUT = 'O'
				AND ROWNUM <= 1;

			IF (l_compteur > 0) THEN
				Pack_Global.recuperer_message(21278, '%s1', p_date_effet, '%s2', p_coddir, NULL, p_message);
			END IF;
		END IF;

END not_Exists_Profil_Defaut;

--PPM 49169 : test en cas de l'update
PROCEDURE not_Exists_Profil_Defaut_m(
                  p_profil IN VARCHAR2,
                  p_date_effet	IN VARCHAR2,
									p_coddir IN PROFIL_DOMFONC.CODDIR%TYPE,
									p_message OUT VARCHAR2) IS
	l_compteur INTEGER;

	BEGIN
		l_compteur := 0;

		IF (p_date_effet IS NOT NULL
			and p_coddir IS NOT NULL) THEN

			SELECT COUNT(1) INTO l_compteur
				FROM PROFIL_DOMFONC
				WHERE TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = p_date_effet --modif
				AND CODDIR = p_coddir
        AND PROFIL_DEFAUT = 'O'
        AND profil_domfonc <> p_profil
				AND ROWNUM <= 1;

			IF (l_compteur > 0) THEN
				Pack_Global.recuperer_message(21278, '%s1', p_date_effet, '%s2', p_coddir, NULL, p_message);
			END IF;
		END IF;

END not_Exists_Profil_Defaut_m;

--PPM 49169

PROCEDURE LISTER_PROFIL_DOMFONC( p_profil         IN PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                p_filtre_date   IN VARCHAR2,
                                p_userid        IN VARCHAR2,
                                p_curseur       IN OUT list_profildomfonc_ViewCurType,
                                p_message       OUT VARCHAR2
                              ) IS


    l_liste     VARCHAR2(5000);
    l_profi     VARCHAR2(1024);
    l_libelle     VARCHAR2(1024);
    l_filtre_date     VARCHAR2(7);
    l_filtre_domfonc       VARCHAR2(12);

    CURSOR C_PROFILDOMFONC IS
                SELECT PDOMFONC.PROFIL_DOMFONC, PDOMFONC.LIBELLE
                FROM PROFIL_DOMFONC PDOMFONC
                WHERE PDOMFONC.PROFIL_DOMFONC  = p_profil;

    CURSOR  p_curseur2 IS
    SELECT DISTINCT
    PROFIL_DOMFONC,
    RPAD(NVL(to_char(PROFIL_DOMFONC), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
    from PROFIL_DOMFONC
    WHERE TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') >= p_filtre_date
    --WHERE DATE_EFFET >= to_date(p_filtre_date,'YYYY')
    AND (PROFIL_DOMFONC like p_profil||'%' OR PROFIL_DOMFONC = p_profil)
    order by PROFIL_DOMFONC asc;

    t_curseur2   p_curseur2%ROWTYPE;

    CURSOR p_curseur3 IS
    SELECT DISTINCT
    PROFIL_DOMFONC,
    RPAD(NVL(to_char(PROFIL_DOMFONC), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
    from PROFIL_DOMFONC
    WHERE TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') >= p_filtre_date
   -- WHERE DATE_EFFET >= to_date(p_filtre_date,'YYYY')
    order by PROFIL_DOMFONC asc;

    t_curseur3   p_curseur3%ROWTYPE;

    CURSOR C_PROFILDOMFONC2 IS
            SELECT PDOMFONC.PROFIL_DOMFONC, PDOMFONC.LIBELLE
            FROM PROFIL_DOMFONC PDOMFONC
            WHERE PDOMFONC.PROFIL_DOMFONC like p_profil||'%';

    BEGIN


            IF(p_profil is not null or p_profil !='') THEN


                IF(p_filtre_date is null) THEN

                    OPEN C_PROFILDOMFONC;
                                    FETCH C_PROFILDOMFONC INTO l_profi, l_libelle;
                                    IF C_PROFILDOMFONC%NOTFOUND THEN
                                        pack_global.recuperer_message(4602,NULL, NULL, NULL, p_message);
                                            OPEN      p_curseur FOR
                                            SELECT DISTINCT
                                            PROFIL_DOMFONC,
                                            RPAD(NVL(to_char(PROFIL_DOMFONC), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                                            from PROFIL_DOMFONC
                                            order by PROFIL_DOMFONC asc;
                                    END IF;
                    CLOSE C_PROFILDOMFONC;

                    OPEN      p_curseur FOR
                              SELECT DISTINCT
                              PROFIL_DOMFONC,
                              RPAD(NVL(to_char(PROFIL_DOMFONC), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                              from PROFIL_DOMFONC
                              where PROFIL_DOMFONC = p_profil
                              order by PROFIL_DOMFONC asc;

                END IF;

                if(p_profil ='*') THEN

                    if(p_filtre_date ='*') then

                              OPEN      p_curseur FOR
                              SELECT DISTINCT
                              PROFIL_DOMFONC,
                              RPAD(NVL(to_char(PROFIL_DOMFONC), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                              from PROFIL_DOMFONC
                              order by PROFIL_DOMFONC asc;

                    else

                              IF(p_filtre_date is null) THEN

                                              OPEN      p_curseur FOR
                                              SELECT DISTINCT
                                              PROFIL_DOMFONC,
                                              RPAD(NVL(to_char(PROFIL_DOMFONC), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                                              from PROFIL_DOMFONC
                                              order by PROFIL_DOMFONC asc;
                              ELSE

                                      OPEN      p_curseur FOR
                                      SELECT DISTINCT
                                      PROFIL_DOMFONC,
                                      RPAD(NVL(to_char(PROFIL_DOMFONC), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                                      from PROFIL_DOMFONC
                                      WHERE TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') >= p_filtre_date
                                   -- WHERE DATE_EFFET >= to_date(p_filtre_date,'YYYY') --to_char(date_effet,'MM/YYYY') >= p_filtre_date
                                      order by PROFIL_DOMFONC asc;

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
                          PROFIL_DOMFONC,
                          RPAD(NVL(to_char(PROFIL_DOMFONC), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                          FROM PROFIL_DOMFONC
                          WHERE PROFIL_DOMFONC like p_profil||'%'
                          ORDER BY PROFIL_DOMFONC ASC;

                        OPEN C_PROFILDOMFONC2;
                        FETCH C_PROFILDOMFONC2 INTO l_profi, l_libelle;
                        IF C_PROFILDOMFONC2%NOTFOUND THEN
                                OPEN      p_curseur FOR
                                SELECT DISTINCT
                                ' ',
                                RPAD(NVL(to_char(' '), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(' '), ' '), 90, ' ')
                                FROM DUAL;
                        END IF;
                        CLOSE C_PROFILDOMFONC2;

                    ELSE
                            OPEN      p_curseur FOR
                            SELECT DISTINCT
                            PROFIL_DOMFONC,
                            RPAD(NVL(to_char(PROFIL_DOMFONC), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(libelle), ' '), 90, ' ')
                            from PROFIL_DOMFONC
                            WHERE TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') >= p_filtre_date
                         -- WHERE TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') >=  p_filtre_date --to_char(date_effet,'MM/YYYY') >= p_filtre_date
                            AND (PROFIL_DOMFONC like p_profil||'%' OR PROFIL_DOMFONC = p_profil)
                            order by PROFIL_DOMFONC asc;

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

    END  LISTER_PROFIL_DOMFONC;


-- *********************************************************************************
--       Procedure   LISTE  DETAILS PROFIL DE DOMFONC : PPM 49169
-- *********************************************************************************

    PROCEDURE LISTER_DETAILS_PROFIL_DOMFONC( p_profi         IN PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                        p_filtre_date   IN VARCHAR2,
                                        p_userid        IN VARCHAR2,
                                        p_curseur       IN OUT details_profildomf_ViewCurType,
                                        p_message       OUT VARCHAR2
                                      ) IS

      l_profi     VARCHAR2(1024);
      CURSOR C_PROFILDOMFONC IS
                SELECT PDOMFONC.PROFIL_DOMFONC
                FROM PROFIL_DOMFONC PDOMFONC
                WHERE PDOMFONC.PROFIL_DOMFONC  = p_profi;
      t_curseur   p_curseur%ROWTYPE;

      BEGIN

      if(p_profi is not null)   then

        OPEN C_PROFILDOMFONC;
        FETCH C_PROFILDOMFONC INTO l_profi;
        IF C_PROFILDOMFONC%NOTFOUND THEN

        OPEN      p_curseur FOR
        SELECT
        ' ',
        RPAD(NVL(to_char(' '), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(' '), ' '), 90, ' ')
        FROM DUAL;

        ELSE

                 CLOSE C_PROFILDOMFONC;

            if(p_filtre_date is null) then

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY'),
                RPAD(NVL(TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PDOMFONC.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                RPAD(NVL(TO_CHAR(pdomfonc.force_travail) , '---'), 12, ' ') ||
                RPAD(NVL(TO_CHAR(pdomfonc.frais_environnement) , '---'), 15, ' ') ||
                RPAD(NVL(PDOMFONC.CODDIR , '---'), 13, ' ') ||
                RPAD(NVL(pdomfonc.profil_defaut , '---'), 16, ' ') ||
                RPAD(NVL(pdomfonc.code_es , '---'), 15, ' ')
                FROM PROFIL_DOMFONC PDOMFONC
                WHERE PDOMFONC.PROFIL_DOMFONC = p_profi
                ORDER BY PDOMFONC.DATE_EFFET DESC;


                            OPEN C_PROFILDOMFONC;
                            FETCH C_PROFILDOMFONC INTO l_profi;
                            IF (l_profi is null) THEN
                                    OPEN    p_curseur FOR
                                    SELECT
                                    TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY'),
                                    RPAD(NVL(TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                                    RPAD(NVL(DECODE(PDOMFONC.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                                    RPAD(NVL(TO_CHAR(pdomfonc.force_travail) , '---'), 12, ' ') ||
                                    RPAD(NVL(TO_CHAR(pdomfonc.frais_environnement) , '---'), 15, ' ') ||
                                    RPAD(NVL(PDOMFONC.CODDIR , '---'), 13, ' ') ||
                                    RPAD(NVL(pdomfonc.profil_defaut , '---'), 16, ' ') ||
                                    RPAD(NVL(pdomfonc.code_es , '---'), 15, ' ')
                                    FROM PROFIL_DOMFONC PDOMFONC
                                    WHERE PDOMFONC.PROFIL_DOMFONC in (SELECT DISTINCT PROFIL_DOMFONC FROM PROFIL_DOMFONC WHERE ROWNUM <='1')
                                    ORDER BY PDOMFONC.PROFIL_DOMFONC ASC;
                            END IF;
                            CLOSE C_PROFILDOMFONC;
            else

                            OPEN C_PROFILDOMFONC;
                            FETCH C_PROFILDOMFONC INTO l_profi;
                            IF C_PROFILDOMFONC%NOTFOUND THEN

                            OPEN      p_curseur FOR
                            SELECT
                            ' ',
                            RPAD(NVL(to_char(' '), ' '), 20, ' ') || RPAD(NVL(TO_CHAR(' '), ' '), 90, ' ')
                            FROM DUAL;
                            END IF;

                            CLOSE C_PROFILDOMFONC;



            end if;

            IF(p_profi ='*' and p_filtre_date is null) THEN

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY'),
                RPAD(NVL(TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PDOMFONC.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                RPAD(NVL(TO_CHAR(pdomfonc.force_travail) , '---'), 12, ' ') ||
                RPAD(NVL(TO_CHAR(pdomfonc.frais_environnement) , '---'), 15, ' ') ||
                RPAD(NVL(PDOMFONC.CODDIR , '---'), 13, ' ') ||
                RPAD(NVL(pdomfonc.profil_defaut , '---'), 16, ' ') ||
                RPAD(NVL(pdomfonc.code_es , '---'), 15, ' ')
                FROM PROFIL_DOMFONC PDOMFONC
                ORDER BY PDOMFONC.DATE_EFFET DESC;
            END IF;

            IF(p_profi ='*' and p_filtre_date ='*') THEN

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY'),
                RPAD(NVL(TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PDOMFONC.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                RPAD(NVL(TO_CHAR(pdomfonc.force_travail) , '---'), 12, ' ') ||
                RPAD(NVL(TO_CHAR(pdomfonc.frais_environnement) , '---'), 15, ' ') ||
                RPAD(NVL(PDOMFONC.CODDIR , '---'), 13, ' ') ||
                RPAD(NVL(pdomfonc.profil_defaut , '---'), 16, ' ') ||
                RPAD(NVL(pdomfonc.code_es , '---'), 15, ' ')
                FROM PROFIL_DOMFONC PDOMFONC
                WHERE PDOMFONC.PROFIL_DOMFONC IN (SELECT PROFIL_DOMFONC FROM ( SELECT PROFIL_DOMFONC FROM PROFIL_DOMFONC ORDER BY PROFIL_DOMFONC ASC ) WHERE ROWNUM<2)
                ORDER BY PDOMFONC.DATE_EFFET DESC;

            END IF;

            IF(p_profi ='*' and p_filtre_date <>'*') then

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY'),
                RPAD(NVL(TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PDOMFONC.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                RPAD(NVL(TO_CHAR(pdomfonc.force_travail) , '---'), 12, ' ') ||
                RPAD(NVL(TO_CHAR(pdomfonc.frais_environnement) , '---'), 15, ' ') ||
                RPAD(NVL(PDOMFONC.CODDIR , '---'), 13, ' ') ||
                RPAD(NVL(pdomfonc.profil_defaut , '---'), 16, ' ') ||
                RPAD(NVL(pdomfonc.code_es , '---'), 15, ' ')
                FROM PROFIL_DOMFONC PDOMFONC
                WHERE  TO_CHAR(TO_DATE(PDOMFONC.DATE_EFFET), 'YYYY') >= p_filtre_date
               
             -- WHERE PDOMFONC.DATE_EFFET >= to_date(p_filtre_date,'YYYY')
                -- *-D
                AND PDOMFONC.PROFIL_DOMFONC IN (SELECT PROFIL_DOMFONC FROM (  SELECT PROFIL_DOMFONC FROM PROFIL_DOMFONC PDOMFONC WHERE  TO_CHAR(TO_DATE(PDOMFONC.DATE_EFFET), 'YYYY') >= p_filtre_date AND ROWNUM<2 ) )
                ORDER BY PDOMFONC.DATE_EFFET DESC;

            END IF;

            if(p_profi <>'*' and p_filtre_date ='*') then

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY'),
                RPAD(NVL(TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PDOMFONC.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                RPAD(NVL(TO_CHAR(pdomfonc.force_travail) , '---'), 12, ' ') ||
                RPAD(NVL(TO_CHAR(pdomfonc.frais_environnement) , '---'), 15, ' ') ||
                RPAD(NVL(PDOMFONC.CODDIR , '---'), 13, ' ') ||
                RPAD(NVL(pdomfonc.profil_defaut , '---'), 16, ' ') ||
                RPAD(NVL(pdomfonc.code_es , '---'), 15, ' ')
                FROM PROFIL_DOMFONC PDOMFONC
                WHERE PDOMFONC.PROFIL_DOMFONC = p_profi
                ORDER BY PDOMFONC.DATE_EFFET DESC;

                OPEN C_PROFILDOMFONC;
                FETCH C_PROFILDOMFONC INTO l_profi;
                IF (l_profi is null) THEN
                        OPEN    p_curseur FOR
                        SELECT
                        TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY'),
                        RPAD(NVL(TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                        RPAD(NVL(DECODE(PDOMFONC.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                        RPAD(NVL(TO_CHAR(pdomfonc.force_travail) , '---'), 12, ' ') ||
                        RPAD(NVL(TO_CHAR(pdomfonc.frais_environnement) , '---'), 15, ' ') ||
                        RPAD(NVL(PDOMFONC.CODDIR , '---'), 13, ' ') ||
                        RPAD(NVL(pdomfonc.profil_defaut , '---'), 16, ' ') ||
                        RPAD(NVL(pdomfonc.code_es , '---'), 15, ' ')
                        FROM PROFIL_DOMFONC PDOMFONC
                        WHERE PDOMFONC.PROFIL_DOMFONC in (SELECT DISTINCT PROFIL_DOMFONC FROM PROFIL_DOMFONC WHERE ROWNUM <='1')
                        ORDER BY PDOMFONC.PROFIL_DOMFONC ASC;
                END IF;
                CLOSE C_PROFILDOMFONC;

            end if;

            if(p_profi <>'*' and p_filtre_date <>'*') then

                OPEN    p_curseur FOR
                SELECT
                TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY'),
                RPAD(NVL(TO_CHAR(PDOMFONC.DATE_EFFET,'YYYY') , '---'), 13, ' ') ||
                RPAD(NVL(DECODE(PDOMFONC.TOP_ACTIF,'O','OUI','NON') , '---'), 8, ' ') ||
                RPAD(NVL(TO_CHAR(pdomfonc.force_travail) , '---'), 12, ' ') ||
                RPAD(NVL(TO_CHAR(pdomfonc.frais_environnement) , '---'), 15, ' ') ||
                RPAD(NVL(PDOMFONC.CODDIR , '---'), 13, ' ') ||
                RPAD(NVL(pdomfonc.profil_defaut , '---'), 16, ' ') ||
                RPAD(NVL(pdomfonc.code_es , '---'), 15, ' ')
                FROM PROFIL_DOMFONC PDOMFONC
                WHERE PDOMFONC.PROFIL_DOMFONC = p_profi
                AND  TO_CHAR(TO_DATE(PDOMFONC.DATE_EFFET), 'YYYY') >= p_filtre_date
               -- AND PDOMFONC.DATE_EFFET >= to_date(p_filtre_date,'YYYY')
                ORDER BY PDOMFONC.DATE_EFFET DESC;

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

    END  LISTER_DETAILS_PROFIL_DOMFONC;

-- *********************************************************************************
--       Procedure   EXISTS GESTION DES PROFILS DOMFONC : PPM 49169
-- *********************************************************************************

PROCEDURE PROFIL_DOMFONC_EXISTS(p_profil     IN PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                p_date_effet IN VARCHAR2,
                                p_result     OUT VARCHAR2,
                                p_message    OUT MESSAGE.LIMSG%TYPE
                               ) IS

		l_msg                        VARCHAR2(1024);
		l_presence                   NUMBER;
		PROFILDOMFONC1_INTEGRITY     EXCEPTION;
		PROFILDOMFONC2_INTEGRITY     EXCEPTION;


		BEGIN

			-- Positionner le nb de curseurs ==> 0
			-- Initialiser le message retour

			p_message := '';
      p_result := '';

				SELECT COUNT (*)
				INTO l_presence
				FROM PROFIL_DOMFONC
				--WHERE PROFIL_DOMFONC = p_profil AND TO_CHAR(DATE_EFFET,'YYYY') = p_date_effet;
        WHERE PROFIL_DOMFONC = p_profil AND  TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = p_date_effet; --modif

			IF(l_presence != 0) THEN
				RAISE PROFILDOMFONC1_INTEGRITY;
      ELSE RAISE PROFILDOMFONC2_INTEGRITY;
      END IF;

		EXCEPTION

			WHEN PROFILDOMFONC1_INTEGRITY THEN
				pack_global.recuperer_message(21272,NULL, NULL, NULL, l_msg);
				p_message := l_msg;
				p_result :='O' ;
			WHEN PROFILDOMFONC2_INTEGRITY THEN
				pack_global.recuperer_message(21273,NULL, NULL, NULL, l_msg);
				p_message := l_msg;
				p_result :='N' ;

END PROFIL_DOMFONC_EXISTS;

PROCEDURE ESTPROFILAFFECTERESSMENSANNEE(p_profil                  IN PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                        p_filtre_date             IN  VARCHAR2,
                                        p_message                 OUT VARCHAR2
                                        ) IS


    l_msg                         VARCHAR2(1024);
    libelle                       VARCHAR2(1024);
		coutFT                        NUMBER(12,2);
    coutENV                       NUMBER(12,2);
    top_actif                     CHAR(1);
		PROFILDOMFONC1_INTEGRITY      EXCEPTION;
		PROFILDOMFONC2_INTEGRITY      EXCEPTION;

    CURSOR c_profil_domFonc IS
        SELECT *
        FROM PROFIL_DOMFONC
        WHERE PROFIL_DOMFONC = p_profil AND  TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') =  p_filtre_date; --modif
       -- WHERE PROFIL_DOMFONC = p_profil AND to_char(date_effet,'YYYY') = p_filtre_date;
          l_profil_domFonc c_profil_domFonc%ROWTYPE;

    CURSOR c_stock_fi IS
        SELECT *
        FROM STOCK_FI
        WHERE PROFIL_FI = p_profil;
          l_stock_fi c_stock_fi%ROWTYPE;

    BEGIN

			-- Positionner le nb de curseurs ==> 0
			-- Initialiser le message retour

			p_message := '';



        OPEN c_profil_domFonc;
        FETCH c_profil_domFonc INTO l_profil_domFonc;
        IF c_profil_domFonc%FOUND THEN
							libelle := l_profil_domFonc.LIBELLE;
              top_actif := l_profil_domFonc.TOP_ACTIF;
              coutFT := l_profil_domFonc.FORCE_TRAVAIL;
              coutENV := l_profil_domFonc.FRAIS_ENVIRONNEMENT;
        END IF;
        CLOSE c_profil_domfonc;

        OPEN c_stock_fi;
        FETCH c_stock_fi INTO l_stock_fi;
        IF c_stock_fi%FOUND THEN
              RAISE PROFILDOMFONC1_INTEGRITY;
        ELSE
              RAISE PROFILDOMFONC2_INTEGRITY;
        END IF;
        CLOSE c_stock_fi;

		EXCEPTION

			WHEN PROFILDOMFONC1_INTEGRITY THEN
				PACK_GLOBAL.RECUPERER_MESSAGE(21275, '%s1', p_profil, '%s2', libelle , '%s3' , p_filtre_date ||' -- Top Actif : '||top_actif ||' -- Coût Force de Travail : '||coutFT ||' -- Coût Frais d''Environnement : '||coutENV ||' \nProfil DomFonc déjà utilisé cette année\nValidez-vous la suppression ?', NULL, l_msg);
        p_message := l_msg;
			WHEN PROFILDOMFONC2_INTEGRITY THEN
				PACK_GLOBAL.RECUPERER_MESSAGE(21275, '%s1', p_profil, '%s2', libelle , '%s3' , p_filtre_date ||' -- Top Actif : '||top_actif ||' -- Coût Force de Travail : '||coutFT ||' -- Coût Frais d''Environnement : '||coutENV ||' \nProfil DomFonc non encore utilisé cette année\nValidez-vous la suppression ?', NULL, l_msg);
				p_message := l_msg;

END ESTPROFILAFFECTERESSMENSANNEE;

-- *********************************************************************************
--       Procedure   SUPPRESSION  PROFIL DOMFONC
-- *********************************************************************************

   PROCEDURE DELETE_PROFIL_DOMFONC (p_profil          IN PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                               p_date_effet           IN  VARCHAR2,
                               p_userid               IN VARCHAR2,
                               p_nbcurseur            OUT INTEGER,
                               p_message              OUT VARCHAR2
                               ) IS

   L_USER                  VARCHAR2 (30);
   REFERENTIAL_INTEGRITY   EXCEPTION;
   l_presence              NUMBER;
   l_msg VARCHAR2(1024);

   CURSOR c_profil_domfonc IS
        SELECT PROFIL_DOMFONC
        FROM PROFIL_DOMFONC
        WHERE PROFIL_DOMFONC = p_profil
        AND  TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = p_date_effet; --modif
      --AND to_char(DATE_EFFET, 'YYYY') = p_date_effet;

   l_profil_domfonc c_profil_domfonc%ROWTYPE;

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';
      L_USER := SUBSTR (pack_global.lire_globaldata (p_userid).idarpege, 1, 30);

        OPEN c_profil_domfonc;
        FETCH c_profil_domfonc INTO l_profil_domfonc;

        IF c_profil_domfonc%NOTFOUND THEN
            PACK_GLOBAL.RECUPERER_MESSAGE(21279,'%s1', p_profil, '%s2', p_date_effet, NULL, l_msg);
            p_message := l_msg;
        ELSE

            DELETE FROM PROFIL_DOMFONC
            WHERE PROFIL_DOMFONC = p_profil
            
            AND  TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = p_date_effet; --modif
            --AND TO_CHAR(DATE_EFFET,'YYYY') = p_date_effet;

            MAJ_PROFIL_DOMFONC_LOGS(p_profil, p_date_effet, L_USER, 'TOUTES', 'TOUTES', NULL, 'Suppression du Profil DomFonc');
			PACK_GLOBAL.RECUPERER_MESSAGE(21274,'%s1', p_profil, '%s2', p_date_effet, NULL, l_msg);
			p_message := l_msg;

        END IF;
        CLOSE c_profil_domfonc;

   EXCEPTION

         WHEN OTHERS THEN
         PACK_GLOBAL.RECUPERER_MESSAGE(21279,'%s1', p_profil, '%s2', p_date_effet, NULL, l_msg);
         p_message := l_msg;


   END DELETE_PROFIL_DOMFONC;

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

   --PPM 49169 : script insertion profil dom fonc

    PROCEDURE INSERT_PROFIL_DOMFONC (p_profil_domfonc      IN  PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                               p_libelle                IN  PROFIL_DOMFONC.LIBELLE%TYPE,
                               p_date_effet             IN  VARCHAR2,
                               p_top_actif              IN  PROFIL_DOMFONC.TOP_ACTIF%TYPE,
                               p_force_travail          IN  PROFIL_DOMFONC.FORCE_TRAVAIL%TYPE,
                               p_frais_environnement    IN  PROFIL_DOMFONC.FRAIS_ENVIRONNEMENT%TYPE,
                               p_commentaire            IN  PROFIL_DOMFONC.COMMENTAIRE%TYPE,
                               p_coddir                 IN  PROFIL_DOMFONC.CODDIR%TYPE,
                               p_profil_defaut			IN  PROFIL_DOMFONC.PROFIL_DEFAUT%TYPE,
                               p_code_es                IN  PROFIL_DOMFONC.CODE_ES%TYPE,
                               p_userid                 IN VARCHAR2,
                               p_message                OUT VARCHAR2
                              ) IS

   l_commentaire_logs VARCHAR2(1024);
   l_msg                VARCHAR2(1024);
   l_profi              VARCHAR2(1024);
   l_user               VARCHAR2(7);
   l_presence           NUMBER;
   l_num_ligne          NUMBER;

   CODDIR_INTEGRITY          EXCEPTION;
   CODE_ES_EXP               EXCEPTION;
   PROFIL_DOMFONC_EXP             EXCEPTION;
   PROFIL_DOMFONC_SEUIL_EXP       EXCEPTION;

   CURSOR C_PROFILDOMFONC IS
                SELECT PDOMFONC.PROFIL_DOMFONC
                FROM PROFIL_DOMFONC PDOMFONC
                WHERE PDOMFONC.PROFIL_DOMFONC  = p_profil_domfonc;

    param varchar2(100);


    CURSOR C_ES (param IN varchar2) IS
        SELECT count(ES.CODCAMO) CODCAMO
        FROM ENTITE_STRUCTURE ES
        WHERE ES.CODCAMO = param;
    T_ES            C_ES%ROWTYPE;


    l_var VARCHAR2(200);


   BEGIN


          BEGIN

             SELECT COUNT (*)
             INTO l_presence
             FROM DIRECTIONS
             WHERE to_char(coddir) = p_coddir;

            IF(p_date_effet is null or p_date_effet='') THEN

                OPEN C_PROFILDOMFONC;
                                FETCH C_PROFILDOMFONC INTO l_profi;
                                IF C_PROFILDOMFONC%FOUND THEN
                                    RAISE PROFIL_DOMFONC_EXP;
                                END IF;
                CLOSE C_PROFILDOMFONC;

            END IF;


            IF(p_profil_domfonc is not null and p_date_effet is not null) THEN



                        INSERT INTO PROFIL_DOMFONC
                                (
                                PROFIL_DOMFONC,
                                LIBELLE,
                                DATE_EFFET,
                                TOP_ACTIF,
                                FORCE_TRAVAIL,
                            		FRAIS_ENVIRONNEMENT,
                                COMMENTAIRE,
                                CODDIR,
                                PROFIL_DEFAUT,
                                CODE_ES
                                )
                                VALUES
                                (
                                p_profil_domfonc,
                                p_libelle,
                                to_char('01-01-'||p_date_effet),
                                p_top_actif,
                                p_force_travail,
								p_frais_environnement,
                                p_commentaire,
                                p_coddir,
                                p_profil_defaut,
                                p_code_es
                                );

                                l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

								l_commentaire_logs := 'Creation Profil DomFonc';

								MAJ_PROFIL_DOMFONC_LOGS(p_profil_domfonc, p_date_effet, l_user,'LIBELLE', '', p_libelle,l_commentaire_logs);
                                MAJ_PROFIL_DOMFONC_LOGS(p_profil_domfonc, p_date_effet, l_user,'TOP_ACTIF', '', p_top_actif,l_commentaire_logs);
								MAJ_PROFIL_DOMFONC_LOGS(p_profil_domfonc, p_date_effet, l_user,'FORCE_TRAVAIL', '', p_force_travail,l_commentaire_logs);
                                MAJ_PROFIL_DOMFONC_LOGS(p_profil_domfonc, p_date_effet, l_user,'FRAIS_ENVIRONNEMENT', '', p_frais_environnement,l_commentaire_logs);
								MAJ_PROFIL_DOMFONC_LOGS(p_profil_domfonc, p_date_effet, l_user,'COMMENTAIRE', '', p_commentaire,l_commentaire_logs);
								MAJ_PROFIL_DOMFONC_LOGS(p_profil_domfonc, p_date_effet, l_user,'CODDIR', '', p_coddir,l_commentaire_logs);
                                MAJ_PROFIL_DOMFONC_LOGS(p_profil_domfonc, p_date_effet, l_user,'PROFIL_DEFAUT', '', p_profil_defaut,l_commentaire_logs);
                                MAJ_PROFIL_DOMFONC_LOGS(p_profil_domfonc, p_date_effet, l_user,'CODE_ES', '', p_code_es,l_commentaire_logs);
                 pack_global.recuperer_message(21283,'%s1', p_profil_domfonc, '%s2', p_date_effet, NULL, p_message);
                    END IF;




          END;

   END INSERT_PROFIL_DOMFONC;

-- *********************************************************************************
--       Procedure   MISE A JOUR  PROFIL DOMFONC
-- *********************************************************************************
   PROCEDURE UPDATE_PROFIL_DOMFONC (p_profil                 IN  PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
									p_libelle                IN  PROFIL_DOMFONC.LIBELLE%TYPE,
									p_date_effet             IN  VARCHAR2,
									p_top_actif              IN  PROFIL_DOMFONC.TOP_ACTIF%TYPE,
									p_force_travail			 IN  PROFIL_DOMFONC.FORCE_TRAVAIL%TYPE,
									p_frais_environnement	 IN  PROFIL_DOMFONC.FRAIS_ENVIRONNEMENT%TYPE,
									p_commentaire            IN  PROFIL_DOMFONC.COMMENTAIRE%TYPE,
									p_coddir                 IN  VARCHAR2,
									p_profil_defaut			 IN  PROFIL_DOMFONC.PROFIL_DEFAUT%TYPE,
                  p_code_es                IN  PROFIL_DOMFONC.CODE_ES%TYPE,
									p_userid                 IN  VARCHAR2,
                  p_message                OUT VARCHAR2
                              ) IS

   L_USER                       VARCHAR2(7);
   L_LIBELLE_OLD                PROFIL_DOMFONC.LIBELLE%TYPE;
   L_TOP_ACTIF_OLD              PROFIL_DOMFONC.TOP_ACTIF%TYPE;
   L_FORCE_TRAVAIL_OLD          PROFIL_DOMFONC.FORCE_TRAVAIL%TYPE;
   L_FRAIS_ENVIRONNEMENT_OLD    PROFIL_DOMFONC.FRAIS_ENVIRONNEMENT%TYPE;
   L_COMMENTAIRE_OLD            PROFIL_DOMFONC.COMMENTAIRE%TYPE;
   L_CODDIR_OLD                 PROFIL_DOMFONC.CODDIR%TYPE;
   L_CODE_ES_OLD                PROFIL_DOMFONC.CODE_ES%TYPE;
   L_PROFIL_DEFAUT_OLD          PROFIL_DOMFONC.PROFIL_DEFAUT%TYPE;

   CODE_ES_EXP               EXCEPTION;
   CODDIR_INTEGRITY          EXCEPTION;

    param varchar2(100);

    CURSOR C_ES (param IN varchar2) IS
        SELECT count(ES.CODCAMO) CODCAMO
        FROM ENTITE_STRUCTURE ES
        WHERE ES.CODCAMO = param;
    T_ES            C_ES%ROWTYPE;

    return_value_es bip.pack_profil_fi.string_array;

    l_var        VARCHAR2(200);
    l_presence   NUMBER;

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour



      BEGIN

            SELECT COUNT (*)
            INTO l_presence
            FROM DIRECTIONS
            WHERE coddir = p_coddir;


        IF(l_presence=0) THEN
                  RAISE CODDIR_INTEGRITY;
        ELSE


                -- *****************************************************************************************

                -- ***************** BLOC COMPARAISON : ANCIENS VALEURS ************************************
                    BEGIN
                        SELECT PDF.LIBELLE, PDF.TOP_ACTIF, PDF.FORCE_TRAVAIL, PDF.FRAIS_ENVIRONNEMENT, PDF.COMMENTAIRE, PDF.CODDIR, PDF.PROFIL_DEFAUT, PDF.CODE_ES
                        INTO L_LIBELLE_OLD, L_TOP_ACTIF_OLD, L_FORCE_TRAVAIL_OLD, L_FRAIS_ENVIRONNEMENT_OLD, L_COMMENTAIRE_OLD, L_CODDIR_OLD, L_PROFIL_DEFAUT_OLD, L_CODE_ES_OLD
                        FROM PROFIL_DOMFONC PDF
                        WHERE PROFIL_DOMFONC = P_PROFIL
                        
                        AND  TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = p_date_effet; --modif
                       -- AND TO_CHAR(DATE_EFFET,'YYYY') = p_date_effet;
                    END;
                -- *****************************************************************************************

                    IF(L_LIBELLE_OLD != p_libelle) THEN
                    dbms_output.put_line('Cas 1');
                            UPDATE PROFIL_DOMFONC SET
                            LIBELLE                = p_libelle,
													  TOP_ACTIF              = p_top_actif,
													  FORCE_TRAVAIL          = p_force_travail,
													  FRAIS_ENVIRONNEMENT	   = p_frais_environnement,
													  COMMENTAIRE            = p_commentaire,
													  CODDIR                 = p_coddir,
													  PROFIL_DEFAUT          = p_profil_defaut,
													  CODE_ES                = p_code_es
                            WHERE PROFIL_DOMFONC = p_profil
                            
                            AND  TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = p_date_effet; --modif
                           -- AND to_char(to_date(date_effet),'YYYY') = p_date_effet;
                           UPDATE PROFIL_DOMFONC SET
                            LIBELLE                = p_libelle
                          WHERE PROFIL_DOMFONC = p_profil;

                    ELSE
                    dbms_output.put_line('Cas 2');
                            UPDATE PROFIL_DOMFONC SET
                            LIBELLE                = p_libelle,
													  --DATE_EFFET             = TO_DATE(p_date_effet, 'MM/YYYY'),
													  TOP_ACTIF              = p_top_actif,
													  FORCE_TRAVAIL          = p_force_travail,
													  FRAIS_ENVIRONNEMENT	   = p_frais_environnement,
													  COMMENTAIRE            = p_commentaire,
													  CODDIR                 = p_coddir,
													  PROFIL_DEFAUT          = p_profil_defaut,
													  CODE_ES                = p_code_es
                            WHERE PROFIL_DOMFONC = p_profil
                            
                            AND TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') = p_date_effet;
                            --AND to_char(to_date(date_effet),'YYYY') = p_date_effet;
                    END IF;
                        L_USER := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
                        -- On loggue les champs dans la table Profil_domfonc_logs
                        MAJ_PROFIL_DOMFONC_LOGS(p_profil, p_date_effet, L_USER, 'TOP_ACTIF', L_TOP_ACTIF_OLD, p_top_actif, 'Modification Profil DOMFONC');
                        MAJ_PROFIL_DOMFONC_LOGS(p_profil, p_date_effet, L_USER, 'FORCE_TRAVAIL', TO_CHAR(L_FORCE_TRAVAIL_OLD), TO_CHAR(p_force_travail), 'Modification Profil DOMFONC');
                        MAJ_PROFIL_DOMFONC_LOGS(p_profil, p_date_effet, L_USER, 'FRAIS_ENVIRONNEMENT', L_FRAIS_ENVIRONNEMENT_OLD, p_frais_environnement, 'Modification Profil DOMFONC');
                        MAJ_PROFIL_DOMFONC_LOGS(p_profil, p_date_effet, L_USER, 'CODDIR', L_CODDIR_OLD, p_coddir, 'Modification Profil DOMFONC');
                        MAJ_PROFIL_DOMFONC_LOGS(p_profil, p_date_effet, L_USER, 'PROFIL_DEFAUT', L_PROFIL_DEFAUT_OLD, p_profil_defaut, 'Modification Profil DOMFONC');
                        MAJ_PROFIL_DOMFONC_LOGS(p_profil, p_date_effet, L_USER, 'CODE_ES', L_CODE_ES_OLD, p_code_es, 'Modification Profil DOMFONC');

                        pack_global.recuperer_message(21281,'%s1', p_profil, '%s2', p_date_effet, NULL, p_message);

            --END IF;  -- Fin si l_num_ligne = 0
        END IF; -- Fin si l_presence=0

      --EXCEPTION

      --   WHEN CODDIR_INTEGRITY THEN
        --    pack_global.recuperer_message(20505,'%s1', p_coddir, NULL,NULL, 'coddir', p_message);-- 20505 : Code Direction Inexistant
         --   raise_application_error( -20505, p_message);
        -- WHEN CODE_ES_EXP THEN
           --pack_global.recuperer_message(4614,'%s1', l_var, NULL, NULL, 'code_es', p_message);
           --raise_application_error( -20226, p_message) ;
          --WHEN OTHERS THEN
           --PACK_GLOBAL.RECUPERER_MESSAGE(21282,NULL, NULL, NULL, p_message);
           --raise_application_error( -20226, p_message) ;

      END;


   END UPDATE_PROFIL_DOMFONC;

-- *********************************************************************************
--       Procedure   Consultation  PROFIL DOMFONC
-- *********************************************************************************
  PROCEDURE SELECT_PROFIL_DOMFONC (p_profil                IN  PROFIL_DOMFONC.PROFIL_DOMFONC%TYPE,
                                   p_date_effet            IN  VARCHAR2,
                                   p_curprofil_domfonc     OUT profil_domfoncCurType
                                   ) IS

   BEGIN

        OPEN p_curprofil_domfonc FOR
        SELECT *
        FROM PROFIL_DOMFONC
        WHERE PROFIL_DOMFONC = p_profil
        
        AND  TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') =  p_date_effet; --modif
       -- AND TO_CHAR(TO_DATE(DATE_EFFET), 'YYYY') =  p_date_effet;

   END SELECT_PROFIL_DOMFONC;

-- *********************************************************************************
--       Procedure   AJAX - PROFIL DE DOMFONC - isValid Code ES
-- *********************************************************************************
    PROCEDURE isValidCodeEs ( p_code_es          IN  VARCHAR2,
                               p_userid          IN  VARCHAR2,
                               p_message         OUT VARCHAR2
                             ) IS

      l_msg VARCHAR2(1024);
      L_USER                  VARCHAR2 (30);
      l_presence              NUMBER;
      CODES_INTEGRITY     EXCEPTION;
      CAFI_LIST       VARCHAR2(32000);
      l_longueur NUMBER;

    BEGIN

        -- Positionner le nb de curseurs ==> 0
        -- Initialiser le message retour

        p_message := '';
        CAFI_LIST := pack_profil_fi.list_cafi(p_code_es);
        --select LENGTH(CAFI_LIST) into l_longueur from DUAL;
                 IF(CAFI_LIST is null) THEN
                    RAISE CODES_INTEGRITY;
                 END IF;
         

    EXCEPTION

        WHEN CODES_INTEGRITY THEN
        pack_global.recuperer_message(4614,'%s1', p_code_es, NULL, l_msg);
        p_message := l_msg;

    END isValidCodeEs;


END PACK_PROFIL_DOMFONC;

/