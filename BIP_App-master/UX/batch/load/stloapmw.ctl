-- -----------------
-- Refonte BIP-SOPRA
-- -----------------
-- Fichier de contrôle du chargement par
-- SQL*Loader du fichier de la remontée PMW-BIP
-- ---------------------------------------
-- Nom           Date         Livraison   
-- ---------------------------------------
-- B. BODIN      08/12/1998   Prototype   
-- M. LECLERC    12/02/1999   Lot 1    
-- N. BACCAM     18/10/2001   Test des champs qui dépassent 100 000.00 j/h
-- MMC           19/04/2004   modif code bip sur 4    
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
LOAD DATA
TRUNCATE

-- *****************************
-- Segment A table PMW_LIGNE_BIP
-- *****************************

-- |PID (4c)
-- ||   PMWBIPVERS (2c)
-- ||   | PNAME (25c)
-- ||   | |                        PPROSTART (6c)
-- ||   | |                        |     PPROEND (6c)
-- ||   | |                        |     |     PCPMDATES (1c)
-- ||   | |                        |     |     |PMILE (1c)
-- ||   | |                        |     |     ||PPCTCMPL (3c)
-- ||   | |                        |     |     |||  PRESERVE (1c)
-- ||   | |                        |     |     |||  |
-- ||   | |  1         2         3 |     | 4   |||  |5
-- 123456789012345678901234567890123456789012345678901

-- suite table PMW_LIGNE_BIP
-- PASOFDATE (6c)
-- |     PCAPTSTART (6c)
-- |     |     PCAPTEND (6c)
-- |     |     |     FILLER (1c)
-- |     |     |     |P_JJ_CARRE (4c)
-- |     |     |     ||   P_MM_CARRE (4c)
-- |     |     |     ||   |   P_AA_ANNEE (4c)
-- |     |     |     ||   |   |       P_SAISIE (5c)
-- 5     |   6 |     ||7  |   |  8    |
-- 0123456789012345678901234567890123456789

into table BIP.PMW_LIGNE_BIP
when( 1 ) = 'A' (
 PID          position( 2 ) char (  4 ),
 PMWBIPVERS   position( * ) char (  2 ),
 PNAME        position( * ) char ( 25 ), 
 PPROSTART    position( * ) date "RRMMDD" nullif PPROSTART = blanks,
 PPROEND      position( * ) date "RRMMDD" nullif PPROEND   = blanks,
 PCPMDATES    position( * ) char ( 1 ),
 PMILE        position( * ) char ( 1 ),
 PPCTCMPL     position( * ) integer external ( 3 ),
 "PRESERVE"   position( * ) char ( 1 ),
 PASOFDATE    position( * ) date "RRMMDD" nullif PASOFDATE  = blanks,
 PCAPTSTART   position( * ) date "RRMMDD" nullif PCAPTSTART = blanks,
 PCAPTEND     position( * ) date "RRMMDD" nullif PCAPTEND   = blanks,
 FILLER       position( * ) char ( 1 ),
 P_JJ_CARRE   position( * ) integer external ( 4 ),
 P_MM_CARRE   position( * ) integer external ( 4 ),
 P_AA_CARRE   position( * ) integer external ( 4 ),
 P_SAISIE     position( 85 ) char ( 5 )
)

-- ******************************
-- SEGMENT 'G' table PMW_ACTIVITE
-- ******************************

-- |PID (4c)
-- ||   ACET (2c)
-- ||   | ACTA (2c)
-- ||   | | ACST (2c)
-- ||   | | | ALOT (6c)
-- ||   | | | |     AIET (6c)
-- ||   | | | |     |     AIST (6c)
-- ||   | | | |     |     |     ASTA (2c)
-- ||   | | | |     |     |     | ADEB (6c)
-- ||   | | | |     |     |     | |     AFIN (6c)
-- ||   | | | |     |     |     | |     |     ANDE (6c)
-- ||   | | | |     |     |     | |     |     |     ANFI (6c)
-- ||   | | | |     |     |     | |     |     |     |
-- ||   | | |1|     |  2  |     |3|     |  4  |     |5    
-- 123456789012345678901234567890123456789012345678901234

-- suite table PMW_ACTIVITE
--     ASNOM (15c)
--     |              APCP (3c)
--     |              |  ADUR (5c)
--     |              |  |
-- 5   |    6         7  |
-- 123456789012345678901234567

into table BIP.PMW_ACTIVITE
WHEN ( 1 ) = 'G' (
 PID       position( 2 ) char ( 4 ),
 ACET       position( * ) char ( 2 ),
 ACTA       position( * ) char ( 2 ),
 ACST       position( * ) char ( 2 ),
 ALOT       position( * ) char ( 6 ),
 AIET       position( * ) char ( 6 ) "DECODE(trim(:AIET), null, 'NO    ', :AIET)",
 AIST       position( * ) char ( 6 ),
 ASTA       position( * ) char ( 2 ),
 ADEB       position( * ) date "RRMMDD" nullif ADEB=blanks,
 AFIN       position( * ) date "RRMMDD" nullif AFIN=blanks,
 ANDE       position( * ) date "RRMMDD" nullif ANDE=blanks,
 ANFI       position( * ) date "RRMMDD" nullif ANFI=blanks,
 ASNOM      position( * ) char ( 15 ),
 APCP       position( * ) integer external ( 3 ),
 ADUR       position( * ) integer external ( 5 )
)

-- *****************************
-- SEGMENT 'I' table PMW_AFFECTA
-- *****************************

-- |PID (4c)
-- ||   TCET (2c)
-- ||   | TCTA (2c)
-- ||   | | TCST (2c)
-- ||   | | | TIRES (6c)
-- ||   | | | |     TPLAN (8c)
-- ||   | | | |     |       TACTU (8c)
-- ||   | | | |     |       |       TEST (8c)
-- ||   | | | |     |       |       |
-- ||   | | |1|     |  2    |    3  |      4
-- 1234567890123456789012345678901234567890

into table BIP.pmw_affecta
when ( 1 ) = 'I' (
 PID       position( 2 ) char  ( 4 ),
 TCET       position( * ) char  ( 2 ),
 TCTA       position( * ) char  ( 2 ),
 TCST       position( * ) char  ( 2 ),
 TIRES      position( * ) char  ( 6 ),
 TPLAN      position( * ) zoned ( 8, 2 ) "DECODE(LENGTH(:TPLAN),9,0,:TPLAN)" ,
 TACTU      position( * ) zoned ( 8, 2 ) "DECODE(LENGTH(:TACTU),9,0,:TACTU)" ,
 TEST       position( * ) zoned ( 8, 2 ) "DECODE(LENGTH(:TEST),9,0,:TEST)" 
)

-- *****************************
-- SEGMENT 'J' table PMW_CONSOMM
-- *****************************

-- |PID (4c)
-- ||   CCET (2c)
-- ||   | CCTA (2c)
-- ||   | | CCST (2c)
-- ||   | | | CIRES (6c)
-- ||   | | | |     CPCT (3c)
-- ||   | | | |     |  CDEB (6c)
-- ||   | | | |     |  |     CDUR (8c)
-- ||   | | | |     |  |     |       CUSAG (8c)
-- ||   | | | |     |  |     |       |       CHTYP (1c)
-- ||   | | | |     |  |     |       |       |
-- ||   | | |1|     |  2     |   3   |     4 |
-- 1234567890123456789012345678901234567890123

into table BIP.PMW_CONSOMM
WHEN ( 1 ) = 'J' (
 PID       position( 2 ) char ( 4 ),
 CCET       position( * ) char ( 2 ),
 CCTA       position( * ) char ( 2 ),
 CCST       position( * ) char ( 2 ),
 CIRES      position( * ) char ( 6 ),
 CPCT       position( * ) integer external ( 3 ),
 CDEB       position( * ) date "RRMMDD",
 CDUR       position( * ) integer external ( 8 ),
 CUSAG      position( * ) zoned ( 8, 2 ) "DECODE(LENGTH(:CUSAG),9,0,:CUSAG)" ,
 CHTYP      position( * ) char ( 1 )
)

-- end of control file


