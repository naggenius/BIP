-- -----------------------------------------------------------------------------------
-- Nom du fichier : purge_q.sql
--
-- Objet : Procédure de purge quotidienne lancée par purge_Q.sh
--				
-- ----------------------------------------------------------------------------------
-- Creation : PPR le 06/10/2006
-- Modifications :
-- ----------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE packbatch_purge_q IS
-- ##################################################################################
--	PROCEDURE de purge des tables lancée lors de l'archivage
-- ##################################################################################
	PROCEDURE purge_tables(
		P_LOGDIR	IN VARCHAR2
	);

END packbatch_purge_q;
/

CREATE OR REPLACE PACKAGE BODY packbatch_purge_q IS
-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
pragma EXCEPTION_init( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !


-- ##################################################################################
--	PROCEDURE de purge des tables lancée tous les jours
-- ##################################################################################

	PROCEDURE purge_tables(
		P_LOGDIR	IN VARCHAR2
	) IS
	L_PROCNAME  varchar2(16) := 'PURGE_TABLES';
	L_HFILE     utl_file.file_type;
	L_STATEMENT VARCHAR2(128);
	L_RETCOD    number;
	
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
	--  table MESSAGE_PERSONNEL
	--
	--  Purger si date antérieure à hier
	-----------------------------------------------------

		DELETE FROM MESSAGE_PERSONNEL WHERE DATE_DEBUT < (SYSDATE-1) ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table MESSAGE_PERSONNEL';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

		
	-----------------------------------------------------
	--  table DEMANDE_VAL_FACTU
	--
	--  Purger si demande traitée et existante depuis 3 mois
	-----------------------------------------------------


		DELETE FROM DEMANDE_VAL_FACTU WHERE DATDEM < (SYSDATE-90) and STATUT='T'  ;
		COMMIT;

		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table DEMANDE_VAL_FACTU';
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
	
	END purge_tables;

END packbatch_purge_q;
/
