-- pack_libelles PL/SQL
--
-- créé le 15/01/2005
-- Package qui contient les procédures rapportant les libellés des objets de la BIP
-- Fiche 101 : insertion des libellés de CA et de code MO
-- 
-- Modifié par PPR le 10/05/2005 : Ne prend que les ca non fermés dans get_lib_codcamo_facturable
-- Modifié par DDI le 24/10/2005 : Ajout libellé code DPG pour fiche 272.
-- Modifié par DDI le 08/03/2006 : Fiche 372. Se baser sur moismens à la place de datdebex pour le controle des CA facturables.
-- Le 07/08/2006 par DDI  : Fiche 451 : Amélioration des messages sur les CA fermés.
--******************************************************************************************************************

CREATE OR REPLACE PACKAGE pack_libelles AS

-- Retourne le libéllé du CA payeur
PROCEDURE get_lib_codcamo ( 	p_codcamo		IN	VARCHAR2,
				p_lib_codcamo		OUT	entite_structure.licoes%TYPE,
				p_message		OUT 	VARCHAR2
				);
				
-- Retourne le libéllé du CA payeur si facturable
PROCEDURE get_lib_codcamo_facturable ( 	p_codcamo		IN	VARCHAR2,
				p_lib_codcamo		OUT	entite_structure.licoes%TYPE,
				p_message		OUT 	VARCHAR2
				);
				
-- Retourne le libéllé du code client
PROCEDURE get_lib_clicode ( 	p_clicode		IN	client_mo.clicode%TYPE,
				p_clilib		OUT	client_mo.clilib%TYPE,
				p_message		OUT 	VARCHAR2
				);

-- Retourne le libéllé du Code DPG
PROCEDURE get_lib_coddpg ( 	p_codsg		  	IN  struct_info.codsg%TYPE,
				p_lib_codsg      	OUT struct_info.libdsg%TYPE,
				p_message	  	OUT VARCHAR2
				);

END pack_libelles;
/

CREATE OR REPLACE PACKAGE BODY pack_libelles AS 
-- Retourne le libéllé du CA payeur
PROCEDURE get_lib_codcamo ( 	p_codcamo		IN	VARCHAR2,
			    	p_lib_codcamo		OUT	entite_structure.licoes%TYPE,
			    	p_message		OUT 	VARCHAR2
			    	) IS
BEGIN
	-- On recherche de lib dans la table entite_structure
	SELECT 	licoes INTO p_lib_codcamo
	FROM 	entite_structure
	WHERE	codcamo=TO_NUMBER(p_codcamo);
		
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
		BEGIN
			-- On recherche de lib dans la table centre_activite
			SELECT 	clibca INTO p_lib_codcamo
			FROM 	centre_activite
			WHERE	codcamo=TO_NUMBER(p_codcamo);
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				pack_global.recuperer_message( 2007, NULL, NULL, NULL, p_message);
		END;
	WHEN OTHERS THEN
		raise_application_error( -20997, SQLERRM);
END get_lib_codcamo;

-- Retourne le libéllé du CA payeur si facturable
PROCEDURE get_lib_codcamo_facturable ( 	p_codcamo		IN	VARCHAR2,
			    	p_lib_codcamo		OUT	entite_structure.licoes%TYPE,
			    	p_message		OUT 	VARCHAR2
			    	) IS
	 l_cdateferm centre_activite.CDATEFERM%TYPE;
	 l_cdfain    centre_activite.CDFAIN%TYPE;
	 l_moismens  datdebex.moismens%TYPE;
BEGIN
  BEGIN
    SELECT 	d.moismens INTO l_moismens
	FROM 	datdebex d;
  END;
  BEGIN
	-- On recherche de lib dans la table centre_activite. 
	SELECT 	c.clibca, c.CDATEFERM, c.CDFAIN INTO p_lib_codcamo, l_cdateferm, l_cdfain
	FROM 	centre_activite c
	WHERE	c.codcamo=TO_NUMBER(p_codcamo);
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		pack_global.recuperer_message( 20986, NULL, NULL, NULL, p_message);
  END;		
  		
	IF ((l_cdateferm is not null) AND (l_cdateferm < l_moismens) )THEN
		pack_global.recuperer_message( 20985, NULL, NULL, NULL, p_message);
	ELSE 
		 IF (l_cdfain=3) THEN
		 	pack_global.recuperer_message( 20984, NULL, NULL, NULL, p_message);
		 END IF;
	END IF;	
	
END get_lib_codcamo_facturable;


-- Retourne le libéllé du code client
PROCEDURE get_lib_clicode ( 	p_clicode		IN	client_mo.clicode%TYPE,
				p_clilib		OUT	client_mo.clilib%TYPE,
				p_message		OUT 	VARCHAR2
				) IS

BEGIN
	-- On recherche de lib dans la table client_mo
	SELECT 	clilib INTO p_clilib
	FROM 	client_mo
	WHERE	clicode=p_clicode;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		pack_global.recuperer_message( 4, '%s1', p_clicode, NULL, p_message);
	WHEN OTHERS THEN
		raise_application_error( -20997, SQLERRM);

END get_lib_clicode;

-- Retourne le libéllé du code DPG
PROCEDURE get_lib_coddpg ( 	p_codsg		  IN	struct_info.codsg%TYPE,
				p_lib_codsg	  OUT	struct_info.libdsg%TYPE,
				p_message	  OUT 	VARCHAR2
				) IS

BEGIN
	-- On recherche de lib dans la table struct_info
	SELECT 	libdsg 
	INTO    p_lib_codsg
	FROM 	struct_info
	WHERE	codsg=p_codsg;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		pack_global.recuperer_message( 20311, NULL, NULL, NULL, p_message);
	WHEN OTHERS THEN
		raise_application_error( -20997, SQLERRM);

END get_lib_coddpg;


END pack_libelles;
/