-- Package PL/SQL PACKBATCH_CONTROLE_MCI 

-- cree le 02/03/2012 par BSA FICHE QC 1321
-- Modifie le 14/03/2012 par BSA QC 1321
-- Modifie le 20/03/2012 par BSA modification ordre colonne + ajout entete (csv)

CREATE OR REPLACE package     PACKBATCH_CONTROLE_MCI as

    -- 
    -- 
    -- 
    -- -------------------------------------------------------
    PROCEDURE alim_tmp(
                        p_chemin_fichier        IN VARCHAR2,
                        p_nom_fichier           IN VARCHAR2
        );
    
PROCEDURE export_tmp(
                        p_chemin_fichier        IN VARCHAR2,
                        p_nom_fichier           IN VARCHAR2
        );
    
    PROCEDURE traitement(
                        p_chemin_fichier        IN VARCHAR2,
                        p_nom_fichier_csv       IN VARCHAR2,
                        p_nom_fichier_count     IN VARCHAR2
        );



end PACKBATCH_CONTROLE_MCI;
/


CREATE OR REPLACE package body     PACKBATCH_CONTROLE_MCI as



    -- ------------------------------------------------
    -- Copier/Coller/Modifier de l'exemple 'drop_table'
    -- de la documentation en ligne de PL/SQL dans
    -- Interaction with Oracle : using DLL and
    -- dynamic SQL
    -- ------------------------------------------------
    PROCEDURE alim_tmp(
                        p_chemin_fichier        IN VARCHAR2,
                        p_nom_fichier           IN VARCHAR2
        ) IS

        CURSOR c_donnee IS 
        SELECT r.RTYPE, r.ident,r.RNOM, r.RPRENOM,s.CODSG, s.DATSITU, s.DATDEP, s.SOCCODE, s.MODE_CONTRACTUEL_INDICATIF 
            FROM ressource r , situ_ress s
            WHERE r.IDENT = s.IDENT
                    AND (
                            ( r.RTYPE = 'P' AND s.SOCCODE <> 'SG..' ) 
                            OR 
                            ( r.RTYPE IN ('E','F','L') )
                        )
                    AND s.PRESTATION NOT IN ('IFO','SLT')
                    AND ( 
                        s.MODE_CONTRACTUEL_INDICATIF IN ('   ',' ','','XXX','???')
                        OR s.MODE_CONTRACTUEL_INDICATIF IS NULL
                        )
                    AND (
                        TO_CHAR(s.DATSITU,'YYYYMM') >= '201112'
                        OR ( TO_CHAR(s.DATSITU,'YYYYMM') <= '201112' AND TO_CHAR(s.DATDEP,'YYYYMM') >= '201112' )
                        OR ( TO_CHAR(s.DATSITU,'YYYYMM') <= '201112' AND s.DATDEP IS NULL )
                        )
                        
                    AND PACK_RESSOURCE_P.ISMCIOBLIGATOIRE ( s.CODSG ) = 'O'
            ORDER BY r.IDENT ASC ; 
        
        t_donnee    c_donnee%ROWTYPE; 
        t_ident     ressource.IDENT%TYPE;    
        ctr_situ    NUMBER;
        ctr_res     NUMBER;
        
        t_commentaire_log   VARCHAR2(500);
        
        -- Ligne contrat en compatibilite simple
        CURSOR c_ligne_contrat    IS
            SELECT l.MODE_CONTRACTUEL FROM LIGNE_CONT l
            WHERE l.IDENT = t_donnee.IDENT
                AND l.LRESDEB >= t_donnee.DATSITU
                               
                AND ( 
                    l.LRESFIN <= t_donnee.DATDEP
                    OR ( 
                        l.LRESFIN <=  NVL(t_donnee.DATDEP,TO_DATE('01123000','MMDDYYYY'))
                       )
                    )
            ORDER BY l.LRESDEB DESC;
                
        t_ligne_contrat         c_ligne_contrat%ROWTYPE;
        t_ctr_ress_deja_fait    BOOLEAN;

        t_separateur    CHAR(1) := ';';
        l_hfile UTL_FILE.FILE_TYPE;
        
    BEGIN
        
        -- Initialistation
        t_commentaire_log := 'Modification de la situation batch modification situation';
        DELETE FROM TMP_MCI_VIDE;
        ctr_situ := 0;
        ctr_res := 0;  
        t_ident := null;
                     
        -- Lecture des donnees
        OPEN c_donnee;
        FETCH c_donnee INTO t_donnee;
        
        WHILE c_donnee%FOUND LOOP
            
            -- test rupture ressource
            IF (t_donnee.IDENT <> NVL(t_ident,-1) ) THEN
            
                t_ctr_ress_deja_fait := FALSE;
                t_ident := t_donnee.IDENT;
                
            END IF;
            
            IF t_donnee.RTYPE = 'L' THEN
            
                ctr_situ := ctr_situ + 1;
                IF t_ctr_ress_deja_fait = FALSE THEN
                    ctr_res := ctr_res + 1;
                    t_ctr_ress_deja_fait := TRUE;                    
                END IF;
                    
                -- Charger le MCI a 'LO'
                UPDATE SITU_RESS SET MODE_CONTRACTUEL_INDICATIF = 'LO' 
                WHERE IDENT = t_donnee.IDENT
                    AND DATSITU = t_donnee.DATSITU ;
                    
                -- Mis a jour du log mci
                Pack_Ressource_P.maj_ressource_logs(t_donnee.IDENT, 'FI', 'SITU_RESS', 'mode_contractuel_indicatif', t_donnee.MODE_CONTRACTUEL_INDICATIF, 'LO', t_commentaire_log);
                   
                -- Sert uniquement de trace (M: mise a jour) , ne doit pas etre pris dans les traitements sur la table temporaire
                INSERT INTO TMP_MCI_VIDE (
                                            IDENT,
                                            RNOM,
                                            RPRENOM,
                                            RTYPE,
                                            DATSITU,
                                            DATDEP,
                                            SOCCODE,
                                            CODSG,
                                            MCI,
                                            ACTION,
                                            MCI_OLD
                                          )
                                    VALUES (
                                            t_donnee.IDENT, 
                                            t_donnee.RNOM, 
                                            t_donnee.RPRENOM, 
                                            t_donnee.RTYPE, 
                                            t_donnee.DATSITU, 
                                            t_donnee.DATDEP, 
                                            t_donnee.SOCCODE, 
                                            t_donnee.CODSG, 
                                            'LO',
                                            'M',
                                            t_donnee.MODE_CONTRACTUEL_INDICATIF -- old
                                            );
                                                
            ELSE
            
                -- recherche ligne contrat
                OPEN c_ligne_contrat;
                FETCH c_ligne_contrat INTO t_ligne_contrat;
                
                -- si ligne contrat trouve       
                IF c_ligne_contrat%FOUND THEN
                
                    ctr_situ := ctr_situ + 1;
                    IF t_ctr_ress_deja_fait = FALSE THEN
                        ctr_res := ctr_res + 1;
                        t_ctr_ress_deja_fait := TRUE;                    
                    END IF;
                    
                    UPDATE SITU_RESS SET MODE_CONTRACTUEL_INDICATIF = t_ligne_contrat.MODE_CONTRACTUEL
                    WHERE IDENT = t_donnee.IDENT
                        AND DATSITU = t_donnee.DATSITU ;
                    
                    -- Mis a jour du log mci
                    Pack_Ressource_P.maj_ressource_logs(t_donnee.IDENT, 'FI', 'SITU_RESS', 'mode_contractuel_indicatif', t_donnee.MODE_CONTRACTUEL_INDICATIF, t_ligne_contrat.MODE_CONTRACTUEL, t_commentaire_log);   

                    -- Sert uniquement de trace (M: mise a jour) , ne doit pas etre pris dans les traitements sur la table temporaire
                    INSERT INTO TMP_MCI_VIDE (
                                                IDENT,
                                                RNOM,
                                                RPRENOM,
                                                RTYPE,
                                                DATSITU,
                                                DATDEP,
                                                SOCCODE,
                                                CODSG,
                                                MCI,
                                                ACTION,
                                                MCI_OLD
                                              )
                                        VALUES (
                                                t_donnee.IDENT, 
                                                t_donnee.RNOM, 
                                                t_donnee.RPRENOM, 
                                                t_donnee.RTYPE, 
                                                t_donnee.DATSITU, 
                                                t_donnee.DATDEP, 
                                                t_donnee.SOCCODE, 
                                                t_donnee.CODSG, 
                                                t_ligne_contrat.MODE_CONTRACTUEL,
                                                'M',
                                                t_donnee.MODE_CONTRACTUEL_INDICATIF -- old
                                                );
                                                                
                -- Aucune ligne contrat trouve 
                --   -> Trace dans fichier csv   
                ELSE
                                                                
                    INSERT INTO TMP_MCI_VIDE (
                                                IDENT,
                                                RNOM,
                                                RPRENOM,
                                                RTYPE,
                                                DATSITU,
                                                DATDEP,
                                                SOCCODE,
                                                CODSG,
                                                MCI,
                                                ACTION
                                              )
                                        VALUES (
                                                t_donnee.IDENT, 
                                                t_donnee.RNOM, 
                                                t_donnee.RPRENOM, 
                                                t_donnee.RTYPE, 
                                                t_donnee.DATSITU, 
                                                t_donnee.DATDEP, 
                                                t_donnee.SOCCODE, 
                                                t_donnee.CODSG, 
                                                t_donnee.MODE_CONTRACTUEL_INDICATIF,
                                                'T'
                                                );
                    
                END IF;
                
                CLOSE c_ligne_contrat;
            END IF;  

            -- ligne suivante
            FETCH c_donnee INTO t_donnee;
            
        END LOOP;
        
        CLOSE c_donnee;
        
        -- Ecriture des compteurs dans le fichier de sortie
        Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);

        Pack_Global.WRITE_STRING( l_hfile,
                        'ctr_situ' || t_separateur ||
                        'ctr_res' || t_separateur
                        );
                        
        Pack_Global.WRITE_STRING( l_hfile,
                        ctr_situ || t_separateur ||
                        ctr_res
                        );

        Pack_Global.CLOSE_WRITE_FILE(l_hfile);        
        
        
    EXCEPTION

        WHEN OTHERS THEN
            NULL;

    END alim_tmp;

-- ======================================================================
-- Extractions de la table TMP_MCI_VIDE
-- ======================================================================
PROCEDURE export_tmp(
                        p_chemin_fichier        IN VARCHAR2,
                        p_nom_fichier           IN VARCHAR2
        ) IS
        
    t_separateur    CHAR(1) := ';';

    CURSOR c_donnee IS
    SELECT IDENT,DATSITU,RNOM,RPRENOM,DATDEP,SOCCODE,CODSG,MCI,RTYPE
    FROM TMP_MCI_VIDE
    WHERE ACTION = 'T'
    ORDER BY IDENT,DATSITU ASC;
                
    l_msg  VARCHAR2(1024);
    l_hfile UTL_FILE.FILE_TYPE;
                
    BEGIN
        Pack_Global.INIT_WRITE_FILE( p_chemin_fichier, p_nom_fichier, l_hfile);

        -- ecriture des entetes
        Pack_Global.WRITE_STRING( l_hfile,
                'IDENT' || t_separateur ||
                'RNOM' || t_separateur ||
                'RPRENOM' || t_separateur ||
                'RTYPE' || t_separateur ||
                'DATSITU' || t_separateur ||
                'DATDEP' || t_separateur ||
                'SOCCODE' || t_separateur ||
                'CODSG' || t_separateur ||
                'MCI'
                );

        FOR rec_donnee IN c_donnee LOOP
                Pack_Global.WRITE_STRING( l_hfile,
                        rec_donnee.IDENT || t_separateur ||
                        rec_donnee.RNOM || t_separateur ||
                        rec_donnee.RPRENOM || t_separateur ||
                        rec_donnee.RTYPE || t_separateur ||
                        rec_donnee.DATSITU || t_separateur ||
                        rec_donnee.DATDEP || t_separateur ||
                        rec_donnee.SOCCODE || t_separateur ||
                        rec_donnee.CODSG || t_separateur ||
                        rec_donnee.MCI
                        );
        END LOOP;
        Pack_Global.CLOSE_WRITE_FILE(l_hfile);
        
    EXCEPTION
            WHEN OTHERS THEN
                    Pack_Global.recuperer_message(20401, NULL, NULL, NULL, l_msg);
                    RAISE_APPLICATION_ERROR(-20401, l_msg);
                    
END export_tmp;

    PROCEDURE traitement(
                        p_chemin_fichier        IN VARCHAR2,
                        p_nom_fichier_csv       IN VARCHAR2,
                        p_nom_fichier_count     IN VARCHAR2
        ) IS

        
    BEGIN
        
        alim_tmp(p_chemin_fichier, p_nom_fichier_count);
        
        export_tmp(p_chemin_fichier, p_nom_fichier_csv);
        
    EXCEPTION


        WHEN OTHERS THEN
            NULL;

    END traitement;
    
END PACKBATCH_CONTROLE_MCI;
/


