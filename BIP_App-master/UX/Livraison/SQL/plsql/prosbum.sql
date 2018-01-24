-- -------------------------------------------------------------------
-- pack_verif_prosbum PL/SQL
--
-- equipe SOPRA (HT)
--
-- crée le 15/02/2000
--
-- Package qui sert à la réalisation de l'état PROSBUM
--                   
-- -------------------------------------------------------------------
--
-- Modification
-- Quand	Qui	Quoi
-- 08/11/2000	OT	retrait des lignes_bip pour qualif = MO ou GRA
-- 05/03/2001 	ODu	ajout de la fonction ConsommeLigneBIP suite a refonte complete
-- 14/01/2008 EVI modif de la table pour recuperer les consomme de l'anne precedente proplus => consomme
--			du report PROSBUM
--
--
-- SET SERVEROUTPUT ON SIZE 1000000;

CREATE OR REPLACE PACKAGE pack_verif_prosbum  AS

   --
   -- Nom        : f_sg
   -- Auteur     : Equipe SOPRA (HT)
   -- Decription : Calcul du consommé d'une ressource pour le mois/
   --     année fourni en paramètres
   -- Paramètres :
   --              p_factpid (IN)
   --			 p_soci(IN)     'SG ou SSII' soc. des ressources
   --              p_type (IN)    'M ou A' mensuel ou annuel
   --              p_moisannee (IN)  Ex. : 01/04/1999
   -- ---------------------------------------------------------------
   FUNCTION f_sg(
			    p_factpid             IN VARCHAR2,
			    p_soci		  IN VARCHAR2,
			    p_type		  IN VARCHAR2,
			    p_moisannee           IN DATE
			    ) RETURN NUMBER;

PRAGMA restrict_references(f_sg, WNDS);

-----------------------------------------------------------------------------------------------------------
--	NOM		ConsommeLigneBIP
--	Fonction	retourne la somme du consommé sur une ligne bip
--	Parametres	p_PID		identifiant de la ligne BIP
--			p_mensuel	0	consomme sur l'annee de la derniere mensuelle
--					1	consomme sur le mois de l'annee de la derniere mensuelle
--					-1	consomme total sur les annees precedentes a l'annee de la derniere mensuelle
--			p_SG		0	seulement les SSII
--					1	seulement les SG
--					NULL	tout le monde
-----------------------------------------------------------------------------------------------------------
	FUNCTION ConsommeLigneBIP(
		p_PID		IN	ligne_bip.pid%TYPE,
		p_mensuel	IN	INTEGER,
		p_SG		IN	INTEGER
	) RETURN NUMBER;

PRAGMA restrict_references(ConsommeLigneBIP, WNDS);

END pack_verif_prosbum;
/


CREATE OR REPLACE PACKAGE BODY     pack_verif_prosbum  AS
-- ---------------------------------------------------

FUNCTION f_sg(
			   p_factpid             IN VARCHAR2,
			    p_soci		  IN VARCHAR2,
			    p_type		  IN VARCHAR2,
			    p_moisannee           IN DATE
			)
			     RETURN NUMBER IS

	l_sg number;
	l_ssii number;
	l_type varchar2(8);

BEGIN
	if p_type = 'M' then
		l_type := 'MM/YYYY';
	elsif p_type = 'A' then
		l_type := 'YYYY';
	end if;
	if p_soci = 'SG' then
          SELECT SUM(cusag)
		  INTO	l_sg
		  FROM  proplus
	 	  WHERE
		factpid    = p_factpid
		AND societe like 'SG%'
		AND qualif not in ('MO','GRA')
		AND to_char(cdeb,l_type) = to_char(p_moisannee,l_type)
		AND to_date(to_char(cdeb,'MM/YYYY'),'MM/YYYY') <=
			 to_date(to_char(p_moisannee,'MM/YYYY'),'MM/YYYY');
	    RETURN( nvl(l_sg,0) );
	end if;

	if p_soci = 'SSII' then
	    SELECT SUM(cusag)
		  INTO	l_ssii
		  FROM  proplus
	 	  WHERE
		factpid    = p_factpid
		AND societe not like 'SG%'
		AND qualif not in ('MO','GRA')
		AND to_char(cdeb,l_type) = to_char(p_moisannee,l_type)
         	AND to_date(to_char(cdeb,'MM/YYYY'),'MM/YYYY') <=
			to_date(to_char(p_moisannee,'MM/YYYY'),'MM/YYYY');
	   RETURN( nvl(l_ssii,0) );
	end if;

	--	DBMS_OUTPUT.PUT_LINE('pid: '|| p_factpid);
	--	DBMS_OUTPUT.PUT_LINE('mois: '|| p_type);
	--	DBMS_OUTPUT.PUT_LINE('total: '|| l_sg);
	--	DBMS_OUTPUT.PUT_LINE('total: '|| l_ssii);

	EXCEPTION
		WHEN no_data_found THEN return 0;

END f_sg;

	FUNCTION ConsommeLigneBIP(
		p_PID		IN	ligne_bip.pid%TYPE,
		p_mensuel	IN	INTEGER,
		p_SG		IN	INTEGER
	) RETURN NUMBER IS
		result	NUMBER;
	BEGIN
		IF (p_mensuel=1) THEN
			IF (p_SG=1) THEN
				SELECT SUM(cusag)
				INTO result
				FROM proplus, DatDebEx
				WHERE factpid=p_PID
				AND TRUNC(cdeb,'MONTH')=TRUNC(DatDebEx.MoisMens,'MONTH')
				AND societe='SG..';
			ELSIF (p_SG=0) THEN
				SELECT SUM(cusag)
				INTO result
				FROM proplus, DatDebEx
				WHERE factpid=p_PID
				AND TRUNC(cdeb,'MONTH')=TRUNC(DatDebEx.MoisMens,'MONTH')
				AND societe!='SG..';
			ELSE
				SELECT SUM(cusag)
				INTO result
				FROM proplus, DatDebEx
				WHERE factpid=p_PID
				AND TRUNC(cdeb,'MONTH')=TRUNC(DatDebEx.MoisMens,'MONTH');
			END IF;
		ELSIF (p_mensuel=0) THEN	-- annuel
			IF (p_SG=1) THEN
				SELECT SUM(cusag)
				INTO result
				FROM proplus, DatDebEx
				WHERE factpid=p_PID
				AND TRUNC(cdeb,'YEAR')=TRUNC(DatDebEx.MoisMens,'YEAR')
				AND societe='SG..';
			ELSIF (p_SG=0) THEN
				SELECT SUM(cusag)
				INTO result
				FROM proplus, DatDebEx
				WHERE factpid=p_PID
				AND TRUNC(cdeb,'YEAR')=TRUNC(DatDebEx.MoisMens,'YEAR')
				AND societe!='SG..';
			ELSE
				SELECT SUM(cusag)
				INTO result
				FROM proplus, DatDebEx
				WHERE factpid=p_PID
				AND TRUNC(cdeb,'YEAR')=TRUNC(DatDebEx.MoisMens,'YEAR');
			END IF;
		ELSE				-- annees precedentes
			IF (p_SG=1) THEN
				SELECT SUM(cusag)
				INTO result
				FROM proplus, DatDebEx
				WHERE factpid=p_PID
				AND cdeb<TRUNC(DatDebEx.MoisMens,'YEAR')
				AND societe='SG..';
			ELSIF (p_SG=0) THEN
				SELECT SUM(cusag)
				INTO result
				FROM proplus, DatDebEx
				WHERE factpid=p_PID
				AND cdeb<TRUNC(DatDebEx.MoisMens,'YEAR')
				AND societe!='SG..';
			ELSE
				SELECT SUM(c.cusag)
				INTO result
				FROM consomme c, DatDebEx
				WHERE c.pid=p_PID
                and c.pid in (select distinct factpid from proplus)
				AND TO_CHAR(annee) = TO_CHAR(DatDebEx.MoisMens,'YYYY')-1;
			END IF;
		END IF;
		RETURN result;
	END;

END pack_verif_prosbum;
/


