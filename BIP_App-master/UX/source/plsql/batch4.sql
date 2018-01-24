/*
	Nom:	batch4.SQL

	Objet:	Fonctions diverses pour les traitements batch

	Historique:
		07/02/2002	O. Duprey	Création du fichier
		02/04/2002	O. Duprey	Correction du traitement de rejet du consomme
		03/04/2002	O. Duprey	Ajout de traitt de rejet des fichiers de mauvaises versions
		22/07/2002      A.Remens        Ajout de la jointure avec cons_sstache_res dans copie_consomme
		17/04/2003	MMC ajout de :
				-rejet_datestatut pour éliminer les lignes de statut Demarre
				dont la DATE de statut est < moismens-1
				-purge_rejet_datestatut : purge de la TABLE temporaire batch_rejet_datestatut
				-copie_datestatut : insertion dans etape,tache,cons_sstache_res,cons_sstache_res_mois pour 
				les lignes avec de la ssous-traitance avec astatut='D' et adatestatut<moismens-1
		16/07/2004	OTO : suppression des procédures citées ci-dessus pour leur intégration à batch.sql
		11/08/2004	MMC : ajout procedure ALIM_REJET pour allimenter la table TMP_REJETMENS
		03/11/2005	PPR : dans Rejet_Ligne_BIP rejette ‚galement les lignes de type 9
		29/12/2009  ABA : TD 875
		20/10/2014  SEL : PPM 59283 : prendre en compte les consommés 0 dans le rapport des rejets
		12/01/2015  SEL : PPM 60708 : Ne pas prendre compte dans le rejet les consommés qui ne font pas obejet d'une RAZ
				
*/

CREATE OR REPLACE PACKAGE packbatch4 IS
-- ##################################################################################################
--	Transert des consommes de CONS_SSTACHE_RES_MOIS vers CONS_SSTACHE_RES_MOIS_REJET
--	pour differents cas de rejet :
--		DATE de consomme superieure a DATE de changement de statut
--		DATE de consomme superieure a DATE des donnees
--		Ligne BIP fermee
-- ##################################################################################################
	PROCEDURE filtrer_consomme( P_HFILE utl_file.file_type );


-- ##################################################################################################
--	constantes correspondant aux motifs de rejet
-- ##################################################################################################
	REJET_STATUT			CONSTANT CHAR(1):='T';
	REJET_STATUT_SS_TRAITANCE	CONSTANT CHAR(1):='S';
	REJET_DONNEE_AVENIR		CONSTANT CHAR(1):='A';
	REJET_FERMEE			CONSTANT CHAR(1):='F';
	REJET_FERMEE_SS_TRAITANCE	CONSTANT CHAR(1):='G';
	REJET_RESSOURCE_INCONNUE	CONSTANT CHAR(1):='R';
	REJET_LBIP_INCONNUE		CONSTANT CHAR(1):='L';
	REJET_LBIP_TYPE9		CONSTANT CHAR(1):='K';


-- ##################################################################################################
--	Mise a jour des informations concernant la situation de la ressource
--	dans la table BATCH_PROPLUS_COMPLUS pour toutes les ressources
-- ##################################################################################################
	PROCEDURE Maj_Situation_Proplus( P_HFILE utl_file.file_type );


-- ##################################################################################################
--	Suppression de toutes les informations provenant de PMW pour lesquels
--	le numero de version de Remontee BIP (PMW_LIGNE_BIP.PMWBIPVERS) n'est pas le bon
--	(le bon est select max( NUMTP) into L_MAXNUMTP from VERSION_TP)
-- ##################################################################################################
	PROCEDURE Rejet_Version_RBIP( P_HFILE utl_file.file_type );


-- ##################################################################################################
--	Copie du consomme depuis PMW_CONSOMM vers CONS_SSTACHE_RES_MOIS
-- ##################################################################################################
	PROCEDURE Copie_Consomme( P_HFILE utl_file.file_type );


-- ##################################################################################################
--	Rejet du consomme sur les ressources qui n'existent pas
-- ##################################################################################################
	PROCEDURE Rejet_Ressource( P_HFILE utl_file.file_type );


-- ##################################################################################################
--	Rejet du consomme sur les lignes BIP qui n'existent pas
-- ##################################################################################################
	PROCEDURE Rejet_Ligne_BIP( P_HFILE utl_file.file_type );


-- ##################################################################################################
--	Purge de la table des rejets
-- ##################################################################################################
	PROCEDURE Purge_rejet( P_HFILE utl_file.file_type );

-- ##################################################################################################
--	Alimentation de TMP_REJETMENS
-- ##################################################################################################
	PROCEDURE Alim_rejet( P_HFILE utl_file.file_type );

END packbatch4;
/

create or replace PACKAGE BODY packbatch4 IS
--gestion des exceptions
CONSTRAINT_VIOLATION exception;          -- pour clause when
pragma exception_init( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère
	PROCEDURE filtrer_consomme( P_HFILE utl_file.file_type ) IS
-- ##################################################################################################
		l_moismens	DATE;
		l_annee		DATE;
		l_statement	VARCHAR2(2000);
	BEGIN
		TRCLOG.TRCLOG( P_HFILE, 'Debut du traitement de filtrage du consomme');

		l_statement:='Lecture de DATDEBEX';
		SELECT moismens, datdebex INTO l_moismens, l_annee FROM datdebex;

/*
	MaJ des dates limites pour chaque TACHE (en fait ce sont des sous-taches) :
		- RaZ
		- DATE changement statut sans ss-traitance		T
		- DATE changement statut avec ss-traitance		S
		- DATE des donnees					A
		- DATE changement statut si ligne BIP fermee		F
		- DATE changement statut si ligne BIP fermee avec ss-tr	G
*/
		l_statement:='RAZ de TACHE';
		UPDATE tache SET cdeb_max=NULL, motif_rejet=NULL;

		l_statement:='Maj de la date pour les motifs REJET_STATUT';
		UPDATE tache
			SET cdeb_max=(SELECT adatestatut FROM ligne_bip WHERE ligne_bip.pid=tache.pid)
				, motif_rejet=REJET_STATUT
			WHERE aistty!='FF' OR aistty IS NULL;


		l_statement:='Maj de la date pour les motifs REJET_STATUT_SS_TRAITANCE';
		UPDATE tache
			SET cdeb_max=(SELECT adatestatut FROM ligne_bip WHERE ligne_bip.pid=tache.aistpid)
				, motif_rejet=REJET_STATUT_SS_TRAITANCE
			WHERE aistty='FF';

		l_statement:='Maj de la date pour les motifs REJET_DONNEE_AVENIR';
		UPDATE tache
			SET cdeb_max=l_moismens
				, motif_rejet=REJET_DONNEE_AVENIR
			WHERE cdeb_max IS NULL
				OR cdeb_max>l_moismens;

		l_statement:='Maj de la date pour les motifs REJET_FERMEE';
		UPDATE tache
			SET cdeb_max=(SELECT adatestatut FROM ligne_bip WHERE ligne_bip.pid=tache.pid)
				, motif_rejet=REJET_FERMEE
			WHERE pid IN (SELECT pid FROM ligne_bip WHERE topfer='O')
				AND (aistty!='FF' OR aistty IS NULL);

		l_statement:='Maj de la date pour les motifs REJET_FERMEE_SS_TRAITANCE';
		UPDATE tache
			SET cdeb_max=(SELECT adatestatut FROM ligne_bip WHERE ligne_bip.pid=tache.aistpid)
				, motif_rejet=REJET_FERMEE_SS_TRAITANCE
			WHERE aistpid IN (SELECT pid FROM ligne_bip WHERE topfer='O')
				AND aistty='FF';

/*
	Transert des consommes de CONS_SSTACHE_RES_MOIS vers CONS_SSTACHE_RES_MOIS_REJET
*/
		l_statement:='INSERT dans la table des rejets';
		INSERT INTO cons_sstache_res_mois_rejet
			(cdeb, cdur, cusag, chraf, chinit, pid, ecet, acta, acst, ident, motif_rejet)
			SELECT cons_sstache_res_mois.cdeb
				, cons_sstache_res_mois.cdur
				, cons_sstache_res_mois.cusag
				, cons_sstache_res_mois.chraf
				, cons_sstache_res_mois.chinit
				, cons_sstache_res_mois.pid
				, cons_sstache_res_mois.ecet
				, cons_sstache_res_mois.acta
				, cons_sstache_res_mois.acst
				, cons_sstache_res_mois.ident
				, tache.motif_rejet
			FROM tache
				, cons_sstache_res_mois
			WHERE cons_sstache_res_mois.pid=tache.pid
				AND cons_sstache_res_mois.ecet=tache.ecet
				AND cons_sstache_res_mois.acta=tache.acta
				AND cons_sstache_res_mois.acst=tache.acst
				AND cdeb > cdeb_max
				AND cdeb >= l_annee;

/*
	Suppression des consommes de CONS_SSTACHE_RES_MOIS
*/
		l_statement:='DELETE de la table des consommes';
		DELETE cons_sstache_res_mois
			WHERE cdeb >
				(SELECT cdeb_max
				FROM tache
					WHERE cons_sstache_res_mois.pid=tache.pid
					AND cons_sstache_res_mois.ecet=tache.ecet
					AND cons_sstache_res_mois.acta=tache.acta
					AND cons_sstache_res_mois.acst=tache.acst
				)
				AND cdeb >= l_annee;

		COMMIT;
		TRCLOG.TRCLOG( P_HFILE, 'Fin du traitement de filtrage du consomme');
	EXCEPTION
		WHEN OTHERS THEN
			TRCLOG.TRCLOG( P_HFILE, 'Fin anormale du traitement de filtrage du consomme');
			TRCLOG.TRCLOG( P_HFILE, l_statement);
			TRCLOG.TRCLOG( P_HFILE, SQLERRM);
			RAISE;
	END filtrer_consomme;

-- ##################################################################################################
        PROCEDURE Maj_Situation_Proplus( P_HFILE utl_file.file_type ) IS
	BEGIN
		TRCLOG.TRCLOG( P_HFILE, 'Debut du traitement de Maj des situations dans PROPLUS.');

		update BATCH_PROPLUS_COMPLUS
		set ( DATDEP, DIVSECGROU, CPIDENT, COUT, SOCIETE, QUALIF, DISPO ) =
		( select DATDEP, CODSG, CPIDENT, COUT, SOCCODE, PRESTATION, DISPO
		  from SITU_RESS_FULL
		  where BATCH_PROPLUS_COMPLUS.TIRES = SITU_RESS_FULL.IDENT
			and ( (BATCH_PROPLUS_COMPLUS.CDEB>=SITU_RESS_FULL.DATSITU OR SITU_RESS_FULL.DATSITU IS NULL)
			      and (BATCH_PROPLUS_COMPLUS.CDEB<=SITU_RESS_FULL.DATDEP OR SITU_RESS_FULL.DATDEP IS NULL)
			    )
			and ROWNUM=1		-- petite condition pour se proteger contre les situations en recouvrement
		);
		commit;

		TRCLOG.TRCLOG( P_HFILE, 'Fin du traitement de Maj des situations dans PROPLUS.');
	EXCEPTION
		WHEN OTHERS THEN
			TRCLOG.TRCLOG( P_HFILE, 'Fin anormale du traitement de Maj des situations dans PROPLUS.');
			TRCLOG.TRCLOG( P_HFILE, SQLERRM);
			RAISE;
	END Maj_Situation_Proplus;



-- ##################################################################################################
	PROCEDURE Rejet_Version_RBIP( P_HFILE utl_file.file_type ) IS
		L_MaxVersion	CHAR(2);
		l_statement	VARCHAR2(255);
	BEGIN
		TRCLOG.TRCLOG( P_HFILE, 'Debut du traitement de rejet des versions eronnees de PMW');

-- recuperation de la bonne version
		l_statement:='Lecture de la bonne version de PMW';
		SELECT MAX(numtp)
			INTO L_MaxVersion
			FROM Version_TP;

-- suppression du consomme
		l_statement:='Suppression du consomme';
		DELETE pmw_consomm WHERE pid IN (SELECT pid FROM pmw_ligne_bip WHERE pmwbipvers<>L_MaxVersion);

-- suppression des affectations
		l_statement:='Suppression des affectations';
		DELETE pmw_affecta WHERE pid IN (SELECT pid FROM pmw_ligne_bip WHERE pmwbipvers<>L_MaxVersion);

-- suppression des sous-taches
		l_statement:='Suppression des sous-taches';
		DELETE pmw_activite WHERE pid IN (SELECT pid FROM pmw_ligne_bip WHERE pmwbipvers<>L_MaxVersion);

-- suppression des lignes BIP
		l_statement:='Suppression des lignes BIP';
		DELETE pmw_ligne_bip WHERE pmwbipvers<>L_MaxVersion;

-- et on valide !
		l_statement:='Validation';
		COMMIT;

		TRCLOG.TRCLOG( P_HFILE, 'Fin du traitement de rejet des versions eronnees de PMW');
	EXCEPTION
		WHEN OTHERS THEN
			TRCLOG.TRCLOG( P_HFILE, 'Fin anormale du traitement de rejet des versions eronnees de PMW');
			TRCLOG.TRCLOG( P_HFILE, l_statement);
			TRCLOG.TRCLOG( P_HFILE, SQLERRM);
			RAISE;
	END Rejet_Version_RBIP;




-- ##################################################################################################
	PROCEDURE Copie_Consomme( P_HFILE utl_file.file_type ) IS
		l_statement		VARCHAR2(255);
		l_annee_courante	DATE;
	BEGIN
		TRCLOG.TRCLOG( P_HFILE, 'Debut du traitement de copie du consomme dans CONS_SSTACHE_RES_MOIS');

-- recuperation de l'annee courante
		l_statement:='Lecture de l''annee courante';
		SELECT datdebex
			INTO l_annee_courante
			FROM datdebex;

-- copie des donnees
		l_statement:='Copie des donnees';
		INSERT INTO cons_sstache_res_mois
			(pid, ecet, acta, acst, ident, cdeb, cdur, cusag, chinit, chraf)
			SELECT PMW_CONSOMM.PID					-- PID
				, ccet					-- etape
				, ccta					-- tache
				, ccst					-- ss-tache
				, TO_NUMBER(SUBSTR(cires, 1, 5))	-- identifiante ressource
				, TRUNC(cdeb, 'month')			-- mois de consomme
				, NULL					-- duree en jours ouvrables du mois de consomme
				, SUM(cusag)				-- consomme
				, 0					-- charge initiale
				, 0					-- reste a faire
			FROM pmw_consomm,cons_sstache_res c
			WHERE PMW_CONSOMM.PID = c.pid
				AND ccet = c.ecet
				AND ccta = c.acta
				AND ccst = c.acst
				AND TO_NUMBER(SUBSTR(cires, 1, 5)) = c.ident
				AND cusag!=0
				AND cdeb>=l_annee_courante
				AND chtyp=1
			GROUP BY PMW_CONSOMM.PID, ccet, ccta, ccst, TO_NUMBER(SUBSTR(cires, 1, 5)), TRUNC(cdeb, 'month');

-- validation
		l_statement:='Validation';
		COMMIT;

		TRCLOG.TRCLOG( P_HFILE, 'Fin du traitement de copie du consomme dans CONS_SSTACHE_RES_MOIS');
	EXCEPTION
		WHEN OTHERS THEN
			TRCLOG.TRCLOG( P_HFILE, 'Fin anormale du traitement de copie du consomme dans CONS_SSTACHE_RES_MOIS');
			TRCLOG.TRCLOG( P_HFILE, l_statement);
			TRCLOG.TRCLOG( P_HFILE, SQLERRM);
			RAISE;
	END Copie_Consomme;



-- ##################################################################################################
	PROCEDURE Rejet_Ressource( P_HFILE utl_file.file_type ) IS
		l_statement	VARCHAR2(255);
	BEGIN
		TRCLOG.TRCLOG( P_HFILE, 'Debut du traitement de rejet du consomme portant sur des ressources inconnues');

-- en passant on remplace les identifiants "joker" de ressources par zero
		l_statement:='Maj identifiants ressources ******';
		UPDATE pmw_consomm SET cires='00000*' WHERE cires='******';

-- toutes les lignes qui correspondent a des ressources inconnues sont copiees dans cons_sstache_res_mois_rejet
		l_statement:='Copie des donnees a rejeter dans CONS_SSTACHE_RES_MOIS_REJET';
		INSERT INTO cons_sstache_res_mois_rejet
			(cdeb, cusag, pid, ecet, acta, acst, ident, motif_rejet)
			SELECT cdeb, cusag, pid, ccet, ccta, ccst, TO_NUMBER(SUBSTR(cires, 1, 5)), REJET_RESSOURCE_INCONNUE
			FROM pmw_consomm
			WHERE NOT EXISTS
				(SELECT ident FROM ressource WHERE ident=TO_NUMBER(SUBSTR(pmw_consomm.cires, 1, 5)));

-- toutes les lignes qui correspondent a des ressources inconnues sont supprimees de pmw_consomm
		l_statement:='Suppression des lignes pour les ressources inconnues';
		DELETE pmw_consomm
			WHERE NOT EXISTS
				(SELECT ident FROM ressource WHERE ident=TO_NUMBER(SUBSTR(pmw_consomm.cires, 1, 5)));

-- validation
		l_statement:='Validation';
		COMMIT;

		TRCLOG.TRCLOG( P_HFILE, 'Fin du traitement de rejet du consomme portant sur des ressources inconnues');
	EXCEPTION
		WHEN OTHERS THEN
			TRCLOG.TRCLOG( P_HFILE, 'Fin du traitement de rejet du consomme portant sur des ressources inconnues');
			TRCLOG.TRCLOG( P_HFILE, l_statement);
			TRCLOG.TRCLOG( P_HFILE, SQLERRM);
			RAISE;
	END Rejet_Ressource;


-- ##################################################################################################
	PROCEDURE Rejet_Ligne_BIP( P_HFILE utl_file.file_type ) IS
		l_statement     VARCHAR2(255);
	BEGIN
		TRCLOG.TRCLOG( P_HFILE, 'Debut du traitement de rejet du consomme portant sur des lignes BIP inconnues');

		l_statement:='copie des donnees dans CONS_SSTACHE_RES_MOIS_REJET';
		INSERT INTO cons_sstache_res_mois_rejet
			(cdeb, cusag, pid, ecet, acta, acst, ident, motif_rejet)
			SELECT cdeb, cusag, pid, ccet, ccta, ccst, TO_NUMBER(SUBSTR(cires, 1, 5)), REJET_LBIP_INCONNUE
			FROM pmw_consomm
			WHERE NOT EXISTS
			(SELECT pid FROM ligne_bip where pid=PMW_CONSOMM.PID);

-- toutes les lignes qui correspondent a des lignes bip inconnues sont supprimees de pmw_consomm
		DELETE pmw_consomm
			WHERE NOT EXISTS
			(SELECT pid FROM ligne_bip where pid=PMW_CONSOMM.PID);

-- D¿tecte les lignes bip de type 9
		INSERT INTO cons_sstache_res_mois_rejet
			(cdeb, cusag, pid, ecet, acta, acst, ident, motif_rejet)
			SELECT cdeb, cusag, pid, ccet, ccta, ccst, TO_NUMBER(SUBSTR(cires, 1, 5)), REJET_LBIP_TYPE9
			FROM pmw_consomm
			WHERE pid in
			(SELECT pid FROM ligne_bip where typproj='9');

-- toutes les lignes qui correspondent a des lignes bip de type 9 sont supprimees de pmw_consomm
		DELETE pmw_consomm
			WHERE pid in
			(SELECT pid FROM ligne_bip where typproj='9');

-- validation
		l_statement:='Validation';
		COMMIT;

		TRCLOG.TRCLOG( P_HFILE, 'Fin du traitement de rejet du consomme portant sur des lignes BIP inconnues');
	EXCEPTION
		WHEN OTHERS THEN
		TRCLOG.TRCLOG( P_HFILE, 'Fin anormale du traitement de rejet du consomme portant sur des lignes BIP inconnues');
		TRCLOG.TRCLOG( P_HFILE, SQLERRM);
		TRCLOG.TRCLOG( P_HFILE, l_statement);
		RAISE;
	END Rejet_Ligne_BIP;



-- ##################################################################################################
	PROCEDURE Purge_rejet( P_HFILE utl_file.file_type ) IS
		l_statement     VARCHAR2(255);
	BEGIN
--	Purge des precedents consommes rejetes
		l_statement:='Purge de CONS_SSTACHE_RES_MOIS_REJET';
		DELETE cons_sstache_res_mois_rejet;


-- validation
		l_statement:='Validation';
		COMMIT;
	EXCEPTION
		WHEN OTHERS THEN
		TRCLOG.TRCLOG( P_HFILE, 'Fin anormale du traitement de rejet du consomme portant sur des lignes BIP inconnues');
		TRCLOG.TRCLOG( P_HFILE, SQLERRM);
		TRCLOG.TRCLOG( P_HFILE, l_statement);
		RAISE;
	END Purge_rejet;

-- ##################################################################################################
	PROCEDURE Alim_rejet ( P_HFILE utl_file.file_type ) IS
		l_statement     VARCHAR2(255);

	l_moismens DATE;

	BEGIN

	  BEGIN
      TRCLOG.TRCLOG( P_HFILE, 'Suppression des données de TMP_REJETMENS');
  --	Purge de la table temporaire
      l_statement:='Purge de TMP_REJETMENS';

		DELETE TMP_REJETMENS;
-- validation
		l_statement:='Validation';
		COMMIT;
  	EXCEPTION
      WHEN OTHERS THEN
      TRCLOG.TRCLOG( P_HFILE, 'Fin anormale de la suppression des données de TMP_REJETMENS');
      TRCLOG.TRCLOG( P_HFILE, SQLERRM);
      TRCLOG.TRCLOG( P_HFILE, l_statement);
      RAISE;

   END;


	BEGIN
		SELECT moismens INTO l_moismens FROM datdebex;
    
    

		TRCLOG.TRCLOG( P_HFILE, 'Debut de l insertion des donnees de rejet du traitement mensuel');
-- insertion des rejets de cons_sstache_res_mois_rejet
		l_statement:='Copie des donnees de CONS_SSTACHE_RES_MOIS_REJET';
		INSERT INTO tmp_rejetmens
  		(SELECT c.pid,l.codsg,c.ecet,c.acta,c.acst,c.ident,c.cdeb,c.cusag,c.motif_rejet
   		FROM cons_sstache_res_mois_rejet c,ligne_bip l
	 	WHERE l.pid=c.pid
	 	-- 59283 AND c.cusag <> 0
    )
	 	;

	 	UPDATE tmp_rejetmens SET motif_rejet='A'
	 	WHERE motif_rejet='R'
	 	AND cdeb >l_moismens;

-- insertion des rejets de sstrt
		l_statement:='Copie des donnees de SSTRT';
		INSERT INTO tmp_rejetmens
  		(SELECT pid,pdsg,ecet,acta,acst,tires,cdeb,cusag,motif_rejet FROM sstrt
  		)
  		;
-- insertion des rejets de batch_rejet_datestatut
		l_statement:='Copie des donnees de BATCH_REJET_DATESTATUT';
		INSERT INTO tmp_rejetmens
		 (SELECT b.pid,l.codsg,b.ecet,b.acta,b.acst,to_number(rtrim (b.cires,'*')),b.cdeb,b.cusag,DECODE(b.sstrait,'O','O','N')
		 FROM BATCH_REJET_DATESTATUT b,ligne_bip l
			WHERE
			b.cusag not in (select c.cusag from CONS_SSTACHE_RES_MOIS c
				where b.pid=c.pid
				AND c.cdeb=b.cdeb
				AND c.ident=to_number(rtrim (b.cires,'*'))
				AND c.ecet=b.ecet
				AND c.acta=b.acta
				AND c.acst=b.acst
			-- 59283	AND c.cusag is not null
        )
			and b.pid=l.pid
			-- 59283 and b.cusag <> 0
  		)
  		;


       --DEBUT SEL PPM 60708 : Ne pas rejeter les consommes qui ont été a 0 depuis toujours (les supprimer des rejets)
    BEGIN
    TRCLOG.TRCLOG(P_HFILE,'Suppression des données qui ne font pas objet d''une RAZ de consommés de CONS_SSTACHE_RES_MOIS_REJET');
    l_statement:='Purge données non RAZ de CONS_SSTACHE_RES_MOIS_REJET';


    DELETE FROM tmp_rejetmens rejet WHERE
    rejet.cusag=0         --le consomme est a 0

    AND


    NOT EXISTS                --Et il n y a pas eu de consommes
          (SELECT * FROM  cons_sstache_res_mois_back back WHERE
            rejet.cdeb= back.cdeb
            AND
            rejet.pid= back.pid
            AND
            rejet.ecet= back.ecet
            AND
            rejet.acta= back.acta
            AND
            rejet.acst=back.acst
            AND
            rejet.ident=back.ident
          );


    l_statement:='Validation';
    TRCLOG.TRCLOG(P_HFILE,'Suppression des données qui ne font pas objet d''une RAZ de consommés de CONS_SSTACHE_RES_MOIS_REJET ('|| SQL%ROWCOUNT ||' lignes supprimées)');
    COMMIT;
    











      







    



commit;







    EXCEPTION

    WHEN OTHERS THEN
    TRCLOG.TRCLOG( P_HFILE, 'Fin anormale de la suppression des données RAZ de CONS_SSTACHE_RES_MOIS_REJET');
    TRCLOG.TRCLOG( P_HFILE, SQLERRM);
    TRCLOG.TRCLOG( P_HFILE, l_statement);
    RAISE;

    END;
    --FIN SEL PPM 60708*/




-- validation
		l_statement:='Validation';
		COMMIT;

		TRCLOG.TRCLOG( P_HFILE, 'Fin du traitement d insertion des donnees de rejet du traitement mensuel');
	EXCEPTION
		WHEN OTHERS THEN
			TRCLOG.TRCLOG( P_HFILE, 'Fin anormale du traitement d insertion des donnees de rejet du traitement mensuel');
			TRCLOG.TRCLOG( P_HFILE, l_statement);
			TRCLOG.TRCLOG( P_HFILE, SQLERRM);
			RAISE;
	END;
	END Alim_rejet;



END packbatch4;
/