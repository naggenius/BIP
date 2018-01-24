--Package qui sert à alimenter les tables ISAC à partir des tables PMW
-- Modifié le 16/12/2002 par NBM :	- création procedure pec_isac (mise en place de l'interface de prise en charge)
--					 	- pmw_to_isac( p_cpident IN NUMBER)
--						- f_verif_cp : teste l'existence cu CP
-- Modifié le 08/03/2004 par PJO : MAJ PID sur 4 caractères
-- Modifie le 14/01/2005 par PPR : traitement spécifique du mois de janvier ou il n'y a
--					pas de consommé
--
CREATE OR REPLACE PACKAGE pack_pmw_to_isac IS
	PROCEDURE transfert(p_pid IN isac_etape.pid%TYPE);

	PROCEDURE purge(p_pid IN isac_etape.pid%TYPE);
	PROCEDURE purge_cp(p_cpident IN NUMBER);

	PROCEDURE pmw_to_isac(p_chemin_fichier  IN VARCHAR2, p_cpident IN NUMBER);
	PROCEDURE pmw_to_isac(p_cpident IN NUMBER);

	PROCEDURE f_verif_cp(	p_cp IN VARCHAR2,
					p_message   OUT VARCHAR2);

	PROCEDURE pec_isac(	p_cp1 IN VARCHAR2,
				p_cp2 IN VARCHAR2,
				p_cp3 IN VARCHAR2,
				p_cp4 IN VARCHAR2,
				p_cp5 IN VARCHAR2,
 				p_global    IN VARCHAR2,
                       		p_nbcurseur OUT INTEGER,
                       		p_message   OUT VARCHAR2
				);
END pack_pmw_to_isac;
/



create or replace PACKAGE BODY pack_pmw_to_isac IS
-- Déclaration du curseur : liste des pid du chef de projet
CURSOR CUR_PID(p_cpident IN NUMBER)  IS
 		select pid
		from ligne_bip
		where pcpi=p_cpident;

-- ***************************************************************
-- PROCEDURE transfert
-- permet d'alimenter les tables ISAC
-- ***************************************************************
	PROCEDURE transfert(p_pid IN isac_etape.pid%TYPE) IS
		l_nb	INTEGER;
	BEGIN
		INSERT INTO isac_etape(pid, etape, ecet, libetape, typetape, flaglock)
			SELECT pid
				, seq_etape.nextval
				, ecet
				, pid || ' / ' || ecet
				, typetap
				, 0
			FROM etape
			WHERE typetap IS NOT NULL
				AND pid=p_pid;

	commit;

		INSERT INTO isac_tache(pid, etape, tache, acta, libtache, flaglock)
			SELECT
				les_taches.pid
				, les_taches.etape
				, seq_tache.nextval
				, les_taches.acta
				, les_taches.libetape
				, 0
			FROM
				(SELECT DISTINCT
					tache.pid
					, isac_etape.etape
					, tache.acta
					, isac_etape.libetape || '/' || tache.acta libetape
				FROM isac_etape, tache
				WHERE isac_etape.pid=tache.pid
					AND isac_etape.ecet=tache.ecet
				) les_taches
			WHERE les_taches.pid=p_pid;

	commit;

		INSERT INTO isac_sous_tache(pid, etape, tache, sous_tache, acst, asnom
									, aist, asta, adeb, afin, ande, anfi, adur, flaglock)
			SELECT tache.pid
				, isac_tache.etape
				, isac_tache.tache
				, seq_sous_tache.nextval
				, tache.acst
				, NVL(tache.asnom, 'nom vide')
				, tache.aist
				, asta
				, tache.adeb
				, tache.afin
				, tache.ande
				, tache.anfi
				, tache.adur
				, 0
			FROM isac_etape, isac_tache, tache
			WHERE tache.pid=isac_etape.pid
				AND tache.ecet=isac_etape.ecet
				AND tache.acta=isac_tache.acta
				AND isac_etape.etape=isac_tache.etape
				AND isac_etape.pid=p_pid;
	commit;

--Test s'il y a du consommé pour la ligne
BEGIN
	l_nb := 0 ;

	 select count(1) into l_nb
	 from cons_sstache_res_mois
	 where  pid= p_pid;

	 IF l_nb = 0 THEN
	 	--
	 	-- Si on n'a pas trouvé de consommé, on va chercher dans la table
	 	-- cons_sstache_res_mois_back afin de ramener des ressources qui ont
	 	-- consommé l'année précédente
	 	-- Cas d'un rattachement à ISAC qui intervient au cours du mois de
	 	-- Janvier alors que la table cons_sstache_res_mois est vide
	 	--
	 	INSERT INTO isac_affectation(pid, etape, tache, sous_tache, ident)
			SELECT DISTINCT isac_etape.pid
				, isac_etape.etape
				, isac_tache.tache
				, isac_sous_tache.sous_tache
				, cons_sstache_res_mois_back.ident
			FROM 	isac_etape
				, isac_tache
				, isac_sous_tache
				, cons_sstache_res_mois_back
			WHERE isac_etape.etape=isac_tache.etape
				AND isac_tache.tache=isac_sous_tache.tache
				AND cons_sstache_res_mois_back.pid=isac_etape.pid
				AND cons_sstache_res_mois_back.ecet=isac_etape.ecet
				AND cons_sstache_res_mois_back.acta=isac_tache.acta
				AND cons_sstache_res_mois_back.acst=isac_sous_tache.acst
				AND isac_etape.PID=p_pid;

		commit;
	 ELSE

		INSERT INTO isac_affectation(pid, etape, tache, sous_tache, ident)
			SELECT DISTINCT isac_etape.pid
				, isac_etape.etape
				, isac_tache.tache
				, isac_sous_tache.sous_tache
				, cons_sstache_res_mois.ident
			FROM 	datdebex
				, isac_etape
				, isac_tache
				, isac_sous_tache
				, cons_sstache_res_mois
			WHERE isac_etape.etape=isac_tache.etape
				AND isac_tache.tache=isac_sous_tache.tache
				AND cons_sstache_res_mois.pid=isac_etape.pid
				AND cons_sstache_res_mois.ecet=isac_etape.ecet
				AND cons_sstache_res_mois.acta=isac_tache.acta
				AND cons_sstache_res_mois.acst=isac_sous_tache.acst
				--AND cdeb>=TO_DATE('01/01/2002', 'dd/mm/yyyy')
				AND cdeb>=datdebex.datdebex
				AND isac_etape.PID=p_pid;

		commit;


		INSERT INTO isac_consomme(ident, pid, etape, tache, sous_tache, cdeb, cusag)
			SELECT cons_sstache_res_mois.ident
				, isac_etape.pid
				, isac_etape.etape
				, isac_tache.tache
				, isac_sous_tache.sous_tache
				, cons_sstache_res_mois.cdeb
				, cons_sstache_res_mois.cusag
			FROM datdebex
				, isac_etape
				, isac_tache
				, isac_sous_tache
				, cons_sstache_res_mois
			WHERE isac_etape.etape=isac_tache.etape
				AND isac_tache.tache=isac_sous_tache.tache
				AND cons_sstache_res_mois.pid=isac_etape.pid
				AND cons_sstache_res_mois.ecet=isac_etape.ecet
				AND cons_sstache_res_mois.acta=isac_tache.acta
				AND cons_sstache_res_mois.acst=isac_sous_tache.acst
				AND cdeb>=datdebex.datdebex
				AND isac_etape.PID=p_pid;

		COMMIT;
		END IF;
END;
	END transfert;

-- ***************************************************************
-- PROCEDURE purge
-- permet de supprimer les lignes reliées à un PID
-- ***************************************************************
PROCEDURE purge(p_pid IN isac_etape.pid%TYPE) IS
	BEGIN
		DELETE isac_consomme WHERE pid=p_pid;
		DELETE isac_affectation WHERE pid=p_pid;
		DELETE isac_sous_tache WHERE pid=p_pid;
		DELETE isac_tache WHERE pid=p_pid;
		DELETE isac_etape WHERE pid=p_pid;
		COMMIT;
	END purge;

-- ***************************************************************
-- PROCEDURE purge_cp
-- permet de supprimer les lignes reliées à un chef de projet
-- ***************************************************************
PROCEDURE purge_cp(p_cpident IN NUMBER) IS
	BEGIN
		FOR curseur IN CUR_PID(p_cpident) LOOP
			purge(curseur.pid);
		END LOOP;

	END purge_cp;

-- ***************************************************************
-- PROCEDURE pmw_to_isac
-- permet de lancer le traitement d'alimentation des tables ISAC
-- ***************************************************************
PROCEDURE pmw_to_isac(p_chemin_fichier  IN VARCHAR2, p_cpident IN NUMBER) IS
	l_nb	INTEGER;
	l_hfile     utl_file.file_type;


	BEGIN
		 PACK_GLOBAL.INIT_WRITE_FILE(p_chemin_fichier, 'PMWtoISAC.'||TO_CHAR(p_cpident), l_hfile);

	-- Rechercher toutes les lignes BIP du chef de projet
		FOR curseur IN CUR_PID(p_cpident) LOOP
		--dbms_output.put_line(curseur.pid);
			SELECT COUNT(1)
			INTO l_nb
			FROM isac_tache
			WHERE pid=curseur.pid;

			IF (l_nb=0) THEN
				 transfert(curseur.pid);
				 PACK_GLOBAL.WRITE_STRING( l_hfile,curseur.pid);
			 ELSE
				 PACK_GLOBAL.WRITE_STRING( l_hfile,curseur.pid||' : existe deja dans ISAC');
			END IF;

	END LOOP;
	PACK_GLOBAL.CLOSE_WRITE_FILE(l_hfile);
	END pmw_to_isac;

PROCEDURE pmw_to_isac( p_cpident IN NUMBER) IS
	l_nb	INTEGER;

      	CURSOR CUR_PID IS
 		select pid
		from ligne_bip
		where pcpi=p_cpident;

	BEGIN


	-- Rechercher toutes les lignes BIP du chef de projet
		FOR curseur IN CUR_PID LOOP
		--dbms_output.put_line(curseur.pid);
			SELECT COUNT(1)
			INTO l_nb
			FROM isac_tache
			WHERE pid=curseur.pid;

			IF (l_nb=0) THEN
				 transfert(curseur.pid);
			END IF;


	END LOOP;

	END pmw_to_isac;


	PROCEDURE f_verif_cp(	p_cp IN VARCHAR2,
					p_message   OUT VARCHAR2)
			 IS
	l_exist number(1);
	BEGIN
		select 1 into l_exist
		from ressource
		where ident=to_number(p_cp);
	EXCEPTION
		WHEN NO_DATA_FOUND THEN --Message : Identifiant chef de projet %s1 inexistant
		 	pack_global.recuperer_message(20226,'%s1',p_cp,NULL,p_message);
            	raise_application_error( -20226, p_message );


	END f_verif_cp;

-- ***************************************************************
-- PROCEDURE pec_isac
-- utiliser dans la page pecisac.htm pour mettre à jour les données d'ISAC
-- ***************************************************************
	PROCEDURE pec_isac(	p_cp1 IN VARCHAR2,
				p_cp2 IN VARCHAR2,
				p_cp3 IN VARCHAR2,
				p_cp4 IN VARCHAR2,
				p_cp5 IN VARCHAR2,
 				p_global    IN VARCHAR2,
                       		p_nbcurseur OUT INTEGER,
                       		p_message   OUT VARCHAR2
				) IS
	l_cp VARCHAR2(4000);-- PPM 63485 : augmenter la taille des chefs de projets à 4000
	BEGIN
		-- Vérifier que les CP existent dans la BIP
		if (p_cp1!='' or p_cp1 is not null) then
			pack_pmw_to_isac.f_verif_cp(	p_cp1,p_message);
		end if;
		if (p_cp2!='' or p_cp2 is not null) then
			pack_pmw_to_isac.f_verif_cp(	p_cp2,p_message);
		end if;
		if (p_cp3!='' or p_cp3 is not null) then
			pack_pmw_to_isac.f_verif_cp(	p_cp3,p_message);
		end if;
		if (p_cp4!='' or p_cp4 is not null) then
			pack_pmw_to_isac.f_verif_cp(	p_cp4,p_message);
		end if;
		if (p_cp5!='' or p_cp5 is not null) then
			pack_pmw_to_isac.f_verif_cp(	p_cp5,p_message);
		end if;

		if (p_cp1!='' or p_cp1 is not null) then
			pack_pmw_to_isac.pmw_to_isac(to_number(p_cp1));
			l_cp := p_cp1;
		end if;
		if (p_cp2!='' or p_cp2 is not null) then
			pack_pmw_to_isac.pmw_to_isac(to_number(p_cp2));
			l_cp := l_cp||', '||p_cp2;
		end if;
		if (p_cp3!='' or p_cp3 is not null) then
			pack_pmw_to_isac.pmw_to_isac(to_number(p_cp3));
			l_cp := l_cp||', '||p_cp3;
		end if;
		if (p_cp4!='' or p_cp4 is not null) then
			pack_pmw_to_isac.pmw_to_isac(to_number(p_cp4));
			l_cp := l_cp||', '||p_cp4;
		end if;
		if (p_cp5!='' or p_cp5 is not null) then
			pack_pmw_to_isac.pmw_to_isac(to_number(p_cp5));
			l_cp := l_cp||', '||p_cp5;
		end if;

	p_message:='Prise en charge des CP '||l_cp||' terminée';
	END pec_isac;
-- exec pack_pmw_to_isac.pmw_to_isac('/bip/bip3/extraction',3697);
END pack_pmw_to_isac;

/