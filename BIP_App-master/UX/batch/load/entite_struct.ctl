-- Fichier de contrôle du chargement par
-- SQL*Loader du fichier de la remontée du fichier ES 
-- ---------------------------------------
-- Nom           Date         Livraison   
-- ---------------------------------------
-- MMC        04/2004                  
-- ---------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table  entite_structure:

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- PRESERVE est un mot clé ORACLE donc on le cite entre ""
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- table CHARGE_ES
--IDELST 5
--CODCAMO 5
--CDTYES 3c
--LILOES 24c
--LICOES 35c

into table CHARGE_ES
(
 IDELST      position( 1:5 ) char(5),
 CODCAMO       position( 6:10 ) char(5),
 CDTYES       position( 11:13 ) char (3),
 LILOES       position( 14:37 )  char(24),
 LICOES       position( 38:67 ) char(30)
)


-- end of control file


