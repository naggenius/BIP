-- pack_activite PL/SQL
--
-- EJE
-- Créé le 28/04/2005
-- PPR le 31/08/2005 - Initialisations à la création de la première activité d'un groupe
-- 
--****************************************************************************
--
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_activite AS

   -- Définition curseur sur la table activite
	
   TYPE activite_ViewType IS RECORD ( 	codsg  		ree_activites.codsg%TYPE,
					code_activite 	VARCHAR2(12),
					lib_activite 	VARCHAR2(60)
					); 
 

   TYPE activiteCurType_Char IS REF CURSOR RETURN activite_ViewType;


   PROCEDURE insert_activite ( 	p_codsg 	IN VARCHAR2,
				p_code_activite IN VARCHAR2,
				p_lib_activite 	IN VARCHAR2,
                                p_nbcurseur  	OUT INTEGER,
                                p_message    	OUT VARCHAR2
                                );

   PROCEDURE update_activite ( 	p_codsg 	IN VARCHAR2,
				p_code_activite IN VARCHAR2,
				p_lib_activite 	IN VARCHAR2,
				p_nbcurseur  	OUT INTEGER,
                                p_message    	OUT VARCHAR2
                              	);

   PROCEDURE delete_activite ( 	p_codsg 	IN VARCHAR2,
				p_code_activite IN VARCHAR2,
                               	p_nbcurseur 	OUT INTEGER,
                               	p_message   	OUT VARCHAR2
                              	);

   PROCEDURE select_activite_liste ( 	p_codsg 	IN VARCHAR2,
   					p_global 	IN VARCHAR2,
                               		p_curactivite 	IN OUT activiteCurType_Char ,
                               		p_nbcurseur   	OUT INTEGER,
                               		p_message     	OUT VARCHAR2
                                	);
                                
    PROCEDURE select_activite_act ( 	p_codsg 	IN VARCHAR2,
					p_code_activite IN VARCHAR2,
                               		p_curactivite 	IN OUT activiteCurType_Char ,
                               		p_nbcurseur   	OUT INTEGER,
                               		p_message     	OUT VARCHAR2
                                	);

END pack_activite;
/

CREATE OR REPLACE PACKAGE BODY pack_activite AS 

  PROCEDURE insert_activite ( 	p_codsg 	IN VARCHAR2,
				p_code_activite IN VARCHAR2,
				p_lib_activite 	IN VARCHAR2,
                                p_nbcurseur  	OUT INTEGER,
                                p_message    	OUT VARCHAR2
                              ) IS 
 
     	l_msg VARCHAR2(1024);
     	l_activite_dpg NUMBER;
     	l_ressource_s NUMBER;
     	l_scenario NUMBER ;

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
 	
--Insert	
	BEGIN

	SELECT count(*) 
	INTO l_activite_dpg 
	FROM ree_activites 
	WHERE codsg = TO_NUMBER(p_codsg);
	
	IF (l_activite_dpg = 0) THEN
	
		INSERT INTO ree_activites
		    ( 	codsg,
			code_activite,
			lib_activite,
			type
	 		)  
	         VALUES ( 	TO_NUMBER(p_codsg),
	         		'ABSENCES',
	         		'ABSENCES',
	         		'A'
			);
			
		INSERT INTO ree_activites
		    ( 	codsg,
			code_activite,
			lib_activite,
			type
	 		)  
	         VALUES ( 	TO_NUMBER(p_codsg),
	         		'SST FOURNIE',
	         		'SOUS-TRAITANCE FOURNIE',
	         		'F'
			);


		BEGIN
		l_ressource_s := 0 ;
		l_scenario := 0 ;
		
		-- Insertion de la ressource sous-traitance reçue 	
		SELECT count(*)
		INTO l_ressource_s 
		FROM ree_ressources
		WHERE codsg = TO_NUMBER(p_codsg) 
		AND type = 'S';

		IF (l_ressource_s = 0) THEN
			INSERT INTO ree_ressources(CODSG,TYPE,IDENT,RNOM) 
		       		VALUES(TO_NUMBER(p_codsg),'S',2,'SST RECUE');		
		END IF ;

		-- Insertion du scénario officiel	
		SELECT count(*)
		INTO l_scenario 
		FROM ree_scenarios
		WHERE codsg = TO_NUMBER(p_codsg) ;

		IF (l_scenario = 0) THEN
			INSERT INTO ree_scenarios(CODSG,CODE_SCENARIO,LIB_SCENARIO,OFFICIEL) 
		       		VALUES(TO_NUMBER(p_codsg),'OFFIC','Scénario officiel','O');		
		END IF ;
	
		END;
			
	END IF;
	
	INSERT INTO ree_activites
	    ( 	codsg,
		code_activite,
		lib_activite,
		type
 		)  
         VALUES ( 	TO_NUMBER(p_codsg),
         		p_code_activite,
         		p_lib_activite,
         		'N'
		);
	
     EXCEPTION
      	WHEN DUP_VAL_ON_INDEX THEN
		pack_global.recuperer_message( 21005, NULL, NULL, NULL, l_msg);
               	p_message := l_msg;

        WHEN OTHERS THEN
               	raise_application_error( -20997, SQLERRM);
     END;
     
   END insert_activite;



   PROCEDURE update_activite ( 	p_codsg 	IN VARCHAR2,
				p_code_activite IN VARCHAR2,
				p_lib_activite 	IN VARCHAR2,
				p_nbcurseur  	OUT INTEGER,
                                p_message    	OUT VARCHAR2
                              ) IS 

	l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- initialiser le message retour

	p_nbcurseur := 0;
	p_message := '';
	
	UPDATE ree_activites
	SET	lib_activite=p_lib_activite
	WHERE codsg = TO_NUMBER(p_codsg) and code_activite = p_code_activite;


	IF SQL%NOTFOUND THEN
	   
	   -- 'Accès concurrent'

	   pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
         
      	ELSE

	   pack_global.recuperer_message( 21007, '%s1', p_code_activite, NULL, l_msg);
	   p_message := l_msg;

      END IF;

   END update_activite;


   PROCEDURE delete_activite ( 	p_codsg 	IN VARCHAR2,
				p_code_activite IN VARCHAR2,
                               	p_nbcurseur 	OUT INTEGER,
                               	p_message   	OUT VARCHAR2
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

	DELETE FROM ree_activites
	WHERE codsg = TO_NUMBER(p_codsg) and code_activite = p_code_activite;

         EXCEPTION

		WHEN referential_integrity THEN

               -- habiller le msg erreur

               pack_global.recuperation_integrite(-2292);
	   
		WHEN OTHERS THEN
		   raise_application_error( -20997, SQLERRM);
      END;

      IF SQL%NOTFOUND THEN
	   
	   -- 'Accès concurrent'

	   pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         raise_application_error( -20999, l_msg );
         
      ELSE

	   pack_global.recuperer_message( 21008, '%s1', p_code_activite, NULL, l_msg);
	   p_message := l_msg;

      END IF;

   END delete_activite;



   PROCEDURE select_activite_liste ( 	p_codsg 	IN VARCHAR2,
   					p_global 	IN VARCHAR2,
                               		p_curactivite 	IN OUT activiteCurType_Char ,
                               		p_nbcurseur   	OUT INTEGER,
                               		p_message     	OUT VARCHAR2
                              		) IS

	l_msg VARCHAR2(1024);
	l_codsg NUMBER;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
	p_nbcurseur := 1;
      	p_message := '';

	If ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu
		pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               raise_application_error(-20203,l_msg);
        
     ELSE
     IF ( pack_habilitation.fhabili_me(p_codsg, p_global)= 'faux' ) 
     THEN
	pack_global.recuperer_message(20364, '%s1', p_codsg, NULL, l_msg);
	raise_application_error(-20364,l_msg);

     ELSE

	BEGIN
        	OPEN   p_curactivite FOR
              	SELECT 	codsg,
              		code_activite,
              		lib_activite
              	FROM  ree_activites
              	WHERE codsg = TO_NUMBER(p_codsg) and type = 'N';

      		EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);
       END;
        END IF; 
     END IF;
     
     p_message := l_msg;
  
   END select_activite_liste;
   
   PROCEDURE select_activite_act ( 	p_codsg 	IN VARCHAR2,
					p_code_activite IN VARCHAR2,
                               		p_curactivite 	IN OUT activiteCurType_Char ,
                               		p_nbcurseur   	OUT INTEGER,
                               		p_message     	OUT VARCHAR2
                              		) IS

	l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
	
      p_nbcurseur := 1;
      p_message := '';
 
       -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      -- ou selectionner toutes les colonnes par *

      BEGIN
         OPEN   p_curactivite FOR
              SELECT 	codsg,
              		code_activite,
              		lib_activite
              FROM  ree_activites
              WHERE codsg = TO_NUMBER(p_codsg) and code_activite = p_code_activite;


      EXCEPTION
	WHEN NO_DATA_FOUND THEN
		pack_global.recuperer_message( 21006, NULL, NULL, NULL, l_msg);
         	p_message := l_msg;
        WHEN OTHERS THEN
          raise_application_error( -20997, SQLERRM);

      END;
  
   END select_activite_act;

END pack_activite;
/