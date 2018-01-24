-- -----------------
-- BIP 
-- -----------------
-- ---------------------------------------
-- Nom           Date         
-- ---------------------------------------
-- ABA   28/07/2011
-- ---------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table LIGNE_BIP_MAJ_MASSE_TYPO

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- Table LIGNE_BIP_MAJ_MASSE_TYPO
-- *****************************

into table BIP.LIGNE_BIP_MAJ_MASSE_TYPO
FIELDS TERMINATED BY ';'
(
PID "trim(:pid)", 
CODSG, 
TYPPROJ,
ARCTYPE
)
