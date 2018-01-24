-- ########################################################
-- Fichier de controle SQL*Loader
-- ------------------------------
-- Nom de table		:  TMP_CONTRAT_PRA
-- Desription		:  Chargement de la table tampon des contrats et
--			   lignes contrats en provenance de Prest@chat.
--
-- Type de fichier 	: UNIX
-- Séparateur      	: ";"
-- Type de chargement 	: TRUNCATE - suppression des donnees dans les tables avant import
--
-- HISTORIQUE 
-- ----------
-- 03/06/2012 - JM.LEDOYEN (Steria) - Fiche 1419 : Création
--
-- ########################################################

LOAD DATA
TRUNCATE
INTO TABLE TMP_CONTRAT_PRA
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(	
	TYPE_CTRA	,
	NUM_CONTRAT	,
	DATE_DEB_CTRA	,
	DATE_FIN_CTRA	,
	DPG		,
	FRAISENV 	,
	CA_IMPUTATION	,
	MNT_TOTAL_CTRA	,
	SIREN_FRS	,
	ID_RESSOURCE	,
	IGG_RESSOURCE	,
	DATE_DEB_RESSOURCE	"to_char(to_date(:DATE_DEB_RESSOURCE,'DD/MM/YYYY'),'DD/MM/YYYY')",
	DATE_FIN_RESSOURCE,
	CHARGE_ESTIMEE	,
	D_ARRIVEE_ACH	,
	D_SAISIE_ACH	,
	OBJET_CTRA	,
	COUT_PROPOSE	,
	LOCALISATION
)
-- =========================== FIN DE SCRIPT ========================