


create or replace TYPE BIPS_OUTSOUC_REC AS object (p_pid nvarchar2(10), p_sous_tache_id ARRAY_TABLE); 
create or replace TYPE BIPS_OUTSOUC IS TABLE OF bips_outsouc_rec ;
