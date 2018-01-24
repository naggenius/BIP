-- pack_verif_factab6 PL/SQL
--
-- equipe SOPRA
--
-- crée le 11/10/1999
--
-- Attention le nom du package ne peut etre le nom
-- de la table...


CREATE OR REPLACE PACKAGE pack_verif_factab6 AS
-- ---------------------------------------------
      PROCEDURE verif_factab6(
                 p_soccode 	IN  societe.soccode%TYPE, -- CHAR(4)
                 p_fregcompta1 	IN  VARCHAR2,             -- date
                 p_fregcompta2 	IN  VARCHAR2,          	  -- date
                 p_userid  	IN  VARCHAR2,
                 P_message 	OUT VARCHAR2
                 ); 

END pack_verif_factab6;
/

CREATE OR REPLACE PACKAGE BODY pack_verif_factab6 AS 
-- ------------------------------------------------
 PROCEDURE verif_factab6(                 
                 p_soccode 	IN  societe.soccode%TYPE, -- CHAR(4)
                 p_fregcompta1 	IN  VARCHAR2,             -- date
                 p_fregcompta2 	IN  VARCHAR2,             -- date
                 p_userid  	IN  VARCHAR2,
                 P_message 	OUT VARCHAR2
                 ) is 

      l_message   VARCHAR2(1024);
   BEGIN
      l_message := '';

      IF (p_soccode IS NOT NULL) THEN
            pack_ctl_lstcontl.select_societe (p_soccode,'P_param6', l_message);
      END IF;

      -- Controle de la periode
      IF (l_message IS NULL) THEN
		pack_ctl_lstcontl.select_periode(p_fregcompta1 , p_fregcompta2 , 'P_param7', l_message);
      END IF;
              
      p_message := l_message;
   END verif_factab6;
   
END pack_verif_factab6;
/





