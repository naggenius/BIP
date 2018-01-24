-- pack_ree_ress_act PL/SQL
--
-- MMC
-- Créé le 18/05/2005
-- 
--****************************************************************************
--
--
-- Attention le nom du package ne peut etre le nom
-- de la table...

CREATE OR REPLACE PACKAGE pack_ree_ress_act AS

   -- Définition curseur sur la table ree_ressources_activite
	
   TYPE ress_act_ViewType IS RECORD ( 	codsg varchar2(7),--ree_ressources_activite.codsg%TYPE,
   					ident	VARCHAR2(5),
   					type_ress	VARCHAR2(1),
   					lib_ress 	VARCHAR2(70),
   					code_activite varchar2(12),--ree_ressources_activite.code_activite%TYPE,
   					lib_activite VARCHAR2(60),
					repartition 	VARCHAR2(8)
					); 
 

   TYPE ress_actCurType_Char IS REF CURSOR RETURN ress_act_ViewType;
   
   TYPE ress_ListeViewType IS RECORD(CODE_RESS   VARCHAR2(6),
  				     LIB_RESS     VARCHAR2(60)
				    );

   TYPE ress_listeCurType IS REF CURSOR RETURN ress_ListeViewType;
   
   TYPE ligne_ListeViewType IS RECORD(  CODE_ACTIVITE   VARCHAR2(12),
   					LIB   VARCHAR2(250)
				);

   TYPE ligne_listeCurType IS REF CURSOR RETURN ligne_ListeViewType;
   
   PROCEDURE lister_ress_dpg( 	p_codsg 	IN VARCHAR2,
   				p_userid 	IN VARCHAR2,
   				p_curseur 	IN OUT ress_listeCurType
                             	);
                             	
  PROCEDURE lister_ligne_act( 	p_codsg 	IN VARCHAR2,
   				p_code_ress IN VARCHAR2,
   				p_userid 	IN VARCHAR2,
   				p_curseur 	IN OUT ligne_listeCurType
                             	);                          
                             	
   PROCEDURE select_ressource_ligne ( 	p_codsg 		IN VARCHAR2,
   					p_code_ress		IN VARCHAR2,
   					p_global		IN VARCHAR2,
                               		p_curress_ligne 	IN OUT ress_actCurType_Char ,
                               		p_nbcurseur   		OUT INTEGER,
                               		p_message     		OUT VARCHAR2,
   					p_lib_ress		OUT VARCHAR2
   					,p_total_rep		OUT FLOAT
                                );

   FUNCTION str_ress_act 	(	p_string     IN  VARCHAR2,
                           		p_occurence  IN  NUMBER
                          	  ) return VARCHAR2;


   PROCEDURE insert_ressources_activites ( 	p_string 	IN VARCHAR2,
   					p_codsg		IN VARCHAR2,
  					p_code_ress	IN VARCHAR2,
                                	p_nbcurseur  	OUT INTEGER,
                                	p_message    	OUT VARCHAR2
                                );
  
                                  
   PROCEDURE select_ligne (p_code_activite 	IN VARCHAR2,
   			p_codsg			IN VARCHAR2,
   			p_code_ress		IN VARCHAR2,
   			p_lib_activite		OUT VARCHAR2,
   			p_repartition		OUT VARCHAR2
                           );

                
                           

END pack_ree_ress_act;
/

CREATE OR REPLACE PACKAGE BODY pack_ree_ress_act AS 

PROCEDURE lister_ress_dpg( 	p_codsg 	IN VARCHAR2,
   				p_userid 	IN VARCHAR2,
   				p_curseur 	IN OUT ress_listeCurType
                             ) IS

l_msg VARCHAR2(1024);
l_codsg NUMBER;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      
	If ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu
		pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               raise_application_error(-20203,l_msg);
        
     ELSE
     IF ( pack_habilitation.fhabili_me(p_codsg, p_userid)= 'faux' ) 
     THEN
	pack_global.recuperer_message(20364, '%s1', p_codsg, NULL, l_msg);
	raise_application_error(-20364,l_msg);

     ELSE

	BEGIN
        	OPEN   p_curseur FOR
        	SELECT '' , 
               ' ' LIB_RESSß
        	FROM dual
       		UNION
              	SELECT 	type||ident CODE_RESSß,
              		rnom || ' ' || rprenom|| ' - ' ||type||' ' ||ident LIB_RESSß
              	FROM  ree_ressources
              	WHERE codsg = TO_NUMBER(p_codsg) and type <> 'S'
              	ORDER by 2;

      		EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);
       END;
        END IF; 
     END IF;
     
     
  END lister_ress_dpg;
  
  /* pour avoir la liste déroulante avec les activites du dpg */
  PROCEDURE lister_ligne_act( 	p_codsg 	IN VARCHAR2,
   				p_code_ress IN VARCHAR2,
   				p_userid 	IN VARCHAR2,
   				p_curseur 	IN OUT ligne_listeCurType
                             ) IS

	l_msg VARCHAR2(1024);
	l_codsg NUMBER;

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
      
	If ( pack_utile.f_verif_dpg(p_codsg)= false ) then -- Message Dep/pole inconnu
		pack_global.recuperer_message(20203, NULL, NULL, NULL, l_msg);
               raise_application_error(-20203,l_msg);
        
     ELSE
     IF ( pack_habilitation.fhabili_me(p_codsg, p_userid)= 'faux' ) 
     THEN
	pack_global.recuperer_message(20364, '%s1', p_codsg, NULL, l_msg);
	raise_application_error(-20364,l_msg);

     ELSE
     	
	BEGIN
        	OPEN   p_curseur FOR
              	SELECT 	act.code_activite CODE_ACTIVITE,
			act.code_activite || ' - ' || act.lib_activite LIB
		FROM  ree_activites act
		where act.CODSG = p_codsg
		and act.type <> 'A'
		--MINUS
		--SELECT 	ract.code_activite,
		--	act.code_activite || ' - ' || act.lib_activite
		--FROM  ree_ressources_activites ract,ree_activites act
		--WHERE ract.ident = to_number(substr(p_code_ress,2,5))
		--and ract.type = substr(p_code_ress,0,1)
		--and ract.CODSG = p_codsg
		--and ract.codsg=act.codsg
		--and ract.code_activite=act.code_activite
		;

      		EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);
       END;
        END IF; 
     END IF;
  END lister_ligne_act;
  
 /* proc qui liste les ressources dans un tableau*/
 PROCEDURE select_ressource_ligne ( 	p_codsg 		IN VARCHAR2,
   					p_code_ress		IN VARCHAR2,
   					p_global		IN VARCHAR2,
                               		p_curress_ligne 	IN OUT ress_actCurType_Char ,
                               		p_nbcurseur   		OUT INTEGER,
                               		p_message     		OUT VARCHAR2,
   					p_lib_ress		OUT VARCHAR2
   					,p_total_rep		OUT FLOAT
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
        	OPEN   p_curress_ligne FOR
              	SELECT 	lpad(to_char(ress.CODSG), 7,'0'),
              		to_char(ract.ident),
              		ract.type,
              		ress.rnom,
			ract.CODE_ACTIVITE,
			act.LIB_ACTIVITE,
              		to_char(nvl(ract.tauxrep,0))
              	FROM  	ree_ressources_activites ract,
              		ree_activites act,
              		ree_ressources ress
              	WHERE ract.codsg = TO_NUMBER(p_codsg)
              	and act.type <> 'A'
              	and act.codsg = ract.codsg
              	and act.code_activite = ract.code_activite
              	and ract.ident = to_number(substr(p_code_ress,2,5))
              	and ract.type=substr(p_code_ress,0,1)
              	and ress.ident=ract.ident
              	and ress.type=ract.type
              	and ress.codsg=ract.codsg
              	;

      		EXCEPTION
      			WHEN NO_DATA_FOUND THEN
      				pack_global.recuperer_message(20900, NULL, NULL, NULL, l_msg);
				raise_application_error(-20900,l_msg);
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);
         		
       END;
       
       BEGIN
        	SELECT 	ress.rnom INTO p_lib_ress
              	FROM  	ree_ressources ress
              	WHERE ress.codsg = TO_NUMBER(p_codsg)
              	and ress.type = substr(p_code_ress,0,1)
              	and ress.ident = to_number(substr(p_code_ress,2,5))
              	;

      		EXCEPTION
      			WHEN NO_DATA_FOUND THEN
      				pack_global.recuperer_message(20900,  NULL, NULL, NULL, l_msg);
				raise_application_error(-20900,l_msg);
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);
         		
       END;
       
      BEGIN
        	SELECT 	SUM(tauxrep) INTO p_total_rep
              	FROM  	ree_ressources_activites 
              	WHERE codsg = TO_NUMBER(p_codsg)
              	and type = substr(p_code_ress,0,1)
              	and ident = to_number(substr(p_code_ress,2,5))
              	;
--
      		EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);
         		
       END;
	
        END IF; 
     END IF;
     
     p_message := l_msg;
  
   END select_ressource_ligne;
   
FUNCTION str_ress_act (	p_string     IN  VARCHAR2,
                           	p_occurence  IN  NUMBER
                          	) return VARCHAR2 IS
   pos1 NUMBER(6);
   pos2 NUMBER(6);
   str  VARCHAR2(111);

   BEGIN

      pos1 := INSTR(p_string,';',1,p_occurence);
      pos2 := INSTR(p_string,';',1,p_occurence+1);

      IF pos2 != 1 THEN
         str := SUBSTR( p_string, pos1+1, pos2-pos1-1);
         return str;
      ELSE
         return '0';
      END IF;

END str_ress_act;

-- proc pour creation dans ree_ressources_activites 
PROCEDURE insert_ressources_activites ( p_string 	IN VARCHAR2,
					p_codsg		IN VARCHAR2,
  					p_code_ress	IN VARCHAR2,
					p_nbcurseur  	OUT INTEGER,
                                	p_message    	OUT VARCHAR2
                              ) IS 
 
   l_msg 		VARCHAR2(1024);
   l_cpt    		NUMBER(7);
   l_codsg  		ree_ressources_activites.codsg%TYPE;
   l_code_activite    	ree_ressources_activites.code_activite%TYPE;
   l_ident  		ree_ressources_activites.ident%TYPE;
   l_type  		ree_ressources_activites.type%TYPE;
   l_ident1  		ree_ressources_activites.ident%TYPE;
   l_type1  		ree_ressources_activites.type%TYPE;
   l_codsg1  		ree_ressources_activites.codsg%TYPE;
   l_tauxrep  		VARCHAR2(6);
   l_test		VARCHAR2(2);
   
   BEGIN
      -- Initialiser le message retour
      p_message   := '';
      l_cpt       := 3;
      
      l_codsg  	:= pack_ree_ress_act.str_ress_act(p_string,l_cpt);
      l_ident := to_number(substr(pack_ree_ress_act.str_ress_act(p_string,l_cpt+1),2,5));
      l_type 	:=(substr(pack_ree_ress_act.str_ress_act(p_string,l_cpt+1),0,1));
      
     l_ident1 := to_number(substr(pack_ree_ress_act.str_ress_act(p_string,2),2,5));
      l_type1 	:=(substr(pack_ree_ress_act.str_ress_act(p_string,2),0,1));
      l_codsg1  := to_number(pack_ree_ress_act.str_ress_act(p_string,1));
      --pack_global.recuperer_message( 1003 , '%s1', l_codsg1, NULL, p_message);  	
	BEGIN
	if l_type IS NOT NULL then
		delete from ree_ressources_activites
		where codsg = l_codsg 
		and ident=l_ident and type=l_type;
		commit;
	else
		delete from ree_ressources_activites
		where codsg = l_codsg1
		--and ident=11 and type='X';
		and ident=l_ident1 and type=l_type1;
		commit;
	end if;
	END;


      WHILE l_cpt != 0 LOOP
      	l_codsg  	:= pack_ree_ress_act.str_ress_act(p_string,l_cpt);
       	l_ident 	:= to_number(substr(pack_ree_ress_act.str_ress_act(p_string,l_cpt+1),2,5));
      	l_type 		:=(substr(pack_ree_ress_act.str_ress_act(p_string,l_cpt+1),0,1));
        l_code_activite := pack_ree_ress_act.str_ress_act(p_string,l_cpt+2);
       	l_tauxrep 	:= to_number(pack_ree_ress_act.str_ress_act(p_string,l_cpt+3));
	
	 -- Si une ligne est retournée
         IF l_codsg != '0' and l_type is not null THEN
         	INSERT INTO ree_ressources_activites (code_activite,codsg,ident,tauxrep,type)
		VALUES (l_code_activite,
			l_codsg,
			l_ident,
			l_tauxrep,
			l_type); 
		          
          l_cpt := l_cpt + 4;

         ELSE
            l_cpt :=0;
         END IF;
      END LOOP;

  -- pack_global.recuperer_message( 1003 , '%s1', l_codsg, NULL, p_message);  
  pack_global.recuperer_message( 20366 , '%s1', 'Ressources - Activités rattachées', '', p_message);
     
END insert_ressources_activites;
   
-- selection de la ligne activite a ajouter à une ressource
PROCEDURE select_ligne (p_code_activite 	IN VARCHAR2,
			p_codsg			IN VARCHAR2,
			p_code_ress		IN VARCHAR2,
   			p_lib_activite		OUT VARCHAR2,
   			p_repartition		OUT VARCHAR2
                           ) IS

   BEGIN
        	SELECT 	act.lib_activite INTO p_lib_activite
              	FROM  	ree_activites act--,ree_ressources_activites ress
              	WHERE act.code_activite = p_code_activite
              	AND act.codsg= to_number(p_codsg)
              	--AND act.codsg=ress.codsg
              	--AND act.code_activite=ress.code_activite
                --AND ress.ident = to_number(substr(p_code_ress,2,5))
              	--AND ress.type=substr(p_code_ress,0,1)
              	;
              	
      		EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);

   END select_ligne;
   
 
  
 END pack_ree_ress_act;
/
