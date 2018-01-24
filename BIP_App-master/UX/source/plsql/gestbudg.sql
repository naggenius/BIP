-- pack_gestbudg PL/SQL
--
-- Equipe SOPRA 
--
-- Crée le 08/03/1999
--
--
-- Modifications 
-- 20/01/1999 ajout de l'appel a la procedure de maj
-- des budgets BUCONSMAJ
--
-- 09/10/2001 -ARE : prise en compte de la nouvelle zone budget BPMONTMO (zone proposé N+1 MO) 
-- 04/2002 ARE refonte budget
-- 04/07/2003 remplacement p_global per p_userid et p_bouton par p_mode
-- 22/11/2005 PPR : insere le réestimé si le budget n'existe pas 
-- Le 02/12/2005 par BAA  : Fiche 299 : LOG Ligne BIP - nouvelles zone à surveiller arbitre et réestime
-- Le 18/08/2009 par EVI  : Fiche 782
-- Le 26/08/2009 par YSB  : Fiche 782
-- Le 06/10/2009 par YNA  : Fiche 839
-- Le 08/10/2009 par YSB  : Fiche 839
-- Le 22/12/2009 par YNA  : Fiche 888
-- Le 26/01/2010 par YSB  : Fiche 888
-- Le 17/02/2010 par YSB  : Fiche 888
-- le 11/05/2011 par CMA : Fiche 1176 si on est dans le menu client, on utilise perim_mcli pour le périmètre MO
-- le 11/04/2012 par ABA : QC 1416
-- le 14/06/2012 par OEL : QC 1391
-- le 24/04/2012 par RBO : HPPM 31739 (pour livraison 8.4) Enrichissement traçabilité du Réeestimé et d'Arbitré
--*********************************************************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE       "PACK_GESTBUDG" AS

   TYPE GestBudg_ViewType IS RECORD( pid          LIGNE_BIP.pid%TYPE,
                                     pnom         LIGNE_BIP.pnom%TYPE,
                                     codsg        LIGNE_BIP.codsg%TYPE,
                                     libdsg       STRUCT_INFO.libdsg%TYPE,
                                     astatut      LIGNE_BIP.astatut%TYPE,
                                     date_statut  VARCHAR2(20),
                                     annee        VARCHAR2(20),
                                     bud_prop     VARCHAR2(20),
                                     bud_propmo   VARCHAR2(20),
                                     bud_not      VARCHAR2(20),
                                     bud_arb      VARCHAR2(20),
                                     reserve      VARCHAR2(20),
                                     bud_rst      VARCHAR2(20),
                                     flaglock     NUMBER,
                                     bpdate       BUDGET.bpdate%TYPE,
                                     bpmedate     BUDGET.bpmedate%TYPE,
                                     bndate       BUDGET.bndate%TYPE,
                                     redate       BUDGET.redate%TYPE,
                                     bresdate     BUDGET.bresdate%TYPE,
                                     ubpmontme    BUDGET.ubpmontme%TYPE,
                                     ubpmontmo    BUDGET.ubpmontmo%TYPE,
                                     ubnmont      BUDGET.ubnmont%TYPE,
                                     uanmont      BUDGET.uanmont%TYPE,
                                     ureestime    BUDGET.ureestime%TYPE,
                                     ureserve     BUDGET.ureserve%TYPE,
                                     arbcomm      BUDGET.arbcomm%TYPE,
                                     reescomm     BUDGET.reescomm%TYPE,
                                     apdate      BUDGET.apdate%TYPE
                                   );

   TYPE gestbudgCurType IS REF CURSOR RETURN GestBudg_ViewType;

   PROCEDURE update_gestbudg ( p_pid          IN LIGNE_BIP.pid%TYPE,
                               p_pnom         IN LIGNE_BIP.pnom%TYPE,
                               p_annee        IN CHAR,
                               p_bud_prop     IN VARCHAR2,
                               p_bud_propmo   IN VARCHAR2,
                               p_bud_not      IN VARCHAR2,
                               p_bud_arb      IN VARCHAR2,
                               p_arbcomm      IN VARCHAR2,
                               p_bud_rst      IN VARCHAR2,
                               p_reescomm     IN VARCHAR2,
                               p_reserve      IN VARCHAR2,
                               p_flaglock     IN NUMBER,
                               p_userid       IN VARCHAR2,
                               p_nbcurseur    OUT INTEGER,
                               p_message      OUT VARCHAR2
                             );

   PROCEDURE select_gestbudg ( p_pid         IN LIGNE_BIP.pid%TYPE,
                               p_annee       IN VARCHAR2,
                               p_mode      IN VARCHAR2,
                               p_userid      IN VARCHAR2,
                               p_curGestbudg IN OUT gestbudgCurType,
                               p_annee_sav   OUT VARCHAR2,
                               p_bud_rees    OUT VARCHAR2,
                               p_nbcurseur   OUT INTEGER,
                               p_message     OUT VARCHAR2,
                               p_perimo   OUT VARCHAR2,
                               p_perime   OUT VARCHAR2
                             );
                             
  FUNCTION recupererValeurArbitre( p_bud_arb IN VARCHAR2) RETURN NUMBER;
  FUNCTION recupererValeurReestime(p_bud_rst IN VARCHAR2) RETURN NUMBER;
  FUNCTION recupererCommentaireArbitre (p_arbcomm IN VARCHAR2, 
                                       p_arbcomm_size IN INTEGER) RETURN VARCHAR2;
  FUNCTION recupererCommentaireReestime(p_reescomm IN VARCHAR2, 
                                       p_reescomm_size IN INTEGER) RETURN VARCHAR2;
                                
  PROCEDURE insert_budget_histo (p_type_histo IN BUDGET_HISTO.TYPE_HISTO%TYPE,
                                p_pid IN BUDGET_HISTO.PID%TYPE,
                                p_annee IN BUDGET_HISTO.ANNEE%TYPE,
                                p_valeur IN BUDGET_HISTO.VALEUR%TYPE,
                                p_date_modif IN BUDGET_HISTO.DATE_MODIF%TYPE,
                                p_matricule IN BUDGET_HISTO.MATRICULE%TYPE,
                                p_commentaire IN BUDGET_HISTO.COMMENTAIRE%TYPE
                                  );
                                  
	PROCEDURE delete_old_budget_histo (p_type_histo IN BUDGET_HISTO.TYPE_HISTO%TYPE,
									p_pid IN BUDGET_HISTO.PID%TYPE,
									p_annee IN BUDGET_HISTO.ANNEE%TYPE
									);
	 
	-- Enregistrement Budget Historique	arbitré						 
	TYPE GestBudgHistoArb_ViewType IS RECORD(pid		LIGNE_BIP.pid%TYPE,
											 pnom       LIGNE_BIP.pnom%TYPE,
											 codsg      LIGNE_BIP.codsg%TYPE,
											 libdsg     STRUCT_INFO.libdsg%TYPE,
											 annee		BUDGET.annee%TYPE,
											 astatut    LIGNE_BIP.astatut%TYPE,
											 bud_arb    VARCHAR2(20),
											 apdate     BUDGET.apdate%TYPE,
											 uanmont  	BUDGET.uanmont%TYPE,
											 arbcomm   	BUDGET.arbcomm%TYPE
											 );

	-- Curseur liste d'enregistrements Budget Historique arbitré
	TYPE gestbudgHistoArbCurType IS REF CURSOR RETURN GestBudgHistoArb_ViewType;

	-- Enregistrement Budget Historique	réestimé	
	TYPE GestBudgHistoRees_ViewType IS RECORD(pid		LIGNE_BIP.pid%TYPE,
											 pnom       LIGNE_BIP.pnom%TYPE,
											 codsg      LIGNE_BIP.codsg%TYPE,
											 libdsg     STRUCT_INFO.libdsg%TYPE,
											 annee		BUDGET.annee%TYPE,
											 astatut    LIGNE_BIP.astatut%TYPE,
											 bud_rst    VARCHAR2(20),
											 redate     BUDGET.redate%TYPE,
											 ureestime  BUDGET.ureestime%TYPE,
											 reescomm   BUDGET.reescomm%TYPE
											);

	-- Curseur liste d'enregistrements Budget Historique réestimé
	TYPE gestbudgHistoReesCurType IS REF CURSOR RETURN GestBudgHistoRees_ViewType;

	-- Enregistrement Budget Historique (partie commune)
	TYPE BudgHisto_ViewType IS RECORD(valeur		BUDGET_HISTO.valeur%TYPE,
									  date_modif	VARCHAR2(20),
									  matricule		BUDGET_HISTO.matricule%TYPE,
									  commentaire	BUDGET_HISTO.commentaire%TYPE
									);

	-- Curseur liste d'enregistrements Budget Historique							
	TYPE budgHistoCurType IS REF CURSOR RETURN budgHisto_ViewType;

									
	  -- Interface : Récupération d'un budget arbitré et de son historique
	PROCEDURE select_gestbudg_histo_arb ( p_pid         IN LIGNE_BIP.pid%TYPE,
								   p_annee       IN VARCHAR2,
								   p_userid      IN VARCHAR2,
								   p_curGestbudgHistoArb IN OUT gestbudgHistoArbCurType,
								   p_curBudgetHisto IN OUT budgHistoCurType,
								   p_message     OUT VARCHAR2
								 );

	-- Interface : Récupération d'un budget réestimé et de son historique
	PROCEDURE select_gestbudg_histo_rees ( p_pid         IN LIGNE_BIP.pid%TYPE,
								   p_annee       IN VARCHAR2,
								   p_userid      IN VARCHAR2,
								   p_curGestbudgHistoRees IN OUT gestbudgHistoReesCurType,
								   p_curBudgetHisto IN OUT budgHistoCurType,
								   p_message     OUT VARCHAR2
								 );

END Pack_Gestbudg;
/


CREATE OR REPLACE PACKAGE BODY "PACK_GESTBUDG" AS

   -- Création / Mise à jour d'un budget
PROCEDURE update_gestbudg ( p_pid          IN LIGNE_BIP.pid%TYPE,
                               p_pnom         IN LIGNE_BIP.pnom%TYPE,
                               p_annee        IN CHAR,
                               p_bud_prop     IN VARCHAR2,
                               p_bud_propmo   IN VARCHAR2,
                               p_bud_not      IN VARCHAR2,
                               p_bud_arb      IN VARCHAR2,
                               p_arbcomm      IN VARCHAR2,
                               p_bud_rst      IN VARCHAR2,
                               p_reescomm     IN VARCHAR2,
                               p_reserve      IN VARCHAR2,
                               p_flaglock     IN NUMBER,
                               p_userid       IN VARCHAR2,
                               p_nbcurseur    OUT INTEGER,
                               p_message      OUT VARCHAR2
                             ) IS
      l_msg VARCHAR(1024);
      l_msg2 VARCHAR2(1024);
      LC$Requete      VARCHAR2(2048) ;
      
      l_arbcomm_size INTEGER;
      l_reescomm_size INTEGER;
      
      l_date_modif BUDGET_HISTO.DATE_MODIF%TYPE;
      l_matricule BUDGET_HISTO.MATRICULE%TYPE;
      
      l_bud_prop  VARCHAR2(13);
      l_bud_propmo  VARCHAR2(13);
      l_bud_not   VARCHAR2(13);
      l_bud_arb   VARCHAR2(13);
      l_apdate    BUDGET.apdate%TYPE;
      l_arbcomm   BUDGET.arbcomm%TYPE;
      l_reserve   VARCHAR2(13);
      l_bud_rst   BUDGET.reestime%TYPE;
      l_redate    BUDGET.redate%TYPE;
      l_reescomm   BUDGET.reescomm%TYPE;
      l_datdebex VARCHAR(20);
      l_user        LIGNE_BIP_LOGS.user_log%TYPE;

   BEGIN

 l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);


      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
      l_msg := '';
      l_msg2 := '';
      LC$Requete := '';
      l_arbcomm_size := 200;
      l_reescomm_size := 200;

      SELECT TO_CHAR(DATDEBEX,'YYYY') INTO l_datdebex FROM DATDEBEX;
      -- La valeur du flaglock issu de PROP_BUDGET indique la présence
      -- ou non des données

      IF (p_flaglock=-1) THEN

         -- L'occurence code projet-année n'existe pas, on l'insère
         BEGIN

            INSERT INTO BUDGET ( pid,
                                      annee,
                                      bpdate,
                                      bpmontme,
                                      reserve,
                      bpmontmo,
                      bnmont,
                      anmont,
                      apdate,
                      reestime,
                      bpmedate,
                      bndate,
                      redate,
                      bresdate,
                      ubpmontme,
                      ubpmontmo,
                      ubnmont,
                      uanmont,
                      ureestime,
                      ureserve,
                      arbcomm,
                      reescomm,
                      flaglock)
            VALUES( p_pid,
                    TO_NUMBER( p_annee),
                      DECODE(p_bud_prop, '', null, NULL, null, sysdate),
                      DECODE(p_bud_prop, '', null, NULL, null, TO_NUMBER(p_bud_prop,'FM9999999990D00')),
                      DECODE(p_reserve, '', null, NULL, null, TO_NUMBER(p_reserve,'FM9999999990D00')),
                      DECODE(p_bud_propmo, '', null, NULL, null, TO_NUMBER(p_bud_propmo,'FM9999999990D00')),
                      DECODE(p_bud_not, '', null, NULL, null, TO_NUMBER(p_bud_not,'FM9999999990D00')),
                      DECODE(p_bud_arb, '', null, NULL, null, TO_NUMBER(p_bud_arb,'FM9999999990D00')),
                      DECODE(p_bud_arb, '', null, NULL, null, sysdate),
                      DECODE(p_bud_rst, '', null, NULL, null, TO_NUMBER(p_bud_rst,'FM9999999990D00')),
                      DECODE(p_bud_propmo, '', null, NULL, null, sysdate),
                      DECODE(p_bud_not, '', null, NULL, null, sysdate),
                      DECODE(p_bud_rst, '', null, NULL, null, sysdate),
                      DECODE(p_reserve, '', null, NULL, null, sysdate),
                      DECODE(p_bud_prop, '', null, NULL, null, l_user),
                      DECODE(p_bud_propmo, '', null, NULL, null, l_user),
                      DECODE(p_bud_not, '', null, NULL, null, l_user),
                      DECODE(p_bud_arb, '', null, NULL, null, l_user),
                      DECODE(p_bud_rst, '', null, NULL, null, l_user),
                      DECODE(p_reserve, '', null, NULL, null, l_user),
                      DECODE(p_arbcomm, NULL, null, SUBSTR(p_arbcomm,0,l_arbcomm_size)),
                      DECODE(p_reescomm, NULL, null, SUBSTR(p_reescomm,0,l_reescomm_size)),
                      0);

            -- On loggue les budgets
                Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Proposé fournisseur ' || p_annee, NULL,p_bud_prop, 'Création via IHM');
                Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Proposé client ' || p_annee, NULL,p_bud_propmo, 'Création via IHM');
                pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Notifié ' || p_annee, NULL,p_bud_not, 'Création via IHM');
                Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Arbitré ' || p_annee, NULL,p_bud_arb, 'Création via IHM');
                Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Réestimé ' || p_annee, NULL,p_bud_rst, 'Création via IHM');
                Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Reservé ' || p_annee, NULL,p_reserve, 'Création via IHM');


         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN

               -- ' budget déjà créé.'

               Pack_Global.recuperer_message( 20310, NULL, NULL,
                                              NULL, l_msg);

               RAISE_APPLICATION_ERROR( -20310, l_msg);

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;

       -- 'Proposition de budget enregistrée'

         Pack_Global.recuperer_message( 3007, NULL, NULL, NULL, l_msg);
         l_msg2 := l_msg;

    Pack_Global.recuperer_message( 3015, NULL, NULL, NULL, l_msg);
     l_msg2 := l_msg2 || '\n' || l_msg;




       -- 'Notification de budget créée.'

         Pack_Global.recuperer_message( 3009, NULL, NULL, NULL, l_msg);

         IF l_msg2 IS NULL THEN
            l_msg2 := l_msg;
         ELSE
            l_msg2 := l_msg2 || '\n' || l_msg;
         END IF;

         -- 'Notification Arbitrage créée'

         Pack_Global.recuperer_message( 3011, NULL, NULL, NULL, l_msg);

         IF l_msg2 IS NULL THEN
            l_msg2 := l_msg;
         ELSE
            l_msg2 := l_msg2 || '\n' || l_msg;
         END IF;
         
         -- 'Notification Commentaire arbitré créé'
          
         Pack_Global.recuperer_message( 21263, NULL, NULL, NULL, l_msg);
         
         IF p_arbcomm IS NOT NULL THEN
           IF l_msg2 IS NULL THEN
              l_msg2 := l_msg;
           ELSE
              l_msg2 := l_msg2 || '\n' || l_msg;
           END IF;
         END IF;
         
         -- 'Notification Réestimé créé'

         Pack_Global.recuperer_message( 21265, NULL, NULL, NULL, l_msg);
         
         IF p_bud_rst IS NOT NULL THEN
           IF l_msg2 IS NULL THEN
              l_msg2 := l_msg;
           ELSE
              l_msg2 := l_msg2 || '\n' || l_msg;
           END IF;
         END IF;
         
         -- 'Notification Commentaire réestimé créé'

         Pack_Global.recuperer_message( 21266, NULL, NULL, NULL, l_msg);
         
         IF p_reescomm IS NOT NULL THEN
           IF l_msg2 IS NULL THEN
              l_msg2 := l_msg;
           ELSE
              l_msg2 := l_msg2 || '\n' || l_msg;
           END IF;
         END IF;
         
          -- 'Notification Réserve créé'

         Pack_Global.recuperer_message( 21268, NULL, NULL, NULL, l_msg);

         IF p_reserve IS NOT NULL THEN
           IF l_msg2 IS NULL THEN
              l_msg2 := l_msg;
           ELSE
              l_msg2 := l_msg2 || '\n' || l_msg;
           END IF;
         END IF;

         p_message := l_msg2;


      ELSE

         -- L'occurence code projet-année existe
         -- On effectue la mise à jour si les données saisies sont
         -- différentes de celles de la base

         BEGIN

           SELECT NVL(TO_CHAR(bpmontme, 'FM9999999990D00'),''),
                 NVL(TO_CHAR(reserve, 'FM9999999990D00'),''),
                 NVL(TO_CHAR(bpmontmo, 'FM9999999990D00'),''),
                 NVL(TO_CHAR(bnmont, 'FM9999999990D00'),''),
                 NVL(TO_CHAR(anmont, 'FM9999999990D00'), ''),
                 apdate,
                 NVL(arbcomm, ''),
                 NVL(TO_CHAR(reestime, 'FM9999999990D00'), ''),
                 redate,
                 NVL(reescomm, '')
            INTO l_bud_prop,
                 l_reserve,
         l_bud_propmo,
         l_bud_not,
         l_bud_arb,
         l_apdate,
         l_arbcomm,
         l_bud_rst,
         l_redate,
         l_reescomm
            FROM BUDGET
            WHERE pid = p_pid
            AND   annee = TO_NUMBER( p_annee)
        AND   flaglock = TO_NUMBER(p_flaglock);

         EXCEPTION
            WHEN NO_DATA_FOUND THEN

               -- 'Accès concurrent'

               Pack_Global.recuperer_message( 20999, NULL, NULL,
                                              NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20999, l_msg);

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;

          IF (RTRIM(LTRIM(nvl(p_bud_prop,0))) != RTRIM(LTRIM(nvl(l_bud_prop,0)))) OR
            (RTRIM(LTRIM(nvl(p_reserve,0))) != RTRIM(LTRIM(nvl(l_reserve,0))))  OR
            (RTRIM(LTRIM(nvl(p_bud_propmo,0))) != RTRIM(LTRIM(nvl(l_bud_propmo,0)))) OR
            (nvl(p_bud_not,0) != nvl(l_bud_not,0)) OR
            (nvl(p_bud_arb,0) != nvl(l_bud_arb, 0)) OR
            (nvl(p_arbcomm,'-') != nvl(l_arbcomm, '-')) OR
           (p_annee = l_datdebex AND (TO_NUMBER( p_bud_rst) != l_bud_rst
            OR  l_bud_rst IS NULL
            OR  TO_NUMBER( p_bud_rst) IS NULL)) OR
            (p_annee = l_datdebex AND nvl(p_reescomm,'-') != nvl(l_reescomm, '-')) THEN

          BEGIN
            l_date_modif := TO_DATE( TO_CHAR( SYSDATE, 'DD/MM/YYYY'),'DD/MM/YYYY');
            l_matricule := substr( p_userid, 1, INSTR( p_userid, ';', 1, 1)-1);
           
            LC$Requete := 'UPDATE BUDGET SET ';
            
            IF RTRIM(LTRIM(nvl(p_bud_prop,0))) != RTRIM(LTRIM(nvl(l_bud_prop,0)))
            THEN
            LC$Requete := LC$Requete||'bpdate  = '''||TO_DATE( TO_CHAR(SYSDATE, 'DD/MM/YYYY'),'DD/MM/YYYY')||
            ''',ubpmontme = '''||substr(p_userid, 1, INSTR(p_userid, ';', 1, 1)-1)||
            ''',bpmontme = '|| 'DECODE('''||p_bud_prop||''','',00'',NULL,TO_NUMBER('''||p_bud_prop||''')),';
            END IF;

            --YNI FDT 892
            IF RTRIM(LTRIM(nvl(p_reserve,0))) != RTRIM(LTRIM(nvl(l_reserve,0)))
            THEN
            LC$Requete := LC$Requete||'bresdate  = '''||TO_DATE( TO_CHAR( SYSDATE, 'DD/MM/YYYY'),'DD/MM/YYYY')||
            ''',ureserve = '''||substr( p_userid, 1, INSTR( p_userid, ';', 1, 1)-1)||
            ''',reserve = '|| 'DECODE('''||p_reserve||''','',00'',NULL,TO_NUMBER('''|| p_reserve||''')),';
            END IF;
            --Fin YNI FDT 892

            IF RTRIM(LTRIM(nvl(p_bud_propmo,0))) != RTRIM(LTRIM(nvl(l_bud_propmo,0)))
            THEN
            LC$Requete := LC$Requete||'bpmedate  = '''||TO_DATE( TO_CHAR( SYSDATE, 'DD/MM/YYYY'),'DD/MM/YYYY')||
            ''',ubpmontmo = '''||substr( p_userid, 1, INSTR( p_userid, ';', 1, 1)-1)||
            ''',bpmontmo = '|| 'DECODE('''||p_bud_propmo||''','',00'',NULL,TO_NUMBER('''|| p_bud_propmo||''')),';
            END IF;

            IF RTRIM(LTRIM(nvl(p_bud_not,0))) != RTRIM(LTRIM(nvl(l_bud_not,0)))
            THEN
            LC$Requete := LC$Requete||'bndate  = '''||TO_DATE( TO_CHAR( SYSDATE, 'DD/MM/YYYY'),'DD/MM/YYYY')||
            ''',ubnmont = '''||substr( p_userid, 1, INSTR( p_userid, ';', 1, 1)-1)||
            ''',bnmont = '||'DECODE('''|| p_bud_not||''','',00'',NULL,TO_NUMBER('''|| p_bud_not||''')),';
             END IF;

            -- Budget arbitré
            IF RTRIM(LTRIM(nvl(p_bud_arb,0))) != RTRIM(LTRIM(nvl(l_bud_arb,0)))
            THEN
            LC$Requete := LC$Requete||'apdate  = '''||TO_DATE( TO_CHAR( SYSDATE, 'DD/MM/YYYY'),'DD/MM/YYYY')||
            ''',uanmont = '''||substr( p_userid, 1, INSTR( p_userid, ';', 1, 1)-1)||
            ''',anmont = '''||recupererValeurArbitre(p_bud_arb)||''',';
            --''',anmont = '||'DECODE('''|| p_bud_arb||''','',00'',NULL, TO_NUMBER('''|| p_bud_arb||''')),';
            END IF;
            -- Commentaire budget arbitré
            IF nvl(p_arbcomm,'-') != nvl(l_arbcomm,'-')
            THEN
            --LC$Requete := LC$Requete||'arbcomm  = '||'DECODE('''||p_arbcomm||''', NULL, null, '''||substr(p_arbcomm,0,TO_CHAR(l_arbcomm_size))||'''),';
            LC$Requete := LC$Requete||'arbcomm  = '''||recupererCommentaireArbitre(p_arbcomm, l_arbcomm_size)||''',';
            END IF;

            -- Budget réestimé
            -- ABN - HP PPM 61299
            -- FAD PPM 64587 : Conversion des deux valeurs bud_rst en NUMBER avant de faire le test
            IF (p_annee = l_datdebex AND (TO_NUMBER(RTRIM(LTRIM(nvl(p_bud_rst,0)))) != TO_NUMBER(RTRIM(LTRIM(nvl(l_bud_rst,0))))))
			-- FAD PPM 64587 : Fin
            THEN
            LC$Requete := LC$Requete||'redate  = '''||TO_DATE( TO_CHAR( SYSDATE, 'DD/MM/YYYY'),'DD/MM/YYYY')||
            ''',ureestime = '''||substr( p_userid, 1, INSTR( p_userid, ';', 1, 1)-1)||
            ''',reestime = '''||recupererValeurReestime(p_bud_rst)||''',';
            END IF ;
            
            -- Commentaire budget réestimé
            IF (p_annee = l_datdebex AND nvl(p_reescomm,'-') != nvl(l_reescomm,'-'))
            THEN
            LC$Requete := LC$Requete||'reescomm  = '''||recupererCommentaireReestime(p_reescomm, l_reescomm_size)||''',';
            END IF;

            LC$Requete := LC$Requete||'flaglock = DECODE( TO_NUMBER('''|| p_flaglock||'''), 1000000,0, TO_NUMBER('''|| (p_flaglock+ 1)||''' ) )
             WHERE pid = '''||p_pid||
             ''' AND   annee = TO_NUMBER( '''||p_annee||''')
             AND   flaglock = TO_NUMBER( '''||p_flaglock||''')';

            EXECUTE IMMEDIATE LC$Requete;

            END;

            IF SQL%NOTFOUND THEN

               -- 'Accès concurrent'

               Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20999, l_msg);
            END IF;
            
            -- Si la valeur de l'arbitré est modifiée
            IF RTRIM(LTRIM(nvl(p_bud_arb,0))) != RTRIM(LTRIM(nvl(l_bud_arb,0)))
            THEN
              -- TODO EVENTUEL : si l_bud_arb IS NULL and l_arbcomm IS NULL et qu'il n'existe pas d'historique d'arbitré, ne pas continuer
              -- (ne pas enregistrer de premier historique vide) 
             
              -- Historisation de l'ancienne valeur de l'arbitré
              insert_budget_histo (0, 
                                  p_pid, 
                                  TO_NUMBER(p_annee), 
                                  recupererValeurArbitre(l_bud_arb), 
                                  TO_DATE( TO_CHAR( l_apdate, 'DD/MM/YYYY'),'DD/MM/YYYY'), 
                                  l_matricule, 
                                  recupererCommentaireArbitre(l_arbcomm, l_arbcomm_size));
               -- Suppression des historiques arbitré les plus anciens si plus de 5 historiques sont présents
               delete_old_budget_histo(0, p_pid, TO_NUMBER(p_annee));
            END IF;
            
            -- Si la valeur du réestimé est modifiée
            -- ABN - HP PPM 61299
			-- FAD PPM 64587 : Conversion des deux valeurs bud_rst en NUMBER avant de faire le test
            IF (p_annee = l_datdebex AND (TO_NUMBER(RTRIM(LTRIM(nvl(p_bud_rst,0)))) != TO_NUMBER(RTRIM(LTRIM(nvl(l_bud_rst,0))))))
			-- FAD PPM 64587 : Fin
            THEN
              -- TODO EVENTUEL : si l_bud_rst IS NULL and l_reescomm IS NULL et qu'il n'existe pas d'historique d'arbitré, ne pas continuer
              -- (ne pas enregistrer de premier historique vide) 
              
              -- Historisation de l'ancienne valeur du réestimé                  
              insert_budget_histo (1, 
                                  p_pid, 
                                  TO_NUMBER(p_annee), 
                                  recupererValeurReestime(l_bud_rst), 
                                  TO_DATE( TO_CHAR( l_redate, 'DD/MM/YYYY'),'DD/MM/YYYY'), 
                                  l_matricule, 
                                  recupererCommentaireReestime(l_reescomm, l_reescomm_size));
              -- Suppression des historiques réestimé les plus anciens si plus de 5 historiques sont présents
              delete_old_budget_histo(1, p_pid, TO_NUMBER(p_annee));
            END IF ;

            -- 12/08/2009 -YSB : Renseigner le message dans le cas de la mise à jour et loguer la valeure ancienne et nouvelle du budget modifié
            -- 'Proposition de budget modifiée'

            IF RTRIM(LTRIM(nvl(p_reserve,0))) != RTRIM(LTRIM(nvl(l_reserve,0)))   THEN
                  --YNI Modification des lignes FDT 892
                  Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Proposé réservé ' || p_annee, l_reserve,p_reserve, 'Modification via IHM');
                  Pack_Global.recuperer_message( 3013, NULL, NULL, NULL, l_msg);
                  l_msg2 := l_msg;
            END IF;

            IF RTRIM(LTRIM(nvl(p_bud_prop,0))) != RTRIM(LTRIM(nvl(l_bud_prop,0)))   THEN
                  Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Proposé fournisseur ' || p_annee, l_bud_prop,p_bud_prop, 'Modification via IHM');
                  Pack_Global.recuperer_message( 3008, NULL, NULL, NULL, l_msg);
                  IF l_msg2 IS NULL THEN
                    l_msg2 := l_msg;
                  ELSE
                    l_msg2 := l_msg2 || '\n' || l_msg;
                  END IF;
            END IF;

        IF RTRIM(LTRIM(nvl(p_bud_propmo,0))) != RTRIM(LTRIM(nvl(l_bud_propmo,0))) THEN
                  Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Proposé client ' || p_annee, l_bud_propmo,p_bud_propmo, 'Modification via IHM');
                  Pack_Global.recuperer_message( 3016, NULL, NULL, NULL, l_msg);
                  IF l_msg2 IS NULL THEN
                    l_msg2 := l_msg;
                  ELSE
                    l_msg2 := l_msg2 || '\n' || l_msg;
                  END IF;
        END IF;


        IF (RTRIM(LTRIM(nvl(p_bud_not,0))) != RTRIM(LTRIM(nvl(l_bud_not,0)))) THEN
            -- Renseigner le message dans le cas de la mise à jour
            -- 'Notification de budget modifiée.'
                Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Notifié ' || p_annee, l_bud_not,p_bud_not, 'Modification via IHM');
                Pack_Global.recuperer_message( 3010, NULL, NULL, NULL, l_msg);
                IF l_msg2 IS NULL THEN
                       l_msg2 := l_msg;
                ELSE
                       l_msg2 := l_msg2 || '\n' || l_msg;
                END IF;
        END IF;


       IF ( RTRIM(LTRIM(nvl(p_bud_arb,0))) != RTRIM(LTRIM(nvl(l_bud_arb,0))) ) THEN
             -- 'Notification Arbitrage modifiée.'
                Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Arbitré ' || p_annee, l_bud_arb,p_bud_arb, 'Modification via IHM');
                Pack_Global.recuperer_message( 3012, NULL, NULL, NULL, l_msg);

                IF l_msg2 IS NULL THEN
                       l_msg2 := l_msg;
                ELSE
                       l_msg2 := l_msg2 || '\n' || l_msg;
                END IF;
       END IF;
       
       IF nvl(p_arbcomm,'-') != nvl(l_arbcomm,'-') THEN
             -- 'Notification Commentaire arbitré modifié.'
                -- On ne met pas à jour LIGNE_BIP_LOG car la donnee message peut atteindre 200 caractères
                -- Récupération du message
                Pack_Global.recuperer_message( 21264, NULL, NULL, NULL, l_msg);

                IF l_msg2 IS NULL THEN
                       l_msg2 := l_msg;
                ELSE
                       l_msg2 := l_msg2 || '\n' || l_msg;
                END IF;
       END IF;


       -- ABN - HP PPM 61299
	   -- FAD PPM 64587 : Conversion des deux valeurs bud_rst en NUMBER avant de faire le test
       IF (p_annee = l_datdebex AND (TO_NUMBER(RTRIM(LTRIM(nvl(p_bud_rst,0)))) != TO_NUMBER(RTRIM(LTRIM(nvl(l_bud_rst,0)))))) THEN
	   -- FAD PPM 64587 : Fin
        -- Réestimation du projet modifié
             Pack_Ligne_Bip.maj_ligne_bip_logs(p_pid, l_user, 'Réestimé  ' || p_annee, l_bud_rst,p_bud_rst, 'Modification via IHM');
             Pack_Global.recuperer_message( 3014, NULL, NULL, NULL, l_msg);

             IF l_msg2 IS NULL THEN
                   l_msg2 := l_msg;
             ELSE
                   l_msg2 := l_msg2 || '\n' || l_msg;
             END IF;
        END IF;

       IF (p_annee = l_datdebex AND nvl(p_reescomm,'-') != nvl(l_reescomm,'-')) THEN
             -- 'Notification Commentaire réestimé modifié.'
                -- On ne met pas à jour LIGNE_BIP_LOG car la donnee message peut atteindre 200 caractères
                -- Récupération du message
                Pack_Global.recuperer_message( 21267, NULL, NULL, NULL, l_msg);

                IF l_msg2 IS NULL THEN
                       l_msg2 := l_msg;
                ELSE
                       l_msg2 := l_msg2 || '\n' || l_msg;
                END IF;
       END IF;

            p_message := l_msg2;

         END IF;
      END IF;
   END update_gestbudg;

-- Récupération d'un budget
PROCEDURE select_gestbudg ( p_pid         IN LIGNE_BIP.pid%TYPE,
                               p_annee       IN VARCHAR2,
                               p_mode      IN VARCHAR2,
                               p_userid      IN VARCHAR2,
                               p_curGestbudg IN OUT gestbudgCurType,
                               p_annee_sav   OUT VARCHAR2,
                               p_bud_rees    OUT VARCHAR2,
                               p_nbcurseur   OUT INTEGER,
                               p_message     OUT VARCHAR2,
                               p_perimo   OUT VARCHAR2,
                               p_perime   OUT VARCHAR2
                             ) IS
   l_msg           VARCHAR(1024);
   l_result           INTEGER;
   l_datdebex         VARCHAR2(20);
   l_statut         CHAR(1);
   l_date_statut     VARCHAR2(10);
   l_topfer         CHAR(1);
   l_datdeb         VARCHAR2(10);
   l_date_statut_number NUMBER(10);
   l_menu         VARCHAR2(255);
   l_ca_payeur VARCHAR2(255);
   --YNI
   l_codsg LIGNE_BIP.codsg%TYPE;
   l_clicode LIGNE_BIP.clicode%TYPE;
   l_perimo VARCHAR2(1000);
   l_perime VARCHAR2(1000);
   perimo VARCHAR2(1000);
   perime VARCHAR2(1000);
   l_mo_defaut VARCHAR2(20);
   l_exist_mo INTEGER;
   l_exist_me INTEGER;
   -- Libelle du DPG
	  l_libdsg STRUCT_INFO.libdsg%TYPE;
   --YNI
   msg  VARCHAR2(1024);

   BEGIN
      --YNI
      -- CMA 1176 si on est dans le menu client, on utilise perimcli

       l_menu := Pack_Global.lire_globaldata(p_userid).menutil;

        if('MO'=l_menu)then
            l_perimo := pack_global.lire_perimcli(p_userid);
        else
            l_perimo := pack_global.lire_perimo(p_userid);
        end if;

      l_perime := PACK_GLOBAL.lire_globaldata(p_userid).perime;
      l_mo_defaut := PACK_GLOBAL.lire_globaldata(p_userid).direction1;
      p_perimo := '3';
      p_perime := '2';
      perimo := '';
      perime := '';
      --Fin YNI

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';
      SELECT TO_CHAR(DATDEBEX,'YYYY') INTO l_datdebex FROM DATDEBEX;

      -- Récupération du code département/division

      BEGIN
         SELECT codsg,clicode
         INTO   l_codsg,l_clicode
         FROM   LIGNE_BIP
         WHERE  pid = p_pid;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN

            -- 'Identifiant ligne BIP inexistant'

            Pack_Global.recuperer_message( 20504, '%s1', p_pid, 'PID', l_msg);
            RAISE_APPLICATION_ERROR( -20504, l_msg);

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

      -- Vérification habilitation

      l_result := Pack_Global.verifier_habilitation_2( p_userid, l_codsg,l_clicode,p_pid,
                                                     'à accéder aux données de ce projet',
                                                     NULL);
    -- test de la date statut
      IF (p_mode = 'update' AND l_menu <> 'DIR') THEN

    SELECT TO_CHAR(adatestatut,'DD/MM/YYYY'),NVL(astatut,'E'),topfer INTO l_date_statut,l_statut,l_topfer
    FROM LIGNE_BIP WHERE pid = p_pid;

    SELECT TO_NUMBER(TO_CHAR(adatestatut,'YYYY')) INTO l_date_statut_number
    FROM LIGNE_BIP WHERE pid = p_pid;


    SELECT TO_NUMBER(p_annee) INTO l_datdeb FROM dual;
    --raise_application_error(-20000,l_datdeb);
    --p_annee >= annee en cours et <= à l'annee de fermeture
    -- message d'erreur quand < annee en cours -> controle de l'annee
    -- OU > annee de fermeture
    IF ((l_date_statut IS NOT NULL) AND (l_date_statut_number < l_datdeb)) THEN
        RAISE_APPLICATION_ERROR (-20000,'Vous ne pouvez pas modifier la ligne bip ' || p_pid ||
                    ' car son statut est ' || l_statut ||
                    ', son top fermeture est ' || l_topfer ||
                    ' et sa date de statut ou de top fermeture est ' || l_date_statut);
    END IF;
      END IF;


      -- Contrôle de l'année

      IF ( p_mode = 'update'              AND
           p_annee < l_datdebex ) THEN

         -- 'Pas de mise à jour sur les années antérieures'

         Pack_Global.recuperer_message( 20313, NULL, NULL, 'ANNEE', l_msg);
         RAISE_APPLICATION_ERROR( -20313, l_msg);
      END IF;

      -- Test annee > annee courante le champs Budget reestimes ne doit pas etre modifiable.

     IF ( p_mode = 'update'              AND
           p_annee > l_datdebex ) THEN

        --p_bud_rees := 'BUD_REES#<input type="hidden" name="BUD_RST" value="<% BUD_RST %>">';
       p_bud_rees := 'NON';

     ELSE

       --p_bud_rees := 'BUD_REES#<input type="text" size=15 maxlength=15 name="BUD_RST" value="<% BUD_RST %>"OnChange="return VerifierNum(this,13,0);">';
     --  p_bud_rees := '<html:text property="bud_rst" styleClass="input" size="1" maxlength="1" onchange="return VerifierNum(this,13,0);"/>';
     p_bud_rees := 'OUI';
     END IF;


     --YNI
     --recuperation de l'etat de la page selon le perimetre MO

     while (length(l_perimo) != 0 and p_perimo = '3') loop
     if (instr(l_perimo,',') != 0) then
          perimo := substr(l_perimo,0,instr(l_perimo,',')-1);
          l_perimo := substr(l_perimo,instr(l_perimo,',')+1);
     else
        perimo := l_perimo;
        l_perimo := '';
     end if;

     IF (l_mo_defaut = '88888' AND perimo = '099988888') THEN
        p_perimo := '1';
     ELSE
       select count(*) into l_exist_mo from ligne_bip
         where pid = p_pid
         AND clicode in (select clicode from vue_clicode_perimo where INSTR(perimo,BDCLICODE)>0);

       IF(l_exist_mo != 0) THEN
          p_perimo := '2';
       ELSE
          p_perimo := '3';
       END IF;
     END IF;
     --insert into test_message message values ('p_perimo : '||p_perimo||' perimo '||perimo||' l_perimo '||l_perimo);

     END LOOP;


     --recuperation de l'etat de la page selon le perimetre ME
     while (length(l_perime) != 0 and p_perime = '2') loop
     if (instr(l_perime,',') != 0) then
          perime := substr(l_perime,0,instr(l_perime,',')-1);
          l_perime := substr(l_perime,instr(l_perime,',')+1);
     else
        perime := l_perime;
        l_perime := '';
     end if;

     select count(*) into l_exist_me from ligne_bip
     where pid = p_pid
     AND codsg in (select codsg from vue_dpg_perime where INSTR(perime,codbddpg)>0);

    IF (l_exist_me != 0) THEN
          p_perime := '1';
    ELSE
          p_perime := '2';
    END IF;
	
    --insert into test_message message values ('p_perime : '||p_perime||' perime '||perime||' l_perime '||l_perime);
    END LOOP;
	-- FAD PPM 64713 : Anno 2
	-- OEL QC 1391
	IF(p_mode != 'update' AND 'ME'=l_menu AND p_perime = '2') THEN
         -- Vous n'êtes pas autorisé à consulter cette ligne BIP, son DPG est
        Pack_Global.recuperer_message(20365, '%s1',  'consulter cette ligne BIP, son DPG est '||l_codsg, 'PID', msg);
        RAISE_APPLICATION_ERROR(-20365, msg);
	END IF;
	-- OEL QC 1391 - END MODIF
	-- FAD PPM 64713 : Fin Anno 2
    --Fin YNI

    --insert into test_message message values (p_perime);
      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

	  -- ==========================
      -- On récupère le lib du DPG 
      -- ==========================
      
      IF l_codsg IS NOT NULL THEN
              -- On récupère le lib du DPG
              BEGIN
                    SELECT libdsg INTO l_libdsg FROM struct_info
                    WHERE codsg = l_codsg AND topfer='O' AND rownum < 2;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    pack_global.recuperer_message(20925, '%s1', l_codsg, 'codsg', l_msg);
                               raise_application_error(-20925,l_msg);

                WHEN OTHERS THEN
                          -- Message d'alerte Problème avec le libellé du DPG
                          pack_global.recuperer_message(20738, '%s1', l_codsg, 'codsg', l_msg);
                               raise_application_error(-20738,l_msg);
              END;
      ELSE
        -- Initialisation du libelle
        l_libdsg := '';
      END IF;
	  
      OPEN p_curGestbudg FOR
         SELECT lb.pid,
                lb.pnom,
                lb.codsg,
                l_libdsg,
                lb.astatut,
                TO_CHAR( lb.adatestatut, 'DD/MM/YYYY'),
                NVL(budg.annee,TO_NUMBER(p_annee)),
                TO_CHAR(budg.bpmontme, 'FM9999999990D00'),--YNI
                TO_CHAR(budg.bpmontmo, 'FM9999999990D00'),--YNI
                TO_CHAR(budg.bnmont, 'FM9999999990D00'),--YNI
                TO_CHAR(budg.anmont, 'FM9999999990D00'),--YNI
                TO_CHAR( budg.reserve, 'FM9999999990D00'),--YNI
                DECODE(p_annee, TO_CHAR(DATDEBEX.DATDEBEX, 'YYYY'), TO_CHAR(budg.reestime, 'FM9999999990D00'), NULL),--YNI
                NVL(budg.flaglock,-1),
                TO_CHAR( budg.BPDATE, 'DD/MM/YYYY'),
                TO_CHAR( budg.BPMEDATE, 'DD/MM/YYYY'),
                TO_CHAR( budg.BNDATE, 'DD/MM/YYYY'),
                TO_CHAR( budg.REDATE, 'DD/MM/YYYY'),
                TO_CHAR( budg.bresdate, 'DD/MM/YYYY'),
                budg.UBPMONTME,
                budg.UBPMONTMO,
                budg.UBNMONT,
                budg.UANMONT,
                budg.UREESTIME,
                budg.ureserve,
                budg.arbcomm,
                budg.reescomm,
                TO_CHAR( budg.APDATE, 'DD/MM/YYYY')
         FROM   LIGNE_BIP lb,
                BUDGET budg, DATDEBEX
         WHERE  lb.pid       =   p_pid
          AND   lb.pid       =   budg.pid  (+)
      AND   budg.annee (+)= TO_NUMBER(p_annee);

      -- Récupération des paramètres OUT

      p_annee_sav := SUBSTR( p_annee, 1, 4);


   -- p_annee_sav := 'ANNEE_SAISIE#' ||  SUBSTR(p_annee, 1, 4);

      -- en cas absence
      -- p_message := 'Identifiant ligne BIP inexistant';
      -- Ce message est utilisé comme message APPLICATIF et
      -- message d'exception. => Il porte un numéro d'EXCEPTION

      Pack_Global.recuperer_message( 20735, NULL, NULL, NULL, l_msg);
      p_message := l_msg;

   END select_gestbudg;

-- Récupération de la valeur de l'arbitré
FUNCTION recupererValeurArbitre(p_bud_arb IN VARCHAR2) RETURN NUMBER IS
  p_result NUMBER;
  BEGIN
    SELECT DECODE(''||p_bud_arb||'',',00',NULL, TO_NUMBER(''||p_bud_arb||''))
    INTO p_result
    FROM DUAL;
  return p_result;
END recupererValeurArbitre;

-- Récupération de la valeur du réestimé
FUNCTION recupererValeurReestime (p_bud_rst IN VARCHAR2) RETURN NUMBER IS
  p_result NUMBER;
  BEGIN
    SELECT TO_NUMBER(''||p_bud_rst||'')
    INTO p_result
    FROM DUAL;
  return p_result;
END recupererValeurReestime;

-- Récupération de la valeur du commentaire arbitré
FUNCTION recupererCommentaireArbitre (p_arbcomm IN VARCHAR2, p_arbcomm_size IN INTEGER) RETURN VARCHAR2 IS
  p_commentaire_arbitre BUDGET.arbcomm%TYPE;
  BEGIN
    SELECT DECODE(''||p_arbcomm||'', NULL, null, ''||substr(p_arbcomm,0,TO_CHAR(p_arbcomm_size))||'')
    INTO p_commentaire_arbitre
    FROM DUAL;
  return p_commentaire_arbitre;
END recupererCommentaireArbitre;

-- Récupération de la valeur du commentaire réestimé
-- Utilisé dans PACK_GESTBUDG, PACK_REES_BIP et PACK_REESTIMES_MASS
FUNCTION recupererCommentaireReestime(p_reescomm IN VARCHAR2, p_reescomm_size IN INTEGER) RETURN VARCHAR2 IS
  p_commentaire_reestime budget.reescomm%TYPE;
  BEGIN 
    SELECT DECODE(''||p_reescomm||'', NULL, null, ''||substr(p_reescomm,0,TO_CHAR(p_reescomm_size))||'')
    INTO p_commentaire_reestime
    FROM DUAL;
  return p_commentaire_reestime;
END recupererCommentaireReestime;

-- Insertion d'un historique de budget arbitré / réestimé
-- Utilisé dans PACK_GESTBUDG, PACK_REES_BIP et PACK_REESTIMES_MASS
PROCEDURE insert_budget_histo (p_type_histo IN BUDGET_HISTO.TYPE_HISTO%TYPE,
                                p_pid IN BUDGET_HISTO.PID%TYPE,
                                p_annee IN BUDGET_HISTO.ANNEE%TYPE,
                                p_valeur IN BUDGET_HISTO.VALEUR%TYPE,
                                p_date_modif IN BUDGET_HISTO.DATE_MODIF%TYPE,
                                p_matricule IN BUDGET_HISTO.MATRICULE%TYPE,
                                p_commentaire IN BUDGET_HISTO.COMMENTAIRE%TYPE
                                  ) IS
                                  
   BEGIN
      INSERT INTO BUDGET_HISTO (ID_BUDGET_HISTO, TYPE_HISTO, PID, ANNEE, VALEUR, DATE_MODIF, MATRICULE, COMMENTAIRE)
      VALUES (SEQ_BUDGET_HISTO.nextval, p_type_histo, p_pid, p_annee, p_valeur, p_date_modif, p_matricule, p_commentaire);
      
END insert_budget_histo;

-- Suppression des historiques les plus anciens si plus de 5 historiques sont présents
-- Utilisé dans PACK_GESTBUDG, PACK_REES_BIP et PACK_REESTIMES_MASS
PROCEDURE delete_old_budget_histo (p_type_histo IN BUDGET_HISTO.TYPE_HISTO%TYPE,
                                p_pid IN BUDGET_HISTO.PID%TYPE,
                                p_annee IN BUDGET_HISTO.ANNEE%TYPE) IS

   BEGIN
      DELETE 
        FROM BUDGET_HISTO 
        WHERE TYPE_HISTO = p_type_histo
              AND PID = p_pid
              AND ANNEE = p_annee
              AND ID_BUDGET_HISTO NOT IN
                  (SELECT ID_BUDGET_HISTO 
                    FROM (SELECT ID_BUDGET_HISTO 
                          FROM BUDGET_HISTO
                          WHERE (TYPE_HISTO = p_type_histo
                                AND PID = p_pid
                                AND ANNEE = p_annee)
                                ORDER BY ID_BUDGET_HISTO DESC) 
                    WHERE ROWNUM <= 5
                  );
          

END delete_old_budget_histo;

-- Récupération d'un budget arbitré et de son historique
PROCEDURE select_gestbudg_histo_arb ( p_pid       IN LIGNE_BIP.pid%TYPE,
									p_annee       IN VARCHAR2,
									p_userid      IN VARCHAR2,
									p_curGestbudgHistoArb IN OUT gestbudgHistoArbCurType,
									p_curBudgetHisto IN OUT budgHistoCurType,
									p_message     OUT VARCHAR2
                             ) IS
   l_msg        VARCHAR(1024);
   -- Résultat de la vérification d'habilitation
   l_result     INTEGER;
   -- Code du DPG
   l_codsg LIGNE_BIP.codsg%TYPE;
   l_clicode LIGNE_BIP.clicode%TYPE;
   -- Libelle du DPG
   l_libdsg STRUCT_INFO.libdsg%TYPE;

   BEGIN
	  l_msg := '';
      -- Initialiser le message retour
      p_message := '';

      -- Récupération du code département/division

      BEGIN
         SELECT codsg,clicode
         INTO   l_codsg,l_clicode
         FROM   LIGNE_BIP
         WHERE  pid = p_pid;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            -- 'Identifiant ligne BIP inexistant'
            Pack_Global.recuperer_message( 20504, '%s1', p_pid, 'PID', l_msg);
            RAISE_APPLICATION_ERROR( -20504, l_msg);

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

	  -- Vérification habilitation
      l_result := Pack_Global.verifier_habilitation_2(p_userid,l_codsg,l_clicode,p_pid,
                                                     'à accéder aux données de ce projet',
                                                     NULL);
		  
	  -- ==========================
      -- On récupère le lib du DPG 
      -- ==========================
      IF l_codsg IS NOT NULL THEN
              -- On récupère le lib du DPG
              BEGIN
                    SELECT libdsg INTO l_libdsg FROM struct_info
                    WHERE codsg = l_codsg AND topfer='O' AND rownum < 2;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    pack_global.recuperer_message(20925, '%s1', l_codsg, 'codsg', l_msg);
                               raise_application_error(-20925,l_msg);

                WHEN OTHERS THEN
                          -- Message d'alerte Problème avec le libellé du DPG
                          pack_global.recuperer_message(20738, '%s1', l_codsg, 'codsg', l_msg);
                               raise_application_error(-20738,l_msg);
              END;
      ELSE
        -- Initialisation du libelle
        l_libdsg := '';
      END IF;
	  
      OPEN p_curGestbudgHistoArb FOR
         SELECT 
				-- Code ligne BIP
				lb.pid,
				-- Nom ligne BIP
                lb.pnom,
				-- Code DPG
                lb.codsg,
				-- Libellé DPG
                l_libdsg,
                -- Année
                NVL(budg.annee,TO_NUMBER(p_annee)),
				-- Statut
				lb.astatut,

				-- Budget arbitré notifié
                TO_CHAR(budg.anmont, 'FM9999999990D00'),
				TO_CHAR( budg.apdate, 'DD/MM/YYYY'),
				budg.uanmont,
				budg.arbcomm

         FROM   LIGNE_BIP lb,
                BUDGET budg, DATDEBEX
         WHERE  lb.pid       =   p_pid
          AND   lb.pid       =   budg.pid  (+)
		  AND   budg.annee (+)= TO_NUMBER(p_annee);

	OPEN p_curBudgetHisto FOR
		SELECT	TO_CHAR(valeur, 'FM9999999990D00'), TO_CHAR(date_modif, 'DD/MM/YYYY'), matricule, commentaire
		FROM    BUDGET_HISTO budgh
         WHERE  budgh.type_histo = 0
          AND	budgh.pid    = p_pid
          AND   budgh.annee  = p_annee
          ORDER BY budgh.id_budget_histo DESC;
		  
	p_message := l_msg;

END select_gestbudg_histo_arb;

-- Récupération d'un budget réestimé et de son historique
PROCEDURE select_gestbudg_histo_rees ( p_pid       IN LIGNE_BIP.pid%TYPE,
									p_annee       IN VARCHAR2,
									p_userid      IN VARCHAR2,
									p_curGestbudgHistoRees IN OUT gestbudgHistoReesCurType,
									p_curBudgetHisto IN OUT budgHistoCurType,
									p_message     OUT VARCHAR2
                             ) IS
   l_msg        VARCHAR(1024);
   -- Résultat de la vérification d'habilitation
   l_result     INTEGER;
   -- Code du DPG
   l_codsg LIGNE_BIP.codsg%TYPE;
   l_clicode LIGNE_BIP.clicode%TYPE;
   -- Libelle du DPG
   l_libdsg STRUCT_INFO.libdsg%TYPE;

   BEGIN
	  l_msg := '';
      -- Initialiser le message retour
      p_message := '';

      -- Récupération du code département/division

      BEGIN
         SELECT codsg,clicode
         INTO   l_codsg,l_clicode
         FROM   LIGNE_BIP
         WHERE  pid = p_pid;

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            -- 'Identifiant ligne BIP inexistant'
            Pack_Global.recuperer_message( 20504, '%s1', p_pid, 'PID', l_msg);
            RAISE_APPLICATION_ERROR( -20504, l_msg);

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

	  -- Vérification habilitation
      l_result := Pack_Global.verifier_habilitation_2(p_userid,l_codsg,l_clicode,p_pid,
                                                     'à accéder aux données de ce projet',
                                                     NULL);
		  
	  -- ==========================
      -- On récupère le lib du DPG 
      -- ==========================
      IF l_codsg IS NOT NULL THEN
              -- On récupère le lib du DPG
              BEGIN
                    SELECT libdsg INTO l_libdsg FROM struct_info
                    WHERE codsg = l_codsg AND topfer='O' AND rownum < 2;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    pack_global.recuperer_message(20925, '%s1', l_codsg, 'codsg', l_msg);
                               raise_application_error(-20925,l_msg);

                WHEN OTHERS THEN
                          -- Message d'alerte Problème avec le libellé du DPG
                          pack_global.recuperer_message(20738, '%s1', l_codsg, 'codsg', l_msg);
                               raise_application_error(-20738,l_msg);
              END;
      ELSE
        -- Initialisation du libelle
        l_libdsg := '';
      END IF;
	  
      OPEN p_curGestbudgHistoRees FOR
         SELECT 
				-- Code ligne BIP
				lb.pid,
				-- Nom ligne BIP
                lb.pnom,
				-- Code DPG
                lb.codsg,
				-- Libellé DPG
                l_libdsg,
                -- Année
                NVL(budg.annee,TO_NUMBER(p_annee)),
				-- Statut
				lb.astatut,

				-- Budget réestimé : soit l'année DATDEDEX soit NULL
                DECODE(p_annee, TO_CHAR(DATDEBEX.datdebex, 'YYYY'), TO_CHAR(budg.reestime, 'FM9999999990D00'), NULL),
                TO_CHAR( budg.redate, 'DD/MM/YYYY'),
				budg.ureestime,
				budg.reescomm
                
         FROM   LIGNE_BIP lb,
                BUDGET budg, DATDEBEX
         WHERE  lb.pid       =   p_pid
          AND   lb.pid       =   budg.pid  (+)
		  AND   budg.annee (+)= TO_NUMBER(p_annee);

	OPEN p_curBudgetHisto FOR
		SELECT	TO_CHAR(valeur, 'FM9999999990D00'), TO_CHAR(date_modif, 'DD/MM/YYYY'), matricule, commentaire
		FROM    BUDGET_HISTO budgh
         WHERE  budgh.type_histo = 1
          AND	budgh.pid    = p_pid
          AND   budgh.annee  = p_annee
          ORDER BY budgh.id_budget_histo DESC;
      
	p_message := l_msg;

END select_gestbudg_histo_rees;

END Pack_Gestbudg;
/


