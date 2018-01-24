-- Application REFONTE BIP
-- Package BATCH 2
-- --------------------------------------

-- ---------------------------------------
-- Quand      Qui   Quoi
-- ---------------------------------------
-- 12/07/99   SOPRA Livraison Lot 1
-- 09/06/2000 QHL   modif de shu4 suite aux pb d'insertion de nouvelles lignes bip
-- 28/07/2000 QHL   Modif de DEBFINTRAIT en ajout un update de deux nouvelles zones dans datdebex
--                  qui sont moismens (mois du mensuel) et moismens_nbjo (nb jour ouvre de ce mois)
-- 06/11/2001 NBM   remplacement de la table cout_prestation par la table prestation
-- 16/11/2001 NBM : les champs pobjet01 à pobjet05 sont remplacés par le champ pobjet multiligne dans la table LIGNE_BIP2
-- 15/05/2002 OTO   mise a jour de la table consomme et suppression de la mise a jour de budcons
-- 22/03/2004 MMC : on ne prend pas en compte les consommés des ressources STA INT IFO
-- 30/01/2004 PJO : Suppression des références à CUMUL_AN et CUMUL_MOIS et suppression de la méthode BUDCONSMAJ
-- 06/10/2004 JMA : ajout d'une actualité dans DEBFINTRAIT indiquant qu'un traitement est en cours
-- 01/06/2006 PPR : modification du message de l'actualite dans DEBFINTRAIT en indiquant si c'est une prémensuelle
-- 06/11/2009 YSB : modification de la procédure ADD_ACTUALITE : le message d'actualité sera affiché pendant 5 jours au lieu de 3 jours
-- 23/11/2009 YNI : modification de la procédure ADD_ACTUALITE : le message d'actualité sera affiché pendant 5 jours au lieu de 3 jours
-- 18/05/2010 ABA : fiche 1013
-- 15/06/2010 ABA fiche 1010
-- 14/02/2011 CMA : Fiche 1101
-- ---------------------------------------
-- MODIF : RPMOISU devient un shell
--

-- ---------------------------------------------------------
-- Environement temporaire de developpement
-- sera ensuite integré dans le package PACKBATCH
-- ---------------------------------------------------------
CREATE OR REPLACE package PACKBATCH2 as

    -- Existe deja dans PACKBATCH.
    -- Utilitaire : calcul du mois et de l'année de traitement
    -- en cours, non pas d'après la date système, mais d'après
    -- la date de la prochaine mensuelle
    -- -------------------------------------------------------
    procedure CALCDATTRT( P_HFILE in utl_file.file_type,
                          P_MOISTRT out number,
                          P_ANTRT   out number );

    -- Utilitaire : calcul de la date de début d'exercice
    -- --------------------------------------------------
--    procedure CALCDATDBX( P_HFILE in utl_file.file_type,
--                          P_DATDBX out date );

    -- A procedure de la mensuelle
    -- -----------------------------------

    -- Procedure appeller par le shell pour la mensuelle
    -- --------------------------------------
    procedure ST54702F( P_LOGDIR in varchar2 );

      -- Procedure lancée par le shell pour le chargement de
      -- la table centre d'activité
      ------------------------------------------------------
   procedure ST54702K( P_LOGDIR in varchar2 );


      -- Copie ligne_bip et etape dans ligne_bip2 et etape2
      -- --------------------------------------------------
    procedure ST54700G( P_LOGDIR in varchar2 );


      -- Procédure pour le message de début et de bonne fin
      -- --------------------------------------------------
    procedure DEBFINTRAIT( P_LOGDIR in varchar2, P_TYPE_MSG in varchar2 );


    -- Change la date de la prochaine mensuelle
    -- --------------------------
    procedure RPMOISU(P_LOGDIR in varchar2 );

    -- Genere l'historique par projet (prise en compte de la sous-traitance)
    -- -------------------------
    procedure PROHISB(P_HFILE in utl_file.file_type);

    -- Maj des centres d'activite et maitrise d'ouvrage
    -- -------------------------
    procedure CHARGCAM(P_HFILE in utl_file.file_type);

    -- Copie ligne_bip et etape dans ligne_bip2 et etape2
    -- -------------------------
    procedure COPIE_BIP_BIP2(P_HFILE in utl_file.file_type);

    -- Ecriture du message de début fin des batchs
    -- -------------------------
      procedure ECRITURE_MESSAGE(P_HFILE in utl_file.file_type, P_TYPE_MSG in varchar2 );

    -- Maj de consomme
    -- -------------------------
    PROCEDURE Alim_conso(P_HFILE in utl_file.file_type);

    -- Ajout d'une actualité pour indiqué qu'un traitement est en cours
    -- -------------------------
    procedure ADD_ACTUALITE(p_position in varchar2 );

end PACKBATCH2;
/


CREATE OR REPLACE package body     PACKBATCH2 as

    -- Gestions exceptions
    -- -------------------

    CALLEE_FAILED exception;
    pragma exception_init( CALLEE_FAILED, -20000 );
    CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
    TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !
    ERR_FONCTIONNELLE_ID number := -20002;   -- pour provoquer erreur alors que Oracle OK
    CONSTRAINT_VIOLATION exception;          -- pour clause when
    pragma exception_init( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère

    -- Dates Globales pour utilisation dans fonctions
    -- appelées en SQL. Oracle Corp. N'est PAS
    -- composée de Dieux vivants. PL/SQL a été codé
    -- par des gens normaux. Il y a des bugs.
    -- C'est pas (trés) grave, on contourne.
    -- ----------------------------------------------
    G_DAT0101AN date;            -- le 01/01 de l'année de l'exercice
    G_DAT0101ANM1 date;          -- le 01/01 de l'année d'avant celle de l'exercice

    -- ------------------------------------------------
    -- Copier/Coller/Modifier de l'exemple 'drop_table'
    -- de la documentation en ligne de PL/SQL dans
    -- Interaction with Oracle : using DLL and
    -- dynamic SQL
    -- ------------------------------------------------
    procedure DYNA_TRUNCATE( TABLENAME IN VARCHAR2 ) is

        CID integer;

    begin

        -- Open new cursor and return cursor ID.
        -- -------------------------------------
        CID := DBMS_SQL.OPEN_CURSOR;
        -- Parse and immediately execute dynamic SQL statement built by
        -- concatenating table name to command.
        -- ------------------------------------------------------------
        DBMS_SQL.PARSE( CID, 'TRUNCATE TABLE ' || TABLENAME,dbms_sql.v7 );

        -- Close cursor.
        -- -------------
        DBMS_SQL.CLOSE_CURSOR( CID );

    exception

        -- If an exception is raised, close cursor before exiting.
        -- -------------------------------------------------------
        -- note de manuel L : Et si l'exception a lieu pendant le
        -- open ou le close ?
        -- (supposons que LEUR code EST correct)
        -- -------------------------------------------------------
        when others then
            DBMS_SQL.CLOSE_CURSOR( CID );
              raise;  -- reraise the exception

    end DYNA_TRUNCATE;


    -- -----------------------------------------
    -- CALCDATTRT : on calcule le numero du mois
    -- de traitement a partir de la date de la
    -- prochaine mensuelle, qu'on trouve dans
    -- la table DATDEBEX. Le mois de traitement
    -- courant est le mois precedent.
    -- La table DATDEBEX est mis a jour en fin
    -- de mensuelle a l'aide de la table
    -- calendrier et de la date systeme.
    -- -----------------------------------------
    procedure CALCDATTRT( P_HFILE in utl_file.file_type,
                          P_MOISTRT out number,
                          P_ANTRT   out number ) is

        L_DATTRT date;
        L_PROCNAME varchar2( 16 ) := 'CALCDATTRT';

    begin

        -- Recherche de la date de la
        -- ===> PROCHAINE <=== mensuelle
        -- et renvoi du mois, annee du mois
        -- d'avant
        -- ----------------------------------
		--PPM 58896 : utilisation directe du cmensuelle sans soustraire 1 mois.
        select CMENSUELLE
        into L_DATTRT
        from DATDEBEX;
        P_MOISTRT := to_char( L_DATTRT, 'MM' );
        P_ANTRT   := to_char( L_DATTRT, 'YYYY' );

    exception

        when others then
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || SQLERRM );
            raise CALLEE_FAILED;

    end CALCDATTRT;

    -- -----------------------------------------
    -- CALCDATDBX : on rend simplement la date
    -- de debut d'exercice qu'on trouve dans la
    -- table DATDEBEX.
    -- -----------------------------------------
    procedure CALCDATDBX( P_HFILE in utl_file.file_type,
                          P_DATDBX out date ) is

        L_PROCNAME varchar2(16):='CALCDATDBX';

    begin

        select DATDEBEX
        into P_DATDBX
        from DATDEBEX;

    exception

        when others then
            TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || SQLERRM );
            raise CALLEE_FAILED;

    end CALCDATDBX;



    -- MENSUELLE contient :
    -- PROHISB    : vide puis remplit la table hispro
    -- -------------------
    procedure ST54702F( P_LOGDIR in varchar2 ) IS

        L_HFILE utl_file.file_type;
        L_RETCOD number;

        L_PROCNAME varchar2(16) := 'ST54702F';

    begin

        -- Init de la trace
        -- ----------------
        L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
        if ( L_RETCOD <> 0 ) then
        raise_application_error( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 false );
        end if;

        -- Trace Start
        -- -----------
        TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );

        -- Lancement des programmes de la mensuelle
        -- --------------

        PROHISB( L_HFILE  );

        -- Trace Stop
        -- ----------
        TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
        TRCLOG.CLOSETRCLOG( L_HFILE );

    exception

        when others then
            rollback;
            if sqlcode <> CALLEE_FAILED_ID and
               sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( L_HFILE, L_PROCNAME || ' : ' || SQLERRM );
            end if;
            if sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
                TRCLOG.CLOSETRCLOG( L_HFILE );
                raise_application_error( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         false );
            else
                raise;
            end if;

    end ST54702F;


    -- Change la date de la prochaine mensuelle
    -- MAJ de DATDEBEX
    -- --------------------------
        procedure RPMOISU (P_LOGDIR in varchar2 ) IS

       L_HFILE utl_file.file_type;
       L_RETCOD number;
       L_PROCNAME varchar2(16) := 'RPMOISU';
       L_STATEMENT varchar2(64);
	   l_moismens date;--PPM 58896

    BEGIN

       -- Init de la trace
       -- ----------------
       L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
       if ( L_RETCOD <> 0 ) then
          raise_application_error( TRCLOG_FAILED_ID,
                       'Erreur : Gestion du fichier LOG impossible',
                       false );
       end if;

       -- Trace Start
       -- -----------
       TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );

       L_STATEMENT := 'Maj de datdebex';
       -- Recupere la date de la mensuelle pour
       -- le mois courant puis
       -- Maj de CMENSUELLE dans datdebex
       -- ---------
	   --PPM 58896 : ajout de 1 mois a datemens pour maj de cmensuelle.
       select moismens into l_moismens from datdebex;   --PPM 58896
       UPDATE DATDEBEX SET (CMENSUELLE) =
         (SELECT CMENSUELLE
          FROM   calendrier
          WHERE  trunc(CALANMOIS, 'MONTH') = trunc(ADD_MONTHS(l_moismens,1),'MONTH')
          );--PPM 58896
       TRCLOG.TRCLOG( L_HFILE, L_STATEMENT ||'-'||sql%rowcount);
       commit;

       TRCLOG.TRCLOG( L_HFILE, 'Fin NORMALE de ' || L_PROCNAME );

       -- Trace Stop
       -- ----------
       TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
       TRCLOG.CLOSETRCLOG( L_HFILE );

    exception

       when others then
         rollback;
         if sqlcode <> CALLEE_FAILED_ID and
           sqlcode <> TRCLOG_FAILED_ID then
        TRCLOG.TRCLOG( L_HFILE, L_PROCNAME || ' : ' || SQLERRM );
         end if;
         if sqlcode <> TRCLOG_FAILED_ID then
        TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        TRCLOG.CLOSETRCLOG( L_HFILE );
        raise_application_error( CALLEE_FAILED_ID,
                     'Erreur : consulter le fichier LOG',
                     false );
         else
        raise;
         end if;

    end RPMOISU;


--
-- Procedure de mise a jour de la table consomme
--

    PROCEDURE Alim_conso(P_HFILE in utl_file.file_type)
    IS

    L_PROCNAME varchar2(16) := 'Alim_conso';
    L_STATEMENT varchar2(64);

    l_annee integer;
    BEGIN

    -- initialisation de la variable locale l_annee

        select to_number(to_char(datdebex,'YYYY')) into l_annee from datdebex;

    -- insertion dans la table consomme des lignes bip inexistantes pour l'année courante et l'année N-1

    L_STATEMENT:='Lignes BIP inexistantes annee N';

        INSERT INTO CONSOMME (annee,pid,cusag,xcusag)
        (SELECT l_annee,
            lb.pid,
            0,
            0
         FROM ligne_bip lb
         WHERE NOT EXISTS (SELECT pid from consomme where consomme.pid = lb.pid
                                        AND consomme.annee = l_annee));

        COMMIT;

    TRCLOG.TRCLOG( P_HFILE, L_STATEMENT ||':-'||sql%rowcount);


    L_STATEMENT:='Lignes BIP inexistantes annee N-1';

        INSERT INTO CONSOMME (annee,pid,cusag,xcusag)
        (SELECT l_annee-1,
            lb.pid,
            0,
            0
         FROM ligne_bip lb
         WHERE NOT EXISTS (SELECT pid from consomme where consomme.pid = lb.pid
                        AND consomme.annee = l_annee-1));

        COMMIT;


    TRCLOG.TRCLOG( P_HFILE, L_STATEMENT ||':-'||sql%rowcount);


    L_STATEMENT:='Alimentation du consomme : cusag';

    -- alimentation de la table CONSOMME
            UPDATE CONSOMME
            SET cusag = (select nvl(sum(cusag),0) from proplus ,datdebex
                    where cdeb >= datdebex
                    and proplus.factpid = CONSOMME.pid
                    and (qualif not in ('MO','GRA','STA','IFO','INT') OR qualif is null))
            WHERE annee = l_annee
            ;


            COMMIT;


    TRCLOG.TRCLOG( P_HFILE, L_STATEMENT ||':-'||sql%rowcount);



    -- pour alimenter le cumul du consommé d'un pid toutes années confondues on doit faire l'update précédent avant
    -- celui-ci pour la prise en compte du nouveau cusag(cumul pour l'année courante) que l'on va ajouter à xcusag
    -- (cumul total)

    L_STATEMENT:='Alimentation du consomme total';

            UPDATE CONSOMME
            SET xcusag = (select nvl(xcusag,0) from consomme cc
                        where cc.pid = consomme.pid
                        and cc.annee = l_annee-1)
            WHERE annee = l_annee;

            UPDATE CONSOMME
            SET xcusag = nvl(xcusag,0) + nvl(cusag,0)
            WHERE annee = l_annee;

    COMMIT;

    TRCLOG.TRCLOG( P_HFILE, L_STATEMENT ||':-'||sql%rowcount);

    END Alim_conso;



    procedure PROHISB( P_HFILE in utl_file.file_type ) IS

        L_PROCNAME varchar2( 16 ) := 'PROHISB';
        L_STATEMENT varchar2(64);
        L_MOISTRT   number(2);
        L_ANTRT     number(4);

    begin

    TRCLOG.TRCLOG( P_HFILE, 'Début de ' || L_PROCNAME );
    L_STATEMENT := 'Recherche mois de traitement';

    CALCDATTRT( P_HFILE, L_MOISTRT, L_ANTRT );
    TRCLOG.TRCLOG( P_HFILE, 'Traitement au titre du mois ' || L_MOISTRT || ' de ' || L_ANTRT );

--    TRCLOG.TRCLOG( P_HFILE, 'Traitement au titre du mois ' ||
--             trunc(add_months(sysdate,-1),'MONTH') || ' de ' || trunc(add_months(sysdate,-1),'MONTH') );

     -- DELETE ALL ROWS FROM hispro
     -- ------------------

    L_STATEMENT := 'Table hispro vide';
    DYNA_TRUNCATE('hispro');
    commit;

    TRCLOG.TRCLOG( P_HFILE, L_STATEMENT);

    -- INSERT les donnees dans hispro
    -- FACTPDSG, FACTPID, PID, PDSG, TIRES, CDEB, FACTPNO, PNOM, AISTTY
    -- SECGROU, DIVSECGROU, CUSAG, IDRES
    -- Il y a inversion entre les donnees de proplus et hispro pour PID, FACTPID, FACTPNO, FACTPDSG, PNOM, ,PDSG
    -- ----------------------

    L_STATEMENT := 'Ajout des data dans hispro';
      INSERT INTO hispro (TIRES,
            CDEB,
            FACTPDSG,
            FACTPID,
            PID,
            PDSG,
            FACTPNO,
            PNOM,
            CUSAG,
            IDPRO,
            FLAG,
            IDRES
           )
    SELECT  pro.TIRES,
        pro.CDEB,
        pro.PDSG,
        pro.PID,
        pro.FACTPID,
        pro.FACTPDSG,
        pro.PNOM,
        pro.FACTPNO,
        pro.CUSAG,
        b.IDPRO,
        '2',
        RTRIM(substr(res.rnom,1,11))|| '-' || substr(res.rprenom,1,1)|| '.' as IDRES
    FROM  (SELECT  RTRIM(substr(r.rnom,1,11))|| '-' || substr(r.rprenom,1,1)|| '.' as IDPRO,
               a.tires as idtires,
               a.cdeb  as idcdeb,
               a.pid   as idpid
          FROM   (SELECT distinct pro.tires,
                     pro.pcpi,
                       pro.pid,
                       pro.cdeb
                FROM   proplus pro, ressource r
                WHERE  trunc(pro.CDEB,'YEAR') = trunc(to_date(L_ANTRT, 'YYYY'), 'YEAR')
                AND    pro.tires = r.ident
                AND    (pro.AISTTY = 'FF' OR pro.AISTTY = 'DC')
               ) a,
               ressource r
          WHERE  a.pcpi = r.ident) b,
              proplus pro,
              ressource res
    WHERE  pro.tires = res.ident
    AND    trunc(pro.CDEB,'YEAR') = trunc(to_date(L_ANTRT, 'YYYY'), 'YEAR')
    AND    (pro.AISTTY = 'FF' OR pro.AISTTY = 'DC')
    AND    pro.tires = b.idtires
    AND    pro.pid = b.idpid
    AND    pro.cdeb = b.idcdeb
    AND    factpid is not null;

    TRCLOG.TRCLOG( P_HFILE, L_STATEMENT ||'-'||sql%rowcount);
    commit;

    TRCLOG.TRCLOG( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME   );

    exception

        when others then
            if sqlcode <> CALLEE_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||
                                               ' [' || L_STATEMENT ||
                               '] : ' || SQLERRM );
            end if;
            TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' ||
                                                L_PROCNAME  );
            raise CALLEE_FAILED;

    end PROHISB;

    -- SHELL appele pour lancer CHARGCAM
    -- CHARGCAM : charge la table charge_camo.
    -- ----------
    procedure ST54702K( P_LOGDIR in varchar2 ) IS

        L_HFILE utl_file.file_type;
        L_RETCOD number;
        L_PROCNAME varchar2(16) := 'ST54702K';

    begin

        -- Init de la trace
        -- ----------------
        L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
        if ( L_RETCOD <> 0 ) then
        raise_application_error( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 false );
        end if;

        -- Trace Start
        -- -----------
        TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );

        -- Lancement du programmes de chargement
        -- --------------
        CHARGCAM( L_HFILE );

        -- Trace Stop
        -- ----------
        TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
        TRCLOG.CLOSETRCLOG( L_HFILE );

    exception

        when others then
            rollback;
            if sqlcode <> CALLEE_FAILED_ID and
               sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( L_HFILE, L_PROCNAME || ' : ' || SQLERRM );
            end if;
            if sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
                TRCLOG.CLOSETRCLOG( L_HFILE );
                raise_application_error( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         false );
            else
                raise;
            end if;

    end ST54702K;

    -- Maj des centres d'activite et maitrise d'ouvrage
    -- -------------------------
    procedure CHARGCAM( P_HFILE in utl_file.file_type ) IS

        L_PROCNAME varchar2(16):= 'CHARGCAM';
        L_STATEMENT varchar2(64);

    begin


      ---------------------------------------------------
      -- Alimentation de la table contenant des rejéts
    -- de chargement dans la table camo
    ---------------------------------------------------

    L_STATEMENT := 'Truncate BATCH_CHARGE_CAMO_BAD';
    DYNA_TRUNCATE('BATCH_CHARGE_CAMO_BAD');

    L_STATEMENT := 'Chargement de la table des rejéts camo';
    insert into BATCH_CHARGE_CAMO_BAD ( XCODCAMO,
                                        XCLIBRCA,
                                     XCLIBCA,
                                    XCDATEOUVE,
                                  XCDATEFERM,
                                        XCODNIV,
                    XCANIV1,
                    XCANIV2,
                                        XCANIV3,
                                        XCANIV4,
                                        XCDFAIN,
                                        XCANIV5,
                                        XCANIV6 )
    select XCODCAMO,
           XCLIBRCA,
         XCLIBCA,
           XCDATEOUVE,
            XCDATEFERM,
            XCODNIV,
            XCANIV1,
            XCANIV2,
            XCANIV3,
            XCANIV4,
            XCDFAIN,
            XCANIV5,
            XCANIV6
    from CHARGE_CAMO chcam, CENTRE_ACTIVITE cact
    where to_number(substr(chcam.XCODCAMO, 6, 5)) = cact.CODCAMO
    and  cact.CTOPAMO = 'M';
    commit;
      TRCLOG.TRCLOG( P_HFILE, L_STATEMENT ||'-'|| sql%rowcount || 'rows inserted');

    -----------------------------------------------------
    -- Alimentation de la table centre activité à partir
    -- de la table CHARGE_CAMO
    -----------------------------------------------------

    -----------------------------------------------------
    -- MAJ dans le cas le l'existance d'un code centre
    -- d'activité dans la table de chargement et dans la
    -- la table des centres d'activité
    -----------------------------------------------------

      L_STATEMENT := 'Update centre activité';

    update CENTRE_ACTIVITE cact
    set (cact.CODCAMO,
           cact.CLIBCA,
            cact.CDATEOUVE,
           cact.CDATEFERM,
           cact.CODNIVCA,
           cact.CANIV4,
           cact.CANIV3,
           cact.CANIV2,
           cact.CANIV1,
           cact.CLIBRCA,
           cact.CTOPAMO,
           cact.CDFAIN,
           cact.CANIV5,
           cact.CANIV6 ) =
          (select
          to_number(substr(chcam.XCODCAMO, 6, 5)),
          substr(chcam.XCLIBCA, 1, 27),
          trunc(chcam.XCDATEOUVE, 'MONTH'),
          trunc(chcam.XCDATEFERM, 'MONTH'),
          to_number(decode(chcam.XCODNIV, 30, 5, 99, 4, 31, 4, 32, 3,
                                33, 2, 34, 1, 35, 0, 0)),
          to_number(substr(nvl(chcam.XCANIV4, '00000000000'), 6, 5)),
          to_number(substr(nvl(chcam.XCANIV3, '00000000000'), 6, 5)),
          to_number(substr(nvl(chcam.XCANIV2, '00000000000'), 6, 5)),
          to_number(substr(nvl(chcam.XCANIV1, '00000000000'), 6, 5)),
          substr(chcam.XCLIBRCA, 1, 16),
          'A',
          chcam.XCDFAIN,
          to_number(substr(nvl(chcam.XCANIV5, '00000000000'), 6, 5)),
          to_number(substr(nvl(chcam.XCANIV6, '00000000000'), 6, 5))
          from CHARGE_CAMO chcam
          where to_number(substr(chcam.XCODCAMO, 6, 5)) = cact.CODCAMO
          and (cact.CTOPAMO <> 'M' or cact.CTOPAMO is null)
          and chcam.XCODNIV = 35
          )
      where cact.CODCAMO IN (select cact.CODCAMO
                             from centre_activite cact, charge_camo chcam
                             where to_number(substr(chcam.XCODCAMO, 6, 5)) = cact.CODCAMO
                             and (cact.CTOPAMO <> 'M' or cact.CTOPAMO is null)
                             and chcam.XCODNIV = 35);
      commit;
      TRCLOG.TRCLOG( P_HFILE, L_STATEMENT ||'-'||sql%rowcount || 'rows updated');


      -----------------------------------------------------
      -- INSERT dans le cas de l'inéxistance d'un code centre
      -- d'activité dans la table de chargement et dans la
      -- la table des centres d'activités
      -----------------------------------------------------

      L_STATEMENT := 'Insert centre activité';

      insert into CENTRE_ACTIVITE     (  CODCAMO,
                                         CLIBCA,
                                          CDATEOUVE,
                                         CDATEFERM,
                                         CODNIVCA,
                                         CANIV4,
                                         CANIV3,
                                         CANIV2,
                                         CANIV1,
                                         CLIBRCA,
                                         CTOPAMO,
                                         CTOPACT,
                                         CDFAIN,
                                         CANIV5,
                                         CANIV6
                                        )
      select
          to_number(substr(chcam.XCODCAMO, 6, 5)),
          substr(chcam.XCLIBCA, 1, 27),
          trunc(chcam.XCDATEOUVE, 'MONTH'),
          trunc(chcam.XCDATEFERM, 'MONTH'),
          to_number(decode(chcam.XCODNIV, 30, 5, 99, 4, 31, 4, 32, 3,
                                33, 2, 34, 1, 35, 0, 0)),
          to_number(substr(nvl(chcam.XCANIV4, '00000000000'), 6, 5)),
          to_number(substr(nvl(chcam.XCANIV3, '00000000000'), 6, 5)),
          to_number(substr(nvl(chcam.XCANIV2, '00000000000'), 6, 5)),
          to_number(substr(nvl(chcam.XCANIV1, '00000000000'), 6, 5)),
          substr(chcam.XCLIBRCA, 1, 16),
          'A',
          'B',
          chcam.XCDFAIN,
           to_number(substr(nvl(chcam.XCANIV5, '00000000000'), 6, 5)),
          to_number(substr(nvl(chcam.XCANIV6, '00000000000'), 6, 5))
      from CHARGE_CAMO chcam
      where not exists (select 1 from CENTRE_ACTIVITE cact
                        where to_number(substr(chcam.XCODCAMO, 6, 5)) = cact.CODCAMO)
    -- le xcodniv 35 correspond au codcamo de niveau 0
        and XCODNIV = 35;

      commit;
      TRCLOG.TRCLOG( P_HFILE, L_STATEMENT ||'-'||sql%rowcount || 'rows inserted');

    TRCLOG.TRCLOG( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME   );

    exception

        when others then
            if sqlcode <> CALLEE_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||
                                               ' [' || L_STATEMENT ||
                               '] : ' || SQLERRM );
            end if;
            TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' ||
                                                L_PROCNAME  );
            raise CALLEE_FAILED;

    end CHARGCAM;


    -- SHELL appele pour lancer COPIE_BIP_BIP2
    --
    -- ----------
    procedure ST54700G( P_LOGDIR in varchar2 ) IS

        L_HFILE utl_file.file_type;
        L_RETCOD number;
        L_PROCNAME varchar2(16) := 'ST54700G';

    begin

        -- Init de la trace
        -- ----------------
        L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
        if ( L_RETCOD <> 0 ) then
        raise_application_error( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 false );
        end if;

        -- Trace Start
        -- -----------
        TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );

        -- Lancement du programmes de chargement
        -- --------------
        COPIE_BIP_BIP2(L_HFILE);

        -- Trace Stop
        -- ----------
        TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
        TRCLOG.CLOSETRCLOG( L_HFILE );

    exception

        when others then
            rollback;
            if sqlcode <> CALLEE_FAILED_ID and
               sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( L_HFILE, L_PROCNAME || ' : ' || SQLERRM );
            end if;
            if sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
                TRCLOG.CLOSETRCLOG( L_HFILE );
                raise_application_error( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         false );
            else
                raise;
            end if;

    end ST54700G;


      -- -------------------------------------------------------------------
      -- Procédure de recopie de bip dans bip2 et de etape dans etape2
      -- Ce traitement se fait en fin de mensuelle pour l'analyse des écarts
      -- bip bip2 pour la prémensuelle suivante
      -- -------------------------------------------------------------------

    procedure COPIE_BIP_BIP2(P_HFILE in utl_file.file_type) IS

        L_PROCNAME varchar2(16) := 'COPIE_BIP_BIP2';
        L_STATEMENT varchar2(64);

    begin
      L_STATEMENT := 'Truncate de etape2';
      DYNA_TRUNCATE('ETAPE2');

      L_STATEMENT := 'Truncate de ligne_bip2';
      DYNA_TRUNCATE('LIGNE_BIP2');

      L_STATEMENT := 'Copie ligne_bip ligne_bip2';

      insert into ligne_bip2
      ( PID,
        PJCAMON1,
        ASTATUT,
        ADATESTATUT,
        TTRMENS,
        TTRFBIP,
        TVAEDN,
        TDEBINN,
        TDATFHP,
        TDATFHR,
        TDATFHN,
        TDATEBR,
        TARCPROC,
        POBJET,
        PDATDEBPRE,
        PDATFINPRE,
        PTYPEN1,
        PCACTOP,
        PCONSN1,
        PDECN1,
        PMOYCEN,
        PSITDED,
        PNMOUVRA,
        PCLE,
        PETAT,
        PNOM,
        PCPI,
        TOPTRI,
        TYPPROJ,
        ICPI,
        CODPSPE,
        CODCAMO,
        DPCODE,
        CODSG,
        ARCTYPE,
        AIRT,
        CLICODE,
      PZONE,
    FLAGLOCK )
      select
        PID,
        PJCAMON1,
        ASTATUT,
        ADATESTATUT,
        TTRMENS,
        TTRFBIP,
        TVAEDN,
        TDEBINN,
        TDATFHP,
        TDATFHR,
        TDATFHN,
        TDATEBR,
        TARCPROC,
        POBJET,
        PDATDEBPRE,
        PDATFINPRE,
        PTYPEN1,
        PCACTOP,
        PCONSN1,
        PDECN1,
        PMOYCEN,
        PSITDED,
        PNMOUVRA,
        PCLE,
        PETAT,
        PNOM,
        PCPI,
        TOPTRI,
        TYPPROJ,
        ICPI,
        CODPSPE,
        CODCAMO,
        DPCODE,
        CODSG,
        ARCTYPE,
        AIRT,
        CLICODE,
      PZONE,
    FLAGLOCK
      from LIGNE_BIP;
      commit;

      TRCLOG.TRCLOG( P_HFILE, L_STATEMENT ||'-'||sql%rowcount);

      L_STATEMENT := 'Copie etape etape2';

      insert into ETAPE2
      ( PID, ECET, EDUR, ENFI, ENDE, EDEB, EFIN, TYPETAP )
      select
        PID, ECET, EDUR, ENFI, ENDE, EDEB, EFIN, TYPETAP
      from ETAPE;
      commit;
      TRCLOG.TRCLOG( P_HFILE, L_STATEMENT ||'-'||sql%rowcount);

    TRCLOG.TRCLOG( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME   );

    exception

        when others then
            if sqlcode <> CALLEE_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||
                                               ' [' || L_STATEMENT ||
                               '] : ' || SQLERRM );
            end if;
            TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' ||
                                                L_PROCNAME  );
            raise CALLEE_FAILED;

    end COPIE_BIP_BIP2;



    -- SHELL appele pour lancer DEBFINTRAIT
    --
    -- ----------
    procedure DEBFINTRAIT( P_LOGDIR in varchar2, P_TYPE_MSG in Varchar2 ) IS

        L_HFILE utl_file.file_type;
        L_RETCOD number;
        L_PROCNAME varchar2(16) := 'DEBFINTRAIT';

    begin

        -- Init de la trace
        -- ----------------
        L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
        if ( L_RETCOD <> 0 ) then
        raise_application_error( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 false );
        end if;

        -- Trace Start
        -- -----------
--        TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );
        TRCLOG.TRCLOG( L_HFILE, 'Start ' || L_PROCNAME || ' -> ' || P_TYPE_MSG);
        -- Lancement du programmes de mise à jour
        -- --------------
        ECRITURE_MESSAGE ( L_HFILE , P_TYPE_MSG );

        -- Trace Stop
        -- ----------
        -- TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
        TRCLOG.CLOSETRCLOG( L_HFILE );

    exception

        when others then
            rollback;
            if sqlcode <> CALLEE_FAILED_ID and
               sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( L_HFILE, L_PROCNAME || ' : ' || SQLERRM );
            end if;
            if sqlcode <> TRCLOG_FAILED_ID then
                TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
                TRCLOG.CLOSETRCLOG( L_HFILE );
                raise_application_error( CALLEE_FAILED_ID,
                                        'Erreur : consulter le fichier LOG',
                                         false );
            else
                raise;
            end if;

    end DEBFINTRAIT;


      -- -------------------------------------------------------------------
      -- Ecriture du message de début ou de fin de traitement du batch
      -- -------------------------------------------------------------------

    procedure ECRITURE_MESSAGE(P_HFILE in utl_file.file_type, P_TYPE_MSG in varchar2 ) IS

      L_PROCNAME varchar2(16) := 'ECRITURE_MESSAGE';
      L_STATEMENT varchar2(64):= 'LECTURE et ECRITURE DU MESSAGE DE DEBUT FIN';
     L_MSG Varchar2(1024);
     L_DATE Varchar2(10);

     MSG1   VARCHAR2(10);
     MSG2   VARCHAR2(80);
     MSG3    VARCHAR2(50);
     pos1   integer;
     pos2   integer;
     lgth   integer;
     L_NUMTRAIT    number(1);

    BEGIN

    -- DEBUT message en cours
    -- FIN   message de bonne fin
    pos1 := INSTR( P_TYPE_MSG, ' ', 1, 1);
    lgth := LENGTH( P_TYPE_MSG);
    MSG1 := substr( P_TYPE_MSG, 1, pos1-1);
    MSG2 := substr( P_TYPE_MSG, pos1+1, lgth-pos1);

    --on determine si MENUELLE ou 2/3 premensuelle
    pos1 := INSTR( MSG2, ' ', 1, 1);
    pos2 := INSTR( MSG2, ' ', 1, 2);
    IF (pos2 = 0) THEN
        pos2 := LENGTH(MSG2);
    ELSE
        pos2 := pos2-1;
    END IF;
    MSG3 := substr( MSG2, pos1+1, pos2-pos1);

    TRCLOG.TRCLOG( P_HFILE, 'NUMTRAIT >'||MSG3||'<');
    IF ( MSG3 = '1' ) THEN
        L_NUMTRAIT := 1;
        --TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || '===>1');
    ELSE
        IF ( MSG3 = '2' ) THEN
            L_NUMTRAIT := 2;
            --TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || '===>2');
        ELSE
            IF ( MSG3 = 'MENSUELLE' ) THEN
                --TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || '===>3');
                L_NUMTRAIT := 3;
            ELSE
                -- Dans le cas du traitement entre la clôture et la première mensuelle de l'année
                -- numtrait doit rester à 3
                L_NUMTRAIT := 3;
                --TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || '= '||MSG3||'==>?????');
            END IF;
        END IF;
    END IF;

    IF MSG1 = 'DEBUT' THEN
        L_DATE := to_char(sysdate, 'DD/MM/YYYY');
        pack_global.recuperer_message( 5015, '%s1', L_DATE, NULL, L_MSG);
        L_STATEMENT := 'Mise à jour de datdebex DERTRAIT';
        IF  MSG2 = 'TRAITEMENT 1 PRE-MENSUELLE' THEN
            -- old          UPDATE datdebex SET DERTRAIT = trunc(sysdate);
            -- new qhl : ajout de 2 zones dans datdebex pour resoudre le pb de quel est le dernier mois mensuel
			--PPM 58896 : utilisation directe du cmensuelle sans soustraire 1 mois pour recuperer calanmois
            UPDATE datdebex  SET (dertrait, moismens , moismens_nbjo, NUMTRAIT) =
                  (SELECT trunc(sysdate), calanmois, cjours, L_NUMTRAIT FROM calendrier
                   WHERE  calanmois = (SELECT trunc(cmensuelle,'month') FROM datdebex ) );--PPM 58896
        ELSE
            UPDATE datdebex SET (DERTRAIT, NUMTRAIT) = (SELECT trunc(sysdate), L_NUMTRAIT from dual);
        END IF;


    ELSE
        IF MSG1 = 'FIN' THEN
           L_DATE := to_char(sysdate, 'DD/MM/YYYY');
              pack_global.recuperer_message( 5014, '%s1', L_DATE, NULL, L_MSG);
        ELSE
           L_MSG := 'Erreur dans la gestion du message de la mensuelle';
        END IF;
    END IF;

    -- Ajout d'une actualité de dernière minute indiquant que le traitement de mensuel est en cours
    ADD_ACTUALITE(MSG1);

    L_STATEMENT := 'Mise à jour de la table des fichiers';

    UPDATE fichier SET contenu = L_MSG
    WHERE IDFIC='mensuelle';
    COMMIT;

    exception

        when others then
            if sqlcode <> CALLEE_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||
                                               ' [' || L_STATEMENT ||
                               '] : ' || SQLERRM );
            end if;
            TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' ||
                                                L_PROCNAME  );
            raise CALLEE_FAILED;

    end ECRITURE_MESSAGE;



    -- -------------------------------------------------------------------
    -- ajout d'une actualité indiquant qu'un traitement est en cours
    -- -------------------------------------------------------------------

    procedure ADD_ACTUALITE(p_position in varchar2 ) IS
        v_titre           actualite.titre%TYPE;
        v_texte_deb          actualite.texte%TYPE;
        v_texte_fin          actualite.texte%TYPE;
        v_date_affich     varchar2(10);
        v_date_debut       varchar2(10);
        v_date_fin           varchar2(10);
        v_menus           varchar2(2000);
        v_userid           varchar2(50);
        o_code_actu       actualite.code_actu%TYPE;
        o_nbcurseur       integer;
        o_message           varchar2(2000);
        v_date_dern_trait date;
        l_msg              VARCHAR2(1024);
        v_moismens          varchar2(20);
        v_libnumtrait     VARCHAR2(40);
        v_jour                varchar2(10);
        v_date_trait        date;
    BEGIN

        BEGIN
            select decode( to_char(moismens,'mm'),'04','d''','08','d''','10','d''','de ')
                   ||trim(to_char(moismens,'month'))||' '||to_char(moismens,'YYYY'), lower(to_char(dertrait,'day')), dertrait,
                   decode(numtrait,1,'pré-mensuelle',2,'pré-mensuelle de régularisation','mensuelle')
              into v_moismens, v_jour, v_date_trait, v_libnumtrait
              from datdebex;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.put_line('Erreur lors de la récupération du mois de la mensuelle.');
        END;

        --DBMS_OUTPUT.put_line('Jour du lancement : '||v_jour||' '||v_date_trait);

        pack_global.recuperer_message( 21030 , '%1', v_moismens, '', l_msg);
        v_titre       := l_msg;
        pack_global.recuperer_message( 21031 , '%1'  , v_libnumtrait, '', l_msg);
        v_texte_deb      := l_msg;
        pack_global.recuperer_message( 21032 , '%1'  ,  v_libnumtrait , '', l_msg);
        v_texte_fin      := l_msg;
        v_date_affich := to_char(v_date_trait, 'dd/mm/yyyy');
        v_date_debut  := to_char(v_date_trait, 'dd/mm/yyyy');
        v_userid       := null;
        -- on affecte à l'actualité le profil POURTOUS pour éviter de liste un par un tous les profils se qui poserait
        -- des problèmes à l'ajout la modification ou la suppression d'un profil.
        -- une clause est ajoutée dans la liste des actualité (PACK_LISTE_ACTU) pour ce profil spécifique.
        v_menus       := 'POURTOUS,';


        if (trim(lower(v_jour))='vendredi') then
            -- si le traitement est lancé un vendredi il faut que le message soit affiché jusqu'au mardi
            -- la date de fin est la date ou on arrête d'afficher l'actualité
            v_date_fin    := to_char(v_date_trait+6, 'dd/mm/yyyy'); -- YNI modification de la date fin de date_trait + 5 a date_trait + 6
        else
            v_date_fin    := to_char(v_date_trait+6, 'dd/mm/yyyy');--YSB : 3 à 5 -- YNI modification de la date fin de date_trait + 5 a date_trait + 6
        end if;


        --DBMS_OUTPUT.put_line('Date de fin d''affichage du message : '||v_date_fin);

        if (p_position='DEBUT') then
            /* Passage des actualité de dernière minute en non dernière minute */
            update actualite
               set derniere_minute='N'
             where valide='O'
                   and v_date_trait between date_debut and date_fin
                   and derniere_minute = 'O';

            /* création d'une actualité de dernière minute sur la mensuelle en cours */
            BEGIN
                PACK_ACTU.INSERT_ACTUALITE( v_titre, v_texte_deb, v_date_affich, v_date_debut, v_date_fin, 'O', null, 'O','N',
                                             v_menus, null, null, null, v_userid, o_code_actu, o_nbcurseur, o_message);
                --DBMS_OUTPUT.put_line('Actualite insérée : '||o_code_actu);
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.put_line('Erreur lors de la création d''une actualité : '||o_message);
            END;


        elsif (p_position='FIN') then
            /* on récupère la date du traitement qui vient de finir */
            select dertrait into v_date_dern_trait from datdebex;

            -- DBMS_OUTPUT.put_line('Date de la dernière mensuelle : '||v_date_dern_trait);

            BEGIN
                select code_actu
                  into o_code_actu
                  from actualite
                 where titre = v_titre
                   and v_date_dern_trait between date_debut and date_fin
                   and valide = 'O'
                   and derniere_minute = 'O';

                --DBMS_OUTPUT.put_line('Actu mensuelle en cours, code = '||o_code_actu);

                /* on rend invalide l'actualité 'mensuelle en cours' */
                update actualite
                   set valide = 'N'
                 where code_actu = o_code_actu;

                /* création d'une actualité de dernière minute sur le succès de la mensuelle */
                BEGIN
                    PACK_ACTU.INSERT_ACTUALITE( v_titre, v_texte_fin, v_date_affich, v_date_debut, v_date_fin, 'O', null, 'O','N',
                                                 v_menus, null, null, null, v_userid, o_code_actu, o_nbcurseur, o_message);
                    -- DBMS_OUTPUT.put_line('Actualite insérée : '||o_code_actu);
                EXCEPTION
                    WHEN OTHERS THEN
                        DBMS_OUTPUT.put_line('Erreur lors de la création d''une actualité : '||o_message);
                END;
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.put_line('ERREUR Impossible de retrouver l''actualité correspondante au début du traitement.');
            END;

        end if;
    END ADD_ACTUALITE;

end PACKBATCH2;
/


