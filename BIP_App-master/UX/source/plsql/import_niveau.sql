-- pack_import_niveau PL/SQL

--

-- Cree le 27/10/2003 par MMC

-- Modif

-- 12/07/2004	EGR		F370 : retrait de filcode dans situ_ress et situ_ress_full

-- 20/04/2005   PPR             Remise à niveau du code car la date de mise à jour n'est 

--				pas rensignée correctement dans le fichier reçu

-- 06/09/2005   PPR             Correction suite problème en prod de début Septembre
--- 01/09/2009 ABA  TD 795 correction suite au chzngement de niveau d'un SG
------------------------------------------------------------

--

-- Ce package contient les traitements lies a l'import des

-- niveaux des ressources SG depuis Gershwin

-- 

------------------------------------------------------------

------------------------------------------------------------

-- Creation du package

------------------------------------------------------------



CREATE OR REPLACE PACKAGE pack_import_niveau AS



------------------------------------------------------------

-- Cette procedure modifie les donnees concernant le niveau

-- present dans la situation de la ressource

------------------------------------------------------------

	PROCEDURE alim_situation;



END pack_import_niveau;
/


create or replace
PACKAGE BODY       "PACK_IMPORT_NIVEAU" AS



PROCEDURE alim_situation IS



l_date_defaut VARCHAR2(10);

l_count1 NUMBER;
l_count2 NUMBER;
l_count3 NUMBER;
l_count4 NUMBER;



BEGIN



--on vide la table des erreurs

DELETE FROM  TMP_IMP_NIVEAU_ERR;

COMMIT;



--Gestion des anomalies : A inserer dans une TABLE des erreurs

--Cas 1 : la ressource n'existe pas dans la Bip

/*INSERT INTO TMP_IMP_NIVEAU_ERR

	(SELECT DISTINCT t.matricule,t.nom,t.prenom,t.niveau,t.date_maj,'matricule inexistant'

	FROM TMP_IMP_NIVEAU t,datdebex dx

	WHERE NOT EXISTS (SELECT 1 FROM ressource r WHERE r.matricule=t.matricule)

	AND (TO_CHAR(dx.datdebex,'yyyy')=SUBSTR(t.date_maj,1,4) OR t.date_maj = '00000000')

);

COMMIT;*/



--Cas a part : ressource existe mais plus de situation sur l annee en cours : on les fait pas

-- apparaitre dans l extraction (trop de ressources)

INSERT INTO TMP_IMP_NIVEAU_ERR

	(SELECT DISTINCT t.matricule,situ.ident,situ.codsg,t.nom,t.prenom,t.niveau,t.date_maj,'situation terminée'

	 FROM TMP_IMP_NIVEAU t,datdebex dx,situ_ress_full situ,ressource r

 	 WHERE to_number(TO_CHAR(dx.datdebex,'yyyy')) > to_number(to_char(situ.datsitu-1,'yyyy'))

         and situ.type_situ='P'

         and situ.datdep is null

         AND  t.matricule=r.matricule

 	 AND r.ident=situ.ident

 	 AND (TO_CHAR(dx.datdebex,'yyyy')=SUBSTR(t.date_maj,1,4) OR t.date_maj = '00000000')

);

COMMIT;



--Cas 2 : le niveau n'existe pas dans la table NIVEAU

INSERT INTO TMP_IMP_NIVEAU_ERR

	(SELECT DISTINCT t.matricule,situ.ident,situ.codsg,t.nom,t.prenom,t.niveau,t.date_maj,'niveau inexistant'

	FROM TMP_IMP_NIVEAU t,datdebex dx,situ_ress situ,ressource r

	WHERE NOT EXISTS (SELECT 1 FROM niveau n WHERE n.niveau=(rtrim(t.niveau)))

	AND EXISTS (SELECT 1 FROM ressource r WHERE r.matricule=t.matricule)

	AND NOT EXISTS (select 1 FROM TMP_IMP_NIVEAU_ERR err where err.matricule=t.matricule

			AND err.type_err='situation terminée')

	AND situ.ident=r.ident

	AND r.matricule=t.matricule

	AND ( situ.datdep IS NULL OR TO_CHAR(situ.datdep,'yyyy')=TO_CHAR(dx.datdebex,'yyyy') )

);

COMMIT;



--Cas 3 : la ressource existe dans la bip mais n'a pas de situation

INSERT INTO TMP_IMP_NIVEAU_ERR

	(SELECT DISTINCT t.matricule,NULL,NULL,t.nom,t.prenom,t.niveau,t.date_maj,'ressource sans situation'

	FROM TMP_IMP_NIVEAU t,datdebex dx

	WHERE NOT EXISTS (SELECT 1 FROM situ_ress s,ressource r WHERE s.ident=r.ident

			  AND r.matricule=t.matricule)

	AND EXISTS (SELECT 1 FROM ressource r WHERE r.matricule=t.matricule)

	AND (TO_CHAR(dx.datdebex,'yyyy')=SUBSTR(t.date_maj,1,4) OR t.date_maj = '00000000')

);

COMMIT;







--Cas 4 : le changement de niveau intervient dans le même mois qu'une nouvelle situation

INSERT INTO TMP_IMP_NIVEAU_ERR

	(SELECT DISTINCT t.matricule,s.ident,s.codsg,t.nom,t.prenom,t.niveau,t.date_maj,'changement dans le mois'

	FROM TMP_IMP_NIVEAU t,situ_ress s,ressource r,datdebex dx

	WHERE

	TO_CHAR(s.datsitu,'mmyyyy')=SUBSTR(t.date_maj,5,2)||SUBSTR(t.date_maj,1,4)

	AND  t.matricule=r.matricule

	AND r.ident=s.ident

	AND (TO_CHAR(dx.datdebex,'yyyy')=SUBSTR(t.date_maj,1,4) OR t.date_maj = '00000000')

	AND s.niveau <> rtrim(t.niveau)

);

COMMIT;



--Cas 5 : matricule en doublon dans la Bip (ca ne devrait pas exister mais sait-on jamais ...)

INSERT INTO TMP_IMP_NIVEAU_ERR

	(SELECT DISTINCT  t.matricule,s.ident,s.codsg,t.nom,t.prenom,t.niveau,t.date_maj,'matricule en doublon'

	FROM TMP_IMP_NIVEAU t,ressource r,situ_ress s,datdebex dx

	WHERE  EXISTS  (SELECT  1 FROM  ressource r2 WHERE  r2.matricule=r.matricule AND  r2.ident!=r.ident)

	AND r.matricule=t.matricule

	AND NOT EXISTS (select 1 FROM TMP_IMP_NIVEAU_ERR err where err.matricule=t.matricule

			AND err.type_err='situation terminée')

	AND s.ident=r.ident

	AND ( s.datdep IS NULL OR TO_CHAR(s.datdep,'yyyy')=TO_CHAR(dx.datdebex,'yyyy') )

);

COMMIT;



--Cas 6 : ressource existe dans la Bip avec une situation dans l'annee et niveau à NULL

-- mais son matricule ne figure pas dans le fichier Gershwin

INSERT INTO TMP_IMP_NIVEAU_ERR

	(SELECT DISTINCT  NVL(r.matricule,'XX'),s.ident,s.codsg,NVL(r.rnom,'XX'),NVL(r.rprenom,'XX'),NVL(s.niveau,'XX'),'XX','La ressource n''est pas dans le fichier Gershwin'

	FROM ressource r,situ_ress s,datdebex dx

	WHERE s.ident=r.ident

	AND s.niveau IS NULL

	AND ( s.datdep IS NULL OR TO_CHAR(s.datdep,'yyyy')=TO_CHAR(dx.datdebex,'yyyy') )

	AND s.soccode='SG..'

	AND r.rtype='P'

	AND NOT EXISTS (SELECT 1 FROM tmp_imp_niveau t  WHERE t.matricule=r.matricule)

);

COMMIT;



-- On initalise la date par défaut du changement de niveau , car la date est rarement renseignée

-- dans le fichier de Gerschwin , on fixe cette date au mois suivant du mois de la mensuelle

SELECT to_char(add_months(moismens,1),'yyyy/mm/dd')

	INTO l_date_defaut

	FROM datdebex ;



DECLARE

--dans le curseur a parcourir, on prend les ressources dont le matricule existe dans la BIP

-- et dont le niveau est present dans la table NIVEAU

--si la DATE de maj est 00000000, ON la remplace par la date par défaut

CURSOR C_NIVEAU IS SELECT DISTINCT t.niveau,r.ident,l_date_defaut date_maj

			FROM  TMP_IMP_NIVEAU t,ressource r,niveau n,datdebex dx

			WHERE t.matricule=r.matricule

			AND rtrim( t.niveau)=n.niveau

			AND (TO_CHAR(dx.datdebex,'yyyy')=SUBSTR(t.date_maj,1,4)	OR t.date_maj = '00000000')

			AND t.niveau <> '00'

			;



	BEGIN

	FOR ONE_NIVEAU IN C_NIVEAU LOOP

	 BEGIN

	 	-- Met à jour tous les niveaux non renseignés

	 	--
    
    
    -- On compte le nombre de lignes à mettre à jour (on ne logue que s'il y en a)
    SELECT COUNT(*) INTO l_count1
    FROM situ_ress
    WHERE situ_ress.ident=ONE_NIVEAU.ident
    AND (TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd') >= situ_ress.datsitu )
		AND (TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd') < situ_ress.datdep OR situ_ress.datdep IS NULL)
		AND ( situ_ress.niveau IS NULL  )
		AND situ_ress.soccode='SG..';
    
      UPDATE situ_ress
  
              SET situ_ress.niveau=rtrim(ONE_NIVEAU.niveau)
  
              WHERE situ_ress.ident=ONE_NIVEAU.ident
  
              AND (TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd') >= situ_ress.datsitu )
  
              AND (TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd') < situ_ress.datdep OR situ_ress.datdep IS NULL)
  
              AND ( situ_ress.niveau IS NULL  )
  
              AND situ_ress.soccode='SG..';
              
              IF l_count1 > 0 THEN
                Pack_Ressource_F.maj_ressource_logs(ONE_NIVEAU.ident,'Batch import niveau','RESSOURCE','ident',null, ONE_NIVEAU.ident,'Modification automatique situation suite chgt niveau');
                Pack_Ressource_F.maj_ressource_logs(ONE_NIVEAU.ident,'Batch import niveau','RESSOURCE','datsitu',null, ONE_NIVEAU.date_maj,'Modification automatique situation suite chgt niveau');
                Pack_Ressource_F.maj_ressource_logs(ONE_NIVEAU.ident,'Batch import niveau','RESSOURCE','niveau', null, ONE_NIVEAU.niveau, 'Modification automatique situation suite chgt niveau');
              END IF;
      COMMIT;


	 	-- Met à jour tous les niveaux différents pour une ligne ayant la même date de situation

	 	--
    
    -- On compte le nombre de lignes à mettre à jour (on ne logue que s'il y en a)
    SELECT COUNT(*) INTO l_count2
    FROM situ_ress
    WHERE situ_ress.ident=ONE_NIVEAU.ident
    AND (TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd') = situ_ress.datsitu )
    AND (TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd') < situ_ress.datdep OR situ_ress.datdep IS NULL)
    AND situ_ress.niveau<>rtrim(ONE_NIVEAU.niveau)
    AND situ_ress.soccode='SG..';

      UPDATE situ_ress
  
              SET situ_ress.niveau=rtrim(ONE_NIVEAU.niveau)
  
              WHERE situ_ress.ident=ONE_NIVEAU.ident
  
              AND (TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd') = situ_ress.datsitu )
  
              AND (TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd') < situ_ress.datdep OR situ_ress.datdep IS NULL)
  
              AND situ_ress.niveau<>rtrim(ONE_NIVEAU.niveau)
  
              AND situ_ress.soccode='SG..';
              
              IF l_count2 > 0 THEN
                Pack_Ressource_F.maj_ressource_logs(ONE_NIVEAU.ident,'Batch import niveau','RESSOURCE','ident',null, ONE_NIVEAU.ident,'Modification automatique situation suite chgt niveau');
                Pack_Ressource_F.maj_ressource_logs(ONE_NIVEAU.ident,'Batch import niveau','RESSOURCE','datsitu',null, ONE_NIVEAU.date_maj,'Modification automatique situation suite chgt niveau');
                Pack_Ressource_F.maj_ressource_logs(ONE_NIVEAU.ident,'Batch import niveau','RESSOURCE','niveau', null, ONE_NIVEAU.niveau, 'Modification automatique situation suite chgt niveau');
              END IF;
  
      COMMIT;
    
    



		--Cas d'un changement de niveau

		--On insère une ligne identique à celle présente dans la base avec le nouveau niveau et

		--Une date de situation égale à la date de mise à jour
    
    -- On compte le nombre de lignes à mettre à jour (on ne logue que s'il y en a)
    SELECT COUNT(*) INTO l_count3
    FROM situ_ress s
    WHERE s.ident=ONE_NIVEAU.ident
    AND (TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd') > s.datsitu )
    AND (TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd') < s.datdep OR s.datdep IS NULL)
    AND s.niveau <> rtrim(ONE_NIVEAU.niveau)
    AND s.soccode='SG..';

      INSERT INTO situ_ress (datsitu,datdep,cpident,cout,dispo,marsg2,rmcomp,prestation,dprest,
  
      ident,soccode,codsg,niveau)
  
         (SELECT TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd'),
  
          s.datdep ,
  
          s.cpident,s.cout,s.dispo,s.marsg2,s.rmcomp,s.prestation,s.dprest,
  
          s.ident,s.soccode,s.codsg,
  
          rtrim(ONE_NIVEAU.niveau)
  
         FROM situ_ress s
  
         WHERE s.ident=ONE_NIVEAU.ident
  
         AND (TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd') > s.datsitu )
  
               AND (TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd') < s.datdep OR s.datdep IS NULL)
  
               AND s.niveau <> rtrim(ONE_NIVEAU.niveau)
  
               AND s.soccode='SG..'
  
               );
               
        IF l_count3 > 0 THEN
          Pack_Ressource_F.maj_ressource_logs(ONE_NIVEAU.ident,'Batch import niveau','RESSOURCE','ident',null, ONE_NIVEAU.ident,'Creation automatique situation suite chgt niveau');
          Pack_Ressource_F.maj_ressource_logs(ONE_NIVEAU.ident,'Batch import niveau','RESSOURCE','datsitu',null, ONE_NIVEAU.date_maj,'Creation automatique situation suite chgt niveau');
          Pack_Ressource_F.maj_ressource_logs(ONE_NIVEAU.ident,'Batch import niveau','RESSOURCE','niveau',null, ONE_NIVEAU.niveau,'Creation automatique situation suite chgt niveau');
        END IF;
        
        COMMIT;



		--Cas d'un changement de niveau

		--ON renseigne la DATE de depart dans la situation existante
    
      UPDATE situ_ress s
  
         SET s.datdep=TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd')-1
  
         WHERE s.ident=ONE_NIVEAU.ident
  
         AND (TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd') > s.datsitu )
  
               AND (TO_DATE(ONE_NIVEAU.date_maj,'yyyy/mm/dd') < s.datdep OR s.datdep IS NULL)
  
               AND s.niveau <> rtrim(ONE_NIVEAU.niveau)
  
               AND s.soccode='SG..' ;
 
      COMMIT;


	 END;

	END LOOP;

	END;

	END alim_situation;



END pack_import_niveau;
/


