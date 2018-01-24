-- pack_societe PL/SQL
--
-- Equipe SOPRA 
--
-- Crée le 18/02/1999
-- 
-- @g:\COMMUN\Lot1_Dev\SOURCE\PLSQL\TP\societe.sql;
--
-- ************************************************************
-- MODIF :
-- Quand    	Qui  	Nom                   	Quoi
-- -------- 	---  	--------------------  	----------------------------------------
-- xx/xx/xxxx   VPR  	gestion_contrat  		Ajout  
-- xx/xx/xxxx   VPR		gestion_situ_res		Ajout
-- 09/02/2000	HTM		gestion_contrat		Ajout Test Exception WHEN DUP_VAL_ON_INDEX 
-- 09/02/2000	HTM		gestion_situ_res		(1) Création nouvelles situations (INSERT) pour les situations tq
--							          (datsitu) < Date fermeture + 1 jour calendaire.
--								(2) Transfert des situations tq  (datsitu) >= Date fermeture + 1 
--								    vers la nouvelle société via un chment du code société (UPDATE)
--								(3) Ajout Test Exception WHEN DUP_VAL_ON_INDEX 
--
-- 11/02/2000	HTM	gestion_contrat		Création de nouveaux contrats/lignes de contrat ssi date de début 
--								ancien contrat/lignes contrat < Date fermeture + 1 
--								Transfert des contrats/lignes tq  (date début) >= Date fermeture + 1 
--								vers la nouvelle société via un chment du code société 
--								(UPDATE direct impossible car Intégrité référentielle CONTRAT/LIGNE CONTRAT)
--								SOLUTION : Création nouveaux contrats + Suppression après MAJ des lignes de contrat
-- 28/05/2003   NBM     suppression dans Societe_ViewType des champs inutiles
-- 12/07/2004	EGR		F370					retrait de filcode dans situ_ress et situ_ress_full
-- 14/02/2005	PPR	Ajout de valeurs au controle de la nature de la societe
-- 27/03/2006	PPR	Ajout valeur 'R' au controle de la nature de la societe
-- 29/08/2007	DDI	TD586 Modification de la gestion des contrats quand une société change de nom. ( Incrémentation du n° de ligne contrat )
--18/03/2008     JAL  numéro de ligne +1 = max numigne +1 lorque modification code société : problème rencontré en PROD
-- 08/04/2008    JAL fiche 641 (on prend num ligne max +1 par rapport à celiu trouvé pour le couple soccont,numcon,lcnum
-- 30/05/2008    JAL correction etape 6  : rajout sécurité : si pas de lignes contrat trouvées on ne traite pas pour éviter NO DATA FOUND EXCEPTION
-- 29/07/2008    EVI  TD 637: refonte societe
-- 26/08/2008    ABA TD 675: siren en cas de rachat de societe
-- 17/04/2009    EVI : TD737 augmentation de la taille du numero de contrat + avenant 27+3
-- 20/01/2011    ABA : QC 1099
-- 18/02/2011    CMA : QC 996 Gestion du siren au changement de societe
-- 29/03/2011    BSA : QC 1107
-- 17/05/2011    CMA : QC1182 Lors du changement de société, le nblcnum n'était pas copié dans les contrats
--*************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE     pack_societe AS

  -- Définition curseur sur la table des contrats

  TYPE contratCurType IS REF CURSOR RETURN contrat%ROWTYPE;

  -- Définition curseur sur la table des situations ressources

  TYPE situ_ressCurType IS REF CURSOR RETURN situ_ress%ROWTYPE;

  TYPE Societe_ViewType IS RECORD( soccode      societe.soccode%TYPE,
                   socgrpe      societe.socgrpe%TYPE,
                   soclib       societe.soclib%TYPE,
                   socnat       societe.socnat%TYPE,
                   soccat       societe.soccat%TYPE,
                   soccre       varchar2(10),
                   socfer_ch    varchar2(10),
                   socnou       societe.socnou%TYPE,
                   soccop       societe.soccop%TYPE,
                   socfer_cl    varchar2(10),
                   soccom       societe.soccom%TYPE,
                   flaglock     societe.flaglock%TYPE,
                   sirennou     varchar2(9));

  TYPE societeCurType_Char IS REF CURSOR RETURN Societe_ViewType;

PROCEDURE insert_societe ( p_soccode   IN societe.soccode%TYPE,
               p_socgrpe   IN societe.socgrpe%TYPE,
               p_soccat    IN societe.soccat%TYPE,
               p_socnat    IN societe.socnat%TYPE,
               p_soclib    IN societe.soclib%TYPE,
               p_soccre    IN VARCHAR2,
               p_userid    IN VARCHAR2,
               p_nbcurseur OUT INTEGER,
               p_message   OUT VARCHAR2
             );

PROCEDURE update_societe ( p_soccode       IN societe.soccode%TYPE,
               p_socgrpe       IN societe.socgrpe%TYPE,
               p_soclib        IN societe.soclib%TYPE,
               p_socnat        IN societe.socnat%TYPE,
               p_soccat        IN societe.soccat%TYPE,
               p_soccre        IN VARCHAR2,
               p_socfer_ch     IN VARCHAR2,
               p_socnou        IN societe.socnou%TYPE,
               p_soccop        IN societe.soccop%TYPE,
               p_socfer_cl     IN VARCHAR2,
               p_soccom        IN societe.soccom%TYPE,
               p_flaglock      IN NUMBER,
               p_userid        IN VARCHAR2,
               p_siren         IN VARCHAR2,
               p_nbcurseur     OUT INTEGER,
               p_message       OUT VARCHAR2
             );

PROCEDURE delete_societe ( p_soccode   IN societe.soccode%TYPE,
               p_flaglock  IN NUMBER,
               p_userid    IN VARCHAR2,
               p_nbcurseur OUT INTEGER,
               p_message   OUT VARCHAR2 );

PROCEDURE select_societe ( p_soccode    IN societe.soccode%TYPE,
               p_userid     IN VARCHAR2,
               p_curSociete IN OUT societeCurType_Char,
               p_datcre     OUT VARCHAR2,
               p_nbcurseur  OUT INTEGER,
               p_message    OUT VARCHAR2
             );

PROCEDURE gestion_contrat( p_ancsoccode IN CHAR,
               p_dfersoc    IN CHAR,
               p_nousoccode IN CHAR,
               p_siren      IN VARCHAR2
             );

PROCEDURE gestion_situ_res(p_ancsoccode IN CHAR,
               p_dfersoc    IN CHAR,
                p_nousoccode IN CHAR
               );

PROCEDURE RECUP_LIB_SOCCODE(p_soccode        IN    SOCIETE.SOCCODE%TYPE,
                               p_lib_soccode    OUT    VARCHAR2,
                               p_message        OUT     VARCHAR2);

PROCEDURE RECUP_LIB_SIREN(p_soccode        IN    SOCIETE.SOCCODE%TYPE,
                               p_lib_siren    OUT    VARCHAR2,
                               p_lib_soccode    OUT    VARCHAR2,
                               p_message        OUT     VARCHAR2);


-- Liste les sirens de la table agence pour un code société donné
PROCEDURE LISTER_SIREN_AGENCE(p_code IN VARCHAR2,
                       p_curSiren  IN OUT Pack_Liste_Dynamique.liste_dyn );

END pack_societe;
/


CREATE OR REPLACE PACKAGE BODY     Pack_Societe AS

PROCEDURE gestion_contrat( p_ancsoccode IN CHAR,
               p_dfersoc    IN CHAR,
               p_nousoccode IN CHAR,
               p_siren      IN VARCHAR2
             ) IS
   l_msg VARCHAR(1024);
   referential_integrity   EXCEPTION;
   PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

   l_cav     CONTRAT.CAV%TYPE;
   l_lcnum   LIGNE_CONT.LCNUM%TYPE;
   l_soccont CONTRAT.SOCCONT%TYPE;
   l_numcont CONTRAT.NUMCONT%TYPE;


    l_ligne_max NUMBER;

    l_test NUMBER ;

    l_count NUMBER ;

   CURSOR curseur_ligne IS
           SELECT (lco.lcnum +1),
                 lco.lfraisdep ,
                 lco.lastreinte,
                 lco.lheursup  ,
                 (TO_DATE(p_dfersoc, 'yyyymmdd') + 1)   lresdeb,
                 lco.lresfin   ,
                 lco.lcdatact  ,
                 lco.lccouact  ,
                 lco.lccouinit ,
                 lco.lcprest   ,
                 lco.cav       ,
                 lco.numcont   ,
                 lco.ident     ,
                 lco.mode_contractuel   -- 29/03/2011    BSA : QC 1107 
             FROM  LIGNE_CONT lco
             WHERE lco.soccont = p_ancsoccode
             AND   ( lco.lresfin > TO_DATE(p_dfersoc, 'yyyymmdd') )
               --
             -- HTM 11/02/2000
             AND  ( lco.lresdeb <  (TO_DATE(p_dfersoc, 'yyyymmdd') + 1)  )
              -- Important ORDER BY INDISPENSABLE AVECE CES COLONNES
             -- car utilisé pour l'insertion qui vérifie
             -- dés qu'une valeur NUMCONT ou CAV change il faut
             -- recalculer le numéro de ligne MAX
             ORDER BY
             SOCCONT,NUMCONT,CAV,LCNUM;

BEGIN
   ------------------------------------------------------------------------
   -- En cas d'erreur on renvoie l'erreur a JS qui fera un rollback
   -------------------------------------------------------------------------

 /**********************************************************************************************
           TRAITEMENT DES CONTRATS ET LIGNES DE CONTRAT
 ***********************************************************************************************/

   -- Creation des nouveaux contrats avec soccont = nouveau nom de la societe
   -- et cdardeb = date de fermeture de la societe + 1 jour calendaire.
   -- flaglock = 0 et soccont = nouvel societe
   -- Pour Information : CONTRAT_PK = NUMCONT, SOCCONT, CAV
   --
   -- -----------------------------HTM 11/02/2000 --------------------------------------------
   -- IL NE FAUT CREER  CES NOUVEAUX CONTRATS QUE  SI (cdatbeb) <= p_dfersoc  DANS ANCIENNE SOCIETE
   -- car sinon, on finirait par fermer les anciens contrats avec (cdatfin) qui vaudrait p_dfersoc
   -- et qui serait donc inférieur à (cdatdeb)
   -- NE PAS OUBLIER QUE CHAQUE NOUVELLE CREATION EST SUIVIE D'UNE FERMETURE DE L'ANCIEN CONTRAT !!!
   -- Pour les cas où (cdatdeb) > p_dfersoc, IL FAUT FAIRE SIMPLEMENT UN UPDATE du code de la société !!!
   --
   -- ATTENTION : NE PAS MODIFIER L'ORDRE DES ETAPES CI-DESSOUS !!!
   -- -----------------------------------------------------------------------------------------------

   ------------------------------ (ETAPE 1 : CREATION NOUVEAUX CONTRATS) ----------------------------

   BEGIN

      INSERT INTO CONTRAT (numcont   ,
               cchtsoc   ,
               ctypfact  ,
               cobjet1   ,
               cobjet2   ,
               cobjet3   ,
               crem      ,
               cantfact  ,
               cmoiderfac,
               cmmens    ,
               ccharesti ,
               cecartht  ,
               cevainit  ,
               cnaffair  ,
               cagrement ,
               crang     ,
               cantcons  ,
               ccoutht   ,
               cdatannul ,
               cdatarr   ,
               cdatclot  ,
               cdatdeb   ,
               cdatsoce  ,
               cdatfin   ,
               cdatmaj   ,
               cdatdir   ,
               cdatbilq  ,
               cdatrpol  ,
               cdatsocr  ,
               cdatsai   ,
               cduree    ,
               flaglock  ,
               soccont   ,
               cav       ,
               filcode   ,
               comcode   ,
               NICHE     ,
               codsg ,
               ccentrefrais,
               siren,
               nblcnum,
               top30)
    (SELECT cont.numcont   ,
     cont.cchtsoc   ,
     cont.ctypfact  ,
     cont.cobjet1   ,
     cont.cobjet2   ,
     cont.cobjet3   ,
     cont.crem      ,
     cont.cantfact  ,
     cont.cmoiderfac,
     cont.cmmens    ,
     cont.ccharesti ,
     cont.cecartht  ,
     cont.cevainit  ,
     cont.cnaffair  ,
     cont.cagrement ,
     cont.crang     ,
     cont.cantcons  ,
     cont.ccoutht   ,
     cont.cdatannul ,
     cont.cdatarr   ,
     cont.cdatclot  ,
     TO_DATE(p_dfersoc, 'yyyymmdd') + 1, -- date de fermeture des anciennes societes +1 jour calendaire
     cont.cdatsoce  ,
     cont.cdatfin   ,
     cont.cdatmaj   ,
     cont.cdatdir   ,
     cont.cdatbilq  ,
     cont.cdatrpol  ,
     cont.cdatsocr  ,
     cont.cdatsai   ,
     cont.cduree    ,
     0         ,   -- FLAGLOCK
     p_nousoccode, -- Nouvelle societe
     cont.cav       ,
     cont.filcode   ,
     cont.comcode   ,
     cont.NICHE     ,
     cont.codsg     ,
     cont.ccentrefrais,
     to_number(p_siren),
     cont.nblcnum,
     cont.top30
     FROM CONTRAT cont
     WHERE cont.soccont = p_ancsoccode
     AND   ( cont.cdatfin > TO_DATE(p_dfersoc, 'yyyymmdd') )
     --
     -- HTM 11/02/2000
     AND  ( cont.cdatdeb <  (TO_DATE(p_dfersoc, 'yyyymmdd') + 1)  )
     );

   EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    -- 'Problème lors de la création des nouveaux contrats : Contrat en double pour une même société!'
    Pack_Global.recuperer_message( 20616, NULL, NULL, NULL, l_msg);
    RAISE_APPLICATION_ERROR( -20616, l_msg);

      WHEN OTHERS THEN
      -- Dans les autres cas, quelque soit l'erreur on renvoie un message d'erreur
      -- 'Problème lors de la creation des nouveaux contrats'
    Pack_Global.recuperer_message( 20296, NULL, NULL, NULL, l_msg);
    RAISE_APPLICATION_ERROR( -20296, l_msg);
   END;

   ------------------------------ (ETAPE 2) ---------------------------------------------------------------
   -- Fermeture des anciens contrats qui ont permis de créer les nouveaux contrats  à l'Etape 1 :
   --    -----------------------------------------------------------------------------------------------------
   -- Mis a jour des anciens contrats
   -- Avec date de fin = date de fermeture de la societe
   -- et cchtsoc = 'A'
   BEGIN

      UPDATE CONTRAT
    SET cdatfin = TO_DATE(p_dfersoc, 'yyyymmdd'),
    cchtsoc = 'A',
    flaglock = DECODE( flaglock, 1000000, 0, flaglock + 1)
    WHERE soccont = p_ancsoccode
    AND   ( cdatfin > TO_DATE(p_dfersoc, 'yyyymmdd') )
     --
     -- HTM 11/02/2000
     AND  ( cdatdeb <  (TO_DATE(p_dfersoc, 'yyyymmdd') + 1)  ) ;

   EXCEPTION
     WHEN referential_integrity THEN
     -- habiller le msg erreur
     --pack_global.recuperation_integrite(-2292);
     RAISE_APPLICATION_ERROR(-20997, SQLERRM);

      -- quelque soit l'erreur on renvoie un message d'erreur
      -- 'Problème lors de la mis a jour des anciens contrats'
      WHEN OTHERS THEN

    Pack_Global.recuperer_message( 20297, NULL, NULL, NULL, l_msg );
    RAISE_APPLICATION_ERROR( -20297, l_msg || ' (... ETAPE 2 ...)' );
   END;

   ---------------------------- (ETAPE 3) -------------------------------------------------------------

   -- Transfert des anciens contrats vérifiant (cdatdeb) >= p_dfersoc + 1 jour calendaire
   -- vers la nouvelle société :
   -- A CAUSE DE L'INTEGRITE REFERENTIELLE CONTRAT -> LIGNE DE CONTRAT
   -- ON NE PEUT FAIRE DE UPDATE DIRECTE DE LA SOCIETE :
   -- SOLUTION :
   --          (1) Duplication des contrats vérifiant (cdatdeb) >= p_dfersoc + 1 jour calendaire
   --             Avec société = nouvelle société et et cchtsoc = 'A'
   --        (2) Après MAJ des lignes de contrat, suppression des anciens contrats vérifiant (cdatdeb) >= p_dfersoc + 1
   --------------------------------------------------------------------------------------------------------

   BEGIN

      INSERT INTO CONTRAT (numcont   ,
               cchtsoc   ,
               ctypfact  ,
               cobjet1   ,
               cobjet2   ,
               cobjet3   ,
               crem      ,
               cantfact  ,
               cmoiderfac,
               cmmens    ,
               ccharesti ,
               cecartht  ,
               cevainit  ,
               cnaffair  ,
               cagrement ,
               crang     ,
               cantcons  ,
               ccoutht   ,
               cdatannul ,
               cdatarr   ,
               cdatclot  ,
               cdatdeb   ,
               cdatsoce  ,
               cdatfin   ,
               cdatmaj   ,
               cdatdir   ,
               cdatbilq  ,
               cdatrpol  ,
               cdatsocr  ,
               cdatsai   ,
               cduree    ,
               flaglock  ,
               soccont   ,
               cav       ,
               filcode   ,
               comcode   ,
               NICHE     ,
               codsg     ,
               ccentrefrais,
               siren,
               nblcnum,
               top30)
    (SELECT cont.numcont   ,
     'A'               ,            -- cchtsoc
     cont.ctypfact  ,
     cont.cobjet1   ,
     cont.cobjet2   ,
     cont.cobjet3   ,
     cont.crem      ,
     cont.cantfact  ,
     cont.cmoiderfac,
     cont.cmmens    ,
     cont.ccharesti ,
     cont.cecartht  ,
     cont.cevainit  ,
     cont.cnaffair  ,
     cont.cagrement ,
     cont.crang     ,
     cont.cantcons  ,
     cont.ccoutht   ,
     cont.cdatannul ,
     cont.cdatarr   ,
     cont.cdatclot  ,
     cdatdeb        ,
     cont.cdatsoce  ,
     cont.cdatfin   ,
     cont.cdatmaj   ,
     cont.cdatdir   ,
     cont.cdatbilq  ,
     cont.cdatrpol  ,
     cont.cdatsocr  ,
     cont.cdatsai   ,
     cont.cduree    ,
     0              ,   -- FLAGLOCK
     p_nousoccode   ,   -- Nouvelle societe
     cont.cav       ,
     cont.filcode   ,
     cont.comcode   ,
     cont.NICHE     ,
     cont.codsg     ,
     cont.ccentrefrais,
     to_number(p_siren),
     cont.nblcnum,
     cont.top30
     FROM CONTRAT cont
     WHERE cont.soccont = p_ancsoccode
     AND   ( cont.cdatfin > TO_DATE(p_dfersoc, 'yyyymmdd') )
     AND  ( cont.cdatdeb >=  (TO_DATE(p_dfersoc, 'yyyymmdd') + 1)  )
     );

   EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    -- 'Problème lors de la création des nouveaux contrats : Contrat en double pour une même société!'
    Pack_Global.recuperer_message( 20616, NULL, NULL, NULL, l_msg);
    RAISE_APPLICATION_ERROR( -20616, l_msg);

        WHEN OTHERS THEN
      -- Dans les autres cas, quelque soit l'erreur on renvoie un message d'erreur
      -- 'Problème lors de la creation des nouveaux contrats'
    Pack_Global.recuperer_message( 20296, NULL, NULL, NULL, l_msg);
    RAISE_APPLICATION_ERROR( -20296, l_msg);
   END;



    ------------------------------ (ETAPE 4 : CREATION NOUVELLES LIGNE DE  CONTRATS) ----------------------------
   -- Creation des ligne de contrat
   -- avec la nouvelle societe et une date de debut = date de fermeture de la societe + 1
   ---------------------------------------------------------------------------------------------------------------

   BEGIN





     /* INSERT INTO LIGNE_CONT(lcnum     ,
                 lfraisdep ,
                 lastreinte,
                 lheursup  ,
                 lresdeb   ,
                 lresfin   ,
                 lcdatact  ,
                 lccouact  ,
                 lccouinit ,
                 lcprest   ,
                 soccont   ,
                 cav       ,
                 numcont   ,
                 ident
                 )
    (SELECT (lco.lcnum +1),
     lco.lfraisdep ,
     lco.lastreinte,
     lco.lheursup  ,
     (TO_DATE(p_dfersoc, 'yyyymmdd') + 1)   lresdeb,
     lco.lresfin   ,
     lco.lcdatact  ,
     lco.lccouact  ,
     lco.lccouinit ,
     lco.lcprest   ,
     p_nousoccode,
     lco.cav       ,
     lco.numcont   ,
     lco.ident
     FROM  LIGNE_CONT lco
     WHERE lco.soccont = p_ancsoccode
     AND   ( lco.lresfin > TO_DATE(p_dfersoc, 'yyyymmdd') )
       --
     -- HTM 11/02/2000
     AND  ( lco.lresdeb <  (TO_DATE(p_dfersoc, 'yyyymmdd') + 1)  )
     );*/


         l_numcont := ' ' ;
         l_cav     := ' ' ;
         l_ligne_max := 0;


         FOR rec_lignes IN curseur_ligne LOOP
          BEGIN

                -------------------------------------------------------------------------------------------------------------
            -- A chaque nouveau couple : (SOCCONT,NUMCONT,CAV)
              -- il faut récupérer le numéro de ligne maxi sur lequel
              -- on va se baser pour faire numéro ligne + 1  dans la boucle
             IF( TRIM(rec_lignes.numcont) !=  TRIM(l_numcont) OR  rec_lignes.cav != l_cav  ) THEN
                  SELECT NBLCNUM INTO l_ligne_max FROM
                  CONTRAT lco
                  WHERE
                  lco.soccont = p_ancsoccode
                  AND lco.numcont = rec_lignes.numcont
                  AND lco.cav = rec_lignes.cav ;
                  -- On met à jour avec les nouvelles valeurs l_numcont, l_cav
                  l_numcont := rec_lignes.numcont;
                  l_cav := rec_lignes.cav;
              END IF ;
             -- A chaque nouvelle ligne contrat insérée pour le coupe de valeurs
             -- soccont,numcont, cav  on incrémente de 1 le numéro de ligne
             -- en se basant sur le max que l'on avait trouvé
             l_ligne_max := l_ligne_max + 1 ;

            -------------------------------------------------------------------------------------------------------------
             INSERT INTO LIGNE_CONT(lcnum     ,
                 lfraisdep ,
                 lastreinte,
                 lheursup  ,
                 lresdeb   ,
                 lresfin   ,
                 lcdatact  ,
                 lccouact  ,
                 lccouinit ,
                 lcprest   ,
                 soccont   ,
                 cav       ,
                 numcont   ,
                 ident     ,
                 mode_contractuel
                 )VALUES
                    ( l_ligne_max ,
                     rec_lignes.lfraisdep ,
                     rec_lignes.lastreinte,
                     rec_lignes.lheursup  ,
                     rec_lignes.lresdeb,
                     rec_lignes.lresfin   ,
                     rec_lignes.lcdatact  ,
                     rec_lignes.lccouact  ,
                     rec_lignes.lccouinit ,
                     rec_lignes.lcprest   ,
                     p_nousoccode,
                     rec_lignes.cav       ,
                     rec_lignes.numcont   ,
                     rec_lignes.ident     ,
                     rec_lignes.mode_contractuel
                     );

          END;
        END LOOP ;







   EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    -- 'Problème lors de la creation des nouvelles lignes de contrats : Ligne de contrat en double pour une même société!'
    Pack_Global.recuperer_message( 20617, NULL, NULL, NULL, l_msg);
    RAISE_APPLICATION_ERROR( -20617, l_msg);

      WHEN OTHERS THEN
      -- Dans les autres cas, quelque soit l'erreur on renvoie un message d'erreur
      -- 'Problème lors de la creation des nouvelles lignes de contrats'
    Pack_Global.recuperer_message( 20298, NULL, NULL, NULL, l_msg);
    RAISE_APPLICATION_ERROR( -20298, l_msg);
   END;

   ------------------------------ (ETAPE 5) ---------------------------------------------------------------
   -- Fermeture des anciennes ligne de contrats qui ont permis de créer les nouvelles lignes  à l'Etape précédente :
   --
   -- Mis a jour des lignes de contrat
   -- avec la date de fin = date de fermeture de la societe.
   --------------------------------------------------------------------------------------------------------

   BEGIN

      UPDATE LIGNE_CONT
    SET  lresfin     = TO_DATE(p_dfersoc, 'yyyymmdd')
    WHERE soccont = p_ancsoccode
    AND   ( lresfin > TO_DATE(p_dfersoc, 'yyyymmdd') )
    --
    -- HTM 11/02/2000
    AND  ( lresdeb <  (TO_DATE(p_dfersoc, 'yyyymmdd') + 1)  ) ;

   EXCEPTION
     WHEN referential_integrity THEN
     -- habiller le msg erreur
     -- pack_global.recuperation_integrite(-2292);
     RAISE_APPLICATION_ERROR(-20997, SQLERRM);

      -- quelque soit l'erreur on renvoie un message d'erreur
      -- 'Problème lors de la mis a jour des ancienes ligne de contrats'
      WHEN OTHERS THEN
    Pack_Global.recuperer_message( 20299, NULL, NULL, NULL, l_msg );
    RAISE_APPLICATION_ERROR( -20299, l_msg || ' (... ETAPE 5 ...)' );
   END;

   ---------------------------- (ETAPE 6) -------------------------------------------------------------

   -- Transfert des anciennes lignes de contrat vérifiant (lresdeb) >= p_dfersoc + 1 jour calendaire
   -- vers la nouvelle société via un Update du code société

   -- Mise a jour des lignes de contrat
   -- avec la société = Nouvelle société.
   -----------------------------------------------------------------------------------------------------

  BEGIN



  -- regarde s'il y a des lignes contrat commençant aprés la date de fermeture ancienne société
    select count(*) into l_count FROM LIGNE_CONT
     WHERE soccont = p_ancsoccode
     AND   ( lresfin > TO_DATE(p_dfersoc, 'yyyymmdd') )
     AND  ( lresdeb >=  (TO_DATE(p_dfersoc, 'yyyymmdd') + 1)  ) AND ROWNUM = 1  ;

  -- Si des lignes contrat commencent aprés la date de fermeture
  IF(l_count>0) THEN
             -- Avant les traitements : on récupère les numcont ,soccont, cav , lcnum
             -- de la première ligne trouvée qui commence aprés la date de fermture
             -- afin de pouvoir fournir des infos pour la log is on tombe sur une
             -- DUP_VAL_ON_INDEX (voir gestion exception ci dessous)
             SELECT numcont,soccont, cav,lcnum  INTO  l_numcont,l_soccont, l_cav, l_lcnum   FROM LIGNE_CONT
             WHERE soccont = p_ancsoccode
             AND   ( lresfin > TO_DATE(p_dfersoc, 'yyyymmdd') )
             AND  ( lresdeb >=  (TO_DATE(p_dfersoc, 'yyyymmdd') + 1)  ) AND ROWNUM = 1  ;


             -- Maj des lignes avec nouveau code société
             UPDATE LIGNE_CONT
             SET  soccont     = p_nousoccode
             WHERE soccont = p_ancsoccode
             AND   ( lresfin > TO_DATE(p_dfersoc, 'yyyymmdd') )
             --
             -- HTM 11/02/2000
             AND  ( lresdeb >=  (TO_DATE(p_dfersoc, 'yyyymmdd') + 1)  ) ;
   END IF ;

   EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN
        Pack_Global.recuperer_message( 20299, NULL, NULL, NULL, l_msg);
        RAISE_APPLICATION_ERROR( -20299, l_msg || ' CLEF EN DOUBLE: NUMCONT =' || TRIM(l_numcont) || ' SOCCONT =' ||l_soccont
        || ' CAV =' || l_cav || ' LCNUM =' || l_lcnum   );



     WHEN referential_integrity THEN
     -- habiller le msg erreur
     --pack_global.recuperation_integrite(-2292);
     RAISE_APPLICATION_ERROR(-20997, SQLERRM);

      -- quelque soit l'erreur on renvoie un message d'erreur
      -- 'Problème lors de la mise a jour des ancienes ligne de contrats'


      -- quelque soit l'erreur on renvoie un message d'erreur
      -- 'Problème lors de la mise a jour des ancienes ligne de contrats'
      WHEN OTHERS THEN
    Pack_Global.recuperer_message( 20299, NULL, NULL, NULL, l_msg);
    RAISE_APPLICATION_ERROR( -20299, l_msg || ' (... ETAPE 6 ...)' );
   END;

   ---------------------------- (ETAPE 7) -------------------------------------------------------------
   -- Suppression des anciens contrats qu'on avait conservé à cause INTEGRITE REFERENTIELLE CONTRAT -> LIGNE DE CONTRAT
   ----------------------------------------------------------------------------------------------------

   BEGIN

      DELETE FROM CONTRAT
    WHERE soccont = p_ancsoccode
    AND   ( cdatfin > TO_DATE(p_dfersoc, 'yyyymmdd') )
    AND  ( cdatdeb >=  (TO_DATE(p_dfersoc, 'yyyymmdd') + 1)  ) ;

   EXCEPTION
     WHEN referential_integrity THEN
     -- habiller le msg erreur
     --pack_global.recuperation_integrite(-2292);
     RAISE_APPLICATION_ERROR(-20997, SQLERRM);

      -- quelque soit l'erreur on renvoie un message d'erreur
      -- 'Problème lors de la mis a jour des anciens contrats'
      WHEN OTHERS THEN

    Pack_Global.recuperer_message( 20297, NULL, NULL, NULL, l_msg );
    RAISE_APPLICATION_ERROR( -20297, l_msg || ' (... ETAPE 7  ...)' );
   END;


END gestion_contrat;

PROCEDURE gestion_situ_res(p_ancsoccode IN CHAR,
               p_dfersoc    IN CHAR,
                p_nousoccode IN CHAR
              ) IS
   l_msg   VARCHAR(1024);

BEGIN
   ------------------------------------------------------------------------
   -- En cas d'erreur on renvoie l'erreur a JS qui fera un rollback
   -------------------------------------------------------------------------

   -- Creation des nouvelles situation
   -- avec une date de situation (datsitu) = p_dfersoc + 1 jour calendaire
   -- Pour Information : SITURESS_PK = IDENT, DATSITU (Code Société ne fait pas partie de la clé!)
   --
   -- IL FAUT EXCLURE DE LA CREATION LES SITUATIONS QUI SONT TELLES QUE (datsitu) > p_dfersoc
   -- De telles situations provoqueraient en effet une remise à p_dfersoc + 1 des
   -- dates de situ qui étaient auparavent supérieures à p_dfersoc + 1 !!!
   -- Pour les cas où (datsitu) > p_dfersoc, IL FAUT FAIRE SIMPLEMENT UN UPDATE du code de la société !!!
   --
   -- ATTENTION : NE PAS MODIFIER L'ORDRE DES ETAPES CI-DESSOUS !!!

   ---------------------------- (ETAPE 1) -------------------------------------------------------------

   BEGIN

      INSERT INTO SITU_RESS (datsitu   ,
                 datdep    ,
                 cpident   ,
                 cout      ,
                 dispo     ,
                 marsg2    ,
                 rmcomp    ,
                     PRESTATION,
                 dprest    ,
                     ident     ,
                     soccode   ,
                 --filcode   ,
                 codsg  ,
                 mode_contractuel_indicatif     -- BSA QC 1107 
              )
     ( SELECT (TO_DATE(p_dfersoc, 'yyyymmdd') + 1) datsitu,
       sre.datdep    ,
       sre.cpident   ,
       sre.cout      ,
       sre.dispo     ,
       sre.marsg2    ,
       sre.rmcomp    ,
       sre.PRESTATION,
       sre.dprest    ,
       sre.ident     ,
       p_nousoccode   ,
       --sre.filcode   ,
       sre.codsg ,
       sre.MODE_CONTRACTUEL_INDICATIF   -- BSA QC 1107 
       FROM SITU_RESS sre
       WHERE sre.soccode = p_ancsoccode
       AND   ( (sre.datdep IS NULL) OR (sre.datdep > TO_DATE(p_dfersoc, 'yyyymmdd')) )
     --
     -- HTM 09/02/2000
     AND  ( sre.datsitu <  (TO_DATE(p_dfersoc, 'yyyymmdd') + 1)  )
     );

   EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    -- 'Problème lors de la création des nouvelles situations : Situation en double pour une même ressource!'
    Pack_Global.recuperer_message( 20615, NULL, NULL, NULL, l_msg);
    RAISE_APPLICATION_ERROR( -20615, l_msg);

      WHEN OTHERS THEN
      -- quelque soit les autres erreurs on renvoie un message d'erreur
      -- 'Problème lors de la creation des nouvelles situations'
    Pack_Global.recuperer_message( 20314, NULL, NULL, NULL, l_msg);
    RAISE_APPLICATION_ERROR( -20314, l_msg);

    -- RAISE_APPLICATION_ERROR(-pack_utile_numsg.nuexc_others, SQLERRM);

   END;

   ---------------------------- (ETAPE 2) -------------------------------------------------------------
   -- Fermetures  des anciennes situations pour lesquelles on vient de créer de nouvelles pour la nouvelle sté
   --
   BEGIN

   UPDATE SITU_RESS
     SET  datdep = TO_DATE(p_dfersoc, 'yyyymmdd')
     WHERE soccode = p_ancsoccode
     AND   ( (datdep IS NULL) OR (datdep > TO_DATE(p_dfersoc, 'yyyymmdd')) )
     -- HTM 09/02/2000
     AND ( datsitu < (TO_DATE(p_dfersoc, 'yyyymmdd') + 1) );

   EXCEPTION
      -- quelque soit l'erreur on renvoie un message d'erreur
      -- 'Problème lors de la modification des anciennes situations'
      WHEN OTHERS THEN
    Pack_Global.recuperer_message( 20315, NULL, NULL, NULL, l_msg);
    RAISE_APPLICATION_ERROR( -20315, l_msg);

   END;


   ---------------------------- (ETAPE 3) -------------------------------------------------------------

   -- ---------------------- HTM 09/02/2000   DEBUT ------------------------------------------

   -- Transfert des anciennes situations vérifiant (datsitu) >= p_dfersoc + 1 jour calendaire
   -- vers la nouvelle société via un Update du code société
   BEGIN

   UPDATE SITU_RESS
         SET    soccode = p_nousoccode
         WHERE soccode = p_ancsoccode
         AND   ( (datdep IS NULL) OR (datdep > TO_DATE(p_dfersoc, 'yyyymmdd')) )
    AND   ( datsitu >= (TO_DATE(p_dfersoc, 'yyyymmdd') + 1) );

   EXCEPTION
      -- quelque soit l'erreur on renvoie un message d'erreur
      -- 'Problème lors de la creation des nouvelles situations'
      WHEN OTHERS THEN
    Pack_Global.recuperer_message( 20314, NULL, NULL, NULL, l_msg);
    RAISE_APPLICATION_ERROR( -20314, l_msg);

   END;

   -- ---------------------- HTM 09/02/2000   FIN ------------------------------------------


END gestion_situ_res;


PROCEDURE insert_societe ( p_soccode   IN SOCIETE.soccode%TYPE,
               p_socgrpe   IN societe.socgrpe%TYPE,
               p_soccat    IN SOCIETE.soccat%TYPE,
               p_socnat    IN SOCIETE.socnat%TYPE,
               p_soclib    IN SOCIETE.soclib%TYPE,
               p_soccre    IN VARCHAR2,
               p_userid    IN VARCHAR2,
               p_nbcurseur OUT INTEGER,
               p_message   OUT VARCHAR2
             ) IS
      -- Variables locales

      l_msg   VARCHAR(1024);
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      -- Contrôle de cohérence des données

      IF ( p_socnat IS NOT NULL AND
           p_socnat != 'RG'  AND  p_socnat != 'RS'   AND  p_socnat != 'G'   AND  p_socnat != 'S' AND  p_socnat != 'R'
    AND  p_socnat != 'E' AND  p_socnat != 'RC'   AND  p_socnat != 'RE'  AND  p_socnat != 'C'  AND  p_socnat != 'L' AND p_socnat <>' ') THEN

         -- 'Code nature erroné: RG référencé généraliste ou RS référencé spécialiste ou G généraliste
         --  ou S spécialiste ou E éditeur ou blanc'

         Pack_Global.recuperer_message( 20305, NULL, NULL, 'SOCNAT', l_msg);

         RAISE_APPLICATION_ERROR( -20305, l_msg);
      END IF;

      IF ( p_soccat IS NOT NULL AND
           p_soccat != 'SSII'   AND
           p_soccat != 'SG..'   AND
           p_soccat != 'CONS'   AND
           p_soccat != 'DIVE'     ) THEN

         -- 'Code catégorie erroné'

         Pack_Global.recuperer_message( 20309, NULL, NULL, 'SOCCAT', l_msg);
         RAISE_APPLICATION_ERROR( -20309, l_msg);
      END IF;

      BEGIN
         INSERT INTO SOCIETE ( soccode,
                               socgrpe,
                               soccat,
                               socnat,
                               soclib,
                               soccre)
         VALUES ( p_soccode,
                  p_socgrpe,
                  p_soccat,
                  p_socnat,
                  p_soclib,
                  TO_DATE( p_soccre, 'DD/MM/YYYY')
                );

         -- 'La société ' || p_soclib || ' a été créé.';

         Pack_Global.recuperer_message( 3001, '%s1', p_soclib, NULL, l_msg);
         p_message := l_msg;

         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN

               -- 'Code société déjà créé.'

               Pack_Global.recuperer_message( 20301, NULL, NULL,
                                              NULL, l_msg);

               RAISE_APPLICATION_ERROR( -20301, l_msg);

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;

   END insert_societe;

   PROCEDURE update_societe ( p_soccode       IN SOCIETE.soccode%TYPE,
                              p_socgrpe   IN societe.socgrpe%TYPE,
                              p_soclib        IN SOCIETE.soclib%TYPE,
                              p_socnat        IN SOCIETE.socnat%TYPE,
                              p_soccat        IN SOCIETE.soccat%TYPE,
                              p_soccre        IN VARCHAR2,
                              p_socfer_ch     IN VARCHAR2,
                              p_socnou        IN SOCIETE.socnou%TYPE,
                              p_soccop        IN SOCIETE.soccop%TYPE,
                              p_socfer_cl     IN VARCHAR2,
                              p_soccom        IN SOCIETE.soccom%TYPE,
                              p_flaglock      IN NUMBER,
                              p_userid        IN VARCHAR2,
                              p_siren          IN VARCHAR2,
                              p_nbcurseur     OUT INTEGER,
                              p_message       OUT VARCHAR2
                            ) IS

      -- Variables locales



      l_msg   VARCHAR(1024);
      l_soccode   SOCIETE.soccode%TYPE;
      l_date_fermeture VARCHAR2(10);
      l_date_fermeture_ch VARCHAR2(10);
      l_date_fermeture_cl VARCHAR2(10);
      l_jour VARCHAR2(2);

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

        -------------------------------------------------------------------------------
      -- Dates de fermetures
        -------------------------------------------------------------------------------

      IF (p_socfer_ch IS NOT NULL) THEN
          l_date_fermeture := TO_CHAR(TO_DATE(p_socfer_ch,'mm/yyyy'),'yyyymm')||'01';
          l_date_fermeture_ch := TO_CHAR(ADD_MONTHS(TO_DATE(l_date_fermeture,'yyyymmdd'),1)-1,'yyyymmdd');
      END IF;

      IF (p_socfer_cl IS NOT NULL) THEN
      l_date_fermeture := TO_CHAR(TO_DATE(p_socfer_cl,'mm/yyyy'),'yyyymm')||'01';
          l_date_fermeture_cl := TO_CHAR(ADD_MONTHS(TO_DATE(l_date_fermeture,'yyyymmdd'),1)-1,'yyyymmdd');
       --   DBMS_OUTPUT.PUT_LINE(l_date_fermeture_cl);
      END IF;


    --------------------------------------------------------------------------------

      -- Contrôle de cohérence de la saisie

    --------------------------------------------------------------------------------


      -- 'Nature Société
      IF ( p_socnat IS NOT NULL AND
           (p_socnat <> 'RG' AND p_socnat <> 'RS' AND p_socnat <> 'G' AND p_socnat <> 'S' AND p_socnat <> 'E' AND p_socnat <> 'R' AND
            p_socnat <> 'RC' AND p_socnat <> 'RE' AND p_socnat <> 'C' AND p_socnat <> 'L')  AND p_socnat <>' '  ) THEN

         -- 'Code nature erroné
         Pack_Global.recuperer_message( 20305, NULL, NULL, 'SOCNAT', l_msg);
         RAISE_APPLICATION_ERROR( -20305, l_msg );
      END IF;



      IF ( p_soccat IS NOT NULL AND
           p_soccat != 'SSII'   AND
           p_soccat != 'SG..'   AND
           p_soccat != 'CONS'   AND
           p_soccat != 'DIVE'     ) THEN

       -- 'Code catégorie erroné'

         Pack_Global.recuperer_message( 20309, NULL, NULL, 'SOCCAT', l_msg);
         RAISE_APPLICATION_ERROR( -20309, l_msg);
      END IF;



      -- La nouvelle société doit exister
      IF p_socnou IS NOT NULL THEN
         BEGIN
            SELECT soccode
            INTO   l_soccode
            FROM   SOCIETE
            WHERE  SOCCODE = p_socnou;

       EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- 'Code société inexistant'

               Pack_Global.recuperer_message( 20306, NULL, NULL,
                                              'SOCNOU', l_msg);
               RAISE_APPLICATION_ERROR( -20306, l_msg );

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
       END;

    END IF;



      -- Si les deux dates de fermetures sont renseignées -> Erreur
      IF p_socfer_ch IS NOT NULL AND
         p_socfer_cl  IS NOT NULL   THEN

         -- 'Renseigner la date de chment seule ou la date de
         --  fermeture provisoire seule'

         Pack_Global.recuperer_message( 20302, NULL, NULL,
                                        'SOCFER_CH', l_msg);
         RAISE_APPLICATION_ERROR( -20302, l_msg );
      END IF;



      -- Si la date fermeture provisoire < date du jour -> Erreur
      IF ( p_socfer_cl IS NOT NULL)
         AND
         (l_date_fermeture_cl <
           TO_CHAR( SYSDATE, 'YYYYMMDD'))  THEN

         -- 'Date de fermeture provisoire inférieure à date du jour'

         Pack_Global.recuperer_message( 20303, NULL, NULL,
                                        'SOCFER_CL', l_msg);
         RAISE_APPLICATION_ERROR( -20303, l_msg );

      END IF;



      -- Si date fermeture saisie et pas nouvelle société ou
      -- l'inverse -> Erreur
      IF ( p_socfer_ch IS NOT NULL AND
           p_socnou IS NULL              )
         OR
         ( p_socfer_ch IS NULL     AND
           p_socnou IS NOT NULL          ) THEN

         -- 'Saisir date fermeture et nouvelle société ou aucun des deux'

         Pack_Global.recuperer_message( 20304, NULL, NULL,
                                        'SOCFER_CH', l_msg);
         RAISE_APPLICATION_ERROR( -20304, l_msg );
      END IF;



    -----------------------------------------------------------------------------

      -- Cas d'un chment de nom de societe.

    -----------------------------------------------------------------------------

      IF (p_socfer_ch IS NOT NULL) AND (p_socnou IS NOT NULL) THEN

     -- gestion des contrats

     gestion_contrat(p_soccode,
             l_date_fermeture_ch,
             p_socnou,
             p_siren
             );



     -- gestion des situations ressource

     gestion_situ_res(p_soccode,
              l_date_fermeture_ch,
              p_socnou
              );

      END IF;

      BEGIN
         UPDATE SOCIETE
         SET soclib  = p_soclib,
             socgrpe = p_socgrpe,
             socnat  = p_socnat,
             soccat  = p_soccat,
             socfer  = DECODE(p_socnou,NULL,TO_DATE(l_date_fermeture_cl,'yyyymmdd'),
                                 TO_DATE(l_date_fermeture_ch,'yyyymmdd')),
             socnou  = p_socnou,
             soccom  = p_soccom,
             soccop  = p_soccop,
             flaglock = DECODE( p_flaglock, 1000000, 0, p_flaglock + 1),
             sirennou = TO_NUMBER(p_siren)
         WHERE soccode = p_soccode
         AND   flaglock = p_flaglock;
     EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;


      IF SQL%NOTFOUND THEN
         -- 'Accès concurrent'
         Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );
      ELSE
         -- 'La société p_soclib a été modifiée'
         Pack_Global.recuperer_message( 3002, '%s1', p_soclib, NULL, l_msg);
         p_message := l_msg;
      END IF;



      -- Si fermeture avec chment de nom de société, il faut
      -- fermer les contrats de l'ancienne et les recréer pour la
      -- nouvelle. Idem pour les situations ressources
   END update_societe;



   PROCEDURE delete_societe ( p_soccode   IN SOCIETE.soccode%TYPE,
                              p_flaglock  IN NUMBER,
                              p_userid    IN VARCHAR2,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                            ) IS
      l_msg   VARCHAR(1024);
      referential_integrity   EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         DELETE FROM SOCIETE
         WHERE soccode = p_soccode
          AND  flaglock = p_flaglock;

      EXCEPTION
         WHEN referential_integrity THEN
            -- habiller le msg erreur
            Pack_Global.recuperation_integrite(-2292);

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN

         -- 'Accès concurrent'

         Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);

         RAISE_APPLICATION_ERROR( -20999, l_msg );
      ELSE
         -- message 'La société %s1 a été supprimée.'
         Pack_Global.recuperer_message( 3003, '%s1', p_soccode, NULL, l_msg);
         p_message := l_msg;
      END IF;

   END delete_societe;

   PROCEDURE select_societe ( p_soccode    IN SOCIETE.soccode%TYPE,
                              p_userid     IN VARCHAR2,
                              p_curSociete IN OUT societeCurType_Char,
                              p_datcre     OUT VARCHAR2,
                              p_nbcurseur  OUT INTEGER,
                              p_message    OUT VARCHAR2
                            ) IS

      l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      OPEN p_curSociete FOR
         SELECT soccode,
                socgrpe,
                soclib,
                socnat,
                soccat,
                TO_CHAR( soccre, 'DD/MM/YYYY'),
                DECODE( socnou, NULL,
                        NULL, TO_CHAR( socfer, 'MM/YYYY')),
                socnou,
                soccop,
                DECODE( socnou, NULL,
                        TO_CHAR( socfer, 'MM/YYYY'), NULL),
                soccom,
                flaglock,
                TO_CHAR(sirennou)
         FROM   SOCIETE
         WHERE  soccode = p_soccode;


      -- Gestion des paramètres OUT

      BEGIN
        SELECT TO_CHAR( soccre, 'DD/MM/YYYY')
        INTO   p_datcre
        FROM   SOCIETE
        WHERE  soccode = p_soccode;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           SELECT TO_CHAR( SYSDATE, 'DD/MM/YYYY')
           INTO   p_datcre
           FROM   DUAL;
      END;

      -- en cas absence
      -- p_message := 'Code Société inexistant.';
      -- Ce message est utilisé comme message APPLICATIF et
      -- message d'exception. => Il porte un numéro d'EXCEPTION
      Pack_Global.recuperer_message( 20306, NULL, NULL, NULL, l_msg);
      p_message := l_msg;

   END select_societe;


PROCEDURE RECUP_LIB_SOCCODE(p_soccode        IN    SOCIETE.SOCCODE%TYPE,
                               p_lib_soccode    OUT    VARCHAR2,
                               p_message        OUT     VARCHAR2)
            IS
msg         VARCHAR(1024);
BEGIN
    SELECT TO_CHAR(SOCFLIB) INTO p_lib_soccode
    FROM AGENCE
    WHERE SOCCODE=p_soccode
    AND ROWNUM=1;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
            return;
            --Pack_Global.recuperer_message( 4000, '%s1', p_soccode, NULL, p_message);
    WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR( -20997, SQLERRM);


END RECUP_LIB_SOCCODE;

PROCEDURE RECUP_LIB_SIREN(p_soccode        IN    SOCIETE.SOCCODE%TYPE,
                               p_lib_siren    OUT    VARCHAR2,
                               p_lib_soccode    OUT    VARCHAR2,
                               p_message        OUT     VARCHAR2)
            IS
msg         VARCHAR(1024);
BEGIN
    SELECT TO_CHAR(SIREN), TO_CHAR(SOCFLIB) INTO p_lib_siren, p_lib_soccode
    FROM AGENCE
    WHERE SOCCODE=p_soccode
    AND ROWNUM=1;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
            Pack_Global.recuperer_message( 4000, '%s1', p_soccode, NULL, p_message);
    WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR( -20997, SQLERRM);


END RECUP_LIB_SIREN;

-- Liste les sirens de la table agence pour un code société donné
PROCEDURE LISTER_SIREN_AGENCE ( p_code       IN VARCHAR2,
                                p_curSiren   IN OUT Pack_Liste_Dynamique.liste_dyn
                              ) IS
BEGIN

     OPEN p_curSiren FOR
      SELECT 0 id,
          'A renseigner' libelle

        FROM DUAL
        UNION
           SELECT DISTINCT SIREN id,to_char(SIREN) libelle
          FROM  agence a
          WHERE  trim(SOCCODE)  =  trim(p_code)
             AND SIREN IS NOT NULL
          ORDER BY id ASC;

END LISTER_SIREN_AGENCE;

END Pack_Societe;
/



