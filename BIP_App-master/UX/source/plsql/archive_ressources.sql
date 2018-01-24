-- -----------------------------------------------------------------------------------
-- Nom du fichier : archive_ressources.sql
--
-- Objet : Procédure d'archivage lancée lors de la cloture par archive_cloture.sh
--			
--         Procédure d'archivage des ressources 
--
--	       Copie les données des tables dans la base d'archivage et purge
--          les données des tables dont la date est antérieure à 
--          la date de début d'exercice - 5 années 
--
--         Ce traitement permet de ne laisser dans les tables de l'application que
--			les données nécessaires. Les données sont copiées dans les tables 
--          d'archivage, ces tables portent le même nom que la table source mais
--          commencent par ARCHIVE_
--          
--         Tables Concernées : CONS_SSTACHE_RES, CONS_SSTACHE_RES_MOIS, CONTRAT,
--                             FACTURE, LIGNE_CONT, LIGNE_FACT, PROPLUS,
--                             RESSOURCE, SITU_RESS
--
-- ----------------------------------------------------------------------------------
-- Creation : PPR le 15/11/2005 à partir de purge_ressource.sql (remplacé par ce batch)
-- Modifications :
-- ABA TD 718		    /  /  	...
-- SEL PPM 60468 30/12/2014 exclure les ressources à recycler pendant l'archivage annuel
-- ----------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE pack_archive_ressources IS
-- ##################################################################################
--	PROCEDURE d'archivage des ressources
-- ##################################################################################
	PROCEDURE archive_ressources(
		P_LOGDIR	IN VARCHAR2
	);

---	-----------------------------------------------------
---	Procédures appelées dans le corps du traitement
---	-----------------------------------------------------
	PROCEDURE copie_situation(
		p_borne		IN DATE,
		p_logfile	IN utl_file.file_type	);

	PROCEDURE copie_facture(
		p_borne		IN DATE,
		p_logfile	IN utl_file.file_type);

	PROCEDURE copie_contrat(
		p_borne		IN DATE,
		p_logfile	IN utl_file.file_type);

	PROCEDURE copie_consomme(
		p_borne		IN DATE,
		p_logfile	IN utl_file.file_type);

	PROCEDURE copie_ressource(
		p_logfile	IN utl_file.file_type);

	PROCEDURE restaure_situation(
		p_logfile	IN utl_file.file_type);

	PROCEDURE change_chef_projet(
		p_logfile	IN utl_file.file_type);

END pack_archive_ressources;
/


CREATE OR REPLACE PACKAGE BODY     pack_archive_ressources IS
-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
pragma EXCEPTION_init( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !


-- ##################################################################################
--	PROCEDURE d'archivage des ressources
-- ##################################################################################

	PROCEDURE archive_ressources(
		P_LOGDIR	IN VARCHAR2
	) IS
	L_PROCNAME  varchar2(20) := 'ARCHIVE_RESSOURCES';
	L_HFILE     utl_file.file_type;
	L_RETCOD    number;
	L_STATEMENT varchar2(128);
	L_MOINS5ANS DATE; 				-- Date moins 5 ans

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

		SELECT  add_months(datdebex,-60) INTO L_MOINS5ANS FROM datdebex;

	-----------------------------------------------------
	--  Appelle les fonctions d'archivage
	-----------------------------------------------------

		copie_situation(L_MOINS5ANS, L_HFILE);
		copie_facture(	L_MOINS5ANS, L_HFILE);
		copie_contrat(	L_MOINS5ANS, L_HFILE);
		copie_consomme(	L_MOINS5ANS, L_HFILE);
		copie_ressource(L_HFILE);
		restaure_situation( L_HFILE) ;
		change_chef_projet(L_HFILE);

    	TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME );

	EXCEPTION
	when others then
	    rollback;
		if sqlcode <> CALLEE_FAILED_ID then
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		end if;
		TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		raise CALLEE_FAILED;

	END archive_ressources;

	-----------------------------------------------------
	--  Table SITU_RESS
	--  Archive les situations dont la date de départ a de plus de 5 Ans d'ancienneté
	-----------------------------------------------------

	PROCEDURE copie_situation(
		p_borne		IN DATE,
		p_logfile	IN utl_file.file_type
	) IS
		l_compteur	INTEGER;
	BEGIN
		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));
		PACK_GLOBAL.WRITE_STRING(p_logfile, 'Debut de la procedure d''archivage des situations pour la borne ' || TO_CHAR(p_borne, 'dd/mm/yyyy'));

		INSERT INTO BIPA.archive_situ_ress(DATSITU, DATDEP, CPIDENT, COUT, DISPO, MARSG2, RMCOMP, PRESTATION
						, DPREST, IDENT, SOCCODE, CODSG, NIVEAU, MONTANT_MENSUEL,FIDENT, MODE_CONTRACTUEL_INDICATIF)
			SELECT DATSITU, DATDEP, CPIDENT, COUT, DISPO, MARSG2, RMCOMP, PRESTATION
						, DPREST, IDENT, SOCCODE, CODSG, NIVEAU, MONTANT_MENSUEL,FIDENT, MODE_CONTRACTUEL_INDICATIF
			FROM situ_ress
			WHERE datdep<p_borne
			--PPM 60468 : exclure les ressources a recycler lors de l archivage
            AND IDENT NOT IN (select distinct ident from ressource where instr(rnom, 'A-RECYCLER-') = 1)
			;

		DELETE situ_ress
			WHERE datdep<p_borne
			--PPM 60468 : exclure les ressources a recycler lors de l archivage
            AND IDENT NOT IN (select distinct ident from ressource where instr(rnom, 'A-RECYCLER-') = 1)
			;
		l_compteur := SQL%ROWCOUNT;
		COMMIT;
		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(l_compteur) || ' situations anciennes archives.');

		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));
		PACK_GLOBAL.WRITE_STRING(p_logfile, 'Fin de la procedure d''archivage des situations pour la borne ' || TO_CHAR(p_borne, 'dd/mm/yyyy'));
	END copie_situation;

	-----------------------------------------------------
	--  Tables LIGNE_FACT et FACTURE
	--  Archive les lignes factures dont la date a de plus de 5 Ans d'ancienneté
	--  Archive les factures qui n'ont plus de lignes de factures (toutes ont ete archivees)
	-----------------------------------------------------

	PROCEDURE copie_facture(
		p_borne		IN DATE,
		p_logfile	IN utl_file.file_type
	) IS
		l_compteur	INTEGER;
	BEGIN
		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));
		PACK_GLOBAL.WRITE_STRING(p_logfile, 'Debut de la procedure d''archivage des factures pour la borne ' || TO_CHAR(p_borne, 'dd/mm/yyyy'));

		PACK_GLOBAL.WRITE_STRING(p_logfile, '    - Archivage des lignes de factures pour la borne ' || TO_CHAR(p_borne, 'dd/mm/yyyy'));
		INSERT INTO BIPA.archive_ligne_fact(LNUM, LMONTHT, LPREST, LSECTEUR, LCODFINALI, LCODCOMPTA, LDEPPOLE
				, LIDAVFACT, LCODJH, LCODESTINA, LMOISPREST, SOCFACT, TYPFACT, DATFACT, NUMFACT
				, TVA, IDENT, CODCAMO, PID, LRAPPROCHT,TYPDPG)
			SELECT LNUM, LMONTHT, LPREST, LSECTEUR, LCODFINALI, LCODCOMPTA, LDEPPOLE
				, LIDAVFACT, LCODJH, LCODESTINA, LMOISPREST, SOCFACT, TYPFACT, DATFACT, NUMFACT
				, TVA, IDENT, CODCAMO, PID, LRAPPROCHT,TYPDPG
			FROM ligne_fact
			WHERE datfact<p_borne;

		DELETE ligne_fact
			WHERE datfact<p_borne;
		l_compteur := SQL%ROWCOUNT;
		COMMIT;
		PACK_GLOBAL.WRITE_STRING(p_logfile, '      ' || TO_CHAR(l_compteur) || ' lignes de facture archivees.');

		PACK_GLOBAL.WRITE_STRING(p_logfile, '    - Archivage des factures qui n''ont plus de lignes de factures (toutes ont ete archivees)');
		INSERT INTO BIPA.archive_facture(SOCFACT, NUMFACT, TYPFACT, DATFACT, FNOM, FNUMASN, FNUMORDRE, FORDRECHEQ, FENVSEC
					, FPROVSDFF1, FPROVSDFF2, FPROVSEGL1, FPROVSEGL2, FREGCOMPTA, LLIBANALYT, FSTEGLE, FCDSG
					, FLIVRAISON, FMODREGLT, FMOIACOMPTA, FMONTHT, FMONTTTC, FECRITCPTAB, FNMRAPPROCHT, FCODUSER
					, FCENTREFRAIS, FDATMAJ, FDATSAI, FDATSUP, FENRCOMPTA, FBURDISTR, FCODEPOST, FSTATUT1, FSTATUT2
					, FACCSEC, FSOCFOUR, FADRESSE1, FADRESSE2, FADRESSE3, FTVA, FCODCOMPTA, FDEPPOLE, FLAGLOCK
					, SOCCONT, CAV, NUMCONT, FDATRECEP, NUM_SMS,REF_SG, NUM_CHARG, NUM_EXPENSE, CUSAG_EXPENSE, FDATINT)
			SELECT SOCFACT, NUMFACT, TYPFACT, DATFACT, FNOM, FNUMASN, FNUMORDRE, FORDRECHEQ, FENVSEC
					, FPROVSDFF1, FPROVSDFF2, FPROVSEGL1, FPROVSEGL2, FREGCOMPTA, LLIBANALYT, FSTEGLE, FCDSG
					, FLIVRAISON, FMODREGLT, FMOIACOMPTA, FMONTHT, FMONTTTC, FECRITCPTAB, FNMRAPPROCHT, FCODUSER
					, FCENTREFRAIS, FDATMAJ, FDATSAI, FDATSUP, FENRCOMPTA, FBURDISTR, FCODEPOST, FSTATUT1, FSTATUT2
					, FACCSEC, FSOCFOUR, FADRESSE1, FADRESSE2, FADRESSE3, FTVA, FCODCOMPTA, FDEPPOLE, FLAGLOCK
					, SOCCONT, CAV, NUMCONT, FDATRECEP, NUM_SMS,REF_SG, NUM_CHARG, NUM_EXPENSE, CUSAG_EXPENSE, FDATINT
			FROM facture
			WHERE NOT EXISTS (SELECT 1 FROM ligne_fact
					WHERE facture.numfact = ligne_fact.numfact
	  				AND facture.socfact = ligne_fact.socfact
	  				AND facture.datfact = ligne_fact.datfact
	  				AND facture.typfact = ligne_fact.typfact );


		DELETE facture
		WHERE NOT EXISTS (SELECT 1 FROM ligne_fact
				WHERE facture.numfact = ligne_fact.numfact
	  			AND facture.socfact = ligne_fact.socfact
	  			AND facture.datfact = ligne_fact.datfact
	  			AND facture.typfact = ligne_fact.typfact );
		l_compteur := SQL%ROWCOUNT;
		COMMIT;
		PACK_GLOBAL.WRITE_STRING(p_logfile, '      ' || TO_CHAR(l_compteur) || ' factures archivees.');

		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));
		PACK_GLOBAL.WRITE_STRING(p_logfile, 'Fin de la procedure d''archivage des factures pour la borne ' || TO_CHAR(p_borne, 'dd/mm/yyyy'));
	END copie_facture;

	-----------------------------------------------------
	--  Tables LIGNE_CONT et CONTRAT
	--  Archivage des lignes de contrats pour lesquelles il n'existe pas de facture
	--    et il n'existe pas de contrat ou d'avenant dont la date de fin a moins de 5 ans d'ancienneté
	--  Archive les contrats qui n'ont plus de lignes de contrats (toutes ont ete archivees)
	-----------------------------------------------------

	PROCEDURE copie_contrat(
		p_borne		IN DATE,
		p_logfile	IN utl_file.file_type
	) IS
		l_compteur	INTEGER;
	BEGIN
		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));

		PACK_GLOBAL.WRITE_STRING(p_logfile, 'Debut de la procedure d''archivage des contrat pour la borne ' || TO_CHAR(p_borne, 'dd/mm/yyyy'));

		PACK_GLOBAL.WRITE_STRING(p_logfile, '    - Archivage des lignes de contrats pour lesquelles il n''existe pas de facture');
		PACK_GLOBAL.WRITE_STRING(p_logfile, '      et il n''existe pas de contrat ou d''avenant dont la date de fin est supérieure à la borne ');

		INSERT INTO BIPA.archive_ligne_cont(LCNUM, LFRAISDEP, LASTREINTE, LHEURSUP, LRESDEB, LRESFIN, LCDATACT, LCCOUACT
						, LCCOUINIT, LCPREST, SOCCONT, CAV, NUMCONT, IDENT, PROPORIG, MODE_CONTRACTUEL)
			SELECT LCNUM, LFRAISDEP, LASTREINTE, LHEURSUP, LRESDEB, LRESFIN, LCDATACT, LCCOUACT
						, LCCOUINIT, LCPREST, SOCCONT, CAV, NUMCONT, IDENT, PROPORIG, MODE_CONTRACTUEL
			FROM ligne_cont

			WHERE NOT EXISTS	(SELECT 1 FROM contrat c WHERE c.soccont=ligne_cont.soccont
						AND c.numcont=ligne_cont.numcont and c.cdatfin>=p_borne)

			AND NOT EXISTS  	( SELECT 1 FROM facture WHERE facture.numcont = ligne_cont.numcont
						AND facture.socfact = ligne_cont.soccont );


		DELETE ligne_cont
			WHERE NOT EXISTS	(SELECT 1 FROM contrat c WHERE c.soccont=ligne_cont.soccont
						AND c.numcont=ligne_cont.numcont and c.cdatfin>=p_borne)

			AND NOT EXISTS  	( SELECT 1 FROM facture WHERE facture.numcont = ligne_cont.numcont
						AND facture.socfact = ligne_cont.soccont );
		l_compteur := SQL%ROWCOUNT;
		COMMIT;
		PACK_GLOBAL.WRITE_STRING(p_logfile, '      ' || TO_CHAR(l_compteur) || ' lignes de contrats archivees.');


		PACK_GLOBAL.WRITE_STRING(p_logfile, '    - Archivage des contrats qui n''ont plus de lignes de contrats (toutes ont ete archivees)');
		INSERT INTO BIPA.archive_contrat(NUMCONT, CCHTSOC, CTYPFACT, COBJET1, COBJET2, COBJET3, CREM, CANTFACT, CMOIDERFAC, CMMENS
						, CCHARESTI, CECARTHT, CEVAINIT, CNAFFAIR, CAGREMENT, CRANG, CANTCONS, CCOUTHT, CDATANNUL
						, CDATARR, CDATCLOT, CDATDEB, CDATSOCE, CDATFIN, CDATMAJ, CDATDIR, CDATBILQ, CDATRPOL
						, CDATSOCR, CDATSAI, CDUREE, FLAGLOCK, SOCCONT, CAV, FILCODE, COMCODE, NICHE, CODSG
						, CCENTREFRAIS,SIREN,NBLCNUM,TOP30,ORICTR)
			SELECT NUMCONT, CCHTSOC, CTYPFACT, COBJET1, COBJET2, COBJET3, CREM, CANTFACT, CMOIDERFAC, CMMENS
						, CCHARESTI, CECARTHT, CEVAINIT, CNAFFAIR, CAGREMENT, CRANG, CANTCONS, CCOUTHT, CDATANNUL
						, CDATARR, CDATCLOT, CDATDEB, CDATSOCE, CDATFIN, CDATMAJ, CDATDIR, CDATBILQ, CDATRPOL
						, CDATSOCR, CDATSAI, CDUREE, FLAGLOCK, SOCCONT, CAV, FILCODE, COMCODE, NICHE, CODSG
						, CCENTREFRAIS,SIREN,NBLCNUM,TOP30,ORICTR
			FROM contrat
			WHERE NOT EXISTS (SELECT 1 FROM ligne_cont
					WHERE contrat.numcont = ligne_cont.numcont
	  				AND contrat.soccont = ligne_cont.soccont
	  				AND contrat.cav = ligne_cont.cav );
		DELETE contrat
			WHERE NOT EXISTS (SELECT 1 FROM ligne_cont
					WHERE contrat.numcont = ligne_cont.numcont
	  				AND contrat.soccont = ligne_cont.soccont
	  				AND contrat.cav = ligne_cont.cav );

		l_compteur := SQL%ROWCOUNT;
		COMMIT;
		PACK_GLOBAL.WRITE_STRING(p_logfile, '      ' || TO_CHAR(l_compteur) || ' contrats archivees.');

		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));
		PACK_GLOBAL.WRITE_STRING(p_logfile, 'Fin de la procedure d''archivage des contrats pour la borne ' || TO_CHAR(p_borne, 'dd/mm/yyyy'));
	END copie_contrat;

	-----------------------------------------------------
	--  Tables CONS_SSTACHE_RES_MOIS et PROPLUS
	--  Archivage des lignes de CONS_SSTACHE_RES_MOIS attaches a des ressources sans situations
	--  Archive les lignes de CONS_SSTACHE_RES_MOIS dont la date a de plus de 5 Ans d'ancienneté
	--  Archivage des lignes de PROPLUS attaches a des ressources sans situations
	--  Archive les lignes de PROPLUS dont la date a de plus de 5 Ans d'ancienneté
	-----------------------------------------------------

	PROCEDURE copie_consomme(
		p_borne		IN DATE,
		p_logfile	IN utl_file.file_type
	) IS
		l_compteur	INTEGER;
	BEGIN
		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));
		PACK_GLOBAL.WRITE_STRING(p_logfile, 'Debut de la procedure d''archivage des consommes pour la borne ' || TO_CHAR(p_borne, 'dd/mm/yyyy'));

		PACK_GLOBAL.WRITE_STRING(p_logfile, '    - Archivage des cons_sstache_res_mois attaches a des ressources sans situations');
		INSERT INTO BIPA.archive_cons_sstache_res_mois(CDEB, CDUR, CUSAG, CHRAF, CHINIT, PID, ECET, ACTA, ACST, IDENT)
			SELECT CDEB, CDUR, CUSAG, CHRAF, CHINIT, PID, ECET, ACTA, ACST, IDENT
			FROM cons_sstache_res_mois
			WHERE NOT EXISTS (SELECT 1 FROM situ_ress
					WHERE cons_sstache_res_mois.ident =  situ_ress.ident);

		DELETE cons_sstache_res_mois
			WHERE NOT EXISTS (SELECT 1 FROM situ_ress
					WHERE cons_sstache_res_mois.ident =  situ_ress.ident);
		l_compteur := SQL%ROWCOUNT;
		COMMIT;
		PACK_GLOBAL.WRITE_STRING(p_logfile, '      ' || TO_CHAR(l_compteur) || ' CONS_SSTACHE_RES_MOIS archives.');

		PACK_GLOBAL.WRITE_STRING(p_logfile, '    - Archivage des cons_sstache_res_mois pour la borne ' || TO_CHAR(p_borne, 'dd/mm/yyyy'));
		INSERT INTO BIPA.archive_cons_sstache_res_mois(CDEB, CDUR, CUSAG, CHRAF, CHINIT, PID, ECET, ACTA, ACST, IDENT)
			SELECT CDEB, CDUR, CUSAG, CHRAF, CHINIT, PID, ECET, ACTA, ACST, IDENT
			FROM cons_sstache_res_mois
			WHERE cdeb<p_borne;

		DELETE cons_sstache_res_mois
			WHERE cdeb<p_borne;
		l_compteur := SQL%ROWCOUNT;
		COMMIT;
		PACK_GLOBAL.WRITE_STRING(p_logfile, '      ' || TO_CHAR(l_compteur) || ' CONS_SSTACHE_RES_MOIS archives.');

		PACK_GLOBAL.WRITE_STRING(p_logfile, '    - Archivage des PROPLUS attaches a des ressources sans situations');
		INSERT INTO BIPA.archive_proplus(FACTPID, PID, AIST, AISTTY, TIRES, CDEB, PTYPE, FACTPTY, PNOM, FACTPNO, PDSG, FACTPDSG
						, PCPI, FACTPCP, PCMOUVRA, FACTPCM, PNMOUVRA, PDATDEBPRE, CUSAG, RNOM, RPRENOM
						, DATDEP, DIVSECGROU, CPIDENT, COUT, MATRICULE, SOCIETE, QUALIF, DISPO, CHINIT, CHRAF, RTYPE)
			SELECT FACTPID, PID, AIST, AISTTY, TIRES, CDEB, PTYPE, FACTPTY, PNOM, FACTPNO, PDSG, FACTPDSG
						, PCPI, FACTPCP, PCMOUVRA, FACTPCM, PNMOUVRA, PDATDEBPRE, CUSAG, RNOM, RPRENOM
						, DATDEP, DIVSECGROU, CPIDENT, COUT, MATRICULE, SOCIETE, QUALIF, DISPO, CHINIT, CHRAF, RTYPE
			FROM proplus
			WHERE NOT EXISTS (SELECT 1 FROM situ_ress
					WHERE proplus.tires =  situ_ress.ident);
		DELETE proplus
			WHERE NOT EXISTS (SELECT 1 FROM situ_ress
					WHERE proplus.tires =  situ_ress.ident);

		l_compteur := SQL%ROWCOUNT;
		COMMIT;
		PACK_GLOBAL.WRITE_STRING(p_logfile, '      ' || TO_CHAR(l_compteur) || ' PROPLUS archives.');

		PACK_GLOBAL.WRITE_STRING(p_logfile, '    - Archivage des PROPLUS pour la borne ' || TO_CHAR(p_borne, 'dd/mm/yyyy'));
		INSERT INTO BIPA.archive_proplus(FACTPID, PID, AIST, AISTTY, TIRES, CDEB, PTYPE, FACTPTY, PNOM, FACTPNO, PDSG, FACTPDSG
						, PCPI, FACTPCP, PCMOUVRA, FACTPCM, PNMOUVRA, PDATDEBPRE, CUSAG, RNOM, RPRENOM
						, DATDEP, DIVSECGROU, CPIDENT, COUT, MATRICULE, SOCIETE, QUALIF, DISPO, CHINIT, CHRAF, RTYPE)
			SELECT FACTPID, PID, AIST, AISTTY, TIRES, CDEB, PTYPE, FACTPTY, PNOM, FACTPNO, PDSG, FACTPDSG
						, PCPI, FACTPCP, PCMOUVRA, FACTPCM, PNMOUVRA, PDATDEBPRE, CUSAG, RNOM, RPRENOM
						, DATDEP, DIVSECGROU, CPIDENT, COUT, MATRICULE, SOCIETE, QUALIF, DISPO, CHINIT, CHRAF, RTYPE
			FROM proplus
			WHERE cdeb<p_borne;

		DELETE proplus
			WHERE cdeb<p_borne;
		l_compteur := SQL%ROWCOUNT;
		COMMIT;
		PACK_GLOBAL.WRITE_STRING(p_logfile, '      ' || TO_CHAR(l_compteur) || ' PROPLUS archives.');



		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));
		PACK_GLOBAL.WRITE_STRING(p_logfile, 'Fin de la procedure d''archivage des consommes pour la borne ' || TO_CHAR(p_borne, 'dd/mm/yyyy'));
	END copie_consomme;

	-----------------------------------------------------
	--  Tables CONS_SSTACHE_RES et RESSOURCE
	--  Archivage des lignes de CONS_SSTACHE_RES attachées a des ressources sans situations
	--       et qui n'ont pas de lignes factures, lignes contrats ni cons_sstaches_res_mois
	--  Archivage des lignes de RESSOURCES sans situations
	--       et qui n'ont pas de lignes factures, lignes contrats ni cons_sstaches_res_mois
	-----------------------------------------------------


	PROCEDURE copie_ressource(
		p_logfile	IN utl_file.file_type
	) IS
		l_compteur	INTEGER;
	BEGIN
		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));
		PACK_GLOBAL.WRITE_STRING(p_logfile, 'Debut de la procedure d''archivage des ressources');

		PACK_GLOBAL.WRITE_STRING(p_logfile, '    - Archivage des CONS_SSTACHE_RES pour les ressources qui n''ont pas de lignes fatures, lignes contrats ni cons_sstaches_res_mois (toutes ont ete archivees)');
		INSERT INTO BIPA.archive_cons_sstache_res(TPLAN, TACTU, TEST, PID, ECET, ACTA, ACST, IDENT)
			SELECT TPLAN, TACTU, TEST, PID, ECET, ACTA, ACST, IDENT
			FROM cons_sstache_res
			WHERE ident IN
				(SELECT ident FROM ressource
					WHERE NOT EXISTS (SELECT 1 FROM situ_ress WHERE situ_ress.ident=ressource.ident)
						AND NOT EXISTS (SELECT 1 FROM cons_sstache_res_mois WHERE cons_sstache_res_mois.ident=ressource.ident)
						AND NOT EXISTS (SELECT 1 FROM ligne_cont WHERE ligne_cont.ident=ressource.ident)
						AND NOT EXISTS (SELECT 1 FROM ligne_fact WHERE ligne_fact.ident=ressource.ident)
				);
		DELETE cons_sstache_res
			WHERE ident IN
				(SELECT ident FROM ressource
					WHERE NOT EXISTS (SELECT 1 FROM situ_ress WHERE situ_ress.ident=ressource.ident)
						AND NOT EXISTS (SELECT 1 FROM cons_sstache_res_mois WHERE cons_sstache_res_mois.ident=ressource.ident)
						AND NOT EXISTS (SELECT 1 FROM ligne_cont WHERE ligne_cont.ident=ressource.ident)
						AND NOT EXISTS (SELECT 1 FROM ligne_fact WHERE ligne_fact.ident=ressource.ident)
				);
		l_compteur := SQL%ROWCOUNT;
		COMMIT;
		PACK_GLOBAL.WRITE_STRING(p_logfile, '      ' || TO_CHAR(l_compteur) || ' CONS_SSTACHE_RES archives.');

		PACK_GLOBAL.WRITE_STRING(p_logfile, '    - Archivage des ressources qui n''ont pas de lignes fatures, lignes contrats ni cons_sstaches_res_mois (toutes ont ete archivees)');
		INSERT INTO BIPA.archive_ressource(IDENT, RNOM, RPRENOM, MATRICULE, COUTOT, RTEL, BATIMENT, ETAGE, BUREAU, FLAGLOCK, RTYPE, ICODIMM, IGG)
			SELECT IDENT, RNOM, RPRENOM, MATRICULE, COUTOT, RTEL, BATIMENT, ETAGE, BUREAU, FLAGLOCK, RTYPE, ICODIMM, IGG
			FROM ressource
			WHERE NOT EXISTS (SELECT 1 FROM situ_ress WHERE situ_ress.ident=ressource.ident)
				AND NOT EXISTS (SELECT 1 FROM cons_sstache_res_mois WHERE cons_sstache_res_mois.ident=ressource.ident)
				AND NOT EXISTS (SELECT 1 FROM ligne_cont WHERE ligne_cont.ident=ressource.ident)
				AND NOT EXISTS (SELECT 1 FROM ligne_fact WHERE ligne_fact.ident=ressource.ident);

		DELETE ressource
			WHERE NOT EXISTS (SELECT 1 FROM situ_ress WHERE situ_ress.ident=ressource.ident)
				AND NOT EXISTS (SELECT 1 FROM cons_sstache_res_mois WHERE cons_sstache_res_mois.ident=ressource.ident)
				AND NOT EXISTS (SELECT 1 FROM ligne_cont WHERE ligne_cont.ident=ressource.ident)
				AND NOT EXISTS (SELECT 1 FROM ligne_fact WHERE ligne_fact.ident=ressource.ident);
		l_compteur := SQL%ROWCOUNT;
		COMMIT;
		PACK_GLOBAL.WRITE_STRING(p_logfile, '      ' || TO_CHAR(l_compteur) || ' ressources archivees.');

		PACK_GLOBAL.WRITE_STRING(p_logfile, 'Fin de la procedure d''archivage des ressources');
		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));
	END copie_ressource;

	-----------------------------------------------------
	-- Restaure les situations qui ont été archivées à tort car elles concernent
	-- une ressource qui n'a pas été archivée car il reste un contrat ou une facture
	-- la concernant
	-----------------------------------------------------

	PROCEDURE restaure_situation(
			p_logfile	IN utl_file.file_type
	) IS
		l_compteur	INTEGER;
	BEGIN
		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));
		PACK_GLOBAL.WRITE_STRING(p_logfile, 'Debut de la procedure de restauration des situations ');

		UPDATE BIPA.archive_situ_ress
			SET MARSG2 = 'O'
		WHERE 	EXISTS (SELECT 1 FROM ressource WHERE archive_situ_ress.ident=ressource.ident)
			AND NOT EXISTS (SELECT 1 FROM situ_ress WHERE archive_situ_ress.ident=situ_ress.ident)
			AND DATDEP = ( SELECT MAX(a.DATDEP) FROM BIPA.archive_situ_ress a WHERE a.ident = archive_situ_ress.ident ) ;

		INSERT INTO situ_ress(DATSITU, DATDEP, CPIDENT, COUT, DISPO, MARSG2, RMCOMP, PRESTATION
						, DPREST, IDENT, SOCCODE, CODSG, NIVEAU, MONTANT_MENSUEL,FIDENT)
			SELECT DATSITU, DATDEP, CPIDENT, COUT, DISPO, '' , RMCOMP, PRESTATION
						, DPREST, IDENT, SOCCODE, CODSG, NIVEAU, MONTANT_MENSUEL,FIDENT
			FROM BIPA.archive_situ_ress
			WHERE MARSG2 = 'O' ;

		DELETE BIPA.archive_situ_ress
			WHERE MARSG2 = 'O' ;

		l_compteur := SQL%ROWCOUNT;
		COMMIT;
		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(l_compteur) || ' situations restaurées.');


		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));
		PACK_GLOBAL.WRITE_STRING(p_logfile, 'Fin de la procedure de restauration des situations ');
	END restaure_situation;

	-----------------------------------------------------
	-- Mise à jours des chefs de projet de lignes BIP qui ont ete archives
	-- Fait pointer les lignes bip et les ressources rattachées sur la ressource 17351 : RESS_REGROUPEMENT
	-----------------------------------------------------

	PROCEDURE change_chef_projet(
		p_logfile	IN utl_file.file_type
	) IS
		l_compteur	INTEGER;
	BEGIN
		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));
		PACK_GLOBAL.WRITE_STRING(p_logfile, 'Debut de la procedure de modifications des chefs de projet pour les ressources archivees');

		PACK_GLOBAL.WRITE_STRING(p_logfile, '    - Mise à jours des chefs de projet de lignes BIP qui ont ete archives');
		UPDATE ligne_bip
			SET pcpi=17351
			WHERE NOT EXISTS (SELECT 1 FROM ressource WHERE ligne_bip.pcpi=ressource.ident);
		l_compteur := SQL%ROWCOUNT;
		COMMIT;
		PACK_GLOBAL.WRITE_STRING(p_logfile, '      ' || TO_CHAR(l_compteur) || ' chefs de projet de lignes BIP mis a jour.');

		PACK_GLOBAL.WRITE_STRING(p_logfile, '    - Mise à jours des chefs de projet de ressources qui ont ete archives');
		UPDATE situ_ress
			SET cpident=17351
			WHERE NOT EXISTS (SELECT 1 FROM ressource WHERE situ_ress.cpident=ressource.ident);
		l_compteur := SQL%ROWCOUNT;
		COMMIT;
		PACK_GLOBAL.WRITE_STRING(p_logfile, '      ' || TO_CHAR(l_compteur) || ' chefs de projet de ressources mis a jour.');

		PACK_GLOBAL.WRITE_STRING(p_logfile, 'Fin de la procedure de modifications des chefs de projet pour les ressources archivees');
		PACK_GLOBAL.WRITE_STRING(p_logfile, TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'));
	END change_chef_projet;



END pack_archive_ressources;
/


