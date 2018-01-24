-- -----------------
-- -----------------
-- Fichier de contrôle du chargement par
-- SQL*Loader du fichier immeuble.col
-- ---------------------------------------
-- Nom           Date         Livraison   
-- ---------------------------------------
-- BAA 	    22/09/2005                  
-- ---------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table tmp_immeuble:

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- PRESERVE est un mot clé ORACLE donc on le cite entre ""
-- Format date "RRMMDD" permet de traiter AN 2000
-- cf doc ORACLE SQL Language Reference Manual page 3-55 (tableau 3-16)
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- table TMP_IMMEUBLE
-- *****************************

-- ICODIMM  (5c)
-- IADRABR  (25c)
-- FLAGLOCK (7n)


into table TMP_IMMEUBLE
(
 ICODIMM      position( 2:6 )   char(5),
 IADRABR      position( 7:31 )  char(25),
 FLAGLOCK     position( 32:32 ) INTEGER EXTERNAL(1)
)

-- end of control file


