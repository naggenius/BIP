-- ----------------------------------------------------------------------
-- pack_hab_historique PL/SQL
--
--
--
-- Gestion des habilitations pour les historiques (pour le menu PCM)
-- 
--
-- Quand       Qui   Nom                           Quoi
-- --------    ---   --------------------          ----------------------------------------
-- 02/07/2001  ODu   Olivier Duprey                Creation du package
-- 15/04/2002  ODu   Olivier Duprey		   Ajout de la fonction verif_prodecl_MO pour CNSLMENU/Client ME
-- 23/12/2011  BSA QC 1281
-- 16/04/2012  OEL QC 1391
-- ------------------------------------------------------------------------


CREATE OR REPLACE PACKAGE pack_hab_historique AS

-- ------------------------------------------------------------------------
--
-- Nom        : verif_prodeta
-- Auteur     : Olivier Duprey
-- Decription : Vérification des paramètres saisis pour l'etat $PRODETA
-- Paramètres :
--		p_mois_annee	IN		Mois et Année traitée
--		p_pid		IN		Code ligne bip
--		p_global	IN		informations globales sur la connexion
--		p_nom_schema	OUT
--		p_message	OUT		Message de sortie
--
-- Remarque :
--
-- ------------------------------------------------------------------------
	PROCEDURE verif_prodeta(
   		p_mois_annee	IN	VARCHAR2,		-- CHAR(7) (Format MM/AAAA)
		p_pid		IN	VARCHAR2,		-- VARCHAR2(4)
		p_global	IN	VARCHAR2,
		p_nom_schema	OUT	VARCHAR2,
		p_message	OUT	VARCHAR2
	);



-- ------------------------------------------------------------------------
--
-- Nom         : verif_prohist
-- Auteur      : Olivier Duprey
-- Description : Vérification des paramètres saisis pour l'etat $PROHIST
-- Paramètres  :
--              p_mois_annee   IN		Mois et Année traitée
--              p_factpid      IN		Code ligne bip
--		p_global       IN		informations globales sur la connexion
--              p_nom_schema  OUT
--              p_message     OUT		Message de sortie
--
-- Remarque :
--
-- ------------------------------------------------------------------------
PROCEDURE verif_prohist(
   		p_mois_annee	IN	VARCHAR2,		-- CHAR(7) (Format MM/AAAA)
		p_factpid	IN	VARCHAR2,		-- CHAR(3)
		p_global	IN	VARCHAR2,
		p_nom_schema	OUT	VARCHAR2,
		p_message	OUT	VARCHAR2
	);



-- ------------------------------------------------------------------------
--
-- Nom        : verif_reshist
-- Auteur     : Olivier Duprey
-- Decription : Vérification des paramètres saisis pour l'etat $PRODETA
-- Paramètres :
--              p_mois_annee   IN		Mois et Année traitée
--              p_coderess     IN		Code ressource
--		p_global       IN		informations globales sur la connexion
--              p_nom_schema  OUT
--              p_message     OUT		Message de sortie
--
-- Remarque :
--
-- ------------------------------------------------------------------------
	PROCEDURE verif_reshist(
		p_mois_annee	IN	VARCHAR2,		-- CHAR(7) (Format MM/AAAA)
		p_coderess	IN	VARCHAR2,		-- CHAR(5)
		p_global	IN	VARCHAR2,
		p_nom_schema	OUT	VARCHAR2,
		p_message	OUT	VARCHAR2
	);




-- ------------------------------------------------------------------------
-- Nom        : verif_prodecl (Prend en compte le concept d'historique)
-- Auteur     : Equipe SOPRA
-- Decription : Vérification des champs saisies dans la page WEB pour PRODECL
-- Paramètres :
--		p_nom_etat	IN	VARCHAR2,
--		p_mois_annee	IN	VARCHAR2,	-- CHAR(7) (Format MM/AAAA)
--		p_pid		IN	VARCHAR2,	-- CHAR(6)
--		p_global	IN	VARCHAR2,
--		p_nom_schema	OUT	VARCHAR2,
--		p_message	OUT	VARCHAR2
--
-- ------------------------------------------------------------------------
PROCEDURE verif_prodecl(
		p_nom_etat	IN	VARCHAR2,
		p_mois_annee	IN	VARCHAR2,	-- CHAR(7) (Format MM/AAAA)
		p_pid		IN	VARCHAR2,	-- CHAR(3)
		p_global	IN	VARCHAR2,
		p_nom_schema	OUT	VARCHAR2,
		p_message	OUT	VARCHAR2
	);



-- ------------------------------------------------------------------------
-- Nom        : verif_prodecl_MO (Prend en compte le concept d'historique)
-- Auteur     : Equipe SOPRA
-- Decription : Vérification des champs saisies dans la page WEB pour PRODECL dans le menu Client
-- Paramètres :
--		p_nom_etat	IN	VARCHAR2,
--		p_mois_annee	IN	VARCHAR2,	-- CHAR(7) (Format MM/AAAA)
--		p_pid		IN	VARCHAR2,	-- VARCHAR2(4)
--		p_global	IN	VARCHAR2,
--		p_nom_schema	OUT	VARCHAR2,
--		p_message	OUT	VARCHAR2
--
-- ------------------------------------------------------------------------
PROCEDURE verif_prodecl_MO(
		p_nom_etat	IN	VARCHAR2,
		p_mois_annee	IN	VARCHAR2,	-- CHAR(7) (Format MM/AAAA)
		p_pid		IN	VARCHAR2,	-- VARCHAR2(4)
		p_global	IN	VARCHAR2,
		p_nom_schema	OUT	VARCHAR2,
		p_message	OUT	VARCHAR2
	);
END pack_hab_historique ;
/


CREATE OR REPLACE PACKAGE BODY     pack_hab_historique AS

-------------------------------------------------------------------
--
------------------------------------------------------------------

-- ------------------------------------------------------------------------
--
-- Nom        : verif_PID_ME
-- Auteur     : O. Duprey
-- Decription : Vérification de presence de la ligne BIP dans le perimetre ME
--		de l'utilisateur
-- ------------------------------------------------------------------------
	FUNCTION verif_PID_ME(
		p_pid		IN	VARCHAR2,
		p_global	IN	VARCHAR2,
		p_focus		IN	VARCHAR2,
		p_message	OUT	VARCHAR2
	) RETURN BOOLEAN IS
		l_hab		BOOLEAN;
		l_dpg		situ_ress.codsg%TYPE;
		l_global	pack_global.GlobalData;
	BEGIN
		l_global:=pack_global.lire_globaldata(p_global);
		l_hab:=FALSE;
	   	BEGIN
	   		SELECT ligne_bip.codsg
	   			INTO l_dpg
	   			FROM ligne_bip
	   			WHERE ligne_bip.pid=p_pid
	   				AND ligne_bip.codsg IN (SELECT codsg
	   								FROM vue_dpg_perime
	   								WHERE INSTR(l_global.perime, vue_dpg_perime.codbddpg) > 0);
	   		l_hab:=TRUE;
	   	EXCEPTION
	   		WHEN no_data_found THEN
	   			l_hab:=FALSE;
	   		WHEN OTHERS THEN
	   			RAISE;
	   	END;

	   	IF NOT(l_hab) THEN
			pack_global.recuperer_message(20201, '%s1', p_pid , p_focus, p_message);
	   		RETURN FALSE;
	   	END IF;
	   	RETURN TRUE;
	END verif_PID_ME;

-- ------------------------------------------------------------------------
--
-- Nom        : verif_PID_ME
-- Auteur     : O. Duprey
-- Decription : Vérification de presence de la ligne BIP dans le perimetre ME
--		de l'utilisateur
-- OEL QC 1391 16/04/2012
-- ------------------------------------------------------------------------
	FUNCTION verif_PID_MO(
		p_pid		IN	VARCHAR2,
		p_global	IN	VARCHAR2,
		p_focus		IN	VARCHAR2,
		p_message	OUT	VARCHAR2
	) RETURN BOOLEAN IS
		l_hab		BOOLEAN;
		l_clicode	ligne_bip.clicode%TYPE;
		l_global	pack_global.GlobalData;
        l_menu VARCHAR2(25);
        l_perimo VARCHAR2(1000);
	BEGIN
		l_global:=pack_global.lire_globaldata(p_global);
        l_menu := l_global.menutil;

		if('MO'=l_menu)then
			l_perimo := l_global.perimcli;
		---else
		---	l_perimo := l_global.perimo;
		end if;

		l_hab:=FALSE;
        IF length(l_perimo) != 0 then
    	   	BEGIN
    	   		SELECT ligne_bip.clicode
    	   			INTO l_clicode
    	   			FROM ligne_bip
    	   			WHERE ligne_bip.pid=p_pid
    	   				AND ligne_bip.clicode IN (SELECT clicode
    	   								FROM vue_clicode_perimo
    	   								WHERE INSTR(l_perimo, vue_clicode_perimo.bdclicode) > 0);
    	   		l_hab:=TRUE;
    	   	EXCEPTION
    	   		WHEN no_data_found THEN
    	   			l_hab:=FALSE;
    	   		WHEN OTHERS THEN
    	   			RAISE;
    	   	END;
        END IF;

	   	IF NOT(l_hab) THEN
			pack_global.recuperer_message(20201, '%s1', p_pid , p_focus, p_message);
	   		RETURN FALSE;
	   	END IF;
	   	RETURN TRUE;
	END verif_PID_MO;

-- ------------------------------------------------------------------------
--
-- Nom        : verif_prodeta
-- Auteur     : O. Duprey
-- Decription : Vérification des paramètres saisis pour l'etat $PRODETA
--		avec controle des habilitations
-- ------------------------------------------------------------------------

	PROCEDURE verif_prodeta(
   		p_mois_annee	IN	VARCHAR2,		-- CHAR(7) (Format MM/AAAA)
		p_pid		IN	VARCHAR2,		-- VARCHAR2(4)
		p_global	IN	VARCHAR2,
		p_nom_schema	OUT	VARCHAR2,
		p_message	OUT	VARCHAR2
	) IS
	BEGIN
	IF (p_pid <> 'Tout') THEN
	---------------------------------------------------------------------------------------------
	-- (1) Vérification des habilitations
	---------------------------------------------------------------------------------------------
	IF NOT verif_PID_ME(p_pid, p_global, 'P_param8', p_message) THEN
		RETURN;
	END IF;
	END IF;
	---------------------------------------------------------------------------------------------
	-- (2) Vérifications autres
	---------------------------------------------------------------------------------------------
	pack_historique.verif_prodeta(p_mois_annee, '', p_pid, p_global, p_nom_schema, p_message);

   END verif_prodeta;



-- ------------------------------------------------------------------------
--
-- Nom        : verif_prohist
-- Auteur     : Olivier Duprey
-- Decription : Vérification des paramètres saisis pour l'etat $PROHIST
-- ------------------------------------------------------------------------
	PROCEDURE verif_prohist(
   		p_mois_annee	IN	VARCHAR2,		-- CHAR(7) (Format MM/AAAA)
		p_factpid	IN	VARCHAR2,		-- VARCHAR2(4)
		p_global	IN	VARCHAR2,
		p_nom_schema	OUT	VARCHAR2,
		p_message	OUT	VARCHAR2
	) IS
	BEGIN
		IF (p_factpid <> 'Tout') THEN
-- controle d'habilitation : la ligne BIP fait-elle partie du perimetre de l'utilisateur ?
		IF NOT verif_PID_ME(p_factpid, p_global, 'P_param8', p_message) THEN
			RETURN;
		END IF;
	END IF;

-- appel de la PROCEDURE standard historiue sans habilitation
		pack_historique.verif_prohist(p_mois_annee, '', p_factpid, p_global, p_nom_schema, p_message);

   END verif_prohist;



-- ------------------------------------------------------------------------
-- Nom        : verif_reshist
-- Auteur     : Olivier Duprey
-- Decription : Vérification des paramètres saisis pour l'etat $PRODETA
--		avec controle d'habilitations
-- ------------------------------------------------------------------------

	PROCEDURE verif_reshist(
		p_mois_annee	IN  VARCHAR2,		-- CHAR(7) (Format MM/AAAA)
		p_coderess	IN  VARCHAR2,		-- CHAR(5)
		p_global	IN  VARCHAR2,
		p_nom_schema	OUT  VARCHAR2,
		p_message	OUT  VARCHAR2
	) IS
		l_hab		BOOLEAN;
		l_dpg		situ_ress.codsg%TYPE;
		l_global	pack_global.GlobalData;
	   BEGIN
---------------------------------------------------------------------------------------------
-- (1) Vérification habilitation
-- On verifie que le ressource a la date de l'histo avait une situation dans le
-- perimetre ME du demandeur.
---------------------------------------------------------------------------------------------
		l_global:=pack_global.lire_globaldata(p_global);
		l_hab:=FALSE;
		IF (p_coderess <> 'Toute') THEN
	   	BEGIN
	   		SELECT situ_ress.codsg
	   			INTO l_dpg
	   			FROM situ_ress
	   			WHERE situ_ress.datsitu<=TO_DATE(p_mois_annee, 'mm/yyyy')
	   				AND ( situ_ress.datdep IS NULL OR situ_ress.datdep>=TO_DATE(p_mois_annee, 'mm/yyyy') )
	   				AND situ_ress.ident=p_coderess
	   				AND situ_ress.codsg IN (SELECT codsg
	   								FROM vue_dpg_perime
	   								WHERE INSTR(l_global.perime, vue_dpg_perime.codbddpg) > 0);
	   		l_hab:=TRUE;
	   	EXCEPTION
	   		WHEN no_data_found THEN
	   			l_hab:=FALSE;
	   		WHEN OTHERS THEN
	   			RAISE;
	   	END;

	   	IF NOT(l_hab) THEN
			pack_global.recuperer_message(20270, '%s1', p_coderess , 'P_param8', p_message);
	   		RETURN;
	   	END IF;
		END IF;
---------------------------------------------------------------------------------------------
-- (2) Autres controles
-- ON fait appel a la procedure standard des historiques sans habilitations
---------------------------------------------------------------------------------------------
	pack_historique.verif_reshist(p_mois_annee, '', p_coderess,p_global, p_nom_schema, p_message);



	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20997, SQLERRM);
	END verif_reshist;


-- ------------------------------------------------------------------------
-- Nom        : verif_prodecl (Prend en compte le concept d'historique)
-- Auteur     : Olivier Duprey
-- Decription : Vérification des champs saisies dans la page WEB pour PRODECL
--		avec controle des habilitations
-- ------------------------------------------------------------------------
	PROCEDURE verif_prodecl(
		p_nom_etat	IN	VARCHAR2,
		p_mois_annee	IN	VARCHAR2,	-- CHAR(7) (Format MM/AAAA)
		p_pid		IN	VARCHAR2,	-- VARCHAR2(4)
		p_global	IN	VARCHAR2,
		p_nom_schema	OUT	VARCHAR2,
		p_message	OUT	VARCHAR2
	) IS
	BEGIN
-- controle d'habilitation
	IF p_pid <> 'Tout' THEN
		IF NOT verif_PID_ME(p_pid, p_global, 'P_param9', p_message) THEN
			RETURN;
		END IF;
	END IF;

-- controles autres
		pack_historique.verif_prodecl(p_nom_etat, p_mois_annee, '', p_pid,p_global, p_nom_schema, p_message);
	END verif_prodecl;


-- ------------------------------------------------------------------------
-- Nom        : verif_prodecl_MO (Prend en compte le concept d'historique)
-- Auteur     : Olivier Duprey
-- Decription : Vérification des champs saisies dans la page WEB pour PRODECL
--		avec controle des habilitations pour CNSLMENU
-- ------------------------------------------------------------------------
	PROCEDURE verif_prodecl_MO(
		p_nom_etat	IN	VARCHAR2,
		p_mois_annee	IN	VARCHAR2,	-- CHAR(7) (Format MM/AAAA)
		p_pid		IN	VARCHAR2,	-- VARCHAR2(4)
		p_global	IN	VARCHAR2,
		p_nom_schema	OUT	VARCHAR2,
		p_message	OUT	VARCHAR2
	) IS
	BEGIN
-- controle d'habilitation
		IF NOT verif_PID_MO(p_pid, p_global, 'P_param9', p_message) THEN
			RETURN;
		END IF;
-- controles autres
		pack_historique.verif_prodecl(p_nom_etat, p_mois_annee, '', p_pid,p_global, p_nom_schema, p_message);
	END verif_prodecl_MO;
END pack_hab_historique ;
/


