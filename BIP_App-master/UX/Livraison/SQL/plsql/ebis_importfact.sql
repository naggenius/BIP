create or replace
TRIGGER "BIP"."INSERT_EBIS_IMPORT_FACTURE" 
BEFORE INSERT
ON BIP.ebis_import_facture
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE

BEGIN
-- Conditions sur la référence Expense du contrat
-- Si nb car. = 13, commence par "CW",   et car. (11 et 8)  = "-", 
-- ou nb car. = 16, commence par "ATG-", et car. (14 et 11) = "-",
IF ((length(:new.numcontcav) = 13 
		AND substr(:new.numcontcav,0,2) = 'CW'
		AND substr(:new.numcontcav,length(:new.numcontcav)-2,1) = '-' 
		AND substr(:new.numcontcav,8,1) = '-')
	OR 
	(length(:new.numcontcav) = 16 
		AND substr(:new.numcontcav,0,4) = 'ATG-' 
		AND substr(:new.numcontcav,length(:new.numcontcav)-2,1) = '-' 
		AND substr(:new.numcontcav,11,1) = '-')) THEN
	-- numéro d'avenant = "000"
	-- racine du contrat = ref Expense
	:new.cav := '000';
	:new.numcont := :new.numcontcav;
-- Sinon, si le 3è car. en partant de la fin = "-" 
ELSIF (substr(:new.numcontcav,length(:new.numcontcav)-2,1) = '-') THEN
	-- numéro d'avenant = "0" suivi des 2 derniers car. de ref Expense
	-- racine du contrat = ref Expense moins les 3 derniers caractères
	:new.cav := '0' || substr(:new.numcontcav,length(:new.numcontcav)-1,2);
	:new.numcont := substr(:new.numcontcav,0,length(:new.numcontcav)-3);
-- Sinon, si le 3è car. en partant de la fin = " "
ELSIF (substr(:new.numcontcav,length(:new.numcontcav)-2,1) = ' ') THEN
	-- numéro d'avenant = "000"
	-- racine du contrat = ref Expense moins les 3 derniers caractères
	:new.cav := '000';
	:new.numcont := substr(:new.numcontcav,0,length(:new.numcontcav)-3);
-- Sinon
ELSE
	-- numéro d'avenant = 3 derniers car. de ref Expense
	-- racine du contrat = ref Expense moins les 3 derniers caractères
	:new.cav := substr(:new.numcontcav,length(:new.numcontcav)-2,3);
	:new.numcont := substr(:new.numcontcav,0,length(:new.numcontcav)-3);
END IF;

END update_cav_ebis_import_facture;
/