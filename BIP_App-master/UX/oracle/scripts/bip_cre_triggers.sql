-- ============================================================
-- PROJET  - Script de creation des triggers BIP
-- Date : 02/10/2006	
-- Auteur :  A. SAKHRAOUI
-- Version:	1
--
-- Modifications :
--	
--
-- ============================================================

-- ========================================================
-- bip_cretriggers.sql
-- ========================================================

--
-- DELETE_SITUATION  (Trigger) 
--
CREATE OR REPLACE TRIGGER bip.delete_situation
   AFTER DELETE
   ON bip.situ_ress
   FOR EACH ROW
BEGIN
   pack_situation_full.delete_situation (:OLD.ident, :OLD.datsitu);
END;
/
SHOW ERRORS;



--
-- INSERT_SITUATION  (Trigger) 
--
CREATE OR REPLACE TRIGGER bip.insert_situation
   AFTER INSERT
   ON bip.situ_ress
   FOR EACH ROW
BEGIN
   pack_situation_full.insert_situation (:NEW.ident,
                                         :NEW.datsitu,
                                         :NEW.datdep,
                                         :NEW.cpident,
                                         :NEW.cout,
                                         :NEW.dispo,
                                         :NEW.marsg2,
                                         :NEW.rmcomp,
                                         :NEW.prestation,
                                         :NEW.dprest,
                                         :NEW.soccode,
                                         :NEW.codsg,
                                         :NEW.niveau,
                                         :NEW.montant_mensuel
                                        );
END;
/
SHOW ERRORS;



--
-- UPDATE_SITUATION  (Trigger) 
--
CREATE OR REPLACE TRIGGER bip.update_situation
   AFTER UPDATE
   ON bip.situ_ress
   FOR EACH ROW
BEGIN
   pack_situation_full.update_situation (:OLD.ident,
                                         :OLD.datsitu,
                                         :NEW.datsitu,
                                         :NEW.datdep,
                                         :NEW.cpident,
                                         :NEW.cout,
                                         :NEW.dispo,
                                         :NEW.marsg2,
                                         :NEW.rmcomp,
                                         :NEW.prestation,
                                         :NEW.dprest,
                                         :NEW.soccode,
                                         :NEW.codsg,
                                         :NEW.niveau,
                                         :NEW.montant_mensuel
                                        );
END;
/
SHOW ERRORS;