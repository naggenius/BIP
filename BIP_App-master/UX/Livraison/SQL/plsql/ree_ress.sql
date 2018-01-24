--*******************************************************************
-- pack_ree_ress PL/SQL
-- 
-- Créé le 02/05/2005 par MMC
--
--*******************************************************************


CREATE OR REPLACE PACKAGE pack_ree_ress AS

 -- Définition curseur
	
   TYPE ress_ViewType IS RECORD (ident  ree_ressources.ident%TYPE,
   				 lib	VARCHAR2(150)
					); 
					
   TYPE ress_s_ViewType IS RECORD (codsg ree_ressources.codsg%TYPE,
              			   type ree_ressources.type%TYPE,
              			   ident VARCHAR2(6),
              			   rnom ree_ressources.rnom%TYPE,
              			   rprenom ree_ressources.rprenom%TYPE,
              			   datdep VARCHAR2(20)
              			   ,code_ress ree_ressources.ident%TYPE
              			   ,datarrivee VARCHAR2(20)
					); 
										
   TYPE ressCurType IS REF CURSOR RETURN ress_ViewType;
   TYPE ress_s_CurType IS REF CURSOR RETURN ress_s_ViewType;
   
   TYPE groupe_ListeViewType IS RECORD( ident ressource.ident%TYPE,
                                        LIBELLE VARCHAR2(500)
                                         );

   TYPE groupe_listeCurType IS REF CURSOR RETURN groupe_ListeViewType;
   
PROCEDURE ress_groupe( p_codsg         IN VARCHAR2,
                       p_userid        IN VARCHAR2,
                       p_curseur       IN OUT groupe_listeCurType
                                );

PROCEDURE ress_liste (  p_codsg 	IN VARCHAR2,
			p_global 	IN VARCHAR2,
   			p_curress 	IN OUT ress_s_CurType,
                	p_nbcurseur   	OUT INTEGER,
                        p_message     	OUT VARCHAR2
                                	);
                                	
PROCEDURE select_ress  	 (p_ident	IN  VARCHAR2,
			  p_type	IN  VARCHAR2,	
                          p_codsg       IN  VARCHAR2,
                          p_curress 	IN OUT ress_s_CurType,
                          p_nbcurseur	OUT INTEGER,
                          p_message	OUT VARCHAR2
                             		 );
                            		
PROCEDURE update_ress(          p_ident    IN  VARCHAR2,
				p_type  IN  VARCHAR2,
				p_codsg	IN VARCHAR2,
				p_rnom  IN VARCHAR2,
				p_rprenom IN VARCHAR2,
				p_datdep IN VARCHAR2,
				p_ident_fict    IN  VARCHAR2,
				p_datarrivee IN VARCHAR2,
				p_nbcurseur  OUT INTEGER,
                                p_message    OUT VARCHAR2
                             );

PROCEDURE insert_ress(p_code_ress    IN  VARCHAR2,
				p_ident_hors    IN  VARCHAR2,
				p_ident_fict    IN  VARCHAR2,
				p_choix  IN  VARCHAR2,
				p_codsg	IN VARCHAR2,
				p_rnom  IN VARCHAR2,
				p_rprenom IN VARCHAR2,
				p_datdep IN VARCHAR2,
				p_datarrivee IN VARCHAR2,
				p_nbcurseur  OUT INTEGER,
                                p_message    OUT VARCHAR2
                             );                            

PROCEDURE delete_ress ( 	p_code_ress    IN  VARCHAR2,
				p_type  IN  VARCHAR2,
				p_codsg	IN VARCHAR2,
                               	p_nbcurseur 	OUT INTEGER,
                               	p_message   	OUT VARCHAR2                       
                               	);                               	                           

PROCEDURE donnees_ress ( 	p_ident    IN  VARCHAR2,
				p_codsg    IN  VARCHAR2,
				p_choix IN VARCHAR2,
				p_rnom  OUT  VARCHAR2,
				p_rprenom  OUT  VARCHAR2,
				p_date OUT VARCHAR2,
				p_choix_retour OUT VARCHAR2,
				p_nbcurseur 	OUT INTEGER,
                               	p_message   	OUT VARCHAR2                       
                               	);    

PROCEDURE ree_ressource_initialise(p_codsg 	IN ligne_bip.codsg%TYPE,
					p_message   	OUT VARCHAR2 );     

PROCEDURE ress_fict_liste (p_codsg         IN VARCHAR2,
                           p_userid        IN VARCHAR2,
                           p_curseur       IN OUT groupe_listeCurType
                                );                                                	                           

END pack_ree_ress;
/

CREATE OR REPLACE PACKAGE BODY pack_ree_ress AS 

/* proc qui liste les ressources associées au DPG */
PROCEDURE ress_liste (p_codsg 	IN VARCHAR2,
			p_global 	IN VARCHAR2,
   			p_curress 	IN OUT ress_s_CurType,
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
      OPEN p_curress FOR SELECT
        codsg,
        type,
       	type||nvl(TO_CHAR(ident),''),
      	rnom,
      	rprenom,
      	NVL(TO_CHAR(datdep,'dd/mm/yyyy'), '          ')
      	,nvl(ident,'')
      	,NVL(TO_CHAR(datarrivee,'dd/mm/yyyy'), '          ')
	FROM ree_ressources
	WHERE codsg = TO_NUMBER(p_codsg)
	AND type <> 'S'
	ORDER BY rnom;

EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);END;
        END IF;
     END IF;

     p_message := l_msg;
  
END ress_liste;

/* proc qui retourne les données d'une ressource */   
PROCEDURE select_ress  (  p_ident	IN  VARCHAR2,
			  p_type	IN  VARCHAR2,	
                          p_codsg       IN  VARCHAR2,
                          p_curress 	IN OUT ress_s_CurType,
                          p_nbcurseur	OUT INTEGER,
                          p_message	OUT VARCHAR2
                              	) IS
l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 1
      -- Initialiser le message retour
	
      p_nbcurseur := 1;
      p_message := '';
      
      -- Attention ordre des colonnes doit correspondre a l ordre
      -- de declaration dans la table ORACLE (a cause de ROWTYPE)
      
      BEGIN
         OPEN   p_curress FOR
              SELECT 	codsg,
              		type,
              		type||to_char(ident),
              		rnom,
              		rprenom,
              		to_char(datdep,'dd/mm/yyyy')
              		,ident
              		,to_char(datarrivee,'dd/mm/yyyy')
              FROM  ree_ressources
              WHERE 
              codsg =TO_NUMBER(p_codsg)
              AND type = substr(p_ident,0,1)
              AND ident = to_number(substr(p_ident,2,5))
              ;


      EXCEPTION
	WHEN NO_DATA_FOUND THEN
		pack_global.recuperer_message( 20131, NULL, NULL, NULL, l_msg);
         	p_message := l_msg;
        WHEN OTHERS THEN
          raise_application_error( -20997, SQLERRM);

      END;                              		
END select_ress;

/* proc qui fait la maj des données d'une ressource */   
PROCEDURE update_ress(p_ident    IN  VARCHAR2,
				p_type  IN  VARCHAR2,
				p_codsg	IN VARCHAR2,
				p_rnom  IN VARCHAR2,
				p_rprenom IN VARCHAR2,
				p_datdep IN VARCHAR2,
				p_ident_fict    IN  VARCHAR2,
				p_datarrivee IN VARCHAR2,
				p_nbcurseur  OUT INTEGER,
                                p_message    OUT VARCHAR2
                              	) IS  
l_msg VARCHAR2(1024);

   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- initialiser le message retour

	p_nbcurseur := 0;
	p_message := '';

	-- On veut remplacer une ressource fictive par une ressource "normale"
	IF p_ident_fict <> '-1' THEN
		begin
			
		UPDATE ree_reestime
		SET	ident=p_ident,
		type=p_type
		WHERE codsg = TO_NUMBER(p_codsg) 
		AND type = 'X'
		AND ident=TO_NUMBER(p_ident_fict);
		
		UPDATE ree_ressources_activites
		SET	ident=p_ident,
		type=p_type
		WHERE codsg = TO_NUMBER(p_codsg) 
		AND type = 'X'
		AND ident=TO_NUMBER(p_ident_fict);
		
		DELETE FROM ree_ressources
		WHERE codsg = TO_NUMBER(p_codsg) 
		AND type = 'X'
		AND ident=TO_NUMBER(p_ident_fict);
		
		IF SQL%NOTFOUND THEN
	   	   -- 'Accès concurrent'
	 	pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         	raise_application_error( -20999, l_msg );
         	ELSE
		pack_global.recuperer_message( 21020, '%s1', p_ident, NULL, l_msg);
	   	p_message := l_msg;
		END IF;
		end;
	ELSE
		begin
		UPDATE ree_ressources
		SET	rnom=p_rnom,
		rprenom=p_rprenom,
		datdep=to_date(p_datdep,'dd/mm/yyyy')
		,datarrivee=to_date(p_datarrivee,'dd/mm/yyyy')
		WHERE codsg = TO_NUMBER(p_codsg) 
		AND type = p_type
		AND ident=TO_NUMBER(p_ident)
		;


		IF SQL%NOTFOUND THEN
	   
	   -- 'Accès concurrent'

	 	pack_global.recuperer_message( 20999, NULL, NULL, NULL, l_msg);
         	raise_application_error( -20999, l_msg );
         
      		ELSE

	   	pack_global.recuperer_message( 21013, '%s1', p_ident, NULL, l_msg);
	   	p_message := l_msg;

      	END IF;   
	end;
       END IF;                  	
END update_ress;

/* proc pour inserer une nouvelle ressource*/
PROCEDURE insert_ress (p_code_ress    IN  VARCHAR2,
				p_ident_hors    IN  VARCHAR2,
				p_ident_fict    IN  VARCHAR2,
				p_choix  IN  VARCHAR2,
				p_codsg	IN VARCHAR2,
				p_rnom  IN VARCHAR2,
				p_rprenom IN VARCHAR2,
				p_datdep IN VARCHAR2,
				p_datarrivee IN VARCHAR2,
				p_nbcurseur  OUT INTEGER,
                                p_message    OUT VARCHAR2
                              ) IS 
 
     	l_msg VARCHAR2(1024);
     	l_type VARCHAR2(1);
     	l_code_ress VARCHAR2(5);
     	
BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
IF p_choix='h' and p_ident_hors is not null then 
	l_code_ress := p_ident_hors;
ELSIF p_code_ress is not null and p_choix='g' then 
	l_code_ress := p_code_ress;
ELSIF  p_choix is null then 
	l_code_ress := p_code_ress;	
END IF      ;

IF p_choix <> 'f' or p_choix is null THEN
	begin
	select rtype into l_type
	from ressource
	where ident=l_code_ress ;
	
	EXCEPTION
	WHEN NO_DATA_FOUND THEN 
		--raise_application_error( -20997, SQLERRM);
		pack_global.recuperer_message( 21019, NULL, NULL, NULL, l_msg);
               	p_message := l_msg;
        end;       	
        BEGIN
        	
	INSERT INTO ree_ressources
	    (codsg,
	    type,
	    ident,
	    rnom,
	    rprenom,
	    datdep
		,datarrivee
 		)  
         VALUES ( 	TO_NUMBER(p_codsg),
         		l_type,
         		TO_NUMBER(l_code_ress),
         		nvl(p_rnom,'nom vide'),
         		nvl(p_rprenom,''),
         		TO_DATE(p_datdep,'dd/mm/yyyy')
         		,TO_DATE(p_datarrivee,'dd/mm/yyyy')
		);
		 
	
     EXCEPTION
      	WHEN DUP_VAL_ON_INDEX THEN
      		-- ressource déjà existante
		pack_global.recuperer_message( 21018, '%s1', l_code_ress, NULL, l_msg);
		--raise_application_error(-21018, l_msg);
               	p_message := l_msg;

        WHEN OTHERS THEN
               	raise_application_error( -20997, SQLERRM);
    	END;
	        
ELSIF  p_choix ='f'  THEN
	BEGIN
	
	select (nvl(max(ident),0) +1)  into l_code_ress
	from ree_ressources
	where codsg=TO_NUMBER(p_codsg)
	and type='X';
	
	INSERT INTO ree_ressources
	    (codsg,
	    type,
	    ident,
	    rnom,
	    rprenom,
	    datdep
		,datarrivee
 		)  
         VALUES ( 	TO_NUMBER(p_codsg),
         		'X',
         		TO_NUMBER(l_code_ress),
         		nvl(p_rnom,''),
         		nvl(p_rprenom,''),
         		TO_DATE(p_datdep,'dd/mm/yyyy')
         		,TO_DATE(p_datarrivee,'dd/mm/yyyy')
		);
	
     EXCEPTION
      	WHEN DUP_VAL_ON_INDEX THEN
      		-- ressource déjà existante
		pack_global.recuperer_message( 21018, NULL, NULL, NULL, l_msg);
               	p_message := l_msg;

        WHEN OTHERS THEN
               	raise_application_error( -20997, SQLERRM);
    END;
 END IF;
 
 pack_global.recuperer_message( 21015, '%s1', l_code_ress, NULL, l_msg);
 p_message := l_msg;
    
     
END insert_ress;

/* proc qui supprime une ressource */
PROCEDURE delete_ress ( p_code_ress    IN  VARCHAR2,
				p_type  IN  VARCHAR2,
				p_codsg	IN VARCHAR2,
                               	p_nbcurseur 	OUT INTEGER,
                               	p_message   	OUT VARCHAR2
                              ) IS


	l_msg VARCHAR2(1024);
      	referential_integrity EXCEPTION;
      	PRAGMA EXCEPTION_INIT(referential_integrity, -2292);
  l_count NUMBER; --ABN - HP PPM 61356
   BEGIN

      -- Positionner le nb de curseurs ==> 0
      -- Initialiser le message retour

      p_nbcurseur := 0;
      p_message := '';
      --ABN - HP PPM 61356 - Controle de presence d'activités pour la ressource a supprimer
      l_count := 0;
      
      BEGIN
            select count(*)
            into l_count
            from REE_RESSOURCES_ACTIVITES
            where codsg = TO_NUMBER(p_codsg)
            AND type = p_type
            AND ident=TO_NUMBER(p_code_ress);

      END;

         IF l_count <> 0 THEN
              pack_global.recuperer_message( 21291, NULL, NULL, NULL, l_msg);
              raise_application_error( -20999, l_msg );
         ELSE
  --ABN - HP PPM 61356
      BEGIN

	DELETE FROM ree_ressources
	WHERE codsg = TO_NUMBER(p_codsg)
	AND type = p_type
	AND ident=TO_NUMBER(p_code_ress)
	;

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

	   pack_global.recuperer_message( 21014, '%s1', p_code_ress, NULL, l_msg);
	   p_message := l_msg;

      END IF;
      END IF;

   END delete_ress;
   
/*lister les ressources du groupe*/
PROCEDURE ress_groupe( p_codsg         IN VARCHAR2,
                       p_userid        IN VARCHAR2,
                       p_curseur       IN OUT groupe_listeCurType
                                ) IS
l_count number(2);
BEGIN


                OPEN p_curseur FOR 
	        SELECT distinct r.ident,s.ident||' - '||r.rnom||' '||r.rprenom
		FROM ressource r,situ_ress_full s
		WHERE s.codsg = TO_NUMBER(p_codsg)
		AND s.datsitu IN ( SELECT MAX(sr.datsitu)
		                   FROM situ_ress sr
		                   WHERE sr.ident = r.ident)
		AND (s.datdep IS NULL or s.datdep>sysdate)
		AND s.ident=r.ident
		UNION
		select -1,'                ' from ressource 
		ORDER BY 1;
		

END ress_groupe ;
   
/*recupération des donnees pour un identifiant*/
PROCEDURE donnees_ress ( 	p_ident    IN  VARCHAR2,
				p_codsg    IN  VARCHAR2,
				p_choix IN VARCHAR2,
				p_rnom  OUT  VARCHAR2,
				p_rprenom  OUT  VARCHAR2,
				p_date OUT VARCHAR2,
				p_choix_retour OUT VARCHAR2,
				p_nbcurseur 	OUT INTEGER,
                               	p_message   	OUT VARCHAR2                       
                               	)IS

l_rnom VARCHAR2(50);
l_rprenom VARCHAR2(50);
l_rtype VARCHAR2(1);
l_msg		VARCHAR2(1024);
l_test		NUMBER(1);

BEGIN
	p_nbcurseur := 1;
   	p_message := '';
   	l_test := 0;
    
    if p_choix='f'  	then
    	p_rnom := '';
    	p_rprenom := '';
    	p_date := '';
    	p_choix_retour := 'f';
    	
    else
    	
      	BEGIN
      		
      	-- test de l existence de la ressource dans l outil des reestimes
      	SELECT 1 INTO l_test
      	FROM ree_ressources
      	WHERE ident=p_ident
      	AND type <> 'X'
      	AND codsg=to_number(p_codsg);
      	
      	EXCEPTION
      		WHEN NO_DATA_FOUND THEN
      	   	
      		begin
      		SELECT rnom, rprenom,to_char(s.datdep,'dd/mm/yyyy') 
			  INTO p_rnom, p_rprenom,p_date
      		FROM ressource r,situ_ress s WHERE s.ident=r.ident
      		and r.ident=p_ident
      		and s.datsitu = (select max(datsitu) from situ_ress where ident=p_ident)
      		; 
      		EXCEPTION
        	WHEN NO_DATA_FOUND THEN
        	pack_global.recuperer_message(20437, '%s1', p_ident,'ident', l_msg);
	        p_message := l_msg;
	        --raise_application_error(-20437, l_msg);
		WHEN OTHERS THEN
		-- Message d'alerte Problème inconnu
	      	raise_application_error(-20997, SQLERRM);
		end;
	END;
	
	if l_test = 1 then
		pack_global.recuperer_message(21018, NULL, NULL, NULL, l_msg);
	       p_message := l_msg;
	       --raise_application_error(-21018, l_msg);
	end if;
    end if;
                                    		
END donnees_ress; 

-- proc pour le bouton initialiser
 PROCEDURE ree_ressource_initialise(p_codsg 	IN ligne_bip.codsg%TYPE,
 					p_message   	OUT VARCHAR2 
				    ) IS
									 
    trouver NUMBER; 								   
	v_ident     situ_ress.ident%TYPE;
	v_rtype     ressource.rtype%TYPE;
	v_rnom      ressource.rnom%TYPE;
	v_rprenom   ressource.rprenom%TYPE;
	v_datsitu   DATE;
	v_datdep	DATE;	
	
	p_date		DATE;
	l_msg		VARCHAR2(1024);
	
		
	--Le curseur qui recupere la liste des ressources d'un pole
	 cursor l_ress(c_codsg NUMBER, c_date DATE) IS
	 	   SELECT sr.ident, r.rtype,r.rnom,r.rprenom,sr.datsitu,sr.datdep
		   FROM situ_ress sr, ressource r
		   WHERE sr.codsg=c_codsg
		   AND sr.datsitu=pack_situation_full.datsitu_ressource(sr.ident,c_date)
		   AND (sr.datdep is NULL OR sr.datdep>= c_date)
		   AND r.ident=sr.ident;								 
									 
 BEGIN
 
 	
	Select to_date(to_char(sysdate,'dd/mm/yyyy'),'dd/mm/yyyy')  into p_date
	from dual;
	
	p_message := '';
 
     OPEN l_ress(p_codsg,p_date);

		 LOOP


		    FETCH l_ress INTO v_ident, v_rtype, v_rnom, v_rprenom, v_datsitu, v_datdep;

	        IF l_ress%NOTFOUND THEN
	        EXIT;
	        END IF;


			    SELECT COUNT(ident) INTO trouver
					   FROM ree_ressources
					   WHERE codsg=p_codsg
					   AND ident=v_ident
					   AND type=v_rtype;
					   
				--si la ressource n'existe pas dans la table ree_ressource alors on insere la ressource
			    IF(trouver = 0) THEN
				
				
				      INSERT INTO ree_ressources(CODSG,
					  	TYPE,
					 	IDENT,
					 	RNOM,
					  	RPRENOM,
					  	DATDEP        
					  	)
					  					  
					  VALUES(
					  p_codsg,
					  v_rtype,
					  v_ident,
					  v_rnom,
					  v_rprenom,
					  v_datdep
				       );
					   
				--si la ressource existe alors on fait un update	   
				ELSE
				
				
				   UPDATE ree_ressources
				          SET RNOM=v_rnom,
					          RPRENOM=v_rprenom,
					          DATDEP=v_datdep 
						  WHERE	codsg=p_codsg
						      AND type=v_rtype
						      AND ident=v_ident;
						     
				
				END IF;		   
			
				  
	     END LOOP;


		 CLOSE l_ress;
 
 
 EXCEPTION
           WHEN OTHERS THEN 
           	-- Message d'alerte Problème inconnu
	      	raise_application_error(-20997, SQLERRM);
 
-- pack_global.recuperer_message( 21021, NULL, NULL, NULL, l_msg);
-- p_message := l_msg;

--test
pack_global.recuperer_message( 21015, '%s1', 'mmc', NULL, l_msg);
raise_application_error( -21015, l_msg ); 
 --p_message := l_msg;
  
END ree_ressource_initialise;			

/*lister les ressources fictives du groupe */
PROCEDURE ress_fict_liste( p_codsg         IN VARCHAR2,
                       	p_userid        IN VARCHAR2,
                       	p_curseur       IN OUT groupe_listeCurType
                                ) IS
l_count number(2);
BEGIN


            OPEN p_curseur FOR 
	        SELECT distinct r.ident,r.ident||' - '||r.rnom||' '||r.rprenom
		FROM ree_ressources r
		WHERE r.codsg = TO_NUMBER(p_codsg)
		AND r.type='X'
		UNION
		select -1,'           ' from ree_ressources r
		ORDER BY 1;

END ress_fict_liste ;						 
                              		

END pack_ree_ress;
/                                                          