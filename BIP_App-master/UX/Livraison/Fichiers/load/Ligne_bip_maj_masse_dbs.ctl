-- -----------------
-- BIP 
-- -----------------
-- ---------------------------------------
-- Nom           Date         
-- ---------------------------------------
-- ABN   13/02/2014
-- ---------------------------------------
-- Cree le 13/02/2014
-- Fichier entree au format ASCII fixe
-- Pour la table LIGNE_BIP_MAJ_MASSE_DBS

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- Table LIGNE_BIP_MAJ_MASSE_DBS
-- *****************************

into table BIP.LIGNE_BIP_MAJ_MASSE_DBS
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
POBJET,
DPCODE,
PZONE,
SOUS_TYPE,
ANNEE,
PROP_FOUR,
DATEFERM, 
CODSG_NEW,
ANNEE_CIBLE,
CAS
)
