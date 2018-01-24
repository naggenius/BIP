-- APPLICATION 
-- -----------------------------------------------------------------------------------------------
-- pack_rtfe PL/SQL
-- 
-- Ce package contient les differents procedures qui permet l'alimentation de stock_fi 
--par les données de répartition
-- 
--
-- Crée        	le 08/11/2005 par BAA
-- Modifié     	le 05/04/2006 par PPR : Optilisation
-- Modifié     	le 27/07/2006 par JMA : TD 448 : ajout metier à la procédure pack_utile_cout.getCoutEnv 
-- 13/07/2011  	ABA   QC 1229
-- Modifié		le 13/01/2015 par SEL :	PPM 60415 mise a jour des CAFIs
--*************************************************************************************************
--
-- Attention le nom du package ne peut etre le nom
-- de la table...





CREATE OR REPLACE PACKAGE Packbatch_Ias_Rjh AS


   -- Utilitaire : Facturation interne des consommés de répartition
	-- -----------------------------------------------------------------------------------------------------------------
   PROCEDURE ALIM_IAS( P_HFILE IN UTL_FILE.FILE_TYPE );

   -- Utilitaire : Alimentation de la table RJH_IAS
   -- -----------------------------------------------------------------------------------------------------------
       PROCEDURE ALIM_RJH_IAS( P_HFILE IN UTL_FILE.FILE_TYPE );


   -- Utilitaire : Ajout des couts dans la table RJH_IAS
   -- -------------------------------------------------------------------------------------------------------------
     PROCEDURE MAJ_RJH_IAS_COUTS( P_HFILE IN UTL_FILE.FILE_TYPE );


	-- Utilitaire : Ajout des consommés dans la table RJH_IAS
	-- -----------------------------------------------------------------------------------------------------------------
	 PROCEDURE MAJ_RJH_IAS_CONS( P_HFILE IN UTL_FILE.FILE_TYPE );


	 -- Utilitaire : Alimentation de stock_fi
	-- -----------------------------------------------------------------------------------------------------------------
	 PROCEDURE ALIM_STOCK_FI_RJH( P_HFILE IN UTL_FILE.FILE_TYPE );

END Packbatch_Ias_Rjh;
/


CREATE OR REPLACE PACKAGE BODY     Packbatch_Ias_Rjh AS

-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
PRAGMA EXCEPTION_INIT( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     NUMBER := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     NUMBER := -20001;   -- problème : erreur dans la gestion d'erreur !
ERR_FONCTIONNELLE_ID NUMBER := -20002;   -- pour provoquer erreur alors que Oracle OK
CONSTRAINT_VIOLATION EXCEPTION;          -- pour clause when
VIOLATION_CONSTRAINT_UNIQUE EXCEPTION;          -- pour clause when
PRAGMA EXCEPTION_INIT( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère
PRAGMA EXCEPTION_INIT( VIOLATION_CONSTRAINT_UNIQUE, -00001 );
CA_IMMO_SC_AVEC_FI  NUMBER := 99820;    --SEL PPM 60415 centre d'activité pour calculer les immos sans lien avec la compte et calculer la FI






-- Utilitaire : Facturation interne des consommés de répartition
	-- -----------------------------------------------------------------------------------------------------------------
   PROCEDURE ALIM_IAS(P_HFILE IN UTL_FILE.FILE_TYPE ) IS

   L_PROCNAME  VARCHAR2(16) := 'ALIM_IAS';
   L_STATEMENT VARCHAR2(128);
   L_RETCOD    NUMBER;




BEGIN


    -----------------------------------------------------
	-- Trace Start
	-----------------------------------------------------


    Trclog.Trclog( P_HFILE, 'Debut de ' || L_PROCNAME );


    -- ------------------------------------------------------------------------------------------------------
	-- Etape 1 : Alimentation de la table RJH_IAS
	-- ------------------------------------------------------------------------------------------------------

	 Packbatch_Ias_Rjh.ALIM_RJH_IAS( P_HFILE );

	-- ------------------------------------------------------------------------------------------------------
	-- Etape 2 : Ajout des couts dans la table RJH_IAS
	-- ------------------------------------------------------------------------------------------------------

      Packbatch_Ias_Rjh.MAJ_RJH_IAS_COUTS( P_HFILE);

   	-- ------------------------------------------------------------------------------------------------------
	-- Etape 3 : Ajout des consommés dans la table RJH_IAS
	-- ------------------------------------------------------------------------------------------------------

      Packbatch_Ias_Rjh.MAJ_RJH_IAS_CONS( P_HFILE);


	   	-- ------------------------------------------------------------------------------------------------------
	-- Etape 4 : Alimentation de stock_fi
	-- ------------------------------------------------------------------------------------------------------

      Packbatch_Ias_Rjh.ALIM_STOCK_FI_RJH( P_HFILE);




    Trclog.Trclog( P_HFILE, 'Fin NORMALE de ' || L_PROCNAME);

EXCEPTION
	WHEN OTHERS THEN
	    ROLLBACK;
		IF SQLCODE <> CALLEE_FAILED_ID THEN
				Trclog.Trclog( P_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		END IF;
		Trclog.Trclog( P_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		RAISE CALLEE_FAILED;


END ALIM_IAS;









-- Utilitaire : Alimentation de la table RJH_IAS
-- -----------------------------------------------------------------------------------------------------------
PROCEDURE ALIM_RJH_IAS( P_HFILE IN UTL_FILE.FILE_TYPE ) IS

 L_STATEMENT VARCHAR2(128);

BEGIN


     L_STATEMENT := '* Troncature de la table RJH_IAS';
	Trclog.Trclog( P_HFILE, L_STATEMENT );

	  -- Troncature RJH_CONSOMME
	  Packbatch.DYNA_TRUNCATE('RJH_IAS');


    L_STATEMENT := '* Insertion des lignes dans la table RJH_IAS';
	Trclog.Trclog( P_HFILE, L_STATEMENT );

		INSERT INTO RJH_IAS (CDEB,
		   				 	 	   		   		   		 	PID,
															IDENT,
															TYPPROJ ,
															METIER,
															PNOM,
                        									CODSG,
                                           					DPCODE,
                       										ICPI,
                       										CODCAMO,
                        									CLIBRCA,
                       										CAFI,
                        									CODSGRESS,
                       										LIBDSG,
                        									RNOM,
                        									RTYPE,
                        									PRESTATION,
                        									NIVEAU,
                        									SOCCODE,
                        									CADA
                       						              )
	  (	SELECT DISTINCT
   	   		    	   									  rc.cdeb ,
														  rc.pid,
      													  r.ident ,
														  l.typproj ,
														  RTRIM(l.METIER) ,
														  l.pnom ,
														  l.codsg ,
														  l.dpcode ,
														  l.icpi ,
														  l.codcamo ,
														  ca.clibrca ,
														  si2.CAFI ,
														  sr.codsg  codsgress,
														  si2.libdsg ,
 														  r.rnom,
														  r.rtype,
														  sr.PRESTATION,
														  sr.NIVEAU,
														  sr.soccode ,
														  p.cada
   		FROM
				RJH_CONSOMME rc,
				SITU_RESS_FULL sr ,
				LIGNE_BIP l ,
				RESSOURCE r,
				CENTRE_ACTIVITE ca,
				PROJ_INFO p,
				STRUCT_INFO si2,
				DOSSIER_PROJET dp,
				DATDEBEX d
	WHERE
	-- Consommés sur l'année courante :
 		TO_CHAR(rc.cdeb,'YYYY')=TO_CHAR(d.moismens,'YYYY')
		AND TO_CHAR(rc.cdeb,'MM')<= TO_CHAR(d.moismens,'MM')
	-- jointure ligne_bip et rjh_consomme
		AND l.pid=rc.pid
	-- jointure ligne_bip et centre_activite
		AND l.codcamo = ca.codcamo
   -- On ne prend pas les lignes dont le ctopact est égal à S
		AND ca.ctopact<>'S'
 	-- jointure ligne_bip et projet_info
		AND l.icpi = p.icpi
	-- jointure ligne_bip et dossier_projet
		AND l.dpcode = dp.dpcode
	-- jointure cons_sstache_res et situ_ress
         AND r.ident =sr.ident
		 AND rc.ident = r.ident
		 AND rc.ident = sr.ident
		AND (rc.cdeb >=sr.datsitu OR sr.datsitu IS NULL)
		AND (rc.cdeb <=sr.datdep OR sr.datdep IS NULL )
	-- On ne prend pas les lignes dont le consommé est égal à 0
	     AND rc.consojh<>0
	-- ressource dont le CAFI du DPG <> 99999 et 88888 et 99810 (immos sans lien avec la compta et pas de FI)
		AND sr.codsg=si2.codsg
		AND si2.CAFI<>88888
		AND si2.CAFI<>99999
        AND si2.CAFI<>99810
	-- ressource dont la prestation <>(IFO,MO ,GRA,INT,STA)
		AND sr.PRESTATION NOT IN ('IFO','MO ','GRA','INT','STA')
   -- TYPE de la ligne =9
	  AND  l.typproj=9
	-- Centre d'activité de la ligne <> 66666 : Exclut lignes d'origine de la répartition
	 AND  l.codcamo<>66666
	  ) ;


	COMMIT;

	Trclog.Trclog( P_HFILE, L_STATEMENT ||':-'||SQL%rowcount||' lignes insérées dans la table RJH_IAS');



 END ALIM_RJH_IAS;


-- Utilitaire : Ajout des couts dans la table RJH_IAS
-- -------------------------------------------------------------------------------------------------------------
PROCEDURE MAJ_RJH_IAS_COUTS( P_HFILE IN UTL_FILE.FILE_TYPE ) IS

L_STATEMENT VARCHAR2(128);
l_annee  NUMBER(4);

BEGIN

     -- Récupère l'année en cours dans une variable
	SELECT TO_NUMBER( TO_CHAR( DATDEBEX, 'YYYY') )
	INTO l_annee
	FROM DATDEBEX;

    L_STATEMENT := '* Ajout des couts dans la table RJH_IAS';
	Trclog.Trclog( P_HFILE, L_STATEMENT );

	-- COUT FORCE DE TRAVAIL
	-- * SG : on prend le coût déjà HTR à partir de la table des coûts standards SG COUT_STD_SG des lignes dont le code société ='SG..',le type='P' par année,niveau,métier,dpg
	-- * Logiciel :coût logiciel HTR de la table COUT_STD2 en fonction du DPG de la ressource

		L_STATEMENT := '* Ajout COUT FORCE DE TRAVAIL SG et Logiciel';
		Trclog.Trclog( P_HFILE, L_STATEMENT );

		UPDATE RJH_IAS
		SET coutft= Pack_Utile_Cout.getCout( RJH_IAS.soccode, RJH_IAS.rtype, l_annee, RJH_IAS.METIER,
												RJH_IAS.NIVEAU, RJH_IAS.codsgress, 0)
		WHERE  RJH_IAS.soccode='SG..'
			OR RJH_IAS.rtype='L';

	COMMIT;

	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes modifiées dans la table RJH_IAS';
	Trclog.Trclog( P_HFILE, L_STATEMENT );



	-- * SSII : on calcule le coût HTR de la situation de la ressource dont le code société est <>'SG..' , le type='P' avec une situation en cours pour l'année courante
	-- * Forfait Hors Site et sur Site:coût HTR de la situation de la ressource saisi en coût HT dont le type=('E','F') avec une situation en cours.

	L_STATEMENT := '* Ajout COUT FORCE DE TRAVAIL SSII et Forfait';
	Trclog.Trclog( P_HFILE, L_STATEMENT );

	UPDATE RJH_IAS
	SET (coutftht,coutft) = (SELECT DISTINCT NVL(s.cout,0),
			Pack_Utile_Cout.AppliqueTauxHTR (l_annee, NVL(s.cout,0) , TO_CHAR(RJH_IAS.cdeb,'DD/MM/YYYY'), '01 ')
			FROM SITU_RESS_FULL s
			WHERE  s.ident =RJH_IAS.ident
			AND (RJH_IAS.cdeb>=s.datsitu OR s.datsitu IS NULL)
			AND (RJH_IAS.cdeb<=s.datdep OR s.datdep IS NULL)
			)
	WHERE
	 	RJH_IAS.soccode!='SG..'
		AND RJH_IAS.rtype!='L';

	COMMIT;


	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes modifiées dans la table RJH_IAS';
	Trclog.Trclog( P_HFILE, L_STATEMENT );


	-- COUT D'ENVIRONNEMENT
	-- * SG,SSII,Forfait sur Site : coût d'environnement en HTR de la table COUT_STD2 en fonction du DPG de la ressource

	L_STATEMENT := '* Ajout COUT D''ENVIRONNEMENT SG,SSII,Forfait sur Site';
	Trclog.Trclog( P_HFILE, L_STATEMENT );

	UPDATE RJH_IAS
	SET coutenv= Pack_Utile_Cout.getCoutEnv(RJH_IAS.soccode, RJH_IAS.rtype, l_annee , RJH_IAS.codsgress, RJH_IAS.metier)
	WHERE  RJH_IAS.rtype != 'L'
	 AND RJH_IAS.rtype!='E' ;

    COMMIT;


	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes modifiées dans la table RJH_IAS';
	Trclog.Trclog( P_HFILE, L_STATEMENT );




END MAJ_RJH_IAS_COUTS;



-- Utilitaire : Ajout des consommés dans la table RJH_IAS
-- -----------------------------------------------------------------------------------------------------------------

PROCEDURE MAJ_RJH_IAS_CONS( P_HFILE IN UTL_FILE.FILE_TYPE ) IS

L_STATEMENT VARCHAR2(128);

BEGIN

	--	calcul du conso en jh de la ressource pour une ligne donnée, pour un mois donné et  une ressource à partir du conso de la table RJH_CONSOMME
	L_STATEMENT := '* Calcul du conso en jh';
	Trclog.Trclog( P_HFILE, L_STATEMENT );


   UPDATE RJH_IAS
   SET consojh = (SELECT NVL(SUM(r.consojh),0)
					              FROM RJH_CONSOMME r
					              WHERE  r.pid = RJH_IAS.pid
					             AND r.ident = RJH_IAS.ident
					            AND r.cdeb = RJH_IAS.cdeb
	 );
	COMMIT;

	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes modifiées dans la table RJH_IAS';
	Trclog.Trclog( P_HFILE, L_STATEMENT );


	--	Calcul du conso en euros de la force de travail : consoft = consojh*coutft
	--  et des frais d'environnement : consoenv = consojh*coutenv
	L_STATEMENT := '* Calcul des consos FT et ENV';
	Trclog.Trclog( P_HFILE, L_STATEMENT );
	UPDATE RJH_IAS
	SET (consoft, consoenv) = (SELECT NVL(i.consojh,0)*NVL(i.coutft,0),
				  		                                                    NVL(i.consojh,0)*NVL(i.coutenv,0)
														  FROM RJH_IAS i
	                                                      WHERE i.pid=RJH_IAS.pid
	                                                      AND i.ident=RJH_IAS.ident
	                                                      AND i.cdeb=RJH_IAS.cdeb
	);
	COMMIT;

	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes modifiées dans la table RJH_IAS';
	Trclog.Trclog( P_HFILE, L_STATEMENT );


	END MAJ_RJH_IAS_CONS;


-- Utilitaire : Alimentation de stock_fi
-- -----------------------------------------------------------------------------------------------------------------
PROCEDURE ALIM_STOCK_FI_RJH( P_HFILE IN UTL_FILE.FILE_TYPE ) IS

L_STATEMENT VARCHAR2(128);

BEGIN

	--Prendre les lignes de la table RJH_IAS
	L_STATEMENT := '* Insertion des lignes de la table STOCK_FI';
    Trclog.Trclog( P_HFILE, L_STATEMENT );
	INSERT INTO STOCK_FI (
						  				   	  	 	   cdeb	,
													   pid,
													   ident,
													   typproj,
													   METIER,
													   pnom,
													   codsg,
													   dpcode,
													   icpi,
													   codcamo,
													   clibrca,
													   CAFI	,
													   codsgress,
													   libdsg,
													   rnom	,
													   rtype,
													   PRESTATION,
													   NIVEAU,
													   soccode	,
													   cada	,
													   coutftht	,
													   coutft,
													   coutenv,
													   nconsojhimmo 	,
													   consoft ,
													   nconsoenvimmo,
													   consojhimmo ,
													   consoenvimmo
													   )
	(SELECT
						cdeb,
						pid	,
						ident,
						MAX(typproj) 		typproj,
						MAX(METIER) 		METIER,
						MAX(pnom) 		pnom,
						MAX(codsg) 		codsg,
						MAX(dpcode) 		dpcode,
						MAX(icpi),
						MAX(codcamo),
						MAX(clibrca),
						MAX(CAFI),
						MAX(codsgress),
						MAX(libdsg),
						MAX(rnom),
						MAX(rtype),
						MAX(PRESTATION)	,
						MAX(NIVEAU),
						MAX(soccode),
						MAX(cada),
						MAX(NVL(coutftht,0)) ,
						MAX(NVL(coutft,0)) ,
						MAX(NVL(coutenv,0)) ,
						SUM(NVL(consojh,0)),
						SUM(NVL(consoft,0)),
						SUM(NVL(consoenv,0)),
						0,
						0
						FROM RJH_IAS
						GROUP BY cdeb,pid,ident
	);
	COMMIT;

	L_STATEMENT := '-> '||SQL%ROWCOUNT ||' lignes insérées dans la table STOCK_FI';
	Trclog.Trclog( P_HFILE, L_STATEMENT );
  
  --SEL 30/12/2014 PPM 60415
  
  L_STATEMENT := '* (ALIM_STOCK_FI_RJH) Mise à jour du CAFI des lignes FI appartenant aux immos sans lien avec la compta';
  Trclog.Trclog( P_HFILE, L_STATEMENT );
  
  UPDATE stock_fi fi set fi.cafi = (select centractiv from struct_info s where s.codsg = fi.codsgress)
  WHERE fi.cafi = CA_IMMO_SC_AVEC_FI;
  
  L_STATEMENT := '-> '||SQL%ROWCOUNT ||' (ALIM_STOCK_FI_RJH) lignes imodifiées dans la table STOCK_FI';
  Trclog.Trclog( P_HFILE, L_STATEMENT );

END ALIM_STOCK_FI_RJH;





END Packbatch_Ias_Rjh;
/
