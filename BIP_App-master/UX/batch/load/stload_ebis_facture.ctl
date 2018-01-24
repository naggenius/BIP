-- -----------------
-- -----------------
-- Fichier de contrôle du chargement par
-- SQL*Loader du fichier import_EBIS_FACTURE.yyyymmdd.csv
-- ----------------------------------------------
-- Nom           Date         Livraison   
-- ----------------------------------------------
-- BAA 	    19/03/2007                  
-- Julio Alves : rajout  CD_REFERENTIEL
-- JAL 15/04/2008 : test avec Append à la place TRUNCATE OK
-- ABA 05/05/2009 : TD 737 contrat 27+3
-- -----------------------------------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table tmp_ebis_facture:

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- PRESERVE est un mot clé ORACLE donc on le cite entre ""
-- Format date "RRMMDD" permet de traiter AN 2000
-- cf doc ORACLE SQL Language Reference Manual page 3-55 (tableau 3-16)
-- --------------------------------------------------------------------
LOAD DATA
Append

-- *****************************
-- table TMP_EBIS_FACTURE
-- *****************************

INTO TABLE EBIS_IMPORT_FACTURE
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(NUMFACT, TYPFACT, DATFACT, NUMCONTCAV, CD_REFERENTIEL, CD_EXPENSE, NUM_EXPENSE, FMONTHT, FMONTTTC,
 DATE_COMPTA, LNUM, IDENT, LMONTHT, LMOISPREST, CUSAG_EXPENSE, TOPPOST  
)