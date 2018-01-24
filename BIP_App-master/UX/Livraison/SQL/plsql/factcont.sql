-- pack_factcont  PL/SQL
--
-- equipe SOPRA
--
-- POUR LA GESTION DES FACTURES
--    Procedure : select_factcont               facture / contrat récent
--                select_factconth1             facture / contrat historisé
--
-- MODIF
-- PPR le 04/07/2006 : enleve tables histo
-- EVI le 22/08/2008: TD 637 siren
-- ABA le 26/08/2008: TD 615 affichage du statut cs1 en fonction du permeitre du contrat 
-- EVI le 17/04/2009: TD737 augmentation de la taille du numero de contrat + avenant 27+3
-- ***********************************************************************************
CREATE OR REPLACE PACKAGE     pack_factcont AS


  TYPE FactSelectRec IS RECORD (soclib       societe.soclib%TYPE,
                                socfact      facture.socfact%TYPE,
                                numcont      facture.numcont%TYPE,
                                cav          facture.cav%TYPE,
                                numfact      facture.numfact%TYPE,
                                typfact      facture.typfact%TYPE,
                                datfact      varchar2(20),
                                codsg        varchar2(20),     -- table contrat
                                comcode      varchar2(20),     -- table contrat pour Modifier
                                flaglock     VARCHAR2(20)
                               );

   TYPE VideRec IS RECORD     (filcode      filiale_cli.filcode%TYPE);

   TYPE SelectCurVide IS REF CURSOR RETURN VideRec;

   TYPE FactSelectCur IS REF CURSOR RETURN FactSelectRec;


-- appel en premier
   PROCEDURE select_factconth1 (p_socfact     IN facture.socfact%TYPE,
                                p_numcont     IN facture.numcont%TYPE,
                                p_rnom        IN ressource.rnom%TYPE,
                                p_numfact     IN facture.numfact%TYPE,
                                p_typfact     IN facture.typfact%TYPE,
                                p_datfact     IN VARCHAR2,
                                p_choixfsc    IN VARCHAR2,        -- choix facture sans contrat
                                p_userid      IN VARCHAR2,
                                p_soclibout      OUT VARCHAR2,
                                p_socfactout     OUT VARCHAR2,
                                p_numfactout     OUT VARCHAR2,
                                p_typfactout     OUT VARCHAR2,
                                p_datfactout     OUT VARCHAR2,
                                p_numcontout     OUT VARCHAR2,
                                p_nbcurseur      OUT INTEGER,
                                p_message        OUT VARCHAR2
                                );

-- appel en deuxieme
   PROCEDURE select_factcont   (p_socfact     IN facture.socfact%TYPE,
                                p_numcont     IN facture.numcont%TYPE,
                                p_rnom        IN ressource.rnom%TYPE,
                                p_numfact     IN facture.numfact%TYPE,
                                p_typfact     IN facture.typfact%TYPE,
                                p_datfact     IN VARCHAR2,
                                p_choixfsc    IN VARCHAR2,
                                p_clelc       IN VARCHAR2,
                                p_userid      IN VARCHAR2,
                                p_soclibout      OUT VARCHAR2,
                                p_socfactout     OUT VARCHAR2,
                                p_numcontout     OUT VARCHAR2,
                                p_cavout         OUT VARCHAR2,
                                p_numfactout     OUT VARCHAR2,
                                p_typfactout     OUT VARCHAR2,
                                p_datfactout     OUT VARCHAR2,
                                p_codsgout       OUT VARCHAR2,
                                p_comcodeout     OUT VARCHAR2,
                                p_nbcurseur      OUT INTEGER,
                                p_message        OUT VARCHAR2,
                                p_siren          OUT VARCHAR2,
                                p_statutcs1      OUT VARCHAR2
                               );

END pack_factcont;
/


CREATE OR REPLACE PACKAGE BODY     pack_factcont AS


-- ********************************************************************************************
-- ********************************************************************************************
--
-- SELECT_FACTCONT
--
-- ********************************************************************************************
-- ********************************************************************************************
   PROCEDURE select_factcont   (p_socfact     IN facture.socfact%TYPE,
                                p_numcont     IN facture.numcont%TYPE,
                                p_rnom        IN ressource.rnom%TYPE,
                                p_numfact     IN facture.numfact%TYPE,
                                p_typfact     IN facture.typfact%TYPE,
                                p_datfact     IN VARCHAR2,
                                p_choixfsc    IN VARCHAR2,
                                p_clelc       IN VARCHAR2,
                                p_userid      IN VARCHAR2,
                                p_soclibout      OUT VARCHAR2,
                                p_socfactout     OUT VARCHAR2,
                                p_numcontout     OUT VARCHAR2,
                                p_cavout         OUT VARCHAR2,
                                p_numfactout     OUT VARCHAR2,
                                p_typfactout     OUT VARCHAR2,
                                p_datfactout     OUT VARCHAR2,
                                p_codsgout       OUT VARCHAR2,
                                p_comcodeout     OUT VARCHAR2,
                                p_nbcurseur      OUT INTEGER,
                                p_message        OUT VARCHAR2,
                                p_siren          OUT VARCHAR2,
                                p_statutcs1      OUT VARCHAR2
                               ) IS

      l_msg         VARCHAR2(1024) ;
      l_soclib      societe.soclib%TYPE ;
      l_socfact     facture.socfact%TYPE ;
      l_numcont     VARCHAR2(30);
      l_cav         VARCHAR2(20);
      l_comcode     VARCHAR2(20);
      l_codsg       VARCHAR2(20);
      l_siren       VARCHAR2(20);
      l_statutcs1   VARCHAR2(2);
      l_syscompta   VARCHAR2(3);
      l_top30       contrat.top30%TYPE;

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';

      -- ======================================
      --      Libellé du CODE SOCIETE
      -- ======================================
      BEGIN
         SELECT soccode , soclib
         INTO   l_socfact , l_soclib
         FROM   societe
         WHERE  soccode = p_socfact;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN       -- Erreur message "Code Societe inexistant"
             pack_global.recuperer_message(20306, NULL, NULL, NULL, l_msg);
             raise_application_error(-20306,l_msg);
         WHEN OTHERS THEN
             raise_application_error(-20997,SQLERRM);
      END;

      -- DBMS_OUTPUT.PUT_LINE('--> après test Code societe : ' || l_socfact || '  ' || l_soclib );
      --      p_soclibout := 'SOCLIB#'|| l_soclib;

      -- ==========================================================
      --  Recupere les infos du contrat via la Clélc composé de
      --  numcont(15);cav(2);comcode(11);codsg(7)
      -- ==========================================================
		pack_liste_contrats.xcle_contrat(p_clelc,0,l_numcont,l_cav,l_comcode,l_codsg);

    BEGIN
         SELECT c.siren
         INTO   l_siren
         FROM   contrat c
         WHERE  TRIM(c.numcont) =TRIM(l_numcont)
            AND TRIM(c.cav) = TRIM(l_cav)
            AND TRIM(c.soccont) = TRIM(l_socfact);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN       -- Erreur message "Code Societe inexistant"
             pack_global.recuperer_message(20306, NULL, NULL, NULL, l_msg);
             raise_application_error(-20306,l_msg);
         WHEN OTHERS THEN
             raise_application_error(-20997,SQLERRM);
      END;

    BEGIN

        select d.syscompta, DECODE(c.top30,'O',DECODE(c.cav,'000',NULL,RPAD(c.cav,3)),'N',SUBSTR(c.cav,2,2))
        into l_syscompta, l_cav
        from directions d, struct_info si, contrat c
        where
        d.coddir = si.coddir
        and si.codsg = c.codsg
        and  TRIM(c.numcont) =TRIM(l_numcont)
        AND TRIM(c.cav) = TRIM(l_cav)
        AND TRIM(c.soccont) = TRIM(l_socfact);

        IF (l_syscompta = 'EXP')
        THEN
            l_statutcs1 := 'SE';
        ELSE
            l_statutcs1 := 'AE';
        END IF;

    END;

      p_soclibout    :=  l_soclib;
      p_socfactout   :=  p_socfact;
      p_numfactout   :=  p_numfact;
      p_typfactout   :=  p_datfact;
      p_datfactout   :=  p_typfact;
      p_numcontout   :=  l_numcont;
      p_cavout       :=  l_cav;
      p_codsgout     :=  LPAD(l_codsg, 7, '0');
      p_comcodeout   :=  l_comcode;
      p_siren        :=  l_siren;
      p_statutcs1    :=  l_statutcs1;


   END select_factcont;


-- ********************************************************************************************
-- ********************************************************************************************
--
-- SELECT_FACTCONTH1 : vérification de la societe, son libellé, la date de facture, l'existence
--         ou non de la facture dans FACTURE
-- (on consultera ensuite la liste des contrats historisés afin de créer une facture)
-- ********************************************************************************************
-- ********************************************************************************************
   PROCEDURE select_factconth1 (p_socfact     IN facture.socfact%TYPE,
                                p_numcont     IN facture.numcont%TYPE,
                                p_rnom        IN ressource.rnom%TYPE,
                                p_numfact     IN facture.numfact%TYPE,
                                p_typfact     IN facture.typfact%TYPE,
                                p_datfact     IN VARCHAR2,
                                p_choixfsc    IN VARCHAR2,        -- choix facture sans contrat
                                p_userid      IN VARCHAR2,
                                p_soclibout      OUT VARCHAR2,
                                p_socfactout     OUT VARCHAR2,
                                p_numfactout     OUT VARCHAR2,
                                p_typfactout     OUT VARCHAR2,
                                p_datfactout     OUT VARCHAR2,
                                p_numcontout     OUT VARCHAR2,
                                p_nbcurseur      OUT INTEGER,
                                p_message        OUT VARCHAR2
                               ) IS

      l_msg         VARCHAR2(1024) ;
      l_soclib      societe.soclib%TYPE ;
      l_socfact     facture.socfact%TYPE ;
      p_filcode     filiale_cli.filcode%TYPE ;



   BEGIN
      -- Positionner le nb de curseurs ==> 1 ?? plutot 0 !
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';


         --DBMS_OUTPUT.PUT_LINE(p_bouton || '-;-' || p_socfact || '-;-' || p_numcont || '-;-'
         --  || p_rnom || '-;-' || p_numfact || '-;-' || p_typfact || '-;-' || p_datfact || '-;-'
         --  || p_choixfsc || '-;-' || p_userid || '-;;') ;


      --  On recupere le code filiale de l'utilisateur
      p_filcode := pack_global.lire_globaldata(p_userid).filcode;


      -- =======================================================================
      -- Test existence du CODE SOCIETE : on recupere en meme temps son libelle
      -- =======================================================================
      BEGIN
         SELECT soccode , soclib
         INTO   l_socfact , l_soclib
         FROM   societe
         WHERE  soccode = p_socfact;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN       -- Erreur message "Code Societe inexistant"
             pack_global.recuperer_message(20306, NULL, NULL, NULL, l_msg);
             raise_application_error(-20306,l_msg);
         WHEN OTHERS THEN
             raise_application_error(-20997,SQLERRM);
      END;

      -- DBMS_OUTPUT.PUT_LINE('--> après test Code societe : ' || l_socfact || '  ' || l_soclib );
      --  p_soclibout := l_soclib;


      -- =======================================
      -- Test Date de facture <= date du jour
      -- =======================================
      DECLARE
         l_datejour DATE;
      BEGIN
         SELECT SYSDATE INTO l_datejour FROM   dual;
         IF l_datejour < to_date(p_datfact,'DD/MM/YYYY') THEN
               -- a adapter pour le num de message
            pack_global.recuperer_message(20104,NULL,NULL,NULL,l_msg);
            raise_application_error(-20104,l_msg);
         END IF;
      END;

		-- =====================================================================================
		-- Test de l'existence de la facture dans la table facture
		-- =====================================================================================
      BEGIN
         SELECT distinct socfact
         INTO   l_socfact
         FROM   facture
         WHERE  socfact = p_socfact
            AND numfact = p_numfact
            AND typfact = p_typfact
            AND datfact = to_date(p_datfact,'DD/MM/YYYY');

         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
            WHEN OTHERS THEN
                raise_application_error(-20997,SQLERRM);
      END;
                -- DBMS_OUTPUT.PUT_LINE('Apres select dans facture');
      IF SQL%FOUND THEN
                -- Erreur message "La facture existe deja" dans facture
         pack_global.recuperer_message(20101, NULL, NULL, NULL, l_msg);
         raise_application_error(-20101,l_msg);
      END IF;

      -- initialisation des champs relatifs au contrat pour facture sans contrat
      -- pour facture avec contrat, initialisation par pack_factcont.select_factcont
		p_nbcurseur := 0;

      p_soclibout    :=  l_soclib;
      p_socfactout   := p_socfact;
      p_numfactout   := p_numfact;
      p_typfactout   := p_datfact;
      p_datfactout   := p_typfact;
      p_numcontout   := p_numcont;

END select_factconth1;



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
-- var vmsg varchar2(200)
-- set serveroutput on
-- set autoprint on
-- exec pack_factcont.select_factcont('SOPR','1248','LE','971221310339','F','31/12/1997','N','S935705;;;;01;',:vcur,:vsoc,:vsoclib,:vnumcont,:vcav,:vnumfact,:vtyp,:vdat,:vcodsg,:vcom,:vnbcur,:vmsg);
-- exec pack_factcont.select_factconth1('SOPR','1248','LE','971221310339','F','31/12/1997','N','S935705;;;;01;'
-- ,:vsoclib,:vsoc,:vnumfact,:vtyp,:vdat,:vnbcur,:vmsg);



END pack_factcont;
/




