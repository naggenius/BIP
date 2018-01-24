-- pack_branche PL/SQL
--
--
-- 
-- Cree le 23/05/2006 par BAA
--
-- Attention le nom du package ne peut etre le nom
-- Modifié Le 23/05/2006  par BAA création du package pour la fiche 385 paramétrage de l'édition ligne bip
-- Modifié Le 06/09/2006  par BAA correction 
-- de la table...





CREATE OR REPLACE PACKAGE Pack_Paramlignebip AS

   -- Définition curseur sur la table struct_info

   TYPE Libelle_ViewType IS RECORD ( CPID                CHAMP_LIGNE_BIP.IDCPID%TYPE,
   						  	 		  						 					CLIB_PID        PARAMETRE_LIGNE_BIP.CLIB_PID%TYPE,
																				CHAMP          CHAMP_LIGNE_BIP.CPID%TYPE
   			  				          		 					  		      	);


   TYPE LibelleCurType_Char IS REF CURSOR RETURN Libelle_ViewType;



   TYPE lib_ListeChampViewType IS RECORD( CPID                CHAMP_LIGNE_BIP.IDCPID%TYPE,
   						  	 		                                                           CLIB_PID        PARAMETRE_LIGNE_BIP.CLIB_PID%TYPE
                                                                                             );

   TYPE lib_listeChampCurType IS REF CURSOR RETURN lib_ListeChampViewType;


   	 PROCEDURE select_Libelle( p_userid     	              IN  VARCHAR2,
																	 p_curRubrique         IN OUT LibelleCurType_Char ,
                                  									 p_nbcurseur             OUT INTEGER,
                                  									 p_message              OUT VARCHAR2
                                									) ;

      	PROCEDURE update_libelle(	p_userid     	   IN  VARCHAR2,
		  													  p_chaine	        IN  VARCHAR2,
                                                              p_nbcurseur   OUT INTEGER,
                                                              p_message    OUT VARCHAR2
					                                         );

      	PROCEDURE update_select(	p_userid     	   IN  VARCHAR2,
		  													           p_chaine	        IN  VARCHAR2,
                                                                       p_nbcurseur   OUT INTEGER,
                                                                       p_message    OUT VARCHAR2
					                                                 );

		 PROCEDURE select_type( p_userid     	              IN  VARCHAR2,
															    p_curRubrique         IN OUT LibelleCurType_Char ,
                                  								p_nbcurseur             OUT INTEGER,
                                  								p_message              OUT VARCHAR2
                                								) ;

      	PROCEDURE update_type(	p_userid     	   IN  VARCHAR2,
		  													      p_chaine	        IN  VARCHAR2,
                                                                  p_nbcurseur   OUT INTEGER,
                                                                  p_message    OUT VARCHAR2
					                                            );


   PROCEDURE lister_champ_select( p_userid   IN 	  VARCHAR2,
   			 					  			 		  		   			   p_curseur  IN OUT lib_listeChampCurType
                                                                         );


	PROCEDURE lister_champ( p_userid   IN 	  VARCHAR2,
   			 					  			 		  		  p_curseur  IN OUT lib_listeChampCurType
                                                            );


END Pack_Paramlignebip;
/


CREATE OR REPLACE PACKAGE BODY Pack_Paramlignebip  AS



   	 PROCEDURE select_Libelle( p_userid     	            IN  VARCHAR2,
															    p_curRubrique         IN OUT LibelleCurType_Char ,
                                  								p_nbcurseur             OUT INTEGER,
                                  								p_message              OUT VARCHAR2
                                							   )   IS


	v_userid VARCHAR2(255);
	l_msg      VARCHAR2(1024);
	l_count    NUMBER;

   BEGIN

        -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';


	   --initialiser les parametres si ne sont pas initialiser
	  v_userid :=  Pack_Global.lire_globaldata(p_userid).idarpege;
    	
     SELECT COUNT(*) INTO l_count FROM  PARAMETRE_LIGNE_BIP WHERE UPPER(USERID)=UPPER(v_userid);
  
  	 IF( l_count = 0 )THEN
		
	       INSERT INTO PARAMETRE_LIGNE_BIP(USERID, IDCPID, AFFICHE, CLIB_PID, NUM_ORDER) (SELECT UPPER(v_userid) , IDCPID, 'VRAI', CPID, IDCPID FROM CHAMP_LIGNE_BIP);
	      
	       COMMIT;
		
  	 END IF;	
	

	   BEGIN
         OPEN   p_curRubrique FOR
             SELECT c.idcpid, p.CLIB_PID, c.cpid
                                FROM PARAMETRE_LIGNE_BIP p, CHAMP_LIGNE_BIP c
                                WHERE UPPER(p.USERID)=UPPER(v_userid)
                                AND p.IDCPID(+)=c.IDCPID
								AND AFFICHE='VRAI'
								ORDER BY p.NUM_ORDER;

      EXCEPTION

	   WHEN NO_DATA_FOUND THEN

	           INSERT INTO PARAMETRE_LIGNE_BIP(USERID, IDCPID, AFFICHE, CLIB_PID, NUM_ORDER) (SELECT UPPER(v_userid) , IDCPID, 'VRAI', CPID, IDCPID FROM CHAMP_LIGNE_BIP);

	           COMMIT;

        WHEN OTHERS THEN

		  RAISE_APPLICATION_ERROR( -20997, SQLERRM);
  END;

   END select_Libelle;


   --*************************************************************************************************
-- Procédure update_rees
--
-- Permet de modifier la table ressource_ecart
--
-- ************************************************************************************************
PROCEDURE update_libelle(	p_userid     	   IN  VARCHAR2,
		  													  p_chaine	        IN  VARCHAR2,
                                                              p_nbcurseur   OUT INTEGER,
                                                              p_message    OUT VARCHAR2
					                                         ) IS
	l_pos NUMBER(7);
	l_pos1 NUMBER(7);

	l_debug   VARCHAR2(1) := 'N';
	l_msg     VARCHAR2(1024);

	l_cle               CHAMP_LIGNE_BIP.CPID%TYPE;
	l_libelle         PARAMETRE_LIGNE_BIP.CLIB_PID%TYPE;
	l_length NUMBER(7);


    v_userid VARCHAR2(255);
	l_ligne VARCHAR2(200);

BEGIN

	l_debug := 'N';

	p_message:='';

	 v_userid :=  Pack_Global.lire_globaldata(p_userid).idarpege;


	 l_length := LENGTH(p_chaine);

	FOR i IN 1..l_length LOOP

	    l_pos := INSTR(p_chaine,':',1,i);
		l_pos1 := INSTR(p_chaine,':',1,i+1);
		l_ligne := SUBSTR(p_chaine,l_pos+1,l_pos1-l_pos-1);


		l_pos := INSTR(l_ligne,';',1,1);
		l_cle := SUBSTR(l_ligne,1,l_pos-1);
		l_libelle := SUBSTR(l_ligne,l_pos+1);

        DBMS_OUTPUT.PUT_LINE('l_pos:'||l_pos);
		DBMS_OUTPUT.PUT_LINE('l_pos1:'||l_pos1);
		DBMS_OUTPUT.PUT_LINE('l_cle:'||l_cle);
		DBMS_OUTPUT.PUT_LINE('l_libelle:'||l_libelle);

     BEGIN

	     UPDATE PARAMETRE_LIGNE_BIP
		                     SET CLIB_PID= l_libelle
							 WHERE UPPER(USERID)=UPPER(v_userid) AND IDCPID=TO_NUMBER(l_cle);

		EXCEPTION
				WHEN OTHERS THEN
				     RAISE_APPLICATION_ERROR( -20997, SQLERRM);

		    END;

			IF (INSTR(p_chaine,':',1,i+2)=0) THEN
			EXIT;
		END IF;
	END LOOP;



END update_libelle;


  --*************************************************************************************************
-- Procédure update_rees
--
-- Permet de modifier la table ressource_ecart
--
-- ************************************************************************************************
PROCEDURE update_select(	p_userid     	   IN  VARCHAR2,
		  													   p_chaine	        IN  VARCHAR2,
                                                               p_nbcurseur   OUT INTEGER,
                                                               p_message    OUT VARCHAR2
					                                         ) IS
	l_pos NUMBER(7);
	l_pos1 NUMBER(7);

	l_debug   VARCHAR2(1) := 'N';
	l_msg     VARCHAR2(1024);

	l_cle               CHAMP_LIGNE_BIP.CPID%TYPE;
	l_libelle         PARAMETRE_LIGNE_BIP.CLIB_PID%TYPE;
	l_length NUMBER(7);


    v_userid VARCHAR2(255);
	l_ligne VARCHAR2(200);
	compteur NUMBER;

BEGIN

	l_debug := 'N';

	p_message:='';

	 v_userid :=  Pack_Global.lire_globaldata(p_userid).idarpege;

	-- On réinitialise tous
	UPDATE PARAMETRE_LIGNE_BIP
		                     SET AFFICHE='FAUX', NUM_ORDER=NULL
							 WHERE UPPER(USERID)=UPPER(v_userid);
	COMMIT;


	 l_length := LENGTH(p_chaine);

	compteur := 1;

	FOR i IN 1..l_length LOOP

	    l_pos := INSTR(p_chaine,':',1,i);
		l_pos1 := INSTR(p_chaine,':',1,i+1);
		l_ligne := SUBSTR(p_chaine,l_pos+1,l_pos1-l_pos-1);


		l_pos := INSTR(l_ligne,';',1,1);
		l_cle := SUBSTR(l_ligne,1,l_pos-1);
		l_libelle := SUBSTR(l_ligne,l_pos+1);

        DBMS_OUTPUT.PUT_LINE('l_pos:'||l_pos);
		DBMS_OUTPUT.PUT_LINE('l_pos1:'||l_pos1);
		DBMS_OUTPUT.PUT_LINE('l_cle:'||l_cle);
		DBMS_OUTPUT.PUT_LINE('l_libelle:'||l_libelle);

     BEGIN

	     UPDATE PARAMETRE_LIGNE_BIP
		                     SET AFFICHE='VRAI', NUM_ORDER=compteur
							 WHERE UPPER(USERID)=UPPER(v_userid) AND IDCPID=TO_NUMBER(l_cle);

					compteur := compteur +1;

		EXCEPTION
				WHEN OTHERS THEN
				     RAISE_APPLICATION_ERROR( -20997, SQLERRM);
		    END;

			IF (INSTR(p_chaine,':',1,i+2)=0) THEN
			EXIT;
		   END IF;
	END LOOP;



END update_select;



   	 PROCEDURE select_type( p_userid     	            IN  VARCHAR2,
															    p_curRubrique         IN OUT LibelleCurType_Char ,
                                  								p_nbcurseur             OUT INTEGER,
                                  								p_message              OUT VARCHAR2
                                							   )   IS


	v_userid VARCHAR2(255);
	l_msg VARCHAR2(1024);
    l_count    NUMBER;
    l_count1    NUMBER;
   
   BEGIN

        -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

	  v_userid :=  Pack_Global.lire_globaldata(p_userid).idarpege;
	  
	   --initialiser les parametres si ne sont pas initialiser	
     SELECT COUNT(*) INTO l_count1 FROM  PARAMETRE_LIGNE_BIP WHERE UPPER(USERID)=UPPER(v_userid);
  
  	 IF( l_count1 = 0 )THEN
		
	       INSERT INTO PARAMETRE_LIGNE_BIP(USERID, IDCPID, AFFICHE, CLIB_PID, NUM_ORDER) (SELECT UPPER(v_userid) , IDCPID, 'VRAI', CPID, IDCPID FROM CHAMP_LIGNE_BIP);
	      
	       COMMIT;
		
  	 END IF;	

   BEGIN



       SELECT COUNT(TYPPROJ) INTO l_count
				   			   FROM PARAM_TYPE_LIGNE_BIP
							   WHERE UPPER(USERID)=UPPER(v_userid)	AND TYPPROJ IN ('1 ','11');



   IF(l_count <>0)THEN
         OPEN   p_curRubrique FOR
            SELECT TYPPROJ, DECODE(TYPPROJ,'11','Grand T1','1 ','Tous','Type '||TYPPROJ) LIBELLE, ' checked '
				   			   FROM PARAM_TYPE_LIGNE_BIP
							   WHERE UPPER(USERID)=UPPER(v_userid)
            UNION
             SELECT DISTINCT TYPPROJ, DECODE(TYPPROJ,'11','Grand T1','1 ','Tous','Type '||TYPPROJ) LIBELLE, ''
				FROM LIGNE_BIP
				WHERE 	TYPPROJ NOT IN (SELECT TYPPROJ
									   		   		   			 		    FROM PARAM_TYPE_LIGNE_BIP
																			WHERE UPPER(USERID)=UPPER(v_userid)
																			)
				AND TYPPROJ<>'1 '
				ORDER BY TYPPROJ;

		ELSE
		       OPEN   p_curRubrique FOR

			SELECT  '0 ' TYPPROJ, 'Aucun' LIBELLE, ''
			                    FROM DUAL
			UNION
            SELECT TYPPROJ, DECODE(TYPPROJ,'11','Grand T1','1 ','Tous','Type '||TYPPROJ) LIBELLE, ' checked '
				   			   FROM PARAM_TYPE_LIGNE_BIP
							   WHERE UPPER(USERID)=UPPER(v_userid)
            UNION
             SELECT DISTINCT TYPPROJ, DECODE(TYPPROJ,'11','Grand T1','1 ','Tous','Type '||TYPPROJ) LIBELLE, ''
				FROM LIGNE_BIP
				WHERE 	TYPPROJ NOT IN (SELECT TYPPROJ
									   		   		   			 		    FROM PARAM_TYPE_LIGNE_BIP
																			WHERE UPPER(USERID)=UPPER(v_userid)
																			)
				AND TYPPROJ<>'1 '
				ORDER BY TYPPROJ;

		END IF;


      EXCEPTION

	   WHEN NO_DATA_FOUND THEN

	   OPEN   p_curRubrique FOR
	  	      SELECT DISTINCT TYPPROJ, DECODE(TYPPROJ,'11','Grand T1','1 ','Tous','Type '||TYPPROJ) LIBELLE, ''
							FROM LIGNE_BIP
							ORDER BY TYPPROJ;



        WHEN OTHERS THEN

		  RAISE_APPLICATION_ERROR( -20997, SQLERRM);
  END;



   END select_type;


   --*************************************************************************************************
-- Procédure update_rees
--
-- Permet de modifier la table ressource_ecart
--
-- ************************************************************************************************
PROCEDURE update_type(	p_userid     	   IN  VARCHAR2,
		  													  p_chaine	        IN  VARCHAR2,
                                                              p_nbcurseur   OUT INTEGER,
                                                              p_message    OUT VARCHAR2
					                                         ) IS
	l_pos NUMBER(7);
	l_pos1 NUMBER(7);

	l_debug   VARCHAR2(1) := 'N';
	l_msg     VARCHAR2(1024);

	l_cle               CHAMP_LIGNE_BIP.CPID%TYPE;
	l_libelle         PARAMETRE_LIGNE_BIP.CLIB_PID%TYPE;
	l_length NUMBER(7);


    v_userid VARCHAR2(255);
	l_ligne VARCHAR2(200);

BEGIN

	l_debug := 'N';

	p_message:='';

	 v_userid :=  Pack_Global.lire_globaldata(p_userid).idarpege;


	 -- On réinitialise tous
	DELETE FROM PARAM_TYPE_LIGNE_BIP
		               WHERE UPPER(USERID)=UPPER(v_userid);
	COMMIT;

	 l_length := LENGTH(p_chaine);

	FOR i IN 1..l_length LOOP

	    l_pos := INSTR(p_chaine,':',1,i);
		l_pos1 := INSTR(p_chaine,':',1,i+1);
		l_ligne := SUBSTR(p_chaine,l_pos+1,l_pos1-l_pos-1);

		l_pos := INSTR(l_ligne,';',1,1);
		l_cle := SUBSTR(l_ligne,1,l_pos-1);
		l_libelle := SUBSTR(l_ligne,l_pos+1);


	 IF( l_libelle <> '0 ' ) AND ( l_libelle<> ' ') THEN

     BEGIN


	     INSERT INTO PARAM_TYPE_LIGNE_BIP (USERID, TYPPROJ) VALUES(v_userid, l_libelle);

		 COMMIT;


		EXCEPTION
				WHEN OTHERS THEN
				     RAISE_APPLICATION_ERROR( -20997, SQLERRM);

		    END;
	END IF;

			IF (INSTR(p_chaine,':',1,i+2)=0) THEN
			EXIT;
		END IF;
	END LOOP;



END update_type;

PROCEDURE lister_champ_select( p_userid   IN 	  VARCHAR2,
   			 					  			 		  		   			p_curseur  IN OUT lib_listeChampCurType
                                                                        ) IS

	v_userid VARCHAR2(255);
	l_count    NUMBER;

   BEGIN


    v_userid :=  Pack_Global.lire_globaldata(p_userid).idarpege;
  
	
	   --initialiser les parametres si ne sont pas initialiser
 	
     SELECT COUNT(*) INTO l_count FROM  PARAMETRE_LIGNE_BIP WHERE UPPER(USERID)=UPPER(v_userid);
  
  	 IF( l_count = 0 )THEN
		
	       INSERT INTO PARAMETRE_LIGNE_BIP(USERID, IDCPID, AFFICHE, CLIB_PID, NUM_ORDER) (SELECT UPPER(v_userid) , IDCPID, 'VRAI', CPID, IDCPID FROM CHAMP_LIGNE_BIP);
	      
	       COMMIT;
		
  	 END IF;	
	
	
	
      OPEN p_curseur FOR


    SELECT c.idcpid, p.CLIB_PID
          FROM PARAMETRE_LIGNE_BIP p, CHAMP_LIGNE_BIP c
                                WHERE UPPER(p.USERID)=UPPER(v_userid)
                                AND p.IDCPID(+)=c.IDCPID
								AND AFFICHE='VRAI'
								ORDER BY p.NUM_ORDER;



   END lister_champ_select;


   PROCEDURE lister_champ( p_userid   IN 	  VARCHAR2,
   			 					  			 		  		 p_curseur  IN OUT lib_listeChampCurType
                                                           ) IS

   v_userid VARCHAR2(255);
   l_count NUMBER;
   
   BEGIN


       	  v_userid :=  Pack_Global.lire_globaldata(p_userid).idarpege;
		  
	      --initialiser les parametres si ne sont pas initialiser

    	
     SELECT COUNT(*) INTO l_count FROM  PARAMETRE_LIGNE_BIP WHERE UPPER(USERID)=UPPER(v_userid);
  
  	 IF( l_count = 0 )THEN
		
	       INSERT INTO PARAMETRE_LIGNE_BIP(USERID, IDCPID, AFFICHE, CLIB_PID, NUM_ORDER) (SELECT UPPER(v_userid) , IDCPID, 'VRAI', CPID, IDCPID FROM CHAMP_LIGNE_BIP);
	      
	       COMMIT;
		
  	 END IF;	
	   
      OPEN p_curseur FOR


	     SELECT c.idcpid, p.CLIB_PID
          FROM PARAMETRE_LIGNE_BIP p, CHAMP_LIGNE_BIP c
                                WHERE UPPER(p.USERID)=UPPER(v_userid)
                                AND p.IDCPID(+)=c.IDCPID
								AND AFFICHE='FAUX'
								ORDER BY p.NUM_ORDER;





   END lister_champ;




END Pack_Paramlignebip;
/

