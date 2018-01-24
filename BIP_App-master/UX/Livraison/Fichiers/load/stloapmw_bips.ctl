-- ------------------------------------------------
-- Samih EL BOUZIDI		09/04/2015		 PPM 60612
-- ------------------------------------------------
-- Fichier de contrôle du chargement par
-- SQL*Loader du fichier de la remontée PMW-BIP
-- ---------------------------------------

-- Fichier entree au format ASCII fixe
-- Pour les tables PMW :
--  * PMW_LIGNE_BIP
--  * PMW_ACTIVITE
--  * PMW_AFFECTA
--  * PMW_CONSOMM

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- PRESERVE est un mot clé ORACLE donc on le cite entre ""
-- Format date "RRMMDD" permet de traiter AN 2000
-- cf doc ORACLE SQL Language Reference Manual page 3-55 (tableau 3-16)
-- --------------------------------------------------------------------
--- *****************************
-- Segment A table PMW_LIGNE_BIP
-- *****************************


------------------------------------------------------------
-- SQL-Loader Basic Control File
------------------------------------------------------------
OPTIONS (SKIP=1)
load data
APPEND
------------------------------------------------------------
-- BIPS
------------------------------------------------------------
into table   BIP.PMW_BIPS
when (1) = '#' and (2:4) <> 'FIN'
fields terminated by ";"       
optionally enclosed by '"' 
TRAILING NULLCOLS
  ( 
	LIGNEBIPCODE 	POSITION(2)		,
	LIGNEBIPCLE			,
	STRUCTUREACTION		,
	ETAPENUM	"LPAD(:ETAPENUM,2,'0')"				,
	ETAPETYPE				,
	ETAPELIBEL			,
	TACHENUM	"LPAD(:TACHENUM,2,'0')"				,
	TACHELIBEL			,
	STACHENUM	"LPAD(:STACHENUM,2,'0')"			,
	STACHETYPE			,
	STACHELIBEL			,
	STACHEINITDEBDATE		,
	STACHEINITFINDATE		,
	STACHEREVDEBDATE		,
	STACHEREVFINDATE		,
	STACHESTATUT			,
	STACHEDUREE			,
	STACHEPARAMLOCAL		,
	RESSBIPCODE	"TRIM(:RESSBIPCODE)"			,
	RESSBIPNOM			,
	CONSODEBDATE			,
	CONSOFINDATE			,
	CONSOQTE				,
	PROVENANCE	,
	PRIORITE 	"(select decode(
                      (select 'O' from dual where NOT EXISTS (select * from isac_etape where pid=:LIGNEBIPCODE)),
                      'O',
                      'P2',
                      'P3') from dual)"
  )

-- end of control file


