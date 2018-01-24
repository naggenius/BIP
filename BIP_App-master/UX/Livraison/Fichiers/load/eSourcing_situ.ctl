-- -----------------
-- BIP - OALIA 
-- -----------------
-- Fichier de controle du chargement par
-- SQL*Loader du fichier provenant d OALIA contenant les donnees sur la situation des ressources 
-- ---------------------------------------
-- Nom           Date         
-- ---------------------------------------
-- MM. CURE   22/11/2004    
-- ---------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table TMP_SITUATION :

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- Table TMP_SITUATION 
-- *****************************

into table BIP.TMP_SITUATION
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
 ID_OALIA    ,
 MATRICULE   ,
 DATARR      Date "DDMMYYYY",       
 DATDEP      Date "DDMMYYYY",          
 DPG         ,          
 SOCCODE     ,   
COUTHT  ,       
 QUALIF      ,   
 CODE_PREST  ,   
 DISPONIBILITE ,  
 CPIDENT,
 SIREN 
)

