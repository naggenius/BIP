-- pack_fact_segl PL/SQL
--
-- equipe SOPRA
-- POUR LA GESTION DES FACTURES  Onglet CORRECTION D'UNE FACTURE VALIDEE PAR SEGL
--    Procedure : 
--                verif_code_compta
--                update_facture_segl        
--                select_facture_segl        
--                select_facture2_segl        
--                select_ligne_segl
--                update_ligne_segl
--
-- MODIF QUAND   QUI      QUOI
-- -----------   ---      ------------------------------------------------------------------
-- 13/12/1999    QHL      Ajout test code comptable avant modif ligne fact (update_ligne_segl)
-- 14/12/1999    QHL      Ajout Verif_filiale_cont_segl pour tester le cas contrat historisé
-- 09/02/2000    QHL      A la demande de la MO, pour la correction facture validee par SEGL,
--                        ajout test mois/annee prestation < mois/annee courant
-- 18/05/2000    QHL      update_facture_segl : il faut updater aussi le champ soccont
-- 21/12/2000    NCM      gestion des habilitation suivant le centre de frais
--				le centre de frais est récupéré par la variable globale
--				=>inconvénient : si un utilisateur est affecté à un autre centre de frais,
--				la modification est prise en compte à la prochaine connexion de l'utilisateur
--
--12/06/2003   Pierre JOSSE : Migration DPG(et fdeppole) a 7 chiffres et suppression de la table USERBIP
--
--09/02/2005   Pierre JOSSE : Suppression de export_sms
-- 04/07/2006   PPR       * Supprime tables histo
-- ***************************************************************************************
CREATE OR REPLACE PACKAGE pack_fact_segl AS

   TYPE FactSelect1 IS RECORD (soclib       societe.soclib%TYPE,
                               socfact      facture.socfact%TYPE,
                               numfact      facture.numfact%TYPE,
                               typfact      facture.typfact%TYPE,
                               datfact      VARCHAR2(20), 
                               faccsec      VARCHAR2(20),         
                               fnumasn      VARCHAR2(20),         
                               fregcompta   VARCHAR2(20),
                               fenvsec      VARCHAR2(20), 
                               fmodreglt    VARCHAR2(20),
                               fmontht      VARCHAR2(20),
                               fmontttc     VARCHAR2(20),
                               llibanalyt   facture.llibanalyt%TYPE,
                               fmoiacompta  VARCHAR2(20),
                               fstatut1     facture.fstatut1%TYPE,
                               fstatut2     facture.fstatut2%TYPE,
                               fprovsdff1   facture.fprovsdff1%TYPE,
                               fprovsdff2   facture.fprovsdff2%TYPE,
                               fprovsegl1   facture.fprovsegl1%TYPE,
                               fprovsegl2   facture.fprovsegl2%TYPE,
                               fsocfour     facture.fsocfour%TYPE,
		        	socflib	agence.socflib%TYPE,
		        	numcont      facture.numcont%TYPE,
                               cav          facture.cav%TYPE,
                               fdeppole     VARCHAR2(20),
                               ftva         VARCHAR2(20),
                               flaglock     VARCHAR2(20)
                               );

   TYPE FactSelect2 IS RECORD (soclib       societe.soclib%TYPE,
                               socfact      facture.socfact%TYPE,
                               numcont      facture.numcont%TYPE,
                               cav          facture.cav%TYPE,
                               numfact      facture.numfact%TYPE,
                               typfact      facture.typfact%TYPE,
                               datfact      VARCHAR2(20),
                               fdeppole     VARCHAR2(20),
                               fmontht      VARCHAR2(20),
                               ftva         VARCHAR2(20),
                               fmontttc     VARCHAR2(20),
                               fmoiacompta  VARCHAR2(20),
                               flaglock     VARCHAR2(20)
                               );

   TYPE FactSelect1Cur IS REF CURSOR RETURN FactSelect1;

   TYPE FactSelect2Cur IS REF CURSOR RETURN FactSelect2;

   TYPE LigfSelect IS RECORD  (socfact      facture.socfact%TYPE,
                               soclib       societe.soclib%TYPE,
                               numcont      facture.numcont%TYPE,
                               cav          facture.cav%TYPE,
                               numfact      facture.numfact%TYPE,
                               typfact      facture.typfact%TYPE,
                               datfact      VARCHAR2(20),
                               lnum         VARCHAR2(10),
                               ident        VARCHAR2(10),
                               rnom         ressource.rnom%TYPE,
                               rprenom      ressource.rprenom%TYPE,
                               lmontht      VARCHAR2(10),
                               lmoisprest   VARCHAR2(10),
                               lcodcompta   VARCHAR2(20)
                              );

   TYPE LigfSelectCur IS REF CURSOR RETURN LigfSelect;

   PROCEDURE verif_codecompta  (c_codcompta   IN VARCHAR2       -- code comptable
                               );

   PROCEDURE verif_filiale_cont_segl
                                (c_soccont    IN facture.soccont%TYPE, -- Societe
                                 c_cav        IN facture.cav%TYPE,     -- Avenant
                                 c_numcont    IN facture.numcont%TYPE, -- Numero Contrat
                                 c_filcode    IN contrat.filcode%TYPE, -- code filiale 
                                 c_msg_typecont  OUT VARCHAR2
                                );

PROCEDURE update_facture_segl (p_socfact     IN facture.socfact%TYPE,
                               p_soclib      IN societe.soclib%TYPE,
                               p_numcont     IN facture.numcont%TYPE,
                               p_cav         IN facture.cav%TYPE,
                               p_numfact     IN facture.numfact%TYPE,
                               p_typfact     IN facture.typfact%TYPE,
                               p_datfact     IN VARCHAR2,
                               p_fdeppole    IN VARCHAR2,     
                               p_fmontht     IN VARCHAR2,      
                               p_ftva        IN VARCHAR2,
                               p_fmontttc    IN VARCHAR2,
                               p_fsocfour    IN facture.fsocfour%TYPE,
                               p_fmoiacompta IN VARCHAR2,
                               p_liste       IN VARCHAR2,
                               p_flaglock    IN VARCHAR2,
                               p_userid      IN VARCHAR2,
                               p_fsocfourout    OUT VARCHAR2,
                               p_flaglockout    OUT VARCHAR2,
                               p_nbcurseur      OUT INTEGER,
                               p_message        OUT VARCHAR2
                              );

PROCEDURE select_facture_segl (p_socfact     IN facture.socfact%TYPE,
                               p_numfact     IN facture.numfact%TYPE,
                               p_typfact     IN facture.typfact%TYPE,
                               p_datfact     IN VARCHAR2,
                               p_userid      IN VARCHAR2,
                               p_curselect   IN OUT FactSelect1Cur,
                               p_soclibout      OUT VARCHAR2,
                               p_socfactout     OUT VARCHAR2,
                               p_numfactout     OUT VARCHAR2,
                               p_typfactout     OUT VARCHAR2,
                               p_datfactout     OUT VARCHAR2,
                               p_msg_info       OUT VARCHAR2,
                               p_nbcurseur      OUT INTEGER,
                               p_message        OUT VARCHAR2
                              );

PROCEDURE select_facture2_segl (p_socfact     IN facture.socfact%TYPE,
                                p_soclib      IN societe.soclib%TYPE,
                                p_numfact     IN facture.numfact%TYPE,
                                p_typfact     IN facture.typfact%TYPE,
                                p_datfact     IN VARCHAR2,
                                p_faccsec     IN VARCHAR2,            
                                p_fnumasn     IN VARCHAR2,            
                                p_fregcompta  IN VARCHAR2,
                                p_fenvsec     IN VARCHAR2,
                                p_fmodreglt   IN VARCHAR2,
                                p_fsocfour    IN VARCHAR2,
                                p_fmontht     IN VARCHAR2,
                                p_fmontttc    IN VARCHAR2,
                                p_llibanalyt  IN facture.llibanalyt%TYPE,
                                p_fmoiacompta IN VARCHAR2,
                                p_fstatut1    IN facture.fstatut1%TYPE,
                                p_fstatut2    IN facture.fstatut2%TYPE,
                                p_fprovsdff1  IN facture.fprovsdff1%TYPE,
                                p_fprovsdff2  IN facture.fprovsdff2%TYPE,
                                p_fprovsegl1  IN facture.fprovsegl1%TYPE,
                                p_fprovsegl2  IN facture.fprovsegl2%TYPE,
                                p_flaglock    IN VARCHAR2,
                                p_userid      IN VARCHAR2,
                                p_curselect   IN OUT FactSelect2Cur,
                                p_fsocfourout    OUT VARCHAR2,
                                p_nbcurseur      OUT INTEGER,
                                p_message        OUT VARCHAR2
                              );

  PROCEDURE select_ligne_segl (p_socfact     IN facture.socfact%TYPE,
                               p_soclib      IN societe.soclib%TYPE,
                               p_numcont     IN facture.numcont%TYPE,
                               p_cav         IN facture.cav%TYPE,
                               p_numfact     IN facture.numfact%TYPE,
                               p_typfact     IN facture.typfact%TYPE,
                               p_datfact     IN VARCHAR2,
                               p_fdeppole    IN VARCHAR2,
                               p_fmontht     IN VARCHAR2,      
                               p_ftva        IN VARCHAR2,
                               p_fmontttc    IN VARCHAR2,
                               p_fsocfour    IN facture.fsocfour%TYPE,
                               p_fmoiacompta IN VARCHAR2,
                               p_clelf       IN VARCHAR2,
                               p_flaglock    IN VARCHAR2,
                               p_userid      IN VARCHAR2,
                               p_socfactout     OUT VARCHAR2,
                               p_soclibout      OUT VARCHAR2,
                               p_numcontout     OUT VARCHAR2,
                               p_cavout         OUT VARCHAR2,
                               p_numfactout     OUT VARCHAR2,
                               p_typfactout     OUT VARCHAR2,
                               p_datfactout     OUT VARCHAR2,
                               p_lnumout        OUT VARCHAR2,
                               p_identout       OUT VARCHAR2,
                               p_rnomout        OUT VARCHAR2,
                               p_rprenomout     OUT VARCHAR2,
                               p_lmonthtout     OUT VARCHAR2,
                               p_lmoisprestout  OUT VARCHAR2,
                               p_lcodcomptaout  OUT VARCHAR2,
                               p_fsocfourout    OUT VARCHAR2,
                               p_flaglockout    OUT VARCHAR2,
                               p_nbcurseur      OUT INTEGER,
                               p_message        OUT VARCHAR2
                              );

  PROCEDURE update_ligne_segl (p_socfact     IN facture.socfact%TYPE,
                               p_soclib      IN societe.soclib%TYPE,
                               p_numcont     IN facture.numcont%TYPE,
                               p_cav         IN facture.cav%TYPE,
                               p_numfact     IN facture.numfact%TYPE,
                               p_typfact     IN facture.typfact%TYPE,
                               p_datfact     IN VARCHAR2,
                               p_ident       IN VARCHAR2,
                               p_rnom        IN ressource.rnom%TYPE,
                               p_rprenom     IN ressource.rprenom%TYPE,
                               p_lmontht     IN VARCHAR2,
                               p_lmoisprest  IN VARCHAR2,
                               p_lcodcompta  IN VARCHAR2,
                               p_lnum        IN VARCHAR2,
                               p_fdeppole    IN VARCHAR2,
                               p_flaglock    IN VARCHAR2,
                               p_userid      IN VARCHAR2,
                               p_fdeppoleout    OUT VARCHAR2,
                               p_flaglockout    OUT VARCHAR2,
                               p_nbcurseur      OUT INTEGER,
                               p_message        OUT VARCHAR2
                              );
END pack_fact_segl;
/

CREATE OR REPLACE PACKAGE BODY pack_fact_segl AS 

-- ***********************************************
--
--       Verification code comptabble
-- 
-- ***********************************************
   PROCEDURE verif_codecompta  (c_codcompta     IN VARCHAR2       -- code comptable
                               ) IS
      l_msg       VARCHAR2(1024);
      l_comcode   code_compt.comcode%TYPE;
      -- ===================================================
      -- Test Existence du code comptable pour Ligne Facture
      -- ===================================================
   BEGIN
      SELECT comcode INTO l_comcode FROM code_compt
            WHERE  comcode = c_codcompta ;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN             -- msg Code comptable invalide
           pack_global.recuperer_message(20110, NULL, NULL, 'LCODCOMPTA', l_msg);
           raise_application_error(-20110,l_msg);
      WHEN OTHERS THEN
           raise_application_error(-20997,SQLERRM);
   END verif_codecompta;


-- **************************************************************************************
--       Verifier la filiale contrat pour ce menu SEGL dans table CONTRAT 
-- NB : different de pack_facture.verif_filiale_cont
-- **************************************************************************************
   PROCEDURE verif_filiale_cont_segl(c_soccont    IN facture.soccont%TYPE, -- Societe
                                     c_cav        IN facture.cav%TYPE,     -- Avenant
                            	     c_numcont    IN facture.numcont%TYPE, -- Numero Contrat
                            	     c_filcode    IN contrat.filcode%TYPE, -- code filiale 
                            	     c_msg_typecont  OUT VARCHAR2
                                ) IS

      l_filcode     	contrat.filcode%TYPE;
      l_flag_nontrouve  BOOLEAN;
      l_msg         	VARCHAR2(512);

   BEGIN
      -- ===========================================
      -- Recherche dans table CONTRAT
      -- ===========================================
      BEGIN
         l_flag_nontrouve := FALSE;

         SELECT   c.filcode
         INTO     l_filcode
         FROM  contrat c
         WHERE  c.soccont = c_soccont
            AND c.cav     = c_cav
            AND c.numcont = c_numcont;
         
         IF l_filcode <> c_filcode THEN   
               -- msg Le Contrat appartient à une autre filiale
               pack_global.recuperer_message(20112, NULL, NULL, NULL, l_msg);
               raise_application_error(-20112,l_msg);
            ELSE  -- Contrat Recent Pas de message
               c_msg_typecont := ''; 

         END IF;  

      EXCEPTION
         WHEN NO_DATA_FOUND THEN    
                 -- msg Contrat/avenant inconnu
               pack_global.recuperer_message(20129, NULL, NULL, 'NUMCONT', l_msg);
               raise_application_error(-20129,l_msg);
         WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END;


   END verif_filiale_cont_segl;




-- ********************************************************************************************************
-- ********************************************************************************************************
--
-- UPDATE_FACTURE   - possible que si fstatut1 = 'AE' ou 'SE' ou 'IN' déjà contrôlé lors du select_facture_segl
-- 
-- ********************************************************************************************************
-- ********************************************************************************************************
   PROCEDURE update_facture_segl (p_socfact     IN facture.socfact%TYPE,
                             	  p_soclib      IN societe.soclib%TYPE,
                             	  p_numcont     IN facture.numcont%TYPE,
                             	  p_cav         IN facture.cav%TYPE,
                             	  p_numfact     IN facture.numfact%TYPE,
                             	  p_typfact     IN facture.typfact%TYPE,
                             	  p_datfact     IN VARCHAR2,
                             	  p_fdeppole    IN VARCHAR2,      -- code fdeppole de la facture      
                             	  p_fmontht     IN VARCHAR2,      
                             	  p_ftva        IN VARCHAR2,      -- code comptable du contrat
                             	  p_fmontttc    IN VARCHAR2,
                             	  p_fsocfour    IN facture.fsocfour%TYPE,
                             	  p_fmoiacompta IN VARCHAR2,
                             	  p_liste       IN VARCHAR2,
                             	  p_flaglock    IN VARCHAR2,
                             	  p_userid      IN VARCHAR2,
                             	  p_fsocfourout    OUT VARCHAR2,
                             	  p_flaglockout    OUT VARCHAR2,
                             	  p_nbcurseur      OUT INTEGER,
                             	  p_message        OUT VARCHAR2
                              ) IS

      l_msg          VARCHAR2(1024);
      l_filcode      filiale_cli.filcode%TYPE;
      p_filcode      filiale_cli.filcode%TYPE;
      l_codsg        struct_info.codsg%TYPE;
      referential_integrity EXCEPTION;
      PRAGMA         EXCEPTION_INIT(referential_integrity, -2292);
      l_llibanalyt   facture.llibanalyt%TYPE;
      l_date         DATE;
      l_msg_cont     VARCHAR2(200);
      l_soccont      facture.soccont%TYPE;
      l_centre_frais centre_frais.codcfrais%TYPE;
      l_scentrefrais centre_frais.codcfrais%TYPE;

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';
      p_fsocfourout :=  p_fsocfour ;
      p_flaglockout :=  p_flaglock;
      
      --  On recupere le code filiale de l'utilisateur
      p_filcode := pack_global.lire_globaldata(p_userid).filcode;

      -- ====================================================================================
      -- Controle filiale du N° contrat et N° Avenant si present
      -- -> a differencier Facture avec contrat ou sans contrat pour construire le libellé analytique
      -- ====================================================================================
      IF p_numcont IS NOT NULL THEN
         BEGIN
            -- =========================================================
            --    Test contrat existant ? appartenant à la filiale ?
            -- =========================================================
            verif_filiale_cont_segl(p_socfact,p_cav,p_numcont,p_filcode,l_msg_cont);
            l_msg_cont := ' - ' || l_msg_cont;

            -- =========================================================
            --    Creer Libellé analytique cas Facture avec Contrat
            -- =========================================================
               l_date    := to_date(p_fmoiacompta,'MM/YYYY');
               l_llibanalyt := (rpad(p_socfact,4) || '-' || to_char(l_date,'MMYYYY') 
                     || '-' || rpad(p_numfact,15) || '-' || rpad(p_numcont,15) );


         END; -- End Bloc if contrat then
      ELSE
         -- =========================================================
         --    Creer Libellé analytique cas Facture sans Contrat
         -- =========================================================
         BEGIN
            l_llibanalyt := (RPAD(p_socfact,4) || '-' || p_fmoiacompta
                        || '-' || RPAD(p_numfact,15) );
         END;
      END IF; -- End if p_numcont not null

      -- ===============================================================
      --   Test Code DPG  existant ?
      -- ===============================================================
      BEGIN
         SELECT DISTINCT  si.codsg,si.scentrefrais
         INTO     l_codsg, l_scentrefrais
         FROM  struct_info si
         WHERE  si.codsg = TO_NUMBER(p_fdeppole);
            
      EXCEPTION
         WHEN NO_DATA_FOUND THEN      -- msg Code DPG inconnu
            pack_global.recuperer_message(20109, NULL, NULL, NULL, l_msg);
            raise_application_error(-20109,l_msg);
         WHEN OTHERS THEN
               raise_application_error(-20997,SQLERRM);
      END;
   
     -- ===================================================================
     -- 21/12/2000 : Test si le DPG appartient bien au centre de frais
     -- ===================================================================
     -- On récupère le code centre de frais de l'utilisateur
	l_centre_frais:=pack_global.lire_globaldata(p_userid).codcfrais;

    IF l_centre_frais!=0 then    -- le centre de frais 0 donne tout les droits à l'utilisateur
      	IF (l_scentrefrais is null)   then 
		--msg : Le DPG n'est rattaché à aucun centre de frais
		pack_global.recuperer_message(20339, NULL,NULL,'FDEPPOLE', l_msg);
          	raise_application_error(-20339, l_msg);
	ELSE
		IF (l_scentrefrais!=l_centre_frais) then
			--msg:Ce DPG n'appartient pas à ce centre de frais
			pack_global.recuperer_message(20334, '%s1',to_char(l_centre_frais),'FDEPPOLE', l_msg);
          		raise_application_error(-20334, l_msg);
		END IF;
      	END IF;
    ELSE	-- l'utilisateur n'est pas affecté à un centre de frais réel: récupérer le centre de frais du DPG
	IF (l_scentrefrais is null) then
		--msg : Le DPG n'est rattaché à aucun centre de frais
		pack_global.recuperer_message(20339, NULL,NULL,'FDEPPOLE', l_msg);
          	raise_application_error(-20339, l_msg);

	ELSE
		-- le centre de frais du contrat est le centre de frais du DPG
		l_centre_frais := l_scentrefrais;
	END IF;
    END IF;

      -- ===============================================================
      -- OK on peut Modifier
      -- ===============================================================
      -- QHL 18/05/2000 : il faut updater aussi le champ soccont
      IF p_numcont = '' 
         THEN l_soccont := null ;
         ELSE l_soccont := p_socfact;
      END IF;

     BEGIN
         UPDATE FACTURE
         SET   llibanalyt = l_llibanalyt,
               fsocfour   = p_fsocfour,
               soccont    = l_soccont,
               cav        = p_cav,
               numcont    = p_numcont,
               fdeppole   = TO_NUMBER(p_fdeppole),
	       fcentrefrais = l_centre_frais,
               flaglock   = decode(p_flaglock, 1000000, 0, p_flaglock + 1)
         WHERE  socfact   = p_socfact
           AND  numfact   = p_numfact
           AND  typfact   = p_typfact
           AND  datfact   = TO_DATE(p_datfact,'DD/MM/YYYY') 
           AND  flaglock  = p_flaglock;

      EXCEPTION
         WHEN referential_integrity THEN
            pack_global.recuperation_integrite(-2292);
         WHEN OTHERS THEN
               raise_application_error(-20997, SQLERRM);
      END;
      
      IF SQL%NOTFOUND THEN  -- Acces concurrent
         pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
      ELSE                 -- Msg Facture modifiée
         pack_global.recuperer_message(2201,'%s1',p_numfact, NULL, l_msg);
         p_message := l_msg || l_msg_cont;
         p_flaglockout :=  (p_flaglock + 1);
      END IF;

     
END update_facture_segl;



-- ********************************************************************************************
-- ********************************************************************************************
--
-- select_facture2_segl : appelé par l'écran Consulter en-tete facture (bouton Lignes)
--
-- ******************************************************************************************** 
-- ********************************************************************************************
PROCEDURE select_facture2_segl (p_socfact     IN facture.socfact%TYPE,
                                p_soclib      IN societe.soclib%TYPE,
                                p_numfact     IN facture.numfact%TYPE,
                                p_typfact     IN facture.typfact%TYPE,
                                p_datfact     IN VARCHAR2,
                                p_faccsec     IN VARCHAR2,              -- date accord pole
                                p_fnumasn     IN VARCHAR2,              -- n° dossier SDFF
                                p_fregcompta  IN VARCHAR2,
                                p_fenvsec     IN VARCHAR2,    -- date reglement demande
                                p_fmodreglt   IN VARCHAR2,
                                p_fsocfour    IN VARCHAR2,
                                p_fmontht     IN VARCHAR2,
                                p_fmontttc    IN VARCHAR2,
                                p_llibanalyt  IN facture.llibanalyt%TYPE,
                                p_fmoiacompta IN VARCHAR2,
                                p_fstatut1    IN facture.fstatut1%TYPE,
                                p_fstatut2    IN facture.fstatut2%TYPE,
                                p_fprovsdff1  IN facture.fprovsdff1%TYPE,
                                p_fprovsdff2  IN facture.fprovsdff2%TYPE,
                                p_fprovsegl1  IN facture.fprovsegl1%TYPE,
                                p_fprovsegl2  IN facture.fprovsegl2%TYPE,
                                p_flaglock    IN VARCHAR2,
                                p_userid      IN VARCHAR2,
                                p_curselect   IN OUT FactSelect2Cur,
                                p_fsocfourout    OUT VARCHAR2,
                                p_nbcurseur      OUT INTEGER,
                                p_message        OUT VARCHAR2
                              ) IS

      l_msg         VARCHAR2(1024) ;
      l_soclib      societe.soclib%TYPE ;
      l_socfact     facture.socfact%TYPE ;
      p_filcode     filiale_cli.filcode%TYPE ;

   BEGIN
      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      p_nbcurseur   := 1;
      p_message     := '';
      p_fsocfourout :=  p_fsocfour;

      DBMS_OUTPUT.PUT_LINE('Debut select ' );
         --  || p_rnom || '-;-' || p_numfact || '-;-' || p_typfact || '-;-' || p_datfact || '-;-'
         --  || p_choixfsc || '-;-' || p_userid || '-;;') ;
      
      BEGIN
      OPEN p_curselect FOR 
         SELECT  s.soclib,
                 f.socfact,
                 f.numcont,
                 f.cav,
                 f.numfact,
                 f.typfact,
                 TO_CHAR(f.datfact,'dd/mm/yyyy'),
                 TO_CHAR(f.fdeppole,'FM0000000'),
                 TO_CHAR(f.fmontht,'FM99999990D00'),
                 TO_CHAR(f.ftva,'FM90D00'),
                 TO_CHAR(f.fmontttc,'FM99999990D00'),
                 TO_CHAR(f.fmoiacompta,'MM/YYYY'),
                 TO_CHAR(f.flaglock,'FM9999999')
         FROM  facture f, societe s
         WHERE  f.socfact  = s.soccode
            AND s.soccode  = p_socfact
            AND f.numfact  = p_numfact
            AND f.typfact  = p_typfact
            AND f.datfact  = TO_DATE(p_datfact,'DD/MM/YYYY')
            AND f.flaglock = p_flaglock;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN     -- Msg Accès concurrent
            pack_global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
            raise_application_error(-20999,l_msg);
      
        WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END; -- End select 

END select_facture2_segl;




-- ********************************************************************************************
-- ********************************************************************************************
--
-- select_facture_segl 
--
-- ******************************************************************************************** 
-- ********************************************************************************************
   PROCEDURE select_facture_segl (p_socfact     IN facture.socfact%TYPE,
                             	  p_numfact     IN facture.numfact%TYPE,
                             	  p_typfact     IN facture.typfact%TYPE,
                             	  p_datfact     IN VARCHAR2,
                             	  p_userid      IN VARCHAR2,
                             	  p_curselect   IN OUT FactSelect1Cur,
                             	  p_soclibout      OUT VARCHAR2,
                             	  p_socfactout     OUT VARCHAR2,
                             	  p_numfactout     OUT VARCHAR2,
                             	  p_typfactout     OUT VARCHAR2,
                             	  p_datfactout     OUT VARCHAR2,
                             	  p_msg_info       OUT VARCHAR2,
                             	  p_nbcurseur      OUT INTEGER,
                             	  p_message        OUT VARCHAR2
                              ) IS

      l_msg          VARCHAR2(1024) ;
      l_soclib       societe.soclib%TYPE ;
      l_socfact      facture.socfact%TYPE ;
      p_filcode      filiale_cli.filcode%TYPE ;
      l_centre_frais centre_frais.codcfrais%TYPE;
      l_fcentrefrais centre_frais.codcfrais%TYPE;

   BEGIN
      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      p_nbcurseur   := 1;
      p_message     := '';
      p_socfactout  :=  p_socfact;
      p_numfactout  :=  p_numfact;
      p_datfactout  := p_datfact;
      p_typfactout  :=  p_typfact;


      --  On recupere le code filiale de l'utilisateur
      p_filcode := pack_global.lire_globaldata(p_userid).filcode;


      -- =======================================================================
      -- Test existence du CODE SOCIETE 
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
      p_soclibout :=  l_soclib;


      -- =======================================================================
      -- Test existence de la facture
      -- Si existe Alors 
      --    Autoriser la Modification  Si   fstatut1 = VA et fprovsegl1 = 1
      --                                 ou fstatut2 = VA et fprovsegl2 = 1 
      -- =======================================================================

      DECLARE
            l_fprovsegl1  facture.fprovsegl1%TYPE;
            l_fprovsegl2  facture.fprovsegl2%TYPE;
            l_fmodreglt   facture.fmodreglt%TYPE;
            l_fstatut1    facture.fstatut1%TYPE;
            l_fstatut2    facture.fstatut2%TYPE;
            l_soccont     facture.soccont%TYPE;
            l_cav         facture.cav%TYPE;
            l_numcont     facture.numcont%TYPE;
            l_codsg       contrat.codsg%TYPE;
            l_comcode     contrat.comcode%TYPE;
            l_msg_cont    VARCHAR2(200);
    
      BEGIN    

         -- ================================
         -- Test existence de la facture
         -- ================================
         BEGIN      
            SELECT f.fprovsegl1,f.fprovsegl2,f.fmodreglt,f.fstatut1,f.fstatut2,f.soccont,f.cav,f.numcont,f.fcentrefrais
            INTO   l_fprovsegl1,l_fprovsegl2,l_fmodreglt,l_fstatut1,l_fstatut2,l_soccont,l_cav,l_numcont,l_fcentrefrais
            FROM  facture f 
            WHERE     f.socfact = p_socfact
                  AND f.numfact = RPAD(p_numfact,15)
                  AND f.typfact = p_typfact
                  AND f.datfact = TO_DATE(p_datfact,'DD/MM/YYYY'); 

 -- DBMS_OUTPUT.PUT_LINE(' --> apres lecture facture:' || l_fstatut1 || ';' || l_fprovsegl1  );
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                  pack_global.recuperer_message(20103, NULL, NULL, NULL, l_msg);
                  raise_application_error(-20103,l_msg);
           WHEN OTHERS THEN
                  raise_application_error(-20997,SQLERRM);
         END;

 -- DBMS_OUTPUT.PUT_LINE(' --> Verif statut:' || l_fstatut1 || ';' || l_fprovsegl1  );

         -- ================================
         -- Test OK pour modifier ?
         -- ================================
         IF    (l_fstatut1   = 'VA')   -- AND l_fprovsegl1 = '1')
            				--OR (l_fstatut2   = 'VA')    AND l_fprovsegl2 = '1')
            THEN  NULL; 
            ELSE  -- Message  Facture non validée par SEGL, correction impossible dans ce menu   
                  pack_global.recuperer_message(20128, NULL, NULL, NULL, l_msg);
                  raise_application_error(-20128,l_msg);
         END IF;


         -- =================================================================================
         -- Cas facture avec contrat : A-t-on la bonne filiale ? 
         -- =================================================================================
         IF l_numcont IS NOT NULL THEN
            pack_facture.verif_filiale_cont(l_soccont,l_cav,l_numcont,p_filcode,l_msg_cont,l_codsg,l_comcode);
            IF l_msg_cont IS NOT NULL THEN
               p_msg_info    :=  l_msg_cont ;
            END IF;
         END IF;
      END;     -- End bloc Test

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


      -- ===================================================
      -- OK Maintenant tout est bon, select de la facture 
      -- ===================================================
      p_nbcurseur := 1;
     
      BEGIN
      OPEN  p_curselect  FOR
         SELECT  s.soclib,
                 f.socfact,
                 f.numfact,
                 f.typfact,
                 TO_CHAR(f.datfact,'dd/mm/yyyy'),
                 TO_CHAR(f.faccsec,'dd/mm/yyyy'),
                 TO_CHAR(f.fnumasn,'FM999999999'),
                 TO_CHAR(f.fregcompta,'dd/mm/yyyy'),
                 TO_CHAR(f.fenvsec,'dd/mm/yyyy'),
                 DECODE(f.Fmodreglt,1,'Virement',2,'Prélèvement',3,'Chèque',8,'Annulation'),
                 TO_CHAR(f.fmontht,'FM99999999D00'),
                 TO_CHAR(f.fmontttc,'FM99999999D00'),
                 f.llibanalyt,
                 TO_CHAR(f.fmoiacompta,'mm/yyyy'),
                 f.fstatut1,
                 f.fstatut2,
                 f.fprovsdff1,
                 f.fprovsdff2,
                 f.fprovsegl1,
                 f.fprovsegl2,
                 f.fsocfour,
	rpad(a.socflib,25,' '),
	f.numcont,
        f.cav,
        TO_CHAR(f.fdeppole,'FM0000000'),
        TO_CHAR(f.ftva,'FM90D00'),
        TO_CHAR(f.flaglock,'FM9999999')
         FROM  facture f,agence a, societe s
         WHERE  f.socfact = s.soccode
            AND s.soccode = p_socfact
            AND f.numfact = p_numfact
            AND f.typfact = p_typfact
            AND f.datfact = TO_DATE(p_datfact,'DD/MM/YYYY') 
            AND s.soccode=a.soccode;
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN     -- Msg Aucune facture pour la sélection demandée
            pack_global.recuperer_message(20103, NULL, NULL, NULL, l_msg);
            raise_application_error(-20103,l_msg);
      
        WHEN OTHERS THEN
            raise_application_error(-20997,SQLERRM);
      END; -- End select 

END select_facture_segl;



-- ********************************************************************************************
-- ********************************************************************************************
--
-- select_ligne_segl 
--
-- ******************************************************************************************** 
-- ********************************************************************************************
   PROCEDURE select_ligne_segl (p_socfact    IN facture.socfact%TYPE,
                               p_soclib      IN societe.soclib%TYPE,
                               p_numcont     IN facture.numcont%TYPE,
                               p_cav         IN facture.cav%TYPE,
                               p_numfact     IN facture.numfact%TYPE,
                               p_typfact     IN facture.typfact%TYPE,
                               p_datfact     IN VARCHAR2,
                               p_fdeppole    IN VARCHAR2,      -- code fdeppole de la facture      
                               p_fmontht     IN VARCHAR2,      
                               p_ftva        IN VARCHAR2,      -- code comptable du contrat
                               p_fmontttc    IN VARCHAR2,
                               p_fsocfour    IN facture.fsocfour%TYPE,
                               p_fmoiacompta IN VARCHAR2,
                               p_clelf       IN VARCHAR2,
                               p_flaglock    IN VARCHAR2,
                               p_userid      IN VARCHAR2,
                               p_socfactout     OUT VARCHAR2,
                               p_soclibout      OUT VARCHAR2,
                               p_numcontout     OUT VARCHAR2,
                               p_cavout         OUT VARCHAR2,
                               p_numfactout     OUT VARCHAR2,
                               p_typfactout     OUT VARCHAR2,
                               p_datfactout     OUT VARCHAR2,
                               p_lnumout        OUT VARCHAR2,
                               p_identout       OUT VARCHAR2,
                               p_rnomout        OUT VARCHAR2,
                               p_rprenomout     OUT VARCHAR2,
                               p_lmonthtout     OUT VARCHAR2,
                               p_lmoisprestout  OUT VARCHAR2,
                               p_lcodcomptaout  OUT VARCHAR2,
                               p_fsocfourout    OUT VARCHAR2,
                               p_flaglockout    OUT VARCHAR2,
                               p_nbcurseur      OUT INTEGER,
                               p_message        OUT VARCHAR2
                              ) IS

      l_msg         VARCHAR2(1024) ;
      l_lnum        VARCHAR2(20);
      l_ident       VARCHAR2(20);
      l_rnom        VARCHAR2(40);
      l_rprenom     VARCHAR2(20);
      l_lmontht     VARCHAR2(20);
      l_lmoisprest  VARCHAR2(20);
      l_lcodcompta  VARCHAR2(50);
      l_typdpg CHAR(1);

   BEGIN
      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur   := 0;
      p_message     := '';
      p_flaglockout :=  p_flaglock;

     pack_liste_lignes_fact.xcle_ligne_fact(p_clelf, 1, 
            l_lnum, l_ident, l_rnom, l_rprenom,
            l_lmontht, l_lmoisprest,l_lcodcompta, l_typdpg) ;

        -- Cle retourne  lf.lnum(2);lf.ident(5);r.rnom(20);r.rprenom(15);
        --               lf.lmontht(11);lf.lmoisprest(7);lf.lcodcompta(11)

      p_socfactout     :=  p_socfact     ;
      p_soclibout      :=  p_soclib      ;
      p_numcontout     :=  p_numcont     ;
      p_cavout         :=  p_cav         ;
      p_numfactout     :=  p_numfact     ;
      p_typfactout     :=  p_typfact     ;
      p_datfactout     :=  p_datfact     ;

      p_lnumout        :=  l_lnum       ;
      p_identout       :=  l_ident      ;
      p_rnomout        :=  l_rnom       ;
      p_rprenomout     :=  l_rprenom    ;
      p_lmonthtout     :=  l_lmontht    ;
      p_lmoisprestout  :=  l_lmoisprest ;
      p_lcodcomptaout  :=  l_lcodcompta ;
      p_fsocfourout    :=  p_fsocfour ;
END select_ligne_segl;


-- ********************************************************************************************
-- ********************************************************************************************
--
-- update_ligne_segl 
--
-- 09/02/2000    QHL      ajout test mois/annee prestation < mois/annee courant
--
-- ******************************************************************************************** 
-- ********************************************************************************************
   PROCEDURE update_ligne_segl (p_socfact    IN facture.socfact%TYPE,
                               p_soclib      IN societe.soclib%TYPE,
                               p_numcont     IN facture.numcont%TYPE,
                               p_cav         IN facture.cav%TYPE,
                               p_numfact     IN facture.numfact%TYPE,
                               p_typfact     IN facture.typfact%TYPE,
                               p_datfact     IN VARCHAR2,
                               p_ident       IN VARCHAR2,
                               p_rnom        IN ressource.rnom%TYPE,
                               p_rprenom     IN ressource.rprenom%TYPE,
                               p_lmontht     IN VARCHAR2,
                               p_lmoisprest  IN VARCHAR2,
                               p_lcodcompta  IN VARCHAR2,
                               p_lnum        IN VARCHAR2,
                               p_fdeppole    IN VARCHAR2,
                               p_flaglock    IN VARCHAR2,
                               p_userid      IN VARCHAR2,
                               p_fdeppoleout    OUT VARCHAR2,
                               p_flaglockout    OUT VARCHAR2,
                               p_nbcurseur      OUT INTEGER,
                               p_message        OUT VARCHAR2
                              ) IS

      l_msg         VARCHAR2(1024) ;
      referential_integrity EXCEPTION;
      PRAGMA       EXCEPTION_INIT(referential_integrity, -2292);

   BEGIN
      p_nbcurseur := 0;
      p_message := '';
      p_flaglockout  :=  p_flaglock;
      p_fdeppoleout  :=  LPAD(p_fdeppole, 7, '0');
      -- =======================================
      -- Mise à jour du flaglock de la facture
      -- =======================================
      BEGIN
         UPDATE  facture
         SET    flaglock  = decode(p_flaglock, 1000000, 0, p_flaglock + 1)
         WHERE  socfact   = p_socfact
           AND  numfact   = p_numfact
           AND  typfact   = p_typfact
           AND  datfact   = TO_DATE(p_datfact,'DD/MM/YYYY') 
           AND  flaglock  = p_flaglock;

         IF SQL%NOTFOUND THEN  -- Acces concurrent
            pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
            raise_application_error( -20999, l_msg );
         END IF;

      EXCEPTION
         WHEN referential_integrity THEN 
            pack_global.recuperation_integrite(-2292);
         WHEN OTHERS THEN
               raise_application_error(-20997, SQLERRM);
      END;

      -- ===================================================
      -- Test Existence du code comptable dans CODE_COMPT
      -- ===================================================
      verif_codecompta(p_lcodcompta);


      -- ===================================================
      -- ajout kha 12/08/2004 fiche 210
      -- Test Mois Prestation  vs  Periode de validite du contrat
      -- ===================================================
      pack_ligne_fact.verif_periode_contrat(p_socfact, p_numcont, p_cav, p_lmoisprest);
      -- ===================================================
      -- Test Date Mois Prestation < Mois courant
      -- ===================================================
            IF  to_date(p_lmoisprest,'MM/YYYY') >= to_date((to_char(sysdate,'MM/YYYY')),'MM/YYYY')
         THEN -- Msg erreur Mois prestation doit etre strictement inferieur au mois courant
            pack_global.recuperer_message(20140,NULL, NULL, NULL, l_msg);
            raise_application_error( -20140, l_msg );
      END IF;

      -- ===============================================================
      -- OK on peut Modifier
      -- ===============================================================
      BEGIN
         UPDATE  ligne_fact
         SET   lmoisprest = TO_DATE(p_lmoisprest,'MM/YYYY'),
               lcodcompta = p_lcodcompta
         WHERE  socfact   = p_socfact
           AND  numfact   = p_numfact
           AND  typfact   = p_typfact
           AND  datfact   = TO_DATE(p_datfact,'DD/MM/YYYY') 
           AND  lnum      = p_lnum;

         IF SQL%NOTFOUND THEN  -- Acces concurrent
            pack_global.recuperer_message(20999,NULL, NULL, NULL, l_msg);
            raise_application_error( -20999, l_msg );
         ELSE                 -- Msg Ligne de Facture modifiée
            pack_global.recuperer_message(2204,NULL,NULL, NULL, l_msg);
            p_message := l_msg;
            p_flaglockout  := (p_flaglock + 1);
         END IF;


      EXCEPTION
         WHEN referential_integrity THEN
            pack_global.recuperation_integrite(-2292);
         WHEN OTHERS THEN
               raise_application_error(-20997, SQLERRM);
      END;
      

END update_ligne_segl;     

END pack_fact_segl;
/
