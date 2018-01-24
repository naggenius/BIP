create or replace
PACKAGE     PACK_RESSOURCE_F AS

TYPE ressource_s_ViewType IS RECORD (ident      VARCHAR2(20),
                                     rnom       RESSOURCE.rnom%TYPE,
                                     coutot     VARCHAR2(20),
                                     flaglock   VARCHAR(20),
                                     datsitu    VARCHAR2(20),
                                     datdep     VARCHAR2(20),
                                     coufor       VARCHAR2(20),
                                     PRESTATION SITU_RESS.PRESTATION%TYPE,
                                     --filcode    situ_ress.filcode%TYPE,
                                     soccode    SITU_RESS.soccode%TYPE,
                                     codsg      VARCHAR2(20),
                                     typeForfait RESSOURCE.rtype%TYPE
                                    );

   TYPE ressource_f_sCurType IS REF CURSOR RETURN ressource_s_ViewType;
   TYPE ressourceCurType IS REF CURSOR RETURN RESSOURCE%ROWTYPE;

   PROCEDURE insert_ressource_f (p_rnom       IN  RESSOURCE.rnom%TYPE,
                                 p_prestation IN  SITU_RESS.PRESTATION%TYPE,
								 p_typeForfait IN RESSOURCE.rtype%TYPE,
				                 p_codsg      IN  VARCHAR2,
                                 p_soccode    IN  SITU_RESS.soccode%TYPE,
                                 p_datsitu    IN  VARCHAR2,
                                 p_datdep       IN  VARCHAR2,
                                 p_cpident    IN  VARCHAR2,
                                 p_coutot	IN VARCHAR2,
                                 p_coufor     IN  VARCHAR2,
                                 p_montant_mens     IN  VARCHAR2,
                                 p_flaglock   IN  VARCHAR2,
                                 p_userid     IN  VARCHAR2,
                                 p_modeContractuelInd    IN  VARCHAR2,
                                 p_nbcurseur  OUT INTEGER,
                                 p_message    OUT VARCHAR2,
                                 p_ident    OUT VARCHAR2
                                );

   PROCEDURE update_ressource_f (p_ident     IN  VARCHAR2,
                                 p_datsitu   IN  VARCHAR2,
                                 p_rnom      IN  RESSOURCE.rnom%TYPE,
                                 p_coutot    IN  VARCHAR2,
                                 p_typeForfait    IN  VARCHAR2,
                                 p_flaglock  IN  NUMBER,
                                 p_userid    IN  VARCHAR2,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                );

   PROCEDURE select_c_ressource_f (p_rnom          IN  RESSOURCE.rnom%TYPE,
				   p_typeForfait    IN  RESSOURCE.rtype%TYPE,
				   p_codsg	   IN  VARCHAR2,
                                   p_ident         IN  VARCHAR2,
                                   p_userid        IN  VARCHAR2,
                                   p_curressource  IN OUT ressourceCurType,
                                   p_date_courante    OUT VARCHAR2,
                                   p_coufor           OUT VARCHAR2,
                                   p_nbcurseur        OUT INTEGER,
                                   p_message          OUT VARCHAR2
                                  );

   PROCEDURE select_m_ressource_f (p_rnom         IN RESSOURCE.rnom%TYPE,
                                   p_prestation   IN SITU_RESS.PRESTATION%TYPE,
				   p_codsg	  IN VARCHAR2,
                                   p_ident        IN VARCHAR2,
                                   p_userid       IN VARCHAR2,
                                   p_curressource IN OUT ressource_f_sCurType,
                                   p_datsitu         OUT VARCHAR2,
                                   p_nbcurseur       OUT INTEGER,
                                   p_message         OUT VARCHAR2
                                  );

   PROCEDURE select_s_ressource_f (p_rnom         IN  RESSOURCE.rnom%TYPE,
				   p_codsg 	  IN  VARCHAR2,
                                   p_prestation   IN  SITU_RESS.PRESTATION%TYPE,
                                   p_ident        IN  VARCHAR2,
                                   p_userid       IN  VARCHAR2,
                                   p_curressource IN OUT ressource_f_sCurType,
                                   p_coufor          OUT VARCHAR2,
                                   p_flag            OUT VARCHAR2,
                                   p_nbcurseur       OUT INTEGER,
                                   p_message         OUT VARCHAR2
                                  );
    PROCEDURE maj_ressource_logs(p_ident	IN RESSOURCE_LOGS.ident%TYPE,
   										   							    p_user_log	IN RESSOURCE_LOGS.user_log%TYPE,
                                										p_table  	IN RESSOURCE_LOGS.nom_table%TYPE,
   																		p_colonne	IN RESSOURCE_LOGS.colonne%TYPE,
   																		p_valeur_prec	IN RESSOURCE_LOGS.valeur_prec%TYPE,
   																		p_valeur_nouv	IN RESSOURCE_LOGS.valeur_nouv%TYPE,
   																		p_commentaire	IN RESSOURCE_LOGS.commentaire%TYPE
   																		);

   PROCEDURE RECUP_LIB_MCI(p_mci        IN    VARCHAR2,
                               p_lib_mci    OUT    VARCHAR2,
                               p_loc        OUT VARCHAR2,
                               p_message        OUT     VARCHAR2);

END Pack_Ressource_F;

/

create or replace PACKAGE BODY       "PACK_RESSOURCE_F" AS

    PROCEDURE insert_ressource_f (p_rnom       IN  RESSOURCE.rnom%TYPE,
                                  p_prestation IN  SITU_RESS.PRESTATION%TYPE,
                                  p_typeForfait IN RESSOURCE.rtype%TYPE,
                                  p_codsg      IN  VARCHAR2,
                                  p_soccode    IN  SITU_RESS.soccode%TYPE,
                                  p_datsitu    IN  VARCHAR2,
                                  p_datdep       IN  VARCHAR2,
                                  p_cpident    IN  VARCHAR2,
                                  p_coutot	IN VARCHAR2,
                                  p_coufor     IN  VARCHAR2,
                                  p_montant_mens     IN  VARCHAR2,
                                  p_flaglock   IN  VARCHAR2,
                                  p_userid     IN  VARCHAR2,
                                  p_modeContractuelInd    IN  VARCHAR2,
                                  p_nbcurseur  OUT INTEGER,
                                  p_message    OUT VARCHAR2,
                                  p_ident    OUT VARCHAR2
                                 ) IS

      	l_msg           VARCHAR2(1024);
      	l_ident         RESSOURCE.ident%TYPE;
      	l_rtype         RESSOURCE.rtype%TYPE;
      	ldatsitu        VARCHAR2(10);
      	l_dsocfer       VARCHAR2(20);
      	l_date_courante VARCHAR2(20);
      	l_menu          VARCHAR2(255);
      	l_topfer        STRUCT_INFO.topfer%TYPE;
      	l_habilitation  VARCHAR2(10);
        l_mode_contractuel VARCHAR2(5);
        l_cpident       RESSOURCE.ident%TYPE;

      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2291);
	  l_user		RESSOURCE_LOGS.user_log%TYPE;
   BEGIN

     -- La regle de gestion 9.5.5 n'est pas suivie, gestion des utilisateur.
     -- Positionner le nb de curseurs ==> 0
     -- Initialiser le message retour
      p_nbcurseur := 0;

      -- Gestion de l'utilisateur pour cout (RES)

      l_menu := Pack_Global.lire_globaldata(p_userid).menutil;

	    l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);

      -- Contrôle de l'existence du chef de projet.
      BEGIN
        SELECT ident INTO l_cpident FROM RESSOURCE
        WHERE ident=TO_NUMBER(p_cpident);
        EXCEPTION WHEN NO_DATA_FOUND THEN
         Pack_Global.recuperer_message(20226, '%s1', p_cpident, 'CPIDENT', l_msg);
         RAISE_APPLICATION_ERROR(-20226, l_msg);
      END;

       -- Calcul de la nouvelle valeur de ident
      BEGIN
          SELECT MAX(ident)
          INTO l_ident
          FROM RESSOURCE;

      EXCEPTION

        WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;
      l_ident := l_ident +1;

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
             RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      SELECT TO_CHAR(SYSDATE,'yyyymmdd')
      INTO l_date_courante
      FROM DUAL;

      IF l_dsocfer <= l_date_courante THEN
             Pack_Global.recuperer_message(20225, '%s1', p_soccode, 'SOCCODE', l_msg);
             RAISE_APPLICATION_ERROR(-20225, l_msg);
      END IF;
     END IF;
     -- Test la validite de la valeur de p_codsg

     IF TO_NUMBER(p_codsg) <= 100000 THEN
          Pack_Global.recuperer_message(20223, '%s1', p_codsg, 'CODSG', l_msg);
          RAISE_APPLICATION_ERROR(-20223, l_msg);
     END IF;

      -- TEST : TOPFER de codsg si menutil = DIR
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

      -- ====================================================================
      -- 7/02/2001 : Test appartenance du DPG au périmètre de l'utilisateur
      -- ====================================================================
     	l_habilitation := Pack_Habilitation.fhabili_me( p_codsg,p_userid);
	IF l_habilitation='faux' THEN
		-- Vous n'êtes pas habilité à ce DPG 20364
		Pack_Global.recuperer_message(20364, '%s1', 'à ce DPG', 'CODSG', l_msg);
                RAISE_APPLICATION_ERROR(-20364, l_msg);
	END IF;
      -- TEST pour savoir si le champ cpident existe

      IF p_cpident IS NOT NULL THEN
           BEGIN

                -- TEST sur l'existance de la ressource
                SELECT rtype
                INTO l_rtype
                FROM RESSOURCE
                WHERE ident = TO_NUMBER(p_cpident);

           EXCEPTION

               WHEN NO_DATA_FOUND THEN
                   Pack_Global.recuperer_message(20226, '%s1', p_cpident, 'CPIDENT', l_msg);
                   RAISE_APPLICATION_ERROR(-20226, l_msg);

               WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR( -20997, SQLERRM);
           END;

           -- TEST pour savoir si cette ressource est une personne
           IF (l_rtype != 'P') AND (l_rtype IS NOT NULL)THEN
               Pack_Global.recuperer_message(20218, NULL, NULL, 'CPIDENT', l_msg);
               RAISE_APPLICATION_ERROR(-20218, l_msg);
           END IF;

      END IF;

      -- test mode contractuel

           BEGIN
               SELECT code_contractuel
               INTO l_mode_contractuel
               FROM mode_contractuel
               WHERE code_contractuel = p_modeContractuelInd
               and top_actif = 'O'
               and (type_ressource = p_typeForfait
               or type_ressource = '*'
               );
           EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  Pack_Global.recuperer_message( 21196, null, null, null, l_msg);
                  RAISE_APPLICATION_ERROR(-20226, l_msg);
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR( -20997, SQLERRM);
           END;


      -- la date d'arrivée d'une ressource doit être le 1er jour du mois qu'a saisi l'utilisateur
         ldatsitu := TO_CHAR(TO_DATE(p_datsitu,'mm/yyyy'),'yyyymm')||'01';


      -- INSERTION
      BEGIN




          INSERT INTO RESSOURCE (rnom,
                              coutot,
                              ident,
                         rtype,
                            rtel
                             )
                VALUES (p_rnom,
                    TO_NUMBER(p_coutot,'FM9999999999D00'),
                    l_ident,
                     p_typeForfait,
                  '000000'
                    );


      EXCEPTION

         WHEN DUP_VAL_ON_INDEX THEN
               -- msg : 'la ressource existe deja'
               Pack_Global.recuperer_message(20219, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20219, l_msg );
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;



	  BEGIN
	     -- On loggue le nom, type et cout dans la table ressource
            Pack_Ressource_F.maj_ressource_logs(l_ident,  l_user, 'RESSOURCE', 'Nom', NULL, p_rnom, 'Création de la ressource');
			Pack_Ressource_F.maj_ressource_logs(l_ident, l_user, 'RESSOURCE', 'Type', NULL, p_typeForfait, 'Création de la ressource');
			Pack_Ressource_F.maj_ressource_logs(l_ident, l_user, 'RESSOURCE', 'Coût Total', NULL, TO_NUMBER(p_coutot,'FM9999999999D00'), 'Création de la ressource');

	  END ;

      BEGIN






         INSERT INTO SITU_RESS (ident,
                                datsitu,
                                soccode,
                                codsg,
                                cout,
                                dispo,
                                PRESTATION,
                                rmcomp,
                                cpident,
                                datdep,
                                montant_mensuel,
                                mode_contractuel_indicatif
                               )
         VALUES (l_ident,
                 TO_DATE(ldatsitu,'yyyymmdd'),
                 p_soccode,
                 TO_NUMBER( p_codsg),
                 TO_NUMBER( p_coufor,'FM9999999999D00'),
                 TO_NUMBER('0,0'),
                 p_prestation,
                 0,
                 TO_NUMBER(p_cpident),
                 TO_DATE(p_datdep,'dd/mm/yyyy'),
                 DECODE (TO_NUMBER( p_montant_mens,'FM9999999999D00') ,0,'',TO_NUMBER( p_montant_mens,'FM9999999999D00') ),
                 p_modeContractuelInd
                );

			-- On logue le dpg, cout total , cout journalier, cout mensuel , date debut , date fin,société,cp
      Pack_Ressource_F.maj_ressource_logs(l_ident,  l_user, 'SITU_RESS', 'Code CP', NULL, p_cpident, 'Création de la situation');
        Pack_Ressource_F.maj_ressource_logs(l_ident,  l_user, 'SITU_RESS', 'cout journalier HT', NULL, p_coufor, 'Création de la situation');
			Pack_Ressource_F.maj_ressource_logs(l_ident,  l_user, 'SITU_RESS', 'Montant mensuel', NULL, p_montant_mens, 'Création de la situation');
			Pack_Ressource_F.maj_ressource_logs(l_ident,  l_user, 'SITU_RESS', 'Date début', NULL, ldatsitu, 'Création de la situation');
			Pack_Ressource_F.maj_ressource_logs(l_ident,  l_user, 'SITU_RESS', 'Date Fin', NULL, p_datdep, 'Création de la situation');
			Pack_Ressource_F.maj_ressource_logs(l_ident,  l_user, 'SITU_RESS', 'Société', NULL, p_soccode, 'Création de la situation');
			Pack_Ressource_F.maj_ressource_logs(l_ident,  l_user, 'SITU_RESS', 'Ident ressource', NULL, l_ident, 'Création de la situation');
			Pack_Ressource_F.maj_ressource_logs(l_ident,  l_user, 'SITU_RESS', 'Code Pôle/dept/groupe', NULL, p_codsg, 'Création de la situation');
      Pack_Ressource_F.maj_ressource_logs(l_ident,  l_user, 'SITU_RESS', 'Code prestation', NULL, p_prestation, 'Création de la situation');
      Pack_Ressource_F.maj_ressource_logs(l_ident,  l_user, 'SITU_RESS', 'Mode contractuel indicatif', NULL, p_modeContractuelInd, 'Création de la situation');


          --  'Forfait ' || p_rnom || ' cree avec l''identifiant || l_ident;
         Pack_Global.recuperer_message(2048, '%s1', p_rnom, '%s2',TO_CHAR(l_ident),
                                       NULL, l_msg);
         p_message := l_msg;
         p_ident := l_ident;

      EXCEPTION

         WHEN DUP_VAL_ON_INDEX THEN -- 'la ressource existe deja'
             Pack_Global.recuperer_message(20219, NULL, NULL, NULL, l_msg);

			    RAISE_APPLICATION_ERROR(  -20997, 'situ ress Non ok OK DUP  ' ||l_ident );

             RAISE_APPLICATION_ERROR( -20219, l_msg );

         WHEN referential_integrity THEN

            -- habiller le msg erreur
            Pack_Global.recuperation_integrite(-2291);

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;


  END insert_ressource_f;


   PROCEDURE update_ressource_f (p_ident     IN  VARCHAR2,
                                 p_datsitu   IN  VARCHAR2,
                                 p_rnom      IN  RESSOURCE.rnom%TYPE,
                                 p_coutot    IN  VARCHAR2,
                                 p_typeForfait    IN  VARCHAR2,
                                 p_flaglock  IN  NUMBER,
                                 p_userid    IN  VARCHAR2,
                                 p_nbcurseur OUT INTEGER,
                                 p_message   OUT VARCHAR2
                                ) IS

      l_msg VARCHAR2(1024);
      l_hom RESSOURCE.rnom%TYPE;
      l_oldrnom RESSOURCE.rnom%TYPE;

	  l_user		     RESSOURCE_LOGS.user_log%TYPE;
      v_rnom	       RESSOURCE.rnom%TYPE;
      v_coutot	    RESSOURCE.coutot%TYPE;
      v_typeforfait RESSOURCE.rtype%TYPE;

        CURSOR curseur_log(p_ident number) IS
              select MODE_CONTRACTUEL_INDICATIF, datsitu  from situ_ress
                where ident= p_ident
                and (datdep >= to_date(sysdate,'DD/MM/RRRR') or datdep is null);



   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour
      p_nbcurseur := 0;
      p_message := '';


	  l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
      -- TEST : interdiction homonyme

      BEGIN
         SELECT rnom
         INTO   l_hom
         FROM   RESSOURCE
         WHERE  rnom = p_rnom
           AND  rtype = 'F'
           AND  ROWNUM < 2;

      EXCEPTION

         WHEN NO_DATA_FOUND THEN
              NULL;

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      BEGIN
         SELECT rnom
         INTO   l_oldrnom
         FROM   RESSOURCE
         WHERE  ident = TO_NUMBER(p_ident);

      EXCEPTION

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF (l_hom IS NOT NULL) AND (l_hom != l_oldrnom) THEN
        Pack_Global.recuperer_message(20236, NULL, NULL , 'RNOM', l_msg);
        RAISE_APPLICATION_ERROR( -20236, l_msg );
      END IF;

      BEGIN

	   -- On récupère les valeurs précédentes pour les logs
            SELECT rnom, coutot, rtype
            INTO v_rnom, v_coutot, v_typeforfait
            FROM RESSOURCE
            WHERE ident  = TO_NUMBER(p_ident)
            AND flaglock = p_flaglock;

          UPDATE RESSOURCE SET rnom      = p_rnom,
                            coutot       = TO_NUMBER(NVL(p_coutot,'0')),
                            flaglock     = DECODE( p_flaglock, 1000000, 0, p_flaglock + 1),
                            rtype = p_typeForfait
          WHERE ident  = TO_NUMBER(p_ident)
          AND flaglock = p_flaglock;


		   -- On loggue le nom et cout menusuel et code société dans la table ressource logs
       Pack_Ressource_F.maj_ressource_logs(p_ident, l_user, 'RESSOURCE', 'Nom', v_rnom, p_rnom, 'Modification de la ressource');
		   Pack_Ressource_F.maj_ressource_logs(p_ident, l_user, 'RESSOURCE', 'Coût', v_coutot, TO_NUMBER(NVL(p_coutot,'0')), 'Modification de la ressource');
       Pack_Ressource_F.maj_ressource_logs(p_ident, l_user, 'RESSOURCE', 'Type', v_typeforfait, p_typeforfait, 'Modification de la ressource');


      EXCEPTION

         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
        Pack_Global.recuperer_message(20999, NULL,NULL , NULL, l_msg);
        RAISE_APPLICATION_ERROR( -20999, l_msg );
      ELSE




         IF (v_typeforfait != p_typeforfait) THEN

            BEGIN

             FOR cur IN  curseur_log(TO_NUMBER(p_ident)) LOOP

                    Pack_Ressource_F.maj_ressource_logs(p_ident, l_user, 'SITU_RESS', 'mode contractuel indicatif',cur.MODE_CONTRACTUEL_INDICATIF, '???', 'Modification (changement type de ressource) de la situation (date valeur situation : '|| cur.datsitu ||')');

                  END LOOP;


            -- en cas de chnagement de type ressource nous reinitialisons le MCI des situs actives ou futures
             update situ_ress set MODE_CONTRACTUEL_INDICATIF= '???'
                where
                ident =  TO_NUMBER(p_ident)
                and (datdep >= to_date(sysdate,'DD/MM/RRRR') or datdep is null);

              IF (SQL%ROWCOUNT > 0) THEN
                 Pack_Global.recuperer_message(21202, '%s1',p_rnom , NULL, l_msg);
            ELSE
                 Pack_Global.recuperer_message(21203, '%s1',p_rnom , NULL, l_msg);
              END IF;


            END;


         ELSE
          -- Message : 'ressource || p_rnom || modifie';
          Pack_Global.recuperer_message(2043, '%s1',p_rnom , NULL, l_msg);
         END IF;

         p_message := l_msg;

      END IF;

   END update_ressource_f;





    PROCEDURE select_c_ressource_f (p_rnom          IN  RESSOURCE.rnom%TYPE,
                                   p_typeForfait    IN  RESSOURCE.rtype%TYPE,
				   p_codsg	   IN  VARCHAR2,
                                   p_ident         IN  VARCHAR2,
                                   p_userid        IN  VARCHAR2,
                                   p_curressource  IN  OUT ressourceCurType,
                                   p_date_courante     OUT VARCHAR2,
                                   p_coufor            OUT VARCHAR2,
                                   p_nbcurseur         OUT INTEGER,
                                   p_message           OUT VARCHAR2
                                  ) IS

       l_msg VARCHAR2(1024);
       l_rnom RESSOURCE.rnom%TYPE;
       l_coufor VARCHAR2(20);
       l_typeForfait  RESSOURCE.rtype%TYPE;
       l_codsg	SITU_RESS.codsg%TYPE;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      p_nbcurseur := 1;
      p_message := '';

      -- TEST : interdiction des homonymes

      BEGIN
          SELECT rnom
          INTO   l_rnom
          FROM   RESSOURCE
          WHERE  rnom = p_rnom
           AND  ( rtype = 'F' OR rtype='E')
           AND   ROWNUM < 2;

      EXCEPTION

           WHEN NO_DATA_FOUND THEN
               NULL;

           WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF (l_rnom IS NOT NULL) THEN
         Pack_Global.recuperer_message(20236, '%s1',p_rnom , NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20236, l_msg);
      END IF;

    -- ====================================================================
      -- 10/09/2001 ARE: Test appartenance du DPG au périmètre de l'utilisateur
      -- ====================================================================
   	Pack_Habilitation.verif_habili_me(p_codsg,p_userid,l_msg);





      -- Renvoie la date courante
      SELECT TO_CHAR(SYSDATE,'mm/yyyy')
      INTO p_date_courante
      FROM DUAL;


	BEGIN
		SELECT
			codsg INTO l_codsg
		FROM
			SITU_RESS
		WHERE
			ident=p_ident
			AND datsitu=Pack_Verif_Restab.f_datsitu_recente(p_ident);
	EXCEPTION
		WHEN NO_DATA_FOUND THEN l_codsg := NULL;
	END;

	IF l_codsg IS NULL AND p_codsg IS NOT NULL THEN l_codsg := TO_NUMBER(p_codsg);END IF;



           l_coufor := '0,00';


      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *
      -- On ouvre le curseur suivant p_rnom
      BEGIN
        OPEN p_curressource FOR
             SELECT *
             FROM RESSOURCE
             WHERE rnom = p_rnom;

      EXCEPTION

        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      -- en cas absence
      -- 'Le forfait existe deja';
      Pack_Global.recuperer_message(2044, NULL, NULL, NULL, l_msg);
      p_message := l_msg;

   END select_c_ressource_f;




   PROCEDURE select_m_ressource_f (p_rnom         IN  RESSOURCE.rnom%TYPE,
                                   p_prestation   IN  SITU_RESS.PRESTATION%TYPE,
				   p_codsg	  IN  VARCHAR2,
                                   p_ident        IN  VARCHAR2,
                                   p_userid       IN  VARCHAR2,
                                   p_curressource IN  OUT ressource_f_sCurType,
                                   p_datsitu          OUT VARCHAR2,
                                   p_nbcurseur        OUT INTEGER,
                                   p_message          OUT VARCHAR2
                                  ) IS

      l_msg      VARCHAR2(1024);
      l_rtype    RESSOURCE.rtype%TYPE;
      l_codsg    SITU_RESS.codsg%TYPE;
      l_idarpege VARCHAR2(255);
      l_habilitation  VARCHAR2(10);
	  l_soccode SOCIETE.SOCCODE%TYPE;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      p_nbcurseur := 1;
      p_message := '';

      -- Gestion du niveau d'acces de l'utilisateur.
      BEGIN
         SELECT codsg, soccode
         INTO l_codsg, l_soccode
         FROM SITU_RESS
         WHERE ident = TO_NUMBER(p_ident)
         AND datsitu IN (SELECT MAX(datsitu)
                         FROM SITU_RESS
                         WHERE ident = TO_NUMBER(p_ident)
                        );



      EXCEPTION

          WHEN NO_DATA_FOUND THEN
                 Pack_Global.recuperer_message(20512, '%s1', 'Forfait', '%s2', '',NULL, l_msg);
		         RAISE_APPLICATION_ERROR( -20512,l_msg);

          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

	   IF  l_codsg IS NOT NULL THEN
      -- ====================================================================
      -- 23/11/2005 : Test appartenance du DPG au périmètre de l'utilisateur
      -- ====================================================================
     	l_habilitation := Pack_Habilitation.fhabili_me( l_codsg,p_userid   );
     	IF l_habilitation='faux' THEN
		-- Vous n'êtes pas autorisé à modifier cette ressource, son DPG est
		Pack_Global.recuperer_message(20365, '%s1',  'modifier cette ressource, son DPG est '||l_codsg, 'IDENT', l_msg);
                RAISE_APPLICATION_ERROR(-20365, l_msg);
	END IF;
      END IF;


      -- On recherche du type de ressource associe a l'identifiant
      BEGIN
        SELECT rtype
        INTO l_rtype
        FROM RESSOURCE
        WHERE ident = TO_NUMBER(p_ident);


	  IF(l_rtype = 'P' )THEN
		     SELECT DECODE(l_soccode,'SG..','A',l_rtype) INTO l_rtype FROM DUAL;
		END IF;

      EXCEPTION

          WHEN NO_DATA_FOUND THEN
                 Pack_Global.recuperer_message(20512, '%s1', 'Forfait', '%s2', '',NULL, l_msg);
		         RAISE_APPLICATION_ERROR( -20512,l_msg);

          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF (l_rtype != 'F' AND l_rtype !='E') THEN
            Pack_Global.recuperer_message(20233, '%s1', p_ident,
                                                 '%s2', l_rtype, 'IDENT', l_msg);
            RAISE_APPLICATION_ERROR(-20233, l_msg);
      END IF;

      -- On recherche la date d'arrivee de la ressource
      BEGIN
         SELECT TO_CHAR(MIN(datsitu),'dd/mm/yyyy')
         INTO p_datsitu
         FROM SITU_RESS
         WHERE ident = TO_NUMBER(p_ident);

      EXCEPTION

          WHEN NO_DATA_FOUND THEN
                Pack_Global.recuperer_message(20512, '%s1', 'Forfait', '%s2', '',NULL, l_msg);
		         RAISE_APPLICATION_ERROR( -20512,l_msg);

          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *
      -- On ouvre le curseur suivant p_rnom
      BEGIN
        OPEN p_curressource FOR
             SELECT RESSOURCE.ident,
                    RESSOURCE.rnom,
                    TO_CHAR(RESSOURCE.coutot,'FM9999999990D00'),
                    RESSOURCE.flaglock,
                    TO_CHAR(SITU_RESS.datsitu,'mm/yyyy'),
                    TO_CHAR(SITU_RESS.datdep,'dd/mm/yyyy'),
                    TO_CHAR(SITU_RESS.cout,'FM9999999990D00'),
                    SITU_RESS.PRESTATION,
                    --situ_ress.filcode,
                    SITU_RESS.soccode,
                    SITU_RESS.codsg,
                    RESSOURCE.rtype
             FROM RESSOURCE,SITU_RESS
             WHERE RESSOURCE.ident = TO_NUMBER(p_ident)
             AND   SITU_RESS.ident = TO_NUMBER(p_ident);

      EXCEPTION

          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      -- en cas absence
      -- p_message := 'Le forfait n''existe pas';
      Pack_Global.recuperer_message(2045, '%s1', p_ident, NULL, l_msg);
      p_message := l_msg;

   END select_m_ressource_f;


   PROCEDURE select_s_ressource_f (p_rnom         IN  RESSOURCE.rnom%TYPE,
				   p_codsg 	  IN  VARCHAR2,
                                   p_prestation   IN  SITU_RESS.PRESTATION%TYPE,
                                   p_ident        IN  VARCHAR2,
                                   p_userid       IN  VARCHAR2,
                                   p_curressource IN  OUT ressource_f_sCurType,
                                   p_coufor           OUT VARCHAR2,
                                   p_flag             OUT VARCHAR2,
                                   p_nbcurseur        OUT INTEGER,
                                   p_message          OUT VARCHAR2
                                  ) IS

      l_msg VARCHAR2(1024);
      l_rtype RESSOURCE.rtype%TYPE;
      l_prestation SITU_RESS.PRESTATION%TYPE;
      l_codsg	SITU_RESS.codsg%TYPE;
     l_habilitation VARCHAR2(10);
	 l_soccode SOCIETE.soccode%TYPE;


   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      p_nbcurseur := 1;
      p_message := '';

      BEGIN
         SELECT TO_CHAR(flaglock)
         INTO p_flag
         FROM RESSOURCE
         WHERE ident = TO_NUMBER(p_ident);

      EXCEPTION

          WHEN NO_DATA_FOUND THEN
             NULL;

          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      --
      BEGIN

         SELECT PRESTATION,cout,soccode
         INTO   l_prestation,p_coufor,l_soccode
         FROM   SITU_RESS
         WHERE  ident = TO_NUMBER(p_ident)
         AND    TO_CHAR(datsitu,'dd/mm/yyyy') IN (SELECT TO_CHAR(MAX(datsitu),'dd/mm/yyyy')
                                                  FROM SITU_RESS
                                                  WHERE ident = TO_NUMBER(p_ident)
                                                 );



      EXCEPTION

         WHEN NO_DATA_FOUND THEN
                 Pack_Global.recuperer_message(20512, '%s1', 'Forfait', '%s2', '',NULL, l_msg);
		         RAISE_APPLICATION_ERROR( -20512,l_msg);

         WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR( -20997, SQLERRM );
      END;

	BEGIN
		SELECT  codsg INTO  l_codsg
		FROM 	SITU_RESS
		WHERE	ident=p_ident
			AND  datsitu=Pack_Verif_Restab.f_datsitu_recente(p_ident);
	EXCEPTION
		WHEN  NO_DATA_FOUND THEN  l_codsg := NULL ;
	END ;


	/*  IF  l_codsg IS NOT NULL THEN
      -- ====================================================================
      -- 23/11/2005 : Test appartenance du DPG au périmètre de l'utilisateur
      -- ====================================================================
     	l_habilitation := Pack_Habilitation.fhabili_me( l_codsg,p_userid   );
     	IF l_habilitation='faux' THEN
		-- Vous n'êtes pas autorisé à modifier cette ressource, son DPG est
		Pack_Global.recuperer_message(20365, '%s1',  'consulter cette ressource, son DPG est '||l_codsg, 'IDENT', l_msg);
                RAISE_APPLICATION_ERROR(-20365, l_msg);
	END IF;
      END IF;*/

      -- TEST : Le type de la ressource est bien Forfait
      BEGIN
         SELECT rtype
         INTO l_rtype
         FROM RESSOURCE
         WHERE ident = TO_NUMBER(p_ident);


		 IF(l_rtype = 'P' )THEN
		     SELECT DECODE(l_soccode,'SG..','A',l_rtype) INTO l_rtype FROM DUAL;
		END IF;

      EXCEPTION
          WHEN NO_DATA_FOUND THEN
             NULL;

          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      IF (l_rtype != 'F' AND l_rtype != 'E') THEN
            Pack_Global.recuperer_message(20233, '%s1', p_ident,
                                                 '%s2', l_rtype, 'IDENT', l_msg);
          RAISE_APPLICATION_ERROR( -20233, l_msg);
      END IF;

      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *
      -- On ouvre le curseur suivant p_rnom
      BEGIN
        OPEN p_curressource FOR
             SELECT RESSOURCE.ident,
                    RESSOURCE.rnom,
                    TO_CHAR(RESSOURCE.coutot,'FM9999999990D00'),
                    RESSOURCE.flaglock,
                    TO_CHAR(SITU_RESS.datsitu,'mm/yyyy'),
                    TO_CHAR(SITU_RESS.datdep,'dd/mm/yyyy'),
                    TO_CHAR(SITU_RESS.cout,'FM9999999990D00'),
                    SITU_RESS.PRESTATION,
                    --situ_ress.filcode,
                    SITU_RESS.soccode,
                    SITU_RESS.codsg,
                    RESSOURCE.rtype
             FROM RESSOURCE,SITU_RESS
             WHERE RESSOURCE.ident = TO_NUMBER(p_ident)
             AND   SITU_RESS.ident = TO_NUMBER(p_ident);

      EXCEPTION

          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
      END;

      -- en cas absence
      -- p_message := 'Le forfait n''existe pas';
      Pack_Global.recuperer_message(2045, '%s1', p_ident, NULL, l_msg);
      p_message := l_msg;

   END select_s_ressource_f;

   PROCEDURE maj_ressource_logs(p_ident		IN RESSOURCE_LOGS.ident%TYPE,
   				                                                          p_user_log	IN RESSOURCE_LOGS.user_log%TYPE,
                                                                          p_table  	IN RESSOURCE_LOGS.nom_table%TYPE,
   				                                                          p_colonne	IN RESSOURCE_LOGS.colonne%TYPE,
   				                                                          p_valeur_prec	IN RESSOURCE_LOGS.valeur_prec%TYPE,
   																		  p_valeur_nouv	IN RESSOURCE_LOGS.valeur_nouv%TYPE,
   																		  p_commentaire	IN RESSOURCE_LOGS.commentaire%TYPE
   																		  ) IS
   BEGIN

	IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
		INSERT INTO RESSOURCE_LOGS
			(ident, date_log, user_log, nom_table, colonne, valeur_prec, valeur_nouv, commentaire)
		VALUES
			(p_ident, CURRENT_TIMESTAMP, p_user_log, p_table, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);
   --PPM 57823 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes
	END IF;
	-- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

   END maj_ressource_logs;


   PROCEDURE RECUP_LIB_MCI(p_mci        IN    VARCHAR2,
                               p_lib_mci    OUT    VARCHAR2,
                               p_loc        OUT VARCHAR2,
                               p_message        OUT     VARCHAR2)
            IS
msg         VARCHAR(1024);
BEGIN
    SELECT LIBELLE, CODE_LOCALISATION INTO p_lib_mci, p_loc
    FROM mode_contractuel
    WHERE CODE_CONTRACTUEL=p_mci;


    EXCEPTION
    WHEN NO_DATA_FOUND THEN
            Pack_Global.recuperer_message( 21191, NULL, NULL, NULL, p_message);
    WHEN OTHERS THEN
                   RAISE_APPLICATION_ERROR( -20997, SQLERRM);


END RECUP_LIB_MCI;

END Pack_Ressource_F;


/

show errors
