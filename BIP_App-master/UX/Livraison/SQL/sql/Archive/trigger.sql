spool trigger.log;

create or replace
TRIGGER UPDATE_LIGNE_BIP_HORO
BEFORE INSERT OR UPDATE ON ISAC_CONSOMME
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN

  UPDATE LIGNE_BIP SET P_SAISIE = to_char(sysdate, 'dd/mm/yyyy hh24:mi') WHERE PID = :New.PID
  AND NVL(:New.cusag,0) <> NVL(:Old.cusag,0)  ;
  
  UPDATE PMW_LIGNE_BIP SET P_SAISIE = to_char(sysdate, 'dd/mm/yyyy hh24:mi') WHERE PID = :New.PID
  AND NVL(:New.cusag,0) <> NVL(:Old.cusag,0)  ;
  

END;

/

exit;
exit;
show errors
