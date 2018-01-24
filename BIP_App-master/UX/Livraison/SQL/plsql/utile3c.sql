-- ============================================================================
-- pack_Utile3c PL/SQL
-- ============================================================================
-- Equipe SOPRA
-- Créé le 03/03/1999
-- ----------------------------------------------------------------------------

-- ============================================================================
CREATE OR REPLACE PACKAGE pack_Utile3c AS
-- ----------------------------------------------------------------------------
-- FUNCTION qui verifie l'habilitation d'un utlisateur sur un Dep Pole.
   FUNCTION f_Habilit_DP ( 
                       p_global   IN CHAR,
                       -- p_global contient l'identifiant codedeppole de l'utilisateur.       
                       p_DepPole  IN VARCHAR2
                       ) RETURN BOOLEAN;

END pack_Utile3c;
/

CREATE OR REPLACE PACKAGE BODY pack_Utile3c AS 
-- ============================================================================
-- FUNCTION qui verifie l'habilitation d'un utlisateur sur un Dep Pole.
--          Attention, les colonnes Pole1 à Pole9 de la table Userbip ne sont
--          pas vérifie. Seule la colonne codpole est prise en compte.
-- Parametres :
--      - p_global : qui contient l'identifiant codedeppole de l'utilisateur
--      - p_DepPole : code departement Pole, il peut prendre les valeurs suivantes 
--                    - '01313',      
--                    - la chaine '*****' (tous les dep poles)
--                    - '024**' (tous les poles du dep 24)
-- Valeurs Retour :
--      - True : s'il a l'habilitation
--      - False : Il n'a pas l'habilitation Dep Pole 
-- ----------------------------------------------------------------------------
 FUNCTION f_Habilit_DP ( 
                       p_global   IN CHAR,
                       p_DepPole  IN VARCHAR2
                       ) RETURN BOOLEAN IS

   l_UserDP VARCHAR2(4);    
   l_ret    VARCHAR2(1);
 BEGIN
      -- Les utilisateur avec code deppole 0000 ont droit à tous les deppole
      l_ret := 'V'; -- par defaut on suppose qu'il a droit à tous

      l_UserDP := SUBSTR(pack_global.lire_globaldata(p_global).codpole, 1,5);
      l_UserDP := RTRIM(l_UserDP,'0'); -- Supprimer des zero à la fin 
      
      IF (LENGTH (l_UserDP) = 1) or (LENGTH (l_UserDP) = 2) or (LENGTH (l_UserDP) = 4) THEN
         l_UserDP := RPAD(l_UserDP, '0');
      END IF;
      
      IF LENGTH (l_UserDP) = 0 THEN
         null;                    -- droit au dep et au pole
      ELSIF LENGTH (l_UserDP) = 3 THEN     -- Il a un pole 00
         IF l_UserDP != SUBSTR(p_DepPole,1,2) THEN
            l_ret := 'F';                 -- droit au pole uniquement
         END IF;
      ELSIF LENGTH (l_UserDP) = 5 THEN
         IF l_UserDP != p_DepPole THEN
            l_ret := 'F';                 -- droit au dep et au pole
         END IF;
      END IF;
      
      IF l_ret = 'V' THEN
         return TRUE;
      ELSE 
         return FALSE;
      END IF;

 END f_Habilit_DP ;


END pack_Utile3c;
/

