-- *****************************************************************************************
-- Créé le 09/12/2010 par ABA (QC 1079)
-- Modification
--    date 	            auteur             	commentaire
---- ******************************************************************************************

CREATE OR REPLACE PACKAGE     PACK_MAJ_MULTI_CA_MASSE IS

PROCEDURE MAJ_MULTI_CA_MASSE(p_log_dir VARCHAR2);

END PACK_MAJ_MULTI_CA_MASSE;
/


CREATE OR REPLACE PACKAGE BODY     PACK_MAJ_MULTI_CA_MASSE IS


/* mise à jour en masse des répartitions en fonction d'un périmètre données 
script utilisé pour la sortie de GTS de la BIP  la mise à jour des repartitions permet de mettre à niveau la FI avec le CAFI à 24000 */
   
PROCEDURE MAJ_MULTI_CA_MASSE(p_log_dir VARCHAR2) IS

  
 CURSOR MAJ_MULTI_CA_MASSE IS
    select l.pid, l.codcamo
    from ligne_bip l, vue_dpg_perime_all s
    where l.codsg = s.codsg
    and s.CODHABILI = 'dir'
    and (s.CODBDDPG like '0630%' or s.CODBDDPG like '0631%')
    and (typproj != 5 and typproj != 7)
    and adatestatut is null;
     
    
    L_HFILE UTL_FILE.FILE_TYPE;
    L_PROCNAME  VARCHAR2(20) := 'MAJ_MULTI_CA_MASSE';
    L_STATEMENT VARCHAR2(1000);
    L_RETCOD    NUMBER;

BEGIN

        L_RETCOD := Trclog.INITTRCLOG( P_LOG_DIR , L_PROCNAME, L_HFILE );
        IF ( L_RETCOD <> 0 ) THEN
        RAISE_APPLICATION_ERROR( -20001,
                                 'Erreur : Gestion du fichier LOG impossible',
                                 FALSE );
        END IF;
        
        
        Trclog.Trclog( L_HFILE, 'Debut de ' || L_PROCNAME );
        
        FOR rec_maj_ca IN MAJ_MULTI_CA_MASSE LOOP
        
            IF (rec_maj_ca.codcamo != 21000 and rec_maj_ca.codcamo != 22000 
                and rec_maj_ca.codcamo != 23000 and rec_maj_ca.codcamo != 24000 
                and rec_maj_ca.codcamo != 66666 and rec_maj_ca.codcamo != 77777) THEN
                
                BEGIN
                
                    L_STATEMENT := '* Traitement ligne : ' || rec_maj_ca.pid ;
                    Trclog.Trclog( l_HFILE, L_STATEMENT );
                
                    UPDATE LIGNE_BIP set codcamo = 77777 where pid = rec_maj_ca.pid;
                    pack_ligne_bip.maj_ligne_bip_logs(rec_maj_ca.pid, 'MAJ_MULTI_CA_MASSE', 'CA payeur', TO_CHAR(rec_maj_ca.codcamo), 77777, 'Modification de la ligne BIP');
                    L_STATEMENT := '- Mise à jour codcamo : ' || rec_maj_ca.codcamo || ' -> 77777' ;
                    Trclog.Trclog( l_HFILE, L_STATEMENT );
                                                   
                    DELETE FROM REPARTITION_LIGNE
                    WHERE pid = rec_maj_ca.pid
                    and datdeb >= to_date('01/12/2009','DD/MM/RRRR');
                    
                    IF (sql%rowcount > 0 )THEN
                      Pack_Ligne_Bip.maj_ligne_bip_logs(rec_maj_ca.pid, 'MAJ_MULTI_CA_MASSE','TOUTES', 'TOUTES', null, 'Suppression (multi CA) à partir de 12/2009');
                      L_STATEMENT := '- Suppression de la repartition à partir de 12/2009';
                      Trclog.Trclog( l_HFILE, L_STATEMENT );
                    END IF; 
                                
                    INSERT INTO REPARTITION_LIGNE (PID, CODCAMO, TAUXREP, DATDEB)
                    VALUES (rec_maj_ca.pid, rec_maj_ca.codcamo, 100, to_date('01/12/2009','DD/MM/RRRR'));
                    Pack_Ligne_Bip.maj_ligne_bip_logs(rec_maj_ca.pid, 'MAJ_MULTI_CA_MASSE',rec_maj_ca.codcamo||' CA payeur', null, rec_maj_ca.codcamo, 'Création CA payeur(multi CA):'||to_char('01/12/2009'));
                    Pack_Ligne_Bip.maj_ligne_bip_logs(rec_maj_ca.pid, 'MAJ_MULTI_CA_MASSE',rec_maj_ca.codcamo||' Taux répartition', null, '100', 'Création CA payeur(multi CA):'||rec_maj_ca.codcamo||' '||to_char('01/12/2009'));
                    L_STATEMENT := '- Création du CA ' || rec_maj_ca.codcamo || ' avec un taux de 100% en date du 12/2009' ;
                    Trclog.Trclog( l_HFILE, L_STATEMENT );
                    
                    INSERT INTO REPARTITION_LIGNE (PID, CODCAMO, TAUXREP, DATDEB)
                    VALUES (rec_maj_ca.pid, 24000, 100, to_date('01/12/2010','DD/MM/RRRR'));
                    Pack_Ligne_Bip.maj_ligne_bip_logs(rec_maj_ca.pid, 'MAJ_MULTI_CA_MASSE', '24000'||' CA payeur', null, '24000', 'Création CA payeur(multi CA):'||to_char('01/12/2010'));
                    Pack_Ligne_Bip.maj_ligne_bip_logs(rec_maj_ca.pid, 'MAJ_MULTI_CA_MASSE', '24000'||' Taux répartition', null, '100', 'Création CA payeur(multi CA):'||'24000'||' '||to_char('01/12/2010'));
                    L_STATEMENT := '- Création du CA 24000 avec un taux de 100% en date du 12/2010' ;
                    Trclog.Trclog( l_HFILE, L_STATEMENT );                

                    UPDATE repartition_ligne l
                    SET l.datfin = (SELECT MIN(rl.datdeb) FROM repartition_ligne rl WHERE rl.datdeb > l.datdeb AND rl.pid = rec_maj_ca.pid )
                    WHERE pid = rec_maj_ca.pid ;
                    L_STATEMENT := '- Mise à jour des dates de fin des répartitions si besoin' ;
                    Trclog.Trclog( l_HFILE, L_STATEMENT );    
            
                    EXCEPTION WHEN
                        OTHERS THEN
                            L_STATEMENT := '- ERREUR : ' ;
                            Trclog.Trclog( l_HFILE, L_STATEMENT || SQLERRM );
                            ROLLBACK;
                    END;
                    
                    COMMIT;
            
            
            
            ELSIF (rec_maj_ca.codcamo = 77777) THEN
            
                BEGIN
                    
                    L_STATEMENT := '* Traitement ligne : ' || rec_maj_ca.pid ;
                    Trclog.Trclog( l_HFILE, L_STATEMENT );
                
            
                    DELETE FROM REPARTITION_LIGNE
                    WHERE pid = rec_maj_ca.pid
                    and datdeb >= to_date('01/12/2010','DD/MM/RRRR');
                                       
                    IF (sql%rowcount > 0 )THEN
                      Pack_Ligne_Bip.maj_ligne_bip_logs(rec_maj_ca.pid, 'MAJ_MULTI_CA_MASSE','TOUTES', 'TOUTES', null, 'Suppression (multi CA) à partir de 12/2010');
                      L_STATEMENT := '- Suppression de la repartition à partir de 12/2010';
                      Trclog.Trclog( l_HFILE, L_STATEMENT );
                    END IF; 
                    
                    INSERT INTO REPARTITION_LIGNE (PID, CODCAMO, TAUXREP, DATDEB)
                    VALUES (rec_maj_ca.pid, 24000, 100, to_date('01/12/2010','DD/MM/RRRR'));
                    Pack_Ligne_Bip.maj_ligne_bip_logs(rec_maj_ca.pid, 'MAJ_MULTI_CA_MASSE', '24000'||' CA payeur', null, '24000', 'Création CA payeur(multi CA):'||to_char('01/12/2010'));
                    Pack_Ligne_Bip.maj_ligne_bip_logs(rec_maj_ca.pid, 'MAJ_MULTI_CA_MASSE', '24000'||' Taux répartition', null, '100', 'Création CA payeur(multi CA):'||'24000'||' '||to_char('01/12/2010'));
                      L_STATEMENT := '- Création du CA 24000 avec un taux de 100% en date du 12/2010' ;
                    Trclog.Trclog( l_HFILE, L_STATEMENT);
    
                    UPDATE repartition_ligne l
                    SET l.datfin = (SELECT MIN(rl.datdeb) FROM repartition_ligne rl WHERE rl.datdeb > l.datdeb AND rl.pid = rec_maj_ca.pid )
                    WHERE pid = rec_maj_ca.pid ;
                    L_STATEMENT := '- Mise à jour des dates de fin des répartitions si besoin' ;
                    Trclog.Trclog( l_HFILE, L_STATEMENT );    
                    
               EXCEPTION WHEN
                    OTHERS THEN
                        L_STATEMENT := '- ERREUR : ' ;
                        Trclog.Trclog( l_HFILE, L_STATEMENT || SQLERRM );
                        ROLLBACK;
                END;
                
                    COMMIT;
                
            END IF;    
            
        
        END LOOP;

           
        Trclog.Trclog( L_HFILE, 'Fin de ' || L_PROCNAME );


END MAJ_MULTI_CA_MASSE;

END PACK_MAJ_MULTI_CA_MASSE;
/