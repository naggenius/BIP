--PACKBATCH_MODIF_STOCK
-- Crée par YNI le 24/05/2010
-- Modifié par YNI le 29/07/2010

CREATE OR REPLACE PACKAGE       "PACKBATCH_MODIF_STOCK" AS

-- Crée par YNI le 24/05/2010
--******************************************************
-- Procédure de modification du stock des situations
--******************************************************
PROCEDURE MODIF_STOCK_SITUATIONS(P_LOGDIR          IN VARCHAR2)   ;

-- Crée par YNI le 24/05/2010
--******************************************************
-- Procédure de modification du stock des lignes contrats
--******************************************************
PROCEDURE MODIF_STOCK_LIGNES_CONTRATS(P_LOGDIR          IN VARCHAR2)   ;

PROCEDURE maj_ressource_logs(p_ident    IN RESSOURCE_LOGS.ident%TYPE,
                             p_user_log    IN RESSOURCE_LOGS.user_log%TYPE,
                             p_table      IN RESSOURCE_LOGS.nom_table%TYPE,
                             p_colonne    IN RESSOURCE_LOGS.colonne%TYPE,
                             p_valeur_prec    IN RESSOURCE_LOGS.valeur_prec%TYPE,
                             p_valeur_nouv    IN RESSOURCE_LOGS.valeur_nouv%TYPE,
                             p_commentaire    IN RESSOURCE_LOGS.commentaire%TYPE);
                             
END PACKBATCH_MODIF_STOCK;
/


CREATE OR REPLACE PACKAGE BODY       "PACKBATCH_MODIF_STOCK" AS

  -----------------------------------------------------
  -- Gestions exceptions
  -----------------------------------------------------
  CALLEE_FAILED EXCEPTION;
  pragma EXCEPTION_init( CALLEE_FAILED, -20000 );
  CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
  TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !
  ERR_FONCTIONNELLE_ID number := -20002;   -- pour provoquer erreur alors que Oracle OK
  CONSTRAINT_VIOLATION EXCEPTION;          -- pour clause when
  pragma EXCEPTION_init( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère


  -- Crée par YNI le 24/05/2010
  --******************************************************
  -- Procédure de modification du stock des situations
  --******************************************************
  PROCEDURE MODIF_STOCK_SITUATIONS(P_LOGDIR          IN VARCHAR2)    AS
  
  
  L_PROCNAME  varchar2(50) := 'MODIF_STOCK_SITUATIONS';
  L_STATEMENT varchar2(128);
  L_HFILE     utl_file.file_type;
  L_RETCOD    number;
  
  CURSOR cur_stock_situations IS
  SELECT r.ident ident,r.rtype rtype, sr.datsitu datsitu, sr.datdep datdep, sr.soccode soccode, sr.prestation prestation 
  FROM situ_ress sr, ressource r 
  where r.ident = sr.ident;
  
  l_date1 date;
  l_date2 date;
  BEGIN

	-----------------------------------------------------
	-- Init de la trace
	-----------------------------------------------------
    begin
		L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
		if ( L_RETCOD <> 0 ) then
		raise_application_error( TRCLOG_FAILED_ID,
		                        'Erreur : Gestion du fichier LOG impossible',
		                         false );
		end if;
    end;
	-----------------------------------------------------
	-- Trace Start
	-----------------------------------------------------

    TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );
    
    FOR curseur IN cur_stock_situations LOOP
	 	--BEGIN
    ---------------------------------------------------------------------------------------------
    -- Traitement 1 : Pour les situations des SG (Type ressource P et sté « SG.. »), ne rien changer 
    ---------------------------------------------------------------------------------------------
    /*
    IF ((curseur.rtype='P') and (curseur.soccode='SG..')) THEN
			           UPDATE situ_ress sr
			           SET  mode_contractuel_indicatif = ''
			           WHERE sr.ident = curseur.ident AND sr.datsitu = curseur.datsitu;
                 -- Trace LOGS
                 commit;
                 insert into test_message message values (' : ');
                 commit;
                 Packbatch_Modif_Stock.maj_ressource_logs(curseur.ident, 'Modif Stock', 'SITU_RESS', 'mode contractuel indicatif',NULL, '', 'Modification du mode contractuel indicatif');
		END IF; 
    */
    -----------------------------------------------------------------------------------------------
    -- Traitement 2 : Pour les situations des logiciels (Type ressource L), ajouter le champ Mode_contractuel_indicatif avec la valeur « LO » 
    ---------------------------------------------------------------------------------------------
    IF (curseur.rtype='L') THEN
           begin
			           UPDATE situ_ress sr
			           SET  mode_contractuel_indicatif = 'LO'
			           WHERE sr.ident = curseur.ident AND sr.datsitu = curseur.datsitu;
                 -- Trace LOGS
                 commit;
                 --insert into test_message message values ('LO : ');
                 --commit;
                 Packbatch_Modif_Stock.maj_ressource_logs(curseur.ident, 'Modif Stock', 'SITU_RESS', 'mode contractuel indicatif',NULL, 'LO', 'Modification de la situation (date valeur situation : '|| curseur.datsitu ||')');
           exception
              when No_Data_Found then  
              null;
              when others then
              null;
           end;       
		END IF;

    -------------------------------------------------------------------------------------------------------
    -- Traitement 3 : Pour les situations des prestataires au temps passé (Type ressource P et sté <> « SG.. »), ajouter le champ Mode_contractuel_indicatif avec la valeur « ATU »
    ----------------------------------------------------------------------------------------------------------
    IF ((curseur.rtype='P') and (curseur.soccode<>'SG..')) THEN
            begin
			           UPDATE situ_ress sr
			           SET  mode_contractuel_indicatif = 'ATU'
			           WHERE sr.ident = curseur.ident AND sr.datsitu = curseur.datsitu;
                 -- Trace LOGS
                 commit;
                 --insert into test_message message values ('ATU : ');
                 --commit;
                 Packbatch_Modif_Stock.maj_ressource_logs(curseur.ident, 'Modif Stock', 'SITU_RESS', 'mode contractuel indicatif',NULL, 'ATU', 'Modification de la situation (date valeur situation : '|| curseur.datsitu ||')');
            exception
              when No_Data_Found then  
              null;
              when others then
              null;
           end;       
		END IF;

    --------------------------------------------------------------------------------------------
    -- Traitement 4 : Pour les situations des forfaits de l'ex type « FS » (Type de ressource F et code prestation FS), ajouter le champ Mode_contractuel_indicatif avec la valeur « SFF » 
    ---------------------------------------------------------------------------------------------
    IF ((curseur.rtype='F') and (curseur.prestation='FS')) THEN
            begin
			           UPDATE situ_ress sr
			           SET  mode_contractuel_indicatif = 'SFF'
			           WHERE sr.ident = curseur.ident AND sr.datsitu = curseur.datsitu;
                 -- Trace LOGS
                 commit;
                 --insert into test_message message values ('SFF : ');
                 --commit;
                 Packbatch_Modif_Stock.maj_ressource_logs(curseur.ident, 'Modif Stock', 'SITU_RESS', 'mode contractuel indicatif',NULL, 'SFF', 'Modification de la situation (date valeur situation : '|| curseur.datsitu ||')');
            exception
              when No_Data_Found then  
              null;
              when others then
              null;
           end;       
		END IF;
    
    
    ---------------------------------------------------------------------------------------------
    -- Traitement 5 : Pour les situations des autres Types de ressources (les forfaits ayant un code prestation autre que FS), ajouter le champ Mode_contractuel_indicatif avec les valeurs suivantes, en fonction de la date d'effet de code action « REFONTECTRAPRESTA-D1» et version « 2010 » et de celle du code action « REFONTECTRAPRESTA-D2» et version « 2010 » :
    --         .  « XXX » si la date du jour est antérieure à D1 ou si date de fin de la situation est antérieure à D2,
    --         .  « ??? » sinon
    ---------------------------------------------------------------------------------------------
    IF ((curseur.rtype='F' or curseur.rtype='E') and (curseur.prestation<>'FS')) THEN
                 --insert into test_message message values ('avant select ');
                 select date_effet into l_date1 from date_effet where code_action = 'REFONTECTRAPRESTA-D1' and code_version = '2010';
                 select date_effet into l_date2 from date_effet where code_action = 'REFONTECTRAPRESTA-D2' and code_version = '2010';
                 --insert into test_message message values ('aprés select ');
                 
                 IF ((sysdate < l_date1) OR (curseur.datdep < l_date2)) THEN
                    begin
                       UPDATE situ_ress sr
                       SET  mode_contractuel_indicatif = 'XXX'
                       WHERE sr.ident = curseur.ident AND sr.datsitu = curseur.datsitu;
                       -- Trace LOGS
                       commit;
                       --insert into test_message message values ('XXX : ');
                       --commit;
                       Packbatch_Modif_Stock.maj_ressource_logs(curseur.ident, 'Modif Stock', 'SITU_RESS', 'mode contractuel indicatif',NULL, 'XXX', 'Modification de la situation (date valeur situation : '|| curseur.datsitu ||')');
                    exception
                       when No_Data_Found then  
                       null;
                       when others then
                       null;
                    end;       
                 
                 ELSE
                    begin
                       UPDATE situ_ress sr
                       SET  mode_contractuel_indicatif = '???'
                       WHERE sr.ident = curseur.ident AND sr.datsitu = curseur.datsitu;
                       -- Trace LOGS
                       commit;
                       --insert into test_message message values ('??? : ');
                       --commit;
                       Packbatch_Modif_Stock.maj_ressource_logs(curseur.ident, 'Modif Stock', 'SITU_RESS', 'mode contractuel indicatif',NULL, '???', 'Modification de la situation (date valeur situation : '|| curseur.datsitu ||')');
                   exception
                      when No_Data_Found then  
                      null;
                      when others then
                      null;
                   end;       
                     
                 END IF;
                 
                 --insert into test_message message values ('aprés update ');
			           
		END IF;
        
    END LOOP;
	  TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
    COMMIT;
   
	  TRCLOG.TRCLOG( L_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
    TRCLOG.CLOSETRCLOG( L_HFILE );
    
    EXCEPTION
    WHEN OTHERS THEN
          TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME);
          ROLLBACK;


  END MODIF_STOCK_SITUATIONS;





  -- Crée par YNI le 24/05/2010
  --******************************************************
  -- Procédure de modification du stock des lignes contrats
  --******************************************************
  PROCEDURE MODIF_STOCK_LIGNES_CONTRATS(P_LOGDIR          IN VARCHAR2)    AS
 
  
  
  L_PROCNAME  varchar2(50) := 'MODIF_STOCK_LIGNES_CONTRATS';
  L_STATEMENT varchar2(128);
  L_HFILE     utl_file.file_type;
  L_RETCOD    number;
  
  CURSOR cur_stock_lignescontrats IS
  SELECT cont.ctypfact ctypfact, lcont.numcont numcont, lcont.soccont soccont, lcont.cav cav, cont.codsg codsg, lcont.lcnum lcnum, lcont.lresfin lresfin 
  FROM ligne_cont lcont, contrat cont 
  where lcont.numcont = cont.numcont and lcont.cav = cont.cav and lcont.soccont = cont.soccont;
  
  l_date1 date;
  l_date2 date;
  BEGIN
  --insert into test_message message values ('test proc ');commit;
	-----------------------------------------------------
	-- Init de la trace
	-----------------------------------------------------
    
		L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
		if ( L_RETCOD <> 0 ) then
		raise_application_error( TRCLOG_FAILED_ID,
		                        'Erreur : Gestion du fichier LOG impossible',
		                         false );
		end if;

	-----------------------------------------------------
	-- Trace Start
	-----------------------------------------------------

    TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );
    --insert into test_message message values ('test proc ');commit;
    FOR curseur IN cur_stock_lignescontrats LOOP
        
   -- insert into test_message message values ('test majeur ');commit;
    ---------------------------------------------------------------------------------------------
    -- Traitement : Pour les situations des autres Types de ressources (les forfaits ayant un code prestation autre que FS), ajouter le champ Mode_contractuel_indicatif avec les valeurs suivantes, en fonction de la date d'effet de code action « REFONTECTRAPRESTA-D1» et version « 2010 » et de celle du code action « REFONTECTRAPRESTA-D2» et version « 2010 » :
    --         .  « XXX » si la date du jour est antérieure à D1 ou si date de fin de la situation est antérieure à D2,
    --         .  « ??? » sinon
    ---------------------------------------------------------------------------------------------
    IF ((curseur.ctypfact='R') or (curseur.ctypfact='M')) THEN
           begin       
                 UPDATE ligne_cont lcont
                 SET  mode_contractuel = 'ATU'
                 WHERE lcont.numcont = curseur.numcont AND lcont.soccont = curseur.soccont AND lcont.cav = curseur.cav AND lcont.lcnum = curseur.lcnum;
                 -- Trace LOGS
                 commit;
                 --insert into test_message message values ('ATU : ');
                 --commit;
                 --TRCLOG.TRCLOG( L_HFILE, 'Modification de la ligne numcont: ' || curseur.numcont || ', soccont: ' || curseur.soccont || ', cav: ' || curseur.cav || ', lcnum: ' || curseur.lcnum || ' avec le mode ATU');
                 Pack_contrat.maj_contrats_logs(curseur.numcont,null, curseur.soccont,curseur.cav, curseur.codsg, curseur.lcnum, 'Modif Stock', 'LIGNE_CONT', 'mode contractuel', '', 'ATU',null,null,3, 'Modification de la ligne contrat');
           exception
              when No_Data_Found then  
              null;
              when others then
              null;
           end;       
    ELSE
                 
                 select date_effet into l_date1 from date_effet where code_action = 'REFONTECTRAPRESTA-D1' and code_version = '2010';
                 select date_effet into l_date2 from date_effet where code_action = 'REFONTECTRAPRESTA-D2' and code_version = '2010';               
                 IF ((sysdate < l_date1) OR (curseur.lresfin < l_date2)) THEN
                     begin
                         UPDATE ligne_cont lcont
                         SET  mode_contractuel = 'XXX'
                         WHERE lcont.numcont = curseur.numcont AND lcont.soccont = curseur.soccont AND lcont.cav = curseur.cav AND lcont.lcnum = curseur.lcnum;
                         -- Trace LOGS
                         commit;
                         --insert into test_message message values ('XXX : '||curseur.lcnum);
                         --commit;
                         --TRCLOG.TRCLOG( L_HFILE, 'Modification de la ligne numcont: ' || curseur.numcont || ', soccont: ' || curseur.soccont || ', cav: ' || curseur.cav || ', lcnum: ' || curseur.lcnum || ' avec le mode XXX');
                         Pack_contrat.maj_contrats_logs(curseur.numcont,null, curseur.soccont,curseur.cav, curseur.codsg, curseur.lcnum, 'Modif Stock', 'LIGNE_CONT', 'mode contractuel', '', 'XXX',null,null,3, 'Modification de la ligne contrat');
                     exception
                        when No_Data_Found then  
                        null;
                        when others then
                        null;
                     end;       
                 ELSE
                     begin
                         UPDATE ligne_cont lcont
                         SET  mode_contractuel = '???'
                         WHERE lcont.numcont = curseur.numcont AND lcont.soccont = curseur.soccont AND lcont.cav = curseur.cav AND lcont.lcnum = curseur.lcnum;
                         -- Trace LOGS
                         commit;
                         --insert into test_message message values ('??? : '||curseur.lcnum);
                         --commit;
                         --TRCLOG.TRCLOG( L_HFILE, 'Modification de la ligne numcont: ' || curseur.numcont || ', soccont: ' || curseur.soccont || ', cav: ' || curseur.cav || ', lcnum: ' || curseur.lcnum || ' avec le mode ???');
                         Pack_contrat.maj_contrats_logs(curseur.numcont,null, curseur.soccont,curseur.cav, curseur.codsg, curseur.lcnum, 'Modif Stock', 'LIGNE_CONT', 'mode contractuel', '', '???',null,null,3, 'Modification de la ligne contrat');
                     exception
                        when No_Data_Found then  
                        null;
                        when others then
                        null;
                     end;          
                 END IF;
			           
		END IF;
    
    END LOOP;
	  
    TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
    COMMIT;
   
	  TRCLOG.TRCLOG( L_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
    TRCLOG.CLOSETRCLOG( L_HFILE );
    
    EXCEPTION
    WHEN OTHERS THEN
          TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME);
          ROLLBACK;

  END MODIF_STOCK_LIGNES_CONTRATS;
  
  
  --Procédure pour remplir les logs de MAJ de la ressource et situ_ress

   PROCEDURE maj_ressource_logs(p_ident        IN RESSOURCE_LOGS.ident%TYPE,
                                p_user_log    IN RESSOURCE_LOGS.user_log%TYPE,
                                p_table      IN RESSOURCE_LOGS.nom_table%TYPE,
                                p_colonne    IN RESSOURCE_LOGS.colonne%TYPE,
                                p_valeur_prec    IN RESSOURCE_LOGS.valeur_prec%TYPE,
                                p_valeur_nouv    IN RESSOURCE_LOGS.valeur_nouv%TYPE,
                                p_commentaire    IN RESSOURCE_LOGS.commentaire%TYPE
                                ) IS
   BEGIN

    IF (UPPER(LTRIM(RTRIM(NVL(p_valeur_prec, 'NULL')))) <> UPPER(LTRIM(RTRIM(NVL(p_valeur_nouv, 'NULL'))))) THEN
        INSERT INTO RESSOURCE_LOGS
            (ident, date_log, user_log, nom_table, colonne, valeur_prec, valeur_nouv, commentaire)
        VALUES
            (p_ident, CURRENT_TIMESTAMP, p_user_log, p_table, p_colonne, p_valeur_prec, p_valeur_nouv, p_commentaire);
    --PPM 57823 : changer SYSDATE par CURRENT_TIMESTAMP pour avoir une precision au millieme de secondes

    END IF;
    -- Pas de commit  car en cas d'erreur la MAJ n'est pas enregistrée et il ne faut donc pas créer de ligne

   END maj_ressource_logs;

END PACKBATCH_MODIF_STOCK;
/


