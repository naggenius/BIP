-- ----------------------------------------------------------------------
-- pack_historique PL/SQL
--
-- EQUIPE SOPRA
--
--
-- Gestion des historiques
-- 
--
-- Quand       Qui   Nom                           Quoi
-- --------    ---   --------------------		----------------------------------------
-- 16/02/2000  MSA   select_nom_schema		creation
-- 17/02/2000  MSA   select_nom_schema		modification du nom (-> select_nom_schema_a_ecraser)
--                   select_nom_schema		creation
-- 22/02/2000  MSA   verif_codsg
-- 23/02/2000  MSA   verif_prodeta			recuperation depuis pack_verif_prodeta (prodeta.sql)
--			   verif_prohist			recuperation depuis pack_verif_prohist (prohist.sql)
--			   verif_reshist			recuperation depuis pack_verif_reshist (reshist.sql)
--
-- 28/03/2000  HTM   verif_prodec3			Vérification des paramètres état PRODEC3
--			   verif_prodecl			Vérification des paramètres état PRODECL
--
-- 28/03/2000  MSA   select_nom_schema		ajout de p_focus (nom du parametre dans la page html)
--								pour positionner correctement le focus
--								peut prendre les valeurs 'P_param6', 'P_param7', ...
--
-- 28/03/2000  MSA   verif_codsg			idem
--
-- 28/03/2000  MSA   verif_pid			creation
--
-- 16/07/2008  EVI   Suite migration oracle 10, probléme d'utilisation de la fonction dbms_sql ( remplacé par IMMEDIATE EXECUTE )
--05/01/2010 ABA TD 905
-- 23/12/2011  BSA QC 1281
-- 03/02/02 ABA verification sur historique ressource du perime_me uniquement si le dpg est renseigné
-- 10/04/2012 : ABA QC 1321
------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE     pack_historique AS


-- ------------------------------------------------------------------------
--
-- Nom         :  select_nom_schema_a_ecraser
-- Auteur      :  Equipe SOPRA (MSA)
-- Description :  récupération du nom du schema le plus ancien
--
-- Paramètres :
--                p_chemin_fichier  IN   repertoire ou il faut ecrire le fichier
--            p_nom_fichier     IN   nom du fichier devant contenir le nom du schema
--
-- Remarque :
--
-- ------------------------------------------------------------------------
   PROCEDURE select_nom_schema_a_ecraser( p_chemin_fichier  IN VARCHAR2,
                                          p_nom_fichier     IN VARCHAR2
                                         );


-- ------------------------------------------------------------------------
--
-- Nom         :  select_nom_schema
-- Auteur      :  Equipe SOPRA (MSA)
-- Description :  récupération du nom du schema pour une date donnee
--
-- Paramètres :
--                p_date         IN        date pour laquelle on veut le nom du schema
--                p_focus        IN        champ devant recevoir le focus en cas d'erreur
--                p_nom_schema  OUT        nom du schema correspondant à la date ci-dessus
--                p_message     OUT        message de sortie
--
-- Remarque :  p_nom_schema = '' si date en dehors de la plage M-14 -> M-1
--
-- ------------------------------------------------------------------------
   PROCEDURE select_nom_schema( p_date         IN VARCHAR2,
                                p_focus        IN VARCHAR2,
                                p_nom_schema   OUT VARCHAR2,
                                p_message      OUT VARCHAR2
                              );


-- ------------------------------------------------------------------------
--
-- Nom         : verif_codsg
-- Auteur      : Equipe SOPRA (MSA)
-- Description : Vérification du code DPG saisi
-- Paramètres  :
--              p_nom_schema   IN        Nom du schema
--              p_codsg        IN         Code DPG
--              p_focus        IN        champ devant recevoir le focus en cas d'erreur
--              p_message     OUT        Message de sortie
--
-- Remarque :
--
-- ------------------------------------------------------------------------
   PROCEDURE verif_codsg( p_nom_schema  IN VARCHAR2,
                          p_codsg       IN VARCHAR2,
                          p_focus       IN VARCHAR2,
                          p_message    OUT VARCHAR2
                        );


-- ------------------------------------------------------------------------
--
-- Nom         : verif_pid
-- Auteur      : Equipe SOPRA
-- Description : Vérification du code pid saisi
-- Paramètres  :
--              p_nom_schema  IN        Nom du schema
--              p_pid         IN         Code pid
--              p_focus       IN         Nom du champ devant recevoir le focus
--            p_message    OUT          Message de sortie
--
-- Remarque :
--
-- ------------------------------------------------------------------------

   PROCEDURE verif_pid( p_nom_schema  IN VARCHAR2,
                        p_pid         IN VARCHAR2,
                        p_focus       IN VARCHAR2,
                        p_message    OUT VARCHAR2
                      );


-- ------------------------------------------------------------------------
--
-- Nom        : verif_prodeta
-- Auteur     : Equipe SOPRA
-- Decription : Vérification des paramètres saisis pour l'etat $PRODETA
-- Paramètres :
--              p_mois_annee   IN        Mois et Année traitée
--              p_codsg        IN         Code DPG
--              p_pid          IN        Code ligne bip
--              p_nom_schema  OUT
--              p_message     OUT        Message de sortie
--
-- Remarque :
--
-- ------------------------------------------------------------------------
   PROCEDURE verif_prodeta( p_mois_annee   IN  VARCHAR2,        -- CHAR(7) (Format MM/AAAA)
                            p_codsg        IN  VARCHAR2,        -- CHAR(6)
                            p_pid          IN  VARCHAR2,        -- CHAR(3)
                            p_global       IN  VARCHAR2,
                            p_nom_schema  OUT  VARCHAR2,
                            p_message     OUT  VARCHAR2
                          );



-- ------------------------------------------------------------------------
--
-- Nom         : verif_prohist
-- Auteur      : Equipe SOPRA
-- Description : Vérification des paramètres saisis pour l'etat $PROHIST
-- Paramètres  :
--              p_mois_annee   IN        Mois et Année traitée
--              p_codsg        IN         Code DPG
--              p_factpid      IN        Code ligne bip
--              p_nom_schema  OUT
--              p_message     OUT        Message de sortie
--
-- Remarque :
--
-- ------------------------------------------------------------------------
   PROCEDURE verif_prohist( p_mois_annee   IN  VARCHAR2,        -- CHAR(7) (Format MM/AAAA)
                            p_codsg        IN  VARCHAR2,        -- CHAR(6)
                            p_factpid      IN  VARCHAR2,        -- CHAR(3)
                            p_global       IN  VARCHAR2,
                            p_nom_schema  OUT  VARCHAR2,
                            p_message     OUT  VARCHAR2
                          );



-- ------------------------------------------------------------------------
--
-- Nom        : verif_reshist
-- Auteur     : Equipe SOPRA
-- Decription : Vérification des paramètres saisis pour l'etat $PRODETA
-- Paramètres :
--              p_mois_annee   IN        Mois et Année traitée
--              p_codsg        IN         Code DPG
--              p_tires        IN        Code ressource
--              p_nom_schema  OUT
--              p_message     OUT        Message de sortie
--
-- Remarque :
--
-- ------------------------------------------------------------------------
   PROCEDURE verif_reshist( p_mois_annee   IN  VARCHAR2,        -- CHAR(7) (Format MM/AAAA)
                            p_codsg        IN  VARCHAR2,        -- CHAR(6)
                            p_tires        IN  VARCHAR2,        -- CHAR(3)
                            p_global       IN  VARCHAR2,
                            p_nom_schema  OUT  VARCHAR2,
                            p_message     OUT  VARCHAR2
                          );



-- ------------------------------------------------------------------------
-- Nom        : verif_prodec3 (Prend en compte le concept d'historique)
-- Auteur     : Equipe SOPRA
-- Decription : Vérification des champs saisies dans la page WEB pour PRODEC3
-- Paramètres :
--             p_nom_etat     IN  VARCHAR2,
--               p_mois_annee   IN  VARCHAR2,                -- CHAR(7) (Format MM/AAAA)
--               p_codsg        IN  VARCHAR2,               -- CHAR(6)
--               p_nom_schema  OUT  VARCHAR2,
--               p_message     OUT VARCHAR2
--
-- ------------------------------------------------------------------------
PROCEDURE verif_prodec3( p_nom_etat     IN  VARCHAR2,
                         p_mois_annee   IN  VARCHAR2,            -- CHAR(7) (Format MM/AAAA)
                         p_codsg        IN  VARCHAR2,             -- CHAR(6)
                         p_global       IN  VARCHAR2,
                         p_nom_schema  OUT  VARCHAR2,
                         p_message     OUT  VARCHAR2
                       );



-- ------------------------------------------------------------------------
-- Nom        : verif_prodecl (Prend en compte le concept d'historique)
-- Auteur     : Equipe SOPRA
-- Decription : Vérification des champs saisies dans la page WEB pour PRODECL
-- Paramètres :
--             p_nom_etat     IN  VARCHAR2,
--               p_mois_annee   IN  VARCHAR2,                -- CHAR(7) (Format MM/AAAA)
--               p_codsg        IN  VARCHAR2,               -- CHAR(6)
--               p_pid          IN  VARCHAR2,               -- CHAR(6)
--               p_nom_schema  OUT  VARCHAR2,
--               p_message     OUT  VARCHAR2
--
-- ------------------------------------------------------------------------
PROCEDURE verif_prodecl( p_nom_etat     IN  VARCHAR2,
                         p_mois_annee   IN  VARCHAR2,         -- CHAR(7) (Format MM/AAAA)
                         p_codsg        IN  VARCHAR2,          -- CHAR(7)
                         p_pid          IN  VARCHAR2,          -- CHAR(3)
                         p_global       IN  VARCHAR2,
                         p_nom_schema  OUT  VARCHAR2,
                         p_message     OUT  VARCHAR2
                 );
                 

PROCEDURE VERIF_PROFIL_FI_HIST( p_mois_annee   IN  VARCHAR2,        -- CHAR(7) (Format MM/AAAA)
                         p_global       IN  VARCHAR2,
                         p_nom_schema  OUT  VARCHAR2,
                         p_message     OUT  VARCHAR2
                       );

END pack_historique ;
/


CREATE OR REPLACE PACKAGE BODY     pack_historique AS

-------------------------------------------------------------------
--
------------------------------------------------------------------

   PROCEDURE select_nom_schema_a_ecraser( p_chemin_fichier  IN VARCHAR2,
                                          p_nom_fichier     IN VARCHAR2
                                        ) IS

    l_nom_schema    ref_histo.nom_schema%TYPE;
    l_hfile        utl_file.file_type;

   BEGIN

    SELECT  LOWER(nom_schema)
    INTO      l_nom_schema
    FROM      ref_histo
    WHERE      mois = ( SELECT min(RH2.mois) FROM ref_histo RH2 ) ;

      PACK_GLOBAL.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);

    PACK_GLOBAL.WRITE_STRING( l_hfile, l_nom_schema );

      PACK_GLOBAL.CLOSE_WRITE_FILE(l_hfile);

   EXCEPTION
     WHEN OTHERS THEN
        raise_application_error(-20997, SQLERRM);

   END select_nom_schema_a_ecraser;


-------------------------------------------------------------------
--
------------------------------------------------------------------

   PROCEDURE select_nom_schema( p_date         IN VARCHAR2,
                                p_focus        IN VARCHAR2,
                                p_nom_schema   OUT VARCHAR2,
                                p_message      OUT VARCHAR2
                              ) IS

    l_min_mois    VARCHAR2(10);
    l_max_mois    VARCHAR2(10);

   BEGIN

    BEGIN
       SELECT  nom_schema
       INTO    p_nom_schema
       FROM    ref_histo
       WHERE   mois = to_date(p_date,'MM/YYYY') ;

    EXCEPTION
       WHEN NO_DATA_FOUND THEN
        SELECT  to_char(min(mois),'MM/YYYY')
        INTO    l_min_mois
        FROM    ref_histo;

        SELECT  to_char(max(mois),'MM/YYYY')
        INTO    l_max_mois
        FROM    ref_histo;

        -- Message de la forme : 'Le mois de traitement doit être compris entre --- et ---'
        pack_global.recuperer_message(20950, '%s1', l_min_mois, '%s2', l_max_mois, p_focus, p_message);

       WHEN OTHERS THEN
        raise_application_error(-20997,SQLERRM);
    END;

   EXCEPTION
    WHEN OTHERS THEN
       raise_application_error(-20997,SQLERRM);

   END select_nom_schema;



-- ------------------------------------------------------------------------
--
-- Nom         : verif_codsg
-- Auteur      : Equipe SOPRA (MSA)
-- Description : Vérification du code DPG saisi
-- Paramètres  :
--              p_nom_schema   IN        Nom du schema
--              p_codsg        IN         Code DPG
--              p_focus        IN        champ devant recevoir le focus en cas d'erreur
--              p_message     OUT        Message de sortie
--
-- Remarque :
--
-- ------------------------------------------------------------------------

   PROCEDURE verif_codsg( p_nom_schema  IN VARCHAR2,
                          p_codsg       IN VARCHAR2,
                          p_focus       IN VARCHAR2,
                          p_message    OUT VARCHAR2
                        ) IS

    CID        INTEGER;
    l_requete   VARCHAR2(250) := '';
    l_FmtCharDPG VARCHAR2(10) := '';

    nb_codsg        NUMBER ;

   BEGIN

    ---------------------------------------------------------------------------------------------
    -- Vérification existence Code DPG dans la table des DPG (Table struct_info)
    -- Commentaire 28/08/2003 : Pierre JOSSE
    -- Les parties de test sur 6 caractères pourront être enlevées une fois qu'il
    -- n'y aura plus d'hitoriques au format Number(6) pour les DPG
    ---------------------------------------------------------------------------------------------

    IF ( ( p_codsg IS NOT NULL ) AND ( p_codsg != '*******' ) AND ( p_codsg != '       ' ) AND ( p_codsg != '******' ) AND ( p_codsg != '      ' ) )
    THEN

       BEGIN
        --
        -- Ouverture du curseur et récupération de l'ID
        --


        --------------------------------------------------
        -- Définition du format demandé.
        --------------------------------------------------
           IF (length(p_codsg) = 7) THEN
               l_FmtCharDPG := 'FM0000000';
           ELSE
               l_FmtCharDPG := 'FM000000';
           END IF;


        -- p_codsg peut avoir une valeur = '01313**' ou '0131312' ou '01312  ' (avec des blancs) ou '1313**' ou '131312' ou '1312  '
        -- S'il possede un metacaractere (' ', '*'), on va le supprimer
        -- Puis former la condition Where du Select en fonction de la longueur de p_codsg
        --
        -- SELECT  codsg
        -- INTO    l_codsg
        -- FROM    struct_info
        -- WHERE   substr(to_char(codsg,'FM0000000'),1,length(rtrim(rtrim(p_codsg,'*')))) = rtrim(rtrim(p_codsg,'*'))
        -- AND     ROWNUM <= 1;
          --
         /*l_requete    :=  'SELECT   codsg'
                ||  ' FROM    struct_info_' || p_nom_schema || '@linkhisto'
                ||  ' WHERE   substr(to_char(codsg,''' || l_FmtCharDPG || '''),1,length(rtrim(rtrim(''' || p_codsg || ''',''*'')))) = rtrim(rtrim(''' || p_codsg || ''',''*''))' ;

        */

         l_requete   :=  'SELECT   COUNT(*)  '
                ||      ' FROM    BIPH.struct_info_' || p_nom_schema
                ||      ' WHERE   substr(to_char(codsg,''' || l_FmtCharDPG || '''),1,length(rtrim(rtrim(''' || p_codsg || ''',''*'')))) = rtrim(rtrim(''' || p_codsg || ''',''*''))' ;

         EXECUTE IMMEDIATE l_requete INTO nb_codsg ;

        IF ( nb_codsg = 0)
        THEN
           pack_global.recuperer_message(pack_utile_numsg.nuexc_coddpg_invalide3, '%s1', p_codsg, p_focus, p_message);
        END IF;



       EXCEPTION
        WHEN OTHERS THEN

           raise;

       END;

    END IF;

   END verif_codsg;







-- ------------------------------------------------------------------------
--
-- Nom         : verif_pid
-- Auteur      : Equipe SOPRA
-- Description : Vérification du code pid saisi
-- Paramètres  :
--              p_nom_schema  IN        Nom du schema
--              p_pid         IN         Code pid
--              p_focus       IN         Nom du champ devant recevoir le focus
--            p_message    OUT          Message de sortie
--
-- Remarque :
--
-- ------------------------------------------------------------------------

   PROCEDURE verif_pid( p_nom_schema  IN VARCHAR2,
                        p_pid         IN VARCHAR2,
                        p_focus       IN VARCHAR2,
                        p_message    OUT VARCHAR2
                      ) IS

    CID        INTEGER;
    l_requete   VARCHAR2(250) := '';
    nb_pid NUMBER;

   BEGIN

    ---------------------------------------------------------------------------------------------
    -- Vérification existence Code ligne BIP dans LIGNE_BIP
    ---------------------------------------------------------------------------------------------

    IF ( p_pid IS NOT NULL )
    THEN
       BEGIN
        --
        -- Ouverture du curseur et récupération de l'ID
        --
        --CID := DBMS_SQL.OPEN_CURSOR;

        l_requete    :=  'SELECT COUNT(*) '
                ||  ' FROM   BIPH.ligne_bip_' || p_nom_schema
                ||  ' WHERE  pid = ''' || p_pid || '''' ;

        -- DEMS_SQL incompatible sous cette forme en oracle 10
        --DBMS_SQL.PARSE( CID, l_requete, DBMS_SQL.V7 );
        EXECUTE IMMEDIATE l_requete INTO nb_pid;

        IF ( nb_pid = 0 )
        THEN
           pack_global.recuperer_message(pack_utile_numsg.nuexc_codligne_bip_inexiste, '%s1', p_pid , p_focus, p_message);
        END IF;

        --DBMS_SQL.CLOSE_CURSOR( CID );

       EXCEPTION
        WHEN OTHERS THEN
          -- DBMS_SQL.CLOSE_CURSOR( CID );
           raise_application_error(-20997,SQLERRM);
       END;

      END IF;


   END verif_pid;


-- ------------------------------------------------------------------------
--
-- Nom        : verif_prodeta
-- Auteur     : Equipe SOPRA
-- Decription : Vérification des paramètres saisis pour l'etat $PRODETA
-- Paramètres :
--              p_mois_annee  (IN)        Mois et Année traitée
--              p_codsg       (IN)         Code DPG
--              p_pid IN      (IN)        Code ligne bip
--              p_nom_schema  OUT
--            p_message     OUT         Message de sortie
--
-- Remarque :
--
-- Quand        Qui      Quoi
-- -----        ---      --------------------------------------------------------
-- 25/01/00      HTM  Ajout contrôle existence code ligne BIP saisi
-- 23/02/2000    MSA    Adaptation au concept d'historique
-- ------------------------------------------------------------------------

   PROCEDURE verif_prodeta( p_mois_annee   IN  VARCHAR2,        -- CHAR(7) (Format MM/AAAA)
                            p_codsg        IN  VARCHAR2,        -- CHAR(7)
                            p_pid          IN  VARCHAR2,        -- CHAR(3)
                            p_global       IN  VARCHAR2,
                            p_nom_schema  OUT  VARCHAR2,
                            p_message     OUT  VARCHAR2
                          ) IS

    l_message        VARCHAR2(1024) := '';
    l_message2        VARCHAR2(1024) := '';
    l_nom_schema    ref_histo.nom_schema%TYPE;

   BEGIN
    ---------------------------------------------------------------------------------------------
    -- (1) Vérification date et récupération du nom du schéma
    ---------------------------------------------------------------------------------------------
    pack_historique.select_nom_schema(p_mois_annee, 'P_param6', l_nom_schema, l_message );


    ---------------------------------------------------------------------------------------------
    -- (2) Vérification CODSG
    ---------------------------------------------------------------------------------------------
    IF (l_nom_schema IS NOT NULL) THEN
       pack_historique.verif_codsg(l_nom_schema, p_codsg, 'P_param7', l_message );
    END IF;


    ---------------------------------------------------------------------------------------------
    -- (3) Vérification existence Code ligne BIP dans LIGNE_BIP
    ---------------------------------------------------------------------------------------------
    IF ( (l_nom_schema IS NOT NULL) AND (l_message IS NULL) AND (p_pid <> 'Tout') ) THEN
       pack_historique.verif_pid(l_nom_schema, p_pid, 'P_param8', l_message );
    END IF;

    ---------------------------------------------------------------------------------------------
    -- (4) Vérification PERIM ME
    ---------------------------------------------------------------------------------------------
    pack_habilitation.verif_habili_me( p_codsg,p_global, l_message2 );


    p_message    := l_message;
    p_nom_schema := 'NOM_SCHEMA#' || l_nom_schema;


   EXCEPTION
    WHEN OTHERS THEN
       raise_application_error(-20997, SQLERRM);

   END verif_prodeta;



-- ------------------------------------------------------------------------
--
-- Nom        : verif_prohist
-- Auteur     : Equipe SOPRA
-- Decription : Vérification des paramètres saisis pour l'etat $PROHIST
-- Paramètres :
--              p_mois_annee  IN        Mois et Année traitée
--              p_codsg       IN         Code DPG
--              p_factpid     IN        Code ligne bip
--              p_nom_schema  OUT
--            P_message    OUT             Message de sortie
--
-- Remarque :
--
-- Quand        Qui      Quoi
-- -----        ---      --------------------------------------------------------
-- 25/01/2000      HTM    Ajout contrôle existence code ligne BIP saisi
-- 23/02/2000    MSA    Adaptation au concept d'historique
-- ------------------------------------------------------------------------


   PROCEDURE verif_prohist( p_mois_annee   IN  VARCHAR2,        -- CHAR(7) (Format MM/AAAA)
                            p_codsg        IN  VARCHAR2,        -- CHAR(7)
                            p_factpid      IN  VARCHAR2,        -- CHAR(3)
                            p_global       IN  VARCHAR2,
                            p_nom_schema  OUT  VARCHAR2,
                            p_message     OUT  VARCHAR2
                          ) IS

    l_message        VARCHAR2(1024) := '';
    l_message2         VARCHAR2(1024) := '';
    l_nom_schema    ref_histo.nom_schema%TYPE;
      l_count        NUMBER := 0;
    CID            INTEGER;
    l_requete        VARCHAR2(250) := '';
    nb_pid  NUMBER;

   BEGIN
    ---------------------------------------------------------------------------------------------
    -- (1) Vérification date et récupération du nom du schéma
    ---------------------------------------------------------------------------------------------
    pack_historique.select_nom_schema(p_mois_annee, 'P_param6', l_nom_schema, l_message );


    ---------------------------------------------------------------------------------------------
    -- (2) Vérification CODSG
    ---------------------------------------------------------------------------------------------
    IF (l_nom_schema IS NOT NULL) THEN
       pack_historique.verif_codsg(l_nom_schema, p_codsg, 'P_param7', l_message );
    END IF;


    ---------------------------------------------------------------------------------------------
    -- (3) Vérification existence Code ligne BIP dans PROPLUS
    ---------------------------------------------------------------------------------------------
    IF ( (l_nom_schema IS NOT NULL) AND (l_message IS NULL) AND (LENGTH(p_factpid) != 0) AND (p_factpid != 'Tout') )
    THEN
        BEGIN

        l_requete    :=  'SELECT  count(*)'
                ||  ' FROM   BIPH.proplus_' || l_nom_schema
                ||  ' WHERE  factpid = ''' || p_factpid || '''' ;


        EXECUTE IMMEDIATE l_requete INTO nb_pid ;

        IF ( nb_pid = 0 )
        THEN
            pack_global.recuperer_message(21164,NULL,NULL, NULL, l_message);

        END IF;

       EXCEPTION
        WHEN OTHERS THEN
           raise_application_error(-20997,SQLERRM);
       END;

    END IF;

    ---------------------------------------------------------------------------------------------
    -- (4) Vérification PERIM ME
    ---------------------------------------------------------------------------------------------
    pack_habilitation.verif_habili_me( p_codsg,p_global, l_message2 );


    p_message    := l_message;
    p_nom_schema := 'NOM_SCHEMA#' || l_nom_schema;

   EXCEPTION
    WHEN OTHERS THEN
       raise_application_error(-20997, SQLERRM);

   END verif_prohist;



-- ------------------------------------------------------------------------
--
-- Nom        : verif_reshist
-- Auteur     : Equipe SOPRA
-- Decription : Vérification des paramètres saisis pour l'etat $PRODETA
-- Paramètres :
--              p_mois_annee   IN        Mois et Année traitée
--              p_codsg        IN         Code DPG
--              p_tires        IN         Code ressource
--              p_nom_schema  OUT
--            p_message     OUT         Message de sortie
--
-- Remarque :
--
-- ------------------------------------------------------------------------

   PROCEDURE verif_reshist( p_mois_annee   IN  VARCHAR2,        -- CHAR(7) (Format MM/AAAA)
                            p_codsg        IN  VARCHAR2,        -- CHAR(7)
                            p_tires        IN  VARCHAR2,        -- CHAR(3)
                            p_global       IN  VARCHAR2,
                            p_nom_schema  OUT  VARCHAR2,
                            p_message     OUT  VARCHAR2
                          ) IS

    l_message         VARCHAR2(1024) := '';
    l_message2         VARCHAR2(1024) := '';
    l_nom_schema    ref_histo.nom_schema%TYPE;

   BEGIN
    ---------------------------------------------------------------------------------------------
    -- (1) Vérification date et récupération du nom du schéma
    ---------------------------------------------------------------------------------------------
    pack_historique.select_nom_schema(p_mois_annee, 'P_param6', l_nom_schema, l_message );


    ---------------------------------------------------------------------------------------------
    -- (2) Vérification CODSG
    ---------------------------------------------------------------------------------------------
    IF (l_nom_schema IS NOT NULL) THEN
       pack_historique.verif_codsg(l_nom_schema, p_codsg, 'P_param7', l_message );
    END IF;

    ---------------------------------------------------------------------------------------------
    -- (3) Vérification PERIM ME
       IF (p_codsg IS NOT NULL) THEN
            pack_habilitation.verif_habili_me( p_codsg,p_global, l_message2 );
       END IF;
    p_message    := l_message;
    p_nom_schema := 'NOM_SCHEMA#' || l_nom_schema;

   EXCEPTION
    WHEN OTHERS THEN
    p_message    := l_message;
    p_nom_schema := 'NOM_SCHEMA#' || l_nom_schema;
       raise_application_error(-20997, SQLERRM);

   END verif_reshist;



-- ------------------------------------------------------------------------
-- Nom        : verif_prodec3 (Prend en compte le concept d'historique)
-- Auteur     : Equipe SOPRA
-- Decription : Vérification des champs saisies dans la page WEB pour PRODEC3
-- Paramètres :
--             p_nom_etat     IN  VARCHAR2,
--               p_mois_annee   IN  VARCHAR2,                -- CHAR(7) (Format MM/AAAA)
--               p_codsg        IN  VARCHAR2,               -- CHAR(7)
--               p_nom_schema  OUT  VARCHAR2,
--               p_message     OUT VARCHAR2
--
-- ------------------------------------------------------------------------
PROCEDURE verif_prodec3( p_nom_etat    IN  VARCHAR2,
                         p_mois_annee  IN  VARCHAR2,         -- CHAR(7) (Format MM/AAAA)
                         p_codsg       IN  VARCHAR2,          -- CHAR(7)
                         p_global       IN  VARCHAR2,
                         p_nom_schema OUT  VARCHAR2,
                         p_message    OUT  VARCHAR2
                       ) IS

      l_message       VARCHAR2(1024) := '';
      l_message2       VARCHAR2(1024) := '';
    l_nom_schema    ref_histo.nom_schema%TYPE;

BEGIN

    ---------------------------------------------------------------------------------------------
    -- (1) Vérification date et récupération du nom du schéma
    ---------------------------------------------------------------------------------------------
    pack_historique.select_nom_schema(p_mois_annee, 'P_param7', l_nom_schema, l_message );


    ---------------------------------------------------------------------------------------------
    -- (2) Vérification existence Code DPG dans la table des DPG du schéma (Table <l_nom_schema>.struct_info))
    ---------------------------------------------------------------------------------------------
    IF (l_nom_schema IS NOT NULL) THEN
       pack_historique.verif_codsg(l_nom_schema, p_codsg, 'P_param8', l_message );
    END IF;

    ---------------------------------------------------------------------------------------------
    -- (3) Vérification PERIM ME
    ---------------------------------------------------------------------------------------------
    pack_habilitation.verif_habili_me( p_codsg,p_global, l_message2 );

      p_message    := l_message;
    p_nom_schema := 'NOM_SCHEMA#' || l_nom_schema;


   EXCEPTION
    WHEN OTHERS THEN
       raise_application_error(-20997, SQLERRM);


END  verif_prodec3;



-- ------------------------------------------------------------------------
-- Nom        : verif_prodecl (Prend en compte le concept d'historique)
-- Auteur     : Equipe SOPRA
-- Decription : Vérification des champs saisies dans la page WEB pour PRODECL
-- Paramètres :
--             p_nom_etat     IN  VARCHAR2,
--               p_mois_annee   IN  VARCHAR2,                -- CHAR(7) (Format MM/AAAA)
--               p_codsg        IN  VARCHAR2,               -- CHAR(7)
--               p_pid          IN  VARCHAR2,               -- VARCHAR2(4)
--               p_nom_schema  OUT  VARCHAR2,
--               p_message     OUT  VARCHAR2
--
-- ------------------------------------------------------------------------
PROCEDURE verif_prodecl(
                        p_nom_etat     IN  VARCHAR2,
                        p_mois_annee   IN  VARCHAR2,         -- CHAR(7) (Format MM/AAAA)
                        p_codsg        IN  VARCHAR2,          -- CHAR(7)
                        p_pid          IN  VARCHAR2,          -- VARCHAR2(4)
                        p_global IN  VARCHAR2,
                        p_nom_schema  OUT  VARCHAR2,
                        p_message     OUT  VARCHAR2
                 ) IS

    l_message        VARCHAR2(1024) := '';
    l_message2        VARCHAR2(1024) := '';
    l_nom_schema    ref_histo.nom_schema%TYPE;


   BEGIN
    ---------------------------------------------------------------------------------------------
    -- (1) Vérification date et récupération du nom du schéma
    ---------------------------------------------------------------------------------------------
    pack_historique.select_nom_schema(p_mois_annee, 'P_param7', l_nom_schema, l_message );


    ---------------------------------------------------------------------------------------------
    -- (2) Vérification CODSG
    ---------------------------------------------------------------------------------------------
    IF (l_nom_schema IS NOT NULL) THEN
       pack_historique.verif_codsg(l_nom_schema, p_codsg, 'P_param8', l_message );
    END IF;


    ---------------------------------------------------------------------------------------------
    -- (3) Vérification existence Code ligne BIP dans LIGNE_BIP
    ---------------------------------------------------------------------------------------------
    IF ( (l_nom_schema IS NOT NULL) AND (l_message IS NULL) AND (p_pid <> 'Tout') ) THEN
       pack_historique.verif_pid(l_nom_schema, p_pid, 'P_param9', l_message );
    END IF;

    ---------------------------------------------------------------------------------------------
    -- (4) Vérification PERIM ME
    ---------------------------------------------------------------------------------------------
    pack_habilitation.verif_habili_me( p_codsg,p_global, l_message2 );


    p_message    := l_message;
    p_nom_schema := 'NOM_SCHEMA#' || l_nom_schema;


   EXCEPTION
    WHEN OTHERS THEN
       raise_application_error(-20997, SQLERRM);

   END  verif_prodecl;

PROCEDURE VERIF_PROFIL_FI_HIST( p_mois_annee   IN  VARCHAR2,        -- CHAR(7) (Format MM/AAAA)
                         p_global       IN  VARCHAR2,
                         p_nom_schema  OUT  VARCHAR2,
                         p_message     OUT  VARCHAR2
                       ) IS
              
             l_message        VARCHAR2(1024) := '';
               l_nom_schema    ref_histo.nom_schema%TYPE;
BEGIN            
     ---------------------------------------------------------------------------------------------
    -- (1) Vérification date et récupération du nom du schéma
    ---------------------------------------------------------------------------------------------
    pack_historique.select_nom_schema(p_mois_annee, 'P_param9', l_nom_schema, l_message );


          p_message    := l_message;
    p_nom_schema := 'NOM_SCHEMA#' || l_nom_schema;                 
                       
END VERIF_PROFIL_FI_HIST;

END pack_historique ;
/


