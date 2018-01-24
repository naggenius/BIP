-- -----------------------------------------------------------------------------------
-- Nom du fichier : archive_purge.sql
--
-- Objet : Procédure d'archivage lancée lors de la cloture par archive_cloture.sh
--				
--         Purge les données des tables dont la date est antérieure à 
--          la date de début d'exercice - x années ( le x étant distinct par table )
--
--         Ce traitement permet de ne laisser dans les tables de l'application que
--			les données nécessaires. Les tables concernées par ce traitement sont
--          généralement des tables de log , car les données qu'elles contiennent
--          n'ont pas à être archivées. Elles sont juste gardées en ligne un certain
--          nombre d'années
-- ----------------------------------------------------------------------------------
-- Creation : PPR le 15/11/2005
-- Modifications :
-- PPR		 le    12/04/2006  Ménage dans les tables temporaires
-- ----------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE pack_archive_purge IS
-- ##################################################################################
--	PROCEDURE de purge des tables lancée lors de l'archivage
-- ##################################################################################
	PROCEDURE archive_purge(
		P_LOGDIR	IN VARCHAR2
	);

END pack_archive_purge;
/

CREATE OR REPLACE PACKAGE BODY pack_archive_purge IS
-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
pragma EXCEPTION_init( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !


-- ##################################################################################
--	PROCEDURE de purge des tables lancée lors de l'archivage
-- ##################################################################################

	PROCEDURE archive_purge(
		P_LOGDIR	IN VARCHAR2
	) IS
	L_PROCNAME  varchar2(16) := 'ARCHIVE_PURGE';
	L_HFILE     utl_file.file_type;
	L_RETCOD    number;
	L_STATEMENT varchar2(128);
	L_MOINS1AN  DATE; 				-- Date moins 1 an
	L_MOINS3ANS DATE; 				-- Date moins 3 ans
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
		
		SELECT  add_months(datdebex,-12),add_months(datdebex,-36) 
		INTO L_MOINS1AN,L_MOINS3ANS 
		FROM datdebex;
		
	-----------------------------------------------------
	--  table AUDIT_STATUT
	--
	--  Purger si DATE_DEMANDE < DATDEBEX - 3ans
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'AUDIT_STATUT : Laisse 3 ans en ligne ');

		DELETE FROM AUDIT_STATUT WHERE DATE_DEMANDE < L_MOINS3ANS ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table audit_statut';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );


	-----------------------------------------------------
	--  table BJH_ANOMALIES
	--
	--  Purger si DATEANO < DATDEBEX - 1 an
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'BJH_ANOMALIES : Laisse 1 an en ligne ');

		DELETE FROM BJH_ANOMALIES WHERE DATEANO < L_MOINS1AN ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table bjh_anomalies';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		
	-----------------------------------------------------
	--  table ISAC_AFFECTATION
	--
	--	Vider les lignes sur des ressources qui ne sont plus la
	--	Purger s'il n'existe pas de ligne dans SITU_RESS avec IDENT et DATDEP null ou DATDEP>= DATDEBEX - 1 an
	--	Vider les lignes sur les lignes BIP fermées
	--	Purger si PID tel que ADATESTATUT de la ligne BIP < DATDEBEX - 1 an
	-----------------------------------------------------

   		TRCLOG.TRCLOG( L_HFILE, 'ISAC_AFFECTATION : Vider les lignes sur des ressources qui ne sont plus la depuis 1 an ');
 
		DELETE FROM ISAC_AFFECTATION WHERE 
				NOT EXISTS ( SELECT IDENT FROM SITU_RESS
				             WHERE SITU_RESS.IDENT=ISAC_AFFECTATION.IDENT
				             AND ( SITU_RESS.DATDEP IS NULL OR SITU_RESS.DATDEP >= L_MOINS1AN )
				            ) ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table isac_affectation';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

   		TRCLOG.TRCLOG( L_HFILE, 'ISAC_AFFECTATION : Vider les lignes sur les lignes BIP fermées depuis 1 an ');

		DELETE FROM ISAC_AFFECTATION WHERE 
				NOT EXISTS ( SELECT PID FROM LIGNE_BIP
				             WHERE LIGNE_BIP.PID=ISAC_AFFECTATION.PID
				             AND ( LIGNE_BIP.ADATESTATUT IS NULL OR LIGNE_BIP.ADATESTATUT >= L_MOINS1AN )
				            ) ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table isac_affectation';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		
	-----------------------------------------------------
	--  table ISAC_SOUS_TACHE
	--
	--	Vider les lignes sur les lignes BIP fermées
	--	Purger si PID tel que ADATESTATUT de la ligne BIP < DATDEBEX - 1 an
	-----------------------------------------------------

   		TRCLOG.TRCLOG( L_HFILE, 'ISAC_SOUS_TACHE : Vider les lignes sur les lignes BIP fermées depuis 1 an ');

		DELETE FROM ISAC_SOUS_TACHE WHERE 
				NOT EXISTS ( SELECT PID FROM LIGNE_BIP
				             WHERE LIGNE_BIP.PID=ISAC_SOUS_TACHE.PID
				             AND ( LIGNE_BIP.ADATESTATUT IS NULL OR LIGNE_BIP.ADATESTATUT >= L_MOINS1AN )
				            ) ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table isac_sous_tache';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		
	-----------------------------------------------------
	--  table ISAC_TACHE
	--
	--	Vider les lignes sur les lignes BIP fermées
	--	Purger si PID tel que ADATESTATUT de la ligne BIP < DATDEBEX - 1 an
	-----------------------------------------------------

   		TRCLOG.TRCLOG( L_HFILE, 'ISAC_TACHE : Vider les lignes sur les lignes BIP fermées depuis 1 an ');

		DELETE FROM ISAC_TACHE WHERE 
				NOT EXISTS ( SELECT PID FROM LIGNE_BIP
				             WHERE LIGNE_BIP.PID=ISAC_TACHE.PID
				             AND ( LIGNE_BIP.ADATESTATUT IS NULL OR LIGNE_BIP.ADATESTATUT >= L_MOINS1AN )
				            ) ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table isac_tache';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table ISAC_ETAPE
	--
	--	Vider les lignes sur les lignes BIP fermées
	--	Purger si PID tel que ADATESTATUT de la ligne BIP < DATDEBEX - 1 an
	-----------------------------------------------------

   		TRCLOG.TRCLOG( L_HFILE, 'ISAC_ETAPE : Vider les lignes sur les lignes BIP fermées depuis 1 an ');

		DELETE FROM ISAC_ETAPE WHERE 
				NOT EXISTS ( SELECT PID FROM LIGNE_BIP
				             WHERE LIGNE_BIP.PID=ISAC_ETAPE.PID
				             AND ( LIGNE_BIP.ADATESTATUT IS NULL OR LIGNE_BIP.ADATESTATUT >= L_MOINS1AN )
				            ) ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table isac_etape';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table LIGNE_BIP_LOGS
	--
	--  Purger si DATE_LOG < DATDEBEX - 3 ans
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table ligne_bip_logs';
   		TRCLOG.TRCLOG( L_HFILE, 'LIGNE_BIP_LOGS : Laisse 3 ans en ligne ');

		LOOP
			--
			-- On supprime les données dans la table ligne_bip_logs
			-- fait un commit tous les 5000 enregistrements
			--
			DELETE FROM LIGNE_BIP_LOGS
			WHERE date_log < L_MOINS3ANS
			AND   ROWNUM <= 5000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 5000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table ligne_bip_logs';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		
	-----------------------------------------------------
	--  table NOTIFICATION_LOGS
	--
	--  Purger si DATE_LOG < DATDEBEX - 3 ans
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table notification_logs';
   		TRCLOG.TRCLOG( L_HFILE, 'NOTIFICATION_LOGS : Laisse 3 ans en ligne ');

		LOOP
			--
			-- On supprime les données dans la table notification_logs
			-- fait un commit tous les 5000 enregistrements
			--
			DELETE FROM NOTIFICATION_LOGS
			WHERE date_log < L_MOINS3ANS
			AND   ROWNUM <= 5000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 5000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table notification_logs';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );	
			
	-----------------------------------------------------
	--  table REPORT_LOG
	--
	--  Purger si DATE_LOG < DATDEBEX - 3 ans
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table report_log';
   		TRCLOG.TRCLOG( L_HFILE, 'REPORT_LOG : Laisse 3 ans en ligne ');

		LOOP
			--
			-- On supprime les données dans la table report_log
			-- fait un commit tous les 5000 enregistrements
			--
			DELETE FROM REPORT_LOG
			WHERE date_log < L_MOINS3ANS
			AND   ROWNUM <= 5000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 5000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table report_log';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table RTFE_LOG
	--
	--  Purger si DATE_LOG < DATDEBEX - 3 ans
	-----------------------------------------------------

		L_TOTAL := 0;
		L_STATEMENT := 'Suppression dans la table rtfe_log';
   		TRCLOG.TRCLOG( L_HFILE, 'RTFE_LOG : Laisse 3 ans en ligne ');

		LOOP
			--
			-- On supprime les données dans la table rtfe_log
			-- fait un commit tous les 5000 enregistrements
			--
			DELETE FROM RTFE_LOG
			WHERE mois < L_MOINS3ANS
			AND   ROWNUM <= 5000;
			
			L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;
			
			-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
			EXIT WHEN SQL%ROWCOUNT < 5000;
			COMMIT;

		END LOOP;
		COMMIT;

		L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table rtfe_log';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table TMP_FACTAE
	--
	--  Purger si DATE_ENVOI < DATDEBEX - 1 an
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'TMP_FACTAE : Laisse 1 an en ligne ');

		DELETE FROM TMP_FACTAE WHERE DATE_ENVOI < L_MOINS1AN ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table tmp_factae';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  Vide les tables temporaires
	-----------------------------------------------------
	PACKBATCH.DYNA_TRUNCATE('TMPEDSSTR');
	PACKBATCH.DYNA_TRUNCATE('TMPFE60');
	PACKBATCH.DYNA_TRUNCATE('TMPRAPSYNT');
	PACKBATCH.DYNA_TRUNCATE('TMPREFTRANS');
	PACKBATCH.DYNA_TRUNCATE('TMP_BUDGET_SSTACHE');
	PACKBATCH.DYNA_TRUNCATE('TMP_CONSO_SSTACHE');
	PACKBATCH.DYNA_TRUNCATE('TMP_FAIR');	
	PACKBATCH.DYNA_TRUNCATE('TMP_ORGANISATION');
	PACKBATCH.DYNA_TRUNCATE('TMP_REE_DETAIL');	
	PACKBATCH.DYNA_TRUNCATE('TMP_REJETMENS');
	PACKBATCH.DYNA_TRUNCATE('TMP_SAISIE_REALISEE');	
	PACKBATCH.DYNA_TRUNCATE('TMP_SYNTHCOUTPROJ');
	PACKBATCH.DYNA_TRUNCATE('TMP_VISUPROJPRIN');
	PACKBATCH.DYNA_TRUNCATE('BJH_ANOMALIES_TEMP');	
	PACKBATCH.DYNA_TRUNCATE('BJH_EXTBIP');
	PACKBATCH.DYNA_TRUNCATE('BJH_RESSOURCE');
	PACKBATCH.DYNA_TRUNCATE('BATCH_REJET_DATESTATUT');
	PACKBATCH.DYNA_TRUNCATE('ETAPE_REJET_DATESTATUT');
	PACKBATCH.DYNA_TRUNCATE('TACHE_REJET_DATESTATUT');
	PACKBATCH.DYNA_TRUNCATE('CONS_SSTRES_REJET_DATESTATUT');
	PACKBATCH.DYNA_TRUNCATE('CONS_SSTRES_M_REJET_DATESTATUT');
	PACKBATCH.DYNA_TRUNCATE('ETAPE_BACK');	
	PACKBATCH.DYNA_TRUNCATE('TACHE_BACK');
	PACKBATCH.DYNA_TRUNCATE('CONS_SSTACHE_RES_BACK');
	PACKBATCH.DYNA_TRUNCATE('CONS_SSTACHE_RES_MOIS_BACK');	
	PACKBATCH.DYNA_TRUNCATE('REMONTEE');

					
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
	
	END archive_purge;

END pack_archive_purge;
/
