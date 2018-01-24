-- Nom           Date         Livraison
-- ---------------------------------------
-- O. Toonelet   09/07/2002 
-- ---------------------------------------
-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- --------------------------------------------------------------------
-- *****************************
-- imp_oscar_tmp
-- *****************************
LOAD DATA
TRUNCATE
INTO TABLE imp_oscar_tmp
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(PID ,
 LIBELLE ,
 RESP_MO ,
 CODE_MO ,
 NOTIFIE ,
 OBJECTIF_MO,
 PROPO_MO_N1
)
