create or replace
PACKAGE     PACK_RESSOURCE_P AS

TYPE list_ress_View IS RECORD (
                                 ident        VARCHAR2(20) ,
                                 libel        VARCHAR2(500)
                              );

TYPE list_ress_ViewCurType IS REF CURSOR RETURN list_ress_View;

TYPE ressource_m_ViewType IS RECORD (ident RESSOURCE.ident%TYPE,
 flaglock   RESSOURCE.flaglock%TYPE,
 rnom       RESSOURCE.rnom%TYPE,
 rprenom    RESSOURCE.rprenom%TYPE,
 matricule  RESSOURCE.matricule%TYPE,
 icodimm    RESSOURCE.icodimm%TYPE,
 batiment   RESSOURCE.batiment%TYPE,
 etage      RESSOURCE.etage%TYPE,
 bureau     RESSOURCE.bureau%TYPE,
 rtel       RESSOURCE.rtel%TYPE,
 igg        RESSOURCE.IGG%TYPE
 );

TYPE personne_c_ViewType IS RECORD (rnom       TMP_PERSONNE.rnom%TYPE,
                                     rprenom    TMP_PERSONNE.rprenom%TYPE,
                                     matricule  TMP_PERSONNE.matricule%TYPE,
                                     icodimm    TMP_IMMEUBLE.ICODIMM%TYPE,
                                     batiment   TMP_PERSONNE.batiment%TYPE,
                                     etage      TMP_PERSONNE.etage%TYPE,
                                     bureau     TMP_PERSONNE.bureau%TYPE,
                                     rtel       TMP_PERSONNE.rtel%TYPE,
                                     igg        TMP_PERSONNE.IGG%TYPE
 );

TYPE personne_d_ViewType IS RECORD ( rnom        RESSOURCE.rnom%TYPE,
                                     rprenom    RESSOURCE.rprenom%TYPE,
                                     matricule  RESSOURCE.matricule%TYPE,
                                     igg        RESSOURCE.IGG%TYPE,
                                     ident      RESSOURCE.IDENT%TYPE,
                                     codsg      SITU_RESS.CODSG%TYPE
 );



TYPE ressource_s_ViewType IS RECORD (ident RESSOURCE.ident%TYPE,
 rnom       RESSOURCE.rnom%TYPE,
 rprenom    RESSOURCE.rprenom%TYPE,
 matricule  RESSOURCE.matricule%TYPE,
 coutot     VARCHAR2(13),
 flaglock   RESSOURCE.flaglock%TYPE,
 datsitu    VARCHAR2(10),
 datdep     VARCHAR2(10),
 cout       VARCHAR2(13),
 PRESTATION SITU_RESS.PRESTATION%TYPE,
 --filcode situ_ress.filcode%TYPE,
 soccode    SITU_RESS.soccode%TYPE,
 codsg      SITU_RESS.codsg%TYPE,
 igg        RESSOURCE.IGG%TYPE
 );

TYPE ressource_p_mCurType IS REF CURSOR RETURN ressource_m_ViewType;
TYPE personne_cCurType IS REF CURSOR RETURN personne_c_ViewType;
TYPE personne_dCurType IS REF CURSOR RETURN personne_d_ViewType;

TYPE ressource_p_sCurType IS REF CURSOR RETURN ressource_s_ViewType;
TYPE ressourceCurType IS REF CURSOR RETURN RESSOURCE%ROWTYPE;

TYPE t_array IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;

TRCLOG_FAILED_ID     NUMBER := -20001;   -- problè : erreur dans la gestion d'erreur !

FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array;

FUNCTION isMciObligatoire (p_codsg IN NUMBER) RETURN VARCHAR2;

 PROCEDURE isMciObligatoire ( p_codsg IN NUMBER,
 p_obligatoire OUT VARCHAR2,
 p_message OUT VARCHAR2 ) ;

-- QC 1321
-- retourne le mci par defaut soit du chef de projet ou du l identifiant forfait
-- pour le code prestation IFO ou SLT
-- Pour IFO on prend p_cpident
-- POur SLT on prend p_ident_forfait
 PROCEDURE getMciDefaut ( p_code_prestation IN VARCHAR2,
 p_ident_forfait IN NUMBER,
 p_cpident IN NUMBER,
 p_dateDebut IN VARCHAR2,
 p_dateFin IN VARCHAR2,
 p_modeContractuelInd OUT VARCHAR2,
 p_libMci OUT VARCHAR2,
 p_message OUT VARCHAR2 ) ;

 PROCEDURE insert_ressource_p (
                                 p_rnom                 IN RESSOURCE.rnom%TYPE,
                                 p_rprenom              IN RESSOURCE.rprenom%TYPE,
                                 p_soccode              IN SITU_RESS.soccode%TYPE,
                                 p_datsitu              IN VARCHAR2,
                                 p_datdep               IN VARCHAR2,
                                 p_prestation           IN SITU_RESS.PRESTATION%TYPE,
                                 p_codsg                IN VARCHAR2,
                                 p_cout                 IN VARCHAR2,
                                 p_cpident              IN VARCHAR2,
                                 p_dispo                IN VARCHAR2,
                                 p_rmcomp               IN VARCHAR2,
                                 --p_filcode IN situ_ress.filcode%TYPE,
                                 p_matricule            IN RESSOURCE.matricule%TYPE,
                                 p_rtel                 IN VARCHAR2,
                                 p_icodimm              IN VARCHAR2,
                                 p_batiment             IN RESSOURCE.batiment%TYPE,
                                 p_etage                IN RESSOURCE.etage%TYPE,
                                 p_bureau               IN RESSOURCE.bureau%TYPE,
                                 p_userid               IN VARCHAR2,
                                 p_rtype                IN RESSOURCE.rtype%TYPE,
                                 p_fident               IN VARCHAR2,
                                 p_modeContractuelInd   IN VARCHAR2,
                                 p_mci_calcule          IN VARCHAR2,
                                 p_igg                  IN RESSOURCE.IGG%TYPE,
                                 p_nbcurseur            OUT INTEGER,
                                 p_message              OUT VARCHAR2,
                                 p_ident                OUT VARCHAR2
 );


 PROCEDURE update_ressource_p (p_ident IN VARCHAR2,
 p_rnom IN RESSOURCE.rnom%TYPE,
 p_rprenom IN RESSOURCE.rprenom%TYPE,
 p_matricule IN RESSOURCE.matricule%TYPE,
 p_rtel IN VARCHAR2,
 p_icodimm IN VARCHAR2,
 p_batiment IN RESSOURCE.batiment%TYPE,
 p_etage IN RESSOURCE.etage%TYPE,
 p_bureau IN RESSOURCE.bureau%TYPE,
 p_flaglock IN NUMBER,
 p_userid IN VARCHAR2,
 p_rtype IN RESSOURCE.rtype%TYPE,
 p_igg  IN RESSOURCE.IGG%TYPE,
 p_nbcurseur OUT INTEGER,
 p_message OUT VARCHAR2
 );

 PROCEDURE verif_matricule_doublon ( p_ident        IN  VARCHAR2,
                                     p_userid       IN  VARCHAR2,
                                     p_matricule    IN VARCHAR2,
                                     p_igg          IN VARCHAR2,
                                     p_nom          IN VARCHAR2,
                                     p_prenom       IN VARCHAR2,
                                     p_rtype        IN VARCHAR2,
                                     p_confirm       OUT VARCHAR2,
                                     p_message       OUT VARCHAR2
                                    );


 PROCEDURE select_c_ressource_p (p_rnom IN RESSOURCE.rnom%TYPE,
 p_rprenom IN RESSOURCE.rprenom%TYPE,
 p_soccode IN SITU_RESS.soccode%TYPE,
 p_ident IN VARCHAR2,
 p_userid IN VARCHAR2,
 p_rtype IN RESSOURCE.rtype%TYPE,
 p_curressource IN OUT ressourceCurType,
 p_date_courante OUT VARCHAR2,
 p_matricule OUT VARCHAR2,
 p_id OUT VARCHAR2,
 p_codsg OUT VARCHAR2,
 p_nbcurseur OUT INTEGER,
 p_message OUT VARCHAR2
 );

 PROCEDURE select_m_ressource_p (p_rnom IN RESSOURCE.rnom%TYPE,
 p_rprenom IN RESSOURCE.rprenom%TYPE,
 p_ident IN VARCHAR2,
 p_userid IN VARCHAR2,
 p_rtype IN RESSOURCE.rtype%TYPE,
 p_curressource IN OUT ressource_p_mCurType,
 p_datsitu OUT VARCHAR2,
 p_nbcurseur OUT INTEGER,
 p_message OUT VARCHAR2
 );

 PROCEDURE select_s_ressource_p (p_rnom IN RESSOURCE.rnom%TYPE,
 p_rprenom IN RESSOURCE.rprenom%TYPE,
 p_ident IN VARCHAR2,
 p_userid IN VARCHAR2,
 p_rtype IN RESSOURCE.rtype%TYPE,
 p_curressource IN OUT ressource_p_sCurType,
 p_flag OUT VARCHAR2,
 p_nbcurseur OUT INTEGER,
 p_message OUT VARCHAR2
 );


 PROCEDURE select_ressource_p (p_ident IN VARCHAR2,
 p_userid IN VARCHAR2,
 p_curressource IN OUT ressource_p_mCurType,
 p_nbcurseur OUT INTEGER,
 p_message OUT VARCHAR2
 );


 PROCEDURE select_personne_col ( p_id_sequence IN VARCHAR2,
                                 p_userid IN VARCHAR2,
                                 p_curressource IN OUT personne_cCurType,
                                 p_nbcurseur OUT INTEGER,
                                 p_message OUT VARCHAR2
                                 );

 PROCEDURE select_ressource_double ( p_id_sequence IN VARCHAR2,
                                     p_userid IN VARCHAR2,
                                     p_curressource IN OUT list_ress_ViewCurType
                                     );

 PROCEDURE verif_homonyme (p_ident IN VARCHAR2,
 p_rnom IN RESSOURCE.rnom%TYPE,
 p_rprenom IN RESSOURCE.rprenom%TYPE,
 p_userid IN VARCHAR2,
 p_matricule OUT VARCHAR2,
 p_id OUT VARCHAR2,
 p_codsg OUT VARCHAR2,
 p_nbcurseur OUT INTEGER,
 p_message OUT VARCHAR2
 ) ;


 PROCEDURE maj_ressource_logs(p_ident IN RESSOURCE_LOGS.ident%TYPE,
 p_user_log IN RESSOURCE_LOGS.user_log%TYPE,
 p_table IN RESSOURCE_LOGS.nom_table%TYPE,
 p_colonne IN RESSOURCE_LOGS.colonne%TYPE,
 p_valeur_prec IN RESSOURCE_LOGS.valeur_prec%TYPE,
 p_valeur_nouv IN RESSOURCE_LOGS.valeur_nouv%TYPE,
 p_commentaire IN RESSOURCE_LOGS.commentaire%TYPE
 );


 PROCEDURE RECUP_LIB_MCI(p_mci IN VARCHAR2,
 p_lib_mci OUT VARCHAR2,
 p_message OUT VARCHAR2);

PROCEDURE LISTER_RESS_IGG(  p_igg       IN VARCHAR2,
                            p_matricule IN VARCHAR2,
                            p_debnom    IN VARCHAR2,
                            p_nomcont   IN VARCHAR2,
                            p_userid     IN VARCHAR2,
                            p_curseur  IN OUT list_ress_ViewCurType
                            );

PROCEDURE get_clone_principale (  p_matricule    IN  RESSOURCE.matricule%TYPE,
                                  p_igg          IN RESSOURCE.IGG%TYPE,
                                  p_rtype        IN RESSOURCE.rtype%TYPE,
                                  p_ident_retour OUT RESSOURCE.IDENT%TYPE,
                                  p_retour       OUT VARCHAR2,
                                  p_message      OUT VARCHAR2
                             );

PROCEDURE update_ress_prepa_recyclage (p_chemin_fichier        IN VARCHAR2,
                                       p_nom_fichier           IN VARCHAR2,
                                       p_id_batch IN TRAIT_BATCH.ID_TRAIT_BATCH%TYPE);

END Pack_Ressource_P;

/

create or replace PACKAGE BODY "PACK_RESSOURCE_P" AS

PROCEDURE get_clone_principale (  p_matricule    IN  RESSOURCE.matricule%TYPE,
                                  p_igg          IN RESSOURCE.IGG%TYPE,
                                  p_rtype        IN RESSOURCE.rtype%TYPE,
                                  p_ident_retour OUT RESSOURCE.IDENT%TYPE,
                                  p_retour       OUT VARCHAR2,
                                  p_message      OUT VARCHAR2
                             ) IS


    l_soccode               SITU_RESS.soccode%TYPE;
    l_ident_mere_ou_fille   RESSOURCE.IDENT%TYPE;
    l_presence              RESSOURCE.IDENT%TYPE;
    l_matricule             RESSOURCE.MATRICULE%TYPE;
    l_msg                   VARCHAR2(1024);

    BEGIN

        -- Initialisation
        p_retour := 'NON';

    -- TEST sur le matricule selon que la ressource est SG ou pas
    --si SSII
    IF  p_rtype = 'P' THEN

        -- SI IGG RENSEIGNE
        IF (p_igg is not null) THEN

            -- SI IGG  commence par un 9 alors nous sommes dans le cas d'un clone
            -- donc nous devons rechercher les informations de la ressource principale
            IF (SUBSTR(p_igg,1,1) ='9') THEN

                BEGIN

                    SELECT ident INTO l_ident_mere_ou_fille FROM RESSOURCE WHERE igg = TO_NUMBER('1'||SUBSTR(p_igg,2));
                    p_retour := 'OUI';
                    p_ident_retour := l_ident_mere_ou_fille;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        p_retour := 'NON';
                    WHEN OTHERS THEN
                        RAISE_APPLICATION_ERROR(-20997, SQLERRM);
                END;

            ELSIF (substr(p_igg,1,1) ='1') THEN

                -- on verifie si la ressource principale possède un clone
                 BEGIN

                    SELECT ident INTO l_ident_mere_ou_fille FROM RESSOURCE WHERE IGG = TO_NUMBER('9'||SUBSTR(p_igg,2));
                    p_retour := 'OUI';
                    p_ident_retour := l_ident_mere_ou_fille;

                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            p_retour := 'NON';
                        WHEN TOO_MANY_ROWS THEN
                            -- Il existe plusieurs clone associé a cette ressource.\nVeuillez contacter l'administrateur.
                            Pack_Global.recuperer_message(21258, NULL, NULL , NULL, l_msg);
                            RAISE_APPLICATION_ERROR(-20916, l_msg);

                        WHEN OTHERS THEN
                             RAISE_APPLICATION_ERROR(-20997, SQLERRM);

                 END;

            END IF;

        END IF;

        -- Clone non trouve sur igg
        -- Alors on recherche sur le matricule
        IF (p_matricule IS NOT NULL AND p_retour <> 'OUI') THEN

            -- cas d'une ressource principale
            IF  SUBSTR(p_matricule,1,1)= 'X' THEN

                -- on verifie si la ressource principale possède un clone
                BEGIN

                    SELECT ident INTO l_ident_mere_ou_fille FROM RESSOURCE
                    WHERE matricule = 'Y' || SUBSTR(p_matricule,2);
                    p_retour := 'OUI';
                    p_ident_retour := l_ident_mere_ou_fille;

                    EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        p_retour := 'NON';
                    WHEN TOO_MANY_ROWS THEN
                        -- Il existe plusieurs clone associé a cette ressource.\nVeuillez contacter l'administrateur.
                        Pack_Global.recuperer_message(21258, NULL, NULL , NULL, l_msg);
                        RAISE_APPLICATION_ERROR(-20916, l_msg);
                    WHEN OTHERS THEN
                        p_retour := 'NON';
                        RAISE_APPLICATION_ERROR(-20997, SQLERRM);
                END;

            -- CAS d'une ressource clone
            ELSIF(SUBSTR(p_matricule,1,1) ='Y') THEN

                BEGIN
                    SELECT ident INTO l_ident_mere_ou_fille FROM ressource
                    WHERE matricule = 'X'||SUBSTR(p_matricule,2);
                    p_retour := 'OUI';
                    p_ident_retour := l_ident_mere_ou_fille;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        p_retour := 'NON';
                    WHEN TOO_MANY_ROWS THEN
                        -- Il existe plusieurs clone associé a cette ressource.\nVeuillez contacter l'administrateur.
                        Pack_Global.recuperer_message(21258, NULL, NULL , NULL, l_msg);
                        RAISE_APPLICATION_ERROR(-20916, l_msg);

                    WHEN OTHERS THEN
                        p_retour := 'NON';
                        RAISE_APPLICATION_ERROR(-20997, SQLERRM);
                END;

            END IF;

        END IF;

    END IF;

    EXCEPTION

        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);


END get_clone_principale;

-- QC 1321
-- Verifie si le code MCI est obligatoire pour la direction
PROCEDURE isMciObligatoire ( p_codsg       IN  NUMBER,
                             p_obligatoire OUT VARCHAR2,
                             p_message     OUT VARCHAR2 ) IS



    l_msg           VARCHAR2(1024);
    l_exist         NUMBER;
    t_coddir        STRUCT_INFO.CODDIR%TYPE;
    t_codaction     LIGNE_PARAM_BIP.code_action%TYPE;
    l_code_action   LIGNE_PARAM_BIP.CODE_ACTION%TYPE;
    l_code_version  LIGNE_PARAM_BIP.CODE_VERSION%TYPE;

    t_table         t_array;

    CURSOR c_coddir IS
        SELECT s.CODDIR FROM STRUCT_INFO s
        WHERE s.CODSG = p_codsg;

    CURSOR c_param IS
        SELECT code_action
        FROM DATE_EFFET
        WHERE code_action = l_code_action
            AND code_version = l_code_version;

    CURSOR c_valeur IS
        SELECT VALEUR, SEPARATEUR FROM LIGNE_PARAM_BIP
        WHERE code_action = l_code_action
            AND code_version = l_code_version
            AND ACTIF = 'O'
        ORDER BY num_ligne ASC;
    t_valeur    c_valeur%ROWTYPE;

    t_obligatoire   VARCHAR2(2);

BEGIN

    -- Initialisation
    p_message       := '';
    t_obligatoire   := ' ';
    l_code_action   := 'OBLIGATION-MCI';
    l_code_version  := 'DEFAUT';

    OPEN c_coddir;
    FETCH c_coddir INTO t_coddir;
    IF c_coddir%NOTFOUND THEN

        Pack_Global.recuperer_message(21080, '%s1',TO_CHAR(p_codsg),'', l_msg);
        p_message := l_msg ;

    END IF;
    CLOSE c_coddir;

    -- Verifier que la date effet existe avant d'aller chercher les lignes
    OPEN c_param;
    FETCH c_param INTO t_codaction;

    -- Si le parametre n est pas trouve alors le mci n est pas obligatoire.
    IF c_param%NOTFOUND THEN

        t_obligatoire := 'N';

    ELSE
        -- Si le parametre n est pas trouve alors le mci n est pas obligatoire.
        OPEN c_valeur;
        FETCH c_valeur INTO t_valeur;
        IF c_valeur%NOTFOUND THEN

            t_obligatoire := 'N';

        ELSE

            -- Parcours des differents code direction
            -- Si code direction trouve alors le MCI est obligatoire.
            t_obligatoire   := 'N';
            t_table := SPLIT(t_valeur.VALEUR,t_valeur.SEPARATEUR);
            FOR I IN 1..t_table.COUNT LOOP

                IF (TO_NUMBER(t_table(I)) = t_coddir ) THEN

                    t_obligatoire := 'O';
                    EXIT;

                END IF;

            END LOOP;

        END IF;

        CLOSE c_valeur;

    END IF;

    CLOSE c_param;

    p_obligatoire := t_obligatoire ;

    EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR( -20997, SQLERRM);

END isMciObligatoire;

-- QC 1321
-- retourne le mci par defaut soit du chef de projet ou du l identifiant forfait
--  qui ont un type de ressource 'E' ou 'F'
-- pour le code prestation IFO ou SLT
-- Pour IFO on prend p_cpident
-- POur SLT on prend p_ident_forfait
PROCEDURE getMciDefaut ( p_code_prestation    IN VARCHAR2,
                         p_ident_forfait      IN NUMBER,
                         p_cpident            IN NUMBER,
                         p_dateDebut          IN VARCHAR2,
                         p_dateFin            IN VARCHAR2,
                         p_modeContractuelInd OUT VARCHAR2,
                         p_libMci             OUT VARCHAR2,
                         p_message OUT VARCHAR2 ) IS

     l_msg      VARCHAR2(1024);
     l_exist    NUMBER;
     t_coddir   STRUCT_INFO.CODDIR%TYPE;
     t_ident    SITU_RESS.IDENT%TYPE;
    t_dateFin   VARCHAR2(50);

    -- Controle du type de la ressource : E ou F
    CURSOR c_type IS
        SELECT r.RTYPE
        FROM RESSOURCE r
        WHERE r.IDENT = t_ident
            AND r.RTYPE IN ('E','F') ;

    t_type  c_type%ROWTYPE;

    -- cas priorite 1 : situation identique (date)
    CURSOR c_situations_1 IS
        SELECT s.MODE_CONTRACTUEL_INDICATIF, m.LIBELLE, s.DATSITU, s.DATDEP
        FROM SITU_RESS s, mode_contractuel m
        WHERE s.IDENT = t_ident
            AND m.CODE_CONTRACTUEL = s.MODE_CONTRACTUEL_INDICATIF
            AND s.DATSITU = TO_DATE(p_dateDebut,'MM/YYYY')
            AND s.DATDEP = t_dateFin
            AND m.TOP_ACTIF = 'O' ;

    t_situations_1 c_situations_1%ROWTYPE;

    -- cas priorite 2 : situation englobante
    CURSOR c_situations_2 IS
        SELECT s.MODE_CONTRACTUEL_INDICATIF, m.LIBELLE, s.DATSITU, s.DATDEP
        FROM SITU_RESS s, mode_contractuel m
        WHERE s.IDENT = t_ident
            AND m.CODE_CONTRACTUEL = s.MODE_CONTRACTUEL_INDICATIF
            AND s.DATSITU <= TO_DATE(p_dateDebut,'MM/YYYY')
            AND NVL(s.DATDEP,TO_DATE('01/01/3000','DD/MM/YYYY')) >= TO_DATE(NVL(t_dateFin,'01/01/3000'),'DD/MM/YYYY')
            AND m.TOP_ACTIF = 'O' ;

    t_situations_2 c_situations_2%ROWTYPE;

    -- cas priorite 3 : situation anterieur
    CURSOR c_situations_3 IS
        SELECT s.MODE_CONTRACTUEL_INDICATIF, m.LIBELLE, s.DATSITU, s.DATDEP
        FROM SITU_RESS s, mode_contractuel m
        WHERE s.IDENT = t_ident
            AND m.CODE_CONTRACTUEL = s.MODE_CONTRACTUEL_INDICATIF
            AND s.DATDEP <= TO_DATE(p_dateDebut,'MM/YYYY')
            AND m.TOP_ACTIF = 'O'
        ORDER BY s.DATSITU DESC ;

    t_situations_3 c_situations_3%ROWTYPE;

    -- cas priorite 4 : situation ulterieur
    CURSOR c_situations_4 IS
        SELECT s.MODE_CONTRACTUEL_INDICATIF, m.LIBELLE, s.DATSITU, s.DATDEP
        FROM SITU_RESS s, mode_contractuel m
        WHERE s.IDENT = t_ident
            AND m.CODE_CONTRACTUEL = s.MODE_CONTRACTUEL_INDICATIF
            AND s.DATSITU >= TO_DATE(p_dateDebut,'MM/YYYY')
            AND m.TOP_ACTIF = 'O'
            ORDER BY s.DATSITU ASC ;

    t_situations_4 c_situations_4%ROWTYPE;
BEGIN

    p_message := '';
    IF (NVL(length(TRIM(p_dateFin)),0) > 1 ) THEN
    --IF ( p_dateFin = '' ) THEN
        t_dateFin := p_dateFin;
    ELSE
        t_dateFin := null;
    END IF;
  -- t_dateFin := null;

    IF p_code_prestation = 'IFO' THEN
        t_ident := p_cpident;
    ELSIF p_code_prestation = 'SLT' THEN
        t_ident := p_ident_forfait;
    ELSE
        NULL;
    END IF;

    OPEN c_type;
    FETCH c_type INTO t_type;

    -- On ne prend que les types 'E' ou 'F'
    IF c_type%FOUND THEN

        IF p_code_prestation = 'SLT' OR p_code_prestation = 'IFO' THEN

            OPEN c_situations_1;
            FETCH c_situations_1 INTO t_situations_1;

            IF c_situations_1%FOUND THEN

                p_modeContractuelInd := t_situations_1.MODE_CONTRACTUEL_INDICATIF ;
                p_libMci             := t_situations_1.LIBELLE ;

            ELSE
                CLOSE  c_situations_1;

                OPEN c_situations_2;
                FETCH c_situations_2 INTO t_situations_2;
                IF c_situations_2%FOUND THEN

                    p_modeContractuelInd := t_situations_2.MODE_CONTRACTUEL_INDICATIF ;
                    p_libMci             := t_situations_2.LIBELLE ;

                ELSE
                    CLOSE c_situations_2;

                    OPEN c_situations_3;
                    FETCH c_situations_3 INTO t_situations_3;
                    IF c_situations_3%FOUND THEN

                            p_modeContractuelInd := t_situations_3.MODE_CONTRACTUEL_INDICATIF ;
                            p_libMci             := t_situations_3.LIBELLE ;

                    ELSE
                        CLOSE c_situations_3;


                        OPEN c_situations_4;
                        FETCH c_situations_4 INTO t_situations_4;
                        IF c_situations_4%FOUND THEN

                            p_modeContractuelInd := t_situations_4.MODE_CONTRACTUEL_INDICATIF ;
                            p_libMci             := t_situations_4.LIBELLE ;

                        END IF;
                        CLOSE c_situations_4;
                    END IF;
                END IF;

            END IF;


        END IF;

    END IF;

    CLOSE c_type;

END getMciDefaut;

   PROCEDURE insert_ressource_p (
                                 p_rnom                 IN RESSOURCE.rnom%TYPE,
                                 p_rprenom              IN RESSOURCE.rprenom%TYPE,
                                 p_soccode              IN SITU_RESS.soccode%TYPE,
                                 p_datsitu              IN VARCHAR2,
                                 p_datdep               IN VARCHAR2,
                                 p_prestation           IN SITU_RESS.PRESTATION%TYPE,
                                 p_codsg                IN VARCHAR2,
                                 p_cout                 IN VARCHAR2,
                                 p_cpident              IN VARCHAR2,
                                 p_dispo                IN VARCHAR2,
                                 p_rmcomp               IN VARCHAR2,
                                 --p_filcode IN situ_ress.filcode%TYPE,
                                 p_matricule            IN RESSOURCE.matricule%TYPE,
                                 p_rtel                 IN VARCHAR2,
                                 p_icodimm              IN VARCHAR2,
                                 p_batiment             IN RESSOURCE.batiment%TYPE,
                                 p_etage                IN RESSOURCE.etage%TYPE,
                                 p_bureau               IN RESSOURCE.bureau%TYPE,
                                 p_userid               IN VARCHAR2,
                                 p_rtype                IN RESSOURCE.rtype%TYPE,
                                 p_fident               IN VARCHAR2,
                                 p_modeContractuelInd   IN VARCHAR2,
                                 p_mci_calcule          IN VARCHAR2,
                                 p_igg                  IN RESSOURCE.IGG%TYPE,
                                 p_nbcurseur            OUT INTEGER,
                                 p_message              OUT VARCHAR2,
                                 p_ident                OUT VARCHAR2
                                 ) IS

      l_msg           VARCHAR2(1024);
      l_ident         RESSOURCE.ident%TYPE;
      l_fident        SITU_RESS.fident%TYPE;
      l_rnom         RESSOURCE.rnom%TYPE;
      l_rprenom         RESSOURCE.rprenom%TYPE;
      l_matricule     VARCHAR2(7);
      l_nb NUMBER(7);
      l_test NUMBER(1);
      l_rtype         RESSOURCE.rtype%TYPE;
      ldatsitu        VARCHAR2(10);
      ldatdep          VARCHAR2(10);
      l_dsocfer       VARCHAR2(20);
      l_date_courante VARCHAR2(20);
      l_prest         PRESTATION.PRESTATION%TYPE;
      l_menu          VARCHAR2(255);
      l_ges           NUMBER(3);
      l_codsg         SITU_RESS.codsg%TYPE;
      l_idarpege      VARCHAR2(255);
      l_topfer        STRUCT_INFO.topfer%TYPE;
      l_habilitation VARCHAR2(10);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);
       l_user        RESSOURCE_LOGS.user_log%TYPE;
       l_mode_contractuel_ind VARCHAR2(3);
       l_count INTEGER;

      t_ident_clone RESSOURCE.ident%TYPE;
      p_clone          VARCHAR2(5);

      v_rnom        RESSOURCE.rnom%TYPE;
      v_rprenom     RESSOURCE.rprenom%TYPE;
      v_rtype       RESSOURCE.rtype%TYPE;
      v_matricule   RESSOURCE.matricule%TYPE;
      v_igg         RESSOURCE.igg%TYPE;

   BEGIN

      -- La regle de gestion 9.5.5 n'est pas suivie, gestion des utilisateur.
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';


      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

      -- Calcul de la nouvelle valeur de ident

      BEGIN
         SELECT MAX(ident)
         INTO l_ident
         FROM RESSOURCE;
--         WHERE  ident < 15000;

-- Clause Where en plus pour les tests a voir plus tard.


      EXCEPTION

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;
      l_ident := l_ident +1;
      l_menu := Pack_Global.lire_globaldata(p_userid).menutil;

      -- la date d'arrivée d'une ressource doit être le 1er jour du mois qu'a saisi l'utilisateur
         ldatsitu := TO_CHAR(TO_DATE(p_datsitu,'mm/yyyy'),'yyyymm')||'01';

      -- date de départ d'une ressource
         ldatdep := TO_CHAR(TO_DATE(p_datdep,'dd/mm/yyyy'),'yyyymmdd');

--     ###################  -- TEST : soccode existe et societe non fermee si

     IF l_menu != 'DIR' THEN

     ---------------------------------------------------------------------------
     -- La date de valeur est toujours inférieure à la date de départ
     ---------------------------------------------------------------------------
    IF (p_datdep IS NOT NULL) THEN

    IF ldatsitu>ldatdep THEN
        Pack_Global.recuperer_message(20227, NULL, NULL, 'DATSITU', l_msg);
          RAISE_APPLICATION_ERROR(-20227, l_msg);
        p_message := l_msg;
    END IF;
    END IF;

    BEGIN
           SELECT TO_CHAR(socfer,'yyyymmdd')
           INTO l_dsocfer
           FROM SOCIETE
           WHERE soccode = p_soccode;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
              Pack_Global.recuperer_message(20225, '%s1', p_soccode, 'SOCCODE', l_msg);
              RAISE_APPLICATION_ERROR(-20225, l_msg);

         WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      SELECT TO_CHAR(SYSDATE,'yyyymmdd')
      INTO l_date_courante
      FROM DUAL;

      IF l_dsocfer <= l_date_courante THEN
             Pack_Global.recuperer_message(20225, '%s1', p_soccode, 'SOCCODE', l_msg);
             RAISE_APPLICATION_ERROR(-20225, l_msg);
      END IF;
    END IF;

      -- TEST : PRESTATION = MO ou GRA

      IF p_prestation != 'MO' AND p_prestation != 'GRA' AND p_prestation != 'IFO'  THEN
         IF (p_cout = ',00' OR p_cout = '0,00' OR p_cout IS NULL) AND (p_soccode <> 'SG..') THEN
            Pack_Global.recuperer_message(20247, NULL, NULL, 'COUT', l_msg);
            RAISE_APPLICATION_ERROR(-20247, l_msg);
         END IF;
      END IF;

      -- TEST : 0< DISPO < 7

      IF (TO_NUMBER(p_dispo) < 0) OR (TO_NUMBER(p_dispo) > 7) THEN
         Pack_Global.recuperer_message(20248, NULL, NULL, 'DISPO', l_msg);
         RAISE_APPLICATION_ERROR(-20248, l_msg);
      END IF;

      -- TEST : Il doit exister ds cout_pres 1codprest pour l'annee d'arrive de la personne


      -- Test TOPFER de codsg si menutil = DIR

      IF l_menu != 'DIR' THEN

    BEGIN
         SELECT PRESTATION
         INTO l_prest
         FROM PRESTATION
         WHERE    UPPER(top_actif)='O'
         AND PRESTATION = p_prestation;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            Pack_Global.recuperer_message(20246, '%s1', p_prestation, 'PRESTATION', l_msg);
            RAISE_APPLICATION_ERROR(-20246, l_msg );

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997,SQLERRM);
      END;

         BEGIN
            SELECT topfer
            INTO   l_topfer
            FROM   STRUCT_INFO
            WHERE  codsg = TO_NUMBER(p_codsg);

         EXCEPTION

            WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR(-20203, l_msg);

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;

         IF l_topfer = 'F' THEN
             Pack_Global.recuperer_message(20274, NULL, NULL, NULL, l_msg);
             RAISE_APPLICATION_ERROR(-20274, l_msg);
         END IF;

      END IF;

      -- Teste la validite de la valeur de p_codsg

      IF TO_NUMBER(p_codsg) <= 100000 THEN
         Pack_Global.recuperer_message(20223, '%s1', p_codsg, 'CODSG', l_msg);
         RAISE_APPLICATION_ERROR(-20223, l_msg);
      END IF;

      -- ====================================================================
      -- 7/02/2001 : Test appartenance du DPG au périmètre de l'utilisateur
      -- ====================================================================
         l_habilitation := Pack_Habilitation.fhabili_me( p_codsg,p_userid   );
    IF l_habilitation='faux' THEN
        -- Vous n'êtes pas habilité à ce DPG 20364
        Pack_Global.recuperer_message(20364, '%s1', 'à ce DPG', 'CODSG', l_msg);
                RAISE_APPLICATION_ERROR(-20364, l_msg);
    END IF;

    -- test mode contractuel sauf pour les mci calcule
        IF (  p_soccode != 'SG..' AND NVL(p_mci_calcule,'-1') != 'O') THEN

               BEGIN
                   SELECT code_contractuel
                   INTO l_mode_contractuel_ind
                   FROM mode_contractuel
                   WHERE code_contractuel = p_modeContractuelInd
                   and top_actif = 'O'
                   and (type_ressource = p_rtype
                   or type_ressource = '*');
               EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      Pack_Global.recuperer_message( 21196, null, null, null, l_msg);
                      RAISE_APPLICATION_ERROR(-20226, l_msg);
                   WHEN OTHERS THEN
                      RAISE_APPLICATION_ERROR( -20997, SQLERRM);
               END;

        END IF;
 --   END IF;

      -- TEST pour savoir si le champ cpident existe

      IF p_cpident IS NOT NULL THEN
         BEGIN

            -- TEST sur l'existence de la ressource

            SELECT rtype
            INTO l_rtype
            FROM RESSOURCE
            WHERE ident = TO_NUMBER(p_cpident);

         EXCEPTION

            WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20226, '%s1', p_cpident, 'CPIDENT', l_msg);
               RAISE_APPLICATION_ERROR(-20226, l_msg);

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;
    END IF;

    -- TD 652 TEST : fident existe @../source/plsql/tp/ressource_ecart.sql un forfait F ou E
    IF p_fident IS NOT NULL THEN
      BEGIN
          SELECT ident
          INTO l_fident
          FROM RESSOURCE
          WHERE ident = TO_NUMBER(p_fident)
          AND (rtype='F' OR rtype='E');

      EXCEPTION

           WHEN NO_DATA_FOUND THEN
             Pack_Global.recuperer_message( 21112, '%s1', p_fident, 'FIDENT', l_msg);
             RAISE_APPLICATION_ERROR(-20226, l_msg);

           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;
     END IF;

    -- TEST sur le matricule selon que la ressource est SG ou pas - Sauf pour les IFO et GRA
    /* yni
    IF p_prestation <> 'IFO' AND p_prestation <> 'GRA' THEN

        -- test d'unicite
        BEGIN
                SELECT rnom,rprenom,ident INTO l_rnom,l_rprenom,l_ident
                FROM RESSOURCE WHERE matricule = p_matricule
                AND EXISTS ( SELECT codsg FROM SITU_RESS
                     WHERE ident = RESSOURCE.ident
                     AND   PRESTATION <> 'IFO' AND PRESTATION <> 'GRA'
                     AND   datsitu IN (  SELECT MAX(datsitu)
                                         FROM SITU_RESS
                                         WHERE ident = RESSOURCE.ident
                                        )
                   );
                Pack_Global.recuperer_message(20916, '%s1', p_matricule, '%s2', l_rnom || ' ' || l_rprenom,'%s3', TO_CHAR(l_ident),'MATRICULE', l_msg);
                RAISE_APPLICATION_ERROR(-20916, l_msg);
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      NULL;
                      -- cas des matricules en doublon
                      WHEN TOO_MANY_ROWS THEN
                      Pack_Global.recuperer_message(20917, NULL,NULL,'MATRICULE', l_msg);
                RAISE_APPLICATION_ERROR(-20917, l_msg);
                    WHEN OTHERS THEN
                      RAISE_APPLICATION_ERROR( -20997, SQLERRM);
            END;
        */
        --si SSII
        IF  p_soccode <> 'SG..' THEN

            -- Le matricule n'est plus obligatoire
            IF p_matricule IS NOT NULL THEN
                -- matricule doit etre sur 7 caracteres
                IF  LENGTH(p_matricule) <> 7 THEN
                    -- le matricule doit etre sur 7 caracteres !
                        Pack_Global.recuperer_message(20915, NULL, NULL,'MATRICULE', l_msg);
                        RAISE_APPLICATION_ERROR(-20915, l_msg);

                END IF;

                -- 6 derniers car non numeriques
                IF  SUBSTR(p_matricule,1,1)= 'X' THEN
                    BEGIN
                        SELECT TO_NUMBER(SUBSTR(p_matricule,2,6)) INTO l_matricule FROM dual;
                        EXCEPTION
                        WHEN OTHERS THEN
                        -- Le format du MATRICULE est incorrect.
                        Pack_Global.recuperer_message(21261, NULL, NULL, 'MATRICULE', l_msg);
                            RAISE_APPLICATION_ERROR(-20913, l_msg);
                    END;
                ELSE
                    -- 1er car = Y -> tests
                    IF SUBSTR(p_matricule,1,1)= 'Y' THEN

/* BSA 07082012
                         BEGIN
                            SELECT 1 INTO l_test FROM RESSOURCE
                            WHERE matricule = ('X' || SUBSTR(p_matricule,2,6))
                            AND UPPER(rnom)= UPPER(p_rnom)
                            AND UPPER(rprenom)=UPPER(p_rprenom);
                            EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                            --'le matricule d'une ressource SSII doit commencer par X'
                            Pack_Global.recuperer_message(20914, NULL, NULL, 'MATRICULE', l_msg);
                                RAISE_APPLICATION_ERROR(-20914, l_msg);
                                -- cas des matricules en doublon
                                      WHEN TOO_MANY_ROWS THEN
                                      NULL ;
                            END;

*/

                            BEGIN
                            SELECT TO_NUMBER(SUBSTR(p_matricule,2,6)) INTO l_matricule FROM dual;
                            EXCEPTION
                            WHEN OTHERS THEN
                            -- 'le matricule commence par la letttre Y et se poursuit par 6 chiffres '
                            Pack_Global.recuperer_message(20918, NULL, NULL, 'MATRICULE', l_msg);
                                RAISE_APPLICATION_ERROR(-20918, l_msg);
                            END;

                    ELSE     --'le matricule d'une ressource SSII doit commencer par X'

                        Pack_Global.recuperer_message(20914, NULL, NULL, 'MATRICULE', l_msg);
                            RAISE_APPLICATION_ERROR(-20914, l_msg);
                        END IF;

                END IF;

            END IF;

        END IF;
    --END IF;


    --si SG
    IF p_soccode = 'SG..' THEN
            --kha 14/05/2004 test s'applique aussi au matricule SG
        IF  LENGTH(p_matricule) <> 7 THEN
            -- le matricule doit etre saisi sur 7 caracteres !
                Pack_Global.recuperer_message(20913, NULL, NULL,'MATRICULE', l_msg);
                RAISE_APPLICATION_ERROR(-20913, l_msg);

        END IF;
            --que des numeriques
            BEGIN
--            SELECT LPAD(p_matricule,7,'0') INTO l_matricule FROM dual;
            SELECT LPAD(p_matricule,7,'0'), TO_NUMBER(p_matricule) INTO l_matricule, l_nb FROM dual;
            EXCEPTION
            WHEN OTHERS THEN
            -- 'le matricule est composé de 7 chiffres'
            Pack_Global.recuperer_message(20913, NULL, NULL, 'MATRICULE', l_msg);
                RAISE_APPLICATION_ERROR(-20913, l_msg);
                END;
    END IF;

         /*YNI FDT 970 test pour autoriser tous type de ressource existant en BIP
         -- TEST pour savoir si cette ressource est une prestation ou un agent SG
         IF (l_rtype != 'P')  AND (l_rtype IS NOT NULL) THEN
            Pack_Global.recuperer_message(20218, NULL, NULL, 'CPIDENT', l_msg);
            RAISE_APPLICATION_ERROR(-20218, l_msg);
         END IF;
         */

      -- INSERTION
      --YNI
      IF l_menu != 'DIR' THEN
           BEGIN
                SELECT rnom,rprenom,ident INTO l_rnom,l_rprenom,l_ident
                FROM RESSOURCE WHERE matricule = p_matricule;
                Pack_Global.recuperer_message(20916, '%s1', p_matricule, '%s2', l_rnom || ' ' || l_rprenom,'%s3', TO_CHAR(l_ident),'MATRICULE', l_msg);
                RAISE_APPLICATION_ERROR(-20916, l_msg);
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      NULL;
                      -- cas des matricules en doublon
                      WHEN TOO_MANY_ROWS THEN
                      Pack_Global.recuperer_message(20917, NULL,NULL,'MATRICULE', l_msg);
                      RAISE_APPLICATION_ERROR(-20917, l_msg);
                    WHEN OTHERS THEN
                      RAISE_APPLICATION_ERROR( -20997, SQLERRM);
            END;
      END IF;
      --YNI

      BEGIN
         INSERT INTO RESSOURCE (rnom,
                                rprenom,
                                ident,
                                rtype,
                                icodimm,
                                matricule,
                                igg,
                                batiment,
                                etage,
                                bureau,
                                rtel
                               )
         VALUES (UPPER(p_rnom),
                 UPPER(p_rprenom),
                 l_ident,
                 'P',
                 p_icodimm,
                 p_matricule,
                 p_igg,
                 p_batiment,
                 p_etage,
                 p_bureau,
                 p_rtel
                );


             -- On loggue le nom, prenom et matricule dans la table ressource
            Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'RESSOURCE', 'Nom', NULL, UPPER(p_rnom), 'Création de la ressource');
            Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'RESSOURCE', 'Prénom', NULL, UPPER(p_rprenom), 'Création de la ressource');
            Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'RESSOURCE', 'Type', NULL, 'P', 'Création de la ressource');
            Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'RESSOURCE', 'Matricule', NULL, p_matricule, 'Création de la ressource');
            Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'RESSOURCE', 'Igg', NULL, p_igg, 'Création de la ressource');




      EXCEPTION

         WHEN DUP_VAL_ON_INDEX THEN

            -- msg : 'ressource deja existante'
            Pack_Global.recuperer_message(20219, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20219, l_msg );

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      -- Recherche du clone ou ressource principale
      BEGIN
          GET_CLONE_PRINCIPALE (  p_matricule, p_igg, p_rtype, t_ident_clone, p_clone, l_msg );

      EXCEPTION
          WHEN OTHERS THEN
              -- Il existe plusieurs clone associé a cette ressource.\nVeuillez contacter l'administrateur.
              Pack_Global.recuperer_message(21258, NULL, NULL , NULL, l_msg);
              RAISE_APPLICATION_ERROR(-20916, l_msg);
      END;



      IF p_clone = 'OUI' THEN

            -- Mise a jour de la ressource clone
            -- On récupère les valeurs précédentes du clone pour les logs
            SELECT rnom, rprenom, rtype, matricule, igg
            INTO v_rnom, v_rprenom, v_rtype, v_matricule, v_igg
            FROM RESSOURCE
            WHERE ident  = TO_NUMBER(t_ident_clone);

            UPDATE RESSOURCE SET rnom      = UPPER(p_rnom),
                                 rprenom   = UPPER(p_rprenom),
                                 icodimm   = p_icodimm,
                                 batiment  = p_batiment,
                                 etage     = p_etage,
                                 bureau    = p_bureau,
                                 rtel      = p_rtel
            WHERE ident  = TO_NUMBER(t_ident_clone);

            -- On loggue le nom, prenom et matricule, igg dans la table ressource
            Pack_Ressource_P.maj_ressource_logs(t_ident_clone, l_user, 'RESSOURCE', 'Nom', v_rnom, p_rnom, 'Modification de la ressource clone');
            Pack_Ressource_P.maj_ressource_logs(t_ident_clone, l_user, 'RESSOURCE', 'Prénom', v_rprenom, p_rprenom, 'Modification de la ressource clone');

            -- Mise a jour du matricule
            IF p_matricule IS NOT NULL THEN

                IF ( SUBSTR(p_matricule,1,1) = 'Y' ) THEN

                    UPDATE RESSOURCE SET matricule = 'X' ||SUBSTR(p_matricule,2)
                    WHERE ident  = TO_NUMBER(t_ident_clone);

                    Pack_Ressource_P.maj_ressource_logs(t_ident_clone, l_user, 'RESSOURCE', 'Matricule', v_matricule, 'X'|| SUBSTR(p_matricule,2), 'Modification de la ressource clone');
                ELSE

                    UPDATE RESSOURCE SET matricule = 'Y' ||SUBSTR(p_matricule,2)
                    WHERE ident  = TO_NUMBER(t_ident_clone);

                    Pack_Ressource_P.maj_ressource_logs(t_ident_clone, l_user, 'RESSOURCE', 'Matricule', v_matricule, 'Y'|| SUBSTR(p_matricule,2), 'Modification de la ressource clone');

                END IF;

            ELSE

                UPDATE RESSOURCE SET matricule = NULL
                WHERE ident  = TO_NUMBER(t_ident_clone);

                Pack_Ressource_P.maj_ressource_logs(t_ident_clone, l_user, 'RESSOURCE', 'Matricule', v_matricule, NULL, 'Modification de la ressource clone');

            END IF;

      END IF;


      BEGIN

         INSERT INTO SITU_RESS (ident,
                                datsitu,
                                soccode,
                                codsg,
                                cout,
                                --filcode,
                                PRESTATION,
                                cpident,
                                dispo,
                                --rmcomp,
                                datdep,
                                fident,
                                mode_contractuel_indicatif
                               )
         VALUES (l_ident,
                 TO_DATE(ldatsitu,'yyyymmdd'),
                 p_soccode,
                 TO_NUMBER( p_codsg),
                 TO_NUMBER( p_cout,'FM9999999999D00'),
                 --p_filcode,
                 p_prestation,
                 TO_NUMBER(p_cpident),
                 TO_NUMBER(p_dispo,'FM9D9'),
                 --NVL(TO_NUMBER(p_rmcomp),0),
                 TO_DATE(ldatdep,'yyyymmdd'),
                 TO_NUMBER(p_fident),
                 p_modeContractuelInd
                );


        -- On loggue le nom, prenom et matricule  dans la table situ_ress
        Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'SITU_RESS', 'Datsitu', NULL, ldatsitu, 'Création de la situation');
        Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'SITU_RESS', 'Datdep', NULL, ldatdep, 'Création de la situation');
        Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'SITU_RESS', 'Societe', NULL, p_soccode, 'Création de la situation');
        Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'SITU_RESS', 'DPG', NULL, p_codsg, 'Création de la situation');
        --PPM 57823 : tracer cout unitaire
        Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'SITU_RESS', 'Coût unitaire', NULL, p_cout, 'Création de la situation');
        Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'SITU_RESS', 'Prestation', NULL, p_prestation, 'Création de la situation');
        if(p_prestation='SLT')THEN
            Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'SITU_RESS', 'Ident Forfait', NULL, p_fident, 'Création de la situation');
        END IF;
        Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'SITU_RESS', 'Chet de projet', NULL, p_cpident, 'Création de la situation');
        Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'SITU_RESS', 'Disponibilité', NULL, p_dispo, 'Création de la situation');
        Pack_Ressource_P.maj_ressource_logs(l_ident, l_user, 'SITU_RESS', 'Mode contractuel indicatif', NULL, p_modeContractuelInd, 'Création de la situation');


          IF(p_soccode='SG..')THEN
                       Pack_Global.recuperer_message(21052, '%s1', p_rnom ||' '|| p_rprenom ,'%s2',TO_CHAR(l_ident), NULL, l_msg);
                     p_message := l_msg;
         ELSE
                       Pack_Global.recuperer_message(21053, '%s1', p_rnom ||' '|| p_rprenom ,'%s2',TO_CHAR(l_ident), NULL, l_msg);
                     p_message := l_msg;
          END IF;

              p_ident := l_ident;

      EXCEPTION

         WHEN DUP_VAL_ON_INDEX THEN

            -- 'la ressource existe deja'

            Pack_Global.recuperer_message(20219, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20219, l_msg );

         WHEN referential_integrity THEN

            -- habiller le msg erreur

            Pack_Global.recuperation_integrite(-2291);

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

  END insert_ressource_p;


   PROCEDURE update_ressource_p (p_ident     IN  VARCHAR2,
                                 p_rnom      IN  RESSOURCE.rnom%TYPE,
                                 p_rprenom   IN  RESSOURCE.rprenom%TYPE,
                                 p_matricule IN  RESSOURCE.matricule%TYPE,
                                 p_rtel      IN  VARCHAR2,
                                 p_icodimm   IN  VARCHAR2,
                                 p_batiment  IN  RESSOURCE.batiment%TYPE,
                                 p_etage     IN  RESSOURCE.etage%TYPE,
                                 p_bureau    IN  RESSOURCE.bureau%TYPE,
                                 p_flaglock  IN  NUMBER,
                                 p_userid    IN  VARCHAR2,
                                 p_rtype     IN RESSOURCE.rtype%TYPE,
                                 p_igg       IN RESSOURCE.IGG%TYPE,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                ) IS

      l_msg VARCHAR2(1024);
      l_hom RESSOURCE.rnom%TYPE;
      l_matricule VARCHAR2(7);
      l_ident RESSOURCE.ident%TYPE;
      l_rnom RESSOURCE.rnom%TYPE;
      l_test NUMBER(1);
      l_rprenom RESSOURCE.rprenom%TYPE;
      l_soccode SITU_RESS.soccode%TYPE;
      l_prestation SITU_RESS.PRESTATION%TYPE;
      l_nb NUMBER(7);
      --YNI
      l_menu          VARCHAR2(255);
      --YNI

      l_user        RESSOURCE_LOGS.user_log%TYPE;
      v_rnom        RESSOURCE.rnom%TYPE;
      v_rprenom     RESSOURCE.rprenom%TYPE;
      v_rtype       RESSOURCE.rtype%TYPE;
      v_matricule   RESSOURCE.matricule%TYPE;
      v_igg         RESSOURCE.igg%TYPE;

      t_ident_clone RESSOURCE.ident%TYPE;
      p_clone          VARCHAR2(5);
      p_flaglock_retour RESSOURCE.FLAGLOCK%TYPE;

    CURSOR c_ressource_old(t_ident RESSOURCE.IDENT%TYPE, t_flaglock RESSOURCE.FLAGLOCK%TYPE) IS
        SELECT rnom, rprenom, rtype, matricule, igg
        FROM RESSOURCE
        WHERE ident  = TO_NUMBER(t_ident)
            AND flaglock = t_flaglock;

    t_ressource_old c_ressource_old%ROWTYPE;

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
      l_prestation := '' ;

       l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
       --YNI
       l_menu := Pack_Global.lire_globaldata(p_userid).menutil;
       --YNI
      -- Récupère la prestation en cours et le soccode

    BEGIN
        SELECT PRESTATION, soccode INTO l_prestation,l_soccode
             FROM SITU_RESS
             WHERE ident = p_ident
             AND   datsitu IN (  SELECT MAX(datsitu)
                                 FROM SITU_RESS
                                 WHERE ident = p_ident
                               );
        EXCEPTION
                WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END ;


    -- TEST sur le matricule selon que la ressource est SG ou pas

    --si SSII
    IF  l_soccode <> 'SG..' THEN

        -- Le matricule n'est plus obligatoire
        IF p_matricule IS NOT NULL THEN

           -- matricule doit etre sur 7 caracteres
            IF  LENGTH(p_matricule) <> 7 THEN
            -- le matricule doit etre sur 7 caracteres !
                   Pack_Global.recuperer_message(20915, NULL, NULL,'MATRICULE', l_msg);
                   RAISE_APPLICATION_ERROR(-20915, l_msg);
            END IF;

            -- 6 derniers car non numeriques
            IF  SUBSTR(p_matricule,1,1)= 'X' THEN
                BEGIN
                SELECT TO_NUMBER(SUBSTR(p_matricule,2,6)) INTO l_matricule FROM dual;
                EXCEPTION
                WHEN OTHERS THEN
                -- 'le matricule est composé de 7 chiffres'
                -- !!! message a modifier !!!!
                Pack_Global.recuperer_message(20913, NULL, NULL, 'MATRICULE', l_msg);
                    RAISE_APPLICATION_ERROR(-20913, l_msg);
                END;
            ELSE
                -- 1er car = Y -> tests
                IF SUBSTR(p_matricule,1,1)= 'Y' THEN
/* bsa 06082012
                     BEGIN
                        SELECT 1 INTO l_test FROM RESSOURCE
                        WHERE matricule = ('X' || SUBSTR(p_matricule,2,6))
                        AND UPPER(rnom)= UPPER(p_rnom)
                        AND UPPER(rprenom)=UPPER(p_rprenom)
                        AND ident <> p_ident;
                        EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                        --'le matricule d'une ressource SSII doit commencer par X'
                        Pack_Global.recuperer_message(20914, NULL, NULL, 'MATRICULE', l_msg);
                            RAISE_APPLICATION_ERROR(-20914, l_msg);
                            -- cas des matricules en doublon
                                  WHEN TOO_MANY_ROWS THEN
                                  NULL ;
                        END;
*/
                    BEGIN
                        SELECT TO_NUMBER(SUBSTR(p_matricule,2,6)) INTO l_matricule FROM dual;
                    EXCEPTION
                    WHEN OTHERS THEN
                    -- 'le matricule commence par la letttre Y et se poursuit par 6 chiffres '
                    Pack_Global.recuperer_message(20918, NULL, NULL, 'MATRICULE', l_msg);
                        RAISE_APPLICATION_ERROR(-20918, l_msg);
                        END;

                    ELSE     --'le matricule d'une ressource SSII doit commencer par X'
                    Pack_Global.recuperer_message(20914, NULL, NULL, 'MATRICULE', l_msg);
                        RAISE_APPLICATION_ERROR(-20914, l_msg);
                    END IF;
            END IF;

        END IF;

    END IF;


    --si SG
    IF l_soccode = 'SG..' THEN
            --kha 14/05/2004 test s'applique aussi au matricule SG
        IF  LENGTH(p_matricule) <> 7 THEN
            -- le matricule doit etre saisi sur 7 caracteres !
                Pack_Global.recuperer_message(20913, NULL, NULL,'MATRICULE', l_msg);
                RAISE_APPLICATION_ERROR(-20913, l_msg);

        END IF;
            --que des numeriques
            BEGIN
            SELECT LPAD(p_matricule,7,'0'), TO_NUMBER(p_matricule) INTO l_matricule, l_nb FROM dual;
            EXCEPTION
            WHEN OTHERS THEN
            -- 'le matricule est composé de 7 chiffres'
            Pack_Global.recuperer_message(20913, NULL, NULL, 'MATRICULE', l_msg);
                RAISE_APPLICATION_ERROR(-20913, l_msg);
                END;
    END IF;


    BEGIN

        -- On récupère les valeurs précédentes pour les logs
        OPEN c_ressource_old(p_ident,p_flaglock) ;
        FETCH c_ressource_old INTO t_ressource_old;

        -- Verification acces concurrent
        IF ( c_ressource_old%NOTFOUND ) THEN

          CLOSE c_ressource_old;
          Pack_Global.recuperer_message(20999, NULL,NULL , NULL, l_msg);
          RAISE_APPLICATION_ERROR( -20999, l_msg );

        END IF;
        CLOSE c_ressource_old;

        UPDATE RESSOURCE SET rnom      = UPPER(p_rnom),
                             rprenom   = UPPER(p_rprenom),
                             matricule = p_matricule,
                             icodimm   = p_icodimm,
                             batiment  = p_batiment,
                             etage     = p_etage,
                             bureau    = p_bureau,
                             rtel      = p_rtel,
                             flaglock  = DECODE( p_flaglock, 1000000, 0, p_flaglock + 1),
                             igg       = p_igg
        WHERE ident  = TO_NUMBER(p_ident)
        AND flaglock = p_flaglock;

         -- On loggue le nom, prenom et matricule, igg dans la table ressource
         Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'RESSOURCE', 'Nom', t_ressource_old.rnom, p_rnom, 'Modification de la ressource');
         Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'RESSOURCE', 'Prénom', t_ressource_old.rprenom, p_rprenom, 'Modification de la ressource');
         Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'RESSOURCE', 'Type', t_ressource_old.rtype, 'P', 'Modification de la ressource');
         Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'RESSOURCE', 'Matricule', t_ressource_old.matricule, p_matricule, 'Modification de la ressource');
         Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'RESSOURCE', 'Igg', t_ressource_old.igg, p_igg, 'Modification de la ressource');

    EXCEPTION

       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;

    -- Recherche du clone ou ressource principale (sur ancienne valeur IGG/Matricule)
    BEGIN
        GET_CLONE_PRINCIPALE ( t_ressource_old.matricule, t_ressource_old.igg, p_rtype, t_ident_clone, p_clone, l_msg );

    EXCEPTION
        WHEN OTHERS THEN
            -- Il existe plusieurs clone associé a cette ressource.\nVeuillez contacter l'administrateur.
            Pack_Global.recuperer_message(21258, NULL, NULL , NULL, l_msg);
            RAISE_APPLICATION_ERROR(-20916, l_msg);
    END;


    -- Si clone ou ressource principale trouve alors maj de ce dernier
    IF ( p_clone = 'OUI' ) THEN

        -- On récupère les valeurs précédentes du clone pour les logs
        SELECT rnom, rprenom, rtype, matricule, igg
        INTO v_rnom, v_rprenom, v_rtype, v_matricule, v_igg
        FROM RESSOURCE
        WHERE ident  = TO_NUMBER(t_ident_clone);

        UPDATE RESSOURCE SET rnom      = UPPER(p_rnom),
                             rprenom   = UPPER(p_rprenom),
                             icodimm   = p_icodimm,
                             batiment  = p_batiment,
                             etage     = p_etage,
                             bureau    = p_bureau,
                             rtel      = p_rtel
        WHERE ident  = TO_NUMBER(t_ident_clone);

        -- On loggue le nom, prenom et matricule, igg dans la table ressource
        Pack_Ressource_P.maj_ressource_logs(t_ident_clone, l_user, 'RESSOURCE', 'Nom', v_rnom, p_rnom, 'Modification de la ressource clone par ident : ' ||p_ident);
        Pack_Ressource_P.maj_ressource_logs(t_ident_clone, l_user, 'RESSOURCE', 'Prénom', v_rprenom, p_rprenom, 'Modification de la ressource clone par ident : ' ||p_ident);

        -- Mise a jour du matricule sur le clone ( Y )
        IF p_matricule IS NOT NULL THEN

            IF ( SUBSTR(p_matricule,1,1) = 'X' ) THEN

                UPDATE RESSOURCE SET matricule = 'Y' ||SUBSTR(p_matricule,2)
                WHERE ident  = TO_NUMBER(t_ident_clone);

                Pack_Ressource_P.maj_ressource_logs(t_ident_clone, l_user, 'RESSOURCE', 'Matricule', v_matricule, 'Y'|| SUBSTR(p_matricule,2), 'Modification de la ressource clone par ident : ' ||p_ident);

            END IF;

        ELSE

            IF ( SUBSTR(p_igg,1,1) = '1' ) THEN

                UPDATE RESSOURCE SET matricule = NULL
                WHERE ident  = TO_NUMBER(t_ident_clone);

                Pack_Ressource_P.maj_ressource_logs(t_ident_clone, l_user, 'RESSOURCE', 'Matricule', v_matricule, NULL, 'Modification de la ressource clone par ident : ' ||p_ident);

            END IF;

        END IF;

        -- Si modification de l igg alors modification de l'igg sur le clone ( 9 )
        IF ( p_igg IS NOT NULL ) THEN

            IF ( SUBSTR(p_igg,1,1) = '1' ) THEN

                UPDATE RESSOURCE SET IGG = '9'||SUBSTR(p_igg,2)
                WHERE ident  = TO_NUMBER(t_ident_clone);

                Pack_Ressource_P.maj_ressource_logs(t_ident_clone, l_user, 'RESSOURCE', 'Igg', v_igg, '9'||SUBSTR(p_igg,2), 'Modification de la ressource clone par ident : ' ||p_ident);

            END IF;

        ELSE
            IF ( SUBSTR(p_matricule,1,1) = 'X' ) THEN

                UPDATE RESSOURCE SET IGG = NULL
                WHERE ident  = TO_NUMBER(t_ident_clone);

                Pack_Ressource_P.maj_ressource_logs(t_ident_clone, l_user, 'RESSOURCE', 'Igg', v_igg, NULL, 'Modification de la ressource clone par ident : ' ||p_ident);
            END IF;

        END IF;

    END IF;

    -- Message : 'situation || p_rnom || modifie';
    IF ( l_soccode='SG..' )THEN
             Pack_Global.recuperer_message(21046, '%s1',p_rnom , NULL, l_msg);
            p_message := l_msg;
    ELSE
            Pack_Global.recuperer_message(21047, '%s1',p_rnom , NULL, l_msg);
            p_message := l_msg;
    END IF;


   END update_ressource_p;


  PROCEDURE verif_matricule_doublon (p_ident        IN  VARCHAR2,
                                     p_userid       IN  VARCHAR2,
                                     p_matricule    IN VARCHAR2,
                                     p_igg          IN VARCHAR2,
                                     p_nom          IN VARCHAR2,
                                     p_prenom       IN VARCHAR2,
                                     p_rtype        IN VARCHAR2,
                                     p_confirm       OUT VARCHAR2,
                                     p_message       OUT VARCHAR2
                                    ) IS


      l_msg         VARCHAR2(1024);
      t_msg         VARCHAR2(1024);

      l_ident       RESSOURCE.ident%TYPE;
      l_rnom        RESSOURCE.rnom%TYPE;
      l_rprenom     RESSOURCE.rprenom%TYPE;
      l_matricule   RESSOURCE.matricule%TYPE;

      l_menu        VARCHAR2(255);
      l_user        RESSOURCE_LOGS.user_log%TYPE;

      v_matricule   RESSOURCE.matricule%TYPE;
      v_igg         RESSOURCE.igg%TYPE;

      p_nbcurseur   NUMBER;

    CURSOR c_igg9_1 IS
        SELECT r.IDENT FROM RESSOURCE r
        WHERE   1 = 1
            AND SUBSTR(r.IGG,1,1) = '1'
            AND SUBSTR(r.IGG,2) = SUBSTR(p_igg,2);

    t_igg9_1 c_igg9_1%ROWTYPE;

    CURSOR c_matricule ( t_nom RESSOURCE.RNOM%TYPE  , t_prenom RESSOURCE.RPRENOM%TYPE, t_matricule RESSOURCE.MATRICULE%TYPE) IS
        SELECT r.IDENT, r.RNOM, r.RPRENOM FROM RESSOURCE r
        WHERE   1 = 1
            AND UPPER(r.RNOM) = UPPER(t_nom)
            AND UPPER(r.RPRENOM) = UPPER(t_prenom)
            AND r.MATRICULE = t_matricule
            AND SUBSTR(r.MATRICULE,1,1) = 'X' ;

     t_matricule   c_matricule%ROWTYPE;


    CURSOR c_matricule2 ( t_matricule RESSOURCE.MATRICULE%TYPE) IS
        SELECT r.IDENT, r.RNOM, r.RPRENOM FROM RESSOURCE r
        WHERE   1 = 1
            AND r.MATRICULE = t_matricule;

     t_matricule2   c_matricule2%ROWTYPE;

    CURSOR c_igg ( t_igg RESSOURCE.IGG%TYPE) IS
        SELECT r.IDENT, r.RNOM, r.RPRENOM FROM RESSOURCE r
        WHERE   1 = 1
            AND r.IGG = t_igg
        ORDER BY r.IDENT ASC;

     t_igg   c_igg%ROWTYPE;

    CURSOR c_igg_double2 ( t_ident RESSOURCE.IDENT%TYPE, t_igg RESSOURCE.IGG%TYPE, t_matricule RESSOURCE.MATRICULE%TYPE ) IS
        SELECT r.IDENT, r.RNOM, r.RPRENOM, r.MATRICULE FROM RESSOURCE r
        WHERE   1 = 1
            AND r.IDENT <> t_ident
            AND r.IGG = t_igg
            AND (
                    ( SUBSTR(t_matricule,1,1) = SUBSTR(r.MATRICULE,1,1)
                      AND SUBSTR(t_matricule,1,1) IN ( 'X','Y')
                      AND SUBSTR(r.MATRICULE,2) = SUBSTR(t_matricule,2)
                    ) OR
                      (
                        r.MATRICULE IS NULL
                      )
                )
        ORDER BY r.IDENT ASC;

    t_igg_double2 c_igg_double2%ROWTYPE;

    CURSOR c_matricule_null ( t_ident RESSOURCE.IDENT%TYPE, t_igg RESSOURCE.IGG%TYPE) IS
        SELECT r.IDENT, r.RNOM, r.RPRENOM FROM RESSOURCE r
        WHERE   1 = 1
            AND r.IGG = t_igg
            AND r.MATRICULE IS NULL
        ORDER BY r.IDENT ASC;

     t_matricule_null   c_matricule_null%ROWTYPE;

    CURSOR c_m2 ( t_ident RESSOURCE.IDENT%TYPE, t_igg RESSOURCE.IGG%TYPE) IS
        SELECT r.IDENT, r.RNOM, r.RPRENOM, r.MATRICULE FROM RESSOURCE r
        WHERE   1 = 1
            AND r.IDENT <> t_ident
            AND r.IGG = t_igg
        ORDER BY r.IDENT ASC;

    t_m2  c_m2%ROWTYPE;

    CURSOR c_m1 ( t_ident RESSOURCE.IDENT%TYPE, t_igg RESSOURCE.IGG%TYPE, t_nom RESSOURCE.RNOM%TYPE  , t_prenom RESSOURCE.RPRENOM%TYPE, t_matricule RESSOURCE.MATRICULE%TYPE ) IS
        SELECT r.IDENT, r.RNOM, r.RPRENOM, r.MATRICULE FROM RESSOURCE r
        WHERE   1 = 1
            AND r.IDENT <> t_ident
            AND r.IGG = t_igg
            AND UPPER(r.RNOM) = UPPER(t_nom)
            AND UPPER(r.RPRENOM) = UPPER(t_prenom)
        ORDER BY r.IDENT ASC;

    t_m1 c_m1%ROWTYPE;

    CURSOR c_igg_double (t_igg RESSOURCE.IGG%TYPE, t_matricule RESSOURCE.MATRICULE%TYPE ) IS
        SELECT r.IDENT, r.RNOM, r.RPRENOM, r.MATRICULE FROM RESSOURCE r
        WHERE   1 = 1
            AND r.IGG = t_igg
            AND SUBSTR(t_matricule,1,1) = 'X'
            AND SUBSTR(r.MATRICULE,1,1) = 'X'
        ORDER BY r.IDENT ASC ;

    t_igg_double c_igg_double%ROWTYPE;

    CURSOR c_clone1 ( t_ident RESSOURCE.IDENT%TYPE, t_matricule RESSOURCE.MATRICULE%TYPE ) IS
        SELECT r.IDENT, r.RNOM, r.RPRENOM, r.MATRICULE FROM RESSOURCE r
        WHERE   1 = 1
            AND r.IDENT <> t_ident
            AND SUBSTR(r.IGG,1,1) = '1'
            AND r.MATRICULE = t_matricule
        ORDER BY r.IDENT ASC ;

    t_clone1 c_clone1%ROWTYPE;

    CURSOR c_clone2 ( t_ident RESSOURCE.IDENT%TYPE, t_matricule RESSOURCE.MATRICULE%TYPE, t_igg RESSOURCE.IGG%TYPE, t_nom RESSOURCE.RNOM%TYPE  , t_prenom RESSOURCE.RPRENOM%TYPE ) IS
        SELECT r.IDENT, r.RNOM, r.RPRENOM, r.MATRICULE FROM RESSOURCE r
        WHERE   1 = 1
            AND r.IDENT <> t_ident
            AND UPPER(r.RNOM) = UPPER(t_nom)
            AND UPPER(r.RPRENOM) = UPPER(t_prenom)
            AND SUBSTR(r.IGG,1,1) <> SUBSTR(t_igg,1,1)
            AND SUBSTR(r.IGG,2) = SUBSTR(t_igg,2)
            AND r.MATRICULE = t_matricule
        ORDER BY r.IDENT ASC ;

    t_clone2 c_clone2%ROWTYPE;
    t_rejet BOOLEAN;

    CURSOR c_res_prin_mat (t_ident RESSOURCE.IDENT%TYPE, t_matricule RESSOURCE.MATRICULE%TYPE ) IS
        SELECT r.IDENT, r.RNOM, r.RPRENOM, r.MATRICULE
        FROM RESSOURCE r
        WHERE SUBSTR(matricule,1,1) = 'X'
          AND SUBSTR(matricule,2) = SUBSTR(t_matricule,2)
          AND ident <> t_ident;

    t_res_prin_mat c_res_prin_mat%ROWTYPE;


    CURSOR c_res_prin_mat_crea (t_matricule RESSOURCE.MATRICULE%TYPE ) IS
        SELECT r.IDENT, r.RNOM, r.RPRENOM, r.MATRICULE
        FROM RESSOURCE r
        WHERE SUBSTR(matricule,1,1) = 'X'
          AND SUBSTR(matricule,2) = SUBSTR(t_matricule,2);

    t_res_prin_mat_crea c_res_prin_mat_crea%ROWTYPE;

    t_notification BOOLEAN;

    t_ident_clone   RESSOURCE.ident%TYPE;
    clone_exist     VARCHAR2(5);
    t_igg_clone     RESSOURCE.IGG%TYPE;
    t_nom_clone     RESSOURCE.RNOM%TYPE;
    t_prenom_clone  RESSOURCE.RPRENOM%TYPE;

    CURSOR csr_homonyme IS SELECT r.ident, r.rnom, r.rprenom ,si.codsg
             FROM   SITU_RESS si, ressource r
             WHERE
             r.rnom = p_nom
             AND r.rprenom =p_prenom
             AND r.ident = si.ident
             AND    datsitu IN (
                             SELECT MAX(datsitu)
                             FROM SITU_RESS
                             WHERE ident = r.ident
                            )
             AND ( r.ident !=p_ident OR p_ident IS NULL);

    CURSOR c_recherche_igg(t_ident RESSOURCE.IDENT%TYPE, t_igg RESSOURCE.IGG%TYPE) IS
        SELECT r.IDENT, r.RNOM, r.RPRENOM, r.IGG
        FROM RESSOURCE r
        WHERE r.ident <> t_ident
            AND r.IGG = t_igg;

    t_recherche_igg c_recherche_igg%ROWTYPE;


    CURSOR c_recherche_matricule(t_ident RESSOURCE.IDENT%TYPE, t_matricule RESSOURCE.MATRICULE%TYPE) IS
        SELECT r.IDENT, r.RNOM, r.RPRENOM, r.MATRICULE
        FROM RESSOURCE r
        WHERE r.ident <> t_ident
            AND r.MATRICULE = t_matricule;

    t_recherche_matricule c_recherche_matricule%ROWTYPE;

   BEGIN

    t_notification := FALSE;
    p_message := '';
    l_msg := '';
    l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
    l_menu := Pack_Global.lire_globaldata(p_userid).menutil;
    t_rejet := FALSE;
    p_nbcurseur := 0;

    -- Nouveau controle

        p_confirm := 'non';

        -- Recherche du clone
        -- Si une ressource clone existe avec un IGG => la ressource doit avoir un igg
        -- Recuperation des anciennes valeur de la ressource : pour la recherche du clone si modif matricule ou igg
        -- Cas modif
        IF ( p_ident IS NOT NULL ) THEN

            SELECT matricule, igg
            INTO v_matricule, v_igg
            FROM RESSOURCE
            WHERE ident  = TO_NUMBER(p_ident);

        -- Cas creation
        ELSE

            v_matricule := p_matricule;
            v_igg := p_igg;

        END IF;

        BEGIN
            GET_CLONE_PRINCIPALE ( v_matricule, v_igg, p_rtype, t_ident_clone, clone_exist, l_msg );

        EXCEPTION
            WHEN OTHERS THEN
                -- Il existe plusieurs clone associé a cette ressource.\nVeuillez contacter l'administrateur.
                Pack_Global.recuperer_message(21258, NULL, NULL , NULL, l_msg);
                p_confirm := 'init';
                RAISE_APPLICATION_ERROR(-20916, l_msg);
        END;

        -- Controle Matricule
        IF ( p_matricule IS NOT NULL ) THEN

            -- Cas Modification
            IF ( p_ident IS NOT NULL ) THEN

                IF ( p_igg IS NOT NULL ) THEN

                    -- Si matricule deja affecte a une autre ressource et les 2 IGG commence par "1"
                    IF ( SUBSTR(p_igg,1,1) = '1' ) THEN
                        OPEN c_clone1(p_ident, p_matricule );
                        FETCH c_clone1 INTO t_clone1;
                        IF c_clone1%FOUND THEN

                            p_confirm := 'init';
                            -- Ce Matricule est déjà affecté à l'identifiant %s1 : %s2, %s3.
                            Pack_Global.recuperer_message(21243, '%s1', t_clone1.IDENT , '%s2', t_clone1.RNOM ,'%s3', t_clone1.RPRENOM, NULL, l_msg);
                            RAISE_APPLICATION_ERROR(-20916, l_msg);

                        END IF;

                        CLOSE c_clone1;
                    END IF;

                    -- Si matricule deja affecte avec meme nom et prenom
                    -- et que igg renseigne pour les 2 ressources sont 1xxxxx... et 9xxxxx...
                    IF ( p_rtype = 'P' ) THEN

                        OPEN c_clone2(p_ident, p_matricule, p_igg, p_nom, p_prenom );
                        FETCH c_clone2 INTO t_clone2;
                        IF c_clone2%FOUND THEN

                            p_confirm := 'init';
                            -- Ce Matricule est déjà affecté à l'identifiant %s1 : %s2, %s3. Si vous souhaitez renseigner un clone veuillez saisir le matricule avec un Y à la place d'un X en premier caractère
                            Pack_Global.recuperer_message(21244, '%s1', t_clone2.IDENT , '%s2', t_clone2.RNOM ,'%s3', t_clone2.RPRENOM, NULL, l_msg);
                            RAISE_APPLICATION_ERROR(-20916, l_msg);

                        END IF;

                        CLOSE c_clone2;
                    END IF;

                END IF;

            -- Cas creation
            ELSE

                IF ( t_rejet = FALSE ) THEN
                    OPEN c_matricule( p_nom, p_prenom, p_matricule );
                    FETCH c_matricule INTO t_matricule;
                    IF c_matricule%FOUND THEN

                        t_rejet := TRUE;
                        p_confirm := 'init';
                        -- Ce Matricule est déjà affecté à l'identifiant %s1 : %s2, %s3. Si vous souhaitez renseigner un clone veuillez saisir le matricule avec un Y à la place d'un X en premier caractère
                        Pack_Global.recuperer_message(21244, '%s1', t_matricule.IDENT , '%s2', t_matricule.RNOM ,'%s3', t_matricule.RPRENOM, NULL, l_msg);
                        RAISE_APPLICATION_ERROR(-20916, l_msg);

                    END IF;

                    CLOSE c_matricule;
                END IF;

                IF ( t_rejet = FALSE ) THEN

                    IF ( clone_exist = 'OUI' ) THEN
                        -- Verification existance Matricule saisie du doublon ( Y ) sur une autre ressource autre que la ressource principale.
                        IF p_matricule IS NOT NULL AND ( NVL(SUBSTR(p_matricule,1,1),'Z') = 'Y' OR NVL(SUBSTR(p_igg,1,1),'Z') = '9' ) THEN

                            -- Recherche la presence du matricule "X...." sur une ressource autre que celui de la ressource principale.
                            OPEN c_recherche_matricule(t_ident_clone, 'X'||SUBSTR(p_matricule,2));
                            FETCH c_recherche_matricule INTO t_recherche_matricule;

                            IF c_recherche_matricule%FOUND THEN

                                t_rejet := TRUE;
                                p_confirm := 'init';
                                -- Le MATRICULE <%s1> est déjà attribué à la ressource %s2 : %s3.
                                Pack_Global.recuperer_message(21260, '%s1', t_recherche_matricule.MATRICULE , '%s2', t_recherche_matricule.IDENT , '%s3', t_recherche_matricule.RNOM || ', ' || t_recherche_matricule.RPRENOM , NULL, l_msg);

                            END IF;

                            CLOSE c_recherche_matricule;

                        END IF;

                    END IF;

                END IF;

                IF ( t_rejet = FALSE ) THEN
                    OPEN c_matricule2( p_matricule );
                    FETCH c_matricule2 INTO t_matricule2;
                    IF c_matricule2%FOUND THEN

                        t_rejet := TRUE;
                        p_confirm := 'init';
                        -- Ce Matricule est déjà affecté à l'identifiant %s1 : %s2, %s3.
                        Pack_Global.recuperer_message(21243, '%s1', t_matricule2.IDENT , '%s2', t_matricule2.RNOM ,'%s3', t_matricule2.RPRENOM, NULL, l_msg);
                        RAISE_APPLICATION_ERROR(-20916, l_msg);

                    END IF;

                    CLOSE c_matricule2;
                END IF;

            END IF;

        END IF;

        -- Controle IGG
        IF ( p_igg IS NOT NULL ) THEN

            -- cas Modification
            IF ( p_ident IS NOT NULL ) THEN

                IF ( t_rejet = FALSE ) THEN

                    -- Regle M1
                    -- Ressource differente avec meme nom et prenom et meme igg
                    OPEN c_m1( p_ident, p_igg, p_nom, p_prenom , p_matricule );
                    FETCH c_m1 INTO t_m1;
                    IF c_m1%FOUND THEN

                            t_rejet := TRUE;
                            p_confirm := 'init';
                            IF ( p_rtype = 'A' ) THEN

                                -- Ce code IGG est déjà affecté à l'identifiant %s1 : %s2, %s3. La mise a jour est impossible
                                Pack_Global.recuperer_message(21241, '%s1', t_m1.IDENT , '%s2', t_m1.RNOM ,'%s3', t_m1.RPRENOM, NULL, l_msg);

                            -- Prestataire
                            ELSE
                                -- Ce code IGG est déjà affecté à l'identifiant %s1 : %s2, %s3. Si vous souhaitez renseigner un clone veuillez saisir l'IGG avec un 9 à la place d'un 1 en premier caractère
                                Pack_Global.recuperer_message(21245, '%s1', t_m1.IDENT , '%s2', t_m1.RNOM ,'%s3', t_m1.RPRENOM, NULL, l_msg);

                            END IF;

                    END IF;

                    CLOSE c_m1;
                END IF;

                -- Regle M2
                -- Si igg commence par 9 ou 1 et deja affecte => rejet
                IF ( t_rejet = FALSE ) THEN

                    OPEN c_m2(p_ident,p_igg );
                    FETCH c_m2 INTO t_m2;
                    IF c_m2%FOUND THEN

                        t_rejet := TRUE;
                        p_confirm := 'init';
                        -- Ce code IGG est déjà affecté à l'identifiant %s1 : %s2, %s3. La mise a jour est impossible
                        Pack_Global.recuperer_message(21241, '%s1', t_m2.IDENT , '%s2', t_m2.RNOM ,'%s3', t_m2.RPRENOM, NULL, l_msg);

                    END IF;

                    CLOSE c_m2;

                END IF;

            -- Cas Creation
            ELSE

                -- Controle IGG 9 : recherche existance IGG 1
                -- si IGG 1 non present alors rejet
                IF SUBSTR(p_igg,1,1) = '9' THEN

                    OPEN c_igg9_1;
                    FETCH c_igg9_1 INTO t_igg9_1;
                    IF c_igg9_1%NOTFOUND THEN

                        t_rejet := TRUE;
                        p_confirm := 'init';
                        -- Code IGG doublon non valide: code IGG commencant par 1 inexistant en base
                        Pack_Global.recuperer_message(21248, '%s1', t_igg_double.IDENT , '%s2', t_igg_double.RNOM ,'%s3', t_igg_double.RPRENOM, NULL, l_msg);

                    END IF;
                    CLOSE c_igg9_1;

                END IF;

                IF ( t_rejet = FALSE ) THEN
                    IF ( clone_exist = 'OUI' ) THEN

                        -- Verification existance igg saisie du doublon ( 9 ) sur une autre ressource autre que la ressource principale.
                        IF ( NVL(SUBSTR(p_igg,1,1),'Z') = '9' ) THEN

                            -- Recherche la presence de l'igg "1...." sur une ressource autre que celui de la ressource principale.
                            OPEN c_recherche_igg(t_ident_clone, '1'||SUBSTR(p_igg,2));
                            FETCH c_recherche_igg INTO t_recherche_igg;

                            IF c_recherche_igg%FOUND THEN

                                t_rejet := TRUE;
                                p_confirm := 'init';
                                -- L'IGG <%s1> est déjà attribué à la ress %s2 : %s3.
                                Pack_Global.recuperer_message(21259, '%s1', t_recherche_igg.IGG , '%s2', t_recherche_igg.IDENT , '%s3', t_recherche_igg.RNOM || ', ' || t_recherche_igg.RPRENOM , NULL, l_msg);

                            END IF;

                            CLOSE c_recherche_igg;

                        END IF;

                    END IF;

                END IF;

                -- Matricule non null
                IF ( p_matricule IS NOT NULL ) THEN

                    -- Matricule saisie et trouve commence tous les 2 par X
                    IF ( t_rejet = FALSE ) THEN
                        OPEN c_igg_double ( p_igg , p_matricule );
                        FETCH c_igg_double INTO t_igg_double;
                        IF c_igg_double%FOUND THEN

                            t_rejet := TRUE;
                            p_confirm := 'init';
                            -- Ce code IGG est déjà affecté à l'identifiant %s1 : %s2, %s3. La création est impossible
                            Pack_Global.recuperer_message(21247, '%s1', t_igg_double.IDENT , '%s2', t_igg_double.RNOM ,'%s3', t_igg_double.RPRENOM, NULL, l_msg);

                        END IF;

                        CLOSE c_igg_double;
                    END IF;

                    -- Matricule saisie et trouve identique commence par X et Y
                    IF ( t_rejet = FALSE ) THEN
                        OPEN c_igg_double2 ( p_ident, p_igg , p_matricule );
                        FETCH c_igg_double2 INTO t_igg_double2;
                        IF c_igg_double2%FOUND THEN

                            t_rejet := TRUE;
                            p_confirm := 'init';
                            -- Ce code IGG est déjà affecté à l'identifiant %s1 : %s2, %s3. La création est impossible
                            Pack_Global.recuperer_message(21247, '%s1', t_igg_double.IDENT , '%s2', t_igg_double.RNOM ,'%s3', t_igg_double.RPRENOM, NULL, l_msg);

                        END IF;

                        CLOSE c_igg_double2;
                    END IF;

                -- Matricule null
                ELSE

                    IF ( t_rejet = FALSE ) THEN

                        OPEN c_matricule_null ( p_ident, p_igg );
                        FETCH c_matricule_null INTO t_matricule_null;
                        IF c_matricule_null%FOUND THEN

                            t_rejet := TRUE;
                            p_confirm := 'init';
                            -- Ce code IGG est déjà affecté à l'identifiant %s1 : %s2, %s3. La création est impossible
                            Pack_Global.recuperer_message(21247, '%s1', t_matricule_null.IDENT , '%s2', t_matricule_null.RNOM ,'%s3', t_matricule_null.RPRENOM, NULL, l_msg);

                        END IF;

                        CLOSE c_matricule_null;

                    END IF;

                END IF;

                -- Controle simple de l existance de l igg
                IF ( t_rejet = FALSE ) THEN

                    OPEN c_igg(p_igg);
                    FETCH c_igg INTO t_igg;
                    IF c_igg%FOUND THEN

                        t_rejet := TRUE;
                        p_confirm := 'init';
                        -- Ce code IGG est déjà affecté à l'identifiant %s1 : %s2, %s3. La création est impossible
                        Pack_Global.recuperer_message(21247, '%s1', t_igg.IDENT , '%s2', t_igg.RNOM ,'%s3', t_igg.RPRENOM, NULL, l_msg);

                    END IF;

                    CLOSE c_igg;

                END IF;

            END IF;

        END IF;

        -- Fin nouveau controle

        -- Init = anomalie
        IF ( p_confirm <> 'init' ) THEN

            -- Debut ancien controle

            BEGIN
                 SELECT matricule,rnom,rprenom INTO l_matricule,l_rnom,l_rprenom
                     FROM RESSOURCE WHERE ident = p_ident;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                         l_matricule:='';
                         l_rnom:='';
                         l_rprenom:='';

            END;

            -- verification homonyme
            IF l_rnom != p_nom OR l_rprenom != p_prenom OR p_ident IS NULL THEN

                -- IDENT : cas d'un homonyme
                l_msg:= '';
                FOR rec_homonyme IN csr_homonyme LOOP

                    p_nbcurseur := 1;
                    l_msg:= l_msg || rec_homonyme.ident || ' - ' || rec_homonyme.rnom || ' - ' || rec_homonyme.rprenom || ' - ' || rec_homonyme.codsg || '\n';

                END LOOP;

                IF (p_nbcurseur = 1) THEN

                    p_confirm := 'oui';

                    p_message := 'ATTENTION : il existe un (des) homonyme(s) : \n';
                    p_message := p_message || 'IDENT - NOM - PRENOM - DPG \n';
                    p_message := p_message || l_msg;

                    IF t_notification = TRUE THEN
                        t_msg := t_msg || '\n' || p_message;
                    ELSE
                        t_notification := TRUE;
                        t_msg := p_message;

                    END IF;
                END IF;

            END IF;

            IF ( clone_exist = 'OUI' ) THEN

                p_confirm := 'oui';

                SELECT rnom,rprenom INTO l_rnom,l_rprenom
                FROM RESSOURCE WHERE ident = t_ident_clone;

                -- La ressource doublon suivante va aussi être mise à jour %s1 : %s2, %s3.
                Pack_Global.recuperer_message(21256, '%s1', t_ident_clone, '%s2', l_rnom, '%s3', l_rprenom, NULL, l_msg);

                IF t_notification = TRUE THEN
                    t_msg := t_msg || '\n' || l_msg;
                ELSE
                    t_notification := TRUE;
                    t_msg := l_msg;

                END IF;

            END IF;

            IF(l_matricule <> p_matricule)   THEN

                -- Modification
                IF(p_ident IS NOT NULL ) THEN

                    -- Cas ou la ressource est transforme en doublon (Y)
                    IF ( SUBSTR(p_matricule,1,1) = 'Y' AND SUBSTR(l_matricule,1,1) = 'X' ) THEN

                        -- Recherche de la ressource principale (X)
                        OPEN c_res_prin_mat(p_ident,p_matricule);
                        FETCH c_res_prin_mat INTO t_res_prin_mat;
                        IF c_res_prin_mat%FOUND THEN

                            p_confirm := 'oui';
                            -- Le nom ou le prenom renseigne est different de la ressource principale %s1 : %s2, %s3.
                            Pack_Global.recuperer_message(21254, '%s1', t_res_prin_mat.ident, '%s2', t_res_prin_mat.rnom ,'%s3', t_res_prin_mat.rprenom,NULL, l_msg);

                            IF t_notification = TRUE THEN
                                t_msg := t_msg || '\n' || l_msg;
                            ELSE
                                t_notification := TRUE;
                                t_msg := l_msg;

                            END IF;

                        END IF;

                        CLOSE c_res_prin_mat;

                    END IF;

                    IF l_menu <> 'DIR' THEN

                         BEGIN
                              SELECT rnom,rprenom,ident INTO l_rnom,l_rprenom,l_ident
                              FROM RESSOURCE WHERE matricule = p_matricule and ident <> p_ident;

                              p_confirm := 'init';
                              t_notification := FALSE;
                              t_msg := l_msg;
                              -- Le matricule %s1 existe déjà pour la ressource %s2,\nident=%s3. Entrez un bon matricule ou contactez l'administrateur.
                              Pack_Global.recuperer_message(20916, '%s1', p_matricule, '%s2', l_rnom || ' ' || l_rprenom,'%s3', TO_CHAR(l_ident),NULL, l_msg);

                              EXCEPTION
                                  WHEN NO_DATA_FOUND THEN
                                    NULL;
                                    -- cas des matricules en doublon
                                  WHEN TOO_MANY_ROWS THEN
                                    p_confirm := 'oui';
                                    -- Le matricule existe déjà !
                                    Pack_Global.recuperer_message(20917, NULL,NULL,NULL, l_msg);
                                    RAISE_APPLICATION_ERROR(-20917, l_msg);

                         END;

                    ELSE

                         BEGIN
                                SELECT rnom,rprenom,ident INTO l_rnom,l_rprenom,l_ident
                                FROM RESSOURCE WHERE matricule = p_matricule and ident <> p_ident;
                                p_confirm := 'oui';
                                -- Le matricule %s1 existe déjà pour la ressource %s2,\nident=%s3.
                                Pack_Global.recuperer_message(21154, '%s1', p_matricule, '%s2', l_rnom || ' ' || l_rprenom,'%s3', TO_CHAR(l_ident),NULL, l_msg);
                                IF t_notification = TRUE THEN
                                    t_msg := t_msg || '\n' || l_msg;
                                ELSE
                                    t_notification := TRUE;
                                    t_msg := l_msg;

                                END IF;


                                EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                                      NULL;

                                    WHEN TOO_MANY_ROWS THEN
                                    p_confirm := 'oui';
                                    -- Matricule déjà existant.
                                    Pack_Global.recuperer_message(21156, NULL,NULL,NULL, l_msg);

                         END;

                    END IF;


                -- Creation
                ELSE
/*
                    -- Cas de creation d un doublon (Y)
                    IF p_matricule IS NOT NULL THEN

                        IF SUBSTR(p_matricule,1,1) = 'Y' THEN

                            -- Recherche de la ressource principale (X)
                            OPEN c_res_prin_mat_crea(p_matricule);
                            FETCH c_res_prin_mat_crea INTO t_res_prin_mat_crea;
                            IF c_res_prin_mat_crea%FOUND THEN

                                p_confirm := 'oui';
                                -- Le nom ou le prenom renseigne est different de la ressource principale %s1 : %s2, %s3.
                                Pack_Global.recuperer_message(21254, '%s1', t_res_prin_mat_crea.ident, '%s2', t_res_prin_mat_crea.rnom ,'%s3', t_res_prin_mat_crea.rprenom,NULL, l_msg);

                                IF t_notification = TRUE THEN
                                    t_msg := t_msg || '\n' || l_msg;
                                ELSE
                                    t_notification := TRUE;
                                    t_msg := l_msg;
                                END IF;

                            END IF;

                            CLOSE c_res_prin_mat_crea;

                        END IF;

                    END IF;
*/
                    IF (l_menu <> 'DIR') THEN
                         BEGIN
                              SELECT rnom,rprenom,ident INTO l_rnom,l_rprenom,l_ident
                              FROM RESSOURCE WHERE matricule = p_matricule;
                              p_confirm := 'oui';
                              -- Le matricule %s1 existe déjà pour la ressource %s2,\nident=%s3. Entrez un bon matricule ou contactez l'administrateur.
                              Pack_Global.recuperer_message(20916, '%s1', p_matricule, '%s2', l_rnom || ' ' || l_rprenom,'%s3', TO_CHAR(l_ident),NULL, l_msg);
                              RAISE_APPLICATION_ERROR(-20916, l_msg);

                                IF t_notification = TRUE THEN
                                    t_msg := t_msg || '\n' || l_msg;
                                ELSE
                                    t_notification := TRUE;
                                    t_msg := l_msg;
                                END IF;

                              EXCEPTION
                                  WHEN NO_DATA_FOUND THEN
                                   NULL;
                                    -- cas des matricules en doublon
                                  WHEN TOO_MANY_ROWS THEN
                                    p_confirm := 'oui';
                                    -- Le matricule existe déjà !
                                    Pack_Global.recuperer_message(20917, NULL,NULL,NULL, l_msg);
                                    RAISE_APPLICATION_ERROR(-20917, l_msg);
                         END;

                    ELSE
                         BEGIN

                            SELECT rnom,rprenom,ident INTO l_rnom,l_rprenom,l_ident
                            FROM RESSOURCE WHERE matricule = p_matricule;
                            p_confirm := 'oui';
                            Pack_Global.recuperer_message(21153, '%s1', p_matricule, '%s2', l_rnom || ' ' || l_rprenom,'%s3', TO_CHAR(l_ident),NULL, l_msg);

                            IF t_notification = TRUE THEN
                                t_msg := t_msg || '\n' || l_msg;
                            ELSE
                                t_notification := TRUE;
                                t_msg := l_msg;
                            END IF;

                         EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                              NULL;

                            WHEN TOO_MANY_ROWS THEN
                            p_confirm := 'oui';
                            -- Le matricule existe déjà !
                            Pack_Global.recuperer_message(20917, NULL,NULL,NULL, l_msg);

                         END;

                    END IF;


                END IF;

            ELSE

                p_confirm :='non';

            END IF;

            -- Fin ancien controle

        END IF;

        IF t_notification = TRUE THEN

            p_confirm :='oui';
            -- Voulez vous continuer ?
            Pack_Global.recuperer_message(21257, NULL,NULL,NULL, l_msg);

            l_msg := t_msg || '\n\n' || l_msg;

        END IF;

        p_message := l_msg;

  END verif_matricule_doublon;


   PROCEDURE select_c_ressource_p (p_rnom          IN  RESSOURCE.rnom%TYPE,
                                   p_rprenom       IN  RESSOURCE.rprenom%TYPE,
                                   p_soccode       IN  SITU_RESS.soccode%TYPE,
                                   p_ident         IN  VARCHAR2,
                                   p_userid        IN  VARCHAR2,
                                   p_rtype IN RESSOURCE.rtype%TYPE,
                                   p_curressource  IN  OUT ressourceCurType,
                                   p_date_courante OUT VARCHAR2,
                                   p_matricule     OUT VARCHAR2,
                                   p_id            OUT VARCHAR2,
                                   p_codsg         OUT VARCHAR2,
                                   p_nbcurseur     OUT INTEGER,
                                   p_message       OUT VARCHAR2
                                  ) IS

    -- SOCODE LOCAL VAR
    l_menu   VARCHAR2(255);
    l_dsocfer       VARCHAR2(20);
    l_date_courante VARCHAR2(20);

    -- FIN SOCODE LOCAL VAR

    l_msg    VARCHAR2(1024);
    l_rnom   RESSOURCE.rnom%TYPE;
    l_id     RESSOURCE.ident%TYPE;


   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- Renvoie la date courante

       -- SELECT 'DATSITU#' || TO_CHAR(SYSDATE,'mm/yyyy')

    SELECT TO_CHAR(SYSDATE,'mm/yyyy')
    INTO   p_date_courante FROM   DUAL;

    -- TEST : soccode existe et societe non fermee si

      l_menu := Pack_Global.lire_globaldata(p_userid).menutil;

     IF l_menu != 'DIR' THEN

      BEGIN
         SELECT TO_CHAR(socfer,'yyyymmdd')
         INTO l_dsocfer
         FROM SOCIETE
         WHERE soccode = p_soccode;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            Pack_Global.recuperer_message(20225, '%s1', p_soccode, 'SOCCODE', l_msg);
            RAISE_APPLICATION_ERROR(-20225, l_msg);

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;


      SELECT TO_CHAR(SYSDATE,'yyyymmdd')
      INTO l_date_courante
      FROM DUAL;

      IF l_dsocfer <= l_date_courante THEN
         Pack_Global.recuperer_message(20225, '%s1', p_soccode, 'SOCCODE', l_msg);
         RAISE_APPLICATION_ERROR(-20225, l_msg);
      END IF;
    END IF;


      -- IDENT : cas d'un homonyme

      BEGIN
         SELECT MAX(ident)
         INTO   l_id
         FROM   RESSOURCE
         WHERE  rnom = p_rnom
         AND    rprenom = p_rprenom;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            NULL;

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;
    -- MATRICULE :cas d un homonyme
    BEGIN
        SELECT matricule
        INTO p_matricule
        FROM RESSOURCE
        WHERE ident= l_id
            ;

         EXCEPTION

         WHEN NO_DATA_FOUND THEN
            NULL;

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;

      --  CODSG : cas d'un homonyme

      BEGIN
         SELECT codsg
         INTO   p_codsg
         FROM   SITU_RESS
         WHERE  ident = l_id
         AND    datsitu IN (
                         SELECT MAX(datsitu)
                         FROM SITU_RESS
                         WHERE ident = TO_NUMBER(l_id)
                        );

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            NULL;

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      p_id :=  l_id;

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *
      -- On ouvre le curseur suivant p_rnom

      -- TEST ident vide -> curseur normal ->, non vide -> curseur vide

      IF p_ident IS NULL THEN

         BEGIN

           OPEN p_curressource FOR
                SELECT *
                FROM   RESSOURCE
                WHERE  rnom = p_rnom
                AND    rprenom = p_rprenom;

         EXCEPTION

           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;

      ELSE
         BEGIN

           OPEN p_curressource FOR
                SELECT *
                FROM   RESSOURCE
                WHERE  rnom = ''
                AND    rprenom = '';

         EXCEPTION

           WHEN OTHERS THEN

              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;
      END IF;

      -- en cas absence
      -- p_message := 'Le logiciel existe deja';

      IF(p_soccode='SG..')THEN
                       Pack_Global.recuperer_message(21044, '%s1', p_rnom, NULL, l_msg);
                    p_message := l_msg;
      ELSE
                      Pack_Global.recuperer_message(21045, '%s1', p_rnom, NULL, l_msg);
                    p_message := l_msg;
      END IF;



   END select_c_ressource_p;



   PROCEDURE select_m_ressource_p (p_rnom         IN  RESSOURCE.rnom%TYPE,
                                   p_rprenom      IN  RESSOURCE.rprenom%TYPE,
                                   p_ident        IN  VARCHAR2,
                                   p_userid       IN  VARCHAR2,
                                   p_rtype IN RESSOURCE.rtype%TYPE,
                                   p_curressource IN  OUT ressource_p_mCurType,
                                   p_datsitu      OUT VARCHAR2,
                                   p_nbcurseur    OUT INTEGER,
                                   p_message      OUT VARCHAR2
                                  ) IS

      l_msg      VARCHAR2(1024);
      l_rtype    RESSOURCE.rtype%TYPE;
      l_codsg    SITU_RESS.codsg%TYPE;
      l_soccode    SITU_RESS.soccode%TYPE;
      l_idarpege VARCHAR2(255);
      l_ges      NUMBER(3);
      l_habilitation VARCHAR2(10);
   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- Gestion du niveau d'acces de l'utilisateur.

      BEGIN
         SELECT codsg,soccode
         INTO l_codsg, l_soccode
         FROM SITU_RESS
         WHERE ident = TO_NUMBER(p_ident)
         AND datsitu IN (
                         SELECT MAX(datsitu)
                         FROM SITU_RESS
                         WHERE ident = TO_NUMBER(p_ident)
                        );

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
             IF(p_rtype='A')THEN
                       Pack_Global.recuperer_message(20512, '%s1', 'Agent SG', '%s2', '',NULL, l_msg);
                   RAISE_APPLICATION_ERROR( -20512,l_msg);
           ELSE
                       Pack_Global.recuperer_message(20512, '%s1', 'Prestation', '%s2', 'e',NULL, l_msg);
                   RAISE_APPLICATION_ERROR( -20512,l_msg);
            END IF;

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

  IF  l_codsg IS NOT NULL THEN
      -- ====================================================================
      -- 7/02/2001 : Test appartenance du DPG au périmètre de l'utilisateur
      -- ====================================================================
         l_habilitation := Pack_Habilitation.fhabili_me( l_codsg,p_userid   );
         IF l_habilitation='faux' THEN
        -- Vous n'êtes pas autorisé à modifier cette ressource, son DPG est
        Pack_Global.recuperer_message(20365, '%s1',  'modifier cette ressource, son DPG est '||l_codsg, 'IDENT', l_msg);
                RAISE_APPLICATION_ERROR(-20365, l_msg);
    END IF;
END IF;
      -- On recherche le type de ressource associe a l'identifiant

      BEGIN
         SELECT rtype
         INTO l_rtype
         FROM RESSOURCE
         WHERE ident = TO_NUMBER(p_ident);

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            NULL;

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF l_rtype != 'P' THEN

             IF p_rtype = 'A' THEN
                  Pack_Global.recuperer_message(20951, '%s1', p_ident,  '%s2', l_rtype, 'IDENT', l_msg);
                  RAISE_APPLICATION_ERROR( -20951, l_msg);
              ELSE
                  Pack_Global.recuperer_message(20952, '%s1', p_ident,  '%s2', l_rtype, 'IDENT', l_msg);
                  RAISE_APPLICATION_ERROR( -20952, l_msg);
               END IF;

      ELSE
                       IF l_soccode!='SG..' AND p_rtype='A' THEN
                          Pack_Global.recuperer_message(20951, '%s1', p_ident,  '%s2', l_rtype, 'IDENT', l_msg);
                          RAISE_APPLICATION_ERROR( -20951, l_msg);

                   ELSIF l_soccode='SG..' AND p_rtype='P' THEN
                          Pack_Global.recuperer_message(20952, '%s1', p_ident,  '%s2','A', 'IDENT', l_msg);
                          RAISE_APPLICATION_ERROR( -20952, l_msg);

                    END IF;


      END IF;


      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *
      -- On ouvre le curseur suivant p_rnom

      BEGIN
         OPEN p_curressource FOR
            SELECT ident,
                   flaglock,
                   rnom,
                   rprenom,
                   matricule,
                   icodimm,
                   batiment,
                   etage,
                   bureau,
                   rtel,
                   igg
            FROM RESSOURCE
            WHERE ident = TO_NUMBER(p_ident)
            ;

      EXCEPTION

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      -- en cas absence
      -- p_message := 'La personne n''existe pas';

      IF ( l_soccode='SG..' )THEN
                 Pack_Global.recuperer_message(21044, '%s1', p_rnom, NULL, l_msg);
                 p_message := l_msg;
      ELSE
                 Pack_Global.recuperer_message(21045, '%s1', p_rnom, NULL, l_msg);
                 p_message := l_msg;
      END IF;



   END select_m_ressource_p;


   PROCEDURE select_s_ressource_p (p_rnom         IN  RESSOURCE.rnom%TYPE,
                                   p_rprenom      IN  RESSOURCE.rprenom%TYPE,
                                   p_ident        IN  VARCHAR2,
                                   p_userid       IN  VARCHAR2,
                                   p_rtype IN RESSOURCE.rtype%TYPE,
                                   p_curressource IN  OUT ressource_p_sCurType,
                                   p_flag         OUT VARCHAR2,
                                   p_nbcurseur    OUT INTEGER,
                                   p_message      OUT VARCHAR2
                                  ) IS

      l_msg VARCHAR2(1024);
      l_rtype RESSOURCE.rtype%TYPE;
      l_soccode SITU_RESS.soccode%TYPE;
      l_codsg SITU_RESS.codsg%TYPE;
      l_habilitation VARCHAR2(10);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      BEGIN
         SELECT TO_CHAR(flaglock)
         INTO p_flag
         FROM RESSOURCE
         WHERE ident = TO_NUMBER(p_ident);

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            NULL;

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      -- TEST : Le type de la ressource est bien une personne

      BEGIN
         SELECT rtype
         INTO l_rtype
         FROM RESSOURCE
         WHERE ident = TO_NUMBER(p_ident);

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            NULL;

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;



      BEGIN
         SELECT codsg,soccode
         INTO l_codsg, l_soccode
         FROM SITU_RESS
         WHERE ident = TO_NUMBER(p_ident)
         AND datsitu IN (
                         SELECT MAX(datsitu)
                         FROM SITU_RESS
                         WHERE ident = TO_NUMBER(p_ident)
                        );

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
        --  pack_global.recuperer_message(2050, '%s1', p_rnom, NULL, l_msg);
    --  p_message := l_msg;
           NULL;

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;


    /*    IF  l_codsg IS NOT NULL THEN
      -- ====================================================================
      -- 24/11/2005 : Test appartenance du DPG au périmètre de l'utilisateur
      -- ====================================================================
         l_habilitation := Pack_Habilitation.fhabili_me( l_codsg,p_userid   );
         IF l_habilitation='faux' THEN
        -- Vous n'êtes pas autorisé à modifier cette ressource, son DPG est
        Pack_Global.recuperer_message(20365, '%s1',  'consulter cette ressource, son DPG est '||l_codsg, 'IDENT', l_msg);
                RAISE_APPLICATION_ERROR(-20365, l_msg);
      END IF;
     END IF;
*/

          IF l_rtype != 'P' THEN

             IF p_rtype = 'A' THEN
                  Pack_Global.recuperer_message(20951, '%s1', p_ident,  '%s2', l_rtype, 'IDENT', l_msg);
                  RAISE_APPLICATION_ERROR( -20951, l_msg);
              ELSE
                  Pack_Global.recuperer_message(20952, '%s1', p_ident,  '%s2', l_rtype, 'IDENT', l_msg);
                  RAISE_APPLICATION_ERROR( -20952, l_msg);
               END IF;

      ELSE
                       IF l_soccode!='SG..' AND p_rtype='A' THEN
                          Pack_Global.recuperer_message(20951, '%s1', p_ident,  '%s2', l_rtype, 'IDENT', l_msg);
                          RAISE_APPLICATION_ERROR( -20951, l_msg);

                    ELSIF l_soccode='SG..' AND p_rtype='P' THEN
                          Pack_Global.recuperer_message(20952, '%s1', p_ident,  '%s2', 'A', 'IDENT', l_msg);
                          RAISE_APPLICATION_ERROR( -20952, l_msg);

                    END IF;


      END IF;



      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *
      -- On ouvre le curseur suivant p_rnom

      BEGIN
         OPEN p_curressource FOR
            SELECT RESSOURCE.ident,
                   RESSOURCE.rnom,
                   RESSOURCE.rprenom,
                   RESSOURCE.matricule,
                   TO_CHAR(RESSOURCE.coutot,'FM9999999990D00'),
                   RESSOURCE.flaglock,
                   TO_CHAR(SITU_RESS.datsitu,'dd/mm/yyyy'),
                   TO_CHAR(SITU_RESS.datdep,'dd/mm/yyyy'),
                   TO_CHAR(SITU_RESS.cout,'FM9999999990D00'),
                   SITU_RESS.PRESTATION,
                   --situ_ress.filcode,
                   SITU_RESS.soccode,
                   SITU_RESS.codsg,
                   TO_CHAR(RESSOURCE.IGG)
            FROM RESSOURCE,SITU_RESS
            WHERE RESSOURCE.ident = TO_NUMBER(p_ident)
            AND   SITU_RESS.ident = TO_NUMBER(p_ident)
        ORDER BY SITU_RESS.datsitu DESC;       --Ajout du 04/09/2001 pour position du curseur sur la liste

      EXCEPTION

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;




      -- si l identifiant ne correspond pas a une ressource
      -- p_message := 'La personne n''existe pas';

       IF ( p_rtype='A' )THEN
                Pack_Global.recuperer_message(21044, '%s1', p_ident, NULL, l_msg);
                p_message := l_msg;
      ELSIF(p_rtype='P')THEN
                Pack_Global.recuperer_message(21045, '%s1', p_ident, NULL, l_msg);
                p_message := l_msg;
      ELSE
                Pack_Global.recuperer_message(2050, '%s1', p_ident, NULL, l_msg);
                p_message := l_msg;
      END IF;



   END select_s_ressource_p;




 PROCEDURE select_ressource_p (  p_ident        IN  VARCHAR2,
                                   p_userid       IN  VARCHAR2,
                                   p_curressource IN  OUT ressource_p_mCurType,
                                   p_nbcurseur    OUT INTEGER,
                                   p_message      OUT VARCHAR2
                                  ) IS

      l_msg      VARCHAR2(1024);
      l_rtype    RESSOURCE.rtype%TYPE;
      l_codsg    SITU_RESS.codsg%TYPE;
      l_idarpege VARCHAR2(255);
      l_ges      NUMBER(3);
      l_habilitation VARCHAR2(10);
   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- Gestion du niveau d'acces de l'utilisateur.

      BEGIN
         SELECT codsg
         INTO l_codsg
         FROM SITU_RESS
         WHERE ident = TO_NUMBER(p_ident)
         AND datsitu IN (
                         SELECT MAX(datsitu)
                         FROM SITU_RESS
                         WHERE ident = TO_NUMBER(p_ident)
                        );

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
        --  pack_global.recuperer_message(2050, '%s1', p_rnom, NULL, l_msg);
    --  p_message := l_msg;
           NULL;

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

  IF  l_codsg IS NOT NULL THEN
      -- ====================================================================
      -- 7/02/2001 : Test appartenance du DPG au périmètre de l'utilisateur
      -- ====================================================================
         l_habilitation := Pack_Habilitation.fhabili_me( l_codsg,p_userid   );
         IF l_habilitation='faux' THEN
        -- Vous n'êtes pas autorisé à modifier cette ressource, son DPG est
        Pack_Global.recuperer_message(20365, '%s1',  'modifier cette ressource, son DPG est '||l_codsg, 'IDENT', l_msg);
                RAISE_APPLICATION_ERROR(-20365, l_msg);
    END IF;
END IF;
      -- On recherche le type de ressource associe a l'identifiant

      BEGIN
         SELECT rtype
         INTO l_rtype
         FROM RESSOURCE
         WHERE ident = TO_NUMBER(p_ident);

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
            NULL;

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF l_rtype != 'P' THEN
         Pack_Global.recuperer_message(20251, '%s1', l_rtype, 'IDENT', l_msg);
         RAISE_APPLICATION_ERROR( -20251, l_msg);
      END IF;


      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *
      -- On ouvre le curseur suivant p_rnom

      BEGIN
         OPEN p_curressource FOR
            SELECT ident,
                   flaglock,
                   rnom,
                   rprenom,
                   matricule,
                   icodimm,
                   batiment,
                   etage,
                   bureau,
                   rtel,
                   igg
            FROM RESSOURCE
            WHERE ident = TO_NUMBER(p_ident)
            ;

      EXCEPTION

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      -- en cas absence
      -- p_message := 'La personne n''existe pas';
      Pack_Global.recuperer_message(2050, '%s1', p_ident, NULL, l_msg);
     p_message := l_msg;

   END select_ressource_p;


 PROCEDURE select_personne_col ( p_id_sequence IN VARCHAR2,
                                 p_userid IN VARCHAR2,
                                 p_curressource IN OUT personne_cCurType,
                                 p_nbcurseur OUT INTEGER,
                                 p_message OUT VARCHAR2
                                 ) IS

      l_msg      VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *
      -- On ouvre le curseur suivant p_rnom

      BEGIN
         OPEN p_curressource FOR
            SELECT
                UPPER(TRIM(p.RNOM)),
                UPPER(TRIM(p.RPRENOM)),
                p.MATRICULE,
                i.ICODIMM,
                p.BATIMENT,
                p.ETAGE,
                p.BUREAU,
                TRIM(p.RTEL),
                p.IGG
                FROM TMP_PERSONNE p, TMP_IMMEUBLE i
                WHERE 1 = 1
                      AND p.IADRABR = i.IADRABR(+)
                      AND p.ID_SEQUENCE = p_id_sequence;

      EXCEPTION

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      -- en cas absence
      -- p_message := 'La personne n''existe pas';
      Pack_Global.recuperer_message(2050, '%s1', p_id_sequence, NULL, l_msg);
      p_message := l_msg;

   END select_personne_col;


 PROCEDURE select_ressource_double ( p_id_sequence IN VARCHAR2,
                                     p_userid IN VARCHAR2,
                                     p_curressource IN OUT list_ress_ViewCurType
                                     ) IS

    l_msg      VARCHAR2(1024);

    CURSOR c_personne_col IS
      SELECT TRIM(p.RNOM) RNOM, TRIM(p.RPRENOM) RPRENOM, TRIM(p.MATRICULE) MATRICULE, TRIM(p.IGG) IGG
      FROM TMP_PERSONNE p
      WHERE p.ID_SEQUENCE = p_id_sequence;

    t_personne_col c_personne_col%ROWTYPE;


BEGIN


    OPEN c_personne_col;
    FETCH c_personne_col INTO t_personne_col;

    CLOSE c_personne_col;

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *
      -- On ouvre le curseur suivant p_rnom

      BEGIN
         OPEN p_curressource FOR
            SELECT TO_CHAR(r.IDENT),
                    RPAD(NVL(TO_CHAR(r.rnom), ' '), 32, ' ')||
                    RPAD(NVL(TO_CHAR(r.RPRENOM ), ' '), 17, ' ')||
                    RPAD(NVL(TO_CHAR(r.matricule) , ' '), 11, ' ')||
                    RPAD(NVL(TO_CHAR(r.IGG) , ' '), 12, ' ') ||
                    RPAD(NVL(TO_CHAR(r.IDENT ), ' '), 13, ' ')||
                    LPAD(NVL(TO_CHAR(s2.CODSG) , ' '), 9, ' ') lib
            FROM RESSOURCE r,
                (SELECT MAX(s.DATSITU) DATSITU , s.IDENT
                FROM situ_ress s
                GROUP BY  s.IDENT) situ,
                SITU_RESS s2

            WHERE 1 = 1
                  AND r.IDENT = s2.IDENT
                  AND s2.IDENT = situ.IDENT
                  AND s2.DATSITU = situ.DATSITU
                  AND (
                        ( UPPER(r.RNOM) = UPPER(t_personne_col.RNOM) AND UPPER(r.RPRENOM) = UPPER(t_personne_col.RPRENOM) )
                        OR r.IGG = t_personne_col.IGG
                        OR r.MATRICULE = t_personne_col.MATRICULE
                      )
            ORDER BY r.RNOM, r.RPRENOM asc;

      EXCEPTION

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;


END select_ressource_double;



 --lot 4.3 fich 187 nouvelle procedure de test des homonymes

  PROCEDURE verif_homonyme (p_ident     IN  VARCHAR2,
                                 p_rnom      IN  RESSOURCE.rnom%TYPE,
                                 p_rprenom   IN  RESSOURCE.rprenom%TYPE,
                                 p_userid    IN  VARCHAR2,
                                 p_matricule OUT VARCHAR2,
                                 p_id        OUT VARCHAR2,
                                 p_codsg     OUT VARCHAR2,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                )  IS

      l_id       RESSOURCE.ident%TYPE;
      l_rprenom  RESSOURCE.rprenom%TYPE;
      l_rnom     RESSOURCE.rnom%TYPE;

    l_msg    VARCHAR2(1024);


CURSOR csr_homonyme IS SELECT r.ident, r.rnom, r.rprenom ,si.codsg
         FROM   SITU_RESS si, ressource r
         WHERE
         r.rnom = p_rnom
         and r.rprenom =p_rprenom
         and r.ident = si.ident
         AND    datsitu IN (
                         SELECT MAX(datsitu)
                         FROM SITU_RESS
                         WHERE ident = r.ident
                        )
         and r.ident !=p_ident;


   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := ' ';

BEGIN
    SELECT rnom, rprenom
    INTO l_rnom, l_rprenom
    FROM RESSOURCE
    WHERE ident = p_ident;

EXCEPTION

         WHEN NO_DATA_FOUND THEN
            NULL;

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

    IF l_rnom != p_rnom OR l_rprenom != p_rprenom THEN

      -- IDENT : cas d'un homonyme

       FOR rec_homonyme IN csr_homonyme LOOP
       p_nbcurseur := 1;
            l_msg:= l_msg || rec_homonyme.ident || ' - ' || rec_homonyme.rnom || ' - ' || rec_homonyme.rprenom || ' - ' || rec_homonyme.codsg || '\n';
       END LOOP;

      IF (p_nbcurseur = 1) THEN


      p_message := 'ATTENTION : il existe un (des) homonyme(s) : \n\n';
      p_message := p_message || 'IDENT - NOM - PRENOM - DPG \n';
      p_message := p_message || l_msg;
      p_message := p_message || '\nVoulez vous continuer ?';
      p_message := ' ';

    END IF;

    END IF;

   END verif_homonyme;


    --Procédure pour remplir les logs de MAJ de la ressource et situ_ress

   PROCEDURE maj_ressource_logs(p_ident        IN RESSOURCE_LOGS.ident%TYPE,
                                                                             p_user_log    IN RESSOURCE_LOGS.user_log%TYPE,
                                                                             p_table      IN RESSOURCE_LOGS.nom_table%TYPE,
                                                                             p_colonne    IN RESSOURCE_LOGS.colonne%TYPE,
                                                                             p_valeur_prec    IN RESSOURCE_LOGS.valeur_prec%TYPE,
                                                                             p_valeur_nouv    IN RESSOURCE_LOGS.valeur_nouv%TYPE,
                                                                             p_commentaire    IN RESSOURCE_LOGS.commentaire%TYPE
                                                                             ) IS
   BEGIN

    IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
        INSERT INTO RESSOURCE_LOGS
            (ident, date_log, user_log, nom_table, colonne, valeur_prec, valeur_nouv, commentaire)
        VALUES
            (p_ident, CURRENT_TIMESTAMP, p_user_log, p_table, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);
    --PPM 57823 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
    END IF;
    -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

   END maj_ressource_logs;


   PROCEDURE RECUP_LIB_MCI(p_mci        IN    VARCHAR2,
                               p_lib_mci    OUT    VARCHAR2,
                               p_message        OUT     VARCHAR2)
            IS
msg         VARCHAR(1024);
BEGIN
    SELECT LIBELLE INTO p_lib_mci
    FROM mode_contractuel
    WHERE CODE_CONTRACTUEL=p_mci;


    EXCEPTION
    WHEN NO_DATA_FOUND THEN
            Pack_Global.recuperer_message( 21191, NULL, NULL, NULL, p_message);
    WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR( -20997, SQLERRM);


END RECUP_LIB_MCI;

PROCEDURE LISTER_RESS_IGG(  p_igg       IN VARCHAR2,
                            p_matricule IN VARCHAR2,
                            p_debnom    IN VARCHAR2,
                            p_nomcont   IN VARCHAR2,
                            p_userid     IN VARCHAR2,
                            p_curseur  IN OUT list_ress_ViewCurType
                            ) IS


  l_menu   VARCHAR2(255);
  l_count NUMBER;


    BEGIN

        IF p_matricule IS NULL THEN
            OPEN    p_curseur FOR
                SELECT
                    to_char(p.ID_SEQUENCE) seq,
                    RPAD(NVL(to_char(p.CIVILITE ), ' '), 8, ' ')||
                    RPAD(NVL(TO_CHAR(p.rnom), ' '), 32, ' ')||
                    RPAD(NVL(TO_CHAR(p.RPRENOM ), ' '), 17, ' ')||
                    RPAD(NVL(TO_CHAR(p.matricule) , ' '), 11, ' ')||
                    RPAD(NVL(p.IGG , ' '), 12, ' ') lib
                FROM TMP_PERSONNE p
                WHERE p.rnom like '%'||UPPER(p_nomcont)||'%'    -- contient
                      AND p.rnom like UPPER(p_debnom) || '%'    -- debut nom
                      AND p.IGG like p_igg || '%'
                ORDER BY p.rnom,p.rprenom;

        ELSE

            OPEN    p_curseur FOR
                SELECT
                    to_char(p.ID_SEQUENCE) seq,
                    RPAD(NVL(to_char(p.CIVILITE ), ' '), 8, ' ')||
                    RPAD(NVL(TO_CHAR(p.rnom), ' '), 32, ' ')||
                    RPAD(NVL(TO_CHAR(p.RPRENOM ), ' '), 17, ' ')||
                    RPAD(NVL(TO_CHAR(p.matricule) , ' '), 11, ' ')||
                    RPAD(NVL(p.IGG , ' '), 12, ' ') lib
                FROM TMP_PERSONNE p
                WHERE p.rnom like '%'||UPPER(p_nomcont)||'%'    -- contient
                      AND p.rnom like UPPER(p_debnom) || '%'    -- debut nom
                      AND p.IGG like p_igg || '%'
                      AND UPPER(p.matricule) = UPPER(p_matricule)
                ORDER BY p.rnom,p.rprenom;
        END IF;


END  LISTER_RESS_IGG;


   /*
    - Mise à jour des prénoms / noms des ressources à recycler
	- Génération d'un log compte rendu
	Appelée par le batch ressources_prepa_recyclage.sh
   */
PROCEDURE update_ress_prepa_recyclage (p_chemin_fichier        IN VARCHAR2,
                                       p_nom_fichier           IN VARCHAR2,
							 p_id_batch IN TRAIT_BATCH.ID_TRAIT_BATCH%TYPE) IS

L_PROCNAME  VARCHAR2(40) := 'update_ress_prepa_recyclage';
L_HFILE     UTL_FILE.FILE_TYPE;
L_RETCOD    NUMBER;
L_STATEMENT VARCHAR2(128);
date_debut_CR VARCHAR2(40);
date_fin_CR VARCHAR2(40);
verif1 NUMBER;
verifnom ressource.rnom%type;
verifprenom ressource.rprenom%type;
modifnom BOOLEAN;
modifprenom BOOLEAN;

		-- Récupération des enregistrements dans la table temporaire RESSOURCES_PREPA_RECYCLAGE
CURSOR cur_ress
IS SELECT * FROM RESSOURCES_PREPA_RECYCLAGE ;



BEGIN

-- Traçabilité des changements : $Dateressources_prepa_recyclage.log

    -----------------------------------------------------
    -- Init de la trace
    -----------------------------------------------------
        L_RETCOD := Trclog.INITTRCLOG( p_chemin_fichier , L_PROCNAME, L_HFILE );
        IF ( L_RETCOD <> 0 ) THEN
        RAISE_APPLICATION_ERROR( TRCLOG_FAILED_ID,
                                'Problème lors de l initialisation du fichier de LOG', FALSE );
        END IF;
   --date/heure début de traitement
        SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') into date_debut_CR FROM DUAL;

        Trclog.Trclog( L_HFILE, 'DEBUT CR du batch de préparation de recyclage de ressources : ' || date_debut_CR );

        FOR curseur IN cur_ress LOOP

          --Initialisation des booleens de modification des noms et prenoms
         -- modifnom := FALSE;
          --modifprenom :=FALSE;

          -- Vérification de l'identifiant BIP
          select count(*) into verif1 from ressource
          where ident = curseur.ident;

          if verif1 = 0 then

            Trclog.Trclog( L_HFILE, 'Ress ' || curseur.ident ||' : inconnue en Bip donc non traitée'  );
          -- Vérification de l'existance de la date
          elsif curseur.DATE_AUPLUSTOT is null then

            Trclog.Trclog( L_HFILE, 'Ress ' || curseur.ident ||' : date manquante ou incorrecte, donc ressource non traitée'  );

          else
          -- SI le nom de la ressource ne commence pas par "A-RECYCLER-", le mettre à jour en le
          --commençant par "A-RECYCLER-" suivi des 1 à 19 premiers car. qui existaient initialement,
          --(ne pas ajouter de blancs à droite du nom)
            select rnom, rprenom  into verifnom, verifprenom from ressource
            where ident = curseur.ident;
            if substr(verifnom, 1,11) != 'A-RECYCLER-' then
                UPDATE RESSOURCE SET RNOM = 'A-RECYCLER-' || substr(verifnom, 1, 19)
                WHERE IDENT = curseur.IDENT;
                --modifnom:=TRUE;
                --On trace le changement dans la table ressource.logs
                /* garder une traçabilité du changement de nom s'il a eu lieu ET du changement de prénom
                  s'il a eu lieu;
                  avec le USER "Batch prép recyclage", le commentaire "Modification ressource",
                  et le bon nom de colonne pour chaque trace concernée,
                */
                Pack_Ressource_P.maj_ressource_logs(curseur.IDENT, 'Batch prép recyclage', 'RESSOURCE', 'RNOM', verifnom, 'A-RECYCLER-' || substr(verifnom, 1, 19), 'Modification ressource');
            end if;
            if substr(verifprenom, 1, 10) != TO_CHAR(curseur.DATE_AUPLUSTOT,'DD/MM/YYYY') or verifprenom is NULL then
                UPDATE RESSOURCE SET RPRENOM = TO_CHAR(curseur.DATE_AUPLUSTOT,'DD/MM/YYYY')
                WHERE IDENT = curseur.IDENT;
                --modifprenom:=TRUE;
                Pack_Ressource_P.maj_ressource_logs(curseur.IDENT, 'Batch prép recyclage', 'RESSOURCE', 'RPRENOM', verifprenom, TO_CHAR(curseur.DATE_AUPLUSTOT,'DD/MM/YYYY'), 'Modification ressource');
            end if;
            -- Si le nom ou/et le prenom a été modifié alors on indique le changement au niveau du fichier de CR
            --Ress NNNNN : traitée
            Trclog.Trclog( L_HFILE, 'Ress ' || curseur.ident ||' : traitée'  );

          end if;

        END LOOP;

        --"FIN CR du batch de préparation de recyclage de ressources" et l'horodatage en cours (JJ/MM/AAAA HH:MM ou autre format similaire).
        --date/heure fin de traitement
        SELECT TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') into date_fin_CR FROM DUAL;
        Trclog.Trclog( L_HFILE, 'FIN CR du batch de préparation de recyclage de ressources : ' || date_fin_CR );

        COMMIT;

END update_ress_prepa_recyclage;

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

FUNCTION isMciObligatoire (p_codsg IN  NUMBER) RETURN VARCHAR2
IS

    l_msg           VARCHAR2(1024);
    t_obligatoire   VARCHAR2(2);


BEGIN

    t_obligatoire := 'N';

    BEGIN
        isMciObligatoire(p_codsg,t_obligatoire,l_msg);

    EXCEPTION
       WHEN OTHERS THEN
          t_obligatoire := 'N';
    END;


   -- valeur retour
   RETURN t_obligatoire;

END isMciObligatoire;




END Pack_Ressource_P;

/

show errors
