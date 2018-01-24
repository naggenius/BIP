-- pack_ressource_l PL/SQL
--
-- BAA
--
-- Crée le 05/12/2005
-- Ce package contient les diferrents ptocedure pour recupere la liste des types 
-- Fiche 257
--
-- Attention le nom du package ne peut etre le nom de la table...
-- Modification:
-- le 03/12/2008 par EVI: TD 719 Liste déroulante dynamique pour le choix d'une prestation lors de la création d'un forfait
-- le 11/12/2008 par ECH: ajout prestat OFS
-- le 31/08/2009 par ABA : mise à jour de la liste dynamique pour rajouter OFS et OFH
-- le 11/09/2009 par YNI : mise à jour de la liste dynamique pour Prestation
-- le 22/03/2010 ABA TD 941
-- le 28/06/2010 YNI FDT 970
-- le 18/07/2010 YNI FDT 970
-- le 12/08/2010 YNI FDT 970
-- Modifiée le 15/09/2010 par ABA Fiche 970
-- 24/09/2010 YSB FDT 970
-- Modifiée le 08/10/2010 par ABA Fiche 970

CREATE OR REPLACE PACKAGE     pack_liste_type
AS
   TYPE lib_listedomaineviewtype IS RECORD (
      code_domaine   type_domaine.code_domaine%TYPE,
      lib_domaine    type_domaine.lib_domaine%TYPE
   );

   TYPE lib_listedomainecurtype IS REF CURSOR
      RETURN lib_listedomaineviewtype;

   -- liste des types de domaine
   PROCEDURE lister_type_domaine (
      p_userid    IN       VARCHAR2,
      p_curseur   IN OUT   lib_listedomainecurtype
   );

   -- liste des types de domaine selon le type
   PROCEDURE lister_type_domaine_type (
      p_userid    IN       VARCHAR2,
      p_rtype     IN       VARCHAR2,
      p_curseur   IN OUT   lib_listedomainecurtype
   );

   TYPE lib_listeprestationviewtype IS RECORD (
      code_prestation   prestation.prestation%TYPE,
      libprest          prestation.libprest%TYPE
   );

   TYPE lib_listeprestationcurtype IS REF CURSOR
      RETURN lib_listeprestationviewtype;

   -- liste des types de Prestation
   PROCEDURE lister_type_prestation (
      p_userid         IN       VARCHAR2,
      p_rtype          IN       VARCHAR2,
      p_code_domaine   IN       VARCHAR2,
      p_curseur        IN OUT   lib_listeprestationcurtype
   );

   TYPE lib_listertypeviewtype IS RECORD (
      rtype   type_ress.rtype%TYPE,
      rlib    type_ress.rlib%TYPE
   );

   TYPE lib_listertypecurtype IS REF CURSOR
      RETURN lib_listertypeviewtype;

   -- liste des types de Ressource
   PROCEDURE lister_type_rtype (
      p_userid    IN       VARCHAR2,
      p_curseur   IN OUT   lib_listertypecurtype
   );

   -- DEBUT YNI FDT 970
   -- Curseur des modes localisation
   TYPE lib_listelocalisationviewtype IS RECORD (
      code_localisation   localisation.code_localisation%TYPE,
      libelle             localisation.libelle%TYPE
   );

   TYPE lib_listelocacontrcurtype IS RECORD (
      code_localisation   localisation.code_localisation%TYPE,
      libelle             localisation.libelle%TYPE
   );

   TYPE lib_listelocalisationcurtype IS REF CURSOR
      RETURN lib_listelocalisationviewtype;

   -- liste des codes localisations
   PROCEDURE lister_type_localisation (
      p_userid    IN       VARCHAR2,
      p_curseur   IN OUT   lib_listelocalisationcurtype
   );

   PROCEDURE lister_localisation_contrat (
      p_userid     IN       VARCHAR2,
      p_rtype      IN       VARCHAR2,
      p_fraisenv   IN       VARCHAR2,
      p_curseur    IN OUT   lib_listelocalisationcurtype
   );

   PROCEDURE lister_localisation_situation (
      p_userid    IN       VARCHAR2,
      p_rtype     IN       VARCHAR2,
      p_curseur   IN OUT   lib_listelocalisationcurtype
   );

   -- Curseur des modes localisation
   TYPE lib_listecontractuelviewtype IS RECORD (
      code_contractuel   mode_contractuel.code_contractuel%TYPE,
      libelle            mode_contractuel.libelle%TYPE
   );

   TYPE lib_listecontractuelcurtype IS REF CURSOR
      RETURN lib_listecontractuelviewtype;

   -- liste des modes localisation
   PROCEDURE lister_mode_contractuel (
      p_userid         IN       VARCHAR2,
      p_rtype          IN       VARCHAR2,
      p_localisation   IN       VARCHAR2,
      p_curseur        IN OUT   lib_listecontractuelcurtype
   );

   PROCEDURE lister_mode_contractuel_long (
      p_userid    IN       VARCHAR2,
      p_rtype     IN       VARCHAR2,
      p_curseur   IN OUT   lib_listecontractuelcurtype
   );

   PROCEDURE lister_mc_long_contrat (
      p_userid      IN       VARCHAR2,
      p_typfact     IN       VARCHAR2,
      p_rtype       IN       VARCHAR2,
      p_curseur     IN OUT   lib_listecontractuelcurtype
   );

   -- FIN YNI FDT 970
   PROCEDURE lister_popup_contractuel_cont (
      p_userid         IN       VARCHAR2,
      p_rtype          IN       VARCHAR2,
      p_localisation   IN       VARCHAR2,
      p_fraisenv       IN       VARCHAR2,
      p_curseur        IN OUT   lib_listecontractuelcurtype
   );
END pack_liste_type;
/


CREATE OR REPLACE PACKAGE BODY     pack_liste_type
AS
   -- liste des types de domaine
   PROCEDURE lister_type_domaine (
      p_userid    IN       VARCHAR2,
      p_curseur   IN OUT   lib_listedomainecurtype
   )
   IS
   BEGIN
      OPEN p_curseur FOR
         --Ligne vide en haut
         SELECT   '', ' ' libelle
             FROM DUAL
         UNION
         SELECT   code_domaine,
                  RPAD (code_domaine, 2, ' ') || ' - ' || lib_domaine
                                                                     libelle
             FROM type_domaine
         ORDER BY libelle;
   END lister_type_domaine;

   -- liste des types de domaine selon le rtype
   PROCEDURE lister_type_domaine_type (
      p_userid    IN       VARCHAR2,
      p_rtype     IN       VARCHAR2,
      p_curseur   IN OUT   lib_listedomainecurtype
   )
   IS
   BEGIN
      IF p_rtype = 'L'
      THEN
         OPEN p_curseur FOR
            --Ligne vide en haut
            SELECT   '', ' ' libelle
                FROM DUAL
            UNION
            SELECT DISTINCT p.code_domaine,
                               RPAD (p.code_domaine, 2, ' ')
                            || ' - '
                            || d.lib_domaine libelle
                       FROM prestation p, type_domaine d
                      WHERE p.rtype = p_rtype
                        AND p.top_actif = 'O'
                        AND d.code_domaine = p.code_domaine
                   ORDER BY libelle;
      ELSE
         OPEN p_curseur FOR
            --Ligne vide en haut
            SELECT   '', ' ' libelle
                FROM DUAL
            UNION
            SELECT DISTINCT p.code_domaine,
                               RPAD (p.code_domaine, 2, ' ')
                            || ' - '
                            || d.lib_domaine libelle
                       FROM prestation p, type_domaine d
                      WHERE (p.rtype = p_rtype OR p.rtype = '*')
                        AND p.top_actif = 'O'
                        AND d.code_domaine = p.code_domaine
                   ORDER BY libelle;
      END IF;
   END lister_type_domaine_type;

   -- liste des types de prestation
   PROCEDURE lister_type_prestation (
      p_userid         IN       VARCHAR2,
      p_rtype          IN       VARCHAR2,
      p_code_domaine   IN       VARCHAR2,
      p_curseur        IN OUT   lib_listeprestationcurtype
   )
   IS
   BEGIN
      -- Si ressource de type  Logiciel
      IF p_rtype = 'L'
      THEN
         OPEN p_curseur FOR
            SELECT   prestation,
                     RPAD (prestation, 3, ' ') || ' - ' || libprest libelle
                FROM prestation
               WHERE rtype = p_rtype
                 AND code_domaine = p_code_domaine
                 AND top_actif = 'O'
            ORDER BY prestation;
      ELSE
         OPEN p_curseur FOR
            SELECT   prestation,
                     RPAD (prestation, 3, ' ') || ' - ' || libprest libelle
                FROM prestation
               WHERE (rtype = p_rtype OR rtype = '*')
                 AND code_domaine = p_code_domaine
                 AND top_actif = 'O'
            ORDER BY prestation;
      END IF;
   END lister_type_prestation;

   -- liste des types de Ressource
   PROCEDURE lister_type_rtype (
      p_userid    IN       VARCHAR2,
      p_curseur   IN OUT   lib_listertypecurtype
   )
   IS
   BEGIN
      OPEN p_curseur FOR
         --Ligne vide en haut
         SELECT   '', ' ' libelle
             FROM DUAL
         UNION
         --YNI FDT 970
         /*
         SELECT '*',
                 '* - Tous types' libelle
          FROM dual
         UNION*/
         --Fin YNI FDT 970
         SELECT   rtype, rtype || ' - ' || rlib libelle
             FROM type_ress
            WHERE UPPER (rtype) <> 'C'
         ORDER BY libelle;
   END lister_type_rtype;

   --YNI FDT 970
   --liste utilisée dans le menu Table/MAJ/mode contractuel
   PROCEDURE lister_type_localisation (
      p_userid    IN       VARCHAR2,
      p_curseur   IN OUT   lib_listelocalisationcurtype
   )
   IS
   BEGIN
      OPEN p_curseur FOR
         --Ligne vide en haut
         SELECT   '', ' ' libel
             FROM DUAL
         UNION
         SELECT   code_localisation,
                  code_localisation || ' - ' || libelle libel
             FROM localisation
         ORDER BY libel;
   END lister_type_localisation;

   --YNI FDT 970
   --liste utilisée popup recherche MCI situations
   PROCEDURE lister_localisation_situation (
      p_userid    IN       VARCHAR2,
      p_rtype     IN       VARCHAR2,
      p_curseur   IN OUT   lib_listelocalisationcurtype
   )
   IS
   BEGIN
      OPEN p_curseur FOR
         SELECT DISTINCT loc.code_localisation,
                         loc.code_localisation || ' - ' || loc.libelle libel
                    FROM localisation loc, mode_contractuel mc
                   WHERE mc.top_actif = 'O'
                     AND  mc.type_ressource = p_rtype
                     AND mc.code_localisation = loc.code_localisation
                ORDER BY libel DESC;
   END lister_localisation_situation;

   --YNI FDT 970
    --liste utilisée popup recherche MC contrats
   PROCEDURE lister_localisation_contrat (
      p_userid     IN       VARCHAR2,
      p_rtype      IN       VARCHAR2,
      p_fraisenv   IN       VARCHAR2,
      p_curseur    IN OUT   lib_listelocalisationcurtype
   )
   IS
   BEGIN
      IF p_fraisenv != p_rtype
      THEN
         OPEN p_curseur FOR
            --Ligne vide en haut
            SELECT DISTINCT loc.code_localisation,
                            loc.code_localisation || ' - '
                            || loc.libelle libel
                       FROM localisation loc, mode_contractuel mc
                      WHERE 0 = 1;
      ELSE
         OPEN p_curseur FOR
            --Ligne vide en haut
            SELECT DISTINCT loc.code_localisation,
                            loc.code_localisation || ' - '
                            || loc.libelle libel
                       FROM localisation loc, mode_contractuel mc
                      WHERE loc.code_localisation = mc.code_localisation
                        AND mc.top_actif = 'O'
                        AND mc.type_ressource = p_rtype
                   ORDER BY libel DESC;
      END IF;
   END lister_localisation_contrat;

   --liste des modes contractuels (situation) pour les logiciel et prestataire eu temps passé
   PROCEDURE lister_mode_contractuel_long (
      p_userid    IN       VARCHAR2,
      p_rtype     IN       VARCHAR2,
      p_curseur   IN OUT   lib_listecontractuelcurtype
   )
   IS
   BEGIN

         OPEN p_curseur FOR
             SELECT code, libel
              FROM (

              SELECT   mcont.code_contractuel code,
                                mcont.code_contractuel
                             || '  '
                             || mcont.libelle
                             || '  '
                             || loc.libelle
                             || '  '
                             || tress.rlib libel,

                             -- top tri permettant d'afficher la valeur ??? en première position dans la liste déroulante
                             DECODE (mcont.code_contractuel,
                                     '???', 1,
                                     0
                                    ) top_tri
                        FROM mode_contractuel mcont,
                             localisation loc,
                             type_ress tress
                       WHERE mcont.code_contractuel = '???'
                         AND mcont.code_localisation = loc.code_localisation(+)
                         AND mcont.type_ressource = tress.rtype(+)
                       union
              SELECT   mcont.code_contractuel code,
                                mcont.code_contractuel
                             || '  '
                             || mcont.libelle
                             || '  '
                             || loc.libelle
                             || '  '
                             || tress.rlib libel,

                             -- top tri permettant d'afficher la valeur ??? en première position dans la liste déroulante
                             DECODE (mcont.code_contractuel,
                                     '???', 1,
                                     0
                                    ) top_tri
                        FROM mode_contractuel mcont,
                             localisation loc,
                             type_ress tress
                       WHERE (   mcont.type_ressource = p_rtype

                             )
                         AND mcont.top_actif = 'O'
                         AND mcont.code_localisation = loc.code_localisation(+)
                         AND mcont.type_ressource = tress.rtype(+)

                 ORDER BY top_tri DESC,
                             libel DESC,
                             code);

   END lister_mode_contractuel_long;

   --liste des modes contractuels (situation) pour les forfait de type F et E
   PROCEDURE lister_mode_contractuel (
      p_userid         IN       VARCHAR2,
      p_rtype          IN       VARCHAR2,
      p_localisation   IN       VARCHAR2,
      p_curseur        IN OUT   lib_listecontractuelcurtype
   )
   IS
   BEGIN
      OPEN p_curseur FOR
         --Ligne vide en haut
       SELECT ' ' code, ' ' libel
           FROM DUAL
         UNION
        select code, libel from(
        SELECT mcont.code_contractuel code,
                mcont.code_contractuel || '  ' || mcont.libelle libel,
                ' ' libelMC
           FROM mode_contractuel mcont
          WHERE mcont.code_contractuel = '???'
         UNION
         SELECT mcont.code_contractuel code ,
                mcont.code_contractuel || '  ' || mcont.libelle libel,
                mcont.libelle libelMC
           FROM mode_contractuel mcont
          WHERE mcont.type_ressource = p_rtype
            AND mcont.top_actif = 'O'
            AND mcont.code_localisation = p_localisation
            order by libelMC);
   END lister_mode_contractuel;

   --liste des modes contractuels (contrat) : ne traite que les types E et F
   PROCEDURE lister_popup_contractuel_cont (
      p_userid         IN       VARCHAR2,
      p_rtype          IN       VARCHAR2,
      p_localisation   IN       VARCHAR2,
      p_fraisenv       IN       VARCHAR2,
      p_curseur        IN OUT   lib_listecontractuelcurtype
   )
   IS
   BEGIN
      IF p_rtype != p_fraisenv
      THEN
         OPEN p_curseur FOR
            --Ligne vide en haut
            SELECT mcont.code_contractuel,
                   mcont.code_contractuel || '  ' || mcont.libelle libel
              FROM mode_contractuel mcont
             WHERE 1 = 0;
      ELSE
         OPEN p_curseur FOR
            --Ligne vide en haut
            SELECT   mcont.code_contractuel,
                     mcont.code_contractuel || '  ' || mcont.libelle libel
                FROM mode_contractuel mcont
               WHERE mcont.code_localisation = p_localisation
                 AND mcont.type_ressource = p_rtype
                 AND mcont.top_actif = 'O'
            ORDER BY libel ASC;
      END IF;
   END lister_popup_contractuel_cont;


-- procedure pour les popup recherche MC (contrat) type logiciel et prestataire au temps passé
   PROCEDURE lister_mc_long_contrat (
      p_userid      IN       VARCHAR2,
      p_typfact   IN       VARCHAR2,
      p_rtype       IN       VARCHAR2,
      p_curseur     IN OUT   lib_listecontractuelcurtype
   )
   IS
   BEGIN


         OPEN p_curseur FOR



            SELECT   mcont.code_contractuel,
                        mcont.code_contractuel
                     || '  '
                     || mcont.libelle
                     || '  '
                     || loc.libelle
                     || '  '
                     || tress.rlib libel
                FROM mode_contractuel mcont,
                     localisation loc,
                     type_ress tress
               WHERE mcont.type_ressource = p_rtype
                 AND mcont.top_actif = 'O'
                 AND mcont.code_localisation = loc.code_localisation(+)
                 AND mcont.type_ressource = tress.rtype(+)
            ORDER BY loc.libelle DESC;


   END lister_mc_long_contrat;
END pack_liste_type;
/