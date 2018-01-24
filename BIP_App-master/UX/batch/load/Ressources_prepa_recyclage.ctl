-- -----------------
-- BIP 
-- -----------------
-- ---------------------------------------
-- Trigramme   Date         
-- ---------------------------------------
-- RBO   28/05/2013
-- ---------------------------------------

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- Table RESSOURCES_PREPA_RECYCLAGE 
-- *****************************

into table BIP.RESSOURCES_PREPA_RECYCLAGE 
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
IDENT "trim(:IDENT)", 
DATE_AUPLUSTOT "to_date(:DATE_AUPLUSTOT,'DD-MM-YYYY')"
)
