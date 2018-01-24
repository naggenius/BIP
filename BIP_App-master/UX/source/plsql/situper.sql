-- pack_situation_p PL/SQL
--
-- EQUIPE SOPRA
-- Attention le nom du package ne peut etre le nom de la table...
--
-- Cree le 18/02/1999
--  MAJ le
-- 11/04/2000	NCM
-- 29/11/2000	NCM :	ne pas contrôler que la société est fermée à partir de DIRMENU
-- 30/10/2001	NBM :	seules les prestation actives sont prises en compte (attribut top_actif='O')
-- 24/06/2003	NBM :	supression des param# pour les paramètres OUT +fiche 77(si IFo cout peut être=0)
-- 12/07/2004	EGR	:	F370 : retrait de filcode dans situ_ress et situ_ress_full
-- 22/04/2005   PPR :   Propagation du niveau lors des mises à jour de situation
-- Modifiée le 24/11/2005   par BAA  Fiche 257   Evolution du référentiel compétence / prestation dans la BIP
-- Modifiée le 10/08/2006  par BAA  FICHE 457  Mettre une log sur les ressources  
-- Modifiée le 25/09/2007 par JAL FICHE 563  Ajout de log.
-- Modifiée le 16/10/2007 par JAL FICHE 563  Ajout de commentaires dans logs et correction format champs identiques pour champs dans logs
-- Modifiée le 19/10/2007 par EVI FICHE 563  Formatage de la date dans le champs 'commentaire'
-- Modifiée le 03/06/2008 par EVI FICHE 652  Mise en place des ressource SLOT
-- Modifiée le 29/06/2010 par YNI Fiche 970
-- Modifiée le 18/07/2010 par YNI Fiche 970
-- Modifiée le 27/07/2010 par YSB Fiche 970
-- Modifiée le 02/08/2010 par YSB Fiche 970
-- Modifiée le 05/08/2010 par YSB Fiche 970
-- Modifiée le 12/08/2010 par YNI Fiche 970
-- Modifiée le 12/08/2010 par YSB Fiche 970
-- Modifiée le 15/09/2010 par ABA Fiche 970
-- Modifiée le 08/10/2010 par ABA Fiche 970
-- Modifiée le 02/11/2010 par CMA Fiche 989  Log du champ fident (Ident Forfait) lors des insert/update de situation
-- Modifiée le 13/01/2011 par ABA Fiche 1095
-- Modifiée le 14/02/2011 par CMA Fiche 857
-- Modifiée le 02/03/2012 par BSA Fiche 1321
-- Modifiée le 19/06/2012 par BSA Fiche 1286

CREATE OR REPLACE PACKAGE PACK_SITUATION_P AS

TYPE situation_s_ViewType IS RECORD (ident      VARCHAR2(20),
                                     rnom       RESSOURCE.rnom%TYPE,
                                     rprenom    RESSOURCE.rprenom%TYPE,
                                     matricule  RESSOURCE.matricule%TYPE,
                                     datsitu    VARCHAR2(20),
                                     datdep     VARCHAR2(20),
                                     codsg      VARCHAR2(20),
                                     --filcode    situ_ress.filcode%TYPE,
                                     soccode    SITU_RESS.soccode%TYPE,
									 p_niveau	SITU_RESS.NIVEAU%TYPE,
                                     PRESTATION SITU_RESS.PRESTATION%TYPE,
                                     cpident    VARCHAR2(20),
                                     rmcomp     VARCHAR2(20),
                                     dispo      VARCHAR2(20),
                                     cout       VARCHAR2(20),
                                     olddatsitu VARCHAR2(20),
                                     flaglock   VARCHAR2(20),
									 code_domaine    TYPE_DOMAINE.CODE_DOMAINE%TYPE,
                                     fident     NUMBER,
                                     igg        VARCHAR2(10)
                                    );

TYPE situationCurType IS REF CURSOR RETURN situation_s_ViewType;

   PROCEDURE insert_situation_p (p_oldatsitu  IN  VARCHAR2,
                                 p_rnom       IN  RESSOURCE.rnom%TYPE,
                                 p_ident      IN  VARCHAR2,
                                 p_rprenom    IN  RESSOURCE.rprenom%TYPE,
                                 p_matricule  IN  RESSOURCE.matricule%TYPE,
                                 p_datsitu    IN  VARCHAR2,
                                 p_datdep     IN  VARCHAR2,
                                 p_codsg      IN  VARCHAR2,
                                 --p_filcode    IN  situ_ress.filcode%TYPE,
                                 p_soccode    IN  SITU_RESS.soccode%TYPE,
                                 p_rmcomp     IN  VARCHAR2,
                                 p_prestation IN  SITU_RESS.PRESTATION%TYPE,
                                 p_dispo      IN  VARCHAR2,
                                 p_cpident    IN  VARCHAR2,
                                 p_cout       IN  VARCHAR2,
                                 p_flaglock   IN  NUMBER,
                                 p_userid     IN  VARCHAR2,
                                 p_fident     IN  NUMBER,
                                 p_mode_contractuelInd   IN VARCHAR2,
                                 p_mci_calcule  IN VARCHAR2,
                                 p_nbcurseur  OUT INTEGER,
                                 p_message    OUT VARCHAR2
                                );

   PROCEDURE update_situation_p (p_oldatsitu  IN  VARCHAR2,
                                 p_rnom       IN  RESSOURCE.rnom%TYPE,
                                 p_ident      IN  VARCHAR2,
                                 p_rprenom    IN  RESSOURCE.rprenom%TYPE,
                                 p_matricule  IN  RESSOURCE.matricule%TYPE,
                                 p_datsitu    IN  VARCHAR2,
                                 p_datdep     IN  VARCHAR2,
                                 p_codsg      IN  VARCHAR2,
                                 --p_filcode    IN  situ_ress.filcode%TYPE,
                                 p_soccode    IN  SITU_RESS.soccode%TYPE,
                                 p_rmcomp     IN  VARCHAR2,
                                 p_prestation IN  SITU_RESS.PRESTATION%TYPE,
                                 p_dispo      IN  VARCHAR2,
                                 p_cpident    IN  VARCHAR2,
                                 p_cout       IN  VARCHAR2,
                                 p_niveau     IN  VARCHAR2,
                                 p_flaglock   IN  NUMBER,
                                 p_userid     IN  VARCHAR2,
                                 p_fident     IN  NUMBER,
                                 p_mode_contractuelInd   IN VARCHAR2,
                                 p_mci_calcule  IN VARCHAR2,
                                 p_nbcurseur  OUT INTEGER,
                                 p_message    OUT VARCHAR2
                                );

   PROCEDURE delete_situation_p (p_rnom       IN  RESSOURCE.rnom%TYPE,
                                 p_ident      IN  VARCHAR2,
                                 p_rprenom    IN  RESSOURCE.rprenom%TYPE,
                                 p_matricule  IN  RESSOURCE.matricule%TYPE,
                                 p_datsitu    IN  VARCHAR2,
                                 p_datdep     IN  VARCHAR2,
                                 p_codsg      IN  VARCHAR2,
                                 --p_filcode    IN  situ_ress.filcode%TYPE,
                                 p_soccode    IN  SITU_RESS.soccode%TYPE,
                                 p_rmcomp     IN  VARCHAR2,
                                 p_prestation IN  SITU_RESS.PRESTATION%TYPE,
                                 p_dispo      IN  VARCHAR2,
                                 p_cpident    IN  VARCHAR2,
                                 p_cout       IN  VARCHAR2,
                                 p_flaglock   IN  NUMBER,
                                 p_userid     IN  VARCHAR2,
                                 p_fident      IN  NUMBER,
                                 p_nbcurseur  OUT INTEGER,
                                 p_message    OUT VARCHAR2
                                );

   PROCEDURE select_situation_p (p_mode        IN  VARCHAR2,
                                 p_rnom         IN  RESSOURCE.rnom%TYPE,
                                 p_ident        IN  VARCHAR2,
                                 p_rprenom      IN  RESSOURCE.rprenom%TYPE,
                                 p_matricule    IN  RESSOURCE.matricule%TYPE,
                                 p_datsitu      IN  VARCHAR2,
                                 p_flaglock     IN  VARCHAR2,
                                 p_userid       IN  VARCHAR2,
                                 p_cursituation IN OUT situationCurType,
                                 p_codsg        OUT VARCHAR2,
                                 p_soccode      OUT VARCHAR2,
					             p_niveau		OUT VARCHAR2,
                                 p_prestation   OUT VARCHAR2,
                                 p_cpident      OUT VARCHAR2,
                                 p_rmcomp       OUT VARCHAR2,
                                 p_dispo        OUT VARCHAR2,
                                 p_cout         OUT VARCHAR2,
								 p_dat          OUT VARCHAR2,
                                 p_flag         OUT VARCHAR2,
                                 p_nbcurseur    OUT INTEGER,
                                 p_message      OUT VARCHAR2,
								 p_code_domaine   OUT PRESTATION.CODE_DOMAINE%TYPE,
                                 p_fident       OUT NUMBER,
                                 p_mode_contractuelInd   OUT VARCHAR2,
                                 p_lib_mci      OUT VARCHAR2
                                );


-- Curseur permettant de ramener la liste des niveaux existants

TYPE niveau_ViewType IS RECORD ( NIVEAU VARCHAR2(2), LIBNIVEAU VARCHAR2(20)
);

TYPE  niveau_Curseur IS REF CURSOR RETURN  niveau_ViewType;



PROCEDURE select_liste_Niveaux( s_curseur 	IN OUT  niveau_Curseur);

FUNCTION verif_situ_ligcont(p_ident IN VARCHAR2,
                              p_soccont IN VARCHAR2,
                              p_lresdeb IN DATE,
                              p_lresfin IN DATE) RETURN NUMBER;

FUNCTION verif_situ_ligcont_rep(p_ident IN VARCHAR2,
                              p_soccont IN VARCHAR2,
                              p_lresdeb IN DATE,
                              p_lresfin IN DATE) RETURN VARCHAR2;

PROCEDURE select_mode_contractuel (p_mode     IN  VARCHAR2,
                                   p_ident    IN VARCHAR2,
                                   p_soccode  IN VARCHAR2,
                                   p_datsitu  IN VARCHAR2,
                                   p_datdep   IN VARCHAR2,
                               p_mode_contractuel_in IN VARCHAR2,
                                   p_mode_contractuel IN OUT VARCHAR2);



END Pack_Situation_P;
/


CREATE OR REPLACE PACKAGE BODY     PACK_SITUATION_P AS
   PROCEDURE insert_situation_p (p_oldatsitu  IN  VARCHAR2,
                                 p_rnom       IN  RESSOURCE.rnom%TYPE,
                                 p_ident      IN  VARCHAR2,
                                 p_rprenom    IN  RESSOURCE.rprenom%TYPE,
                                 p_matricule  IN  RESSOURCE.matricule%TYPE,
                                 p_datsitu    IN  VARCHAR2,
                                 p_datdep     IN  VARCHAR2,
                                 p_codsg      IN  VARCHAR2,
                                 --p_filcode    IN  situ_ress.filcode%TYPE,
                                 p_soccode    IN  SITU_RESS.soccode%TYPE,
                                 p_rmcomp     IN  VARCHAR2,
                                 p_prestation IN  SITU_RESS.PRESTATION%TYPE,
                                 p_dispo      IN  VARCHAR2,
                                 p_cpident    IN  VARCHAR2,
                                 p_cout       IN  VARCHAR2,
                                 p_flaglock   IN  NUMBER,
                                 p_userid     IN  VARCHAR2,
                                 p_fident     IN  NUMBER,
                                 p_mode_contractuelInd   IN VARCHAR2,
                                 p_mci_calcule  IN VARCHAR2,
                                 p_nbcurseur  OUT INTEGER,
                                 p_message    OUT VARCHAR2
                                ) IS

      l_msg           VARCHAR2(1024);
      l_ncodsg        SITU_RESS.codsg%TYPE;
      l_dsocfer       VARCHAR2(20);
      l_ncpident      SITU_RESS.cpident%TYPE;
      l_date_courante VARCHAR2(20);
      l_datval        VARCHAR2(20);
      l_datfin        VARCHAR2(20);
      l_datval1       VARCHAR2(20);
      l_datfin1       VARCHAR2(20);
      l_datvalnext    VARCHAR2(20);
      datval          VARCHAR2(20);
      datfin          VARCHAR2(20);
      l_odatval       NUMBER;
      l_mode_contractuelInd VARCHAR2(20);

      l_menu          VARCHAR2(255);
      l_prest         PRESTATION.PRESTATION%TYPE;
      l_topfer        STRUCT_INFO.topfer%TYPE;
      l_niveau        SITU_RESS.NIVEAU%TYPE;
      l_flaglock      RESSOURCE.flaglock%TYPE;
      l_habilitation VARCHAR2(10);
	  l_codbr NUMBER(2);

      CURSOR curdate IS
	SELECT TO_CHAR(datsitu,'yyyymmdd') ,TO_CHAR(datdep,'yyyymmdd')
	FROM SITU_RESS
	WHERE ident=TO_NUMBER(p_ident);

      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

	  l_user		RESSOURCE_LOGS.user_log%TYPE;

	  v_datdep       				RESSOURCE_LOGS.VALEUR_PREC%TYPE;
	  v_codsg         				RESSOURCE_LOGS.VALEUR_PREC%TYPE;
	  v_soccode    	  		     RESSOURCE_LOGS.VALEUR_PREC%TYPE;
	  v_PRESTATION       RESSOURCE_LOGS.VALEUR_PREC%TYPE;
	  v_dispo 			 			 RESSOURCE_LOGS.VALEUR_PREC%TYPE;
	  v_cpident 					RESSOURCE_LOGS.VALEUR_PREC%TYPE;
	  v_cout  						    RESSOURCE_LOGS.VALEUR_PREC%TYPE;


   BEGIN

       -- regle 4 non prise en compte.
       -- Positionner le nb de curseurs ==> 0
       -- Initialiser le message retour

       p_nbcurseur := 0;
       p_message := '';
       l_flaglock := p_flaglock;


	     l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

       -- test mode contractuel sauf pour les mci calcule


        IF (  p_soccode != 'SG..' AND NVL(p_mci_calcule,'-1') != 'O' ) then

            BEGIN
                SELECT code_contractuel
                INTO l_mode_contractuelInd
                FROM mode_contractuel
                WHERE code_contractuel = p_mode_contractuelInd
                and top_actif = 'O'
                and (type_ressource = (select rtype from ressource where ident = p_ident) or
                type_ressource = '*');

            EXCEPTION

                 WHEN NO_DATA_FOUND THEN
                   Pack_Global.recuperer_message( 21196, null, null, null, l_msg);
                   RAISE_APPLICATION_ERROR(-20226, l_msg);

                 WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
            END;

        END IF;
 --   END IF;

      -- ====================================================================
      -- 8/02/2001 : Test appartenance du DPG au périmètre de l'utilisateur
      -- ====================================================================
     	l_habilitation := Pack_Habilitation.fhabili_me( p_codsg,p_userid   );
	IF l_habilitation='faux' THEN
		-- Vous n'êtes pas habilité à ce DPG 20364
		Pack_Global.recuperer_message(20364, '%s1', 'à ce DPG', 'CODSG', l_msg);
                RAISE_APPLICATION_ERROR(-20364, l_msg);
	END IF;

      -- TEST : PRESTATION = MO ou GRA

      IF p_prestation != 'MO' AND p_prestation != 'GRA' AND p_prestation != 'IFO' AND p_prestation != 'STA' AND p_prestation != 'INT' THEN
         IF (p_cout = ',00' OR p_cout = '0,00' OR p_cout IS NULL) AND (p_soccode <> 'SG..') THEN
            Pack_Global.recuperer_message(20247, NULL, NULL, 'COUT', l_msg);
            RAISE_APPLICATION_ERROR(-20247, l_msg);
         END IF;
      END IF;

       -- TEST : RMCOMP doit etre = 0 ou 1

      -- IF (p_rmcomp != 0) AND (p_rmcomp != 1) THEN
         -- Pack_Global.recuperer_message(20275, NULL, NULL, 'RMCOMP', l_msg);
         -- RAISE_APPLICATION_ERROR(-20275, l_msg);
      -- END IF;

      -- TEST : 0< DISPO < 7

      IF (TO_NUMBER(p_dispo) < 0) OR (TO_NUMBER(p_dispo) > 7) THEN
           Pack_Global.recuperer_message(20248, NULL, NULL, 'COUT', l_msg);
           RAISE_APPLICATION_ERROR(-20248, l_msg);
      END IF;

      -- TEST : Il doit exister ds cout_pres un codprest pour l'annee d'arrive de la personne


      -- TEST : Gestion de l'utilisateur pour cout (RES)

      l_menu := Pack_Global.lire_globaldata(p_userid).menutil;

      IF l_menu != 'DIR' THEN

	BEGIN
          SELECT PRESTATION
          INTO l_prest
          FROM PRESTATION
          WHERE UPPER(top_actif)='O'
          AND PRESTATION = p_prestation;

      EXCEPTION

           WHEN NO_DATA_FOUND THEN
             Pack_Global.recuperer_message(20246, '%s1', p_prestation, 'PRESTATION', l_msg);
             RAISE_APPLICATION_ERROR(-20246, l_msg);

           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997,SQLERRM);
      END;

      END IF;

      -- TEST : TOPFER de codsg si menutil != DIR

      IF l_menu != 'DIR' THEN

         BEGIN
            SELECT topfer
            INTO   l_topfer
            FROM   STRUCT_INFO
            WHERE  codsg = TO_NUMBER(p_codsg);

         EXCEPTION

            WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20203, NULL, NULL, 'CODSG', l_msg);
               RAISE_APPLICATION_ERROR(-20203, l_msg);

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;

         IF l_topfer = 'F' THEN
             Pack_Global.recuperer_message(20274, NULL, NULL, 'CODSG', l_msg);
             RAISE_APPLICATION_ERROR(-20274, l_msg);
         END IF;

      END IF;


       -- TEST : codsg > 1

      IF TO_NUMBER(p_codsg) <= 1 THEN
            Pack_Global.recuperer_message( 20223, NULL, NULL, 'CODSG', l_msg);
            RAISE_APPLICATION_ERROR(-20223, l_msg);
      END IF;

      -- TEST : soccode existe et societe non fermee.
     IF l_menu != 'DIR' THEN

      BEGIN
           SELECT TO_CHAR(socfer,'yyyymmdd')
           INTO   l_dsocfer
           FROM   SOCIETE
           WHERE  soccode = p_soccode;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
             Pack_Global.recuperer_message( 20225, '%s1', p_soccode, 'SOCCODE', l_msg);
             RAISE_APPLICATION_ERROR(-20225, l_msg);

         WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      SELECT TO_CHAR(SYSDATE,'yyyymmdd')
      INTO l_date_courante
      FROM DUAL;

      IF l_dsocfer <= l_date_courante THEN
             Pack_Global.recuperer_message( 20225, '%s1', p_soccode, 'SOCCODE', l_msg);
             RAISE_APPLICATION_ERROR(-20225, l_msg);
      END IF;
     END IF;
      -- TEST : cpident existe

      BEGIN
          SELECT ident
          INTO l_ncpident
          FROM RESSOURCE
          WHERE ident = TO_NUMBER(p_cpident);

      EXCEPTION

           WHEN NO_DATA_FOUND THEN
             Pack_Global.recuperer_message( 20226, '%s1', p_cpident, 'CPIDENT', l_msg);
             RAISE_APPLICATION_ERROR(-20226, l_msg);

           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

    -- TD 652 TEST : fident existe @../source/plsql/tp/societe.sql un forfait F ou E
    IF p_fident IS NOT NULL THEN
      BEGIN
          SELECT ident
          INTO l_ncpident
          FROM RESSOURCE
          WHERE ident = TO_NUMBER(p_fident)
          AND (rtype='F' OR rtype='E');

      EXCEPTION

           WHEN NO_DATA_FOUND THEN
             Pack_Global.recuperer_message( 21112, '%s1', p_fident, 'FIDENT', l_msg);
             RAISE_APPLICATION_ERROR(-20226, l_msg);

           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;
     END IF;
-- -------------------------------------------------------------------------------------
-- CONTROLES DE DATES
-- -------------------------------------------------------------------------------------
-- Recherche si la date de valeur existe déjà
  SELECT COUNT(datsitu) INTO l_odatval
  FROM SITU_RESS
  WHERE ident=TO_NUMBER(p_ident)
	AND TO_CHAR(datsitu,'mm/yyyy')=p_datsitu;
IF l_odatval=1 THEN
	SELECT SUBSTR(TO_CHAR(datsitu,'dd/mm/yyyy'),1,2) INTO l_datval
	FROM SITU_RESS
	WHERE ident=TO_NUMBER(p_ident)
	AND   TO_CHAR(datsitu,'mm/yyyy')=p_datsitu ;
	-- Impossible de créer une autre situation dans le même mois
	IF l_datval!='01' THEN
		Pack_Global.recuperer_message(20322, NULL, NULL, 'DATSITU', l_msg);
      		RAISE_APPLICATION_ERROR(-20322, l_msg);
		p_message := l_msg;
   	END IF;
END IF;

l_datval:=TO_CHAR(TO_DATE(p_datsitu,'mm/yyyy'),'yyyymm')||'01';
l_datfin:=TO_CHAR(TO_DATE(p_datdep,'dd/mm/yyyy'),'yyyymmdd') ;


---------------------------------------------------------------------------
-- La date de valeur est toujours inférieure à la date de départ
---------------------------------------------------------------------------
IF (p_datdep IS NOT NULL) THEN

	IF l_datval>l_datfin THEN
    		Pack_Global.recuperer_message(20227, NULL, NULL, 'DATSITU', l_msg);
      	     	RAISE_APPLICATION_ERROR(-20227, l_msg);
		p_message := l_msg;
	END IF;
END IF;

-- Recherche de la date de départ la plus récente
-- En profite pour récupérer le niveau
SELECT TO_CHAR(datdep,'yyyymmdd'), NIVEAU INTO l_datfin1, l_niveau
FROM SITU_RESS
WHERE datsitu=(SELECT MAX(datsitu)
		FROM SITU_RESS
		WHERE 	ident=TO_NUMBER(p_ident))
AND	ident=TO_NUMBER(p_ident);

-- Recherche de la date de valeur la plus récente
SELECT MAX(TO_CHAR(datsitu,'yyyymmdd')) INTO l_datval1
FROM SITU_RESS
WHERE ident=TO_NUMBER(p_ident);


------------------------------------------------------------------------------------
-- 1) Cas d'une situation intermédiaire ou antérieure à la plus ancienne situation
------------------------------------------------------------------------------------
IF  l_datval<l_datval1 THEN                    /* Cas d'une situation intermédiaire */
  -- La date de départ est obligatoire
  IF l_datfin IS NULL THEN
	Pack_Global.recuperer_message(20441, NULL, NULL, 'DATDEP', l_msg);
      		RAISE_APPLICATION_ERROR(-20441, l_msg);
		p_message := l_msg;
  END IF;

  ---------------------------------------------------------------------------------------
  -- Vérification de la validité des dates (non comprises dans des situations existantes)
  ---------------------------------------------------------------------------------------
  OPEN curdate;
  LOOP
	FETCH curdate INTO datval,datfin;
	-- la date de valeur se trouve entre les dates d'une situation existante
	IF (l_datval > datval AND  l_datval<=datfin)   THEN
		Pack_Global.recuperer_message(20320, NULL, NULL, 'DATSITU', l_msg);
      		RAISE_APPLICATION_ERROR(-20320, l_msg);
		p_message := l_msg;
	END IF;
	-- la date de depart se trouve entre les dates d'une situation existante
	IF  (l_datfin >=datval AND l_datfin<=datfin ) THEN
	    IF l_odatval<1 THEN
		Pack_Global.recuperer_message(20321, NULL, NULL, 'DATDEP', l_msg);
      		RAISE_APPLICATION_ERROR(-20321, l_msg);
		p_message := l_msg;
	    END IF;
	END IF;
	EXIT WHEN curdate%NOTFOUND;

  END LOOP;
  CLOSE curdate;

  -- Recherche de la date de valeur qui suit la date de valeur saisie
  SELECT MIN(TO_CHAR(datsitu,'yyyymmdd')) INTO l_datvalnext
  FROM SITU_RESS
  WHERE TO_CHAR(datsitu,'yyyymmdd')>l_datval
	AND ident=TO_NUMBER(p_ident);


  ---------------------------------------------------------------------------------------------
  -- La situation  entre la date de valeur et celle de départ ne doit pas chevaucher
  -- les situations existantes
  -- ie la date de départ doit etre inférieure à la date de valeur de la situation postérieure
  ---------------------------------------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('datedep : '||l_datfin||', datval: '||l_datval);
IF (l_datfin>=l_datvalnext)  THEN
	Pack_Global.recuperer_message(20321, NULL,NULL, 'DATDEP', l_msg);
      	RAISE_APPLICATION_ERROR(-20321, l_msg);
	p_message := l_msg;
  END IF;

END IF;

---------------------------------------------------------------------
-- 2) Cas où d'une situation qui suit la situation la plus récente
---------------------------------------------------------------------
IF (l_datval>l_datval1)  THEN
  IF (l_datfin1 IS NULL) THEN
	-- La date de départ la plus récente est égale à la date de valeur saisie-1jour
	BEGIN
		UPDATE SITU_RESS
		SET datdep=(TO_DATE(p_datsitu,'mm/yyyy')-1)
		WHERE datsitu= (SELECT MAX(datsitu)
				FROM SITU_RESS
				WHERE ident=TO_NUMBER(p_ident))
			AND ident=TO_NUMBER(p_ident);
	EXCEPTION
		WHEN referential_integrity THEN
			Pack_Global.recuperation_integrite(-2291);
		WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR(-20997,SQLERRM);
	END;
	-- Mise à jour de ressource
	BEGIN
		UPDATE RESSOURCE
		SET flaglock=DECODE(l_flaglock,1000000,0,l_flaglock+1)
		WHERE flaglock=l_flaglock
			AND ident= TO_NUMBER(p_ident);
	EXCEPTION
		WHEN referential_integrity THEN
			Pack_Global.recuperation_integrite(-2291);
		WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR(-20997,SQLERRM);
	END;
	l_flaglock:=l_flaglock+1;
  ELSE
	IF l_datval<=l_datfin1 THEN
		Pack_Global.recuperer_message(20320, NULL, NULL, 'DATSITU', l_msg);
      		RAISE_APPLICATION_ERROR(-20320, l_msg);
		p_message := l_msg;
	END IF;
  END IF;

END IF;


 /* la date de valeur n'existe pas */
IF l_odatval<1 THEN

	BEGIN
		INSERT INTO SITU_RESS (ident,
                                            datsitu,
                                            datdep,
                                            codsg,
                                            --filcode,
                                            soccode,
                                            rmcomp,
                                            PRESTATION,
                                            dispo,
                                            cpident,
                                            cout,
                                            NIVEAU,
                                            FIDENT,
                                            mode_contractuel_indicatif
                                           )
                      VALUES (TO_NUMBER(p_ident),
                              TO_DATE(p_datsitu,'mm/yyyy'),
                              TO_DATE(p_datdep,'dd/mm/yyyy'),
                              TO_NUMBER(p_codsg),
                              --p_filcode,
                              p_soccode,
                              NVL(TO_NUMBER(p_rmcomp),0),
                              p_prestation,
                              TO_NUMBER(p_dispo,'FM9D0'),
                              p_cpident,
                              TO_NUMBER(p_cout),
                              l_niveau,
                              TO_NUMBER(p_fident),
                              p_mode_contractuelInd
                             );


			-- On loggue le nom, prenom et matricule  dans la table situ_ress
      Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Datsitu', NULL, p_datsitu, 'Création de la situation ecran création situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Datdep', NULL, p_datdep, 'Création de la situation ecran création situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'DPG', NULL, p_codsg, 'Création de la situation ecran création situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Societe', NULL, p_soccode, 'Création de la situation ecran création situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Prestation', NULL, p_prestation, 'Création de la situation ecran création situation');
        if(p_prestation='SLT')THEN
            Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Ident Forfait', NULL, p_fident, 'Création de la situation ecran création situation');
        END IF;
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Disponibilité', NULL, p_dispo, 'Création de la situation ecran création situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Chet de projet', NULL, p_cpident, 'Création de la situation ecran création situation');
      Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Coût', NULL, p_cout, 'Création de la situation ecran création situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Niveau', NULL, l_niveau, 'Création de la situation ecran création situation');
      Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'mode_contractuel_indicatif', NULL, p_mode_contractuelInd, 'Création de la situation ecran création situation');



                   EXCEPTION
                         WHEN DUP_VAL_ON_INDEX THEN
                              -- 'la ressource existe deja'
                              Pack_Global.recuperer_message(20219, NULL, NULL, NULL, l_msg);
                              RAISE_APPLICATION_ERROR( -20219, l_msg );
                         WHEN referential_integrity THEN
                              -- habiller le msg erreur
                              Pack_Global.recuperation_integrite(-2291);
                         WHEN OTHERS THEN
                              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
        END;

/* La date de valeur existe déjà */
ELSE
	BEGIN


	SELECT  TO_CHAR(datdep,'dd/mm/yyyy'), codsg, soccode, PRESTATION, dispo, cpident, cout, mode_contractuel_indicatif
	INTO v_datdep, v_codsg, v_soccode, v_PRESTATION, v_dispo, v_cpident, v_cout, l_mode_contractuelInd
	FROM SITU_RESS
    WHERE ident = TO_NUMBER(p_ident)
     AND TO_CHAR(datsitu,'yyyymmdd') = l_datval;


		UPDATE SITU_RESS SET  datdep     = TO_DATE(p_datdep,'dd/mm/yyyy'),
                                     codsg      = TO_NUMBER(p_codsg),
                                     --filcode    = p_filcode,
                                     soccode    = p_soccode,
                                     rmcomp     = NVL(TO_NUMBER(p_rmcomp),0),
                                     PRESTATION = p_prestation,
                                     dispo      = TO_NUMBER(p_dispo,'FM9D0'),
                                     cpident    = TO_NUMBER(p_cpident),
                                     cout       = TO_NUMBER(p_cout),
                                     fident     = TO_NUMBER(p_fident),
                                     mode_contractuel_indicatif = p_mode_contractuelInd
                WHERE ident = TO_NUMBER(p_ident)
                AND TO_CHAR(datsitu,'yyyymmdd') = l_datval;



		  -- On loggue le nom, prenom et matricule  dans la table situ_ress
      Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Datdep', v_datdep, p_datdep, 'Création de la situation ecran situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'DPG', v_codsg, p_codsg, 'Création de la situation ecran situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Societe', v_soccode, p_soccode, 'Création de la situation ecran situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Prestation', v_prestation, p_prestation, 'Création de la situation ecran situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Disponibilité', v_dispo, TO_NUMBER(p_dispo,'FM9D0'), 'Création de la situation ecran situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Chet de projet', v_cpident, p_cpident, 'Création de la situation ecran situation');
      Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Coût', TO_CHAR( TO_NUMBER(v_cout),'FM99999999D00') , p_cout , 'Création de la situation ecran situation');
      Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'mode_contractuel_indicatif', l_mode_contractuelInd , p_mode_contractuelInd , 'Création de la situation ecran situation');



             EXCEPTION
                WHEN referential_integrity THEN
                    -- habiller le msg erreur
                    Pack_Global.recuperation_integrite(-2291);
                WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR( -20997, SQLERRM);
             END;

             BEGIN
                 UPDATE RESSOURCE
                 SET    flaglock = DECODE(l_flaglock, 1000000, 0, l_flaglock + 1)
                 WHERE  flaglock = l_flaglock
                 AND    ident = TO_NUMBER(p_ident);

             EXCEPTION
                WHEN referential_integrity THEN
                    -- habiller le msg erreur
                    Pack_Global.recuperation_integrite(-2291);
                 WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
             END;

             IF SQL%NOTFOUND THEN
                Pack_Global.recuperer_message(20999, NULL, NULL, NULL, l_msg);
                RAISE_APPLICATION_ERROR(-20999, l_msg);
             END IF;
END IF;




    -- Message : 'situation Personne || p_rnom || creee';

	IF(p_soccode='SG..')THEN

	          Pack_Global.recuperer_message(21054,'%s1','l''agent SG', '%s2', p_ident, NULL, l_msg);
              p_message := l_msg;

	 ELSE

              Pack_Global.recuperer_message(21054, '%s1','la prestation','%s2', p_ident, NULL, l_msg);
              p_message := p_message ||'\n'||l_msg;

	END IF;

 END insert_situation_p;



---------------------------------------------------------------------------------------
-- Procédure de modification d'une situation
---------------------------------------------------------------------------------------
   PROCEDURE update_situation_p (p_oldatsitu  IN  VARCHAR2,
                                 p_rnom       IN  RESSOURCE.rnom%TYPE,
                                 p_ident      IN  VARCHAR2,
                                 p_rprenom    IN  RESSOURCE.rprenom%TYPE,
                                 p_matricule  IN  RESSOURCE.matricule%TYPE,
                                 p_datsitu    IN  VARCHAR2,
                                 p_datdep     IN  VARCHAR2,
                                 p_codsg      IN  VARCHAR2,
                                 --p_filcode    IN  situ_ress.filcode%TYPE,
                                 p_soccode    IN  SITU_RESS.soccode%TYPE,
                                 p_rmcomp     IN  VARCHAR2,
                                 p_prestation IN  SITU_RESS.PRESTATION%TYPE,
                                 p_dispo      IN  VARCHAR2,
                                 p_cpident    IN  VARCHAR2,
                                 p_cout       IN  VARCHAR2,
                                 p_niveau     IN  VARCHAR2,
                                 p_flaglock   IN  NUMBER,
                                 p_userid     IN  VARCHAR2,
                                 p_fident     IN  NUMBER,
                                 p_mode_contractuelInd   IN VARCHAR2,
                                 p_mci_calcule  IN VARCHAR2,
                                 p_nbcurseur  OUT INTEGER,
                                 p_message    OUT VARCHAR2
                                ) IS

l_msg           VARCHAR2(1024);
l_ncodsg        SITU_RESS.codsg%TYPE;
l_ncpident      SITU_RESS.cpident%TYPE;
l_dsocfer       VARCHAR2(20);
l_date_courante VARCHAR2(20);
l_datval        VARCHAR2(20);
l_oldatval      VARCHAR2(20);
l_datfin        VARCHAR2(20);
l_prest         PRESTATION.PRESTATION%TYPE;
l_menu          VARCHAR2(255);
l_topfer        STRUCT_INFO.topfer%TYPE;
l_datvalnext    VARCHAR2(20);
l_oldatdep  VARCHAR2(20);
l_datval1  VARCHAR2(20);
l_mode_contractuelInd VARCHAR2(20);

datval VARCHAR2(20);
datfin VARCHAR2(20);
CURSOR curdatval IS
	SELECT TO_CHAR(datsitu,'yyyymmdd') ,TO_CHAR(datdep,'yyyymmdd')
	FROM SITU_RESS
	WHERE ident=TO_NUMBER(p_ident)
	AND    TO_CHAR(datsitu,'dd/mm/yyyy')!=p_oldatsitu;

      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

	    l_user		RESSOURCE_LOGS.user_log%TYPE;

	  v_datdep       				  RESSOURCE_LOGS.VALEUR_PREC%TYPE;
	  v_codsg         				   RESSOURCE_LOGS.VALEUR_PREC%TYPE;
	  v_soccode    	  				RESSOURCE_LOGS.VALEUR_PREC%TYPE;
	  v_PRESTATION          RESSOURCE_LOGS.VALEUR_PREC%TYPE;
      v_fident          RESSOURCE_LOGS.VALEUR_PREC%TYPE;
	  v_dispo 			 				RESSOURCE_LOGS.VALEUR_PREC%TYPE;
	  v_cpident 					   RESSOURCE_LOGS.VALEUR_PREC%TYPE;
	  v_cout  							  RESSOURCE_LOGS.VALEUR_PREC%TYPE;
	  v_niveau  					   RESSOURCE_LOGS.VALEUR_PREC%TYPE;

   BEGIN

       -- REGLE non respecte : 9.12.5 regle 4 gestion utilisateur.
       -- Positionner le nb de curseurs ==> 0
       -- Initialiser le message retour

       p_nbcurseur := 0;
       p_message := '';

	   l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

    -- test mode contractuel sauf pour les mci calcule


        IF (  p_soccode != 'SG..' AND NVL(p_mci_calcule,'-1') != 'O' )  then

            BEGIN
                SELECT code_contractuel
                INTO l_mode_contractuelInd
                FROM mode_contractuel
                WHERE code_contractuel = p_mode_contractuelInd
                and top_actif = 'O'
                and (type_ressource = (select rtype from ressource where ident = p_ident)
                or type_ressource = '*');

            EXCEPTION

                 WHEN NO_DATA_FOUND THEN
                   Pack_Global.recuperer_message( 21196, null, null, null, l_msg);
                   RAISE_APPLICATION_ERROR(-20226, l_msg);

                 WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
            END;
        END IF;

 --   END IF;

       -- TEST COUT obligatoire si p_prestation n est pas MO,GRA,STA,IFO,INT

      IF p_prestation != 'MO' AND p_prestation != 'GRA'AND p_prestation != 'IFO' AND p_prestation != 'STA' AND p_prestation != 'INT'THEN
         IF (p_cout = ',00' OR p_cout = '0,00' OR p_cout IS NULL) AND (p_soccode <> 'SG..') THEN
            Pack_Global.recuperer_message(20247, NULL, NULL, 'COUT', l_msg);
            RAISE_APPLICATION_ERROR(-20247, l_msg);
         END IF;
      END IF;

       -- TEST : RMCOMP doit etre = 0 ou 1

  --    IF (p_rmcomp != 0) AND (p_rmcomp != 1) THEN
     --     Pack_Global.recuperer_message(20275, NULL, NULL, 'RMCOMP', l_msg);
         -- RAISE_APPLICATION_ERROR(-20275, l_msg);
      -- END IF;

       -- TEST : 0< DISPO < 7

       IF (TO_NUMBER(p_dispo) < 0) OR (TO_NUMBER(p_dispo) > 7) THEN
          Pack_Global.recuperer_message(20248, NULL, NULL, 'COUT', l_msg);
          RAISE_APPLICATION_ERROR(-20248, l_msg);
       END IF;

       -- TEST : Il doit exister ds cout_pres le codprest pour l'annee d'arrive de la personne
	l_menu := Pack_Global.lire_globaldata(p_userid).menutil;

      	IF l_menu != 'DIR' THEN

		BEGIN
        	   	SELECT PRESTATION
           		INTO l_prest
           		FROM PRESTATION
           		WHERE UPPER(top_actif)='O'
           		AND PRESTATION = p_prestation;

       		EXCEPTION

            	WHEN NO_DATA_FOUND THEN
              	Pack_Global.recuperer_message(20246, '%s1', p_prestation, 'PRESTATION', l_msg);
              	RAISE_APPLICATION_ERROR(-20246, l_msg);

            	WHEN OTHERS THEN
               	RAISE_APPLICATION_ERROR( -20997,SQLERRM);
       		END;
	END IF;
       -- TEST : codsg > 1

      IF TO_NUMBER(p_codsg) <= 1 THEN
            Pack_Global.recuperer_message(20223, NULL, NULL, 'CODSG', l_msg);
            RAISE_APPLICATION_ERROR(-20223, l_msg);
      END IF;

      -- TEST : TOPFER de codsg si menutil = DIR

      l_menu := Pack_Global.lire_globaldata(p_userid).menutil;

      IF l_menu != 'DIR' THEN

         BEGIN
            SELECT topfer
            INTO   l_topfer
            FROM   STRUCT_INFO
            WHERE  codsg = TO_NUMBER(p_codsg);

         EXCEPTION

            WHEN NO_DATA_FOUND THEN
               Pack_Global.recuperer_message(20203, NULL, NULL, 'CODSG', l_msg);
               RAISE_APPLICATION_ERROR(-20203, l_msg);

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;

         IF l_topfer = 'F' THEN
             Pack_Global.recuperer_message(20274, NULL, NULL, 'CODSG', l_msg);
             RAISE_APPLICATION_ERROR(-20274, l_msg);
         END IF;

      END IF;

      -- TEST : soccode existe et societe non fermee.
      IF l_menu != 'DIR' THEN
      BEGIN
           SELECT TO_CHAR(socfer,'yyyymmdd')
           INTO l_dsocfer
           FROM SOCIETE
           WHERE soccode = p_soccode;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
             Pack_Global.recuperer_message(20225, '%s1', p_soccode, 'SOCCODE', l_msg);
             RAISE_APPLICATION_ERROR(-20225, l_msg);

         WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, l_msg);

      END;

      SELECT TO_CHAR(SYSDATE,'yyyymmdd')
      INTO l_date_courante
      FROM DUAL;

      IF l_dsocfer <= l_date_courante THEN
             Pack_Global.recuperer_message(20225, '%s1', p_soccode, 'SOCCODE', l_msg);
             RAISE_APPLICATION_ERROR(-20225, l_msg);
      END IF;
      END IF;
      -- TEST : cpident existe

      BEGIN
          SELECT ident
          INTO l_ncpident
          FROM RESSOURCE
          WHERE ident = TO_NUMBER(p_cpident);

      EXCEPTION

           WHEN NO_DATA_FOUND THEN
             Pack_Global.recuperer_message(20226, '%s1', p_cpident, 'CPIDENT', l_msg);
             RAISE_APPLICATION_ERROR(-20226, l_msg);

           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR ( -20997, SQLERRM);
      END;

    -- TD 652 TEST : fident existe @../source/plsql/tp/sous_typo.sql un forfait F ou E
IF p_fident IS NOT NULL THEN
      BEGIN
          SELECT ident
          INTO l_ncpident
          FROM RESSOURCE
          WHERE ident = TO_NUMBER(p_fident)
          AND (rtype='F' OR rtype='E');

      EXCEPTION

           WHEN NO_DATA_FOUND THEN
             Pack_Global.recuperer_message( 21112, '%s1', p_fident, 'FIDENT', l_msg);
             RAISE_APPLICATION_ERROR(-20226, l_msg);

           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;
     END IF;
--------------------------------------------------
-- CONTROLE DES DATES
-- MAJ le 10/04/2000 par NCM
---------------------------------------------------
l_datval:=TO_CHAR(TO_DATE(p_datsitu,'mm/yyyy'),'yyyymm');
l_oldatval:=TO_CHAR(TO_DATE(p_oldatsitu,'dd/mm/yyyy'),'yyyymm');
IF l_datval=l_oldatval THEN
	l_oldatval:=TO_CHAR(TO_DATE(p_oldatsitu,'dd/mm/yyyy'),'yyyymmdd');
	l_datval:=l_oldatval;
ELSE
	l_oldatval:=TO_CHAR(TO_DATE(p_oldatsitu,'dd/mm/yyyy'),'yyyymmdd');
	l_datval:=TO_CHAR(TO_DATE(p_datsitu,'mm/yyyy'),'yyyymm')||'01';
END IF;

---------------------------------------------------------------------------
-- La date de valeur est toujours inférieure à la date de départ
---------------------------------------------------------------------------
l_datfin:=TO_CHAR(TO_DATE(p_datdep,'dd/mm/yyyy'),'yyyymmdd') ;

IF (p_datdep IS NOT NULL) THEN
	IF l_datval>l_datfin THEN
    		Pack_Global.recuperer_message(20227, NULL, NULL, 'DATSITU', l_msg);
      	     	RAISE_APPLICATION_ERROR(-20227, l_msg);
		p_message := l_msg;
	END IF;
END IF;

DBMS_OUTPUT.PUT_LINE('old: '||l_oldatval||' , new: '||l_datval);

-- Recherche de la date de valeur la plus récente
SELECT MAX(TO_CHAR(datsitu,'yyyymmdd')) INTO l_datval1
FROM SITU_RESS
WHERE ident=TO_NUMBER(p_ident);

IF  l_datval<l_datval1 THEN                    /* Cas d'une situation intermédiaire */
  -- La date de départ est obligatoire
  IF l_datfin IS NULL THEN
	Pack_Global.recuperer_message(20441, NULL, NULL, 'DATDEP', l_msg);
      		RAISE_APPLICATION_ERROR(-20441, l_msg);
		p_message := l_msg;
  END IF;
END IF;

-- Recherche de la date de départ avant la modification
SELECT TO_CHAR(datdep,'yyyymmdd') INTO l_oldatdep
FROM SITU_RESS
WHERE TO_CHAR(datsitu,'dd/mm/yyyy')=p_oldatsitu
 AND  ident=TO_NUMBER(p_ident);

--l_oldatval:=to_char(to_date(p_oldatsitu,'dd/mm/yyyy'),'yyyymmdd');

---------------------------------------------
-- 1) La date de valeur est modifiée
---------------------------------------------
IF (l_oldatval!=l_datval) THEN
	DBMS_OUTPUT.PUT_LINE('old: '||l_oldatval||' , new: '||l_datval);
	-----------------------------------------------------------------------
	-- 1.1) La date de valeur doit etre supérieure à la date de valeur d'origine
	-----------------------------------------------------------------------
	IF l_oldatval>l_datval THEN
	    Pack_Global.recuperer_message(20228, NULL, NULL, 'DATSITU' , l_msg);
            RAISE_APPLICATION_ERROR(-20228, l_msg);
	END IF;

	---------------------------------------------------------
	-- 1.2) La date de départ est modifiée
	---------------------------------------------------------
	IF (l_oldatdep!=l_datfin) THEN
		/*** Les nouvelles dates ne doiventt pes appartenir à d'autres situations ***/
		OPEN curdatval;
		LOOP
			FETCH curdatval INTO datval,datfin;
			-- la date de valeur se trouve entre les dates d'une situation existante
			IF (l_datval >= datval AND  l_datval <= datfin)   THEN
			  DBMS_OUTPUT.PUT_LINE('date valeur: '||datval||' date depart: '||datfin);
			   Pack_Global.recuperer_message(20320, NULL, NULL, 'DATSITU', l_msg);
      			   RAISE_APPLICATION_ERROR(-20320, l_msg);
			   p_message := l_msg;
			END IF;
			-- la date de depart se trouve entre les dates d'une situation existante
			IF  (l_datfin >= datval AND l_datfin <= datfin) THEN
			  -- dbms_output.put_line('date valeur: '||datval||' date depart: '||datfin);
			   Pack_Global.recuperer_message(20321, NULL, NULL, 'DATDEP', l_msg);
      			   RAISE_APPLICATION_ERROR(-20321, l_msg);
			   p_message := l_msg;
			END IF;
			EXIT WHEN curdatval%NOTFOUND;

		END LOOP;
		CLOSE curdatval;


		/*** La nouvelle date de départ doit etre inférieure à la date de valeur suivante ***/
		 -- Recherche de la date de valeur qui suit la date de valeur saisie
  		SELECT MIN(TO_CHAR(datsitu,'yyyymmdd')) INTO l_datvalnext
  		FROM SITU_RESS
  		WHERE TO_CHAR(datsitu,'yyyymmdd')>l_oldatval
		AND ident=TO_NUMBER(p_ident);

  		IF (l_datfin>=l_datvalnext) THEN
			Pack_Global.recuperer_message(20321, NULL,NULL, 'DATDEP', l_msg);
      			RAISE_APPLICATION_ERROR(-20321, l_msg);
			p_message := l_msg;
  		END IF;

	END IF;

	---------------------------------------------------------------------------
	-- 1.3) Création d'une nouvelle situation avec la nouvelle date de valeur
	---------------------------------------------------------------------------
    BEGIN
  	INSERT INTO SITU_RESS (     ident,
                               	    datsitu,
                                    datdep,
                                    codsg,
                                    --filcode,
                                    soccode,
                                    rmcomp,
                                    PRESTATION,
                                    dispo,
                                    cpident,
                                    cout,
                                    NIVEAU,
                                    fident,
                                    mode_contractuel_indicatif
                                   )
		VALUES (TO_NUMBER(p_ident),
                     TO_DATE(p_datsitu,'mm/yyyy'),
                     TO_DATE(p_datdep,'dd/mm/yyyy'),
                     TO_NUMBER(p_codsg),
                     --p_filcode,
                     p_soccode,
                     NVL(TO_NUMBER(p_rmcomp),0),
                     p_prestation,
                     TO_NUMBER(p_dispo,'FM9D0'),
                     TO_NUMBER(p_cpident),
                     TO_NUMBER(p_cout),
                     p_niveau,
                     TO_NUMBER(p_fident),
                     p_mode_contractuelInd
                    );




      			-- On loggue le nom, prenom et matricule  dans la table situ_ress
					-- On loggue le nom, prenom et matricule  dans la table situ_ress
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Datsitu', NULL, p_datsitu, 'Création de la situation ecran modification situation');
      Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Datdep', NULL, p_datdep, 'Création de la situation ecran modification situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'DPG', NULL, p_codsg, 'Création de la situation ecran modification situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Societe', NULL, p_soccode, 'Création de la situation ecran modification situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Prestation', NULL, p_prestation, 'Création de la situation ecran modification situation');
            IF(p_prestation='SLT')THEN
                Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Ident Forfait', NULL, p_fident, 'Création de la situation ecran modification situation');
            END IF;
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Disponibilité', NULL, p_dispo, 'Création de la situation ecran modification situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Chet de projet', NULL, p_cpident, 'Création de la situation ecran modification situation');
      Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Coût', NULL, p_cout, 'Création de la situation ecran modification situation');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Niveau', NULL, p_niveau, 'Création de la situation ecran modification situation');
      Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'mode_contractuel_indicatif', NULL, p_mode_contractuelInd, 'Création de la situation ecran modification situation');



	--------------------------------------------------------------------
	-- 1.4) Mise à jour de la date de départ de la situation d'origine
	--------------------------------------------------------------------
             	BEGIN

				        SELECT  TO_CHAR(datdep,'dd/mm/yyyy')
	                    INTO v_datdep
	                    FROM SITU_RESS
                        WHERE ident = TO_NUMBER(p_ident)
                        AND TO_CHAR(datsitu,'yyyymmdd') = l_oldatval;


                 	UPDATE SITU_RESS
                            SET datdep = (TO_DATE(p_datsitu,'mm/yyyy')-1)
                        WHERE ident = TO_NUMBER(p_ident)
                             AND TO_CHAR(datsitu,'yyyymmdd') = l_oldatval;

					-- On loggue le nom, prenom et matricule  dans la table situ_ress
      		     Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Datdep', v_datdep, TO_CHAR((TO_DATE(p_datsitu,'mm/yyyy')-1),'dd/mm/yyyy'), 'Modification de la situation ecran modification situation');


                     EXCEPTION

                        WHEN referential_integrity THEN
                           -- habiller le msg erreur
                           Pack_Global.recuperation_integrite(-2291);
                        WHEN OTHERS THEN
                            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
                    END;

                     IF SQL%NOTFOUND THEN
                         Pack_Global.recuperer_message(20999, NULL, NULL, NULL , l_msg);
                         RAISE_APPLICATION_ERROR(-20999, l_msg );
                    END IF;

 		EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                   Pack_Global.recuperer_message(20229, NULL, NULL, NULL , l_msg);
                   RAISE_APPLICATION_ERROR(-20229, l_msg);
                WHEN referential_integrity THEN
                    -- habiller le msg erreur
                    Pack_Global.recuperation_integrite(-2291);
               WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR( -20997, l_msg);
	    END;

ELSE
---------------------------------------------
-- 2) La date de valeur n'est pas modifiée
---------------------------------------------

	DBMS_OUTPUT.PUT_LINE('old: '||l_oldatval||' , new: '||l_datval);
	---------------------------------------------------------
	-- 2.1) La date de départ est modifiée
	---------------------------------------------------------
	IF (l_oldatdep!=l_datfin) THEN
		/*** La nouvelle date de départ doit etre inférieure à la date de valeur suivante ***/
		 -- Recherche de la date de valeur qui suit la date de valeur saisie
  		SELECT MIN(TO_CHAR(datsitu,'yyyymmdd')) INTO l_datvalnext
  		FROM SITU_RESS
  		WHERE TO_CHAR(datsitu,'yyyymmdd')>l_datval
		AND ident=TO_NUMBER(p_ident);

  		IF (l_datfin>=l_datvalnext) THEN
			Pack_Global.recuperer_message(20321, NULL,NULL, 'DATDEP', l_msg);
      			RAISE_APPLICATION_ERROR(-20321, l_msg);
			p_message := l_msg;
  		END IF;
	END IF;
	--------------------------------
	-- MAJ SITUATION
	-------------------------------
 	BEGIN


	      SELECT  TO_CHAR(datdep,'dd/mm/yyyy'), codsg, soccode, PRESTATION, fident, dispo, cpident, cout, NIVEAU, mode_contractuel_indicatif
	      INTO v_datdep, v_codsg, v_soccode, v_PRESTATION, v_fident, v_dispo, v_cpident, v_cout, v_niveau, l_mode_contractuelInd
	      FROM SITU_RESS
        WHERE ident = TO_NUMBER(p_ident)
             AND TO_CHAR(datsitu,'yyyymmdd') = l_oldatval;



           UPDATE SITU_RESS
                SET
                    datdep     = TO_DATE(p_datdep,'dd/mm/yyyy'),
                    codsg      = TO_NUMBER(p_codsg),
                    --filcode    = p_filcode,
                    soccode    = p_soccode,
                    rmcomp     = NVL(TO_NUMBER(p_rmcomp),0),
                    PRESTATION = p_prestation,
                    dispo      = TO_NUMBER(p_dispo,'FM9D0'),
                    cpident    = TO_NUMBER(p_cpident),
                    cout       = TO_NUMBER(p_cout),
                    NIVEAU     = p_niveau,
                    fident     = TO_NUMBER(p_fident),
                    mode_contractuel_indicatif = p_mode_contractuelInd
             WHERE ident       = TO_NUMBER(p_ident)
             AND TO_CHAR(datsitu,'yyyymmdd') = l_oldatval;

			l_oldatval:= TO_CHAR (TO_DATE(l_oldatval,'yyyymmdd') , 'dd/mm/yyyy');
			-- On loggue le nom, prenom et matricule  dans la table situ_ress
      Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Datdep', v_datdep, p_datdep, 'Modification de la situation ecran modification situation (date valeur situation : ' || l_oldatval ||')');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'DPG', v_codsg, p_codsg, 'Modification de la situation ecran modification situation (date valeur situation : ' || l_oldatval ||')');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Societe', v_soccode, p_soccode, 'Modificationde la situation ecran modification situation (date valeur situation : ' || l_oldatval ||')');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Prestation', v_prestation, p_prestation, 'Modification de la situation ecran modification situation (date valeur situation : ' || l_oldatval ||')');
            IF(p_prestation='SLT')THEN
                Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Ident Forfait', v_fident, p_fident, 'Modification de la situation ecran modification situation (date valeur situation : ' || l_oldatval ||')');
            END IF;
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Disponibilité', v_dispo, TO_NUMBER(p_dispo,'FM9D0'), 'Modification de la situation ecran modification situation (date valeur situation : ' || l_oldatval ||')');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Chet de projet', v_cpident, p_cpident, 'Modification de la situation ecran modification situation (date valeur situation : ' || l_oldatval ||')');
      Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Coût', TO_CHAR(TO_NUMBER( v_cout ),'FM99999999D00'),  p_cout , 'Modification de la situation ecran modification situation (date valeur situation :' || l_oldatval ||')');
			Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Niveau', v_niveau, p_niveau, 'Modification de la situation ecran modification situation (date valeur situation : ' || l_oldatval ||')');
      Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'mode_contractuel_indicatif', l_mode_contractuelInd, p_mode_contractuelInd, 'Modification de la situation ecran modification situation (date valeur situation : ' || l_oldatval ||')');


         EXCEPTION
            WHEN referential_integrity THEN
               -- habiller le msg erreur
               Pack_Global.recuperation_integrite(-2291);
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;

  	BEGIN
		UPDATE RESSOURCE
        	SET flaglock = DECODE(p_flaglock, 1000000, 0, p_flaglock + 1)
        	WHERE flaglock = p_flaglock
             	AND ident = TO_NUMBER(p_ident);
  	EXCEPTION
		WHEN referential_integrity THEN
               -- habiller le msg erreur
        		Pack_Global.recuperation_integrite(-2291);
		WHEN OTHERS THEN
               		RAISE_APPLICATION_ERROR( -20997, SQLERRM);
  	END;

  	IF SQL%NOTFOUND THEN
         Pack_Global.recuperer_message(20999, NULL, NULL, NULL , l_msg);
         RAISE_APPLICATION_ERROR(-20999, l_msg);
  	END IF;

END IF;

    -- Message : 'situation personne || p_rnom || modifie';

	IF(p_soccode='SG..')THEN

	          Pack_Global.recuperer_message(21055,'%s1','l''agent SG', '%s2', p_ident, NULL, l_msg);
              p_message := l_msg;

	 ELSE

              Pack_Global.recuperer_message(21055, '%s1','la prestation','%s2', p_ident, NULL, l_msg);
              p_message :=p_message||'\n'|| l_msg;

	END IF;


    --Pack_Global.recuperer_message(2055, '%s1', p_rnom, NULL , l_msg);
    --p_message := l_msg;

END update_situation_p;

/********************************************************************************************/

   PROCEDURE delete_situation_p (p_rnom       IN  RESSOURCE.rnom%TYPE,
                                 p_ident      IN  VARCHAR2,
                                 p_rprenom    IN  RESSOURCE.rprenom%TYPE,
                                 p_matricule  IN  RESSOURCE.matricule%TYPE,
                                 p_datsitu    IN  VARCHAR2,
                                 p_datdep     IN  VARCHAR2,
                                 p_codsg      IN  VARCHAR2,
                                 --p_filcode    IN  situ_ress.filcode%TYPE,
                                 p_soccode    IN  SITU_RESS.soccode%TYPE,
                                 p_rmcomp     IN  VARCHAR2,
                                 p_prestation IN  SITU_RESS.PRESTATION%TYPE,
                                 p_dispo      IN  VARCHAR2,
                                 p_cpident    IN  VARCHAR2,
                                 p_cout       IN  VARCHAR2,
                                 p_flaglock   IN  NUMBER,
                                 p_userid     IN  VARCHAR2,
                                 p_fident     IN  NUMBER,
                                 p_nbcurseur  OUT INTEGER,
                                 p_message    OUT VARCHAR2
                                ) IS

      l_msg VARCHAR2(1024);
      l_datval VARCHAR2(20);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
      l_flag RESSOURCE.flaglock%TYPE;

	  l_user		RESSOURCE_LOGS.user_log%TYPE;


	   v_chaine       				  VARCHAR2(180);


   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
      l_flag := 0;

	  l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

      -- TEST : il doit toujours exister un row situation pour la ressource

      BEGIN
         SELECT COUNT(ident)
         INTO   l_flag
         FROM   SITU_RESS
         WHERE  ident = TO_NUMBER(p_ident);

      EXCEPTION

         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF l_flag = 1 THEN
         Pack_Global.recuperer_message(20234, NULL, NULL, NULL , l_msg);
         RAISE_APPLICATION_ERROR( -20234, l_msg );
      END IF;

      -- On utilise le flaglock de ressource pour protege l'acces a situ_ress

      BEGIN
         SELECT flaglock
         INTO   l_flag
         FROM   RESSOURCE
         WHERE  ident = TO_NUMBER(p_ident);

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

     IF l_flag != p_flaglock THEN
         Pack_Global.recuperer_message(20999, NULL, NULL, NULL , l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg);
      END IF;

     IF p_datdep IS NOT NULL THEN
	SELECT TO_CHAR(datsitu,'dd/mm/yyyy')
	INTO l_datval
	FROM SITU_RESS
	WHERE ident= TO_NUMBER(p_ident)
		AND TO_CHAR(datdep,'dd/mm/yyyy')=p_datdep;
     ELSE
	SELECT TO_CHAR(datsitu,'dd/mm/yyyy')
	INTO l_datval
	FROM SITU_RESS
	WHERE ident= TO_NUMBER(p_ident)
		AND TO_CHAR(datdep,'dd/mm/yyyy')IS NULL;
     END IF;

      BEGIN

	      	SELECT  l_datval || '-' || TO_CHAR(datdep,'dd/mm/yyyy') || '-' || codsg || '-' || soccode || '-' || PRESTATION || '-' || dispo || '-' || cpident || '-' || cout
	        INTO v_chaine
	        FROM SITU_RESS
            WHERE ident = TO_NUMBER(p_ident)
            AND TO_CHAR(datsitu,'dd/mm/yyyy') = l_datval;

          DELETE FROM SITU_RESS
                 WHERE ident = TO_NUMBER(p_ident)
                 AND TO_CHAR(datsitu,'dd/mm/yyyy') = l_datval;

           	-- On loggue
      		 Pack_Ressource_P.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Suppression', NULL, 'Supression', 'Suppression de la situation ' || v_chaine);



      EXCEPTION

         WHEN referential_integrity THEN

            -- habiller le msg erreur

            Pack_Global.recuperation_integrite(-2292);

          WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         Pack_Global.recuperer_message(20999, NULL, NULL, NULL , l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg ||'!');
      ELSE

	             IF(p_soccode='SG..')THEN
	 	               Pack_Global.recuperer_message(21056,'%s1','l''agent SG', '%s2', p_ident, NULL, l_msg);
                       p_message := l_msg;
	             ELSE
                      Pack_Global.recuperer_message(21056, '%s1','la prestation','%s2', p_ident, NULL, l_msg);
                      p_message := l_msg;
	              END IF;

        --  Pack_Global.recuperer_message(2056, '%s1', p_ident, NULL , l_msg);
         --p_message := l_msg;
     END IF;

   END delete_situation_p;


   PROCEDURE select_situation_p (p_mode         IN  VARCHAR2,
                                 p_rnom         IN  RESSOURCE.rnom%TYPE,
                                 p_ident        IN  VARCHAR2,
                                 p_rprenom      IN  RESSOURCE.rprenom%TYPE,
                                 p_matricule    IN  RESSOURCE.matricule%TYPE,
                                 p_datsitu      IN  VARCHAR2,
                                 p_flaglock     IN  VARCHAR2,
                                 p_userid       IN  VARCHAR2,
                                 p_cursituation IN OUT situationCurType,
                                 p_codsg           OUT VARCHAR2,
                                 p_soccode         OUT VARCHAR2,
                                 p_niveau	         OUT VARCHAR2,
                                 p_prestation      OUT VARCHAR2,
                                 p_cpident         OUT VARCHAR2,
                                 p_rmcomp          OUT VARCHAR2,
                                 p_dispo           OUT VARCHAR2,
                                 p_cout            OUT VARCHAR2,
                                 p_dat             OUT VARCHAR2,
                                 p_flag            OUT VARCHAR2,
                                 p_nbcurseur       OUT INTEGER,
                                 p_message         OUT VARCHAR2,
                                 p_code_domaine   OUT PRESTATION.CODE_DOMAINE%TYPE,
                                 p_fident         OUT NUMBER,
                                 p_mode_contractuelInd   OUT VARCHAR2,
                                 p_lib_mci OUT VARCHAR2
                                ) IS

      l_msg VARCHAR2(1024);
      l_codsg SITU_RESS.codsg%TYPE;
      l_ges NUMBER(3);
      l_idarpege VARCHAR2(255);
      l_habilitation VARCHAR2(10);
      l_datdep date;
      l_count NUMBER(3);
      l_soccode VARCHAR2(50);
      l_mode_contractuelInd VARCHAR2(5);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

      -- TEST : p_choix == Créer -> creation !='Créer' ->modif,supp

      IF  p_mode = 'insert' THEN

        -- FLAGLOCK

        BEGIN
           SELECT flaglock
           INTO   p_flag
           FROM   RESSOURCE
           WHERE  ident = TO_NUMBER(p_ident);
        EXCEPTION
          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);

        END;


        -- DATSITU

        p_dat := '';

        -- CODSG, SOCCODE, PRESTATION, CPIDENT, RMCOMP, DISPO, COUT

        BEGIN
           /* SELECT 'CODSG#'      || TO_CHAR(codsg),
                   'SOCCODE#'    || soccode,
                   'PRESTATION#' || prestation,
                   'CPIDENT#'    || TO_CHAR(cpident),
                   'RMCOMP#'     || TO_CHAR(rmcomp),
                   'DISPO#'      || TO_CHAR(dispo,'FM9D0'),
                   'COUT#'       || TO_CHAR(cout,'FM9999999990D00')*/
        SELECT  TO_CHAR(codsg),
                soccode,
                NVL(NIVEAU,''),
                PRESTATION,
                TO_CHAR(cpident),
                TO_CHAR(rmcomp),
                TO_CHAR(dispo,'FM9D0'),
                TO_CHAR(cout,'FM9999999990D00'),
                TO_CHAR(fident)
          INTO   p_codsg,
                 p_soccode,
                 p_niveau,
                 p_prestation,
                 p_cpident,
                 p_rmcomp,
                 p_dispo,
                 p_cout,
                 p_fident
            FROM SITU_RESS
            WHERE ident = TO_NUMBER(p_ident)
            AND TO_CHAR(datsitu,'dd/mm/yyyy') IN (
                              SELECT TO_CHAR(MAX(datsitu),'dd/mm/yyyy')
                              FROM SITU_RESS
                              WHERE ident = TO_NUMBER(p_ident)
                             );

			--recupere le code_domaine

			         SELECT NVL(CODE_DOMAINE,'') INTO p_code_domaine FROM PRESTATION
                     WHERE PRESTATION=p_prestation;

                EXCEPTION
                  WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR( -20997, SQLERRM);

                END;



        -- On ouvre un curseur vide, pour mettre l'automate en mode creation
        BEGIN
          OPEN p_cursituation FOR
                   SELECT TO_CHAR(RESSOURCE.ident),
                          RESSOURCE.rnom,
                          RESSOURCE.rprenom,
                          RESSOURCE.matricule,
                          TO_CHAR(SITU_RESS.datsitu,'mm/yyyy'),
                          TO_CHAR(SITU_RESS.datdep,'dd/mm/yyyy'),
                          TO_CHAR(SITU_RESS.codsg),
                          --situ_ress.filcode,
                          SITU_RESS.soccode,
						  SITU_RESS.NIVEAU,
                          SITU_RESS.PRESTATION,
                          TO_CHAR(SITU_RESS.cpident),
                          TO_CHAR(SITU_RESS.rmcomp),
                          TO_CHAR(SITU_RESS.dispo, 'FM9D0'),
                          TO_CHAR(SITU_RESS.cout, 'FM9999999999D00'),
                          TO_CHAR(SITU_RESS.datsitu,'mm/yyyy'),
                          RESSOURCE.flaglock,
						  PRESTATION.code_domaine,
                          TO_CHAR(SITU_RESS.fident),
                          TO_CHAR(RESSOURCE.IGG)
                   FROM RESSOURCE,SITU_RESS,PRESTATION
			WHERE 0=1;
--                   WHERE ressource.ident = -1
--                     AND situ_ress.ident = -1;
      EXCEPTION

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR (-20997, SQLERRM);
      END;

      ELSE -- CAS d'une modification, suppression

         -- Attention ordre des colonnes doit correspondre a l ordre
         -- de declaration dans la table ORACLE (a cause de ROWTYPE)
         -- ou selectionner toutes les colonnes par *
         -- On ouvre le curseur suivant p_rnom
         -- Gestion du niveau d'acces de l'utilisateur.

      BEGIN
         SELECT codsg, soccode
         INTO   l_codsg, l_soccode
         FROM   SITU_RESS
         WHERE  ident = TO_NUMBER(p_ident)
         AND    TO_CHAR(datsitu,'dd/mm/yyyy') = p_datsitu;

      EXCEPTION

          WHEN NO_DATA_FOUND THEN
            Pack_Global.recuperer_message(20245, NULL, NULL, 'IDENT', l_msg);
            RAISE_APPLICATION_ERROR( -20245, l_msg);

          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      /*l_ges := pack_global.verifier_habilitation(p_userid, l_codsg,
               'à modifier/supprimer la situation ( ident :' || p_ident ||', code DPG :'|| l_codsg ||')', NULL);

      IF l_ges != 0 THEN
         l_idarpege := pack_global.lire_globaldata(p_userid).idarpege;
         pack_global.recuperer_message( 20244, '%s1', l_idarpege, '%s2', l_codsg, 'IDENT', l_msg);
         raise_application_error( -20244, l_msg);
      END IF;
      */
      -- ====================================================================
      -- 7/02/2001 : Test appartenance du DPG au périmètre de l'utilisateur
      -- ====================================================================
     	l_habilitation := Pack_Habilitation.fhabili_me( l_codsg,p_userid   );
      IF l_habilitation='faux' THEN
        -- Vous n'êtes pas autorisé à modifier cette ressource, son DPG est
        Pack_Global.recuperer_message(20365, '%s1',  'modifier/supprimer la situation', NULL, l_msg);
                    RAISE_APPLICATION_ERROR(-20365, l_msg);
      END IF;


        --Recherche du mode contractuel de la ligne contrat si mode contractuel egal à '???' ou 'XXX'

        BEGIN
        SELECT SITU_RESS.mode_contractuel_indicatif INTO l_mode_contractuelInd
           FROM RESSOURCE, SITU_RESS,PRESTATION
                   WHERE RESSOURCE.ident = TO_NUMBER(p_ident)
                   AND SITU_RESS.ident = TO_NUMBER(p_ident)
                   AND TO_CHAR(SITU_RESS.datsitu,'dd/mm/yyyy') = TO_CHAR(TO_DATE(p_datsitu,'dd/mm/yyyy'),'dd/mm/yyyy')
                  AND PRESTATION.PRESTATION=SITU_RESS.PRESTATION(+);
        EXCEPTION
         WHEN NO_DATA_FOUND THEN
            null;
        END;


          BEGIN
          SELECT datdep INTO l_datdep
           FROM SITU_RESS
                   WHERE ident = TO_NUMBER(p_ident)
                   AND TO_CHAR(datsitu,'dd/mm/yyyy') = TO_CHAR(TO_DATE(p_datsitu,'dd/mm/yyyy'),'dd/mm/yyyy');
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                null;
          END;


        if(l_mode_contractuelInd = '???' or l_mode_contractuelInd= 'XXX') then

            IF (l_datdep is not null) THEN

             BEGIN

                  SELECT mode_contractuel
                    INTO p_mode_contractuelInd
                    FROM ligne_cont
                    WHERE ident = TO_NUMBER(p_ident)
                    AND soccont = l_soccode
                    AND lresdeb >= TO_DATE(p_datsitu,'dd/mm/yyyy')
                    AND lresdeb = (select MAX(lresdeb)
                                          from ligne_cont
                                          where ident = TO_NUMBER(p_ident)
                                          and soccont = l_soccode
                                          and lresdeb >= TO_DATE(p_datsitu,'dd/mm/yyyy')
                                          and lresfin <= l_datdep)
                    AND rownum = 1;




                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          p_mode_contractuelInd := l_mode_contractuelInd;
                       WHEN OTHERS THEN
                         RAISE_APPLICATION_ERROR ( -20997, SQLERRM);
                    END;
                ELSE

                    BEGIN
                       SELECT mode_contractuel
                    INTO p_mode_contractuelInd
                    FROM ligne_cont
                    WHERE ident = TO_NUMBER(p_ident)
                    AND soccont = l_soccode
                    AND lresdeb >= TO_DATE(p_datsitu,'dd/mm/yyyy')
                    AND lresdeb = (select MAX(lresdeb)
                                          from ligne_cont
                                          where ident = TO_NUMBER(p_ident)
                                          and soccont = l_soccode
                                          and lresdeb >= TO_DATE(p_datsitu,'dd/mm/yyyy'))
                    AND rownum = 1;
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          p_mode_contractuelInd := l_mode_contractuelInd;
                       WHEN OTHERS THEN
                         RAISE_APPLICATION_ERROR ( -20997, SQLERRM);
                    END;

                END IF;
        ELSE
            p_mode_contractuelInd := l_mode_contractuelInd;
        END IF;
        --Fin de la recherche du mode contractuel


        -- recherche du libelle du MCI

      BEGIN
            SELECT LIBELLE INTO p_lib_mci
            FROM mode_contractuel
            WHERE CODE_CONTRACTUEL=p_mode_contractuelInd;


            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                    Pack_Global.recuperer_message( 21191, NULL, NULL, NULL, p_message);
            WHEN OTHERS THEN
                           RAISE_APPLICATION_ERROR( -20997, SQLERRM);

        END;



         BEGIN
            OPEN p_cursituation FOR
                   SELECT TO_CHAR(RESSOURCE.ident),
                          RESSOURCE.rnom,
                          RESSOURCE.rprenom,
                          RESSOURCE.matricule,
                          TO_CHAR(SITU_RESS.datsitu,'mm/yyyy'),
                          TO_CHAR(SITU_RESS.datdep,'dd/mm/yyyy'),
                          TO_CHAR(SITU_RESS.codsg),
                          --situ_ress.filcode,
                          SITU_RESS.soccode,
                          SITU_RESS.NIVEAU,
                          SITU_RESS.PRESTATION,
                          TO_CHAR(SITU_RESS.cpident),
                          TO_CHAR(SITU_RESS.rmcomp),
                          TO_CHAR(SITU_RESS.dispo, 'FM9D0'),
                          TO_CHAR(SITU_RESS.cout, 'FM9999999990D00'),
                          TO_CHAR(SITU_RESS.datsitu,'dd/mm/yyyy'),
                          RESSOURCE.flaglock,
                          PRESTATION.code_domaine,
                          TO_CHAR(SITU_RESS.fident),
                          TO_CHAR(RESSOURCE.IGG)
                   FROM RESSOURCE, SITU_RESS,PRESTATION
                   WHERE RESSOURCE.ident = TO_NUMBER(p_ident)
                   AND SITU_RESS.ident = RESSOURCE.ident
                   AND SITU_RESS.datsitu = TO_DATE(p_datsitu,'dd/mm/yyyy')
                   AND SITU_RESS.PRESTATION = PRESTATION.PRESTATION(+);

--                   AND TO_CHAR(situ_ress.datsitu,'mm/yyyy')
--                       = TO_CHAR(TO_DATE(p_datsitu,'dd/mm/yyyy'),'mm/yyyy');

        EXCEPTION

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;
     END IF;

       -- en cas absence
       -- p_message := 'La situation n''existe pas';

      Pack_Global.recuperer_message(2041, NULL, NULL, NULL , l_msg);
      p_message := l_msg;

   END select_situation_p;





   -- Récupération de la liste des niveaux existants de la table NIVEAU


   PROCEDURE select_liste_Niveaux(s_curseur 	IN OUT  niveau_Curseur ) IS
   	BEGIN
		 BEGIN



	OPEN s_curseur  FOR
           	 SELECT NIVEAU, LIBNIVEAU
           	 FROM NIVEAU
			 ORDER BY NIVEAU;





   	EXCEPTION
		WHEN OTHERS THEN
   		    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;



END select_liste_Niveaux;

FUNCTION verif_situ_ligcont (p_ident IN VARCHAR2,
                                  p_soccont IN VARCHAR2,
                                  p_lresdeb IN DATE,
                                  p_lresfin IN DATE) RETURN NUMBER IS
      l_compteur NUMBER;
      l_count NUMBER;
      l_datef DATE;
      l_datefstat DATE;
      l_datedeb DATE;
      l_datefin DATE;

     CURSOR cur_situligne IS
          SELECT datsitu, datdep FROM situ_ress
            where ident = to_number(p_ident)
            and trim(soccode) = trim(p_soccont)
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and  trim(soccode) = trim(p_soccont) and datsitu <= p_lresdeb) and p_lresfin)
            order by datsitu asc;

      BEGIN
          SELECT count(*) into l_count FROM situ_ress
            where ident = to_number(p_ident)
            and trim(soccode) = trim(p_soccont)
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and  trim(soccode) = trim(p_soccont) and datsitu <= p_lresdeb) and p_lresfin)
            order by datsitu asc;

          IF(l_count = 0) THEN
             return 0;
          ELSIF(l_count = 1) THEN

            SELECT datsitu, datdep into l_datedeb,l_datefin FROM situ_ress
              where ident = to_number(p_ident)
              and  trim(soccode) = trim(p_soccont)
              and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and  trim(soccode) = trim(p_soccont) and datsitu <= p_lresdeb) and p_lresfin)
              and rownum = 1
              order by datsitu asc;

            IF((l_datedeb > p_lresdeb) or ((l_datefin is not null) and (l_datefin < p_lresfin))) THEN
              return 0;
            END IF;

         ELSE

         l_datefstat := TO_DATE('01/01/1900','DD/MM/YYYY');
         l_datef := TO_DATE('01/01/1900','DD/MM/YYYY');
         l_compteur := 0;

           FOR one_situligne IN cur_situligne LOOP
              l_compteur := l_compteur+1;
              l_datedeb := one_situligne.datsitu;
              l_datefin := one_situligne.datdep;

                IF((one_situligne.datdep is not null) and (one_situligne.datdep <= p_lresfin)) THEN
                    IF(l_datef != l_datefstat) THEN
                      IF(l_datef = one_situligne.datsitu) THEN
                          l_datef := one_situligne.datdep + 1;
                      ELSE
                        return 0;
                      END IF;
                    ELSE
                        l_datef := one_situligne.datdep + 1;
                    END IF;
                  ELSIF(one_situligne.datdep is null) THEN
                    IF(l_datef != l_datefstat) THEN
                      IF(l_datef != one_situligne.datsitu) THEN
                        return 0;
                      END IF;
                    END IF;
                  END IF;
           END LOOP;

         IF(
            ((l_datefin is not null) and  (l_datefin < p_lresfin))
          or
            ((l_datefin is not null) and  (l_datefin > p_lresfin) and (l_datef != p_lresfin) and (l_datef != l_datedeb))
            ) THEN
            return 0;
         END IF;
       END IF;

       return 1;

END  verif_situ_ligcont;

FUNCTION verif_situ_ligcont_rep (p_ident IN VARCHAR2,
                                  p_soccont IN VARCHAR2,
                                  p_lresdeb IN DATE,
                                  p_lresfin IN DATE) RETURN VARCHAR2 IS
      l_dprest VARCHAR2(20);
      l_compteur NUMBER;
      l_count NUMBER;
      l_valid NUMBER;
      l_datef DATE;
      l_datefstat DATE;
      l_datedeb DATE;
      l_datefin DATE;

     CURSOR cur_situligne IS

          SELECT datsitu, datdep FROM situ_ress
            where ident = to_number(p_ident)
            and  trim(soccode) = trim(p_soccont)
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and  trim(soccode) = trim(p_soccont) and datsitu <= p_lresdeb) and p_lresfin)
            order by datsitu asc;

      BEGIN
        l_valid := 1;

        SELECT count(*) into l_count FROM situ_ress
            where ident = to_number(p_ident)
            and  trim(soccode) = trim(p_soccont)
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and  trim(soccode) = trim(p_soccont) and datsitu <= p_lresdeb) and p_lresfin)
            order by datsitu asc;

         IF(l_count = 0) THEN

          l_valid := 0;

         ELSIF(l_count = 1) THEN

          SELECT datsitu, datdep into l_datedeb,l_datefin FROM situ_ress
            where ident = to_number(p_ident)
            and  trim(soccode) = trim(p_soccont)
            and (datsitu between (select max(datsitu) from situ_ress where ident = to_number(p_ident) and trim(soccode) = trim(p_soccont) and datsitu <= p_lresdeb) and p_lresfin)
            and rownum = 1
            order by datsitu asc;

          IF((l_datedeb > p_lresdeb) or ((l_datefin is not null) and (l_datefin < p_lresfin))) THEN
            l_valid := 0;
          END IF;

         ELSE

           l_datefstat := TO_DATE('01/01/1900','DD/MM/YYYY');
           l_datef := TO_DATE('01/01/1900','DD/MM/YYYY');
           l_compteur := 0;


           IF((p_lresdeb is null) and (p_lresfin is null)) THEN
            return '';
           END IF;

             FOR one_situligne IN cur_situligne LOOP
                l_compteur := l_compteur+1;
                l_datedeb := one_situligne.datsitu;
                l_datefin := one_situligne.datdep;

                  IF((one_situligne.datdep is not null) and (one_situligne.datdep <= p_lresfin)) THEN
                      IF(l_datef != l_datefstat) THEN
                        IF(l_datef = one_situligne.datsitu) THEN
                            l_datef := one_situligne.datdep + 1;
                        ELSE
                          l_valid := 0;
                          EXIT;
                        END IF;
                      ELSE
                          l_datef := one_situligne.datdep + 1;
                      END IF;
                    ELSIF(one_situligne.datdep is null) THEN
                      IF(l_datef != l_datefstat) THEN
                        IF(l_datef != one_situligne.datsitu) THEN
                          l_valid := 0;
                          EXIT;
                        END IF;
                      END IF;
                    END IF;
             END LOOP;

           IF(
              ((l_datefin is not null) and  (l_datefin < p_lresfin))
            or
              ((l_datefin is not null) and  (l_datefin > p_lresfin) and (l_datef != p_lresfin) and (l_datef != l_datedeb))
             ) THEN
              l_valid := 0;
           END IF;

         END IF;


       IF(l_valid = 1) THEN

          BEGIN
            IF(l_datefin is not null) THEN
            SELECT PRESTATION into l_dprest FROM situ_ress
              where datsitu =  l_datedeb
              and datdep = l_datefin
              and soccode = p_soccont
              and ident = p_ident;
            ELSE
            SELECT PRESTATION into l_dprest FROM situ_ress
              where datsitu =  l_datedeb
              and datdep is null
              and soccode = p_soccont
              and ident = p_ident;
            END IF;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              null;
          END;

          return l_dprest;

       ELSE
         return '!!!';
       END IF;

END  verif_situ_ligcont_rep;

PROCEDURE select_mode_contractuel (p_mode     IN  VARCHAR2,
                                   p_ident    IN VARCHAR2,
                                   p_soccode  IN VARCHAR2,
                                   p_datsitu  IN VARCHAR2,
                                   p_datdep   IN VARCHAR2,
                                    p_mode_contractuel_in IN VARCHAR2,
                                   p_mode_contractuel IN OUT VARCHAR2)IS

l_datdep VARCHAR2(20);
--l_datdep DATE;
l_count NUMBER;
l_mode_contractuel VARCHAR2(20);

BEGIN

  l_mode_contractuel := p_mode_contractuel_in;

   SELECT count(*) INTO l_count
           FROM SITU_RESS
           WHERE SITU_RESS.ident = TO_NUMBER(p_ident);

  IF  p_mode = 'insert' THEN

        IF(l_count != 0) THEN

              BEGIN
                IF (p_datdep is not null) THEN
                    SELECT mode_contractuel
                    INTO p_mode_contractuel
                    FROM ligne_cont
                    WHERE ident = TO_NUMBER(p_ident)
                    AND soccont = p_soccode
                    AND lresdeb >= TRUNC(TO_DATE(p_datsitu,'mm/yyyy'),'MONTH')
                    and lresfin <= TO_DATE(p_datdep,'dd/mm/yyyy')
                    AND lresdeb = (select MAX(lresdeb)
                                          from ligne_cont
                                          where ident = TO_NUMBER(p_ident)
                                          and soccont = p_soccode
                                          and lresdeb >= TRUNC(TO_DATE(p_datsitu,'mm/yyyy'),'MONTH')
                                          and lresfin <= TO_DATE(p_datdep,'dd/mm/yyyy'))
                    AND rownum = 1;
                ELSE
                    SELECT mode_contractuel
                    INTO p_mode_contractuel
                    FROM ligne_cont
                    WHERE ident = TO_NUMBER(p_ident)
                    AND soccont = p_soccode
                    AND lresdeb >= TRUNC(TO_DATE(p_datsitu,'mm/yyyy'),'MONTH')
                    AND lresdeb = (select MAX(lresdeb)
                                          from ligne_cont
                                          where ident = TO_NUMBER(p_ident)
                                          and soccont = p_soccode
                                          and lresdeb >= TRUNC(TO_DATE(p_datsitu,'mm/yyyy'),'MONTH'))
                    AND rownum = 1;
                END IF;

              EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      p_mode_contractuel := l_mode_contractuel;
                   WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR ( -20997, SQLERRM);

              END;
        ELSE
          p_mode_contractuel := l_mode_contractuel;
        END IF;
  ELSE
        SELECT TO_CHAR(datdep,'dd/mm/yyyy') INTO l_datdep
           FROM SITU_RESS
                   WHERE ident = TO_NUMBER(p_ident)
                   AND TO_CHAR(datsitu,'mm/yyyy') = p_datsitu;

        IF(p_mode_contractuel_in = '???' or p_mode_contractuel_in = 'XXX') THEN
            BEGIN
                IF (l_datdep is not null) THEN
                    SELECT mode_contractuel
                    INTO p_mode_contractuel
                    FROM ligne_cont
                    WHERE ident = TO_NUMBER(p_ident)
                    AND soccont = p_soccode
                    AND lresdeb >= TRUNC(TO_DATE(p_datsitu,'mm/yyyy'),'MONTH')
                    and lresfin <= TO_DATE(p_datdep,'dd/mm/yyyy')
                    AND lresdeb = (select MAX(lresdeb)
                                          from ligne_cont
                                          where ident = TO_NUMBER(p_ident)
                                          and soccont = p_soccode
                                          and lresdeb >= TRUNC(TO_DATE(p_datsitu,'mm/yyyy'),'MONTH')
                                          and lresfin <= TO_DATE(p_datdep,'dd/mm/yyyy'))
                    AND rownum = 1;
                ELSE
                    SELECT mode_contractuel
                    INTO p_mode_contractuel
                    FROM ligne_cont
                    WHERE ident = TO_NUMBER(p_ident)
                    AND soccont = p_soccode
                    AND lresdeb >= TRUNC(TO_DATE(p_datsitu,'mm/yyyy'),'MONTH')
                    AND lresdeb = (select MAX(lresdeb)
                                          from ligne_cont
                                          where ident = TO_NUMBER(p_ident)
                                          and soccont = p_soccode
                                          and lresdeb >= TRUNC(TO_DATE(p_datsitu,'mm/yyyy'),'MONTH'))
                    AND rownum = 1;
                END IF;
              EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      p_mode_contractuel := l_mode_contractuel;
                   WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR ( -20997, SQLERRM);

              END;
        ELSE
          p_mode_contractuel := l_mode_contractuel;
        END IF;

  END IF;

END  select_mode_contractuel;



END Pack_Situation_P;
/


