-- pack_appli PL/SQL
--
-- Cree le 17/06/2004 par MMC
------------------------------------------------------------
--
-- Ce package contient les traitements lies a l'import des
-- données sur les applications
-- modifié
-- ABA le 06/03/2009  TD 755
------------------------------------------------------------
------------------------------------------------------------
-- Creation du package
------------------------------------------------------------

CREATE OR REPLACE PACKAGE pack_appli AS

------------------------------------------------------------
-- Cette procedure modifie les donnees concernant le niveau
-- present dans la situation de la ressource
------------------------------------------------------------
    PROCEDURE alim_appli;

END pack_appli;
/


CREATE OR REPLACE PACKAGE BODY     pack_appli AS

PROCEDURE alim_appli IS
    
    L_STATEMENT varchar2(64);
BEGIN

--on vide la table des erreurs
L_STATEMENT := 'On vide la table temporaire';
DELETE FROM  TMP_APPLI_REJET;
COMMIT;
TRCLOG.TRCLOG(null,  L_STATEMENT ||'-'|| sql%rowcount || 'lignes supprimees');
--Gestion des anomalies : A inserer dans une TABLE des erreurs


/*L_STATEMENT := 'Insertion dans table temporaire pour code MO inexistant';
-- le code client MO n'existe pas dans la Bip
INSERT INTO TMP_APPLI_REJET
    (SELECT DISTINCT a.AIRT ,a.ALIBEL,a.ALIBCOURT ,a.AMNEMO ,a.ACDAREG ,a.CODSG ,a.ACME ,a.CLICODE ,a.AMOP ,a.CODGAPPLI ,a.AGAPPLI,
             a.ADESCR1 ,a.ADESCR2 ,a.ADESCR3,a.ADESCR4,a.ADESCR5,a.ADESCR6,'Code client MO inexistant'
     FROM TMP_APPLI a
      WHERE NOT EXISTS (SELECT 1 FROM CLIENT_MO c WHERE c.clicode=a.clicode)
      AND a.clicode is not null
      AND a.clicode <> 'S.O.'
      AND a.clicode <> 'S.O'
);
COMMIT;    
TRCLOG.TRCLOG(null,  L_STATEMENT ||'-'|| sql%rowcount || 'lignes inserees');

L_STATEMENT := 'Insertion dans table temporaire pour code gest inexistant';
-- le code gestionnaire n'existe pas dans la Bip
INSERT INTO TMP_APPLI_REJET
    (SELECT DISTINCT a.AIRT ,a.ALIBEL,a.ALIBCOURT ,a.AMNEMO ,a.ACDAREG ,a.CODSG ,a.ACME ,a.CLICODE ,a.AMOP ,a.CODGAPPLI ,a.AGAPPLI,
             a.ADESCR1 ,a.ADESCR2 ,a.ADESCR3,a.ADESCR4,a.ADESCR5,a.ADESCR6,'Code gestionnaire inexistant'
     FROM TMP_APPLI a
      WHERE NOT EXISTS (SELECT 1 FROM CLIENT_MO c WHERE c.clicode=a.CODGAPPLI)
      AND a.CODGAPPLI is not null
      AND a.CODGAPPLI <> 'S.O.'
      AND a.CODGAPPLI <> 'S.O'
);
COMMIT;    
TRCLOG.TRCLOG(null,  L_STATEMENT ||'-'|| sql%rowcount || 'lignes inserees');

L_STATEMENT := 'Insertion dans table temporaire pour code DPG inexistant';
-- le code DPG n'existe pas dans la Bip
INSERT INTO TMP_APPLI_REJET
    (SELECT DISTINCT a.AIRT ,a.ALIBEL,a.ALIBCOURT ,a.AMNEMO ,a.ACDAREG ,a.CODSG ,a.ACME ,a.CLICODE ,a.AMOP ,a.CODGAPPLI ,a.AGAPPLI,
             a.ADESCR1 ,a.ADESCR2 ,a.ADESCR3,a.ADESCR4,a.ADESCR5,a.ADESCR6,'Code DPG inexistant'
     FROM TMP_APPLI a
      WHERE NOT EXISTS (SELECT 1 FROM STRUCT_INFO s WHERE to_char(s.codsg)=a.codsg)
      AND a.CODSG is not null
      AND a.CODSG <> 'S.O.'
      AND a.CODSG <> 'S.O'
      );
COMMIT;    
TRCLOG.TRCLOG(null,  L_STATEMENT ||'-'|| sql%rowcount || 'lignes inserees');
*/

L_STATEMENT := 'Insertion dans table temporaire pour code appli reg inexistant';
-- le code application de regroupement n'existe pas dans la Bip
INSERT INTO TMP_APPLI_REJET
    (SELECT DISTINCT a.AIRT ,
        replace(replace(a.ALIBEL,'"',' '),';','.'),
        a.ALIBCOURT ,a.AMNEMO ,a.ACDAREG ,a.CODSG ,a.ACME ,a.CLICODE ,a.AMOP ,a.CODGAPPLI ,a.AGAPPLI,
         replace(replace(a.ADESCR1,'"',' '),';','.'),
        replace(replace(a.ADESCR2,'"',' '),';','.'),
        replace(replace(a.ADESCR3,'"',' '),';','.'),
        replace(replace(a.ADESCR4,'"',' '),';','.'),
        replace(replace(a.ADESCR5,'"',' '),';','.'),
        replace(replace(a.ADESCR6,'"',' '),';','.'),
        'Code appli regroupement inexistant'
     FROM TMP_APPLI a
      WHERE NOT EXISTS (SELECT 1 FROM APPLICATION ap WHERE ap.airt=a.acdareg)
      AND a.ACDAREG is not null
      AND a.ACDAREG <> 'S.O.'
      AND a.ACDAREG <> 'S.O'
      AND a.airt <> a.acdareg
      );
COMMIT;    
TRCLOG.TRCLOG(null,  L_STATEMENT ||'-'|| sql%rowcount || 'lignes inserees');

L_STATEMENT := 'Suppression codes appli regroupement errones';
DELETE FROM TMP_APPLI a
     WHERE a.airt in (SELECT rej.airt from tmp_appli_rejet rej where rej.rejet='Code appli regroupement inexistant')
    ;
    COMMIT;
    TRCLOG.TRCLOG(null,  L_STATEMENT ||'-'|| sql%rowcount || 'ligens supprimees');


BEGIN 
    L_STATEMENT := 'Mise à jour de APPLICATION';
    UPDATE application ap
        SET (ALIBEL,ALIBCOURT ,AMNEMO ,ACDAREG ,ACME , AMOP,AGAPPLI,
        ADESCR) =
         (SELECT    convert(replace(replace(a.ALIBEL,'"',' '),';','.'),'US7ASCII','WE8PC850'),
         a.ALIBCOURT ,a.AMNEMO ,nvl(a.ACDAREG,a.airt),a.ACME,a.AMOP,a.AGAPPLI,
         upper(convert(replace(replace(trim(a.ADESCR1),'"',' '),';','.') ||
        replace(replace(trim(a.ADESCR2),'"',' '),';','.')  ||
        replace(replace(trim(a.ADESCR3),'"',' '),';','.')  ||
        replace(replace(trim(a.ADESCR4),'"',' '),';','.')  ||
        replace(replace(trim(a.ADESCR5),'"',' '),';','.')  ||
        replace(replace(trim(a.ADESCR6),'"',' '),';','.'),'US7ASCII','WE8PC850'))
             FROM TMP_APPLI a
             WHERE a.airt=ap.airt
             )
         WHERE ap.airt IN (SELECT t.airt FROM TMP_APPLI t,application ap WHERE t.airt=ap.airt)
         ;
        COMMIT;
    TRCLOG.TRCLOG(null,  L_STATEMENT || ' : ' || sql%rowcount || ' lignes maj' );    
    
    L_STATEMENT := 'Insertion dans APPLICATION';    
    --Le code appli n existe pas, on le crée
    INSERT INTO application (AIRT ,ALIBEL,ALIBCOURT ,AMNEMO ,ACDAREG ,ACME ,AMOP ,AGAPPLI,ADESCR,FLAGLOCK)
         (SELECT a.AIRT,
         convert(replace(replace(a.ALIBEL,'"',' '),';','.'),'US7ASCII','WE8PC850'),
         a.ALIBCOURT,a.AMNEMO ,nvl(a.ACDAREG,a.AIRT),a.ACME,a.AMOP ,a.AGAPPLI,
              upper(convert(replace(replace(trim(a.ADESCR1),'"',' '),';','.') ||
        replace(replace(trim(a.ADESCR2),'"',' '),';','.')  ||
        replace(replace(trim(a.ADESCR3),'"',' '),';','.')  ||
        replace(replace(trim(a.ADESCR4),'"',' '),';','.')  ||
        replace(replace(trim(a.ADESCR5),'"',' '),';','.')  ||
        replace(replace(trim(a.ADESCR6),'"',' '),';','.'),'US7ASCII','WE8PC850')),0 
         FROM TMP_APPLI a
             WHERE NOT EXISTS (select 1 from application ap WHERE ap.airt=a.airt)
         );
        COMMIT;
    TRCLOG.TRCLOG(null,  L_STATEMENT ||'-'|| sql%rowcount || 'lignes inserees');
    
    /*L_STATEMENT := 'Maj code MO dans APPLICATION';
    -- avec client MO inexistant
    UPDATE application ap
        SET (CLICODE) =
         (SELECT    decode(err.rejet,'Code client MO inexistant',null,decode(a.clicode,'S.O.',null,decode(a.clicode,'S.O',null,a.CLICODE)))
             FROM TMP_APPLI a, TMP_APPLI_REJET err
             WHERE a.airt=ap.airt
             AND a.airt=err.airt (+)
             AND err.rejet(+)='Code client MO inexistant'
             )
         WHERE ap.airt IN (SELECT t.airt FROM TMP_APPLI t,application ap WHERE t.airt=ap.airt)
         ;
        COMMIT;
    TRCLOG.TRCLOG(null,  L_STATEMENT ||'-'|| sql%rowcount || 'lignes maj');
        
    L_STATEMENT := 'Maj code gestionnaire dans APPLICATION';
    -- avec code gestionnaire inexistant
    UPDATE application ap
        SET (CODGAPPLI) =
         (SELECT    decode(err.rejet,'Code gestionnaire inexistant',null,decode(a.codgappli,'S.O.',null,decode(a.codgappli,'S.O',null,a.CODGAPPLI))) 
             FROM TMP_APPLI a, TMP_APPLI_REJET err
             WHERE a.airt=ap.airt
             AND a.airt=err.airt (+)
             AND err.rejet(+)='Code gestionnaire inexistant'
             )
         WHERE ap.airt IN (SELECT t.airt FROM TMP_APPLI t,application ap WHERE t.airt=ap.airt)
         ;
        COMMIT;
    TRCLOG.TRCLOG(null,  L_STATEMENT ||'-'|| sql%rowcount || 'lignes maj');
    */
    
    END;
END alim_appli;



END pack_appli;
/


