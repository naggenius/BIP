-- -----------------
-- BIP 
-- -----------------
-- ---------------------------------------
-- Nom           Date         
-- ---------------------------------------
-- MM. CURE   22/11/2004    
-- ---------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table TMP_RESS_MASSE

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- Table TMP_RESS_MASSE
-- *****************************

into table BIP.TMP_RESS_MASSE
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
ID_LIGNE "BIP.SRESS_MASSE.nextval",
RPRENOM "trim(:RPRENOM)", 
RNOM "trim(:RNOM)", 
MATRICULE, 
DATARR , 
DATDEP, 
DPG, 
SOCCODE, 
COUTHT , 
QUALIF, 
DISPONIBILITE, 
CPIDENT
)
