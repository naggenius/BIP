-- -----------------------------------------------------------------------------------
-- Nom du fichier : archive_tables.sql
--
-- Objet : Procédure d'archivage lancée lors de la cloture par archive_cloture.sh
--			
--	       Copie les données des tables dans la base d'archivage et purge
--          les données des tables dont la date est antérieure à 
--          la date de début d'exercice - x années ( le x étant distinct par table )
--
--         Ce traitement permet de ne laisser dans les tables de l'application que
--			les données nécessaires. Les données sont copiées dans les tables 
--          d'archivage, ces tables portent le même nom que la table source mais
--          commencent par ARCHIVE_
--          
-- ----------------------------------------------------------------------------------
-- Creation : PPR le 15/11/2005
-- Modifications :
-- ABA 27/02/09 TD 718		    /  /  	...
-- 13/07/2011  ABA   QC 1229
-- 18/04/2012  BSA   QC 1415
-- ----------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE     pack_archive_tables IS
-- ##################################################################################
--	PROCEDURE d'archivage des tables
-- ##################################################################################
	PROCEDURE archive_tables(
		P_LOGDIR	IN VARCHAR2
	);

END pack_archive_tables;
/


CREATE OR REPLACE PACKAGE BODY     pack_archive_tables IS
-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
pragma EXCEPTION_init( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !


-- ##################################################################################
--	PROCEDURE d'archivage des tables
-- ##################################################################################

	PROCEDURE archive_tables(
		P_LOGDIR	IN VARCHAR2
	) IS
	L_PROCNAME  varchar2(16) := 'ARCHIVE_TABLES';
	L_HFILE     utl_file.file_type;
	L_RETCOD    number;
	L_STATEMENT varchar2(128);
	L_ANNEE1AN  NUMBER(4); 				-- Année moins 1 an
	L_ANNEE3ANS NUMBER(4); 				-- Année moins 3 ans
	L_ANNEE5ANS NUMBER(4); 				-- Année moins 5 ans
	L_MOINS0ANS DATE; 					-- Date moins 0 ans (donc datdebex)
	L_MOINS1AN  DATE; 					-- Date moins 1 an
	L_MOINS3ANS DATE; 					-- Date moins 3 ans
	L_MOINS5ANS DATE; 					-- Date moins 5 ans
	L_COMPTEUR NUMBER :=0;              -- Compteur utilisé pour gérer le commit
	L_TOTAL    NUMBER :=0;              -- Compteur utilisé pour gérer le commit

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

		SELECT  TO_NUMBER( TO_CHAR(add_months(datdebex,-12),'YYYY')),
				TO_NUMBER( TO_CHAR(add_months(datdebex,-36),'YYYY')),
				TO_NUMBER( TO_CHAR(add_months(datdebex,-60),'YYYY')),
				datdebex,
				add_months(datdebex,-12),
				add_months(datdebex,-36),
		        add_months(datdebex,-60)
		INTO L_ANNEE1AN ,L_ANNEE3ANS ,L_ANNEE5ANS ,L_MOINS0ANS ,L_MOINS1AN ,L_MOINS3ANS , L_MOINS5ANS
		FROM datdebex;

	-----------------------------------------------------
	--  table BUDGET
	--
	--  On garde 5 ans en ligne dans Budget, le reste va dans Archive_Budget qui ne sera pas purgé
	--  Déplacer dans ARCHIVE_BUDGET si ANNEE < Année(DATDEBEX - 5 ans )
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'BUDGET : Laisse 5 ans en ligne ');

		INSERT INTO BIPA.ARCHIVE_BUDGET
		(annee, pid, bnmont, bpmontme,
		bpmontme2, anmont, bpdate, reserve,
		apdate, apmont, bpmontmo, reestime,
		flaglock, bpmedate, bndate, redate, 
		ubpmontme, ubpmontmo, ubnmont, uanmont, ureestime)
		SELECT
		annee, pid, bnmont, bpmontme,
		bpmontme2, anmont, bpdate, reserve,
		apdate, apmont, bpmontmo, reestime,
		flaglock, bpmedate, bndate, redate, 
		ubpmontme, ubpmontmo, ubnmont, uanmont, ureestime
		FROM BUDGET
		WHERE annee < L_ANNEE5ANS ;
		COMMIT;
		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes copiées dans la table archive_budget';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

		DELETE FROM BUDGET WHERE annee < L_ANNEE5ANS  ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table budget';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );


	-----------------------------------------------------
	--  table CALENDRIER
	--
	--  On garde 5 ans en ligne dans Calendrier, le reste va dans Archive_Calendrier qui ne sera pas purgé
	--  Déplacer dans ARCHIVE_CALENDRIER si CALANMOIS < DATDEBEX - 5 ans
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'CALENDRIER : Laisse 5 ans en ligne ');

		INSERT INTO BIPA.ARCHIVE_CALENDRIER
		(calanmois, ccloture, cafin, cpremens2,
		cmensuelle, cjours, cpremens1, flaglock,
		nb_travail_sg, nb_travail_ssii, theorique, date_ebis_facture, debut_blocage_ebis)
		SELECT
		calanmois, ccloture, cafin, cpremens2,
		cmensuelle, cjours, cpremens1, flaglock,
		nb_travail_sg, nb_travail_ssii, theorique, date_ebis_facture, debut_blocage_ebis
		FROM CALENDRIER
		WHERE calanmois < L_MOINS5ANS ;

		COMMIT;
		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes copiées dans la table archive_calendrier';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

		DELETE FROM CALENDRIER WHERE calanmois < L_MOINS5ANS  ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table calendrier';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );


	-----------------------------------------------------
	--  table CONSOMME
	--
	--  On garde 5 ans en ligne dans Consomme, le reste va dans Archive_Consomme qui ne sera pas purgé
	--  Déplacer dans ARCHIVE_CONSOMME si ANNEE < Année(DATDEBEX - 5 ans ) et CUSAG<>0
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'CONSOMME : Laisse 5 ans en ligne, n''archive pas les consommés à O ');

		INSERT INTO BIPA.ARCHIVE_CONSOMME
		(annee, pid, cusag, xcusag)
		SELECT
		annee, pid, cusag, xcusag
		FROM CONSOMME
		WHERE annee < L_ANNEE5ANS
		AND cusag <> 0 ;
		COMMIT;
		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes copiées dans la table archive_consomme';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

		DELETE FROM CONSOMME WHERE annee < L_ANNEE5ANS  ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table consomme';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table CONS_SSTACHE_RES
	--
	--  Archivage des données correspondant à des lignes BIP fermées depuis + 5 ans( ADATESTATUT < DATDEBEX-5ans)
    --  Déplacer dans ARCHIVE_CONS_SSTACHE_RES dans ces cas
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'CONS_SSTACHE_RES : Archivage des données correspondant à des lignes BIP fermées depuis + 5 ans ');

		INSERT INTO BIPA.ARCHIVE_CONS_SSTACHE_RES
		(tplan, tactu, test, pid, ecet, acta, acst, ident)
		SELECT
		tplan, tactu, test, pid, ecet, acta, acst, ident
		FROM CONS_SSTACHE_RES
			WHERE pid IN
				(SELECT pid FROM LIGNE_BIP
					WHERE ADATESTATUT < L_MOINS5ANS
				);

		COMMIT;
		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes copiées dans la table archive_cons_sstache_res';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

		DELETE FROM CONS_SSTACHE_RES
			WHERE pid IN
				(SELECT pid FROM LIGNE_BIP
					WHERE ADATESTATUT < L_MOINS5ANS
				);
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table cons_sstache_res';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table CONS_SSTACHE_RES_MOIS_ARCHIVE
	--
	-- 	On garde 3 ans en ligne dans CONS_SSTACHE_RES_MOIS_ARCHIVE ,
	--	le reste va dans ARCHIVE_CONS_SSTACHE_RES_MOIS qui sera gardé 7 ans de plus
	--  Déplacer dans ARCHIVE_CONS_SSTACHE_RES_MOIS  si CDEB < DATDEBEX - 3 ans
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'CONS_SSTACHE_RES_MOIS_ARCHIVE : Garde 3 ans en ligne ');
		L_COMPTEUR := 0;
		L_TOTAL := 0;
		L_STATEMENT := 'Sauvegarde Des données dans la table archive_cons_sstache_res_mois';


		DECLARE
			CURSOR c_cons_archive IS
				SELECT	cdeb, cdur, cusag, chraf, chinit, pid, ecet, acta, acst, ident
				FROM CONS_SSTACHE_RES_MOIS_ARCHIVE
				WHERE cdeb < L_MOINS3ANS;

		BEGIN
			FOR un_cons IN c_cons_archive LOOP
				--
				-- On sauvegarde les données dans la table archive_cons_sstache_res_mois avant de la supprimer
				--
				INSERT INTO BIPA.ARCHIVE_CONS_SSTACHE_RES_MOIS
				(cdeb, cdur, cusag, chraf, chinit, pid, ecet, acta, acst, ident)
				VALUES
				( un_cons.cdeb, un_cons.cdur, un_cons.cusag, un_cons.chraf, un_cons.chinit,
				  un_cons.pid, un_cons.ecet, un_cons.acta, un_cons.acst, un_cons.ident );

				-- Gère un commit tous les 10000 enregistrements
				L_COMPTEUR:= L_COMPTEUR+1;
				IF L_COMPTEUR>=10000 THEN
					COMMIT;
					L_TOTAL := L_TOTAL + L_COMPTEUR ;
					L_COMPTEUR:=0;
				END IF;

			END LOOP;
			COMMIT;

			L_TOTAL := L_TOTAL + L_COMPTEUR ;
			L_STATEMENT := '-> '||L_TOTAL ||' lignes copiées dans la table archive_cons_sstache_res_mois';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

			L_TOTAL := 0;
			L_STATEMENT := 'Suppression dans la table cons_sstache_res_mois_archive';

			LOOP
				--
				-- On supprime les données dans la table cons_sstache_res_mois_archive
				-- fait un commit tous les 10000 enregistrements
				--
				DELETE FROM CONS_SSTACHE_RES_MOIS_ARCHIVE
				WHERE cdeb < L_MOINS3ANS
				AND   ROWNUM <= 10000;

				L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;

				-- On sort de la boucle si on a supprimé moins de 10000 enregistrements
				EXIT WHEN SQL%ROWCOUNT < 10000;
				COMMIT;

			END LOOP;
			COMMIT;

			L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table cons_sstache_res_mois_archive';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		EXCEPTION
			when others then
			    rollback;
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
				TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				raise CALLEE_FAILED;
		END;

	-----------------------------------------------------
	--  table COUT_STD_SG
	--
	--  On garde 3 ans en ligne dans Cout_std_sg, le reste va dans Archive_Cout_std_sg qui ne sera pas purgé
    --  Déplacer dans ARCHIVE_COUT_STD_SG si ANNEE < Annee(DATDEBEX - 3 ans)
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'COUT_STD_SG : Laisse 3 ans en ligne ');

		INSERT INTO BIPA.ARCHIVE_COUT_STD_SG
		(annee, niveau, metier, cout_sg,
		dpg_haut, dpg_bas, flaglock)
		SELECT
		annee, niveau, metier, cout_sg,
		dpg_haut, dpg_bas, flaglock
		FROM COUT_STD_SG
		WHERE annee < L_ANNEE3ANS ;

		COMMIT;
		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes copiées dans la table archive_Cout_std_sg';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

		DELETE FROM COUT_STD_SG WHERE annee < L_ANNEE3ANS   ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table Cout_std_sg';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table CUMUL_CONSO
	--
	-- 	On garde 1 an en ligne dans Cumul_conso , le reste va dans Archive_Cumul_conso qui sera gardé 10 ans.
	--	Déplacer dans ARCHIVE_CUMUL_CONSO  si ANNEE < Annee(DATDEBEX - 1 an)
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'CUMUL_CONSO : Laisse 1 an en ligne ');

		INSERT INTO BIPA.ARCHIVE_CUMUL_CONSO
		(annee, pid, ftsg, ftssii,
		envsg, envssii)
		SELECT
		annee, pid, ftsg, ftssii,
		envsg, envssii
		FROM CUMUL_CONSO
		WHERE annee < L_ANNEE1AN ;

		COMMIT;
		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes copiées dans la table archive_cumul_conso';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

		DELETE FROM CUMUL_CONSO WHERE annee < L_ANNEE1AN   ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table cumul_conso';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );


	-----------------------------------------------------
	--  table HISTO_STOCK_FI
	--
	-- 	On garde 3 ans en ligne dans HISTO_STOCK_FI ,
	--	le reste va dans ARCHIVE_HISTO_STOCK_FI qui sera gardé 7 ans de plus
	--  Déplacer dans ARCHIVE_HISTO_STOCK_FI  si CDEB < DATDEBEX - 3 ans
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'HISTO_STOCK_FI : Garde 3 ans en ligne ');
		L_COMPTEUR := 0;
		L_TOTAL := 0;
		L_STATEMENT := 'Sauvegarde Des données dans la table archive_histo_stock_fi';


		DECLARE
			CURSOR c_fi_archive IS
				SELECT
				cdeb, pid, ident, typproj,
				metier, pnom, codsg, dpcode,
				icpi, codcamo, clibrca, cafi,
				codsgress, libdsg, rnom, rtype,
				prestation, niveau, soccode, cada,
				coutftht, coutft, coutenv, consojhimmo,
				nconsojhimmo, consoft, consoenvimmo, nconsoenvimmo,
				a_consojhimmo, a_nconsojhimmo, a_consoft, a_consoenvimmo,
				a_nconsoenvimmo, fi1, profil_fi
				FROM HISTO_STOCK_FI
				WHERE cdeb < L_MOINS3ANS;

		BEGIN
			FOR un_cons IN c_fi_archive LOOP
				--
				-- On sauvegarde les données dans la table archive_histo_stock_fi avant de la supprimer
				--
				INSERT INTO BIPA.ARCHIVE_HISTO_STOCK_FI
				(cdeb, pid, ident, typproj,
				metier, pnom, codsg, dpcode,
				icpi, codcamo, clibrca, cafi,
				codsgress, libdsg, rnom, rtype,
				prestation, niveau, soccode, cada,
				coutftht, coutft, coutenv, consojhimmo,
				nconsojhimmo, consoft, consoenvimmo, nconsoenvimmo,
				a_consojhimmo, a_nconsojhimmo, a_consoft, a_consoenvimmo,
				a_nconsoenvimmo, fi1, profil_fi)
				VALUES
				( un_cons.cdeb, un_cons.pid, un_cons.ident, un_cons.typproj,
				un_cons.metier, un_cons.pnom, un_cons.codsg, un_cons.dpcode,
				un_cons.icpi, un_cons.codcamo, un_cons.clibrca, un_cons.cafi,
				un_cons.codsgress, un_cons.libdsg, un_cons.rnom, un_cons.rtype,
				un_cons.prestation, un_cons.niveau, un_cons.soccode, un_cons.cada,
				un_cons.coutftht, un_cons.coutft, un_cons.coutenv, un_cons.consojhimmo,
				un_cons.nconsojhimmo, un_cons.consoft, un_cons.consoenvimmo, un_cons.nconsoenvimmo,
				un_cons.a_consojhimmo, un_cons.a_nconsojhimmo, un_cons.a_consoft, un_cons.a_consoenvimmo,
				un_cons.a_nconsoenvimmo, un_cons.fi1, un_cons.profil_fi);


				-- Gère un commit tous les 5000 enregistrements
				L_COMPTEUR:= L_COMPTEUR+1;
				IF L_COMPTEUR>=5000 THEN
					COMMIT;
					L_TOTAL := L_TOTAL + L_COMPTEUR ;
					L_COMPTEUR:=0;
				END IF;

			END LOOP;
			COMMIT;

			L_TOTAL := L_TOTAL + L_COMPTEUR ;
			L_STATEMENT := '-> '||L_TOTAL ||' lignes copiées dans la table archive_histo_stock_fi';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

			L_TOTAL := 0;
			L_STATEMENT := 'Suppression dans la table histo_stock_fi';

			LOOP
				--
				-- On supprime les données dans la table histo_stock_fi
				-- fait un commit tous les 5000 enregistrements
				--
				DELETE FROM HISTO_STOCK_FI
				WHERE cdeb < L_MOINS3ANS
				AND   ROWNUM <= 5000;

				L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;

				-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
				EXIT WHEN SQL%ROWCOUNT < 5000;
				COMMIT;

			END LOOP;
			COMMIT;

			L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table histo_stock_fi';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		EXCEPTION
			when others then
			    rollback;
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
				TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				raise CALLEE_FAILED;
		END;


	-----------------------------------------------------
	--  table HISTO_STOCK_IMMO
	--
	-- 	On garde 3 ans en ligne dans HISTO_STOCK_IMMO ,
	--	le reste va dans ARCHIVE_HISTO_STOCK_IMMO qui sera gardé 7 ans de plus
	--  Déplacer dans ARCHIVE_HISTO_STOCK_IMMO  si CDEB < DATDEBEX - 3 ans
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'HISTO_STOCK_IMMO : Garde 3 ans en ligne ');
		L_COMPTEUR := 0;
		L_TOTAL := 0;
		L_STATEMENT := 'Sauvegarde Des données dans la table archive_histo_stock_immo';


		DECLARE
			CURSOR c_immo_archive IS
				SELECT
				cdeb, pid, ident, typproj,
				metier, pnom, codsg, dpcode,
				icpi, codcamo, clibrca, cafi,
				codsgress, libdsg, rnom, rtype,
				prestation, niveau, soccode, cada,
				coutftht, coutft, consojh, consoft,
				a_consojh, a_consoft, immo1
				FROM HISTO_STOCK_IMMO
				WHERE cdeb < L_MOINS3ANS;

		BEGIN
			FOR un_cons IN c_immo_archive LOOP
				--
				-- On sauvegarde les données dans la table archive_histo_stock_immo avant de la supprimer
				--
				INSERT INTO BIPA.ARCHIVE_HISTO_STOCK_IMMO
				(cdeb, pid, ident, typproj,
				metier, pnom, codsg, dpcode,
				icpi, codcamo, clibrca, cafi,
				codsgress, libdsg, rnom, rtype,
				prestation, niveau, soccode, cada,
				coutftht, coutft, consojh, consoft,
				a_consojh, a_consoft, immo1)
				VALUES
				( un_cons.cdeb, un_cons.pid, un_cons.ident, un_cons.typproj,
				un_cons.metier, un_cons.pnom, un_cons.codsg, un_cons.dpcode,
				un_cons.icpi, un_cons.codcamo, un_cons.clibrca, un_cons.cafi,
				un_cons.codsgress, un_cons.libdsg, un_cons.rnom, un_cons.rtype,
				un_cons.prestation, un_cons.niveau, un_cons.soccode, un_cons.cada,
				un_cons.coutftht, un_cons.coutft, un_cons.consojh, un_cons.consoft,
				un_cons.a_consojh, un_cons.a_consoft,  un_cons.immo1);


				-- Gère un commit tous les 5000 enregistrements
				L_COMPTEUR:= L_COMPTEUR+1;
				IF L_COMPTEUR>=5000 THEN
					COMMIT;
					L_TOTAL := L_TOTAL + L_COMPTEUR ;
					L_COMPTEUR:=0;
				END IF;

			END LOOP;
			COMMIT;

			L_TOTAL := L_TOTAL + L_COMPTEUR ;
			L_STATEMENT := '-> '||L_TOTAL ||' lignes copiées dans la table archive_histo_stock_immo';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

			L_TOTAL := 0;
			L_STATEMENT := 'Suppression dans la table histo_stock_immo';

			LOOP
				--
				-- On supprime les données dans la table histo_stock_immo
				-- fait un commit tous les 5000 enregistrements
				--
				DELETE FROM HISTO_STOCK_IMMO
				WHERE cdeb < L_MOINS3ANS
				AND   ROWNUM <= 5000;

				L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;

				-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
				EXIT WHEN SQL%ROWCOUNT < 5000;
				COMMIT;

			END LOOP;
			COMMIT;

			L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table histo_stock_immo';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		EXCEPTION
			when others then
			    rollback;
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
				TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				raise CALLEE_FAILED;
		END;

-----------------------------------------------------
	--  table HISTO_STOCK_IMMO_SC
	--
	-- 	On garde 3 ans en ligne dans HISTO_STOCK_IMMO_SC ,
	--	le reste va dans ARCHIVE_HISTO_STOCK_IMMO_SC qui sera gardé 7 ans de plus
	--  Déplacer dans ARCHIVE_HISTO_STOCK_IMMO_SC  si CDEB < DATDEBEX - 3 ans
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'HISTO_STOCK_IMMO_SC : Garde 3 ans en ligne ');
		L_COMPTEUR := 0;
		L_TOTAL := 0;
		L_STATEMENT := 'Sauvegarde Des données dans la table archive_histo_stock_immo_sc';


		DECLARE
			CURSOR c_immo_SC_archive IS
				SELECT
				cdeb, pid, ident, typproj,
				metier, pnom, codsg, dpcode,
				icpi, codcamo, clibrca, cafi,
				codsgress, libdsg, rnom, rtype,
				prestation, niveau, soccode, cada,
				coutftht, coutft, consojh, consoft,
				a_consojh, a_consoft, immo1
				FROM HISTO_STOCK_IMMO_SC
				WHERE cdeb < L_MOINS3ANS;

		BEGIN
			FOR un_cons IN c_immo_SC_archive LOOP
				--
				-- On sauvegarde les données dans la table archive_histo_stock_immo avant de la supprimer
				--
				INSERT INTO BIPA.ARCHIVE_HISTO_STOCK_IMMO_SC
				(cdeb, pid, ident, typproj,
				metier, pnom, codsg, dpcode,
				icpi, codcamo, clibrca, cafi,
				codsgress, libdsg, rnom, rtype,
				prestation, niveau, soccode, cada,
				coutftht, coutft, consojh, consoft,
				a_consojh, a_consoft, immo1)
				VALUES
				( un_cons.cdeb, un_cons.pid, un_cons.ident, un_cons.typproj,
				un_cons.metier, un_cons.pnom, un_cons.codsg, un_cons.dpcode,
				un_cons.icpi, un_cons.codcamo, un_cons.clibrca, un_cons.cafi,
				un_cons.codsgress, un_cons.libdsg, un_cons.rnom, un_cons.rtype,
				un_cons.prestation, un_cons.niveau, un_cons.soccode, un_cons.cada,
				un_cons.coutftht, un_cons.coutft, un_cons.consojh, un_cons.consoft,
				un_cons.a_consojh, un_cons.a_consoft,  un_cons.immo1);


				-- Gère un commit tous les 5000 enregistrements
				L_COMPTEUR:= L_COMPTEUR+1;
				IF L_COMPTEUR>=5000 THEN
					COMMIT;
					L_TOTAL := L_TOTAL + L_COMPTEUR ;
					L_COMPTEUR:=0;
				END IF;

			END LOOP;
			COMMIT;

			L_TOTAL := L_TOTAL + L_COMPTEUR ;
			L_STATEMENT := '-> '||L_TOTAL ||' lignes copiées dans la table archive_histo_stock_immo_sc';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

			L_TOTAL := 0;
			L_STATEMENT := 'Suppression dans la table histo_stock_immo_sc';

			LOOP
				--
				-- On supprime les données dans la table histo_stock_immo_SC
				-- fait un commit tous les 5000 enregistrements
				--
				DELETE FROM HISTO_STOCK_IMMO_SC
				WHERE cdeb < L_MOINS3ANS
				AND   ROWNUM <= 5000;

				L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;

				-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
				EXIT WHEN SQL%ROWCOUNT < 5000;
				COMMIT;

			END LOOP;
			COMMIT;

			L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table histo_stock_immo_SC';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		EXCEPTION
			when others then
			    rollback;
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
				TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				raise CALLEE_FAILED;
		END;

	-----------------------------------------------------
	--  table ISAC_CONSOMME
	--
	-- 	On garde en ligne que l'année en cours dans Isac_Consomme ,
	--    le reste va dans Archive_Isac_Consomme qui sera gardé 1 ans de plus
	--  Déplacer dans ARCHIVE_ISAC_CONSOMME  si CDEB < DATDEBEX
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'ISAC_CONSOMME : Garde 0 ans en ligne ');
		L_COMPTEUR := 0;
		L_TOTAL := 0;
		L_STATEMENT := 'Sauvegarde Des données dans la table archive_isac_consomme';

		DECLARE
			CURSOR c_isac_archive IS
				SELECT	ident, sous_tache, cdeb, cusag, pid, etape, tache
				FROM ISAC_CONSOMME
				WHERE cdeb < L_MOINS0ANS;

		BEGIN
			FOR un_cons IN c_isac_archive LOOP
				--
				-- On sauvegarde les données dans la table archive_isac_consomme avant de la supprimer
				--
				INSERT INTO BIPA.ARCHIVE_ISAC_CONSOMME
				(ident, sous_tache, cdeb, cusag, pid, etape, tache)
				VALUES
				( un_cons.ident, un_cons.sous_tache, un_cons.cdeb, un_cons.cusag,
				  un_cons.pid, un_cons.etape, un_cons.tache );

				-- Gère un commit tous les 10000 enregistrements
				L_COMPTEUR:= L_COMPTEUR+1;
				IF L_COMPTEUR>=10000 THEN
					COMMIT;
					L_TOTAL := L_TOTAL + L_COMPTEUR ;
					L_COMPTEUR:=0;
				END IF;

			END LOOP;
			COMMIT;

			L_TOTAL := L_TOTAL + L_COMPTEUR ;
			L_STATEMENT := '-> '||L_TOTAL ||' lignes copiées dans la table archive_isac_consomme';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

			L_TOTAL := 0;
			L_STATEMENT := 'Suppression dans la table isac_consomme';

			LOOP
				--
				-- On supprime les données dans la table isac_consomme
				-- fait un commit tous les 10000 enregistrements
				--
				DELETE FROM ISAC_CONSOMME
				WHERE cdeb < L_MOINS0ANS
				AND   ROWNUM <= 10000;

				L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;

				-- On sort de la boucle si on a supprimé moins de 10000 enregistrements
				EXIT WHEN SQL%ROWCOUNT < 10000;
				COMMIT;

			END LOOP;
			COMMIT;

			L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table isac_consomme';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		EXCEPTION
			when others then
			    rollback;
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
				TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				raise CALLEE_FAILED;
		END;

	-----------------------------------------------------
	--  table PROPLUS
	--
	-- 	On garde 1 an en ligne dans PROPLUS ,
	--    le reste va dans ARCHIVE_PROPLUS qui sera gardé 9 ans de plus
	--  Déplacer dans ARCHIVE_PROPLUS  si CDEB < DATDEBEX - 1 an
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'PROPLUS : Garde 1 an en ligne ');
		L_COMPTEUR := 0;
		L_TOTAL := 0;
		L_STATEMENT := 'Sauvegarde Des données dans la table archive_proplus';

		DECLARE
			CURSOR c_proplus_archive IS
				SELECT
				factpid, pid, aist, aistty,
				tires, cdeb, ptype, factpty,
				pnom, factpno, pdsg, factpdsg,
				pcpi, factpcp, pcmouvra, factpcm,
				pnmouvra, pdatdebpre, cusag, rnom,
				rprenom, datdep, divsecgrou, cpident,
				cout, matricule, societe, qualif,
				dispo, chinit, chraf, rtype
				FROM PROPLUS
				WHERE cdeb < L_MOINS1AN;

		BEGIN
			FOR un_cons IN c_proplus_archive LOOP
				--
				-- On sauvegarde les données dans la table archive_proplus avant de la supprimer
				--
				INSERT INTO BIPA.ARCHIVE_PROPLUS
				(factpid, pid, aist, aistty,
				tires, cdeb, ptype, factpty,
				pnom, factpno, pdsg, factpdsg,
				pcpi, factpcp, pcmouvra, factpcm,
				pnmouvra, pdatdebpre, cusag, rnom,
				rprenom, datdep, divsecgrou, cpident,
				cout, matricule, societe, qualif,
				dispo, chinit, chraf, rtype)
				VALUES
				( un_cons.factpid, un_cons.pid, un_cons.aist, un_cons.aistty,
				un_cons.tires, un_cons.cdeb, un_cons.ptype, un_cons.factpty,
				un_cons.pnom, un_cons.factpno, un_cons.pdsg, un_cons.factpdsg,
				un_cons.pcpi, un_cons.factpcp, un_cons.pcmouvra, un_cons.factpcm,
				un_cons.pnmouvra, un_cons.pdatdebpre, un_cons.cusag, un_cons.rnom,
				un_cons.rprenom, un_cons.datdep, un_cons.divsecgrou, un_cons.cpident,
				un_cons.cout, un_cons.matricule, un_cons.societe, un_cons.qualif,
				un_cons.dispo, un_cons.chinit, un_cons.chraf, un_cons.rtype );

				-- Gère un commit tous les 5000 enregistrements
				L_COMPTEUR:= L_COMPTEUR+1;
				IF L_COMPTEUR>=5000 THEN
					COMMIT;
					L_TOTAL := L_TOTAL + L_COMPTEUR ;
					L_COMPTEUR:=0;
				END IF;

			END LOOP;
			COMMIT;

			L_TOTAL := L_TOTAL + L_COMPTEUR ;
			L_STATEMENT := '-> '||L_TOTAL ||' lignes copiées dans la table archive_proplus';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

			L_TOTAL := 0;
			L_STATEMENT := 'Suppression dans la table proplus';

			LOOP
				--
				-- On supprime les données dans la table proplus
				-- fait un commit tous les 5000 enregistrements
				--
				DELETE FROM PROPLUS
				WHERE cdeb < L_MOINS1AN
				AND   ROWNUM <= 5000;

				L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;

				-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
				EXIT WHEN SQL%ROWCOUNT < 5000;
				COMMIT;

			END LOOP;
			COMMIT;

			L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table proplus';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		EXCEPTION
			when others then
			    rollback;
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
				TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				raise CALLEE_FAILED;
		END;

	-----------------------------------------------------
	--  table REE_REESTIME
	--
	-- 	On garde en ligne que l'année en cours dans REE_REESTIME ,
	--    le reste va dans ARCHIVE_REE_REESTIME qui sera gardé 1 ans de plus
	--  Déplacer dans ARCHIVE_REE_REESTIME  si CDEB < DATDEBEX
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'REE_REESTIME : Laisse 0 an en ligne ');

		INSERT INTO BIPA.ARCHIVE_REE_REESTIME
		(codsg, code_scenario, cdeb, type,
		ident, code_activite, conso_prevu)
		SELECT
		codsg, code_scenario, cdeb, type,
		ident, code_activite, conso_prevu
		FROM REE_REESTIME
		WHERE cdeb < L_MOINS0ANS ;

		COMMIT;
		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes copiées dans la table archive_ree_reestime';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

		DELETE FROM REE_REESTIME WHERE cdeb < L_MOINS0ANS   ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table ree_reestime';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-----------------------------------------------------
	--  table STOCK_RA
	--
	-- 	On garde en ligne que l'année en cours dans STOCK_RA ,
	--    le reste va dans ARCHIVE_STOCK_RA qui sera gardé 1 ans de plus
	--  Déplacer dans ARCHIVE_STOCK_RA  si CDEB < DATDEBEX
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'STOCK_RA : Garde 0 ans en ligne ');
		L_COMPTEUR := 0;
		L_TOTAL := 0;
		L_STATEMENT := 'Sauvegarde Des données dans la table archive_stock_ra';

		DECLARE
			CURSOR c_ra_archive IS
				SELECT	factpid, pid, cdeb, typproj,
				metier, pnom, codsg, dpcode,
				icpi, cada, codcamo, ecet,
				typetap, acta, acst, aist,
				asnom, cafi, codsgress, ident,
				rtype, niveau, prestation, soccode,
				coutftht, coutfthtr, coutenv, consojh,
				consoft, consoenv, a_consojh, a_consoft,
				a_consoenv, flag_ra
				FROM STOCK_RA
				WHERE cdeb < L_MOINS0ANS;

		BEGIN
			FOR un_cons IN c_ra_archive LOOP
				--
				-- On sauvegarde les données dans la table archive_stock_ra avant de la supprimer
				--
				INSERT INTO BIPA.ARCHIVE_STOCK_RA
				(factpid, pid, cdeb, typproj,
				metier, pnom, codsg, dpcode,
				icpi, cada, codcamo, ecet,
				typetap, acta, acst, aist,
				asnom, cafi, codsgress, ident,
				rtype, niveau, prestation, soccode,
				coutftht, coutfthtr, coutenv, consojh,
				consoft, consoenv, a_consojh, a_consoft,
				a_consoenv, flag_ra)
				VALUES
				( un_cons.factpid, un_cons.pid, un_cons.cdeb, un_cons.typproj,
				un_cons.metier, un_cons.pnom, un_cons.codsg, un_cons.dpcode,
				un_cons.icpi, un_cons.cada, un_cons.codcamo, un_cons.ecet,
				un_cons.typetap, un_cons.acta, un_cons.acst, un_cons.aist,
				un_cons.asnom, un_cons.cafi, un_cons.codsgress, un_cons.ident,
				un_cons.rtype, un_cons.niveau, un_cons.prestation, un_cons.soccode,
				un_cons.coutftht, un_cons.coutfthtr, un_cons.coutenv, un_cons.consojh,
				un_cons.consoft, un_cons.consoenv, un_cons.a_consojh, un_cons.a_consoft,
				un_cons.a_consoenv, un_cons.flag_ra );

				-- Gère un commit tous les 5000 enregistrements
				L_COMPTEUR:= L_COMPTEUR+1;
				IF L_COMPTEUR>=5000 THEN
					COMMIT;
					L_TOTAL := L_TOTAL + L_COMPTEUR ;
					L_COMPTEUR:=0;
				END IF;

			END LOOP;
			COMMIT;

			L_TOTAL := L_TOTAL + L_COMPTEUR ;
			L_STATEMENT := '-> '||L_TOTAL ||' lignes copiées dans la table archive_stock_ra';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

			L_TOTAL := 0;
			L_STATEMENT := 'Suppression dans la table stock_ra';

			LOOP
				--
				-- On supprime les données dans la table stock_ra
				-- fait un commit tous les 5000 enregistrements
				--
				DELETE FROM STOCK_RA
				WHERE cdeb < L_MOINS0ANS
				AND   ROWNUM <= 5000;

				L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;

				-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
				EXIT WHEN SQL%ROWCOUNT < 5000;
				COMMIT;

			END LOOP;
			COMMIT;

			L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table stock_ra';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		EXCEPTION
			when others then
			    rollback;
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
				TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				raise CALLEE_FAILED;
		END;
	-----------------------------------------------------
	--  table SYNTHESE_ACTIVITE
	--
	-- 	On garde 5 ans en ligne dans SYNTHESE_ACTIVITE ,
	--    le reste va dans ARCHIVE_SYNTHESE_ACTIVITE qui sera gardé 9 ans de plus
	--  Déplacer dans ARCHIVE_SYNTHESE_ACTIVITE   si ANNEE < Annee(DATDEBEX - 5 ans)
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'SYNTHESE_ACTIVITE : Garde 5 ans en ligne ');
		L_COMPTEUR := 0;
		L_TOTAL := 0;
		L_STATEMENT := 'Sauvegarde Des données dans la table archive_synthese_activite';

		DECLARE
			CURSOR c_sa_archive IS
				SELECT
				pid, annee, typproj, metier,
				pnom, codsg, dpcode, icpi,
				codcamo, consojh_sg, consojh_ssii, consoft_sg,
				consoft_ssii, consoenv_sg, consoenv_ssii
				FROM SYNTHESE_ACTIVITE
				WHERE annee < L_ANNEE5ANS;

		BEGIN
			FOR un_cons IN c_sa_archive LOOP
				--
				-- On sauvegarde les données dans la table archive_synthese_activite avant de la supprimer
				--
				INSERT INTO BIPA.ARCHIVE_SYNTHESE_ACTIVITE
				(pid, annee, typproj, metier,
				pnom, codsg, dpcode, icpi,
				codcamo, consojh_sg, consojh_ssii, consoft_sg,
				consoft_ssii, consoenv_sg, consoenv_ssii)
				VALUES
				( un_cons.pid, un_cons.annee, un_cons.typproj, un_cons.metier,
				un_cons.pnom, un_cons.codsg, un_cons.dpcode, un_cons.icpi,
				un_cons.codcamo, un_cons.consojh_sg, un_cons.consojh_ssii, un_cons.consoft_sg,
				un_cons.consoft_ssii, un_cons.consoenv_sg, un_cons.consoenv_ssii );

				-- Gère un commit tous les 5000 enregistrements
				L_COMPTEUR:= L_COMPTEUR+1;
				IF L_COMPTEUR>=5000 THEN
					COMMIT;
					L_TOTAL := L_TOTAL + L_COMPTEUR ;
					L_COMPTEUR:=0;
				END IF;

			END LOOP;
			COMMIT;

			L_TOTAL := L_TOTAL + L_COMPTEUR ;
			L_STATEMENT := '-> '||L_TOTAL ||' lignes copiées dans la table archive_synthese_activite';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

			L_TOTAL := 0;
			L_STATEMENT := 'Suppression dans la table synthese_activite';

			LOOP
				--
				-- On supprime les données dans la table synthese_activite
				-- fait un commit tous les 5000 enregistrements
				--
				DELETE FROM SYNTHESE_ACTIVITE
				WHERE annee < L_ANNEE5ANS
				AND   ROWNUM <= 5000;

				L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;

				-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
				EXIT WHEN SQL%ROWCOUNT < 5000;
				COMMIT;

			END LOOP;
			COMMIT;

			L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table synthese_activite';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		EXCEPTION
			when others then
			    rollback;
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
				TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				raise CALLEE_FAILED;
		END;


	-----------------------------------------------------
	--  table SYNTHESE_ACTIVITE_MOIS
	--
	-- 	On garde 1 an en ligne dans SYNTHESE_ACTIVITE_MOIS ,
	--    le reste va dans ARCHIVE_SYNTHESE_ACTIVITE_MOIS qui sera gardé 4 ans de plus
	--  Déplacer dans ARCHIVE_SYNTHESE_ACTIVITE_MOIS   si CDEB < DATDEBEX - 1 an
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'SYNTHESE_ACTIVITE_MOIS : Garde 1 ans en ligne ');
		L_COMPTEUR := 0;
		L_TOTAL := 0;
		L_STATEMENT := 'Sauvegarde Des données dans la table archive_synthese_activite_mois';

		DECLARE
			CURSOR c_sam_archive IS
				SELECT
				pid, cdeb, typproj, metier,
				pnom, codsg, dpcode, icpi,
				codcamo, consojh_sg, consojh_ssii, consoft_sg,
				consoft_ssii, consoenv_sg, consoenv_ssii
				FROM SYNTHESE_ACTIVITE_MOIS
				WHERE cdeb < L_MOINS1AN;

		BEGIN
			FOR un_cons IN c_sam_archive LOOP
				--
				-- On sauvegarde les données dans la table archive_synthese_activite_mois avant de la supprimer
				--
				INSERT INTO BIPA.ARCHIVE_SYNTHESE_ACTIVITE_MOIS
				(pid, cdeb, typproj, metier,
				pnom, codsg, dpcode, icpi,
				codcamo, consojh_sg, consojh_ssii, consoft_sg,
				consoft_ssii, consoenv_sg, consoenv_ssii)
				VALUES
				( un_cons.pid, un_cons.cdeb, un_cons.typproj, un_cons.metier,
				un_cons.pnom, un_cons.codsg, un_cons.dpcode, un_cons.icpi,
				un_cons.codcamo, un_cons.consojh_sg, un_cons.consojh_ssii, un_cons.consoft_sg,
				un_cons.consoft_ssii, un_cons.consoenv_sg, un_cons.consoenv_ssii );

				-- Gère un commit tous les 5000 enregistrements
				L_COMPTEUR:= L_COMPTEUR+1;
				IF L_COMPTEUR>=5000 THEN
					COMMIT;
					L_TOTAL := L_TOTAL + L_COMPTEUR ;
					L_COMPTEUR:=0;
				END IF;

			END LOOP;
			COMMIT;

			L_TOTAL := L_TOTAL + L_COMPTEUR ;
			L_STATEMENT := '-> '||L_TOTAL ||' lignes copiées dans la table archive_synthese_activite_mois';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

			L_TOTAL := 0;
			L_STATEMENT := 'Suppression dans la table synthese_activite_mois';

			LOOP
				--
				-- On supprime les données dans la table synthese_activite_mois
				-- fait un commit tous les 5000 enregistrements
				--
				DELETE FROM SYNTHESE_ACTIVITE_MOIS
				WHERE cdeb < L_MOINS1AN
				AND   ROWNUM <= 5000;

				L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;

				-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
				EXIT WHEN SQL%ROWCOUNT < 5000;
				COMMIT;

			END LOOP;
			COMMIT;

			L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table synthese_activite_mois';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		EXCEPTION
			when others then
			    rollback;
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
				TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				raise CALLEE_FAILED;
		END;

	-----------------------------------------------------
	--  table SYNTHESE_FIN
	--
	-- 	On garde 1 an en ligne dans SYNTHESE_FIN ,
	--    le reste va dans ARCHIVE_SYNTHESE_FIN qui sera gardé 4 ans de plus
	--  Déplacer dans ARCHIVE_SYNTHESE_FIN   si ANNEE < Annee(DATDEBEX - 1 an)
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'SYNTHESE_FIN : Garde 1 an en ligne ');
		L_COMPTEUR := 0;
		L_TOTAL := 0;
		L_STATEMENT := 'Sauvegarde Des données dans la table archive_synthese_fin';

		DECLARE
			CURSOR c_sf_archive IS
				SELECT
				annee, pid, codsg, codcamo,
				cafi, codsgress, cada, consojhsg_im,
				consojhssii_im, consoftsg_im, consoftssii_im, consojhsg_fi,
				consojhssii_fi, consoftsg_fi, consoftssii_fi, consoenvsg_ni,
				consoenvssii_ni, consoenvsg_im, consoenvssii_im, d_consojhsg_fi,
				d_consojhssii_fi, d_consoftsg_fi, d_consoftssii_fi, d_consoenvsg_ni,
				d_consoenvssii_ni, d_consoenvsg_im, d_consoenvssii_im, m_consojhsg_im,
				m_consojhssii_im, m_consoftsg_im, m_consoftssii_im, m_consojhsg_fi,
				m_consojhssii_fi, m_consoftsg_fi, m_consoftssii_fi, m_consoenvsg_ni,
				m_consoenvssii_ni, m_consoenvsg_im, m_consoenvssii_im, a_consojh_im,
				a_consoft_im, a_consojh_fi, a_consoft_fi, a_consoenv_ni,
				a_consoenv_im
				FROM SYNTHESE_FIN
				WHERE annee < L_ANNEE1AN;

		BEGIN
			FOR un_cons IN c_sf_archive LOOP
				--
				-- On sauvegarde les données dans la table archive_synthese_fin avant de la supprimer
				--
				INSERT INTO BIPA.ARCHIVE_SYNTHESE_FIN
				(annee, pid, codsg, codcamo,
				cafi, codsgress, cada, consojhsg_im,
				consojhssii_im, consoftsg_im, consoftssii_im, consojhsg_fi,
				consojhssii_fi, consoftsg_fi, consoftssii_fi, consoenvsg_ni,
				consoenvssii_ni, consoenvsg_im, consoenvssii_im, d_consojhsg_fi,
				d_consojhssii_fi, d_consoftsg_fi, d_consoftssii_fi, d_consoenvsg_ni,
				d_consoenvssii_ni, d_consoenvsg_im, d_consoenvssii_im, m_consojhsg_im,
				m_consojhssii_im, m_consoftsg_im, m_consoftssii_im, m_consojhsg_fi,
				m_consojhssii_fi, m_consoftsg_fi, m_consoftssii_fi, m_consoenvsg_ni,
				m_consoenvssii_ni, m_consoenvsg_im, m_consoenvssii_im, a_consojh_im,
				a_consoft_im, a_consojh_fi, a_consoft_fi, a_consoenv_ni,
				a_consoenv_im)
				VALUES
				( un_cons.annee, un_cons.pid, un_cons.codsg, un_cons.codcamo,
				un_cons.cafi, un_cons.codsgress, un_cons.cada, un_cons.consojhsg_im,
				un_cons.consojhssii_im, un_cons.consoftsg_im, un_cons.consoftssii_im, un_cons.consojhsg_fi,
				un_cons.consojhssii_fi, un_cons.consoftsg_fi, un_cons.consoftssii_fi, un_cons.consoenvsg_ni,
				un_cons.consoenvssii_ni, un_cons.consoenvsg_im, un_cons.consoenvssii_im, un_cons.d_consojhsg_fi,
				un_cons.d_consojhssii_fi, un_cons.d_consoftsg_fi, un_cons.d_consoftssii_fi, un_cons.d_consoenvsg_ni,
				un_cons.d_consoenvssii_ni, un_cons.d_consoenvsg_im, un_cons.d_consoenvssii_im, un_cons.m_consojhsg_im,
				un_cons.m_consojhssii_im, un_cons.m_consoftsg_im, un_cons.m_consoftssii_im, un_cons.m_consojhsg_fi,
				un_cons.m_consojhssii_fi, un_cons.m_consoftsg_fi, un_cons.m_consoftssii_fi, un_cons.m_consoenvsg_ni,
				un_cons.m_consoenvssii_ni, un_cons.m_consoenvsg_im, un_cons.m_consoenvssii_im, un_cons.a_consojh_im,
				un_cons.a_consoft_im, un_cons.a_consojh_fi, un_cons.a_consoft_fi, un_cons.a_consoenv_ni,
				un_cons.a_consoenv_im );

				-- Gère un commit tous les 5000 enregistrements
				L_COMPTEUR:= L_COMPTEUR+1;
				IF L_COMPTEUR>=5000 THEN
					COMMIT;
					L_TOTAL := L_TOTAL + L_COMPTEUR ;
					L_COMPTEUR:=0;
				END IF;

			END LOOP;
			COMMIT;

			L_TOTAL := L_TOTAL + L_COMPTEUR ;
			L_STATEMENT := '-> '||L_TOTAL ||' lignes copiées dans la table archive_synthese_fin';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

			L_TOTAL := 0;
			L_STATEMENT := 'Suppression dans la table synthese_fin';

			LOOP
				--
				-- On supprime les données dans la table synthese_fin
				-- fait un commit tous les 5000 enregistrements
				--
				DELETE FROM SYNTHESE_FIN
				WHERE annee < L_ANNEE1AN
				AND   ROWNUM <= 5000;

				L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;

				-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
				EXIT WHEN SQL%ROWCOUNT < 5000;
				COMMIT;

			END LOOP;
			COMMIT;

			L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table synthese_fin';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		EXCEPTION
			when others then
			    rollback;
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
				TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				raise CALLEE_FAILED;
		END;

	-----------------------------------------------------
	--  table SYNTHESE_FIN_BIP
	--
	-- 	On garde 1 an en ligne dans SYNTHESE_FIN_BIP ,
	--    le reste va dans ARCHIVE_SYNTHESE_FIN_BIP qui sera gardé 9 ans de plus
	--  Déplacer dans ARCHIVE_SYNTHESE_FIN_BIP   si ANNEE < Annee(DATDEBEX - 1 an)
	-----------------------------------------------------

    	TRCLOG.TRCLOG( L_HFILE, 'SYNTHESE_FIN_BIP : Garde 1 an en ligne ');
		L_COMPTEUR := 0;
		L_TOTAL := 0;
		L_STATEMENT := 'Sauvegarde Des données dans la table archive_synthese_fin_bip';

		DECLARE
			CURSOR c_sfb_archive IS
				SELECT
				annee, pid, consoftsg_im, consoftssii_im,
				consosg_fi, consossii_fi, d_consosg_fi, d_consossii_fi,
				m_consosg_fi, m_consossii_fi
				FROM SYNTHESE_FIN_BIP
				WHERE annee < L_ANNEE1AN;

		BEGIN
			FOR un_cons IN c_sfb_archive LOOP
				--
				-- On sauvegarde les données dans la table archive_synthese_fin_bip avant de la supprimer
				--
				INSERT INTO BIPA.ARCHIVE_SYNTHESE_FIN_BIP
				(annee, pid, consoftsg_im, consoftssii_im,
				consosg_fi, consossii_fi, d_consosg_fi, d_consossii_fi,
				m_consosg_fi, m_consossii_fi)
				VALUES
				( un_cons.annee, un_cons.pid, un_cons.consoftsg_im, un_cons.consoftssii_im,
				un_cons.consosg_fi, un_cons.consossii_fi, un_cons.d_consosg_fi, un_cons.d_consossii_fi,
				un_cons.m_consosg_fi, un_cons.m_consossii_fi );

				-- Gère un commit tous les 5000 enregistrements
				L_COMPTEUR:= L_COMPTEUR+1;
				IF L_COMPTEUR>=5000 THEN
					COMMIT;
					L_TOTAL := L_TOTAL + L_COMPTEUR ;
					L_COMPTEUR:=0;
				END IF;

			END LOOP;
			COMMIT;

			L_TOTAL := L_TOTAL + L_COMPTEUR ;
			L_STATEMENT := '-> '||L_TOTAL ||' lignes copiées dans la table archive_synthese_fin_bip';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

			L_TOTAL := 0;
			L_STATEMENT := 'Suppression dans la table synthese_fin_bip';

			LOOP
				--
				-- On supprime les données dans la table synthese_fin_bip
				-- fait un commit tous les 5000 enregistrements
				--
				DELETE FROM SYNTHESE_FIN_BIP
				WHERE annee < L_ANNEE1AN
				AND   ROWNUM <= 5000;

				L_TOTAL := L_TOTAL + SQL%ROWCOUNT ;

				-- On sort de la boucle si on a supprimé moins de 5000 enregistrements
				EXIT WHEN SQL%ROWCOUNT < 5000;
				COMMIT;

			END LOOP;
			COMMIT;

			L_STATEMENT := '-> '||L_TOTAL||' lignes supprimées dans la table synthese_fin_bip';
			TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		EXCEPTION
			when others then
			    rollback;
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
				TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				raise CALLEE_FAILED;
		END;


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

	END archive_tables;

END pack_archive_tables;
/


