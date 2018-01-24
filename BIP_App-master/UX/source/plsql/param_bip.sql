-- PACK_PARAM_BIP
-- Gestion des lignes de paramètres BIP et des logs liés
-- CMA 22/03/2011 création 1087
-- CMA 25/03/2011 1090 ajout de recuperer_liste_param_bip pour l'écran contacts
-- CMA 04/04/2011 Retrait de traces inutiles dans test_message

CREATE OR REPLACE PACKAGE     PACK_PARAM_BIP AS
/******************************************************************************
   NAME:       PACK_PARAM_BIP
   PURPOSE:    Gestion des lignes de paramètres BIP

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        24/02/2011             CMA    Created this package.
******************************************************************************/

PROCEDURE maj_param_bip_logs( p_code_action            IN PARAM_BIP_LOGS.code_action%TYPE,
                                p_code_version            IN PARAM_BIP_LOGS.code_version%TYPE,
                                p_num_ligne            IN PARAM_BIP_LOGS.num_ligne%TYPE,
                                p_user_log        IN PARAM_BIP_LOGS.user_log%TYPE,
                                p_colonne        IN PARAM_BIP_LOGS.colonne%TYPE,
                                p_valeur_prec    IN PARAM_BIP_LOGS.valeur_prec%TYPE,
                                p_valeur_nouv    IN PARAM_BIP_LOGS.valeur_nouv%TYPE,
                                p_commentaire    IN PARAM_BIP_LOGS.commentaire%TYPE
                                ) ;

   TYPE ligne_param_bip_ViewType IS RECORD ( CODE_ACTION       LIGNE_PARAM_BIP.code_action%TYPE,
  CODE_VERSION      LIGNE_PARAM_BIP.code_version%TYPE,
  NUM_LIGNE         LIGNE_PARAM_BIP.num_ligne%TYPE,
  ACTIF             LIGNE_PARAM_BIP.actif%TYPE,
  APPLICABLE        LIGNE_PARAM_BIP.applicable%TYPE,
  OBLIGATOIRE       LIGNE_PARAM_BIP.obligatoire%TYPE,
  MULTI             LIGNE_PARAM_BIP.multi%TYPE,
  SEPARATEUR        LIGNE_PARAM_BIP.separateur%TYPE,
  FORMAT            LIGNE_PARAM_BIP.format%TYPE,
  CASSE             LIGNE_PARAM_BIP.casse%TYPE,
  CODE_ACTION_LIE   LIGNE_PARAM_BIP.code_action_lie%TYPE,
  CODE_VERSION_LIE  LIGNE_PARAM_BIP.code_version_lie%TYPE,
  NUM_LIGNE_LIE     LIGNE_PARAM_BIP.num_ligne_lie%TYPE,
  MIN_SIZE_UNIT     LIGNE_PARAM_BIP.min_size_unit%TYPE,
  MAX_SIZE_UNIT     LIGNE_PARAM_BIP.max_size_unit%TYPE,
  MIN_SIZE_TOT      LIGNE_PARAM_BIP.min_size_tot%TYPE,
  MAX_SIZE_TOT      LIGNE_PARAM_BIP.max_size_tot%TYPE,
  VALEUR            LIGNE_PARAM_BIP.valeur%TYPE,
  COMMENTAIRE       LIGNE_PARAM_BIP.commentaire%TYPE);


   -- définition du curseur sur la table ligne_param_bip

   TYPE ligne_param_bipCurType IS REF CURSOR RETURN ligne_param_bip_ViewType;

   TYPE ligne_param_bip_p_RecType IS RECORD (num_ligne    VARCHAR2(20),
                                            lib        VARCHAR2(150));

        TYPE ligne_param_bip_p_CurType IS REF CURSOR RETURN ligne_param_bip_p_RecType;

PROCEDURE lister_lignes_param_bip (p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                                   p_code_version IN LIGNE_PARAM_BIP.code_version%TYPE,
                                   p_curLigne_bip IN OUT ligne_param_bip_p_CurType,
                                   p_message      OUT VARCHAR2
                                   );

PROCEDURE select_ligne_param_bip (p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                                   p_code_version IN LIGNE_PARAM_BIP.code_version%TYPE,
                                   p_num_ligne IN LIGNE_PARAM_BIP.num_ligne%TYPE,
                                   p_curLigne_bip IN OUT ligne_param_bipCurType,
                                   p_message      OUT VARCHAR2
                                   );

PROCEDURE insert_ligne_param_bip (p_code_action IN varchar2,
                                  p_code_version IN varchar2,
                                  p_num_ligne IN NUMBER,
                                  p_actif IN char,
                                  p_applicable IN char,
                                  p_obligatoire IN char,
                                  p_multi IN char,
                                  p_separateur IN char,
                                  p_format IN char,
                                  p_casse IN char,
                                  p_code_action_lie IN varchar2,
                                  p_code_version_lie IN varchar2,
                                  p_num_ligne_lie IN number,
                                  p_min_size_unit IN number,
                                  p_max_size_unit IN number,
                                  p_min_size_tot IN number,
                                  p_max_size_tot IN number,
                                  p_valeur IN varchar2,
                                  p_commentaire IN varchar2,
                                  p_userid IN varchar2,
                                  p_message OUT varchar2);

PROCEDURE update_ligne_param_bip (p_code_action IN varchar2,
                                  p_code_version IN varchar2,
                                  p_num_ligne IN NUMBER,
                                  p_actif IN char,
                                  p_applicable IN char,
                                  p_obligatoire IN char,
                                  p_multi IN char,
                                  p_separateur IN char,
                                  p_format IN char,
                                  p_casse IN char,
                                  p_code_action_lie IN varchar2,
                                  p_code_version_lie IN varchar2,
                                  p_num_ligne_lie IN number,
                                  p_min_size_unit IN number,
                                  p_max_size_unit IN number,
                                  p_min_size_tot IN number,
                                  p_max_size_tot IN number,
                                  p_valeur IN varchar2,
                                  p_commentaire IN varchar2,
                                  p_userid IN varchar2,
                                  p_message OUT varchar2);

PROCEDURE delete_ligne_param_bip ( p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                                   p_code_version IN LIGNE_PARAM_BIP.code_version%TYPE,
                                   p_num_ligne IN LIGNE_PARAM_BIP.num_ligne%TYPE,
                                   p_userid IN VARCHAR2,
                                   p_message      OUT VARCHAR2
                                   );

PROCEDURE delete_lignes_param_bip ( p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                                   p_code_version IN LIGNE_PARAM_BIP.code_version%TYPE,
                                   p_userid IN VARCHAR2);

PROCEDURE existe_param_bip (p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                            p_code_version IN LIGNE_PARAM_BIP.code_version%TYPE,
                            p_num_ligne IN VARCHAR2,
                            p_message OUT VARCHAR2);

PROCEDURE is_ligne_param_bip_active (p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                            p_code_version IN LIGNE_PARAM_BIP.code_version%TYPE,
                            p_num_ligne IN VARCHAR2,
                            p_message OUT VARCHAR2);

-- Permet de récupérer X lignes paramètres BIP, actives ou non pour un code action et un code version donné
PROCEDURE recuperer_lignes_param_bip (p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                                   p_code_version IN LIGNE_PARAM_BIP.code_version%TYPE,
                                   p_actives IN VARCHAR2,
                                   p_nbLignes IN NUMBER,
                                   p_curLigne_bip IN OUT ligne_param_bipCurType,
                                   p_message      OUT VARCHAR2
                                   );


-- SEL 60709 5.4
PROCEDURE lister_lignes_param_bip_global (p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                                             p_curLigne_bip IN OUT ligne_param_bipCurType,
                                             p_message      OUT VARCHAR2 );


END PACK_PARAM_BIP;
/

create or replace PACKAGE BODY     PACK_PARAM_BIP AS

PROCEDURE maj_param_bip_logs( p_code_action            IN PARAM_BIP_LOGS.code_action%TYPE,
                                p_code_version            IN PARAM_BIP_LOGS.code_version%TYPE,
                                p_num_ligne            IN PARAM_BIP_LOGS.num_ligne%TYPE,
                                p_user_log        IN PARAM_BIP_LOGS.user_log%TYPE,
                                p_colonne        IN PARAM_BIP_LOGS.colonne%TYPE,
                                p_valeur_prec    IN PARAM_BIP_LOGS.valeur_prec%TYPE,
                                p_valeur_nouv    IN PARAM_BIP_LOGS.valeur_nouv%TYPE,
                                p_commentaire    IN PARAM_BIP_LOGS.commentaire%TYPE
                                ) IS
   BEGIN


    IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
        INSERT INTO PARAM_BIP_LOGS
            (code_action, code_version, num_ligne, date_log, user_log, colonne, valeur_prec, valeur_nouv, commentaire)
        VALUES
            (p_code_action, p_code_version, p_num_ligne, SYSDATE, p_user_log, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);

    END IF;
    -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

   END maj_param_bip_logs;

   PROCEDURE lister_lignes_param_bip (p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                                   p_code_version IN LIGNE_PARAM_BIP.code_version%TYPE,
                                   p_curLigne_bip IN OUT ligne_param_bip_p_CurType,
                                   p_message      OUT VARCHAR2
                                   ) IS

    msg VARCHAR2(1024);
    codaction LIGNE_PARAM_BIP.code_action%TYPE;

    BEGIN


        BEGIN

            -- Verifier que la date effet existe avant d'aller chercher les lignes

            SELECT code_action into codaction
            FROM DATE_EFFET
            WHERE code_action = p_code_action
                AND code_version = p_code_version;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- Paramètre BIP inexistant

               Pack_Global.recuperer_message(21222, NULL, NULL, NULL, msg);
               p_message := msg;
               RAISE_APPLICATION_ERROR( -20999, msg );
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

        open p_curLigne_bip FOR
        SELECT TO_CHAR(num_ligne),LPAD(TO_CHAR(num_ligne),2,'0')||'      '||actif||'       '||SUBSTR(valeur,0,67) FROM LIGNE_PARAM_BIP
        WHERE code_action = p_code_action
            AND code_version = p_code_version
        order by num_ligne;

    END lister_lignes_param_bip;

PROCEDURE select_ligne_param_bip (p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                                   p_code_version IN LIGNE_PARAM_BIP.code_version%TYPE,
                                   p_num_ligne IN LIGNE_PARAM_BIP.num_ligne%TYPE,
                                   p_curLigne_bip IN OUT ligne_param_bipCurType,
                                   p_message      OUT VARCHAR2
                                   )IS

    msg VARCHAR2(1024);
    codaction LIGNE_PARAM_BIP.code_action%TYPE;

    BEGIN


        BEGIN

            -- Verifier que la date effet existe avant d'aller chercher les lignes

            SELECT code_action into codaction
            FROM DATE_EFFET
            WHERE code_action = p_code_action
                AND code_version = p_code_version;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- Paramètre BIP inexistant

               Pack_Global.recuperer_message(21222, NULL, NULL, NULL, msg);
               p_message := msg;
               RAISE_APPLICATION_ERROR( -20999, msg );
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

        open p_curLigne_bip FOR
        SELECT * FROM LIGNE_PARAM_BIP
        WHERE code_action = p_code_action
            AND code_version = p_code_version
            AND num_ligne = p_num_ligne;

    END select_ligne_param_bip;

PROCEDURE insert_ligne_param_bip (p_code_action IN varchar2,
                                  p_code_version IN varchar2,
                                  p_num_ligne IN NUMBER,
                                  p_actif IN char,
                                  p_applicable IN char,
                                  p_obligatoire IN char,
                                  p_multi IN char,
                                  p_separateur IN char,
                                  p_format IN char,
                                  p_casse IN char,
                                  p_code_action_lie IN varchar2,
                                  p_code_version_lie IN varchar2,
                                  p_num_ligne_lie IN number,
                                  p_min_size_unit IN number,
                                  p_max_size_unit IN number,
                                  p_min_size_tot IN number,
                                  p_max_size_tot IN number,
                                  p_valeur IN varchar2,
                                  p_commentaire IN varchar2,
                                  p_userid IN varchar2,
                                  p_message OUT varchar2)IS

    l_msg varchar2(1024);
    l_user        PARAM_BIP_LOGS.user_log%TYPE;

    BEGIN

         p_message := '';
         l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);


      BEGIN



          INSERT INTO LIGNE_PARAM_BIP

         VALUES ( p_code_action,
                  p_code_version ,
                  p_num_ligne ,
                  UPPER(p_actif) ,
                  UPPER(p_applicable) ,
                  UPPER(p_obligatoire) ,
                  UPPER(p_multi) ,
                  p_separateur,
                  UPPER(p_format) ,
                  UPPER(p_casse) ,
                  p_code_action_lie ,
                  p_code_version_lie ,
                  p_num_ligne_lie ,
                  p_min_size_unit ,
                  p_max_size_unit ,
                  p_min_size_tot ,
                  p_max_size_tot ,
                  p_valeur ,
                  p_commentaire);

         pack_global.recuperer_message( 21217, '%s1', p_num_ligne, NULL, l_msg);

         p_message := l_msg;

         maj_param_bip_logs( p_code_action,p_code_version,p_num_ligne,l_user,'Numéro ligne','',p_num_ligne,'Création d''une nouvelle ligne paramètre BIP');
         maj_param_bip_logs( p_code_action,p_code_version,p_num_ligne,l_user,'Actif','',p_actif,'Création d''une nouvelle ligne paramètre BIP');
         maj_param_bip_logs( p_code_action,p_code_version,p_num_ligne,l_user,'Applicable','',p_applicable,'Création d''une nouvelle ligne paramètre BIP');
         maj_param_bip_logs( p_code_action,p_code_version,p_num_ligne,l_user,'Obligatoire','',p_obligatoire,'Création d''une nouvelle ligne paramètre BIP');
         maj_param_bip_logs( p_code_action,p_code_version,p_num_ligne,l_user,'Multivalué','',p_multi,'Création d''une nouvelle ligne paramètre BIP');
         maj_param_bip_logs( p_code_action,p_code_version,p_num_ligne,l_user,'Séparateur si multivalué','',p_separateur,'Création d''une nouvelle ligne paramètre BIP');
         maj_param_bip_logs( p_code_action,p_code_version,p_num_ligne,l_user,'Num. seulement','',p_format,'Création d''une nouvelle ligne paramètre BIP');
         maj_param_bip_logs( p_code_action,p_code_version,p_num_ligne,l_user,'Convertir en maj.','',p_casse,'Création d''une nouvelle ligne paramètre BIP');
         maj_param_bip_logs( p_code_action,p_code_version,p_num_ligne,l_user,'Code action lié','',p_code_action_lie,'Création d''une nouvelle ligne paramètre BIP');
         maj_param_bip_logs( p_code_action,p_code_version,p_num_ligne,l_user,'Code version lié','',p_code_version_lie,'Création d''une nouvelle ligne paramètre BIP');
         maj_param_bip_logs( p_code_action,p_code_version,p_num_ligne,l_user,'Numéro ligne lié','',p_num_ligne_lie,'Création d''une nouvelle ligne paramètre BIP');
         maj_param_bip_logs( p_code_action,p_code_version,p_num_ligne,l_user,'Long unitaire mini et maxi','',p_min_size_unit||' - '||p_max_size_unit,'Création d''une nouvelle ligne paramètre BIP');
         maj_param_bip_logs( p_code_action,p_code_version,p_num_ligne,l_user,'Long totale mini et maxi','',p_min_size_tot||' - '||p_max_size_tot,'Création d''une nouvelle ligne paramètre BIP');
         maj_param_bip_logs( p_code_action,p_code_version,p_num_ligne,l_user,'Valeur','',SUBSTR(p_valeur,0,30),'Création d''une nouvelle ligne paramètre BIP');


         EXCEPTION

          WHEN DUP_VAL_ON_INDEX THEN

           pack_global.recuperer_message( 21218, NULL, NULL, NULL, l_msg);

               RAISE_APPLICATION_ERROR( -20999, l_msg );



            WHEN OTHERS THEN

               RAISE_APPLICATION_ERROR( -20997, SQLERRM);

     END;


    END insert_ligne_param_bip;

PROCEDURE update_ligne_param_bip (p_code_action IN varchar2,
                                  p_code_version IN varchar2,
                                  p_num_ligne IN NUMBER,
                                  p_actif IN char,
                                  p_applicable IN char,
                                  p_obligatoire IN char,
                                  p_multi IN char,
                                  p_separateur IN char,
                                  p_format IN char,
                                  p_casse IN char,
                                  p_code_action_lie IN varchar2,
                                  p_code_version_lie IN varchar2,
                                  p_num_ligne_lie IN number,
                                  p_min_size_unit IN number,
                                  p_max_size_unit IN number,
                                  p_min_size_tot IN number,
                                  p_max_size_tot IN number,
                                  p_valeur IN varchar2,
                                  p_commentaire IN varchar2,
                                  p_userid IN VARCHAR2,
                                  p_message OUT varchar2)IS

  l_msg VARCHAR2(1024);
  l_user        PARAM_BIP_LOGS.user_log%TYPE;
  l_prev_actif VARCHAR2(1);
  l_prev_applicable VARCHAR2(1);
  l_prev_obligatoire VARCHAR2(1);
  l_prev_multi VARCHAR2(1);
  l_prev_separateur VARCHAR2(1);
  l_prev_format VARCHAR2(1);
  l_prev_casse VARCHAR2(1);
  l_prev_code_action_lie VARCHAR2(30);
  l_prev_code_version_lie VARCHAR2(30);
  l_prev_num_ligne_lie VARCHAR2(30);
  l_prev_long_min_unit NUMBER(2);
  l_prev_long_max_unit NUMBER(2);
  l_prev_long_min_tot NUMBER(3);
  l_prev_long_max_tot NUMBER(4);--PPM 63485 : agrandir le champ « longueur totale maximale » de 3 à 4
  l_prev_valeur VARCHAR2(30);

  BEGIN

      -- Initialiser le message retour

      p_message := '';
      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);


      BEGIN
      -- Sélection des valeurs précédentes pour traçabilité
      SELECT actif,applicable,obligatoire,multi,separateur,format,casse,code_action_lie,code_version_lie,num_ligne_lie,
             min_size_unit,max_size_unit,min_size_tot,max_size_tot,SUBSTR(valeur,0,30)
             INTO l_prev_actif,l_prev_applicable,l_prev_obligatoire,l_prev_multi,l_prev_separateur,l_prev_format,l_prev_casse,
                  l_prev_code_action_lie,l_prev_code_version_lie,l_prev_num_ligne_lie,l_prev_long_min_unit,
                  l_prev_long_max_unit,l_prev_long_min_tot,l_prev_long_max_tot,l_prev_valeur
             FROM LIGNE_PARAM_BIP
             WHERE code_action = p_code_action  AND code_version =  p_code_version AND num_ligne = p_num_ligne;

            UPDATE LIGNE_PARAM_BIP
            SET     actif = UPPER(p_actif),
                 applicable = UPPER(p_applicable),
                 obligatoire = UPPER(p_obligatoire),
                 multi = UPPER(p_multi),
                 separateur = p_separateur,
                 format = UPPER(p_format),
                 casse = UPPER(p_casse),
                 code_action_lie = p_code_action_lie,
                 code_version_lie = p_code_version_lie,
                 num_ligne_lie = p_num_ligne_lie,
                 min_size_unit = p_min_size_unit,
                 max_size_unit = p_max_size_unit,
                 min_size_tot = p_min_size_tot,
                 max_size_tot = p_max_size_tot,
                 valeur = p_valeur,
                 commentaire = p_commentaire
            WHERE code_action = p_code_action  AND code_version =  p_code_version AND num_ligne = p_num_ligne;

        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'Actif',l_prev_actif,p_actif,'Modification d''une ligne de paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'Applicable ici',l_prev_applicable,p_applicable,'Modification d''une ligne de paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'Multivalué',l_prev_multi,p_multi,'Modification d''une ligne de paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'Séparateur',l_prev_separateur,p_separateur,'Modification d''une ligne de paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'num. seulement',l_prev_format,p_format,'Modification d''une ligne de paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'Convertir en maj.',l_prev_casse,p_casse,'Modification d''une ligne de paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'Code action lié',l_prev_code_action_lie,p_code_action_lie,'Modification d''une ligne de paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'Code version lié',l_prev_code_version_lie,p_code_version_lie,'Modification d''une ligne de paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'Num ligne lié',l_prev_num_ligne_lie,p_num_ligne_lie,'Modification d''une ligne de paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'Long unitaire mini',l_prev_long_min_unit,p_min_size_unit,'Modification d''une ligne de paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'Long unitaire maxi',l_prev_long_max_unit,p_max_size_unit,'Modification d''une ligne de paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'Long totale mini',l_prev_long_min_tot,p_min_size_tot,'Modification d''une ligne de paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'Long totale maxi',l_prev_long_max_tot,p_max_size_tot,'Modification d''une ligne de paramètre BIP');
        PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'Valeur',l_prev_valeur,SUBSTR(p_valeur,0,30),'Modification d''une ligne de paramètre BIP');


      EXCEPTION

      WHEN OTHERS THEN
               Pack_Global.recuperer_message( 21181, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20999, SQLERRM );
      END;


          IF SQL%NOTFOUND THEN

          -- 'Accès concurrent'

             Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20999, l_msg );

          ELSE


         -- 'La ligne a été modifiée'

               Pack_Global.recuperer_message( 21221, '%s1', p_num_ligne, NULL, l_msg);
               p_message := l_msg;
          END IF;


    END update_ligne_param_bip;

PROCEDURE delete_ligne_param_bip ( p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                                   p_code_version IN LIGNE_PARAM_BIP.code_version%TYPE,
                                   p_num_ligne IN LIGNE_PARAM_BIP.num_ligne%TYPE,
                                   p_userid IN VARCHAR2,
                                   p_message      OUT VARCHAR2
                                   )IS


    l_msg VARCHAR2(1024);
    referential_integrity EXCEPTION;
    l_count NUMBER;
    PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
    l_user        PARAM_BIP_LOGS.user_log%TYPE;

    BEGIN

      -- Initialiser le message retour

      p_message := '';
      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);


     BEGIN
       DELETE FROM LIGNE_PARAM_BIP WHERE code_action = p_code_action  AND code_version =  p_code_version AND num_ligne = p_num_ligne;

     EXCEPTION
         WHEN referential_integrity THEN
                 Pack_Global.recuperer_message( 21179, NULL, NULL, NULL, l_msg);
             RAISE_APPLICATION_ERROR( -20954, l_msg );

         WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;

     IF SQL%NOTFOUND THEN

       -- 'Accès concurrent'
        Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
      RAISE_APPLICATION_ERROR( -20999, l_msg );

      ELSE

       -- ' la ligne a été supprimée'

         PACK_PARAM_BIP.maj_param_bip_logs( UPPER(p_code_action),UPPER(p_code_version),p_num_ligne,l_user,'Num ligne',p_num_ligne,'','Suppression de la ligne paramètre BIP');
         Pack_Global.recuperer_message( 21220, '%s1', p_num_ligne, NULL, l_msg);
         p_message := l_msg;


      END IF;
    END delete_ligne_param_bip;

PROCEDURE delete_lignes_param_bip ( p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                                   p_code_version IN LIGNE_PARAM_BIP.code_version%TYPE,
                                   p_userid IN VARCHAR2
                                   )IS

    CURSOR lignesCur IS SELECT * FROM LIGNE_PARAM_BIP
           WHERE code_action  = p_code_action
           AND   code_version  = p_code_version;

      l_ligne LIGNE_PARAM_BIP%ROWTYPE;
      l_message VARCHAR2(1024);
    BEGIN
    OPEN lignesCur;
    LOOP
            FETCH lignesCur INTO l_ligne;
            IF (lignesCur%FOUND) THEN
                delete_ligne_param_bip(p_code_action,p_code_version,l_ligne.num_ligne,p_userid,l_message);
            END IF;
            EXIT WHEN lignesCur%NOTFOUND;
        END LOOP;
        CLOSE lignesCur;

    END delete_lignes_param_bip;


PROCEDURE existe_param_bip (p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                            p_code_version IN LIGNE_PARAM_BIP.code_version%TYPE,
                            p_num_ligne IN VARCHAR2,
                            p_message OUT VARCHAR2)IS

    msg VARCHAR2(1024);
    codaction LIGNE_PARAM_BIP.code_action%TYPE;

    BEGIN

    p_message :='';

    IF(p_num_ligne is null OR p_num_ligne='')THEN

        BEGIN

            -- On regarde si la date_effete xiste

            SELECT code_action into codaction
            FROM DATE_EFFET
            WHERE code_action = p_code_action
                AND code_version = p_code_version;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- Paramètre BIP inexistant

               Pack_Global.recuperer_message(21222, NULL, NULL, NULL, msg);
               p_message := msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

     ELSE

      BEGIN

            -- On regarde si la ligne_param_bip existe

            SELECT code_action into codaction
            FROM LIGNE_PARAM_BIP
            WHERE code_action = p_code_action
                AND code_version = p_code_version
                AND num_ligne = TO_NUMBER(p_num_ligne);

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- Ligne Paramètre BIP inexistante

               Pack_Global.recuperer_message(21222, NULL, NULL, NULL, msg);
               p_message := msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

     END IF;



    END existe_param_bip;

PROCEDURE is_ligne_param_bip_active (p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                            p_code_version IN LIGNE_PARAM_BIP.code_version%TYPE,
                            p_num_ligne IN VARCHAR2,
                            p_message OUT VARCHAR2)IS

     msg VARCHAR2(1024);
     l_actif LIGNE_PARAM_BIP.actif%TYPE;

    BEGIN

        p_message :='';

     BEGIN

            -- On regarde si la ligne_param_bip est active

            SELECT actif into l_actif
            FROM LIGNE_PARAM_BIP
            WHERE code_action = p_code_action
                AND code_version = p_code_version
                AND num_ligne = TO_NUMBER(p_num_ligne);

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- Ligne Paramètre BIP inexistante

               Pack_Global.recuperer_message(21222, NULL, NULL, NULL, msg);
               p_message := msg;
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

        IF(l_actif='N')THEN
            Pack_Global.recuperer_message(21222, NULL, NULL, NULL, msg);
            p_message := msg;
        END IF;

    END is_ligne_param_bip_active;

    PROCEDURE recuperer_lignes_param_bip (p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                                   p_code_version IN LIGNE_PARAM_BIP.code_version%TYPE,
                                   p_actives IN VARCHAR2,
                                   p_nbLignes IN NUMBER,
                                   p_curLigne_bip IN OUT ligne_param_bipCurType,
                                   p_message      OUT VARCHAR2
                                   ) IS

    msg VARCHAR2(1024);
    codaction LIGNE_PARAM_BIP.code_action%TYPE;

    BEGIN


        BEGIN

            -- Verifier que la date effet existe avant d'aller chercher les lignes

            SELECT code_action into codaction
            FROM DATE_EFFET
            WHERE code_action = p_code_action
                AND code_version = p_code_version;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- Paramètre BIP inexistant

               Pack_Global.recuperer_message(21222, NULL, NULL, NULL, msg);
               p_message := msg;
               RAISE_APPLICATION_ERROR( -20999, msg );
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;
        IF (p_nbLignes!=0) THEN
            open p_curLigne_bip FOR
            SELECT * FROM LIGNE_PARAM_BIP
            WHERE code_action = p_code_action
                AND code_version = p_code_version
                AND actif LIKE '%'||p_actives
                AND ROWNUM <= p_nbLignes
            order by num_ligne;
        ELSE
            open p_curLigne_bip FOR
            SELECT * FROM LIGNE_PARAM_BIP
            WHERE code_action = p_code_action
                AND code_version = p_code_version
                AND actif LIKE '%'||p_actives
            order by num_ligne;
        END IF;

    END recuperer_lignes_param_bip;

  -- SEL 60709 5.4
  PROCEDURE lister_lignes_param_bip_global (p_code_action IN LIGNE_PARAM_BIP.code_action%TYPE,
                                             p_curLigne_bip IN OUT ligne_param_bipCurType,
                                             p_message      OUT VARCHAR2 ) IS



    msg VARCHAR2(1024);
    codaction LIGNE_PARAM_BIP.code_action%TYPE;


    BEGIN
      p_message := 'OK';

          BEGIN


          open p_curLigne_bip FOR
          SELECT * FROM LIGNE_PARAM_BIP
          WHERE code_action like p_code_action||'%'
              AND upper(actif) LIKE 'O'
          order by num_ligne;

         if p_curLigne_bip%rowcount = 0 then

                      BEGIN

                      open p_curLigne_bip FOR
                      SELECT * FROM LIGNE_PARAM_BIP
                      WHERE upper(code_action) like p_code_action||'%'
                      AND upper(code_version) like 'DEFAUT'
                          AND upper(actif) LIKE 'O'
                      order by num_ligne;


                       if p_curLigne_bip%rowcount = 0 then
                       p_message := 'KO';
                       end if;

                      END;
          end if;

          END;

  END lister_lignes_param_bip_global;

   END PACK_PARAM_BIP;
   /