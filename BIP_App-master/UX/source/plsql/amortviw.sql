-- -------------------------------------------------------------------
-- pack_verif_amortviw PL/SQL
--
-- equipe SOPRA (HT)
--
-- cr�e le 21/01/2000
--
-- Package qui sert � la r�alisation de l'�tat AMORTVIW
-- (D�tail des amortissements d'une ligne BIP)
--
-- Quand    Qui  Nom                   	Quoi
-- -------- ---  --------------------  	----------------------------------------
--
-- -------------------------------------------------------------------

CREATE OR REPLACE PACKAGE pack_verif_amortviw  AS
-- ----------------------------------------------

-- ------------------------------------------------------------------------
--
-- Nom        : verif_amortviw
-- Auteur     : Equipe SOPRA 
-- Decription : V�rification des param�tres saisis pour l'�tat AMORTVIW
-- Param�tres : 
--              p_pid (IN)		Code ligne BIP
--              p_codsg      (IN) 		Code DPG
--		    P_message OUT             Message de sortie
-- 
-- Remarque :  
--             
-- ------------------------------------------------------------------------   

     PROCEDURE verif_amortviw( 
                 p_pid IN  VARCHAR2,	     -- CHAR(4) 
                 P_message OUT VARCHAR2
                 );


END pack_verif_amortviw ;
/

CREATE OR REPLACE PACKAGE BODY pack_verif_amortviw  AS 
-- ---------------------------------------------------

-- ------------------------------------------------------------------------
--
-- Nom        : verif_amortviw
-- Auteur     : Equipe SOPRA 
-- Decription : V�rification des param�tres saisis pour l'�tat AMORTVIW
-- Param�tres : 
--              p_pid (IN)		Code Ligne BIP
--              p_codsg      (IN) 		Code DPG
--		    P_message OUT             Message de sortie
-- 
-- Remarque :  
--             
-- ------------------------------------------------------------------------   

PROCEDURE verif_amortviw( 
                 p_pid IN  VARCHAR2,	     -- CHAR(4) 
                 P_message OUT VARCHAR2
                 ) IS

      l_message   VARCHAR2(1024) := '';

BEGIN

   BEGIN

	---------------------------------------------------------------------------------------------
	-- V�rification existence Code ligne bip dans la table HISTO_AMORT
	---------------------------------------------------------------------------------------------
	IF ( pack_utile3B.f_verif_pid_histo_amort(p_pid) = FALSE ) 
	THEN
            pack_global.recuperer_message(pack_utile_numsg.nuexc_codligne_bip_inexiste, '%s1', 
                                          p_pid, ' P_param6 ', l_message);
	END IF;  

      p_message := l_message;

      IF (l_message IS NOT NULL) THEN
          RAISE_APPLICATION_ERROR(-pack_utile_numsg.nuexc_codligne_bip_inexiste, l_message);
      END IF;

   END;

END verif_amortviw; 
 
END pack_verif_amortviw ;
/

