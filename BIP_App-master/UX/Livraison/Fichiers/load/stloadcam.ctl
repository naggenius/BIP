-- -----------------
-- Refonte BIP-SOPRA
-- -----------------
-- Fichier de contrôle du chargement par
-- SQL*Loader du fichier de la remontée du fichier DPA
-- ---------------------------------------
-- Nom           Date         Livraison   
-- ---------------------------------------
-- J.F. MOUTON   30/07/1999                  
-- ---------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table charge_camo :

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- PRESERVE est un mot clé ORACLE donc on le cite entre ""
-- Format date "RRMMDD" permet de traiter AN 2000
-- cf doc ORACLE SQL Language Reference Manual page 3-55 (tableau 3-16)
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- table CHARGE_CAMO
-- *****************************

-- XCODCAMO (10c)
-- XCLIBCA (35c)
-- XCODNIV (3c)
-- XDATEOUV (8c)
-- XDATEFER (8c)
-- Filler (20c)
-- XCANIV6 (10c)
-- XCANIV5 (10c)
-- XCANIV4 (10c)
-- XCANIV3 (10c)
-- XCANIV2 (10c)
-- XCANIV1 (10)
-- Filler (6c)
-- XCLIBRCA (24c)
-- Filler (11c)
-- XCDFAIN (1c)

into table CHARGE_CAMO
(
 XCODCAMO      position( 1:10 ) char(10),
 XCLIBCA       position( 11:45 ) char (35),
 XCODNIV       position( 46:48 ) char (3) , 
 XCDATEOUVE    position( 49:56 ) date "YYYYMMDD" nullif XCDATEOUVE = '00000000',
 XCDATEFERM    position( 57:64 ) date "YYYYMMDD" nullif XCDATEFERM = '00000000',
 XCANIV3       position( 85:94 )  char(10),
 XCANIV2       position( 95:104 ) char(10),
 XCANIV1       position( 105:114 )char(10),
 XCLIBRCA      position( 131:154 ) char (24),
 XCANIV4       position( 155:164 ) char (10),
 XCDFAIN       position( 126:126 ) char (1),
 XCANIV5       position( 75:84 )char(10),
 XCANIV6       position( 65:74 )char(10)
)

-- end of control file


