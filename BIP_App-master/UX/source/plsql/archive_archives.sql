-- -----------------------------------------------------------------------------------
-- Nom du fichier : archive_archives.sql
--
-- Objet : Procédure d'archivage lancée lors de la cloture par archive_cloture.sh
--				
--         Purge les données des tables d'archivage dont la date est antérieure à 
--          la date de début d'exercice - x années ( le x étant distinct par table )
--
--         Ce traitement permet de ne laisser indéfiniment les données archivées
--		   Elles sont juste gardées en ligne un certain nombre d'années
-- ----------------------------------------------------------------------------------
-- Creation : PPR le 15/11/2005
-- Modifications :
-- XXX		    /  /  	...
-- ----------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE pack_archive_archives IS
-- ##################################################################################
--	PROCEDURE de purge des tables d'archive
-- ##################################################################################
	PROCEDURE archive_archives(
		P_LOGDIR	IN VARCHAR2
	);

END pack_archive_archives;
/

CREATE OR REPLACE PACKAGE BODY pack_archive_archives IS
-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
pragma EXCEPTION_init( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !


-- ##################################################################################
--	PROCEDURE de purge des tables d'archive
-- ##################################################################################

	PROCEDURE archive_archives(
		P_LOGDIR	IN VARCHAR2
	) IS
	L_PROCNAME  varchar2(16) := 'ARCHIVE_ARCHIVES';
	L_HFILE     utl_file.file_type;
	L_RETCOD    number;
	L_STATEMENT varchar2(128);
	L_ANNEE5ANS NUMBER(4); 			-- Année moins 5 ans
	L_ANNEE10ANS NUMBER(4); 		-- Année moins 10 ans
	L_MOINS1AN  DATE; 				-- Date moins 1 an
	L_MOINS5ANS DATE; 				-- Date moins 5 ans
	L_MOINS10ANS DATE; 				-- Date moins 10 ans
	L_TOTAL    NUMBER :=0;          -- Compteur utilisé pour gérer le commit
	
	BEGIN
	
	-----------------------------------------------------
	--  Init de la trace
	-----------------------------------------------------
		L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
		if ( L_RETCOD <> 0 ) then
		raise_application_error( TRCLOG_FAILED_ID,
		                        'Erreur : Gestion du fichier LOG impossible',
		                         false );
		end if;
		
    	TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );
		
	-----------------------------------------------------
	--  Positionne les dates
	-----------------------------------------------------
		
		SELECT  TO_NUMBER( TO_CHAR(add_months(datdebex,-60),'YYYY')),
				TO_NUMBER( TO_CHAR(add_months(datdebex,-120),'YYYY')),
				add_months(datdebex,-12), add_months(datdebex,-60), add_months(datdebex,-120)
		INTO L_ANNEE5ANS, L_ANNEE10ANS, L_MOINS1AN, L_MOINS5ANS, L_MOINS10ANS 
		FROM datdebex;
		
	-----------------------------------------------------
	--  table ARCHIVE_CONS_SSTACHE_RES_MOIS
	--
	--  Purger si DATE_DEMANDE < DATDEBEX - 10 ans
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table archive_cons_sstache_res_mois';
    	TRCLOG.TRCLOG( L_HFILE, 'ARCHIVE_CONS_SSTACHE_RES_MOIS : Laisse 10 ans en archive ');

		LOOP
			--
			-- On supprime les données dans la table archive_cons_sstache_res_mois
			-- fait un commit tous les 10000 enregistrements
			--
			DELETE FROM BIPA.ARCHIVE_CONS_SSTACHE_RES_MOIS
			WHERE cdeb < L_MOINS10ANS
			AND   ROWNUM <= 10000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 10000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 10000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table archive_cons_sstache_res_mois';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
	
	-----------------------------------------------------
	--  table ARCHIVE_CUMUL_CONSO
	--
	--	Purger  si ANNEE < Annee(DATDEBEX - 10 ans) 
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'ARCHIVE_CUMUL_CONSO : Laisse 10 ans en archive ');
	
		DELETE FROM BIPA.ARCHIVE_CUMUL_CONSO WHERE annee < L_ANNEE10ANS   ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table archive_cumul_conso';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table ARCHIVE_HISTO_STOCK_FI
	--
	--  Purger si CDEB < DATDEBEX - 10 ans
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table archive_histo_stock_fi';

   		TRCLOG.TRCLOG( L_HFILE, 'ARCHIVE_HISTO_STOCK_FI : Laisse 10 ans en archive ');

		LOOP
			--
			-- On supprime les données dans la table archive_histo_stock_fi
			-- fait un commit tous les 5000 enregistrements
			--
			DELETE FROM BIPA.ARCHIVE_HISTO_STOCK_FI
			WHERE cdeb < L_MOINS10ANS
			AND   ROWNUM <= 5000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 5000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table archive_histo_stock_fi';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table ARCHIVE_HISTO_STOCK_IMMO
	--
	--  Purger si CDEB < DATDEBEX - 10 ans
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table archive_histo_stock_immo';
   		TRCLOG.TRCLOG( L_HFILE, 'ARCHIVE_HISTO_STOCK_IMMO : Laisse 10 ans en archive ');

		LOOP
			--
			-- On supprime les données dans la table archive_histo_stock_immo
			-- fait un commit tous les 5000 enregistrements
			--
			DELETE FROM BIPA.ARCHIVE_HISTO_STOCK_IMMO
			WHERE cdeb < L_MOINS10ANS
			AND   ROWNUM <= 5000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 5000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table archive_histo_stock_immo';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table ARCHIVE_ISAC_CONSOMME
	--
	--  Purger si CDEB < DATDEBEX - 1 an
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table archive_isac_consomme';
   		TRCLOG.TRCLOG( L_HFILE, 'ARCHIVE_ISAC_CONSOMME : Laisse 1 an en archive ');

		LOOP
			--
			-- On supprime les données dans la table archive_isac_consomme
			-- fait un commit tous les 10000 enregistrements
			--
			DELETE FROM BIPA.ARCHIVE_ISAC_CONSOMME
			WHERE cdeb < L_MOINS1AN
			AND   ROWNUM <= 10000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 10000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 10000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table archive_isac_consomme';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table ARCHIVE_PROPLUS
	--
	--  Purger si CDEB < DATDEBEX - 10 ans
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table archive_proplus';
   		TRCLOG.TRCLOG( L_HFILE, 'ARCHIVE_PROPLUS : Laisse 10 ans en archive ');

		LOOP
			--
			-- On supprime les données dans la table archive_proplus
			-- fait un commit tous les 5000 enregistrements
			--
			DELETE FROM BIPA.ARCHIVE_PROPLUS
			WHERE cdeb < L_MOINS10ANS
			AND   ROWNUM <= 5000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 5000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table archive_proplus';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table ARCHIVE_REE_REESTIME
	--
	--  Purger si CDEB < DATDEBEX - 1 an
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table archive_ree_reestime';
   		TRCLOG.TRCLOG( L_HFILE, 'ARCHIVE_REE_REESTIME : Laisse 1 an en archive ');

		LOOP
			--
			-- On supprime les données dans la table archive_ree_reestime
			-- fait un commit tous les 10000 enregistrements
			--
			DELETE FROM BIPA.ARCHIVE_REE_REESTIME
			WHERE cdeb < L_MOINS1AN
			AND   ROWNUM <= 10000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 10000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 10000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table archive_ree_reestime';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table ARCHIVE_STOCK_RA
	--
	--  Purger si CDEB < DATDEBEX - 1 an
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table archive_stock_ra';
   		TRCLOG.TRCLOG( L_HFILE, 'ARCHIVE_STOCK_RA : Laisse 1 an en archive ');

		LOOP
			--
			-- On supprime les données dans la table archive_stock_ra
			-- fait un commit tous les 5000 enregistrements
			--
			DELETE FROM BIPA.ARCHIVE_STOCK_RA
			WHERE cdeb < L_MOINS1AN
			AND   ROWNUM <= 5000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 5000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table archive_stock_ra';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table ARCHIVE_SYNTHESE_ACTIVITE
	--
	--  Purger si ANNEE < Annee(DATDEBEX - 10 ans)
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table archive_synthese_activite';
   		TRCLOG.TRCLOG( L_HFILE, 'ARCHIVE_SYNTHESE_ACTIVITE : Laisse 10 ans en archive ');

		LOOP
			--
			-- On supprime les données dans la table archive_synthese_activite
			-- fait un commit tous les 5000 enregistrements
			--
			DELETE FROM BIPA.ARCHIVE_SYNTHESE_ACTIVITE
			WHERE annee < L_ANNEE10ANS
			AND   ROWNUM <= 5000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 5000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table archive_synthese_activite';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table ARCHIVE_SYNTHESE_ACTIVITE_MOIS
	--
	--  Purger si CDEB < DATDEBEX - 1 an
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table archive_synthese_activite_mois';
   		TRCLOG.TRCLOG( L_HFILE, 'ARCHIVE_SYNTHESE_ACTIVITE_MOIS : Laisse 5 ans en archive ');

		LOOP
			--
			-- On supprime les données dans la table archive_synthese_activite_mois
			-- fait un commit tous les 5000 enregistrements
			--
			DELETE FROM BIPA.ARCHIVE_SYNTHESE_ACTIVITE_MOIS
			WHERE cdeb < L_MOINS5ANS
			AND   ROWNUM <= 5000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 5000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table archive_synthese_activite_mois';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table ARCHIVE_SYNTHESE_FIN
	--
	--  Purger si ANNEE < Annee(DATDEBEX - 5 ans)
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table archive_synthese_fin';
   		TRCLOG.TRCLOG( L_HFILE, 'ARCHIVE_SYNTHESE_FIN : Laisse 5 ans en archive ');

		LOOP
			--
			-- On supprime les données dans la table archive_synthese_fin
			-- fait un commit tous les 5000 enregistrements
			--
			DELETE FROM BIPA.ARCHIVE_SYNTHESE_FIN
			WHERE annee < L_ANNEE5ANS
			AND   ROWNUM <= 5000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 5000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table archive_synthese_fin';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		

	-----------------------------------------------------
	--  table ARCHIVE_SYNTHESE_FIN_BIP
	--
	--  Purger si ANNEE < Annee(DATDEBEX - 10 ans)
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table archive_synthese_fin_bip';
   		TRCLOG.TRCLOG( L_HFILE, 'ARCHIVE_SYNTHESE_FIN_BIP : Laisse 10 ans en archive ');

		LOOP
			--
			-- On supprime les données dans la table archive_synthese_fin_bip
			-- fait un commit tous les 5000 enregistrements
			--
			DELETE FROM BIPA.ARCHIVE_SYNTHESE_FIN_BIP
			WHERE annee < L_ANNEE10ANS
			AND   ROWNUM <= 5000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 5000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table archive_synthese_fin_bip';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		
	-----------------------------------------------------
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME );

	EXCEPTION
	when others then
	    rollback;
		if sqlcode <> CALLEE_FAILED_ID then
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		end if;
		TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		raise CALLEE_FAILED; 
	
	END archive_archives;

END pack_archive_archives;
/
