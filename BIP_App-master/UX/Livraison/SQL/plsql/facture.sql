-- pack_facture  PL/SQL
--
-- equipe SOPRA
--
-- POUR LA GESTION DES FACTURES
--    Procedure : SELECT_FACTURE
--                INSERT_FACTURE
--                UPDATE_FACTURE
--                DELETE_UPDATE
--                controle_champ
-- Quand    Qui   Quoi
-- -----    ---   ----------------------------------------------------------------------------------------
-- 18/01/00 QHL   ajout champ FENRCOMPTA=FDATSAI=sysdate lors de insert_facture.
-- 19/04/00 QHL   a la demande de Mme Daire, on n'accepte l'unicité de la facture que sur Socfact + Numfact + Typfact
--                donc le controle d'existence ne tient pas compte de la date de facture.(select_facture - Créer)
-- 26/05/00 NCM  ajout du message d'erreur 20325  lorsque la société est fermée
-- 17/07/00 NCM  update_facture : le code user ne doit pas changé, c'est le code user d'origine, il ne doit pas
--			être remplacé par le code user qui modifie la facture
-- 20/12/2000 (NCM) : Gestion des habilitations suivant appartenance au centre de frais
--			le centre de frais est récupéré par la variable globale
--			=>inconvénient : si un utilisateur est affecté à un autre centre de frais,
--			la modification n'est prise en compte qu'à la prochaine connexion de l'utilisateur
--			-Tester les DPG fermés (création et modification)
-- 09/01/2001 NBM  : modification d'une facture si statut CS1=AE ou SE ou IN ou EN
-- 12/06/2003 Pierre JOSSE : Modification du format de DPG et migration vers le RTFE.
-- 30/06/2006 (PPR) : enlève la référence à histo_facture
-- 28/08/2007 BPO : Ajout du numéro Expense (Fiche TD 582)
-- 29/01/2008 EVI : Verification si statut correspond au périmétre expense
-- 30/05/2008 ABA : ajout du cusag expense (fiche td 595)
-- 26/08/2008 ABA : TD 615 affichage sur statut cs1 par defaut en fonction du permeitre du contrat
-- 22/10/2008 EVI :  TD  695 
-- 23/02/2009 ABA :  TD  750 
-- 10/04/2009 EVI :  TD  783 ORDONNANCEMENT - Saisie facture sur SSII fermée - Menu supach 
-- 17/04/2009 EVI : TD737 augmentation de la taille du numero de contrat + avenant 27+3
-- 03/11/2009 YNI : TD784 Offrir la possibilité d’interroger une facture à partir du code Expense. 
-- ***********************************************************************************
create or replace
PACKAGE     pack_facture
AS
   TYPE factrectype IS RECORD (
      soclib           societe.soclib%TYPE,
      socfact          facture.socfact%TYPE,
      numfact          facture.numfact%TYPE,
      typfact          facture.typfact%TYPE,
      datfact          VARCHAR2 (20),
      fmoiacompta      VARCHAR2 (20),
      fmontht          VARCHAR2 (20),
      fstatut1         facture.fstatut1%TYPE,
      flaglock         VARCHAR2 (20),
      soccont          facture.soccont%TYPE,
      cav              facture.cav%TYPE,
      numcont          facture.numcont%TYPE,
      fenrcompta       VARCHAR2 (20),
      faccsec          VARCHAR2 (20),
      fregcompta       VARCHAR2 (20),
      date_reception   VARCHAR2 (20),
      fenvsec          VARCHAR2 (20),               -- date reglement demande
      fcodcompta       VARCHAR2 (20),
      fsocfour         facture.fsocfour%TYPE,
      fdeppole         VARCHAR2 (20),
      num_expense      facture.num_expense%TYPE,                     -- TD 582
      cusag_expense      VARCHAR2 (20),                   -- TD 595
      siren            CONTRAT.SIREN%TYPE
   );

   TYPE viderec IS RECORD (
      filcode   filiale_cli.filcode%TYPE
   );

   TYPE factcurtype IS REF CURSOR
      RETURN factrectype;

   TYPE selectcurvide IS REF CURSOR
      RETURN viderec;

   PROCEDURE controle_champ (
      c_daterecp     IN   VARCHAR2,                          -- date reception
      c_fdeppole     IN   VARCHAR2,             -- code fdeppole de la facture
      c_fcodcompta   IN   VARCHAR2,                          -- code comptable
      c_fstatut1     IN   VARCHAR2                              -- code statut
   );



   PROCEDURE verif_filiale_cont (
      c_soccont        IN       facture.soccont%TYPE,               -- Societe
      c_cav            IN       facture.cav%TYPE,                   -- Avenant
      c_numcont        IN       facture.numcont%TYPE,        -- Numero Contrat
      c_filcode        IN       contrat.filcode%TYPE,          -- code filiale
      c_msg_typecont   OUT      VARCHAR2,
      c_codsgout       OUT      VARCHAR2,
      c_comcodeout     OUT      VARCHAR2
   );
   PROCEDURE insert_facture (
      p_socfact       IN       facture.socfact%TYPE,
      p_soclib        IN       societe.soclib%TYPE,
      p_numcont       IN       facture.numcont%TYPE,
      p_cav           IN       facture.cav%TYPE,
      p_numfact       IN       facture.numfact%TYPE,
      p_typfact       IN       facture.typfact%TYPE,
      p_datfact       IN       VARCHAR2,
      p_datrecp       IN       VARCHAR2,      -- date reception + 30 = fenvsec
      p_fsocfour      IN       facture.fsocfour%TYPE,
      p_fdeppole      IN       VARCHAR2,        -- code fdeppole de la facture
      p_codsg         IN       VARCHAR2,           -- code fdeppole du contrat
      p_fcodcompta    IN       VARCHAR2,
      p_comcode       IN       VARCHAR2,          -- code comptable du contrat
      p_fstatut1      IN       facture.fstatut1%TYPE,
      p_fmoiacompta   IN       VARCHAR2,
      p_userid        IN       VARCHAR2,
      p_numexpense    IN       VARCHAR2,                             -- TD 582
      p_cusagexpense  IN       VARCHAR2,
      p_nbcurseur     OUT      INTEGER,
      p_message       OUT      VARCHAR2
   );

   PROCEDURE update_facture (
      p_socfact       IN       facture.socfact%TYPE,
      p_soclib        IN       societe.soclib%TYPE,
      p_numcont       IN       facture.numcont%TYPE,
      p_cav           IN       facture.cav%TYPE,
      p_numfact       IN       facture.numfact%TYPE,
      p_typfact       IN       facture.typfact%TYPE,
      p_datfact       IN       VARCHAR2,
      p_datrecp       IN       VARCHAR2,      -- date reception + 30 = fenvsec
      p_fsocfour      IN       facture.fsocfour%TYPE,
      p_fdeppole      IN       VARCHAR2,        -- code fdeppole de la facture
      p_codsg         IN       VARCHAR2,           -- code fdeppole du contrat
      p_fcodcompta    IN       VARCHAR2,
      p_comcode       IN       VARCHAR2,          -- code comptable du contrat
      p_fstatut1      IN       facture.fstatut1%TYPE,
      p_fmoiacompta   IN       VARCHAR2,
      p_flaglock      IN       VARCHAR2,
      p_userid        IN       VARCHAR2,
      p_numexpense    IN       VARCHAR2,                             -- TD 582
      p_cusagexpense  IN       VARCHAR2,                               -- TD 595
      p_nbcurseur     OUT      INTEGER,
      p_message       OUT      VARCHAR2
   );

   PROCEDURE delete_facture (
      p_socfact      IN       facture.socfact%TYPE,
      p_soclib       IN       societe.soclib%TYPE,
      p_numfact      IN       facture.numfact%TYPE,
      p_typfact      IN       facture.typfact%TYPE,
      p_datfact      IN       VARCHAR2,
      p_fmontht      IN       VARCHAR2,
      p_fenrcompta   IN       VARCHAR2,               -- date envoi enr compta
      p_faccsec      IN       VARCHAR2,                    -- date accord pole
      p_fregcompta   IN       VARCHAR2,               -- date reglement compta
      p_fenvsec      IN       VARCHAR2,              -- date reglement demande
      p_flaglock     IN       VARCHAR2,
      p_userid       IN       VARCHAR2,
      p_nbcurseur    OUT      INTEGER,
      p_message      OUT      VARCHAR2
   );

   PROCEDURE select_facture (
      p_mode          IN       VARCHAR2,
      p_socfact       IN       facture.socfact%TYPE,
      p_numcont       IN       facture.numcont%TYPE,
      p_rnom          IN       ressource.rnom%TYPE,
      p_numfact       IN       facture.numfact%TYPE,
      p_typfact       IN       facture.typfact%TYPE,
      p_datfact       IN       VARCHAR2,
      p_choixfsc      IN       VARCHAR2,         -- choix facture sans contrat
      p_userid        IN       VARCHAR2,
      p_curselect     IN OUT   factcurtype,
      p_socfactout    OUT      VARCHAR2,
      p_soclibout     OUT      VARCHAR2,
      p_numcontout    OUT      VARCHAR2,
      p_cavout        OUT      VARCHAR2,
      p_numfactout    OUT      VARCHAR2,
      p_typfactout    OUT      VARCHAR2,
      p_datfactout    OUT      VARCHAR2,
      p_codsgout      OUT      VARCHAR2,
      p_comcodeout    OUT      VARCHAR2,
      p_choixfscout   OUT      VARCHAR2,
      p_ftvaout       OUT      VARCHAR2,
      p_msg_info      OUT      VARCHAR2,
      p_nbcurseur     OUT      INTEGER,
      p_message       OUT      VARCHAR2,
      p_siren         OUT      VARCHAR2
   );
   
   --YNI FDT 784 : methode de recuperation des factures a partir d'un code expense
   PROCEDURE select_facture_expense (
      p_mode          IN       VARCHAR2,
      p_numexpense    IN       facture.NUM_EXPENSE%TYPE,
      p_choixfsc      IN       VARCHAR2,
      p_userid        IN       VARCHAR2,
      p_curselect     IN OUT   factcurtype,
      p_socfactout    OUT      VARCHAR2,
      p_soclibout     OUT      VARCHAR2,
      p_numcontout    OUT      VARCHAR2,
      p_cavout        OUT      VARCHAR2,
      p_numfactout    OUT      VARCHAR2,
      p_typfactout    OUT      VARCHAR2,
      p_datfactout    OUT      VARCHAR2,
      p_codsgout      OUT      VARCHAR2,
      p_comcodeout    OUT      VARCHAR2,
      p_choixfscout   OUT      VARCHAR2,
      p_ftvaout       OUT      VARCHAR2,
      p_msg_info      OUT      VARCHAR2,
      p_nbcurseur     OUT      INTEGER,
      p_message       OUT      VARCHAR2,
      p_siren         OUT      VARCHAR2
   );
   --Fin YNI


      PROCEDURE maj_facture_logs (p_numexpense IN VARCHAR2,
                                p_numfact      IN VARCHAR2,
                               p_socfact    IN VARCHAR2,
                               p_typfact    IN VARCHAR2,
                               p_datfact    IN DATE,
                               p_lnum       IN NUMBER,
                               p_nom_table  VARCHAR2,
                              p_user_log    IN VARCHAR2,
                              p_colonne        IN VARCHAR2,
                              p_valeur_prec    IN VARCHAR2,
                              p_valeur_nouv    IN VARCHAR2,
                              p_commentaire    IN VARCHAR2
                              );



END pack_facture;
/
create or replace
PACKAGE BODY     pack_facture
AS
-- **************************************************************************************
--       Procedure controle date reception et existence du code DPG
-- **************************************************************************************
   PROCEDURE controle_champ (
      c_daterecp     IN   VARCHAR2,                         -- date reception
      c_fdeppole     IN   VARCHAR2,            -- code fdeppole de la facture
      c_fcodcompta   IN   VARCHAR2,                         -- code comptable
      c_fstatut1     IN   VARCHAR2                             -- code statut
   )
   IS
      l_msg        VARCHAR2 (1024);
      l_datejour   DATE;
      l_codsg      struct_info.codsg%TYPE;
      l_comcode    code_compt.comcode%TYPE;
      l_coddir     struct_info.coddir%TYPE;
   BEGIN
-- =======================================
-- Test Date de réception <= date du jour
-- =======================================
      BEGIN
         SELECT SYSDATE
           INTO l_datejour
           FROM DUAL;

         IF l_datejour < TO_DATE (c_daterecp, 'DD/MM/YYYY')
         THEN                          -- msg Date doit inf ou egale date jour
            pack_global.recuperer_message (20108,
                                           NULL,
                                           NULL,
                                           'DATE_RECEPTION',
                                           l_msg
                                          );
            raise_application_error (-20108, l_msg);
         END IF;
      END;

-- ===================================================
-- Test Existence du code DPG dans struct_info.codsg
-- ===================================================
      BEGIN
         SELECT codsg
           INTO l_codsg
           FROM struct_info
          WHERE codsg = TO_NUMBER (c_fdeppole);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN                      -- msg Code Departement/pole/groupe inconnu
            pack_global.recuperer_message (20109,
                                           NULL,
                                           NULL,
                                           'FDEPPOLE',
                                           l_msg
                                          );
            raise_application_error (-20109, l_msg);
         WHEN OTHERS
         THEN
            raise_application_error (-20997, SQLERRM);
      END;

-- ===================================================
-- Test Existence du code comptable dans CODE_COMPT
-- ==================================================
      BEGIN
         SELECT comcode
           INTO l_comcode
           FROM code_compt
          WHERE comcode = c_fcodcompta;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN                                   -- msg Code comptable invalide
            pack_global.recuperer_message (20110,
                                           NULL,
                                           NULL,
                                           'FCODCOMPTA',
                                           l_msg
                                          );
            raise_application_error (-20110, l_msg);
         WHEN OTHERS
         THEN
            raise_application_error (-20997, SQLERRM);
      END;

-- ===================================================
 -- Test si dans perim Expense et code statut CS1 corrct
 -- ===================================================
      BEGIN
         IF c_fstatut1 != 'SE'
         THEN

             SELECT si.coddir
              INTO l_coddir
              FROM struct_info si, directions d
             WHERE si.codsg = TO_NUMBER (c_fdeppole)
             AND si.coddir = d.coddir
             AND d.syscompta not in ('EXP');

         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN                      -- msg Code Departement/pole/groupe inconnu
            pack_global.recuperer_message (21068,
                                           NULL,
                                           NULL,
                                           'FSTATUT1',
                                           l_msg
                                          );
            raise_application_error (-20110, l_msg);
         WHEN OTHERS
         THEN
            raise_application_error (-20997, SQLERRM);
      END;
   END controle_champ;

-- **************************************************************************************

   --       Procedure Verifier la filiale contrat dans tables CONTRAT

   -- **************************************************************************************

   PROCEDURE verif_filiale_cont (
      c_soccont        IN       facture.soccont%TYPE,               -- Societe
      c_cav            IN       facture.cav%TYPE,                   -- Avenant
      c_numcont        IN       facture.numcont%TYPE,        -- Numero Contrat
      c_filcode        IN       contrat.filcode%TYPE,          -- code filiale
      c_msg_typecont   OUT      VARCHAR2,
      c_codsgout       OUT      VARCHAR2,
      c_comcodeout     OUT      VARCHAR2
   )
   IS
      l_filcode          contrat.filcode%TYPE;
      l_codsg            contrat.codsg%TYPE;
      l_comcode          contrat.comcode%TYPE;
      l_flag_nontrouve   BOOLEAN;
      l_msg              VARCHAR2 (512);
   BEGIN
-- ===========================================

      -- Recherche dans table CONTRAT

      -- ===========================================
      BEGIN
         l_flag_nontrouve := FALSE;

         SELECT c.filcode, c.codsg, c.comcode
           INTO l_filcode, l_codsg, l_comcode
           FROM contrat c
          WHERE c.soccont = c_soccont
            AND c.cav = c_cav
            AND c.numcont = c_numcont;

         IF l_filcode <> c_filcode
         THEN
            -- msg La facture existe mais pour une autre filiale
            pack_global.recuperer_message (20106, NULL, NULL, NULL, l_msg);
            raise_application_error (-20106, l_msg);
         ELSE                               -- Contrat Recent : pas de message
            c_msg_typecont := '';
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            -- msg Probl facture fait reference a un contrat inexistant
            pack_global.recuperer_message (20107, NULL, NULL, NULL, l_msg);
            raise_application_error (-20107, l_msg);
         WHEN OTHERS
         THEN
            raise_application_error (-20997, SQLERRM);
      END;

      c_codsgout := TO_CHAR (l_codsg, 'FM0000000');
      c_comcodeout := l_comcode;
   END verif_filiale_cont;
-- ********************************************************************************************

   -- ********************************************************************************************

   --

   -- INSERT_FACTURE  : controle eventuel sur le contrat et la filiale fait dans Select_facture

   --

   -- ********************************************************************************************

   -- ********************************************************************************************
   PROCEDURE insert_facture (
      p_socfact       IN       facture.socfact%TYPE,
      p_soclib        IN       societe.soclib%TYPE,
      p_numcont       IN       facture.numcont%TYPE,
      p_cav           IN       facture.cav%TYPE,
      p_numfact       IN       facture.numfact%TYPE,
      p_typfact       IN       facture.typfact%TYPE,
      p_datfact       IN       VARCHAR2,
      p_datrecp       IN       VARCHAR2,      -- date reception + 30 = fenvsec
      p_fsocfour      IN       facture.fsocfour%TYPE,
      p_fdeppole      IN       VARCHAR2,        -- code fdeppole de la facture
      p_codsg         IN       VARCHAR2,           -- code fdeppole du contrat
      p_fcodcompta    IN       VARCHAR2,
      p_comcode       IN       VARCHAR2,          -- code comptable du contrat
      p_fstatut1      IN       facture.fstatut1%TYPE,
      p_fmoiacompta   IN       VARCHAR2,
      p_userid        IN       VARCHAR2,
      p_numexpense    IN       VARCHAR2,                                -- TD 582
      p_cusagexpense  IN       VARCHAR2,                               -- TD 595
      p_nbcurseur     OUT      INTEGER,
      p_message       OUT      VARCHAR2
   )
   IS
      l_msg                   VARCHAR2 (1024);
      l_fcoduser              facture.fcoduser%TYPE;
      referential_integrity   EXCEPTION;
      PRAGMA EXCEPTION_INIT (referential_integrity, -2291);
      l_soccont               facture.soccont%TYPE;
      l_cav                   facture.cav%TYPE;
      l_numcont               facture.numcont%TYPE;
      l_llibanalyt            facture.llibanalyt%TYPE;
      l_date                  DATE;
      l_centre_frais          centre_frais.codcfrais%TYPE;
      l_scentrefrais          centre_frais.codcfrais%TYPE;
      l_topfer                struct_info.topfer%TYPE;
   BEGIN
      -- Positionner le nb de curseurs ==> 0

      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';
      -- On recupere le code user (idarpege)
      l_fcoduser := pack_global.lire_globaldata (p_userid).idarpege;
      -- Controle de la Date de réception , du Code DPG , du Code Comptable
      controle_champ (p_datrecp, p_fdeppole, p_fcodcompta, p_fstatut1);

      -- OK pour Creer.  -> a differencier avec contrat ou sans contrat pour construire le

      -- le libellé analytique
      IF p_numcont IS NULL
      THEN
         l_soccont := NULL;
         l_cav := NULL;
         l_numcont := NULL;
         l_date := TO_DATE (p_fmoiacompta, 'MM/YYYY');
         l_llibanalyt :=
            (   RPAD (p_socfact, 4)
             || '-'
             || TO_CHAR (l_date, 'MMYYYY')
             || '-'
             || RPAD (p_numfact, 15)
            );
      ELSE
         l_soccont := p_socfact;
         l_cav := lpad(NVL(p_cav,0),3,'0');
         l_numcont := p_numcont;
         l_date := TO_DATE (p_fmoiacompta, 'MM/YYYY');
         l_llibanalyt :=
            (   RPAD (p_socfact, 4)
             || '-'
             || TO_CHAR (l_date, 'MMYYYY')
             || '-'
             || RPAD (p_numfact, 15)
             || '-'
             || RPAD (p_numcont, 27)
            );
      END IF;

      -- DBMS_output.put_line('p_numcont=' || p_numcont || ' l_llibanalyt=' || l_llibanalyt);

      -- ==========================================================

      -- Test  fermeture DPG

      -- ==========================================================
      BEGIN
         SELECT topfer, scentrefrais
           INTO l_topfer, l_scentrefrais
           FROM struct_info
          WHERE codsg = TO_NUMBER (p_fdeppole);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            pack_global.recuperer_message (20203,
                                           NULL,
                                           NULL,
                                           'FDEPPOLE',
                                           l_msg
                                          );
            raise_application_error (-20203, l_msg);
         WHEN OTHERS
         THEN
            raise_application_error (-20997, SQLERRM);
      END;

      IF l_topfer = 'F'
      THEN
         pack_global.recuperer_message (20274, NULL, NULL, 'FDEPPOLE', l_msg);
         raise_application_error (-20274, l_msg);
      END IF;

-- =====================================================================

      -- Test : appartenance du DPG dans le centre de frais du user

      -- =====================================================================

      -- On récupère le code centre de frais de l'utilisateur
      l_centre_frais := pack_global.lire_globaldata (p_userid).codcfrais;

      IF l_centre_frais != 0
      THEN       -- le centre de frais 0 donne tous les droits à l'utilisateur
         IF (l_scentrefrais IS NULL)
         THEN
            --msg : Le DPG n'est rattaché à aucun centre de frais
            pack_global.recuperer_message (20339,
                                           NULL,
                                           NULL,
                                           'FDEPPOLE',
                                           l_msg
                                          );
            raise_application_error (-20339, l_msg);
         ELSE
            IF (l_scentrefrais != l_centre_frais)
            THEN
               --msg:Ce DPG n'appartient pas à ce centre de frais
               pack_global.recuperer_message (20334,
                                              '%s1',
                                              TO_CHAR (l_centre_frais),
                                              'FDEPPOLE',
                                              l_msg
                                             );
               raise_application_error (-20334, l_msg);
            END IF;
         END IF;
      ELSE
-- l'utilisateur n'est pas affecté à un centre de frais réel: récupérer le centre de frais du DPG
         IF (l_scentrefrais IS NULL)
         THEN
            --msg : Le DPG n'est rattaché à aucun centre de frais
            pack_global.recuperer_message (20339,
                                           NULL,
                                           NULL,
                                           'FDEPPOLE',
                                           l_msg
                                          );
            raise_application_error (-20339, l_msg);
         ELSE
            -- le centre de frais du contrat est le centre de frais du DPG
            l_centre_frais := l_scentrefrais;
         END IF;
      END IF;

      BEGIN
         INSERT INTO facture
                     (socfact, numfact, typfact,
                      datfact, fnumasn, fnumordre,
                      fenvsec,
                      llibanalyt, fmoiacompta,
                      fcoduser, fdatsai, fenrcompta, fstatut1, fsocfour,
                      fcodcompta, fdeppole, flaglock, soccont,
                      cav, numcont, fdatrecep,
                      fcentrefrais, cusag_expense, num_expense                      -- TD 582
                     )
              VALUES (p_socfact, p_numfact, p_typfact,
                      TO_DATE (p_datfact, 'DD/MM/YYYY'), 0,         -- fnumasn
                                                           0,     -- fnumordre
                      (TO_DATE (p_datrecp, 'DD/MM/YYYY') + 30
                      ),
                      l_llibanalyt, TO_DATE (p_fmoiacompta, 'MM/YYYY'),
                      l_fcoduser, SYSDATE, SYSDATE, p_fstatut1, p_fsocfour,
                      p_fcodcompta, TO_NUMBER (p_fdeppole), 0,     -- flaglock
                                                              l_soccont,
                      l_cav, l_numcont, TO_DATE (p_datrecp, 'DD/MM/YYYY'),
                      l_centre_frais, to_number(p_cusagexpense), p_numexpense                   -- TD 582
                     );

         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'NUMCONT',NULL,to_char(l_numcont),'Création du numéro de contrat');
         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'CAV',NULL,to_char(l_cav),'Création du numéro de cav');
         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'NUM_EXPENSE',NULL,to_char(p_numexpense),'Création du numéro expense');
         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'CUSAG_EXPENSE',NULL,to_char(TO_NUMBER(p_cusagexpense,'FM999999D00')),'Création du cusag expense');
         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'FDATRECEP',NULL,p_datrecp,'Création de la date de réception');
         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'FDEPPOLE',NULL,TO_char(to_number(p_fdeppole)),'Création du DPG');
         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'FCODCOMPTA',NULL,TO_char(p_fcodcompta),'Création du code comptable');
         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'SOCFACT',NULL,to_char(p_socfact),'Création du numéro de contrat');
         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'TYPFACT',NULL,to_char(p_typfact),'Création du numéro de cav');
         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'DATFACT',NULL,to_char(p_datfact),'Création du numéro expense');
         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'NUMFACT',NULL,p_numfact,'Création du numéro de facture');



      EXCEPTION
         WHEN referential_integrity
         THEN
            pack_global.recuperation_integrite (-2291);
         WHEN DUP_VAL_ON_INDEX
         THEN
            pack_global.recuperer_message (20111, NULL, NULL, NULL, l_msg);
            raise_application_error (-20111, l_msg);
         WHEN OTHERS
         THEN
            raise_application_error (-20997, SQLERRM);
      END;

      IF SQL%NOTFOUND
      THEN                                                 -- Acces concurrent
         pack_global.recuperer_message (20999, NULL, NULL, NULL, l_msg);
         raise_application_error (-20999, l_msg);
      ELSE                                                -- Msg Facture créée
         pack_global.recuperer_message (2200, '%s1', p_numfact, NULL, l_msg);
      END IF;

        -- TD 695 MAJ automatique des rejet expense lorsque une facture est inséré.
      IF p_numexpense is not null THEN

      UPDATE EBIS_FACT_REJET SET TOP_ETAT='TR' WHERE num_expense = p_numexpense;

      END IF;

      p_message := l_msg;
   END insert_facture;

-- ********************************************************************************************************

   -- ********************************************************************************************************

   --

   -- UPDATE_FACTURE   - possible que si fstatut1 = 'AE' ou 'SE' ou 'IN' déjà contrôlé lors du select_facture

   --

   -- ********************************************************************************************************

   -- ********************************************************************************************************
   PROCEDURE update_facture (
      p_socfact       IN       facture.socfact%TYPE,
      p_soclib        IN       societe.soclib%TYPE,
      p_numcont       IN       facture.numcont%TYPE,
      p_cav           IN       facture.cav%TYPE,
      p_numfact       IN       facture.numfact%TYPE,
      p_typfact       IN       facture.typfact%TYPE,
      p_datfact       IN       VARCHAR2,
      p_datrecp       IN       VARCHAR2,      -- date reception + 30 = fenvsec
      p_fsocfour      IN       facture.fsocfour%TYPE,
      p_fdeppole      IN       VARCHAR2,        -- code fdeppole de la facture
      p_codsg         IN       VARCHAR2,           -- code fdeppole du contrat
      p_fcodcompta    IN       VARCHAR2,
      p_comcode       IN       VARCHAR2,          -- code comptable du contrat
      p_fstatut1      IN       facture.fstatut1%TYPE,
      p_fmoiacompta   IN       VARCHAR2,
      p_flaglock      IN       VARCHAR2,
      p_userid        IN       VARCHAR2,
      p_numexpense    IN       VARCHAR2,                             -- TD 582
      p_cusagexpense  IN       VARCHAR2,                             -- TD 595
      p_nbcurseur     OUT      INTEGER,
      p_message       OUT      VARCHAR2
   )
   IS
      l_msg                   VARCHAR2 (1024);
      p_filcode               filiale_cli.filcode%TYPE;
      referential_integrity   EXCEPTION;
      PRAGMA EXCEPTION_INIT (referential_integrity, -2291);
      l_soccont               facture.soccont%TYPE;
      l_cav                   facture.cav%TYPE;
      l_numcont               facture.numcont%TYPE;
      l_llibanalyt            facture.llibanalyt%TYPE;
      l_fcoduser              facture.fcoduser%TYPE;
      l_date                  DATE;
      l_codsg                 contrat.codsg%TYPE;
      l_comcode               contrat.comcode%TYPE;
      l_siren                 contrat.siren%TYPE;
      l_msg_cont              VARCHAR2 (512);
      l_topfer                struct_info.topfer%TYPE;
      l_centre_frais          centre_frais.codcfrais%TYPE;
      l_scentrefrais          centre_frais.codcfrais%TYPE;

      old_numcont            facture.numcont%TYPE;
      old_cav                facture.cav%TYPE;
      old_num_expense          VARCHAR2(8);
      old_cusag_expense         NUMBER;
      old_dfatrecep        DATE;
      old_fdeppole          NUMBER;
      old_fcodcompta       VARCHAR2(11);






   BEGIN
      -- Positionner le nb de curseurs ==> 0

      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';
      l_msg_cont := '';
      -- Controle de la Date de réception , du Code DPG , du Code Comptable
      controle_champ (p_datrecp, p_fdeppole, p_fcodcompta, p_fstatut1);
      --  On recupere le code filiale de l'utilisateur
      p_filcode := pack_global.lire_globaldata (p_userid).filcode;
      -- On recupere le code user (idarpege)
      l_fcoduser := pack_global.lire_globaldata (p_userid).idarpege;

      -- Controle filiale du N° contrat et N° Avenant si present

      -- -> a differencier Facture avec contrat ou sans contrat pour construire le libellé analytique
      IF p_numcont IS NOT NULL
      THEN
         BEGIN
            l_cav := lpad(NVL(p_cav,0),3,'0');
            verif_filiale_cont (p_socfact,
                                l_cav,
                                p_numcont,
                                p_filcode,
                                l_msg_cont,
                                l_codsg,
                                l_comcode
                               );
            l_soccont := p_socfact;
            l_numcont := p_numcont;
            l_date := TO_DATE (p_fmoiacompta, 'MM/YYYY');
            l_llibanalyt :=
               (   RPAD (p_socfact, 4)
                || '-'
                || TO_CHAR (l_date, 'MMYYYY')
                || '-'
                || RPAD (p_numfact, 15)
                || '-'
                || RPAD (p_numcont, 27)
               );
         END;
      ELSE
         BEGIN
            l_soccont := NULL;
            l_cav := NULL;
            l_numcont := NULL;
            l_date := TO_DATE (p_fmoiacompta, 'MM/YYYY');
            l_llibanalyt :=
               (   RPAD (p_socfact, 4)
                || '-'
                || TO_CHAR (l_date, 'MMYYYY')
                || '-'
                || RPAD (p_numfact, 15)
               );
         END;
      END IF;

-- ==========================================================

      -- Test existence et fermeture DPG

      -- ==========================================================
      BEGIN
         SELECT topfer, scentrefrais
           INTO l_topfer, l_scentrefrais
           FROM struct_info
          WHERE codsg = TO_NUMBER (p_fdeppole);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            pack_global.recuperer_message (20203,
                                           NULL,
                                           NULL,
                                           'FDEPPOLE',
                                           l_msg
                                          );
            raise_application_error (-20203, l_msg);
         WHEN OTHERS
         THEN
            raise_application_error (-20997, SQLERRM);
      END;

      IF l_topfer = 'F'
      THEN
         pack_global.recuperer_message (20274, NULL, NULL, 'FDEPPOLE', l_msg);
         raise_application_error (-20274, l_msg);
      END IF;

-- =====================================================================

      -- Test : appartenance du DPG dans le centre de frais du user

      -- =====================================================================

      -- On récupère le code centre de frais de l'utilisateur
      l_centre_frais := pack_global.lire_globaldata (p_userid).codcfrais;

      IF l_centre_frais != 0
      THEN       -- le centre de frais 0 donne tout les droits à l'utilisateur
         IF (l_scentrefrais IS NULL)
         THEN
            --msg : Le DPG n'est rattaché à aucun centre de frais
            pack_global.recuperer_message (20339,
                                           NULL,
                                           NULL,
                                           'FDEPPOLE',
                                           l_msg
                                          );
            raise_application_error (-20339, l_msg);
         ELSE
            IF (l_scentrefrais != l_centre_frais)
            THEN
               --msg:Ce DPG n'appartient pas à ce centre de frais
               pack_global.recuperer_message (20334,
                                              '%s1',
                                              TO_CHAR (l_centre_frais),
                                              'FDEPPOLE',
                                              l_msg
                                             );
               raise_application_error (-20334, l_msg);
            END IF;
         END IF;
      ELSE
-- l'utilisateur n'est pas affecté à un centre de frais réel: récupérer le centre de frais du DPG
         IF (l_scentrefrais IS NULL)
         THEN
            --msg : Le DPG n'est rattaché à aucun centre de frais
            pack_global.recuperer_message (20339,
                                           NULL,
                                           NULL,
                                           'FDEPPOLE',
                                           l_msg
                                          );
            raise_application_error (-20339, l_msg);
         ELSE
            -- le centre de frais du contrat est le centre de frais du DPG
            l_centre_frais := l_scentrefrais;
         END IF;
      END IF;

      -- OK on peut Modifier
      BEGIN

         SELECT NUMCONT, CAV, NUM_EXPENSE, CUSAG_EXPENSE,  FDATRECEP,   FDEPPOLE,  FCODCOMPTA
         into old_numcont, old_cav, old_num_expense, old_cusag_expense, old_dfatrecep, old_fdeppole, old_fcodcompta
         from facture
         where socfact = p_socfact
            AND numfact = RPAD (p_numfact, 15)
            AND typfact = p_typfact
            AND datfact = TO_DATE (p_datfact, 'DD/MM/YYYY');


         UPDATE facture
            SET fnumasn = 0,
                fnumordre = 0,
                fenvsec = (TO_DATE (p_datrecp, 'DD/MM/YYYY') + 30),
                llibanalyt = l_llibanalyt,
                fmoiacompta = l_date,
                fdatmaj = SYSDATE,
                fstatut1 = p_fstatut1,
                fsocfour = p_fsocfour,
                flaglock = DECODE (p_flaglock, 1000000, 0, p_flaglock + 1),
                fcodcompta = p_fcodcompta,
                fdeppole = TO_NUMBER (p_fdeppole),
                fdatrecep = TO_DATE (p_datrecp, 'DD/MM/YYYY'),
                fcentrefrais = l_centre_frais,
                cusag_expense = to_number(p_cusagexpense),
                num_expense = p_numexpense
          WHERE socfact = p_socfact
            AND numfact = RPAD (p_numfact, 15)
            AND typfact = p_typfact
            AND datfact = TO_DATE (p_datfact, 'DD/MM/YYYY')
            AND flaglock = TO_NUMBER (p_flaglock, 'FM9999999');


         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact),   TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'NUM_EXPENSE',to_char(old_num_expense),to_char(p_numexpense),'Modification du numéro expense');
         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact), TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'CUSAG_EXPENSE',to_char(TO_NUMBER(old_cusag_expense,'FM999999D00')),to_char(TO_NUMBER(p_cusagexpense,'FM999999D00')),'Modification du cusag expense');
         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact),  TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'FDATRECEP',to_char(old_dfatrecep,'DD/MM/YYYY'),p_datrecp,'Modification de la date de réception');
         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact),   TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'FDEPPOLE',to_char(to_number(old_fdeppole)),TO_char(to_number(p_fdeppole)),'Modification du DPG');
         maj_facture_logs(p_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact),  TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE',  l_fcoduser, 'FCODCOMPTA',to_char(old_fcodcompta),TO_char(p_fcodcompta),'Modification du code comptable');


      EXCEPTION
         WHEN referential_integrity
         THEN
            pack_global.recuperation_integrite (-2291);
         WHEN OTHERS
         THEN
            raise_application_error (-20997, SQLERRM);
      END;



      IF SQL%NOTFOUND
      THEN                                                 -- Acces concurrent
         pack_global.recuperer_message (20999, NULL, NULL, NULL, l_msg);
         raise_application_error (-20999, l_msg);
      ELSE

         -- TD 695 MAJ automatique des rejet expense lorsque une facture est inséré.
      IF p_numexpense is not null THEN

      UPDATE EBIS_FACT_REJET SET TOP_ETAT='TR' WHERE num_expense = p_numexpense;

      END IF;
                                                 -- Msg Facture modifiée
         pack_global.recuperer_message (2201, '%s1', p_numfact, NULL, l_msg);
         p_message := l_msg || ' ' || l_msg_cont;
      END IF;
   END update_facture;

-- ********************************************************************************************

   -- ********************************************************************************************

   --

   -- DELETE_FACTURE  :

   --

   -- ********************************************************************************************

   -- ********************************************************************************************
   PROCEDURE delete_facture (
      p_socfact      IN       facture.socfact%TYPE,
      p_soclib       IN       societe.soclib%TYPE,
      p_numfact      IN       facture.numfact%TYPE,
      p_typfact      IN       facture.typfact%TYPE,
      p_datfact      IN       VARCHAR2,
      p_fmontht      IN       VARCHAR2,
      p_fenrcompta   IN       VARCHAR2,               -- date envoi enr compta
      p_faccsec      IN       VARCHAR2,                    -- date accord pole
      p_fregcompta   IN       VARCHAR2,               -- date reglement compta
      p_fenvsec      IN       VARCHAR2,              -- date reglement demande
      p_flaglock     IN       VARCHAR2,
      p_userid       IN       VARCHAR2,
      p_nbcurseur    OUT      INTEGER,
      p_message      OUT      VARCHAR2
   )
   IS
      l_msg                   VARCHAR2 (1024);
      l_numexpense            FACTURE.NUM_EXPENSE%TYPE;
      referential_integrity   EXCEPTION;
      PRAGMA EXCEPTION_INIT (referential_integrity, -2292);
      l_fcoduser              facture.fcoduser%TYPE;

   BEGIN
      -- Positionner le nb de curseurs ==> 0

      -- Initialiser le message retour

      -- l'utilisateur a déjà fait un select pour visualiser avant, ici on est sur que

      -- la facture existe et donc la seule difference ne concernera que le Flaglock
      p_nbcurseur := 0;
      p_message := '';

      l_fcoduser := pack_global.lire_globaldata (p_userid).idarpege;

      -- TD 695 MAJ automatique des rejet expense lorsque une facture est inséré.
      SELECT nvl(num_expense,'0') INTO l_numexpense FROM FACTURE where socfact = p_socfact
                                                          AND numfact = RPAD (p_numfact, 15)
                                                          AND typfact = p_typfact
                                                          AND datfact = TO_DATE (p_datfact, 'DD/MM/YYYY')
                                                          AND flaglock = TO_NUMBER (p_flaglock, 'FM9999999');

      IF l_numexpense !='0' THEN

      UPDATE EBIS_FACT_REJET SET TOP_ETAT='AT' WHERE num_expense = l_numexpense;

      END IF;


      BEGIN
         DELETE FROM facture
               WHERE socfact = p_socfact
                 AND numfact = RPAD (p_numfact, 15)
                 AND typfact = p_typfact
                 AND datfact = TO_DATE (p_datfact, 'DD/MM/YYYY')
                 AND flaglock = TO_NUMBER (p_flaglock, 'FM9999999');

         maj_facture_logs(l_numexpense, to_char(p_numfact), to_char(p_socfact), to_char(p_typfact),  TO_DATE (p_datfact, 'DD/MM/YYYY'), NULL, 'FACTURE,LIGNE_FACT',  l_fcoduser, 'TOUTES',NULL,'VIDE','Suppression de la facture');


      EXCEPTION
         WHEN referential_integrity
         THEN
            pack_global.recuperation_integrite (-2292);
         WHEN OTHERS
         THEN
            raise_application_error (-20997, SQLERRM);
      END;

      IF SQL%NOTFOUND
      THEN                          -- ici ce sera erreur d' Accces concurrent
         pack_global.recuperer_message (20999, NULL, NULL, NULL, l_msg);
         raise_application_error (-20999, l_msg);
      ELSE                                               --  Facture supprimée
         pack_global.recuperer_message (2202, '%s1', p_numfact, NULL, l_msg);
         p_message := l_msg;
      END IF;
   END delete_facture;

-- ********************************************************************************************

   -- ********************************************************************************************

   --

   -- SELECT_FACTURE

   -- Cas a tester : 1) Bouton Creer (la facture doit etre inexistante)

   --                2) Bouton Modifier ou Supprimer

   --                3) Bouton Lignes

   --

   -- ********************************************************************************************

   -- ********************************************************************************************
   PROCEDURE select_facture (
      p_mode          IN       VARCHAR2,
      p_socfact       IN       facture.socfact%TYPE,
      p_numcont       IN       facture.numcont%TYPE,
      p_rnom          IN       ressource.rnom%TYPE,
      p_numfact       IN       facture.numfact%TYPE,
      p_typfact       IN       facture.typfact%TYPE,
      p_datfact       IN       VARCHAR2,
      p_choixfsc      IN       VARCHAR2,         -- choix facture sans contrat
      p_userid        IN       VARCHAR2,
      p_curselect     IN OUT   factcurtype,
      p_socfactout    OUT      VARCHAR2,
      p_soclibout     OUT      VARCHAR2,
      p_numcontout    OUT      VARCHAR2,
      p_cavout        OUT      VARCHAR2,
      p_numfactout    OUT      VARCHAR2,
      p_typfactout    OUT      VARCHAR2,
      p_datfactout    OUT      VARCHAR2,
      p_codsgout      OUT      VARCHAR2,
      p_comcodeout    OUT      VARCHAR2,
      p_choixfscout   OUT      VARCHAR2,
      p_ftvaout       OUT      VARCHAR2,
      p_msg_info      OUT      VARCHAR2,
      p_nbcurseur     OUT      INTEGER,
      p_message       OUT      VARCHAR2,
      p_siren         OUT      VARCHAR2
   )
   IS
      l_msg            VARCHAR2 (1024);
      l_soclib         societe.soclib%TYPE;
      l_socfact        facture.socfact%TYPE;
      p_filcode        filiale_cli.filcode%TYPE;
      l_centre_frais   centre_frais.codcfrais%TYPE;
      l_fcentrefrais   centre_frais.codcfrais%TYPE;
      l_sousmenus   VARCHAR2(1024);
   BEGIN
      -- Initialiser le message retour
      p_message := '';
      p_socfactout := p_socfact;
      p_numfactout := p_numfact;
      p_datfactout := p_datfact;
      p_typfactout := p_typfact;
      p_choixfscout := p_choixfsc;
      -- initialisation des champs relatifs au contrat pour facture sans contrat

      -- pour Créer facture avec contrat, initialisation par pack_factcont.select_factcont
      p_numcontout := '';
      p_cavout := '';
      p_codsgout := '';
      p_comcodeout := '';
      p_siren := '';
      --DBMS_OUTPUT.PUT_LINE(p_mode || '-;-' || p_socfact || '-;-' || p_numcont || '-;-'

      --  || p_rnom || '-;-' || p_numfact || '-;-' || p_typfact || '-;-' || p_datfact || '-;-'

      --  || p_choixfsc || '-;-' || p_userid || '-;;') ;

      --  On recupere le code filiale de l'utilisateur
      p_filcode := pack_global.lire_globaldata (p_userid).filcode;

      l_sousmenus := Pack_Global.lire_globaldata(p_userid).sousmenus;

-- =======================================================================

      -- Test existence du CODE SOCIETE : on recupere en meme temps son libelle

      -- =======================================================================
      BEGIN
         SELECT soccode, soclib
           INTO l_socfact, l_soclib
           FROM societe
          WHERE soccode = p_socfact;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN                      -- Erreur message "Code Societe inexistant"
            pack_global.recuperer_message (20306, NULL, NULL, NULL, l_msg);
            raise_application_error (-20306, l_msg);
         WHEN OTHERS
         THEN
            raise_application_error (-20997, SQLERRM);
      END;

      -- DBMS_OUTPUT.PUT_LINE('--> après test Code societe : ' || l_socfact || '  ' || l_soclib );
      p_soclibout := l_soclib;

-- =======================================

      -- Test Date de facture <= date du jour

      -- =======================================
      DECLARE
         l_datejour   DATE;
      BEGIN
         SELECT SYSDATE
           INTO l_datejour
           FROM DUAL;

         IF l_datejour < TO_DATE (p_datfact, 'DD/MM/YYYY')
         THEN
            -- a adapter pour le num de message
            pack_global.recuperer_message (20104, NULL, NULL, NULL, l_msg);
            raise_application_error (-20104, l_msg);
         END IF;
      END;

-- ****************************************************************************

      --

      --       Cas   CREER

      --

      -- ****************************************************************************
      IF p_mode = 'insert'
      THEN
         BEGIN
-- ========================

            -- Test SOCIETE FERMEE

            -- ========================
          IF INSTR(l_sousmenus,'supach') = 0 THEN
            BEGIN
               SELECT soccode
                 INTO l_socfact
                 FROM societe
                WHERE soccode = p_socfact AND (socfer IS NULL OR socfer = '');
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
             -- Erreur message "Création impossible, la société n'existe plus"
                  pack_global.recuperer_message (20325,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 l_msg
                                                );
                  raise_application_error (-20325, l_msg);
               WHEN OTHERS
               THEN
                  raise_application_error (-20997, SQLERRM);
            END;
          END IF;

-- ===========================================================

            -- Test de l'existence de la facture dans la table facture

            -- ===========================================================
            BEGIN
               SELECT DISTINCT socfact
                          INTO l_socfact
                          FROM facture
                         WHERE socfact = p_socfact
                           AND numfact = RPAD (p_numfact, 15)
                           AND typfact = p_typfact;
            -- modif 19042000 :  AND datfact = to_date(p_datfact,'DD/MM/YYYY');
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  raise_application_error (-20997, SQLERRM);
            END;

            -- DBMS_OUTPUT.PUT_LINE('Apres select dans facture');
            IF SQL%FOUND
            THEN
               -- Erreur message "La facture existe deja dans facture "
               pack_global.recuperer_message (20101, NULL, NULL, NULL, l_msg);
               raise_application_error (-20101, l_msg);
            END IF;

-- ======================================================================

            -- Curseur VIDE  pour armer p_curselect sinon HTML va se perdre !!!

            -- ======================================================================
            BEGIN
               p_nbcurseur := 0;

               OPEN p_curselect FOR
                  SELECT s.soclib, f.socfact, f.numfact, f.typfact,
                         TO_CHAR (f.datfact, 'dd/mm/yyyy'),
                         TO_CHAR (f.fmoiacompta, 'mm/yyyy'),
                         TO_CHAR (f.fmontht, 'FM99999990D00'), f.fstatut1,
                         TO_CHAR (f.flaglock), f.soccont, DECODE(c.top30,'O',DECODE(f.cav,'000','000',RPAD(f.cav,3)),'N',SUBSTR(f.cav,2,2) ), f.numcont,
                         TO_CHAR (f.fenrcompta, 'dd/mm/yyyy'),
                         TO_CHAR (f.faccsec, 'dd/mm/yyyy'),
                         TO_CHAR (f.fregcompta, 'dd/mm/yyyy'),
                         TO_CHAR (f.fdatrecep, 'dd/mm/yyyy'),
                         TO_CHAR (f.fenvsec, 'dd/mm/yyyy'), f.fcodcompta,
                         f.fsocfour, TO_CHAR (f.fdeppole, 'FM0000000'),
                           f.num_expense ,      -- TD 582
                         to_char(f.cusag_expense),                             -- TD 595
                         c.siren                -- TD 637
                    FROM facture f, societe s, contrat c
                   WHERE f.socfact = s.soccode AND s.soccode IS NULL
                            AND f.numcont=c.numcont
                            AND f.cav=c.cav
                            AND f.socfact=c.soccont;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  raise_application_error (-20997, SQLERRM);
            END;                               --   Fin de renvoi curseur Vide
         END;                                             -- Fin Bloc Creation
      END IF;                                            -- Fin de IF Creation

-- ******************************************************************

      --

      -- Cas  MODIFIER  ou  SUPPRIMER ou LIGNES

      --

      -- ******************************************************************

      --
      IF (p_mode = 'update' OR p_mode = 'delete' OR p_mode = 'lignes')
      THEN
         DECLARE
            l_fprovsegl1     facture.fprovsegl1%TYPE;
            l_fprovsegl2     facture.fprovsegl2%TYPE;
            l_fmodreglt      facture.fmodreglt%TYPE;
            l_fstatut1       facture.fstatut1%TYPE;
            l_fstatut2       facture.fstatut2%TYPE;
            l_soccont        facture.soccont%TYPE;
            l_cav            facture.cav%TYPE;
            l_numcont        facture.numcont%TYPE;
            l_tva            facture.ftva%TYPE;
            l_filcode        contrat.filcode%TYPE;
            l_codsg          contrat.codsg%TYPE;
            l_comcode        contrat.comcode%TYPE;
            l_siren          contrat.siren%TYPE;
            l_msg_cont       VARCHAR2 (200);
            l_centre_frais   centre_frais.codcfrais%TYPE;
            l_fcentrefrais   centre_frais.codcfrais%TYPE;
         BEGIN
            -- Test existence de la facture

            -- Si existe Alors

            --       Pour Modifier ou Lignes AUTORISER Si fstatut1 = AE ou SE ou IN ou EN (kha 12/08/2004 pas EN)

            --       Pour Supprimer INTERDIRE Si fstatut1 = VA et fmodreglt = 1

            --                                si fstatut1 = AE et fmodreglt = 8

            --                                si fstatut1 = VA et fmodreglt = 8

            --       La liste des lignes de factures sera obtenue par lister_ligne_fact

            -- EXCEPTION si facture inexistante
            BEGIN
               SELECT f.fprovsegl1, f.fprovsegl2, f.fmodreglt, f.fstatut1,
                      f.fstatut2, f.soccont, f.cav, f.numcont, f.ftva,
                      f.fcentrefrais
                 INTO l_fprovsegl1, l_fprovsegl2, l_fmodreglt, l_fstatut1,
                      l_fstatut2, l_soccont, l_cav, l_numcont, l_tva,
                      l_fcentrefrais
                 FROM facture f, societe s
                WHERE f.socfact = s.soccode
                  AND s.soccode = p_socfact
                  AND f.numfact = RPAD (p_numfact, 15)
                  AND f.typfact = p_typfact
                  AND f.datfact = TO_DATE (p_datfact, 'DD/MM/YYYY');
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  pack_global.recuperer_message (20103,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 l_msg
                                                );
                  raise_application_error (-20103, l_msg);
               WHEN OTHERS
               THEN
                  raise_application_error (-20997, SQLERRM);
            END;

-- ======================================================================================

            -- 20/12/2000 :Contrôler que la facture appartient au centre de frais de l'utilisateur

            -- =======================================================================================

            -- On récupère le code centre de frais de l'utilisateur
            l_centre_frais := pack_global.lire_globaldata (p_userid).codcfrais;

            IF l_centre_frais != 0
            THEN -- le centre de frais 0 donne tout les droits à l'utilisateur
               IF l_fcentrefrais IS NULL
               THEN
                  -- la facture n'est rattachée à aucun centre de frais
                  pack_global.recuperer_message (20337,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 l_msg
                                                );
                  raise_application_error (-20337, l_msg);
               ELSE
                  IF l_centre_frais != l_fcentrefrais
                  THEN
                     -- la facture n'est pas rattachée au centre de frais %s1 mais au centre de frais %s2
                     pack_global.recuperer_message (20338,
                                                    '%s1',
                                                    TO_CHAR (l_centre_frais),
                                                    '%s2',
                                                    TO_CHAR (l_fcentrefrais),
                                                    NULL,
                                                    l_msg
                                                   );
                     raise_application_error (-20338, l_msg);
                  END IF;
               END IF;
            END IF;

            --    DBMS_OUTPUT.PUT_LINE(' --> Verif statut:' || l_fstatut1 || ';' || l_fprovsegl1  );

            -- Test si c'est autorise pour Modifier ou Lignes
            IF (p_mode = 'update' OR p_mode = 'lignes')
            THEN
               --kha f209 12/08/2004

               --IF (l_fstatut1 = 'AE' OR l_fstatut1 = 'SE' OR l_fstatut1 = 'IN' OR l_fstatut1 = 'EN') THEN  NULL ; -- OK modif
               IF (l_fstatut1 = 'AE' OR l_fstatut1 = 'SE' OR l_fstatut1 = 'IN'
                  )
               THEN
                  NULL;                                           -- OK modif
               ELSE                         -- Message  Modification interdite
                  pack_global.recuperer_message (20102,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 l_msg
                                                );
                  raise_application_error (-20102, l_msg);
               END IF;
            ELSE                      -- Test si c'est autorise pour Supprimer
               IF p_mode = 'delete'
               THEN
                  IF (l_fstatut1 = 'VA' AND l_fmodreglt = 1)
                  THEN
                  -- Message  Facture validée par SEGL, suppression interdite
                     pack_global.recuperer_message (20105,
                                                    NULL,
                                                    NULL,
                                                    NULL,
                                                    l_msg
                                                   );
                     raise_application_error (-20105, l_msg);
                  END IF;

                  IF (   (l_fstatut1 = 'AE' AND l_fmodreglt = 8)
                      OR (l_fstatut1 = 'VA' AND l_fmodreglt = 8)
                     )
                  THEN      -- Message  Facture annulée, suppression interdite
                     pack_global.recuperer_message (20379,
                                                    NULL,
                                                    NULL,
                                                    NULL,
                                                    l_msg
                                                   );
                     raise_application_error (-20379, l_msg);
                  END IF;
               END IF;
            END IF;

-- =================================================================================

            -- Cas facture avec contrat : A-t-on la bonne filiale ? - Initialisation de C.COMCODE et C.CODSG

            -- =================================================================================
            IF l_numcont IS NOT NULL
            THEN
               verif_filiale_cont (l_soccont,
                                   l_cav,
                                   l_numcont,
                                   p_filcode,
                                   l_msg_cont,
                                   l_codsg,
                                   l_comcode
                                  );
               p_codsgout := TO_CHAR (l_codsg, 'FM0000000');
               p_comcodeout := l_comcode;
               p_siren := l_siren;

               IF l_msg_cont IS NOT NULL
               THEN
                  p_msg_info := l_msg_cont;
               END IF;
            END IF;

            -- Select du Taux TVA
            IF l_tva IS NULL
            THEN
               BEGIN
                  SELECT tva
                    INTO l_tva
                    FROM tva
                   WHERE datetva = (SELECT MAX (datetva)
                                      FROM tva);
               END;
            END IF;

            p_ftvaout := TO_CHAR (l_tva, 'FM00D00');
-- =================================================================================

            -- OK Maintenant tout est bon, select de la facture suivant MODIF ou SUPPR ou LIGNES

            -- =================================================================================
            p_nbcurseur := 1;

            BEGIN
               OPEN p_curselect FOR
                  SELECT s.soclib, f.socfact, f.numfact, f.typfact,
                         TO_CHAR (f.datfact, 'dd/mm/yyyy'),
                         TO_CHAR (f.fmoiacompta, 'mm/yyyy'),
                         TO_CHAR (f.fmontht, 'FM99999990D00'), f.fstatut1,
                         TO_CHAR (f.flaglock), f.soccont, DECODE(c.top30,'O',DECODE(f.cav,'000','000',RPAD(f.cav,3)),'N',SUBSTR(f.cav,2,2) ), f.numcont,
                         TO_CHAR (f.fenrcompta, 'dd/mm/yyyy'),
                         TO_CHAR (f.faccsec, 'dd/mm/yyyy'),
                         TO_CHAR (f.fregcompta, 'dd/mm/yyyy'),
                         TO_CHAR (f.fdatrecep, 'dd/mm/yyyy'),

                         --TO_CHAR((f.fenvsec - 30),'dd/mm/yyyy'),    -- date reception
                         TO_CHAR ((f.fenvsec), 'dd/mm/yyyy'),
                                                   -- date reglement souhaite
                                                             f.fcodcompta,
                         f.fsocfour, TO_CHAR (f.fdeppole, 'FM0000000'),
                         f.num_expense,                              -- TD 582
                         to_char(f.cusag_expense),                   -- TD 595
                         c.siren                                     -- TD 637
                    FROM facture f, societe s, contrat c
                   WHERE f.socfact = s.soccode
                     AND s.soccode = p_socfact
                     AND f.numfact = RPAD (p_numfact, 15)
                     AND f.typfact = p_typfact
                     AND f.datfact = TO_DATE (p_datfact, 'DD/MM/YYYY')
                     AND f.numcont=c.numcont
                     AND f.cav=c.cav
                     AND f.socfact=c.soccont;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN           -- Msg Aucune facture pour la sélection demandée
                  pack_global.recuperer_message (20103,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 l_msg
                                                );
                  raise_application_error (-20103, l_msg);
               WHEN OTHERS
               THEN
                  raise_application_error (-20997, SQLERRM);
            END;             -- end select pour Modifier , Supprimer ou Lignes
         END;                          -- End bloc Modifier ,Supprimer, Lignes
      END IF;                   -- Fin du cas  MODIFIER ou SUPPRIMER ou LIGNES
   END select_facture;



--YNI FDT 784 : methode de recuperation des factures a partir d'un code expense
   PROCEDURE select_facture_expense (
      p_mode          IN       VARCHAR2,
      p_numexpense    IN       facture.NUM_EXPENSE%TYPE,
      p_choixfsc      IN       VARCHAR2,         -- choix facture sans contrat
      p_userid        IN       VARCHAR2,
      p_curselect     IN OUT   factcurtype,
      p_socfactout    OUT      VARCHAR2,
      p_soclibout     OUT      VARCHAR2,
      p_numcontout    OUT      VARCHAR2,
      p_cavout        OUT      VARCHAR2,
      p_numfactout    OUT      VARCHAR2,
      p_typfactout    OUT      VARCHAR2,
      p_datfactout    OUT      VARCHAR2,
      p_codsgout      OUT      VARCHAR2,
      p_comcodeout    OUT      VARCHAR2,
      p_choixfscout   OUT      VARCHAR2,
      p_ftvaout       OUT      VARCHAR2,
      p_msg_info      OUT      VARCHAR2,
      p_nbcurseur     OUT      INTEGER,
      p_message       OUT      VARCHAR2,
      p_siren         OUT      VARCHAR2
   )
   IS
      l_msg            VARCHAR2 (1024);
      p_filcode        filiale_cli.filcode%TYPE;
      l_sousmenus   VARCHAR2(1024);
   BEGIN
      -- Initialiser le message retour
      p_message := '';
      
      -- initialisation des champs relatifs au contrat pour facture sans contrat
      --p_socfactout := p_socfact;
      --p_numfactout := p_numfact;
      --_datfactout := p_datfact;
      --p_typfactout := p_typfact;
      --p_choixfscout := p_choixfsc;
      
      -- pour Créer facture avec contrat, initialisation par pack_factcont.select_factcont
      p_numcontout := '';
      p_cavout := '';
      p_codsgout := '';
      p_comcodeout := '';
      p_siren := '';
      --DBMS_OUTPUT.PUT_LINE(p_mode || '-;-' || p_socfact || '-;-' || p_numcont || '-;-'

      --  || p_rnom || '-;-' || p_numfact || '-;-' || p_typfact || '-;-' || p_datfact || '-;-'

      --  || p_choixfsc || '-;-' || p_userid || '-;;') ;

      --  On recupere le code filiale de l'utilisateur
      p_filcode := pack_global.lire_globaldata (p_userid).filcode;

      l_sousmenus := Pack_Global.lire_globaldata(p_userid).sousmenus;


      -- ******************************************************************

      --

      -- Cas  MODIFIER  ou  SUPPRIMER ou LIGNES

      --

      -- ******************************************************************

      --
      IF (p_mode = 'update' OR p_mode = 'delete' OR p_mode = 'lignes')
      THEN
         DECLARE
            l_fprovsegl1     facture.fprovsegl1%TYPE;
            l_fprovsegl2     facture.fprovsegl2%TYPE;
            l_fmodreglt      facture.fmodreglt%TYPE;
            l_fstatut1       facture.fstatut1%TYPE;
            l_fstatut2       facture.fstatut2%TYPE;
            l_soccont        facture.soccont%TYPE;
            l_cav            facture.cav%TYPE;
            l_numcont        facture.numcont%TYPE;
            l_tva            facture.ftva%TYPE;
            l_filcode        contrat.filcode%TYPE;
            l_codsg          contrat.codsg%TYPE;
            l_comcode        contrat.comcode%TYPE;
            l_siren          contrat.siren%TYPE;
            l_msg_cont       VARCHAR2 (200);
            l_centre_frais   centre_frais.codcfrais%TYPE;
            l_fcentrefrais   centre_frais.codcfrais%TYPE;
         BEGIN
            -- Test existence de la facture

            -- Si existe Alors

            --       Pour Modifier ou Lignes AUTORISER Si fstatut1 = AE ou SE ou IN ou EN (kha 12/08/2004 pas EN)

            --       Pour Supprimer INTERDIRE Si fstatut1 = VA et fmodreglt = 1

            --                                si fstatut1 = AE et fmodreglt = 8

            --                                si fstatut1 = VA et fmodreglt = 8

            --       La liste des lignes de factures sera obtenue par lister_ligne_fact

            -- EXCEPTION si facture inexistante
            BEGIN
               SELECT f.fprovsegl1, f.fprovsegl2, f.fmodreglt, f.fstatut1,
                      f.fstatut2, f.soccont, f.cav, f.numcont, f.ftva,
                      f.fcentrefrais
                 INTO l_fprovsegl1, l_fprovsegl2, l_fmodreglt, l_fstatut1,
                      l_fstatut2, l_soccont, l_cav, l_numcont, l_tva,
                      l_fcentrefrais
                 FROM facture f
                WHERE f.num_expense = p_numexpense;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  pack_global.recuperer_message (20103,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 l_msg
                                                );
                  raise_application_error (-20103, l_msg);
               WHEN OTHERS
               THEN
                  raise_application_error (-20997, SQLERRM);
            END;

-- ======================================================================================

            -- 20/12/2000 :Contrôler que la facture appartient au centre de frais de l'utilisateur

            -- =======================================================================================

            -- On récupère le code centre de frais de l'utilisateur
            l_centre_frais := pack_global.lire_globaldata (p_userid).codcfrais;

            IF l_centre_frais != 0
            THEN -- le centre de frais 0 donne tout les droits à l'utilisateur
               IF l_fcentrefrais IS NULL
               THEN
                  -- la facture n'est rattachée à aucun centre de frais
                  pack_global.recuperer_message (20337,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 l_msg
                                                );
                  raise_application_error (-20337, l_msg);
               ELSE
                  IF l_centre_frais != l_fcentrefrais
                  THEN
                     -- la facture n'est pas rattachée au centre de frais %s1 mais au centre de frais %s2
                     pack_global.recuperer_message (20338,
                                                    '%s1',
                                                    TO_CHAR (l_centre_frais),
                                                    '%s2',
                                                    TO_CHAR (l_fcentrefrais),
                                                    NULL,
                                                    l_msg
                                                   );
                     raise_application_error (-20338, l_msg);
                  END IF;
               END IF;
            END IF;

            --    DBMS_OUTPUT.PUT_LINE(' --> Verif statut:' || l_fstatut1 || ';' || l_fprovsegl1  );

            -- Test si c'est autorise pour Modifier ou Lignes
            IF (p_mode = 'update' OR p_mode = 'lignes')
            THEN
               --kha f209 12/08/2004

               --IF (l_fstatut1 = 'AE' OR l_fstatut1 = 'SE' OR l_fstatut1 = 'IN' OR l_fstatut1 = 'EN') THEN  NULL ; -- OK modif
               IF (l_fstatut1 = 'AE' OR l_fstatut1 = 'SE' OR l_fstatut1 = 'IN'
                  )
               THEN
                  NULL;                                           -- OK modif
               ELSE                         -- Message  Modification interdite
                  pack_global.recuperer_message (20102,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 l_msg
                                                );
                  raise_application_error (-20102, l_msg);
               END IF;
            ELSE                      -- Test si c'est autorise pour Supprimer
               IF p_mode = 'delete'
               THEN
                  IF (l_fstatut1 = 'VA' AND l_fmodreglt = 1)
                  THEN
                  -- Message  Facture validée par SEGL, suppression interdite
                     pack_global.recuperer_message (20105,
                                                    NULL,
                                                    NULL,
                                                    NULL,
                                                    l_msg
                                                   );
                     raise_application_error (-20105, l_msg);
                  END IF;

                  IF (   (l_fstatut1 = 'AE' AND l_fmodreglt = 8)
                      OR (l_fstatut1 = 'VA' AND l_fmodreglt = 8)
                     )
                  THEN      -- Message  Facture annulée, suppression interdite
                     pack_global.recuperer_message (20379,
                                                    NULL,
                                                    NULL,
                                                    NULL,
                                                    l_msg
                                                   );
                     raise_application_error (-20379, l_msg);
                  END IF;
               END IF;
            END IF;

-- =================================================================================

            -- Cas facture avec contrat : A-t-on la bonne filiale ? - Initialisation de C.COMCODE et C.CODSG

            -- =================================================================================
            IF l_numcont IS NOT NULL
            THEN
               verif_filiale_cont (l_soccont,
                                   l_cav,
                                   l_numcont,
                                   p_filcode,
                                   l_msg_cont,
                                   l_codsg,
                                   l_comcode
                                  );
               p_codsgout := TO_CHAR (l_codsg, 'FM0000000');
               p_comcodeout := l_comcode;
               p_siren := l_siren;

               IF l_msg_cont IS NOT NULL
               THEN
                  p_msg_info := l_msg_cont;
               END IF;
            END IF;

            -- Select du Taux TVA
            IF l_tva IS NULL
            THEN
               BEGIN
                  SELECT tva
                    INTO l_tva
                    FROM tva
                   WHERE datetva = (SELECT MAX (datetva)
                                      FROM tva);
               END;
            END IF;

            p_ftvaout := TO_CHAR (l_tva, 'FM00D00');
-- =================================================================================

            -- OK Maintenant tout est bon, select de la facture suivant MODIF ou SUPPR ou LIGNES

            -- =================================================================================
            p_nbcurseur := 1;

            BEGIN
               OPEN p_curselect FOR
                  SELECT s.soclib, f.socfact, f.numfact, f.typfact,
                         TO_CHAR (f.datfact, 'dd/mm/yyyy'),
                         TO_CHAR (f.fmoiacompta, 'mm/yyyy'),
                         TO_CHAR (f.fmontht, 'FM99999990D00'), f.fstatut1,
                         TO_CHAR (f.flaglock), f.soccont, DECODE(c.top30,'O',DECODE(f.cav,'000','000',RPAD(f.cav,3)),'N',SUBSTR(f.cav,2,2) ), f.numcont,
                         TO_CHAR (f.fenrcompta, 'dd/mm/yyyy'),
                         TO_CHAR (f.faccsec, 'dd/mm/yyyy'),
                         TO_CHAR (f.fregcompta, 'dd/mm/yyyy'),
                         TO_CHAR (f.fdatrecep, 'dd/mm/yyyy'),

                         --TO_CHAR((f.fenvsec - 30),'dd/mm/yyyy'),    -- date reception
                         TO_CHAR ((f.fenvsec), 'dd/mm/yyyy'),
                                                   -- date reglement souhaite
                                                             f.fcodcompta,
                         f.fsocfour, TO_CHAR (f.fdeppole, 'FM0000000'),
                         f.num_expense,                              -- TD 582
                         to_char(f.cusag_expense),                   -- TD 595
                         c.siren                                     -- TD 637
                    FROM facture f, societe s, contrat c
                   WHERE f.socfact = s.soccode
                     AND f.num_expense = p_numexpense 
                     AND f.numcont=c.numcont
                     AND f.cav=c.cav
                     AND f.socfact=c.soccont;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN           -- Msg Aucune facture pour la sélection demandée
                  pack_global.recuperer_message (20103,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 l_msg
                                                );
                  raise_application_error (-20103, l_msg);
               WHEN OTHERS
               THEN
                  raise_application_error (-20997, SQLERRM);
            END;             -- end select pour Modifier , Supprimer ou Lignes
         END;                          -- End bloc Modifier ,Supprimer, Lignes
      END IF;                   -- Fin du cas  MODIFIER ou SUPPRIMER ou LIGNES
   END select_facture_expense;
--Fin YNI


-- **************************************************************************************

-- TEST sous SQL+

-- var vcur refcursor

-- var vsoc varchar2(20)

-- var vsoclib varchar2(30)

-- var vnumcont varchar2(30)

-- var vcav varchar2(20)

-- var vnumfact varchar2(30)

-- var vtyp varchar2(20)

-- var vdat varchar2(20)

-- var vcodsg varchar2(20)

-- var vcom varchar2(20)

-- var vchoix varchar2(20)

-- var vnbcur number

-- var vmsg varchar2(200)

-- var vftva varchar2(20)

-- set serveroutput on

-- set autoprint on

-- exec pack_facture.select_facture('Lignes','SOPR','','LE','971221310339','F','10/11/1999','N','S935705;;;;01;', :vcur,:vsoc,:vsoclib,:vnumcont,:vcav,:vnumfact,:vtyp,:vdat,:vcodsg,:vcom,:vchoix,:vftva,:vnbcur,:vmsg);

-- exec pack_facture.insert_facture('SOPR','SOPRA','1248','02','LE123456','F','10/11/1999','10/11/1999','631195','241612','241612','4376','4376','AE','10/1999','S935705;;;;01;',:vcur,:vnbcur,:vmsg)

-- exec pack_facture.insert_facture('SOPR','SOPRA','','','LE123456','F','10/11/1999','10/11/1999','631195','241612','241612','4376','4376','AE','10/1999','S935705;;;;01;',:vcur,:vnbcur,:vmsg)

-- exec pack_facture.delete_facture('SOPR','LE123456','F','10/11/1999','5000,00','10/11/1999','01/10/1999','10/11/1999','10/11/1999',0,'S935705;;;;01;',:vcur,:vnbcur,:vmsg)

-- exec pack_facture.update_facture('SOPR','SOPRA','1248','02','LE123456','F','10/11/1999','1/11/1999','631195','241612','241612','4376','4376','IN','10/1999',0,'S935705;;;;01;',:vcur,:vnbcur,:vmsg)

-- attention au flaglock lors des operations update,modify et delete


   --Procédure pour remplir les logs de MAJ des oodes dpg
PROCEDURE maj_facture_logs (p_numexpense IN VARCHAR2,
                            p_numfact      IN VARCHAR2,
                               p_socfact    IN VARCHAR2,
                               p_typfact    IN VARCHAR2,
                               p_datfact    IN DATE,
                               p_lnum       IN NUMBER,
                               p_nom_table  VARCHAR2,
                              p_user_log    IN VARCHAR2,
                              p_colonne        IN VARCHAR2,
                              p_valeur_prec    IN VARCHAR2,
                              p_valeur_nouv    IN VARCHAR2,
                              p_commentaire    IN VARCHAR2
                              ) IS
BEGIN



    IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
        INSERT INTO FACTURE_LOGS
            (NUM_EXP, NUMFACT, SOCFACT, TYPFACT, DATFACT, LNUM, DATE_LOG, USER_LOG, NOM_TABLE, COLONNE, VALEUR_PREC, VALEUR_NOUV, COMMENTAIRE)
        VALUES
            (p_numexpense, p_numfact,p_socfact, p_typfact, p_datfact, p_lnum, SYSDATE, p_user_log, p_nom_table, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);

    END IF;
    -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

END maj_facture_logs ;



END pack_facture;
/


