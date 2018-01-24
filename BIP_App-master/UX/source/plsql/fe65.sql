-- pack_ctl_FE65 PL/SQL
--
-- equipe SOPRA
--
-- crée le 27/10/1999
--
-- Package qui sert à la réalisation du report FE65
-- ---------------------------------------------------------

CREATE OR REPLACE PACKAGE pack_ctl_FE65 IS 

-- Fonction qui retourne le libelle des colonnes en fonction de numéro de la colonne (1 à 5) 
-- Concerne l'édition FE65
   function f_entetecol( 
                       p_num NUMBER
                       ) RETURN VARCHAR2;
   PRAGMA RESTRICT_REFERENCES(f_entetecol,WNDS,WNPS);

-- Procedure qui controle les parametre d'entrées

   PROCEDURE select_fe65(
                 p_datdeb  IN VARCHAR2,         -- date
                 p_datfin  IN VARCHAR2,         -- date
                 p_userid  IN  VARCHAR2,
                 P_message OUT VARCHAR2
                 );

END pack_ctl_FE65;
/


CREATE OR REPLACE PACKAGE BODY pack_ctl_FE65 IS 
-- ------------------------------------
function f_entetecol(
                    p_num NUMBER
                    ) RETURN VARCHAR2
                    IS 
BEGIN
 	IF (p_num = 1) THEN
   		RETURN '1NB Factures    entregistrées';
 	END IF ;
 	IF (p_num = 2) THEN
   		RETURN '2NB Factures    réglées';
 	END IF ;
 	IF (p_num = 3) THEN
   		RETURN '3NB Factures    sans contrat';
 	END IF ;
 	IF (p_num = 4) THEN
   		RETURN '4Nb tot. fact.  en att./periode';
 	END IF ;
 	IF (p_num = 5) THEN
   		RETURN '5Nb tot. fact.  en attente';
 	END IF ;

END f_entetecol; 

-- ---------------------------------------------
PROCEDURE select_fe65(
                 p_datdeb  IN  VARCHAR2,         -- date
                 p_datfin  IN  VARCHAR2,         -- date
                 p_userid  IN  VARCHAR2,
                 P_message OUT VARCHAR2
                 ) is 

      l_message   VARCHAR2(1024);
BEGIN
      pack_ctl_lstcontl.select_periode (p_datdeb, p_datfin, 'P_param6', TRUE, l_message);
      p_message := l_message;
END select_fe65;

END pack_ctl_FE65;
/
