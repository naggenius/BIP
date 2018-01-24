-- pack_rep_refpca4 PL/SQL
--
-- equipe SOPRA
--
-- crée le 6/12/1999       @g:\commun\lot3A_dev\source\plsql\reports\refpcax.sql
--
CREATE OR REPLACE PACKAGE pack_rep_refpca4 IS

-- ------------------------------------------------------------------------
-- Nom        : f_trityp       retourne tritype       
--              f_trityplib    retourne Libellé de tritype
-- Auteur     : Equipe SOPRA
-- Paramètres : p_typproj (IN) type de projet (ligne_bip.typproj)
--
-- ------------------------------------------------------------------------   
-- Quand       Qui       Quoi
-- 6/12/1999   QHL       Creation
-- ------------------------------------------------------------------------   
   FUNCTION f_trityp ( p_ptype   IN   NUMBER
                     ) RETURN VARCHAR2;
      PRAGMA RESTRICT_REFERENCES(f_trityp,WNDS,WNPS);


   FUNCTION f_trityplib ( p_ptype   IN   VARCHAR2
                     ) RETURN VARCHAR2;
      PRAGMA RESTRICT_REFERENCES(f_trityplib,WNDS,WNPS);


-- ------------------------------------------------------------------------
-- Nom        : f_annee_mois0
-- Appel      : Appelé par Before report
-- Auteur     : Equipe SOPRA
-- Decription : retourne l'année du mois précédant le mois système courant
-- Paramètres : pas de paramètre
-- Retour     : année (en char)
-- ------------------------------------------------------------------------   
-- Quand       Qui       Quoi
-- 6/12/1999   QHL       Creation
-- ------------------------------------------------------------------------   

   FUNCTION f_annee_mois0 RETURN VARCHAR2;
      PRAGMA RESTRICT_REFERENCES(f_annee_mois0,WNDS,WNPS);

END pack_rep_refpca4;
/
-- ********************************************************************************

CREATE OR REPLACE PACKAGE BODY pack_rep_refpca4 IS

-- ===================================================
   FUNCTION f_trityp(p_ptype  IN  NUMBER
                    ) RETURN VARCHAR2  IS
   BEGIN
      IF p_ptype >= 1 AND p_ptype <= 4 
                      THEN   RETURN 'PLAN'; END IF;
      IF p_ptype = 5  THEN   RETURN 'T5';   END IF;
      IF p_ptype = 6  THEN   RETURN 'T6';   END IF;
      IF p_ptype = 7  THEN   RETURN 'T7';   END IF;
      IF p_ptype = 8  THEN   RETURN 'T8';   END IF;
      RETURN 'TXXX';
   END f_trityp;

-- ===================================================
   FUNCTION f_trityplib(p_ptype  IN  VARCHAR2
                    ) RETURN VARCHAR2  IS
   BEGIN
      IF p_ptype >= 1 AND p_ptype <= 4 
                      THEN   RETURN 'PLAN PLAN INFORMATIQUE   ';  END IF;
      IF p_ptype = 5  THEN   RETURN 'T5   STRUCTURE           ';  END IF;
      IF p_ptype = 6  THEN   RETURN 'T6   EXPLOITATION        ';  END IF;
      IF p_ptype = 7  THEN   RETURN 'T7   ABSENCES            ';  END IF;
      IF p_ptype = 8  THEN   RETURN 'T8   ACTIVITES TECHNIQUES';  END IF;
      RETURN                        'TXXX Type Projet INCONNU ';
   END f_trityplib;

-- ===================================================
   
   FUNCTION f_annee_mois0 RETURN VARCHAR2  IS
      l_annee  VARCHAR2(10);
   BEGIN
      -- ====================================================================
      -- Determiner l'annee de traitement N qui est l'annee du mois precedent
      -- ====================================================================
      select to_char(add_months(sysdate,-1),'YYYY') into l_annee from dual ;
      return l_annee;
   END f_annee_mois0;

END pack_rep_refpca4;
/