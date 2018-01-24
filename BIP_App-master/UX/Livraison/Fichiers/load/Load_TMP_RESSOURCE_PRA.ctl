-- ########################################################
-- Fichier de controle SQL*Loader
-- --------------------------------------------------------
-- Nom de table		:  TMP_RESSOURCE_PRA
-- Desription		:  Chargement de la table tampon des ressources et
--			   des situations en provenance de Prest@chat.
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
INTO TABLE TMP_RESSOURCE_PRA
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(	TYPE_CTRA,
	LOCALISATION,
	DPG,
	FRAISENV,
	CA_IMPUTATION,
	TAUX,
	METIER,
	COMPLEXITE,
	MATRICULE_DO,
	IGG_DO,
	SIREN_FRS,
	ID_RESSOURCE,
	IGG_RESSOURCE,
	NOM_RESSOURCE,
	PRENOM_RESSOURCE,
	DATE_DEB_RESSOURCE	"to_char(to_date(:DATE_DEB_RESSOURCE,'DD/MM/YYYY'),'DD/MM/YYYY')",
	DATE_FIN_RESSOURCE,
	DISPONIBILITE,
	MNT_MENSUEL,
	COUT_TOTAL
)
-- =========================== FIN DE SCRIPT ========================