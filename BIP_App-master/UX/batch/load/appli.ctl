-- -----------------
-- BIP C1 
-- -----------------
-- Fichier de contrôle du chargement par
-- SQL*Loader du fichier des applications
-- ---------------------------------------
-- Nom           Date         
-- ---------------------------------------
-- MM. CURE   16/06/2004    
-- ---------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table TMP_APPLI :

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- PRESERVE est un mot clé ORACLE donc on le cite entre ""
-- Format date "RRMMDD" permet de traiter AN 2000
-- cf doc ORACLE SQL Language Reference Manual page 3-55 (tableau 3-16)
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- Table TMP_APPLI 
-- *****************************

into table BIP.TMP_APPLI
(
 AIRT    position( 1 ) char ( 5 ),
 ALIBEL       position( * ) char ( 50 ),
 ALIBCOURT  position( * ) char ( 20 ),
 AMNEMO    position( * ) char ( 5 ), 
 ACDAREG  position( * ) char ( 5 ),
 CODSG       position( * ) char ( 6  ),
 ACME        position( * ) char (  35 ),
 CLICODE    position( * ) char ( 5 ),
 AMOP       position( * ) char ( 35 ),
 CODGAPPLI    position( * ) char ( 5 ),
 AGAPPLI       position( * ) char ( 35 ),
 ADESCR1    position( * ) char ( 70 ),
 ADESCR2    position( * ) char ( 70 ),
 ADESCR3    position( * ) char ( 70 ),
 ADESCR4    position( * ) char ( 70 ),
 ADESCR5    position( * ) char ( 70 ),
 ADESCR6    position( * ) char ( 70 )
)

