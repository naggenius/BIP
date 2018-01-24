--***********************************************************************
--
-- Equipe SOPRA
--
-- Cr\351e le 03/05/2002
--
--***********************************************************************
--
-- modification du 24/09/02 CRI regles gestion top fermeture
-- MMC 15/04/03 suppression du filtre sur les lignes de TYPE 5
--
-- Le 11/07/2005 par DDI : Fiche 226 : Passage du type2 sur 3 caract\350res
-- Le 12/01/2006 par PPR : Fiche 335 : Alimentation de Metrique
-- Le 16/08/2006 par DDI : Fiche 450 : Alimentation de DIVA
-- Le 01/09/2006 par DDI : Fiche 450 : Optimisation requete DIVA Lignes.
-- Le 10/10/2006 par DDI : Fiche 450 : Modification des specifications DIVA.
-- Le 13/10/2006 par DDI : Fiche 450 : RE Modification des specifications DIVA.
-- Le 17/10/2006 par PPR : Ajout du statut diva
-- Le 17/11/2006 par DDI : Fiche 450 : Ajout des types 5 dans DIVA Lignes.
-- Le 07/12/2006 par DDI : Fiche 450 : Modification de la gestion des tops pourDIVA
-- Le 11/12/2006 par DDI : Fiche 450 : Modification extraction ligne bip pour DIVA (type 8)
-- Le 08/02/2007 par ASI : Fiche 450 : retour arriere sur la procédure ressources_diva
-- Le 13/02/2007 par DDI : Fiche 450 : Ajout des Logiciels sur la procédure ressources_diva

-- Le 19/06/2007 par BPO : Fiche 550 : Modification de la taille du champ correspondant au libelle du Dossier Projet

-- Le 25/06/2007 par DDI :           : PB formatage des zones de montants.
-- Le 12/10/2007 par EVI :           : Prise en compte du nouveau top diva (top_diva_int) dans la selection des ressources pour diva.
-- Le 15/11/2007 par DDI : Fiche 592 : Ajout des types 6 dans Export Lignes DIVA.
-- Le 26/11/2008 par EVI : Fiche 688: Modification du traitement export ligne DIVA entre le 01/01/yyyy et la date de cloture
-- le 30/06/2010 ABA : correction de l'extraction diva_ressource utilisation du format de date DD/MM/RRRR
-- 19/01/2012 ABA : QC 1358
--***********************************************************************

CREATE OR REPLACE PACKAGE PACK_OSCAR_LIGNEBIP AS

   PROCEDURE alim_oscar (
                            p_type    IN VARCHAR2
                );

   PROCEDURE select_oscar_lignebip (
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2
                );

   PROCEDURE lance_oscar_lignebip (
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2
                );

   PROCEDURE oscar_ressource (
                        p_chemin_fichier        IN VARCHAR2,
                        p_nom_fichier           IN VARCHAR2
                );


   PROCEDURE select_bip_pma (
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2
                );

        PROCEDURE select_bip_metrique (
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2
       );

        PROCEDURE diva_ressources (
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2
       );

        PROCEDURE diva_lignes_notifie (
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2
       );

END pack_oscar_lignebip;
/


CREATE OR REPLACE PACKAGE BODY "PACK_OSCAR_LIGNEBIP" AS

   PROCEDURE alim_oscar ( p_type IN VARCHAR2
                       )IS
	-- algorythme  :
	-- on crée une table temporaire de même structure que le fichier oscar en sortie
	-- à chaque appel de la procédure d'alimentation de la table temporaire on delete ce qu'il y a dedans
	-- puis on alimente toutes les colonnes qui contiennent des données différentes des budgets ou consommé
	-- on met les colonnes budgétaires ou de consommé à NULL
	-- puis on update la table à partir des tables budget consomme et proplus
	-- une fois la table ok on fait le select sur toute la table


	-- delete de la table temporaire tmp_oscar
	BEGIN
		DELETE FROM TMP_OSCAR;
		COMMIT;
	-- alimentation de la table temporaire tmp_oscar
	-- dans un premier temp on insère les données pour les colonnes différentes du budget ou du consommé
	  BEGIN


		INSERT INTO TMP_OSCAR ( pid,
					DATDEBEX,
					pnom,
					typproj,
					dpcode,
					dplib,
					sigdeppole,
					clisigle,
					codcamo,
					codpspe ,
					icpi,
					ilibel,
					factint,
					airt ,
					alibel,
					arctype,
					rnom ,
					pnmouvra,
					bpmontme ,
					bpmontme1,
					bpmontme2,
					bpmontme3,
					bnmont,
					reserve,
					anmont,
					xcusmois,
					cusag,
					xcusag,
					reestime,
					METIER,
					topfer,
					cle_bip,
                                        astatut,
                                        adatestatut,
					bpmontmo,
					bpmontmo1
				      )
				      ( SELECT  lb.pid,
						d.DATDEBEX,
						lb.pnom,
						lb.typproj,
						lb.dpcode,
						RPAD(NVL(DP.dplib,' '),50,' '),
						sti.sigdep||'/'||NVL(sti.sigpole,' '),
						cmo.clisigle,
						lb.codcamo,
						lb.codpspe,
						lb.icpi,
						RPAD(NVL(PI.ilibel,' '),50,' '),
						conskf.factint,
						lb.airt,
						RPAD(NVL(AP.alibel,' '),50,' '),
						lb.arctype,
						ress.rnom,
						lb.pnmouvra,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						lb.METIER,
						lb.topfer,
						lb.pcle,
						lb.astatut,
						lb.adatestatut,
						NULL,
						NULL
					FROM  	LIGNE_BIP lb,
						DATDEBEX		d,
        					RESSOURCE ress,
        					PROJ_INFO PI,
        					DOSSIER_PROJET DP,
        					APPLICATION AP,
        					STRUCT_INFO   sti,
						(SELECT ROUND((SUM(consoft+consoenvimmo+nconsoenvimmo)/1000),1)	factint,
						LIGNE_BIP.pid
						FROM 	LIGNE_BIP
							, STOCK_FI
						WHERE STOCK_FI.pid(+) = LIGNE_BIP.pid
						AND LIGNE_BIP.typproj NOT IN (p_type)
						AND LIGNE_BIP.codsg > 1
						GROUP BY LIGNE_BIP.pid
          					) CONSKF,
        					CLIENT_MO cmo
					WHERE	lb.pcpi = ress.ident
					AND lb.codsg = sti.codsg
					AND lb.clicode = cmo.clicode
					AND     lb.pid = CONSKF.pid(+)
					AND lb.icpi    = PI.icpi
  					AND lb.airt    = AP.airt
 					AND lb.dpcode  = DP.dpcode
        				AND sti.coddep != '50'
        				AND     lb.typproj != p_type );

		COMMIT;



	  END;
	-- deuxième temps on update le table tmp_oscar pour les colonnes budgétaires

	  BEGIN

		UPDATE TMP_OSCAR SET 	bpmontme = (SELECT bpmontme FROM BUDGET,DATDEBEX
							WHERE annee = TO_NUMBER(TO_CHAR(DATDEBEX.DATDEBEX,'YYYY'))
							AND BUDGET.pid = TMP_OSCAR.pid),
					bpmontme1 = (SELECT bpmontme FROM BUDGET,DATDEBEX
							WHERE annee = TO_NUMBER(TO_CHAR(DATDEBEX.DATDEBEX,'YYYY')) +1
							AND BUDGET.pid = TMP_OSCAR.pid) ,
					bpmontme2 = (SELECT bpmontme FROM BUDGET,DATDEBEX
							WHERE annee = TO_NUMBER(TO_CHAR(DATDEBEX.DATDEBEX,'YYYY')) +2
							AND BUDGET.pid = TMP_OSCAR.pid),
					bpmontme3 = (SELECT bpmontme FROM BUDGET,DATDEBEX
							WHERE annee = TO_NUMBER(TO_CHAR(DATDEBEX.DATDEBEX,'YYYY')) +3
							AND BUDGET.pid = TMP_OSCAR.pid),
					bnmont = (SELECT bnmont FROM BUDGET,DATDEBEX
							WHERE annee = TO_NUMBER(TO_CHAR(DATDEBEX.DATDEBEX,'YYYY'))
							AND BUDGET.pid = TMP_OSCAR.pid) ,
					reserve = (SELECT reserve FROM BUDGET,DATDEBEX
							WHERE annee = TO_NUMBER(TO_CHAR(DATDEBEX.DATDEBEX,'YYYY'))
							AND BUDGET.pid = TMP_OSCAR.pid),
					anmont = (SELECT anmont FROM BUDGET,DATDEBEX
							WHERE annee = TO_NUMBER(TO_CHAR(DATDEBEX.DATDEBEX,'YYYY'))
							AND BUDGET.pid = TMP_OSCAR.pid),
					reestime = (SELECT reestime FROM BUDGET,DATDEBEX
							WHERE annee = TO_NUMBER(TO_CHAR(DATDEBEX.DATDEBEX,'YYYY'))
							AND BUDGET.pid = TMP_OSCAR.pid),
					bpmontmo = (SELECT bpmontmo FROM BUDGET,DATDEBEX
							WHERE annee = TO_NUMBER(TO_CHAR(DATDEBEX.DATDEBEX,'YYYY'))
							AND BUDGET.pid = TMP_OSCAR.pid),
					bpmontmo1 = (SELECT bpmontmo FROM BUDGET,DATDEBEX
							WHERE annee = TO_NUMBER(TO_CHAR(DATDEBEX.DATDEBEX,'YYYY')) +1
							AND BUDGET.pid = TMP_OSCAR.pid);


		COMMIT;

	  END;

	-- troisième temps on update la table tmp_oscar pour les colonnes de consomme

	  BEGIN

		UPDATE TMP_OSCAR SET 	cusag = (SELECT cusag FROM CONSOMME,DATDEBEX
							WHERE annee = TO_NUMBER(TO_CHAR(DATDEBEX.DATDEBEX,'YYYY'))
							AND CONSOMME.pid = TMP_OSCAR.pid),
					xcusag = (SELECT xcusag FROM CONSOMME,DATDEBEX
							WHERE annee = TO_NUMBER(TO_CHAR(DATDEBEX.DATDEBEX,'YYYY'))
							AND CONSOMME.pid = TMP_OSCAR.pid),
					xcusmois = (SELECT conso_mois.xcusmois FROM
							(SELECT factpid pid,SUM(cusag) xcusmois
							FROM PROPLUS, DATDEBEX,LIGNE_BIP lb
							WHERE PROPLUS.factpid=lb.pid
							AND (qualif NOT IN ('MO','GRA','STA','INT','IFO') OR qualif IS NULL)
							AND TRUNC(PROPLUS.cdeb,'MONTH')=TRUNC(DATDEBEX.moismens,'MONTH')
	 						GROUP BY factpid
	 						)conso_mois
							WHERE conso_mois.pid = TMP_OSCAR.pid);


		COMMIT;
	  END;

	-- quatrième temps on update la table tmp_oscar pour les lignes de type T1 le top fermeture
	BEGIN

		UPDATE TMP_OSCAR SET topfer = 'N'
			WHERE astatut IS NULL
			AND   adatestatut IS NULL;

		UPDATE TMP_OSCAR SET topfer = 'O'
			WHERE astatut IN ('D','A','C')
			AND   adatestatut <= SYSDATE;


		UPDATE TMP_OSCAR SET topfer = 'N'
			WHERE astatut IN ('D','A','C')
			AND   adatestatut > SYSDATE;

		COMMIT;

	END;

   END alim_oscar;

   PROCEDURE select_oscar_lignebip (
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2) IS


       l_hfile UTL_FILE.FILE_TYPE;
       l_datdebex NUMBER(4);
       l_msg  VARCHAR2(1024);

-- déclaration du curseur pour oscar
	CURSOR curs_oscar IS
	SELECT RPAD(NVL(pid,' '),4,' ') pid,
        LPAD(TO_CHAR(DATDEBEX,'YYYY'),4,' ') DATDEBEX,
        RPAD(NVL(REPLACE(pnom,'"',' '),' '),30,' ') pnom,
        RPAD(NVL(typproj,' '),1,' ') typproj,
        RPAD(TO_CHAR(NVL(dpcode,0)),5,' ') dpcode,
        LPAD(TO_CHAR(NVL(bpmontme,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontme,
        LPAD(TO_CHAR(NVL(bpmontme1,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontme1,
        LPAD(TO_CHAR(NVL(bpmontme2,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontme2,
        LPAD(TO_CHAR(NVL(bpmontme3,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontme3,
	LPAD(TO_CHAR(NVL(bnmont,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bnmont,
	LPAD(TO_CHAR(NVL(reserve,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') reserve,
	LPAD(TO_CHAR(NVL(anmont,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') anmont,
	LPAD(TO_CHAR(NVL(xcusmois,'0'), 'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') xcusmois,
	LPAD(TO_CHAR(NVL(cusag,'0'), 'FM999990D00','NLS_NUMERIC_CHARACTERS='',.'),8,' ') cusag,
	LPAD(TO_CHAR(NVL(xcusag,'0'), 'FM999990D00','NLS_NUMERIC_CHARACTERS='',.'),8,' ') xcusag,
	LPAD(TO_CHAR(NVL(reestime,'0'),'FM999990D00','NLS_NUMERIC_CHARACTERS='',.'),8,' ') reestime,
	RPAD(sigdeppole,7,' ') sigdeppole,
	RPAD(NVL(clisigle,' '),8,' ') clisigle,
	RPAD(TO_CHAR(NVL(codcamo,0)),5,' ') codcamo,
	RPAD(NVL(codpspe,' '),1,' ') codpspe,
	RPAD(NVL(icpi,' '),5,' ') icpi,
	LPAD(TO_CHAR(NVL(factint,'0'),'FM999990D00','NLS_NUMERIC_CHARACTERS='',.'),8,' ') factint,
	RPAD(NVL(airt,' '),5,' ') airt,
	RPAD(NVL(arctype,' '),3,' ') arctype,
	RPAD(NVL(REPLACE(rnom,'"',' '),' '),30,' ') rnom,
	RPAD(NVL(REPLACE(pnmouvra,'"',' '),' '),15,' ') pnmouvra,
	RPAD(NVL(METIER,' '),3,' ') METIER,
	RPAD(NVL(topfer,' '),1,' ') topfer,
	RPAD(NVL(cle_bip,' '),3,' ') cle_bip,
	LPAD(TO_CHAR(NVL(bpmontmo,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontmo,
	LPAD(TO_CHAR(NVL(bpmontmo1,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontmo1,
	RPAD(NVL(dplib,' '),35,' ') libdp,
	RPAD(NVL(ilibel,' '),50,' ') libproj,
	RPAD(NVL(alibel,' '),50,' ') libappli
FROM    TMP_OSCAR
ORDER BY RPAD(NVL(pid,' '),4,' ');


   BEGIN


      SELECT TO_NUMBER(TO_CHAR(DATDEBEX,'YYYY')) INTO l_datdebex FROM DATDEBEX;


      Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);


    FOR cur_enr IN curs_oscar
      LOOP
        Pack_Global.WRITE_STRING( l_hfile,
                                   '"' ||cur_enr.pid 				|| '";' ||
                                   cur_enr.DATDEBEX				|| ';"' ||
                                   cur_enr.pnom 				|| '";"' ||
                                   cur_enr.typproj			 	|| '";"' ||
                                   cur_enr.dpcode 				|| '";' ||
                                   cur_enr.bpmontme 				|| ';' ||
                                   cur_enr.bpmontme1 				|| ';' ||
                                   cur_enr.bpmontme2				|| ';' ||
                                   cur_enr.bpmontme3 				|| ';' ||
				   cur_enr.bnmont 				|| ';' ||
                                   LPAD(TO_CHAR(0,'FM0D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') 	|| ';' ||
				   cur_enr.anmont 				|| ';' ||
                                   cur_enr.xcusmois 				|| ';' ||
				   cur_enr.cusag 				|| ';' ||
                                   cur_enr.xcusag 				|| ';' ||
                                   cur_enr.reestime 				|| ';"' ||
                                   cur_enr.sigdeppole 				|| '";"' ||
                                   cur_enr.clisigle 				|| '";"' ||
                                   cur_enr.codcamo 				|| '";"' ||
				   cur_enr.codpspe 				|| '";"' ||
				   cur_enr.icpi 				|| '";' ||
				   cur_enr.factint				|| ';"' ||
                                   cur_enr.airt 				|| '";"' ||
                                   cur_enr.arctype	 			|| '";"' ||
                                   cur_enr.rnom 				|| '";"' ||
                                   cur_enr.pnmouvra 				|| '";"' ||
				   cur_enr.METIER				|| '";"' ||
				   cur_enr.topfer				|| '";"' ||
				   cur_enr.cle_bip				|| '";' ||
				   cur_enr.bpmontmo                             || ';' ||
				   cur_enr.bpmontmo1				|| ';' ||
				   cur_enr.libdp 				|| ';' ||
				   cur_enr.libproj 				|| ';' ||
				   cur_enr.libappli 				);
       END LOOP;


       Pack_Global.CLOSE_WRITE_FILE(l_hfile);


	EXCEPTION
   		WHEN OTHERS THEN


   		Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
   		RAISE_APPLICATION_ERROR(-20401, l_msg);

    END select_oscar_lignebip;

    PROCEDURE lance_oscar_lignebip (
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2) IS

	l_msg  VARCHAR2(1024);
	BEGIN

		Pack_Oscar_Lignebip.alim_oscar('7'); -- Exclut les lignes de type 7
		Pack_Oscar_Lignebip.select_oscar_lignebip(p_chemin_fichier,p_nom_fichier);

	EXCEPTION
   		WHEN OTHERS THEN

   		Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
   		RAISE_APPLICATION_ERROR(-20401, l_msg);

	END lance_oscar_lignebip;


	PROCEDURE oscar_ressource(
			p_chemin_fichier	IN VARCHAR2,
			p_nom_fichier		IN VARCHAR2
	) IS
		CURSOR csr_ressource IS
			SELECT TO_CHAR(RESSOURCE.ident)			ident
				, RESSOURCE.matricule			matricule
				, RESSOURCE.rnom			rnom
				, RESSOURCE.rprenom			rprenom
				, TO_CHAR(STRUCT_INFO.centractiv)	centractiv
				, RESSOURCE.rtype			rtype
			FROM STRUCT_INFO
				, SITU_RESS_FULL
				, RESSOURCE
			WHERE SITU_RESS_FULL.ident=RESSOURCE.ident
			AND SITU_RESS_FULL.codsg=STRUCT_INFO.codsg
			AND (SITU_RESS_FULL.datsitu<=SYSDATE OR SITU_RESS_FULL.datsitu IS NULL)
			AND (SITU_RESS_FULL.datdep>=SYSDATE OR SITU_RESS_FULL.datdep IS NULL)
			AND RESSOURCE.rtype='P';

		l_msg  VARCHAR2(1024);
		l_hfile UTL_FILE.FILE_TYPE;
	BEGIN
		Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);

		FOR rec_ressource IN csr_ressource LOOP
			Pack_Global.WRITE_STRING( l_hfile,
				rec_ressource.ident || ';' ||
				rec_ressource.matricule || ';' ||
				rec_ressource.rnom || ';' ||
				rec_ressource.rprenom || ';' ||
				rec_ressource.centractiv || ';' ||
				rec_ressource.rtype);
		END LOOP;
		Pack_Global.CLOSE_WRITE_FILE(l_hfile);
	EXCEPTION
   		WHEN OTHERS THEN
			Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
			RAISE_APPLICATION_ERROR(-20401, l_msg);
	END oscar_ressource;

-- extraction pour l'appli PMA
PROCEDURE select_bip_pma (
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2) IS


       l_hfile UTL_FILE.FILE_TYPE;
       l_datdebex NUMBER(4);
       l_msg  VARCHAR2(1024);

-- déclaration du curseur
	CURSOR curs_pma IS
	SELECT RPAD(NVL(o.pid,' '),4,' ') pid,
        LPAD(TO_CHAR(o.DATDEBEX,'YYYY'),4,' ') DATDEBEX,
        RPAD(NVL(REPLACE(o.pnom,'"',' '),' '),30,' ') pnom,
        RPAD(NVL(o.typproj,' '),1,' ') typproj,
        RPAD(TO_CHAR(NVL(o.dpcode,0)),5,' ') dpcode,
        LPAD(TO_CHAR(NVL(o.bpmontme,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontme,
        LPAD(TO_CHAR(NVL(o.bpmontme1,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontme1,
        LPAD(TO_CHAR(NVL(o.bpmontme2,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontme2,
        LPAD(TO_CHAR(NVL(o.bpmontme3,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontme3,
	LPAD(TO_CHAR(NVL(o.bnmont,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bnmont,
	LPAD(TO_CHAR(NVL(o.reserve,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') reserve,
	LPAD(TO_CHAR(NVL(o.anmont,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') anmont,
	LPAD(TO_CHAR(NVL(o.xcusmois,'0'), 'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') xcusmois,
	LPAD(TO_CHAR(NVL(o.cusag,'0'), 'FM999990D00','NLS_NUMERIC_CHARACTERS='',.'),8,' ') cusag,
	LPAD(TO_CHAR(NVL(o.xcusag,'0'), 'FM999990D00','NLS_NUMERIC_CHARACTERS='',.'),8,' ') xcusag,
	LPAD(TO_CHAR(NVL(o.reestime,'0'),'FM999990D00','NLS_NUMERIC_CHARACTERS='',.'),8,' ') reestime,
	RPAD(o.sigdeppole,7,' ') sigdeppole,
	RPAD(NVL(o.clisigle,' '),8,' ') clisigle,
	RPAD(TO_CHAR(NVL(o.codcamo,0)),5,' ') codcamo,
	RPAD(NVL(o.codpspe,' '),1,' ') codpspe,
	RPAD(NVL(o.icpi,' '),5,' ') icpi,
	LPAD(TO_CHAR(NVL(o.factint,'0'),'FM999990D00','NLS_NUMERIC_CHARACTERS='',.'),8,' ') factint,
	RPAD(NVL(o.airt,' '),5,' ') airt,
	RPAD(NVL(o.arctype,' '),2,' ') arctype,
	RPAD(NVL(REPLACE(o.rnom,'"',' '),' '),30,' ') rnom,
	RPAD(NVL(REPLACE(o.pnmouvra,'"',' '),' '),15,' ') pnmouvra,
	RPAD(NVL(o.METIER,' '),3,' ') METIER,
	RPAD(NVL(o.topfer,' '),1,' ') topfer,
	RPAD(NVL(o.cle_bip,' '),3,' ') cle_bip,
	LPAD(TO_CHAR(NVL(o.bpmontmo,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontmo,
	LPAD(TO_CHAR(NVL(o.bpmontmo1,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontmo1,
	RPAD(NVL(o.dplib,' '),35,' ') libdp,
	RPAD(NVL(o.ilibel,' '),50,' ') libproj,
	RPAD(NVL(o.alibel,' '),50,' ') libappli,
	RPAD(NVL(TO_CHAR(l.codsg),' '),7,' ') codsg,
	RPAD(NVL(s.libdsg,' '),30,' ') libdsg
FROM    TMP_OSCAR o, STRUCT_INFO s, LIGNE_BIP l
WHERE   o.pid = l.pid
AND     l.codsg = s.codsg
ORDER BY RPAD(NVL(o.pid,' '),4,' ');


   BEGIN


      SELECT TO_NUMBER(TO_CHAR(DATDEBEX,'YYYY')) INTO l_datdebex FROM DATDEBEX;


      Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);


    FOR cur_enr IN curs_pma
      LOOP
        Pack_Global.WRITE_STRING( l_hfile,
                                   '"' ||cur_enr.pid 				|| '";' ||
                                   cur_enr.DATDEBEX				|| ';"' ||
                                   cur_enr.pnom 				|| '";"' ||
                                   cur_enr.typproj			 	|| '";"' ||
                                   cur_enr.dpcode 				|| '";' ||
                                   cur_enr.bpmontme 				|| ';' ||
                                   cur_enr.bpmontme1 				|| ';' ||
                                   cur_enr.bpmontme2				|| ';' ||
                                   cur_enr.bpmontme3 				|| ';' ||
				   cur_enr.bnmont 				|| ';' ||
                                   LPAD(TO_CHAR(0,'FM0D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') 	|| ';' ||
				   cur_enr.anmont 				|| ';' ||
                                   cur_enr.xcusmois 				|| ';' ||
				   cur_enr.cusag 				|| ';' ||
                                   cur_enr.xcusag 				|| ';' ||
                                   cur_enr.reestime 				|| ';"' ||
                                   cur_enr.sigdeppole 				|| '";"' ||
                                   cur_enr.clisigle 				|| '";"' ||
                                   cur_enr.codcamo 				|| '";"' ||
				   cur_enr.codpspe 				|| '";"' ||
				   cur_enr.icpi 				|| '";' ||
				   cur_enr.factint				|| ';"' ||
                                   cur_enr.airt 				|| '";"' ||
                                   cur_enr.arctype	 			|| '";"' ||
                                   cur_enr.rnom 				|| '";"' ||
                                   cur_enr.pnmouvra 				|| '";"' ||
				   cur_enr.METIER				|| '";"' ||
				   cur_enr.topfer				|| '";"' ||
				   cur_enr.cle_bip				|| '";' ||
				   cur_enr.bpmontmo                             || ';' ||
				   cur_enr.bpmontmo1				|| ';' ||
				   cur_enr.libdp 				|| ';' ||
				   cur_enr.libproj 				|| ';' ||
				   cur_enr.libappli 				|| ';' ||
				   cur_enr.codsg 				|| ';' ||
				   cur_enr.libdsg 				);
       END LOOP;


       Pack_Global.CLOSE_WRITE_FILE(l_hfile);


	EXCEPTION
   		WHEN OTHERS THEN


   		Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
   		RAISE_APPLICATION_ERROR(-20401, l_msg);

END select_bip_pma;

--
-- extraction pour l'appli METRIQUE
--
PROCEDURE select_bip_metrique (
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2) IS

       l_hfile UTL_FILE.FILE_TYPE;
       l_datdebex NUMBER(4);
       l_msg  VARCHAR2(1024);

-- déclaration du curseur
CURSOR curs_metrique IS
SELECT
	RPAD(NVL(o.pid,' '),4,' ') pid,
	LPAD(TO_CHAR(o.DATDEBEX,'YYYY'),4,' ') DATDEBEX,
	RPAD(NVL(REPLACE(o.pnom,'"',' '),' '),30,' ') pnom,
	RPAD(NVL(o.typproj,' '),1,' ') typproj,
	RPAD(TO_CHAR(NVL(o.dpcode,0)),5,' ') dpcode,
	LPAD(TO_CHAR(NVL(o.bpmontme,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontme,
	LPAD(TO_CHAR(NVL(o.bpmontme1,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontme1,
	LPAD(TO_CHAR(NVL(o.bpmontme2,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontme2,
	LPAD(TO_CHAR(NVL(o.bpmontme3,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontme3,
	LPAD(TO_CHAR(NVL(o.bnmont,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bnmont,
	LPAD(TO_CHAR(NVL(o.reserve,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') reserve,
	LPAD(TO_CHAR(NVL(o.anmont,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') anmont,
	LPAD(TO_CHAR(NVL(o.xcusmois,'0'), 'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') xcusmois,
	LPAD(TO_CHAR(NVL(o.cusag,'0'), 'FM999990D00','NLS_NUMERIC_CHARACTERS='',.'),8,' ') cusag,
	LPAD(TO_CHAR(NVL(o.xcusag,'0'), 'FM999990D00','NLS_NUMERIC_CHARACTERS='',.'),8,' ') xcusag,
	LPAD(TO_CHAR(NVL(o.reestime,'0'),'FM999990D00','NLS_NUMERIC_CHARACTERS='',.'),8,' ') reestime,
	RPAD(o.sigdeppole,7,' ') sigdeppole,
	RPAD(NVL(o.clisigle,' '),8,' ') clisigle,
	RPAD(TO_CHAR(NVL(o.codcamo,0)),5,' ') codcamo,
	RPAD(NVL(o.codpspe,' '),1,' ') codpspe,
	RPAD(NVL(o.icpi,' '),5,' ') icpi,
	LPAD(TO_CHAR(NVL(o.factint,'0'),'FM999990D00','NLS_NUMERIC_CHARACTERS='',.'),8,' ') factint,
	RPAD(NVL(o.airt,' '),5,' ') airt,
	RPAD(NVL(o.arctype,' '),2,' ') arctype,
	RPAD(NVL(REPLACE(o.rnom,'"',' '),' '),30,' ') rnom,
	RPAD(NVL(REPLACE(o.pnmouvra,'"',' '),' '),15,' ') pnmouvra,
	RPAD(NVL(o.METIER,' '),3,' ') METIER,
	RPAD(NVL(o.topfer,' '),1,' ') topfer,
	RPAD(NVL(o.cle_bip,' '),3,' ') cle_bip,
	LPAD(TO_CHAR(NVL(o.bpmontmo,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontmo,
	LPAD(TO_CHAR(NVL(o.bpmontmo1,'0'),'FM99990D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') bpmontmo1,
	RPAD(NVL(o.dplib,' '),35,' ') libdp,
	RPAD(NVL(o.ilibel,' '),50,' ') libproj,
	RPAD(NVL(o.alibel,' '),50,' ') libappli,
	RPAD(NVL(TO_CHAR(l.codsg),' '),7,' ') codsg,
	RPAD(NVL(s.libdsg,' '),30,' ') libdsg
	,RPAD(NVL(l.sous_type,' '),3,' ') soustype
	,LPAD(TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM'),6,' ') datearrete
	,LPAD(TO_CHAR(l.adatestatut,'DD/MM/YYYY'),10,' ') adatestatut
FROM    TMP_OSCAR o, STRUCT_INFO s, LIGNE_BIP l
WHERE   o.pid = l.pid AND l.codsg = s.codsg
ORDER BY RPAD(NVL(o.pid,' '),4,' ');

BEGIN

	-- Regenere la table TMP_OSCAR
	Pack_Oscar_Lignebip.alim_oscar('7'); -- Exclut les lignes de type 7

	SELECT TO_NUMBER(TO_CHAR(DATDEBEX,'YYYY')) INTO l_datdebex FROM DATDEBEX;
	Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);

    FOR cur_enr IN curs_metrique
      LOOP
        Pack_Global.WRITE_STRING( l_hfile,
	'"' ||cur_enr.pid 			|| '";' ||
	cur_enr.DATDEBEX			|| ';"' ||
	cur_enr.pnom 				|| '";"' ||
	cur_enr.typproj			 	|| '";"' ||
	cur_enr.dpcode 				|| '";' ||
	cur_enr.bpmontme 			|| ';' ||
	cur_enr.bpmontme1 			|| ';' ||
	cur_enr.bpmontme2			|| ';' ||
	cur_enr.bpmontme3 			|| ';' ||
	cur_enr.bnmont 				|| ';' ||
	LPAD(TO_CHAR(0,'FM0D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') 	|| ';' ||
	cur_enr.anmont 				|| ';' ||
	cur_enr.xcusmois 			|| ';' ||
	cur_enr.cusag 				|| ';' ||
	cur_enr.xcusag 				|| ';' ||
	cur_enr.reestime 			|| ';"' ||
	cur_enr.sigdeppole 			|| '";"' ||
	cur_enr.clisigle 			|| '";"' ||
	cur_enr.codcamo 			|| '";"' ||
	cur_enr.codpspe 			|| '";"' ||
	cur_enr.icpi 				|| '";' ||
	cur_enr.factint				|| ';"' ||
	cur_enr.airt 				|| '";"' ||
	cur_enr.arctype	 			|| '";"' ||
	cur_enr.rnom 				|| '";"' ||
	cur_enr.pnmouvra 			|| '";"' ||
	cur_enr.METIER				|| '";"' ||
	cur_enr.topfer				|| '";"' ||
	cur_enr.cle_bip				|| '";' ||
	cur_enr.bpmontmo                        || ';' ||
	cur_enr.bpmontmo1			|| ';' ||
	cur_enr.libdp 				|| ';' ||
	cur_enr.libproj 			|| ';' ||
	cur_enr.libappli 			|| ';' ||
	cur_enr.codsg 				|| ';' ||
	cur_enr.libdsg 				|| ';' ||
	cur_enr.soustype			|| ';' ||
	cur_enr.datearrete			|| ';' ||
	cur_enr.adatestatut			);
      END LOOP;

	Pack_Global.CLOSE_WRITE_FILE(l_hfile);

	EXCEPTION
   		WHEN OTHERS THEN
   		Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
   		RAISE_APPLICATION_ERROR(-20401, l_msg);

END select_bip_metrique;
-- ======================================================================
-- Extractions pour l application DIVA.
-- ======================================================================
PROCEDURE diva_ressources(
                        p_chemin_fichier        IN VARCHAR2,
                        p_nom_fichier           IN VARCHAR2
        ) IS
                CURSOR csr_ressource IS
                        SELECT TO_CHAR(RESSOURCE.ident)                 ident
                                , RESSOURCE.rnom                        rnom
                                , RESSOURCE.rprenom                     rprenom
                                , RESSOURCE.matricule                   matricule
                                , TO_CHAR(STRUCT_INFO.centractiv)       centractiv
                                , DECODE(RESSOURCE.rtype,
				 'P',DECODE(SITU_RESS_FULL.soccode,'SG..','A','P'),
				 'E','F',
                                 RESSOURCE.rtype )  rtype
                                , SITU_RESS_FULL.codsg      codsg
                                , SITU_RESS_FULL.cpident    cpident
                        FROM STRUCT_INFO
                                , SITU_RESS_FULL
                                , RESSOURCE
                        WHERE SITU_RESS_FULL.ident=RESSOURCE.ident
                        AND SITU_RESS_FULL.codsg=STRUCT_INFO.codsg
                        AND STRUCT_INFO.TOPFER = 'O' -- DPG ACTIF.
                        AND STRUCT_INFO.top_diva_int = 'O' -- DPG pour DIVA.
                        AND (SITU_RESS_FULL.datsitu<=to_date(SYSDATE,'DD/MM/RRRR') OR SITU_RESS_FULL.datsitu IS NULL)
                        AND (SITU_RESS_FULL.datdep>=to_date(SYSDATE,'DD/MM/RRRR') OR SITU_RESS_FULL.datdep IS NULL)
                        AND RESSOURCE.rtype IN ('P','F','E','L')
                        AND SITU_RESS_FULL.type_situ = 'N' -- Presence dans situ_ress Sitation Normale.
                        ORDER BY SITU_RESS_FULL.cpident
                        ;

                l_msg  VARCHAR2(1024);
                l_hfile UTL_FILE.FILE_TYPE;
        BEGIN
                Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);

                FOR rec_ressource IN csr_ressource LOOP
                        Pack_Global.WRITE_STRING( l_hfile,
                                rec_ressource.ident || ';' ||
                                rec_ressource.rnom || ';' ||
                                rec_ressource.rprenom || ';' ||
                                rec_ressource.matricule || ';' ||
                                rec_ressource.centractiv || ';' ||
                                rec_ressource.rtype || ';' ||
                                rec_ressource.codsg || ';' ||
                                rec_ressource.cpident
                                );
                END LOOP;
                Pack_Global.CLOSE_WRITE_FILE(l_hfile);
        EXCEPTION
                WHEN OTHERS THEN
                        Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
                        RAISE_APPLICATION_ERROR(-20401, l_msg);
END diva_ressources;

-- ======================================================================
PROCEDURE diva_lignes_notifie (
                       p_chemin_fichier IN VARCHAR2,
                       p_nom_fichier    IN VARCHAR2) IS

       l_hfile UTL_FILE.FILE_TYPE;
       l_datdebex NUMBER(4);
       l_msg  VARCHAR2(1024);
       l_calanmois VARCHAR2(2);
       l_sysdate DATE;
       l_ccloture  DATE;

-- déclaration du curseur
CURSOR curs_ligne IS
SELECT
	RPAD(NVL(o.pid,' '),4,' ') pid,
	LPAD(TO_CHAR(o.DATDEBEX,'YYYY'),4,' ') DATDEBEX,
	RPAD(NVL(REPLACE(o.pnom,'"',' '),' '),30,' ') pnom,
	RPAD(NVL(o.typproj,' '),1,' ') typproj,
	RPAD(TO_CHAR(NVL(o.dpcode,0)),5,' ') dpcode,
	LPAD(TO_CHAR(NVL(o.bpmontme,'0'),'FM99999990D00','NLS_NUMERIC_CHARACTERS='',.,'),12,' ') bpmontme,
	LPAD(TO_CHAR(NVL(o.bpmontme1,'0'),'FM99999990D00','NLS_NUMERIC_CHARACTERS='',.,'),12,' ') bpmontme1,
	LPAD(TO_CHAR(NVL(o.bpmontme2,'0'),'FM99999990D00','NLS_NUMERIC_CHARACTERS='',.,'),12,' ') bpmontme2,
	LPAD(TO_CHAR(NVL(o.bpmontme3,'0'),'FM99999990D00','NLS_NUMERIC_CHARACTERS='',.,'),12,' ') bpmontme3,
	LPAD(TO_CHAR(NVL(o.bnmont,'0'),'FM99999990D00','NLS_NUMERIC_CHARACTERS='',.,'),12,' ') bnmont,
	LPAD(TO_CHAR(NVL(o.reserve,'0'),'FM99999990D00','NLS_NUMERIC_CHARACTERS='',.,'),12,' ') reserve,
	LPAD(TO_CHAR(NVL(o.anmont,'0'),'FM99999990D00','NLS_NUMERIC_CHARACTERS='',.,'),12,' ') anmont,
	LPAD(TO_CHAR(NVL(o.xcusmois,'0'), 'FM99999990D00','NLS_NUMERIC_CHARACTERS='',.,'),12,' ') xcusmois,
	LPAD(TO_CHAR(NVL(o.cusag,'0'), 'FM99999990D00','NLS_NUMERIC_CHARACTERS='',.'),12,' ') cusag,
	LPAD(TO_CHAR(NVL(o.xcusag,'0'), 'FM99999990D00','NLS_NUMERIC_CHARACTERS='',.'),12,' ') xcusag,
	LPAD(TO_CHAR(NVL(o.reestime,'0'),'FM99999990D00','NLS_NUMERIC_CHARACTERS='',.'),12,' ') reestime,
	RPAD(o.sigdeppole,7,' ') sigdeppole,
	RPAD(NVL(o.clisigle,' '),8,' ') clisigle,
	RPAD(TO_CHAR(NVL(o.codcamo,0)),5,' ') codcamo,
	RPAD(NVL(o.codpspe,' '),1,' ') codpspe,
	RPAD(NVL(o.icpi,' '),5,' ') icpi,
	LPAD(TO_CHAR(NVL(o.factint,'0'),'FM99999990D00','NLS_NUMERIC_CHARACTERS='',.'),12,' ') factint,
	RPAD(NVL(o.airt,' '),5,' ') airt,
	RPAD(NVL(o.arctype,' '),2,' ') arctype,
	RPAD(NVL(REPLACE(o.rnom,'"',' '),' '),30,' ') rnom,
	RPAD(NVL(REPLACE(o.pnmouvra,'"',' '),' '),15,' ') pnmouvra,
	RPAD(NVL(o.METIER,' '),3,' ') METIER,
	RPAD(NVL(o.topfer,' '),1,' ') topfer,
	RPAD(NVL(o.cle_bip,' '),3,' ') cle_bip,
	LPAD(TO_CHAR(NVL(o.bpmontmo,'0'),'FM99999990D00','NLS_NUMERIC_CHARACTERS='',.,'),12,' ') bpmontmo,
	LPAD(TO_CHAR(NVL(o.bpmontmo1,'0'),'FM99999990D00','NLS_NUMERIC_CHARACTERS='',.,'),12,' ') bpmontmo1,
	RPAD(NVL(o.dplib,' '),35,' ') libdp,
	RPAD(NVL(o.ilibel,' '),50,' ') libproj,
	RPAD(NVL(o.alibel,' '),50,' ') libappli,
	RPAD(NVL(TO_CHAR(l.codsg),' '),7,' ') codsg,
	RPAD(NVL(s.libdsg,' '),30,' ') libdsg
	,RPAD(NVL(l.sous_type,' '),3,' ') soustype
	,LPAD(TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM'),6,' ') datearrete
	,LPAD(TO_CHAR(l.adatestatut,'DD/MM/YYYY'),10,' ') adatestatut
FROM    TMP_OSCAR o, STRUCT_INFO s, LIGNE_BIP l, CLIENT_MO cmo, DATDEBEX dax
WHERE       o.pid = l.pid
	AND l.codsg = s.codsg
	AND s.TOPFER = 'O'    -- DPG Actif
	AND l.clicode = cmo.clicode
	AND cmo.CLITOPF = 'O'  -- CLIENT MO Actif
	AND	(
			( -- Ligne de type 7 - Fournisseur DIVA
			     l.typproj = '7 '
			 AND s.top_diva = 'O'
			)
		 OR -- Lignes de type 1,2,3,4,5,6 et 8 - Le fournisseur ou le client doit être toppé DIVA
			(
			    l.typproj != '7'
			AND (    (s.top_diva = 'O' AND ( cmo.TOP_DIVA = 'O' OR cmo.TOP_DIVA = 'N' OR cmo.TOP_DIVA = 'Y') )
			 	  OR (s.top_diva = 'N' AND cmo.TOP_DIVA = 'O')
				  OR (s.top_diva = 'X' AND cmo.TOP_DIVA = 'O')
				)
			)
		)
		AND ((l.adatestatut IS NULL) OR (TO_CHAR(l.adatestatut,'YYYY') = TO_CHAR(dax.DATDEBEX,'YYYY')) )
ORDER BY RPAD(NVL(o.pid,' '),4,' ');

BEGIN

	-- Regenere la table TMP_OSCAR
	Pack_Oscar_Lignebip.alim_oscar('0'); -- Passe 0 à la fonction, donc n'exclut pas les lignes de type 7

	SELECT TO_NUMBER(TO_CHAR(DATDEBEX,'YYYY')) INTO l_datdebex FROM DATDEBEX;
	Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);

    --l_sysdate:='14/01/2009';

    SELECT TO_CHAR(CALANMOIS,'mm'), TO_DATE(CCLOTURE) INTO l_calanmois, l_ccloture FROM CALENDRIER WHERE TO_CHAR(CALANMOIS,'mm/yyyy')=TO_CHAR(sysdate,'mm/yyyy');
    --SELECT TO_CHAR(CALANMOIS,'mm'), TO_DATE(CCLOTURE) INTO l_calanmois, l_ccloture FROM CALENDRIER WHERE TO_CHAR(CALANMOIS,'mm/yyyy')=TO_CHAR(l_sysdate,'mm/yyyy');

    IF l_calanmois='01' AND TO_DATE(sysdate-2,'dd/mm/yyyy')< TO_DATE(l_ccloture,'dd/mm/yyyy') THEN
    --IF l_calanmois='01' AND TO_DATE(l_sysdate-2,'dd/mm/yyyy')< TO_DATE(l_ccloture,'dd/mm/yyyy') THEN

    FOR cur_enr IN curs_ligne
      LOOP
        Pack_Global.WRITE_STRING( l_hfile,
	'"' ||cur_enr.pid 			|| '";' ||
	TO_CHAR(l_ccloture,'yyyy')	|| ';"' ||
	cur_enr.pnom 				|| '";"' ||
	cur_enr.typproj			 	|| '";"' ||
	cur_enr.dpcode 				|| '";' ||
	cur_enr.bpmontme 			|| ';' ||
	cur_enr.bpmontme1 			|| ';' ||
	cur_enr.bpmontme2			|| ';' ||
	cur_enr.bpmontme3 			|| ';' ||
	'0'	|| ';' ||
	LPAD(TO_CHAR(0,'FM0D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') 	|| ';' ||
	'0' 	|| ';' ||
	cur_enr.xcusmois 			|| ';' ||
	cur_enr.cusag 				|| ';' ||
	cur_enr.xcusag 				|| ';' ||
	cur_enr.reestime 			|| ';"' ||
	cur_enr.sigdeppole 			|| '";"' ||
	cur_enr.clisigle 			|| '";"' ||
	cur_enr.codcamo 			|| '";"' ||
	cur_enr.codpspe 			|| '";"' ||
	cur_enr.icpi 				|| '";' ||
	cur_enr.factint				|| ';"' ||
	cur_enr.airt 				|| '";"' ||
	cur_enr.arctype	 			|| '";"' ||
	cur_enr.rnom 				|| '";"' ||
	cur_enr.pnmouvra 			|| '";"' ||
	cur_enr.METIER				|| '";"' ||
	cur_enr.topfer				|| '";"' ||
	cur_enr.cle_bip				|| '";' ||
	cur_enr.bpmontmo            || ';' ||
	cur_enr.bpmontmo1			|| ';' ||
	cur_enr.libdp 				|| ';' ||
	cur_enr.libproj 			|| ';' ||
	cur_enr.libappli 			|| ';' ||
	cur_enr.codsg 				|| ';' ||
	cur_enr.libdsg 				|| ';' ||
	cur_enr.soustype			|| ';' ||
	cur_enr.datearrete			|| ';' ||
	cur_enr.adatestatut			);
      END LOOP;

    ELSE

    FOR cur_enr IN curs_ligne
      LOOP
        Pack_Global.WRITE_STRING( l_hfile,
	'"' ||cur_enr.pid 			|| '";' ||
	cur_enr.DATDEBEX			|| ';"' ||
	cur_enr.pnom 				|| '";"' ||
	cur_enr.typproj			 	|| '";"' ||
	cur_enr.dpcode 				|| '";' ||
	cur_enr.bpmontme 			|| ';' ||
	cur_enr.bpmontme1 			|| ';' ||
	cur_enr.bpmontme2			|| ';' ||
	cur_enr.bpmontme3 			|| ';' ||
	cur_enr.bnmont 				|| ';' ||
	LPAD(TO_CHAR(0,'FM0D00','NLS_NUMERIC_CHARACTERS='',.,'),8,' ') 	|| ';' ||
	cur_enr.anmont 				|| ';' ||
	cur_enr.xcusmois 			|| ';' ||
	cur_enr.cusag 				|| ';' ||
	cur_enr.xcusag 				|| ';' ||
	cur_enr.reestime 			|| ';"' ||
	cur_enr.sigdeppole 			|| '";"' ||
	cur_enr.clisigle 			|| '";"' ||
	cur_enr.codcamo 			|| '";"' ||
	cur_enr.codpspe 			|| '";"' ||
	cur_enr.icpi 				|| '";' ||
	cur_enr.factint				|| ';"' ||
	cur_enr.airt 				|| '";"' ||
	cur_enr.arctype	 			|| '";"' ||
	cur_enr.rnom 				|| '";"' ||
	cur_enr.pnmouvra 			|| '";"' ||
	cur_enr.METIER				|| '";"' ||
	cur_enr.topfer				|| '";"' ||
	cur_enr.cle_bip				|| '";' ||
	cur_enr.bpmontmo            || ';' ||
	cur_enr.bpmontmo1			|| ';' ||
	cur_enr.libdp 				|| ';' ||
	cur_enr.libproj 			|| ';' ||
	cur_enr.libappli 			|| ';' ||
	cur_enr.codsg 				|| ';' ||
	cur_enr.libdsg 				|| ';' ||
	cur_enr.soustype			|| ';' ||
	cur_enr.datearrete			|| ';' ||
	cur_enr.adatestatut			);
      END LOOP;

    END IF;

	Pack_Global.CLOSE_WRITE_FILE(l_hfile);

	EXCEPTION
   		WHEN OTHERS THEN
   		Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
   		RAISE_APPLICATION_ERROR(-20401, l_msg);

END diva_lignes_notifie;
END Pack_Oscar_Lignebip;
/
