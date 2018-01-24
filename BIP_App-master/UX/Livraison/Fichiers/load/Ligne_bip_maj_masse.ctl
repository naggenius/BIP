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
PID "SUBSTR(trim(:pid),1,4)", 
PNOM "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:PNOM, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,30)",
TYPPROJ "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:TYPPROJ, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,2)",
PDATDEBPRE "trunc(to_date(:PDATDEBPRE,'MM/YYYY'),'MONTH')",
ARCTYPE "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:ARCTYPE, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,3)",
TOPTRI "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:TOPTRI, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,3)",
CODPSPE "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:CODPSPE, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,1)",
AIRT "UPPER(SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:AIRT, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,5))",
ICPI "UPPER(SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:ICPI, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,5))",
CODSG "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:CODSG, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,7)",
PCPI "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:PCPI, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,5)",
CLICODE "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:CLICODE, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,5)",
CLICODE_OPER "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:CLICODE_OPER, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,5)",
CODCAMO "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:CODCAMO, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,6)",
PNMOUVRA "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:PNMOUVRA, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,15)",
METIER "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:METIER, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,3)",
POBJET char(304) "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:POBJET, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,304)",
DPCODE "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:DPCODE, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,5)",
PZONE "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:PZONE, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,20)",
LINEAXISBUSINESS1 "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:LINEAXISBUSINESS1, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,12)",
LINEAXISBUSINESS2 "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:LINEAXISBUSINESS2, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,12)",
DBS "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:DBS, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,3)",
ANNEE "SUBSTR(TRIM(:ANNEE),1,4)",
PROP_FOUR "SUBSTR(TRIM(:PROP_FOUR),1,18)",
DATEFERM, 
CODSG_NEW "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:CODSG_NEW, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,7)",
ANNEE_CIBLE "SUBSTR(TRIM(:ANNEE_CIBLE),1,4)",
CAS "SUBSTR(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(:CAS, '[^A-Za-z0-9 ]', ' '),' {2,}', ' ')),1,2)"
)
