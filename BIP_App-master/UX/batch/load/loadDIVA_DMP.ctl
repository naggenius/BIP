-- -----------------
-- BIP - DIVA 
-- -----------------
-- Fichier de controle du chargement par
-- SQL*Loader du fichier provenant de DIVA contenant les DMP 
-- ---------------------------------------
-- Nom           Date         
-- ---------------------------------------
-- AABBAR ZAHIRA   01/09/2015
-- ---------------------------------------

-- Fichier entree au format ASCII variable délimité par ";"
-- Pour la table TMP_RESEAUXFRANCE :

-- --------------------------------------------------------------------
-- TRUNCATE => suppression des donnees dans les tables avant import
-- --------------------------------------------------------------------
OPTIONS(skip=1)
LOAD DATA 
TRUNCATE

-- *****************************
-- Table TMP_RESEAUXFRANCE 
-- *****************************

into table BIP.TMP_ReseauxFrance
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
DMPNUM  
, DMPLIBEL   
, EXNUMDEM   
, DDETYPE   
, DPCODE   
, DPCOPICODE   
, PROJCODE   
, CODEDPGPOLE   
, STATDECIS   
, STATAGR   
, STATEXE   
, ENVBUD   
, TXFINEXT  
, DBS   
, NATDEM   
, AGREGN1   
, AGREGN2   
, PORTMOA   
, ANNEEENCOURS   
,ACC_LIB_MONT01	  , Acc_Mont01	  
,ACC_LIB_MONT02	  , Acc_Mont02	  
,ACC_LIB_MONT03   , Acc_Mont03	  
,ACC_LIB_MONT04	  , Acc_Mont04	  
,ACC_LIB_MONT05	  , Acc_Mont05	  
,ACC_LIB_MONT06	  , Acc_Mont06	  
,ACC_LIB_MONT07	  , Acc_Mont07	  
,ACC_LIB_MONT08	  , Acc_Mont08	  
,ACC_LIB_MONT09	  , Acc_Mont09	  
,ACC_LIB_MONT10	  , Acc_Mont10	  
,ACC_LIB_MONT11	  , Acc_Mont11	  
,ACC_LIB_MONT12	  , Acc_Mont12	  
,ACC_LIB_MONT13	  , Acc_Mont13	  
,ACC_LIB_MONT14	  , Acc_Mont14	  
,ACC_LIB_MONT15	  , Acc_Mont15	  
,ACC_LIB_MONT16	  , Acc_Mont16	  
,ACC_LIB_MONT17	  , Acc_Mont17	  
,ACC_LIB_MONT18	  , Acc_Mont18	  
,ACC_LIB_MONT19	  , Acc_Mont19	  
,ACC_LIB_MONT20	  , Acc_Mont20	  
,ACC_LIB_MONT21	  , Acc_Mont21	  
,ACC_LIB_MONT22	  , Acc_Mont22	  
,ACC_LIB_MONT23	  , Acc_Mont23	  
,ACC_LIB_MONT24	  , Acc_Mont24	  
,ACC_LIB_MONT25	  , Acc_Mont25	  
,ACC_LIB_MONT26	  , Acc_Mont26	  
,ACC_LIB_MONT27	  , Acc_Mont27	  
,ACC_LIB_MONT28	  , Acc_Mont28	  
,ACC_LIB_MONT29	  , Acc_Mont29	  
,ACC_LIB_MONT30	  , Acc_Mont30	  
,ACC_LIB_MONT31	  , Acc_Mont31	  
,ACC_LIB_MONT32	  , Acc_Mont32	  
,ACC_LIB_MONT33	  , Acc_Mont33	  
,ACC_LIB_MONT34	  , Acc_Mont34	  
,ACC_LIB_MONT35	  , Acc_Mont35	  
,ACC_LIB_MONT36	  , Acc_Mont36	  
,ACC_LIB_MONT37	  , Acc_Mont37	  
,ACC_LIB_MONT38	  , Acc_Mont38	  
,ACC_LIB_MONT39	  , Acc_Mont39	  
,ACC_LIB_MONT40	  , Acc_Mont40	  
,ACC_LIB_MONT41	  , Acc_Mont41	  
,ACC_LIB_MONT42	  , Acc_Mont42	  
,ACC_LIB_MONT43	  , Acc_Mont43	  
,ACC_LIB_MONT44	  , Acc_Mont44	  
,ACC_LIB_MONT45	  , Acc_Mont45	  
,ACC_LIB_MONT46	  , Acc_Mont46	  
,ACC_LIB_MONT47	  , Acc_Mont47	  
,ACC_LIB_MONT48	  , Acc_Mont48	  
,ACC_LIB_MONT49	  , Acc_Mont49	  
,ACC_LIB_MONT50	  , Acc_Mont50	  
,ACC_LIB_MONT51	  , Acc_Mont51	  
,ACC_LIB_MONT52	  , Acc_Mont52	  
,ACC_LIB_MONT53	  , Acc_Mont53	  
,ACC_LIB_MONT54	  , Acc_Mont54	  
,ACC_LIB_MONT55	  , Acc_Mont55	  
,ACC_LIB_MONT56	  , Acc_Mont56	  
,ACC_LIB_MONT57	  , Acc_Mont57	  
,ACC_LIB_MONT58	  , Acc_Mont58	  
,ACC_LIB_MONT59	  , Acc_Mont59	  
,ACC_LIB_MONT60	  , Acc_Mont60	  
,ACC_LIB_MONT61	  , Acc_Mont61	  
,ACC_LIB_MONT62	  , Acc_Mont62	  
,ACC_LIB_MONT63	  , Acc_Mont63	  
,ACC_LIB_MONT64	  , Acc_Mont64	  
,ACC_LIB_MONT65	  , Acc_Mont65	  
,ACC_LIB_MONT66	  , Acc_Mont66	  
,ACC_LIB_MONT67	  , Acc_Mont67	  
,ACC_LIB_MONT68	  , Acc_Mont68	  
,ACC_LIB_MONT69	  , Acc_Mont69	  
,ACC_LIB_MONT70	  , Acc_Mont70	  
,ACC_LIB_MONT71	  , Acc_Mont71	  
,ACC_LIB_MONT72	  , Acc_Mont72	  
,ACC_LIB_MONT73	  , Acc_Mont73	  
,ACC_LIB_MONT74	  , Acc_Mont74	  
,ACC_LIB_MONT75	  , Acc_Mont75	  
,ACC_LIB_MONT76	  , Acc_Mont76	  
,ACC_LIB_MONT77	  , Acc_Mont77	  
,ACC_LIB_MONT78	  , Acc_Mont78	  
,ACC_LIB_MONT79	  , Acc_Mont79	  
,ACC_LIB_MONT80	  , Acc_Mont80	  

)
