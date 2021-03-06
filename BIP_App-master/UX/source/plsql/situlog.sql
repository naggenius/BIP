-- pack_situation_l PL/SQL
--
-- EQUIPE SOPRA
-- Attention le nom du package ne peut etre le nom de la table...
--
-- Cree le 18/02/1999
-- MAJ le 
-- 11/04/2000	NCM
-- 29/11/2000	NCM	:	ne pas contr�ler que la soci�t� est ferm�e � partir de DIRMENU
-- 12/07/2004	EGR	:	F370 : retrait de filcode dans situ_ress et situ_ress_full
-- Modifi�e le 24/11/2004  par Fiche 257   Evolution du r�f�rentiel comp�tence / prestation dans la BIP
-- 27/07/2006	JMA	:	TD 448 : cout standard 2 par m�tier

-- 6.3.1
-- 02/04/2007   EVI	:	TD 545 : Prise en compte du cout standard lors de la creation d'une situ

-- 6.3.0
-- Modifi�e le 25/09/2007 par JAL FICHE 563  Ajout de log.
-- Modifi�e le 16/10/2007 par JAL FICHE 563  Ajout de commentaires dans logs et correction format champs identiques pour champs dans logs
-- Modifi�e le 19/10/2007 par EVI FICHE 563  Formatage de la date dans le champs 'commentaire'
-- Modifi�e le 2-/06/2010 Par YNI Fiche 970
-- Modifi�e le 18/07/2010 par YNI Fiche 970
-- Modifi�e le 15/09/2010 par ABA Fiche 970
-- Modifi�e le 08/10/2010 par ABA Fiche 970
-- Modifi�e le 14/02/2011 par CMA Fiche 857

CREATE OR REPLACE PACKAGE PACK_SITUATION_L AS

TYPE situation_s_ViewType IS RECORD (ident      VARCHAR2(20),
                                     rnom       RESSOURCE.rnom%TYPE,
                                     coutot     VARCHAR2(20),
                                     flaglock   VARCHAR2(20),
                                     datsitu    VARCHAR2(20),
                                     datdep     VARCHAR2(20),
                                     codsg      VARCHAR2(20),
                                     --filcode    situ_ress.filcode%TYPE,
                                     soccode    SITU_RESS.soccode%TYPE,
                                     PRESTATION SITU_RESS.PRESTATION%TYPE,
                                     cpident    VARCHAR2(20),
                                     olddatsitu VARCHAR2(20),
                                     coulog	VARCHAR2(20),
                                     code_domaine VARCHAR2(20)
                                    );

TYPE situationCurType IS REF CURSOR RETURN situation_s_ViewType;


   PROCEDURE insert_situation_l (p_oldatsitu  IN  VARCHAR2,
                                 p_ident      IN  VARCHAR2,
                                 p_coulog     IN  VARCHAR2,
                                 p_rnom       IN  RESSOURCE.rnom%TYPE,
                                 p_coutot     IN  VARCHAR2,
                                 p_datsitu    IN  VARCHAR2,
                                 p_datdep     IN  VARCHAR2,
                                 p_codsg      IN  VARCHAR2,
                                 --p_filcode    IN  situ_ress.filcode%TYPE,
                                 p_soccode    IN  SITU_RESS.soccode%TYPE,
                                 p_prestation IN  SITU_RESS.PRESTATION%TYPE,
                                 p_cpident    IN  VARCHAR2,
                                 p_flaglock   IN  NUMBER,
                                 p_userid     IN  VARCHAR2,
                                 p_mode_contractuel   IN VARCHAR2,
                                 p_nbcurseur  OUT INTEGER,
                                 p_message    OUT VARCHAR2
                                );

   PROCEDURE update_situation_l (p_oldatsitu  IN  VARCHAR2,
                                 p_ident      IN  VARCHAR2,
                                 p_coulog     IN  VARCHAR2,
                                 p_rnom       IN  RESSOURCE.rnom%TYPE,
                                 p_coutot     IN  VARCHAR2,
                                 p_datsitu    IN  VARCHAR2,
                                 p_datdep     IN  VARCHAR2,
                                 p_codsg      IN  VARCHAR2,
                                 --p_filcode    IN  situ_ress.filcode%TYPE,
                                 p_soccode    IN  SITU_RESS.soccode%TYPE,
                                 p_prestation IN  SITU_RESS.PRESTATION%TYPE,
                                 p_cpident    IN  VARCHAR2,
                                 p_flaglock   IN  NUMBER,
                                 p_userid     IN  VARCHAR2,
                                 p_mode_contractuel   IN VARCHAR2,
                                 p_nbcurseur  OUT INTEGER,
                                 p_message    OUT VARCHAR2
                                );

   PROCEDURE delete_situation_l (p_ident     IN  VARCHAR2,
                                 p_coufor    IN  VARCHAR2,
                                 p_rnom      IN  VARCHAR2,
                                 p_coutot    IN  VARCHAR2,
                                 p_datsitu   IN  VARCHAR2,
				 p_datdep    IN  VARCHAR2,
                                 p_flaglock  IN  NUMBER,
                                 p_userid    IN  VARCHAR2,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                );

   PROCEDURE select_situation_l (p_mode        IN  VARCHAR2,
                                 p_ident        IN  VARCHAR2,
                                 p_coulog       IN  VARCHAR2,
                                 p_rnom         IN  RESSOURCE.rnom%TYPE,
                                 p_coutot       IN  VARCHAR2,
                                 p_datsitu      IN  VARCHAR2,
                                 p_flaglock     IN  VARCHAR2,
                                 p_userid       IN  VARCHAR2,
                                 p_cursituation IN OUT situationCurType,
                                 p_codsg           OUT VARCHAR2,
                                 p_soccode         OUT VARCHAR2,
                                 p_cpident         OUT VARCHAR2,
                                 p_dat             OUT VARCHAR2,
                                 p_coul            OUT VARCHAR2,
                                 p_prestation      OUT VARCHAR2,
                                 p_flag            OUT VARCHAR2,
                                 p_nbcurseur       OUT INTEGER,
                                 p_message         OUT VARCHAR2,
                                 p_mode_contractuel   OUT VARCHAR2
                                );

 PROCEDURE select_mode_contractuel (p_mode     IN  VARCHAR2,
                                     p_ident    IN VARCHAR2,
                                     p_soccode  IN VARCHAR2,
                                     p_datsitu  IN VARCHAR2,
                                     p_datdep   IN VARCHAR2,
                                        p_mode_contractuel_in IN VARCHAR2,
                                     p_mode_contractuel IN OUT VARCHAR2);
END Pack_Situation_L;
/


CREATE OR REPLACE PACKAGE BODY     PACK_SITUATION_L AS
   PROCEDURE insert_situation_l (p_oldatsitu  IN  VARCHAR2,
                                 p_ident      IN  VARCHAR2,
                                 p_coulog     IN  VARCHAR2,
                                 p_rnom       IN  RESSOURCE.rnom%TYPE,
                                 p_coutot     IN  VARCHAR2,
                                 p_datsitu    IN  VARCHAR2,
                                 p_datdep     IN  VARCHAR2,
                                 p_codsg      IN  VARCHAR2,
                                 --p_filcode    IN  situ_ress.filcode%TYPE,
                                 p_soccode    IN  SITU_RESS.soccode%TYPE,
                                 p_prestation IN  SITU_RESS.PRESTATION%TYPE,
                                 p_cpident    IN  VARCHAR2,
                                 p_flaglock   IN  NUMBER,
                                 p_userid     IN  VARCHAR2,
                                 p_mode_contractuel   IN VARCHAR2,
                                 p_nbcurseur  OUT INTEGER,
                                 p_message    OUT VARCHAR2
                                ) IS

      l_msg VARCHAR2(1024);
      l_ncodsg SITU_RESS.codsg%TYPE;
      l_dsocfer VARCHAR2(20);
      l_ncpident SITU_RESS.cpident%TYPE;
      l_date_courante VARCHAR2(20);
      l_datval VARCHAR2(20);
      l_datfin VARCHAR2(20);
      l_datval1       VARCHAR2(20);
      l_datfin1       VARCHAR2(20);
      l_datvalnext    VARCHAR2(20);
      datval          VARCHAR2(20);
      datfin          VARCHAR2(20);
      l_odatval VARCHAR2(20);

      l_menu VARCHAR2(255);
      l_topfer STRUCT_INFO.topfer%TYPE;
      l_flaglock RESSOURCE.flaglock%TYPE;
      l_habilitation VARCHAR2(10);

	   l_user		RESSOURCE_LOGS.user_log%TYPE;


	   l_old_datdep SITU_RESS.DATDEP%TYPE;
	   l_old_codsg SITU_RESS.CODSG%TYPE;
	   l_old_soccode SITU_RESS.SOCCODE%TYPE;
	   l_old_prestation SITU_RESS.PRESTATION%TYPE;
	   l_old_cpident SITU_RESS.CPIDENT%TYPE;
     l_mode_contractuel VARCHAR2(20);





CURSOR curdate IS
	SELECT TO_CHAR(datsitu,'yyyymmdd') ,TO_CHAR(datdep,'yyyymmdd')
	FROM SITU_RESS
	WHERE ident=TO_NUMBER(p_ident);

      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

   BEGIN

    l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

    -- test mode contractuel

       BEGIN
          SELECT code_contractuel
          INTO l_mode_contractuel
          FROM mode_contractuel
          WHERE code_contractuel = p_mode_contractuel
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



       -- regle 4 non prise en compte.
       -- Positionner le nb de curseurs ==> 0
       -- Initialiser le message retour

       p_nbcurseur := 0;
       p_message := '';
       l_flaglock := p_flaglock;

      -- ====================================================================
      -- 8/02/2001 : Test appartenance du DPG au p�rim�tre de l'utilisateur
      -- ====================================================================
     	l_habilitation := Pack_Habilitation.fhabili_me( p_codsg,p_userid   );
	IF l_habilitation='faux' THEN
		-- Vous n'�tes pas habilit� � ce DPG 20364
		Pack_Global.recuperer_message(20364, '%s1', '� ce DPG', 'CODSG', l_msg);
                RAISE_APPLICATION_ERROR(-20364, l_msg);
	END IF;

      -- Gestion de l'utilisateur

      l_menu := Pack_Global.lire_globaldata(p_userid).menutil;



       -- TEST : codsg > 100000

      IF TO_NUMBER(p_codsg) <= 100000 THEN
            Pack_Global.recuperer_message( 20223, NULL, NULL, 'CODSG', l_msg);
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
          INTO   l_ncpident
          FROM   RESSOURCE
          WHERE  ident = TO_NUMBER(p_cpident);

      EXCEPTION

           WHEN NO_DATA_FOUND THEN
             Pack_Global.recuperer_message( 20226, '%s1', p_cpident, 'CPIDENT', l_msg);
             RAISE_APPLICATION_ERROR(-20226, l_msg);

           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

-- -------------------------------------------------------------------------------------
-- CONTROLES DE DATES
-- -------------------------------------------------------------------------------------
-- Recherche si la date de valeur existe d�j�
  SELECT COUNT(datsitu) INTO l_odatval
  FROM SITU_RESS
  WHERE ident=TO_NUMBER(p_ident)
	AND TO_CHAR(datsitu,'mm/yyyy')=p_datsitu;
IF l_odatval=1 THEN
	SELECT SUBSTR(TO_CHAR(datsitu,'dd/mm/yyyy'),1,2) INTO l_datval
	FROM SITU_RESS
	WHERE ident=TO_NUMBER(p_ident)
	AND   TO_CHAR(datsitu,'mm/yyyy')=p_datsitu ;
	-- Impossible de cr�er une autre situation dans le m�me mois
	IF l_datval!='01' THEN
		Pack_Global.recuperer_message(20322, NULL, NULL, 'DATSITU', l_msg);
      		RAISE_APPLICATION_ERROR(-20322, l_msg);
		p_message := l_msg;
   	END IF;
END IF;

l_datval:=TO_CHAR(TO_DATE(p_datsitu,'mm/yyyy'),'yyyymm')||'01';
l_datfin:=TO_CHAR(TO_DATE(p_datdep,'dd/mm/yyyy'),'yyyymmdd') ;
---------------------------------------------------------------------------
-- La date de valeur est toujours inf�rieure � la date de d�part
---------------------------------------------------------------------------
IF (p_datdep IS NOT NULL) THEN

	IF l_datval>l_datfin THEN
    		Pack_Global.recuperer_message(20227, NULL, NULL, 'DATSITU', l_msg);
      	     	RAISE_APPLICATION_ERROR(-20227, l_msg);
		p_message := l_msg;
	END IF;
END IF;

-- Recherche de la date de d�part la plus r�cente
SELECT TO_CHAR(datdep,'yyyymmdd') INTO l_datfin1
FROM SITU_RESS
WHERE datsitu=(SELECT MAX(datsitu)
		FROM SITU_RESS
		WHERE 	ident=TO_NUMBER(p_ident))
AND	ident=TO_NUMBER(p_ident);

-- Recherche de la date de valeur la plus r�cente
SELECT MAX(TO_CHAR(datsitu,'yyyymmdd')) INTO l_datval1
FROM SITU_RESS
WHERE ident=TO_NUMBER(p_ident);


------------------------------------------------------------------------------------
-- 1) Cas d'une situation interm�diaire ou ant�rieure � la plus ancienne situation
------------------------------------------------------------------------------------
IF  l_datval<l_datval1 THEN                    /* Cas d'une situation interm�diaire */
  -- La date de d�part est obligatoire
  IF l_datfin IS NULL THEN
	Pack_Global.recuperer_message(20441, NULL, NULL, 'DATDEP', l_msg);
      		RAISE_APPLICATION_ERROR(-20441, l_msg);
		p_message := l_msg;
  END IF;

  ---------------------------------------------------------------------------------------
  -- V�rification de la validit� des dates (non comprises dans des situations existantes)
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
  -- La situation  entre la date de valeur et celle de d�part ne doit pas chevaucher
  -- les situations existantes
  -- ie la date de d�part doit etre inf�rieure � la date de valeur de la situation post�rieure
  ---------------------------------------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('datedep : '||l_datfin||', datval: '||l_datval);
IF (l_datfin>=l_datvalnext)  THEN
	Pack_Global.recuperer_message(20321, NULL,NULL, 'DATDEP', l_msg);
      	RAISE_APPLICATION_ERROR(-20321, l_msg);
	p_message := l_msg;
  END IF;

END IF;

---------------------------------------------------------------------
-- 2) Cas o� d'une situation qui suit la situation la plus r�cente
---------------------------------------------------------------------
IF (l_datval>l_datval1)  THEN
  IF (l_datfin1 IS NULL) THEN
	-- La date de d�part la plus r�cente est �gale � la date de valeur saisie-1jour
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
	-- Mise � jour de ressource
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


-- la date de valeur n'existe pas
IF l_odatval<1 THEN
	BEGIN
          	INSERT INTO SITU_RESS (ident,
                                    	datsitu,
                                       	datdep,
                                   	PRESTATION,
                                 	soccode,
                                   	codsg,
                                  	--filcode,
                                 	cpident,
									cout,
                  mode_contractuel_indicatif
                                           )
           	VALUES (TO_NUMBER(p_ident),
                              TO_DATE(p_datsitu,'mm/yyyy'),
                              TO_DATE(p_datdep,'dd/mm/yyyy'),
                              p_prestation,
                              p_soccode,
                              TO_NUMBER(p_codsg),
                              --p_filcode,
                              p_cpident,
							  p_coulog, --Initialisation du cout au cout standard
                p_mode_contractuel             );

			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'identifiant ressource', NULL, p_ident, 'Cr�ation de la situation');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'date valeur situation', NULL, p_datsitu, 'Cr�ation de la situation');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'date d�part situation', NULL, p_datdep, 'Cr�ation de la situation');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'code prestation', NULL, p_prestation, 'Cr�ation de la situation');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'code soci�t�', NULL, p_soccode, 'Cr�ation de la situation');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'code p�le/dpt/groupe', NULL, p_codsg, 'Cr�ation de la situation');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'code Chef de Projet', NULL, p_cpident, 'Cr�ation de la situation');
      Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'mode contractuel indicatif', NULL, p_mode_contractuel, 'Cr�ation de la situation');



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
-- La date de valeur existe d�j�
ELSE
       BEGIN

	   SELECT datdep,codsg,soccode,PRESTATION ,cpident, mode_contractuel_indicatif INTO
	    l_old_datdep, l_old_codsg, l_old_soccode,  l_old_prestation ,l_old_cpident, l_mode_contractuel
	   FROM SITU_RESS
	    WHERE ident = TO_NUMBER(p_ident)
        AND TO_CHAR(datsitu,'yyyymmdd') = l_datval;


               UPDATE SITU_RESS SET  datdep     = TO_DATE(p_datdep,'dd/mm/yyyy'),
                                     codsg      = TO_NUMBER(p_codsg),
                                     --filcode    = p_filcode,
                                     soccode    = p_soccode,
                                     PRESTATION = p_prestation,
                                     cpident    = TO_NUMBER(p_cpident),
                                     mode_contractuel_indicatif = p_mode_contractuel
                WHERE ident = TO_NUMBER(p_ident)
                AND TO_CHAR(datsitu,'yyyymmdd') = l_datval;




			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'date d�part situation', TO_CHAR(l_old_datdep,'dd/mm/yyyy'), p_datdep, 'Modification de la situation');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'code prestation', l_old_prestation, p_prestation, 'Modification de la situation');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'code soci�t�',l_old_soccode, p_soccode, 'Modification de la situation');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'code p�le/dpt/groupe', TO_CHAR(l_old_codsg), p_codsg, 'Modification de la situation');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'code Chef de Projet', TO_CHAR(l_old_cpident), p_cpident, 'Modification de la situation');
      Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'mode contractuel indicatif', l_mode_contractuel, p_mode_contractuel, 'Modification de la situation');


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

    -- Message : 'situation Logiciel || p_rnom || creee';

    Pack_Global.recuperer_message(2042, '%s1', p_ident, NULL, l_msg);
    p_message := l_msg;

   END insert_situation_l;

/****************************************************************************************
****************************************************************************************/

   PROCEDURE update_situation_l (p_oldatsitu  IN  VARCHAR2,
                                 p_ident      IN  VARCHAR2,
                                 p_coulog     IN  VARCHAR2,
                                 p_rnom       IN  RESSOURCE.rnom%TYPE,
                                 p_coutot     IN  VARCHAR2,
                                 p_datsitu    IN  VARCHAR2,
                                 p_datdep     IN  VARCHAR2,
                                 p_codsg      IN  VARCHAR2,
                                 --p_filcode    IN  situ_ress.filcode%TYPE,
                                 p_soccode    IN  SITU_RESS.soccode%TYPE,
                                 p_prestation IN  SITU_RESS.PRESTATION%TYPE,
                                 p_cpident    IN  VARCHAR2,
                                 p_flaglock   IN  NUMBER,
                                 p_userid     IN  VARCHAR2,
                                 p_mode_contractuel   IN VARCHAR2,
                                 p_nbcurseur  OUT INTEGER,
                                 p_message    OUT VARCHAR2
                                ) IS

      l_msg VARCHAR2(1024);
      l_ncodsg SITU_RESS.codsg%TYPE;
      l_ncpident SITU_RESS.cpident%TYPE;
      l_dsocfer       VARCHAR2(20);
      l_date_courante VARCHAR2(20);
      l_datval        VARCHAR2(20);
      l_oldatval      VARCHAR2(20);
      l_datfin        VARCHAR2(20);
      l_menu 	      VARCHAR2(255);
      l_topfer STRUCT_INFO.topfer%TYPE;
	l_datvalnext    VARCHAR2(20);
	l_oldatdep  VARCHAR2(20);
	l_datval1  VARCHAR2(20);


	datval VARCHAR2(20);
	datfin VARCHAR2(20);
	l_user		RESSOURCE_LOGS.user_log%TYPE;
	l_datsitu VARCHAR2(20);
	   l_old_datdep SITU_RESS.DATDEP%TYPE;
	   l_old_codsg SITU_RESS.CODSG%TYPE;
	   l_old_soccode SITU_RESS.SOCCODE%TYPE;
	   l_old_prestation SITU_RESS.PRESTATION%TYPE;
	   l_old_cpident SITU_RESS.CPIDENT%TYPE;
     l_mode_contractuel VARCHAR2(20);


CURSOR curdatval IS
	SELECT TO_CHAR(datsitu,'yyyymmdd') ,TO_CHAR(datdep,'yyyymmdd')
	FROM SITU_RESS
	WHERE ident=TO_NUMBER(p_ident)
	AND    TO_CHAR(datsitu,'dd/mm/yyyy')!=p_oldatsitu;

      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);

   BEGIN


       l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

       -- test mode contractuel

       BEGIN
          SELECT code_contractuel
          INTO l_mode_contractuel
          FROM mode_contractuel
          WHERE code_contractuel = p_mode_contractuel
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


       -- test mode contractuel

       BEGIN
          SELECT code_contractuel
          INTO l_mode_contractuel
          FROM mode_contractuel
          WHERE code_contractuel = p_mode_contractuel
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



       -- REGLE non respecte : 9.12.5 regle 4 gestion utilisateur.
       -- Positionner le nb de curseurs ==> 0
       -- Initialiser le message retour

       p_nbcurseur := 0;
       p_message := '';

      -- Gestion de l'utilisateur

      l_menu := Pack_Global.lire_globaldata(p_userid).menutil;

       -- TEST : codsg > 100000
      IF TO_NUMBER(p_codsg) <= 100000 THEN
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



      -- TEST : soccode existe et societe non fermee.

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
-- La date de valeur est toujours inf�rieure � la date de d�part
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

-- Recherche de la date de valeur la plus r�cente
SELECT MAX(TO_CHAR(datsitu,'yyyymmdd')) INTO l_datval1
FROM SITU_RESS
WHERE ident=TO_NUMBER(p_ident);

IF  l_datval<l_datval1 THEN                    /* Cas d'une situation interm�diaire */
  -- La date de d�part est obligatoire
  IF l_datfin IS NULL THEN
	Pack_Global.recuperer_message(20441, NULL, NULL, 'DATDEP', l_msg);
      		RAISE_APPLICATION_ERROR(-20441, l_msg);
		p_message := l_msg;
  END IF;
END IF;

-- Recherche de la date de d�part avant la modification
SELECT TO_CHAR(datdep,'yyyymmdd') INTO l_oldatdep
FROM SITU_RESS
WHERE TO_CHAR(datsitu,'dd/mm/yyyy')=p_oldatsitu
 AND  ident=TO_NUMBER(p_ident);

--l_oldatval:=to_char(to_date(p_oldatsitu,'dd/mm/yyyy'),'yyyymmdd');

---------------------------------------------
-- 1) La date de valeur est modifi�e
---------------------------------------------
IF (l_oldatval!=l_datval) THEN
	DBMS_OUTPUT.PUT_LINE('old: '||l_oldatval||' , new: '||l_datval);
	-----------------------------------------------------------------------
	-- 1.1) La date de valeur doit etre sup�rieure � la date de valeur d'origine
	-----------------------------------------------------------------------
	IF l_oldatval>l_datval THEN
	    Pack_Global.recuperer_message(20228, NULL, NULL, 'DATSITU' , l_msg);
            RAISE_APPLICATION_ERROR(-20228, l_msg);
	END IF;

	---------------------------------------------------------
	-- 1.2) La date de d�part est modifi�e
	---------------------------------------------------------
	IF (l_oldatdep!=l_datfin) THEN
		/*** Les nouvelles dates ne doiventt pes appartenir � d'autres situations ***/
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


		/*** La nouvelle date de d�part doit etre inf�rieure � la date de valeur suivante ***/
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
	-- 1.3) Cr�ation d'une nouvelle situation avec la nouvelle date de valeur
	---------------------------------------------------------------------------
	BEGIN
             INSERT INTO SITU_RESS (ident,
                                    datsitu,
                                    datdep,
                                    PRESTATION,
                                    soccode,
                                    codsg,
                                    mode_contractuel_indicatif
                                   )
             VALUES (TO_NUMBER(p_ident),
                     TO_DATE(p_datsitu,'mm/yyyy'),
                     TO_DATE(p_datdep,'dd/mm/yyyy'),
                     p_prestation,
                     p_soccode,
                     TO_NUMBER(p_codsg),
                     p_mode_contractuel
                    );

			l_datsitu :=TO_CHAR( TO_DATE(p_datsitu,'yyyymmdd'),'dd/mm/yyyy') ;
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'identifiant ressource', NULL, p_ident, 'Modification de la situation (date valeur situation : ' || l_datsitu ||')');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'date valeur situation', NULL, p_datsitu, 'Modification de la situation (date valeur situation : ' || l_datsitu ||')');

			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'code prestation', NULL, p_prestation, 'Modification de la situation (date valeur situation : ' || l_datsitu ||')');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'code soci�t�', NULL, p_soccode, 'Modification de la situation (date valeur situation : ' || l_datsitu ||')');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'code p�le/dpt/groupe', NULL, p_codsg, 'Modification de la situation (date valeur situation : ' || l_datsitu ||')');
      Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'mode contractuel indicatif', NULL, p_mode_contractuel, 'Modification de la situation (date valeur situation : ' || l_datsitu ||')');

	--------------------------------------------------------------------
	-- 1.4) Mise � jour de la date de d�part de la situation d'origine
	--------------------------------------------------------------------
           BEGIN
                 	UPDATE SITU_RESS
                            SET datdep = (TO_DATE(p_datsitu,'mm/yyyy')-1)
                        WHERE ident = TO_NUMBER(p_ident)
                             AND TO_CHAR(datsitu,'yyyymmdd') = l_oldatval;

				 Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'date d�part situation', p_datdep, TO_CHAR((TO_DATE(p_datsitu,'mm/yyyy')-1)), 'Modification de la situation');

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
-- 2) La date de valeur n'est pas modifi�e
---------------------------------------------

	DBMS_OUTPUT.PUT_LINE('old: '||l_oldatval||' , new: '||l_datval);
	---------------------------------------------------------
	-- 2.1) La date de d�part est modifi�e
	---------------------------------------------------------
	IF (l_oldatdep!=l_datfin) THEN
		/*** La nouvelle date de d�part doit etre inf�rieure � la date de valeur suivante ***/
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



	  SELECT datdep,codsg,soccode,PRESTATION ,cpident, mode_contractuel_indicatif INTO
	    l_old_datdep, l_old_codsg, l_old_soccode,  l_old_prestation ,l_old_cpident, l_mode_contractuel
	   FROM SITU_RESS
	      WHERE ident = TO_NUMBER(p_ident)
             AND TO_CHAR(datsitu,'yyyymmdd') = l_oldatval;




             UPDATE SITU_RESS
                SET datdep     = TO_DATE(p_datdep,'dd/mm/yyyy'),
                    codsg      = TO_NUMBER(p_codsg),
                    --filcode    = p_filcode,
                    soccode    = p_soccode,
                    PRESTATION = p_prestation,
                    cpident    = TO_NUMBER(p_cpident),
                    mode_contractuel_indicatif = p_mode_contractuel
             WHERE ident = TO_NUMBER(p_ident)
             AND TO_CHAR(datsitu,'yyyymmdd') = l_oldatval;


			l_oldatval:= TO_CHAR (TO_DATE(l_oldatval,'yyyymmdd') , 'dd/mm/yyyy');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'date d�part situation', TO_CHAR(l_old_datdep,'dd/mm/yyyy'), p_datdep, 'Modification de la situation (date valeur situation : '|| l_oldatval ||')');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'code prestation', l_old_prestation, p_prestation, 'Modification de la situation (date valeur situation : '|| l_oldatval ||')');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'code soci�t�',l_old_soccode, p_soccode, 'Modification de la situation (date valeur situation : '|| l_oldatval ||')');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'code p�le/dpt/groupe', TO_CHAR(l_old_codsg), p_codsg, 'Modification de la situation (date valeur situation : '|| l_oldatval ||')');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'Code chef de projet', TO_CHAR( l_old_cpident) , p_cpident, 'Modification de la situation (date valeur situation : '|| l_oldatval ||')');
      Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'mode contractuel indicatif', l_mode_contractuel , p_mode_contractuel, 'Modification de la situation (date valeur situation : '|| l_oldatval ||')');





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

    -- Message : 'situation Logiciel || p_rnom || modifie';

    Pack_Global.recuperer_message(20230, '%s1', p_rnom, NULL , l_msg);
    p_message := l_msg;

   END update_situation_l;

/*************************************************************************************
*************************************************************************************/

   PROCEDURE delete_situation_l (p_ident     IN  VARCHAR2,
                                 p_coufor    IN  VARCHAR2,
                                 p_rnom      IN  VARCHAR2,
                                 p_coutot    IN  VARCHAR2,
                                 p_datsitu   IN  VARCHAR2,
				 p_datdep    IN  VARCHAR2,
                                 p_flaglock  IN  NUMBER,
                                 p_userid    IN  VARCHAR2,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                ) IS

      l_msg VARCHAR2(1024);
      l_datval VARCHAR2(20);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
      l_flag RESSOURCE.flaglock%TYPE;

	  	l_user		RESSOURCE_LOGS.user_log%TYPE;

   BEGIN

      l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
      l_flag := 0;

      -- TEST : il doit toujours exister un row situation pour la ressource

      BEGIN
         SELECT COUNT(ident)
         INTO l_flag
         FROM SITU_RESS
         WHERE ident = TO_NUMBER(p_ident);

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
         INTO l_flag
         FROM RESSOURCE
         WHERE ident = TO_NUMBER(p_ident);

      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF l_flag != p_flaglock THEN
         Pack_Global.recuperer_message(20999, NULL, NULL, NULL , l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );
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
          DELETE FROM SITU_RESS
                 WHERE ident = TO_NUMBER(p_ident)
		AND TO_CHAR(datsitu,'dd/mm/yyyy') =l_datval;


			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'identifiant ressource', NULL, p_ident, 'Supression de la situation');
			Pack_Ressource_L.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'date valeur situation', NULL, l_datval, 'Supression de la situation');


      EXCEPTION

         WHEN referential_integrity THEN

            -- habiller le msg erreur

            Pack_Global.recuperation_integrite(-2292);

          WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
         Pack_Global.recuperer_message(20999, NULL, NULL, NULL , l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );
      ELSE
         Pack_Global.recuperer_message(2040, '%s1', p_ident, NULL , l_msg);
         p_message := l_msg;
      END IF;

   END delete_situation_l;

/***************************************************************************************
****************************************************************************************/
   PROCEDURE select_situation_l (p_mode        IN  VARCHAR2,
                                 p_ident        IN  VARCHAR2,
                                 p_coulog       IN  VARCHAR2,
                                 p_rnom         IN  RESSOURCE.rnom%TYPE,
                                 p_coutot       IN  VARCHAR2,
                                 p_datsitu      IN  VARCHAR2,
                                 p_flaglock     IN  VARCHAR2,
                                 p_userid       IN  VARCHAR2,
                                 p_cursituation IN OUT situationCurType,
                                 p_codsg           OUT VARCHAR2,
                                 p_soccode         OUT VARCHAR2,
                                 p_cpident         OUT VARCHAR2,
                                 p_dat             OUT VARCHAR2,
                                 p_coul            OUT VARCHAR2,
                                 p_prestation      OUT VARCHAR2,
                                 p_flag            OUT VARCHAR2,
                                 p_nbcurseur       OUT INTEGER,
                                 p_message         OUT VARCHAR2,
                                 p_mode_contractuel   OUT VARCHAR2
                                ) IS

      l_msg      VARCHAR2(1024);
      l_ges      NUMBER(3);
      l_contsitu NUMBER(3);
      l_idarpege VARCHAR2(255);
      l_habilitation VARCHAR2(10);
      l_datdep date;
      l_count NUMBER(3);
      l_soccode VARCHAR2(50);
      l_mode_contractuel VARCHAR2(5);

      l_codsg    SITU_RESS.codsg%TYPE;


   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 1;
      p_message := '';

	BEGIN
		SELECT
			codsg INTO l_codsg
		FROM
			SITU_RESS
		WHERE
			ident=p_ident
			AND datsitu=Pack_Verif_Restab.f_datsitu_recente(p_ident);
	END;



      BEGIN
         SELECT TO_CHAR(cout_log,'FM9999D00')
         INTO p_coul
         FROM COUT_STD2 , DATDEBEX
         WHERE annee = TO_NUMBER(TO_CHAR(DATDEBEX,'yyyy'))
			AND dpg_bas = (SELECT dpg_bas FROM COUT_STD2,DATDEBEX WHERE dpg_bas<= l_codsg
						AND l_codsg <=dpg_haut
						AND annee = TO_NUMBER(TO_CHAR(DATDEBEX,'yyyy'))
						AND ROWNUM = 1)
			AND METIER = 'ME';


      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           Pack_Global.recuperer_message(20510, NULL, NULL, NULL, l_msg);
           RAISE_APPLICATION_ERROR( -20510, l_msg);

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      p_prestation := 'LG';

      -- TEST : p_choix == Cr�er -> creation !='Cr�er' ->modif,supp

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

        -- CODSG, SOCCODE, CPIDENT

        BEGIN
            SELECT  codsg,  soccode,  cpident
            INTO   p_codsg, p_soccode, p_cpident
            FROM   SITU_RESS
            WHERE  ident = TO_NUMBER(p_ident)
            AND    TO_CHAR(datsitu,'dd/mm/yyyy') IN (
                              SELECT TO_CHAR(MAX(datsitu),'dd/mm/yyyy')
                              FROM SITU_RESS
                              WHERE ident = TO_NUMBER(p_ident)
                             );

        EXCEPTION
          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);

        END;


        -- On ouvre un curseur vide, pour mettre l'automate en mode creation
        BEGIN
          OPEN p_cursituation FOR
                   SELECT RESSOURCE.ident,
                          RESSOURCE.rnom,
                          TO_CHAR(RESSOURCE.coutot, '9999999999D00'),
                          RESSOURCE.flaglock,
                          TO_CHAR(SITU_RESS.datsitu,'mm/yyyy'),
                          TO_CHAR(SITU_RESS.datdep,'dd/mm/yyyy'),
                          SITU_RESS.codsg,
                          --situ_ress.filcode,
                          SITU_RESS.soccode,
                          SITU_RESS.PRESTATION,
                          SITU_RESS.cpident,
                          TO_CHAR(SITU_RESS.datsitu,'dd/mm/yyyy'),
                          TO_CHAR(NVL(cout_log,0), '999990D00'),
                          prestation.code_domaine
                   FROM RESSOURCE, SITU_RESS, COUT_STD2, DATDEBEX, PRESTATION
                   WHERE RESSOURCE.ident = -1
                     AND SITU_RESS.ident = -1
                     AND annee = TO_NUMBER(TO_CHAR(DATDEBEX,'yyyy'))
                     AND dpg_bas = ( SELECT dpg_bas FROM COUT_STD2,DATDEBEX WHERE dpg_bas <= l_codsg
						AND l_codsg <= dpg_haut
						AND annee = TO_NUMBER(TO_CHAR(DATDEBEX,'yyyy'))
						AND ROWNUM = 1 )
					  AND COUT_STD2.METIER = 'ME'
            AND SITU_RESS.PRESTATION = PRESTATION.PRESTATION(+);

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

        -- ====================================================================
      -- 7/02/2001 : Test appartenance du DPG au p�rim�tre de l'utilisateur
      -- ====================================================================
     	l_habilitation := Pack_Habilitation.fhabili_me( l_codsg,p_userid   );
	IF l_habilitation='faux' THEN
		-- Vous n'�tes pas autoris� � modifier cette ressource, son DPG est
		Pack_Global.recuperer_message(20365, '%s1',  'modifier/supprimer la situation', NULL, l_msg);
                RAISE_APPLICATION_ERROR(-20365, l_msg);
	END IF;

        --Recherche du mode contractuel de la ligne contrat si mode contractuel egal � '???' ou 'XXX'
         BEGIN
          SELECT SITU_RESS.mode_contractuel_indicatif INTO l_mode_contractuel
            FROM RESSOURCE, SITU_RESS
                   WHERE RESSOURCE.ident = TO_NUMBER(p_ident)
                     AND SITU_RESS.ident = TO_NUMBER(p_ident)
                     AND TO_CHAR(SITU_RESS.datsitu,'dd/mm/yyyy') = TO_CHAR(TO_DATE(p_datsitu,'dd/mm/yyyy'),'dd/mm/yyyy');
         EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      l_mode_contractuel := '???';
                   WHEN OTHERS THEN
                      RAISE_APPLICATION_ERROR ( -20997, SQLERRM);

         END;

         BEGIN
          SELECT datdep INTO l_datdep
           FROM SITU_RESS
              WHERE ident = TO_NUMBER(p_ident)
                AND datsitu = TO_DATE(p_datsitu,'dd/mm/yyyy');
         EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      null; --p_mode_contractuel := l_mode_contractuel;
                   WHEN OTHERS THEN
                      RAISE_APPLICATION_ERROR ( -20997, SQLERRM);

         END;

        if(l_mode_contractuel = '???' or l_mode_contractuel= 'XXX') then
            BEGIN
                IF (l_datdep is not null) THEN

                    SELECT mode_contractuel
                    INTO p_mode_contractuel
                    FROM ligne_cont
                    WHERE ident = TO_NUMBER(p_ident)
                    AND soccont = l_soccode
                    AND lresdeb >= TRUNC(TO_DATE(p_datsitu,'dd/mm/yyyy'),'MONTH')
                    AND lresdeb = (select MAX(lresdeb)
                                          from ligne_cont
                                          where ident = TO_NUMBER(p_ident)
                                          and soccont = l_soccode
                                          and lresdeb >= TRUNC(TO_DATE(p_datsitu,'dd/mm/yyyy'),'MONTH')
                                          and lresfin <= l_datdep)
                    AND rownum = 1;

               ELSE
                     SELECT mode_contractuel
                    INTO p_mode_contractuel
                    FROM ligne_cont, mode_contractuel
                    WHERE ident = TO_NUMBER(p_ident)
                    AND soccont = l_soccode
                    AND lresdeb >= TRUNC(TO_DATE(p_datsitu,'dd/mm/yyyy'),'MONTH')
                    AND lresdeb = (select MAX(lresdeb)
                                          from ligne_cont
                                          where ident = TO_NUMBER(p_ident)
                                          and soccont = l_soccode
                                          and lresdeb >= TRUNC(TO_DATE(p_datsitu,'dd/mm/yyyy'),'MONTH'))
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

         BEGIN
            OPEN p_cursituation FOR
                 SELECT RESSOURCE.ident,
                        RESSOURCE.rnom,
                        TO_CHAR(RESSOURCE.coutot, 'FM9999999990D00'),
                        RESSOURCE.flaglock,
                        TO_CHAR(SITU_RESS.datsitu,'mm/yyyy'),
                        TO_CHAR(SITU_RESS.datdep,'dd/mm/yyyy'),
                        SITU_RESS.codsg,
                        --situ_ress.filcode,
                        SITU_RESS.soccode,
                        SITU_RESS.PRESTATION,
                        SITU_RESS.cpident,
                        TO_CHAR(SITU_RESS.datsitu,'dd/mm/yyyy'),
                        TO_CHAR(NVL(cout_log,0), '999990D00'),
                        prestation.code_domaine
                 FROM RESSOURCE,SITU_RESS, COUT_STD2, DATDEBEX, PRESTATION
                 WHERE RESSOURCE.ident = TO_NUMBER(p_ident)
                 AND SITU_RESS.ident = TO_NUMBER(p_ident)
                 AND TO_CHAR(SITU_RESS.datsitu,'dd/mm/yyyy')
                     = TO_CHAR(TO_DATE(p_datsitu,'dd/mm/yyyy'),'dd/mm/yyyy')
                 AND annee = TO_NUMBER(TO_CHAR(DATDEBEX,'yyyy'))
                 AND dpg_bas = ( SELECT dpg_bas FROM COUT_STD2,DATDEBEX WHERE dpg_bas <= l_codsg
						AND l_codsg <= dpg_haut
						AND annee = TO_NUMBER(TO_CHAR(DATDEBEX,'yyyy'))
						AND ROWNUM = 1 )
				 AND COUT_STD2.METIER = 'ME'
         AND SITU_RESS.PRESTATION = PRESTATION.PRESTATION (+);


         EXCEPTION

            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR( -20997, SQLERRM);
         END;
       END IF;

       -- en cas absence
       -- p_message := 'La situation existe deja';

      Pack_Global.recuperer_message(2041, '%s1', p_ident, NULL , l_msg);
      p_message := l_msg;

   END select_situation_l;

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
                        WHERE ident = TO_NUMBER(p_ident) AND soccont = p_soccode
                        AND lresdeb >= TRUNC(TO_DATE(p_datsitu,'mm/yyyy'),'MONTH')
                        and lresfin <= TO_DATE(p_datdep,'dd/mm/yyyy')
                        AND lresdeb = (select MAX(lresdeb)
                                          from ligne_cont
                                          where ident = TO_NUMBER(p_ident)
                                          and soccont = p_soccode
                                          and lresdeb >= TRUNC(TO_DATE(p_datsitu,'mm/yyyy'),'MONTH')
                                          and lresfin <= TO_DATE(p_datdep,'dd/mm/yyyy'))
                        and rownum=1;
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
                        and rownum=1;
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

            IF(p_mode_contractuel_in = '???' or p_mode_contractuel_in= 'XXX') THEN
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
                        and rownum=1;
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
                        and rownum=1;
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

END Pack_Situation_L;
/


