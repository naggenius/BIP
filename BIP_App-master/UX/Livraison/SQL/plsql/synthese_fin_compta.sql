-- Nom        :  Packbatch_Synth_Fin_Compta
-- Auteur     :  BAA fiche 392
-- Description : Procédure pour alimenter la table synthse_fin_compta
-- 23/08/2007 JAL : correction ordres updates et fonctionnel
-- 10/10/2007 JAL : dernière corrections des claculs de la synthèse
-- 11/10/2007 JAL : changement du calcul des flux du mois
-- 12/10/2007 JAL : changement du calcul des flux du mois et supression NULL VALUE
--13/11/2007   JAL : Correction des formules de calcul
--04/12/2007 JAL : remise des traces logs et supression des commentaire
---------------------------------------------------------------------------------------------------
 
 
 CREATE OR REPLACE PACKAGE Packbatch_Synth_Fin_Compta AS

--****************************************************
-- Procédure globale d'alimentation des tables
--****************************************************
PROCEDURE globale (P_LOGDIR          IN VARCHAR2)  ;

--****************************************************
-- Procédures d'alimentation de la table synthese_fin_compta
--****************************************************
PROCEDURE alim_synth_fin_compta_fi(P_HFILE           IN UTL_FILE.FILE_TYPE, L_ANNEE NUMBER, L_MOIS DATE) ;
PROCEDURE alim_synth_fin_compta_immo(P_HFILE           IN UTL_FILE.FILE_TYPE, L_ANNEE NUMBER, L_MOIS DATE) ;


-- curseur lignes STOCK_FI
CURSOR curseur_stock_fi  IS
 SELECT DISTINCT  pid,codcamo,cafi,rtype  FROM STOCK_FI;


-- curseur lignes STOCK_IMMO
CURSOR curseur_stock_immo  IS
 SELECT DISTINCT  pid,codcamo,cafi,rtype  FROM STOCK_IMMO;




TYPE SommeRecType IS RECORD  (
	 			  	 		  	somme1   NUMBER(12,2),
								somme2   NUMBER(12,2),
								somme3   NUMBER(12,2)
							 ) ;




END Packbatch_Synth_Fin_Compta;
/

CREATE OR REPLACE PACKAGE  BODY  Packbatch_Synth_Fin_Compta AS

-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
PRAGMA EXCEPTION_INIT( CALLEE_FAILED, -20000);
CALLEE_FAILED_ID     NUMBER := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     NUMBER := -20001;   -- problème : erreur dans la gestion d'erreur !
ERR_FONCTIONNELLE_ID NUMBER := -20002;   -- pour provoquer erreur alors que Oracle OK
CONSTRAINT_VIOLATION EXCEPTION;          -- pour clause when
PRAGMA EXCEPTION_INIT( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère

--****************************************************
-- Procédure d'alimentation des tables pour le batch IAS
--****************************************************
PROCEDURE globale (P_LOGDIR          IN VARCHAR2)  IS

L_HFILE     UTL_FILE.FILE_TYPE;
L_RETCOD    NUMBER;
L_PROCNAME  VARCHAR2(25) := 'SYNTH_FIN_COMPTA';
L_ANNEE NUMBER;
L_MOIS DATE;


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

		-----------------------------------------------------
		-- Lancement ...
		-----------------------------------------------------

		-- Année et mois d'exercice
      	SELECT TO_NUMBER(TO_CHAR(DATDEBEX, 'YYYY')), MOISMENS INTO L_ANNEE, L_MOIS
      	FROM DATDEBEX WHERE ROWNUM < 2;

		--Alimentation de la table SYNTHESE_FIN
	 	alim_synth_fin_compta_fi( L_HFILE, L_ANNEE, L_MOIS );
	 	alim_synth_fin_compta_immo( L_HFILE , L_ANNEE, L_MOIS);

		-----------------------------------------------------
		-- Trace Stop
		-----------------------------------------------------
		Trclog.Trclog( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
		Trclog.CLOSETRCLOG( L_HFILE );

	EXCEPTION
		WHEN OTHERS THEN
			IF SQLCODE <> CALLEE_FAILED_ID AND SQLCODE <> TRCLOG_FAILED_ID THEN
				 Trclog.Trclog( L_HFILE, L_PROCNAME || ' : ' || SQLERRM );
			END IF;
			IF SQLCODE <> TRCLOG_FAILED_ID THEN
				  Trclog.Trclog( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				  Trclog.CLOSETRCLOG( L_HFILE );
				RAISE_APPLICATION_ERROR( CALLEE_FAILED_ID,
				                        'Erreur : consulter le fichier LOG',
				                         FALSE );
			ELSE
				RAISE;
			END IF;


END globale;


--******************************************************************************
-- Procédure d'alimentation de la table SYNTHESE_FIN avec les donnees de stock_fi
--******************************************************************************
PROCEDURE alim_synth_fin_compta_fi(P_HFILE           IN UTL_FILE.FILE_TYPE, L_ANNEE NUMBER, L_MOIS DATE)   IS

L_RETCOD    NUMBER;
L_PROCNAME  VARCHAR2(25) := 'ALIM_SYNT_FIN_COMPTA_FI';
L_STATEMENT VARCHAR2(128);


L_SOMME1 NUMBER(12,2);
L_SOMME2 NUMBER(12,2);
L_SOMME3 NUMBER(12,2);



BEGIN
	  Trclog.Trclog( P_HFILE, 'Debut de ' || L_PROCNAME );

	     -- Vider les tables SYNTHESE_FIN_COMPTA
		L_STATEMENT := '* Suppression des lignes des tables SYNTHESE_FIN_COMPTA';
		Trclog.Trclog( P_HFILE, L_STATEMENT );
		Packbatch.DYNA_TRUNCATE('SYNTHESE_FIN_COMPTA');


		COMMIT;

	-- -------------------------------------------------------------
	-- Etape 1 : Insertion des lignes dans la table SYNTHESE_FIN_COMPTA si
	-- (PID, CODCAMO, CAFI, RTYPE) n existe pas
	-- --------------------------------------------------------------
	L_STATEMENT := '* Etape 1 : Insertion des lignes dans la table SYNTHESE_FIN_COMPTA';
	Trclog.Trclog( P_HFILE, L_STATEMENT );

	INSERT INTO SYNTHESE_FIN_COMPTA (
			PID,
			CODCAMO,
			CAFI,
			RTYPE,
			NCONSOJHFT_DEC,
            NCONSOFTENV_DEC,
            CONSOENV_DEC,
            NCONSOJHFT_N ,
            NCONSOFTENV_N,
            CONSOENV_N ,
            CONSOTOTAL,
            NCONSOJHFTENV_MOIS,
            NCONSOFTENV_MOIS,
            CONSOENV_MOIS,
            IMMOCONSOJH_MOIS,
            IMMOCONSO_MOIS,
            IMMOCONSOJH_N,
            IMMOCONSO_N
			)
	(SELECT DISTINCT
      		   	s.pid,
      			s.codcamo,
      			s.cafi,
				DECODE(s.rtype,'P',DECODE(s.soccode,'SG..','A','P'),s.rtype) rtype, 
				0,0,0,0,0,0,0,0,0,0,0,0,0,0
      	FROM		STOCK_FI s
	WHERE NOT EXISTS (SELECT 1 FROM SYNTHESE_FIN_COMPTA sf
			  WHERE sf.pid=s.pid
      				AND sf.codcamo=s.codcamo
      				AND sf.cafi=s.cafi
      				AND sf.rtype=DECODE(s.rtype,'P',DECODE(s.soccode,'SG..','A','P'),s.rtype) 
      				)
	);


	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table SYNTHESE_FIN_COMPTA';
	Trclog.Trclog( P_HFILE, L_STATEMENT );
	COMMIT;






	FOR curseur_STOCKFI IN curseur_stock_fi  LOOP
	   BEGIN






	   				-- -------------------------------------------------------------
					-- Etape 2 : alimentation des champs concernant les SG
					-- --------------------------------------------------------------
					L_STATEMENT := '* Etape 2 : alimentation des champs concernant les SG du mois dans SYNTHESE_FIN_COMPTA';
					Trclog.Trclog( P_HFILE, L_STATEMENT );
						 /*
						   Doit prendre en compte les RA sur année en cours de Janv à Nov
						   puis Décembre sur année précédente :

						   STOCK FI - nconsojhimmo (conso non immo en JH) -> NCONSOJHFTENV_MOIS
						   STOCK FI (conso env non immo + cout ft non immo) ->  NCONSOFTENV_MOIS
						   STOCK FI (consoenvimmo) -> CONSOENV_MOIS
						 */
						SELECT
								     NVL(SUM(a_nconsojhimmo),0), 
									 NVL(SUM(a_nconsoenvimmo),0)+NVL(SUM(NVL(a_consoft,0)),0),
								     NVL(SUM(a_consoenvimmo),0)
								    INTO  L_SOMME1,   L_SOMME2 , L_SOMME3
									FROM STOCK_FI fi
									WHERE
										fi.pid=curseur_STOCKFI.pid
										AND fi.codcamo=curseur_STOCKFI.codcamo
										AND fi.cafi=curseur_STOCKFI.cafi
										AND fi.rtype=curseur_STOCKFI.rtype
										AND fi.soccode = 'SG..'
										AND
										  (
--SEL PPM 58986 il faut prendre en compte tout l'exercice            
										       TO_NUMBER(TO_CHAR(fi.cdeb,'yyyy'))=(L_ANNEE)
										   )
										 ;

						 UPDATE SYNTHESE_FIN_COMPTA SET
							   					   	   NCONSOJHFTENV_MOIS = L_SOMME1 ,
													   NCONSOFTENV_MOIS   = L_SOMME2,
													   CONSOENV_MOIS      = L_SOMME3
										  WHERE
										              SYNTHESE_FIN_COMPTA.pid =curseur_STOCKFI.pid
											      	  AND SYNTHESE_FIN_COMPTA.codcamo = curseur_STOCKFI.codcamo
										      		  AND SYNTHESE_FIN_COMPTA.cafi = curseur_STOCKFI.cafi
										      		  AND SYNTHESE_FIN_COMPTA.rtype = DECODE(curseur_STOCKFI.rtype , 'P','A',curseur_STOCKFI.rtype);
					 L_STATEMENT := '-> '||SQL%ROWCOUNT ||' Maj des champs pour les SG dans la table SYNTHESE_FIN_COMPTA';
					 Trclog.Trclog( P_HFILE, L_STATEMENT );
					 COMMIT;

					-- -------------------------------------------------------------
					-- Etape 3 : alimentation des champs concernant les SSII
					-- --------------------------------------------------------------
					L_STATEMENT := '* Etape 3 : alimentation des champs concernant les SSII du mois dans SYNTHESE_FIN_COMPTA';
					Trclog.Trclog( P_HFILE, L_STATEMENT );
						/*
						  Doit prendre en compte les RA sur année en cours de Janv à Nov
						   puis Décembre sur année précédente  :

						   STOCK FI - nconsojhimmo (conso non immo en JH) -> NCONSOJHFTENV_MOIS
						   STOCK FI (conso env non immo + cout ft non immo) ->  NCONSOFTENV_MOIS
						   STOCK FI (consoenvimmo) -> CONSOENV_MOIS
						 */
						SELECT
								NVL(SUM(a_nconsojhimmo),0), 
								NVL(SUM(a_nconsoenvimmo),0)+NVL(SUM(NVL(a_consoft,0)),0),
								NVL(SUM(a_consoenvimmo),0)  INTO  L_SOMME1,   L_SOMME2 , L_SOMME3
								FROM STOCK_FI fi WHERE
										fi.pid=curseur_STOCKFI.pid
										AND fi.codcamo=curseur_STOCKFI.codcamo
										AND fi.cafi=curseur_STOCKFI.cafi
										AND fi.rtype=curseur_STOCKFI.rtype
										AND fi.soccode <>  'SG..'
										AND
										  (
--SEL PPM 58986 il faut prendre en compte tout l'exercice :  -x_synthFICompta.xml                    
										       TO_NUMBER(TO_CHAR(fi.cdeb,'yyyy'))=(L_ANNEE)
										   )
										 ;

						UPDATE SYNTHESE_FIN_COMPTA SET
										NCONSOJHFTENV_MOIS =  L_SOMME1,
										NCONSOFTENV_MOIS   =  L_SOMME2,
										CONSOENV_MOIS      =  L_SOMME3
										WHERE
										SYNTHESE_FIN_COMPTA.pid = curseur_STOCKFI.pid
										AND SYNTHESE_FIN_COMPTA.codcamo = curseur_STOCKFI.codcamo
										AND SYNTHESE_FIN_COMPTA.cafi =  curseur_STOCKFI.cafi
										AND SYNTHESE_FIN_COMPTA.rtype = curseur_STOCKFI.rtype ;

				L_STATEMENT := '-> '||SQL%ROWCOUNT ||' Maj des champs pour les SSII dans la table SYNTHESE_FIN_COMPTA';
				Trclog.Trclog( P_HFILE, L_STATEMENT );
				COMMIT;


/*
					-- ----------------------------------------------------------------------
					-- Etape 4 : alimentation des champs concernant decembre N-1 pour les SG
					-- ----------------------------------------------------------------------
					L_STATEMENT := '* Etape 4 : alimentation des champs concernant les SG pour dec n-1 dans SYNTHESE_FIN_COMPTA';
					Trclog.Trclog( P_HFILE, L_STATEMENT );

						Détail des calculs
						  1) nconsojhimmo : Consommé mois non immobilisable en JH -> NCONSOJHFT_DEC : Concommé Dec Année - 1 en JH non immo
						  2) FT non immo et Env Non Immos en Euros Déc année-1  -> NCONSOFTENV_DEC : Montant Euros Dec Année - 1 JH en FI non immo
						  3) Consommé Env immo Déc Année -1 -> CONSOENVDEC : Consommé Env immobilisé Déc an-1

						
					SELECT    NVL(SUM(nconsojhimmo),0),
							  NVL(SUM(NVL(nconsoenvimmo,0)),0)+ NVL(SUM(NVL(consoft,0)),0) ,
							  NVL(SUM(consoenvimmo),0) INTO  L_SOMME1,   L_SOMME2 , L_SOMME3
						 FROM STOCK_FI fi WHERE
												fi.pid= curseur_STOCKFI.pid
												AND fi.codcamo= curseur_STOCKFI.codcamo
												AND fi.cafi= curseur_STOCKFI.cafi
												AND fi.rtype= curseur_STOCKFI.rtype
												AND fi.soccode = 'SG..'
												AND TO_NUMBER(TO_CHAR(fi.cdeb,'yyyy'))=(L_ANNEE - 1)
												AND TO_NUMBER(TO_CHAR(fi.cdeb,'mm'))= 12	;
--SEL PPM 58986 les champs _DEC sont nuls vu que la table STOCK_FI ne contient pas les donnees DEC                         
				       UPDATE SYNTHESE_FIN_COMPTA SET
								NCONSOJHFT_DEC  = L_SOMME1,
								NCONSOFTENV_DEC = L_SOMME2,
								CONSOENV_DEC    = L_SOMME3
					   WHERE
								SYNTHESE_FIN_COMPTA.pid = curseur_STOCKFI.pid
								AND SYNTHESE_FIN_COMPTA.codcamo = curseur_STOCKFI.codcamo
								AND SYNTHESE_FIN_COMPTA.cafi = curseur_STOCKFI.cafi
								AND SYNTHESE_FIN_COMPTA.rtype = DECODE(curseur_STOCKFI.rtype , 'P','A',curseur_STOCKFI.rtype);

				L_STATEMENT := '-> '||SQL%ROWCOUNT ||' Maj des champs de dec n-1 pour les SG dans la table SYNTHESE_FIN_COMPTA';
				Trclog.Trclog( P_HFILE, L_STATEMENT );
				COMMIT;




				-- ----------------------------------------------------------------------
				-- Etape 5 : alimentation des champs concernant decembre N-1 pour les SSII
				-- ----------------------------------------------------------------------
				L_STATEMENT := '* Etape 5 : alimentation des champs concernant les SSII pour dec n-1 dans SYNTHESE_FIN_COMPTA';
				Trclog.Trclog( P_HFILE, L_STATEMENT );
						 Détail des calculs
						  1) nconsojhimmo : Consommé mois non immobilisable en JH -> NCONSOJHFT_DEC : Concommé Dec Année - 1 en JH non immo
						  2) FT non immo et Env Non Immos en Euros Déc année-1  -> NCONSOFTENV_DEC : Montant Euros Dec Année - 1 JH en FI non immo
						  3) Consommé Env immo Déc Année -1 -> CONSOENVDEC : Consommé Env immobilisé Déc an-1

						
							SELECT
								     NVL(SUM(nconsojhimmo),0),
									 NVL(SUM(NVL(nconsoenvimmo,0)),0)+ NVL(SUM(NVL(consoft,0)),0) ,
								     NVL(SUM(consoenvimmo),0)
									 INTO  L_SOMME1,   L_SOMME2 , L_SOMME3
								FROM STOCK_FI fi
								WHERE
									fi.pid=curseur_STOCKFI.pid
									AND fi.codcamo=curseur_STOCKFI.codcamo
									AND fi.cafi=curseur_STOCKFI.cafi
									AND fi.rtype=curseur_STOCKFI.rtype
									AND fi.soccode <> 'SG..'
									AND TO_NUMBER(TO_CHAR(fi.cdeb,'yyyy'))=(L_ANNEE - 1)
									AND TO_NUMBER(TO_CHAR(fi.cdeb,'mm'))= 12 ;
--SEL PPM 58986 les champs _DEC sont nuls vu que la table STOCK_FI ne contient pas les donnees DEC                   
							UPDATE SYNTHESE_FIN_COMPTA SET
									       NCONSOJHFT_DEC  =  L_SOMME1,
										   NCONSOFTENV_DEC =  L_SOMME2,
										   CONSOENV_DEC    =  L_SOMME3
									WHERE
									      	SYNTHESE_FIN_COMPTA.pid =         curseur_STOCKFI.pid
									      	AND SYNTHESE_FIN_COMPTA.codcamo = curseur_STOCKFI.codcamo
									      	AND SYNTHESE_FIN_COMPTA.cafi =    curseur_STOCKFI.cafi
									      	AND SYNTHESE_FIN_COMPTA.rtype =   curseur_STOCKFI.rtype ;
				L_STATEMENT := '-> '||SQL%ROWCOUNT ||' Maj des champs de dec n-1  pour les SII dans la table SYNTHESE_FIN_COMPTA';
				Trclog.Trclog( P_HFILE, L_STATEMENT );
				COMMIT;

*/
				-- -------------------------------------------------------------------------------------
				-- Etape 4 : alimentation des champs pour les SG pour l'année
				-- -------------------------------------------------------------------------------------
				L_STATEMENT := '* Etape 4 : alimentation des champs des les SG pour l''année dans SYNTHESE_FIN_COMPTA';
				Trclog.Trclog( P_HFILE, L_STATEMENT );

						 SELECT
								     NVL(SUM(nconsojhimmo),0),
									 NVL(SUM(nconsoenvimmo),0)+NVL(SUM(consoft),0),
								     NVL(SUM(consoenvimmo),0)
									 INTO  L_SOMME1,   L_SOMME2 , L_SOMME3
								FROM STOCK_FI fi
								WHERE
									fi.pid=curseur_STOCKFI.pid
									AND fi.codcamo=curseur_STOCKFI.codcamo
									AND fi.cafi=curseur_STOCKFI.cafi
									AND fi.rtype=curseur_STOCKFI.rtype
									AND fi.soccode = 'SG..'
									AND TO_NUMBER(TO_CHAR(fi.cdeb,'yyyy'))=L_ANNEE
--SEL PPM 58986 inclure le mois de decembre de l annee en cours dans le FI  
								    --AND TO_NUMBER(TO_CHAR(fi.cdeb,'mm')) <> 12		
                    ;
							UPDATE SYNTHESE_FIN_COMPTA SET
													    NCONSOJHFT_N  =  L_SOMME1,
													    NCONSOFTENV_N =  L_SOMME2,
													    CONSOENV_N    =  L_SOMME3
										WHERE
								     		SYNTHESE_FIN_COMPTA.pid         = curseur_STOCKFI.pid
									      	AND SYNTHESE_FIN_COMPTA.codcamo = curseur_STOCKFI.codcamo
									      	AND SYNTHESE_FIN_COMPTA.cafi    = curseur_STOCKFI.cafi
											AND SYNTHESE_FIN_COMPTA.rtype   = DECODE(curseur_STOCKFI.rtype , 'P','A',curseur_STOCKFI.rtype);

				L_STATEMENT := '-> '||SQL%ROWCOUNT ||' Maj des champs de l''année  pour les SG dans la table SYNTHESE_FIN_COMPTA';
				Trclog.Trclog( P_HFILE, L_STATEMENT );
				COMMIT ;




				-- -------------------------------------------------------------------------------------

				-- Etape 5 : alimentation des champs pour les SSII pour l'année
				-- -------------------------------------------------------------------------------------
				L_STATEMENT := '* Etape 5 : alimentation des champs des les SII pour l''année dans SYNTHESE_FIN_COMPTA';
				Trclog.Trclog( P_HFILE, L_STATEMENT );

								SELECT
								     NVL(SUM(nconsojhimmo),0),
								     NVL(SUM(nconsoenvimmo),0)+NVL(SUM(consoft),0),
								     NVL(SUM(consoenvimmo),0)
									 INTO  L_SOMME1,   L_SOMME2 , L_SOMME3
								  FROM STOCK_FI fi
								  WHERE
									fi.pid=curseur_STOCKFI.pid
									AND fi.codcamo=curseur_STOCKFI.codcamo
									AND fi.cafi=curseur_STOCKFI.cafi
									AND fi.rtype=curseur_STOCKFI.rtype
									AND fi.soccode <> 'SG..'
									AND TO_CHAR(fi.cdeb,'yyyy')=L_ANNEE
--SEL PPM 58986 inclure le mois de decembre de l anne en cours dans le FI                    
									--AND TO_NUMBER(TO_CHAR(fi.cdeb,'mm')) <> 12	
                  ;
								UPDATE SYNTHESE_FIN_COMPTA SET
													    NCONSOJHFT_N  =  L_SOMME1,
													    NCONSOFTENV_N =  L_SOMME2,
													    CONSOENV_N    =  L_SOMME3
									WHERE
											     		SYNTHESE_FIN_COMPTA.pid = curseur_STOCKFI.pid
											     		AND SYNTHESE_FIN_COMPTA.codcamo = curseur_STOCKFI.codcamo
											            AND SYNTHESE_FIN_COMPTA.cafi = curseur_STOCKFI.cafi
												      	AND SYNTHESE_FIN_COMPTA.rtype = curseur_STOCKFI.rtype;
					L_STATEMENT := '-> '||SQL%ROWCOUNT ||' Maj des champs de l''année  pour les SII dans la table SYNTHESE_FIN_COMPTA';
					Trclog.Trclog( P_HFILE, L_STATEMENT );
					COMMIT;




					-- -------------------------------------------------------------------------------------
					-- Etape 6 : alimentation du champ total pour les  SG pour l'année
					-- -------------------------------------------------------------------------------------
					L_STATEMENT := '* Etape 6 : alimentation du champ total pour les  SG pour l''année dans SYNTHESE_FIN_COMPTA';
					Trclog.Trclog( P_HFILE, L_STATEMENT );

								SELECT
									  NVL(SUM(nconsoenvimmo),0)+NVL(SUM(consoenvimmo),0) + NVL(SUM(consoft),0)
									  INTO L_SOMME1
									  FROM STOCK_FI fi
								  WHERE
									fi.pid=curseur_STOCKFI.pid
									AND fi.codcamo=curseur_STOCKFI.codcamo
									AND fi.cafi=curseur_STOCKFI.cafi
									AND fi.rtype=curseur_STOCKFI.rtype
									AND fi.soccode = 'SG..' ;
								UPDATE SYNTHESE_FIN_COMPTA
									   	SET  CONSOTOTAL =  L_SOMME1
											 WHERE
												SYNTHESE_FIN_COMPTA.pid = curseur_STOCKFI.pid
											    AND SYNTHESE_FIN_COMPTA.codcamo = curseur_STOCKFI.codcamo
											    AND SYNTHESE_FIN_COMPTA.cafi = curseur_STOCKFI.cafi
												AND SYNTHESE_FIN_COMPTA.rtype = DECODE(curseur_STOCKFI.rtype , 'P','A',curseur_STOCKFI.rtype);

					L_STATEMENT := '-> '||SQL%ROWCOUNT ||' Maj du champ total pour les  SG dans la table SYNTHESE_FIN_COMPTA';
					Trclog.Trclog( P_HFILE, L_STATEMENT );
					COMMIT;



	  -- -------------------------------------------------------------------------------------
	  -- Etape 7 : alimentation des champs pour  les SSII pour l'année
	  -- -------------------------------------------------------------------------------------
	  L_STATEMENT := '* Etape 7 : alimentation du champ total pour les SSII dans SYNTHESE_FIN_COMPTA';
	  Trclog.Trclog( P_HFILE, L_STATEMENT );

			

	   SELECT
				NVL(SUM(nconsoenvimmo),0)+NVL(SUM(consoenvimmo),0) + NVL(SUM(consoft),0)
									  INTO L_SOMME1
									  FROM STOCK_FI fi
				WHERE
						fi.pid=curseur_STOCKFI.pid
						AND fi.codcamo=curseur_STOCKFI.codcamo
						AND fi.cafi=curseur_STOCKFI.cafi
						AND fi.rtype=curseur_STOCKFI.rtype
						AND fi.soccode <> 'SG..' ;
		UPDATE SYNTHESE_FIN_COMPTA
						SET  CONSOTOTAL = L_SOMME1
						WHERE
							SYNTHESE_FIN_COMPTA.pid = curseur_STOCKFI.pid
							AND SYNTHESE_FIN_COMPTA.codcamo = curseur_STOCKFI.codcamo
							AND SYNTHESE_FIN_COMPTA.cafi = curseur_STOCKFI.cafi
							AND SYNTHESE_FIN_COMPTA.rtype =curseur_STOCKFI.rtype ;


	  L_STATEMENT := '-> '||SQL%ROWCOUNT ||' Maj du champ total pour les SG dans la table SYNTHESE_FIN_COMPTA';
	  Trclog.Trclog( P_HFILE, L_STATEMENT );
	  COMMIT;


	END ;
  END LOOP ;


EXCEPTION
	WHEN OTHERS THEN
		IF SQLCODE <> CALLEE_FAILED_ID THEN
				Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		END IF;
		Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		RAISE CALLEE_FAILED;

END alim_synth_fin_compta_fi ;

--******************************************************************************
-- Procédure d'alimentation de la table SYNTHESE_FIN_COMPTA avec les donnees de stock_immo
--******************************************************************************
PROCEDURE alim_synth_fin_compta_immo(P_HFILE IN UTL_FILE.FILE_TYPE, L_ANNEE NUMBER, L_MOIS DATE)  IS

L_RETCOD    NUMBER;
L_PROCNAME  VARCHAR2(25) := 'ALIM_SYNT_FIN_COMPTA_IMMO';
L_STATEMENT VARCHAR2(128);

L_SOMME1 NUMBER(12,2);
L_SOMME2 NUMBER(12,2);
L_SOMME3 NUMBER(12,2);

BEGIN
	Trclog.Trclog( P_HFILE, 'Debut de ' || L_PROCNAME );


	-- -------------------------------------------------------------
	-- Etape 1 : Insertion des lignes dans la table SYNTHESE_FIN_COMPTA si
	-- (pid,codcamo,cafi,rtype) n existe pas
	-- --------------------------------------------------------------
	L_STATEMENT := '* Etape 1 : Insertion des lignes dans la table SYNTHESE_FIN';
	Trclog.Trclog( P_HFILE, L_STATEMENT );
	INSERT INTO SYNTHESE_FIN_COMPTA (
			PID,
			CODCAMO,
			CAFI,
			RTYPE,
			NCONSOJHFT_DEC,
            NCONSOFTENV_DEC,
            CONSOENV_DEC,
            NCONSOJHFT_N ,
            NCONSOFTENV_N,
            CONSOENV_N ,
            CONSOTOTAL,
            NCONSOJHFTENV_MOIS,
            NCONSOFTENV_MOIS,
            CONSOENV_MOIS,
            IMMOCONSOJH_MOIS,
            IMMOCONSO_MOIS,
            IMMOCONSOJH_N,
            IMMOCONSO_N
			)
	(SELECT DISTINCT
      		   	s.pid,
      			s.codcamo,
      			s.cafi,
				DECODE(s.rtype,'P',DECODE(s.soccode,'SG..','A','P'),s.rtype) rtype, 
				0,0,0,0,0,0,0,0,0,0,0,0,0,0
      	FROM		STOCK_IMMO s
	WHERE NOT EXISTS (SELECT 1 FROM SYNTHESE_FIN_COMPTA sf
			  WHERE sf.pid=s.pid
      				AND sf.codcamo=s.codcamo
      				AND sf.cafi=s.cafi
      				AND sf.rtype=DECODE(s.rtype,'P',DECODE(s.soccode,'SG..','A','P'),s.rtype) 
      				)
	);


	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table SYNTHESE_FIN_COMPTA';
	  Trclog.Trclog( P_HFILE, L_STATEMENT );
	COMMIT;


	/*
	   Calcul des données suivantes :

	   - immobilisations flux du mois en JH   : somme CONSOJH
	   - immobilisations flux du mois en Euro : somme CONSOFT
	   - immobilisations stock du mois en JH   : somme A_CONSOJH
	   - immobilisations stock du mois en Euro : somme A_CONSOFT


	*/

	FOR curseur_STOCKIMMO IN curseur_stock_immo LOOP
			BEGIN
					-- -------------------------------------------------------------
					-- Etape 2 : alimentation des champs concernant les SG du mois
					-- --------------------------------------------------------------
					L_STATEMENT := '* Etape 2 : alimentation des champs du mois concernant les SG dans SYNTHESE_FIN_COMPTA';
					Trclog.Trclog( P_HFILE, L_STATEMENT);



					 

					    SELECT
						     SUM(NVL(a_consojh,0)) ,
							 SUM(NVL(a_consoft,0))
						INTO L_SOMME1,L_SOMME2 FROM STOCK_IMMO si
						WHERE si.soccode = 'SG..'
				      		AND si.pid=curseur_STOCKIMMO.pid
				      		AND si.codcamo=curseur_STOCKIMMO.codcamo
				      		AND si.cafi=curseur_STOCKIMMO.cafi
							AND si.rtype = curseur_STOCKIMMO.rtype
								AND TO_CHAR(si.cdeb,'yyyy')=L_ANNEE ;

				      	UPDATE SYNTHESE_FIN_COMPTA SET
								   IMMOCONSOJH_MOIS = L_SOMME1 ,
								   IMMOCONSO_MOIS   = L_SOMME2 WHERE
				      		SYNTHESE_FIN_COMPTA.pid = curseur_STOCKIMMO.pid
				      		AND SYNTHESE_FIN_COMPTA.codcamo = curseur_STOCKIMMO.codcamo
				      		AND SYNTHESE_FIN_COMPTA.cafi = curseur_STOCKIMMO.cafi
							AND SYNTHESE_FIN_COMPTA.rtype = DECODE(curseur_STOCKIMMO.rtype,'P','A',curseur_STOCKIMMO.rtype) ;

				      	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes SG maj dans la table SYNTHESE_FIN_COMPTA';
					  Trclog.Trclog( P_HFILE, L_STATEMENT );
					COMMIT;

					-- -------------------------------------------------------------
					-- Etape 3 : alimentation des champs concernant les SSII du mois
					-- --------------------------------------------------------------
					L_STATEMENT := '* Etape 3 : alimentation des champs du mois concernant les SSII dans SYNTHESE_FIN_COMPTA';
					Trclog.Trclog( P_HFILE, L_STATEMENT );

					 
						SELECT
						                  SUM(NVL(a_consojh,0)) ,
										  SUM(NVL(a_consoft,0))
										 INTO L_SOMME1,L_SOMME2
						FROM STOCK_IMMO si
						WHERE
				      	 si.pid=curseur_STOCKIMMO.pid
							AND si.codcamo=curseur_STOCKIMMO.codcamo
							AND si.cafi=curseur_STOCKIMMO.cafi
				      		AND si.rtype=curseur_STOCKIMMO.rtype
							AND si.soccode <> 'SG..'
								AND TO_CHAR(si.cdeb,'yyyy')=L_ANNEE ;

						UPDATE SYNTHESE_FIN_COMPTA SET
												   IMMOCONSOJH_MOIS = L_SOMME1 ,
												   IMMOCONSO_MOIS   = L_SOMME2 WHERE
								      		SYNTHESE_FIN_COMPTA.pid = curseur_STOCKIMMO.pid
								      		AND SYNTHESE_FIN_COMPTA.codcamo = curseur_STOCKIMMO.codcamo
								      		AND SYNTHESE_FIN_COMPTA.cafi = curseur_STOCKIMMO.cafi
											AND SYNTHESE_FIN_COMPTA.rtype = curseur_STOCKIMMO.rtype ;
				      	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes SSII maj dans la table SYNTHESE_FIN_COMPTA';
					    Trclog.Trclog( P_HFILE, L_STATEMENT );
					COMMIT;



					-- -------------------------------------------------------------
					-- Etape 4 : alimentation des champs concernant les SG de l'année
					-- --------------------------------------------------------------
					L_STATEMENT := '* Etape 4 : alimentation des champs de l''année concernant les SG dans SYNTHESE_FIN_COMPTA';
					Trclog.Trclog( P_HFILE, L_STATEMENT );
					 

						SELECT  SUM(NVL(consojh,0)) ,  SUM(NVL(consoft,0))
								INTO L_SOMME1,L_SOMME2
						FROM STOCK_IMMO si
						WHERE si.soccode = 'SG..'
				      		AND si.pid=curseur_STOCKIMMO.pid
							AND si.codcamo=curseur_STOCKIMMO.codcamo
							AND si.cafi=curseur_STOCKIMMO.cafi
				      		AND si.rtype=curseur_STOCKIMMO.rtype
							AND TO_CHAR(si.cdeb,'yyyy')=L_ANNEE ;

						UPDATE SYNTHESE_FIN_COMPTA SET
								IMMOCONSOJH_N = L_SOMME1 ,
								IMMOCONSO_N   = L_SOMME2 WHERE
									SYNTHESE_FIN_COMPTA.pid = curseur_STOCKIMMO.pid
								    AND SYNTHESE_FIN_COMPTA.codcamo = curseur_STOCKIMMO.codcamo
								    AND SYNTHESE_FIN_COMPTA.cafi = curseur_STOCKIMMO.cafi
									AND SYNTHESE_FIN_COMPTA.rtype = DECODE(curseur_STOCKIMMO.rtype,'P','A',curseur_STOCKIMMO.rtype) ;


				      	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes SG maj dans la table SYNTHESE_FIN_COMPTA_COMPTA';
					  Trclog.Trclog( P_HFILE, L_STATEMENT );
					COMMIT;


					-- -------------------------------------------------------------
					-- Etape 5 : alimentation des champs concernant les SSII de l'années
					-- --------------------------------------------------------------
					L_STATEMENT := '* Etape 5 : alimentation des champs de l''année concernant les SSII dans SYNTHESE_FIN';
					Trclog.Trclog( P_HFILE, L_STATEMENT );

			 

						SELECT   SUM(NVL(consojh,0)) ,  SUM(NVL(consoft,0))
								INTO L_SOMME1,L_SOMME2
						FROM STOCK_IMMO si
						WHERE
						        si.pid=curseur_STOCKIMMO.pid
							AND si.codcamo=curseur_STOCKIMMO.codcamo
							AND si.cafi=curseur_STOCKIMMO.cafi
				      		AND si.rtype=curseur_STOCKIMMO.rtype
							AND si.soccode <> 'SG..'
							AND TO_CHAR(si.cdeb,'yyyy')=L_ANNEE ;

						UPDATE SYNTHESE_FIN_COMPTA SET
								IMMOCONSOJH_N = L_SOMME1 ,
								IMMOCONSO_N   = L_SOMME2 WHERE
									SYNTHESE_FIN_COMPTA.pid = curseur_STOCKIMMO.pid
								    AND SYNTHESE_FIN_COMPTA.codcamo = curseur_STOCKIMMO.codcamo
								    AND SYNTHESE_FIN_COMPTA.cafi = curseur_STOCKIMMO.cafi
									AND SYNTHESE_FIN_COMPTA.rtype =curseur_STOCKIMMO.rtype ;
				      	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes SSII maj dans la table SYNTHESE_FIN_COMPTA';
					   Trclog.Trclog( P_HFILE, L_STATEMENT );
					COMMIT;




			END ;
	END LOOP ;




EXCEPTION
	WHEN OTHERS THEN
		 IF SQLCODE <> CALLEE_FAILED_ID THEN
			 	Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		 END IF;
		 Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		RAISE CALLEE_FAILED;

END alim_synth_fin_compta_immo ;



END Packbatch_Synth_Fin_Compta;
/
