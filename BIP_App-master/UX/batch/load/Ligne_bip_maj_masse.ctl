-- -----------------
-- BIP 
-- -----------------
-- ---------------------------------------
-- Nom           Date         
-- ---------------------------------------
-- ABA   28/01/2010
-- ---------------------------------------
-- Modifie le 04/04/2012 : BSA - QC 1382
-- Fichier entree au format ASCII fixe
-- Pour la table LIGNE_BIP_MAJ_MASSE

-- SEL   29/05/2014
-- ---------------------------------------
-- Ajout colonne DBS : PPM 58143


-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- Table LIGNE_BIP_MAJ_MASSE
-- *****************************

into table BIP.LIGNE_BIP_MAJ_MASSE
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
PID "trim(:pid)", 
PNOM "trim(:pnom)",
TYPPROJ,
PDATDEBPRE "trunc(to_date(:PDATDEBPRE,'MM/YYYY'),'MONTH')",
ARCTYPE,
TOPTRI,
CODPSPE,
AIRT,
ICPI,
CODSG,
PCPI,
CLICODE,
CLICODE_OPER,
CODCAMO,
PNMOUVRA,
METIER,
POBJET char(304),
DPCODE,
PZONE,
DBS,
ANNEE,
PROP_FOUR,
DATEFERM, 
CODSG_NEW,
ANNEE_CIBLE,
CAS
)
