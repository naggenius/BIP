-- pack_batch_remontee

CREATE OR REPLACE PACKAGE PACK_BATCH_REMONTEE AS

PROCEDURE build_fichier_remontee(	p_logdir			IN VARCHAR2,
									p_chemin_fichier	IN VARCHAR2,
                       				p_nom_fichier		IN VARCHAR2);

END PACK_BATCH_REMONTEE;
/

CREATE OR REPLACE PACKAGE BODY PACK_BATCH_REMONTEE AS
TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !

PROCEDURE build_fichier_remontee(	p_logdir			IN VARCHAR2,
									p_chemin_fichier	IN VARCHAR2,
                       				p_nom_fichier		IN VARCHAR2)
IS
	l_file_log	utl_file.file_type;
	L_RETCOD	number;
	L_PROCNAME  varchar2(256) := 'rbip_extract';
	l_log		boolean := false;
	
	l_file_out	utl_file.file_type;	
	l_CURSEUR	PACK_REMONTEE.remonteeCurType;
	cur_enr		PACK_REMONTEE.remonteeRecType;
	vBuffer		VARCHAR2 (32767);
	vBuffer_r		VARCHAR2 (32767);
	l_amount	BINARY_INTEGER := 32767;
	l_pos		PLS_INTEGER;
	l_clob_len	PLS_INTEGER;
	l_msg 		varchar2(1024);
	rBipClob	CLOB;

  l_message VARCHAR2(100);
	--l_entete varchar2 (1024) := 'LigneBipCode;LigneBipCle;StructureAction;EtapeNum;EtapeType;EtapeLibel;TacheNum;TacheLibel;TacheAxeMetier;StacheNum;StacheType;StacheLibel;StacheInitDebDate;StacheInitFinDate;StacheRevDebDate;StacheRevFinDate;StacheStatut;StacheDuree;StacheParamLocal;RessBipCode;RessBipNom;ConsoDebDate;ConsoFinDate;ConsoQte';
  
    
BEGIN
	-----------------------------------------------------
	-- Init de la trace
	-----------------------------------------------------
	

	L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, l_file_log );
	if ( L_RETCOD <> 0 )
	then
		raise_application_error( TRCLOG_FAILED_ID, 'Erreur : Gestion du fichier LOG impossible', false );
	end if;
	l_log := true;
	-----------------------------------------------------
	-- Trace Start
	-----------------------------------------------------
	TRCLOG.TRCLOG( l_file_log, 'Debut de ' || L_PROCNAME );
	TRCLOG.TRCLOG( l_file_log, 'Le fichier de donnée est : ' || p_chemin_fichier || '/' || p_nom_fichier);	
	-----------------------------------------------------
	
  /*SEL PPM 60709 5.5 : supprimer les structures SR des lignes BIP remontees par des fichiers .BIP
                        rejeter les lignes BIP remontees par des fichiers .BIP
  */
  TRCLOG.TRCLOG( l_file_log, 'Supprimer les structures SR des lignes BIP remontees par des fichiers .BIP ');	
  FOR i in (SELECT * FROM	REMONTEE	WHERE (STATUT = 2 OR STATUT = 22) ) LOOP
  
  pack_ligne_bip.supprimer_sr_si_existe(i.pid,'',l_message);
  TRCLOG.TRCLOG( l_file_log, 'Ligne supprimées '||i.pid);	
  
  END LOOP;
 
  --FIN SEL PPM 60709 5.5

	l_file_out := UTL_FILE.FOPEN(p_chemin_fichier, p_nom_fichier, 'w', l_amount);
	-- on recupere la liste des fichiers valides dans l_CURSEUR
	TRCLOG.TRCLOG( l_file_log, 'On recupere la liste des fichiers valides ... ' || L_PROCNAME );
	PACK_REMONTEE.select_fichiers_statut(PACK_REMONTEE.STATUT_CONTROLE_OK, l_CURSEUR);
	TRCLOG.TRCLOG( l_file_log, '... fait' || L_PROCNAME );
	

	LOOP
		FETCH l_CURSEUR INTO cur_enr;
		EXIT WHEN l_CURSEUR%NOTFOUND;
		-- lecture du clob
		-- 	parcours du clob et ajout au fichier de sortie
		PACK_REMONTEE.get_data_fichier(cur_enr.PID, cur_enr.ID_REMONTEUR, rBipClob);
		l_clob_len := dbms_lob.getlength(rBipClob);
		TRCLOG.TRCLOG( l_file_log, ' - Traitement du fichier ' || cur_enr.FICHIER_DATA || ' ' || cur_enr.PID || ' ' || cur_enr.ID_REMONTEUR);
		
		
		--dbms_output.put_line('Recup de ' || cur_enr.PID || ' | ' || cur_enr.ID_REMONTEUR);
		l_pos := 1;
		WHILE l_pos < l_clob_len
		LOOP
			dbms_lob.read(rBipClob, l_amount, l_pos, vBuffer);
			
			IF vBuffer IS NOT NULL
			THEN
				UTL_FILE.PUT(l_file_out, vBuffer); --pas de retour à la ligne !!!!
			END IF;
			utl_file.fflush(l_file_out);
			l_pos := l_pos + l_amount; 
		END LOOP;
		PACK_GLOBAL.WRITE_STRING( l_file_out, '');
		
		--on passe le fichier en statut 'CHARGE'		
		TRCLOG.TRCLOG( l_file_log, '	Mise à jour du statut du fichier');	
		PACK_REMONTEE.update_fichier(cur_enr.PID, cur_enr.ID_REMONTEUR, PACK_REMONTEE.STATUT_CHARGE, cur_enr.STATUT_INFO);
	end loop;

	-----------------------------------------------------
	-- Trace Stop
	-----------------------------------------------------
	TRCLOG.TRCLOG( l_file_log, 'Fin normale de ' || L_PROCNAME  );
	TRCLOG.CLOSETRCLOG( l_file_log );
	
	EXCEPTION
		WHEN OTHERS THEN
			if l_log = true
			then
				TRCLOG.TRCLOG( l_file_log, 'Fin ANORMALE de ' || L_PROCNAME ||' ( '||SQLERRM||' ) ' );
				TRCLOG.CLOSETRCLOG( l_file_log );
				raise;
			end if;
			
END build_fichier_remontee;

END PACK_BATCH_REMONTEE;
/
