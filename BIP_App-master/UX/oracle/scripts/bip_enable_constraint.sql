-- ============================================================
-- PROJET  - Script de activation des contraintes
-- Date : 02/10/2006	
-- Auteur :  A. SAKHRAOUI
-- Version:	1
--
-- Modifications :
--	
--
-- ============================================================

-- ========================================================
-- bip_enable_constraint.sql
-- ========================================================

-- 
set fee
-- 
set feedback off
set verify off
set wrap off
set echo off
set termout off
set lines 120
set heading off
spool bip_enable.sql
select 'spool bip_enable_constraint.log;' from dual;
select 'ALTER TABLE '||substr(c.table_name,1,35)|| ' ENABLE CONSTRAINT '||constraint_name||' ;'
from user_constraints c, user_tables u where c.table_name = u.table_name;
select 'exit;' from dual;
@tmp_enable;
!rm -i bip_enable.sql;
