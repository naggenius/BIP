-- -----------------
-- -----------------
-- Fichier de contrôle du chargement par
-- SQL*Loader du fichier personne.col
-- ---------------------------------------
-- Nom           Date         Livraison   
-- ---------------------------------------
-- BAA:22/09/2005
-- DDI:12/07/2006 Changement format n°Tel.
-- BSA 13/04/2012 Ajout du champ IGG
-- ---------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table tmp_personne :

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- PRESERVE est un mot clé ORACLE donc on le cite entre ""
-- Format date "RRMMDD" permet de traiter AN 2000
-- cf doc ORACLE SQL Language Reference Manual page 3-55 (tableau 3-16)
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- table TMP_PERSONNE
-- *****************************

-- MATRICULE  CHAR(7),
-- CIVILITE (5c),
-- RNOM (30c),
-- RPRENOM (15c),
-- IADRABR (25c),
-- BATIMENT (1c),  
-- ETAGE (2c),
-- BUREAU (3c),
-- ----------- RTEL (6c)            RTEL          position( 156:161 ) char(6)
-- RTEL (16c)
-- IGG (10c)            



into table TMP_PERSONNE
(
 MATRICULE     position( 1:7 ) char(7),
 CIVILITE      position( 8:11 ) char(4),
 RNOM          position( 12:41 ) char(30),
 RPRENOM       position( 52:66 ) char(15) , 
 IADRABR       position( 118:142 ) char(25),
 BATIMENT      position( 143:143 ) char(1),
 ETAGE         position( 144:145 ) char(2),
 BUREAU        position( 148:150 ) char(3),
 RTEL          position( 151:166 ) char(16),
 IGG           position( 174:184 ) char(16)
)

-- end of control file


