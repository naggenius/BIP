
-- Package pour l alimentation des tables de synthese
-- Créé le 24/02/2005 par MMC
-- Modifié le 25/05/2005 par PPR : Optimisation
-- Modifié le 31/08/2006 par PPR : Ajout de la gestion de la table Synthese_fin_ress ( par ressource )
-- Modifié le 11/05/2011 par ABA : QC 1100

CREATE OR REPLACE PACKAGE PACKBATCH_SYNTH_FIN AS

--****************************************************
-- Procédure globale d'alimentation des tables
--****************************************************
PROCEDURE globale (P_LOGDIR          IN VARCHAR2)  ;

--****************************************************
-- Procédures d'alimentation de la table synthese_fin
--****************************************************
PROCEDURE alim_synth_fin_fi(P_HFILE           IN utl_file.file_type)   ;
PROCEDURE alim_synth_fin_immo(P_HFILE           IN utl_file.file_type)   ;

--*******************************************************
-- Procédures d'alimentation de la table synthese_fin_bip
--*******************************************************
PROCEDURE alim_synth_fin_bip(P_HFILE           IN utl_file.file_type)   ;

--*******************************************************
-- Procédures d'alimentation de la table synthese_fin_ress
--*******************************************************
PROCEDURE alim_synth_fin_ress(P_HFILE           IN utl_file.file_type)   ;


END PACKBATCH_SYNTH_FIN;
/


CREATE OR REPLACE PACKAGE BODY PACKBATCH_SYNTH_FIN AS

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

--****************************************************
-- Procédure d'alimentation des tables pour le batch IAS
--****************************************************
PROCEDURE globale (P_LOGDIR          IN VARCHAR2)  IS

L_HFILE     utl_file.file_type;
L_RETCOD    number;
L_PROCNAME  varchar2(16) := 'SYNTH_FIN';

	BEGIN

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

		-----------------------------------------------------
		-- Lancement ...
		-----------------------------------------------------
		--Alimentation de la table SYNTHESE_FIN
	 	alim_synth_fin_fi( L_HFILE );
	 	alim_synth_fin_immo( L_HFILE );

	 	--Alimentation de la table SYNTHESE_FIN_BIP
	 	alim_synth_fin_bip( L_HFILE );

	 	--Alimentation de la table SYNTHESE_FIN_RESS
	 	alim_synth_fin_ress( L_HFILE );

		-----------------------------------------------------
		-- Trace Stop
		-----------------------------------------------------
		TRCLOG.TRCLOG( L_HFILE, 'Fin normale de ' || L_PROCNAME  );
		TRCLOG.CLOSETRCLOG( L_HFILE );

	EXCEPTION
		when others then
			if sqlcode <> CALLEE_FAILED_ID and sqlcode <> TRCLOG_FAILED_ID then
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


END globale;


--******************************************************************************
-- Procédure d'alimentation de la table SYNTHESE_FIN avec les donnees de stock_fi
--******************************************************************************
PROCEDURE alim_synth_fin_fi(P_HFILE           IN utl_file.file_type)   IS

L_RETCOD    number;
L_PROCNAME  varchar2(16) := 'ALIM_SYNT_FIN';
L_STATEMENT varchar2(128);
L_ANNEE     number;

BEGIN
	 TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

	 -- Année d'exercice
      	SELECT TO_NUMBER(TO_CHAR(datdebex, 'YYYY')) INTO L_ANNEE
      	FROM datdebex WHERE ROWNUM < 2;

	 -- on vide la table
	L_STATEMENT := '* vide synthese_fin de l annee courante';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	DELETE SYNTHESE_FIN
	WHERE annee=L_ANNEE;
	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	COMMIT;

	-- -------------------------------------------------------------
	-- Etape 1 : Insertion des lignes dans la table SYNTHESE_FIN si
	-- (annee,pid,codcamo,cafi,codsgress) n existe pas
	-- --------------------------------------------------------------
	L_STATEMENT := '* Etape 1 : Insertion des lignes dans la table SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	INSERT INTO SYNTHESE_FIN (ANNEE,
			PID,
			CODSG,
			CODCAMO,
			CAFI,
			CODSGRESS,
			CADA,
			CONSOJHSG_IM      ,
			CONSOJHSSII_IM,
			CONSOFTSG_IM,
			CONSOFTSSII_IM,
			CONSOJHSG_FI,
			CONSOJHSSII_FI,
			CONSOFTSG_FI,
			CONSOFTSSII_FI,
			CONSOENVSG_NI ,
			CONSOENVSSII_NI ,
			CONSOENVSG_IM ,
			CONSOENVSSII_IM ,
			D_CONSOJHSG_FI,
			D_CONSOJHSSII_FI,
			D_CONSOFTSG_FI,
			D_CONSOFTSSII_FI,
			D_CONSOENVSG_NI ,
			D_CONSOENVSSII_NI ,
			D_CONSOENVSG_IM ,
			D_CONSOENVSSII_IM ,
			M_CONSOJHSG_IM,
			M_CONSOJHSSII_IM,
			M_CONSOFTSG_IM,
			M_CONSOFTSSII_IM,
			M_CONSOJHSG_FI,
			M_CONSOJHSSII_FI,
			M_CONSOFTSG_FI,
			M_CONSOFTSSII_FI,
			M_CONSOENVSG_NI ,
			M_CONSOENVSSII_NI ,
			M_CONSOENVSG_IM ,
			M_CONSOENVSSII_IM,
			A_CONSOJH_IM,
			A_CONSOFT_IM,
			A_CONSOJH_FI ,
			A_CONSOFT_FI ,
			A_CONSOENV_NI,
			A_CONSOENV_IM)
	(SELECT distinct
      			L_ANNEE,
      			s.pid,
      			0,
      			s.codcamo,
      			s.cafi,
      			s.codsgress,
      			0,
      			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      	FROM		stock_fi s
	WHERE not exists (select 1 from synthese_fin sf
			  where sf.annee=L_ANNEE
      				and sf.pid=s.pid
      				and sf.codcamo=s.codcamo
      				and sf.cafi=s.cafi
      				and sf.codsgress=s.codsgress
      				)
	);
	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	commit;

	-- -------------------------------------------------------------
	-- Etape 2 : alimentation des champs concernant les SG
	-- --------------------------------------------------------------
	L_STATEMENT := '* Etape 2 : alimentation des champs concernant les SG dans SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

	UPDATE SYNTHESE_FIN SET (CONSOJHSG_FI,CONSOFTSG_FI,CONSOENVSG_NI,CONSOENVSG_IM,
				M_CONSOJHSG_FI,M_CONSOFTSG_FI,M_CONSOENVSG_NI,M_CONSOENVSG_IM)=
		(select NVL(sum(nvl(consojhimmo,0)+nvl(nconsojhimmo,0)),0),
		nvl(sum(consoft),0),
		nvl(sum(nconsoenvimmo),0),
		nvl(sum(consoenvimmo),0),
		NVL(sum((nvl(a_consojhimmo,0)+nvl(a_nconsojhimmo,0))),0),
		NVL(sum(a_consoft),0),
		NVL(sum(a_nconsoenvimmo),0),
		NVL(sum(a_consoenvimmo),0)
		from stock_fi fi
		where       fi.pid=SYNTHESE_FIN.pid
	      		and fi.codcamo=SYNTHESE_FIN.codcamo
      			and fi.cafi=SYNTHESE_FIN.cafi
      			and fi.codsgress=SYNTHESE_FIN.codsgress
      			and fi.soccode = 'SG..'
      		)
      	WHERE annee=L_ANNEE;

      	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes SG maj dans la table SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	commit;

	-- -------------------------------------------------------------
	-- Etape 3 : alimentation des champs concernant les SSII
	-- --------------------------------------------------------------
	L_STATEMENT := '* Etape 3 : alimentation des champs concernant les SSII dans SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

	UPDATE SYNTHESE_FIN SET (CONSOJHSSII_FI,CONSOFTSSII_FI,CONSOENVSSII_NI,CONSOENVSSII_IM,
				M_CONSOJHSSII_FI,M_CONSOFTSSII_FI,M_CONSOENVSSII_NI,M_CONSOENVSSII_IM)=
		(select NVL(sum(nvl(consojhimmo,0)+nvl(nconsojhimmo,0)),0),
		nvl(sum(consoft),0),
		nvl(sum(nconsoenvimmo),0),
		nvl(sum(consoenvimmo),0),
		NVL(sum((nvl(a_consojhimmo,0)+nvl(a_nconsojhimmo,0))),0),
		NVL(sum(a_consoft),0),
		NVL(sum(a_nconsoenvimmo),0),
		NVL(sum(a_consoenvimmo),0)
		from stock_fi fi
		where       fi.pid=SYNTHESE_FIN.pid
	      		and fi.codcamo=SYNTHESE_FIN.codcamo
      			and fi.cafi=SYNTHESE_FIN.cafi
      			and fi.codsgress=SYNTHESE_FIN.codsgress
      			and fi.soccode <> 'SG..'
      		)
      	WHERE annee=L_ANNEE;


      	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes SSII maj dans la table SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	commit;

 --SEL PPM 58986 les champs D_ sont a zero puisque stock_fi ne contient pas la FI de decembre N-1

	-- ----------------------------------------------------------------------
	-- Etape 4 : alimentation des champs concernant decembre N-1 pour les SG
	-- ----------------------------------------------------------------------
	/*
  L_STATEMENT := '* Etape 4 : alimentation des champs concernant les SG pour dec n-1 dans SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

	UPDATE SYNTHESE_FIN SET (D_CONSOJHSG_FI,D_CONSOFTSG_FI,D_CONSOENVSG_NI,D_CONSOENVSG_IM)=

  (select sum((nvl(consojhimmo,0)+nvl(nconsojhimmo,0))),sum(nvl(consoft,0)),sum(nvl(nconsoenvimmo,0)),sum(nvl(consoenvimmo,0))
		from stock_fi fi
		where fi.soccode = 'SG..'
		and to_number(to_char(fi.cdeb,'yyyy'))=(SYNTHESE_FIN.annee - 1)
		and to_number(to_char(fi.cdeb,'mm'))= 12
      		and fi.pid=SYNTHESE_FIN.pid
      		and fi.codcamo=SYNTHESE_FIN.codcamo
      		and fi.cafi=SYNTHESE_FIN.cafi
      		and fi.codsgress=SYNTHESE_FIN.codsgress
	)
      	WHERE annee=L_ANNEE;

	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes SG maj dans la table SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	commit;

	-- ----------------------------------------------------------------------
	-- Etape 5 : alimentation des champs concernant decembre N-1 pour les SSII
	-- ----------------------------------------------------------------------
	L_STATEMENT := '* Etape 5 : alimentation des champs concernant les SSII pour dec n-1 dans SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

	UPDATE SYNTHESE_FIN SET (D_CONSOJHSSII_FI,D_CONSOFTSSII_FI,D_CONSOENVSSII_NI,D_CONSOENVSSII_IM)=
	(select sum((nvl(consojhimmo,0)+nvl(nconsojhimmo,0))),sum(nvl(consoft,0)),sum(nvl(nconsoenvimmo,0)),sum(nvl(consoenvimmo,0))
		from stock_fi fi
		where fi.soccode <> 'SG..'
		and to_number(to_char(fi.cdeb,'yyyy'))=(SYNTHESE_FIN.annee - 1)
		and to_number(to_char(fi.cdeb,'mm'))= 12
      		and fi.pid=SYNTHESE_FIN.pid
      		and fi.codcamo=SYNTHESE_FIN.codcamo
      		and fi.cafi=SYNTHESE_FIN.cafi
      		and fi.codsgress=SYNTHESE_FIN.codsgress
	)
	WHERE annee=L_ANNEE;

	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes SSII maj dans la table SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	commit;
*/

	-- -------------------------------------------------------------------------------------
	-- Etape 4 : alimentation des champs concernant les mois inferieurs au mois de mensuelle
	-- -------------------------------------------------------------------------------------
	L_STATEMENT := '* Etape 4 : alimentation des champs concernant les retours arrieres dans SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

	UPDATE SYNTHESE_FIN SET (A_CONSOJH_FI,A_CONSOFT_FI,A_CONSOENV_NI,A_CONSOENV_IM )=
	(select sum((nvl(a_consojhimmo,0)+nvl(a_nconsojhimmo,0))),sum(nvl(a_consoft,0)),sum(nvl(a_nconsoenvimmo,0)),sum(nvl(a_consoenvimmo,0))
		from stock_fi fi,datdebex
		where to_number(to_char(fi.cdeb,'yyyy'))=SYNTHESE_FIN.annee
		and fi.cdeb < datdebex.moismens
      		and fi.pid=SYNTHESE_FIN.pid
      		and fi.codcamo=SYNTHESE_FIN.codcamo
      		and fi.cafi=SYNTHESE_FIN.cafi
      		and fi.codsgress=SYNTHESE_FIN.codsgress
	)
      	WHERE annee=L_ANNEE;

	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes < moimens maj dans la table SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	commit;


EXCEPTION
	when others then
		if sqlcode <> CALLEE_FAILED_ID then
				TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		end if;
		TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		raise CALLEE_FAILED;

END alim_synth_fin_fi ;

--******************************************************************************
-- Procédure d'alimentation de la table SYNTHESE_FIN avec les donnees de stock_immo
--******************************************************************************
PROCEDURE alim_synth_fin_immo(P_HFILE           IN utl_file.file_type)   IS

L_RETCOD    number;
L_PROCNAME  varchar2(16) := 'SYNT_FIN_IMMO';
L_STATEMENT varchar2(128);
L_ANNEE     number;

BEGIN
	 TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

	 -- Année d'exercice
      	SELECT TO_NUMBER(TO_CHAR(datdebex, 'YYYY')) INTO L_ANNEE
      	FROM datdebex WHERE ROWNUM < 2;

	-- -------------------------------------------------------------
	-- Etape 5 : Insertion des lignes dans la table SYNTHESE_FIN si
	-- (annee,pid,codcamo,cafi,codsgress) n existe pas
	-- --------------------------------------------------------------
	L_STATEMENT := '* Etape 5 : Insertion des lignes dans la table SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
		INSERT INTO SYNTHESE_FIN (ANNEE,
			PID,
			CODSG,
			CODCAMO,
			CAFI,
			CODSGRESS,
			CADA,
			CONSOJHSG_IM      ,
			CONSOJHSSII_IM,
			CONSOFTSG_IM,
			CONSOFTSSII_IM,
			CONSOJHSG_FI,
			CONSOJHSSII_FI,
			CONSOFTSG_FI,
			CONSOFTSSII_FI,
			CONSOENVSG_NI ,
			CONSOENVSSII_NI ,
			CONSOENVSG_IM ,
			CONSOENVSSII_IM ,
			D_CONSOJHSG_FI,
			D_CONSOJHSSII_FI,
			D_CONSOFTSG_FI,
			D_CONSOFTSSII_FI,
			D_CONSOENVSG_NI ,
			D_CONSOENVSSII_NI ,
			D_CONSOENVSG_IM ,
			D_CONSOENVSSII_IM ,
			M_CONSOJHSG_IM,
			M_CONSOJHSSII_IM,
			M_CONSOFTSG_IM,
			M_CONSOFTSSII_IM,
			M_CONSOJHSG_FI,
			M_CONSOJHSSII_FI,
			M_CONSOFTSG_FI,
			M_CONSOFTSSII_FI,
			M_CONSOENVSG_NI ,
			M_CONSOENVSSII_NI ,
			M_CONSOENVSG_IM ,
			M_CONSOENVSSII_IM,
			A_CONSOJH_IM,
			A_CONSOFT_IM,
			A_CONSOJH_FI ,
			A_CONSOFT_FI ,
			A_CONSOENV_NI,
			A_CONSOENV_IM)
	(SELECT distinct
      			L_ANNEE,
      			s.pid,
      			0,
      			s.codcamo,
      			s.cafi,
      			s.codsgress,
      			0,
      			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      	FROM		stock_immo s
	WHERE not exists (select 1 from synthese_fin sf
			  where sf.annee=L_ANNEE
      				and sf.pid=s.pid
      				and sf.codcamo=s.codcamo
      				and sf.cafi=s.cafi
      				and sf.codsgress=s.codsgress
      				)
	);

	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	commit;

	-- -------------------------------------------------------------
	-- Etape 6 : alimentation des champs concernant les SG
	-- --------------------------------------------------------------
	L_STATEMENT := '* Etape 6 : alimentation des champs concernant les SG dans SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

	UPDATE SYNTHESE_FIN SET (CONSOJHSG_IM,CONSOFTSG_IM,M_CONSOJHSG_IM,M_CONSOFTSG_IM)=
		(select sum((nvl(consojh,0))),sum((nvl(consoft,0))),sum((nvl(a_consojh,0))),sum((nvl(a_consoft,0)))
		from stock_immo si
		where si.soccode = 'SG..'
      		and si.pid=SYNTHESE_FIN.pid
      		and si.codcamo=SYNTHESE_FIN.codcamo
      		and si.cafi=SYNTHESE_FIN.cafi
      		and si.codsgress=SYNTHESE_FIN.codsgress
      		)
      	WHERE annee=L_ANNEE;

      	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes SG maj dans la table SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	commit;

	-- -------------------------------------------------------------
	-- Etape 7 : alimentation des champs concernant les SSII
	-- --------------------------------------------------------------
	L_STATEMENT := '* Etape 7 : alimentation des champs concernant les SSII dans SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

	UPDATE SYNTHESE_FIN SET (CONSOJHSSII_IM,CONSOFTSSII_IM,M_CONSOJHSSII_IM,M_CONSOFTSSII_IM)=
		(select sum((nvl(consojh,0))),sum((nvl(consoft,0))),sum((nvl(a_consojh,0))),sum((nvl(a_consoft,0)))
		from stock_immo si
		where si.soccode <> 'SG..'
      		and si.pid=SYNTHESE_FIN.pid
      		and si.codcamo=SYNTHESE_FIN.codcamo
      		and si.cafi=SYNTHESE_FIN.cafi
      		and si.codsgress=SYNTHESE_FIN.codsgress
      		)
      	WHERE annee=L_ANNEE;

      	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes SSII maj dans la table SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	commit;

	-- ----------------------------------------------------------------------
	-- Etape 8 : alimentation des retours arrieres
	-- ----------------------------------------------------------------------
	L_STATEMENT := '* Etape 8 : alimentation des retours arrieres dans SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

	UPDATE SYNTHESE_FIN SET (A_CONSOJH_IM,A_CONSOFT_IM)=
	(select sum((nvl(a_consojh,0))),sum((nvl(a_consoft,0)))
		from stock_immo si,datdebex
		where si.cdeb < datdebex.moismens
     		and si.pid=SYNTHESE_FIN.pid
      		and si.codcamo=SYNTHESE_FIN.codcamo
      		and si.cafi=SYNTHESE_FIN.cafi
      		and si.codsgress=SYNTHESE_FIN.codsgress
      		)
      	WHERE annee=L_ANNEE;

	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes maj dans la table SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	commit;

	-- ----------------------------------------------------------------------
	-- Etape 9 : mise à jour de codsg et de cada
	-- ----------------------------------------------------------------------
	L_STATEMENT := '* Etape 9 : mise à jour de codsg et de cada';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

	UPDATE SYNTHESE_FIN SET (codsg,cada)=
	(select l.codsg, p.cada
		from ligne_bip l , proj_info p
		where l.icpi = p.icpi
     		and l.pid=SYNTHESE_FIN.pid
      		)
      	WHERE annee=L_ANNEE;

	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes maj dans la table SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	commit;


EXCEPTION
	when others then
		if sqlcode <> CALLEE_FAILED_ID then
				TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		end if;
		TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		raise CALLEE_FAILED;

END alim_synth_fin_immo ;


--***************************************************************************
-- Procédure d'alimentation de la table synthese_fin_bip
--***************************************************************************
PROCEDURE alim_synth_fin_bip(P_HFILE IN utl_file.file_type)   IS

L_PROCNAME  varchar2(16) := 'SYNTH_BIP';
L_STATEMENT varchar2(128);
L_ANNEE     number;


BEGIN

TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

 -- Année d'exercice
SELECT TO_NUMBER(TO_CHAR(datdebex, 'YYYY')) INTO L_ANNEE
FROM datdebex WHERE ROWNUM < 2;

-- on vide la table
L_STATEMENT := '* vide synthese_fin_bip de l annee courante';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	DELETE SYNTHESE_FIN_BIP
	WHERE annee = L_ANNEE;
	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes supprimées dans SYNTHESE_FIN_BIP';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
COMMIT;

-- on alimente la table de synthese avec les données contenues dans synthese_fin

L_STATEMENT := '* alimentation de synthese_fin_bip';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

	INSERT INTO SYNTHESE_FIN_BIP
		(PID,
		ANNEE,
		CONSOFTSG_IM,
		CONSOFTSSII_IM,
  		CONSOSG_FI,
  		CONSOSSII_FI,
  		D_CONSOSG_FI,
  		D_CONSOSSII_FI,
  		M_CONSOSG_FI,
  		M_CONSOSSII_FI)
	  	(select PID,
	  		L_ANNEE ,
	  		NVL(SUM(CONSOFTSG_IM),0),
	  		NVL(SUM(CONSOFTSSII_IM),0),
	  		NVL(SUM(CONSOFTSG_FI + CONSOENVSG_NI + CONSOENVSG_IM),0) ,
	  		NVL(SUM(CONSOFTSSII_FI + CONSOENVSSII_NI + CONSOENVSSII_IM),0) ,
	  		NVL(SUM(D_CONSOFTSG_FI + D_CONSOENVSG_NI + D_CONSOENVSG_IM),0) ,
	  	 	NVL(SUM(D_CONSOFTSSII_FI + D_CONSOENVSSII_NI + D_CONSOENVSSII_IM),0) ,
	  		NVL(SUM(M_CONSOFTSG_FI + M_CONSOENVSG_NI + M_CONSOENVSG_IM),0) ,
	  		NVL(SUM(M_CONSOFTSSII_FI + M_CONSOENVSSII_NI + M_CONSOENVSSII_IM),0)
	  	 from SYNTHESE_FIN
	  	 where annee= L_ANNEE
	  	 group by PID
	  	 );

  	commit;
L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes inserees dans SYNTHESE_FIN_BIP';
TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );


	TRCLOG.TRCLOG( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);
EXCEPTION
	when others then
	    rollback;
		if sqlcode <> CALLEE_FAILED_ID then
				TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		end if;
		TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		raise CALLEE_FAILED;


END alim_synth_fin_bip;


--******************************************************************************
-- Procédure d'alimentation de la table SYNTHESE_FIN_RESS avec les donnees de stock_fi
--******************************************************************************
PROCEDURE alim_synth_fin_ress(P_HFILE           IN utl_file.file_type)   IS

L_RETCOD    number;
L_PROCNAME  varchar2(20) := 'ALIM_SYNT_FIN_RESS';
L_STATEMENT varchar2(128);
L_ANNEE     number;

BEGIN
	 TRCLOG.TRCLOG( P_HFILE, 'Debut de ' || L_PROCNAME );

	 -- Année d'exercice
      	SELECT TO_NUMBER(TO_CHAR(datdebex, 'YYYY')) INTO L_ANNEE
      	FROM datdebex WHERE ROWNUM < 2;

	 -- on vide la table
	L_STATEMENT := '* vide synthese_fin_ress de l annee courante';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	Packbatch.DYNA_TRUNCATE('SYNTHESE_FIN_RESS');
	COMMIT;

	-- -------------------------------------------------------------
	-- Etape 1 : Insertion des lignes dans la table SYNTHESE_FIN_RESS
	-- --------------------------------------------------------------
	L_STATEMENT := '* Etape 1 : Insertion des lignes dans la table SYNTHESE_FIN';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	INSERT INTO SYNTHESE_FIN_RESS (ANNEE,
			PID,
			IDENT,
			CODCAMO,
			CAFI,
			CONSOJH_IM,
			CONSOJH_NI,
			CONSOFT,
			CONSOENV_IM,
			CONSOENV_NI,
			D_CONSOJH_IM,
			D_CONSOJH_NI,
			D_CONSOFT,
			D_CONSOENV_IM,
			D_CONSOENV_NI)
	(SELECT 	L_ANNEE,
      			s.pid,
      			s.ident,
      			s.codcamo,
      			s.cafi,
      			nvl(sum(s.consojhimmo),0),
      			nvl(sum(s.nconsojhimmo),0),
      			nvl(sum(s.consoft),0),
				nvl(sum(s.consoenvimmo),0),
				nvl(sum(s.nconsoenvimmo),0),
      			0,0,0,0,0
      	FROM		stock_fi s
      	GROUP BY    s.pid, s.ident, s.codcamo, s.cafi
	);

	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table SYNTHESE_FIN_RESS';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	commit;

/*
 --SEL PPM 58986 les champs D_ sont a zero puisque stock_fi ne contient pas la FI de decembre N-1 

	-- ----------------------------------------------------------------------
	-- Etape 2 : alimentation des champs concernant decembre N-1
	-- ----------------------------------------------------------------------
	L_STATEMENT := '* Etape 2 : alimentation des champs pour dec n-1 dans SYNTHESE_FIN_RESS';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );

	UPDATE SYNTHESE_FIN_RESS SET (D_CONSOJH_IM,
			D_CONSOJH_NI,
			D_CONSOFT,
			D_CONSOENV_IM,
			D_CONSOENV_NI)=
	(select 	nvl(sum(fi.consojhimmo),0),
      			nvl(sum(fi.nconsojhimmo),0),
      			nvl(sum(fi.consoft),0),
				nvl(sum(fi.consoenvimmo),0),
				nvl(sum(fi.nconsoenvimmo),0)
		from stock_fi fi
		where  to_number(to_char(fi.cdeb,'yyyy'))=(SYNTHESE_FIN_RESS.annee - 1)
		and to_number(to_char(fi.cdeb,'mm'))= 12
      		and fi.pid=SYNTHESE_FIN_RESS.pid
      		and fi.codcamo=SYNTHESE_FIN_RESS.codcamo
      		and fi.cafi=SYNTHESE_FIN_RESS.cafi
      		and fi.ident=SYNTHESE_FIN_RESS.ident
	)	;

	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes SG maj dans la table SYNTHESE_FIN_RESS';
	TRCLOG.TRCLOG( P_HFILE, L_STATEMENT );
	commit;
*/


EXCEPTION
	when others then
		if sqlcode <> CALLEE_FAILED_ID then
				TRCLOG.TRCLOG( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		end if;
		TRCLOG.TRCLOG( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		raise CALLEE_FAILED;

END alim_synth_fin_ress ;

END PACKBATCH_SYNTH_FIN;
/


