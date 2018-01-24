set feedback off 
set verify off
set echo off
set termout off
set pages 80
set heading off
set linesize 120
spool bip_disable.sql
select 'spool bip_disable_constraint.log;' from dual;
select 'ALTER TABLE '||substr(c.table_name,1,35)|| ' DISABLE CONSTRAINT '||constraint_name||' ;'
from user_constraints c, user_tables u where c.table_name = u.table_name;
select 'exit;' from dual;
@bip_disable.sql;
!rm -i bip_disable.sql;
