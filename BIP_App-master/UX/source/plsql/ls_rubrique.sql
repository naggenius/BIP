-- pack_branche PL/SQL
--
-- 
--
-- Cree le 06/02/2006 BAA
--
-- 
-- Attention le nom du package ne peut etre le nom
-- Modifié Le 01/02/2006  par BAA Ajout de la procedure lister_direction
-- Modifié Le 01/02/2006  par BAA Ajout de la procedure lister_rubrique_metier iche 286
-- Modifié Le 03/05/2006  par BAA Correction
-- Modifié Le 28/09/2006  par PPR Cas du DPG inexistant
-- Modifié Le 24/05/2011  par BSA QC 1174
-- Modifié Le 13/09/2011  par ABA QC 1229

create or replace
PACKAGE     Pack_Liste_Rubrique AS

    TYPE lib_ListeCompteViewType IS RECORD( CODCOMPTE      COMPTE.CODCOMPTE%TYPE,
                                            LIBCOMPTE           VARCHAR2(70)
                                          );

    TYPE lib_listeCompteCurType IS REF CURSOR RETURN lib_ListeCompteViewType;



   -- liste des compte selon le type
      PROCEDURE lister_compte_type( p_userid   IN       VARCHAR2,
                                         p_type                         IN VARCHAR2,
                                     p_curseur  IN OUT lib_listeCompteCurType
                                   );



     PROCEDURE lister_type_rubrique( p_userid   IN       VARCHAR2,
                                     p_curseur  IN OUT Pack_Liste_Dynamique.liste_dyn
                                   );

     PROCEDURE lister_rubrique_metier( p_userid   IN       VARCHAR2,
                                             p_codsg IN       VARCHAR2,
                                            p_curseur  IN OUT Pack_Liste_Dynamique.liste_dyn
                                      );

     PROCEDURE lister_rubrique_metier_type( p_userid    IN       VARCHAR2,
                                                   p_codsg     IN       VARCHAR2,
                                            p_typproj   IN    VARCHAR2,
                                            p_ca_payeur IN VARCHAR2,
                                                  p_curseur  IN OUT Pack_Liste_Dynamique.liste_dyn
                                          );
     -- SEL 19/05/2014 PPM 58920 8.5.1
     FUNCTION exister_rubrique_fictive RETURN boolean;
     --KRA 61919 p5.9 : liste des métiers autorisées 
      FUNCTION liste_metiers_autorisees ( p_codsg IN VARCHAR2) RETURN VARCHAR2;

END Pack_Liste_Rubrique;
/


create or replace
PACKAGE BODY     pack_liste_rubrique
AS
   PROCEDURE lister_compte_type (
      p_userid    IN       VARCHAR2,
      p_type      IN       VARCHAR2,
      p_curseur   IN OUT   lib_listecomptecurtype
   )
   IS
   BEGIN
      OPEN p_curseur FOR
         --Ligne vide en haut
         SELECT   '', ' ' libelle
             FROM compte
         UNION
         SELECT DISTINCT TO_CHAR (codcompte),
                            RPAD (TO_CHAR (codcompte), 10, ' ')
                         || ' - '
                         || libcompte libelle
                    FROM compte
                   WHERE TYPE = p_type
                ORDER BY libelle;
   END lister_compte_type;

   PROCEDURE lister_type_rubrique (
      p_userid    IN       VARCHAR2,
      p_curseur   IN OUT   pack_liste_dynamique.liste_dyn
   )
   IS
   BEGIN
      OPEN p_curseur FOR
         --Ligne vide en haut
         SELECT   TO_CHAR (codep, 'FM00000') || '-' || codfei,
                  codep || ' - ' || codfei || ' - ' || librubst
             FROM type_rubrique
         ORDER BY codfei, codep;
   END lister_type_rubrique;

   PROCEDURE lister_rubrique_metier (
      p_userid    IN       VARCHAR2,
      p_codsg     IN       VARCHAR2,
      p_curseur   IN OUT   pack_liste_dynamique.liste_dyn
   )
   IS
      v_cafi   NUMBER;
   BEGIN
      IF (UPPER (p_codsg) != 'NULL')
      THEN
         SELECT s.cafi
           INTO v_cafi
           FROM struct_info s
          WHERE s.codsg = TO_NUMBER (p_codsg);

         IF ((v_cafi = 88888) OR (v_cafi = 99999))
         THEN
            OPEN p_curseur FOR
               SELECT   '', ' ' libelle
                   FROM rubrique_metier
               UNION
               SELECT DISTINCT RPAD (rm.metier, 3, ' '), rm.metier libelle
                          FROM rubrique_metier rm
                      ORDER BY libelle;
         ELSE
            OPEN p_curseur FOR
               SELECT   '', ' ' libelle
                   FROM rubrique_metier
               UNION
               SELECT DISTINCT RPAD (rm.metier, 3, ' '), rm.metier libelle
                          FROM rubrique_metier rm
                         WHERE (rm.codep, rm.codfei) IN (
                                  SELECT r.codep, r.codfei
                                    FROM rubrique r
                                   WHERE r.cafi IN (
                                            SELECT s.cafi
                                              FROM struct_info s
                                             WHERE s.codsg =
                                                          TO_NUMBER (p_codsg)))
                      ORDER BY libelle;
         END IF;
      ELSE
         OPEN p_curseur FOR
            SELECT '' metier, ' ' libelle
              FROM DUAL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         OPEN p_curseur FOR
            SELECT '' metier, ' ' libelle
              FROM DUAL;
   END lister_rubrique_metier;

-- BSA QC 1174
   PROCEDURE lister_rubrique_metier_type (
      p_userid    IN       VARCHAR2,
      p_codsg     IN       VARCHAR2,
      p_typproj   IN       VARCHAR2,
      p_ca_payeur IN       VARCHAR2,
      p_curseur   IN OUT   pack_liste_dynamique.liste_dyn
   )
   IS
      v_cafi   NUMBER;
   BEGIN
      IF (UPPER (p_codsg) != 'NULL')
      THEN
         SELECT s.cafi
           INTO v_cafi
           FROM struct_info s
          WHERE s.codsg = TO_NUMBER (p_codsg);

         IF (   (v_cafi in (88888,99999,99810))
             OR (p_typproj in (5,7))
             OR (p_ca_payeur in ('21000','22000','23000','24000','25000'))
             OR exister_rubrique_fictive -- SEL 19/05/2014 PPM 58920 8.5.1
           )
         THEN
            OPEN p_curseur FOR
               SELECT   '', ' ' libelle
                   FROM rubrique_metier
               UNION
               SELECT DISTINCT RPAD (rm.metier, 3, ' '), rm.metier libelle
                          FROM rubrique_metier rm
                          where INSTR(NVL(liste_metiers_autorisees(p_codsg),METIER),METIER)>0 --KRA PPM 61919 p6.9 : si param DIR-REGLAGES est absent alors tous les métiers sont autorisés.
                      ORDER BY libelle;
         ELSIF (v_cafi = 99820)
         THEN
            OPEN p_curseur FOR
               SELECT   '', ' ' libelle
                   FROM rubrique_metier
               UNION
               SELECT DISTINCT RPAD (rm.metier, 3, ' '), rm.metier libelle
                          FROM rubrique_metier rm
                         WHERE INSTR(NVL(liste_metiers_autorisees(p_codsg),METIER),METIER)>0 AND --KRA PPM 61919 p6.9
                         (rm.codep, rm.codfei) IN (
                                  SELECT r.codep, r.codfei
                                    FROM rubrique r
                                   WHERE r.cafi IN (
                                            SELECT s.centractiv
                                              FROM struct_info s
                                             WHERE s.codsg =
                                                          TO_NUMBER (p_codsg)))
                      ORDER BY libelle;
         ELSE
            OPEN p_curseur FOR
               SELECT   '', ' ' libelle
                   FROM rubrique_metier
               UNION
               SELECT DISTINCT RPAD (rm.metier, 3, ' '), rm.metier libelle
                          FROM rubrique_metier rm
                         WHERE INSTR(NVL(liste_metiers_autorisees(p_codsg),METIER),METIER)>0 AND --KRA PPM 61919 p6.9
                         (rm.codep, rm.codfei) IN (
                                  SELECT r.codep, r.codfei
                                    FROM rubrique r
                                   WHERE r.cafi IN (
                                            SELECT s.cafi
                                              FROM struct_info s
                                             WHERE s.codsg =
                                                          TO_NUMBER (p_codsg)))
                      ORDER BY libelle;
         END IF;
      ELSE
         OPEN p_curseur FOR
            SELECT '' metier, ' ' libelle
              FROM DUAL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         OPEN p_curseur FOR
            SELECT '' metier, ' ' libelle
              FROM DUAL;
   END lister_rubrique_metier_type;

   -- SEL 19/05/2014 PPM 58920 8.5.1
   FUNCTION exister_rubrique_fictive  RETURN boolean IS

   existe boolean:=true;

   l_codrub NUMBER;
   BEGIN

    BEGIN

    SELECT codrub INTO l_codrub  FROM rubrique WHERE coddir=99;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      existe := false;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR( -20997, SQLERRM);
    END;

    --IF(existe) THEN DBMS_OUTPUT.PUT_LINE('TRUE'); ELSE DBMS_OUTPUT.PUT_LINE('FALSE'); END IF;

   RETURN existe;

   END exister_rubrique_fictive;
   --KRA 61919 p6.9 : liste des métiers autorisées
   FUNCTION liste_metiers_autorisees ( p_codsg IN VARCHAR2) RETURN VARCHAR2 IS
   
   l_valeur VARCHAR2(1024);
   BEGIN
    BEGIN
    l_valeur := '';
     SELECT valeur INTO l_valeur
          FROM ligne_param_bip
          WHERE code_action = 'DIR-REGLAGES'
          AND   actif = 'O'
          and code_version = (select coddir from struct_info where codsg = TO_NUMBER (p_codsg))
          AND   num_ligne = (SELECT MIN (num_ligne) FROM ligne_param_bip
                                  WHERE  code_action = 'DIR-REGLAGES'
                                  AND   actif = 'O' );
        EXCEPTION
    WHEN NO_DATA_FOUND THEN    
    return l_valeur;
    END;
    return l_valeur ;
   
   END liste_metiers_autorisees;
END pack_liste_rubrique;
/




