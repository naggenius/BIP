CREATE OR REPLACE PACKAGE packbatch_budget_ecart AS

-- Modifié par DDI le 16/10/2006

--****************************************************** 
-- Procédure d'alimentation de la table ressource_ecart 
-- à partir de la table CONS_SSTACHE_RES_MOIS 
--****************************************************** 
PROCEDURE alim_budget_ecart(P_LOGDIR          IN VARCHAR2)   ;

END packbatch_budget_ecart;
/

CREATE OR REPLACE PACKAGE BODY packbatch_budget_ecart AS


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


--******************************************************
-- Procédure d'alimentation de la table budget_ecart
-- à partir des tables : BUDGET et CONSOMME
--******************************************************
PROCEDURE alim_budget_ecart(P_LOGDIR          IN VARCHAR2)  IS


L_PROCNAME  varchar2(17) := 'ALIM_BUDGET_ECART';
L_STATEMENT varchar2(128);
L_HFILE     utl_file.file_type;
L_RETCOD    number;
L_ANNEE varchar2(4);
L_MOISMENS DATE;
l_exist NUMBER(1);

CURSOR cur_ecartbud IS
SELECT * FROM budget_ecart;

l_pid		budget_ecart.pid%TYPE;
l_type  	budget_ecart.type%TYPE;
l_annee1       	budget_ecart.annee%TYPE;
l_valide      	budget_ecart.valide%TYPE;
l_commentaire  	budget_ecart.commentaire%TYPE;
l_reestime	budget_ecart.reestime%TYPE;
l_anmont	budget_ecart.anmont%TYPE;
l_bpmontme	budget_ecart.bpmontme%TYPE;
l_bnmont	budget_ecart.bnmont%TYPE;

BEGIN

    SELECT to_char(moismens,'yyyy') INTO L_ANNEE FROM datdebex;

    SELECT moismens INTO L_MOISMENS FROM datdebex;

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

	-- ------------------------------------------------------------------------------------------- 
	-- Etape 1 : vider BUDGET_ECART_1, copier BUDGET_ECART dans BUDGET_ECART_1, vider BUDGET_ECART 
	-- ------------------------------------------------------------------------------------------- 

	-- Vide BUDGET_ECART_1 
		L_STATEMENT := '* Vider BUDGET_ECART_1';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		PACKBATCH.DYNA_TRUNCATE('BUDGET_ECART_1');

	-- Données de BUDGET_ECART dans BUDGET_ECART_1 
		L_STATEMENT := '* Copier BUDGET_ECART dans BUDGET_ECART_1';
		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		INSERT INTO budget_ecart_1
		select * from budget_ecart;
		L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table BUDGET_ECART_1';
-- dbms_output.put_line('***************************************************************************************');
-- dbms_output.put_line(L_STATEMENT);
		commit;

	-- Vider les lignes de la table BUDGET_ECART 
 		L_STATEMENT := '* Vider BUDGET_ECART';
 		TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
		PACKBATCH.DYNA_TRUNCATE('BUDGET_ECART');

    TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
    COMMIT;


	-- ------------------------------------------------------------------------------------------
	-- Etape 2 : On alimente la table BUDGET_ECART avec des données des tables BUDGET et CONSOMME
	-- ------------------------------------------------------------------------------------------

    L_STATEMENT := '* alimentation de BUDGET_ECART par les ecarts de type REE>ARB et Conso sans budget';
    TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );


	INSERT INTO BUDGET_ECART (CODSG,PID,PNOM,REESTIME,ANMONT,BPMONTME,BNMONT,CUSAG,ANNEE,TYPE,VALIDE,COMMENTAIRE)
  	(select l.codsg,l.pid,l.pnom,NVL(b.REESTIME,0),NVL(b.ANMONT,0),NVL(b.BPMONTME,0),NVL(b.BNMONT,0),NVL(c.CUSAG,0),
  	        L_ANNEE,'REE>ARB','N','Anomalie estimé > arbitré'
	 from ligne_bip l,budget b, consomme c
	 where
	  l.pid      = c.pid(+)
	   and c.ANNEE(+) = L_ANNEE
	   and l.pid      = b.pid(+)
	   and l.typproj <> '7 '
	   and b.ANNEE(+) = L_ANNEE
	   and (
	   	(NVL(b.REESTIME,0)) > (NVL(b.ANMONT,0))
	       )
	);--order by l.codsg,l.pid;
	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées de type Estimé > Arbitré dans la table BUDGET_ECART';
-- dbms_output.put_line(L_STATEMENT);
	TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
  	COMMIT;


	INSERT INTO BUDGET_ECART (CODSG,PID,PNOM,REESTIME,ANMONT,BPMONTME,BNMONT,CUSAG,ANNEE,TYPE,VALIDE,COMMENTAIRE)
  	(select l.codsg,l.pid,l.pnom,NVL(b.REESTIME,0),NVL(b.ANMONT,0),NVL(b.BPMONTME,0),NVL(b.BNMONT,0),NVL(c.CUSAG,0),
  	        L_ANNEE,'CONS-BUD','N','Anomalie Conso sans budget'
	 from ligne_bip l,budget b, consomme c
	 where
	  l.pid      = c.pid(+)
	   and c.ANNEE(+) = L_ANNEE
	   and l.pid      = b.pid(+)
	   and l.typproj <> '7 '
	   and b.ANNEE(+) = L_ANNEE
	   and (
	   	( NVL(c.CUSAG,0) > 0 )  AND ( NVL(b.BPMONTME,0) =0 ) AND ( NVL(b.BNMONT,0) =0 ) AND ( NVL(b.ANMONT,0) =0 )
	       )
	);--order by l.codsg,l.pid;
	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées de type Conso sans budget dans la table BUDGET_ECART';
-- dbms_output.put_line(L_STATEMENT);
	TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
  	COMMIT;
	
-- ---------------------------	
	INSERT INTO BUDGET_ECART (CODSG,PID,PNOM,REESTIME,ANMONT,BPMONTME,BNMONT,CUSAG,ANNEE,TYPE,VALIDE,COMMENTAIRE)
  	(select l.codsg,l.pid,l.pnom,NVL(b.REESTIME,0),NVL(b.ANMONT,0),NVL(b.BPMONTME,0),NVL(b.BNMONT,0),NVL(c.CUSAG,0),
  	        L_ANNEE,'REE-CON','N','Anomalie Estimé inférieur au consommé'
	 from ligne_bip l,budget b, consomme c
	 where
	  l.pid      = c.pid(+)
	   and c.ANNEE(+) = L_ANNEE
	   and l.pid      = b.pid(+)
	   and l.typproj <> '7 '
	   and b.ANNEE(+) = L_ANNEE
	   and (
	   	   	  (NVL(b.REESTIME,0)) < (NVL(c.CUSAG,0))  
	       )
	);
	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées de type Estimé < consommé dans la table BUDGET_ECART';
-- dbms_output.put_line(L_STATEMENT);
	TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
  	COMMIT;


	-- ------------------------------------------------------------------------------------
	-- Etape 3 :  Calcul des retours arrière
	--            On compare chaque ligne de BUDGET_ECART avec les lignes de BUDGET_ECART_1
	-- ------------------------------------------------------------------------------------

     L_STATEMENT := '* Calcul des retours arrière sur les écarts budgétaires';
     TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
	 FOR curseur IN cur_ecartbud LOOP
	 	BEGIN
		  SELECT PID, TYPE, ANNEE, VALIDE, COMMENTAIRE, REESTIME, ANMONT, BPMONTME, BNMONT
			 into l_pid, l_type, l_annee1, l_valide, l_commentaire, l_reestime, l_anmont, l_bpmontme, l_bnmont
		  FROM budget_ecart_1 be1
		  WHERE be1.pid = curseur.pid
		  AND be1.annee = curseur.annee
		  AND be1.type = curseur.type
		  ;

		-- Si l'écart a été validé dans budget_ecart_1 ET si les données budgétaires sont identiques
		-- Alors on reporte le fait que l'écart a été validé dans budget_ecart

		  IF (l_valide = 'O') THEN

			IF ((curseur.annee=l_annee1) and (curseur.reestime=l_reestime) and (curseur.anmont=l_anmont) and (curseur.bpmontme=l_bpmontme) and (curseur.bnmont=l_bnmont)) THEN
			           UPDATE budget_ecart
			           SET  VALIDE = l_valide,
			  	   	COMMENTAIRE = l_commentaire
			           WHERE pid = curseur.pid
			           AND annee = curseur.annee
			           AND type = curseur.type;
			END IF;
-- dbms_output.put_line(curseur.pid); 
		  END IF;


		EXCEPTION

			 WHEN No_Data_Found THEN


				UPDATE budget_ecart
			    SET	VALIDE = curseur.valide,
				COMMENTAIRE = curseur.commentaire
			    WHERE pid = curseur.pid
			    AND annee = curseur.annee
			    AND type = curseur.type;

        END;

	 END LOOP;
	 TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
	 COMMIT;


	 TRCLOG.TRCLOG( L_HFILE, 'Fin NORMALE de ' || L_PROCNAME);

EXCEPTION
	when others then
	    rollback;
		if sqlcode <> CALLEE_FAILED_ID then
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		end if;
		TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		raise CALLEE_FAILED;


end alim_budget_ecart;


END packbatch_budget_ecart;
/
