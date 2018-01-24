create or replace PACKAGE     PACKBATCH_RA AS
--****************************************************
-- Procédure globale d'alimentation des tables de stock
--****************************************************
PROCEDURE ra (P_LOGDIR          IN VARCHAR2)  ;

--********************************************************
-- Procédure globale d'alimentation des tables de synthese
--********************************************************
PROCEDURE synthese (P_LOGDIR          IN VARCHAR2)  ;
--********************************************************
-- Procédure globale d'alimentation des tables de synthese lancée lors de la prémensuelle
--********************************************************
PROCEDURE synthese_premensuelle (P_LOGDIR          IN VARCHAR2)  ;

--****************************************************
-- Procédure d'alimentation de la table stock_ra
--****************************************************
PROCEDURE alim_stock_ra(P_HFILE           IN utl_file.file_type)   ;
--*************************************************************
-- Procédure de calcul des retours arrieres
--************************************************************
PROCEDURE calcul_ra(P_HFILE           IN utl_file.file_type) ;
--*******************************************************
-- Procédure d'alimentation de la table SYNTHESE_ACTIVITE_MOIS
--*******************************************************
PROCEDURE alim_synth_act_mois(P_HFILE           IN utl_file.file_type)   ;
--*************************************************************
-- Procédure d'alimentation de la table SYNTHESE_ACTIVITE
--************************************************************
PROCEDURE alim_synth_act(P_HFILE           IN utl_file.file_type) ;
--*******************************************************
-- Procédure d'alimentation de la table SYNTHESE_ACTIVITE_MOIS lors de la prémensuelle
--*******************************************************
PROCEDURE alim_synth_act_mois_pre(P_HFILE           IN utl_file.file_type)   ;
--*************************************************************
--*******************************************************
-- Procédure d'alimentation de la table SYNTHESE_ACTIVITE lors de la prémensuelle
--*******************************************************
PROCEDURE alim_synth_act_pre(P_HFILE           IN utl_file.file_type)   ;
--*************************************************************


END PACKBATCH_RA;
/

create or replace PACKAGE BODY     PACKBATCH_RA AS

-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
pragma EXCEPTION_init( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !
ERR_FONCTIONNELLE_ID number := -20002;   -- pour provoquer erreur alors que Oracle OK
CONSTRAINT_VIOLATION EXCEPTION;          -- pour clause when
pragma EXCEPTION_init( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère



--****************************************************
-- Procédure d'alimentation des differentes tables
--****************************************************
PROCEDURE ra (P_LOGDIR          IN VARCHAR2)  IS

L_HFILE     utl_file.file_type;
L_RETCOD    number;
L_PROCNAME  varchar2(16) := 'RA';

    BEGIN

        -----------------------------------------------------
        -- Init de la trace
        -----------------------------------------------------
        L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
        if ( L_RETCOD <> 0 ) then
        raise_application_error( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 false );
        end if;

        -----------------------------------------------------
        -- Trace Start
        -----------------------------------------------------
        TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );

        -----------------------------------------------------
        -- Lancement ...
        -----------------------------------------------------
        --Alimentation de la table STOCK_RA
         alim_stock_ra( L_HFILE );

         --Alimentation de la table STOCK_RA : calcul des retours arrières
         calcul_ra( L_HFILE );

         -----------------------------------------------------
        -- Trace Stop
        -----------------------------------------------------
        TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
        TRCLOG.CLOSETRCLOG( L_HFILE );

    EXCEPTION
        when others then
            if sqlcode <> CALLEE_FAILED_ID and sqlcode <> TRCLOG_FAILED_ID then
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


END ra;

--************************************************************
-- Procédure d'alimentation des differentes tables de synthese
--************************************************************
PROCEDURE synthese (P_LOGDIR          IN VARCHAR2)  IS

L_HFILE     utl_file.file_type;
L_RETCOD    number;
L_PROCNAME  varchar2(16) := 'SYNTHESE';

    BEGIN

        -----------------------------------------------------
        -- Init de la trace
        -----------------------------------------------------
        L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
        if ( L_RETCOD <> 0 ) then
        raise_application_error( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 false );
        end if;

        -----------------------------------------------------
        -- Trace Start
        -----------------------------------------------------
        TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );

        -----------------------------------------------------
        -- Lancement ...
        -----------------------------------------------------
        --Alimentation des tables de synthese
         alim_synth_act_mois( L_HFILE );
         alim_synth_act( L_HFILE );

        -----------------------------------------------------
        -- Trace Stop
        -----------------------------------------------------
        TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
        TRCLOG.CLOSETRCLOG( L_HFILE );

    EXCEPTION
        when others then
            if sqlcode <> CALLEE_FAILED_ID and sqlcode <> TRCLOG_FAILED_ID then
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


END synthese;

--************************************************************
-- Procédure d'alimentation des differentes tables de synthese
-- lancée lors de la prémensuelle
--************************************************************
PROCEDURE synthese_premensuelle (P_LOGDIR          IN VARCHAR2)  IS

L_HFILE     utl_file.file_type;
L_RETCOD    number;
L_PROCNAME  varchar2(30) := 'SYNTHESE_PREMENSUELLE';

    BEGIN

        -----------------------------------------------------
        -- Init de la trace
        -----------------------------------------------------
        L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
        if ( L_RETCOD <> 0 ) then
        raise_application_error( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 false );
        end if;

        -----------------------------------------------------
        -- Trace Start
        -----------------------------------------------------
        TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );

        -----------------------------------------------------
        -- Lancement ...
        -----------------------------------------------------
        --Alimentation des tables de synthese
         alim_synth_act_mois_pre( L_HFILE );
         alim_synth_act_pre( L_HFILE );

        -----------------------------------------------------
        -- Trace Stop
        -----------------------------------------------------
        TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
        TRCLOG.CLOSETRCLOG( L_HFILE );

    EXCEPTION
        when others then
            if sqlcode <> CALLEE_FAILED_ID and sqlcode <> TRCLOG_FAILED_ID then
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


END synthese_premensuelle;


--*************************************************************
-- Sélection des lignes pour STOCK_RA
--************************************************************
PROCEDURE alim_stock_ra(P_HFILE IN utl_file.file_type)  IS

L_PROCNAME  varchar2(16) := 'ALIM_STOCK_RA';
L_STATEMENT varchar2(128);
l_exist NUMBER(1);
l_date  VARCHAR2(8);

  CURSOR C_STOCK_RA IS
    SELECT distinct t.TOP_IMMO, s.*
    FROM STOCK_RA s LEFT OUTER JOIN type_etape t
    ON s.TYPETAP = t.TYPETAP;


    T_STOCK_RA C_STOCK_RA%ROWTYPE;
    l_profil_fi VARCHAR2(12);
    l_type_profil NUMBER;
    l_cout      NUMBER(12,2);
    l_cout_env NUMBER(12,2);
    l_param_appli VARCHAR2(200);

BEGIN

    TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );
    -- --------------------------------------------------------------------------------------
    -- Etape 1 : vider STOCK_RA_1, copier STOCK_RA dans STOCK_RA_1, vider STOCK_RA
    -- --------------------------------------------------------------------------------------
    L_STATEMENT := '* Copier STOCK_RA dans STOCK_RA_1';
    TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
    -- vide STOCK_RA_1
    PACKBATCH.DYNA_TRUNCATE('STOCK_RA_1');
    -- données de STOCK_RA dans STOCK_RA_1
    INSERT INTO stock_ra_1
    select * from stock_ra
    where flag_ra!='O' or flag_ra is null; --Ne pas copier les lignes qui existaient dans stock_ra_1 et pas dans stock_ra
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table STOCK_RA_1';
    commit;
    -- vider STOCK_RA
    PACKBATCH.DYNA_TRUNCATE('STOCK_RA');

    -- --------------------------------------------------------------------------------------
    -- Etape 2 : On prend les consommés des lignes BIP en imputation directe
    -- --------------------------------------------------------------------------------------
    L_STATEMENT := '* Insertion des consommés des lignes Bip dans STOCK_RA';
        TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
    INSERT into stock_ra (  FACTPID,
                PID         ,
                CDEB         ,
                TYPPROJ         ,
                  METIER          ,
                  PNOM            ,
                  CODSG           ,
                  DPCODE          ,
                  ICPI            ,
                  CADA            ,
                  CODCAMO         ,
                  ECET        ,
                  TYPETAP            ,
                  ACTA        ,
                  ACST        ,
                  AIST        ,
                  ASNOM        ,
                  CAFI            ,
                  CODSGRESS       ,
                  IDENT           ,
                  RTYPE           ,
                  NIVEAU          ,
                  PRESTATION      ,
                  SOCCODE         ,
                  --COUTFTHT        ,
                  --COUTFTHTR       ,
                  --COUTENV         ,
                  CONSOJH         ,
                  --CONSOFT         ,
                  --CONSOENV        ,
                  --A_CONSOJH       ,
                  --A_CONSOFT       ,
                  --A_CONSOENV      ,
                  FLAG_RA  )
    (SELECT /*+ CONS_SSTACHE_RES_MOIS CONS_SSTACHE_RES_MOIS_PK */
            decode(t.aistty,'FF',t.aistpid,t.pid) factpid,
            t.pid pid,
             c.cdeb ,
                   l.typproj ,
             rtrim(l.metier) ,
             l.pnom ,
             l.codsg ,
             l.dpcode ,
             l.icpi ,
             p.cada,
             l.codcamo ,
             e.ecet,
             DECODE(e.typetap,NULL,'NO',e.typetap) typetap,
             t.acta,
             t.acst,
             t.aist,
             t.asnom,
             si.cafi ,
             sr.codsg  codsgress,
             c.ident,
             r.rtype,
             sr.niveau,
             sr.prestation,
             sr.soccode,
             NVL(c.cusag,0),
             'N'
         FROM cons_sstache_res_mois c,tache t,
        etape e,
        ressource r,
        proj_info p,
        struct_info si,
        datdebex d ,
        situ_ress_full sr ,
        ligne_bip l
    WHERE
    -- jointure ligne_bip et tache
        l.pid= decode(t.aistty,'FF',t.aistpid,t.pid)
    -- jointure ligne_bip et projet_info
        and l.icpi = p.icpi
    -- données concernant les ressources
               and r.ident =sr.ident
        and c.ident = sr.ident
        and (c.cdeb >=sr.datsitu or sr.datsitu is null)
        and (c.cdeb <=sr.datdep or sr.datdep is null )
    -- ressource dont la prestation n est pas gratuite
        and sr.prestation not in ('IFO','MO ','GRA','INT','STA')
    -- cafi de la ressource
        and si.codsg=sr.codsg
    -- consommés sur l'année en cours
         and to_char(d.moismens,'YYYY')=to_char(c.cdeb,'YYYY')
        and to_char(c.cdeb,'MM')<= to_char(d.moismens,'MM')
        -- On prend la ligne Bip d'imputation si elle existe
        and c.pid = t.pid
                and c.acta=t.acta
                and c.acst=t.acst
                and c.ecet=t.ecet
                and t.pid = e.pid
                and t.ecet = e.ecet
            );

    commit;

    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table stock_ra';
    TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

    --------------------------------------------------------------------------------
    -- ETAPE 3 : insertion des couts
    --------------------------------------------------------------------------------

    -- Ouverture du curseur pour le calcule et application des coûts FI
    OPEN C_STOCK_RA;

        LOOP

            FETCH C_STOCK_RA INTO T_STOCK_RA;
            IF C_STOCK_RA%NOTFOUND THEN
                EXIT;
            END IF;
           
            
    -- COUT D'ENVIRONNEMENT
    -- *SG,SSII,Forfait sur Site : cout d'environnement en HTR de la table COUT_STD2 en fonction du DPG de la ressource
    L_STATEMENT := '* Ajout cout d''environnement SG,SSII,Forfait sur Site';
    TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
    UPDATE stock_ra
    SET COUTENV= (SELECT distinct NVL(decode(stock_ra.soccode,'SG..',c.coutenv_sg,c.coutenv_ssii),0)
            FROM cout_std2 c, datdebex d
            WHERE
            --Sur l'année courante :
            to_char(c.annee )=to_char(d.datdebex,'YYYY')
            --sur le dpg de la ressource :
            and stock_ra.codsgress between c.dpg_bas and c.dpg_haut
            and rtrim(stock_ra.metier) = c.metier
            )
   WHERE
                            IDENT = T_STOCK_RA.IDENT
                            AND CAFI = T_STOCK_RA.CAFI
                            AND ACST = T_STOCK_RA.ACST
                            AND ECET = T_STOCK_RA.ECET
                            AND CAFI = T_STOCK_RA.CAFI
                            AND CODCAMO = T_STOCK_RA.CODCAMO
                            AND CDEB = T_STOCK_RA.CDEB
                            AND PID = T_STOCK_RA.PID
                            AND FACTPID = T_STOCK_RA.FACTPID;
            

        -- Le cas de calcule des coût Standard

        -- COUT FORCE DE TRAVAIL
        -- * SG : on prend le coût déjà HTR à partir de la table des coûts standards SG COUT_STD_SG des lignes dont le code société ='SG..',le type='P' par année,niveau,métier,dpg
        UPDATE stock_ra
        SET COUTFTHTR = (SELECT distinct NVL(c.cout_sg,0)
                FROM cout_std_sg c, datdebex d
                WHERE
                --Sur l'année courante :
                 to_char(c.annee )=to_char(d.datdebex,'YYYY')
                --sur le dpg de la ressource :
                and stock_ra.codsgress between c.dpg_bas and c.dpg_haut
                --Sur le métier de la ressource :
                and stock_ra.metier = c.metier
                --Sur le niveau de la ressource : les niveaux L,M,N correspondent au niveau HC dans la table COUT_STD_SG
                and decode(stock_ra.niveau,'L','HC','M','HC','N','HC',stock_ra.niveau) = c.niveau)
        WHERE  stock_ra.soccode='SG..'
        AND stock_ra.rtype='P'
        and   stock_ra.IDENT = T_STOCK_RA.IDENT
            AND stock_ra.CAFI = T_STOCK_RA.CAFI
            AND stock_ra.ACST = T_STOCK_RA.ACST
            AND stock_ra.CDEB = T_STOCK_RA.CDEB
            AND stock_ra.ECET = T_STOCK_RA.ECET
            AND stock_ra.CAFI = T_STOCK_RA.CAFI
            AND stock_ra.CODCAMO = T_STOCK_RA.CODCAMO
            AND stock_ra.PID = T_STOCK_RA.PID
            AND stock_ra.FACTPID = T_STOCK_RA.FACTPID;


        -- * SSII : cout HT et HTR des ressources dont le code société est <>'SG..' , le type='P' avec une situation en cours pour l'année courante
        -- Forfaits Hors site et sur site : cout HT et HTR type='E' ou 'F' avec une situation en cours pour l'année courante
        UPDATE stock_ra
        SET (COUTFTHT,COUTFTHTR) = (SELECT DISTINCT NVL(s.cout,0), pack_utile_cout.getCoutHTR(stock_ra.soccode,stock_ra.rtype,to_number(TO_CHAR(stock_ra.cdeb,'YYYY')),stock_ra.metier,stock_ra.niveau,stock_ra.codsg,s.cout,TO_CHAR(stock_ra.cdeb,'DD/MM/YYYY'),si.filcode)
                    FROM situ_ress_full s,datdebex d, ressource r,struct_info si
                    WHERE
                         s.ident = stock_ra.ident
                         AND (stock_ra.cdeb>=s.datsitu or s.datsitu is null)
                         AND (stock_ra.cdeb<=s.datdep or s.datdep is null)
                         AND to_char(stock_ra.cdeb,'YYYY') = to_char(d.datdebex,'YYYY')
                         AND r.ident=s.ident
                         AND s.codsg = si.codsg)

        WHERE
             stock_ra.soccode!='SG..'
             AND
             -- Type='P' pour personne, Type='F' pour forfait sur site, Type='E' pour forfait hors site
             (stock_ra.rtype='P' or stock_ra.rtype ='F' or stock_ra.rtype ='E')
             and   stock_ra.IDENT = T_STOCK_RA.IDENT
            AND stock_ra.CAFI = T_STOCK_RA.CAFI
            AND stock_ra.ACST = T_STOCK_RA.ACST
            AND stock_ra.ECET = T_STOCK_RA.ECET
            AND stock_ra.CAFI = T_STOCK_RA.CAFI
            AND stock_ra.CODCAMO = T_STOCK_RA.CODCAMO
            AND stock_ra.CDEB = T_STOCK_RA.CDEB
            AND stock_ra.PID = T_STOCK_RA.PID
            AND stock_ra.FACTPID = T_STOCK_RA.FACTPID
             ;

        -- * Logiciel : cout logiciel HTR de la table COUT_STD2 en fonction du DPG de la ressource
        UPDATE stock_ra
        SET COUTFTHTR = (SELECT distinct    NVL(c.cout_log,0)
                FROM cout_std2 c, datdebex d
                WHERE
                --Sur l'année courante :
                to_char(c.annee )=to_char(d.datdebex,'YYYY')
                --sur le dpg de la ressource :
                and stock_ra.codsgress between c.dpg_bas and c.dpg_haut
                and c.metier = 'ME'
                )

        WHERE  stock_ra.rtype='L'
        and   stock_ra.IDENT = T_STOCK_RA.IDENT
            AND stock_ra.CAFI = T_STOCK_RA.CAFI
            AND stock_ra.ACST = T_STOCK_RA.ACST
            AND stock_ra.ECET = T_STOCK_RA.ECET
            AND stock_ra.CAFI = T_STOCK_RA.CAFI
            AND stock_ra.CODCAMO = T_STOCK_RA.CODCAMO
            AND stock_ra.CDEB = T_STOCK_RA.CDEB
            AND stock_ra.PID = T_STOCK_RA.PID
            AND stock_ra.FACTPID = T_STOCK_RA.FACTPID;

         --END IF;
         END LOOP;
    -- Fermeture du curseur C_STOCK_RA
    CLOSE C_STOCK_RA;

    -- COUT D'ENVIRONNEMENT
    -- *SG,SSII,Forfait sur Site : cout d'environnement en HTR de la table COUT_STD2 en fonction du DPG de la ressource
    L_STATEMENT := '* Ajout cout d''environnement SG,SSII,Forfait sur Site';
    TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
    
        commit;
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes modifiées dans la table stock_ra';
    TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );


    --------------------------------------------------------------------------------
    -- ETAPE 4 : insertion des montants
    -- consoft = consojh*coutft et consoenv = consojh*coutenv
    --------------------------------------------------------------------------------
    L_STATEMENT := '* Calcul des montants';
    TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
    UPDATE stock_ra
    SET (CONSOFT, CONSOENV) = (select NVL(consojh,0)*NVL(coutfthtr,0),NVL(consojh,0)*NVL(coutenv,0)
                from stock_ra s
    WHERE
    s.typetap=stock_ra.typetap
    and s.ident=stock_ra.ident
    and s.factpid=stock_ra.factpid
    and s.pid=stock_ra.pid
    and s.cdeb=stock_ra.cdeb
    AND s.cafi=stock_ra.cafi
    AND s.ecet=stock_ra.ecet
    AND s.acta=stock_ra.acta
    AND s.acst=stock_ra.acst
    );
    commit;
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes modifiées dans la table stock_ra';
    TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

    TRCLOG.TRCLOG( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);

------------------------------------------------------------------------
-- GESTION DES EXCEPTIONS
------------------------------------------------------------------------
EXCEPTION
    when others then
        TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        if sqlcode <> CALLEE_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        end if;
        raise CALLEE_FAILED;



    TRCLOG.TRCLOG( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);

end alim_stock_ra;


-------------------------------------------------------------------------------------
-- CALCUL DES RETOURS ARRIERES
-------------------------------------------------------------------------------------
PROCEDURE calcul_ra(P_HFILE IN utl_file.file_type)   IS

CURSOR cur_stock_ra IS
SELECT * FROM stock_ra ;

L_PROCNAME  varchar2(16) := 'ALIM_RA';
L_STATEMENT varchar2(128);

l_consojh NUMBER(10,2);
l_consoft NUMBER(10,2);
l_consoenv NUMBER(10,2);

l_a_consojh NUMBER(10,2);
l_a_consoft NUMBER(10,2);
l_a_consoenv NUMBER(10,2);

l_moismens NUMBER(2);

BEGIN

TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

-- On compare chaque ligne de STOCK_RA avec les lignes de STOCK_RA_1
L_STATEMENT := '* Calcul des retours arrière';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
     FOR curseur IN cur_stock_ra LOOP
         BEGIN
           SELECT CONSOJH,CONSOFT,CONSOENV
             into l_consojh,l_consoft,l_consoenv
          FROM stock_ra_1 s
          WHERE s.ident = curseur.ident
          AND s.pid = curseur.pid
          AND s.factpid = curseur.factpid
          AND s.cdeb = curseur.cdeb
          AND s.codcamo=curseur.codcamo
          AND s.cafi=curseur.cafi
          AND s.ecet=curseur.ecet
          AND s.acta=curseur.acta
          AND s.acst=curseur.acst
          ;

          -- Calcul des retours arrières
              l_a_consojh := NVL(curseur.consojh,0) - NVL(l_consojh,0);
              l_a_consoft := NVL(curseur.consoft,0) - NVL(l_consoft,0);
              l_a_consoenv := NVL(curseur.consoenv,0) - NVL(l_consoenv,0);

              UPDATE stock_ra
              SET     A_CONSOJH = l_a_consojh,
                  A_CONSOFT = l_a_consoft,
                A_CONSOENV = l_a_consoenv
              WHERE ident = curseur.ident
              AND pid = curseur.pid
              AND factpid = curseur.factpid
              AND cdeb = curseur.cdeb
              AND codcamo = curseur.codcamo
              AND cafi = curseur.cafi
              AND ecet = curseur.ecet
                AND acta = curseur.acta
                AND acst = curseur.acst;

        EXCEPTION
             WHEN No_Data_Found THEN
                       UPDATE stock_ra
                      SET   A_CONSOJH = NVL(curseur.consojh,0),
                          A_CONSOFT =NVL(curseur.consoft,0),
                          A_CONSOENV = NVL(curseur.consoenv,0)
                      WHERE ident = curseur.ident
                        AND pid = curseur.pid
                        AND factpid = curseur.factpid
                        AND cdeb = curseur.cdeb
                        AND codcamo=curseur.codcamo
                        AND cafi=curseur.cafi
                        AND ecet = curseur.ecet
                          AND acta = curseur.acta
                          AND acst = curseur.acst;

        END;


     END LOOP;
    commit;


    -----------------------------------------------------------------------------
    -- CAS PARTICULIER
    -----------------------------------------------------------------------------
    -- Cas où il existe des lignes dans STOCK_RA_1 et pas dans STOCK_RA
    L_STATEMENT := '* Insertion des lignes dans STOCK_RA existant dans STOCK_RA_1 et pas dans STOCK_RA';
         TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
    INSERT INTO stock_ra (  FACTPID        ,
                PID         ,
                CDEB         ,
                TYPPROJ         ,
                  METIER          ,
                  PNOM            ,
                  CODSG           ,
                  DPCODE          ,
                  ICPI            ,
                  CADA            ,
                  CODCAMO         ,
                  ECET        ,
                  TYPETAP            ,
                  ACTA        ,
                  ACST        ,
                  AIST        ,
                  ASNOM        ,
                  CAFI            ,
                  CODSGRESS       ,
                  IDENT           ,
                  RTYPE           ,
                  NIVEAU          ,
                  PRESTATION      ,
                  SOCCODE         ,
                  COUTFTHT        ,
                  COUTFTHTR       ,
                  COUTENV         ,
                  CONSOJH         ,
                  CONSOFT         ,
                  CONSOENV        ,
                  A_CONSOJH       ,
                  A_CONSOFT       ,
                  A_CONSOENV      ,
                  FLAG_RA     )
     SELECT     s.factpid    ,
            s.pid         ,
            s.cdeb         ,
            s.typproj     ,
            s.metier         ,
            s.pnom         ,
            s.codsg         ,
            s.dpcode         ,
            s.icpi         ,
            s.cada        ,
            s.codcamo     ,
            s.ecet        ,
            s.typetap    ,
            s.acta    ,
            s.acst    ,
            s.aist    ,
            s.asnom    ,
            s.cafi         ,
            s.codsgress     ,
            s.ident         ,
            s.rtype        ,
            s.niveau         ,
            s.prestation    ,
            s.soccode     ,
            NVL(s.coutftht,0)    ,
            NVL(s.coutfthtr,0)     ,
            NVL(s.coutenv,0)    ,
            0    ,
            0     ,
            0    ,
            decode(s.consojh,0, s.a_consojh,- s.consojh),
            decode(s.consojh,0,s.a_consoft,- s.consoft),
            decode(s.consojh,0,s.a_consoenv,- s.consoenv),
            'O'
        FROM
        (select cdeb,factpid,pid,ident,cafi,codcamo,ecet,acta,acst from stock_ra_1
         minus
         select cdeb,factpid,pid,ident,cafi,codcamo,ecet,acta,acst from stock_ra) n,
        stock_ra_1 s, datdebex d
        where n.ident=s.ident
        and n.pid=s.pid
        and n.factpid=s.factpid
        and n.cdeb=s.cdeb
        AND n.codcamo=s.codcamo
        AND n.cafi=s.cafi
        AND n.ecet = s.ecet
        AND n.acta = s.acta
        AND n.acst = s.acst
        ;
        commit;
        L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table STOCK_RA';
        TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

        TRCLOG.TRCLOG( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
EXCEPTION
    when others then
        rollback;
        if sqlcode <> CALLEE_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        end if;
        TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        raise CALLEE_FAILED;

END calcul_ra ;

--***********************************************************
-- Procédure d'alimentation de la table synthese_activite_mois
--***********************************************************
PROCEDURE alim_synth_act_mois(P_HFILE IN utl_file.file_type)   IS

CURSOR cur_ra IS
select DISTINCT FACTPID,PID,CDEB,TYPPROJ,METIER,PNOM,CODSG,DPCODE,ICPI,CODCAMO,SOCCODE,CONSOJH,CONSOFT,CONSOENV from stock_ra ;

L_PROCNAME  varchar2(16) := 'SYNTH_ACT_MOIS';
L_STATEMENT varchar2(128);

l_exist NUMBER(1);

BEGIN

TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

-- on vide la table
L_STATEMENT := '* vide synthese_activite_mois de l annee courante';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
    DELETE SYNTHESE_ACTIVITE_MOIS
    WHERE to_number(to_char(cdeb,'YYYY')) in (select to_number(to_char(datdebex,'YYYY')) from datdebex);
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table SYNTHESE_ACTIVITE_MOIS';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
COMMIT;


-- on alimente la table de synthese avec les données contenues dans le stock ra

L_STATEMENT := '* alimentation de synthese_activite_mois';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

    INSERT INTO SYNTHESE_ACTIVITE_MOIS (PID,CDEB,TYPPROJ,METIER,PNOM,CODSG,DPCODE,ICPI,CODCAMO)
      (select DISTINCT FACTPID,CDEB,TYPPROJ,METIER,PNOM,CODSG,DPCODE,ICPI,CODCAMO
       from stock_ra s
       where flag_ra <> 'O'
       );
      commit;

-- mise à jour des conso en fonction du code societe
L_STATEMENT := '* consommés des SG';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

        UPDATE SYNTHESE_ACTIVITE_MOIS
          SET (CONSOJH_SG,CONSOFT_SG,CONSOENV_SG)=
              (select distinct NVL(SUM(s.consojh),0),NVL(SUM(s.consoft),0),NVL(SUM(s.consoenv),0)
            from stock_ra s
            where
            s.factpid=SYNTHESE_ACTIVITE_MOIS.pid
            and s.cdeb=SYNTHESE_ACTIVITE_MOIS.cdeb
            and s.soccode='SG..')
        ;
        commit;

L_STATEMENT := '* consommés des SSII';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

        UPDATE SYNTHESE_ACTIVITE_MOIS
          SET (CONSOJH_SSII,CONSOFT_SSII,CONSOENV_SSII)=
              (select distinct NVL(SUM(s.consojh),0),NVL(SUM(s.consoft),0),NVL(SUM(s.consoenv),0)
            from stock_ra s
            where
            s.factpid=SYNTHESE_ACTIVITE_MOIS.pid
            and s.cdeb=SYNTHESE_ACTIVITE_MOIS.cdeb
            and s.soccode<>'SG..')
        ;
        commit;

    TRCLOG.TRCLOG( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
EXCEPTION
    when others then
        rollback;
        if sqlcode <> CALLEE_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        end if;
        TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        raise CALLEE_FAILED;


END alim_synth_act_mois;

--***************************************************************************
-- Procédure d'alimentation de la table synthese_activite : stock sur l'annee
--***************************************************************************
PROCEDURE alim_synth_act(P_HFILE IN utl_file.file_type)   IS
L_STATEMENT varchar2(128);
L_PROCNAME  varchar2(16) := 'SYNTH_ACT';

BEGIN

TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

-- on vide la table
L_STATEMENT := '* vide synthese_activite de l annee courante';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
    DELETE SYNTHESE_ACTIVITE
    WHERE annee in (select to_number(to_char(datdebex,'YYYY')) from datdebex);
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table SYNTHESE_ACTIVITE';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
COMMIT;

-- on alimente la table de synthese avec les données contenues dans synthese_activite_mois

L_STATEMENT := '* alimentation de synthese_activite';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

    INSERT INTO SYNTHESE_ACTIVITE (PID,ANNEE)
      (select DISTINCT PID,to_number(to_char(cdeb,'yyyy'))
       from SYNTHESE_ACTIVITE_MOIS s, datdebex d
       where s.cdeb >= d.datdebex
       );
      L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans SYNTHESE_ACTIVITE.';
      commit;

-- mise à jour des conso
L_STATEMENT := '* consommés';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

        UPDATE SYNTHESE_ACTIVITE
          SET (CONSOJH_SG,CONSOFT_SG,CONSOENV_SG,CONSOJH_SSII,CONSOFT_SSII,CONSOENV_SSII)=
              (select distinct NVL(SUM(CONSOJH_SG),0),NVL(SUM(CONSOFT_SG),0),NVL(SUM(CONSOENV_SG),0) ,
                        NVL(SUM(CONSOJH_SSII),0),NVL(SUM(CONSOFT_SSII),0),NVL(SUM(CONSOENV_SSII),0)
            from SYNTHESE_ACTIVITE_MOIS s , datdebex d
            where
            s.pid=SYNTHESE_ACTIVITE.pid
            and s.cdeb >= d.datdebex
            )
        WHERE annee in (select to_number(to_char(datdebex,'YYYY')) from datdebex);
        L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes de consommés maj.';
        commit;
-- mise à jour des données complémentaires
L_STATEMENT := '* Compléments';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

        UPDATE SYNTHESE_ACTIVITE
          SET (TYPPROJ,METIER,PNOM,CODSG,DPCODE,ICPI,CODCAMO)=
     (select TYPPROJ,trim(METIER),PNOM,CODSG,DPCODE,ICPI,CODCAMO
     from SYNTHESE_ACTIVITE_MOIS s, datdebex
     where s.pid = SYNTHESE_ACTIVITE.pid
     and s.cdeb >= datdebex
     and s.cdeb in (select max(s1.cdeb) from SYNTHESE_ACTIVITE_MOIS s1 where s1.pid=s.pid  and s1.CDEB >= datdebex    )
     )
WHERE annee in (select to_number(to_char(datdebex,'YYYY')) from datdebex);
L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes de données complémentaires maj.';
COMMIT;


    TRCLOG.TRCLOG( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
EXCEPTION
    when others then
        rollback;
        if sqlcode <> CALLEE_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        end if;
        TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        raise CALLEE_FAILED;


END alim_synth_act;

--***********************************************************
-- Procédure d'alimentation de la table synthese_activite_mois lancée
-- en fin de prémensuelle pour alimenter les données nombre de jours
-- afin d'être utilisées par l'état d'extraction des lignes BIP
-- Les bonnes valeurs sont ensuite mises à jour lors de la mensuelle
--***********************************************************
PROCEDURE alim_synth_act_mois_pre(P_HFILE IN utl_file.file_type)   IS

CURSOR cur_ra IS
select DISTINCT FACTPID,PID,CDEB,TYPPROJ,METIER,PNOM,CODSG,DPCODE,ICPI,CODCAMO,SOCCODE,CONSOJH,CONSOFT,CONSOENV from stock_ra ;

L_PROCNAME  varchar2(30) := 'SYNTH_ACT_MOIS_PRE';
L_STATEMENT varchar2(128);

l_exist NUMBER(1);

BEGIN

TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

-- on vide la table
L_STATEMENT := '* vide synthese_activite_mois du mois courant';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
    DELETE SYNTHESE_ACTIVITE_MOIS
    WHERE cdeb in (select moismens from datdebex);
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table SYNTHESE_ACTIVITE_MOIS';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
COMMIT;


-- on alimente la table de synthese avec les données contenues dans le stock ra

L_STATEMENT := '* alimentation de synthese_activite_mois';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

    INSERT INTO SYNTHESE_ACTIVITE_MOIS (PID,CDEB,TYPPROJ,METIER,PNOM,CODSG,DPCODE,ICPI,CODCAMO,CONSOJH_SG,CONSOJH_SSII,CONSOFT_SG,CONSOFT_SSII,CONSOENV_SG,CONSOENV_SSII)
    (SELECT p.factpid ,p.cdeb, lb.typproj , TRIM(lb.metier), lb.pnom, lb.codsg, lb.dpcode, lb.icpi, lb.codcamo, SUM(cusag) , 0 , 0 , 0 , 0 , 0
     FROM proplus p,  ligne_bip LB, datdebex
     WHERE p.factpid=LB.pid
     AND (p.qualif not in ('MO','GRA','IFO','STA','INT') OR P.qualif is null)
     AND p.cdeb=datdebex.moismens
     AND LB.codsg > 1
     GROUP BY p.factpid ,p.cdeb, lb.typproj , lb.metier, lb.pnom, lb.codsg, lb.dpcode, lb.icpi, lb.codcamo);

      commit;

    TRCLOG.TRCLOG( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
EXCEPTION
    when others then
        rollback;
        if sqlcode <> CALLEE_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        end if;
        TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        raise CALLEE_FAILED;

END alim_synth_act_mois_pre;
--***************************************************************************



-- Procédure d'alimentation de la table synthese_activite : stock sur l'annee
-- en fin de prémensuelle pour alimenter les données nombre de jours
-- afin d'être utilisées par l'état d'extraction suivi financier
-- Les bonnes valeurs sont ensuite mises à jour lors de la mensuelle
--***************************************************************************
PROCEDURE alim_synth_act_pre(P_HFILE IN utl_file.file_type)   IS

L_PROCNAME  varchar2(20) := 'ALIM_SYNTH_ACT_PRE';
L_STATEMENT varchar2(128);


BEGIN

/**********************************************************************

     ATTENTION TRAITEMENT IDENTIQUE A CELUI DE LA MENSUELLE

***********************************************************************/


TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

-- on vide la table
L_STATEMENT := '* vide synthese_activite de l annee courante';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
    DELETE SYNTHESE_ACTIVITE
    WHERE annee in (select to_number(to_char(datdebex,'YYYY')) from datdebex);
    L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table SYNTHESE_ACTIVITE';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
COMMIT;

-- on alimente la table de synthese avec les données contenues dans synthese_activite_mois

L_STATEMENT := '* alimentation de synthese_activite';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

    INSERT INTO SYNTHESE_ACTIVITE (PID,ANNEE)
      (select DISTINCT PID,to_number(to_char(cdeb,'yyyy'))
       from SYNTHESE_ACTIVITE_MOIS s, datdebex d
       where s.cdeb >= d.datdebex
       );
      L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans SYNTHESE_ACTIVITE.';
      commit;

-- mise à jour des conso
L_STATEMENT := '* consommés';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

        UPDATE SYNTHESE_ACTIVITE
          SET (CONSOJH_SG,CONSOFT_SG,CONSOENV_SG,CONSOJH_SSII,CONSOFT_SSII,CONSOENV_SSII)=
              (select distinct NVL(SUM(CONSOJH_SG),0),NVL(SUM(CONSOFT_SG),0),NVL(SUM(CONSOENV_SG),0) ,
                        NVL(SUM(CONSOJH_SSII),0),NVL(SUM(CONSOFT_SSII),0),NVL(SUM(CONSOENV_SSII),0)
            from SYNTHESE_ACTIVITE_MOIS s , datdebex d
            where
            s.pid=SYNTHESE_ACTIVITE.pid
            and s.cdeb >= d.datdebex
            )
        WHERE annee in (select to_number(to_char(datdebex,'YYYY')) from datdebex);
        L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes de consommés maj.';
        commit;
-- mise à jour des données complémentaires
L_STATEMENT := '* Compléments';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

        UPDATE SYNTHESE_ACTIVITE
          SET (TYPPROJ,METIER,PNOM,CODSG,DPCODE,ICPI,CODCAMO)=
     (select TYPPROJ,trim(METIER),PNOM,CODSG,DPCODE,ICPI,CODCAMO
     from SYNTHESE_ACTIVITE_MOIS s, datdebex
     where s.pid = SYNTHESE_ACTIVITE.pid
     and s.cdeb >= datdebex
     and s.cdeb in (select max(s1.cdeb) from SYNTHESE_ACTIVITE_MOIS s1 where s1.pid=s.pid  and s1.CDEB >= datdebex    )
     )
WHERE annee in (select to_number(to_char(datdebex,'YYYY')) from datdebex);
L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes de données complémentaires maj.';
COMMIT;

    TRCLOG.TRCLOG( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
EXCEPTION
    when others then
        rollback;
        if sqlcode <> CALLEE_FAILED_ID then
                TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
        end if;
        TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
        raise CALLEE_FAILED;


END alim_synth_act_pre;


END PACKBATCH_RA;
/

show errors