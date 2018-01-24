-- @C:\Honore\Prodec2\PlSql\Prodec4.sql;
-- SET SERVEROUTPUT ON SIZE 1000000;
--
-- Modifié le 02/03/2001 par NBM: gestion des habilitation suivant le périmètre MO de l'utilisateur
-- 22/02/2010 ABA : TD 938
--

CREATE OR REPLACE PACKAGE     pack_prodec4 IS
-----------------------------------------


------------------------------------------------------------------------------
-- Constantes globales
------------------------------------------------------------------------------

CST_PREM_CAR_ID_APPLI CONSTANT CHAR(1) := 'A';		-- 1er caractère identifiant Application (AIRT)
CST_PREM_CAR_ID_PROJ CONSTANT CHAR(1) := 'P';		-- 1er caractère identifiant Projet (ICPI)

------------------------------------------------------------------------------
-- Les Procédures
------------------------------------------------------------------------------


   -- ------------------------------------------------------------------------
   -- Nom        : verif_prodec4
   -- Auteur     : Equipe SOPRA
   -- Decription : Vérification des champs saisies dans la page WEB pour PRODEC4
   -- Paramètres : p_id_proj_ou_appli (IN)   CHAR(5) Ident appli (Axxxx)  ou Projet (Pxxxx)
   --
   -- Retour     : p_message (OUT) 	  message d'erreur
   --
   -- ------------------------------------------------------------------------
PROCEDURE verif_prodec4(
		     	p_nom_etat   		IN  VARCHAR2,
                 	p_param10	IN  VARCHAR2,
                    p_param12	IN  VARCHAR2,          -- CHAR(5)
			p_global 		IN  VARCHAR2,
                 	P_message 		OUT VARCHAR2
                 	);


END pack_prodec4;
/


CREATE OR REPLACE PACKAGE BODY     pack_prodec4 IS
----------------------------------------------

--****************************************************************************
-- Les Procédures
--****************************************************************************


   -- ------------------------------------------------------------------------
   -- Nom        : verif_prodec4
   -- Auteur     : Equipe SOPRA
   -- Decription : Vérification des champs saisies dans la page WEB pour PRODEC4
   -- Paramètres : p_id_proj_ou_appli (IN)   CHAR(5) Ident appli (Axxxx)  ou Projet (Pxxxx)
   --
   -- Retour     : p_message (OUT) 	  message d'erreur
   --
   -- ------------------------------------------------------------------------
PROCEDURE verif_prodec4(
		     	p_nom_etat   		IN  VARCHAR2,
                 	p_param10	IN  VARCHAR2,
                    p_param12	IN  VARCHAR2,        -- CHAR(5)
		 	p_global 		IN  VARCHAR2,
                 	P_message 		OUT VARCHAR2
                 	) IS

      	l_message   			VARCHAR2(1024) := '';
      	l_num_exception 		NUMBER;
	l_nuexc_id_appli_inexistant 	CONSTANT NUMBER := 20733;
	l_nuexc_id_proj_inexistant 	CONSTANT NUMBER := 20735;
	l_clicode 			varchar2(10);
	l_bool 				boolean;
BEGIN


  	IF ( (p_param10 <> null or p_param10 != ' ')) THEN

		-- Vérifier que le clicode de l'application appartient au périmètre MO de l'utilisateur
		BEGIN
			select clicode into l_clicode
			from application
			where airt=p_param10;

		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			pack_global.recuperer_message(20733, NULL, NULL, ' P_param10 ', l_message);
                       	RAISE_APPLICATION_ERROR(-20733, l_message);

		END;
    END IF;
	
    IF  ( (p_param12 <> null or p_param12 != ' '))  THEN
		-- Vérifier que le clicode du projet appartient au périmètre MO de l'utilisateur
		BEGIN
			select clicode into l_clicode
			from proj_info
			where icpi=p_param12;

		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				pack_global.recuperer_message(20735, NULL, NULL, ' P_param12 ', l_message);
                        	RAISE_APPLICATION_ERROR(-20735, l_message);

		END;

	END IF;

      p_message := l_message;

END  verif_prodec4;

END  pack_prodec4;
/


