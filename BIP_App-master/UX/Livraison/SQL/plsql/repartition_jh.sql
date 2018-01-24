-- APPLICATION 
-- -----------------------------------------------------------------------------------------------
-- pack_rtfe PL/SQL
-- 
-- Ce package contient les differents procedures qui permet le traitement de répartition
--
-- Crée        le 03/11/2005 par BAA
--
-- Modifié le 01/02/2006 par DDI : Prise en compte de la répartition des arbitrés 
-- Modifié le 04/10/2006 par PPR : Optimisation de CURSOR cur_cons*
-- Modifié le 06/03/2007 par EVI : Modification de INIT_RJH_CONSO pour complete les trous dans les tables de répartition
-- Modifié le 27/04/2007 par EVI : Modification regle de calcul
-- Modifié le 28/11/2012 par ABA : QC1399
--*************************************************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
CREATE OR REPLACE PACKAGE BIP."PACKBATCH_REPARTITION" AS


    -- Utilitaire : Traitement de répartition
	-- -----------------------------------------------------------------------------------------------------------------
   PROCEDURE ALIM_RJH( P_LOGDIR IN VARCHAR2 );


   -- Utilitaire : Initialisations pour le traitement de répartition
   -- -----------------------------------------------------------------------------------------------------------
   PROCEDURE INIT_RJH_CONSO( P_HFILE IN UTL_FILE.FILE_TYPE );


   -- Utilitaire : Alimentation de la table RJH_CONSOMME
   -- -------------------------------------------------------------------------------------------------------------
   PROCEDURE ALIM_RJH_CONSO( P_HFILE IN UTL_FILE.FILE_TYPE );


	-- Utilitaire : Alimentation de la table consomme à partir de RJH_CONSOMME
	-- -----------------------------------------------------------------------------------------------------------------
	   PROCEDURE ALIM_CONSO( P_HFILE IN UTL_FILE.FILE_TYPE );





END Packbatch_Repartition;
/
CREATE OR REPLACE PACKAGE BODY BIP."PACKBATCH_REPARTITION" AS


-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
PRAGMA EXCEPTION_INIT( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     NUMBER := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     NUMBER := -20001;   -- problème : erreur dans la gestion d'erreur !
ERR_FONCTIONNELLE_ID NUMBER := -20002;   -- pour provoquer erreur alors que Oracle OK
CONSTRAINT_VIOLATION EXCEPTION;          -- pour clause when
VIOLATION_CONSTRAINT_UNIQUE EXCEPTION;          -- pour clause when
PRAGMA EXCEPTION_INIT( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère
PRAGMA EXCEPTION_INIT( VIOLATION_CONSTRAINT_UNIQUE, -00001 );



-- Utilitaire : Traitement de répartition
-- -----------------------------------------------------------------------------------------------------------------

PROCEDURE ALIM_RJH( P_LOGDIR IN VARCHAR2 ) IS

   L_PROCNAME  VARCHAR2(16) := 'ALIM_RJH_CONSO';
   L_STATEMENT VARCHAR2(128);
   L_HFILE     UTL_FILE.FILE_TYPE;
   L_RETCOD    NUMBER;


BEGIN

    -----------------------------------------------------
	-- Init de la trace
	-----------------------------------------------------
		L_RETCOD := Trclog.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
		IF ( L_RETCOD <> 0 ) THEN
		RAISE_APPLICATION_ERROR( TRCLOG_FAILED_ID,
		                         'Erreur : Gestion du fichier LOG impossible',
		                         FALSE );
		END IF;

    -----------------------------------------------------
	-- Trace Start
	-----------------------------------------------------


    Trclog.Trclog( L_HFILE, 'Debut de ' || L_PROCNAME );


    -- ------------------------------------------------------------------------------------------------------
	-- Etape 1 : Initialisations
	-- ------------------------------------------------------------------------------------------------------

	  Packbatch_Repartition.INIT_RJH_CONSO( L_HFILE );

	-- ------------------------------------------------------------------------------------------------------
	-- Etape 2 : Alimentation de la table RJH_CONSOMME
	-- ------------------------------------------------------------------------------------------------------

      Packbatch_Repartition.ALIM_RJH_CONSO( L_HFILE);

   	-- ------------------------------------------------------------------------------------------------------
	-- Etape 3 : Alimentation de la table CONSOMME
	-- ------------------------------------------------------------------------------------------------------

     Packbatch_Repartition.ALIM_CONSO( L_HFILE);


    Trclog.Trclog( L_HFILE, 'Fin NORMALE de ' || L_PROCNAME);

EXCEPTION
	WHEN OTHERS THEN
	    ROLLBACK;
		IF SQLCODE <> CALLEE_FAILED_ID THEN
				Trclog.Trclog( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		END IF;
		Trclog.Trclog( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		RAISE CALLEE_FAILED;


  END ALIM_RJH;


-- Utilitaire : Alimentations de la table RJH_CONSOMME et complete les trous dans la table RJH_TABREPART_DETAIL
-- -------------------------------------------------------------------------------------------------------------

PROCEDURE INIT_RJH_CONSO( P_HFILE IN UTL_FILE.FILE_TYPE ) IS

 L_STATEMENT VARCHAR2(128);
 L_MOISMENS DATE;
 l_date		DATE;
 l_date2	DATE;
 l_annee	DATE;

 cpt1		INTEGER;

--  Ramène toutes les tables de repartition utilise
	CURSOR cur_table IS
		SELECT DISTINCT codrep
		FROM LIGNE_BIP
		WHERE 1 = 1
              --and (typproj='6' or typproj= '8')
			  and codcamo='66666'
			  and codrep IS NOT NULL
			  and codrep!='A_RENSEIGNER';

--  Ramène le detail d'une table de repartition
	CURSOR cur_ligne(c_codrep CHAR) IS
		SELECT codrep,moisrep
		FROM RJH_TABREPART_DETAIL
		WHERE CODREP=c_codrep
		GROUP BY codrep,moisrep;

-- Ramene la table de repartition a dupliquer
    CURSOR cur_ligne_duplique(c_codrep CHAR,
		   					  c_moisrep RJH_TABREPART_DETAIL.MOISREP%TYPE) IS
		SELECT codrep,moisrep,pid,tauxrep,liblignerep,typtab
		FROM RJH_TABREPART_DETAIL
		WHERE CODREP=c_codrep
			  and moisrep=c_moisrep
		GROUP BY codrep,moisrep,pid,tauxrep,liblignerep,typtab;


BEGIN
 -- Récupération de l'année courante.
    SELECT DATDEBEX,MOISMENS INTO l_annee,l_moismens FROM DATDEBEX;

L_STATEMENT := 'Complete les trous dans les tables de répartition';
Trclog.Trclog( P_HFILE, L_STATEMENT );

 -- Boucle sur toutes les lignes BIP
	FOR curseur_tab IN cur_table LOOP
 		cpt1 := 0 ;
		l_date:=l_annee;
		-- Boucle sur une table de répartition
	    	FOR curseur_ligne IN cur_ligne(curseur_tab.codrep) LOOP
		  BEGIN

		  IF cpt1=0 THEN l_date:=curseur_ligne.moisrep; cpt1:=1;END IF;

		  	 -- si il y a un trou dans une table de répartition
		  	  IF (curseur_ligne.moisrep>l_date)THEN

			  L_STATEMENT := 'Table de reparition dupliquer: ' || curseur_ligne.codrep;
			  Trclog.Trclog( P_HFILE, L_STATEMENT );

			   WHILE curseur_ligne.moisrep>l_date LOOP
			   		 -- on recupere la table de repartition a dupliquer
			   		 FOR curseur_ligne_duplique IN cur_ligne_duplique(curseur_ligne.codrep,l_date2) LOOP

			   		 INSERT INTO RJH_TABREPART_DETAIL (CODREP,MOISREP,PID,TAUXREP,LIBLIGNEREP,TYPTAB)
	  			  	 VALUES (curseur_ligne_duplique.CODREP,
					  l_date,
					  curseur_ligne_duplique.PID,
					  curseur_ligne_duplique.TAUXREP,
					  curseur_ligne_duplique.LIBLIGNEREP,
					  curseur_ligne_duplique.TYPTAB);

					 COMMIT;
					 END LOOP;

			   l_date:=ADD_MONTHS(l_date,+1);
			   END LOOP;
			   END IF;

		   l_date2:=curseur_ligne.moisrep;
		   l_date:=ADD_MONTHS(l_date,+1);
		  END;
		  END LOOP;

		  --L_STATEMENT := 'l_date= ' || l_date || ' l_moismens= '|| l_moismens;
		  --Trclog.Trclog( P_HFILE, L_STATEMENT );


		  l_date:=ADD_MONTHS(l_date,-1);
		  l_date2:=l_date;
		  -- si il manque des ligne a la fin de la table de repartition
		  	 WHILE l_date<l_moismens LOOP
 				l_date:=ADD_MONTHS(l_date,+1);
				     -- on recupere la table de repartition a dupliquer
					 FOR curseur_ligne_duplique IN cur_ligne_duplique(curseur_tab.codrep,l_date2) LOOP

			   		 INSERT INTO RJH_TABREPART_DETAIL (CODREP,MOISREP,PID,TAUXREP,LIBLIGNEREP,TYPTAB)
	  			  	 VALUES (curseur_ligne_duplique.CODREP,
					  l_date,
					  curseur_ligne_duplique.PID,
					  curseur_ligne_duplique.TAUXREP,
					  curseur_ligne_duplique.LIBLIGNEREP,
					  curseur_ligne_duplique.TYPTAB);



					 COMMIT;
					 END LOOP;
					 --L_STATEMENT := 'l_date= ' || l_date || ' l_date2= '|| l_date2;
		  			 --Trclog.Trclog( P_HFILE, L_STATEMENT );


			   END LOOP;

	END LOOP;
------------------------------------------------------------------------------
    L_STATEMENT := '* Troncature de la table RJH_CONSOMME';
	Trclog.Trclog( P_HFILE, L_STATEMENT );

	  -- Troncature RJH_CONSOMME
	  Packbatch.DYNA_TRUNCATE('RJH_CONSOMME');

	  L_STATEMENT:='* Inexistantes MOIMENS N-1';

	   INSERT INTO RJH_TABREPART_DETAIL (CODREP,MOISREP,PID,TAUXREP,LIBLIGNEREP,TYPTAB)
	  (SELECT
	  		   r1.CODREP,
	                   L_MOISMENS,
	                   r1.PID,
	                   r1.TAUXREP,
	                   r1.LIBLIGNEREP,
	                   r1.TYPTAB
	   FROM RJH_TABREPART_DETAIL r1, RJH_TABREPART rt
                     WHERE r1.MOISREP=ADD_MONTHS(L_MOISMENS,-1)
                     AND rt.CODREP=r1.CODREP
                     AND rt.FLAGACTIF='O'
                     AND NOT EXISTS(SELECT r2.CODREP, r2.MOISREP, r2.PID
				                                           FROM  RJH_TABREPART_DETAIL  r2
	  	  						   			               WHERE r2.CODREP=r1.CODREP
														  AND  r2.MOISREP=L_MOISMENS
														  AND r2.PID=r1.PID)
                     AND NOT EXISTS(SELECT *
				 FROM  RJH_TABREPART_DETAIL  r3
	  	  		 WHERE r3.CODREP=r1.CODREP
				 AND  r3.MOISREP=L_MOISMENS)

		);

		COMMIT;

	  	Trclog.Trclog( P_HFILE, L_STATEMENT ||':-'||SQL%rowcount);



 END INIT_RJH_CONSO;




   -- Utilitaire : Alimentation de la table RJH_CONSOMME
   -- -------------------------------------------------------------------------------------------------------------
PROCEDURE ALIM_RJH_CONSO( P_HFILE IN UTL_FILE.FILE_TYPE ) IS

 L_STATEMENT 			VARCHAR2(128);
 msg 					  				VARCHAR(1024);
 v_TAUXREP 					RJH_TABREPART_DETAIL.TAUXREP%TYPE;

 cons_repart       				 NUMBER(12,7);
 nbr 									  NUMBER;
 COMPTER									  NUMBER;


 CURSOR cur_cons IS
                      SELECT
				 	 		DISTINCT p.factpid,
			 				p.cdeb ,
			 				l.codrep,
							p.tires ident,
							NVL(p.cusag,0) cusag
					 FROM PROPLUS p,
					 	   DATDEBEX d ,
					 	   SITU_RESS_FULL sr ,
						   LIGNE_BIP l
					WHERE
	  					  l.codcamo=66666
						  -- jointure ligne_bip et tache
						  AND l.pid=p.factpid
						  -- données concernant les ressources
		   				  AND p.tires = sr.ident
						  AND (p.cdeb >=sr.datsitu OR sr.datsitu IS NULL)
						  AND (p.cdeb <=sr.datdep OR sr.datdep IS NULL )
						  AND NVL(p.cusag,0) <>0
						  -- ressource dont la prestation n est pas gratuite
						  AND sr.PRESTATION NOT IN ('IFO','MO ','GRA','INT','STA')
						  -- consommés sur l'année en cours
 						  AND TO_CHAR(d.moismens,'YYYY')=TO_CHAR(p.cdeb,'YYYY')
						  AND TO_CHAR(p.cdeb,'MM')<= TO_CHAR(d.moismens,'MM') ;


CURSOR cur_rep(c_codrep CHAR, c_cdeb DATE) IS
                     SELECT *
					 FROM  RJH_TABREPART_DETAIL
			         WHERE codrep=c_codrep
			         AND moisrep=c_cdeb
			         AND typtab='P';

BEGIN

    L_STATEMENT := '* Alimentations de la table RJH_CONSOMME';
	Trclog.Trclog( P_HFILE, L_STATEMENT );

	DELETE FROM RJH_ALIM_CONSO_LOG;

	 COMPTER := 0;
	    FOR curseur IN cur_cons LOOP

		 COMPTER := COMPTER  + 1;

		      SELECT COUNT(*) INTO nbr FROM  RJH_TABREPART_DETAIL
			  WHERE codrep=curseur.codrep
			  AND moisrep=curseur.cdeb;
			  --AND typtab='P';



			  IF(nbr = 0)THEN

			          Pack_Global.recuperer_message(21033, '%s1',curseur.codrep ,'%s2',TO_CHAR(curseur.cdeb,'dd/mm/yyyy'),NULL, msg);
					 Trclog.Trclog( P_HFILE, msg );

					 if (curseur.codrep!='A_RENSEIGNER') then
						 INSERT INTO RJH_ALIM_CONSO_LOG (CODREP, TEXTE)
						 VALUES (curseur.codrep, msg);
					 end if;

			 ELSE

			     FOR curseur_rep IN cur_rep(curseur.codrep,curseur.cdeb) LOOP
				     BEGIN

				          cons_repart := curseur_rep.TAUXREP * curseur.cusag;

						 INSERT INTO RJH_CONSOMME(
					   					 				 				  	 				CDEB,
																							PID,
																							IDENT,
																							PID_ORIGINE,
																							CONSOJH
																							)
				                                                          VALUES(
																 				     		curseur.cdeb,
																							curseur_rep.pid,
																 							curseur.ident,
																 							curseur.factpid,
																 							cons_repart
																							 );


				       EXCEPTION

             			    WHEN VIOLATION_CONSTRAINT_UNIQUE THEN

	                                    UPDATE RJH_CONSOMME
				                        SET  consojh = consojh + cons_repart
			  	   	                               WHERE      cdeb = curseur.cdeb
							                       AND ident = curseur.ident
			                                       AND pid= curseur_rep.pid
										           AND pid_origine= curseur.factpid;
					 END;

					COMMIT;
			 END LOOP;

			  END IF;

        END LOOP;



Trclog.Trclog( P_HFILE, COMPTER );

 END ALIM_RJH_CONSO;




-- Utilitaire : Alimentation de la table consomme à partir de RJH_CONSOMME
-- -----------------------------------------------------------------------------------------------------------------

PROCEDURE ALIM_CONSO( P_HFILE IN UTL_FILE.FILE_TYPE ) IS

 L_STATEMENT VARCHAR2(128);
l_annee INTEGER;

BEGIN

    SELECT TO_NUMBER(TO_CHAR(DATDEBEX,'YYYY')) INTO l_annee FROM DATDEBEX;


		L_STATEMENT:='Alimentation du consomme : cusag';

	-- alimentation de la table CONSOMME
			UPDATE CONSOMME
			SET cusag = (SELECT NVL(SUM(RJH_CONSOMME.consojh),0) FROM RJH_CONSOMME ,DATDEBEX
					  					WHERE RJH_CONSOMME.pid = CONSOMME.pid
					                     AND RJH_CONSOMME.cdeb >= DATDEBEX.DATDEBEX	)
			WHERE annee = l_annee
			AND CONSOMME.pid IN (SELECT DISTINCT pid FROM RJH_CONSOMME ,DATDEBEX
					  				                        	WHERE  RJH_CONSOMME.cdeb >= DATDEBEX.DATDEBEX )

			 ;


			COMMIT;


	 Trclog.Trclog( P_HFILE, L_STATEMENT ||':-'||SQL%rowcount);



	-- pour alimenter le cumul du consommé d'un pid toutes années confondues on doit faire l'update précédent avant
	-- celui-ci pour la prise en compte du nouveau cusag(cumul pour l'année courante) que l'on va ajouter à xcusag
	-- (cumul total)

	L_STATEMENT:='Alimentation du consomme total';

			UPDATE CONSOMME
			SET xcusag = NVL(xcusag,0) + NVL(cusag,0)
			WHERE annee = l_annee
			AND CONSOMME.pid IN (SELECT DISTINCT pid FROM RJH_CONSOMME ,DATDEBEX
					  				                        	WHERE  RJH_CONSOMME.cdeb >= DATDEBEX.DATDEBEX )

			;

	COMMIT;

	Trclog.Trclog( P_HFILE, L_STATEMENT ||':-'||SQL%rowcount);



 END ALIM_CONSO;






END Packbatch_Repartition;
/
