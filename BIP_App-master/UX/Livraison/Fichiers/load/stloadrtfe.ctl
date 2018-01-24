-- -----------------
-- -----------------
-- Fichier de contrôle du chargement par
-- SQL*Loader du fichier export_RTFE.yyyymmdd.csv
-- ----------------------------------------------
-- Nom           Date         Livraison   
-- ----------------------------------------------
-- BAA 	    17/10/2005                  
-- ----------------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour la table tmp_rtfe:

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- PRESERVE est un mot clé ORACLE donc on le cite entre ""
-- Format date "RRMMDD" permet de traiter AN 2000
-- cf doc ORACLE SQL Language Reference Manual page 3-55 (tableau 3-16)
-- --------------------------------------------------------------------
LOAD DATA
TRUNCATE

-- *****************************
-- table TMP_RTFE
-- *****************************

INTO TABLE TMP_RTFE
FIELDS TERMINATED BY ','
TRAILING NULLCOLS
(
	sgZoneId,
	cn,
	sgCustomId1,
	sn,
	givenname,
	sgLegalStatus,
	sgRtfeId,
	id,
	sgGroupId,
	C,
	L,
	mail,
	sgMailType,
	telephoneNumber,
	sgCompany,
	sgServiceCode,
	sgServiceName,
	sgJob,
	sgStructure,
	buildingName,
	roomNumber,
	postalAdress,
	postalCode,
	fax "SUBSTR(:fax, length(:fax) - 19)",
	sgActivity,
	sgActivitycenter,
	--FAD PPM 63956 : Ajout de l'attribut IGG
	IGG,
	--FAD PPM 63956 : Fin
	sgutiroleatt1 CHAR(4000),
	sgutiroleatt2 CHAR(4000),
	sgutiroleatt3 CHAR(4000),
	sgutiroleatt4 CHAR(4000),
	sgutiroleatt5 CHAR(4000),
	sgutiroleatt6 CHAR(4000),
	sgutiroleatt7 CHAR(4000)
)

--(sgZoneId,cn,sgCustomId1,sn,givenname,sgLegalStatus,sgRtfeId,id,sgGroupId,C,L,mail,sgMailType,telephoneNumber,sgCompany,sgServiceCode,sgServiceName,sgJob,
--sgStructure,buildingName,roomNumber,postalAdress,postalCode,fax,sgActivity,sgActivitycenter,
--sgutiroleatt1,sgutiroleatt2,sgutiroleatt3,sgutiroleatt4,sgutiroleatt5,sgutiroleatt6,sgutiroleatt7)

--sgutiroleatt2,sgutiroleatt3,sgutiroleatt4,sgutiroleatt5,sgutiroleatt6,sgutiroleatt7
-- end of control file


