-- pack_datesuiv_fact  PL/SQL
--
-- equipe SOPRA
--
-- POUR LA GESTION DES DATES DE SUIVI DES FACTURES
--    Appelle à pack_global.
--    Procedure : select_datesuiv_fact   -> appel à pack_facture.verif_filiale_cont
--                update_datesuiv_fact 
-- Quand    Qui   Quoi
-- -------- ---   ----------------------------------------------------------------------------------------
-- 31/01/00 QHL   select_datesuiv_fact : ajouter autorisation de modifier dates de suivi si CS1 = VA
-- 08/06/00 NCM   si statut cs2='SE' : le mode de règlement est indifférent,
--                                      le message de code fournisseur ne doit pas bloquer la modif des dates de suivi 
--
-- 21/12/00 NCM   gestion des habilitation suivant le centre de frais
--				le centre de frais est récupéré par la variable globale
--				=>inconvénient : si un utilisateur est affecté à un autre centre de frais,
--				la modification est prise en compte à la prochaine connexion de l'utilisateur
-- 10/09/2008 EVI TD 637 ajout du siren
-- 19/03/2012 OEL QC 1344
-- ***********************************************************************************

CREATE OR REPLACE PACKAGE     pack_datesuiv_fact AS

   TYPE FactRecType IS RECORD (soclib       societe.soclib%TYPE,
                               socfact      facture.socfact%TYPE,
                               numfact      facture.numfact%TYPE,
                               typfact      facture.typfact%TYPE,
                               datfact      varchar2(20),
                               fnom         facture.fnom%TYPE,
                               fordrecheq   facture.fordrecheq%TYPE,
                               fenvsec      varchar2(20),      -- date reglmt souhaite
                               fregcompta   varchar2(20),
                               fmodreglt    varchar2(20),
                               fenrcompta   varchar2(20),
                               fburdistr    facture.fburdistr%TYPE,
                               fcodepost    varchar2(20),
                               fstatut2     facture.fstatut2%TYPE,
                               faccsec      varchar2(20),
                               fadresse1    facture.fadresse1%TYPE,
                               fadresse2    facture.fadresse2%TYPE,
                               fadresse3    facture.fadresse3%TYPE,
                               flaglock     VARCHAR2(20),
                               siren        contrat.siren%TYPE
                               );

   TYPE FactSelectCur IS REF CURSOR RETURN FactRecType;


   PROCEDURE update_datesuiv_fact   (p_socfact        IN facture.socfact%TYPE,
                                     p_soclib         IN societe.soclib%TYPE,
                                     p_numfact        IN facture.numfact%TYPE,
                                     p_typfact        IN facture.typfact%TYPE,
                                     p_datfact        IN VARCHAR2,
                                     p_fenrcompta     IN VARCHAR2,
                                     p_faccsec        IN VARCHAR2,
                                     p_fregcompta     IN VARCHAR2,
                                     p_fenvsec        IN VARCHAR2,
                                     p_fstatut2       IN facture.fstatut2%TYPE,
                                     p_fmodreglt      IN VARCHAR2,
                                     p_fordrecheq     IN facture.fordrecheq%TYPE,
                                     p_fnom           IN facture.fnom%TYPE,
                                     p_fadresse1      IN facture.fadresse1%TYPE,
                                     p_fadresse2      IN facture.fadresse2%TYPE,
                                     p_fadresse3      IN facture.fadresse3%TYPE,
                                     p_fcodepost      IN VARCHAR2,
                                     p_fburdistr      IN facture.fburdistr%TYPE,
                                     p_flaglock       IN VARCHAR2,
                                     p_userid         IN VARCHAR2,
                                     p_nbcurseur         OUT INTEGER,
                                     p_message           OUT VARCHAR2
                                    );


   PROCEDURE select_datesuiv_fact   (p_socfact        IN facture.socfact%TYPE,
                                     p_numfact        IN facture.numfact%TYPE,
                                     p_typfact        IN facture.typfact%TYPE,
                                     p_datfact        IN VARCHAR2,
                                     p_num_expense IN facture.NUM_EXPENSE%TYPE,
                                     p_userid         IN VARCHAR2,
                                     p_curselect      IN OUT FactSelectCur,
                                     p_msg_info          OUT VARCHAR2,
                                     p_nbcurseur         OUT INTEGER,
                                     p_message           OUT VARCHAR2
                                    );

END pack_datesuiv_fact;
/


CREATE OR REPLACE PACKAGE BODY "PACK_DATESUIV_FACT" AS

-- ********************************************************************************************************
-- ********************************************************************************************************
--
-- UPDATE_FACTURE   - possible que si fstatut1 = 'AE' ou 'SE' déjà contrôlé lors du select_datesuiv_fact
--
-- ********************************************************************************************************
-- ********************************************************************************************************
   PROCEDURE update_datesuiv_fact   (p_socfact        IN facture.socfact%TYPE,
                                     p_soclib         IN societe.soclib%TYPE,
                                     p_numfact        IN facture.numfact%TYPE,
                                     p_typfact        IN facture.typfact%TYPE,
                                     p_datfact        IN VARCHAR2,
                                     p_fenrcompta     IN VARCHAR2,
                                     p_faccsec        IN VARCHAR2,
                                     p_fregcompta     IN VARCHAR2,
                                     p_fenvsec        IN VARCHAR2,
                                     p_fstatut2       IN facture.fstatut2%TYPE,
                                     p_fmodreglt      IN VARCHAR2,
                                     p_fordrecheq     IN facture.fordrecheq%TYPE,
                                     p_fnom           IN facture.fnom%TYPE,
                                     p_fadresse1      IN facture.fadresse1%TYPE,
                                     p_fadresse2      IN facture.fadresse2%TYPE,
                                     p_fadresse3      IN facture.fadresse3%TYPE,
                                     p_fcodepost      IN VARCHAR2,
                                     p_fburdistr      IN facture.fburdistr%TYPE,
                                     p_flaglock       IN VARCHAR2,
                                     p_userid         IN VARCHAR2,
                                     p_nbcurseur         OUT INTEGER,
                                     p_message           OUT VARCHAR2
                                    ) IS

      l_msg        VARCHAR2(1024);
      l_filcode    filiale_cli.filcode%TYPE;
      p_filcode    filiale_cli.filcode%TYPE;
      referential_integrity EXCEPTION;
      PRAGMA       EXCEPTION_INIT(referential_integrity, -2292);
      l_soccont    facture.soccont%TYPE;
      l_cav        facture.cav%TYPE;
      l_numcont    facture.numcont%TYPE;
      l_llibanalyt facture.llibanalyt%TYPE;
      l_date       DATE;
      l_fsocfour   facture.fsocfour%TYPE;


   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';

      --  On recupere le code filiale de l'utilisateur
      p_filcode := pack_global.lire_globaldata(p_userid).filcode;

      -- =======================================
      -- Test Dates
      -- =======================================
      DECLARE
         l_datejour DATE;
      BEGIN
         SELECT SYSDATE INTO l_datejour FROM   dual;


      -- OK si Dates Enreg Compta <= date du jour
         IF l_datejour < to_date(p_fenrcompta,'DD/MM/YYYY') THEN
               -- Msg La date d'envoi à l'enreg Compta ne peut pas être postérieure à aujourd'hui
            pack_global.recuperer_message(20115,NULL,NULL,'FENRCOMPTA',l_msg);
            raise_application_error(-20115,l_msg);
         END IF;

      -- OK si Dates Enreg Compta <= Dates Accord Pole <= date du jour
         IF l_datejour < to_date(p_faccsec,'DD/MM/YYYY') THEN
               -- Msg La date d'accord Pole ne peut être postérieure à aujourd'hui
               pack_global.recuperer_message(20116,NULL,NULL,'FACCSEC',l_msg);
               raise_application_error(-20116,l_msg);

         ELSIF ( to_date(p_fenrcompta,'DD/MM/YYYY') > to_date(p_faccsec,'DD/MM/YYYY') ) THEN
               -- Msg La date d'accord Pole ne peut pas être antérieure à la date d'envoi à l'enreg. Compta
            pack_global.recuperer_message(20117,NULL,NULL,'FACCSEC',l_msg);
            raise_application_error(-20117,l_msg);
         END IF;


      -- Dates Reglement Compta <= Date du jour
         IF l_datejour < to_date(p_fregcompta,'DD/MM/YYYY') THEN
               -- Msg La date d'envoi au règlement Compta ne peut pas être postérieure à aujourd'hui
            pack_global.recuperer_message(20118,NULL,NULL,'FREGCOMPTA',l_msg);
            raise_application_error(-20118,l_msg);
         END IF;

      -- Dates Reglement Demandé > Date de facture
         IF to_date(p_fenvsec,'DD/MM/YYYY') <= to_date(p_datfact,'DD/MM/YYYY') THEN
               -- Msg La date de réglement demandée ne peut être antérieure ou égale à la date de facture
            pack_global.recuperer_message(20119,NULL,NULL,'FENVSEC',l_msg);
            raise_application_error(-20119,l_msg);
         END IF;


      END;

      -- ==============================================================
      --  Test si p_fmodreglt = 3 (cheque) alors il faut saisir les zones
      -- ==============================================================

      IF p_fmodreglt = 3 THEN
         BEGIN
            IF p_fordrecheq IS NULL THEN
                    pack_global.recuperer_message(20123,NULL, NULL, 'FORDRECHEQ', l_msg);
                    raise_application_error( -20123, l_msg );
            END IF;
            IF p_fnom       IS NULL THEN
                    pack_global.recuperer_message(20124,NULL, NULL, 'FNOM', l_msg);
                    raise_application_error( -20124, l_msg );
            END IF;
            IF p_fadresse1  IS NULL THEN
                    pack_global.recuperer_message(20125,NULL, NULL, 'FADRESSE1', l_msg);
                    raise_application_error( -20125, l_msg );
            END IF;
            IF p_fcodepost  = '0'  THEN
                    pack_global.recuperer_message(20126,NULL, NULL, 'FCODEPOST', l_msg);
                    raise_application_error( -20126, l_msg );
            END IF;
            IF p_fburdistr  IS NULL THEN
                    pack_global.recuperer_message(20127,NULL, NULL, 'FBURDISTR', l_msg);
                    raise_application_error( -20127, l_msg );
            END IF;
            END;
        END IF;

      -- ==============================================================
      --  TEST si Fsocfour = 9999999999 alors p_fmodreglt doit <> 1
      -- ==============================================================

      BEGIN
         SELECT   f.fsocfour   INTO l_fsocfour  FROM facture f
         WHERE  socfact  = p_socfact
           AND  numfact  = p_numfact
           AND  typfact  = p_typfact
           AND  datfact  = to_date(p_datfact,'DD/MM/YYYY')
           AND  flaglock = to_number(p_flaglock,'9999999');

            IF SQL%NOTFOUND THEN            -- Acces concurrent
                pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
                raise_application_error( -20999, l_msg );
            END IF;

            IF ( (l_fsocfour = '9999999999' or  l_fsocfour = '9999999' or  l_fsocfour = '999999 ')
                and p_fstatut2!='SE')        THEN
                IF p_fmodreglt = 1 THEN
                   -- Erreur Msg Pour le code fournisseur 9999999999, le mode de regl doit différent de 1(virement)
                        pack_global.recuperer_message(20122,NULL, NULL, 'FMODREGL', l_msg);
                        raise_application_error( -20122, l_msg );
                END IF;
            END IF;

      EXCEPTION
           WHEN NO_DATA_FOUND THEN  -- Acces concurrent
                    pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
                    raise_application_error( -20999, l_msg );
           WHEN OTHERS THEN
               raise_application_error(-20997,SQLERRM);

      END;


      -- ==============================================================
      --   OK : Modifier
      -- ==============================================================

      BEGIN
         UPDATE FACTURE
         SET   fnom        = p_fnom,
               fordrecheq  = p_fordrecheq,
               fenvsec     = to_date(p_fenvsec,'DD/MM/YYYY'),
               fregcompta  = to_date(p_fregcompta,'dd/mm/yyyy'),
               fmodreglt   = to_number(p_fmodreglt,'99'),
               fenrcompta  = to_date(p_fenrcompta,'dd/mm/yyyy'),
               fburdistr   = p_fburdistr,
               fcodepost   = to_number(p_fcodepost,'99999'),
               fstatut2    = p_fstatut2,
               fdatmaj     = sysdate,
               faccsec     = to_date(p_faccsec,'dd/mm/yyyy'),
               fadresse1   = p_fadresse1,
               fadresse2   = p_fadresse2,
               fadresse3   = p_fadresse3,
               flaglock    = decode(p_flaglock, 1000000, 0, p_flaglock + 1)
         WHERE  socfact  = p_socfact
           AND  numfact  = p_numfact
           AND  typfact  = p_typfact
           AND  datfact  = to_date(p_datfact,'DD/MM/YYYY')
           AND  flaglock = to_number(p_flaglock,'9999999');

      EXCEPTION
         WHEN referential_integrity THEN
            pack_global.recuperation_integrite(-2292);
         WHEN OTHERS THEN
               raise_application_error(-20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN  -- Acces concurrent
         pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
      ELSE                 -- Msg Dates enregistrées pour la facture numfact
         pack_global.recuperer_message(2206,'%s1',p_numfact, NULL, l_msg);
         p_message := l_msg;
      END IF;

END update_datesuiv_fact;


-- ********************************************************************************************
-- ********************************************************************************************
--
-- select_datesuiv_fact   : un seul cas
--
-- ********************************************************************************************
-- ********************************************************************************************
   PROCEDURE select_datesuiv_fact(
                                   p_socfact        IN facture.socfact%TYPE,
                                   p_numfact        IN facture.numfact%TYPE,
                                   p_typfact        IN facture.typfact%TYPE,
                                   p_datfact        IN VARCHAR2,
                                   p_num_expense    IN facture.NUM_EXPENSE%TYPE, -- QC 1344
                                   p_userid         IN VARCHAR2,
                                   p_curselect      IN  OUT FactSelectCur,
                                   p_msg_info       OUT VARCHAR2,
                                   p_nbcurseur      OUT INTEGER,
                                   p_message        OUT VARCHAR2
                              ) IS

      l_msg          VARCHAR2(1024) ;
      l_soclib       societe.soclib%TYPE ;
      l_socfact      facture.socfact%TYPE ;
      p_filcode      filiale_cli.filcode%TYPE ;
      l_fprovsegl1   facture.fprovsegl1%TYPE;
      l_fprovsegl2   facture.fprovsegl2%TYPE;
      l_fmodreglt    facture.fmodreglt%TYPE;
      l_fstatut1     facture.fstatut1%TYPE;
      l_fstatut2     facture.fstatut2%TYPE;
      l_soccont      facture.soccont%TYPE;
      l_cav          facture.cav%TYPE;
      l_numcont      facture.numcont%TYPE;
      l_filcode         contrat.filcode%TYPE;
      l_codsg        contrat.codsg%TYPE;
      l_comcode      contrat.comcode%TYPE;
      l_msg_cont     VARCHAR2(200);
      l_centre_frais centre_frais.codcfrais%TYPE;
      l_fcentrefrais centre_frais.codcfrais%TYPE;

      l_count NUMBER; -- QC 1344
      
   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur   := 0;
      p_message     := '';

         --DBMS_OUTPUT.PUT_LINE(p_bouton || '-;-' || p_socfact || '-;-' || p_numcont || '-;-'
         --  || p_rnom || '-;-' || p_numfact || '-;-' || p_typfact || '-;-' || p_datfact || '-;-'
         --  || p_choixfsc || '-;-' || p_userid || '-;;') ;

      --  On recupere le code filiale de l'utilisateur
      p_filcode := pack_global.lire_globaldata(p_userid).filcode;


      -- =======================================================================
      -- Test existence du CODE SOCIETE : on recupere en meme temps son libelle
      -- =======================================================================
     IF (p_num_expense IS NULL) THEN
          BEGIN
             SELECT soccode
             INTO   l_socfact
             FROM   societe
             WHERE  soccode = p_socfact;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN       -- Erreur message "Code Societe inexistant"
                 pack_global.recuperer_message(20306, NULL, NULL, NULL, l_msg);
                 raise_application_error(-20306,l_msg);
             WHEN OTHERS THEN
                 raise_application_error(-20997,SQLERRM);
          END;
      
     ELSE
      -- =======================================================================
      -- Test existence du Numero Expense - QC 1344-
      -- =======================================================================
      
     
          BEGIN
            SELECT COUNT(*) INTO l_count
            FROM   FACTURE
            WHERE  num_expense = p_num_expense;

            IF(l_count = 0) THEN    
                pack_global.recuperer_message(4650,'%s1', p_num_expense, NULL, NULL, 'num_expense', p_message);
                raise_application_error( -20226, p_message);                                                    
            END IF ;

          EXCEPTION
              WHEN OTHERS THEN  
                RAISE_APPLICATION_ERROR(-20997, SQLERRM);
                l_count := 0; 
          END;
     END IF;
     
   BEGIN
      -- ============================================================
      -- Test existence de la facture
      -- Si existe Alors
      --       Pour Modifier ou Lignes AUTORISER Si fstatut1 = AE ou SE   -> (ajout 31/1/2000 ) ou VA
      --       Pour Supprimer INTERDIRE Si fstatut1 = VA et fprovsegl1 = 1
      --                                et fstatut2 = VA et fprovsegl2 = 1 et fmodreglt = 1
      --       La liste des lignes de factures sera obtenue par lister_ligne_fact
      -- EXCEPTION si facture inexistante
      -- ============================================================
      BEGIN
         SELECT distinct f.fprovsegl1,f.fprovsegl2,f.fmodreglt,f.fstatut1,f.fstatut2,f.soccont,f.cav,f.numcont,f.fcentrefrais
         INTO     l_fprovsegl1,l_fprovsegl2,l_fmodreglt,l_fstatut1,l_fstatut2,l_soccont,l_cav,l_numcont,l_fcentrefrais
         FROM  facture f , societe s
         WHERE     f.socfact = s.soccode
               AND s.soccode = p_socfact
               AND f.numfact = p_numfact
               AND f.typfact = p_typfact
               AND f.datfact = to_date(p_datfact,'DD/MM/YYYY')
               OR  f.num_expense = p_num_expense ; -- QC 1344
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
               pack_global.recuperer_message(20103, NULL, NULL, NULL, l_msg);
               raise_application_error(-20103,l_msg);

        WHEN OTHERS THEN
               raise_application_error(-20997,SQLERRM);
      END;

      -- ============================================================
      -- Test si c'est autorise pour Modifier ou Lignes
      -- ============================================================
      IF (l_fstatut1 = 'AE' OR l_fstatut1 = 'SE' OR l_fstatut1 = 'VA'  ) THEN  NULL ; -- OK modif
         ELSE           -- Message  La modification par ce menu n'est possible que si CS1 = AE ou SE ou VA
               pack_global.recuperer_message(20139, NULL, NULL, NULL, l_msg);
               raise_application_error(-20139,l_msg);
      END IF;

      -- ============================================================
      -- Cas facture avec contrat : A-t-on la bonne filiale ?
      -- ============================================================
      IF l_numcont IS NOT NULL THEN
         pack_facture.verif_filiale_cont(l_soccont,l_cav,l_numcont,p_filcode,l_msg_cont,l_codsg,l_comcode);
         IF l_msg_cont IS NOT NULL THEN
            p_msg_info    := 'MSG_ERREUR#' || l_msg_cont ;
         END IF;
      END IF;


      -- ======================================================================================
      -- 21/12/2000 :Contrôler que la facture appartient au centre de frais de l'utilisateur
      -- =======================================================================================
     -- On récupère le code centre de frais de l'utilisateur
            l_centre_frais:=pack_global.lire_globaldata(p_userid).codcfrais;

         IF l_centre_frais!=0 then    -- le centre de frais 0 donne tout les droits à l'utilisateur
        IF l_fcentrefrais is null THEN
            -- la facture n'est rattachée à aucun centre de frais
            pack_global.recuperer_message(20337,NULL,NULL,NULL, l_msg);
                  raise_application_error(-20337, l_msg);

        ELSE
            IF l_centre_frais!=l_fcentrefrais THEN
                -- la facture n'est pas rattachée au centre de frais %s1 mais au centre de frais %s2
                pack_global.recuperer_message(20338,'%s1',to_char(l_centre_frais),'%s2',
                                    to_char(l_fcentrefrais),NULL, l_msg);
                     raise_application_error(-20338, l_msg);

            END IF;
        END IF;
    END IF;

      -- ============================================================
      -- OK Maintenant tout est bon, select de la facture
      -- ============================================================
      p_nbcurseur := 1;

      IF(p_num_expense IS NULL) THEN
          
          BEGIN
          OPEN p_curselect FOR
             SELECT  s.soclib,
                     f.socfact,
                     f.numfact,
                     f.typfact,
                     TO_CHAR(f.datfact,'dd/mm/yyyy'),
                     f.fnom,
                     f.fordrecheq,
                     TO_CHAR(f.fenvsec,'dd/mm/yyyy'),
                     TO_CHAR(f.fregcompta,'dd/mm/yyyy'),
                     TO_CHAR(f.fmodreglt,'FM99'),
                     TO_CHAR(f.fenrcompta,'dd/mm/yyyy'),
                     f.fburdistr,
                     TO_CHAR(f.fcodepost,'FM99999'),
                     f.fstatut2,
                     TO_CHAR(faccsec,'dd/mm/yyyy'),
                     f.fadresse1,
                     f.fadresse2,
                     f.fadresse3,
                     TO_CHAR(f.flaglock,'FM99999999'),
                     c.siren
             FROM  facture f, societe s, contrat c
             WHERE  f.socfact = s.soccode
                AND s.soccode = p_socfact
                AND f.numfact = p_numfact
                AND f.typfact = p_typfact
                AND f.datfact = to_date(p_datfact,'DD/MM/YYYY')
                AND f.numcont=c.numcont
                AND f.cav=c.cav
                AND f.socfact=c.soccont;
                

          EXCEPTION
            WHEN OTHERS THEN
                raise_application_error(-20997,SQLERRM);
          END; -- end select pour Modifier , Supprimer ou Lignes
    
      ELSE -- QC 1344 : N° Expense <> Null
          
          BEGIN
          OPEN p_curselect FOR
             SELECT  s.soclib,
                     f.socfact,
                     f.numfact,
                     f.typfact,
                     TO_CHAR(f.datfact,'dd/mm/yyyy'),
                     f.fnom,
                     f.fordrecheq,
                     TO_CHAR(f.fenvsec,'dd/mm/yyyy'),
                     TO_CHAR(f.fregcompta,'dd/mm/yyyy'),
                     TO_CHAR(f.fmodreglt,'FM99'),
                     TO_CHAR(f.fenrcompta,'dd/mm/yyyy'),
                     f.fburdistr,
                     TO_CHAR(f.fcodepost,'FM99999'),
                     f.fstatut2,
                     TO_CHAR(faccsec,'dd/mm/yyyy'),
                     f.fadresse1,
                     f.fadresse2,
                     f.fadresse3,
                     TO_CHAR(f.flaglock,'FM99999999'),
                     c.siren
             FROM  facture f, societe s, contrat c
             WHERE  f.socfact = s.soccode
                AND f.numcont=c.numcont
                AND f.cav=c.cav
                AND f.socfact=c.soccont
                AND f.num_expense = p_num_expense;                

          EXCEPTION
            WHEN OTHERS THEN
                raise_application_error(-20997,SQLERRM);
          END; -- end select pour Modifier , Supprimer ou Lignes
       
       END IF;    
    
   END;     -- End bloc Modifier


END select_datesuiv_fact;

-- **************************************************************************************
-- TEST sous SQL+
-- var vcur refcursor
-- var vsoc varchar2(20)
-- var vsoclib varchar2(30)
-- var vnumcont varchar2(20)
-- var vcav varchar2(20)
-- var vnumfact varchar2(20)
-- var vtyp varchar2(20)
-- var vdat varchar2(20)
-- var vcodsg varchar2(20)
-- var vcom varchar2(20)
-- var vchoix varchar2(20)
-- var vnbcur number
-- var vmsg varchar2(500)
-- var vmsgi varchar2(500)
-- set serveroutput on
-- set autoprint on
-- exec pack_datesuiv_fact.select_datesuiv_fact('SOPR','LE123456','F','10/11/1999','S935708;achmenu;;0000;01 ;bip_F04_08046',:vcur,:vmsgi,:vnbcur,:vmsg);
-- exec pack_datesuiv_fact.insert_facture('SOPR','SOPRA','','','LE123456','F','10/11/1999','10/11/1999','631195','241612','241612','4376','4376','AE','01/10/1999',0,'S935705;;;;01;',:vcur,:vnbcur,:vmsg)
-- exec pack_datesuiv_fact.delete_facture('SOPR','LE123456','F','10/11/1999','5000,00','10/11/1999','01/10/1999','10/11/1999','10/11/1999',0,'S935705;;;;01;',:vcur,:vnbcur,:vmsg)
-- exec pack_datesuiv_fact.update_datesuiv_fact('SOPR','SOPRA','1248','02','LE123456','F','10/11/1999','1/11/1999','631195','241612','241612','4376','4376','IN','01/10/1999',0,'S935705;;;;01;',:vcur,:vnbcur,:vmsg)
-- attention au flaglock lors des operations update,modify et delete

END pack_datesuiv_fact;
/

