-- -----------------
-- BIP C1 
-- -----------------
-- Fichier de contrôle du chargement par
-- SQL*Loader du fichier Gershwin contenant les niveaux des SG
-- ---------------------------------------
-- Nom           Date         
-- ---------------------------------------
-- MM. CURE   27/10/2003    
-- ---------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table TMP_IMP_NIVEAU :

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- PRESERVE est un mot clé ORACLE donc on le cite entre ""
-- Format date "RRMMDD" permet de traiter AN 2000
-- cf doc ORACLE SQL Language Reference Manual page 3-55 (tableau 3-16)
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- Table TMP_IMP_NIVEAU 
-- *****************************

-- MATRICULE (7c)
-- |      NOM (30c)
-- |      |                             PPRENOM (20c)
-- |      |                             |                   NIVEAU (6c)
-- |      |                             |                   |     DATEMAJ (8c)
-- |      |                             |                   |     | 
-- |      |                             |                   |     |  
-- |      |                             |                   |     |   
-- |      |                             |                   |     |    
-- |      |                             |                   |     |     
-- |      |1         2         3        | 4        5        | 6   |   
-- 12345678901234567890123456789012345678901234567890123456789012345678901

into table BIP.TMP_IMP_NIVEAU
(
 MATRICULE    position( 1 ) char ( 7 ),
 NOM       position( * ) char ( 30 ),
 PRENOM    position( * ) char ( 20 ), 
 NIVEAU       position( * ) char ( 6  ),
 DATE_MAJ        position( * ) char (  8 )
)

