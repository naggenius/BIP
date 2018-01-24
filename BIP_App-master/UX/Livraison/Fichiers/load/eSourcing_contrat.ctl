-- -----------------
-- BIP - OALIA 
-- -----------------
-- Fichier de controle du chargement par
-- SQL*Loader du fichier provenant d OALIA contenant les donnees sur le contrat 
-- ---------------------------------------
-- Nom           Date         
-- ---------------------------------------
-- MM. CURE   22/11/2004    
-- ---------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table TMP_CONTRAT :

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- Table TMP_CONTRAT 
-- *****************************

into table BIP.TMP_CONTRAT
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
ID_OALIA    ,
NUMCONT     ,   
CAV         ,   
DPG         ,    
SOCCONT     ,   
CAGREMENT   ,
DATARR      Date "DDMMYYYY",      
OBJET       ,   
COMCODE     ,    
TYPEFACT    ,    
COUTOT     ,   
CHARESTI  ,   
DATDEB      Date "DDMMYYYY",   
DATFIN      Date "DDMMYYYY",
SIREN
)
