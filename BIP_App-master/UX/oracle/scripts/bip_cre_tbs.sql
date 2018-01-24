-- ============================================================
-- PROJET  - Script de creation des tablespaces BIP
-- Date : 02/10/2006	
-- Auteur :  A. SAKHRAOUI
-- Version:	1
--
-- Modifications :
--	
--
-- ============================================================

-- ========================================================
-- bip_cre_tbs.sql
-- ========================================================

CREATE TABLESPACE tbs_bip_ref_data DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_bip_ref_data_01.dbf'
SIZE 1.5G EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE tbs_bip_ref_idx DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_bip_ref_idx_01.dbf'
SIZE 750m EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE tbs_bip_his_data DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_his_data_01.dbf'
SIZE 500m EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE tbs_bip_his_idx DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_his_idx_01.dbf'
SIZE 150 m EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE tbs_bip_tmp_data DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_bip_tmp_data_01.dbf'
SIZE 250 m EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE tbs_bip_tmp_idx DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_bip_tmp_idx_01.dbf'
SIZE 100 m EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE tbs_bip_isa_data DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_bip_isa_data_01.dbf'
SIZE 500m EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE tbs_bip_isa_idx DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_bip_isa_idx_01.dbf'
SIZE 250m EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE tbs_bip_isac_data DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_isac_data_01.dbf'
SIZE 500m EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE tbs_bip_isac_idx DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_isac_idx_01.dbf'
SIZE 150 m EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE tbs_bip_fact_data DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_bip_fact_data_01.dbf'
SIZE 500 m EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE tbs_bip_fact_idx DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_bip_fact_idx_01.dbf'
SIZE 100 m EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE tbs_bip_batch_data DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_bip_batch_data_01.dbf'
SIZE 500 m EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE tbs_bip_batch_idx DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_bip_batch_idx_01.dbf'
SIZE 100 m EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;


CREATE TABLESPACE tbs_bip_lob_data DATAFILE '/produits/oracle/admin/bipdev10/disk1/bip_tbs_bip_lob_data_01.dbf'
SIZE 250 m EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64k SEGMENT SPACE MANAGEMENT AUTO;
