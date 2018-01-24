-- APPLICATION ISAC
-- -------------------------------------
-- pack_isac_alimentation PL/SQL
-- 
-- Créé le 10/04/2002 par NBM
-- Modifié le 16/05/2003 par NBM : on ne se base plus uniquement sur les consos mais sur la structure 
-- Modifié le 04/03/2004 par PJO : Modif des codes BIP sur 4 caractères
-- Modifié le 16/12/2004 par PPR : Optimisation de la requête ALIMENTATION DE PMW_CONSOMM
--
-- Procédure d'alimentation des tables PMW à partir des tables ISAC
--
-- Attention: il n'y a pas de clé primaire pour les tables PMW_  !!
--*******************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
-- Modifié le 06/06/2008 par EVI: TD 652 SLOT
-- Modifié le 30/12/2008 par EVI: TD 722 Modif dans traitement SLOT
-- Modifié le 06/09/2010 par ABA: TD 1048 
-- Modifié le 29/12/2015 par SEL: PPMs 60612,60709 

create or replace PACKAGE     BIP.pack_isac_alimentation AS
PROCEDURE insert_pmw (P_LOGDIR in varchar2,P_TYPEMENSUELLE in varchar2); --SEL 1766 P_TYPEMENSUELLE

-- FAD PPM 63868 : Début procédure contrôle Axe Métier
PROCEDURE CTRL_AXE_METIER;
-- FAD PPM 63868 : Fin procédure contrôle Axe Métier

END pack_isac_alimentation;
/


create or replace PACKAGE BODY     BIP.pack_isac_alimentation AS
-- Gestions exceptions
-- -------------------
CALLEE_FAILED exception;
pragma exception_init( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !

PROCEDURE insert_pmw (P_LOGDIR in varchar2,P_TYPEMENSUELLE in varchar2) IS --SEL 1766 P_TYPEMENSUELLE


L_HFILE utl_file.file_type;
L_RETCOD number;
l_jj_carre number;
l_mm_carre number;
l_aa_carre number;
l_datedujour varchar2(10);
l_nextmens varchar2(10);
l_exist number;
l_tot_ligne number;
l_insert_ligne number;
l_insert_ligne_forfait NUMBER;
l_delete_ligne_forfait NUMBER;
l_exist_ligne number;
l_num_tp VERSION_TP.NUMTP%TYPE;
nnligne NUMBER;

-- Curseur qui recupere les forfait SLOT
CURSOR curseur_fident IS SELECT DISTINCT TO_CHAR(sr.fident,'FM00000')||'*' IDENT
    from isac_consomme c,isac_affectation a, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d, situ_ress_full sr
    where   c.sous_tache=a.sous_tache
        and a.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')
	--FAD PPM 64368 : ajout de la joiture par ident
	and c.ident = a.ident
	--FAD PPM 64368 : Fin
        -- jointure isac_consomme et situ_ress_full
    and sr.ident=c.ident
	AND (c.cdeb >=sr.datsitu OR sr.datsitu IS NULL)
	AND (c.cdeb <=sr.datdep OR sr.datdep IS NULL )
    and sr.fident is not null;

BEGIN
    -- Init de la trace
    -- ----------------

    L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , 'ISAC_ALIMENTATION', L_HFILE );

    if ( L_RETCOD <> 0 ) then
        raise_application_error( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 false );
    end if;

    -- Trace Start
    -- -----------


   --SEL PPM 60709 5.5  Rejeter les types etapes des données des fichier .BIP avant les P2
      TRCLOG.TRCLOG( L_HFILE, 'Debut du traitement de rejet des types etapes des données des fichier .BIP');




      insert into TMP_REJETMENS_BIPS
      (
      select c.pid,(select codsg from ligne_bip where pid=c.pid),
       c.ccet,c.ccta,c.ccst,replace(c.cires,'*',''),c.cdeb,c.cusag,'La ligne '||c.pid||' contient un type d''étape incompatible avec votre entité et/ou la ligne Bip '
      from pmw_consomm c, pmw_activite a where
      c.pid= a.pid
      and c.ccet=a.acet
      and c.ccta=a.acta
      and c.ccst=a.acst
      and pack_remontee.check_etapetype_f(c.pid, c.ccet||c.ccta||c.ccst, a.aiet, 'LA') like 'REJET'
      )
      ;
      commit;
      
      DELETE pmw_consomm where pid|| ccet|| ccta||ccst|| cdeb|| replace(cires,'*','') in (
      
      select c.pid||c.ccet||c.ccta||c.ccst||c.cdeb||replace(c.cires,'*','')
      from pmw_consomm c, pmw_activite a where
      c.pid= a.pid
      and c.ccet=a.acet
      and c.ccta=a.acta
      and c.ccst=a.acst
      and pack_remontee.check_etapetype_f(c.pid, c.ccet||c.ccta||c.ccst, a.aiet, 'LA') like 'REJET'
      
      );
      commit;
      
      DELETE pmw_activite where pid|| acet|| acta||acst in (
      
      select c.pid||c.ccet||c.ccta||c.ccst
      from pmw_consomm c, pmw_activite a where
      c.pid= a.pid
      and c.ccet=a.acet
      and c.ccta=a.acta
      and c.ccst=a.acst
      and pack_remontee.check_etapetype_f(c.pid, c.ccet||c.ccta||c.ccst, a.aiet, 'LA') like 'REJET'
      
      );
       commit;
       
       DELETE pmw_affecta where pid|| tcet|| tcta||tcst|| replace(tires,'*','') in (
      
      select c.pid||c.ccet||c.ccta||c.ccst||replace(c.cires,'*','')
      from pmw_consomm c, pmw_activite a where
      c.pid= a.pid
      and c.ccet=a.acet
      and c.ccta=a.acta
      and c.ccst=a.acst
      and pack_remontee.check_etapetype_f(c.pid, c.ccet||c.ccta||c.ccst, a.aiet, 'LA') like 'REJET'
      
      );
      commit;
      
       DELETE pmw_ligne_bip where pid in (
      
      select c.pid
      from pmw_consomm c, pmw_activite a where
      c.pid= a.pid
      and c.ccet=a.acet
      and c.ccta=a.acta
      and c.ccst=a.acst
      and pack_remontee.check_etapetype_f(c.pid, c.ccet||c.ccta||c.ccst, a.aiet, 'LA') like 'REJET'
      
      );
      commit;
   
    --SEL PPM 60612 Traiter les P2 (avant la saisie directe)
    TRCLOG.TRCLOG( L_HFILE, 'Debut du traitement d''insertion BIPS(P2) vers PMW');
    PACK_BATCH_BIPS.insert_bips_to_pmw(P_LOGDIR,P_TYPEMENSUELLE); --SEL PPM 60612 QC 1766 P_TYPEMENSUELLE
    TRCLOG.TRCLOG( L_HFILE, 'Debut du traitement ISAC' );

    -- Calcul du carré du jour,du mois et de l'année de traitement
    select    POWER(TO_NUMBER(TO_CHAR(sysdate,'dd')),2),
        POWER(TO_NUMBER(TO_CHAR(sysdate,'mm')),2),
        POWER(TO_NUMBER(TO_CHAR(sysdate,'yy')),2),
        to_char(sysdate,'dd/mm/yyyy'),
        to_char(cmensuelle,'dd/mm/yyyy')
        into l_jj_carre,l_mm_carre,l_aa_carre, l_datedujour, l_nextmens
    from datdebex;


---------------------------------------------------------------------------------------------------------
    -- ALIMENTATION DE PMW_LIGNE_BIP
---------------------------------------------------------------------------------------------------------
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'ALIMENTATION DE LA TABLE PMW_LIGNE_BIP');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    l_tot_ligne := 0;
    l_insert_ligne := 0;

    -- On initialise le numero de version de la remontee BIP
    SELECT numtp INTO l_num_tp
    FROM version_tp
    WHERE dattp IN (SELECT MAX(dattp) FROM version_tp)
    ;

    -- On prend toutes les lignes BIP d'ISAC
    /*select count(distinct pid)  into l_insert_ligne
    from isac_etape
    where  pid not in (select pid from pmw_ligne_bip);*/

    insert into pmw_ligne_bip (pid,pmwbipvers,p_jj_carre,p_mm_carre,p_aa_carre)
    (select distinct pid ,l_num_tp,l_jj_carre,l_mm_carre,l_aa_carre
    from isac_etape
    where  pid not in (select pid from pmw_ligne_bip));
	l_insert_ligne := SQL%ROWCOUNT;


    --TRCLOG.TRCLOG( L_HFILE, 'Nombre Total de lignes BIP :'||l_tot_ligne);
    TRCLOG.TRCLOG( L_HFILE, l_insert_ligne ||' lignes insérées');


---------------------------------------------------------------------------------------------------------
    -- ALIMENTATION DE PMW_ACTIVITE
---------------------------------------------------------------------------------------------------------
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'ALIMENTATION DE LA TABLE PMW_ACTIVITE');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    l_insert_ligne := 0;

    -- On prend toutes les sous-tâches d'ISAC
    /*select count(distinct st.pid||e.ecet||t.acta||st.acst ) into l_insert_ligne
    from  isac_sous_tache st, isac_tache t, isac_etape e, datdebex d
    where   st.tache=t.tache
    and t.etape=e.etape
    and st.pid not in (select pid from pmw_activite )
    --and pack_remontee.check_etapetype_f(st.pid, e.ecet||t.acta||st.acst, e.typetape, 'AF') not like 'REJET'
    ;*/


    insert into pmw_activite (pid,acet,acta,acst,aiet,aist,asta,
                adeb,afin,ande,anfi,asnom,adur)
    (select distinct st.pid as PID, e.ecet ACET, t.acta ACTA, st.acst ACST,
             e.typetape AIET, st.aist AIST, st.asta ASTA,st.adeb ADEB, st.afin AFIN,
             st.ande ANDE, st.anfi ANFI,st.asnom ASNOM, st.adur ADUR
    from  isac_sous_tache st, isac_tache t, isac_etape e
    where   st.tache=t.tache
    and t.etape=e.etape
    and st.pid not in (select pid from pmw_activite )
    --and pack_remontee.check_etapetype_f(st.pid, e.ecet||t.acta||st.acst, e.typetape, 'AF') not like 'REJET'
    );
	l_insert_ligne := SQL%ROWCOUNT;

    --TRCLOG.TRCLOG( L_HFILE, 'Nombre Total de lignes à insérer:'||l_tot_ligne);
    TRCLOG.TRCLOG( L_HFILE, l_insert_ligne ||' lignes insérées');
    --TRCLOG.TRCLOG( L_HFILE, l_exist_ligne ||' lignes déjà existantes' );

---------------------------------------------------------------------------------------------------------
    -- ALIMENTATION DE PMW_AFFECTA
---------------------------------------------------------------------------------------------------------
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'ALIMENTATION DE LA TABLE PMW_AFFECTA');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    l_insert_ligne := 0;
    l_insert_ligne_forfait := 0;


    /****** RESSOURCE HORS SLOT *****/
    -- On prend toutes les affectations d'ISAC + cumul des consommés pour l'année en cours
    /*select count(1) into  l_insert_ligne
    from (select a.pid as PID, e.ecet TCET, t.acta TCTA, st.acst TCST,
    TO_CHAR(a.ident,'FM00000')||'*' TIRES,
    sum(cusag) TACTU
    from isac_consomme c,isac_affectation a, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d
    where   c.sous_tache=a.sous_tache
        and a.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
	--FAD PPM 64368 : ajout de la joiture par ident
	and c.ident = a.ident
	--FAD PPM 64368 : Fin
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')
    and a.pid not in (select pid from pmw_affecta )
    
    --and pack_remontee.check_etapetype_f(a.pid, e.ecet||t.acta||st.acst, e.typetape, 'AF') not like 'REJET'
    
    group by a.pid,e.ecet,t.acta,st.acst,a.ident
    MINUS
    select a.pid as PID, e.ecet TCET, t.acta TCTA, st.acst TCST,
        TO_CHAR(a.ident,'FM00000')||'*' TIRES,
         sum(cusag) TACTU
    from isac_consomme c,isac_affectation a, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d, situ_ress_full sr
    where   c.sous_tache=a.sous_tache
        and a.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')
	--FAD PPM 64368 : ajout de la joiture par ident
	and c.ident = a.ident
	--FAD PPM 64368 : Fin
    -- jointure isac_consomme et situ_ress_full
    and sr.ident=c.ident
	AND (c.cdeb >=sr.datsitu OR sr.datsitu IS NULL)
	AND (c.cdeb <=sr.datdep OR sr.datdep IS NULL )
    -- on retire les ressource attache a un forfait (SLOT)
    and sr.fident is not null
         and a.pid not in (select pid from pmw_affecta )
    group by a.pid,e.ecet,t.acta,st.acst,a.ident);*/

    -----------------------------------------------
    -- On insert toutes les ressources hors SLOT
    insert into pmw_affecta (pid,tcet,tcta,tcst,tires,tactu)
    (select a.pid as PID, e.ecet TCET, t.acta TCTA, st.acst TCST,
    TO_CHAR(a.ident,'FM00000')||'*' TIRES,
    sum(cusag) TACTU
    from isac_consomme c,isac_affectation a, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d
    where   c.sous_tache=a.sous_tache
        and a.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
	--FAD PPM 64368 : ajout de la joiture par ident
	and c.ident = a.ident
	--FAD PPM 64368 : Fin
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')
    and a.pid not in (select pid from pmw_affecta )
    
    --and pack_remontee.check_etapetype_f(a.pid, e.ecet||t.acta||st.acst, e.typetape, 'AF') not like 'REJET'
    
    group by a.pid,e.ecet,t.acta,st.acst,a.ident
    MINUS
    select a.pid as PID, e.ecet TCET, t.acta TCTA, st.acst TCST,
        TO_CHAR(a.ident,'FM00000')||'*' TIRES,
         sum(cusag) TACTU
    from isac_consomme c,isac_affectation a, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d, situ_ress_full sr
    where   c.sous_tache=a.sous_tache
        and a.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')
	--FAD PPM 64368 : ajout de la joiture par ident
	and c.ident = a.ident
	--FAD PPM 64368 : Fin
    -- jointure isac_consomme et situ_ress_full
    and sr.ident=c.ident
	AND (c.cdeb >=sr.datsitu OR sr.datsitu IS NULL)
	AND (c.cdeb <=sr.datdep OR sr.datdep IS NULL )
    -- on retire les ressource attache a un forfait (SLOT)
    and sr.fident is not null
         and a.pid not in (select pid from pmw_affecta )
    group by a.pid,e.ecet,t.acta,st.acst,a.ident);
	l_insert_ligne := SQL%ROWCOUNT;

    TRCLOG.TRCLOG( L_HFILE, l_insert_ligne ||' lignes insérées (Ressources hors SLOT)');

    /****** RESSOURCE SLOT *****/
    -- Mise en commentaire du DELETE: plutot que de supprimer apres on insere aucun consomme sur la ressource Forfait SLOT a l'etzpe precedente
    -- Suppression des forfaits SLOT
    l_delete_ligne_forfait :=0;
    FOR curseur IN curseur_fident  LOOP
    DELETE FROM PMW_AFFECTA WHERE tires=curseur.ident;
    l_delete_ligne_forfait := l_delete_ligne_forfait+1;
    END LOOP;
    TRCLOG.TRCLOG( L_HFILE, l_delete_ligne_forfait ||' lignes delete (Consommé saisie sur forfait SLOT)');

    -- Insertion des forfait ou il y a des SLOT
    /*select count(1) into l_insert_ligne_forfait
    FROM (select a.pid as PID, e.ecet TCET, t.acta TCTA, st.acst TCST,
        TO_CHAR(sr.fident,'FM00000')||'*' TIRES,
         sum(cusag) TACTU
    from isac_consomme c,isac_affectation a, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d, situ_ress_full sr
    where   c.sous_tache=a.sous_tache
        and a.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')
	--FAD PPM 64368 : ajout de la joiture par ident
	and c.ident = a.ident
	--FAD PPM 64368 : Fin
    -- jointure isac_consomme et situ_ress_full
    and sr.ident=c.ident
	AND (c.cdeb >=sr.datsitu OR sr.datsitu IS NULL)
	AND (c.cdeb <=sr.datdep OR sr.datdep IS NULL )
    and sr.fident is not null
    
    --and pack_remontee.check_etapetype_f(a.pid, e.ecet||t.acta||st.acst, e.typetape, 'AF') not like 'REJET'
    
    group by a.pid,e.ecet,t.acta,st.acst,sr.fident );*/

    insert into pmw_affecta (pid,tcet,tcta,tcst,tires,tactu)
        (select a.pid as PID, e.ecet TCET, t.acta TCTA, st.acst TCST,
        TO_CHAR(sr.fident,'FM00000')||'*' TIRES,
         sum(cusag) TACTU
    from isac_consomme c,isac_affectation a, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d, situ_ress_full sr
    where   c.sous_tache=a.sous_tache
        and a.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')
	--FAD PPM 64368 : ajout de la joiture par ident
	and c.ident = a.ident
	--FAD PPM 64368 : Fin
    -- jointure isac_consomme et situ_ress_full
    and sr.ident=c.ident
	AND (c.cdeb >=sr.datsitu OR sr.datsitu IS NULL)
	AND (c.cdeb <=sr.datdep OR sr.datdep IS NULL )
    and sr.fident is not null
    group by a.pid,e.ecet,t.acta,st.acst,sr.fident);
	l_insert_ligne_forfait := SQL%ROWCOUNT;
	
    TRCLOG.TRCLOG( L_HFILE, l_insert_ligne_forfait ||' lignes insérées (Forfait SLOT)');

---------------------------------------------------------------------------------------------------------
    -- ALIMENTATION DE PMW_CONSOMM
---------------------------------------------------------------------------------------------------------
    l_tot_ligne := 0;
    l_insert_ligne := 0;
    l_insert_ligne_forfait := 0;

    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'ALIMENTATION DE LA TABLE PMW_CONSOMM');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');


    /****** RESSOURCE HORS SLOT *****/
    -- On prend tous les consommés d'ISAC pour l'année en cours
    /*select count(1) into  l_insert_ligne
    from (select c.pid as PID, e.ecet CCET, t.acta CCTA, st.acst CCST, TO_CHAR(c.ident,'FM00000')||'*' CIRES,
        c.cdeb CDEB, st.adur CDUR, c.cusag CUSAG,'1' CHTYP
    from isac_consomme c, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d
    where c.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')
    and c.pid in (  select distinct pid from isac_consomme
            minus
            select distinct pid from pmw_consomm )


    and pack_remontee.check_etapetype_f(c.pid, e.ecet||t.acta||st.acst, e.typetape, 'AF') not like 'REJET'


    MINUS
    select c.pid as PID, e.ecet CCET, t.acta CCTA, st.acst CCST, TO_CHAR(c.ident,'FM00000')||'*' CIRES,
        c.cdeb CDEB, st.adur CDUR, c.cusag CUSAG,'1' CHTYP
    from isac_consomme c, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d, situ_ress_full sr
    where c.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')
    and c.pid in (  select distinct pid from isac_consomme
            minus
            select distinct pid from pmw_consomm )
    -- jointure isac_consomme et situ_ress_full
    and sr.ident=c.ident
	AND (c.cdeb >=sr.datsitu OR sr.datsitu IS NULL)
	AND (c.cdeb <=sr.datdep OR sr.datdep IS NULL )
    and sr.fident is not null
    );*/

    insert into pmw_consomm (pid,ccet,ccta,ccst,cires,cdeb,cdur,cusag,chtyp)
    (select c.pid as PID, e.ecet CCET, t.acta CCTA, st.acst CCST, TO_CHAR(c.ident,'FM00000')||'*' CIRES,
        c.cdeb CDEB, st.adur CDUR, c.cusag CUSAG,'1' CHTYP
    from isac_consomme c, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d
    where c.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')
    and c.pid in (  select distinct pid from isac_consomme
            minus
            select distinct pid from pmw_consomm )
            
    and pack_remontee.check_etapetype_f(c.pid, e.ecet||t.acta||st.acst, e.typetape, 'AF') not like 'REJET'
    
    MINUS
    select c.pid as PID, e.ecet CCET, t.acta CCTA, st.acst CCST, TO_CHAR(c.ident,'FM00000')||'*' CIRES,
        c.cdeb CDEB, st.adur CDUR, c.cusag CUSAG,'1' CHTYP
    from isac_consomme c, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d, situ_ress_full sr
    where c.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')
    and c.pid in (  select distinct pid from isac_consomme
            minus
            select distinct pid from pmw_consomm )
    -- jointure isac_consomme et situ_ress_full
    and sr.ident=c.ident
	AND (c.cdeb >=sr.datsitu OR sr.datsitu IS NULL)
	AND (c.cdeb <=sr.datdep OR sr.datdep IS NULL )
    -- on retire les ressource attache a un forfait (SLOT)
    and sr.fident is not null
    );
	l_insert_ligne := SQL%ROWCOUNT;
	
    --TRCLOG.TRCLOG( L_HFILE, 'Nombre Total de lignes à insérer:'||l_tot_ligne);
    TRCLOG.TRCLOG( L_HFILE, l_insert_ligne ||' lignes insérées (Ressources hors SLOT)');


    /****** RESSOURCE SLOT *****/
    -- Mise en commentaire du DELETE: plutot que de supprimer apres on insere aucun consomme sur la ressource Forfait SLOT a l'etzpe precedente

    -- Suppression des consommé remonté sur les forfait avec des ressources SLOT
    l_delete_ligne_forfait :=0;
    FOR curseur IN curseur_fident  LOOP
    DELETE FROM PMW_CONSOMM WHERE cires=curseur.ident;
    l_delete_ligne_forfait := l_delete_ligne_forfait+1;
    END LOOP;
    TRCLOG.TRCLOG( L_HFILE, l_delete_ligne_forfait ||' lignes delete (Consommé saisie sur forfait SLOT)');

    -- Insertion des forfait avec SLOT
    /*select count(1) into  l_insert_ligne_forfait
    from (select c.pid as PID, e.ecet CCET, t.acta CCTA, st.acst CCST, TO_CHAR(sr.fident,'FM00000')||'*' CIRES,
        c.cdeb CDEB, st.adur CDUR, sum(c.cusag) CUSAG,'1' CHTYP
    from isac_consomme c, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d, situ_ress_full sr
    where c.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')
    -- jointure isac_consomme et situ_ress_full
    and sr.ident=c.ident
	AND (c.cdeb >=sr.datsitu OR sr.datsitu IS NULL)
	AND (c.cdeb <=sr.datdep OR sr.datdep IS NULL )
    and sr.fident is not null




    and pack_remontee.check_etapetype_f(c.pid, e.ecet||t.acta||st.acst, e.typetape, 'AF') not like 'REJET'

    group by c.pid, e.ecet, t.acta, st.acst,sr.fident,c.cdeb, st.adur
    );*/

    insert into pmw_consomm (pid,ccet,ccta,ccst,cires,cdeb,cdur,cusag,chtyp)
    (select c.pid as PID, e.ecet CCET, t.acta CCTA, st.acst CCST, TO_CHAR(sr.fident,'FM00000')||'*' CIRES,
        c.cdeb CDEB, st.adur CDUR, sum(c.cusag) CUSAG,'1' CHTYP
    from isac_consomme c, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d, situ_ress_full sr
    where c.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')
    -- jointure isac_consomme et situ_ress_full
    and sr.ident=c.ident
	AND (c.cdeb >=sr.datsitu OR sr.datsitu IS NULL)
	AND (c.cdeb <=sr.datdep OR sr.datdep IS NULL )
    and sr.fident is not null




    and pack_remontee.check_etapetype_f(c.pid, e.ecet||t.acta||st.acst, e.typetape, 'AF') not like 'REJET'

    group by c.pid, e.ecet, t.acta, st.acst,sr.fident,c.cdeb, st.adur);
	l_insert_ligne_forfait := SQL%ROWCOUNT;

    TRCLOG.TRCLOG( L_HFILE, l_insert_ligne_forfait ||' lignes insérées (Forfait SLOT)');

	---------------------------------------'---------------------------------------'---------------------------------------'---------------------------------------
	--FAD PPM 64368 : rejets des Conso depuis la table PMW_AFFECTA
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'ALIMENTATION DES REJETS DES TAILLES DES CONSOMMES');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Purge des anciens rejets des tailles des consommés');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	
	DELETE FROM TMP_REJETMENS_TAIL;
	nnligne := SQL%ROWCOUNT;
	TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) supprimée(s)');
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Controle : 1 - Début Log "Dépassement de capacité refusé pour 1 ressource, 1 s/tâche et 1 mois"');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	-- 1 - Début Log "Dépassement de capacité refusé pour 1 ressource, 1 s/tâche et 1 mois" --
	/*INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour 1 ressource, 1 s/tâche et 1 mois'
	FROM PMW_CONSOMM WHERE (PID, CIRES, CCET, CCTA, CCST, CDEB) IN
	(SELECT PID, CIRES, CCET, CCTA, CCST, CDEB
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY PID, CIRES, CCET, CCTA, CCST, CDEB HAVING SUM(CUSAG) > 999.99));*/
	
	INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour 1 ressource, 1 s/tâche et 1 mois'
	FROM PMW_CONSOMM,
	(SELECT PID, CIRES, CCET, CCTA, CCST, CDEB
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY PID, CIRES, CCET, CCTA, CCST, CDEB HAVING SUM(CUSAG) > 999.99) REQ
	WHERE PMW_CONSOMM.PID = REQ.PID
	AND PMW_CONSOMM.CIRES = REQ.CIRES
	AND PMW_CONSOMM.CCET = REQ.CCET
	AND PMW_CONSOMM.CCTA = REQ.CCTA
	AND PMW_CONSOMM.CCST = REQ.CCST
	AND PMW_CONSOMM.CDEB = REQ.CDEB);

	
	nnligne := SQL%ROWCOUNT;
	TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) rejetée(s)');
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	IF (nnligne <> 0) THEN
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		TRCLOG.TRCLOG( L_HFILE, 'Suppression lignes rejetées : 1 - Début Log "Dépassement de capacité refusé pour 1 ressource, 1 s/tâche et 1 mois"');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		DELETE FROM PMW_CONSOMM WHERE (PID, CIRES, CCET, CCTA, CCST, CDEB) IN
		(SELECT PID, CIRES, CCET, CCTA, CCST, CDEB
		FROM PMW_CONSOMM, DATDEBEX
		WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
		GROUP BY PID, CIRES, CCET, CCTA, CCST, CDEB HAVING SUM(CUSAG) > 999.99);
		nnligne := SQL%ROWCOUNT;
		TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) supprimé(s)');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	END IF;
	-- 1 - Fin Log "Dépassement de capacité refusé pour 1 ressource, 1 s/tâche et 1 mois" --

	-- 2 - Début Log "Dépassement de capacité refusé pour 1 ressource, 1 s/tâche et l'année" --
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Controle : 2 - Début Log "Dépassement de capacité refusé pour 1 ressource, 1 s/tâche et l''année"');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	/*INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour 1 ressource, 1 s/tâche et l''année'
	FROM PMW_CONSOMM WHERE (PID, CIRES, CCET, CCTA, CCST) IN
	(SELECT PID, CIRES, CCET, CCTA, CCST
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY PID, CIRES, CCET, CCTA, CCST HAVING SUM(CUSAG) > 99999.99)
	);*/

	INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour 1 ressource, 1 s/tâche et l''année'
	FROM PMW_CONSOMM,
	(SELECT PID, CIRES, CCET, CCTA, CCST
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY PID, CIRES, CCET, CCTA, CCST HAVING SUM(CUSAG) > 99999.99) REQ
	WHERE PMW_CONSOMM.PID = REQ.PID
	AND PMW_CONSOMM.CIRES = REQ.CIRES
	AND PMW_CONSOMM.CCET = REQ.CCET
	AND PMW_CONSOMM.CCTA = REQ.CCTA
	AND PMW_CONSOMM.CCST = REQ.CCST
	);
	nnligne := SQL%ROWCOUNT;
	TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) rejetée(s)');
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	IF (nnligne <> 0) THEN
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		TRCLOG.TRCLOG( L_HFILE, 'Suppression lignes rejetées : 2 - Début Log "Dépassement de capacité refusé pour 1 ressource, 1 s/tâche et l''année"');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		DELETE FROM PMW_CONSOMM WHERE (PID, CIRES, CCET, CCTA, CCST) IN
		(SELECT PID, CIRES, CCET, CCTA, CCST
		FROM PMW_CONSOMM, DATDEBEX
		WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
		GROUP BY PID, CIRES, CCET, CCTA, CCST HAVING SUM(CUSAG) > 99999.99);
		nnligne := SQL%ROWCOUNT;
		TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) supprimé(s)');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	END IF;

	-- 2 - Fin Log "Dépassement de capacité refusé pour 1 ressource, 1 s/tâche et l'année" --

	-- 3 - Début Log "Dépassement de capacité refusé pour 1 ressource, 1 ligne BIP et 1 mois" --
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Controle : 3 - Début Log "Dépassement de capacité refusé pour 1 ressource, 1 ligne BIP et 1 mois"');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	/*INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour 1 ressource, 1 ligne BIP et 1 mois'
	FROM PMW_CONSOMM WHERE (PID, CIRES, CDEB) IN
	(SELECT PID, CIRES, CDEB
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY PID, CIRES, CDEB HAVING SUM(CUSAG) > 99999.99)
	);*/
	INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour 1 ressource, 1 ligne BIP et 1 mois'
	FROM PMW_CONSOMM,
	(SELECT PID, CIRES, CDEB
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY PID, CIRES, CDEB HAVING SUM(CUSAG) > 99999.99) REQ
	WHERE PMW_CONSOMM.PID = REQ.PID
	AND PMW_CONSOMM.CIRES = REQ.CIRES
	AND PMW_CONSOMM.CDEB = REQ.CDEB
	);
	nnligne := SQL%ROWCOUNT;
	TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) rejetée(s)');
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	IF (nnligne <> 0) THEN
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		TRCLOG.TRCLOG( L_HFILE, 'Suppression lignes rejetées : 3 - Début Log "Dépassement de capacité refusé pour 1 ressource, 1 ligne BIP et 1 mois"');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		DELETE FROM PMW_CONSOMM WHERE (PID, CIRES, CDEB) IN
		(SELECT PID, CIRES, CDEB
		FROM PMW_CONSOMM, DATDEBEX
		WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
		GROUP BY PID, CIRES, CDEB HAVING SUM(CUSAG) > 99999.99);
		nnligne := SQL%ROWCOUNT;
		TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) supprimé(s)');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	END IF;
	-- 3 - Fin Log "Dépassement de capacité refusé pour 1 ressource, 1 ligne BIP et 1 mois" --

	-- 4 - Début Log "Dépassement de capacité refusé pour 1 ressource, toutes lignes BIP et 1 mois" --
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Controle : 4 - Début Log "Dépassement de capacité refusé pour 1 ressource, toutes lignes BIP et 1 mois"');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	/*INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour 1 ressource, toutes lignes BIP et 1 mois'
	FROM PMW_CONSOMM WHERE (CIRES, CDEB) IN
	(SELECT CIRES, CDEB
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY CIRES, CDEB HAVING SUM(CUSAG) > 999999.99));*/
	INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour 1 ressource, toutes lignes BIP et 1 mois'
	FROM PMW_CONSOMM,
	(SELECT CIRES, CDEB
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY CIRES, CDEB HAVING SUM(CUSAG) > 999999.99) REQ
	WHERE PMW_CONSOMM.CIRES = REQ.CIRES
	AND PMW_CONSOMM.CDEB = REQ.CDEB
	);
	nnligne := SQL%ROWCOUNT;
	TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) rejetée(s)');
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	IF (nnligne <> 0) THEN
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		TRCLOG.TRCLOG( L_HFILE, 'Suppression lignes rejetées : 4 - Début Log "Dépassement de capacité refusé pour 1 ressource, toutes lignes BIP et 1 mois"');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		DELETE FROM PMW_CONSOMM WHERE (CIRES, CDEB) IN
		(SELECT CIRES, CDEB
		FROM PMW_CONSOMM, DATDEBEX
		WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
		GROUP BY CIRES, CDEB HAVING SUM(CUSAG) > 999999.99);
		nnligne := SQL%ROWCOUNT;
		TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) supprimé(s)');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	END IF;
	-- 4 - Fin Log "Dépassement de capacité refusé pour 1 ressource, toutes lignes BIP et 1 mois" --

	-- 5 - Début Log "Dépassement de capacité refusé pour toutes ressources, 1 s/tâche et 1 mois" --
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Controle : 5 - Début Log "Dépassement de capacité refusé pour toutes ressources, 1 s/tâche et 1 mois"');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	/*INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour toutes ressources, 1 s/tâche et 1 mois'
	FROM PMW_CONSOMM WHERE (PID, CCET, CCTA, CCST, CDEB) IN
	(SELECT PID, CCET, CCTA, CCST, CDEB
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY PID, CCET, CCTA, CCST, CDEB HAVING SUM(CUSAG) > 99999.99));*/
	INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour toutes ressources, 1 s/tâche et 1 mois'
	FROM PMW_CONSOMM,
	(SELECT PID, CCET, CCTA, CCST, CDEB
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY PID, CCET, CCTA, CCST, CDEB HAVING SUM(CUSAG) > 99999.99) REQ
	WHERE PMW_CONSOMM.PID = REQ.PID
	AND PMW_CONSOMM.CCET = REQ.CCET
	AND PMW_CONSOMM.CCTA = REQ.CCTA
	AND PMW_CONSOMM.CCST = REQ.CCST
	AND PMW_CONSOMM.CDEB = REQ.CDEB
	);
	nnligne := SQL%ROWCOUNT;
	TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) rejetée(s)');
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	IF (nnligne <> 0) THEN
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		TRCLOG.TRCLOG( L_HFILE, 'Suppression lignes rejetées : 5 - Début Log "Dépassement de capacité refusé pour toutes ressources, 1 s/tâche et 1 mois"');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		DELETE FROM PMW_CONSOMM WHERE (PID, CCET, CCTA, CCST, CDEB) IN
		(SELECT PID, CCET, CCTA, CCST, CDEB
		FROM PMW_CONSOMM, DATDEBEX
		WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
		GROUP BY PID, CCET, CCTA, CCST, CDEB HAVING SUM(CUSAG) > 99999.99);
		nnligne := SQL%ROWCOUNT;
		TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) supprimé(s)');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	END IF;
	-- 5 - Fin Log "Dépassement de capacité refusé pour toutes ressources, 1 s/tâche et 1 mois" --

	-- 6 - Début Log "Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et 1 mois" --
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Controle : 6 - Début Log "Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et 1 mois"');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	/*INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et 1 mois'
	FROM PMW_CONSOMM WHERE (PID, CDEB) IN
	(SELECT PID, CDEB
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY PID, CDEB HAVING SUM(CUSAG) > 999999.99));*/
	INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et 1 mois'
	FROM PMW_CONSOMM,
	(SELECT PID, CDEB
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY PID, CDEB HAVING SUM(CUSAG) > 999999.99) REQ
	WHERE PMW_CONSOMM.PID = REQ.PID
	AND PMW_CONSOMM.CDEB = REQ.CDEB
	);
	nnligne := SQL%ROWCOUNT;
	TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) rejetée(s)');
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	IF (nnligne <> 0) THEN
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		TRCLOG.TRCLOG( L_HFILE, 'Suppression lignes rejetées : 6 - Début Log "Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et 1 mois"');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		DELETE FROM PMW_CONSOMM WHERE (PID, CDEB) IN
		(SELECT PID, CDEB
		FROM PMW_CONSOMM, DATDEBEX
		WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
		GROUP BY PID, CDEB HAVING SUM(CUSAG) > 999999.99);
		nnligne := SQL%ROWCOUNT;
		TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) supprimé(s)');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	END IF;
	-- 6 - Fin Log "Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et 1 mois" --

	-- 7 - Début Log "Dépassement de capacité refusé pour 1 ressource, toutes lignes BIP et l'année" --
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Controle : 7 - Début Log "Dépassement de capacité refusé pour 1 ressource, toutes lignes BIP et l''année"');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	/*INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour 1 ressource, toutes lignes BIP et l''année'
	FROM PMW_CONSOMM WHERE CIRES IN
	(SELECT CIRES
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY CIRES HAVING SUM(CUSAG) > 9999999.99));*/
	INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour 1 ressource, toutes lignes BIP et l''année'
	FROM PMW_CONSOMM,
	(SELECT CIRES
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY CIRES HAVING SUM(CUSAG) > 9999999.99) REQ
	WHERE PMW_CONSOMM.CIRES = REQ.CIRES
	);
	nnligne := SQL%ROWCOUNT;
	TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) rejetée(s)');
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	IF (nnligne <> 0) THEN
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		TRCLOG.TRCLOG( L_HFILE, 'Suppression lignes rejetées : 7 - Début Log "Dépassement de capacité refusé pour 1 ressource, toutes lignes BIP et l''année"');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		DELETE FROM PMW_CONSOMM WHERE CIRES IN
		(SELECT CIRES
		FROM PMW_CONSOMM, DATDEBEX
		WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
		GROUP BY CIRES HAVING SUM(CUSAG) > 9999999.99);
		nnligne := SQL%ROWCOUNT;
		TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) supprimé(s)');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	END IF;
	-- 7 - Fin Log "Dépassement de capacité refusé pour 1 ressource, toutes lignes BIP et l'année" --

	-- 8 - Début Log "Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et l'année" --
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Controle : 8 - Début Log "Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et l''année"');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	/*INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et l''année'
	FROM PMW_CONSOMM WHERE PID IN
	(SELECT PID
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY PID HAVING SUM(CUSAG) > 9999999.99));*/
	INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et l''année'
	FROM PMW_CONSOMM,
	(SELECT PID
	FROM PMW_CONSOMM, DATDEBEX
	WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
	GROUP BY PID HAVING SUM(CUSAG) > 9999999.99) REQ
	WHERE PMW_CONSOMM.PID = REQ.PID
	);
	nnligne := SQL%ROWCOUNT;
	TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) rejetée(s)');
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	IF (nnligne <> 0) THEN
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		TRCLOG.TRCLOG( L_HFILE, 'Suppression lignes rejetées : 8 - Début Log "Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et l''année"');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		DELETE FROM PMW_CONSOMM WHERE PID IN
		(SELECT PID
		FROM PMW_CONSOMM, DATDEBEX
		WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
		GROUP BY PID HAVING SUM(CUSAG) > 9999999.99);
		nnligne := SQL%ROWCOUNT;
		TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) supprimé(s)');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	END IF;
	-- 8 - Fin Log "Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et l'année" --

	-- 9 - Début Log "Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et toutes les années" --
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Controle : 9 - Début Log "Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et toutes les années"');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	/*INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et toutes les années'
	FROM PMW_CONSOMM WHERE PID IN 
	(SELECT PID
	FROM
		(SELECT PID, CUSAG
		FROM PMW_CONSOMM, DATDEBEX
		WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
		UNION ALL
		SELECT PID, CUSAG
		FROM CONS_SSTACHE_RES_MOIS, DATDEBEX
		WHERE CDEB < DATDEBEX)
	GROUP BY PID
	HAVING SUM(CUSAG) > 999999999.99));*/
	INSERT INTO TMP_REJETMENS_TAIL
	(SELECT PMW_CONSOMM.PID, (SELECT CODSG FROM LIGNE_BIP WHERE LIGNE_BIP.PID = PMW_CONSOMM.PID), PMW_CONSOMM.CCET, PMW_CONSOMM.CCTA, PMW_CONSOMM.CCST,
	TO_CHAR(REPLACE(PMW_CONSOMM.CIRES, '*', '')), PMW_CONSOMM.CDEB, PMW_CONSOMM.CUSAG,
	'Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et toutes les années'
	FROM PMW_CONSOMM,
	(SELECT PID
	FROM
		(SELECT PID, CUSAG
		FROM PMW_CONSOMM, DATDEBEX
		WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
		UNION ALL
		SELECT PID, CUSAG
		FROM CONS_SSTACHE_RES_MOIS, DATDEBEX
		WHERE CDEB < DATDEBEX)
	GROUP BY PID
	HAVING SUM(CUSAG) > 999999999.99) REQ
	WHERE PMW_CONSOMM.PID = REQ.PID
	);
	nnligne := SQL%ROWCOUNT;
	TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) rejetée(s)');
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	IF (nnligne <> 0) THEN
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		TRCLOG.TRCLOG( L_HFILE, 'Suppression lignes rejetées : 9 - Début Log "Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et toutes les années"');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		DELETE FROM PMW_CONSOMM WHERE PID IN
		(SELECT PID
		FROM
			(SELECT PID, CUSAG
			FROM PMW_CONSOMM, DATDEBEX
			WHERE CDEB >= DATDEBEX AND CDEB <= MOISMENS
			UNION ALL
			SELECT PID, CUSAG
			FROM CONS_SSTACHE_RES_MOIS, DATDEBEX
			WHERE CDEB < DATDEBEX)
		GROUP BY PID
		HAVING SUM(CUSAG) > 999999999.99);
		nnligne := SQL%ROWCOUNT;
		TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) supprimé(s)');
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	END IF;
	-- 9 - Fin Log "Dépassement de capacité refusé pour toutes ressources, 1 ligne BIP et toutes les années" --

	-- MAJ données dans les tables PMW suite au controle des consommés
	-- PMW_AFFECTA
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Suppression des lignes PMW_AFFECTA rejetées');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	DELETE FROM PMW_AFFECTA WHERE (PID, TCET, TCTA, TCST, TIRES) NOT IN
	(SELECT DISTINCT PID, CCET, CCTA, CCST, CIRES FROM PMW_CONSOMM);
	nnligne := SQL%ROWCOUNT;
	TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) supprimé(s)');
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Modification du total consommé de la table PMW_AFFECTA');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	--FAD QC 1927 PPM 64368 : Utilisation du MERGE pour optimiser la requête UPDATE PMW_AFFECTA
	MERGE INTO PMW_AFFECTA PA
	USING (SELECT PID, CCET, CCTA, CCST, CIRES, SUM(CUSAG) CUSAG
	FROM PMW_CONSOMM
	GROUP BY PID, CCET, CCTA, CCST, CIRES) PC
	ON (PA.PID = PC.PID AND PA.TCET = PC.CCET AND PA.TCTA = PC.CCTA AND PC.CCST = PA.TCST AND PA.TIRES = PC.CIRES)
	WHEN MATCHED THEN
	UPDATE SET PA.TACTU = PC.CUSAG;
	nnligne := SQL%ROWCOUNT;
	TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) mise(s) à jour');
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	-- PMW_ACTIVITE
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Suppression des lignes PMW_ACTIVITE rejetées');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	DELETE FROM PMW_ACTIVITE WHERE (PID, ACET, ACTA, ACST) NOT IN
	(SELECT DISTINCT PID, CCET, CCTA, CCST FROM PMW_CONSOMM);
	nnligne := SQL%ROWCOUNT;
	TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) supprimé(s)');
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	-- PMW_LIGNE_BIP
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Suppression des lignes pmw_ligne_bip rejetées');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	DELETE FROM pmw_ligne_bip WHERE PID NOT IN
	(SELECT DISTINCT PID FROM PMW_CONSOMM);
	nnligne := SQL%ROWCOUNT;
	TRCLOG.TRCLOG( L_HFILE, nnligne || ' ligne(s) supprimé(s)');
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'FIN ALIMENTATION DES REJETS DES TAILLES DES CONSOMMES');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	
	--FAD PPM 64368 : Fin
	---------------------------------------'---------------------------------------'---------------------------------------'---------------------------------------

---------------------------------------------------------------------------------------------------------
    -- ALIMENTATION DES REJETS SAISIE DIRECTES
---------------------------------------------------------------------------------------------------------
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'ALIMENTATION DES REJETS DE LA SAISIE DIRECTE');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    --Debut insertion rejet données saisie réalisée
     INSERT INTO TMP_REJETMENS_TAIL
 (select c.pid as PID, l.codsg, e.ecet CCET, t.acta CCTA, st.acst CCST, TO_CHAR(c.ident,'FM00000') CIRES,
        c.cdeb CDEB, c.cusag CUSAG,'REJET pour la ligne '||c.pid||', ressource '||TO_CHAR(c.ident,'FM00000')||', activité '||e.ecet||t.acta||st.acst||' et début de période consommée '||c.cdeb||' : le type d''étape est incompatible avec votre entité et/ou la ligne Bip' MOTIF_REJET
    from isac_consomme c, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d,ligne_bip l
    where c.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
    and c.pid=l.pid
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')
    and c.pid in (  select distinct pid from isac_consomme

            /*minus
            select distinct pid from pmw_consomm */
            )


    and pack_remontee.check_etapetype_f(c.pid, e.ecet||t.acta||st.acst, e.typetape, 'AF') like 'REJET'
    );
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'FIN ALIMENTATION DES REJETS DE LA SAISIE DIRECTE');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');

	-- FAD PPM 63868 : Début procédure contrôle Axe Métier
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'ALIMENTATION DES WARNINGS RELATIFS AUX AXES METIERS');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	BEGIN
		CTRL_AXE_METIER;
	EXCEPTION WHEN OTHERS THEN
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
		TRCLOG.TRCLOG( L_HFILE, 'ERREUR DANS ALIMENTATION DES WARNINGS RELATIFS AUX AXES METIERS');
		TRCLOG.TRCLOG( L_HFILE, SQLCODE || ' - ' || SQLERRM);
		TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
	END;
	TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'FIN ALIMENTATION DES WARNINGS RELATIFS AUX AXES METIERS');
    TRCLOG.TRCLOG( L_HFILE, '---------------------------------------');
    --Fin insertion rejet données saisie réalisée
    
    --Debut insertion des warnings de la donnée Tache Axe Metier
    /*INSERT INTO tmp_rejetmens_bips(
    select c.pid as PID, l.codsg, e.ecet CCET, t.acta CCTA, st.acst CCST, TO_CHAR(c.ident,'FM00000') CIRES,
        c.cdeb CDEB, c.cusag CUSAG,
        decode(pack_remontee.check_TacheAxeMetier(c.pid,t.tacheaxemetier),
        'A','Warning pour la ligne '||c.pid||', ressource '||TO_CHAR(c.ident,'FM00000')||', activité '||e.ecet||t.acta||st.acst||' et début de période consommée '||c.cdeb||' : la référence de demande est absente, inexistante ou incompatible avec la ligne',
        'P','Warning pour la ligne '||c.pid||', ressource '||TO_CHAR(c.ident,'FM00000')||', activité '||e.ecet||t.acta||st.acst||' et début de période consommée '||c.cdeb||' : la référence de demande est déjà mentionnée sur un Projet Bip, ce qui est incohérent',
        'D','Warning pour la ligne '||c.pid||', ressource '||TO_CHAR(c.ident,'FM00000')||', activité '||e.ecet||t.acta||st.acst||' et début de période consommée '||c.cdeb||' : la référence de demande est déjà mentionnée sur un lot DPCOPI, ce qui est incohérent'
        )  MOTIF_REJET


    from isac_consomme c, isac_sous_tache st, isac_tache t, isac_etape e, datdebex d,ligne_bip l
    where c.sous_tache=st.sous_tache
    and st.tache=t.tache
    and t.etape=e.etape
    and c.pid=l.pid
    and TRUNC(cdeb,'YEAR')= TRUNC(d.datdebex,'YEAR')





    and c.pid in (  select distinct pid from isac_consomme )

    and pack_remontee.check_TacheAxeMetier(c.pid,t.tacheaxemetier) not in ('N','OK')

    );*/
    --Fin
	-- FAD PPM 63868 : Fin procédure contrôle Axe Métier
    -- Trace Stop
    -- ----------
    TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ISAC'  );
    TRCLOG.CLOSETRCLOG( L_HFILE );

    commit;
EXCEPTION
    WHEN OTHERS THEN
	ROLLBACK;
	TRCLOG.TRCLOG( L_HFILE, 'Fin anormale de ISAC'  );
	TRCLOG.CLOSETRCLOG( L_HFILE );
END insert_pmw;

-- FAD PPM 63868 : Début procédure contrôle Axe Métier
PROCEDURE CTRL_AXE_METIER IS
	CONTROLE_NIVEAU VARCHAR2(6);
	ERR VARCHAR2(150);
	L_DP_COPI DOSSIER_PROJET_COPI.DP_COPI%TYPE;
	L_DPCOPIAXEMETIER DOSSIER_PROJET_COPI.DPCOPIAXEMETIER%TYPE;
	L_DIRECTION CLIENT_MO.CLIDIR%TYPE;
	L_CODE_ACTION LIGNE_PARAM_BIP.CODE_ACTION%TYPE;
	L_OBLIGATOIRE LIGNE_PARAM_BIP.OBLIGATOIRE%TYPE;
	L_VALEUR LIGNE_PARAM_BIP.VALEUR%TYPE;
	L_ACTIF LIGNE_PARAM_BIP.ACTIF%TYPE;
	L_DDETYPE DMP_RESEAUXFRANCE.DDETYPE%TYPE;
	L_ICPI PROJ_INFO.ICPI%TYPE;
	L_PROJAXEMETIER PROJ_INFO.PROJAXEMETIER%TYPE;
	L_RET VARCHAR2(5);
	nbrC NUMBER;
BEGIN
	FOR CUR IN (SELECT DISTINCT C.PID, L.CODSG FROM ISAC_CONSOMME C, ISAC_SOUS_TACHE ST, ISAC_TACHE T, ISAC_ETAPE E, DATDEBEX D,LIGNE_BIP L
		WHERE C.SOUS_TACHE=ST.SOUS_TACHE
		AND ST.TACHE=T.TACHE
		AND T.ETAPE=E.ETAPE
		AND C.PID=L.PID
		AND TRUNC(CDEB,'YEAR')= TRUNC(D.DATDEBEX,'YEAR'))
	LOOP
		ERR := NULL;
		-- Début contrôle niveau DPCOPI
		BEGIN
			SELECT DOSSIER_PROJET_COPI.DP_COPI, DOSSIER_PROJET_COPI.DPCOPIAXEMETIER INTO L_DP_COPI, L_DPCOPIAXEMETIER
			FROM LIGNE_BIP, PROJ_INFO, DOSSIER_PROJET_COPI
			WHERE LIGNE_BIP.PID = CUR.PID
			AND LIGNE_BIP.ICPI = PROJ_INFO.ICPI
			AND PROJ_INFO.DP_COPI = DOSSIER_PROJET_COPI.DP_COPI;

			BEGIN
				SELECT CMO.CLIDIR INTO L_DIRECTION
				FROM CLIENT_MO CMO, DOSSIER_PROJET_COPI DP
				WHERE DP.DP_COPI = L_DP_COPI
				AND DP.CLICODE = CMO.CLICODE;
			
				SELECT CODE_ACTION, OBLIGATOIRE, VALEUR, ACTIF
				INTO L_CODE_ACTION, L_OBLIGATOIRE, L_VALEUR, L_ACTIF
				FROM LIGNE_PARAM_BIP
				WHERE CODE_ACTION = 'AXEMETIER_' || L_DIRECTION
				AND CODE_VERSION LIKE 'DPC%';

				IF L_OBLIGATOIRE = 'O' THEN
					IF L_DPCOPIAXEMETIER IS NULL THEN
						INSERT INTO TMP_REJETMENS_TAIL
						SELECT C.PID, L.CODSG, E.ECET, T.ACTA, ST.ACST, C.IDENT, C.CDEB, C.CUSAG, 'Warning pour la ligne ' || C.PID || ' : la référence de demande est absente du lot DPCOPI, ou inexistante ou incompatible avec le DPCOPI'
						FROM ISAC_CONSOMME C, ISAC_SOUS_TACHE ST, ISAC_TACHE T, ISAC_ETAPE E, DATDEBEX D,LIGNE_BIP L
						WHERE C.SOUS_TACHE=ST.SOUS_TACHE
						AND ST.TACHE=T.TACHE
						AND T.ETAPE=E.ETAPE
						and C.PID=L.PID
						AND C.PID = CUR.PID
						AND TRUNC(CDEB,'YEAR')= TRUNC(D.DATDEBEX,'YEAR') AND ROWNUM = 1;
						CONTROLE_NIVEAU := 'TACHE';
					ELSE
						BEGIN
							SELECT DDETYPE INTO L_DDETYPE FROM DMP_RESEAUXFRANCE WHERE TRIM(DMPNUM) = L_DPCOPIAXEMETIER AND ROWNUM = 1;
							IF L_DDETYPE <> 'P' THEN
								INSERT INTO TMP_REJETMENS_TAIL
								SELECT C.PID, L.CODSG, E.ECET, T.ACTA, ST.ACST, C.IDENT, C.CDEB, C.CUSAG, 'Warning pour la ligne ' || CUR.PID || ' : la référence de demande est absente du lot DPCOPI, ou inexistante ou incompatible avec le DPCOPI'
								FROM ISAC_CONSOMME C, ISAC_SOUS_TACHE ST, ISAC_TACHE T, ISAC_ETAPE E, DATDEBEX D,LIGNE_BIP L
								WHERE C.SOUS_TACHE=ST.SOUS_TACHE
								AND ST.TACHE=T.TACHE
								AND T.ETAPE=E.ETAPE
								and C.PID=L.PID
								AND C.PID = CUR.PID
								AND TRUNC(CDEB,'YEAR')= TRUNC(D.DATDEBEX,'YEAR') AND ROWNUM = 1;
								CONTROLE_NIVEAU := 'TACHE';
							ELSE
								CONTROLE_NIVEAU := 'TACHE';
							END IF;
						EXCEPTION WHEN NO_DATA_FOUND THEN
							INSERT INTO TMP_REJETMENS_TAIL
							SELECT C.PID, L.CODSG, E.ECET, T.ACTA, ST.ACST, C.IDENT, C.CDEB, C.CUSAG, 'Warning pour la ligne ' || CUR.PID || ' : la référence de demande est absente du lot DPCOPI, ou inexistante ou incompatible avec le DPCOPI'
							FROM ISAC_CONSOMME C, ISAC_SOUS_TACHE ST, ISAC_TACHE T, ISAC_ETAPE E, DATDEBEX D,LIGNE_BIP L
							WHERE C.SOUS_TACHE=ST.SOUS_TACHE
							AND ST.TACHE=T.TACHE
							AND T.ETAPE=E.ETAPE
							and C.PID=L.PID
							AND C.PID = CUR.PID
							AND TRUNC(CDEB,'YEAR')= TRUNC(D.DATDEBEX,'YEAR') AND ROWNUM = 1;
							CONTROLE_NIVEAU := 'TACHE';
						END;
					END IF;
				ELSE
					IF L_DPCOPIAXEMETIER IS NULL THEN
						CONTROLE_NIVEAU := 'PROJET';
					ELSE
						CONTROLE_NIVEAU := 'TACHE';
					END IF;
				END IF;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				CONTROLE_NIVEAU := 'PROJET';
			END;
			
		EXCEPTION WHEN NO_DATA_FOUND THEN
			CONTROLE_NIVEAU := 'PROJET';
		END;
		-- Fin contrôle niveau DPCOPI

		-- Début contrôle niveau PROJET
		IF CONTROLE_NIVEAU = 'PROJET' THEN
			BEGIN
				SELECT PROJ_INFO.ICPI, PROJ_INFO.PROJAXEMETIER INTO L_ICPI, L_PROJAXEMETIER
				FROM LIGNE_BIP, PROJ_INFO
				WHERE LIGNE_BIP.PID = CUR.PID
				AND LIGNE_BIP.ICPI = PROJ_INFO.ICPI;

				BEGIN
					SELECT CMO.CLIDIR INTO L_DIRECTION
					FROM CLIENT_MO CMO, PROJ_INFO PI
					WHERE PI.ICPI = L_ICPI
					AND PI.CLICODE = CMO.CLICODE;
				EXCEPTION WHEN NO_DATA_FOUND THEN
					--ERR := NULL;
					--CONTROLE_NIVEAU := 'TACHE';
					BEGIN
						SELECT PI.CODSG INTO L_DIRECTION FROM STRUCT_INFO SI, PROJ_INFO PI WHERE PI.ICPI = L_ICPI AND  PI.CODSG = SI.CODSG;
					EXCEPTION WHEN NO_DATA_FOUND THEN
						L_DIRECTION := NULL;
					END;
				END;
				BEGIN
					SELECT CODE_ACTION, OBLIGATOIRE, VALEUR, ACTIF
					INTO L_CODE_ACTION, L_OBLIGATOIRE, L_VALEUR, L_ACTIF
					FROM LIGNE_PARAM_BIP
					WHERE CODE_ACTION = 'AXEMETIER_' || L_DIRECTION
					AND CODE_VERSION LIKE 'PRJ%';

					IF L_OBLIGATOIRE = 'O' THEN
						IF L_PROJAXEMETIER IS NULL THEN
							INSERT INTO TMP_REJETMENS_TAIL
							SELECT C.PID, L.CODSG, E.ECET, T.ACTA, ST.ACST, C.IDENT, C.CDEB, C.CUSAG, 'Warning pour la ligne ' || CUR.PID || ' : la référence de demande est absente du Projet, ou inexistante ou incompatible avec le Projet'
							FROM ISAC_CONSOMME C, ISAC_SOUS_TACHE ST, ISAC_TACHE T, ISAC_ETAPE E, DATDEBEX D,LIGNE_BIP L
							WHERE C.SOUS_TACHE=ST.SOUS_TACHE
							AND ST.TACHE=T.TACHE
							AND T.ETAPE=E.ETAPE
							and C.PID=L.PID
							AND C.PID = CUR.PID
							AND TRUNC(CDEB,'YEAR')= TRUNC(D.DATDEBEX,'YEAR') AND ROWNUM = 1;
							CONTROLE_NIVEAU := NULL;
						ELSE
							BEGIN
								SELECT DDETYPE INTO L_DDETYPE FROM DMP_RESEAUXFRANCE WHERE TRIM(DMPNUM) = L_PROJAXEMETIER AND ROWNUM = 1;
							EXCEPTION WHEN NO_DATA_FOUND THEN
								L_DDETYPE := NULL;
							END;
							IF (L_DDETYPE <> 'E' AND L_DDETYPE <> 'P') OR L_DDETYPE IS NULL THEN
								INSERT INTO TMP_REJETMENS_TAIL
								SELECT C.PID, L.CODSG, E.ECET, T.ACTA, ST.ACST, C.IDENT, C.CDEB, C.CUSAG, 'Warning pour la ligne ' || CUR.PID || ' : la référence de demande est absente du Projet, ou inexistante ou incompatible avec le Projet'
								FROM ISAC_CONSOMME C, ISAC_SOUS_TACHE ST, ISAC_TACHE T, ISAC_ETAPE E, DATDEBEX D,LIGNE_BIP L
								WHERE C.SOUS_TACHE=ST.SOUS_TACHE
								AND ST.TACHE=T.TACHE
								AND T.ETAPE=E.ETAPE
								and C.PID=L.PID
								AND C.PID = CUR.PID
								AND TRUNC(CDEB,'YEAR')= TRUNC(D.DATDEBEX,'YEAR') AND ROWNUM = 1;
								CONTROLE_NIVEAU := NULL;
							END IF;
							
						END IF;
					ELSE
						CONTROLE_NIVEAU := 'TACHE';
					END IF;
				EXCEPTION WHEN NO_DATA_FOUND THEN
					CONTROLE_NIVEAU := 'TACHE';
				END;
			EXCEPTION WHEN NO_DATA_FOUND THEN
				CONTROLE_NIVEAU := 'TACHE';
			END;
		END IF;
		-- Fin contrôle niveau PROJET

		-- Début contrôle niveau TÂCHE
		IF CONTROLE_NIVEAU = 'TACHE' THEN
			FOR CUR2 IN (SELECT DISTINCT LIGNE_BIP.PID, ISAC_ETAPE.ECET, ISAC_TACHE.ACTA, ISAC_SOUS_TACHE.ACST, ISAC_TACHE.TACHEAXEMETIER, LIGNE_BIP.CODSG, ISAC_CONSOMME.IDENT, ISAC_CONSOMME.CDEB, ISAC_CONSOMME.CUSAG
						FROM LIGNE_BIP
						JOIN ISAC_ETAPE ON LIGNE_BIP.PID = ISAC_ETAPE.PID
						JOIN ISAC_TACHE ON ISAC_ETAPE.ETAPE = ISAC_TACHE.ETAPE
						JOIN ISAC_SOUS_TACHE ON ISAC_TACHE.TACHE = ISAC_SOUS_TACHE.TACHE
						JOIN ISAC_CONSOMME ON ISAC_SOUS_TACHE.SOUS_TACHE = ISAC_CONSOMME.SOUS_TACHE
						WHERE LIGNE_BIP.PID = CUR.PID)
			LOOP
				BEGIN
					SELECT COUNT(*) INTO nbrC FROM TMP_REJETMENS_TAIL WHERE PID = CUR2.PID AND ECET = CUR2.ECET AND ACTA = CUR2.ACTA AND
					(MOTIF_REJET LIKE '%la référence de demande est absente, inexistante ou incompatible avec la ligne%'
					OR MOTIF_REJET LIKE '%la référence de demande est déjà mentionnée sur un Projet Bip, ce qui est incohérent%'
					OR MOTIF_REJET LIKE '%la référence de demande est déjà mentionnée sur un lot DPCOPI, ce qui est incohérent%');
				EXCEPTION WHEN OTHERS THEN
					nbrC := 0;
				END;
				IF (nbrC = 0) THEN
					L_RET := PACK_REMONTEE.CHECK_TACHEAXEMETIER(CUR2.PID, CUR2.TACHEAXEMETIER);
					IF (L_RET NOT IN ('N','OK') AND L_RET IS NOT NULL) THEN
						INSERT INTO TMP_REJETMENS_TAIL VALUES(CUR.PID, CUR2.CODSG, CUR2.ECET, CUR2.ACTA, CUR2.ACST, CUR2.IDENT, CUR2.CDEB, CUR2.CUSAG,
						DECODE(L_RET,
						'A','Warning pour la ligne ' || CUR2.PID || ', activité ' || CUR2.ECET || CUR2.ACTA || ' : la référence de demande est absente, inexistante ou incompatible avec la ligne',
						'P','Warning pour la ligne ' || CUR2.PID || ', activité ' || CUR2.ECET || CUR2.ACTA || ' : la référence de demande est déjà mentionnée sur un Projet Bip, ce qui est incohérent',
						'D','Warning pour la ligne ' || CUR2.PID || ', activité ' || CUR2.ECET || CUR2.ACTA || ' : la référence de demande est déjà mentionnée sur un lot DPCOPI, ce qui est incohérent'
						)
						);
					END IF;
				END IF;
			END LOOP;
		END IF;
		
		-- Fin contrôle niveau TÂCHE
	END LOOP;
END CTRL_AXE_METIER;
-- FAD PPM 63868 : Fin procédure contrôle Axe Métier

END pack_isac_alimentation;
/
