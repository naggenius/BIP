-- pack_bjh_compare PL/SQL
--
-- Cree le 24/11/2000 par maintenance BIP
------------------------------------------------------------
--
-- Ce package contient les traitements lies au
-- bouclage jour/homme
-- 
-- Modifie par PPR le 12/07/2006 : Met en commentaire le delete sur  bjh_extgip dans  Filtre_Gershwin
-- afin d'éviter que des consommés de l'année qui portent sur des centres d'activité qui ont été
-- fermés depuis disparaissent
------------------------------------------------------------
------------------------------------------------------------
-- Creation du package
------------------------------------------------------------

CREATE OR REPLACE PACKAGE pack_bjh AS

------------------------------------------------------------
-- Cette procedure modifie les donnees recues de Gershwin
-- en eliminant les ressources qui ne concernent pas la BIP
-- (filtre sur le CA) et en convertissant le mofif
-- d'absence Gershwin en type d'absence BIP
------------------------------------------------------------
	PROCEDURE Filtre_Gershwin;

------------------------------------------------------------
-- Cette procedure recupere le consomme sur l'annee en cours.
------------------------------------------------------------
	PROCEDURE Import_consomme_BIP;

------------------------------------------------------------
-- Cette procedure recupere les ressources concernees par
-- le bouclage.
------------------------------------------------------------
	PROCEDURE Import_Ressource_BIP;

	PROCEDURE Compare_BIP_Gershwin;
END pack_bjh;
/

------------------------------------------------------------
--  Corps du package
------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY pack_bjh AS

        PROCEDURE Filtre_Gershwin IS
	BEGIN
-- Modifie par PPR le 12/07/2006	
--		DELETE bjh_extgip
--		        WHERE bjh_extgip.gipca NOT IN (SELECT centractiv from struct_info where topfer='O');

		UPDATE bjh_extgip
		        SET bipabs= (SELECT bjh_type_absence.bipabs FROM bjh_type_absence WHERE bjh_type_absence.gipabs=bjh_extgip.motifabs);

-- on ajoute des espaces en fin de type d'absence dans la table Gershwin
-- car c'est du CHAR(6) qui pose entre autre des problemes avec RTT
                UPDATE bjh_extgip
                        SET bipabs=RPAD(bipabs, 6, ' ');
-- la meme chose a ete faite sur bjh_type_absence

		COMMIT;
	END Filtre_Gershwin;



	PROCEDURE Import_Consomme_BIP IS
	BEGIN


-- extraction depuis la BIP des consommes divers
		DELETE bjh_extbip;
		COMMIT;

		INSERT INTO bjh_extbip
			(matricule
			, mois
			, typsst
			, cusag)
		SELECT
			ressource.matricule
			, TO_NUMBER(TO_CHAR(proplus.cdeb,'MM'))
			, RPAD(proplus.aist, 6, ' ')
			, SUM(proplus.cusag)   cusag
		FROM proplus
			, ressource
			, datdebex
		WHERE  proplus.cdeb >= TRUNC(datdebex.datdebex, 'YEAR')
			AND proplus.societe = 'SG..'
			AND proplus.cusag > 0
			AND proplus.rtype    = 'P'
			AND (proplus.divsecgrou < 500000 OR proplus.divsecgrou > 519999)  -- pour retirer SGAM
			AND ressource.ident=proplus.tires
		GROUP BY ressource.matricule
			, RPAD(proplus.aist, 6, ' ')
			, TO_NUMBER(TO_CHAR(proplus.cdeb,'MM'));

		COMMIT;
	END Import_Consomme_BIP;


	PROCEDURE Import_Ressource_BIP IS
	BEGIN
-- extraction des ressources qui nous interessent
		DELETE bjh_ressource;
		COMMIT;

		INSERT INTO bjh_ressource
		(
			matricule,
			mois,
			codsg,
			nom,
			prenom,
			dep,
			pole,
			ident,
			activite
		)
		SELECT DISTINCT
			ressource.matricule
			, cal.mois
			, proplus.divsecgrou
			, ressource.rnom
			, ressource.rprenom
			, struct_info.sigdep
			, struct_info.sigpole
			, ressource.ident
			, struct_info.centractiv
		FROM proplus
			, (SELECT TO_CHAR(calanmois, 'MM') mois
					, cjours
					, calanmois
				FROM calendrier, datdebex
				WHERE TRUNC(calanmois, 'year')=TRUNC(datdebex)		-- annee courante
				AND calanmois<=moismens					-- en se limitant aux mois deja traites
			  ) cal
			, struct_info
			, ressource
		WHERE
			TRUNC(proplus.cdeb, 'MM')=TRUNC(cal.calanmois, 'MM')
			AND proplus.tires=ressource.ident
			AND proplus.divsecgrou=struct_info.codsg
			AND proplus.societe='SG..'					-- seulement les Societe Generale
			AND proplus.rtype='P'						-- ressource de type PERSONNE
			AND (proplus.divsecgrou<500000 OR proplus.divsecgrou>519999)	-- on retire SGAM
			AND ressource.matricule IS NOT NULL				-- on retire les ressources avec un
			AND ressource.matricule!='0000000';				-- matricule incoherent

-- suppression des doublons (meme matricule, ident diferent)
		DELETE bjh_ressource
		WHERE matricule IN
			(SELECT t1.matricule
				FROM bjh_ressource t1
					, bjh_ressource t2
				WHERE t1.matricule=t2.matricule
					AND t1.mois=t2.mois
					AND t1.ident!=t2.ident
			);
		COMMIT;


-- mise a jour des consommes des ressources (a partir de la BIP)
--	consomme total
--	consomme conge
--	consomme absence autre que conge
		UPDATE bjh_ressource
			SET conso_total=(SELECT NVL(SUM(cusag), 0)
								FROM bjh_extbip
								WHERE bjh_extbip.matricule=bjh_ressource.matricule
								AND bjh_extbip.mois=bjh_ressource.mois
							 )
				, conso_conge=(SELECT NVL(SUM(cusag), 0)
								FROM bjh_extbip
								WHERE bjh_extbip.matricule=bjh_ressource.matricule
								AND bjh_extbip.mois=bjh_ressource.mois
								AND bjh_extbip.typsst IN (SELECT bipabs FROM bjh_type_absence)
							 )
				, conso_autre=(SELECT NVL(SUM(cusag), 0)
								FROM bjh_extbip
								WHERE bjh_extbip.matricule=bjh_ressource.matricule
								AND bjh_extbip.mois=bjh_ressource.mois
								AND bjh_extbip.typsst IN ('ACCUEI','CLUBUT','COLOQU','DEMENA','MOBILI','SEMINA')
							 );
		COMMIT;




-- mise a jour du champ "Temps partiel" des ressources a partir de Gershwin
-- la condition ROWNUM=1 est une bidouille car on peut avoir plusieurs lignes pour une ressource et un mois
		UPDATE bjh_ressource
			SET tempart=(SELECT tempart
							FROM bjh_extgip
							WHERE bjh_ressource.mois=bjh_extgip.mois
							AND bjh_ressource.matricule=bjh_extgip.matricule
							AND ROWNUM=1
						);

		COMMIT;
	END Import_Ressource_BIP;





        PROCEDURE Compare_BIP_Gershwin IS
                CURSOR csr_anomalie IS
                        SELECT tmp.matricule    tmp_matricule
                                , ano.matricule		ano_matricule
                                , tmp.mois		mois
                                , tmp.typeabsence	typeabsence
                                , ano.coutgip		ano_coutgip
                                , ano.coutbip		ano_coutbip
                                , tmp.coutgip		tmp_coutgip
                                , tmp.coutbip		tmp_coutbip
				, NVL(ano.validation1, ano.validation2)	validation
				, ano.topdv		topdv
                        FROM bjh_anomalies ano
                                , bjh_anomalies_temp tmp
                        WHERE tmp.matricule=ano.matricule(+)
                                AND tmp.mois=ano.mois(+)
                                AND tmp.typeabsence=ano.typeabsence(+);
		l_moismens	datdebex.moismens%TYPE;
		l_topdv		bjh_anomalies.topdv%TYPE;
	BEGIN
-- alimentation de la table bjh_anomalies_temp qui contient toutes les anomalies BIP / Gershwin a l'instant donnee
		DELETE bjh_anomalies_temp;
		COMMIT;

-- premiere etape : une ligne par ressource, par mois et par type d'absence
		INSERT INTO bjh_anomalies_temp(matricule, mois, typeabsence)
			SELECT
				bjh_ressource.matricule
				, bjh_ressource.mois
				, bipabs
			FROM
				bjh_ressource
				, (SELECT DISTINCT bipabs FROM bjh_type_absence);
		COMMIT;



-- deuxieme etape : mise a jour du cumul pour BIP par ressource, mois, type absence
		UPDATE bjh_anomalies_temp
			SET coutbip=(SELECT NVL(SUM(cusag), 0)
							FROM bjh_extbip
							WHERE bjh_extbip.matricule=bjh_anomalies_temp.matricule
							AND bjh_extbip.mois=bjh_anomalies_temp.mois
							AND bjh_extbip.typsst=bjh_anomalies_temp.typeabsence
						)
			, coutgip=(SELECT NVL(SUM(intjour), 0)
							FROM bjh_extgip
							WHERE bjh_extgip.matricule=bjh_anomalies_temp.matricule
							AND bjh_extgip.mois=bjh_anomalies_temp.mois
							AND bjh_extgip.bipabs=bjh_anomalies_temp.typeabsence
						);
		COMMIT;


-- troisieme etape : suppression des lignes ou BIP = Gershwin
		DELETE bjh_anomalies_temp WHERE coutbip=coutgip;
		COMMIT;


-- quatrieme etape : supression des lignes sans Gershwin ni BIP
		DELETE bjh_anomalies_temp WHERE coutbip IS NULL AND coutgip IS NULL;





-- ################################################################
-- A ce niveau bjh_anomalies_temp contient les ecarts entre BIP et Gershwin.
-- Il faut maintenant mettre a jour bjh_anomalies, sans ecraser les
-- eventuelles validations.
-- La procedure pour cela est la suivante :
--		- suppresion des anomalies de bjh_anomalies qui n'existent
--		  pas dans bjh_anomalies_temp (anomalies corrigees)
--		- mise a jour des anomalies presentes dans les deux tables
--		  mais pour des valeurs differentes
--		  (suppression de la validation)
--		- ajout dans bjh_anomalies des nouvelles anomalies
-- ################################################################


		DELETE bjh_anomalies b
			WHERE (b.matricule,b.mois,b.typeabsence) NOT IN (SELECT matricule,mois,typeabsence FROM bjh_anomalies_temp);
		COMMIT;


-- toutes les anomalies devalidees le mois precedent redeviennent des anomalies non validees, sans plus
		SELECT moismens
			INTO l_moismens
			FROM datdebex;

		UPDATE bjh_anomalies
			SET topdv=NULL
			WHERE topdv<l_moismens;
		COMMIT;

-- on fait une boucle sur toutes les anomalies dans bjh_anomalies_temp
		FOR rec_anomalie IN csr_anomalie LOOP
			IF rec_anomalie.ano_matricule IS NULL THEN
-- l'anomalie n'existe que dans bjh_anomalies_temp : on l'ajoute dans bjh_anomalies
				INSERT INTO bjh_anomalies(
					matricule
					, mois
					, typeabsence
					, coutgip
					, coutbip
					, dateano
					, validation1
					, validation2
					, ecartcal
					, topdv
				)
				VALUES (
					rec_anomalie.tmp_matricule
					, rec_anomalie.mois
					, rec_anomalie.typeabsence
					, rec_anomalie.tmp_coutgip
					, rec_anomalie.tmp_coutbip
					, SYSDATE
					, NULL
					, NULL
					, 0
					, NULL);
			ELSE
-- l'anomalie existe : on ne modifie que si l'un au moins des couts est different
				IF rec_anomalie.tmp_coutbip!=rec_anomalie.ano_coutbip
						OR rec_anomalie.tmp_coutgip!=rec_anomalie.ano_coutgip THEN

					IF rec_anomalie.topdv=l_moismens THEN
-- l'ano a deja ete marquee devalidee ce mois-ci
						l_topdv:=l_moismens;
					ELSE
						IF rec_anomalie.validation IS NULL THEN
							l_topdv:=NULL;
						ELSE
							l_topdv:=l_moismens;
						END IF;
					END IF;

					UPDATE bjh_anomalies
						SET coutbip=rec_anomalie.tmp_coutbip
							, coutgip=rec_anomalie.tmp_coutgip
							, validation1 = NULL
							, validation2 = NULL
							, topdv=l_topdv
						WHERE matricule=rec_anomalie.tmp_matricule
							AND mois=rec_anomalie.mois
							AND typeabsence=rec_anomalie.typeabsence;
				END IF;
			END IF;

			COMMIT;
		END LOOP;

	END Compare_BIP_Gershwin;

END pack_bjh;
/
