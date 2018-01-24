-- pack_RefPCM PL/SQL
-- equipe SOPRA
-- crée le 27/10/1999
-- Package qui sert à la réalisation des reports du lot (refpcm) Reftrans, proref4
-- -------------------------------------------------------------------------
-- Quand      Qui Quoi
-- --------   --- ----------------------------------------------------
-- 09/02/2001 PHD Correction liée à la nouvelle FI (cout de FI par DPG)
-- 11/09/2003 NBM ajout du code métier (fiche 54)
-- 02/12/2003 NBM Select_DataProref4:pb au niveau du curseur(clause where)
-- 10/12/2003 NBM modif calcul du champ facint qui devient "Euros année n"
-- 23/02/2005 PJO MAJ pour intégrer les habilitations par référentiels
-- 30/08/2008 BPO MAJ pour elargir l'extraction ua ligne de type 9 (Fiche TD 585)
-- 30/07/2008 ABA TD 539 remplacement de datedebx par moismens dans select_datareftrans
-- 22/02/2010 ABA : TD 938
-- -------------------------------------------------------------------

CREATE OR REPLACE PACKAGE     pack_RefPCM IS
-- =========================================================================
-- FUNCTION f_facint
-- Role : calcule le cout Standar Total d'un projet(ligne_bip) en KF
-- Parametre : - p_pid   Identifiant de projet informatique

-- -------------------------------------------------------------------------
-- FUNCTION Select_DataReftrans
-- Role : Recheche les donnees de l'édition Reftrans en ouvrant un cursor
--        puis les insere dans la table temporaire tmpreftrans.
-- Retour : Retourne le numéro de sequence qui sera utilisé dans select et
--        les trigers du report
-- Parametre : P_codPADP peut prendre une valeure d'un Code Porjet ou d'un
--        Code Appli ou d'un code Dossier Projet.

-- -------------------------------------------------------------------------
-- FUNCTION Select_DataProref4
-- Role : identique à la foncition Select_DataReftrans mais pour l'édition
-- Proref4
-- -------------------------------------------------------------------------

-- FUNCTION Delete_Donnees
-- Role : Supprime, dans la table Tmpreftrans, les données creees par les
-- fonctions Select_DataReftrans et Select_DataProref4, a la fin de l'édition.

-- -------------------------------------------------------------------------

   FUNCTION f_facint (p_pid IN VARCHAR2) RETURN NUMBER;
   PRAGMA RESTRICT_REFERENCES(f_facint,WNDS,WNPS);

   FUNCTION Select_DataReftrans(P_param6 IN VARCHAR2,P_param7 IN VARCHAR2,
                          P_param8 IN VARCHAR2,   -- Code Projet ou Code Appli ou code Dossier Projet
                p_global  IN VARCHAR2) RETURN NUMBER;
                
   FUNCTION Select_DataProref4 (P_codDossProj IN CHAR) RETURN NUMBER;
   FUNCTION Delete_Donnees (P_numseq IN NUMBER) RETURN BOOLEAN;

END pack_RefPCM;
/


CREATE OR REPLACE PACKAGE BODY     pack_RefPCM IS
-- ===========================================
-- -------------------------------------------------------------------------
-- FUNCTION f_facint
--
-- En commentaire car faux et inutile
-- -------------------------------------------------------------------------
FUNCTION f_facint (p_pid IN VARCHAR2) RETURN NUMBER IS
      l_facint number(12,2);
BEGIN

    SELECT NVL(cc.ftsg,0) +NVL(cc.ftssii,0)+ NVL(cc.envsg,0)+ NVL(cc.envssii,0)
     INTO l_facint
    FROM cumul_conso cc,
    datdebex d
    WHERE cc.pid=p_pid
      AND cc.annee = to_number(to_char(d.datdebex,'YYYY'));

   RETURN round(l_facint/1000, 2); -- arrondi en Montant en KE

END f_facint;

-- -------------------------------------------------------------------------
-- FUNCTION Select_DataReftrans
-- -------------------------------------------------------------------------
  FUNCTION Select_DataReftrans(P_param6 IN VARCHAR2,P_param7 IN VARCHAR2,
                          P_param8 IN VARCHAR2,   -- Code Projet ou Code Appli ou code Dossier Projet
                p_global  IN VARCHAR2 ) RETURN NUMBER IS

   l_annee0  NUMBER(4);
   l_msg  VARCHAR2(1024);


   l_numseq         NUMBER ; -- numéro de séquence identifiant l'edition en cours

   -- déclaration du cursor pour rammener les projets informatiques
   -- Les trois cursors se distingue par les lignes marquées : -- ##
   -- -------------------------------------------------------------

cursor c_curProjet (cp_anneeN Number, P_param6 VARCHAR2) IS
select pri.icpi                    CODGROUP,
       pri.ilibel                              NOMGROUP,
       decode(pri.icpi,P_param6,0,1)         FILS,
       si.coddeppole                CODEDP,
       si.sigdep || '/' || si.sigpole as       SIGDP,
       lb.pid                          PID,
       lb.typproj                      PTYPE,
       lb.arctype                ARCTYPE,
       lb.codcamo                      CODCAMO,
       lb.pnom                        LIBPROJET,
       substr(r.rnom,1,8)                CHEFPROJET,
       lb.clicode                CODMO      ,
       cm.clisigle                SIGDIRMO,
       lb.codsg                    CODSG,
       si.libdsg                LIBDSG,
       nvl(nvl(conso.cusag,0) + nvl(conso_1.cusag,0) + nvl(conso_2.xcusag,0) ,0) CUMULJH,
       nvl(conso.cusag, 0)                      CONSOJH,
       f_facint(lb.pid)                 FACINT,
       nvl(floor(budg.reestime), 0)             REESTJH,
       nvl(budg.bpmontme, 0)                       PROPOJH,
       nvl(budg.bpmontmo,0)                        PROPOMOJH,
       nvl(budg.bnmont, 0)                      NOTIFJH,
       nvl(budg.anmont, 0)                      ARBITJH,
       nvl(budg1.bpmontme, 0)                      PROPOJHN1,
       nvl(budg1.bpmontmo,0)                       PROPOMOJHN1,
       lb.metier                 METIER
from
      ressource           r          ,
      budget         budg       ,
      budget         budg1      ,
      consomme         conso      ,
      consomme         conso_1    ,
      consomme         conso_2    ,
      struct_info         si         ,
      ligne_bip     lb         ,
      client_mo        cm    ,
      proj_info     pri
where   lb.icpi = pri.icpi   -- ###
        and lb.pcpi    = r.ident
        and lb.codsg   = si.codsg
        and lb.clicode = cm.clicode
        and lb.typproj in (1,2,3,4,6,8,9) -- BPO : Ajout ligne de type 9 (TD 585)
        and ((pri.icpi LIKE DECODE(P_param6, 'P', '%', P_param6)) OR (pri.icpir LIKE DECODE(P_param6, 'P', '%', P_param6)))    -- ###
        and lb.pid = budg.pid    (+)
    and lb.pid = budg1.pid   (+)
    and lb.pid = conso.pid   (+)
    and lb.pid = conso_1.pid (+)
    and lb.pid = conso_2.pid (+)
   -- Au moins une des donnees n°14 a 21, ou b.xcusag0 ou b.xcusagM1 est different de zero
       and (      (conso.cusag      <> 0 AND   conso.cusag     is not null )
            OR (conso_1.cusag    <> 0 AND   conso_1.cusag   is not null )
          OR (conso_2.xcusag   <> 0 AND   conso_2.xcusag  is not null )
            OR (f_facint(lb.pid) <> 0 )
            OR (budg.reestime    <> 0 AND  budg.reestime    is not null )
            OR (budg.bpmontme    <> 0 AND  budg.bpmontme    is not null )
        OR (budg.bpmontmo    <> 0 AND  budg.bpmontmo    is not null )
            OR (budg.bnmont      <> 0 AND  budg.bnmont      is not null )
            OR (budg.anmont      <> 0 AND budg.anmont       is not null )
            OR (budg1.bpmontme   <> 0 AND budg1.bpmontme    is not null )
        OR (budg1.bpmontmo   <> 0 AND budg1.bpmontmo    is not null )
        )
    and budg.annee(+)    = cp_anneeN
    and conso.annee(+)   = cp_anneeN
    and conso_1.annee(+) = cp_anneeN-1
    and conso_2.annee(+) = cp_anneeN-2
    and budg1.annee(+)   = cp_anneeN+1;

-- Déclaration du cursor pour rammener les Applications
-- -------------------------------------------------------------

cursor c_curAppli (cp_anneeN Number, P_param7 VARCHAR2) IS
select  app.airt                                 CODGROUP  ,
    app.alibel                               NOMGROUP  ,
           decode(app.airt,P_param7,0,1)         FILS      ,
           si.coddeppole                CODEDP      ,
           si.sigdep || '/' || si.sigpole as       SIGDP      ,
           lb.pid                          PID      ,
           lb.typproj                      PTYPE      ,
        lb.arctype                ARCTYPE      ,
           lb.codcamo                      CODCAMO      ,
    lb.pnom                        LIBPROJET ,
           substr(r.rnom,1,15)                CHEFPROJET,
        lb.clicode                CODMO      ,
        cm.clisigle                SIGDIRMO  ,
        lb.codsg                CODSG      ,
        si.libdsg                LIBDSG      ,
           nvl(nvl(conso.cusag,0) + nvl(conso_1.cusag,0) + nvl(conso_2.xcusag,0) ,0) CUMULJH,
           nvl(conso.cusag, 0)                     CONSOJH   ,
    f_facint(lb.pid)            FACINT      ,
           nvl(floor(budg.reestime), 0)            REESTJH      ,
           nvl(budg.bpmontme, 0)                   PROPOJH      ,
           nvl(budg.bpmontmo,0)                    PROPOMOJH ,
           nvl(budg.bnmont, 0)                     NOTIFJH      ,
           nvl(budg.anmont, 0)                     ARBITJH      ,
           nvl(budg1.bpmontme, 0)                  PROPOJHN1 ,
           nvl(budg1.bpmontmo,0)                   PROPOMOJHN1,
           lb.metier                 METIER
from
      ressource           r      ,
      budget         budg   ,
      budget         budg1  ,
      consomme         conso  ,
      consomme         conso_1,
      consomme         conso_2,
      struct_info         si     ,
      client_mo        cm     ,
      ligne_bip     lb     ,
      application app
where   lb.airt    = app.airt  -- ###
       and lb.pcpi    = r.ident
       and lb.codsg   = si.codsg
       and lb.clicode = cm.clicode
       and (app.airt LIKE DECODE(P_param7, 'A', '%', P_param7) OR app.acdareg LIKE DECODE(P_param7, 'A', '%', P_param7))    -- ###
       AND typproj in (1,2,3,4,6,8,9) -- BPO : Ajout ligne de type 9 (Fiche TD 585)
    and lb.pid = budg.pid     (+)
    and lb.pid = budg1.pid   (+)
    and lb.pid = conso.pid  (+)
    and lb.pid = conso_1.pid (+)
    and lb.pid = conso_2.pid(+)
       -- Au moins une des donnees n°14 a 21, ou b.xcusag0 ou b.xcusagM1 est different de zero
       and (      (conso.cusag      <> 0 AND conso.cusag    is not null)
            OR (conso_1.cusag    <> 0 AND conso_1.cusag  is not null)
          OR (conso_2.xcusag   <> 0 AND conso_2.xcusag is not null)
            OR (f_facint(lb.pid) <> 0)
            OR (budg.reestime    <> 0 AND budg.reestime  is not null)
            OR (budg.bpmontme    <> 0 AND budg.bpmontme  is not null)
        OR (budg.bpmontmo    <> 0 AND budg.bpmontmo  is not null)
            OR (budg.bnmont      <> 0 AND budg.bnmont    is not null)
            OR (budg.anmont      <> 0 AND budg.anmont    is not null)
            OR (budg1.bpmontme   <> 0 AND budg1.bpmontme is not null)
        OR (budg1.bpmontmo   <> 0 AND budg1.bpmontmo is not null)
        )
    and budg.annee(+)    = cp_anneeN
    and conso.annee(+)   = cp_anneeN
    and conso_1.annee(+) = cp_anneeN-1
    and conso_2.annee(+) = cp_anneeN-2
    and budg1.annee(+)   = cp_anneeN+1;


-- déclaration du cursor pour rammener les Dossiers Projets
-- -------------------------------------------------------------
cursor c_curDossProj (cp_anneeN Number, P_param8 VARCHAR2) IS
select     TO_CHAR(dp.dpcode, 'FM00000')              CODGROUP,
    dp.dplib                                NOMGROUP,
           0                                        FILS,
           si.coddeppole                    CODEDP,
           si.sigdep || '/' || si.sigpole as       SIGDP,
           lb.pid                          PID,
           lb.typproj                      PTYPE,
        lb.arctype                ARCTYPE,
           lb.codcamo                      CODCAMO,
    lb.pnom                        LIBPROJET,
           substr(r.rnom,1,15)               CHEFPROJET,
        lb.clicode                CODMO      ,
        cm.clisigle                SIGDIRMO,
        lb.codsg                CODSG,
        si.libdsg                LIBDSG,
           nvl(nvl(conso.cusag,0) + nvl(conso_1.cusag,0) + nvl(conso_2.xcusag,0) ,0) CUMULJH,
           nvl(conso.cusag, 0)                     CONSOJH,
           f_facint(lb.pid)               FACINT,
           nvl(floor(budg.reestime), 0)            REESTJH,
           nvl(budg.bpmontme, 0)                   PROPOJH,
           nvl(budg.bpmontmo,0)                    PROPOMOJH,
           nvl(budg.bnmont, 0)                     NOTIFJH,
           nvl(budg.anmont, 0)                     ARBITJH,
           nvl(budg1.bpmontme, 0)                  PROPOJHN1,
           nvl(budg1.bpmontmo,0)                  PROPOMOJHN1,
           lb.metier                 METIER
from
      ressource           r      ,
      budget         budg   ,
      budget         budg1  ,
      consomme         conso  ,
      consomme          conso_1,
      consomme         conso_2,
      client_mo           cm     ,
      struct_info         si     ,
      ligne_bip     lb     ,
      dossier_projet     dp
where      lb.dpcode    = dp.dpcode  -- ###
       and lb.clicode = cm.clicode
       and lb.pcpi    = r.ident
       and lb.codsg   = si.codsg
       and lb.typproj in (1,2,3,4,6,8,9) -- BPO : Ajout ligne de type 9 (TD 585)
       and TO_CHAR(dp.dpcode, 'FM00000') LIKE DECODE(P_param8, 'DP', '%', LPAD(P_param8, 5, '0'))  -- ###
       and lb.pid = budg.pid     (+)
    and lb.pid = budg1.pid   (+)
    and lb.pid = conso.pid  (+)
    and lb.pid = conso_1.pid (+)
       and lb.pid = conso_2.pid    (+)
       -- Au moins une des donnees n°14 a 21, ou b.xcusag0 ou b.xcusagM1 est different de zero
       and (      (conso.cusag     <> 0 AND conso.cusag    is not null )
            OR (conso_1.cusag   <> 0 AND conso_1.cusag  is not null )
          OR (conso_2.xcusag  <> 0 AND conso_2.xcusag is not null )
            OR (f_facint(lb.pid)<> 0 )
            OR (budg.reestime   <> 0 AND budg.reestime  is not null )
            OR (budg.bpmontme   <> 0 AND budg.bpmontme  is not null )
            OR (budg.bpmontmo   <> 0 AND budg.bpmontmo  is not null )
            OR (budg.bnmont     <> 0 AND budg.bnmont    is not null )
            OR (budg.anmont     <> 0 AND budg.anmont    is not null )
            OR (budg1.bpmontme  <> 0 AND budg1.bpmontme is not null )
        OR (budg1.bpmontmo  <> 0 AND budg1.bpmontmo is not null )
        )
    and budg.annee(+)  =  cp_anneeN
    and conso.annee(+)  =  cp_anneeN
    and conso_1.annee(+) =  cp_anneeN-1
    and conso_2.annee(+) = cp_anneeN-2
    and budg1.annee(+) =  cp_anneeN+1;

BEGIN
      -- p_msg := '';
      SELECT TO_NUMBER( TO_CHAR( moismens, 'YYYY') )
    INTO l_annee0
    FROM datdebex;

      SELECT Seqreftrans.nextval INTO l_numseq FROM dual;
      
      IF ((P_param6 <> null or P_param6 != ' ') ) THEN
         FOR enr_cur IN c_curProjet(l_annee0, P_param6)
         LOOP
          INSERT INTO Tmpreftrans
             (numseq,CODGROUP,NOMGROUP,FILS, CODEDP, SIGDP, PID, PTYPE, ARCTYPE, CODCAMO, LIBPROJET, CHEFPROJET, CODMO, SIGDIRMO, CODSG, LIBDSG,
              CUMULJH, CONSOJH, FACINT, REESTJH, PROPOJH, NOTIFJH, RESERJH, ARBITJH, PROPOJHN1,PROPOMOJH,PROPOMOJHN1,METIER)
          VALUES
               (l_numseq,enr_cur.CODGROUP,enr_cur.NOMGROUP,enr_cur.FILS, enr_cur.CODEDP, enr_cur.SIGDP, enr_cur.PID, enr_cur.PTYPE, enr_cur.ARCTYPE,
                enr_cur.CODCAMO, enr_cur.LIBPROJET, enr_cur.CHEFPROJET, enr_cur.CODMO, enr_cur.SIGDIRMO, enr_cur.CODSG, enr_cur.LIBDSG,
                enr_cur.CUMULJH, enr_cur.CONSOJH, enr_cur.FACINT, enr_cur.REESTJH, enr_cur.PROPOJH,
                enr_cur.NOTIFJH, NULL, enr_cur.ARBITJH, enr_cur.PROPOJHN1,enr_cur.PROPOMOJH,enr_cur.PROPOMOJHN1,enr_cur.METIER)  ;
         END LOOP;
        
      ELSIF ((P_param7 <> null or P_param7 != ' ') ) THEN
         FOR enr_cur IN c_curAppli (l_annee0, P_param7)
         LOOP
            INSERT INTO Tmpreftrans
             (numseq,CODGROUP,NOMGROUP,FILS, CODEDP, SIGDP, PID, PTYPE, ARCTYPE, CODCAMO, LIBPROJET, CHEFPROJET, CODMO, SIGDIRMO, CODSG, LIBDSG,
              CUMULJH, CONSOJH, FACINT, REESTJH, PROPOJH, NOTIFJH, RESERJH, ARBITJH, PROPOJHN1,PROPOMOJH,PROPOMOJHN1,METIER)
          VALUES
               (l_numseq,enr_cur.CODGROUP,enr_cur.NOMGROUP,enr_cur.FILS, enr_cur.CODEDP, enr_cur.SIGDP, enr_cur.PID, enr_cur.PTYPE, enr_cur.ARCTYPE,
                enr_cur.CODCAMO, enr_cur.LIBPROJET, enr_cur.CHEFPROJET, enr_cur.CODMO, enr_cur.SIGDIRMO, enr_cur.CODSG, enr_cur.LIBDSG,
                enr_cur.CUMULJH, enr_cur.CONSOJH, enr_cur.FACINT, enr_cur.REESTJH, enr_cur.PROPOJH,
                enr_cur.NOTIFJH, NULL, enr_cur.ARBITJH, enr_cur.PROPOJHN1,enr_cur.PROPOMOJH,enr_cur.PROPOMOJHN1,enr_cur.METIER);
         END LOOP;
      ELSIF ((P_param8 <> null or P_param8 != ' ') ) THEN
        FOR enr_cur IN c_curDossProj (l_annee0, P_param8)
         LOOP
            INSERT INTO Tmpreftrans
             (numseq, CODGROUP,NOMGROUP,FILS ,CODEDP, SIGDP, PID, PTYPE, ARCTYPE, CODCAMO, LIBPROJET, CHEFPROJET, CODMO, SIGDIRMO, CODSG, LIBDSG,
              CUMULJH, CONSOJH, FACINT, REESTJH, PROPOJH, NOTIFJH, RESERJH, ARBITJH, PROPOJHN1,PROPOMOJH,PROPOMOJHN1,METIER)
          VALUES
               (l_numseq,enr_cur.CODGROUP,enr_cur.NOMGROUP,enr_cur.FILS, enr_cur.CODEDP, enr_cur.SIGDP, enr_cur.PID, enr_cur.PTYPE, enr_cur.ARCTYPE,
                enr_cur.CODCAMO, enr_cur.LIBPROJET, enr_cur.CHEFPROJET, enr_cur.CODMO, enr_cur.SIGDIRMO, enr_cur.CODSG, enr_cur.LIBDSG,
                enr_cur.CUMULJH, enr_cur.CONSOJH, enr_cur.FACINT, enr_cur.REESTJH, enr_cur.PROPOJH,
                enr_cur.NOTIFJH, NULL, enr_cur.ARBITJH, enr_cur.PROPOJHN1,enr_cur.PROPOMOJH,enr_cur.PROPOMOJHN1,enr_cur.METIER);
         END LOOP;
      END IF;
      
  
      /*
   IF SUBSTR(P_codPADP,1,1)='P' OR SUBSTR(P_codPADP,1,1)='I' THEN -- Si un code Projet

         FOR enr_cur IN c_curProjet(l_annee0, P_codPADP)
         LOOP
            INSERT INTO Tmpreftrans
             (numseq,CODGROUP,NOMGROUP,FILS, CODEDP, SIGDP, PID, PTYPE, ARCTYPE, CODCAMO, LIBPROJET, CHEFPROJET, CODMO, SIGDIRMO, CODSG, LIBDSG,
              CUMULJH, CONSOJH, FACINT, REESTJH, PROPOJH, NOTIFJH, RESERJH, ARBITJH, PROPOJHN1,PROPOMOJH,PROPOMOJHN1,METIER)
          VALUES
               (l_numseq,enr_cur.CODGROUP,enr_cur.NOMGROUP,enr_cur.FILS, enr_cur.CODEDP, enr_cur.SIGDP, enr_cur.PID, enr_cur.PTYPE, enr_cur.ARCTYPE,
                enr_cur.CODCAMO, enr_cur.LIBPROJET, enr_cur.CHEFPROJET, enr_cur.CODMO, enr_cur.SIGDIRMO, enr_cur.CODSG, enr_cur.LIBDSG,
                enr_cur.CUMULJH, enr_cur.CONSOJH, enr_cur.FACINT, enr_cur.REESTJH, enr_cur.PROPOJH,
                enr_cur.NOTIFJH, NULL, enr_cur.ARBITJH, enr_cur.PROPOJHN1,enr_cur.PROPOMOJH,enr_cur.PROPOMOJHN1,enr_cur.METIER)  ;
         END LOOP;

      ELSIF SUBSTR(P_codPADP,1,1)='A' THEN -- si un code Application

         FOR enr_cur IN c_curAppli (l_annee0, P_codPADP)
         LOOP
            INSERT INTO Tmpreftrans
             (numseq,CODGROUP,NOMGROUP,FILS, CODEDP, SIGDP, PID, PTYPE, ARCTYPE, CODCAMO, LIBPROJET, CHEFPROJET, CODMO, SIGDIRMO, CODSG, LIBDSG,
              CUMULJH, CONSOJH, FACINT, REESTJH, PROPOJH, NOTIFJH, RESERJH, ARBITJH, PROPOJHN1,PROPOMOJH,PROPOMOJHN1,METIER)
          VALUES
               (l_numseq,enr_cur.CODGROUP,enr_cur.NOMGROUP,enr_cur.FILS, enr_cur.CODEDP, enr_cur.SIGDP, enr_cur.PID, enr_cur.PTYPE, enr_cur.ARCTYPE,
                enr_cur.CODCAMO, enr_cur.LIBPROJET, enr_cur.CHEFPROJET, enr_cur.CODMO, enr_cur.SIGDIRMO, enr_cur.CODSG, enr_cur.LIBDSG,
                enr_cur.CUMULJH, enr_cur.CONSOJH, enr_cur.FACINT, enr_cur.REESTJH, enr_cur.PROPOJH,
                enr_cur.NOTIFJH, NULL, enr_cur.ARBITJH, enr_cur.PROPOJHN1,enr_cur.PROPOMOJH,enr_cur.PROPOMOJHN1,enr_cur.METIER);
         END LOOP;
      ELSE

         FOR enr_cur IN c_curDossProj (l_annee0, P_codPADP)
         LOOP
            INSERT INTO Tmpreftrans
             (numseq, CODGROUP,NOMGROUP,FILS ,CODEDP, SIGDP, PID, PTYPE, ARCTYPE, CODCAMO, LIBPROJET, CHEFPROJET, CODMO, SIGDIRMO, CODSG, LIBDSG,
              CUMULJH, CONSOJH, FACINT, REESTJH, PROPOJH, NOTIFJH, RESERJH, ARBITJH, PROPOJHN1,PROPOMOJH,PROPOMOJHN1,METIER)
          VALUES
               (l_numseq,enr_cur.CODGROUP,enr_cur.NOMGROUP,enr_cur.FILS, enr_cur.CODEDP, enr_cur.SIGDP, enr_cur.PID, enr_cur.PTYPE, enr_cur.ARCTYPE,
                enr_cur.CODCAMO, enr_cur.LIBPROJET, enr_cur.CHEFPROJET, enr_cur.CODMO, enr_cur.SIGDIRMO, enr_cur.CODSG, enr_cur.LIBDSG,
                enr_cur.CUMULJH, enr_cur.CONSOJH, enr_cur.FACINT, enr_cur.REESTJH, enr_cur.PROPOJH,
                enr_cur.NOTIFJH, NULL, enr_cur.ARBITJH, enr_cur.PROPOJHN1,enr_cur.PROPOMOJH,enr_cur.PROPOMOJHN1,enr_cur.METIER);
         END LOOP;

      END IF;
*/
      -----------------
      -- COMMIT
      -----------------
      COMMIT;

      RETURN l_numseq;

EXCEPTION
    WHEN OTHERS THEN
    RETURN 0; -- code d'erreur
END Select_DataReftrans;




-- -------------------------------------------------------------------------
-- FUNCTION Select_DataProref4
-- Role : identique à la foncition Select_DataReftrans mais pour l'édition
-- Proref4
-- -------------------------------------------------------------------------
FUNCTION Select_DataProref4 (P_codDossProj IN CHAR) RETURN NUMBER IS

   l_annee0  NUMBER(4);
   l_msg  VARCHAR2(1024);

   l_numseq         NUMBER ; -- numéro de séquence identifiant l'extraction en cours

-- déclaration du cursor pour rammener les Dossiers Projets
-- -------------------------------------------------------------

cursor c_curDossProj (cp_anneeN Number, cp_CodDossProj char) IS
select
       si.coddeppole               CODEDP,
       si.sigdep ||'/'|| si.sigpole as    SIGDP,
       lb.pid                      PID,
       lb.typproj                  PTYPE,
       lb.codcamo                  CODCAMO,
       substr(lb.pnom,1,20)         LIBPROJET,
       substr(r.rnom,1,10)          CHEFPROJET,
       nvl(nvl(conso.cusag,0) + nvl(conso_1.cusag,0) + nvl(conso_2.xcusag,0) ,0) CUMULJH,
       nvl(conso.cusag, 0)              CONSOJH,
       f_facint(lb.pid)          FACINT,
       nvl(floor(budg.reestime), 0)     REESTJH,
       nvl(floor(budg.bpmontme), 0)     PROPOJH,
       nvl(budg.bnmont, 0)              NOTIFJH,
       nvl(floor(budg.reserve), 0)      RESERJH,
       nvl(budg.anmont, 0)              ARBITJH,
       nvl(floor(budg1.bpmontme), 0)    PROPOJHN1,
       cm.clicode                  CODMO,
       cm.clisigle                 SIGDIRMO
from  ligne_bip           lb     ,
      dossier_projet      dp     ,  -- ###
      ressource           r      ,
      budget         budg   ,
      budget         budg1  ,
      consomme         conso  ,
      consomme         conso_1,
      consomme         conso_2,
      client_mo           cm     ,
      struct_info         si
where  lb.dpcode   = dp.dpcode  -- ###
   and lb.clicode  = cm.clicode
   and lb.pcpi     = r.ident
   and lb.codsg    = si.codsg
   and lb.typproj in (1,2,3,4,6,8,9) -- BPO : Ajout ligne de type 9 (TD 585)
   and lb.dpcode = TO_NUMBER(cp_CodDossProj)  -- ###
   and cm.clicode not in ('999  ', ' AB  ')  -- absent dans Select_DataReftrans
   and lb.pid = budg.pid     (+)
    and lb.pid = budg1.pid   (+)
    and lb.pid = conso.pid  (+)
    and lb.pid = conso_1.pid (+)
   and lb.pid = conso_2.pid    (+)
   -- Au moins une des donnees n°9 a 15, ou b.xcusag0 ou b.xcusagM1 est different de zero
   and (   (  conso.cusag     <> 0 AND   conso.cusag    is not null )
        OR (  conso_1.cusag    <> 0 AND   conso_1.cusag   is not null )
      OR (  conso_2.xcusag    <> 0 AND   conso_2.xcusag   is not null )
        OR ( f_facint(lb.pid) <> 0 )
        OR ( budg.reestime  <> 0 AND  budg.reestime is not null )
        OR ( budg.bpmontme     <> 0 AND  budg.bpmontme    is not null )
        OR ( budg.bnmont      <> 0 AND  budg.bnmont     is not null )
        OR ( budg.reserve     <> 0 AND  budg.reserve    is not null )
        OR (budg.anmont      <> 0 AND budg.anmont     is not null )
        OR (budg.bpmontme     <> 0 AND budg.bpmontme    is not null )
        )
and budg.annee(+)  =  cp_anneeN
and conso.annee(+)  =  cp_anneeN
and conso_1.annee(+) =  cp_anneeN-1
and conso_2.annee(+) = cp_anneeN-2
and budg1.annee(+) =  cp_anneeN+1;
-- AND ROWNUM < 20;  --


BEGIN

      -- p_msg := '';
      SELECT TO_NUMBER( TO_CHAR( datdebex, 'YYYY'))
    INTO l_annee0
    FROM datdebex;

      SELECT Seqreftrans.nextval INTO l_numseq FROM dual;

      FOR enr_cur IN c_curDossProj (l_annee0, P_codDossProj)
      LOOP
         INSERT INTO Tmpreftrans
          (numseq, CODEDP, SIGDP, PID, PTYPE, CODCAMO, LIBPROJET, CHEFPROJET, CUMULJH,
            CONSOJH, FACINT, REESTJH, PROPOJH, NOTIFJH, RESERJH, ARBITJH, PROPOJHN1,
            CODMO, SIGDIRMO)
       VALUES
            (l_numseq, enr_cur.CODEDP, enr_cur.SIGDP, enr_cur.PID, enr_cur.PTYPE,
             enr_cur.CODCAMO, enr_cur.LIBPROJET, enr_cur.CHEFPROJET, enr_cur.CUMULJH,
             enr_cur.CONSOJH, enr_cur.FACINT, enr_cur.REESTJH, enr_cur.PROPOJH,
             enr_cur.NOTIFJH, enr_cur.RESERJH, enr_cur.ARBITJH, enr_cur.PROPOJHN1,
             enr_cur.CODMO, enr_cur.SIGDIRMO);
      END LOOP;

      -----------------
      -- COMMIT
      -----------------
      COMMIT;

      RETURN l_numseq;

EXCEPTION
   WHEN OTHERS THEN
   RETURN 0; -- code d'erreur
END Select_DataProref4;


-- -------------------------------------------------------------------------
-- FUNCTION Delete_Donnees
-- Role : Supprime, dans la table Tmpreftrans, les données creees par la
-- fonction Select_DataReftrans A la fin de l'édition.
-- -------------------------------------------------------------------------

FUNCTION Delete_Donnees (
             P_numseq IN NUMBER   -- Code Porjet ou Code Appli ou code Dossier Projet
                         ) RETURN BOOLEAN IS
BEGIN
   DELETE FROM tmpreftrans
   WHERE  numseq = p_numseq;
   COMMIT;
   RETURN TRUE;
EXCEPTION
      WHEN OTHERS THEN RETURN(FALSE); -- NOK
END Delete_Donnees;


-- -------------------
END pack_RefPCM;
/



