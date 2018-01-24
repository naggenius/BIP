create or replace
PACKAGE PACK_URL_DOC IS
-- ==============================================================================
-- Nom     :    PACK_URL_DOC
-- Description:    Package de récupération du lien documentaire
-- ==============================================================================
-- Historique :
-- ------------
-- 18/11/2011 - S.GARCIA PPM 31216
-- ==============================================================================

/* procedure principale*/
PROCEDURE recup_lien_param_bip (p_lien_url IN VARCHAR2,
                                liendoc	OUT	VARCHAR2,
                                p_message		OUT 	VARCHAR2);


END PACK_URL_DOC;	
/
		
create or replace
PACKAGE BODY     PACK_URL_DOC IS				

PROCEDURE recup_lien_param_bip (
        p_lien_url IN VARCHAR2,
        liendoc	OUT	VARCHAR2,
				p_message		OUT 	VARCHAR2
				) IS

BEGIN
	-- On recherche du lien documentaire
	SELECT 	valeur
	INTO liendoc
	FROM 	ligne_param_bip
	WHERE	code_action = 'LIEN-URL'
	AND code_version = 'DOC-BIP'
	AND num_ligne = (SELECT MIN(num_ligne)
					 FROM ligne_param_bip
					 WHERE code_version = 'DOC-BIP' AND code_action = 'LIEN-URL' AND actif = 'O');
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		 p_message := 'lien documentaire indisponible, contacter la MO BIP';
	WHEN OTHERS THEN
		raise_application_error( -20997, SQLERRM);

END recup_lien_param_bip;

END PACK_URL_DOC;
/