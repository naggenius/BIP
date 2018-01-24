-- -----------------
-- BIP - OALIA 
-- -----------------
-- Fichier de controle du chargement par
-- SQL*Loader du fichier provenant d OALIA contenant les donnees sur la ligne contrat 
-- ---------------------------------------
-- Nom           Date         
-- ---------------------------------------
-- MM. CURE   22/11/2004    
-- ---------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table TMP_LIGNE_CONT :

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- Table TMP_LIGNE_CONT 
-- *****************************

into table BIP.TMP_LIGNE_CONT
FIELDS TERMINATED BY ';'
(
ID_OALIA    ,
IDENT       ,  
NUMCONT     ,
CAV         ,
SOCCONT     , 
COUTHT     ,    
DATDEB      Date "DDMMYYYY",   
DATFIN      Date "DDMMYYYY",   
PROPORIG      ,
QUALIF      
)
