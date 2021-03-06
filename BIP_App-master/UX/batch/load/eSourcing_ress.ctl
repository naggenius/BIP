-- -----------------
-- BIP - OALIA 
-- -----------------
-- Fichier de controle du chargement par
-- SQL*Loader du fichier provenant d OALIA contenant les donnees sur les ressources 
-- ---------------------------------------
-- Nom           Date         
-- ---------------------------------------
-- MM. CURE   22/11/2004    
-- ---------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table TMP_RESSOURCE :

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- Table TMP_RESSOURCE 
-- *****************************

into table BIP.TMP_RESSOURCE
FIELDS TERMINATED BY ';'
(
 ID_OALIA    ,
 MATRICULE   ,
 RNOM        ,
 RPRENOM    
)

