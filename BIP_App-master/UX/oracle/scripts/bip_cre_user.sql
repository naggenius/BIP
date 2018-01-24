-- ============================================================
-- PROJET  - Script de creation des utilisateurs
-- Date : 02/10/2006	
-- Auteur :  A. SAKHRAOUI
-- Version:	1
--
-- Modifications :
--	V
--
-- ============================================================

-- ========================================================
-- bip_cre_user.sql
-- ========================================================

-- ============================================================
--   USER : BIP (Proprietaire du schema) 

-- ============================================================
-- ========================================================
--  Suppression des utilisateurs
-- ========================================================
DROP USER bip CASCADE
/
-- ========================================================
--  Creation des utilisateurs
-- ========================================================
CREATE USER bip
IDENTIFIED BY bip
DEFAULT TABLESPACE tbs_bip_data
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON tbs_alertes_128k_da
QUOTA UNLIMITED ON tbs_alertes_1m_da
QUOTA UNLIMITED ON tbs_alertes_8m_da
QUOTA UNLIMITED ON tbs_alertes_64m_da
QUOTA UNLIMITED ON tbs_alertes_512m_da
QUOTA UNLIMITED ON tbs_alertes_lob
QUOTA UNLIMITED ON tbs_alertes_128k_ix
QUOTA UNLIMITED ON tbs_alertes_1m_ix
QUOTA UNLIMITED ON tbs_alertes_8m_ix
QUOTA UNLIMITED ON tbs_alertes_64m_ix
QUOTA UNLIMITED ON tbs_alertes_512m_ix
/
-- ============================================================
--   Assignation des roles
-- ============================================================
GRANT CONNECT TO bip
/
GRANT RESOURCE TO bip
/