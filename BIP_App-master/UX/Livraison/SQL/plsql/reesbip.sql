-- pack_rees_bip PL/SQL
--
-- equipe SOPRA
--
-- crée le 09/04/1999
-- 
-- -------------- MODIFICATION ----------------------
-- 16/11/1999 :Changement dans select de la 
-- colonne pconsn1 de ligne_bip a xcusag0 de budcons.
-- 12/01/2000 : Chgt de dans select_rees_bip
-- modification du select le filtre ne dois pas se faire sur
-- les tables budg_notif et budcons uniquement sur ligne_bip.
-- --------------------------------------------------
-- 20/01/2000 : ajout de l'appel à la procedure de maj
--              des reestime (BUDCONSMAJ shu=5 sto=5)
-- 23/05/2000 : NON on n'appelle pas BUDCONSMAJ qui met a jour tous les pids
--              on met a jour directement la table BUDCONS avec notre pid !
-- --------------------------------------------------
-- 19/02/2001 (NBM) : gestion des habilitation selon le périmètre de l'utilisateur :
--		      le codsg de la ligne BIP doit appartenir au périmètre de l'utilisateur
-- avril 2002 : refonte budget
-- 06/10/2003 Pierre JOSSE : Modifications migration RTFE, modifs du format des DPG.
-- Le 05/12/2005 par BAA  : Fiche 299 : LOG Ligne BIP - nouvelles zone à surveiller arbitre et réestime
-- Le 25/01/2006 par BAA  : Correstion du beg de la prod
-- Attention le nom du package ne peut etre le nom
-- de la table...
-- 11/06/2007 JAL : Fiche 556 exclusion lignes BIP type 9
-- 28/09/2009   ABA: TD 822 (lot 7.3) trace des modifications des budgets
-- 24/04/2012   RBO : HPPM 31739 (pour livraison 8.4) Enrichissement traçabilité du Réeestimé et d'Arbitré


CREATE OR REPLACE PACKAGE       "PACK_REES_BIP" AS

   TYPE rees_RecType IS RECORD (pid        LIGNE_BIP.pid%TYPE,
                                pnom       LIGNE_BIP.pnom%TYPE,
                                typproj    LIGNE_BIP.TYPPROJ%TYPE ,
                                codsg      VARCHAR2(20),
                                xcusag0    VARCHAR2(20),
                                bnmont     VARCHAR2(20),
                                preesancou VARCHAR2(20),
                                reescomm   BUDGET.reescomm%TYPE,
                                estimpluran VARCHAR2(20),
                                flaglock   BUDGET.flaglock%TYPE,
                                flag       LIGNE_BIP.flaglock%TYPE,
                                redate     BUDGET.redate%TYPE,
                                ureestime  BUDGET.ureestime%TYPE
                               );


   TYPE reesCurType IS REF CURSOR RETURN rees_RecType;

   PROCEDURE update_rees_bip (p_pid         IN  LIGNE_BIP.pid%TYPE,
                              p_pnom        IN  LIGNE_BIP.pnom%TYPE,
                              p_codsg       IN  VARCHAR2,
                              p_xcusag0     IN VARCHAR2,
                              p_bnmont      IN  VARCHAR2,
                              p_preesancou  IN  VARCHAR2,
                              p_reescomm    IN VARCHAR2,
                              p_estimpluran IN  VARCHAR2,
                              p_flag        IN NUMBER,
                              p_flaglock    IN  NUMBER,
                              p_userid      IN  VARCHAR2,
                              p_nbcurseur   OUT INTEGER,
                              p_message     OUT VARCHAR2
                             );


   PROCEDURE select_rees_bip (p_pid       IN LIGNE_BIP.pid%TYPE,
                              p_userid    IN VARCHAR2,
                              p_currees   IN OUT reesCurType,
                              p_curBudgetHisto IN OUT PACK_GESTBUDG.budgHistoCurType,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                             );

END Pack_Rees_Bip;
/


CREATE OR REPLACE PACKAGE BODY "PACK_REES_BIP" AS

-- *********************************************************************
--  update_rees_bip
-- *********************************************************************

   PROCEDURE update_rees_bip (p_pid         IN  LIGNE_BIP.pid%TYPE,
                              p_pnom        IN  LIGNE_BIP.pnom%TYPE,
                              p_codsg       IN  VARCHAR2,
                              p_xcusag0     IN VARCHAR2,
                              p_bnmont      IN  VARCHAR2,
                              p_preesancou  IN  VARCHAR2,
                              p_reescomm     IN VARCHAR2,
                              p_estimpluran IN  VARCHAR2,
                              p_flag        IN NUMBER,
                              p_flaglock    IN  NUMBER,
                              p_userid      IN  VARCHAR2,
                              p_nbcurseur   OUT INTEGER,
                              p_message     OUT VARCHAR2
                             ) IS

   l_reescomm_size INTEGER;
   l_matricule BUDGET_HISTO.MATRICULE%TYPE;
   
   l_msg                       VARCHAR2(1024);
   l_msg2 VARCHAR2(1024);
   LC$Requete      VARCHAR2(2048) ;
   l_datdebex             NUMBER(4);
   l_bud_rst              VARCHAR2(15);
   l_redate    BUDGET.redate%TYPE;
   l_reescomm   BUDGET.reescomm%TYPE;
   l_estimplurian      LIGNE_BIP.estimplurian%TYPE;
   l_user                      LIGNE_BIP_LOGS.user_log%TYPE;
   l_count                   NUMBER;

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';
      l_msg := '';
      l_msg2 := '';
      LC$Requete := '';
      l_reescomm_size := 200;

      SELECT TO_NUMBER(TO_CHAR(DATDEBEX,'YYYY')) INTO l_datdebex FROM DATDEBEX;

      --n recupere l'ancien réestimé

       BEGIN

            SELECT COUNT(*)
            INTO  l_count
            FROM BUDGET
            WHERE pid = p_pid
            AND   annee =  l_datdebex;

            IF(l_count != 0)THEN

                  BEGIN
                       SELECT  to_char(replace(to_char(reestime,'FM999999999990D00'),'.',',')), 
                               redate,
                               NVL(reescomm, '')
                    INTO  l_bud_rst, 
                          l_redate,
                          l_reescomm
                    FROM BUDGET
                        WHERE pid = p_pid
                         AND   annee =  l_datdebex
                      AND flaglock=p_flaglock;

                       EXCEPTION

                      WHEN NO_DATA_FOUND  THEN

                         -- 'Accès concurrent'

                                         Pack_Global.recuperer_message( 20999, NULL, NULL,
                                                                       NULL, l_msg);
                                   RAISE_APPLICATION_ERROR( -20999, l_msg);

                        WHEN OTHERS THEN
                                RAISE_APPLICATION_ERROR( -20997, SQLERRM);

               END;

            END IF;

         END;
      
      -- 'Nouveau réestimé du projet %s1, saisi pour cette année'
     pack_global.recuperer_message(2078, '%s1', p_pid, NULL, l_msg);
     l_msg2 := l_msg;
      
      BEGIN

        l_matricule := substr( p_userid, 1, INSTR( p_userid, ';', 1, 1)-1);
        l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

        -- Si un réestimé ou un commentaire différent de l'existant a été saisi
        IF (nvl(l_bud_rst,' ') != nvl( p_preesancou ,' ')) OR
           (nvl(l_reescomm,' ') != nvl(p_reescomm, ' ')) THEN
            
            LC$Requete := 'UPDATE BUDGET SET ';
            IF (nvl(l_bud_rst,' ') != nvl( p_preesancou ,' ')) THEN
                 LC$Requete := LC$Requete || 
                 'reestime = ''' || TO_NUMBER(p_preesancou) || 
                 ''', redate  =  ''' || SYSDATE || 
                 ''', ureestime = ''' || l_matricule || 
                 ''', flaglock  = DECODE( ''' || p_flaglock || ''', 1000000, 0, ''' || (p_flaglock + 1) || ''')';
                --AND    flaglock = p_flaglock;
                IF (nvl(l_reescomm,' ') != nvl(p_reescomm, ' ')) THEN
                    LC$Requete := LC$Requete || ', ';
                END IF;
            END IF;
            
            IF (nvl(l_reescomm,' ') != nvl(p_reescomm, ' ')) THEN
                LC$Requete := LC$Requete || 'reescomm = ''' || pack_gestbudg.recupererCommentaireReestime(p_reescomm, l_reescomm_size) || '''';
            END IF;
            
            LC$Requete := LC$Requete || ' WHERE  pid = ''' || p_pid || ''' AND annee = ''' || l_datdebex || '''';

            EXECUTE IMMEDIATE LC$Requete;
          
        END IF;
       
        EXCEPTION
          WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM );
     END;

    -- Cas de l'insertion
    IF SQL%NOTFOUND THEN

        INSERT INTO BUDGET (     ANNEE,
                     PID,
                     REESTIME,
                     reescomm,
                     FLAGLOCK,
                     redate,
                     ureestime
          )
            VALUES     (l_datdebex,
                 p_pid,
                 TO_NUMBER(p_preesancou,'FM9999999990D00'),
                 pack_gestbudg.recupererCommentaireReestime(p_reescomm, l_reescomm_size),
                 0,
                 sysdate,
                 l_user
         );
          
             -- On loggue le réestimé insert
            Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Réestimé ' || l_datdebex, NULL,TO_NUMBER(p_preesancou,'FM9999999990D00'), 'Création via IHM');
            
            -- 'Nouveau commentaire de réestimé du projet %s1, saisi pour cette année'
            Pack_Global.recuperer_message( 21269, '%s1', p_pid, NULL, l_msg);
         
           IF p_reescomm IS NOT NULL THEN
             IF l_msg2 IS NULL THEN
               l_msg2 := l_msg;
             ELSE
               l_msg2 := l_msg2 || '\n' || l_msg;
             END IF;
           END IF;
           
    -- Cas de la mise à jour
    ELSE

           -- ABN - PPM 64290
		   -- FAD PPM 64543 : Ajout de l'exception NO_DATA_FOUND
            begin
				select USER_LOG into l_matricule from ligne_bip_logs where pid = p_pid and colonne like 'Réestimé%' and DATE_LOG =
				(SELECT MAX(DATE_LOG) FROM LIGNE_BIP_LOGS WHERE PID = P_PID AND COLONNE LIKE 'Réestimé%' AND ROWNUM = 1);
            EXCEPTION WHEN NO_DATA_FOUND
            THEN
				L_MATRICULE := NULL;
            end;
			-- FAD PPM 64543 : Fin
             -- On loggue le réestimé updat
            Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Réestimé ', l_bud_rst, p_preesancou, 'Modification via IHM');

            -- Si le commentaire saisi est différent du commentaire existant
            IF (nvl(p_reescomm,'-') != nvl(l_reescomm, '-')) THEN
                -- 'Nouveau commentaire de réestimé du projet %s1, saisi pour cette année'
                Pack_Global.recuperer_message( 21269, '%s1', p_pid, NULL, l_msg);
                 IF l_msg2 IS NULL THEN
                    l_msg2 := l_msg;
                 ELSE
                    l_msg2 := l_msg2 || '\n' || l_msg;
                 END IF;


            END IF;

            IF (nvl(l_bud_rst,' ') != nvl( p_preesancou ,' ')) THEN
              -- Historisation de l'ancienne valeur du réestimé

              pack_gestbudg.insert_budget_histo (1,
                                  p_pid,
                                  TO_NUMBER(l_datdebex),
                                  TO_NUMBER(l_bud_rst),
                                  l_redate,
                                  l_matricule,
                                  pack_gestbudg.recupererCommentaireReestime(l_reescomm, l_reescomm_size));
              -- Suppression des historiques réestimé les plus anciens si plus de 5 historiques sont présents
              pack_gestbudg.delete_old_budget_histo(1, p_pid, TO_NUMBER(l_datdebex));
            END IF;

    END IF;

    BEGIN

      BEGIN

          SELECT estimplurian INTO l_estimplurian
          FROM LIGNE_BIP
          WHERE  pid = p_pid
         AND    flaglock = p_flag;

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- 'Accès concurrent'

               Pack_Global.recuperer_message( 20999, NULL, NULL,
                                              NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20999, l_msg);

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;

         UPDATE LIGNE_BIP SET estimplurian = TO_NUMBER(p_estimpluran,'FM9999999990D00'),
                              flaglock   = DECODE( p_flag, 1000000, 0, p_flag + 1)
         WHERE  pid = p_pid
         AND    flaglock = p_flag;

          -- On loggue le Estimation pluriannuelle
          Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Estimation pluriannuelle ', l_estimplurian,TO_NUMBER(p_estimpluran,'FM9999999990D00'), 'Par Ligne/Réestimé/Modification du réestimé');

      EXCEPTION

        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;

     p_message := l_msg2;
    
   END update_rees_bip;


-- *********************************************************************
--  select_rees_bip
-- *********************************************************************

   PROCEDURE select_rees_bip (p_pid       IN LIGNE_BIP.pid%TYPE,
                              p_userid    IN VARCHAR2,
                              p_currees   IN OUT reesCurType,
                              p_curBudgetHisto IN OUT PACK_GESTBUDG.budgHistoCurType,
                              p_nbcurseur OUT INTEGER,
                              p_message   OUT VARCHAR2
                             ) IS

      msg               VARCHAR2(1024);
      l_codsg             LIGNE_BIP.codsg%TYPE;
      l_year_courante     BUDGET.annee%TYPE;
      l_ges               NUMBER(3);
      l_habilitation      VARCHAR2(10);
      l_statut         VARCHAR2(56);
      l_date_statut     VARCHAR2(10);
      l_topfer         CHAR(1);
      l_datdebex     VARCHAR2(10);
      l_date_statut_number NUMBER(10);
      l_menu         VARCHAR2(255);



   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
     -- p_message := '';


    l_menu := Pack_Global.lire_globaldata(p_userid).menutil;


      -- TEST d'habilitation

      BEGIN
         SELECT codsg
         INTO   l_codsg
         FROM   LIGNE_BIP
         WHERE  pid = p_pid;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            Pack_Global.recuperer_message( 20504, '%s1', p_pid, NULL, msg);
            RAISE_APPLICATION_ERROR( -20504, msg);

          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      -- ====================================================================
      -- 19/02/2001 : Test appartenance du DPG au périmètre de l'utilisateur
      -- ====================================================================
         l_habilitation := Pack_Habilitation.fhabili_me( l_codsg,p_userid   );
    IF l_habilitation='faux' THEN
        -- Vous n'êtes pas autorisé à modifier cette ligne BIP, son DPG est
        Pack_Global.recuperer_message(20365, '%s1',  'modifier cette ligne BIP, son DPG est '||l_codsg, 'PID', msg);
                RAISE_APPLICATION_ERROR(-20365, msg);
    END IF;


    -- test de la date statut
    IF (l_menu <> 'DIR') THEN
        SELECT TO_CHAR(adatestatut,'DD/MM/YYYY'),NVL(astatut,'Pas de statut'),topfer INTO l_date_statut,l_statut,l_topfer
        FROM LIGNE_BIP WHERE pid = p_pid;

        SELECT TO_NUMBER(TO_CHAR(adatestatut,'YYYY')) INTO l_date_statut_number
        FROM LIGNE_BIP WHERE pid = p_pid;


        SELECT TO_NUMBER(TO_CHAR(DATDEBEX,'YYYY')) INTO l_datdebex FROM DATDEBEX;


        IF ((l_date_statut IS NOT NULL) AND (l_date_statut_number < l_datdebex)) THEN
        RAISE_APPLICATION_ERROR (-20000,'Vous ne pouvez pas modifier la ligne bip ' || p_pid ||
                    ' car son statut est ' || l_statut ||
                    ', son top fermeture est ' || l_topfer ||
                    ' et sa date de statut ou de top fermeture est ' || l_date_statut);
        END IF;
    END IF;

      -- Annee courante

      SELECT TO_NUMBER(TO_CHAR(DATDEBEX,'yyyy'),'9999')
      INTO   l_year_courante
      FROM   DATDEBEX;

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN

     OPEN p_currees FOR
       SELECT LIGNE_BIP.pid,
         LIGNE_BIP.pnom,
         LIGNE_BIP.typproj,
         TO_CHAR(LIGNE_BIP.codsg),
         NVL(TO_CHAR(conso.cusag,'FM999999990D00'),'0,00'),
         NVL(TO_CHAR(budg.bnmont,'FM999999990D00'),'0,00'),
         TO_CHAR(budg.reestime,'FM999999990D00'),
         budg.reescomm,
         NVL(TO_CHAR(LIGNE_BIP.estimplurian,'FM999999990D00'),'0,00'),
         NVL(budg.flaglock,0),
         LIGNE_BIP.flaglock,
       TO_CHAR(budg.redate,'DD/MM/YYYY'),
       budg.ureestime

         FROM   LIGNE_BIP, BUDGET budg, CONSOMME conso
         WHERE  LIGNE_BIP.pid      = p_pid
         AND    LIGNE_BIP.pid   = budg.pid(+)
         AND    LIGNE_BIP.pid   = conso.pid(+)
         AND    budg.annee(+) = l_year_courante
         AND    conso.annee(+) = l_year_courante;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20997,SQLERRM);
      END;

      -- en cas absence
      -- p_message := ;

      Pack_Global.recuperer_message(5010, NULL, NULL, NULL, msg);
     -- p_message := msg;
     
     OPEN p_curBudgetHisto FOR
      SELECT	TO_CHAR(valeur, 'FM9999999990D00'), TO_CHAR(date_modif, 'DD/MM/YYYY'), matricule, commentaire
      FROM    BUDGET_HISTO budgh
           WHERE  budgh.type_histo = 1
            AND	budgh.pid    = p_pid
            AND   budgh.annee  = l_year_courante
            ORDER BY budgh.id_budget_histo DESC;

   END select_rees_bip;

END Pack_Rees_Bip;
/


