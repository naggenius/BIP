-- -----------------------
-- Application REFONTE BIP
-- Package BATCH
-- -----------------------

-- ---------------------------------------
-- Qui    Quand    Quoi
-- ---------------------------------------
-- M.LECLERC  01/02/1999   Lot 1
-- MOUTON 22/10/1999   Modification dans
--                p_proplus pour ne pas prendre en compte les 
--                ressources ident=0 dans proplus
--                et les ressource sans situations valides
-- MOUTON 03/02/2000 Modification dans
--                TRAITEMENT DES DATES DE TRANSFERTS ET DE TRAITEMENTS PMW-BIP
--                TTRMENS est mise à jour à partir de la données contenu dans
--                la colonne DERTRAIT de la table DATDEBEX (et non à partir de la 
--                date systeme)
-- MOUTON 04/04/2000 Modification dans P_PROPLUS, insertion dans proplus
--                on insert les ressources 2222 avec une date de situation 01/01/1986  
-- QHL    04/07/2000 PRMOMOIM2 : pb de maj de CODE_DEVIS.PCSCONSN1 du a 
--                une addition entre un zone nul avec une valeur = nul (et non pas valeur)
--     
-- NCM    26/07/2000 Table SSTRT: ajout des ressources en sous-traitance sur des lignes bip inexistantes
--
-- ODU    07/02/2002 Suppression dans REPTEST du code destine a filtrer le consomme sur les lignes BIP
--                   dont le statut est Demarre ou Abandonne.
--                   Ajout de l'appel a la procedure de purge de CONS_SSTACHE_RES_MOIS pour rejeter le
--                   consomme sur les lignes Abandonnee ou Demarree, ainsi que sur les lignes Fermee
--                   et le consomme par anticipation
--
-- ODU    07/02/2002 Remplacement du code de mise a jour des donnees situation ressources dans PROPLUS
--                   On n'utilise plus la table temporaire, mais SITU_RESS_FULL
--
-- ODU    04/04/2002 Remplacement de la procedure de chargement du consomme
--                   On ne travaille plus ligne par ligne, mais on traite tout en bloc.
--                   Avant on commence par filtrer les fichiers avec un mauvais numero de version
--                   et on corrige les identifiants de ressources ******
-- PJO	  28/01/2004 Suppression des tables ANNEE_DEVIS et CODE_DEVIS	
-- MMC    19/04/2004 Modif code Bip sur 4 caractères
-- OTO	  16/07/2004 Ajout des procédures pour blocage du consommé sur ligne A, D ou C
-- PPR    04/10/2005 Teste le cas ou on insere deux fois le même enregistrement dans la procédure copie_datestatut
-- PPR    26/06/2006 Ajoute un ROWNUM=1 dans la mise à jour de P_SAISIE dans ligne_bip
-- PPR    04/07/2006 Enleve la référence à la table JFERIE
-- SEL	  01/09/2014 PPM 58986 : mettre le consomme de decembre a 0 pour les lignes BIP lors de la mensuelle de Janvier.

-- ---------------------------------------------------------
-- A FAIRE : SEULS LES POINTS D'ENTREE DEPUIS SHELL SQL*PLUS
-- SONT NECESSAIRES DANS LA SPEC DU PACKAGE.
-- ---------------------------------------------------------
CREATE OR REPLACE package PACKBATCH as

	-- Utilitaire : calcul du mois et de l'année de traitement
	-- en cours, non pas d'après la date système, mais d'après
	-- la date de la prochaine mensuelle
	-- -------------------------------------------------------
	procedure CALCDATTRT( P_HFILE in utl_file.file_type,
	                      P_MOISTRT out number,
	                      P_ANTRT   out number );

	-- Utilitaire : calcul de la date de début d'exercice
	-- --------------------------------------------------
	procedure CALCDATDBX( P_HFILE in utl_file.file_type,
	                      P_DATDBX out date );

	-- procedure controle consomm
	-- permet de controler les tables pmw_...
	PROCEDURE controle_consomme(P_HFILE IN utl_file.file_type);
 

	-- Première prémensuelle : PROMOIM1 et PROMOIM2
	-- Calcul de dates et passage de données N en
	-- données N-1
	-- --------------------------------------------
	procedure ST54700B( P_LOGDIR in varchar2 );
		procedure PROMOIM1( P_HFILE in utl_file.file_type );
		procedure PROMOIM2( P_HFILE in utl_file.file_type );

	-- Les deux prémensuelles et la mensuelle : prise
	-- en compte des données PMW chargées par SQL*LOAD
	-- dans les tables PMW_*
	-- -----------------------------------------------
	procedure ST54700E( P_LOGDIR in varchar2 );

		-- ----------------------------------------
		-- Test pour savoir si une consommation PMW
		-- doit générer une anomalie
		-- ----------------------------------------
		function TESTANO( P_ASTATUT in char, P_ADATESTATUT in date, P_CDEB in date,
		                  P_CHTYP in char )
		         return number;

		-- la fonction  utilise des variables globales
		-- donc pas de RNPS
		-- (ceci dit, la notion de "packaged variable"
		-- n'est pas claire, pour le moins)
		-- -------------------------------------------
		pragma restrict_references( TESTANO, WNDS, WNPS, RNDS );


		function REPTEST( CHTYP in char,
		                  TOTALCHINIT in number,
		                  TOTALCHRAF in number,
		                  CDEB in date,
		                  MUST_ACCEPT_TYPE_2 in char )
		         return char;
		pragma restrict_references( REPTEST, WNDS, WNPS );

		-- Prise en compte entete, etape,
		-- tache/sous-tache et affectations
		-- --------------------------------
		procedure RPETA( P_HFILE in utl_file.file_type );

		-- Prise en compte charges initiales et Reste A Faire
		-- Segments J0 et J2
		-- --------------------------------------------------
		procedure RPINIT_AND_RPRAF( P_HFILE in utl_file.file_type );

		-- Recalcul des dates au niveau etape pour toutes
		-- les etapes de tous les projets presents en PMW
		-- ----------------------------------------------
		procedure RPDATE( P_HFILE in utl_file.file_type );

		-- Remplit la table des anomalies de
		-- sous-traitances
		-- -------------------------------------------
		procedure RPSSTRT( P_HFILE in utl_file.file_type );

		-- Regénération des données de PROPLUS
		-- -------------------------------------------
		procedure P_PROPLUS( P_HFILE utl_file.file_type );

-- Fonction qui permet d'utiliser le truncate dans un bloc pl/sql
	procedure DYNA_TRUNCATE( TABLENAME IN VARCHAR2 );

-- Fonction qui permet d'utiliser le drop index dans un bloc pl/sql
	procedure DYNA_DROP_IND( INDEXNAME IN VARCHAR2 );

-- Fonction qui permet de creer un index dans un blocpl/sql
	procedure DYNA_CREATE_IND( TABLENAME IN VARCHAR2,
                                 INDEXNAME IN VARCHAR2,
                                 COLNAME IN VARCHAR2,
                                           MODETRI IN VARCHAR2,
                                 STORAGE_CLAUSE IN VARCHAR2 DEFAULT NULL);

-- ##################################################################################################
--	Purge TABLE Rejet en fonction de la DATE de statut
-- ##################################################################################################
	PROCEDURE purge_rejet_datestatut( P_HFILE utl_file.file_type ) ;

-- ##################################################################################################
--	Rejet en fonction de la DATE de statut
-- ##################################################################################################
	PROCEDURE rejet_datestatut( P_HFILE utl_file.file_type ) ;

-- ##################################################################################################
--	Copie des donnees rejetees par rejet_datestatut pour les lignes avec sous traitance
-- ##################################################################################################
	PROCEDURE copie_datestatut( P_HFILE utl_file.file_type ) ;

end PACKBATCH;
/


CREATE OR REPLACE package body     PACKBATCH as

	-- Gestions exceptions
	-- -------------------
	CALLEE_FAILED exception;
	pragma exception_init( CALLEE_FAILED, -20000 );
	CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
	TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !
	ERR_FONCTIONNELLE_ID number := -20002;   -- pour provoquer erreur alors que Oracle OK
	CONSTRAINT_VIOLATION exception;          -- pour clause when
	pragma exception_init( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère
	INDEX_PK_VIOLATION exception;          -- pour clause when
	pragma exception_init( INDEX_PK_VIOLATION, -1 ); -- On essaie d'insérer deux fois le même enreg

	-- Dates Globales pour utilisation dans fonctions
	-- appelées en SQL. Oracle Corp. N'est PAS
	-- composée de Dieux vivants. PL/SQL a été codé
	-- par des gens normaux. Il y a des bugs.
	-- C'est pas (trés) grave, on contourne.
	-- ----------------------------------------------
	G_DAT0101AN date;            -- le 01/01 de l'année de l'exercice
	G_DAT0101ANM1 date;          -- le 01/01 de l'année d'avant celle de l'exercice

	-- ------------------------------------------------
	-- Copier/Coller/Modifier de l'exemple 'drop_table'
	-- de la documentation en ligne de PL/SQL dans
	-- Interaction with Oracle : using DLL and
	-- dynamic SQL
	-- ------------------------------------------------
	procedure DYNA_TRUNCATE( TABLENAME IN VARCHAR2 ) is

		CID integer;

	begin

		-- Open new cursor and return cursor ID.
		-- -------------------------------------
		CID := DBMS_SQL.OPEN_CURSOR;
		-- Parse and immediately execute dynamic SQL statement built by
		-- concatenating table name to command.
		-- ------------------------------------------------------------
		DBMS_SQL.PARSE( CID, 'TRUNCATE TABLE ' || TABLENAME, dbms_sql.v7 );
		-- Close cursor.
		-- -------------
		DBMS_SQL.CLOSE_CURSOR( CID );

	exception

		-- If an exception is raised, close cursor before exiting.
		-- -------------------------------------------------------
		-- note de manuel L : Et si l'exception a lieu pendant le
		-- open ou le close ?
		-- (supposons que LEUR code EST correct)
		-- -------------------------------------------------------
		when others then
			DBMS_SQL.CLOSE_CURSOR( CID );
		      raise;  -- reraise the exception

	end DYNA_TRUNCATE;


      -- CREATE INDEX indexname ON tablename (colname modetri) TABLESPACE IDX
	-- : réalisé par DBT (Denis Blanc-Tranchant) le 29091999


	procedure DYNA_CREATE_IND( TABLENAME IN VARCHAR2,
                                 INDEXNAME IN VARCHAR2,
                                 COLNAME IN VARCHAR2,
					   MODETRI IN VARCHAR2,
				 STORAGE_CLAUSE IN VARCHAR2 DEFAULT NULL) is


		CID integer;
		l_SQL	VARCHAR2(2000);

	begin
		l_SQL := 'CREATE INDEX ' || INDEXNAME || ' ON ' || TABLENAME || ' (' || COLNAME || ' ' || MODETRI || ' ) ';
		IF (STORAGE_CLAUSE IS NOT NULL) THEN
			l_SQL := l_SQL || ' STORAGE ( ' || STORAGE_CLAUSE || ' )';
		END IF;

		-- Open new cursor and return cursor ID.
		-- -------------------------------------
		CID := DBMS_SQL.OPEN_CURSOR;
		-- Parse and immediately execute dynamic SQL statement built by
		-- concatenating table name to command.
		-- ------------------------------------------------------------
		DBMS_SQL.PARSE( CID, l_SQL, dbms_sql.v7 );

		-- Close cursor.
		-- -------------
		DBMS_SQL.CLOSE_CURSOR( CID );

	exception

		-- If an exception is raised, close cursor before exiting.
		-- -------------------------------------------------------
		-- note de manuel L : Et si l'exception a lieu pendant le
		-- open ou le close ?
		-- (supposons que LEUR code EST correct)
		-- -------------------------------------------------------
		when others then
			DBMS_SQL.CLOSE_CURSOR( CID );
		      raise;  -- reraise the exception

	end DYNA_CREATE_IND;



      -- DROP INDEX indexname : réalisé par DBT (Denis Blanc-Tranchant) le 29091999

	procedure DYNA_DROP_IND( INDEXNAME IN VARCHAR2 ) is

		CID integer;

	begin

		-- Open new cursor and return cursor ID.
		-- -------------------------------------
		CID := DBMS_SQL.OPEN_CURSOR;
		-- Parse and immediately execute dynamic SQL statement built by
		-- concatenating table name to command.
		-- ------------------------------------------------------------
		DBMS_SQL.PARSE( CID, 'DROP INDEX ' || INDEXNAME,dbms_sql.v7 );

		-- Close cursor.
		-- -------------
		DBMS_SQL.CLOSE_CURSOR( CID );

	exception

		-- If an exception is raised, close cursor before exiting.
		-- -------------------------------------------------------
		-- note de manuel L : Et si l'exception a lieu pendant le
		-- open ou le close ?
		-- (supposons que LEUR code EST correct)
		-- -------------------------------------------------------
		when others then
			DBMS_SQL.CLOSE_CURSOR( CID );
			IF SQLCODE=-1418 THEN		-- index inexistant : on s'en fout et on continue
				NULL;
			ELSE
				RAISE;
			END IF;
	end DYNA_DROP_IND;

	-- Procedure CONTROLE_CONSOMM : procedure de controle des donnees dans les tables
	-- PMW_CONSOMM, PMW_LIGNE_BIP ....
	-- Suppression des consommes antérieurs a la date d'exercice

	PROCEDURE controle_consomme (P_HFILE IN utl_file.file_type) IS

	L_PROCNAME VARCHAR2(20) := 'controle_consomme';
	ANNEE date;


	BEGIN

	TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

	SELECT datdebex INTO ANNEE
	FROM datdebex;

	TRCLOG.TRCLOG( P_HFILE, 'Début d exercice : ' || ANNEE);
	TRCLOG.TRCLOG( P_HFILE, 'Suppression des consommes antérieur au : ' || ANNEE);

	DELETE PMW_CONSOMM
	WHERE cdeb<ANNEE;

	IF SQL%ROWCOUNT = 0 THEN
		TRCLOG.TRCLOG( P_HFILE, 'Pas de consommes antérieurs à l exercice');
	ELSE
		TRCLOG.TRCLOG( P_HFILE, 'Nombre de lignes supprimées : '|| SQL%ROWCOUNT);
	END IF;

	COMMIT;

	TRCLOG.TRCLOG( P_HFILE, 'Fin de la procedure :'||L_PROCNAME);

	EXCEPTION

	WHEN OTHERS THEN
		TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || SQLERRM );
		raise CALLEE_FAILED;

	END controle_consomme;

	-- -----------------------------------------
	-- CALCDATTRT : on calcule le numero du mois
	-- de traitement a partir de la date de la
	-- prochaine mensuelle, qu'on trouve dans
	-- la table DATDEBEX. Le mois de traitement
	-- courant est le mois precedent.
	-- La table DATDEBEX est mis a jour en fin
	-- de mensuelle a l'aide de la table
	-- calendrier et de la date systeme.
	-- -----------------------------------------
	procedure CALCDATTRT( P_HFILE in utl_file.file_type,
	                      P_MOISTRT out number,
	                      P_ANTRT   out number ) is

		L_DATTRT date;
		L_PROCNAME varchar2( 16 ) := 'CALCDATTRT';

	begin

		-- Recherche de la date de la
		-- ===> PROCHAINE <=== mensuelle
		-- et renvoi du mois, annee du mois
		-- d'avant
		-- ----------------------------------
		--PPM 58896 : utilisation directe du datemens sans soustraire 1 mois.
		select CMENSUELLE
		into L_DATTRT
		from DATDEBEX;
		P_MOISTRT := to_char( L_DATTRT, 'MM' );
		P_ANTRT   := to_char( L_DATTRT, 'YYYY' );

	exception

		when others then
			TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || SQLERRM );
			raise CALLEE_FAILED;

	end CALCDATTRT;

	-- -----------------------------------------
	-- CALCDATDBX : on rend simplement la date
	-- de debut d'exercice qu'on trouve dans la
	-- table DATDEBEX.
	-- -----------------------------------------
	procedure CALCDATDBX( P_HFILE in utl_file.file_type,
	                      P_DATDBX out date ) is

		L_PROCNAME varchar2( 16 ) := 'CALCDATDBX';

	begin

		select DATDEBEX
		into P_DATDBX
		from DATDEBEX;

	exception

		when others then
			TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' : ' || SQLERRM );
			raise CALLEE_FAILED;

	end CALCDATDBX;

	-- -----------------------------------------
	-- PROMOIM1 : certaines donnees N deviennent
	-- des donnees N-1. De LIGNE_BIP vers
	-- LIGNE_BIP et de BUDCONS vers LIGNE_BIP
	-- Mise a jour des j/h N-1 pour Fact. Int.
	-- ancien systeme
	-- -----------------------------------------
	procedure PROMOIM1( P_HFILE in  utl_file.file_type ) is

		L_MOISTRT number;
		L_ANTRT number;
		L_PROCNAME varchar2(16) := 'PROMOIM1';
		L_STATEMENT varchar2(100);

	begin

		-- Trace Start
		-- -----------
		TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

		L_STATEMENT := 'Recherche mois de traitement';
		CALCDATTRT( P_HFILE, L_MOISTRT, L_ANTRT );
		TRCLOG.TRCLOG( P_HFILE, 'Traitement au titre du mois ' ||
		               L_MOISTRT || ' de ' || L_ANTRT );

		-- ---------------------------------------------------------------
		-- Part One : dates et type projet. En TSO-FOCUS il s'agissait de
		-- mettre a jour les colonnes "N-1" de PROJ a l'aide des colonnes
		-- "N" de PROJ2. PROJ2 étant a ce moment la "photo" de la base à
		-- la fin des traitements du mois precedant. Dans le nouveau
		-- système, on utilise une "copie" de LIGNE_BIP et de ETAPE pour
		-- accéder à "proj2". Veuillez relire le document d'architecture
		-- technique et adresser toutes remarques à B.B.
		-- ---------------------------------------------------------------
		-- TVA????    : calculer, pour chaque ligne BIP, les valeurs "N-1"
		-- des 3 dates de fin revisees des fins d'etapes de type "EP",
		-- "ED" et "AP" (s'il y a plusieurs étapes d'un meme type, c'est
		-- la plus grande qui compte car la memorisation "N-1" est au
		-- niveau "ligne bip" et non pas au niveau "etape". Resumé : pour
		-- une ligne et un type, on prend la plus grande date N et elle
		-- devient la date N-1
		-- ---------------------------------------------------------------
		-- Le code "TSO-FOCUS" mouvementait egalement le "centre activité
		-- gestionnaire du produit" de N vers N-1 mais cette donnée n'est
		-- plus dans le modèle.
		-- ---------------------------------------------------------------
		-- Remarque : dans le code FOCUS le join entre proj2 et proj était
		-- codé de telle sorte qu'un nouveau projet (présent dans proj et
		-- pas dans proj2) ne subissait aucune mise a jour
		-- ---------------------------------------------------------------
		-- La "table" proj2 est représenté dans le nouveau systeme par les
		-- tables LIGNE_BIP2 et ETAPE2.
		-- Attention : sous focus, le jour des TVA??? n'était pas stocké
		-- On reproduit
		-- ---------------------------------------------------------------
		L_STATEMENT := 'Update de LIGNE_BIP avec LIGNE_BIP2 - Dates prévues, type projet';
		update LIGNE_BIP PROJ
		set ( TDATFHN,     -- date prevue fin homo. N-1
		      PTYPEN1 ) =  -- type de projet N-1
		( select
		    TDATFHP,     -- date prevue fin homo.
		    TYPPROJ      -- type de projet
		  from LIGNE_BIP2 PROJ2
		  where PROJ.PID = PROJ2.PID ),
		TVAEDN = ( select trunc( max( ENFI ), 'month' ) from
		           ETAPE2 PROJ2 where
		           PROJ.PID = PROJ2.PID and
		           PROJ2.TYPETAP = 'ED' );
		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows updated' );

		-- ---------------------------------------------------------------
		-- Part Two : consommation en j/h ancien systeme (le nouveau
		-- systeme est pris en charge par PROMOIM2)
		-- ---------------------------------------------------------------
    --SEL 26/09/2014 PPM 58986
		-- PCONSN1 NE DOIT PAS contenir a la fin de la premensuelle le cumul des
		-- j/h depuis decembre A-1 (inclu) jusqu'au mois (inclu) de la






		-- mensuelle precedente.
    -- On remet PCONSN1 à 0 en Janvier et à partir de la mensuelle de Janvier
    -- le cumul ne sera calculé qu'à la base de l'année en cours.
		-- ---------------------------------------------------------------
		-- Remarque : dans le code FOCUS le join entre proj et budcons
		-- etait code de telle sorte qu'un nouveau projet (present dans
		-- proj et pas dans budcons) ne subissait aucune mise a jour
		-- ---------------------------------------------------------------
		L_STATEMENT := 'Update LIGNE_BIP avec Cumul consommé à la dernière mensuelle';
		IF L_MOISTRT = 1 then
			update LIGNE_BIP
    --SEL PPM 58986 : mettre le consomme de decembre a 0
       set PCONSN1 = 0;
			--set PCONSN1 = PDECN1;
		else
      --SEL PPM 58986 : ne plus ramener le consomme de decembre
			update LIGNE_BIP lb                  -- qhl : 4/7/00 ajout test nvl
			set lb.PCONSN1 = (select NVL(c.CUSAG,0) FROM
			                consomme c
					WHERE lb.pid=c.pid
					AND c.annee=L_ANTRT);
		end if;
		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows updated' );

			-- Trace Stop
			-- ----------
			TRCLOG.TRCLOG( P_HFILE, 'Fin de ' || L_PROCNAME );

	exception

		when others then
			if sqlcode <> CALLEE_FAILED_ID then
				TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [' || L_STATEMENT ||
				               '] : ' || SQLERRM );
			end if;
			TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
			raise CALLEE_FAILED;

	end PROMOIM1;

	-- ----------------------------------------------------------
	-- PROMOIM2 : certaines donnees N deviennent des donnees N-1.
	-- De LIGNE_BIP vers LIGNE_BIP et de BUDCONS vers LIGNE_BIP
	-- Mise a jour des j/h N-1 pour Fact. Int. nouveau systeme
	-- ----------------------------------------------------------
	procedure PROMOIM2( P_HFILE in  utl_file.file_type ) is

		L_MOISTRT number;
		L_ANTRT number;
		L_PROCNAME varchar2(16) := 'PROMOIM2';
		L_STATEMENT varchar2(100);

	begin


		-- Trace Start
		-- -----------
		TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

		L_STATEMENT := 'Recherche mois de traitement';
		CALCDATTRT( P_HFILE, L_MOISTRT, L_ANTRT );
		TRCLOG.TRCLOG( P_HFILE, 'Traitement au titre du mois ' ||
		               L_MOISTRT || ' de ' || L_ANTRT );

		-- ----------------------------------------------------------
		-- Part One : client maitrise ouvrage et le flag qui signale
		-- qu'aucun changement n'a eu lieu
		-- ----------------------------------------------------------
		-- CI-DESSOUS : Commentaires lus dans source
		-- FOCUS PROMOIM2
		--*----------------------------------------------------------
		--* F.I.
		--* S'IL Y A EU CHANGEMENT DE CA DEPUIS LE MOIS - 1, C'EST-A-DIRE :
		--* SI LE CA TRAITE LE MOIS DERNIER EST DIFFERENT DU CA A IMPUTER CE MOIS
		--* ALORS ON GARDE LE STATUT PCACTOP POUR SAVOIR COMMENT IMPUTER LE
		--*       NOUVEAU CA (SI ANCIEN CA FERME : F, SI ANCIEN CA ERRONE : O)
		--* SINON ON RETABLIT LE TOP A OUVERT (O) POUR NE PAS TRAITER 2 FOIS UNE
		--*       FERMETURE DE CA (LE CA FERME EST DEJA REMPLACE PAR LE NOUVEAU)
		--*----------------------------------------------------------------------
		-- Autres commentaires trouves dans la description du segment PROJ FOCUS
		-- TOP (O:OUVERT,F:FERME) CAMO FACT.INT
		-- ----------------------------------------------------------------------
		-- Remarque : dans le code FOCUS le join entre proj2 et proj etait code
		-- de telle sorte qu'un nouveau projet (present dans proj et pas dans
		-- proj2) ne subissait aucune mise a jour
		-- ----------------------------------------------------------------------
		L_STATEMENT := 'Update LIGNE_BIP avec Ligne_BIP2 - PJCAMON1(CODCAMO),PCACTOP ';
		update LIGNE_BIP PROJ
		set ( PJCAMON1, PCACTOP ) =
		( select PROJ2.CODCAMO,  decode( PROJ.CODCAMO, PROJ2.CODCAMO, 'O',
		                                 PROJ.PCACTOP )
		  from LIGNE_BIP2 PROJ2 where PROJ.PID = PROJ2.PID );
		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows updated' );

		-- ---------------------------------------------------------------
		-- Part Two : consomation en j/h nouveau systeme
		-- ---------------------------------------------------------------
		-- Rappel de ce qui est fait en TSO
		--   1 - extraction PID, AN, CODE, DECN1 a partir de proj
		--   2 - extraction PID, AN, CODE, CUSJH a partir de budcons
		--   3 - appariement avec jointure externe des deux cotes à la
		--       fois (mode OLD-OR-NEW)
		--   4 - addition de DECN1 et CUSJH pour donner nouveau CONSN1
		--       (CUSJH pas additionne si on est en premensuelle de
		--       janvier)
		--   5 - update de proj (CONSN1) avec creation eventuelle de
		--       ligne a cause de triplet PID, AN, CODE en provenance de
		--       BUDCONS et qui ne seraient pas dans PROJ (cas normalement
		--       tres improbable mais traite ici en l'absence de
		--       certitude)
		-- Remarque : en focus, tout PID qui n'est QUE dans Budcons n'est
		--            PAS traite : les creations de ligne dans proj a
		--            partir de budcons concernent les triplets
		--           (pid, an, code)
		-- ---------------------------------------------------------------
		-- Mise a niveau de proj a l'aide de BudCons pour regler le
		-- probleme des donnees de budcons qui ne serait pas dans proj
		-- mais seulement pour les pids presents dans proj. Cette dernière
		-- restriction n'est pas codées en SQL : on part du principe que
		-- si on trouve quelque part un pid alors il est dans LIGNE_BIP
		-- (sinon, c'est que quelqu'un a fait sous lui, et c'est vraimant
		-- dégoutant)

	exception

		when others then
			if sqlcode <> CALLEE_FAILED_ID then
				TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [' || L_STATEMENT ||
				               '] : ' || SQLERRM );
			end if;
			TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
			raise CALLEE_FAILED;

	end PROMOIM2;

	-- -----------------------------------------
	-- ST54700B : PROMOI1 et PROMOI2
	-- -----------------------------------------
	procedure ST54700B( P_LOGDIR in varchar2 ) is

		L_HFILE utl_file.file_type;
		L_RETCOD number;

		L_PROCNAME varchar2(16) := 'ST54700B';

	begin

		-- Init de la trace
		-- ----------------
		L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
		if ( L_RETCOD <> 0 ) then
			raise_application_error( TRCLOG_FAILED_ID,
			                         'Erreur : Gestion du fichier LOG impossible',
			                         false );
		end if;

		-- Trace Start
		-- -----------
		TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );


		-- PROMOI1 et PROMOI2
		-- ------------------
		PROMOIM1( L_HFILE );
		PROMOIM2( L_HFILE );

		-- Trace Stop
		-- ----------
		TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
		TRCLOG.CLOSETRCLOG( L_HFILE );

	exception

		when others then
			rollback;
			if sqlcode <> CALLEE_FAILED_ID and
			   sqlcode <> TRCLOG_FAILED_ID then
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME || ' : ' || SQLERRM );
			end if;
			if sqlcode <> TRCLOG_FAILED_ID then
				TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				TRCLOG.CLOSETRCLOG( L_HFILE );
				raise_application_error( CALLEE_FAILED_ID,
				                         'Erreur : consulter le fichier LOG',
				                          false );
			else
				raise;
			end if;

	end ST54700B;

	-- -------------------------------------------------------------------
	--	PACKBATCH4.purge_rejet_datestatut vidage des tables des rejets pour lignes demarrée et DATE < moismens-1
	--	PACKBATCH4.rejet_datestatut suppression lignes demarrée et DATE < moismens-1
	--      RPETA   chargement entete, etapes, tache/sous-taches,
	--                    affectations
	--	PACKBATCH4.Purge_Rejet		vidage de la table des rejets
	--	PACKBATCH4.Rejet_Version_RBIP	suppression des fichiers de versions obsoletes
	--	PACKBATCH4.Rejet_Ressource	suppression des ressources inconnues
	--	PACKBATCH4.Rejet_Ligne_BIP	suppression des lignes bip inconnues
	--	PACKBATCH4.Copie_Consomme	chargement du consomme (segments J1)
	--	PACKBATCH4.copie_datestatut      copie données des lignes en sstrait. de statut demarre et DATE < moismens-1
	--  RPINIT_AND_RPRAF  chargement charges Init. et Reste A Faire
	--                    (segments J0 et J2)
	--            RPDATE  recalcul des dates Etapes
	--            RPSSTRT table des anomalies de sous-traitance
	--            P_PROPLUS Regénération des données "récentes" de PROPLUS
	-- -------------------------------------------------------------------
	procedure ST54700E( P_LOGDIR in varchar2 ) is

		L_HFILE utl_file.file_type;
		L_RETCOD number;
		L_PROCNAMESUIVI varchar2(16) := 'alimsuivijhr';
		L_PROCNAME varchar2(16) := 'ST54700E';

	begin

		-- Init de la trace
		-- ----------------
		L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
		if ( L_RETCOD <> 0 ) then
		raise_application_error( TRCLOG_FAILED_ID,
		                         'Erreur : Gestion du fichier LOG impossible',
		                         false );
		end if;

		-- Trace Start
		-- -----------
		TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );


		-- Toute la prise en compte de PMW
		-- -------------------------------
		CONTROLE_CONSOMME( L_HFILE );
		PACKBATCH.purge_rejet_datestatut( L_HFILE );
		PACKBATCH.rejet_datestatut( L_HFILE );
		RPETA( L_HFILE );
		PACKBATCH4.Purge_Rejet( L_HFILE );
		PACKBATCH4.Rejet_Version_RBIP( L_HFILE );
		PACKBATCH4.Rejet_Ressource( L_HFILE );
		PACKBATCH4.Rejet_Ligne_BIP( L_HFILE );
		PACKBATCH4.Copie_Consomme( L_HFILE );
		PACKBATCH.copie_datestatut( L_HFILE );
		RPINIT_AND_RPRAF( L_HFILE );
		PACKBATCH4.FILTRER_CONSOMME( L_HFILE );
		RPDATE( L_HFILE );
		RPSSTRT( L_HFILE );
		P_PROPLUS( L_HFILE );
		PACKBATCH2.Alim_conso( L_HFILE );
		PACKBATCH4.ALIM_REJET( L_HFILE );

		-- PPM 61919 6.17 : mise à jour de la donnée Axe metier tache de la table TACHE depuis les tables ISAC_TACHE et BIPS_ACTIVITE
		Begin
			UPDATE TACHE
			SET TACHE.TACHEAXEMETIER =(
			SELECT ISAC_TACHE.TACHEAXEMETIER
			FROM ISAC_ETAPE, ISAC_TACHE
			WHERE ISAC_ETAPE.ETAPE = ISAC_TACHE.ETAPE
			AND TACHE.PID = ISAC_TACHE.PID
			AND TACHE.ACTA = ISAC_TACHE.ACTA
			AND TACHE.ECET = ISAC_ETAPE.ECET
			)
			WHERE EXISTS (SELECT 1
			FROM ISAC_ETAPE, ISAC_TACHE
			WHERE ISAC_ETAPE.ETAPE = ISAC_TACHE.ETAPE
			AND TACHE.PID = ISAC_TACHE.PID
			AND TACHE.ACTA = ISAC_TACHE.ACTA
			AND TACHE.ECET = ISAC_ETAPE.ECET);

			UPDATE TACHE
			SET TACHE.TACHEAXEMETIER =(
			SELECT BIPS_ACTIVITE.TACHEAXEMETIER
			FROM BIPS_ACTIVITE
			WHERE TACHE.PID = BIPS_ACTIVITE.LIGNEBIPCODE
			AND TACHE.ACTA = BIPS_ACTIVITE.TACHENUM
			AND TACHE.ECET = BIPS_ACTIVITE.ETAPENUM
			AND ROWNUM = 1
			)
			WHERE EXISTS (SELECT 1
			FROM BIPS_ACTIVITE
			WHERE TACHE.PID = BIPS_ACTIVITE.LIGNEBIPCODE
			AND TACHE.ACTA = BIPS_ACTIVITE.TACHENUM
			AND TACHE.ECET = BIPS_ACTIVITE.ETAPENUM);
			COMMIT;
		Exception when others then
			TRCLOG.TRCLOG( L_HFILE, 'Fin anormale du traitement de mise à jour de la donnée Axe metier tache de la table TACHE depuis les tables ISAC_TACHE et BIPS_ACTIVITE');
			TRCLOG.TRCLOG( L_HFILE, SQLERRM);
			ROLLBACK;
			RAISE;
		end;
		-- Trace Start pour suivijhr
		-- -----------
		TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAMESUIVI );

		PACK_SUIVIJHR.ALIM_SUIVIJHR;

		-- Trace Stop pour suivijhr
		-- ----------
		TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAMESUIVI  );

		-- Trace Stop
		-- ----------
		TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
		TRCLOG.CLOSETRCLOG( L_HFILE );

	exception

		when others then
			rollback;
			if sqlcode <> CALLEE_FAILED_ID and
			   sqlcode <> TRCLOG_FAILED_ID then
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME || ' : ' || SQLERRM );
			end if;
			if sqlcode <> TRCLOG_FAILED_ID then
				TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				TRCLOG.CLOSETRCLOG( L_HFILE );
				raise_application_error( CALLEE_FAILED_ID,
				                        'Erreur : consulter le fichier LOG',
				                         false );
			else
				raise;
			end if;

	end ST54700E;

	-- -------------------------------------------------------------------
	-- Test pour savoir si une consommation PMW doit générer une anomalie
	-- -------------------------------------------------------------------
	-- Il n'est pas possible d'invoquer une fonction utilisateur dans un
	-- ordre SQL si elle utilise des types de données autres que "natif",
	-- d'où l'absence de gestion d'exception avec la technique du fichier
	-- de LOG.
	-- -------------------------------------------------------------------
	function TESTANO( P_ASTATUT in char, P_ADATESTATUT in date,
	                  P_CDEB in date, P_CHTYP in char )
	         return number is
	begin

		if P_ASTATUT <> ' ' and -- A FAIRE : et si null value ?
		   ( trunc( P_CDEB, 'year' ) > trunc( P_ADATESTATUT, 'year' ) ) then
			return 3;
		else
			if ( P_CDEB < G_DAT0101ANM1 ) and ( P_CHTYP = '1' ) then
				return 1;
			else
				if ( P_CDEB < G_DAT0101AN ) and
				   ( P_CHTYP = '1' ) then
					return 2;
				else
					return 0;
				end if;
			end if;
		end if;

	end TESTANO;


	-- ----------------------------------------
	-- Test pour savoir si une consommation PMW
	-- est à prendre en compte ou a poubelliser
	-- ----------------------------------------
	-- ---------------------------------------------
	-- Il n'est pas possible d'invoquer une fonction
	-- utilisateur dans un ordre SQL si elle utilise
	-- des types de données autres que "natif", d'où
	-- l'absence de gestion d'exception avec la
	-- technique du fichier de LOG.
	-- ---------------------------------------------
	-- ATTENTION : LA VERSION D'ORIGINE DE CE TEST
	-- (DANS LE SOURCE FOCUS) ETAIT UN PEU
	-- DIFFERENTE : D'UN AUTRE COTE, LA VERSION EN
	-- QUESTION AVAIT ETE PREVUE POUR ETRE APPELEE
	-- PENDANT LA CONSTITUTION DE SA2 MAIS L'APPEL
	-- A ETE MIS EN COMMENTAIRE. EN PLUS, LES DEUX
	-- SOURCES CONSOMMATEUR DE SA0 et SA2 ONT ETE
	-- REGROUPES EN PL/SQL. CONSEQUENCES : ON
	-- MODIFIE LE TEST FOCUS POUR QU'UN APPEL AVEC
	-- LE TYPE 2 REPONDE TOUJOURS OK
	-- Signature d'appel cas rpinit et rpraf
	-- MLC19990330_REPTEST
	-- ---------------------------------------------
	function REPTEST( CHTYP in char,         -- type de consommation
	                  TOTALCHINIT in number, -- somme de tous les CHINIT du projet avant delete
	                  TOTALCHRAF in number,  -- somme de tous les CHRAF du projet avant delete
	                  CDEB in date,          -- debut periode de chargement
	                  MUST_ACCEPT_TYPE_2 in char ) -- pour rpinit et rpraf
	         return char is
	begin
		-- ---------------
		-- Nouveau test
		-- ---------------
		if CHTYP = '2' and MUST_ACCEPT_TYPE_2 = 'true' then
			return 'O';
		else
			if CHTYP = '2' and TOTALCHRAF = 0 then
				return 'O';
			else
			  if CHTYP = '0' and TOTALCHINIT = 0 then
					return 'O';
		/**********************************************************/
			  else
				if CDEB < G_DAT0101AN then
						return 'N';
				else
					return 'O';
				end if;
			  end if;
			end if;
		end if;
	end REPTEST;

	-- ------------------------------------------------------------
	-- RPETA   : prise en compte PMW : prise en compte des segments
	--           Etapes, taches,sous-taches et affectation
	--  - alimentation en mode annule et remplace de la table de
	--    travail BATCH_HDLA
	--  - destruction des sous-segments a partir de Etape, pour les
	--    donnees de l'annee en cours. Sous FOCUS cette destruction
	--    etait realisee avec la technique suivante : je sauvegarde
	--    ce que je NE veux PAS detruire, je detruit TOUT, je
	--    recupere ce que je NE voulais PAS detruire. En Oracle la
	--    technique est : je detruits seulement ce que je veux
	--    detruire. A ce jour (09/02/1999) il n'est pas evident que
	--    le resultat est le meme, mais il semble raisonnable de le
	--    penser, en particulier parceque le 'WHERE CDEB LT MOIS'
	--    du source focus ne sauvegarde pas les segments peres sans
	--    fils (dixit PH)
	-- - traitement d'insertion etape, tache/sous-tache et
	--   affectation. En focus, ces insertions étaient réalisées à
	--   l'aide des fichiers SAx et de la table PMW. Version
	--   ORACLE : les insertions sont réalisées en remplaçant les
	--   fichiers SAx par des requêtes ou curseur (en résumé)
	-- - mise à jour des deux dates "remontée" et "traitement" dans
	--   chaque ligne bip traitée.
	-- A REVOIR : remplacer PID in (version TP)
	-- par une jointure dans certaines requetes
	-- ------------------------------------------------------------
	procedure RPETA( P_HFILE in utl_file.file_type ) is

		L_PROCNAME varchar2(16) := 'RPETA';
		L_STATEMENT varchar2(96);

		L_DATDBX date;           -- date du début de l'exercice
		L_MAXNUMTP char(2);      -- version 'Turbo Pascal' exigée

		L_ORAERRMSG varchar2(128); -- pour insert sqlerrm, warning : 128 codé en substr

		L_INSERTED pls_integer;  -- compte insert
		L_SKIPED pls_integer;    -- compte poubelle
		L_REJECTED pls_integer;  -- compte rapport d'erreur

	begin
		-- Trace Start
		-- -----------
		TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );
		DYNA_TRUNCATE( 'BATCH_CONS_SST_RES_M_BAD');
		-- recupere la date de début de l'exercice en cours
		-- ------------------------------------------------
		L_STATEMENT := 'Recherche date début d''exercice';
		CALCDATDBX( P_HFILE, L_DATDBX );
		TRCLOG.TRCLOG( P_HFILE, 'Début d''exercice : ' ||
		               to_char( L_DATDBX, 'DD/MM/YYYY' ) );

		-- valorise les deux dates '01/01/yyyy'
		-- ------------------------------------
		G_DAT0101AN   := trunc( L_DATDBX, 'year' );
		G_DAT0101ANM1 := add_months( G_DAT0101AN, -12 );

		-- recupere le filtre sur la version Turbo Pascal
		-- ----------------------------------------------
		L_STATEMENT := 'Calcul version actuelle';
		select max( NUMTP) into L_MAXNUMTP from VERSION_TP;
		if L_MAXNUMTP is null then
			raise_application_error( ERR_FONCTIONNELLE_ID,
			                         'max(NUMTP) from VERSION_TP est null !',
			                         true );
		else
			TRCLOG.TRCLOG( P_HFILE, 'Version PMW-BIP de référence : ' ||
			               L_MAXNUMTP );
		end if;

		-- Alimentation de la table de travail BATCH_HDLA
		-- voir signature MLC19990211_BATCH_HDLA
		-- Si le rollback n'est pas necessaire (ce qui est le cas
		-- puisque la table est a usage "local" en mode "replace")
		-- le truncate est beaucoup plus efficace que le delete
		-- (le truncate EST une sequence drop-create). On profite
		-- de la création de cette table pour éviter une jointure
		-- sur LIGNE_BIP quand on voudra faire le test de la mort
		-- qui tue grave : REPTEST
		-- --------------------------------------------------------
		-- TOTALCHRAF ne sert a rien. Il est théoriquement utilisé
		-- par REPTEST mais il semble bien que REPTEST ne soit
		-- jamais utilisé avec des lignes de type 2
		-- --------------------------------------------------------
		-- ATTENTION : TOTALISATIONS TOTALEMENT INUTILES : ON VEUT
		-- JUSTE SAVOIR SI LE RESULTAT EST DIFFERENT DE ZERO !
		-- PLUSIEURS AUTRES TECHNIQUES POSSIBLES
		-- peut être PLUS PERFORMANTES
		-- --------------------------------------------------------
		-- 18/05/1999 : manuel leclerc est un gros nul, signé le
		-- gros nul : il manquait la jointure externe sur la
		-- subquery pour traiter les projets sans conso !
		-- --------------------------------------------------------
		L_STATEMENT := 'Truncate Table BATCH_HDLA';
		DYNA_TRUNCATE( 'BATCH_HDLA' );

		L_STATEMENT := 'Alimentation Table BATCH_HDLA';
		insert into BATCH_HDLA ( PID, ASTATUT, ADATESTATUT,
		                   TOTALCHINIT, TOTALCHRAF )
		( select LIGNE_BIP.PID, LIGNE_BIP.ASTATUT,
		         LIGNE_BIP.ADATESTATUT,
		         TOTAUX.TOTALCHINIT, TOTAUX.TOTALCHRAF
		  from LIGNE_BIP,( select PID, sum( CHINIT ) as TOTALCHINIT,
		                               sum( CHRAF ) as TOTALCHRAF
		                   from CONS_SSTACHE_RES_MOIS
		                   group by PID ) TOTAUX
		  where LIGNE_BIP.PID = TOTAUX.PID (+) );
		-- DONE
		-- ----
		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows inserted (after truncate)' );

		-- ----------------------------------------------
		-- detruit toutes les consommations de l'exercice
		-- pour les projets remontes
		-- ----------------------------------------------
		L_STATEMENT := 'Delete CONS_SSTACHE_RES_MOIS pour l''année et PID PMW';
		delete from CONS_SSTACHE_RES_MOIS
		where CDEB >= L_DATDBX and
		      PID in ( select PID from PMW_LIGNE_BIP
		               where PMWBIPVERS = L_MAXNUMTP );
		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows deleted' );

		-- detruit toutes les affectation sans
		-- consommations pour les projets remontes
		-- PERFORMANCE : peut être remplacer les deux
		-- select par un seul avec jointure et clause
		-- or/and ?
		-- ----------------------------------------------
		L_STATEMENT := 'Delete CONS_SSTACHE_RES sans consommation mais PID PMW';
		DELETE  FROM  CONS_SSTACHE_RES A
		where A.PID in ( select PID from PMW_LIGNE_BIP
		                 where PMWBIPVERS = L_MAXNUMTP ) and
		      not exists ( select /*+ index(B CONSSSTACHERESMOIS_PK) */ null
				   from CONS_SSTACHE_RES_MOIS B
		                   where A.PID   = B.PID  and
		                         A.ECET  = B.ECET and
		                         A.ACTA  = B.ACTA and
		                         A.ACST  = B.ACST and
		                         A.IDENT = B.IDENT );
		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows deleted' );

		-- detruit toutes les taches, sous-taches sans
		-- affectation pour les projets remontes
		-- ----------------------------------------------
		L_STATEMENT := 'Delete TACHE sans affectation mais PID PMW';
		DELETE  FROM  TACHE A
		WHERE  A.PID IN  ( SELECT  PID FROM  PMW_LIGNE_BIP
		                 WHERE  PMWBIPVERS = L_MAXNUMTP ) AND
		      NOT  EXISTS  ( SELECT  NULL  FROM  CONS_SSTACHE_RES B
		                   WHERE  A.PID  = B.PID  AND
		                         A.ECET = B.ECET AND
		                         A.ACTA = B.ACTA AND
		                         A.ACST = B.ACST );
		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows deleted' );

		-- detruit toutes les etapes sans tache pour les
		-- projets remontes
		-- ----------------------------------------------
		L_STATEMENT := 'Delete ETAPE sans tache mais PID PMW';
		delete from ETAPE A
		where A.PID in ( select PID from PMW_LIGNE_BIP
		                 where PMWBIPVERS = L_MAXNUMTP ) and
		      not exists ( select null from TACHE B
		                   where A.PID  = B.PID  and
		                         A.ECET = B.ECET );
		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows deleted' );

		-- Change le statut de tous les projets remontes
		-- ---------------------------------------------
		L_STATEMENT := 'Positionne PETAT a ''M'' pour les projets PMW';
		update LIGNE_BIP set PETAT = 'M'
		where PID in ( select PID from PMW_LIGNE_BIP
		               where PMWBIPVERS = L_MAXNUMTP );
		commit;

		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows updated' );

		-- TD 355 : J.MAS : Mise à jour de l'origine de la saisie
		-- ---------------------------------------------
		L_STATEMENT := 'Mise à jour de l''origine de la saisie P_SAISIE';
		update LIGNE_BIP lb set lb.P_SAISIE = ( select plb.P_SAISIE from PMW_LIGNE_BIP plb where plb.PID = lb.PID and rownum=1 )
		where lb.PID in (select plb.PID from PMW_LIGNE_BIP plb where plb.P_SAISIE is not null ); -- QC 1911 et 1912
		commit;

		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows updated' );

		-- --------------------------------------------------------
		-- SA03 : segment G
		-- --------------------------------------------------------
		-- remonte les etapes, taches, sous-taches
		-- --------------------------------------------------------
		-- Le source focus presente quelques particularites
		-- interressantes :
		--    - les calculs sum(), min(), max() sont fait AVANT le
		--      filtre sur les affectations.
		--    - les segments NE sont PAS mis à jour quand ils
		--      pre-existent, c'est a dire chaque fois qu'il y a eu
		--      une consommation l'annee d'avant (autrement dit :
		--      on ne fait que des insert, pas des update)
		--    - tous doublons pendant l'insertion est poubellisé
		-- --------------------------------------------------------
		-- Le curseur principal est la liste des couples distincts
		-- PID, Etape pour lesquels existent au moins une
		-- affectation, avec la contrainte sur la validite du
		-- numero de version TP. Le source focus ajoute un filtre
		-- sur la version TP au moment de la jointure sur les
		-- affectations, mais CA on peut le virer puisqu'il n'y a
		-- qu'un seul numéro de version par fichier PMW : celui du
		--  segment A !
		-- --------------------------------------------------------
		-- Si quelqu'un veut essayer de coder ca en une seule
		-- requete ensembliste a peu pres lisible et acceptee par
		-- PL/SQL 7.3.3.4, je lui souhaite bien du plaisir
		-- --------------------------------------------------------
		-- on profite d'avoir un select et on un ordre de mise à
		-- jour pour régler le problème du numéro de version par
		-- une jointure et non par un "where pid in ( select...)"
		-- L'optimisation des performances passe peut être par
		-- l'ajout d''une colonne numtp dans toutes les tables
		-- PMW_* qui ne l'ont pas, colonnes que l'on renseignerait
		-- après le load
		-- --------------------------------------------------------
		-- Etape
		-- -----
		L_STATEMENT := 'Truncate Table BATCH_ETAPE_BAD';
		DYNA_TRUNCATE( 'BATCH_ETAPE_BAD' );
		L_STATEMENT := 'Insertion des Etapes';
		L_INSERTED := 0;
		L_SKIPED := 0;
		L_REJECTED := 0;

		declare

			L_ROW_COUNT number;
			cursor C_NEW_ETAPE is select distinct PMW_ACTIVITE.PID, ACET
			                      from PMW_ACTIVITE, PMW_AFFECTA,
			                           PMW_LIGNE_BIP
			                      where PMW_ACTIVITE.PID =  PMW_LIGNE_BIP.PID and
			                            PMW_ACTIVITE.PID = PMW_AFFECTA.PID and
			                            ACET = TCET and
			                            PMWBIPVERS = L_MAXNUMTP;

		begin

			for ONE_ETAPE in C_NEW_ETAPE loop
				-- -------------------------------------------------
				-- on n'insere pas si l'etape existe deja. La clause
				-- distinct du select elimine les tres nombreux
				-- doublons générés par la jointure sur les
				-- affectations mais IL EST POSSIBLE QU'UNE ETAPE
				-- EXISTE DEJA MALGRES LE DELETE EFFECTUE en début
				-- de traitement car ce delete ne concerne que
				-- l'année N. Si les procédures de changement
				-- d'année preservent des données N-1 pour certains
				-- projet alors ON N'INSERE PAS ! CETTE REMARQUE EST
				-- VALABLE EGALEMENT POUR LES TACHES/SOUS-TACHES ET
				-- POUR LES AFFECTATIONS
				-- Etant donné qu'on est obligé de gérer les
				-- exceptions à cause des deux clés étrangère de la
				-- table ETAPE, on ne vérifie pas la non existance
				-- par un select : on traite dup_val_on_index
				-- -------------------------------------------------
				-- On utilise les fonctions de groupe SANS se
				-- preocuper de la jointure sur les affectations,
				-- comme en FOCUS. ATTENTION : fonction de groupe
				-- sur la colonne "type etape" AIET car il est
				-- normalement interdit de selecter une colonne qui
				-- n'est pas dans la clause group by (bien que cela
				-- ne pertube pas le compilateur PL/SQL 7.3.3.4,
				-- mais que ferait-il au run-time ?). Toutes les
				-- AIET des taches d'une meme etape sont
				-- THEORIQUEMENT identiques
				-- -------------------------------------------------
				-- type etape sur 6 en focus dans Proj et PMW mais
				-- table focus type etape avec cle sur 2
				-- Migration SQL : type etape partout sur 2
				-- -------------------------------------------------
				-- Remarque : ceci n'est ni une pipe ni une requete
				-- "n-rows" : une selection sur valeur avec un group
				-- by sur les mêmes colonnes rend obligatoirement 0
				-- ou une lignes
				-- PERFORMANCES : SI LE TAUX DE SKIPED EST
				-- SIGNIFICATIF IL FAUT VERIFIER SI LA LIGNE EXISTE
				-- AVANT D ESSAYER D'INSERER (inutile de calculer le
				--  group by)
				-- -------------------------------------------------
				BEGIN
					-- **** WARNING **** : code dupliqué
					-- ci-dessous pour rapport d'erreur
					-- ---------------------------------
					INSERT  INTO  ETAPE
					(PID, ECET, EDUR, EDEB, EFIN, ENDE, ENFI, TYPETAP )
					(SELECT  PID, ACET, sum( ADUR ), min( ADEB ),
					         max( AFIN ), min( ANDE ), max( ANFI ),
					         max( substr( AIET, 1, 2 ) )
					  FROM  PMW_ACTIVITE
					  WHERE  PID = ONE_ETAPE.PID AND
					        ACET = ONE_ETAPE.ACET
					  GROUP BY  PID, ACET );
					L_INSERTED := L_INSERTED + 1;

				EXCEPTION

					-- Clé primaire dupliquée : poubelle
					-- Clé étrangère mauvaise : rapport et suite
					-- -----------------------------------------
					when dup_val_on_index then
						L_SKIPED := L_SKIPED + 1; -- poubelle

					when CONSTRAINT_VIOLATION then
						L_ORAERRMSG := sqlerrm;
						-- DUPLICATION DE CODE POUR RAPPORT D'ERREUR
						-- -----------------------------------------
						insert into BATCH_ETAPE_BAD
						( PID, ECET, EDUR, EDEB, EFIN, ENDE, ENFI,
						  TYPETAP, ERRMSG )
						( select PID, ACET, sum( ADUR ), min( ADEB ),
						         max( AFIN ), min( ANDE ), max( ANFI ),
						         max( substr( AIET, 1, 2 ) ),
						         substr( L_ORAERRMSG, 1, 128 )
						  from PMW_ACTIVITE
						  where PID = ONE_ETAPE.PID and
						        ACET = ONE_ETAPE.ACET
						  group by PID, ACET );
						L_REJECTED := L_REJECTED + 1;

					when others then
						-- Curseur : info disponible
						-- -------------------------
						TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [' ||
						               L_STATEMENT || '] ( PID=' ||
						               ONE_ETAPE.PID || ', CET=' ||
						               ONE_ETAPE.ACET || ' ) : ' ||
						               SQLERRM );
						raise CALLEE_FAILED;

				end; -- block insert

			end loop; -- curseur etape

		end; -- block etape

		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || L_INSERTED ||
		               ' rows inserted. ' || L_SKIPED || ' rows skiped. ' ||
		               L_REJECTED || ' rows rejected.' );

		-- ----------------------------------------------------------
		-- Tache, sous-tache
		-- ----------------------------------------------------------
		-- On ne prend que les sous-taches affectees. En fait, on est
		-- sensé ne prendre que les taches et sous-taches du
		-- traitement ci-dessus des étapes, sans élimination des
		-- doublons mais avec un ON MATCH REJECT. PERFORMANCES : il
		-- "pourrait" être plus rapide de traiter l'insertion des
		-- taches/sous-taches toute de suite après avoir traité une
		-- etape (curseur du traitement ci-dessus) mais c'est loin
		-- d'être évident à priori.
		-- On a une clause distinct pour éliminer les nombreux
		-- doublons qui arrivent à cause de la jointure sur les
		-- affectations. En contrepartie, on ne selectionne pas les
		-- colonnes utiles, qu'on va donc devoir rechercher pour
		-- l'insertion
		-- ----------------------------------------------------------
		L_STATEMENT := 'Truncate Table BATCH_TACHE_BAD';
		DYNA_TRUNCATE( 'BATCH_TACHE_BAD' );
		L_STATEMENT := 'Insertion des Taches/Sous-taches';
		L_INSERTED := 0;
		L_SKIPED := 0;
		L_REJECTED := 0;


		declare

			L_ROW_COUNT number;

			cursor C_NEW_TACHE is select distinct PMW_ACTIVITE.PID, ACET, ACTA, ACST
			                      from PMW_ACTIVITE, PMW_AFFECTA,
			                           PMW_LIGNE_BIP
			                      where PMW_ACTIVITE.PID = PMW_LIGNE_BIP.PID and
			                            PMWBIPVERS = L_MAXNUMTP and
			                            PMW_ACTIVITE.PID = PMW_AFFECTA.PID and
			                            ACET = TCET and
			                            ACTA = TCTA and
			                            ACST = TCST;

		begin

			for ONE_TACHE in C_NEW_TACHE loop
				-- --------------------------------------------------
				-- on n'insere pas si la tache existe deja
				-- IL PEUT Y AVOIR UNE TACHE QUI EXISTE DEJA MALGRES
				-- LE DISTINCT CI-DESSUS : C'EST COMME POUR LES
				-- ETAPES : LA TACHE N'A PEUT ETRE PAS ETE DELETEE EN
				-- DEBUT DE TRAITEMENT
				-- --------------------------------------------------
				-- A la différence de l'insert ETAPE, il n'y a aucun
				-- group by a faire ici : IL Y A RISQUE POTENTIEL
				-- QU'ON ESSAYE ICI D'INSERER PLUSIEURS LIGNES D'UN
				-- COUP (s'il y a doublons sur PMW_ACTIVITE) CELA
				-- ARRIVE CHAQUE FOIS QU'UN CHEF DE PROJET REMONTE EN
				-- DOUBLE. LE CODE FOCUS POUBELISE LES TACHES EN
				-- DOUBLE ALORS QU'IL A ADDITIONNE ALEGREMENT LES
				-- ADUR POUR FAIRE EDUR. SOLUTIONS : utilisation de
				-- la pseudo-colonne de comptage du "ResultSet" pour
				-- ne prendre qu'un seul exemplaire de la
				-- tache/sous-tache
				-- --------------------------------------------------
				begin
					-- **** WARNING **** : code dupliqué
					-- ci-dessous pour rapport d'erreur
					-- ---------------------------------
					insert into TACHE
					( PID, ECET, ACTA, ACST, ADEB, AFIN, ANDE, ANFI,
					  ADUR, ASNOM, ASTA, APCP, AIST, AISTTY, AISTPID )
					( select PID, ACET, ACTA, ACST, ADEB, AFIN, ANDE,
					         ANFI, ADUR, ASNOM, ASTA, APCP, AIST,
					         DECODE(AIST, 'HEUSUP', NULL, substr(AIST,1,2)),
					         DECODE(AIST, 'HEUSUP', NULL, rtrim(substr(AIST, 3, 4 )))
					  from PMW_ACTIVITE
					  where PID = ONE_TACHE.PID and
					        ACET = ONE_TACHE.ACET and
					        ACTA = ONE_TACHE.ACTA and
					        ACST = ONE_TACHE.ACST and
					        rownum < 2 );
					L_INSERTED := L_INSERTED + 1;

				exception

					-- Clé primaire dupliquée : poubelle
					-- Clé étrangère mauvaise : rapport et suite
					-- -----------------------------------------
					when dup_val_on_index then
						L_SKIPED := L_SKIPED + 1; -- poubelle

					when CONSTRAINT_VIOLATION then
						L_ORAERRMSG := sqlerrm;
						-- DUPLICATION DE CODE POUR RAPPORT D'ERREUR
						-- -----------------------------------------
						L_REJECTED := L_REJECTED + 1;
						insert into BATCH_TACHE_BAD
						( PID, ECET, ACTA, ACST, ADEB, AFIN, ANDE, ANFI,
						  ADUR, ASNOM, ASTA, APCP, AIST, AISTTY, AISTPID,
						  ERRMSG )
						( select PID, ACET, ACTA, ACST, ADEB, AFIN, ANDE,
						         ANFI, ADUR, ASNOM, ASTA, APCP, AIST,
						         DECODE(AIST, 'HEUSUP', NULL, substr(AIST,1,2)),
					         	 DECODE(AIST, 'HEUSUP', NULL, rtrim(substr(AIST, 3, 4))),
						         substr( L_ORAERRMSG, 1, 128 )
						  from PMW_ACTIVITE
						  where PID = ONE_TACHE.PID and
						        ACET = ONE_TACHE.ACET and
						        ACTA = ONE_TACHE.ACTA and
						        ACST = ONE_TACHE.ACST and
						        rownum < 2 );

					when others then
						-- Curseur : info disponible
						-- -------------------------
						TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [' ||
						               L_STATEMENT || '] ( PID=' ||
						               ONE_TACHE.PID || ', CET=' ||
						               ONE_TACHE.ACET || ', CTA=' ||
						               ONE_TACHE.ACTA || ', CST=' ||
						               ONE_TACHE.ACST || ') : ' ||
						               SQLERRM );
						raise CALLEE_FAILED;

				end; -- end block insert

			end loop; -- curseur tache

		end; -- block tache

		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || L_INSERTED ||
		               ' rows inserted. ' || L_SKIPED || ' rows skiped. ' ||
		               L_REJECTED || ' rows rejected.' );

		-- ----------------------------------------------------------
		-- SA4 : segment I AFFECTATIONS
		-- ----------------------------------------------------------
		-- Le contenu du SA4 est un sous-ensemble de PMW_AFFECTAT
		-- (segment I) restreint a l'aide d'une consultation de
		-- PMW_CONSOMM (segment J) et de BATCH_HDLA (extraction de proj,
		-- segment CONSOMM). Le probleme est que ce dernier segment
		-- (table CONS_SSTACHE_RES_MOIS) VIENT de subir un delete de
		-- la mort ! On ne sait donc PLUS reconstituer SA4. D'ou la
		-- creation de la table de travail BATCH_HDLA
		-- MLC19990211_BATCH_HDLA
		-- ----------------------------------------------------------
		-- les petites transformations sur le numéro de ressource
		-- sont faites AVANT jointure dans le source FOCUS.
		-- ----------------------------------------------------------
		-- Vérification de l'existance d'une consommation vérifiant
		-- la règle focus REPTEST : deux solutions : dans le curseur
		-- ou à chaque fetch. Choix fait à ce jour 12/02/1999 : au
		-- fetch. Autre choix le 25/03/1999 : à l'open
		-- ----------------------------------------------------------
		-- Mêmes remarques que pour l'insertion des taches : la
		-- jointure sur le niveau du dessous (ici les consommations)
		-- provoquent de nombreux doublons : on les élimine par la
		-- clause distinct et on ne récupère en fait que des clés
		-- donc a chaque fetch on relira la ligne à inserer
		-- ----------------------------------------------------------
		-- une ligne n'est à prendre en compte que si on trouve une
		-- consommation qui vérifie la règle REPTEST
		-- ----------------------------------------------------------
		L_STATEMENT := 'Truncate Table BATCH_CONS_SSTACHE_RES_BAD';
		DYNA_TRUNCATE( 'BATCH_CONS_SSTACHE_RES_BAD' );
		L_STATEMENT := 'Insertion des Affectations';
		L_INSERTED := 0;
		L_SKIPED := 0;
		L_REJECTED := 0;

		declare

			cursor C_NEW_AFF is select distinct PMW_AFFECTA.PID, TCET, TCTA, TCST, TIRES
			                    from PMW_AFFECTA, PMW_CONSOMM, PMW_LIGNE_BIP,
			                         BATCH_HDLA
			                    where PMW_AFFECTA.PID = PMW_LIGNE_BIP.PID and
			                          PMW_AFFECTA.PID = BATCH_HDLA.PID and
			                          PMW_AFFECTA.PID  = PMW_CONSOMM.PID and
			                          TCET  = CCET and
			                          TCTA  = CCTA and
			                          TCST  = CCST and
			                          TIRES = CIRES and
			                          PMWBIPVERS = L_MAXNUMTP and
			                          REPTEST( CHTYP, TOTALCHINIT,
			                                   TOTALCHRAF, CDEB, 'false' ) = 'O';



		begin

			for ONE_AFFECT in C_NEW_AFF loop

				begin

					-- ----------------------------------------------
					-- on redemande les données. On utilise la
					-- pseudo-colonne de comptage pour ne voir que
					-- le premier des doublons
					-- ----------------------------------------------
					-- **** WARNING **** : code dupliqué ci-dessous
					-- pour rapport d'erreur
					-- ----------------------------------------------
					insert into CONS_SSTACHE_RES
					( PID, ECET, ACTA, ACST, IDENT, TPLAN, TACTU, TEST )
					( select PID, TCET, TCTA, TCST,
					         decode( TIRES, '******', 0,
					                 to_number( substr( TIRES, 1, 5 ) ) ),
					         TPLAN, TACTU, TEST
					  from PMW_AFFECTA
					  where PID = ONE_AFFECT.PID and
					        TCET = ONE_AFFECT.TCET and
					        TCTA = ONE_AFFECT.TCTA and
					        TCST = ONE_AFFECT.TCST and
					        TIRES = ONE_AFFECT.TIRES and
					        rownum < 2 );

					L_INSERTED := L_INSERTED + 1;

				exception

					-- Clé primaire dupliquée : poubelle
					-- Clé étrangère mauvaise : rapport et suite
					-- -----------------------------------------
					when dup_val_on_index then
						L_SKIPED := L_SKIPED + 1; -- poubelle

					when CONSTRAINT_VIOLATION then
						L_ORAERRMSG := sqlerrm;
						-- DUPLICATION DE CODE POUR RAPPORT D'ERREUR
						-- -----------------------------------------
						L_REJECTED := L_REJECTED + 1;
						insert into BATCH_CONS_SSTACHE_RES_BAD
						( PID, ECET, ACTA, ACST, IDENT, TPLAN, TACTU,
						  TEST, ERRMSG )
						( select PID, TCET, TCTA, TCST,
						         decode( TIRES, '******', 0,
						                 to_number( substr( TIRES, 1, 5 ) ) ),
						         TPLAN, TACTU, TEST,
						         substr( L_ORAERRMSG, 1, 128 )
						  from PMW_AFFECTA
						  where PID = ONE_AFFECT.PID and
						        TCET = ONE_AFFECT.TCET and
						        TCTA = ONE_AFFECT.TCTA and
						        TCST = ONE_AFFECT.TCST and
						        TIRES = ONE_AFFECT.TIRES and
						        rownum < 2 );

					when others then
						-- Curseur : info disponible
						-- -------------------------
						TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [' ||
						               L_STATEMENT || '] ( PID=' ||
						               ONE_AFFECT.PID || ', CET=' ||
						               ONE_AFFECT.TCET || ', CTA=' ||
						               ONE_AFFECT.TCTA || ', CST=' ||
						               ONE_AFFECT.TCST || ', IDT=' ||
						               ONE_AFFECT.TIRES || ') : ' || SQLERRM );
						raise CALLEE_FAILED;

				end; -- end block insert

			end loop; -- curseur affectation

		end; -- end block affectation

		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || L_INSERTED ||
		               ' rows inserted. ' || L_SKIPED || ' rows skiped. ' ||
		               L_REJECTED || ' rows rejected.' );

		-- --------------------------------------------
		-- TRAITEMENT DES DATES DE TRANSFERTS ET DE
		-- TRAITEMENTS PMW-BIP
		-- --------------------------------------------
		-- Ce qu'on appelle un "projet remonté" dans la
		-- suite des traitements est un projet present
		-- dans le SA6-SA7
		-- --------------------------------------------
		-- ATTENTION : SI LES INFOS PMW REMONTENT EN
		-- DOUBLE LA SUBQUERY REND PLUSIEURS LIGNES
		-- PROTECTION PAR COMPTAGE RESULT-SET
		-- --------------------------------------------
		L_STATEMENT := 'Mise à jour des dates de traitement';
		update LIGNE_BIP
		set TTRMENS = (select NVL(trunc(dertrait), trunc(sysdate)) from datdebex),
		    TTRFBIP = ( select to_date( to_char( sqrt( P_AA_CARRE ), 'FM00' ) ||
		                                to_char( sqrt( P_MM_CARRE ), 'FM00' ) ||
		                                to_char( sqrt( P_JJ_CARRE ), 'FM00' ),
		                             'RRMMDD' )
		                from PMW_LIGNE_BIP
		                where LIGNE_BIP.PID = PMW_LIGNE_BIP.PID and rownum < 2 )
		where PID in ( select PID from PMW_LIGNE_BIP
		               where PMWBIPVERS = L_MAXNUMTP );
		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows updated' );

		-- Trace Stop
		-- ----------
		TRCLOG.TRCLOG( P_HFILE, 'Fin normale de ' || L_PROCNAME  );

		exception

			when others then
				if sqlcode <> CALLEE_FAILED_ID then
					TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [' || L_STATEMENT ||
					               '] : ' || SQLERRM );
				end if;
				TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
				raise CALLEE_FAILED;

	end RPETA;

	-- -----------------------------------------------------------
	-- UPDATE_OR_INSERT_CUSAG
	-- Routine   de mise à jour effective de CONS_SSTACHE_RES_MOIS
	-- en ce qui concerne le "segment J1" (conso.) de PMW_CONSOMM
	-- Cette routine se VAUTRE si clés étrangères ne sont pas
	-- correctes car l'appelant est censé avoir vérifié qu'une
	-- affectation existe. PERFOMANCES : si l'appelant ne fait
	-- pas cette vérification, il faut la faire içi mais gérer
	-- l'exception de manière applicative
	-- -----------------------------------------------------------
	procedure UPDATE_OR_INSERT_CUSAG( P_HFILE in utl_file.file_type,
	                                  P_PID in char, P_ET in char, P_TA in char,
	                                  P_ST in char, P_IDENT in number, P_CDEB in date,
	                                  P_CDUR in number, P_CUSAG in number,
	                                  P_NEW_CONSO out boolean ) is

		L_PROCNAME varchar2( 32 ) := 'UPDATE_OR_INSERT_CUSAG';
		L_STATEMENT varchar2( 96 );

		L_CDEB date; -- au premier jour du mois, par précaution

	begin

		L_STATEMENT := 'Essai d''Update';
		L_CDEB := trunc( P_CDEB, 'month' );

		update CONS_SSTACHE_RES_MOIS
		set CDUR  = P_CDUR,
		    CUSAG = CUSAG + P_CUSAG
		where PID = P_PID and
		      ECET = P_ET and
		      ACTA = P_TA and
		      ACST = P_ST and
		      IDENT = P_IDENT and
		      CDEB = L_CDEB;
		if sql%notfound then
			L_STATEMENT := 'No Data Found : Insert';
			-- A ce jour, 29/03/1999, les colonnes CHINIT, CHRAF et
			-- SHPROUF sont mises à zéro lors de l'insert
			-- ----------------------------------------------------
			insert into CONS_SSTACHE_RES_MOIS
			( PID, ECET, ACTA, ACST, IDENT, CDEB, CDUR, CUSAG, CHINIT, CHRAF )
			VALUES ( P_PID, P_ET, P_TA, P_ST, P_IDENT, L_CDEB,
			         P_CDUR, P_CUSAG, 0, 0 );
			P_NEW_CONSO := true;
		else
			P_NEW_CONSO := false;
		end if;

	exception

		when others then
			TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [' || L_STATEMENT ||
			               '] : ( PID =' || P_PID || ', ET=' || P_ET ||
			               ', TA=' || P_TA || ', ST=' || P_ST || ', IDENT=' || P_IDENT ||
			               ', CDEB=' || P_CDEB || ', CDUR=' || P_CDUR ||
			               ', CUSAG=' || P_CUSAG || ' ) : ' || SQLERRM );
			raise CALLEE_FAILED;

	end UPDATE_OR_INSERT_CUSAG;

	-- ----------------------------------------------------------------
	-- GET_CJOUR    Petite fonction utilitaire qui lit CALENDRIER et
	-- considère que les mois absents font 21 jours ouvrés. Cette
	-- fonction n'impose pas que la date soit celle du premier jour du
	-- mois
	-- ----------------------------------------------------------------
	-- Le trunc est donc effectué par précaution. CETTE FONCTION EST
	-- APPELLEE UN GRAND NOMBRE DE FOIS ET UTILISE UNE TABLE : UNE
	-- OPTIMISATION DE TYPE "CACHE-MEMOIRE" EST A CONSIDERER.
	-- ----------------------------------------------------------------
	function GET_CJOUR( P_HFILE in utl_file.file_type, DTMONTH in date )
	         return number is

		L_CJOUR number;
		L_PROCNAME varchar2(16) := 'GET_CJOUR';

	begin

		select CJOURS into L_CJOUR from calendrier
		where CALANMOIS = trunc( DTMONTH, 'month' );
		return L_CJOUR;

	exception

		when no_data_found then
			return 21;

		when others then

			TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [date=' || DTMONTH ||
			              '] : ' || SQLERRM );
			raise CALLEE_FAILED;

	end GET_CJOUR;


	-- -----------------------------------------
	-- CALCJOUROUVR Petite fonction utilitaire
	-- qui calcule le nombre de jour ouvrés
	-- entre deux dates en enlevant les
	-- wekk end. Les deux
	-- bornes sont incluses dans le compte
	-- CETTE FONCTION EST APPELLEE UN GRAND
	-- NOMBRE DE FOIS ET UTILISE UNE TABLE : UNE
	-- OPTIMISATION DE TYPE "CACHE-MEMOIRE" EST
	-- A CONSIDERER.
	-- -----------------------------------------
	function CALCJOUROUVR( P_HFILE in utl_file.file_type,
	                       DTSTART in date )
		return number is

		L_PROCNAME varchar2(16) := 'CALCJOUROUVR';
		L_STATEMENT varchar2(64);

		NBJOURTOTAL number;       -- nombre de jour restant à examiner
		NBJOUROUVR number;        -- nombre de jour au boulot
		DAYSTART date;            -- ramené à la journée pour éviter ennuis
		DAYEND date;              -- ramené à la journée pour éviter ennuis
		DAYOFWEEK char(1);        -- jour de la semaine Lundi = '1', Dimanche = '7'
		ROWCOUNT number;          -- résultat du select count(*) fériés

	begin

		L_STATEMENT := 'Calcul date';
		DAYSTART := DTSTART;
		DAYEND   := last_day( DAYSTART );
		NBJOURTOTAL := DAYEND - DAYSTART + 1;
		NBJOUROUVR := 0;

		-- Date de fin strictement plus petite que
		-- date de début : pas d'entrée en boucle
		-- ---------------------------------------

		while NBJOURTOTAL > 0 loop
			-- On n'ajoute un jour que si on n'est pas
			-- sur un week-end
			-- ---------------------------------------
			-- Lundi = '1', Dimanche = '7'
			-- ---------------------------------------
			L_STATEMENT := 'Get Day Of Week';
			select to_char( DAYSTART, 'D' ) into DAYOFWEEK
			from dual;

			if DAYOFWEEK <> '6' and DAYOFWEEK <> '7' then
				NBJOUROUVR := NBJOUROUVR + 1;
			end if;
			NBJOURTOTAL := NBJOURTOTAL - 1;
			DAYSTART := DAYSTART + 1;
		end loop;

		return NBJOUROUVR;

	exception

		when others then

			TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [' || L_STATEMENT || '] : ' ||
			               ' (Date Start =' || DTSTART || ') : ' ||
			               SQLERRM );
			raise CALLEE_FAILED;

	end CALCJOUROUVR;

	-- -----------------------------------------------------------
	-- LOAD_CONSO_INIT_RAF
	-- Routine de mise à jour effective de CONS_SSTACHE_RES_MOIS
	-- en ce qui concerne les "segments J0 et J2" de PMW_CONSOMM
	-- Le CUSAG en paramètre va aller soit vers CHINIT soit vers
	-- CHRAF en fonction de CHTYP
	-- -----------------------------------------------------------
	procedure LOAD_CONSO_INIT_RAF( P_HFILE in utl_file.file_type,
	                               P_PID in char, P_ET in char, P_TA in char,
	                               P_ST in char, P_IDENT in char, P_CDEB in date,
	                               P_CDUR in number, P_CUSAG in number,
	                               P_CHTYP in char,
	                               P_RESULT out char,
                                   P_NUMERO_PASSE in pls_integer ) is

		L_PROCNAME varchar2(48) := 'LOAD_CONSO_INIT_RAF' || P_NUMERO_PASSE;
		L_STATEMENT varchar2(64);

		L_CDEB date;          -- au premier jour du mois, par précaution
		L_IDENT number ( 5 ); -- ressource

	begin

		L_STATEMENT := 'Decode Ressource';
		select decode( P_IDENT, '******', 0,
		               to_number( substr( P_IDENT, 1, 5 ) ) )
		into L_IDENT from dual;

		L_CDEB := trunc( P_CDEB, 'month' );
		L_STATEMENT := 'Update';

--  DEBUGING CODE
--		TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [' || L_STATEMENT || '] : ' ||
--		               ' (PID=' || P_PID || ', ET=' || P_ET || ', TA=' ||
--		               P_TA || ', ST=' || P_ST || ', IDENT=' || P_IDENT ||
--		               ', CDEB=' || P_CDEB || ', CDUR=' || P_CDUR ||
--		               ', CHRAF=' || P_CUSAG || ')' );
--		P_RESULT := 'U';
--		return;
--  DEBUGING CODE

		-- on essaye de ne mettre à jour que CDUR et ou CHINIT ou
		-- CHRAF en fonction du type d'enreg. traité
		-- ------------------------------------------------------
		update CONS_SSTACHE_RES_MOIS set
		CDUR   = P_CDUR,
		CHINIT = decode( P_CHTYP, '0',
		                 decode( P_NUMERO_PASSE, 1, 0, P_CUSAG + CHINIT ),
		                 CHINIT ),
		CHRAF  = decode( P_CHTYP, '2',
		                 decode( P_NUMERO_PASSE, 1, 0, P_CUSAG + CHRAF )
		               , CHRAF )
		where PID = P_PID and
		      ECET = P_ET and
		      ACTA = P_TA and
		      ACST = P_ST and
		      IDENT = L_IDENT and
		      CDEB = L_CDEB;
		if sql%notfound then
			L_STATEMENT := 'Echec Update : Insert';

			-- on ajoute avec CUSAG à 0 et CHINIT ou CHRAF aussi
			-- en fonction du type d'enreg. traité
			-- -------------------------------------------------
			insert into CONS_SSTACHE_RES_MOIS
			( PID, ECET, ACTA, ACST, IDENT, CDEB, CDUR, CUSAG, CHINIT, CHRAF )
			VALUES ( P_PID, P_ET, P_TA, P_ST, L_IDENT, L_CDEB,
			         P_CDUR, 0,
			         decode( P_CHTYP, '0',
			                 decode( P_NUMERO_PASSE, 1, 0, P_CUSAG ),
			                 0 ),
			         decode( P_CHTYP, '2',
			                 decode( P_NUMERO_PASSE, 1, 0, P_CUSAG ),
			                 0 ) );
			P_RESULT := 'I';
		else
			P_RESULT := 'U';
		end if;
		return;

	exception

		when CONSTRAINT_VIOLATION then

			-- Trés certainement à cause de rpeta. Soit problème dans
			-- le fichier PMW (segment G, I, J incohérants) Soit
			-- problème sur les clé étrangère type d'étapes et
			-- ressources. La vrai cause du problème a été stockée
			-- dans BATCH_ETAPE_BAD et/ou dans BATCH_TACHE_BAD
			-- et/ou dans BATCH_CONS_SSTACHE_RES_BAD
			-- ------------------------------------------------------
			if P_NUMERO_PASSE = 1 then
				insert into BATCH_REJETSRP
				( PID, ECET, ACTA, ACST, IDENT, ERRMSG )
				VALUES ( P_PID, P_ET, P_TA, P_ST, P_IDENT,
				         'REJET POUR AFFECTATION ABSENTE' );
			end if;
			P_RESULT := 'R';
			return;

		when others then

			TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [' || L_STATEMENT || '] : ' ||
			               ' (PID=' || P_PID || ', ET=' || P_ET || ', TA=' ||
			               P_TA || ', ST=' || P_ST || ', IDENT=' || P_IDENT ||
			               ', CDEB=' || P_CDEB ||') : ' || SQLERRM );
			raise CALLEE_FAILED;

	end LOAD_CONSO_INIT_RAF;

	-- ------------------------------------------------------------------
	-- RPINIT_AND_RPRAF
	--           prise en compte PMW : prise en compte des consommations
	--           de type 0 et 2
	-- ------------------------------------------------------------------
	-- ATTENTION : $rpinit et $rpraf sont deux programme identique à la
	-- virgule près sauf que :
	--      1   - $rpinit concerne chinit (avec les segments PMW J0 alors
	--            que $rpraf concerne chraf avec les segments PMW J2
	--      2   - $rpinit prend en entrée SA0 alors que $rpraf prend SA2
	--      3   - SA0 est constitué avec le filtre reptest. SA4 aurait pu
	--            sauf que l'appel est en commentaire !
	-- ------------------------------------------------------------------
	-- voir aussi signature MLC19990330_REPTEST
	-- ------------------------------------------------------------------
	-- Deux passes : une pour remettre à zéro et une pour cumuler car
	-- on veut cumuler les doublons d'un traitements mais pas avec les
	-- données du traitements d'avant !
	-- ------------------------------------------------------------------
	-- ATTENTION : LA PRISE EN COMPTE DU RESTE-A-FAIRE NE FILTRE PAS AVEC
	-- LE TEST DE LA MORT QUI TUE MORTELLEMENT : REPTEST. C'EST PAS
	-- CONFONDRE AVEC LA CHINIT
	-- ------------------------------------------------------------------
	-- En focus on part du SAx : extraction de PMW_CONSOMM avec
	-- restrictions suivantes :
	--      - Le fameux test REPTEST pour refuser de prendre en compte
	--        certaines consommmations ($rpinit)
	--      - Elimination des code BIP pour lesquels la remontée s'est
	--        effetuée avec une mauvaise version de PMW-Turbo Pascal
	--      - Uniquement les consommations de type 0 ($rpinit) 1 ($rpraf)
	--      - Elimination des consommations nulles
	-- ------------------------------------------------------------------
	-- A la différence de $rpcons, si on ne trouve pas CDEB dans
	-- calendrier on n'en fait pas un fromage, on prend 21 jours ouvrés.
	-- Nota : il y a d'autres différences (beaucoup plus importantes,
	-- comme par exemple le test qui va provoquer un éclatement en
	-- plusieurs mois et qui n'est pas le même dans rpcons et rpinit,
	-- ce qui signifie qu'à CDEB, CDUR et CUSAG identiques, la création
	-- ou non de ligne CDEB+n dépend de CHTYP) (sans parler, si quand
	-- même, du fait que rpinit définit une notion de charge journalière
	-- traduisant le travail à XX% dont rpcons se moque comme de sa
	-- première chemise)
	-- ------------------------------------------------------------------
	-- $rpinit et $rpraf sont deux programmes (suite du commentaires
	-- finalement supprimée...)
	-- ------------------------------------------------------------------
	-- ATTENTION : PAC. Les calculs focus sont fait trés délicat à
	-- reproduire en SQL : On ne sait pas trops qu'elle est la
	-- signification PRECISE du type D8.2. Je penche pour
	-- l'hypothèse suivante : 8 chiffres significatifs, mais
	-- format d'affichage avec deux décimales. Cela expliquerait
	-- pourquoi un CUSAG de 1 et un CDUR de 220 donne une charge
	-- journalière non nulle. Ce type de comportement n'est pas
	-- facile à reproduire en SQL car il faudrait effectuer un
	-- arrondi dépendant du nombre de chiffre significatif du résultat !
	-- Solution actuelle : étant donné que le problème ne semble
	-- apparaître que pour les charges journalières trés petites
	-- du type 0,00xxxxx
	-- on demande à ORACLE une précision maximale
	-- -----------------------------------------------------------------
	procedure RPINIT_AND_RPRAF( P_HFILE in utl_file.file_type ) is

		L_PROCNAME varchar2( 32 ) := 'RPINIT_AND_RPRAF';
		L_STATEMENT varchar2( 128 );

		L_DATDBX date;           -- date du début de l'exercice
		L_MAXNUMTP char(2);      -- version courante attendue pour PMWBIPVERS
		L_DAT0101AN date;        -- le 01/01 de l'année de l'exercice
		L_DAT0101ANM1 date;      -- le 01/01 de l'année d'avant celle de l'exercice
		L_JOUROUVRES number;     -- jour ouvrés de CDEB jusqu'à la fin du mois
		L_CJOUR number;           -- nombre de jour ouvrés d'un mois dans calendrier
		L_CHARGE_ONE_MONTH number( 8, 2 ); -- mis en base pour un mois
		L_CHARGE_ALL_MONTH number( 8, 2 ); -- cumul du déjà affecté
		L_DUREE_NON_AFFECTEE number;       -- jour ouvrés non encore chargés
		L_NEXT_MONTH date;                 -- un des mois suivants celui de CDEB
		L_CHARGE_MOYENNE number;           -- CUSAG / CDUR, précision maximale
		                                   -- CUSAG = 1, CDUR = 220 ==> 0,00454545...

		L_NUMERO_PASSE pls_integer;    -- passe 1 : remise à 0, passe 2 : cumul

		L_RESULT char( 1 );           -- résultat essai d'insert
		L_INSERTED pls_integer;       -- compte insert
		L_UPDATED pls_integer;        -- compte update
		L_REJECT pls_integer;         -- compte rejets
		L_SPLIT_INSERTED pls_integer; -- compte insert répartition
		L_SPLIT_UPDATED pls_integer;  -- compte update répartition
		L_SPLIT_REJECT pls_integer;   -- compte rejets répartition
		L_TOTALCONSO pls_integer;     -- compte ligne du curseur

		cursor C_NEW_INRA is select PMW_CONSOMM.PID, CCET, CCTA, CCST,
		                            CIRES , CDEB, CDUR, CUSAG, CHTYP
		                     from PMW_CONSOMM, BATCH_HDLA, PMW_LIGNE_BIP
		                     where PMW_CONSOMM.PID = BATCH_HDLA.PID and
		                           PMW_CONSOMM.PID = PMW_LIGNE_BIP.PID and
		                           PMWBIPVERS =  L_MAXNUMTP and
		                           ( CHTYP = '0' or CHTYP = '2' ) and
		                           CUSAG <> 0 and
		                           REPTEST( CHTYP, TOTALCHINIT, TOTALCHRAF, CDEB, 'true' ) = 'O';

	begin

		-- Trace Start
		-- -----------
		TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

		-- recupere la date de début de l'exercice en cours
		-- ------------------------------------------------
		L_STATEMENT := 'Recherche date début d''exercice';
		CALCDATDBX( P_HFILE, L_DATDBX );
		TRCLOG.TRCLOG( P_HFILE, 'Début d''exercice : ' ||
		                        to_char( L_DATDBX, 'DD/MM/YYYY' ) );

		-- valorise les deux dates '01/01/yyyy'
		-- ------------------------------------
		G_DAT0101AN   := trunc( L_DATDBX, 'year' );
		G_DAT0101ANM1 := add_months( G_DAT0101AN, -12);

		-- recupere le filtre sur la version Turbo Pascal
		-- ----------------------------------------------
		L_STATEMENT := 'Calcul version actuelle';
		select max( NUMTP) into L_MAXNUMTP from VERSION_TP;
		if L_MAXNUMTP is null then
			raise_application_error( ERR_FONCTIONNELLE_ID,
							 'max(NUMTP) from VERSION_TP est null !', true );
		else
			TRCLOG.TRCLOG( P_HFILE, 'Version PMW-BIP de référence : ' || L_MAXNUMTP );
		end if;

		L_STATEMENT := 'Ouverture Curseur des Consommations (passe 1)';
		L_NUMERO_PASSE := 1;

		<<one_more_time>>

		L_INSERTED    := 0;
		L_UPDATED     := 0;
		L_REJECT      := 0;
		L_SPLIT_INSERTED := 0;
		L_SPLIT_UPDATED  := 0;
		L_SPLIT_REJECT   := 0;
		L_TOTALCONSO     := 0;

		-- boucle de prise en compte des consommations
		-- -------------------------------------------
		for ONE_INRA in C_NEW_INRA loop

			L_TOTALCONSO := L_TOTALCONSO + 1;

--	DEBUGING CODE
--			if ONE_INRA.PID <> 'A24' or ONE_INRA.CHTYP <> '2' or
--			   ONE_INRA.CIRES <> '08505*' or
--			   ONE_INRA.CDEB <> to_date( '01/01/1999', 'DD/MM/YYYY' ) then
--				goto END_LOOP_RPINIRAF;
--			end if;
--	DEBUGING CODE

			-- recherche du nb de jour ouvrés total théorique
			-- ----------------------------------------------
			L_CJOUR := GET_CJOUR( P_HFILE, ONE_INRA.CDEB );

			-- Analyse du cas
			-- --------------
			L_JOUROUVRES := CALCJOUROUVR( P_HFILE, ONE_INRA.CDEB );

			-- si la durée est plus petite ou égale, on balance tout et c'est fini
			-- -------------------------------------------------------------------
			if ONE_INRA.CDUR <= L_JOUROUVRES then

				LOAD_CONSO_INIT_RAF( P_HFILE,
				                     ONE_INRA.PID, ONE_INRA.CCET, ONE_INRA.CCTA,
				                     ONE_INRA.CCST, ONE_INRA.CIRES, ONE_INRA.CDEB,
				                     L_CJOUR, ONE_INRA.CUSAG, ONE_INRA.CHTYP,
				                     L_RESULT, L_NUMERO_PASSE );

				if L_RESULT = 'I' then
					L_INSERTED := L_INSERTED + 1;
				else
					if L_RESULT = 'U' then
						L_UPDATED := L_UPDATED + 1;
					else
						L_REJECT := L_REJECT + 1;
					end if;
				end if;

			else

				-- il FAUT étaler sur plusieurs mois
				-- ---------------------------------
				-- On commence par remplir le premier mois
				-- ---------------------------------------
				-- Reproduction de l'algo focus qui garantit une
				-- sous-estimation systématique des charges afin
				-- d'éviter un reliquat négatif sur le dernier
				-- mois : trunc au lieu de round pour la charge
				-- a affecter
				-- ---------------------------------------------
				L_CHARGE_MOYENNE := ONE_INRA.CUSAG / ONE_INRA.CDUR;
				L_CHARGE_ONE_MONTH :=  trunc( L_CHARGE_MOYENNE * L_JOUROUVRES, 2 );
				LOAD_CONSO_INIT_RAF( P_HFILE,
				                     ONE_INRA.PID, ONE_INRA.CCET, ONE_INRA.CCTA,
				                     ONE_INRA.CCST, ONE_INRA.CIRES, ONE_INRA.CDEB,
				                     L_CJOUR, L_CHARGE_ONE_MONTH, ONE_INRA.CHTYP,
				                     L_RESULT, L_NUMERO_PASSE );

				if L_RESULT = 'I' then
					L_INSERTED := L_INSERTED + 1;
				else
					if L_RESULT = 'U' then
						L_UPDATED := L_UPDATED + 1;
					else
						L_REJECT := L_REJECT + 1;
						-- Ajout manuel L. 20-05-1999 : comme en focus
						-- on n'essaye pas de traiter la suite de la
						-- répartition : ca ne va pas le faire, donc
						-- on passe à l'enreg. suivant
						-- -------------------------------------------
						goto END_LOOP_RPINIRAF;
					end if;
				end if;

				-- initialise compteurs
				-- --------------------
				L_CHARGE_ALL_MONTH := L_CHARGE_ONE_MONTH;
				L_DUREE_NON_AFFECTEE := ONE_INRA.CDUR - L_JOUROUVRES;
				L_NEXT_MONTH := trunc( add_months( ONE_INRA.CDEB, 1 ), 'month' );

				-- On boucle tant qu'il reste une période non chargée
				-- --------------------------------------------------
				while L_DUREE_NON_AFFECTEE > 0 loop

					L_CJOUR := GET_CJOUR( P_HFILE, L_NEXT_MONTH );
					if L_DUREE_NON_AFFECTEE <= L_CJOUR then

						-- C'est le dernier mois, on balance le reste
						-- ------------------------------------------
						LOAD_CONSO_INIT_RAF( P_HFILE,
						                     ONE_INRA.PID, ONE_INRA.CCET,
						                     ONE_INRA.CCTA, ONE_INRA.CCST,
						                     ONE_INRA.CIRES, L_NEXT_MONTH,
						                     L_CJOUR,
						                     ONE_INRA.CUSAG - L_CHARGE_ALL_MONTH,
						                     ONE_INRA.CHTYP, L_RESULT,
						                     L_NUMERO_PASSE );

						if L_RESULT = 'I' then
							L_SPLIT_INSERTED := L_SPLIT_INSERTED + 1;
						else
							if L_RESULT = 'U' then
								L_SPLIT_UPDATED := L_SPLIT_UPDATED + 1;
							else
								L_SPLIT_REJECT := L_SPLIT_REJECT + 1;
								-- Ajout manuel L. 20-05-1999 : comme en focus
								-- on n'essaye pas de traiter la suite de la
								-- répartition : ca ne va pas le faire, donc
								-- on passe à l'enreg. suivant.
								-- Remarque (en passant) : ce code ne
								-- normalement pas être atteint, puisque le
								-- goto est codé à la première tentative
								-- -------------------------------------------
								goto END_LOOP_RPINIRAF;
							end if;
						end if;

						-- force la sortie de boucle
						-- -------------------------
						exit;

					else

						-- on charge le mois
						-- -----------------
						L_CHARGE_ONE_MONTH :=
						        trunc(  L_CHARGE_MOYENNE * L_CJOUR, 2 );
						LOAD_CONSO_INIT_RAF( P_HFILE,
						                     ONE_INRA.PID, ONE_INRA.CCET,
						                     ONE_INRA.CCTA, ONE_INRA.CCST,
						                     ONE_INRA.CIRES, L_NEXT_MONTH,
						                     L_CJOUR, L_CHARGE_ONE_MONTH,
						                     ONE_INRA.CHTYP, L_RESULT,
						                     L_NUMERO_PASSE );
						if L_RESULT = 'I' then
							L_SPLIT_INSERTED := L_SPLIT_INSERTED + 1;
						else
							if L_RESULT = 'U' then
								L_SPLIT_UPDATED := L_SPLIT_UPDATED + 1;
							else
								L_SPLIT_REJECT := L_SPLIT_REJECT + 1;
								-- Ajout manuel L. 20-05-1999 : comme en focus
								-- on n'essaye pas de traiter la suite de la
								-- répartition : ca ne va pas le faire, donc
								-- on passe à l'enreg. suivant.
								-- Remarque (en passant) : ce code ne
								-- normalement pas être atteint, puisque le
								-- goto est codé à la première tentative
								-- -------------------------------------------
								goto END_LOOP_RPINIRAF;
							end if;
						end if;
						-- les compteurs
						-- -------------
						L_CHARGE_ALL_MONTH := L_CHARGE_ALL_MONTH +
						                      L_CHARGE_ONE_MONTH;
						L_DUREE_NON_AFFECTEE := L_DUREE_NON_AFFECTEE -
						                        L_CJOUR;
						L_NEXT_MONTH := add_months( L_NEXT_MONTH, 1 );

					end if; -- if dernier mois

				end loop; -- loop si reste duréee non chargée

			end if; -- if tout tient sur le premier mois

			-- ********************
			-- FIN DE BOUCLE
			-- ********************
			<<END_LOOP_RPINIRAF>>
			null;

		end loop; -- curseur conso init

		if L_NUMERO_PASSE = 1 then
			L_STATEMENT := 'Ouverture Curseur des Consommations (passe 2)';
			L_NUMERO_PASSE := 2;
			goto ONE_MORE_TIME;
		end if;

		-- Rapport détaillé
		-- ----------------
		TRCLOG.TRCLOG( P_HFILE, 'Lignes parcourues (Curseur): ' || L_TOTALCONSO );
		TRCLOG.TRCLOG( P_HFILE, 'Lignes insérées (Date d''origine) : ' || L_INSERTED );
		TRCLOG.TRCLOG( P_HFILE, 'Lignes mises à jour (Date d''origine) : ' || L_UPDATED );
		TRCLOG.TRCLOG( P_HFILE, 'Lignes insérées (Répartition) : ' || L_SPLIT_INSERTED );
		TRCLOG.TRCLOG( P_HFILE, 'Lignes mises à jour (Répartition) : ' || L_SPLIT_UPDATED );
		TRCLOG.TRCLOG( P_HFILE, 'Lignes rejetées (Date d''origine) : ' || L_REJECT );
		TRCLOG.TRCLOG( P_HFILE, 'Lignes rejetées (Répartition) : ' || L_SPLIT_REJECT );

		commit;

		-- Trace Stop
		-- ----------
		TRCLOG.TRCLOG( P_HFILE, 'Fin normale de ' || L_PROCNAME  );

	exception

		when others then
			if sqlcode <> CALLEE_FAILED_ID then
				TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [' || L_STATEMENT ||
				               '] : ' || SQLERRM );
			end if;
			TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
			raise CALLEE_FAILED;

	end RPINIT_AND_RPRAF;

	-- ------------------------------------------------------------------
	-- RPDATE  : mise à jour du segment ETAPE avec les nouvelles dates
	--           mini et maxi de début et de fin des sous-taches de
	--           l'étape (dates initiales et dates révisées)
	-- ------------------------------------------------------------------
	-- PERFORMANCE : UPDATE DE JOINTURE A ESSAYER
	-- ------------------------------------------------------------------
	procedure RPDATE( P_HFILE in utl_file.file_type ) is

		L_PROCNAME varchar2(16) := 'RPDATE';
		L_STATEMENT varchar2(64);

		L_MAXNUMTP char(2);   -- version courante attendue pour PMWBIPVERS

	begin

		-- Trace Start
		-- -----------
		TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

		-- recupere le filtre sur la version Turbo Pascal
		-- ----------------------------------------------
		L_STATEMENT := 'Calcul version actuelle';
		select max( NUMTP) into L_MAXNUMTP from VERSION_TP;
		if L_MAXNUMTP is null then
			raise_application_error( ERR_FONCTIONNELLE_ID,
							 'max(NUMTP) from VERSION_TP est null !', true );
		else
			TRCLOG.TRCLOG( P_HFILE, 'Version PMW-BIP de référence : ' || L_MAXNUMTP );
		end if;

		-- recalcule les dates des étapes pour laquelle
		-- le PID était présent dans la remontée
		-- --------------------------------------------
		L_STATEMENT := 'Update Dates Etapes';
		update ETAPE
		set ( EDEB, EFIN, ENDE, ENFI ) =
		    ( select min( ADEB ), max( AFIN ), min( ANDE ), max( ANFI )
		      from tache where ETAPE.PID = TACHE.PID and
		                       ETAPE.ECET = TACHE.ECET )
		where PID in ( select PID from PMW_LIGNE_BIP
	                     where PMWBIPVERS = L_MAXNUMTP );
		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows updated' );

		-- Trace Stop
		-- ----------
		TRCLOG.TRCLOG( P_HFILE, 'Fin normale de ' || L_PROCNAME  );

	exception

		when others then

			if sqlcode <> CALLEE_FAILED_ID then
				TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [' || L_STATEMENT ||
				               '] : ' || SQLERRM );
			end if;
			TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
			raise CALLEE_FAILED;

	end RPDATE;

	-- -------------------------------------------------------------------
	-- RPSSTRT : mettre à jour la table SSTRT en fonction du contenu de
	--           proj. Cette table ne sert certainement à rien d'un point
	--           de vue FONCTIONNEL(comme de NOMBREUSES autres tables).
	--           Elle existe sous focus pour des raison de performance.
	--           Procédure reprise à l'identique sous oracle pour la
	--           raison fondamentale suivante : ET POURQUOI PAS ?
 	-- -------------------------------------------------------------------
	-- AUSSI : mettre des cusag a 0 si c'est illégal
 	-- -------------------------------------------------------------------
	-- Question : les traitements précédants testent parfois la valeur de
	-- CUSAG, ne devrait-on pas inverser l'ordre des traitements.
	-- Réponse : et ta soeur ?
 	-- -------------------------------------------------------------------
 	-- LE RAPPORT $RPSSTRT ne donnne pas lieu à constitution d'une table
	-- dédiée : le contenu de SSTRT permet de le reconstituer
	-- -------------------------------------------------------------------
	-- le source focus fabrique un fichier temporaire qui permet
	--            - edition de $rpsstrt
	--            - alimentation de SSTRT
	--            - mise à zéro de cusag
	-- Le traitement ci-dessous est architecturé autrement : le fichier
	-- temporaire est remplacé par une requête ensembliste d'alimentation
	-- de SSTRT. Cette table servira à l'édition du rapport et SERT à
	-- la mise à zéro des CUSAG. POUR CE FAIRE il a été nécessaire
	-- d'enrichir chaque ligne de SSTRT avec les informations de clé
	-- primaires qui manquaient pour attaquer CONS_SSTACHE_RES_MOIS en
	-- mise à jour. Il s'agit de la triplette Etape, Tache, SsTache.
	-- -------------------------------------------------------------------
	procedure RPSSTRT( P_HFILE utl_file.file_type ) is

		L_PROCNAME varchar2(16) := 'RPSSTRT';
		L_STATEMENT varchar2(64);

		L_MOISTRT number( 2 );
		L_ANTRT number( 4 );
		L_FDOTY date; -- First Day Of The Year (yeah, man)

	begin

		-- Trace Start
		-- -----------
		TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

		-- "destruction" de la table SSTRT
		-- -------------------------------
		L_STATEMENT := 'Truncate SSTRT';
		DYNA_TRUNCATE( 'SSTRT' );

		-- recherche année de traitement
		-- -----------------------------
		CALCDATTRT( P_HFILE, L_MOISTRT, L_ANTRT );
		L_FDOTY := trunc( to_date( L_ANTRT, 'YYYY'), 'year' );
		TRCLOG.TRCLOG( P_HFILE, 'Traitement avec date début au ' || L_FDOTY );

		-- ajout des anomalies
		-- -------------------

		-- ---------------------------------------------------------------
		-- on ne fait le contrôle de sous-traitance correcte  que pour les
		-- CDEB "récentes", d'un autre côté, la mensuelle des données de
		-- décembre tourne en janvier (si tout va bien, poil au
		-- métatarsien), donc, petite bidouille (limite grosse bidouille)
		-- en focus, à grand coup de date système et de test à la noix (du
		-- genre : est-ce que, par le plus grand des hasards, on ne serait
		-- pas en janvier ? Si ? Zut ! bonne année quand même !)
		-- ---------------------------------------------------------------
		-- ce point DEVRAIT être pris en compte par la jolie technique
		-- "année du mois précédant la date de la prochaine mensuelle",
		-- qui est utilisée par ailleurs dans d'autres procédures, mais
		-- le programmeur de $rpsstrt est arrivé après le début de la
		-- séance : il a raté la pub.
		-- ---------------------------------------------------------------
		-- 01/04/1999. Je craque : ce point EST (en SQL) pris en compte
		-- par la technique évoquée.
		-- ---------------------------------------------------------------
		-- On ajoute dans SSTRT les consommations non nulles sur des
		-- taches de sous-traitances, si le projet pour lequel on bosse a
		-- un statut non blanc et si on la date de pose de ce statut est
		-- une année antérieure (on peut consommer en sous-traitance toute
		-- l'année de la pose du statut : on ne s'occupe pas du jour et du
		-- mois de la pose de statut par rapport au mois de consommation).
		-- Cette recherche de consommation "invalide" ne s'effectue que
		-- pour les consommations de l'année de traitement
		-- ---------------------------------------------------------------
		-- PERFORMANCES
		-- OPTIMISATION POSSIBLE : par exemple, insérer avec un libellé
		-- LIBDSG à null pour éviter jointure STRUCT_INFO alors qu'on est
		-- dans un full-scan de filtre puis passer un update ensembliste
		-- sur SSTRT, ("quelques" lignes insérées seulement)
		-- REMARQUE : LA JOINTURE SUR STRUCT_INFO POURRAIT CERTAINEMENT
		-- ETRE FAITE AU MOMENT DE L'UTILISATION DE LA TABLE
		-- ---------------------------------------------------------------
		L_STATEMENT := 'Insert SSTRT';
		insert into SSTRT ( PID, PDSG, AISTPID,
		                    TIRES, CDEB, CUSAG, ASTATUT,
					  ADATESTATUT, LIBDSG, ECET, ACTA, ACST, PNOM,MOTIF_REJET )
		select A.PID, A.CODSG, AISTPID, IDENT, CDEB, CUSAG, B.ASTATUT,
		       B.ADATESTATUT, LIBDSG, C.ECET, C.ACTA, C.ACST, A.PNOM,'I'
		from LIGNE_BIP A, LIGNE_BIP B, TACHE T, CONS_SSTACHE_RES_MOIS C,
		     STRUCT_INFO S
		where A.PID = T.PID   and         -- jointure proj - tache
		      T.AISTTY = 'FF' and         -- filtre sous-traitance
		      T.ECET = C.ECET and         -- jointure tache - conso
		      T.ACTA = C.ACTA and         --        idem
		      T.ACST = C.ACST and         --        idem
		      T.PID  = C.PID  and         --        idem
		      C.CUSAG <> 0    and         -- filtre consommation nulle
		      trunc( C.CDEB, 'year' ) >=
		      L_FDOTY         and         -- filtre conso de l'année
		      T.AISTPID = B.PID and       -- jointure tache-proj
		      B.ASTATUT <> '  ' and       -- filtre statut non blanc
		      B.ADATESTATUT < L_FDOTY           and       -- filtre statut de l'année
		      A.CODSG = S.CODSG;          -- jointure proj - struct_info
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows inserted' );

  -- Ajout des projets sous-traités inexistants
		L_STATEMENT := 'Insert SSTRT projets sous-traites inexistants';
		insert into SSTRT ( PID, PDSG, AISTPID,
		                    TIRES, CDEB, CUSAG,
					   LIBDSG, ECET, ACTA, ACST, PNOM, MOTIF_REJET )
		select  A.PID, A.CODSG, AISTPID, IDENT, CDEB, CUSAG, LIBDSG, C.ECET, C.ACTA, C.ACST, A.PNOM,'I'
		from LIGNE_BIP A,TACHE T, CONS_SSTACHE_RES_MOIS C,
		     STRUCT_INFO S
		where A.PID = T.PID   and         -- jointure proj - tache
		      T.AISTTY = 'FF' and         -- filtre sous-traitance
		      T.ECET = C.ECET and         -- jointure tache - conso
		      T.ACTA = C.ACTA and         --        idem
		      T.ACST = C.ACST and         --        idem
		      T.PID  = C.PID  and         --        idem
		      C.CUSAG <> 0    and         -- filtre consommation nulle
		      trunc( C.CDEB, 'year' ) >= L_FDOTY         and         -- filtre conso de l'année
		      T.AISTPID not in (select pid from ligne_bip) and       -- jointure tache-proj
		      A.CODSG = S.CODSG;

		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows inserted' );
                       
      -- Ajout des lignes de sous traitance de type T9
		L_STATEMENT := 'Insert SSTRT ligne sous traitance de type T9';
		insert into SSTRT ( PID, PDSG, AISTPID,
		                    TIRES, CDEB, CUSAG,
					   LIBDSG, ECET, ACTA, ACST, PNOM,MOTIF_REJET )
		select  A.PID, A.CODSG, AISTPID, IDENT, CDEB, CUSAG, LIBDSG, C.ECET, C.ACTA, C.ACST, A.PNOM,'Q'
		from LIGNE_BIP A,TACHE T, CONS_SSTACHE_RES_MOIS C, LIGNE_BIP A2,
		     STRUCT_INFO S
		where A.PID = T.PID   and         -- jointure proj - tache
		      T.AISTTY = 'FF' and         -- filtre sous-traitance
		      T.ECET = C.ECET and         -- jointure tache - conso
		      T.ACTA = C.ACTA and         --        idem
		      T.ACST = C.ACST and         --        idem
		      T.PID  = C.PID  and         --        idem
		      C.CUSAG <> 0    and         -- filtre consommation nulle
		      trunc( C.CDEB, 'year' ) >= L_FDOTY         and         -- filtre conso de l'année
		      T.AISTPID = A2.PID and
              A2.typproj = '9' and
		      A.CODSG = S.CODSG;

		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows inserted' );

		-- Utilisation de la technique "mise à jour de jointure" pour
		-- changer un peu.
		-- ----------------------------------------------------------
		L_STATEMENT := 'Mise à zéro des CUSAG en erreur';
		update ( select C.CUSAG from SSTRT S, CONS_SSTACHE_RES_MOIS C
		         where S.PID = C.PID and
		               S.ECET = C.ECET and
		               S.ACTA = C.ACTA and
		               S.ACST = C.ACST and
		               S.TIRES = C.IDENT and
		               S.CDEB = C.CDEB )
		set CUSAG = 0;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows updated' );

		commit;

		-- Trace Stop
		-- ----------
		TRCLOG.TRCLOG( P_HFILE, 'Fin normale de ' || L_PROCNAME  );

	exception

		when others then

			if sqlcode <> CALLEE_FAILED_ID then
				TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [' || L_STATEMENT ||
				               '] : ' || SQLERRM );
			end if;
			TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
			raise CALLEE_FAILED;

	end RPSSTRT;

	-- -------------------------------------------------------------------
	-- P_PROPLUS : Créer from scratch COMPLUS, qui ajouté à une sauvegarde
	--             de PROPLUS pour les années antérieures (ANTPLUS), va
	--             devenir le nouveau PROPLUS
	-- -------------------------------------------------------------------
	-- ATTENTION : sous focus, l'année est codée en dur. Le changement de
	-- la date n'est "traditionnelement" fait qu'en avril ! Il se trouve
	-- que les diverses situations présentes pour une ressource dans RES
	-- ne sont pas "forcément" cohérentes. De plus, l'algorithme qui
	-- "filtre" les situations utilise intensivement le 01/01 de l'année
	-- codée en dur comme "date pivot". En conséquence, il est probable
	-- que le PROPLUS qui serait calculé fin janvier APRES UN CHANGEMENT
	-- DE DATE PIVOT et le PROPLUS qui est calculé fin avril après un
	--  changement de date pivot (après la mensuelle de début avril) NE
	-- DONNERAIENT pas les même résultats Y COMPRIS POUR les données des
	-- premiers mois de l'année CETTE AFFIRMATION REPOSE SUR LE FAIT QUE
	-- LE FILTRE SUR LES SITUATIONS NE DONNERAIT PAS LE MEME RESULTAT POUR
	-- LES SITUATIONS INCOHERENTES. Dans l'optique d'une reproduction
	-- fidèle des traitements focus, ce traitement utilise lui aussi le
	-- pivot d'Avril (PREMIERE ACTIVATION FIN AVRIL/DEBUT MAI).
	-- Selection des situations à prendre en compte :
	--      1° : toutes les situations de la table SITU_RESS
	--      2°   Pour chaque ident, s'il existe des situations à date de
	--           début strictement inférieure au 01/01/AA, alors il ne
	--           faut garder que LA situation de la plus grande de début
	--           (dans le paquet des situations de date de début
	--           inférieure à 01/01/AA)
	--      3° : Pour chaque ident, s'il existe une situation de date de
	--           début strictement inférieure à 01/01/AA alors elle est
	--           unique en vertu du paragraphe précédent. Il faut
	--           l'enlever, si, pour l'Ident, il existe aussi une
	--           situation à date de début EGALE au 01/01/AA.
	--      4° : Pour chaque ident, s'il existe une situation de date de
	--           début strictement inférieure à 01/01/AA ET avec une
	--           date de départ également strictement inférieure au
	--           01/01/AA, alors elle est unique et elle vient peut être
	--           d'être éliminée par le paragraphe précédent. Il faut en
	--           tout cas l'éliminer s'il n'existe pas de situation avec
	--           date de début strictement supérieure au 01/01/AA.
	-- -------------------------------------------------------------------
	-- Résumé, en gros  : On essaye de ne garder que les situations
	-- pertinentes, on enlève tout ce qui est vieux si on peut trouver une
	-- "prise de relai" au 01/01/AA. Sans prise de relai au 01/01/AA, on
	-- ne vire que si la date de départ est vieille ET si il existe quand
	-- même un relai après le 01/01/AA. On garde des vieilles situations
	-- "non relayées"
	-- -------------------------------------------------------------------
	-- Extractions à l'origine de COMPLUS
	--
	--   1° : Dans les Conso, On "group by" par PID, IDENT, CDEB et
	--        "type de sous-tache" et on additionne CUSAG, CHINIT et.
	--        CHRAF.
	--
	--   2° : De nombreuses colonnes sont en double : on a les données du
	--        PID et les données du PID sous-traité. On commence par faire
	--        comme s'il n' y avait pas de sous-traitance et on passera un
	--        update plus tard pour la sous-traitance
	--
	--   3° : On ne fait tout ça que pour les CDEB >= année de traitement
	-- -------------------------------------------------------------------
	procedure P_PROPLUS( P_HFILE utl_file.file_type ) is

		L_PROCNAME varchar2( 16 ) := 'P_PROPLUS';
		L_STATEMENT varchar2( 96 );

		-- ********************        -- **********************************
		-- ********** *********        -- mois de bascule, si avril, l'année
		-- *********   ********        -- "change" à partir de la première
		-- ********  *  *******        -- pré-mensuelle de fin avril (pour
		-- *******   *   ******        -- les données d'avril)
		-- ******    *    *****        -- **********************************
		-- *****     *     ****
		-- ****             ***
		-- ***       *       **
		-- **                 *
		-- ********************
		-- ********************
		L_MOIS_BASCULE number := 4;

		L_BORNE_SUP number;      -- si 1996 on supprime 96, 97, 98, ....
		L_BORNE_INF number;      -- si 1996 on supprime 96, 95, 94, ....
		L_BORNE_SUP_DT date;     -- L_BORNE_SUP en tant que date
		L_BORNE_INF_DT date;     -- L_BORNE_INF en tant que date

		L_MOISTRT number;
		L_ANTRT number;

	begin

		-- Trace Start
		-- -----------
		TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );






    
    ----------------------------------------------------------------------------------------
    -- ZAA KRA PPM 63403 -	Suppression de la table PROPLUS_BACK   
    ----------------------------------------------------------------------------------------
    
    L_STATEMENT := 'Truncate PROPLUS_BACK';
		DYNA_TRUNCATE( 'PROPLUS_BACK' );

		
    ----------------------------------------------------------------------------------------
    -- ZAA KRA PPM 63403 -Alimentation de la table PROPLUS_BACK à partir de la table PROPLUS  
    ----------------------------------------------------------------------------------------
     L_STATEMENT := 'Insert dans PROPLUS_BACK';
     
     INSERT INTO PROPLUS_BACK PROPLUS_BACK(FACTPID,PID,
                                          AIST,
                                          AISTTY,
                                          TIRES,
                                          CDEB,
                                          PTYPE,
                                          FACTPTY,
                                          PNOM,
                                          FACTPNO,
                                          PDSG,
                                          FACTPDSG,
                                          PCPI,
                                          FACTPCP,
                                          PCMOUVRA,
                                          FACTPCM,
                                          PNMOUVRA,
                                          PDATDEBPRE,
                                          CUSAG,
                                          RNOM,
                                          RPRENOM,
                                          DATDEP,
                                          DIVSECGROU,
                                          CPIDENT,
                                          COUT,
                                          MATRICULE,
                                          SOCIETE,
                                          QUALIF,
                                          DISPO,
                                          CHINIT,
                                          CHRAF,
                                          RTYPE) SELECT * FROM PROPLUS;
     
     
     COMMIT;
     ---------------------------------------------------------------------------------------
     
		L_STATEMENT := 'Recherche mois de traitement';
		CALCDATTRT( P_HFILE, L_MOISTRT, L_ANTRT );
		TRCLOG.TRCLOG( P_HFILE, 'Traitement au titre du mois ' ||
		               L_MOISTRT || ' de ' || L_ANTRT );

		-- calcul des années de bornes en fonctions
		-- du mois pivot
		-- ----------------------------------------
--		if L_MOISTRT < L_MOIS_BASCULE then
--			L_BORNE_SUP := L_ANTRT - 1;
--		else
			L_BORNE_SUP := L_ANTRT;   -- on n'utilise plus d'annee pivot
--		end if;
		L_BORNE_INF := L_BORNE_SUP - 12;   -- 98 ==> on supprime 86
		L_BORNE_SUP_DT := to_date( '01/01/' || to_char( L_BORNE_SUP, 'FM0000' ),
		                           'DD/MM/YYYY' );
		L_BORNE_INF_DT := to_date( '01/01/' || to_char( L_BORNE_INF, 'FM0000' ),
		                           'DD/MM/YYYY' );

		-- Supression des données de l'année courante
		-- PERFORMANCES : ON POURRAIT FAIRE UN
		-- CREATE AS AVEC FILTRE POUR SIMULER LA
		-- TECHNIQUE PROPLUS = ANTPLUS + COMPLUS
		-- ------------------------------------------
		-- WARNING : ROLL-BACK SEGMENT
		-- ------------------------------------------
		TRCLOG.TRCLOG( P_HFILE, 'Dates bornes : ' || L_BORNE_INF || ', ' ||
		               'L_BORNE_SUP' );
		L_STATEMENT := 'Delete Années de PROPLUS';


		-- DBT: Ajout de Denis Blanc-Tranchant le 29091999
		-- on droppe les indexes pour gagner en performance
		DYNA_DROP_IND('PROPLUS_IDX2');
		DYNA_DROP_IND('PROPLUS_IDX3');
		DYNA_DROP_IND('PROPLUS_IDX4');
		DYNA_DROP_IND('PROPLUS_IDX5');
		DYNA_DROP_IND('PROPLUS_IDX6');

		delete from PROPLUS
		where ( trunc( CDEB, 'year' ) >= L_BORNE_SUP_DT );

            -- or( trunc( CDEB, 'year' ) <= L_BORNE_INF_DT );
		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows deleted' );


		-- PERFORMANCE : IL EXISTE UN POINT A PARTIR DU QUEL IL VAUT MIEUX
		-- FAIRE DU PROCEDURAL NORMALEMENT COMPLEXE QUE DE L'ENSEMBLISTE
		-- DELIRANT (EN PARTICULIER SI ON COMMENCE A EMPILER LES SUB-QUERY
		-- CORRELLEES)
		--               une petite voix, au fond : oui, quand ?
		-- ---------------------------------------------------------------
		-- PERFORMANCE : TENTATIVE DE COMPROMIS : TABLES INTERMEDIAIRES.
		-- On introduit un peu de procédural en travailant par étape mais
		-- chaque étape est composées de requêtes ensembliste
		-- ---------------------------------------------------------------

		-- Etape 1 : préparation de la liste des situations valides
		-- On reproduit focus
		-- 2001 : code entierement refait en utilisant SITU_RESS_FULL
		-- Tout est dans PACKBATCH4.Maj_situation_Proplus
		-- --------------------------------------------------------

		-- Etape 2 : préparation de la liste des consommés à inclure dans
		-- proplus pour le compte de ce traitement. Performance : on fait
		-- comme s'il n'y avait aucune sous-traitance. On passera un
		-- Update pour la sous traitance
		-- --------------------------------------------------------------
		-- Le code focus utilise le type d'étape dans un "group by"
		-- sur les sous-taches de même AIST, PID, TIRES ! Plutôt que
		-- de prendre le type de l'étape dont le rang au carré est le
		-- plus proche de la racine cubique du quantième, on va prendre
		-- la valeur max (plutôt).
		-- --------------------------------------------------------------
		L_STATEMENT := 'Truncate BATCH_PROPLUS_COMPLUS';
		DYNA_TRUNCATE( 'BATCH_PROPLUS_COMPLUS' );

		L_STATEMENT := 'Insert dans BATCH_PROPLUS_COMPLUS';
		insert into BATCH_PROPLUS_COMPLUS
		( PID,
		  AIST,
		  AISTTY,
		  TIRES,
		  CDEB,
		  PTYPE,
		  PNOM,
		  PDSG,
		  PCPI,
		  PCMOUVRA,
		  PDATDEBPRE,
		  PNMOUVRA,
		  FACTPID,
		  FACTPTY,
		  FACTPNO,
		  FACTPDSG,
		  FACTPCP,
		  FACTPCM,
		  RNOM,
		  RPRENOM,
              RTYPE,
		  DATDEP,
		  DIVSECGROU,
		  CPIDENT,
		  COUT,
		  MATRICULE,
		  SOCIETE,
		  QUALIF,
		  DISPO,
		  CUSAG,
		  CHINIT,
		  CHRAF )
		select
		  CONSO.PID,
		  CONSO.AIST,
		  substr( CONSO.AIST, 1, 2 ),
		  CONSO.IDENT,
		  CONSO.CDEB,
		  BIP.TYPPROJ,
		  BIP.PNOM,
		  BIP.CODSG,
		  BIP.PCPI,
		  BIP.CLICODE,
		  BIP.PDATDEBPRE,
		  BIP.PNMOUVRA,
		  CONSO.PID,  -- FACTPID
		  BIP.TYPPROJ,  -- FACTPTY
		  BIP.PNOM,   -- FACTPNO
		  BIP.CODSG,  -- FACTPDSG
		  BIP.PCPI,   -- FACTPCP
		  BIP.CLICODE, -- FACTPCM
		  RES.RNOM,
		  RES.RPRENOM,
              RES.RTYPE,
		  null,       -- SITU.DATDEP
		  null,       -- SITU.CODSG focus res DIVSECGROU
		  null,       -- SITU.CPIDENT
		  null,       -- SITU.COUT
		  RES.MATRICULE,
		  null,       -- SITU.SOCCODE focus res SOCIETE
		  null,       -- SITU.PRESTATION focus res QUALIF
		  null,       -- SITU.DISPO
		  CONSO.CUSAG,
		  CONSO.CHINIT,
		  CONSO.CHRAF
		from LIGNE_BIP BIP, CENTRE_ACTIVITE ACTI, RESSOURCE RES,
		     ( select C.PID as PID, T.AIST as AIST, C.IDENT as IDENT,
		              C.CDEB as CDEB, sum( cusag ) as CUSAG,
		              sum( CHINIT ) as CHINIT, sum( CHRAF ) as CHRAF
		       from ETAPE E, TACHE T, CONS_SSTACHE_RES_MOIS C
		       where E.PID = T.PID and
		             E.ECET = T.ECET and
		             T.PID = C.PID and
		             T.ECET = C.ECET and
		             T.ACTA = C.ACTA and
		             T.ACST = C.ACST and
		             CDEB >= L_BORNE_SUP_DT
		       group by C.PID, T.AIST, C.IDENT, C.CDEB ) CONSO
		where BIP.PID = CONSO.PID and
		      BIP.CODCAMO = ACTI.CODCAMO and
		      CONSO.IDENT = RES.IDENT;
		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows inserted' );

		-- Pour chaque consommation, on cherche la situation a prendre en
		-- compte
		PACKBATCH4.Maj_Situation_Proplus( P_HFILE );

		-- On change les données 'FACT' de PID vers
		-- PID de sous-traitance chaque fois qu'il
		-- y a sous-traitance
		-- ----------------------------------------
		L_STATEMENT := 'Mise à jour données de Sous-Traitance';
		update BATCH_PROPLUS_COMPLUS
		set (
		  FACTPID,
		  FACTPTY,
		  FACTPNO,
		  FACTPDSG,
		  FACTPCP,
		  FACTPCM ) =
		( select PID, TYPPROJ, PNOM, CODSG, PCPI, CLICODE
		  from LIGNE_BIP BIP,
                   CENTRE_ACTIVITE ACTI
		  where rtrim(substr( BATCH_PROPLUS_COMPLUS.AIST, 3, 4 )) = BIP.PID
              and   (AISTTY = 'FF' or AISTTY = 'DC')
              and   BIP.CODCAMO = ACTI.CODCAMO )
		where AISTTY = 'FF' or
		      AISTTY = 'DC';
		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows updated' );

		-- On balance le résultat dans PROPLUS
		-- -----------------------------------
		L_STATEMENT := 'Insert dans PROPLUS';
		insert into PROPLUS
		( PID,
		  AIST,
		  AISTTY,
		  TIRES,
		  CDEB,
		  PTYPE,
		  PNOM,
		  PDSG,
		  PCPI,
		  PCMOUVRA,
		  PDATDEBPRE,
		  PNMOUVRA,
		  FACTPID,
		  FACTPTY,
		  FACTPNO,
		  FACTPDSG,
		  FACTPCP,
		  FACTPCM,
		  RNOM,
		  RPRENOM,
              RTYPE,
		  DATDEP,
		  DIVSECGROU,
		  CPIDENT,
		  COUT,
		  MATRICULE,
		  SOCIETE,
		  QUALIF,
		  DISPO,
		  CUSAG,
		  CHINIT,
		  CHRAF )
		select
		  PID,
		  AIST,
		  AISTTY,
		  TIRES,
		  CDEB,
		  PTYPE,
		  PNOM,
		  PDSG,
		  PCPI,
		  PCMOUVRA,
		  PDATDEBPRE,
		  PNMOUVRA,
		  FACTPID,
		  FACTPTY,
		  FACTPNO,
		  FACTPDSG,
		  FACTPCP,
		  FACTPCM,
		  RNOM,
		  RPRENOM,
              RTYPE,
		  DATDEP,
		  DIVSECGROU,
		  CPIDENT,
		  COUT,
		  MATRICULE,
		  SOCIETE,
		  QUALIF,
		  DISPO,
		  CUSAG,
		  CHINIT,
		  CHRAF
		from BATCH_PROPLUS_COMPLUS bpc
       -- Modification pour ne pas prendre
       -- en compte les ressources 0
       -- et les consommés de ressources
       -- sans situations excepte pour la 2222
            where bpc.tires <> 0
            and   (bpc.tires = 2222
                   or bpc.datsitu is not null
		  	 or bpc.cusag<>0);
		commit;
		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : ' || sql%rowcount ||
		               ' rows inserted' );

		-- DBT: Ajout de Denis Blanc-Tranchant le 29091999
		-- on reconstruit les indexes de PROPLUS 'DROPPES' avant le 'Delete Années'
		DYNA_CREATE_IND('PROPLUS','PROPLUS_IDX2','TIRES','ASC', 'INITIAL 1024 K NEXT 1024 K PCTINCREASE 0');
		DYNA_CREATE_IND('PROPLUS','PROPLUS_IDX3','PID','ASC', 'INITIAL 1024 K NEXT 1024 K PCTINCREASE 0');
		DYNA_CREATE_IND('PROPLUS','PROPLUS_IDX4','FACTPID','ASC', 'INITIAL 1024 K NEXT 1024 K PCTINCREASE 0');
		DYNA_CREATE_IND('PROPLUS','PROPLUS_IDX5','QUALIF','ASC', 'INITIAL 1024 K NEXT 1024 K PCTINCREASE 0');
		DYNA_CREATE_IND('PROPLUS','PROPLUS_IDX6','RTYPE','ASC', 'INITIAL 1024 K NEXT 1024 K PCTINCREASE 0');

		TRCLOG.TRCLOG( P_HFILE, L_STATEMENT || ' : creation des indexes PROPLUS_IDX2...5');

			-- Trace Stop
		-- ----------
		TRCLOG.TRCLOG( P_HFILE, 'Fin normale de ' || L_PROCNAME  );

	exception

		when others then

			if sqlcode <> CALLEE_FAILED_ID then
				TRCLOG.TRCLOG( P_HFILE, L_PROCNAME || ' [' || L_STATEMENT ||
				               '] : ' || SQLERRM );
			end if;
			TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
			raise CALLEE_FAILED;

	end P_PROPLUS;

	-- ##################################################################################################
PROCEDURE purge_rejet_datestatut( P_HFILE utl_file.file_type ) IS
		l_statement     VARCHAR2(255);
	BEGIN
--	Purge des precedents consommes rejetes
		TRCLOG.TRCLOG( P_HFILE, '*** Debut de purge_rejet_datestatut ***');

		l_statement:='Purge de BATCH_REJET_DATESTATUT';
		TRCLOG.TRCLOG( P_HFILE,l_statement);
		DELETE batch_rejet_datestatut;
		COMMIT;

		l_statement:='Purge de ETAPE_REJET_DATESTATUT';
		TRCLOG.TRCLOG( P_HFILE,l_statement);
		DELETE ETAPE_REJET_DATESTATUT;
		COMMIT;

		l_statement:='Purge de TACHE_REJET_DATESTATUT';
		TRCLOG.TRCLOG( P_HFILE,l_statement);
		DELETE tache_rejet_datestatut;
		COMMIT;

		l_statement:='Purge de CONS_SSTRES_REJET_DATESTATUT';
		TRCLOG.TRCLOG( P_HFILE,l_statement);
		DELETE cons_sstres_rejet_datestatut;
		COMMIT;

		l_statement:='Purge de CONS_SSTRES_M_REJET_DATESTATUT';
		TRCLOG.TRCLOG( P_HFILE,l_statement);
		DELETE cons_sstres_m_rejet_datestatut;
		COMMIT;

-- purge des TABLES de sauvegarde
		l_statement:='Purge de etape_back';
		TRCLOG.TRCLOG( P_HFILE,l_statement);
		DELETE etape_back;
		COMMIT;

		l_statement:='Purge de tache_back';
		TRCLOG.TRCLOG( P_HFILE,l_statement);
		DELETE tache_back;
		COMMIT;

		l_statement:='Purge de cons_sstache_res_back';
		TRCLOG.TRCLOG( P_HFILE,l_statement);
		DELETE cons_sstache_res_back;
		COMMIT;

		l_statement:='Purge de cons_sstache_res_mois_back';
		TRCLOG.TRCLOG( P_HFILE,l_statement);
		DELETE cons_sstache_res_mois_back;
		COMMIT;

		TRCLOG.TRCLOG( P_HFILE, '*** Fin de purge_rejet_datestatut ***');

	EXCEPTION
		WHEN OTHERS THEN
		TRCLOG.TRCLOG( P_HFILE, '!!! Fin anormale de la purge des tables de rejet en fonction de la datestatut !!!');
		TRCLOG.TRCLOG( P_HFILE, SQLERRM);
		TRCLOG.TRCLOG( P_HFILE, l_statement);
		RAISE;
	END purge_rejet_datestatut;

-- ##################################################################################################
PROCEDURE rejet_datestatut( P_HFILE utl_file.file_type ) IS

		l_moismens_moins1	DATE;
		l_moismens	DATE;
		l_annee		DATE;
		l_statement	VARCHAR2(2000);

	BEGIN
		TRCLOG.TRCLOG( P_HFILE, '*** Debut de la procedure rejet_datestatut ***');

		l_statement:='Lecture de DATDEBEX';
		TRCLOG.TRCLOG( P_HFILE,l_statement) ;
		SELECT add_months(moismens,-1), datdebex,moismens INTO l_moismens_moins1, l_annee,l_moismens FROM datdebex;


		-- Insertion des donnees rejetees dans BATCH_REJET_DATESTATUT
		l_statement :='Insertion dans BATCH_REJET_DATESTATUT';
		TRCLOG.TRCLOG( P_HFILE,l_statement) ;
		/* 1er cas : on supprime les lignes bip (pas vrai : dont le statut est DEMARRE
		et) dont la DATE de statut est antérieure au mois de traitement -1
		*/
		INSERT INTO  BATCH_REJET_DATESTATUT (PID,AIST,ECET,ACTA,ACST,ADEB,AFIN,ANDE,ANFI,ADUR,APCP,ASTA,ASNOM,
		TPLAN,TACTU,TEST,ASTATUT,ADATESTATUT,CIRES,CUSAG,CDEB,MOISMENS,SSTRAIT)
		SELECT DISTINCT  lb.PID, pmw.aist,pmw.ACET,pmw.ACTA,pmw.ACST,pmw.ADEB,pmw.AFIN,pmw.ANDE,pmw.ANFI,pmw.ADUR,pmw.APCP,pmw.ASTA,
		pmw.asnom,af.TPLAN,af.TACTU,af.TEST,lb.astatut,lb.adatestatut,cons.cires,cons.cusag,cons.cdeb,dx.moismens,'N'
		FROM PMW_ACTIVITE pmw,pmw_affecta af, LIGNE_BIP lb,pmw_consomm cons,datdebex dx
		WHERE lb.PID = pmw.PID
		AND cons.pid=pmw.pid
		AND cons.ccet=pmw.acet
		AND cons.ccta=pmw.acta
		AND cons.ccst=pmw.acst
		AND pmw.pid=af.pid
		AND af.tcet=pmw.acet
		AND af.tcta=pmw.acta
		AND af.tcst=pmw.acst
		AND af.tires=cons.cires
		AND (lb.adatestatut <= add_months(dx.moismens,-1)
-- AND  lb.astatut ='D'
                 )
		;
		COMMIT;

		/* 2eme cas : on supprime les lignes bip qui ont de la sous traitance avec (non : un statut DEMARRE)
		et une DATE de statut antérieure au mois de traitement -1
		*/
		INSERT INTO  BATCH_REJET_DATESTATUT (PID,AIST,ECET,ACTA,ACST,ADEB,AFIN,ANDE,ANFI,ADUR,APCP,ASTA,ASNOM,
		TPLAN,TACTU,TEST,ASTATUT,ADATESTATUT,CIRES,CUSAG,CDEB,MOISMENS,SSTRAIT)
		SELECT  DISTINCT  lb.PID, pmw.aist,pmw.ACET,pmw.ACTA,pmw.ACST,pmw.ADEB,pmw.AFIN,pmw.ANDE,pmw.ANFI,pmw.ADUR,pmw.APCP,pmw.ASTA,
		pmw.asnom,af.TPLAN,af.TACTU,af.TEST,lb.astatut,lb.adatestatut,cons.cires,cons.cusag,cons.cdeb,dx.moismens,'O'
 		 from PMW_ACTIVITE pmw,pmw_affecta af,LIGNE_BIP lb,pmw_consomm cons,datdebex dx
  		where lb.PID = pmw.PID
  		AND pmw.pid=cons.pid
  		AND cons.ccet=pmw.acet
		AND cons.ccta=pmw.acta
		AND cons.ccst=pmw.acst
		AND pmw.pid=af.pid
		AND af.tcet=pmw.acet
		AND af.tcta=pmw.acta
		AND af.tcst=pmw.acst
		AND af.tires=cons.cires
  		AND  (lb.adatestatut IS NULL OR lb.adatestatut > add_months(dx.moismens,-1))
  		AND (( SUBSTR(pmw.aist,0,2)='FF' AND RTRIM(SUBSTR(pmw.aist,3,4)) IN
    			(SELECT bip.pid FROM ligne_bip bip,datdebex
                         WHERE
			 bip.adatestatut <= add_months(dx.moismens,-1))
		    )
		   )
  		 ;
  		 COMMIT;

  		-- Suppression des lignes concernees de la table pmw_consomm

  		l_statement:='Rejet des enregistrements sur lignes D ou A dans les tables PMW_ ';
		TRCLOG.TRCLOG( P_HFILE,l_statement) ;

		DELETE FROM pmw_consomm
		WHERE  pid IN (SELECT rej.pid FROM BATCH_REJET_DATESTATUT rej WHERE
			pmw_consomm.cires=rej.cires
			AND pmw_consomm.ccet=rej.ecet
			AND pmw_consomm.ccta=rej.acta
			AND pmw_consomm.ccst=rej.acst
			)
			;
		COMMIT;

		-- Suppression des lignes concernees de la table pmw_activite
		DELETE FROM pmw_activite
		WHERE  pid IN (SELECT rej.pid FROM BATCH_REJET_DATESTATUT rej WHERE
			pmw_activite.aist=rej.aist
			AND pmw_activite.acet=rej.ecet
			AND pmw_activite.acta=rej.acta
			AND pmw_activite.acst=rej.acst
			)
			;
		COMMIT;

		-- Suppression des lignes concernees de la table pmw_affecta
		DELETE FROM pmw_affecta
		WHERE  pid IN (SELECT rej.pid FROM BATCH_REJET_DATESTATUT rej WHERE
			pmw_affecta.tires=rej.cires
			AND pmw_affecta.tcet=rej.ecet
			AND pmw_affecta.tcta=rej.acta
			AND pmw_affecta.tcst=rej.acst
			)
			;
		COMMIT;

		-- Suppression des lignes concernees de la table pmw_ligne_bip
		DELETE FROM pmw_ligne_bip
		WHERE  pid IN (SELECT pid FROM BATCH_REJET_DATESTATUT
				WHERE sstrait='N')
		;

		COMMIT;

  		/*SAUVEGARDE DE ETAPE TACHE CONS_SSTACHE_RES CONS_SSTACHE_RES_MOIS !!!
  		(c'est mieux pour eviter de faire un export de la base de prod quand le traitement plante !*/

  		l_statement:='Sauvegarde des tables de consommes';
		TRCLOG.TRCLOG( P_HFILE,l_statement) ;

  		INSERT INTO etape_back(ECET,EDUR,ENFI,ENDE,EDEB,EFIN,PID,TYPETAP)
  		        (SELECT ECET,EDUR,ENFI,ENDE,EDEB,EFIN,PID,TYPETAP FROM etape);
  		COMMIT;

  		INSERT INTO tache_back(ACTA,ACST,AISTTY,AISTPID,ADEB,AFIN,ANDE,ANFI,ADUR,APCP,ASNOM,ASTA,AIST,PID,ECET,CDEB_MAX,MOTIF_REJET)
  		 	(SELECT ACTA,ACST,AISTTY,AISTPID,ADEB,AFIN,ANDE,ANFI,ADUR,APCP,
  		 	ASNOM,ASTA,AIST,PID,ECET,CDEB_MAX,MOTIF_REJET FROM tache);
		COMMIT;

  		INSERT INTO cons_sstache_res_back(TPLAN,TACTU,TEST,PID,ECET,ACTA,ACST,IDENT)
	  		 (SELECT TPLAN,TACTU,TEST,PID,ECET,ACTA,ACST,IDENT FROM cons_sstache_res);
		COMMIT;

  		INSERT INTO cons_sstache_res_mois_back(CDEB,CDUR,CUSAG,CHRAF,CHINIT,PID,ECET,ACTA,ACST,IDENT)
  			 (SELECT CDEB,CDUR,CUSAG,CHRAF,CHINIT,PID,ECET,ACTA,ACST,IDENT FROM cons_sstache_res_mois);
		COMMIT;

  		/*on recupere les donnees de tache et etape :
  		on prend dans TACHE les lignes bip avec une ss traitance dont (le statut est demarre et) la datestatut < moismens -1
  		*/

  		l_statement:='Sauvegarde des consommes sur lignes demarrees ou abandonnees';
		TRCLOG.TRCLOG( P_HFILE,l_statement) ;

  		INSERT INTO TACHE_REJET_DATESTATUT (ACTA,ACST,AISTTY,AISTPID,ADEB,AFIN,ANDE,ANFI,ADUR,
  		APCP,ASNOM,ASTA,AIST,PID,ECET,ECET_NEW,ACTA_NEW,ACST_NEW)
  		SELECT  DISTINCT  t.ACTA,t.acst,t.aistty,t.aistpid,t.adeb,t.afin,t.ande,t.anfi,t.adur,
  		t.apcp,t.asnom,t.asta,t.aist,t.PID,t.ecet,t.ecet,t.acta,t.acst
		FROM  tache t,LIGNE_BIP lb,datdebex dx
		WHERE  lb.PID = t.PID
  			AND  (lb.adatestatut IS NULL OR lb.adatestatut > add_months(dx.moismens,-1))
			AND ((SUBSTR(t.aist,0,2)='FF' AND RTRIM(t.aistpid) IN
       				(SELECT bip.pid FROM ligne_bip bip,datdebex
                                  WHERE
		       		 bip.adatestatut <= add_months(dx.moismens,-1))
     		 		)
     			)
     		;
     		COMMIT;

  		--insertion dans ETAPE_REJET_DATESTATUT des données concernant les lignes du 2eme cas
  		l_statement :='Insertion dans ETAPE_REJET_DATESTATUT';
  		INSERT INTO ETAPE_REJET_DATESTATUT (ECET,EDUR,ENFI,ENDE,EDEB,EFIN,PID,TYPETAP,ECET_NEW)
  		SELECT DISTINCT et.ECET,et.EDUR,et.ENFI,et.ENDE,et.EDEB,et.EFIN,et.PID,et.TYPETAP,et.ECET
  		FROM etape et,TACHE_REJET_DATESTATUT rej
  		WHERE  et.PID=rej.pid
		AND et.ecet=rej.ecet
  		;
  		COMMIT;


  		--insertion dans CONS_SSTRES_REJET_DATESTATUT des données concernant les lignes du 2eme cas
  		l_statement :='Insertion dans CONS_SSTRES_REJET_DATESTATUT';
  		INSERT INTO CONS_SSTRES_REJET_DATESTATUT (TPLAN,TACTU,TEST,PID,ECET,ACTA,ACST,IDENT,ECET_NEW,ACTA_NEW,ACST_NEW)
  		SELECT DISTINCT t.TPLAN,t.TACTU,t.TEST,t.PID,t.ECET,t.ACTA,t.ACST,t.IDENT,t.ecet,t.acta,t.acst
  		FROM cons_sstache_res t,TACHE_REJET_DATESTATUT rej
  		WHERE  t.PID=rej.pid
		AND t.ecet=rej.ecet
		AND t.acta=rej.acta
		AND t.acst=rej.acst
     		;
  		COMMIT;

  		--insertion dans CONS_SSTRES_M_REJET_DATESTATUT des données concernant les lignes du 2eme cas
  		l_statement :='Insertion dans CONS_SSTRES_M_REJET_DATESTATUT';
  		INSERT INTO CONS_SSTRES_M_REJET_DATESTATUT (CDEB,CDUR,CUSAG,CHRAF,CHINIT,PID,
  		ECET,ACTA,ACST,IDENT,ECET_NEW,ACTA_NEW,ACST_NEW)
  		SELECT DISTINCT t.CDEB,t.CDUR,t.CUSAG,t.CHRAF,t.CHINIT,t.PID,t.ECET,t.ACTA,t.ACST,t.IDENT,t.ecet,t.acta,t.acst
  		FROM cons_sstache_res_mois t,TACHE_REJET_DATESTATUT rej
  		WHERE  t.PID=rej.pid
		AND t.ecet=rej.ecet
		AND t.acta=rej.acta
		AND t.acst=rej.acst
     		;
  		COMMIT;


		TRCLOG.TRCLOG( P_HFILE, '*** Fin de la procedure rejet_datestatut ***');
	EXCEPTION
		WHEN OTHERS THEN
		TRCLOG.TRCLOG( P_HFILE, '!!! Fin anormale de la procedure rejet_datestatut !!!');
		TRCLOG.TRCLOG( P_HFILE, SQLERRM);
		TRCLOG.TRCLOG( P_HFILE, l_statement);
		RAISE;

END rejet_datestatut;

-- ##################################################################################################
--	Copie des donnees rejetees par rejet_datestatut pour les lignes avec sous traitance
-- ##################################################################################################
PROCEDURE copie_datestatut( P_HFILE utl_file.file_type ) IS
l_statement	VARCHAR2(255);
L_ORAERRMSG VARCHAR2(128);
L_INSERTED pls_integer;
L_REJECTED pls_integer;
L_UPDATED pls_integer;
l_ecet	VARCHAR2(4);
l_acta  VARCHAR2(4);
L_ACST	VARCHAR2(4);

BEGIN
TRCLOG.TRCLOG( P_HFILE, 'Debut insertion donnees concernant les lignes avec ss traitance et datestatut < moismens -1 ');

l_statement:='Insertion dans ETAPE';
L_INSERTED := 0;
L_REJECTED := 0;
L_ECET:='00';
L_ACTA:='00';
L_ACST:='00';

DECLARE
L_PID etape.pid%type;
MAX_ECET EXCEPTION;

 /* curseur pour insertion dans ETAPE
 On sélectionne toutes les etapes à reinserer en se basant sur le pid, le numero d'etape
 et le type d'etape (important pour les calculs FI / Immo) */

CURSOR C_ETAPE IS
	SELECT DISTINCT rej.PID,rej.ECET, rej.EDUR,rej.EDEB,rej.EFIN,rej.ENDE,rej.ENFI,rej.TYPETAP
	FROM etape_rejet_datestatut rej
	MINUS
	SELECT  e.pid,e.ecet,e.edur,e.edeb,e.efin,e.ende,e.enfi,e.typetap
	FROM  etape e;


  BEGIN

  FOR ONE_ETAPE IN C_ETAPE LOOP
     	BEGIN
     		BEGIN

     			/* On verifie que le couple pid,ecet n'est pas deja utilise */
     			SELECT pid  INTO l_pid FROM Etape
     			WHERE etape.pid=ONE_ETAPE.PID
     			AND etape.ecet=ONE_ETAPE.ecet;


		     	/* Si le couple est pris, on insert les enregistrements dans etape après avoir recalculé le numero d'etape */
     			SELECT TO_CHAR(MAX(TO_NUMBER(ecet)) + 1,'000') INTO l_ecet
     			FROM etape e
     			WHERE one_etape.pid=e.pid;

     			L_ECET:=LTRIM(RTRIM(L_ECET));


     			IF TO_NUMBER(l_ecet,'000')>99 THEN
     				-- On ne peut etendre le numero d etape... l'enregistrement est rejete...
     				RAISE MAX_ECET;
     			END IF;


     			INSERT  INTO  ETAPE ( PID, ECET, EDUR, EDEB, EFIN, ENDE, ENFI,TYPETAP)
     			VALUES (ONE_ETAPE.PID,
     				L_ECET,
     				ONE_ETAPE.EDUR,
     				ONE_ETAPE.EDEB,
     				ONE_ETAPE.EFIN,
     				ONE_ETAPE.ENDE,
     				ONE_ETAPE.ENFI,
     				ONE_ETAPE.TYPETAP);

     				L_INSERTED := L_INSERTED + 1;


     			-- On met à jour le nouveau N° d'etape dans les tables de sauvegarde.
     			-- Ce numero est la nouvelle reference.

     			UPDATE etape_rejet_datestatut e
     			SET ECET_NEW=L_ECET
     			WHERE one_etape.pid=e.pid
     			AND one_etape.ecet=e.ecet;


			-- On met a jour la table tache_rejet_datestatut
			-- si des enregistrements sont rattaches à l'ancien N° d'etape


 			UPDATE tache_rejet_datestatut t
     			SET ECET_NEW=L_ECET
     			WHERE one_etape.pid=t.pid
     			AND one_etape.ecet=t.ecet
     			;

     			IF SQL%NOTFOUND THEN
     				-- on arrête la mise a jour
     				L_PID :='RAS';
     			ELSE
     				-- on met à jour le nouveau n° etape pour les affectations

    				UPDATE CONS_SSTRES_REJET_DATESTATUT c
     				SET ECET_NEW=L_ECET
     				WHERE one_etape.pid=c.pid
     				AND one_etape.ecet=c.ecet
     				;

     				IF SQL%NOTFOUND THEN
     					-- on arrête la mise a jour
     					L_PID :='RAS';
     				ELSE
     					-- on met à jour le nouveau n° etape pour les consommes
     			     		UPDATE CONS_SSTRES_M_REJET_DATESTATUT c
     					SET ECET_NEW=L_ECET
     					WHERE one_etape.pid=c.pid
     					AND one_etape.ecet=c.ecet
     					;

					IF SQL%NOTFOUND THEN
     					-- on arrête la mise a jour
     					L_PID :='RAS';
					END IF;

     				END IF;

     			END IF;
     		EXCEPTION
     			WHEN NO_DATA_FOUND THEN
			/* Si le couple (pid,ecet) n'est pas pris, on insert les enregistrements directement dans etape */

     				INSERT  INTO  ETAPE ( PID, ECET, EDUR, EDEB, EFIN, ENDE, ENFI,TYPETAP)
     				VALUES (ONE_ETAPE.PID,
     				ONE_ETAPE.ECET,
     				ONE_ETAPE.EDUR,
     				ONE_ETAPE.EDEB,
     				ONE_ETAPE.EFIN,
     				ONE_ETAPE.ENDE,
     				ONE_ETAPE.ENFI,
     				ONE_ETAPE.TYPETAP);

     				L_INSERTED := L_INSERTED + 1;

     			WHEN OTHERS THEN

     				TRCLOG.TRCLOG( P_HFILE,'Probleme de reinsertion pour : '|| ONE_ETAPE.PID ||' , '||ONE_ETAPE.ECET || ' - erreur: ' ||SQLERRM);
     				TRCLOG.TRCLOG( P_HFILE, l_statement);
     		END;


     	EXCEPTION

     		--gestion des doublons : recuperation dans une TABLE de rejet
     		when CONSTRAINT_VIOLATION then
     				L_ORAERRMSG := sqlerrm;
     				-- DUPLICATION DE CODE POUR RAPPORT D'ERREUR
     				-- -----------------------------------------
     				insert into BATCH_ETAPE_BAD
     				( PID, ECET, EDUR, EDEB, EFIN, ENDE, ENFI,
     				  TYPETAP, ERRMSG )
     				VALUES (ONE_ETAPE.PID,
     			ONE_ETAPE.ECET,
     			ONE_ETAPE.EDUR,
     			ONE_ETAPE.EDEB,
     			ONE_ETAPE.EFIN,
     			ONE_ETAPE.ENDE,
     			ONE_ETAPE.ENFI,
     			ONE_ETAPE.TYPETAP,
     			SUBSTR(l_ORAERRMSG,1,127));
     				L_REJECTED := L_REJECTED + 1;

     		WHEN MAX_ECET THEN
     			TRCLOG.TRCLOG( P_HFILE, l_statement);
     			TRCLOG.TRCLOG( P_HFILE, '!!! Impossible de reinserer l etape...  PID: '||one_etape.pid||', N°: '||one_etape.ecet||' !!!');

     			insert into BATCH_ETAPE_BAD
     			( PID, ECET, EDUR, EDEB, EFIN, ENDE, ENFI,TYPETAP, ERRMSG )
     			VALUES (ONE_ETAPE.PID,
     			ONE_ETAPE.ECET,
     			ONE_ETAPE.EDUR,
     			ONE_ETAPE.EDEB,
     			ONE_ETAPE.EFIN,
     			ONE_ETAPE.ENDE,
     			ONE_ETAPE.ENFI,
     			ONE_ETAPE.TYPETAP,
     			'Erreur extension ecet');
     				L_REJECTED := L_REJECTED + 1;

     		WHEN OTHERS THEN
     		TRCLOG.TRCLOG( P_HFILE, 'Fin anormale de la reinsertion des enregistrements protégés pour ligne démarrée ou abandonnée');
     		TRCLOG.TRCLOG( P_HFILE, SQLERRM);
     		TRCLOG.TRCLOG( P_HFILE, l_statement);
     		RAISE;
     	END;
     COMMIT;
     L_ECET:='00';
END LOOP;
TRCLOG.TRCLOG( P_HFILE, 'Fin de la reinsertion des etapes');

END;
COMMIT;
TRCLOG.TRCLOG( P_HFILE, L_statement || ' : ' || L_INSERTED ||
		               ' rows inserted. ' || L_REJECTED || ' rows rejected.' );


--**********************************************************
-- Insertion des donnees dans tache
--**********************************************************
l_statement:='Insertion dans TACHE';
TRCLOG.TRCLOG( P_HFILE, l_statement);

L_INSERTED := 0;
L_REJECTED := 0;

DECLARE
L_PID tache.pid%type;
MAX_ACST EXCEPTION;

 /* curseur pour insertion dans TACHE
 On sélectionne toutes les taches à reinserer en se basant sur le pid, le numero d'etape, de tache,
 de sous-tache, le libelle et le type de sous-tache (important pour les calculs FI / Immo, etc.) */

CURSOR C_TACHE IS
	SELECT DISTINCT rej.ACTA,rej.ACST,rej.AISTTY,rej.AISTPID,rej.ADEB,rej.AFIN,rej.ANDE
			,rej.ANFI,rej.ADUR,rej.APCP,rej.ASNOM,rej.ASTA,rej.AIST,rej.PID,rej.ECET_NEW ecet
	FROM TACHE_REJET_DATESTATUT rej
	MINUS
	SELECT  ta.ACTA,ta.ACST,ta.AISTTY,ta.AISTPID,ta.ADEB,ta.AFIN,ta.ANDE
			,ta.ANFI,ta.ADUR,ta.APCP,ta.ASNOM,ta.ASTA,ta.AIST,ta.PID,ta.ECET ecet
	FROM  tache ta
	;

  BEGIN
  FOR ONE_TACHE IN C_TACHE LOOP
     	BEGIN
     		BEGIN
     			L_ACTA:=ONE_TACHE.acta;
     			L_ACST:=ONE_TACHE.acst;

     			/* On verifie que le quadruplet pid,ecet,acta,acst n'est pas deja utilise */
     			SELECT pid  INTO l_pid FROM tache
     			WHERE tache.pid=ONE_TACHE.PID
     			AND tache.ecet=ONE_TACHE.ecet
     			AND tache.acta=ONE_TACHE.acta
     			AND tache.acst=ONE_TACHE.acst;

     		/* Si le quadruplet est pris, on insert les enregistrements dans tache en recalculant n° tache voire sous-tache */

     			SELECT TO_CHAR(MAX(TO_NUMBER(acta)) + 1,'000') INTO l_acta
     			FROM tache t
     			WHERE one_tache.ecet=t.ecet
     			AND one_tache.pid=t.pid;


     			IF TO_NUMBER(l_acta,'000')>99 THEN

     				l_acta :=ONE_TACHE.ACTA;

     				SELECT TO_CHAR(MAX(TO_NUMBER(acst)) + 1,'000') INTO l_acst
     				FROM tache t
     				WHERE one_tache.ecet=t.ecet
     				AND one_tache.pid=t.pid
     				AND one_tache.acta=t.acta;

      				IF TO_NUMBER(l_acst,'000')>99 THEN
     					-- On ne peut etendre le numero de sous-tache... l'enregistrement est rejete...
     					RAISE MAX_ACST;
     				END IF;
     			END IF;

     			L_ACTA:=LTRIM(RTRIM(L_ACTA));
     			L_ACST:=LTRIM(RTRIM(L_ACST));

     			INSERT INTO TACHE (PID,ECET,ACTA,ACST,AISTTY,AISTPID,ADEB,AFIN,ANDE,ANFI,ADUR,APCP,ASNOM,ASTA,AIST)
			VALUES (ONE_TACHE.PID,ONE_TACHE.ECET,DECODE(l_acta,'00',ONE_TACHE.ACTA,l_acta),DECODE(l_acst,'00',ONE_TACHE.ACST,l_acst)
				,ONE_TACHE.AISTTY,ONE_TACHE.AISTPID,ONE_TACHE.ADEB,ONE_TACHE.AFIN,ONE_TACHE.ANDE,ONE_TACHE.ANFI
				,ONE_TACHE.ADUR,ONE_TACHE.APCP,ONE_TACHE.ASNOM,ONE_TACHE.ASTA,ONE_TACHE.AIST
         		       );

     			L_INSERTED := L_INSERTED + 1;

     			-- On met a jour les numero de tache et sous-tache
     			UPDATE tache_rejet_datestatut t
     			SET 	ACTA_NEW=DECODE(l_acta,'00',ONE_TACHE.ACTA,l_acta),
     				 ACST_NEW=DECODE(l_acst,'00',ONE_TACHE.ACST,l_acst)
     			WHERE one_tache.pid=t.pid
     			AND one_tache.ecet=t.ecet
     			AND one_tache.acta=t.acta
     			AND one_tache.acst=t.acst
     			;

    			UPDATE CONS_SSTRES_REJET_DATESTATUT c
     			SET 	ACTA_NEW=DECODE(l_acta,'00',ONE_TACHE.ACTA,l_acta),
     				ACST_NEW=DECODE(l_acst,'00',ONE_TACHE.ACST,l_acst)
     			WHERE one_tache.pid=c.pid
     			AND one_tache.ecet=c.ecet
     			AND one_tache.acta=c.acta
     			AND one_tache.acst=c.acst
     			;

     			IF SQL%NOTFOUND THEN
     				-- on arrête la mise a jour
     				L_PID :='RAS';
     			ELSE
     				-- on met à jour les nouveaux n° de tache et de sous-tache pour les consommes

     				UPDATE CONS_SSTRES_M_REJET_DATESTATUT c
     				SET 	ACTA_NEW=DECODE(l_acta,'00',ONE_TACHE.ACTA,l_acta),
     					ACST_NEW=DECODE(l_acst,'00',ONE_TACHE.ACST,l_acst)
     				WHERE one_tache.pid=c.pid
     				AND one_tache.ecet=c.ecet
     				AND one_tache.acta=c.acta
     				AND one_tache.acst=c.acst
     				;

				IF SQL%NOTFOUND THEN

     				L_PID :='RAS';
     				END IF;
     			END IF;
     		EXCEPTION

			WHEN NO_DATA_FOUND THEN
					INSERT INTO TACHE (PID,ECET,ACTA,ACST,AISTTY,AISTPID,ADEB,AFIN,ANDE,ANFI,ADUR,APCP,ASNOM,ASTA,AIST)
					VALUES (ONE_TACHE.PID,ONE_TACHE.ECET,ONE_TACHE.ACTA,ONE_TACHE.ACST,ONE_TACHE.AISTTY
					,ONE_TACHE.AISTPID,ONE_TACHE.ADEB,ONE_TACHE.AFIN,ONE_TACHE.ANDE,ONE_TACHE.ANFI
					,ONE_TACHE.ADUR,ONE_TACHE.APCP,ONE_TACHE.ASNOM,ONE_TACHE.ASTA,ONE_TACHE.AIST
                			);

     					L_INSERTED := L_INSERTED + 1;
			WHEN OTHERS THEN
					TRCLOG.TRCLOG( P_HFILE,'Probleme de reinsertion pour : '|| ONE_TACHE.PID ||' , '||ONE_TACHE.ECET || ' , ' ||ONE_TACHE.ACTA||','||ONE_TACHE.ACST||','||L_ACTA||','||L_ACST||' - erreur: ' ||SQLERRM);
     					TRCLOG.TRCLOG( P_HFILE, l_statement);



     		END;
     	EXCEPTION
     		--gestion des doublons : recuperation dans une TABLE de rejet
     		when CONSTRAINT_VIOLATION OR INDEX_PK_VIOLATION then
     				L_ORAERRMSG := sqlerrm;
     				-- DUPLICATION DE CODE POUR RAPPORT D'ERREUR
     				-- -----------------------------------------
     				INSERT INTO BATCH_TACHE_BAD(PID,ECET,ACTA,ACST,AISTTY,AISTPID,ADEB,AFIN,ANDE,ANFI,ADUR,APCP,ASNOM,ASTA,AIST,ERRMSG)
				VALUES (ONE_TACHE.PID,ONE_TACHE.ECET,ONE_TACHE.ACTA,ONE_TACHE.ACST,ONE_TACHE.AISTTY
					,ONE_TACHE.AISTPID,ONE_TACHE.ADEB,ONE_TACHE.AFIN,ONE_TACHE.ANDE,ONE_TACHE.ANFI
					,ONE_TACHE.ADUR,ONE_TACHE.APCP,ONE_TACHE.ASNOM,ONE_TACHE.ASTA,ONE_TACHE.AIST,
         		       		SUBSTR(l_ORAERRMSG,1,127));
     				L_REJECTED := L_REJECTED + 1;

     		WHEN MAX_ACST THEN

     			TRCLOG.TRCLOG( P_HFILE, l_statement);
     			TRCLOG.TRCLOG( P_HFILE, '!!! Impossible de reinserer la tache...  PID: '||one_tache.pid||', N° etape: '||one_tache.ecet||', N° tache: '||one_tache.acta||', N° sous-tache: '||one_tache.acst||' !!!');

     			INSERT INTO BATCH_TACHE_BAD(PID,ECET,ACTA,ACST,AISTTY,AISTPID,ADEB,AFIN,ANDE,ANFI,ADUR,APCP,ASNOM,ASTA,AIST,ERRMSG)
				VALUES (ONE_TACHE.PID,ONE_TACHE.ECET,ONE_TACHE.ACTA,ONE_TACHE.ACST,ONE_TACHE.AISTTY
					,ONE_TACHE.AISTPID,ONE_TACHE.ADEB,ONE_TACHE.AFIN,ONE_TACHE.ANDE,ONE_TACHE.ANFI
					,ONE_TACHE.ADUR,ONE_TACHE.APCP,ONE_TACHE.ASNOM,ONE_TACHE.ASTA,ONE_TACHE.AIST,
         		       		'Erreur extension acst');
     				L_REJECTED := L_REJECTED + 1;

     		WHEN OTHERS THEN
     		TRCLOG.TRCLOG( P_HFILE, 'Fin anormale de modif de la table des rejets concernant les lignes avec ss traitance dont datestatut < moismens -1');
     		TRCLOG.TRCLOG( P_HFILE, SQLERRM);
     		TRCLOG.TRCLOG( P_HFILE, l_statement);
     		RAISE;
     END;
     COMMIT;
     	l_acst := '00';
	l_acta := '00';
END LOOP;
TRCLOG.TRCLOG( P_HFILE, 'Fin de la reinsertion des taches');

END;
COMMIT;

TRCLOG.TRCLOG( P_HFILE, L_statement || ' : ' || L_INSERTED ||
		               ' rows inserted. ' || L_REJECTED || ' rows rejected.' );

/********************************************************
** Mise à jour des affectations
********************************************************/
L_INSERTED := 0;
L_REJECTED := 0;
l_statement:='Insertion dans CONS_SSTACHE_RES';
DECLARE

 /* curseur pour insertion dans CONS_SSTACHE_RES
 On sélectionne toutes les affectations à reinserer en se basant sur le pid, le numero d'etape, de tache,
 de sous-tache et l'identifiant de la ressource */

CURSOR C_AFFECTA IS
	SELECT rej.PID,rej.ECET_NEW,rej.ACTA_NEW,rej.ACST_NEW,rej.ident,rej.TPLAN,rej.TACTU,rej.TEST
	FROM CONS_SSTRES_REJET_DATESTATUT rej
	MINUS
	SELECT c.PID,c.ECET,c.ACTA,c.ACST,c.ident,c.TPLAN,c.TACTU,c.TEST
	FROM cons_sstache_res c;

BEGIN

     TRCLOG.TRCLOG( P_HFILE, l_statement);

     FOR ONE_AFFECTA IN C_AFFECTA LOOP
          	BEGIN
     		INSERT INTO CONS_SSTACHE_RES (PID,ECET,ACTA,ACST,IDENT,TPLAN,TACTU,TEST)
     		VALUES(ONE_AFFECTA.PID,ONE_AFFECTA.ECET_NEW,ONE_AFFECTA.ACTA_NEW,
     			ONE_AFFECTA.ACST_NEW,ONE_AFFECTA.ident,ONE_AFFECTA.TPLAN,
     			ONE_AFFECTA.TACTU,ONE_AFFECTA.TEST)
     		;

     		L_INSERTED := L_INSERTED + 1;

     		EXCEPTION
          		--gestion des doublons : recuperation dans une TABLE de rejet
          		when CONSTRAINT_VIOLATION OR INDEX_PK_VIOLATION then
          				L_ORAERRMSG := sqlerrm;
          				-- DUPLICATION DE CODE POUR RAPPORT D'ERREUR
          				-- -----------------------------------------
          				INSERT INTO BATCH_CONS_SSTACHE_RES_BAD(PID,ECET,ACTA,ACST,IDENT,TPLAN,TACTU,TEST,ERRMSG)
     					VALUES (ONE_AFFECTA.PID,ONE_AFFECTA.ECET_NEW,ONE_AFFECTA.ACTA_NEW,
     					ONE_AFFECTA.ACST_NEW,ONE_AFFECTA.ident,ONE_AFFECTA.TPLAN,
     					ONE_AFFECTA.TACTU,ONE_AFFECTA.TEST,SUBSTR(l_ORAERRMSG,1,127));
          				L_REJECTED := L_REJECTED + 1;

          		WHEN OTHERS THEN
          		TRCLOG.TRCLOG( P_HFILE, 'Fin anormale de modif de la table des rejets concernant les lignes avec ss traitance dont datestatut < moismens -1');
          		TRCLOG.TRCLOG( P_HFILE, SQLERRM);
          		TRCLOG.TRCLOG( P_HFILE, l_statement);
          		RAISE;

     		END;
     	END LOOP;
	COMMIT;
END;

TRCLOG.TRCLOG( P_HFILE, 'Fin d insertion dans cons_sstache_res');
TRCLOG.TRCLOG( P_HFILE, L_statement || ' : ' || L_INSERTED ||
		               ' rows inserted. ' || L_REJECTED || ' rows rejected.' );


/********************************************************
** Mise à jour des consommes
********************************************************/
L_INSERTED := 0;
L_REJECTED := 0;
L_UPDATED := 0;
l_statement:='Insertion dans CONS_SSTACHE_RES_MOIS';
DECLARE

 /* curseur pour insertion dans CONS_SSTACHE_RES_MOIS
 On sélectionne tous les consommes à reinserer en se basant sur le pid, le numero d'etape, de tache,
 de sous-tache, l'identifiant de la ressource et le mois */

CURSOR C_CONSOMMES IS
	SELECT rej.PID,rej.ECET_NEW,rej.ACTA_NEW,rej.ACST_NEW,rej.ident,rej.CDEB,rej.CUSAG
	FROM CONS_SSTRES_M_REJET_DATESTATUT rej
	MINUS
	SELECT c.PID,c.ECET,c.ACTA,c.ACST,c.ident,c.CDEB,c.CUSAG
	FROM cons_sstache_res_mois c;

BEGIN

     TRCLOG.TRCLOG( P_HFILE, l_statement);

     FOR ONE_CONSOMMES IN C_CONSOMMES LOOP
          	BEGIN

          	UPDATE CONS_SSTACHE_RES_MOIS c
          	SET c.CUSAG = NVL(c.CUSAG,0) + ONE_CONSOMMES.CUSAG
          	WHERE ONE_CONSOMMES.pid=c.pid
          	AND ONE_CONSOMMES.ecet_new=c.ecet
          	AND ONE_CONSOMMES.acta_new=c.acta
          	AND ONE_CONSOMMES.acst_new=c.acst
          	AND ONE_CONSOMMES.ident=c.ident
          	AND ONE_CONSOMMES.cdeb=c.cdeb;

          	L_UPDATED := L_UPDATED + 1;

          	IF SQL%NOTFOUND THEN

     			INSERT INTO CONS_SSTACHE_RES_MOIS (PID,ECET,ACTA,ACST,IDENT,CDEB,CUSAG)
     			VALUES(ONE_CONSOMMES.PID,ONE_CONSOMMES.ECET_NEW,ONE_CONSOMMES.ACTA_NEW,
     				ONE_CONSOMMES.ACST_NEW,ONE_CONSOMMES.ident,ONE_CONSOMMES.CDEB,
     				ONE_CONSOMMES.CUSAG);

     		L_INSERTED := L_INSERTED + 1;

     		END IF;
     		EXCEPTION
          		--gestion des doublons : recuperation dans une TABLE de rejet
          		when CONSTRAINT_VIOLATION  OR INDEX_PK_VIOLATION then
          				L_ORAERRMSG := sqlerrm;
          				-- DUPLICATION DE CODE POUR RAPPORT D'ERREUR
          				-- -----------------------------------------
          				INSERT INTO BATCH_CONS_SST_RES_M_BAD(PID,ECET,ACTA,ACST,IDENT,CDEB,CUSAG,ERRMSG)
     					VALUES (ONE_CONSOMMES.PID,ONE_CONSOMMES.ECET_NEW,ONE_CONSOMMES.ACTA_NEW,
     					ONE_CONSOMMES.ACST_NEW,ONE_CONSOMMES.ident,ONE_CONSOMMES.CDEB,
     					ONE_CONSOMMES.CUSAG,SUBSTR(l_ORAERRMSG,1,127));
          				L_REJECTED := L_REJECTED + 1;

          		WHEN OTHERS THEN
          		TRCLOG.TRCLOG( P_HFILE, 'Fin anormale de modif de la table des rejets concernant les lignes avec ss traitance dont datestatut < moismens -1');
          		TRCLOG.TRCLOG( P_HFILE, SQLERRM);
          		TRCLOG.TRCLOG( P_HFILE, l_statement);
          		RAISE;

     		END;
     	END LOOP;
	COMMIT;
END;

TRCLOG.TRCLOG( P_HFILE, 'Fin d insertion dans cons_sstache_res_mois');
TRCLOG.TRCLOG( P_HFILE, L_statement || ' : ' || L_INSERTED ||
               ' rows inserted. ' || L_REJECTED || ' rows rejected.' || L_UPDATED || ' rows updated.' );

COMMIT ;

TRCLOG.TRCLOG( P_HFILE, 'Fin du traitement d insertion des donnees concernant les lignes avec ss traitance dont datestatut < moismens -1');
EXCEPTION

	WHEN OTHERS THEN
		TRCLOG.TRCLOG( P_HFILE,'On est dans le grand block ...');
	TRCLOG.TRCLOG( P_HFILE, 'Fin anormale du traitement d insertion des donnees concernant les lignes avec ss traitance dont datestatut < moismens -1');
	TRCLOG.TRCLOG( P_HFILE, SQLERRM);
	TRCLOG.TRCLOG( P_HFILE, l_statement);
	RAISE;



END copie_datestatut;

end PACKBATCH;
/