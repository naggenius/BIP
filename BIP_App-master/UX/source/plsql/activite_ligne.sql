-- pack_activite_ligne PL/SQL
--
-- EJE
-- Créé le 03/05/2005
-- JAL : Fiche 554 22/02/2008 : création fonction de vérification existantce DPG et habilitation
--**********************************************************************************
--
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

 CREATE OR REPLACE PACKAGE Pack_Activite_Ligne AS

   -- Définition curseur sur la table activite_ligne

   TYPE activite_ligne_ViewType IS RECORD ( 	codsg 		REE_ACTIVITES.codsg%TYPE,
   						code_activite	REE_ACTIVITES.code_activite%TYPE,
   						lib_activite 	VARCHAR2(4),
   						pid 		VARCHAR2(4),
						lib_pid 	VARCHAR2(30)
					);


   TYPE activite_ligneCurType_Char IS REF CURSOR RETURN activite_ligne_ViewType;

   FUNCTION str_act_ligne 	(	p_string     IN  VARCHAR2,
                           		p_occurence  IN  NUMBER
                          	  ) RETURN VARCHAR2;


   PROCEDURE insert_activite_ligne ( 	p_string 	IN VARCHAR2,
                                	p_nbcurseur  	OUT INTEGER,
                                	p_message    	OUT VARCHAR2
                                );


   PROCEDURE select_activite_ligne ( 	p_codsg 		IN VARCHAR2,
   					p_code_activite		IN VARCHAR2,
   					p_global		IN VARCHAR2,
                               		p_curactivite_ligne 	IN OUT activite_ligneCurType_Char ,
                               		p_nbcurseur   		OUT INTEGER,
                               		p_message     		OUT VARCHAR2,
   					p_lib_activite		OUT VARCHAR2
                                );

   PROCEDURE select_ligne ( 	p_pid 		IN VARCHAR2,
   				p_pnom		OUT VARCHAR2
                           );
						   
	PROCEDURE verifie_codsg ( 	p_codsg 		IN VARCHAR2,
	   			 			   		p_global		IN VARCHAR2,
                                	p_nbcurseur  	OUT INTEGER,
                                	p_message    	OUT VARCHAR2
                                );					   
						   

END Pack_Activite_Ligne;
/


CREATE OR REPLACE PACKAGE BODY Pack_Activite_Ligne AS


   FUNCTION str_act_ligne (	p_string     IN  VARCHAR2,
                           	p_occurence  IN  NUMBER
                          	) RETURN VARCHAR2 IS
   pos1 NUMBER(6);
   pos2 NUMBER(6);
   str  VARCHAR2(111);

   BEGIN

      pos1 := INSTR(p_string,';',1,p_occurence);
      pos2 := INSTR(p_string,';',1,p_occurence+1);

      IF pos2 != 1 THEN
         str := SUBSTR( p_string, pos1+1, pos2-pos1-1);
         RETURN str;
      ELSE
         RETURN '0';
      END IF;

   END str_act_ligne;

  PROCEDURE insert_activite_ligne ( 	p_string 	IN VARCHAR2,
                                	p_nbcurseur  	OUT INTEGER,
                                	p_message    	OUT VARCHAR2
                              ) IS

   l_msg 		VARCHAR2(1024);
   l_cpt    		NUMBER(7);
   l_codsg  		REE_ACTIVITES_LIGNE_BIP.codsg%TYPE;
   l_code_activite    	REE_ACTIVITES_LIGNE_BIP.code_activite%TYPE;
   l_pid  		REE_ACTIVITES_LIGNE_BIP.pid%TYPE;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message   := '';
      -- Prise en compte de l'année
      l_cpt       := 1;
      l_codsg := TO_NUMBER(Pack_Activite_Ligne.str_act_ligne(p_string,l_cpt));
      -- Prise en compte de du clicode
      l_cpt       := 2;
      l_code_activite := Pack_Activite_Ligne.str_act_ligne(p_string,l_cpt);
      -- Position de départ pour la boucle
      l_cpt       := 3;

	BEGIN
		DELETE FROM REE_ACTIVITES_LIGNE_BIP
		WHERE codsg = l_codsg AND code_activite = l_code_activite;
	END;

      WHILE l_cpt != 0 LOOP

	l_pid := Pack_Activite_Ligne.str_act_ligne(p_string,l_cpt);

	IF l_pid != '-1' THEN
		BEGIN
		INSERT INTO REE_ACTIVITES_LIGNE_BIP (codsg, code_activite, pid)
		VALUES (l_codsg,
			l_code_activite,
			l_pid);
		END;
		l_cpt := l_cpt + 1;
         ELSE
            l_cpt :=0;
         END IF;
	 dbms_output.put_line('l_cpt:'||l_cpt);
      END LOOP;

   Pack_Global.recuperer_message( 20366 , '%s1', 'Activité - Lignes BIP rattachées', '', p_message);

   END insert_activite_ligne;

   PROCEDURE select_activite_ligne ( 	p_codsg 		IN VARCHAR2,
   					p_code_activite		IN VARCHAR2,
   					p_global		IN VARCHAR2,
                               		p_curactivite_ligne 	IN OUT activite_ligneCurType_Char ,
                               		p_nbcurseur   		OUT INTEGER,
                               		p_message     		OUT VARCHAR2,
   					p_lib_activite		OUT VARCHAR2
                              		) IS

	l_msg VARCHAR2(1024);
	l_codsg NUMBER;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
	p_nbcurseur := 1;
      	p_message := '';

	IF ( Pack_Utile.f_verif_dpg(p_codsg)= FALSE ) THEN -- Message Dep/pole inconnu
		Pack_Global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR(-20203,l_msg);

     ELSE
     IF ( Pack_Habilitation.fhabili_me(p_codsg, p_global)= 'faux' )
     THEN
	Pack_Global.recuperer_message(20364, '%s1', p_codsg, NULL, l_msg);
	RAISE_APPLICATION_ERROR(-20364,l_msg);

     ELSE

	BEGIN
        	OPEN   p_curactivite_ligne FOR
              	SELECT 	LPAD(TO_CHAR(ral.CODSG), 7,'0'),
			ral.CODE_ACTIVITE,
			ral.LIB_ACTIVITE,
              		ralb.pid,
              		lb.pnom
              	FROM  	REE_ACTIVITES ral,
              		REE_ACTIVITES_LIGNE_BIP ralb,
              		LIGNE_BIP lb
              	WHERE ral.codsg = TO_NUMBER(p_codsg)
              	AND ral.TYPE = 'N'
              	AND ral.codsg = ralb.codsg
              	AND ral.code_activite = ralb.code_activite
              	AND ral.code_activite = p_code_activite
              	AND ralb.pid = lb.pid;

      		EXCEPTION
      			WHEN NO_DATA_FOUND THEN
      				Pack_Global.recuperer_message(20901, NULL, NULL, NULL, l_msg);
				RAISE_APPLICATION_ERROR(-20901,l_msg);
			WHEN OTHERS THEN
         		RAISE_APPLICATION_ERROR( -20997, SQLERRM);
       END;

       BEGIN
        	SELECT 	ral.lib_activite INTO p_lib_activite
              	FROM  	REE_ACTIVITES ral
              	WHERE ral.codsg = TO_NUMBER(p_codsg)
              	AND ral.TYPE = 'N'
              	AND ral.code_activite = p_code_activite;

      		EXCEPTION
      			WHEN NO_DATA_FOUND THEN
      				Pack_Global.recuperer_message(20901, NULL, NULL, NULL, l_msg);
				RAISE_APPLICATION_ERROR(-20901,l_msg);
			WHEN OTHERS THEN
         		RAISE_APPLICATION_ERROR( -20997, SQLERRM);
       END;
        END IF;
     END IF;

     p_message := l_msg;

   END select_activite_ligne;

   PROCEDURE select_ligne ( 	p_pid 		IN VARCHAR2,
   				p_pnom		OUT VARCHAR2
                           ) IS

   BEGIN
        	SELECT 	pnom INTO p_pnom
              	FROM  	LIGNE_BIP
              	WHERE pid = p_pid;

      		EXCEPTION
			WHEN OTHERS THEN
         		RAISE_APPLICATION_ERROR( -20997, SQLERRM);

   END select_ligne;
   
   
     --fonction simple vérifie codsg saisi ok
  PROCEDURE verifie_codsg ( 	p_codsg 		IN VARCHAR2,
	   			 			   	p_global		IN VARCHAR2,
                                p_nbcurseur  	OUT INTEGER,
                                p_message    	OUT VARCHAR2 
                              		) IS

	l_msg VARCHAR2(1024);
	l_codsg NUMBER;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
	p_nbcurseur := 1;
    p_message := '';

	IF ( Pack_Utile.f_verif_dpg(p_codsg)= FALSE ) THEN -- Message Dep/pole inconnu
		Pack_Global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               RAISE_APPLICATION_ERROR(-20203,l_msg);

     ELSE
		     IF ( Pack_Habilitation.fhabili_me(p_codsg, p_global)= 'faux' )
			     THEN
				Pack_Global.recuperer_message(20364, '%s1', p_codsg, NULL, l_msg);
				RAISE_APPLICATION_ERROR(-20364,l_msg); 
		     END IF;
     END IF;

     p_message := l_msg;

   END verifie_codsg ;
   
   

END Pack_Activite_Ligne;
/
