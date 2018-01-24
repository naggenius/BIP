--
--
--
--
-- Crée le 30/01/2006 par BAA : Fiche 286 permet la gestion des comptes
--
--




CREATE OR REPLACE PACKAGE Pack_Compte AS

   -- Définition curseur sur la table struct_info

   TYPE Compte_ViewType IS RECORD ( codcompte     	COMPTE.CODCOMPTE%TYPE,
					 	                                                           libcompte     	  COMPTE.LIBCOMPTE%TYPE,
																				   TYPE    	             COMPTE.TYPE%TYPE,
                                  	 						 	                    flaglock   	          COMPTE.flaglock%TYPE
					 					                                          );

   TYPE CompteCurType_Char IS REF CURSOR RETURN Compte_ViewType;

  
   PROCEDURE insert_Compte ( 	p_codcompte     	IN COMPTE.CODCOMPTE%TYPE,
					 	                                            p_libcompte     	  IN COMPTE.LIBCOMPTE%TYPE,
																	p_TYPE    	         IN COMPTE.TYPE%TYPE,
                                  									p_userid     	    IN  VARCHAR2,
                                  									p_nbcurseur     OUT INTEGER,
                                  									p_message      OUT VARCHAR2
                                									) ;

	PROCEDURE update_compte ( 	p_codcompte     IN	COMPTE.CODCOMPTE%TYPE,
					 	                                               p_libcompte     	  IN COMPTE.LIBCOMPTE%TYPE,
																	   p_type    	            IN  COMPTE.TYPE%TYPE,
                                  	 						 	       p_flaglock   	     IN   COMPTE.flaglock%TYPE,
				  													   p_userid     	      IN  VARCHAR2,
				  													   p_nbcurseur  	  OUT INTEGER,
                                  									   p_message    	 OUT VARCHAR2
                              										);
			
							
							
	PROCEDURE delete_compte ( p_codcompte     IN  COMPTE.CODCOMPTE%TYPE,
                                   		  	  		   	   		  p_flaglock 	         IN  NUMBER,
                                  								  p_userid                IN  VARCHAR2,
                                  								  p_nbcurseur        OUT INTEGER,
                                  								  p_message         OUT VARCHAR2
                         										   );						
								
	 PROCEDURE select_Compte ( 	p_codcompte     	IN COMPTE.CODCOMPTE%TYPE,
					 	                                          	 p_userid     	             IN  VARCHAR2,
																	 p_curCompte         IN OUT CompteCurType_Char ,
                                  									 p_nbcurseur            OUT INTEGER,
                                  									 p_message             OUT VARCHAR2
                                									) ;
								
END Pack_Compte;
/




CREATE OR REPLACE PACKAGE BODY Pack_Compte AS



  PROCEDURE insert_Compte ( 	p_codcompte     	IN COMPTE.CODCOMPTE%TYPE,
					 	                                            p_libcompte     	  IN COMPTE.LIBCOMPTE%TYPE,
																	p_TYPE    	         IN COMPTE.TYPE%TYPE,
                                  									p_userid     	    IN  VARCHAR2,
                                  									p_nbcurseur     OUT INTEGER,
                                  									p_message      OUT VARCHAR2
                                									) IS

     l_msg VARCHAR2(1024);
     l_msg_alert VARCHAR2(1024);
     l_exist NUMBER;
   

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

 
	BEGIN
     	   INSERT INTO COMPTE
	       		  	   		 		   	                   ( codcompte,
 		  												     libcompte,
 		  												     TYPE,
 														     flaglock)
         VALUES ( TO_NUMBER(p_codcompte),
		   		  			  p_libcompte,
		  					  p_type,
		  			  	      0
		                     );

		COMMIT;					 
							 
	  Pack_Global.recuperer_message( 20971, '%s1', p_codcompte, NULL, l_msg);
	
	 p_message := l_msg;
	
     EXCEPTION
      	WHEN DUP_VAL_ON_INDEX THEN
		       Pack_Global.recuperer_message( 21058, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR( -20001, l_msg );
            
     END;

   END insert_compte;



   PROCEDURE update_compte ( 	p_codcompte     IN	COMPTE.CODCOMPTE%TYPE,
					 	                                               p_libcompte     	  IN COMPTE.LIBCOMPTE%TYPE,
																	   p_type    	            IN  COMPTE.TYPE%TYPE,
                                  	 						 	       p_flaglock   	     IN   COMPTE.flaglock%TYPE,
				  													   p_userid     	      IN  VARCHAR2,
				  													   p_nbcurseur  	  OUT INTEGER,
                                  									   p_message    	 OUT VARCHAR2
                              										) IS

	 l_msg               VARCHAR2(1024);
	 l_type               VARCHAR2(10);
	 l_count             NUMBER;
    
	
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- initialiser le message retour

	p_nbcurseur := 0;
	p_message := '';

      -- test si le un compte est utilisé

      BEGIN
	  
	  
	  IF(p_type = 'C')THEN
	  	   
	   l_type := 'déditer';
	   
        SELECT COUNT(*) INTO l_count
        FROM RUBRIQUE
        WHERE comptedeb = p_codcompte;
		
	ELSE	
		
		l_type := 'créditer';
		
		SELECT COUNT(*) INTO l_count
        FROM RUBRIQUE
        WHERE comptecre = p_codcompte;
		
	END IF;	
		
	IF(l_count != 0)THEN
	
		  Pack_Global.recuperer_message( 20953, '%s1',l_type, NULL, l_msg);
          RAISE_APPLICATION_ERROR( -20953, l_msg );
	    
	
	END IF;	
		
				

      END;

	

	BEGIN
	  
         UPDATE COMPTE
		SET	libcompte = p_libcompte,
		    	  TYPE 	= p_type,
				 flaglock 	= DECODE( p_flaglock, 1000000, 0, p_flaglock + 1 ) 
				 WHERE codcompte 	= TO_NUMBER(p_codcompte)
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


	   -- 'Le compte p_codcompte a été modifié'

	         Pack_Global.recuperer_message( 20972, '%s1', p_codcompte, NULL, l_msg);
		  	 p_message := l_msg;
      END IF;

   END update_compte;


PROCEDURE delete_compte ( p_codcompte     IN  COMPTE.CODCOMPTE%TYPE,
                                   		  	  		   	   	   p_flaglock 	         IN  NUMBER,
                                  							   p_userid                IN  VARCHAR2,
                                  							   p_nbcurseur        OUT INTEGER,
                                  							   p_message         OUT VARCHAR2
                         								   ) IS				


	  l_msg VARCHAR2(1024);
      referential_integrity EXCEPTION;
      PRAGMA EXCEPTION_INIT(referential_integrity, -2292);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
	   DELETE FROM COMPTE
		    WHERE codcompte = TO_NUMBER(p_codcompte)
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

	   Pack_Global.recuperer_message( 20973, '%s1', p_codcompte, NULL, l_msg);
	   p_message := l_msg;

      END IF;

   END delete_compte;



   PROCEDURE select_Compte ( 	p_codcompte     	IN COMPTE.CODCOMPTE%TYPE,
					 	                                          	 p_userid     	             IN  VARCHAR2,
																	 p_curCompte     IN OUT CompteCurType_Char ,
                                  									 p_nbcurseur            OUT INTEGER,
                                  									 p_message             OUT VARCHAR2
                                									)  IS
								

	l_msg VARCHAR2(1024);

   BEGIN

        -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';

      BEGIN
         OPEN   p_curCompte FOR
              SELECT 	codcompte,
                     				libcompte,
                     				TYPE,
                     	          	flaglock
		     FROM  COMPTE
              WHERE codcompte = TO_NUMBER(p_codcompte);

         -- en cas absence
	   -- 'code codcompte  inexistant'

         Pack_Global.recuperer_message( 21034, '%s1', p_codcompte, NULL, l_msg);
         p_message := l_msg;

      EXCEPTION

        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR( -20997, SQLERRM);

      END;

   END select_compte;

END Pack_Compte;
/




