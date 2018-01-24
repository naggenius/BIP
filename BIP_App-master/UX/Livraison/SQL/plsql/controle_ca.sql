-- PACK_CONTROLE_CA PL/SQL
--
-- 
--
-- cree  le 17/06/2011  par BSA
--
-- Attention le nom du package ne peut etre le nom
-- de la table...
-- Il est tres important de laisser un return apres
-- le dernier '/' du fichier.
-- BSA 29/03/2012 : suite QC 1367 amelioration + correction ano
-- BSA 04/04/2012 : suite QC 1368
-- BSA 20/04/2012 : suite QC 1368 : ajout filtre sur repartition en vigueur

-- 

CREATE OR REPLACE PACKAGE     PACK_CONTROLE_CA AS


TYPE Controle_Ca_ViewType IS RECORD (   TYPECAMO        VARCHAR2(10),
                                        CODCAMO            NUMBER (6),
                                        CLIBRCA            VARCHAR2 (16),
                                        CDATE_CESSATION DATE,
                                        ICPI            CHAR (5),
                                        ILIBEL            VARCHAR2 (50),
                                        CODSG            NUMBER (7),
                                        LIBDSG            VARCHAR2 (30),
                                        PID                VARCHAR2 (4),
                                        PRIORITE        NUMBER (1),
                                        DATE_CREATION    DATE
                                     );



TYPE Controle_Ca_CurType_Char IS REF CURSOR RETURN Controle_Ca_ViewType;

FUNCTION get_annee_dbex RETURN VARCHAR2;

FUNCTION is_rejet ( p_dateferm_camo DATE, p_date_statut_ligne DATE) RETURN BOOLEAN;

   PROCEDURE insertion_tmp_camo (p_annee        IN NUMBER,
                                 p_codcamo      IN NUMBER,
                                 p_clibrca      IN VARCHAR2,
                                 p_dateferm     IN VARCHAR2, 
                                 p_codsg        IN VARCHAR2,
                                 p_libdsg       IN VARCHAR2, 
                                 p_pid          IN VARCHAR2, 
                                 p_pid_ligne    IN VARCHAR2, 
                                 p_typproj      IN VARCHAR2,
                                 p_cas          IN NUMBER) ;

   PROCEDURE insertion_tmp_camo_rep (p_annee        IN NUMBER,
                                     p_codcamo      IN NUMBER,
                                     p_clibrca      IN VARCHAR2,
                                     p_dateferm     IN VARCHAR2, 
                                     p_codsg        IN VARCHAR2,
                                     p_libdsg       IN VARCHAR2, 
                                     p_pid          IN VARCHAR2,
                                     p_pid_ligne    IN VARCHAR2, 
                                     p_typproj      IN VARCHAR2,
                                     p_cas          IN NUMBER) ;
                                 
   PROCEDURE controle_camo (p_message   OUT VARCHAR2
                                );

   PROCEDURE controle_metier (p_message   OUT VARCHAR2
                                );
                                
   PROCEDURE controle_cada (p_message   OUT VARCHAR2
                                );

   PROCEDURE controle_ressource (p_message   OUT VARCHAR2
                                );

   PROCEDURE controle_ca;

 PROCEDURE select_controle_ca ( p_curStruct_info      IN OUT Controle_Ca_CurType_Char);

END PACK_CONTROLE_CA;
/


CREATE OR REPLACE PACKAGE BODY     PACK_CONTROLE_CA AS


    FUNCTION get_annee_dbex RETURN VARCHAR2 IS

        l_annee   VARCHAR2(4);

    BEGIN

        SELECT TO_CHAR(datdebex, 'YYYY') INTO l_annee from datdebex WHERE ROWNUM < 2;

        RETURN l_annee;

    END get_annee_dbex;


    FUNCTION is_rejet ( p_dateferm_camo DATE, p_date_statut_ligne DATE) RETURN BOOLEAN IS

        t_retour    BOOLEAN;

    BEGIN

        t_retour := FALSE;
        
        IF p_dateferm_camo IS NOT NULL THEN
            IF p_date_statut_ligne IS NULL THEN                                
                t_retour := TRUE;                    
            ELSE                
                IF TO_CHAR(p_date_statut_ligne,'YYYYMMDD') > TO_CHAR(p_dateferm_camo,'YYYYMMDD') THEN
                    t_retour := TRUE;
                END IF;                    
            END IF;
        END IF;

        RETURN t_retour;

    END is_rejet;
    
   PROCEDURE insertion_tmp_camo (p_annee        IN NUMBER,
                                 p_codcamo      IN NUMBER,
                                 p_clibrca      IN VARCHAR2,
                                 p_dateferm     IN VARCHAR2, 
                                 p_codsg        IN VARCHAR2,
                                 p_libdsg       IN VARCHAR2, 
                                 p_pid          IN VARCHAR2, 
                                 p_pid_ligne    IN VARCHAR2, 
                                 p_typproj      IN VARCHAR2,
                                 p_cas          IN NUMBER) IS

--SEL PPM 58986 : prendre le consomme sur l annee civile
      CURSOR c_consomme IS
        SELECT SUM(NVL(p.CUSAG,0)) CUSAG
        FROM PROPLUS p


        WHERE TO_CHAR(p.CDEB,'YYYY') = p_annee AND p.PID = p_pid;
     t_consomme  c_consomme%ROWTYPE;
     
     t_priorite     NUMBER;
     
    BEGIN

      OPEN c_consomme;
      FETCH c_consomme INTO t_consomme;
      IF c_consomme%FOUND THEN
          IF NVL(t_consomme.CUSAG,-1) > 0 THEN
              t_priorite := 1;
          ELSE
              t_priorite := 0;
          END IF;
      ELSE
          t_priorite := 0;
      END IF;

      CLOSE c_consomme;
      -- Insertion dans la table temporaire
      INSERT INTO TMP_CONTROLE_CA (TYPECAMO,
                                   CODCAMO,
                                   CLIBRCA,
                                   CDATE_CESSATION,
                                   CODSG,
                                   LIBDSG,
                                   PID,
                                   PID_LIGNE,
                                   PRIORITE,
                                   DATE_CREATION,
                                   TYPE_LIGNE_PROJ,
                                   CAS)
                           VALUES ('CAMO',
                                   p_codcamo,
                                   p_clibrca,
                                   p_dateferm,
                                   p_codsg,
                                   p_libdsg,
                                   p_pid,
                                   p_pid_ligne,
                                   t_priorite,
                                   SYSDATE,
                                   p_typproj,
                                   p_cas  );

    
        EXCEPTION

            WHEN OTHERS THEN
              raise_application_error( -20997, SQLERRM);

    END insertion_tmp_camo;

   PROCEDURE insertion_tmp_camo_rep (p_annee        IN NUMBER,
                                     p_codcamo      IN NUMBER,
                                     p_clibrca      IN VARCHAR2,
                                     p_dateferm     IN VARCHAR2, 
                                     p_codsg        IN VARCHAR2,
                                     p_libdsg       IN VARCHAR2, 
                                     p_pid          IN VARCHAR2,
                                     p_pid_ligne    IN VARCHAR2, 
                                     p_typproj      IN VARCHAR2,
                                     p_cas          IN NUMBER) IS
                                     
--SEL PPM 58986 : prendre en compte le consomme de l annee civile
    CURSOR c_consomme IS
      SELECT SUM(NVL(r.CONSOJH,0)) CONSOJH
      FROM RJH_CONSOMME r
      WHERE TO_CHAR(r.CDEB,'YYYY') = p_annee AND r.PID = p_pid;



    t_consomme  c_consomme%ROWTYPE;
     
    t_priorite     NUMBER;
     
    BEGIN

      OPEN c_consomme;
      FETCH c_consomme INTO t_consomme;
      IF c_consomme%FOUND THEN
          IF NVL(t_consomme.CONSOJH,-1) > 0 THEN
              t_priorite := 1;
          ELSE
              t_priorite := 0;
          END IF;
      ELSE
          t_priorite := 0;
      END IF;

      CLOSE c_consomme;
      -- Insertion dans la table temporaire
      INSERT INTO TMP_CONTROLE_CA (TYPECAMO,
                                   CODCAMO,
                                   CLIBRCA,
                                   CDATE_CESSATION,
                                   CODSG,
                                   LIBDSG,
                                   PID,
                                   PID_LIGNE,
                                   PRIORITE,
                                   DATE_CREATION,
                                   TYPE_LIGNE_PROJ,
                                   CAS)
                           VALUES ('CAMO',
                                   p_codcamo,
                                   p_clibrca,
                                   p_dateferm,
                                   p_codsg,
                                   p_libdsg,
                                   p_pid,
                                   p_pid_ligne,
                                   t_priorite,
                                   SYSDATE,
                                   p_typproj,
                                   p_cas  );

    
        EXCEPTION

            WHEN OTHERS THEN
              raise_application_error( -20997, SQLERRM);

    END insertion_tmp_camo_rep;

PROCEDURE controle_camo (p_message   OUT VARCHAR2
                                ) IS

    
    l_annee   VARCHAR2(4);

    --SEL  PPM 58986 
    --Ligne actif au sens FI
    CURSOR c_ligne_actif IS
        SELECT c.CDATEFERM, l.ADATESTATUT, l.PID, l.ICPI,
               p.ILIBEL, l.CODSG, s.LIBDSG, c.CLIBRCA, c.CODCAMO, l.TYPPROJ,
               l.CODREP
        FROM centre_activite c
            INNER JOIN ligne_bip l ON c.CODCAMO = l.CODCAMO
            INNER JOIN PROJ_INFO p ON p.ICPI = l.ICPI
            INNER JOIN STRUCT_INFO s ON s.CODSG = l.CODSG

        WHERE (
      /*  
      TO_CHAR(l.ADATESTATUT,'YYYYMM') <= l_annee  || '11'
                AND TO_CHAR(l.ADATESTATUT,'YYYYMM') >= (l_annee -1)|| '12'*/
                
              TO_CHAR(l.ADATESTATUT,'YYYY') = l_annee
                
                )
              OR l.ADATESTATUT IS NULL;

    t_ligne_actif   c_ligne_actif%ROWTYPE;
    
    t_priorite      NUMBER;
    t_rejet         BOOLEAN;

    -- Recherche des lignes reparti en fonction d'un codrep
    -- sur la période concerné dec annee -1 et novembre annee en cours 
    -- pour les codes camo = 66666 
    CURSOR c_camo_rjh_repartition ( t_codrep LIGNE_BIP.CODREP%TYPE ) IS
        SELECT DISTINCT l.CODCAMO, d.PID, c.CDATEFERM , l.CODSG, s.LIBDSG, l.TYPPROJ, c.CLIBRCA
        FROM RJH_TABREPART_DETAIL d , LIGNE_BIP l, centre_activite c, STRUCT_INFO s
        WHERE 1 = 1
            AND s.CODSG = l.CODSG
            AND c.CODCAMO = l.CODCAMO
            AND l.PID = d.PID
            AND d.CODREP = t_codrep;
    
    t_camo_rjh_repartition  c_camo_rjh_repartition%ROWTYPE;
    
    CURSOR c_camo_rep_ligne (t_pid LIGNE_BIP.PID%TYPE ) IS
        SELECT DISTINCT r.CODCAMO, r.PID, c.CDATEFERM, l.CODSG,l.TYPPROJ, s.LIBDSG, c.CLIBRCA
        FROM REPARTITION_LIGNE r, centre_activite c, LIGNE_BIP l, STRUCT_INFO s
        WHERE 1 = 1
            AND s.CODSG = l.CODSG
            AND c.CODCAMO = r.CODCAMO
            AND l.PID = r.PID
            AND r.PID = t_pid
            AND r.DATFIN IS NULL;   -- On ne prend que les repartitions actives

    t_camo_rep_ligne    c_camo_rep_ligne%ROWTYPE;

   BEGIN

        -- Initialiser le message retour
        p_message := '';

        l_annee := get_annee_dbex;
 
        OPEN c_ligne_actif;
        LOOP
            FETCH c_ligne_actif INTO t_ligne_actif;
            EXIT WHEN c_ligne_actif%NOTFOUND;

            t_rejet := FALSE;
           
            -- Recherche des rejets
            -- Si date ligne (ADATESTATUT) < CDATEFERM                      => OK
            -- Si date ligne (ADATESTATUT) <> NULL et CDATEFERM = NULL      => OK
            -- Si date ligne (ADATESTATUT = null) et (CDATEFERM <> NULL)    => KO
            -- Si date ligne (ADATESTATUT) > CDATEFERM                      => KO
            -- Nb : Pour les camo 66666 ou 77777 , celui ci est toujours actif, faut voir les camo rattache a ce dernier
            --       pour conclure sur le rejet ( date )
            
            -- Si camo fictif ( 66666 ) 
            --    => recherche des code camo associés ( via RJH_TABLEREP_DETAIL / CODREP )
            --    => PID => consome     
            CASE t_ligne_actif.CODCAMO   
                -- CAMO FICTIF        
                WHEN 66666 THEN

                    -- Recherche des code camo (reparti) de la ligne
                    --  a partir du codrep de la table RJH_TABREPART_DETAIL
                    OPEN c_camo_rjh_repartition ( t_ligne_actif.CODREP );

                    -- Boucle sur les pid trouve et recherche du consome pour trouve la priorite
                    LOOP

                        FETCH c_camo_rjh_repartition INTO t_camo_rjh_repartition;
                        IF c_camo_rjh_repartition%NOTFOUND THEN
                            EXIT;
                        END IF;

                        IF ( t_camo_rjh_repartition.CODCAMO = 77777 ) THEN
                                
                            -- Recherche des CODE CAMO sur la table REPARTITION_LIGNE
                            -- en fonction du PID et de la date DEB
                            OPEN c_camo_rep_ligne( t_camo_rjh_repartition.PID ) ;
                                    
                            LOOP
                                FETCH c_camo_rep_ligne INTO t_camo_rep_ligne;
                                IF c_camo_rep_ligne%NOTFOUND THEN
                                    EXIT;
                                END IF;                                    
                                
                                IF is_rejet ( t_camo_rep_ligne.CDATEFERM , t_ligne_actif.ADATESTATUT) = TRUE THEN
                                    -- Insertion dans la table temporaire 
                                    -- avec gestion de la priorite en fonction du consome
                                    -- sur la table RJH_CONSOMME
                                    -- Cas 1
                                    insertion_tmp_camo_rep ( l_annee, 
                                                             t_camo_rep_ligne.CODCAMO,
                                                             t_camo_rep_ligne.CLIBRCA,
                                                             t_camo_rep_ligne.CDATEFERM, 
                                                             t_camo_rep_ligne.CODSG,
                                                             t_camo_rep_ligne.LIBDSG, 
                                                             t_camo_rep_ligne.PID,
                                                             t_ligne_actif.PID, 
                                                             t_camo_rep_ligne.TYPPROJ,
                                                             1) ;
                                END IF;                                        
                                    
                            END LOOP;
                            CLOSE c_camo_rep_ligne;
                            
                        -- Camo normal        
                        ELSE  
                            
                            IF is_rejet ( t_camo_rjh_repartition.CDATEFERM , t_ligne_actif.ADATESTATUT) = TRUE THEN                

                                -- Insertion dans la table temporaire 
                                -- avec gestion de la priorite en fonction du consome
                                -- sur la table RJH_CONSOMME
                                -- Cas 2
                                insertion_tmp_camo_rep ( l_annee, 
                                                         t_camo_rjh_repartition.CODCAMO,
                                                         t_camo_rjh_repartition.CLIBRCA,
                                                         t_camo_rjh_repartition.CDATEFERM, 
                                                         t_camo_rjh_repartition.CODSG,
                                                         t_camo_rjh_repartition.LIBDSG, 
                                                         t_camo_rjh_repartition.PID,
                                                         t_ligne_actif.PID, 
                                                         t_camo_rjh_repartition.TYPPROJ,
                                                         2) ;
                            END IF;                                
                                
                        END IF;
                                             
                    END LOOP;
                    CLOSE c_camo_rjh_repartition;
                    -- Fin boucle
                    
                WHEN 77777 THEN
                    
                    -- Recherche des CODE CAMO sur la table REPARTITION_LIGNE
                    -- en fonction du PID et de la date DEB
                    OPEN c_camo_rep_ligne( t_ligne_actif.PID );
                                    
                    LOOP
                        FETCH c_camo_rep_ligne INTO t_camo_rep_ligne;
                        IF c_camo_rep_ligne%NOTFOUND THEN
                            EXIT;
                        END IF; 
                        
                        IF is_rejet ( t_camo_rep_ligne.CDATEFERM , t_ligne_actif.ADATESTATUT) = TRUE THEN                                   



                            -- Insertion dans la table temporaire 
                            -- avec gestion de la priorite en fonction du consome
                            -- sur la table RJH_CONSOMME
                            -- Cas 3
                            insertion_tmp_camo ( l_annee, 
                                                     t_camo_rep_ligne.CODCAMO,
                                                     t_camo_rep_ligne.CLIBRCA,
                                                     t_camo_rep_ligne.CDATEFERM, 
                                                     t_camo_rep_ligne.CODSG,
                                                     t_camo_rep_ligne.LIBDSG, 
                                                     t_camo_rep_ligne.PID,
                                                     t_ligne_actif.PID, 
                                                     t_camo_rep_ligne.TYPPROJ,
                                                     3) ;                                        
                        END IF;
                                        
                    END LOOP;
                    CLOSE c_camo_rep_ligne;
                                    
                -- Fin camo fictif  
                    
                -- CAMO NORMAL
                ELSE
                       
                    IF is_rejet ( t_ligne_actif.CDATEFERM , t_ligne_actif.ADATESTATUT) = TRUE THEN
                        -- Insertion dans la table temporaire 
                        --  avec gestion de la priorite en fonction du consome
                        -- Cas 4
                        insertion_tmp_camo (l_annee, 
                                     t_ligne_actif.CODCAMO,
                                     t_ligne_actif.CLIBRCA,
                                     t_ligne_actif.CDATEFERM, 
                                     t_ligne_actif.CODSG,
                                     t_ligne_actif.LIBDSG, 
                                     t_ligne_actif.PID, 
                                     t_ligne_actif.PID,
                                     t_ligne_actif.TYPPROJ,
                                     4) ;  
                    END IF;            
                                   
            END CASE;
                  

        END LOOP;

        CLOSE c_ligne_actif;

        EXCEPTION

            WHEN OTHERS THEN
              raise_application_error( -20997, SQLERRM);

END controle_camo;

   PROCEDURE controle_cada (p_message   OUT VARCHAR2
                                ) IS

    l_annee   VARCHAR2(4);

    --SEL PPM 58986 
    -- Ligne actif (de type GT1) au sens FI
    CURSOR c_ligne_actif IS
        SELECT c.CDATEFERM, l.ADATESTATUT, l.ICPI,
               p.ILIBEL, c.CLIBRCA, c.CODCAMO
        FROM ligne_bip l
            INNER JOIN PROJ_INFO p ON p.ICPI = l.ICPI
            INNER JOIN CENTRE_ACTIVITE c ON p.CADA = c.CODCAMO
            INNER JOIN STRUCT_INFO s ON s.CODSG = l.CODSG

        WHERE (
                (
       /* TO_CHAR(l.ADATESTATUT,'YYYYMM') <= l_annee  || '11'
                AND TO_CHAR(l.ADATESTATUT,'YYYYMM') >= (l_annee -1)|| '12'*/
                
               TO_CHAR(l.ADATESTATUT,'YYYY') = l_annee
                )
              OR l.ADATESTATUT IS NULL )
              AND l.ARCTYPE = 'T1'
              AND l.TYPPROJ = 1
              AND p.STATUT = 'O'
              AND p.ICPI NOT IN ('P0000', 'P9000', 'P9999', 'P9995', 'P9997')
              AND c.CDATEFERM IS NOT NULL  ;

    t_ligne_actif  c_ligne_actif%ROWTYPE;
    t_priorite     NUMBER;
    t_rejet        BOOLEAN;

   BEGIN

        -- Initialiser le message retour
        p_message := '';

        l_annee := get_annee_dbex;

        OPEN c_ligne_actif;

        LOOP
            FETCH c_ligne_actif INTO t_ligne_actif;
            EXIT WHEN c_ligne_actif%NOTFOUND;

            t_priorite := 0;
            -- Insertion dans la table temporaire
            INSERT INTO TMP_CONTROLE_CA (TYPECAMO,
                                         CODCAMO,
                                         CLIBRCA,
                                         CDATE_CESSATION,
                                         ICPI,
                                         ILIBEL,
                                         PRIORITE,
                                         DATE_CREATION)
                                 VALUES ('CADA',
                                         t_ligne_actif.CODCAMO,
                                         t_ligne_actif.CLIBRCA,
                                         t_ligne_actif.CDATEFERM,
                                         t_ligne_actif.ICPI,
                                         t_ligne_actif.ILIBEL,
                                         t_priorite,
                                         SYSDATE  );


        END LOOP;

        CLOSE c_ligne_actif;

        EXCEPTION

            WHEN OTHERS THEN
              raise_application_error( -20997, SQLERRM);

    END controle_cada;

   PROCEDURE controle_ressource (p_message   OUT VARCHAR2
                                ) IS

    l_annee   VARCHAR2(4);

    -- Ressource active
    --SEL PPM 58986 : prendre en compte l annee civile
    CURSOR c_ressource_actif IS
        SELECT s.IDENT, si.codsg,si.TOPFER, si.CAFI, si.CENTRACTIV, si.LIBDSG
        FROM SITU_RESS s,
            ( SELECT MAX (r1.DATSITU) DATSITU,r1.IDENT
                            FROM situ_ress r1
                            WHERE TO_CHAR(r1.DATSITU,'YYYYMM') <= (l_annee) || '12'
                            GROUP BY R1.IDENT ) s2,
             struct_info si
        WHERE s.ident = s2.ident
              AND s.DATSITU = s2.DATSITU
              AND ( (TO_CHAR(s.datdep,'YYYYMM') >= l_annee || '01') OR s.datdep IS NULL)
              AND si.codsg = s.codsg;

    t_ressource_actif  c_ressource_actif%ROWTYPE;

    -- Consomme sur la periode active (dbex)
    --SEL PPM 58986 : prendre en compte l annee civile
    CURSOR c_consomme IS
        SELECT CUSAG
        FROM PROPLUS p


        WHERE TO_CHAR(p.CDEB,'YYYY') = l_annee
           AND NVL(p.CUSAG,-1) > 0
           AND p.TIRES = t_ressource_actif.IDENT  ;

    t_consomme  c_consomme%ROWTYPE;

    
    CURSOR c_cafi IS
        SELECT c.CDATEFERM, c.CLIBRCA FROM CENTRE_ACTIVITE c
        WHERE c.CODCAMO = t_ressource_actif.CAFI;

    t_cafi  c_cafi%ROWTYPE;

    CURSOR c_cadpg IS
        SELECT c.CDATEFERM, c.CLIBRCA FROM CENTRE_ACTIVITE c
        WHERE c.CODCAMO = t_ressource_actif.CENTRACTIV;

    t_cadpg  c_cadpg%ROWTYPE;

    t_lib_ca       CENTRE_ACTIVITE.CLIBRCA%TYPE;
    t_priorite     NUMBER;
    t_rejet_cadpg  BOOLEAN;
    t_rejet_cafi   BOOLEAN;
    t_rejet_dpg    BOOLEAN;
    b_consomme     BOOLEAN;
  --  t_rejet_metier BOOLEAN;
  --  t_liste_codfei VARCHAR2(100);
  --  t_code_6        BOOLEAN;
  --  t_code_7_8     BOOLEAN;

   BEGIN
        -- Initialiser le message retour
        p_message := '';
        l_annee := get_annee_dbex;

        OPEN c_ressource_actif;

        LOOP
            FETCH c_ressource_actif INTO t_ressource_actif;
            EXIT WHEN c_ressource_actif%NOTFOUND;

            t_rejet_cadpg   := FALSE;
            t_rejet_cafi    := FALSE;
            t_rejet_dpg     := FALSE;

            -- Recherche du consomme
            OPEN c_consomme;
            b_consomme := FALSE;
            
            FETCH c_consomme INTO t_consomme;
            IF c_consomme%FOUND THEN
                b_consomme      := TRUE;
            END IF;

            CLOSE c_consomme;

            -- Controle DPG 
            -- Si consomme et si DPG inactif : TOPFER = 'F' => rejet
            IF b_consomme AND t_ressource_actif.TOPFER = 'F' THEN
                t_rejet_dpg := TRUE;
            END IF;

            -- Controle CADPG
            OPEN c_cadpg;
            FETCH c_cadpg INTO t_cadpg;
            IF c_cadpg%FOUND THEN

                -- Si consomme
                IF b_consomme THEN

                    -- si CADPG inactif
                    IF t_cadpg.CDATEFERM IS NOT NULL THEN
                        t_rejet_cadpg := TRUE;
                        t_priorite := 1;
                    END IF;

                -- Pas de consomme
                ELSE
                    -- si CADPG non actif
                    IF t_cadpg.CDATEFERM IS NOT NULL THEN
                        t_rejet_cadpg := TRUE;
                        t_priorite := 0;
                    END IF;

                END IF;

            END IF;
            CLOSE c_cadpg;

            IF t_rejet_cadpg = TRUE THEN

                -- Insertion dans la table temporaire
                INSERT INTO TMP_CONTROLE_CA (   TYPECAMO,
                                                CODCAMO,
                                                CLIBRCA,
                                                CDATE_CESSATION,
                                                CODSG,
                                                LIBDSG,
                                                PRIORITE,
                                                DATE_CREATION)
                                     VALUES (   'CADPG',
                                                t_ressource_actif.CENTRACTIV,
                                                t_cadpg.CLIBRCA,
                                                t_cadpg.CDATEFERM,
                                                t_ressource_actif.CODSG,
                                                t_ressource_actif.LIBDSG,
                                                t_priorite,
                                                SYSDATE  );

            END IF;

            IF t_rejet_dpg = TRUE THEN

                -- Insertion dans la table temporaire
                INSERT INTO TMP_CONTROLE_CA (   TYPECAMO,
                                                CODSG,
                                                LIBDSG,
                                                PRIORITE,
                                                DATE_CREATION)
                                     VALUES (   'DPG',
                                                t_ressource_actif.CODSG,
                                                t_ressource_actif.LIBDSG,
                                                1,
                                                SYSDATE  );

            END IF;
            
            
            OPEN c_cafi;
            FETCH c_cafi INTO t_cafi;

            IF c_cafi%FOUND THEN

                
                IF b_consomme = TRUE THEN
                
                    IF t_ressource_actif.CAFI NOT IN (66666,77777,88888,99999,99810) THEN
                    
                        -- Cafi non actif 
                        IF t_cafi.CDATEFERM IS NOT NULL THEN
                            -- Insertion dans la table temporaire priorite forte 
                            INSERT INTO TMP_CONTROLE_CA (   TYPECAMO,
                                                            CODCAMO,
                                                            CLIBRCA,
                                                            CDATE_CESSATION,
                                                            CODSG,
                                                            LIBDSG,
                                                            PRIORITE,
                                                            DATE_CREATION)
                                                 VALUES (   'CAFI',
                                                            t_ressource_actif.CAFI,
                                                            t_cafi.CLIBRCA,
                                                            t_cafi.CDATEFERM,
                                                            t_ressource_actif.CODSG,
                                                            t_ressource_actif.LIBDSG,
                                                            1,
                                                            SYSDATE  );                        

                        END IF;
                        
                        
                    END IF;
                    
                -- Pas de consomme
                ELSE
                
                    -- Cafi non actif 
                    IF t_cafi.CDATEFERM IS NOT NULL 
                            AND t_ressource_actif.CAFI NOT IN (66666,77777,88888,99999,99810,99820) 
                        THEN
                        
                        -- Insertion dans la table temporaire
                        INSERT INTO TMP_CONTROLE_CA (   TYPECAMO,
                                                        CODCAMO,
                                                        CLIBRCA,
                                                        CDATE_CESSATION,
                                                        CODSG,
                                                        LIBDSG,
                                                        PRIORITE,
                                                        DATE_CREATION)
                                             VALUES (   'CAFI',
                                                        t_ressource_actif.CAFI,
                                                        t_cafi.CLIBRCA,
                                                        t_cafi.CDATEFERM,
                                                        t_ressource_actif.CODSG,
                                                        t_ressource_actif.LIBDSG,
                                                        0,
                                                        SYSDATE  );                        
                        
                    END IF;
                    
                END IF;


            END IF;
            
            CLOSE c_cafi;

        END LOOP;

        CLOSE c_ressource_actif;

        EXCEPTION

            WHEN OTHERS THEN
              raise_application_error( -20997, SQLERRM);

    END controle_ressource;

   PROCEDURE controle_metier (p_message   OUT VARCHAR2
                                ) IS

    l_annee   VARCHAR2(4);

    -- Ressource active
    --SEL PPM 58986 : prendre en compte l annee civile
    CURSOR c_ressource_actif IS
        SELECT s.IDENT, si.codsg,si.TOPFER, si.CAFI, si.CENTRACTIV, si.LIBDSG
        FROM SITU_RESS s,
            ( SELECT MAX (r1.DATSITU) DATSITU,r1.IDENT
                            FROM situ_ress r1
                            WHERE TO_CHAR(r1.DATSITU,'YYYYMM') <= (l_annee) || '12'
                            GROUP BY R1.IDENT ) s2,
             struct_info si
        WHERE s.ident = s2.ident
              AND s.DATSITU = s2.DATSITU
              AND ( (TO_CHAR(s.datdep,'YYYYMM') >= l_annee || '01') OR s.datdep IS NULL)
              AND si.codsg = s.codsg;

    t_ressource_actif  c_ressource_actif%ROWTYPE;

    -- Consomme sur la periode active (dbex)
    --SEL PPM 58986 : prendre en compte l annee civile
    CURSOR c_consomme (t_ident SITU_RESS.IDENT%TYPE) IS
        SELECT CUSAG
        FROM PROPLUS p


        WHERE TO_CHAR(p.CDEB,'YYYY') = l_annee          
           AND NVL(p.CUSAG,-1) > 0
           AND p.TIRES = t_ident  ;

    t_consomme  c_consomme%ROWTYPE;

    -- Consomme sur la periode active (dbex)
    -- et fonction du DPG
    --SEL PPM 58986 : prendre en compte l annee civile    
    CURSOR c_consomme_dpg (t_ident SITU_RESS.IDENT%TYPE, t_codsg STRUCT_INFO.CODSG%TYPE )  IS
        SELECT DISTINCT l.METIER
        FROM PROPLUS p, LIGNE_BIP l


        WHERE TO_CHAR(p.CDEB,'YYYY') = l_annee
           AND NVL(p.CUSAG,-1) > 0
           AND p.PID = l.PID
           AND p.TIRES = t_ident
           AND l.CODSG = t_codsg ;

    t_consomme_dpg  c_consomme_dpg%ROWTYPE;
    
    CURSOR c_cafi IS
        SELECT c.CDATEFERM, c.CLIBRCA FROM CENTRE_ACTIVITE c
        WHERE c.CODCAMO = t_ressource_actif.CAFI;

    t_cafi  c_cafi%ROWTYPE;

    CURSOR c_cadpg IS
        SELECT c.CDATEFERM, c.CLIBRCA FROM CENTRE_ACTIVITE c
        WHERE c.CODCAMO = t_ressource_actif.CENTRACTIV;

    t_cadpg  c_cadpg%ROWTYPE;

    CURSOR c_metier_manquant_simple ( t_cafi STRUCT_INFO.CAFI%TYPE, t_metier LIGNE_BIP.METIER%TYPE ) IS
        SELECT DISTINCT rm.CODFEI CODFEI,r.CODFEI CODFEI2
        FROM RUBRIQUE_METIER rm LEFT OUTER JOIN (SELECT r1.CODFEI FROM RUBRIQUE r1 WHERE r1.CAFI = t_cafi) r
                                                ON rm.CODFEI = r.CODFEI
        WHERE rm.METIER = TRIM( t_metier ) AND r.CODFEI IS NULL
        ORDER BY rm.CODFEI;

    t_metier_manquant_simple    c_metier_manquant_simple%ROWTYPE;

    CURSOR c_metier_manquant ( t_cafi STRUCT_INFO.CAFI%TYPE ) IS
        SELECT r.CODFEI 
        FROM RUBRIQUE r 
        WHERE r.CAFI = t_cafi;

    t_metier_manquant  c_metier_manquant%ROWTYPE;        

    t_lib_ca       CENTRE_ACTIVITE.CLIBRCA%TYPE;
    t_priorite     NUMBER;
    t_rejet_cadpg  BOOLEAN;
    t_rejet_cafi   BOOLEAN;
    t_rejet_dpg    BOOLEAN;
    b_consomme     BOOLEAN;
    t_rejet_metier BOOLEAN;
    t_liste_codfei VARCHAR2(100);
    t_code_6        BOOLEAN;
    t_code_7_8     BOOLEAN;

   BEGIN
        -- Initialiser le message retour
        p_message := '';
        l_annee := get_annee_dbex;

        OPEN c_ressource_actif;

        LOOP
            FETCH c_ressource_actif INTO t_ressource_actif;
            EXIT WHEN c_ressource_actif%NOTFOUND;

            t_rejet_cadpg   := FALSE;
            t_rejet_cafi    := FALSE;
            t_rejet_dpg     := FALSE;

            -- Recherche du consomme
            OPEN c_consomme (t_ressource_actif.IDENT );
            b_consomme := FALSE;
            
            FETCH c_consomme INTO t_consomme;
            IF c_consomme%FOUND THEN
                b_consomme      := TRUE;
            END IF;

            CLOSE c_consomme;          
            
            OPEN c_cafi;
            FETCH c_cafi INTO t_cafi;

            IF c_cafi%FOUND THEN
                
                IF b_consomme = TRUE THEN
                
                    IF t_ressource_actif.CAFI NOT IN (66666,77777,88888,99999,99810) THEN
                    
                        -- CAFI ACTIF 
                        IF t_cafi.CDATEFERM IS NULL THEN
                                              
                            IF t_ressource_actif.CAFI <> 99820 THEN
                                OPEN c_consomme_dpg (t_ressource_actif.IDENT, t_ressource_actif.CODSG );

                                LOOP
                                    FETCH c_consomme_dpg INTO t_consomme_dpg;
                                    EXIT WHEN c_consomme_dpg%NOTFOUND;

                                    t_rejet_metier  := FALSE;
                                    t_liste_codfei  := '-1';

                                    -- Controle Metier 
                                    -- Recherche du metier associe 
                                    CASE 
                                    
                                        WHEN TRIM(t_consomme_dpg.METIER) = 'EXP' THEN

                                            -- Pour le metier EXP il faut au moins une des 2 valeurs pour le non rejet .
                                            t_code_7_8 := FALSE;                                                                                        
                                            
                                            OPEN c_metier_manquant (t_ressource_actif.CAFI );
                                            LOOP
                                                FETCH c_metier_manquant INTO t_metier_manquant;
                                                EXIT WHEN c_metier_manquant%NOTFOUND;

                                                IF NVL(t_metier_manquant.CODFEI,-1) = 7 OR NVL(t_metier_manquant.CODFEI,-1) = 8  THEN
                                                    t_code_7_8 := TRUE;
                                                END IF;

                                            END LOOP;
                                            CLOSE c_metier_manquant; 
                                            
                                            IF t_code_7_8 = TRUE THEN
                                                t_rejet_metier  := FALSE; 
                                            ELSE
                                                t_rejet_metier  := TRUE;
                                                t_liste_codfei  := '7, 8';                             
                                            END IF;                                       
                                        
                                        WHEN TRIM(t_consomme_dpg.METIER) = 'GAP' OR TRIM(t_consomme_dpg.METIER) = 'SAU' THEN
                                         
                                            -- Pour ces metier il faut le code fei 6 et (7 ou 8 ) 
                                            t_code_7_8 := FALSE;
                                            t_code_6   := FALSE;
                                            t_rejet_metier  := TRUE;
                                            
                                            OPEN c_metier_manquant (t_ressource_actif.CAFI );
                                            LOOP
                                            
                                                FETCH c_metier_manquant INTO t_metier_manquant;
                                                EXIT WHEN c_metier_manquant%NOTFOUND;

                                                IF NVL(t_metier_manquant.CODFEI,-1) = 6 THEN
                                                    t_code_6 := TRUE;
                                                END IF;
                                                IF NVL(t_metier_manquant.CODFEI,-1) = 7 OR NVL(t_metier_manquant.CODFEI,-1) = 8  THEN
                                                    t_code_7_8 := TRUE;
                                                END IF;


                                            END LOOP;
                                            CLOSE c_metier_manquant;
                                             
                                            IF t_code_6 = FALSE THEN
                                                t_liste_codfei := '6';
                                                IF t_code_7_8 = FALSE THEN
                                                    t_liste_codfei := t_liste_codfei || ', 7, 8';
                                                END IF;
                                            ELSE
                                                IF t_code_7_8 = FALSE THEN
                                                    t_liste_codfei := '7, 8';
                                                END IF;                                            
                                            END IF;
                                                                                           
                                            IF  t_code_6 = TRUE AND t_code_7_8 = TRUE THEN                                             
                                                t_rejet_metier  := FALSE;
                                            END IF;   
                                        
                                        WHEN TRIM(t_consomme_dpg.METIER) = 'ME' OR TRIM(t_consomme_dpg.METIER) = 'MO' OR TRIM(t_consomme_dpg.METIER) = 'HOM' THEN                                            
                                        
                                            OPEN c_metier_manquant_simple (t_ressource_actif.CAFI,t_consomme_dpg.METIER) ;
                                            LOOP
                                                FETCH c_metier_manquant_simple INTO t_metier_manquant_simple;
                                                EXIT WHEN c_metier_manquant_simple%NOTFOUND;

                                                -- rejet
                                                t_rejet_metier  := TRUE;
                                                IF t_liste_codfei = '-1' THEN
                                                    t_liste_codfei  := t_metier_manquant_simple.CODFEI;
                                                ELSE
                                                    t_liste_codfei := t_liste_codfei || ', ' ||  t_metier_manquant_simple.CODFEI;
                                                END IF;

                                            END LOOP;
                                            CLOSE c_metier_manquant_simple;
                                        
                                        ELSE
                                        
                                            NULL;                                            
                                    END CASE;
                                    

                                    IF t_rejet_metier = TRUE THEN
                                    
                                        -- Insertion dans la table temporaire
                                        INSERT INTO TMP_CONTROLE_CA (   TYPECAMO,
                                                                        CODCAMO,
                                                                        CLIBRCA,
                                                                        METIER,
                                                                        CODFEI,
                                                                        PRIORITE,
                                                                        CENTRACTIV,
                                                                        DATE_CREATION)
                                                             VALUES (   'CAFI_METIER',
                                                                        t_ressource_actif.CAFI,
                                                                        t_cadpg.CLIBRCA,
                                                                        TRIM(t_consomme_dpg.METIER),
                                                                        t_liste_codfei,
                                                                        1,
                                                                        t_ressource_actif.CENTRACTIV,
                                                                        SYSDATE  );
                                    END IF;

                                END LOOP;
                                CLOSE c_consomme_dpg;  
                                
                            -- CAFI = 99820     
                            ELSE
                                
                                OPEN c_consomme_dpg (t_ressource_actif.IDENT, t_ressource_actif.CODSG );
                                LOOP
                                    FETCH c_consomme_dpg INTO t_consomme_dpg;
                                    EXIT WHEN c_consomme_dpg%NOTFOUND;

                                    t_rejet_metier  := FALSE;
                                    t_liste_codfei  := '-1';

                                    -- Controle Metier 
                                    -- Recherche du metier associe 
                                    CASE
                                    
                                        WHEN TRIM(t_consomme_dpg.METIER) = 'EXP' THEN
                                        
                                            -- Pour le metier EXP il faut au moins une des 2 valeurs pour le non rejet .
                                            t_code_7_8      := FALSE;                                                                                        
                                            
                                            -- On prend le CADPG ( centractiv ) comme reference pour le cafi 99820
                                            -- pour les rubriques
                                            OPEN c_metier_manquant ( t_ressource_actif.CENTRACTIV );
                                            LOOP
                                                FETCH c_metier_manquant INTO t_metier_manquant;
                                                EXIT WHEN c_metier_manquant%NOTFOUND;

                                                IF NVL(t_metier_manquant.CODFEI,-1) = 7 OR NVL(t_metier_manquant.CODFEI,-1) = 8  THEN
                                                    t_code_7_8 := TRUE;
                                                END IF;

                                            END LOOP;
                                            CLOSE c_metier_manquant; 
                                            
                                            IF t_code_7_8 = TRUE THEN
                                                t_rejet_metier  := FALSE; 
                                            ELSE
                                                t_rejet_metier  := TRUE;
                                                t_liste_codfei  := '7, 8';                             
                                            END IF; 
                                            
                                        WHEN TRIM(t_consomme_dpg.METIER) = 'GAP' OR TRIM(t_consomme_dpg.METIER) = 'SAU' THEN
                                        
                                            -- Pour ces metier il faut le code fei 6 et (7 ou 8 ) 
                                            t_code_7_8 := FALSE;
                                            t_code_6   := FALSE;
                                            t_rejet_metier  := TRUE;
                                            
                                            OPEN c_metier_manquant ( t_ressource_actif.CENTRACTIV );
                                            LOOP
                                                FETCH c_metier_manquant INTO t_metier_manquant;
                                                EXIT WHEN c_metier_manquant%NOTFOUND;

                                                IF NVL(t_metier_manquant.CODFEI,-1) = 6 THEN
                                                    t_code_6 := TRUE;
                                                END IF;
                                                IF NVL(t_metier_manquant.CODFEI,-1) = 7 OR NVL(t_metier_manquant.CODFEI,-1) = 8  THEN
                                                    t_code_7_8 := TRUE;
                                                END IF;

                                            END LOOP;
                                            CLOSE c_metier_manquant;
                                             
                                            IF t_code_6 = FALSE THEN
                                                t_liste_codfei := '6';
                                                IF t_code_7_8 = FALSE THEN
                                                    t_liste_codfei := t_liste_codfei || ', 7, 8';
                                                END IF;
                                            ELSE
                                                IF t_code_7_8 = FALSE THEN
                                                    t_liste_codfei := '7, 8';
                                                END IF;                                            
                                            END IF;
                                                                                           
                                            IF  t_code_6 = TRUE AND t_code_7_8 = TRUE THEN                                             
                                                t_rejet_metier  := FALSE;
                                            END IF; 
                                                                                                                                
                                        ELSE -- 'ME', 'MO', 'HOM' 
                                        
                                            OPEN c_metier_manquant_simple ( t_ressource_actif.CENTRACTIV, t_consomme_dpg.METIER );
                                            LOOP
                                                FETCH c_metier_manquant_simple INTO t_metier_manquant_simple;
                                                EXIT WHEN c_metier_manquant_simple%NOTFOUND;

                                                -- rejet
                                                t_rejet_metier  := TRUE;
                                                IF t_liste_codfei = '-1' THEN
                                                    t_liste_codfei  := t_metier_manquant_simple.CODFEI;
                                                ELSE
                                                    t_liste_codfei := t_liste_codfei || ', ' ||  t_metier_manquant_simple.CODFEI;
                                                END IF;

                                            END LOOP;
                                            CLOSE c_metier_manquant_simple;                                            
                                    END CASE;

                                    IF t_rejet_metier = TRUE THEN
                                        -- Insertion dans la table temporaire
                                        INSERT INTO TMP_CONTROLE_CA (   TYPECAMO,
                                                                        CODCAMO,
                                                                        CLIBRCA,
                                                                        METIER,
                                                                        CODFEI,
                                                                        PRIORITE,
                                                                        CENTRACTIV,
                                                                        DATE_CREATION)
                                                             VALUES (   'CAFI_METIER',
                                                                        t_ressource_actif.CAFI,
                                                                        t_cadpg.CLIBRCA,
                                                                        TRIM(t_consomme_dpg.METIER),
                                                                        t_liste_codfei,
                                                                        1,
                                                                        t_ressource_actif.CENTRACTIV,
                                                                        SYSDATE  );
                                    END IF;

                                END LOOP;
                                CLOSE c_consomme_dpg;                             
                            END IF;                          
                        
                        END IF;
                        
                        
                    END IF;                  
                    
                END IF;


            END IF;
            
            CLOSE c_cafi;

        END LOOP;

        CLOSE c_ressource_actif;

        EXCEPTION

            WHEN OTHERS THEN
              raise_application_error( -20997, SQLERRM);

    END controle_metier;

   PROCEDURE controle_ca IS

      l_msg VARCHAR2(1024);


   BEGIN

        -- Initialiser le message retour
        l_msg := '';
        DELETE FROM TMP_CONTROLE_CA;

        controle_camo(l_msg);

        controle_cada(l_msg);


        controle_ressource(l_msg);

        
        --SEL PPM 60907 : SI l existence d une rubrique fictive ALORS pas de controle
        
        IF(NOT PACK_LISTE_RUBRIQUE.exister_rubrique_fictive()) THEN
        controle_metier(l_msg);


        END IF;


        COMMIT;

        EXCEPTION

            WHEN OTHERS THEN
              raise_application_error( -20997, SQLERRM);

    END controle_ca;


PROCEDURE select_controle_ca ( p_curStruct_info      IN OUT Controle_Ca_CurType_Char ) is


   BEGIN

        OPEN  p_curStruct_info  FOR
                        SELECT TYPECAMO,CODCAMO,CLIBRCA,CDATE_CESSATION,ICPI,
                            ILIBEL,CODSG,LIBDSG,PID,PRIORITE,DATE_CREATION
                        FROM TMP_CONTROLE_CA;

END select_controle_ca;



END PACK_CONTROLE_CA;
/


