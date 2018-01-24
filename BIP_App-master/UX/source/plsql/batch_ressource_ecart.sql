-- Package pour l'alimentation de la table ressource_ecart
-- Créé le 03/08/2005 par BAA
-- Modifié le 20/09/2005 par BAA   recupérer que les consommés des ressources physiques
-- Modifié le 27/10/2005 par BAA   dans alim_total_jh on supprime les ecarts de type <> de TOTAL
-- 				    et non validé, inserer les ressource non remonter 
----------------------------------------------------------------------------------------




CREATE OR REPLACE PACKAGE packbatch_ressource_ecart AS



--******************************************************
-- Procédure d'alimentation de la table ressource_ecart
-- à partir de la table CONS_SSTACHE_RES_MOIS
--******************************************************
PROCEDURE alim_total_jh(P_LOGDIR          IN VARCHAR2)   ;



--******************************************************
-- Procédure d'alimentation de la table ressource_ecart
-- à partir de la table BJH_ANOMALIES
--******************************************************
PROCEDURE alim_bouclage_jh(P_LOGDIR          IN VARCHAR2)   ;




END packbatch_ressource_ecart;
/




CREATE OR REPLACE PACKAGE BODY packbatch_ressource_ecart AS


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
-- Procédure d'alimentation de la table ressource_ecart
-- à partir de la table CONS_SSTACHE_RES_MOIS
--******************************************************
PROCEDURE alim_total_jh(P_LOGDIR          IN VARCHAR2)  IS


L_PROCNAME  varchar2(16) := 'ALIM_TOTAL_JH';
L_STATEMENT varchar2(128);
L_HFILE     utl_file.file_type;
L_RETCOD    number;
L_ANNEE varchar2(4);
L_MOISMENS DATE;
l_exist NUMBER(1);

CURSOR cur_re IS
SELECT * FROM ressource_ecart
WHERE type='TOTAL';

l_nbjbip           ressource_ecart.nbjbip%TYPE;
l_nbjgersh         ressource_ecart.nbjgersh%TYPE;
l_nbjmois          ressource_ecart.nbjmois%TYPE;
l_valide           ressource_ecart.valide%TYPE;
l_commentaire      ressource_ecart.commentaire%TYPE;

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

	-- ------------------------------------------------------------------------------------------------------
	-- Etape 1 : vider RESSOURCE_ECART, copier RESSOURCE_ECART dans RESSOURCE_ECART_1, vider RESSOURCE_ECART
	--           pour les ecarts de type TOTAL
	-- ------------------------------------------------------------------------------------------------------
	L_STATEMENT := '* Copier RESSOURCE_ECART dans RESSOURCE_ECART_1';
	TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-- vide RESSOURCE_ECART_1
	PACKBATCH.DYNA_TRUNCATE('RESSOURCE_ECART_1');

	-- données de RESSOURCE_ECART dans RESSOURCE_ECART_1
	INSERT INTO ressource_ecart_1
	select * from ressource_ecart
	where type='TOTAL';
	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table RESSOURCE_ECART_1';
	commit;

	-- vider les lignes de la table RESSOURCE_ECART de type TOTAL
    L_STATEMENT := '* vide les lignes de la table RESSOURCE_ECART de type TOTAL ';
    TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
	DELETE RESSOURCE_ECART
	WHERE to_char(cdeb,'YYYY')=L_ANNEE AND TYPE='TOTAL';
	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table RESSOURCE_ECART';
    TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
    COMMIT;


	-- vider les lignes de la table RESSOURCE_ECART de type <> TOTAL
    L_STATEMENT := '* vide les lignes de la table RESSOURCE_ECART de type <> de TOTAL non validé';
    TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
	DELETE RESSOURCE_ECART
	WHERE to_char(cdeb,'YYYY')=L_ANNEE AND TYPE<>'TOTAL' AND VALIDE='N';
	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table RESSOURCE_ECART';
    TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
    COMMIT;
	

	-- --------------------------------------------------------------------------------------
	-- Etape 2 : On alimente la table RESSOURCE_ECART  par total JH
	--           avec des données de la table con_sstache_res_mois
	-- --------------------------------------------------------------------------------------



    L_STATEMENT := '* alimentation de RESSOURCE_ECART par les écarts de type TOTAL';
    TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );


	INSERT INTO RESSOURCE_ECART (IDENT,CDEB,TYPE,NBJBIP,NBJMOIS,VALIDE,COMMENTAIRE)
  	(select s.ident, s.cdeb, 'TOTAL', SUM(s.cusag), c.cjours,'N','Anomalie'
   	 		from cons_sstache_res_mois s, calendrier c,ressource r
			where to_char(s.cdeb,'yyyy')=L_ANNEE
			and c.calanmois=s.cdeb
			and r.ident=s.ident
			and r.rtype='P'
			group by s.ident,s.cdeb,c.cjours
			having SUM(s.cusag)<>c.cjours
			
	 UNION
	 select distinct r.ident, r.MOIS, 'TOTAL',0, c.cjours,'N','Anomalie' 
	 		from
			-- FAD PPM Corrective 64640 : Remplacement de la table RESSOURCE pas la sous requête ci-dessous pour tracer toutes les ressources avec tous les mois de l'année
			(SELECT IDENT, RTYPE, MOIS FROM
				(select IDENT, RTYPE, TO_DATE('0101' || (select TO_CHAR(DATDEBEX, 'YYYY') from DATDEBEX), 'DDMMYYYY') MOIS from RESSOURCE
				union
				select IDENT, RTYPE, TO_DATE('0102' || (select TO_CHAR(DATDEBEX, 'YYYY') from DATDEBEX), 'DDMMYYYY') MOIS from RESSOURCE
				union
				select IDENT, RTYPE, TO_DATE('0103' || (select TO_CHAR(DATDEBEX, 'YYYY') from DATDEBEX), 'DDMMYYYY') MOIS from RESSOURCE
				union
				select IDENT, RTYPE, TO_DATE('0104' || (SELECT TO_CHAR(DATDEBEX, 'YYYY') FROM DATDEBEX), 'DDMMYYYY') MOIS from RESSOURCE
				union
				select IDENT, RTYPE, TO_DATE('0105' || (SELECT TO_CHAR(DATDEBEX, 'YYYY') FROM DATDEBEX), 'DDMMYYYY') MOIS from RESSOURCE
				union
				select IDENT, RTYPE, TO_DATE('0106' || (select TO_CHAR(DATDEBEX, 'YYYY') from DATDEBEX), 'DDMMYYYY') MOIS from RESSOURCE
				union
				select IDENT, RTYPE, TO_DATE('0107' || (select TO_CHAR(DATDEBEX, 'YYYY') from DATDEBEX), 'DDMMYYYY') MOIS from RESSOURCE
				union
				select IDENT, RTYPE, TO_DATE('0108' || (select TO_CHAR(DATDEBEX, 'YYYY') from DATDEBEX), 'DDMMYYYY') MOIS from RESSOURCE
				union
				select IDENT, RTYPE, TO_DATE('0109' || (SELECT TO_CHAR(DATDEBEX, 'YYYY') FROM DATDEBEX), 'DDMMYYYY') MOIS from RESSOURCE
				union
				select IDENT, RTYPE, TO_DATE('0110' || (select TO_CHAR(DATDEBEX, 'YYYY') from DATDEBEX), 'DDMMYYYY') MOIS from RESSOURCE
				union
				select IDENT, RTYPE, TO_DATE('0111' || (select TO_CHAR(DATDEBEX, 'YYYY') from DATDEBEX), 'DDMMYYYY') MOIS from RESSOURCE
				union
				select IDENT, RTYPE, TO_DATE('0112' || (select TO_CHAR(DATDEBEX, 'YYYY') from DATDEBEX), 'DDMMYYYY') MOIS from RESSOURCE)
			WHERE MOIS <= (select MOISMENS from DATDEBEX)
			) r,
			-- FAD PPM Corrective 64640 : Fin
			-- FAD PPM Corrective 64868 : Début
			(
			-- FAD QC 1949 : Utilisation TO_CHAR(MOISMENS, 'YYYY') à la place de MOISMENS
			select distinct IDENT, DATSITU, DATDEP from SITU_RESS where TO_CHAR(DATSITU, 'YYYY') <= (select TO_CHAR(MOISMENS, 'YYYY') from DATDEBEX)
			and (DATDEP is null or TO_CHAR(DATDEP, 'YYYY') >= (select TO_CHAR(MOISMENS, 'YYYY') from DATDEBEX))
			AND PRESTATION <> 'IFO' AND PRESTATION <> 'GRA'
			-- FAD QC 1949 : Fin
			) SR,
			-- FAD PPM Corrective 64868 : Fin
			calendrier c
			-- FAD PPM Corrective 64868 : Début
			WHERE R.IDENT = SR.IDENT
			AND R.mois >= SR.DATSITU AND (SR.DATDEP IS NULL OR R.mois <= SR.DATDEP)
			-- FAD PPM Corrective 64868 : Fin
			
			and (R.ident, R.mois) not in
						(
							select distinct IDENT, CDEB from CONS_SSTACHE_RES_MOIS where CDEB BETWEEN (SELECT DATDEBEX from DATDEBEX) and (SELECT MOISMENS from DATDEBEX)
						)
 	  	 	and r.rtype='P'
	  	    and c.calanmois=r.MOIS
		
	);
	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées de type TOTAL dans la table RESSOURCE_ECART';
	TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
  	COMMIT;



	-- --------------------------------------------------------------------------------------
	-- Etape 3 :  Calcul des retours arrière
	--            On compare chaque ligne de RESSOURCE_ECART avec les lignes de RESSOURCE_ECART_1
	-- --------------------------------------------------------------------------------------



     L_STATEMENT := '* Calcul des retours arrière';
     TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
	 FOR curseur IN cur_re LOOP
	 	BEGIN
	 	  SELECT NBJBIP, NBJGERSH, NBJMOIS, VALIDE, COMMENTAIRE
			 into l_nbjbip, l_nbjgersh, l_nbjmois, l_valide, l_commentaire
		  FROM ressource_ecart_1 r
		  WHERE r.ident = curseur.ident
		  AND r.cdeb = curseur.cdeb
		  AND r.type = curseur.type
		  ;

		  IF (l_valide = 'O') THEN

			      IF (curseur.nbjbip=l_nbjbip) THEN

			           UPDATE ressource_ecart
			           SET  VALIDE = l_valide,
			  	            COMMENTAIRE = l_commentaire
			           WHERE ident = curseur.ident
			           AND cdeb = curseur.cdeb
			           AND type = curseur.type
			           ;

				   END IF;

		  END IF;

		EXCEPTION

			 WHEN No_Data_Found THEN

				UPDATE ressource_ecart
			    SET  VALIDE = curseur.valide,
			  	     COMMENTAIRE = curseur.commentaire
			    WHERE ident = curseur.ident
			    AND cdeb = curseur.cdeb
			    AND type = curseur.type
			    ;

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


end alim_total_jh;




--******************************************************
-- Procédure d'alimentation de la table ressource_ecart
-- à partir de la table BJH_ANOMALIES
--******************************************************
PROCEDURE alim_bouclage_jh(P_LOGDIR          IN VARCHAR2)  IS


L_PROCNAME  varchar2(16) := 'ALIM_BOUCLAGE_JH';
L_STATEMENT varchar2(128);
L_HFILE     utl_file.file_type;
L_RETCOD    number;
L_ANNEE varchar2(4);
l_exist NUMBER(1);

CURSOR cur_re IS
SELECT * FROM ressource_ecart
WHERE type<>'TOTAL';

l_nbjbip           ressource_ecart.nbjbip%TYPE;
l_nbjgersh         ressource_ecart.nbjgersh%TYPE;
l_nbjmois          ressource_ecart.nbjmois%TYPE;
l_valide           ressource_ecart.valide%TYPE;
l_commentaire      ressource_ecart.commentaire%TYPE;


BEGIN




SELECT to_char(moismens,'yyyy') INTO L_ANNEE FROM datdebex;



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



	-- ------------------------------------------------------------------------------------------------------
	-- Etape 1 : vider RESSOURCE_ECART, copier RESSOURCE_ECART dans RESSOURCE_ECART_1, vider RESSOURCE_ECART
	--           pour les ecarts de type CONGES et ABSDIV
	-- ------------------------------------------------------------------------------------------------------
	L_STATEMENT := '* Copier RESSOURCE_ECART dans RESSOURCE_ECART_1';
	TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );

	-- vide RESSOURCE_ECART_1
	PACKBATCH.DYNA_TRUNCATE('RESSOURCE_ECART_1');


	-- données de RESSOURCE_ECART dans RESSOURCE_ECART_1
	INSERT INTO ressource_ecart_1
	select * from ressource_ecart
	where type<>'TOTAL';
	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table RESSOURCE_ECART_1';
	commit;

	-- vider les lignes de la table RESSOURCE_ECART de type CONGES et ABSDIV
    L_STATEMENT := '* vide les lignes de la table RESSOURCE_ECART de type different à TOTAL ';
    TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
	DELETE RESSOURCE_ECART
	WHERE to_char(cdeb,'YYYY')=L_ANNEE AND TYPE<>'TOTAL';
	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans la table RESSOURCE_ECART';
    TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
    COMMIT;




    -- --------------------------------------------------------------------------------------
	-- Etape 2 : On alimente la table RESSOURCE_ECART  par bouclage JH
	--           avec des données de la table BJH_ANOMALIES de type ABSDIV
	-- --------------------------------------------------------------------------------------


    L_STATEMENT := '* alimentation de RESSOURCE_ECART ECART par les écarts de type ABSDIV';
    TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );


	INSERT INTO RESSOURCE_ECART (IDENT,CDEB,TYPE,NBJBIP,NBJGERSH,NBJMOIS,VALIDE,COMMENTAIRE)
  	(select ident, to_date(to_char(mois)||'/'||L_ANNEE,'mm/yyyy'), typeabsence,sum(coutbip),sum(coutgip),c.cjours,'N','Anomalie'
			from bjh_anomalies ba, ressource r, calendrier c
			where ba.TYPEABSENCE='ABSDIV'
			and r.matricule=ba.matricule
			and calanmois=to_date(to_char(mois)||'/'||L_ANNEE,'mm/yyyy')
			group by ident,mois,typeabsence,cjours
			having sum(coutgip)<>sum(coutbip)
  	 );



  	TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
	commit;


	-- --------------------------------------------------------------------------------------
	-- Etape 3 : On alimente la table RESSOURCE_ECART  par bouclage JH
	--           avec des données de la table BJH_ANOMALIES de type CONGES
	-- --------------------------------------------------------------------------------------


    L_STATEMENT := '* alimentation de RESSOURCE_ECART ECART par les écarts de type CONGES';
    TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );


	INSERT INTO RESSOURCE_ECART (IDENT,CDEB,TYPE,NBJBIP,NBJGERSH,NBJMOIS,VALIDE,COMMENTAIRE)
  	(select ident, to_date(to_char(mois)||'/'||L_ANNEE,'mm/yyyy'), 'CONGES', sum(coutbip), sum(coutgip), c.cjours, 'N', 'Anomalie'
			from bjh_anomalies ba, ressource r, calendrier c
			where ba.TYPEABSENCE<>'ABSDIV'
			and r.matricule=ba.matricule
			and calanmois=to_date(to_char(mois)||'/'||L_ANNEE,'mm/yyyy')
			group by ident,mois,cjours
			having sum(coutgip)<>sum(coutbip)
  	 );

	TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
  	commit;



	-- ------------------------------------------------------------------------------------------
	-- Etape 3 :  Calcul des retours arrière
	--            On compare chaque ligne de RESSOURCE_ECART avec les lignes de RESSOURCE_ECART_1
	-- ------------------------------------------------------------------------------------------



     L_STATEMENT := '* Calcul des retours arrière';
     TRCLOG.TRCLOG( L_HFILE, L_STATEMENT );
	 FOR curseur IN cur_re LOOP
	 	BEGIN
	 	  SELECT NBJBIP, NBJGERSH, NBJMOIS, VALIDE, COMMENTAIRE
			 into l_nbjbip, l_nbjgersh, l_nbjmois, l_valide, l_commentaire
		  FROM ressource_ecart_1 r
		  WHERE r.ident = curseur.ident
		  AND r.cdeb = curseur.cdeb
		  AND r.type = curseur.type
		  ;

		  IF (l_valide = 'O') THEN

				   IF ( (curseur.nbjbip=l_nbjbip) AND (curseur.nbjgersh=l_nbjgersh) ) THEN

			           UPDATE ressource_ecart
			           SET  VALIDE = l_valide,
			  	            COMMENTAIRE = l_commentaire
			           WHERE ident = curseur.ident
			           AND cdeb = curseur.cdeb
			           AND type = curseur.type
			           ;

				   END IF;

		  END IF;

		  EXCEPTION

			 WHEN No_Data_Found THEN

				UPDATE ressource_ecart
			    SET  VALIDE = curseur.valide,
			  	     COMMENTAIRE = curseur.commentaire
			    WHERE ident = curseur.ident
			    AND cdeb = curseur.cdeb
			    AND type = curseur.type
			    ;

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


end alim_bouclage_jh;




END packbatch_ressource_ecart;
/
