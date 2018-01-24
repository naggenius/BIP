create or replace PACKAGE     PACKBATCH_IAS AS
--****************************************************
-- Procédure globale d'alimentation des tables pour le batch IAS appelée par le shell
--****************************************************
PROCEDURE IAS(P_LOGDIR          IN VARCHAR2)  ;
--****************************************************
-- Procédure d'alimentation de la table IAS
--****************************************************
PROCEDURE alim_ias(P_HFILE           IN UTL_FILE.FILE_TYPE)   ;
--*************************************************************
-- Procédure d'alimentation de la table TMP_IMMO_SC
--************************************************************
PROCEDURE alim_tmp_immo_sc(P_HFILE           IN UTL_FILE.FILE_TYPE) ;
--*************************************************************
-- Procédure d'alimentation de la table STOCK_IMMO_SC
--************************************************************
PROCEDURE alim_stock_immo_sc (P_HFILE           IN UTL_FILE.FILE_TYPE)  ;
--*************************************************************
-- Procédure d'alimentation de la table TMP_IMMO
--************************************************************
PROCEDURE alim_tmp_immo(P_HFILE           IN UTL_FILE.FILE_TYPE) ;
--*************************************************************
-- Procédure d'alimentation de la table STOCK_FI :lignes et consos
--************************************************************
PROCEDURE alim_tmp_fi (P_HFILE           IN UTL_FILE.FILE_TYPE) ;
--*************************************************************
-- Procédure de mise à jour de la table STOCK_FI_DEC
--************************************************************
PROCEDURE alim_stock_fi_dec(P_HFILE           IN UTL_FILE.FILE_TYPE);
--*************************************************************
-- Procédure d'alimentation de la table STOCK_IMMO
--************************************************************
PROCEDURE alim_stock_immo (P_HFILE           IN UTL_FILE.FILE_TYPE)  ;
--*************************************************************
-- Procédure d'alimentation de la table STOCK_FI :
-- ajout lignes de DEC N-1 et retours arrières
--**************************************************************
PROCEDURE alim_stock_fi(P_HFILE           IN UTL_FILE.FILE_TYPE) ;
--*************************************************************
-- Procédure pour la mise en place d'une répartition dans STOCK_FI (facturation mult-CA) :
-- Répartition des imputations pour les lignes avec le CA 77777
--**************************************************************
PROCEDURE repartition_fi(P_HFILE           IN UTL_FILE.FILE_TYPE) ;
-- **************************************************************************************
-- Vérification des arrondis pour le multi-CA(afin d'avoir le bon montant total à la fin).
-- **************************************************************************************
PROCEDURE verif_arrondis(P_HFILE           IN UTL_FILE.FILE_TYPE) ;
--*************************************************************
-- Procédure de création du fichier pour la FI appelée par le shell
--************************************************************
PROCEDURE fi( P_LOGDIR          IN VARCHAR2,
              p_chemin_fichier  IN VARCHAR2,
              p_nom_fichier     IN VARCHAR2);
--*************************************************************
-- Procédure de création du fichier pour SMS appelée par le shell
--************************************************************
PROCEDURE immo( P_LOGDIR          IN VARCHAR2,
                  p_chemin_fichier  IN VARCHAR2,
                  p_nom_fichier    IN VARCHAR2
               ) ;
--*************************************************************
-- Procedure qui tourne en parrallèle pour test
--************************************************************
PROCEDURE immo2( P_LOGDIR          IN VARCHAR2,
                  p_chemin_fichier  IN VARCHAR2,
                p_nom_fichier_sms     IN VARCHAR2,
                p_nom_fichier_expense     IN VARCHAR2
                  ) ;
--*************************************************************
-- Procédure qui écrit dans un fichier le mois de la mensuelle
--************************************************************
PROCEDURE DATRAIT(   P_LOGDIR          IN VARCHAR2,
                          p_chemin_fichier  IN VARCHAR2,
                          p_nom_fichier     IN VARCHAR2
                        );
--********************************************************************
-- Procédure d'alimentation des tables stock_fi_dec et stock_immo_dec
-- lors de la clôture
--********************************************************************
PROCEDURE cloture(P_LOGDIR          IN VARCHAR2)  ;

--*************************************************************
-- Procédure d'application du coût FI dans la table STOCK_FI
--*************************************************************
PROCEDURE appli_profil_fi(P_HFILE           IN UTL_FILE.FILE_TYPE) ;

END PACKBATCH_IAS;
/

create or replace PACKAGE BODY     Packbatch_Ias AS
-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
PRAGMA EXCEPTION_INIT( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     NUMBER := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     NUMBER := -20001;   -- problème : erreur dans la gestion d'erreur !
ERR_FONCTIONNELLE_ID NUMBER := -20002;   -- pour provoquer erreur alors que Oracle OK
CONSTRAINT_VIOLATION EXCEPTION;          -- pour clause when
PRAGMA EXCEPTION_INIT( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère
CA_IMMO_SC_PAS_FI   NUMBER := 99810;   -- centre d'activité pour calculer les immos sans lien avec la compte et ne pas calculer la FI
CA_IMMO_SC_AVEC_FI  NUMBER := 99820;    -- centre d'activité pour calculer les immos sans lien avec la compte et calculer la FI
--****************************************************
-- Procédure d'alimentation des tables pour le batch IAS
--****************************************************
PROCEDURE IAS (P_LOGDIR          IN VARCHAR2)  IS

L_HFILE     UTL_FILE.FILE_TYPE;
L_RETCOD    NUMBER;
L_PROCNAME  VARCHAR2(16) := 'IAS';
P_MSG       VARCHAR2(200);

    BEGIN

        -----------------------------------------------------
        -- Init de la trace
        -----------------------------------------------------
        L_RETCOD := Trclog.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
        IF ( L_RETCOD <> 0 ) THEN
        RAISE_APPLICATION_ERROR( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 FALSE );
        END IF;

        -----------------------------------------------------
        -- Trace Start
        -----------------------------------------------------
        Trclog.Trclog( L_HFILE, 'Debut de ' || L_PROCNAME );

        -----------------------------------------------------
        -- Lancement ...
        -----------------------------------------------------
        --Alimentation de la table IAS
        alim_ias( L_HFILE );

       -- sélection des lignes pour TMP_IMMO_SC
        alim_tmp_immo_sc( L_HFILE)  ;

        --Alimentation de la table STOCK_IMMO_SC : calcul retours arrières
        alim_stock_immo_sc( L_HFILE );

         -- sélection des lignes pour TMP_IMMO
        alim_tmp_immo( L_HFILE)  ;

        --Alimentation de la table STOCK_IMMO : calcul retours arrières
        alim_stock_immo( L_HFILE );

         -- sélection des lignes pour STOCK_FI
        alim_tmp_fi( L_HFILE ) ;

        -- Facturation interne des consommés de répartition
        Packbatch_Ias_Rjh.ALIM_IAS( L_HFILE );

         -- Mise à jour des données dans STOCK_FI_DEC
        --SEL PPM 58986 : pas de mise a jour de la table STOCK_FI par les donnees de STOCK_FI_DEC.
        --alim_stock_fi_dec( L_HFILE ) ;

        -- Multi-CA : répartition sur les CA en fonction des taux
        repartition_fi(L_HFILE);

        -- Multi-CA : Vérification des arrondis
        verif_arrondis(L_HFILE);

       -- Application du coût FI dans la Table STOCK_FI  -- OEL 1321
        appli_profil_fi(L_HFILE);

        --Alimentation de la table STOCK_FI : ajout DEC N-1 et retours arrières
        alim_stock_fi( L_HFILE );



        -----------------------------------------------------
        -- Trace Stop
        -----------------------------------------------------
        Trclog.Trclog( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
        Trclog.CLOSETRCLOG( L_HFILE );

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE <> CALLEE_FAILED_ID AND SQLCODE <> TRCLOG_FAILED_ID THEN
                Trclog.Trclog( L_HFILE, L_PROCNAME || ' : ' || SQLERRM );
            END IF;
            IF SQLCODE <> TRCLOG_FAILED_ID THEN
                Trclog.Trclog( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
                Trclog.CLOSETRCLOG( L_HFILE );
                RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         FALSE );
            ELSE
                RAISE;
            END IF;


END IAS;

/********************************************************************
-- Procédure d'alimentation des tables stock_fi_dec
-- lors de la clôture


traitannuel.sh
    + cloture_ias.sh

--********************************************************************/
-- SEL PPM 58986 : Ne pas deverser les données STOCK_FI_DEC dans STOCK_FI ; cloture_ias.sh
PROCEDURE cloture(P_LOGDIR          IN VARCHAR2)  IS
L_HFILE     UTL_FILE.FILE_TYPE;
L_RETCOD    NUMBER;
L_PROCNAME  VARCHAR2(16) := 'IAS_ClOTURE';
L_STATEMENT VARCHAR2(256);
CODCAMO_MULTI    NUMBER(6) := 77777;
L_TOP_SITU CHAR(1);
top_erreur number;
l_dpg number;
l_cafi number;
l_libdpg varchar2(30);




CURSOR cur_fi IS
    select * from stock_fi_dec;


    BEGIN

        -----------------------------------------------------
        -- Init de la trace
        -----------------------------------------------------
        L_RETCOD := Trclog.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
        IF ( L_RETCOD <> 0 ) THEN
        RAISE_APPLICATION_ERROR( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 FALSE );
        END IF;

        -----------------------------------------------------
        -- Trace Start
        -----------------------------------------------------
        Trclog.Trclog( L_HFILE, 'Debut de ' || L_PROCNAME );
        ----------------------------------------------------
        --Stocker les lignes STOCK_FI dans STOCK_FI_DEC
        ----------------------------------------------------
        Trclog.Trclog( L_HFILE, 'Suppression des lignes STOCK_FI_DEC' );
        DELETE STOCK_FI_DEC;
        COMMIT;

-- LIGNES qui ne sont pas des MULTI_CA
Trclog.Trclog( L_HFILE, 'Insertion des lignes NON MULTI_CA dans STOCK_FI_DEC' );
           INSERT INTO STOCK_FI_DEC (    cdeb         ,
                                        pid         ,
                                        ident         ,
                                        typproj     ,
                                        METIER         ,
                                        pnom         ,
                                        codsg         ,
                                        dpcode         ,
                                        icpi         ,
                                        codcamo     ,
                                        clibrca     ,
                                        CAFI         ,
                                        codsgress     ,
                                        libdsg         ,
                                        rnom        ,
                                        rtype        ,
                                        PRESTATION    ,
                                        NIVEAU         ,
                                        soccode     ,
                                        cada        ,
                                        coutftht    ,
                                        coutft     ,
                                        coutenv    ,
                                        consojhimmo     ,
                                        nconsojhimmo     ,
                                        consoft    ,
                                        consoenvimmo,
                                        nconsoenvimmo)
         (SELECT         TO_DATE('01/12/'||TO_CHAR(d.DATDEBEX,'YYYY'),'DD/MM/YYYY')    ,
                        s.pid         ,
                        s.ident     ,
                        s.typproj     ,
                        s.METIER     ,
                        s.pnom         ,
                        s.codsg     ,
                        s.dpcode     ,
                        s.icpi         ,
                        s.codcamo     ,
                        s.clibrca     ,
                        s.CAFI         ,
                        s.codsgress ,
                        s.libdsg     ,
                        s.rnom        ,
                        s.rtype        ,
                        s.PRESTATION,
                        s.NIVEAU     ,
                        s.soccode     ,
                        s.cada        ,
                        s.coutftht     ,
                        s.coutft     ,
                        s.coutenv    ,
                        c.a_consojhimmo,
                        c.a_nconsojhimmo,
                        c.a_consoft,
                        c.a_consoenvimmo,
                        c.a_nconsoenvimmo
           FROM
           (SELECT * FROM STOCK_FI st
           WHERE st.cdeb IN (SELECT MAX(cdeb) FROM STOCK_FI f
                              WHERE st.ident= f.ident AND st.pid=f.pid and st.cafi = f.cafi and st.codcamo = f.codcamo
                              )
            ) s,
           (SELECT pid,ident,cafi, codcamo, SUM(a_consojhimmo) a_consojhimmo, SUM(a_nconsojhimmo) a_nconsojhimmo,
                      SUM(a_consoft) a_consoft, SUM(a_consoenvimmo) a_consoenvimmo, SUM(a_nconsoenvimmo) a_nconsoenvimmo
            FROM STOCK_FI
            GROUP BY pid,ident,cafi, codcamo
            HAVING SUM(a_consojhimmo+a_nconsojhimmo+a_consoft+a_consoenvimmo+a_nconsoenvimmo)!=0) c,
           DATDEBEX d  ,ligne_bip lb
           WHERE
               s.ident=c.ident
               AND s.pid=lb.pid
               AND lb.codcamo != 77777  -- LIGNES NON MULTI_CA.
            AND s.pid=c.pid
            and s.cafi = c.cafi
            and s.codcamo = c.codcamo);

           L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées NON MULTI_CA dans la table STOCK_FI_DEC';
           Trclog.Trclog( L_HFILE, L_STATEMENT );

           COMMIT;

-- LIGNES qui SONT des MULTI_CA
        Trclog.Trclog( L_HFILE, 'Insertion des lignes MULTI_CA dans STOCK_FI_DEC' );
           INSERT INTO STOCK_FI_DEC(    cdeb         ,
                                        pid         ,
                                        ident         ,
                                        typproj     ,
                                        METIER         ,
                                        pnom         ,
                                        codsg         ,
                                        dpcode         ,
                                        icpi         ,
                                        codcamo     ,
                                        clibrca     ,
                                        CAFI         ,
                                        codsgress     ,
                                        libdsg         ,
                                        rnom        ,
                                        rtype        ,
                                        PRESTATION    ,
                                        NIVEAU         ,
                                        soccode     ,
                                        cada        ,
                                        coutftht    ,
                                        coutft     ,
                                        coutenv    ,
                                        consojhimmo     ,
                                        nconsojhimmo     ,
                                        consoft    ,
                                        consoenvimmo,
                                        nconsoenvimmo)
         (SELECT         TO_DATE('01/12/'||TO_CHAR(d.DATDEBEX,'YYYY'),'DD/MM/YYYY')    ,
                        s.pid         ,
                        s.ident     ,
                        s.typproj     ,
                        s.METIER     ,
                        s.pnom         ,
                        s.codsg     ,
                        s.dpcode     ,
                        s.icpi         ,
                        s.codcamo     ,
                        s.clibrca     ,
                        s.CAFI         ,
                        s.codsgress ,
                        s.libdsg     ,
                        s.rnom        ,
                        s.rtype        ,
                        s.PRESTATION,
                        s.NIVEAU     ,
                        s.soccode     ,
                        s.cada        ,
                        s.coutftht     ,
                        s.coutft     ,
                        s.coutenv    ,
                        c.a_consojhimmo,
                        c.a_nconsojhimmo,
                        c.a_consoft,
                        c.a_consoenvimmo,
                        c.a_nconsoenvimmo
           FROM
           (SELECT * FROM STOCK_FI st
           WHERE st.cdeb IN (SELECT MAX(cdeb) FROM STOCK_FI f
                              WHERE st.ident= f.ident AND st.pid=f.pid and st.cafi = f.cafi and st.codcamo = f.codcamo
                              )
            ) s,
           (SELECT pid,ident,cafi, codcamo,SUM(a_consojhimmo) a_consojhimmo, SUM(a_nconsojhimmo) a_nconsojhimmo,
                      SUM(a_consoft) a_consoft, SUM(a_consoenvimmo) a_consoenvimmo, SUM(a_nconsoenvimmo) a_nconsoenvimmo
            FROM STOCK_FI
            GROUP BY pid,ident,cafi,codcamo
            HAVING SUM(a_consojhimmo+a_nconsojhimmo+a_consoft+a_consoenvimmo+a_nconsoenvimmo)!=0) c,
           DATDEBEX d
           ,ligne_bip lb
           WHERE
               s.ident=c.ident
               AND s.pid=lb.pid
               AND s.codcamo = c.codcamo
               and s.cafi = c.cafi
               AND lb.codcamo = 77777    -- LIGNES MULTI_CA.
               AND lb.arctype = 'T1' AND  lb.typproj = '1' -- PPM 59288 : la ligne concernée doit être de type GT1
            AND s.pid=c.pid);

           L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées MULTI_CA dans la table STOCK_FI_DEC';
           Trclog.Trclog( L_HFILE, L_STATEMENT );


         --Vider les tables STOCK_FI, STOCK_FI_1, STOCK_IMMO, STOCK_IMMO_1
         L_STATEMENT := '* Suppression des lignes des tables STOCK_FI, STOCK_FI_1, STOCK_IMMO, STOCK_IMMO_1';
         Trclog.Trclog( L_HFILE, L_STATEMENT );
         Packbatch.DYNA_TRUNCATE('STOCK_FI');
         Packbatch.DYNA_TRUNCATE('STOCK_FI_1');
         Packbatch.DYNA_TRUNCATE('STOCK_IMMO');
         Packbatch.DYNA_TRUNCATE('STOCK_IMMO_1');

        -- Insertion de stock_fi_dec dans stock_fi sera prise en compte
        -- dans stock_fi_1 lors du traitement de janvier
        --
        --SEL PPM 58986 : on ne deverse pas les donnees de stock_fi_dec dans stock_fi.
        /*
        L_STATEMENT := '* Insertion des lignes des stock_fi_dec dans stock_fi';
        INSERT INTO STOCK_FI(CDEB,
                PID,
                IDENT,
                TYPPROJ,
                METIER,
                PNOM,
                CODSG,
                DPCODE,
                ICPI,
                CODCAMO,
                CLIBRCA,
                CAFI,
                CODSGRESS,
                LIBDSG,
                RNOM,
                RTYPE,
                PRESTATION,
                NIVEAU,
                SOCCODE,
                CADA,
                COUTFTHT,
                COUTFT,
                COUTENV,
                CONSOJHIMMO,
                NCONSOJHIMMO,
                CONSOFT,
                CONSOENVIMMO,
                NCONSOENVIMMO,
                A_CONSOFT,
                A_CONSOENVIMMO,
                A_NCONSOENVIMMO,
                A_CONSOJHIMMO,
                A_NCONSOJHIMMO)
        SELECT CDEB,
                PID,
                IDENT,
                TYPPROJ,
                METIER,
                PNOM,
                CODSG,
                DPCODE,
                ICPI,
                CODCAMO,
                CLIBRCA,
                CAFI,
                CODSGRESS,
                LIBDSG,
                RNOM,
                RTYPE,
                PRESTATION,
                NIVEAU,
                SOCCODE,
                CADA,
                COUTFTHT,
                COUTFT,
                COUTENV,
                CONSOJHIMMO,
                NCONSOJHIMMO,
                CONSOFT,
                CONSOENVIMMO,
                NCONSOENVIMMO,
                A_CONSOFT,
                A_CONSOENVIMMO,
                A_NCONSOENVIMMO,
                A_CONSOJHIMMO,
                A_NCONSOJHIMMO
                FROM STOCK_FI_DEC
                ;

        COMMIT;

*/

        ----------------------------------------------------
        --Stocker les lignes STOCK_FI_MULTI dans STOCK_FI_DEC
        -- cas particulier des lignes multi_ca pour lesquelles on met dans STOCK_FI_DEC
        -- les lignes d'origine ( avant éclatement sur les différents CA ) qui ont
        -- été stockées lors du traitement mensuel dans la table STOCK_FI_MULTI
        ----------------------------------------------------
        Trclog.Trclog( L_HFILE, 'Insertion des lignes de STOCK_FI_MULTI dans STOCK_FI_DEC' );
           INSERT INTO STOCK_FI_DEC (    cdeb         ,
                                        pid         ,
                                        ident         ,
                                        typproj     ,
                                        METIER         ,
                                        pnom         ,
                                        codsg         ,
                                        dpcode         ,
                                        icpi         ,
                                        codcamo     ,
                                        clibrca     ,
                                        CAFI         ,
                                        codsgress     ,
                                        libdsg         ,
                                        rnom        ,
                                        rtype        ,
                                        PRESTATION    ,
                                        NIVEAU         ,
                                        soccode     ,
                                        cada        ,
                                        coutftht    ,
                                        coutft     ,
                                        coutenv    ,
                                        consojhimmo     ,
                                        nconsojhimmo     ,
                                        consoft    ,
                                        consoenvimmo,
                                        nconsoenvimmo)
         (SELECT         max(s.cdeb)    ,
                        s.pid         ,
                        s.ident     ,
                        max(s.typproj)     ,
                        max(s.METIER)     ,
                        max(s.pnom)     ,
                        max(s.codsg)     ,
                        max(s.dpcode)     ,
                        max(s.icpi)     ,
                        CODCAMO_MULTI    ,
                        max(s.clibrca)     ,
                        s.CAFI        ,
                        max(s.codsgress),
                        max(s.libdsg)     ,
                        max(s.rnom)        ,
                        max(s.rtype)    ,
                        max(s.PRESTATION),
                        max(s.NIVEAU)     ,
                        max(s.soccode)     ,
                        max(s.cada)        ,
                        max(s.coutftht)    ,
                        max(s.coutft)     ,
                        max(s.coutenv)    ,
                        sum(s.consojhimmo),
                        sum(nconsojhimmo),
                        sum(consoft),
                        sum(consoenvimmo),
                        sum(nconsoenvimmo)
           FROM STOCK_FI s
           WHERE s.pid IN (SELECT distinct pid FROM STOCK_FI_MULTI )
           GROUP BY s.pid, s.ident,s.cafi);
           L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes de STOCK_FI_MULTI insérées dans la table STOCK_FI_DEC';
            Trclog.Trclog( L_HFILE, L_STATEMENT );

        COMMIT ;

        ----------------------------------------------------
        --Vider dans STOCK_FI_DEC les lignes correspondant aux lignes BIP qui ont
        -- été insérées précédemment d'après la table STOCK_FI_MULTI
        ----------------------------------------------------
        Trclog.Trclog( L_HFILE, 'Suppression dans STOCK_FI_DEC des lignes correspondantes à celles de STOCK_FI_MULTI' );

            DELETE FROM STOCK_FI_DEC
            WHERE     codcamo != CODCAMO_MULTI
            AND     PID IN ( SELECT DISTINCT m.PID
                    FROM STOCK_FI_MULTI m );


            L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table STOCK_FI_DEC';
            Trclog.Trclog( L_HFILE, L_STATEMENT );

        COMMIT ;

        ----------------------------------------------------
        --Mise à j our du TOP_situ pour connaitre la situation en cours lors de la cloture en decembre
        -- E pour encours
        --- A pour ancienne
        ----------------------------------------------------
        Trclog.Trclog( L_HFILE, 'Mise à jour du TOP_SITU en fonction de la situation de la personne à fin decembre' );
        FOR ligne IN cur_fi LOOP
          top_erreur := 0;
              begin
                SELECT si.codsg, si.cafi, si.libdsg into l_dpg,l_cafi,l_libdpg
                from struct_info si, situ_ress_full sr
                where
                (sr.datsitu<=ligne.cdeb OR datsitu IS NULL)
                AND (sr.datdep>=ligne.cdeb OR datdep IS NULL)
                AND sr.ident = ligne.ident
                AND si.codsg = sr.codsg;
              exception when
              others then
              top_erreur :=1 ;
               L_STATEMENT := 'ERREUR => Problème concernant la situation de la ressource : '|| ligne.ident;
                Trclog.Trclog( L_HFILE, L_STATEMENT );
               end;

            if (top_erreur = 0) then
                if ((l_cafi = ligne.cafi) and (l_dpg = ligne.codsgress)) then
                    l_top_situ := 'E';
                else
                     l_top_situ := 'A';
                end if;
                update stock_fi_dec s set top_situ=l_top_situ
                where s.ident = ligne.ident
                and s.codcamo = ligne.codcamo
                and s.cafi = ligne.cafi
                and s.pid = ligne.pid ;
            end if;


       end loop;


        -----------------------------------------------------
        -- Trace Stop
        -----------------------------------------------------
        Trclog.Trclog( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
        Trclog.CLOSETRCLOG( L_HFILE );

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE <> CALLEE_FAILED_ID AND SQLCODE <> TRCLOG_FAILED_ID THEN
                Trclog.Trclog( L_HFILE, L_PROCNAME || ' : ' || SQLERRM );
            END IF;
            IF SQLCODE <> TRCLOG_FAILED_ID THEN
                Trclog.Trclog( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
                Trclog.CLOSETRCLOG( L_HFILE );
                RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         FALSE );
            ELSE
                RAISE;
            END IF;

END cloture;
--****************************************************
-- Procédure d'alimentation de la table IAS
--****************************************************
PROCEDURE alim_ias(    P_HFILE           IN UTL_FILE.FILE_TYPE)   IS

L_RETCOD    NUMBER;
L_PROCNAME  VARCHAR2(16) := 'ALIM_IAS';
L_STATEMENT VARCHAR2(128);
l_annee  NUMBER(4);
l_date  VARCHAR2(8);
L_COMPTEUR NUMBER :=0;              -- Compteur utilisé pour gérer le commit
L_TOTAL    NUMBER :=0;              -- Compteur utilisé pour gérer le commit

 tmp_CDEB DATE;
    tmp_FACTPID VARCHAR2(4);
    tmp_IDENT NUMBER(5);
    tmp_PID VARCHAR2(4);
    tmp_TYPETAP CHAR(2);

BEGIN
     Trclog.Trclog( P_HFILE, 'Debut de ' || L_PROCNAME );

    -- -------------------------------------------------------------
    -- Etape préliminaire : Suppression de toutes les lignes de la table iAS
    -- --------------------------------------------------------------
    L_STATEMENT := '* Suppression des lignes de la table IAS';
    Trclog.Trclog( P_HFILE, L_STATEMENT );
    Packbatch.DYNA_TRUNCATE('IAS');
    L_COMPTEUR := 0;
    L_TOTAL := 0;



    -- -------------------------------------------------------------
    -- Etape 1 : Insertion des lignes dans la table iAS
    -- --------------------------------------------------------------
    L_STATEMENT := '* Insertion des lignes dans la table IAS';
    Trclog.Trclog( P_HFILE, L_STATEMENT );

    DECLARE
        CURSOR c_ias IS
            SELECT DISTINCT
                      c.cdeb ,
                    DECODE(t.aistpid,NULL,t.pid,'    ',t.pid,'   ',t.pid,t.aistpid) factpid,
                      r.ident ,
                    t.pid ,
                      l.typproj ,
                    RTRIM(l.METIER) metier ,
                    l.pnom ,
                    l.codsg ,
                    -- Si le statut du projet est O , D ou A : prend le statut de la ligne BIP
                    -- Sinon prend le statut du projet : afin de pouvoir ensuite ne pas immobiliser
                    -- toutes les lignes bip du projet en fonction de son statut
                    DECODE(p.statut,'O',l.astatut,'D',l.astatut,'A',l.astatut,p.statut) astatut,
                    l.dpcode ,
                    l.icpi ,
                    l.codcamo ,
                    ca.clibrca ,
                    ca.ctopact ,
                    si2.CAFI ,
                    sr.codsg  codsgress,
                    si2.libdsg ,
                     r.rnom,
                    r.rtype,
                    sr.PRESTATION,
                    sr.NIVEAU,
                    sr.soccode ,
                    p.cada ,
                    p.DATDEM  ,
                    p.datstatut ,
                    dp.datimmo ,
                    DECODE(e.typetap,NULL,'NO',e.typetap) typetap,
                    si2.filcode filcoderess

        FROM
                    CONS_SSTACHE_RES_MOIS c ,
                    TACHE t,
                    SITU_RESS_FULL sr ,
                    LIGNE_BIP l ,
                    ETAPE e,
                    RESSOURCE r,
                    CENTRE_ACTIVITE ca,
                    PROJ_INFO p,
                    STRUCT_INFO si1,
                    STRUCT_INFO si2,
                    DOSSIER_PROJET dp,
                    FILIALE_CLI f1,
                    FILIALE_CLI f2,
                    DATDEBEX d
        WHERE
        -- Consommés sur l'année courante :
             TO_CHAR(c.cdeb,'YYYY')=TO_CHAR(d.moismens,'YYYY')
            AND TO_CHAR(c.cdeb,'MM')<= TO_CHAR(d.moismens,'MM')
        -- jointure ligne_bip et cons_sstache_res
            --Attention si t.aist n'est pas nul, t.aistpid=''   '
            AND l.pid=DECODE(t.aistpid,NULL,t.pid,'    ',t.pid,'   ',t.pid,t.aistpid)
            AND (t.aistpid IS NULL OR t.aistty='FF' OR t.aistpid='   ' OR t.aistpid='    ')
        -- On prend la ligne Bip d'imputation si elle existe
                AND c.pid = t.pid
                AND c.acta=t.acta
                AND c.acst=t.acst
                AND c.ecet=t.ecet
                AND t.pid = e.pid
                AND t.ecet = e.ecet
        -- jointure ligne_bip et centre_activite
            AND l.codcamo = ca.codcamo
         -- jointure ligne_bip et projet_info
            AND l.icpi = p.icpi
        -- jointure ligne_bip et dossier_projet
            AND l.dpcode = dp.dpcode
        -- jointure cons_sstache_res et situ_ress
                 AND r.ident =sr.ident
            AND c.ident = sr.ident
            AND (c.cdeb >=sr.datsitu OR sr.datsitu IS NULL)
            AND (c.cdeb <=sr.datdep OR sr.datdep IS NULL )
        -- On ne prend pas les lignes dont le consommé est égal à 0
              AND c.cusag<>0
        -- ressource dont le CAFI du DPG <>9999 et  le DPG est rattaché à une filiale dont le top immo est oui
            AND sr.codsg=si2.codsg
            AND si2.CAFI!=99999
            AND si2.filcode= f2.filcode
            AND f2.top_immo='O'
        -- ressource dont la prestation <>(IFO,MO ,GRA,INT,STA)
            AND sr.PRESTATION NOT IN ('IFO','MO ','GRA','INT','STA')
        -- Dpg de la ligne rattaché à une filiale dont le top immo est OUI :
            AND l.codsg = si1.codsg
            AND si1.filcode = f1.filcode
            AND f1.top_immo = 'O'
        -- Type de la ligne <5 , 6 ou 8:
        AND  (l.typproj<5 OR l.typproj=6 OR l.typproj=8)
        -- Centre d'activité de la ligne <> 66666 : Exclut lignes d'origine de la répartition
        AND  l.codcamo<>66666 ;

        BEGIN



            FOR un_ias IN c_ias LOOP
                --
                -- On alimente la table IAS avec les données
                --
                 tmp_CDEB := un_ias.cdeb;
                 tmp_FACTPID := un_ias.factpid;
                 tmp_IDENT := un_ias.ident;
                 tmp_PID := un_ias.pid;
                 tmp_TYPETAP := un_ias.typetap;


                INSERT INTO IAS
                (CDEB         ,
                            FACTPID ,
                            IDENT     ,
                            PID         ,
                            TYPPROJ     ,
                            METIER     ,
                            PNOM         ,
                            CODSG     ,
                            ASTATUT     ,
                            DPCODE     ,
                            ICPI         ,
                            CODCAMO     ,
                            CLIBRCA     ,
                            CTOPACT     ,
                            CAFI      ,
                            CODSGRESS      ,
                            LIBDSG     ,
                            RNOM      ,
                            RTYPE     ,
                            PRESTATION    ,
                            NIVEAU       ,
                            SOCCODE      ,
                            CADA      ,
                            DATDEMAR     ,
                            DATSTATUT      ,
                            DATIMMO      ,
                            TYPETAP,
                            FILCODERESS
                            )
                VALUES
                ( un_ias.cdeb, un_ias.factpid, un_ias.ident, un_ias.pid, un_ias.typproj,
                  un_ias.metier, un_ias.pnom, un_ias.codsg, un_ias.astatut, un_ias.dpcode,
                  un_ias.icpi ,un_ias.codcamo ,un_ias.clibrca ,un_ias.ctopact ,un_ias.CAFI ,
                  un_ias.codsgress, un_ias.libdsg ,un_ias.rnom,un_ias.rtype,un_ias.PRESTATION,
                  un_ias.NIVEAU,un_ias.soccode ,un_ias.cada ,un_ias.DATDEM  ,un_ias.datstatut ,
                  un_ias.datimmo , un_ias.typetap, un_ias.filcoderess
                  );

                -- Gère un commit tous les 500 enregistrements
                L_COMPTEUR:= L_COMPTEUR+1;
                IF L_COMPTEUR>=500 THEN
                    COMMIT;
                    L_TOTAL := L_TOTAL + L_COMPTEUR ;
                    L_COMPTEUR:=0;
                END IF;

            END LOOP;
            COMMIT;

        EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE <> CALLEE_FAILED_ID THEN
            Trclog.Trclog( P_HFILE, 'Ligne en anomalie : ' || tmp_cdeb || ' - ' || tmp_factpid || ' - ' || tmp_ident
            || ' - ' || tmp_pid || ' - ' || tmp_typetap);
                    Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
            END IF;
            Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        RAISE CALLEE_FAILED;
        END;

        L_TOTAL := L_TOTAL + L_COMPTEUR ;
        L_STATEMENT := '-> '||L_TOTAL||' lignes insérées dans la table IAS';
        Trclog.Trclog( P_HFILE, L_STATEMENT );

    -- Récupère l'année en cours dans une variable
    SELECT TO_NUMBER( TO_CHAR( DATDEBEX, 'YYYY') )
    INTO l_annee
    FROM DATDEBEX;

    -- Récupère la date de l'année en cours (DD/MM/YYYY) dans une variable
    SELECT TO_CHAR( DATDEBEX, 'DDMMYYYY')
    INTO l_date
    FROM DATDEBEX;

  -- ------------------------------------------------------------------------------
    -- Etape 2 : ajout des couts dans la table IAS
    -- ------------------------------------------------------------------------------
    -- COUT FORCE DE TRAVAIL
    -- * SG : on prend le coût déjà HTR à partir de la table des coûts standards SG COUT_STD_SG des lignes dont le code société ='SG..',le type='P' par année,niveau,métier,dpg
    -- * Logiciel :coût logiciel HTR de la table COUT_STD2 en fonction du DPG de la ressource
        L_STATEMENT := '* Ajout COUT FORCE DE TRAVAIL SG et Logiciel';
        Trclog.Trclog( P_HFILE, L_STATEMENT );
        UPDATE IAS
        SET coutft= Pack_Utile_Cout.getCout( IAS.soccode, IAS.rtype, l_annee, IAS.METIER, IAS.NIVEAU, IAS.codsgress, 0)
        WHERE  IAS.soccode='SG..'
           OR IAS.rtype='L';
    COMMIT;
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes modifiées dans la table IAS';
    Trclog.Trclog( P_HFILE, L_STATEMENT );

    -- * SSII : on calcule le coût HTR de la situation de la ressource dont le code société est <>'SG..' , le type='P' avec une situation en cours pour l'année courante
    -- * Forfait Hors Site et sur Site:coût HTR de la situation de la ressource saisi en coût HT dont le type=('E','F') avec une situation en cours.
    L_STATEMENT := '* Ajout COUT FORCE DE TRAVAIL SSII et Forfait';
    Trclog.Trclog( P_HFILE, L_STATEMENT );

    UPDATE IAS
    SET (coutftht,coutft) = (SELECT DISTINCT NVL(s.cout,0),
            Pack_Utile_Cout.AppliqueTauxHTR (l_annee, NVL(s.cout,0) , TO_CHAR(IAS.cdeb,'DD/MM/YYYY'), ias.filcoderess)
            FROM SITU_RESS_FULL s
            WHERE  s.ident =IAS.ident
            AND (IAS.cdeb>=s.datsitu OR s.datsitu IS NULL)
            AND (IAS.cdeb<=s.datdep OR s.datdep IS NULL)
            )
    WHERE
         IAS.soccode!='SG..'
     AND IAS.rtype!='L';
    COMMIT;
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes modifiées dans la table IAS';
    Trclog.Trclog( P_HFILE, L_STATEMENT );

    -- COUT D'ENVIRONNEMENT
    -- * SG,SSII,Forfait sur Site : coût d'environnement en HTR de la table COUT_STD2 en fonction du DPG de la ressource
    L_STATEMENT := '* Ajout COUT D''ENVIRONNEMENT SG,SSII,Forfait sur Site';
    Trclog.Trclog( P_HFILE, L_STATEMENT );
    UPDATE IAS
     SET coutenv= Pack_Utile_Cout.getCoutEnv(IAS.soccode, IAS.rtype, l_annee , IAS.codsgress, IAS.metier)

	 WHERE  IAS.rtype != 'L'
     AND IAS.rtype!='E' ;
    COMMIT;
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes modifiées dans la table IAS';
    Trclog.Trclog( P_HFILE, L_STATEMENT );


    -- ------------------------------------------------------------------------------
    -- Etape 3 : ajout des consommés dans la table IAS
    -- ------------------------------------------------------------------------------

    --    calcul du conso en jh de la ressource pour une ligne donnée, pour un mois donné et un type d'étape à partir du conso de la table CONS_SSTACHE_RES_MOIS
    L_STATEMENT := '* Calcul du conso en jh';
    Trclog.Trclog( P_HFILE, L_STATEMENT );

    UPDATE IAS
    SET consojh = (SELECT NVL(SUM(c.cusag),0)
                      FROM CONS_SSTACHE_RES_MOIS c, TACHE t, ETAPE e
                      WHERE
                           c.pid = t.pid
                        AND c.acta=t.acta
                        AND c.acst=t.acst
                        AND c.ecet=t.ecet
                        AND t.pid = e.pid
                        AND t.ecet = e.ecet
                        AND IAS.factpid=DECODE(t.aistpid,NULL,t.pid,'    ',t.pid,'   ',t.pid,t.aistpid)
                        AND  c.ident = IAS.ident
                        AND c.pid = IAS.pid
                        AND c.cdeb = IAS.cdeb
                        AND IAS.typetap = DECODE(e.typetap,NULL,'NO',e.typetap));

    COMMIT;
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes modifiées dans la table IAS';
    Trclog.Trclog( P_HFILE, L_STATEMENT );
    --    Calcul du conso en euros de la force de travail : consoft = consojh*coutft
    --  et des frais d'environnement : consoenv = consojh*coutenv
    L_STATEMENT := '* Calcul des consos FT et ENV';
    Trclog.Trclog( P_HFILE, L_STATEMENT );
    UPDATE IAS
    SET (consoft, consoenv) = (SELECT NVL(consojh,0)*NVL(coutft,0),
                            NVL(consojh,0)*NVL(coutenv,0)
                    FROM IAS i
    WHERE
    i.typetap=IAS.typetap
    AND i.ident=IAS.ident
    AND i.pid=IAS.pid
    AND i.factpid=IAS.factpid
    AND i.cdeb=IAS.cdeb
    );
    COMMIT;
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes modifiées dans la table IAS';
    Trclog.Trclog( P_HFILE, L_STATEMENT );

    Trclog.Trclog( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE <> CALLEE_FAILED_ID THEN
                Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        END IF;
        Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        RAISE CALLEE_FAILED;

END alim_ias ;

--*************************************************************
-- Procédure de sélection des lignes pour  TMP_IMMO_SC
--************************************************************
PROCEDURE alim_tmp_immo_sc (P_HFILE           IN UTL_FILE.FILE_TYPE)  IS
L_PROCNAME  VARCHAR2(20) := 'ALIM_TMP_IMMO_SC';
L_STATEMENT VARCHAR2(128);
BEGIN
     Trclog.Trclog( P_HFILE, 'Debut de ' || L_PROCNAME );

    -- --------------------------------------------------------------------------
    -- Etape préliminaire : Suppression de toutes les lignes de la table TMP_IMMO_SC
    -- ---------------------------------------------------------------------------
    L_STATEMENT := '* Suppression des lignes de la table TMP_IMMO_SC';
    Trclog.Trclog( P_HFILE, L_STATEMENT );
    Packbatch.DYNA_TRUNCATE('TMP_IMMO_SC');


-- Insertion des lignes immobilisables dans TMP_IMMO_SC
   L_STATEMENT := '* Insertion des lignes immobilisables dans TMP_IMMO_SC';
   Trclog.Trclog( P_HFILE, L_STATEMENT );
   INSERT INTO TMP_IMMO_SC (
                        cdeb         ,
                        pid         ,
                        ident         ,
                        typproj         ,
                        METIER         ,
                        pnom         ,
                        codsg         ,
                        dpcode     ,
                        icpi         ,
                        codcamo     ,
                        clibrca         ,
                        CAFI         ,
                        codsgress     ,
                        libdsg         ,
                        rnom        ,
                        rtype        ,
                        PRESTATION    ,
                        NIVEAU         ,
                        soccode     ,
                        cada        ,
                        coutftht    ,
                        coutft     ,
                        coutenv    ,
                        consojh     ,
                        consoft    ,
                        consoenv)
    (SELECT
                        i.cdeb         ,
                        i.factpid         ,
                        i.ident         ,
                        MAX(i.typproj)         ,
                        MAX(i.METIER)         ,
                        MAX(i.pnom)         ,
                        MAX(i.codsg)         ,
                        MAX(i.dpcode)     ,
                        MAX(i.icpi)         ,
                        MAX(i.codcamo)     ,
                        MAX(i.clibrca)         ,
                        MAX(i.CAFI)         ,
                        MAX(i.codsgress)     ,
                        MAX(i.libdsg)         ,
                        MAX(i.rnom)        ,
                        MAX(i.rtype)        ,
















                        MAX(i.PRESTATION)    ,
                        MAX(i.NIVEAU)         ,
                        MAX(i.soccode)     ,
                        MAX(i.cada)        ,



                        NVL(MAX(i.coutftht),0),
                        NVL(MAX(i.coutft),0)     ,
                        NVL(MAX(i.coutenv),0)     ,
                        NVL(SUM(i.consojh),0)     ,
                        NVL(SUM(i.consoft),0)    ,
                        NVL(SUM(i.consoenv),0)
                        FROM IAS i, LIGNE_BIP l -- PPM 59288 : liaison avec la table ligne_bip

                        WHERE
                        -- de la date d'immo à la date de statut
                           ( TRUNC(i.cdeb,'MONTH') BETWEEN TRUNC(i.datimmo,'MONTH') AND TRUNC(i.datstatut,'MONTH')
                              OR TRUNC(i.cdeb,'MONTH')>=TRUNC(i.datimmo,'MONTH'))
                        --    dont le statut comptable de la ligne ou du projet info est égal à 'O','D','A','C' :
                        AND i.astatut IN ('O','D','A','C')
                        --    de type 1 : IAS. Typproj=1
                        AND i.typproj=1
                        -- AND i.pid = l.pid -- PPM 59288 : liaison avec la table ligne_bip
                        AND i.factpid = l.pid -- PPM 64471 - ABN
                        AND l.arctype = 'T1' -- PPM 59288 : la ligne concernée doit être de type GT1

                        -- Qui ont une étape PACTE immobilisable :
                        AND i.typetap IN (select distinct typetap from type_etape where top_immo = 'O' )
                        -- prise en compte des CAFI spécial IMMO_SC
                        AND (i.CAFI=CA_IMMO_SC_PAS_FI or i.CAFI=CA_IMMO_SC_AVEC_FI)
                        GROUP BY i.cdeb,i.ident,i.factpid
                        );
       COMMIT;
       L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table TMP_IMMO_SC';
       Trclog.Trclog( P_HFILE, L_STATEMENT );


       Trclog.Trclog( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE <> CALLEE_FAILED_ID THEN
                Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        END IF;
        Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        RAISE CALLEE_FAILED;
END alim_tmp_immo_sc ;

--*************************************************************
-- Procédure d'alimentation de la table STOCK_IMMO_SC
--************************************************************
PROCEDURE alim_stock_immo_sc(P_HFILE           IN UTL_FILE.FILE_TYPE)  IS
CURSOR cur_stock_immo_sc IS
SELECT * FROM STOCK_IMMO_SC ;

L_PROCNAME  VARCHAR2(20) := 'ALIM_STOCK_IMMO_SC';
L_STATEMENT VARCHAR2(128);
l_consojh NUMBER(12,2);
l_consoft NUMBER(12,2);
l_a_consojh NUMBER(12,2);
l_a_consoft NUMBER(12,2);
l_moismens NUMBER(2);


BEGIN
      Trclog.Trclog( P_HFILE, 'Debut de ' || L_PROCNAME );
    -- --------------------------------------------------------------------------
    -- Etape préliminaire : vider STOCK_IMMO_SC_1, copier STOCK_IMMO_SC  dans STOCK_IMMO_SC_1, vider STOCK_IMMO_SC
    -- ---------------------------------------------------------------------------
    L_STATEMENT := '* Copier STOCK_IMMO_SC  dans STOCK_IMMO_SC_1';
    Trclog.Trclog( P_HFILE, L_STATEMENT );
    Packbatch.DYNA_TRUNCATE('STOCK_IMMO_SC_1');
    INSERT INTO STOCK_IMMO_SC_1
    SELECT * FROM STOCK_IMMO_SC
    WHERE immo1!='O' OR immo1 IS NULL; --Ne pas copier les lignes qui existaient dans stock_fi_1 et pas dans stock_fi

    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table STOCK_IMMO _1';
    COMMIT;
    Packbatch.DYNA_TRUNCATE('STOCK_IMMO_SC');

     --Insérer dans STOCK_IMMO toutes les lignes de TMP_IMMO
     INSERT INTO STOCK_IMMO_SC (CDEB,
                               PID ,
                             IDENT  ,
                             TYPPROJ ,
                             METIER ,
                             PNOM   ,
                             CODSG ,
                             DPCODE  ,
                             ICPI   ,
                             CODCAMO ,
                             CLIBRCA  ,
                             CAFI     ,
                             CODSGRESS,
                             LIBDSG  ,
                             RNOM    ,
                             RTYPE   ,
                             PRESTATION ,
                             NIVEAU    ,
                             SOCCODE  ,
                             CADA    ,
                             COUTFTHT ,
                             COUTFT   ,
                             CONSOJH  ,
                             CONSOFT  )
     SELECT                  t.CDEB,
                               t.PID ,
                             t.IDENT ,
                             t.TYPPROJ ,
                             t.METIER ,
                             t.PNOM   ,
                             t.CODSG ,
                             t.DPCODE  ,
                             t.ICPI   ,
                             t.CODCAMO ,
                             t.CLIBRCA  ,
                             --si cafi=88888 alors prendre le CA du DPG de la ressource
                             DECODE(t.CAFI,88888,s.CENTRACTIV,CA_IMMO_SC_PAS_FI,s.CENTRACTIV,CA_IMMO_SC_AVEC_FI,s.CENTRACTIV,t.CAFI)     ,
                             t.CODSGRESS,
                             t.LIBDSG  ,
                             t.RNOM    ,
                             t.RTYPE   ,
                             t.PRESTATION ,
                             t.NIVEAU    ,
                             t.SOCCODE  ,
                             t.CADA    ,
                             NVL(t.COUTFTHT,0) ,
                             NVL(t.COUTFT ,0)  ,
                             NVL(t.CONSOJH ,0) ,
                             NVL(t.CONSOFT,0)
    FROM TMP_IMMO_SC t, STRUCT_INFO s
    WHERE t.CODSGRESS=s.CODSG;
     COMMIT;

     -- On compare chaque ligne de STOCK_IMMO_SC avec les lignes de STOCK_IMMO_SC_1
     L_STATEMENT := '* Calcul des retours arrière';
     Trclog.Trclog( P_HFILE, L_STATEMENT );
     --Calcul des retours arrières
      FOR curseur IN cur_stock_immo_sc LOOP
         BEGIN
                SELECT consojh,
                     consoft
                     INTO l_consojh,l_consoft
              FROM STOCK_IMMO_SC_1 s
              WHERE s.ident = curseur.ident
              AND s.pid = curseur.pid
              AND s.cdeb = curseur.cdeb
              AND s.icpi=curseur.icpi
              AND s.CAFI=curseur.CAFI;

              -- Calcul des retours arrières
              l_a_consojh := NVL(curseur.consojh,0) - NVL(l_consojh,0);
              l_a_consoft := NVL(curseur.consoft,0) - NVL(l_consoft,0);


              UPDATE STOCK_IMMO_SC
              SET     a_consojh = l_a_consojh,
                    a_consoft = l_a_consoft
              WHERE ident = curseur.ident
              AND pid = curseur.pid
              AND cdeb = curseur.cdeb
              AND icpi=curseur.icpi
              AND CAFI=curseur.CAFI;


        EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                       UPDATE STOCK_IMMO_SC
                      SET a_consojh = NVL(curseur.consojh,0),
                            a_consoft = NVL(curseur.consoft,0)
                      WHERE ident = curseur.ident
                        AND pid = curseur.pid
                        AND cdeb = curseur.cdeb
                        AND icpi=curseur.icpi
                        AND CAFI=curseur.CAFI;

        END;


     END LOOP;
    COMMIT;
    -- Cas où il existe des lignes dans STOCK_IMMO_SC_1 et pas dans STOCK_IMMO_SC
     L_STATEMENT := '* Insertion des lignes dans STOCK_IMMO_SC existant dans STOCK_IMMO_SC_1 et pas dans STOCK_IMMO_SC';
     Trclog.Trclog( P_HFILE, L_STATEMENT );
    INSERT INTO STOCK_IMMO_SC (cdeb         ,
                        pid         ,
                        ident         ,
                        typproj     ,
                        METIER         ,
                        pnom         ,
                        codsg         ,
                        dpcode         ,
                        icpi         ,
                        codcamo     ,
                        clibrca     ,
                        CAFI         ,
                        codsgress     ,
                        libdsg         ,
                        rnom        ,
                        rtype        ,
                        PRESTATION    ,
                        NIVEAU         ,
                        soccode     ,
                        cada        ,
                        coutftht    ,
                        coutft     ,
                        consojh,
                        consoft    ,
                        a_consojh,
                        a_consoft,
                        immo1
                        )
     SELECT             s.cdeb         ,
                        s.pid         ,
                        s.ident         ,
                        s.typproj     ,
                        s.METIER         ,
                        s.pnom         ,
                        s.codsg         ,
                        s.dpcode         ,
                        s.icpi         ,
                        s.codcamo     ,
                        s.clibrca     ,
                        s.CAFI         ,
                        s.codsgress     ,
                        s.libdsg         ,
                        s.rnom        ,
                        s.rtype        ,
                        s.PRESTATION    ,
                        s.NIVEAU         ,
                        s.soccode     ,
                        s.cada        ,
                        NVL(s.coutftht,0)    ,
                        NVL(s.coutft,0)     ,
                        0    ,
                        0     ,
                        DECODE(s.consojh,0, s.a_consojh,- (s.consojh)),
                        DECODE(s.consojh,0,s.a_consoft,- s.consoft),
                        'O'
        FROM
        (SELECT cdeb,pid,ident,CAFI,icpi FROM STOCK_IMMO_SC_1
         MINUS
         SELECT cdeb,pid,ident,CAFI,icpi FROM STOCK_IMMO_SC) n,
        STOCK_IMMO_SC_1 s, DATDEBEX d
        WHERE n.ident=s.ident
        AND n.pid=s.pid
        AND n.cdeb=s.cdeb
        AND n.icpi=s.icpi
        AND n.CAFI=s.CAFI;


        COMMIT;

        -- Mise à jour du CADA en prenant comme référence celui lié au projet le jour du
        -- traitement.

        UPDATE STOCK_IMMO_SC
        SET CADA=(SELECT cada FROM PROJ_INFO
              WHERE STOCK_IMMO_SC.icpi=PROJ_INFO.icpi)
        ;

        COMMIT;

        L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table STOCK_IMMO_SC';
        Trclog.Trclog( P_HFILE, L_STATEMENT );


        Trclog.Trclog( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE <> CALLEE_FAILED_ID THEN
                Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        END IF;
        Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        RAISE CALLEE_FAILED;
END alim_stock_immo_sc;

--*************************************************************
-- Procédure de sélection des lignes pour  TMP_IMMO
--************************************************************
PROCEDURE alim_tmp_immo(P_HFILE           IN UTL_FILE.FILE_TYPE)  IS
L_PROCNAME  VARCHAR2(16) := 'ALIM_TMP_IMMO';
L_STATEMENT VARCHAR2(128);
BEGIN
     Trclog.Trclog( P_HFILE, 'Debut de ' || L_PROCNAME );

    -- --------------------------------------------------------------------------
    -- Etape préliminaire : Suppression de toutes les lignes de la table TMP_IMMO
    -- ---------------------------------------------------------------------------
    L_STATEMENT := '* Suppression des lignes de la table TMP_IMMO';
    Trclog.Trclog( P_HFILE, L_STATEMENT );
    Packbatch.DYNA_TRUNCATE('TMP_IMMO');


-- Insertion des lignes immobilisables dans TMP_IMMO
   L_STATEMENT := '* Insertion des lignes immobilisables dans TMP_IMMO';
   Trclog.Trclog( P_HFILE, L_STATEMENT );
   INSERT INTO TMP_IMMO (
                        cdeb         ,
                        pid         ,
                        ident         ,
                        typproj         ,
                        METIER         ,
                        pnom         ,
                        codsg         ,
                        dpcode     ,
                        icpi         ,
                        codcamo     ,
                        clibrca         ,
                        CAFI         ,
                        codsgress     ,
                        libdsg         ,
                        rnom        ,
                        rtype        ,
                        PRESTATION    ,
                        NIVEAU         ,
                        soccode     ,
                        cada        ,
                        coutftht    ,
                        coutft     ,
                        coutenv    ,
                        consojh     ,
                        consoft    ,
                        consoenv)
    (SELECT
                        i.cdeb         ,
                        i.factpid         ,
                        i.ident         ,
                        MAX(i.typproj)         ,
                        MAX(i.METIER)         ,
                        MAX(i.pnom)         ,
                        MAX(i.codsg)         ,
                        MAX(i.dpcode)     ,
                        MAX(i.icpi)         ,
                        MAX(i.codcamo)     ,
                        MAX(i.clibrca)         ,
                        MAX(i.CAFI)         ,
                        MAX(i.codsgress)     ,
                        MAX(i.libdsg)         ,
                        MAX(i.rnom)        ,
                        MAX(i.rtype)        ,
















                        MAX(i.PRESTATION)    ,
                        MAX(i.NIVEAU)         ,
                        MAX(i.soccode)     ,
                        MAX(i.cada)        ,



                        NVL(MAX(i.coutftht),0),
                        NVL(MAX(i.coutft),0)     ,
                        NVL(MAX(i.coutenv),0)     ,
                        NVL(SUM(i.consojh),0)     ,
                        NVL(SUM(i.consoft),0)    ,
                        NVL(SUM(i.consoenv),0)
                        FROM IAS i, LIGNE_BIP l -- PPM 59288 : liaison avec la table ligne_bip

                        WHERE
                        -- de la date d'immo à la date de statut
                           ( TRUNC(i.cdeb,'MONTH') BETWEEN TRUNC(i.datimmo,'MONTH') AND TRUNC(i.datstatut,'MONTH')
                              OR TRUNC(i.cdeb,'MONTH')>=TRUNC(i.datimmo,'MONTH'))
                        --    dont le statut comptable de la ligne ou du projet info est égal à 'O','D','A','C' :
                        AND i.astatut IN ('O','D','A','C')
                        --    de type 1 : IAS. Typproj=1
                        AND i.typproj=1
                        -- AND i.pid = l.pid -- PPM 59288 : liaison avec la table ligne_bip
                        AND i.factpid = l.pid -- PPM 64471 - ABN
                        AND l.arctype = 'T1' -- PPM 59288 : la ligne concernée doit être de type GT1

                        -- Qui ont une étape PACTE immobilisable :
                        AND i.typetap IN (select distinct typetap from type_etape where top_immo = 'O' )
                        -- exclusion des CAFI spécial IMMO_SC
                        AND (i.CAFI!=CA_IMMO_SC_PAS_FI and i.CAFI!=CA_IMMO_SC_AVEC_FI)
                        GROUP BY i.cdeb,i.ident,i.factpid
                        );
       COMMIT;
       L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table TMP_IMMO';
       Trclog.Trclog( P_HFILE, L_STATEMENT );


       Trclog.Trclog( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE <> CALLEE_FAILED_ID THEN
                Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        END IF;
        Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        RAISE CALLEE_FAILED;
END alim_tmp_immo ;
--*************************************************************
-- Procédure de sélection des lignes pour STOCK_FI
--************************************************************
PROCEDURE alim_tmp_fi(P_HFILE           IN UTL_FILE.FILE_TYPE)  IS

CODCAMO_MULTI    NUMBER(6) := 77777;

CURSOR cur_tmp_immo IS
SELECT DISTINCT
immo.cdeb         AS cdeb ,
immo.pid         AS pid,
immo.ident         AS ident,
immo.typproj     AS typproj,
immo.METIER     AS METIER,
immo.pnom         AS pnom,
immo.codsg         AS codsg,
immo.dpcode     AS dpcode,
immo.icpi         AS icpi ,
immo.codcamo     AS codcamo ,
immo.clibrca     AS clibrca,
immo.CAFI         AS CAFI,
immo.codsgress     AS codsgress,
immo.libdsg     AS libdsg,
immo.rnom        AS rnom,
immo.rtype        AS rtype    ,
immo.PRESTATION    AS PRESTATION,
immo.NIVEAU     AS NIVEAU,
immo.soccode     AS soccode ,
immo.cada        AS cada,
immo.coutenv     AS coutenv,
immo.consojh     AS consojh,
immo.COUTFT        AS coutft,
immo.COUTFTHT   AS coutftht,
s.CENTRACTIV    AS centractiv
FROM IAS i, (select * from TMP_IMMO union select * from TMP_IMMO_SC where cafi != CA_IMMO_SC_PAS_FI) immo, struct_info s
WHERE i.ident=immo.ident
AND  i.factpid = immo.pid
AND    i.cdeb = immo.cdeb
 --    Dont le cafi du DPG de la ressource est différent de 0 et de 88888
    AND immo.CAFI<>0 AND immo.CAFI<>88888
--    Dont le camo de la ligne est différent de 0 :
    AND immo.codcamo<>0
--    Dont le top du camo de la ligne  est différent de " ne pas refacturer " :
    AND i.ctopact <>'S'
 -- jointure struct_info et table immo
 AND immo.codsgress = s.codsg;


L_PROCNAME  VARCHAR2(16) := 'ALIM_TMP_FI';
L_STATEMENT VARCHAR2(128);
l_exist NUMBER(1);


BEGIN
    Trclog.Trclog( P_HFILE, 'Debut de ' || L_PROCNAME );
    -- --------------------------------------------------------------------------
    -- Etape préliminaire : vider STOCK_FI_1, copier STOCK_FI dans STOCK_FI_1, vider STOCK_FI
    -- ---------------------------------------------------------------------------
    L_STATEMENT := '* Copier STOCK_FI dans STOCK_FI_1';
    Trclog.Trclog( P_HFILE, L_STATEMENT );
    Packbatch.DYNA_TRUNCATE('STOCK_FI_1');
    INSERT INTO STOCK_FI_1
    SELECT * FROM STOCK_FI
    WHERE fi1!='O' OR fi1 IS NULL; --Ne pas copier les lignes qui existaient dans stock_fi_1 et pas dans stock_fi
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table STOCK_FI_1';
    COMMIT;
    Packbatch.DYNA_TRUNCATE('STOCK_FI');

    --Prendre les lignes non immobilisables :Force de travail et env
    L_STATEMENT := '* Insertion des lignes non immobilisables dans STOCK_FI:FT et ENV';
    Trclog.Trclog( P_HFILE, L_STATEMENT );
    INSERT INTO STOCK_FI (
                        cdeb         ,
                        pid         ,
                        ident         ,
                        typproj         ,
                        METIER         ,
                        pnom         ,
                        codsg         ,
                        dpcode     ,
                        icpi         ,
                        codcamo     ,
                        clibrca         ,
                        CAFI         ,
                        codsgress     ,
                        libdsg         ,
                        rnom        ,
                        rtype        ,
                        PRESTATION    ,
                        NIVEAU         ,
                        soccode     ,
                        cada        ,
                        coutftht    ,
                        coutft         ,
                        coutenv        ,
                        nconsojhimmo     ,
                        consoft ,
                        nconsoenvimmo,
                        consojhimmo ,
                        consoenvimmo
                            )
    (SELECT
                        cdeb         ,
                        factpid         ,
                        ident         ,
                        MAX(typproj)         typproj,
                        MAX(METIER)         METIER,
                        MAX(pnom)         pnom,
                        MAX(codsg)         codsg,
                        MAX(dpcode)         dpcode,
                        MAX(icpi)         ,
                        MAX(codcamo)     ,
                        MAX(clibrca)         ,
                        MAX(CAFI)         ,
                        MAX(codsgress)     ,
                        MAX(libdsg)         ,
                        MAX(rnom)        ,
                        MAX(rtype)        ,
                        MAX(PRESTATION)    ,
                        MAX(NIVEAU)         ,
                        MAX(soccode)     ,
                        MAX(cada)        ,
                        MAX(NVL(coutftht,0)) ,
                        MAX(NVL(coutft,0)) ,
                        MAX(NVL(coutenv,0)) ,
                        SUM(NVL(consojh,0)),
                        SUM(NVL(consoft,0)),
                        SUM(NVL(consoenv,0)),
                        0,
                        0
                        FROM IAS
    WHERE
--    Dont le cafi du DPG de la ressource est différent de 0 et de 88888 et CA_IMMO_SC_AVEC_FI
    CAFI<>0 AND CAFI<>88888 AND CAFI!=CA_IMMO_SC_PAS_FI
--    Dont le camo de la ligne est différent de 0 :
     AND codcamo<>0
     AND codcamo IS NOT NULL
--    Dont le top du camo de la ligne  est différent de " ne pas refacturer " :
    AND ctopact <>'S'
    GROUP BY cdeb,factpid,ident,codcamo,CAFI
    MINUS
        (SELECT    cdeb                     ,
                        pid         ,
                        ident         ,
                        typproj     ,
                        METIER         ,
                        pnom         ,
                        codsg         ,
                        dpcode         ,
                        icpi         ,
                        codcamo     ,
                        clibrca     ,
                        CAFI         ,
                        codsgress     ,
                        libdsg         ,
                        rnom        ,
                        rtype        ,
                        PRESTATION    ,
                        NIVEAU         ,
                        soccode     ,
                        cada        ,
                        NVL(coutftht,0)     ,
                        NVL(coutft,0)         ,
                        NVL(coutenv,0)    ,
                        NVL(consojh,0)    ,
                        NVL(consoft,0) ,
                        NVL(consoenv,0),
                        0,
                        0
                FROM TMP_IMMO
                    UNION ALL
                SELECT    cdeb                     ,
                        pid         ,
                        ident         ,
                        typproj     ,
                        METIER         ,
                        pnom         ,
                        codsg         ,
                        dpcode         ,
                        icpi         ,
                        codcamo     ,
                        clibrca     ,
                        CAFI         ,
                        codsgress     ,
                        libdsg         ,
                        rnom        ,
                        rtype        ,
                        PRESTATION    ,
                        NIVEAU         ,
                        soccode     ,
                        cada        ,
                        NVL(coutftht,0)     ,
                        NVL(coutft,0)         ,
                        NVL(coutenv,0)    ,
                        NVL(consojh,0)    ,
                        NVL(consoft,0) ,
                        NVL(consoenv,0),
                        0,
                        0
                FROM TMP_IMMO_SC)
    );
    COMMIT;
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table STOCK_FI';
    Trclog.Trclog( P_HFILE, L_STATEMENT );

    --- mise à jour des CAFI par le centractiv du dpg de la ress pour les lignes FI ayant un cafi egal à CA_IMMO_SC_AVEC_FI(99820)
    L_STATEMENT := '* Mise à jour du CAFI des lignes FI appartenant aux immos sans lien avec la compta';
    Trclog.Trclog( P_HFILE, L_STATEMENT );

    UPDATE stock_fi fi set fi.cafi = (select centractiv from struct_info s where s.codsg = fi.codsgress)
    WHERE fi.cafi = CA_IMMO_SC_AVEC_FI;

    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes imodifiées dans la table STOCK_FI';
    Trclog.Trclog( P_HFILE, L_STATEMENT );

    L_STATEMENT := '* Insertion des lignes immobilisables dans STOCK_FI:ENV';
    Trclog.Trclog( P_HFILE, L_STATEMENT );
    --On parcourt la table TMP_IMMO et on compare chaque ligne avec les lignes de la table STOCK_FI
    FOR curseur IN cur_tmp_immo LOOP

             SELECT COUNT(1) INTO l_exist
             FROM STOCK_FI
             WHERE ident=curseur.ident
             AND pid=curseur.pid
             AND cdeb=curseur.cdeb
             AND codcamo=curseur.codcamo
             AND CAFI=decode(curseur.CAFI,CA_IMMO_SC_AVEC_FI,curseur.centractiv,curseur.CAFI)
             AND icpi=curseur.icpi;

         IF l_exist = 0 THEN
             -- Créer la ligne dans STOCK_FI
             INSERT INTO STOCK_FI (
                        cdeb         ,
                        pid         ,
                        ident         ,
                        typproj         ,
                        METIER         ,
                        pnom         ,
                        codsg         ,
                        dpcode     ,
                        icpi         ,
                        codcamo     ,
                        clibrca         ,
                        CAFI         ,
                        codsgress     ,
                        libdsg         ,
                        rnom        ,
                        rtype        ,
                        PRESTATION    ,
                        NIVEAU         ,
                        soccode     ,
                        cada        ,
                        coutenv        ,
                        consojhimmo ,
                        consoenvimmo,
                        coutftht,
                        coutft,
                        consoft, nconsojhimmo, nconsoenvimmo
                            )
              VALUES (    curseur.cdeb         ,
                        curseur.pid         ,
                        curseur.ident         ,
                        curseur.typproj         ,
                        curseur.METIER         ,
                        curseur.pnom         ,
                        curseur.codsg         ,
                        curseur.dpcode     ,
                        curseur.icpi         ,
                        curseur.codcamo     ,
                        curseur.clibrca         ,
                        decode(curseur.CAFI,CA_IMMO_SC_AVEC_FI,curseur.centractiv,curseur.CAFI)         ,
                        curseur.codsgress     ,
                        curseur.libdsg         ,
                        curseur.rnom        ,
                        curseur.rtype        ,
                        curseur.PRESTATION    ,
                        curseur.NIVEAU         ,
                        curseur.soccode     ,
                        curseur.cada        ,
                        NVL(curseur.coutenv,0)     ,
                        NVL(curseur.consojh,0)      ,
                        NVL(curseur.coutenv * curseur.consojh ,0),
                        NVL(curseur.coutftht,0),
                        NVL(curseur.coutft,0),
                        0, 0, 0
                            );
             ELSE
             -- La ligne existe déjà dans STOCK_FI
             -- Ajouter les consos immo dans la ligne et modifier les consos FT
                 UPDATE STOCK_FI
                SET consojhimmo = NVL(curseur.consojh,0) ,
                    nconsojhimmo = NVL(nconsojhimmo,0) - NVL(curseur.consojh,0) ,
                    consoft = NVL(coutft,0) * (NVL(nconsojhimmo,0) - NVL(curseur.consojh,0)),
                    consoenvimmo = NVL(coutenv,0) * NVL(curseur.consojh,0),
                    nconsoenvimmo = NVL(coutenv,0) * (NVL(nconsojhimmo,0) - NVL(curseur.consojh,0))
                WHERE ident=curseur.ident
                 AND pid=curseur.pid
                 AND cdeb=curseur.cdeb;

             END IF;

    COMMIT;
    END LOOP;

    Trclog.Trclog( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);


EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE <> CALLEE_FAILED_ID THEN
                Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        END IF;
        Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        RAISE CALLEE_FAILED;
END alim_tmp_fi ;


--*************************************************************
-- Procédure de mise à jour des données de STOCK_FI_DEC
--************************************************************
PROCEDURE alim_stock_fi_dec(P_HFILE           IN UTL_FILE.FILE_TYPE)  IS

L_PROCNAME  VARCHAR2(20) := 'ALIM_STOCK_FI_DEC';
L_STATEMENT VARCHAR2(128);
l_codcamo NUMBER;
l_cafi number;
l_dpg number;
l_libdpg varchar2(30);
top_erreur number;
top_erreur_libelle number;
l_CONSOJHIMMO number;
l_NCONSOJHIMMO number;
l_CONSOFT number;
l_CONSOENVIMMO number;
 l_NCONSOENVIMMO number;

CURSOR cur_fi IS
    select * from stock_fi_dec;




BEGIN
    Trclog.Trclog( P_HFILE, 'Debut de ' || L_PROCNAME );

-- Pour chaque ligne de stock_fi_dec nous mettons à jour le CAMO, le CAFI, le DPG cd la ressource ainsi que son libellé
--
    top_erreur_libelle := 0;

    FOR ligne IN cur_fi LOOP
     top_erreur := 0;

      begin

        -- on recupère le CAFI, DPG ressource, libelle de la situation de décembre
        -- si aucune situation et trouver nous loggons l'ident pour correction ultérieur
        SELECT si.codsg, si.cafi, si.libdsg into l_dpg,l_cafi,l_libdpg
        from struct_info si, situ_ress_full sr
        where
        (sr.datsitu<=ligne.cdeb OR datsitu IS NULL)
        AND (sr.datdep>=ligne.cdeb OR datdep IS NULL)
        AND sr.ident = ligne.ident
        AND si.codsg = sr.codsg;
      exception when
      others then
          top_erreur :=1 ;
          top_erreur_libelle := 1;
               L_STATEMENT := 'ERREUR => Problème concernant la situation de la ressource : '|| ligne.ident;
                Trclog.Trclog( P_HFILE, L_STATEMENT );
       end;


    -- On regarde si le CAMO de la ligne n'a pas changé par rapport au mois de décembre
    -- si oui, on mofifie le CAMO de la ligne de décembre
    -- pour ce faire nous recuperons le CAMO de chaque ligne de la table ligne_bip
     select decode(codcamo,66666,ligne.codcamo,codcamo)  into l_codcamo from ligne_bip where pid=ligne.pid;

      if (top_erreur = 0 and l_cafi != CA_IMMO_SC_PAS_FI) then

         if (ligne.top_situ = 'E') then


        BEGIN
            select CONSOJHIMMO, NCONSOJHIMMO, CONSOFT, CONSOENVIMMO, NCONSOENVIMMO
            into l_CONSOJHIMMO, l_NCONSOJHIMMO, l_CONSOFT, l_CONSOENVIMMO, l_NCONSOENVIMMO
            from STOCK_FI
            where
            ident= ligne.ident
            and pid = ligne.pid
            and cafi =decode(l_cafi,88888,ligne.cafi,l_cafi)
            and codcamo = l_codcamo
            and cdeb = ligne.cdeb;
        EXCEPTION WHEN
        NO_DATA_FOUND THEN
            l_CONSOJHIMMO := 0;
            l_NCONSOJHIMMO := 0;
            l_CONSOFT := 0;
            l_CONSOENVIMMO := 0;
            l_NCONSOENVIMMO := 0;
        END ;


         BEGIN
            MERGE into STOCK_FI s
            using
            (
                select ligne.cdeb cdeb,ligne.pid pid, ligne.ident ident, l_cafi cafi, l_codcamo codcamo
                from dual
            )   tmp
            on
            (
                tmp.pid = s.pid
                and tmp.ident = s.ident
                and tmp.cafi = s.cafi
                and tmp.codcamo = s.codcamo
                and tmp.cdeb = s.cdeb
           )
            when matched then
                update set CONSOJHIMMO = l_CONSOJHIMMO+ligne.CONSOJHIMMO ,
                    NCONSOJHIMMO = l_NCONSOJHIMMO+ligne.NCONSOJHIMMO,
                    CONSOFT = l_CONSOFT+ligne.CONSOFT,
                    CONSOENVIMMO = l_CONSOENVIMMO+ligne.CONSOENVIMMO,
                    NCONSOENVIMMO = l_NCONSOENVIMMO+ligne.NCONSOENVIMMO
            when not matched then
                insert (CDEB, PID, IDENT, TYPPROJ, METIER, PNOM, CODSG, DPCODE, ICPI, CODCAMO,
                    CLIBRCA, CAFI, CODSGRESS, LIBDSG, RNOM, RTYPE, PRESTATION, NIVEAU, SOCCODE, CADA, COUTFTHT, COUTFT, COUTENV,
                    CONSOJHIMMO, NCONSOJHIMMO, CONSOFT, CONSOENVIMMO, NCONSOENVIMMO,
                    A_CONSOJHIMMO, A_NCONSOJHIMMO, A_CONSOFT, A_CONSOENVIMMO, A_NCONSOENVIMMO, FI1)
                values (
                   ligne.CDEB, ligne.PID, ligne.IDENT, ligne.TYPPROJ, ligne.METIER, ligne.PNOM, ligne.CODSG, ligne.DPCODE, ligne.ICPI, l_codcamo,
                    ligne.CLIBRCA, decode(l_cafi,88888,ligne.cafi,l_cafi), decode(l_cafi,88888,ligne.codsgress,l_dpg), decode(l_cafi,88888,ligne.libdsg,l_libdpg), ligne.RNOM, ligne.RTYPE, ligne.PRESTATION,
                    ligne.NIVEAU, ligne.SOCCODE, ligne.CADA, ligne.COUTFTHT, ligne.COUTFT, ligne.COUTENV,
                    ligne.CONSOJHIMMO, ligne.NCONSOJHIMMO, ligne.CONSOFT, ligne.CONSOENVIMMO, ligne.NCONSOENVIMMO,
                    ligne.A_CONSOJHIMMO, ligne.A_NCONSOJHIMMO, ligne.A_CONSOFT, ligne.A_CONSOENVIMMO, ligne.A_NCONSOENVIMMO, ligne.FI1
                    );
         EXCEPTION WHEN
         OTHERS THEN
         top_erreur_libelle := 1;
               L_STATEMENT := 'ERREUR => Problème concernant la ligne de stock_fi decembre suivante avec TOP_SITU : E ';
                Trclog.Trclog( P_HFILE, L_STATEMENT );
                 L_STATEMENT := 'IDENT : ' || ligne.ident ||' PID : ' || ligne.pid || ' CAFI : ' || ligne.cafi || ' CODCAMO : ' || ligne.codcamo;
                Trclog.Trclog( P_HFILE, L_STATEMENT );
                 L_STATEMENT := SQLERRM;
                Trclog.Trclog( P_HFILE, L_STATEMENT );
         END;

        -- cas où TOP_situ = A
        else

        BEGIN
            select CONSOJHIMMO, NCONSOJHIMMO, CONSOFT, CONSOENVIMMO, NCONSOENVIMMO
            into l_CONSOJHIMMO, l_NCONSOJHIMMO, l_CONSOFT, l_CONSOENVIMMO, l_NCONSOENVIMMO
            from STOCK_FI
            where
            ident= ligne.ident
            and pid = ligne.pid
            and cafi =ligne.cafi
            and codcamo = l_codcamo
            and cdeb = ligne.cdeb;
        EXCEPTION WHEN
        NO_DATA_FOUND THEN
            l_CONSOJHIMMO := 0;
            l_NCONSOJHIMMO := 0;
            l_CONSOFT := 0;
            l_CONSOENVIMMO := 0;
            l_NCONSOENVIMMO := 0;
        END ;


        BEGIN
            MERGE into STOCK_FI s
            using
            (
                select ligne.cdeb cdeb,ligne.pid pid, ligne.ident ident, ligne.cafi cafi, l_codcamo codcamo
                from dual
            )   tmp
            on
            (
                tmp.pid = s.pid
                and tmp.ident = s.ident
                and tmp.cafi = s.cafi
                and tmp.codcamo = s.codcamo
                and tmp.cdeb = s.cdeb
           )
            when matched then
                update set CONSOJHIMMO = l_CONSOJHIMMO+ligne.CONSOJHIMMO ,
                    NCONSOJHIMMO = l_NCONSOJHIMMO+ligne.NCONSOJHIMMO,
                    CONSOFT = l_CONSOFT+ligne.CONSOFT,
                    CONSOENVIMMO = l_CONSOENVIMMO+ligne.CONSOENVIMMO,
                    NCONSOENVIMMO = l_NCONSOENVIMMO+ligne.NCONSOENVIMMO
            when not matched then
                insert (CDEB, PID, IDENT, TYPPROJ, METIER, PNOM, CODSG, DPCODE, ICPI, CODCAMO,
                    CLIBRCA, CAFI, CODSGRESS, LIBDSG, RNOM, RTYPE, PRESTATION, NIVEAU, SOCCODE, CADA, COUTFTHT, COUTFT, COUTENV,
                    CONSOJHIMMO, NCONSOJHIMMO, CONSOFT, CONSOENVIMMO, NCONSOENVIMMO,
                    A_CONSOJHIMMO, A_NCONSOJHIMMO, A_CONSOFT, A_CONSOENVIMMO, A_NCONSOENVIMMO, FI1)
                values (
                   ligne.CDEB, ligne.PID, ligne.IDENT, ligne.TYPPROJ, ligne.METIER, ligne.PNOM, ligne.CODSG, ligne.DPCODE, ligne.ICPI, l_codcamo,
                    ligne.CLIBRCA, ligne.CAFI, ligne.CODSGRESS, ligne.LIBDSG, ligne.RNOM, ligne.RTYPE, ligne.PRESTATION,
                    ligne.NIVEAU, ligne.SOCCODE, ligne.CADA, ligne.COUTFTHT, ligne.COUTFT, ligne.COUTENV,
                    ligne.CONSOJHIMMO, ligne.NCONSOJHIMMO, ligne.CONSOFT, ligne.CONSOENVIMMO, ligne.NCONSOENVIMMO,
                    ligne.A_CONSOJHIMMO, ligne.A_NCONSOJHIMMO, ligne.A_CONSOFT, ligne.A_CONSOENVIMMO, ligne.A_NCONSOENVIMMO, ligne.FI1
                    );
          EXCEPTION WHEN
         OTHERS THEN
            top_erreur_libelle := 1;
               L_STATEMENT := 'ERREUR => Problème concernant la ligne de stock_fi decembre suivante avec TOP_SITU : A ';
                Trclog.Trclog( P_HFILE, L_STATEMENT );
                 L_STATEMENT := 'IDENT : ' || ligne.ident ||' PID : ' || ligne.pid || ' CAFI : ' || ligne.cafi || ' CODCAMO : ' || ligne.codcamo;
                Trclog.Trclog( P_HFILE, L_STATEMENT );
                 L_STATEMENT := SQLERRM;
                Trclog.Trclog( P_HFILE, L_STATEMENT );
         END;
        end if;

        end if;
      END loop;

    COMMIT;
    
-- SEL PPM 59018 06/06/2014 8.6  
    --- mise à jour des CAFI par le centractiv du dpg de la ress pour les lignes FI (de decembre) ayant un cafi egal à CA_IMMO_SC_AVEC_FI(99820)
    L_STATEMENT := '* Mise à jour du CAFI des lignes FI (de decembre) appartenant aux immos sans lien avec la compta';
    Trclog.Trclog( P_HFILE, L_STATEMENT );
    
    UPDATE stock_fi fi set fi.cafi = (select centractiv from struct_info s where s.codsg = fi.codsgress)
    WHERE fi.cafi = CA_IMMO_SC_AVEC_FI;
    
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes imodifiées dans la table STOCK_FI';
    Trclog.Trclog( P_HFILE, L_STATEMENT );
    
    -- Suppression des lignes insérées dans la table STOCK_FI dont le métier est FOR
    --
    DELETE FROM STOCK_FI
    WHERE STOCK_FI.METIER = 'FOR' ;

    COMMIT;

    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes de métier FOR supprimées de la table STOCK_FI';
    Trclog.Trclog( P_HFILE, L_STATEMENT );

    IF (top_erreur_libelle = 1) then
       RAISE CALLEE_FAILED;
    else
        Trclog.Trclog( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
    end if;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE <> CALLEE_FAILED_ID THEN
                Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        END IF;
        Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        RAISE CALLEE_FAILED;
END alim_stock_fi_dec ;
--*************************************************************
-- Procédure pour la facturation multi-CA :
-- Pour les CODCAMO=77777, on répartit les charges
-- entre les CA de la table repartition_ligne et suivant les différents taux.
--************************************************************
PROCEDURE repartition_fi(P_HFILE           IN UTL_FILE.FILE_TYPE)  IS
CODCAMO_MULTI    NUMBER(6)     := 77777;
L_PROCNAME      VARCHAR2(16)     := 'REPARTITION_FI';
L_STATEMENT     VARCHAR2(128);
CURSOR cur_multi_ca IS
SELECT * FROM STOCK_FI WHERE codcamo=CODCAMO_MULTI;

BEGIN
    Trclog.Trclog( P_HFILE, 'Debut de ' || L_PROCNAME );
    FOR curseur IN cur_multi_ca LOOP
         BEGIN
            -- On effectue la mise à jour avec les taux fixés.
            INSERT INTO STOCK_FI(
                cdeb        ,
                pid        ,
                ident        ,
                typproj        ,
                METIER        ,
                pnom        ,
                codsg         ,
                dpcode         ,
                icpi         ,
                codcamo     ,
                clibrca     ,
                CAFI         ,
                codsgress     ,
                libdsg         ,
                rnom        ,
                rtype        ,
                PRESTATION    ,
                NIVEAU         ,
                soccode     ,
                cada        ,
                coutftht    ,
                coutft        ,
                coutenv        ,
                consojhimmo     ,
                nconsojhimmo    ,
                consoenvimmo    ,
                nconsoenvimmo    ,
                consoft
                )
            ( SELECT
                curseur.cdeb        ,
                curseur.pid        ,
                curseur.ident        ,
                curseur.typproj        ,
                curseur.METIER        ,
                curseur.pnom         ,
                curseur.codsg         ,
                curseur.dpcode         ,
                curseur.icpi         ,
                rl.codcamo         ,
                ca.clibrca         ,
                curseur.CAFI         ,
                curseur.codsgress     ,
                curseur.libdsg         ,
                curseur.rnom        ,
                curseur.rtype        ,
                curseur.PRESTATION    ,
                curseur.NIVEAU         ,
                curseur.soccode     ,
                curseur.cada        ,
                NVL(curseur.coutftht,0)    ,
                NVL(curseur.coutft,0)    ,
                NVL(curseur.coutenv,0)     ,
                ROUND(NVL(curseur.consojhimmo,0) * (rl.tauxrep/100), 2)     ,
                ROUND(NVL(curseur.nconsojhimmo,0) * (rl.tauxrep/100), 2)    ,
                ROUND(NVL(curseur.consoenvimmo,0) * (rl.tauxrep/100), 2)    ,
                ROUND(NVL(curseur.nconsoenvimmo,0) * (rl.tauxrep/100), 2)    ,
                ROUND(NVL(curseur.consoft,0) * (rl.tauxrep/100), 2)
              FROM REPARTITION_LIGNE rl, CENTRE_ACTIVITE ca
              WHERE rl.pid = curseur.pid
                AND rl.codcamo = ca.codcamo
                AND rl.datdeb <= curseur.cdeb
                AND (rl.datfin IS NULL OR rl.datfin > curseur.cdeb)
            );
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                Trclog.Trclog( P_HFILE, L_PROCNAME || ': Pas de répartition pour la ligne BIP ' || curseur.pid || ' et pour la date ' || TO_CHAR(curseur.cdeb, 'MM/YYYY') || '.');
        END;
        COMMIT;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE <> CALLEE_FAILED_ID THEN
                Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        END IF;
        Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        RAISE CALLEE_FAILED;
END repartition_fi;
-- **************************************************************************************
-- Vérification des arrondis dans les coûts (afin d'avoir le bon montant total à la fin).
-- **************************************************************************************
PROCEDURE verif_arrondis(P_HFILE           IN UTL_FILE.FILE_TYPE)  IS
CODCAMO_MULTI    NUMBER(6)     := 77777;
L_PROCNAME      VARCHAR2(16)     := 'VERIF_ARRONDIS';
L_STATEMENT     VARCHAR2(128);

-- Curseur contenant toutes les erreurs d'arrondis
CURSOR cur_err_arrondis IS
    SELECT     sf.pid,
        sf.cdeb,
        sf.ident,
        sf.cafi,
        consojhimmo - s_consojhimmo d_consojhimmo,
        nconsojhimmo - s_nconsojhimmo d_nconsojhimmo,
        consoenvimmo - s_consoenvimmo d_consoenvimmo,
        nconsoenvimmo - s_nconsoenvimmo d_nconsoenvimmo,
        consoft - s_consoft d_consoft
    FROM     STOCK_FI sf,
        -- Sommes des Coûts pour les lignes Multi-CA
        (SELECT pid,
            cdeb,
            ident,
            cafi,
            SUM(consojhimmo)    s_consojhimmo,
            SUM(nconsojhimmo)    s_nconsojhimmo,
            SUM(consoenvimmo)    s_consoenvimmo,
            SUM(nconsoenvimmo)    s_nconsoenvimmo,
            SUM(consoft)        s_consoft
         FROM   STOCK_FI
         WHERE    codcamo != CODCAMO_MULTI
           AND     pid IN (SELECT pid FROM STOCK_FI WHERE codcamo=CODCAMO_MULTI)
         GROUP BY pid, cdeb, ident,cafi
         ) s_couts
    WHERE sf.codcamo= CODCAMO_MULTI
      AND sf.pid    = s_couts.pid
      AND sf.cdeb    = s_couts.cdeb
      AND sf.ident    = s_couts.ident
      and sf.cafi = s_couts.cafi
      -- La sommes des coûts multi_CA est différente du coût d'origine.
      AND (  consojhimmo    != s_consojhimmo
            OR nconsojhimmo    != s_nconsojhimmo
            OR consoenvimmo    != s_consoenvimmo
            OR nconsoenvimmo!= s_nconsoenvimmo
            OR consoft    != s_consoft
      )
  ;
BEGIN
    -- On corrige la différence à partir sur la première ligne trouvée.
    FOR curseur IN cur_err_arrondis LOOP
        UPDATE STOCK_FI s SET
            consojhimmo    = consojhimmo + curseur.d_consojhimmo,
                nconsojhimmo    = nconsojhimmo + curseur.d_nconsojhimmo,
                consoenvimmo    = consoenvimmo + curseur.d_consoenvimmo,
                nconsoenvimmo    = nconsoenvimmo + curseur.d_nconsoenvimmo,
                consoft        = consoft + curseur.d_consoft
        WHERE pid    = curseur.pid
          AND cdeb    = curseur.cdeb
          AND ident    = curseur.ident
          and cafi = curseur.cafi
          -- On effectue la MAJ sur le même CA tous les mois afin d'éviter des faux retours arrières
          AND codcamo   = (SELECT     MAX(sf.codcamo)
                     FROM     STOCK_FI sf
                     WHERE      codcamo!=CODCAMO_MULTI
                       AND    s.pid=sf.pid
                       AND    s.cdeb=sf.cdeb
                       AND    s.ident=sf.ident
                       and   s.cafi = sf.cafi);
        COMMIT;
    END LOOP;

    Packbatch.DYNA_TRUNCATE('STOCK_FI_MULTI');

    -- On stocke les lignes avec CA = CODCAMO_MULTI(77777) dans la table STOCK_FI_MULTI
    -- Cela servira pour la traitement de cloture

    INSERT INTO STOCK_FI_MULTI(CDEB,
                PID,
                IDENT,
                TYPPROJ,
                METIER,
                PNOM,
                CODSG,
                DPCODE,
                ICPI,
                CODCAMO,
                CLIBRCA,
                CAFI,
                CODSGRESS,
                LIBDSG,
                RNOM,
                RTYPE,
                PRESTATION,
                NIVEAU,
                SOCCODE,
                CADA,
                COUTFTHT,
                COUTFT,
                COUTENV,
                CONSOJHIMMO,
                NCONSOJHIMMO,
                CONSOFT,
                CONSOENVIMMO,
                NCONSOENVIMMO,
                A_CONSOFT,
                A_CONSOENVIMMO,
                A_NCONSOENVIMMO,
                A_CONSOJHIMMO,
                A_NCONSOJHIMMO)
    SELECT CDEB,
                PID,
                IDENT,
                TYPPROJ,
                METIER,
                PNOM,
                CODSG,
                DPCODE,
                ICPI,
                CODCAMO,
                CLIBRCA,
                CAFI,
                CODSGRESS,
                LIBDSG,
                RNOM,
                RTYPE,
                PRESTATION,
                NIVEAU,
                SOCCODE,
                CADA,
                COUTFTHT,
                COUTFT,
                COUTENV,
                CONSOJHIMMO,
                NCONSOJHIMMO,
                CONSOFT,
                CONSOENVIMMO,
                NCONSOENVIMMO,
                A_CONSOFT,
                A_CONSOENVIMMO,
                A_NCONSOENVIMMO,
                A_CONSOJHIMMO,
                A_NCONSOJHIMMO
            FROM STOCK_FI
            WHERE codcamo = CODCAMO_MULTI ;
    COMMIT;

    -- On supprime les CA non refacturés et les CA = CODCAMO_MULTI(77777)
    DELETE STOCK_FI
    WHERE codcamo = CODCAMO_MULTI
       OR codcamo = 0
       OR codcamo IS NULL
       OR codcamo IN (SELECT codcamo FROM CENTRE_ACTIVITE WHERE ctopact = 'S');
    COMMIT;

    Trclog.Trclog( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE <> CALLEE_FAILED_ID THEN
                Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        END IF;
        Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        RAISE CALLEE_FAILED;
END verif_arrondis;
--*************************************************************
-- Procédure d'alimentation de la table STOCK_IMMO
--************************************************************
PROCEDURE alim_stock_immo(P_HFILE           IN UTL_FILE.FILE_TYPE)  IS
CURSOR cur_stock_immo IS
SELECT * FROM STOCK_IMMO ;

L_PROCNAME  VARCHAR2(16) := 'ALIM_STOCK_IMMO';
L_STATEMENT VARCHAR2(128);
l_consojh NUMBER(12,2);
l_consoft NUMBER(12,2);
l_a_consojh NUMBER(12,2);
l_a_consoft NUMBER(12,2);
l_moismens NUMBER(2);


BEGIN
      Trclog.Trclog( P_HFILE, 'Debut de ' || L_PROCNAME );
    -- --------------------------------------------------------------------------
    -- Etape préliminaire : vider STOCK_IMMO _1, copier STOCK_IMMO  dans STOCK_IMMO _1, vider STOCK_IMMO
    -- ---------------------------------------------------------------------------
    L_STATEMENT := '* Copier STOCK_IMMO  dans STOCK_IMMO _1';
    Trclog.Trclog( P_HFILE, L_STATEMENT );
    Packbatch.DYNA_TRUNCATE('STOCK_IMMO_1');
    INSERT INTO STOCK_IMMO_1
    SELECT * FROM STOCK_IMMO
    WHERE immo1!='O' OR immo1 IS NULL; --Ne pas copier les lignes qui existaient dans stock_fi_1 et pas dans stock_fi

    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table STOCK_IMMO _1';
    COMMIT;
    Packbatch.DYNA_TRUNCATE('STOCK_IMMO');

     --Insérer dans STOCK_IMMO toutes les lignes de TMP_IMMO
     INSERT INTO STOCK_IMMO (CDEB,
                               PID ,
                             IDENT  ,
                             TYPPROJ ,
                             METIER ,
                             PNOM   ,
                             CODSG ,
                             DPCODE  ,
                             ICPI   ,
                             CODCAMO ,
                             CLIBRCA  ,
                             CAFI     ,
                             CODSGRESS,
                             LIBDSG  ,
                             RNOM    ,
                             RTYPE   ,
                             PRESTATION ,
                             NIVEAU    ,
                             SOCCODE  ,
                             CADA    ,
                             COUTFTHT ,
                             COUTFT   ,
                             CONSOJH  ,
                             CONSOFT  )
     SELECT                  t.CDEB,
                               t.PID ,
                             t.IDENT ,
                             t.TYPPROJ ,
                             t.METIER ,
                             t.PNOM   ,
                             t.CODSG ,
                             t.DPCODE  ,
                             t.ICPI   ,
                             t.CODCAMO ,
                             t.CLIBRCA  ,
                             --si cafi=88888 alors prendre le CA du DPG de la ressource
                             DECODE(t.CAFI,88888,s.CENTRACTIV,t.CAFI)     ,
                             t.CODSGRESS,
                             t.LIBDSG  ,
                             t.RNOM    ,
                             t.RTYPE   ,
                             t.PRESTATION ,
                             t.NIVEAU    ,
                             t.SOCCODE  ,
                             t.CADA    ,
                             NVL(t.COUTFTHT,0) ,
                             NVL(t.COUTFT ,0)  ,
                             NVL(t.CONSOJH ,0) ,
                             NVL(t.CONSOFT,0)
    FROM TMP_IMMO t, STRUCT_INFO s
    WHERE t.CODSGRESS=s.CODSG;
     COMMIT;

     -- On compare chaque ligne de STOCK_IMMO avec les lignes de STOCK_IMMO_1
     L_STATEMENT := '* Calcul des retours arrière';
     Trclog.Trclog( P_HFILE, L_STATEMENT );
     --Calcul des retours arrières
      FOR curseur IN cur_stock_immo LOOP
         BEGIN
                SELECT consojh,
                     consoft
                     INTO l_consojh,l_consoft
              FROM STOCK_IMMO_1 s
              WHERE s.ident = curseur.ident
              AND s.pid = curseur.pid
              AND s.cdeb = curseur.cdeb
              AND s.icpi=curseur.icpi
              AND s.CAFI=curseur.CAFI;

              -- Calcul des retours arrières
              l_a_consojh := NVL(curseur.consojh,0) - NVL(l_consojh,0);
              l_a_consoft := NVL(curseur.consoft,0) - NVL(l_consoft,0);


              UPDATE STOCK_IMMO
              SET     a_consojh = l_a_consojh,
                    a_consoft = l_a_consoft
              WHERE ident = curseur.ident
              AND pid = curseur.pid
              AND cdeb = curseur.cdeb
              AND icpi=curseur.icpi
              AND CAFI=curseur.CAFI;


        EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                       UPDATE STOCK_IMMO
                      SET a_consojh = NVL(curseur.consojh,0),
                            a_consoft = NVL(curseur.consoft,0)
                      WHERE ident = curseur.ident
                        AND pid = curseur.pid
                        AND cdeb = curseur.cdeb
                        AND icpi=curseur.icpi
                        AND CAFI=curseur.CAFI;

        END;


     END LOOP;
    COMMIT;
    -- Cas où il existe des lignes dans STOCK_IMMO_1 et pas dans STOCK_IMMO
     L_STATEMENT := '* Insertion des lignes dans STOCK_IMMO existant dans STOCK_IMMO_1 et pas dans STOCK_IMMO';
     Trclog.Trclog( P_HFILE, L_STATEMENT );
    INSERT INTO STOCK_IMMO (cdeb         ,
                        pid         ,
                        ident         ,
                        typproj     ,
                        METIER         ,
                        pnom         ,
                        codsg         ,
                        dpcode         ,
                        icpi         ,
                        codcamo     ,
                        clibrca     ,
                        CAFI         ,
                        codsgress     ,
                        libdsg         ,
                        rnom        ,
                        rtype        ,
                        PRESTATION    ,
                        NIVEAU         ,
                        soccode     ,
                        cada        ,
                        coutftht    ,
                        coutft     ,
                        consojh,
                        consoft    ,
                        a_consojh,
                        a_consoft,
                        immo1
                        )
     SELECT             s.cdeb         ,
                        s.pid         ,
                        s.ident         ,
                        s.typproj     ,
                        s.METIER         ,
                        s.pnom         ,
                        s.codsg         ,
                        s.dpcode         ,
                        s.icpi         ,
                        s.codcamo     ,
                        s.clibrca     ,
                        s.CAFI         ,
                        s.codsgress     ,
                        s.libdsg         ,
                        s.rnom        ,
                        s.rtype        ,
                        s.PRESTATION    ,
                        s.NIVEAU         ,
                        s.soccode     ,
                        s.cada        ,
                        NVL(s.coutftht,0)    ,
                        NVL(s.coutft,0)     ,
                        0    ,
                        0     ,
                        DECODE(s.consojh,0, s.a_consojh,- (s.consojh)),
                        DECODE(s.consojh,0,s.a_consoft,- s.consoft),
                        'O'
        FROM
        (SELECT cdeb,pid,ident,CAFI,icpi FROM STOCK_IMMO_1
         MINUS
         SELECT cdeb,pid,ident,CAFI,icpi FROM STOCK_IMMO) n,
        STOCK_IMMO_1 s, DATDEBEX d
        WHERE n.ident=s.ident
        AND n.pid=s.pid
        AND n.cdeb=s.cdeb
        AND n.icpi=s.icpi
        AND n.CAFI=s.CAFI;
        -- on ne compare pas les lignes de dec N-1

        --06/07/2004 KHA gestion immo de janv à dec
        --
        --and to_char(s.cdeb,'MM/YYYY')<>'12/'||to_char(add_months(d.moismens,-12),'YYYY')

        COMMIT;

        -- Mise à jour du CADA en prenant comme référence celui lié au projet le jour du
        -- traitement.

        UPDATE STOCK_IMMO
        SET CADA=(SELECT cada FROM PROJ_INFO
              WHERE STOCK_IMMO.icpi=PROJ_INFO.icpi)
        ;

        COMMIT;

        L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table STOCK_IMMO';
        Trclog.Trclog( P_HFILE, L_STATEMENT );


        Trclog.Trclog( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE <> CALLEE_FAILED_ID THEN
                Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        END IF;
        Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        RAISE CALLEE_FAILED;
END alim_stock_immo;
--*************************************************************
-- Procédure d'alimentation de la table STOCK_FI :
-- retours arrières
--**************************************************************
PROCEDURE alim_stock_fi(P_HFILE           IN UTL_FILE.FILE_TYPE)   IS
CURSOR cur_stock_fi IS
SELECT * FROM STOCK_FI ;

L_PROCNAME  VARCHAR2(16) := 'ALIM_STOCK_FI';
L_STATEMENT VARCHAR2(128);

l_consojhimmo NUMBER(10,2);
l_nconsojhimmo NUMBER(10,2);
l_consoft NUMBER(10,2);
l_consoenvimmo NUMBER(10,2);
l_nconsoenvimmo NUMBER(10,2);
l_a_consojhimmo NUMBER(10,2);
l_a_nconsojhimmo NUMBER(10,2);
l_a_consoft NUMBER(10,2);
l_a_consoenvimmo NUMBER(10,2);
l_a_nconsoenvimmo NUMBER(10,2);
l_moismens NUMBER(2);
BEGIN
      Trclog.Trclog( P_HFILE, 'Debut de ' || L_PROCNAME );

     -- On compare chaque ligne de STOCK_FI avec les lignes de STOCK_FI_1
     L_STATEMENT := '* Calcul des retours arrière';
     Trclog.Trclog( P_HFILE, L_STATEMENT );
     FOR curseur IN cur_stock_fi LOOP
         BEGIN
                SELECT consojhimmo,
                       nconsojhimmo,
                     consoft,
                     consoenvimmo,
                     nconsoenvimmo
                     INTO l_consojhimmo,l_nconsojhimmo,l_consoft,l_consoenvimmo,l_nconsoenvimmo
              FROM STOCK_FI_1 s
              WHERE s.ident = curseur.ident
              AND s.pid = curseur.pid
              AND s.cdeb = curseur.cdeb
              AND s.codcamo=curseur.codcamo
              AND s.CAFI=curseur.CAFI;

              -- Calcul des retours arrières
             -- l_a_consojh := (curseur.consojhimmo+curseur.nconsojhimmo)-(l_consojhimmo+l_nconsojhimmo);
              l_a_consojhimmo := NVL(curseur.consojhimmo,0) - NVL(l_consojhimmo,0);
              l_a_nconsojhimmo := NVL(curseur.nconsojhimmo,0) - NVL(l_nconsojhimmo,0);
              l_a_consoft := NVL(curseur.consoft,0) - NVL(l_consoft,0);
              l_a_consoenvimmo := NVL(curseur.consoenvimmo,0) - NVL(l_consoenvimmo,0);
              l_a_nconsoenvimmo  := NVL(curseur.nconsoenvimmo,0) - NVL(l_nconsoenvimmo,0);

              UPDATE STOCK_FI
              SET     a_consojhimmo = l_a_consojhimmo,
                      a_nconsojhimmo = l_a_nconsojhimmo,
                    a_consoft = l_a_consoft,
                    a_consoenvimmo = l_a_consoenvimmo,
                    a_nconsoenvimmo =  l_a_nconsoenvimmo
              WHERE ident = curseur.ident
              AND pid = curseur.pid
              AND cdeb = curseur.cdeb
              AND codcamo=curseur.codcamo
              AND CAFI=curseur.CAFI;


        EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                       UPDATE STOCK_FI
                      SET a_consojhimmo = NVL(curseur.consojhimmo,0),
                            a_nconsojhimmo =NVL(curseur.nconsojhimmo,0),
                            a_consoft = NVL(curseur.consoft,0),
                          a_consoenvimmo = NVL(curseur.consoenvimmo,0),
                          a_nconsoenvimmo = NVL(curseur.nconsoenvimmo,0)
                      WHERE ident = curseur.ident
                        AND pid = curseur.pid
                        AND cdeb = curseur.cdeb
                        AND codcamo=curseur.codcamo
                        AND CAFI=curseur.CAFI;

        END;


     END LOOP;
    COMMIT;
    -- Cas où il existe des lignes dans STOCK_FI_1 et pas dans STOCK_FI
     L_STATEMENT := '* Insertion des lignes dans STOCK_FI existant dans STOCK_FI_1 et pas dans STOCK_FI';
     Trclog.Trclog( P_HFILE, L_STATEMENT );
    INSERT INTO STOCK_FI (cdeb         ,
                        pid         ,
                        ident         ,
                        typproj     ,
                        METIER         ,
                        pnom         ,
                        codsg         ,
                        dpcode         ,
                        icpi         ,
                        codcamo     ,
                        clibrca     ,
                        CAFI         ,
                        codsgress     ,
                        libdsg         ,
                        rnom        ,
                        rtype        ,
                        PRESTATION    ,
                        NIVEAU         ,
                        soccode     ,
                        cada        ,
                        coutftht    ,
                        coutft     ,
                        coutenv    ,
                        consojhimmo     ,
                        nconsojhimmo     ,
                        consoft    ,
                        consoenvimmo,
                        nconsoenvimmo,
                        a_consojhimmo,
                        a_nconsojhimmo,
                        a_consoft,
                        a_consoenvimmo,
                        a_nconsoenvimmo,
                        fi1)
     SELECT             s.cdeb         ,
                        s.pid         ,
                        s.ident         ,
                        s.typproj     ,
                        s.METIER         ,
                        s.pnom         ,
                        s.codsg         ,
                        s.dpcode         ,
                        s.icpi         ,
                        s.codcamo     ,
                        s.clibrca     ,
                        s.CAFI         ,
                        s.codsgress     ,
                        s.libdsg         ,
                        s.rnom        ,
                        s.rtype        ,
                        s.PRESTATION    ,
                        s.NIVEAU         ,
                        s.soccode     ,
                        s.cada        ,
                        NVL(s.coutftht,0)    ,
                        NVL(s.coutft,0)     ,
                        NVL(s.coutenv,0)    ,
                        0    ,
                        0     ,
                        0    ,
                        0    ,
                        0    ,
                        - s.consojhimmo,
                        - s.nconsojhimmo,
                        - s.consoft,
                        - s.consoenvimmo,
                        - s.nconsoenvimmo,
                         'O'
        FROM
        (SELECT cdeb,pid,ident,CAFI,codcamo FROM STOCK_FI_1
         MINUS
         SELECT cdeb,pid,ident,CAFI,codcamo FROM STOCK_FI) n,
        STOCK_FI_1 s, DATDEBEX d
        WHERE n.ident=s.ident
        AND n.pid=s.pid
        AND n.cdeb=s.cdeb
        AND n.codcamo=s.codcamo
        AND n.CAFI=s.CAFI;


        COMMIT;
        L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table STOCK_FI';
        Trclog.Trclog( P_HFILE, L_STATEMENT );

        Trclog.Trclog( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        IF SQLCODE <> CALLEE_FAILED_ID THEN
                Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        END IF;
        Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        RAISE CALLEE_FAILED;
END alim_stock_fi;
--*************************************************************
-- Procédure de création du fichier pour la FI
--************************************************************
PROCEDURE fi( P_LOGDIR          IN VARCHAR2,
              p_chemin_fichier  IN VARCHAR2,
              p_nom_fichier     IN VARCHAR2) IS
CURSOR cur_fi IS
--Montant de FI de type OPE=3
SELECT
    '30003'                                        AS cdbqma,
    LPAD(codcamo,5,'0')                                AS cdcamo,
    '30003'                                        AS cdbqme,
    LPAD(TO_CHAR(CAFI),5,'0')                            AS cdcamu,
    '3'                    AS cdofei,
    DECODE(SIGN(SUM(a_consoft)),-1,'O',0,'O','N')                AS tregul,
    DECODE(SIGN(SUM(a_consoft)),-1,'-',1,'+')                    AS signe,
    LPAD(ROUND(ABS(SUM(a_consoft))*100,0),16,'0')                AS mtopr,
    'EUR'                                            AS cddv,
    '2'                                            AS nbdedv
FROM
STOCK_FI
WHERE METIER IN ('ME','MO','HOM')
GROUP BY CAFI, codcamo
HAVING  SUM(a_consoft)<>0
UNION
--Montant de FI de type OPE=4
SELECT
    '30003'                                        AS cdbqma,
    LPAD(codcamo,5,'0')                                AS cdcamo,
    '30003'                                        AS cdbqme,
    LPAD(TO_CHAR(CAFI),5,'0')                            AS cdcamu,
    '4'                    AS cdofei,
    DECODE(SIGN(SUM(a_nconsoenvimmo)),-1,'O',0,'O','N')                AS tregul,
    DECODE(SIGN(SUM(a_nconsoenvimmo)),-1,'-',1,'+')                    AS signe,
    LPAD(ROUND(ABS(SUM(a_nconsoenvimmo))*100,0),16,'0')                AS mtopr,
    'EUR'                                            AS cddv,
    '2'                                            AS nbdedv
FROM
STOCK_FI
WHERE METIER IN ('ME','MO','HOM')
GROUP BY CAFI, codcamo
HAVING  SUM(a_nconsoenvimmo)<>0
UNION
--Montant de FI de type OPE=5
SELECT
    '30003'                                        AS cdbqma,
    LPAD(codcamo,5,'0')                                AS cdcamo,
    '30003'                                        AS cdbqme,
    LPAD(TO_CHAR(CAFI),5,'0')                            AS cdcamu,
    '5'                    AS cdofei,
    DECODE(SIGN(SUM(a_consoenvimmo)),-1,'O',0,'O','N')                AS tregul,
    DECODE(SIGN(SUM(a_consoenvimmo)),-1,'-',1,'+')                    AS signe,
    LPAD(ROUND(ABS(SUM(a_consoenvimmo))*100,0),16,'0')                AS mtopr,
    'EUR'                                            AS cddv,
    '2'                                            AS nbdedv
FROM
STOCK_FI
WHERE METIER IN ('ME','MO','HOM')
GROUP BY CAFI, codcamo
HAVING  SUM(a_consoenvimmo)<>0
UNION
--Montant de FI de type OPE=6
SELECT
    '30003'                                        AS cdbqma,
    LPAD(codcamo,5,'0')                                AS cdcamo,
    '30003'                                        AS cdbqme,
    LPAD(TO_CHAR(CAFI),5,'0')                            AS cdcamu,
    '6'                    AS cdofei,
    DECODE(SIGN(SUM(a_consoft)),-1,'O',0,'O','N')                AS tregul,
    DECODE(SIGN(SUM(a_consoft)),-1,'-',1,'+')                    AS signe,
    LPAD(ROUND(ABS(SUM(a_consoft))*100,0),16,'0')                AS mtopr,
    'EUR'                                            AS cddv,
    '2'                                            AS nbdedv
FROM
STOCK_FI
WHERE METIER IN ('GAP','SAU')
GROUP BY CAFI, codcamo
HAVING  SUM(a_consoft)<>0
UNION
--Montant de FI de type OPE=7
SELECT
    '30003'                                        AS cdbqma,
    LPAD(codcamo,5,'0')                                AS cdcamo,
    '30003'                                        AS cdbqme,
    LPAD(TO_CHAR(CAFI),5,'0')                            AS cdcamu,
    '7'                    AS cdofei,
    DECODE(SIGN(SUM(a_consoft)),-1,'O',0,'O','N')                AS tregul,
    DECODE(SIGN(SUM(a_consoft)),-1,'-',1,'+')                    AS signe,
    LPAD(ROUND(ABS(SUM(a_consoft))*100,0),16,'0')                AS mtopr,
    'EUR'                                            AS cddv,
    '2'                                            AS nbdedv
FROM
STOCK_FI
WHERE METIER = 'EXP'
GROUP BY CAFI, codcamo
HAVING  SUM(a_consoft)<>0
UNION
--Montant de FI de type OPE=8
SELECT
    '30003'                                        AS cdbqma,
    LPAD(codcamo,5,'0')                                AS cdcamo,
    '30003'                                        AS cdbqme,
    LPAD(TO_CHAR(CAFI),5,'0')                            AS cdcamu,
    '8'                    AS cdofei,
    DECODE(SIGN(SUM(a_nconsoenvimmo+a_consoenvimmo)),-1,'O',0,'O','N')                AS tregul,
    DECODE(SIGN(SUM(a_nconsoenvimmo+a_consoenvimmo)),-1,'-',1,'+')                    AS signe,
    LPAD(ROUND(ABS(SUM(a_nconsoenvimmo+a_consoenvimmo))*100,0),16,'0')                AS mtopr,
    'EUR'                                            AS cddv,
    '2'                                            AS nbdedv
FROM
STOCK_FI
WHERE METIER IN ('EXP','GAP','SAU')
GROUP BY CAFI, codcamo
HAVING  SUM(a_nconsoenvimmo+a_consoenvimmo)<>0
ORDER BY 4,2,5;

L_RETCOD    NUMBER;
L_PROCNAME  VARCHAR2(16) := 'FI';
L_HFILE1     UTL_FILE.FILE_TYPE;
L_STATEMENT VARCHAR2(128);
l_moismens      DATE;
l_hfile      UTL_FILE.FILE_TYPE;
l_nbenreg      NUMBER(15);

BEGIN
    -----------------------------------------------------
    -- Init de la trace
    -----------------------------------------------------
    L_RETCOD := Trclog.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE1 );
    IF ( L_RETCOD <> 0 ) THEN
    RAISE_APPLICATION_ERROR( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 FALSE );
    END IF;
    -----------------------------------------------------
    -- Trace Start
    -----------------------------------------------------
    Trclog.Trclog( L_HFILE1, 'Debut de ' || L_PROCNAME );

     L_STATEMENT := 'ECRITURE DANS LES FICHIERS DE FI : début';
     Trclog.Trclog( L_HFILE1, L_STATEMENT );

     L_STATEMENT := 'Init du fichier de sortie : ' || p_chemin_fichier || '/' || p_nom_fichier || '.txt';
     Trclog.Trclog( L_HFILE1, L_STATEMENT );
     Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);

     SELECT moismens INTO l_moismens FROM DATDEBEX;

     -- Création de l'entête du fichier
     Pack_Global.WRITE_STRING(    l_hfile,
                            '1'        ||
                            '0'        ||
                            'BIP54703'    ||
                            'DDDD3725'        ||
                            '00401'       ||
                            'A0374'    ||
                            TO_CHAR(l_moismens,'yyyymm')    ||
                            TO_CHAR(SYSDATE,'yyyymmdd')    ||
                            TO_CHAR(SYSDATE,'HH24MI')        ||
                            TO_CHAR(LAST_DAY(l_moismens),'yyyymmdd')    ||
                            RPAD(' ',6)
                        );

     -- Corps du fichier
     FOR ligne IN cur_fi LOOP
          Pack_Global.WRITE_STRING(    l_hfile,
                            '2'            ||
                            '1'            ||
                            ligne.cdbqma        ||
                            ligne.cdcamo        ||
                            ligne.cdbqme    ||
                            ligne.cdcamu        ||
                            ligne.cdofei       ||
                            ligne.tregul    ||
                            ligne.signe    ||
                            ligne.mtopr    ||
                            ligne.cddv        ||
                            ligne.nbdedv    ||
                            RPAD(' ',15)
                        );

        --On compte le nombre de lignes
        l_nbenreg := cur_fi%ROWCOUNT ;

     END LOOP;

     -- Fin de fichier
     Pack_Global.WRITE_STRING(    l_hfile,
                            '9'        ||
                            '0'        ||
                            LTRIM(TO_CHAR(l_nbenreg,'000000000')) ||
                            RPAD(' ',49)
                        );

    L_STATEMENT := 'FIN ECRITURE DANS LE FICHIER FI';
    Trclog.Trclog( L_HFILE1, L_STATEMENT );
    L_STATEMENT := '-> '||l_nbenreg ||' lignes créées dans le fichier FI';
    Trclog.Trclog( L_HFILE1, L_STATEMENT );
    Pack_Global.CLOSE_WRITE_FILE(l_hfile);

    -----------------------------------------------------
    -- Trace Stop
    -----------------------------------------------------
    Trclog.Trclog( L_HFILE1, 'Fin normale de ' || L_PROCNAME  );
    Trclog.CLOSETRCLOG( L_HFILE1 );

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE <> CALLEE_FAILED_ID AND SQLCODE <> TRCLOG_FAILED_ID THEN
                Trclog.Trclog( L_HFILE1, L_PROCNAME || ' : ' || SQLERRM );
            END IF;
            IF SQLCODE <> TRCLOG_FAILED_ID THEN
                Trclog.Trclog( L_HFILE1, 'Fin ANORMALE de ' || L_PROCNAME  );
                Trclog.CLOSETRCLOG( L_HFILE1 );
                RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         FALSE );
            ELSE
                RAISE;
            END IF;


END fi;
--*************************************************************
-- Procédure de création du fichier pour SMS appelée par le shell
--************************************************************
PROCEDURE immo( P_LOGDIR          IN VARCHAR2,
                  p_chemin_fichier  IN VARCHAR2,
                  p_nom_fichier     IN VARCHAR2) IS
CURSOR cur_immo IS
SELECT * FROM vue_immo;

L_RETCOD    NUMBER;
L_PROCNAME  VARCHAR2(16) := 'IMMO';
L_HFILE1    UTL_FILE.FILE_TYPE;
L_STATEMENT VARCHAR2(128);
l_hfile     UTL_FILE.FILE_TYPE;
l_separateur CHAR(1) := ';';
l_nbenreg      NUMBER(15);
l_zone_evol_1 VARCHAR2(30) :='';
l_zone_evol_2 VARCHAR2(30) :='';
l_zone_evol_3 VARCHAR2(30) :='';

BEGIN
    -----------------------------------------------------
    -- Init de la trace
    -----------------------------------------------------
    L_RETCOD := Trclog.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE1 );
    IF ( L_RETCOD <> 0 ) THEN
    RAISE_APPLICATION_ERROR( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 FALSE );
    END IF;
    -----------------------------------------------------
    -- Trace Start
    -----------------------------------------------------
    Trclog.Trclog( L_HFILE1, 'Debut de ' || L_PROCNAME );

     L_STATEMENT := 'ECRITURE DANS LE FICHIER POUR SMS : début';
     Trclog.Trclog( L_HFILE1, L_STATEMENT );

     L_STATEMENT := 'Init du fichier de sortie : ' || p_chemin_fichier || '/' || p_nom_fichier || '.txt';
     Trclog.Trclog( L_HFILE1, L_STATEMENT );
     Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier , l_hfile);

     --Nombre de lignes total du fichier y compris la ligne d'entête
     SELECT COUNT(*)+1 INTO l_nbenreg
     FROM vue_immo;
     -- Entête du fichier
     Pack_Global.WRITE_STRING(    l_hfile,
                            '1'        ||l_separateur||
                            ' '        ||l_separateur||
                            'IEC'    ||l_separateur||
                            'A0374' ||l_separateur||
                            TO_NUMBER(TO_CHAR(SYSDATE,'yyyymmdd'))||l_separateur||
                            TO_NUMBER(TO_CHAR(SYSDATE,'HH24MISS'))    ||l_separateur||
                            l_nbenreg
                        );

     -- Corps du fichier
     --Parcourir la vue vue_immo
     FOR ligne IN cur_immo LOOP

          Pack_Global.WRITE_STRING(    l_hfile,
                            ligne.TYPE_ENREG    ||l_separateur||
                            ligne.ORIGINE        ||l_separateur||
                            ligne.ENTITE_PROJET    ||l_separateur||
                            ligne.PROJET        ||l_separateur||
                            ligne.COMPOSANT        ||l_separateur||
                            ligne.CADA            ||l_separateur||
                            ligne.ANNEE            ||l_separateur||
                            ligne.MOIS            ||l_separateur||
                            ligne.TYPE_MONTANT    ||l_separateur||
                            ligne.MONTANT        ||l_separateur||
                            ligne.SENS            ||l_separateur||
                            ligne.DEVISE        ||l_separateur||
                            ligne.CAFI            ||l_separateur||
                            l_zone_evol_1        ||l_separateur||
                            l_zone_evol_2        ||l_separateur||
                            l_zone_evol_3
                        );



     END LOOP;


     L_STATEMENT := 'FIN ECRITURE DANS LE FICHIER IMMO';
    Trclog.Trclog( L_HFILE1, L_STATEMENT );
    L_STATEMENT := '-> '||l_nbenreg ||' lignes créées dans le fichier IMMO';
    Trclog.Trclog( L_HFILE1, L_STATEMENT );
    Pack_Global.CLOSE_WRITE_FILE(l_hfile);

    -----------------------------------------------------
    -- Trace Stop
    -----------------------------------------------------
    Trclog.Trclog( L_HFILE1, 'Fin normale de ' || L_PROCNAME  );
    Trclog.CLOSETRCLOG( L_HFILE1 );

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE <> CALLEE_FAILED_ID AND SQLCODE <> TRCLOG_FAILED_ID THEN
                Trclog.Trclog( L_HFILE1, L_PROCNAME || ' : ' || SQLERRM );
            END IF;
            IF SQLCODE <> TRCLOG_FAILED_ID THEN
                Trclog.Trclog( L_HFILE1, 'Fin ANORMALE de ' || L_PROCNAME  );
                Trclog.CLOSETRCLOG( L_HFILE1 );
                RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         FALSE );
            ELSE
                RAISE;
            END IF;

END immo;

--Procedure dupliqué pour test en parrallèle
PROCEDURE immo2( P_LOGDIR          IN VARCHAR2,
                  p_chemin_fichier  IN VARCHAR2,
                p_nom_fichier_sms     IN VARCHAR2,
                p_nom_fichier_expense     IN VARCHAR2
              ) IS


L_RETCOD    NUMBER;
L_PROCNAME  VARCHAR2(16) := 'IMMO';
L_HFILE1    UTL_FILE.FILE_TYPE;
L_STATEMENT VARCHAR2(128);
l_hfile     UTL_FILE.FILE_TYPE;
l_separateur CHAR(1) := ';';
l_nbenreg      NUMBER(15);
l_zone_evol_1 VARCHAR2(30) :='';
l_zone_evol_2 VARCHAR2(30) :='';
l_zone_evol_3 VARCHAR2(30) :='';

--########################################
-- Curseur ramenant les immos encours SMS
--########################################
CURSOR cur_immo_SMS IS
select
           2                                                    type_enreg,
        'BIP'                                                origine,
        'P7090'                                              entite_projet,
        s.icpi                                               projet,
        '0BIPIAS'                                            composant,
        s.cada                                               cada,
        to_char(d.datdebex,'YYYY')                           annee,
        to_char(d.moismens,'MM')                             mois,
        'P'                                                  type_montant,
        to_char(abs(sum(s.a_consoft)),'FM999999999990.00')   montant,
        decode(sign(sum(s.a_consoft)),-1,'C',1,'D')          sens,
        'EUR'                                                devise,
        s.cafi                                               cafi
from stock_immo s,
     datdebex d,
     struct_info si,
     directions d
where soccode<>'SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
and s.a_consoft <> 0
and d.syscompta = 'SMS'
group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada
having sum(a_consoft)<>0
UNION
-- Charges salariales SSII
select
      2                                                             type_enreg,
      'BIP'                                                         origine,
      'P7090'                                                         entite_projet,
      s.icpi                                                        projet,
      '0BIPIAS'                                                     composant,
      s.cada                                                        cada,
      to_char(d.datdebex,'YYYY')                                     annee,
      to_char(d.moismens,'MM')                                         mois,
      'C'                                                             type_montant,
      to_char(abs(sum(a_consoft*(t.taux/100))),'FM999999999990.00') montant,
      decode(sign(sum(s.a_consoft)),-1,'C',1,'D')                     sens,
      'EUR'                                                         devise,
      s.cafi                                                        cafi
from stock_immo s,
     taux_charge_salariale t,
     datdebex d,
     struct_info si,
     directions d
where
t.annee = to_number(to_char(d.datdebex,'YYYY'))
and soccode='SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
and d.syscompta = 'SMS'
group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada
having sum(a_consoft)<>0
UNION
--salaires SG
select
      2                                                                        type_enreg,
      'BIP'                                                                    origine,
      'P7090'                                                                    entite_projet,
      s.icpi                                                                   projet,
      '0BIPIAS'                                                                composant,
      s.cada                                                                   cada,
      to_char(d.datdebex,'YYYY')                                                annee,
      to_char(d.moismens,'MM')                                                    mois,
      'S'                                                                        type_montant,
      to_char(abs(sum(s.a_consoft*((100-taux)/100))),'FM999999999990.00')   montant,
      decode(sign(sum(s.a_consoft)),-1,'C',1,'D')                             sens,
      'EUR'                                                                 devise,
      s.cafi                                                                cafi
from stock_immo s,
     taux_charge_salariale t,
     datdebex d,
     struct_info si,
     directions d
where
t.annee = to_number(to_char(d.datdebex,'YYYY'))
and soccode='SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
and d.syscompta = 'SMS'
group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada
having sum(a_consoft)<>0 ;



--########################################
-- Curseur ramenant les immos encours EXP
--########################################
CURSOR cur_immo_EXPENSE IS
select
           2                                                    type_enreg,
        'BIP'                                                origine,
        'P7090'                                              entite_projet,
        s.icpi                                               projet,
        '0BIPIAS'                                            composant,
        s.cada                                               cada,
        to_char(d.datdebex,'YYYY')                           annee,
        to_char(d.moismens,'MM')                             mois,
        'P'                                                  type_montant,
        to_char(abs(sum(s.a_consoft)),'FM999999999990.00')   montant,
        decode(sign(sum(s.a_consoft)),-1,'C',1,'D')          sens,
        'EUR'                                                devise,
        s.cafi                                               cafi,
        perim.codperim                                      perimetre_cafi
 from stock_immo s,
     datdebex d,
     struct_info si,
     directions d,
    (select distinct d.codperim, si.cafi
           from struct_info si, directions d
          where
           si.topfer = 'O'
           and si.coddir = d.coddir

       ) perim
where soccode<>'SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
and s.a_consoft <> 0
and d.syscompta = 'EXP'
and perim.cafi = s.cafi
group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada, perim.codperim
having sum(a_consoft)<>0
UNION
-- Charges salariales SSII
select
      2                                                             type_enreg,
      'BIP'                                                         origine,
      'P7090'                                                         entite_projet,
      s.icpi                                                        projet,
      '0BIPIAS'                                                     composant,
      s.cada                                                        cada,
      to_char(d.datdebex,'YYYY')                                     annee,
      to_char(d.moismens,'MM')                                         mois,
      'C'                                                             type_montant,
      to_char(abs(sum(a_consoft*(t.taux/100))),'FM999999999990.00') montant,
      decode(sign(sum(s.a_consoft)),-1,'C',1,'D')                     sens,
      'EUR'                                                         devise,
      s.cafi                                                        cafi,
       perim.codperim                                      perimetre_cafi

from stock_immo s,
     taux_charge_salariale t,
     datdebex d,
     struct_info si,
     directions d,
    (select distinct d.codperim, si.cafi
           from struct_info si, directions d
          where
           si.topfer = 'O'
           and si.coddir = d.coddir

       ) perim
where
t.annee = to_number(to_char(d.datdebex,'YYYY'))
and soccode='SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
and d.syscompta = 'EXP'
and perim.cafi = s.cafi
group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada, perim.codperim
having sum(a_consoft)<>0
UNION
--salaires SG
select
      2                                                                        type_enreg,
      'BIP'                                                                    origine,
      'P7090'                                                                    entite_projet,
      s.icpi                                                                   projet,
      '0BIPIAS'                                                                composant,
      s.cada                                                                   cada,
      to_char(d.datdebex,'YYYY')                                                annee,
      to_char(d.moismens,'MM')                                                    mois,
      'S'                                                                        type_montant,
      to_char(abs(sum(s.a_consoft*((100-taux)/100))),'FM999999999990.00')   montant,
      decode(sign(sum(s.a_consoft)),-1,'C',1,'D')                             sens,
      'EUR'                                                                 devise,
      s.cafi                                                                cafi,
       perim.codperim                                      perimetre_cafi
from stock_immo s,
     taux_charge_salariale t,
     datdebex d,
     struct_info si,
     directions d,
    (select distinct d.codperim, si.cafi
           from struct_info si, directions d
          where
           si.topfer = 'O'
           and si.coddir = d.coddir

       ) perim
where
t.annee = to_number(to_char(d.datdebex,'YYYY'))
and soccode='SG..'
and s.CODSGRESS = si.CODSG
and si.coddir = d.CODDIR
and d.syscompta = 'EXP'
and perim.cafi = s.cafi
group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada, perim.codperim
having sum(a_consoft)<>0    ;




BEGIN


    -----------------------------------------------------
    -- Init de la trace
    -----------------------------------------------------
    L_RETCOD := Trclog.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE1 );
    IF ( L_RETCOD <> 0 ) THEN
    RAISE_APPLICATION_ERROR( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 FALSE );
    END IF;
    -----------------------------
    --DEBUT PARTIE CONCERNANT SMS
    -----------------------------
    -----------------------------------------------------
    -- Trace Start
    -----------------------------------------------------
    Trclog.Trclog( L_HFILE1, 'Debut de ' || L_PROCNAME );

     L_STATEMENT := 'ECRITURE DANS LE FICHIER POUR SMS : début';
     Trclog.Trclog( L_HFILE1, L_STATEMENT );

     L_STATEMENT := 'Init du fichier de sortie : ' || p_chemin_fichier || '/' || p_nom_fichier_sms || '.txt';
     Trclog.Trclog( L_HFILE1, L_STATEMENT );
     Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier_sms , l_hfile);

     --Nombre de lignes total du fichier y compris la ligne d'entête pour SMS
     SELECT COUNT(*)+1 INTO l_nbenreg
     FROM (select
               s.icpi, s.cada, to_char(d.datdebex,'YYYY'), to_char(d.moismens,'MM'),
               to_char(abs(sum(s.a_consoft)),'FM999999999990.00'), decode(sign(sum(s.a_consoft)),-1,'C',1,'D'),
                s.cafi
            from stock_immo s, datdebex d, struct_info si, directions d
            where soccode<>'SG..' and s.CODSGRESS = si.CODSG and si.coddir = d.CODDIR and s.a_consoft <> 0
                and d.syscompta = 'SMS'
            group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada
            having sum(a_consoft)<>0
            UNION
            -- Charges salariales SSII
            select
             s.icpi, s.cada, to_char(d.datdebex,'YYYY'), to_char(d.moismens,'MM'), to_char(abs(sum(a_consoft*(t.taux/100))),'FM999999999990.00'),
            decode(sign(sum(s.a_consoft)),-1,'C',1,'D') , s.cafi
            from stock_immo s, taux_charge_salariale t, datdebex d, struct_info si, directions d
            where t.annee = to_number(to_char(d.datdebex,'YYYY')) and soccode='SG..' and s.CODSGRESS = si.CODSG
            and si.coddir = d.CODDIR and d.syscompta = 'SMS'
            group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada
            having sum(a_consoft)<>0
            UNION
            --salaires SG
            select
            s.icpi, s.cada, to_char(d.datdebex,'YYYY'), to_char(d.moismens,'MM'), to_char(abs(sum(s.a_consoft*((100-taux)/100))),'FM999999999990.00'),
            decode(sign(sum(s.a_consoft)),-1,'C',1,'D'), s.cafi
            from stock_immo s, taux_charge_salariale t, datdebex d, struct_info si, directions d
            where
            t.annee = to_number(to_char(d.datdebex,'YYYY')) and soccode='SG..' and s.CODSGRESS = si.CODSG and si.coddir = d.CODDIR
            and d.syscompta = 'SMS'
            group by s.icpi,s.cafi, d.datdebex, d.moismens,s.cada
            having sum(a_consoft)<>0  );


     -- Entête du fichier
     Pack_Global.WRITE_STRING(    l_hfile,
                            '1'        ||l_separateur||
                            ' '        ||l_separateur||
                            'IEC'    ||l_separateur||
                            'A0374' ||l_separateur||
                            TO_NUMBER(TO_CHAR(SYSDATE,'yyyymmdd'))||l_separateur||
                            TO_NUMBER(TO_CHAR(SYSDATE,'HH24MISS'))    ||l_separateur||
                            l_nbenreg
                        );

     -- Corps du fichier
     --Parcourir la vue vue_immo
     FOR ligne IN cur_immo_SMS LOOP

          Pack_Global.WRITE_STRING(    l_hfile,
                            ligne.TYPE_ENREG    ||l_separateur||
                            ligne.ORIGINE        ||l_separateur||
                            ligne.ENTITE_PROJET    ||l_separateur||
                            ligne.PROJET        ||l_separateur||
                            ligne.COMPOSANT        ||l_separateur||
                            ligne.CADA            ||l_separateur||
                            ligne.ANNEE            ||l_separateur||
                            ligne.MOIS            ||l_separateur||
                            ligne.TYPE_MONTANT    ||l_separateur||
                            ligne.MONTANT        ||l_separateur||
                            ligne.SENS            ||l_separateur||
                            ligne.DEVISE        ||l_separateur||
                            ligne.CAFI            ||l_separateur||
                            l_zone_evol_1        ||l_separateur||
                            l_zone_evol_2        ||l_separateur||
                            l_zone_evol_3
                        );



     END LOOP;


     L_STATEMENT := 'FIN ECRITURE DANS LE FICHIER SMS';
    Trclog.Trclog( L_HFILE1, L_STATEMENT );
    L_STATEMENT := '-> '||l_nbenreg ||' lignes créées dans le fichier SMS';
    Trclog.Trclog( L_HFILE1, L_STATEMENT );
    Pack_Global.CLOSE_WRITE_FILE(l_hfile);

    ---------------------------
    --FIN PARTIE CONCERNANT SMS
    ---------------------------
    -----------------------------
    --DEBUT PARTIE CONCERNANT EXPENSE
    -----------------------------
    L_STATEMENT := 'ECRITURE DANS LE FICHIER POUR EXPENSE : début';
     Trclog.Trclog( L_HFILE1, L_STATEMENT );

     L_STATEMENT := 'Init du fichier de sortie : ' || p_chemin_fichier || '/' || p_nom_fichier_expense || '.txt';
     Trclog.Trclog( L_HFILE1, L_STATEMENT );
     Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier_expense , l_hfile);

     --Nombre de lignes total du fichier calcule dans la boucle for
    l_nbenreg := 0;

     -- Corps du fichier
     --Parcourir la vue vue_immo
     FOR ligne IN cur_immo_EXPENSE LOOP

          Pack_Global.WRITE_STRING(    l_hfile,
                            ligne.TYPE_ENREG    ||l_separateur||
                            ligne.ORIGINE        ||l_separateur||
                            ligne.ENTITE_PROJET    ||l_separateur||
                            ligne.PROJET        ||l_separateur||
                            ligne.COMPOSANT        ||l_separateur||
                            ligne.CADA            ||l_separateur||
                            ligne.ANNEE            ||l_separateur||
                            ligne.MOIS            ||l_separateur||
                            ligne.TYPE_MONTANT    ||l_separateur||
                            ligne.MONTANT        ||l_separateur||
                            ligne.SENS            ||l_separateur||
                            ligne.DEVISE        ||l_separateur||
                            ligne.CAFI            ||l_separateur||
                            ligne.perimetre_cafi
                        );


        l_nbenreg := l_nbenreg + 1;
     END LOOP;


     L_STATEMENT := 'FIN ECRITURE DANS LE FICHIER EXPENSE';
    Trclog.Trclog( L_HFILE1, L_STATEMENT );
    L_STATEMENT := '-> '||l_nbenreg ||' lignes créées dans le fichier EXPENSE';
    Trclog.Trclog( L_HFILE1, L_STATEMENT );
    Pack_Global.CLOSE_WRITE_FILE(l_hfile);

    -------------------------------
    --FIN PARTIE CONCERNANT EXPENSE
    -------------------------------


    -----------------------------------------------------
    -- Trace Stop
    -----------------------------------------------------
    Trclog.Trclog( L_HFILE1, 'Fin normale de ' || L_PROCNAME  );
    Trclog.CLOSETRCLOG( L_HFILE1 );

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE <> CALLEE_FAILED_ID AND SQLCODE <> TRCLOG_FAILED_ID THEN
                Trclog.Trclog( L_HFILE1, L_PROCNAME || ' : ' || SQLERRM );
            END IF;
            IF SQLCODE <> TRCLOG_FAILED_ID THEN
                Trclog.Trclog( L_HFILE1, 'Fin ANORMALE de ' || L_PROCNAME  );
                Trclog.CLOSETRCLOG( L_HFILE1 );
                RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         FALSE );
            ELSE
                RAISE;
            END IF;

END immo2;
--*************************************************************
-- Procédure qui écrit dans un fichier le mois de la mensuelle
--************************************************************
    PROCEDURE DATRAIT(   P_LOGDIR          IN VARCHAR2,
                          p_chemin_fichier  IN VARCHAR2,
                          p_nom_fichier     IN VARCHAR2
                        ) IS

        L_RETCOD    NUMBER;
        L_PROCNAME  VARCHAR2(16) := 'DATRAIT';
        L_HFILE1    UTL_FILE.FILE_TYPE;
        L_STATEMENT VARCHAR2(128);
        l_hfile2      UTL_FILE.FILE_TYPE;
        l_moismens    VARCHAR2(6);

    BEGIN
    -----------------------------------------------------
    -- Init de la trace
    -----------------------------------------------------
    L_RETCOD := Trclog.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE1 );
    IF ( L_RETCOD <> 0 ) THEN
    RAISE_APPLICATION_ERROR( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 FALSE );
    END IF;
    -----------------------------------------------------
    -- Trace Start
    -----------------------------------------------------
    Trclog.Trclog( L_HFILE1, 'Debut de ' || L_PROCNAME );

    L_STATEMENT := 'Recuperation de la date de la derniere mensuelle';
    SELECT  TO_CHAR(moismens,'mmyyyy')  INTO  l_moismens FROM   DATDEBEX;
    Trclog.Trclog( L_HFILE1, L_STATEMENT || ' : ' || l_moismens );

    L_STATEMENT := 'Init du fichier de sortie : ' || p_chemin_fichier || '/' || p_nom_fichier;
    Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile2);
    Trclog.Trclog( L_HFILE1, L_STATEMENT );

    L_STATEMENT := 'Ecriture date derniere mensuelle dans fichier de sortie';
    Trclog.Trclog( L_HFILE1, L_STATEMENT );
    Pack_Global.WRITE_STRING( l_hfile2, l_moismens  );

    L_STATEMENT := 'Fermeture du fichier de sortie : ' || p_chemin_fichier || '/' || p_nom_fichier;
    Pack_Global.CLOSE_WRITE_FILE(l_hfile2);
    Trclog.Trclog( L_HFILE1, L_STATEMENT );

    Trclog.Trclog( L_HFILE1, 'Fin NORMALE de ' || L_PROCNAME);

    EXCEPTION
        WHEN OTHERS THEN
             IF UTL_FILE.IS_OPEN(l_hfile2) THEN
                Pack_Global.CLOSE_WRITE_FILE(l_hfile2);
            END IF;
            IF SQLCODE <> CALLEE_FAILED_ID THEN
                Trclog.Trclog( L_HFILE1, L_PROCNAME ||
                                               ' [' || L_STATEMENT ||
                               '] : ' || SQLERRM );
            END IF;
            Trclog.Trclog( L_HFILE1, 'Fin ANORMALE de ' ||
                                                L_PROCNAME  );
            RAISE CALLEE_FAILED;
    END DATRAIT;



    PROCEDURE appli_profil_fi(P_HFILE  IN UTL_FILE.FILE_TYPE)  IS

        CURSOR C_STOCK_FI IS
            SELECT s.*
            FROM STOCK_FI s, datdebex d
            WHERE TO_CHAR(s.cdeb,'YYYY')= TO_CHAR(d.moismens,'YYYY') ;
   
      
        T_STOCK_FI C_STOCK_FI%ROWTYPE;

        l_cout NUMBER(12,2);
      	l_cout_env NUMBER(12,2);
        l_profil_fi VARCHAR2(12);
      	l_type_profil NUMBER;
        l_param_appli VARCHAR2(200);

        L_PROCNAME  VARCHAR2(16) := 'APPLI_PROFIL_FI';
        L_STATEMENT VARCHAR2(128);
        
     BEGIN

          Trclog.Trclog( P_HFILE, 'Debut de ' || L_PROCNAME );

        -- ---------------------------------------------------------------------------------------------------
        -- Etape préliminaire : Suppression de toutes les lignes de la table Historique: HISTO_RESS_PROFIL_FI
        -- ---------------------------------------------------------------------------------------------------
        L_STATEMENT := '* Suppression des lignes de la table HISTO_RESS_PROFIL_FI';
        Trclog.Trclog( P_HFILE, L_STATEMENT );
        PACKBATCH.DYNA_TRUNCATE('HISTO_RESS_PROFIL_FI');
        
      

        OPEN C_STOCK_FI;

            -- --------------------------------------------------------------------------
            -- Parcours de la table STOCK_FI
            -- --------------------------------------------------------------------------
            L_STATEMENT := 'Parcours de la table STOCK_FI';
            Trclog.Trclog( P_HFILE, L_STATEMENT );

            LOOP

                FETCH C_STOCK_FI INTO T_STOCK_FI;
                IF C_STOCK_FI%NOTFOUND THEN
                    EXIT;
                END IF;
                
               PACK_UTILE_COUT.CALCUL_COUT_FI(T_STOCK_FI.CODSGRESS , T_STOCK_FI.CAFI, T_STOCK_FI.PRESTATION , T_STOCK_FI.IDENT, TO_CHAR(T_STOCK_FI.CDEB,'DD/MM/YYYY') , T_STOCK_FI.SOCCODE, T_STOCK_FI.RTYPE, T_STOCK_FI.METIER, T_STOCK_FI.NIVEAU, T_STOCK_FI.CODCAMO, l_type_profil, l_profil_fi , l_cout, l_cout_env);
                    
			-- Si DomFonc - 2 / prifile localize - 3
				IF(l_type_profil = 2 OR l_type_profil = 3) THEN
                    -- Mise à jour Stock_fi
                    -- --------------------------------------------------------------------------
                    -- Mise à jour des Coûts et PROFIL_FI de la table STOCK_FI
                    -- --------------------------------------------------------------------------
           
                                  
                    UPDATE STOCK_FI SET
                      COUTFT = l_cout,
                      COUTENV = l_cout_env,
                      COUTFTHT = 0,
                      CONSOFT = l_cout * NCONSOJHIMMO,
                      -- QC 1594
                      CONSOENVIMMO = l_cout_env * CONSOJHIMMO,
                      NCONSOENVIMMO = l_cout_env * NCONSOJHIMMO,
                      --
                      PROFIL_FI = l_profil_fi
                    WHERE
                      CDEB = T_STOCK_FI.CDEB
                      AND PID = T_STOCK_FI.PID
                      AND IDENT = T_STOCK_FI.IDENT
                      AND CODCAMO = T_STOCK_FI.CODCAMO
                      AND CAFI = T_STOCK_FI.CAFI;

                    -- --------------------------------------------------------------------------
                    -- Insertion des données dans la table HISTO_RESS_PROFIL_FI (Ressource/Mois)
                    -- --------------------------------------------------------------------------
                    INSERT INTO HISTO_RESS_PROFIL_FI
                                (
                                MOISPREST ,
                                IDENT ,
                                PROFIL_FI,
                                PID, --PPM 58225 
                                CODCAMO
                                )
                            VALUES
                                (
                                T_STOCK_FI.CDEB ,
                                T_STOCK_FI.IDENT ,
                                l_profil_fi,
                                T_STOCK_FI.PID, --PPM 58225 
                                T_STOCK_FI.CODCAMO
                                );

                ELSIF(NVL(l_profil_fi,'-1') != 'STANDARD') THEN

                    -- Mise à jour Stock_fi
                    -- --------------------------------------------------------------------------
                    -- Mise à jour des Coûts et PROFIL_FI de la table STOCK_FI
                    -- --------------------------------------------------------------------------
              
                    UPDATE STOCK_FI SET
                      COUTFT = l_cout,
                      COUTFTHT = 0,
                      CONSOFT = l_cout * NCONSOJHIMMO,
                      PROFIL_FI = l_profil_fi
                    WHERE
                      CDEB = T_STOCK_FI.CDEB
                      AND PID = T_STOCK_FI.PID
                      AND IDENT = T_STOCK_FI.IDENT
                      AND CODCAMO = T_STOCK_FI.CODCAMO
                      AND CAFI = T_STOCK_FI.CAFI;

                    -- --------------------------------------------------------------------------
                    -- Insertion des données dans la table HISTO_RESS_PROFIL_FI (Ressource/Mois)
                    -- --------------------------------------------------------------------------
                    INSERT INTO HISTO_RESS_PROFIL_FI
                                (
                                MOISPREST ,
                                IDENT ,
                                PROFIL_FI,
                                PID, --PPM 58225 
                                CODCAMO
                                )
                            VALUES
                                (
                                T_STOCK_FI.CDEB ,
                                T_STOCK_FI.IDENT ,
                                l_profil_fi,
                                T_STOCK_FI.PID, --PPM 58225 
                                T_STOCK_FI.CODCAMO
                                );
                    -- --------------------------------------------------------------------------

                ELSE

                   -- Mise à jour Stock_fi
                   -- -----------------------------------------------------------------------------
                   -- Mise à jour des PROFIL_FI de la table STOCK_FI dans le CAS STANDARD
                   -- -----------------------------------------------------------------------------

                   UPDATE STOCK_FI SET
                     PROFIL_FI = 'STANDARD'
                     
                   WHERE
                     CDEB = T_STOCK_FI.CDEB
                     AND PID = T_STOCK_FI.PID
                     AND IDENT = T_STOCK_FI.IDENT
                     AND CODCAMO = T_STOCK_FI.CODCAMO
                     AND CAFI = T_STOCK_FI.CAFI;

                    -- ----------------------------------------------------------------------------------------------
                    -- Insertion des données dans la table HISTO_RESS_PROFIL_FI (Ressource/Mois) Profil_fi = STANDARD
                    -- ----------------------------------------------------------------------------------------------

                    l_profil_fi := 'STANDARD';
                   INSERT INTO HISTO_RESS_PROFIL_FI
                                (
                                MOISPREST ,
                                IDENT ,
                                PROFIL_FI,
                                PID, --PPM 58225 
                                CODCAMO
                                )
                            VALUES
                                (
                                T_STOCK_FI.CDEB ,
                                T_STOCK_FI.IDENT ,
                                l_profil_fi,
                                T_STOCK_FI.PID, --PPM 58225 
                                T_STOCK_FI.CODCAMO 
                                );
                    -- --------------------------------------------------------------------------

                END IF;

            END LOOP;

        CLOSE C_STOCK_FI;
        COMMIT;
        L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes mise à jour dans la table STOCK_FI';
        Trclog.Trclog( P_HFILE, L_STATEMENT );
        Trclog.Trclog( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);


    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE <> CALLEE_FAILED_ID THEN
                    Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
            END IF;
            Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
            RAISE CALLEE_FAILED;
    END appli_profil_fi;

END Packbatch_Ias;
/

