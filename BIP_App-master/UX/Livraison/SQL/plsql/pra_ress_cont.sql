create or replace
PACKAGE PACK_PRA_RESS_CONT IS

/* procedure principale*/
PROCEDURE P_PRA_RESS_CONT_MAIN (P_LOGDIR VARCHAR2);

   ------------------------------------------
-- PROCEDURE SUR LES RESSOURCES ET SITUATIONS --
   ------------------------------------------

/* controle et determination des ressources et situations */
PROCEDURE P_RESS_SITU_PRA (P_HFILE utl_file.file_type);

/* Creation de lignes dans PRA_RESSOURCE */
PROCEDURE P_CRE_PRA_RESSOURCE (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ress     IN TMP_RESSOURCE_PRA%ROWTYPE,
                rec_ress    IN RESSOURCE%ROWTYPE,
                rec_situ    IN SITU_RESS%ROWTYPE,
                p_code_mess    IN INTEGER,
                p_message    IN VARCHAR2
                );

/* Creation d'une ressource dans la table ressource */
PROCEDURE P_CRE_RESSOURCE (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ress     IN TMP_RESSOURCE_PRA%ROWTYPE,
                rec_ress     IN OUT RESSOURCE%ROWTYPE,
                rec_situ    IN OUT SITU_RESS%ROWTYPE,
                p_clone        IN INTEGER,
                is_recycle OUT INTEGER
                );

/* Modification d'une ressource dans la table ressource */
PROCEDURE P_MOD_RESSOURCE (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ress     IN TMP_RESSOURCE_PRA%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE,
                rec_situ    IN SITU_RESS%ROWTYPE,
                rec_ress_bip     IN RESSOURCE%ROWTYPE,
                p_clone        IN INTEGER,        -- 1 si clone 0 sinon
                p_maj        OUT INTEGER        -- mise à jour effective 1 oui, 0 sinon
                );
/* Modification d'une situation dans la table SITU_RESS */
PROCEDURE P_CRE_SITUATION (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ress     IN TMP_RESSOURCE_PRA%ROWTYPE,
                rec_ress    IN RESSOURCE%ROWTYPE,
                rec_situ     IN SITU_RESS%ROWTYPE,
                p_clone        IN INTEGER
                );

/* Modification d'une situation dans la table SITU_RESS */
PROCEDURE P_MOD_SITUATION (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ress     IN TMP_RESSOURCE_PRA%ROWTYPE,
                rec_ress    IN RESSOURCE%ROWTYPE,
                rec_situ    IN SITU_RESS%ROWTYPE,
                rec_situ_bip     IN SITU_RESS%ROWTYPE,
                p_clone        IN INTEGER,        -- 1 si clone 0 sinon
                p_maj        OUT INTEGER        -- mise à jour effective 1 oui, 0 sinon
                );

   ---------------------------------------------
-- PROCEDURE SUR LES CONTRATS ET LIGNES CONTRATS --
   ---------------------------------------------
/*
Vérification de la conformité d'un numéro de contrat ATG
*/
FUNCTION EST_NUM_CONTRAT_ATG_CONFORME(num_contrat TMP_CONTRAT_PRA.num_contrat%TYPE) RETURN VARCHAR2;

/* procédure de traitements contrats /lignes contrats PRA */
PROCEDURE P_CTRA_LIGC_PRA (P_HFILE utl_file.file_type);

/* Création des  PRA de suivi */
PROCEDURE P_CRE_PRA_CONTRAT (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ctra    IN TMP_CONTRAT_PRA%ROWTYPE,
                rec_ctra    IN CONTRAT%ROWTYPE,
                rec_ligc    IN LIGNE_CONT%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE,
                p_code_mess    IN INTEGER,
                p_message    IN VARCHAR2
                );

/* Création des contrats PRA */
PROCEDURE P_CRE_CONTRAT (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ctra    IN TMP_CONTRAT_PRA%ROWTYPE,
                rec_ctra    IN CONTRAT%ROWTYPE,
                rec_ligc    IN LIGNE_CONT%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE
                );

/* Modification des contrats PRA */
PROCEDURE P_MOD_CONTRAT (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ctra    IN TMP_CONTRAT_PRA%ROWTYPE,
                rec_ctra    IN CONTRAT%ROWTYPE,
                rec_ligc    IN LIGNE_CONT%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE,
                rec_ctra_bip    IN CONTRAT%ROWTYPE
                );

/* Création des lignes contrats PRA */
PROCEDURE P_CRE_LIGNE_CONT (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ctra    IN TMP_CONTRAT_PRA%ROWTYPE,
                rec_ctra    IN CONTRAT%ROWTYPE,
                rec_ligc    IN LIGNE_CONT%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE
                );

/* Modification des lignes contrats PRA */
PROCEDURE P_MOD_LIGNE_CONT (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ctra    IN TMP_CONTRAT_PRA%ROWTYPE,
                rec_ctra    IN CONTRAT%ROWTYPE,
                rec_ligc    IN LIGNE_CONT%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE,
                rec_ligc_bip     IN LIGNE_CONT%ROWTYPE,
                p_maj        OUT INTEGER        -- mise à jour effective 1 oui, 0 sinon
                );



/* PPM 60006: Suppression des lignes contrats PRA */
PROCEDURE P_DEL_LIGNE_CONT (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ctra    IN TMP_CONTRAT_PRA%ROWTYPE,
                rec_ctra    IN CONTRAT%ROWTYPE,
                rec_ligc    IN LIGNE_CONT%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE,
                rec_ligc_bip     IN LIGNE_CONT%ROWTYPE              
                );
Type TAB_REC_LIGC IS TABLE OF LIGNE_CONT%ROWTYPE INDEX BY BINARY_INTEGER ;--PPM 60006 

/* procedure d'optimisation des ressources */
PROCEDURE P_PRA_RESS_CONT_OPT (P_LOGDIR VARCHAR2,  p_chemin_fichier  IN VARCHAR2, p_nom_fichier   IN VARCHAR2);

/* procedure d'export des fichiers optimisés des ressources */
PROCEDURE SELECT_EXPORT_PRA_OPT (P_HFILE IN utl_file.file_type,  p_chemin_fichier  IN VARCHAR2, p_nom_fichier   IN VARCHAR2);

/* procedure de copie de la table TMP_RESSOURCE_PRA vers OPT */
PROCEDURE DUPLICATE_FROM_PRA_TO_OPT;

FUNCTION verif_situ(p_ident IN NUMBER, datedeb IN DATE, datefin IN DATE) RETURN INTEGER;

/* PPM 49340 : */

FUNCTION calcul_consomme(
 ress_ident IN RESSOURCE.IDENT%TYPE,
 d_creation IN RESSOURCE_LOGS.DATE_LOG%TYPE
) return integer;

FUNCTION calcul_stock_fi(
 ress_ident IN RESSOURCE.IDENT%TYPE,
 d_creation IN RESSOURCE_LOGS.DATE_LOG%TYPE
) return integer;

FUNCTION calcul_stock_immo(
 ress_ident IN RESSOURCE.IDENT%TYPE,
 d_creation IN RESSOURCE_LOGS.DATE_LOG%TYPE
) return integer;

FUNCTION verif_eligible(
 P_HFILE IN utl_file.file_type,
 rec_ress IN RESSOURCE%ROWTYPE
) return integer;

PROCEDURE P_CRE_SITUATION_RECYCLABLE(
 P_HFILE IN utl_file.file_type,
 p_date_trait IN date,
 rec_tmp_ress IN TMP_RESSOURCE_PRA%ROWTYPE,
 rec_ress IN RESSOURCE%ROWTYPE,
 rec_situ IN SITU_RESS%ROWTYPE);

PROCEDURE P_MOD_SITUATION_RECYCLABLE(
 P_HFILE IN utl_file.file_type,
 p_date_trait IN date,
 rec_tmp_ress IN TMP_RESSOURCE_PRA%ROWTYPE,
 rec_ress IN RESSOURCE%ROWTYPE,
 rec_situ IN SITU_RESS%ROWTYPE);
 
PROCEDURE P_DEL_SITUATION(
 P_HFILE IN utl_file.file_type,
 rec_situ IN SITU_RESS%ROWTYPE,
 rec_tmp_ress IN TMP_RESSOURCE_PRA%ROWTYPE);

PROCEDURE P_RECYCLE_RESS(
 P_HFILE IN utl_file.file_type,
 p_date_trait IN date,
 rec_tmp_ress IN TMP_RESSOURCE_PRA%ROWTYPE,
 rec_ress IN RESSOURCE%ROWTYPE,
 rec_situ IN OUT SITU_RESS%ROWTYPE);

 
/* Modification d'une ressource dans la table ressource */
PROCEDURE P_MOD_RESSOURCE_RECYCLABLE (    P_HFILE     IN utl_file.file_type,
    p_date_trait    IN date,
    rec_tmp_ress     IN TMP_RESSOURCE_PRA%ROWTYPE,
    rec_ress     IN RESSOURCE%ROWTYPE,
    rec_situ    IN SITU_RESS%ROWTYPE
    );
 
/* FIN PPM 49340 */
/* QC 1620 (PPM 49340) : ajout de fonction de recuparation de la date a partir du prenom */
FUNCTION date_rprenom (p_chaine IN VARCHAR2)
return DATE;
END PACK_PRA_RESS_CONT;
/
create or replace
PACKAGE BODY     PACK_PRA_RESS_CONT IS

	-- Exceptions générales
    -- --------------------
    ANO_DATE EXCEPTION;
    PRAGMA EXCEPTION_INIT( ANO_DATE, -01839 ); -- Permet de gérer les anomalies sur les format date
    ANO_DATE2 EXCEPTION;
    PRAGMA EXCEPTION_INIT( ANO_DATE2, -01843 ); -- Permet de gérer les anomalies sur les format date
    ANO_DATE3 EXCEPTION;
    PRAGMA EXCEPTION_INIT( ANO_DATE3, -01847 ); -- Permet de gérer les anomalies sur les format date

    CALL_ABORT exception;
    PRAGMA EXCEPTION_INIT( CALL_ABORT, -20100 ); -- Abort provoqué suite à anomalie détectée

    CALL_ABORT_LOG exception;
    PRAGMA EXCEPTION_INIT( CALL_ABORT_LOG, -20300 ); -- Abort provoqué suite à anomalie détectée sur gestion de LOG
    
    -- SEL PPM 60488 : optimisation recyclage ressource
    IDENT_NON_ELIGIBLE number:=0;

	PROCEDURE P_PRA_RESS_CONT_MAIN(P_LOGDIR VARCHAR2) IS
-- ==============================================================================
-- Nom     :    P_PRA_RESS_CONT_MAIN (Procedure)
-- Description:    Procédure principale de gestion des ressources/ situations et
--        des contrats / lignes contrat en provenance de prestachat
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    PLOGDIR : Directory du fichier de log
--
-- Parametres de sortie :
-- --------------------
--    Aucun
--
-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - JM.LEDOYEN - FICHE 1419 : création
-- 12/12/2014 - Samih EL BOUZIDI - FICHE PPM 60488 : optimisation recyclage ressource
-- ==============================================================================

    P_HFILE        utl_file.file_type;     -- Pointeur de fichier log
    L_RETCOD    number;            -- Receptionne le code retour d'une procedure
    L_PROCNAME     varchar2(30):='P_PRA_RESS_CONT_MAIN'; -- nom de la procedure courante

BEGIN
    -- Init de la trace
    -- ----------------
    L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, P_HFILE );
    if ( L_RETCOD <> 0 ) then
        raise_application_error( -20300,
        'Erreur : Gestion du fichier LOG impossible', false );
    end if;

    -- Trace Start
    -- -----------
    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : Debut.');

    -- lancement des procédures ressources/situation
    -- ---------------------------------------------

    PACK_PRA_RESS_CONT.P_RESS_SITU_PRA (P_HFILE) ;

    -- lancement des procédures Contrats/lignes
    -- ---------------------------------------------

    PACK_PRA_RESS_CONT.P_CTRA_LIGC_PRA (P_HFILE) ;

    -- Trace Stop
    -- ----------
    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Fin normale.');
    TRCLOG.CLOSETRCLOG( P_HFILE );

EXCEPTION
    WHEN CALL_ABORT_LOG THEN
        RAISE_APPLICATION_ERROR(-20300,
                    'Arrêt du BATCH provoqué suite à anomalie de gestion de log (|: consulter la log',false);

    WHEN CALL_ABORT THEN
        ROLLBACK;
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : Fin ANORMALE.' );
        TRCLOG.CLOSETRCLOG( P_HFILE );
        RAISE_APPLICATION_ERROR(-20100,
                    'Arrêt du BATCH provoqué suite à anomalie : consulter la log',false);
    WHEN OTHERS THEN
        ROLLBACK;
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : Code = ' || sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : Fin ANORMALE.' );
        TRCLOG.CLOSETRCLOG( P_HFILE );
        RAISE_APPLICATION_ERROR(-20200,
                    'Arrêt du BATCH NON provoqué suite à anomalie : consulter la log',false);

-- =================== Fin procedure P_PRA_RESS_CONT_MAIN ===================
END P_PRA_RESS_CONT_MAIN;

PROCEDURE P_RESS_SITU_PRA (P_HFILE utl_file.file_type) IS
-- ==============================================================================
-- Nom     :    P_RESS_SITU_PAR (Procedure)
-- Description:    Procédure de controle et de mise à jour des ressources
--        et situations prestachat
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE : Pointeur du fichier log
--
-- Parametres de sortie :
-- --------------------
--    Aucun
--
-- Retour :
-- -------
--    non traité
-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - JM.LEDOYEN - FICHE 1419 : Création
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_RESS_SITU_PRA'; -- nom de la procedure courante
l_type_maj    CHAR(1);        -- Type de mise a jour C=creation , M=modification
l_message    VARCHAR2(255);        -- message d'anomalie ou de mise à jour
l_date_trait    DATE;            -- date de passage du traitement
l_etape        VARCHAR2(255);        -- etape courante
l_null        INTEGER;        -- Flag de controle existence
--PPM 58858 l_centractiv    NUMBER(6);    -- centre d'activité
--PPM 58858 l_librca    VARCHAR2(30);        -- Libellé du centre activité
l_complexite    VARCHAR2(255);        -- champ de constitution du libellé complexité
l_action_situ    VARCHAR2(50);        -- action à réaliser sur la situation
l_action_ress    VARCHAR2(50);        -- action à réaliser sur la ressource
l_action_clone    VARCHAR2(50);        -- action à réaliser sur le clone ressource
l_flag_clone    INTEGER;        -- flag de présence de clone sur la ressource 1=clone existe sinon 0
l_req_where_cl    VARCHAR2(255);        -- clause where de la requete dynamique (pour clone)
l_req_where    VARCHAR2(255);        -- clause where de la requete dynamique
l_requete    VARCHAR2(255);        -- variable au contenu divers selon besoin
l_maj        INTEGER;        -- flag de mise à joour effective d'une ressource
i        INTEGER; -- Flag de vérification de situation
l_save_rprenom    VARCHAR2(50);        -- sauvegarde prenom
l_save_igg    NUMBER(30);        -- sauvegarde igg
l_save_matricule VARCHAR2(30);        -- sauvegarde matricule
l_id_trace VARCHAR2(30);        -- id trace abort
l_igg_trace VARCHAR2(30);        -- igg trace abort
l_igg_ress_princ ressource.igg%TYPE; -- igg de la ressource principale
l_matricule_ress_princ ressource.matricule%TYPE; -- matricule de la ressource principale
l_topfer CHAR(1 BYTE); -- PPM 58858
L_DATE_EFFET STRUCT_INFO.DATE_EFFET%TYPE;

               ------------------
            -- Structure de table --
               ------------------
    -- *** tableau tampon des donéees vérifiées et transformées p@c
rec_ress    RESSOURCE%ROWTYPE;    -- Stucture de reception pour Modification ou modification
rec_situ    SITU_RESS%ROWTYPE;    -- Stucture de reception pour Modification ou modification
rec_situ_clone    RESSOURCE%ROWTYPE;    -- Ressource de type clone existante

    -- *** tableau tampon des donéees existantes BIP
rec_ress_bip    RESSOURCE%ROWTYPE;    -- Ressource de référence BIP existante
rec_situ_bip    SITU_RESS%ROWTYPE;    -- Situation de référence BIP existante

    -- *** tableau tampon des donéees CLONE existantes BIP
rec_ress_clone_bip RESSOURCE%ROWTYPE;    -- Ressource de type clone existante
rec_situ_clone_bip SITU_RESS%ROWTYPE;    -- Situation clone de référence BIP existante


is_recycle integer; --1 si une ressource a ete recycle, sinon 0
-- Curseur sur la table tampon des ressources et situations
CURSOR c_tmp_ressource IS
    SELECT    type_ctra,
        localisation,
        dpg,
        fraisenv,
        ca_imputation,
        taux,
        metier,
        complexite,
        matricule_do,
        igg_do,
        siren_frs,
        id_ressource,
        igg_ressource,
        nom_ressource,
        prenom_ressource,
        date_deb_ressource,
        date_fin_ressource,
        disponibilite,
        mnt_mensuel,
        cout_total
    FROM    TMP_RESSOURCE_PRA
    ORDER BY IGG_RESSOURCE, ID_RESSOURCE, to_date(date_deb_ressource,'DD/MM/YYYY'), to_date(date_fin_ressource,'DD/MM/YYYY') ;

BEGIN
    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ': Début ressource / situation PRA : '|| to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS'));
    l_date_trait := sysdate;

    -- Purge de la table de compte rendu RESSOURCE
    -- --------------------------------- ---------
    l_etape:='Purge PRA_RESSOURCE';
        SELECT SYSDATE into l_date_trait FROM dual;

        DELETE FROM PRA_RESSOURCE
        WHERE date_trait < ADD_MONTHS(l_date_trait,-2)
        ;
        COMMIT;

    -- Boucle sur la table tempon des ressources et situations
    -- -------------------------------------------------------
    FOR rec_tmp_ress IN c_tmp_ressource LOOP
        ----------------------------------------------------------------------
        -- Controles prealables des données ressources/situation
        ----------------------------------------------------------------------

        -- Initialisations
        rec_ress := null;
        rec_situ := null;
        rec_ress_bip := null;
        rec_situ_bip := null;
        rec_ress_clone_bip := null;
        rec_situ_clone_bip := null;

        l_action_situ := null;
        l_action_ress := null;
        l_action_clone     := null;
        l_flag_clone := 0;
        l_maj := 0;
        --PPM 59958 initialisation par 0
        is_recycle  :=0;--1 si une ressource a ete recycle, sinon 0

        l_id_trace := rec_tmp_ress.id_ressource;
        l_igg_trace := rec_tmp_ress.igg_ressource;

        l_etape :='controle du code frais d''envoi';
        --------------------------------------------
        IF rec_tmp_ress.fraisenv <> 'O' and rec_tmp_ress.fraisenv <> 'N' THEN
            l_message:='Code frais d''environnement '|| rec_tmp_ress.fraisenv || ' incorrect';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
            GOTO end_loop;
        END IF;

        l_etape :='controle du type de contrat';
        ----------------------------------------
        IF rec_tmp_ress.type_ctra <> 'ATU' and rec_tmp_ress.type_ctra <> 'ATG' THEN
            l_message:='Type contrat '|| rec_tmp_ress.type_ctra || ' incorrect';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
            GOTO end_loop;
        END IF;

        l_etape :='Détermination du type de ressource';
        -----------------------------------------------
        IF rec_tmp_ress.type_ctra = 'ATU' THEN
            rec_ress.rtype := 'P';
        ELSIF rec_tmp_ress.fraisenv = 'O' THEN
            rec_ress.rtype := 'F';
        ELSIF rec_tmp_ress.fraisenv = 'N' THEN
            rec_ress.rtype := 'E';
        END IF;

        l_etape := 'Contrôle de la localisation';
        -----------------------------------------
        BEGIN
            select 1 into l_null
            from LOCALISATION
            where code_localisation = rec_tmp_ress.localisation;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_message:='Code localisation '|| rec_tmp_ress.localisation || ' incorrect';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;
        END;

        l_etape :='Détermination du mode contractuel';
        ----------------------------------------------
        IF rec_tmp_ress.type_ctra = 'ATU' THEN
            rec_situ.mode_contractuel_indicatif := 'ATU';
        ELSE

            BEGIN
                select    CODE_CONTRACTUEL
                into     rec_situ.mode_contractuel_indicatif
                from     MODE_CONTRACTUEL
                where     TYPE_RESSOURCE = rec_ress.rtype AND
                    CODE_LOCALISATION = rec_tmp_ress.localisation AND
                    TOP_ACTIF = 'O' AND
                    substr(CODE_CONTRACTUEL,-1) = 'G';
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    l_message:='Détermination du MCI impossible';
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                    GOTO end_loop;
            END;
        END IF;

        l_etape :='Détermination du nom et prénom';
        -------------------------------------------
        -- vérification de la longeur des champs
        IF length(rec_tmp_ress.nom_ressource) > 30 THEN
            l_message:='Nom de la ressource trop long';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
            GOTO end_loop;
        END IF;

        -- test la longueur
        IF rec_tmp_ress.type_ctra = 'ATU' THEN
           IF length(rec_tmp_ress.prenom_ressource) > 15 THEN
               l_message:='Prénom de la ressource trop long';
               TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
               PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
               GOTO end_loop;
           END IF;
        ELSE
           IF length(rec_tmp_ress.id_ressource) > 18 THEN
               l_message:='Nom de la ressource ATG trop long';
               TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
               PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
               GOTO end_loop;
            END IF;
        END IF;

        IF rec_tmp_ress.type_ctra = 'ATU' THEN
            rec_ress.rnom := UPPER(CONVERT(rec_tmp_ress.nom_ressource,'US7ASCII'));
            rec_ress.rprenom := UPPER(CONVERT(rec_tmp_ress.prenom_ressource,'US7ASCII'));
        ELSE
            rec_ress.rnom := UPPER(CONVERT(rec_tmp_ress.id_ressource,'US7ASCII'));
            rec_ress.rprenom := null;
        END IF;

        l_etape :='Détermination du matricule BIP';
        -------------------------------------------
        IF rec_tmp_ress.type_ctra = 'ATU' THEN

        -- le matricule doit avoir une longueur de 11 caractères et doit commencer par 'GL00'
            IF rec_tmp_ress.id_ressource is not null and
               ( length(rec_tmp_ress.id_ressource) <> 11 or upper(substr(rec_tmp_ress.id_ressource,1,4)) <> 'GL00' ) THEN
                l_message:='Matricule de la ressource incorrect';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;
            END IF;

            rec_ress.matricule := UPPER(substr(rec_tmp_ress.id_ressource,5));

        ELSE
            rec_ress.matricule := null;
        END IF;

        l_etape:='test si l''igg est numerique';
        ----------------------------------------
        BEGIN
            IF to_number(rec_tmp_ress.igg_ressource) is not null AND rec_tmp_ress.type_ctra = 'ATU' THEN
                null;
            END IF;
        EXCEPTION
            WHEN INVALID_NUMBER OR VALUE_ERROR THEN
                    l_message:='IGG ressource non numérique';
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                    GOTO end_loop;
        END;

        l_etape :='Détermination et controle de l''IGG tressource';
        -----------------------------------------------------------
        IF rec_tmp_ress.type_ctra = 'ATU' THEN
            IF rec_tmp_ress.igg_ressource is not null THEN
                -- L'IGG doit voir une longueur de 10 caractères
                IF length(to_number(rec_tmp_ress.igg_ressource)) <> 10 THEN
                    l_message:='IGG ressource '|| rec_tmp_ress.igg_ressource ||' incorrect';
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                    GOTO end_loop;
                ELSE
                    rec_ress.igg := to_number(rec_tmp_ress.igg_ressource);
                END IF;
            ELSE
                IF rec_tmp_ress.id_ressource is null THEN
                    -- les deux codes sont null = erreur
                    l_message:='Ressource indéterminable car ne comportant ni matricule ni IGG';
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                    GOTO end_loop;
                END IF;
            END IF;
        ELSE
            rec_ress.igg := null;
        END IF;

        l_etape :='Détermination du code CP';
        -------------------------------------
        IF rec_tmp_ress.matricule_do is null AND rec_tmp_ress.igg_do is null THEN
            -- les deux codes sont null = erreur
            l_message:='CP indéterminable car ne comportant ni matricule ni IGG ';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
            GOTO end_loop;
        END IF;

        l_etape:='test si l''igg DO est numerique';
        -------------------------------------------
        BEGIN
            IF to_number(rec_tmp_ress.igg_do) is not null THEN
                null;
            END IF;
        EXCEPTION
            WHEN INVALID_NUMBER OR VALUE_ERROR THEN
                    l_message:='IGG CP non numérique';
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                    GOTO end_loop;
        END;

    -- le matricule CP doit avoir une longeur de 11
        IF rec_tmp_ress.matricule_do is not null and
           ( length(rec_tmp_ress.matricule_do) <> 11 or substr(rec_tmp_ress.matricule_do,1,4) <> 'GL00' ) THEN
             l_message:='Matricule CP de la ressource incorrect';
             TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
             PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
             GOTO end_loop;
        END IF;


        l_etape :='Détermination et controle de l''IGG DO';
        -----------------------------------------------------------
            -- L'IGG doit voir une longueur de 10 caractères
            IF rec_tmp_ress.igg_do is not null and length(to_number(rec_tmp_ress.igg_do)) <> 10 THEN
                l_message:='IGG CP '|| rec_tmp_ress.igg_do ||' incorrect';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;
            END IF;

        -- on cherche d'abord par l'IGG CP
        IF rec_tmp_ress.igg_do is not null THEN
            BEGIN
                SELECT   IDENT
                INTO     rec_situ.cpident
                FROM     RESSOURCE
                WHERE    RTYPE = 'P' AND
                         IGG =  to_number(rec_tmp_ress.igg_do);
            EXCEPTION
                WHEN TOO_MANY_ROWS THEN
                    l_message:='Plusieurs CP Bip trouvés avec l''IGG '||rec_tmp_ress.igg_do;
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                    GOTO end_loop;
                WHEN NO_DATA_FOUND THEN
                    l_message:='CP indéterminable car aucune ressource n''existe avec cet IGG '||rec_tmp_ress.igg_do;
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                    GOTO end_loop;
            END;
        ELSE
            -- Sinon recherche sur le matricule CP
            BEGIN
                SELECT    IDENT
                INTO     rec_situ.cpident
                FROM    RESSOURCE
                WHERE    RTYPE = 'P' AND
                    MATRICULE = substr(rec_tmp_ress.matricule_do,5);
            EXCEPTION
                WHEN TOO_MANY_ROWS THEN
                    l_message:='Plusieurs CP Bip trouvées avec le matricule '||substr(rec_tmp_ress.matricule_do,5);
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                    GOTO end_loop;
                WHEN NO_DATA_FOUND THEN
                    l_message:='CP indéterminable car aucune ressource n''existe avec ce matricule '||substr(rec_tmp_ress.matricule_do,5) ;
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                    GOTO end_loop;
            END;
        END IF;

        l_etape :='Contrôle de la disponibilité ';
        ------------------------------------------
        IF rec_tmp_ress.type_ctra = 'ATU' THEN
            IF rec_tmp_ress.disponibilite is not null THEN
                -- Controle que la disponibilité est numérique
                BEGIN
                    rec_situ.dispo := to_number(rec_tmp_ress.disponibilite,'9.9','NLS_NUMERIC_CHARACTERS = ''. ''');

                    IF rec_situ.dispo > 5 OR rec_situ.dispo < 0 THEN
                        rec_situ.dispo := 5;
                    END IF;

                EXCEPTION
                    WHEN INVALID_NUMBER OR VALUE_ERROR THEN
                        l_message:='Disponibilité de la ressource incorrecte  '|| rec_tmp_ress.disponibilite;
                        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                        PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                        GOTO end_loop;
                END;
            ELSE
                rec_situ.dispo := 5;
            END IF;
        ELSE
            rec_situ.dispo := null;
        END IF;

        l_etape:='Détermination et contrôle des dates de situation';
        ------------------------------------------------------------
        -- transformation et controle format date
        BEGIN
            rec_situ.datsitu := trunc(to_date(rec_tmp_ress.date_deb_ressource,'DD/MM/YYYY'),'MONTH');
            rec_situ.datdep := to_date(rec_tmp_ress.date_fin_ressource,'DD/MM/YYYY');
        EXCEPTION
            WHEN ANO_DATE OR ANO_DATE2 OR ANO_DATE3 THEN
                l_message:='Format date début ressource ou date fin incorrect';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;
            WHEN OTHERS THEN
                l_message:='Format date début ressource ou date fin incorrect';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;
        END;

        -- la date de fin ne peut etre supérieur a la date de début
        IF to_date(rec_tmp_ress.date_deb_ressource,'DD/MM/YYYY') > to_date(rec_tmp_ress.date_fin_ressource,'DD/MM/YYYY') THEN
            l_message:='Incohérence sur les dates de la ressource';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
            GOTO end_loop;
        END IF;

        -- controle et transformation de la date de début
        IF rec_situ.datsitu is null THEN
            l_message:='La date de début ressource n''est pas renseignée';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
            GOTO end_loop;
        ELSE
            -- la date de début est positionnée au premier jour du mois
            rec_situ.datsitu := trunc(rec_situ.datsitu,'MM');
        END IF;

-- debut PPM 58858 : modification du contrôle du DPG (flux de ressources)
        l_etape:='Contrôle du DPG';
        ---------------------------
        BEGIN
            SELECT  TOPFER, DATE_EFFET
            INTO    l_topfer, L_DATE_EFFET
            FROM    STRUCT_INFO
            WHERE   CODSG = rec_tmp_ress.dpg;
            -- AND TOPFER = 'O';
            rec_situ.codsg := rec_tmp_ress.dpg;-- QC 1620

      -- Si DPG correspond  a un DPG inactif (TOPFER='F')
      IF (l_topfer = 'F') THEN
        --Si la < Date de fin ressource > est egale ou ulterieure a la date du jour,
        --alors rejeter la ressource avec le libelle « DPG inactif », et passer a la suivante QC 1635
        IF L_DATE_EFFET IS NULL THEN
        IF to_date(rec_tmp_ress.date_fin_ressource,'DD/MM/YYYY') >= sysdate THEN
        l_message:='DPG inactif : '||rec_tmp_ress.dpg;
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;
        END IF;
         ELSE
           IF to_date(rec_tmp_ress.date_fin_ressource,'DD/MM/YYYY') > L_DATE_EFFET THEN
                l_message:='DPG inactif : '||rec_tmp_ress.dpg;
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;          
          END IF;
      END IF;
        
      END IF;
      -- si pas de DPG, on affiche un message de rejet "DPG inconnu"
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_message:='DPG inconnu : '||rec_tmp_ress.dpg;
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;
        END;
-- fin PPM 58858 : modification du contrôle du DPG (flux de ressources)
--  debut PPM 58858 : supression de controle de compatibilite de libelle (flux de ressources)
--        l_etape:='controle compatibilité du libelle';
--        ---------------------------------------------
--        BEGIN
--
--            SELECT  LILOES
--            INTO    l_librca
--            FROM    ENTITE_STRUCTURE
--            WHERE   CODCAMO = l_centractiv;
--
--
--
--            -- controle compatibilité du libelle
--            IF UPPER(TRIM(l_librca)) <> UPPER(TRIM(rec_tmp_ress.ca_imputation)) THEN
--                l_message:='Le CA fourni n''est pas compatible avec celui du DPG';
--                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
--                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
--                GOTO end_loop;
--            END IF;
--
--        EXCEPTION
--            WHEN NO_DATA_FOUND THEN
--                l_message:='Le centre d''activité est inconnu';
--                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
--                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
--                GOTO end_loop;
--        END;
--  fin PPM 58858 : supression de controle de compatibilite de libelle (flux de ressources)




        l_etape :='Détermination et controle de la societe';
        ----------------------------------------------------
        BEGIN
            SELECT     distinct SOCCODE
            INTO     rec_situ.soccode
            FROM    AGENCE
            WHERE    SIREN = rec_tmp_ress.siren_frs AND
                ACTIF = 'O';

        EXCEPTION
            WHEN TOO_MANY_ROWS THEN
                l_message:='Détermination de la société bip impossible';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;
            WHEN NO_DATA_FOUND THEN
                l_message:='Société avec ce SIREN inconnue ou inactive en bip';
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;
        END;

        l_etape:='Détermination du code prestation et Contrôle de la société';
        ----------------------------------------------------------------------
        -- reconstitution du libelle prestation
        CASE UPPER(rec_tmp_ress.complexite)
            WHEN 'NIVEAU 1' THEN l_complexite := rec_tmp_ress.metier || ' - standard';
            WHEN 'NIVEAU 2' THEN l_complexite := rec_tmp_ress.metier || ' - assez complexe';
            WHEN 'NIVEAU 3' THEN l_complexite := rec_tmp_ress.metier || ' - complexe';
            WHEN 'NIVEAU 4' THEN l_complexite := rec_tmp_ress.metier || ' - très complexe';
        ELSE
            l_message:='Complexité incohérente : '||rec_tmp_ress.complexite;
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
            GOTO end_loop;
        END CASE ;

        l_etape:='recherche et controle du libelle prestation';

        BEGIN
            SELECT     PRESTATION
            INTO    rec_situ.prestation
            FROM    PRESTATION
            WHERE    ( RTYPE = rec_ress.rtype OR RTYPE = '*' ) AND
                TOP_ACTIF = 'O' AND
                UPPER(CONVERT(LIBPREST, 'US7ASCII')) = UPPER(CONVERT(l_complexite, 'US7ASCII'));

        EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                l_message:='Détermination de la prestation Bip et/ou de sa complexité impossible';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;
        END;

        l_etape:='Contrôle du cout unitaire';
        -------------------------------------
        IF rec_tmp_ress.taux is not null THEN
            -- Controle que le cout est numérique
            BEGIN
                rec_situ.cout := to_number(rec_tmp_ress.taux,'9999999999.99','NLS_NUMERIC_CHARACTERS = ''. ''');

                IF rec_situ.cout < 0 THEN
                    RAISE INVALID_NUMBER;
                END IF;

            EXCEPTION
                WHEN INVALID_NUMBER OR VALUE_ERROR THEN
                    l_message:='Coût unitaire de la ressource incorrect : '|| rec_tmp_ress.taux;
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                    GOTO end_loop;
            END;
        ELSE
            rec_situ.cout := 0;
        END IF;

        l_etape:='Contrôle du cout total';
        ----------------------------------
        IF rec_tmp_ress.cout_total is not null AND rec_tmp_ress.type_ctra <> 'ATU' THEN
            -- Controle que le cout est numérique
            BEGIN
                rec_ress.coutot := to_number(rec_tmp_ress.cout_total,'9999999999.99','NLS_NUMERIC_CHARACTERS = ''. ''');

                IF rec_ress.coutot < 0 THEN
                    RAISE INVALID_NUMBER;
                END IF;

            EXCEPTION
                WHEN INVALID_NUMBER OR VALUE_ERROR THEN
                    l_message:='Coût total de la ressource incorrect : '|| rec_tmp_ress.cout_total;
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                    GOTO end_loop;
            END;
        ELSE
            rec_ress.coutot := 0;
        END IF;

        l_etape:='Contrôle du montant mensuel';
        -------------------------------------
        IF rec_tmp_ress.type_ctra = 'ATG' THEN
            IF rec_tmp_ress.mnt_mensuel is not null and rec_tmp_ress.mnt_mensuel != '0' and rec_tmp_ress.mnt_mensuel != '0.0' and rec_tmp_ress.mnt_mensuel != '0.00' THEN

                -- Controle que la disponibilité est numérique et que son format est correct
                BEGIN
                    rec_situ.montant_mensuel := to_number(rec_tmp_ress.mnt_mensuel,'9999999999.99','NLS_NUMERIC_CHARACTERS = ''. ''');
                    IF rec_situ.montant_mensuel < 0 THEN
                        RAISE INVALID_NUMBER;
                    END IF;

                EXCEPTION
                    WHEN INVALID_NUMBER OR VALUE_ERROR THEN
                        l_message:='Montant mensuel du contrat incorrect';
                        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                        PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                        GOTO end_loop;
                END;
            ELSE
                rec_situ.montant_mensuel := null;
            END IF;
        ELSE
            rec_situ.montant_mensuel := null;
        END IF;

        ----------------------------------------------------------------------
        -- Fin des controles prealables des données ressources/situation
        -- Détermination des actions sur les tables
        ----------------------------------------------------------------------

        l_etape:='Recherche d''une ressource du contrat existante';
        BEGIN
            IF rec_tmp_ress.type_ctra = 'ATG' THEN
                l_req_where := ' UPPER(RNOM) = '''|| to_char(rec_ress.rnom) ||''' AND RPRENOM IS NULL';
            ELSE
                -- recherche par l'IGG s'il existe sinon par le matricule gershwin
                IF rec_tmp_ress.igg_ressource is not null THEN --recherche par l'IGG
                    l_req_where := ' IGG = '|| to_char(rec_ress.igg);
                ELSE -- recherche par le matricule
                    l_req_where := ' UPPER(MATRICULE) = '''|| rec_ress.matricule||'''';
                END IF;
            END IF;

            -- constitution de la requete dynamique pour ressource principale
            -- on peut se permettre le select * car structure acceuil est %ROWTYPE
            l_requete := 'SELECT * FROM RESSOURCE WHERE' || l_req_where;

            -- Execution de la requete dynamique
            EXECUTE IMMEDIATE l_requete INTO rec_ress_bip ;

            -- on trouve une ressource, donc on va tenter de faire une modification
        -- C'est la procédure qui déterminera si il y a eu une modification
        l_action_ress := 'MOD_RESS';
        l_action_situ := 'MOD_SITU';

            -- on recherche s'il existe une situation sur la resource exitante tel que
            -- les dates de situation de la ressources sont égales à celles du flux (SFD V5)
            BEGIN
                l_etape:='Recherche d''une situation identique pour la ressource principale';

                SELECT     *
                INTO       rec_situ_bip
                FROM       SITU_RESS
                WHERE      IDENT = rec_ress_bip.ident AND
                           rec_situ.datdep = DATDEP AND
                           rec_situ.datsitu = DATSITU AND
                           ROWNUM < 2;

                -- la situation identique est trouvée alors pas d'analyse de situation ni de clone
        -- on est en modification simple de situation
                l_action_situ := 'MOD_SITU';
                GOTO fin_test_situ;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    null;
            END;

            -- Recherche existance d'un clone
            l_etape:='Recherche d''un clone pour la ressource';
            BEGIN
                IF rec_tmp_ress.type_ctra = 'ATG' THEN
                    l_req_where_cl := ' UPPER(RNOM) = '''|| to_char(rec_ress.rnom) ||''' AND UPPER(RPRENOM) = ''CLONE-'||to_char(rec_ress_bip.ident)||'''';
                ELSE
                    -- recherche par l'IGG clone s'il existe sinon par le matricule gershwin
                    IF rec_tmp_ress.igg_ressource is not null THEN --recherche par l'IGG
                        l_req_where_cl := ' IGG = '||'9'||SUBSTR(to_char(rec_ress.igg),2);
                    ELSE -- recherche par le matricule clone
                        l_req_where_cl := ' UPPER(MATRICULE) = ''Y'||SUBSTR(rec_ress.matricule,2)||'''';
                    END IF;
                END IF;
                -- constitution de la requete dynamique pour ressource principale
                l_requete := 'SELECT * FROM RESSOURCE WHERE' || l_req_where_cl;

                -- Execution de la requete dynamique
                EXECUTE IMMEDIATE l_requete INTO rec_ress_clone_bip ;

                -- On positionne le flag de présence de clone
                l_flag_clone := 1;

            EXCEPTION
                WHEN TOO_MANY_ROWS THEN
                        l_message:='Détermination du clone ' || rec_tmp_ress.type_ctra || ' Bip impossible';
                        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                        PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                        GOTO end_loop;
                WHEN NO_DATA_FOUND THEN
                    l_flag_clone := 0;
            END;

        EXCEPTION
            WHEN TOO_MANY_ROWS THEN
                l_message:='Détermination de la ressource ' || rec_tmp_ress.type_ctra || ' impossible';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;
            WHEN NO_DATA_FOUND THEN
                l_action_ress := 'CRE_RESS';
                l_action_situ := 'CRE_SITU';
        END;

    -- si on est en création de ressource il n'y a pas de contrôle de situation à réaliser
    -- car on est automatiquement en creation de situation.
    IF l_action_ress <> 'CRE_RESS' THEN

        l_etape:='Recherche si il existe au moins une situation existante';
        BEGIN -- cas 1 pas de situation existante
            SELECT     1
            INTO     l_null
            FROM    SITU_RESS
            WHERE    ( IDENT = rec_ress_bip.ident OR
                  (IDENT = rec_ress_clone_bip.ident AND l_flag_clone = 1) )  AND
                ROWNUM < 2;

            l_action_situ := 'MOD_SITU';

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_action_situ := 'CRE_SITU';
                GOTO fin_test_situ;
        END;

        -- On recherche d'abord une situation correspondante sur le clone si il existe
        IF l_flag_clone = 1 then
            BEGIN
                l_etape:='recherche d''une situation clone existante correspondante';
                SELECT *
                INTO    rec_situ_clone_bip
                FROM    SITU_RESS
                WHERE    (DATSITU = trunc(rec_situ.datsitu,'MONTH') OR DATDEP = rec_situ.datdep OR (rec_situ.datsitu >= DATSITU AND rec_situ.datdep <= DATDEP)) AND
                    IDENT = rec_ress_clone_bip.ident;

                l_action_situ := 'MOD_SITU_CLONE';

            EXCEPTION
                WHEN NO_DATA_FOUND THEN null;
                WHEN TOO_MANY_ROWS THEN
                   l_message:='Cas de modification de situation de clone non géré : à traiter en manuel';
                   TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                   PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                   GOTO end_loop;
            END;
        END IF;

        -- cas 3 des SFD
        l_etape:='Recherche si il existe une situation antérieur non fermée';
        BEGIN
            SELECT    1
            INTO     l_null
            FROM    SITU_RESS
            WHERE    rec_situ.datsitu >= DATSITU AND
                DATDEP IS null AND
                IDENT = decode(l_action_situ,'MOD_SITU_CLONE',rec_ress_clone_bip.ident,rec_ress_bip.ident);

            l_message:='Situation existante sans date de fin';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
            GOTO end_loop;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN null;
        END;

        -- Répond à tous les cas de chevauchement des SFD (cas 1,2,4,5,7,11)
        BEGIN
            l_etape:='Recherche si il y a chevauchement sur une situation ultérieure';
            SELECT    1
            INTO     l_null
            FROM    SITU_RESS
            WHERE    rec_situ.datsitu < DATSITU AND
                rec_situ.datdep >= DATSITU AND
                --IDENT = decode(l_flag_clone,1,rec_ress_clone_bip.ident,rec_ress_bip.ident) AND
                IDENT = decode(l_action_situ,'MOD_SITU_CLONE',rec_ress_clone_bip.ident,rec_ress_bip.ident) AND
                rownum < 2; -- un seul suffit

            l_message:='Chevauchement avec situation existante';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
            GOTO end_loop;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN null;
        END;

        -- Si pas de situation clone alors on recherche sur la situation ressource principale
        IF l_action_situ <> 'MOD_SITU_CLONE' THEN

            BEGIN
                l_etape:='recherche d''une situation existante correspondante';
                SELECT    *        -- on peut se permettre le select * car structure acceuil est %ROWTYPE
                INTO    rec_situ_bip
                FROM     SITU_RESS
                WHERE    IDENT = rec_ress_bip.ident AND
                    (
                        rec_situ.datsitu BETWEEN DATSITU and DATDEP
                        OR -- cas 10 et 11
                        (to_date(rec_tmp_ress.date_deb_ressource,'DD/MM/YYYY') > rec_situ_bip.datdep AND
                         to_char(rec_situ.datsitu,'YYYYMM') = to_char(rec_situ_bip.datdep,'YYYYMM') )
                    );

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- cas 1 et 4 des SFD
                    l_action_situ := 'CRE_SITU';
                WHEN TOO_MANY_ROWS THEN
                    l_message:='Détermination de la situation bip impossible';
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                    GOTO end_loop;
            END;
        END IF;
    END IF;

    IF l_action_situ <> 'CRE_SITU' THEN

        -- On test les différends cas de modification de date de situation
        -- ---------------------------------------------------------------

        -- Test des situation sur clone
        -- ----------------------------
        IF l_action_situ = 'MOD_SITU_CLONE' THEN

            -- Si les dates debut et de fin de la situation trouvées sont identiques
            -- à celles envoyées par PAC alors il n'y a pas besoin de les controler.
            IF rec_situ.datsitu = rec_situ_clone_bip.datsitu AND rec_situ.datdep = rec_situ_clone_bip.datdep THEN

               GOTO fin_test_situ;

            END IF;

            -- cas 6 -- inclusion de date
            IF to_char(rec_situ.datsitu,'YYYYMM') > to_char(rec_situ_clone_bip.datsitu,'YYYYMM') AND  rec_situ.datdep < rec_situ_clone_bip.datdep THEN
                l_message:='Cas ambigu de comparaison de date sur clone';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;
            END IF;

            -- cas 6 bis Modification date de fin
            IF to_char(rec_situ.datsitu,'YYYYMM') = to_char(rec_situ_clone_bip.datsitu,'YYYYMM') AND rec_situ.datdep < rec_situ_clone_bip.datdep THEN
                -- la date de fin recu devient la nouvelle date : arrêt anticipé
                --l_action_situ := 'MOD_SITU_CLONE';
                l_action_clone := 'MOD_CLONE';
                GOTO fin_test_situ;
            END IF;

            -- Prolongation de situation clone
            IF -- cas 8 et 9
               to_char(rec_situ.datsitu,'YYYYMM') = to_char(rec_situ_clone_bip.datsitu,'YYYYMM') AND
               rec_situ.datsitu < rec_situ_clone_bip.datdep AND
               to_char(rec_situ.datdep,'YYYYMM') = to_char(rec_situ_clone_bip.datdep,'YYYYMM') THEN
                -- on garde la date de debut bip et la date de fin est celle provenant de pac
                l_action_clone := 'MOD_CLONE';
                rec_situ.datsitu := rec_situ_clone_bip.datsitu;
                GOTO fin_test_situ;
            END IF;

            -- test cas 5 et 7 : Prolongation
            IF to_char(rec_situ.datsitu,'YYYYMM') = to_char(rec_situ_clone_bip.datsitu,'YYYYMM') AND
               rec_situ.datsitu < rec_situ_clone_bip.datdep AND
               to_char(rec_situ.datdep,'YYYYMM') > to_char(rec_situ_clone_bip.datdep,'YYYYMM') THEN
               -- On prolonge la date de fin de la situation à celle fournie par pra
               -- la date de deb est au 1er du mois (déjà calculé)
               l_action_clone := 'MOD_CLONE';
               GOTO fin_test_situ;
            END IF;

            -- A partir de ce cas si on est en modification de situation sur clone, on ne sait plus gérer
            -- le cas en automatique :
            l_message:='Cas de modification de situation de clone non géré : à traiter en manuel';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
            GOTO end_loop;
        END IF;

        -- Test de situation sur ressource principale
        -- -------------------------------------------

        -- Si les dates debut et de fin de la situation trouvées sont identiques
        -- à celles envoyées par PAC alors il n'y a pas besoin de les controler.
        IF (rec_situ.datsitu = rec_situ_bip.datsitu AND rec_situ.datdep = rec_situ_bip.datdep ) THEN
           GOTO fin_test_situ;

        END IF;

        -- test cas 10 et 11 en premier : création clone (si celui ci n'existe pas)
        IF to_date(rec_tmp_ress.date_deb_ressource,'DD/MM/YYYY') > rec_situ_bip.datdep AND
           to_char(rec_situ.datsitu,'YYYYMM') = to_char(rec_situ_bip.datdep,'YYYYMM') THEN

            IF l_flag_clone <> 1 THEN
                -- creation d'un clone
            l_action_clone := 'CRE_CLONE';
            ELSE
                -- sinon modification des données du clone
                l_action_clone := 'MOD_CLONE';
            END IF;

            -- création d'une situation sur le clone
            l_action_situ := 'CRE_SITU_CLONE';

            GOTO fin_test_situ;
        END IF;

        -- test cas 2 création clone (si celui ci n'existe pas)
        IF rec_situ.datsitu > rec_situ_bip.datsitu AND
           to_char(rec_situ_bip.datdep,'YYYYMM') = to_char(rec_situ.datsitu,'YYYYMM') THEN

       IF l_flag_clone <> 1 THEN
                -- creation d'un clone
            l_action_clone := 'CRE_CLONE';
           ELSE
                -- sinon modification des données du clone
                l_action_clone := 'MOD_CLONE';
           END IF;

        -- création d'une situation sur le clone
            l_action_situ := 'CRE_SITU_CLONE';

            GOTO fin_test_situ;
        END IF;

        -- test cas 5 et 7 : Prolongation
        IF to_char(rec_situ.datsitu,'YYYYMM') = to_char(rec_situ_bip.datsitu,'YYYYMM') AND
           rec_situ.datsitu < rec_situ_bip.datdep AND
           to_char(rec_situ.datdep,'YYYYMM') > to_char(rec_situ_bip.datdep,'YYYYMM') THEN
            -- On prolonge la date de fin de la situation à celle fournie par pra
            -- la date de deb est au 1er du mois (déjà calculé)

            l_action_situ := 'MOD_SITU';

            GOTO fin_test_situ;
        END IF;

        -- cas 6 inclusion de date
        IF to_char(rec_situ.datsitu,'YYYYMM') > to_char(rec_situ_bip.datsitu,'YYYYMM') AND rec_situ.datdep < rec_situ_bip.datdep THEN
            l_message:='Cas ambigu de comparaison de date situation';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
            GOTO end_loop;
        END IF;

        -- Cas 4 : rejet pour englobement
        IF  rec_situ.datsitu < rec_situ_bip.datsitu AND rec_situ.datdep >= rec_situ_bip.datsitu THEN
            l_message:='Situation antérieure en chevauchement avec situation existante';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
            GOTO end_loop;
        END IF;

        -- cas 6 bis Modification date de fin
        IF to_char(rec_situ.datsitu,'YYYYMM') = to_char(rec_situ_bip.datsitu,'YYYYMM') AND rec_situ.datdep < rec_situ_bip.datdep THEN
            -- la date de fin recu devient la nouvelle date : arrêt anticipé
            l_action_situ := 'MOD_SITU';

            GOTO fin_test_situ;
        END IF;

        -- cas 12 : modification de date de début de contrat
        IF rec_situ.datsitu > rec_situ_bip.datsitu AND rec_situ.datdep = rec_situ_bip.datdep THEN
            -- On modifie la situation avec les dates déjà positionnées
            l_action_situ := 'MOD_SITU';

            GOTO fin_test_situ;
        END IF;

        -- cas 8 et 9 : modification de date de début de contrat
        IF to_char(rec_situ.datsitu,'YYYYMM') = to_char(rec_situ_bip.datsitu,'YYYYMM') AND
           rec_situ.datsitu < rec_situ_bip.datdep AND
           to_char(rec_situ.datdep,'YYYYMM') = to_char(rec_situ_bip.datdep,'YYYYMM') THEN
            -- On prolonge la date de fin de la situation à celle fournie par pra
            -- la date de deb est au 1er du mois (déjà calculé)

            l_action_situ := 'MOD_SITU';

            GOTO fin_test_situ;
        END IF;

        -- A ce stade, on ne sait plus controler les dates de situation en automatique alors on rejette
        -- pour qu'il y ait un controle manuel.
        l_message:='Cas ambigu de comparaison de date';
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
        PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
        GOTO end_loop;

    END IF;

    <<fin_test_situ>>

        -------------------------
        -- Mises à jour ressource
        -------------------------

        IF l_action_ress = 'CRE_RESS' THEN

            l_etape:='appel de la procedure de création de ressource';
            PACK_PRA_RESS_CONT.P_CRE_RESSOURCE(    P_HFILE,
                                l_date_trait,
                                rec_tmp_ress,
                                rec_ress,
                                rec_situ,
                                0,
                                is_recycle); -- ressource principale

            -- la nouvelle structure est stockée
            rec_ress_bip := rec_ress;
        END IF;

        IF l_action_ress = 'MOD_RESS' THEN
            -- l'ident est celui de la ressource principale
            rec_ress.ident := rec_ress_bip.ident;
            l_etape:='appel de la procedure de Modification de ressource';
            PACK_PRA_RESS_CONT.P_MOD_RESSOURCE(    P_HFILE,
                                l_date_trait,
                                rec_tmp_ress,
                                rec_ress,
                                rec_situ,
                                rec_ress_bip,
                                0,
                                l_maj);

            -- Si la ressource est réellement modifiée dans ce cas on fera une modification de clone s'il existe
        -- SYNCHRONISATION
            IF l_flag_clone = 1 AND l_maj =1 THEN

                -- l'ident est celui du clone
                rec_ress.ident := rec_ress_clone_bip.ident;

                l_etape:='transformation des données de type clone';
                IF rec_tmp_ress.type_ctra = 'ATG' THEN
                    rec_ress.rprenom := 'CLONE-'||to_char(rec_ress.ident);
                ELSE
                    IF rec_ress.igg is not null THEN
                        rec_ress.igg := '9'||SUBSTR(to_char(rec_ress.igg),2);
                    END IF;
                    IF rec_ress.matricule is not null THEN
                        rec_ress.matricule := 'Y'||SUBSTR(rec_ress.matricule,2);
                    END IF;
                END IF;

                -- l'ident est celui du clone
                rec_ress.ident := rec_ress_clone_bip.ident;
                l_etape:='appel de la procedure de Modification de ressource';
                PACK_PRA_RESS_CONT.P_MOD_RESSOURCE(    P_HFILE,
                                    l_date_trait,
                                    rec_tmp_ress,
                                    rec_ress,
                                    rec_situ,
                                    rec_ress_clone_bip,
                                    1,
                                    l_maj);
            END IF;
        END IF;

        IF l_action_clone = 'CRE_CLONE' THEN

              -- Sauvegarde des données initiales
              l_save_rprenom :=  rec_ress.rprenom;
              l_save_igg := rec_ress.igg;
              l_save_matricule := rec_ress.matricule;

              l_etape:='transformation des données de type clone';
              IF rec_tmp_ress.type_ctra = 'ATG' THEN
                  rec_ress.rprenom := 'CLONE-'||to_char(rec_ress.ident);
              ELSE
                  IF rec_ress.igg is not null THEN
                      rec_ress.igg := '9'||SUBSTR(to_char(rec_ress.igg),2);
                  ELSE
                      --On recherche la ressource principale et si elle a un IGG on l'affecte au clone
                      select igg into l_igg_ress_princ from ressource where matricule = l_save_matricule;
                      IF l_igg_ress_princ is not null THEN
                        rec_ress.igg := '9'||SUBSTR(to_char(l_igg_ress_princ),2);
                      END IF;
                  END IF;
                  IF rec_ress.matricule is not null THEN
                      rec_ress.matricule := 'Y'||SUBSTR(rec_ress.matricule,2);
                  ELSE
                      --On recherche la ressource principale et si elle a un matricule on l'affecte au clone
                      select matricule into l_matricule_ress_princ from ressource where igg = l_save_igg;
                      IF l_matricule_ress_princ is not null THEN
                        rec_ress.matricule := 'Y'||SUBSTR(l_matricule_ress_princ,2);
                      END IF;
                  END IF;
              END IF;

              l_etape:='appel de la procedure de création du clone de ressource';
              PACK_PRA_RESS_CONT.P_CRE_RESSOURCE(    P_HFILE,
                                  l_date_trait,
                                  rec_tmp_ress,
                                  rec_ress,
                                  rec_situ,
                                  1,
                                  is_recycle); -- clone

              -- la nouvelle structure est stockée
              rec_ress_clone_bip := rec_ress;

              -----------------------------------------------------------------
        -- on tente de faire une SYNCHRONISATION données de la ressource
              -----------------------------------------------------------------
              -- on rétablit les données ressources initiales

                  rec_ress.rprenom := l_save_rprenom;
                  rec_ress.igg := l_save_igg;
                  rec_ress.matricule := l_save_matricule;

                   -- l'ident est celui de la ressource principale
                  rec_ress.ident := rec_ress_bip.ident;

                  l_etape:='appel de la procedure de Modification de ressource';
                  PACK_PRA_RESS_CONT.P_MOD_RESSOURCE(    P_HFILE,
                                      l_date_trait,
                                      rec_tmp_ress,
                                      rec_ress,
                                      rec_situ,
                                      rec_ress_bip,
                                      0,
                                      l_maj);

        END IF;

        IF l_action_clone = 'MOD_CLONE' THEN

            -- Sauvegarde des données initiales
            l_save_rprenom :=  rec_ress.rprenom;
            l_save_igg := rec_ress.igg;
            l_save_matricule := rec_ress.matricule;

            l_etape:='transformation des données de type clone';
            IF rec_tmp_ress.type_ctra = 'ATG' THEN
                rec_ress.rprenom := 'CLONE-'||to_char(rec_ress.ident);
            ELSE
                IF rec_ress.igg is not null THEN
                    rec_ress.igg := '9'||SUBSTR(to_char(rec_ress.igg),2);
                END IF;
                IF rec_ress.matricule is not null THEN
                    rec_ress.matricule := 'Y'||SUBSTR(rec_ress.matricule,2);
                END IF;
            END IF;

            -- l'ident est celui du clone
            rec_ress.ident := rec_ress_clone_bip.ident;
            l_etape:='appel de la procedure de Modification du clone de ressource';
            PACK_PRA_RESS_CONT.P_MOD_RESSOURCE(    P_HFILE,
                                l_date_trait,
                                rec_tmp_ress,
                                rec_ress,
                                rec_situ,
                                rec_ress_clone_bip,
                                1,
                                l_maj);

            -- Si le clone est réellement modifié, on fera une modification de la ressource
        -- SYNCHRONISATION
            IF l_maj = 1 THEN

                -- on rétablit les données ressources initiales
                rec_ress.rprenom := l_save_rprenom;
                rec_ress.igg := l_save_igg;
                rec_ress.matricule := l_save_matricule;

                -- l'ident est celui de la ressource principale
                rec_ress.ident := rec_ress_bip.ident;

                l_etape:='appel de la procedure de Modification de ressource';
                PACK_PRA_RESS_CONT.P_MOD_RESSOURCE(    P_HFILE,
                                    l_date_trait,
                                    rec_tmp_ress,
                                    rec_ress,
                                    rec_situ,
                                    rec_ress_bip,
                                    0,
                                    l_maj);
            END IF;
        END IF;

    --Si la ressource n'a pas été recycler pendant une creation de ressource
    IF is_recycle = 0 THEN
        -------------------------
        -- Mises à jour situation
        -------------------------

        IF l_action_situ = 'CRE_SITU' THEN

            -- l'ident situation est celui de la ressource principale
            rec_situ.ident := rec_ress_bip.ident;
            rec_ress.ident := rec_ress_bip.ident;
            rec_ress.igg := rec_ress_bip.igg;
            rec_ress.matricule := rec_ress_bip.matricule;


            -- SGA PPM 33018 Ajout d'une vérification si il y a un chevauchement entre la date de départ et la date de fin existante
            IF  (verif_situ(rec_situ.ident,rec_situ.datsitu,rec_situ.datdep) >0)
            THEN
                l_message:='Rejet insertion de situation en chevauchement';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;
            END IF;

            l_etape:='appel de la procedure de création de situation pour la ressource principale';
            PACK_PRA_RESS_CONT.P_CRE_SITUATION (P_HFILE,
                        l_date_trait,
                        rec_tmp_ress,
                        rec_ress,
                        rec_situ,
                        0    );
        END IF;

        IF l_action_situ = 'CRE_SITU_CLONE' THEN

            -- l'ident situation est celui de la ressource principale
            rec_situ.ident := rec_ress_clone_bip.ident;
            --l'ident de la ressource est celui du clone
            rec_ress.ident := rec_ress_clone_bip.ident;


            --MAJ matricule et IGG pour le clone
            IF rec_ress.igg is not null THEN
              rec_ress.igg := '9' ||SUBSTR(to_char(rec_ress.igg),2);
            END IF;
            IF rec_ress.matricule is not null THEN
               rec_ress.matricule := 'Y'||SUBSTR(rec_ress.matricule,2);
            END IF;

            -- SGA PPM 33018 Ajout d'une vérification si il y a un chevauchement entre la date de départ et la date de fin existante
            IF  (verif_situ(rec_situ.ident,rec_situ.datsitu,rec_situ.datdep) >0)
            THEN
                l_message:='Rejet insertion de situation en chevauchement';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    l_date_trait, rec_tmp_ress, rec_ress, rec_situ, 0, l_message);
                GOTO end_loop;
            END IF;

            l_etape:='appel de la procedure de création de situation pour le clone';
            PACK_PRA_RESS_CONT.P_CRE_SITUATION (P_HFILE,
                        l_date_trait,
                        rec_tmp_ress,
                        rec_ress,
                        rec_situ,
                        1    );
        END IF;

        IF l_action_situ = 'MOD_SITU' THEN
            -- l'ident situation est celui de la ressource principale
            rec_situ.ident := rec_situ_bip.ident;
            rec_ress.ident := rec_situ_bip.ident;
            rec_ress.igg := rec_ress_bip.igg;
            rec_ress.matricule := rec_ress_bip.matricule;

            l_etape:='appel de la procedure de modification de situation pour la ressource principale';
            P_MOD_SITUATION (    P_HFILE,
                        l_date_trait,
                        rec_tmp_ress,
                        rec_ress,
                        rec_situ,
                        rec_situ_bip,
                        0,
                        l_maj    );
        END IF;

        IF l_action_situ = 'MOD_SITU_CLONE' THEN
            -- l'ident situation est celui du clone
            rec_situ.ident := rec_ress_clone_bip.ident;

            l_etape:='appel de la procedure de modification de situation pour le clone';
            P_MOD_SITUATION (    P_HFILE,
                        l_date_trait,
                        rec_tmp_ress,
                        rec_ress,
                        rec_situ,
                        rec_situ_clone_bip,
                        1,
                        l_maj    );
        END IF;
    END IF;
        -- fin normal des controles ressource/situation on peut faire un commit
        -------
        COMMIT;
        -------

    <<end_loop>> -- label de GOTO permettant de continuer à ligne tampon suivante
        null;
    END LOOP;

    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Fin normale '|| to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS') );

EXCEPTION
    WHEN CALL_ABORT THEN
        RAISE_APPLICATION_ERROR(-20100,
                    'Arrêt du BATCH provoqué suite à anomalie : consulter la log',false);
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : Etape = '|| l_etape);
    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : Ident technique : ' || l_id_trace || ' IGG : ' || l_igg_trace);
        RAISE_APPLICATION_ERROR(-20200,
                    'Arrêt du BATCH NON provoqué suite à anomalie : consulter la log',false);
-- =================== Fin procedure P_RESS_SITU_PRA ===================
END P_RESS_SITU_PRA;

-- --------------------------------------------------------------------------------------

PROCEDURE P_CRE_PRA_RESSOURCE (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ress     IN TMP_RESSOURCE_PRA%ROWTYPE,
                rec_ress    IN RESSOURCE%ROWTYPE,
                rec_situ    IN SITU_RESS%ROWTYPE,
                p_code_mess    IN INTEGER,
                p_message    IN VARCHAR2
                ) IS

-- ==============================================================================
-- Nom     :    P_CRE_PRA_RESSOURCE (Procedure)
-- Description:    Procedure d insertion dans la table PRA controle et de mise à jour des ressources
--        et situations prestachat
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE     : Pointeur du fichier log
--    p_date_trait    : Date de passage du traitement
--    tmp_ress    : Structure de données de la table TEMP_RESSOURCE_PRA
--    p_code_mess     : 0=message d'information, 1=anomalie
--    p_message    : libellé du message
--
-- Parametres de sortie :
-- --------------------
--    Aucun

-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - JM.LEDOYEN - FICHE 1419 : Création
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_CRE_PRA_RESSOURCE'; -- nom de la procedure courante
l_etape        varchar2(255);
l_message    varchar2(255);

BEGIN

	-- ------------------------------------------
	-- Insertion dans la table des comptes rendus
	-- ------------------------------------------
	l_etape := 'Insert PRA_RESSOURCE';

	IF p_code_mess = 0 OR (p_code_mess = 1 AND instr(p_message,'Situation') != 0) OR (p_code_mess = 2 AND instr(p_message,'Situation') != 0) THEN

		INSERT INTO PRA_RESSOURCE
			(
			DATE_TRAIT,
			TYPE_CTRA,
			LOCALISATION,
			DPG,
			FRAISENV,
			CA_IMPUTATION,
			COUT,
			METIER,
			COMPLEXITE,
			IDENT_DO,
			MATRICULE_DO,
			IGG_DO,
			SIREN_FRS,
			IDENT_RESSOURCE,
			MATRICULE_RESSOURCE,
			IGG_RESSOURCE,
			NOM_RESSOURCE,
			PRENOM_RESSOURCE,
			DATE_DEB_SITUATION,
			DATE_FIN_SITUATION,
			PRESTATION,
			DISPONIBILITE,
			MNT_MENSUEL,
			COUT_TOTAL,
			MCI,
			SOCCODE,
			CODE_RETOUR,
			RETOUR)
		VALUES    (
			p_date_trait,
			rec_tmp_ress.type_ctra,
			rec_tmp_ress.localisation,
			rec_tmp_ress.dpg,
			rec_tmp_ress.fraisenv,
			rec_tmp_ress.ca_imputation,
			rec_tmp_ress.taux,
			rec_tmp_ress.metier,
			rec_tmp_ress.complexite,
			rec_situ.cpident,
			substr(rec_tmp_ress.matricule_do,5),
			rec_tmp_ress.igg_do,
			rec_tmp_ress.siren_frs,
			to_char(rec_ress.ident),
			--rec_tmp_ress.id_ressource,
			rec_ress.matricule,
			nvl(to_char(rec_ress.igg), rec_tmp_ress.igg_ressource),
			nvl(rec_ress.rnom, rec_tmp_ress.nom_ressource) ,
			nvl(rec_ress.rprenom, rec_tmp_ress.prenom_ressource) ,
			nvl2(rec_situ.datsitu,to_char(rec_situ.datsitu,'DD/MM/YYYY'),rec_tmp_ress.date_deb_ressource),
			nvl2(rec_situ.datdep,to_char(rec_situ.datdep,'DD/MM/YYYY'),rec_tmp_ress.date_fin_ressource),
			rec_situ.prestation,
			rec_tmp_ress.disponibilite,
			rec_tmp_ress.mnt_mensuel,
			rec_tmp_ress.cout_total,
			rec_situ.mode_contractuel_indicatif,
			rec_situ.soccode,
			p_code_mess,
			p_message );

			ELSE

			  INSERT INTO PRA_RESSOURCE
				(
				DATE_TRAIT,
				IDENT_RESSOURCE,
				MATRICULE_RESSOURCE,
				IGG_RESSOURCE,
				NOM_RESSOURCE,
				PRENOM_RESSOURCE,
				CODE_RETOUR,
				RETOUR)
			  VALUES (
				p_date_trait,
				to_char(rec_ress.ident),
				rec_ress.matricule,
				nvl(to_char(rec_ress.igg), rec_tmp_ress.igg_ressource),
				nvl(rec_ress.rnom, rec_tmp_ress.nom_ressource) ,
				nvl(rec_ress.rprenom, rec_tmp_ress.prenom_ressource) ,
				p_code_mess,
				p_message );

			END IF;

		COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_CRE_PRA_RESSOURCE ===================
END P_CRE_PRA_RESSOURCE;

PROCEDURE P_CRE_RESSOURCE (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ress     IN TMP_RESSOURCE_PRA%ROWTYPE,
                rec_ress     IN OUT RESSOURCE%ROWTYPE,
                rec_situ    IN OUT SITU_RESS%ROWTYPE,
                p_clone        IN INTEGER,
                is_recycle OUT INTEGER
                ) IS
-- ==============================================================================
-- Nom     :    P_CRE_RESSOURCE (Procedure)
-- Description:    Procedure de création dans la table des ressources
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE     : Pointeur du fichier log
--    rec_ress    : Structure de données de la table RESSOURCE en IN OUT pour récupérer l'identifiant
--    p_clone        : indique si il s'agit d'une ressource principal ou un clone 1 clone, 0 sinon
--
-- Parametres de sortie :
-- --------------------
--    Aucun
-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - JM.LEDOYEN - FICHE 1419 : création
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_CRE_RESSOURCE'; -- nom de la procedure courante
l_etape        varchar2(255);
l_message    varchar2(255);
v_rec_ress     RESSOURCE%ROWTYPE;
v_eligible integer;
cursor c_a_recycler is
  select * from ressource
  where 
  instr(rnom, 'A-RECYCLER-') = 1
  -- SEL PPM 60488 : optimisation recyclage ressource
  AND ident > IDENT_NON_ELIGIBLE
  order by ident ;

BEGIN

  /* PPM 49340 */
  is_recycle := 0;

  l_etape := 'Recherche ressource recyclable';
  for v_rec_ress IN c_a_recycler LOOP
    --Le nom de la ressource commence par "A-RECYCLER-"
    v_eligible := verif_eligible(P_HFILE, v_rec_ress);
    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Ressource (IDENT=' || v_rec_ress.ident || ') eligible = ' || v_eligible );
    IF (v_eligible = 1) THEN
	--La ressource est eligible
        rec_ress.ident := v_rec_ress.ident;
        P_RECYCLE_RESS(P_HFILE, p_date_trait, rec_tmp_ress, rec_ress, rec_situ);
        is_recycle := 1;
        goto end_procedure;
    ELSE
    /* SEL PPM 60488 : optimisation recyclage ressource
    La ressource est non eligible , on memorise son IDENT afin qu on puisse reprendre le traitement a partir de
    ce IDENT*/
    IDENT_NON_ELIGIBLE := v_rec_ress.ident;
    END IF;
  END LOOP;

		l_etape := 'détermination du nouvel identifiant';
		SELECT  MAX(IDENT) + 1
		INTO    rec_ress.ident
		FROM    RESSOURCE;

		-- ------------------------------------------
		-- Insertion dans la table des Ressources
		-- ------------------------------------------
		IF p_clone = 0 THEN
			l_etape := 'Insert RESSOURCE';
		ELSE
			l_etape := 'Insert du clone de la RESSOURCE';
			--MAJ matricule et IGG pour le clone
				/*IF rec_ress.igg is not null THEN
				  rec_ress.igg := '9' ||SUBSTR(to_char(rec_ress.igg),2);
				END IF;
				IF rec_ress.matricule is not null THEN
				   rec_ress.matricule := 'Y'||SUBSTR(rec_ress.matricule,2);
				END IF;*/
		END IF;



		INSERT INTO RESSOURCE
			(
			IDENT,
			RNOM,
			RPRENOM,
			MATRICULE,
			COUTOT,
			RTEL,
			BATIMENT,
			ETAGE,
			BUREAU,
			FLAGLOCK,
			RTYPE,
			ICODIMM,
			IGG)
		VALUES    (
			rec_ress.ident,
		UPPER(CONVERT(rec_ress.rnom,'US7ASCII')), -- on transforme le nom en majuscule non accentué
			UPPER(CONVERT(rec_ress.rprenom, 'US7ASCII')), -- on transforme le nom en majuscule non accentué
			UPPER(rec_ress.matricule),
			rec_ress.coutot,
			null,
			null,
			null,
			null,
			0,
			rec_ress.rtype,
			'00000',
			rec_ress.igg);

		l_etape :='Mise à jour de la log';
		---------------------------------
		Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','ident',null,rec_ress.ident,'Creation ressource');
		Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','rnom',null,rec_ress.rnom,'Creation ressource');
		Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','rprenom',null,rec_ress.rprenom,'Creation ressource');
		Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','matricule',null,rec_ress.matricule,'Creation ressource');
		Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','IGG',null,rec_ress.igg,'Creation ressource');
		Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','rtype',null,rec_ress.rtype,'Creation ressource');
		IF rec_tmp_ress.type_ctra != 'ATU' THEN
		-- on est en ATU, alors le cout total n'est pas pris en compte
			Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','coutot',null,rec_ress.coutot,'Creation ressource');
		END IF;

		IF p_clone = 0 THEN
			l_message:='Ressource créée : Ident = ' || to_char(rec_ress.ident);
		ELSE
			l_message:='Clone ressource créé : Ident = ' || to_char(rec_ress.ident);
		END IF;

		TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || l_message );
		PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    p_date_trait, rec_tmp_ress, rec_ress, rec_situ, 1, l_message);

  <<end_procedure>>
  null;

EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_CRE_RESSOURCE ===================
END P_CRE_RESSOURCE;

PROCEDURE P_MOD_RESSOURCE (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ress     IN TMP_RESSOURCE_PRA%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE,
                rec_situ    IN SITU_RESS%ROWTYPE,
                rec_ress_bip     IN RESSOURCE%ROWTYPE,
                p_clone        IN INTEGER,        -- 1 si clone 0 sinon
                p_maj        OUT INTEGER        -- mise à jour effective 1 oui, 0 sinon
                ) IS
-- ==============================================================================
-- Nom     :    P_MOD_RESSOURCE(Procedure)
-- Description:    Procedure de modification de la table RESSOURCE
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE     : Pointeur du fichier log
--    rec_ress    : Structure de données de la table RESSOURCE en IN OUT pour récupérer l'identifiant
--    rec_ress_
--    p_clone        : indique si il s'agit d'une ressource principal ou un clone 1 clone, 0 sinon
--
-- Parametres de sortie :
-- --------------------
--    Aucun
-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - JM.LEDOYEN - FICHE 1419 : Création
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_MOD_RESOURCE'; -- nom de la procedure courante
l_etape        varchar2(255);
l_message    varchar2(255);

BEGIN

    p_maj := 0;


    
    -- on test si une des données est réélement modifiée
    IF  nvl(rec_ress.rnom,'#') <> nvl(rec_ress_bip.rnom,'#') OR
        nvl(rec_ress.rprenom,'#') <> nvl(rec_ress_bip.rprenom,'#') OR
        (rec_ress.matricule is not null AND nvl(rec_ress.matricule,'#') <> nvl(rec_ress_bip.matricule,'#')) OR
        (rec_ress.igg is not null AND nvl(rec_ress.igg,1) <> nvl(rec_ress_bip.igg,1)) OR
        rec_ress.coutot <> rec_ress_bip.coutot THEN
        -- ------------------------------------------
        -- Mise à jour de la table des Ressources
        -- ------------------------------------------

        p_maj := 1;

        IF p_clone = 0 THEN
            l_etape := 'Update RESSOURCE';
        ELSE
            l_etape := 'Update du clone de la RESSOURCE';
        END IF;

        -- On ne modifie pas le type de ressource
        UPDATE RESSOURCE SET
            RNOM = UPPER(CONVERT(rec_ress.rnom, 'US7ASCII')), -- on transforme le nom en majuscule non accentué
            RPRENOM = UPPER(CONVERT(rec_ress.rprenom, 'US7ASCII')), -- on transforme le nom en majuscule non accentué

            MATRICULE = NVL2 ( rec_ress.matricule, -- on ne prend pas en compte la nouvelle valeur si celle ci est null
                               UPPER(rec_ress.matricule),
                               rec_ress_bip.matricule ),

        IGG = NVL2 ( rec_ress.igg, -- on ne prend pas en compte la nouvelle valeur si celle ci est null
                         rec_ress.igg,
             rec_ress_bip.igg ),
            COUTOT = rec_ress.coutot
        WHERE    IDENT = rec_ress.ident;


        l_etape :='Mise à jour de la log';
        ---------------------------------
        Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','ident',rec_ress_bip.ident,rec_ress.ident,'Modification ressource');
        Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','rnom',rec_ress_bip.rnom,rec_ress.rnom,'Modification ressource');
        Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','rprenom',rec_ress_bip.rprenom,rec_ress.rprenom,'Modification ressource');
        if rec_ress.matricule is not null then
          Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','matricule',rec_ress_bip.matricule,rec_ress.matricule,'Modification ressource');
        end if;
        if rec_ress.igg is not null then
        --QC 1621 11/07/2014 : il faut resnseigner IGG et non igg dans le champ COLONNE
          Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','IGG',rec_ress_bip.igg,rec_ress.igg,'Modification ressource');
        end if;
        IF rec_tmp_ress.type_ctra != 'ATU' THEN
            -- on est en ATU, alors le cout total n'est pas pris en compte
           Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','coutot',rec_ress_bip.coutot,rec_ress.coutot,'Modification ressource');
        END IF;

          IF p_clone = 0 THEN
              l_message:='Ressource modifiée : Ident = ' || to_char(rec_ress.ident);
          ELSE
              l_message:='Clone ressource modifiée : Ident = ' || to_char(rec_ress.ident);
          END IF;

          TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || l_message );
          PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    p_date_trait, rec_tmp_ress, rec_ress, rec_situ, 2, l_message);

    END IF;

EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_MOD_RESSOURCE ===================
END P_MOD_RESSOURCE;

PROCEDURE P_CRE_SITUATION (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ress     IN TMP_RESSOURCE_PRA%ROWTYPE,
                rec_ress    IN RESSOURCE%ROWTYPE,
                rec_situ     IN SITU_RESS%ROWTYPE,
                p_clone        IN INTEGER
                ) IS
-- ==============================================================================
-- Nom     :    P_CRE_SITUATION (Procedure)
-- Description:    Procedure de creation de la table des situations ressource
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE     : Pointeur du fichier log
--    rec_ress    : Structure de données de la table SITU_RESS
--    p_clone        : indique si il s'agit d'une ressource principal ou un clone 1 clone, 0 sinon
--
-- Parametres de sortie :
-- --------------------
--    Aucun
-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - JM.LEDOYEN - FICHE 1419 : création
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_CRE_SITUATION'; -- nom de la procedure courante
l_etape        varchar2(255);
l_message    varchar2(255);

BEGIN

    -- ------------------------------------------
    -- Insertion dans la table des situations
    -- ------------------------------------------
    IF p_clone = 0 THEN
        l_etape := 'Insert SITU_RESS';
    ELSE
        l_etape := 'Insert du clone SITU_RESS';
    END IF;

    INSERT INTO SITU_RESS
        (
        DATSITU,
        DATDEP,
        CPIDENT,
        COUT,
        DISPO,
        MARSG2,
        RMCOMP,
        PRESTATION,
        DPREST,
        IDENT,
        SOCCODE,
        CODSG,
        NIVEAU,
        MONTANT_MENSUEL,
        FIDENT,
        MODE_CONTRACTUEL_INDICATIF)
    VALUES    (
        rec_situ.datsitu,
        rec_situ.datdep,
        rec_situ.cpident,
        rec_situ.cout,
        rec_situ.dispo,
        rec_situ.marsg2,
        rec_situ.rmcomp,
        rec_situ.prestation,
        rec_situ.dprest,
        rec_situ.ident,
        rec_situ.soccode,
        rec_situ.codsg,
        rec_situ.niveau,
        rec_situ.montant_mensuel,
        rec_situ.fident,
        rec_situ.mode_contractuel_indicatif
        );

    l_etape :='Mise à jour de la log';
    ---------------------------------
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','datsitu',null,rec_situ.datsitu,'Creation situation');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','datdep',null,rec_situ.datdep,'Creation situation');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','cpident',null,rec_situ.cpident,'Creation situation');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','cout',null,rec_situ.cout,'Creation situation');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','dispo',null,rec_situ.dispo,'Creation situation');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','prestation',null,rec_situ.prestation,'Creation situation');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','ident',null,rec_situ.ident,'Creation situation');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','soccode',null,rec_situ.soccode,'Creation situation');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','codsg',null,rec_situ.codsg,'Creation situation');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','montant_mensuel',null,rec_situ.montant_mensuel,'Creation situation');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','mode_contractuel_indicatif',null,rec_situ.mode_contractuel_indicatif,'Creation situation');

    IF p_clone = 0 THEN
        l_message:='Situation ressource créée : Ident = ' || to_char(rec_situ.ident);
    ELSE
        l_message:='Situation clone ressource créée : Ident = ' || to_char(rec_situ.ident);
    END IF;

    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || l_message );
    PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    p_date_trait, rec_tmp_ress, rec_ress, rec_situ, 1, l_message);

EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_CRE_SITUATION ===================
END P_CRE_SITUATION;

PROCEDURE P_MOD_SITUATION (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ress     IN TMP_RESSOURCE_PRA%ROWTYPE,
                rec_ress    IN RESSOURCE%ROWTYPE,
                rec_situ    IN SITU_RESS%ROWTYPE,
                rec_situ_bip     IN SITU_RESS%ROWTYPE,
                p_clone        IN INTEGER,        -- 1 si clone 0 sinon
                p_maj        OUT INTEGER        -- mise à jour effective 1 oui, 0 sinon
                ) IS
-- ==============================================================================
-- Nom     :    P_MOD_SITUATION (Procedure)
-- Description:    Procedure de modification de la table ressource
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE     : Pointeur du fichier log
--    rec_ress    : Structure de données de la table RESSOURCE en IN OUT pour récupérer l'identifiant
--    rec_ress_
--    p_clone        : indique si il s'agit d'une ressource principal ou un clone 1 clone, 0 sinon
--
-- Parametres de sortie :
-- --------------------
--    Aucun
-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - JM.LEDOYEN - FICHE 1419 : Création
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_MOD_SITUATION'; -- nom de la procedure courante
l_etape        varchar2(255);
l_message    varchar2(255);

BEGIN

    p_maj := 0;

    -- on test si une des données est réélement modifiée
    IF  rec_situ_bip.datsitu <> rec_situ.datsitu OR
        rec_situ_bip.datdep <> rec_situ.datdep OR
        rec_situ_bip.codsg <> rec_situ.codsg OR
        rec_situ_bip.soccode <> rec_situ.soccode OR
        rec_situ_bip.prestation <> rec_situ.prestation OR
        rec_situ_bip.mode_contractuel_indicatif <> rec_situ.mode_contractuel_indicatif OR
        rec_situ_bip.cpident <> rec_situ.cpident OR
        rec_situ_bip.dispo <> rec_situ.dispo OR
        rec_situ_bip.cout <> rec_situ.cout OR
        rec_situ_bip.montant_mensuel <> rec_situ.montant_mensuel THEN

        -- ------------------------------------------
        -- Mise à jour de la table des Ressources
        -- ------------------------------------------

        p_maj := 1;

        IF p_clone = 0 THEN
            l_etape := 'Update SITUATION pour la ressource : ident = ' || rec_situ.ident;
        ELSE
            l_etape := 'Update de la situation du clone de la RESSOURCE : ident = ' || rec_situ.ident;
        END IF;

        -- On ne modifie pas l'IGG et le type de ressource
        UPDATE SITU_RESS SET
            DATSITU = rec_situ.datsitu,
            DATDEP = rec_situ.datdep,
            CODSG = rec_situ.codsg,
            SOCCODE = rec_situ.soccode,
            PRESTATION = rec_situ.prestation,
            MODE_CONTRACTUEL_INDICATIF = rec_situ.mode_contractuel_indicatif,
            CPIDENT = rec_situ.cpident,
            DISPO = rec_situ.dispo,
            COUT = rec_situ.cout,
            MONTANT_MENSUEL    = rec_situ.montant_mensuel
        WHERE    IDENT = rec_situ.ident AND
             DATSITU = rec_situ_bip.datsitu;

        l_etape :='Mise à jour de la log';
        ---------------------------------
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','datsitu',rec_situ_bip.datsitu,rec_situ.datsitu,'Modification situation (date valeur situation : '|| rec_situ.datsitu ||')' );
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','datdep',rec_situ_bip.datdep,rec_situ.datdep,'Modification situation (date valeur situation : '|| rec_situ.datsitu ||')');
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','codsg',rec_situ_bip.codsg,rec_situ.codsg,'Modification situation (date valeur situation : '|| rec_situ.datsitu ||')');
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','soccode',rec_situ_bip.soccode,rec_situ.soccode,'Modification situation (date valeur situation : '|| rec_situ.datsitu ||')');
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','prestation',rec_situ_bip.prestation,rec_situ.prestation,'Modification situation (date valeur situation : '|| rec_situ.datsitu ||')');
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','mode_contractuel_indicatif',rec_situ_bip.mode_contractuel_indicatif,rec_situ.mode_contractuel_indicatif,'Modification situation (date valeur situation : '|| rec_situ.datsitu ||')');
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','cpident',rec_situ_bip.cpident,rec_situ.cpident,'Modification situation (date valeur situation : '|| rec_situ.datsitu ||')');
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','dispo',rec_situ_bip.dispo,rec_situ.dispo,'Modification situation (date valeur situation : '|| rec_situ.datsitu ||')');
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','cout',rec_situ_bip.cout,rec_situ.cout,'Modification situation (date valeur situation : '|| rec_situ.datsitu ||')');
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','montant_mensuel',rec_situ_bip.montant_mensuel,rec_situ.montant_mensuel,'Modification situation (date valeur situation : '|| rec_situ.datsitu ||')');

        IF p_clone = 0 THEN
            l_message:='Situation ressource modifiée : Ident = ' || to_char(rec_situ.ident);
        ELSE
            l_message:='Situation clone ressource modifiée : Ident = ' || to_char(rec_situ.ident);
        END IF;

        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || l_message );
        PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    p_date_trait, rec_tmp_ress, rec_ress, rec_situ, 2, l_message);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_MOD_SITUATION ===================
END P_MOD_SITUATION;

/*
Vérification de la conformité d'un numéro de contrat ATG
*/
FUNCTION EST_NUM_CONTRAT_ATG_CONFORME(num_contrat TMP_CONTRAT_PRA.num_contrat%TYPE) RETURN VARCHAR2 IS
    refpac VARCHAR2(100);

    BEGIN
        refpac := TRIM(num_contrat);
        -- Si (RefP@C est sur 13 car, commence par CW et comporte un "-" en pos. 8 et 11)
        --  ou
        -- (RefP@C est sur 16 car., commence par ATG- et comporte un "-" en pos. 11 et 14)
        IF (length(refpac) = 13
            AND refpac LIKE 'CW%'
            AND substr(refpac, 8, 1) = '-'
            AND substr(refpac, 11, 1) = '-')
            OR
            (length(refpac) = 16
            AND refpac LIKE 'ATG-%'
            AND substr(refpac, 11, 1) = '-'
            AND substr(refpac, 14, 1) = '-') THEN
                return 'true';
        END IF;
        return 'false';
END EST_NUM_CONTRAT_ATG_CONFORME;

PROCEDURE P_CTRA_LIGC_PRA (P_HFILE utl_file.file_type) IS
-- ==============================================================================
-- Nom     :    P_CTRA_LIGC_PRA (Procedure)
-- Description:    Procédure de controle et de mise à jour des contrats
--        et lignes contrats prestachat
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE : Pointeur du fichier log
--
-- Parametres de sortie :
-- ------------------- -
--    Aucun
--
-- Retour :
-- -------
--    traité par l'appelant si erreur non gérée
-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - JM.LEDOYEN - FICHE 1419 : Création
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_CTRA_LIGC_PRA'; -- nom de la procedure courante
l_message    VARCHAR2(255);        -- message d'anomalie ou de mise à jour
l_date_trait    DATE;            -- date de passage du traitement
l_etape        VARCHAR2(255);        -- etape courante
l_null        INTEGER;        -- Flag de controle existence
--PPM 58858 l_centractiv    NUMBER(6);    -- centre d'activité
--PPM 58858 l_librca    VARCHAR2(30);        -- Libellé du centre activité
l_action_ctra    VARCHAR2(50);        -- action à réaliser sur le contrat
l_action_ligc    VARCHAR2(50);        -- action à réaliser sur la ligne contrat
l_flag_clone    INTEGER;        -- flag de présence de clone sur la ressource 1=clone existe sinon 0
l_divers    VARCHAR2(50);        -- variable au contenu divers selon besoin
l_maj        INTEGER;        -- flag de mise à joour effective d'une ligne contrat
l_typ_ctra    VARCHAR(1);        -- type de contrat
l_ident        NUMBER(5);        -- Identifiant de la ressource principale
l_ident_clone    NUMBER(5);        -- Identifiant du clone de la ressource principale
l_req_where_cl    VARCHAR2(255);        -- clause where de la requete dynamique (pour clone)
l_req_where    VARCHAR2(255);        -- clause where de la requete dynamique
l_requete    VARCHAR2(255);        -- variable contenant la requete finale
l_comp_clone    INTEGER;        -- flag de compatibilité de la situation avec le clone
l_topfer CHAR(1 BYTE); -- PPM 58858
               ------------------
            -- Structure de table --
               ------------------
    -- *** tableau tampon des donéees vérifiées et transformées p@c
rec_ctra    CONTRAT%ROWTYPE;    -- Stucture de reception pour création ou modification contrat
rec_ligc    LIGNE_CONT%ROWTYPE;    -- Stucture de reception pour création ou modification ligne contrat

    -- *** tableau tampon des donéees existantes BIP
rec_ctra_bip    CONTRAT%ROWTYPE;    -- contrat de référence BIP existante
rec_ligc_bip    LIGNE_CONT%ROWTYPE;    -- ligne contrat référence BIP existante
rec_ress_bip    RESSOURCE%ROWTYPE;    -- Ressources attachée BIP
rec_ress_clone_bip    RESSOURCE%ROWTYPE;    -- clone ressources attachée BIP

--PPM 60006 : décalaration des variables
rec_ligc1 LIGNE_CONT%ROWTYPE;    -- ligne contrat référence BIP existante
nbr_rec_ligc_bip INTEGER;
i INTEGER;
t_rec_ligc_mem TAB_REC_LIGC;
--PPM 6006 : fin déclarations
-- Curseur sur la table tampon des ressources et situations
CURSOR c_tmp_contrat IS
    SELECT    type_ctra,
        num_contrat,
        date_deb_ctra,
        date_fin_ctra,
        dpg,
        fraisenv,
        ca_imputation,
        mnt_total_ctra,
        siren_frs,
        id_ressource,
        igg_ressource,
        date_deb_ressource,
        date_fin_ressource,
        nvl(charge_estimee,0) charge_estimee,
        d_arrivee_ach,
        d_saisie_ach,
        objet_ctra,
        cout_propose,
        localisation
    FROM    TMP_CONTRAT_PRA;
    --ORDER BY num_contrat, to_date(DATE_DEB_RESSOURCE,'DD/MM/YYYY');

BEGIN
    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ': Début contrat / ligne ctra PRA ' || to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS'));
    l_date_trait := sysdate;

    -- Purge de la table de compte rendu CONTRAT
    -- ------------------------------------------
    l_etape:='Purge PRA_CONTRAT';
        SELECT SYSDATE into l_date_trait FROM dual;

        DELETE FROM PRA_CONTRAT
        WHERE date_trait < ADD_MONTHS(l_date_trait,-2)
        ;
        COMMIT;

    -- Boucle sur la table tempon des contrats et lignes contrat
    -- ----------------------------------------------------------
    FOR rec_tmp_ctra IN c_tmp_contrat LOOP
        ----------------------------------------------------------------------
        -- Controles prealables des données ressources/situation
        ----------------------------------------------------------------------

        -- Initialisations
        rec_ctra:= null;
        rec_ligc := null;

        rec_ctra_bip := null;
        rec_ligc_bip := null;
        rec_ress_bip := null;
        rec_ress_clone_bip := null;        

        rec_ligc1 := null;--PPM 60006        
        nbr_rec_ligc_bip := 0;--PPM 60006
        
        l_ident_clone := null;
        l_ident := null;
        l_action_ctra := null;
        l_action_ligc := null;
        l_flag_clone := 0;
        l_maj := 0;

        l_etape :='determination et controle du type de facturation';
        -------------------------------------------------------------
        IF rec_tmp_ctra.type_ctra = 'ATU' THEN
            rec_ctra.ctypfact  := 'R';
        ELSIF rec_tmp_ctra.type_ctra = 'ATG' OR  rec_tmp_ctra.type_ctra = 'FOR' THEN
            rec_ctra.ctypfact  := 'F';
        ELSE
            l_message:='Type de contrat '|| rec_tmp_ctra.type_ctra || ' incorrect';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                rec_ligc, rec_ress_bip, 0, l_message);
            GOTO end_loop;
        END IF;

        l_etape :='Détermination de la racine du contrat';
        -------------------------------------------------
        -- Si contrat ATU ou FOR, chargement contrat racine avec les 12 premiers car. de RefP@C
        IF rec_tmp_ctra.type_ctra = 'ATU' OR  rec_tmp_ctra.type_ctra = 'FOR' THEN
            rec_ctra.numcont := rtrim(substr(rec_tmp_ctra.num_contrat,1,12));
            rec_ligc.numcont := rtrim(substr(rec_tmp_ctra.num_contrat,1,12));
        -- Si contrat ATG non conforme
        ELSIF rec_tmp_ctra.type_ctra = 'ATG' AND EST_NUM_CONTRAT_ATG_CONFORME(rec_tmp_ctra.num_contrat) = 'false' THEN
            -- Rejet du contrat avec le libellé 'Format de contrat ATG ... non conforme'
            l_message:='Format de contrat ATG '|| rec_tmp_ctra.num_contrat || ' non conforme';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                rec_ligc, rec_ress_bip, 0, l_message);
            -- Passer au contrat suivant
            GOTO end_loop;
        -- Sinon par défaut (car métier non géré)
        ELSE
            rec_ctra.numcont := rtrim(rec_tmp_ctra.num_contrat);
            rec_ligc.numcont := rtrim(rec_tmp_ctra.num_contrat);
        END IF;

        l_etape :='Détermination et controle de la societe';
        ----------------------------------------------------
        BEGIN
            SELECT     distinct SOCCODE
            INTO     rec_ctra.soccont
            FROM    AGENCE
            WHERE    SIREN = rec_tmp_ctra.siren_frs AND
                ACTIF = 'O';

            rec_ligc.soccont := rec_ctra.soccont;
            rec_ctra.siren := rec_tmp_ctra.siren_frs;
        EXCEPTION
            WHEN TOO_MANY_ROWS THEN
                l_message:='Détermination de la société bip impossible';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
            WHEN NO_DATA_FOUND THEN
                l_message:='Société avec ce SIREN inconnue ou inactive en bip';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                    rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
        END;


        l_etape :='Détermination de l''avenant du contrat';
        -- Détermination numéro d'avenant
        -------------------------------------------------
        -- Si contrat ATU ou FOR
        IF rec_tmp_ctra.type_ctra = 'ATU' OR  rec_tmp_ctra.type_ctra = 'FOR' THEN
            rec_ctra.cav := '0'||substr(rec_tmp_ctra.num_contrat,14,2);
            rec_ligc.cav := '0'||substr(rec_tmp_ctra.num_contrat,14,2);
        -- Si contrat ATG non conforme
        ELSIF rec_tmp_ctra.type_ctra = 'ATG' AND  EST_NUM_CONTRAT_ATG_CONFORME(rec_tmp_ctra.num_contrat) = 'false' THEN
            -- Rejet du contrat avec le libellé 'Format de contrat ATG ... non conforme'
            l_message:='Format de contrat ATG '|| rec_tmp_ctra.num_contrat || ' non conforme';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                rec_ligc, rec_ress_bip, 0, l_message);
            -- Passer au contrat suivant
            GOTO end_loop;
        ELSE
            rec_ctra.cav := '000';
            rec_ligc.cav := '000';
        END IF;

        l_etape :='Détermination de l''objet du contrat';
        -------------------------------------------------
        rec_ctra.cobjet1 := substr(rec_tmp_ctra.objet_ctra,1,50);
        rec_ctra.cobjet2 := substr(rec_tmp_ctra.objet_ctra,51,50);
        rec_ctra.cobjet3 := substr(rec_tmp_ctra.objet_ctra,101,50);

-- debut PPM 58858 : Suppression du contrôle de compatibilité du libelle (flux de contrats)
--        l_etape:='controle compatibilité du libelle';
--        ---------------------------------------------
--        BEGIN
--            SELECT LILOES
--            INTO    l_librca
--            FROM    ENTITE_STRUCTURE
--            WHERE   CODCAMO = l_centractiv;
--
--            -- controle compatibilité du libelle
--            IF UPPER(TRIM(l_librca)) <> UPPER(TRIM(rec_tmp_ctra.ca_imputation)) THEN
--                l_message:='Le CA fourni n''est pas compatible avec celui du DPG';
--                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
--                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
--                                                            rec_ligc, rec_ress_bip, 0, l_message);
--                GOTO end_loop;
--            END IF;
--
--        EXCEPTION
--            WHEN NO_DATA_FOUND THEN
--                l_message:='Le centre d''activité est inconnu';
--                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
--                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
--                                                            rec_ligc, rec_ress_bip, 0, l_message);
--                GOTO end_loop;
--        END;

-- fin PPM 58858 : Suppression du contrôle de compatibilité du libelle (flux de contrats)


        l_etape:='Détermination date arrivée contrat et Date saisie contrat ';
        ----------------------------------------------------------------------
        BEGIN
            IF rec_tmp_ctra.d_arrivee_ach is null THEN
                rec_ctra.cdatarr := to_date(rec_tmp_ctra.date_deb_ctra,'DD/MM/YYYY');
            ELSE
                rec_ctra.cdatarr := to_date(rec_tmp_ctra.d_arrivee_ach,'DD/MM/YYYY');
            END IF;

            IF rec_tmp_ctra.d_saisie_ach is null THEN
                rec_ctra.cdatsai := l_date_trait;
            ELSE
                rec_ctra.cdatsai := to_date(rec_tmp_ctra.d_saisie_ach,'DD/MM/YYYY');
            END IF;

        EXCEPTION
            WHEN ANO_DATE OR ANO_DATE2 OR ANO_DATE3 THEN
                l_message:='Format date arrivée ou saisie du contrat incorrect';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                    rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
            WHEN OTHERS THEN
                l_message:='Format date arrivée ou saisie du contrat incorrect';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                    rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
        END;

        l_etape:='Contrôles dates début et fin contrat';
        ----------------------------------------------------------------------
        BEGIN
            rec_ctra.cdatdeb := to_date(rec_tmp_ctra.date_deb_ctra,'DD/MM/YYYY');

            IF to_date(rec_tmp_ctra.date_deb_ctra,'DD/MM/YYYY') >  to_date(rec_tmp_ctra.date_fin_ctra,'DD/MM/YYYY') THEN
                l_message:='Dates de contrat incohérentes ';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                    rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
            ELSE
                rec_ctra.cdatfin := to_date(rec_tmp_ctra.date_fin_ctra,'DD/MM/YYYY');
            END IF;

        EXCEPTION
            WHEN ANO_DATE OR ANO_DATE2 OR ANO_DATE3 THEN
                l_message:='Format date début ou fin contrat incorrect';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                    rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
            WHEN OTHERS THEN
                l_message:='Format date début ou fin contrat incorrect';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                    rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
        END;

-- Debut PPM 58858 : charge estimée = 0 (flux de contrats)
        l_etape:='Charge estimée';
        --------------------------
        BEGIN
            rec_ctra.ccharesti := to_number(rec_tmp_ctra.charge_estimee,'99999.9','NLS_NUMERIC_CHARACTERS = ''. ''');
      -- PPM 58858 : si la charge estimée est négative ou non numérique, elle doit avoir la valeur 0 et continuer le traitement sans généré le rejet.
            -- la charge estimée ne doit pas être négative
            IF rec_ctra.ccharesti < 0 THEN
            rec_ctra.ccharesti := 0;
                --l_message:='La charge estimée est invalide';
                --PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                --                    rec_ligc, rec_ress_bip, 0, l_message);
                --GOTO end_loop;
            END IF;

        EXCEPTION
            WHEN INVALID_NUMBER OR VALUE_ERROR THEN
            rec_ctra.ccharesti := 0;
                --l_message:='La charge estimée est invalide';
                --PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                --                    rec_ligc, rec_ress_bip, 0, l_message);
                --GOTO end_loop;
        END;
-- Fin PPM 58858 : charge estimée = 0 (flux de contrats)

        l_etape:='Montant total contrat';
        ---------------------------------
        BEGIN
            rec_ctra.ccoutht := to_number(rec_tmp_ctra.mnt_total_ctra,'9999999999.99','NLS_NUMERIC_CHARACTERS = ''. ''');
        EXCEPTION
            WHEN INVALID_NUMBER OR VALUE_ERROR THEN
                l_message:='Le Montant total contrat est invalide';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                    rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
        END;



        -- si type contrat = 'FOR' alors pas de contrôle sur les données ligne contrat
        -- ===========================================================================

        IF rec_tmp_ctra.type_ctra <> 'FOR' THEN

        l_etape:='Contrôle date de début et de fin de ligne contrat';
        -------------------------------------------------------------
        BEGIN
            -- la date de debut doit être inférieure à la date de fin
            IF to_date(rec_tmp_ctra.date_deb_ressource,'DD/MM/YYYY') >  to_date(rec_tmp_ctra.date_fin_ressource,'DD/MM/YYYY') THEN
                l_message:='Dates de ressource de la ligne contrat incohérentes ';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                    rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
            ELSE
                rec_ctra.cdatfin := to_date(rec_tmp_ctra.date_fin_ctra,'DD/MM/YYYY');
            END IF;

            -- controle de date en coherence avec le contrat
            IF to_date(rec_tmp_ctra.date_deb_ressource,'DD/MM/YYYY') <  to_date(rec_tmp_ctra.date_deb_ctra,'DD/MM/YYYY') OR
               to_date(rec_tmp_ctra.date_deb_ressource,'DD/MM/YYYY') >  to_date(rec_tmp_ctra.date_fin_ctra,'DD/MM/YYYY') THEN
                RAISE ANO_DATE;
            ELSE
                rec_ligc.lresdeb := to_date(rec_tmp_ctra.date_deb_ressource,'DD/MM/YYYY');
            END IF;

            IF to_date(rec_tmp_ctra.date_fin_ressource,'DD/MM/YYYY') <  to_date(rec_tmp_ctra.date_deb_ctra,'DD/MM/YYYY') OR
               to_date(rec_tmp_ctra.date_fin_ressource,'DD/MM/YYYY') >  to_date(rec_tmp_ctra.date_fin_ctra,'DD/MM/YYYY') THEN
                RAISE ANO_DATE;
            ELSE
                rec_ligc.lresfin := to_date(rec_tmp_ctra.date_fin_ressource,'DD/MM/YYYY');
            END IF;
        EXCEPTION
            WHEN ANO_DATE OR ANO_DATE2 OR ANO_DATE3 THEN
                l_message:='Dates de la ligne contrat incohérentes ou incompatibles avec le contrat';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                    rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
            WHEN OTHERS THEN
                l_message:='Dates de la ligne contrat incohérentes ou incompatibles avec le contrat';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                    rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
        END;
        END IF;
-- debut PPM 58858 : contrôle du DPG (flux de contrats)
        l_etape:='Contrôle du DPG';
        ---------------------------
        BEGIN
        -- PPM 58858 : modification de la requête pour récupérer tous les DPG actifs et inactifs
            SELECT  FILCODE,
                    SCENTREFRAIS,
                    TOPFER
            INTO    rec_ctra.filcode,
                    rec_ctra.ccentrefrais,
                    l_topfer
            FROM    STRUCT_INFO
            WHERE   CODSG = rec_tmp_ctra.dpg;
            --AND TOPFER = 'O'; --PPM 58858
            rec_ctra.codsg := rec_tmp_ctra.dpg; -- QC 1620

        -- Si DPG correspond à un DPG inactif (TOPFER='F')
        IF l_topfer = 'F' THEN
          -- SI la < Date de fin du contrat > et la < Date de fin ressource > sont egales ou ulterieures a la date du jour
          -- alors rejeter le contrat avec le libelle « DPG inactif », et passer au suivant QC 1635
          IF to_date(rec_tmp_ctra.date_fin_ctra,'DD/MM/YYYY') >= sysdate
              AND to_date(rec_tmp_ctra.date_fin_ressource,'DD/MM/YYYY') >= sysdate THEN
          l_message:='DPG inactif : '||rec_tmp_ctra.dpg;
          TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                  PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                      rec_ligc, rec_ress_bip, 0, l_message);
            GOTO end_loop;
          END IF;
        END IF;

        EXCEPTION
        --Si la requête ne renvoi rien, alors le DPG n'existe pas en BIP
        -- SI <DPG> ne correspond pas à un DPG existant en Bip, alors rejeter le contrat avec le libellé « DPG inconnu » et passer au suivant
            WHEN NO_DATA_FOUND THEN
                l_message:='DPG inconnu : '||rec_tmp_ctra.dpg;
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                    rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
        END;
-- fin PPM 58858 : contrôle du DPG  (flux de contrats)

        l_etape:='Contrôle de la localisation ';
        ----------------------------------------
        BEGIN
            SELECT     1
            INTO    l_null
            FROM    LOCALISATION
            WHERE    CODE_LOCALISATION = rec_tmp_ctra.localisation;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_message:='Code localisation incorrect : '||rec_tmp_ctra.localisation;
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                    rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
        END;

        l_etape :='controle du code frais d''envoi';
        --------------------------------------------
        IF rec_tmp_ctra.fraisenv <> 'O' and rec_tmp_ctra.fraisenv <> 'N' THEN
            l_message:='Code frais d''environnement '|| rec_tmp_ctra.fraisenv || ' incorrect';
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
            PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                rec_ligc, rec_ress_bip, 0, l_message);
            GOTO end_loop;
        END IF;

        l_etape:='recherche d''un contrat existant';
        -----------------------------------------------
        BEGIN
            SELECT    *
            INTO    rec_ctra_bip
            FROM    CONTRAT
            WHERE    NUMCONT = rec_ctra.numcont AND
                SOCCONT = rec_ctra.soccont AND
                CAV = rec_ctra.cav;

            l_action_ctra:='MOD_CTRA';

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_action_ctra:='CRE_CTRA';
            WHEN TOO_MANY_ROWS THEN
                l_message:='Détermination du contrat Bip impossible';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                    rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
        END;

        -- Etapes inutiles pour les contrat de type 'FOR'
        IF rec_tmp_ctra.type_ctra <> 'FOR' THEN
            l_etape :='controle du code frais d''envoi';
            --------------------------------------------
            IF rec_tmp_ctra.fraisenv <> 'O' and rec_tmp_ctra.fraisenv <> 'N' THEN
                l_message:='Code frais d''environnement '|| rec_tmp_ctra.fraisenv || ' incorrect';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                    rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
            END IF;

            l_etape :='Détermination du MC';
            --------------------------------
            IF rec_tmp_ctra.type_ctra = 'ATU' THEN
                rec_ligc.mode_contractuel := 'ATU';
            ELSE
                -- determine type de contrat
                IF rec_tmp_ctra.fraisenv = 'O' THEN
                    l_typ_ctra := 'F';
                ELSIF rec_tmp_ctra.fraisenv = 'N' THEN
                    l_typ_ctra := 'E';
                END IF;

                -- Recherche MC
                BEGIN
                    select    CODE_CONTRACTUEL
                    into     rec_ligc.mode_contractuel
                    from     MODE_CONTRACTUEL
                    where     TYPE_RESSOURCE = l_typ_ctra AND
                        CODE_LOCALISATION = rec_tmp_ctra.localisation AND
                        TOP_ACTIF = 'O' AND
                        SUBSTR(CODE_CONTRACTUEL,-1) = 'G';
                EXCEPTION
                    WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                        l_message:='Détermination du MCI impossible';
                        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                        PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                            rec_ligc, rec_ress_bip, 0, l_message);
                        GOTO end_loop;
                END;
            END IF;

            l_etape:='test si l''igg est numerique';
            ----------------------------------------
            BEGIN
                IF to_number(rec_tmp_ctra.igg_ressource) is not null AND rec_tmp_ctra.type_ctra = 'ATU' THEN
                    null;
                END IF;
            EXCEPTION
                    WHEN INVALID_NUMBER OR VALUE_ERROR THEN
                        l_message:='IGG non numérique';
                        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                        PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                            rec_ligc, rec_ress_bip, 0, l_message);
                        GOTO end_loop;
                END;

        l_etape :='Détermination du matricule BIP';
        -------------------------------------------

        IF rec_tmp_ctra.type_ctra = 'ATU' THEN

              -- le matricule doit avoir une longueur de 11 caractères et doit commencer par GL00
            IF rec_tmp_ctra.id_ressource is not null and
               ( length(rec_tmp_ctra.id_ressource) <> 11 or upper(substr(rec_tmp_ctra.id_ressource,1,4)) <> 'GL00' ) THEN
                l_message:='Matricule de la ressource incorrect';
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                                      rec_ligc, rec_ress_bip, 0, l_message);
                GOTO end_loop;
            END IF;

        END IF;

        l_etape :='Détermination et controle de l''IGG tressource';
        -----------------------------------------------------------
        IF rec_tmp_ctra.type_ctra = 'ATU' THEN
            IF rec_tmp_ctra.igg_ressource is not null THEN
                -- L'IGG doit voir une longueur de 10 caractères
                IF length(to_number(rec_tmp_ctra.igg_ressource)) <> 10 THEN
                    l_message:='IGG ressource '|| rec_tmp_ctra.igg_ressource ||' incorrect';
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                                      rec_ligc, rec_ress_bip, 0, l_message);
                    GOTO end_loop;
                END IF;
            ELSE
                IF rec_tmp_ctra.id_ressource is null THEN
                    -- les deux codes sont null = erreur
                    l_message:='Ressource indéterminable car ne comportant ni matricule ni IGG';
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                                      rec_ligc, rec_ress_bip, 0, l_message);
                    GOTO end_loop;
                END IF;
            END IF;
        ELSE
            --  L'id ressource ne doit pas dépasser 18 caractères
        IF length(rec_tmp_ctra.id_ressource) > 18 THEN
               l_message:='Nom de la ressource ATG trop long';
               TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
               PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                                      rec_ligc, rec_ress_bip, 0, l_message);
               GOTO end_loop;
            END IF;
        END IF;

            l_etape:='Recherche d''une ressource existante';
            -----------------------------------------------
            BEGIN
                IF rec_tmp_ctra.type_ctra = 'ATG' THEN
                    l_divers := 'ATG';
                    -- le nom et prénom sont déja déterminés precedemment en fonction du type contrat lors des controles
                    l_req_where := ' UPPER(RNOM) = '''|| UPPER(CONVERT(to_char(rec_tmp_ctra.id_ressource),'US7ASCII')) ||''' AND RPRENOM IS NULL';
                ELSE
                    l_divers := 'ATU';
                    -- recherche par l'IGG s'il existe sinon par le matricule gershwin
                    IF rec_tmp_ctra.igg_ressource is not null THEN --recherche par l'IGG
                        l_req_where := ' IGG = '|| to_char(rec_tmp_ctra.igg_ressource);
                    ELSE -- recherche par le matricule
                        l_req_where := ' UPPER(MATRICULE) = '''|| upper(substr(rec_tmp_ctra.id_ressource,5))||'''';
                    END IF;
                END IF;

                -- constitution de la requete dynamique pour ressource principale
                l_requete := 'SELECT * FROM RESSOURCE WHERE' || l_req_where;

                -- Execution de la requete dynamique
                EXECUTE IMMEDIATE l_requete INTO rec_ress_bip ;

               -- Recherche existance d'un clone
                l_etape:='Recherche d''un clone pour la ressource';
                BEGIN
                    IF rec_tmp_ctra.type_ctra = 'ATG' THEN
                        l_divers := 'ATG';
                        l_req_where_cl := ' UPPER(RNOM) = '''|| to_char(rec_ress_bip.rnom) ||''' AND UPPER(RPRENOM) = ''CLONE-'||to_char(rec_ress_bip.ident)||'''';
                    ELSE
                        l_divers := 'ATU';
                        -- recherche par l'IGG clone s'il existe sinon par le matricule gershwin
                        IF rec_tmp_ctra.igg_ressource is not null THEN --recherche par l'IGG
                            l_req_where_cl := ' IGG = '||'9'||SUBSTR(to_char(rec_tmp_ctra.igg_ressource),2);
                        ELSE -- recherche par le matricule clone
                            l_req_where_cl := ' UPPER(MATRICULE) = ''Y'||SUBSTR(rec_ress_bip.matricule,2)||'''';
                        END IF;
                    END IF;
                    -- constitution de la requete dynamique pour ressource principale
                    l_requete := 'SELECT * FROM RESSOURCE WHERE' || l_req_where_cl;

                    -- Execution de la requete dynamique
                    EXECUTE IMMEDIATE l_requete INTO rec_ress_clone_bip ;

                    l_flag_clone := 1;
                EXCEPTION
                    WHEN TOO_MANY_ROWS THEN
                            l_message:='Détermination du clone ' || l_divers || ' Bip attaché impossible';
                            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                            PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                                rec_ligc, rec_ress_bip, 0, l_message);
                            GOTO end_loop;
                    WHEN NO_DATA_FOUND THEN
                        l_flag_clone := 0;
                END;

            EXCEPTION
                WHEN TOO_MANY_ROWS THEN
                        l_message:='Détermination de la ressource ' || l_divers || ' Bip attachée impossible';
                        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                        PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                            rec_ligc, rec_ress_bip, 0, l_message);
                        GOTO end_loop;
                WHEN NO_DATA_FOUND THEN
                        l_message:='Détermination de la ressource ' || l_divers || ' attachée impossible';
                        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                        PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                            rec_ligc, rec_ress_bip, 0, l_message);
                        GOTO end_loop;
            END;

            l_etape:='Recherche d''une situation compatible';
            ----------------------------------------------------

            -- On recherche d'abord une situation compatible avec le clone s'il existe
            l_comp_clone := 0;

            IF l_flag_clone = 1 THEN
                l_etape:='Recherche compatibilité sur le clone ressource';
                rec_ligc.lccouact:=pack_contrat.get_cout_situ_comp(    to_char(rec_ress_clone_bip.ident),
                                            rec_ligc.soccont,
                                            rec_ligc.lresdeb,
                                            rec_ligc.lresfin );
                -- compatibilité clone trouvée
                IF rec_ligc.lccouact is not null THEN
                    l_comp_clone := 1;
                    rec_ligc.ident := rec_ress_clone_bip.ident;
                END IF;
            END IF;

            -- si pas de compatibilité avec  le clone alors on recherche sur la ressource principale
            IF l_comp_clone = 0 THEN
                l_etape:='Recherche compatibilité sur ressource unique';
                rec_ligc.ident := rec_ress_bip.ident;
                rec_ligc.lccouact:=pack_contrat.get_cout_situ_comp(    to_char(rec_ress_bip.ident),
                                            rec_ligc.soccont,
                                            rec_ligc.lresdeb,
                                            rec_ligc.lresfin );
                IF rec_ligc.lccouact is null THEN
                    l_message:='La ressource Bip attachée n''est pas compatible en terme de date ou de société';
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                        rec_ligc, rec_ress_bip, 0, l_message);
                    GOTO end_loop;
                ELSE
                    rec_ligc.ident := rec_ress_bip.ident;
                END IF;
            END IF;

            l_etape:='Détermination du cout unitaire';
            ---------------------------------------------
            BEGIN
                IF rec_tmp_ctra.cout_propose is null THEN
                    rec_ligc.proporig:= rec_ligc.lccouact;
                    rec_ligc.lccouinit:= rec_ligc.lccouact;
                ELSE
                    rec_ligc.proporig:= to_number(rec_tmp_ctra.cout_propose,'9999999999.99','NLS_NUMERIC_CHARACTERS = ''. ''');
                    rec_ligc.lccouinit:= to_number(rec_tmp_ctra.cout_propose,'9999999999.99','NLS_NUMERIC_CHARACTERS = ''. ''');

                    -- Le cout proposé ne doit pas être négatif
                    IF to_number(rec_tmp_ctra.cout_propose,'9999999999.99','NLS_NUMERIC_CHARACTERS = ''. ''') < 0 THEN
                        l_message:='Le cout proposé est invalide';
                        PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                            rec_ligc, rec_ress_bip, 0, l_message);
                        GOTO end_loop;
                    END IF;
                END IF;
            EXCEPTION
                WHEN INVALID_NUMBER OR VALUE_ERROR THEN
                    l_message:='Le cout proposé est invalide';
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                        PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                            rec_ligc, rec_ress_bip, 0, l_message);
                    GOTO end_loop;
            END;

--PPM 60006 : ajout d'un controle de présence de plusieurs lignes contrat sur la même période pour le même contrat/ressource
            l_etape:='Recherche s''il y a présence de deux lignes contrats sur la même période pour le même contrat/ressource';
            -----------------------------------------------------------------------------------
                        BEGIN
                SELECT    COUNT(lcnum)
                INTO l_null
                FROM    LIGNE_CONT
                WHERE    NUMCONT = rec_ctra.numcont AND
                    SOCCONT    = rec_ctra.soccont AND
                    CAV = rec_ctra.cav AND
                    IDENT = rec_ligc.ident AND
                    rec_ligc.lresdeb = lresdeb AND
                    rec_ligc.lresfin = lresfin
                    HAVING ( COUNT(lcnum) >1 ) ;

                    l_message:='Deux lignes contrats sur la même période pour le même contrat/ressource';
                    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                        rec_ligc, rec_ress_bip, 0, l_message);
                    -- Deux lignes contrats sur la même période pour le même contrat/ressource
                    GOTO end_loop;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    null;
            END;
--PPM 60006 : fin d'ajout d'un controle des dates

/* --PPM 60006 : suppression de l'étape de controle de chevauchement de dates
                        l_etape:='Recherche d''un chevauchement possible sur les dates de ligne contrat';--PPM 60006 : à supprimer
            -----------------------------------------------------------------------------------
            BEGIN
                SELECT     1
                INTO    l_null
                FROM    LIGNE_CONT
                WHERE    NUMCONT = rec_ctra.numcont AND
                    SOCCONT    = rec_ctra.soccont AND
                    CAV = rec_ctra.cav AND
                    IDENT = rec_ligc.ident
                    AND
                    ---- test des conditions de chevauchement -
                    (
                        (rec_ligc.lresdeb > lresdeb AND rec_ligc.lresdeb <= lresfin AND rec_ligc.lresfin >= lresfin)
                    OR
                        (rec_ligc.lresdeb < lresdeb AND rec_ligc.lresfin >= lresfin)
                    OR
                        (rec_ligc.lresdeb < lresdeb AND rec_ligc.lresfin >= lresdeb)
                    OR
                        (rec_ligc.lresdeb > lresdeb AND rec_ligc.lresfin <= lresfin)
                    )
                    AND rownum < 2;

                    l_message:='La ressource attachée est en chevauchement de date sur une ligne existante du contrat';
                                      TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : '|| l_message);
                    PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                        rec_ligc, rec_ress_bip, 0, l_message);

                    -- au moins 1 ligne en chevauchement possible
                    GOTO end_loop;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    null;
            END;
*/--PPM 60006 : suppression de l'étape de controle de chevauchement de dates


            -- Si on est en création de contrat alors on est en création de ligne
            IF l_action_ctra <> 'CRE_CTRA' THEN
                l_etape:='Recherche si on est en modification de ligne contrat';
                -------------------------------------------------------------------
                BEGIN

              SELECT    count(*)
                    INTO    nbr_rec_ligc_bip
                    FROM    LIGNE_CONT
                    WHERE  IDENT = rec_ligc.ident
                    AND NUMCONT = rec_ligc.numcont 
                    AND SOCCONT = rec_ligc.soccont 
                    AND CAV = rec_ligc.cav;
                    --LRESDEB = rec_ligc.lresdeb AND --PPM 60006 : on recupère toutes les périodes              

              --PPM 60006 : SI il existe déjà plusieurs (>1) lignes contrat sur cette ressource 
              i :=-1; -- initialisation par -1 pour controle de présence des lignes à supprimer
              IF nbr_rec_ligc_bip > 1 THEN              
                  FOR rec_ligc1 IN (SELECT * FROM LIGNE_CONT WHERE IDENT = rec_ligc.ident AND NUMCONT = rec_ligc.numcont AND SOCCONT = rec_ligc.soccont AND CAV = rec_ligc.cav)
                  LOOP
                    -- un a exactement les mêmes dates de début et fin que la nouvelle ligne contrat venant de P@C, alors on est en MODIFICATION DE LIGNE CONTRAT
                    if (rec_ligc1.lresdeb = rec_ligc.lresdeb and rec_ligc1.lresfin = rec_ligc.lresfin) then
                      l_action_ligc := 'MOD_LIGC';
                      rec_ligc_bip :=rec_ligc1; --mémoriser la ligne contrat à modifier
                      --recuperation du numero de ligne contrat pour la modif
                      rec_ligc.lcnum := rec_ligc_bip.lcnum;

                      GOTO end_loop_ligc;
                      
                -- SI au moins 1 ligne contrat parmi la sélection a au moins 1 jour en commun avec le contrat venant de P@C, alors
                -- on va supprimer les lignes contrat en question, puis créer une nouvelle ligne contrat
                  elsif  (rec_ligc1.lresdeb <= rec_ligc.lresdeb AND rec_ligc1.lresfin >= rec_ligc.lresdeb)   
                          OR (rec_ligc1.lresdeb <= rec_ligc.lresfin AND rec_ligc1.lresfin >= rec_ligc.lresfin)
                          OR (rec_ligc1.lresdeb >= rec_ligc.lresdeb AND rec_ligc1.lresfin <= rec_ligc.lresfin)
                       
                     then                 
                -- Mémoriser la ou les lignes contrat concernées (et aucun autre),
                  i := i+1;
                  t_rec_ligc_mem(i) := rec_ligc1;                
                --On est en ANNULE ET REMPLACE de LIGNE CONTRAT;
                l_action_ligc := 'ANN_REMP_LIGC'; 
                end if;
                END LOOP;
             -- SINON alors on est en CREATION DE LIGNE CONTRAT ;
             l_action_ligc := 'CRE_LIGC';

              <<end_loop_ligc>>

              if i > -1 and l_action_ligc <> 'MOD_LIGC'
              then
               l_action_ligc := 'ANN_REMP_LIGC';
               end if;
              --PPM 60006 : SINON SI il existe 1 seule ligne contrat avec cette ressource 
              ELSIF nbr_rec_ligc_bip = 1 THEN
                SELECT * INTO rec_ligc1 FROM LIGNE_CONT 
                  WHERE IDENT = rec_ligc.ident 
                  AND NUMCONT = rec_ligc.numcont 
                  AND SOCCONT = rec_ligc.soccont 
                  AND CAV = rec_ligc.cav;
                --SI il y a au moins 1 jour en commun entre les 2 périodes, alors on est en MODIFICATION DE LIGNE CONTRAT
                 if (rec_ligc1.lresdeb <= rec_ligc.lresdeb AND rec_ligc1.lresfin >= rec_ligc.lresdeb)   
                          OR (rec_ligc1.lresdeb <= rec_ligc.lresfin AND rec_ligc1.lresfin >= rec_ligc.lresfin)
                          OR (rec_ligc1.lresdeb >= rec_ligc.lresdeb AND rec_ligc1.lresfin <= rec_ligc.lresfin)
                  then                
                    l_action_ligc := 'MOD_LIGC';
                    rec_ligc_bip :=rec_ligc1; --mémoriser la ligne contrat à modifier
                    --recuperation du numero de ligne contrat pour la modif
                    rec_ligc.lcnum := rec_ligc_bip.lcnum;



                    else
                   -- SINON alors on est en CREATION DE LIGNE CONTRAT ;
                   l_action_ligc := 'CRE_LIGC';
                    end if;                    
              ELSE
              --NO_DATA_FOUND : nbr_rec_ligc_bip = 0;
              l_action_ligc := 'CRE_LIGC';         

              END IF;
              END;
            ELSE
                l_action_ligc := 'CRE_LIGC';           
            END IF;
        END IF; -- Fin des controles si type <> 'FOR'
        l_etape:='Test compatibilité entre type ressource et type facturation contrat';
        -------------------------------------------------------------------------------
        IF (rec_ctra.ctypfact = 'R' OR rec_ctra.ctypfact = 'M')
        AND (rec_ress_bip.rtype = 'F' OR rec_ress_bip.rtype = 'E' OR rec_ress_bip.rtype = 'L') THEN
            l_message:='La ressource bip n''est pas compatible en terme de type';
            PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                rec_ligc, rec_ress_bip, 0, l_message);
            GOTO end_loop;
        END IF;

        IF (rec_ress_bip.rtype = 'P') AND (rec_ctra.ctypfact = 'F')THEN
            l_message:='La ressource bip n''est pas compatible en terme de type';
            PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra,
                                rec_ligc, rec_ress_bip, 0, l_message);
            GOTO end_loop;
        END IF;


        ------ Appel des procédures de mise à jour -----
        ------------------------------------------------

      --PPM 60006 - debut : Appel de la procédure de suppression des lignes contrat
        l_etape:='Appel de la procédure de suppression des lignes contrat';
        --------------------------------------------------------
        IF l_action_ligc = 'ANN_REMP_LIGC' AND i > -1 THEN
        --Suppression de toutes les lignes contrat préalablement mémorisées comme à supprimer dans la table t_rec_ligc_mem
          FOR j IN 0..i LOOP
            PACK_PRA_RESS_CONT.P_DEL_LIGNE_CONT (P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra, t_rec_ligc_mem(j), rec_ress_bip, rec_ligc_bip);
          END LOOP;
            --Continuer en création de contrat
            l_action_ligc := 'CRE_LIGC';
        END IF;
        --PPM 60006 : Fin 
        l_etape:='Appel de la procédure de création du contrat';
        --------------------------------------------------------
        IF l_action_ctra = 'CRE_CTRA' THEN
            PACK_PRA_RESS_CONT.P_CRE_CONTRAT (P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra, rec_ligc, rec_ress_bip);

        END IF;

        l_etape:='Appel de la procédure de modification du contrat';
        ------------------------------------------------------------
        IF l_action_ctra = 'MOD_CTRA' THEN
            PACK_PRA_RESS_CONT.P_MOD_CONTRAT (P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra, rec_ligc, rec_ress_bip, rec_ctra_bip );
        END IF;

        l_etape:='Appel de la procédure de création de ligne contrat';
        --------------------------------------------------------------
        IF l_action_ligc = 'CRE_LIGC' THEN
            PACK_PRA_RESS_CONT.P_CRE_LIGNE_CONT (P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra, rec_ligc, rec_ress_bip);
        END IF;

        l_etape:='Appel de la procédure de modification de ligne contrat';
        ------------------------------------------------------------------
        IF l_action_ligc = 'MOD_LIGC' THEN
            PACK_PRA_RESS_CONT.P_MOD_LIGNE_CONT (P_HFILE, l_date_trait, rec_tmp_ctra, rec_ctra, rec_ligc, rec_ress_bip, rec_ligc_bip, l_maj);
        END IF;

        IF l_action_ligc = 'MOD_LIGC' AND l_maj = 1 AND rec_ctra_bip.orictr <> 'PAC' THEN
            l_etape:='MAJ code origine contrat';
            ------------------------------------
            UPDATE    CONTRAT
            SET     ORICTR = 'PAC'
            WHERE    NUMCONT = rec_ctra.numcont AND
                SOCCONT = rec_ctra.soccont AND
                CAV = rec_ctra.cav;

        END IF;

        -- fin normal des controles ressource/situation on peut faire un commit
        -----------------------------------------------------------------------
        COMMIT;
        -------

    <<end_loop>>
        null;
    END LOOP;

    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Fin normale '|| to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS'));

EXCEPTION
    WHEN CALL_ABORT THEN
        RAISE_APPLICATION_ERROR(-20100,
                    'Arrêt du BATCH provoqué suite à anomalie : consulter la log',false);
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' : Etape = '|| l_etape);
        RAISE_APPLICATION_ERROR(-20200,
                    'Arrêt du BATCH NON provoqué suite à anomalie : consulter la log',false);
-- =================== Fin procedure P_RESS_SITU_PRA ===================

END P_CTRA_LIGC_PRA;

PROCEDURE P_CRE_PRA_CONTRAT (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ctra    IN TMP_CONTRAT_PRA%ROWTYPE,
                rec_ctra    IN CONTRAT%ROWTYPE,
                rec_ligc    IN LIGNE_CONT%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE,
                p_code_mess    IN INTEGER,
                p_message    IN VARCHAR2
                ) IS
-- ==============================================================================
-- Nom     :    P_RESS_SITU_PAR (Procedure)
-- Description:    Procedure d insertion dans la table PRA controle et de mise à jour
--        des contrats et lignes contrats
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE     : Pointeur du fichier log
--    p_date_trait    : Date de passage du traitement
--    tmp_ress    : Structure de données de la table TEMP_RESSOURCE_PRA
--    p_code_mess     : 0=message d'information, 1=anomlie
--    p_message    : libellé du message
--
-- Parametres de sortie :
-- --------------------
--    Aucun

-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - JM.LEDOYEN - FICHE 1419 : Création
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_CRE_PRA_CONTRAT'; -- nom de la procedure courante
l_etape        varchar2(255);
l_message    varchar2(255);

BEGIN

    -- ------------------------------------------
    -- Insertion dans la table des comptes rendus
    -- ------------------------------------------
    l_etape := 'Insert PRA_CONTRAT';
    INSERT INTO PRA_CONTRAT
        (
        DATE_TRAIT,
        TYPE_CTRA,
        NUM_CONTRAT,
        CAV,
        DATE_DEB_CTRA,
        DATE_FIN_CTRA,
        DPG,
        FRAISENV,
        CA_IMPUTATION,
        MNT_TOTAL_CTRA,
        SIREN_FRS,
        SOCCONT,
        IDENT_RESSOURCE,
        MATRICULE_RESSOURCE,
        IGG_RESSOURCE,
        NOM_RESSOURCE,
        PRENOM_RESSOURCE,
        COUT_ORIGINE_SITU,
        DATE_DEB_RESSOURCE,
        DATE_FIN_RESSOURCE,
        CHARGE_ESTIMEE,
        D_ARRIVEE_ACH,
        D_SAISIE_ACH,
        OBJET_CTRA,
        COUT_PROPOSE,
        LOCALISATION,
        CODE_RETOUR,
        RETOUR)
    VALUES    (
        p_date_trait,
        rec_tmp_ctra.type_ctra,
        decode(rec_tmp_ctra.type_ctra,'ATG',rec_tmp_ctra.num_contrat,rtrim(substr(rec_tmp_ctra.num_contrat,1,12))),
        NVL2( rec_ctra.cav, rec_ctra.cav, decode(rec_tmp_ctra.type_ctra,'ATG','000','0'||substr(rec_tmp_ctra.num_contrat,14,2))),
        rec_tmp_ctra.date_deb_ctra,
        rec_tmp_ctra.date_fin_ctra,
        rec_tmp_ctra.dpg,
        rec_tmp_ctra.fraisenv,
        rec_tmp_ctra.ca_imputation,
        rec_tmp_ctra.mnt_total_ctra,
        rec_tmp_ctra.siren_frs,
        rec_ligc.soccont,
        to_char(rec_ligc.ident),
        decode(rec_tmp_ctra.type_ctra,'ATU',UPPER(substr(rec_tmp_ctra.id_ressource,5)),null),
        rec_tmp_ctra.igg_ressource,
        rec_ress.rnom,
        rec_ress.rprenom,
        rec_ligc.lccouact,
        rec_tmp_ctra.date_deb_ressource,
        rec_tmp_ctra.date_fin_ressource,
        rec_tmp_ctra.charge_estimee,
        to_char(rec_ctra.cdatarr,'DD/MM/YYYY'),
        to_char(rec_ctra.cdatsai,'DD/MM/YYYY'),
        rec_tmp_ctra.objet_ctra,
        rec_tmp_ctra.cout_propose,
        rec_tmp_ctra.localisation,
        p_code_mess,
        p_message );

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_CRE_PRA_CONTRAT ===================
END P_CRE_PRA_CONTRAT;

PROCEDURE P_CRE_CONTRAT (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ctra    IN TMP_CONTRAT_PRA%ROWTYPE,
                rec_ctra    IN CONTRAT%ROWTYPE,
                rec_ligc    IN LIGNE_CONT%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE
                ) IS
-- ==============================================================================
-- Nom     :    P_CRE_CONTRAT (Procedure)
-- Description:    Procedure de creation de la table des contrats
--
-- ==============================================================================
--- Parametres d entree :
-- --------------------
--    P_HFILE     : Pointeur du fichier log
--    p_date_trait    : Date de traitement
--    rec_ctra    : Structure de données de la table CONTRAT
--    rec_tmp_ctra    : structure donnée recu de PRA
--
-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - JM.LEDOYEN - FICHE 1419 : création
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_CRE_CONTRAT'; -- nom de la procedure courante
l_etape        varchar2(255);
l_message    varchar2(255);

BEGIN

    -- ------------------------------------------
    -- Insertion dans la table des contrats
    -- ------------------------------------------

    l_etape := 'Insert CONTRAT';

    INSERT INTO CONTRAT
        (
        NUMCONT,
        CTYPFACT,
        COBJET1,
        COBJET2,
        COBJET3,
        CCHARESTI,
        CNAFFAIR,
        CCOUTHT,
        CDATARR,
        CDATDEB,
        CDATFIN,
        CDATDIR,
        CDATRPOL,
        CDATSAI,
        FLAGLOCK,
        SOCCONT,
        CAV,
        FILCODE,
        COMCODE,
        NICHE,
        CODSG,
        CCENTREFRAIS,
        SIREN,
        TOP30,
        ORICTR,
        CANTCONS)
    VALUES    (
        rec_ctra.numcont,
        rec_ctra.ctypfact,
        rec_ctra.cobjet1,
        rec_ctra.cobjet2,
        rec_ctra.cobjet3,
        nvl(rec_ctra.ccharesti,0),
        decode(rec_ctra.cav,'000','OUI','NON'),
        rec_ctra.ccoutht,
        rec_ctra.cdatarr,
        rec_ctra.cdatdeb,
        rec_ctra.cdatfin,
        rec_ctra.cdatarr,
        rec_ctra.cdatarr,
        rec_ctra.cdatsai,
        1,
        rec_ctra.soccont,
        rec_ctra.cav,
        rec_ctra.filcode,
        '6391504',
        1,
        rec_ctra.codsg,
        rec_ctra.ccentrefrais,
        rec_ctra.siren,
        'N',
        'PAC',
        0
        );

    l_etape :='Mise à jour de la log';
    ---------------------------------
    Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'numéro de contrat', NULL, rec_ctra.numcont,null,null,1, 'Création du contrat');
    Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'date début', NULL, rec_ctra.cdatdeb,null,null,1, 'Création du contrat');
    Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'date fin', NULL, rec_ctra.cdatfin,null,null,1, 'Création du contrat');
    Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'DPG', NULL, rec_ctra.codsg,null,null,1, 'Création du contrat');
    Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'Siren', NULL, rec_ctra.siren,null,null,1, 'Création du contrat');
    Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'Type facturation', NULL, rec_ctra.ctypfact,null,null,1, 'Création du contrat');


    l_message:='Contrat créé : Num = ' || rec_ctra.numcont;
    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || l_message );
    PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, p_date_trait, rec_tmp_ctra, rec_ctra,
                        rec_ligc, rec_ress, 1, l_message);
EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_CRE_CONTRAT ===================
END P_CRE_CONTRAT;

PROCEDURE P_MOD_CONTRAT (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ctra    IN TMP_CONTRAT_PRA%ROWTYPE,
                rec_ctra    IN CONTRAT%ROWTYPE,
                rec_ligc    IN LIGNE_CONT%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE,
                rec_ctra_bip    IN CONTRAT%ROWTYPE
                ) IS
-- ==============================================================================
-- Nom     :    P_MOD_CONTRAT (Procedure)
-- Description:    Procedure de modification de la table des contrats
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE     : Pointeur du fichier log
--    p_date_trait    : Date de traitement
--    rec_ctra    : Structure de données de la table CONTRAT
--    rec_tmp_ctra    : structure donnée recu de PRA
--    rec_ctra_bip    : Donnée existante en BIP
--
-- Parametres de sortie :
-- --------------------
--    l_maj        : réellement mis à jour 1 = oui, 0 = non
-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - JM.LEDOYEN - FICHE 1419 : création
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_MOD_CONTRAT'; -- nom de la procedure courante
l_etape        varchar2(255);
l_message    varchar2(255);

BEGIN

    -- ------------------------------------------
    -- mise à jour dans la table des contrats
    -- ------------------------------------------

    -- Test si l'on est réellemant en modification
    IF    rec_ctra.cobjet1 <> rec_ctra_bip.cobjet1 OR
        rec_ctra.cobjet2 <> rec_ctra_bip.cobjet2 OR
        rec_ctra.cobjet3 <> rec_ctra_bip.cobjet3 OR
        rec_ctra.ccharesti <> rec_ctra_bip.ccharesti OR
        rec_ctra.ccoutht <> rec_ctra_bip.ccoutht OR
        rec_ctra.cdatarr <> rec_ctra_bip.cdatarr OR
        rec_ctra.cdatdeb <> rec_ctra_bip.cdatdeb OR
        rec_ctra.cdatfin <> rec_ctra_bip.cdatfin OR
        rec_ctra.cdatmaj <> rec_ctra_bip.cdatmaj OR
        rec_ctra.cdatsai <> rec_ctra_bip.cdatsai OR
        rec_ctra.filcode <> rec_ctra_bip.filcode OR
        rec_ctra.codsg <> rec_ctra_bip.codsg OR
        rec_ctra.ccentrefrais <> rec_ctra_bip.ccentrefrais THEN

        l_etape := 'Update contrat';
        ----------------------------
        UPDATE CONTRAT
        SET     COBJET1=rec_ctra.cobjet1,
            COBJET2=rec_ctra.cobjet2,
            COBJET3=rec_ctra.cobjet3,
            CCHARESTI=nvl(rec_ctra.ccharesti,0),
            CCOUTHT=rec_ctra.ccoutht,
            CDATARR=rec_ctra.cdatarr,
            CDATDEB=rec_ctra.cdatdeb,
            CDATFIN=rec_ctra.cdatfin,
            CDATMAJ=rec_ctra.cdatmaj,
            CDATDIR=rec_ctra.cdatarr,
            CDATRPOL=rec_ctra.cdatarr,
            CDATSAI=rec_ctra.cdatsai,
            FILCODE=rec_ctra.filcode,
            CODSG=rec_ctra.codsg,
            CCENTREFRAIS=rec_ctra.ccentrefrais,
            ORICTR='PAC'
        WHERE    NUMCONT = rec_ctra.numcont AND
            SOCCONT = rec_ctra.soccont AND
            CAV = rec_ctra.cav;


        l_etape :='Mise à jour de la log';
        ---------------------------------
        Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'cobjet1', rec_ctra_bip.cobjet1, rec_ctra.cobjet1,null,null,3, 'Modification du contrat');
        Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'cobjet2', rec_ctra_bip.cobjet2, rec_ctra.cobjet2,null,null,3, 'Modification du contrat');
        Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'cobjet3', rec_ctra_bip.cobjet3, rec_ctra.cobjet3,null,null,3, 'Modification du contrat');
        Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'ccharesti', rec_ctra_bip.ccharesti, rec_ctra.ccharesti,null,null,3, 'Modification du contrat');
        Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'ccoutht', rec_ctra_bip.ccoutht, rec_ctra.ccoutht,null,null,3, 'Modification du contrat');
        Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'cdatarr', rec_ctra_bip.cdatarr, rec_ctra.cdatarr,null,null,3, 'Modification du contrat');
        Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'cdatdeb', rec_ctra_bip.cdatdeb, rec_ctra.cdatdeb,null,null,3, 'Modification du contrat');
        Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'cdatfin', rec_ctra_bip.cdatfin, rec_ctra.cdatfin,null,null,3, 'Modification du contrat');
        Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'cdatmaj', rec_ctra_bip.cdatmaj, rec_ctra.cdatmaj,null,null,3, 'Modification du contrat');
        Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'cdatsai', rec_ctra_bip.cdatsai, rec_ctra.cdatsai,null,null,3, 'Modification du contrat');
        Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'filcode', rec_ctra_bip.filcode, rec_ctra.filcode,null,null,3, 'Modification du contrat');
        Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'codsg', rec_ctra_bip.codsg, rec_ctra.codsg,null,null,3, 'Modification du contrat');
        Pack_contrat.maj_contrats_logs(rec_ctra.numcont,null, rec_ctra.soccont, rec_ctra.cav, rec_ctra.codsg, null, 'Batch prestachat', 'CONTRAT', 'ccentrefrais', rec_ctra_bip.ccentrefrais, rec_ctra.ccentrefrais,null,null,3, 'Modification du contrat');

        l_message:='Contrat modifié : Num = ' || rec_ctra.numcont;
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || l_message );
        PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, p_date_trait, rec_tmp_ctra, rec_ctra,
                            rec_ligc, rec_ress, 2, l_message);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_MOD_CONTRAT ===================
END P_MOD_CONTRAT;

PROCEDURE P_CRE_LIGNE_CONT (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ctra    IN TMP_CONTRAT_PRA%ROWTYPE,
                rec_ctra    IN CONTRAT%ROWTYPE,
                rec_ligc    IN LIGNE_CONT%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE
                ) IS
-- ==============================================================================
-- Nom     :    P_CRE_LIGNE_CONT (Procedure)
-- Description:    Procedure de creation de la table des lignes contrats
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE     : Pointeur du fichier log
--    rec_tmp_ligc    : Structure de données de la table tampon LIGNE_CONT
--    rec_ligc    : Structure de données de la table LIGNE_CONT
--
-- Parametres de sortie :
-- --------------------
--    Aucun
-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - JM.LEDOYEN - FICHE 1419 : création
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_CRE_LIGNE_CONT'; -- nom de la procedure courante
l_etape        varchar2(255);
l_message    varchar2(255);
l_lcnum        number(2,0);

BEGIN

    -- ------------------------------------------
    -- Insertion dans la table des lignes contrats
    -- ------------------------------------------

    l_etape := 'Détermination du numéro de ligne contrat';
    BEGIN
        SELECT    nvl(max(LCNUM),0) + 1
        INTO    l_lcnum
        FROM    LIGNE_CONT
        WHERE    SOCCONT = rec_ligc.soccont AND
            NUMCONT = rec_ligc.numcont AND
            CAV = rec_ligc.cav;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            l_lcnum :=1;
    END;

    l_etape := 'Insert LIGNE_CONT';

    INSERT INTO LIGNE_CONT
        (
        LCNUM,
        LRESDEB,
        LRESFIN,
        LCCOUACT,
        LCCOUINIT,
        LCPREST,
        SOCCONT,
        CAV,
        NUMCONT,
        IDENT,
        PROPORIG,
        MODE_CONTRACTUEL
        )
    VALUES    (
        l_lcnum,
        rec_ligc.lresdeb,
        rec_ligc.lresfin,
        rec_ligc.lccouact,
        rec_ligc.lccouinit,
        rec_ligc.lcprest,
        rec_ligc.soccont,
        rec_ligc.cav,
        rec_ligc.numcont,
        rec_ligc.ident,
        rec_ligc.proporig,
        rec_ligc.mode_contractuel
        );

    l_etape :='Mise à jour de la log';
    ---------------------------------
    Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, l_lcnum, 'Batch prestachat', 'LIGNE_CONT', 'lresdeb', null, rec_ligc.lresdeb,null,null,3, 'Creation de la ligne contrat');
    Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, l_lcnum, 'Batch prestachat', 'LIGNE_CONT', 'lresfin', null,rec_ligc.lresfin,null,null,3, 'Creation de la ligne contrat');
    Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, l_lcnum, 'Batch prestachat', 'LIGNE_CONT', 'ident', null, rec_ligc.ident,null,null,3, 'Creation de la ligne contrat');
    Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, l_lcnum, 'Batch prestachat', 'LIGNE_CONT', 'mode_contractuel', null, rec_ligc.mode_contractuel,null,null,3, 'Creation de la ligne contrat');


    l_message:='Ligne contrat créée : Num = ' || rec_ctra.numcont;
    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || l_message );
    PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, p_date_trait, rec_tmp_ctra, rec_ctra,
                        rec_ligc, rec_ress, 1, l_message);

EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_CRE_LIGNE_CONTRAT ===================
END P_CRE_LIGNE_CONT;

PROCEDURE P_MOD_LIGNE_CONT (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ctra    IN TMP_CONTRAT_PRA%ROWTYPE,
                rec_ctra    IN CONTRAT%ROWTYPE,
                rec_ligc    IN LIGNE_CONT%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE,
                rec_ligc_bip     IN LIGNE_CONT%ROWTYPE,
                p_maj        OUT INTEGER        -- mise à jour effective 1 oui, 0 sinon
                ) IS
-- ==============================================================================
-- Nom     :    P_MOD_LIGNE_CONT(Procedure)
-- Description:    Procedure de modification de la table LIGNE_CONT
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE     : Pointeur du fichier log
--    rec_ress    : Structure de données de la table LIGNE_CONT
--    rec_ress_
--
-- Parametres de sortie :
-- --------------------
--    Aucun
-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - JM.LEDOYEN - FICHE 1419 : Création
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_MOD_LIG_CONT'; -- nom de la procedure courante
l_etape        varchar2(255);
l_message    varchar2(255);

BEGIN

    p_maj := 0;

    -- on test si une des données est réélement modifiée
    IF    rec_ligc_bip.lresfin <> rec_ligc.lresfin OR
        rec_ligc_bip.lresdeb <> rec_ligc.lresdeb OR --PPM 60006 : Date début ligne contrat si elle a été modifiée
        rec_ligc_bip.lccouinit <> rec_ligc.lccouinit OR
        rec_ligc_bip.lccouact <> rec_ligc.lccouact OR
        rec_ligc_bip.proporig <> rec_ligc.proporig OR
        rec_ligc_bip.ident <> rec_ligc.ident OR
        rec_ligc_bip.mode_contractuel <> rec_ligc.mode_contractuel THEN

        -- ------------------------------------------
        -- Mise à jour de la table des Ressources
        -- ------------------------------------------

        p_maj := 1;

        l_etape := 'Update de la ligne contrat';

        -- On ne modifie pas l'IGG et le type de ressource
        UPDATE LIGNE_CONT SET
            LRESFIN=rec_ligc.lresfin,
            LRESDEB=rec_ligc.lresdeb, --PPM 60006
            LCCOUACT=rec_ligc.lccouact,
            LCCOUINIT=rec_ligc.lccouinit,
            LCPREST=rec_ligc.lcprest,
            IDENT=rec_ligc.ident,
            PROPORIG=rec_ligc.proporig,
            MODE_CONTRACTUEL=rec_ligc.mode_contractuel
        WHERE    SOCCONT = rec_ligc.soccont AND
            NUMCONT = rec_ligc.numcont AND
            CAV = rec_ligc.cav    AND
            LCNUM=rec_ligc.lcnum;

        l_etape :='Mise à jour de la log';
        ---------------------------------
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', rec_ligc_bip.lcnum, 'lresdeb', rec_ligc_bip.lresdeb, rec_ligc.lresdeb,null,null,3, 'Modification de la ligne contrat');--PPM 60006
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', rec_ligc_bip.lcnum, 'lresfin', rec_ligc_bip.lresfin, rec_ligc.lresfin,null,null,3, 'Modification de la ligne contrat');
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', rec_ligc_bip.lcnum, 'lccouact', rec_ligc_bip.lccouact, rec_ligc.lccouact,null,null,3, 'Modification de la ligne contrat');
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', rec_ligc_bip.lcnum, 'lccouinit', rec_ligc_bip.lccouinit, rec_ligc.lccouinit,null,null,3, 'Modification de la ligne contrat');
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', rec_ligc_bip.lcnum, 'lcprest', rec_ligc_bip.lcprest, rec_ligc.lcprest,null,null,3, 'Modification de la ligne contrat');
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', rec_ligc_bip.lcnum, 'ident', rec_ligc_bip.ident, rec_ligc.ident,null,null,3, 'Modification de la ligne contrat');
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', rec_ligc_bip.lcnum, 'proporig', rec_ligc_bip.proporig, rec_ligc.proporig,null,null,3, 'Modification de la ligne contrat');
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', rec_ligc_bip.lcnum, 'mode_contractuel', rec_ligc_bip.mode_contractuel, rec_ligc.mode_contractuel,null,null,3, 'Modification de la ligne contrat');

        l_message:='Ligne contrat modifiée : Ident = ' || to_char(rec_ress.ident);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || l_message );
        PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, p_date_trait, rec_tmp_ctra, rec_ctra,
                            rec_ligc, rec_ress, 2, l_message);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_MOD_LIGNE_CONT ===================
END P_MOD_LIGNE_CONT;

--PPM 60006 
PROCEDURE P_DEL_LIGNE_CONT (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ctra    IN TMP_CONTRAT_PRA%ROWTYPE,
                rec_ctra    IN CONTRAT%ROWTYPE,
                rec_ligc    IN LIGNE_CONT%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE,
                rec_ligc_bip     IN LIGNE_CONT%ROWTYPE
                ) IS
-- ==============================================================================
-- Nom     :    P_DEL_LIGNE_CONT(Procedure)
-- Description:    Procedure de suppression d'un ligne contrat
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE     : Pointeur du fichier log
--    rec_ress    : Structure de données de la table LIGNE_CONT
--    rec_ress_
--
-- Parametres de sortie :
-- --------------------
--    Aucun
-- ==============================================================================
-- Historique :
-- ------------
-- 13/10/2014 - KRA - PPM 60006 : Création
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_DEL_LIGNE_CONT'; -- nom de la procedure courante
l_etape        varchar2(255);
l_message    varchar2(255);

BEGIN

        -- ------------------------------------------
        -- Supression de ligne contrat
        -- ------------------------------------------
        l_etape := 'Supression de la ligne contrat';

        DELETE FROM LIGNE_CONT
        WHERE    SOCCONT = rec_ligc.soccont AND
            NUMCONT = rec_ligc.numcont AND
            CAV = rec_ligc.cav    AND
            LCNUM=rec_ligc.lcnum AND
            IDENT = rec_ligc.ident;

        l_etape :='Mise à jour de la log';
        ---------------------------------
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', 'LIGNE_CONT', 'lresdeb', rec_ligc.lresdeb, null,null,null,3, 'Ligne contrat supprimee');
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', 'LIGNE_CONT', 'lresfin', rec_ligc.lresfin, null,null,null,3, 'Ligne contrat supprimee');
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', 'LIGNE_CONT', 'lccouact', rec_ligc.lccouact, null,null,null,3, 'Ligne contrat supprimee');
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', 'LIGNE_CONT', 'lccouinit', rec_ligc.lccouinit, null,null,null,3, 'Ligne contrat supprimee');
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', 'LIGNE_CONT', 'lcprest', rec_ligc.lcprest, null,null,null,3, 'Ligne contrat supprimee');
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', 'LIGNE_CONT', 'ident', rec_ligc.ident, null,null,null,3, 'Ligne contrat supprimee');
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', 'LIGNE_CONT', 'proporig', rec_ligc.proporig, null,null,null,3, 'Ligne contrat supprimee');
        Pack_contrat.maj_contrats_logs(rec_ligc.numcont,null, rec_ligc.soccont, rec_ligc.cav, null, rec_ligc.lcnum, 'Batch prestachat', 'LIGNE_CONT', 'mode_contractuel', rec_ligc.mode_contractuel, null,null,null,3, 'Ligne contrat supprimee');

        l_message:='Ligne contrat supprimee : Ident = ' || to_char(rec_ress.ident);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || l_message );
        PACK_PRA_RESS_CONT.P_CRE_PRA_CONTRAT (    P_HFILE, p_date_trait, rec_tmp_ctra, rec_ctra,
                            rec_ligc, rec_ress, 2, l_message);

EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_DEL_LIGNE_CONT ===================
END P_DEL_LIGNE_CONT;
--PPM 60006 fin

FUNCTION verif_situ(p_ident IN NUMBER, datedeb IN DATE, datefin IN DATE) RETURN INTEGER IS

      i INTEGER;
begin
      i:=0;
      for rec in (select datsitu, datdep
                        from situ_ress
                        where ident = p_ident
                        )
      loop
          if ((to_char(rec.datdep,'YYYYMM') = to_char(datedeb,'YYYYMM'))
             or (to_char(rec.datsitu,'YYYYMM') = to_char(datefin,'YYYYMM')))
          then
            i:=i+1;

          end if;
      end loop;
      return i;
END  verif_situ;

PROCEDURE P_PRA_RESS_CONT_OPT(P_LOGDIR VARCHAR2, p_chemin_fichier  IN VARCHAR2, p_nom_fichier   IN VARCHAR2) IS
-- ==============================================================================
-- Nom     :    P_PRA_RESS_CONT_OPT (Procedure)
-- Description:    Procédure d'optimisation des ressources/ situations
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    PLOGDIR : Directory du fichier de log
--    p_chemin_fichier : Chemin du fichier où exporter
--    p_nom_fichier : Nom du fichier à exporter
-- Parametres de sortie :
-- --------------------
--    Aucun

--
-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - STERIA - PPM 45977 : création
-- ==============================================================================

    P_HFILE        utl_file.file_type;     -- Pointeur de fichier log
    L_RETCOD    number;            -- Receptionne le code retour d'une procedure
    L_PROCNAME     varchar2(30):='P_PRA_RESS_CONT_OPT'; -- nom de la procedure courante
    l_etape        varchar2(255):='';
    l_cout_total        varchar2(255):='';
    l_insert        number(1,0):=0;
    NbLigneOpt  NUMBER(6):=0;
    Nbligne2 NUMBER(3):=0;
    l_date_deb_en_cours     date:= null;
    l_date_fin_en_cours     date:= null;
    l_date_deb_precedente date:= null;
    l_date_fin_precedente date:= null;
    l_ca_imputation varchar2(255):='';--PPM 60006
    --l_date_deb_en_cours     tmp_ressource_pra.date_deb_ressource%TYPE;
    --l_date_fin_en_cours     tmp_ressource_pra.date_fin_ressource%TYPE;
    --l_date_deb_precedente tmp_ressource_pra.date_deb_ressource%TYPE;
    --l_date_fin_precedente tmp_ressource_pra.date_fin_ressource%TYPE;

BEGIN

    TRCLOG.TRCLOG(P_HFILE, L_PROCNAME || ': Début ressource / situation PRA : '|| to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS'));
    l_etape := 'Optimisation du fichier ressource';

    -- Purge de la table d'optimisation des ressources
    -- --------------------------------- ---------

    DELETE FROM TMP_RESSOURCE_PRA_OPT;
    COMMIT;
    -- Boucle sur la table tampon des ressources et situations
    -- -------------------------------------------------------
    FOR REC1 IN (SELECT * FROM TMP_RESSOURCE_PRA ORDER BY igg_ressource, id_ressource, to_date(date_deb_ressource, 'dd/MM/yyyy'), to_date(date_fin_ressource, 'dd/MM/yyyy') )
    LOOP

    BEGIN
      NbLigneOpt:=0;

      SELECT COUNT(*) as NbLigne
          INTO NbLigneOpt
          FROM TMP_RESSOURCE_PRA_OPT
          WHERE type_ctra=REC1.type_ctra
          AND localisation=REC1.localisation
          AND dpg=REC1.dpg
          AND fraisenv=REC1.fraisenv
        --  AND ca_imputation=REC1.ca_imputation --PPM 60006
          AND taux=REC1.taux
          AND metier=REC1.metier
          AND complexite=REC1.complexite
          AND matricule_do=REC1.matricule_do
          AND igg_do=REC1.igg_do
          AND siren_frs=REC1.siren_frs
          AND id_ressource=REC1.id_ressource
          AND ((igg_ressource=REC1.igg_ressource) OR (igg_ressource IS NULL AND REC1.igg_ressource IS NULL ))
          AND ((nom_ressource=REC1.nom_ressource) OR (nom_ressource IS NULL AND REC1.nom_ressource IS NULL ))
          AND ((prenom_ressource=REC1.prenom_ressource) OR (prenom_ressource IS NULL AND REC1.prenom_ressource IS NULL ))
          AND ((disponibilite=REC1.disponibilite) OR (disponibilite IS NULL AND REC1.disponibilite IS NULL ))
          AND mnt_mensuel=REC1.mnt_mensuel
          --AND cout_total=REC1.cout_total
          ORDER BY id_ressource, igg_ressource, to_date(date_deb_ressource, 'dd/MM/yyyy'), to_date(date_fin_ressource, 'dd/MM/yyyy');


     EXCEPTION
        WHEN NO_DATA_FOUND THEN
             NbLigneOpt :=0;
        -- Vue distante contenant uniquement la ligne courante.
        -- -----------------------------------------------------
        l_date_deb_precedente := null;
        l_date_fin_precedente := null;
     END;

     -- Si on a des lignes dans la table optimisé, cela signifie que cet enregistrement a déjà été traité, on passe à la ligne suivante.
     IF NbLigneOpt  < 1 THEN

      l_etape := 'Recherche des lignes ayant pour critères les valeurs de la ligne en cours dans la première vue distante';
      FOR REC2 IN (SELECT
              type_ctra,
              localisation,
              dpg,
              fraisenv,
              ca_imputation,
              taux,
              metier,
              complexite,
              matricule_do,
              igg_do,
              siren_frs,
              id_ressource,
              igg_ressource,
              nom_ressource,
              prenom_ressource,
              date_deb_ressource,
              date_fin_ressource,
              disponibilite,
              mnt_mensuel,
              cout_total
          FROM TMP_RESSOURCE_PRA
          WHERE type_ctra=REC1.type_ctra
          AND localisation=REC1.localisation
          AND dpg=REC1.dpg
          AND fraisenv=REC1.fraisenv
         -- AND ca_imputation=REC1.ca_imputation --PPM 60006
          AND taux=REC1.taux
          AND metier=REC1.metier
          AND complexite=REC1.complexite
          AND matricule_do=REC1.matricule_do
          AND igg_do=REC1.igg_do
          AND siren_frs=REC1.siren_frs
          AND id_ressource=REC1.id_ressource
          AND ((igg_ressource=REC1.igg_ressource) OR (igg_ressource IS NULL AND REC1.igg_ressource IS NULL ))
          AND ((nom_ressource=REC1.nom_ressource) OR (nom_ressource IS NULL AND REC1.nom_ressource IS NULL ))
          AND ((prenom_ressource=REC1.prenom_ressource) OR (prenom_ressource IS NULL AND REC1.prenom_ressource IS NULL ))
          AND ((disponibilite=REC1.disponibilite) OR (disponibilite IS NULL AND REC1.disponibilite IS NULL ))
          AND mnt_mensuel=REC1.mnt_mensuel
          --AND cout_total=REC1.cout_total
          group by type_ctra, localisation, dpg, fraisenv, ca_imputation, taux, metier, complexite, matricule_do, igg_do, siren_frs, id_ressource, igg_ressource, nom_ressource, prenom_ressource, date_deb_ressource, date_fin_ressource, disponibilite, mnt_mensuel, cout_total
          ORDER BY igg_ressource, id_ressource, to_date(date_deb_ressource, 'dd/MM/yyyy'), to_date(date_fin_ressource, 'dd/MM/yyyy')
          )

      LOOP

         l_etape := 'Boucle dans la deuxième vue distante';
         -- Si la ligne est unique, pas besoin d'être optimisé

            l_etape :='';
            l_insert := 1;
            l_date_deb_en_cours := to_date(REC2.date_deb_ressource, 'dd/MM/yyyy');
            l_date_fin_en_cours := to_date(REC2.date_fin_ressource, 'dd/MM/yyyy');
      --If (NbLigne2 <> 1) THEN
            -- Si on est sur la première ligne de la vue distante 2
            IF l_date_deb_precedente is null THEN
                -- On affecte une valeur de début et de fin
                l_date_deb_precedente := l_date_deb_en_cours;
                l_date_fin_precedente := l_date_fin_en_cours;
                l_cout_total := REC2.cout_total;
            ELSE
                -- Si on est au moins sur la deuxième date
                -- et si les dates de fin de la précédente et
                -- début de celle en cours se suivent.
               IF l_date_deb_en_cours = l_date_fin_precedente + 1 THEN
                   -- On affecte la nouvelle valeur date de fin
                   -- et on continue à boucler.
                    l_date_fin_precedente := l_date_fin_en_cours;
                    l_ca_imputation := REC2.ca_imputation; --PPM 60006 :CA d'imputation du tampon = CA d'imputation en entrée,                   
                ELSE
                    -- INSERT AVEC LES DATES PRECEDENTES
                    INSERT INTO TMP_RESSOURCE_PRA_OPT
                        VALUES (REC2.type_ctra,
                          REC2.localisation,
                          REC2.dpg,
                          REC2.fraisenv,
                          REC2.ca_imputation,
                          REC2.taux,
                          REC2.metier,
                          REC2.complexite,
                          REC2.matricule_do,
                          REC2.igg_do,
                          REC2.siren_frs,
                          REC2.id_ressource,
                          REC2.igg_ressource,
                          REC2.nom_ressource,
                          REC2.prenom_ressource,
                          TO_CHAR(l_date_deb_precedente,'dd/MM/yyyy'),
                          TO_CHAR(l_date_fin_precedente,'dd/MM/yyyy'),
                          REC2.disponibilite,
                          REC2.mnt_mensuel,
                          REC2.cout_total
                          );
                      COMMIT;
                    -- ON REMPLIT LES DATES PRECEDENTES
                    l_date_deb_precedente := l_date_deb_en_cours;
                    l_date_fin_precedente := l_date_fin_en_cours;

                    --  GOTO end_loop;
                END IF;
            END IF;
      --END IF;

       -- <<end_loop>>
        --null;
      END LOOP;

      IF l_insert = 1 THEN
        -- INSERT AVEC LES DATES PRECEDENTES
        INSERT INTO TMP_RESSOURCE_PRA_OPT
            VALUES (REC1.type_ctra,
              REC1.localisation,
              REC1.dpg,
              REC1.fraisenv,
              l_ca_imputation,--REC1.ca_imputation,--PPM 60006 
              REC1.taux,
              REC1.metier,
              REC1.complexite,
              REC1.matricule_do,
              REC1.igg_do,
              REC1.siren_frs,
              REC1.id_ressource,
              REC1.igg_ressource,
              REC1.nom_ressource,
              REC1.prenom_ressource,
              TO_CHAR(l_date_deb_precedente,'dd/MM/yyyy'),
              TO_CHAR(l_date_fin_precedente,'dd/MM/yyyy'),
              REC1.disponibilite,
              REC1.mnt_mensuel,
              l_cout_total
              );
          COMMIT;
          l_insert := 0;
        END IF;

      -- ON VIDE LES DATES PRECEDENTES
      l_date_deb_precedente := null;
      l_date_fin_precedente := null;
    END IF;

    END LOOP;

    PACK_PRA_RESS_CONT.SELECT_EXPORT_PRA_OPT (P_HFILE, p_chemin_fichier, p_nom_fichier);

    -- On vide la table temporaire d'origine
    DELETE FROM TMP_RESSOURCE_PRA;
    COMMIT;

    -- On y réinjecte les enregistrements optimisés
    -- ORDER BY igg_ressource, id_ressource, to_date(date_deb_ressource, 'dd/MM/yyyy'), to_date(date_fin_ressource, 'dd/MM/yyyy')
    --INSERT INTO TMP_RESSOURCE_PRA (SELECT * FROM TMP_RESSOURCE_PRA_OPT );
    --COMMIT;

   /* FOR REC3 IN (SELECT * FROM TMP_RESSOURCE_PRA_OPT ORDER BY igg_ressource, id_ressource, to_date(date_deb_ressource, 'dd/MM/yyyy'), to_date(date_fin_ressource, 'dd/MM/yyyy'))
    LOOP
        INSERT INTO TMP_RESSOURCE_PRA VALUES (
              REC3.type_ctra,
              REC3.localisation,
              REC3.dpg,
              REC3.fraisenv,
              REC3.ca_imputation,
              REC3.taux,
              REC3.metier,
              REC3.complexite,
              REC3.matricule_do,
              REC3.igg_do,
              REC3.siren_frs,
              REC3.id_ressource,
              REC3.igg_ressource,
              REC3.nom_ressource,
              REC3.prenom_ressource,
              REC3.date_deb_ressource,
              REC3.date_fin_ressource,
              REC3.disponibilite,
              REC3.mnt_mensuel,
              REC3.cout_total);
        COMMIT;
    END LOOP; */
    DUPLICATE_FROM_PRA_TO_OPT;

EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_PRA_RESS_CONT_MAIN ===================
END P_PRA_RESS_CONT_OPT;

PROCEDURE DUPLICATE_FROM_PRA_TO_OPT IS

CURSOR curs_PRA_OPT IS
SELECT     type_ctra,
        localisation,
        dpg,
        fraisenv,
        ca_imputation,
        taux,
        metier,
        complexite,
        matricule_do,
        igg_do,
        siren_frs,
        id_ressource,
        igg_ressource,
        nom_ressource,
        prenom_ressource,
        date_deb_ressource,
        date_fin_ressource,
        disponibilite,
        mnt_mensuel,
        cout_total
FROM      TMP_RESSOURCE_PRA_OPT
ORDER BY igg_ressource, id_ressource, to_date(date_deb_ressource, 'dd/MM/yyyy'), to_date(date_fin_ressource, 'dd/MM/yyyy') ;

l_msg  VARCHAR2(1024);

    BEGIN

      FOR REC3 IN curs_PRA_OPT
      LOOP
        INSERT INTO TMP_RESSOURCE_PRA VALUES (
              REC3.type_ctra,
              REC3.localisation,
              REC3.dpg,
              REC3.fraisenv,
              REC3.ca_imputation,
              REC3.taux,
              REC3.metier,
              REC3.complexite,
              REC3.matricule_do,
              REC3.igg_do,
              REC3.siren_frs,
              REC3.id_ressource,
              REC3.igg_ressource,
              REC3.nom_ressource,
              SUBSTR(REC3.prenom_ressource,1,15),
              REC3.date_deb_ressource,
              REC3.date_fin_ressource,
              REC3.disponibilite,
              REC3.mnt_mensuel,
              REC3.cout_total);
      END LOOP;

    EXCEPTION
          WHEN OTHERS THEN
           Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
           RAISE_APPLICATION_ERROR(-20401, l_msg);

END DUPLICATE_FROM_PRA_TO_OPT;

PROCEDURE SELECT_EXPORT_PRA_OPT(P_HFILE IN utl_file.file_type, p_chemin_fichier IN VARCHAR2, p_nom_fichier    IN VARCHAR2) IS

CURSOR curs_PRA_OPT IS
SELECT     type_ctra,
        localisation,
        dpg,
        fraisenv,
        ca_imputation,
        taux,
        metier,
        complexite,
        matricule_do,
        igg_do,
        siren_frs,
        id_ressource,
        igg_ressource,
        nom_ressource,
        prenom_ressource,
        date_deb_ressource,
        date_fin_ressource,
        disponibilite,
        mnt_mensuel,
        cout_total
FROM      TMP_RESSOURCE_PRA_OPT
ORDER BY igg_ressource, id_ressource, to_date(date_deb_ressource, 'dd/MM/yyyy'), to_date(date_fin_ressource, 'dd/MM/yyyy') ;

L_HFILE                              UTL_FILE.FILE_TYPE;
L_RETCOD                        NUMBER;
l_msg  VARCHAR2(1024);

    BEGIN

        -----------------------------------------------------
        -- Génération du fichier.
        -----------------------------------------------------
     Pack_Global.INIT_WRITE_FILE(p_chemin_fichier, p_nom_fichier, l_hfile);
    Pack_Global.WRITE_STRING(l_hfile, 'OAL_BIP_INTERVENANTS_;03062013_233141');
   Pack_Global.WRITE_STRING( l_hfile,
        'TYPE_CTRA;LOCALISATION;DPG;FRAISENV;CA_IMPUTATION;TAUX;METIER;COMPLEXITE;' ||
        'MATRICULE_DO;IGG_DO;SIREN_FRS;ID_RESSOURCE;IGG_RESSOURCE;NOM_RESSOURCE;PRENOM_RESSOURCE;' ||
    'DATE_DEB_RESSOURCE;DATE_FIN_RESSOURCE;DISPONIBILITE;MNT_MENSUEL;COUT_TOTAL;');

      FOR cur_enr IN curs_PRA_OPT
      LOOP
        Pack_Global.WRITE_STRING( l_hfile,
        cur_enr.type_ctra     || ';' ||
        cur_enr.localisation  || ';' ||
        cur_enr.dpg           || ';' ||
        cur_enr.fraisenv      || ';' ||
        cur_enr.ca_imputation || ';' ||
        cur_enr.taux          || ';' ||
        cur_enr.metier        || ';' ||
        cur_enr.complexite    || ';' ||
        cur_enr.matricule_do  || ';' ||
        cur_enr.igg_do        || ';' ||
        cur_enr.siren_frs     || ';' ||
        cur_enr.id_ressource  || ';' ||
        cur_enr.igg_ressource || ';' ||
        cur_enr.nom_ressource || ';' ||
        cur_enr.prenom_ressource  || ';' ||
        cur_enr.date_deb_ressource  || ';' ||
        cur_enr.date_fin_ressource  || ';' ||
        cur_enr.disponibilite   || ';' ||
        cur_enr.mnt_mensuel     || ';' ||
        cur_enr.cout_total);
      END LOOP;

    Pack_Global.CLOSE_WRITE_FILE(l_hfile);

    EXCEPTION
          WHEN OTHERS THEN
           Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
           RAISE_APPLICATION_ERROR(-20401, l_msg);

END SELECT_EXPORT_PRA_OPT;

/* PPM 49340 : */

/*
 * Calcul du nombre de consommé d'une ressource entre janvier de l'année de sa création
 * jusqu'à la dernière mensuelle exécutée de l'année en cours.
 */
 --SEL 03/12/2014 Optimisation traitement de verification de l existence du consomme d une ressource
FUNCTION calcul_consomme(
 ress_ident IN RESSOURCE.IDENT%TYPE,
 d_creation IN RESSOURCE_LOGS.DATE_LOG%TYPE
) return integer is
	nb_consomme integer;
BEGIN
	select count(*) into nb_consomme from (
		select IDENT from CONS_SSTACHE_RES_MOIS_ARCHIVE where IDENT = ress_ident
		union select IDENT from CONS_SSTACHE_RES_MOIS where IDENT = ress_ident
		union select IDENT from BIPA.ARCHIVE_CONS_SSTACHE_RES_MOIS where IDENT = ress_ident




	);
	return nb_consomme;
END calcul_consomme;

/*
 * Calcul du nombre d'écriture comptable STOCK_FI d'une ressource entre janvier de l'année de sa création
 * jusqu'à la dernière mensuelle exécutée de l'année en cours.
 */
 --SEL 03/12/2014 Optimisation traitement de verification de l existence du stock fi d une ressource
FUNCTION calcul_stock_fi(
 ress_ident IN RESSOURCE.IDENT%TYPE,
 d_creation IN RESSOURCE_LOGS.DATE_LOG%TYPE
) return integer is
	nb_stock_fi integer;
BEGIN
	select count(*) into nb_stock_fi from (






		select IDENT from STOCK_FI where IDENT = ress_ident
		union select IDENT from HISTO_STOCK_FI where IDENT = ress_ident
		union select IDENT from BIPA.ARCHIVE_HISTO_STOCK_FI where IDENT = ress_ident

	);
  
	return nb_stock_fi;
END calcul_stock_fi;

/*
 * Calcul du nombre d'écriture comptable STOCK_IMMO d'une ressource entre janvier de l'année de sa création
 * jusqu'à la dernière mensuelle exécutée de l'année en cours.
 */
 --SEL 03/12/2014 Optimisation traitement de verification de l existence du stock immo d une ressource
FUNCTION calcul_stock_immo(
 ress_ident IN RESSOURCE.IDENT%TYPE,
 d_creation IN RESSOURCE_LOGS.DATE_LOG%TYPE
) return integer is
	nb_stock_immo integer;
BEGIN
	select count(*) into nb_stock_immo from (
		select IDENT from STOCK_IMMO where IDENT = ress_ident

		union select IDENT from HISTO_STOCK_IMMO where IDENT = ress_ident
		union select IDENT from BIPA.ARCHIVE_HISTO_STOCK_IMMO where IDENT = ress_ident




	) ; 
	return nb_stock_immo;
END calcul_stock_immo;

FUNCTION verif_eligible(
 P_HFILE IN utl_file.file_type,
 rec_ress IN RESSOURCE%ROWTYPE
) return integer IS
	nb_consomme integer;
	nb_stock_fi integer;
	nb_stock_immo integer;
	d_creation RESSOURCE_LOGS.DATE_LOG%TYPE;
	d_situ_futur SITU_RESS.DATSITU%TYPE;
	nb_ress_maitre integer;
	nb_contrat integer;
	diff_contrat integer;
	nb_sous_ress integer;
	l_prenom RESSOURCE.RPRENOM%TYPE;
	d_datevalide date;
        nb_soccode integer;
        L_PROCNAME varchar2(30):='verif_eligible';
        l_etape varchar2(255);
        d_prenom date;-- QC 1620
BEGIN
  l_etape := 'Date de creation ressource';
  --Date de creation de la ressource
    --select distinct DATE_LOG into d_creation from RESSOURCE_LOGS where IDENT = rec_ress.ident and COMMENTAIRE like 'Création de la ressource%'; --QC 1619
    --QC 1638 : modification de la requête pour ramener une seule ligne correspondante à la date la plus ancienne de la creation de ressource
  BEGIN
  select min(DATE_LOG) into d_creation from RESSOURCE_LOGS
  where IDENT = rec_ress.ident
  and UPPER(commentaire) like '%CR%'
  and upper(nom_table) like '%RESSOURCE%'
  and UPPER(commentaire) not like '%NIV%';
  EXCEPTION WHEN
        NO_DATA_FOUND THEN
		-- FAD PPM 64864 Corrective : Initialiser la date de création au 01/01/1970 dans le cas ou on ne trouve pas de date de création de la ressource
        --return 0;
		-- FAD PPM 64864 Corrective QC 1969
		d_creation := TO_TIMESTAMP('01/01/1970 00:00:10.123000', 'DD/MM/YYYY HH24:MI:SS.FF');
		-- FAD PPM 64864 Corrective QC 1969 Fin
		-- FAD PPM 64864 Corrective : Fin
  END;
  --QC 1640 : controle de la date de creation
  if(d_creation is null) then
	-- FAD PPM 64864 Corrective QC 1969
	--return 0; -- Ressource non-éligible
	d_creation := TO_TIMESTAMP('01/01/1970 00:00:10.123000', 'DD/MM/YYYY HH24:MI:SS.FF');
	-- FAD PPM 64864 Corrective QC 1969 Fin
  end if;

  l_etape := 'Date de recyclage atteint';
  --Date de recyclage atteint
  --l_prenom := rec_ress.rprenom;
  --l_prenom := substr(l_prenom,1,10);
  --l_prenom := to_date(l_prenom, 'dd/MM/yyyy')-30 ;

  -- QC 1620 : Ajout de controle pour verifier si le prenom contient une date au debut ou non
  --l_prenom := to_date((substr(rec_ress.rprenom,1,10)), 'dd/MM/yyyy')-30;
  -- date_rprenom recupère la date indiqué dans les 10 premiers caractères du prénom
  d_prenom := date_rprenom(rec_ress.rprenom);
  -- vérifciation si la ressoucre a atteint sa date de recyclage au + tot.
  if (d_prenom is null OR d_prenom > sysdate) then
		--Ressource non-éligible
		return 0;
	end if;

  l_etape := 'Date de depart vide pour ressource interne';
  --Date de départ vide pour une ressource interne.
  -- FAD PPM 65070 Corrective
  --select count(*) into nb_soccode from SITU_RESS where IDENT = rec_ress.ident AND SOCCODE = 'SG..' and DATDEP is not null;
/*  SELECT COUNT(*) INTO NB_SOCCODE FROM SITU_RESS WHERE IDENT = REC_RESS.IDENT AND SOCCODE = 'SG..' AND DATDEP IS NOT NULL
  AND DATSITU = (SELECT MAX(DATSITU) FROM SITU_RESS WHERE IDENT = REC_RESS.IDENT AND SOCCODE = 'SG..');
  -- FAD PPM 65070 Corrective Fin
  if (nb_soccode > 0) then
      --Ressource non-éligible
      return 0;
  end if;*/

  l_etape := 'Date de creation valide';
  --Date de création valide
  d_datevalide := sysdate - 30;
  if (d_creation > d_datevalide) then
      --Ressource non-éligible
      return 0;
	end if;

  l_etape := 'Ressource non fictive';
 --Ressource non fictive
  select count(*) into nb_sous_ress from SITU_RESS where IDENT = rec_ress.ident AND PRESTATION = 'FIC';
  if (nb_sous_ress > 0) then
      --Ressource non-éligible
      return 0;
	end if;

  l_etape := 'Ressource non generique';
  --Ressource non générique
  select count(*) into nb_sous_ress from RESSOURCE where RNOM = 'GENERIQUE-' || rec_ress.ident;
  if (nb_sous_ress > 0) then
      --Ressource non-éligible
      return 0;
	end if;
--
	l_etape := 'Ressource sans consomme et sans ecriture dans les stocks';
	--Ressource sans consommé (nb_consomme = 0)
	--Ressource sans écriture dans les STOCK_FI et STOCK_IMMO (nb_stock_fi = 0 et nb_stock_immo = 0)
        declare
            cursor c_situ is select * from SITU_RESS where IDENT = rec_ress.ident;
            rec_situ SITU_RESS%ROWTYPE;
        begin
            for rec_situ in c_situ loop
              if (rec_situ.prestation = 'IFO') then
                  --Pas de consommé sur elle-même ou sur le code ressource du CP
                  nb_consomme := calcul_consomme(rec_situ.cpident, d_creation) + calcul_consomme(rec_ress.ident, d_creation);
                  if (nb_consomme > 0) then
                          --Ressource non-éligible
                          return 0;
                  end if;

                  --Pas d'écriture sur elle-même ou sur le code ressource du CP (STOCK_FI)
                  nb_stock_fi := calcul_stock_fi(rec_situ.cpident, d_creation) + calcul_stock_fi(rec_ress.ident, d_creation);
                  if (nb_stock_fi > 0) then
                          --Ressource non-éligible
                          return 0;
                  end if;

                  --Pas d'écriture sur elle-même ou sur le code ressource du CP (STOCK_IMMO)
                  nb_stock_immo := calcul_stock_immo(rec_situ.cpident, d_creation) + calcul_stock_immo(rec_ress.ident, d_creation);
                  if (nb_stock_immo > 0) then
                          --Ressource non-éligible
                          return 0;
                  end if;

              elsif (rec_situ.prestation = 'SLT') then
		--Pas de consommé sur le code ressource de l'ident forfait
		nb_consomme := calcul_consomme(rec_situ.fident, d_creation);
		if (nb_consomme > 0) then
			--Ressource non-éligible
			return 0;
		end if;

		--Pas d'écriture sur elle-même ou sur le code ressource du CP (STOCK_FI)
		nb_stock_fi := calcul_stock_fi(rec_situ.fident, d_creation);
		if (nb_stock_fi > 0) then
			--Ressource non-éligible
			return 0;
		end if;

		--Pas d'écriture sur elle-même ou sur le code ressource du CP (STOCK_IMMO)
		nb_stock_immo := calcul_stock_immo(rec_situ.fident, d_creation);
		if (nb_stock_immo > 0) then
			--Ressource non-éligible
			return 0;
		end if;

              else
		--Pas de consommé sur elle-même
		nb_consomme := calcul_consomme(rec_ress.ident, d_creation);
		if (nb_consomme > 0) then
			--Ressource non-éligible
			return 0;
		end if;

		--Pas d'écriture sur elle-même (STOCK_FI)
		nb_stock_fi := calcul_stock_fi(rec_ress.ident, d_creation);
		if (nb_stock_fi > 0) then
			--Ressource non-éligible
			return 0;
		end if;

		--Pas d'écriture sur elle-même (STOCK_IMMO)
		nb_stock_immo := calcul_stock_immo(rec_ress.ident, d_creation);
		if (nb_stock_immo > 0) then
			--Ressource non-éligible
			return 0;
		end if;

              end if;
            end loop;
        end;

        l_etape := 'Situation dans le futur';
	--Situation dans le futur : ne doit pas être ultérieure à la date du jour
	select max(DATSITU) into d_situ_futur from SITU_RESS where IDENT = rec_ress.ident;
	if (d_situ_futur > sysdate) then
		--Ressource non-éligible
		return 0;
	end if;

        l_etape := 'Ressource non maitre';
	--Ressource non maître : par le code ressource CP ou ident forfait
	-- FAD PPM 65070 Corrective
	--select count(*) into nb_ress_maitre from SITU_RESS where CPIDENT = rec_ress.ident or FIDENT = rec_ress.ident;
	SELECT COUNT(*) INTO NB_RESS_MAITRE FROM SITU_RESS WHERE (CPIDENT = REC_RESS.IDENT OR FIDENT = REC_RESS.IDENT) AND IDENT != REC_RESS.IDENT;
	-- FAD PPM 65070 Corrective Fin
	if (nb_ress_maitre > 0) then
		--Ressource non-éligible
		return 0;
	end if;

        l_etape := 'Aucun contrat';
	--Lien avec un contrat :
	--Aucun contrat
	select count(*) into nb_contrat from LIGNE_CONT where IDENT = rec_ress.ident;
	--Ou plusieurs contrats mais la date de fin de la ligne contrat la plus dans le futur est échu depuis plus de 30 jours
	select trunc(sysdate) - trunc(max(LRESFIN)) into diff_contrat from LIGNE_CONT where IDENT = rec_ress.ident;
	if (nb_contrat > 0 and diff_contrat <= 30) then
		--Ressource non-éligible
		return 0;
	end if;

        l_etape := 'Pas une ressource principale';
	--Pas une ressource principale
	if (rec_ress.rtype = 'P') then
		--Si prestataire au temps passé, un clone existe s'il y a une ressource ayant le même matricule 
    -- QC 1639 : sauf le 1er car. avec un Y OU le même IGG sauf le 1er chiffre avec un 9 
		-- FAD PPM 64864 Corrective : Si la ressource a un matricule avec Y ou IGG avec 9 alors elle est éligible
		-- FAD PPM 64864 Corrective : Sinon, vérifier si elle a un autre matricule hors Y ou IGG hors 9
		IF rec_ress.matricule LIKE 'Y%' OR to_char(rec_ress.igg) LIKE '9%' THEN
			nb_sous_ress := 0;
		ELSE
			select count(*) into nb_sous_ress from RESSOURCE where MATRICULE = 'Y' || SUBSTR(rec_ress.matricule,2) OR IGG = '9' || SUBSTR(to_char(rec_ress.igg),2);
		END IF;
		-- FAD PPM 64864 Corrective : Fin
	elsif (rec_ress.rtype = 'E' or rec_ress.rtype = 'F') then
		--Si forfait (code ressource E ou F), un clone existe s¿il y a une ressource ayant un prénom commençant par « CLONE- »  suivi du code ressource de la ressource principale
		select count(*) into nb_sous_ress from RESSOURCE where RPRENOM = 'CLONE-' || rec_ress.ident;
	end if;
	if (nb_sous_ress > 0) then
		--Ressource non-éligible
		return 0;
	end if;

	--Toutes les conditions sont passées avec succès

	--Ressource éligible
	return 1;
EXCEPTION
	WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;
END verif_eligible;

PROCEDURE P_CRE_SITUATION_RECYCLABLE(
 P_HFILE IN utl_file.file_type,
 p_date_trait IN date,
 rec_tmp_ress IN TMP_RESSOURCE_PRA%ROWTYPE,
 rec_ress IN RESSOURCE%ROWTYPE,
 rec_situ IN SITU_RESS%ROWTYPE) IS
 -- ==============================================================================
-- Nom     :    P_CRE_SITUATION_RECYCLABLE (Procedure)
-- Description:    Procedure de creation de la table des situations ressource
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE     : Pointeur du fichier log
--    rec_ress    : Structure de données de la table SITU_RESS
--
-- Parametres de sortie :
-- --------------------
--    Aucun
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_CRE_SITUATION_RECYCLABLE'; -- nom de la procedure courante
l_etape        varchar2(255);
l_message    varchar2(255);

BEGIN

    -- ------------------------------------------
    -- Insertion dans la table des situations
    -- ------------------------------------------
    l_etape := 'Insert SITU_RESS';

    INSERT INTO SITU_RESS
        (
        DATSITU,
        DATDEP,
        CPIDENT,
        COUT,
        DISPO,
        MARSG2,
        RMCOMP,
        PRESTATION,
        DPREST,
        IDENT,
        SOCCODE,
        CODSG,
        NIVEAU,
        MONTANT_MENSUEL,
        FIDENT,
        MODE_CONTRACTUEL_INDICATIF)
    VALUES    (
        rec_situ.datsitu,
        rec_situ.datdep,
        rec_situ.cpident,
        rec_situ.cout,
        rec_situ.dispo,
        rec_situ.marsg2,
        rec_situ.rmcomp,
        rec_situ.prestation,
        rec_situ.dprest,
        rec_situ.ident,
        rec_situ.soccode,
        rec_situ.codsg,
        rec_situ.niveau,
        rec_situ.montant_mensuel,
        rec_situ.fident,
        rec_situ.mode_contractuel_indicatif
        );

    l_etape :='Mise à jour de la log';
    ---------------------------------
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','datsitu',null,rec_situ.datsitu,'Creation situation suite a recyclage');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','datdep',null,rec_situ.datdep,'Creation situation suite a recyclage');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','cpident',null,rec_situ.cpident,'Creation situation suite a recyclage');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','cout',null,rec_situ.cout,'Creation situation suite a recyclage');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','dispo',null,rec_situ.dispo,'Creation situation suite a recyclage');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','prestation',null,rec_situ.prestation,'Creation situation suite a recyclage');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','ident',null,rec_situ.ident,'Creation situation suite a recyclage');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','soccode',null,rec_situ.soccode,'Creation situation suite a recyclage');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','codsg',null,rec_situ.codsg,'Creation situation suite a recyclage');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','montant_mensuel',null,rec_situ.montant_mensuel,'Creation situation suite a recyclage');
    Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','mode_contractuel_indicatif',null,rec_situ.mode_contractuel_indicatif,'Creation situation suite a recyclage');

	l_message:='Situation ressource créée suite à recyclage : Ident = ' || to_char(rec_situ.ident);

    TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || l_message );
    PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    p_date_trait, rec_tmp_ress, rec_ress, rec_situ, 1, l_message);

EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_CRE_SITUATION_RECYCLABLE ===================
END P_CRE_SITUATION_RECYCLABLE;

PROCEDURE P_MOD_SITUATION_RECYCLABLE(
 P_HFILE IN utl_file.file_type,
 p_date_trait IN date,
 rec_tmp_ress IN TMP_RESSOURCE_PRA%ROWTYPE,
 rec_ress IN RESSOURCE%ROWTYPE,
 rec_situ IN SITU_RESS%ROWTYPE) IS
 -- ==============================================================================
-- Nom     :    P_MOD_SITUATION_RECYCLABLE (Procedure)
-- Description:    Procedure de modification de la table ressource
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE     : Pointeur du fichier log
--    rec_ress    : Structure de données de la table RESSOURCE en IN OUT pour récupérer l'identifiant
--    rec_ress_
--    p_clone        : indique si il s'agit d'une ressource principal ou un clone 1 clone, 0 sinon
--
-- Parametres de sortie :
-- --------------------
--    Aucun
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_MOD_SITUATION_RECYCLABLE'; -- nom de la procedure courante
l_etape        varchar2(255);
l_message    varchar2(255);
rec_situ_mod  SITU_RESS%ROWTYPE; --QC 1637 15/07/2014

BEGIN
        -- ------------------------------------------
        -- Mise à jour de la table des Ressources
        -- ------------------------------------------

        --QC 1637 15/07/2014 : sauvegarde des données avant modification
        SELECT * INTO rec_situ_mod 
        FROM SITU_RESS 
        WHERE  IDENT = rec_situ.ident AND
             DATSITU = rec_situ.datsitu;
             
        l_etape := 'Update SITUATION pour la ressource : ident = ' || rec_situ.ident;

        -- On ne modifie pas l'IGG et le type de ressource
        UPDATE SITU_RESS SET
            DATSITU = rec_situ.datsitu,
            DATDEP = rec_situ.datdep,
            CODSG = rec_situ.codsg,
            SOCCODE = rec_situ.soccode,
            PRESTATION = rec_situ.prestation,
            MODE_CONTRACTUEL_INDICATIF = rec_situ.mode_contractuel_indicatif,
            CPIDENT = rec_situ.cpident,
			FIDENT = null,
			NIVEAU = null,
			DISPO = decode(rec_tmp_ress.type_ctra, 'ATU', rec_situ.dispo, null),
            COUT = rec_situ.cout,
            MONTANT_MENSUEL = decode(rec_tmp_ress.type_ctra, 'ATG', rec_situ.montant_mensuel, null)
        WHERE    IDENT = rec_situ.ident AND
             DATSITU = rec_situ.datsitu;

        l_etape :='Mise à jour de la log';
        ---------------------------------
        --QC 1637 15/07/2014 garder une traçabilité des changement (remplacer rec_situ par rec_situ_mod dans la colonne ancienne valeur)
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','datsitu',rec_situ_mod.datsitu,rec_situ.datsitu,'Modification situation suite a recyclage (date valeur situation : '|| rec_situ.datsitu ||')' );
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','datdep',rec_situ_mod.datdep,rec_situ.datdep,'Modification situation suite a recyclage (date valeur situation : '|| rec_situ.datsitu ||')');
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','codsg',rec_situ_mod.codsg,rec_situ.codsg,'Modification situation suite a recyclage (date valeur situation : '|| rec_situ.datsitu ||')');
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','soccode',rec_situ_mod.soccode,rec_situ.soccode,'Modification situation suite a recyclage (date valeur situation : '|| rec_situ.datsitu ||')');
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','prestation',rec_situ_mod.prestation,rec_situ.prestation,'Modification situation suite a recyclage (date valeur situation : '|| rec_situ.datsitu ||')');
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','mode_contractuel_indicatif',rec_situ_mod.mode_contractuel_indicatif,rec_situ.mode_contractuel_indicatif,'Modification situation suite a recyclage (date valeur situation : '|| rec_situ.datsitu ||')');
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','cpident',rec_situ_mod.cpident,rec_situ.cpident,'Modification situation suite a recyclage (date valeur situation : '|| rec_situ.datsitu ||')');
		Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','fident',rec_situ_mod.fident,null,'Modification situation suite a recyclage (date valeur situation : '|| rec_situ.datsitu ||')');
		IF (rec_tmp_ress.type_ctra = 'ATU') THEN
			Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','dispo',rec_situ_mod.dispo,rec_situ.dispo,'Modification situation suite a recyclage (date valeur situation : '|| rec_situ.datsitu ||')');
		ELSE
			Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','dispo',rec_situ_mod.dispo,null,'Modification situation suite a recyclage (date valeur situation : '|| rec_situ.datsitu ||')');
		END IF;
        Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','cout',rec_situ_mod.cout,rec_situ.cout,'Modification situation suite a recyclage (date valeur situation : '|| rec_situ.datsitu ||')');
        IF (rec_tmp_ress.type_ctra = 'ATG') THEN
			Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','montant_mensuel',rec_situ_mod.montant_mensuel,rec_situ.montant_mensuel,'Modification situation suite a recyclage (date valeur situation : '|| rec_situ.datsitu ||')');
		ELSE
			Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','montant_mensuel',rec_situ_mod.montant_mensuel,null,'Modification situation suite a recyclage (date valeur situation : '|| rec_situ.datsitu ||')');
		END IF;

        l_message:='Situation ressource modifiée suite à recyclage : Ident = ' || to_char(rec_situ.ident);

        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || l_message );
        PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    p_date_trait, rec_tmp_ress, rec_ress, rec_situ, 2, l_message);

EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_MOD_SITUATION_RECYCLABLE ===================
END P_MOD_SITUATION_RECYCLABLE;

/**
 * Suppression d'une ou plusieurs situations de ressource.
 */
PROCEDURE P_DEL_SITUATION(
 P_HFILE IN utl_file.file_type,
 rec_situ IN SITU_RESS%ROWTYPE,
 rec_tmp_ress IN TMP_RESSOURCE_PRA%ROWTYPE)
IS
 L_PROCNAME varchar2(30):='P_DEL_SITUATION'; -- nom de la procedure courante
 l_etape varchar2(255);
 l_message varchar2(255);
BEGIN
 l_etape := 'Suppression de la situation';
 -- PPM 59848 : supression ligne par ligne
 delete from SITU_RESS where IDENT = rec_situ.ident and DATSITU = rec_situ.datsitu and (DATDEP is null or DATDEP = rec_situ.datdep);--PPM 61193
 l_etape := 'Mise à jour de la log';
 ---------------------------------
 Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','datsitu',null,rec_situ.datsitu,'Suppression situation');
 Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','datdep',null,rec_situ.datdep,'Suppression situation');
 Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','cpident',null,rec_situ.cpident,'Suppression situation');
 Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','cout',null,rec_situ.cout,'Suppression situation');
 Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','dispo',null,rec_situ.dispo,'Suppression situation');
 Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','prestation',null,rec_situ.prestation,'Suppression situation');
 Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','ident',null,rec_situ.ident,'Suppression situation');
 Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','soccode',null,rec_situ.soccode,'Suppression situation');
 Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','codsg',null,rec_situ.codsg,'Suppression situation');
 Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','montant_mensuel',null,rec_situ.montant_mensuel,'Suppression situation');
 Pack_Ressource_F.maj_ressource_logs(rec_situ.ident,'Batch prestachat','situation','mode_contractuel_indicatif',null,rec_situ.mode_contractuel_indicatif,'Suppression situation');

 l_message := 'Situation ressource supprimée : Ident = ' || to_char(rec_situ.ident);
 TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || l_message );
EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

END P_DEL_SITUATION;

PROCEDURE P_RECYCLE_RESS(
 P_HFILE IN utl_file.file_type,
 p_date_trait IN date,
 rec_tmp_ress IN TMP_RESSOURCE_PRA%ROWTYPE,
 rec_ress IN RESSOURCE%ROWTYPE,
 rec_situ IN OUT SITU_RESS%ROWTYPE)
IS
 L_PROCNAME varchar2(30):='P_RECYCLE_RESS'; -- nom de la procedure courante
 l_etape varchar2(255);
 l_message varchar2(255);
  --PPM 60006 : déclaration des variables
 i integer;
 nb_situ integer;
 rec_situ_mem SITU_RESS%ROWTYPE;
 --PPM 60006 : supression des variables non utilisés
 /*nb_situ_1 integer;
 nb_situ_2 integer;
 nb_situ_3 integer;

 --rec_situ_mod SITU_RESS%ROWTYPE;--QC 1637
 */
  
BEGIN

	l_etape := 'Modifications sur la ressource';

	P_MOD_RESSOURCE_RECYCLABLE(P_HFILE, p_date_trait, rec_tmp_ress, rec_ress, rec_situ);

	l_etape := 'Modifications sur la situation';


--PPM 60006 : Supprimer TOUTES les situations existantes et en garder la traçabilité puis Créer la nouvelle situation

-- Garder en mémoire toutes les situations existantes avant les supprimer.
select count(*) into nb_situ from SITU_RESS where IDENT = rec_ress.ident;

rec_situ.ident := rec_ress.ident;

    for i in 0..nb_situ loop 
    
      BEGIN
      select * into rec_situ_mem from SITU_RESS where IDENT = rec_ress.ident
      and rownum < 2;
  EXCEPTION WHEN
        NO_DATA_FOUND THEN
       GOTO  end_loop_situ;
  END;
      P_DEL_SITUATION(P_HFILE, rec_situ_mem, rec_tmp_ress);
    end loop;
     <<end_loop_situ>>    
    -- Création de la nouvelle situation
		P_CRE_SITUATION_RECYCLABLE(P_HFILE, p_date_trait, rec_tmp_ress, rec_ress, rec_situ);
    

--Fin PPM 60006




	l_message := 'Modifications terminées';
	TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || l_message );

EXCEPTION
	WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;
END P_RECYCLE_RESS;

PROCEDURE P_MOD_RESSOURCE_RECYCLABLE (    P_HFILE     IN utl_file.file_type,
                p_date_trait    IN date,
                rec_tmp_ress     IN TMP_RESSOURCE_PRA%ROWTYPE,
                rec_ress     IN RESSOURCE%ROWTYPE,
                rec_situ    IN SITU_RESS%ROWTYPE
                ) IS
-- ==============================================================================
-- Nom     :    P_MOD_RESSOURCE_RECYCLABLE(Procedure)
-- Description:    Procedure de modification de la table RESSOURCE
--
-- ==============================================================================
-- Parametres d entree :
-- --------------------
--    P_HFILE     : Pointeur du fichier log
--    rec_ress    : Structure de données de la table RESSOURCE en IN OUT pour récupérer l'identifiant
--    rec_ress_
--    p_clone        : indique si il s'agit d'une ressource principal ou un clone 1 clone, 0 sinon
--
-- Parametres de sortie :
-- --------------------
--    Aucun
-- ==============================================================================
-- Historique :
-- ------------
-- 06/06/2011 - JM.LEDOYEN - FICHE 1419 : Création
-- ==============================================================================

L_PROCNAME     varchar2(30):='P_MOD_RESSOURCE_RECYCLABLE'; -- nom de la procedure courante
l_etape        varchar2(255);
l_message    varchar2(255);

-- Debut QC 1621 : traçabilité en cas de modification de la ressource suite à recyclage
-- déclaration des variables pour mémorisation des anciennes valeurs
l_old_rtype RESSOURCE.RTYPE%TYPE;
l_old_rnom RESSOURCE.RNOM%TYPE;
l_old_rprenom RESSOURCE.RPRENOM%TYPE;
l_old_matricule RESSOURCE.MATRICULE%TYPE;
l_old_igg RESSOURCE.IGG%TYPE;
l_old_coutot RESSOURCE.COUTOT%TYPE;
-- Fin QC 1621
BEGIN

        -- ------------------------------------------
        -- Mise à jour de la table des Ressources
        -- ------------------------------------------

        l_etape := 'Update RESSOURCE';
        --Debut QC 1621
        --- Mémorisation anciennes valeurs avant modification pour la LOG -----
        SELECT RTYPE, RNOM , RPRENOM , MATRICULE , IGG , COUTOT
        INTO l_old_rtype ,l_old_rnom ,l_old_rprenom , l_old_matricule , l_old_igg , l_old_coutot
        FROM RESSOURCE
        WHERE  IDENT = rec_ress.ident;
        -- Fin QC 1621

        -- On ne modifie pas le type de ressource
        UPDATE RESSOURCE SET
            RTYPE = rec_ress.rtype,
            RNOM = UPPER(CONVERT(rec_ress.rnom, 'US7ASCII')), -- on transforme le nom en majuscule non accentué
            RPRENOM = UPPER(CONVERT(rec_ress.rprenom, 'US7ASCII')), -- on transforme le nom en majuscule non accentué
            MATRICULE = decode(rec_tmp_ress.type_ctra, 'ATU', UPPER(rec_ress.matricule), null),
            IGG = decode(rec_tmp_ress.type_ctra, 'ATU', rec_ress.IGG, null),
            COUTOT = decode(rec_tmp_ress.cout_total, null, 0, decode(rec_tmp_ress.type_ctra, 'ATG', rec_ress.COUTOT, 0))
        WHERE    IDENT = rec_ress.ident;

         ----------------------------------------------------
         --------------- ATTENTION --------------------------
         -- Il me reste : Réinitialiser les données de localisation : n° de tel, immeuble, zone, étage et bureau --
         ----------------------------------------------------

        l_etape :='Mise à jour de la log';
        ---------------------------------
        -- Debut QC 1621 : modification des paramètres en entrée avec les anciennes valeurs : l_old_rtype ,l_old_rnom ,l_old_rprenom , l_old_matricule , l_old_igg , l_old_coutot
        Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','ident',rec_ress.ident,rec_ress.ident,'Modification de la ressource suite à recyclage');
        Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','rnom',l_old_rnom,rec_ress.rnom,'Modification de la ressource suite à recyclage');
        Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','rprenom',l_old_rprenom,rec_ress.rprenom,'Modification de la ressource suite à recyclage');
-- Debut QC 1621 07/07/2014 : pour un ATU il y a uniquement le cout total qui n'est pas logué les autres champs doivent l'être
 --       IF rec_tmp_ress.type_ctra != 'ATU' THEN
 --         if rec_ress.matricule is not null then
            Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','matricule',l_old_matricule,rec_ress.matricule,'Modification de la ressource suite à recyclage');
 --         end if;
 --        if rec_ress.igg is not null then
            --QC 1621 11/07/2014 : il faut resnseigner IGG et non igg dans le champ COLONNE
            Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','IGG',l_old_igg,rec_ress.igg,'Modification de la ressource suite à recyclage');
 --         end if;
 --       end if;
-- Fin QC 1621 07/07/2014        
        Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','rtype',l_old_rtype,rec_ress.rtype,'Modification de la ressource suite à recyclage');

        IF rec_tmp_ress.type_ctra != 'ATU' THEN
            -- on est en ATU, alors le cout total n'est pas pris en compte
           Pack_Ressource_F.maj_ressource_logs(rec_ress.ident,'Batch prestachat','ressource','coutot',l_old_coutot,rec_ress.coutot,'Modification de la ressource suite à recyclage');
        END IF;
        -- Fin QC 1621

           l_message:='Modification de la ressource suite à recyclage : Ident = ' || to_char(rec_ress.ident);

          TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || l_message );
          PACK_PRA_RESS_CONT.P_CRE_PRA_RESSOURCE(P_HFILE,    p_date_trait, rec_tmp_ress, rec_ress, rec_situ, 2, l_message);


EXCEPTION
    WHEN OTHERS THEN
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Erreur non gérée -- arret du BATCH !!!');
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Code = '|| sqlerrm);
        TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : Etape = '|| l_etape);
        RAISE CALL_ABORT;

-- =================== Fin procedure P_MOD_RESSOURCE_RECYCLABLE ===================
END P_MOD_RESSOURCE_RECYCLABLE;

/* PPM 49340 */
/* QC 1620 date_rprenom recupère la date indiqué dans les 10 premiers caractères du prénom */
FUNCTION date_rprenom (p_chaine IN VARCHAR2)
RETURN DATE
IS
	v_date DATE;
BEGIN
	v_date := to_date((substr(p_chaine,1,10)), 'dd/MM/yyyy');
  IF v_date IS NULL THEN RETURN NULL;
  END IF;
  RETURN v_date;
EXCEPTION
WHEN OTHERS THEN RETURN NULL;
END;

END PACK_PRA_RESS_CONT;
/

