-- Package permet la mise à jour des tables ressource et immeuble
-- Créé le 27/09/2005 par BAA
-- Modifié 19/06/2012 BSA QC 1286
-- Modifié 04/09/2012 BSA QC 1286 : correction ano sur clone (recuperation igg principale)
----------------------------------------------------------------------------------------


CREATE OR REPLACE PACKAGE       "PACK_BATCH_RESSIMMEUB" AS






--***********************************************************
-- Procédure de mise à jour les tables ressource et immeuble
-- à partir des tables TMP_PERSONNE et TMP_IMMEUBLE
--***********************************************************

PROCEDURE maj_ressource(P_LOGDIR          IN VARCHAR2)   ;







END pack_batch_ressimmeub;
/


CREATE OR REPLACE PACKAGE BODY "PACK_BATCH_RESSIMMEUB" AS


-----------------------------------------------------
-- Gestions exceptions
-----------------------------------------------------
CALLEE_FAILED EXCEPTION;
pragma EXCEPTION_init( CALLEE_FAILED, -20000 );
CALLEE_FAILED_ID     number := -20000;   -- pour propagation dans pile d'appel
TRCLOG_FAILED_ID     number := -20001;   -- problème : erreur dans la gestion d'erreur !
ERR_FONCTIONNELLE_ID number := -20002;   -- pour provoquer erreur alors que Oracle OK
CONSTRAINT_VIOLATION EXCEPTION;          -- pour clause when
pragma EXCEPTION_init( CONSTRAINT_VIOLATION, -2291 ); -- typiquement : clé étrangère



--***********************************************************
-- Procédure de mise à jour les tables ressource et immeuble
-- à partir des tables TMP_PERSONNE et TMP_IMMEUBLE
--***********************************************************

PROCEDURE maj_ressource(P_LOGDIR          IN VARCHAR2)  IS


    L_PROCNAME  varchar2(16) := 'MAJ_RESS_IMME';
    L_STATEMENT varchar2(128);
    L_HFILE     utl_file.file_type;
    L_RETCOD    number;

    CURSOR cur_re IS
        SELECT *
        FROM ressource
        WHERE rtype='P' ;

    CURSOR c_tmp_igg (p_igg TMP_PERSONNE.IGG%TYPE) IS
        SELECT MATRICULE, IADRABR, BATIMENT, ETAGE, BUREAU, RTEL, IGG
        FROM TMP_PERSONNE
        WHERE IGG = p_igg;

    t_tmp_igg c_tmp_igg%ROWTYPE;

    CURSOR c_tmp_matricule (p_matricule TMP_PERSONNE.MATRICULE%TYPE) IS
        SELECT MATRICULE, IADRABR, BATIMENT, ETAGE, BUREAU, RTEL, IGG
        FROM TMP_PERSONNE
        WHERE MATRICULE = p_matricule;
        
    t_tmp_matricule c_tmp_matricule%ROWTYPE;

    CURSOR c_tmp_immeuble ( p_iadrabr TMP_PERSONNE.IADRABR%TYPE ) IS
        SELECT ICODIMM, FLAGLOCK
        FROM TMP_IMMEUBLE
        WHERE IADRABR = p_iadrabr;        

    t_tmp_immeuble c_tmp_immeuble%ROWTYPE;
           
    v_MATRICULE tmp_personne.matricule%TYPE;
    v_IADRABR   tmp_personne.iadrabr%TYPE;
    v_BATIMENT  tmp_personne.batiment%TYPE;
    v_ETAGE     tmp_personne.etage%TYPE;
    v_BUREAU    tmp_personne.bureau%TYPE;
    v_RTEL      tmp_personne.rtel%TYPE;
    v_ICODIMM   tmp_immeuble.ICODIMM%TYPE;
    v_IGG       tmp_personne.IGG%TYPE;

    v_FLAGLOCK 	tmp_immeuble.flaglock%TYPE;

    l_ICODIMM   immeuble.ICODIMM%TYPE;

    t_igg       TMP_PERSONNE.IGG%TYPE;    
    t_matricule TMP_PERSONNE.MATRICULE%TYPE;
    
    l_user      RESSOURCE_LOGS.USER_LOG%TYPE;
    
BEGIN

    l_user := 'BATCH_URBANN';    

   -----------------------------------------------------
	-- Init de la trace
	-----------------------------------------------------
		L_RETCOD := TRCLOG.INITTRCLOG( P_LOGDIR , L_PROCNAME, L_HFILE );
		if ( L_RETCOD <> 0 ) then
		raise_application_error( TRCLOG_FAILED_ID,
		                        'Erreur : Gestion du fichier LOG impossible',
		                         false );
		end if;

    -----------------------------------------------------
	-- Trace Start
	-----------------------------------------------------


    TRCLOG.TRCLOG( L_HFILE, 'Debut de ' || L_PROCNAME );


	FOR curseur IN cur_re LOOP
	 	BEGIN

            --t_donne_tmp_trouve := FALSE;
            
            -- Regles relative a IGG en respectant l ordre de priorite :
            /*
            
            IGG Renseigné
            
                1 - Charger les données pour les ressources dont l'IGG est renseigné dans la table BIP_RESSOURCES.
            
                2 - Pour les IGG (BIP_RESSOURCES) en 9xxxxxxxxx, copier les données de l'IGG de base (fichier) en 1xxxxxxxxx
            
            IGG Non renseigné
            
                3 - Pour les ressources n'ayant pas d'IGG de renseigné mais un Matricule SG, 
                    charger les données relatives au matricule.
                
                4 - Pour les ressources n'ayant pas d'IGG de renseigné mais un Matricule en X, 
                    charger les données relatives au matricule.
                
                5 - Pour les ressources n'ayant pas d'IGG de renseigné mais un Matricule en Y, 
                    copier les données du matricule en X.
                
            Si l'IGG et le matricule ne sont pas trouvés dans le fichier personne.col, 
            alors les champs sont laissés commme actuellement à 0 ou blanc
            
            */            
            
            -- regle 1 et 2 : IGG renseigne
            IF ( curseur.IGG IS NOT NULL )THEN
               
                -- Pour les doublons IGG 9.....
                IF ( SUBSTR(curseur.IGG,1,1 ) = '9' ) THEN                
                    t_igg := '1' || SUBSTR(curseur.IGG,2 );
                ELSE                
                    t_igg := curseur.IGG;                    
                END IF;                

                OPEN c_tmp_igg ( t_igg);
                FETCH c_tmp_igg INTO t_tmp_igg;
                IF ( c_tmp_igg%FOUND ) THEN


                    OPEN c_tmp_immeuble(t_tmp_igg.IADRABR );
                    FETCH c_tmp_immeuble INTO t_tmp_immeuble;
                    IF c_tmp_immeuble%FOUND THEN
                        v_ICODIMM := t_tmp_immeuble.ICODIMM;
                        v_FLAGLOCK := t_tmp_immeuble.FLAGLOCK;
                        
                         -- Si la ressource a changer d'immeuble
                        IF( curseur.icodimm <> v_ICODIMM)THEN
                            BEGIN

                                SELECT ICODIMM INTO l_ICODIMM FROM IMMEUBLE WHERE ICODIMM = v_ICODIMM;

                                EXCEPTION

                                WHEN No_Data_Found THEN

                                   INSERT INTO immeuble
                                      	   VALUES(v_ICODIMM,SUBSTR(v_IADRABR,1,10),v_FLAGLOCK);

                            END;

                        END IF;
                    
                        UPDATE RESSOURCE
                           SET  ICODIMM     = v_ICODIMM,
                         	    BATIMENT    = t_tmp_igg.BATIMENT,
                              	ETAGE       = t_tmp_igg.ETAGE,
                            	BUREAU      = t_tmp_igg.BUREAU,
                            	RTEL        = t_tmp_igg.RTEL
                         	WHERE IDENT = curseur.IDENT;

                    
                    ELSE
                    
                        UPDATE RESSOURCE
                           SET  BATIMENT    = t_tmp_igg.BATIMENT,
                              	ETAGE       = t_tmp_igg.ETAGE,
                            	BUREAU      = t_tmp_igg.BUREAU,
                            	RTEL        = t_tmp_igg.RTEL
                         	WHERE IDENT = curseur.IDENT;                   

                    
                    END IF;
                    CLOSE c_tmp_immeuble;

                    COMMIT;
                                    
                END IF;
                    
                CLOSE c_tmp_igg;  

            -- regle 3, 4 et 5 : IGG null
            ELSE
                
                -- Pour les doublons Matricule Y.....
                IF ( SUBSTR(curseur.MATRICULE,1,1 ) = 'Y' ) THEN                
                    t_matricule := 'X' || SUBSTR(curseur.MATRICULE,2 );
                ELSE                
                    t_matricule := curseur.MATRICULE;                    
                END IF;                

                OPEN c_tmp_matricule ( t_matricule);
                FETCH c_tmp_matricule INTO t_tmp_matricule;
                IF ( c_tmp_matricule%FOUND ) THEN
                
                    -- Dans le fichier Urbann il n'existe pas de notion de clone que des X ou/et 1
                    -- Si on met a jour le clone on transforme l'igg trouvé en 9....
                    --   sinon on laisse l'igg intacte
                    IF t_tmp_matricule.IGG IS NOT NULL THEN
                        
                        IF ( SUBSTR(curseur.MATRICULE,1,1 ) = 'Y' ) THEN                         
                            t_igg := '9' || SUBSTR(t_tmp_matricule.IGG,2 );           
                        ELSE                
                            t_igg := t_tmp_matricule.IGG;                    
                        END IF;
                                            
                    ELSE
                        
                        t_igg := NULL;
                         
                    END IF;
                    
                    OPEN c_tmp_immeuble(t_tmp_matricule.IADRABR );
                    FETCH c_tmp_immeuble INTO t_tmp_immeuble;
                    IF c_tmp_immeuble%FOUND THEN
                        v_ICODIMM := t_tmp_immeuble.ICODIMM;
                        v_FLAGLOCK := t_tmp_immeuble.FLAGLOCK;
                        
                         -- Si la ressource a changer d'immeuble
                        IF( curseur.icodimm <> v_ICODIMM)THEN
                            BEGIN

                                SELECT ICODIMM INTO l_ICODIMM FROM IMMEUBLE WHERE ICODIMM = v_ICODIMM;

                                EXCEPTION

                                WHEN No_Data_Found THEN

                                   INSERT INTO immeuble
                                      	   VALUES(v_ICODIMM,SUBSTR(v_IADRABR,1,10),v_FLAGLOCK);

                            END;

                        END IF;
                    
                        UPDATE ressource
                           SET  ICODIMM     = v_ICODIMM,
                         	    BATIMENT    = t_tmp_matricule.BATIMENT,
                              	ETAGE       = t_tmp_matricule.ETAGE,
                            	BUREAU      = t_tmp_matricule.BUREAU,
                            	RTEL        = t_tmp_matricule.RTEL,
                                IGG         = t_igg
                         	WHERE ident = curseur.ident;
                            
                         -- On loggue le nom, prenom et igg dans la table ressource
                         Pack_Ressource_P.maj_ressource_logs(curseur.ident, l_user, 'RESSOURCE', 'IGG', curseur.igg, t_igg, 'Modification de la ressource');       
                                              
                    ELSE
                    
                        UPDATE ressource
                           SET  BATIMENT    = t_tmp_matricule.BATIMENT,
                              	ETAGE       = t_tmp_matricule.ETAGE,
                            	BUREAU      = t_tmp_matricule.BUREAU,
                            	RTEL        = t_tmp_matricule.RTEL,
                                IGG         = t_igg
                         	WHERE ident = curseur.ident;     
                                           
                         -- On loggue le nom, prenom et igg dans la table ressource
                         Pack_Ressource_P.maj_ressource_logs(curseur.ident, l_user, 'RESSOURCE', 'IGG', curseur.igg, t_igg, 'Modification de la ressource');       
                    
                    END IF;
                    CLOSE c_tmp_immeuble;

                    COMMIT;
                
                END IF;
                   
                CLOSE c_tmp_matricule;

            END IF;  
                 
		EXCEPTION

			 WHEN No_Data_Found THEN
			 	--UPDATE ressource
			    --SET  BUREAU = curseur.bureau
			  	--WHERE matricule = curseur.matricule;
				rollback;

			 WHEN others then
	   			rollback;
				if sqlcode <> CALLEE_FAILED_ID then
				    TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
				end if;
		        TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		        raise CALLEE_FAILED;

        END;

    END LOOP;

    TRCLOG.TRCLOG( L_HFILE, 'Fin NORMALE de ' || L_PROCNAME);

EXCEPTION
	WHEN others THEN
	    ROLLBACK;
		IF sqlcode <> CALLEE_FAILED_ID then
				TRCLOG.TRCLOG( L_HFILE, L_PROCNAME ||' [' || L_STATEMENT ||'] : ' || SQLERRM );
		END IF;
		TRCLOG.TRCLOG( L_HFILE, 'Fin ANORMALE de ' || L_PROCNAME  );
		RAISE CALLEE_FAILED;


END maj_ressource;


END pack_batch_ressimmeub;
/


