-- pack_lock PL/SQL
--
-- Attention le nom du package ne peut etre le nom de la table...
--
-- Cree le 04/07/2012 QC 1343
--  MAJ le
--12/12/12 ABA : QC 1343

CREATE OR REPLACE PACKAGE BIP."PACK_LOCK" AS

PROCEDURE RESET_LOCK_USER ( p_userid    IN VARCHAR2,
                            p_fonction  IN VARCHAR2);



PROCEDURE GESTION_LOCK (p_userid      IN  VARCHAR2,
                        p_fonction    IN  VARCHAR2,
                        p_valeur      IN  VARCHAR2,
                        p_lock        OUT VARCHAR2,
                        p_message     OUT VARCHAR2);


END PACK_LOCK;
/
CREATE OR REPLACE PACKAGE BODY BIP."PACK_LOCK" AS

-- Purge des locks
PROCEDURE RESET_LOCK_USER ( p_userid    IN VARCHAR2,
                            p_fonction  IN VARCHAR2) IS
       
    t_user_rtfe RTFE_USER.USER_RTFE%TYPE;
    
    t_delai 	    parametre.valeur%TYPE;
    t_listeValeurs  parametre.liste_valeurs%TYPE;
    t_libelle       parametre.libelle%TYPE;
    t_message       VARCHAR2(1000);
                       
BEGIN

    -- Recuperation du user RTFE
    t_user_rtfe := pack_global.lire_globaldata(p_userid).idarpege;

    -- Recuperation du delai
    PACK_PARAMETRE.select_parametre('LOCK_TIME',t_delai, t_listeValeurs,t_libelle,t_message);

      
    -- TOP des sessions expirées 
       UPDATE tmp_lock l set expire = 'O' where
          l.FONCTION = p_fonction 
            AND   round((sysdate - l.date_dernier_acces)*1440,1) > t_delai ;
           
    
    -- Purge des anciens lock + celui de l utilisateur en cours
    DELETE FROM TMP_LOCK l
  WHERE 1=1
      AND l.FONCTION = p_fonction 
    AND  UPPER(l.USER_RTFE) = UPPER(t_user_rtfe) ;

 
END RESET_LOCK_USER;


PROCEDURE GESTION_LOCK (p_userid      IN  VARCHAR2,
                        p_fonction    IN  VARCHAR2,
                        p_valeur      IN  VARCHAR2,
                        p_lock        OUT VARCHAR2,
                        p_message     OUT VARCHAR2) IS

    t_retour    VARCHAR2(10);
    t_date      DATE;
    t_user_rtfe RTFE_USER.USER_RTFE%TYPE;

    CURSOR c_lock IS
        SELECT l.USER_RTFE , l.DATE_DERNIER_ACCES, EXPIRE  FROM TMP_LOCK l
        WHERE 1 = 1
            AND UPPER(l.FONCTION) = UPPER(p_fonction)
            AND l.VALEUR = p_valeur;
    
    t_lock  c_lock%ROWTYPE;

    CURSOR c_user(t_matricule RESSOURCE.MATRICULE%TYPE) IS
        SELECT r.USER_RTFE , r.NOM, r.PRENOM
        FROM RTFE_USER r
        WHERE UPPER(TRIM(r.USER_RTFE)) = UPPER(TRIM(t_matricule)) ;
        
    t_user  c_user%ROWTYPE;
        
    t_delai 	    parametre.valeur%TYPE;
    t_listeValeurs  parametre.liste_valeurs%TYPE;
    t_libelle       parametre.libelle%TYPE;
    t_message       VARCHAR2(1000);          
    l_presence      number(2);
            
    BEGIN

        -- Recuperation du delai
        BEGIN
        
            PACK_PARAMETRE.select_parametre('LOCK_TIME',t_delai, t_listeValeurs,t_libelle,t_message);
            
            EXCEPTION
                WHEN OTHERS THEN
                    t_delai := '30';
        END;
            
        t_date := SYSDATE - t_delai/1440 ;  -- p_delai en minute
        
        -- Recuperation du user RTFE
        t_user_rtfe := pack_global.lire_globaldata(p_userid).idarpege;
        
        t_retour := 'N';
        
        
         UPDATE tmp_lock l set expire = 'O' where
              l.FONCTION = p_fonction 
           AND   round((sysdate - l.date_dernier_acces)*1440,1) > t_delai ;
           commit;
    
    
                 BEGIN
                       Select count(*) into l_presence from tmp_lock
                       where 
                             UPPER(FONCTION) = UPPER(p_fonction)
                             AND VALEUR = p_valeur
                             and UPPER(user_rtfe) =  UPPER(t_user_rtfe)
                             and expire = 'O' ;
              
            
                                                                 
                 IF  l_presence  !=  0 THEN
                 
                 --round((sysdate - t_lock.date_dernier_acces)*1440,1) > t_delai THEN
                   Pack_Global.recuperer_message(21262, NULL, NULL,NULL, t_message);
                   p_message := t_message;
                  t_retour := 'O';
                 END IF;
             
          
            END;   
    
    
    
       -- Purge des anciens lock + celui de l utilisateur en cours
      DELETE FROM TMP_LOCK l
      WHERE 1=1
           AND l.FONCTION = p_fonction 
         AND l.USER_RTFE = t_user_rtfe; 
             

            
        -- Recherche du lock sur la valeur
        OPEN c_lock;
        FETCH c_lock INTO t_lock;
        IF c_lock%FOUND THEN
            
            IF (UPPER(t_lock.USER_RTFE) <> UPPER(t_user_rtfe) AND t_lock.expire != 'O' ) THEN
               
                t_retour := 'O';
                
                -- Recuperation de l utilisateur
                OPEN c_user(t_lock.USER_RTFE);
                FETCH c_user INTO t_user;
                CLOSE c_user;
                
                Pack_Global.recuperer_message(21249, '%s1', t_user.USER_RTFE , '%s2', t_user.NOM ,'%s3', t_user.PRENOM, NULL, t_message);
                
                p_message := t_message;
                  
           ELSE
        
             INSERT INTO TMP_LOCK ( USER_RTFE,DATE_ACCES,DATE_DERNIER_ACCES,FONCTION,VALEUR,EXPIRE)
             VALUES (TRIM(t_user_rtfe), SYSDATE, SYSDATE, p_fonction, p_valeur,'N' );    
                        
            END IF;
            
        ELSE
        
            INSERT INTO TMP_LOCK ( USER_RTFE,DATE_ACCES,DATE_DERNIER_ACCES,FONCTION,VALEUR,EXPIRE)
            VALUES (TRIM(t_user_rtfe), SYSDATE, SYSDATE, p_fonction, p_valeur,'N' );
        
        END IF;
        CLOSE c_lock;        
        
        p_lock := t_retour;


    END GESTION_LOCK;

END PACK_LOCK;
/

