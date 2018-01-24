-- pack_scenario PL/SQL
--
-- PPR
-- Créé le 03/05/2005
-- 
--****************************************************************************
-- Gère les accès à la base de données pour la table REE_SCENARIOS
-- dans le cadre de l'outil de réestimé
--
--****************************************************************************

CREATE OR REPLACE PACKAGE pack_scenario AS

   -- Définition curseur sur la table scenario
	
   TYPE scenario_ViewType IS RECORD ( 	codsg  		ree_scenarios.codsg%TYPE,
					code_scenario 	ree_scenarios.code_scenario%TYPE,
					lib_scenario 	ree_scenarios.lib_scenario%TYPE,
					officiel 	VARCHAR2(3),
					commentaire 	ree_scenarios.commentaire%TYPE
					); 
 

   TYPE scenarioCurType_Char IS REF CURSOR RETURN scenario_ViewType;


   PROCEDURE insert_scenario ( 	p_codsg 	IN VARCHAR2,
				p_code_scenario IN VARCHAR2,
				p_lib_scenario 	IN VARCHAR2,
				p_init_scenario IN VARCHAR2,			
				p_officiel      IN VARCHAR2,
				p_commentaire   IN VARCHAR2,								
                                p_nbcurseur  	OUT INTEGER,
                                p_message    	OUT VARCHAR2
                                );

   PROCEDURE update_scenario ( 	p_codsg 	IN VARCHAR2,
				p_code_scenario IN VARCHAR2,
				p_lib_scenario 	IN VARCHAR2,
				p_init_scenario IN VARCHAR2,
				p_officiel      IN VARCHAR2,
				p_commentaire   IN VARCHAR2,				
				p_nbcurseur  	OUT INTEGER,
                                p_message    	OUT VARCHAR2
                              	);

   PROCEDURE delete_scenario ( 	p_codsg 	IN VARCHAR2,
				p_code_scenario IN VARCHAR2,
                               	p_nbcurseur 	OUT INTEGER,
                               	p_message   	OUT VARCHAR2
                              	);

   PROCEDURE select_scenario_liste ( 	p_codsg 	IN VARCHAR2,
   					p_global 	IN VARCHAR2,
                               		p_curscenario 	IN OUT scenarioCurType_Char ,
                               		p_nbcurseur   	OUT INTEGER,
                               		p_message     	OUT VARCHAR2
                                	);
                                
    PROCEDURE select_scenario ( 	p_codsg 	IN VARCHAR2,
					p_code_scenario IN VARCHAR2,
                               		p_curscenario 	IN OUT scenarioCurType_Char ,
                               		p_nbcurseur   	OUT INTEGER,
                               		p_message     	OUT VARCHAR2
                                	);

   PROCEDURE scenario_officiel ( 	p_codsg 	IN VARCHAR2,
					p_code_scenario IN VARCHAR2,
					p_officiel	IN VARCHAR2
                              		);

   PROCEDURE initialise_reestime ( 	p_codsg 	IN VARCHAR2,
					p_code_scenario IN VARCHAR2,
					p_init_scenario	IN VARCHAR2
                              		);


END pack_scenario;
/

CREATE OR REPLACE PACKAGE BODY pack_scenario AS 

  PROCEDURE insert_scenario ( 	p_codsg 	IN VARCHAR2,
				p_code_scenario IN VARCHAR2,
				p_lib_scenario 	IN VARCHAR2,
				p_init_scenario IN VARCHAR2,
				p_officiel      IN VARCHAR2,
				p_commentaire   IN VARCHAR2,				
                                p_nbcurseur  	OUT INTEGER,
                                p_message    	OUT VARCHAR2
                              ) IS 
 
     	l_msg VARCHAR2(1024);
     	l_scenario_dpg NUMBER;

   BEGIN

	-- Positionner le nb de curseurs ==> 0
	-- Initialiser le message retour

      	p_nbcurseur := 0;
      	p_message := '';
 	
	
	BEGIN

	
	INSERT INTO ree_scenarios
	    ( 	codsg,
		code_scenario,
		lib_scenario,
		officiel,
		commentaire
 		)  
         VALUES ( 	TO_NUMBER(p_codsg),
         		p_code_scenario,
         		p_lib_scenario,
         		p_officiel,
         		p_commentaire
		);
	
	-- Met à jour le caractère officiel du scénario
	scenario_officiel(p_codsg ,
			p_code_scenario ,	
			p_officiel ) ;

	-- Initialise le réestimé du scénario à partir du scénario d'initialisation
	initialise_reestime(p_codsg,
			p_code_scenario,
			p_init_scenario ) ;

     	EXCEPTION
      		WHEN DUP_VAL_ON_INDEX THEN
			pack_global.recuperer_message( 21009, NULL, NULL, NULL, l_msg);
               		p_message := l_msg;

        	WHEN OTHERS THEN
               		raise_application_error( -20997, SQLERRM);
     	END;
     
   END insert_scenario;



   PROCEDURE update_scenario ( 	p_codsg 	IN VARCHAR2,
				p_code_scenario IN VARCHAR2,
				p_lib_scenario 	IN VARCHAR2,
				p_init_scenario IN VARCHAR2,
				p_officiel      IN VARCHAR2,
				p_commentaire   IN VARCHAR2,
				p_nbcurseur  	OUT INTEGER,
                                p_message    	OUT VARCHAR2
                              ) IS 

	l_msg VARCHAR2(1024);

   BEGIN

      	-- Positionner le nb de curseurs ==> 0
      	-- initialiser le message retour

	p_nbcurseur := 0;
	p_message := '';
	
	UPDATE ree_scenarios
	SET	lib_scenario=p_lib_scenario ,
		officiel    =p_officiel ,
		commentaire =p_commentaire
	WHERE codsg = TO_NUMBER(p_codsg) and code_scenario = p_code_scenario;



	IF SQL%NOTFOUND THEN
	   
	   	-- 'Accès concurrent'

	   	pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         	raise_application_error( -20999, l_msg );
         
      	ELSE

	   	-- Met à jour le caractère officiel du scénario
	   	scenario_officiel(p_codsg ,
				p_code_scenario ,	
				p_officiel ) ;

		-- Initialise le réestimé du scénario à partir du scénario d'initialisation
		initialise_reestime(p_codsg,
				p_code_scenario,
				p_init_scenario ) ;

	   	pack_global.recuperer_message( 21010, '%s1', p_code_scenario, NULL, l_msg);
	   	p_message := l_msg;

      	END IF;

   END update_scenario;


   PROCEDURE delete_scenario ( 	p_codsg 	IN VARCHAR2,
				p_code_scenario IN VARCHAR2,
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

	DELETE FROM ree_scenarios
	WHERE codsg = TO_NUMBER(p_codsg) and code_scenario = p_code_scenario;

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

	   	-- Met à jour le caractère officiel des scénarios restants ( surtout si on supprime le scénario officiel
	   	scenario_officiel(p_codsg ,
				p_code_scenario ,	
				'' ) ;

	   	pack_global.recuperer_message( 21011, '%s1', p_code_scenario, NULL, l_msg);
	   	p_message := l_msg;

      	END IF;

   END delete_scenario;



   PROCEDURE select_scenario_liste ( 	p_codsg 	IN VARCHAR2,
   					p_global 	IN VARCHAR2,
                               		p_curscenario 	IN OUT scenarioCurType_Char ,
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

	IF ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu
		pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               	raise_application_error(-20203,l_msg);
        
     	ELSIF ( pack_habilitation.fhabili_me(p_codsg, p_global)= 'faux' ) THEN
		pack_global.recuperer_message(20384, '%s1', p_codsg, NULL, l_msg);
		raise_application_error(-20384,l_msg);

     	ELSE

		BEGIN
        	OPEN   p_curscenario FOR
              	SELECT 	codsg,
              		code_scenario,
              		lib_scenario,
              		DECODE(officiel,'O','Oui','N','Non',' '),
              		commentaire
              	FROM  ree_scenarios
              	WHERE codsg = TO_NUMBER(p_codsg)
              	ORDER BY officiel desc , code_scenario;

      		EXCEPTION
			WHEN OTHERS THEN
         			raise_application_error( -20997, SQLERRM);
       		END;
        END IF; 
          
     	p_message := l_msg;
  
   END select_scenario_liste;
   
   PROCEDURE select_scenario ( 	p_codsg 	IN VARCHAR2,
				p_code_scenario IN VARCHAR2,
                               	p_curscenario 	IN OUT scenarioCurType_Char ,
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
        OPEN   p_curscenario FOR
              SELECT 	codsg,
              		code_scenario,
              		lib_scenario,
              		officiel,
              		commentaire
              FROM  ree_scenarios
              WHERE codsg = TO_NUMBER(p_codsg) and code_scenario = p_code_scenario;


      	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			pack_global.recuperer_message( 21006, NULL, NULL, NULL, l_msg);
         		p_message := l_msg;
        	WHEN OTHERS THEN
          		raise_application_error( -20997, SQLERRM);

      	END;
  
   END select_scenario;

-- 
-- Détermine pour un scénario celui qui sera le scénario officiel
-- 
   PROCEDURE scenario_officiel ( 	p_codsg 	IN VARCHAR2,
					p_code_scenario IN VARCHAR2,
					p_officiel	IN VARCHAR2
                              		) IS

     	l_nb_officiel NUMBER;
   BEGIN

	BEGIN
	--
	-- Compte le nombre de scénarios officiels pour le DPG 
	--	
	SELECT count(*) 
	INTO l_nb_officiel
	FROM ree_scenarios  
	WHERE codsg = TO_NUMBER(p_codsg)
	AND   officiel = 'O' ;

	-- En fonction du nombre ramené agit sur la base
	--	- Si le nombre est 1 , ne fait rien car la situation est normale

	IF (l_nb_officiel = 0) THEN
	--
	-- On positionne arbitrairement le statut officiel d'un scénario à O	
		update ree_scenarios
		set officiel = 'O'
		where codsg = TO_NUMBER(p_codsg)
		and rownum <= 1 ;

	ELSIF (l_nb_officiel >= 2) THEN
	--
	-- Il y a trop de scénarios officiels , il faut n'en laisser qu'un
		update ree_scenarios
		set officiel = 'N'
		where codsg = TO_NUMBER(p_codsg)
		and code_scenario <> (
			select code_scenario
			from ree_scenarios
			where codsg = TO_NUMBER(p_codsg)
			and code_scenario = DECODE (p_officiel,'O',p_code_scenario,code_scenario)
			and rownum <= 1 );
			
	END IF ;

      	EXCEPTION
        	WHEN OTHERS THEN
          		raise_application_error( -20997, SQLERRM);
      	END;
  
   END scenario_officiel;


-- 
-- initialise les réestimés d'un scénario à partir d'un scénario d'initialisation
-- 
   PROCEDURE initialise_reestime ( 	p_codsg 	IN VARCHAR2,
					p_code_scenario IN VARCHAR2,
					p_init_scenario	IN VARCHAR2
                              		) IS

   BEGIN
	--
	-- Si init_scenario est vide ou égal à code_scenario on ne fait rien
	--	
	IF ( p_init_scenario <> p_code_scenario  AND  p_init_scenario is not null ) THEN

		BEGIN	
		--
		-- Supprime tous les réestimés du scénario
		--	
		DELETE 
		FROM ree_reestime  
		WHERE codsg = TO_NUMBER(p_codsg)
		AND   code_scenario = p_code_scenario  ;
	
		--
		-- Recrée tous les réestimés de init_scenario pour le scénatio
		--	
		INSERT INTO ree_reestime (
			CODSG          ,
	  		CODE_SCENARIO  ,
	  		CDEB           ,
	  		TYPE           ,
	  		IDENT          ,
	  		CODE_ACTIVITE  ,
	  		CONSO_PREVU )
	  	SELECT 	CODSG          ,
	  		p_code_scenario  ,
	  		CDEB           ,
	  		TYPE           ,
	  		IDENT          ,
	  		CODE_ACTIVITE  ,
	  		CONSO_PREVU 
		FROM ree_reestime
		WHERE codsg = TO_NUMBER(p_codsg)
		AND   code_scenario = p_init_scenario  ;
		
	      	EXCEPTION
	        	WHEN OTHERS THEN
	          		raise_application_error( -20997, SQLERRM);
	      	END;
	END IF;
  
   END initialise_reestime;


END pack_scenario;
/