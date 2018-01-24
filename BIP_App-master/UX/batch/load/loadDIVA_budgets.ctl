-- -----------------
-- BIP - DIVA 
-- -----------------
-- Fichier de controle du chargement par
-- SQL*Loader du fichier provenant de DIVA contenant les budgets proposes et reestimes
-- ---------------------------------------
-- Nom           Date         
-- ---------------------------------------
-- David DEDIEU   16/08/2006
-- ---------------------------------------

-- Fichier entree au format ASCII variable délimité par ";"
-- Pour la table TMP_DIVA_BUDGETS :

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- Table TMP_DIVA_BUDGETS 
-- *****************************

into table BIP.TMP_DIVA_BUDGETS
FIELDS TERMINATED BY ';'
(
PID		,
PNOM		,   
ANNEE		,  
BPMONTME	,
BPMONTME1	,
REESTIME
)
