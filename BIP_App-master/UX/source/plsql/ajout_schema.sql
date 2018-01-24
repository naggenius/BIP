-- Nom        :  pack_schema_histo
-- Auteur     :  Equipe SOPRA
-- Description : Procédure pour ajouter automatiquement le nom du schema historique a copier
-- @g:\commun\docs_exploit\migration_focus_oracle\ajout_schema.sql
-- exec pack_schema_histo.ajout_schema('/bip/bip1/batch');
CREATE OR REPLACE PACKAGE pack_schema_histo AS
  -- ------------------------------------------------------------------------
  -- Nom        :  update_fcoduser
  -- Auteur     :  Equipe SOPRA
  -- 
  -- ------------------------------------------------------------------------  
PROCEDURE ajout_schema(P_LOGDIR in varchar2);

END pack_schema_histo;
/

CREATE OR REPLACE PACKAGE BODY pack_schema_histo AS
-- -------------------
-- Gestions exceptions
-- -------------------
	CALLEE_FAILED exception;
	pragma exception_init( CALLEE_FAILED, -20000 );
	CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
	TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !
	ERR_FONCTIONNELLE_ID number := -20002;   -- pour provoquer erreur alors que Oracle OK
	CONSTRAINT_VIOLATION exception;          -- pour clause when
	pragma exception_init( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère

  -- ------------------------------------------------------------------------
  -- Nom        :  update_fcoduser
  -- Auteur     :  Equipe SOPRA
  -- 
  -- ------------------------------------------------------------------------  
PROCEDURE ajout_schema(P_LOGDIR in varchar2) AS

L_HFILE utl_file.file_type;
L_RETCOD number;
L_PROCNAME varchar2(50) := 'AJOUTSCHEMA';
L_STATEMENT varchar2(64);

l_schema_num  number;
	
BEGIN
 -- ----------------
 -- Init de la trace
 -- ----------------
	L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
	  if ( L_RETCOD <> 0 ) then
	      raise_application_error( TRCLOG_FAILED_ID,
				       'Erreur ' || L_RETCOD || ': Gestion du fichier LOG impossible',
				       false );
	  end if; 

 -- -----------
 -- Trace Start
 -- -----------
	TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );

	L_STATEMENT := 'DETERMINER LE NUMERO DU SCHEMA';

   SELECT  count(*) INTO l_schema_num FROM ref_histo ;

   IF l_schema_num >= 14  THEN  
       TRCLOG.TRCLOG( L_HFILE, 'Pas d''ajout de schema =' || l_schema_num || ' - Fin normale de ' || L_PROCNAME );
   ELSE  
       TRCLOG.TRCLOG( L_HFILE, 'Ajout schema =' || to_char(l_schema_num + 1) || ' - Fin normale de ' || L_PROCNAME );
       INSERT INTO ref_histo 
       VALUES ( add_months(sysdate,-36) ,'BIPH' || to_char(l_schema_num + 1) );
   END IF;

-- ---------- 
 -- Trace Stop
 -- ----------

	TRCLOG.CLOSETRCLOG( L_HFILE );
EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		IF  sqlcode <> CALLEE_FAILED_ID and sqlcode <> TRCLOG_FAILED_ID
        THEN TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' : '|| SQLERRM );
	   END IF;
	   IF  sqlcode <> TRCLOG_FAILED_ID 
        THEN
		  	TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		  	TRCLOG.CLOSETRCLOG( L_HFILE );
		  	raise_application_error( CALLEE_FAILED_ID,
					 'Erreur : consulter le fichier LOG',false );
  	     ELSE  raise;
      END IF;

END ajout_schema;
END pack_schema_histo;
/
