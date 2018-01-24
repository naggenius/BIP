-- *****************************************************************************************
-- Package
-- Créé    le 09/11/2005 par JMA 
-- Modifié le 14/11/2005 par BAA  Ajout de la procedure update_propose_rjh Procédure 
-- 				  qui met à jour les proposés
--  Modifié le 27/01/2006 par BAA Ajouter message 
--  Modifié le 16/02/2006 par PPR Modification pour traiter en une fois toutes les tables
--                                   de la même direction dans update_propose_rjh 
--  Modifié le 20/02/2006 par DDI Fiche 339 : Prise en compte de la répartition des arbitrés
--  Modifié le 17/03/2006 par PPR Pour les proposés et arbitrés passe en parametre
--                                   le code de la direction au lieu de la table
-- Modifié le 06/02/2007 par Emmanuel VINATIER: Prise en compte du nouveau champ DPG dans la table RJH_TABLEREPART
-- Modifié le 23/04/2007 par Emmanuel VINATIER: changement DPG remplacé par CODDEPPOLE
-- ******************************************************************************************

CREATE OR REPLACE PACKAGE Pack_Rjh_Tablerepart AS

   -- Définition curseur sur la table RJH_TABREPART

   TYPE TableRepart_ViewType IS RECORD ( codrep RJH_TABREPART.CODREP%TYPE,
   							 		   	 librep RJH_TABREPART.LIBREP%TYPE,
										 coddir RJH_TABREPART.CODREP%TYPE,
										 libdir DIRECTIONS.LIBDIR%TYPE,
										 flagactif RJH_TABREPART.FLAGACTIF%TYPE,
										 coddeppole RJH_TABREPART.CODDEPPOLE%TYPE,
										 libdsg CHAR(7)
									   );

   TYPE tablerepartCurType_Char IS REF CURSOR RETURN TableRepart_ViewType;

-- ----------------------------------------------------------------
-- Procédure qui ramène une table de répartition suivant son code
-- ----------------------------------------------------------------
   PROCEDURE select_table ( p_codrep	   	 IN VARCHAR2,
                            p_userid         IN VARCHAR2,
                            p_curTableRepart IN OUT tablerepartCurType_Char ,
                            p_nbcurseur         OUT INTEGER,
                            p_message           OUT VARCHAR2
                          );

-- ----------------------------------------------------------------
-- Procédure qui insert une table de répartition
-- ----------------------------------------------------------------
   PROCEDURE insert_table ( p_codrep      	IN  RJH_TABREPART.CODREP%TYPE,
				  		  	p_librep     	IN  RJH_TABREPART.LIBREP%TYPE,
                            p_coddir     	IN  RJH_TABREPART.CODDIR%TYPE,
                            p_flagactif   	IN  RJH_TABREPART.FLAGACTIF%TYPE,
                           	p_userid     	IN  VARCHAR2,
							p_coddeppole	IN  RJH_TABREPART.CODDEPPOLE%TYPE,
                            p_nbcurseur  	OUT INTEGER,
                            p_message    	OUT VARCHAR2
                          );

-- ----------------------------------------------------------------
-- Procédure qui met à jour une table de répartition
-- ----------------------------------------------------------------
   PROCEDURE update_table ( p_codrep      	IN  RJH_TABREPART.CODREP%TYPE,
				  		  	p_librep     	IN  RJH_TABREPART.LIBREP%TYPE,
                            p_coddir     	IN  RJH_TABREPART.CODDIR%TYPE,
                            p_flagactif   	IN  RJH_TABREPART.FLAGACTIF%TYPE,
                           	p_userid     	IN  VARCHAR2,
							p_coddeppole	IN  RJH_TABREPART.CODDEPPOLE%TYPE,
                            p_nbcurseur  	OUT INTEGER,
                            p_message    	OUT VARCHAR2
                          );

-- ----------------------------------------------------------------
-- Procédure qui supprime une table de répartition
-- ----------------------------------------------------------------
   PROCEDURE delete_table ( p_codrep    IN  RJH_TABREPART.CODREP%TYPE,
                            p_userid    IN  VARCHAR2,
                            p_nbcurseur OUT INTEGER,
                            p_message   OUT VARCHAR2
                          );


-- ----------------------------------------------------------------
-- Procédure qui mis à jour les proposés
-- ----------------------------------------------------------------
   PROCEDURE update_propose_rjh ( p_annee      	IN  INTEGER,
   			 					  											p_coddir IN VARCHAR,
																			p_mois_table IN VARCHAR,
																			p_nbcurseur  	OUT INTEGER,
                            												p_message    	OUT VARCHAR2
                         												   );

-- -----------------------------------------------------------------------
-- Procédure qui initialise les budgets Arbitrés Proposés sur les types 9.
-- -----------------------------------------------------------------------
   PROCEDURE update_arbitre_rjh ( p_annee      	IN  INTEGER,
   			 	  p_coddir 	IN  VARCHAR,
				  p_mois_table 	IN  VARCHAR,
				  p_nbcurseur  	OUT INTEGER,
                            	  p_message    	OUT VARCHAR2
                         		);

	FUNCTION en_anomalie(p_codrep IN RJH_TABREPART_DETAIL.CODREP%TYPE,
							   p_moisrep IN RJH_TABREPART_DETAIL.MOISREP%TYPE
							   ) return VARCHAR;
END Pack_Rjh_Tablerepart;
/
CREATE OR REPLACE PACKAGE BODY Pack_Rjh_Tablerepart AS


VIOLATION_CONSTRAINT_UNIQUE EXCEPTION;          -- pour clause when
PRAGMA EXCEPTION_INIT( VIOLATION_CONSTRAINT_UNIQUE, -00001 );


-- ----------------------------------------------------------------
-- Procédure qui ramène une table de répartition suivant son code
-- ----------------------------------------------------------------
PROCEDURE select_table ( p_codrep         IN VARCHAR2,
                         p_userid         IN VARCHAR2,
                         p_curTableRepart IN OUT tablerepartCurType_Char ,
                         p_nbcurseur         OUT INTEGER,
                         p_message           OUT VARCHAR2
                       ) IS
	l_msg VARCHAR2(1024);
BEGIN

    -- Positionner le nb de curseurs ==> 1
    -- Initialiser le message retour
    p_nbcurseur := 1;
    p_message := '';

	BEGIN
	    OPEN p_curTableRepart FOR
	        SELECT r.codrep,
	               r.librep,
	               r.coddir,
	               d.libdir,
				   r.flagactif,
				   r.coddeppole,
           		   s.sigdep||'/'||s.sigpole libdeppole
	          FROM RJH_TABREPART r, DIRECTIONS d, STRUCT_INFO s
	         WHERE r.CODDIR = d.CODDIR
			   AND r.CODREP = p_codrep
			   AND s.CODDEPPOLE = r.CODDEPPOLE;

	EXCEPTION
	   WHEN OTHERS THEN
		   RAISE_APPLICATION_ERROR( -20997, SQLERRM);
	END;

	-- En cas d'absence
    Pack_Global.recuperer_message( 21034, '%s1', 'table de répartition', NULL, l_msg);
    p_message := l_msg;

END select_table;





-- ----------------------------------------------------------------
-- Procédure qui insert une table de répartition
-- ----------------------------------------------------------------
PROCEDURE insert_table ( p_codrep      	IN  RJH_TABREPART.CODREP%TYPE,
			  		  	 p_librep     	IN  RJH_TABREPART.LIBREP%TYPE,
                         p_coddir     	IN  RJH_TABREPART.CODDIR%TYPE,
                         p_flagactif   	IN  RJH_TABREPART.FLAGACTIF%TYPE,
                         p_userid     	IN  VARCHAR2,
						 p_coddeppole	IN  RJH_TABREPART.CODDEPPOLE%TYPE,
                         p_nbcurseur  	OUT INTEGER,
                         p_message    	OUT VARCHAR2
                       ) IS

     l_msg VARCHAR2(1024);
BEGIN

    -- Positionner le nb de curseurs ==> 0
    -- Initialiser le message retour
    p_nbcurseur := 0;
    p_message := '';

	BEGIN
   	    INSERT INTO RJH_TABREPART (
	    	   codrep,
 			   librep,
 			   coddir,
 			   flagactif,
			   coddeppole)
        VALUES (
		   	   p_codrep,
		   	   p_librep,
		   	   p_coddir,
		   	   p_flagactif,
			   p_coddeppole);

	    -- Table de répartiton p_codrep créée'
        Pack_Global.recuperer_message( 21035, '%s1', 'Table de répartition '||p_codrep, NULL, l_msg);
    EXCEPTION
      	WHEN DUP_VAL_ON_INDEX THEN
		    Pack_Global.recuperer_message( 20001, NULL, NULL, NULL, l_msg);
            RAISE_APPLICATION_ERROR( -20001, l_msg );
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;

END insert_table;




-- ----------------------------------------------------------------
-- Procédure qui met à jour une table de répartition
-- ----------------------------------------------------------------
PROCEDURE update_table ( p_codrep      	IN  RJH_TABREPART.CODREP%TYPE,
				  		 p_librep     	IN  RJH_TABREPART.LIBREP%TYPE,
                         p_coddir     	IN  RJH_TABREPART.CODDIR%TYPE,
                         p_flagactif   	IN  RJH_TABREPART.FLAGACTIF%TYPE,
                         p_userid     	IN  VARCHAR2,
						 p_coddeppole	IN  RJH_TABREPART.CODDEPPOLE%TYPE,
                         p_nbcurseur  	OUT INTEGER,
                         p_message    	OUT VARCHAR2
                       ) IS

	l_msg VARCHAR2(1024);
	l_codcamo CENTRE_ACTIVITE.codcamo%TYPE;
BEGIN

    -- Positionner le nb de curseurs ==> 0
    -- initialiser le message retour
	p_nbcurseur := 0;
	p_message := '';

	BEGIN

        UPDATE RJH_TABREPART
		   SET librep    = p_librep,
		   	   coddir    = p_coddir,
			   flagactif = p_flagactif,
			   coddeppole = p_coddeppole
		 WHERE codrep = p_codrep;

    EXCEPTION
		WHEN OTHERS THEN
		    Pack_Global.recuperer_message( 20006, '%s1', 'Table de répartition', NULL, l_msg);
	        RAISE_APPLICATION_ERROR( -20006, l_msg );
	END;

END update_table;




-- ----------------------------------------------------------------
-- Procédure qui supprime une table de répartition
-- ----------------------------------------------------------------
PROCEDURE delete_table ( p_codrep    IN  RJH_TABREPART.CODREP%TYPE,
                         p_userid    IN  VARCHAR2,
                         p_nbcurseur OUT INTEGER,
                         p_message   OUT VARCHAR2
                       ) IS

	l_msg VARCHAR2(1024);
	nb_ligne_bip NUMBER;
    referential_integrity EXCEPTION;
    PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

BEGIN

    -- Positionner le nb de curseurs ==> 0
    -- Initialiser le message retour
    p_nbcurseur := 0;
    p_message := '';

	-- test si une ligne bip est reliée à la table on ne la supprime pas
	BEGIN
	    SELECT COUNT(*)
		  INTO nb_ligne_bip
		  FROM LIGNE_BIP
		 WHERE codrep = p_codrep;

		IF (nb_ligne_bip > 0) THEN
		    -- Suppression interdite. Des lignes BIP sont rattachées à cette table.
			Pack_Global.recuperer_message( 21036, NULL, NULL, NULL, l_msg);
			p_message := l_msg;
		ELSE

    		BEGIN
				-- suppression de la table DETAIL
			    DELETE FROM RJH_TABREPART_DETAIL
				 WHERE codrep = p_codrep;

			    -- suppression de la table des erreurs de chargement
			    DELETE FROM RJH_CHARG_ERREUR e
				 WHERE e.codchr IN (SELECT c.codchr FROM RJH_CHARGEMENT c WHERE c.codrep = p_codrep);

			    -- suppression de la table des chargements
			    DELETE FROM RJH_CHARGEMENT
				 WHERE codrep = p_codrep;

			    -- suppression de la table de répartition
			    DELETE FROM RJH_TABREPART
				 WHERE codrep = p_codrep;
		    EXCEPTION
				WHEN referential_integrity THEN
		            -- habiller le msg erreur
		            Pack_Global.recuperation_integrite(-2292);
				WHEN OTHERS THEN
				    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
		    END;

			-- Table de répartiton p_coderep supprimée'
			Pack_Global.recuperer_message( 20007, '%s1', 'Table de répartition '||p_codrep, NULL, l_msg);
			p_message := l_msg;

		END IF;

	END;

END delete_table;



-- ----------------------------------------------------------------
-- Procédure qui mis à jour les proposés
-- ----------------------------------------------------------------
   PROCEDURE update_propose_rjh ( p_annee      	IN  INTEGER,
   			 					  											p_coddir IN VARCHAR,
																			p_mois_table IN VARCHAR,
																			p_nbcurseur  	OUT INTEGER,
                            												p_message    	OUT VARCHAR2
                        												   ) IS
		l_bpmontmo NUMBER(12,2);
		l_bpmontme NUMBER(12,2);

		l_date DATE;

		v_bpmontmo NUMBER(12,2);
		v_bpmontme NUMBER(12,2);

		l_count NUMBER;

--
--  Ramene toutes les tables de repartition qui ont la direction passée en parametre
		CURSOR cur_tab(c_coddir CHAR, c_mois_table CHAR) IS
                     SELECT DISTINCT codrep
					 FROM RJH_TABREPART_DETAIL
					 WHERE codrep IN ( SELECT codrep from RJH_TABREPART
					                   WHERE coddir = TO_NUMBER ( c_coddir )
					                  )
                     AND moisrep=TO_DATE(c_mois_table,'mm/yyyy')
                     AND TYPTAB='P'
					 ;

		CURSOR cur_prop(c_table_rep CHAR, c_mois_table CHAR) IS
                     SELECT
				 	 		pid,
							tauxrep
					 FROM RJH_TABREPART_DETAIL
					 WHERE CODREP=c_table_rep
                     AND MOISREP=TO_DATE(c_mois_table,'mm/yyyy')
                     AND TYPTAB='P'
					 ;

 BEGIN
 	SELECT SYSDATE INTO l_date FROM DUAL;

    -- Remet à zero tous les proposes des lignes T9 de la direction
    UPDATE BUDGET
    SET  bpmontmo = 0, bpmontme = 0, bpdate = l_date, flaglock = DECODE(flaglock, 1000000, 0, flaglock + 1)
    WHERE  pid IN ( SELECT pid FROM LIGNE_BIP
                    WHERE typproj = 9
                    AND codsg IN ( SELECT codsg FROM STRUCT_INFO
                    			   WHERE coddir = TO_NUMBER ( p_coddir )
					           	 )
					)
	AND annee = p_annee
	;
    COMMIT;


	-- Boucle sur toutes les tables de répartition
	FOR curseur_tab IN cur_tab(p_coddir, p_mois_table) LOOP

 		-- Recherche le proposé à répartir pour une table de répartition
	    SELECT SUM(b.BPMONTMO), SUM(b.BPMONTME) INTO l_bpmontmo, l_bpmontme
        FROM LIGNE_BIP l,BUDGET b
        WHERE l.CODREP=curseur_tab.codrep
        AND b.pid=l.pid
        AND b.ANNEE=p_annee
        AND l.codcamo=66666
        ;

		-- Boucle sur les lignes BIP de la table de répartition
	    FOR curseur_prop IN cur_prop(curseur_tab.codrep, p_mois_table) LOOP
			BEGIN

			-- Calcule le montant réparti
          	v_bpmontmo := l_bpmontmo * curseur_prop.tauxrep ;
          	v_bpmontme := l_bpmontme * curseur_prop.tauxrep ;

			-- Essaie d'insérer dans budget
			INSERT INTO BUDGET (
			 				  	 PID,
								 ANNEE,
								 BPMONTMO,
								 BPMONTME,
								 BPDATE,
								 FLAGLOCK
								)
             VALUES(
					     		curseur_prop.pid,
								p_annee,
					 			v_bpmontmo,
					 			v_bpmontme,
								l_date,
							    0
								);


			EXCEPTION

            WHEN VIOLATION_CONSTRAINT_UNIQUE THEN

			-- Fait la mise à jour dans budget en ajoutant les proposés
			-- aux proposés existants
                    UPDATE BUDGET
                    SET  bpmontmo = bpmontmo + v_bpmontmo, bpmontme = bpmontme + v_bpmontme, bpdate = l_date, flaglock = DECODE(flaglock, 1000000, 0, flaglock + 1)
                    WHERE  pid = curseur_prop.pid
					AND annee = p_annee ;

					END;


		END LOOP;

	END LOOP;

	Pack_Global.recuperer_message(21042, NULL,  NULL, NULL, p_message);
	COMMIT;


    EXCEPTION
    	WHEN OTHERS THEN
		    ROLLBACK;
        	RAISE_APPLICATION_ERROR( -20997, SQLERRM);



 END update_propose_rjh;

-- -----------------------------------------------------------------------
-- Procédure qui initialise les budgets Arbitrés Notifié sur les types 9.
-- -----------------------------------------------------------------------
   PROCEDURE update_arbitre_rjh ( p_annee      	IN  INTEGER,
   			 	  p_coddir 	IN VARCHAR,
				  p_mois_table 	IN VARCHAR,
				  p_nbcurseur  	OUT INTEGER,
                            	  p_message    	OUT VARCHAR2
                        		) IS
		l_anmont INTEGER;
		l_date DATE;
		v_anmont INTEGER(12,2);
		l_count NUMBER;

--
--  Ramene toutes les tables de repartition qui ont la  direction passée en parametre
		CURSOR cur_tab(c_coddir CHAR, c_mois_table CHAR) IS
                     SELECT DISTINCT codrep
		     FROM RJH_TABREPART_DETAIL
		     WHERE codrep IN ( SELECT codrep
		     			from RJH_TABREPART
			                WHERE coddir = TO_NUMBER ( c_coddir )
					                  )
                     AND moisrep=TO_DATE(c_mois_table,'mm/yyyy')
                     AND TYPTAB='A'
					 ;

		CURSOR cur_prop(c_table_rep CHAR, c_mois_table CHAR) IS
                     SELECT pid,
			    tauxrep
		     FROM RJH_TABREPART_DETAIL
		     WHERE CODREP=c_table_rep
                     AND MOISREP=TO_DATE(c_mois_table,'mm/yyyy')
                     AND TYPTAB='A'
					 ;

 BEGIN
 	SELECT SYSDATE INTO l_date FROM DUAL;

    -- Remet à zero tous les arbitres des lignes T9 de la direction
    UPDATE BUDGET
    SET  anmont = 0, apdate = l_date, flaglock = DECODE(flaglock, 1000000, 0, flaglock + 1)
    WHERE  pid IN ( SELECT pid FROM LIGNE_BIP
                    WHERE typproj = 9
                    AND codsg IN ( SELECT codsg FROM STRUCT_INFO
                    			   WHERE coddir = TO_NUMBER ( p_coddir )
					           	 )
					)
	AND annee = p_annee
	;
    COMMIT;


	-- Boucle sur toutes les tables de répartition
	FOR curseur_tab IN cur_tab(p_coddir, p_mois_table) LOOP

 		-- Recherche le proposé à répartir pour une table de répartition
	    SELECT SUM(b.ANMONT) INTO l_anmont
        FROM LIGNE_BIP l,BUDGET b
        WHERE l.CODREP=curseur_tab.codrep
        AND b.pid=l.pid
        AND b.ANNEE=p_annee
        AND l.codcamo=66666
        ;

		-- Boucle sur les lignes BIP de la table de répartition
	    FOR curseur_prop IN cur_prop(curseur_tab.codrep, p_mois_table) LOOP
			BEGIN

			-- Calcule le montant réparti
          	v_anmont := l_anmont * curseur_prop.tauxrep ;

			-- Essaie d'insérer dans budget
			INSERT INTO BUDGET (
			 				  	 PID,
								 ANNEE,
								 ANMONT,
								 APDATE,
								 FLAGLOCK
								)
             VALUES(
					     		curseur_prop.pid,
								p_annee,
					 			v_anmont,
								l_date,
							    0
								);


			EXCEPTION

            WHEN VIOLATION_CONSTRAINT_UNIQUE THEN

			-- Fait la mise à jour dans budget en ajoutant les arbitrés
			-- aux arbitrés existants
                    UPDATE BUDGET
                    SET  anmont = anmont + v_anmont, apdate = l_date, flaglock = DECODE(flaglock, 1000000, 0, flaglock + 1)
                    WHERE  pid = curseur_prop.pid
					AND annee = p_annee ;

					END;


		END LOOP;

	END LOOP;

	Pack_Global.recuperer_message(21050,  NULL, NULL, NULL, p_message);
	COMMIT;


    EXCEPTION
    	WHEN OTHERS THEN
		    ROLLBACK;
        	RAISE_APPLICATION_ERROR( -20997, SQLERRM);



 END update_arbitre_rjh;

 FUNCTION en_anomalie(p_codrep IN RJH_TABREPART_DETAIL.CODREP%TYPE,
							   p_moisrep IN RJH_TABREPART_DETAIL.MOISREP%TYPE
							   ) RETURN VARCHAR IS
	p_test VARCHAR(4);
	p_somme_taux NUMBER(6,5);

  BEGIN
    -- on culcul la somme des taux par table de répartition
    SELECT sum(tauxrep) INTO p_somme_taux
	FROM RJH_TABREPART_DETAIL
	WHERE codrep=p_codrep
		  and moisrep=p_moisrep;

	return p_somme_taux;

 END en_anomalie;

END Pack_Rjh_Tablerepart;
/
