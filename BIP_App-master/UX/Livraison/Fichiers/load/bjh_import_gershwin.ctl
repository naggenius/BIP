-- -----------------
-- Refonte BIP-Maintenance
-- -----------------
-- Fichier de contrôle du chargement par
-- SQL*Loader du fichier de RSRH  Bouclage J/H
-- ---------------------------------------
-- Nom           Date         
-- ---------------------------------------
-- O. TONNELET   23/11/2000    
-- ---------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table BJH_EXTGIP :

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- PRESERVE est un mot clé ORACLE donc on le cite entre ""
-- Format date "RRMMDD" permet de traiter AN 2000
-- cf doc ORACLE SQL Language Reference Manual page 3-55 (tableau 3-16)
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- Table BJH_EXTGIP
-- *****************************

-- |MATRICULE (7c)
-- ||      GIPNOM (32c)
-- ||      |                               GIPPRENOM (32c)
-- ||      |                               |                               CODEMP (4c)
-- ||      |                               |                               |   GIPCA (6c)
-- ||      |                               |                               |   |     TEMPART (3c)
-- ||      |                               |                               |   |     |  MOIS (2c)
-- ||      |                               |                               |   |     |  | MOTIFABS (3c)
-- ||      |                               |                               |   |     |  | |  NBJOURS (3c)
-- ||      |                               |                               |   |     |  | |  |
-- ||      |1         2         3         4|        5         6         7  |   |  8  |  | | 9|   |
-- 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456

into table BIP.BJH_EXTGIP
(
 MATRICULE    position( 1 ) char ( 7 ),
 GIPNOM       position( * ) char ( 32 ),
 GIPPRENOM    position( * ) char ( 32 ), 
 CODEMP       position( * ) integer external (  4 ),
 GIPCA        position( * ) integer external (  5 ),
 TEMPART      position( * ) integer external (  3 ),
 MOIS         position( * ) integer external (  2 ),
 MOTIFABS     position( * ) char ( 6 ),
 INTJOUR      position( * ) decimal external ( 4 )
)

