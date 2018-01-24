-- pack_branche PL/SQL
--
--
-- 
-- Cree le 06/02/2006 par BAA
--
-- Attention le nom du package ne peut etre le nom
-- Modifié Le 01/02/2006  par BAA Ajout de la procedure lister_direction
-- Modifié Le 03/05/2006  par BAA Correction
-- de la table...


	
CREATE OR REPLACE PACKAGE Pack_Rubrique AS

   -- Définition curseur sur la table struct_info

   TYPE Rubrique_ViewType IS RECORD ( codrub                 RUBRIQUE.codrub%TYPE,
   						  	 		  						 					  	  coddir                  RUBRIQUE.coddir%TYPE,
   			  				          		 					  		              libdir                     VARCHAR2(80),
																					  libelle                   VARCHAR2(80),
																					  codep                  RUBRIQUE.codep%TYPE,
    																				  codfei                   RUBRIQUE.codfei%TYPE,
   																					  CAFI                      RUBRIQUE.CAFI%TYPE,
																					  LIBCAFI                VARCHAR2(80),
   																					  comptedeb         RUBRIQUE.comptedeb%TYPE,
																					  libcomptedeb     VARCHAR2(80),
   																					  comptecre           RUBRIQUE.comptecre%TYPE,
																					  libcomptecre      VARCHAR2(80),
   																					  schemacpt          RUBRIQUE.schemacpt%TYPE,
   																					  appli                      RUBRIQUE.appli%TYPE,
  																					  datedemande    RUBRIQUE.datedemande%TYPE,
   																					  dateretour            RUBRIQUE.dateretour%TYPE,
   																					  commentaires    RUBRIQUE.commentaires%TYPE,
   																					  flaglock   	           RUBRIQUE.flaglock%TYPE
					 					                                          );

   TYPE RubriqueCurType_Char IS REF CURSOR RETURN Rubrique_ViewType;


    PROCEDURE insert_Rubrique( 	p_codrub                 IN  VARCHAR2,
   			  				          		 					  	p_coddir                   IN VARCHAR2,
																	p_codep                   IN VARCHAR2,
    																p_codfei                    IN VARCHAR2,
   																	p_CAFI                       IN VARCHAR2,
   																	p_comptedeb          IN VARCHAR2,
   																	p_comptecre            IN VARCHAR2,
   																	p_schemacpt           IN VARCHAR2,
   																	p_appli                       IN VARCHAR2,
  																	p_datedemande     IN VARCHAR2,
   																	p_dateretour             IN VARCHAR2,
   																	p_commentaires     IN VARCHAR2,
                                  									p_userid     	             IN  VARCHAR2,
                                  									p_nbcurseur             OUT INTEGER,
                                  									p_message              OUT VARCHAR2
                                									)  ;


	PROCEDURE update_rubrique ( 	p_codrub                IN VARCHAR2,
   			  				          		 					  	  p_coddir                  IN VARCHAR2,
																	  p_codep                   IN VARCHAR2,
    																  p_codfei                   IN VARCHAR2,
   																	  p_CAFI                      IN VARCHAR2,
   																	  p_comptedeb       IN VARCHAR2,
   																	  p_comptecre           IN VARCHAR2,
   																	  p_schemacpt          IN VARCHAR2,
   																	  p_appli                       IN VARCHAR2,
  																	  p_datedemande     IN VARCHAR2,
   																	  p_dateretour             IN VARCHAR2,
   																	  p_commentaires    IN VARCHAR2,
                                  	 						 	      p_userid     	               IN  VARCHAR2,
																	  p_flaglock   	             IN VARCHAR2,
				  													  p_nbcurseur  	  OUT INTEGER,
                                  									  p_message    	 OUT VARCHAR2
                              										);



	PROCEDURE delete_rubrique ( p_codrub                  IN  RUBRIQUE.codrub%TYPE,
			  				  							  	  		p_flaglock 	                IN  NUMBER,
   			  				          		 					  	p_userid                     IN  VARCHAR2,
																    p_nbcurseur             OUT INTEGER,
                                  								    p_message               OUT VARCHAR2
                         										   );

	 PROCEDURE select_Rubrique( p_codrub          	       IN RUBRIQUE.CODRUB%TYPE,
					 	                                          	 p_userid     	              IN  VARCHAR2,
																	 p_curRubrique         IN OUT RubriqueCurType_Char ,
                                  									 p_nbcurseur             OUT INTEGER,
                                  									 p_message              OUT VARCHAR2
                                									) ;

END Pack_Rubrique;
/




CREATE OR REPLACE PACKAGE BODY Pack_Rubrique AS



 PROCEDURE insert_Rubrique( 	p_codrub                 IN  VARCHAR2,
   			  				          		 					  	p_coddir                   IN VARCHAR2,
																	p_codep                   IN VARCHAR2,
    																p_codfei                    IN VARCHAR2,
   																	p_CAFI                       IN VARCHAR2,
   																	p_comptedeb          IN VARCHAR2,
   																	p_comptecre            IN VARCHAR2,
   																	p_schemacpt           IN VARCHAR2,
   																	p_appli                       IN VARCHAR2,
  																	p_datedemande     IN VARCHAR2,
   																	p_dateretour             IN VARCHAR2,
   																	p_commentaires     IN VARCHAR2,
                                  									p_userid     	             IN  VARCHAR2,
                                  									p_nbcurseur             OUT INTEGER,
                                  									p_message              OUT VARCHAR2
                                									)  IS

     l_msg VARCHAR2(1024);
     l_msg_alert VARCHAR2(1024);
     l_exist NUMBER;
     l_count NUMBER;
	 l_count2 NUMBER;
	 l_diff NUMBER;

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

	  
	  SELECT COUNT(*)   INTO l_count2 FROM RUBRIQUE 
	                              WHERE codfei =  TO_NUMBER(p_codfei)
								  AND CAFI =  TO_NUMBER(p_CAFI);
		
	IF(l_count2 <> 0)THEN

	          Pack_Global.recuperer_message(20958, '%s1', TO_NUMBER(p_cafi),NULL, l_msg);
			  RAISE_APPLICATION_ERROR( -20958, l_msg );

	END IF;		
      	  
	 IF(TO_NUMBER(p_cafi) = 99999) OR (TO_NUMBER(p_cafi)=88888)THEN

	          Pack_Global.recuperer_message(20957, '%s1', TO_NUMBER(p_cafi),NULL, l_msg);
			  RAISE_APPLICATION_ERROR( -20957, l_msg );

	END IF;

    SELECT COUNT(*) INTO l_count FROM STRUCT_INFO WHERE CAFI=p_cafi AND TOPFER='O';

	IF(p_dateretour IS NOT NULL) AND (p_datedemande IS NOT  NULL) THEN

	                SELECT TO_DATE(p_dateretour,'dd/mm/yyyy') - TO_DATE(p_datedemande,'dd/mm/yyyy') INTO l_diff FROM dual;

					IF(l_diff < 0)THEN

	         		 		  Pack_Global.recuperer_message(20956, '%s1', p_cafi,NULL, l_msg);
			  		 		RAISE_APPLICATION_ERROR( -20956, l_msg );

				  END IF;

	END IF;


	IF(l_count != 0)THEN


	BEGIN
     	   INSERT INTO RUBRIQUE
	       		  	   		 		   	                  ( codrub,
   			  				        					   coddir,
								    					   codep,
    													   codfei,
   														   CAFI,
   														   comptedeb,
   														   comptecre,
   														   schemacpt,
   														   appli,
  														   datedemande,
   														   dateretour,
   														   commentaires,
   														   flaglock)
         VALUES ( TO_NUMBER(p_codrub),
		   		  			  TO_NUMBER(p_coddir),
							  TO_NUMBER(p_codep),
    						  TO_NUMBER(p_codfei),
   							  TO_NUMBER(p_CAFI),
   							  TO_NUMBER(p_comptedeb),
   							  TO_NUMBER(p_comptecre),
   							  TO_NUMBER(p_schemacpt),
   							  p_appli,
  							  TO_DATE(p_datedemande,'dd/mm/yyyy'),
   							  TO_DATE(p_dateretour,'dd/mm/yyyy'),
   							   p_commentaires,
   							   0
							  );

		COMMIT;

	  Pack_Global.recuperer_message( 20971, '%s1', p_codrub, NULL, l_msg);

	 p_message := l_msg;

     EXCEPTION
      	WHEN DUP_VAL_ON_INDEX THEN
		       Pack_Global.recuperer_message( 21059, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20001, l_msg );

     END;


	 ELSE
			  Pack_Global.recuperer_message(20955, '%s1', p_cafi,NULL, l_msg);
			  RAISE_APPLICATION_ERROR( -20955, l_msg );
	 END IF;


   END insert_rubrique;

	PROCEDURE update_rubrique ( 	p_codrub                IN VARCHAR2,
   			  				          		 					  	  p_coddir                  IN VARCHAR2,
																	  p_codep                   IN VARCHAR2,
    																  p_codfei                   IN VARCHAR2,
   																	  p_CAFI                      IN VARCHAR2,
   																	  p_comptedeb       IN VARCHAR2,
   																	  p_comptecre           IN VARCHAR2,
   																	  p_schemacpt          IN VARCHAR2,
   																	  p_appli                       IN VARCHAR2,
  																	  p_datedemande     IN VARCHAR2,
   																	  p_dateretour             IN VARCHAR2,
   																	  p_commentaires    IN VARCHAR2,
                                  	 						 	      p_userid     	               IN  VARCHAR2,
																	  p_flaglock   	             IN VARCHAR2,
				  													  p_nbcurseur  	  OUT INTEGER,
                                  									  p_message    	 OUT VARCHAR2
                              										)  IS

	 l_msg               VARCHAR2(1024);
	 l_type               VARCHAR2(10);
	 l_count             NUMBER;
	 l_count1           NUMBER;
	 l_count2           NUMBER;
     l_diff 			     NUMBER;

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- initialiser le message retour

	p_nbcurseur := 0;
	p_message := '';

	
	SELECT COUNT(*)  INTO l_count2 FROM RUBRIQUE 
	                              WHERE codfei =  TO_NUMBER(p_codfei)
								  AND CAFI =  TO_NUMBER(p_CAFI)
								  AND CODRUB <> p_codrub ;
		
	IF(l_count2 <> 0)THEN

	          Pack_Global.recuperer_message(20958, '%s1', TO_NUMBER(p_cafi),NULL, l_msg);
			  RAISE_APPLICATION_ERROR( -20958, l_msg );

	END IF;							  

	 IF(TO_NUMBER(p_cafi) = 99999) OR (TO_NUMBER(p_cafi)=88888)THEN

	          Pack_Global.recuperer_message(20957, '%s1', TO_NUMBER(p_cafi),NULL, l_msg);
			  RAISE_APPLICATION_ERROR( -20957, l_msg );

	END IF;


	SELECT COUNT(*) INTO l_count1 FROM STRUCT_INFO WHERE CAFI=p_cafi AND TOPFER='O';

	IF(p_dateretour IS NOT  NULL) AND (p_datedemande IS NOT NULL) THEN

	                SELECT TO_DATE(p_dateretour,'dd/mm/yyyy') - TO_DATE(p_datedemande,'dd/mm/yyyy') INTO l_diff FROM dual;

					IF(l_diff < 0)THEN

	         		 		  Pack_Global.recuperer_message(20956, '%s1', p_cafi,NULL, l_msg);
			  		 		RAISE_APPLICATION_ERROR( -20956, l_msg );

				  END IF;

	END IF;


   IF(l_count1 != 0)THEN


	BEGIN

        UPDATE RUBRIQUE
		SET	 codrub = TO_NUMBER(p_codrub),
		   		   coddir = TO_NUMBER(p_coddir),
				   codep =  TO_NUMBER(p_codep),
    			   codfei =  TO_NUMBER(p_codfei),
   				   CAFI =  TO_NUMBER(p_CAFI),
   				   comptedeb = TO_NUMBER(p_comptedeb),
   				   comptecre =  TO_NUMBER(p_comptecre),
   				   schemacpt =  TO_NUMBER(p_schemacpt),
   				   appli =  p_appli,
  				   datedemande = TO_DATE(p_datedemande,'dd/mm/yyyy'),
   				   dateretour = TO_DATE(p_dateretour,'dd/mm/yyyy'),
   				   commentaires = p_commentaires,
				   flaglock 	= DECODE( p_flaglock, 1000000, 0, p_flaglock + 1 )
				 WHERE codrub 	= TO_NUMBER(p_codrub)
                 AND flaglock 	= p_flaglock;

	EXCEPTION

		WHEN OTHERS THEN
	         RAISE_APPLICATION_ERROR( -20754, l_msg );
		 END;


      IF SQL%NOTFOUND THEN

	   -- 'Accès concurrent'

	      Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         RAISE_APPLICATION_ERROR( -20999, l_msg );

      ELSE


	   -- 'La rubrique  p_codrub a été modifié'

	         Pack_Global.recuperer_message( 20972, '%s1', p_codrub, NULL, l_msg);
		  	 p_message := l_msg;
      END IF;

	  ELSE
			  Pack_Global.recuperer_message(20955, '%s1', p_cafi,NULL, l_msg);
			  RAISE_APPLICATION_ERROR( -20955, l_msg );
	 END IF;


   END update_rubrique;

	PROCEDURE delete_rubrique ( p_codrub                  IN  RUBRIQUE.codrub%TYPE,
			  				  							  	  		p_flaglock 	                IN  NUMBER,
   			  				          		 					  	p_userid                     IN  VARCHAR2,
																    p_nbcurseur             OUT INTEGER,
                                  								    p_message               OUT VARCHAR2
                         										   ) IS


	  l_msg VARCHAR2(1024);
      referential_integrity EXCEPTION;
	  l_count NUMBER;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

	  
	  SELECT COUNT(*) INTO l_count FROM STRUCT_INFO 
	                           WHERE TOPFER='O'
							   AND CAFI IN (SELECT CAFI FROM RUBRIQUE WHERE codrub=p_codrub);
	  
	  IF(l_count = 0)THEN
	  
      BEGIN
	   DELETE FROM RUBRIQUE
		    WHERE codrub = TO_NUMBER(p_codrub)
			AND flaglock = TO_NUMBER(p_flaglock);

         EXCEPTION
		WHEN referential_integrity THEN
		         Pack_Global.recuperer_message( 20954, NULL, NULL, NULL, l_msg);
                RAISE_APPLICATION_ERROR( -20954, l_msg );

		WHEN OTHERS THEN
				    RAISE_APPLICATION_ERROR( -20997, SQLERRM);
		END;

      IF SQL%NOTFOUND THEN

	   -- 'Accès concurrent'

	   Pack_Global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
      RAISE_APPLICATION_ERROR( -20999, l_msg );

      ELSE

	   -- ' p_codcompte a été supprimé'

	   Pack_Global.recuperer_message( 20973, '%s1', p_codrub, NULL, l_msg);
	   p_message := l_msg;

      END IF;
	  
	  ELSE
	  
	  
	       Pack_Global.recuperer_message( 20996, '%s1', p_codrub, NULL, l_msg);
	       p_message := l_msg;
	  
	  END IF;
	  

   END delete_rubrique;




    PROCEDURE select_Rubrique( p_codrub          	       IN RUBRIQUE.CODRUB%TYPE,
					 	                                          	 p_userid     	              IN  VARCHAR2,
																	 p_curRubrique         IN OUT RubriqueCurType_Char ,
                                  									 p_nbcurseur             OUT INTEGER,
                                  									 p_message              OUT VARCHAR2
                                									)   IS


	l_msg VARCHAR2(1024);

   BEGIN

        -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         OPEN   p_curRubrique FOR
              SELECT 	r.codrub,
			  					 	d.CODDIR,
   			  				        d.LIBDIR,
									r.codep || ' - ' || r.codfei || ' - ' || tr.librubst,
								    r.codep,
    								r.codfei,
   									r.CAFI,
									r.CAFI || ' - '|| ca.CLIBRCA,
									r.comptedeb,
   									RPAD(TO_CHAR(c1.codcompte),10,' ') || ' - '|| c1.libcompte,
									r.comptecre,
   									RPAD(TO_CHAR(c2.codcompte),10,' ') || ' - '|| c2.libcompte,
   									r.schemacpt,
   									r.appli,
  									TO_CHAR(r.datedemande,'dd/mm/yyyy'),
   									TO_CHAR(r.dateretour,'dd/mm/yyyy'),
   									r.commentaires,
   									r.flaglock
		     FROM  RUBRIQUE r, TYPE_RUBRIQUE tr, COMPTE c1, COMPTE c2, CENTRE_ACTIVITE ca, DIRECTIONS d
              WHERE r.codrub = TO_NUMBER(p_codrub)
			  AND r.CODEP=tr.CODEP(+)
			  AND r.CODFEI=tr.CODFEI
			  AND c1.codcompte(+)=r.comptedeb
			   AND c2.codcompte(+)=r.comptecre
			   AND ca.CODCAMO(+)=r.CAFI
			   AND d.coddir(+)=r.coddir;

     
          Pack_Global.recuperer_message( 21034, '%s1', p_codrub, NULL, l_msg);
      p_message := l_msg;

      EXCEPTION

        WHEN OTHERS THEN
		
		  RAISE_APPLICATION_ERROR( -20997, SQLERRM);
  END;

   END select_Rubrique;

END Pack_Rubrique;
/
