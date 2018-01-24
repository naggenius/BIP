create or replace
PACKAGE     pack_batch_bips AS


TYPE pmw_bips_ListeViewType IS RECORD(
								  P_LIGNEBIPCODE     pmw_bips.LIGNEBIPCODE%type,
                                  P_LIGNEBIPCLE				     pmw_bips.LIGNEBIPCLE%type,
                                  P_STRUCTUREACTION			     pmw_bips.STRUCTUREACTION%type,
                                  P_ETAPENUM				     pmw_bips.ETAPENUM%type,
                                  P_ETAPETYPE					     pmw_bips.ETAPETYPE%type,
                                  P_ETAPELIBEL				     pmw_bips.ETAPELIBEL%type,
                                  P_TACHENUM				     pmw_bips.TACHENUM%type,
                                  P_TACHELIBEL				     pmw_bips.TACHELIBEL%type,
                                  P_TACHEAXEMETIER				     pmw_bips.TACHEAXEMETIER%type,
                                  P_STACHENUM				     pmw_bips.STACHENUM%type,
                                  P_STACHETYPE				     pmw_bips.STACHETYPE%type,
                                  P_STACHELIBEL					     pmw_bips.STACHELIBEL%type,
                                  P_STACHEINITDEBDATE			     pmw_bips.STACHEINITDEBDATE%type,
                                  P_STACHEINITFINDATE			     pmw_bips.STACHEINITFINDATE%type,
                                  P_STACHEREVDEBDATE			     pmw_bips.STACHEREVDEBDATE%type,
                                  P_STACHEREVFINDATE			     pmw_bips.STACHEREVFINDATE%type,
                                  P_STACHESTATUT			     pmw_bips.STACHESTATUT%type,
                                  P_STACHEDUREE					     pmw_bips.STACHEDUREE%type,
                                  P_STACHEPARAMLOCAL			     pmw_bips.STACHEPARAMLOCAL%type,
                                  P_RESSBIPCODE					     pmw_bips.RESSBIPCODE%type,
                                  P_RESSBIPNOM				     pmw_bips.RESSBIPNOM%type,
                                  P_CONSODEBDATE				     pmw_bips.CONSODEBDATE%type,
                                  P_CONSOFINDATE				     pmw_bips.CONSOFINDATE%type,
                                  P_CONSOQTE				     pmw_bips.CONSOQTE%type,
                                  P_PROVENANCE	     pmw_bips.PROVENANCE%type,
                                  P_PRIORITE	     pmw_bips.PRIORITE%type,
                                  P_TOP	     pmw_bips.TOP%type,
                                  P_USER	     pmw_bips.USER_PEC%type,
                                  P_DATE	     pmw_bips.DATE_PEC%type,
                                  P_FICHIER	     pmw_bips.FICHIER%type
                                         );

TYPE pmw_bips_listeCurType IS REF CURSOR RETURN pmw_bips_ListeViewType;

PROCEDURE insert_bips_to_pmw(P_LOGDIR in varchar2,P_TYPEMENSUELLE in varchar2); --SEL 1766 P_TYPEMENSUELLE

PROCEDURE prise_en_charge_bips(P_FICHIER in pmw_bips.FICHIER%type,P_LOGDIR in varchar2);

PROCEDURE insert_intranet_to_bips(P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_LIGNEBIPCLE				  in   pmw_bips.LIGNEBIPCLE%type,
                                  P_STRUCTUREACTION			  in   pmw_bips.STRUCTUREACTION%type,
                                  P_ETAPENUM				  in   pmw_bips.ETAPENUM%type,
                                  P_ETAPETYPE					  in   pmw_bips.ETAPETYPE%type,
                                  P_ETAPELIBEL				  in   pmw_bips.ETAPELIBEL%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_TACHELIBEL				  in   pmw_bips.TACHELIBEL%type,
                                  P_TACHEAXEMETIER				  in   pmw_bips.TACHEAXEMETIER%type, --SEL 6.11.2
                                  P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                                  P_STACHETYPE				  in   pmw_bips.STACHETYPE%type,
                                  P_STACHELIBEL					  in   pmw_bips.STACHELIBEL%type,
                                  P_STACHEINITDEBDATE			  in   pmw_bips.STACHEINITDEBDATE%type,
                                  P_STACHEINITFINDATE			  in   pmw_bips.STACHEINITFINDATE%type,
                                  P_STACHEREVDEBDATE			  in   pmw_bips.STACHEREVDEBDATE%type,
                                  P_STACHEREVFINDATE			  in   pmw_bips.STACHEREVFINDATE%type,
                                  P_STACHESTATUT			  in   pmw_bips.STACHESTATUT%type,
                                  P_STACHEDUREE					  in   pmw_bips.STACHEDUREE%type,
                                  P_STACHEPARAMLOCAL			  in   pmw_bips.STACHEPARAMLOCAL%type,
                                  P_RESSBIPCODE					  in   pmw_bips.RESSBIPCODE%type,
                                  P_RESSBIPNOM				  in   pmw_bips.RESSBIPNOM%type,
                                  P_CONSODEBDATE				  in   pmw_bips.CONSODEBDATE%type,
                                  P_CONSOFINDATE				  in   pmw_bips.CONSOFINDATE%type,
                                  P_CONSOQTE				  in   pmw_bips.CONSOQTE%type,
                                  P_PROVENANCE	  in   pmw_bips.PROVENANCE%type,
                                  P_PRIORITE	  in   pmw_bips.PRIORITE%type,
                                  P_USER	  in   pmw_bips.USER_PEC%type,
                                  P_DATE	  in   pmw_bips.DATE_PEC%type,
                                  P_FICHIER	  in   pmw_bips.FICHIER%type,
                                  P_MESSAGE out VARCHAR2
                                  );


PROCEDURE insert_bulk_to_bips(
                                  P_ARRAY_BIPS in ARRAY_TABLE,
                                  P_PROVENANCE	  in   pmw_bips.PROVENANCE%type,
                                  P_PRIORITE	  in   pmw_bips.PRIORITE%type,
                                  P_USER	  in   pmw_bips.USER_PEC%type,
                                  P_DATE	  in   pmw_bips.DATE_PEC%type,
                                  P_FICHIER	  in   pmw_bips.FICHIER%type,
                                  P_MESSAGE out VARCHAR2

                                  );


PROCEDURE INSERT_AAC_BIPS(P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_LIGNEBIPCLE				  in   pmw_bips.LIGNEBIPCLE%type,
                                  P_STRUCTUREACTION			  in   pmw_bips.STRUCTUREACTION%type,
                                  P_ETAPENUM				  in   pmw_bips.ETAPENUM%type,
                                  P_ETAPETYPE					  in   pmw_bips.ETAPETYPE%type,
                                  P_ETAPELIBEL				  in   pmw_bips.ETAPELIBEL%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_TACHELIBEL				  in   pmw_bips.TACHELIBEL%type,
                                  P_TACHEAXEMETIER				  in   pmw_bips.TACHEAXEMETIER%type, --SEL 6.11.2
                                  P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                                  P_STACHETYPE				  in   pmw_bips.STACHETYPE%type,
                                  P_STACHELIBEL					  in   pmw_bips.STACHELIBEL%type,
                                  P_STACHEINITDEBDATE			  in   pmw_bips.STACHEINITDEBDATE%type,
                                  P_STACHEINITFINDATE			  in   pmw_bips.STACHEINITFINDATE%type,
                                  P_STACHEREVDEBDATE			  in   pmw_bips.STACHEREVDEBDATE%type,
                                  P_STACHEREVFINDATE			  in   pmw_bips.STACHEREVFINDATE%type,
                                  P_STACHESTATUT			  in   pmw_bips.STACHESTATUT%type,
                                  P_STACHEDUREE					  in   pmw_bips.STACHEDUREE%type,
                                  P_STACHEPARAMLOCAL			  in   pmw_bips.STACHEPARAMLOCAL%type,
                                  P_RESSBIPCODE					  in   pmw_bips.RESSBIPCODE%type,
                                  P_RESSBIPNOM				  in   pmw_bips.RESSBIPNOM%type,
                                  P_CONSODEBDATE				  in   pmw_bips.CONSODEBDATE%type,
                                  P_CONSOFINDATE				  in   pmw_bips.CONSOFINDATE%type,
                                  P_CONSOQTE				  in   pmw_bips.CONSOQTE%type,
                                  P_PROVENANCE	  in   pmw_bips.PROVENANCE%type,
                                  P_PRIORITE	  in   pmw_bips.PRIORITE%type,
                                  P_FICHIER     in  pmw_bips.FICHIER%type,
                                  P_RETOUR out VARCHAR2
                                  );

PROCEDURE DELETE_AAC_BIPS(P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_ETAPE			  in   NUMBER,
                                  P_NBCURSEUR	  out   pmw_bips.PROVENANCE%type,
                                  P_RETOUR out VARCHAR2
                                  );

PROCEDURE UPDATE_AAC_BIPS(P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_LIGNEBIPCLE				  in   pmw_bips.LIGNEBIPCLE%type,
                                  P_STRUCTUREACTION			  in   pmw_bips.STRUCTUREACTION%type,
                                  P_ETAPENUM				  in   pmw_bips.ETAPENUM%type,
                                  P_ETAPETYPE					  in   pmw_bips.ETAPETYPE%type,
                                  P_ETAPELIBEL				  in   pmw_bips.ETAPELIBEL%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_TACHELIBEL				  in   pmw_bips.TACHELIBEL%type,
                                  P_TACHEAXEMETIER				  in   pmw_bips.TACHEAXEMETIER%type, --SEL 6.11.2
                                  P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                                  P_STACHETYPE				  in   pmw_bips.STACHETYPE%type,
                                  P_STACHELIBEL					  in   pmw_bips.STACHELIBEL%type,
                                  P_STACHEINITDEBDATE			  in   pmw_bips.STACHEINITDEBDATE%type,
                                  P_STACHEINITFINDATE			  in   pmw_bips.STACHEINITFINDATE%type,
                                  P_STACHEREVDEBDATE			  in   pmw_bips.STACHEREVDEBDATE%type,
                                  P_STACHEREVFINDATE			  in   pmw_bips.STACHEREVFINDATE%type,
                                  P_STACHESTATUT			  in   pmw_bips.STACHESTATUT%type,
                                  P_STACHEDUREE					  in   pmw_bips.STACHEDUREE%type,
                                  P_STACHEPARAMLOCAL			  in   pmw_bips.STACHEPARAMLOCAL%type,
                                  P_RESSBIPCODE					  in   pmw_bips.RESSBIPCODE%type,
                                  P_RESSBIPNOM				  in   pmw_bips.RESSBIPNOM%type,
                                  P_CONSODEBDATE				  in   pmw_bips.CONSODEBDATE%type,
                                  P_CONSOFINDATE				  in   pmw_bips.CONSOFINDATE%type,
                                  P_CONSOQTE				  in   pmw_bips.CONSOQTE%type,
                                  P_PROVENANCE	  in   pmw_bips.PROVENANCE%type,
                                  P_PRIORITE	  in   pmw_bips.PRIORITE%type,
                                  P_FICHIER     in  pmw_bips.FICHIER%type,
                                  P_RETOUR out VARCHAR2
                                  );

PROCEDURE UPDATE_ETAPE_BIPS    (  P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_ETAPENUM				  in   pmw_bips.ETAPENUM%type,
                                  P_ETAPETYPE					  in   pmw_bips.ETAPETYPE%type,
                                  P_ETAPELIBEL				  in   pmw_bips.ETAPELIBEL%type,
                                  P_ETAPEJEU				  in   VARCHAR2,
                                  P_ETAPE out NUMBER,
                                  P_RETOUR out VARCHAR2);

PROCEDURE UPDATE_TACHE_BIPS    (  P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_ETAPENUM   in    pmw_bips.ETAPENUM%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_TACHELIBEL				  in   pmw_bips.TACHELIBEL%type,
                                  P_TACHEAXEMETIER				  in   pmw_bips.TACHEAXEMETIER%type,
                                  P_TACHE out NUMBER,
                                  P_RETOUR out VARCHAR2);

PROCEDURE UPDATE_SOUS_TACHE_BIPS( P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_ETAPENUM   in    pmw_bips.ETAPENUM%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                                  P_STACHETYPE				  in   pmw_bips.STACHETYPE%type,
                                  P_STACHELIBEL					  in   pmw_bips.STACHELIBEL%type,
                                  P_STACHEINITDEBDATE			  in   pmw_bips.STACHEINITDEBDATE%type,
                                  P_STACHEINITFINDATE			  in   pmw_bips.STACHEINITFINDATE%type,
                                  P_STACHEREVDEBDATE			  in   pmw_bips.STACHEREVDEBDATE%type,
                                  P_STACHEREVFINDATE			  in   pmw_bips.STACHEREVFINDATE%type,
                                  P_STACHESTATUT			  in   pmw_bips.STACHESTATUT%type,
                                  P_STACHEDUREE					  in   pmw_bips.STACHEDUREE%type,
                                  P_STACHEPARAMLOCAL			  in   pmw_bips.STACHEPARAMLOCAL%type,
                                  P_SOUS_TACHE out NUMBER,
                                  P_RETOUR out VARCHAR2
                                  );


--SEL 1766
PROCEDURE VERIF_SR_P2( P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_ETAPENUM   in    pmw_bips.ETAPENUM%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                                  P_RETOUR out VARCHAR2
                                  );
--SEL 1766
PROCEDURE UPDATE_BIPS_P2(P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_STRUCTUREACTION			  in   pmw_bips.STRUCTUREACTION%type,
                                  P_ETAPENUM				  in   pmw_bips.ETAPENUM%type,
                                  P_ETAPETYPE					  in   pmw_bips.ETAPETYPE%type,
                                  P_ETAPELIBEL				  in   pmw_bips.ETAPELIBEL%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_TACHELIBEL				  in   pmw_bips.TACHELIBEL%type,
                                  P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                                  P_STACHETYPE				  in   pmw_bips.STACHETYPE%type,
                                  P_STACHELIBEL					  in   pmw_bips.STACHELIBEL%type,
                                  P_STACHEINITDEBDATE			  in   pmw_bips.STACHEINITDEBDATE%type,
                                  P_STACHEINITFINDATE			  in   pmw_bips.STACHEINITFINDATE%type,
                                  P_STACHEREVDEBDATE			  in   pmw_bips.STACHEREVDEBDATE%type,
                                  P_STACHEREVFINDATE			  in   pmw_bips.STACHEREVFINDATE%type,
                                  P_STACHESTATUT			  in   pmw_bips.STACHESTATUT%type,
                                  P_STACHEDUREE					  in   pmw_bips.STACHEDUREE%type,
                                  P_STACHEPARAMLOCAL			  in   pmw_bips.STACHEPARAMLOCAL%type,
                                  P_TOP     IN pmw_bips.TOP%type,
                                  P_TACHEAXEMETIER     IN pmw_bips.TACHEAXEMETIER %type,
                                  P_RETOUR out VARCHAR2
                                  ) ;

--SEL 1766
PROCEDURE INSERT_BIPS_P2(P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_STRUCTUREACTION			  in   pmw_bips.STRUCTUREACTION%type,
                                  P_ETAPENUM				  in   pmw_bips.ETAPENUM%type,
                                  P_ETAPETYPE					  in   pmw_bips.ETAPETYPE%type,
                                  P_ETAPELIBEL				  in   pmw_bips.ETAPELIBEL%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_TACHELIBEL				  in   pmw_bips.TACHELIBEL%type,
                                  P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                                  P_STACHETYPE				  in   pmw_bips.STACHETYPE%type,
                                  P_STACHELIBEL					  in   pmw_bips.STACHELIBEL%type,
                                  P_STACHEINITDEBDATE			  in   pmw_bips.STACHEINITDEBDATE%type,
                                  P_STACHEINITFINDATE			  in   pmw_bips.STACHEINITFINDATE%type,
                                  P_STACHEREVDEBDATE			  in   pmw_bips.STACHEREVDEBDATE%type,
                                  P_STACHEREVFINDATE			  in   pmw_bips.STACHEREVFINDATE%type,
                                  P_STACHESTATUT			  in   pmw_bips.STACHESTATUT%type,
                                  P_STACHEDUREE					  in   pmw_bips.STACHEDUREE%type,
                                  P_STACHEPARAMLOCAL			  in   pmw_bips.STACHEPARAMLOCAL%type,
                                  P_TOP     IN pmw_bips.TOP%type,
                                  P_TACHEAXEMETIER     IN pmw_bips.TACHEAXEMETIER %type,
                                  P_RETOUR out VARCHAR2
                                  ) ;


PROCEDURE LISTER_PMW_BIPS(P_USER_ID in VARCHAR2,
                          P_CURSOR in out pmw_bips_listeCurType,
                          P_MESSAGE OUT VARCHAR2
                            );

PROCEDURE INSERT_REJET_BIPS(P_REJET in varchar2,
                            P_PID in varchar2,
                            P_IDENT in varchar2,
                            P_ACTIVITE in varchar2,
                            P_DEBCONSO in varchar2,
                            P_CUSAG in varchar2,
                            P_TAG in varchar2,
                            P_CODE in varchar2,
                            P_MESSAGE out varchar2);


PROCEDURE DELETE_REJET_MENS_BIPS(P_VAR in varchar2,
                                 P_MESSAGE out varchar2);

--SEL QC 1846                                 
PROCEDURE ARCHIVE_PURGE_PMW_BIPS(P_LOGDIR in varchar2);

END pack_batch_bips;
/

create or replace
PACKAGE BODY       "PACK_BATCH_BIPS" AS

-- Gestions exceptions
-- -------------------
CALLEE_FAILED exception;
insert_etape_existe exception;
insert_tache_existe exception;
insert_sous_tache_existe exception;
no_etape_to_update exception;
no_tache_to_update exception;
no_sous_tache_to_update exception;

/*PRAGMA EXCEPTION_INIT(no_etape_to_update, -1);
PRAGMA EXCEPTION_INIT(no_tache_to_update, -2);
PRAGMA EXCEPTION_INIT(no_sous_tache_to_update, -3);*/

pragma exception_init( CALLEE_FAILED, -20000 );
PRAGMA EXCEPTION_INIT(insert_etape_existe, -20044);
PRAGMA EXCEPTION_INIT(insert_tache_existe, -20045);
PRAGMA EXCEPTION_INIT(insert_sous_tache_existe, -20046);
CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !
P_PID_LE     VARCHAR2(1024) := '0;';   -- PID de la ligne BIP à retenir pour ne pas reprendre dans le traitement
P_ACTIVITE_LA     VARCHAR2(1024) := '';   -- l activité a supprimer suivant le code structure LA

P_LA number := 0;

l_first VARCHAR2(30) := '%_FIRST';
l_last VARCHAR2(30) := '%_LAST';
l_cp number := 0;
P2 VARCHAR2(2):='P2';
P3 VARCHAR2(2):='P3';

PROCEDURE insert_bips_to_pmw (P_LOGDIR in varchar2,P_TYPEMENSUELLE in varchar2) IS --SEL 1766 P_TYPEMENSUELLE



L_HFILE utl_file.file_type;
L_RETCOD number;
l_jj_carre number;
l_mm_carre number;
l_aa_carre number;
l_datedujour varchar2(10);
l_nextmens varchar2(10);
l_insert_ligne number;
l_chaine_pid varchar2(500) := '';

CURSOR l_curseur IS

    SELECT distinct lignebipcode FROM PMW_BIPS
    WHERE top = 'n'
    AND PRIORITE='P2'
    AND LIGNEBIPCODE  NOT IN (select pid from pmw_ligne_bip bip)
    AND LIGNEBIPCODE  NOT IN (select pid from pmw_activite bip)
    AND LIGNEBIPCODE  NOT IN (select pid from pmw_affecta bip)
    AND LIGNEBIPCODE  NOT IN (select pid from pmw_consomm bip)
    ;


BEGIN

     FOR rec IN l_curseur LOOP
    l_chaine_pid := l_chaine_pid||rec.lignebipcode;

    END LOOP;
    -- Init de la trace
    -- ----------------

   L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , 'BATCH_BIPS', L_HFILE);

    if ( L_RETCOD <> 0 ) then
        raise_application_error( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 false );
    end if;

    -- Trace Start
    -- -----------
    TRCLOG.TRCLOG( L_HFILE, 'Debut du traitement BATCH BIPS vers PMW' );

     --SEL 5.5 : supprimer les messages de rejets P2 qui sont OK dans un fichier .BIP
    delete tmp_rejetmens_bips where
    pid in (select pid from pmw_consomm)
    and pid in (select lignebipcode from pmw_bips where top='r' and priorite='P2')
    and upper(substr(motif_rejet, 0, 7)) not like 'WARNING';
    COMMIT;

    -- Calcul du carré du jour,du mois et de l'année de traitement
    select    POWER(TO_NUMBER(TO_CHAR(sysdate,'dd')),2),
        POWER(TO_NUMBER(TO_CHAR(sysdate,'mm')),2),
        POWER(TO_NUMBER(TO_CHAR(sysdate,'yy')),2),
        to_char(sysdate,'dd/mm/yyyy'),
        to_char(cmensuelle,'dd/mm/yyyy')
        into l_jj_carre,l_mm_carre,l_aa_carre, l_datedujour, l_nextmens
    from datdebex;
/*
delete from pmw_ligne_bip l where exists (select * from pmw_bips where pmw_bips.lignebipcode= l.pid);
delete from pmw_activite l where exists (select * from pmw_bips where pmw_bips.lignebipcode= l.pid);
delete from pmw_affecta l where exists (select * from pmw_bips where pmw_bips.lignebipcode= l.pid);
delete from pmw_consomm l where exists (select * from pmw_bips where pmw_bips.lignebipcode= l.pid);*/

-- On prend toutes les lignes BIP de PMW_BIPS
    select count(lignebipcode)  into l_insert_ligne
    from pmw_bips
    where  lignebipcode not in (select pid from pmw_ligne_bip) and top='n' and priorite='P2';


	TRCLOG.TRCLOG( L_HFILE, '------------------------------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'Nombre de lignes BIP en PMW_BIPS (P2) et qui ne sont pas en PMW_LIGNE_BIP : '||l_insert_ligne);
    TRCLOG.TRCLOG( L_HFILE, '------------------------------------------------------------');

---------------------------------------------------------------------------------------------------------
    -- ALIMENTATION DE PMW_LIGNE_BIP
---------------------------------------------------------------------------------------------------------
    TRCLOG.TRCLOG( L_HFILE, '------------------------------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'ALIMENTATION DE LA TABLE PMW_LIGNE_BIP PAR LES DONNEES BIPS');
    TRCLOG.TRCLOG( L_HFILE, '------------------------------------------------------------');




    -- On prend toutes les lignes BIP de la table PMW_BIPS
    insert into pmw_ligne_bip (pid,pmwbipvers,p_jj_carre,p_mm_carre,p_aa_carre,p_saisie) --SEL PPM 60292
    (select distinct lignebipcode ,'42',l_jj_carre,l_mm_carre,l_aa_carre,decode(lb.p_saisie,null,'FBIPS',lb.p_saisie)
    from PMW_BIPS BIPS,ligne_bip lb
    WHERE PRIORITE='P2'
    AND lb.pid = bips.lignebipcode
    AND TOP = 'n'
    AND LIGNEBIPCODE
    NOT IN (select pid from pmw_ligne_bip bip)
    --SEL QC 1870
    AND trim(lignebipcode)||trim(etapenum)||trim(tachenum)||trim(stachenum) 
    in (select trim(lignebipcode)||trim(etapenum)||trim(tachenum)||trim(stachenum) from bips_activite)
    );
     commit;
    TRCLOG.TRCLOG( L_HFILE, 'PMW_LIGNE_BIP ('||sql%rowcount||')');

---------------------------------------------------------------------------------------------------------
    -- ALIMENTATION DE PMW_ACTIVITE
---------------------------------------------------------------------------------------------------------
    TRCLOG.TRCLOG( L_HFILE, '------------------------------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'ALIMENTATION DE LA TABLE PMW_ACTIVITE PAR LES DONNEES BIPS');
    TRCLOG.TRCLOG( L_HFILE, '------------------------------------------------------------');

    /* On prend toutes les lignes BIP de la table PMW_BIPS qui n'ont pas de structure SR et qui ne sont pas dans PMW (P2)
    */
    insert into pmw_activite
    (PID,
    ACET,
    AIET,
    ACTA,
    ACST,
    AIST,
    ASNOM,
    ADEB,
    AFIN,
    ANDE,
    ANFI,
    ASTA,
    ADUR)
    (select distinct
    LIGNEBIPCODE,
    ETAPENUM,
    ETAPETYPE,
    TACHENUM,
    STACHENUM,
    STACHETYPE,
    STACHELIBEL,
    STACHEINITDEBDATE,
    STACHEINITFINDATE,
    STACHEREVDEBDATE,
    STACHEREVFINDATE,
    SUBSTR(STACHESTATUT,1,2),--SEL PPM 60612 QC 1719
    STACHEDUREE
    from PMW_BIPS BIPS

    where LIGNEBIPCODE
    NOT IN (select pid from pmw_activite bip)

    AND PRIORITE='P2'
    AND TOP = 'n'
    --SEL QC 1870
    AND trim(lignebipcode)||trim(etapenum)||trim(tachenum)||trim(stachenum) 
    in (select trim(lignebipcode)||trim(etapenum)||trim(tachenum)||trim(stachenum) from bips_activite)

    );
    commit;
    TRCLOG.TRCLOG( L_HFILE, 'PMW_ACTIVITE ('||sql%rowcount||')');



---------------------------------------------------------------------------------------------------------
    -- ALIMENTATION DE PMW_AFFECTA
---------------------------------------------------------------------------------------------------------
    TRCLOG.TRCLOG( L_HFILE, '------------------------------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'ALIMENTATION DE LA TABLE PMW_AFFECTA PAR LES DONNEES BIPS');
    TRCLOG.TRCLOG( L_HFILE, '------------------------------------------------------------');

    /* On prend toutes les lignes BIP de la table PMW_BIPS qui n'ont pas de structure SR et qui ne sont dans PMW (P2)
    */
    insert into PMW_AFFECTA
    (
    PID,
    TCET,
    TCTA,
    TCST,
    TIRES
    )
    (select distinct
    LIGNEBIPCODE,
    ETAPENUM,
    TACHENUM,
    STACHENUM,
    RESSBIPCODE
    from PMW_BIPS

    where LIGNEBIPCODE
    NOT IN (select pid from PMW_AFFECTA bip)

     AND PRIORITE='P2'
     AND TOP = 'n'
     
     --SEL QC 1870
    AND trim(lignebipcode)||trim(etapenum)||trim(tachenum)||trim(stachenum) 
    in (select trim(lignebipcode)||trim(etapenum)||trim(tachenum)||trim(stachenum) from bips_activite)

    );
     commit;
    TRCLOG.TRCLOG( L_HFILE, 'PMW_AFFECTA ('||sql%rowcount||')');

---------------------------------------------------------------------------------------------------------
    -- ALIMENTATION DE PMW_CONSOMM
---------------------------------------------------------------------------------------------------------
    TRCLOG.TRCLOG( L_HFILE, '------------------------------------------------------------');
    TRCLOG.TRCLOG( L_HFILE, 'ALIMENTATION DE LA TABLE PMW_CONSOMM PAR LES DONNEES BIPS');
    TRCLOG.TRCLOG( L_HFILE, '------------------------------------------------------------');


    /* On prend toutes les lignes BIP de la table PMW_BIPS qui n'ont pas de structure SR et qui ne sont pas dans PMW (P2)
    */
    insert into PMW_CONSOMM
    (
    PID,
    CCET,
    CCTA,
    CCST,
    CIRES,
    CDEB,
    CUSAG,
    CHTYP
    )
    (select distinct
    LIGNEBIPCODE,
    ETAPENUM,
    TACHENUM,
    STACHENUM,
    RESSBIPCODE,
    CONSODEBDATE,
    CONSOQTE,
    1
    from PMW_BIPS

    where LIGNEBIPCODE
    NOT IN (select pid from PMW_CONSOMM bip)

    AND PRIORITE='P2'
    AND TOP = 'n'
    
    --SEL QC 1870
    AND trim(lignebipcode)||trim(etapenum)||trim(tachenum)||trim(stachenum) 
    in (select trim(lignebipcode)||trim(etapenum)||trim(tachenum)||trim(stachenum) from bips_activite)

    );
     commit;
    TRCLOG.TRCLOG( L_HFILE, 'PMW_CONSOMM  ('||sql%rowcount||')');

    /*DEBUT SEL PPM 60292*/ 
    
    /*FIN SEL PPM 60292*/ 


    IF (P_TYPEMENSUELLE LIKE '3' OR P_TYPEMENSUELLE='3') THEN --SEL 1766 P_TYPEMENSUELLE

    update pmw_bips bips
    SET bips.top='o'
    WHERE INSTR (l_chaine_pid,bips.lignebipcode)>0 ;



    END IF;

    /*
    END LOOP;*/

    -- Trace Stop
    -- ----------
    TRCLOG.TRCLOG( L_HFILE, 'Fin normale de BATCH_BIPS.insert_bips_to_pmw'  );
    TRCLOG.CLOSETRCLOG( L_HFILE );
    
    

    commit;
EXCEPTION
    WHEN OTHERS THEN
    TRCLOG.TRCLOG( L_HFILE, 'Fin anormale de BATCH_BIPS.insert_bips_to_pmw :'||SQLERRM  );
    TRCLOG.CLOSETRCLOG( L_HFILE );
    --dbms_output.put_line(SQLERRM);
          ROLLBACK;
END insert_bips_to_pmw;

PROCEDURE prise_en_charge_bips(P_FICHIER in pmw_bips.FICHIER%type,P_LOGDIR in varchar2) IS

L_HFILE utl_file.file_type;
l_exist_sr varchar2(5);
l_retour_pmw varchar2(5);
l_nbcurseur  INTEGER;
l_message  VARCHAR2(5);
l_etape NUMBER(10,0);
l_tache NUMBER(10,0);
l_sstache NUMBER(10,0);
l_activites_isac varchar2(1024);
l_activites_bips varchar2(1024);
l_maj boolean:=true;

p_message varchar2(200);
p_nbcurseur INTEGER;
l_chaine_conso VARCHAR2(1024);
l_chaine_aff VARCHAR2(1024);
l_chaine_conso_date VARCHAR2(1024);
l_nb_mois_conso NUMBER(10,0);
l_exist_aff NUMBER(1);
l_exist_isac NUMBER(1);
l_ligne VARCHAR2(100);


BEGIN

  p_nbcurseur := 0;
  p_message:='';


FOR i in (select distinct * from pmw_bips where 
          upper(priorite) = 'P3' 
          and upper(top) = 'N' 
          and upper(trim(fichier)) = upper(trim(P_FICHIER))
          order by lignebipcode
        ) LOOP

l_ligne := i.LIGNEBIPCODE||i.ETAPENUM||i.TACHENUM||i.STACHENUM||i.CONSODEBDATE;
CASE

/*1 cas LE : toutes les activités doivent exister*/
WHEN i.STRUCTUREACTION = 'LE' THEN

      IF(INSTR(P_PID_LE, i.LIGNEBIPCODE) = 0) THEN  /*La chaine P_PID_LE represente les PID traités, si la ligne est deja traitée, alors on passe*/

        l_activites_isac := '';

        --Rechercher toutes les activités en base
        FOR k in (select distinct e.ECET etape, t.acta tache, s.acst sstache from isac_etape e,isac_tache t, isac_sous_tache s
        where e.pid=i.LIGNEBIPCODE and e.pid=t.pid and t.pid=s.pid) LOOP

        l_activites_isac := l_activites_isac||k.etape||k.tache||k.sstache||';';

        END LOOP;

        --dbms_output.put_line('l_activites_isac : '||i.LIGNEBIPCODE||' - '||l_activites_isac);
        --Pour chaque activité provenant du fichier BIPS, on teste si elle existe en base
        FOR j in (select * from pmw_bips where lignebipcode = i.LIGNEBIPCODE and upper(top) <> 'O'  ) LOOP

        l_activites_bips := j.etapenum||j.tachenum||j.stachenum;
        --dbms_output.put_line('l_activites_bips : '||i.LIGNEBIPCODE||' - '||l_activites_bips);
        --une fois on ne trouve pas une activité ,venue du fichier, en base, on annule toutes mise à jour
          IF (INSTR(l_activites_isac,l_activites_bips) = 0) THEN

          l_maj := false;
          P_PID_LE := P_PID_LE||i.LIGNEBIPCODE||';';
          goto end_loop;

          ELSE

          l_maj := true;
          END IF;

         END LOOP;



 <<end_loop>>

  IF(l_maj = true) THEN
--dbms_output.put_line('MAJ : '||i.LIGNEBIPCODE||' - '||to_number(i.ETAPENUM)||' '||to_number(i.TACHENUM)||' '||to_number(i.STACHENUM));
  UPDATE_AAC_BIPS(i.LIGNEBIPCODE  ,
                                  i.LIGNEBIPCLE				 ,
                                  i.STRUCTUREACTION			 ,
                                  i.ETAPENUM				 ,
                                  i.ETAPETYPE					 ,
                                  i.ETAPELIBEL				 ,
                                  i.TACHENUM				  ,
                                  i.TACHELIBEL			,
                                  i.TACHEAXEMETIER			,
                                  i.STACHENUM				 ,
                                  i.STACHETYPE				 ,
                                  i.STACHELIBEL					 ,
                                  i.STACHEINITDEBDATE			  ,
                                  i.STACHEINITFINDATE			  ,
                                  i.STACHEREVDEBDATE			  ,
                                  i.STACHEREVFINDATE			 ,
                                  i.STACHESTATUT			  ,
                                  i.STACHEDUREE					  ,
                                  i.STACHEPARAMLOCAL			  ,
                                  i.RESSBIPCODE					  ,
                                  i.RESSBIPNOM				  ,
                                  i.CONSODEBDATE				  ,
                                  i.CONSOFINDATE				  ,
                                  i.CONSOQTE				 ,
                                  i.PROVENANCE	 ,
                                  i.PRIORITE,
                                  i.FICHIER,
                                  p_message);


  --ELSE

  --dbms_output.put_line('Mise à jour non autorisée pour : '||i.LIGNEBIPCODE||' - '||to_number(i.ETAPENUM)||' '||to_number(i.TACHENUM)||' '||to_number(i.STACHENUM));

  END IF;



END IF;

/*2 cas AE : analyse individuelle : l'activité doit exister pour la mettre a jour*/
WHEN i.STRUCTUREACTION = 'AE' THEN

  BEGIN

      select distinct 1 into l_exist_sr from isac_etape e,isac_tache t, isac_sous_tache s
    where
    e.pid=i.LIGNEBIPCODE
    and e.pid=t.pid
    and t.pid=s.pid
    and t.etape= e.etape
    and s.tache= t.tache
    and e.ecet = i.ETAPENUM
    and t.acta = i.TACHENUM
    and s.acst = i.STACHENUM
    ORDER BY e.pid
      ;

      --Le SR doit exiter pour la mettre à jour , sinon on passe à l'enregistrement suivant
      UPDATE_AAC_BIPS(i.LIGNEBIPCODE  ,
                                  i.LIGNEBIPCLE				 ,
                                  i.STRUCTUREACTION			 ,
                                  i.ETAPENUM				 ,
                                  i.ETAPETYPE					 ,
                                  i.ETAPELIBEL				 ,
                                  i.TACHENUM				  ,
                                  i.TACHELIBEL			,
                                  i.TACHEAXEMETIER			,
                                  i.STACHENUM				 ,
                                  i.STACHETYPE				 ,
                                  i.STACHELIBEL					 ,
                                  i.STACHEINITDEBDATE			  ,
                                  i.STACHEINITFINDATE			  ,
                                  i.STACHEREVDEBDATE			  ,
                                  i.STACHEREVFINDATE			 ,
                                  i.STACHESTATUT			  ,
                                  i.STACHEDUREE					  ,
                                  i.STACHEPARAMLOCAL			  ,
                                  i.RESSBIPCODE					  ,
                                  i.RESSBIPNOM				  ,
                                  i.CONSODEBDATE				  ,
                                  i.CONSOFINDATE				  ,
                                  i.CONSOQTE				 ,
                                  i.PROVENANCE	 ,
                                  i.PRIORITE,
                                  i.FICHIER,
                                  p_message);


  --EXCEPTION
  --WHEN NO_DATA_FOUND THEN
  --dbms_output.put_line('aucune donnée trouvée : '||i.LIGNEBIPCODE||' - '||to_number(i.ETAPENUM)||' '||to_number(i.TACHENUM)||' '||to_number(i.STACHENUM));
  END;

/*3 cas AF : analyse individuelle : MAJ ou  CREATION*/
WHEN i.STRUCTUREACTION = 'AF' THEN

BEGIN

      select distinct 1 into l_exist_sr from isac_etape e,isac_tache t, isac_sous_tache s
    where
    e.pid=i.LIGNEBIPCODE
    and e.pid=t.pid
    and t.pid=s.pid
    and t.etape= e.etape
    and s.tache= t.tache
    and e.ecet = i.ETAPENUM
    and t.acta = i.TACHENUM
    and s.acst = i.STACHENUM
    ORDER BY e.pid
      ;

      --Si le SR existe , on la mets à jour
      UPDATE_AAC_BIPS(i.LIGNEBIPCODE  ,
                                  i.LIGNEBIPCLE				 ,
                                  i.STRUCTUREACTION			 ,
                                  i.ETAPENUM				 ,
                                  i.ETAPETYPE					 ,
                                  i.ETAPELIBEL				 ,
                                  i.TACHENUM				  ,
                                  i.TACHELIBEL			,
                                  i.TACHEAXEMETIER			,
                                  i.STACHENUM				 ,
                                  i.STACHETYPE				 ,
                                  i.STACHELIBEL					 ,
                                  i.STACHEINITDEBDATE			  ,
                                  i.STACHEINITFINDATE			  ,
                                  i.STACHEREVDEBDATE			  ,
                                  i.STACHEREVFINDATE			 ,
                                  i.STACHESTATUT			  ,
                                  i.STACHEDUREE					  ,
                                  i.STACHEPARAMLOCAL			  ,
                                  i.RESSBIPCODE					  ,
                                  i.RESSBIPNOM				  ,
                                  i.CONSODEBDATE				  ,
                                  i.CONSOFINDATE				  ,
                                  i.CONSOQTE				 ,
                                  i.PROVENANCE	 ,
                                  i.PRIORITE,
                                  i.FICHIER,
                                  p_message);


         EXCEPTION
         WHEN NO_DATA_FOUND THEN
        --dbms_output.put_line('IL FAUT CREER '||i.LIGNEBIPCODE||' - '||to_number(i.ETAPENUM)||';'||to_number(i.TACHENUM)||';'||to_number(i.STACHENUM));
  --On crée la SR si elle n'existe pas
  INSERT_AAC_BIPS(i.LIGNEBIPCODE  ,
                                  i.LIGNEBIPCLE				 ,
                                  i.STRUCTUREACTION			 ,
                                  i.ETAPENUM				 ,
                                  i.ETAPETYPE					 ,
                                  i.ETAPELIBEL				 ,
                                  i.TACHENUM				  ,
                                  i.TACHELIBEL			,
                                  i.TACHEAXEMETIER			,
                                  i.STACHENUM				 ,
                                  i.STACHETYPE				 ,
                                  i.STACHELIBEL					 ,
                                  i.STACHEINITDEBDATE			  ,
                                  i.STACHEINITFINDATE			  ,
                                  i.STACHEREVDEBDATE			  ,
                                  i.STACHEREVFINDATE			 ,
                                  i.STACHESTATUT			  ,
                                  i.STACHEDUREE					  ,
                                  i.STACHEPARAMLOCAL			  ,
                                  i.RESSBIPCODE					  ,
                                  i.RESSBIPNOM				  ,
                                  i.CONSODEBDATE				  ,
                                  i.CONSOFINDATE				  ,
                                  i.CONSOQTE				 ,
                                  i.PROVENANCE	 ,
                                  i.PRIORITE,
                                  i.FICHIER,
                                  p_message);

 -- WHEN OTHERS THEN
  --dbms_output.put_line(p_message);
  END;




/*4 cas LA : supprimer l'activité en base , et la remplacer par celle du fichier (comme .BIP)*/
WHEN i.STRUCTUREACTION = 'LA' THEN


-- Remplacer la SR supprumer par une nouvelle (activités + affectations + consommés)
INSERT_AAC_BIPS(i.LIGNEBIPCODE  ,
                                  i.LIGNEBIPCLE				 ,
                                  i.STRUCTUREACTION			 ,
                                  i.ETAPENUM				 ,
                                  i.ETAPETYPE					 ,
                                  i.ETAPELIBEL				 ,
                                  i.TACHENUM				  ,
                                  i.TACHELIBEL			,
                                  i.TACHEAXEMETIER			,
                                  i.STACHENUM				 ,
                                  i.STACHETYPE				 ,
                                  i.STACHELIBEL					 ,
                                  i.STACHEINITDEBDATE			  ,
                                  i.STACHEINITFINDATE			  ,
                                  i.STACHEREVDEBDATE			  ,
                                  i.STACHEREVFINDATE			 ,
                                  i.STACHESTATUT			  ,
                                  i.STACHEDUREE					  ,
                                  i.STACHEPARAMLOCAL			  ,
                                  i.RESSBIPCODE					  ,
                                  i.RESSBIPNOM				  ,
                                  i.CONSODEBDATE				  ,
                                  i.CONSOFINDATE				  ,
                                  i.CONSOQTE				 ,
                                  i.PROVENANCE	 ,
                                  i.PRIORITE,
                                  i.FICHIER,
                                  p_message);



  END CASE;

  
  update PMW_BIPS set TOP = 'o' where
                      LIGNEBIPCODE = i.LIGNEBIPCODE and
                      STRUCTUREACTION = i.STRUCTUREACTION and
                      ETAPENUM = LPAD(i.ETAPENUM, 2, '0') and
                      TACHENUM=LPAD(i.TACHENUM, 2, '0') and
                      STACHENUM=LPAD(i.STACHENUM, 2, '0') and
                      RESSBIPCODE=i.RESSBIPCODE and
                      CONSODEBDATE=i.CONSODEBDATE and
                      CONSOFINDATE=i.CONSOFINDATE and
                      USER_PEC=i.USER_PEC and
                      --DATE_PEC=P_DATE and
                      FICHIER=i.FICHIER and
                      PRIORITE = I.PRIORITE;
--PPM 60292                      
 update ligne_bip set p_saisie =i.USER_PEC||';FBIPS'
 where pid in (select lignebipcode from pmw_bips where TOP = 'o' and lignebipcode=i.LIGNEBIPCODE) ;


END LOOP;




    -- Trace Stop
    -- ----------
    TRCLOG.TRCLOG( L_HFILE, 'Fin normale de prise_en_charge_bips'  );
    TRCLOG.CLOSETRCLOG( L_HFILE );

EXCEPTION
    WHEN OTHERS THEN

    TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE du traitement prise_en_charge_bips du fichier  '||P_FICHIER||' ligne  : '||l_ligne);
          ROLLBACK;
END prise_en_charge_bips;


PROCEDURE insert_intranet_to_bips(P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_LIGNEBIPCLE				  in   pmw_bips.LIGNEBIPCLE%type,
                                  P_STRUCTUREACTION			  in   pmw_bips.STRUCTUREACTION%type,
                                  P_ETAPENUM				  in   pmw_bips.ETAPENUM%type,
                                  P_ETAPETYPE					  in   pmw_bips.ETAPETYPE%type,
                                  P_ETAPELIBEL				  in   pmw_bips.ETAPELIBEL%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_TACHELIBEL				  in   pmw_bips.TACHELIBEL%type,
                                  P_TACHEAXEMETIER				  in   pmw_bips.TACHEAXEMETIER%type, --SEL 6.11.2
                                  P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                                  P_STACHETYPE				  in   pmw_bips.STACHETYPE%type,
                                  P_STACHELIBEL					  in   pmw_bips.STACHELIBEL%type,
                                  P_STACHEINITDEBDATE			  in   pmw_bips.STACHEINITDEBDATE%type,
                                  P_STACHEINITFINDATE			  in   pmw_bips.STACHEINITFINDATE%type,
                                  P_STACHEREVDEBDATE			  in   pmw_bips.STACHEREVDEBDATE%type,
                                  P_STACHEREVFINDATE			  in   pmw_bips.STACHEREVFINDATE%type,
                                  P_STACHESTATUT			  in   pmw_bips.STACHESTATUT%type,
                                  P_STACHEDUREE					  in   pmw_bips.STACHEDUREE%type,
                                  P_STACHEPARAMLOCAL			  in   pmw_bips.STACHEPARAMLOCAL%type,
                                  P_RESSBIPCODE					  in   pmw_bips.RESSBIPCODE%type,
                                  P_RESSBIPNOM				  in   pmw_bips.RESSBIPNOM%type,
                                  P_CONSODEBDATE				  in   pmw_bips.CONSODEBDATE%type,
                                  P_CONSOFINDATE				  in   pmw_bips.CONSOFINDATE%type,
                                  P_CONSOQTE				  in   pmw_bips.CONSOQTE%type,
                                  P_PROVENANCE	  in   pmw_bips.PROVENANCE%type,
                                  P_PRIORITE	  in   pmw_bips.PRIORITE%type,
                                  P_USER	  in   pmw_bips.USER_PEC%type,
                                  P_DATE	  in   pmw_bips.DATE_PEC%type,
                                  P_FICHIER	  in   pmw_bips.FICHIER%type,
                                  P_MESSAGE   out VARCHAR2
                                  ) IS


l_priorite pmw_bips.PRIORITE%type;


L_HFILE utl_file.file_type;
L_RETCOD number;

l_pl_logs VARCHAR2(50);

l_count number(4);
l_activites varchar2(1024);
l_etapelib varchar2(100);
l_tachelib varchar2(100);
l_sstachelib varchar2(100);

l_stacheinitdebdate		   pmw_bips.stacheinitdebdate%type;
l_stacheinitfindate			   pmw_bips.stacheinitfindate%type;
l_stacherevdebdate			     pmw_bips.stacherevdebdate%type;
l_stacherevfindate			     pmw_bips.stacherevfindate%type;
l_stacheduree		     pmw_bips.STACHEDUREE%type;
l_fonction      VARCHAR2(20) := 'SASIE_CONSOMME';
l_lock   VARCHAR2(20):='n';

l_message   VARCHAR2(32767);

l_user  VARCHAR2(32767) := P_USER;
l_count_isac number(10);

l_chaine_param VARCHAR2(32767);




l_retour_sr_p2 VARCHAR2(32767);
l_retour_ins_upd VARCHAR2(32767);

l_proc VARCHAR2(32767) := 'insert_intranet_to_bips';


BEGIN

    L_RETCOD := TRCLOG.INITTRCLOG( 'PL_LOGS' , 'insert_intranet_to_bips', L_HFILE );

    if ( L_RETCOD <> 0 ) then
        raise_application_error( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible ',
                                 false );
    end if;

    -- Trace Start
    -- -----------
    l_cp := l_cp+1;
    --TRCLOG.TRCLOG( L_HFILE, 'Debut du traitement insert_intranet_to_bips de '||P_LIGNEBIPCODE||','||LPAD(P_ETAPENUM, 2, '0')||LPAD(P_TACHENUM, 2, '0')||LPAD(P_STACHENUM, 2, '0')||','||P_RESSBIPCODE||','||P_CONSODEBDATE||'('||l_cp||')' );





  IF (lower(P_PROVENANCE) = 'intra' or lower(P_PROVENANCE) like 'intra') THEN





  PACK_LOCK.GESTION_LOCK (P_USER,l_fonction,trim(P_RESSBIPCODE),l_lock,l_message);
  l_user := pack_global.lire_globaldata(P_USER).idarpege;

  --TRCLOG.TRCLOG( L_HFILE, '(1)insert_intranet_to_bips - apres traitement PACK_LOCK.GESTION_LOCK '||l_cp );



  END IF;

  IF (l_lock <> 'O') THEN



            IF (upper(P_PRIORITE) not like 'P4' OR P_PRIORITE is null) THEN
          
            DELETE FROM pmw_bips
            where  lignebipcode = p_lignebipcode
            and     etapenum = lpad(p_etapenum,2,'0')
            and     tachenum = lpad(p_tachenum,2,'0')
            and     stachenum = lpad(p_stachenum,2,'0')
            and     trim(ressbipcode) = p_ressbipcode
           -- and     consodebdate = to_date(p_consodebdate)
            and     to_char(consodebdate,'DD/MM/YYYY') = to_char(to_date(p_consodebdate),'DD/MM/YYYY')
            --and     upper(priorite) <> 'P4'
            ;
            commit;
        
            
            END IF;


    --S2 : libelle etape vide
    BEGIN
     IF (P_ETAPELIBEL = 'CHARGER-CREER') THEN

        IF (P_STRUCTUREACTION = 'LA') THEN

        l_etapelib := LPAD(P_ETAPENUM,2,'0');

        ELSE

        select e.libetape into l_etapelib from isac_etape e
        where e.pid = P_LIGNEBIPCODE
        AND   e.ecet = to_number(P_ETAPENUM);

        END IF;

      ELSE
      l_etapelib := P_ETAPELIBEL;


    END IF;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    l_etapelib := LPAD(P_ETAPENUM,2,'0');





    WHEN OTHERS THEN
    P_MESSAGE := l_proc|| ' : 800 : '||SQLERRM;

    END;
    --S2 : libelle tache vide
    BEGIN
    IF (P_TACHELIBEL = 'CHARGER-CREER') THEN


    IF (P_STRUCTUREACTION = 'LA') THEN

    l_tachelib := LPAD(P_TACHENUM,2,'0');

    ELSE

    select t.libtache into l_tachelib from isac_tache t,isac_etape e
      where t.pid = P_LIGNEBIPCODE
      and t.pid = e.pid
      and t.etape = e.etape
      AND e.ecet = to_number(P_ETAPENUM)
      AND  t.acta = to_number(P_TACHENUM);

    END IF;

      ELSE

      l_tachelib := P_TACHELIBEL;

    END IF;


    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    l_tachelib := LPAD(P_TACHENUM,2,'0');

WHEN OTHERS THEN

    P_MESSAGE := l_proc|| ' : 836 : '||SQLERRM;

    END;

    --S2 : libelle sous tache vide
    BEGIN
    IF (P_STACHELIBEL = 'CHARGER-CREER') THEN

          IF (P_STRUCTUREACTION = 'LA') THEN

          l_sstachelib := LPAD(P_STACHENUM,2,'0');

          ELSE



          select s.asnom into l_sstachelib from isac_sous_tache s,isac_tache t,isac_etape e
          where s.pid = P_LIGNEBIPCODE
          and s.etape = e.etape
          and s.tache = t.tache
          AND s.acst = to_number(P_STACHENUM)


          AND e.ecet = to_number(P_ETAPENUM)
          AND t.acta = to_number(P_TACHENUM);


          --TRCLOG.TRCLOG( L_HFILE, '(3)insert_intranet_to_bips - apres traitement  select s.asnom '||l_cp );

         END IF;


      ELSE


      l_sstachelib := P_STACHELIBEL;


    END IF;


    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    l_sstachelib := LPAD(P_STACHENUM,2,'0');

WHEN OTHERS THEN
    P_MESSAGE := l_proc|| ' : 881 : '||SQLERRM;



    END;


    BEGIN




BEGIN
    select s.ADEB,s.AFIN,s.ANDE,s.ANFI ,s.adur
    into l_stacheinitdebdate, l_stacheinitfindate, l_stacherevdebdate, l_stacherevfindate,l_stacheduree
    from isac_sous_tache s,isac_tache t,isac_etape e
      where s.pid = P_LIGNEBIPCODE
      and s.etape = e.etape
      and s.tache = t.tache
      AND s.acst = to_number(P_STACHENUM)


      AND t.acta = to_number(P_TACHENUM)
      AND e.ecet = to_number(P_ETAPENUM)
      ;


       --TRCLOG.TRCLOG( L_HFILE, '(4)insert_intranet_to_bips '||l_cp );




EXCEPTION
WHEN NO_DATA_FOUND THEN

 null;
END;

     IF (P_STACHEINITDEBDATE IS NOT NULL ) THEN
     l_stacheinitdebdate := P_STACHEINITDEBDATE;
     END IF;




     IF (P_STACHEINITFINDATE IS NOT NULL ) THEN
     l_stacheinitfindate := P_STACHEINITFINDATE;
     END IF;



     IF (P_STACHEREVDEBDATE IS NOT NULL ) THEN
     l_stacherevdebdate := P_STACHEREVDEBDATE;
     END IF;


     IF (P_STACHEREVFINDATE IS NOT NULL ) THEN
     l_stacherevfindate := P_STACHEREVFINDATE;
     END IF;


     IF (P_STACHEDUREE IS NOT NULL ) THEN
     l_stacheduree := P_STACHEDUREE;
     END IF;


     EXCEPTION
     WHEN NO_DATA_FOUND THEN
    l_stacheinitdebdate := P_STACHEINITDEBDATE;
    l_stacheinitfindate := P_STACHEINITFINDATE;
    l_stacherevdebdate := P_STACHEREVDEBDATE;
    l_stacherevfindate := P_STACHEREVFINDATE;
    l_stacheduree := P_STACHEDUREE;





    WHEN OTHERS THEN
    P_MESSAGE := l_proc|| ' : 958 : '||SQLERRM;

    END;




    l_priorite := P_PRIORITE;


--TRCLOG.TRCLOG( L_HFILE, '********** l_priorite '||l_priorite );
IF(l_priorite <> 'P2') THEN

INSERT INTO pmw_bips (LIGNEBIPCODE,
                      LIGNEBIPCLE,
                      STRUCTUREACTION,
                      ETAPENUM,
                      ETAPETYPE,
                      ETAPELIBEL,
                      TACHENUM,
                      TACHELIBEL,
                      STACHENUM,
                      STACHETYPE,
                      STACHELIBEL,
                      STACHEINITDEBDATE,
                      STACHEINITFINDATE,
                      STACHEREVDEBDATE,
                      STACHEREVFINDATE,
                      STACHESTATUT,
                      STACHEDUREE,
                      STACHEPARAMLOCAL,
                      RESSBIPCODE,
                      RESSBIPNOM,
                      CONSODEBDATE,
                      CONSOFINDATE,
                      CONSOQTE,
                      PROVENANCE,
                      PRIORITE,
                      TOP,
                      USER_PEC,
                      DATE_PEC,
                      FICHIER,
                      TACHEAXEMETIER --SEL 6.11.2
                      )
                      VALUES
                      (
                      P_LIGNEBIPCODE,
                      P_LIGNEBIPCLE,
                      P_STRUCTUREACTION,
                      LPAD(P_ETAPENUM, 2, '0'),
                      P_ETAPETYPE,
                      SUBSTR(l_etapelib,1,30),
                      LPAD(P_TACHENUM, 2, '0'),
                      SUBSTR(l_tachelib,1,30),
                      LPAD(P_STACHENUM, 2, '0'),
                      trim(P_STACHETYPE),
                      SUBSTR(l_sstachelib,1,30) ,
                      l_stacheinitdebdate,
                      l_stacheinitfindate,
                      l_stacherevdebdate,
                      l_stacherevfindate,
                      SUBSTR(P_STACHESTATUT,1,2),
                      l_stacheduree,
                      P_STACHEPARAMLOCAL,
                      P_RESSBIPCODE,
                      P_RESSBIPNOM,
                      P_CONSODEBDATE,
                      P_CONSOFINDATE,
                      P_CONSOQTE,
                      P_PROVENANCE,
                      l_priorite,
                      'n',
                      l_user,
                      SYSDATE,
                      P_FICHIER,
                      P_TACHEAXEMETIER--SEL 6.11.2
                      );

                      commit;

--TRCLOG.TRCLOG( L_HFILE, '(6)insert_intranet_to_bips '||l_cp );










commit;



                     --TRCLOG.TRCLOG( L_HFILE, '(8)insert_intranet_to_bips '||l_cp );
END IF;

IF (upper(l_priorite) = 'P2') THEN

--Verifier si l'activté P2 n'a pas de structure SR dans le referentiel BIPS_ACTIVITE
VERIF_SR_P2(P_LIGNEBIPCODE,P_ETAPENUM,P_TACHENUM,P_STACHENUM,l_retour_sr_p2);
 --TRCLOG.TRCLOG( L_HFILE, '(9)insert_intranet_to_bips '||l_cp );

CASE


    --l'activité doit exister
    WHEN P_STRUCTUREACTION = 'AE' THEN


    IF(l_retour_sr_p2 = 'O') THEN


   UPDATE_BIPS_P2(P_LIGNEBIPCODE,P_STRUCTUREACTION,P_ETAPENUM,P_ETAPETYPE,P_ETAPELIBEL,
                                  P_TACHENUM,P_TACHELIBEL,P_STACHENUM,P_STACHETYPE,
                                  P_STACHELIBEL,P_STACHEINITDEBDATE,P_STACHEINITFINDATE,
                                  P_STACHEREVDEBDATE,
                                  P_STACHEREVFINDATE,
                                  P_STACHESTATUT,
                                  P_STACHEDUREE,
                                  P_STACHEPARAMLOCAL,
                                  'O',
                                  P_TACHEAXEMETIER,
                                  l_retour_ins_upd
                                  );


  --TRCLOG.TRCLOG( L_HFILE, '(10)insert_intranet_to_bips '||l_cp );


    END IF;




    WHEN P_STRUCTUREACTION = 'LE' THEN
    --Toutes les activités doivent exister
   UPDATE_BIPS_P2(P_LIGNEBIPCODE,P_STRUCTUREACTION,P_ETAPENUM,P_ETAPETYPE,P_ETAPELIBEL,
                                  P_TACHENUM,P_TACHELIBEL,P_STACHENUM,P_STACHETYPE,
                                  P_STACHELIBEL,P_STACHEINITDEBDATE,P_STACHEINITFINDATE,
                                  P_STACHEREVDEBDATE,
                                  P_STACHEREVFINDATE,
                                  P_STACHESTATUT,
                                  P_STACHEDUREE,
                                  P_STACHEPARAMLOCAL,
                                  'O',
                                  P_TACHEAXEMETIER,
                                  l_retour_ins_upd
                                  );

--TRCLOG.TRCLOG( L_HFILE, '(11)insert_intranet_to_bips '||l_cp );
    WHEN P_STRUCTUREACTION = 'AF' THEN


   IF(l_retour_sr_p2 = 'O') THEN


   UPDATE_BIPS_P2(P_LIGNEBIPCODE,P_STRUCTUREACTION,P_ETAPENUM,P_ETAPETYPE,P_ETAPELIBEL,
                                  P_TACHENUM,P_TACHELIBEL,P_STACHENUM,P_STACHETYPE,
                                  P_STACHELIBEL,P_STACHEINITDEBDATE,P_STACHEINITFINDATE,
                                  P_STACHEREVDEBDATE,
                                  P_STACHEREVFINDATE,
                                  P_STACHESTATUT,
                                  P_STACHEDUREE,
                                  P_STACHEPARAMLOCAL,
                                  'O',
                                  P_TACHEAXEMETIER,
                                  l_retour_ins_upd
                                  );

--TRCLOG.TRCLOG( L_HFILE, '(12)insert_intranet_to_bips '||l_cp );
   ELSE


   INSERT_BIPS_P2(P_LIGNEBIPCODE,P_STRUCTUREACTION,
                                    LPAD(P_ETAPENUM, 2, '0'),
                                    P_ETAPETYPE,
                                    SUBSTR(P_ETAPELIBEL,1,15),
                                    LPAD(P_TACHENUM, 2, '0'),
                                    SUBSTR(P_TACHELIBEL,1,15),
                                    LPAD(P_STACHENUM, 2, '0'),
                                    trim(P_STACHETYPE),
                                    SUBSTR(P_STACHELIBEL,1,15) ,
                                    l_stacheinitdebdate,
                                    l_stacheinitfindate,
                                    l_stacherevdebdate,
                                    l_stacherevfindate,
                                    SUBSTR(P_STACHESTATUT,1,2),
                                    P_STACHEDUREE,
                                    P_STACHEPARAMLOCAL,
                                    'O',
                                    P_TACHEAXEMETIER,
                                    l_retour_ins_upd
                                  );

--TRCLOG.TRCLOG( L_HFILE, '(13)insert_intranet_to_bips '||l_cp );
   END IF;


    WHEN P_STRUCTUREACTION = 'LA' THEN


    INSERT_BIPS_P2(P_LIGNEBIPCODE,P_STRUCTUREACTION,
                                    LPAD(P_ETAPENUM, 2, '0'),
                                    P_ETAPETYPE,
                                    SUBSTR(P_ETAPELIBEL,1,15),
                                    LPAD(P_TACHENUM, 2, '0'),
                                    SUBSTR(P_TACHELIBEL,1,15),
                                    LPAD(P_STACHENUM, 2, '0'),
                                    trim(P_STACHETYPE),
                                    SUBSTR(P_STACHELIBEL,1,15) ,
                                    l_stacheinitdebdate,
                                    l_stacheinitfindate,
                                    l_stacherevdebdate,
                                    l_stacherevfindate,
                                    SUBSTR(P_STACHESTATUT,1,2),
                                    P_STACHEDUREE,
                                    P_STACHEPARAMLOCAL,
                                    'O',
                                    P_TACHEAXEMETIER,
                                    l_retour_ins_upd
                                  );


                                  commit;




     --TRCLOG.TRCLOG( L_HFILE, '(15)insert_intranet_to_bips '||l_cp );

END CASE;

 INSERT INTO pmw_bips (LIGNEBIPCODE,LIGNEBIPCLE,STRUCTUREACTION,
                      ETAPENUM,ETAPETYPE,ETAPELIBEL,
                      TACHENUM,TACHELIBEL,
                      STACHENUM,STACHETYPE,STACHELIBEL,STACHEINITDEBDATE,STACHEINITFINDATE,STACHEREVDEBDATE,
                      STACHEREVFINDATE,STACHESTATUT,STACHEDUREE,STACHEPARAMLOCAL,
                      RESSBIPCODE,RESSBIPNOM,CONSODEBDATE,CONSOFINDATE,CONSOQTE,
                      PROVENANCE,PRIORITE,TOP,USER_PEC,DATE_PEC,FICHIER
                      ,TACHEAXEMETIER --6.11.2
                      )
                      VALUES
                      (
                      P_LIGNEBIPCODE,P_LIGNEBIPCLE,P_STRUCTUREACTION,
                      LPAD(P_ETAPENUM, 2, '0'),
                      P_ETAPETYPE,
                      SUBSTR(l_etapelib,1,15),
                      LPAD(P_TACHENUM, 2, '0'),
                      SUBSTR(l_tachelib,1,15),
                      LPAD(P_STACHENUM, 2, '0'),
                      trim(P_STACHETYPE),
                      SUBSTR(l_sstachelib,1,15) ,
                      l_stacheinitdebdate,
                      l_stacheinitfindate,
                      l_stacherevdebdate,
                      l_stacherevfindate,
                      SUBSTR(P_STACHESTATUT,1,2),
                      l_stacheduree,
                      P_STACHEPARAMLOCAL,P_RESSBIPCODE,P_RESSBIPNOM,P_CONSODEBDATE,
                      P_CONSOFINDATE,P_CONSOQTE,P_PROVENANCE,
                      l_priorite,
                      'n',
                      l_user,
                      SYSDATE,
                      P_FICHIER,
                      P_TACHEAXEMETIER --SEL 6.11.2
                      );


    commit;

 --TRCLOG.TRCLOG( L_HFILE, '(16)insert_intranet_to_bips '||l_cp );

END IF;

PACK_LOCK.RESET_LOCK_USER(P_USER,l_fonction);

--TRCLOG.TRCLOG( L_HFILE, '(17)insert_intranet_to_bips '||l_cp );


ELSE

P_MESSAGE := 'RESSOURCE_BLOQUEE';

END IF;

--TRCLOG.TRCLOG( L_HFILE, 'insert_intranet_to_bips - FIN NORMALE '||P_LIGNEBIPCODE||','||LPAD(P_ETAPENUM, 2, '0')||LPAD(P_TACHENUM, 2, '0')||LPAD(P_STACHENUM, 2, '0')||','||P_RESSBIPCODE||','||P_CONSODEBDATE||'('||l_cp||')' );

TRCLOG.CLOSETRCLOG( L_HFILE );

EXCEPTION
    WHEN OTHERS THEN
    --dbms_output.put_line(SQLERRM);

    TRCLOG.TRCLOG( L_HFILE, 'Exception  :'||SQLERRM );
    
    TRCLOG.TRCLOG( L_HFILE, 'insert_intranet_to_bips - FIN ANORMALE '||P_LIGNEBIPCODE||','||P_ETAPENUM||P_TACHENUM||P_STACHENUM||','||P_RESSBIPCODE||','||P_CONSODEBDATE );
    
    P_MESSAGE:=l_retour_ins_upd||' - '||l_proc ||' : '||SQLERRM;
    TRCLOG.CLOSETRCLOG( L_HFILE );
          ROLLBACK;

END insert_intranet_to_bips;


PROCEDURE INSERT_AAC_BIPS(P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_LIGNEBIPCLE				  in   pmw_bips.LIGNEBIPCLE%type,
                                  P_STRUCTUREACTION			  in   pmw_bips.STRUCTUREACTION%type,
                                  P_ETAPENUM				  in   pmw_bips.ETAPENUM%type,
                                  P_ETAPETYPE					  in   pmw_bips.ETAPETYPE%type,
                                  P_ETAPELIBEL				  in   pmw_bips.ETAPELIBEL%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_TACHELIBEL				  in   pmw_bips.TACHELIBEL%type,
                                  P_TACHEAXEMETIER				  in   pmw_bips.TACHEAXEMETIER%type, --SEL 6.11.2
                                  P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                                  P_STACHETYPE				  in   pmw_bips.STACHETYPE%type,
                                  P_STACHELIBEL					  in   pmw_bips.STACHELIBEL%type,
                                  P_STACHEINITDEBDATE			  in   pmw_bips.STACHEINITDEBDATE%type,
                                  P_STACHEINITFINDATE			  in   pmw_bips.STACHEINITFINDATE%type,
                                  P_STACHEREVDEBDATE			  in   pmw_bips.STACHEREVDEBDATE%type,
                                  P_STACHEREVFINDATE			  in   pmw_bips.STACHEREVFINDATE%type,
                                  P_STACHESTATUT			  in   pmw_bips.STACHESTATUT%type,
                                  P_STACHEDUREE					  in   pmw_bips.STACHEDUREE%type,
                                  P_STACHEPARAMLOCAL			  in   pmw_bips.STACHEPARAMLOCAL%type,
                                  P_RESSBIPCODE					  in   pmw_bips.RESSBIPCODE%type,
                                  P_RESSBIPNOM				  in   pmw_bips.RESSBIPNOM%type,
                                  P_CONSODEBDATE				  in   pmw_bips.CONSODEBDATE%type,
                                  P_CONSOFINDATE				  in   pmw_bips.CONSOFINDATE%type,
                                  P_CONSOQTE				  in   pmw_bips.CONSOQTE%type,
                                  P_PROVENANCE	  in   pmw_bips.PROVENANCE%type,
                                  P_PRIORITE	  in   pmw_bips.PRIORITE%type,
                                  P_FICHIER     in  pmw_bips.FICHIER%type,
                                  P_RETOUR out VARCHAR2
                                  )
IS


L_HFILE utl_file.file_type;
l_exist_sr varchar2(5);
l_retour_pmw varchar2(5);
l_nbcurseur  INTEGER;
l_message  VARCHAR2(5);
l_etape NUMBER(10,0);
l_tache NUMBER(10,0);
l_sstache NUMBER(10,0);

l_activites_isac varchar2(1024);
l_activites_bips varchar2(1024);
l_maj boolean:=true;

p_message varchar2(200);
p_nbcurseur INTEGER;
l_chaine_conso VARCHAR2(1024);
l_chaine_aff VARCHAR2(1024);
l_chaine_conso_date VARCHAR2(1024);
l_nb_mois_conso NUMBER(10,0);
l_exist_aff NUMBER(1);
l_exist_isac NUMBER(1);
l_sum_conso NUMBER(10,2);
l_proc varchar2(200) :='INSERT_AAC_BIPS' ;

l_flag_etape NUMBER(5);
l_flag_tache NUMBER(5);


l_flag_sous_tache NUMBER(5);

l_jeu VARCHAR2(10);

l_old_tacheaxemetier VARCHAR2(12);

l_message_axe VARCHAR2(1024);
l_type VARCHAR2(20);
l_param_id VARCHAR2(20);
l_flag_axe_met VARCHAR2(20);

BEGIN

PACK_REMONTEE.check_EtapeType (P_LIGNEBIPCODE,P_ETAPENUM||P_TACHENUM||P_STACHENUM, P_ETAPETYPE, P_STRUCTUREACTION, l_jeu);

    BEGIN
      pack_isac_etape.insert_etape (
          P_LIGNEBIPCODE,
          P_ETAPENUM,
          trim(P_ETAPETYPE),
          P_ETAPELIBEL,
         l_jeu,

          '',
          p_nbcurseur,
          p_message
       );


    EXCEPTION
    WHEN insert_etape_existe THEN
    --dbms_output.put_line('insert_etape_existe '||P_ETAPELIBEL);



    UPDATE_ETAPE_BIPS( P_LIGNEBIPCODE,P_ETAPENUM,P_ETAPETYPE,P_ETAPELIBEL,l_jeu,l_etape,P_RETOUR );

    END;


   select e.etape into l_etape from isac_etape e
    where
    e.pid=P_LIGNEBIPCODE
    and e.ecet = P_ETAPENUM
    ORDER BY e.pid
      ;

   BEGIN

   PACK_ISAC_TACHE.VERIFIER_TACHE_AXE_METIER(P_TACHEAXEMETIER,P_LIGNEBIPCODE,l_message_axe,l_type,l_param_id);
/*Commented for US- BIP-16 */
--    IF (l_type = 'N') THEN
--
--    l_flag_axe_met := 'absence';
--
--    END IF;

   pack_isac_tache.insert_tache(
      P_LIGNEBIPCODE,
			l_etape,
			P_TACHENUM,
			P_TACHELIBEL,
			P_TACHEAXEMETIER,
      '.BIPS',
      l_flag_axe_met,
			p_nbcurseur,
      p_message
			);

      /*pack_ligne_bip.maj_ligne_bip_logs        (P_LIGNEBIPCODE,
                                                '.BIPS',
                                                'Axe métier Tâche',
                                                null,
                                                P_TACHEAXEMETIER,
                                                'Création via fichier sur la tâche  <'||P_ETAPENUM||'.'||P_TACHENUM||'> '
                                               );*/


    EXCEPTION
    WHEN insert_tache_existe THEN
   --dbms_output.put_line('insert_tache_existe '||P_TACHELIBEL);

   UPDATE_TACHE_BIPS(P_LIGNEBIPCODE,P_ETAPENUM,P_TACHENUM,P_TACHELIBEL,P_TACHEAXEMETIER,l_tache,P_RETOUR);

   END;

       select t.tache into l_tache from isac_tache t
    where
    t.pid=P_LIGNEBIPCODE
    and t.acta = P_TACHENUM
    and t.etape = l_etape
    ORDER BY t.pid
      ;

    BEGIN
      pack_isac_sous_tache.insert_sous_tache (
        P_LIGNEBIPCODE,
				l_etape		,
				l_tache		,
				P_STACHENUM		,
				replace(P_STACHETYPE,' ',''),
				P_STACHELIBEL,
			  to_char(to_date(P_STACHEINITDEBDATE), 'dd/mm/yyyy'),
        to_char(to_date(P_STACHEINITFINDATE), 'dd/mm/yyyy'),
        to_char(to_date(P_STACHEREVDEBDATE), 'dd/mm/yyyy'),
        to_char(to_date(P_STACHEREVFINDATE), 'dd/mm/yyyy'),
				SUBSTR(P_STACHESTATUT,1,2),
				P_STACHEDUREE,
				P_STACHEPARAMLOCAL,
        '',
				p_nbcurseur    ,
        p_message
			    );
      EXCEPTION
    WHEN insert_sous_tache_existe THEN
    --dbms_output.put_line('insert_sous_tache_existe '||P_STACHELIBEL);

    UPDATE_SOUS_TACHE_BIPS(P_LIGNEBIPCODE,P_ETAPENUM,P_TACHENUM,
                       P_STACHENUM,P_STACHETYPE,P_STACHELIBEL,P_STACHEINITDEBDATE,
                       P_STACHEINITFINDATE,P_STACHEREVDEBDATE,P_STACHEREVFINDATE,P_STACHESTATUT,P_STACHEDUREE,P_STACHEPARAMLOCAL,
                       l_sstache,
                       P_RETOUR);
    END;

          select s.sous_tache into l_sstache from isac_sous_tache s
    where
    s.pid=P_LIGNEBIPCODE
    and s.acst = P_STACHENUM
    and s.tache = l_tache
    and s.etape = l_etape
         ;

  --Mise à jour des affectations
      l_chaine_aff := l_etape||'-'||l_tache||'-'||l_sstache||'/';
      BEGIN
      pack_isac_affectation.insert_affectation(trim(P_RESSBIPCODE),P_LIGNEBIPCODE,l_chaine_aff,'', p_nbcurseur,p_message);
      EXCEPTION
      WHEN OTHERS THEN
      P_RETOUR := l_proc||' - Warning MAJ affectation '||SQLERRM;
      --dbms_output.put_line(P_RETOUR);
      END;

  --Mise à jour des consommé

       l_nb_mois_conso := to_number(to_char(P_CONSOFINDATE,'MM'));


      select sum(CONSOQTE)  into l_sum_conso from pmw_bips where LIGNEBIPCODE=P_LIGNEBIPCODE
      and etapenum=P_etapenum
      and tachenum=P_tachenum
      and stachenum=P_stachenum
      AND ressbipcode= p_ressbipcode
      AND upper(trim(fichier)) = upper(trim(p_fichier))

      AND to_char(consodebdate,'MM')  = to_char(P_CONSODEBDATE,'MM') --SEL PPM 60612 QC 1719
      ;


      l_chaine_conso_date := 'conso_1_'||l_nb_mois_conso||'='||l_sum_conso||';';
      --dbms_output.put_line('l_chaine_conso_date --> '||l_chaine_conso_date);

      l_chaine_conso := trim(P_RESSBIPCODE)||':'||P_LIGNEBIPCODE||';'||to_number(l_etape)||';'||to_number(l_tache)||';'||to_number(l_sstache)||';'||l_chaine_conso_date||':';
      BEGIN
      pack_isac_conso.update_conso_chaine(l_chaine_conso,'', p_nbcurseur, p_message);
      EXCEPTION
      WHEN OTHERS THEN
      P_RETOUR := l_proc||' - Warning MAJ consommés '||SQLERRM;
      --dbms_output.put_line(P_RETOUR);
      END;

EXCEPTION
      WHEN OTHERS THEN
      P_RETOUR := l_proc||' - '||SQLERRM;
      --dbms_output.put_line(P_RETOUR);


END INSERT_AAC_BIPS ;

PROCEDURE DELETE_AAC_BIPS(P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_ETAPE			  in   NUMBER,
                                  P_NBCURSEUR	  out   pmw_bips.PROVENANCE%type,
                                  P_RETOUR out VARCHAR2
                                  ) IS

l_proc varchar2(200) :='DELETE_AAC_BIPS' ;
BEGIN

       --dbms_output.put_line('AA');

      DELETE      isac_consomme
      WHERE pid = P_LIGNEBIPCODE AND etape = TO_NUMBER (P_ETAPE);

       --dbms_output.put_line('BB');
      pack_isac_etape.delete_etape (P_LIGNEBIPCODE,to_number(P_ETAPE), '', P_NBCURSEUR, P_RETOUR);
       --dbms_output.put_line('CC');

END DELETE_AAC_BIPS;


PROCEDURE UPDATE_AAC_BIPS(P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_LIGNEBIPCLE				  in   pmw_bips.LIGNEBIPCLE%type,
                                  P_STRUCTUREACTION			  in   pmw_bips.STRUCTUREACTION%type,
                                  P_ETAPENUM				  in   pmw_bips.ETAPENUM%type,
                                  P_ETAPETYPE					  in   pmw_bips.ETAPETYPE%type,
                                  P_ETAPELIBEL				  in   pmw_bips.ETAPELIBEL%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_TACHELIBEL				  in   pmw_bips.TACHELIBEL%type,
                                  P_TACHEAXEMETIER				  in   pmw_bips.TACHEAXEMETIER%type, --SEL 6.11.2
                                  P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                                  P_STACHETYPE				  in   pmw_bips.STACHETYPE%type,
                                  P_STACHELIBEL					  in   pmw_bips.STACHELIBEL%type,
                                  P_STACHEINITDEBDATE			  in   pmw_bips.STACHEINITDEBDATE%type,
                                  P_STACHEINITFINDATE			  in   pmw_bips.STACHEINITFINDATE%type,
                                  P_STACHEREVDEBDATE			  in   pmw_bips.STACHEREVDEBDATE%type,
                                  P_STACHEREVFINDATE			  in   pmw_bips.STACHEREVFINDATE%type,
                                  P_STACHESTATUT			  in   pmw_bips.STACHESTATUT%type,
                                  P_STACHEDUREE					  in   pmw_bips.STACHEDUREE%type,
                                  P_STACHEPARAMLOCAL			  in   pmw_bips.STACHEPARAMLOCAL%type,
                                  P_RESSBIPCODE					  in   pmw_bips.RESSBIPCODE%type,
                                  P_RESSBIPNOM				  in   pmw_bips.RESSBIPNOM%type,
                                  P_CONSODEBDATE				  in   pmw_bips.CONSODEBDATE%type,
                                  P_CONSOFINDATE				  in   pmw_bips.CONSOFINDATE%type,
                                  P_CONSOQTE				  in   pmw_bips.CONSOQTE%type,
                                  P_PROVENANCE	  in   pmw_bips.PROVENANCE%type,
                                  P_PRIORITE	  in   pmw_bips.PRIORITE%type,
                                  P_FICHIER     in  pmw_bips.FICHIER%type,
                                  P_RETOUR out VARCHAR2
                                  ) IS

L_HFILE utl_file.file_type;
l_exist_sr varchar2(5);
l_retour_pmw varchar2(5);
l_nbcurseur  INTEGER;
l_message  VARCHAR2(5);
l_etape NUMBER(10,0);
l_tache NUMBER(10,0);
l_sstache NUMBER(10,0);
l_activites_isac varchar2(1024);
l_activites_bips varchar2(1024);
l_maj boolean:=true;

p_message varchar2(200);
p_nbcurseur INTEGER;
l_chaine_conso VARCHAR2(1024);
l_chaine_aff VARCHAR2(1024);
l_chaine_conso_date VARCHAR2(1024);
l_nb_mois_conso NUMBER(10,0);
l_exist_aff NUMBER(1);
l_exist_isac NUMBER(1);
l_sum_conso NUMBER(10,2); -- QC 1542 : consommé sur 2 décimales

l_flag_etape NUMBER(5);
l_flag_tache NUMBER(5);
l_flag_sous_tache NUMBER(5);

l_jeu VARCHAR (100);

l_proc varchar2(200) :='UPDATE_AAC_BIPS' ;

BEGIN

      BEGIN
      PACK_REMONTEE.check_EtapeType (P_LIGNEBIPCODE,P_ETAPENUM||P_TACHENUM||P_STACHENUM, trim(P_ETAPETYPE), P_STRUCTUREACTION, l_jeu);

      --l_jeu := P_LIGNEBIPCODE||','||P_ETAPENUM||P_TACHENUM||P_STACHENUM||','||P_ETAPETYPE||',' ||P_STRUCTUREACTION;
      UPDATE_ETAPE_BIPS(P_LIGNEBIPCODE,P_ETAPENUM,P_ETAPETYPE,P_ETAPELIBEL,l_jeu,l_etape,P_RETOUR);



      UPDATE_TACHE_BIPS(P_LIGNEBIPCODE,P_ETAPENUM,P_TACHENUM,P_TACHELIBEL,P_TACHEAXEMETIER,l_tache,P_RETOUR);


      UPDATE_SOUS_TACHE_BIPS(P_LIGNEBIPCODE,P_ETAPENUM,P_TACHENUM,
                         P_STACHENUM,P_STACHETYPE,P_STACHELIBEL,P_STACHEINITDEBDATE,
                         P_STACHEINITFINDATE,P_STACHEREVDEBDATE,P_STACHEREVFINDATE,SUBSTR(P_STACHESTATUT,1,2),P_STACHEDUREE,P_STACHEPARAMLOCAL,
                         l_sstache,
                         P_RETOUR);


    EXCEPTION
      WHEN OTHERS THEN
       dbms_output.put_line(P_RETOUR||' -- '||SQLERRM);
      END;


      --Mise à jour des affectations
      l_chaine_aff := l_etape||'-'||l_tache||'-'||l_sstache||'/';
      BEGIN
      pack_isac_affectation.insert_affectation(trim(P_RESSBIPCODE),P_LIGNEBIPCODE,l_chaine_aff,'', p_nbcurseur,p_message);
      EXCEPTION
      WHEN OTHERS THEN
      P_RETOUR := l_proc||' - Warning MAJ affectation '||SQLERRM;
      dbms_output.put_line(P_RETOUR);
      END;

      --Mise à jour des consommé
      l_nb_mois_conso := to_number(to_char(P_CONSOFINDATE,'MM'));

      select sum(CONSOQTE)  into l_sum_conso from pmw_bips where LIGNEBIPCODE=P_LIGNEBIPCODE
      and etapenum=P_etapenum
      and tachenum=P_tachenum
      and stachenum=P_stachenum
      AND ressbipcode= p_ressbipcode
      AND upper(trim(fichier)) = upper(trim(p_fichier))
      AND to_char(consodebdate,'MM')  = to_char(P_CONSODEBDATE,'MM'); --SEL PPM 60612 QC 1719

      l_chaine_conso_date := 'conso_1_'||l_nb_mois_conso||'='||l_sum_conso||';';
      --dbms_output.put_line('l_chaine_conso_date --> '||P_STRUCTUREACTION||' - '||P_LIGNEBIPCODE||' - '||l_chaine_conso_date);


      l_chaine_conso := trim(P_RESSBIPCODE)||':'||P_LIGNEBIPCODE||';'||to_number(l_etape)||';'||to_number(l_tache)||';'||to_number(l_sstache)||';'||l_chaine_conso_date||':';
      BEGIN
      pack_isac_conso.update_conso_chaine(l_chaine_conso,'', p_nbcurseur, p_message);
      EXCEPTION
      WHEN OTHERS THEN
      P_RETOUR := P_RETOUR||' -- '||l_proc||' - Warning MAJ affectation '||SQLERRM;
      --dbms_output.put_line(P_RETOUR);
      END;

END UPDATE_AAC_BIPS;

PROCEDURE UPDATE_ETAPE_BIPS    (  P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_ETAPENUM				  in   pmw_bips.ETAPENUM%type,
                                  P_ETAPETYPE					  in   pmw_bips.ETAPETYPE%type,
                                  P_ETAPELIBEL				  in   pmw_bips.ETAPELIBEL%type,
                                  P_ETAPEJEU				  in   VARCHAR2,
                                  P_ETAPE out NUMBER,
                                  P_RETOUR out VARCHAR2) IS


l_etape NUMBER(10,0);
l_flag_etape NUMBER(10,0);
p_nbcurseur NUMBER :=0;
BEGIN

    select e.etape,e.flaglock into l_etape, l_flag_etape from isac_etape e
    where
    e.pid=P_LIGNEBIPCODE
    and e.ecet = P_ETAPENUM
    ORDER BY e.pid ;

    pack_isac_etape.update_etape (
      l_etape,
      P_LIGNEBIPCODE,
      P_ETAPENUM,
      trim(P_ETAPETYPE ),
      P_ETAPELIBEL,
      P_ETAPEJEU,

      l_flag_etape,
      '',

      p_nbcurseur,
      P_RETOUR
   );

   P_ETAPE := l_etape;

EXCEPTION
WHEN NO_DATA_FOUND THEN

	raise_application_error( -1, '');

END UPDATE_ETAPE_BIPS;


PROCEDURE UPDATE_TACHE_BIPS    (  P_LIGNEBIPCODE    in   pmw_bips.LIGNEBIPCODE%type,
                                  P_ETAPENUM        in      pmw_bips.ETAPENUM%type,
                                  P_TACHENUM				in   pmw_bips.TACHENUM%type,
                                  P_TACHELIBEL				  in   pmw_bips.TACHELIBEL%type,
                                  P_TACHEAXEMETIER				  in   pmw_bips.TACHEAXEMETIER%type, --SEL 6.11.2
                                  P_TACHE out NUMBER,
                                  P_RETOUR out VARCHAR2) IS


l_tache NUMBER(10,0);
l_etape NUMBER(10,0);
l_flag_tache NUMBER(10,0);
p_nbcurseur NUMBER :=0;
l_old_tacheaxemetier VARCHAR2(12);

l_message VARCHAR2(1024);
l_type VARCHAR2(200);
l_param_id VARCHAR2(200);

l_flag_axe_met VARCHAR2(200);

BEGIN

    select distinct e.etape,t.tache, t.flaglock, t.tacheaxemetier into l_etape,l_tache,l_flag_tache,l_old_tacheaxemetier from isac_etape e,isac_tache t, isac_sous_tache s
    where
    e.pid=P_LIGNEBIPCODE
    and e.pid=t.pid
    and t.pid=s.pid
    and t.etape= e.etape
    and s.tache= t.tache
    and e.ecet = P_ETAPENUM
    and t.acta = P_TACHENUM
    ORDER BY e.pid
      ;


    PACK_ISAC_TACHE.VERIFIER_TACHE_AXE_METIER(P_TACHEAXEMETIER,P_LIGNEBIPCODE,l_message,l_type,l_param_id);
/*Commented for US- BIP-16 */
--    IF (l_type = 'N') THEN
--
--    l_flag_axe_met := 'absence';
--
--    END IF;


     pack_isac_tache.update_tache(
      l_tache,
			P_LIGNEBIPCODE,
			l_etape,
			P_TACHENUM,
			P_TACHELIBEL,
			l_flag_tache,
			P_TACHEAXEMETIER,
      '.BIPS',
      l_flag_axe_met,
			p_nbcurseur ,
      P_RETOUR
			);

     /*pack_ligne_bip.maj_ligne_bip_logs        (P_LIGNEBIPCODE,
                                                '.BIPS',
                                                'Axe métier Tâche',
                                                l_old_tacheaxemetier,
                                                P_TACHEAXEMETIER,
                                                'Modification via fichier sur la tâche  <'||P_ETAPENUM||'.'||P_TACHENUM||'> '
                                               );*/

      P_TACHE := l_tache;

EXCEPTION
WHEN NO_DATA_FOUND THEN
raise_application_error( -2, '');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('UPDATE_TACHE_BIPS - '||SQLERRM);

END UPDATE_TACHE_BIPS;


PROCEDURE UPDATE_SOUS_TACHE_BIPS( P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_ETAPENUM   in    pmw_bips.ETAPENUM%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                                  P_STACHETYPE				  in   pmw_bips.STACHETYPE%type,
                                  P_STACHELIBEL					  in   pmw_bips.STACHELIBEL%type,
                                  P_STACHEINITDEBDATE			  in   pmw_bips.STACHEINITDEBDATE%type,
                                  P_STACHEINITFINDATE			  in   pmw_bips.STACHEINITFINDATE%type,
                                  P_STACHEREVDEBDATE			  in   pmw_bips.STACHEREVDEBDATE%type,
                                  P_STACHEREVFINDATE			  in   pmw_bips.STACHEREVFINDATE%type,
                                  P_STACHESTATUT			  in   pmw_bips.STACHESTATUT%type,
                                  P_STACHEDUREE					  in   pmw_bips.STACHEDUREE%type,
                                  P_STACHEPARAMLOCAL			  in   pmw_bips.STACHEPARAMLOCAL%type,
                                  P_SOUS_TACHE out NUMBER,
                                  P_RETOUR out VARCHAR2
                                  ) IS

l_etape NUMBER(10,0);
l_tache NUMBER(10,0);
l_sstache NUMBER(10,0);

l_flag_sous_tache NUMBER(10,0);

p_nbcurseur NUMBER:=0;

BEGIN


select distinct e.etape,t.tache,s.sous_tache, s.flaglock into l_etape,l_tache,l_sstache,l_flag_sous_tache from isac_etape e,isac_tache t, isac_sous_tache s
    where
    e.pid=P_LIGNEBIPCODE
    and e.pid=t.pid
    and t.pid=s.pid
    and t.etape= e.etape
    and s.tache= t.tache
    and e.ecet = P_ETAPENUM
    and t.acta = P_TACHENUM
    and s.acst = P_STACHENUM
    ORDER BY e.pid
      ;



pack_isac_sous_tache.update_sous_tache(
        l_sstache	,
				P_LIGNEBIPCODE    ,
				l_etape 	,
				l_tache		,
				P_STACHENUM		,
				replace(P_STACHETYPE,' ',''),
				P_STACHELIBEL		,
        to_char(to_date(P_STACHEINITDEBDATE), 'dd/mm/yyyy'),
        to_char(to_date(P_STACHEINITFINDATE), 'dd/mm/yyyy'),
        to_char(to_date(P_STACHEREVDEBDATE), 'dd/mm/yyyy'),
        to_char(to_date(P_STACHEREVFINDATE), 'dd/mm/yyyy'),




				SUBSTR(P_STACHESTATUT,1,2)	,
				P_STACHEDUREE		,
				P_STACHEPARAMLOCAL	,
				l_flag_sous_tache      ,
				''     	,
				p_nbcurseur    	,
        P_RETOUR
			);

      P_SOUS_TACHE := l_sstache;

     -- dbms_output.put_line('update_sous_tache ');

EXCEPTION
WHEN NO_DATA_FOUND THEN
raise_application_error( -3, '');

END UPDATE_SOUS_TACHE_BIPS;

--SEL 1766
PROCEDURE VERIF_SR_P2(            P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_ETAPENUM   in    pmw_bips.ETAPENUM%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                                  P_RETOUR out VARCHAR2
                                  ) IS



l_lignebipcode varchar2(4);
l_etapenum varchar2(2);
l_tachenum varchar2(2);
l_stachenum varchar2(2);

BEGIN

P_RETOUR := 'O';

BEGIN
  SELECT DISTINCT LIGNEBIPCODE,ETAPENUM,TACHENUM,STACHENUM
  into l_lignebipcode,l_etapenum,l_tachenum,l_stachenum
  FROM bips_activite
  WHERE
  LIGNEBIPCODE = P_LIGNEBIPCODE
  AND ETAPENUM = LPAD(P_ETAPENUM, 2, '0')
  AND TACHENUM = LPAD(P_TACHENUM, 2, '0')
  AND STACHENUM  = LPAD(P_STACHENUM, 2, '0');

EXCEPTION
WHEN NO_DATA_FOUND THEN
P_RETOUR := 'N';
END;

END VERIF_SR_P2;


PROCEDURE UPDATE_BIPS_P2(P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_STRUCTUREACTION			  in   pmw_bips.STRUCTUREACTION%type,
                                  P_ETAPENUM				  in   pmw_bips.ETAPENUM%type,
                                  P_ETAPETYPE					  in   pmw_bips.ETAPETYPE%type,
                                  P_ETAPELIBEL				  in   pmw_bips.ETAPELIBEL%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_TACHELIBEL				  in   pmw_bips.TACHELIBEL%type,
                                  P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                                  P_STACHETYPE				  in   pmw_bips.STACHETYPE%type,
                                  P_STACHELIBEL					  in   pmw_bips.STACHELIBEL%type,
                                  P_STACHEINITDEBDATE			  in   pmw_bips.STACHEINITDEBDATE%type,
                                  P_STACHEINITFINDATE			  in   pmw_bips.STACHEINITFINDATE%type,
                                  P_STACHEREVDEBDATE			  in   pmw_bips.STACHEREVDEBDATE%type,
                                  P_STACHEREVFINDATE			  in   pmw_bips.STACHEREVFINDATE%type,
                                  P_STACHESTATUT			  in   pmw_bips.STACHESTATUT%type,
                                  P_STACHEDUREE					  in   pmw_bips.STACHEDUREE%type,
                                  P_STACHEPARAMLOCAL			  in   pmw_bips.STACHEPARAMLOCAL%type,
                                  P_TOP			  in   pmw_bips.TOP%type,
                                  P_TACHEAXEMETIER     IN pmw_bips.TACHEAXEMETIER %type,
                                  P_RETOUR out VARCHAR2
                                  ) IS



l_etapelibel pmw_bips.ETAPELIBEL%type;
l_tachelibel pmw_bips.TACHELIBEL%type;
l_stachelibel pmw_bips.STACHELIBEL%type;

l_tacheaxemetier VARCHAR2(12);
l_old_tacheaxemetier VARCHAR2(12);

l_message VARCHAR2(300);
l_type VARCHAR(100);
l_param_id VARCHAR(100);

BEGIN




    BEGIN


        PACK_ISAC_TACHE.VERIFIER_TACHE_AXE_METIER(P_TACHEAXEMETIER,P_LIGNEBIPCODE,l_message,l_type,l_param_id);

         IF (upper(l_type) = 'N') THEN
/*Commented for US- BIP-16 */
        -- l_tacheaxemetier := '';

          select distinct tacheaxemetier
          into l_old_tacheaxemetier
          from bips_activite
          where LIGNEBIPCODE = P_LIGNEBIPCODE
          AND ETAPENUM = LPAD(P_ETAPENUM, 2, '0')
          AND TACHENUM = LPAD(P_TACHENUM, 2, '0')   ;

         pack_ligne_bip.maj_ligne_bip_logs        (P_LIGNEBIPCODE,
                                                        '.BIPS',
                                                        'Axe métier Tâche',
                                                        l_old_tacheaxemetier,
                                                        l_tacheaxemetier,
                                                        'Suppression de la valeur du champ car paramètre applicatif inexistant'
                                                       );

         ELSE

         l_tacheaxemetier := P_TACHEAXEMETIER;

         END IF;

        UPDATE BIPS_ACTIVITE SET

        ETAPELIBEL = SUBSTR( DECODE (P_ETAPELIBEL,'CHARGER-CREER',ETAPELIBEL,P_ETAPELIBEL) ,1,15),
        TACHELIBEL = SUBSTR( DECODE (P_TACHELIBEL,'CHARGER-CREER',TACHELIBEL,P_TACHELIBEL) ,1,15),
        STACHELIBEL = SUBSTR( DECODE (P_STACHELIBEL,'CHARGER-CREER',STACHELIBEL,P_STACHELIBEL) ,1,15),

        ETAPETYPE = P_ETAPETYPE,
        STACHETYPE = P_STACHETYPE,
        STACHESTATUT = P_STACHESTATUT,
        STACHEINITDEBDATE = P_STACHEINITDEBDATE,
        STACHEINITFINDATE = P_STACHEINITFINDATE,
        STACHEREVDEBDATE = P_STACHEREVDEBDATE,
        STACHEREVFINDATE = P_STACHEREVFINDATE,
        STACHEPARAMLOCAL = P_STACHEPARAMLOCAL,
        STACHEDUREE = P_STACHEDUREE,
        TACHEAXEMETIER = l_tacheaxemetier

        WHERE

        LIGNEBIPCODE = P_LIGNEBIPCODE
        AND ETAPENUM = LPAD(P_ETAPENUM, 2, '0')
        AND TACHENUM = LPAD(P_TACHENUM, 2, '0')
        AND STACHENUM  = LPAD(P_STACHENUM, 2, '0');


        commit;

        --SEL 6.11.2
        update bips_activite
        set tacheaxemetier = l_tacheaxemetier
        WHERE
        LIGNEBIPCODE = P_LIGNEBIPCODE
        AND ETAPENUM = LPAD(P_ETAPENUM, 2, '0')
        AND TACHENUM = LPAD(P_TACHENUM, 2, '0') ;
        commit;

        P_RETOUR := 'UPDATE_BIPS_P2 : OK';

      EXCEPTION
      WHEN OTHERS THEN
      P_RETOUR := 'UPDATE_BIPS_P2 : '||SQLERRM;

      END;

END UPDATE_BIPS_P2;

--SEL 1766
PROCEDURE INSERT_BIPS_P2(P_LIGNEBIPCODE  in   pmw_bips.LIGNEBIPCODE%type,
                                  P_STRUCTUREACTION			  in   pmw_bips.STRUCTUREACTION%type,
                                  P_ETAPENUM				  in   pmw_bips.ETAPENUM%type,
                                  P_ETAPETYPE					  in   pmw_bips.ETAPETYPE%type,
                                  P_ETAPELIBEL				  in   pmw_bips.ETAPELIBEL%type,
                                  P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                                  P_TACHELIBEL				  in   pmw_bips.TACHELIBEL%type,
                                  P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                                  P_STACHETYPE				  in   pmw_bips.STACHETYPE%type,
                                  P_STACHELIBEL					  in   pmw_bips.STACHELIBEL%type,
                                  P_STACHEINITDEBDATE			  in   pmw_bips.STACHEINITDEBDATE%type,
                                  P_STACHEINITFINDATE			  in   pmw_bips.STACHEINITFINDATE%type,
                                  P_STACHEREVDEBDATE			  in   pmw_bips.STACHEREVDEBDATE%type,
                                  P_STACHEREVFINDATE			  in   pmw_bips.STACHEREVFINDATE%type,
                                  P_STACHESTATUT			  in   pmw_bips.STACHESTATUT%type,
                                  P_STACHEDUREE					  in   pmw_bips.STACHEDUREE%type,
                                  P_STACHEPARAMLOCAL			  in   pmw_bips.STACHEPARAMLOCAL%type,
                                  P_TOP     IN pmw_bips.TOP%type,
                                  P_TACHEAXEMETIER     IN pmw_bips.TACHEAXEMETIER %type,
                                  P_RETOUR out VARCHAR2
                                  ) IS

l_top number(2);

l_tacheaxemetier VARCHAR2(12);

l_message VARCHAR2(300);
l_type VARCHAR(100);
l_param_id VARCHAR(100);
l_count number(5):=0;

BEGIN



BEGIN

 PACK_ISAC_TACHE.VERIFIER_TACHE_AXE_METIER(P_TACHEAXEMETIER,P_LIGNEBIPCODE,l_message,l_type,l_param_id);
/*Commented for US- BIP-16 */
-- IF (upper(l_type) = 'N') THEN
--
-- l_tacheaxemetier := '';
--
-- ELSE
--
-- l_tacheaxemetier := P_TACHEAXEMETIER;
--
-- END IF;



select count(*) into l_count from bips_activite
WHERE
        LIGNEBIPCODE = P_LIGNEBIPCODE
        AND ETAPENUM = LPAD(P_ETAPENUM, 2, '0')
        AND TACHENUM = LPAD(P_TACHENUM, 2, '0')
        AND STACHENUM= LPAD(P_STACHENUM,2,'O');


IF (l_count = 0) THEN





INSERT INTO BIPS_ACTIVITE( LIGNEBIPCODE  ,
                                  STRUCTUREACTION,
                                  ETAPENUM,
                                  ETAPETYPE,
                                  ETAPELIBEL,
                                  TACHENUM,
                                  TACHELIBEL,
                                  STACHENUM,
                                  STACHETYPE,
                                  STACHELIBEL,
                                  STACHEINITDEBDATE,
                                  STACHEINITFINDATE,
                                  STACHEREVDEBDATE,
                                  STACHEREVFINDATE,
                                  STACHESTATUT,
                                  STACHEDUREE,
                                  STACHEPARAMLOCAL,
                                  TACHEAXEMETIER
                                  )
                          VALUES( P_LIGNEBIPCODE  ,
                                  P_STRUCTUREACTION,
                                  P_ETAPENUM,
                                  P_ETAPETYPE,
                                  SUBSTR(DECODE (P_ETAPELIBEL,'CHARGER-CREER',P_ETAPENUM,P_ETAPELIBEL) ,1,15),
                                  P_TACHENUM,
                                  SUBSTR( DECODE (P_TACHELIBEL,'CHARGER-CREER',P_TACHENUM,P_TACHELIBEL) ,1,15),
                                  P_STACHENUM,
                                  P_STACHETYPE,
                                  SUBSTR( DECODE (P_STACHELIBEL,'CHARGER-CREER',P_STACHENUM,P_STACHELIBEL) ,1,15),
                                  P_STACHEINITDEBDATE,
                                  P_STACHEINITFINDATE,
                                  P_STACHEREVDEBDATE,
                                  P_STACHEREVFINDATE,
                                  P_STACHESTATUT,
                                  P_STACHEDUREE,
                                  P_STACHEPARAMLOCAL,
                                  l_tacheaxemetier
                                  ) ;
                                  commit;
END IF;

        --SEL 6.11.2
        update bips_activite
        set tacheaxemetier = l_tacheaxemetier
        WHERE
        LIGNEBIPCODE = P_LIGNEBIPCODE
        AND ETAPENUM = LPAD(P_ETAPENUM, 2, '0')
        AND TACHENUM = LPAD(P_TACHENUM, 2, '0') ;

        commit;
      P_RETOUR := 'INSERT_BIPS_P2 : OK';

      EXCEPTION
      WHEN OTHERS THEN
      P_RETOUR := 'INSERT_BIPS_P2 : '||SQLERRM||' -> '||P_LIGNEBIPCODE  ||' ; '||
                                  P_STRUCTUREACTION||' ; '||
                                  P_ETAPENUM||' ; '||
                                  P_ETAPETYPE||' ; '||
                                  P_ETAPELIBEL||' ; '||
                                  P_TACHENUM||' ; '||
                                  P_TACHELIBEL||' ; '||
                                  P_STACHENUM||' ; '||
                                  P_STACHETYPE||' ; '||
                                  P_STACHELIBEL||' ; '||
                                  P_STACHEINITDEBDATE||' ; '||
                                  P_STACHEINITFINDATE||' ; '||
                                  P_STACHEREVDEBDATE||' ; '||
                                  P_STACHEREVFINDATE||' ; '||
                                  P_STACHESTATUT||' ; '||
                                  P_STACHEDUREE||' ; '||
                                  P_STACHEPARAMLOCAL;

      --P_RETOUR := 'INSERT_BIPS_P2 -> '||SQLERRM;

      END;



END INSERT_BIPS_P2;


PROCEDURE LISTER_PMW_BIPS(P_USER_ID in VARCHAR2,
                          P_CURSOR in out pmw_bips_listeCurType,
                          P_MESSAGE OUT VARCHAR2
                            ) IS


BEGIN

OPEN P_CURSOR FOR
SELECT
LigneBipCode,LigneBipCle,StructureAction,EtapeNum,EtapeType,EtapeLibel,TacheNum,TacheLibel,TacheAxeMetier,StacheNum,
StacheType,StacheLibel,StacheInitDebDate,StacheInitFinDate,StacheRevDebDate,StacheRevFinDate,StacheStatut,StacheDuree,StacheParamLocal,RessBipCode,
RessBipNom,ConsoDebDate,ConsoFinDate,ConsoQte,provenance,priorite,top,user_pec,date_pec,fichier
FROM PMW_BIPS where upper(priorite)='P2' and top='n' ;

END LISTER_PMW_BIPS;

PROCEDURE INSERT_REJET_BIPS(P_REJET in varchar2,
                            P_PID in varchar2,
                            P_IDENT in varchar2,
                            P_ACTIVITE in varchar2,
                            P_DEBCONSO in varchar2,
                            P_CUSAG in varchar2,
                            P_TAG in varchar2,
                            P_CODE in varchar2,
                            P_MESSAGE out varchar2) IS


BEGIN


  BEGIN

  INSERT INTO tmp_rejetmens_bips (PID,
                                  CODSG,
                                  ECET,
                                  ACTA,
                                  ACST,
                                  IDENT,
                                  CDEB,
                                  CUSAG,
                                  MOTIF_REJET)
                                  values
                                  (
                                  P_PID,
                                  (select distinct codsg from ligne_bip where pid=P_PID),
                                  substr(P_ACTIVITE,1,2),
                                  substr(P_ACTIVITE,3,2),
                                  substr(P_ACTIVITE,5,2),
                                  P_IDENT,
                                  TO_DATE(P_DEBCONSO),
                                  P_CUSAG,
                                  P_REJET
                                  );

    IF (P_TAG like 'erreur.')THEN

    update pmw_bips set top='r' where
        lignebipcode = trim(P_PID )
    and etapenum = substr(P_ACTIVITE,1,2)
    and tachenum = substr(P_ACTIVITE,3,2)
    and stachenum = substr(P_ACTIVITE,5,2)
    and ressbipcode = to_number(P_IDENT)
    and consodebdate = TO_DATE(P_DEBCONSO)
    and consoqte = trim(P_CUSAG)
    ;

    END IF;

    IF(P_CODE in ('R001','R004')) THEN

    update pmw_bips set top='r' where
        lignebipcode = trim(P_PID )
        ;

    END IF;

    IF(P_CODE in ('R019','R022')) THEN

    update pmw_bips set top='r' where
        lignebipcode = trim(P_PID )
    and etapenum = substr(P_ACTIVITE,1,2)
    and tachenum = substr(P_ACTIVITE,3,2)
    and stachenum = substr(P_ACTIVITE,5,2)
    and ressbipcode = to_number(P_IDENT)
    and consodebdate = TO_DATE(P_DEBCONSO)
    ;

    END IF;


    EXCEPTION
    WHEN OTHERS THEN
    P_MESSAGE := 'INSERT_REJET_BIPS '||SQLERRM;
    END;


END INSERT_REJET_BIPS;

PROCEDURE DELETE_REJET_MENS_BIPS(P_VAR in varchar2,
                                 P_MESSAGE out varchar2) IS


BEGIN



  BEGIN
     DELETE tmp_rejetmens_bips;
     commit;
  EXCEPTION
  WHEN OTHERS THEN
  P_MESSAGE := SQLERRM;
  END;


END DELETE_REJET_MENS_BIPS;


PROCEDURE insert_bulk_to_bips(
                                  P_ARRAY_BIPS in array_table,
                                  P_PROVENANCE	  in   pmw_bips.PROVENANCE%type,
                                  P_PRIORITE	  in   pmw_bips.PRIORITE%type,
                                  P_USER	  in   pmw_bips.USER_PEC%type,
                                  P_DATE	  in   pmw_bips.DATE_PEC%type,
                                  P_FICHIER	  in   pmw_bips.FICHIER%type,
                                  P_MESSAGE out VARCHAR2
                                  ) IS
l_message VARCHAR2(32000);
l_proc VARCHAR2(32000) :='insert_bulk_to_bips';
l_ress_bloq VARCHAR2(32000):='';
t_array PACK_LIGNE_BIP.t_array;
t_array_data PACK_LIGNE_BIP.t_array;
cp_av number:=0;
cp_ap number:=0;
L_HFILE utl_file.file_type;
L_RETCOD number;
l_user VARCHAR2(32000):=pack_global.lire_globaldata(P_USER).idarpege;

l_cp_sr number :=0;
l_retour_sr_p2 VARCHAR2(32000);

l_priorite VARCHAR2(32767) := P_PRIORITE;
l_lock_p3 boolean := true;
l_lock_p2 boolean := true;

l_chaine_p2_la VARCHAR2(32767):=';';
l_chaine_p3_la VARCHAR2(32767):=';';

c_l_chaine_p2_la CLOB;
c_l_chaine_p3_la CLOB;

l_cp number := 0;

TYPE t_pid_prio IS TABLE OF VARCHAR2(2) INDEX BY VARCHAR2(4);
list_pid_prio t_pid_prio;
l_pid varchar2(4);

nb number;


BEGIN

    l_message := l_proc||' BEGIN ';
    P_MESSAGE :=   l_message;
    
    
    L_RETCOD := TRCLOG.INITTRCLOG( 'PL_LOGS' , 'insert_intranet_to_bips', L_HFILE );
    
        if ( L_RETCOD <> 0 ) then
            raise_application_error( TRCLOG_FAILED_ID,
                                     'Erreur : Gestion du fichier LOG impossible ',
                                     false );
        end if;
    
        TRCLOG.TRCLOG( L_HFILE, '<'||l_user||'> debut du traitement '||l_proc||' du fichier  '||P_FICHIER );
    
    BEGIN
    
    DBMS_OUTPUT.PUT_LINE('SIZE ARRAY '||P_ARRAY_BIPS.count);
    IF (l_priorite IS NULL OR l_priorite = '' OR l_priorite like '' OR UPPER(TRIM(l_priorite)) != 'P4' OR UPPER(TRIM(l_priorite)) NOT LIKE 'P4') THEN
    
    
        /*****************************************************************************************************/
        /* Lecture du fichier BIPS ligne par ligne et determiniation de la priorite et les lignes à supprimer
        /*****************************************************************************************************/
        for i in 1..P_ARRAY_BIPS.count-1 loop
        
            /***************************************************************************/
            /* Recuperation de la ligne
            /***************************************************************************/
            t_array := PACK_LIGNE_BIP.split(P_ARRAY_BIPS(i),';');
        
            /***************************************************************************/
            /* Construction d'un enregistrement à partir du fichier en entrée
            /***************************************************************************/
             for j in 1..t_array.count LOOP
             t_array_data(j) := t_array(j);
             END LOOP;
        
            /*QC 1870 */
            /***************************************************************************/
            /* Determination de la priorité
            /***************************************************************************/
            BEGIN
            
            l_priorite := list_pid_prio(t_array_data(1));
             
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
            
                  select count(pid) into l_cp_sr from ISAC_SOUS_TACHE where pid like t_array_data(1);
              
                  IF (l_cp_sr>0) THEN--P3
              
                  l_priorite := P3;
                  list_pid_prio(t_array_data(1)) := l_priorite ;
                
                  ELSE--P2
              
                  l_priorite := P2;
                  list_pid_prio(t_array_data(1)) := l_priorite ;
                  
                  END IF;
              
            END;
            /***************************************************************************/
            /*Recupération des structures à supprimer si 'LA'
            /***************************************************************************/
            BEGIN
            IF(upper(t_array_data(3)) like 'LA') THEN
            
                IF (l_priorite like P3) THEN
                
                      IF(INSTR(l_chaine_p3_la,t_array_data(1)) = 0) THEN
                      
                      l_chaine_p3_la := l_chaine_p3_la||t_array_data(1)||';';
                      
                      END IF;
                   
                ELSIF (l_priorite like P2) THEN
                    
                      IF(INSTR(l_chaine_p2_la,t_array_data(1)) = 0) THEN
                      
                      l_chaine_p2_la := l_chaine_p2_la||t_array_data(1)||';';
                      
                      END IF;
                    
                END IF;
              
            END IF;
            
            cp_ap := cp_ap+1;
            
            EXCEPTION
            WHEN OTHERS THEN
            
            TRCLOG.TRCLOG( L_HFILE, '<'||l_user||'> Exception dans la Recupération des structures LA du fichier '||P_FICHIER||' ligne '||cp_ap||' : '||t_array_data(1)||t_array_data(4)||t_array_data(7)||t_array_data(10)|| t_array_data(22) );
            TRCLOG.TRCLOG( L_HFILE, '<'||l_user||'> Exception dans la Recupération des structures LA du fichier '||P_FICHIER||' ligne '||cp_ap||' : '||SQLERRM);
            --DBMS_OUTPUT.PUT_LINE('Suppression des structures de la ligne BIP si code de structure action est ''LA'' '||SQLERRM);
            END;
            
        end loop;
         
        
        /***************************************************************************/
        /*Suppression des structures quand c'est 'LA'
        /***************************************************************************/   
         BEGIN
         
         TRCLOG.TRCLOG( L_HFILE, '<'||l_user||'> Suppression des SR LA ');          
         c_l_chaine_p3_la := TO_CLOB(l_chaine_p3_la);
         
       
         delete from isac_consomme where INSTR(c_l_chaine_p3_la,pid)>0;
         TRCLOG.TRCLOG( L_HFILE, '<'||l_user||'> delete from isac_consomme : '||SQL%ROWCOUNT);
         
         delete from isac_affectation where INSTR(c_l_chaine_p3_la,pid)>0;
         TRCLOG.TRCLOG( L_HFILE, '<'||l_user||'> delete from isac_affectation : '||SQL%ROWCOUNT);
         
         delete from isac_sous_tache where INSTR(c_l_chaine_p3_la,pid)>0;
         TRCLOG.TRCLOG( L_HFILE, '<'||l_user||'> delete from isac_sous_tache : '||SQL%ROWCOUNT);
         
         delete from isac_tache where INSTR(c_l_chaine_p3_la,pid)>0;
         TRCLOG.TRCLOG( L_HFILE, '<'||l_user||'> delete from isac_tache : '||SQL%ROWCOUNT);
         
         delete from isac_etape where INSTR(c_l_chaine_p3_la,pid)>0;
         TRCLOG.TRCLOG( L_HFILE, '<'||l_user||'> delete from isac_etape : '||SQL%ROWCOUNT);
         
         commit;
         
        
         c_l_chaine_p2_la := TO_CLOB(l_chaine_p2_la);
         
         delete from BIPS_ACTIVITE where INSTR(c_l_chaine_p2_la,lignebipcode)>0; 
         TRCLOG.TRCLOG( L_HFILE, '<'||l_user||'> delete from BIPS_ACTIVITE '||SQL%ROWCOUNT);

                  
         commit;
         
         TRCLOG.TRCLOG( L_HFILE, '<'||l_user||'> Fin suppression des SR LA '||SQLERRM);
         EXCEPTION
            WHEN OTHERS THEN
            TRCLOG.TRCLOG( L_HFILE, '<'||l_user||'> Exception dans la suppression des SR LA '||SQLERRM);
          --DBMS_OUTPUT.PUT_LINE(SQLERRM);
         END;
        
        
        
        /***************************************************************************/
        /*Insertion ligne par ligne dans PMW_BIPS
        /***************************************************************************/ 
        BEGIN
        
        cp_ap := 0;
        
        for i in 1..P_ARRAY_BIPS.count-1 loop
    
        /***************************************************************************/
        /* Recuperation de la ligne
        /***************************************************************************/
        t_array := PACK_LIGNE_BIP.split(P_ARRAY_BIPS(i),';');
    
        /***************************************************************************/
        /* Construction d'un enregistrement à partir du fichier en entrée
        /***************************************************************************/
        for j in 1..t_array.count LOOP
        t_array_data(j) := t_array(j);
        END LOOP;
         
        
        BEGIN
        insert_intranet_to_bips(trim(t_array_data(1)),
                             t_array_data(2),         --P_LIGNEBIPCLE
                             t_array_data(3),      --P_STRUCTUREACTION			  in   pmw_bips.STRUCTUREACTION%type,
                             t_array_data(4),         --P_ETAPENUM				  in   pmw_bips.ETAPENUM%type,
                             t_array_data(5),         --P_ETAPETYPE					  in   pmw_bips.ETAPETYPE%type,
                             t_array_data(6),         --P_ETAPELIBEL				  in   pmw_bips.ETAPELIBEL%type,
                             t_array_data(7),         --P_TACHENUM				  in   pmw_bips.TACHENUM%type,
                             t_array_data(8),         --P_TACHELIBEL				  in   pmw_bips.TACHELIBEL%type,
                             t_array_data(9),         --P_TACHEAXEMETIER				  in   pmw_bips.TACHEAXEMETIER%type, --SEL 6.11.2
                             t_array_data(10),         --P_STACHENUM				  in   pmw_bips.STACHENUM%type,
                             t_array_data(11),         --P_STACHETYPE				  in   pmw_bips.STACHETYPE%type,
                             t_array_data(12),         --P_STACHELIBEL					  in   pmw_bips.STACHELIBEL%type,
                             t_array_data(13),          --P_STACHEINITDEBDATE			  in   pmw_bips.STACHEINITDEBDATE%type,
                             t_array_data(14),          --P_STACHEINITFINDATE			  in   pmw_bips.STACHEINITFINDATE%type,
                             t_array_data(15),       --P_STACHEREVDEBDATE			  in   pmw_bips.STACHEREVDEBDATE%type,
                             t_array_data(16),         --P_STACHEREVFINDATE			  in   pmw_bips.STACHEREVFINDATE%type,
                             t_array_data(17),         --P_STACHESTATUT			  in   pmw_bips.STACHESTATUT%type,
                             to_number( replace(trim(t_array_data(18)),'.',',') ),         --P_STACHEDUREE					  in   pmw_bips.STACHEDUREE%type,
                             t_array_data(19),         --P_STACHEPARAMLOCAL			  in   pmw_bips.STACHEPARAMLOCAL%type,
                             t_array_data(20),         --P_RESSBIPCODE					  in   pmw_bips.RESSBIPCODE%type,
                             t_array_data(21),         --P_RESSBIPNOM				  in   pmw_bips.RESSBIPNOM%type,
                             t_array_data(22),        --P_CONSODEBDATE				  in   pmw_bips.CONSODEBDATE%type,
                             t_array_data(23),       --P_CONSOFINDATE				  in   pmw_bips.CONSOFINDATE%type,
                             to_number( replace(trim(t_array_data(24)),'.',',') ),         -- P_CONSOQTE				  in   pmw_bips.CONSOQTE%type,
                             P_PROVENANCE,         --P_PROVENANCE	  in   pmw_bips.PROVENANCE%type,
                             list_pid_prio(t_array_data(1)),         --P_PRIORITE	  in   pmw_bips.PRIORITE%type,
                             P_USER,         --P_USER	  in   pmw_bips.USER_PEC%type,
                             null,         --P_DATE	  in   pmw_bips.DATE_PEC%type,
                             P_FICHIER,         --P_FICHIER	  in   pmw_bips.FICHIER%type,
                             l_message        --P_MESSAGE out VARCHAR2
                                      );
         END;                          
                                     
    
         cp_ap := cp_ap+1;
            
         IF (l_message like 'RESSOURCE_BLOQUEE') THEN
                
             IF (INSTR(l_ress_bloq,t_array_data(20)||';') = 0 OR INSTR(l_ress_bloq,t_array_data(20)||';') is null) THEN
                
             l_ress_bloq := l_ress_bloq||t_array_data(20)||';';
                
             END IF;
            
            
         END IF;
    
        end loop;
        
        END;

        
        /***************************************************************************/
        /*Prise en charge des consommées P3
        /***************************************************************************/
         prise_en_charge_bips(P_FICHIER,''); 
    
   END IF;
    
    
    IF (INSTR(l_ress_bloq,';')>1) THEN
    
    P_MESSAGE := 'RESSOURCE_BLOQUEE Insertion du fichier '||P_FICHIER||' OK - '||cp_ap||' lignes - Sans prendre en compte les ressources qui sont en cours  d''integration par la saisie directe : '||l_ress_bloq;
    
    ELSE
    
    P_MESSAGE := 'RESSOURCE_LIBEREE Insertion du fichier '||P_FICHIER||' OK - '||cp_ap||' lignes';
    
    END IF;
    
  	   
    
    TRCLOG.TRCLOG( L_HFILE, '<'||l_user||'> fin NORMALE du traitement '||l_proc||' du fichier  '||P_FICHIER||' : '||cp_ap||' ligne(s)' );
    TRCLOG.CLOSETRCLOG( L_HFILE );
    EXCEPTION
    WHEN OTHERS THEN
    
    P_MESSAGE := 'MESSAGE_EXCEPTION '||l_proc||' : '||l_message||' - '||SQLERRM;
    

    TRCLOG.TRCLOG( L_HFILE, 'EXCEPTION dans '||l_proc||' - '||SQLERRM );
    
    TRCLOG.TRCLOG( L_HFILE, '<'||l_user||'> fin ANORMALE du traitement '||l_proc||' du fichier  '||P_FICHIER||' ligne '||cp_ap||' : '||t_array_data(1)||t_array_data(4)||t_array_data(7)||t_array_data(10)|| t_array_data(22) );
    
    TRCLOG.CLOSETRCLOG( L_HFILE );
    
    END;
    

END insert_bulk_to_bips;



--SEL QC 1846
PROCEDURE ARCHIVE_PURGE_PMW_BIPS(P_LOGDIR in varchar2) IS

L_HFILE utl_file.file_type;
L_RETCOD number;
l_proc varchar2(200) := 'ARCHIVE_PURGE_PMW_BIPS';

BEGIN

    L_RETCOD := TRCLOG.INITTRCLOG( 'PL_LOGS' , 'ARCHIVE_PURGE_PMW_BIPS', L_HFILE );

    if ( L_RETCOD <> 0 ) then
        raise_application_error( TRCLOG_FAILED_ID,
                                 'Erreur : Gestion du fichier LOG impossible ',
                                 false );
    end if;

    TRCLOG.TRCLOG( L_HFILE, 'Debut du traitement '||l_proc);

    --1)Archiver le dernier mois
    INSERT INTO ARCHIVE_PMW_BIPS (
    
        SELECT * FROM PMW_BIPS where 
        to_char(consodebdate,'MM/YYYY')=(select to_char(moismens,'MM/YYYY') from datdebex)
    
    );
    commit;
    TRCLOG.TRCLOG( L_HFILE, 'Recopie de '||SQL%ROWCOUNT||' lignes de PMW_BIPS vers ARCHIVE_PMW_BIPS');

    TRCLOG.TRCLOG( L_HFILE, 'Fin NORMALE du traitement '||l_proc);
    TRCLOG.CLOSETRCLOG( L_HFILE );
    
    --2)Purger la table PMW_BIPS
    PACKBATCH.DYNA_TRUNCATE('PMW_BIPS');
    
    --1)Supprmer l'archive qui date plus de 3 mois
    DELETE FROM ARCHIVE_PMW_BIPS where 
    to_char(consodebdate,'MM/YYYY')<(select to_char(ADD_MONTHS(moismens,-2),'MM/YYYY') from datdebex)
    ;


     
EXCEPTION
WHEN OTHERS THEN

    TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE du traitement '||l_proc);
    TRCLOG.CLOSETRCLOG( L_HFILE );


END ARCHIVE_PURGE_PMW_BIPS;


END pack_batch_bips;
/

